From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix dc395x compile
Date: Fri, 8 Aug 2003 21:07:06 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030808190706.GA17983@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:46722 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S271824AbTHHTHO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2003 15:07:14 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
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
