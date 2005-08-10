From: James.Smart@Emulex.Com
Subject: [PATCH 3 of 7] lpfc driver 8.0.30 : fix iocb reuse initialization
Date: Wed, 10 Aug 2005 15:02:45 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F439F@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64141 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030197AbVHJTCs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 15:02:48 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j7AJ2kr7000744
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2005 12:02:47 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

IOCB BDE not getting fully initialized during reuse

Symptoms: Driver gets Status 3 and Reason 0x13 on IOCB completions.

Cause: The IOCB bpl.bdeSize and bdeFlags are not getting initialized on reuse.

Fix: Reinitialize these fields in prep_dma each time an IOCB is used.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -238,6 +238,8 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 		bpl->tus.f.bdeSize = scsi_cmnd->request_bufflen;
 		if (datadir == DMA_TO_DEVICE)
 			bpl->tus.f.bdeFlags = 0;
+		else
+			bpl->tus.f.bdeFlags = BUFF_USE_RCV;
 		bpl->tus.w = le32_to_cpu(bpl->tus.w);
 		num_bde = 1;
 		bpl++;
@@ -245,8 +247,11 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *
 
 	/*
 	 * Finish initializing those IOCB fields that are dependent on the
-	 * scsi_cmnd request_buffer
+	 * scsi_cmnd request_buffer.  Note that the bdeSize is explicitly
+	 * reinitialized since all iocb memory resources are used many times
+	 * for transmit, receive, and continuation bpl's.
 	 */
+	iocb_cmd->un.fcpi64.bdl.bdeSize = (2 * sizeof (struct ulp_bde64));
 	iocb_cmd->un.fcpi64.bdl.bdeSize +=
 		(num_bde * sizeof (struct ulp_bde64));
 	iocb_cmd->ulpBdeCount = 1;
