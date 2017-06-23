From: Yadan Fan <ydfan@suse.com>
Subject: [PATCH v2 2/2] smartpqi: limit transfer length to 1MB
Date: Fri, 23 Jun 2017 17:40:06 +0800
Message-ID: <20170623094006.16807-2-ydfan@suse.com>
References: <20170623094006.16807-1-ydfan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170623094006.16807-1-ydfan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: don.brace@microsemi.com, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Yadan Fan <ydfan@suse.com>
List-Id: linux-scsi@vger.kernel.org

The smartpqi firmware will bypass the cache for any request larger
than 1MB, so we should cap the request size to avoid any
performance degradation in kernels later than v4.3

This degradation is caused from d2be537c3ba3568acd79cd178327b842e60d035e,
which changed max_sectors_kb to 1280k, but the hardware is able to
work fine with it, so the true fix should be from smartpqi driver.

Signed-off-by: Yadan Fan <ydfan@suse.com>
---
 drivers/scsi/smartpqi/smartpqi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index b673825f46b5..9513357bd472 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -630,7 +630,7 @@ struct pqi_encryption_info {
 };
 
 #define PQI_MAX_OUTSTANDING_REQUESTS	((u32)~0)
-#define PQI_MAX_TRANSFER_SIZE		(4 * 1024U * 1024U)
+#define PQI_MAX_TRANSFER_SIZE		(1024U * 1024U)
 
 #define RAID_MAP_MAX_ENTRIES		1024
 
-- 
2.12.3
