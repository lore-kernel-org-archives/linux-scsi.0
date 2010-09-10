From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Fix VPD page wrapper
Date: Fri, 10 Sep 2010 01:20:27 -0400
Message-ID: <yq14odyrx7o.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:19187 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0IJFWC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 01:22:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org


Fix two bugs in the VPD page wrapper:

    - Don't return failure if the user asked for page 0

    - The end of buffer check failed to account for the page header size
      and consequently didn't work

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ad0ed21..348fba0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1046,13 +1046,13 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 
 	/* If the user actually wanted this page, we can skip the rest */
 	if (page == 0)
-		return -EINVAL;
+		return 0;
 
 	for (i = 0; i < min((int)buf[3], buf_len - 4); i++)
 		if (buf[i + 4] == page)
 			goto found;
 
-	if (i < buf[3] && i > buf_len)
+	if (i < buf[3] && i >= buf_len - 4)
 		/* ran off the end of the buffer, give us benefit of doubt */
 		goto found;
 	/* The device claims it doesn't support the requested page */
