From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] scsi: gdth.c use unaligned access helpers
Date: Thu, 03 Jul 2008 18:38:43 -0700
Message-ID: <1215135523.16647.52.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:30317 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbYGDBjQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2008 21:39:16 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1278306rvb.1
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2008 18:39:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

Remove two now unnecessary local vars.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/gdth.c |   23 ++++++++++-------------
 1 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 822d521..239274f 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -131,6 +131,7 @@
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
@@ -2441,8 +2442,8 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 {
     register gdth_cmd_str *cmdp;
     struct gdth_cmndinfo *cmndinfo = gdth_cmnd_priv(scp);
-    ulong32 cnt, blockcnt;
-    ulong64 no, blockno;
+    ulong32 blockcnt;
+    ulong64 blockno;
     int i, cmd_index, read_write, sgcnt, mode64;
 
     cmdp = ha->pccb;
@@ -2510,19 +2511,15 @@ static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive)
 
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
+		blockcnt= scp->cmnd[4]==0 ? 0x100 : scp->cmnd[4];
         }
         if (mode64) {
             cmdp->u.cache64.BlockNo = blockno;
-- 
1.5.6.1.281.g1087e



