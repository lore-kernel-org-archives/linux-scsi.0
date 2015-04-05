From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/7] mpt2sas: store scsi io tracker data in the scsi
	command / request
Date: Sun, 5 Apr 2015 18:03:59 +0200
Message-ID: <20150405160359.GD28173@lst.de>
References: <1428076703-31014-1-git-send-email-axboe@fb.com> <1428076703-31014-7-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45938 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbbDEQEC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Apr 2015 12:04:02 -0400
Content-Disposition: inline
In-Reply-To: <1428076703-31014-7-git-send-email-axboe@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de

On Fri, Apr 03, 2015 at 09:58:22AM -0600, Jens Axboe wrote:
> +struct scsiio_tracker *
> +mpt2sas_get_st_from_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> +{
> +	if (shost_use_blk_mq(ioc->shost)) {
> +		struct scsi_cmnd *scmd;
> +
> +		scmd = scsi_mq_find_tag(ioc->shost, smid - 1);
> +		if (!scmd)
> +			return NULL;
> +		return scsi_mq_scmd_to_pdu(scmd);
> +	} else
> +		return &ioc->scsi_lookup[smid - 1];
> +}

The mq case will also work for the !mq case when you call
scsi_host_find_tag and scsi_cmd_priv.   In general all the mq-specific
codepathes you add should become the default and only one, even if this
requires a lit bit of additional core work.

> @@ -1724,6 +1739,18 @@ mpt2sas_base_get_smid_scsiio(struct MPT2SAS_ADAPTER *ioc, u8 cb_idx,
>  	struct scsiio_tracker *request;
>  	u16 smid;
>  
> +	if (shost_use_blk_mq(ioc->shost)) {
> +		/*
> +		 * If we don't have a SCSI command associated with this smid,
> +		 * bump it to high-prio
> +		 */
> +		if (!scmd)
> +			return mpt2sas_base_get_smid_hpr(ioc, cb_idx);

Seems like _ctl_do_mpt_command should be changed to just
call mpt2sas_base_get_smid_hpr unconditionally instead of adding this
hack  Preferably as a standalone preparatory patch.


>  	unsigned long flags;
>  	int i;
> -	struct chain_tracker *chain_req, *next;
> +
> +	if (shost_use_blk_mq(ioc->shost) && smid < ioc->hi_priority_smid) {
> +		struct scsiio_tracker *st;
> +
> +		st = mpt2sas_get_st_from_smid(ioc, smid);
> +		if (!st)
> +			return;
> +
> +		st->direct_io = 0;
> +
> +		if (!list_empty(&st->chain_list)) {
> +			spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
> +			_dechain_st(ioc, st);
> +			spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> +		}

This whole chain list thing looks bonkers to me.  We always allocated
a fixed multiple of the queue depth in ->chain_lookup, but then do this
required list manipulation at least once per I/O submission and completion.

Seems like we should instead add an array of (cpu address, dma address)
tuples to the scsiio_tracker and avoid all the chain_lookup / chain_list
lookups entirely.

> +			if (shost_use_blk_mq(ioc->shost)) {
> +				scmd = scsi_mq_find_tag(ioc->shost,  i);
> +				if (scsi_mq_scmd_started(scmd))
> +					pending++;

Ok, I guess we should move the request_started check into the _find_tag
helpers, as tags that aren't started aren't something that driver
should ever lookup.

> +static bool
> +_scmd_match(struct scsi_cmnd *scmd, u16 handle, u32 lun)
> +{
> +	struct MPT2SAS_DEVICE *priv_data;
> +
> +	if (scmd == NULL || scmd->device == NULL ||
> +	    scmd->device->hostdata == NULL)
> +		return false;

If the queue is started this can't ever happen.

> +	if (lun != scmd->device->lun)
> +		return false;

If you pass in a specific scsi_device and thus request_queue  this
can't happen.

> +static u16
> +_ctl_find_smid(struct MPT2SAS_ADAPTER *ioc, u16 handle, u32 lun)
> +{
> +	if (shost_use_blk_mq(ioc->shost))
> +		return _ctl_find_smid_mq(ioc, handle, lun);
> +	else
> +		return _ctl_find_smid_legacy(ioc, handle, lun);
> +}

The caller of this looks entirely broken.  It's a driver specific API
to submit task management commands, duplicating the mid level code,
and it doesn't even allow which task to target.  I think we should
just return a error when invoking MPI2_FUNCTION_SCSI_TASK_MGMT instead
of digging us an even deeper grave here.  If someone complains we'll
have to find a way to redirect it to the generic EH ioctls.
