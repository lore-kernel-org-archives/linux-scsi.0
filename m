From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 4 Mar 2009 21:09:41 +0100 (CET)
Message-ID: <alpine.LFD.2.00.0903042058100.29264@localhost.localdomain>
References: <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de>
 <20090303234834.GA13389@elte.hu> <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net> <49AE32B5.9040603@s5r6.in-berlin.de> <20090304112455.GB14593@elte.hu> <20090304111114.aed7b225.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:41796 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841AbZCDULB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 15:11:01 -0500
In-Reply-To: <20090304111114.aed7b225.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, stefanr@s5r6.in-berlin.de, efault@gmx.de, James.Bottomley@HansenPartnership.com, jengelh@medozas.de, bharrosh@panasas.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org

On Wed, 4 Mar 2009, Andrew Morton wrote:
> On Wed, 4 Mar 2009 12:24:55 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > FYI, we still have not tracked down the SCSI bug. Latest 
> > tip:master is able to boot and work on the affected systems, 
> > while the upstream kernel does not even boot because the fix (or 
> > the revert, should the fix be deemed unwanted) is stuck in the 
> > SCSI tree.
> 
> <wakes up>
> 
> There are fixes in the scsi tree?
> 
> Does the scsi tree fix all the regressions which you guys are seeing?
> 
> I must say that it seems to be awfully late in the cycle to have this
> amount of breakage remaining in mainline when we know exactly which
> patches need to be reverted to unbreak things.

We are looking at two breakages:

1) the hang which is observed on AIC7xxx, which is identified (Ingo
tracked it down to a bunch of commits). There is a tentative fix right
now, which needs more testing and the ack of James. James has some
objections which stalled the fix, but I did not come around to dig
into this yet as I'm busy with #2.

2) a crash caused by blk_rq_map_sg() using more sg entries than the
code which setup the request estimated. That one is dangerous, it
already trashed a complete filesystem. I'm in the process of providing
the necessary debug data, as I found a way to reproduce the problem
halfsways.

Thanks,

	tglx
