From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 02/37] smartpqi: cleanup interrupt management
Date: Tue, 25 Apr 2017 14:46:04 -0500
Message-ID: <149314956402.13903.6707238397795732028.stgit@brunhilda>
References: <149314950730.13903.644081079070695025.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0075.outbound.protection.outlook.com ([104.47.37.75]:57613
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1031978AbdDYTqP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 15:46:15 -0400
In-Reply-To: <149314950730.13903.644081079070695025.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

minor cleanup of interrupt initialization and tear-down.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   45 ++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index dd00c69..39695a4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2892,9 +2892,9 @@ static irqreturn_t pqi_irq_handler(int irq, void *data)
 
 static int pqi_request_irqs(struct pqi_ctrl_info *ctrl_info)
 {
-	struct pci_dev *pdev = ctrl_info->pci_dev;
 	int i;
 	int rc;
+	struct pci_dev *pdev = ctrl_info->pci_dev;
 
 	ctrl_info->event_irq = pci_irq_vector(pdev, 0);
 
@@ -2913,23 +2913,44 @@ static int pqi_request_irqs(struct pqi_ctrl_info *ctrl_info)
 	return 0;
 }
 
+static void pqi_free_irqs(struct pqi_ctrl_info *ctrl_info)
+{
+	int i;
+
+	for (i = 0; i < ctrl_info->num_msix_vectors_initialized; i++)
+		free_irq(pci_irq_vector(ctrl_info->pci_dev, i),
+			&ctrl_info->queue_groups[i]);
+
+	ctrl_info->num_msix_vectors_initialized = 0;
+}
+
 static int pqi_enable_msix_interrupts(struct pqi_ctrl_info *ctrl_info)
 {
-	int ret;
+	int num_vectors_enabled;
 
-	ret = pci_alloc_irq_vectors(ctrl_info->pci_dev,
+	num_vectors_enabled = pci_alloc_irq_vectors(ctrl_info->pci_dev,
 			PQI_MIN_MSIX_VECTORS, ctrl_info->num_queue_groups,
 			PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
-	if (ret < 0) {
+	if (num_vectors_enabled < 0) {
 		dev_err(&ctrl_info->pci_dev->dev,
-			"MSI-X init failed with error %d\n", ret);
-		return ret;
+			"MSI-X init failed with error %d\n",
+			num_vectors_enabled);
+		return num_vectors_enabled;
 	}
 
-	ctrl_info->num_msix_vectors_enabled = ret;
+	ctrl_info->num_msix_vectors_enabled = num_vectors_enabled;
+
 	return 0;
 }
 
+static void pqi_disable_msix_interrupts(struct pqi_ctrl_info *ctrl_info)
+{
+	if (ctrl_info->num_msix_vectors_enabled) {
+		pci_free_irq_vectors(ctrl_info->pci_dev);
+		ctrl_info->num_msix_vectors_enabled = 0;
+	}
+}
+
 static int pqi_alloc_operational_queues(struct pqi_ctrl_info *ctrl_info)
 {
 	unsigned int i;
@@ -5519,14 +5540,8 @@ static inline void pqi_free_ctrl_info(struct pqi_ctrl_info *ctrl_info)
 
 static void pqi_free_interrupts(struct pqi_ctrl_info *ctrl_info)
 {
-	int i;
-
-	for (i = 0; i < ctrl_info->num_msix_vectors_initialized; i++) {
-		free_irq(pci_irq_vector(ctrl_info->pci_dev, i),
-				&ctrl_info->queue_groups[i]);
-	}
-
-	pci_free_irq_vectors(ctrl_info->pci_dev);
+	pqi_free_irqs(ctrl_info);
+	pqi_disable_msix_interrupts(ctrl_info);
 }
 
 static void pqi_free_ctrl_resources(struct pqi_ctrl_info *ctrl_info)
