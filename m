From: tom.ty89@gmail.com
Subject: [PATCH 2/2] sd: check BLK_DEF_MAX_SECTORS against max_dev_sectors
Date: Fri, 12 Aug 2016 19:56:07 +0800
Message-ID: <0bc2e9a09870610a48e0033a0370941ad549ba6b.1471002480.git.tom.ty89@gmail.com>
References: <911c68378b91bf275a4bbed5717b4639641d7029.1471002480.git.tom.ty89@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <911c68378b91bf275a4bbed5717b4639641d7029.1471002480.git.tom.ty89@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

The SCSI disk driver sets max_sector to BLK_DEF_MAX_SECTORS when
the device does not report Optimal Transfer Length. However, it
checks only whether it is smaller than max_hw_sectors, but not
max_dev_sectors.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d3e852a..2b6da13 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2875,8 +2875,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	    logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
-	} else
+	} else {
 		rw_max = BLK_DEF_MAX_SECTORS;
+		/* Combine with device limits */
+		rw_max = min(rw_max, q->limits.max_dev_sectors);
+	}
 
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
-- 
2.9.2

