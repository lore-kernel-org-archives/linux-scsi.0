From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] sr: fix error handling in module_init
Date: Tue, 26 Jun 2007 00:39:33 +0900
Message-ID: <20070625153933.GA14464@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:29028 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbXFYPsc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2007 11:48:32 -0400
Received: by nz-out-0506.google.com with SMTP id n1so1400690nzf
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2007 08:48:30 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>

Sweep registered blkdev when scsi_register_driver has failed.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Index: 2.6-rc/drivers/scsi/sr.c
===================================================================
--- 2.6-rc.orig/drivers/scsi/sr.c
+++ 2.6-rc/drivers/scsi/sr.c
@@ -885,7 +885,11 @@ static int __init init_sr(void)
 	rc = register_blkdev(SCSI_CDROM_MAJOR, "sr");
 	if (rc)
 		return rc;
-	return scsi_register_driver(&sr_template.gendrv);
+	rc = scsi_register_driver(&sr_template.gendrv);
+	if (rc)
+		unregister_blkdev(SCSI_CDROM_MAJOR, "sr");
+
+	return rc;
 }
 
 static void __exit exit_sr(void)
