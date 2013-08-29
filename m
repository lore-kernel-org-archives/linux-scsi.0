From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/9] blk-timeout: add BLK_EH_SCHEDULED return code
Date: Thu, 29 Aug 2013 15:32:13 +0200
Message-ID: <1377783140-57191-3-git-send-email-hare@suse.de>
References: <1377783140-57191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab3H2NcY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Aug 2013 09:32:24 -0400
In-Reply-To: <1377783140-57191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>, Hannes Reinecke <hare@suse.de>

Add a 'BLK_EH_SCHEDULED' return code for blk-timeout to indicate
that a delayed error recovery has been initiated.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 4 ++++
 include/linux/blkdev.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c88cb7e..b7dd774 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -161,6 +161,10 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 	else if (host->hostt->eh_timed_out)
 		rtn = host->hostt->eh_timed_out(scmd);
 
+	/* Check for asynchronous command aborts */
+	if (rtn == BLK_EH_SCHEDULED)
+		return BLK_EH_NOT_HANDLED;
+
 	scmd->result |= DID_TIME_OUT << 16;
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2fdb4a4..d846e2b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -238,6 +238,7 @@ enum blk_eh_timer_return {
 	BLK_EH_NOT_HANDLED,
 	BLK_EH_HANDLED,
 	BLK_EH_RESET_TIMER,
+	BLK_EH_SCHEDULED,
 };
 
 typedef enum blk_eh_timer_return (rq_timed_out_fn)(struct request *);
-- 
1.7.12.4

