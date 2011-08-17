From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 17/21] iscsi-target: Fix iscsit_allocate_se_cmd_for_tmr failure path bugs
Date: Wed, 17 Aug 2011 23:17:21 +0000
Message-ID: <1313623045-15916-18-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58348 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab1HQXmn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:43 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Dan Carpenter <error27@gmail.com>

From: Dan Carpenter <error27@gmail.com>

This patch fixes two bugs in allocation failure handling in
iscsit_allocate_se_cmd_for_tmr():

This first reported by DanC is a free-after call to transport_free_se_cmd(), this
patch drops the transport_free_se_cmd() call all together, as iscsit_release_cmd()
will release existing allocations as expected.

The second is a bug where iscsi_cmd_t was being leaked on a cmd->tmr_req allocation
failure, so make this jump to iscsit_release_cmd() as well.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_util.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index a1acb01..a0d23bc 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -243,7 +243,7 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 	if (!cmd->tmr_req) {
 		pr_err("Unable to allocate memory for"
 			" Task Management command!\n");
-		return NULL;
+		goto out;
 	}
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
@@ -298,8 +298,6 @@ struct iscsi_cmd *iscsit_allocate_se_cmd_for_tmr(
 	return cmd;
 out:
 	iscsit_release_cmd(cmd);
-	if (se_cmd)
-		transport_free_se_cmd(se_cmd);
 	return NULL;
 }
 
-- 
1.7.6

