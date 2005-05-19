From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Sanitize PQ3 device handling (Take #2)
Date: Thu, 19 May 2005 16:38:27 +0200
Message-ID: <428CA4E3.9030601@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020508010900020800020903"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:63429 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S262533AbVESOig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 10:38:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020508010900020800020903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

this is an updated version of the patch. As I suspected, the issue isn't
quite as easy. Problem is that older SCSI-2 device have the habit for
responding to LUN1 in addition to LUN0, even though only one device is
attached. LUN1 has set PQ to 3 accordingly.
And of course we _don't_ want those fake devices to stick around.
So I've improved the logic to not register devices with LUN != 0 and a
PQ of 1 or 3. All other devices are registered accordingly.

I can't really see why we should register devices with PQ 1 and LUN !=
0; if one wants to have them he still can do a REPORT LUN on LUN 0 and
an explicit scan for the missing device.

And I do think the locking is slightly wrong for the failure case;
without this adaptecs have a habit of crashing when doing a rmmod.

But again, comments etc are welcome.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------020508010900020800020903
Content-Type: text/plain;
 name="linux-2.6.12-rc4-scsi-scan-sparse-luns"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.12-rc4-scsi-scan-sparse-luns"

From: Hannes Reinecke <hare@suse.de>
Subject: Sanitize PQ 3 devices

The current handling of devices with a PQ of 3 is plain broken.
Whenever we detect such a device, no device check with REPORT LUNs is
made but rather a SCSI-2 sequential scan is done. This is plain wrong
for modern storage servers who use LUN 0 as a virtual device to be
used for configuration, eg REPORT LUN queries.

Improved scanning logic:
The SCSI_SCAN_XX flags have been renamed to the more precise
SCSI_SCAN_TARGET_PRESENT and SCSI_SCAN_TARGET_IGNORED.
First LUN 0 is scanned; if any device is detected a report_lun scan is
attempted. This will bail out for any device which does not support
it; for those a sequential scan is performed.
All devices are registered with the midlayer except those which report
a PQ of 1 or 3 and have a LUN != 0. LUN 0 will always be registered as
we might need it for configuration / queries.

Oh, and IMHO the locking is wrong for failed devices.

--- linux-2.6.12-rc4/drivers/scsi/scsi_scan.c.orig	2005-05-19 15:57:51.000000000 +0200
+++ linux-2.6.12-rc4/drivers/scsi/scsi_scan.c	2005-05-19 16:18:26.000000000 +0200
@@ -64,15 +64,15 @@
  * SCSI_SCAN_NO_RESPONSE: no valid response received from the target, this
  * includes allocation or general failures preventing IO from being sent.
  *
- * SCSI_SCAN_TARGET_PRESENT: target responded, but no device is available
- * on the given LUN.
+ * SCSI_SCAN_TARGET_IGNORED: target responded, but is ignored from the
+ * midlayer
  *
- * SCSI_SCAN_LUN_PRESENT: target responded, and a device is available on a
- * given LUN.
+ * SCSI_SCAN_TARGET_PRESENT: target responded, and is registered with the
+ * midlayer
  */
 #define SCSI_SCAN_NO_RESPONSE		0
-#define SCSI_SCAN_TARGET_PRESENT	1
-#define SCSI_SCAN_LUN_PRESENT		2
+#define SCSI_SCAN_TARGET_IGNORED	1
+#define SCSI_SCAN_TARGET_PRESENT	2
 
 static char *scsi_null_device_strs = "nullnullnullnull";
 
@@ -282,6 +282,9 @@ static struct scsi_device *scsi_alloc_sd
 out_device_destroy:
 	transport_destroy_device(&sdev->sdev_gendev);
 	scsi_free_queue(sdev->request_queue);
+	put_device(&starget->dev);
+	put_device(&sdev->transport_classdev);
+	put_device(&sdev->sdev_classdev);
 	put_device(&sdev->sdev_gendev);
 out:
 	if (display_failure_msg)
@@ -553,8 +556,7 @@ static void scsi_probe_lun(struct scsi_r
 
 	/*
 	 * The scanning code needs to know the scsi_level, even if no
-	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
-	 * non-zero LUNs can be scanned.
+	 * device is attached at LUN 0 so that non-zero LUNs can be scanned.
 	 */
 	sdev->scsi_level = inq_result[2] & 0x07;
 	if (sdev->scsi_level >= 2 ||
@@ -579,7 +581,7 @@ static void scsi_probe_lun(struct scsi_r
  *
  * Return:
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
- *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
+ *     SCSI_SCAN_TARGET_PRESENT: a new Scsi_Device was allocated and initialized
  **/
 static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
 {
@@ -651,6 +653,11 @@ static int scsi_add_lun(struct scsi_devi
 	 * Don't set the device offline here; rather let the upper
 	 * level drivers eval the PQ to decide whether they should
 	 * attach. So remove ((inq_result[0] >> 5) & 7) == 1 check.
+	 *
+	 * Since we don't set the device offline anymore there is
+	 * no sense at all in treating PQ 1 and PQ 3 differently
+	 * as both do not have a device attached. If PQ 1 targets
+	 * ever get it's device back we need to rescan anyway.
 	 */ 
 
 	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
@@ -739,7 +746,7 @@ static int scsi_add_lun(struct scsi_devi
 	 */
 	scsi_sysfs_add_sdev(sdev);
 
-	return SCSI_SCAN_LUN_PRESENT;
+	return SCSI_SCAN_TARGET_PRESENT;
 }
 
 /**
@@ -756,9 +763,8 @@ static int scsi_add_lun(struct scsi_devi
  *
  * Return:
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
- *     SCSI_SCAN_TARGET_PRESENT: target responded, but no device is
- *         attached at the LUN
- *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
+ *     SCSI_SCAN_TARGET_IGNORED: target responded but was ignored.
+ *     SCSI_SCAN_TARGET_PRESENT: a new Scsi_Device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
 				  uint lun, int *bflagsp,
@@ -790,7 +796,7 @@ static int scsi_probe_and_add_lun(struct
 				*bflagsp = scsi_get_device_flags(sdev,
 								 sdev->vendor,
 								 sdev->model);
-			return SCSI_SCAN_LUN_PRESENT;
+			return SCSI_SCAN_TARGET_PRESENT;
 		}
 	}
 
@@ -812,26 +818,23 @@ static int scsi_probe_and_add_lun(struct
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
-	if ((result[0] >> 5) == 3) {
+	if ( lun != 0 && ((result[0] >> 5) == 3) || ((result[0] >> 5) == 1)) {
 		/*
-		 * For a Peripheral qualifier 3 (011b), the SCSI
-		 * spec says: The device server is not capable of
-		 * supporting a physical device on this logical
-		 * unit.
+		 * The Peripheral qualifier indicates that there
+		 * is no physical device connected.
 		 *
-		 * For disks, this implies that there is no
-		 * logical disk configured at sdev->lun, but there
-		 * is a target id responding.
+		 * So ignore this device if it's not LUN 0;
+		 * keep LUN 0 around so as to send inquiries to it.
 		 */
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-					"scsi scan: peripheral qualifier of 3,"
-					" no device added\n"));
-		res = SCSI_SCAN_TARGET_PRESENT;
+					"scsi scan: no physical device present,"
+					" device not added\n"));
+		res = SCSI_SCAN_TARGET_IGNORED;
 		goto out_free_result;
 	}
 
 	res = scsi_add_lun(sdev, result, &bflags);
-	if (res == SCSI_SCAN_LUN_PRESENT) {
+	if (res != SCSI_SCAN_NO_RESPONSE) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
 			scsi_unlock_floptical(sreq, result);
@@ -845,7 +848,7 @@ static int scsi_probe_and_add_lun(struct
  out_free_sreq:
 	scsi_release_request(sreq);
  out_free_sdev:
-	if (res == SCSI_SCAN_LUN_PRESENT) {
+	if (res == SCSI_SCAN_TARGET_PRESENT) {
 		if (sdevp) {
 			scsi_device_get(sdev);
 			*sdevp = sdev;
@@ -854,6 +857,8 @@ static int scsi_probe_and_add_lun(struct
 		if (sdev->host->hostt->slave_destroy)
 			sdev->host->hostt->slave_destroy(sdev);
 		transport_destroy_device(&sdev->sdev_gendev);
+		put_device(&sdev->transport_classdev);
+		put_device(&sdev->sdev_classdev);
 		put_device(&sdev->sdev_gendev);
 	}
  out:
@@ -899,7 +904,7 @@ static void scsi_sequential_lun_scan(str
 	 * If not sparse lun and no device attached at LUN 0 do not scan
 	 * any further.
 	 */
-	if (!sparse_lun && (lun0_res != SCSI_SCAN_LUN_PRESENT))
+	if (!sparse_lun && (lun0_res != SCSI_SCAN_TARGET_PRESENT))
 		return;
 
 	/*
@@ -944,7 +949,7 @@ static void scsi_sequential_lun_scan(str
 	 */
 	for (lun = 1; lun < max_dev_lun; ++lun)
 		if ((scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan,
-					    NULL) != SCSI_SCAN_LUN_PRESENT) &&
+					    NULL) != SCSI_SCAN_TARGET_PRESENT) &&
 		    !sparse_lun)
 			return;
 }
@@ -1199,7 +1204,7 @@ struct scsi_device *__scsi_add_device(st
 
 	down(&shost->scan_mutex);
 	res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
-	if (res != SCSI_SCAN_LUN_PRESENT)
+	if (res != SCSI_SCAN_TARGET_PRESENT)
 		sdev = ERR_PTR(-ENODEV);
 	up(&shost->scan_mutex);
 	scsi_target_reap(starget);
@@ -1215,7 +1220,6 @@ void scsi_rescan_device(struct device *d
 	
 	if (!dev->driver)
 		return;
-
 	drv = to_scsi_driver(dev->driver);
 	if (try_module_get(drv->owner)) {
 		if (drv->rescan)
@@ -1279,23 +1283,30 @@ void scsi_scan_target(struct device *par
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
 	res = scsi_probe_and_add_lun(starget, 0, &bflags, &sdev, rescan, NULL);
-	if (res == SCSI_SCAN_LUN_PRESENT) {
-		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
+	if (res != SCSI_SCAN_NO_RESPONSE) {
+		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0) {
 			/*
 			 * The REPORT LUN did not scan the target,
 			 * do a sequential scan.
 			 */
+			if (res == SCSI_SCAN_TARGET_IGNORED)
+				/*
+				 * There's a target here, but lun 0 is not 
+				 * connected to a device and does not support
+				 * the report_lun scan.  Fall back to a 
+				 * sequential lun scan with a bflags of 
+				 * SPARSELUN.
+				 *
+				 * The old code also used a default scsi level
+				 * of SCSI_2 which seems a bit spurious. Any
+				 * misbehaving device should rather be added
+				 * to the blacklist.
+				 */
+				bflags |= BLIST_SPARSELUN;
+
 			scsi_sequential_lun_scan(starget, bflags,
 				       	res, sdev->scsi_level, rescan);
-	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
-		/*
-		 * There's a target here, but lun 0 is offline so we
-		 * can't use the report_lun scan.  Fall back to a
-		 * sequential lun scan with a bflags of SPARSELUN and
-		 * a default scsi level of SCSI_2
-		 */
-		scsi_sequential_lun_scan(starget, BLIST_SPARSELUN,
-				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
+		}
 	}
 	if (sdev)
 		scsi_device_put(sdev);

--------------020508010900020800020903--
