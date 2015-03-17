From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 26/42] hpsa: add support sending aborts to physical
 devices via the ioaccel2 path
Date: Tue, 17 Mar 2015 15:04:45 -0500
Message-ID: <20150317200445.19856.26822.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:59605 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288AbbCQUGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:06:24 -0400
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen Cameron <stephenmcameron@gmail.com>

add support for tmf when in ioaccel2 mode

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |  136 +++++++++++++++++++++++++++++++++++++++++++++--
 drivers/scsi/hpsa.h     |    1 
 drivers/scsi/hpsa_cmd.h |    6 +-
 3 files changed, 135 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7d0e226..e9642dd 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -861,6 +861,28 @@ static void set_ioaccel1_performant_mode(struct ctlr_info *h,
 					IOACCEL1_BUSADDR_CMDTYPE;
 }
 
+static void set_ioaccel2_tmf_performant_mode(struct ctlr_info *h,
+						struct CommandList *c,
+						int reply_queue)
+{
+	struct hpsa_tmf_struct *cp = (struct hpsa_tmf_struct *)
+		&h->ioaccel2_cmd_pool[c->cmdindex];
+
+	/* Tell the controller to post the reply to the queue for this
+	 * processor.  This seems to give the best I/O throughput.
+	 */
+	if (likely(reply_queue == DEFAULT_REPLY_QUEUE))
+		cp->reply_queue = smp_processor_id() % h->nreply_queues;
+	else
+		cp->reply_queue = reply_queue % h->nreply_queues;
+	/* Set the bits in the address sent down to include:
+	 *  - performant mode bit not used in ioaccel mode 2
+	 *  - pull count (bits 0-3)
+	 *  - command type isn't needed for ioaccel2
+	 */
+	c->busaddr |= h->ioaccel2_blockFetchTable[0];
+}
+
 static void set_ioaccel2_performant_mode(struct ctlr_info *h,
 						struct CommandList *c,
 						int reply_queue)
@@ -927,6 +949,10 @@ static void __enqueue_cmd_and_start_io(struct ctlr_info *h,
 		set_ioaccel2_performant_mode(h, c, reply_queue);
 		writel(c->busaddr, h->vaddr + IOACCEL2_INBOUND_POSTQ_32);
 		break;
+	case IOACCEL2_TMF:
+		set_ioaccel2_tmf_performant_mode(h, c, reply_queue);
+		writel(c->busaddr, h->vaddr + IOACCEL2_INBOUND_POSTQ_32);
+		break;
 	default:
 		set_performant_mode(h, c, reply_queue);
 		h->access.submit_command(h, c);
@@ -4954,6 +4980,47 @@ static int hpsa_send_abort(struct ctlr_info *h, unsigned char *scsi3addr,
 	return rc;
 }
 
+static void setup_ioaccel2_abort_cmd(struct CommandList *c, struct ctlr_info *h,
+	struct CommandList *command_to_abort, int reply_queue)
+{
+	struct io_accel2_cmd *c2 = &h->ioaccel2_cmd_pool[c->cmdindex];
+	struct hpsa_tmf_struct *ac = (struct hpsa_tmf_struct *) c2;
+	struct io_accel2_cmd *c2a =
+		&h->ioaccel2_cmd_pool[command_to_abort->cmdindex];
+	struct scsi_cmnd *scmd =
+		(struct scsi_cmnd *) command_to_abort->scsi_cmd;
+	struct hpsa_scsi_dev_t *dev = scmd->device->hostdata;
+
+	/*
+	 * We're overlaying struct hpsa_tmf_struct on top of something which
+	 * was allocated as a struct io_accel2_cmd, so we better be sure it
+	 * actually fits, and doesn't overrun the error info space.
+	 */
+	BUILD_BUG_ON(sizeof(struct hpsa_tmf_struct) >
+			sizeof(struct io_accel2_cmd));
+	BUG_ON(offsetof(struct io_accel2_cmd, error_data) <
+			offsetof(struct hpsa_tmf_struct, error_len) +
+				sizeof(ac->error_len));
+
+	c->cmd_type = IOACCEL2_TMF;
+	/* Adjust the DMA address to point to the accelerated command buffer */
+	c->busaddr = (u32) h->ioaccel2_cmd_pool_dhandle +
+				(c->cmdindex * sizeof(struct io_accel2_cmd));
+	BUG_ON(c->busaddr & 0x0000007F);
+
+	memset(ac, 0, sizeof(*c2)); /* yes this is correct */
+	ac->iu_type = IOACCEL2_IU_TMF_TYPE;
+	ac->reply_queue = reply_queue;
+	ac->tmf = IOACCEL2_TMF_ABORT;
+	ac->it_nexus = cpu_to_le32(dev->ioaccel_handle);
+	memset(ac->lun_id, 0, sizeof(ac->lun_id));
+	ac->tag = cpu_to_le64(c->cmdindex << DIRECT_LOOKUP_SHIFT);
+	ac->abort_tag = cpu_to_le64(le32_to_cpu(c2a->Tag));
+	ac->error_ptr = cpu_to_le64(c->busaddr +
+			offsetof(struct io_accel2_cmd, error_data));
+	ac->error_len = cpu_to_le32(sizeof(c2->error_data));
+}
+
 /* ioaccel2 path firmware cannot handle abort task requests.
  * Change abort requests to physical target reset, and send to the
  * address of the physical disk used for the ioaccel 2 command.
@@ -5032,17 +5099,72 @@ static int hpsa_send_reset_as_abort_ioaccel2(struct ctlr_info *h,
 	return rc; /* success */
 }
 
