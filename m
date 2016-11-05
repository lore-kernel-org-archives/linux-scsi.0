From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH 4.9/scsi-fixes] libcxgbi: fix incorrect DDP resource cleanup
Date: Sat,  5 Nov 2016 21:49:28 +0530
Message-ID: <1478362768-19895-1-git-send-email-varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:25314 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755914AbcKEQT7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Nov 2016 12:19:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, indranil@chelsio.com, varun@chelsio.com

Before calling task_release_itt() task data is memset
to zero because of which DDP context information is lost
resulting in incorrect DDP resource cleanup, to fix
this call task_release_itt() before memset.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/scsi/cxgbi/libcxgbi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index d142113..2ffe029 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2081,9 +2081,10 @@ void cxgbi_cleanup_task(struct iscsi_task *task)
 	/*  never reached the xmit task callout */
 	if (tdata->skb)
 		__kfree_skb(tdata->skb);
-	memset(tdata, 0, sizeof(*tdata));
 
 	task_release_itt(task, task->hdr_itt);
+	memset(tdata, 0, sizeof(*tdata));
+
 	iscsi_tcp_cleanup_task(task);
 }
 EXPORT_SYMBOL_GPL(cxgbi_cleanup_task);
-- 
2.0.2

