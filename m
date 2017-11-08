From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] SCSI: don't get target/host busy_count in
 scsi_mq_get_budget()
Date: Wed, 8 Nov 2017 11:19:57 -0700
Message-ID: <915a08af-4aa8-08a4-e081-9dc019f14ce1@kernel.dk>
References: <1510071607.2656.17.camel@wdc.com>
 <74925156-b425-de0e-de39-0a166ef5c5f3@kernel.dk>
 <49b5c202-0303-85f7-102a-fcc013e7256e@kernel.dk>
 <292e3f7d-cfe3-840a-5a5e-d00e01239152@kernel.dk>
 <a6a505f5-d374-2878-6c55-116255795346@kernel.dk>
 <20171108010345.GF20599@ming.t460p>
 <81215aae-2755-1b4c-b7bd-1aef5d1dfa1b@kernel.dk>
 <20171108031204.GB30129@ming.t460p>
 <8450283f-4882-0f2f-fdc8-8ab02f1dc333@kernel.dk>
 <20171108062041.GB30541@ming.t460p> <20171108155903.GA11003@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108155903.GA11003@ming.t460p>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>, "john.garry@huawei.com" <john.garry@huawei.com>, "loberman@redhat.com" <loberman@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/08/2017 08:59 AM, Ming Lei wrote:
