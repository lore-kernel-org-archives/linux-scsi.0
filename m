From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [Emulex] queuecommands and GFP_ATOMIC
Date: Tue, 8 Jun 2004 14:21:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F946C@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44960 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263893AbUFHSVY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 14:21:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Anton Blanchard <anton@samba.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

So we've done some testing with the locks moved and the GFP_xxx flag
changed...

On a RedHat 3.90 2.6.5 kernel, we hit the following:

Debug: sleeping function called from invalid context at mm/slab.c:1980
in_atomic():1, irqs_disabled():0
Call Trace:
 [<0211c5a1>] __might_sleep+0x80/0x8a
 [<0213ba96>] kmem_cache_alloc+0x1b/0x50
 [<82ac32e8>] lpfc_get_scsi_buf+0x20/0x12e [lpfc]
 [<82ac45b5>] lpfc_queuecommand+0x2c/0x175 [lpfc]
 [<82834864>] scsi_done+0x0/0x60 [scsi_mod]
 [<828346a7>] scsi_dispatch_cmd+0x1bb/0x220 [scsi_mod]
 [<828390d1>] scsi_request_fn+0x292/0x31e [scsi_mod]
 [<021f3b5c>] blk_run_queue+0x25/0x34
 [<82838679>] scsi_end_request+0x9d/0xa4 [scsi_mod]
 [<828389d6>] scsi_io_completion+0x225/0x427 [scsi_mod]
 [<82834a59>] scsi_finish_command+0xac/0xb1 [scsi_mod]
 [<8283497a>] scsi_softirq+0xb6/0xc3 [scsi_mod]
 [<02121d00>] __do_softirq+0x48/0x9d
 [<02107f91>] do_softirq+0x4f/0x56

Given this stack trace, any GFP_xxx flag that has __GFP_WAIT set is at risk
(includes GFP_NOIO).

So, the only real solution looks to be to go back to the local memory pools
in queuecommand, failing back to the midlayer upon alloc failure.

Any other suggestions?

-- James


> -----Original Message-----
> From: 'Christoph Hellwig' [mailto:hch@infradead.org]
> Sent: Tuesday, June 08, 2004 1:03 PM
> To: Smart, James
> Cc: Anton Blanchard; 'linux-scsi@vger.kernel.org'
> Subject: Re: Emulex lpfcdriver v8.0.2 available
> 
> 
> On Tue, Jun 08, 2004 at 10:54:27AM -0400, Smart, James wrote:
> > FYI - and status update.
> > 
> > A malloc or two was condense on the fast path. However, the 
> reorg so alloc
> > was not under lock is not done yet. Should be in the next drop. In
> > queuecommand, we will: unload the host lock, perform all 
> allocations and do
> > prep data, then take the driver lock, complete state checks 
> and submit to
> > hardware. Should allow all the ATOMIC allocations to go 
> back to normal for
> > the queuecommand sequence.
> 
> Not quite normal, it still needs to be GFP_NOIO to avoid deadlocks.
> 
