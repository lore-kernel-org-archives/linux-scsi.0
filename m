From: Andries.Brouwer@cwi.nl
Subject: [patch] NCR53C9x.c fix
Date: Tue, 20 May 2003 15:59:06 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200305201359.h4KDx6p22636.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:7311 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263773AbTETNqU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2003 09:46:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com
Cc: davem@redhat.com, jskov@cygnus.co.uk, linux-scsi@vger.kernel.org, tymm@coe.missouri.edu

This is the second one in the series of patches for SCSI drivers
that confuse CHECK_CONDITION and CHECK_CONDITION << 1.
It is relative to 2.5.69-bk13.

Andries

diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
--- a/drivers/scsi/NCR53C9x.c	Tue May 20 11:26:43 2003
+++ b/drivers/scsi/NCR53C9x.c	Tue May 20 16:38:06 2003
@@ -1262,7 +1262,7 @@
 	esp_get_dmabufs(esp, SCpnt);
 	esp_save_pointers(esp, SCpnt); /* FIXME for tag queueing */
 
-	SCpnt->SCp.Status           = CHECK_CONDITION;
+	SCpnt->SCp.Status           = (CHECK_CONDITION << 1);
 	SCpnt->SCp.Message          = 0xff;
 	SCpnt->SCp.sent_command     = 0;
 
@@ -2224,8 +2224,8 @@
 		if(esp->disconnected_SC)
 			esp_cmd(esp, eregs, ESP_CMD_ESEL);
 
-		if(SCptr->SCp.Status != GOOD &&
-		   SCptr->SCp.Status != CONDITION_GOOD &&
+		if(status_byte(SCptr->SCp.Status) != GOOD &&
+		   status_byte(SCptr->SCp.Status) != CONDITION_GOOD &&
 		   ((1<<SCptr->device->id) & esp->targets_present) &&
 		   esp_dev->sync && esp_dev->sync_max_offset) {
 			/* SCSI standard says that the synchronous capabilities
