From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/5] [LIO-Target]: Move iscsi_free_all_datain_reqs() to
	generic location
Date: Fri, 09 Jan 2009 12:55:28 -0800
Message-ID: <1231534528.4560.1005.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:29631 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752929AbZAIUzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 15:55:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 46a298686ce73eafcfa68782b7a0dba7bb39061f Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 9 Jan 2009 10:53:35 -0800
Subject: [PATCH 5/5] [LIO-Target]: Move iscsi_free_all_datain_reqs() to generic location

This patch fixes a memory leak of iscsi_datain_req_t during a NON_EXISTENT_LUN
exception for an ISCSI_READ PDU, followed by an immediate explict logout.
iscsi_free_all_datain_reqs() was not being called in iscsi_release_commands_from_conn()
after the explict logout was initiated.

The solution was to move the call to iscsi_free_all_datain_reqs() to a generic location
in iscsi_release_cmd_direct() and __iscsi_release_cmd_to_pool().  This is where
iscsi_free_r2ts_from_list() was already being called for ISCSI_WRITE, so it makes sense
to put the call to release iscsi_datain_req_t for ISCSI_READ here as well.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c      |    1 -
 drivers/lio-core/iscsi_target_util.c |    3 +++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index bf7b478..228c9c3 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -4792,7 +4792,6 @@ static void iscsi_release_commands_from_conn (iscsi_conn_t *conn)
 		}
 		spin_unlock_bh(&conn->cmd_lock);
 
-		iscsi_free_all_datain_reqs(cmd);
 		iscsi_increment_maxcmdsn(cmd, sess);
 
 		if (SE_CMD(cmd)->transport_wait_for_tasks)
diff --git a/drivers/lio-core/iscsi_target_util.c b/drivers/lio-core/iscsi_target_util.c
index 9c83f33..ea66704 100644
--- a/drivers/lio-core/iscsi_target_util.c
+++ b/drivers/lio-core/iscsi_target_util.c
@@ -53,6 +53,7 @@
 #include <target_core_transport.h>
 
 #include <iscsi_target_core.h>
+#include <iscsi_target_datain_values.h>
 #include <iscsi_target_erl0.h>
 #include <iscsi_target_erl1.h>
 #include <iscsi_target_erl2.h>
@@ -1063,6 +1064,7 @@ extern void iscsi_free_queue_reqs_for_conn (iscsi_conn_t *conn)
 extern void iscsi_release_cmd_direct (iscsi_cmd_t *cmd)
 {
 	iscsi_free_r2ts_from_list(cmd);
+	iscsi_free_all_datain_reqs(cmd);
 
 	if (cmd->buf_ptr)
 		kfree(cmd->buf_ptr);
@@ -1089,6 +1091,7 @@ extern void __iscsi_release_cmd_to_pool (iscsi_cmd_t *cmd, iscsi_session_t *sess
 	iscsi_conn_t *conn = CONN(cmd);
 
 	iscsi_free_r2ts_from_list(cmd);
+	iscsi_free_all_datain_reqs(cmd);
 	
 	if (cmd->buf_ptr)
 		kfree(cmd->buf_ptr);
-- 
1.5.4.1



