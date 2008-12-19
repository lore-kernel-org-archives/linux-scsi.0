From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 8/14]: Make ErrorRecoveryLevel=1 code use
	iscsi_tpg_get_node_attrib()
Date: Fri, 19 Dec 2008 15:34:36 -0800
Message-ID: <1229729676.4560.116.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:24013 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755817AbYLSXfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:35:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 1aecef1154d178049c63ff2b63f69591a90b35ac Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:22:26 -0800
Subject: [PATCH] [LIO-Target]: Make ErrorRecoveryLevel=1 code use iscsi_tpg_get_node_attrib()

This patch gets rid of iscsi_node_acl_t usage in ERL=1 code and locates
iscsi_node_attrib_t for DATAOUT timer settings via iscsi_tpg_get_node_attrib().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_erl1.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_erl1.c b/drivers/lio-core/iscsi_target_erl1.c
index 718b9e7..c95ece0 100644
--- a/drivers/lio-core/iscsi_target_erl1.c
+++ b/drivers/lio-core/iscsi_target_erl1.c
@@ -46,11 +46,13 @@
 #include <iscsi_crc.h>
 #include <iscsi_debug.h>
 #include <iscsi_lists.h>
-#include <iscsi_target_core.h>
+
 #include <target_core_base.h>
+#include <target_core_transport.h>
+#include <iscsi_target_core.h>
 #include <iscsi_target_datain_values.h>
 #include <iscsi_target_device.h>
-#include <target_core_transport.h>
+#include <iscsi_target_tpg.h>
 #include <iscsi_target_util.h>
 #include <iscsi_target_erl0.h>
 #include <iscsi_target_erl1.h>
@@ -1277,7 +1279,7 @@ static void iscsi_handle_dataout_timeout (
 	iscsi_cmd_t *cmd = (iscsi_cmd_t *) data;
 	iscsi_conn_t *conn = conn = CONN(cmd);
 	iscsi_session_t *sess = NULL;
-	iscsi_node_acl_t *acl = NULL;
+	iscsi_node_attrib_t *na;
 
 	iscsi_inc_conn_usage_count(conn);
 		
@@ -1289,7 +1291,7 @@ static void iscsi_handle_dataout_timeout (
 	}
 	cmd->dataout_timer_flags &= ~DATAOUT_TF_RUNNING;
 	sess = SESS(conn);
-	acl = sess->node_acl;
+	na = iscsi_tpg_get_node_attrib(sess);
 	
 	if (!SESS_OPS(sess)->ErrorRecoveryLevel) {
 		TRACE(TRACE_ERL0, "Unable to recover from DataOut timeout while"
@@ -1297,12 +1299,10 @@ static void iscsi_handle_dataout_timeout (
 		goto failure;
 	}
 	
-	if (++cmd->dataout_timeout_retries ==
-	    ISCSI_NODE_ATTRIB(acl)->dataout_timeout_retries) {
+	if (++cmd->dataout_timeout_retries == na->dataout_timeout_retries) {
 		TRACE(TRACE_TIMER, "Command ITT: 0x%08x exceeded max retries for"
 		" DataOUT timeout %u, closing iSCSI connection.\n",
-			cmd->init_task_tag,
-			ISCSI_NODE_ATTRIB(acl)->dataout_timeout_retries);
+			cmd->init_task_tag, na->dataout_timeout_retries);
 		goto failure;
 	}
 
@@ -1363,7 +1363,7 @@ extern void iscsi_mod_dataout_timer (iscsi_cmd_t *cmd)
 {               
 	iscsi_conn_t *conn = CONN(cmd);
 	iscsi_session_t *sess = SESS(conn);
-	iscsi_node_acl_t *acl = sess->node_acl;
+	iscsi_node_attrib_t *na = na = iscsi_tpg_get_node_attrib(sess);	
 	
 	spin_lock_bh(&cmd->dataout_timeout_lock);
 	if (!(cmd->dataout_timer_flags & DATAOUT_TF_RUNNING)) {
@@ -1371,7 +1371,7 @@ extern void iscsi_mod_dataout_timer (iscsi_cmd_t *cmd)
 		return;
 	}
 		                        
-	MOD_TIMER(&cmd->dataout_timer, ISCSI_NODE_ATTRIB(acl)->dataout_timeout);
+	MOD_TIMER(&cmd->dataout_timer, na->dataout_timeout);
 	TRACE(TRACE_TIMER, "Updated DataOUT timer for ITT: 0x%08x",
 			cmd->init_task_tag);
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
@@ -1388,7 +1388,7 @@ extern void iscsi_start_dataout_timer (
 	iscsi_conn_t *conn)
 {
 	iscsi_session_t *sess = SESS(conn);
-	iscsi_node_acl_t *acl = sess->node_acl;
+	iscsi_node_attrib_t *na = na = iscsi_tpg_get_node_attrib(sess); 
 	
 	if (cmd->dataout_timer_flags & DATAOUT_TF_RUNNING)
 		return;
@@ -1397,8 +1397,8 @@ extern void iscsi_start_dataout_timer (
 		" CID: %hu.\n", cmd->init_task_tag, conn->cid);
 
 	init_timer(&cmd->dataout_timer);
-	SETUP_TIMER(cmd->dataout_timer, ISCSI_NODE_ATTRIB(acl)->dataout_timeout,
-		cmd, iscsi_handle_dataout_timeout);
+	SETUP_TIMER(cmd->dataout_timer, na->dataout_timeout, cmd,
+			iscsi_handle_dataout_timeout);
 	cmd->dataout_timer_flags &= ~DATAOUT_TF_STOP;
 	cmd->dataout_timer_flags |= DATAOUT_TF_RUNNING;
 	add_timer(&cmd->dataout_timer);
-- 
1.5.4.1