> On Wed, Nov 08, 2017 at 02:20:41PM +0800, Ming Lei wrote:
>> On Tue, Nov 07, 2017 at 08:17:59PM -0700, Jens Axboe wrote:
>>> On 11/07/2017 08:12 PM, Ming Lei wrote:
>>>> On Tue, Nov 07, 2017 at 08:01:48PM -0700, Jens Axboe wrote:
>>>>> On 11/07/2017 06:03 PM, Ming Lei wrote:
>>>>>> On Tue, Nov 07, 2017 at 03:06:31PM -0700, Jens Axboe wrote:
>>>>>>> On 11/07/2017 10:36 AM, Jens Axboe wrote:
>>>>>>>> On 11/07/2017 10:10 AM, Jens Axboe wrote:
>>>>>>>>> On 11/07/2017 09:29 AM, Jens Axboe wrote:
>>>>>>>>>> On 11/07/2017 09:20 AM, Bart Van Assche wrote:
>>>>>>>>>>> On Tue, 2017-11-07 at 10:11 +0800, Ming Lei wrote:
>>>>>>>>>>>> If you can reproduce, please provide me at least the following log
>>>>>>>>>>>> first:
>>>>>>>>>>>>
>>>>>>>>>>>> 	find /sys/kernel/debug/block -name tags | xargs cat | grep busy
>>>>>>>>>>>>
>>>>>>>>>>>> If any pending requests arn't completed, please provide the related
>>>>>>>>>>>> info in dbgfs about where is the request.
>>>>>>>>>>>
>>>>>>>>>>> Every time I ran the above or a similar command its output was empty. I
>>>>>>>>>>> assume that's because the hang usually occurs in a phase where these debugfs
>>>>>>>>>>> attributes either have not yet been created or have already disappeared.
>>>>>>>>>>
>>>>>>>>>> Bart, do you still see a hang with the patch that fixes the tag leak when
>>>>>>>>>> we fail to get a dispatch budget?
>>>>>>>>>>
>>>>>>>>>> https://marc.info/?l=linux-block&m=151004881411480&w=2
>>>>>>>>>>
>>>>>>>>>> I've run a lot of stability testing here, and I haven't run into any
>>>>>>>>>> issues. This is with shared tags as well. So if you still see the failure
>>>>>>>>>> case with the current tree AND the above patch, then I'll try and get
>>>>>>>>>> a test case setup that hits it too so we can get to the bottom of this.
>>>>>>>>>
>>>>>>>>> Ming, I managed to reproduce the hang using null_blk. Note this is
>>>>>>>>> WITHOUT the patch mentioned above, running with that now.
>>>>>>>>>
>>>>>>>>> # modprobe null_blk queue_mode=2 nr_devices=4 shared_tags=1 submit_queues=1 hw_queue_depth=1
>>>>>>>>>
>>>>>>>>> and using this fio file:
>>>>>>>>>
>>>>>>>>> [global]
>>>>>>>>> bs=4k
>>>>>>>>> rw=randread
>>>>>>>>> norandommap
>>>>>>>>> direct=1
>>>>>>>>> ioengine=libaio
>>>>>>>>> iodepth=4
>>>>>>>>>
>>>>>>>>> [nullb0]
>>>>>>>>> filename=/dev/nullb0
>>>>>>>>> [nullb1]
>>>>>>>>> filename=/dev/nullb1
>>>>>>>>> [nullb2]
>>>>>>>>> filename=/dev/nullb2
>>>>>>>>> [nullb3]
>>>>>>>>> filename=/dev/nullb3
>>>>>>>>>
>>>>>>>>> it seemed to keep running, but it hung when exiting. The troublesome
>>>>>>>>> device was nullb1:
>>>>>>>>>
>>>>>>>>> [  492.513374] INFO: task fio:3263 blocked for more than 120 seconds.
>>>>>>>>> [  492.520782]       Not tainted 4.14.0-rc7+ #499
>>>>>>>>> [  492.526247] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>>>>>>> [  492.535904] fio             D13208  3263   3211 0x00000000
>>>>>>>>> [  492.542535] Call Trace:
>>>>>>>>> [  492.545764]  __schedule+0x279/0x720
>>>>>>>>> [  492.550151]  schedule+0x33/0x90
>>>>>>>>> [  492.554145]  io_schedule+0x16/0x40
>>>>>>>>> [  492.558435]  blk_mq_get_tag+0x148/0x250
>>>>>>>>> [  492.563211]  ? finish_wait+0x90/0x90
>>>>>>>>> [  492.567693]  blk_mq_get_request+0xf0/0x3e0
>>>>>>>>> [  492.572760]  blk_mq_make_request+0xe2/0x690
>>>>>>>>> [  492.577913]  generic_make_request+0xfc/0x2f0
>>>>>>>>> [  492.583177]  submit_bio+0x64/0x120
>>>>>>>>> [  492.587475]  ? set_page_dirty_lock+0x4b/0x60
>>>>>>>>> [  492.592736]  ? submit_bio+0x64/0x120
>>>>>>>>> [  492.597309]  ? bio_set_pages_dirty+0x55/0x60
>>>>>>>>> [  492.602570]  blkdev_direct_IO+0x388/0x3c0
>>>>>>>>> [  492.607546]  ? free_ioctx_users+0xe0/0xe0
>>>>>>>>> [  492.612511]  ? blk_mq_dispatch_rq_list+0x238/0x3a0
>>>>>>>>> [  492.618353]  ? _raw_spin_unlock+0xe/0x20
>>>>>>>>> [  492.623227]  generic_file_read_iter+0xb3/0xa00
>>>>>>>>> [  492.628682]  ? generic_file_read_iter+0xb3/0xa00
>>>>>>>>> [  492.634334]  ? security_file_permission+0x9b/0xc0
>>>>>>>>> [  492.640114]  blkdev_read_iter+0x35/0x40
>>>>>>>>> [  492.644877]  aio_read+0xc5/0x120
>>>>>>>>> [  492.648973]  ? aio_read_events+0x24c/0x340
>>>>>>>>> [  492.654124]  ? __might_sleep+0x4a/0x80
>>>>>>>>> [  492.658800]  do_io_submit+0x47c/0x5e0
>>>>>>>>> [  492.663373]  ? do_io_submit+0x47c/0x5e0
>>>>>>>>> [  492.668234]  SyS_io_submit+0x10/0x20
>>>>>>>>> [  492.672715]  ? SyS_io_submit+0x10/0x20
>>>>>>>>> [  492.677394]  entry_SYSCALL_64_fastpath+0x13/0x94
>>>>>>>>> [  492.683039] RIP: 0033:0x7f83d1871717
>>>>>>>>> [  492.687521] RSP: 002b:00007ffd38fe5a88 EFLAGS: 00000202 ORIG_RAX: 00000000000000d1
>>>>>>>>> [  492.696969] RAX: ffffffffffffffda RBX: 00007f83b6972b50 RCX: 00007f83d1871717
>>>>>>>>> [  492.705423] RDX: 0000000001f41418 RSI: 0000000000000001 RDI: 00007f83e4d36000
>>>>>>>>> [  492.713889] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000001f3f2e0
>>>>>>>>> [  492.722352] R10: 0000000000001000 R11: 0000000000000202 R12: 00007ffd38fe5be0
>>>>>>>>> [  492.730827] R13: 00007f83b6972b01 R14: 00007f83b69824b8 R15: 00007f83b6982368
>>>>>>>>>
>>>>>>>>> and if we look at the debug entries, it's waiting on a scheduler tag:
>>>>>>>>>
>>>>>>>>> sched_tags:nr_tags=2
>>>>>>>>> sched_tags:nr_reserved_tags=0
>>>>>>>>> sched_tags:active_queues=0
>>>>>>>>> sched_tags:bitmap_tags:
>>>>>>>>> sched_tags:depth=2
>>>>>>>>> sched_tags:busy=2
>>>>>>>>> sched_tags:bits_per_word=64
>>>>>>>>> sched_tags:map_nr=1
>>>>>>>>> sched_tags:alloc_hint={0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0}
>>>>>>>>> sched_tags:wake_batch=1
>>>>>>>>> sched_tags:wake_index=4
>>>>>>>>> sched_tags:ws={
>>>>>>>>> sched_tags:	{.wait_cnt=-102, .wait=inactive},
>>>>>>>>> sched_tags:	{.wait_cnt=-126, .wait=inactive},
>>>>>>>>> sched_tags:	{.wait_cnt=-72, .wait=inactive},
>>>>>>>>> sched_tags:	{.wait_cnt=-96, .wait=inactive},
>>>>>>>>> sched_tags:	{.wait_cnt=-134, .wait=inactive},
>>>>>>>>> sched_tags:	{.wait_cnt=-116, .wait=inactive},
>>>>>>>>> sched_tags:	{.wait_cnt=-90, .wait=inactive},
>>>>>>>>> sched_tags:	{.wait_cnt=-115, .wait=active},
>>>>>>>>> sched_tags:}
>>>>>>>>> sched_tags:round_robin=0
>>>>>>>>> sched_tags_bitmap:00000000: 03
>>>>>>>>>
>>>>>>>>> with SCHED_RESTART being set:
>>>>>>>>>
>>>>>>>>> state:SCHED_RESTART
>>>>>>>>>
>>>>>>>>> and with the driver tags being idle:
>>>>>>>>>
>>>>>>>>> tags:nr_tags=1
>>>>>>>>> tags:nr_reserved_tags=0
>>>>>>>>> tags:active_queues=0
>>>>>>>>> tags:bitmap_tags:
>>>>>>>>> tags:depth=1
>>>>>>>>> tags:busy=0
>>>>>>>>> tags:bits_per_word=64
>>>>>>>>> tags:map_nr=1
>>>>>>>>> tags:alloc_hint={0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
>>>>>>>>> tags:wake_batch=1
>>>>>>>>> tags:wake_index=3
>>>>>>>>> tags:ws={
>>>>>>>>> tags:	{.wait_cnt=-48, .wait=inactive},
>>>>>>>>> tags:	{.wait_cnt=-39, .wait=inactive},
>>>>>>>>> tags:	{.wait_cnt=-50, .wait=inactive},
>>>>>>>>> tags:	{.wait_cnt=-47, .wait=inactive},
>>>>>>>>> tags:	{.wait_cnt=-25, .wait=inactive},
>>>>>>>>> tags:	{.wait_cnt=-24, .wait=inactive},
>>>>>>>>> tags:	{.wait_cnt=-47, .wait=inactive},
>>>>>>>>> tags:	{.wait_cnt=-47, .wait=inactive},
>>>>>>>>> tags:}
>>>>>>>>
>>>>>>>> Unsurprisingly (since this is sched_tags starvation) this still happens
>>>>>>>> with the patch. Same trace as above. Note that dispatch has two requests
>>>>>>>> sitting ready:
>>>>>>>>
>>>>>>>> ffff881ff5ab1000 {.op=READ, .cmd_flags=, .rq_flags=STARTED|IO_STAT, .atomic_flags=COMPLETE, .tag=-1, .internal_tag=0}
>>>>>>>> ffff881ff5ab1240 {.op=READ, .cmd_flags=, .rq_flags=STARTED|IO_STAT, .atomic_flags=COMPLETE, .tag=-1, .internal_tag=1}
>>>>>>>>
>>>>>>>> while we're blocked trying to get a new sched tag off the regular
>>>>>>>> blk_mq_make_request() path. It looks like a missing restart of the hctx.
>>>>>>>
>>>>>>> Just to keep everyone in the loop, this bug is not new to
>>>>>>> for-4.15/block, nor is it new to the current 4.41-rc or 4.13. So it's
>>>>>>> probably different to what Bart is hitting, but it's a bug none the
>>>>>>> less...
>>>>>>
>>>>>> Thanks for running this test ans share us the result.
>>>>>>
>>>>>>>
>>>>>>> To me, this looks like a race between marking the queue as needing a
>>>>>>> restart, and the driver tag being released and re-running the queue. If
>>>>>>> I do:
>>>>>>>
>>>>>>> # echo run > /sys/kernel/debug/block/nullb1/state
>>>>>>>
>>>>>>> then it starts just fine. So there must be a race between marking the
>>>>>>> need for a restart (when getting the driver tag fails), and when one of
>>>>>>> the shared tag queues finishes a request and releases the driver tag.
>>>>>>
>>>>>> Just one hint, blk-mq's RESTART won't work if no requests are pending,
>>>>>> but looks no efficient/reliable way to handle that.
>>>>>
>>>>> Requests are pending, see above output. My assumption/theory was that
>>>>> we were racing on setting restart. Simplified version:
>>>>>
>>>>> CPUX					CPUY
>>>>> get_driver_tag, fails
>>>>> 					complete request, put tag
>>>>> 					check restart, not set
>>>>> mark needing restart
>>>>
>>>> This case should be covered by TAG_WAITING.
>>>
>>> Right. The keyword here being 'should'.
>>>
>>>> If get_driver_tag fails on CPUX, this hctx will be added to tags's wait
>>>> queue, then the 'complete request' on CPUY will trigger to run queue via
>>>> blk_mq_dispatch_wake().
>>>
>>> I know how it's _supposed_ to work. I'm saying that the debug info
>>> indicates that we have a problem in there, which matches what the
>>> TAG_WAITING should be covering for us. The TAG_WAITING may be fine and
>>> the issue could be somewhere else, it just looks identical for now.
>>
>> One possible reason:
>>
>> 	- the request to be dispatched may not be added to hctx->dispatch
>> 	when blk_mq_dispatch_wake() is triggered.
> 
> If we call blk_mq_dispatch_wait_add() after request is added to hctx->dispatch,
> TAG_WAITING becomes basically similar with SCHED_RESTART.
> 
> Now I don't object to revert 358a3a6bccb7(blk-mq: don't handle TAG_SHARED in restart)
> any more, because SCHED_RESTART works fine from this viewpoint even
> though it isn't efficient. We can improve it in the future.
> 
> Also we might need to unify both TAG_WAITING and SCHED_RESTART into one generic
> restart mechanism, and make it efficient. IMO, both two aren't efficient enough.

