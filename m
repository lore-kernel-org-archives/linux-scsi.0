From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6 of 6] sd: Support for SCSI disk (SBC) Data Integrity Field
Date: Thu, 17 Jul 2008 04:28:35 -0400
Message-ID: <b63980705ea0919076e8.1216283315@sermon.lab.mkp.net>
References: <patchbomb.1216283309@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:35761 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753616AbYGQIfu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2008 04:35:50 -0400
In-Reply-To: <patchbomb.1216283309@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Support for controllers and disks that implement DIF protection
information:

 - During command preparation the RDPROTECT/WRPROTECT must be set
   correctly if the target has DIF enabled.

 - READ(6) and WRITE(6) are not supported when DIF is on.

 - The controller must be told how to handle the I/O via the
   protection operation field in scsi_cmnd.

 - Refactor the I/O completion code that extracts failed LBA from the
   returned sense data and handle DIF failures correctly.

 - sd_dif.c implements the functions required to prepare and complete
   requests with protection information attached.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
5 files changed, 647 insertions(+), 40 deletions(-)
drivers/scsi/Kconfig  |    1 
drivers/scsi/Makefile |    2 
drivers/scsi/sd.c     |  121 +++++++----
drivers/scsi/sd.h     |   25 ++
drivers/scsi/sd_dif.c |  538 +++++++++++++++++++++++++++++++++++++++++++++++++



diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -63,6 +63,7 @@ config BLK_DEV_SD
 config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
+	select CRC_T10DIF
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -151,6 +151,8 @@ scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_
 scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
 
 sd_mod-objs	:= sd.o
+sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
+
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -374,6 +374,7 @@ static int sd_prep_fn(struct request_que
 	struct scsi_cmnd *SCpnt;
 	struct scsi_device *sdp = q->queuedata;
 	struct gendisk *disk = rq->rq_disk;
+	struct scsi_disk *sdkp;
 	sector_t block = rq->sector;
 	unsigned int this_count = rq->nr_sectors;
 	unsigned int timeout = sdp->timeout;
@@ -390,6 +391,7 @@ static int sd_prep_fn(struct request_que
 	if (ret != BLKPREP_OK)
 		goto out;
 	SCpnt = rq->special;
+	sdkp = scsi_disk(disk);
 
 	/* from here on until we're complete, any goto out
 	 * is used for a killable error condition */
@@ -479,6 +481,11 @@ static int sd_prep_fn(struct request_que
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
+
+		if (blk_integrity_rq(rq) &&
+		    sd_dif_prepare(rq, block, sdp->sector_size) == -EIO)
+			goto out;
+
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
@@ -493,8 +500,12 @@ static int sd_prep_fn(struct request_que
 					"writing" : "reading", this_count,
 					rq->nr_sectors));
 
-	SCpnt->cmnd[1] = 0;
-	
+	/* Set RDPROTECT/WRPROTECT if disk is formatted with DIF */
+	if (scsi_host_dif_capable(sdp->host, sdkp->protection_type))
+		SCpnt->cmnd[1] = 1 << 5;
+	else
+		SCpnt->cmnd[1] = 0;
+
 	if (block > 0xffffffff) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
@@ -512,6 +523,7 @@ static int sd_prep_fn(struct request_que
 		SCpnt->cmnd[13] = (unsigned char) this_count & 0xff;
 		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
 	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
+		   scsi_device_protection(SCpnt->device) ||
 		   SCpnt->device->use_10_for_rw) {
 		if (this_count > 0xffff)
 			this_count = 0xffff;
@@ -545,6 +557,10 @@ static int sd_prep_fn(struct request_que
 		SCpnt->cmnd[5] = 0;
 	}
 	SCpnt->sdb.length = this_count * sdp->sector_size;
+
+	/* If DIF or DIX is enabled, tell HBA how to handle request */
+	if (sdkp->protection_type || scsi_prot_sg_count(SCpnt))
+		sd_dif_op(SCpnt, sdkp->protection_type, scsi_prot_sg_count(SCpnt));
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -940,6 +956,48 @@ static struct block_device_operations sd
 	.revalidate_disk	= sd_revalidate_disk,
 };
 
+static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
+{
+	u64 start_lba = scmd->request->sector;
+	u64 end_lba = scmd->request->sector + (scsi_bufflen(scmd) / 512);
+	u64 bad_lba;
+	int info_valid;
+
+	if (!blk_fs_request(scmd->request))
+		return 0;
+
+	info_valid = scsi_get_sense_info_fld(scmd->sense_buffer,
+					     SCSI_SENSE_BUFFERSIZE,
+					     &bad_lba);
+	if (!info_valid)
+		return 0;
+
+	if (scsi_bufflen(scmd) <= scmd->device->sector_size)
+		return 0;
+
+	if (scmd->device->sector_size < 512) {
+		/* only legitimate sector_size here is 256 */
+		start_lba <<= 1;
+		end_lba <<= 1;
+	} else {
+		/* be careful ... don't want any overflows */
+		u64 factor = scmd->device->sector_size / 512;
+		do_div(start_lba, factor);
+		do_div(end_lba, factor);
+	}
+
+	/* The bad lba was reported incorrectly, we have no idea where
+	 * the error is.
+	 */
+	if (bad_lba < start_lba  || bad_lba >= end_lba)
+		return 0;
+
+	/* This computation should always be done in terms of
+	 * the resolution of the device's medium.
+	 */
+	return (bad_lba - start_lba) * scmd->device->sector_size;
+}
+
 /**
  *	sd_done - bottom half handler: called when the lower level
  *	driver has completed (successfully or otherwise) a scsi command.
@@ -950,15 +1008,10 @@ static int sd_done(struct scsi_cmnd *SCp
 static int sd_done(struct scsi_cmnd *SCpnt)
 {
 	int result = SCpnt->result;
-	unsigned int xfer_size = scsi_bufflen(SCpnt);
- 	unsigned int good_bytes = result ? 0 : xfer_size;
- 	u64 start_lba = SCpnt->request->sector;
-	u64 end_lba = SCpnt->request->sector + (xfer_size / 512);
- 	u64 bad_lba;
+	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	int sense_deferred = 0;
-	int info_valid;
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
@@ -983,36 +1036,7 @@ static int sd_done(struct scsi_cmnd *SCp
 	switch (sshdr.sense_key) {
 	case HARDWARE_ERROR:
 	case MEDIUM_ERROR:
-		if (!blk_fs_request(SCpnt->request))
-			goto out;
-		info_valid = scsi_get_sense_info_fld(SCpnt->sense_buffer,
-						     SCSI_SENSE_BUFFERSIZE,
-						     &bad_lba);
-		if (!info_valid)
-			goto out;
-		if (xfer_size <= SCpnt->device->sector_size)
-			goto out;
-		if (SCpnt->device->sector_size < 512) {
-			/* only legitimate sector_size here is 256 */
-			start_lba <<= 1;
-			end_lba <<= 1;
-		} else {
-			/* be careful ... don't want any overflows */
-			u64 factor = SCpnt->device->sector_size / 512;
-			do_div(start_lba, factor);
-			do_div(end_lba, factor);
-		}
-
-		if (bad_lba < start_lba  || bad_lba >= end_lba)
-			/* the bad lba was reported incorrectly, we have
-			 * no idea where the error is
-			 */
-			goto out;
-
-		/* This computation should always be done in terms of
-		 * the resolution of the device's medium.
-		 */
-		good_bytes = (bad_lba - start_lba)*SCpnt->device->sector_size;
+		good_bytes = sd_completed_bytes(SCpnt);
 		break;
 	case RECOVERED_ERROR:
 	case NO_SENSE:
@@ -1022,10 +1046,23 @@ static int sd_done(struct scsi_cmnd *SCp
 		scsi_print_sense("sd", SCpnt);
 		SCpnt->result = 0;
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
-		good_bytes = xfer_size;
+		good_bytes = scsi_bufflen(SCpnt);
+		break;
+	case ABORTED_COMMAND:
+		if (sshdr.asc == 0x10) { /* DIF: Disk detected corruption */
+			scsi_print_result(SCpnt);
+			scsi_print_sense("sd", SCpnt);
+			good_bytes = sd_completed_bytes(SCpnt);
+		}
 		break;
 	case ILLEGAL_REQUEST:
-		if (SCpnt->device->use_10_for_rw &&
+		if (sshdr.asc == 0x10) { /* DIX: HBA detected corruption */
+			scsi_print_result(SCpnt);
+			scsi_print_sense("sd", SCpnt);
+			good_bytes = sd_completed_bytes(SCpnt);
+		}
+		if (!scsi_device_protection(SCpnt->device) &&
+		    SCpnt->device->use_10_for_rw &&
 		    (SCpnt->cmnd[0] == READ_10 ||
 		     SCpnt->cmnd[0] == WRITE_10))
 			SCpnt->device->use_10_for_rw = 0;
@@ -1038,6 +1075,9 @@ static int sd_done(struct scsi_cmnd *SCp
 		break;
 	}
  out:
+	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
+		sd_dif_complete(SCpnt, good_bytes);
+
 	return good_bytes;
 }
 
@@ -1825,6 +1865,7 @@ static int sd_probe(struct device *dev)
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
+	sd_dif_config_host(sdkp);
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -82,4 +82,29 @@ enum sd_dif_target_protection_types {
 	SD_DIF_TYPE3_PROTECTION = 0x3,
 };
 
+/*
+ * Data Integrity Field tuple.
+ */
+struct sd_dif_tuple {
+       __be16 guard_tag;	/* Checksum */
+       __be16 app_tag;		/* Opaque storage */
+       __be32 ref_tag;		/* Target LBA or indirect LBA */
+};
+
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+
+extern void sd_dif_op(struct scsi_cmnd *, unsigned int, unsigned int);
+extern void sd_dif_config_host(struct scsi_disk *);
+extern int sd_dif_prepare(struct request *rq, sector_t, unsigned int);
+extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
+
+#else /* CONFIG_BLK_DEV_INTEGRITY */
+
+#define sd_dif_op(a, b, c)			do { } while (0)
+#define sd_dif_config_host(a)			do { } while (0)
+#define sd_dif_prepare(a, b, c)			(0)
+#define sd_dif_complete(a, b)			(0)
+
+#endif /* CONFIG_BLK_DEV_INTEGRITY */
+
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
new file mode 100644
--- /dev/null
+++ b/drivers/scsi/sd_dif.c
@@ -0,0 +1,538 @@
+/*
+ * sd_dif.c - SCSI Data Integrity Field
+ *
+ * Copyright (C) 2007, 2008 Oracle Corporation
+ * Written by: Martin K. Petersen <martin.petersen@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
+ * USA.
+ *
+ */
+
+#include <linux/blkdev.h>
+#include <linux/crc-t10dif.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_ioctl.h>
+#include <scsi/scsicam.h>
+
+#include <net/checksum.h>
+
+#include "sd.h"
+
+typedef __u16 (csum_fn) (void *, unsigned int);
+
+static __u16 sd_dif_crc_fn(void *data, unsigned int len)
+{
+	return cpu_to_be16(crc_t10dif(data, len));
+}
+
+static __u16 sd_dif_ip_fn(void *data, unsigned int len)
+{
+	return ip_compute_csum(data, len);
+}
+
+/*
+ * Type 1 and Type 2 protection use the same format: 16 bit guard tag,
+ * 16 bit app tag, 32 bit reference tag.
+ */
+static void sd_dif_type1_generate(struct blk_integrity_exchg *bix, csum_fn *fn)
+{
+	void *buf = bix->data_buf;
+	struct sd_dif_tuple *sdt = bix->prot_buf;
+	sector_t sector = bix->sector;
+	unsigned int i;
+
+	for (i = 0 ; i < bix->data_size ; i += bix->sector_size, sdt++) {
+		sdt->guard_tag = fn(buf, bix->sector_size);
+		sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
+		sdt->app_tag = 0;
+
+		buf += bix->sector_size;
+		sector++;
+	}
+}
+
+static void sd_dif_type1_generate_crc(struct blk_integrity_exchg *bix)
+{
+	sd_dif_type1_generate(bix, sd_dif_crc_fn);
+}
+
+static void sd_dif_type1_generate_ip(struct blk_integrity_exchg *bix)
+{
+	sd_dif_type1_generate(bix, sd_dif_ip_fn);
+}
+
+static int sd_dif_type1_verify(struct blk_integrity_exchg *bix, csum_fn *fn)
+{
+	void *buf = bix->data_buf;
+	struct sd_dif_tuple *sdt = bix->prot_buf;
+	sector_t sector = bix->sector;
+	unsigned int i;
+	__u16 csum;
+
+	for (i = 0 ; i < bix->data_size ; i += bix->sector_size, sdt++) {
+		/* Unwritten sectors */
+		if (sdt->app_tag == 0xffff)
+			return 0;
+
+		/* Bad ref tag received from disk */
+		if (sdt->ref_tag == 0xffffffff) {
+			printk(KERN_ERR
+			       "%s: bad phys ref tag on sector %lu\n",
+			       bix->disk_name, (unsigned long)sector);
+			return -EIO;
+		}
+
+		if (be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
+			printk(KERN_ERR
+			       "%s: ref tag error on sector %lu (rcvd %u)\n",
+			       bix->disk_name, (unsigned long)sector,
+			       be32_to_cpu(sdt->ref_tag));
+			return -EIO;
+		}
+
+		csum = fn(buf, bix->sector_size);
+
+		if (sdt->guard_tag != csum) {
+			printk(KERN_ERR "%s: guard tag error on sector %lu " \
+			       "(rcvd %04x, data %04x)\n", bix->disk_name,
+			       (unsigned long)sector,
+			       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
+			return -EIO;
+		}
+
+		buf += bix->sector_size;
+		sector++;
+	}
+
+	return 0;
+}
+
+static int sd_dif_type1_verify_crc(struct blk_integrity_exchg *bix)
+{
+	return sd_dif_type1_verify(bix, sd_dif_crc_fn);
+}
+
+static int sd_dif_type1_verify_ip(struct blk_integrity_exchg *bix)
+{
+	return sd_dif_type1_verify(bix, sd_dif_ip_fn);
+}
+
+/*
+ * Functions for interleaving and deinterleaving application tags
+ */
+static void sd_dif_type1_set_tag(void *prot, void *tag_buf, unsigned int sectors)
+{
+	struct sd_dif_tuple *sdt = prot;
+	char *tag = tag_buf;
+	unsigned int i, j;
+
+	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
+		sdt->app_tag = tag[j] << 8 | tag[j+1];
+		BUG_ON(sdt->app_tag == 0xffff);
+	}
+}
+
+static void sd_dif_type1_get_tag(void *prot, void *tag_buf, unsigned int sectors)
+{
+	struct sd_dif_tuple *sdt = prot;
+	char *tag = tag_buf;
+	unsigned int i, j;
+
+	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
+		tag[j] = (sdt->app_tag & 0xff00) >> 8;
+		tag[j+1] = sdt->app_tag & 0xff;
+	}
+}
+
+static struct blk_integrity dif_type1_integrity_crc = {
+	.name			= "T10-DIF-TYPE1-CRC",
+	.generate_fn		= sd_dif_type1_generate_crc,
+	.verify_fn		= sd_dif_type1_verify_crc,
+	.get_tag_fn		= sd_dif_type1_get_tag,
+	.set_tag_fn		= sd_dif_type1_set_tag,
+	.tuple_size		= sizeof(struct sd_dif_tuple),
+	.tag_size		= 0,
+};
+
+static struct blk_integrity dif_type1_integrity_ip = {
+	.name			= "T10-DIF-TYPE1-IP",
+	.generate_fn		= sd_dif_type1_generate_ip,
+	.verify_fn		= sd_dif_type1_verify_ip,
+	.get_tag_fn		= sd_dif_type1_get_tag,
+	.set_tag_fn		= sd_dif_type1_set_tag,
+	.tuple_size		= sizeof(struct sd_dif_tuple),
+	.tag_size		= 0,
+};
+
+
+/*
+ * Type 3 protection has a 16-bit guard tag and 16 + 32 bits of opaque
+ * tag space.
+ */
+static void sd_dif_type3_generate(struct blk_integrity_exchg *bix, csum_fn *fn)
+{
+	void *buf = bix->data_buf;
+	struct sd_dif_tuple *sdt = bix->prot_buf;
+	unsigned int i;
+
+	for (i = 0 ; i < bix->data_size ; i += bix->sector_size, sdt++) {
+		sdt->guard_tag = fn(buf, bix->sector_size);
+		sdt->ref_tag = 0;
+		sdt->app_tag = 0;
+
+		buf += bix->sector_size;
+	}
+}
+
+static void sd_dif_type3_generate_crc(struct blk_integrity_exchg *bix)
+{
+	sd_dif_type3_generate(bix, sd_dif_crc_fn);
+}
+
+static void sd_dif_type3_generate_ip(struct blk_integrity_exchg *bix)
+{
+	sd_dif_type3_generate(bix, sd_dif_ip_fn);
+}
+
+static int sd_dif_type3_verify(struct blk_integrity_exchg *bix, csum_fn *fn)
+{
+	void *buf = bix->data_buf;
+	struct sd_dif_tuple *sdt = bix->prot_buf;
+	sector_t sector = bix->sector;
+	unsigned int i;
+	__u16 csum;
+
+	for (i = 0 ; i < bix->data_size ; i += bix->sector_size, sdt++) {
+		/* Unwritten sectors */
+		if (sdt->app_tag == 0xffff && sdt->ref_tag == 0xffffffff)
+			return 0;
+
+		csum = fn(buf, bix->sector_size);
+
+		if (sdt->guard_tag != csum) {
+			printk(KERN_ERR "%s: guard tag error on sector %lu " \
+			       "(rcvd %04x, data %04x)\n", bix->disk_name,
+			       (unsigned long)sector,
+			       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
+			return -EIO;
+		}
+
+		buf += bix->sector_size;
+		sector++;
+	}
+
+	return 0;
+}
+
+static int sd_dif_type3_verify_crc(struct blk_integrity_exchg *bix)
+{
+	return sd_dif_type3_verify(bix, sd_dif_crc_fn);
+}
+
+static int sd_dif_type3_verify_ip(struct blk_integrity_exchg *bix)
+{
+	return sd_dif_type3_verify(bix, sd_dif_ip_fn);
+}
+
+static void sd_dif_type3_set_tag(void *prot, void *tag_buf, unsigned int sectors)
+{
+	struct sd_dif_tuple *sdt = prot;
+	char *tag = tag_buf;
+	unsigned int i, j;
+
+	for (i = 0, j = 0 ; i < sectors ; i++, j += 6, sdt++) {
+		sdt->app_tag = tag[j] << 8 | tag[j+1];
+		sdt->ref_tag = tag[j+2] << 24 | tag[j+3] << 16 |
+			tag[j+4] << 8 | tag[j+5];
+	}
+}
+
+static void sd_dif_type3_get_tag(void *prot, void *tag_buf, unsigned int sectors)
+{
+	struct sd_dif_tuple *sdt = prot;
+	char *tag = tag_buf;
+	unsigned int i, j;
+
+	for (i = 0, j = 0 ; i < sectors ; i++, j += 2, sdt++) {
+		tag[j] = (sdt->app_tag & 0xff00) >> 8;
+		tag[j+1] = sdt->app_tag & 0xff;
+		tag[j+2] = (sdt->ref_tag & 0xff000000) >> 24;
+		tag[j+3] = (sdt->ref_tag & 0xff0000) >> 16;
+		tag[j+4] = (sdt->ref_tag & 0xff00) >> 8;
+		tag[j+5] = sdt->ref_tag & 0xff;
+		BUG_ON(sdt->app_tag == 0xffff || sdt->ref_tag == 0xffffffff);
+	}
+}
+
+static struct blk_integrity dif_type3_integrity_crc = {
+	.name			= "T10-DIF-TYPE3-CRC",
+	.generate_fn		= sd_dif_type3_generate_crc,
+	.verify_fn		= sd_dif_type3_verify_crc,
+	.get_tag_fn		= sd_dif_type3_get_tag,
+	.set_tag_fn		= sd_dif_type3_set_tag,
+	.tuple_size		= sizeof(struct sd_dif_tuple),
+	.tag_size		= 0,
+};
+
+static struct blk_integrity dif_type3_integrity_ip = {
+	.name			= "T10-DIF-TYPE3-IP",
+	.generate_fn		= sd_dif_type3_generate_ip,
+	.verify_fn		= sd_dif_type3_verify_ip,
+	.get_tag_fn		= sd_dif_type3_get_tag,
+	.set_tag_fn		= sd_dif_type3_set_tag,
+	.tuple_size		= sizeof(struct sd_dif_tuple),
+	.tag_size		= 0,
+};
+
+/*
+ * Configure exchange of protection information between OS and HBA.
+ */
+void sd_dif_config_host(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct gendisk *disk = sdkp->disk;
+	u8 type = sdkp->protection_type;
+
+	/* If this HBA doesn't support DIX, resort to normal I/O or DIF */
+	if (scsi_host_dix_capable(sdp->host, type) == 0) {
+
+		if (type == SD_DIF_TYPE0_PROTECTION)
+			return;
+
+		if (scsi_host_dif_capable(sdp->host, type) == 0) {
+			sd_printk(KERN_INFO, sdkp, "Type %d protection " \
+				  "unsupported by HBA. Disabling DIF.\n", type);
+			sdkp->protection_type = 0;
+			return;
+		}
+
+		sd_printk(KERN_INFO, sdkp, "Enabling DIF Type %d protection\n",
+			  type);
+
+		return;
+	}
+
+	/* Enable DMA of protection information */
+	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)
+		if (type == SD_DIF_TYPE3_PROTECTION)
+			blk_integrity_register(disk, &dif_type3_integrity_ip);
+		else
+			blk_integrity_register(disk, &dif_type1_integrity_ip);
+	else
+		if (type == SD_DIF_TYPE3_PROTECTION)
+			blk_integrity_register(disk, &dif_type3_integrity_crc);
+		else
+			blk_integrity_register(disk, &dif_type1_integrity_crc);
+
+	sd_printk(KERN_INFO, sdkp,
+		  "Enabling %s integrity protection\n", disk->integrity->name);
+
+	/* Signal to block layer that we support sector tagging */
+	if (type && sdkp->ATO) {
+		if (type == SD_DIF_TYPE3_PROTECTION)
+			disk->integrity->tag_size = sizeof(u16) + sizeof(u32);
+		else
+			disk->integrity->tag_size = sizeof(u16);
+
+		sd_printk(KERN_INFO, sdkp, "DIF application tag size %u\n",
+			  disk->integrity->tag_size);
+	}
+}
+
+/*
+ * DIF DMA operation magic decoder ring.
+ */
+void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif, unsigned int dix)
+{
+	int csum_convert, prot_op;
+
+	prot_op = 0;
+
+	/* Convert checksum? */
+	if (scsi_host_get_guard(scmd->device->host) != SHOST_DIX_GUARD_CRC)
+		csum_convert = 1;
+	else
+		csum_convert = 0;
+
+	switch (scmd->cmnd[0]) {
+	case READ_10:
+	case READ_12:
+	case READ_16:
+		if (dif && dix)
+			if (csum_convert)
+				prot_op = SCSI_PROT_READ_CONVERT;
+			else
+				prot_op = SCSI_PROT_READ_PASS;
+		else if (dif && !dix)
+			prot_op = SCSI_PROT_READ_STRIP;
+		else if (!dif && dix)
+			prot_op = SCSI_PROT_READ_INSERT;
+
+		break;
+
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+		if (dif && dix)
+			if (csum_convert)
+				prot_op = SCSI_PROT_WRITE_CONVERT;
+			else
+				prot_op = SCSI_PROT_WRITE_PASS;
+		else if (dif && !dix)
+			prot_op = SCSI_PROT_WRITE_INSERT;
+		else if (!dif && dix)
+			prot_op = SCSI_PROT_WRITE_STRIP;
+
+		break;
+	}
+
+	scsi_set_prot_op(scmd, prot_op);
+	scsi_set_prot_type(scmd, dif);
+}
+
+/*
+ * The virtual start sector is the one that was originally submitted
+ * by the block layer.	Due to partitioning, MD/DM cloning, etc. the
+ * actual physical start sector is likely to be different.  Remap
+ * protection information to match the physical LBA.
+ *
+ * From a protocol perspective there's a slight difference between
+ * Type 1 and 2.  The latter uses 32-byte CDBs exclusively, and the
+ * reference tag is seeded in the CDB.  This gives us the potential to
+ * avoid virt->phys remapping during write.  However, at read time we
+ * don't know whether the virt sector is the same as when we wrote it
+ * (we could be reading from real disk as opposed to MD/DM device.  So
+ * we always remap Type 2 making it identical to Type 1.
+ *
+ * Type 3 does not have a reference tag so no remapping is required.
+ */
+int sd_dif_prepare(struct request *rq, sector_t hw_sector, unsigned int sector_sz)
+{
+	const int tuple_sz = sizeof(struct sd_dif_tuple);
+	struct bio *bio;
+	struct scsi_disk *sdkp;
+	struct sd_dif_tuple *sdt;
+	unsigned int i, j;
+	u32 phys, virt;
+
+	/* Already remapped? */
+	if (rq->cmd_flags & REQ_INTEGRITY)
+		return 0;
+
+	sdkp = rq->bio->bi_bdev->bd_disk->private_data;
+
+	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION)
+		return 0;
+
+	rq->cmd_flags |= REQ_INTEGRITY;
+	phys = hw_sector & 0xffffffff;
+
+	__rq_for_each_bio(bio, rq) {
+		struct bio_vec *iv;
+
+		virt = bio->bi_integrity->bip_sector & 0xffffffff;
+
+		bip_for_each_vec(iv, bio->bi_integrity, i) {
+			sdt = kmap_atomic(iv->bv_page, KM_USER0)
+				+ iv->bv_offset;
+
+			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
+
+				if (be32_to_cpu(sdt->ref_tag) != virt)
+					goto error;
+
+				sdt->ref_tag = cpu_to_be32(phys);
+				virt++;
+				phys++;
+			}
+
+			kunmap_atomic(sdt, KM_USER0);
+		}
+	}
+
+	return 0;
+
+error:
+	kunmap_atomic(sdt, KM_USER0);
+	sd_printk(KERN_ERR, sdkp, "%s: virt %u, phys %u, ref %u\n",
+		  __func__, virt, phys, be32_to_cpu(sdt->ref_tag));
+
+	return -EIO;
+}
+
+/*
+ * Remap physical sector values in the reference tag to the virtual
+ * values expected by the block layer.
+ */
+void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
+{
+	const int tuple_sz = sizeof(struct sd_dif_tuple);
+	struct scsi_disk *sdkp;
+	struct bio *bio;
+	struct sd_dif_tuple *sdt;
+	unsigned int i, j, sectors, sector_sz;
+	u32 phys, virt;
+
+	sdkp = scsi_disk(scmd->request->rq_disk);
+
+	if (sdkp->protection_type == SD_DIF_TYPE3_PROTECTION || good_bytes == 0)
+		return;
+
+	sector_sz = scmd->device->sector_size;
+	sectors = good_bytes / sector_sz;
+
+	phys = scmd->request->sector & 0xffffffff;
+	if (sector_sz == 4096)
+		phys >>= 3;
+
+	__rq_for_each_bio(bio, scmd->request) {
+		struct bio_vec *iv;
+
+		virt = bio->bi_integrity->bip_sector & 0xffffffff;
+
+		bip_for_each_vec(iv, bio->bi_integrity, i) {
+			sdt = kmap_atomic(iv->bv_page, KM_USER0)
+				+ iv->bv_offset;
+
+			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
+
+				if (sectors == 0) {
+					kunmap_atomic(sdt, KM_USER0);
+					return;
+				}
+
+				if (be32_to_cpu(sdt->ref_tag) != phys &&
+				    sdt->app_tag != 0xffff)
+					sdt->ref_tag = 0xffffffff; /* Bad ref */
+				else
+					sdt->ref_tag = cpu_to_be32(virt);
+
+				virt++;
+				phys++;
+				sectors--;
+			}
+
+			kunmap_atomic(sdt, KM_USER0);
+		}
+	}
+}
+


