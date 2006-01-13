From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH] fusion - adding support for FC949ES
Date: Fri, 13 Jan 2006 16:25:26 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AA7EB@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13494 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1423103AbWAMXZb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 18:25:31 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de, James.Bottomley@steeleye.com

Add software recognition for the new LSI Logic Fibre Channel controller.

It relies on patch I posted yesterday:
http://marc.theaimsgroup.com/?l=linux-kernel&m=113710143305078&w=2

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

diff -uarN b/drivers/message/fusion/mptbase.c
a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-01-13 13:51:07.000000000
-0700
+++ a/drivers/message/fusion/mptbase.c	2006-01-13 15:42:07.000000000
-0700
@@ -1378,6 +1378,10 @@
 		ioc->bus_type = FC;
 		ioc->errata_flag_1064 = 1;
 	}
+	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC949E) {
+		ioc->prod_name = "LSIFC949E";
+		ioc->bus_type = FC;
+	}
 	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_53C1030) {
 		ioc->prod_name = "LSI53C1030";
 		ioc->bus_type = SPI;
diff -uarN b/drivers/message/fusion/mptfc.c
a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2006-01-13 13:51:07.000000000
-0700
+++ a/drivers/message/fusion/mptfc.c	2006-01-13 15:43:03.000000000
-0700
@@ -145,6 +145,8 @@
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC949X,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC949ES,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptfc_pci_table);
