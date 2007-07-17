From: "Prakash, Sathya" <sathya.prakash@lsi.com>
Subject: Re: [PATCH] mpt fusion: add support for Brocade branded LSI FC HBA
Date: Tue, 17 Jul 2007 14:18:41 +0530
Message-ID: <20070717084840.GA8143@lsil.com>
References: <20070713092918.GB5564@lsil.com> <664A4EBB07F29743873A87CF62C26D7085119B@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61010 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758834AbXGQIuv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 04:50:51 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7085119B@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi@vger.kernel.org, "Hickerson, Roger" <Roger.Hickerson@lsi.com>, ggrignou@brocade.com

Resubmitting with Eric Moore suggested modifications:
---
Add support for Brocade 410/420 4Gbit FC HBAs. 
They are re-branded LSI HBAs [LSI7104EP-LC/LSI7204EP-LC]

This patch should be applied over the following patches:
1. mpt fusion: deregister from transport layer if PCI registration failed 
2. mpt fusion: add sysfs attributes to display IOC parameters 
3. add PCI_VENDOR_ID macro for Brocade in pci_ids.h

signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
---

diff -Naurp b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2007-07-13 12:11:12.000000000 +0530
+++ a/drivers/message/fusion/mptbase.c	2007-07-17 14:11:52.000000000 +0530
@@ -1132,6 +1132,248 @@ mpt_verify_adapter(int iocid, MPT_ADAPTE
 	return -1;
 }
 
+/**
+ *	mpt_get_product_name - returns product string
+ *	@vendor: pci vendor id
+ *	@device: pci device id
+ *	@revision: pci revision id
+ *	@prod_name: string returned
+ *
+ *	Returns product string displayed when driver loads,
+ *	in /proc/mpt/summary and /sysfs/class/scsi_host/host<X>/version_product
+ *
+ **/
+static void
+mpt_get_product_name(u16 vendor, u16 device, u8 revision, char *prod_name)
+{
+	char *product_str = NULL;
+
+	if (vendor == PCI_VENDOR_ID_BROCADE) {
+		switch (device)
+		{
+		case MPI_MANUFACTPAGE_DEVICEID_FC949E:
+			switch (revision)
+			{
+			case 0x00:
+				product_str = "BRE040 A0";
+				break;
+			case 0x01:
+				product_str = "BRE040 A1";
+				break;
+			default:
+				product_str = "BRE040";
+				break;
+			}
+			break;
+		}
+		goto out;
+	}
+
+	switch (device)
+	{
+	case MPI_MANUFACTPAGE_DEVICEID_FC909:
+		product_str = "LSIFC909 B1";
+		break;
+	case MPI_MANUFACTPAGE_DEVICEID_FC919:
+		product_str = "LSIFC919 B0";
+		break;
+	case MPI_MANUFACTPAGE_DEVICEID_FC929:
+		product_str = "LSIFC929 B0";
+		break;
+	case MPI_MANUFACTPAGE_DEVICEID_FC919X:
+		if (revision < 0x80)
+			product_str = "LSIFC919X A0";
+		else
+			product_str = "LSIFC919XL A1";
+		break;
+	case MPI_MANUFACTPAGE_DEVICEID_FC929X:
+		if (revision < 0x80)
+			product_str = "LSIFC929X A0";
+		else
+			product_str = "LSIFC929XL A1";
+		break;
+	case MPI_MANUFACTPAGE_DEVICEID_FC939X:
+		product_str = "LSIFC939X A1";
+		break;
+	case MPI_MANUFACTPAGE_DEVICEID_FC949X:
+		product_str = "LSIFC949X A1";
+		break;
+	case MPI_MANUFACTPAGE_DEVICEID_FC949E:
+		switch (revision)
+		{
+		case 0x00:
+			product_str = "LSIFC949E A0";
+			break;
+		case 0x01:
+			product_str = "LSIFC949E A1";
+			break;
+		default:
+			product_str = "LSIFC949E";
+			break;
+		}
+		break;
+	case MPI_MANUFACTPAGE_DEVID_53C1030:
+		switch (revision)
+		{
+		case 0x00:
+			product_str = "LSI53C1030 A0";
+			break;
+		case 0x01:
+			product_str = "LSI53C1030 B0";
+			break;
+		case 0x03:
+			product_str = "LSI53C1030 B1";
+			break;
+		case 0x07:
+			product_str = "LSI53C1030 B2";
+			break;
+		case 0x08:
+			product_str = "LSI53C1030 C0";
+			break;
+		case 0x80:
+			product_str = "LSI53C1030T A0";
+			break;
+		case 0x83:
+			product_str = "LSI53C1030T A2";
+			break;
+		case 0x87:
+			product_str = "LSI53C1030T A3";
+			break;
+		case 0xc1:
+			product_str = "LSI53C1020A A1";
+			break;
+		default:
+			product_str = "LSI53C1030";
+			break;
+		}
+		break;
+	case MPI_MANUFACTPAGE_DEVID_1030_53C1035:
+		switch (revision)
+		{
+		case 0x03:
+			product_str = "LSI53C1035 A2";
+			break;
+		case 0x04:
+			product_str = "LSI53C1035 B0";
+			break;
+		default:
+			product_str = "LSI53C1035";
+			break;
+		}
+		break;
+	case MPI_MANUFACTPAGE_DEVID_SAS1064:
+		switch (revision)
+		{
+		case 0x00:
+			product_str = "LSISAS1064 A1";
+			break;
+		case 0x01:
+			product_str = "LSISAS1064 A2";
+			break;
+		case 0x02:
+			product_str = "LSISAS1064 A3";
+			break;
+		case 0x03:
+			product_str = "LSISAS1064 A4";
+			break;
+		default:
+			product_str = "LSISAS1064";
+			break;
+		}
+		break;
+	case MPI_MANUFACTPAGE_DEVID_SAS1064E:
+		switch (revision)
+		{
+		case 0x00:
+			product_str = "LSISAS1064E A0";
+			break;
+		case 0x01:
+			product_str = "LSISAS1064E B0";
+			break;
+		case 0x02:
+			product_str = "LSISAS1064E B1";
+			break;
+		case 0x04:
+			product_str = "LSISAS1064E B2";
+			break;
+		case 0x08:
+			product_str = "LSISAS1064E B3";
+			break;
+		default:
+			product_str = "LSISAS1064E";
+			break;
+		}
+		break;
+	case MPI_MANUFACTPAGE_DEVID_SAS1068:
+		switch (revision)
+		{
+		case 0x00:
+			product_str = "LSISAS1068 A0";
+			break;
+		case 0x01:
+			product_str = "LSISAS1068 B0";
+			break;
+		case 0x02:
+			product_str = "LSISAS1068 B1";
+			break;
+		default:
+			product_str = "LSISAS1068";
+			break;
+		}
+		break;
+	case MPI_MANUFACTPAGE_DEVID_SAS1068E:
+		switch (revision)
+		{
+		case 0x00:
+			product_str = "LSISAS1068E A0";
+			break;
+		case 0x01:
+			product_str = "LSISAS1068E B0";
+			break;
+		case 0x02:
+			product_str = "LSISAS1068E B1";
+			break;
+		case 0x04:
+			product_str = "LSISAS1068E B2";
+			break;
+		case 0x08:
+			product_str = "LSISAS1068E B3";
+			break;
+		default:
+			product_str = "LSISAS1068E";
+			break;
+		}
+		break;
+	case MPI_MANUFACTPAGE_DEVID_SAS1078:
+		switch (revision)
+		{
+		case 0x00:
+			product_str = "LSISAS1078 A0";
+			break;
+		case 0x01:
+			product_str = "LSISAS1078 B0";
+			break;
+		case 0x02:
+			product_str = "LSISAS1078 C0";
+			break;
+		case 0x03:
+			product_str = "LSISAS1078 C1";
+			break;
+		case 0x04:
+			product_str = "LSISAS1078 C2";
+			break;
+		default:
+			product_str = "LSISAS1078";
+			break;
+		}
+		break;
+	}
+
+ out:
+	if (product_str)
+		sprintf(prod_name, "%s", product_str);
+}
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mpt_attach - Install a PCI intelligent MPT adapter.
@@ -1275,23 +1517,23 @@ mpt_attach(struct pci_dev *pdev, const s
 		ioc->pio_chip = (SYSIF_REGS __iomem *)pmem;
 	}
 
