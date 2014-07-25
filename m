From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 13/14] block: Add T10 Protection Information functions
Date: Fri, 25 Jul 2014 16:34:28 -0400
Message-ID: <1406320469-29352-14-git-send-email-martin.petersen@oracle.com>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38398 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935135AbaGYUdv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 16:33:51 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PKXoB5028328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:51 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s6PKXo2S017843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:50 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXngU014850
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:49 GMT
In-Reply-To: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

The T10 Protection Information format is also used by some devices that
do not go through the SCSI layer (virtual block devices, NVMe). Relocate
the relevant functions to a block layer library that can be used without
involving SCSI.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/Kconfig              |   1 +
 block/Makefile             |   4 +-
 block/t10-pi.c             | 164 ++++++++++++++++++++++++++++++
 drivers/scsi/Kconfig       |   1 -
 drivers/scsi/sd_dif.c      | 241 ++++-----------------------------------------
 include/linux/crc-t10dif.h |   5 +-
 include/linux/t10-pi.h     |  60 +++++++++++
 7 files changed, 250 insertions(+), 226 deletions(-)
 create mode 100644 block/t10-pi.c
 create mode 100644 include/linux/t10-pi.h

diff --git a/block/Kconfig b/block/Kconfig
index 2429515c05c2..1427106f30c9 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -77,6 +77,7 @@ config BLK_DEV_BSGLIB
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"
+	select CRC_T10_PI if BLK_DEV_INTEGRITY
 	---help---
 	Some storage devices allow extra information to be
 	stored/retrieved to help protect the data.  The block layer
diff --git a/block/Makefile b/block/Makefile
index a2ce6ac935ec..00ecc97629db 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -20,6 +20,6 @@ obj-$(CONFIG_IOSCHED_DEADLINE)	+= deadline-iosched.o
 obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
-obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
 obj-$(CONFIG_BLK_CMDLINE_PARSER)	+= cmdline-parser.o
-obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o
+obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o t10-pi.o
+
diff --git a/block/t10-pi.c b/block/t10-pi.c
new file mode 100644
index 000000000000..f45da5d55bd8
--- /dev/null
+++ b/block/t10-pi.c
@@ -0,0 +1,164 @@
+/*
+ * t10_pi.c - Functions for generating and verifying T10 Protection
+ *	      Information.
+ *
+ * Copyright (C) 2007, 2008, 2014 Oracle Corporation
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
+#include <linux/t10-pi.h>
+#include <linux/blkdev.h>
+#include <linux/crc-t10dif.h>
+#include <net/checksum.h>
+
+typedef __u16 (csum_fn) (void *, unsigned int);
+
+static __u16 t10_pi_crc_fn(void *data, unsigned int len)
+{
+	return cpu_to_be16(crc_t10dif(data, len));
+}
+
+static __u16 t10_pi_ip_fn(void *data, unsigned int len)
+{
+	return ip_compute_csum(data, len);
+}
+
+/*
+ * Type 1 and Type 2 protection use the same format: 16 bit guard tag,
+ * 16 bit app tag, 32 bit reference tag. Type 3 does not define the ref
+ * tag.
+ */
+static int t10_pi_generate(struct blk_integrity_iter *iter, csum_fn *fn,
+			   unsigned int type)
+{
+	unsigned int i;
+
+	for (i = 0 ; i < iter->data_size ; i += iter->interval) {
+		struct t10_pi_tuple *pi = iter->prot_buf;
+
+		pi->guard_tag = fn(iter->data_buf, iter->interval);
+		pi->app_tag = 0;
+
+		if (type == 1)
+			pi->ref_tag = cpu_to_be32(iter->seed & 0xffffffff);
+		else
+			pi->ref_tag = 0;
+
+		iter->data_buf += iter->interval;
+		iter->prot_buf += sizeof(struct t10_pi_tuple);
+		iter->seed++;
+	}
+
+	return 0;
+}
+
+static int t10_pi_verify(struct blk_integrity_iter *iter, csum_fn *fn,
+				unsigned int type)
+{
+	unsigned int i;
+
+	for (i = 0 ; i < iter->data_size ; i += iter->interval) {
+		struct t10_pi_tuple *pi = iter->prot_buf;
+		__u16 csum;
+
+		switch (type) {
+		case 1:
+		case 2:
+			if (pi->app_tag == 0xffff)
+				goto next;
+
+			if (be32_to_cpu(pi->ref_tag) !=
+			    (iter->seed & 0xffffffff)) {
+				pr_err("%s: ref tag error at location %lu " \
+				       "(rcvd %u)\n", iter->disk_name,
+				       iter->seed, be32_to_cpu(pi->ref_tag));
+				return -EILSEQ;
+			}
+			break;
+		case 3:
+			if (pi->app_tag == 0xffff && pi->ref_tag == 0xffffffff)
+				goto next;
+			break;
+		}
+
+		csum = fn(iter->data_buf, iter->interval);
+
+		if (pi->guard_tag != csum) {
+			pr_err("%s: guard tag error at location %lu " \
+			       "(rcvd %04x, data %04x)\n", iter->disk_name,
+			       (unsigned long)iter->seed,
+			       be16_to_cpu(pi->guard_tag), be16_to_cpu(csum));
+			return -EILSEQ;
+		}
+
+next:
+		iter->data_buf += iter->interval;
+		iter->prot_buf += sizeof(struct t10_pi_tuple);
+		iter->seed++;
+	}
+
+	return 0;
+}
+
+int t10_pi_type1_generate_crc(struct blk_integrity_iter *iter)
+{
+	return t10_pi_generate(iter, t10_pi_crc_fn, 1);
+}
+EXPORT_SYMBOL(t10_pi_type1_generate_crc);
+
+int t10_pi_type1_generate_ip(struct blk_integrity_iter *iter)
+{
+	return t10_pi_generate(iter, t10_pi_ip_fn, 1);
+}
+EXPORT_SYMBOL(t10_pi_type1_generate_ip);
+
+int t10_pi_type1_verify_crc(struct blk_integrity_iter *iter)
+{
+	return t10_pi_verify(iter, t10_pi_crc_fn, 1);
+}
+EXPORT_SYMBOL(t10_pi_type1_verify_crc);
+
+int t10_pi_type1_verify_ip(struct blk_integrity_iter *iter)
+{
+	return t10_pi_verify(iter, t10_pi_ip_fn, 1);
+}
+EXPORT_SYMBOL(t10_pi_type1_verify_ip);
+
+int t10_pi_type3_generate_crc(struct blk_integrity_iter *iter)
+{
+	return t10_pi_generate(iter, t10_pi_crc_fn, 3);
+}
+EXPORT_SYMBOL(t10_pi_type3_generate_crc);
+
+int t10_pi_type3_generate_ip(struct blk_integrity_iter *iter)
+{
+	return t10_pi_generate(iter, t10_pi_ip_fn, 3);
+}
+EXPORT_SYMBOL(t10_pi_type3_generate_ip);
+
+int t10_pi_type3_verify_crc(struct blk_integrity_iter *iter)
+{
+	return t10_pi_verify(iter, t10_pi_crc_fn, 3);
+}
+EXPORT_SYMBOL(t10_pi_type3_verify_crc);
+
+int t10_pi_type3_verify_ip(struct blk_integrity_iter *iter)
+{
+	return t10_pi_verify(iter, t10_pi_ip_fn, 3);
+}
+EXPORT_SYMBOL(t10_pi_type3_verify_ip);
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 2f85035e6e97..962559db012d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -69,7 +69,6 @@ comment "SCSI support type (disk, tape, CD-ROM)"
 config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
-	select CRC_T10DIF if BLK_DEV_INTEGRITY
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 2198abee619e..b7eaeadc18f9 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -21,7 +21,7 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/crc-t10dif.h>
+#include <linux/t10-pi.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -33,207 +33,8 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsicam.h>
 
-#include <net/checksum.h>
-
 #include "sd.h"
 
