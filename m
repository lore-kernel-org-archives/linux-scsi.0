From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH] qedi: Limit number for CQ queues.
Date: Thu, 10 Aug 2017 06:32:17 -0700
Message-ID: <20170810133217.31481-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0067.outbound.protection.outlook.com ([104.47.41.67]:59760
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751456AbdHJNcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 09:32:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

[qed_sp_iscsi_func_start:189(host_7-0)]Cannot satisfy CQ amount. Queues
requested 8, CQs available 4. Aborting function start

Above condition will resolve as management firmware is capable of telling
us the number of CQs available for a given PF, qed will communicate the
same number to qedi, So that qedi will know how much CQs are allowed.

Signed-off-by: Manish Rangankar <manish.rangankar@cavium.com>
---
 drivers/scsi/qedi/qedi.h       |  5 ++---
 drivers/scsi/qedi/qedi_iscsi.c |  2 +-
 drivers/scsi/qedi/qedi_main.c  | 10 +++++++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qedi/qedi.h b/drivers/scsi/qedi/qedi.h
index 91d2f51..b8b22ce 100644
--- a/drivers/scsi/qedi/qedi.h
+++ b/drivers/scsi/qedi/qedi.h
@@ -54,8 +54,8 @@
 /* MAX Length for cached SGL */
 #define MAX_SGLEN_FOR_CACHESGL	((1U << 16) - 1)
 
-#define MAX_NUM_MSIX_PF         8
-#define MIN_NUM_CPUS_MSIX(x)	min((x)->msix_count, num_online_cpus())
+#define MIN_NUM_CPUS_MSIX(x)	min_t(u32, x->dev_info.num_cqs, \
+					num_online_cpus())
 
 #define QEDI_LOCAL_PORT_MIN     60000
 #define QEDI_LOCAL_PORT_MAX     61024
@@ -301,7 +301,6 @@ struct qedi_ctx {
 	u16 bdq_prod_idx;
 	u16 rq_num_entries;
 
-	u32 msix_count;
 	u32 max_sqes;
 	u8 num_queues;
 	u32 max_active_conns;
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 37da9a8..a02b34e 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -534,7 +534,7 @@ static int qedi_iscsi_offload_conn(struct qedi_endpoint *qedi_ep)
 	SET_FIELD(conn_info->tcp_flags, TCP_OFFLOAD_PARAMS_DA_CNT_EN, 1);
 	SET_FIELD(conn_info->tcp_flags, TCP_OFFLOAD_PARAMS_KA_EN, 1);
 
-	conn_info->default_cq = (qedi_ep->fw_cid % 8);
+	conn_info->default_cq = (qedi_ep->fw_cid % qedi->num_queues);
 
 	conn_info->ka_max_probe_cnt = DEF_KA_MAX_PROBE_COUNT;
 	conn_info->dup_ack_theshold = 3;
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 2c37836..c4a470b 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -794,13 +794,14 @@ static int qedi_set_iscsi_pf_param(struct qedi_ctx *qedi)
 	u32 log_page_size;
 	int rval = 0;
 
-	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_DISC, "Min number of MSIX %d\n",
-		  MIN_NUM_CPUS_MSIX(qedi));
 
 	num_sq_pages = (MAX_OUSTANDING_TASKS_PER_CON * 8) / PAGE_SIZE;
 
 	qedi->num_queues = MIN_NUM_CPUS_MSIX(qedi);
 
+	QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
+		  "Number of CQ count is %d\n", qedi->num_queues);
+
 	memset(&qedi->pf_params.iscsi_pf_params, 0,
 	       sizeof(qedi->pf_params.iscsi_pf_params));
 
@@ -2179,9 +2180,12 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
 		goto free_host;
 	}
 
-	qedi->msix_count = MAX_NUM_MSIX_PF;
 	atomic_set(&qedi->link_state, QEDI_LINK_DOWN);
 
+	rc = qedi_ops->fill_dev_info(qedi->cdev, &qedi->dev_info);
+	if (rc)
+		goto free_host;
+
 	if (mode != QEDI_MODE_RECOVERY) {
 		rc = qedi_set_iscsi_pf_param(qedi);
 		if (rc) {
-- 
1.8.3.1
