From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: [PATCH 8/8] qla4xxx: Resubmission: ql4_os.c bugfixes
Date: Wed, 23 May 2007 18:03:32 -0700
Message-ID: <1179968612.16099.19.camel@iscsi-sles10>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:6166 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757280AbXEXBEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 21:04:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, David Somayajulu <david.somayajulu@qlogic.com>, David Wagner <david.wagner@qlogic.com>

Free memory resources after invoking free_irq() in qla4xxx_free_adapter(). QLA4xxx has two pci functions per port (Ethernet and iSCSI). When one of these PCI functions issues a HBA reset, all other functions are notified and need to acknowledge and re-initialize. During module qla4xxx_remove_adapter() gets invoked. This function needs to wait if it is currently responding to a reset from another function.

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

 drivers/scsi/qla4xxx/ql4_os.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index da21f5f..0e4688c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -10,6 +10,10 @@ #include <scsi/scsi_tcq.h>
 #include <scsi/scsicam.h>
 
 #include "ql4_def.h"
+#include "ql4_version.h"
+#include "ql4_glbl.h"
+#include "ql4_dbg.h"
+#include "ql4_inline.h"
 
 /*
  * Driver version
@@ -711,7 +715,7 @@ static int qla4xxx_cmd_wait(struct scsi_
 	return stat;
 }
 
-static void qla4xxx_hw_reset(struct scsi_qla_host *ha)
+void qla4xxx_hw_reset(struct scsi_qla_host *ha)
 {
 	uint32_t ctrl_status;
 	unsigned long flags = 0;
@@ -1081,13 +1085,13 @@ static void qla4xxx_free_adapter(struct 
 	if (ha->timer_active)
 		qla4xxx_stop_timer(ha);
 
-	/* free extra memory */
-	qla4xxx_mem_free(ha);
-
 	/* Detach interrupts */
 	if (test_and_clear_bit(AF_IRQ_ATTACHED, &ha->flags))
 		free_irq(ha->pdev->irq, ha);
 
+	/* free extra memory */
+	qla4xxx_mem_free(ha);
+
 	pci_disable_device(ha->pdev);
 
 }
@@ -1332,6 +1336,11 @@ static void __devexit qla4xxx_remove_ada
 
 	ha = pci_get_drvdata(pdev);
 
+	qla4xxx_disable_intrs(ha);
+
+	while (test_bit(DPC_RESET_HA_INTR, &ha->dpc_flags))
+		ssleep(1);
+
 	/* remove devs from iscsi_sessions to scsi_devices */
 	qla4xxx_free_ddb_list(ha);
 

