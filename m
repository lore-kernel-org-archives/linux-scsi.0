From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] ses: check return code from ses_recv_diag()
Date: Tue, 15 Aug 2017 10:21:41 +0200
Message-ID: <1502785303-41870-3-git-send-email-hare@suse.de>
References: <1502785303-41870-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751068AbdHOIVs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 04:21:48 -0400
In-Reply-To: <1502785303-41870-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

We should be checking the return code from ses_recv_diag() to
avoid accessing invalid data.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ses.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index a37aec8..fc70c00 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -179,7 +179,8 @@ static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
 	unsigned char *type_ptr = ses_dev->page1_types;
 	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
-	ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len);
+	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len) < 0)
+		return NULL;
 
 	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {
 		for (j = 0; j < type_ptr[1]; j++) {
-- 
1.8.5.6
