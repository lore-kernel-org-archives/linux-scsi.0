From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCHv2] scsi: use 'scsi_device_from_queue()' for scsi_dh
Date: Thu, 16 Feb 2017 16:09:30 +0000
Message-ID: <1487261355.2612.1.camel@sandisk.com>
References: <1487257943-72264-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:37516 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754441AbdBPQM5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Feb 2017 11:12:57 -0500
In-Reply-To: <1487257943-72264-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <1AA5D6772F6BDC4CA46B3D43926E41E5@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "keith.busch@intel.com" <keith.busch@intel.com>, "hare@suse.com" <hare@suse.com>

On Thu, 2017-02-16 at 16:12 +0100, Hannes Reinecke wrote:
> +struct scsi_device *scsi_device_from_queue(struct request_queue *q)
> +{
> +	struct scsi_device *sdev = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	if (q->mq_ops) {
> +		if (q->mq_ops == &scsi_mq_ops)
> +			sdev = q->queuedata;
> +	} else if (q->request_fn == scsi_request_fn)
> +		sdev = q->queuedata;
> +	if (!sdev || !get_device(&sdev->sdev_gendev))
> +		sdev = NULL;
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +
> +	return sdev;
> +}

Hello Hannes,

Do we need to take the queue lock? Neither q->mq_ops nor q->request_fn are
modified after a block device has been created. q->queuedata is not modified
by any SCSI driver after it has been set. And since the caller of
scsi_device_from_queue() has to guarantee that the queue does not disappear
while this function is in progress, the queue lock does not have to be held
around the get_device() call either. Otherwise this patch looks fine to me.

Bart.