This patch works for me, I don't see any more stalls after this happens.
On another positive note, for my 4 device test case, it also bumps the
per-device performance from (run where it actually finished):

nullb0: (groupid=0, jobs=1): err= 0: pid=3540: Wed Nov  8 10:57:43 2017
   read: IOPS=73.6k, BW=288MiB/s (302MB/s)(84.3GiB/300001msec)
    slat (nsec): min=1214, max=911980, avg=12070.86, stdev=15586.24
    clat (nsec): min=1637, max=1011.2k, avg=41375.87, stdev=28103.51
     lat (usec): min=7, max=1045, avg=53.56, stdev=32.30
    clat percentiles (usec):
     |  1.00th=[   11],  5.00th=[   14], 10.00th=[   17], 20.00th=[   21],
     | 30.00th=[   26], 40.00th=[   30], 50.00th=[   35], 60.00th=[   41],
     | 70.00th=[   47], 80.00th=[   56], 90.00th=[   73], 95.00th=[   95],
     | 99.00th=[  149], 99.50th=[  161], 99.90th=[  190], 99.95th=[  204],
     | 99.99th=[  258]
   bw (  KiB/s): min=223672, max=368880, per=24.76%, avg=294699.27, stdev=45893.24, samples=599
   iops        : min=55918, max=92220, avg=73674.76, stdev=11473.32, samples=599
  lat (usec)   : 2=0.01%, 10=0.89%, 20=17.13%, 50=56.13%, 100=21.42%
  lat (usec)   : 250=4.42%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=0.01%
  cpu          : usr=7.84%, sys=52.94%, ctx=9763310, majf=0, minf=14

