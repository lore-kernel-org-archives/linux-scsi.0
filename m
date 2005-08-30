From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH scsi-misc-2.6] allow REPORT LUN scanning even for LUN 0 PQ of 3
Date: Tue, 30 Aug 2005 15:43:16 -0700
Message-ID: <20050830224316.GA11210@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:65234 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932328AbVH3Wn2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 18:43:28 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7UMhRiX032602
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 18:43:27 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7UMhRUp094840
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 18:43:27 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7UMhQbW019274
	for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2005 18:43:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

James -

Can you ack or comment?

Allow REPORT LUN scanning even if LUN 0 reports a peripheral qualifier of
3 (effectively no storage is available on LUN 0).

Similar patch I previously posted:

http://marc.theaimsgroup.com/?l=linux-scsi&m=110297733824960&w=2

There is also Hannes patch, it leaves LUN 0 available for use via user
space, for compatibility it likely requires that it stay visible in the
future:

http://marc.theaimsgroup.com/?l=linux-scsi&m=111692497200507&w=2

Hannes' patch also causes a lot of extra vSCSI devices to show up on some
platforms :)

Signed-off-by: Patrick Mansfield <patmans@us.ibm.com>

diff -uprN -X /home/patman/dontdiff scsi-misc-2.6.git/drivers/scsi/scsi_scan.c lun0-scsi-misc-2.6.git/drivers/scsi/scsi_scan.c
--- scsi-misc-2.6.git/drivers/scsi/scsi_scan.c	2005-08-16 15:02:20.000000000 -0700
+++ lun0-scsi-misc-2.6.git/drivers/scsi/scsi_scan.c	2005-08-30 14:59:15.000000000 -0700
@@ -64,14 +64,14 @@
  * SCSI_SCAN_NO_RESPONSE: no valid response received from the target, this
  * includes allocation or general failures preventing IO from being sent.
  *
- * SCSI_SCAN_TARGET_PRESENT: target responded, but no device is available
+ * SCSI_SCAN_LUN_IGNORED: target responded, but no device is available
  * on the given LUN.
  *
  * SCSI_SCAN_LUN_PRESENT: target responded, and a device is available on a
  * given LUN.
  */
 #define SCSI_SCAN_NO_RESPONSE		0
-#define SCSI_SCAN_TARGET_PRESENT	1
+#define SCSI_SCAN_LUN_IGNORED		1
 #define SCSI_SCAN_LUN_PRESENT		2
 
 static char *scsi_null_device_strs = "nullnullnullnull";
@@ -578,7 +578,7 @@ static void scsi_probe_lun(struct scsi_r
 
 	/*
 	 * The scanning code needs to know the scsi_level, even if no
-	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
+	 * device is attached at LUN 0 (SCSI_SCAN_LUN_IGNORED) so
 	 * non-zero LUNs can be scanned.
 	 */
 	sdev->scsi_level = inq_result[2] & 0x07;
@@ -769,6 +769,19 @@ static int scsi_add_lun(struct scsi_devi
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
+/*
+ * scsi_scan_remove: Helper funciton to free up sdev's that are not added
+ * as sys devices. That is, we never call scsi_probe_and_add_lun for these
+ * sdev's.
+ */
+static void scsi_scan_remove(struct scsi_device *sdev)
+{
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_gendev);
+}
+
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
@@ -783,8 +796,10 @@ static int scsi_add_lun(struct scsi_devi
  *
  * Return:
  *     SCSI_SCAN_NO_RESPONSE: could not allocate or setup a Scsi_Device
- *     SCSI_SCAN_TARGET_PRESENT: target responded, but no device is
- *         attached at the LUN
+ *     SCSI_SCAN_LUN_IGNORED: target responded, but no device is
+ *         attached at the LUN. The sdev is never made visible, and must
+ *         be freed by the caller via scsi_scan_remove(). This way, LUN 0
+ *         is avaiable for use with the REPORT LUN command.
  *     SCSI_SCAN_LUN_PRESENT: a new Scsi_Device was allocated and initialized
  **/
 static int scsi_probe_and_add_lun(struct scsi_target *starget,
@@ -853,7 +868,7 @@ static int scsi_probe_and_add_lun(struct
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 					"scsi scan: peripheral qualifier of 3,"
 					" no device added\n"));
-		res = SCSI_SCAN_TARGET_PRESENT;
+		res = SCSI_SCAN_LUN_IGNORED;
 		goto out_free_result;
 	}
 
@@ -872,17 +887,13 @@ static int scsi_probe_and_add_lun(struct
  out_free_sreq:
 	scsi_release_request(sreq);
  out_free_sdev:
-	if (res == SCSI_SCAN_LUN_PRESENT) {
+	if ((res == SCSI_SCAN_LUN_PRESENT) || (res == SCSI_SCAN_LUN_IGNORED)) {
 		if (sdevp) {
 			scsi_device_get(sdev);
 			*sdevp = sdev;
 		}
-	} else {
-		if (sdev->host->hostt->slave_destroy)
-			sdev->host->hostt->slave_destroy(sdev);
-		transport_destroy_device(&sdev->sdev_gendev);
-		put_device(&sdev->sdev_gendev);
-	}
+	} else
+		scsi_scan_remove(sdev);
  out:
 	return res;
 }
@@ -1228,7 +1239,8 @@ static int scsi_report_lun_scan(struct s
 				       " from %s lun %d while scanning, scan"
 				       " aborted\n", devname, lun);
 				break;
-			}
+			} else if (res == SCSI_SCAN_LUN_IGNORED) 
+				scsi_scan_remove(sdev);
 		}
 	}
 
@@ -1262,6 +1274,8 @@ struct scsi_device *__scsi_add_device(st
 	if (scsi_host_scan_allowed(shost)) {
 		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1,
 					     hostdata);
+		if (res == SCSI_SCAN_LUN_IGNORED)
+			scsi_scan_remove(sdev);
 		if (res != SCSI_SCAN_LUN_PRESENT)
 			sdev = ERR_PTR(-ENODEV);
 	}
@@ -1334,7 +1348,8 @@ void scsi_scan_target(struct device *par
 		/*
 		 * Scan for a specific host/chan/id/lun.
 		 */
-		scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL);
+		res = scsi_probe_and_add_lun(starget, lun, NULL, &sdev,
+					     rescan, NULL);
 		goto out_reap;
 	}
 
@@ -1342,8 +1357,10 @@ void scsi_scan_target(struct device *par
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
-	res = scsi_probe_and_add_lun(starget, 0, &bflags, &sdev, rescan, NULL);
-	if (res == SCSI_SCAN_LUN_PRESENT) {
+	res = scsi_probe_and_add_lun(starget, 0, &bflags, &sdev, rescan,
+				     NULL);
+	WARN_ON(!sdev && res != SCSI_SCAN_NO_RESPONSE);
+	if (sdev && res != SCSI_SCAN_NO_RESPONSE)
 		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
 			/*
 			 * The REPORT LUN did not scan the target,
@@ -1351,20 +1368,12 @@ void scsi_scan_target(struct device *par
 			 */
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
-	}
 	if (sdev)
 		scsi_device_put(sdev);
 
  out_reap:
+	if (res == SCSI_SCAN_LUN_IGNORED)
+		scsi_scan_remove(sdev);
 	/* now determine if the target has any children at all
 	 * and if not, nuke it */
 	scsi_target_reap(starget);
@@ -1540,4 +1549,3 @@ void scsi_free_host_dev(struct scsi_devi
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
-
