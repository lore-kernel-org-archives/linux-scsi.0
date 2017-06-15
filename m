From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 2/2] qedi: Remove WARN_ON from clear task context.
Date: Thu, 15 Jun 2017 00:10:40 -0700
Message-ID: <20170615071040.18093-3-manish.rangankar@cavium.com>
References: <20170615071040.18093-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0055.outbound.protection.outlook.com ([104.47.41.55]:55164
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751761AbdFOHKx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Jun 2017 03:10:53 -0400
In-Reply-To: <20170615071040.18093-1-manish.rangankar@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 09a2946..879d3b7 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -1499,11 +1499,9 @@ int qedi_get_task_idx(struct qedi_ctx *qedi)
 
 void qedi_clear_task_idx(struct qedi_ctx *qedi, int idx)
 {
-	if (!test_and_clear_bit(idx, qedi->task_idx_map)) {
+	if (!test_and_clear_bit(idx, qedi->task_idx_map))
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "FW task context, already cleared, tid=0x%x\n", idx);
-		WARN_ON(1);
-	}
 }
 
 void qedi_update_itt_map(struct qedi_ctx *qedi, u32 tid, u32 proto_itt,
-- 
1.8.3.1
