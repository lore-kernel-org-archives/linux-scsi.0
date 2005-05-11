From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 3/5] fusion - Adding pci recog support for Fibre 949X and
	939X chips
Date: Wed, 11 May 2005 11:46:52 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C0247DCBC@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C55651.6A8A10A0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49384 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262018AbVEKRrC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 13:47:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@steeleye.com

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C55651.6A8A10A0
Content-Type: text/plain;
	charset="iso-8859-1"

mptfusion patch 3/5:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.02/

Changelog:
* adding pci id support for new Fibre chips, 949X and 939X
* adding errata workaround - disabling PIO access except during fwdlb.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>










------_=_NextPart_000_01C55651.6A8A10A0
Content-Type: application/octet-stream;
	name="fc949x-3.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="fc949x-3.patch"

--- b/drivers/message/fusion/mptfc.c	2005-05-05 10:19:45.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptfc.c	2005-05-10 14:59:11.000000000 =
-0600=0A=
@@ -134,6 +134,10 @@=0A=
 		PCI_ANY_ID, PCI_ANY_ID },=0A=
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC929X,=0A=
 		PCI_ANY_ID, PCI_ANY_ID },=0A=
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC939X,=0A=
+		PCI_ANY_ID, PCI_ANY_ID },=0A=
+	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FC949X,=0A=
+		PCI_ANY_ID, PCI_ANY_ID },=0A=
 	{0}	/* Terminating entry */=0A=
 };=0A=
 MODULE_DEVICE_TABLE(pci, mptfc_pci_table);=0A=
--- b/drivers/message/fusion/mptbase.c	2005-05-10 14:27:13.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.c	2005-05-11 10:51:26.000000000 =
-0600=0A=
@@ -186,6 +186,26 @@=0A=
 #define CHIPREG_PIO_WRITE32(addr,val)	outl(val, (unsigned =
long)addr)=0A=
 #define CHIPREG_PIO_READ32(addr) 	inl((unsigned long)addr)=0A=
 =0A=
+static void=0A=
+pci_disable_io_access(struct pci_dev *pdev)=0A=
+{=0A=
+	u16 command_reg;=0A=
+=0A=
+	pci_read_config_word(pdev, PCI_COMMAND, &command_reg);=0A=
+	command_reg &=3D ~1;=0A=
+	pci_write_config_word(pdev, PCI_COMMAND, command_reg);=0A=
+}=0A=
+=0A=
+static void=0A=
+pci_enable_io_access(struct pci_dev *pdev)=0A=
+{=0A=
+	u16 command_reg;=0A=
+=0A=
+	pci_read_config_word(pdev, PCI_COMMAND, &command_reg);=0A=
+	command_reg |=3D 1;=0A=
+	pci_write_config_word(pdev, PCI_COMMAND, command_reg);=0A=
+}=0A=
+=0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
 /*=0A=
  *	mpt_interrupt - MPT adapter (IOC) specific interrupt handler.=0A=
@@ -1161,6 +1181,16 @@=0A=
 		pcixcmd &=3D 0x8F;=0A=
 		pci_write_config_byte(pdev, 0x6a, pcixcmd);=0A=
 	}=0A=
+	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC939X) {=0A=
+		ioc->prod_name =3D "LSIFC939X";=0A=
+		ioc->bus_type =3D FC;=0A=
+		ioc->errata_flag_1064 =3D 1;=0A=
+	}=0A=
+	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVICEID_FC949X) {=0A=
+		ioc->prod_name =3D "LSIFC949X";=0A=
+		ioc->bus_type =3D FC;=0A=
+		ioc->errata_flag_1064 =3D 1;=0A=
+	}=0A=
 	else if (pdev->device =3D=3D MPI_MANUFACTPAGE_DEVID_53C1030) {=0A=
 		ioc->prod_name =3D "LSI53C1030";=0A=
 		ioc->bus_type =3D SCSI;=0A=
@@ -1179,6 +1209,9 @@=0A=
 		ioc->bus_type =3D SCSI;=0A=
 	}=0A=
 =0A=
+	if (ioc->errata_flag_1064)=0A=
+		pci_disable_io_access(pdev);=0A=
+=0A=
 	sprintf(ioc->name, "ioc%d", ioc->id);=0A=
 =0A=
 	spin_lock_init(&ioc->FreeQlock);=0A=
@@ -2660,7 +2693,7 @@=0A=
 	/* prevent a second downloadboot and memory free with alt_ioc */=0A=
 	if (ioc->alt_ioc && ioc->alt_ioc->cached_fw)=0A=
 		ioc->alt_ioc->cached_fw =3D NULL;=0A=
-	=0A=
+=0A=
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, 0xFF);=0A=
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, =
MPI_WRSEQ_1ST_KEY_VALUE);=0A=
 	CHIPREG_WRITE32(&ioc->chip->WriteSequence, =
MPI_WRSEQ_2ND_KEY_VALUE);=0A=
@@ -2718,6 +2751,9 @@=0A=
 	/* Write the LoadStartAddress to the DiagRw Address Register=0A=
 	 * using Programmed IO=0A=
 	 */=0A=
+	if (ioc->errata_flag_1064)=0A=
+		pci_enable_io_access(ioc->pcidev);=0A=
+=0A=
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, =
pFwHeader->LoadStartAddress);=0A=
 	ddlprintk((MYIOC_s_INFO_FMT "LoadStart addr written 0x%x \n",=0A=
 		ioc->name, pFwHeader->LoadStartAddress));=0A=
@@ -2764,6 +2800,9 @@=0A=
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwAddress, 0x3F000000);=0A=
 	CHIPREG_PIO_WRITE32(&ioc->pio_chip->DiagRwData, diagRwData);=0A=
 =0A=
+	if (ioc->errata_flag_1064)=0A=
+		pci_disable_io_access(ioc->pcidev);=0A=
+=0A=
 	diag0val =3D CHIPREG_READ32(&ioc->chip->Diagnostic);=0A=
 	ddlprintk((MYIOC_s_INFO_FMT "downloadboot diag0val=3D%x, turning off =
PREVENT_IOC_BOOT, DISABLE_ARM\n",=0A=
 		ioc->name, diag0val));=0A=
--- b/drivers/message/fusion/mptbase.h	2005-05-05 10:19:45.000000000 =
-0600=0A=
+++ a/drivers/message/fusion/mptbase.h	2005-05-10 15:09:56.000000000 =
-0600=0A=
@@ -562,6 +562,13 @@=0A=
 	FCPortPage0_t		 fc_port_page0[2];=0A=
 	LANPage0_t		 lan_cnfg_page0;=0A=
 	LANPage1_t		 lan_cnfg_page1;=0A=
+	/*  =0A=
+	 * Description: errata_flag_1064=0A=
+	 * If a PCIX read occurs within 1 or 2 cycles after the chip =
receives=0A=
+	 * a split completion for a read data, an internal address pointer =
incorrectly=0A=
+	 * increments by 32 bytes=0A=
+	 */=0A=
+	int			 errata_flag_1064;	=0A=
 	u8			 FirstWhoInit;=0A=
 	u8			 upload_fw;	/* If set, do a fw upload */=0A=
 	u8			 reload_fw;	/* Force a FW Reload on next reset */=0A=

------_=_NextPart_000_01C55651.6A8A10A0--
