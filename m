From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] aic94xx: fix SMP request DMA direction
Date: Thu, 27 Sep 2007 22:33:41 -0400
Message-ID: <20070928023341.GA10750@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:55832 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733AbXI1Cdm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 22:33:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Unless I'm missing something, the SMP request goes /to/ the PCI device :)

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/scsi/aic94xx/aic94xx_task.c |    4 -
 2 files changed, 83 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index d5d8cab..ab13824 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -451,7 +451,7 @@ static int asd_build_smp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	struct scb *scb;
 
 	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_req, 1,
-		   PCI_DMA_FROMDEVICE);
+		   PCI_DMA_TODEVICE);
 	pci_map_sg(asd_ha->pcidev, &task->smp_task.smp_resp, 1,
 		   PCI_DMA_FROMDEVICE);
 
@@ -486,7 +486,7 @@ static void asd_unbuild_smp_ascb(struct asd_ascb *a)
 
 	BUG_ON(!task);
 	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_req, 1,
-		     PCI_DMA_FROMDEVICE);
+		     PCI_DMA_TODEVICE);
 	pci_unmap_sg(a->ha->pcidev, &task->smp_task.smp_resp, 1,
 		     PCI_DMA_FROMDEVICE);
 }
