From: bo yang <boyang1288@gmail.com>
Subject: [PATCH 2/5] scsi: megaraid_sas - support devices update flag
Date: Wed, 11 Aug 2010 16:54:30 -0400
Message-ID: <AANLkTinQAWYt-Pc0z-eG5dQpqvXkOGsK48rs=YFtyjWp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f66.google.com ([209.85.160.66]:43819 "EHLO
	mail-pw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191Ab0HKUyb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2010 16:54:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo.yang@lsi.com, James.Bottomley@HansenPartnership.com, James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

Driver added the Device update flag to tell LSI application driver
will do the device
Update.  LSI MegaRAID SAS application will check this flag to decide
if it is need to
update the Device or not.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c
new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-05-03 03:50:44.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-05-03 05:46:37.000000000 -0400
@@ -99,6 +99,7 @@ static int megasas_poll_wait_aen;
 static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
 static u32 support_poll_for_event;
 static u32 megasas_dbg_lvl;
+static u32 support_device_change;

 /* define lock for aen poll */
 spinlock_t poll_aen_lock;
@@ -4660,6 +4661,15 @@ megasas_sysfs_show_support_poll_for_even
 static DRIVER_ATTR(support_poll_for_event, S_IRUGO,
 			megasas_sysfs_show_support_poll_for_event, NULL);

+ static ssize_t
+megasas_sysfs_show_support_device_change(struct device_driver *dd, char *buf)
+{
+	return sprintf(buf, "%u\n", support_device_change);
+}
+
+static DRIVER_ATTR(support_device_change, S_IRUGO,
+			megasas_sysfs_show_support_device_change, NULL);
+
 static ssize_t
 megasas_sysfs_show_dbg_lvl(struct device_driver *dd, char *buf)
 {
@@ -4980,6 +4990,7 @@ static int __init megasas_init(void)
 	       MEGASAS_EXT_VERSION);

 	support_poll_for_event = 2;
+	support_device_change = 1;

 	memset(&megasas_mgmt_info, 0, sizeof(megasas_mgmt_info));

@@ -5028,8 +5039,17 @@ static int __init megasas_init(void)
 	if (rval)
 		goto err_dcf_poll_mode_io;

+	rval = driver_create_file(&megasas_pci_driver.driver,
+				&driver_attr_support_device_change);
+	if (rval)
+		goto err_dcf_support_device_change;
+
 	return rval;

+err_dcf_support_device_change:
+	driver_remove_file(&megasas_pci_driver.driver,
+		  &driver_attr_poll_mode_io);
+
 err_dcf_poll_mode_io:
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
@@ -5060,6 +5080,10 @@ static void __exit megasas_exit(void)
 	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_dbg_lvl);
 	driver_remove_file(&megasas_pci_driver.driver,
+			&driver_attr_support_poll_for_event);
+	driver_remove_file(&megasas_pci_driver.driver,
+			&driver_attr_support_device_change);
+	driver_remove_file(&megasas_pci_driver.driver,
 			   &driver_attr_release_date);
 	driver_remove_file(&megasas_pci_driver.driver, &driver_attr_version);
