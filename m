From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 11/18] scsi xcopy: keep cache of failures
Date: Wed, 22 Oct 2014 09:29:54 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410220929260.31351@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbaJVNaU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2014 09:30:20 -0400
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Jonathan Brassow <jbrassow@redhat.com>, Edward Thornber <thornber@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

If xcopy between two devices fails, it is pointless to send more xcopy
command between there two devices because they take time and they will
likely also fail.

This patch keeps a cache of (source_device,destination_device) pairs where
copying failed and makes sure that no xcopy command is sooner than 30
seconds after the last failure.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/scsi/sd.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux-3.18-rc1/drivers/scsi/sd.c
===================================================================
--- linux-3.18-rc1.orig/drivers/scsi/sd.c	2014-10-21 00:49:21.000000000 +0200
+++ linux-3.18-rc1/drivers/scsi/sd.c	2014-10-21 00:49:24.000000000 +0200
@@ -943,6 +943,26 @@ static void sd_config_copy(struct scsi_d
 				   (logical_block_size >> 9));
 }
 
+#define SD_COPY_DISABLED_CACHE_TIME		(HZ * 30)
+#define SD_COPY_DISABLED_CACHE_HASH_BITS	6
+#define SD_COPY_DISABLED_CACHE_HASH		(1 << SD_COPY_DISABLED_CACHE_HASH_BITS)
+
+struct sd_copy_disabled_cache_entry {
+	struct scsi_device *src;
+	struct scsi_device *dst;
+	unsigned long jiffies;
+};
+
+static struct sd_copy_disabled_cache_entry sd_copy_disabled_cache[SD_COPY_DISABLED_CACHE_HASH];
+
+static struct sd_copy_disabled_cache_entry *sd_copy_disabled_cache_hash(
+	struct scsi_device *src, struct scsi_device *dst)
+{
+	return &sd_copy_disabled_cache[
+		hash_long((unsigned long)src + ((unsigned long)dst >> 1), SD_COPY_DISABLED_CACHE_HASH_BITS)
+	];
+}
+
 static int sd_setup_copy_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -955,6 +975,7 @@ static int sd_setup_copy_cmnd(struct scs
 	struct bio *bio = rq->bio;
 	struct page *page;
 	unsigned char *buf;
+	struct sd_copy_disabled_cache_entry *e;
 
 	dst_sdp = scsi_disk(rq->rq_disk)->device;
 	dst_queue = rq->rq_disk->queue;
@@ -974,6 +995,12 @@ static int sd_setup_copy_cmnd(struct scs
 	if (src_sdp->sector_size != dst_sdp->sector_size)
 		return BLKPREP_KILL;
 
+	/* The copy failed in the past, so do not retry it for some time */
+	e = sd_copy_disabled_cache_hash(src_sdp, dst_sdp);
+	if (unlikely(jiffies - ACCESS_ONCE(e->jiffies) < SD_COPY_DISABLED_CACHE_TIME) &&
+	    likely(ACCESS_ONCE(e->src) == src_sdp) && likely(ACCESS_ONCE(e->dst) == dst_sdp))
+		return BLKPREP_KILL;
+
 	dst_lba = blk_rq_pos(rq) >> (ilog2(dst_sdp->sector_size) - 9);
 	src_lba = bio->bi_copy->pair[0]->bi_iter.bi_sector >> (ilog2(src_sdp->sector_size) - 9);
 	nr_blocks = blk_rq_sectors(rq) >> (ilog2(dst_sdp->sector_size) - 9);
@@ -1937,11 +1964,19 @@ static int sd_done(struct scsi_cmnd *SCp
 			}
 		} else if (sshdr.asc == 0x26) {
 			switch (op) {
+				struct sd_copy_disabled_cache_entry *e;
+				struct scsi_device *src_sdp, *dst_sdp;
 			/*
 			 * Copying between two arrays that support XCOPY, but
 			 * cannot access each other.
 			 */
 			case EXTENDED_COPY:
+				dst_sdp = sdkp->device;
+				src_sdp = scsi_disk(req->bio->bi_copy->pair[0]->bi_bdev->bd_disk)->device;
+				e = sd_copy_disabled_cache_hash(src_sdp, dst_sdp);
+				ACCESS_ONCE(e->src) = src_sdp;
+				ACCESS_ONCE(e->dst) = dst_sdp;
+				ACCESS_ONCE(e->jiffies) = jiffies;
 				good_bytes = 0;
 				req->__data_len = blk_rq_bytes(req);
 				req->cmd_flags |= REQ_QUIET;

