From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: [PATCH 4/6] qedf: Covert single-threaded workqueues to regular workqueues.
Date: Tue, 15 Aug 2017 10:08:19 -0700
Message-ID: <20170815170821.20806-5-chad.dupuis@cavium.com>
References: <20170815170821.20806-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0080.outbound.protection.outlook.com ([104.47.32.80]:59820
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752547AbdHORJJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 13:09:09 -0400
In-Reply-To: <20170815170821.20806-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

There is no ordering required for the various workqueues the driver uses
so they can be converted to regular workqueues.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 0520dd1be749..24e8d2ab099c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2987,7 +2987,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 
 	sprintf(host_buf, "qedf_%u_link",
 	    qedf->lport->host->host_no);
-	qedf->link_update_wq = create_singlethread_workqueue(host_buf);
+	qedf->link_update_wq = create_workqueue(host_buf);
 	INIT_DELAYED_WORK(&qedf->link_update, qedf_handle_link_update);
 	INIT_DELAYED_WORK(&qedf->link_recovery, qedf_link_recovery);
 
@@ -3157,7 +3157,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	/* Start LL2 processing thread */
 	snprintf(host_buf, 20, "qedf_%d_ll2", host->host_no);
 	qedf->ll2_recv_wq =
-		create_singlethread_workqueue(host_buf);
+		create_workqueue(host_buf);
 	if (!qedf->ll2_recv_wq) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to LL2 workqueue.\n");
 		goto err7;
@@ -3199,7 +3199,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 
 	sprintf(host_buf, "qedf_%u_timer", qedf->lport->host->host_no);
 	qedf->timer_work_queue =
-		create_singlethread_workqueue(host_buf);
+		create_workqueue(host_buf);
 	if (!qedf->timer_work_queue) {
 		QEDF_ERR(&(qedf->dbg_ctx), "Failed to start timer "
 			  "workqueue.\n");
@@ -3210,7 +3210,7 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	if (mode != QEDF_MODE_RECOVERY) {
 		sprintf(host_buf, "qedf_%u_dpc",
 		    qedf->lport->host->host_no);
-		qedf->dpc_wq = create_singlethread_workqueue(host_buf);
+		qedf->dpc_wq = create_workqueue(host_buf);
 	}
 
 	/*
-- 
2.12.3
