From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x - fix compile
Date: Sun, 17 Aug 2003 13:51:59 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030817035159.GA13666@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:36278 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S275010AbTHQDvz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Aug 2003 23:51:55 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@steeleye.com>, dc395x@twibble.org

Hi,

this patch is good and needs to be applied to get the dc395x driver
in the current tree (2.6.0-test3-bk3) to build (it's not yet included
in the scsi-misc tree).

Thanks.

----- Forwarded message from Christoph Hellwig <hch@lst.de> -----
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix dc395x compile
Date: Fri, 8 Aug 2003 21:07:06 +0200
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

The recent update made it check the scsi_remove_host retval which
is void now.

diff -Nru a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	Fri Aug  8 11:11:11 2003
+++ b/drivers/scsi/dc395x.c	Fri Aug  8 11:11:11 2003
@@ -5862,14 +5862,7 @@
 	struct Scsi_Host *host = pci_get_drvdata(dev);
 
 	dprintkdbg(DBG_0, "Removing instance\n");
-	if (!host) {
-		dprintkl(KERN_ERR, "no host allocated\n");
-		return;
-	}
-	if (scsi_remove_host(host)) {
-		dprintkl(KERN_ERR, "scsi_remove_host failed\n");
-		return;
-	}
+	scsi_remove_host(host);
 	host_release(host);
 	scsi_host_put(host);
 	pci_set_drvdata(dev, NULL);

----- End forwarded message -----

-- 
 Jamie Lenehan <lenehan@twibble.org>
