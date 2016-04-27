From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 1/7] hpsa: correct initialization order issue
Date: Wed, 27 Apr 2016 17:13:26 -0500
Message-ID: <146179520607.31195.18171570890226870133.stgit@brunhilda>
References: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0082.outbound.protection.outlook.com ([157.56.110.82]:56960
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751553AbcD0W20 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2016 18:28:26 -0400
In-Reply-To: <146179474454.31195.15135625511559409075.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

The driver was calling scsi_scan_host before enabling interrupts.

This has gone unnoticed except for customers running in intx mode.
Calling scsi_scan_host before interrupts are enabled causes
"irq XX: nobody cared" messages and the driver to hang.

This patch enables interrupts before the call to scsi_scan_host.

Reported-by: Piotr Karbowski <piotr.karbowski@gmail.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5be944c..5763f43 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8541,11 +8541,6 @@ reinit_after_soft_reset:
 	if (rc)
 		goto clean6; /* sg, cmd, irq, shost, pci, lu, aer/h */
 
-	/* hook into SCSI subsystem */
-	rc = hpsa_scsi_add_host(h);
-	if (rc)
-		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
-
 	/* create the resubmit workqueue */
 	h->rescan_ctlr_wq = hpsa_create_controller_wq(h, "rescan");
 	if (!h->rescan_ctlr_wq) {
@@ -8642,6 +8637,11 @@ reinit_after_soft_reset:
 		dev_info(&h->pdev->dev,
 			"Can't track change to report lun data\n");
 
+	/* hook into SCSI subsystem */
+	rc = hpsa_scsi_add_host(h);
+	if (rc)
+		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
+
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
 	INIT_DELAYED_WORK(&h->monitor_ctlr_work, hpsa_monitor_ctlr_worker);

