From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Fw: 2.6.4-mm1 and removable USB drive oops
Date: 13 Mar 2004 13:17:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079201828.2512.24.camel@mulgrave>
References: <20040312213831.4b56c469.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:35016 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263155AbUCMSRQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Mar 2004 13:17:16 -0500
In-Reply-To: <20040312213831.4b56c469.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "Brian S. Stephan" <stephanb@msoe.edu>

On Sat, 2004-03-13 at 00:38, Andrew Morton wrote:
> James's tree broke.

Well, yes.

The actual problem reported was because there wasn't a corresponding
check on transport_classdev.class in the unregister.

However, on closer inspection I also turned up a nasty thinko in the
reference counting.  For reasons best known to the class code authors,
class devices have to obtain their own references to the devices they're
attached to which they release again in their .release routines, so you
have to remember to do a get_device() in the correct place after the
class_device_add().  I put comments in the code so that, hopefully, we
can avoid the problem in future.

James

===== drivers/scsi/scsi_sysfs.c 1.43 vs edited =====
--- 1.43/drivers/scsi/scsi_sysfs.c	Fri Mar 12 16:50:50 2004
+++ edited/drivers/scsi/scsi_sysfs.c	Sat Mar 13 12:09:30 2004
@@ -367,15 +367,20 @@
 		printk(KERN_INFO "error 2\n");
 		goto clean_device;
 	}
+	/* take a reference for the sdev_classdev; this is
+	 * released by the sdev_class .release */
+	get_device(&sdev->sdev_gendev);
 
 	if (sdev->transport_classdev.class) {
 		error = class_device_add(&sdev->transport_classdev);
 		if (error)
 			goto clean_device2;
+		/* take a reference for the transport_classdev; this
+		 * is released by the transport_class .release */
+		get_device(&sdev->sdev_gendev);
+		
 	}
 
-	get_device(&sdev->sdev_gendev);
-
 	if (sdev->host->hostt->sdev_attrs) {
 		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
 			error = attr_add(&sdev->sdev_gendev,
@@ -434,7 +439,8 @@
 	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CANCEL) {
 		scsi_device_set_state(sdev, SDEV_DEL);
 		class_device_unregister(&sdev->sdev_classdev);
-		class_device_unregister(&sdev->transport_classdev);
+		if(sdev->transport_classdev.class)
+			class_device_unregister(&sdev->transport_classdev);
 		device_del(&sdev->sdev_gendev);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);

