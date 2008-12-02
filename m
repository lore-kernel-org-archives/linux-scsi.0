From: michaelc@cs.wisc.edu
Subject: [PATCH 10/13] libiscsi: allow drivers to modify the itt sent to the target
Date: Tue,  2 Dec 2008 00:32:13 -0600
Message-ID: <1228199536-12595-11-git-send-email-michaelc@cs.wisc.edu>
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
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbYLBGc1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:27 -0500
In-Reply-To: <1228199536-12595-10-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

bnx2i and cxgb3i need to encode LLD info in the itt so that
the firmware/hardware can process the pdu. This patch allows
the LLDs to encode info in the task->hdr->itt that they
setup in the alloc_pdu callout (any resources that are allocated
can be freed with the pdu in the cleanup_task callout). If
the LLD encodes info in the itt they should implement a
parse_pdu_itt callout. If parse_pdu_itt is not implemented
libiscsi will do the right thing for the LLD.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |   47 +++++++++++++++++++++++++---------
 include/scsi/libiscsi.h             |    5 ++-
 include/scsi/scsi_transport_iscsi.h |    3 ++
 3 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 0a99ca0..2fdc94f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -222,12 +222,14 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	struct scsi_cmnd *sc = task->sc;
 	struct iscsi_cmd *hdr;
 	unsigned hdrlength, cmd_len;
+	itt_t itt;
 	int rc;
 
 	rc = conn->session->tt->alloc_pdu(task);
 	if (rc)
 		return rc;
 	hdr = (struct iscsi_cmd *) task->hdr;
+	itt = hdr->itt;
 	memset(hdr, 0, sizeof(*hdr));
 
 	task->hdr_len = 0;
@@ -238,7 +240,11 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
 	hdr->flags = ISCSI_ATTR_SIMPLE;
 	int_to_scsilun(sc->device->lun, (struct scsi_lun *)hdr->lun);
 	memcpy(task->lun, hdr->lun, sizeof(task->lun));
-	hdr->itt = task->hdr_itt = build_itt(task->itt, session->age);
+	if (session->tt->parse_pdu_itt)
+		hdr->itt = task->hdr_itt = itt;
+	else
+		hdr->itt = task->hdr_itt = build_itt(task->itt,
+						     task->conn->session->age);
 	hdr->cmdsn = task->cmdsn = cpu_to_be32(session->cmdsn);
 	session->cmdsn++;
 	hdr->exp_statsn = cpu_to_be32(conn->exp_statsn);
