From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 8/9] Implement scsi_resurrect_device()
Date: Wed, 23 May 2007 10:55:55 +0200
Message-ID: <20070523085555.52B23D44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757732AbXEWIz4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 04:55:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


This is the main part. This patch implements a function
scsi_resurrect_device() which puts a sdev in state SDEV_CANCEL
back into SDEV_RUNNING.
So during scan any device in state SDEV_DEL (ie waiting to be
deleted) will be put back into SDEV_RUNNING and normal scanning
can continue on these devices. Of course there is a high likelyhood
that the device will drop back into SDEV_DEL afterwards, but it is
perfectly useable during the scan operation.
For this to work I actually had to modify the allowed state
transitions, as it's now perfectly possible to move back from
SDEV_DEL into SDEV_CANCEL.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c      |    3 ++
 drivers/scsi/scsi_lib.c  |    2 +
 drivers/scsi/scsi_scan.c |   52 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 56 insertions(+), 1 deletions(-)

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
index 1f5a07b..4288572 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1945,6 +1945,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_CANCEL:
 			break;
 		default:
 			goto illegal;
@@ -1990,6 +1991,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
 		case SDEV_BLOCK:
+		case SDEV_DEL:
 			break;
 		default:
 			goto illegal;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2653015..75b8a78 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -698,7 +698,7 @@ static int scsi_probe_lun(struct scsi_de
  * Description:
  *    Configure an existing scsi_device. This function
  *    elevates a scsi_device from state SDEV_CREATED or
- *    SDEV_DEL into SDEV_RUNNING.
+ *    SDEV_CANCEL into SDEV_RUNNING.
  *
  * Return:
  *    0  On Success
@@ -723,6 +723,49 @@ int scsi_configure_device(struct scsi_de
 }
 
 /**
+ * scsi_resurrect_device - resurrect a deleted scsi_device
+ * @sdev:	The scsi_device to resurrect
+ *
+ * Description:
+ *    Elevate a deleted scsi_device back to SDEV_RUNNING.
+ *    A deleted scsi_device (ie in state SDEV_DEL) is only
+ *    deleted from the internal list when the ->release
+ *    function of the corresponding kobj structure is called.
+ *    Until that time it will stay visible to the host.
+ *    Whenever a scan has been initiated we thus have to
+ *    put this device back to SDEV_RUNNING and proceed
+ *    as with normal sdevs. It might be dropping back to
+ *    SDEV_DEL after scanning is completed, but is perfectly
+ *    useable during that time.
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
+	if (ret) {
+		scsi_destroy_device(sdev);
+		return ret;
+	}
+
+	/*
+	 * Ok, the device is now all set up, we can
+	 * register it and tell the rest of the kernel
+	 * about it.
+	 */
+	return scsi_sysfs_add_sdev(sdev);
+}
+
+/**
  * scsi_add_lun - allocate and fully initialze a scsi_device
  * @sdevscan:	holds information to be stored in the new scsi_device
  * @sdevnew:	store the address of the newly allocated scsi_device
@@ -1002,6 +1045,10 @@ static int scsi_probe_and_add_lun(struct
 	 */
 	sdev = scsi_device_lookup_by_target(starget, lun);
 	if (sdev) {
+		if (scsi_resurrect_device(sdev)) {
+			scsi_device_put(sdev);
+			return SCSI_SCAN_NO_RESPONSE;
+		}
 		if (rescan || sdev->sdev_state != SDEV_CREATED) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
@@ -1319,6 +1366,9 @@ static int scsi_report_lun_scan(struct s
 			return 0;
 		if (scsi_device_get(sdev))
 			return 0;
+	} else if (scsi_resurrect_device(sdev)) {
+		scsi_device_put(sdev);
+		return 0;
 	}
 
 	sprintf(devname, "host %d channel %d id %d",
-- 
1.4.3.4

