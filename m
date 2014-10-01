From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 13/24] scsi: remove scsi_print_status()
Date: Wed,  1 Oct 2014 08:22:49 +0200
Message-ID: <1412144580-72880-14-git-send-email-hare@suse.de>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaJAGXI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2014 02:23:08 -0400
In-Reply-To: <1412144580-72880-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

Last caller is gone, so we can remove it.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 35 -----------------------------------
 include/scsi/scsi_dbg.h  |  1 -
 2 files changed, 36 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 55ece2a..6e16b19 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -433,41 +433,6 @@ void scsi_print_command(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL(scsi_print_command);
 
-/**
- *	scsi_print_status - print scsi status description
- *	@scsi_status: scsi status value
- *
- *	If the status is recognized, the description is printed.
- *	Otherwise "Unknown status" is output. No trailing space.
- *	If CONFIG_SCSI_CONSTANTS is not set, then print status in hex
- *	(e.g. "0x2" for Check Condition).
- **/
-void
-scsi_print_status(unsigned char scsi_status) {
-#ifdef CONFIG_SCSI_CONSTANTS
-	const char * ccp;
-
-	switch (scsi_status) {
-	case 0:    ccp = "Good"; break;
-	case 0x2:  ccp = "Check Condition"; break;
-	case 0x4:  ccp = "Condition Met"; break;
-	case 0x8:  ccp = "Busy"; break;
-	case 0x10: ccp = "Intermediate"; break;
-	case 0x14: ccp = "Intermediate-Condition Met"; break;
-	case 0x18: ccp = "Reservation Conflict"; break;
-	case 0x22: ccp = "Command Terminated"; break;	/* obsolete */
-	case 0x28: ccp = "Task set Full"; break;	/* was: Queue Full */
-	case 0x30: ccp = "ACA Active"; break;
-	case 0x40: ccp = "Task Aborted"; break;
-	default:   ccp = "Unknown status";
-	}
-	printk(KERN_INFO "%s", ccp);
-#else
-	printk(KERN_INFO "0x%0x", scsi_status);
-#endif
-}
-EXPORT_SYMBOL(scsi_print_status);
-
 #ifdef CONFIG_SCSI_CONSTANTS
 
 struct error_info {
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index cd0c873..44bea15 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -19,7 +19,6 @@ extern void __scsi_print_sense(struct scsi_device *, const char *name,
 			       int sense_len);
 extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
-extern void scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
 					  const char **);
-- 
1.8.5.2

