From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [BUG] linux-2.6.0-test9: slave_destroy called too early
Date: Tue, 11 Nov 2003 11:45:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200311111145.49009.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:6362 "EHLO
	mtagate7.de.ibm.com") by vger.kernel.org with ESMTP id S263135AbTKKK4C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 05:56:02 -0500
Received: from d12relay02.megacenter.de.ibm.com (d12relay02.megacenter.de.ibm.com [9.149.165.196] (may be forged))
	by mtagate7.de.ibm.com (8.12.10/8.12.10) with ESMTP id hABAu0xm023322
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2003 10:56:00 GMT
Received: from osiris (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12relay02.megacenter.de.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hABAtx3A250346
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2003 11:55:59 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

in linux-2.6.0-test9 there seems to be a bug in scsi_remove_device: each time
I try to remove a scsi disk the sd driver fails to synchronize the SCSI cache.
Reason for this is that the slave_destroy function of the LLD gets called
before sd_shutdown of the sd driver gets called.
I would suggest the patch below. Please apply or let me know that this is the
wrong thing to do.

Thanks,
Heiko

diff -urN linux-2.6.0-test9/drivers/scsi/scsi_sysfs.c 
linux-2.6.0-test9-sd/drivers/scsi/scsi_sysfs.c
--- linux-2.6.0-test9/drivers/scsi/scsi_sysfs.c	Sat Oct 25 20:43:04 2003
+++ linux-2.6.0-test9-sd/drivers/scsi/scsi_sysfs.c	Tue Nov 11 11:43:27 2003
@@ -410,9 +410,9 @@
 	if (class) {
 		down_write(&class->subsys.rwsem);
 		set_bit(SDEV_DEL, &sdev->sdev_state);
+		device_del(&sdev->sdev_gendev);
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
-		device_del(&sdev->sdev_gendev);
 		up_write(&class->subsys.rwsem);
 	}

