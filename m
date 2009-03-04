From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 4 Mar 2009 01:39:59 +0100
Message-ID: <20090304003959.GA11782@elte.hu>
References: <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain> <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain> <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <1236124861.24019.78.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:51364 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbZCDAkZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Mar 2009 19:40:25 -0500
Content-Disposition: inline
In-Reply-To: <1236124861.24019.78.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > Dude, lets make it clear to you: it is not "your area" that 
> > you own in any way and you have no monopoly on SCSI fixes.
> 
> The fact that I can spot a missing release buffers and you, 
> apparently, can't does lend credence to a claim of greater 
> expertise in the SCSI area.

Uhm, i dont maintain SCSI and dont intend to. I got a fix patch 
from an SCSI person for a lockup bug i reported on the SCSI 
list, caused by a commit authored by that same SCSI person, and 
i applied the fix.

The real question is, why didnt your review and testing skills 
catch the serious lockups caused by:

    commit b60af5b0adf0da24c673598c8d3fb4d4189a15ce
    Date:   Mon Nov 3 15:56:47 2008 -0500
    [SCSI] simplify scsi_io_completion()

... and why is the bug still unfixed today in the upstream 
kernel?

The thing is, we triggered the lockups quite easily in -rt and 
-tip testing - and we are not set up to catch SCSI bugs at all. 
We are set up to test and catch bugs in the areas of the kernel 
we are interested in mainly.

> >  We acted out of necessity because the SCSI tree is taking 
> > very long to get fixes upstream.
> 
> To get upstream, there first has to be a fix.  I've already 
> explained why I don't think the patch in question is a fix.

Uhm, then why didnt you revert the original commit? I clearly 
identified it to you as the root trigger of the lockup and 
confirmed that reverting it fixes the hang, and i invested many 
days of testing into that.
 
When i reported this very serious and potentially data 
corrupting bug to you on January 15th you immediately suggested 
it's a problem with the commit above.

So you were in full knowledge of the root cause of the breakage 
- but why have you not reverted it? Doing a speedy revert is a 
must-have for any bug that has data corruption potential.

What you did is akin to playing russian roulette with other 
people's data. You knew about a serious, data corruptor 
breakage, you knew which change caused it, but still you didnt 
act to revert the patch or resolve the problem.

The expected behavior from an upstream maintainer is not to 
introduce breakages and wait until the "real cause" is 
understood. The expected behavior is to either fix or revert a 
commit that has been pinpointed as the source of a serious bug. 
You didnt do that - why?

> > I reported this lockup bug to you on _January 15th_, more 
> > than one and a half months ago - and it's still unfixed even 
> > today. Alan sent his v2 fix on Feburary 19th - two weeks 
> > ago.
> 
> OK, so why don't you humour me and try applying the diagnostic 
> patch I sent you on the 24th of January? [...]

Uhm, below is the so-called "diagnostic" patch you sent to me 
and the problem with that "patch" is that it does not tell us 
anything we did not know already.

It just confirms that the function locks up - and we already 
knew that much from all the logs i sent to you. I.e. that 
"patch" is an utter waste of my time and you should know that.

I bisect commits, i test fixes, but i dont test silly 
half-hearted "diagnostic" patches which must have taken you less 
than 1 minute to write and would waste 30 minutes of my time to 
test - for no objective purpose. It has no chance to give us any 
new information. I really have better things to do with my time.

James, you ned to try harder to get bugs fixed and you need to 
treat your testers better. Come up with a real diagnostic patch 
that tells us something useful and i'll run it. Until then i'll 
just ignore your rants.

	Ingo

--------------------->
From: James Bottomley

On Wed, 2009-01-21 at 16:44 +0100, Ingo Molnar wrote:
> > One thought I had is that somehow the starved list processing in 
> > scsi_run_queue might never be terminating.  This should be easy to 
> > verify: just put a counter inside the while(!list_empty(&starved_list)) 
> > and print if it gets ridiculously large (like > 1000).
> 
> i deal with about a dozen regressions a day, so it would really help if 
> you could send me a debug patch to apply. I can then turn off the reverts 
> for that testbox and wait for another hang to occur.

OK, try this.

But could we take this to the scsi-list so that others get a chance to
give suggestions and you're not single threaded on me.

Thanks,

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 940dc32..5919dd0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -593,6 +593,7 @@ static void scsi_run_queue(struct request_queue *q)
 	struct Scsi_Host *shost = sdev->host;
 	LIST_HEAD(starved_list);
 	unsigned long flags;
+	int count = 0;
 
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
@@ -603,6 +604,8 @@ static void scsi_run_queue(struct request_queue *q)
 	while (!list_empty(&starved_list)) {
 		int flagset;
 
+		BUG_ON(count++ > 1000);
+
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn

