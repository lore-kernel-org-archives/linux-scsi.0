From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] scsi: Fixup ses page check
Date: Tue, 15 Aug 2017 10:21:40 +0200
Message-ID: <1502785303-41870-2-git-send-email-hare@suse.de>
References: <1502785303-41870-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36880 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751175AbdHOIVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 04:21:49 -0400
In-Reply-To: <1502785303-41870-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The error code from a scsi_execute_req() is a SCSI status, not
a normal errno. So whenever it returns a value here an error
occurred and there's no point in looking at the page number.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ses.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index f1cdf32..a37aec8 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -99,8 +99,8 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 
 	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
 				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
-	if (unlikely(!ret))
-		return ret;
+	if (unlikely(ret))
+		return -EIO;
 
 	recv_page_code = ((unsigned char *)buf)[0];
 
-- 
1.8.5.6
