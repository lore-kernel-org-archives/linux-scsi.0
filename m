From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/8] qla2xxx: Make driver (mostly) legacy I/O port free.
Date: Fri, 19 Oct 2007 15:59:17 -0700
Message-ID: <1192834760-573-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20071019225824.GG24197@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29152 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966648AbXJSW7k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 18:59:40 -0400
In-Reply-To: <20071019225824.GG24197@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Recent ISPs need only the single MMIO BAR to manipulate HW
registers.  Unfortunately, ISP21xx, ISP22xx, ISP23xx, and ISP63xx
type cards still require the I/O mapped region to manipulate the
FLASH via the two HW flash-registers (flash_address and
flash_data).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_os.c  |   50 ++++++++++++++++++++++++----------------
 2 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1900fbf..04e8cbc 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2271,6 +2271,7 @@ typedef struct scsi_qla_host {
 
 	spinlock_t		hardware_lock ____cacheline_aligned;
 
+	int		bars;
 	device_reg_t __iomem *iobase;		/* Base I/O address */
 	unsigned long	pio_address;
 	unsigned long	pio_length;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0351d38..a5bcf1f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1482,6 +1482,17 @@ qla2x00_iospace_config(scsi_qla_host_t *ha)
 	unsigned long	pio, pio_len, pio_flags;
 	unsigned long	mmio, mmio_len, mmio_flags;
 
+	if (pci_request_selected_regions(ha->pdev, ha->bars,
+	    QLA2XXX_DRIVER_NAME)) {
+		qla_printk(KERN_WARNING, ha,
+		    "Failed to reserve PIO/MMIO regions (%s)\n",
+		    pci_name(ha->pdev));
+
+		goto iospace_error_exit;
+	}
+	if (!(ha->bars & 1))
+		goto skip_pio;
+
 	/* We only need PIO for Flash operations on ISP2312 v2 chips. */
 	pio = pci_resource_start(ha->pdev, 0);
 	pio_len = pci_resource_len(ha->pdev, 0);
@@ -1499,7 +1510,10 @@ qla2x00_iospace_config(scsi_qla_host_t *ha)
 		    pci_name(ha->pdev));
 		pio = 0;
 	}
+	ha->pio_address = pio;
+	ha->pio_length = pio_len;
 
+skip_pio:
 	/* Use MMIO operations for all accesses. */
 	mmio = pci_resource_start(ha->pdev, 1);
 	mmio_len = pci_resource_len(ha->pdev, 1);
@@ -1518,16 +1532,6 @@ qla2x00_iospace_config(scsi_qla_host_t *ha)
 		goto iospace_error_exit;
 	}
 
-	if (pci_request_regions(ha->pdev, QLA2XXX_DRIVER_NAME)) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to reserve PIO/MMIO regions (%s)\n",
-		    pci_name(ha->pdev));
-
-		goto iospace_error_exit;
-	}
-
-	ha->pio_address = pio;
-	ha->pio_length = pio_len;
 	ha->iobase = ioremap(mmio, MIN_IOBASE_LEN);
 	if (!ha->iobase) {
 		qla_printk(KERN_ERR, ha,
@@ -1579,21 +1583,26 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
+	int bars;
 
-	if (pci_enable_device(pdev))
-		goto probe_out;
-
-	if (pci_find_aer_capability(pdev))
-		if (pci_enable_pcie_error_reporting(pdev))
-			goto probe_out;
-
+	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2x00_driver_template;
 	if (pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2432 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5422 ||
 	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP5432 ||
-	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532)
+	    pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2532) {
+		bars = pci_select_bars(pdev, IORESOURCE_MEM);
 		sht = &qla24xx_driver_template;
+	}
+
+	if (pci_enable_device_bars(pdev, bars))
+		goto probe_out;
+
+	if (pci_find_aer_capability(pdev))
+		if (pci_enable_pcie_error_reporting(pdev))
+			goto probe_out;
+
 	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
 	if (host == NULL) {
 		printk(KERN_WARNING
@@ -1610,6 +1619,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->host_no = host->host_no;
 	sprintf(ha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, ha->host_no);
 	ha->parent = NULL;
+	ha->bars = bars;
 
 	/* Set ISP-type information. */
 	qla2x00_set_isp_flags(ha);
@@ -1880,7 +1890,7 @@ qla2x00_free_device(scsi_qla_host_t *ha)
 	/* release io space registers  */
 	if (ha->iobase)
 		iounmap(ha->iobase);
-	pci_release_regions(ha->pdev);
+	pci_release_selected_regions(ha->pdev, ha->bars);
 }
 
 static inline void
@@ -2890,7 +2900,7 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
 	scsi_qla_host_t *ha = pci_get_drvdata(pdev);
 
-	if (pci_enable_device(pdev)) {
+	if (pci_enable_device_bars(pdev, ha->bars)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Can't re-enable PCI device after reset.\n");
 
-- 
1.5.3.4.206.g58ba4

