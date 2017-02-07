From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/5] target: Use correct SCSI status during EXTENDED_COPY exception
Date: Tue,  7 Feb 2017 13:17:47 +0000
Message-ID: <1486473470-15837-3-git-send-email-nab@linux-iscsi.org>
References: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Nixon Vincent <nixon.vincent@calsoftinc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the missing target_complete_cmd() SCSI status
parameter change in target_xcopy_do_work(), that was originally
missing in commit 926317de33.

It correctly propigates up the correct SCSI status during
EXTENDED_COPY exception cases, instead of always using the
hardcoded SAM_STAT_CHECK_CONDITION from original code.

This is required for ESX host environments that expect to
hit SAM_STAT_RESERVATION_CONFLICT for certain scenarios,
and SAM_STAT_CHECK_CONDITION results in non-retriable
status for these cases.

Reported-by: Nixon Vincent <nixon.vincent@calsoftinc.com>
Tested-by: Nixon Vincent <nixon.vincent@calsoftinc.com>
Cc: Nixon Vincent <nixon.vincent@calsoftinc.com>
Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_xcopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index d828b3b..cac5a20 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -864,7 +864,7 @@ static void target_xcopy_do_work(struct work_struct *work)
 			" CHECK_CONDITION -> sending response\n", rc);
 		ec_cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 	}
-	target_complete_cmd(ec_cmd, SAM_STAT_CHECK_CONDITION);
+	target_complete_cmd(ec_cmd, ec_cmd->scsi_status);
 }
 
 sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
-- 
1.9.1
