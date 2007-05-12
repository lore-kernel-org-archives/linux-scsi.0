From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 6/19] fusion: remove the non-use-sg case
Date: Sat, 12 May 2007 19:05:43 +0900 (JST)
Message-ID: <20070512183349U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:55490 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXELKF5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 12 May 2007 06:05:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This removes the non-use-sg case.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/message/fusion/mptscsih.c |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index fa0f776..d7e2fa9 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -267,18 +267,6 @@ mptscsih_AddSGE(MPT_ADAPTER *ioc, struct
 			       SCpnt->sc_data_direction);
 		if (sges_left == 0)
 			return FAILED;
-	} else if (SCpnt->request_bufflen) {
-		SCpnt->SCp.dma_handle = pci_map_single(ioc->pcidev,
-				      SCpnt->request_buffer,
-				      SCpnt->request_bufflen,
-				      SCpnt->sc_data_direction);
-		dsgprintk((MYIOC_s_INFO_FMT "SG: non-SG for %p, len=%d\n",
-				ioc->name, SCpnt, SCpnt->request_bufflen));
-		mptscsih_add_sge((char *) &pReq->SGL,
-			0xD1000000|MPT_SGE_FLAGS_ADDRESSING|sgdir|SCpnt->request_bufflen,
-			SCpnt->SCp.dma_handle);
-
-		return SUCCESS;
 	}
 
 	/* Handle the SG case.
@@ -909,13 +897,10 @@ #endif
 	} /* end of address reply case */
 
 	/* Unmap the DMA buffers, if any. */
-	if (sc->use_sg) {
+	if (sc->use_sg)
 		pci_unmap_sg(ioc->pcidev, (struct scatterlist *) sc->request_buffer,
-			    sc->use_sg, sc->sc_data_direction);
-	} else if (sc->request_bufflen) {
-		pci_unmap_single(ioc->pcidev, sc->SCp.dma_handle,
-				sc->request_bufflen, sc->sc_data_direction);
-	}
+			     sc->use_sg,
+			     sc->sc_data_direction);
 
 	sc->scsi_done(sc);		/* Issue the command callback */
 
@@ -970,17 +955,12 @@ mptscsih_flush_running_cmds(MPT_SCSI_HOS
 			/* Set status, free OS resources (SG DMA buffers)
 			 * Do OS callback
 			 */
-			if (SCpnt->use_sg) {
+			if (SCpnt->use_sg)
 				pci_unmap_sg(ioc->pcidev,
 					(struct scatterlist *) SCpnt->request_buffer,
 					SCpnt->use_sg,
 					SCpnt->sc_data_direction);
-			} else if (SCpnt->request_bufflen) {
-				pci_unmap_single(ioc->pcidev,
-					SCpnt->SCp.dma_handle,
-					SCpnt->request_bufflen,
-					SCpnt->sc_data_direction);
-			}
+
 			SCpnt->result = DID_RESET << 16;
 			SCpnt->host_scribble = NULL;
 
@@ -1044,11 +1024,6 @@ mptscsih_search_running_cmds(MPT_SCSI_HO
 				(struct scatterlist *) sc->request_buffer,
 					sc->use_sg,
 					sc->sc_data_direction);
-			} else if (sc->request_bufflen) {
-				pci_unmap_single(hd->ioc->pcidev,
-					sc->SCp.dma_handle,
-					sc->request_bufflen,
-					sc->sc_data_direction);
 			}
 			sc->host_scribble = NULL;
 			sc->result = DID_NO_CONNECT << 16;
-- 
1.4.3.2

