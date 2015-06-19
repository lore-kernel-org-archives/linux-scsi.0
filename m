From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/6] target: Send UA on ALUA target port group change
Date: Fri, 19 Jun 2015 15:05:19 +0200
Message-ID: <20150619130519.GA7783@lst.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de> <1434009689-112909-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:60723 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbbFSNFV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 09:05:21 -0400
Content-Disposition: inline
In-Reply-To: <1434009689-112909-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -1880,12 +1880,19 @@ static void core_alua_put_tg_pt_gp_from_name(
>  static void __target_attach_tg_pt_gp(struct se_lun *lun,
>  		struct t10_alua_tg_pt_gp *tg_pt_gp)
>  {
> +	struct se_dev_entry *se_deve;
> +
>  	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
>  
>  	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
>  	lun->lun_tg_pt_gp = tg_pt_gp;
>  	list_add_tail(&lun->lun_tg_pt_gp_link, &tg_pt_gp->tg_pt_gp_lun_list);
>  	tg_pt_gp->tg_pt_gp_members++;
> +	spin_lock_bh(&lun->lun_deve_lock);
> +	list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link)
> +		core_scsi3_ua_allocate(se_deve, 0x3f,
> +				       ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
> +	spin_unlock_bh(&lun->lun_deve_lock);
>  	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);

Taking a _bh lock inside a regular spinlock is completely broken.

Fortunately I don't think lun_deve_lock needs to disable bottom halves,
but this needs to be fixed first.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
