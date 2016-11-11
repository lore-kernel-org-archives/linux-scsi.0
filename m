From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] hpsa: scsi-mq support
Date: Fri, 11 Nov 2016 19:22:05 +0100
Message-ID: <39d1198d-eb49-71ed-9139-f0efd9eefd0d@suse.com>
References: <1478879194-32529-1-git-send-email-hare@suse.de>
 <20161111163532.GA14922@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:55742 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932697AbcKKSWb (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 11 Nov 2016 13:22:31 -0500
In-Reply-To: <20161111163532.GA14922@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

On 11/11/2016 05:35 PM, Christoph Hellwig wrote:
> On Fri, Nov 11, 2016 at 04:46:34PM +0100, Hannes Reinecke wrote:
>> This patch enables full scsi-mq support for the hpsa driver.
>> Due to some reports of performance regressions this patch
>> also adds a parameter 'use_blk_mq' which can be used to
>> disable multiqueue support if required.
>
> This patch looks odd to me.  The hardware does not seem to support
> multiple submission queues, which makes exposing nr_hw_queues > 1
> rather pointless given that the block layer (using blk-mq or the legacy
> path) can already steer completions to the submitting cpu.
>
Well, it's the same as with megasas and mpt3sas. Each of those have
a single MMIO register where the driver writes the address of the
command into. What exactly the hardware does in the back doesn't
really matter here; the command is in memory and the hardware can
access it as it sees fit. So from that point of view we can assume
having a submission queue to match the completion queue;
With that setup we do have a contention point on the single command 
register, but that's about it.
We still should benefit from scsi-mq, though.

> You also mention there are performance regressions, but don't talk
> about any benefits.  I also think per-driver module parameters for this
> are generally a rather bad idea.
>
Well; this is also suffering from the same performance regression I 
noticed when doing performance testing on megasas.
I'm still trying to figure out _where_ to problem actually is (it might 
be fio itself, using several submission queues in parallel thereby
defeating merging), but it might also be due to the setup I've been
testing with.
As it's inconclusive I've added this parameter.

> So what exactly are the benefits of this MQ-mode for a single submission
> queue device, and what do we need to do to get these without lying about
> the number of submission queues?
>
As I said; for a single submission queue you are correct, but I don't 
think that is the case here.
But then Don should be able to shed some light here.

Cheers,

Hannes
