From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] qla1280: convert to use the data buffer accessors
Date: Wed, 17 Oct 2007 21:34:42 +0900
Message-ID: <20071017213442V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:33541 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310AbXJQMgE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 08:36:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Any chance to send this for 2.6.24?

This is a data buffer accessor cleanup dependent on sg chaining. Now
it can cleanly applied to the latest Linus tree.


qla1280: convert to use the data buffer accessors

- remove the unnecessary map_single path.

- convert to use the new accessors for the sg lists and the parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/qla1280.c |  376 ++++++++++++++++++++----------------------------
 1 files changed, 157 insertions(+), 219 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 76089cf..1744244 100644
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
@@ -2893,120 +2882,95 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		/* Setup packet address segment pointer. */
 		dword_ptr = (u32 *)&pkt->dseg_0_address;
 
-		if (cmd->use_sg) {	/* If scatter gather */
-			/* Load command entry data segments. */
-			for_each_sg(sg, s, seg_cnt, cnt) {
-				if (cnt == 2)
+		/* Load command entry data segments. */
+		for_each_sg(sg, s, seg_cnt, cnt) {
+			if (cnt == 2)
+				break;
+			dma_handle = sg_dma_address(s);
+#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
+			if (ha->flags.use_pci_vchannel)
+				sn_pci_set_vchan(ha->pdev,
+						 (unsigned long *)&dma_handle,
+						 SCSI_BUS_32(cmd));
+#endif
+			*dword_ptr++ =
+				cpu_to_le32(pci_dma_lo32(dma_handle));
+			*dword_ptr++ =
+				cpu_to_le32(pci_dma_hi32(dma_handle));
+			*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
+			dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
+				cpu_to_le32(pci_dma_hi32(dma_handle)),
+				cpu_to_le32(pci_dma_lo32(dma_handle)),
+				cpu_to_le32(sg_dma_len(sg_next(s))));
+			remseg--;
+		}
+		dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
+			"command packet data - b %i, t %i, l %i \n",
+			SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
+			SCSI_LUN_32(cmd));
+		qla1280_dump_buffer(5, (char *)pkt,
+				    REQUEST_ENTRY_SIZE);
+
+		/*
+		 * Build continuation packets.
+		 */
+		dprintk(3, "S/G Building Continuation...seg_cnt=0x%x "
+			"remains\n", seg_cnt);
+
+		while (remseg > 0) {
+			/* Update sg start */
+			sg = s;
+			/* Adjust ring index. */
+			ha->req_ring_index++;
+			if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
+				ha->req_ring_index = 0;
+				ha->request_ring_ptr =
+					ha->request_ring;
+			} else
+				ha->request_ring_ptr++;
+
+			pkt = (cmd_a64_entry_t *)ha->request_ring_ptr;
+
+			/* Zero out packet. */
+			memset(pkt, 0, REQUEST_ENTRY_SIZE);
+
+			/* Load packet defaults. */
+			((struct cont_a64_entry *) pkt)->entry_type =
+				CONTINUE_A64_TYPE;
+			((struct cont_a64_entry *) pkt)->entry_count = 1;
+			((struct cont_a64_entry *) pkt)->sys_define =
+				(uint8_t)ha->req_ring_index;
+			/* Setup packet address segment pointer. */
+			dword_ptr =
+				(u32 *)&((struct cont_a64_entry *) pkt)->dseg_0_address;
+
+			/* Load continuation entry data segments. */
+			for_each_sg(sg, s, remseg, cnt) {
+				if (cnt == 5)
 					break;
 				dma_handle = sg_dma_address(s);
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 				if (ha->flags.use_pci_vchannel)
 					sn_pci_set_vchan(ha->pdev,
-							(unsigned long *)&dma_handle,
+							 (unsigned long *)&dma_handle,
 							 SCSI_BUS_32(cmd));
 #endif
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_lo32(dma_handle));
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_hi32(dma_handle));
-				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
-				dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
+				*dword_ptr++ =
+					cpu_to_le32(sg_dma_len(s));
+				dprintk(3, "S/G Segment Cont. phys_addr=%x %x, len=0x%x\n",
 					cpu_to_le32(pci_dma_hi32(dma_handle)),
 					cpu_to_le32(pci_dma_lo32(dma_handle)),
-					cpu_to_le32(sg_dma_len(sg_next(s))));
-				remseg--;
-			}
-			dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-				"command packet data - b %i, t %i, l %i \n",
-				SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
-				SCSI_LUN_32(cmd));
-			qla1280_dump_buffer(5, (char *)pkt,
-					    REQUEST_ENTRY_SIZE);
-
-			/*
-			 * Build continuation packets.
-			 */
-			dprintk(3, "S/G Building Continuation...seg_cnt=0x%x "
-				"remains\n", seg_cnt);
-
-			while (remseg > 0) {
-				/* Update sg start */
-				sg = s;
-				/* Adjust ring index. */
-				ha->req_ring_index++;
-				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
-					ha->req_ring_index = 0;
-					ha->request_ring_ptr =
-						ha->request_ring;
-				} else
-						ha->request_ring_ptr++;
-
-				pkt = (cmd_a64_entry_t *)ha->request_ring_ptr;
-
-				/* Zero out packet. */
-				memset(pkt, 0, REQUEST_ENTRY_SIZE);
-
-				/* Load packet defaults. */
-				((struct cont_a64_entry *) pkt)->entry_type =
-					CONTINUE_A64_TYPE;
-				((struct cont_a64_entry *) pkt)->entry_count = 1;
-				((struct cont_a64_entry *) pkt)->sys_define =
-					(uint8_t)ha->req_ring_index;
-				/* Setup packet address segment pointer. */
-				dword_ptr =
-					(u32 *)&((struct cont_a64_entry *) pkt)->dseg_0_address;
-
-				/* Load continuation entry data segments. */
-				for_each_sg(sg, s, remseg, cnt) {
-					if (cnt == 5)
-						break;
-					dma_handle = sg_dma_address(s);
-#if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
-				if (ha->flags.use_pci_vchannel)
-					sn_pci_set_vchan(ha->pdev, 
-							(unsigned long *)&dma_handle,
-							 SCSI_BUS_32(cmd));
-#endif
-					*dword_ptr++ =
-						cpu_to_le32(pci_dma_lo32(dma_handle));
-					*dword_ptr++ =
-						cpu_to_le32(pci_dma_hi32(dma_handle));
-					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(s));
-					dprintk(3, "S/G Segment Cont. phys_addr=%x %x, len=0x%x\n",
-						cpu_to_le32(pci_dma_hi32(dma_handle)),
-						cpu_to_le32(pci_dma_lo32(dma_handle)),
-						cpu_to_le32(sg_dma_len(s)));
-				}
-				remseg -= cnt;
-				dprintk(5, "qla1280_64bit_start_scsi: "
-					"continuation packet data - b %i, t "
-					"%i, l %i \n", SCSI_BUS_32(cmd),
-					SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
-				qla1280_dump_buffer(5, (char *)pkt,
-						    REQUEST_ENTRY_SIZE);
+					cpu_to_le32(sg_dma_len(s)));
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
+			remseg -= cnt;
+			dprintk(5, "qla1280_64bit_start_scsi: "
+				"continuation packet data - b %i, t "
+				"%i, l %i \n", SCSI_BUS_32(cmd),
+				SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 			qla1280_dump_buffer(5, (char *)pkt,
 					    REQUEST_ENTRY_SIZE);
 		}
