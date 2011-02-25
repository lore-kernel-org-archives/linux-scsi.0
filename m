From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: scsi LLD implementation question
Date: Fri, 25 Feb 2011 08:37:05 -0500
Message-ID: <1298641025.8617.63.camel@mulgrave.site>
References: <AANLkTi=+6z4qRS7MGSNTyomtyQTu5A20iBF-T92xAPMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923Ab1BYNhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 08:37:10 -0500
In-Reply-To: <AANLkTi=+6z4qRS7MGSNTyomtyQTu5A20iBF-T92xAPMA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: va stg2010 <va.storage2010@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Cc to linux-scsi added because that's the list that best handles these
type of questions.

On Thu, 2011-02-24 at 20:13 -0800, va stg2010 wrote:
> Hi,
> I am working on a driver  for scsi initiator HBA driver for  linux.
> Have an implementation question. Once the commands are received
> into .queuecommand  callback from linux-scsi, I insert them into a
> queue maintained  locally in my driver until the responses comes back
> from target.  The responses when posted later by an interrupt handler
> are eventually processed by a kthread which "iterates"  through this
> queue to post responses back to linux-scsi.

Actually, doing actual internal queueing isn't a good idea:  two queue
confuse the block elevators and only usually serve to increase latency.
If by "queue" you just mean a list of pending commands that have already
been issued to the driver which you need to find again by some
identifier again when the interrupt driven completion is posted, then
using the block tags for this is usually optimal (depending on how many
bits you have for the completion identifier).

>  Question about this queue:
> Is it efficient to have one single queue for all the disks or  its
> more efficient to have separate queue for each disk and separate
> response processing kthreads ?

Having a kthread process responses is generally not a good idea because
completions will come in at interrupt level ... you need a context
switch to get to a thread and this costs latency.  The idea of done
processing in SCSI is to identify the scsi_cmnd as quickly as possible
and post it.  All back end SCSI processing is done in the block softirq
(a level between hard interrupt and user context), again to keep latency
low.  That also means that the kthread architecture is wrong because
it's difficult for the kernel to go hardirq->user->softirq without
adding an extra interrupt latency (usually a clock tick).

If you want a "threaded" response in a multiqueue card using MSIs, then
you bind the MSIs to CPU groups and use the hardware interrupt context
as the threading (I think drivers like lpfc already do this).  The best
performance is actually observed when the MSI comes back in on the same
CPU that issued the I/O because the cache is still hot.  The block keeps
an rq->cpu to tag this which internal HBA setup can use for programming
MSI completions.

James


