Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A2F12D1E0
	for <linux-scsi@vger.kernel.org>; Tue,  5 Mar 2024 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709677579; cv=none; b=Y6Yw69GqGOyhXaurF/F0BsuNNz61AiMsr9VJxYYcSPBqF9DooTuGfcc3tqzDAwn1FQIABUxxcGN724KxJ+DWpBgtxxIvro0apdorOHgOYkDTh2UGTOaYwnhCmeMWdzZJwVPjfxiw2wTyCVsfW4lGfpAZqVPtSp8KCGv+khlNiBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709677579; c=relaxed/simple;
	bh=dxW4hhYdNQGXj6W+HUUeYsh9qi4skxkhMmNFd7/dd1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XKyfylqVrobMU0ZuYmYiQLKGmSMxQ3NNfSoqQ8uNzTnB4uklpHbm52uCJyHe51MGoFkKK8Cqtm3EQNO7qLR7jUtdnxMGFU0TP0xzjw5bnMsLBtBTurbg21GYeWtL+5oqD1ZiEC2BBwAiPsGFJ3tf90PvhXm3Pm3WpgWYzGDbc4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-29b7164eef6so333708a91.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2024 14:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709677576; x=1710282376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zlw7mJAbu2FY+YW3hujYWPt1vZh+oDVWTTqmecy5+X8=;
        b=UXuLfHH8n6n5Kjy+JK+yglprKcT73D/c5J/xKc6d54SclKehm3aUpwV0zayc3XBlXi
         aSHO7QTFglXP1VUUZxXYStjgaszgDDhW5vFjo+HdGT9EFgEM/ircL2gNyPOw5hN6Tt5y
         oO/mLRWfP/mRTCPl5aRqRn8+eh3TzdGybEEb3kWc3FtsI/uEGSjv9+Xj4sSg3OX5ZWDx
         tR/THUCJ9kweY6QWxqyw+D9vTGm30Ek2odzTQXWCIB7W+w3vCsQOLM4S+IJc52IpnXDY
         LCHSdflGD/lEkfMNPLNbFGBxLukuyTAK4iD9HlqQcXN1VjYoHCT2dn+uayTEEzxJg1Qs
         mmwA==
X-Gm-Message-State: AOJu0YzgEr+VJ7vOGfdx5oZHg4j3jQpQxN/XxGMarUvNcWFvpvhD5Dkd
	73uediHKNx0OUu0iaTSrmKbYFjvQQIPUHP+kjH+2OYtHEr8KyAmy5HC8yShb
X-Google-Smtp-Source: AGHT+IGuUXE05ZhIL/zBnjG4azQ/crSKfF2T/ZQfVBa3JpZ1BqouVdhTHrGjwrEpOo2Lx5LmvUSucw==
X-Received: by 2002:a17:90a:f09:b0:29b:307a:d5ed with SMTP id 9-20020a17090a0f0900b0029b307ad5edmr9414872pjy.10.1709677576096;
        Tue, 05 Mar 2024 14:26:16 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:3e11:2c1a:c1ee:7fe1])
        by smtp.gmail.com with ESMTPSA id q37-20020a17090a17a800b0029af5587889sm11218330pja.12.2024.03.05.14.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Mar 2024 14:26:15 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2] scsi_debug: Make CRC_T10DIF support optional
Date: Tue,  5 Mar 2024 14:25:57 -0800
Message-ID: <20240305222612.37383-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not all scsi_debug users need data integrity support. Hence modify the
scsi_debug driver such that it becomes possible to build this driver
without data integrity support. The changes in this patch are as
follows:
- Split the scsi_debug source code into two files without modifying any
  functionality.
