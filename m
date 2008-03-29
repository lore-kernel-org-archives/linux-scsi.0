From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/5] scsi_debug: sweep up sdebug_capacity calculation
Date: Sun, 30 Mar 2008 00:59:55 +0900
Message-ID: <1206806398-22205-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35455 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYC2QAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 12:00:54 -0400
In-Reply-To: <1206806398-22205-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

sdebug_capacity is calculated at five different places. This add a
helper function to calculate sdebug_capacity to sweep up the
duplicatated code.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   44 +++++++++++++++++---------------------------
 1 files changed, 17 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4e93b69..70bcee6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -823,6 +823,14 @@ static int resp_start_stop(struct scsi_cmnd * scp,
 	return 0;
 }
 
+static sector_t get_sdebug_capacity(void)
+{
+	if (scsi_debug_virtual_gb > 0)
+		return 2048 * 1024 * scsi_debug_virtual_gb;
+	else
+		return sdebug_store_sectors;
+}
+
 #define SDEBUG_READCAP_ARR_SZ 8
 static int resp_readcap(struct scsi_cmnd * scp,
 			struct sdebug_dev_info * devip)
@@ -834,11 +842,7 @@ static int resp_readcap(struct scsi_cmnd * scp,
 	if ((errsts = check_readiness(scp, 1, devip)))
 		return errsts;
 	/* following just in case virtual_gb changed */
-	if (scsi_debug_virtual_gb > 0) {
-		sdebug_capacity = 2048 * 1024;
-		sdebug_capacity *= scsi_debug_virtual_gb;
-	} else
-		sdebug_capacity = sdebug_store_sectors;
+	sdebug_capacity = get_sdebug_capacity();
 	memset(arr, 0, SDEBUG_READCAP_ARR_SZ);
 	if (sdebug_capacity < 0xffffffff) {
 		capac = (unsigned int)sdebug_capacity - 1;
@@ -871,11 +875,7 @@ static int resp_readcap16(struct scsi_cmnd * scp,
 	alloc_len = ((cmd[10] << 24) + (cmd[11] << 16) + (cmd[12] << 8)
 		     + cmd[13]);
 	/* following just in case virtual_gb changed */
-	if (scsi_debug_virtual_gb > 0) {
-		sdebug_capacity = 2048 * 1024;
-		sdebug_capacity *= scsi_debug_virtual_gb;
-	} else
-		sdebug_capacity = sdebug_store_sectors;
+	sdebug_capacity = get_sdebug_capacity();
 	memset(arr, 0, SDEBUG_READCAP16_ARR_SZ);
 	capac = sdebug_capacity - 1;
 	for (k = 0; k < 8; ++k, capac >>= 8)
@@ -1169,13 +1169,9 @@ static int resp_mode_sense(struct scsi_cmnd * scp, int target,
 		offset = 8;
 	}
 	ap = arr + offset;
-	if ((bd_len > 0) && (0 == sdebug_capacity)) {
-		if (scsi_debug_virtual_gb > 0) {
-			sdebug_capacity = 2048 * 1024;
-			sdebug_capacity *= scsi_debug_virtual_gb;
-		} else
-			sdebug_capacity = sdebug_store_sectors;
-	}
+	if ((bd_len > 0) && (!sdebug_capacity))
+		sdebug_capacity = get_sdebug_capacity();
+
 	if (8 == bd_len) {
 		if (sdebug_capacity > 0xfffffffe) {
 			ap[0] = 0xff;
@@ -2392,11 +2388,9 @@ static ssize_t sdebug_virtual_gb_store(struct device_driver * ddp,
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		scsi_debug_virtual_gb = n;
-		if (scsi_debug_virtual_gb > 0) {
-			sdebug_capacity = 2048 * 1024;
-			sdebug_capacity *= scsi_debug_virtual_gb;
-		} else
-			sdebug_capacity = sdebug_store_sectors;
+
+		sdebug_capacity = get_sdebug_capacity();
+
 		return count;
 	}
 	return -EINVAL;
@@ -2507,11 +2501,7 @@ static int __init scsi_debug_init(void)
 		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
 	sz = (unsigned int)scsi_debug_dev_size_mb * 1048576;
 	sdebug_store_sectors = sz / SECT_SIZE;
-	if (scsi_debug_virtual_gb > 0) {
-		sdebug_capacity = 2048 * 1024;
-		sdebug_capacity *= scsi_debug_virtual_gb;
-	} else
-		sdebug_capacity = sdebug_store_sectors;
+	sdebug_capacity = get_sdebug_capacity();
 
 	/* play around with geometry, don't waste too much on track 0 */
 	sdebug_heads = 8;
-- 
1.5.3.7

