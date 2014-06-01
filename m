From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 1/2] libiscsi, iser: Adjust data_length to include protection information
Date: Sun,  1 Jun 2014 19:19:40 +0300
Message-ID: <1401639581-20111-2-git-send-email-sagig@mellanox.com>
References: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1401639581-20111-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

In case protection information exists over the wire
iscsi header data_length field is required to include it.

Also remove iser transfer length checks for each task as
they are not always true and somewhat redundant anyway.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iser_initiator.c |   34 +++++++-----------------
 drivers/scsi/libiscsi.c                      |   35 +++++++++++++++++++++++++-
 include/scsi/libiscsi.h                      |   19 ++++++++++++++
 3 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 2e2d903..1600e35 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -41,11 +41,11 @@
 #include "iscsi_iser.h"
 
 /* Register user buffer memory and initialize passive rdma
- *  dto descriptor. Total data size is stored in
- *  iser_task->data[ISER_DIR_IN].data_len
+ *  dto descriptor. Data size is stored in
+ *  task->data[ISER_DIR_IN].data_len, Protection size
+ *  os stored in task->prot[ISER_DIR_IN].data_len
  */
-static int iser_prepare_read_cmd(struct iscsi_task *task,
-				 unsigned int edtl)
+static int iser_prepare_read_cmd(struct iscsi_task *task)
 
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
@@ -73,14 +73,6 @@ static int iser_prepare_read_cmd(struct iscsi_task *task,
 			return err;
 	}
 
-	if (edtl > iser_task->data[ISER_DIR_IN].data_len) {
-		iser_err("Total data length: %ld, less than EDTL: "
-			 "%d, in READ cmd BHS itt: %d, conn: 0x%p\n",
-			 iser_task->data[ISER_DIR_IN].data_len, edtl,
-			 task->itt, iser_task->ib_conn);
-		return -EINVAL;
-	}
-
 	err = device->iser_reg_rdma_mem(iser_task, ISER_DIR_IN);
 	if (err) {
 		iser_err("Failed to set up Data-IN RDMA\n");
@@ -100,8 +92,9 @@ static int iser_prepare_read_cmd(struct iscsi_task *task,
 }
 
 /* Register user buffer memory and initialize passive rdma
- *  dto descriptor. Total data size is stored in
- *  task->data[ISER_DIR_OUT].data_len
+ *  dto descriptor. Data size is stored in
+ *  task->data[ISER_DIR_OUT].data_len, Protection size
+ *  is stored at task->prot[ISER_DIR_OUT].data_len
  */
 static int
 iser_prepare_write_cmd(struct iscsi_task *task,
@@ -135,14 +128,6 @@ iser_prepare_write_cmd(struct iscsi_task *task,
 			return err;
 	}
 
-	if (edtl > iser_task->data[ISER_DIR_OUT].data_len) {
-		iser_err("Total data length: %ld, less than EDTL: %d, "
-			 "in WRITE cmd BHS itt: %d, conn: 0x%p\n",
-			 iser_task->data[ISER_DIR_OUT].data_len,
-			 edtl, task->itt, task->conn);
-		return -EINVAL;
-	}
-
 	err = device->iser_reg_rdma_mem(iser_task, ISER_DIR_OUT);
 	if (err != 0) {
 		iser_err("Failed to register write cmd RDMA mem\n");
@@ -417,11 +402,12 @@ int iser_send_command(struct iscsi_conn *conn,
 	if (scsi_prot_sg_count(sc)) {
 		prot_buf->buf  = scsi_prot_sglist(sc);
 		prot_buf->size = scsi_prot_sg_count(sc);
-		prot_buf->data_len = sc->prot_sdb->length;
+		prot_buf->data_len = iscsi_prot_len(data_buf->data_len,
+						    sc->device->sector_size);
 	}
 
 	if (hdr->flags & ISCSI_FLAG_CMD_READ) {
-		err = iser_prepare_read_cmd(task, edtl);
+		err = iser_prepare_read_cmd(task);
 		if (err)
 			goto send_command_error;
 	}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 26dc005..b54d1cc 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -326,6 +326,31 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
 }
 
 /**
+ * iscsi_adjust_dl - Adjust SCSI data length to include PI
+ * @sc: scsi command.
+ * @data_length: command data length.
+ *
+ * Adjust the data length to account for how much data
+ * is actually on the wire.
+ *
+ * returns the adjusted data length
+ **/
+static unsigned
+iscsi_adjust_dl(struct scsi_cmnd *sc, unsigned data_len)
+{
+	if (sc->sc_data_direction == DMA_FROM_DEVICE) {
+		if (scsi_get_prot_op(sc) ==  SCSI_PROT_READ_INSERT)
+			return data_len;
+	} else {
+		if (scsi_get_prot_op(sc) ==  SCSI_PROT_WRITE_STRIP)
+			return data_len;
+	}
+
+	/* Protection information exists on the wire */
+	return data_len + iscsi_prot_len(data_len, sc->device->sector_size);
+}
+
+/**
  * iscsi_prep_scsi_cmd_pdu - prep iscsi scsi cmd pdu
  * @task: iscsi task
  *
@@ -395,6 +420,9 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 		unsigned out_len = scsi_out(sc)->length;
 		struct iscsi_r2t_info *r2t = &task->unsol_r2t;
 
+		if (task->protected)
+			out_len = iscsi_adjust_dl(sc, out_len);
+
 		hdr->data_length = cpu_to_be32(out_len);
 		hdr->flags |= ISCSI_FLAG_CMD_WRITE;
 		/*
@@ -436,9 +464,14 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 			/* No unsolicit Data-Out's */
 			hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 	} else {
+		unsigned in_len = scsi_in(sc)->length;
+
 		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
 		zero_data(hdr->dlength);
-		hdr->data_length = cpu_to_be32(scsi_in(sc)->length);
+		if (task->protected)
+			in_len = iscsi_adjust_dl(sc, in_len);
+
+		hdr->data_length = cpu_to_be32(in_len);
 
 		if (sc->sc_data_direction == DMA_FROM_DEVICE)
 			hdr->flags |= ISCSI_FLAG_CMD_READ;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 728c9ad..534a1dc 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -494,4 +494,23 @@ iscsi_padding(unsigned int len)
 	return len;
 }
 
+/*
+ * data integrity helpers
+ */
+static inline unsigned
+iscsi_prot_len(unsigned data_len, unsigned sector_size)
+{
+	switch (sector_size) {
+	case 512:
+		return (data_len >> 9) * 8;
+	case 1024:
+		return (data_len >> 10) * 8;
+	case 2048:
+		return (data_len >> 11) * 8;
+	case 4096:
+		return (data_len >> 12) * 8;
+	default:
+		return (data_len >> ilog2(sector_size)) * 8;
+	}
+}
 #endif
-- 
1.7.1
