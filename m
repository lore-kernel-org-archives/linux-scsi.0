Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208822;
	b=TnmcKTngMFnHAG/4zqy1+iYj3c9CZXJfWMDl+4yRKX9f2hqkwxUWABenZVNC5ldZ3adN
	 SDVEQgp2/tB4kXXo2YOm2DUUCqR7dMjWoJeazVbDhZq4yqX9qUKeTgqneFGB7PTWrh25w
	 cFeNopH6Jcg4GkD/35cri0CDCn9sSm8ANgQ+3oiCP5W/j9YH8kkVAJsxlczNKHVBddapY
	 lqN/CQFNsE4eg4CN1okL1Rxw6D+A6YTkgImS9jNuk5VrFI3Yz21CwWfxslGhCMDpizxoQ
	 9yTEeCekdLXhGBQ7OD9rwuxrDCnSZY9z7OVVHX/a2vV6cSud07CinlVt3G3RSbKshGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208822;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BPEB+RryEGNmTDREnj2tmiHHy3y5IabmZioZ8RtffH4=;
	b=QU2qjsWjw2aXdS/q/gAWo7mns0+1PQ3lE1tgeUpMt3dyzE012ucUCiHPHIhO+YUC/SZv
	 8UL9N8Xsf0ghL9udI1X157BCd1ziDWGiKEJMRQlumg3yMEBDENZuLmHlZwhTdi0osHEQQ
	 G+EedVLrvu8Ef2g42vXj5DVrvSVJnkYQ056lsq/BghMq1KjcS74HeaOXq4gV5NMUv7Zv+
	 cWd4aS1xdUTSZAXMTExD4Zh+uXlW7s8xVpYLtahjL3Fq2c8WcRidzsM+VJuX1ZjJcIagn
	 Zv/ekGznvQlg0D71MxYFfwLKbSk1iHAePbyNNVsmfWu6EJjGOhNkHup6oqrOOXGT2Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="G7+1/Vpi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C46D606A68B;
	Fri, 20 Nov 2026 21:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G7+1/Vpi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF481F000C0;
	Fri, 20 Nov 2026 21:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208821;
	bh=BPEB+RryEGNmTDREnj2tmiHHy3y5IabmZioZ8RtffH4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=G7+1/VpixX1nj1uPYRRPZN/+7tny/woEn3Q4SUUmy1urpotaRhjXZ3GBJWFbofMJ2
	 PjAv8UmYq3Wr1fa3qdRiWyiNXbwzUGh/PNH9/xwS2zcw5zTQjKmaFyr5PyYwgwtQ9h
	 KhJgn/aDxXCDzHs3KMXfMfolOEXsTAsT34fbHBEiCXnnKijOr5A5bWXl6TMpR3H/cg
	 01djqucDUwRL10fWjyZ9FSrOsM4HfAD+pfa9WjkVsVwhozCsUsTMekOvEJ2JVsY1Bu
	 z1BWzhUdAdTuZ3iEigeDeXLdXbgqs6xl9kmh2A6CFGzDbBpgpgFIEH7o8IBmpfW/TW
	 IOB70zEtspGmQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v13 06/13] zloop: fix ordered zone append handling
Date: Sat, 21 Nov 2026 06:06:44 +0900
Message-ID: <20261120210651.580511-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120210651.580511-1-dlemoal@kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For oredered zone append commands, the function
zloop_set_zone_append_sector() increments a zone write pointer without
checking if the zone is already open (implicitly or explicitly). This
check is done only when the command is later executed using a work item,
and the zone is only then implicitly open if needed. This creates a short
time window where a report zone can show an empty zone with a write
pointer that is not equal to the zone start sector, which is incorrect.

Calling zloop_do_open_zone() in zloop_set_zone_append_sector() is required
but introduces locking complexity as the zone mutex cannot be taken in the
context of zloop_queue_rq(). Instead introduce the ordered workqueue
append_workqueue to handle zone append commands when ordered zone append
is enabled. This ensure that all zone append operations are executed in
the order of there submission. This removes the need for setting the
command sector in the context of zloop_queue_rq() and we can rely on the
reguar command execution done by zloop_rw(). With this change,
zloop_seq_write_prep() is simplified and zloop_set_zone_append_sector() is
removed entirely.

