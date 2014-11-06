From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/10] scsi: Do not display buffer pointers in scsi_log_send()
Date: Thu,  6 Nov 2014 09:30:39 +0100
Message-ID: <1415262639-121586-11-git-send-email-hare@suse.de>
References: <1415262639-121586-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaKFIaq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 03:30:46 -0500
In-Reply-To: <1415262639-121586-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsi_log_send() would display buffer pointer for higher
logging levels. This is not only of questionable value
but also exposes kernel pointer to userspace, which is
discouraged in some setups. So drop this message
altogether.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 92d5912..9ec576d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -531,7 +531,7 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 	 *
 	 * 3: same as 2
 	 *
-	 * 4: same as 3 plus dump extra junk
+	 * 4: same as 3
 	 */
 	if (unlikely(scsi_logging_level)) {
 		level = SCSI_LOG_LEVEL(SCSI_LOG_MLQUEUE_SHIFT,
@@ -540,13 +540,6 @@ void scsi_log_send(struct scsi_cmnd *cmd)
 			scmd_printk(KERN_INFO, cmd,
 				    "Send: scmd 0x%p\n", cmd);
 			scsi_print_command(cmd);
-			if (level > 3) {
-				printk(KERN_INFO "buffer = 0x%p, bufflen = %d,"
-				       " queuecommand 0x%p\n",
-					scsi_sglist(cmd), scsi_bufflen(cmd),
-					cmd->device->host->hostt->queuecommand);
-
-			}
 		}
 	}
 }
-- 
1.8.5.2

