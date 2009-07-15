From: michaelc@cs.wisc.edu
Subject: [PATCH 6/6] qla4xxx: Remove hiwat code so scsi eh does not get escalated when we can make progress
Date: Wed, 15 Jul 2009 15:03:02 -0500
Message-ID: <1247688182-15764-7-git-send-email-michaelc@cs.wisc.edu>
References: <1247688182-15764-1-git-send-email-michaelc@cs.wisc.edu>
 <1247688182-15764-2-git-send-email-michaelc@cs.wisc.edu>
 <1247688182-15764-3-git-send-email-michaelc@cs.wisc.edu>
 <1247688182-15764-4-git-send-email-michaelc@cs.wisc.edu>
 <1247688182-15764-5-git-send-email-michaelc@cs.wisc.edu>
 <1247688182-15764-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60940 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326AbZGOUDK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2009 16:03:10 -0400
In-Reply-To: <1247688182-15764-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Karen Higgins <karen.higgins@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Karen Higgins <karen.higgins@qlogic.com>

Removed unnecessary hiwat code to free up the number available IOCBs.
Eliminates unnecessary eh_ escalations due to inability to obtain IOCB
pkt for marker.

Patch was made over scsi-rc-fixes.

v2.
- Remove define not used anymore and fix req_q_coun accounting.

Signed-off-by: Karen Higgins <karen.higgins@qlogic.com>
[michaelc: ported patch from qlogic.com driver to upstream]
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    2 -
 drivers/scsi/qla4xxx/ql4_iocb.c |  133 +++++++++++++++++---------------------
 drivers/scsi/qla4xxx/ql4_mbx.c  |   10 ---
 3 files changed, 60 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 963e855..81b5f29 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -100,7 +100,6 @@
 #define MAX_SRBS		MAX_CMDS_TO_RISC
 #define MBOX_AEN_REG_COUNT	5
 #define MAX_INIT_RETRIES	5
-#define IOCB_HIWAT_CUSHION	16
 
 /*
  * Buffer sizes
@@ -307,7 +306,6 @@ struct scsi_qla_host {
 	uint32_t tot_ddbs;
 
 	uint16_t	iocb_cnt;
-	uint16_t	iocb_hiwat;
 
 	/* SRB cache. */
 #define SRB_MIN_REQ	128
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index 912a674..872d7af 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -10,9 +10,42 @@
 #include "ql4_dbg.h"
 #include "ql4_inline.h"
 
-
 #include <scsi/scsi_tcq.h>
 
+static int
+qla4xxx_space_in_req_ring(struct scsi_qla_host *ha, uint16_t req_cnt)
+{
+	uint16_t cnt;
+
+	/* Calculate number of free request entries. */
+	if ((req_cnt + 2) >= ha->req_q_count) {
+		cnt = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
+		if (ha->request_in < cnt)
+			ha->req_q_count = cnt - ha->request_in;
+		else
+			ha->req_q_count = REQUEST_QUEUE_DEPTH -
+						(ha->request_in - cnt);
+	}
+
+	/* Check if room for request in request ring. */
+	if ((req_cnt + 2) < ha->req_q_count)
+		return 1;
+	else
+		return 0;
+}
+
+static void qla4xxx_advance_req_ring_ptr(struct scsi_qla_host *ha)
+{
+	/* Advance request queue pointer */
+	if (ha->request_in == (REQUEST_QUEUE_DEPTH - 1)) {
+		ha->request_in = 0;
+		ha->request_ptr = ha->request_ring;
+	} else {
+		ha->request_in++;
+		ha->request_ptr++;
+	}
+}
+
 /**
  * qla4xxx_get_req_pkt - returns a valid entry in request queue.
  * @ha: Pointer to host adapter structure.
@@ -26,35 +59,18 @@
 static int qla4xxx_get_req_pkt(struct scsi_qla_host *ha,
 			       struct queue_entry **queue_entry)
 {
-	uint16_t request_in;
-	uint8_t status = QLA_SUCCESS;
-
-	*queue_entry = ha->request_ptr;
+	uint16_t req_cnt = 1;
 
-	/* get the latest request_in and request_out index */
-	request_in = ha->request_in;
-	ha->request_out = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
-
-	/* Advance request queue pointer and check for queue full */
-	if (request_in == (REQUEST_QUEUE_DEPTH - 1)) {
-		request_in = 0;
-		ha->request_ptr = ha->request_ring;
-	} else {
-		request_in++;
-		ha->request_ptr++;
-	}
-
-	/* request queue is full, try again later */
-	if ((ha->iocb_cnt + 1) >= ha->iocb_hiwat) {
-		/* restore request pointer */
-		ha->request_ptr = *queue_entry;
-		status = QLA_ERROR;
-	} else {
-		ha->request_in = request_in;
+	if (qla4xxx_space_in_req_ring(ha, req_cnt)) {
+		*queue_entry = ha->request_ptr;
 		memset(*queue_entry, 0, sizeof(**queue_entry));
+
+		qla4xxx_advance_req_ring_ptr(ha);
+		ha->req_q_count -= req_cnt;
+		return QLA_SUCCESS;
 	}
 
-	return status;
+	return QLA_ERROR;
 }
 
 /**
@@ -100,21 +116,14 @@ exit_send_marker:
 	return status;
 }
 
-static struct continuation_t1_entry* qla4xxx_alloc_cont_entry(
-	struct scsi_qla_host *ha)
+static struct continuation_t1_entry *
+qla4xxx_alloc_cont_entry(struct scsi_qla_host *ha)
 {
 	struct continuation_t1_entry *cont_entry;
 
 	cont_entry = (struct continuation_t1_entry *)ha->request_ptr;
 
-	/* Advance request queue pointer */
-	if (ha->request_in == (REQUEST_QUEUE_DEPTH - 1)) {
-		ha->request_in = 0;
-		ha->request_ptr = ha->request_ring;
-	} else {
-		ha->request_in++;
-		ha->request_ptr++;
-	}
+	qla4xxx_advance_req_ring_ptr(ha);
 
 	/* Load packet defaults */
 	cont_entry->hdr.entryType = ET_CONTINUE;