@@ -3073,7 +3037,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	int status = 0;
 	int cnt;
 	int req_cnt;
-	uint16_t seg_cnt;
+	int seg_cnt;
 	dma_addr_t dma_handle;
 	u8 dir;
 
@@ -3083,18 +3047,8 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		cmd->cmnd[0]);
 
 	/* Calculate number of entries and segments required. */
-	req_cnt = 1;
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
+	if (seg_cnt) {
 		/*
 		 * if greater than four sg entries then we need to allocate
 		 * continuation entries
@@ -3106,14 +3060,9 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
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
@@ -3198,87 +3147,76 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		/* Setup packet address segment pointer. */
 		dword_ptr = &pkt->dseg_0_address;
 
-		if (cmd->use_sg) {	/* If scatter gather */
-			dprintk(3, "Building S/G data segments..\n");
-			qla1280_dump_buffer(1, (char *)sg, 4 * 16);
+		dprintk(3, "Building S/G data segments..\n");
+		qla1280_dump_buffer(1, (char *)sg, 4 * 16);
+
+		/* Load command entry data segments. */
+		for_each_sg(sg, s, seg_cnt, cnt) {
+			if (cnt == 4)
+				break;
+			*dword_ptr++ =
+				cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
+			*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
+			dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
+				(pci_dma_lo32(sg_dma_address(s))),
+				(sg_dma_len(s)));
+			remseg--;
+		}
+		/*
+		 * Build continuation packets.
+		 */
+		dprintk(3, "S/G Building Continuation"
+			"...seg_cnt=0x%x remains\n", seg_cnt);
+		while (remseg > 0) {
+			/* Continue from end point */
+			sg = s;
+			/* Adjust ring index. */
+			ha->req_ring_index++;
+			if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
+				ha->req_ring_index = 0;
+				ha->request_ring_ptr =
+					ha->request_ring;
+			} else
+				ha->request_ring_ptr++;
+
+			pkt = (struct cmd_entry *)ha->request_ring_ptr;
+
+			/* Zero out packet. */
+			memset(pkt, 0, REQUEST_ENTRY_SIZE);
+
+			/* Load packet defaults. */
+			((struct cont_entry *) pkt)->
+				entry_type = CONTINUE_TYPE;
+			((struct cont_entry *) pkt)->entry_count = 1;
+
+			((struct cont_entry *) pkt)->sys_define =
+				(uint8_t) ha->req_ring_index;
 
-			/* Load command entry data segments. */
-			for_each_sg(sg, s, seg_cnt, cnt) {
-				if (cnt == 4)
+			/* Setup packet address segment pointer. */
+			dword_ptr =
+				&((struct cont_entry *) pkt)->dseg_0_address;
+
+			/* Load continuation entry data segments. */
+			for_each_sg(sg, s, remseg, cnt) {
+				if (cnt == 7)
 					break;
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
-				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
-				dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
-					(pci_dma_lo32(sg_dma_address(s))),
-					(sg_dma_len(s)));
-				remseg--;
-			}
-			/*
-			 * Build continuation packets.
-			 */
-			dprintk(3, "S/G Building Continuation"
-				"...seg_cnt=0x%x remains\n", seg_cnt);
-			while (remseg > 0) {
-				/* Continue from end point */
-				sg = s;
-				/* Adjust ring index. */
-				ha->req_ring_index++;
-				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
-					ha->req_ring_index = 0;
-					ha->request_ring_ptr =
-						ha->request_ring;
-				} else
-					ha->request_ring_ptr++;
-
-				pkt = (struct cmd_entry *)ha->request_ring_ptr;
-
-				/* Zero out packet. */
-				memset(pkt, 0, REQUEST_ENTRY_SIZE);
-
-				/* Load packet defaults. */
-				((struct cont_entry *) pkt)->
-					entry_type = CONTINUE_TYPE;
-				((struct cont_entry *) pkt)->entry_count = 1;
-
-				((struct cont_entry *) pkt)->sys_define =
-					(uint8_t) ha->req_ring_index;
-
-				/* Setup packet address segment pointer. */
-				dword_ptr =
-					&((struct cont_entry *) pkt)->dseg_0_address;
-
-				/* Load continuation entry data segments. */
-				for_each_sg(sg, s, remseg, cnt) {
-					if (cnt == 7)
-						break;
-					*dword_ptr++ =
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
-					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(s));
-					dprintk(1,
-						"S/G Segment Cont. phys_addr=0x%x, "
-						"len=0x%x\n",
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
-						cpu_to_le32(sg_dma_len(s)));
-				}
-				remseg -= cnt;
-				dprintk(5, "qla1280_32bit_start_scsi: "
-					"continuation packet data - "
-					"scsi(%i:%i:%i)\n", SCSI_BUS_32(cmd),
-					SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
-				qla1280_dump_buffer(5, (char *)pkt,
-						    REQUEST_ENTRY_SIZE);
+				*dword_ptr++ =
+					cpu_to_le32(sg_dma_len(s));
+				dprintk(1,
+					"S/G Segment Cont. phys_addr=0x%x, "
+					"len=0x%x\n",
+					cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
+					cpu_to_le32(sg_dma_len(s)));
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
+			remseg -= cnt;
+			dprintk(5, "qla1280_32bit_start_scsi: "
+				"continuation packet data - "
+				"scsi(%i:%i:%i)\n", SCSI_BUS_32(cmd),
+				SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
+			qla1280_dump_buffer(5, (char *)pkt,
+					    REQUEST_ENTRY_SIZE);
 		}
 	} else {	/* No data transfer at all */
 		dprintk(5, "qla1280_32bit_start_scsi: No data, command "
@@ -4086,9 +4024,9 @@ __qla1280_print_scsi_cmd(struct scsi_cmnd *cmd)
 	for (i = 0; i < cmd->cmd_len; i++) {
 		printk("0x%02x ", cmd->cmnd[i]);
 	}
-	printk("  seg_cnt =%d\n", cmd->use_sg);
+	printk("  seg_cnt =%d\n", scsi_sg_count(cmd));
 	printk("  request buffer=0x%p, request buffer len=0x%x\n",
-	       cmd->request_buffer, cmd->request_bufflen);
+	       scsi_sglist(cmd), scsi_bufflen(cmd));
 	/* if (cmd->use_sg)
 	   {
 	   sg = (struct scatterlist *) cmd->request_buffer;
-- 
1.5.2.4

