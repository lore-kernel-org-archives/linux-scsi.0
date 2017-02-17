From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] scsi: use 'scsi_device_from_queue()' for scsi_dh
Date: Fri, 17 Feb 2017 08:19:29 +0100
Message-ID: <e9492098-b5d8-54b7-4748-c2de99059439@suse.de>
References: <1487257943-72264-1-git-send-email-hare@suse.de>
 <1487261355.2612.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58481 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755926AbdBQHTg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Feb 2017 02:19:36 -0500
In-Reply-To: <1487261355.2612.1.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "hch@lst.de" <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "keith.busch@intel.com" <keith.busch@intel.com>, "hare@suse.com" <hare@suse.com>

On 02/16/2017 05:09 PM, Bart Van Assche wrote:
> On Thu, 2017-02-16 at 16:12 +0100, Hannes Reinecke wrote:
>> +struct scsi_device *scsi_device_from_queue(struct request_queue *q)
>> +{
>> +	struct scsi_device *sdev = NULL;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(q->queue_lock, flags);
>> +	if (q->mq_ops) {
>> +		if (q->mq_ops == &scsi_mq_ops)
>> +			sdev = q->queuedata;
>> +	} else if (q->request_fn == scsi_request_fn)
>> +		sdev = q->queuedata;
>> +	if (!sdev || !get_device(&sdev->sdev_gendev))
>> +		sdev = NULL;
>> +	spin_unlock_irqrestore(q->queue_lock, flags);
>> +
>> +	return sdev;
>> +}
> 
> Hello Hannes,
> 
> Do we need to take the queue lock? Neither q->mq_ops nor q->request_fn are
> modified after a block device has been created. q->queuedata is not modified
> by any SCSI driver after it has been set. And since the caller of
> scsi_device_from_queue() has to guarantee that the queue does not disappear
> while this function is in progress, the queue lock does not have to be held
> around the get_device() call either. Otherwise this patch looks fine to me.
> 
Well, we did for the original code path, so I assumed that it'd be
prudent to do so.
And it's hardly time-critical anyway.
But yes, I guess we could do without the lock.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
