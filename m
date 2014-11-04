From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/10] scsi: Move remaining printk() statement to scmd_printk()
Date: Tue,  4 Nov 2014 09:06:49 +0100
Message-ID: <1415088409-46590-11-git-send-email-hare@suse.de>
References: <1415088409-46590-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbaKDIG4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:06:56 -0500
In-Reply-To: <1415088409-46590-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

One statement was missing from the conversion to dev_printk().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 92d5912..9880b59 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -541,10 +541,12 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 				    "Send: scmd 0x%p\n", cmd);
 			scsi_print_command(cmd);
 			if (level > 3) {
-				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
-				       " queuecommand 0x%p\n",
-					scsi_sglist(cmd), scsi_bufflen(cmd),
-					cmd->device->host->hostt->queuecommand);
+				struct Scsi_Host *shost = cmd->device->host;
+				scmd_printk(KERN_INFO, cmd,
+					    "buffer = 0x%p, bufflen = %d,"
+					    " queuecommand 0x%p\n",
+					    scsi_sglist(cmd), scsi_bufflen(cmd),
+					    shost->hostt->queuecommand);
 
 			}
 		}
-- 
1.8.5.2

