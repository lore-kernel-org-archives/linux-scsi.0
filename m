From: Rob Landley <rob@landley.net>
Subject: [PATCH 2/15] Update kerneldoc comments in drivers/scsi/scsicam.c
Date: Fri, 26 Oct 2007 23:08:49 -0500
Message-ID: <200710262308.49254.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47474
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750984AbXJ0DJE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:09:04 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id B6CA873938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:11:48 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsicam.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsicam.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff -r a868e8217782 drivers/scsi/scsicam.c
--- a/drivers/scsi/scsicam.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsicam.c	Fri Oct 26 22:44:43 2007 -0500
@@ -24,6 +24,14 @@ static int setsize(unsigned long capacit
 static int setsize(unsigned long capacity, unsigned int *cyls, unsigned int *hds,
 		   unsigned int *secs);
 
+/**
+ * scsi_bios_ptable - Read PC partition table out of first sector of device.
+ * @dev: from this device
+ *
+ * Description: Reads the first sector from the device and returns %0x42 bytes
+ *              starting at offset %0x1be.
+ * Returns: partition table in kmalloc(GFP_KERNEL) memory, or NULL on error.
+ */
 unsigned char *scsi_bios_ptable(struct block_device *dev)
 {
 	unsigned char *res = kmalloc(66, GFP_KERNEL);
@@ -43,15 +51,17 @@ unsigned char *scsi_bios_ptable(struct b
 }
 EXPORT_SYMBOL(scsi_bios_ptable);
 
-/*
- * Function : int scsicam_bios_param (struct block_device *bdev, ector_t capacity, int *ip)
- *
- * Purpose : to determine the BIOS mapping used for a drive in a 
+/**
+ * scsicam_bios_param - Determine geometry of a disk in cylinders/heads/sectors.
+ * @bdev: which device
+ * @capacity: size of the disk in sectors
+ * @ip: return value: ip[0]=heads, ip[1]=sectors, ip[2]=cylinders
+ *
+ * Description : determine the BIOS mapping/geometry used for a drive in a 
  *      SCSI-CAM system, storing the results in ip as required
  *      by the HDIO_GETGEO ioctl().
  *
  * Returns : -1 on failure, 0 on success.
- *
  */
 
 int scsicam_bios_param(struct block_device *bdev, sector_t capacity, int *ip)
@@ -98,15 +108,18 @@ int scsicam_bios_param(struct block_devi
 }
 EXPORT_SYMBOL(scsicam_bios_param);
 
-/*
- * Function : static int scsi_partsize(unsigned char *buf, unsigned long 
- *     capacity,unsigned int *cyls, unsigned int *hds, unsigned int *secs);
- *
- * Purpose : to determine the BIOS mapping used to create the partition
+/**
+ * scsi_partsize - Parse cylinders/heads/sectors from PC partition table
+ * @buf: partition table, see scsi_bios_ptable()
+ * @capacity: size of the disk in sectors
+ * @cyls: put cylinders here
+ * @hds: put heads here
+ * @secs: put sectors here
+ *
+ * Description: determine the BIOS mapping/geometry used to create the partition
  *      table, storing the results in *cyls, *hds, and *secs 
  *
- * Returns : -1 on failure, 0 on success.
- *
+ * Returns: -1 on failure, 0 on success.
  */
 
 int scsi_partsize(unsigned char *buf, unsigned long capacity,
@@ -194,7 +207,7 @@ EXPORT_SYMBOL(scsi_partsize);
  *
  * WORKING                                                    X3T9.2
  * DRAFT                                                        792D
- *
+ * see http://www.t10.org/ftp/t10/drafts/cam/cam-r12b.pdf
  *
  *                                                        Revision 6
  *                                                         10-MAR-94

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
