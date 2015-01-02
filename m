From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH][RESEND] scsi_scan: Send TEST UNIT READY to LUN0 before LUN scanning
Date: Fri,  2 Jan 2015 15:18:28 +0100
Message-ID: <1420208308-96701-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbbABOSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2015 09:18:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Martthias Roessler <Matthias.Roessler@ts.fujitsu.com>

REPORT_LUN_SCAN does not report any outstanding unit attention
condition as per SAM. However, there are some target implementations
which might not be fully initialized by the time we're starting
the report lun scan.
For these targets we end up getting a default entry
(or even a partially filled one).
And as we're not able to process the REPORT LUN DATA HAS CHANGED
unit attention correctly we'll be missing out some LUNs altogether.

To handle these conditions properly I've added a new blacklist
flag 'BLIST_TEST_LUN0' which will send a TEST UNIT READY
and wait until the unit attention condition goes away.

We cannot make this the default as some other target
implementations rely on the scanning code to complete even though the
firmware might not be fully initialized.

Cc: Martthias Roessler <Matthias.Roessler@ts.fujitsu.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_devinfo.c |  1 +
 drivers/scsi/scsi_scan.c    | 80 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_devinfo.h |  2 ++
 3 files changed, 83 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 262ab83..50a8b49 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -166,6 +166,7 @@ static struct {
 	{"easyRAID", "X6P", NULL, BLIST_NOREPORTLUN},
 	{"easyRAID", "F8", NULL, BLIST_NOREPORTLUN},
 	{"FSC", "CentricStor", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"FUJITSU", "ETERNUS_DX", "*", BLIST_TEST_LUN0 },
 	{"Generic", "USB SD Reader", "1.00", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0180", BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"Generic", "USB Storage-SMC", "0207", BLIST_FORCELUN | BLIST_INQUIRY_36},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 983aed1..ecda94d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -34,6 +34,7 @@
 #include <linux/spinlock.h>
 #include <linux/async.h>
 #include <linux/slab.h>
+#include <linux/ratelimit.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -119,6 +120,13 @@ MODULE_PARM_DESC(inq_timeout,
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
@@ -756,6 +764,69 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
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
+static bool
+scsi_test_lun(struct scsi_device *sdev)
+{
+	struct scsi_sense_hdr sshdr;
+	bool res = false;
+	int tur_result;
+	unsigned long tur_timeout = jiffies + scsi_scan_timeout * HZ;
+
+	/* Skip for older devices */
+	if (sdev->scsi_level <= SCSI_3)
+		return true;
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
+		if (tur_result &&
+		    (driver_byte(tur_result) & DRIVER_SENSE) &&
+		    scsi_sense_valid(&sshdr)) {
+			static DEFINE_RATELIMIT_STATE(_rs,
+					DEFAULT_RATELIMIT_INTERVAL,
+					DEFAULT_RATELIMIT_BURST);
+			if (__ratelimit(&_rs))
+				SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO,
+					sdev, "scsi_scan: tur returned %02x/%02x/%02x\n",
+					sshdr.sense_key, sshdr.asc,
+					sshdr.ascq));
+
+			if (sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x01) {
+				/* Logical Unit is in process
+				 * of becoming ready */
+				msleep(100);
+				continue;
+			}
+		}
+		res = true;
+		break;
+	} while (time_before_eq(jiffies, tur_timeout));
+	return res;
+}
+
+/**
  * scsi_add_lun - allocate and fully initialze a scsi_device
  * @sdev:	holds information to be stored in the new scsi_device
  * @inq_result:	holds the result of a previous INQUIRY to the LUN
@@ -1159,6 +1230,15 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
 		goto out_free_result;
 	}
 
+	if (bflags & BLIST_TEST_LUN0) {
+		if (!scsi_test_lun(sdev)) {
+			SCSI_LOG_SCAN_BUS(1, sdev_printk(KERN_INFO, sdev,
+				"scsi scan: device not ready\n"));
+			res = SCSI_SCAN_TARGET_PRESENT;
+			goto out_free_result;
+		}
+	}
+
 	res = scsi_add_lun(sdev, result, &bflags, shost->async_scan);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 183eaab..cf1887b 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -36,5 +36,7 @@
 					     for sequential scan */
 #define BLIST_TRY_VPD_PAGES	0x10000000 /* Attempt to read VPD pages */
 #define BLIST_NO_RSOC		0x20000000 /* don't try to issue RSOC */
+#define BLIST_TEST_LUN0		0x40000000 /* Send TEST UNIT READY to
+					    * LUN0 before scanning */
 
 #endif
-- 
1.8.4.5

