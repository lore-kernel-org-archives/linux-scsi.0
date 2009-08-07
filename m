From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/3] block: add blk-iopoll, a NAPI like approach for	block
 devices
Date: Fri, 07 Aug 2009 04:38:34 -0400
Message-ID: <4A7BE80A.6080808@garzik.org>
References: <1249588685-4662-1-git-send-email-jens.axboe@oracle.com> <1249588685-4662-2-git-send-email-jens.axboe@oracle.com> <20090806223257.0c33cf15@lxorguk.ukuu.org.uk> <20090807063745.GQ12579@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:44816 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757090AbZHGIio (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Aug 2009 04:38:44 -0400
In-Reply-To: <20090807063745.GQ12579@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com

Jens Axboe wrote:
> On Thu, Aug 06 2009, Alan Cox wrote:
>>> doing the command completion when the irq occurs, schedule a dedicated
>>> softirq in the hopes that we will complete more IO when the iopoll
>>> handler is invoked. Devices have a budget of commands assigned, and will
>>> stay in polled mode as long as they continue to consume their budget
>>> from the iopoll softirq handler. If they do not, the device is set back
>>> to interrupt completion mode.
>> This seems a little odd for pure ATA except for NCQ commands. Normal ATA
>> is notoriously completion/reissue latency sensitive [to the point I
>> suspect we should be dequeuing 2 commands from SCSI and loading the next
>> in the completion handler as soon as we recover the result task file and
>> see no error rather than going up and down the stack)
> 
> Yes certainly, it's only for devices that do queuing. If they don't,
> then we will always have just the one command to complete. So not much
> to poll! As to pre-prep for extra latency intensive devices, have you
> tried experimenting with just pretending that non-ncq devices in libata
> have a queue depth of 2? That should ensure that the first command
> available upon completion of the existing command is already prepped.
> Not sure how much time that would save, I would hope that our prep phase
> isn't too slow to begin with (or that would be the place to fix :-)
> 
>> What do the numbers look like ?
> 
> On a slow box (with many cores), the benefits are quite huge:
> 
> 
> blocksize       blk-iopoll      IOPS    IRQ/sec         Commands/IRQ
> --------------------------------------------------------------------
> 512b            0               25168   ~19500          1,3
> 512b            1               30355     ~750          40
> 4096b           0               25612   ~21500          1,2
> 4096b           1               30231    ~1200          25
> 
> I suspect there's some cache interaction going on here too, but the
> numbers do look very good. On a faster box (and different architecture),
> on a test that does 50k IOPS, they perform identically but the iopoll
> approach uses less CPU. The interrupt rate drops from 55k ints/sec to
> 39-40k ints/sec for that case.

It's easy to move work from one place to another, so I would definitely 
expect that IRQ/sec drops...  but these are the more relevant numbers, IMO:

* CPU usage before/after
* latency before/after

Also, and even for storage where command queueing is _possible_, there 
is a problem case we saw with NAPI:  sometimes the combination of a fast 
computer and an under-100%-utilization workload can imply repeated cycles of

	spin lock
	irq disable
	blk_iopoll_sched()
	spin unlock

	spin lock
	handle a single command completion
	spin unlock
	blk_iopoll_complete()

which not only erases the benefit, but winds up being more costly, both 
in terms of CPU usage and in terms of latency.

This makes measuring the problem much more difficult; the interesting 
case I am highlighting does not occur when using a benchmarking tool to 
keep a storage device at 100% utilization.

We don't want to optimize for the 100%-load case at the expense of the 
_common case_, which is IMO utilization below 100%.  Servers are not 
100% busy all the time, which opens the possibility that a 
split-completion scheme such as the one presented can actually use 
_more_ CPU than the current, unmodified 2.6.31-rc kernel.

I'm not NAK'ing...  just inserting some relevant NAPI field experience, 
and hoping for some numbers that better measure the costs/benefits.

	Jeff



