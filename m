From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix sym2_init
Date: Tue, 14 Sep 2004 15:00:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914130049.GA11300@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:385 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269374AbUINNAw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 09:00:52 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: linux-scsi@vger.kernel.org

Use pci_module_init instead of pci_register_driver and handle
initialization failure.


--- 1.49/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-09-13 14:36:39 +02:00
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-09-14 16:33:41 +02:00
@@ -2443,12 +2383,16 @@
 
 static int __init sym2_init(void)
 {
+	int error;
+
 	sym2_transport_template = spi_attach_transport(&sym2_transport_functions);
 	if (!sym2_transport_template)
 		return -ENODEV;
 
-	pci_register_driver(&sym2_driver);
-	return 0;
+	error = pci_module_init(&sym2_driver);
+	if (error)
+		spi_release_transport(sym2_transport_template);
+	return error;
 }
 
 static void __exit sym2_exit(void)