-	if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC909) {
-		ioc->prod_name = "LSIFC909";
-		ioc->bus_type = FC;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC929) {
-		ioc->prod_name = "LSIFC929";
-		ioc->bus_type = FC;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC919) {
-		ioc->prod_name = "LSIFC919";
-		ioc->bus_type = FC;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC929X) {
-		pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
+	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
+	mpt_get_product_name(pdev->vendor, pdev->device, revision, ioc->prod_name);
+
+	switch (pdev->device)
+	{
+	case MPI_MANUFACTPAGE_DEVICEID_FC939X:
+	case MPI_MANUFACTPAGE_DEVICEID_FC949X:
+		ioc->errata_flag_1064 = 1;
+	case MPI_MANUFACTPAGE_DEVICEID_FC909:
+	case MPI_MANUFACTPAGE_DEVICEID_FC929:
+	case MPI_MANUFACTPAGE_DEVICEID_FC919:
+	case MPI_MANUFACTPAGE_DEVICEID_FC949E:
 		ioc->bus_type = FC;
+		break;
+
+	case MPI_MANUFACTPAGE_DEVICEID_FC929X:
 		if (revision < XL_929) {
-			ioc->prod_name = "LSIFC929X";
 			/* 929X Chip Fix. Set Split transactions level
 		 	* for PCIX. Set MOST bits to zero.
 		 	*/
@@ -1299,75 +1541,46 @@ mpt_attach(struct pci_dev *pdev, const s
 			pcixcmd &= 0x8F;
 			pci_write_config_byte(pdev, 0x6a, pcixcmd);
 		} else {
-			ioc->prod_name = "LSIFC929XL";
 			/* 929XL Chip Fix. Set MMRBC to 0x08.
 		 	*/
 			pci_read_config_byte(pdev, 0x6a, &pcixcmd);
 			pcixcmd |= 0x08;
 			pci_write_config_byte(pdev, 0x6a, pcixcmd);
 		}
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC919X) {
-		ioc->prod_name = "LSIFC919X";
 		ioc->bus_type = FC;
+		break;
+
+	case MPI_MANUFACTPAGE_DEVICEID_FC919X:
 		/* 919X Chip Fix. Set Split transactions level
 		 * for PCIX. Set MOST bits to zero.
 		 */
 		pci_read_config_byte(pdev, 0x6a, &pcixcmd);
 		pcixcmd &= 0x8F;
 		pci_write_config_byte(pdev, 0x6a, pcixcmd);
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC939X) {
-		ioc->prod_name = "LSIFC939X";
-		ioc->bus_type = FC;
-		ioc->errata_flag_1064 = 1;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC949X) {
-		ioc->prod_name = "LSIFC949X";
 		ioc->bus_type = FC;
-		ioc->errata_flag_1064 = 1;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVICEID_FC949E) {
-		ioc->prod_name = "LSIFC949E";
-		ioc->bus_type = FC;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_53C1030) {
-		ioc->prod_name = "LSI53C1030";
-		ioc->bus_type = SPI;
+		break;
+
+	case MPI_MANUFACTPAGE_DEVID_53C1030:
 		/* 1030 Chip Fix. Disable Split transactions
 		 * for PCIX. Set MOST bits to zero if Rev < C0( = 8).
 		 */
-		pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
 		if (revision < C0_1030) {
 			pci_read_config_byte(pdev, 0x6a, &pcixcmd);
 			pcixcmd &= 0x8F;
 			pci_write_config_byte(pdev, 0x6a, pcixcmd);
 		}
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_1030_53C1035) {
-		ioc->prod_name = "LSI53C1035";
+
+	case MPI_MANUFACTPAGE_DEVID_1030_53C1035:
 		ioc->bus_type = SPI;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1064) {
-		ioc->prod_name = "LSISAS1064";
-		ioc->bus_type = SAS;
-		ioc->errata_flag_1064 = 1;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1068) {
-		ioc->prod_name = "LSISAS1068";
-		ioc->bus_type = SAS;
+		break;
+
+	case MPI_MANUFACTPAGE_DEVID_SAS1064:
+	case MPI_MANUFACTPAGE_DEVID_SAS1068:
 		ioc->errata_flag_1064 = 1;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1064E) {
-		ioc->prod_name = "LSISAS1064E";
-		ioc->bus_type = SAS;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1068E) {
-		ioc->prod_name = "LSISAS1068E";
-		ioc->bus_type = SAS;
-	}
-	else if (pdev->device == MPI_MANUFACTPAGE_DEVID_SAS1078) {
-		ioc->prod_name = "LSISAS1078";
+
+	case MPI_MANUFACTPAGE_DEVID_SAS1064E:
+	case MPI_MANUFACTPAGE_DEVID_SAS1068E:
+	case MPI_MANUFACTPAGE_DEVID_SAS1078:
 		ioc->bus_type = SAS;
 	}
 
@@ -2140,8 +2353,8 @@ MptDisplayIocCapabilities(MPT_ADAPTER *i
 	int i = 0;
 
 	printk(KERN_INFO "%s: ", ioc->name);
-	if (ioc->prod_name && strlen(ioc->prod_name) > 3)
-		printk("%s: ", ioc->prod_name+3);
+	if (ioc->prod_name)
+		printk("%s: ", ioc->prod_name);
 	printk("Capabilities={");
 
 	if (ioc->pfacts[0].ProtocolFlags & MPI_PORTFACTS_PROTOCOL_INITIATOR) {
diff -Naurp b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-07-13 12:11:12.000000000 +0530
+++ a/drivers/message/fusion/mptbase.h	2007-07-13 12:17:33.000000000 +0530
@@ -537,7 +537,7 @@ typedef struct _MPT_ADAPTER
 	int			 id;		/* Unique adapter id N {0,1,2,...} */
 	int			 pci_irq;	/* This irq           */
 	char			 name[MPT_NAME_LENGTH];	/* "iocN"             */
-	char			*prod_name;	/* "LSIFC9x9"         */
+	char			 prod_name[MPT_NAME_LENGTH];	/* "LSIFC9x9"         */
 	char			 board_name[16];
 	char			 board_assembly[16];
 	char			 board_tracer[16];
diff -Naurp b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2007-07-13 12:11:15.000000000 +0530
+++ a/drivers/message/fusion/mptfc.c	2007-07-13 12:17:33.000000000 +0530
@@ -154,6 +154,8 @@ static struct pci_device_id mptfc_pci_ta
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVICEID_FC949E,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_BROCADE, MPI_MANUFACTPAGE_DEVICEID_FC949E,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptfc_pci_table);
