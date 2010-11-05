From: Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 2/3] SCSI:sd:error handling in sd_sync_cache()
Date: Fri, 5 Nov 2010 11:09:17 +0100
Message-ID: <201011051109.17925.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:36800 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828Ab0KEKI5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Nov 2010 06:08:57 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 6EED493F46
	for <linux-scsi@vger.kernel.org>; Fri,  5 Nov 2010 11:08:56 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, hare@suse.de, linux-scsi@vger.kernel.org

>From 2ab03ae46d6dc126a51ee9cd38206fbdc8bf6a34 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Mon, 25 Oct 2010 12:25:26 +0200
Subject: [PATCH 2/3] SCSI:sd:error handling in sd_sync_cache()

The SCSI commands sd_sync_cache() uses may fail.
These errors needs to be evaluated to return correct
error codes. This fixes system suspension while a device
removal is being handled.

Signed-off-by: Oliver NEukum <oneukum@suse.de>
---
 drivers/scsi/sd.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fcba7d2..5ed75bf 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1104,11 +1104,31 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		sd_print_result(sdkp, res);
 		if (driver_byte(res) & DRIVER_SENSE)
 			sd_print_sense_hdr(sdkp, &sshdr);
-	}
 
-	if (res)
-		return -EIO;
-	return 0;
+		/* we need to evaluate the error return  */
+		if ((scsi_sense_valid(&sshdr) &&
+			/* 0x3a is medium not present */
+			sshdr.asc == 0x3a))
+			/* this is no error here */
+			return 0;
+
+		switch (host_byte(res)) {
+		/* ignore errors due to racing a disconnection */
+		case DID_BAD_TARGET:
+		case DID_NO_CONNECT:	
+			return 0;
+		/* signal the upper layer it might try again */
+		case DID_BUS_BUSY:
+		case DID_IMM_RETRY:
+		case DID_REQUEUE:
+		case DID_SOFT_ERROR:
+			return -EBUSY;
+		default:
+			return -EIO;
+		}
+	} else {
+		return 0;
+	}
 }
 
 static void sd_rescan(struct device *dev)
-- 
1.7.1

