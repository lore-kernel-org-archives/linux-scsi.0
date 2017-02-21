From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 10/10] mpt3sas: lockless command submission for
        scsi-mq
Date: Tue, 21 Feb 2017 15:34:37 +0100
Message-ID: <20170221143437.GC27251@lst.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de> <1487680029-3701-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37724 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752571AbdBUOej (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Feb 2017 09:34:39 -0500
Content-Disposition: inline
In-Reply-To: <1487680029-3701-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On Tue, Feb 21, 2017 at 01:27:09PM +0100, Hannes Reinecke wrote:
> Enable lockless command submission for scsi-mq by moving the
> command structure into the payload for struct request.

No dependency on scsi-mq, so the changelog could use a little update.

> @@ -2345,26 +2354,22 @@ struct scsiio_tracker *
>  mpt3sas_base_get_smid_scsiio(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx,
>  	struct scsi_cmnd *scmd)
>  {
> +	struct scsiio_tracker *request = scsi_cmd_priv(scmd);
> +	unsigned int tag;
>  	u16 smid;
>  
> +	if (ioc->shost->use_blk_mq) {
> +		u32 unique_tag = blk_mq_unique_tag(scmd->request);
> +
> +		tag = blk_mq_unique_tag_to_tag(unique_tag);
> +	} else
> +		tag = scmd->request->tag;

All that unique_tag stuff is only required for SCSI LLDDs that
set nr_hw_queues > 1, which isn't the ase with this patch.

>   * @ioc: per adapter object
> @@ -2423,23 +2444,21 @@ struct scsiio_tracker *
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
>  		return;

This looks fine, but it would be good if could derive the scsiio_tracker
structure from the scsi_cmnd in as many as possible places, most notably
all the fast path calls and then just clal mpt3sas_base_clear_st directly.

> +	ioc->shost->reserved_cmds = INTERNAL_SCSIIO_CMDS_COUNT;

Why?  You're never calling the block layer to allocate a reserved
request.

> +	ioc->shost->can_queue = ioc->scsiio_depth - ioc->shost->reserved_cmds;

Just assign ioc->shost->can_queue to ioc->scsiio_depth -
INTERNAL_SCSIIO_CMDS_COUNT directly.

> +	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
> +		struct scsiio_tracker *st;
>  
> +		st = mpt3sas_get_st_from_smid(ioc, smid);
> +		if (st->cb_idx != 0xFF)
> +			ioc->pending_io_count++;
> +	}

How is this different from ioc->host->host_busy (except for maybe
the ioctl smid).

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 23e0ef1..bcc6a51 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -563,11 +563,10 @@ enum block_state {
>  	Mpi2SCSITaskManagementRequest_t *tm_request)
>  {
>  	u8 found = 0;
> -	u16 i;
> +	u16 smid;
>  	u16 handle;
>  	struct scsi_cmnd *scmd;
>  	struct MPT3SAS_DEVICE *priv_data;
> -	unsigned long flags;
>  	Mpi2SCSITaskManagementReply_t *tm_reply;
>  	u32 sz;
>  	u32 lun;
> @@ -583,11 +582,11 @@ enum block_state {
>  	lun = scsilun_to_int((struct scsi_lun *)tm_request->LUN);
>  
>  	handle = le16_to_cpu(tm_request->DevHandle);
> -	spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> -	for (i = ioc->scsiio_depth; i && !found; i--) {
> -		scmd = ioc->scsi_lookup[i - 1].scmd;
> -		if (scmd == NULL || scmd->device == NULL ||
> -		    scmd->device->hostdata == NULL)
> +	for (smid = ioc->scsiio_depth; smid && !found; smid--) {
> +		struct scsiio_tracker *st;
> +
> +		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
> +		if (!scmd)
>  			continue;
>  		if (lun != scmd->device->lun)
>  			continue;
> @@ -596,10 +595,10 @@ enum block_state {
>  			continue;
>  		if (priv_data->sas_target->handle != handle)
>  			continue;
> -		tm_request->TaskMID = cpu_to_le16(ioc->scsi_lookup[i - 1].smid);
> +		st = scsi_cmd_priv(scmd);
> +		tm_request->TaskMID = cpu_to_le16(st->smid);
>  		found = 1;
>  	}
> -	spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);

This looks like you're keeping the existing behavior, but can someone
please explain why we need to find a random used smid here?  Whatever
requests is using the smid could be completed at any point in time,
so this whole loop looks rather bogus both in the old and new version.
a

> +		if (ioc->shost->use_blk_mq)
> +			smid = 1;
> +		else
> +			smid = ioc->scsiio_depth - ioc->shost->reserved_cmds;

Huh?  Explanation, please.

> @@ -1146,22 +1101,21 @@ struct _sas_node *
>  _scsih_scsi_lookup_find_by_target(struct MPT3SAS_ADAPTER *ioc, int id,
>  	int channel)
>  {
> +	u8 found = 0;
> +	u16 smid;
>  
> +	for (smid = 1; smid  <= ioc->scsiio_depth; smid++) {
> +		struct scsi_cmnd *scmd;
> +
> +		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
> +		if (!scmd)
> +			continue;
> +		if (scmd->device->id == id &&
> +		    scmd->device->channel == channel) {
>  			found = 1;
> +			break;
>  		}
>  	}
>  	return found;
>  }

This looks ok, but I'd really like to understand what the hell
the original code is trying to do here.

>  
> @@ -1180,23 +1134,22 @@ struct _sas_node *
>  _scsih_scsi_lookup_find_by_lun(struct MPT3SAS_ADAPTER *ioc, int id,
>  	unsigned int lun, int channel)
>  {
> +	u8 found = 0;
> +	u16 smid;
>  
> +	for (smid = 1; smid <= ioc->scsiio_depth; smid++) {
> +		struct scsi_cmnd *scmd;
> +
> +		scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
> +		if (!scmd)
> +			continue;
> +		if (scmd->device->id == id &&
> +		    scmd->device->channel == channel &&
> +		    scmd->device->lun == lun) {
>  			found = 1;
> +			break;
>  		}
>  	}
>  	return found;
>  }

.. and here
