From: akpm@linux-foundation.org
Subject: [patch 10/17] scsi: gdth.c use unaligned access helpers
Date: Mon, 22 Sep 2008 14:56:47 -0700
Message-ID: <200809222156.m8MLum2c032291@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653AbYIVV53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2008 17:57:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, harvey.harrison@gmail.com, bharrosh@panasas.com

From: Harvey Harrison <harvey.harrison@gmail.com>

Remove two now unnecessary local vars.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/gdth.c~scsi-gdthc-use-unaligned-access-helpers drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-gdthc-use-unaligned-access-helpers
+++ a/drivers/scsi/gdth.c
@@ -131,6 +131,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
@@ -2429,8 +2430,8 @@ static int gdth_fill_cache_cmd(gdth_ha_s
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-    ulong32 cnt, blockcnt;
-    ulong64 no, blockno;
+    ulong32 blockcnt;
+    ulong64 blockno;
     int i, cmd_index, read_write, sgcnt, mode64;
 
     cmdp = ha->pccb;
@@ -2498,19 +2499,15 @@ static int gdth_fill_cache_cmd(gdth_ha_s
 
     if (read_write) {
         if (scp->cmd_len == 16) {
-            memcpy(&no, &scp->cmnd[2], sizeof(ulong64));
-            blockno = be64_to_cpu(no);
-            memcpy(&cnt, &scp->cmnd[10], sizeof(ulong32));
-            blockcnt = be32_to_cpu(cnt);
+		blockno = get_unaligned_be64(&scp->cmnd[2]);
+		blockcnt = get_unaligned_be64(&scp->cmnd[10]);
         } else if (scp->cmd_len == 10) {
-            memcpy(&no, &scp->cmnd[2], sizeof(ulong32));
-            blockno = be32_to_cpu(no);
-            memcpy(&cnt, &scp->cmnd[7], sizeof(ushort));
-            blockcnt = be16_to_cpu(cnt);
+		blockno = get_unaligned_be32(&scp->cmnd[2]);
+		blockcnt = get_unaligned_be16(&scp->cmnd[7]);
         } else {
-            memcpy(&no, &scp->cmnd[0], sizeof(ulong32));
-            blockno = be32_to_cpu(no) & 0x001fffffUL;
-            blockcnt= scp->cmnd[4]==0 ? 0x100 : scp->cmnd[4];
+		blockno = get_unaligned_be32(&scp->cmnd[2]);
+		blockno &= 0x001fffffUL;
+		blockcnt = scp->cmnd[4] == 0 ? 0x100 : scp->cmnd[4];
         }
         if (mode64) {
             cmdp->u.cache64.BlockNo = blockno;
_
