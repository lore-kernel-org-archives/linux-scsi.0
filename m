From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7 of 7] Support for SCSI disk (SBC) Data Integrity Field
Date: Sat, 07 Jun 2008 00:55:40 -0400
Message-ID: <8bc1728dc75a3e55e1f9.1212814540@sermon.lab.mkp.net>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:38422 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYFGE5p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jun 2008 00:57:45 -0400
In-Reply-To: <patchbomb.1212814533@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

12 files changed, 935 insertions(+), 7 deletions(-)
Documentation/scsi/data-integrity.txt |   57 ++
drivers/scsi/Kconfig                  |    1 
drivers/scsi/Makefile                 |    2 
drivers/scsi/scsi_error.c             |    3 
drivers/scsi/scsi_lib.c               |    4 
drivers/scsi/scsi_sysfs.c             |    4 
drivers/scsi/sd.c                     |   58 ++
drivers/scsi/sd.h                     |   22 +
drivers/scsi/sd_dif.c                 |  644 +++++++++++++++++++++++++++++++++
include/scsi/scsi_cmnd.h              |    3 
include/scsi/scsi_dif.h               |  140 +++++++
include/scsi/scsi_host.h              |    4 


Configure DMA of protection information and issue READ/WRITE commands
with RDPROTECT/WRPROTECT set accordingly.

Force READ CAPACITY(16) if the target has the PROTECT bit set and grab
an extra byte of response (P_TYPE and PROT_EN are in byte 12).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r ad65bfde4e05 -r 8bc1728dc75a Documentation/scsi/data-integrity.txt
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/Documentation/scsi/data-integrity.txt	Sat Jun 07 00:45:15 2008 -0400
@@ -0,0 +1,57 @@
+----------------------------------------------------------------------
+1.0 INTRODUCTION
+
+For a general overview of the data integrity framework please consult
+Documentation/block/data-integrity.txt.
+
+----------------------------------------------------------------------
+2.0 SCSI LAYER IMPLEMENTATION DETAILS
+
+The scsi_command has been extended with a scatterlist for the
+integrity metadata.  Note that all SCSI mid layer changes refer to
+this using the term "protection information" which is what it is
+called in the T10 spec.
+
+The term DIF (Data Integrity Field) is specific to SCSI disks (SBC).
+The SCSI midlayer doesn't know, or care, about the contents of the
+protection scatterlist, except it calls blk_rq_map_integrity_sg()
+during command initialization.
+
+
+2.1 SCSI DEVICE SCANNING
+
+A SCSI device has the PROTECT bit set in the standard INQUIRY page if
+it supports protection information.  The state of this bit is saved in
+the scsi_device struct.
+
+
+2.2 SCSI DISK SETUP
+
+In the case of a SCSI disk the actual DIF protection format is
+contained in in result of READ CAPACITY(16).  Consequently we have to
+use the 16-byte READ CAPACITY variant if the device is
+protection-capable.
+
+If the device has DIF-enabled we'll negotiate capabilities with the
+HBA.  And if the HBA is capable of protection DMA, the blk_integrity
+profile will be registered.
+
+Currently we only support Type 1 and Type 3.  Type 2 is only defined
+for 32-byte CDBs and is awaiting varlen CDB support.
+
+The controller may support checksum conversion as an optimization.
+Initial benchmarks showed that calculating a 16-bit CRC for each 512
+bytes of an I/O was expensive.  Emulex' hardware had the capability to
+convert an IP checksum to the T10 CRC on the wire.  So as part of the
+negotiation process the checksum algorithm will be selected and the
+blk_integrity profile set accordingly.
+
+----------------------------------------------------------------------
+3.0 HBA INTERFACE
+
+See the following doc:
+
+http://oss.oracle.com/projects/data-integrity/dist/documentation/linux-hba.pdf
+
+----------------------------------------------------------------------
+2007-12-24 Martin K. Petersen <martin.petersen@oracle.com>
diff -r ad65bfde4e05 -r 8bc1728dc75a drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/Kconfig	Sat Jun 07 00:45:15 2008 -0400
@@ -265,6 +265,7 @@
        bool "SCSI Data Integrity Protection"
        depends on SCSI
        depends on BLK_DEV_INTEGRITY
+       select CRC_T10DIF
        help 
 	 Some SCSI devices support data protection features above and
 	 beyond those implemented in the transport.  Select this