@@ -457,7 +463,6 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
 	 */
 	nop->cmdsn = cpu_to_be32(session->cmdsn);
 	if (hdr->itt != RESERVED_ITT) {
-		hdr->itt = build_itt(task->itt, session->age);
 		/*
 		 * TODO: We always use immediate, so we never hit this.
 		 * If we start to send tmfs or nops as non-immediate then
@@ -490,6 +495,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 {
 	struct iscsi_session *session = conn->session;
 	struct iscsi_task *task;
+	itt_t itt;
 
 	if (session->state == ISCSI_STATE_TERMINATE)
 		return NULL;
@@ -537,9 +543,18 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 				 "pdu for mgmt task.\n");
 		goto requeue_task;
 	}
+	itt = task->hdr->itt;
 	task->hdr_len = sizeof(struct iscsi_hdr);
-
 	memcpy(task->hdr, hdr, sizeof(struct iscsi_hdr));
+
+	if (hdr->itt != RESERVED_ITT) {
+		if (session->tt->parse_pdu_itt)
+			task->hdr->itt = itt;
+		else
+			task->hdr->itt = build_itt(task->itt,
+						   task->conn->session->age);
+	}
+
 	INIT_LIST_HEAD(&task->running);
 	list_add_tail(&task->running, &conn->mgmtqueue);
 
@@ -746,7 +761,6 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 {
 	struct iscsi_reject *reject = (struct iscsi_reject *)hdr;
 	struct iscsi_hdr rejected_pdu;
-	uint32_t itt;
 
 	conn->exp_statsn = be32_to_cpu(reject->statsn) + 1;
 
@@ -756,10 +770,9 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 
 		if (ntoh24(reject->dlength) >= sizeof(struct iscsi_hdr)) {
 			memcpy(&rejected_pdu, data, sizeof(struct iscsi_hdr));
-			itt = get_itt(rejected_pdu.itt);
 			iscsi_conn_printk(KERN_ERR, conn,
-					  "itt 0x%x had pdu (op 0x%x) rejected "
-					  "due to DataDigest error.\n", itt,
+					  "pdu (op 0x%x) rejected "
+					  "due to DataDigest error.\n",
 					  rejected_pdu.opcode);
 		}
 	}
@@ -779,12 +792,15 @@ static int iscsi_handle_reject(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 static struct iscsi_task *iscsi_itt_to_task(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
-	uint32_t i;
+	int i;
 
 	if (itt == RESERVED_ITT)
 		return NULL;
 
-	i = get_itt(itt);
+	if (session->tt->parse_pdu_itt)
+		session->tt->parse_pdu_itt(conn, itt, &i, NULL);
+	else
+		i = get_itt(itt);
 	if (i >= session->cmds_max)
 		return NULL;
 
@@ -959,20 +975,25 @@ EXPORT_SYMBOL_GPL(iscsi_complete_pdu);
 int iscsi_verify_itt(struct iscsi_conn *conn, itt_t itt)
 {
 	struct iscsi_session *session = conn->session;
-	uint32_t i;
+	int age = 0, i = 0;
 
 	if (itt == RESERVED_ITT)
 		return 0;
 
-	if (((__force u32)itt & ISCSI_AGE_MASK) !=
-	    (session->age << ISCSI_AGE_SHIFT)) {
+	if (session->tt->parse_pdu_itt)
+		session->tt->parse_pdu_itt(conn, itt, &i, &age);
+	else {
+		i = get_itt(itt);
+		age = ((__force u32)itt >> ISCSI_AGE_SHIFT) & ISCSI_AGE_MASK;
+	}
+
+	if (age != session->age) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "received itt %x expected session age (%x)\n",
 				  (__force u32)itt, session->age);
 		return ISCSI_ERR_BAD_ITT;
 	}
 
-	i = get_itt(itt);
 	if (i >= session->cmds_max) {
 		iscsi_conn_printk(KERN_ERR, conn,
 				  "received invalid itt index %u (max cmds "
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 5150057..7360e19 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -30,6 +30,7 @@
 #include <linux/workqueue.h>
 #include <scsi/iscsi_proto.h>
 #include <scsi/iscsi_if.h>
+#include <scsi/scsi_transport_iscsi.h>
 
 struct scsi_transport_template;
 struct scsi_host_template;
@@ -70,12 +71,12 @@ enum {
 /* Connection suspend "bit" */
 #define ISCSI_SUSPEND_BIT		1
 
-#define ISCSI_ITT_MASK			(0x1fff)
+#define ISCSI_ITT_MASK			0x1fff
 #define ISCSI_TOTAL_CMDS_MAX		4096
 /* this must be a power of two greater than ISCSI_MGMT_CMDS_MAX */
 #define ISCSI_TOTAL_CMDS_MIN		16
 #define ISCSI_AGE_SHIFT			28
-#define ISCSI_AGE_MASK			(0xf << ISCSI_AGE_SHIFT)
+#define ISCSI_AGE_MASK			0xf
 
 #define ISCSI_ADDRESS_BUF_LEN		64
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index c928234..e13cb20 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -122,6 +122,9 @@ struct iscsi_transport {
 	int (*xmit_pdu) (struct iscsi_task *task);
 	int (*init_pdu) (struct iscsi_task *task, unsigned int offset,
 			 unsigned int count);
+	void (*parse_pdu_itt) (struct iscsi_conn *conn, itt_t itt,
+			       int *index, int *age);
+
 	void (*session_recovery_timedout) (struct iscsi_cls_session *session);
 	struct iscsi_endpoint *(*ep_connect) (struct sockaddr *dst_addr,
 					      int non_blocking);
-- 
1.5.6.5

