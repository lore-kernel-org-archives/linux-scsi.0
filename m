From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/26] scsi: check for correct return code in scsi_eh_abort_cmds()
Date: Tue,  7 Oct 2014 11:03:24 +0200
Message-ID: <1412672605-42868-26-git-send-email-hare@suse.de>
References: <1412672605-42868-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42646 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbaJGJDh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2014 05:03:37 -0400
In-Reply-To: <1412672605-42868-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

scsi_try_to_abort_cmd() might return SUCCESS, FAILED, or
FAST_IO_FAIL. So just checking for FAILED will treat
FAST_IO_FAIL as SUCCESS, which is wrong.

Cc: Robert Elliott <elliott@hp.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9209407..06cd624 100644
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

