From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 4/5] be2iscsi: Fix processing CQE before connection resources are freed
Date: Fri,  8 Aug 2014 01:00:01 -0400
Message-ID: <1407474003-26220-4-git-send-email-jkallickal@emulex.com>
References: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:53040 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbaHHFAT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2014 01:00:19 -0400
Received: by mail-pd0-f170.google.com with SMTP id g10so6398202pdj.15
        for <linux-scsi@vger.kernel.org>; Thu, 07 Aug 2014 22:00:19 -0700 (PDT)
In-Reply-To: <1407474003-26220-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 Driver should process the completion queue entries before a connection
 resources are freed. While running mixed traffic due to latency, driver
 processes the CQE after the connection resources are freed. This fix
 processes all the completion queue before the connection resources are
 freed.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 29 +++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_main.c  | 15 ++++++++++++++-
 drivers/scsi/be2iscsi/be_main.h  |  3 +++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index e25203e..b7391a3 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1274,6 +1274,31 @@ int beiscsi_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 }
 
 /**
+ * beiscsi_flush_cq()- Flush the CQ created.
+ * @phba: ptr device priv structure.
+ *
+ * Before the connection resource are freed flush
+ * all the CQ enteries
+ **/
+static void beiscsi_flush_cq(struct beiscsi_hba *phba)
+{
+	uint16_t i;
+	struct be_eq_obj *pbe_eq;
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+
+	for (i = 0; i < phba->num_cpus; i++) {
+		pbe_eq = &phwi_context->be_eq[i];
+		blk_iopoll_disable(&pbe_eq->iopoll);
+		beiscsi_process_cq(pbe_eq);
+		blk_iopoll_enable(&pbe_eq->iopoll);
+	}
+}
+
+/**
  * beiscsi_close_conn - Upload the  connection
  * @ep: The iscsi endpoint
  * @flag: The type of connection closure
@@ -1294,6 +1319,10 @@ static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 	}
 
 	ret = beiscsi_mccq_compl(phba, tag, NULL, NULL);
+
+	/* Flush the CQ entries */
+	beiscsi_flush_cq(phba);
+
 	return ret;
 }
 
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 8f9f625..cbc9fc2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2068,7 +2068,7 @@ static void  beiscsi_process_mcc_isr(struct beiscsi_hba *phba)
  * return
  *     Number of Completion Entries processed.
  **/
-static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
+unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 {
 	struct be_queue_info *cq;
 	struct sol_cqe *sol;
@@ -2110,6 +2110,18 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 
 		cri_index = BE_GET_CRI_FROM_CID(cid);
 		ep = phba->ep_array[cri_index];
+
+		if (ep == NULL) {
+			/* connection has already been freed
+			 * just move on to next one
+			 */
+			beiscsi_log(phba, KERN_WARNING,
+				    BEISCSI_LOG_INIT,
+				    "BM_%d : proc cqe of disconn ep: cid %d\n",
+				    cid);
+			goto proc_next_cqe;
+		}
+
 		beiscsi_ep = ep->dd_data;
 		beiscsi_conn = beiscsi_ep->conn;
 
@@ -2219,6 +2231,7 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
 			break;
 		}
 
+proc_next_cqe:
 		AMAP_SET_BITS(struct amap_sol_cqe, valid, sol, 0);
 		queue_tail_inc(cq);
 		sol = queue_tail_node(cq);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 1e3428a..5f8b0fc 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -840,6 +840,9 @@ void beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
 void hwi_ring_cq_db(struct beiscsi_hba *phba,
 		     unsigned int id, unsigned int num_processed,
 		     unsigned char rearm, unsigned char event);
+
+unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq);
+
 static inline bool beiscsi_error(struct beiscsi_hba *phba)
 {
 	return phba->ue_detected || phba->fw_timeout;
-- 
1.8.5.3

