From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/5] [LIO-Target]: Update core_tmr_alloc_req() usage
Date: Tue, 24 Mar 2009 22:54:35 -0700
Message-ID: <1237960475.4138.402.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:22009 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753578AbZCYF7I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 01:59:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>From a13a460d284e32dc62b55e00a20acc154b793e14 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 23 Mar 2009 22:42:05 -0700
Subject: [PATCH 5/5] [LIO-Target]: Update core_tmr_alloc_req() usage

This patch updates parameter usage of core_tmr_alloc_req() from target_core_mod
in iscsi_target_mod code.  It also removes an non-fatal error message from
iscsi_handle_task_mgt_cmd() related to non ABORT_TASK iSCSI TMRs.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c      |    4 +---
 drivers/lio-core/iscsi_target_util.c |    3 ++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index 25a107a..33d1363 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -2343,10 +2343,8 @@ static inline int iscsi_handle_task_mgt_cmd (
 				"implementation\n");
 		return(iscsi_add_reject(REASON_PROTOCOL_ERR, 1, buf, conn));
 	}
-	if ((hdr->function != ABORT_TASK) && (hdr->ref_cmd_sn != RESERVED)) {
-		TRACE_ERROR("RefCmdSN should be set to 0xFFFFFFFF.\n"); 
+	if ((hdr->function != ABORT_TASK) && (hdr->ref_cmd_sn != RESERVED))
 		hdr->ref_cmd_sn = RESERVED;
-	}
 
 	if (!(cmd = iscsi_allocate_se_cmd_for_tmr(conn, hdr->function))) 
 		return(iscsi_add_reject(REASON_OUT_OF_RESOURCES, 1, buf, conn));
diff --git a/drivers/lio-core/iscsi_target_util.c b/drivers/lio-core/iscsi_target_util.c
index bf74c32..7aa3c7e 100644
--- a/drivers/lio-core/iscsi_target_util.c
+++ b/drivers/lio-core/iscsi_target_util.c
@@ -396,7 +396,8 @@ extern iscsi_cmd_t *iscsi_allocate_se_cmd_for_tmr (
 
 	se_cmd = cmd->se_cmd;
 
-	if (!(se_cmd->se_tmr_req = core_tmr_alloc_req((void *)cmd->tmr_req, function))) 
+	if (!(se_cmd->se_tmr_req = core_tmr_alloc_req(se_cmd,
+			(void *)cmd->tmr_req, function))) 
 		goto out;
 
 	cmd->tmr_req->se_tmr_req = se_cmd->se_tmr_req;
-- 
1.5.4.1



