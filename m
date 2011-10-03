From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 11/13] qla4xxx: Fixed target discovery failed issue.
Date: Mon, 3 Oct 2011 10:29:25 -0700
Message-ID: <1317662967-30110-12-git-send-email-vikas.chaudhary@qlogic.com>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:46447
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757125Ab1JCRlt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 13:41:49 -0400
In-Reply-To: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

From: Manish Rangankar <manish.rangankar@qlogic.com>

When sendtargets response is grater then max receive data segment length,
the passthrough IOCB failed with data overrun status. Solution is to
allocate space for iSCSI header in the IOCB response buffer.

JIRA Key: UPSISCSI-147

Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |    1 +
 drivers/scsi/qla4xxx/ql4_iocb.c |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c   |    9 +++++----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index fcb1dff..ace637b 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -631,6 +631,7 @@ struct ql4_task_data {
 	dma_addr_t data_dma;
 	void *req_buffer;
 	dma_addr_t req_dma;
+	uint32_t req_len;
 	void *resp_buffer;
 	dma_addr_t resp_dma;
 	uint32_t resp_len;
diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index ad40a61..4106693 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -407,7 +407,7 @@ int qla4xxx_send_passthru0(struct iscsi_task *task)
 	passthru_iocb->timeout = cpu_to_le16(PT_DEFAULT_TIMEOUT);
 
 	/* Setup the out & in DSDs */
-	if (task->data_count) {
+	if (task_data->req_len) {
 		memcpy((uint8_t *)task_data->req_buffer +
 		       sizeof(struct iscsi_hdr), task->data, task->data_count);
 		ctrl_flags |= PT_FLAG_SEND_BUFFER;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 47e4fcb..34388b6 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1273,7 +1273,7 @@ static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
 		      __func__, task->conn->max_recv_dlength, hdr_len));
 
-	task_data->resp_len = task->conn->max_recv_dlength;
+	task_data->resp_len = task->conn->max_recv_dlength + hdr_len;
 	task_data->resp_buffer = dma_alloc_coherent(&ha->pdev->dev,
 						    task_data->resp_len,
 						    &task_data->resp_dma,
@@ -1281,8 +1281,9 @@ static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	if (!task_data->resp_buffer)
 		goto exit_alloc_pdu;
 
+	task_data->req_len = task->data_count + hdr_len;
 	task_data->req_buffer = dma_alloc_coherent(&ha->pdev->dev,
-						   task->data_count + hdr_len,
+						   task_data->req_len,
 						   &task_data->req_dma,
 						   GFP_ATOMIC);
 	if (!task_data->req_buffer)
@@ -1300,7 +1301,7 @@ exit_alloc_pdu:
 				  task_data->resp_buffer, task_data->resp_dma);
 
 	if (task_data->req_buffer)
-		dma_free_coherent(&ha->pdev->dev, task->data_count + hdr_len,
+		dma_free_coherent(&ha->pdev->dev, task_data->req_len,
 				  task_data->req_buffer, task_data->req_dma);
 	return -ENOMEM;
 }
@@ -1329,7 +1330,7 @@ static void qla4xxx_task_cleanup(struct iscsi_task *task)
 
 	dma_free_coherent(&ha->pdev->dev, task_data->resp_len,
 			  task_data->resp_buffer, task_data->resp_dma);
-	dma_free_coherent(&ha->pdev->dev, task->data_count + hdr_len,
+	dma_free_coherent(&ha->pdev->dev, task_data->req_len,
 			  task_data->req_buffer, task_data->req_dma);
 	return;
 }
-- 
1.7.6


