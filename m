From: Doug Maxey <dwm@enoyolf.org>
Subject: [PATCH 2/3] qla4xxx: really move free_adapter
Date: Wed, 09 Aug 2006 13:42:32 -0500
Message-ID: <20060809184232.2021.12800.stgit@bebe.enoyolf.org>
References: <20060809182406.2021.90492.stgit@bebe.enoyolf.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:12467 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S1751315AbWHISrE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Aug 2006 14:47:04 -0400
In-Reply-To: <20060809182406.2021.90492.stgit@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

From: Doug Maxey <dwm@enoyolf.org>

Ok.  This one got away.  Really move defn to before callers.

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---

 drivers/scsi/qla4xxx/ql4_os.c |   69 ++++++++++++++++++++---------------------
 1 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b14e63a..f656fb3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -47,7 +47,6 @@ MODULE_PARM_DESC(extended_error_logging,
 void qla4xxx_config_dma_addressing(struct scsi_qla_host *ha);
 
 static int qla4xxx_iospace_config(struct scsi_qla_host *ha);
-static void qla4xxx_free_adapter(struct scsi_qla_host *ha);
 
 /*
  * iSCSI template entry points
@@ -1106,6 +1105,40 @@ static void qla4xxx_do_dpc(void *data)
 }
 
 /**
+ * qla4xxx_free_adapter - release the adapter
+ * @ha: pointer to adapter structure
+ **/
+static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
+{
+
+	if (test_bit(AF_INTERRUPTS_ON, &ha->flags)) {
+		/* Turn-off interrupts on the card. */
+		qla4xxx_disable_intrs(ha);
+	}
+
+	/* Kill the kernel thread for this host */
+	if (ha->dpc_thread)
+		destroy_workqueue(ha->dpc_thread);
+
+	/* Issue Soft Reset to put firmware in unknown state */
+	qla4xxx_soft_reset(ha);
+
+	/* Remove timer thread, if present */
+	if (ha->timer_active)
+		qla4xxx_stop_timer(ha);
+
+	/* free extra memory */
+	qla4xxx_mem_free(ha);
+
+	/* Detach interrupts */
+	if (test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags))
+		free_irq(ha->pdev->irq, ha);
+
+	pci_disable_device(ha->pdev);
+
+}
+
+/**
  * qla4xxx_probe_adapter - callback function to probe HBA
  * @pdev: pointer to pci_dev structure
  * @pci_device_id: pointer to pci_device entry
@@ -1288,40 +1321,6 @@ static void __devexit qla4xxx_remove_ada
 	pci_set_drvdata(pdev, NULL);
 }
 
-/**
- * qla4xxx_free_adapter - release the adapter
- * @ha: pointer to adapter structure
- **/
-static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
-{
-
-	if (test_bit(AF_INTERRUPTS_ON, &ha->flags)) {
-		/* Turn-off interrupts on the card. */
-		qla4xxx_disable_intrs(ha);
-	}
-
-	/* Kill the kernel thread for this host */
-	if (ha->dpc_thread)
-		destroy_workqueue(ha->dpc_thread);
-
-	/* Issue Soft Reset to put firmware in unknown state */
-	qla4xxx_soft_reset(ha);
-
-	/* Remove timer thread, if present */
-	if (ha->timer_active)
-		qla4xxx_stop_timer(ha);
-
-	/* free extra memory */
-	qla4xxx_mem_free(ha);
-
-	/* Detach interrupts */
-	if (test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags))
-		free_irq(ha->pdev->irq, ha);
-
-	pci_disable_device(ha->pdev);
-
-}
-
 /***
  * qla4xxx_iospace_config - maps registers
  * @ha: pointer to adapter structure
