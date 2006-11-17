From: Sven Rudolph <Sven_Rudolph@drewag.de>
Subject: Atto UL5D: negotiates only up to FAST-40 SCSI
Date: Fri, 17 Nov 2006 12:21:32 +0100
Message-ID: <xfku00y8gjn.fsf@uxrs53.drewag.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from miranda.drewag.de ([212.111.238.29]:36333 "EHLO
	miranda.drewag.de") by vger.kernel.org with ESMTP id S1755036AbWKQLVP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 06:21:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I try to use an Atto Dual-Channel Low-Profile PCIExpress SCSI HBA
(<http://www.attotech.com/ultra5Dlowpro.html>) with Linux (2.6.18.1,
2.6.19rc6).

(Atto provides a Linux driver on CD, but I prefer to use drivers
included in the vanilla Linux kernel. It looks like their driver does
not include all source code; but I might be wrong on this.)

According to lspci the card seems to include a vanilla Symbios Logic
1030 Chip (with an ATTO Vendor ID) and an Intel PCI-to-PCIExpress
bridge:


  09:00.0 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel PCI Bridge (A-Segment Bridge) (rev 09)
  09:00.2 PCI bridge: Intel Corporation 41210 [Lanai] Serial to Parallel PCI Bridge (B-Segment Bridge) (rev 09)
  0a:04.0 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)
  0a:04.1 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter (rev 08)

  09:00.0 0604: 8086:0340 (rev 09)
  09:00.2 0604: 8086:0341 (rev 09)
  0a:04.0 0100: 117c:0030 (rev 08)
  0a:04.1 0100: 117c:0030 (rev 08)


I added the new vendor ID to the fusion driver; with this kernel I can
access a hard disk attached to that controller:

diff -uprN linux-2.6.18.1-common/drivers/message/fusion/mptspi.c linux-2.6.18.1-atto/drivers/message/fusion/mptspi.c
--- linux-2.6.18.1-common/drivers/message/fusion/mptspi.c	2006-11-15 14:08:39.000000000 +0100
+++ linux-2.6.18.1-atto/drivers/message/fusion/mptspi.c	2006-11-15 14:09:17.000000000 +0100
@@ -775,6 +775,8 @@ static struct pci_device_id mptspi_pci_t
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1035,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_ATTO, MPI_MANUFACTPAGE_DEVID_53C1030,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptspi_pci_table);
diff -uprN linux-2.6.18.1-common/include/linux/pci_ids.h linux-2.6.18.1-atto/include/linux/pci_ids.h
--- linux-2.6.18.1-common/include/linux/pci_ids.h	2006-10-14 05:34:03.000000000 +0200
+++ linux-2.6.18.1-atto/include/linux/pci_ids.h	2006-11-15 14:11:26.000000000 +0100
@@ -1440,6 +1440,8 @@
 #define PCI_DEVICE_ID_TOSHIBA_TC86C001_MISC	0x0108
 #define PCI_DEVICE_ID_TOSHIBA_SPIDER_NET 0x01b3
 
+#define PCI_VENDOR_ID_ATTO		0x117c
+
 #define PCI_VENDOR_ID_RICOH		0x1180
 #define PCI_DEVICE_ID_RICOH_RL5C465	0x0465
 #define PCI_DEVICE_ID_RICOH_RL5C466	0x0466


I tested this with Linux 2.6.19-rc6 too and it works.

Only remaining problem is that it does not negotiate transfer speeds
beyond FAST-40 (and does not negotiate WIDE transfers):


  Fusion MPT base driver 3.04.02
  Copyright (c) 1999-2005 LSI Logic Corporation
  Fusion MPT SPI Host driver 3.04.02
  ACPI: PCI Interrupt 0000:0a:04.0[A] -> GSI 16 (level, low) -> IRQ 16
  mptbase: Initiating ioc0 bringup
  ioc0: 53C1030: Capabilities={Initiator,Target}
  scsi1 : ioc0: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=16
  scsi 1:0:3:0: Direct-Access     SEAGATE  ST3300007LC      7806 PQ: 0 ANSI: 3
   target1:0:3: Beginning Domain Validation
   target1:0:3: Domain Validation skipping write tests
   target1:0:3: Ending Domain Validation
   target1:0:3: FAST-40 SCSI 40.0 MB/s ST (25 ns, offset 63)
  SCSI device sdl: 585937500 512-byte hdwr sectors (300000 MB)
  sdl: Write Protect is off
  sdl: Mode Sense: ab 00 10 08
  SCSI device sdl: drive cache: write through w/ FUA
  SCSI device sdl: 585937500 512-byte hdwr sectors (300000 MB)
  sdl: Write Protect is off
  sdl: Mode Sense: ab 00 10 08
  SCSI device sdl: drive cache: write through w/ FUA
   sdl: unknown partition table
  sd 1:0:3:0: Attached scsi disk sdl
  scsi 1:0:8:0: Processor         QLogic   GEM359           1.10 PQ: 0 ANSI: 2
   target1:0:8: Beginning Domain Validation
   target1:0:8: Ending Domain Validation
   target1:0:8: asynchronous


I have no idea what causes this problem. Any suggestions where and how
I should look for more info?

	Sven

