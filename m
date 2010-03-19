From: Marco Schindler <marco.schindler@gmail.com>
Subject: Intel SASMF8I
Date: Fri, 19 Mar 2010 23:39:58 +0100
Message-ID: <4BA3FD3E.9070801@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010605010907090106030604"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:42237 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079Ab0CSWkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2010 18:40:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010605010907090106030604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,
this card (using LSISAS1068(E)) is not recognized by FUSION_SAS, after
patching the device code it appears to work nicely.

--------------010605010907090106030604
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="fusion.mpt.lsi8208elp.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fusion.mpt.lsi8208elp.patch"

Signed-off-by: Marco Schindler <marco.schindler@gmail.com>
diff -ru --exclude=auto.conf --exclude=autoconf.h --exclude=mptsas.mod.c --exclude='*.o' --exclude='*.ko' linux.old/drivers/message/fusion/lsi/mpi_cnfg.h linux.new/drivers/message/fusion/lsi/mpi_cnfg.h
--- linux.old/drivers/message/fusion/lsi/mpi_cnfg.h	2009-01-27 23:37:45.000000000 +0100
+++ linux.new/drivers/message/fusion/lsi/mpi_cnfg.h	2009-01-27 23:53:07.000000000 +0100
@@ -569,6 +569,7 @@
 #define MPI_MANUFACTPAGE_DEVID_SAS1066E             (0x005A)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068              (0x0054)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068E             (0x0058)
+#define MPI_MANUFACTPAGE_DEVID_SAS1068_820XELP      (0x0059)
 #define MPI_MANUFACTPAGE_DEVID_SAS1078              (0x0062)
 
 
diff -ru --exclude=auto.conf --exclude=autoconf.h --exclude=mptsas.mod.c --exclude='*.o' --exclude='*.ko' linux.old/drivers/message/fusion/mptsas.c linux.new/drivers/message/fusion/mptsas.c
--- linux.old/drivers/message/fusion/mptsas.c	2009-01-27 23:37:45.000000000 +0100
+++ linux.new/drivers/message/fusion/mptsas.c	2009-01-27 23:54:00.000000000 +0100
@@ -3335,6 +3335,8 @@
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1078,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068_820XELP,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptsas_pci_table);

--------------010605010907090106030604--
