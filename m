From: michaelc@cs.wisc.edu
Subject: [PATCH 11/13] libiscsi: pass opcode into alloc_pdu callout
Date: Tue,  2 Dec 2008 00:32:14 -0600
Message-ID: <1228199536-12595-12-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-6-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-7-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-8-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-9-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-10-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-11-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52477 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbYLBGc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:28 -0500
In-Reply-To: <1228199536-12595-11-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We do not need to allocate a itt for data_out, so this
passes the opcode to the alloc_pdu callout.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    2 +-
 drivers/scsi/iscsi_tcp.c                 |    2 +-
 drivers/scsi/libiscsi.c                  |   14 +++++++-------
 drivers/scsi/libiscsi_tcp.c              |    2 +-
 include/scsi/scsi_transport_iscsi.h      |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 78bf5e4..1287639 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -119,7 +119,7 @@ error:
 	iscsi_conn_failure(conn, rc);
 }
 
-static int iscsi_iser_pdu_alloc(struct iscsi_task *task)
+static int iscsi_iser_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 728046e..c65175e 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -457,7 +457,7 @@ static int iscsi_sw_tcp_pdu_init(struct iscsi_task *task,
 	return 0;
 }
 
-static int iscsi_sw_tcp_pdu_alloc(struct iscsi_task *task)
+static int iscsi_sw_tcp_pdu_alloc(struct iscsi_task *task, uint8_t opcode)
 {
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2fdc94f..8ba55c1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -225,13 +225,18 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	itt_t itt;
 	int rc;
 
-	rc = conn->session->tt->alloc_pdu(task);
+	rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_CMD);
 	if (rc)
 		return rc;
 	hdr = (struct iscsi_cmd *) task->hdr;
 	itt = hdr->itt;
 	memset(hdr, 0, sizeof(*hdr));
 
+	if (session->tt->parse_pdu_itt)
+		hdr->itt = task->hdr_itt = itt;
+	else
+		hdr->itt = task->hdr_itt = build_itt(task->itt,
+						     task->conn->session->age);
 	task->hdr_len = 0;
 	rc = iscsi_add_hdr(task, sizeof(*hdr));
 	if (rc)
@@ -240,11 +245,6 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
 	memcpy(task->lun, hdr->lun, sizeof(task->lun));
-	if (session->tt->parse_pdu_itt)
-		hdr->itt = task->hdr_itt = itt;
-	else
-		hdr->itt = task->hdr_itt = build_itt(task->itt,
-						     task->conn->session->age);
 	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
@@ -538,7 +538,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	} else
 		task->data_count = 0;
 
-	if (conn->session->tt->alloc_pdu(task)) {
+	if (conn->session->tt->alloc_pdu(task, hdr->opcode)) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate "
 				 "pdu for mgmt task.\n");
 		goto requeue_task;
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index e865089..9df6b34 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1021,7 +1021,7 @@ flush:
 		return 0;
 	}
 
-	rc = conn->session->tt->alloc_pdu(task);
+	rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_DATA_OUT);
 	if (rc)
 		return rc;
 	iscsi_prep_data_out_pdu(task, r2t, (struct iscsi_data *) task->hdr);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index e13cb20..b50aabe 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -118,7 +118,7 @@ struct iscsi_transport {
 	int (*xmit_task) (struct iscsi_task *task);
 	void (*cleanup_task) (struct iscsi_task *task);
 
-	int (*alloc_pdu) (struct iscsi_task *task);
+	int (*alloc_pdu) (struct iscsi_task *task, uint8_t opcode);
 	int (*xmit_pdu) (struct iscsi_task *task);
 	int (*init_pdu) (struct iscsi_task *task, unsigned int offset,
 			 unsigned int count);
-- 
1.5.6.5

