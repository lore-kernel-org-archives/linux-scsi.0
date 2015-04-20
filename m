From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 8/18] megaraid_sas : Add release date and update
 driver version
Date: Mon, 20 Apr 2015 18:03:40 +0530
Message-ID: <201504201235.t3KCZqwd016586@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:32864
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753070AbbDTPdK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 11:33:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch will upgrade the driver version and add back the release date and sysfs hook for the same.
Some internal applications uses sysfs parameter for release date, so they were broken because of removal
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
index 3970780..6c84f88 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6437,6 +6437,15 @@ static ssize_t megasas_sysfs_show_version(struct device_driver *dd, char *buf)
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
@@ -6776,6 +6785,11 @@ static int __init megasas_init(void)
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
@@ -6798,6 +6812,9 @@ err_dcf_dbg_lvl:
 	driver_remove_file(&megasas_pci_driver.driver,
 			&driver_attr_support_poll_for_event);
 err_dcf_support_poll_for_event:
+	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_release_date);
+err_dcf_rel_date:
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 err_dcf_attr_ver:
 	pci_unregister_driver(&megasas_pci_driver);
@@ -6817,6 +6834,8 @@ static void __exit megasas_exit(void)
 			&driver_attr_support_poll_for_event);
 	driver_remove_file(&megasas_pci_driver.driver,
 			&driver_attr_support_device_change);
+	driver_remove_file(&megasas_pci_driver.driver,
+			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
 
 	pci_unregister_driver(&megasas_pci_driver);
-- 
1.7.1

