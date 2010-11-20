From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: QUEUE_FLAG_CLUSTER?
Date: Fri, 19 Nov 2010 17:24:14 -0800
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F049D4EB8@nonamew.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:63421 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753694Ab0KTBj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 20:39:27 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dm-devel@redhat.com, Promise_Linux <Promise_Linux@promise.com>

Hello,

When a dm is created, it will adjust queue limits from underlying
devices.
If the no_cluster member is not set, QUEUE_FLAG_CLUSTER will be set.
When a bio is constructed, QUEUE_FLAG_CLUSTER enables segment
merge. Later, however, when the request is mapped to scatterlist, if the
underlying (scsi) device does not enable clustering, the mergeable
segments
will be separated, and unexpected sg count surge follows. If the segment
count is around the limit,  the final sg count could break the limit due
to the
extra addition. This is caused by mismatch of cluster setting between dm
and underlying devices.

For the stex driver, this problem was made obvious when code in
blk_set_default_limits() (block/blk-settings.c) was changed from
	lim->max_sectors = lim->max_hw_sectors = SAFE_MAX_SECTORS;
in 2.6.31, to
	lim->max_sectors = BLK_DEF_MAX_SECTORS;
	lim->max_hw_sectors = INT_MAX;
in 2.6.32.

The dm already has function to adjust limits based on underlying device
limits. So, is it good to add the no_cluster setting to the queue limits
at the scsi side? For example, some code change like the following?

Thanks,
Ed Lin


diff -rupN a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	2010-11-19 16:45:56.000000000 -0800
+++ b/drivers/scsi/scsi_lib.c	2010-11-19 16:46:27.000000000 -0800
@@ -1641,8 +1641,10 @@ struct request_queue *__scsi_alloc_queue
 	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
 
 	/* New queue, no concurrency on queue_flags */
-	if (!shost->use_clustering)
+	if (!shost->use_clustering) {
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
+		q->limits.no_cluster = 1;
+	}
 
 	/*
 	 * set a reasonable default alignment on word boundaries: the