diff -r ad65bfde4e05 -r 8bc1728dc75a drivers/scsi/Makefile
--- a/drivers/scsi/Makefile	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/Makefile	Sat Jun 07 00:45:15 2008 -0400
@@ -149,6 +149,8 @@
 scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
 
 sd_mod-objs	:= sd.o
+sd_mod-$(CONFIG_SCSI_PROTECTION) += sd_dif.o
+
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
 		:= -DCONFIG_NCR53C8XX_PREFETCH -DSCSI_NCR_BIG_ENDIAN \
diff -r ad65bfde4e05 -r 8bc1728dc75a drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/scsi_error.c	Sat Jun 07 00:45:15 2008 -0400
@@ -333,6 +333,9 @@
 		return /* soft_error */ SUCCESS;
 
 	case ABORTED_COMMAND:
+		if (sshdr.asc == 0x10) /* DIF */
+			return SUCCESS;
+
 		return NEEDS_RETRY;
 	case NOT_READY:
 	case UNIT_ATTENTION:
diff -r ad65bfde4e05 -r 8bc1728dc75a drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/scsi_lib.c	Sat Jun 07 00:45:15 2008 -0400
@@ -947,6 +947,10 @@
 				scsi_requeue_command(q, cmd);
 				return;
 			} else {
+				if (sshdr.asc == 0x10) { /* DIF */
+					scsi_print_result(cmd);
+					scsi_print_sense("", cmd);
+				}
 				scsi_end_request(cmd, -EIO, this_count, 1);
 				return;
 			}
diff -r ad65bfde4e05 -r 8bc1728dc75a drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/scsi_sysfs.c	Sat Jun 07 00:45:15 2008 -0400
@@ -249,6 +249,8 @@
 shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
+shost_rd_attr(dif_capabilities, "%hd\n");
+shost_rd_attr(dif_guard_type, "%hd\n");
 shost_rd_attr2(proc_name, hostt->proc_name, "%s\n");
 
 static struct attribute *scsi_sysfs_shost_attrs[] = {
@@ -263,6 +265,8 @@
 	&dev_attr_hstate.attr,
 	&dev_attr_supported_mode.attr,
 	&dev_attr_active_mode.attr,
+	&dev_attr_dif_capabilities.attr,
+	&dev_attr_dif_guard_type.attr,
 	NULL
 };
 
diff -r ad65bfde4e05 -r 8bc1728dc75a drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/sd.c	Sat Jun 07 00:45:15 2008 -0400
@@ -58,6 +58,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_dif.h>
 
 #include "sd.h"
 #include "scsi_logging.h"
@@ -233,6 +234,24 @@
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
@@ -241,6 +260,8 @@
 	       sd_store_allow_restart),
 	__ATTR(manage_start_stop, S_IRUGO|S_IWUSR, sd_show_manage_start_stop,
 	       sd_store_manage_start_stop),
+	__ATTR(protection_type, S_IRUGO, sd_show_protection_type, NULL),
+	__ATTR(app_tag_own, S_IRUGO, sd_show_app_tag_own, NULL),
 	__ATTR_NULL,
 };
 
@@ -353,6 +374,7 @@
 	struct scsi_cmnd *SCpnt;
 	struct scsi_device *sdp = q->queuedata;
 	struct gendisk *disk = rq->rq_disk;
+	struct scsi_disk *sdkp;
 	sector_t block = rq->sector;
 	unsigned int this_count = rq->nr_sectors;
 	unsigned int timeout = sdp->timeout;
@@ -369,6 +391,7 @@
 	if (ret != BLKPREP_OK)
 		goto out;
 	SCpnt = rq->special;
+	sdkp = scsi_disk(disk);
 
 	/* from here on until we're complete, any goto out
 	 * is used for a killable error condition */
@@ -458,6 +481,11 @@
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
@@ -472,8 +500,13 @@
 					"writing" : "reading", this_count,
 					rq->nr_sectors));
 