+static int hpsa_send_abort_ioaccel2(struct ctlr_info *h,
+	struct CommandList *abort, int reply_queue)
+{
+	int rc = IO_OK;
+	struct CommandList *c;
+	__le32 taglower, tagupper;
+	struct hpsa_scsi_dev_t *dev;
+	struct io_accel2_cmd *c2;
+
+	dev = abort->scsi_cmd->device->hostdata;
+	if (!dev->offload_enabled && !dev->hba_ioaccel_enabled)
+		return -1;
+
+	c = cmd_alloc(h);
+	setup_ioaccel2_abort_cmd(c, h, abort, reply_queue);
+	c2 = &h->ioaccel2_cmd_pool[c->cmdindex];
+	(void) hpsa_scsi_do_simple_cmd(h, c, reply_queue, NO_TIMEOUT);
+	hpsa_get_tag(h, abort, &taglower, &tagupper);
+	dev_dbg(&h->pdev->dev,
+		"%s: Tag:0x%08x:%08x: do_simple_cmd(ioaccel2 abort) completed.\n",
+		__func__, tagupper, taglower);
+	/* no unmap needed here because no data xfer. */
+
+	dev_dbg(&h->pdev->dev,
+		"%s: Tag:0x%08x:%08x: abort service response = 0x%02x.\n",
+		__func__, tagupper, taglower, c2->error_data.serv_response);
+	switch (c2->error_data.serv_response) {
+	case IOACCEL2_SERV_RESPONSE_TMF_COMPLETE:
+	case IOACCEL2_SERV_RESPONSE_TMF_SUCCESS:
+		rc = 0;
+		break;
+	case IOACCEL2_SERV_RESPONSE_TMF_REJECTED:
+	case IOACCEL2_SERV_RESPONSE_FAILURE:
+	case IOACCEL2_SERV_RESPONSE_TMF_WRONG_LUN:
+		rc = -1;
+		break;
+	default:
+		dev_warn(&h->pdev->dev,
+			"%s: Tag:0x%08x:%08x: unknown abort service response 0x%02x\n",
+			__func__, tagupper, taglower,
+			c2->error_data.serv_response);
+		rc = -1;
+	}
+	cmd_free(h, c);
+	dev_dbg(&h->pdev->dev, "%s: Tag:0x%08x:%08x: Finished.\n", __func__,
+		tagupper, taglower);
+	return rc;
+}
+
 static int hpsa_send_abort_both_ways(struct ctlr_info *h,
 	unsigned char *scsi3addr, struct CommandList *abort, int reply_queue)
 {
-	/* ioccelerator mode 2 commands should be aborted via the
+	/*
+	 * ioccelerator mode 2 commands should be aborted via the
 	 * accelerated path, since RAID path is unaware of these commands,
-	 * but underlying firmware can't handle abort TMF.
-	 * Change abort to physical device reset.
+	 * but not all underlying firmware can handle abort TMF.
+	 * Change abort to physical device reset when abort TMF is unsupported.
 	 */
-	if (abort->cmd_type == CMD_IOACCEL2)
-		return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr,
+	if (abort->cmd_type == CMD_IOACCEL2) {
+		if (HPSATMF_IOACCEL_ENABLED & h->TMFSupportFlags)
+			return hpsa_send_abort_ioaccel2(h, abort,
+						reply_queue);
+		else
+			return hpsa_send_reset_as_abort_ioaccel2(h, scsi3addr,
 							abort, reply_queue);
+	}
 	return hpsa_send_abort(h, scsi3addr, abort, reply_queue);
 }
 
