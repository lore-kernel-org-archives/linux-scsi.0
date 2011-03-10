From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH] libsas: fix ata list corruption issue
Date: Thu, 10 Mar 2011 17:13:18 -0600
Message-ID: <1299798798.11933.167.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:60385 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab1CJXNX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Mar 2011 18:13:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-ide <linux-ide@vger.kernel.org>

I think this stems from a misunderstanding of how the ata error handler
works.  ata_scsi_cmd_error_handler() gets called with a passed in list
of commands to handle.  However, that list may still not be empty when
it exits.  The command ata_scsi_port_error_handler() must be called
(which takes no list) before the list will be completely emptied.  This
bites the sas error handler because the two are called from different
functions and the original list has gone out of scope before
ata_scsi_port_error_handler() is called. leading to some commands
dangling on bare stack, which is a potential memory corruption issue.
Fix this by manually deleting all outstanding commands from the on-stack
list before it goes out of scope.

James

---

diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 16c5094..3356bf3 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -802,6 +802,19 @@ int sas_ata_eh(struct Scsi_Host *shost, struct list_head *work_q,
 		if (!list_empty(&sata_q)) {
 			ata_port_printk(ap, KERN_DEBUG, "sas eh calling libata cmd error handler\n");
 			ata_scsi_cmd_error_handler(shost, ap, &sata_q);
+			/*
+			 * ata's error handler may leave the cmd on the list
+			 * so make sure they don't remain on a stack list
+			 * about to go out of scope.
+			 *
+			 * This looks strange, since the commands are
+			 * now part of no list, but the next error
+			 * action will be ata_port_error_handler()
+			 * which takes no list and sweeps them up
+			 * anyway from the ata tag array.
+			 */
+			while (!list_empty(&sata_q))
+				list_del_init(sata_q.next);
 		}
 	} while (ap);
 


