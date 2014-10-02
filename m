From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH RESEND 2/2] target: Implement report lun data change
 unit attention.
Date: Wed, 01 Oct 2014 17:00:00 -0700
Message-ID: <1412208000.5120.20.camel@haakon3.risingtidesystems.com>
References: <1411640549-8013-1-git-send-email-saurav.kashyap@qlogic.com>
	 <1411640549-8013-3-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45019 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbaJBAAD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2014 20:00:03 -0400
In-Reply-To: <1411640549-8013-3-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com

Hi Saurav & Co,

Comments are inline below.

On Thu, 2014-09-25 at 06:22 -0400, Saurav Kashyap wrote:
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> ---
>  drivers/target/target_core_fabric_configfs.c |   28 ++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index 7de9f04..f97866e 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -42,6 +42,7 @@
>  #include "target_core_internal.h"
>  #include "target_core_alua.h"
>  #include "target_core_pr.h"
> +#include "target_core_ua.h"
>  
>  #define TF_CIT_SETUP(_name, _item_ops, _group_ops, _attrs)		\
>  static void target_fabric_setup_##_name##_cit(struct target_fabric_configfs *tf) \
> @@ -326,6 +327,8 @@ static struct config_group *target_fabric_make_mappedlun(
>  	char *buf;
>  	unsigned long mapped_lun;
>  	int ret = 0;
> +	struct se_lun *lun;
> +	int i = 0;
>  
>  	acl_ci = &group->cg_item;
>  	if (!acl_ci) {
> @@ -400,6 +403,16 @@ static struct config_group *target_fabric_make_mappedlun(
>  		goto out;
>  	}
>  	target_stat_setup_mappedlun_default_groups(lacl);
> +	spin_lock(&se_tpg->tpg_lun_lock);
> +	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> +		lun = se_tpg->tpg_lun_list[i];
> +		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
> +			continue;
> +		spin_unlock(&se_tpg->tpg_lun_lock);
> +		core_scsi3_ua_allocate(se_nacl, lun->unpacked_lun, 0x3f, 0xe);
> +		spin_lock(&se_tpg->tpg_lun_lock);
> +	}
> +	spin_unlock(&se_tpg->tpg_lun_lock);
>  

This should be walking se_nacl->device_list[] to generate UAs for the
specific NodeACL's existing MappedLUN layout (se_dev_entry->mapped_lun),
minus the se_dev_entry->mapped_lun that was added by this particular
invocation of target_fabric_make_mappedlun(). 

The above walks the TPG LUN list, but doesn't honor the specific
NodeACL's MappedLUN layout.

>  	kfree(buf);
>  	return &lacl->se_lun_group;
> @@ -419,6 +432,8 @@ static void target_fabric_drop_mappedlun(
>  	struct config_item *df_item;
>  	struct config_group *lacl_cg = NULL, *ml_stat_grp = NULL;
>  	int i;
> +	struct se_lun *lun;
> +	struct se_portal_group *se_tpg = lacl->se_lun_nacl->se_tpg;
>  
>  	ml_stat_grp = &lacl->ml_stat_grps.stat_group;
>  	for (i = 0; ml_stat_grp->default_groups[i]; i++) {
> @@ -437,6 +452,19 @@ static void target_fabric_drop_mappedlun(
>  	kfree(lacl_cg->default_groups);
>  
>  	config_item_put(item);
> +
> +	spin_lock(&se_tpg->tpg_lun_lock);
> +	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
> +		lun = se_tpg->tpg_lun_list[i];
> +		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
> +			continue;
> +		spin_unlock(&se_tpg->tpg_lun_lock);
> +		core_scsi3_ua_allocate(lacl->se_lun_nacl, lun->unpacked_lun,
> +		    0x3f, 0xe);
> +		spin_lock(&se_tpg->tpg_lun_lock);
> +	}
> +	spin_unlock(&se_tpg->tpg_lun_lock);
> +

Ditto here as well, and AFAICT there is no reason why these two can't be
made into common code

Also, this patch doesn't handle the case of demo-mode sessions where no
explicit NodeACLs + MappedLUNs layout exists in configfs.  This will
require walking the list of active sessions per endpoint, and update
individual se_node_acl->device_list[] entries accordingly..

So that said, I'm OK with merging support for generating UA's for
explicit NodeACLs + MappedLUNs first, but the demo-mode case will
require a bit more effort to implement.

Thanks,

--nab

