From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Kernel crash with unsupported DIF protection type
Date: Fri, 21 Sep 2012 12:44:12 -0400
Message-ID: <yq1d31fjpgj.fsf@sermon.lab.mkp.net>
References: <50583924.90708@suse.de> <yq14nmslbck.fsf@sermon.lab.mkp.net>
	<505C76D1.6020506@suse.de> <yq1haqrjr8w.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:48230 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab2IUQoX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Sep 2012 12:44:23 -0400
In-Reply-To: <yq1haqrjr8w.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Fri, 21 Sep 2012 12:05:35 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:

Martin> Updated patch below...

This time without mangled closing bracket...


sd: Ensure we correctly disable devices with unknown protection type

We set the capacity to zero when we discovered a device formatted with
an unknown DIF protection type. However, the read_capacity code would
override the capacity and cause the device to be enabled regardless.

Make sd_read_protection_type() return an error if the protection type is
unknown. Also prevent duplicate printk lines when the device is being
revalidated.

Reported-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1cf2d5d..7a22db3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1820,34 +1820,42 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 /*
  * Determine whether disk supports Data Integrity Field.
  */
-static void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
+static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdp = sdkp->device;
 	u8 type;
+	int ret = 0;
 
 	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0)
-		return;
+		return ret;
 
 	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 
-	if (type == sdkp->protection_type || !sdkp->first_scan)
-		return;
+	if (type > SD_DIF_TYPE3_PROTECTION)
+		ret = -ENODEV;
+	else if (scsi_host_dif_capable(sdp->host, type))
+		ret = 1;
+
+	if (sdkp->first_scan || type != sdkp->protection_type)
+		switch (ret) {
+		case -ENODEV:
+			sd_printk(KERN_ERR, sdkp, "formatted with unsupported" \
+				  " protection type %u. Disabling disk!\n",
+				  type);
+			break;
+		case 1:
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Enabling DIF Type %u protection\n", type);
+			break;
+		case 0:
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Disabling DIF Type %u protection\n", type);
+			break;
+		}
 
 	sdkp->protection_type = type;
 
-	if (type > SD_DIF_TYPE3_PROTECTION) {
-		sd_printk(KERN_ERR, sdkp, "formatted with unsupported "	\
-			  "protection type %u. Disabling disk!\n", type);
-		sdkp->capacity = 0;
-		return;
-	}
-
-	if (scsi_host_dif_capable(sdp->host, type))
-		sd_printk(KERN_NOTICE, sdkp,
-			  "Enabling DIF Type %u protection\n", type);
-	else
-		sd_printk(KERN_NOTICE, sdkp,
-			  "Disabling DIF Type %u protection\n", type);
+	return ret;
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
@@ -1943,7 +1951,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	sector_size = get_unaligned_be32(&buffer[8]);
 	lba = get_unaligned_be64(&buffer[0]);
 
-	sd_read_protection_type(sdkp, buffer);
+	if (sd_read_protection_type(sdkp, buffer) < 0) {
+		sdkp->capacity = 0;
+		return -ENODEV;
+	}
 
 	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
@@ -2788,7 +2799,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	}
 
 	add_disk(gd);
-	sd_dif_config_host(sdkp);
+	if (sdkp->capacity)
+		sd_dif_config_host(sdkp);
 
 	sd_revalidate_disk(gd);
 
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 5f7d5b3..4908480 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -873,6 +873,9 @@ static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsign
 				       SHOST_DIF_TYPE2_PROTECTION,
 				       SHOST_DIF_TYPE3_PROTECTION };
 
+	if (target_type > SHOST_DIF_TYPE3_PROTECTION)
+		return 0;
+
 	return shost->prot_capabilities & cap[target_type] ? target_type : 0;
 }
 
@@ -884,6 +887,9 @@ static inline unsigned int scsi_host_dix_capable(struct Scsi_Host *shost, unsign
 				       SHOST_DIX_TYPE2_PROTECTION,
 				       SHOST_DIX_TYPE3_PROTECTION };
 
+	if (target_type > SHOST_DIX_TYPE3_PROTECTION)
+		return 0;
+
 	return shost->prot_capabilities & cap[target_type];
 #endif
 	return 0;
