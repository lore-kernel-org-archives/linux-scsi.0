From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] osst: Read buffer overflow
Date: Sun, 02 Aug 2009 10:34:13 +0200
Message-ID: <4A754F85.2070709@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:32861 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbZHBIbE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Aug 2009 04:31:04 -0400
Received: by ewy10 with SMTP id 10so2386173ewy.37
        for <linux-scsi@vger.kernel.org>; Sun, 02 Aug 2009 01:31:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

Check whether index is within bounds before testing the element.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index acb8358..ddb3d06 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -5860,7 +5860,8 @@ static int osst_probe(struct device *dev)
 	}
 
 	/* find a free minor number */
-	for (i=0; os_scsi_tapes[i] && i<osst_max_dev; i++);
+	for (i = 0; i < osst_max_dev && os_scsi_tapes[i]; i++)
+		;
 	if(i >= osst_max_dev) panic ("Scsi_devices corrupt (osst)");
 	dev_num = i;
 
