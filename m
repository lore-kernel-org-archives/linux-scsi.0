From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [RFC] Quiesce disk revalidate
Date: Sun, 04 Jan 2009 03:11:24 -0500
Message-ID: <yq1r63j4hjn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet14.oracle.com ([148.87.113.126]:53721 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZADIMo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 03:12:44 -0500
Received: from rgminet13.oracle.com (rcsinet13.oracle.com [148.87.113.125])
	by rgminet14.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n048DeFm002010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sun, 4 Jan 2009 08:14:48 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org


sd_revalidate ends up being called several times during device setup.
With this patch we print everything during the first scan.  Subsequent
invocations will only print a message if the parameter in question has
actually changed (LUN capacity has increased, etc.).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1424,6 +1424,7 @@ sd_read_capacity(struct scsi_disk *sdkp,
 {
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
+	sector_t old_capacity = sdkp->capacity;
 
 	if (scsi_device_protection(sdp) || sdp->scsi_level > SCSI_SPC_2) {
 		sector_size = read_capacity_16(sdkp, sdp, buffer);
@@ -1511,10 +1512,11 @@ got_data:
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
@@ -1551,6 +1553,7 @@ sd_read_write_protect_flag(struct scsi_d
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
+	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
 	if (sdp->skip_ms_page_3f) {
@@ -1591,8 +1594,9 @@ sd_read_write_protect_flag(struct scsi_d
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
-		sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-			  sdkp->write_prot ? "on" : "off");
+		if (sdkp->first_scan || old_wp != sdkp->write_prot)
+			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
+				  sdkp->write_prot ? "on" : "off");
 		sd_printk(KERN_DEBUG, sdkp,
 			  "Mode Sense: %02x %02x %02x %02x\n",
 			  buffer[0], buffer[1], buffer[2], buffer[3]);
@@ -1613,6 +1617,9 @@ sd_read_cache_type(struct scsi_disk *sdk
 	int modepage;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	int old_wce = sdkp->WCE;
+	int old_rcd = sdkp->RCD;
+	int old_dpofua = sdkp->DPOFUA;
 
 	if (sdp->skip_ms_page_8)
 		goto defaults;
@@ -1684,12 +1691,14 @@ sd_read_cache_type(struct scsi_disk *sdk
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
@@ -1785,15 +1794,6 @@ static int sd_revalidate_disk(struct gen
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
@@ -1806,6 +1806,8 @@ static int sd_revalidate_disk(struct gen
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
 	}
+
+	sdkp->first_scan = 0;
 
 	/*
 	 * We now have all cache related info, determine how we deal
@@ -1963,6 +1965,16 @@ static int sd_probe(struct device *dev)
 	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
 	gd->queue = sdkp->device->request_queue;
+
+	/* defaults, until the device tells us otherwise */
+	sdp->sector_size = 512;
+	sdkp->capacity = 0;
+	sdkp->media_present = 1;
+	sdkp->write_prot = 0;
+	sdkp->WCE = 0;
+	sdkp->RCD = 0;
+	sdkp->ATO = 0;
+	sdkp->first_scan = 1;
 
 	sd_revalidate_disk(gd);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -53,6 +53,7 @@ struct scsi_disk {
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
+	unsigned	first_scan : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