to

nullb3: (groupid=0, jobs=1): err= 0: pid=3128: Wed Nov  8 11:08:18 2017
   read: IOPS=215k, BW=841MiB/s (882MB/s)(246GiB/300001msec)
    slat (nsec): min=1335, max=739184, avg=3920.20, stdev=2561.74
    clat (nsec): min=1039, max=763200, avg=14229.43, stdev=5382.08
     lat (usec): min=3, max=772, avg=18.20, stdev= 6.34
    clat percentiles (nsec):
     |  1.00th=[ 7712],  5.00th=[ 9408], 10.00th=[10048], 20.00th=[10816],
     | 30.00th=[12096], 40.00th=[12864], 50.00th=[13504], 60.00th=[14400],
     | 70.00th=[15552], 80.00th=[16768], 90.00th=[18816], 95.00th=[21632],
     | 99.00th=[29312], 99.50th=[31872], 99.90th=[37120], 99.95th=[41216],
     | 99.99th=[63232]
   bw (  KiB/s): min=658704, max=1012880, per=26.09%, avg=861735.73, stdev=63136.40, samples=599
   iops        : min=164676, max=253220, avg=215433.91, stdev=15784.07, samples=599
  lat (usec)   : 2=0.01%, 4=0.01%, 10=9.52%, 20=83.55%, 50=6.91%
  lat (usec)   : 100=0.02%, 250=0.01%, 750=0.01%, 1000=0.01%
  cpu          : usr=13.23%, sys=56.78%, ctx=33334423, majf=0, minf=14

