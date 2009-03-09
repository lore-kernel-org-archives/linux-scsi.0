From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Make revalidate less chatty
Date: Mon, 09 Mar 2009 11:33:31 -0400
Message-ID: <yq1y6veyalw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:55878 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZCIPdk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2009 11:33:40 -0400
Received: from acsinet13.oracle.com (acsinet13.oracle.com [141.146.126.235])
	by rgminet11.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n29FaMRw026556
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Mon, 9 Mar 2009 15:36:23 GMT
Received: from acsmt706.oracle.com (acsmt706.oracle.com [141.146.40.84])
	by acsinet13.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n29FXmOB029758
	for <linux-scsi@vger.kernel.org>; Mon, 9 Mar 2009 15:33:49 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


sd_revalidate ends up being called several times during device setup.
With this patch we print everything during the first scan.  Subsequent
invocations will only print a message if the parameter in question has
actually changed (LUN capacity has increased, etc.).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 158fc21..62564f0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1434,6 +1434,7 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
+	sector_t old_capacity = sdkp->capacity;
 
 	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, buffer);
@@ -1521,10 +1522,11 @@ got_data:
 		string_get_size(sz, STRING_UNITS_10, cap_str_10,
 				sizeof(cap_str_10));
 
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%llu %d-byte hardware sectors: (%s/%s)\n",
-			  (unsigned long long)sdkp->capacity,
-			  sector_size, cap_str_10, cap_str_2);
+		if (sdkp->first_scan || old_capacity != sdkp->capacity)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "%llu %d-byte hardware sectors: (%s/%s)\n",
+				  (unsigned long long)sdkp->capacity,
+				  sector_size, cap_str_10, cap_str_2);
 	}
 
 	/* Rescale capacity to 512-byte units */
@@ -1561,6 +1563,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
+	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
 	if (sdp->skip_ms_page_3f) {
@@ -1601,11 +1604,13 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
-		sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-			  sdkp->write_prot ? "on" : "off");
-		sd_printk(KERN_DEBUG, sdkp,
-			  "Mode Sense: %02x %02x %02x %02x\n",
-			  buffer[0], buffer[1], buffer[2], buffer[3]);
+		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
+			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
+				  sdkp->write_prot ? "on" : "off");
+			sd_printk(KERN_DEBUG, sdkp,
+				  "Mode Sense: %02x %02x %02x %02x\n",
+				  buffer[0], buffer[1], buffer[2], buffer[3]);
+		}
 	}
 }
 
@@ -1623,6 +1628,9 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 	int modepage;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	int old_wce = sdkp->WCE;
+	int old_rcd = sdkp->RCD;
+	int old_dpofua = sdkp->DPOFUA;
 
 	if (sdp->skip_ms_page_8)
 		goto defaults;
@@ -1694,12 +1702,14 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 			sdkp->DPOFUA = 0;
 		}
 
-		sd_printk(KERN_NOTICE, sdkp,
-		       "Write cache: %s, read cache: %s, %s\n",
-		       sdkp->WCE ? "enabled" : "disabled",
-		       sdkp->RCD ? "disabled" : "enabled",
-		       sdkp->DPOFUA ? "supports DPO and FUA"
-		       : "doesn't support DPO or FUA");
+		if (sdkp->first_scan || old_wce != sdkp->WCE ||
+		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Write cache: %s, read cache: %s, %s\n",
+				  sdkp->WCE ? "enabled" : "disabled",
+				  sdkp->RCD ? "disabled" : "enabled",
+				  sdkp->DPOFUA ? "supports DPO and FUA"
+				  : "doesn't support DPO or FUA");
 
 		return;
 	}
@@ -1795,15 +1805,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		goto out;
 	}
 
-	/* defaults, until the device tells us otherwise */
-	sdp->sector_size = 512;
-	sdkp->capacity = 0;
-	sdkp->media_present = 1;
-	sdkp->write_prot = 0;
-	sdkp->WCE = 0;
-	sdkp->RCD = 0;
-	sdkp->ATO = 0;
-
 	sd_spinup_disk(sdkp);
 
 	/*
@@ -1817,6 +1818,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_app_tag_own(sdkp, buffer);
 	}
 
+	sdkp->first_scan = 0;
+
 	/*
 	 * We now have all cache related info, determine how we deal
 	 * with ordered requests.  Note that as the current SCSI
@@ -1927,6 +1930,16 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
 
+	/* defaults, until the device tells us otherwise */
+	sdp->sector_size = 512;
+	sdkp->capacity = 0;
+	sdkp->media_present = 1;
+	sdkp->write_prot = 0;
+	sdkp->WCE = 0;
+	sdkp->RCD = 0;
+	sdkp->ATO = 0;
+	sdkp->first_scan = 1;
+
 	sd_revalidate_disk(gd);
 
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 75638e7..708778c 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -53,6 +53,7 @@ struct scsi_disk {
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
+	unsigned	first_scan : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
