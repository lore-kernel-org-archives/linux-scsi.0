From: Brian King <brking@us.ibm.com>
Subject: [PATCH] Allow LLDs to modify disk r/w timeout
Date: Wed, 31 Mar 2004 22:25:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406B999E.2020803@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080202080707090604030404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:36046 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262175AbUDAEZH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 23:25:07 -0500
Received: from westrelay04.boulder.ibm.com (westrelay04.boulder.ibm.com [9.17.193.32])
	by e32.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i314P40Y649762
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 23:25:04 -0500
Received: from us.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i314P2jU090338
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 21:25:03 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080202080707090604030404
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is a patch that adds a rw_timeout field to the scsi_device 
struct which LLDs can setup in their slave_configure routines to 
override the read/write timeout used by sd. Various disk device types 
(i.e. RAID array devices) need longer timeout values than regular scsi 
disks, and this patch allows for this. This would get remove one of the 
reasons the ipr driver modifies the scsi timer today.

Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------080202080707090604030404
Content-Type: text/plain;
 name="sd_timeout_mod.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sd_timeout_mod.patch"


This patch adds a r/w timeout field to the scsi_device struct
to allow LLDs to modify the r/w timeout used by the scsi disk
driver. LLDs may setup this field in their slave_configure
routines if they require a different timeout to be used for
certain devices, such as RAID arrays.


---

 linux-2.6.5-rc3-bjking1/drivers/scsi/sd.c          |   11 ++++++++---
 linux-2.6.5-rc3-bjking1/include/scsi/scsi_device.h |    2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/sd.c~sd_timeout_mod drivers/scsi/sd.c
--- linux-2.6.5-rc3/drivers/scsi/sd.c~sd_timeout_mod	2004-03-31 19:55:51.000000000 -0600
+++ linux-2.6.5-rc3-bjking1/drivers/scsi/sd.c	2004-03-31 21:41:31.000000000 -0600
@@ -203,9 +203,7 @@ static int sd_init_command(struct scsi_c
 	sector_t block;
 	struct scsi_device *sdp = SCpnt->device;
 
-	timeout = SD_TIMEOUT;
-	if (SCpnt->device->type != TYPE_DISK)
-		timeout = SD_MOD_TIMEOUT;
+	timeout = sdp->rw_timeout;
 
 	/*
 	 * these are already setup, just copy cdb basically
@@ -1370,6 +1368,13 @@ static int sd_probe(struct device *dev)
 	sdkp->index = index;
 	sdkp->openers = 0;
 
+	if (!sdp->rw_timeout) {
+		if (sdp->type == TYPE_DISK)
+			sdp->rw_timeout = SD_TIMEOUT;
+		else
+			sdp->rw_timeout = SD_MOD_TIMEOUT;
+	}
+
 	devno = make_sd_dev(index, 0);
 	gd->major = MAJOR(devno);
 	gd->first_minor = MINOR(devno);
diff -puN include/scsi/scsi_device.h~sd_timeout_mod include/scsi/scsi_device.h
--- linux-2.6.5-rc3/include/scsi/scsi_device.h~sd_timeout_mod	2004-03-31 20:08:26.000000000 -0600
+++ linux-2.6.5-rc3-bjking1/include/scsi/scsi_device.h	2004-03-31 20:10:20.000000000 -0600
@@ -104,6 +104,8 @@ struct scsi_device {
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
+	int rw_timeout;
+
 	struct device		sdev_gendev;
 	struct class_device	sdev_classdev;
 

_

--------------080202080707090604030404--

