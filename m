From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] kick ksoftirqd more often to please soft lockup
 detector
Date: Tue, 28 Feb 2012 22:41:39 +0100 (CET)
Message-ID: <alpine.LFD.2.02.1202282240340.2794@ionos>
References: <20120227203847.22153.62468.stgit@dwillia2-linux.jf.intel.com> <1330422535.11248.78.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:52560 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2B1Vll (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2012 16:41:41 -0500
In-Reply-To: <1330422535.11248.78.camel@twins>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Lukasz Dorau <lukasz.dorau@intel.com>, James Bottomley <JBottomley@parallels.com>, Andrzej Jakowski <andrzej.jakowski@intel.com>

On Tue, 28 Feb 2012, Peter Zijlstra wrote:

> On Mon, 2012-02-27 at 12:38 -0800, Dan Williams wrote:
> > An experimental hack to tease out whether we are continuing to
> > run the softirq handler past the point of needing scheduling.
> > 
> > It allows only one trip through __do_softirq() as long as need_resched()
> > is set which hopefully creates the back pressure needed to get ksoftirqd
> > scheduled.
> > 
> > Targeted to address reports like the following that are produced
> > with i/o tests to a sas domain with a large number of disks (48+), and
> > lots of debugging enabled (slub_deubg, lockdep) that makes the
> > block+scsi softirq path more cpu-expensive than normal.
> > 
> > With this patch applied the softlockup detector seems appeased, but it
> > seems odd to need changes to kernel/softirq.c so maybe I have overlooked
> > something that needs changing at the block/scsi level?
> > 
> > BUG: soft lockup - CPU#3 stuck for 22s! [kworker/3:1:78] 
> 
> So you're stuck in softirq for 22s+, max_restart is 10, this gives that
> on average you spend 2.2s+ per softirq invocation, this is completely
> absolutely bonkers. Softirq handlers should never consume significant
> amount of cpu-time.
> 
> Thomas, think its about time we put something like the below in?

Absolutely. Anything which consumes more than a few microseconds in
the softirq handler needs to be sorted out, no matter what.
