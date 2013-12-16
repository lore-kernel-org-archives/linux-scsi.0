From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 08/24] qla4xxx: Fixed AER reset sequence for ISP83xx/ISP84xx
Date: Mon, 16 Dec 2013 06:49:38 -0500
Message-ID: <1387194594-29817-9-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:32722 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754333Ab3LPMXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:39 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h |  3 ++-
 drivers/scsi/qla4xxx/ql4_os.c  | 46 +++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 5236337..4e11133 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -909,7 +909,8 @@ static inline int is_qla80XX(struct scsi_qla_host *ha)
 static inline int is_aer_supported(struct scsi_qla_host *ha)
 {
 	return ((ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8022) ||
-		(ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8324));
+		(ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8324) ||
+		(ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8042));
 }
 
 static inline int adapter_up(struct scsi_qla_host *ha)
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index e6fa19c..a78edc3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9579,28 +9579,36 @@ static uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
 	}
 
 	fn = PCI_FUNC(ha->pdev->devfn);
-	while (fn > 0) {
-		fn--;
-		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Finding PCI device at "
-		    "func %x\n", ha->host_no, __func__, fn);
-		/* Get the pci device given the domain, bus,
-		 * slot/function number */
-		other_pdev =
-		    pci_get_domain_bus_and_slot(pci_domain_nr(ha->pdev->bus),
-		    ha->pdev->bus->number, PCI_DEVFN(PCI_SLOT(ha->pdev->devfn),
-		    fn));
-
-		if (!other_pdev)
-			continue;
+	if (is_qla8022(ha)) {
+		while (fn > 0) {
+			fn--;
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Finding PCI device at func %x\n",
+				   ha->host_no, __func__, fn);
+			/* Get the pci device given the domain, bus,
+			 * slot/function number */
+			other_pdev = pci_get_domain_bus_and_slot(
+					   pci_domain_nr(ha->pdev->bus),
+					   ha->pdev->bus->number,
+					   PCI_DEVFN(PCI_SLOT(ha->pdev->devfn),
+					   fn));
+
+			if (!other_pdev)
+				continue;
 
-		if (atomic_read(&other_pdev->enable_cnt)) {
-			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Found PCI "
-			    "func in enabled state%x\n", ha->host_no,
-			    __func__, fn);
+			if (atomic_read(&other_pdev->enable_cnt)) {
+				ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Found PCI func in enabled state%x\n",
+					   ha->host_no, __func__, fn);
+				pci_dev_put(other_pdev);
+				break;
+			}
 			pci_dev_put(other_pdev);
-			break;
 		}
-		pci_dev_put(other_pdev);
+	} else {
+		/* this case is meant for ISP83xx/ISP84xx only */
+		if (qla4_83xx_can_perform_reset(ha)) {
+			/* reset fn as iSCSI is going to perform the reset */
+			fn = 0;
+		}
 	}
 
 	/* The first function on the card, the reset owner will
-- 
1.8.2.GIT

