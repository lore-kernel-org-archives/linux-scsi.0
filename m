From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [3/18]  qla2xxx: PCI DMA mappings rework
Date: Mon, 21 Jun 2004 22:50:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055032.GA8404@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-01-qfe0.socal.rr.com ([66.75.162.133]:27811 "EHLO
	ms-smtp-01-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266591AbUFVFqr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:46:47 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1839 04/06/03 15:44:26 andrew.vasquez@apc.qlogic.com +3 -0
  Restructure qla2x00_start_scsi() so that PCI mappings are
  done after we've verified command list and request queue
  resource availability.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_def.h  |    4 -
 drivers/scsi/qla2xxx/qla_iocb.c |   81 +++++++++++++++++-----------------------
 drivers/scsi/qla2xxx/qla_os.c   |    4 -
 3 files changed, 36 insertions(+), 53 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h	2004-06-21 15:36:53 -07:00
+++ b/drivers/scsi/qla2xxx/qla_def.h	2004-06-21 15:36:53 -07:00
@@ -264,10 +264,6 @@
 #define SRB_ERR_DEVICE	3		/* Request failed -- "device error" */
 #define SRB_ERR_OTHER	4
 
-	/* Segment/entries counts */
-	uint16_t	req_cnt;	/* !0 indicates counts determined */
-	uint16_t	tot_dsds;
-
 	/* SRB magic number */
 	uint16_t magic;
 #define SRB_MAGIC       0x10CB
diff -Nru a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:53 -07:00
+++ b/drivers/scsi/qla2xxx/qla_iocb.c	2004-06-21 15:36:53 -07:00
@@ -350,11 +350,12 @@
 	uint32_t	*clr_ptr;
 	uint32_t        index;
 	uint32_t	handle;
-	uint16_t	cnt;
 	cmd_entry_t	*cmd_pkt;
 	uint32_t        timeout;
 	struct scatterlist *sg;
-
+	uint16_t	cnt;
+	uint16_t	req_cnt;
+	uint16_t	tot_dsds;
 	device_reg_t	*reg;
 
 	/* Setup device pointers. */
@@ -372,72 +373,60 @@
 		ha->marker_needed = 0;
 	}
 
-	/* Calculate number of segments and entries required. */
-	if (sp->req_cnt == 0) {
-		sp->tot_dsds = 0;
-		if (cmd->use_sg) {
-			sg = (struct scatterlist *) cmd->request_buffer;
-			sp->tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
-			    cmd->sc_data_direction);
-		} else if (cmd->request_bufflen) {
-		    sp->tot_dsds++;
-		}
-		sp->req_cnt = (ha->calc_request_entries)(sp->tot_dsds);
-	}
-
 	/* Acquire ring specific lock */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (ha->req_q_cnt < (sp->req_cnt + 2)) {
-		/* Calculate number of free request entries */
-		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
-		if (ha->req_ring_index < cnt)
-			ha->req_q_cnt = cnt - ha->req_ring_index;
-		else
-			ha->req_q_cnt = ha->request_q_length -
-			    (ha->req_ring_index - cnt);
-	}
-
-	/* If no room for request in request ring */
-	if (ha->req_q_cnt < (sp->req_cnt + 2)) {
-		DEBUG5(printk("scsi(%ld): in-ptr=%x req_q_cnt=%x "
-		    "tot_dsds=%x.\n",
-		    ha->host_no, ha->req_ring_index, ha->req_q_cnt,
-		    sp->tot_dsds));
-
-		goto queuing_error;
-	}
-
 	/* Check for room in outstanding command list. */
 	handle = ha->current_outstanding_cmd;
 	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
 		handle++;
 		if (handle == MAX_OUTSTANDING_COMMANDS)
 			handle = 1;
-		if (ha->outstanding_cmds[handle] == 0) {
-			ha->current_outstanding_cmd = handle;
+		if (ha->outstanding_cmds[handle] == 0)
 			break;
-		}
 	}
-	if (index == MAX_OUTSTANDING_COMMANDS) {
-		DEBUG5(printk("scsi(%ld): Unable to queue command -- NO ROOM "
-		    "IN OUTSTANDING ARRAY (req_q_cnt=%x).\n",
-		    ha->host_no, ha->req_q_cnt));
+	if (index == MAX_OUTSTANDING_COMMANDS)
+		goto queuing_error;
+
+	/* Calculate the number of request entries needed. */
+	req_cnt = (ha->calc_request_entries)(cmd->request->nr_hw_segments);
+	if (ha->req_q_cnt < (req_cnt + 2)) {
+		cnt = RD_REG_WORD_RELAXED(ISP_REQ_Q_OUT(ha, reg));
+		if (ha->req_ring_index < cnt)
+			ha->req_q_cnt = cnt - ha->req_ring_index;
+		else
+			ha->req_q_cnt = ha->request_q_length -
+			    (ha->req_ring_index - cnt);
+	}
+	if (ha->req_q_cnt < (req_cnt + 2))
 		goto queuing_error;
+
+	/* Finally, we have enough space, now perform mappings. */
+	tot_dsds = 0;
+	if (cmd->use_sg) {
+		sg = (struct scatterlist *) cmd->request_buffer;
+		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
+		    cmd->sc_data_direction);
+		if (tot_dsds == 0)
+			goto queuing_error;
+	} else if (cmd->request_bufflen) {
+	    tot_dsds++;
 	}
+	req_cnt = (ha->calc_request_entries)(tot_dsds);
 
 	/* Build command packet */
+	ha->current_outstanding_cmd = handle;
 	ha->outstanding_cmds[handle] = sp;
 	sp->ha = ha;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
-	ha->req_q_cnt -= sp->req_cnt;
+	ha->req_q_cnt -= req_cnt;
 
 	cmd_pkt = (cmd_entry_t *)ha->request_ring_ptr;
 	cmd_pkt->handle = handle;
 	/* Zero out remaining portion of packet. */
 	clr_ptr = (uint32_t *)cmd_pkt + 2;
 	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
-	cmd_pkt->dseg_count = cpu_to_le16(sp->tot_dsds);
+	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
 
 	/* Set target ID */
 	SET_TARGET_ID(ha, cmd_pkt->target, fclun->fcport->loop_id);
@@ -477,10 +466,10 @@
 	cmd_pkt->byte_count = cpu_to_le32((uint32_t)cmd->request_bufflen);
 
 	/* Build IOCB segments */
-	(ha->build_scsi_iocbs)(sp, cmd_pkt, sp->tot_dsds);
+	(ha->build_scsi_iocbs)(sp, cmd_pkt, tot_dsds);
 
 	/* Set total data segment count. */
-	cmd_pkt->entry_count = (uint8_t)sp->req_cnt;
+	cmd_pkt->entry_count = (uint8_t)req_cnt;
 	wmb();
 
 	/* Adjust ring index. */
diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:36:53 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:36:53 -07:00
@@ -3627,10 +3627,8 @@
 	srb_t *sp;
 
 	sp = mempool_alloc(ha->srb_mempool, GFP_KERNEL);
-	if (sp) {
+	if (sp)
 		atomic_set(&sp->ref_count, 1);
-		sp->req_cnt = 0;
-	}
 	return (sp);
 }
 
