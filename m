From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/9] blk-timeout: add BLK_EH_SCHEDULED return code
Date: Mon, 10 Jun 2013 09:40:51 +0200
Message-ID: <1370850058-27613-3-git-send-email-hare@suse.de>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab3FJHlC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jun 2013 03:41:02 -0400
In-Reply-To: <1370850058-27613-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Add a 'BLK_EH_SCHEDULED' return code for blk-timeout to indicate
that a delayed error recovery has been initiated.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 3 +++
 include/linux/blkdev.h    | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f43de1e..96b4bb6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -146,6 +146,9 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
 		rtn = host->hostt->eh_timed_out(scmd);
 
 	scmd->result |= DID_TIME_OUT << 16;
+	/* Check for delayed EH scheduling */
+	if (rtn == BLK_EH_SCHEDULED)
+		return BLK_EH_NOT_HANDLED;
 
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD)))
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

