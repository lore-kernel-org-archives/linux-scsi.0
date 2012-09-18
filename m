From: Hannes Reinecke <hare@suse.de>
Subject: Kernel crash with unsupported DIF protection type
Date: Tue, 18 Sep 2012 11:04:36 +0200
Message-ID: <50583924.90708@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000305070609040305000000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140Ab2IRJEi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Sep 2012 05:04:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This is a multi-part message in MIME format.
--------------000305070609040305000000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi all,

I recently got my hands on some weird drives, insisting on having
been formatted with protection type 7:

# sg_readcap --16 /dev/sdb
Read Capacity results:
   Protection: prot_en=1, p_type=6, p_i_exponent=0
   Logical block provisioning: lbpme=0, lbprz=0
   Last logical block address=1758174767 (0x68cb9e2f), Number of
logical blocks=1758174768
   Logical block length=512 bytes
   Logical blocks per physical block exponent=0
   Lowest aligned logical block address=0
Hence:
   Device size: 900185481216 bytes, 858483.8 MiB, 900.19 GB

(I know. I've already complained.)
However, this drive causes a horrible crash:

sd 0:0:1:0: [sdb] formatted with unsupported protection type 7.
Disabling disk!
sd 0:0:1:0: [sdb] 1758174768 512-byte logical blocks: (900
GB/838 GiB)
sd 0:0:1:0: [sdb]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
sd 0:0:1:0: [sdb]  Sense Key : Medium Error [current]
sd 0:0:1:0: [sdb]  Add. Sense: Medium format corrupted
sd 0:0:1:0: [sdb] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sdb, sector 0
Buffer I/O error on device sdb, logical block 0

[ tons and tons of I/O errors ]

[   15.551689] sd 0:0:1:0: [sdb] Enabling DIX T10-DIF-TYPE1-CRC
protection
[   15.561353] ------------[ cut here ]------------
[   15.569416] kernel BUG at
/usr/src/linux-3.0/drivers/scsi/scsi_lib.c:1069!

There are several odd things happening here:
- It says 'Disabling disk', which _should_ have set the
  capacity to '0':

drivers/scsi/sd.c:sd_read_protection_type()
	if (type > SD_DIF_TYPE3_PROTECTION) {
		sd_printk(KERN_ERR, sdkp, "formatted with unsupported "	\
			  "protection type %u. Disabling disk!\n", type);
		sdkp->capacity = 0;
		return;
	}

- it enables type 1 protection, which it evidently is not.

I've attached a tentative patch, which allows the system to boot.
However, I'm not completely happy with that, as the capacity is
_still_ updated after revalidation:

sd 0:0:1:0: [sdb] formatted with unsupported protection type 7.
Disabling disk!
sd 0:0:1:0: [sdb] 0 512-byte logical blocks: (0 B/0 B)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: cf 00 10 08
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled,
supports DPO and FUA
sd 0:0:1:0: [sdb] 1758174768 512-byte logical blocks: (900 GB/838 GiB)
sd 0:0:1:0: [sdb] Attached SCSI disk

Thoughts?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)


--------------000305070609040305000000
Content-Type: text/x-patch;
 name="sd-disable-disk-with-incorrect-protection-information.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="sd-disable-disk-with-incorrect-protection-information.patch"

>From 88f73f9e3c9e9aaa6af73885db9c6230edab6fe0 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Tue, 18 Sep 2012 10:37:52 +0200
Subject: [PATCH] sd: disable disk with incorrect protection information

SPC-3 only defines DIF protection up to type 3.
Other types are invalid and the drive cannot be used.
So make sure to disable the drive correctly by setting
the capacity to 0.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..6a0b216 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1671,26 +1671,25 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 /*
  * Determine whether disk supports Data Integrity Field.
  */
-static void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
+static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	struct scsi_device *sdp = sdkp->device;
 	u8 type;
 
 	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0)
-		return;
+		return 0;
 
 	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 
 	if (type == sdkp->protection_type || !sdkp->first_scan)
-		return;
+		return 0;
 
 	sdkp->protection_type = type;
 
 	if (type > SD_DIF_TYPE3_PROTECTION) {
 		sd_printk(KERN_ERR, sdkp, "formatted with unsupported "	\
 			  "protection type %u. Disabling disk!\n", type);
-		sdkp->capacity = 0;
-		return;
+		return -EINVAL;
 	}
 
 	if (scsi_host_dif_capable(sdp->host, type))
@@ -1699,6 +1698,7 @@ static void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffe
 	else
 		sd_printk(KERN_NOTICE, sdkp,
 			  "Disabling DIF Type %u protection\n", type);
+	return 0;
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
@@ -1794,8 +1794,6 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	sector_size = get_unaligned_be32(&buffer[8]);
 	lba = get_unaligned_be64(&buffer[0]);
 
-	sd_read_protection_type(sdkp, buffer);
-
 	if ((sizeof(sdkp->capacity) == 4) && (lba >= 0xffffffffULL)) {
 		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
 			"kernel compiled with support for large block "
@@ -1804,6 +1802,12 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		return -EOVERFLOW;
 	}
 
+	if (sd_read_protection_type(sdkp, buffer))
+		/* Invalid or unhandled protection type */
+		sdkp->capacity = 0;
+	else
+		sdkp->capacity = lba + 1;
+
 	/* Logical blocks per physical block exponent */
 	sdkp->physical_block_size = (1 << (buffer[13] & 0xf)) * sector_size;
 
@@ -1823,7 +1827,6 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		sd_config_discard(sdkp, SD_LBP_WS16);
 	}
 
-	sdkp->capacity = lba + 1;
 	return sector_size;
 }
 
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index e52d5bc..1b15b51 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -320,7 +320,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 		dif = 0; dix = 1;
 	}
 
-	if (!dix)
+	if (!dix || type > SD_DIF_TYPE3_PROTECTION)
 		return;
 
 	/* Enable DMA of protection information */

--------------000305070609040305000000--