- Instead of selecting CRC_T10DIF no matter how the scsi_debug driver is
  built, only select CRC_T10DIF if the scsi_debug driver is built-in to
  the kernel.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared with v1: made the patch description more detailed.

 drivers/scsi/Kconfig                          |   2 +-
 drivers/scsi/Makefile                         |   2 +
 drivers/scsi/scsi_debug-dif.h                 |  65 +++++
 drivers/scsi/scsi_debug_dif.c                 | 224 +++++++++++++++
 .../scsi/{scsi_debug.c => scsi_debug_main.c}  | 257 ++----------------
 5 files changed, 308 insertions(+), 242 deletions(-)
 create mode 100644 drivers/scsi/scsi_debug-dif.h
 create mode 100644 drivers/scsi/scsi_debug_dif.c
 rename drivers/scsi/{scsi_debug.c => scsi_debug_main.c} (97%)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3328052c8715..b7c92d7af73d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1227,7 +1227,7 @@ config SCSI_WD719X
 config SCSI_DEBUG
 	tristate "SCSI debugging host and device simulator"
 	depends on SCSI
-	select CRC_T10DIF
+	select CRC_T10DIF if SCSI_DEBUG = y
 	help
 	  This pseudo driver simulates one or more hosts (SCSI initiators),
 	  each with one or more targets, each with one or more logical units.
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1313ddf2fd1a..6287d9d65f04 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -156,6 +156,8 @@ obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
 
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
+scsi_debug-y			+= scsi_debug_main.o
+scsi_debug-$(CONFIG_CRC_T10DIF) += scsi_debug_dif.o
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_CONSTANTS) += constants.o
diff --git a/drivers/scsi/scsi_debug-dif.h b/drivers/scsi/scsi_debug-dif.h
new file mode 100644
index 000000000000..d1d9e57b528b
--- /dev/null
+++ b/drivers/scsi/scsi_debug-dif.h
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_DEBUG_DIF_H
+#define _SCSI_DEBUG_DIF_H
+
+#include <linux/kconfig.h>
+#include <linux/types.h>
+#include <linux/spinlock_types.h>
+
+struct scsi_cmnd;
+struct sdebug_dev_info;
+struct t10_pi_tuple;
+
+extern int dix_writes;
+extern int dix_reads;
+extern int dif_errors;
+extern struct xarray *const per_store_ap;
+extern int sdebug_dif;
+extern int sdebug_dix;
+extern unsigned int sdebug_guard;
+extern int sdebug_sector_size;
+extern unsigned int sdebug_store_sectors;
+
+/* There is an xarray of pointers to this struct's objects, one per host */
+struct sdeb_store_info {
+	rwlock_t macc_lck;	/* for atomic media access on this store */
+	u8 *storep;		/* user data storage (ram) */
+	struct t10_pi_tuple *dif_storep; /* protection info */
+	void *map_storep;	/* provisioning map */
+};
+
+struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
+				  bool bug_if_fake_rw);
+
+#if IS_ENABLED(CONFIG_CRC_T10DIF)
+
+int dif_verify(struct t10_pi_tuple *sdt, const void *data, sector_t sector,
+	       u32 ei_lba);
+int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
+		     unsigned int sectors, u32 ei_lba);
+int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
+		      unsigned int sectors, u32 ei_lba);
+
+#else /* CONFIG_CRC_T10DIF */
+
+static inline int dif_verify(struct t10_pi_tuple *sdt, const void *data,
+			     sector_t sector, u32 ei_lba)
+{
+	return 0x01; /*GUARD check failed*/
+}
+
+static inline int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
+				   unsigned int sectors, u32 ei_lba)
+{
+	return 0x01; /*GUARD check failed*/
+}
+
+static inline int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
+				    unsigned int sectors, u32 ei_lba)
+{
+	return 0x01; /*GUARD check failed*/
+}
+
+#endif /* CONFIG_CRC_T10DIF */
+
+#endif /* _SCSI_DEBUG_DIF_H */
diff --git a/drivers/scsi/scsi_debug_dif.c b/drivers/scsi/scsi_debug_dif.c
new file mode 100644
index 000000000000..a6599d787248
--- /dev/null
+++ b/drivers/scsi/scsi_debug_dif.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include "scsi_debug-dif.h"
+#include <linux/crc-t10dif.h>
+#include <linux/t10-pi.h>
+#include <net/checksum.h>
+#include <scsi/scsi_cmnd.h>
+
+static __be16 dif_compute_csum(const void *buf, int len)
+{
+	__be16 csum;
+
+	if (sdebug_guard)
+		csum = (__force __be16)ip_compute_csum(buf, len);
+	else
+		csum = cpu_to_be16(crc_t10dif(buf, len));
+
+	return csum;
+}
+
+int dif_verify(struct t10_pi_tuple *sdt, const void *data, sector_t sector,
+	       u32 ei_lba)
+{
+	__be16 csum = dif_compute_csum(data, sdebug_sector_size);
+
+	if (sdt->guard_tag != csum) {
+		pr_err("GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
+			(unsigned long)sector,
+			be16_to_cpu(sdt->guard_tag),
+			be16_to_cpu(csum));
+		return 0x01;
+	}
+	if (sdebug_dif == T10_PI_TYPE1_PROTECTION &&
+	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
+		pr_err("REF check failed on sector %lu\n",
+			(unsigned long)sector);
+		return 0x03;
+	}
+	if (sdebug_dif == T10_PI_TYPE2_PROTECTION &&
+	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
+		pr_err("REF check failed on sector %lu\n",
+			(unsigned long)sector);
+		return 0x03;
+	}
+	return 0;
+}
+
+static struct t10_pi_tuple *dif_store(struct sdeb_store_info *sip,
+				      sector_t sector)
+{
+	sector = sector_div(sector, sdebug_store_sectors);
+
+	return sip->dif_storep + sector;
+}
+
+static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector,
+			  unsigned int sectors, bool read)
+{
+	size_t resid;
+	void *paddr;
+	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
+						scp->device->hostdata, true);
+	struct t10_pi_tuple *dif_storep = sip->dif_storep;
+	const void *dif_store_end = dif_storep + sdebug_store_sectors;
+	struct sg_mapping_iter miter;
+
+	/* Bytes of protection data to copy into sgl */
+	resid = sectors * sizeof(*dif_storep);
+
+	sg_miter_start(&miter, scsi_prot_sglist(scp),
+		       scsi_prot_sg_count(scp), SG_MITER_ATOMIC |
+		       (read ? SG_MITER_TO_SG : SG_MITER_FROM_SG));
+
+	while (sg_miter_next(&miter) && resid > 0) {
+		size_t len = min_t(size_t, miter.length, resid);
+		void *start = dif_store(sip, sector);
+		size_t rest = 0;
+
+		if (dif_store_end < start + len)
+			rest = start + len - dif_store_end;
+
+		paddr = miter.addr;
+
+		if (read)
+			memcpy(paddr, start, len - rest);
+		else
+			memcpy(start, paddr, len - rest);
+
+		if (rest) {
+			if (read)
+				memcpy(paddr + len - rest, dif_storep, rest);
+			else
+				memcpy(dif_storep, paddr + len - rest, rest);
+		}
+
+		sector += len / sizeof(*dif_storep);
+		resid -= len;
+	}
+	sg_miter_stop(&miter);
+}
+
+static void *lba2fake_store(struct sdeb_store_info *sip,
+			    unsigned long long lba)
+{
+	struct sdeb_store_info *lsip = sip;
+
+	lba = do_div(lba, sdebug_store_sectors);
+	if (!sip || !sip->storep) {
+		WARN_ON_ONCE(true);
+		lsip = xa_load(per_store_ap, 0);  /* should never be NULL */
+	}
+	return lsip->storep + lba * sdebug_sector_size;
+}
+
+int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
+		     unsigned int sectors, u32 ei_lba)
+{
+	int ret = 0;
+	unsigned int i;
+	sector_t sector;
+	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
+						scp->device->hostdata, true);
+	struct t10_pi_tuple *sdt;
+
+	for (i = 0; i < sectors; i++, ei_lba++) {
+		sector = start_sec + i;
+		sdt = dif_store(sip, sector);
+
+		if (sdt->app_tag == cpu_to_be16(0xffff))
+			continue;
+
+		/*
+		 * Because scsi_debug acts as both initiator and
+		 * target we proceed to verify the PI even if
+		 * RDPROTECT=3. This is done so the "initiator" knows
+		 * which type of error to return. Otherwise we would
+		 * have to iterate over the PI twice.
+		 */
+		if (scp->cmnd[1] >> 5) { /* RDPROTECT */
+			ret = dif_verify(sdt, lba2fake_store(sip, sector),
+					 sector, ei_lba);
+			if (ret) {
+				dif_errors++;
+				break;
+			}
+		}
+	}
+
+	dif_copy_prot(scp, start_sec, sectors, true);
+	dix_reads++;
+
+	return ret;
+}
+
+int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
+		      unsigned int sectors, u32 ei_lba)
+{
+	int ret;
+	struct t10_pi_tuple *sdt;
+	void *daddr;
+	sector_t sector = start_sec;
+	int ppage_offset;
+	int dpage_offset;
+	struct sg_mapping_iter diter;
+	struct sg_mapping_iter piter;
+
+	BUG_ON(scsi_sg_count(SCpnt) == 0);
+	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
+
+	sg_miter_start(&piter, scsi_prot_sglist(SCpnt),
+			scsi_prot_sg_count(SCpnt),
+			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	sg_miter_start(&diter, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+
+	/* For each protection page */
+	while (sg_miter_next(&piter)) {
+		dpage_offset = 0;
+		if (WARN_ON(!sg_miter_next(&diter))) {
+			ret = 0x01;
+			goto out;
+		}
+
+		for (ppage_offset = 0; ppage_offset < piter.length;
+		     ppage_offset += sizeof(struct t10_pi_tuple)) {
+			/* If we're at the end of the current
+			 * data page advance to the next one
+			 */
+			if (dpage_offset >= diter.length) {
+				if (WARN_ON(!sg_miter_next(&diter))) {
+					ret = 0x01;
+					goto out;
+				}
+				dpage_offset = 0;
+			}
+
+			sdt = piter.addr + ppage_offset;
+			daddr = diter.addr + dpage_offset;
+
+			if (SCpnt->cmnd[1] >> 5 != 3) { /* WRPROTECT */
+				ret = dif_verify(sdt, daddr, sector, ei_lba);
+				if (ret)
+					goto out;
+			}
+
+			sector++;
+			ei_lba++;
+			dpage_offset += sdebug_sector_size;
+		}
+		diter.consumed = dpage_offset;
+		sg_miter_stop(&diter);
+	}
+	sg_miter_stop(&piter);
+
+	dif_copy_prot(SCpnt, start_sec, sectors, false);
+	dix_writes++;
+
+	return 0;
+
+out:
+	dif_errors++;
+	sg_miter_stop(&diter);
+	sg_miter_stop(&piter);
+	return ret;
+}
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug_main.c
similarity index 97%
rename from drivers/scsi/scsi_debug.c
rename to drivers/scsi/scsi_debug_main.c
index acf0592d63da..34a7028b2392 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug_main.c
@@ -30,13 +30,11 @@
 #include <linux/moduleparam.h>
 #include <linux/scatterlist.h>
 #include <linux/blkdev.h>
-#include <linux/crc-t10dif.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/atomic.h>
 #include <linux/hrtimer.h>
 #include <linux/uuid.h>
-#include <linux/t10-pi.h>
 #include <linux/msdos_partition.h>
 #include <linux/random.h>
 #include <linux/xarray.h>
@@ -45,8 +43,6 @@
 #include <linux/async.h>
 #include <linux/cleanup.h>
 
-#include <net/checksum.h>
-
 #include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
@@ -59,6 +55,7 @@
 #include <scsi/scsi_dbg.h>
 
 #include "sd.h"
+#include "scsi_debug-dif.h"
 #include "scsi_logging.h"
 
 /* make sure inq_product_rev string corresponds to this version */
@@ -372,14 +369,6 @@ struct sdebug_host_info {
 	struct list_head dev_info_list;
 };
 
-/* There is an xarray of pointers to this struct's objects, one per host */
-struct sdeb_store_info {
-	rwlock_t macc_lck;	/* for atomic media access on this store */
-	u8 *storep;		/* user data storage (ram) */
-	struct t10_pi_tuple *dif_storep; /* protection info */
-	void *map_storep;	/* provisioning map */
-};
-
 #define dev_to_sdebug_host(d)	\
 	container_of(d, struct sdebug_host_info, dev)
 
@@ -799,12 +788,12 @@ static int sdebug_ato = DEF_ATO;
 static int sdebug_cdb_len = DEF_CDB_LEN;
 static int sdebug_jdelay = DEF_JDELAY;	/* if > 0 then unit is jiffies */
 static int sdebug_dev_size_mb = DEF_DEV_SIZE_PRE_INIT;
-static int sdebug_dif = DEF_DIF;
-static int sdebug_dix = DEF_DIX;
+int sdebug_dif = DEF_DIF;
+int sdebug_dix = DEF_DIX;
 static int sdebug_dsense = DEF_D_SENSE;
 static int sdebug_every_nth = DEF_EVERY_NTH;
 static int sdebug_fake_rw = DEF_FAKE_RW;
-static unsigned int sdebug_guard = DEF_GUARD;
+unsigned int sdebug_guard = DEF_GUARD;
 static int sdebug_host_max_queue;	/* per host */
 static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns = DEF_MAX_LUNS;
@@ -822,7 +811,7 @@ static int sdebug_physblk_exp = DEF_PHYSBLK_EXP;
 static int sdebug_opt_xferlen_exp = DEF_OPT_XFERLEN_EXP;
 static int sdebug_ptype = DEF_PTYPE; /* SCSI peripheral device type */
 static int sdebug_scsi_level = DEF_SCSI_LEVEL;
-static int sdebug_sector_size = DEF_SECTOR_SIZE;
+int sdebug_sector_size = DEF_SECTOR_SIZE;
 static int sdeb_tur_ms_to_ready = DEF_TUR_MS_TO_READY;
 static int sdebug_virtual_gb = DEF_VIRTUAL_GB;
 static int sdebug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
@@ -864,7 +853,7 @@ enum sam_lun_addr_method {SAM_LUN_AM_PERIPHERAL = 0x0,
 static enum sam_lun_addr_method sdebug_lun_am = SAM_LUN_AM_PERIPHERAL;
 static int sdebug_lun_am_i = (int)SAM_LUN_AM_PERIPHERAL;
 
-static unsigned int sdebug_store_sectors;
+unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
 
 /* old BIOS stuff, kernel may get rid of them but some mode sense pages
@@ -877,7 +866,7 @@ static LIST_HEAD(sdebug_host_list);
 static DEFINE_MUTEX(sdebug_host_list_mutex);
 
 static struct xarray per_store_arr;
-static struct xarray *per_store_ap = &per_store_arr;
+struct xarray *const per_store_ap = &per_store_arr;
 static int sdeb_first_idx = -1;		/* invalid index ==> none created */
 static int sdeb_most_recent_idx = -1;
 static DEFINE_RWLOCK(sdeb_fake_rw_lck);	/* need a RW lock when fake_rw=1 */
@@ -888,9 +877,9 @@ static int num_dev_resets;
 static int num_target_resets;
 static int num_bus_resets;
 static int num_host_resets;
-static int dix_writes;
-static int dix_reads;
-static int dif_errors;
+int dix_writes;
+int dix_reads;
+int dif_errors;
 
 /* ZBC global data */
 static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
@@ -1188,27 +1177,6 @@ static inline bool scsi_debug_lbp(void)
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
 }
 
-static void *lba2fake_store(struct sdeb_store_info *sip,
-			    unsigned long long lba)
-{
-	struct sdeb_store_info *lsip = sip;
-
-	lba = do_div(lba, sdebug_store_sectors);
-	if (!sip || !sip->storep) {
-		WARN_ON_ONCE(true);
-		lsip = xa_load(per_store_ap, 0);  /* should never be NULL */
-	}
-	return lsip->storep + lba * sdebug_sector_size;
-}
-
-static struct t10_pi_tuple *dif_store(struct sdeb_store_info *sip,
-				      sector_t sector)
-{
-	sector = sector_div(sector, sdebug_store_sectors);
-
-	return sip->dif_storep + sector;
-}
-
 static void sdebug_max_tgts_luns(void)
 {
 	struct sdebug_host_info *sdbg_host;
@@ -3367,8 +3335,8 @@ static inline int check_device_access_params
  * that access any of the "stores" in struct sdeb_store_info should call this
  * function with bug_if_fake_rw set to true.
  */
-static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
-						bool bug_if_fake_rw)
+struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
+				  bool bug_if_fake_rw)
 {
 	if (sdebug_fake_rw) {
 		BUG_ON(bug_if_fake_rw);	/* See note above */
@@ -3471,131 +3439,6 @@ static bool comp_write_worker(struct sdeb_store_info *sip, u64 lba, u32 num,
 	return res;
 }
 
-static __be16 dif_compute_csum(const void *buf, int len)
-{
-	__be16 csum;
-
-	if (sdebug_guard)
-		csum = (__force __be16)ip_compute_csum(buf, len);
-	else
-		csum = cpu_to_be16(crc_t10dif(buf, len));
-
-	return csum;
-}
-
-static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
-		      sector_t sector, u32 ei_lba)
-{
-	__be16 csum = dif_compute_csum(data, sdebug_sector_size);
-
-	if (sdt->guard_tag != csum) {
-		pr_err("GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
-			(unsigned long)sector,
-			be16_to_cpu(sdt->guard_tag),
-			be16_to_cpu(csum));
-		return 0x01;
-	}
-	if (sdebug_dif == T10_PI_TYPE1_PROTECTION &&
-	    be32_to_cpu(sdt->ref_tag) != (sector & 0xffffffff)) {
-		pr_err("REF check failed on sector %lu\n",
-			(unsigned long)sector);
-		return 0x03;
-	}
-	if (sdebug_dif == T10_PI_TYPE2_PROTECTION &&
-	    be32_to_cpu(sdt->ref_tag) != ei_lba) {
-		pr_err("REF check failed on sector %lu\n",
-			(unsigned long)sector);
-		return 0x03;
-	}
-	return 0;
-}
-
-static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector,
-			  unsigned int sectors, bool read)
-{
-	size_t resid;
-	void *paddr;
-	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
-						scp->device->hostdata, true);
-	struct t10_pi_tuple *dif_storep = sip->dif_storep;
-	const void *dif_store_end = dif_storep + sdebug_store_sectors;
-	struct sg_mapping_iter miter;
-
-	/* Bytes of protection data to copy into sgl */
-	resid = sectors * sizeof(*dif_storep);
-
-	sg_miter_start(&miter, scsi_prot_sglist(scp),
-		       scsi_prot_sg_count(scp), SG_MITER_ATOMIC |
-		       (read ? SG_MITER_TO_SG : SG_MITER_FROM_SG));
-
-	while (sg_miter_next(&miter) && resid > 0) {
-		size_t len = min_t(size_t, miter.length, resid);
-		void *start = dif_store(sip, sector);
-		size_t rest = 0;
-
-		if (dif_store_end < start + len)
-			rest = start + len - dif_store_end;
-
-		paddr = miter.addr;
-
-		if (read)
-			memcpy(paddr, start, len - rest);
-		else
-			memcpy(start, paddr, len - rest);
-
-		if (rest) {
-			if (read)
-				memcpy(paddr + len - rest, dif_storep, rest);
-			else
-				memcpy(dif_storep, paddr + len - rest, rest);
-		}
-
-		sector += len / sizeof(*dif_storep);
-		resid -= len;
-	}
-	sg_miter_stop(&miter);
-}
-
-static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
-			    unsigned int sectors, u32 ei_lba)
-{
-	int ret = 0;
-	unsigned int i;
-	sector_t sector;
-	struct sdeb_store_info *sip = devip2sip((struct sdebug_dev_info *)
-						scp->device->hostdata, true);
-	struct t10_pi_tuple *sdt;
-
-	for (i = 0; i < sectors; i++, ei_lba++) {
-		sector = start_sec + i;
-		sdt = dif_store(sip, sector);
-
-		if (sdt->app_tag == cpu_to_be16(0xffff))
-			continue;
-
-		/*
-		 * Because scsi_debug acts as both initiator and
-		 * target we proceed to verify the PI even if
-		 * RDPROTECT=3. This is done so the "initiator" knows
-		 * which type of error to return. Otherwise we would
-		 * have to iterate over the PI twice.
-		 */
-		if (scp->cmnd[1] >> 5) { /* RDPROTECT */
-			ret = dif_verify(sdt, lba2fake_store(sip, sector),
-					 sector, ei_lba);
-			if (ret) {
-				dif_errors++;
-				break;
-			}
-		}
-	}
-
-	dif_copy_prot(scp, start_sec, sectors, true);
-	dix_reads++;
-
-	return ret;
-}
-
 static inline void
 sdeb_read_lock(struct sdeb_store_info *sip)
 {
@@ -3803,78 +3646,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	return 0;
 }
 
