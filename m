From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Calling sd_shutdown when in state SDEV_DEL
Date: Wed, 24 Mar 2004 16:03:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200403241603.23269.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:48622 "EHLO
	mtagate3.uk.ibm.com") by vger.kernel.org with ESMTP id S263738AbUCXPKF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 10:10:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Hi,

upon scsi_remove_device the sd driver tries to send out a SYNCHRONIZE_CACHE
command (sd_shutdown) which is not possible because the sdev_state for the
device in question is already SDEV_DEL.
The patch below solves the problem, but I'm not sure if this is the right
way to do it. Also setting the state to SDEV_DEL after calling device_del
is probably pointless...

Heiko

diff -urN 2.5/drivers/scsi/scsi_sysfs.c 2.5-q/drivers/scsi/scsi_sysfs.c
--- 2.5/drivers/scsi/scsi_sysfs.c	Wed Mar 24 14:42:57 2004
+++ 2.5-q/drivers/scsi/scsi_sysfs.c	Wed Mar 24 14:39:21 2004
@@ -437,11 +437,12 @@
 void scsi_remove_device(struct scsi_device *sdev)
 {
 	if (sdev->sdev_state == SDEV_RUNNING || sdev->sdev_state == SDEV_CANCEL) {
-		scsi_device_set_state(sdev, SDEV_DEL);
+		scsi_device_quiesce(sdev);
 		class_device_unregister(&sdev->sdev_classdev);
 		if(sdev->transport_classdev.class)
 			class_device_unregister(&sdev->transport_classdev);
 		device_del(&sdev->sdev_gendev);
+		scsi_device_set_state(sdev, SDEV_DEL);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
 		if (sdev->host->transportt->cleanup)

