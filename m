From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before scanning
Date: Thu,  5 Jun 2014 09:26:42 +0200
Message-ID: <1401953203-103015-2-git-send-email-hare@suse.de>
References: <1401953203-103015-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51981 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbaFEH0r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2014 03:26:47 -0400
In-Reply-To: <1401953203-103015-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Robert Elliot <elliot@hp.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

REPORT_LUN_SCAN does not report any outstanding unit attention
condition as per SAM. However, the target might not be fully
initialized at that time, so we might end up getting a
default entry (or even a partially filled one).
But as we're not able to process the REPORT LUN DATA HAS CHANGED
unit attention correctly we'll be missing out some LUNs during
startup.
So it's better to send a TEST UNIT READY for modern implementations
and wait until the unit attention condition goes away.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c | 86 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 73 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e02b3aa..a8e59c3 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -123,6 +123,13 @@ MODULE_PARM_DESC(inq_timeout,
 		 "Timeout (in seconds) waiting for devices to answer INQUIRY."
 		 " Default is 20. Some devices may need more; most need less.");
 
+static unsigned int scsi_scan_timeout = SCSI_TIMEOUT/HZ + 58;
+
+module_param_named(scan_timeout, scsi_scan_timeout, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scan_timeout,
+		 "Timeout (in seconds) waiting for devices to become ready"
+		 " after INQUIRY. Default is 60.");
+
 /* This lock protects only this list */
 static DEFINE_SPINLOCK(async_scan_lock);
 static LIST_HEAD(scanning_hosts);
@@ -712,19 +719,6 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	}
 
 	/*
-	 * Related to the above issue:
-	 *
-	 * XXX Devices (disk or all?) should be sent a TEST UNIT READY,
-	 * and if not ready, sent a START_STOP to start (maybe spin up) and
-	 * then send the INQUIRY again, since the INQUIRY can change after
-	 * a device is initialized.
-	 *
-	 * Ideally, start a device if explicitly asked to do so.  This
-	 * assumes that a device is spun up on power on, spun down on
-	 * request, and then spun up on request.
-	 */
-
-	/*
 	 * The scanning code needs to know the scsi_level, even if no
 	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
 	 * non-zero LUNs can be scanned.
@@ -739,6 +733,65 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 }
 
 /**
+ * scsi_test_lun - waiting for a LUN to become ready
+ * @sdev:	scsi_device to test
+ *
+ * Description:
+ *     Wait for the lun associated with @sdev to become ready
+ *
+ *     Send a TEST UNIT READY to detect any unit attention conditions.
+ *     Retry TEST UNIT READY for up to @scsi_scan_timeout if the
+ *     returned sense key is 02/04/01 (Not ready, Logical Unit is
+ *     in process of becoming ready)
+ **/
+static int
+scsi_test_lun(struct scsi_device *sdev)
+{
+	struct scsi_sense_hdr sshdr;
+	int res = SCSI_SCAN_TARGET_PRESENT;
+	int tur_result;
+	unsigned long tur_timeout = jiffies + scsi_scan_timeout * HZ;
+
+	/* Skip for older devices */
+	if (sdev->scsi_level <= SCSI_3)
+		return SCSI_SCAN_LUN_PRESENT;
+
+	/*
+	 * Wait for the device to become ready.
+	 *
+	 * Some targets take some time before the firmware is
+	 * fully initialized, during which time they might not
+	 * be able to fill out any REPORT_LUN command correctly.
+	 * And as we're not capable of handling the
+	 * INQUIRY DATA CHANGED unit attention correctly we'd
+	 * rather wait here.
+	 */
+	do {
+		tur_result = scsi_test_unit_ready(sdev, SCSI_TIMEOUT,
+							  3, &sshdr);
+		if (!tur_result) {
+			res = SCSI_SCAN_LUN_PRESENT;
+			break;
+		}
+		if ((driver_byte(tur_result) & DRIVER_SENSE) &&
+		    scsi_sense_valid(&sshdr)) {
+			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
+				"scsi_scan: tur returned %02x/%02x/%02x\n",
+				sshdr.sense_key, sshdr.asc, sshdr.ascq));
+			if (sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x01) {
+				/* Logical Unit is in process
+				 * of becoming ready */
+				msleep(100);
+				continue;
+			}
+		}
+		res = SCSI_SCAN_LUN_PRESENT;
+	} while (time_before_eq(jiffies, tur_timeout));
+	return res;
+}
+
+/**
  * scsi_add_lun - allocate and fully initialze a scsi_device
  * @sdev:	holds information to be stored in the new scsi_device
  * @inq_result:	holds the result of a previous INQUIRY to the LUN
@@ -1142,6 +1195,13 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 		goto out_free_result;
 	}
 
+	res = scsi_test_lun(sdev);
+	if (res == SCSI_SCAN_TARGET_PRESENT) {
+		SCSI_LOG_SCAN_BUS(1, sdev_printk(KERN_INFO, sdev,
+			"scsi scan: device not ready\n"));
+		goto out_free_result;
+	}
+
 	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
-- 
1.7.12.4

