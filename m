From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] blk-timeout: add BLK_EH_SCHEDULED return code
Date: Wed, 30 Oct 2013 09:37:50 +0100
Message-ID: <1383122272-93572-3-git-send-email-hare@suse.de>
References: <1383122272-93572-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab3J3Ih7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:37:59 -0400
In-Reply-To: <1383122272-93572-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Hannes Reinecke <hare@suse.de>

Add a 'BLK_EH_SCHEDULED' return code for blk-timeout to indicate
that a delayed error recovery has been initiated.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 4 ++++
 include/linux/blkdev.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 67c0014..af51a9c 100644
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
index 0e6f765..afec57c 100644
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
1.8.1.4

