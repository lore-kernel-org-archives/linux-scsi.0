From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] gdth: Stop abusing ->done for internal commands
Date: Tue, 25 Sep 2007 12:42:03 -0400
Message-ID: <1190738524757-git-send-email-willy@linux.intel.com>
References: <1190738524460-git-send-email-willy@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:56324 "EHLO
	mail-01.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbXIYQmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 12:42:07 -0400
In-Reply-To: <1190738524460-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

From: Matthew Wilcox <matthew@wil.cx>

The ->done member was being used to mark commands as being internal.
I decided to put a magic number in ->underflow instead.  I believe this
to be safe as no current user of ->underflow has any of the bottom 9
bits set.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/gdth.c      |   19 +++++++++++--------
 drivers/scsi/gdth_proc.c |    4 ++--
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8a6a5f8..42a200f 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -691,6 +691,9 @@ static const struct file_operations gdth_fops = {
     .release = gdth_close,
 };
 
+#define GDTH_MAGIC	0xc2e7c389	/* I got it from /dev/urandom */
+#define IS_GDTH_INTERNAL_CMD(scp)	(scp->underflow == GDTH_MAGIC)
+
 #include "gdth_proc.h"
 #include "gdth_proc.c"
 
@@ -713,7 +716,7 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
 {
 	TRACE2(("gdth_scsi_done()\n"));
 
-	if (scp->done == gdth_scsi_done)
+	if (IS_GDTH_INTERNAL_CMD(scp))
 		complete((struct completion *)scp->request);
 	else 
 		scp->scsi_done(scp);
@@ -738,7 +741,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
     scp->cmd_len = 12;
     memcpy(scp->cmnd, cmnd, 12);
     scp->SCp.this_residual = IOCTL_PRI;   /* priority */
-    scp->done = gdth_scsi_done;
+    scp->underflow = GDTH_MAGIC;
     gdth_queuecommand(scp, NULL);
     wait_for_completion(&wait);
 
@@ -2319,7 +2322,7 @@ static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority)
     ha = HADATA(gdth_ctr_tab[hanum]);
     spin_lock_irqsave(&ha->smp_lock, flags);
 
-    if (scp->done != gdth_scsi_done) {
+    if (!IS_GDTH_INTERNAL_CMD(scp)) {
         scp->SCp.this_residual = (int)priority;
         b = virt_ctr ? NUMDATA(scp->device->host)->busnum:scp->device->channel;
         t = scp->device->id;
@@ -2382,7 +2385,7 @@ static void gdth_next(int hanum)
     for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
         if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
             pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
-        if (nscp->done != gdth_scsi_done) {
+        if (!IS_GDTH_INTERNAL_CMD(nscp)) {
             b = virt_ctr ?
                 NUMDATA(nscp->device->host)->busnum : nscp->device->channel;
             t = nscp->device->id;
@@ -2408,7 +2411,7 @@ static void gdth_next(int hanum)
             firsttime = FALSE;
         }
 
-        if (nscp->done != gdth_scsi_done) {
+        if (!IS_GDTH_INTERNAL_CMD(nscp)) {
         if (nscp->SCp.phase == -1) {
             nscp->SCp.phase = CACHESERVICE;           /* default: cache svc. */ 
             if (nscp->cmnd[0] == TEST_UNIT_READY) {
@@ -2471,7 +2474,7 @@ static void gdth_next(int hanum)
                 else
                     gdth_scsi_done(nscp);
             }
-        } else if (nscp->done == gdth_scsi_done) {
+        } else if (IS_GDTH_INTERNAL_CMD(nscp)) {
             if (!(cmd_index=gdth_special_cmd(hanum,nscp)))
                 this_cmd = FALSE;
             next_cmd = FALSE;
@@ -3812,7 +3815,7 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
                     scp->sense_buffer[2] = NOT_READY;
                     scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
                 }
-                if (scp->done != gdth_scsi_done) {
+                if (!IS_GDTH_INTERNAL_CMD(scp)) {
                     ha->dvr.size = sizeof(ha->dvr.eu.sync);
                     ha->dvr.eu.sync.ionode  = hanum;
                     ha->dvr.eu.sync.service = service;
@@ -4910,7 +4913,7 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
 #endif
 
     priority = DEFAULT_PRI;
-    if (scp->done == gdth_scsi_done)
+    if (IS_GDTH_INTERNAL_CMD(scp))
         priority = scp->SCp.this_residual;
     else
         gdth_update_timeout(hanum, scp, scp->timeout_per_command * 6);
diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
index 32982eb..1f8d9a5 100644
--- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -805,7 +805,7 @@ static void gdth_stop_timeout(int hanum, int busnum, int id)
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        if (scp->done != gdth_scsi_done) {
+        if (!IS_GDTH_INTERNAL_CMD(scp)) {
             b = virt_ctr ?
                 NUMDATA(scp->device->host)->busnum : scp->device->channel;
             t = scp->device->id;
@@ -829,7 +829,7 @@ static void gdth_start_timeout(int hanum, int busnum, int id)
     spin_lock_irqsave(&ha->smp_lock, flags);
 
     for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
-        if (scp->done != gdth_scsi_done) {
+        if (!IS_GDTH_INTERNAL_CMD(scp)) {
             b = virt_ctr ?
                 NUMDATA(scp->device->host)->busnum : scp->device->channel;
             t = scp->device->id;
-- 
1.5.3.1