which is a massive win on all metrics.

Patch on top of current for-4.15/block


diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 7f4a1ba532af..bb7f08415203 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -179,7 +179,6 @@ static const char *const hctx_state_name[] = {
 	HCTX_STATE_NAME(STOPPED),
 	HCTX_STATE_NAME(TAG_ACTIVE),
 	HCTX_STATE_NAME(SCHED_RESTART),
-	HCTX_STATE_NAME(TAG_WAITING),
 	HCTX_STATE_NAME(START_ON_RUN),
 };
 #undef HCTX_STATE_NAME
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3d759bb8a5bb..adb6c8bceb7c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1005,42 +1005,53 @@ static int blk_mq_dispatch_wake(wait_queue_entry_t *wait, unsigned mode, int fla
 
 	hctx = container_of(wait, struct blk_mq_hw_ctx, dispatch_wait);
 
-	list_del(&wait->entry);
-	clear_bit_unlock(BLK_MQ_S_TAG_WAITING, &hctx->state);
+	list_del_init(&wait->entry);
 	blk_mq_run_hw_queue(hctx, true);
 	return 1;
 }
 
-static bool blk_mq_dispatch_wait_add(struct blk_mq_hw_ctx *hctx)
+static bool blk_mq_dispatch_wait_add(struct blk_mq_hw_ctx **hctx,
+				     struct request *rq)
 {
+	wait_queue_entry_t *wait = &(*hctx)->dispatch_wait;
 	struct sbq_wait_state *ws;
 
-	/*
-	 * The TAG_WAITING bit serves as a lock protecting hctx->dispatch_wait.
-	 * The thread which wins the race to grab this bit adds the hardware
-	 * queue to the wait queue.
-	 */
-	if (test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state) ||
-	    test_and_set_bit_lock(BLK_MQ_S_TAG_WAITING, &hctx->state))
+	if (!list_empty_careful(&wait->entry))
 		return false;
 
