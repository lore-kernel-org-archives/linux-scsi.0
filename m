From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh: only attach to SCSI devices
Date: Thu, 16 Feb 2017 15:38:47 +0100
Message-ID: <97978361-d948-858c-c45a-f21bab099b22@suse.de>
References: <1487230394-84552-1-git-send-email-hare@suse.de>
 <1487255419.2973.1.camel@sandisk.com> <20170216143817.GA32302@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34338 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754231AbdBPOit (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 09:38:49 -0500
In-Reply-To: <20170216143817.GA32302@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "keith.busch@inter.com" <keith.busch@inter.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>

On 02/16/2017 03:38 PM, hch@lst.de wrote:
> On Thu, Feb 16, 2017 at 02:30:34PM +0000, Bart Van Assche wrote:
>>>  	sdev = q->queuedata;
>>> -	if (!sdev || !get_device(&sdev->sdev_gendev))
>>> +	if (!sdev ||
>>> +	    !scsi_is_sdev_device(&sdev->sdev_gendev) ||
>>> +	    !get_device(&sdev->sdev_gendev))
>>>  		sdev = NULL;
>>>  	spin_unlock_irqrestore(q->queue_lock, flags);
>>
>> Hello Hannes,
>>
>> Sorry but this approach looks wrong to me. A block driver can store any data
>> in .queuedata, even data that would cause the scsi_is_sdev_device() function
>> to crash.
> 
> Yes, I fear you're right.  I guess we need to call into the scsi_dh_*
> functions through an indirection mediated by the block layer.
> 
Okay, will be tooling it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
