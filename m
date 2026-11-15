Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754225;
	b=kKT2ltZsQ0XBwIUwjHeFZXcgeX3ZS2lhxGqvfYlH+o/4Jt1TjzI+36zvXvJPeGO2Mq3i
	 UBG0PcKmCJRmfMvLjbzZqqMj6JXVZmG0fgrjNB0dgvc5vltMMpTksneqdbiqFIn+l7rsj
	 WRYx3Mv/V8C342ztP3oN6GoKaaFPFje93y1KW8ecL+xdat/EfJSVvnuvX3wac5vnKWIMK
	 9+WzymEXsd4H9ek/dzw+4Dzb5qu7Col8ovy5NEcoLDYoHaPzcJnB1SxFKUAMCIee4dHFk
	 8Ot9GSUccS/b/x6sRT1q1iHVwS6zXek2sGAVjOWpZhkrSB28NF2OcFQyWqYrrJlp8Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754225;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=D/B8vk0Ll96T486S8lJdX85f9OsU4P4+TMdOMchphoQ=;
	b=vNUyE+3W84xQ/QXKNVwzk6Y8aIhM4GRCp69OQISh3ifRIdO8IktJ2FdF/ClBRexdCZtC
	 R2207NQTL1nagRCkzcxXIZowtJsQjrtuQ0oHlKcRH148h5YQDlEN5PAALl43tWqfENok4
	 k0ceQvVg7fdbgeBy3K6DvSmEp1pMiHeMirj+eovYoGDLg3h67ERvDFnJR9JnZIC2xj5Tx
	 2wQnqocE9G2YPOYpaK6FTllyyt0eBiBANyh6rs9YgOEgt0L1aPWQENuCVsSIudSOpac3s
	 o93pahr6qXfqH+ItDy10iJUjvtpZA8/VVx7+VmetnFZmZ2Q/lyz/PmMmUggE0LE0jZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfIOckjg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997A2606A330;
	Sun, 15 Nov 2026 14:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PfIOckjg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7CF1F000C4;
	Sun, 15 Nov 2026 14:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754225;
	bh=D/B8vk0Ll96T486S8lJdX85f9OsU4P4+TMdOMchphoQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=PfIOckjglfHujCVdfVkBWzQWCL6kSvB7up84RwKBydDCCjqEXACTLQt8IqLtfJY7w
	 etedFcub5yjJqzjzZY5KRjhmGAgb+w1O/VElaypyrticSsFQyG1YD99Z3xb5yUGMVH
	 9PG+GCqxw1KW0bJLAtTFnzwVNEWyVO+/kvRdOR8MOmrGaq24HdYXzHk2Fmo28ukKVa
	 NiA9wrN65shPb4qMXM63G71d/8tOlDAbiUMr/+Ue6AZlOLqU+6nMXSkMzr/bwQ20WT
	 0j9z+8tRjHc/zITtWo+MVKsLX77IGyRflYb0vHjQB+LMInZvXa37qJzd0uLtqd0NRw
	 taLRyPU8jRkHA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 06/13] zloop: keep zone write pointer and condition consistent
Date: Sun, 15 Nov 2026 23:50:08 +0900
Message-ID: <20261115145015.938426-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
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
and the zone is implicitly open if needed. This creates a short time
window where a report zone can show an empty zone with a write pointer
that is not equal to the zone start sector, which is incorrect.

Fix this by calling zloop_do_open_zone() in zloop_set_zone_append_sector()
to make sure that a zone is always first implicitly open if needed. This
requires changing zloop_set_zone_append_sector() to return a blk_status_t
so that potential zone resource errors can also be returned correctly.

Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/zloop.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 96666742523b..7d98be66a3a8 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -885,20 +885,26 @@ static void zloop_complete_rq(struct request *rq)
 	blk_mq_end_request(rq, sts);
 }
 
-static bool zloop_set_zone_append_sector(struct request *rq)
+static blk_status_t zloop_set_zone_append_sector(struct request *rq)
 {
 	struct zloop_device *zlo = rq->q->queuedata;
 	unsigned int zone_no = rq_zone_no(rq);
 	struct zloop_zone *zone = &zlo->zones[zone_no];
 	sector_t zone_end = zone->start + zlo->zone_capacity;
 	sector_t nr_sectors = blk_rq_sectors(rq);
+	static blk_status_t ret = BLK_STS_OK;
 
 	spin_lock(&zone->wp_lock);
 
 	if (zone->cond == BLK_ZONE_COND_FULL ||
 	    zone->wp + nr_sectors > zone_end) {
-		spin_unlock(&zone->wp_lock);
-		return false;
+		ret = BLK_STS_IOERR;
+		goto unlock;
+	}
+
+	if (!zloop_do_open_zone(zlo, zone, false)) {
+		ret = BLK_STS_ZONE_OPEN_RESOURCE;
+		goto unlock;
 	}
 
 	rq->__sector = zone->wp;
@@ -906,9 +912,10 @@ static bool zloop_set_zone_append_sector(struct request *rq)
 	if (zone->wp >= zone_end)
 		zloop_mark_full(zlo, zone);
 
+ unlock:
 	spin_unlock(&zone->wp_lock);
 
-	return true;
+	return ret;
 }
 
 static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
@@ -917,6 +924,7 @@ static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct request *rq = bd->rq;
 	struct zloop_cmd *cmd = blk_mq_rq_to_pdu(rq);
 	struct zloop_device *zlo = rq->q->queuedata;
+	blk_status_t ret;
 
 	if (data_race(READ_ONCE(zlo->state)) == Zlo_deleting) {
 		rq->rq_flags |= RQF_QUIET;
@@ -929,8 +937,9 @@ static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * command work runs.
 	 */
 	if (zlo->ordered_zone_append && req_op(rq) == REQ_OP_ZONE_APPEND) {
-		if (!zloop_set_zone_append_sector(rq))
-			return BLK_STS_IOERR;
+		ret = zloop_set_zone_append_sector(rq);
+		if (ret != BLK_STS_OK)
+			return ret;
 	}
 
 	blk_mq_start_request(rq);
-- 
2.56.0

