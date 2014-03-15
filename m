From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] scsi: Return VPD page length in scsi_vpd_inquiry()
Date: Sat, 15 Mar 2014 09:51:48 +0100
Message-ID: <1394873512-102073-3-git-send-email-hare@suse.de>
References: <1394873512-102073-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753167AbaCOIvz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2014 04:51:55 -0400
In-Reply-To: <1394873512-102073-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

We should be returning the number of bytes of the
requested VPD page in scsi_vpd_inquiry.
This makes it easier for the caller to verify the
required space.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index d8afec8..9e08d3d 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -954,7 +954,7 @@ EXPORT_SYMBOL(scsi_track_queue_full);
  * This is an internal helper function.  You probably want to use
  * scsi_get_vpd_page instead.
  *
- * Returns 0 on success or a negative error number.
+ * Returns size of the vpd page on success or a negative error number.
  */
 static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 							u8 page, unsigned len)
@@ -962,6 +962,9 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	int result;
 	unsigned char cmd[16];
 
+	if (len < 4)
+		return -EINVAL;
+
 	cmd[0] = INQUIRY;
 	cmd[1] = 1;		/* EVPD */
 	cmd[2] = page;
@@ -982,7 +985,7 @@ static int scsi_vpd_inquiry(struct scsi_device *sdev, unsigned char *buffer,
 	if (buffer[1] != page)
 		return -EIO;
 
-	return 0;
+	return get_unaligned_be16(&buffer[2]) + 4;
 }
 
 /**
@@ -1009,18 +1012,18 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 
 	/* Ask for all the pages supported by this device */
 	result = scsi_vpd_inquiry(sdev, buf, 0, buf_len);
-	if (result)
+	if (result < 4)
 		goto fail;
 
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
 		return 0;
 
-	for (i = 0; i < min((int)buf[3], buf_len - 4); i++)
-		if (buf[i + 4] == page)
+	for (i = 4; i < min(result, buf_len); i++)
+		if (buf[i] == page)
 			goto found;
 
-	if (i < buf[3] && i >= buf_len - 4)
+	if (i < result && i >= buf_len)
 		/* ran off the end of the buffer, give us benefit of doubt */
 		goto found;
 	/* The device claims it doesn't support the requested page */
@@ -1028,7 +1031,7 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 
  found:
 	result = scsi_vpd_inquiry(sdev, buf, page, buf_len);
-	if (result)
+	if (result < 0)
 		goto fail;
 
 	return 0;
-- 
1.7.12.4

