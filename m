From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 1/7] libata: check for AN support
Date: Mon, 11 Jun 2007 13:20:38 -0700
Message-ID: <20070611132038.cca35aec.kristen.c.accardi@intel.com>
References: <20070510072247.063476979@intel.com>
	<20070509163809.7b0b3fde.kristen.c.accardi@intel.com>
	<20070509220952.5fa34822.akpm@linux-foundation.org>
	<20070510100215.94c3a2ea.kristen.c.accardi@intel.com>
	<465654EC.9080805@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXFKUYG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jun 2007 16:24:06 -0400
In-Reply-To: <465654EC.9080805@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, "Randy.Dunlap" <rdunlap@xenotime.net>

On Thu, 24 May 2007 23:15:56 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Kristen Carlson Accardi wrote:
> > Check to see if an ATAPI device supports Asynchronous Notification.
> > If so, enable it.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > ---
> > Andrew, I cleaned up the function header to properly comply with kernel
> > doc requirements.  Other than that, this patch is the same.  
> 
> I would ask for a simple revision:  update ata_dev_set_AN() such that it 
> takes a second argument 'enable'.  This boolean indicates to the 
> function whether SETFEATURES_SATA_ENABLE or SETFEATURES_SATA_DISABLE 
> should be passed to the device.
> 
> Otherwise than that, it's ready to merge I would say.
> 

Jeff - can you fold this into the original patch, or would you like me
to resubmit the whole thing?

Kristen

Modify ata_dev_set_AN to take a second argument 'enable'.  This
boolean indicates to the function whether SETFEATURES_SATA_ENABLE
or SETFEATURES_SATA_DISABLE should be passed to the device.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/ata/libata-core.c
===================================================================
--- 2.6-git.orig/drivers/ata/libata-core.c
+++ 2.6-git/drivers/ata/libata-core.c
@@ -70,7 +70,7 @@ const unsigned long sata_deb_timing_long
 static unsigned int ata_dev_init_params(struct ata_device *dev,
 					u16 heads, u16 sectors);
 static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
-static unsigned int ata_dev_set_AN(struct ata_device *dev);
+static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable);
 static void ata_dev_xfermask(struct ata_device *dev);
 
 unsigned int ata_print_id = 1;
@@ -2010,7 +2010,7 @@ int ata_dev_configure(struct ata_device 
 		if ((ap->flags & ATA_FLAG_AN) && ata_id_has_AN(id)) {
 			int err;
 			/* issue SET feature command to turn this on */
-			err = ata_dev_set_AN(dev);
+			err = ata_dev_set_AN(dev, SETFEATURES_SATA_ENABLE);
 			if (err)
 				ata_dev_printk(dev, KERN_ERR,
 						"unable to set AN, err %x\n",
@@ -3966,6 +3966,7 @@ static unsigned int ata_dev_set_xfermode
 /**
  *	ata_dev_set_AN - Issue SET FEATURES - SATA FEATURES
  *	@dev: Device to which command will be sent
+ *	@enable: Whether to enable or disable the feature
  *
  *	Issue SET FEATURES - SATA FEATURES command to device @dev
  *	on port @ap with sector count set to indicate Asynchronous
@@ -3977,7 +3978,7 @@ static unsigned int ata_dev_set_xfermode
  *	RETURNS:
  *	0 on success, AC_ERR_* mask otherwise.
  */
-static unsigned int ata_dev_set_AN(struct ata_device *dev)
+static unsigned int ata_dev_set_AN(struct ata_device *dev, u8 enable)
 {
 	struct ata_taskfile tf;
 	unsigned int err_mask;
@@ -3987,7 +3988,7 @@ static unsigned int ata_dev_set_AN(struc
 
 	ata_tf_init(dev, &tf);
 	tf.command = ATA_CMD_SET_FEATURES;
-	tf.feature = SETFEATURES_SATA_ENABLE;
+	tf.feature = enable;
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.protocol = ATA_PROT_NODATA;
 	tf.nsect = SATA_AN;
