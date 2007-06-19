From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] fix req->cmd == INT cases
Date: Tue, 19 Jun 2007 18:59:12 +0300
Message-ID: <4677FD50.2090803@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:49576 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756775AbXFSQEI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 12:04:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Bristow <paul@paulbristow.net>, Dave Gilbert <linux@treblig.org>, Russell King <rmk@arm.linux.org.uk>, Dave Alan Gilbert <gilbertd@cs.man.ac.uk>, Paul Clements <Paul.Clements@steeleye.com>, Pavel Machek <pavel@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, Eberhard Moenkeberg <emoenke@gwdg.de>, David van Leeuwen <avid@tm.tno.nl>, Oliver Raupach <raupach@nwfs1.rz.fh-hannover.de>, Heiko Schlittermann <heiko@lotte.sax.de>, Leo Spiekman <spiekman@dutette.et.tudelft.nl>, "Vadim V. Model" <model@cecmow.enet.dec.com>, linux-scsi <linux-scsi@vger.kernel.org>

>From 6f4641911701cbdbe01516305b682012d8c6982a Mon Sep 17 00:00:00 2001
Date: Tue, 19 Jun 2007 18:54:54 +0300

 I have unearthed very old bugs in stale drivers that still
 used request->cmd as a READ|WRITE int.
 This patch is maybe a proof that these drivers have not been
 used for a long time. Should they be removed completely?

 If you are CCed it means your name was in one of these drivers
 source files, or in the MAINTAINERS file. Please acknowledge
 the possible removal of this old driver.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

drivers/acorn/block/fd1772.c
Jens Axboe
Paul Bristow <paul@paulbristow.net>
Dave Gilbert (linux@treblig.org)

drivers/acorn/block/mfmhd.c
TO: Russell King <rmk@arm.linux.org.uk>
TO: Dave Alan Gilbert <gilbertd@cs.man.ac.uk>

drivers/block/amiflop.c
Greg Harp
Joerg Dorchain

drivers/block/nbd.c
Paul Clements <Paul.Clements@steeleye.com>
Pavel Machek <pavel@suse.cz>
Steven Whitehouse <swhiteho@redhat.com>

drivers/cdrom/aztcd.c
Eberhard Moenkeberg <emoenke@gwdg.de>
Werner Zimmermann(Werner.Zimmermann@fht-esslingen.de)

drivers/cdrom/cm206.c
David van Leeuwen <avid@tm.tno.nl>

drivers/cdrom/gscd.c
Oliver Raupach <raupach@nwfs1.rz.fh-hannover.de>

drivers/cdrom/mcdx.c
Heiko Schlittermann <heiko@lotte.sax.de>

drivers/cdrom/optcd.c
Leo Spiekman <spiekman@dutette.et.tudelft.nl>

drivers/cdrom/sjcd.c
Vadim V. Model <model@cecmow.enet.dec.com>
vadim@rbrf.ru
vadim@ipsun.ras.ru

drivers/ide/legacy/hd.c
Linus Trovalds
---
 drivers/acorn/block/fd1772.c |    2 +-
 drivers/acorn/block/mfmhd.c  |    9 +++++----
 drivers/block/amiflop.c      |    2 +-
 drivers/block/nbd.c          |    2 +-
 drivers/cdrom/aztcd.c        |    2 +-
 drivers/cdrom/cm206.c        |    2 +-
 drivers/cdrom/gscd.c         |    2 +-
 drivers/cdrom/mcdx.c         |    2 +-
 drivers/cdrom/optcd.c        |    2 +-
 drivers/cdrom/sjcd.c         |    2 +-
 drivers/ide/legacy/hd.c      |    4 ++--
 11 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/acorn/block/fd1772.c b/drivers/acorn/block/fd1772.c
index 674bf81..423ed08 100644
--- a/drivers/acorn/block/fd1772.c
+++ b/drivers/acorn/block/fd1772.c
@@ -1246,7 +1246,7 @@ repeat:
     del_timer(&motor_off_timer);
 
     ReqCnt = 0;
