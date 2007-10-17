From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 21/32] qla1280: convert to use the data buffer accessors
Date: Wed, 17 Oct 2007 20:07:15 +0200
Message-ID: <47164F53.4010109@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1482 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754941AbXJQSIw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 14:08:52 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>

From: FUJITA Tomonori <tomof@acm.org>

  - remove the unnecessary map_single path.
  - convert to use the new accessors for the sg lists and the parameters.
  - NOTE: Indentation fix is in next patch. Otherwise this patch
    becomes totally impossible to read (and easily breakable)

Signed-off-by: FUJITA Tomonori <tomof@acm.org>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/qla1280.c |  101 +++++++++---------------------------------------
 1 files changed, 19 insertions(+), 82 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 76089cf..7a18b1a 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1310,14 +1310,7 @@ qla1280_done(struct scsi_qla_host *ha)
 		}
 
 		/* Release memory used for this I/O */
-		if (cmd->use_sg) {
-			pci_unmap_sg(ha->pdev, cmd->request_buffer,
-					cmd->use_sg, cmd->sc_data_direction);
-		} else if (cmd->request_bufflen) {
-			pci_unmap_single(ha->pdev, sp->saved_dma_handle,
-					cmd->request_bufflen,
-					cmd->sc_data_direction);
-		}
+		scsi_dma_unmap(cmd);
 
 		/* Call the mid-level driver interrupt handler */
 		CMD_HANDLE(sp->cmd) = (unsigned char *)INVALID_HANDLE;
@@ -1406,14 +1399,14 @@ qla1280_return_status(struct response * sts, struct scsi_cmnd *cp)
 		break;
 
 	case CS_DATA_UNDERRUN:
