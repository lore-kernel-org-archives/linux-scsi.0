From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: [PATCH] mpt fusion: deregister from transport layer if PCI registration failed
Date: Mon, 2 Jul 2007 17:04:10 +0530
Message-ID: <20070702113409.GB9231@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:45763 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbXGBLfi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jul 2007 07:35:38 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l62BYTE2023898
	for <linux-scsi@vger.kernel.org>; Mon, 2 Jul 2007 04:34:29 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: eric.moore@lsi.com

The mptspi and mptsas drivers are modified to deregister from transport layer
if registration with PCI driver failed

Signed-Off-by: Sathya Prakash <sathya.prakash@lsi.com>

----------------

diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptsas.c	2007-07-02 16:22:23.000000000 +0530
@@ -3237,6 +3237,8 @@ static struct pci_driver mptsas_driver =
 static int __init
 mptsas_init(void)
 {
+	int error;
+
 	show_mptmod_ver(my_NAME, my_VERSION);
 
 	mptsas_transport_template =
@@ -3259,8 +3261,12 @@ mptsas_init(void)
 		dprintk((KERN_INFO MYNAM
 		  ": Registered for IOC reset notifications\n"));
 	}
+	
+	error = pci_register_driver(&mptsas_driver);
+	if (error)
+		sas_release_transport(mptsas_transport_template);
 
-	return pci_register_driver(&mptsas_driver);
+	return error;
 }
 
 static void __exit
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-07-02 16:20:46.000000000 +0530
+++ a/drivers/message/fusion/mptspi.c	2007-07-02 16:22:23.000000000 +0530
@@ -1521,6 +1521,8 @@ static struct pci_driver mptspi_driver =
 static int __init
 mptspi_init(void)
 {
+	int error;
+
 	show_mptmod_ver(my_NAME, my_VERSION);
 
 	mptspi_transport_template = spi_attach_transport(&mptspi_transport_functions);
@@ -1541,7 +1543,11 @@ mptspi_init(void)
 		  ": Registered for IOC reset notifications\n"));
 	}
 
-	return pci_register_driver(&mptspi_driver);
+	error = pci_register_driver(&mptspi_driver);
+	if (error)
+		spi_release_transport(mptspi_transport_template);
+
+	return error;
 }
 
