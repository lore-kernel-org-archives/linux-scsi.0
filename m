From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: kernel BUG at drivers/scsi/scsi_error.c:197! - git
 4.17.0-x64-08428-g7d3bf613e99a
Date: Wed, 13 Jun 2018 12:03:47 +0800
Message-ID: <5ca74fb7-af70-31c3-0e3f-bace058e5a57@oracle.com>
References: <201806091606.51078.randrianasulu@gmail.com>
 <025bf705-15b0-65e5-4b16-6c91d41c1730@infradead.org>
 <40617b19667b3c1302f8a903c19f2fa2f409b12a.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------EE67CD2F84B4B38487383716"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <40617b19667b3c1302f8a903c19f2fa2f409b12a.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "randrianasulu@gmail.com" <randrianasulu@gmail.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hch@lst.de" <hch@lst.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------EE67CD2F84B4B38487383716
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit



On 06/12/2018 11:28 PM, Bart Van Assche wrote:
> On Sat, 2018-06-09 at 08:02 -0700, Randy Dunlap wrote:
>> On 06/09/2018 06:06 AM, Andrew Randrianasulu wrote:
>>> Hello, everyone!
>>>
>>> I was trying to test not-yet-completed 4.18-rc1, and run into this bug, probably 
>>> due to HAL (yes, I still use this) trying to poll empty DVD-RW drive:
>>>
>>> [   35.040167] ------------[ cut here ]------------
>>> [   35.040171] kernel BUG at drivers/scsi/scsi_error.c:197!
>>> [   35.040196] invalid opcode: 0000 [#1] SMP NOPTI
>>> [   35.040210] CPU: 2 PID: 117 Comm: kworker/2:1H Not tainted 
>>> 4.17.0-x64-08428-g7d3bf613e99a-dirty #18
>>> [   35.040225] Hardware name: MSI MS-7693/970A-G46 (MS-7693), BIOS V2.8 
>>> 01/08/2016
>>> [   35.040244] Workqueue: kblockd blk_mq_timeout_work
>>> [   35.040283] RIP: 0010:scsi_times_out+0xe9/0x1a6 [scsi_mod]
>>> [   35.040287] Code: 03 76 18 48 c7 c2 f9 c2 01 a0 48 89 ee 48 c7 c7 14 be 01 a0 
>>> 31 c0 e8 76 ad 00 00 48 8b 83 98 01 00 00 a8 01 0f 84 a5 00 00 00 <0f> 0b 49 8b 
>>> 7c 24 38 e8 8f ba 4b e1 41 83 bc 24 2c 01
>>>  00 00 ff 74
>>> [   35.040312] RSP: 0018:ffffc90000293d98 EFLAGS: 00010202
>>> [   35.040318] RAX: ffff88031f240605 RBX: ffff88031eed8500 RCX: 00000000fffefd40
>>> [   35.040323] RDX: ffffc90000293e80 RSI: 0000000000002007 RDI: ffff88031eed8638
>>> [   35.040327] RBP: ffff88031eed8638 R08: ffff88031eed85d8 R09: 0000000000000000
>>> [   35.040332] R10: 0000000000000040 R11: fefefefefefefeff R12: ffff88031f2a8800
>>> [   35.040336] R13: ffff88031f2a8800 R14: ffff88031f29e910 R15: 0000000000000001
>>> [   35.040341] FS:  0000000000000000(0000) GS:ffff88032ed00000(0000) 
>>> knlGS:0000000000000000
>>> [   35.040346] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [   35.040350] CR2: 00000000f7ea83c0 CR3: 000000031e194000 CR4: 00000000000406e0
>>> [   35.040354] Call Trace:
>>> [   35.040360]  blk_mq_check_expired+0xdc/0x10c
>>> [   35.040365]  bt_iter+0x42/0x45
>>> [   35.040369]  __sbitmap_for_each_set.constprop.12+0x83/0xac
>>> [   35.040374]  ? blk_mq_update_nr_requests+0xad/0xad
>>> [   35.040595]  ? blk_mq_exit_hctx+0xda/0xda
>>> [   35.041595]  blk_mq_queue_tag_busy_iter+0xa3/0xb4
>>> [   35.042578]  ? blk_mq_exit_hctx+0xda/0xda
>>> [   35.043550]  blk_mq_timeout_work+0x6b/0xca
>>> [   35.044505]  process_one_work+0x17c/0x2a6
>>> [   35.045445]  worker_thread+0x19f/0x243
>>> [   35.046393]  ? rescuer_thread+0x262/0x262
>>> [   35.047346]  kthread+0x100/0x108
>>> [   35.048290]  ? kthread_destroy_worker+0x3e/0x3e
>>> [   35.049242]  ret_from_fork+0x27/0x50
>>> [   35.050192] Modules linked in: bridge stp llc bnep rfcomm hidp snd_aloop ipv6 
.....
> Is this something that happens systematically or sporadically? Additionally,
> have you verified whether or not this can be triggered with kernel v4.17? I'm
> wondering whether or not this is a regression that was introduced in the merge
> window.
> 

I suspect this is due to we could expire a same request twice or even more.
For scsi mid-layer, it return BLK_EH_DONE from .timeout, in fact, the request is not
completed there, but just queue a delayed abort_work (HZ/100). If the blk_mq_timeout_work
runs again before the abort_work, the request will be timed out again, because there is not
any mark on it to identify this request has been timed out.

Would please try the patch attached on to see whether this issue could be fixed ?
(this patch only works for scsi device currently)

Thanks
Jianchao
 

--------------EE67CD2F84B4B38487383716
Content-Type: text/x-patch;
 name="0001-blk-mq-protect-timed-out-request-against-completion-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-blk-mq-protect-timed-out-request-against-completion-.pa";
 filename*1="tch"

>From fcc515b3a642c909e8b82d2a240014faff5acd44 Mon Sep 17 00:00:00 2001
From: Jianchao Wang <jianchao.w.wang@oracle.com>
Date: Tue, 12 Jun 2018 21:20:13 +0800
Subject: [PATCH] blk-mq: protect timed out request against completion path

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 block/blk-mq.c         | 22 +++++++++++++++-------
 include/linux/blk-mq.h |  1 +
 include/linux/blkdev.h |  6 ++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6332940..2714a23 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -473,6 +473,7 @@ static void __blk_mq_free_request(struct request *rq)
 	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
 	const int sched_tag = rq->internal_tag;
 
+	WRITE_ONCE(rq->state, MQ_RQ_IDLE);
 	if (rq->tag != -1)
 		blk_mq_put_tag(hctx, hctx->tags, ctx, rq->tag);
 	if (sched_tag != -1)
@@ -509,7 +510,6 @@ void blk_mq_free_request(struct request *rq)
 	if (blk_rq_rl(rq))
 		blk_put_rl(blk_rq_rl(rq));
 
-	WRITE_ONCE(rq->state, MQ_RQ_IDLE);
 	if (refcount_dec_and_test(&rq->ref))
 		__blk_mq_free_request(rq);
 }
