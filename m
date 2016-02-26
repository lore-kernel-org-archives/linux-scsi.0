From: tom.ty89@gmail.com
Subject: [PATCH 2/2] sd: disable write same for SAT as per the comment
Date: Sat, 27 Feb 2016 04:07:30 +0800
Message-ID: <56d0b08c.e99c420a.dbca1.0415@mx.google.com>
References: <1456517250-2713-1-git-send-email-me>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35851 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbcBZUHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2016 15:07:41 -0500
Received: by mail-pf0-f196.google.com with SMTP id e127so5166403pfe.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 Feb 2016 12:07:41 -0800 (PST)
In-Reply-To: <1456517250-2713-1-git-send-email-me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tom Yan <tom.ty89@gmail.com>

From: Tom Yan <tom.ty89@gmail.com>

Signed-off-by: Tom Yan <tom.ty89@gmail.com>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1179ec1..9eeee51 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2786,7 +2786,7 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		 * CODES is unsupported and the device has an ATA
 		 * Information VPD page (SAT).
 		 */
-		if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
+		if (scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
 			sdev->no_write_same = 1;
 	}
 
-- 
2.7.1

