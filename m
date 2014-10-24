From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/27] scsi: check for correct return code in scsi_eh_abort_cmds()
Date: Fri, 24 Oct 2014 14:27:05 +0200
Message-ID: <1414153627-2863-26-git-send-email-hare@suse.de>
References: <1414153627-2863-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584AbaJXM1T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Oct 2014 08:27:19 -0400
In-Reply-To: <1414153627-2863-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Robert Elliott <elliott@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

scsi_try_to_abort_cmd() might return SUCCESS, FAILED, or
FAST_IO_FAIL. So just checking for FAILED will treat
FAST_IO_FAIL as SUCCESS, which is wrong.

Cc: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index fa7b5ec..e94baf1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1345,7 +1345,7 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 			scmd_printk(KERN_INFO, scmd,
 				     "%s: aborting cmd\n", current->comm));
 		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
-		if (rtn == FAILED) {
+		if (rtn != SUCCESS) {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				scmd_printk(KERN_INFO, scmd,
 					    "%s: aborting cmd failed\n",
-- 
1.8.5.2

