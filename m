From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 25/26] scsi: check for corrent return code in scsi_eh_abort_cmds()
Date: Mon,  6 Oct 2014 11:01:25 +0200
Message-ID: <1412586086-129821-26-git-send-email-hare@suse.de>
References: <1412586086-129821-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbaJFJBi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2014 05:01:38 -0400
In-Reply-To: <1412586086-129821-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

scsi_try_to_abort_cmd() might return SUCCESS, FAILED, or
FAST_IO_FAIL. So just checking for FAILED will treat
FAST_IO_FAIL as SUCCESS, which is wrong.

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