-	init_waitqueue_func_entry(&hctx->dispatch_wait, blk_mq_dispatch_wake);
-	ws = bt_wait_ptr(&hctx->tags->bitmap_tags, hctx);
+	spin_lock(&(*hctx)->lock);
+	if (!list_empty(&wait->entry)) {
+		spin_unlock(&(*hctx)->lock);
+		return false;
+	}
+
+	init_waitqueue_func_entry(wait, blk_mq_dispatch_wake);
+	ws = bt_wait_ptr(&(*hctx)->tags->bitmap_tags, *hctx);
+	add_wait_queue(&ws->wait, wait);
+	spin_unlock(&(*hctx)->lock);
 
 	/*
-	 * As soon as this returns, it's no longer safe to fiddle with
-	 * hctx->dispatch_wait, since a completion can wake up the wait queue
-	 * and unlock the bit.
+	 * It's possible that a tag was freed in the window between the
+	 * allocation failure and adding the hardware queue to the wait
+	 * queue. If we can get a tag now, remove ourselves from the
+	 * wait queue to ensure someone else gets the wakeup.
 	 */
-	add_wait_queue(&ws->wait, &hctx->dispatch_wait);
-	return true;
+	if (blk_mq_get_driver_tag(rq, hctx, false)) {
+		spin_lock_irq(&ws->wait.lock);
+		list_del_init(&wait->entry);
+		spin_unlock_irq(&ws->wait.lock);
+		return true;
+	}
+
+	return false;
 }
 
 bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
-		bool got_budget)
+			     bool got_budget)
 {
 	struct blk_mq_hw_ctx *hctx;
 	struct request *rq, *nxt;
+	bool failed_tag = false;
 	int errors, queued;
 
 	if (list_empty(list))
@@ -1062,20 +1073,10 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 			 * The initial allocation attempt failed, so we need to
 			 * rerun the hardware queue when a tag is freed.
 			 */
-			if (!blk_mq_dispatch_wait_add(hctx)) {
-				if (got_budget)
-					blk_mq_put_dispatch_budget(hctx);
-				break;
-			}
-
-			/*
-			 * It's possible that a tag was freed in the window
-			 * between the allocation failure and adding the
-			 * hardware queue to the wait queue.
-			 */
-			if (!blk_mq_get_driver_tag(rq, &hctx, false)) {
+			if (!blk_mq_dispatch_wait_add(&hctx, rq)) {
 				if (got_budget)
 					blk_mq_put_dispatch_budget(hctx);
+				failed_tag = true;
 				break;
 			}
 		}
@@ -1140,10 +1141,11 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		 * it is no longer set that means that it was cleared by another
 		 * thread and hence that a queue rerun is needed.
 		 *
-		 * If TAG_WAITING is set that means that an I/O scheduler has
-		 * been configured and another thread is waiting for a driver
-		 * tag. To guarantee fairness, do not rerun this hardware queue
-		 * but let the other thread grab the driver tag.
+		 * If 'failed_tag' is set, that means that we failed getting
+		 * a driver tag with an I/O scheduler attached. Ensure that
+		 * we run the queue AFTER adding our entries back to the list,
+		 * so we don't stall if the queue run and wakeup happened
+		 * before we got here.
 		 *
 		 * If no I/O scheduler has been configured it is possible that
 		 * the hardware queue got stopped and restarted before requests
@@ -1155,8 +1157,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		 *   returning BLK_STS_RESOURCE. Two exceptions are scsi-mq
 		 *   and dm-rq.
 		 */
-		if (!blk_mq_sched_needs_restart(hctx) &&
-		    !test_bit(BLK_MQ_S_TAG_WAITING, &hctx->state))
+		if (!blk_mq_sched_needs_restart(hctx) || failed_tag)
 			blk_mq_run_hw_queue(hctx, true);
 	}
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 674641527da7..2f0036b977a9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -181,8 +181,7 @@ enum {
 	BLK_MQ_S_STOPPED	= 0,
 	BLK_MQ_S_TAG_ACTIVE	= 1,
 	BLK_MQ_S_SCHED_RESTART	= 2,
-	BLK_MQ_S_TAG_WAITING	= 3,
-	BLK_MQ_S_START_ON_RUN	= 4,
+	BLK_MQ_S_START_ON_RUN	= 3,
 
 	BLK_MQ_MAX_DEPTH	= 10240,
 

-- 
Jens Axboe
