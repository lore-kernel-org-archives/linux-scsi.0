From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] mptsas: fix checks for dma mapping errors
Date: Sat, 16 Apr 2016 02:12:29 +0300
Message-ID: <1460761950-8006-1-git-send-email-khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

mptsas_smp_handler() checks for dma mapping errors by comparison
returned address with zero, while pci_dma_mapping_error() should be used.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/message/fusion/mptsas.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 7ebccfa8072a..7ee1667acde4 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2281,7 +2281,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
 				      blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
-	if (!dma_addr_out)
+	if (pci_dma_mapping_error(ioc->pcidev, dma_addr_out))
 		goto put_mf;
 	ioc->add_sge(psge, flagsLength, dma_addr_out);
 	psge += ioc->SGE_size;
@@ -2296,7 +2296,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	flagsLength |= blk_rq_bytes(rsp) + 4;
 	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
 				      blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
-	if (!dma_addr_in)
+	if (pci_dma_mapping_error(ioc->pcidev, dma_addr_in))
 		goto unmap;
 	ioc->add_sge(psge, flagsLength, dma_addr_in);
 
-- 
1.9.1
