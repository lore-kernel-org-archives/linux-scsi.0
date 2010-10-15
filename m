From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: block: eliminate potential for infinite loop in  blkdev_issue_discard
Date: Fri, 15 Oct 2010 13:05:48 +0200
Message-ID: <4CB8358C.8060405@fusionio.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com> <1285605664-27027-3-git-send-email-martin.petersen@oracle.com> <20100927181321.GC14180@redhat.com> <20101014213744.GA24959@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37783 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755603Ab0JOLFs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 07:05:48 -0400
In-Reply-To: <20101014213744.GA24959@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-10-14 23:37, Mike Snitzer wrote:
> On Mon, Sep 27 2010 at  2:13pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> Due to the recently identified overflow in read_capacity_16() it was
>> possible for max_discard_sectors to be zero but still have discards
>> enabled on the associated device's queue.
>>
>> Eliminate the possibility for blkdev_issue_discard to infinitely loop.
>>
>> Interestingly this issue wasn't identified until a device, whose
>> discard_granularity was 0 due to read_capacity_16 overflow, was consumed
>> by blk_stack_limits() to construct limits for a higher-level DM
>> multipath device.  The multipath device's resulting limits never had the
>> discard limits stacked because blk_stack_limits() will only do so if
>> the bottom device's discard_granularity != 0.  This resulted in the
>> multipath device's limits.max_discard_sectors being 0.
> 
> Hi Jens,
> 
> This patch would only serve as a future safety-net now that the
> elimination of the overflow in read_capacity_16() has been staged for
> 2.6.37.  Defensive programming and all...
> 
> What do you (and others) think about this patch?

Agree, may as well play it safe(r).

-- 
Jens Axboe

