From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: scsi-mq V2
Date: Sat, 12 Jul 2014 21:50:43 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B9969F@G9W0745.americas.hpqcorp.net>
References: <20140710062040.GB20146@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
 <20140710160422.GA13728@infradead.org>
 <20140710161438.GA30792@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
 <x497g3l10x6.fsf@segfault.boston.devel.redhat.com>
 <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net>
 <94D0CD8314A33A4D9D801C0FE68B402958B979E6@G9W0745.americas.hpqcorp.net>
 <20140711061441.GA29629@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B98323@G9W0745.americas.hpqcorp.net>
 <20140711145524.GB12478@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:21386 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaGLVw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Jul 2014 17:52:58 -0400
In-Reply-To: <20140711145524.GB12478@kvack.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



> -----Original Message-----
> From: Benjamin LaHaise [mailto:bcrl@kvack.org]
> Sent: Friday, 11 July, 2014 9:55 AM
> To: Elliott, Robert (Server Storage)
> Cc: Christoph Hellwig; Jeff Moyer; Jens Axboe; dgilbert@interlog.com; James
> Bottomley; Bart Van Assche; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: scsi-mq V2
...
> Can you try the below totally untested patch instead?  It looks like
> put_reqs_available() is not irq-safe.
> 

With that addition alone, fio still runs into the same problem.

I added the same fix to get_reqs_available, which also accesses 
kcpu->reqs_available, and the test has run for 35 minutes with 
no problem.

Patch applied:

diff --git a/fs/aio.c b/fs/aio.c
index e59bba8..8e85e26 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -830,16 +830,20 @@ void exit_aio(struct mm_struct *mm)
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 {
 	struct kioctx_cpu *kcpu;
+	unsigned long flags;
 
 	preempt_disable();
 	kcpu = this_cpu_ptr(ctx->cpu);
 
+	local_irq_save(flags);
 	kcpu->reqs_available += nr;
+
 	while (kcpu->reqs_available >= ctx->req_batch * 2) {
 		kcpu->reqs_available -= ctx->req_batch;
 		atomic_add(ctx->req_batch, &ctx->reqs_available);
 	}
 
+	local_irq_restore(flags);
 	preempt_enable();
 }
 
@@ -847,10 +851,12 @@ static bool get_reqs_available(struct kioctx *ctx)
 {
 	struct kioctx_cpu *kcpu;
 	bool ret = false;
+	unsigned long flags;
 
 	preempt_disable();
 	kcpu = this_cpu_ptr(ctx->cpu);
 
+	local_irq_save(flags);
 	if (!kcpu->reqs_available) {
 		int old, avail = atomic_read(&ctx->reqs_available);
 
@@ -869,6 +875,7 @@ static bool get_reqs_available(struct kioctx *ctx)
 	ret = true;
 	kcpu->reqs_available--;
 out:
+	local_irq_restore(flags);
 	preempt_enable();
 	return ret;
 }

--
I will see if that solves the problem with the scsi-mq-3 tree, or 
at least some of the bisect trees leading up to it.

A few other comments:

1. Those changes boost _raw_spin_lock_irqsave into first place
in perf top:

  6.59%  [kernel]                    [k] _raw_spin_lock_irqsave
  4.37%  [kernel]                    [k] put_compound_page
  2.87%  [scsi_debug]                [k] sdebug_q_cmd_hrt_complete
  2.74%  [kernel]                    [k] _raw_spin_lock
  2.73%  [kernel]                    [k] apic_timer_interrupt
  2.41%  [kernel]                    [k] do_blockdev_direct_IO
  2.24%  [kernel]                    [k] __get_page_tail
  1.97%  [kernel]                    [k] _raw_spin_unlock_irqrestore
  1.87%  [kernel]                    [k] scsi_queue_rq
  1.76%  [scsi_debug]                [k] schedule_resp

Maybe (later) kcpu->reqs_available should converted to an atomic,
like ctx->reqs_available, to reduce that overhead?

2. After the f8567a3 patch, aio_complete has one early return that 
bypasses the call to put_reqs_available.  Is that OK, or does
that mean that sync iocbs will now eat up reqs_available?

        /*
         * Special case handling for sync iocbs:
         *  - events go directly into the iocb for fast handling
         *  - the sync task with the iocb in its stack holds the single iocb
         *    ref, no other paths have a way to get another ref
         *  - the sync task helpfully left a reference to itself in the iocb
         */
        if (is_sync_kiocb(iocb)) {
                iocb->ki_user_data = res;
                smp_wmb();
                iocb->ki_ctx = ERR_PTR(-EXDEV);
                wake_up_process(iocb->ki_obj.tsk);
                return;
        }


3. The f8567a3 patch renders this comment in aio.c out of date - it's 
no longer incremented when pulled off the ringbuffer, but is now 
incremented when aio_complete is called.

        struct {
                /*
                 * This counts the number of available slots in the ringbuffer,
                 * so we avoid overflowing it: it's decremented (if positive)
                 * when allocating a kiocb and incremented when the resulting
                 * io_event is pulled off the ringbuffer.
                 *
                 * We batch accesses to it with a percpu version.
                 */
                atomic_t        reqs_available;
        } ____cacheline_aligned_in_smp;


---
Rob Elliott    HP Server Storage



