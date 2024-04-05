Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B695D37171;
	Fri,  5 Apr 2024 04:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292157; cv=none; b=PWUPs3wPVNqtYOZGXo1YsdhWgbWPy6dW5MU6prjg//VeUfKOyI7+i1G/8kUzsNu3g1l9OaM/M7vs0S8XT+V2zQRATsrITr48c0CnP25L4PofxG2NNDsQ1WTmSYje1GOBWb2T/tXO0DLAPM8K3N/3S0IJvXGGYF/VRWEVxTs8Rjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292157; c=relaxed/simple;
	bh=yf3aHd7xoJIE60kW1dRyHMueT66VySqIUCV6rd0JX3w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js5z6v1AwG86VD11cOc/uMO33NcTd7AbRVqNFASo1nzEcoEXfo9Dw+25LAgUUlPFx2fmZy3C+2Vrk1N4+9Wl61h8BK29cs+TBSFE7fMJ3oEaJoJPHulEmeWjlS0C+d1DDWtfe7XF8xDXPPS+UEAGKJPASfggJ6VVizcgh86VSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OfCFwm49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OfCFwm49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71336C433F1;
	Fri,  5 Apr 2024 04:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292157;
	bh=yf3aHd7xoJIE60kW1dRyHMueT66VySqIUCV6rd0JX3w=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=OfCFwm49vUMpIsETStBjxGWkuuDfoiOjxD+/tUENI4pukS0mVsMKouENdZ2844dEG
	 R/9SzrwsBmOVqoVdGHkIb6ofbV7mrQ9xDhK73DXfRaZa8cUG2PqTtQwDYUzUozJ1KN
	 HnTxQkMdMuYTyY+Zvpee23yJKZBwc8jz/xWWEAcvPA4hC8M8oE77firomVzDMveY2s
	 /gw0xRmS+qpP1Ees9Pxq8pR3XRmU+sINd9d4dAZqfiQHV78yQVD8J4Gq8U3eOVrtP5
	 8xFCRKREiFuDS9euZn9tlPcOYEJ4AEuowr1Q3zPS/SycjysanS82Pse0IHTkImgJDu
	 2J76FHIcnWygg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v6 19/28] block: Remove BLK_STS_ZONE_RESOURCE
Date: Fri,  5 Apr 2024 13:41:58 +0900
Message-ID: <20240405044207.1123462-20-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 block/blk-mq.c            | 26 --------------------------
 drivers/scsi/scsi_lib.c   |  1 -
 include/linux/blk_types.h | 20 ++++----------------
 3 files changed, 4 insertions(+), 43 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6f9cc1c4d4fb..9f2d9970eeba 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1921,19 +1921,6 @@ static void blk_mq_handle_dev_resource(struct request *rq,
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
@@ -2019,7 +2006,6 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
 	struct request *rq;
 	int queued;
 	blk_status_t ret = BLK_STS_OK;
-	LIST_HEAD(zone_list);
 	bool needs_resource = false;
 
 	if (list_empty(list))
@@ -2061,23 +2047,11 @@ bool blk_mq_dispatch_rq_list(struct blk_mq_hw_ctx *hctx, struct list_head *list,
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
index 2e28e2360c85..9ca96116bd33 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1870,7 +1870,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 	case BLK_STS_OK:
 		break;
 	case BLK_STS_RESOURCE:
-	case BLK_STS_ZONE_RESOURCE:
 		if (scsi_device_blocked(sdev))
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 29b3170431e7..ffe0c112b128 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -136,18 +136,6 @@ typedef u16 blk_short_t;
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
@@ -155,7 +143,7 @@ typedef u16 blk_short_t;
  * after the number of open zones decreases below the device's limits, which is
  * reported in the request_queue's max_open_zones.
  */
-#define BLK_STS_ZONE_OPEN_RESOURCE	((__force blk_status_t)15)
+#define BLK_STS_ZONE_OPEN_RESOURCE	((__force blk_status_t)14)
 
 /*
  * BLK_STS_ZONE_ACTIVE_RESOURCE is returned from the driver in the completion
@@ -164,20 +152,20 @@ typedef u16 blk_short_t;
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
2.44.0

