Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B248114294
	for <linux-scsi@vger.kernel.org>; Thu,  7 Mar 2024 20:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709843454; cv=none; b=Bm2J3AGO81xdOzZWZ9WUigO+IEmtON2Syvr8Y8jYpn+b3RaOkRThviApLwixa+hLsM9/ZTtjqxRplY4qwcoD3qxJw8NbVcEKBRaGIJmOEDWq1Or9puX56U3FOMbp9m7wt5vM29BGbI1D2l90n2kfsVO4Jg0tRf4mIGlyowOlZvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709843454; c=relaxed/simple;
	bh=39VXYDr+SdZoEJAdgRTMfBVRULufgf0Ms9IzU5OkNEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lArMZdJ/kHE5YKk25RnT1r4xkLeN7O0+kUAfTeGVYNOAdTFcfcAMsx0f4T6a57AhcjZ+JgpcJCHYcYxQqWk8ZU3FN7P0BMbyxhyRWe1cc6v0bbIkn4SNoR8HLV+iQwXk/eI6Hsdq1gjwTEjusKba3mufX2Uh49kx4M+dfrh+DBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lTSDsg+G; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lTSDsg+G"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4TrLXr15dwz6Cl450;
	Thu,  7 Mar 2024 20:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1709843436; x=1712435437; bh=CjH+u
	kgmf8wnBA9Nh+nh2erFg968LViQCHbLp499+J0=; b=lTSDsg+G684axYvYiw7+U
	ldXq/Ud6uVIk/ykFE6/HQyKLV5v3OaAEd+rtQmfjnFdQfopvhTyU7RNrCwgXbWuU
	d50OpKtjyO+cJhL74UwFwc2AtKRDl/HUWchOCSUS/fqTln8x95AXHHNZg0AWBNCL
	7+42YNDwMmUXhzcx7gOKeAxK7CoSq91AZEwZYp91o0EhxLZlsecQ0pDESBatmCwC
	+oK9fa5DnEKmvAsnMGCM4gKfOvyI5GcVDWwFnhGKkpmEjgM1nR5g6L/IXQfSGfz9
	gGTlW+bhBj3m8P+aOIZQ16lASYehkaqOXkN1fbkdCo7GjZByQVMJNfm66TdWEfz3
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0ONrJDGJhgLi; Thu,  7 Mar 2024 20:30:36 +0000 (UTC)
Received: from bvanassche-linux.mtv.corp.google.com (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4TrLXV3VF7z6Cl44T;
	Thu,  7 Mar 2024 20:30:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v3 4/4] scsi: scsi_debug: Make CRC_T10DIF support optional
Date: Thu,  7 Mar 2024 12:30:07 -0800
Message-ID: <20240307203015.870254-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
In-Reply-To: <20240307203015.870254-1-bvanassche@acm.org>
References: <20240307203015.870254-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

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
 drivers/scsi/Kconfig                          |   3 +-
 drivers/scsi/Makefile                         |   2 +
 drivers/scsi/scsi_debug_dif.c                 | 240 +++++++++++++++++
 drivers/scsi/scsi_debug_dif.h                 |  57 ++++
 .../scsi/{scsi_debug.c =3D> scsi_debug_main.c}  | 254 +-----------------
 5 files changed, 306 insertions(+), 250 deletions(-)
 create mode 100644 drivers/scsi/scsi_debug_dif.c
 create mode 100644 drivers/scsi/scsi_debug_dif.h
 rename drivers/scsi/{scsi_debug.c =3D> scsi_debug_main.c} (97%)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3328052c8715..a283338e0ebd 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1226,8 +1226,7 @@ config SCSI_WD719X
=20
 config SCSI_DEBUG
 	tristate "SCSI debugging host and device simulator"
