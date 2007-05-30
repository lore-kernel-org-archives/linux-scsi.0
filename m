From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Deadlock during DV when queue is full
Date: Wed, 30 May 2007 14:02:02 -0500
Message-ID: <1180551722.3697.41.camel@mulgrave.il.steeleye.com>
References: <1180395725.1292.43.camel@bluto.andrew>
	 <20070530180138.GQ15559@kernel.dk>
	 <1180550612.3697.39.camel@mulgrave.il.steeleye.com>
	 <20070530185526.GV15559@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33364 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753994AbXE3TCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 15:02:05 -0400
In-Reply-To: <20070530185526.GV15559@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Patterson <andrew.patterson@hp.com>, linux-scsi@vger.kernel.org, jens.axboe@oracale.com, "Moore, Eric" <Eric.Moore@lsi.com>

On Wed, 2007-05-30 at 20:55 +0200, Jens Axboe wrote:
> On Wed, May 30 2007, James Bottomley wrote:
> > On Wed, 2007-05-30 at 20:01 +0200, Jens Axboe wrote:
> > > On Mon, May 28 2007, Andrew Patterson wrote:
> > > > I am running into deadlock during domain validation when the request
> > > > queue is full. I am using the MPT Fusion spi driver and have run into
> > > > this problem with 2.6.16 and the latest scsi_misc kernels.  The system
> > > > is running a load test on a u320 pSCSI bus with a drive that will
> > > > occasionally hang the bus until a host reset clears the condition.  This
> > > > particular drive in known to not handle QAS very well.  After the host
> > > > reset, the MPT Fusion driver attempts domain validation on all drives on
> > > > the bus. During DV, one or more of the queues lockup while trying to
> > > > execute various SCSI commands (INQUIRY, WRITE_BUFFER, etc) using the
> > > > scsi_execute() call.  A stack trace shows:
> > > 
> > > Ugh, that's nasty. If that is a valid scenario (and it looks like it
> > > is), then we have reserve a request (and SCSI command) for such uses as
> > > the below scenario is definitely livelock country.
> > > 
> > > > [ 2318.524898] events/1      D a0000001007258f0     0    16      2 (L-TLB)
> > > > [ 2318.532030] 
> > > > [ 2318.532031] Call Trace:
> > > > [ 2318.532202]  [<a000000100724750>] schedule+0x1550/0x1840
> > > > [ 2318.532204]                                 sp=e00000010a8dfc60 bsp=e00000010a8d8ff0
> > > > [ 2318.546975]  [<a0000001007258f0>] io_schedule+0x50/0x80
> > > > [ 2318.546977]                                 sp=e00000010a8dfcf0 bsp=e00000010a8d8fd0
> > > > [ 2318.554417]  [<a0000001003b8820>] get_request_wait+0x200/0x2c0
> > > > [ 2318.554419]                                 sp=e00000010a8dfcf0 bsp=e00000010a8d8f78
> > > > [ 2318.562540]  [<a0000001003b8990>] blk_get_request+0xb0/0x120
> > > > [ 2318.562542]                                 sp=e00000010a8dfd40 bsp=e00000010a8d8f40
> > > > [ 2318.579166]  [<a00000010058b5e0>] scsi_execute+0x40/0x1e0
> > > > [ 2318.579168]                                 sp=e00000010a8dfd40 bsp=e00000010a8d8ee8
> > > > [ 2318.586863]  [<a0000001005980f0>] spi_execute+0x70/0x120
> > > > [ 2318.586865]                                 sp=e00000010a8dfd40 bsp=e00000010a8d8e88
> > > > [ 2318.594204]  [<a000000100599650>] spi_dv_device_echo_buffer+0x2f0/0x520
> > > > [ 2318.594206]                                 sp=e00000010a8dfdc0 bsp=e00000010a8d8e30
> > > > [ 2318.607333]  [<a000000100597a30>] spi_dv_retrain+0x70/0x520
> > > > [ 2318.607335]                                 sp=e00000010a8dfde0 bsp=e00000010a8d8dc0
> > > > [ 2318.616119]  [<a000000100599170>] spi_dv_device+0xdf0/0xf00
> > > > [ 2318.616121]                                 sp=e00000010a8dfde0 bsp=e00000010a8d8d40
> > > > [ 2318.630538]  [<a00000020db7e360>] mptspi_dv_device+0x160/0x2c0 [mptspi]
> > > > [ 2318.630540]                                 sp=e00000010a8dfdf0 bsp=e00000010a8d8ce0
> > > > [ 2318.638341]  [<a00000020db7e660>] mptspi_dv_renegotiate_work+0x1a0/0x220 [mptspi]
> > > > [ 2318.638343]                                 sp=e00000010a8dfdf0 bsp=e00000010a8d8cb0
> > > > [ 2318.652773]  [<a0000001000b80c0>] run_workqueue+0x1c0/0x320
> > > > [ 2318.652775]                                 sp=e00000010a8dfe00 bsp=e00000010a8d8c80
> > > > [ 2318.660003]  [<a0000001000b8460>] worker_thread+0x240/0x280
> > > > [ 2318.660005]                                 sp=e00000010a8dfe00 bsp=e00000010a8d8c50
> > > > [ 2318.667536]  [<a0000001000c24e0>] kthread+0xa0/0x120
> > > > [ 2318.667538]                                 sp=e00000010a8dfe30 bsp=e00000010a8d8c20
> > > > [ 2318.681699]  [<a0000001000129f0>] kernel_thread_helper+0xd0/0x100
> > > > [ 2318.681701]                                 sp=e00000010a8dfe30 bsp=e00000010a8d8bf0
> > > > [ 2318.689121]  [<a0000001000094c0>] start_kernel_thread+0x20/0x40
> > > > [ 2318.689124]                                 sp=e00000010a8dfe30 bsp=e00000010a8d8bf0
> > > > 
> > > > 
> > > > Some code examination and tracing show that get_request_wait() calls
> > > > get_request() to obtain a request.  If get_request() returns NULL, it
> > > > will wait and try again.  Here is the code from get_request_wait():
> > > > 
> > > > 	rq = get_request(q, rw_flags, bio, GFP_NOIO);
> > > > 	while (!rq) {
> > > > 		DEFINE_WAIT(wait);
> > > > 		struct request_list *rl = &q->rq;
> > > > 
> > > > 		prepare_to_wait_exclusive(&rl->wait[rw], &wait,
> > > > 				TASK_UNINTERRUPTIBLE);
> > > > 
> > > > 		rq = get_request(q, rw_flags, bio, GFP_NOIO);
> > > > 
> > > > 		if (!rq) {
> > > > 			struct io_context *ioc;
> > > > 			blk_add_trace_generic(q, bio, rw, BLK_TA_SLEEPRQ);
> > > > 
> > > > 			__generic_unplug_device(q);
> > > > 			spin_unlock_irq(q->queue_lock);
> > > > 			io_schedule();
> > > > 
> > > > 			/*
> > > > 			 * After sleeping, we become a "batching" process and
> > > > 			 * will be able to allocate at least one request, and
> > > > 			 * up to a big batch of them for a small period time.
> > > > 			 * See ioc_batching, ioc_set_batching
> > > > 			 */
> > > > 			ioc = current_io_context(GFP_NOIO, q->node);
> > > > 			ioc_set_batching(q, ioc);
> > > > 
> > > > 			spin_lock_irq(q->queue_lock);
> > > > 		}
> > > > 		finish_wait(&rl->wait[rw], &wait);
> > > > 	}
> > > > 
> > > > Note the io_schedule() here. As far as I can tell, there is not wakeup
> > > > for this wait queue.  The only wakeup's occur when a request is freed.
> > > > No requests can be processed because the error handling is holding off
> > > > request processing until the error condition is cleared so we get a
> > > > deadlock. 
> > > > 
> > > > Looking through get_request() we see:
> > > > 
> > > > 	if (rl->count[rw]+1 >= queue_congestion_on_threshold(q)) {
> > > > 		if (rl->count[rw]+1 >= q->nr_requests) {
> > > > 			ioc = current_io_context(GFP_ATOMIC, q->node);
> > > > 			/*
> > > > 			 * The queue will fill after this allocation, so set
> > > > 			 * it as full, and mark this process as "batching".
> > > > 			 * This process will be allowed to complete a batch of
> > > > 			 * requests, others will be blocked.
> > > > 			 */
> > > > 			if (!blk_queue_full(q, rw)) {
> > > > 				ioc_set_batching(q, ioc);
> > > > 				blk_set_queue_full(q, rw);
> > > > 			} else {
> > > > 				if (may_queue != ELV_MQUEUE_MUST
> > > > 						&& !ioc_batching(q, ioc)) {
> > > > 					/*
> > > > 					 * The queue is full and the allocating
> > > > 					 * process is not a "batcher", and not
> > > > 					 * exempted by the IO scheduler
> > > > 					goto out;
> > > > 				}
> > > > 			}
> > > > 		}
> > > > 		blk_set_queue_congested(q, rw);
> > > > 	}
> > > > 
> > > > In this heavily loaded system, we get into the "goto out" because count
> > > > > nr_requests. The "goto out" will lead to returning NULL. This
> > > > condition would not occur if ioc_batching was set, but this is not done
> > > > until after the io_schedule() in get_request_wait().  
> > > 
> > > It doesn't matter, memory allocation could still block due to reclaim
> > > which wont happen because no more IO is getting through. Or if you went
> > > atomic it could also fail.
> > > 
> > > There's no other solution than maintaining a cached request + command
> > > for this. libata has a similar issue wrt error handling with ncq, we may
> > > need a command in error handling to retrieve the log page.
> > 
> > Actually, there is another solution: DV is careful only to be using a
> > single command for its processes ... if we could use the eh command for
> > this, then I think the problem would go away ... unfortunately, that's a
> > bit more complex to achieve than it sounds.
> 
> That would be fine, the key is just to have such a reserved command. Is
> there also a reserved request?

Yes ... we clean out the failing command in error recovery and reuse it,
so we know it has both a command and a request.

James


