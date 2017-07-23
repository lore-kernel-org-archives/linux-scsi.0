From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH] scsi: libcxgbi: add check for valid cxgbi_task_data
Date: Sun, 23 Jul 2017 20:01:32 +0530
Message-ID: <1500820292-21893-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:59041 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751423AbdGWObm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jul 2017 10:31:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

In error case it is possible that ->cleanup_task()
gets called without calling ->alloc_pdu() in this case
cxgbi_task_data is not valid, so add a check for
for valid cxgbi_task_data in cxgbi_cleanup_task().

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index e4c83b7..1a4cfa5 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2128,6 +2128,13 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 	struct iscsi_tcp_task *tcp_task = task->dd_data;
 	struct cxgbi_task_data *tdata = iscsi_task_cxgbi_data(task);
 
+	if (!tcp_task || !tdata || (tcp_task->dd_data != tdata)) {
+		pr_info("task 0x%p,0x%p, tcp_task 0x%p, tdata 0x%p/0x%p.\n",
+			task, task->sc, tcp_task,
+			tcp_task ? tcp_task->dd_data : NULL, tdata);
+		return;
+	}
+
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"task 0x%p, skb 0x%p, itt 0x%x.\n",
 		task, tdata->skb, task->hdr_itt);
-- 
2.0.2
