From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] don't increment use count twice on open
Date: Fri, 1 Nov 2002 03:52:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021101035238.A23109@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Since 2.4 drivers get their usecount managed by higher levels if they
supply a owner field in block_device_operations/file_operations.

Remove managment of the additional usecount in ->open/->close.


--- 1.17/drivers/scsi/osst.c	Thu Oct 17 13:52:39 2002
+++ edited/drivers/scsi/osst.c	Thu Oct 31 00:50:21 2002
@@ -4178,8 +4178,6 @@
 
 	if (STp->device->host->hostt->module)
 		 __MOD_INC_USE_COUNT(STp->device->host->hostt->module);
-	if (osst_template.module)
-		 __MOD_INC_USE_COUNT(osst_template.module);
 	STp->device->access_count++;
 
 	if (mode != STp->current_mode) {
@@ -4522,8 +4520,6 @@
 
 	if (STp->device->host->hostt->module)
 	    __MOD_DEC_USE_COUNT(STp->device->host->hostt->module);
-	if (osst_template.module)
-	    __MOD_DEC_USE_COUNT(osst_template.module);
 
 	return retval;
 }
@@ -4667,8 +4663,6 @@
 
 	if (STp->device->host->hostt->module)
 		__MOD_DEC_USE_COUNT(STp->device->host->hostt->module);
-	if(osst_template.module)
-		__MOD_DEC_USE_COUNT(osst_template.module);
 
 	return result;
 }
--- 1.84/drivers/scsi/sd.c	Tue Oct 29 23:22:34 2002
+++ edited/drivers/scsi/sd.c	Thu Oct 31 00:50:21 2002
@@ -452,8 +452,6 @@
 	 */
 	if (sdp->host->hostt->module)
 		__MOD_INC_USE_COUNT(sdp->host->hostt->module);
-	if (sd_template.module)
-		__MOD_INC_USE_COUNT(sd_template.module);
 	sdp->access_count++;
 
 	if (sdp->removable) {
@@ -497,8 +495,6 @@
 	sdp->access_count--;
 	if (sdp->host->hostt->module)
 		__MOD_DEC_USE_COUNT(sdp->host->hostt->module);
-	if (sd_template.module)
-		__MOD_DEC_USE_COUNT(sd_template.module);
 	return retval;	
 }
 
@@ -535,9 +531,6 @@
 	}
 	if (sdp->host->hostt->module)
 		__MOD_DEC_USE_COUNT(sdp->host->hostt->module);
-	if (sd_template.module)
-		__MOD_DEC_USE_COUNT(sd_template.module);
-
 	return 0;
 }
 
--- 1.59/drivers/scsi/sr.c	Mon Oct 28 14:06:43 2002
+++ edited/drivers/scsi/sr.c	Thu Oct 31 00:50:21 2002
@@ -105,8 +105,6 @@
 	cd->device->access_count--;
 	if (cd->device->host->hostt->module)
 		__MOD_DEC_USE_COUNT(cd->device->host->hostt->module);
-	if (sr_template.module)
-		__MOD_DEC_USE_COUNT(sr_template.module);
 }
 
 static struct cdrom_device_ops sr_dops = {
@@ -443,8 +441,6 @@
 	cd->device->access_count++;
 	if (cd->device->host->hostt->module)
 		__MOD_INC_USE_COUNT(cd->device->host->hostt->module);
-	if (sr_template.module)
-		__MOD_INC_USE_COUNT(sr_template.module);
 
 	/* If this device did not have media in the drive at boot time, then
 	 * we would have been unable to get the sector size.  Check to see if
