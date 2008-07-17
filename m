From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5 of 6] sd: Identify DIF protection type and application tag
	ownership
Date: Thu, 17 Jul 2008 04:28:34 -0400
Message-ID: <5c990b75cc65fdf93000.1216283314@sermon.lab.mkp.net>
References: <patchbomb.1216283309@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:35760 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbYGQIfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 04:35:50 -0400
In-Reply-To: <patchbomb.1216283309@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

If a disk is formatted with protection information (Inquiry bit
PROTECT=1) it is required to support Read Capacity(16).  Force use of
the 16-bit command in this case and extract the P_TYPE field which
indicates whether the disk is formatted using DIF Type 1, 2 or 3.

The ATO (App Tag Own) bit in the Control Mode Page indicates whether
the storage device or the initiator own the contents of the
DIF application tag.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 141 insertions(+), 4 deletions(-)
drivers/scsi/sd.c |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++--
drivers/scsi/sd.h |   23 +++++++++



diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -234,6 +234,24 @@ sd_show_allow_restart(struct device *dev
 	return snprintf(buf, 40, "%d\n", sdkp->device->allow_restart);
 }
 
+static ssize_t
+sd_show_protection_type(struct device *dev, struct device_attribute *attr,
+			char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->protection_type);
+}
+
+static ssize_t
+sd_show_app_tag_own(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->ATO);
+}
+
 static struct device_attribute sd_disk_attrs[] = {
 	__ATTR(cache_type, S_IRUGO|S_IWUSR, sd_show_cache_type,
 	       sd_store_cache_type),
@@ -242,6 +260,8 @@ static struct device_attribute sd_disk_a
 	       sd_store_allow_restart),
 	__ATTR(manage_start_stop, S_IRUGO|S_IWUSR, sd_show_manage_start_stop,
 	       sd_store_manage_start_stop),
+	__ATTR(protection_type, S_IRUGO, sd_show_protection_type, NULL),
+	__ATTR(app_tag_own, S_IRUGO, sd_show_app_tag_own, NULL),
 	__ATTR_NULL,
 };
 
@@ -1165,6 +1185,49 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	}
 }
 
+
+/*
+ * Determine whether disk supports Data Integrity Field.
+ */
+void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	struct scsi_device *sdp = sdkp->device;
+	u8 type;
+
+	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0)
+		type = 0;
+	else
+		type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
+
+	switch (type) {
+	case SD_DIF_TYPE0_PROTECTION:
+		sdkp->protection_type = 0;
+		break;
+
+	case SD_DIF_TYPE1_PROTECTION:
+	case SD_DIF_TYPE3_PROTECTION:
+		sdkp->protection_type = type;
+		break;
+
+	case SD_DIF_TYPE2_PROTECTION:
+		sd_printk(KERN_ERR, sdkp, "formatted with DIF Type 2 "	\
+			  "protection which is currently unsupported. "	\
+			  "Disabling disk!\n");
+		goto disable;
+
+	default:
+		sd_printk(KERN_ERR, sdkp, "formatted with unknown "	\
+			  "protection type %d. Disabling disk!\n", type);
+		goto disable;
+	}
+
+	return;
+
+disable:
+	sdkp->protection_type = 0;
+	sdkp->capacity = 0;
+}
+
 /*
  * read disk capacity
  */
@@ -1174,7 +1237,8 @@ sd_read_capacity(struct scsi_disk *sdkp,
 	unsigned char cmd[16];
 	int the_result, retries;
 	int sector_size = 0;
-	int longrc = 0;
+	/* Force READ CAPACITY(16) when PROTECT=1 */
+	int longrc = scsi_device_protection(sdkp->device) ? 1 : 0;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	struct scsi_device *sdp = sdkp->device;
@@ -1186,8 +1250,8 @@ repeat:
 			memset((void *) cmd, 0, 16);
 			cmd[0] = SERVICE_ACTION_IN;
 			cmd[1] = SAI_READ_CAPACITY_16;
-			cmd[13] = 12;
-			memset((void *) buffer, 0, 12);
+			cmd[13] = 13;
+			memset((void *) buffer, 0, 13);
 		} else {
 			cmd[0] = READ_CAPACITY;
 			memset((void *) &cmd[1], 0, 9);
@@ -1195,7 +1259,7 @@ repeat:
 		}
 		
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					      buffer, longrc ? 12 : 8, &sshdr,
+					      buffer, longrc ? 13 : 8, &sshdr,
 					      SD_TIMEOUT, SD_MAX_RETRIES);
 
 		if (media_not_present(sdkp, &sshdr))
