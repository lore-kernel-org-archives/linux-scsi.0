From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] scsi_error: set DID_TIME_OUT correctly
Date: Fri, 13 Jun 2014 14:01:45 +0200
Message-ID: <1402660906-74661-2-git-send-email-hare@suse.de>
References: <1402660906-74661-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaFMMB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 08:01:57 -0400
In-Reply-To: <1402660906-74661-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bart vn Assche <bvanassche@acm.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Any callbacks in scsi_timeout_out() might return BLK_EH_RESET_TIMER,
in which case we should leave the result alone and not set
DID_TIME_OUT, as the command didn't actually timeout.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 47a1ffc..ff176a6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -291,11 +291,11 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		if (scsi_abort_command(scmd) == SUCCESS)
 			return BLK_EH_NOT_HANDLED;
 
-	scmd->result |= DID_TIME_OUT << 16;
-
-	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
-		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
-		rtn = BLK_EH_HANDLED;
+	if (unlikely(rtn == BLK_EH_NOT_HANDLED)) {
+		scmd->result |= DID_TIME_OUT << 16;
+		if (!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))
+			rtn = BLK_EH_HANDLED;
+	}
 
 	return rtn;
 }
-- 
1.7.12.4

