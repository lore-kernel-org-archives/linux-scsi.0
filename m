From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] zfcp: Test kmalloc failure in scsi_get_vpd_page()
Date: Mon, 24 Aug 2009 18:21:44 +0200
Message-ID: <4A92BE18.50208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61724 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZHXQQp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Aug 2009 12:16:45 -0400
Received: by ewy3 with SMTP id 3so2540366ewy.18
        for <linux-scsi@vger.kernel.org>; Mon, 24 Aug 2009 09:16:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

kmalloc() may fail, so test whether it succeeded.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2de5f3a..34fdde0 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1056,6 +1056,9 @@ unsigned char *scsi_get_vpd_page(struct scsi_device *sdev, u8 page)
 
 	kfree(buf);
 	buf = kmalloc(len + 4, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
 	result = scsi_vpd_inquiry(sdev, buf, page, len);
 	if (result)
 		goto fail;
