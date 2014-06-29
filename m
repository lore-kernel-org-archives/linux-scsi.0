From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/10] sd: retry write same commands
Date: Sun, 29 Jun 2014 15:34:38 +0200
Message-ID: <1404048881-19526-8-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46579 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaF2Nce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:34 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Currently cmd->allowed is initialized from rq->retries for write same
commands, but retries is always 0 for non-BLOCK_PC requests.  Set it
to the standard number of retries instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9737e78..777b141 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -843,7 +843,7 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	}
 
 	cmd->transfersize = sdp->sector_size;
-	cmd->allowed = rq->retries;
+	cmd->allowed = SD_MAX_RETRIES;
 
 	/*
 	 * For WRITE_SAME the data transferred in the DATA IN buffer is
-- 
1.7.10.4

