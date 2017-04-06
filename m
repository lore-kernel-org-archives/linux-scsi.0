From: Fam Zheng <famz@redhat.com>
Subject: [PATCH] sd: Explicit type cast to fix calculating rw_max
Date: Thu,  6 Apr 2017 16:20:59 +0800
Message-ID: <20170406082059.26492-1-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Some compilers don't like BLK_DEF_MAX_SECTORS being an enum (int) when
expanding min_not_zero. Cast it to sector_t so it matches the type of
the other operand, logical_to_sectors().

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab9011a..8d2315a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2957,7 +2957,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
 	} else
 		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
-				      BLK_DEF_MAX_SECTORS);
+				      (sector_t)BLK_DEF_MAX_SECTORS);
 
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
-- 
2.9.3