-	SCpnt->cmnd[1] = 0;
-	
+	sd_dif_op(SCpnt);
+
+	if (scsi_host_dif_type(sdp->host, sdkp->protection_type))
+		SCpnt->cmnd[1] = 1 << 5;
+	else
+		SCpnt->cmnd[1] = 0;
+
 	if (block > 0xffffffff) {
 		SCpnt->cmnd[0] += READ_16 - READ_6;
 		SCpnt->cmnd[1] |= blk_fua_rq(rq) ? 0x8 : 0;
@@ -491,6 +524,7 @@
 		SCpnt->cmnd[13] = (unsigned char) this_count & 0xff;
 		SCpnt->cmnd[14] = SCpnt->cmnd[15] = 0;
 	} else if ((this_count > 0xff) || (block > 0x1fffff) ||
+		   SCpnt->device->protection ||
 		   SCpnt->device->use_10_for_rw) {
 		if (this_count > 0xffff)
 			this_count = 0xffff;
@@ -1004,7 +1038,8 @@
 		good_bytes = xfer_size;
 		break;
 	case ILLEGAL_REQUEST:
-		if (SCpnt->device->use_10_for_rw &&
+		if (SCpnt->device->protection == 0 &&
+		    SCpnt->device->use_10_for_rw &&
 		    (SCpnt->cmnd[0] == READ_10 ||
 		     SCpnt->cmnd[0] == WRITE_10))
 			SCpnt->device->use_10_for_rw = 0;
@@ -1017,6 +1052,9 @@
 		break;
 	}
  out:
+	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
+		sd_dif_complete(SCpnt, good_bytes);
+
 	return good_bytes;
 }
 
@@ -1171,7 +1209,8 @@
 	unsigned char cmd[16];
 	int the_result, retries;
 	int sector_size = 0;
-	int longrc = 0;
+	/* Force READ CAPACITY(16) when PROTECT=1 */
+	int longrc = sdkp->device->protection ? 1 : 0;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
 	struct scsi_device *sdp = sdkp->device;
@@ -1183,8 +1222,8 @@
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
@@ -1192,7 +1231,7 @@
 		}
 		
 		the_result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
-					      buffer, longrc ? 12 : 8, &sshdr,
+					      buffer, longrc ? 13 : 8, &sshdr,
 					      SD_TIMEOUT, SD_MAX_RETRIES);
 
 		if (media_not_present(sdkp, &sshdr))
@@ -1267,6 +1306,8 @@
 			
 		sector_size = (buffer[8] << 24) |
 			(buffer[9] << 16) | (buffer[10] << 8) | buffer[11];
+
+		sd_dif_config_disk(sdkp, buffer);
 	}	
 
 	/* Some devices return the total number of sectors, not the
@@ -1564,6 +1605,7 @@
 	sdkp->write_prot = 0;
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
+	sdkp->ATO = 0;
 
 	sd_spinup_disk(sdkp);
 
@@ -1575,6 +1617,7 @@
 		sd_read_capacity(sdkp, buffer);
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
+		sd_dif_app_tag_own(sdkp, buffer);
 	}
 
 	/*
@@ -1708,6 +1751,7 @@
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
+	sd_dif_config_host(sdkp);
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
diff -r ad65bfde4e05 -r 8bc1728dc75a drivers/scsi/sd.h
--- a/drivers/scsi/sd.h	Sat Jun 07 00:45:15 2008 -0400
+++ b/drivers/scsi/sd.h	Sat Jun 07 00:45:15 2008 -0400
@@ -41,7 +41,9 @@
 	u32		index;
 	u8		media_present;
 	u8		write_prot;
+	u8		protection_type;/* Data Integrity Field */
 	unsigned	previous_state : 1;
