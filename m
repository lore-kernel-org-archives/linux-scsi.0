From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.11-rc8
Date: Mon, 24 Apr 2017 10:33:34 -0400
Message-ID: <1493044414.2651.25.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59076 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1172412AbdDXOdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 10:33:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Our final fix before the 4.12 release (hopefully).  It's an error leg
again: the fix to not bug on empty DMA transfers is returning the wrong
code and confusing the block layer. 

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Johannes Thumshirn (1):
      scsi: return correct blkprep status code in case scsi_init_io() fails.

With the diffstat:

 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

And full diff below.

James

---
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 19125d72f322..5558e212368b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1061,10 +1061,10 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
 	bool is_mq = (rq->mq_ctx != NULL);
-	int error;
+	int error = BLKPREP_KILL;
 
 	if (WARN_ON_ONCE(!blk_rq_nr_phys_segments(rq)))
-		return -EINVAL;
+		goto err_exit;
 
 	error = scsi_init_sgtable(rq, &cmd->sdb);
 	if (error)