-typedef __u16 (csum_fn) (void *, unsigned int);
-
-static __u16 sd_dif_crc_fn(void *data, unsigned int len)
-{
-	return cpu_to_be16(crc_t10dif(data, len));
-}
-
-static __u16 sd_dif_ip_fn(void *data, unsigned int len)
-{
-	return ip_compute_csum(data, len);
-}
-
-/*
- * Type 1 and Type 2 protection use the same format: 16 bit guard tag,
- * 16 bit app tag, 32 bit reference tag.
- */
-static void sd_dif_type1_generate(struct blk_integrity_iter *iter, csum_fn *fn)
-{
-	void *buf = iter->data_buf;
-	struct sd_dif_tuple *sdt = iter->prot_buf;
-	sector_t seed = iter->seed;
-	unsigned int i;
-
-	for (i = 0 ; i < iter->data_size ; i += iter->interval, sdt++) {
-		sdt->guard_tag = fn(buf, iter->interval);
-		sdt->ref_tag = cpu_to_be32(seed & 0xffffffff);
-		sdt->app_tag = 0;
-
-		buf += iter->interval;
-		seed++;
-	}
-}
-
-static int sd_dif_type1_generate_crc(struct blk_integrity_iter *iter)
-{
-	sd_dif_type1_generate(iter, sd_dif_crc_fn);
-	return 0;
-}
-
-static int sd_dif_type1_generate_ip(struct blk_integrity_iter *iter)
-{
-	sd_dif_type1_generate(iter, sd_dif_ip_fn);
-	return 0;
-}
-
-static int sd_dif_type1_verify(struct blk_integrity_iter *iter, csum_fn *fn)
-{
-	void *buf = iter->data_buf;
-	struct sd_dif_tuple *sdt = iter->prot_buf;
-	sector_t seed = iter->seed;
-	unsigned int i;
-	__u16 csum;
-
-	for (i = 0 ; i < iter->data_size ; i += iter->interval, sdt++) {
-		/* Unwritten sectors */
-		if (sdt->app_tag == 0xffff)
-			return 0;
-
-		if (be32_to_cpu(sdt->ref_tag) != (seed & 0xffffffff)) {
-			printk(KERN_ERR
-			       "%s: ref tag error on sector %lu (rcvd %u)\n",
-			       iter->disk_name, (unsigned long)seed,
-			       be32_to_cpu(sdt->ref_tag));
-			return -EIO;
-		}
-
-		csum = fn(buf, iter->interval);
-
-		if (sdt->guard_tag != csum) {
-			printk(KERN_ERR "%s: guard tag error on sector %lu " \
-			       "(rcvd %04x, data %04x)\n", iter->disk_name,
-			       (unsigned long)seed,
-			       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
-			return -EIO;
-		}
-
-		buf += iter->interval;
-		seed++;
-	}
-
-	return 0;
-}
-
-static int sd_dif_type1_verify_crc(struct blk_integrity_iter *iter)
-{
-	return sd_dif_type1_verify(iter, sd_dif_crc_fn);
-}
-
-static int sd_dif_type1_verify_ip(struct blk_integrity_iter *iter)
-{
-	return sd_dif_type1_verify(iter, sd_dif_ip_fn);
-}
-
-static struct blk_integrity dif_type1_integrity_crc = {
-	.name			= "T10-DIF-TYPE1-CRC",
-	.generate_fn		= sd_dif_type1_generate_crc,
-	.verify_fn		= sd_dif_type1_verify_crc,
-	.tuple_size		= sizeof(struct sd_dif_tuple),
-	.tag_size		= 0,
-};
-
-static struct blk_integrity dif_type1_integrity_ip = {
-	.name			= "T10-DIF-TYPE1-IP",
-	.generate_fn		= sd_dif_type1_generate_ip,
-	.verify_fn		= sd_dif_type1_verify_ip,
-	.tuple_size		= sizeof(struct sd_dif_tuple),
-	.tag_size		= 0,
-};
-
-
-/*
- * Type 3 protection has a 16-bit guard tag and 16 + 32 bits of opaque
- * tag space.
- */
-static void sd_dif_type3_generate(struct blk_integrity_iter *iter, csum_fn *fn)
-{
-	void *buf = iter->data_buf;
-	struct sd_dif_tuple *sdt = iter->prot_buf;
-	unsigned int i;
-
-	for (i = 0 ; i < iter->data_size ; i += iter->interval, sdt++) {
-		sdt->guard_tag = fn(buf, iter->interval);
-		sdt->ref_tag = 0;
-		sdt->app_tag = 0;
-
-		buf += iter->interval;
-	}
-}
-
-static int sd_dif_type3_generate_crc(struct blk_integrity_iter *iter)
-{
-	sd_dif_type3_generate(iter, sd_dif_crc_fn);
-	return 0;
-}
-
-static int sd_dif_type3_generate_ip(struct blk_integrity_iter *iter)
-{
-	sd_dif_type3_generate(iter, sd_dif_ip_fn);
-	return 0;
-}
-
-static int sd_dif_type3_verify(struct blk_integrity_iter *iter, csum_fn *fn)
-{
-	void *buf = iter->data_buf;
-	struct sd_dif_tuple *sdt = iter->prot_buf;
-	sector_t seed = iter->seed;
-	unsigned int i;
-	__u16 csum;
-
-	for (i = 0 ; i < iter->data_size ; i += iter->interval, sdt++) {
-		/* Unwritten sectors */
-		if (sdt->app_tag == 0xffff && sdt->ref_tag == 0xffffffff)
-			return 0;
-
-		csum = fn(buf, iter->interval);
-
-		if (sdt->guard_tag != csum) {
-			printk(KERN_ERR "%s: guard tag error on sector %lu " \
-			       "(rcvd %04x, data %04x)\n", iter->disk_name,
-			       (unsigned long)seed,
-			       be16_to_cpu(sdt->guard_tag), be16_to_cpu(csum));
-			return -EIO;
-		}
-
-		buf += iter->interval;
-		seed++;
-	}
-
-	return 0;
-}
-
-static int sd_dif_type3_verify_crc(struct blk_integrity_iter *iter)
-{
-	return sd_dif_type3_verify(iter, sd_dif_crc_fn);
-}
-
-static int sd_dif_type3_verify_ip(struct blk_integrity_iter *iter)
-{
-	return sd_dif_type3_verify(iter, sd_dif_ip_fn);
-}
-
-static struct blk_integrity dif_type3_integrity_crc = {
-	.name			= "T10-DIF-TYPE3-CRC",
-	.generate_fn		= sd_dif_type3_generate_crc,
-	.verify_fn		= sd_dif_type3_verify_crc,
-	.tuple_size		= sizeof(struct sd_dif_tuple),
-	.tag_size		= 0,
-};
-
-static struct blk_integrity dif_type3_integrity_ip = {
-	.name			= "T10-DIF-TYPE3-IP",
-	.generate_fn		= sd_dif_type3_generate_ip,
-	.verify_fn		= sd_dif_type3_verify_ip,
-	.tuple_size		= sizeof(struct sd_dif_tuple),
-	.tag_size		= 0,
-};
-
 /*
  * Configure exchange of protection information between OS and HBA.
  */
@@ -257,16 +58,16 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 	/* Enable DMA of protection information */
 	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP) {
 		if (type == SD_DIF_TYPE3_PROTECTION)
-			blk_integrity_register(disk, &dif_type3_integrity_ip);
+			blk_integrity_register(disk, &t10_pi_type3_ip);
 		else
-			blk_integrity_register(disk, &dif_type1_integrity_ip);
+			blk_integrity_register(disk, &t10_pi_type1_ip);
 
 		disk->integrity->flags |= BLK_INTEGRITY_IP_CHECKSUM;
 	} else
 		if (type == SD_DIF_TYPE3_PROTECTION)
