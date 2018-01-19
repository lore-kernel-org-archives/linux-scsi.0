From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH] qedi: Drop cqe response during connection recovery
Date: Thu, 18 Jan 2018 22:52:09 -0800
Message-ID: <20180119065209.30927-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0064.outbound.protection.outlook.com ([104.47.41.64]:2320
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750722AbeASGwO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 01:52:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

We get stuck in the loop when firmware sends a cqe response
during connection recovery.

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index cccc34a..8808f0d 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -998,7 +998,9 @@ static bool qedi_process_completions(struct qedi_fastpath *fp)
 
 		ret = qedi_queue_cqe(qedi, cqe, fp->sb_id, p);
 		if (ret)
-			continue;
+			QEDI_WARN(&qedi->dbg_ctx,
+				  "Dropping CQE 0x%x for cid=0x%x.\n",
+				  que->cq_cons_idx, cqe->cqe_common.conn_id);
 
 		que->cq_cons_idx++;
 		if (que->cq_cons_idx == QEDI_CQ_SIZE)
-- 
1.8.3.1
