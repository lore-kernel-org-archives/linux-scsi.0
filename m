From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH for-next 05/10] iser: Have initiator and target to share protocol structures and definitions
Date: Mon, 16 Nov 2015 18:37:36 +0200
Message-ID: <1447691861-3796-6-git-send-email-sagig@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>, Steve Wise <swise@opengridcomputing.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The iser RDMA_CM negotiation protocol is shared by
the initiator and the target, so have a shared header
for the defines and structure. Move relevant items from
the initiator and target headers.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Jenny Derzhavetz <jennyf@mellanox.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  41 ++--------
 drivers/infiniband/ulp/iser/iser_initiator.c |   6 +-
 drivers/infiniband/ulp/iser/iser_verbs.c     |   7 +-
 drivers/infiniband/ulp/isert/ib_isert.c      |  22 +++---
 drivers/infiniband/ulp/isert/ib_isert.h      |   6 +-
 include/scsi/iser.h                          | 109 +++++++++++++++++++++++++++
 6 files changed, 135 insertions(+), 56 deletions(-)
 create mode 100644 include/scsi/iser.h

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index fb7fa7aa113c..096d5234bbea 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -48,6 +48,7 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
+#include <scsi/iser.h>
 
 #include <linux/interrupt.h>
 #include <linux/wait.h>
@@ -154,43 +155,11 @@
 #define ISER_WC_BATCH_COUNT   16
 #define ISER_SIGNAL_CMD_COUNT 32
 
-#define ISER_VER			0x10
-#define ISER_WSV			0x08
-#define ISER_RSV			0x04
-
 #define ISER_FASTREG_LI_WRID		0xffffffffffffffffULL
 #define ISER_BEACON_WRID		0xfffffffffffffffeULL
 
-/**
- * struct iser_hdr - iSER header
- *
- * @flags:        flags support (zbva, remote_inv)
- * @rsvd:         reserved
- * @write_stag:   write rkey
- * @write_va:     write virtual address
- * @reaf_stag:    read rkey
- * @read_va:      read virtual address
- */
-struct iser_hdr {
-	u8      flags;
-	u8      rsvd[3];
-	__be32  write_stag;
-	__be64  write_va;
-	__be32  read_stag;
-	__be64  read_va;
-} __attribute__((packed));
-
-
-#define ISER_ZBVA_NOT_SUPPORTED		0x80
-#define ISER_SEND_W_INV_NOT_SUPPORTED	0x40
-
-struct iser_cm_hdr {
-	u8      flags;
-	u8      rsvd[3];
-} __packed;
-
-/* Constant PDU lengths calculations */
-#define ISER_HEADERS_LEN  (sizeof(struct iser_hdr) + sizeof(struct iscsi_hdr))
+/*Constant PDU lengths calculations */
+#define ISER_HEADERS_LEN       (sizeof(struct iser_ctrl) + sizeof(struct iscsi_hdr))
 
 #define ISER_RECV_DATA_SEG_LEN	128
 #define ISER_RX_PAYLOAD_SIZE	(ISER_HEADERS_LEN + ISER_RECV_DATA_SEG_LEN)
