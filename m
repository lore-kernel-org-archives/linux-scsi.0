From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.18 229/235] blk-mq: avoid to synchronize rcu inside blk_cleanup_queue()
Date: Mon, 24 Sep 2018 13:53:35 +0200
Message-ID: <20180924113125.837160833@linuxfoundation.org>
References: <20180924113103.999624566@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180924113103.999624566@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Andrew Jones <drjones@redhat.com>, Omar Sandoval <osandov@fb.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

4.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 1311326cf4755c7ffefd20f576144ecf46d9906b ]

SCSI probing may synchronously create and destroy a lot of request_queues
for non-existent devices. Any synchronize_rcu() in queue creation or
destroy path may introduce long latency during booting, see detailed
description in comment of blk_register_queue().

This patch removes one synchronize_rcu() inside blk_cleanup_queue()
for this case, commit c2856ae2f315d75(blk-mq: quiesce queue before freeing queue)
needs synchronize_rcu() for implementing blk_mq_quiesce_queue(), but
when queue isn't initialized, it isn't necessary to do that since
only pass-through requests are involved, no original issue in
scsi_execute() at all.

Without this patch and previous one, it may take more 20+ seconds for
virtio-scsi to complete disk probe. With the two patches, the time becomes
less than 100ms.

Fixes: c2856ae2f315d75 ("blk-mq: quiesce queue before freeing queue")
Reported-by: Andrew Jones <drjones@redhat.com>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Tested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -791,9 +791,13 @@ void blk_cleanup_queue(struct request_qu
 	 * make sure all in-progress dispatch are completed because
 	 * blk_freeze_queue() can only complete all requests, and
 	 * dispatch may still be in-progress since we dispatch requests
-	 * from more than one contexts
+	 * from more than one contexts.
+	 *
+	 * No need to quiesce queue if it isn't initialized yet since
+	 * blk_freeze_queue() should be enough for cases of passthrough
+	 * request.
 	 */
-	if (q->mq_ops)
+	if (q->mq_ops && blk_queue_init_done(q))
 		blk_mq_quiesce_queue(q);
 
 	/* for synchronous bio-based driver finish in-flight integrity i/o */