@@ -197,13 +206,10 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	struct scsi_cmnd *cmd = srb->cmd;
 	struct ddb_entry *ddb_entry;
 	struct command_t3_entry *cmd_entry;
-
 	int nseg;
 	uint16_t tot_dsds;
 	uint16_t req_cnt;
-
 	unsigned long flags;
-	uint16_t cnt;
 	uint32_t index;
 	char tag[2];
 
@@ -217,6 +223,19 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 
 	index = (uint32_t)cmd->request->tag;
 
+	/*
+	 * Check to see if adapter is online before placing request on
+	 * request queue.  If a reset occurs and a request is in the queue,
+	 * the firmware will still attempt to process the request, retrieving
+	 * garbage for pointers.
+	 */
+	if (!test_bit(AF_ONLINE, &ha->flags)) {
+		DEBUG2(printk("scsi%ld: %s: Adapter OFFLINE! "
+			      "Do not issue command.\n",
+			      ha->host_no, __func__));
+		goto queuing_error;
+	}
+
 	/* Calculate the number of request entries needed. */
 	nseg = scsi_dma_map(cmd);
 	if (nseg < 0)
@@ -224,17 +243,7 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 	tot_dsds = nseg;
 
 	req_cnt = qla4xxx_calc_request_entries(tot_dsds);
-
-	if (ha->req_q_count < (req_cnt + 2)) {
-		cnt = (uint16_t) le32_to_cpu(ha->shadow_regs->req_q_out);
-		if (ha->request_in < cnt)
-			ha->req_q_count = cnt - ha->request_in;
-		else
-			ha->req_q_count = REQUEST_QUEUE_DEPTH -
-				(ha->request_in - cnt);
-	}
-
-	if (ha->req_q_count < (req_cnt + 2))
+	if (!qla4xxx_space_in_req_ring(ha, req_cnt))
 		goto queuing_error;
 
 	/* total iocbs active */
@@ -286,32 +295,10 @@ int qla4xxx_send_command_to_isp(struct scsi_qla_host *ha, struct srb * srb)
 			break;
 		}
 
-
-	/* Advance request queue pointer */
-	ha->request_in++;
-	if (ha->request_in == REQUEST_QUEUE_DEPTH) {
-		ha->request_in = 0;
-		ha->request_ptr = ha->request_ring;
-	} else
-		ha->request_ptr++;
-
-
+	qla4xxx_advance_req_ring_ptr(ha);
 	qla4xxx_build_scsi_iocbs(srb, cmd_entry, tot_dsds);
 	wmb();
 
-	/*
-	 * Check to see if adapter is online before placing request on
-	 * request queue.  If a reset occurs and a request is in the queue,
-	 * the firmware will still attempt to process the request, retrieving
-	 * garbage for pointers.
-	 */
-	if (!test_bit(AF_ONLINE, &ha->flags)) {
-		DEBUG2(printk("scsi%ld: %s: Adapter OFFLINE! "
-			      "Do not issue command.\n",
-			      ha->host_no, __func__));
-		goto queuing_error;
-	}
-
 	srb->cmd->host_scribble = (unsigned char *)srb;
 
 	/* update counters */
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 051b0f5..09d6d4b 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -385,16 +385,6 @@ int qla4xxx_get_firmware_status(struct scsi_qla_host * ha)
 			      mbox_sts[0]));
 		return QLA_ERROR;
 	}
-
-	/* High-water mark of IOCBs */
-	ha->iocb_hiwat = mbox_sts[2];
-	if (ha->iocb_hiwat > IOCB_HIWAT_CUSHION)
-		ha->iocb_hiwat -= IOCB_HIWAT_CUSHION;
-	else
-		dev_info(&ha->pdev->dev, "WARNING!!!  You have less than %d "
-			   "firmware IOCBs available (%d).\n",
-			   IOCB_HIWAT_CUSHION, ha->iocb_hiwat);
-
 	return QLA_SUCCESS;
 }
 
-- 
1.6.0.6

