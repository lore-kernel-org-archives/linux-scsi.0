From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: [PATCH] advansys: fix init error handling in case board is ASC_NARROW_BOARD
Date: Thu, 8 Apr 2010 11:39:41 -0300
Message-ID: <201004081139.42073.herton@mandriva.com.br>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:41247 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760Ab0DHOjr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2010 10:39:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>

Current advansys code can oops when using a board of type
ASC_NARROW_BOARD in the case an error occurs at initialization
(inside advansys_board_found). For example, when advansys can't find
firmware files, the oops as seen on this image can happen, after
applying previous advansys change ("[SCSI] advansys: fix regression with
request_firmware change"):
https://bzattachment.mandriva.com/attachment.cgi?id=16897

When initialization fails, like in this oops case, it is freeing items
of wrong struct in the dvc_var union of struct asc_board, as code was
choosing to always freeing "wide" board fields, leading to the crash.

This change fixes error handling on all initialization path so that we
can properly free/deinit fields when we have a "narrow" board.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/scsi/advansys.c |   50 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 9201afe..7f87979 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4724,6 +4724,10 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	BUG_ON((unsigned long)asc_dvc->overrun_buf & 7);
 	asc_dvc->overrun_dma = dma_map_single(board->dev, asc_dvc->overrun_buf,
 					ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+	if (dma_mapping_error(board->dev, asc_dvc->overrun_dma)) {
+		warn_code = -ENOMEM;
+		goto err_dma_map;
+	}
 	phy_addr = cpu_to_le32(asc_dvc->overrun_dma);
 	AscMemDWordCopyPtrToLram(iop_base, ASCV_OVERRUN_PADDR_D,
 				 (uchar *)&phy_addr, 1);
@@ -4739,14 +4743,23 @@ static ushort AscInitMicroCodeVar(ASC_DVC_VAR *asc_dvc)
 	AscSetPCAddr(iop_base, ASC_MCODE_START_ADDR);
 	if (AscGetPCAddr(iop_base) != ASC_MCODE_START_ADDR) {
 		asc_dvc->err_code |= ASC_IERR_SET_PC_ADDR;
-		return warn_code;
+		warn_code = UW_ERR;
+		goto err_mcode_start;
 	}
 	if (AscStartChip(iop_base) != 1) {
 		asc_dvc->err_code |= ASC_IERR_START_STOP_CHIP;
-		return warn_code;
+		warn_code = UW_ERR;
+		goto err_mcode_start;
 	}
 
 	return warn_code;
+
+err_mcode_start:
+	dma_unmap_single(board->dev, asc_dvc->overrun_dma,
+			 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+err_dma_map:
+	asc_dvc->overrun_dma = 0;
+	return warn_code;
 }
 
 static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
@@ -4802,6 +4815,8 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	}
 	release_firmware(fw);
 	warn_code |= AscInitMicroCodeVar(asc_dvc);
+	if (!asc_dvc->overrun_dma)
+		return warn_code;
 	asc_dvc->init_state |= ASC_INIT_STATE_END_LOAD_MC;
 	AscEnableInterrupt(iop_base);
 	return warn_code;
@@ -7978,9 +7993,10 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		status = AscInitAsc1000Driver(asc_dvc);
 
 		/* Refer to ASC_IERR_* definitions for meaning of 'err_code'. */
-		if (asc_dvc->err_code) {
+		if (asc_dvc->err_code || !asc_dvc->overrun_dma) {
 			scmd_printk(KERN_INFO, scp, "SCSI bus reset error: "
-				    "0x%x\n", asc_dvc->err_code);
+				    "0x%x, status: 0x%x\n", asc_dvc->err_code,
+				    status);
 			ret = FAILED;
 		} else if (status) {
 			scmd_printk(KERN_INFO, scp, "SCSI bus reset warning: "
@@ -12311,7 +12327,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		asc_dvc_varp->overrun_buf = kzalloc(ASC_OVERRUN_BSIZE, GFP_KERNEL);
 		if (!asc_dvc_varp->overrun_buf) {
 			ret = -ENOMEM;
-			goto err_free_wide_mem;
+			goto err_free_irq;
 		}
 		warn_code = AscInitAsc1000Driver(asc_dvc_varp);
 
@@ -12320,30 +12336,36 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 					"warn 0x%x, error 0x%x\n",
 					asc_dvc_varp->init_state, warn_code,
 					asc_dvc_varp->err_code);
-			if (asc_dvc_varp->err_code) {
+			if (!asc_dvc_varp->overrun_dma) {
 				ret = -ENODEV;
-				kfree(asc_dvc_varp->overrun_buf);
+				goto err_free_mem;
 			}
 		}
 	} else {
-		if (advansys_wide_init_chip(shost))
+		if (advansys_wide_init_chip(shost)) {
 			ret = -ENODEV;
+			goto err_free_mem;
+		}
 	}
 
-	if (ret)
-		goto err_free_wide_mem;
-
 	ASC_DBG_PRT_SCSI_HOST(2, shost);
 
 	ret = scsi_add_host(shost, boardp->dev);
 	if (ret)
-		goto err_free_wide_mem;
+		goto err_free_mem;
 
 	scsi_scan_host(shost);
 	return 0;
 
- err_free_wide_mem:
-	advansys_wide_free_mem(boardp);
+ err_free_mem:
+	if (ASC_NARROW_BOARD(boardp)) {
+		if (asc_dvc_varp->overrun_dma)
+			dma_unmap_single(boardp->dev, asc_dvc_varp->overrun_dma,
+					 ASC_OVERRUN_BSIZE, DMA_FROM_DEVICE);
+		kfree(asc_dvc_varp->overrun_buf);
+	} else
+		advansys_wide_free_mem(boardp);
+ err_free_irq:
 	free_irq(boardp->irq, shost);
  err_free_dma:
 #ifdef CONFIG_ISA
-- 
1.7.0.4

