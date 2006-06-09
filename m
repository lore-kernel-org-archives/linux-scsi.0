From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] Remove last page_address from dc395x.c
Date: Fri, 9 Jun 2006 22:25:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606092216460.5256@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:32389 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750930AbWFIUZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 16:25:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jamie Lenehan <lenehan@twibble.org>, James Bottomley <James.Bottomley@steeleye.com>

Hi all,

the patch below removes the last use of page_address() from dc395x.c on 
INQUIRY path... The functionality is not changed. Yes, the ultimate fix 
would be to eliminate INQUIRY evaluation completely... Tested.

Thanks
Guennadi
---
Guennadi Liakhovetski

Dynamically map scattergather buffer instead of using page_address().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

diff -u a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2006-04-02 11:10:48.000000000 +0200
+++ b/drivers/scsi/dc395x.c	2006-06-09 00:18:41.000000000 +0200
@@ -3332,21 +3332,14 @@
 {
 	u8 tempcnt, status;
 	struct scsi_cmnd *cmd = srb->cmd;
-	struct ScsiInqData *ptr;
 	enum dma_data_direction dir = cmd->sc_data_direction;
-
-	if (cmd->use_sg) {
-		struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
-		ptr = (struct ScsiInqData *)(page_address(sg->page) + sg->offset);
-	} else {
-		ptr = (struct ScsiInqData *)(cmd->request_buffer);
-	}
+	int ckc_only = 1;
 
 	dprintkdbg(DBG_1, "srb_done: (pid#%li) <%02i-%i>\n", srb->cmd->pid,
 		srb->cmd->device->id, srb->cmd->device->lun);
-	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p addr=%p\n",
+	dprintkdbg(DBG_SG, "srb_done: srb=%p sg=%i(%i/%i) buf=%p\n",
 		srb, cmd->use_sg, srb->sg_index, srb->sg_count,
-		cmd->request_buffer, ptr);
+		cmd->request_buffer);
 	status = srb->target_status;
 	if (srb->flag & AUTO_REQSENSE) {
 		dprintkdbg(DBG_0, "srb_done: AUTO_REQSENSE1\n");
@@ -3485,29 +3478,47 @@
 					    srb->segment_x[0].address,
 					    cmd->request_bufflen, dir);
 	}
-
-	if ((cmd->result & RES_DID) == 0 && cmd->cmnd[0] == INQUIRY
-	    && cmd->cmnd[2] == 0 && cmd->request_bufflen >= 8
-	    && dir != PCI_DMA_NONE && ptr && (ptr->Vers & 0x07) >= 2)
-		dcb->inquiry7 = ptr->Flags;
+	ckc_only = 0;
 /* Check Error Conditions */
       ckc_e:
 
+	if (cmd->cmnd[0] == INQUIRY) {
+		unsigned char *base = NULL;
+		struct ScsiInqData *ptr;
+		unsigned long flags = 0;
+
+		if (cmd->use_sg) {
+			struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
+			size_t offset = 0, len = sizeof(struct ScsiInqData);
+
+			local_irq_save(flags);
+			base = scsi_kmap_atomic_sg(sg, cmd->use_sg, &offset, &len);
+			ptr = (struct ScsiInqData *)(base + offset);
+		} else
+			ptr = (struct ScsiInqData *)(cmd->request_buffer);
+
+		if (!ckc_only && (cmd->result & RES_DID) == 0
+		    && cmd->cmnd[2] == 0 && cmd->request_bufflen >= 8
+		    && dir != PCI_DMA_NONE && ptr && (ptr->Vers & 0x07) >= 2)
+			dcb->inquiry7 = ptr->Flags;
+
 	/*if( srb->cmd->cmnd[0] == INQUIRY && */
 	/*  (host_byte(cmd->result) == DID_OK || status_byte(cmd->result) & CHECK_CONDITION) ) */
-	if (cmd->cmnd[0] == INQUIRY && (cmd->result == (DID_OK << 16)
-					 || status_byte(cmd->
-							result) &
-					 CHECK_CONDITION)) {
-
-		if (!dcb->init_tcq_flag) {
-			add_dev(acb, dcb, ptr);
-			dcb->init_tcq_flag = 1;
+		if ((cmd->result == (DID_OK << 16)
+		     || status_byte(cmd->result) &
+		     CHECK_CONDITION)) {
+			if (!dcb->init_tcq_flag) {
+				add_dev(acb, dcb, ptr);
+				dcb->init_tcq_flag = 1;
+			}
 		}
 
+		if (cmd->use_sg) {
+			scsi_kunmap_atomic_sg(base);
+			local_irq_restore(flags);
+		}
 	}
 
-
 	/* Here is the info for Doug Gilbert's sg3 ... */
 	cmd->resid = srb->total_xfer_length;
 	/* This may be interpreted by sb. or not ... */