-		if ((cp->request_bufflen - residual_length) <
+		if ((scsi_bufflen(cp) - residual_length) <
 		    cp->underflow) {
 			printk(KERN_WARNING
 			       "scsi: Underflow detected - retrying "
 			       "command.\n");
 			host_status = DID_ERROR;
 		} else {
-			cp->resid = residual_length;
+			scsi_set_resid(cp, residual_length);
 			host_status = DID_OK;
 		}
 		break;
@@ -2781,27 +2774,23 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	int status = 0;
 	int cnt;
 	int req_cnt;
-	u16 seg_cnt;
+	int seg_cnt;
 	u8 dir;
 
 	ENTER("qla1280_64bit_start_scsi:");
 
 	/* Calculate number of entries and segments required. */
 	req_cnt = 1;
-	if (cmd->use_sg) {
-		sg = (struct scatterlist *) cmd->request_buffer;
-		seg_cnt = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-				     cmd->sc_data_direction);
-
+	seg_cnt = scsi_dma_map(cmd);
+	if (seg_cnt > 0) {
 		if (seg_cnt > 2) {
 			req_cnt += (seg_cnt - 2) / 5;
 			if ((seg_cnt - 2) % 5)
 				req_cnt++;
 		}
-	} else if (cmd->request_bufflen) {	/* If data transfer. */
-		seg_cnt = 1;
-	} else {
-		seg_cnt = 0;
+	} else if (seg_cnt < 0) {
+		status = 1;
+		goto out;
 	}
 
 	if ((req_cnt + 2) >= ha->req_q_cnt) {
@@ -2893,7 +2882,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		/* Setup packet address segment pointer. */
 		dword_ptr = (u32 *)&pkt->dseg_0_address;
 
-		if (cmd->use_sg) {	/* If scatter gather */
+		{	/* FIXME:Indentation in next patch */
 			/* Load command entry data segments. */
 			for_each_sg(sg, s, seg_cnt, cnt) {
 				if (cnt == 2)
@@ -2986,29 +2975,6 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 				qla1280_dump_buffer(5, (char *)pkt,
 						    REQUEST_ENTRY_SIZE);
 			}
-		} else {	/* No scatter gather data transfer */
-			dma_handle = pci_map_single(ha->pdev,
-					cmd->request_buffer,
-					cmd->request_bufflen,
-					cmd->sc_data_direction);
-
-			sp->saved_dma_handle = dma_handle;
-#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
-			if (ha->flags.use_pci_vchannel)
-				sn_pci_set_vchan(ha->pdev, 
-						(unsigned long *)&dma_handle,
-						 SCSI_BUS_32(cmd));
-#endif
-			*dword_ptr++ = cpu_to_le32(pci_dma_lo32(dma_handle));
-			*dword_ptr++ = cpu_to_le32(pci_dma_hi32(dma_handle));
-			*dword_ptr = cpu_to_le32(cmd->request_bufflen);
-
-			dprintk(5, "qla1280_64bit_start_scsi: No scatter/"
-				"gather command packet data - b %i, t %i, "
-				"l %i \n", SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
-				SCSI_LUN_32(cmd));
-			qla1280_dump_buffer(5, (char *)pkt,
-					    REQUEST_ENTRY_SIZE);
 		}
 	} else {	/* No data transfer */
 		dprintk(5, "qla1280_64bit_start_scsi: No data, command "
@@ -3073,7 +3039,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	int status = 0;
 	int cnt;
 	int req_cnt;
-	uint16_t seg_cnt;
+	int seg_cnt;
 	dma_addr_t dma_handle;
 	u8 dir;
 
@@ -3084,17 +3050,8 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 
 	/* Calculate number of entries and segments required. */
 	req_cnt = 1;
-	if (cmd->use_sg) {
-		/*
-		 * We must build an SG list in adapter format, as the kernel's
-		 * SG list cannot be used directly because of data field size
-		 * (__alpha__) differences and the kernel SG list uses virtual
-		 * addresses where we need physical addresses.
-		 */
-		sg = (struct scatterlist *) cmd->request_buffer;
-		seg_cnt = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-				     cmd->sc_data_direction);
-
+	seg_cnt = scsi_dma_map(cmd);
+	if (seg_cnt > 0) {
 		/*
 		 * if greater than four sg entries then we need to allocate
 		 * continuation entries
@@ -3106,14 +3063,9 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		}
 		dprintk(3, "S/G Transfer cmd=%p seg_cnt=0x%x, req_cnt=%x\n",
 			cmd, seg_cnt, req_cnt);
-	} else if (cmd->request_bufflen) {	/* If data transfer. */
-		dprintk(3, "No S/G transfer t=%x cmd=%p len=%x CDB=%x\n",
-			SCSI_TCN_32(cmd), cmd, cmd->request_bufflen,
-			cmd->cmnd[0]);
-		seg_cnt = 1;
-	} else {
-		/* dprintk(1, "No data transfer \n"); */
-		seg_cnt = 0;
+	} else if (seg_cnt < 0) {
+		status = 1;
+		goto out;
 	}
 
 	if ((req_cnt + 2) >= ha->req_q_cnt) {
@@ -3198,7 +3150,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		/* Setup packet address segment pointer. */
 		dword_ptr = &pkt->dseg_0_address;
 
-		if (cmd->use_sg) {	/* If scatter gather */
+		{	/* FIXME:Indentation in next patch */
 			dprintk(3, "Building S/G data segments..\n");
 			qla1280_dump_buffer(1, (char *)sg, 4 * 16);
 
@@ -3270,15 +3222,6 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 				qla1280_dump_buffer(5, (char *)pkt,
 						    REQUEST_ENTRY_SIZE);
 			}
-		} else {	/* No S/G data transfer */
-			dma_handle = pci_map_single(ha->pdev,
-					cmd->request_buffer,
-					cmd->request_bufflen,
-					cmd->sc_data_direction);
-			sp->saved_dma_handle = dma_handle;
-
-			*dword_ptr++ = cpu_to_le32(pci_dma_lo32(dma_handle));
-			*dword_ptr = cpu_to_le32(cmd->request_bufflen);
 		}
 	} else {	/* No data transfer at all */
 		dprintk(5, "qla1280_32bit_start_scsi: No data, command "
@@ -4086,15 +4029,9 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	for (i = 0; i < cmd->cmd_len; i++) {
 		printk("0x%02x ", cmd->cmnd[i]);
 	}
-	printk("  seg_cnt =%d\n", cmd->use_sg);
+	printk("  seg_cnt =%d\n", scsi_sg_count(cmd));
 	printk("  request buffer=0x%p, request buffer len=0x%x\n",
-	       cmd->request_buffer, cmd->request_bufflen);
-	/* if (cmd->use_sg)
-	   {
-	   sg = (struct scatterlist *) cmd->request_buffer;
-	   printk("  SG buffer: \n");
-	   qla1280_dump_buffer(1, (char *)sg, (cmd->use_sg*sizeof(struct scatterlist)));
-	   } */
+	       scsi_sglist(cmd), scsi_bufflen(cmd));
 	printk("  tag=%d, transfersize=0x%x \n",
 	       cmd->tag, cmd->transfersize);
 	printk("  Pid=%li, SP=0x%p\n", cmd->serial_number, CMD_SP(cmd));
-- 
1.5.3.1


