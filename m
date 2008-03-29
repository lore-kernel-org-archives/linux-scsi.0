From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/5] scsi_debug: remove unnecessary sdebug_store_size
Date: Sun, 30 Mar 2008 00:59:54 +0900
Message-ID: <1206806398-22205-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35454 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbYC2QAx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 12:00:53 -0400
In-Reply-To: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

sdebug_store_size doesn't need to be static global. It's used at
startup only.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 65c88dd..4e93b69 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -148,7 +148,6 @@ static int scsi_debug_cmnd_count = 0;
 #define DEV_READONLY(TGT)      (0)
 #define DEV_REMOVEABLE(TGT)    (0)
 
-static unsigned int sdebug_store_size;	/* in bytes */
 static unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
 
@@ -1969,7 +1968,8 @@ static void __init init_all_queued(void)
 	spin_unlock_irqrestore(&queued_arr_lock, iflags);
 }
 
-static void __init sdebug_build_parts(unsigned char * ramp)
+static void __init sdebug_build_parts(unsigned char *ramp,
+				      unsigned int store_size)
 {
 	struct partition * pp;
 	int starts[SDEBUG_MAX_PARTS + 2];
@@ -1977,7 +1977,7 @@ static void __init sdebug_build_parts(unsigned char * ramp)
 	int heads_by_sects, start_sec, end_sec;
 
 	/* assume partition table already zeroed */
-	if ((scsi_debug_num_parts < 1) || (sdebug_store_size < 1048576))
+	if ((scsi_debug_num_parts < 1) || (store_size < 1048576))
 		return;
 	if (scsi_debug_num_parts > SDEBUG_MAX_PARTS) {
 		scsi_debug_num_parts = SDEBUG_MAX_PARTS;
@@ -2505,8 +2505,8 @@ static int __init scsi_debug_init(void)
 
 	if (scsi_debug_dev_size_mb < 1)
 		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
-	sdebug_store_size = (unsigned int)scsi_debug_dev_size_mb * 1048576;
-	sdebug_store_sectors = sdebug_store_size / SECT_SIZE;
+	sz = (unsigned int)scsi_debug_dev_size_mb * 1048576;
+	sdebug_store_sectors = sz / SECT_SIZE;
 	if (scsi_debug_virtual_gb > 0) {
 		sdebug_capacity = 2048 * 1024;
 		sdebug_capacity *= scsi_debug_virtual_gb;
@@ -2530,7 +2530,6 @@ static int __init scsi_debug_init(void)
 			       (sdebug_sectors_per * sdebug_heads);
 	}
 
-	sz = sdebug_store_size;
 	fake_storep = vmalloc(sz);
 	if (NULL == fake_storep) {
 		printk(KERN_ERR "scsi_debug_init: out of memory, 1\n");
@@ -2538,7 +2537,7 @@ static int __init scsi_debug_init(void)
 	}
 	memset(fake_storep, 0, sz);
 	if (scsi_debug_num_parts > 0)
-		sdebug_build_parts(fake_storep);
+		sdebug_build_parts(fake_storep, sz);
 
 	ret = device_register(&pseudo_primary);
 	if (ret < 0) {
-- 
1.5.3.7

