From: Imran Haider <imran1008@gmail.com>
Subject: [PATCH] iscsi-target: graceful disconnect on invalid mapping to iovec
Date: Sun,  8 May 2016 11:17:54 -0400
Message-ID: <1462720674-2159-1-git-send-email-imran1008@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36785 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbcEHPUU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 May 2016 11:20:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Imran Haider <imran1008@gmail.com>

Ensures the first page entry is within bounds. A failed check would
terminate the iSCSI connection instead of causing a NULL-dereference.

This violation seems to happen with certain iSCSI commands where the
computed CDB length is zero but the expected transfer length is
non-zero. The real problem is probably on the iSCSI initiator side
since there is a discrepancy between the iSCSI header and the
encapsulated CDB Opcode.

Signed-off-by: Imran Haider <imran1008@gmail.com>
---
 drivers/target/iscsi/iscsi_target.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 961202f..963e9a7 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -737,7 +737,14 @@ static int iscsit_map_iovec(
 	/*
 	 * We know each entry in t_data_sg contains a page.
 	 */
-	sg = &cmd->se_cmd.t_data_sg[data_offset / PAGE_SIZE];
+	u32 ent = data_offset / PAGE_SIZE;
+
+	if (ent >= cmd->se_cmd.t_data_nents) {
+		pr_err("Initial page entry out-of-bounds\n");
+		return -1;
+	}
+
+	sg = &cmd->se_cmd.t_data_sg[ent];
 	page_off = (data_offset % PAGE_SIZE);
 
 	cmd->first_data_sg = sg;
-- 
2.8.0

