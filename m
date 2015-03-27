From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 4/5] megaraid_sas : Add release date and update driver
 version
Date: Fri, 27 Mar 2015 17:25:47 +0530
Message-ID: <201503271157.t2RBvI5F032301@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0092.outbound.protection.outlook.com ([157.56.110.92]:37525
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752719AbbC0MLd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 08:11:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will upgrade the driver version and add back the release date and sysfs hook for the same.
Some Avago's internal applications uses sysfs parameter of release date, so they were broken because of removal
of release date from sysfs.
 
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    3 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index e9a0820..680d90b 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -35,7 +35,8 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.806.08.00-rc1"
+#define MEGASAS_VERSION				"06.807.10.00-rc1"
+#define MEGASAS_RELDATE				"March 6, 2015"
 
 /*
  * Device IDs
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9a89047..7195f18 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6436,6 +6436,15 @@ static ssize_t megasas_sysfs_show_version(struct device_driver *dd, char *buf)
 static DRIVER_ATTR(version, S_IRUGO, megasas_sysfs_show_version, NULL);
 
 static ssize_t
+megasas_sysfs_show_release_date(struct device_driver *dd, char *buf)
+{
+	return snprintf(buf, strlen(MEGASAS_RELDATE) + 2, "%s\n",
+		MEGASAS_RELDATE);
+}
+
+static DRIVER_ATTR(release_date, S_IRUGO, megasas_sysfs_show_release_date, NULL);
+
+static ssize_t
 megasas_sysfs_show_support_poll_for_event(struct device_driver *dd, char *buf)
 {
 	return sprintf(buf, "%u\n", support_poll_for_event);
@@ -6775,6 +6784,11 @@ static int __init megasas_init(void)
 		goto err_dcf_attr_ver;
 
 	rval = driver_create_file(&megasas_pci_driver.driver,
+				  &driver_attr_release_date);
+	if (rval)
+		goto err_dcf_rel_date;
+
+	rval = driver_create_file(&megasas_pci_driver.driver,
 				&driver_attr_support_poll_for_event);
 	if (rval)
 		goto err_dcf_support_poll_for_event;
@@ -6797,6 +6811,9 @@ err_dcf_dbg_lvl:
 	driver_remove_file(&megasas_pci_driver.driver,
 			&driver_attr_support_poll_for_event);
 err_dcf_support_poll_for_event:
+	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_release_date);
+err_dcf_rel_date:
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 err_dcf_attr_ver:
 	pci_unregister_driver(&megasas_pci_driver);
@@ -6816,6 +6833,8 @@ static void __exit megasas_exit(void)
 			&driver_attr_support_poll_for_event);
 	driver_remove_file(&megasas_pci_driver.driver,
 			&driver_attr_support_device_change);
+	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 
 	pci_unregister_driver(&megasas_pci_driver);
-- 
1.7.1

