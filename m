From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 23/32] target: Add lun->lun_tpg pointer
Date: Mon, 16 Dec 2013 13:45:35 -0800
Message-ID: <1387230335.20247.243.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-24-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46564 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3LPVom (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 16:44:42 -0500
In-Reply-To: <1386979160-6928-24-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:59 -0800, Andy Grover wrote:
> Although the port also has a tpg pointer, if there's no port to link
> (lun->lun_sep is NULL) then we can't get to it. So we need one in se_lun.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_tpg.c  |    2 ++
>  include/target/target_core_base.h |    1 +
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 

Given the other NAKs, I don't believe this patch is necessary.

--nab

> diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
> index 6b4b0e6..c63f6cd 100644
> --- a/drivers/target/target_core_tpg.c
> +++ b/drivers/target/target_core_tpg.c
> @@ -614,6 +614,7 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
>  	INIT_LIST_HEAD(&lun->lun_acl_list);
>  	spin_lock_init(&lun->lun_acl_lock);
>  	spin_lock_init(&lun->lun_sep_lock);
> +	lun->lun_tpg = se_tpg;
>  
>  	return core_tpg_add_lun(se_tpg, lun, lun_access, dev);
>  }
> @@ -739,6 +740,7 @@ struct se_lun *core_tpg_alloc_lun(
>  	spin_lock_init(&lun->lun_acl_lock);
>  	spin_lock_init(&lun->lun_sep_lock);
>  	kref_init(&lun->refcount);
> +	lun->lun_tpg = tpg;
>  
>  	spin_lock(&tpg->tpg_lun_lock);
>  	if (!core_insert_lun(tpg, lun)) {
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 6d67c31..e4d5119 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -639,6 +639,7 @@ struct se_lun {
>  	struct list_head	lun_acl_list;
>  	struct se_device	*lun_se_dev;
>  	struct se_port		*lun_sep;
> +	struct se_portal_group	*lun_tpg;
>  	struct config_group	lun_group;
>  	struct se_port_stat_grps port_stat_grps;
>  	struct kref		refcount;


