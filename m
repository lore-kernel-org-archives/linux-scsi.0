From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] Quiesce disk revalidate
Date: Wed, 11 Feb 2009 10:47:10 -0500
Message-ID: <yq11vu5rn5t.fsf@sermon.lab.mkp.net>
References: <yq1r63j4hjn.fsf@sermon.lab.mkp.net>
	<1232893249.4586.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:45137 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbZBKPrW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Feb 2009 10:47:22 -0500
In-Reply-To: <1232893249.4586.6.camel@localhost.localdomain> (James Bottomley's message of "Sun\, 25 Jan 2009 08\:20\:49 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org


sd_revalidate ends up being called several times during device setup.
With this patch we print everything during the first scan.  Subsequent
invocations will only print a message if the parameter in question has
actually changed (LUN capacity has increased, etc.).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1290,6 +1290,7 @@ sd_read_capacity(struct scsi_disk *sdkp,
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	struct scsi_device *sdp = sdkp->device;
+	sector_t old_capacity = sdkp->capacity;
 
 repeat:
 	retries = 3;
@@ -1440,10 +1441,11 @@ got_data:
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
@@ -1480,6 +1482,7 @@ sd_read_write_protect_flag(struct scsi_d
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
+	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
 	if (sdp->skip_ms_page_3f) {
@@ -1520,11 +1523,13 @@ sd_read_write_protect_flag(struct scsi_d
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
 
@@ -1542,6 +1547,9 @@ sd_read_cache_type(struct scsi_disk *sdk
 	int modepage;
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
+	int old_wce = sdkp->WCE;
+	int old_rcd = sdkp->RCD;
+	int old_dpofua = sdkp->DPOFUA;
 
 	if (sdp->skip_ms_page_8)
 		goto defaults;
@@ -1613,12 +1621,14 @@ sd_read_cache_type(struct scsi_disk *sdk
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
@@ -1714,15 +1724,6 @@ static int sd_revalidate_disk(struct gen
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
@@ -1736,6 +1737,8 @@ static int sd_revalidate_disk(struct gen
 		sd_read_app_tag_own(sdkp, buffer);
 	}
 
+	sdkp->first_scan = 0;
+
 	/*
 	 * We now have all cache related info, determine how we deal
 	 * with ordered requests.  Note that as the current SCSI
@@ -1846,6 +1849,16 @@ static void sd_probe_async(void *data, a
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
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -53,6 +53,7 @@ struct scsi_disk {
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
+	unsigned	first_scan : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 

