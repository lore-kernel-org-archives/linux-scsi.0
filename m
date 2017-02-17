From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 09/11] mpt3sas: lockless command submission for
        scsi-mq
Date: Fri, 17 Feb 2017 09:54:10 +0100
Message-ID: <20170217085410.GD18443@lst.de>
References: <1487319790-97340-1-git-send-email-hare@suse.de> <1487319790-97340-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41206 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751646AbdBQIyM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 03:54:12 -0500
Content-Disposition: inline
In-Reply-To: <1487319790-97340-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Fri, Feb 17, 2017 at 09:23:08AM +0100, Hannes Reinecke wrote:
> Enable lockless command submission for scsi-mq by moving the
> command structure into the payload for struct request.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c      | 123 ++++-----
>  drivers/scsi/mpt3sas/mpt3sas_base.h      |  13 +-
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  85 ++++--
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 460 ++++++++++++++-----------------
>  drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  20 +-
>  5 files changed, 330 insertions(+), 371 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index dec86c4..e9470a3 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -865,9 +865,17 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
>  struct scsiio_tracker *
>  mpt3sas_get_st_from_smid(struct MPT3SAS_ADAPTER *ioc, u16 smid)
>  {
> +	u32 unique_tag;
> +	struct scsi_cmnd *cmd;
> +
>  	WARN_ON(!smid);
>  	WARN_ON(smid >= ioc->hi_priority_smid);
> -	return &ioc->scsi_lookup[smid - 1];
> +	unique_tag = smid - 1;
> +	cmd = scsi_host_find_tag(ioc->shost, unique_tag);
> +	if (cmd)
> +		return scsi_cmd_priv(cmd);
> +
> +	return NULL;
>  }
>  
>  /**
> @@ -2343,34 +2351,23 @@ struct scsiio_tracker *
>  mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
>  	struct scsi_cmnd *scmd)
>  {
> -	unsigned long flags;
>  	struct scsiio_tracker *request;
>  	u16 smid;
>  
> -	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> -	if (list_empty(&ioc->free_list)) {
> -		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> -		pr_err(MPT3SAS_FMT "%s: smid not available\n",
> -		    ioc->name, __func__);
> -		return 0;
> -	}
> -
>  	if (!scmd) {
> -		/* ioctl command, always use the first slot */
> -		request = ioc->lookup[0];
> -		request->scmd = NULL;
> +		smid = 1;
> +		request = mpt3sas_get_st_from_smid(ioc, smid);

How is this going to work?  mpt3sas_get_st_from_smid fails if we
don't find a block layer tag derived from smid?

>  /**
>   * mpt3sas_base_free_smid - put smid back on free_list
>   * @ioc: per adapter object
> @@ -2428,22 +2441,21 @@ struct scsiio_tracker *
>  	unsigned long flags;
>  	int i;
>  
>  	if (smid < ioc->hi_priority_smid) {
> +		struct scsiio_tracker *st;
>  
> +		st = mpt3sas_get_st_from_smid(ioc, smid);
> +		if (WARN_ON(!st)) {
> +			_base_recovery_check(ioc);
> +			return;
> +		}
> +		mpt3sas_base_clear_st(ioc, st);
>  		_base_recovery_check(ioc);

		st = mpt3sas_get_st_from_smid(ioc, smid);
		if (!WARN_ON_ONCE(!st))
			mpt3sas_base_clear_st(ioc, st);
		_base_recovery_check(ioc);
		return;
		
		
>  	/* pending command count */
> -	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> -	for (i = 0; i < ioc->scsiio_depth; i++)
> -		if (ioc->scsi_lookup[i].cb_idx != 0xFF)
> -			ioc->pending_io_count++;
> -	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> +	blk_mq_tagset_busy_iter(&ioc->shost->tag_set,
> +				_count_pending, ioc);

You can't rely on blk-mq being used, and we'd really want to avoid
layering violations like this anyway.
