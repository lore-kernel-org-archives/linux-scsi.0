From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] qla2xxx: Disable MSI/MSI-X on some chips or as selected by
 module parameter
Date: Wed, 10 Mar 2010 04:53:50 +0000
Message-ID: <1268196830.2819.593.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55771 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756254Ab0CJEyB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2010 23:54:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Bernd Zeimetz <bzed@debian.org>, Marcus Barrow <mbarrow@redhat.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com

MSI is unreliable on many of the QLA24xx chips, resulting in fatal
I/O errors under load, as reported in <http://bugs.debian.org/572322>
and by some RHEL customers.

RHEL 5 includes a series of fixes by Marcus Barrow <mbarrow@redhat.com>
with the combined effect that:
- MSI is disabled on QLA24xx chips other than QLA2432 (MSI-X already was)
- MSI-X is disabled if qlx2enablemsix=2
- MSI and MSI-X are disabled if qlx2enablemsix=0
(and by default qlx2enablemsix=1).

Bring these changes upstream.

For reference, the patch filenames in RHEL are:
    linux-2.6-scsi-qla2xxx-disable-msi-x-by-default.patch
    linux-2.6-scsi-qla2xxx-msi-x-hardware-issues-on-platforms.patch
    linux-2.6-scsi-qla2xxx-allow-use-of-msi-when-msi-x-disabled.patch
    linux-2.6-scsi-qla2xxx-enable-msi-x-correctly-on-qlogic-2xxx-series.patch

Reported-by: Bernd Zeimetz <bzed@debian.org>
Cc: stable@kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |   31 ++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_os.c  |    9 +++++++++
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3a89bc5..a6f3e61 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -79,6 +79,7 @@ extern int ql2xmaxqueues;
 extern int ql2xmultique_tag;
 extern int ql2xfwloadbin;
 extern int ql2xetsenable;
+extern int ql2xenablemsix;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ab90329..fb49a55 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2270,19 +2270,13 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 	int ret;
 	device_reg_t __iomem *reg = ha->iobase;
 
-	/* If possible, enable MSI-X. */
+	/* If possible, enable MSI-X, MSI. */
+	if (ql2xenablemsix == 0)
+		goto skip_msi;
+
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
 	    !IS_QLA8432(ha) && !IS_QLA8001(ha))
-		goto skip_msix;
-
-	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
-		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		"MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
-			ha->pdev->revision, ha->fw_attributes));
-
-		goto skip_msix;
-	}
+		goto skip_msi;
 
 	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
 	    (ha->pdev->subsystem_device == 0x7040 ||
@@ -2296,6 +2290,17 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 		goto skip_msi;
 	}
 
+	if (ql2xenablemsix == 2)
+		goto skip_msix;
+
+	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
+	    !QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+		    "MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
+		    ha->pdev->revision, ha->fw_attributes));
+		goto skip_msix;
+	}
+
 	ret = qla24xx_enable_msix(ha, rsp);
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
@@ -2307,10 +2312,6 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 	    "MSI-X: Falling back-to INTa mode -- %d.\n", ret);
 skip_msix:
 
-	if (!IS_QLA24XX(ha) && !IS_QLA2532(ha) && !IS_QLA8432(ha) &&
-	    !IS_QLA8001(ha))
-		goto skip_msi;
-
 	ret = pci_enable_msi(ha->pdev);
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha, "MSI: Enabled.\n"));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 46720b2..9c5c012 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -113,6 +113,15 @@ MODULE_PARM_DESC(ql2xetsenable,
 		"Enables firmware ETS burst."
 		"Default is 0 - skip ETS enablement.");
 
+int ql2xenablemsix = 1;
+module_param(ql2xenablemsix, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xenablemsix,
+                "Set to enable MSI or MSI-X interrupt mechanism."
+                " Default is 1, enable MSI-X interrupt mechanism."
+                " 0 = enable traditional pin-based mechanism."
+                " 1 = enable MSI-X interrupt mechanism."
+                " 2 = enable MSI interrupt mechanism.");
+
 /*
  * SCSI host template entry points
  */
-- 
1.6.6.2


