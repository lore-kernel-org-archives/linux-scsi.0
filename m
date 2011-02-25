From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: scsi LLD implementation question
Date: Fri, 25 Feb 2011 12:20:06 -0500
Message-ID: <1298654406.2459.50.camel@mulgrave.site>
References: <AANLkTi=+6z4qRS7MGSNTyomtyQTu5A20iBF-T92xAPMA@mail.gmail.com>
	 <1298641025.8617.63.camel@mulgrave.site>
	 <AANLkTinzhNr7FtKW5LR6QJ3O3b_Xy50wN0tS+NRg4KL2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411Ab1BYRUQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 12:20:16 -0500
In-Reply-To: <AANLkTinzhNr7FtKW5LR6QJ3O3b_Xy50wN0tS+NRg4KL2@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-02-25 at 18:12 +0100, Bart Van Assche wrote:
> On Fri, Feb 25, 2011 at 2:37 PM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > Having a kthread process responses is generally not a good idea because
> > completions will come in at interrupt level ... you need a context
> > switch to get to a thread and this costs latency.  The idea of done
> > processing in SCSI is to identify the scsi_cmnd as quickly as possible
> > and post it.  All back end SCSI processing is done in the block softirq
> > (a level between hard interrupt and user context), again to keep latency
> > low.  That also means that the kthread architecture is wrong because
> > it's difficult for the kernel to go hardirq->user->softirq without
> > adding an extra interrupt latency (usually a clock tick).
> >
> > If you want a "threaded" response in a multiqueue card using MSIs, then
> > you bind the MSIs to CPU groups and use the hardware interrupt context
> > as the threading (I think drivers like lpfc already do this).  The best
> > performance is actually observed when the MSI comes back in on the same
> > CPU that issued the I/O because the cache is still hot.  The block keeps
> > an rq->cpu to tag this which internal HBA setup can use for programming
> > MSI completions.
> 
> The above sounds like great advice if the processing time is
> reasonably short. But what if the processing time can be anything
> between e.g. a microsecond and twenty minutes ?

Well, what processing?  SCSI LLDs are data shifting engines; there's not
a lot of extra stuff to do.  If you mean things like integrity
verification, they tend to be done inline adding directly to latency as
a cost of turning on integrity.  If you mean something like
excrutiatingly slow PIO just to capture the data, then that's up to the
LLD ... but most do it in-line (bogging down the whole system) primarily
because timing tends to be critical to avoid FIFO overruns (the lesson
being to avoid those cards).

Can you give an example?  I can't really think of any processing that's
so huge it would require threaded offloading.  The main point I was
making is that offloading to a thread between HW irq and SCSI done adds
enormously to latency because of the way done completions are processed
in softirq context.  If that latency is just a drop in the ocean
compared to the processing, then sure, offload it.

James


James


