From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH] scsi: Set queue limits no_cluster for stacked devices
Date: Tue, 23 Nov 2010 13:56:50 -0800
Message-ID: <201011231356497405397@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:23738 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750943Ab0KWV5O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 16:57:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: promise_linux <promise_linux@promise.com>, dm-devel <dm-devel@redhat.com>

When a dm is created, it will adjust queue limits from underlying
devices. If the no_cluster member is not set, QUEUE_FLAG_CLUSTER
will be set. When a bio is constructed, QUEUE_FLAG_CLUSTER enables
segment merge, and neighboring mergeable segments are counted as
only one segment. Later, however, when the request is mapped to
scatterlist, if the underlying (scsi) device does not enable
clustering, the mergeable segments will be separated, and unexpected
sg count surge follows. If the original segment count is around the
max_hw_segments (sg_tablesize) limit, the final sg count could break
the limit due to the extra addition. This is caused by mismatch of
cluster settings between dm and underlying device.

The dm layer already has function to adjust limits based on underlying
device limits. So, it is necessary to set queue limits no_cluster at
scsi side, to eliminate the discrepancy.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---
 drivers/scsi/scsi_lib.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -purN a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2010-11-23 11:46:04.000000000 -0800
+++ b/drivers/scsi/scsi_lib.c	2010-11-23 11:49:22.000000000 -0800
@@ -1643,8 +1643,10 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
 
 	/* New queue, no concurrency on queue_flags */
-	if (!shost->use_clustering)
+	if (!shost->use_clustering) {
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
+		q->limits.no_cluster = 1;
+	}
 
 	/*
 	 * set a reasonable default alignment on word boundaries: the


