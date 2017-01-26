From: Jens Axboe <axboe@fb.com>
Subject: Re: split scsi passthrough fields out of struct request V2
Date: Thu, 26 Jan 2017 11:44:15 -0700
Message-ID: <e8f4b084-be66-d5b3-5785-13b80642040f@fb.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
 <1485455329.2540.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1485455329.2540.7.camel@sandisk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "hch@lst.de" <hch@lst.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On 01/26/2017 11:29 AM, Bart Van Assche wrote:
> On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
>> Hi all,
>>
>> this series splits the support for SCSI passthrough commands from the
>> main struct request used all over the block layer into a separate
>> scsi_request structure that drivers that want to support SCSI passthough
>> need to embedded as the first thing into their request-private data,
>> similar to how we handle NVMe passthrough commands.
>>
>> To support this I've added support for that the private data after
>> request structure to the legacy request path instead, so that it can
>> be treated the same way as the blk-mq path.  Compare to the current
>> scsi_cmnd allocator that actually is a major simplification.
>>
>> Changes since V1:
>>  - fix handling of a NULL sense pointer in __scsi_execute
>>  - clean up handling of the flush flags in the block layer and MD
>>  - additional small cleanup in dm-rq
> 
> Hello Christoph,
> 
> Thanks for having fixed the NULL pointer issue I had reported for v1.
> However, if I try to run my srp-test testsuite on top of your
> hch-block/block-pc-refactor branch (commit ID a07dc3521034) merged
> with v4.10-rc5 the following appears on the console:

I think this may be my bug - does the below help?


diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index d05061f27bb1..56b92db944ae 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -117,7 +117,7 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
 	ctx = blk_mq_get_ctx(q);
 	hctx = blk_mq_map_queue(q, ctx->cpu);
 
-	blk_mq_set_alloc_data(data, q, 0, ctx, hctx);
+	blk_mq_set_alloc_data(data, q, data->flags, ctx, hctx);
 
 	if (e) {
 		data->flags |= BLK_MQ_REQ_INTERNAL;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index dcb567642db7..9e4ed04f398c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -253,7 +253,7 @@ EXPORT_SYMBOL_GPL(__blk_mq_alloc_request);
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		unsigned int flags)
 {
-	struct blk_mq_alloc_data alloc_data;
+	struct blk_mq_alloc_data alloc_data = { .flags = flags };
 	struct request *rq;
 	int ret;
 
@@ -1382,7 +1382,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = op_is_sync(bio->bi_opf);
 	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
-	struct blk_mq_alloc_data data;
+	struct blk_mq_alloc_data data = { 0, };
 	struct request *rq;
 	unsigned int request_count = 0, srcu_idx;
 	struct blk_plug *plug;
@@ -1504,7 +1504,7 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
-	struct blk_mq_alloc_data data;
+	struct blk_mq_alloc_data data = { 0, };
 	struct request *rq;
 	blk_qc_t cookie;
 	unsigned int wb_acct;

-- 
Jens Axboe

