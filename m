From: Jeremy Higdon <jeremy@sgi.com>
Subject: [RFC] [PATCH 2.6.9-rc1] add blacklist attribute indicating no ULD attach
Date: Tue, 14 Sep 2004 20:18:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040915031834.GA102988@sgi.com>
References: <20040914063237.GA97486@sgi.com> <20040914144023.GA9524@beaverton.ibm.com> <20040914182203.GA100433@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:31918 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S266910AbUIODTk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 23:19:40 -0400
Content-Disposition: inline
In-Reply-To: <20040914182203.GA100433@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: patmans@us.ibm.com, axboe@suse.de, james.bottomley@steeleye.com

After an IRC chat with jejb, I have a new patch to proffer.

This one takes a different tack that is cleaner (thanks James).


# This is a BitKeeper generated diff -Nru style patch.
# 
# ChangeSet
#   2004/09/14 19:48:01-07:00 jeremy@tomahawk.engr.sgi.com 
#   Add new SCSI blacklist attribute to indicate that a lun should not be
#   attached to an upper level driver, and use that attribute for UTM luns
#   for SGI branded LSI/Engenio RAIDs.
# 
# include/scsi/scsi_devinfo.h
#   2004/09/14 19:47:51-07:00 jeremy@tomahawk.engr.sgi.com +1 -1
#   Add BLIST_NO_ULD_ATTACH blacklist attribute.
# 
# include/scsi/scsi_device.h
#   2004/09/14 19:47:51-07:00 jeremy@tomahawk.engr.sgi.com +1 -0
#   Add no_uld_attach flag to struct scsi_device.
# 
# drivers/scsi/scsi_sysfs.c
#   2004/09/14 19:47:51-07:00 jeremy@tomahawk.engr.sgi.com +2 -0
#   If no_uld_attach flag is set, force "mismatch" result to scsi_bus_match().
# 
# drivers/scsi/scsi_scan.c
#   2004/09/14 19:47:51-07:00 jeremy@tomahawk.engr.sgi.com +2 -7
#   Set no_uld_attach flag for lun if indicated.
# 
# drivers/scsi/scsi_devinfo.c
#   2004/09/14 19:47:51-07:00 jeremy@tomahawk.engr.sgi.com +1 -1
#   Add UTM luns for SGI branded LSI/Engenio RAIDs to blacklist for no ULD attach.
# 
diff -Nru a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	2004-09-14 19:58:52 -07:00
+++ b/drivers/scsi/scsi_devinfo.c	2004-09-14 19:58:52 -07:00
@@ -182,6 +182,7 @@
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
+	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2004-09-14 19:58:52 -07:00
+++ b/drivers/scsi/scsi_scan.c	2004-09-14 19:58:52 -07:00
@@ -532,6 +532,9 @@
 		inq_result[0] = TYPE_ROM;
 		inq_result[1] |= 0x80;	/* removable */
 	}
+	else if (*bflags & BLIST_NO_ULD_ATTACH) {
+		sdev->no_uld_attach = 1;
+	}
 
 	switch (sdev->type = (inq_result[0] & 0x1f)) {
 	case TYPE_TAPE:
diff -Nru a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	2004-09-14 19:58:52 -07:00
+++ b/drivers/scsi/scsi_sysfs.c	2004-09-14 19:58:52 -07:00
@@ -183,6 +183,8 @@
 static int scsi_bus_match(struct device *dev, struct device_driver *gendrv)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
+	if (sdp->no_uld_attach)
+		return 0;
 	return (sdp->inq_periph_qual == SCSI_INQ_PQ_CON)? 1: 0;
 }
 
diff -Nru a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h	2004-09-14 19:58:52 -07:00
+++ b/include/scsi/scsi_device.h	2004-09-14 19:58:52 -07:00
@@ -106,6 +106,7 @@
 	unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */
 	unsigned no_start_on_add:1;	/* do not issue start on add */
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
+	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 
 	unsigned int device_blocked;	/* Device returned QUEUE_FULL. */
 
diff -Nru a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
--- a/include/scsi/scsi_devinfo.h	2004-09-14 19:58:52 -07:00
+++ b/include/scsi/scsi_devinfo.h	2004-09-14 19:58:52 -07:00
@@ -25,4 +25,5 @@
  					   (if HBA supports more than 8 LUNs) */
 #define BLIST_NOREPORTLUN	0x40000	/* don't try REPORT_LUNS scan (SCSI-3 devs) */
 #define BLIST_NOT_LOCKABLE	0x80000	/* don't use PREVENT-ALLOW commands */
+#define BLIST_NO_ULD_ATTACH	0x100000 /* device is actually for RAID config */
 #endif
