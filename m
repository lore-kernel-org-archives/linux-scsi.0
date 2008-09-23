From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 2/2] scsi: annotate gdth_rdcap_data, gdth_rdcap16_data
 endianness
Date: Tue, 23 Sep 2008 13:38:27 -0700
Message-ID: <1222202307.16003.12.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:14530 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYIWUig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2008 16:38:36 -0400
Received: by rn-out-0910.google.com with SMTP id k40so725888rnd.17
        for <linux-scsi@vger.kernel.org>; Tue, 23 Sep 2008 13:38:33 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

It would be easy to get rid of the typedefs too, but I kept this
minimal.

Noticed by sparse:
drivers/scsi/gdth.c:2395:31: warning: incorrect type in assignment (different base types)
drivers/scsi/gdth.c:2395:31:    expected unsigned int [unsigned] [assigned] [usertype] last_block_no
drivers/scsi/gdth.c:2395:31:    got restricted __be32 [usertype] <noident>
drivers/scsi/gdth.c:2396:27: warning: incorrect type in assignment (different base types)
drivers/scsi/gdth.c:2396:27:    expected unsigned int [unsigned] [assigned] [usertype] block_length
drivers/scsi/gdth.c:2396:27:    got restricted __be32 [usertype] <noident>
drivers/scsi/gdth.c:2406:33: warning: incorrect type in assignment (different base types)
drivers/scsi/gdth.c:2406:33:    expected unsigned long long [unsigned] [usertype] last_block_no
drivers/scsi/gdth.c:2406:33:    got restricted __be64 [usertype] <noident>
drivers/scsi/gdth.c:2407:33: warning: incorrect type in assignment (different base types)
drivers/scsi/gdth.c:2407:33:    expected unsigned int [unsigned] [usertype] block_length
drivers/scsi/gdth.c:2407:33:    got restricted __be32 [usertype] <noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/gdth.c |    2 +-
 drivers/scsi/gdth.h |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index a788aa1..6e94e54 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2391,7 +2391,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp)
       case READ_CAPACITY:
         TRACE2(("Read capacity hdrive %d\n",t));
         if (ha->hdr[t].size > (ulong64)0xffffffff)
-            rdc.last_block_no = 0xffffffff;
+            rdc.last_block_no = cpu_to_be32(0xffffffff);
         else
             rdc.last_block_no = cpu_to_be32(ha->hdr[t].size-1);
         rdc.block_length  = cpu_to_be32(SECTOR_SIZE);
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 1646444..c685745 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -968,14 +968,14 @@ typedef struct {
 
 /* READ_CAPACITY data format */
 typedef struct {
-    ulong32     last_block_no;
-    ulong32     block_length;
+	__be32 last_block_no;
+	__be32 block_length;
 } PACKED gdth_rdcap_data;
 
 /* READ_CAPACITY (16) data format */
 typedef struct {
-    ulong64     last_block_no;
-    ulong32     block_length;
+	__be64 last_block_no;
+	__be32 block_length;
 } PACKED gdth_rdcap16_data;
 
 /* REQUEST_SENSE data format */
-- 
1.6.0.2.450.gdb265

