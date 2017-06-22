From: Yadan Fan <ydfan@suse.com>
Subject: [PATCH 1/2] hpsa: limit transfer length to 1MB
Date: Thu, 22 Jun 2017 17:58:44 +0800
Message-ID: <20170622095845.4235-1-ydfan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: don.brace@microsemi.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ydfan@suse.com
List-Id: linux-scsi@vger.kernel.org

The hpsa firmware will bypass the cache for any request larger
than 1MB, so we should cap the request size to avoid any
performance degradation in SLE12-SP2.

This degradation is caused from d2be537c3ba3568acd79cd178327b842e60d035e,
which changed max_sectors_kb to 1280k, but the hardware is able to
work fine with it, so the true fix should be from hpsa driver.

References: bsc#1025461

Signed-off-by: Yadan Fan <ydfan@suse.com>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 73daace478cb..b4c0bbea680c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -952,7 +952,7 @@ static struct scsi_host_template hpsa_driver_template = {
 #endif
 	.sdev_attrs = hpsa_sdev_attrs,
 	.shost_attrs = hpsa_shost_attrs,
-	.max_sectors = 8192,
+	.max_sectors = 1024,
 	.no_write_same = 1,
 };
 
-- 
2.12.3
