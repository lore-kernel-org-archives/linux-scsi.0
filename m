From: David Brownell <david-b@pacbell.net>
Subject: [patch 2.6.21-rc4-git] SCSI newstyle hotplug/coldplug support
Date: Tue, 20 Mar 2007 17:36:09 -0700
Message-ID: <200703201736.09280.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S934084AbXCTXgO@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This teaches scsi devices how to support "new style" hotplug/coldplug:
using a modalias sysfs attribute for coldplug, and MODALIAS environment
variable for hotplug.

It also updates the CH, SD, SR, and ST drivers with the aliases needed to
drive them by that mechanism.  (Older OnStream devices use OSST not ST;
left for someone else to sort out.  SG seems best loaded by KMOD.)

Using this, I've seen pure new-style hotplugging drive the loading of all
the relevant driver modules for usb storage devices:  host controller,
usb-storage, scsi core, sd_mod.  Previously, sd_mod never loaded.  (Except
when using the obsolete old-style hotplug scripts ... which are unusable
on ~100 BogoMIPS embedded systems that only run busybox, but may have no
options for lots of external storage other than USB.)  Yep, this is a LOT
faster too.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/scsi/ch.c         |    1 +
 drivers/scsi/scsi_sysfs.c |   24 ++++++++++++++++++++++++
 drivers/scsi/sd.c         |    4 ++++
 drivers/scsi/sr.c         |    2 ++
 drivers/scsi/st.c         |    1 +
 5 files changed, 32 insertions(+)

--- g26.orig/drivers/scsi/scsi_sysfs.c	2007-03-16 12:54:22.000000000 -0700
+++ g26/drivers/scsi/scsi_sysfs.c	2007-03-20 17:27:07.000000000 -0700
@@ -276,6 +276,18 @@ static int scsi_bus_match(struct device 
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
 }
 
+/* for hotplug support: modprobe $MODALIAS */
+static int scsi_uevent(struct device *dev, char **envp, int num_envp,
+		char *buffer, int buffer_size)
+{
+	struct scsi_device *sdp = to_scsi_device(dev);
+
+	envp[0] = buffer;
+	snprintf(buffer, buffer_size, "MODALIAS=scsi:type-%02x", (u8)sdp->type);
+	envp[1] = NULL;
+	return 0;
+}
+
 static int scsi_bus_suspend(struct device * dev, pm_message_t state)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -308,6 +320,7 @@ static int scsi_bus_resume(struct device
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
+	.uevent		= scsi_uevent,
 	.suspend	= scsi_bus_suspend,
 	.resume		= scsi_bus_resume,
 };
@@ -547,6 +560,16 @@ show_sdev_iostat(iorequest_cnt);
 show_sdev_iostat(iodone_cnt);
 show_sdev_iostat(ioerr_cnt);
 
+/* for coldplug support: modprobe $(cat .../modalias) */
+static ssize_t
+show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return snprintf(buf, 20, "scsi:type-%02x\n", (u8)sdev->type);
+}
+static DEVICE_ATTR(modalias, S_IRUGO, show_modalias, NULL);
+
 
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
@@ -566,6 +589,7 @@ static struct device_attribute *scsi_sys
 	&dev_attr_iorequest_cnt,
 	&dev_attr_iodone_cnt,
 	&dev_attr_ioerr_cnt,
+	&dev_attr_modalias,
 	NULL
 };
 
--- g26.orig/drivers/scsi/sd.c	2007-02-19 13:43:00.000000000 -0800
+++ g26/drivers/scsi/sd.c	2007-03-20 17:27:07.000000000 -0700
@@ -89,6 +89,10 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK13_
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK14_MAJOR);
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
 
+MODULE_ALIAS("scsi:type-00");		/* TYPE_DISK */
+MODULE_ALIAS("scsi:type-07");		/* TYPE_MOD */
+MODULE_ALIAS("scsi:type-0e");		/* TYPE_RBC */
+
 /*
  * This is limited by the naming scheme enforced in sd_probe,
  * add another character to it if you really need more disks.
--- g26.orig/drivers/scsi/sr.c	2007-02-15 18:17:21.000000000 -0800
+++ g26/drivers/scsi/sr.c	2007-03-20 17:27:07.000000000 -0700
@@ -62,6 +62,8 @@
 MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR);
+MODULE_ALIAS("scsi:type-04");		/* TYPE_WORM */
+MODULE_ALIAS("scsi:type-05");		/* TYPE_ROM */
 
 #define SR_DISKS	256
 
--- g26.orig/drivers/scsi/st.c	2007-02-19 22:14:16.000000000 -0800
+++ g26/drivers/scsi/st.c	2007-03-20 17:27:07.000000000 -0700
@@ -89,6 +89,7 @@ MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI tape (st) driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_TAPE_MAJOR);
+MODULE_ALIAS("scsi:type-01");		/* TYPE_TAPE */
 
 /* Set 'perm' (4th argument) to 0 to disable module_param's definition
  * of sysfs parameters (which module_param doesn't yet support).
--- g26.orig/drivers/scsi/ch.c	2007-02-15 18:17:21.000000000 -0800
+++ g26/drivers/scsi/ch.c	2007-03-20 17:27:07.000000000 -0700
@@ -38,6 +38,7 @@ MODULE_DESCRIPTION("device driver for sc
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org>");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_CHANGER_MAJOR);
+MODULE_ALIAS("scsi:type-08");		/* TYPE_MEDIUM_CHANGER */
 
 static int init = 1;
 module_param(init, int, 0444);
