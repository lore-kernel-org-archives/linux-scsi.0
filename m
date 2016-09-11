From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] scsi_debug: use struct t10_pi_tuple instead of struct sd_dif_tuple
Date: Sun, 11 Sep 2016 19:35:39 +0200
Message-ID: <1473615341-27203-2-git-send-email-hch@lst.de>
References: <1473615341-27203-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46207 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932307AbcIKRfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2016 13:35:47 -0400
In-Reply-To: <1473615341-27203-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

And remove the declaration of the latter in sd.h as scsi_debug was the
only user.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_debug.c | 15 ++++++++-------
 drivers/scsi/sd.h         |  9 ---------
 2 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6a219a0..044fc93 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -42,6 +42,7 @@
 #include <linux/atomic.h>
 #include <linux/hrtimer.h>
 #include <linux/uuid.h>
+#include <linux/t10-pi.h>
 
 #include <net/checksum.h>
 
@@ -627,7 +628,7 @@ static LIST_HEAD(sdebug_host_list);
 static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
 static unsigned char *fake_storep;	/* ramdisk storage */
-static struct sd_dif_tuple *dif_storep;	/* protection info */
+static struct t10_pi_tuple *dif_storep;	/* protection info */
 static void *map_storep;		/* provisioning map */
 
 static unsigned long map_size;
@@ -682,7 +683,7 @@ static void *fake_store(unsigned long long lba)
 	return fake_storep + lba * sdebug_sector_size;
 }
 
-static struct sd_dif_tuple *dif_store(sector_t sector)
+static struct t10_pi_tuple *dif_store(sector_t sector)
 {
 	sector = sector_div(sector, sdebug_store_sectors);
 
@@ -2430,7 +2431,7 @@ static __be16 dif_compute_csum(const void *buf, int len)
 	return csum;
 }
 
-static int dif_verify(struct sd_dif_tuple *sdt, const void *data,
+static int dif_verify(struct t10_pi_tuple *sdt, const void *data,
 		      sector_t sector, u32 ei_lba)
 {
 	__be16 csum = dif_compute_csum(data, sdebug_sector_size);
@@ -2504,7 +2505,7 @@ static int prot_verify_read(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			    unsigned int sectors, u32 ei_lba)
 {
 	unsigned int i;
-	struct sd_dif_tuple *sdt;
+	struct t10_pi_tuple *sdt;
 	sector_t sector;
 
 	for (i = 0; i < sectors; i++, ei_lba++) {
@@ -2696,7 +2697,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 			     unsigned int sectors, u32 ei_lba)
 {
 	int ret;
-	struct sd_dif_tuple *sdt;
+	struct t10_pi_tuple *sdt;
 	void *daddr;
 	sector_t sector = start_sec;
 	int ppage_offset;
@@ -2722,7 +2723,7 @@ static int prot_verify_write(struct scsi_cmnd *SCpnt, sector_t start_sec,
 		}
 
 		for (ppage_offset = 0; ppage_offset < piter.length;
-		     ppage_offset += sizeof(struct sd_dif_tuple)) {
+		     ppage_offset += sizeof(struct t10_pi_tuple)) {
 			/* If we're at the end of the current
 			 * data page advance to the next one
 			 */
@@ -5026,7 +5027,7 @@ static int __init scsi_debug_init(void)
 	if (sdebug_dix) {
 		int dif_size;
 
-		dif_size = sdebug_store_sectors * sizeof(struct sd_dif_tuple);
+		dif_size = sdebug_store_sectors * sizeof(struct t10_pi_tuple);
 		dif_storep = vmalloc(dif_size);
 
 		pr_err("dif_storep %u bytes @ %p\n", dif_size, dif_storep);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 765a6f1..d00966d 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -239,15 +239,6 @@ static inline unsigned int sd_prot_flag_mask(unsigned int prot_op)
 	return flag_mask[prot_op];
 }
 
-/*
- * Data Integrity Field tuple.
- */
-struct sd_dif_tuple {
-       __be16 guard_tag;	/* Checksum */
-       __be16 app_tag;		/* Opaque storage */
-       __be32 ref_tag;		/* Target LBA or indirect LBA */
-};
-
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 
 extern void sd_dif_config_host(struct scsi_disk *);
-- 
2.1.4

