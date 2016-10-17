From: Adam Manzanares <adam.manzanares@hgst.com>
Subject: [PATCH v6 1/3] block: Add iocontext priority to request
Date: Mon, 17 Oct 2016 11:27:28 -0700
Message-ID: <1476728850-2309-2-git-send-email-adam.manzanares@hgst.com>
References: <1476728850-2309-1-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1476728850-2309-1-git-send-email-adam.manzanares@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, tj@kernel.org, dan.j.williams@intel.com, hare@suse.de, martin.petersen@oracle.com, mchristi@redhat.com, toshi.kani@hpe.com, ming.lei@canonical.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@hgst.com>, Adam Manzananares <adam.manzanares@wdc.com>
List-Id: linux-scsi@vger.kernel.org

Patch adds an association between iocontext ioprio and the ioprio of a
request. This is done to enable request based drivers the ability to
act on priority information stored in the request. An example being
ATA devices that support command priorities. If the ATA driver discovers
that the device supports command priorities and the request has valid
priority information indicating the request is high priority, then a high
priority command can be sent to the device. This should improve tail
latencies for high priority IO on any device that queues requests
internally and can make use of the priority information stored in the
request.

The ioprio of the request is set in blk_rq_set_prio which takes the
request and the ioc as arguments. If the ioc is valid in blk_rq_set_prio
then the iopriority of the request is set as the iopriority of the ioc.
In init_request_from_bio a check is made to see if the ioprio of the bio
is valid and if so then the request prio comes from the bio.

Signed-off-by: Adam Manzananares <adam.manzanares@wdc.com>
---
 block/blk-core.c       |  4 +++-
 include/linux/blkdev.h | 14 ++++++++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 14d7c07..361b1b9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1153,6 +1153,7 @@ static struct request *__get_request(struct request_list *rl, int op,
 
 	blk_rq_init(q, rq);
 	blk_rq_set_rl(rq, rl);
+	blk_rq_set_prio(rq, ioc);
 	req_set_op_attrs(rq, op, op_flags | REQ_ALLOCED);
 
 	/* init elvpriv */
@@ -1656,7 +1657,8 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 
 	req->errors = 0;
 	req->__sector = bio->bi_iter.bi_sector;
-	req->ioprio = bio_prio(bio);
+	if (ioprio_valid(bio_prio(bio)))
+		req->ioprio = bio_prio(bio);
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c47c358..9a0ceaa 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -934,6 +934,20 @@ static inline unsigned int blk_rq_count_bios(struct request *rq)
 }
 
 /*
+ * blk_rq_set_prio - associate a request with prio from ioc
+ * @rq: request of interest
+ * @ioc: target iocontext
+ *
+ * Assocate request prio with ioc prio so request based drivers
+ * can leverage priority information.
+ */
+static inline void blk_rq_set_prio(struct request *rq, struct io_context *ioc)
+{
+	if (ioc)
+		rq->ioprio = ioc->ioprio;
+}
+
+/*
  * Request issue related functions.
  */
 extern struct request *blk_peek_request(struct request_queue *q);
-- 
2.1.4

