From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/5] scsi_debug: support large non-fake virtual disk
Date: Sun, 30 Mar 2008 00:59:57 +0900
Message-ID: <1206806398-22205-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1206806398-22205-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1206806398-22205-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:41059 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYC2QAy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Mar 2008 12:00:54 -0400
In-Reply-To: <1206806398-22205-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

Currently, the maximum amount of RAM that scsi_debug can allocate is
4GB. This patch increases it to 2TB; scsi_debug can allocates 2TB
memory and export it as if it were 2TB scsi disk.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c98559e..1b6a6d8 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -1949,7 +1949,7 @@ static void __init init_all_queued(void)
 }
 
 static void __init sdebug_build_parts(unsigned char *ramp,
-				      unsigned int store_size)
+				      unsigned long store_size)
 {
 	struct partition * pp;
 	int starts[SDEBUG_MAX_PARTS + 2];
@@ -2476,14 +2476,14 @@ static void do_remove_driverfs_files(void)
 
 static int __init scsi_debug_init(void)
 {
-	unsigned int sz;
+	unsigned long sz;
 	int host_to_add;
 	int k;
 	int ret;
 
 	if (scsi_debug_dev_size_mb < 1)
 		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
-	sz = (unsigned int)scsi_debug_dev_size_mb * 1048576;
+	sz = (unsigned long)scsi_debug_dev_size_mb * 1048576;
 	sdebug_store_sectors = sz / SECT_SIZE;
 	sdebug_capacity = get_sdebug_capacity();
 
-- 
1.5.3.7

