From: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 21/33] qla1280: sg chaining support
Date: Mon, 16 Jul 2007 11:47:35 +0200
Message-ID: <11845792683713-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:9336 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759678AbXGPJsi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 05:48:38 -0400
In-Reply-To: <11845792671245-git-send-email-jens.axboe@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, hch@infradead.org

Interesting hardware setup...

Cc: hch@infradead.org
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 drivers/scsi/qla1280.c |   66 +++++++++++++++++++++++++++---------------------
 1 files changed, 37 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 54d8bdf..bd805ec 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -2775,7 +2775,7 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	cmd_a64_entry_t *pkt;
-	struct scatterlist *sg = NULL;
+	struct scatterlist *sg = NULL, *s;
 	__le32 *dword_ptr;
 	dma_addr_t dma_handle;
 	int status = 0;
@@ -2889,13 +2889,16 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	 * Load data segments.
 	 */
 	if (seg_cnt) {	/* If data transfer. */
+		int remseg = seg_cnt;
 		/* Setup packet address segment pointer. */
 		dword_ptr = (u32 *)&pkt->dseg_0_address;
 
 		if (cmd->use_sg) {	/* If scatter gather */
 			/* Load command entry data segments. */
-			for (cnt = 0; cnt < 2 && seg_cnt; cnt++, seg_cnt--) {
-				dma_handle = sg_dma_address(sg);
+			for_each_sg(sg, s, seg_cnt, cnt) {
+				if (cnt == 2)
+					break;
+				dma_handle = sg_dma_address(s);
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 				if (ha->flags.use_pci_vchannel)
 					sn_pci_set_vchan(ha->pdev,
@@ -2906,12 +2909,12 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 					cpu_to_le32(pci_dma_lo32(dma_handle));
 				*dword_ptr++ =
 					cpu_to_le32(pci_dma_hi32(dma_handle));
-				*dword_ptr++ = cpu_to_le32(sg_dma_len(sg));
-				sg++;
+				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
 				dprintk(3, "S/G Segment phys_addr=%x %x, len=0x%x\n",
 					cpu_to_le32(pci_dma_hi32(dma_handle)),
 					cpu_to_le32(pci_dma_lo32(dma_handle)),
-					cpu_to_le32(sg_dma_len(sg)));
+					cpu_to_le32(sg_dma_len(sg_next(s))));
+				remseg--;
 			}
 			dprintk(5, "qla1280_64bit_start_scsi: Scatter/gather "
 				"command packet data - b %i, t %i, l %i \n",
@@ -2926,7 +2929,9 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			dprintk(3, "S/G Building Continuation...seg_cnt=0x%x "
 				"remains\n", seg_cnt);
 
-			while (seg_cnt > 0) {
+			while (remseg > 0) {
+				/* Update sg start */
+				sg = s;
 				/* Adjust ring index. */
 				ha->req_ring_index++;
 				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
@@ -2952,9 +2957,10 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 					(u32 *)&((struct cont_a64_entry *) pkt)->dseg_0_address;
 
 				/* Load continuation entry data segments. */
-				for (cnt = 0; cnt < 5 && seg_cnt;
-				     cnt++, seg_cnt--) {
-					dma_handle = sg_dma_address(sg);
+				for_each_sg(sg, s, remseg, cnt) {
+					if (cnt == 5)
+						break;
+					dma_handle = sg_dma_address(s);
 #if defined(CONFIG_IA64_GENERIC) || defined(CONFIG_IA64_SGI_SN2)
 				if (ha->flags.use_pci_vchannel)
 					sn_pci_set_vchan(ha->pdev, 
@@ -2966,12 +2972,12 @@ qla1280_64bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 					*dword_ptr++ =
 						cpu_to_le32(pci_dma_hi32(dma_handle));
 					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(sg));
+						cpu_to_le32(sg_dma_len(s));
 					dprintk(3, "S/G Segment Cont. phys_addr=%x %x, len=0x%x\n",
 						cpu_to_le32(pci_dma_hi32(dma_handle)),
 						cpu_to_le32(pci_dma_lo32(dma_handle)),
-						cpu_to_le32(sg_dma_len(sg)));
-					sg++;
+						cpu_to_le32(sg_dma_len(s)));
+					remseg--;
 				}
 				dprintk(5, "qla1280_64bit_start_scsi: "
 					"continuation packet data - b %i, t "
@@ -3062,7 +3068,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	struct device_reg __iomem *reg = ha->iobase;
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct cmd_entry *pkt;
-	struct scatterlist *sg = NULL;
+	struct scatterlist *sg = NULL, *s;
 	__le32 *dword_ptr;
 	int status = 0;
 	int cnt;
@@ -3188,6 +3194,7 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 	 * Load data segments.
 	 */
 	if (seg_cnt) {
+		int remseg = seg_cnt;
 		/* Setup packet address segment pointer. */
 		dword_ptr = &pkt->dseg_0_address;
 
@@ -3196,22 +3203,25 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 			qla1280_dump_buffer(1, (char *)sg, 4 * 16);
 
 			/* Load command entry data segments. */
-			for (cnt = 0; cnt < 4 && seg_cnt; cnt++, seg_cnt--) {
+			for_each_sg(sg, s, seg_cnt, cnt) {
+				if (cnt == 4)
+					break;
 				*dword_ptr++ =
-					cpu_to_le32(pci_dma_lo32(sg_dma_address(sg)));
-				*dword_ptr++ =
-					cpu_to_le32(sg_dma_len(sg));
+					cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
+				*dword_ptr++ = cpu_to_le32(sg_dma_len(s));
 				dprintk(3, "S/G Segment phys_addr=0x%lx, len=0x%x\n",
-					(pci_dma_lo32(sg_dma_address(sg))),
-					(sg_dma_len(sg)));
-				sg++;
+					(pci_dma_lo32(sg_dma_address(s))),
+					(sg_dma_len(s)));
+				remseg--;
 			}
 			/*
 			 * Build continuation packets.
 			 */
 			dprintk(3, "S/G Building Continuation"
 				"...seg_cnt=0x%x remains\n", seg_cnt);
-			while (seg_cnt > 0) {
+			while (remseg > 0) {
+				/* Continue from end point */
+				sg = s;
 				/* Adjust ring index. */
 				ha->req_ring_index++;
 				if (ha->req_ring_index == REQUEST_ENTRY_CNT) {
@@ -3239,18 +3249,16 @@ qla1280_32bit_start_scsi(struct scsi_qla_host *ha, struct srb * sp)
 					&((struct cont_entry *) pkt)->dseg_0_address;
 
 				/* Load continuation entry data segments. */
-				for (cnt = 0; cnt < 7 && seg_cnt;
-				     cnt++, seg_cnt--) {
+				for_each_sg(sg, s, remseg, cnt) {
 					*dword_ptr++ =
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(sg)));
+						cpu_to_le32(pci_dma_lo32(sg_dma_address(s)));
 					*dword_ptr++ =
-						cpu_to_le32(sg_dma_len(sg));
+						cpu_to_le32(sg_dma_len(s));
 					dprintk(1,
 						"S/G Segment Cont. phys_addr=0x%x, "
 						"len=0x%x\n",
-						cpu_to_le32(pci_dma_lo32(sg_dma_address(sg))),
-						cpu_to_le32(sg_dma_len(sg)));
-					sg++;
+						cpu_to_le32(pci_dma_lo32(sg_dma_address(s))),
+						cpu_to_le32(sg_dma_len(s)));
 				}
 				dprintk(5, "qla1280_32bit_start_scsi: "
 					"continuation packet data - "
-- 
1.5.3.rc0.90.gbaa79

