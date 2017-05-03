From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH V2 12/36] smartpqi: make pdev pointer names consistent
Date: Wed, 3 May 2017 18:53:30 -0500
Message-ID: <149385561017.11043.2472883687377034527.stgit@brunhilda>
References: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0065.outbound.protection.outlook.com ([104.47.34.65]:13440
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752014AbdECXxg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 3 May 2017 19:53:36 -0400
In-Reply-To: <149385549428.11043.8013091835763091910.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@hpe.com>

make all variable names for pointers to struct pci_dev consistent
throughout the driver.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   41 +++++++++++++++++----------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 586a1d5..0083ea4 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3093,19 +3093,19 @@ static irqreturn_t pqi_irq_handler(int irq, void *data)
 
 static int pqi_request_irqs(struct pqi_ctrl_info *ctrl_info)
 {
-	struct pci_dev *pdev = ctrl_info->pci_dev;
+	struct pci_dev *pci_dev = ctrl_info->pci_dev;
 	int i;
 	int rc;
 
-	ctrl_info->event_irq = pci_irq_vector(pdev, 0);
+	ctrl_info->event_irq = pci_irq_vector(pci_dev, 0);
 
 	for (i = 0; i < ctrl_info->num_msix_vectors_enabled; i++) {
-		rc = request_irq(pci_irq_vector(pdev, i), pqi_irq_handler, 0,
+		rc = request_irq(pci_irq_vector(pci_dev, i), pqi_irq_handler, 0,
 			DRIVER_NAME_SHORT, &ctrl_info->queue_groups[i]);
 		if (rc) {
-			dev_err(&pdev->dev,
+			dev_err(&pci_dev->dev,
 				"irq %u init failed with error %d\n",
-				pci_irq_vector(pdev, i), rc);
+				pci_irq_vector(pci_dev, i), rc);
 			return rc;
 		}
 		ctrl_info->num_msix_vectors_initialized++;
@@ -6229,7 +6229,7 @@ static void pqi_remove_ctrl(struct pqi_ctrl_info *ctrl_info)
 	pqi_free_ctrl_resources(ctrl_info);
 }
 
-static void pqi_print_ctrl_info(struct pci_dev *pdev,
+static void pqi_print_ctrl_info(struct pci_dev *pci_dev,
 	const struct pci_device_id *id)
 {
 	char *ctrl_description;
@@ -6248,41 +6248,42 @@ static void pqi_print_ctrl_info(struct pci_dev *pdev,
 		}
 	}
 
-	dev_info(&pdev->dev, "%s found\n", ctrl_description);
+	dev_info(&pci_dev->dev, "%s found\n", ctrl_description);
 }
 
-static int pqi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+static int pqi_pci_probe(struct pci_dev *pci_dev,
+	const struct pci_device_id *id)
 {
 	int rc;
 	int node;
 	struct pqi_ctrl_info *ctrl_info;
 
-	pqi_print_ctrl_info(pdev, id);
+	pqi_print_ctrl_info(pci_dev, id);
 
 	if (pqi_disable_device_id_wildcards &&
 		id->subvendor == PCI_ANY_ID &&
 		id->subdevice == PCI_ANY_ID) {
-		dev_warn(&pdev->dev,
+		dev_warn(&pci_dev->dev,
 			"controller not probed because device ID wildcards are disabled\n");
 		return -ENODEV;
 	}
 
 	if (id->subvendor == PCI_ANY_ID || id->subdevice == PCI_ANY_ID)
-		dev_warn(&pdev->dev,
+		dev_warn(&pci_dev->dev,
 			"controller device ID matched using wildcards\n");
 
-	node = dev_to_node(&pdev->dev);
+	node = dev_to_node(&pci_dev->dev);
 	if (node == NUMA_NO_NODE)
-		set_dev_node(&pdev->dev, 0);
+		set_dev_node(&pci_dev->dev, 0);
 
 	ctrl_info = pqi_alloc_ctrl_info(node);
 	if (!ctrl_info) {
-		dev_err(&pdev->dev,
+		dev_err(&pci_dev->dev,
 			"failed to allocate controller info block\n");
 		return -ENOMEM;
 	}
 
-	ctrl_info->pci_dev = pdev;
+	ctrl_info->pci_dev = pci_dev;
 
 	rc = pqi_pci_init(ctrl_info);
 	if (rc)
@@ -6300,23 +6301,23 @@ static int pqi_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return rc;
 }
 
-static void pqi_pci_remove(struct pci_dev *pdev)
+static void pqi_pci_remove(struct pci_dev *pci_dev)
 {
 	struct pqi_ctrl_info *ctrl_info;
 
-	ctrl_info = pci_get_drvdata(pdev);
+	ctrl_info = pci_get_drvdata(pci_dev);
 	if (!ctrl_info)
 		return;
 
 	pqi_remove_ctrl(ctrl_info);
 }
 
-static void pqi_shutdown(struct pci_dev *pdev)
+static void pqi_shutdown(struct pci_dev *pci_dev)
 {
 	int rc;
 	struct pqi_ctrl_info *ctrl_info;
 
-	ctrl_info = pci_get_drvdata(pdev);
+	ctrl_info = pci_get_drvdata(pci_dev);
 	if (!ctrl_info)
 		goto error;
 
@@ -6329,7 +6330,7 @@ static void pqi_shutdown(struct pci_dev *pdev)
 		return;
 
 error:
-	dev_warn(&pdev->dev,
+	dev_warn(&pci_dev->dev,
 		"unable to flush controller cache\n");
 }
 
