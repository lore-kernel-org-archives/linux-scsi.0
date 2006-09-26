From: Eric Sesterhenn <snakebyte@gmx.de>
Subject: [Patch] Overrun in drivers/scsi/scsi.c
Date: Tue, 26 Sep 2006 13:22:13 +0200
Message-ID: <1159269733.5935.1.camel@alice>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:11166 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751113AbWIZLWR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Sep 2006 07:22:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

hi,

this overrun was spotted by coverity (cid #1403).

If type == ARRAY_SIZE(scsi_device_types), we are off by one.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>

--- linux-2.6.18-git5/drivers/scsi/scsi.c.orig	2006-09-26 13:18:52.000000000 +0200
+++ linux-2.6.18-git5/drivers/scsi/scsi.c	2006-09-26 13:19:13.000000000 +0200
@@ -128,7 +128,7 @@ const char * scsi_device_type(unsigned t
 		return "Well-known LUN   ";
 	if (type == 0x1f)
 		return "No Device        ";
-	if (type > ARRAY_SIZE(scsi_device_types))
+	if (type >= ARRAY_SIZE(scsi_device_types))
 		return "Unknown          ";
 	return scsi_device_types[type];
 }


