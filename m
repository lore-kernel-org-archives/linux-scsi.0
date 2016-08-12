From: tom.ty89@gmail.com
Subject: [PATCH v2 2/2] sd: check BLK_DEF_MAX_SECTORS against max_dev_sectors
Date: Fri, 12 Aug 2016 22:27:04 +0800
Message-ID: <974f3a0aa9e82caf067353fd7d7119c07d7e98c1.1471011949.git.tom.ty89@gmail.com>
References: <60518e90d462d4cbb1c528914eac64e2fe124717.1471011949.git.tom.ty89@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <60518e90d462d4cbb1c528914eac64e2fe124717.1471011949.git.tom.ty89@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Tom Yan <tom.ty89@gmail.com>

The SCSI disk driver sets max_sectors to BLK_DEF_MAX_SECTORS when
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

