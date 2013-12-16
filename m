From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 10/32] target: Change sep_tg_pt_ref_cnt to use kref
Date: Mon, 16 Dec 2013 13:11:39 -0800
Message-ID: <1387228299.20247.219.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-11-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54269 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3LPVKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 16:10:46 -0500
In-Reply-To: <1386979160-6928-11-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> Use the kernel's std kref for refcounting.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_device.c   |   12 ++----------
>  drivers/target/target_core_internal.h |   10 ++++++++++
>  drivers/target/target_core_pr.c       |   12 ++++--------
>  include/target/target_core_base.h     |    2 +-
>  4 files changed, 17 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 3350467..1954b0f 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -472,6 +472,7 @@ static struct se_port *core_alloc_port(struct se_device *dev)
>  	atomic_set(&port->sep_tg_pt_secondary_offline, 0);
>  	spin_lock_init(&port->sep_alua_lock);
>  	mutex_init(&port->sep_tg_pt_md_mutex);
> +	kref_init(&port->refcount);
>  
>  	spin_lock(&dev->se_port_lock);
>  	if (dev->dev_port_count == 0x0000ffff) {
> @@ -555,20 +556,11 @@ static void core_export_port(
>  static void core_release_port(struct se_device *dev, struct se_port *port)
>  	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
>  {
> -	/*
> -	 * Wait for any port reference for PR ALL_TG_PT=1 operation
> -	 * to complete in __core_scsi3_alloc_registration()
> -	 */
> -	spin_unlock(&dev->se_port_lock);
> -	if (atomic_read(&port->sep_tg_pt_ref_cnt))
> -		cpu_relax();
> -	spin_lock(&dev->se_port_lock);
> -
>  	core_alua_free_tg_pt_gp_mem(port);
>  
>  	list_del(&port->sep_node);
>  	dev->dev_port_count--;
> -	kfree(port);
> +	put_port(port);
>  }
>  

Same problem yet again.  It's not safe to release the se_port from it's
tg_pt_gp_mem association, while there are active references from other
process contexts.

Also the same issue with the configfs child / parent reference here,
where returning (instead of waiting for references to drop) introduces a
whole new host of reference counting issues.

NAK.

--nab

