From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: sd: Make revalidate less chatty
Date: Wed, 01 Oct 2008 01:38:15 -0400
Message-ID: <yq1ej30kh88.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:44028 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbYJAFiV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 01:38:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@hansenpartnership.com


sd_revalidate ends up being called several times during device setup.
With this patch we print everything during the first scan.  Subsequent
invocations will only print a message if the parameter in question has
actually changed (LUN capacity has increased, etc.).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1356,6 +1356,7 @@ sd_read_capacity(struct scsi_disk *sdkp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	struct scsi_device *sdp = sdkp->device;
+	sector_t old_capacity = sdkp->capacity;
 
 repeat:
 	retries = 3;
@@ -1512,10 +1513,12 @@ got_data:
 		mb -= sz - 974;
 		sector_div(mb, 1950);
 
-		sd_printk(KERN_NOTICE, sdkp,
-			  "%llu %d-byte hardware sectors (%llu MB)\n",
-			  (unsigned long long)sdkp->capacity,
-			  hard_sector, (unsigned long long)mb);
+		/* Only print first time and if capacity changes */
+		if (sdkp->verbose || old_capacity != sdkp->capacity)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "%llu %d-byte hardware sectors (%llu MB)\n",
+				  (unsigned long long)sdkp->capacity,
+				  hard_sector, (unsigned long long)mb);
 	}
 
 	/* Rescale capacity to 512-byte units */
@@ -1552,6 +1555,7 @@ sd_read_write_protect_flag(struct scsi_d
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
+	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
 	if (sdp->skip_ms_page_3f) {
@@ -1592,8 +1596,9 @@ sd_read_write_protect_flag(struct scsi_d
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
-		sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-			  sdkp->write_prot ? "on" : "off");
+		if (sdkp->verbose || old_wp != sdkp->write_prot)
+			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
+				  sdkp->write_prot ? "on" : "off");
 		sd_printk(KERN_DEBUG, sdkp,
 			  "Mode Sense: %02x %02x %02x %02x\n",
 			  buffer[0], buffer[1], buffer[2], buffer[3]);
@@ -1614,6 +1619,9 @@ sd_read_cache_type(struct scsi_disk *sdk
 	int modepage;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	int old_wce = sdkp->WCE;
+	int old_rcd = sdkp->RCD;
+	int old_dpofua = sdkp->DPOFUA;
 
 	if (sdp->skip_ms_page_8)
 		goto defaults;
@@ -1685,12 +1693,14 @@ sd_read_cache_type(struct scsi_disk *sdk
 			sdkp->DPOFUA = 0;
 		}
 
-		sd_printk(KERN_NOTICE, sdkp,
-		       "Write cache: %s, read cache: %s, %s\n",
-		       sdkp->WCE ? "enabled" : "disabled",
-		       sdkp->RCD ? "disabled" : "enabled",
-		       sdkp->DPOFUA ? "supports DPO and FUA"
-		       : "doesn't support DPO or FUA");
+		if (sdkp->verbose || old_wce != sdkp->WCE ||
+		    old_rcd != sdkp->RCD || old_dpofua != sdkp->DPOFUA)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Write cache: %s, read cache: %s, %s\n",
+				  sdkp->WCE ? "enabled" : "disabled",
+				  sdkp->RCD ? "disabled" : "enabled",
+				  sdkp->DPOFUA ? "supports DPO and FUA"
+				  : "doesn't support DPO or FUA");
 
 		return;
 	}
@@ -1786,15 +1796,6 @@ static int sd_revalidate_disk(struct gen
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
@@ -1807,6 +1808,8 @@ static int sd_revalidate_disk(struct gen
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
 	}
+
+	sdkp->verbose = 0;
 
 	/*
 	 * We now have all cache related info, determine how we deal
@@ -1929,6 +1932,16 @@ static int sd_probe(struct device *dev)
 
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
+	sdkp->verbose = 1;
 
 	sd_revalidate_disk(gd);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -53,6 +53,7 @@ struct scsi_disk {
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
+	unsigned	verbose : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 

