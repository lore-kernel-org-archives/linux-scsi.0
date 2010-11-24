From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/8] target: simplify subsystem registration and lookup
Date: Tue, 23 Nov 2010 18:33:25 -0800
Message-ID: <1290566005.30138.171.camel@haakon2.linux-iscsi.org>
References: <20101123223053.574330460@bombadil.infradead.org>
	 <20101123223110.413122129@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53392 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab0KXCix (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 21:38:53 -0500
In-Reply-To: <20101123223110.413122129@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Tue, 2010-11-23 at 17:30 -0500, Christoph Hellwig wrote:
> plain text document attachment (lio-move-subsystem-registration)
> Move the subsystem registration and lookup into target_core_hba.c, and
> make the list of subsystems local to the file.  Get rid of the sub_api_hba_cnt
> field and instead to proper reference counting of the module inside the
> subsystem_mutex to make it non-racy vs module removal.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I think this looks good with a small NULL pointer deference fix
mentioned below..

> 
> Index: lio-core/drivers/target/target_core_hba.c
> ===================================================================
> --- lio-core.orig/drivers/target/target_core_hba.c	2010-11-23 22:36:42.000000000 +0100
> +++ lio-core/drivers/target/target_core_hba.c	2010-11-23 22:43:18.977254087 +0100
> @@ -44,10 +43,63 @@
>  
>  #include "target_core_hba.h"
>  
> +static LIST_HEAD(subsystem_list);
> +static DEFINE_MUTEX(subsystem_mutex);
> +
> +int transport_subsystem_register(struct se_subsystem_api *sub_api)
> +{
> +	struct se_subsystem_api *s;
> +
> +	INIT_LIST_HEAD(&sub_api->sub_api_list);
> +
> +	mutex_lock(&subsystem_mutex);
> +	list_for_each_entry(s, &subsystem_list, sub_api_list) {
> +		if (!(strcmp(s->name, sub_api->name))) {
> +			printk(KERN_ERR "%p is already registered with"
> +				" duplicate name %s, unable to process"
> +				" request\n", s, s->name);
> +			mutex_unlock(&subsystem_mutex);
> +			return -EEXIST;
> +		}
> +	}
> +	list_add_tail(&sub_api->sub_api_list, &subsystem_list);
> +	mutex_unlock(&subsystem_mutex);
> +
> +	printk(KERN_INFO "TCM: Registered subsystem plugin: %s struct module:"
> +			" %p\n", sub_api->name, sub_api->owner);
> +	return 0;
> +}
> +EXPORT_SYMBOL(transport_subsystem_register);
> +
> +void transport_subsystem_release(struct se_subsystem_api *sub_api)
> +{
> +	mutex_lock(&subsystem_mutex);
> +	list_del(&sub_api->sub_api_list);
> +	mutex_unlock(&subsystem_mutex);
> +}
> +EXPORT_SYMBOL(transport_subsystem_release);
> +
> +static struct se_subsystem_api *core_get_backend(const char *sub_name)
> +{
> +	struct se_subsystem_api *s;
> +
> +	mutex_lock(&subsystem_mutex);
> +	list_for_each_entry(s, &subsystem_list, sub_api_list) {
> +		if (!strcmp(s->name, sub_name))
> +			goto found;
> +	}
> +	mutex_unlock(&subsystem_mutex);
> +	return NULL;
> +found:
> +	if (s->owner && !try_module_get(s->owner))
> +		s = NULL;
> +	mutex_unlock(&subsystem_mutex);
> +	return s;
> +}
> +
>  struct se_hba *
>  core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
>  {
> -	struct se_subsystem_api *t;
>  	struct se_hba *hba;
>  	int ret = 0;
>  
> @@ -68,30 +120,13 @@ core_alloc_hba(const char *plugin_name,
>  	atomic_set(&hba->max_queue_depth, 0);
>  	atomic_set(&hba->left_queue_depth, 0);
>  
> -	t = transport_core_get_sub_by_name(plugin_name);
> -	if (!t) {
> +	hba->transport = core_get_backend(plugin_name);
> +	if (!hba->transport) {
>  		ret = -EINVAL;
>  		goto out_free_hba;
>  	}
>  
> -	hba->transport = t;
> -
> -	/*
> -	 * Get TCM subsystem api struct module reference to struct se_hba
> -	 */
> -	if (t->owner) {
> -		/*
> -		 * Grab a struct module reference count for subsystem plugin
> -		 */
> -		if (!try_module_get(t->owner)) {
> -			printk(KERN_ERR "try_module_get() failed for %s\n",
> -				t->owner->name);
> -			ret = -EINVAL;
> -			goto out_put_subsystem;
> -		}
> -	}
> -
> -	ret = t->attach_hba(hba, plugin_dep_id);
> +	ret = hba->transport->attach_hba(hba, plugin_dep_id);
>  	if (ret < 0)
>  		goto out_module_put;
>  
> @@ -106,11 +141,9 @@ core_alloc_hba(const char *plugin_name,
>  	return hba;
>  
>  out_module_put:
> -	if (t->owner)
> -		module_put(t->owner);
> -out_put_subsystem:
> +	if (hba->transport->owner)
> +		module_put(hba->transport->owner);
>  	hba->transport = NULL;
> -	transport_core_put_sub(t);
>  out_free_hba:
>  	kfree(hba);
>  	return ERR_PTR(ret);
> @@ -134,11 +167,6 @@ core_delete_hba(struct se_hba *hba)
>  	spin_unlock(&hba->device_lock);
>  
>  	hba->transport->detach_hba(hba);
> -	if (hba->transport->owner)
> -		module_put(hba->transport->owner);
> -
> -	if (!(hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
> -		transport_core_put_sub(hba->transport);
>  
>  	spin_lock(&se_global->hba_lock);
>  	list_del(&hba->hba_list);
> @@ -149,6 +177,8 @@ core_delete_hba(struct se_hba *hba)
>  	printk(KERN_INFO "CORE_HBA[%d] - Detached HBA from Generic Target"
>  			" Core\n", hba->hba_id);
>  
> +	if (hba->transport->owner)
> +		module_put(hba->transport->owner);
>  	kfree(hba);
>  	return 0;
>  }

Fixing a NULL pointer deference here because of the:

	 hba->transport = NULL;

assignment above printk() in the section above (and out of view for the
patch) in core_delete_hba()

Committed as 276bb848bf with the following incremental fix:

diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index f600f87..4bbe820 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -173,13 +173,13 @@ core_delete_hba(struct se_hba *hba)
        list_del(&hba->hba_list);
        spin_unlock(&se_global->hba_lock);
 
-       hba->transport = NULL;
-
        printk(KERN_INFO "CORE_HBA[%d] - Detached HBA from Generic Target"
                        " Core\n", hba->hba_id);
 
        if (hba->transport->owner)
                module_put(hba->transport->owner);
+
+       hba->transport = NULL;
        kfree(hba);
        return 0;
 }


