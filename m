From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] ses: Fixup error message 'failed to get diagnostic page 0xffffffea'
Date: Tue, 15 Aug 2017 10:21:42 +0200
Message-ID: <1502785303-41870-4-git-send-email-hare@suse.de>
References: <1502785303-41870-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36882 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751344AbdHOIVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 04:21:49 -0400
In-Reply-To: <1502785303-41870-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The printk was using the result as argument, leading to a slightly
confusing log message.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/ses.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index fc70c00..46984cd 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -602,7 +602,7 @@ static int ses_intf_add(struct device *cdev,
 {
 	struct scsi_device *sdev = to_scsi_device(cdev->parent);
 	struct scsi_device *tmp_sdev;
-	unsigned char *buf = NULL, *hdr_buf, *type_ptr;
+	unsigned char *buf = NULL, *hdr_buf, *type_ptr, page;
 	struct ses_device *ses_dev;
 	u32 result;
 	int i, types, len, components = 0;
@@ -631,7 +631,8 @@ static int ses_intf_add(struct device *cdev,
 	if (!hdr_buf || !ses_dev)
 		goto err_init_free;
 
-	result = ses_recv_diag(sdev, 1, hdr_buf, INIT_ALLOC_SIZE);
+	page = 1;
+	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
 		goto recv_failed;
 
@@ -640,7 +641,7 @@ static int ses_intf_add(struct device *cdev,
 	if (!buf)
 		goto err_free;
 
-	result = ses_recv_diag(sdev, 1, buf, len);
+	result = ses_recv_diag(sdev, page, buf, len);
 	if (result)
 		goto recv_failed;
 
@@ -670,7 +671,8 @@ static int ses_intf_add(struct device *cdev,
 	ses_dev->page1_len = len;
 	buf = NULL;
 
-	result = ses_recv_diag(sdev, 2, hdr_buf, INIT_ALLOC_SIZE);
+	page = 2;
+	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
 	if (result)
 		goto recv_failed;
 
@@ -689,7 +691,8 @@ static int ses_intf_add(struct device *cdev,
 
 	/* The additional information page --- allows us
 	 * to match up the devices */
-	result = ses_recv_diag(sdev, 10, hdr_buf, INIT_ALLOC_SIZE);
+	page = 10;
+	result = ses_recv_diag(sdev, page, hdr_buf, INIT_ALLOC_SIZE);
 	if (!result) {
 
 		len = (hdr_buf[2] << 8) + hdr_buf[3] + 4;
@@ -697,7 +700,7 @@ static int ses_intf_add(struct device *cdev,
 		if (!buf)
 			goto err_free;
 
-		result = ses_recv_diag(sdev, 10, buf, len);
+		result = ses_recv_diag(sdev, page, buf, len);
 		if (result)
 			goto recv_failed;
 		ses_dev->page10 = buf;
@@ -735,7 +738,7 @@ static int ses_intf_add(struct device *cdev,
 
  recv_failed:
 	sdev_printk(KERN_ERR, sdev, "Failed to get diagnostic page 0x%x\n",
-		    result);
+		    page);
 	err = -ENODEV;
  err_free:
 	kfree(buf);
-- 
1.8.5.6