-			blk_integrity_register(disk, &dif_type3_integrity_crc);
+			blk_integrity_register(disk, &t10_pi_type3_crc);
 		else
-			blk_integrity_register(disk, &dif_type1_integrity_crc);
+			blk_integrity_register(disk, &t10_pi_type1_crc);
 
 	sd_printk(KERN_NOTICE, sdkp,
 		  "Enabling DIX %s protection\n", disk->integrity->name);
@@ -308,10 +109,10 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 		    unsigned int sector_sz)
 {
-	const int tuple_sz = sizeof(struct sd_dif_tuple);
+	const int tuple_sz = sizeof(struct t10_pi_tuple);
 	struct bio *bio;
 	struct scsi_disk *sdkp;
-	struct sd_dif_tuple *sdt;
+	struct t10_pi_tuple *pi;
 	u32 phys, virt;
 
 	sdkp = rq->bio->bi_bdev->bd_disk->private_data;
@@ -334,19 +135,18 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 		virt = bip_get_seed(bip) & 0xffffffff;
 
 		bip_for_each_vec(iv, bip, iter) {
-			sdt = kmap_atomic(iv.bv_page)
-				+ iv.bv_offset;
+			pi = kmap_atomic(iv.bv_page) + iv.bv_offset;
 
-			for (j = 0; j < iv.bv_len; j += tuple_sz, sdt++) {
+			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
-				if (be32_to_cpu(sdt->ref_tag) == virt)
-					sdt->ref_tag = cpu_to_be32(phys);
+				if (be32_to_cpu(pi->ref_tag) == virt)
+					pi->ref_tag = cpu_to_be32(phys);
 
 				virt++;
 				phys++;
 			}
 
-			kunmap_atomic(sdt);
+			kunmap_atomic(pi);
 		}
 
 		bip->bip_flags |= BIP_MAPPED_INTEGRITY;
@@ -359,10 +159,10 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
  */
 void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 {
-	const int tuple_sz = sizeof(struct sd_dif_tuple);
+	const int tuple_sz = sizeof(struct t10_pi_tuple);
 	struct scsi_disk *sdkp;
 	struct bio *bio;
-	struct sd_dif_tuple *sdt;
+	struct t10_pi_tuple *pi;
 	unsigned int j, sectors, sector_sz;
 	u32 phys, virt;
 
@@ -386,25 +186,24 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 		virt = bip_get_seed(bip) & 0xffffffff;
 
 		bip_for_each_vec(iv, bip, iter) {
-			sdt = kmap_atomic(iv.bv_page)
-				+ iv.bv_offset;
+			pi = kmap_atomic(iv.bv_page) + iv.bv_offset;
 
-			for (j = 0; j < iv.bv_len; j += tuple_sz, sdt++) {
+			for (j = 0; j < iv.bv_len; j += tuple_sz, pi++) {
 
 				if (sectors == 0) {
-					kunmap_atomic(sdt);
+					kunmap_atomic(pi);
 					return;
 				}
 
-				if (be32_to_cpu(sdt->ref_tag) == phys)
-					sdt->ref_tag = cpu_to_be32(virt);
+				if (be32_to_cpu(pi->ref_tag) == phys)
+					pi->ref_tag = cpu_to_be32(virt);
 
 				virt++;
 				phys++;
 				sectors--;
 			}
 
-			kunmap_atomic(sdt);
+			kunmap_atomic(pi);
 		}
 	}
 }
diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index b3cb71f0d3b0..cf53d0773ce3 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -6,7 +6,8 @@
 #define CRC_T10DIF_DIGEST_SIZE 2
 #define CRC_T10DIF_BLOCK_SIZE 1
 
-__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len);
-__u16 crc_t10dif(unsigned char const *, size_t);
+extern __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
+				size_t len);
+extern __u16 crc_t10dif(unsigned char const *, size_t);
 
 #endif
