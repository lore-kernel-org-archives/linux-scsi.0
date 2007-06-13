From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] ips: convert to use the data buffer accessors
Date: Wed, 13 Jun 2007 23:27:09 +0900 (JST)
Message-ID: <20070613225501W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:64931 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbXFMO1W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jun 2007 10:27:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, mark_salyzyn@adaptec.com

Mark pointed out that the initial patch has problems in the breakup
handling. This is an updated patch.

---
>From 50d2daa783e6b323aeea30c9dddefba18f00f9e9 Mon Sep 17 00:00:00 2001
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 12 Jun 2007 13:18:26 -0400
Subject: [PATCH] ips: convert to use the data buffer accessors

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the
parameters.

Jens Axboe <jens.axboe@oracle.com> did the for_each_sg cleanup.

TODO: use scsi_for_each_sg() in the breakup handling.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ips.c |  256 ++++++++++++++++++++--------------------------------
 1 files changed, 99 insertions(+), 157 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 84f4f5d..f9fce70 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1104,7 +1104,7 @@ static int ips_queue(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *))
 		/* A Reset IOCTL is only sent by the boot CD in extreme cases.           */
 		/* There can never be any system activity ( network or disk ), but check */
 		/* anyway just as a good practice.                                       */
-		pt = (ips_passthru_t *) SC->request_buffer;
+		pt = (ips_passthru_t *) scsi_sglist(SC);
 		if ((pt->CoppCP.cmd.reset.op_code == IPS_CMD_RESET_CHANNEL) &&
 		    (pt->CoppCP.cmd.reset.adapter_flag == 1)) {
 			if (ha->scb_activelist.count != 0) {
@@ -1507,30 +1507,22 @@ static int ips_is_passthru(struct scsi_cmnd *SC)
 	if ((SC->cmnd[0] == IPS_IOCTL_COMMAND) &&
 	    (SC->device->channel == 0) &&
 	    (SC->device->id == IPS_ADAPTER_ID) &&
-	    (SC->device->lun == 0) && SC->request_buffer) {
-		if ((!SC->use_sg) && SC->request_bufflen &&
-		    (((char *) SC->request_buffer)[0] == 'C') &&
-		    (((char *) SC->request_buffer)[1] == 'O') &&
-		    (((char *) SC->request_buffer)[2] == 'P') &&
-		    (((char *) SC->request_buffer)[3] == 'P'))
-			return 1;
-		else if (SC->use_sg) {
-			struct scatterlist *sg = SC->request_buffer;
-			char  *buffer; 
-
-			/* kmap_atomic() ensures addressability of the user buffer.*/
-			/* local_irq_save() protects the KM_IRQ0 address slot.     */
-			local_irq_save(flags);
-			buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset; 
-			if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
-			    buffer[2] == 'P' && buffer[3] == 'P') {
-				kunmap_atomic(buffer - sg->offset, KM_IRQ0);
-				local_irq_restore(flags);
-				return 1;
-			}
-			kunmap_atomic(buffer - sg->offset, KM_IRQ0);
-			local_irq_restore(flags);
-		}
+	    (SC->device->lun == 0) && scsi_sglist(SC)) {
+                struct scatterlist *sg = scsi_sglist(SC);
+                char  *buffer;
+
+                /* kmap_atomic() ensures addressability of the user buffer.*/
+                /* local_irq_save() protects the KM_IRQ0 address slot.     */
+                local_irq_save(flags);
+                buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+                if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
+                    buffer[2] == 'P' && buffer[3] == 'P') {
+                        kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+                        local_irq_restore(flags);
+                        return 1;
+                }
+                kunmap_atomic(buffer - sg->offset, KM_IRQ0);
+                local_irq_restore(flags);
 	}
 	return 0;
 }
