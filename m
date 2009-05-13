From: michaelc@cs.wisc.edu
Subject: [PATCH 02/13] libiscsi: check of LLD has a alloc pdu callout.
Date: Wed, 13 May 2009 17:57:39 -0500
Message-ID: <12422554711865-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51803 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762085AbZEMW5x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:53 -0400
In-Reply-To: <12422554711659-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

bnx2i does not have one. It currently preallocates the bdt
when the session is setup.

We probably want to change that to a dma pool, then allocate from
the pool in the alloc pdu. Until then check if there is a alloc
pdu callout.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e72b4ad..11bc3e1 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -257,9 +257,11 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	itt_t itt;
 	int rc;
 
-	rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_CMD);
-	if (rc)
-		return rc;
+	if (conn->session->tt->alloc_pdu) {
+		rc = conn->session->tt->alloc_pdu(task, ISCSI_OP_SCSI_CMD);
+		if (rc)
+			return rc;
+	}
 	hdr = (struct iscsi_cmd *) task->hdr;
 	itt = hdr->itt;
 	memset(hdr, 0, sizeof(*hdr));
@@ -566,11 +568,14 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 	} else
 		task->data_count = 0;
 
-	if (conn->session->tt->alloc_pdu(task, hdr->opcode)) {
-		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate "
-				 "pdu for mgmt task.\n");
-		goto requeue_task;
+	if (conn->session->tt->alloc_pdu) {
+		if (conn->session->tt->alloc_pdu(task, hdr->opcode)) {
+			iscsi_conn_printk(KERN_ERR, conn, "Could not allocate "
+					 "pdu for mgmt task.\n");
+			goto requeue_task;
+		}
 	}
+
 	itt = task->hdr->itt;
 	task->hdr_len = sizeof(struct iscsi_hdr);
 	memcpy(task->hdr, hdr, sizeof(struct iscsi_hdr));
-- 
1.5.2.1

