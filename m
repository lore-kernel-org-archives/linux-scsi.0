From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 22/32 ver2] qla1280: Indentation fix
Date: Thu, 18 Oct 2007 18:32:07 +0200
Message-ID: <47178A87.2050409@panasas.com>
References: <47164306.6090702@panasas.com> <47165001.2090204@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8941 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758990AbXJRQdR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 12:33:17 -0400
In-Reply-To: <47165001.2090204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


  - Indentation fix of last patch. Don't be fooled by diff,
    all I did was back-indent from open-bracket to close-bracket,
    and remove the brackets.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/qla1280.c |  290 ++++++++++++++++++++++++------------------------
 1 files changed, 143 insertions(+), 147 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 7a18b1a..bf07b17 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2882,99 +2882,97 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		/* Setup packet address segment pointer. */
 		dword_ptr = (u32 *)&pkt->dseg_0_address;
 
-		{	/* FIXME:Indentation in next patch */
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
+						(unsigned long *)&dma_handle,
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
+					ha->request_ring_ptr++;
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
-				if (ha->flags.use_pci_vchannel)
-					sn_pci_set_vchan(ha->pdev,
-							(unsigned long *)&dma_handle,
-							 SCSI_BUS_32(cmd));
+			if (ha->flags.use_pci_vchannel)
+				sn_pci_set_vchan(ha->pdev,
+						(unsigned long *)&dma_handle,
+						 SCSI_BUS_32(cmd));
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
+					cpu_to_le32(sg_dma_len(s)));
 			}
-			dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
-				"command packet data - b %i, t %i, l %i \n",
-				SCSI_BUS_32(cmd), SCSI_TCN_32(cmd),
-				SCSI_LUN_32(cmd));
+			remseg -= cnt;
+			dprintk(5, "qla1280_64bit_start_scsi: "
+				"continuation packet data - b %i, t "
+				"%i, l %i \n", SCSI_BUS_32(cmd),
+				SCSI_TCN_32(cmd), SCSI_LUN_32(cmd));
 			qla1280_dump_buffer(5, (char *)pkt,
 					    REQUEST_ENTRY_SIZE);
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
-			}
 		}
 	} else {	/* No data transfer */
 		dprintk(5, "qla1280_64bit_start_scsi: No data, command "
@@ -3150,78 +3148,76 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 		/* Setup packet address segment pointer. */
 		dword_ptr = &pkt->dseg_0_address;
 
-		{	/* FIXME:Indentation in next patch */
-			dprintk(3, "Building S/G data segments..\n");
-			qla1280_dump_buffer(1, (char *)sg, 4 * 16);
+		dprintk(3, "Building S/G data segments..\n");
+		qla1280_dump_buffer(1, (char *)sg, 4 * 16);
 
-			/* Load command entry data segments. */
-			for_each_sg(sg, s, seg_cnt, cnt) {
-				if (cnt == 4)
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
+
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
-- 
1.5.3.1