@@ -1270,6 +1334,8 @@ repeat:
 			
 		sector_size = (buffer[8] << 24) |
 			(buffer[9] << 16) | (buffer[10] << 8) | buffer[11];
+
+		sd_read_protection_type(sdkp, buffer);
 	}	
 
 	/* Some devices return the total number of sectors, not the
@@ -1531,6 +1597,52 @@ defaults:
 	sdkp->DPOFUA = 0;
 }
 
+/*
+ * The ATO bit indicates whether the DIF application tag is available
+ * for use by the operating system.
+ */
+void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	int res, offset;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_mode_data data;
+	struct scsi_sense_hdr sshdr;
+
+	if (sdp->type != TYPE_DISK)
+		return;
+
+	if (sdkp->protection_type == 0)
+		return;
+
+	res = scsi_mode_sense(sdp, 1, 0x0a, buffer, 36, SD_TIMEOUT,
+			      SD_MAX_RETRIES, &data, &sshdr);
+
+	if (!scsi_status_is_good(res) || !data.header_length ||
+	    data.length < 6) {
+		sd_printk(KERN_WARNING, sdkp,
+			  "getting Control mode page failed, assume no ATO\n");
+
+		if (scsi_sense_valid(&sshdr))
+			sd_print_sense_hdr(sdkp, &sshdr);
+
+		return;
+	}
+
+	offset = data.header_length + data.block_descriptor_length;
+
+	if ((buffer[offset] & 0x3f) != 0x0a) {
+		sd_printk(KERN_ERR, sdkp, "ATO Got wrong page\n");
+		return;
+	}
+
+	if ((buffer[offset + 5] & 0x80) == 0)
+		return;
+
+	sdkp->ATO = 1;
+
+	return;
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -1567,6 +1679,7 @@ static int sd_revalidate_disk(struct gen
 	sdkp->write_prot = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
+	sdkp->ATO = 0;
 
 	sd_spinup_disk(sdkp);
 
@@ -1578,6 +1691,7 @@ static int sd_revalidate_disk(struct gen
 		sd_read_capacity(sdkp, buffer);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
+		sd_read_app_tag_own(sdkp, buffer);
 	}
 
 	/*
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -41,7 +41,9 @@ struct scsi_disk {
 	u32		index;
 	u8		media_present;
 	u8		write_prot;
+	u8		protection_type;/* Data Integrity Field */
 	unsigned	previous_state : 1;
+	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
@@ -59,4 +61,25 @@ static inline struct scsi_disk *scsi_dis
 		    (sdsk)->disk->disk_name, ##a) :			\
 	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
 
+/*
+ * A DIF-capable target device can be formatted with different
+ * protection schemes.  Currently 0 through 3 are defined:
+ *
+ * Type 0 is regular (unprotected) I/O
+ *
+ * Type 1 defines the contents of the guard and reference tags
+ *
+ * Type 2 defines the contents of the guard and reference tags and
+ * uses 32-byte commands to seed the latter
+ *
+ * Type 3 defines the contents of the guard tag only
+ */
+
+enum sd_dif_target_protection_types {
+	SD_DIF_TYPE0_PROTECTION = 0x0,
+	SD_DIF_TYPE1_PROTECTION = 0x1,
+	SD_DIF_TYPE2_PROTECTION = 0x2,
+	SD_DIF_TYPE3_PROTECTION = 0x3,
+};
+
 #endif /* _SCSI_DISK_H */


