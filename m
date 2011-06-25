From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] isci: add ABI documentation and fixup sysfs registration for
 'isci_id'
Date: Fri, 24 Jun 2011 17:25:11 -0700
Message-ID: <20110625000939.10572.28777.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:5073 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab1FYAZM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 20:25:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

Adding ABI update for adding isci_id entry scsi_host sysfs entry.
Also fixing up the sysfs registration to the scsi_host template

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

James,

This touches the tree outside our driver so I wanted to get an ack before
putting it in isci.git.

--
Dan

 Documentation/ABI/testing/sysfs-class-scsi_host |   13 ++++++++
 drivers/scsi/isci/init.c                        |   36 ++++++++++++-----------
 2 files changed, 31 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-scsi_host

diff --git a/Documentation/ABI/testing/sysfs-class-scsi_host b/Documentation/ABI/testing/sysfs-class-scsi_host
new file mode 100644
index 0000000..29a4f89
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-scsi_host
@@ -0,0 +1,13 @@
+What:		/sys/class/scsi_host/hostX/isci_id
+Date:		June 2011
+Contact:	Dave Jiang <dave.jiang@intel.com>
+Description:
+		This file contains the enumerated host ID for the Intel
+		SCU controller. The Intel(R) C600 Series Chipset SATA/SAS
+		Storage Control Unit embeds up to two 4-port controllers in
+		a single PCI device.  The controllers are enumerated in order
+		which usually means the lowest number scsi_host corresponds
+		with the first controller, but this association is not
+		guaranteed.  The 'isci_id' attribute unambiguously identifies
+		the controller index: '0' for the first controller,
+		'1' for the second.
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index bbfb6e5..1f03dbe 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -59,6 +59,7 @@
 #include <linux/firmware.h>
 #include <linux/efi.h>
 #include <asm/string.h>
+#include <scsi/scsi_host.h>
 #include "isci.h"
 #include "task.h"
 #include "probe_roms.h"
@@ -117,6 +118,22 @@ unsigned char max_concurr_spinup = 1;
 module_param(max_concurr_spinup, byte, 0);
 MODULE_PARM_DESC(max_concurr_spinup, "Max concurrent device spinup");
 
+static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = container_of(dev, typeof(*shost), shost_dev);
+	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+	struct isci_host *ihost = container_of(sas_ha, typeof(*ihost), sas_ha);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
+}
+
+static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
+
+struct device_attribute *isci_host_attrs[] = {
+	&dev_attr_isci_id,
+	NULL
+};
+
 static struct scsi_host_template isci_sht = {
 
 	.module				= THIS_MODULE,
@@ -142,6 +159,7 @@ static struct scsi_host_template isci_sht = {
 	.slave_alloc			= sas_slave_alloc,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
+	.shost_attrs			= isci_host_attrs,
 };
 
 static struct sas_domain_function_template isci_transport_ops  = {
@@ -236,17 +254,6 @@ static int isci_register_sas_ha(struct isci_host *isci_host)
 	return 0;
 }
 
-static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct Scsi_Host *shost = container_of(dev, typeof(*shost), shost_dev);
-	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
-	struct isci_host *ihost = container_of(sas_ha, typeof(*ihost), sas_ha);
-
-	return snprintf(buf, PAGE_SIZE, "%d\n", ihost->id);
-}
-
-static DEVICE_ATTR(isci_id, S_IRUGO, isci_show_id, NULL);
-
 static void isci_unregister(struct isci_host *isci_host)
 {
 	struct Scsi_Host *shost;
@@ -255,7 +262,6 @@ static void isci_unregister(struct isci_host *isci_host)
 		return;
 
 	shost = isci_host->shost;
-	device_remove_file(&shost->shost_dev, &dev_attr_isci_id);
 
 	sas_unregister_ha(&isci_host->sas_ha);
 
@@ -419,14 +425,8 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 	if (err)
 		goto err_shost_remove;
 
-	err = device_create_file(&shost->shost_dev, &dev_attr_isci_id);
-	if (err)
-		goto err_unregister_ha;
-
 	return isci_host;
 
- err_unregister_ha:
-	sas_unregister_ha(&(isci_host->sas_ha));
  err_shost_remove:
 	scsi_remove_host(shost);
  err_shost:

