From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v1 10/12] be2iscsi: Fix ExpStatSn in management tasks
Date: Thu,  4 Feb 2016 15:49:18 +0530
Message-ID: <1454581160-31869-11-git-send-email-jitendra.bhivare@broadcom.com>
References: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:62101 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S964847AbcBDKhi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 05:37:38 -0500
In-Reply-To: <1454581160-31869-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Connection resets observed from some targets when NOP-Out with wrong
ExpStatSn is sent.

FW keeps track of StatSn and fills up ExpStatSn accordingly.
The header filled up by the stack needs to be modified by driver to clear
ExpStatSn. If the field is not cleared, FW recalculates ExpStatSn and
wrong offset'ed ExpStatSn is seen in the wire trace.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/be2iscsi/be_main.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 3f08a11..03265b6 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4926,7 +4926,6 @@ int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
 
 	pwrb = io_task->pwrb_handle->pwrb;
 
-	io_task->cmd_bhs->iscsi_hdr.exp_statsn = 0;
 	io_task->bhs_len = sizeof(struct be_cmd_bhs);
 
 	if (writedir) {
@@ -4987,7 +4986,6 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 	unsigned int doorbell = 0;
 
 	pwrb = io_task->pwrb_handle->pwrb;
-	io_task->cmd_bhs->iscsi_hdr.exp_statsn = 0;
 	io_task->bhs_len = sizeof(struct be_cmd_bhs);
 
 	if (writedir) {
@@ -5159,23 +5157,21 @@ static int beiscsi_task_xmit(struct iscsi_task *task)
 {
 	struct beiscsi_io_task *io_task = task->dd_data;
 	struct scsi_cmnd *sc = task->sc;
-	struct beiscsi_hba *phba = NULL;
+	struct beiscsi_hba *phba;
 	struct scatterlist *sg;
 	int num_sg;
 	unsigned int  writedir = 0, xferlen = 0;
 
-	phba = ((struct beiscsi_conn *)task->conn->dd_data)->phba;
+	if (!io_task->conn->login_in_progress)
+		task->hdr->exp_statsn = 0;
 
 	if (!sc)
 		return beiscsi_mtask(task);
 
 	io_task->scsi_cmnd = sc;
 	num_sg = scsi_dma_map(sc);
+	phba = io_task->conn->phba;
 	if (num_sg < 0) {
-		struct iscsi_conn *conn = task->conn;
-		struct beiscsi_hba *phba = NULL;
-
-		phba = ((struct beiscsi_conn *)conn->dd_data)->phba;
 		beiscsi_log(phba, KERN_ERR,
 			    BEISCSI_LOG_IO | BEISCSI_LOG_ISCSI,
 			    "BM_%d : scsi_dma_map Failed "
-- 
2.5.0

