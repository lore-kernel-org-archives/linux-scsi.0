From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Calling sd_shutdown when in state SDEV_DEL
Date: 24 Mar 2004 10:35:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080142505.2706.25.camel@mulgrave>
References: <200403241603.23269.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:55174 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263741AbUCXPif (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 10:38:35 -0500
In-Reply-To: <200403241603.23269.heiko.carstens@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-24 at 10:03, Heiko Carstens wrote:
> upon scsi_remove_device the sd driver tries to send out a SYNCHRONIZE_CACHE
> command (sd_shutdown) which is not possible because the sdev_state for the
> device in question is already SDEV_DEL.
> The patch below solves the problem, but I'm not sure if this is the right
> way to do it. Also setting the state to SDEV_DEL after calling device_del
> is probably pointless...

Actually, I don't think quiesce, because that defers I/O waiting to
restart (also the transition QUIESCE->DEL is currently forbidden).

How about the attached instead.  That forces every deleted device to go
through CANCEL (uncompiled, but you can test it...)

James

===== scsi_sysfs.c 1.43 vs edited =====
--- 1.43/drivers/scsi/scsi_sysfs.c	Sat Mar 13 07:09:30 2004
+++ edited/scsi_sysfs.c	Wed Mar 24 10:32:56 2004
@@ -436,18 +436,19 @@
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CANCEL) {
-		scsi_device_set_state(sdev, SDEV_DEL);
-		class_device_unregister(&sdev->sdev_classdev);
-		if(sdev->transport_classdev.class)
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
+	if(sdev->transport_classdev.class)
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

