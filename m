From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] hpsa: scsi-mq support
Date: Sat, 12 Nov 2016 11:30:25 -0700
Message-ID: <ab5aaa83-78ad-c50e-8a07-a156b0e5d84e@kernel.dk>
References: <1478879194-32529-1-git-send-email-hare@suse.de>
 <20161111163532.GA14922@infradead.org>
 <39d1198d-eb49-71ed-9139-f0efd9eefd0d@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:34371 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966447AbcKLShe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2016 13:37:34 -0500
Received: by mail-pf0-f181.google.com with SMTP id c4so7934706pfb.1
        for <linux-scsi@vger.kernel.org>; Sat, 12 Nov 2016 10:37:34 -0800 (PST)
In-Reply-To: <39d1198d-eb49-71ed-9139-f0efd9eefd0d@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org

On 11/11/2016 11:22 AM, Hannes Reinecke wrote:
> On 11/11/2016 05:35 PM, Christoph Hellwig wrote:
>> On Fri, Nov 11, 2016 at 04:46:34PM +0100, Hannes Reinecke wrote:
>>> This patch enables full scsi-mq support for the hpsa driver.
>>> Due to some reports of performance regressions this patch
>>> also adds a parameter 'use_blk_mq' which can be used to
>>> disable multiqueue support if required.
>>
>> This patch looks odd to me.  The hardware does not seem to support
>> multiple submission queues, which makes exposing nr_hw_queues > 1
>> rather pointless given that the block layer (using blk-mq or the legacy
>> path) can already steer completions to the submitting cpu.
>>
> Well, it's the same as with megasas and mpt3sas. Each of those have
> a single MMIO register where the driver writes the address of the
> command into. What exactly the hardware does in the back doesn't
> really matter here; the command is in memory and the hardware can
> access it as it sees fit. So from that point of view we can assume
> having a submission queue to match the completion queue;
> With that setup we do have a contention point on the single command
> register, but that's about it.

That's just wrong. We can have multiple completion queues without having
multiple submission queues. And for that to work ideally, you tell
blk/scsi-mq that you have 1 queue, since that is what you have. You
don't get great submission side scaling, but we can't pull that stuff
out of thin air. How you interface to the hardware DOES matter, it's the
whole point of multiple submission queues. Trying to make up some
imaginary 1:1 mapping between submission and completion queues is
nonsensical, when it doesn't exist.

> We still should benefit from scsi-mq, though.

Sure, but with 1 submission queue.

-- 
Jens Axboe

