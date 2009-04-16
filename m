From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: LSF Papers online?
Date: Thu, 16 Apr 2009 11:45:53 -0600
Message-ID: <20090416174553.GE1926@parisc-linux.org>
References: <49E335BA.3020103@panasas.com> <200904141654.24067.bzolnier@gmail.com> <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk> <200904150009.06539.bzolnier@gmail.com> <1239749357.3638.3.camel@mulgrave> <49E53AE6.4010803@gmail.com> <da824cf30904152331r82594e5i1968471af1dbb1fa@mail.gmail.com> <1239899823.3762.37.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1239899823.3762.37.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Grundler <grundler@google.com>, Robert Hancock <hancockrwd@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 16, 2009 at 11:37:02AM -0500, James Bottomley wrote:
> of data.   I fully agree that some of the less smart SATA controllers
> have a lot of catching up to do in this space, but that isn't
> necessarily a driver issue; you can't polish a turd as the saying
> goes ...

I guess you haven't seen the episode of Mythbusters where they manage
to do exactly that?  ;-)

> IOPS are starting to come up because SSDs are saying they prefer many
> smaller transactions to an accumulated larger one.  I'm still not

I don't think that's what SSDs are saying.  The protocol (and controllers)
still work better if you send down one 128k IO than 32 4k IOs.  But with
the low latency of doing accesses, it's better to send down a 16k IO
now than it is to wait around a bit and see if another 16k IO comes along.

> entirely convinced that trying to rightsize is wrong here:  most of the
> FS data is getting more contiguous, so even for SSDs we can merge
> without a lot of work.  A simple back of the envelope calculation can
> give the rightizing:  If you want a SSD to max out at its 31 allowed
> tags saturating a 3G sata link, then you're talking 10M per tag per

Better than that, only 8MB of data per tag per second.  SATA effectively
limits you to 250MB/s.  That's 2016 IOPS per tag.  Of course, this
assumes you're only doing the NCQ commands and not, say, issuing TRIM
or something.

> second.  If we assume a 4k sector size, that's 2500 IOPS per tag
> (there's no real point doing less than 4k, because that has us splitting
> the page cache). Or, to put it another way, over 75k IOPS for a single
> SSD doesn't make sense ... the interesting question is whether it would
> make more sense to align on, say 16k io and so expect to max out at 20k
> IOPS.

If we're serious about getting 2000 IOPS per tag, then the round-trip
inside the kernel to recycle a tag has to be less than 500 microseconds.
Do you have a good idea about how to measure what that is today?
Here's the call path taken by the AHCI driver:

ahci_interrupt()
ahci_port_intr()
ata_qc_complete_multiple()
ata_qc_complete()
__ata_qc_complete()
ata_scsi_qc_complete() [qc->complete_fn]
scsi_done() [qc->scsidone]
blk_complete_request()
__blk_complete_request()
raise_softirq_irqoff()
...
blk_done_softirq()
scsi_softirq_done() [rq->q->softirq_done_fn]
scsi_finish_command()
scsi_io_completion()
scsi_end_request()
scsi_next_command()
scsi_run_queue()
__blk_run_queue()
blk_invoke_request_fn()
scsi_request_fn() [q->request_fn]
scsi_dispatch_cmd()
ata_scsi_translate() [host->hostt->queuecommand]
ata_qc_issue()
ahci_qc_issue() [ap->ops->qc_issue]

I can see a few ways to cut down the latency between knowing a tag is
no longer used and starting the next command.

We could pretend the AHCI driver has a queue depth of 64, queue up
commands in the driver, swap the tags over, and send out the next command
before we process this command.

This is similar to a technique that's used in some old SCSI drivers that
didn't support tagged commands at all -- a second command was queued
inside the driver while the first was executing on the device.

But then, we had that big movement towards elimintaing queues from inside
drivers ... maybe we need another way.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
