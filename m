From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: next-20081119: general protection fault:
	get_next_timer_interrupt()
Date: Mon, 24 Nov 2008 13:35:17 -0800
Message-ID: <20081124213517.GA25898@linux.vnet.ibm.com>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com> <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain> <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com> <alpine.LFD.2.00.0811241816120.3301@localhost.localdomain> <1227554117.25499.46.camel@localhost.localdomain> <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40791 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbYKXVfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2008 16:35:20 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alexander Beregalov <a.beregalov@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>

Thomas Gleixner <tglx@linutronix.de> wrote:
> > Well, not sure.  Most likely candidate is the new block timer code.
> > What seems to be happening is that the queue is being released with
> > either an outstanding request (refcounting problem) or ticking timer
> > with no work (block timer problem).  The way scanning works is that we
> > create a request queue for each device we probe and then delete it again
> > if nothing appears after the bus settle time.   The argument against
> > this is that it should show up on every scanned bus.  However, these are
> > getting rarer; I was just about to write that I hadn't seen it when I
> > remembered that all my SCSI testing systems are currently running
> > hotplug reporting busses (i.e. don't do scanning).  However,
> > fortunately, I've also booted voyager recently which does use parallel
> > SCSI and doesn't see this either, so it could also be megaraid_sas
> > specific.
> 
> Yeah, block could it be as well. Jens, Mike ?

I added a comment to bug 12020 on Thursday about a few other systems that
where seeing the signature shown in bug 12020. It appeared from debug that
there where a few paths that where adding timers for requests that where
not expected.

http://bugzilla.kernel.org/show_bug.cgi?id=12020

It would be good to know if the debug patch below effects your problem as while.

If it does we need to investigated a solution to resolve not adding a
timer for these requests.

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com



blk: blk_add_timer debug patch

[DEBUG] Debug only patch.

Debug patch to blk_add_timer to not start timer for request that do not
have the REQ_STARTED flag set.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 block/blk-timeout.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 69185ea..4389391 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -177,6 +177,9 @@ void blk_add_timer(struct request *req)
 	BUG_ON(!list_empty(&req->timeout_list));
 	BUG_ON(test_bit(REQ_ATOM_COMPLETE, &req->atomic_flags));
 
+	if (!(req->cmd_flags & REQ_STARTED))
+		return;
+
 	if (req->timeout)
 		req->deadline = jiffies + req->timeout;
 	else {
-- 
1.5.6.5

