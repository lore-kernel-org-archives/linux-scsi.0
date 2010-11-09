From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] tcm/pscsi: Fix incorrect usage of head_of_queue with blk_execute_rq_nowait()
Date: Mon,  8 Nov 2010 21:41:18 -0800
Message-ID: <1289281278-20454-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.sbc.mail.gq1.yahoo.com ([67.195.14.95]:31567 "HELO
	smtp110.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751448Ab0KIFlV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 00:41:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a conditional check based on the received struct se_task->task_se_cmd->sam_task_attr
to determine if the HEAD_OF_QUEUE flag should be set when calling blk_execute_rq_nowait().
This fixes a bug where all struct request for TCM/pSCSI where being set with the HEAD_OF_QUEUE
tag.

Many thanks to Boaz Harrosh for catching this one!

Reported-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 6296a0f..a1b9bf6 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -41,6 +41,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
+#include <scsi/libsas.h> /* For TASK_ATTR_* */
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
@@ -802,9 +803,12 @@ static int pscsi_do_task(struct se_task *task)
 	pt->pscsi_req->retries = PS_RETRY;
 	/*
 	 * Queue the struct request into the struct scsi_device->request_queue.
+	 * Also check for HEAD_OF_QUEUE SAM TASK attr from received se_cmd
+	 * descriptor
 	 */
-	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, NULL,
-			      pt->pscsi_req, 1, pscsi_req_done);
+	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, NULL, pt->pscsi_req,
+			(task->task_se_cmd->sam_task_attr == TASK_ATTR_HOQ),
+			pscsi_req_done);
 
 	return PYX_TRANSPORT_SENT_TO_TRANSPORT;
 }
-- 
1.5.6.5