-static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
-			     unsigned int sectors, u32 ei_lba)
-{
-	int ret;
-	struct t10_pi_tuple *sdt;
-	void *daddr;
-	sector_t sector = start_sec;
-	int ppage_offset;
-	int dpage_offset;
-	struct sg_mapping_iter diter;
-	struct sg_mapping_iter piter;
-
-	BUG_ON(scsi_sg_count(SCpnt) == 0);
-	BUG_ON(scsi_prot_sg_count(SCpnt) == 0);
-
-	sg_miter_start(&piter, scsi_prot_sglist(SCpnt),
-			scsi_prot_sg_count(SCpnt),
-			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
-	sg_miter_start(&diter, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
-			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
-
-	/* For each protection page */
-	while (sg_miter_next(&piter)) {
-		dpage_offset = 0;
-		if (WARN_ON(!sg_miter_next(&diter))) {
-			ret = 0x01;
-			goto out;
-		}
-
-		for (ppage_offset = 0; ppage_offset < piter.length;
-		     ppage_offset += sizeof(struct t10_pi_tuple)) {
-			/* If we're at the end of the current
-			 * data page advance to the next one
-			 */
-			if (dpage_offset >= diter.length) {
-				if (WARN_ON(!sg_miter_next(&diter))) {
-					ret = 0x01;
-					goto out;
-				}
-				dpage_offset = 0;
-			}
-
-			sdt = piter.addr + ppage_offset;
-			daddr = diter.addr + dpage_offset;
-
-			if (SCpnt->cmnd[1] >> 5 != 3) { /* WRPROTECT */
-				ret = dif_verify(sdt, daddr, sector, ei_lba);
-				if (ret)
-					goto out;
-			}
-
-			sector++;
-			ei_lba++;
-			dpage_offset += sdebug_sector_size;
-		}
-		diter.consumed = dpage_offset;
-		sg_miter_stop(&diter);
-	}
-	sg_miter_stop(&piter);
-
-	dif_copy_prot(SCpnt, start_sec, sectors, false);
-	dix_writes++;
-
-	return 0;
-
-out:
-	dif_errors++;
-	sg_miter_stop(&diter);
-	sg_miter_stop(&piter);
-	return ret;
-}
-
 static unsigned long lba_to_map_index(sector_t lba)
 {
 	if (sdebug_unmap_alignment)
@@ -6266,8 +6037,10 @@ module_param_named(cdb_len, sdebug_cdb_len, int, 0644);
 module_param_named(clustering, sdebug_clustering, bool, S_IRUGO | S_IWUSR);
 module_param_named(delay, sdebug_jdelay, int, S_IRUGO | S_IWUSR);
 module_param_named(dev_size_mb, sdebug_dev_size_mb, int, S_IRUGO);
+#ifdef CONFIG_CRC_T10DIF
 module_param_named(dif, sdebug_dif, int, S_IRUGO);
 module_param_named(dix, sdebug_dix, int, S_IRUGO);
+#endif
 module_param_named(dsense, sdebug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, sdebug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, sdebug_fake_rw, int, S_IRUGO | S_IWUSR);
@@ -6343,8 +6116,10 @@ MODULE_PARM_DESC(cdb_len, "suggest CDB lengths to drivers (def=10)");
 MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=0)");
 MODULE_PARM_DESC(delay, "response delay (def=1 jiffy); 0:imm, -1,-2:tiny");
 MODULE_PARM_DESC(dev_size_mb, "size in MiB of ram shared by devs(def=8)");
+#ifdef CONFIG_CRC_T10DIF
 MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=0)");
 MODULE_PARM_DESC(dix, "data integrity extensions mask (def=0)");
+#endif
 MODULE_PARM_DESC(dsense, "use descriptor sense format(def=0 -> fixed)");
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=0)");
