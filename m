From: Jeremy Higdon <jeremy@sgi.com>
Subject: [RFC & PATCH 2.6.9-rc1] Add Blacklist for RAID configuration luns
Date: Mon, 13 Sep 2004 23:32:37 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914063237.GA97486@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:59854 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S269156AbUINGcv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 02:32:51 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@suse.de

Engenio RAIDs have special luns that are used for configuring the RAID.
These luns have a device type of 0 (disk), but do not adhere to
standard disk semantics.  To avoid having to parse potentially dozens
of error messages during initialization, it's good to avoid attaching
these devices to sd.  This can be done by changing the device type
to RAID (0xC).

This is somewhat messy, because the device doesn't actually adhere
to the SCSI Controller Commands specification.  An alternative would
be to access the blacklist flags from sd_probe and look for BLIST_ISRAID
there.

One can imagine several other options.  If this one is acceptable, I
think it gives the clearest output to the user (who isn't aware of
the distinction between a RAID controller that implements the SCC
command set), but I'm willing to be swayed by arguments of architectural
purity  :-)

Note that in the part of the patch that adds the blacklist entry, I
would expect several different vendor IDs to be added . . . .

signed-off-by: Jeremy Higdon <jeremy@sgi.com>

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/09/13 23:00:11-07:00 jeremy@tomahawk.engr.sgi.com 
#   Add SCSI blacklist for RAID and LSI/Engenio UTM lun
# 
# include/scsi/scsi_devinfo.h
#   2004/09/13 23:00:01-07:00 jeremy@tomahawk.engr.sgi.com +1 -0
#   Add SCSI blacklist for RAID and LSI UTM lun
# 
# drivers/scsi/scsi_scan.c
#   2004/09/13 23:00:01-07:00 jeremy@tomahawk.engr.sgi.com +9 -0
#   Add SCSI blacklist for RAID and LSI UTM lun
# 
# drivers/scsi/scsi_devinfo.c
#   2004/09/13 23:00:00-07:00 jeremy@tomahawk.engr.sgi.com +1 -0
#   Add SCSI blacklist for RAID and LSI UTM lun
# 
diff -Nru a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	2004-09-13 23:01:40 -07:00
+++ b/drivers/scsi/scsi_devinfo.c	2004-09-13 23:01:40 -07:00
@@ -182,6 +182,7 @@
 	{"SGI", "RAID3", "*", BLIST_SPARSELUN},
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
+	{"SGI", "Universal Xport", "*", BLIST_ISRAID},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	2004-09-13 23:01:41 -07:00
+++ b/drivers/scsi/scsi_scan.c	2004-09-13 23:01:41 -07:00
@@ -532,6 +532,14 @@
 		inq_result[0] = TYPE_ROM;
 		inq_result[1] |= 0x80;	/* removable */
 	}
+	else if (*bflags & BLIST_ISRAID) {
+		/*
+		 * Some devices that identify themselves as disks are really
+		 * special RAID configuration devices, and should not be
+		 * attached to sd.
+		 */
+		inq_result[0] = (inq_result[0] & 0xE0) | TYPE_RAID;
+	}
 
 	switch (sdev->type = (inq_result[0] & 0x1f)) {
 	case TYPE_TAPE:
@@ -543,6 +551,7 @@
 	case TYPE_MEDIUM_CHANGER:
 	case TYPE_ENCLOSURE:
 	case TYPE_COMM:
+	case TYPE_RAID:
 		sdev->writeable = 1;
 		break;
 	case TYPE_WORM:
diff -Nru a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
--- a/include/scsi/scsi_devinfo.h	2004-09-13 23:01:40 -07:00
+++ b/include/scsi/scsi_devinfo.h	2004-09-13 23:01:40 -07:00
@@ -25,4 +25,5 @@
  					   (if HBA supports more than 8 LUNs) */
 #define BLIST_NOREPORTLUN	0x40000	/* don't try REPORT_LUNS scan (SCSI-3 devs) */
 #define BLIST_NOT_LOCKABLE	0x80000	/* don't use PREVENT-ALLOW commands */
+#define BLIST_ISRAID		0x100000 /* device is actually for RAID config */
 #endif
