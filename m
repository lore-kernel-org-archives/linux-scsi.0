From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Calling sd_shutdown when in state SDEV_DEL
Date: 02 Apr 2004 18:33:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080948785.1830.157.camel@mulgrave>
References: <200403241603.23269.heiko.carstens@de.ibm.com>
	<1080142505.2706.25.camel@mulgrave>
	<20040324170452.GB1679@beaverton.ibm.com>
	<1080158975.1783.26.camel@mulgrave>
	<20040325014859.GA3040@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:24998 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261347AbUDBXdc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Apr 2004 18:33:32 -0500
In-Reply-To: <20040325014859.GA3040@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-24 at 20:48, Mike Anderson wrote:
> James Bottomley [James.Bottomley@SteelEye.com] wrote:
> > On Wed, 2004-03-24 at 12:04, Mike Anderson wrote:
> > > Why setting CANCEL on the device? Future plans for the CANCEL state?
> > > You are setting the state to cancel, but not going through
> > > scsi_device_cancel as you want IO to still flow.
> > 
> > Mainly because it was there.  Using CANCEL instead of DEL is appealing
> > since it will still allow special I/O.  Would there be an issue with
> > refusing new device references in the CANCEL state?
> 
> I think this should be ok as this is our (scsi core) own internal
> solution to keep ref counts from increasing for the purpose of
> eventually allowing everything to cleanup. 

So can we agree on this as the final patch?

James

===== drivers/scsi/scsi.c 1.140 vs edited =====
--- 1.140/drivers/scsi/scsi.c	Tue Mar 16 20:10:09 2004
+++ edited/drivers/scsi/scsi.c	Fri Apr  2 15:36:08 2004
@@ -977,7 +977,7 @@
  */
 int scsi_device_get(struct scsi_device *sdev)
 {
-	if (sdev->sdev_state == SDEV_DEL)
+	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;
===== drivers/scsi/scsi_sysfs.c 1.44 vs edited =====
--- 1.44/drivers/scsi/scsi_sysfs.c	Tue Mar 16 10:00:19 2004
+++ edited/drivers/scsi/scsi_sysfs.c	Fri Apr  2 17:31:06 2004
@@ -502,18 +502,19 @@
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CANCEL) {
-		scsi_device_set_state(sdev, SDEV_DEL);
-		class_device_unregister(&sdev->sdev_classdev);
-		if (sdev->transport_classdev.class)
-			class_device_unregister(&sdev->transport_classdev);
-		device_del(&sdev->sdev_gendev);
-		if (sdev->host->hostt->slave_destroy)
-			sdev->host->hostt->slave_destroy(sdev);
-		if (sdev->host->transportt->cleanup)
-			sdev->host->transportt->cleanup(sdev);
-		put_device(&sdev->sdev_gendev);
-	}
+	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
+		return;
+
+	class_device_unregister(&sdev->sdev_classdev);
+	if (sdev->transport_classdev.class)
+		class_device_unregister(&sdev->transport_classdev);
+	device_del(&sdev->sdev_gendev);
+	scsi_device_set_state(sdev, SDEV_DEL);
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	if (sdev->host->transportt->cleanup)
+		sdev->host->transportt->cleanup(sdev);
+	put_device(&sdev->sdev_gendev);
 }
 
 int scsi_register_driver(struct device_driver *drv)

