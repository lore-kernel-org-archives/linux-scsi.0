From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 11/14]: Update iscsi_target_nego.c for
	se_node_acl_t
Date: Fri, 19 Dec 2008 15:36:22 -0800
Message-ID: <1229729782.4560.122.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:22892 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751164AbYLSXgv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:36:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From fbcdadaa1c60d76c39668cfebf8a771e6055f46c Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:31:59 -0800
Subject: [PATCH] [LIO-Target]: Update iscsi_target_nego.c for se_node_acl_t

In iscsi_target_check_first_request() and iscsi_target_locate_portal(),
update logic to use se_node_acl_t instead of iscsi_node_acl_t.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_nego.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_nego.c b/drivers/lio-core/iscsi_target_nego.c
index 554067f..a16cbbd 100644
--- a/drivers/lio-core/iscsi_target_nego.c
+++ b/drivers/lio-core/iscsi_target_nego.c
@@ -42,8 +42,10 @@
 #include <iscsi_debug.h>
 #include <iscsi_protocol.h>
 #include <iscsi_debug_opcodes.h>
-#include <iscsi_target_core.h>
 #include <target_core_base.h>
+#include <target_core_tpg.h>
+
+#include <iscsi_target_core.h>
 #include <iscsi_target_device.h>
 #include <iscsi_target_login.h>
 #include <iscsi_target_nego.h>
@@ -162,8 +164,8 @@ static int iscsi_target_check_first_request(
 	iscsi_conn_t *conn,
 	iscsi_login_t *login)
 {
-	iscsi_node_acl_t *acl;
 	iscsi_param_t *param = NULL;
+	se_node_acl_t *se_nacl;
 
 	TRACE_ENTER
 
@@ -200,14 +202,14 @@ static int iscsi_target_check_first_request(
 			 * iscsi_node_acl_t.
 			 */
 			if (!login->leading_connection) {
-				if (!(acl = SESS(conn)->node_acl)) {
-					TRACE_ERROR("Unable to locate iscsi_node_acl_t\n");
+				if (!(se_nacl = SESS(conn)->se_sess->se_node_acl)) {
+					TRACE_ERROR("Unable to locate se_node_acl_t\n");
 					iscsi_tx_login_rsp(conn, STAT_CLASS_INITIATOR,
 							STAT_DETAIL_NOT_FOUND);
 					return(-1);
 				}
 
-				if (strcmp(param->value, acl->initiatorname)) {
+				if (strcmp(param->value, se_nacl->initiatorname)) {
 					TRACE_ERROR("Incorrect InitiatorName: %s for"
 						" this iSCSI Initiator Node.\n",
 						param->value);
@@ -682,11 +684,10 @@ static int iscsi_target_locate_portal (
 	if (iscsi_target_get_initial_payload(conn, login) < 0)
 		return(-1);
 
-	if (!(tmpbuf = (char *) kmalloc(login_req->length + 1, GFP_KERNEL))) {
+	if (!(tmpbuf = (char *) kzalloc(login_req->length + 1, GFP_KERNEL))) {
 		TRACE_ERROR("Unable to allocate memory for tmpbuf.\n");
 		return(-1);
 	}
-	memset(tmpbuf, 0, login_req->length + 1);
 
 	memcpy(tmpbuf, login->req_buf, login_req->length);
 	tmpbuf[login_req->length] = '\0';
@@ -828,8 +829,8 @@ get_target:
 	/*
 	 * Locate incoming Initiator IQN reference from Storage Node.
 	 */
-	if (!(sess->node_acl = iscsi_tpg_check_initiator_node_acl(
-			conn->tpg, i_buf))) {
+	if (!(sess->se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
+			conn->tpg->tpg_se_tpg, i_buf))) {
 		TRACE_ERROR("iSCSI Initiator Node: %s is not authorized to"
 			" access iSCSI target portal group: %hu.\n",
 				i_buf, conn->tpg->tpgt);
-- 
1.5.4.1



