From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/5] aacraid:  expose physical devices
Date: Tue, 19 Sep 2006 08:59:43 -0700
Message-ID: <1158681583.2837.20.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:43426 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751782AbWISP7q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 11:59:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn:

I am placing this functionality into an insmod parameter. Normally the physical
components are exported to sg, and are blocked from showing up in sd.

Note that the pass-through I/O path via the driver through the Firmware to the
physical disks is not an optimized path, the card is designed for Hardware
RAID, elevator sorting and caching. This should not be used as a means for
utilizing the aacraid based controllers as a generic scsi/SATA/SAS controller,
performance should suck by a few percentage points, any RAID meta-data on the
drives will confuse the controller about who owns the drives and there is a
high risk of destroying content in both directions. Unreliable and for
experimentation or strange controlled circumstances only.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-09-12 09:49:31.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-09-12 09:49:40.000000000 -0700
@@ -169,6 +169,10 @@
 int acbsize = -1;
 module_param(acbsize, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(acbsize, "Request a specific adapter control block (FIB) size. Valid values are 512, 2048, 4096 and 8192. Default is to use suggestion from Firmware.");
+
+int expose_physicals = 0;
+module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(expose_physicals, "Expose physical components of the arrays. 0=off, 1=on");
 /**
  *	aac_get_config_status	-	check the adapter configuration
  *	@common: adapter to query
@@ -1535,7 +1539,7 @@
 				return 0;
 			}
 		} else {  /* check for physical non-dasd devices */
-			if(dev->nondasd_support == 1){
+			if ((dev->nondasd_support == 1) || expose_physicals) {
 				if (dev->in_reset)
 					return -1;
 				return aac_send_srb_fib(scsicmd);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-09-12 09:48:51.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-09-12 09:49:40.000000000 -0700
@@ -82,6 +82,8 @@
 static int aac_cfg_major = -1;
 char aac_driver_version[] = AAC_DRIVER_FULL_VERSION;
 
+extern int expose_physicals;
+
 /*
  * Because of the way Linux names scsi devices, the order in this table has
  * become important.  Check for on-board Raid first, add-in cards second.
@@ -394,6 +396,7 @@
 		sdev->skip_ms_page_3f = 1;
 	}
 	if ((sdev->type == TYPE_DISK) &&
+			!expose_physicals &&
 			(sdev_channel(sdev) != CONTAINER_CHANNEL)) {
 		struct aac_dev *aac = (struct aac_dev *)sdev->host->hostdata;
 		if (!aac->raid_scsi_mode || (sdev_channel(sdev) != 2))
@@ -928,7 +931,7 @@
 	 * all containers are on the virtual channel 0 (CONTAINER_CHANNEL)
 	 * physical channels are address by their actual physical number+1
 	 */
-	if (aac->nondasd_support == 1)
+	if ((aac->nondasd_support == 1) || expose_physicals)
 		shost->max_channel = aac->maximum_num_channels;
 	else
 		shost->max_channel = 0;

-- 
Mark Haverkamp <markh@osdl.org>