+	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
@@ -61,4 +63,24 @@
 		    (sdsk)->disk->disk_name, ##a) :			\
 	sdev_printk(prefix, (sdsk)->device, fmt, ##a)
 
+#if defined(CONFIG_SCSI_PROTECTION)
+
+extern unsigned char sd_dif_op(struct scsi_cmnd *);
+extern void sd_dif_app_tag_own(struct scsi_disk *, unsigned char *);
+extern void sd_dif_config_disk(struct scsi_disk *, unsigned char *);
+extern void sd_dif_config_host(struct scsi_disk *);
+extern int sd_dif_prepare(struct request *rq, sector_t, unsigned int);
+extern void sd_dif_complete(struct scsi_cmnd *, unsigned int);
+
+#else /* CONFIG_SCSI_PROTECTION */
+
+#define sd_dif_op(a)				(0)
+#define sd_dif_app_tag_own(a, b)		do { } while (0)
+#define sd_dif_config_disk(a, b)		do { } while (0)
+#define sd_dif_config_host(a)			do { } while (0)
+#define sd_dif_prepare(a, b, c)			(0)
+#define sd_dif_complete(a, b)			(0)
+
+#endif /* CONFIG_SCSI_PROTECTION */
+
 #endif /* _SCSI_DISK_H */
diff -r ad65bfde4e05 -r 8bc1728dc75a drivers/scsi/sd_dif.c
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/drivers/scsi/sd_dif.c	Sat Jun 07 00:45:15 2008 -0400
@@ -0,0 +1,644 @@
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
+#include <scsi/scsi_ioctl.h>
+#include <scsi/scsicam.h>
+#include <scsi/scsi_dif.h>
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
+			       bix->disk_name, sector);
+			return -EIO;
+		}
+
+		if (be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
+			printk(KERN_ERR
+			       "%s: ref tag error on sector %lu (rcvd %u)\n",
+			       bix->disk_name, sector,
+			       be32_to_cpu(sdt->ref_tag));
+			return -EIO;
+		}
+
+		csum = fn(buf, bix->sector_size);
+
+		if (sdt->guard_tag != csum) {
+			printk(KERN_ERR "%s: guard tag error on sector %lu " \
+			       "(rcvd %04x, data %04x)\n", bix->disk_name,
+			       sector, be16_to_cpu(sdt->guard_tag),
+			       be16_to_cpu(csum));
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
+ * Type 3 protection has a 16-bit guard tag and 16 + 32 bits of opaque tag space.
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
+			       sector, be16_to_cpu(sdt->guard_tag),
+			       be16_to_cpu(csum));
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
+
+/*
+ * The ATO bit indicates whether the application tag is available for
+ * use by the operating system.
+ */
+void sd_dif_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
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
+		goto no_ato;
+	}
+
+	offset = data.header_length + data.block_descriptor_length;
+
+	if ((buffer[offset] & 0x3f) != 0x0a) {
+		sd_printk(KERN_ERR, sdkp, "ATO Got wrong page\n");
+		goto no_ato;
+	}
+
+	if ((buffer[offset + 5] & 0x80) == 0)
+		goto no_ato;
+
+	sdkp->ATO = 1;
+	sd_printk(KERN_NOTICE, sdkp, "ATO Enabled\n");
+
+	return;
+
+no_ato:
+	sd_printk(KERN_NOTICE, sdkp, "ATO Disabled\n");
+}
+
+/*
+ * Determine whether disk supports Data Integrity Field.
+ */
+void sd_dif_config_disk(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	struct scsi_device *sdp = sdkp->device;
+	u8 type;
+
+	if (sdp->protection == 0 || (buffer[12] & 1) == 0)
+		type = 0;
+	else
+		type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
+
+	switch (type) {
+	case SCSI_DIF_TYPE0_PROTECTION:
+		sd_printk(KERN_NOTICE, sdkp, "formatted without data " \
+			  "integrity protection\n");
+		sdkp->protection_type = 0;
+		break;
+
+	case SCSI_DIF_TYPE1_PROTECTION:
+	case SCSI_DIF_TYPE3_PROTECTION:
+		sd_printk(KERN_NOTICE, sdkp, "formatted with DIF Type %d " \
+			  "protection\n", type);
+		sdkp->protection_type = type;
+		break;
+
+	case SCSI_DIF_TYPE2_PROTECTION:
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
+/*
+ * Configure exchange of protection information between OS and HBA.
+ */
+void sd_dif_config_host(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	struct gendisk *disk = sdkp->disk;
+	u8 type = sdkp->protection_type;
+
+	/* Does HBA support protection DMA? */
+	if (scsi_host_dif_dma(sdp->host) == 0) {
+
+		if (type) {
+			sd_printk(KERN_NOTICE, sdkp, "Type %d protection " \
+				  "unsupported by HBA. No protection DMA!\n",
+				  type);
+			sdkp->protection_type = 0;
+		}
+
+		return;
+	}
+
+	/* Does HBA support this type? */
+	if (scsi_host_dif_type(sdp->host, type) == 0) {
+		sd_printk(KERN_NOTICE, sdkp, "Type %d protection "	\
+			  "unsupported by HBA. Disabling DIF!\n", type);
+		sdkp->protection_type = 0;
+		return;
+	}
+
+	if (scsi_host_guard_type(sdkp->device->host) & SCSI_DIF_GUARD_IP)
+		if (type == SCSI_DIF_TYPE3_PROTECTION)
+			blk_integrity_register(disk, &dif_type3_integrity_ip);
+		else
+			blk_integrity_register(disk, &dif_type1_integrity_ip);
+	else
+		if (type == SCSI_DIF_TYPE3_PROTECTION)
+			blk_integrity_register(disk, &dif_type3_integrity_crc);
+		else
+			blk_integrity_register(disk, &dif_type1_integrity_crc);
+
+	sd_printk(KERN_INFO, sdkp,
+		  "Enabling %s integrity protection between OS and HBA\n",
+		  disk->integrity->name);
+
+	/* Signal to block layer that we support sector tagging */
+	if (type && sdkp->ATO) {
+		if (type == SCSI_DIF_TYPE3_PROTECTION)
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
+ * DIF DMA operation magic decoder ring.  DIF-capable HBA drivers
+ * should call this function in their queuecommand to determine how to
+ * handle the I/O.
+ */
+unsigned char sd_dif_op(struct scsi_cmnd *scmd)
+{
+	struct request *rq = scmd->request;
+	struct scsi_disk *sdkp;
+	int hba_to_disk, os_to_hba, csum_convert;
+
+	if (rq->cmd_type != REQ_TYPE_FS)
+		return SCSI_DIF_NORMAL;
+
+	/* Protection information passed between OS and HBA */
+	sdkp = scsi_disk(rq->rq_disk);
+	hba_to_disk = sdkp->protection_type;
+
+	/* Protection information between HBA and storage device */
+	os_to_hba = scsi_prot_sg_count(scmd);
+
+	/* Convert checksum? */
+	if (scsi_host_guard_type(scmd->device->host) == SCSI_DIF_GUARD_IP)
+		csum_convert = 1;
+	else
+		csum_convert = 0;
+
+	switch (scmd->cmnd[0]) {
+	case READ_10:
+	case READ_12:
+	case READ_16:
+		if (hba_to_disk && os_to_hba)
+			return csum_convert ?
+				SCSI_DIF_READ_CONVERT :
+				SCSI_DIF_READ_PASS;
+
+		else if (hba_to_disk && !os_to_hba)
+			return SCSI_DIF_READ_STRIP;
+
+		else if (!hba_to_disk && os_to_hba)
+			return SCSI_DIF_READ_INSERT;
+
+		break;
+
+	case WRITE_10:
+	case WRITE_12:
+	case WRITE_16:
+		if (hba_to_disk && os_to_hba)
+			return csum_convert ?
+				SCSI_DIF_WRITE_CONVERT :
+				SCSI_DIF_WRITE_PASS;
+
+		else if (hba_to_disk && !os_to_hba)
+			return SCSI_DIF_WRITE_INSERT;
+
+		else if (!hba_to_disk && os_to_hba)
+			return SCSI_DIF_WRITE_STRIP;
+
+		break;
+	}
+
+	return SCSI_DIF_NORMAL;
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
+	if (sdkp->protection_type == SCSI_DIF_TYPE3_PROTECTION)
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
+			sdt = kmap_atomic(iv->bv_page, KM_USER0) + iv->bv_offset;
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
+			kunmap_atomic(iv->bv_page, KM_USER0);
+		}
+	}
+
+	return 0;
+
+error:
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
+	if (sdkp->protection_type == SCSI_DIF_TYPE3_PROTECTION)
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
+			sdt = kmap_atomic(iv->bv_page, KM_USER0) + iv->bv_offset;
+
+			for (j = 0 ; j < iv->bv_len ; j += tuple_sz, sdt++) {
+
+				if (sectors == 0)
+					return;
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
+			kunmap_atomic(iv->bv_page, KM_USER0);
+		}
+	}
+}
+
diff -r ad65bfde4e05 -r 8bc1728dc75a include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h	Sat Jun 07 00:45:15 2008 -0400
+++ b/include/scsi/scsi_cmnd.h	Sat Jun 07 00:45:15 2008 -0400
@@ -78,6 +78,9 @@
 	int allowed;
 	int timeout_per_command;
 
+#if defined(CONFIG_SCSI_PROTECTION)
+	char prot_op;
+#endif
 	unsigned short cmd_len;
 	enum dma_data_direction sc_data_direction;
 
diff -r ad65bfde4e05 -r 8bc1728dc75a include/scsi/scsi_dif.h
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000
+++ b/include/scsi/scsi_dif.h	Sat Jun 07 00:45:15 2008 -0400
@@ -0,0 +1,140 @@
+/*
+ * scsi_dif.h - SCSI Data Integrity Field
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
+#ifndef _SCSI_SCSI_DIF_H
+#define _SCSI_SCSI_DIF_H
+
+#include <scsi/scsi_host.h>
+
+/*
+ * Type 1 through 3 indicate the DIF format. Type H is for protection
+ * between OS and HBA only.  The DMA flag indicates that the initiator
+ * is capable of transferring protection data to and from host memory.
+ */
+
+enum scsi_host_dif_capabilities {
+	SHOST_DIF_TYPE1_PROTECTION = 1 << 0,
+	SHOST_DIF_TYPE2_PROTECTION = 1 << 1,
+	SHOST_DIF_TYPE3_PROTECTION = 1 << 2,
+	SHOST_DIF_TYPEH_PROTECTION = 1 << 6,
+	SHOST_DIF_PROTECTION_DMA   = 1 << 7,
+};
+
+static inline void scsi_host_set_dif_caps(struct Scsi_Host *shost, unsigned char mask)
+{
+	shost->dif_capabilities = mask;
+}
+
+static inline unsigned char scsi_host_dif_dma(struct Scsi_Host *shost)
+{
+	return shost->dif_capabilities & SHOST_DIF_PROTECTION_DMA;
+}
+
+static inline unsigned char scsi_host_dif_type(struct Scsi_Host *shost, unsigned int target_type)
+{
+	if (target_type == 0)
+		return shost->dif_capabilities & SHOST_DIF_TYPEH_PROTECTION;
+
+	return shost->dif_capabilities & (1 << (target_type - 1));
+}
+
+/*
+ * All DIF-capable initiators must support the T10-mandated CRC
+ * checksum.  Controllers can optionally implement the IP checksum
+ * scheme which has much lower impact on system performance.  Note
+ * that the main rationale for the checksum is to match integrity
+ * metadata with data.  Detecting bit errors are a job for ECC memory
+ * and buses.
+ */
+
+enum scsi_host_guard_types {
+	SCSI_DIF_GUARD_CRC = 1 << 0,
+	SCSI_DIF_GUARD_IP  = 1 << 1,
+};
+
+static inline void scsi_host_set_guard_type(struct Scsi_Host *shost, unsigned char type)
+{
+	shost->dif_guard_type = type;
+}
+
+static inline unsigned char scsi_host_guard_type(struct Scsi_Host *shost)
+{
+	return shost->dif_guard_type;
+}
+
+/*
+ * Depending on the protection scheme implemented by initiator and
+ * target device, the request needs to be routed accordingly.  The
+ * host operations below are hints that tell the controller driver how
+ * to handle the I/O.
+ */
+
+enum scsi_host_dif_operations {
+	/* Normal I/O */
+	SCSI_DIF_NORMAL = 0,
+
+	/* OS-HBA: Protected, HBA-Target: Unprotected */
+	SCSI_DIF_READ_INSERT,
+	SCSI_DIF_WRITE_STRIP,
+
+	/* OS-HBA: Unprotected, HBA-Target: Protected */
+	SCSI_DIF_READ_STRIP,
+	SCSI_DIF_WRITE_INSERT,
+
+	/* OS-HBA: Protected, HBA-Target: Protected */
+	SCSI_DIF_READ_PASS,
+	SCSI_DIF_WRITE_PASS,
+
+	/* OS-HBA: Protected, HBA-Target: Protected, checksum conversion */
+	SCSI_DIF_READ_CONVERT,
+	SCSI_DIF_WRITE_CONVERT,
+};
+
+
+/* A DIF-capable target device can be formatted with different
+ * protection schemes.  Currently 0 through 3 are defined:
+ *
+ * Type 0 is regular (unprotected I/O)
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
+	SCSI_DIF_TYPE0_PROTECTION = 0x0,
+	SCSI_DIF_TYPE1_PROTECTION = 0x1,
+	SCSI_DIF_TYPE2_PROTECTION = 0x2,
+	SCSI_DIF_TYPE3_PROTECTION = 0x3,
+};
+
+/* DIF contents are considered data and consequently host-endian */
+struct sd_dif_tuple {
+       __u16 guard_tag;
+       __u16 app_tag;
+       __u32 ref_tag;
+};
+
+#endif /* _SCSI_SCSI_DIF_H */
diff -r ad65bfde4e05 -r 8bc1728dc75a include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Sat Jun 07 00:45:15 2008 -0400
+++ b/include/scsi/scsi_host.h	Sat Jun 07 00:45:15 2008 -0400
@@ -636,6 +636,10 @@
 	 */
 	unsigned int max_host_blocked;
 
+	/* Data Integrity Field */
+	unsigned char dif_capabilities;
+	unsigned char dif_guard_type;
+
 	/*
 	 * q used for scsi_tgt msgs, async events or any other requests that
 	 * need to be processed in userspace


