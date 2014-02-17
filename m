From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into scsi_{host,target}_queue_ready
Date: Mon, 17 Feb 2014 10:36:20 +0100
Message-ID: <5301D814.5070100@acm.org>
References: <20140205123930.150608699@bombadil.infradead.org> <20140205124021.286457268@bombadil.infradead.org> <1391705819.22335.8.camel@dabdike> <20140210113932.GA31405@infradead.org> <20140210200934.GA4096@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:36685 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751100AbaBQJgZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Feb 2014 04:36:25 -0500
In-Reply-To: <20140210200934.GA4096@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On 02/10/14 21:09, Jens Axboe wrote:
> On Mon, Feb 10 2014, Christoph Hellwig wrote:
>>> I also think we should be getting more utility out of threading
>>> guarantees.  So, if there's only one thread active per device we don't
>>> need any device counters to be atomic.  Likewise, u32 read/write is an
>>> atomic operation, so we might be able to use sloppy counters for the
>>> target and host stuff (one per CPU that are incremented/decremented on
>>> that CPU ... this will only work using CPU locality ... completion on
>>> same CPU but that seems to be an element of a lot of stuff nowadays).
>>
>> The blk-mq code is aiming for CPU locality, but there are no hard
>> guarantees.  I'm also not sure always bouncing around the I/O submission
>> is a win, but it might be something to play around with at the block
>> layer.
>>
>> Jens, did you try something like this earlier?
> 
> Nope, I've always thought that if you needed to bounce submission
> around, you would already have lost. [ ... ]

This comment makes a lot of sense to me. The approach that has been
taken in the scsi-mq patches that have been posted on February 5 is to
associate one blk-mq device with each LUN. That blk-mq device has one
hctx with queue depth shost->cmd_per_lun. So if there are multiple LUNs
per SCSI host the combined hctx queue depth of its LUNs can exceed
shost->can_queue. I'm not sure whether it's possible to prevent this
without modifying the block layer. How about modifying the block layer
such that a single hctx can be shared by multiple block devices and
adding cmd_per_lun support in the block layer ? I think that would allow
to prevent having to bounce submission in the SCSI mid-layer.

Thanks,

Bart.