@@ -552,15 +552,17 @@ static void __blk_mq_complete_request_remote(void *data)
 	rq->q->softirq_done_fn(rq);
 }
 
-static void __blk_mq_complete_request(struct request *rq)
+/*
+ * The LLDD timeout path must invoke this interface to complete
+ * the request.
+ */
+void __blk_mq_complete_request(struct request *rq)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	bool shared = false;
 	int cpu;
 
-	if (cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) !=
-			MQ_RQ_IN_FLIGHT)
-		return;
+	WARN_ON(blk_mq_rq_state(rq) != MQ_RQ_COMPLETE);
 
 	if (rq->internal_tag != -1)
 		blk_mq_sched_completed_request(rq);
@@ -584,6 +586,7 @@ static void __blk_mq_complete_request(struct request *rq)
 	}
 	put_cpu();
 }
+EXPORT_SYMBOL(__blk_mq_complete_request);
 
 static void hctx_unlock(struct blk_mq_hw_ctx *hctx, int srcu_idx)
 	__releases(hctx->srcu)
@@ -617,7 +620,9 @@ void blk_mq_complete_request(struct request *rq)
 {
 	if (unlikely(blk_should_fake_timeout(rq->q)))
 		return;
-	__blk_mq_complete_request(rq);
+
+	if (blk_mq_mark_rq_complete(rq))
+		__blk_mq_complete_request(rq);
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
@@ -779,6 +784,7 @@ static void blk_mq_rq_timed_out(struct request *req, bool reserved)
 		WARN_ON_ONCE(ret != BLK_EH_RESET_TIMER);
 	}
 
+	WRITE_ONCE(req->state, MQ_RQ_IDLE);
 	blk_add_timer(req);
 }
 
@@ -830,8 +836,10 @@ static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 	 * expired; if it is not expired, then the request was completed and
 	 * reallocated as a new request.
 	 */
-	if (blk_mq_req_expired(rq, next))
+	if (blk_mq_req_expired(rq, next) &&
+		blk_mq_mark_rq_complete(rq)) {
 		blk_mq_rq_timed_out(rq, reserved);
+	}
 	if (refcount_dec_and_test(&rq->ref))
 		__blk_mq_free_request(rq);
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index fb35517..10a496b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -259,6 +259,7 @@ void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
 void blk_mq_complete_request(struct request *rq);
+void __blk_mq_complete_request(struct request *rq);
 bool blk_mq_bio_list_merge(struct request_queue *q, struct list_head *list,
 			   struct bio *bio);
 bool blk_mq_queue_stopped(struct request_queue *q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bca3a92..4c8b29a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -270,6 +270,12 @@ struct request {
 #endif
 };
 
+static inline bool blk_mq_mark_rq_complete(struct request *rq)
+{
+	return (cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
+			MQ_RQ_IN_FLIGHT);
+}
+
 static inline bool blk_op_is_scsi(unsigned int op)
 {
 	return op == REQ_OP_SCSI_IN || op == REQ_OP_SCSI_OUT;
-- 
2.7.4


--------------EE67CD2F84B4B38487383716--
