From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Kernel crash with unsupported DIF protection type
Date: Thu, 20 Sep 2012 15:53:47 -0400
Message-ID: <yq14nmslbck.fsf@sermon.lab.mkp.net>
References: <50583924.90708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:22388 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2ITTyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2012 15:54:04 -0400
In-Reply-To: <50583924.90708@suse.de> (Hannes Reinecke's message of "Tue, 18
	Sep 2012 11:04:36 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> I recently got my hands on some weird drives, insisting on
Hannes> having been formatted with protection type 7:

Lovely :|


Hannes> I've attached a tentative patch, which allows the system to
Hannes> boot.  However, I'm not completely happy with that, as the
Hannes> capacity is _still_ updated after revalidation:

How about this?


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
index 1cf2d5d..1c54564 100644
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
