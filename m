From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] REPORT LUN scan even if no storage is available on LUN 0
Date: Mon, 13 Dec 2004 14:22:06 -0800
Message-ID: <20041213222206.GA18893@us.ibm.com>
References: <20041210123333.GD685@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34961 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261210AbULMWXj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Dec 2004 17:23:39 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id iBDMNYGM014362
	for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2004 17:23:34 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBDMMTPY087636
	for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2004 17:22:29 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id iBDMMTqR017625
	for <linux-scsi@vger.kernel.org>; Mon, 13 Dec 2004 17:22:29 -0500
Content-Disposition: inline
In-Reply-To: <20041210123333.GD685@bogon.ms20.nix>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guido Guenther <agx@sigxcpu.org>
Cc: linux-scsi@vger.kernel.org

Patch looks okay, but we should always be trying the report lun scan, and
then failing back to the sequential scan even if there is no storage on
LUN 0.

Can you test this? I don't have hardware readily available that supports
sparse luns and report lun. Patch is against current bk. I built and
ran with regular disks (lun 0 only).

This is a bit hacky, improvements welcomed. Ideally we should create and
then use a scsi_target to scan, rather than having the scsi_device
allocation trigger creation of the scsi_target, and pass a scsi_target to
other scan functions.


Support REPORT LUN scan even if no storage is available on LUN 0.

Signed-off-by: Patrick Mansfield <patmans@us.ibm.com>

--- 1.134/drivers/scsi/scsi_scan.c	Sun Oct 24 04:09:48 2004
+++ edited/drivers/scsi/scsi_scan.c	Mon Dec 13 13:23:37 2004
@@ -647,6 +647,9 @@
  *     Call scsi_probe_lun, if a LUN with an attached device is found,
  *     allocate and set it up by calling scsi_add_lun.
  *
+ * Note: LUN 0 is special cased, the sdev is not released if we are
+ *     returning SCSI_SCAN_TARGET_PRESENT.
+ *
  * Return:
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
  *     SCSI_SCAN_TARGET_PRESENT: target responded, but no device is
@@ -735,7 +738,12 @@
  out_free_sreq:
 	scsi_release_request(sreq);
  out_free_sdev:
-	if (res == SCSI_SCAN_LUN_PRESENT) {
+	if ((res == SCSI_SCAN_LUN_PRESENT) ||
+	    ((lun == 0) && res == SCSI_SCAN_TARGET_PRESENT)) {
+		/*
+		 * The LUN 0 check is for support of report lun scanning
+		 * when no storage is configured on LUN 0.
+		 */
 		if (sdevp)
 			*sdevp = sdev;
 	} else {
@@ -1076,6 +1084,8 @@
 	down(&shost->scan_mutex);
 	res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL,
 				     &sdev, 1, hostdata);
+	if ((lun == 0) && (res == SCSI_SCAN_TARGET_PRESENT))
+		put_device(&sdev->sdev_gendev);
 	if (res != SCSI_SCAN_LUN_PRESENT)
 		sdev = ERR_PTR(-ENODEV);
 	up(&shost->scan_mutex);
@@ -1134,18 +1144,19 @@
 		/*
 		 * Scan for a specific host/chan/id/lun.
 		 */
-		scsi_probe_and_add_lun(shost, channel, id, lun, NULL, NULL,
-				       rescan, NULL);
-		return;
+		res = scsi_probe_and_add_lun(shost, channel, id, lun, NULL,
+					     &sdev, rescan, NULL);
+		goto completed;
 	}
 
 	/*
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
-	res = scsi_probe_and_add_lun(shost, channel, id, 0, &bflags, &sdev,
+	lun = 0;
+	res = scsi_probe_and_add_lun(shost, channel, id, lun, &bflags, &sdev,
 				     rescan, NULL);
-	if (res == SCSI_SCAN_LUN_PRESENT) {
+	if (res != SCSI_SCAN_NO_RESPONSE) {
 		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
 			/*
 			 * The REPORT LUN did not scan the target,
@@ -1153,16 +1164,15 @@
 			 */
 			scsi_sequential_lun_scan(shost, channel, id, bflags,
 				       	res, sdev->scsi_level, rescan);
-	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
+	}
+
+ completed:
+	if ((lun == 0) && (res == SCSI_SCAN_TARGET_PRESENT))
 		/*
-		 * There's a target here, but lun 0 is offline so we
-		 * can't use the report_lun scan.  Fall back to a
-		 * sequential lun scan with a bflags of SPARSELUN and
-		 * a default scsi level of SCSI_2
+		 * LUN 0 is handled specially so the sdev can be
+		 * used with the REPORT LUN scan, release it now.
 		 */
-		scsi_sequential_lun_scan(shost, channel, id, BLIST_SPARSELUN,
-				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
-	}
+		put_device(&sdev->sdev_gendev);
 }
 
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int channel,
