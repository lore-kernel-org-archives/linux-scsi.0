From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6] allow REPORT LUN scanning even for LUN 0
	PQ of 3
Date: Thu, 22 Sep 2005 20:33:28 -0500
Message-ID: <1127439208.4818.94.camel@mulgrave>
References: <20050830224316.GA11210@us.ibm.com>
	 <1127272270.5589.57.camel@mulgrave> <20050921221500.GA24993@us.ibm.com>
	 <20050922001035.GA27643@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:64472 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751081AbVIWBdh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 21:33:37 -0400
In-Reply-To: <20050922001035.GA27643@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: hare@suse.de, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-09-21 at 17:10 -0700, Patrick Mansfield wrote:
> I removed the bad "!" on !scsi_device_get(), and the "insmod ./scsi_debug.ko
> max_luns=3' found 2 sd's as expected.

Fixed it.

> But, scsi_debug module count is still at 1. Removing (via delete attr) the
> 2 scsi_debug devices, and module count is still at 1. So probably still a
> missing scsi_device_put(). I'm trying to debug a bit more.

Found it and fixed that too ... missing a put after the find_device.

James

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -587,6 +587,7 @@ static int scsi_probe_lun(struct scsi_de
 	if (sdev->scsi_level >= 2 ||
 	    (sdev->scsi_level == 1 && (inq_result[3] & 0x0f) == 1))
 		sdev->scsi_level++;
+	sdev->sdev_target->scsi_level = sdev->scsi_level;
 
 	return 0;
 }
@@ -771,6 +772,15 @@ static int scsi_add_lun(struct scsi_devi
 	return SCSI_SCAN_LUN_PRESENT;
 }
 
+static inline void scsi_destroy_sdev(struct scsi_device *sdev)
+{
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	transport_destroy_device(&sdev->sdev_gendev);
+	put_device(&sdev->sdev_gendev);
+}
+
+
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
@@ -803,9 +813,9 @@ static int scsi_probe_and_add_lun(struct
 	 * The rescan flag is used as an optimization, the first scan of a
 	 * host adapter calls into here with rescan == 0.
 	 */
-	if (rescan) {
-		sdev = scsi_device_lookup_by_target(starget, lun);
-		if (sdev) {
+	sdev = scsi_device_lookup_by_target(starget, lun);
+	if (sdev) {
+		if (rescan || sdev->sdev_state != SDEV_CREATED) {
 			SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
 				"scsi scan: device exists on %s\n",
 				sdev->sdev_gendev.bus_id));
@@ -820,9 +830,9 @@ static int scsi_probe_and_add_lun(struct
 								 sdev->model);
 			return SCSI_SCAN_LUN_PRESENT;
 		}
-	}
-
-	sdev = scsi_alloc_sdev(starget, lun, hostdata);
+		scsi_device_put(sdev);
+	} else
+		sdev = scsi_alloc_sdev(starget, lun, hostdata);
 	if (!sdev)
 		goto out;
 
@@ -877,12 +887,8 @@ static int scsi_probe_and_add_lun(struct
 				res = SCSI_SCAN_NO_RESPONSE;
 			}
 		}
-	} else {
-		if (sdev->host->hostt->slave_destroy)
-			sdev->host->hostt->slave_destroy(sdev);
-		transport_destroy_device(&sdev->sdev_gendev);
-		put_device(&sdev->sdev_gendev);
-	}
+	} else
+		scsi_destroy_sdev(sdev);
  out:
 	return res;
 }
@@ -1054,7 +1060,7 @@ EXPORT_SYMBOL(int_to_scsilun);
  *     0: scan completed (or no memory, so further scanning is futile)
  *     1: no report lun scan, or not configured
  **/