@@ -287,7 +256,7 @@ enum iser_desc_type {
  * @sig_attrs:     Signature attributes
  */
 struct iser_tx_desc {
-	struct iser_hdr              iser_header;
+	struct iser_ctrl             iser_header;
 	struct iscsi_hdr             iscsi_header;
 	enum   iser_desc_type        type;
 	u64		             dma_addr;
@@ -318,7 +287,7 @@ struct iser_tx_desc {
  * @pad:           for sense data TODO: Modify to maximum sense length supported
  */
 struct iser_rx_desc {
-	struct iser_hdr              iser_header;
+	struct iser_ctrl             iser_header;
 	struct iscsi_hdr             iscsi_header;
 	char		             data[ISER_RECV_DATA_SEG_LEN];
 	u64		             dma_addr;
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 07bf26427ee7..6a968e350c14 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -51,7 +51,7 @@ static int iser_prepare_read_cmd(struct iscsi_task *task)
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_mem_reg *mem_reg;
 	int err;
-	struct iser_hdr *hdr = &iser_task->desc.iser_header;
+	struct iser_ctrl *hdr = &iser_task->desc.iser_header;
 	struct iser_data_buf *buf_in = &iser_task->data[ISER_DIR_IN];
 
 	err = iser_dma_map_task_data(iser_task,
@@ -104,7 +104,7 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 	struct iscsi_iser_task *iser_task = task->dd_data;
 	struct iser_mem_reg *mem_reg;
 	int err;
-	struct iser_hdr *hdr = &iser_task->desc.iser_header;
+	struct iser_ctrl *hdr = &iser_task->desc.iser_header;
 	struct iser_data_buf *buf_out = &iser_task->data[ISER_DIR_OUT];
 	struct ib_sge *tx_dsg = &iser_task->desc.tx_sg[1];
 
@@ -167,7 +167,7 @@ static void iser_create_send_desc(struct iser_conn	*iser_conn,
 	ib_dma_sync_single_for_cpu(device->ib_device,
 		tx_desc->dma_addr, ISER_HEADERS_LEN, DMA_TO_DEVICE);
 
-	memset(&tx_desc->iser_header, 0, sizeof(struct iser_hdr));
+	memset(&tx_desc->iser_header, 0, sizeof(struct iser_ctrl));
 	tx_desc->iser_header.flags = ISER_VER;
 	tx_desc->num_sge = 1;
 }
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 09121e774d14..74161a566852 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -847,10 +847,9 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
 	conn_param.rnr_retry_count     = 6;
 
 	memset(&req_hdr, 0, sizeof(req_hdr));
-	req_hdr.flags = (ISER_ZBVA_NOT_SUPPORTED |
-			ISER_SEND_W_INV_NOT_SUPPORTED);
-	conn_param.private_data		= (void *)&req_hdr;
-	conn_param.private_data_len	= sizeof(struct iser_cm_hdr);
+	req_hdr.flags = (ISER_ZBVA_NOT_SUP | ISER_SEND_W_INV_NOT_SUP);
+	conn_param.private_data	= (void *)&req_hdr;
+	conn_param.private_data_len = sizeof(struct iser_cm_hdr);
 
 	ret = rdma_connect(cma_id, &conn_param);
 	if (ret) {
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 7dbae56e576a..97ac9ffaf1eb 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1054,8 +1054,8 @@ isert_create_send_desc(struct isert_conn *isert_conn,
 	ib_dma_sync_single_for_cpu(ib_dev, tx_desc->dma_addr,
 				   ISER_HEADERS_LEN, DMA_TO_DEVICE);
 
-	memset(&tx_desc->iser_header, 0, sizeof(struct iser_hdr));
-	tx_desc->iser_header.flags = ISER_VER;
+	memset(&tx_desc->iser_header, 0, sizeof(struct iser_ctrl));
+	tx_desc->iser_header.flags = ISCSI_CTRL;
 
 	tx_desc->num_sge = 1;
 	tx_desc->isert_cmd = isert_cmd;
@@ -1547,22 +1547,22 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 static void
 isert_rx_do_work(struct iser_rx_desc *rx_desc, struct isert_conn *isert_conn)
 {
-	struct iser_hdr *iser_hdr = &rx_desc->iser_header;
+	struct iser_ctrl *iser_ctrl = &rx_desc->iser_header;
 	uint64_t read_va = 0, write_va = 0;
 	uint32_t read_stag = 0, write_stag = 0;
 	int rc;
 
-	switch (iser_hdr->flags & 0xF0) {
+	switch (iser_ctrl->flags & 0xF0) {
 	case ISCSI_CTRL:
-		if (iser_hdr->flags & ISER_RSV) {
-			read_stag = be32_to_cpu(iser_hdr->read_stag);
-			read_va = be64_to_cpu(iser_hdr->read_va);
+		if (iser_ctrl->flags & ISER_RSV) {
+			read_stag = be32_to_cpu(iser_ctrl->read_stag);
+			read_va = be64_to_cpu(iser_ctrl->read_va);
 			isert_dbg("ISER_RSV: read_stag: 0x%x read_va: 0x%llx\n",
 				  read_stag, (unsigned long long)read_va);
 		}
-		if (iser_hdr->flags & ISER_WSV) {
-			write_stag = be32_to_cpu(iser_hdr->write_stag);
-			write_va = be64_to_cpu(iser_hdr->write_va);
+		if (iser_ctrl->flags & ISER_WSV) {
+			write_stag = be32_to_cpu(iser_ctrl->write_stag);
+			write_va = be64_to_cpu(iser_ctrl->write_va);
 			isert_dbg("ISER_WSV: write_stag: 0x%x write_va: 0x%llx\n",
 				  write_stag, (unsigned long long)write_va);
 		}
@@ -1573,7 +1573,7 @@ isert_rx_do_work(struct iser_rx_desc *rx_desc, struct isert_conn *isert_conn)
 		isert_err("iSER Hello message\n");
 		break;
 	default:
-		isert_warn("Unknown iSER hdr flags: 0x%02x\n", iser_hdr->flags);
+		isert_warn("Unknown iSER hdr flags: 0x%02x\n", iser_ctrl->flags);
 		break;
 	}
 
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 3d7fbc47c343..03ddc3e0087f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -3,6 +3,8 @@
 #include <linux/in6.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
+#include <scsi/iser.h>
+
 
 #define DRV_NAME	"isert"
 #define PFX		DRV_NAME ": "
@@ -56,7 +58,7 @@ enum iser_conn_state {
 };
 
 struct iser_rx_desc {
-	struct iser_hdr iser_header;
+	struct iser_ctrl iser_header;
 	struct iscsi_hdr iscsi_header;
 	char		data[ISER_RECV_DATA_SEG_LEN];
 	u64		dma_addr;
@@ -65,7 +67,7 @@ struct iser_rx_desc {
 } __packed;
 
 struct iser_tx_desc {
-	struct iser_hdr iser_header;
+	struct iser_ctrl iser_header;
 	struct iscsi_hdr iscsi_header;
 	enum isert_desc_type type;
 	u64		dma_addr;
diff --git a/include/scsi/iser.h b/include/scsi/iser.h
new file mode 100644
index 000000000000..16098de23f4b
--- /dev/null
+++ b/include/scsi/iser.h
@@ -0,0 +1,109 @@
+/*
+ * Copyright (c) 2015 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *	- Redistributions of source code must retain the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer.
+ *
+ *	- Redistributions in binary form must reproduce the above
+ *	  copyright notice, this list of conditions and the following
+ *	  disclaimer in the documentation and/or other materials
+ *	  provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+#ifndef ISCSI_ISER_H
+#define ISCSI_ISER_H
+
+#define ISER_ZBVA_NOT_SUP		0x80
+#define ISER_SEND_W_INV_NOT_SUP		0x40
+#define ISERT_ZBVA_NOT_USED		0x80
+#define ISERT_SEND_W_INV_NOT_USED	0x40
+
+#define ISCSI_CTRL	0x10
+#define ISER_HELLO	0x20
+#define ISER_HELLORPLY	0x30
+
+#define ISER_VER	0x10
+#define ISER_WSV	0x08
+#define ISER_RSV	0x04
+
+/**
+ * struct iser_cm_hdr - iSER CM header (from iSER Annex A12)
+ *
+ * @flags:        flags support (zbva, send_w_inv)
+ * @rsvd:         reserved
+ */
+struct iser_cm_hdr {
+	u8      flags;
+	u8      rsvd[3];
+} __packed;
+
+/**
+ * struct iser_ctrl - iSER header of iSCSI control PDU
+ *
+ * @flags:        opcode and read/write valid bits
+ * @rsvd:         reserved
+ * @write_stag:   write rkey
+ * @write_va:     write virtual address
+ * @reaf_stag:    read rkey
+ * @read_va:      read virtual address
+ */
+struct iser_ctrl {
+	u8      flags;
+	u8      rsvd[3];
+	__be32  write_stag;
+	__be64  write_va;
+	__be32  read_stag;
+	__be64  read_va;
+} __packed;
+
+/**
+ * struct iser_hello - iSER Hello header
+ *
+ * @opcode:       opcode (must be set to ISER_HELLO)
+ * @max_min_ver:  maximum and minimum iser versions
+ * @iser_ird:     iSER IRD
+ * @rsvd:         reserved
+ */
+struct iser_hello {
+	u8      opcode;
+	u8	max_min_ver;
+	u16	iser_ird;
+	u8	rsvd[20];
+} __packed;
+
+/**
+ * struct iser_hello_rep - iSER Hello reply header
+ *
+ * @opcode_rej:   opcode (must be set to ISER_HELLORPLY)
+ *                lower bit is reject bit
+ * @max_cur_ver:  maximum and current iser versions
+ * @iser_ord:     iSER ORD
+ * @rsvd:         reserved
+ */
+struct iser_hello_rep {
+	u8      opcode_rej;
+	u8	max_cur_ver;
+	u16	iser_ord;
+	u8	rsvd[20];
+} __packed;
+
+#endif /* ISCSI_ISER_H */
-- 
1.8.4.3
