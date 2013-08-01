From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH RFC 49/51] ARM: 7796/1: scsi: Use dma_max_pfn(dev) helper for
 bounce_limit calculations
Date: Thu, 01 Aug 2013 23:23:14 +0100
Message-ID: <E1V51H8-0006ud-Ow@rmk-PC.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

DMA bounce limit is the maximum direct DMA'able memory beyond which
bounce buffers has to be used to perform dma operations. SCSI driver
relies on dma_mask but its calculation is based on max_*pfn which
don't have uniform meaning across architectures. So make use of
dma_max_pfn() which is expected to return the DMAable maximum pfn
value across architectures.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/scsi/scsi_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 124392f..1be55e3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1684,7 +1684,7 @@ u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
 
 	host_dev = scsi_get_device(shost);
 	if (host_dev && host_dev->dma_mask)
-		bounce_limit = *host_dev->dma_mask;
+		bounce_limit = dma_max_pfn(host_dev) << PAGE_SHIFT;
 
 	return bounce_limit;
 }
-- 
1.7.4.4