diff --git a/include/linux/t10-pi.h b/include/linux/t10-pi.h
new file mode 100644
index 000000000000..70569a6f2e8c
--- /dev/null
+++ b/include/linux/t10-pi.h
@@ -0,0 +1,60 @@
+#ifndef _LINUX_T10_PI_H
+#define _LINUX_T10_PI_H
+
+#include <linux/types.h>
+#include <linux/blkdev.h>
+
+/*
+ * T10 Protection Information tuple.
+ */
+struct t10_pi_tuple {
+	__be16 guard_tag;	/* Checksum */
+	__be16 app_tag;		/* Opaque storage */
+	__be32 ref_tag;		/* Target LBA or indirect LBA */
+};
+
+extern int t10_pi_type1_generate_crc(struct blk_integrity_iter *);
+extern int t10_pi_type1_verify_crc(struct blk_integrity_iter *);
+
+extern int t10_pi_type1_generate_ip(struct blk_integrity_iter *);
+extern int t10_pi_type1_verify_ip(struct blk_integrity_iter *);
+
+extern int t10_pi_type3_generate_crc(struct blk_integrity_iter *);
+extern int t10_pi_type3_verify_crc(struct blk_integrity_iter *);
+
+extern int t10_pi_type3_generate_ip(struct blk_integrity_iter *);
+extern int t10_pi_type3_verify_ip(struct blk_integrity_iter *);
+
+struct blk_integrity t10_pi_type1_crc = {
+	.name			= "T10-DIF-TYPE1-CRC",
+	.generate_fn		= t10_pi_type1_generate_crc,
+	.verify_fn		= t10_pi_type1_verify_crc,
+	.tuple_size		= sizeof(struct t10_pi_tuple),
+	.tag_size		= 0,
+};
+
+struct blk_integrity t10_pi_type1_ip = {
+	.name			= "T10-DIF-TYPE1-IP",
+	.generate_fn		= t10_pi_type1_generate_ip,
+	.verify_fn		= t10_pi_type1_verify_ip,
+	.tuple_size		= sizeof(struct t10_pi_tuple),
+	.tag_size		= 0,
+};
+
+struct blk_integrity t10_pi_type3_crc = {
+	.name			= "T10-DIF-TYPE3-CRC",
+	.generate_fn		= t10_pi_type3_generate_crc,
+	.verify_fn		= t10_pi_type3_verify_crc,
+	.tuple_size		= sizeof(struct t10_pi_tuple),
+	.tag_size		= 0,
+};
+
+struct blk_integrity t10_pi_type3_ip = {
+	.name			= "T10-DIF-TYPE3-IP",
+	.generate_fn		= t10_pi_type3_generate_ip,
+	.verify_fn		= t10_pi_type3_verify_ip,
+	.tuple_size		= sizeof(struct t10_pi_tuple),
+	.tag_size		= 0,
+};
+
+#endif
-- 
1.9.3

