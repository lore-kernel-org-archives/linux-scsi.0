Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931069;
	b=jGwbf4OwgrU3PxZNlUcfbOKpclZlf3qCgPZf4L/qkZgb+sCcolRpprdilunHfM05kTRG
	 sJkkuwYtS+RtoCNwffjVR0LSytyqzGw5wSWUe7WIqUerceEfLeyVA/keKxXnNgKqsYicI
	 c7gS3EFwypGJLecfmxiJOZ4VxDSm6+jfNMcvGXfoh28Pn0jEr4cjVAHdhYljWreGCb/YY
	 kFJw1UDVv6/zYHrnntNIXoHg91BdiLiFbQFBoXtRvyIKX/ZMlqUD7sZvJ0WeJco0OY/jx
	 p8zQL3uUQw0oXAwjKnnbSAJwk7LlJke+JrIyqUi9WRRUQLZX3Y8xjiGgFzmC6TLBtZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931069;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=1FUB7MtTIpQ7XSLXYOlcdLsaHW/dgpju2Ehml34+19w=;
	b=gp/q5jT3vTS2BCkTxk+2q4540RsI/gdrG0TE8Pr7Zlq73Z0+FPWFM5gRw45NJ1LqTNai
	 lQ/c2RKAbNENJ1r8ZKN30mkcdjE+K4Fq7bNVKGpl1Z2bJiA6zfdK+QxMgkYCreIqR6GxY
	 +3bBRLQmSJ2sHSClICmsFKLyccGwm0VuyGgHZTffSV4uZiVbPvdtS49yy/AKdWS88gUXh
	 8WkwlzVrS8z3ZO9ynEk9SwjlzjA6IJuY03ZKQ3yWS9fdzxutr3oca9Ddw15LQcz1Ut6Js
	 js95haMpWcKNBfhN16AsnIkFkfMDXtZQUcxtCcP3CSAi25A0bs4SOKJ3pHnfq+WaABQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DMlXVesi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B66606A883;
	Tue, 17 Nov 2026 15:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DMlXVesi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0BE1F000C4;
	Tue, 17 Nov 2026 15:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931068;
	bh=1FUB7MtTIpQ7XSLXYOlcdLsaHW/dgpju2Ehml34+19w=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DMlXVesi+hJPqA3sVJAa9OO6VdPKamU1+GhUh7BCmwbIMimH0yn10Rfnoa6N6vCso
	 Lna393adjKbbdC2IxPUOQriqGwrN9QClN4NgqWFRYB+G3urRnDrr7NBeRI69NKLjj8
	 FNrzXs0DNthfMhDvkfJH6IxtX1lYEMzUACroZahHQ38w19onsQEcKKRkjoecPBKSW/
	 Or59DATON8pxhjnge8fSfQmn2CQCNHOLCFXJWsmfLHfi7dpmIILbf4Q/8871q66QRd
	 wQPiMCcPvCoXoGc3swQ+HIgrZWHKVCmwZ/K/MYcf+xJFFUBcRIfxcp8nyMchupGgcw
	 UbAk4NYgYxzQw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 06/13] zloop: fix ordered zone append handling
Date: Wed, 18 Nov 2026 00:57:32 +0900
Message-ID: <20261117155739.304506-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117155739.304506-1-dlemoal@kernel.org>
References: <20261117155739.304506-1-dlemoal@kernel.org>
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