@@ -1581,18 +1573,14 @@ ips_make_passthru(ips_ha_t *ha, struct scsi_cmnd *SC, ips_scb_t *scb, int intr)
 {
 	ips_passthru_t *pt;
 	int length = 0;
-	int ret;
+	int i, ret;
+        struct scatterlist *sg = scsi_sglist(SC);
 
 	METHOD_TRACE("ips_make_passthru", 1);
 
-	if (!SC->use_sg) {
-		length = SC->request_bufflen;
-	} else {
-		struct scatterlist *sg = SC->request_buffer;
-		int i;
-		for (i = 0; i < SC->use_sg; i++)
-			length += sg[i].length;
-	}
+        scsi_for_each_sg(SC, sg, scsi_sg_count(SC), i)
+                length += sg[i].length;
+
 	if (length < sizeof (ips_passthru_t)) {
 		/* wrong size */
 		DEBUG_VAR(1, "(%s%d) Passthru structure wrong size",
@@ -2016,7 +2004,7 @@ ips_cleanup_passthru(ips_ha_t * ha, ips_scb_t * scb)
 
 	METHOD_TRACE("ips_cleanup_passthru", 1);
 
-	if ((!scb) || (!scb->scsi_cmd) || (!scb->scsi_cmd->request_buffer)) {
+	if ((!scb) || (!scb->scsi_cmd) || (!scsi_sglist(scb->scsi_cmd))) {
 		DEBUG_VAR(1, "(%s%d) couldn't cleanup after passthru",
 			  ips_name, ha->host_num);
 
@@ -2766,41 +2754,26 @@ ips_next(ips_ha_t * ha, int intr)
 		/* copy in the CDB */
 		memcpy(scb->cdb, SC->cmnd, SC->cmd_len);
 
-		/* Now handle the data buffer */
-		if (SC->use_sg) {
+                scb->sg_count = scsi_dma_map(SC);
+                BUG_ON(scb->sg_count < 0);
+		if (scb->sg_count) {
 			struct scatterlist *sg;
 			int i;
 
-			sg = SC->request_buffer;
-			scb->sg_count = pci_map_sg(ha->pcidev, sg, SC->use_sg,
-						   SC->sc_data_direction);
 			scb->flags |= IPS_SCB_MAP_SG;
-			for (i = 0; i < scb->sg_count; i++) {
+
+                        scsi_for_each_sg(SC, sg, scb->sg_count, i) {
 				if (ips_fill_scb_sg_single
-				    (ha, sg_dma_address(&sg[i]), scb, i,
-				     sg_dma_len(&sg[i])) < 0)
+				    (ha, sg_dma_address(sg), scb, i,
+				     sg_dma_len(sg)) < 0)
 					break;
 			}
 			scb->dcdb.transfer_length = scb->data_len;
 		} else {
-			if (SC->request_bufflen) {
-				scb->data_busaddr =
-				    pci_map_single(ha->pcidev,
-						   SC->request_buffer,
-						   SC->request_bufflen,
-						   SC->sc_data_direction);
-				scb->flags |= IPS_SCB_MAP_SINGLE;
-				ips_fill_scb_sg_single(ha, scb->data_busaddr,
-						       scb, 0,
-						       SC->request_bufflen);
-				scb->dcdb.transfer_length = scb->data_len;
-			} else {
-				scb->data_busaddr = 0L;
-				scb->sg_len = 0;
-				scb->data_len = 0;
-				scb->dcdb.transfer_length = 0;
-			}
-
+                        scb->data_busaddr = 0L;
+                        scb->sg_len = 0;
+                        scb->data_len = 0;
+                        scb->dcdb.transfer_length = 0;
 		}
 
 		scb->dcdb.cmd_attribute =
@@ -3277,52 +3250,32 @@ ips_done(ips_ha_t * ha, ips_scb_t * scb)
 		 * the rest of the data and continue.
 		 */
 		if ((scb->breakup) || (scb->sg_break)) {
+                        struct scatterlist *sg;
+                        int sg_dma_index, ips_sg_index = 0;
+
 			/* we had a data breakup */
 			scb->data_len = 0;
 
-			if (scb->sg_count) {
-				/* S/G request */
-				struct scatterlist *sg;
-				int ips_sg_index = 0;
-				int sg_dma_index;
-
-				sg = scb->scsi_cmd->request_buffer;
-
-				/* Spin forward to last dma chunk */
-				sg_dma_index = scb->breakup;
-
-				/* Take care of possible partial on last chunk */
-				ips_fill_scb_sg_single(ha,
-						       sg_dma_address(&sg
-								      [sg_dma_index]),
-						       scb, ips_sg_index++,
-						       sg_dma_len(&sg
-								  [sg_dma_index]));
-
-				for (; sg_dma_index < scb->sg_count;
-				     sg_dma_index++) {
-					if (ips_fill_scb_sg_single
-					    (ha,
-					     sg_dma_address(&sg[sg_dma_index]),
-					     scb, ips_sg_index++,
-					     sg_dma_len(&sg[sg_dma_index])) < 0)
-						break;
+                        sg = scsi_sglist(scb->scsi_cmd);
 
-				}
+                        /* Spin forward to last dma chunk */
+                        sg_dma_index = scb->breakup;
 
-			} else {
-				/* Non S/G Request */
-				(void) ips_fill_scb_sg_single(ha,
-							      scb->
-							      data_busaddr +
-							      (scb->sg_break *
-							       ha->max_xfer),
-							      scb, 0,
-							      scb->scsi_cmd->
-							      request_bufflen -
-							      (scb->sg_break *
-							       ha->max_xfer));
-			}
+			/* Take care of possible partial on last chunk */
+                        ips_fill_scb_sg_single(ha,
+                                               sg_dma_address(&sg[sg_dma_index]),
+                                               scb, ips_sg_index++,
+                                               sg_dma_len(&sg[sg_dma_index]));
+
+                        for (; sg_dma_index < scsi_sg_count(scb->scsi_cmd);
+                             sg_dma_index++) {
+                                if (ips_fill_scb_sg_single
+                                    (ha,
+                                     sg_dma_address(&sg[sg_dma_index]),
+                                     scb, ips_sg_index++,
+                                     sg_dma_len(&sg[sg_dma_index])) < 0)
+                                        break;
+                        }
 
 			scb->dcdb.transfer_length = scb->data_len;
 			scb->dcdb.cmd_attribute |=
@@ -3553,32 +3506,27 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int timeout, int intr)
 static void
 ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
 {
-	if (scmd->use_sg) {
-		int i;
-		unsigned int min_cnt, xfer_cnt;
-		char *cdata = (char *) data;
-		unsigned char *buffer;
-		unsigned long flags;
-		struct scatterlist *sg = scmd->request_buffer;
-		for (i = 0, xfer_cnt = 0;
-		     (i < scmd->use_sg) && (xfer_cnt < count); i++) {
-			min_cnt = min(count - xfer_cnt, sg[i].length);
-
-			/* kmap_atomic() ensures addressability of the data buffer.*/
-			/* local_irq_save() protects the KM_IRQ0 address slot.     */
-			local_irq_save(flags);
-			buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
-			memcpy(buffer, &cdata[xfer_cnt], min_cnt);
-			kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
-			local_irq_restore(flags);
-
-			xfer_cnt += min_cnt;
-		}
-
-	} else {
-		unsigned int min_cnt = min(count, scmd->request_bufflen);
-		memcpy(scmd->request_buffer, data, min_cnt);
-	}
+        int i;
+        unsigned int min_cnt, xfer_cnt;
+        char *cdata = (char *) data;
+        unsigned char *buffer;
+        unsigned long flags;
+        struct scatterlist *sg = scsi_sglist(scmd);
+
+        for (i = 0, xfer_cnt = 0;
+             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
+                min_cnt = min(count - xfer_cnt, sg[i].length);
+
+                /* kmap_atomic() ensures addressability of the data buffer.*/
+                /* local_irq_save() protects the KM_IRQ0 address slot.     */
+                local_irq_save(flags);
+                buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+                memcpy(buffer, &cdata[xfer_cnt], min_cnt);
+                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+                local_irq_restore(flags);
+
+                xfer_cnt += min_cnt;
+        }
 }
 
 /****************************************************************************/
@@ -3591,32 +3539,27 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
 static void
 ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
 {
-	if (scmd->use_sg) {
-		int i;
-		unsigned int min_cnt, xfer_cnt;
-		char *cdata = (char *) data;
-		unsigned char *buffer;
-		unsigned long flags;
-		struct scatterlist *sg = scmd->request_buffer;
-		for (i = 0, xfer_cnt = 0;
-		     (i < scmd->use_sg) && (xfer_cnt < count); i++) {
-			min_cnt = min(count - xfer_cnt, sg[i].length);
-
-			/* kmap_atomic() ensures addressability of the data buffer.*/
-			/* local_irq_save() protects the KM_IRQ0 address slot.     */
-			local_irq_save(flags);
-			buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
-			memcpy(&cdata[xfer_cnt], buffer, min_cnt);
-			kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
-			local_irq_restore(flags);
-
-			xfer_cnt += min_cnt;
-		}
-
-	} else {
-		unsigned int min_cnt = min(count, scmd->request_bufflen);
-		memcpy(data, scmd->request_buffer, min_cnt);
-	}
+        int i;
+        unsigned int min_cnt, xfer_cnt;
+        char *cdata = (char *) data;
+        unsigned char *buffer;
+        unsigned long flags;
+        struct scatterlist *sg = scsi_sglist(scmd);
+
+        for (i = 0, xfer_cnt = 0;
+             (i < scsi_sg_count(scmd)) && (xfer_cnt < count); i++) {
+                min_cnt = min(count - xfer_cnt, sg[i].length);
+
+                /* kmap_atomic() ensures addressability of the data buffer.*/
+                /* local_irq_save() protects the KM_IRQ0 address slot.     */
+                local_irq_save(flags);
+                buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+                memcpy(&cdata[xfer_cnt], buffer, min_cnt);
+                kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
+                local_irq_restore(flags);
+
+                xfer_cnt += min_cnt;
+        }
 }
 
 /****************************************************************************/
@@ -4250,7 +4193,7 @@ ips_rdcap(ips_ha_t * ha, ips_scb_t * scb)
 
 	METHOD_TRACE("ips_rdcap", 1);
 
-	if (scb->scsi_cmd->request_bufflen < 8)
+	if (scsi_bufflen(scb->scsi_cmd) < 8)
 		return (0);
 
 	cap.lba =
@@ -4635,8 +4578,7 @@ ips_freescb(ips_ha_t * ha, ips_scb_t * scb)
 
 	METHOD_TRACE("ips_freescb", 1);
 	if (scb->flags & IPS_SCB_MAP_SG)
-		pci_unmap_sg(ha->pcidev, scb->scsi_cmd->request_buffer,
-			     scb->scsi_cmd->use_sg, IPS_DMA_DIR(scb));
+                scsi_dma_unmap(scb->scsi_cmd);
 	else if (scb->flags & IPS_SCB_MAP_SINGLE)
 		pci_unmap_single(ha->pcidev, scb->data_busaddr, scb->data_len,
 				 IPS_DMA_DIR(scb));
-- 
1.4.4.4