-	depends on SCSI
-	select CRC_T10DIF
+	depends on SCSI && (m || CRC_T10DIF =3D y)
 	help
 	  This pseudo driver simulates one or more hosts (SCSI initiators),
 	  each with one or more targets, each with one or more logical units.
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1313ddf2fd1a..6287d9d65f04 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -156,6 +156,8 @@ obj-$(CONFIG_SCSI_HISI_SAS) +=3D hisi_sas/
=20
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+=3D scsi_debug.o
+scsi_debug-y			+=3D scsi_debug_main.o
+scsi_debug-$(CONFIG_CRC_T10DIF) +=3D scsi_debug_dif.o
 scsi_mod-y			+=3D scsi.o hosts.o scsi_ioctl.o \
 				   scsicam.o scsi_error.o scsi_lib.o
 scsi_mod-$(CONFIG_SCSI_CONSTANTS) +=3D constants.o
diff --git a/drivers/scsi/scsi_debug_dif.c b/drivers/scsi/scsi_debug_dif.=
c
new file mode 100644
index 000000000000..b6cfd64f7a21
--- /dev/null
+++ b/drivers/scsi/scsi_debug_dif.c
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/crc-t10dif.h>
+#include <linux/t10-pi.h>
+#include <net/checksum.h>
+#include "scsi_debug_dif.h"
+
+#define DEF_DIF 0
+#define DEF_DIX 0
+#define DEF_GUARD 0
+
+int sdebug_dif =3D DEF_DIF;
+int sdebug_dix =3D DEF_DIX;
+unsigned int sdebug_guard =3D DEF_GUARD;
+int dix_writes;
+int dix_reads;
+int dif_errors;
+
+static __be16 dif_compute_csum(const void *buf, int len)
+{
+	__be16 csum;
+
+	if (sdebug_guard)
+		csum =3D (__force __be16)ip_compute_csum(buf, len);
+	else
+		csum =3D cpu_to_be16(crc_t10dif(buf, len));
+
+	return csum;
+}
+
+static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
+		      sector_t sector, u32 ei_lba)
+{
+	__be16 csum =3D dif_compute_csum(data, sdebug_sector_size);
+
+	if (sdt->guard_tag !=3D csum) {
+		pr_err("GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
+			(unsigned long)sector,
+			be16_to_cpu(sdt->guard_tag),
+			be16_to_cpu(csum));
+		return 0x01;
+	}
+	if (sdebug_dif =3D=3D T10_PI_TYPE1_PROTECTION &&
+	    be32_to_cpu(sdt->ref_tag) !=3D (sector & 0xffffffff)) {
+		pr_err("REF check failed on sector %lu\n",
+			(unsigned long)sector);
+		return 0x03;
+	}
+	if (sdebug_dif =3D=3D T10_PI_TYPE2_PROTECTION &&
+	    be32_to_cpu(sdt->ref_tag) !=3D ei_lba) {
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
+	sector =3D sector_div(sector, sdebug_store_sectors);
+
+	return sip->dif_storep + sector;
+}
+
+static void dif_copy_prot(struct scsi_cmnd *scp, sector_t sector,
+			  unsigned int sectors, bool read)
+{
+	size_t resid;
+	void *paddr;
+	struct sdeb_store_info *sip =3D devip2sip((struct sdebug_dev_info *)
+						scp->device->hostdata, true);
+	struct t10_pi_tuple *dif_storep =3D sip->dif_storep;
+	const void *dif_store_end =3D dif_storep + sdebug_store_sectors;
+	struct sg_mapping_iter miter;
+
+	/* Bytes of protection data to copy into sgl */
+	resid =3D sectors * sizeof(*dif_storep);
+
+	sg_miter_start(&miter, scsi_prot_sglist(scp),
+		       scsi_prot_sg_count(scp), SG_MITER_ATOMIC |
+		       (read ? SG_MITER_TO_SG : SG_MITER_FROM_SG));
+
+	while (sg_miter_next(&miter) && resid > 0) {
+		size_t len =3D min_t(size_t, miter.length, resid);
+		void *start =3D dif_store(sip, sector);
+		size_t rest =3D 0;
+
+		if (dif_store_end < start + len)
+			rest =3D start + len - dif_store_end;
+
+		paddr =3D miter.addr;
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
+		sector +=3D len / sizeof(*dif_storep);
+		resid -=3D len;
+	}
+	sg_miter_stop(&miter);
+}
+
+static void *lba2fake_store(struct sdeb_store_info *sip,
+			    unsigned long long lba)
+{
+	struct sdeb_store_info *lsip =3D sip;
+
+	lba =3D do_div(lba, sdebug_store_sectors);
+	if (!sip || !sip->storep) {
+		WARN_ON_ONCE(true);
+		lsip =3D xa_load(per_store_ap, 0);  /* should never be NULL */
+	}
+	return lsip->storep + lba * sdebug_sector_size;
+}
+
+int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
+		     unsigned int sectors, u32 ei_lba)
+{
+	int ret =3D 0;
+	unsigned int i;
+	sector_t sector;
+	struct sdeb_store_info *sip =3D devip2sip((struct sdebug_dev_info *)
+						scp->device->hostdata, true);
+	struct t10_pi_tuple *sdt;
+
+	for (i =3D 0; i < sectors; i++, ei_lba++) {
+		sector =3D start_sec + i;
+		sdt =3D dif_store(sip, sector);
+
+		if (sdt->app_tag =3D=3D cpu_to_be16(0xffff))
+			continue;
+
+		/*
+		 * Because scsi_debug acts as both initiator and
+		 * target we proceed to verify the PI even if
+		 * RDPROTECT=3D3. This is done so the "initiator" knows
+		 * which type of error to return. Otherwise we would
+		 * have to iterate over the PI twice.
+		 */
+		if (scp->cmnd[1] >> 5) { /* RDPROTECT */
+			ret =3D dif_verify(sdt, lba2fake_store(sip, sector),
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
+	sector_t sector =3D start_sec;
+	int ppage_offset;
+	int dpage_offset;
+	struct sg_mapping_iter diter;
+	struct sg_mapping_iter piter;
+
+	BUG_ON(scsi_sg_count(SCpnt) =3D=3D 0);
+	BUG_ON(scsi_prot_sg_count(SCpnt) =3D=3D 0);
+
+	sg_miter_start(&piter, scsi_prot_sglist(SCpnt),
+			scsi_prot_sg_count(SCpnt),
+			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+	sg_miter_start(&diter, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
+			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
+
+	/* For each protection page */
+	while (sg_miter_next(&piter)) {
+		dpage_offset =3D 0;
+		if (WARN_ON(!sg_miter_next(&diter))) {
+			ret =3D 0x01;
+			goto out;
+		}
+
+		for (ppage_offset =3D 0; ppage_offset < piter.length;
+		     ppage_offset +=3D sizeof(struct t10_pi_tuple)) {
+			/* If we're at the end of the current
+			 * data page advance to the next one
+			 */
+			if (dpage_offset >=3D diter.length) {
+				if (WARN_ON(!sg_miter_next(&diter))) {
+					ret =3D 0x01;
+					goto out;
+				}
+				dpage_offset =3D 0;
+			}
+
+			sdt =3D piter.addr + ppage_offset;
+			daddr =3D diter.addr + dpage_offset;
+
+			if (SCpnt->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT */
+				ret =3D dif_verify(sdt, daddr, sector, ei_lba);
+				if (ret)
+					goto out;
+			}
+
+			sector++;
+			ei_lba++;
+			dpage_offset +=3D sdebug_sector_size;
+		}
+		diter.consumed =3D dpage_offset;
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
+
+module_param_named(dif, sdebug_dif, int, S_IRUGO);
+module_param_named(dix, sdebug_dix, int, S_IRUGO);
+
+MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=3D0)");
+MODULE_PARM_DESC(dix, "data integrity extensions mask (def=3D0)");
diff --git a/drivers/scsi/scsi_debug_dif.h b/drivers/scsi/scsi_debug_dif.=
h
new file mode 100644
index 000000000000..7af633ced854
--- /dev/null
+++ b/drivers/scsi/scsi_debug_dif.h
@@ -0,0 +1,57 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_DEBUG_DIF_H
+#define _SCSI_DEBUG_DIF_H
+
+#include <linux/kconfig.h>
+#include <linux/types.h>
+#include <linux/spinlock_types.h>
+#include <scsi/scsi_cmnd.h>
+
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
+/* There is an xarray of pointers to this struct's objects, one per host=
 */
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
+int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
+		     unsigned int sectors, u32 ei_lba);
+int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
+		      unsigned int sectors, u32 ei_lba);
+
+#else /* CONFIG_CRC_T10DIF */
+
+static inline int prot_verify_read(struct scsi_cmnd *scp, sector_t start=
_sec,
+				   unsigned int sectors, u32 ei_lba)
+{
+	return 0x01; /* GUARD check failed */
+}
+
+static inline int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t st=
art_sec,
+				    unsigned int sectors, u32 ei_lba)
+{
+	return 0x01; /* GUARD check failed */
+}
+
+#endif /* CONFIG_CRC_T10DIF */
+
+#endif /* _SCSI_DEBUG_DIF_H */
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug_main.c
similarity index 97%
rename from drivers/scsi/scsi_debug.c
rename to drivers/scsi/scsi_debug_main.c
index 1597156cb573..7bc08c55c9e1 100644
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
=20
-#include <net/checksum.h>
-
 #include <asm/unaligned.h>
=20
 #include <scsi/scsi.h>
@@ -59,6 +55,7 @@
 #include <scsi/scsi_dbg.h>
=20
 #include "sd.h"
+#include "scsi_debug_dif.h"
 #include "scsi_logging.h"
=20
 /* make sure inq_product_rev string corresponds to this version */
@@ -120,13 +117,10 @@ static const char *sdebug_version_date =3D "2021052=
0";
 #define DEF_DEV_SIZE_PRE_INIT   0
 #define DEF_DEV_SIZE_MB   8
 #define DEF_ZBC_DEV_SIZE_MB   128
-#define DEF_DIF 0
-#define DEF_DIX 0
 #define DEF_PER_HOST_STORE false
 #define DEF_D_SENSE   0
 #define DEF_EVERY_NTH   0
 #define DEF_FAKE_RW	0
-#define DEF_GUARD 0
 #define DEF_HOST_LOCK 0
 #define DEF_LBPU 0
 #define DEF_LBPWS 0
@@ -367,14 +361,6 @@ struct sdebug_host_info {
 	struct list_head dev_info_list;
 };
=20
-/* There is an xarray of pointers to this struct's objects, one per host=
 */
-struct sdeb_store_info {
-	rwlock_t macc_lck;	/* for atomic media access on this store */
-	u8 *storep;		/* user data storage (ram) */
-	struct t10_pi_tuple *dif_storep; /* protection info */
-	void *map_storep;	/* provisioning map */
-};
-
 #define dev_to_sdebug_host(d)	\
 	container_of(d, struct sdebug_host_info, dev)
=20
@@ -785,12 +771,9 @@ static int sdebug_ato =3D DEF_ATO;
 static int sdebug_cdb_len =3D DEF_CDB_LEN;
 static int sdebug_jdelay =3D DEF_JDELAY;	/* if > 0 then unit is jiffies =
*/
 static int sdebug_dev_size_mb =3D DEF_DEV_SIZE_PRE_INIT;
-static int sdebug_dif =3D DEF_DIF;
-static int sdebug_dix =3D DEF_DIX;
 static int sdebug_dsense =3D DEF_D_SENSE;
 static int sdebug_every_nth =3D DEF_EVERY_NTH;
 static int sdebug_fake_rw =3D DEF_FAKE_RW;
-static unsigned int sdebug_guard =3D DEF_GUARD;
 static int sdebug_host_max_queue;	/* per host */
 static int sdebug_lowest_aligned =3D DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns =3D DEF_MAX_LUNS;
@@ -808,7 +791,7 @@ static int sdebug_physblk_exp =3D DEF_PHYSBLK_EXP;
 static int sdebug_opt_xferlen_exp =3D DEF_OPT_XFERLEN_EXP;
 static int sdebug_ptype =3D DEF_PTYPE; /* SCSI peripheral device type */
 static int sdebug_scsi_level =3D DEF_SCSI_LEVEL;
-static int sdebug_sector_size =3D DEF_SECTOR_SIZE;
+int sdebug_sector_size =3D DEF_SECTOR_SIZE;
 static int sdeb_tur_ms_to_ready =3D DEF_TUR_MS_TO_READY;
 static int sdebug_virtual_gb =3D DEF_VIRTUAL_GB;
 static int sdebug_vpd_use_hostno =3D DEF_VPD_USE_HOSTNO;
@@ -850,7 +833,7 @@ enum sam_lun_addr_method {SAM_LUN_AM_PERIPHERAL =3D 0=
x0,
 static enum sam_lun_addr_method sdebug_lun_am =3D SAM_LUN_AM_PERIPHERAL;
 static int sdebug_lun_am_i =3D (int)SAM_LUN_AM_PERIPHERAL;
=20
-static unsigned int sdebug_store_sectors;
+unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
=20
 /* old BIOS stuff, kernel may get rid of them but some mode sense pages
@@ -863,7 +846,7 @@ static LIST_HEAD(sdebug_host_list);
 static DEFINE_MUTEX(sdebug_host_list_mutex);
=20
 static struct xarray per_store_arr;
-static struct xarray *per_store_ap =3D &per_store_arr;
+struct xarray *const per_store_ap =3D &per_store_arr;
 static int sdeb_first_idx =3D -1;		/* invalid index =3D=3D> none created=
 */
 static int sdeb_most_recent_idx =3D -1;
 static DEFINE_RWLOCK(sdeb_fake_rw_lck);	/* need a RW lock when fake_rw=3D=
1 */
@@ -874,9 +857,6 @@ static int num_dev_resets;
 static int num_target_resets;
 static int num_bus_resets;
 static int num_host_resets;
-static int dix_writes;
-static int dix_reads;
-static int dif_errors;
=20
 /* ZBC global data */
 static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed dis=
ks */
@@ -1174,27 +1154,6 @@ static inline bool scsi_debug_lbp(void)
 		(sdebug_lbpu || sdebug_lbpws || sdebug_lbpws10);
 }
=20
-static void *lba2fake_store(struct sdeb_store_info *sip,
-			    unsigned long long lba)
-{
-	struct sdeb_store_info *lsip =3D sip;
-
-	lba =3D do_div(lba, sdebug_store_sectors);
-	if (!sip || !sip->storep) {
-		WARN_ON_ONCE(true);
-		lsip =3D xa_load(per_store_ap, 0);  /* should never be NULL */
-	}
-	return lsip->storep + lba * sdebug_sector_size;
-}
-
-static struct t10_pi_tuple *dif_store(struct sdeb_store_info *sip,
-				      sector_t sector)
-{
-	sector =3D sector_div(sector, sdebug_store_sectors);
-
-	return sip->dif_storep + sector;
-}
-
 static void sdebug_max_tgts_luns(void)
 {
 	struct sdebug_host_info *sdbg_host;
@@ -3353,8 +3312,8 @@ static inline int check_device_access_params
  * that access any of the "stores" in struct sdeb_store_info should call=
 this
  * function with bug_if_fake_rw set to true.
  */
-static inline struct sdeb_store_info *devip2sip(struct sdebug_dev_info *=
devip,
-						bool bug_if_fake_rw)
+struct sdeb_store_info *devip2sip(struct sdebug_dev_info *devip,
+				  bool bug_if_fake_rw)
 {
 	if (sdebug_fake_rw) {
 		BUG_ON(bug_if_fake_rw);	/* See note above */
@@ -3457,131 +3416,6 @@ static bool comp_write_worker(struct sdeb_store_i=
nfo *sip, u64 lba, u32 num,
 	return res;
 }
=20
-static __be16 dif_compute_csum(const void *buf, int len)
-{
-	__be16 csum;
-
-	if (sdebug_guard)
-		csum =3D (__force __be16)ip_compute_csum(buf, len);
-	else
-		csum =3D cpu_to_be16(crc_t10dif(buf, len));
-
-	return csum;
-}
-
-static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
-		      sector_t sector, u32 ei_lba)
-{
-	__be16 csum =3D dif_compute_csum(data, sdebug_sector_size);
-
-	if (sdt->guard_tag !=3D csum) {
-		pr_err("GUARD check failed on sector %lu rcvd 0x%04x, data 0x%04x\n",
-			(unsigned long)sector,
-			be16_to_cpu(sdt->guard_tag),
-			be16_to_cpu(csum));
-		return 0x01;
-	}
-	if (sdebug_dif =3D=3D T10_PI_TYPE1_PROTECTION &&
-	    be32_to_cpu(sdt->ref_tag) !=3D (sector & 0xffffffff)) {
-		pr_err("REF check failed on sector %lu\n",
-			(unsigned long)sector);
-		return 0x03;
-	}
-	if (sdebug_dif =3D=3D T10_PI_TYPE2_PROTECTION &&
-	    be32_to_cpu(sdt->ref_tag) !=3D ei_lba) {
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
-	struct sdeb_store_info *sip =3D devip2sip((struct sdebug_dev_info *)
-						scp->device->hostdata, true);
-	struct t10_pi_tuple *dif_storep =3D sip->dif_storep;
-	const void *dif_store_end =3D dif_storep + sdebug_store_sectors;
-	struct sg_mapping_iter miter;
-
-	/* Bytes of protection data to copy into sgl */
-	resid =3D sectors * sizeof(*dif_storep);
-
-	sg_miter_start(&miter, scsi_prot_sglist(scp),
-		       scsi_prot_sg_count(scp), SG_MITER_ATOMIC |
-		       (read ? SG_MITER_TO_SG : SG_MITER_FROM_SG));
-
-	while (sg_miter_next(&miter) && resid > 0) {
-		size_t len =3D min_t(size_t, miter.length, resid);
-		void *start =3D dif_store(sip, sector);
-		size_t rest =3D 0;
-
-		if (dif_store_end < start + len)
-			rest =3D start + len - dif_store_end;
-
-		paddr =3D miter.addr;
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
-		sector +=3D len / sizeof(*dif_storep);
-		resid -=3D len;
-	}
-	sg_miter_stop(&miter);
-}
-
-static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
-			    unsigned int sectors, u32 ei_lba)
-{
-	int ret =3D 0;
-	unsigned int i;
-	sector_t sector;
-	struct sdeb_store_info *sip =3D devip2sip((struct sdebug_dev_info *)
-						scp->device->hostdata, true);
-	struct t10_pi_tuple *sdt;
-
-	for (i =3D 0; i < sectors; i++, ei_lba++) {
-		sector =3D start_sec + i;
-		sdt =3D dif_store(sip, sector);
-
-		if (sdt->app_tag =3D=3D cpu_to_be16(0xffff))
-			continue;
-
-		/*
-		 * Because scsi_debug acts as both initiator and
-		 * target we proceed to verify the PI even if
-		 * RDPROTECT=3D3. This is done so the "initiator" knows
-		 * which type of error to return. Otherwise we would
-		 * have to iterate over the PI twice.
-		 */
-		if (scp->cmnd[1] >> 5) { /* RDPROTECT */
-			ret =3D dif_verify(sdt, lba2fake_store(sip, sector),
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
@@ -3789,78 +3623,6 @@ static int resp_read_dt0(struct scsi_cmnd *scp, st=
ruct sdebug_dev_info *devip)
 	return 0;
 }
=20
-static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec=
,
-			     unsigned int sectors, u32 ei_lba)
-{
-	int ret;
-	struct t10_pi_tuple *sdt;
-	void *daddr;
-	sector_t sector =3D start_sec;
-	int ppage_offset;
-	int dpage_offset;
-	struct sg_mapping_iter diter;
-	struct sg_mapping_iter piter;
-
-	BUG_ON(scsi_sg_count(SCpnt) =3D=3D 0);
-	BUG_ON(scsi_prot_sg_count(SCpnt) =3D=3D 0);
-
-	sg_miter_start(&piter, scsi_prot_sglist(SCpnt),
-			scsi_prot_sg_count(SCpnt),
-			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
-	sg_miter_start(&diter, scsi_sglist(SCpnt), scsi_sg_count(SCpnt),
-			SG_MITER_ATOMIC | SG_MITER_FROM_SG);
-
-	/* For each protection page */
-	while (sg_miter_next(&piter)) {
-		dpage_offset =3D 0;
-		if (WARN_ON(!sg_miter_next(&diter))) {
-			ret =3D 0x01;
-			goto out;
-		}
-
-		for (ppage_offset =3D 0; ppage_offset < piter.length;
-		     ppage_offset +=3D sizeof(struct t10_pi_tuple)) {
-			/* If we're at the end of the current
-			 * data page advance to the next one
-			 */
-			if (dpage_offset >=3D diter.length) {
-				if (WARN_ON(!sg_miter_next(&diter))) {
-					ret =3D 0x01;
-					goto out;
-				}
-				dpage_offset =3D 0;
-			}
-
-			sdt =3D piter.addr + ppage_offset;
-			daddr =3D diter.addr + dpage_offset;
-
-			if (SCpnt->cmnd[1] >> 5 !=3D 3) { /* WRPROTECT */
-				ret =3D dif_verify(sdt, daddr, sector, ei_lba);
-				if (ret)
-					goto out;
-			}
-
-			sector++;
-			ei_lba++;
-			dpage_offset +=3D sdebug_sector_size;
-		}
-		diter.consumed =3D dpage_offset;
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
@@ -6191,8 +5953,6 @@ module_param_named(cdb_len, sdebug_cdb_len, int, 06=
44);
 module_param_named(clustering, sdebug_clustering, bool, S_IRUGO | S_IWUS=
R);
 module_param_named(delay, sdebug_jdelay, int, S_IRUGO | S_IWUSR);
 module_param_named(dev_size_mb, sdebug_dev_size_mb, int, S_IRUGO);
-module_param_named(dif, sdebug_dif, int, S_IRUGO);
-module_param_named(dix, sdebug_dix, int, S_IRUGO);
 module_param_named(dsense, sdebug_dsense, int, S_IRUGO | S_IWUSR);
 module_param_named(every_nth, sdebug_every_nth, int, S_IRUGO | S_IWUSR);
 module_param_named(fake_rw, sdebug_fake_rw, int, S_IRUGO | S_IWUSR);
@@ -6268,8 +6028,6 @@ MODULE_PARM_DESC(cdb_len, "suggest CDB lengths to d=
rivers (def=3D10)");
 MODULE_PARM_DESC(clustering, "when set enables larger transfers (def=3D0=
)");
 MODULE_PARM_DESC(delay, "response delay (def=3D1 jiffy); 0:imm, -1,-2:ti=
ny");
 MODULE_PARM_DESC(dev_size_mb, "size in MiB of ram shared by devs(def=3D8=
)");
-MODULE_PARM_DESC(dif, "data integrity field type: 0-3 (def=3D0)");
-MODULE_PARM_DESC(dix, "data integrity extensions mask (def=3D0)");
 MODULE_PARM_DESC(dsense, "use descriptor sense format(def=3D0 -> fixed)"=
);
 MODULE_PARM_DESC(every_nth, "timeout every nth command(def=3D0)");
 MODULE_PARM_DESC(fake_rw, "fake reads/writes instead of copying (def=3D0=
)");
