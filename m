Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2CA3FB21;
	Fri,  2 Feb 2024 07:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859091; cv=none; b=RRIFv5DZ9/j8t+GWXPylzwygIa0t1EXNuT1VVnBwBBJUKalruOB+pMVxgZ0URfI+H1/itNCgsvdCoDmYRpAcw/mP+PnlORfduD9d10Wy6Ttcekb7PopjfVCvCkoGoxb4IpCTIEOvZHh2uUY7Rq1peAJOdIiwj0tYXK0NyHsXtsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859091; c=relaxed/simple;
	bh=A62WYC+ntBR0ceN3cvfJ5vo+5cUAXr1/eaGJDGksaEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hb3dku4Yr+ov+s9Vwa8qwMcFhZByEzK90x+Etgd6lXRi9Vh7FERp2PN9pZ3nju9OEwThbkXwMATl3bcf56OXM2dlBLOXdtgGb5j+lrAXs9nWN6Dpg86cML7BmfUEPtpuOXvMmrUnX69U21aUfYIIjM3mGMdTTXs0DOwUqF1zyXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CKEyeKg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CKEyeKg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7346CC43399;
	Fri,  2 Feb 2024 07:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859091;
	bh=A62WYC+ntBR0ceN3cvfJ5vo+5cUAXr1/eaGJDGksaEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKEyeKg1VIaufTllykahq1f2ez1EAb7fBN+/+AzMdmw+jrZhkH/BVuBjXcIptFO9a
	 151suXxwh85KrsSJXP7dfXDtwXlC1obCXzs63bVc/DPj/8pUPKM2APVEUsGy+/JEJS
	 qgHjk46WTqLSl2DtGA1v0FVEk5ykXnel7eo8LWw+ga/2uctOazyLT9LtfYV7UcOPF1
	 kv4nziJZk5KMATOuUMrfjf9F4Wr+pOP7c+JO/HdTPuULuaZIWLm1yQCzTSQbIGApP3
	 rBYvab+a6lhp2B5ZZfZ1TLyyAbUOf+eZ+JPLZFWVoA4WS+daZ6cPy3US+rEKa8+dCe
	 SL/WKBWdxjejA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/26] block: Remove BLK_STS_ZONE_RESOURCE
Date: Fri,  2 Feb 2024 16:30:55 +0900
Message-ID: <20240202073104.2418230-18-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zone append emulation of the scsi disk driver was the only driver
using BLK_STS_ZONE_RESOURCE. With this code removed,
BLK_STS_ZONE_RESOURCE is now unused. Remove this macro definition and
simplify blk_mq_dispatch_rq_list() where this status code was handled.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq.c            | 26 --------------------------
 drivers/scsi/scsi_lib.c   |  1 -
 include/linux/blk_types.h | 20 ++++----------------
 3 files changed, 4 insertions(+), 43 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index a112298a6541..8576940f8674 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1940,19 +1940,6 @@ static void blk_mq_handle_dev_resource(struct request *rq,
 	__blk_mq_requeue_request(rq);
 }
 
-static void blk_mq_handle_zone_resource(struct request *rq,
-					struct list_head *zone_list)
-{
-	/*
-	 * If we end up here it is because we cannot dispatch a request to a
-	 * specific zone due to LLD level zone-write locking or other zone
-	 * related resource not being available. In this case, set the request
-	 * aside in zone_list for retrying it later.
-	 */
-	list_add(&rq->queuelist, zone_list);
-	__blk_mq_requeue_request(rq);
-}
-
 enum prep_dispatch {
 	PREP_DISPATCH_OK,
 	PREP_DISPATCH_NO_TAG,
@@ -2038,7 +2025,6 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 	struct request *rq;
 	int queued;
 	blk_status_t ret = BLK_STS_OK;
-	LIST_HEAD(zone_list);
 	bool needs_resource = false;
 
 	if (list_empty(list))
@@ -2080,23 +2066,11 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 		case BLK_STS_DEV_RESOURCE:
 			blk_mq_handle_dev_resource(rq, list);
 			goto out;
-		case BLK_STS_ZONE_RESOURCE:
-			/*
-			 * Move the request to zone_list and keep going through
-			 * the dispatch list to find more requests the drive can
-			 * accept.
-			 */
-			blk_mq_handle_zone_resource(rq, &zone_list);
-			needs_resource = true;
-			break;
 		default:
 			blk_mq_end_request(rq, ret);
 		}
 	} while (!list_empty(list));
 out:
-	if (!list_empty(&zone_list))
-		list_splice_tail_init(&zone_list, list);
-
 	/* If we didn't flush the entire list, we could have told the driver
 	 * there was more coming, but that turned out to be a lie.
 	 */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index cf3864f72093..80e692149e2c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1776,7 +1776,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-	case BLK_STS_ZONE_RESOURCE:
 		if (scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 5c5343099800..fd0dc2d08924 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -135,18 +135,6 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_DEV_RESOURCE	((__force blk_status_t)13)
 
-/*
- * BLK_STS_ZONE_RESOURCE is returned from the driver to the block layer if zone
- * related resources are unavailable, but the driver can guarantee the queue
- * will be rerun in the future once the resources become available again.
- *
- * This is different from BLK_STS_DEV_RESOURCE in that it explicitly references
- * a zone specific resource and IO to a different zone on the same device could
- * still be served. Examples of that are zones that are write-locked, but a read
- * to the same zone could be served.
- */
-#define BLK_STS_ZONE_RESOURCE	((__force blk_status_t)14)
-
 /*
  * BLK_STS_ZONE_OPEN_RESOURCE is returned from the driver in the completion
  * path if the device returns a status indicating that too many zone resources
@@ -154,7 +142,7 @@ typedef u16 blk_short_t;
  * after the number of open zones decreases below the device's limits, which is
  * reported in the request_queue's max_open_zones.
  */
-#define BLK_STS_ZONE_OPEN_RESOURCE	((__force blk_status_t)15)
+#define BLK_STS_ZONE_OPEN_RESOURCE	((__force blk_status_t)14)
 
 /*
  * BLK_STS_ZONE_ACTIVE_RESOURCE is returned from the driver in the completion
@@ -163,20 +151,20 @@ typedef u16 blk_short_t;
  * after the number of active zones decreases below the device's limits, which
  * is reported in the request_queue's max_active_zones.
  */
-#define BLK_STS_ZONE_ACTIVE_RESOURCE	((__force blk_status_t)16)
+#define BLK_STS_ZONE_ACTIVE_RESOURCE	((__force blk_status_t)15)
 
 /*
  * BLK_STS_OFFLINE is returned from the driver when the target device is offline
  * or is being taken offline. This could help differentiate the case where a
  * device is intentionally being shut down from a real I/O error.
  */
-#define BLK_STS_OFFLINE		((__force blk_status_t)17)
+#define BLK_STS_OFFLINE		((__force blk_status_t)16)
 
 /*
  * BLK_STS_DURATION_LIMIT is returned from the driver when the target device
  * aborted the command because it exceeded one of its Command Duration Limits.
  */
-#define BLK_STS_DURATION_LIMIT	((__force blk_status_t)18)
+#define BLK_STS_DURATION_LIMIT	((__force blk_status_t)17)
 
 /**
  * blk_path_error - returns true if error may be path related
-- 
2.43.0

