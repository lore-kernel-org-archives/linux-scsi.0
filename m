From: Michael Tokarev <mjt@tls.msk.ru>
Subject: modalias for scsi devices?
Date: Fri, 27 Oct 2006 16:02:37 +0400
Message-ID: <4541F55D.8040900@tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040306090806040600080207"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:61265 "EHLO hobbit.corpit.ru")
	by vger.kernel.org with ESMTP id S1946440AbWJ0MCq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Oct 2006 08:02:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------040306090806040600080207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Currently, scsi device modules (sd_mod, sr_mod, st, ch)
are the only commonly used modules which requires special
handling.  For the rest of (commonly used) devices, there's
modalias file in sysfs and $MODALIAS env. variable at
hotplug time.  (Well, there are other cases still, but
those are rare and mostly legacy stuff - such as ISA-PnP
devices etc - on such systems static configuration in
a means of /etc/modules or similar will do the trick
just fine).  Since not-so-recently already IDE modules -
another very commonly used kind - become "modalias-aware",
so to say.

I implemented a patch enabling scsi modules autoloading
without special handling for 2.6.17 -- modalias contains
scsi:type-0x04 for WORMs for example, and sd_mod has
scsi:type-0x04* alias string.  Very simple patch, I
posted it to lkml.

But at that time, someone replied telling me he's implementing
this functionality in a more general way.

The problem with my (simplistic?) approach was with
st vs osst modules - in "new world" as I did it both
will be loading for all tapes, but only one will take
care of the given device.  It can be worked around
later as well, by including, say, vendor information
into modalias string, like scsi:type-0:vendor-ADAPTEC
or something like that, and after this, os/osst dilemma
will be solved.  But in any way, I don't see a problem
with trying both modules this way.

The original patch as I did for 2.6.17 still applies
cleanly against 2.6.18 and current 2.6.19-tobe tree
(with some offsets).  It's attached to this email for
consideration.

Thanks.

/mjt

--------------040306090806040600080207
Content-Type: text/x-patch;
 name="scsi-modalias.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi-modalias.patch"

From: Michael Tokarev <mjt@tls.msk.ru>
To: Linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus-SCSI <linux-scsi@vger.kernel.org>
Subject: [RFC] MODALIAS support for SCSI devices (try 1)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="scsi-modalias-1.patch"

The following patch adds support for sysfs/uevent modalias
attribute for scsi devices (like disks, tapes, cdroms etc),
based on whatever current sd.c, sr.c, st.c and osst.c drivers
supports.

The modalias format is like this:

 scsi:type-0x04

(for TYPE_WORM, handled by sr.c now).

Several comments.

o This hexadecimal type value is because all TYPE_XXX constants
  in include/scsi/scsi.h are given in hex, but __stringify() will
  not convert them to decimal (so it will NOT be scsi:type-4).
  Since it does not really matter in which format it is, while
  both modalias in module and modalias attribute match each other,
  I descided to go for that 0x%02x format (and added a comment in
  include/scsi/scsi.h to keep them that way), instead of changing
  them all to decimal.

o There was no .uevent routine for SCSI bus.  It might be a good
  idea to add some more ueven environment variables in there.

o osst.c driver handles tapes too, like st.c, but only SOME tapes.
  With this setup, hotplug scripts (or whatever is used by the
  user) will try to load both st and osst modules for all SCSI
  tapes found, because both modules have scsi:type-0x01 alias).
  It is not harmful, but one extra module is no good either.
  It is possible to solve this, by exporting more info in
  modalias attribute, including vendor and device identification
  strings, so that modalias becomes something like
    scsi:type-0x12:vendor-Adaptec LTD:device-OnStream Tape Drive
  and having that, match for all 3 attributes, not only device
  type.  But oh well, vendor and device strings may be large,
  and they do contain spaces and whatnot.
  So I left them for now, awaiting for comments first.

The patch is against 2.6.17, but should apply to more recent
versions as well.

And oh, almost forget:

Signed-Off-By: Michael Tokarev <mjt@tls.msk.ru>

Thanks.