-    ReqCmd = CURRENT->cmd;
+    ReqCmd = rq_data_dir(CURRENT);
     ReqBlock = CURRENT->sector;
     ReqBuffer = CURRENT->buffer;
     setup_req_params(drive);
diff --git a/drivers/acorn/block/mfmhd.c b/drivers/acorn/block/mfmhd.c
index 689a4c3..7a4e12b 100644
--- a/drivers/acorn/block/mfmhd.c
+++ b/drivers/acorn/block/mfmhd.c
@@ -439,7 +439,7 @@ static void mfm_rw_intr(void)
        a choice of command end or some data which is ready to be
collected */
     /* I think we have to transfer data while the interrupt line is on
and its
        not any other type of interrupt */
-    if (CURRENT->cmd == WRITE) {
+    if (rq_data_dir(CURRENT) == WRITE) {
         extern void hdc63463_writedma(void);
         if ((hdc63463_dataleft <= 0) && (!(mfm_status & STAT_CED))) {
             printk("mfm_rw_intr: Apparent DMA write request when no
more to DMA\n");
@@ -799,7 +799,7 @@ static void issue_request(unsigned int block,
unsigned int nsect,
     raw_cmd.head = start_head;
     raw_cmd.cylinder = track / p->heads;
     raw_cmd.cmdtype = CURRENT->cmd;
-    raw_cmd.cmdcode = CURRENT->cmd == WRITE ? CMD_WD : CMD_RD;
+    raw_cmd.cmdcode = rq_data_dir(CURRENT) == WRITE ? CMD_WD : CMD_RD;
     raw_cmd.cmddata[0] = dev + 1;    /* DAG: +1 to get US */
     raw_cmd.cmddata[1] = raw_cmd.head;
     raw_cmd.cmddata[2] = raw_cmd.cylinder >> 8;
@@ -830,7 +830,7 @@ static void issue_request(unsigned int block,
unsigned int nsect,
     hdc63463_dataleft = nsect * 256;    /* Better way? */
 
     DBG("mfm%c: %sing: CHS=%d/%d/%d, sectors=%d, buffer=0x%08lx (%p)\n",
-         raw_cmd.dev + 'a', (CURRENT->cmd == READ) ? "read" : "writ",
+         raw_cmd.dev + 'a', rq_data_dir(CURRENT) == READ ? "read" : "writ",
                raw_cmd.cylinder,
                raw_cmd.head,
         raw_cmd.sector, nsect, (unsigned long) Copy_buffer, CURRENT);
@@ -917,7 +917,8 @@ static void mfm_request(void)
 
         DBG("mfm_request: block after offset=%d\n", block);
 
-        if (CURRENT->cmd != READ && CURRENT->cmd != WRITE) {
+        if (rq_data_dir(CURRENT) != READ &&
+                                    rq_data_dir(CURRENT) != WRITE) {
             printk("unknown mfm-command %d\n", CURRENT->cmd);
             end_request(CURRENT, 0);
             Busy = 0;
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 27a1390..6ce8b89 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1363,7 +1363,7 @@ static void redo_fd_request(void)
 #ifdef DEBUG
         printk("fd: sector %ld + %d requested for %s\n",
                CURRENT->sector,cnt,
-               (CURRENT->cmd==READ)?"read":"write");
+               (rq_data_dir(CURRENT) == READ) ? "read" : "write");
 #endif
         block = CURRENT->sector + cnt;
         if ((int)block > floppy->blocks) {
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 069ae39..c575fb1 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -416,7 +416,7 @@ static void nbd_clear_que(struct nbd_device *lo)
 /*
  * We always wait for result of write, for now. It would be nice to
make it optional
  * in future
- * if ((req->cmd == WRITE) && (lo->flags & NBD_WRITE_NOCHK))
+ * if ((rq_data_dir(req) == WRITE) && (lo->flags & NBD_WRITE_NOCHK))
  *   { printk( "Warning: Ignoring result!\n"); nbd_end_request( req ); }
  */
 
diff --git a/drivers/cdrom/aztcd.c b/drivers/cdrom/aztcd.c
index 1f9fb7a..d7fbfaa 100644
--- a/drivers/cdrom/aztcd.c
+++ b/drivers/cdrom/aztcd.c
@@ -229,7 +229,7 @@ static struct request_queue *azt_queue;
 static int current_valid(void)
 {
         return CURRENT &&
-        CURRENT->cmd == READ &&
+        rq_data_dir(CURRENT) == READ &&
         CURRENT->sector != -1;
 }
 
diff --git a/drivers/cdrom/cm206.c b/drivers/cdrom/cm206.c
index 2301311..2f8fe3b 100644
--- a/drivers/cdrom/cm206.c
+++ b/drivers/cdrom/cm206.c
@@ -851,7 +851,7 @@ static void do_cm206_request(request_queue_t * q)
         if (!req)
             return;
 
-        if (req->cmd != READ) {
+        if (rq_data_dir(req) != READ) {
             debug(("Non-read command %d on cdrom\n", req->cmd));
             end_request(req, 0);
             continue;
diff --git a/drivers/cdrom/gscd.c b/drivers/cdrom/gscd.c
index b3ab6e9..176742e 100644
--- a/drivers/cdrom/gscd.c
+++ b/drivers/cdrom/gscd.c
@@ -264,7 +264,7 @@ repeat:
     if (req->sector == -1)
         goto out;
 
-    if (req->cmd != READ) {
+    if (rq_data_dir(req) != READ) {
         printk("GSCD: bad cmd %u\n", rq_data_dir(req));
         end_request(req, 0);
         goto repeat;
diff --git a/drivers/cdrom/mcdx.c b/drivers/cdrom/mcdx.c
index 4310cc8..972ee9c 100644
--- a/drivers/cdrom/mcdx.c
+++ b/drivers/cdrom/mcdx.c
@@ -596,7 +596,7 @@ static void do_mcdx_request(request_queue_t * q)
     xtrace(REQUEST, "do_request() (%lu + %lu)\n",
            req->sector, req->nr_sectors);
 
-    if (req->cmd != READ) {
+    if (rq_data_dir(req) != READ) {
         xwarn("do_request(): non-read command to cd!!\n");
         xtrace(REQUEST, "end_request(0): write\n");
         end_request(req, 0);
diff --git a/drivers/cdrom/optcd.c b/drivers/cdrom/optcd.c
index 3541690..efd619c 100644
--- a/drivers/cdrom/optcd.c
+++ b/drivers/cdrom/optcd.c
@@ -977,7 +977,7 @@ static int update_toc(void)
 static int current_valid(void)
 {
         return CURRENT &&
-        CURRENT->cmd == READ &&
+        rq_data_dir(CURRENT) == READ &&
         CURRENT->sector != -1;
 }
 
diff --git a/drivers/cdrom/sjcd.c b/drivers/cdrom/sjcd.c
index 5409fca..76c24e6 100644
--- a/drivers/cdrom/sjcd.c
+++ b/drivers/cdrom/sjcd.c
@@ -1064,7 +1064,7 @@ static void sjcd_invalidate_buffers(void)
 static int current_valid(void)
 {
         return CURRENT &&
-        CURRENT->cmd == READ &&
+        rq_data_dir(CURRENT) == READ &&
         CURRENT->sector != -1;
 }
 
diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
index 45ed035..6004b7d 100644
--- a/drivers/ide/legacy/hd.c
+++ b/drivers/ide/legacy/hd.c
@@ -622,8 +622,8 @@ repeat:
     head  = track % disk->head;
     cyl   = track / disk->head;
 #ifdef DEBUG
-    printk("%s: %sing: CHS=%d/%d/%d, sectors=%d, buffer=%p\n",
-        req->rq_disk->disk_name, (req->cmd == READ)?"read":"writ",
+    printk("%s: %s: CHS=%d/%d/%d, sectors=%d, buffer=%p\n",
+        req->rq_disk->disk_name, dma_dir_to_string(rq_dma_dir(req)),
         cyl, head, sec, nsect, req->buffer);
 #endif
     if (blk_fs_request(req)) {
-- 
1.5.0.4.402.g8035


