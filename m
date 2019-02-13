From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 063/105] scsi: qla1280: set 64bit coherent mask
Date: Tue, 12 Feb 2019 21:32:54 -0500
Message-ID: <20190213023336.19019-63-sashal@kernel.org>
References: <20190213023336.19019-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190213023336.19019-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Thomas Bogendoerfer <tbogendoerfer@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 4a01ab60f55041b1ccc760e43258a5b3aeeca1bc ]

After Commit 54aed4dd3526 ("MIPS: IP27: use dma_direct_ops") qla1280 driver
failed on SGI IP27 machines with

qla1280: QLA1040 found on PCI bus 0, dev 0
qla1280 0000:00:00.0: enabling device (0006 -> 0007)
qla1280: Failed to get request memory
qla1280: probe of 0000:00:00.0 failed with error -12

Reason is that SGI IP27 always generates 64bit DMA addresses and has no
fallback mode for 32bit DMA addresses implemented. QLA1280 supports 64bit
addressing for all DMA accesses so setting coherent mask to 64bit fixes the
issue.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla1280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 15a50cc7e4b3..c8589926014d 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4259,7 +4259,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(64))) {
+	if (dma_set_mask_and_coherent(&ha->pdev->dev, DMA_BIT_MASK(64))) {
 		if (dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32))) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
-- 
2.19.1
