From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Sanitize PQ3 device handling
Date: Wed, 18 May 2005 11:43:41 +0200
Message-ID: <428B0E4D.50505@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060300010804090903010405"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:25487 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S262140AbVERJnv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2005 05:43:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060300010804090903010405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

the attached patch sanitzes the handling of devices with a periperal
qualifier of 3. As we don't set non-existing devices offline anymore
there is no real sense in distinguishing between PQ 1 and PQ3, as the
net effect (no available device) is identical. However, we really want
to have access to the target via sg.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------060300010804090903010405
Content-Type: text/plain;
 name="linux-2.6.12-rc4-scsi-scan-sparse-luns"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.12-rc4-scsi-scan-sparse-luns"

diff -pur linux-2.6.12-rc4.orig/drivers/scsi/scsi_scan.c linux-2.6.12-rc4/drivers/scsi/scsi_scan.c
--- linux-2.6.12-rc4.orig/drivers/scsi/scsi_scan.c	2005-05-07 07:20:31.000000000 +0200
+++ linux-2.6.12-rc4/drivers/scsi/scsi_scan.c	2005-05-18 11:29:47.000000000 +0200
@@ -579,6 +579,8 @@ static void scsi_probe_lun(struct scsi_r
  *
  * Return:
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
+ *     SCSI_SCAN_TARGET_PRESENT: a Scsi_Device was allocated and initialized
+ *                               however there is (currently) no LUN connected.
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
 static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
@@ -651,6 +653,11 @@ static int scsi_add_lun(struct scsi_devi
 	 * Don't set the device offline here; rather let the upper
 	 * level drivers eval the PQ to decide whether they should
 	 * attach. So remove ((inq_result[0] >> 5) & 7) == 1 check.
+	 *
+	 * Since we don't set the device offline anymore there is
+	 * no sense at all in treating PQ 1 and PQ 3 differently
+	 * as both do not have a device attached. If a PQ 1 target
+	 * ever get it's device back we need to rescan it anyway.
 	 */ 
 
 	sdev->inq_periph_qual = (inq_result[0] >> 5) & 7;
@@ -739,7 +746,16 @@ static int scsi_add_lun(struct scsi_devi
 	 */
 	scsi_sysfs_add_sdev(sdev);
 
-	return SCSI_SCAN_LUN_PRESENT;
+	/*
+	 * Targets with a PQ of 1 or 3 do not have
+	 * a device attached; tell the upper layers
+	 * about it.
+	 */
+	if (((inq_result[0] >> 5) & 7) == 1 ||
+	    ((inq_result[0] >> 5) & 7) == 3)
+		return SCSI_SCAN_TARGET_PRESENT;
+	else
+		return SCSI_SCAN_LUN_PRESENT;
 }
 
 /**
@@ -812,26 +828,8 @@ static int scsi_probe_and_add_lun(struct
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
-	if ((result[0] >> 5) == 3) {
-		/*
-		 * For a Peripheral qualifier 3 (011b), the SCSI
-		 * spec says: The device server is not capable of
-		 * supporting a physical device on this logical
-		 * unit.
-		 *
-		 * For disks, this implies that there is no
-		 * logical disk configured at sdev->lun, but there
-		 * is a target id responding.
-		 */
-		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
-					"scsi scan: peripheral qualifier of 3,"
-					" no device added\n"));
-		res = SCSI_SCAN_TARGET_PRESENT;
-		goto out_free_result;
-	}
-
 	res = scsi_add_lun(sdev, result, &bflags);
-	if (res == SCSI_SCAN_LUN_PRESENT) {
+	if (res != SCSI_SCAN_NO_RESPONSE) {
 		if (bflags & BLIST_KEY) {
 			sdev->lockable = 0;
 			scsi_unlock_floptical(sreq, result);
@@ -845,7 +843,7 @@ static int scsi_probe_and_add_lun(struct
  out_free_sreq:
 	scsi_release_request(sreq);
  out_free_sdev:
-	if (res == SCSI_SCAN_LUN_PRESENT) {
+	if (res != SCSI_SCAN_NO_RESPONSE) {
 		if (sdevp) {
 			scsi_device_get(sdev);
 			*sdevp = sdev;
@@ -1199,7 +1197,7 @@ struct scsi_device *__scsi_add_device(st
 
 	down(&shost->scan_mutex);
 	res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
-	if (res != SCSI_SCAN_LUN_PRESENT)
+	if (res == SCSI_SCAN_NO_RESPONSE)
 		sdev = ERR_PTR(-ENODEV);
 	up(&shost->scan_mutex);
 	scsi_target_reap(starget);
@@ -1279,23 +1277,29 @@ void scsi_scan_target(struct device *par
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
+			if (res == SCSI_SCAN_TARGET_PRESENT)
+				/*
+				 * There's a target here, but lun 0 is 
+				 * offline so we can't use the report_lun
+				 * scan.  Fall back to a sequential lun scan
+				 * with a bflags of SPARSELUN.
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
Only in linux-2.6.12-rc4/drivers/scsi: scsi_scan.c~
Only in linux-2.6.12-rc4/drivers/scsi: scsi_scan.c.orig

--------------060300010804090903010405--
