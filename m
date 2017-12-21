From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] ses: skip error messages for invalid LUNs
Date: Thu, 21 Dec 2017 12:22:33 +0100
Message-ID: <1513855354-86603-3-git-send-email-hare@suse.de>
References: <1513855354-86603-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752066AbdLULWh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 06:22:37 -0500
In-Reply-To: <1513855354-86603-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Some storage array set the 'Embedded enclosure' bit even though
no LUN is present, causing the first RECEIVE DIAGNOSTIC call to
be returned with sense code 'LOGICAL UNIT NOT SUPPORTED'.
This patch skips the annoying 'Failed to get diagnostic page 0x1'
messages for those cases.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ses.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index e8ffee1..c1f96b0 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -110,12 +110,17 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
+	struct scsi_sense_hdr sshdr;
 
 	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
-	if (unlikely(ret))
+				&sshdr, SES_TIMEOUT, SES_RETRIES, NULL);
+	if (unlikely(ret)) {
+		if (status_byte(ret) == CHECK_CONDITION &&
+		    sshdr.asc == 0x25 && sshdr.ascq == 0x00) {
+			ret = -ENODEV;
+		}
 		return ret;
-
+	}
 	recv_page_code = ((unsigned char *)buf)[0];
 
 	if (likely(recv_page_code == page_code))
@@ -674,9 +679,14 @@ static int ses_intf_add(struct device *cdev,
 
 	page = 1;
 	result = ses_recv_diag(sdev, page, hdr_buf, ses_alloc_size);
-	if (result)
+	if (result) {
+		if (result == -ENODEV &&
+		    sdev->inq_periph_qual != 0) {
+			kfree(hdr_buf);
+			return result;
+		}
 		goto recv_failed;
-
+	}
 	len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
 	buf = kzalloc(len, GFP_KERNEL);
 	if (!buf)
-- 
1.8.5.6
