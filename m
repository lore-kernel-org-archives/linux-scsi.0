From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] scsi: Add added_to_sysfs sdev flag to fix device scanning oops
Date: Mon, 11 Aug 2008 13:03:24 -0500
Message-ID: <200808111804.m7BI46kb004687@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:57456 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYHKSEX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Aug 2008 14:04:23 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7BI4KjZ031894
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2008 14:04:20 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7BI48bK164818
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2008 12:04:08 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7BI47pl004795
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2008 12:04:07 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The following patch fixes an oops which was observed during device scanning.
If LUN 0 does not exist for a valid target, but non-zero LUNs do exist, a struct
scsi_device exists only when probing the target and is deleted by the scanning
code, by checking to see if the device's state is SDEV_CREATED. If, while scanning,
the rport is deleted, such that target is placed into the blocked state, and
then later the rport is added again, the LUN 0 sdev finds its way into the SDEV_RUNNING
state. This causes the scanning code to NOT delete the sdev when scanning is complete.
Later on, if the target is deleted, we will oops when we try to free up everything
that gets allocated in scsi_sysfs_add_sdev, since it was never added. This patch
fixes this issue, by adding a added_to_sysfs flag to struct scsi_device, which is
then checked to determine what to do, both in the device probe exit code and the
device remove code.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/scsi_scan.c   |    4 ++--
 drivers/scsi/scsi_sysfs.c  |   11 +++++++----
 include/scsi/scsi_device.h |    1 +
 3 files changed, 10 insertions(+), 6 deletions(-)

diff -puN include/scsi/scsi_device.h~scsi_add_sysfs_flag include/scsi/scsi_device.h
--- linux-2.6/include/scsi/scsi_device.h~scsi_add_sysfs_flag	2008-08-11 10:49:06.000000000 -0500
+++ linux-2.6-bjking1/include/scsi/scsi_device.h	2008-08-11 10:49:06.000000000 -0500
@@ -142,6 +142,7 @@ struct scsi_device {
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
 	unsigned last_sector_bug:1;	/* do not use multisector accesses on
 					   SD_LAST_BUGGY_SECTORS */
+	unsigned added_to_sysfs:1;	/* Device added to sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
diff -puN drivers/scsi/scsi_sysfs.c~scsi_add_sysfs_flag drivers/scsi/scsi_sysfs.c
--- linux-2.6/drivers/scsi/scsi_sysfs.c~scsi_add_sysfs_flag	2008-08-11 10:49:06.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/scsi_sysfs.c	2008-08-11 10:49:06.000000000 -0500
@@ -922,6 +922,7 @@ int scsi_sysfs_add_sdev(struct scsi_devi
 	}
 
 	transport_add_device(&sdev->sdev_gendev);
+	sdev->added_to_sysfs = 1;
  out:
 	return error;
 
@@ -942,10 +943,12 @@ void __scsi_remove_device(struct scsi_de
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
-	bsg_unregister_queue(sdev->request_queue);
-	device_unregister(&sdev->sdev_dev);
-	transport_remove_device(dev);
-	device_del(dev);
+	if (sdev->added_to_sysfs) {
+		bsg_unregister_queue(sdev->request_queue);
+		device_unregister(&sdev->sdev_dev);
+		transport_remove_device(dev);
+		device_del(dev);
+	}
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
diff -puN drivers/scsi/scsi_scan.c~scsi_add_sysfs_flag drivers/scsi/scsi_scan.c
--- linux-2.6/drivers/scsi/scsi_scan.c~scsi_add_sysfs_flag	2008-08-11 10:49:06.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/scsi_scan.c	2008-08-11 10:49:06.000000000 -0500
@@ -994,7 +994,7 @@ static int scsi_probe_and_add_lun(struct
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
-		if (rescan || sdev->sdev_state != SDEV_CREATED) {
+		if (rescan || sdev->added_to_sysfs) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
 				sdev->sdev_gendev.bus_id));
@@ -1466,7 +1466,7 @@ static int scsi_report_lun_scan(struct s
 	kfree(lun_data);
  out:
 	scsi_device_put(sdev);
-	if (sdev->sdev_state == SDEV_CREATED)
+	if (!sdev->added_to_sysfs)
 		/*
 		 * the sdev we used didn't appear in the report luns scan
 		 */
_
