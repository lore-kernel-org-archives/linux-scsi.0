From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RFC/RFT PATCH 3/5] scsi: Use dma_max_pfn(dev) helper for bounce_limit calculations
Date: Fri, 12 Jul 2013 17:48:12 -0400
Message-ID: <1373665694-7580-4-git-send-email-santosh.shilimkar@ti.com>
References: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1373665694-7580-1-git-send-email-santosh.shilimkar@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, Russell King <linux@arm.linux.org.uk>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

DMA bounce limit is the maximum direct DMA'able memory beyond which
bounce buffers has to be used to perform dma operations. SCSI driver
relies on dma_mask but its calculation is based on max_*pfn which
don't have uniform meaning across architectures. So make use of
dma_max_pfn() which is expected to return the DMAable maximum pfn
value across architectures.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 86d5220..e8275fa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1668,7 +1668,7 @@ u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 
 	host_dev = scsi_get_device(shost);
 	if (host_dev && host_dev->dma_mask)
-		bounce_limit = *host_dev->dma_mask;
+		bounce_limit = dma_max_pfn(host_dev) << PAGE_SHIFT;
 
 	return bounce_limit;
 }
-- 
1.7.9.5
