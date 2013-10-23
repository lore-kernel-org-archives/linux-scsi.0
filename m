From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] scsi_error: Escalate to LUN reset if abort fails
Date: Wed, 23 Oct 2013 10:51:22 +0200
Message-ID: <1382518282-107606-9-git-send-email-hare@suse.de>
References: <1382518282-107606-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55155 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab3JWIv1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Oct 2013 04:51:27 -0400
In-Reply-To: <1382518282-107606-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Hannes Reinecke <hare@suse.de>

If a command abort fails there is a fair chance that all other
aborts will be failing, too.
So we should be calling LUN reset directly after the first failed
abort and skip aborting the remaining commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index edae9e2..e8bee9f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1192,18 +1192,20 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 						  "0x%p\n", current->comm,
 						  scmd));
 		rtn = scsi_try_to_abort_cmd(shost->hostt, scmd);
-		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
-			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
-			if (rtn == FAST_IO_FAIL)
-				scsi_eh_finish_cmd(scmd, done_q);
-			else
-				list_move_tail(&scmd->eh_entry, &check_list);
-		} else
+		if (rtn == FAILED) {
 			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting"
 							  " cmd failed:"
 							  "0x%p\n",
 							  current->comm,
 							  scmd));
+			list_splice_init(&check_list, work_q);
+			return list_empty(work_q);
+		}
+		scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
+		if (rtn == FAST_IO_FAIL)
+			scsi_eh_finish_cmd(scmd, done_q);
+		else
+			list_move_tail(&scmd->eh_entry, &check_list);
 	}
 
 	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
-- 
1.8.1.4