--- linux-2.6.17.orig/drivers/scsi/osst.c	2006-06-18 05:49:35.000000000 +0400
+++ linux-2.6.17/drivers/scsi/osst.c	2006-07-04 22:59:18.000000000 +0400
@@ -87,6 +87,7 @@ MODULE_AUTHOR("Willem Riede");
 MODULE_DESCRIPTION("OnStream {DI-|FW-|SC-|USB}{30|50} Tape Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(OSST_MAJOR);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_TAPE);
 
 module_param(max_dev, int, 0444);
 MODULE_PARM_DESC(max_dev, "Maximum number of OnStream Tape Drives to attach (4)");
--- linux-2.6.17.orig/drivers/scsi/scsi_sysfs.c	2006-06-18 05:49:35.000000000 +0400
+++ linux-2.6.17/drivers/scsi/scsi_sysfs.c	2006-07-05 00:16:17.000000000 +0400
@@ -275,6 +275,19 @@ static int scsi_bus_match(struct device 
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
 }
 
+static int scsi_bus_uevent(struct device *dev, char **envp, int num_envp,
+		           char *buffer, int buffer_size)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int i = 0;
+	int length = 0;
+
+	add_uevent_var(envp, num_envp, &i, buffer, buffer_size, &length,
+		       "MODALIAS=" SCSI_DEVICE_MODALIAS_FMT, sdev->type);
+	envp[i] = NULL;
+	return 0;
+}
+
 static int scsi_bus_suspend(struct device * dev, pm_message_t state)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
@@ -307,6 +320,7 @@ static int scsi_bus_resume(struct device
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
+	.uevent		= scsi_bus_uevent,
 	.suspend	= scsi_bus_suspend,
 	.resume		= scsi_bus_resume,
 };
@@ -534,6 +548,14 @@ show_sdev_iostat(iorequest_cnt);
 show_sdev_iostat(iodone_cnt);
 show_sdev_iostat(ioerr_cnt);
 
+static ssize_t
+sdev_show_modalias(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf (buf, 20, SCSI_DEVICE_MODALIAS_FMT "\n", sdev->type);
+}
+static DEVICE_ATTR(modalias, S_IRUGO, sdev_show_modalias, NULL);
 
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
@@ -553,6 +575,7 @@ static struct device_attribute *scsi_sys
 	&dev_attr_iorequest_cnt,
 	&dev_attr_iodone_cnt,
 	&dev_attr_ioerr_cnt,
+	&dev_attr_modalias,
 	NULL
 };
 
--- linux-2.6.17.orig/drivers/scsi/sd.c	2006-06-18 05:49:35.000000000 +0400
+++ linux-2.6.17/drivers/scsi/sd.c	2006-07-04 22:53:29.000000000 +0400
@@ -90,6 +90,9 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK12_
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK13_MAJOR);
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK14_MAJOR);
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
 /*
  * This is limited by the naming scheme enforced in sd_probe,
--- linux-2.6.17.orig/drivers/scsi/sr.c	2006-06-18 05:49:35.000000000 +0400
+++ linux-2.6.17/drivers/scsi/sr.c	2006-07-04 22:54:49.000000000 +0400
@@ -63,6 +63,8 @@
 MODULE_DESCRIPTION("SCSI cdrom (sr) driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_CDROM_MAJOR);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_ROM);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_WORM);
 
 #define SR_DISKS	256
 
--- linux-2.6.17.orig/drivers/scsi/st.c	2006-06-18 05:49:35.000000000 +0400
+++ linux-2.6.17/drivers/scsi/st.c	2006-07-04 22:56:02.000000000 +0400
@@ -89,6 +89,7 @@ MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI tape (st) driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_CHARDEV_MAJOR(SCSI_TAPE_MAJOR);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_TAPE);
 
 /* Set 'perm' (4th argument) to 0 to disable module_param's definition
  * of sysfs parameters (which module_param doesn't yet support).
--- linux-2.6.17.orig/include/scsi/scsi_device.h	2006-06-18 05:49:35.000000000 +0400
+++ linux-2.6.17/include/scsi/scsi_device.h	2006-07-05 00:16:40.000000000 +0400
@@ -352,4 +352,9 @@ static inline int scsi_device_qas(struct
 		return 0;
 	return sdev->inquiry[56] & 0x02;
 }
+
+#define MODULE_ALIAS_SCSI_DEVICE(type) \
+	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
+#define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"
+
 #endif /* _SCSI_SCSI_DEVICE_H */
--- linux-2.6.17.orig/include/scsi/scsi.h	2006-06-18 05:49:35.000000000 +0400
+++ linux-2.6.17/include/scsi/scsi.h	2006-07-04 22:35:53.000000000 +0400
@@ -207,6 +207,7 @@ static inline int scsi_status_is_good(in
 
 /*
  *  DEVICE TYPES
+ *  Please keep them in 0x%02x format for $MODALIAS to work
  */
 
 #define TYPE_DISK           0x00

--------------040306090806040600080207--
