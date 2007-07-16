From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/4] advansys: Clean up proc_info implementation
Date: Mon, 16 Jul 2007 16:41:50 -0600
Message-ID: <11846257131961-git-send-email-matthew@wil.cx>
References: <1184625712490-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:48921 "EHLO
	smtp-04.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbXGPXJ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jul 2007 19:09:27 -0400
In-Reply-To: <1184625712490-git-send-email-matthew@wil.cx>
In-Reply-To: <20070716202815.GQ13826@parisc-linux.org>
References: <20070716202815.GQ13826@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Just use the Scsi_Host passed in, rather than looking through the driver's
own array of boards for one that matches it.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   35 +++++++++++------------------------
 1 files changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 2b6cf30..83fd9c7 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4072,9 +4072,7 @@ static int
 advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		off_t offset, int length, int inout)
 {
-    struct Scsi_Host    *shp;
     asc_board_t         *boardp;
-    int                 i;
     char                *cp;
     int			cplen;
     int                 cnt;
@@ -4099,18 +4097,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      * User read of /proc/scsi/advansys/[0...] file.
      */
 
-    /* Find the specified board. */
-    for (i = 0; i < asc_board_count; i++) {
-        if (asc_host[i]->host_no == shost->host_no) {
-            break;
-        }
-    }
-    if (i == asc_board_count) {
-        return(-ENOENT);
-    }
-
-    shp = asc_host[i];
-    boardp = ASC_BOARDP(shp);
+    boardp = ASC_BOARDP(shost);
 
     /* Copy read data starting at the beginning of the buffer. */
     *start = buffer;
@@ -4124,7 +4111,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      *
      * advansys_info() returns the board string from its own static buffer.
      */
-    cp = (char *) advansys_info(shp);
+    cp = (char *) advansys_info(shost);
     strcat(cp, "\n");
     cplen = strlen(cp);
     /* Copy board information. */
@@ -4143,7 +4130,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      */
     if (ASC_WIDE_BOARD(boardp)) {
         cp = boardp->prtbuf;
-        cplen = asc_prt_adv_bios(shp, cp, ASC_PRTBUF_SIZE);
+        cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
         ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
         cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
         totcnt += cnt;
@@ -4160,7 +4147,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      * Display driver information for each device attached to the board.
      */
     cp = boardp->prtbuf;
-    cplen = asc_prt_board_devices(shp, cp, ASC_PRTBUF_SIZE);
+    cplen = asc_prt_board_devices(shost, cp, ASC_PRTBUF_SIZE);
     ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
     cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
     totcnt += cnt;
@@ -4177,9 +4164,9 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      */
     cp = boardp->prtbuf;
     if (ASC_NARROW_BOARD(boardp)) {
-        cplen = asc_prt_asc_board_eeprom(shp, cp, ASC_PRTBUF_SIZE);
+        cplen = asc_prt_asc_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
     } else {
-        cplen = asc_prt_adv_board_eeprom(shp, cp, ASC_PRTBUF_SIZE);
+        cplen = asc_prt_adv_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
     }
     ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
     cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
@@ -4196,7 +4183,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      * Display driver configuration and information for the board.
      */
     cp = boardp->prtbuf;
-    cplen = asc_prt_driver_conf(shp, cp, ASC_PRTBUF_SIZE);
+    cplen = asc_prt_driver_conf(shost, cp, ASC_PRTBUF_SIZE);
     ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
     cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
     totcnt += cnt;
@@ -4213,7 +4200,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      * Display driver statistics for the board.
      */
     cp = boardp->prtbuf;
-    cplen = asc_prt_board_stats(shp, cp, ASC_PRTBUF_SIZE);
+    cplen = asc_prt_board_stats(shost, cp, ASC_PRTBUF_SIZE);
     ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
     cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
     totcnt += cnt;
@@ -4230,7 +4217,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      */
     for (tgt_id = 0; tgt_id <= ADV_MAX_TID; tgt_id++) {
       cp = boardp->prtbuf;
-      cplen = asc_prt_target_stats(shp, tgt_id, cp, ASC_PRTBUF_SIZE);
+      cplen = asc_prt_target_stats(shost, tgt_id, cp, ASC_PRTBUF_SIZE);
       ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
       cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
       totcnt += cnt;
@@ -4250,9 +4237,9 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
      */
     cp = boardp->prtbuf;
     if (ASC_NARROW_BOARD(boardp)) {
-        cplen = asc_prt_asc_board_info(shp, cp, ASC_PRTBUF_SIZE);
+        cplen = asc_prt_asc_board_info(shost, cp, ASC_PRTBUF_SIZE);
     } else {
-        cplen = asc_prt_adv_board_info(shp, cp, ASC_PRTBUF_SIZE);
+        cplen = asc_prt_adv_board_info(shost, cp, ASC_PRTBUF_SIZE);
     }
     ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
     cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-- 
1.4.4.4

