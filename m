From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/20] scsi: Use scsi_print_command() where possible
Date: Wed,  3 Sep 2014 12:06:06 +0200
Message-ID: <1409738775-80876-12-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397AbaICKG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:28 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Some drivers use __scsi_print_command() although in fact
they refer to the scsi command. So move them over to use
scsi_print_command() instead.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aha152x.c       |  6 ++----
 drivers/scsi/arm/acornscsi.c |  9 +++++----
 drivers/scsi/arm/fas216.c    | 30 +++++++++++++-----------------
 3 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 447568a..bc923d1 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2443,11 +2443,9 @@ static void disp_enintr(struct Scsi_Host *shpnt)
  */
 static void show_command(Scsi_Cmnd *ptr)
 {
-	scmd_printk(KERN_DEBUG, ptr, "%p: cmnd=(", ptr);
+	scsi_print_command(ptr);
 
-	__scsi_print_command(ptr->cmnd);
-
-	printk(KERN_DEBUG "); request_bufflen=%d; resid=%d; phase |",
+	scmd_printk(KERN_DEBUG, ptr, "request_bufflen=%d; resid=%d; phase |",
 	       scsi_bufflen(ptr), scsi_get_resid(ptr));
 
 	if (ptr->SCp.phase & not_issued)
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index d89b9b4..78dd881 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -850,11 +850,12 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 			break;
 
 		    default:
-			printk(KERN_ERR "scsi%d.H: incomplete data transfer detected: result=%08X command=",
-				host->host->host_no, SCpnt->result);
-			__scsi_print_command(SCpnt->cmnd);
+			scmd_printk(KERN_ERR, SCPnt,
+				    "incomplete data transfer detected:"
+				    " result=%08X\n", SCpnt->result);
+			scsi_print_command(SCpnt);
 			acornscsi_dumpdma(host, "done");
-		 	acornscsi_dumplog(host, SCpnt->device->id);
+			acornscsi_dumplog(host, SCpnt->device->id);
 			SCpnt->result &= 0xffff;
 			SCpnt->result |= DID_ERROR << 16;
 		    }
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 71cfb1e..778fd36 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -308,8 +308,7 @@ static void fas216_log_command(FAS216_Info *info, int level,
 	fas216_do_log(info, '0' + SCpnt->device->id, fmt, args);
 	va_end(args);
 
-	printk(" CDB: ");
-	__scsi_print_command(SCpnt->cmnd);
+	scsi_print_command(SCpnt);
 }
 
 static void
@@ -2079,12 +2078,12 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 			break;
 
 		default:
-			printk(KERN_ERR "scsi%d.%c: incomplete data transfer "
-				"detected: res=%08X ptr=%p len=%X CDB: ",
-				info->host->host_no, '0' + SCpnt->device->id,
-				SCpnt->result, info->scsi.SCp.ptr,
-				info->scsi.SCp.this_residual);
-			__scsi_print_command(SCpnt->cmnd);
+			scmd_printk(KERN_ERR, SCpnt,
+				    "incomplete data transfer "
+				    "detected: res=%08X ptr=%p len=%X\n",
+				    SCpnt->result, info->scsi.SCp.ptr,
+				    info->scsi.SCp.this_residual);
+			scsi_print_command(SCpnt->cmnd);
 			SCpnt->result &= ~(255 << 16);
 			SCpnt->result |= DID_BAD_TARGET << 16;
 			goto request_sense;
@@ -2158,12 +2157,11 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * to transfer, we should not have a valid pointer.
 	 */
 	if (info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
-		printk("scsi%d.%c: zero bytes left to transfer, but "
-		       "buffer pointer still valid: ptr=%p len=%08x CDB: ",
-		       info->host->host_no, '0' + SCpnt->device->id,
-		       info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
+		scmd_printk(KERN_INFO, SCpnt, "zero bytes left to transfer, "
+			    "but buffer pointer still valid: ptr=%p len=%08x\n",
+			    info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
 		info->scsi.SCp.ptr = NULL;
-		__scsi_print_command(SCpnt->cmnd);
+		scsi_print_command(SCpnt);
 	}
 
 	/*
@@ -2427,14 +2425,12 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 
 	info->stats.aborts += 1;
 
-	printk(KERN_WARNING "scsi%d: abort command ", info->host->host_no);
-	__scsi_print_command(SCpnt->cmnd);
+	scmd_printk(KERN_WARNING, SCpnt, "abort command %p\n", SCpnt);
+	scsi_print_command(SCpnt);
 
 	print_debug_list();
 	fas216_dumpstate(info);
 
-	printk(KERN_WARNING "scsi%d: abort %p ", info->host->host_no, SCpnt);
-
 	switch (fas216_find_command(info, SCpnt)) {
 	/*
 	 * We found the command, and cleared it out.  Either
-- 
1.8.5.2

