From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 1/3] target: Fix sense data for out-of-bounds IO operations
Date: Fri,  8 Feb 2013 15:18:38 -0800
Message-ID: <1360365520-11972-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:52398 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760370Ab3BHXSr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2013 18:18:47 -0500
Received: by mail-pa0-f70.google.com with SMTP id kp1so3353816pab.9
        for <linux-scsi@vger.kernel.org>; Fri, 08 Feb 2013 15:18:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

We're supposed to return LOGICAL BLOCK ADDRESS OUT OF RANGE, not
INVALID FIELD IN CDB.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_sbc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a664c66..170f1f7 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -486,7 +486,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 */
 		if (cmd->t_task_lba || sectors) {
 			if (sbc_check_valid_sectors(cmd) < 0)
-				return TCM_INVALID_CDB_FIELD;
+				return TCM_ADDRESS_OUT_OF_RANGE;
 		}
 		cmd->execute_cmd = ops->execute_sync_cache;
 		break;
-- 
1.8.1.2

