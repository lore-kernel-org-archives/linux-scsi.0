From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] pmcraid: redundant check in pmcraid_check_ioctl_buffer()?
Date: Wed, 21 Oct 2009 16:41:14 +0200
Message-ID: <4ADF1D8A.1030906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:50341 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZJUObJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2009 10:31:09 -0400
Received: by ewy3 with SMTP id 3so6104728ewy.17
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 07:31:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil_ravindranath@pmc-sierra.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

struct pmcraid_ioctl_header member buffer_length is unsigned, so
this check appears redundant.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Or should we replace it by a check like
if (hdr->buffer_length > MAX) ... ?

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index f7c70e2..e448776 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3731,12 +3731,6 @@ static int pmcraid_check_ioctl_buffer(
 		return -EINVAL;
 	}
 
-	/* buffer length can't be negetive */
-	if (hdr->buffer_length < 0) {
-		pmcraid_err("ioctl: invalid buffer length specified\n");
-		return -EINVAL;
-	}
-
 	/* check for appropriate buffer access */
 	if ((_IOC_DIR(cmd) & _IOC_READ) == _IOC_READ)
 		access = VERIFY_WRITE;
