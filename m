From: Pavel Roskin <proski@gnu.org>
Subject: libata - success with 82801AA IDE
Date: Wed, 29 Oct 2003 16:37:57 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0310291626210.29421@marabou.research.att.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:20372 "EHLO
	fencepost.gnu.org") by vger.kernel.org with ESMTP id S261626AbTJ2Vh6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 16:37:58 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>

Hello!

I just want to report that Intel 82801AA IDE controller (8086:2411) is
working with libata from 2.6.0-test9-bk3.  I applied following patch:

------------------------
--- linux.orig/drivers/scsi/ata_piix.c
+++ linux/drivers/scsi/ata_piix.c
@@ -29,6 +29,7 @@

 #define DRV_NAME	"ata_piix"
 #define DRV_VERSION	"0.95"
+#define ATA_ENABLE_PATA 1

 enum {
 	PIIX_IOCFG		= 0x54, /* IDE I/O configuration register */
@@ -63,6 +64,7 @@ static unsigned int in_module_init = 1;
 static struct pci_device_id piix_pci_tbl[] = {
 #ifdef ATA_ENABLE_PATA
 	{ 0x8086, 0x7111, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix4_pata },
+	{ 0x8086, 0x2411, PCI_ANY_ID, PCI_ANY_ID, 0, 0, piix4_pata },
 	{ 0x8086, 0x24db, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich5_pata },
 	{ 0x8086, 0x25a2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich5_pata },
 #endif
------------------------

Relevant portion of the kernel log:

------------------------
libata version 0.75 loaded.
ata_piix version 0.95
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata1: PATA max UDMA/33 cmd 0x1F0 ctl 0x3F6 bmdma 0xF000 irq 14
ata1: dev 0 cfg 49:2f00 82:346b 83:4301 84:4000 85:3468 86:0001 87:4000
88:103f
ata1: dev 0 ATA, max UDMA/100, 39102336 sectors
ata1: dev 0 configured for UDMA/33
scsi0 : ata_piix
  Vendor: ATA       Model: WDC WD200BB-00AU  Rev: 0.75
  Type:   Direct-Access                      ANSI SCSI revision: 05
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
ata2: dev 0 cfg 49:0f00 82:0000 83:0000 84:0000 85:0000 86:0000 87:0000
88:0000
ata2: no udma
ata2: dev 0 not supported, ignoring
ata2: thread exiting
scsi1 : ata_piix
SCSI device sda: 39102336 512-byte hdwr sectors (20020 MB)
SCSI device sda: drive cache: write through
 /dev/scsi/host0/bus0/target0/lun0: p1 p2 p3
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
------------------------

I have a CD-ROM as master on the the secondary channel (normally seen as
/dev/hdc), but it doesn't support DMA, so it wasn't detected.

I don't know if there is any interest in developing the "parallel IDE"
support.  I see that the option to enable it is not present in Linux
configuration.  Anyway, that's a device that can be added to the
device table if PATA support is here to stay.

-- 
Regards,
Pavel Roskin
