From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 17/18] isci: implement suspend/resume support
Date: Sat, 10 Mar 2012 23:29:11 -0800
Message-ID: <20120311072911.6320.68362.stgit@dwillia2-linux.jf.intel.com>
References: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2CKHNy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2012 03:13:54 -0400
In-Reply-To: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Artur Wojcik <artur.wojcik@intel.com>, Jacek Danecki <jacek.danecki@intel.com>

From: Artur Wojcik <artur.wojcik@intel.com>

Provide a "simple-dev-pm-ops" implementation that shuts down the domain
and the device on suspend, and resumes the device and the domain on
resume.  All of the mechanics of restoring domain connectivity are
handled by libsas once isci has notified libsas that all links should be
back up.  libsas is in charge of handling links that did not resume, or
resumed out of order.

Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c |    2 +-
 drivers/scsi/isci/host.h |    2 +-
 drivers/scsi/isci/init.c |   58 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 5832b13..2bafb55 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1044,7 +1044,7 @@ static enum sci_status sci_controller_start(struct isci_host *ihost,
 	return SCI_SUCCESS;
 }
 
-void isci_host_scan_start(struct Scsi_Host *shost)
+void isci_host_start(struct Scsi_Host *shost)
 {
 	struct isci_host *ihost = SHOST_TO_SAS_HA(shost)->lldd_ha;
 	unsigned long tmo = sci_controller_get_suggested_start_timeout(ihost);
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 7272a0a..bcd556f 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -470,7 +470,7 @@ void sci_controller_remote_device_stopped(struct isci_host *ihost,
 
 enum sci_status sci_controller_continue_io(struct isci_request *ireq);
 int isci_host_scan_finished(struct Scsi_Host *, unsigned long);
-void isci_host_scan_start(struct Scsi_Host *);
+void isci_host_start(struct Scsi_Host *);
 u16 isci_alloc_tag(struct isci_host *ihost);
 enum sci_status isci_free_tag(struct isci_host *ihost, u16 io_tag);
 void isci_tci_free(struct isci_host *ihost, u16 tci);
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index fdae42f..acf75c2 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -156,7 +156,7 @@ static struct scsi_host_template isci_sht = {
 	.target_alloc			= sas_target_alloc,
 	.slave_configure		= sas_slave_configure,
 	.scan_finished			= isci_host_scan_finished,
-	.scan_start			= isci_host_scan_start,
+	.scan_start			= isci_host_start,
 	.change_queue_depth		= sas_change_queue_depth,
 	.change_queue_type		= sas_change_queue_type,
 	.bios_param			= sas_bios_param,
@@ -722,11 +722,67 @@ static void __devexit isci_pci_remove(struct pci_dev *pdev)
 	}
 }
 
+#ifdef CONFIG_PM
+static int isci_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct isci_host *ihost;
+	int i;
+
+	for_each_isci_host(i, ihost, pdev) {
+		sas_suspend_ha(&ihost->sas_ha);
+		isci_host_deinit(ihost);
+	}
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	return 0;
+}
+
+static int isci_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct isci_host *ihost;
+	int rc, i;
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+
+	rc = pcim_enable_device(pdev);
+	if (rc) {
+		dev_err(&pdev->dev,
+			"enabling device failure after resume(%d)\n", rc);
+		return rc;
+	}
+
+	pci_set_master(pdev);
+
+	for_each_isci_host(i, ihost, pdev) {
+		sas_prep_resume_ha(&ihost->sas_ha);
+
+		isci_host_init(ihost);
+		isci_host_start(to_shost(ihost));
+		wait_for_start(ihost);
+
+		sas_resume_ha(&ihost->sas_ha);
+	}
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(isci_pm_ops, isci_suspend, isci_resume);
+#endif
+
 static struct pci_driver isci_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= isci_id_table,
 	.probe		= isci_pci_probe,
 	.remove		= __devexit_p(isci_pci_remove),
+#ifdef CONFIG_PM
+	.driver.pm      = &isci_pm_ops,
+#endif
 };
 
 static __init int isci_init(void)

