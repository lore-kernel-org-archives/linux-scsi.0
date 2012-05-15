From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 07/22] qla2xxx: Handle interrupt registration failures more gracefully.
Date: Tue, 15 May 2012 14:34:14 -0400
Message-ID: <1337106869-14191-8-git-send-email-chad.dupuis@qlogic.com>
References: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:20335 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S966397Ab2EOS5s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 14:57:48 -0400
In-Reply-To: <1337106869-14191-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

If interrupt registration failed we could crash the machine as we were trying
to deference some pointers which weren't allocated yet.  Move the allocation
a little earlier and make some checks to the free resource code to make sure
that we don't try to free a resource that was never allocated.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   10 ++++++++-
 drivers/scsi/qla2xxx/qla_os.c  |   44 ++++++++++++++++++++++++++++-----------
 2 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ce42288..f4b8a5f 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2564,7 +2564,15 @@ void
 qla2x00_free_irqs(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct rsp_que *rsp = ha->rsp_q_map[0];
+	struct rsp_que *rsp;
+
+	/*
+	 * We need to check that ha->rsp_q_map is valid in case we are called
+	 * from a probe failure context.
+	 */
+	if (!ha->rsp_q_map || !ha->rsp_q_map[0])
+		return;
+	rsp = ha->rsp_q_map[0];
 
 	if (ha->flags.msix_enabled)
 		qla24xx_disable_msix(ha);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7db8033..2e6dd88 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -306,7 +306,8 @@ static void qla2x00_free_fw_dump(struct qla_hw_data *);
 static void qla2x00_mem_free(struct qla_hw_data *);
 
 /* -------------------------------------------------------------------------- */
-static int qla2x00_alloc_queues(struct qla_hw_data *ha)
+static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
+				struct rsp_que *rsp)
 {
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	ha->req_q_map = kzalloc(sizeof(struct req_que *) * ha->max_req_queues,
@@ -324,6 +325,12 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha)
 		    "Unable to allocate memory for response queue ptrs.\n");
 		goto fail_rsp_map;
 	}
+	/*
+	 * Make sure we record at least the request and response queue zero in
+	 * case we need to free them if part of the probe fails.
+	 */
+	ha->rsp_q_map[0] = rsp;
+	ha->req_q_map[0] = req;
 	set_bit(0, ha->rsp_qid_map);
 	set_bit(0, ha->req_qid_map);
 	return 1;
@@ -2417,6 +2424,16 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	    host->max_cmd_len, host->max_channel, host->max_lun,
 	    host->transportt, sht->vendor_id);
 
+que_init:
+	/* Alloc arrays of request and response ring ptrs */
+	if (!qla2x00_alloc_queues(ha, req, rsp)) {
+		ql_log(ql_log_fatal, base_vha, 0x003d,
+		    "Failed to allocate memory for queue pointers..."
+		    "aborting.\n");
+		goto probe_init_failed;
+	}
+
+
 	/* Set up the irqs */
 	ret = qla2x00_request_irqs(ha, rsp);
 	if (ret)
@@ -2424,20 +2441,10 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_save_state(pdev);
 
-	/* Alloc arrays of request and response ring ptrs */
-que_init:
-	if (!qla2x00_alloc_queues(ha)) {
-		ql_log(ql_log_fatal, base_vha, 0x003d,
-		    "Failed to allocate memory for queue pointers.. aborting.\n");
-		goto probe_init_failed;
-	}
-
-	ha->rsp_q_map[0] = rsp;
-	ha->req_q_map[0] = req;
+	/* Assign back pointers */
 	rsp->req = req;
 	req->rsp = rsp;
-	set_bit(0, ha->req_qid_map);
-	set_bit(0, ha->rsp_qid_map);
+
 	/* FWI2-capable only. */
 	req->req_q_in = &ha->iobase->isp24.req_q_in;
 	req->req_q_out = &ha->iobase->isp24.req_q_out;
@@ -2581,7 +2588,11 @@ skip_dpc:
 
 probe_init_failed:
 	qla2x00_free_req_que(ha, req);
+	ha->req_q_map[0] = NULL;
+	clear_bit(0, ha->req_qid_map);
 	qla2x00_free_rsp_que(ha, rsp);
+	ha->rsp_q_map[0] = NULL;
+	clear_bit(0, ha->rsp_qid_map);
 	ha->max_req_queues = ha->max_rsp_queues = 0;
 
 probe_failed:
@@ -2663,6 +2674,13 @@ qla2x00_remove_one(struct pci_dev *pdev)
 	struct qla_hw_data  *ha;
 	unsigned long flags;
 
+	/*
+	 * If the PCI device is disabled that means that probe failed and any
+	 * resources should be have cleaned up on probe exit.
+	 */
+	if (!atomic_read(&pdev->enable_cnt))
+		return;
+
 	base_vha = pci_get_drvdata(pdev);
 	ha = base_vha->hw;
 
-- 
1.7.7

