From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 1/6] mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030
Date: Tue, 14 Aug 2007 17:28:27 -0600
Message-ID: <20070814232827.GA24388@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53567 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbXHNXcB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2007 19:32:01 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.11/8.12.11) with ESMTP id l7ENUSTw027401
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 16:30:29 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.46.33])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id l7ENW0SI030002
	for <linux-scsi@vger.kernel.org>; Tue, 14 Aug 2007 16:32:01 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Per request from Matthew Wilcox - using PCI_VENDOR_ATTO.

Add support for ATTO UL4D, they are rebranded 53C1030.
The changes are
1. Adding a new PCI vendor ID in pci table
2. The spi_port_page_2 is in different format than that of LSI generic
spi_port_page_2 and hence mapping code is added.

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/Kconfig a/drivers/message/fusion/Kconfig
--- b/drivers/message/fusion/Kconfig	2007-08-14 15:50:10.000000000 -0600
+++ a/drivers/message/fusion/Kconfig	2007-08-14 15:53:31.000000000 -0600
@@ -20,6 +20,7 @@ config FUSION_SPI
 	  LSI53C1020A
 	  LSI53C1030
 	  LSI53C1035
+	  ATTO UL4D
 
 config FUSION_FC
 	tristate "Fusion MPT ScsiHost drivers for FC"
diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-08-14 15:50:10.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2007-08-14 16:05:02.000000000 -0600
@@ -4888,6 +4888,38 @@ mpt_GetScsiPortSettings(MPT_ADAPTER *ioc
 				/* Nvram data is left with INVALID mark
 				 */
 				rc = 1;
+			} else if (ioc->pcidev->vendor == PCI_VENDOR_ID_ATTO) {
+
+				/* This is an ATTO adapter, read Page2 accordingly
+				*/
+				ATTO_SCSIPortPage2_t *pPP2 = (ATTO_SCSIPortPage2_t  *) pbuf;
+				ATTODeviceInfo_t *pdevice = NULL;
+				u16 ATTOFlags;
+
+				/* Save the Port Page 2 data
+				 * (reformat into a 32bit quantity)
+				 */
+				for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
+				  pdevice = &pPP2->DeviceSettings[ii];
+				  ATTOFlags = le16_to_cpu(pdevice->ATTOFlags);
+				  data = 0;
+
+				  /* Translate ATTO device flags to LSI format
+				   */
+				  if (ATTOFlags & ATTOFLAG_DISC)
+				    data |= (MPI_SCSIPORTPAGE2_DEVICE_DISCONNECT_ENABLE);
+				  if (ATTOFlags & ATTOFLAG_ID_ENB)
+				    data |= (MPI_SCSIPORTPAGE2_DEVICE_ID_SCAN_ENABLE);
+				  if (ATTOFlags & ATTOFLAG_LUN_ENB)
+				    data |= (MPI_SCSIPORTPAGE2_DEVICE_LUN_SCAN_ENABLE);
+				  if (ATTOFlags & ATTOFLAG_TAGGED)
+				    data |= (MPI_SCSIPORTPAGE2_DEVICE_TAG_QUEUE_ENABLE);
+				  if (!(ATTOFlags & ATTOFLAG_WIDE_ENB))
+				    data |= (MPI_SCSIPORTPAGE2_DEVICE_WIDE_DISABLE);
+
+				  data = (data << 16) | (pdevice->Period << 8) | 10;
+				  ioc->spi_data.nvram[ii] = data;
+				}
 			} else {
 				SCSIPortPage2_t *pPP2 = (SCSIPortPage2_t  *) pbuf;
 				MpiDeviceInfo_t	*pdevice = NULL;
diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-08-14 15:50:10.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2007-08-14 15:53:31.000000000 -0600
@@ -194,6 +194,35 @@
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
+ *  ATTO UL4D associated structures and defines
+ */
+#define ATTOFLAG_DISC     0x0001
+#define ATTOFLAG_TAGGED   0x0002
+#define ATTOFLAG_WIDE_ENB 0x0008
+#define ATTOFLAG_ID_ENB   0x0010
+#define ATTOFLAG_LUN_ENB  0x0060
+
+typedef struct _ATTO_DEVICE_INFO
+{
+	u8	Offset;					/* 00h */
+	u8	Period;					/* 01h */
+	u16	ATTOFlags;				/* 02h */
+} ATTO_DEVICE_INFO, MPI_POINTER PTR_ATTO_DEVICE_INFO,
+  ATTODeviceInfo_t, MPI_POINTER pATTODeviceInfo_t;
+
+typedef struct _ATTO_CONFIG_PAGE_SCSI_PORT_2
+{
+	CONFIG_PAGE_HEADER	Header;			/* 00h */
+	u16			PortFlags;		/* 04h */
+	u16			Unused1;		/* 06h */
+	u32			Unused2;		/* 08h */
+	ATTO_DEVICE_INFO	DeviceSettings[16];	/* 0Ch */
+} fATTO_CONFIG_PAGE_SCSI_PORT_2, MPI_POINTER PTR_ATTO_CONFIG_PAGE_SCSI_PORT_2,
+  ATTO_SCSIPortPage2_t, MPI_POINTER pATTO_SCSIPortPage2_t;
+
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
  *  MPT protocol driver defs...
  */
 typedef enum {
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-08-14 15:50:10.000000000 -0600
+++ a/drivers/message/fusion/mptspi.c	2007-08-14 16:02:35.000000000 -0600
@@ -1190,6 +1190,8 @@ static struct spi_function_template mpts
 static struct pci_device_id mptspi_pci_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1030,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_ATTO, MPI_MANUFACTPAGE_DEVID_53C1030,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1035,
 		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
