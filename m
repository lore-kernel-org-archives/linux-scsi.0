From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 13/14] lib: Add T10 Protection Information functions
Date: Wed, 28 May 2014 23:28:47 -0400
Message-ID: <1401334128-15499-14-git-send-email-martin.petersen@oracle.com>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26969 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954AbaE2D33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:29:29 -0400
In-Reply-To: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

The T10 Protection Information format is also used by some devices that
do not go through the SCSI layer (virtual block devices, NVMe). Relocate
the relevant functions to a library that can be used without involving
SCSI.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/Kconfig              |   1 +
 drivers/scsi/Kconfig       |   2 +-
 drivers/scsi/sd_dif.c      | 193 +++------------------------------------------
 include/linux/crc-t10dif.h |   5 +-
 include/linux/t10-pi.h     |  28 +++++++
 lib/Kconfig                |   7 ++
 lib/Makefile               |   2 +
 lib/t10-pi.c               | 164 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 219 insertions(+), 183 deletions(-)
 create mode 100644 include/linux/t10-pi.h
 create mode 100644 lib/t10-pi.c

diff --git a/block/Kconfig b/block/Kconfig
index 2429515c05c2..947658db8456 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -77,6 +77,7 @@ config BLK_DEV_BSGLIB
 
 config BLK_DEV_INTEGRITY
 	bool "Block layer data integrity support"
+	select T10_PI if BLK_DEV_INTEGRITY
 	---help---
 	Some storage devices allow extra information to be
 	stored/retrieved to help protect the data.  The block layer
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 02832d64d918..1096b16b2a0c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -69,7 +69,7 @@ comment "SCSI support type (disk, tape, CD-ROM)"
 config BLK_DEV_SD
 	tristate "SCSI disk support"
 	depends on SCSI
-	select CRC_T10DIF if BLK_DEV_INTEGRITY
+	select T10_PI if BLK_DEV_INTEGRITY
 	---help---
 	  If you want to use SCSI hard disks, Fibre Channel disks,
 	  Serial ATA (SATA) or Parallel ATA (PATA) hard disks,
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 033d30d37952..d7109fff327d 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -21,7 +21,7 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/crc-t10dif.h>
+#include <linux/t10-pi.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -33,204 +33,37 @@
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
 static struct blk_integrity dif_type1_integrity_crc = {
 	.name			= "T10-DIF-TYPE1-CRC",
-	.generate_fn		= sd_dif_type1_generate_crc,
-	.verify_fn		= sd_dif_type1_verify_crc,
-	.tuple_size		= sizeof(struct sd_dif_tuple),
+	.generate_fn		= t10_pi_type1_generate_crc,
+	.verify_fn		= t10_pi_type1_verify_crc,
+	.tuple_size		= sizeof(struct t10_pi_tuple),
 	.tag_size		= 0,
 };
 
 static struct blk_integrity dif_type1_integrity_ip = {
 	.name			= "T10-DIF-TYPE1-IP",
-	.generate_fn		= sd_dif_type1_generate_ip,
-	.verify_fn		= sd_dif_type1_verify_ip,
-	.tuple_size		= sizeof(struct sd_dif_tuple),
+	.generate_fn		= t10_pi_type1_generate_ip,
+	.verify_fn		= t10_pi_type1_verify_ip,
+	.tuple_size		= sizeof(struct t10_pi_tuple),
 	.tag_size		= 0,
 };
 
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
 static struct blk_integrity dif_type3_integrity_crc = {
 	.name			= "T10-DIF-TYPE3-CRC",
-	.generate_fn		= sd_dif_type3_generate_crc,
-	.verify_fn		= sd_dif_type3_verify_crc,
-	.tuple_size		= sizeof(struct sd_dif_tuple),
+	.generate_fn		= t10_pi_type3_generate_crc,
+	.verify_fn		= t10_pi_type3_verify_crc,
+	.tuple_size		= sizeof(struct t10_pi_tuple),
 	.tag_size		= 0,
 };
 
 static struct blk_integrity dif_type3_integrity_ip = {
 	.name			= "T10-DIF-TYPE3-IP",
-	.generate_fn		= sd_dif_type3_generate_ip,
-	.verify_fn		= sd_dif_type3_verify_ip,
-	.tuple_size		= sizeof(struct sd_dif_tuple),
+	.generate_fn		= t10_pi_type3_generate_ip,
+	.verify_fn		= t10_pi_type3_verify_ip,
+	.tuple_size		= sizeof(struct t10_pi_tuple),
 	.tag_size		= 0,
 };
 
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
index 000000000000..6d8e138c9471
--- /dev/null
+++ b/include/linux/t10-pi.h
@@ -0,0 +1,28 @@
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
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index 4771fb3f4da4..4e7b1ba722ea 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -198,6 +198,13 @@ config RANDOM32_SELFTEST
 	  This option enables the 32 bit PRNG library functions to perform a
 	  self test on initialization.
 
+config T10_PI
+	tristate "Functions for generating and verifying T10 Protection Information"
+	select CRC_T10DIF
+	select CRYPTO_CRCT10DIF
+	help
+	  This code is for use with the block layer data integrity subsystem.
+
 #
 # compression support is select'ed if needed
 #
diff --git a/lib/Makefile b/lib/Makefile
index 0cd7b68e1382..c93dc958c7e6 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -164,6 +164,8 @@ obj-$(CONFIG_ASN1) += asn1_decoder.o
 
 obj-$(CONFIG_FONT_SUPPORT) += fonts/
 
+obj-$(CONFIG_T10_PI) += t10-pi.o
+
 hostprogs-y	:= gen_crc32table
 clean-files	:= crc32table.h
 
diff --git a/lib/t10-pi.c b/lib/t10-pi.c
new file mode 100644
index 000000000000..6e2f9b8bb404
--- /dev/null
+++ b/lib/t10-pi.c
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
+				return -EKERNREF;
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
+			return -EKERNGRD;
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
-- 
1.9.0

