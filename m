From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 09/18] qla2xxx: Swap enablement order of EFT and FCE.
Date: Thu, 10 Jul 2008 16:55:54 -0700
Message-ID: <1215734163-40825-9-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757511AbYGJX4K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:10 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The firmware group has suggested that FCE (Fibre Channel Event)
tracing be enabled prior to EFT (Extended Firmware Tracing) to
maximize the capturing of data on the wire.  This change has no
real semantic effect on driver operation, as it's mostly a
shuffling of code.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |   80 +++++++++++++++++++-------------------
 1 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 08bdba5..80f4f9d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -768,42 +768,16 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		mem_size = (ha->fw_memory_size - 0x100000 + 1) *
 		    sizeof(uint32_t);
 
-		/* Allocate memory for Extended Trace Buffer. */
-		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
-		    GFP_KERNEL);
-		if (!tc) {
-			qla_printk(KERN_WARNING, ha, "Unable to allocate "
-			    "(%d KB) for EFT.\n", EFT_SIZE / 1024);
-			goto cont_alloc;
-		}
-
-		memset(tc, 0, EFT_SIZE);
-		rval = qla2x00_enable_eft_trace(ha, tc_dma, EFT_NUM_BUFFERS);
-		if (rval) {
-			qla_printk(KERN_WARNING, ha, "Unable to initialize "
-			    "EFT (%d).\n", rval);
-			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc,
-			    tc_dma);
-			goto cont_alloc;
-		}
-
-		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for EFT...\n",
-		    EFT_SIZE / 1024);
-
-		eft_size = EFT_SIZE;
-		ha->eft_dma = tc_dma;
-		ha->eft = tc;
-
 		/* Allocate memory for Fibre Channel Event Buffer. */
 		if (!IS_QLA25XX(ha))
-			goto cont_alloc;
+			goto try_eft;
 
 		tc = dma_alloc_coherent(&ha->pdev->dev, FCE_SIZE, &tc_dma,
 		    GFP_KERNEL);
 		if (!tc) {
 			qla_printk(KERN_WARNING, ha, "Unable to allocate "
 			    "(%d KB) for FCE.\n", FCE_SIZE / 1024);
-			goto cont_alloc;
+			goto try_eft;
 		}
 
 		memset(tc, 0, FCE_SIZE);
@@ -815,7 +789,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 			dma_free_coherent(&ha->pdev->dev, FCE_SIZE, tc,
 			    tc_dma);
 			ha->flags.fce_enabled = 0;
-			goto cont_alloc;
+			goto try_eft;
 		}
 
 		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for FCE...\n",
@@ -825,6 +799,32 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *ha)
 		ha->flags.fce_enabled = 1;
 		ha->fce_dma = tc_dma;
 		ha->fce = tc;
+try_eft:
+		/* Allocate memory for Extended Trace Buffer. */
+		tc = dma_alloc_coherent(&ha->pdev->dev, EFT_SIZE, &tc_dma,
+		    GFP_KERNEL);
+		if (!tc) {
+			qla_printk(KERN_WARNING, ha, "Unable to allocate "
+			    "(%d KB) for EFT.\n", EFT_SIZE / 1024);
+			goto cont_alloc;
+		}
+
+		memset(tc, 0, EFT_SIZE);
+		rval = qla2x00_enable_eft_trace(ha, tc_dma, EFT_NUM_BUFFERS);
+		if (rval) {
+			qla_printk(KERN_WARNING, ha, "Unable to initialize "
+			    "EFT (%d).\n", rval);
+			dma_free_coherent(&ha->pdev->dev, EFT_SIZE, tc,
+			    tc_dma);
+			goto cont_alloc;
+		}
+
+		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for EFT...\n",
+		    EFT_SIZE / 1024);
+
+		eft_size = EFT_SIZE;
+		ha->eft_dma = tc_dma;
+		ha->eft = tc;
 	}
 cont_alloc:
 	req_q_size = ha->request_q_length * sizeof(request_t);
@@ -3286,17 +3286,6 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 			ha->isp_abort_cnt = 0;
 			clear_bit(ISP_ABORT_RETRY, &ha->dpc_flags);
 
-			if (ha->eft) {
-				memset(ha->eft, 0, EFT_SIZE);
-				rval = qla2x00_enable_eft_trace(ha,
-				    ha->eft_dma, EFT_NUM_BUFFERS);
-				if (rval) {
-					qla_printk(KERN_WARNING, ha,
-					    "Unable to reinitialize EFT "
-					    "(%d).\n", rval);
-				}
-			}
-
 			if (ha->fce) {
 				ha->flags.fce_enabled = 1;
 				memset(ha->fce, 0,
@@ -3311,6 +3300,17 @@ qla2x00_abort_isp(scsi_qla_host_t *ha)
 					ha->flags.fce_enabled = 0;
 				}
 			}
+
+			if (ha->eft) {
+				memset(ha->eft, 0, EFT_SIZE);
+				rval = qla2x00_enable_eft_trace(ha,
+				    ha->eft_dma, EFT_NUM_BUFFERS);
+				if (rval) {
+					qla_printk(KERN_WARNING, ha,
+					    "Unable to reinitialize EFT "
+					    "(%d).\n", rval);
+				}
+			}
 		} else {	/* failed the ISP abort */
 			ha->flags.online = 1;
 			if (test_bit(ISP_ABORT_RETRY, &ha->dpc_flags)) {
-- 
1.5.6.2.292.ga9a3

