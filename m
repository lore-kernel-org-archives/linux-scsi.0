From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] ses: Retry Power-on-reset check condition
Date: Thu, 21 Dec 2017 12:22:34 +0100
Message-ID: <1513855354-86603-4-git-send-email-hare@suse.de>
References: <1513855354-86603-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60781 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752088AbdLULWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 06:22:38 -0500
In-Reply-To: <1513855354-86603-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

During startup any SCSI request might encounter a 'Power-on/reset'
sense code, which just can be retried.
In the case of ses it needs to be retried, otherwise ses will
errorneously detect this as a failure and not attach the driver.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ses.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c1f96b0..9c8b3db 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -110,14 +110,20 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
+	int retries = SES_RETRIES;
 	struct scsi_sense_hdr sshdr;
 
+retry:
 	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				&sshdr, SES_TIMEOUT, SES_RETRIES, NULL);
+				&sshdr, SES_TIMEOUT, retries, NULL);
 	if (unlikely(ret)) {
-		if (status_byte(ret) == CHECK_CONDITION &&
-		    sshdr.asc == 0x25 && sshdr.ascq == 0x00) {
-			ret = -ENODEV;
+		if (status_byte(ret) == CHECK_CONDITION) {
+			if (sshdr.asc == 0x29) {
+				retries--;
+				goto retry;
+			}
+			if (sshdr.asc == 0x25 && sshdr.ascq == 0x00)
+				ret = -ENODEV;
 		}
 		return ret;
 	}
-- 
1.8.5.6
