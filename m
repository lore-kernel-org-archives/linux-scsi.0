From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 9/11] Implement scsi_resurrect_device()
Date: Mon, 18 Jun 2007 11:02:09 +0200
Message-ID: <20070618090209.7D00DD44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757082AbXFRJCK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Jun 2007 05:02:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


This patch implements a function scsi_resurrect_device()
which elevates a sdev from state SDEV_CANCEL back into
SDEV_RUNNING.
So during a scan any sdev in SDEV_DEL is put into
SDEV_CANCEL and then scsi_resurrect_device() is called.
This will put the device into SDEV_RUNNING and the scan
can proceed.
To allow this the state machine has to be expanded, as no
transistion out of SDEV_CANCEL into SDEV_RUNNING and from
SDEV_DEL into SDEV_CANCEL are now perfectly possible.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c      |    3 ++
 drivers/scsi/scsi_lib.c  |    2 +
 drivers/scsi/scsi_scan.c |   53 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 4c1e313..11f0f0d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -950,6 +950,9 @@ struct scsi_device *scsi_device_lookup_b
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	sdev = __scsi_device_lookup_by_target(starget, lun);
+	/* This triggers a resurrection of the sdev */
+	if (sdev && sdev->sdev_state == SDEV_DEL)
+		scsi_device_set_state(sdev, SDEV_CANCEL);
 	if (sdev && scsi_device_get(sdev))
 		sdev = NULL;
 	spin_unlock_irqrestore(shost->host_lock, flags);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index bb32747..d1dc7ce 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1954,6 +1954,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_CANCEL:
 			break;
 		default:
 			goto illegal;
@@ -1999,6 +2000,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
 		case SDEV_BLOCK:
+		case SDEV_DEL:
 			break;
 		default:
 			goto illegal;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index bf62089..a97c889 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -735,6 +735,52 @@ int scsi_configure_device(struct scsi_de
 }
 
 /**
+ * scsi_resurrect_device - resurrect a deleted scsi_device
+ * @sdev:	The scsi_device to resurrect
+ *
+ * Description:
+ *    Elevate a deleted scsi_device back to SDEV_RUNNING.
+ *    The scsi_device has to be in SDEV_CANCEL.
+ *    The resurrection process calls scsi_configure_device()
+ *    to setup transport and LLDD and then attaches it to sysfs
+ *    with scsi_sysfs_add_sdev().
+ *    On success the device is in SDEV_RUNNING and ready to
+ *    accept I/O.
+ *    On failure the device is put back into SDEV_CANCEL.
+ *    It should be set to SDEV_DEL afterwards by eg.
+ *    a call to scsi_destroy_device().
+ *
+ * Return:
+ *    0  On Success
+ *    <0 On failure.
+ *
+ **/
+int scsi_resurrect_device(struct scsi_device *sdev)
+{
+	int ret = 0;
+
+	/* Ignore devices not in state SDEV_CANCEL */
+	if (sdev->sdev_state != SDEV_CANCEL)
+		return 0;
+
+	ret = scsi_configure_device(sdev);
+	if (ret)
+		return ret;
+
+	/*
+	 * Ok, the device is now all set up, we can
+	 * register it and tell the rest of the kernel
+	 * about it.
+	 */
+	ret = scsi_sysfs_add_sdev(sdev);
+
+	if (ret)
+		scsi_device_set_state(sdev, SDEV_CANCEL);
+
+	return ret;
+}
+
+/**
  * scsi_add_lun - allocate and fully initialze a scsi_device
  * @sdevscan:	holds information to be stored in the new scsi_device
  * @sdevnew:	store the address of the newly allocated scsi_device
@@ -1013,6 +1059,10 @@ static int scsi_probe_and_add_lun(struct
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
+		if (scsi_resurrect_device(sdev)) {
+			scsi_destroy_device(sdev);
+			return SCSI_SCAN_NO_RESPONSE;
+		}
 		if (rescan || sdev->sdev_state != SDEV_CREATED) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
@@ -1330,6 +1380,9 @@ static int scsi_report_lun_scan(struct s
 			return 0;
 		if (scsi_device_get(sdev))
 			return 0;
+	} else if (scsi_resurrect_device(sdev)) {
+		scsi_destroy_device(sdev);
+		return 0;
 	}
 
 	sprintf(devname, "host %d channel %d id %d",
-- 
1.4.3.4