@@ -5927,7 +6049,7 @@ static inline void finish_cmd(struct CommandList *c)
 	if (likely(c->cmd_type == CMD_IOACCEL1 || c->cmd_type == CMD_SCSI
 			|| c->cmd_type == CMD_IOACCEL2))
 		complete_scsi_command(c);
-	else if (c->cmd_type == CMD_IOCTL_PEND)
+	else if (c->cmd_type == CMD_IOCTL_PEND || c->cmd_type == IOACCEL2_TMF)
 		complete(c->waiting);
 }
 
@@ -6714,6 +6836,8 @@ static void hpsa_find_board_params(struct ctlr_info *h)
 		dev_warn(&h->pdev->dev, "Physical aborts not supported\n");
 	if (!(HPSATMF_LOG_TASK_ABORT & h->TMFSupportFlags))
 		dev_warn(&h->pdev->dev, "Logical aborts not supported\n");
+	if (!(HPSATMF_IOACCEL_ENABLED & h->TMFSupportFlags))
+		dev_warn(&h->pdev->dev, "HP SSD Smart Path aborts not supported\n");
 }
 
 static inline bool hpsa_CISS_signature_present(struct ctlr_info *h)
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 3acacf6..28b5d79 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -231,6 +231,7 @@ struct ctlr_info {
 #define HPSATMF_PHYS_QRY_TASK   (1 << 7)
 #define HPSATMF_PHYS_QRY_TSET   (1 << 8)
 #define HPSATMF_PHYS_QRY_ASYNC  (1 << 9)
+#define HPSATMF_IOACCEL_ENABLED (1 << 15)
 #define HPSATMF_MASK_SUPPORTED  (1 << 16)
 #define HPSATMF_LOG_LUN_RESET   (1 << 17)
 #define HPSATMF_LOG_NEX_RESET   (1 << 18)
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index cecb62b..3719592 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -396,6 +396,7 @@ struct ErrorInfo {
 #define CMD_SCSI	0x03
 #define CMD_IOACCEL1	0x04
 #define CMD_IOACCEL2	0x05
+#define IOACCEL2_TMF	0x06
 
 #define DIRECT_LOOKUP_SHIFT 4
 #define DIRECT_LOOKUP_MASK (~((1 << DIRECT_LOOKUP_SHIFT) - 1))
@@ -590,6 +591,7 @@ struct io_accel2_cmd {
 #define IOACCEL2_DIR_NO_DATA	0x00
 #define IOACCEL2_DIR_DATA_IN	0x01
 #define IOACCEL2_DIR_DATA_OUT	0x02
+#define IOACCEL2_TMF_ABORT	0x01
 /*
  * SCSI Task Management Request format for Accelerator Mode 2
  */
@@ -598,13 +600,13 @@ struct hpsa_tmf_struct {
 	u8 reply_queue;		/* Reply Queue ID */
 	u8 tmf;			/* Task Management Function */
 	u8 reserved1;		/* byte 3 Reserved */
-	u32 it_nexus;		/* SCSI I-T Nexus */
+	__le32 it_nexus;	/* SCSI I-T Nexus */
 	u8 lun_id[8];		/* LUN ID for TMF request */
 	__le64 tag;		/* cciss tag associated w/ request */
 	__le64 abort_tag;	/* cciss tag of SCSI cmd or TMF to abort */
 	__le64 error_ptr;		/* Error Pointer */
 	__le32 error_len;		/* Error Length */
-};
+} __aligned(IOACCEL2_COMMANDLIST_ALIGNMENT);
 
 /* Configuration Table Structure */
 struct HostWrite {

