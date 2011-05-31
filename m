From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] target: remove the unused SCF_SE_DISABLE_ONLINE_CHECK flag
Date: Tue, 31 May 2011 17:06:43 -0400
Message-ID: <20110531210702.863406136@bombadil.infradead.org>
References: <20110531210641.032149131@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42334
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932326Ab1EaVHD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2011 17:07:03 -0400
Content-Disposition: inline; filename=lio-kill-SCF_SE_DISABLE_ONLINE_CHECK
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2011-06-01 05:18:40.682628525 +0900
+++ lio-core/drivers/target/target_core_transport.c	2011-06-01 05:29:40.383627959 +0900
@@ -2436,14 +2436,12 @@ static int transport_execute_tasks(struc
 {
 	int add_tasks;
 
-	if (!(cmd->se_cmd_flags & SCF_SE_DISABLE_ONLINE_CHECK)) {
-		if (se_dev_check_online(cmd->se_orig_obj_ptr) != 0) {
-			cmd->transport_error_status =
-				PYX_TRANSPORT_LU_COMM_FAILURE;
-			transport_generic_request_failure(cmd, NULL, 0, 1);
-			return 0;
-		}
+	if (se_dev_check_online(cmd->se_orig_obj_ptr) != 0) {
+		cmd->transport_error_status = PYX_TRANSPORT_LU_COMM_FAILURE;
+		transport_generic_request_failure(cmd, NULL, 0, 1);
+		return 0;
 	}
+
 	/*
 	 * Call transport_cmd_check_stop() to see if a fabric exception
 	 * has occurred that prevents execution.
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2011-06-01 05:08:51.154236383 +0900
+++ lio-core/include/target/target_core_base.h	2011-06-01 05:29:40.403630758 +0900
@@ -116,7 +116,6 @@ enum se_cmd_flags_table {
 	SCF_SE_CMD_FAILED		= 0x00000400,
 	SCF_SE_LUN_CMD			= 0x00000800,
 	SCF_SE_ALLOW_EOO		= 0x00001000,
-	SCF_SE_DISABLE_ONLINE_CHECK	= 0x00002000,
 	SCF_SENT_CHECK_CONDITION	= 0x00004000,
 	SCF_OVERFLOW_BIT		= 0x00008000,
 	SCF_UNDERFLOW_BIT		= 0x00010000,

