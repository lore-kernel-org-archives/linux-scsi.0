From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Wed, 29 Sep 2010 11:08:55 +0900
Message-ID: <1285726135.3092.9.camel@mulgrave.site>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com>
	 <1285668896-6356-2-git-send-email-willy@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36250 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab0I2CJF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 22:09:05 -0400
In-Reply-To: <1285668896-6356-2-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, sarah.a.sharp@linux.intel.com, Matthew Wilcox <matthew.r.wilcox@intel.com>

On Tue, 2010-09-28 at 06:14 -0400, Matthew Wilcox wrote:
> +static int uas_queuecommand(struct scsi_cmnd *cmnd,
> +					void (*done)(struct scsi_cmnd *))
> +{
> +	struct scsi_device *sdev = cmnd->device;
> +	struct uas_dev_info *devinfo = sdev->hostdata;
> +	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
> +	int err;
> +
> +	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
> +
> +	if (!cmdinfo->sense_urb && sdev->current_cmnd)
> +		return SCSI_MLQUEUE_DEVICE_BUSY;
> +
> +	if (blk_rq_tagged(cmnd->request)) {
> +		cmdinfo->stream = cmnd->request->tag + 1;
> +	} else {
> +		sdev->current_cmnd = cmnd;
> +		cmdinfo->stream = 1;
> +	}
> +
> +	cmnd->scsi_done = done;
> +
> +	cmdinfo->state = ALLOC_SENSE_URB | SUBMIT_SENSE_URB |
> +			ALLOC_CMD_URB | SUBMIT_CMD_URB;
> +
> +	switch (cmnd->sc_data_direction) {
> +	case DMA_FROM_DEVICE:
> +		cmdinfo->state |= ALLOC_DATA_IN_URB | SUBMIT_DATA_IN_URB;
> +		break;
> +	case DMA_BIDIRECTIONAL:
> +		cmdinfo->state |= ALLOC_DATA_IN_URB | SUBMIT_DATA_IN_URB;
> +	case DMA_TO_DEVICE:
> +		cmdinfo->state |= ALLOC_DATA_OUT_URB | SUBMIT_DATA_OUT_URB;
> +	case DMA_NONE:
> +		break;
> +	}
> +
> +	if (!devinfo->use_streams) {
> +		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
> +		cmdinfo->stream = 0;
> +	}
> +
> +	err = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
> +	if (err) {
> +		/* If we did nothing, give up now */
> +		if (cmdinfo->state & SUBMIT_SENSE_URB) {
> +			usb_free_urb(cmdinfo->sense_urb);
> +			return SCSI_MLQUEUE_DEVICE_BUSY;
> +		}
> +		spin_lock(&uas_work_lock);
> +		list_add_tail(&cmdinfo->list, &uas_work_list);
> +		spin_unlock(&uas_work_lock);
> +		schedule_work(&uas_work);

So, as I read this, you defer to a workqueue if allocation fails?  You
can't do that in all cases because the system will lock up if we do this
on a dirty page clearing path.  In order to avoid this lockup, you have
to guarantee at least some forward progress.  That usually (for SCSI)
means that we guarantee at least one command can be issued per device,
so we use mempools to guarantee this single free command.

James

> +	}
> +
> +	return 0;
> +}
> +