-static int scsi_report_lun_scan(struct scsi_device *sdev, int bflags,
+static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				int rescan)
 {
 	char devname[64];
@@ -1067,7 +1073,8 @@ static int scsi_report_lun_scan(struct s
 	struct scsi_lun *lunp, *lun_data;
 	u8 *data;
 	struct scsi_sense_hdr sshdr;
-	struct scsi_target *starget = scsi_target(sdev);
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 
 	/*
 	 * Only support SCSI-3 and up devices if BLIST_NOREPORTLUN is not set.
@@ -1075,15 +1082,23 @@ static int scsi_report_lun_scan(struct s
 	 * support more than 8 LUNs.
 	 */
 	if ((bflags & BLIST_NOREPORTLUN) || 
-	     sdev->scsi_level < SCSI_2 ||
-	    (sdev->scsi_level < SCSI_3 && 
-	     (!(bflags & BLIST_REPORTLUN2) || sdev->host->max_lun <= 8)) )
+	     starget->scsi_level < SCSI_2 ||
+	    (starget->scsi_level < SCSI_3 && 
+	     (!(bflags & BLIST_REPORTLUN2) || shost->max_lun <= 8)) )
 		return 1;
 	if (bflags & BLIST_NOLUN)
 		return 0;
 
+	if (!(sdev = scsi_device_lookup_by_target(starget, 0))) {
+		sdev = scsi_alloc_sdev(starget, 0, NULL);
+		if (!sdev)
+			return 0;
+		if (scsi_device_get(sdev))
+			return 0;
+	}
+
 	sprintf(devname, "host %d channel %d id %d",
-		sdev->host->host_no, sdev->channel, sdev->id);
+		shost->host_no, sdev->channel, sdev->id);
 
 	/*
 	 * Allocate enough to hold the header (the same size as one scsi_lun)
@@ -1098,8 +1113,10 @@ static int scsi_report_lun_scan(struct s
 	length = (max_scsi_report_luns + 1) * sizeof(struct scsi_lun);
 	lun_data = kmalloc(length, GFP_ATOMIC |
 			   (sdev->host->unchecked_isa_dma ? __GFP_DMA : 0));
-	if (!lun_data)
+	if (!lun_data) {
+		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 		goto out;
+	}
 
 	scsi_cmd[0] = REPORT_LUNS;
 
@@ -1201,10 +1218,6 @@ static int scsi_report_lun_scan(struct s
 			for (i = 0; i < sizeof(struct scsi_lun); i++)
 				printk("%02x", data[i]);
 			printk(" has a LUN larger than currently supported.\n");
-		} else if (lun == 0) {
-			/*
-			 * LUN 0 has already been scanned.
-			 */
 		} else if (lun > sdev->host->max_lun) {
 			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
 			       " than allowed by the host adapter\n",
@@ -1227,13 +1240,13 @@ static int scsi_report_lun_scan(struct s
 	}
 
 	kfree(lun_data);
-	return 0;
-
  out:
-	/*
-	 * We are out of memory, don't try scanning any further.
-	 */
-	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
+	scsi_device_put(sdev);
+	if (sdev->sdev_state == SDEV_CREATED)
+		/*
+		 * the sdev we used didn't appear in the report luns scan
+		 */
+		scsi_destroy_sdev(sdev);
 	return 0;
 }
 
@@ -1299,7 +1312,6 @@ static void __scsi_scan_target(struct de
 	struct Scsi_Host *shost = dev_to_shost(parent);
 	int bflags = 0;
 	int res;
-	struct scsi_device *sdev = NULL;
 	struct scsi_target *starget;
 
 	if (shost->this_id == id)
@@ -1325,27 +1337,16 @@ static void __scsi_scan_target(struct de
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
-	res = scsi_probe_and_add_lun(starget, 0, &bflags, &sdev, rescan, NULL);
-	if (res == SCSI_SCAN_LUN_PRESENT) {
-		if (scsi_report_lun_scan(sdev, bflags, rescan) != 0)
+	res = scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL);
+	if (res == SCSI_SCAN_LUN_PRESENT || res == SCSI_SCAN_TARGET_PRESENT) {
+		if (scsi_report_lun_scan(starget, bflags, rescan) != 0)
 			/*
 			 * The REPORT LUN did not scan the target,
 			 * do a sequential scan.
 			 */
 			scsi_sequential_lun_scan(starget, bflags,
-				       	res, sdev->scsi_level, rescan);
-	} else if (res == SCSI_SCAN_TARGET_PRESENT) {
-		/*
-		 * There's a target here, but lun 0 is offline so we
-		 * can't use the report_lun scan.  Fall back to a
-		 * sequential lun scan with a bflags of SPARSELUN and
-		 * a default scsi level of SCSI_2
-		 */
-		scsi_sequential_lun_scan(starget, BLIST_SPARSELUN,
-				SCSI_SCAN_TARGET_PRESENT, SCSI_2, rescan);
+				       	res, starget->scsi_level, rescan);
 	}
-	if (sdev)
-		scsi_device_put(sdev);
 
  out_reap:
 	/* now determine if the target has any children at all
@@ -1542,10 +1543,7 @@ void scsi_free_host_dev(struct scsi_devi
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
 
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	scsi_destroy_sdev(sdev);
 }
 EXPORT_SYMBOL(scsi_free_host_dev);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -163,6 +163,7 @@ struct scsi_target {
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
 	unsigned long		create:1; /* signal that it needs to be added */
+	char			scsi_level;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */
 	/* starget_data must be the last element!!!! */


