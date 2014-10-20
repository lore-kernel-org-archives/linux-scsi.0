From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/27] fas216: Update logging messages
Date: Mon, 20 Oct 2014 08:52:11 +0200
Message-ID: <1413787950-14659-9-git-send-email-hare@suse.de>
References: <1413787950-14659-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaJTGwd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2014 02:52:33 -0400
In-Reply-To: <1413787950-14659-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Update logging messages to use dev_printk() variants for correct
device annotations.

Reviewed-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/fas216.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 7fc6fd3..cea3463 100644
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
@@ -2079,12 +2078,11 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 			break;
 
 		default:
-			printk(KERN_ERR "scsi%d.%c: incomplete data transfer "
-				"detected: res=%08X ptr=%p len=%X CDB: ",
-				info->host->host_no, '0' + SCpnt->device->id,
-				SCpnt->result, info->scsi.SCp.ptr,
-				info->scsi.SCp.this_residual);
-			__scsi_print_command(SCpnt->cmnd);
+			scmd_printk(KERN_ERR, SCpnt,
+				    "incomplete data transfer detected: res=%08X ptr=%p len=%X\n",
+				    SCpnt->result, info->scsi.SCp.ptr,
+				    info->scsi.SCp.this_residual);
+			scsi_print_command(SCpnt);
 			set_host_byte(SCpnt, DID_ERROR);
 			goto request_sense;
 		}
@@ -2157,12 +2155,11 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * to transfer, we should not have a valid pointer.
 	 */
 	if (info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
-		printk("scsi%d.%c: zero bytes left to transfer, but "
-		       "buffer pointer still valid: ptr=%p len=%08x CDB: ",
-		       info->host->host_no, '0' + SCpnt->device->id,
-		       info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
+		scmd_printk(KERN_INFO, SCpnt,
+			    "zero bytes left to transfer, but buffer pointer still valid: ptr=%p len=%08x\n",
+			    info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
 		info->scsi.SCp.ptr = NULL;
-		__scsi_print_command(SCpnt->cmnd);
+		scsi_print_command(SCpnt);
 	}
 
 	/*
@@ -2663,8 +2660,7 @@ int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
 
 	fas216_checkmagic(info);
 
-	printk("scsi%d.%c: %s: resetting host\n",
-		info->host->host_no, '0' + SCpnt->device->id, __func__);
+	fas216_log(info, LOG_ERROR, "resetting host");
 
 	/*
 	 * Reset the SCSI chip.
-- 
1.8.5.2

