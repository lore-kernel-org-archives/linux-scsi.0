From: Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] SCSI: remove DRIVER_ATTR() usage
Date: Wed, 19 Jul 2017 14:50:06 +0200
Message-ID: <20170719125006.GA17776@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Willem Riede <osst@riede.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

It's better to use the DRIVER_ATTR_RW() and DRIVER_ATTR_RO() macros to
explicitly show that this is a read/write or read/only sysfs file.  So
convert the remaining SCSI drivers that use the old style to use the
newer macros.

Bonus is that this removes some checkpatch.pl warnings :)

This is part of a series to drop DRIVER_ATTR() from the tree entirely.

Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Willem Riede <osst@riede.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/aic94xx/aic94xx_init.c       |    4 +--
 drivers/scsi/megaraid/megaraid_sas_base.c |   36 ++++++++++--------------------
 drivers/scsi/osst.c                       |    4 +--
 3 files changed, 16 insertions(+), 28 deletions(-)

--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -956,11 +956,11 @@ static int asd_scan_finished(struct Scsi
 	return 1;
 }
 
-static ssize_t asd_version_show(struct device_driver *driver, char *buf)
+static ssize_t version_show(struct device_driver *driver, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", ASD_DRIVER_VERSION);
 }
-static DRIVER_ATTR(version, S_IRUGO, asd_version_show, NULL);
+static DRIVER_ATTR_RO(version);
 
 static int asd_create_driver_attrs(struct device_driver *driver)
 {
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7323,49 +7323,39 @@ static struct pci_driver megasas_pci_dri
 /*
  * Sysfs driver attributes
  */
-static ssize_t megasas_sysfs_show_version(struct device_driver *dd, char *buf)
+static ssize_t version_show(struct device_driver *dd, char *buf)
 {
 	return snprintf(buf, strlen(MEGASAS_VERSION) + 2, "%s\n",
 			MEGASAS_VERSION);
 }
+static DRIVER_ATTR_RO(version);
 
-static DRIVER_ATTR(version, S_IRUGO, megasas_sysfs_show_version, NULL);
-
-static ssize_t
-megasas_sysfs_show_release_date(struct device_driver *dd, char *buf)
+static ssize_t release_date_show(struct device_driver *dd, char *buf)
 {
 	return snprintf(buf, strlen(MEGASAS_RELDATE) + 2, "%s\n",
 		MEGASAS_RELDATE);
 }
+static DRIVER_ATTR_RO(release_date);
 
-static DRIVER_ATTR(release_date, S_IRUGO, megasas_sysfs_show_release_date, NULL);
-
-static ssize_t
-megasas_sysfs_show_support_poll_for_event(struct device_driver *dd, char *buf)
+static ssize_t support_poll_for_event_show(struct device_driver *dd, char *buf)
 {
 	return sprintf(buf, "%u\n", support_poll_for_event);
 }
+static DRIVER_ATTR_RO(support_poll_for_event);
 
-static DRIVER_ATTR(support_poll_for_event, S_IRUGO,
-			megasas_sysfs_show_support_poll_for_event, NULL);
-
- static ssize_t
-megasas_sysfs_show_support_device_change(struct device_driver *dd, char *buf)
+static ssize_t support_device_change_show(struct device_driver *dd, char *buf)
 {
 	return sprintf(buf, "%u\n", support_device_change);
 }
+static DRIVER_ATTR_RO(support_device_change);
 
-static DRIVER_ATTR(support_device_change, S_IRUGO,
-			megasas_sysfs_show_support_device_change, NULL);
-
-static ssize_t
-megasas_sysfs_show_dbg_lvl(struct device_driver *dd, char *buf)
+static ssize_t dbg_lvl_show(struct device_driver *dd, char *buf)
 {
 	return sprintf(buf, "%u\n", megasas_dbg_lvl);
 }
 
-static ssize_t
-megasas_sysfs_set_dbg_lvl(struct device_driver *dd, const char *buf, size_t count)
+static ssize_t dbg_lvl_store(struct device_driver *dd, const char *buf,
+			     size_t count)
 {
 	int retval = count;
 
@@ -7375,9 +7365,7 @@ megasas_sysfs_set_dbg_lvl(struct device_
 	}
 	return retval;
 }
-
-static DRIVER_ATTR(dbg_lvl, S_IRUGO|S_IWUSR, megasas_sysfs_show_dbg_lvl,
-		megasas_sysfs_set_dbg_lvl);
+static DRIVER_ATTR_RW(dbg_lvl);
 
 static inline void megasas_remove_scsi_device(struct scsi_device *sdev)
 {
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5667,12 +5667,12 @@ static	struct	osst_support_data support_
  * sysfs support for osst driver parameter information
  */
 
-static ssize_t osst_version_show(struct device_driver *ddd, char *buf)
+static ssize_t version_show(struct device_driver *ddd, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", osst_version);
 }
 
-static DRIVER_ATTR(version, S_IRUGO, osst_version_show, NULL);
+static DRIVER_ATTR_RO(version);
 
 static int osst_create_sysfs_files(struct device_driver *sysfs)
 {