This change does reduce the command execution concurrency and impact
performance with ordered zone append enabled for file systems using zone
append. This is however not a critical option and the default unordered
zone append handling is unaffected.

Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/block/zloop.c | 113 +++++++++++++++++-------------------------
 1 file changed, 45 insertions(+), 68 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 96666742523b..19949ed3824f 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -129,6 +129,7 @@ struct zloop_device {
 	struct gendisk		*disk;
 
 	struct workqueue_struct *workqueue;
+	struct workqueue_struct *append_workqueue;
 	bool			buffered_io;
 	bool			zone_append;
 	bool			ordered_zone_append;
@@ -590,32 +591,24 @@ static int zloop_seq_write_prep(struct zloop_cmd *cmd)
 	 * when submitted.
 	 */
 	if (is_append) {
-		/*
-		 * If ordered zone append is in use, we already checked and set
-		 * the target sector in zloop_queue_rq().
-		 */
-		if (!zlo->ordered_zone_append) {
-			if (zone->cond == BLK_ZONE_COND_FULL ||
-			    zone->wp + nr_sectors > zone_end) {
-				ret = -EIO;
-				goto out_unlock;
-			}
-			cmd->sector = zone->wp;
-		}
-	} else {
-		if (cmd->sector != zone->wp) {
-			if (zone->wp == ULLONG_MAX)
-				pr_err("%pg: Zone %u: write to %s zone: sect %llu\n",
-				       zlo->disk->part0, zone_no,
-				       blk_zone_cond_str(zone->cond),
-				       cmd->sector);
-			else
-				pr_err("%pg: Zone %u: unaligned write: sect %llu, wp %llu\n",
-				       zlo->disk->part0, zone_no, cmd->sector,
-				       zone->wp);
+		if (zone->cond == BLK_ZONE_COND_FULL ||
+		    zone->wp + nr_sectors > zone_end) {
 			ret = -EIO;
 			goto out_unlock;
 		}
+		cmd->sector = zone->wp;
+	} else if (cmd->sector != zone->wp) {
+		if (zone->wp == ULLONG_MAX)
+			pr_err("%pg: Zone %u: write to %s zone: sect %llu\n",
+			       zlo->disk->part0, zone_no,
+			       blk_zone_cond_str(zone->cond),
+			       cmd->sector);
+		else
+			pr_err("%pg: Zone %u: unaligned write: sect %llu, wp %llu\n",
+			       zlo->disk->part0, zone_no, cmd->sector,
+			       zone->wp);
+		ret = -EIO;
+		goto out_unlock;
 	}
 
 	/* Implicitly open the target zone. */
@@ -625,15 +618,13 @@ static int zloop_seq_write_prep(struct zloop_cmd *cmd)
 	}
 
 	/*
-	 * Advance the write pointer, unless ordered zone append is in use. If
-	 * the write fails, the write pointer position will be corrected when
-	 * the next I/O starts execution.
+	 * Advance the write pointer. If the write fails, the write pointer
+	 * position will be corrected when the next I/O starts execution.
 	 */
-	if (!is_append || !zlo->ordered_zone_append) {
-		zone->wp += nr_sectors;
-		if (zone->wp == zone_end)
-			zloop_mark_full(zlo, zone);
-	}
+	zone->wp += nr_sectors;
+	if (zone->wp == zone_end)
+		zloop_mark_full(zlo, zone);
+
 out_unlock:
 	spin_unlock(&zone->wp_lock);
 	return ret;
@@ -885,32 +876,6 @@ static void zloop_complete_rq(struct request *rq)
 	blk_mq_end_request(rq, sts);
 }
 
-static bool zloop_set_zone_append_sector(struct request *rq)
-{
-	struct zloop_device *zlo = rq->q->queuedata;
-	unsigned int zone_no = rq_zone_no(rq);
-	struct zloop_zone *zone = &zlo->zones[zone_no];
-	sector_t zone_end = zone->start + zlo->zone_capacity;
-	sector_t nr_sectors = blk_rq_sectors(rq);
-
-	spin_lock(&zone->wp_lock);
-
-	if (zone->cond == BLK_ZONE_COND_FULL ||
-	    zone->wp + nr_sectors > zone_end) {
-		spin_unlock(&zone->wp_lock);
-		return false;
-	}
-
-	rq->__sector = zone->wp;
-	zone->wp += blk_rq_sectors(rq);
-	if (zone->wp >= zone_end)
-		zloop_mark_full(zlo, zone);
-
-	spin_unlock(&zone->wp_lock);
-
-	return true;
-}
-
 static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
 				   const struct blk_mq_queue_data *bd)
 {
@@ -923,20 +888,13 @@ static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return BLK_STS_IOERR;
 	}
 
-	/*
-	 * If we need to strongly order zone append operations, set the request
-	 * sector to the zone write pointer location now instead of when the
-	 * command work runs.
-	 */
-	if (zlo->ordered_zone_append && req_op(rq) == REQ_OP_ZONE_APPEND) {
-		if (!zloop_set_zone_append_sector(rq))
-			return BLK_STS_IOERR;
-	}
-
 	blk_mq_start_request(rq);
 
 	INIT_WORK(&cmd->work, zloop_cmd_workfn);
-	queue_work(zlo->workqueue, &cmd->work);
+	if (zlo->ordered_zone_append && req_op(rq) == REQ_OP_ZONE_APPEND)
+		queue_work(zlo->append_workqueue, &cmd->work);
+	else
+		queue_work(zlo->workqueue, &cmd->work);
 
 	return BLK_STS_OK;
 }
@@ -1029,6 +987,8 @@ static void zloop_free_disk(struct gendisk *disk)
 
 	fput(zlo->data_dir);
 	destroy_workqueue(zlo->workqueue);
+	if (zlo->append_workqueue)
+		destroy_workqueue(zlo->append_workqueue);
 	kfree(zlo->base_dir);
 	kvfree(zlo);
 }
@@ -1285,6 +1245,21 @@ static int zloop_ctl_add(struct zloop_options *opts)
 		goto out_free_idr;
 	}
 
+	/*
+	 * Use an ordered workqueue for strongly ordered zone append operations
+	 * so that we can keep processing the operations in the same order as
+	 * they are submitted.
+	 */
+	if (zlo->ordered_zone_append) {
+		zlo->append_workqueue =
+			alloc_ordered_workqueue("zloop%d_append", WQ_FREEZABLE,
+						zlo->id);
+		if (!zlo->append_workqueue) {
+			ret = -ENOMEM;
+			goto out_destroy_workqueue;
+		}
+	}
+
 	if (opts->base_dir)
 		zlo->base_dir = kstrdup(opts->base_dir, GFP_KERNEL);
 	else
@@ -1391,6 +1366,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	kfree(zlo->base_dir);
 out_destroy_workqueue:
 	destroy_workqueue(zlo->workqueue);
+	if (zlo->append_workqueue)
+		destroy_workqueue(zlo->append_workqueue);
 out_free_idr:
 	mutex_lock(&zloop_ctl_mutex);
 	idr_remove(&zloop_index_idr, zlo->id);
-- 
2.56.1

