From: "Ken Hwang" <ken.hwang@zyxel.com>
Subject: ata_piix in 2.4.27
Date: Mon, 13 Sep 2004 11:19:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <HIENIDNHFMODBIPFNJPDCEFLCEAA.ken.hwang@zyxel.com>
Reply-To: <ken.hwang@zyxel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [65.170.185.70] ([65.170.185.70]:61397 "EHLO zyxel.com")
	by vger.kernel.org with ESMTP id S266517AbUIMSTZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Sep 2004 14:19:25 -0400
Received: from dns.zyxel.com (root@localhost)
	by zyxel.com (8.12.11/8.12.5) with SMTP id i8DIJOoZ032468
	for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2004 11:19:24 -0700
Received: from KenHwang (adsl-67-124-113-178.dsl.snfc21.pacbell.net [67.124.113.178])
	(authenticated bits=0)
	by zyxel.com (8.12.11/8.12.5) with ESMTP id i8DIJGR2032451
	for <linux-scsi@vger.kernel.org>; Mon, 13 Sep 2004 11:19:21 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a problem with ata_piix in 2.4.27 and please HELP. If I send this
message to a wrong list please also let me know. Thanks.

I was using kernel 2.4.26 plus the 2.4.26-rc1-libata3.patch on the hardware
I have. The system had Intel 865 chipset and the disk controllers are: 2x
Promise SATA, 1x Intel PIIX ATA. And I want to treat all 3 disks as SATA for
easier scripting later on. I used kernel 2.4.26 + 2.4.26-rc1-libata3 and I
added one line in the ata_piix.c to define the ATA_ENABLE_PATA so that the
disks connect to Intel PIIX can show as /dev/sdx instead of /dev/hdx. And
they work fine: the system can boot from the disk connected to PIIX and
treat it as /dev/sda.

I need to move to 2.4.27 for some FS fixes. I downloaded kernel 2.4.27 and
added 2.4.26-bk1-libata1. I then define the ATA_ENABLE_PATA in the
include/linux/libata.h and recompiled the kernel with Intel PIIX SCSI low
level driver support configured as part of kernel. I then use the kernel to
boot and it can recognize the PATA disk as SCSI disk but then kernel panic.
I list some of the bootup messege as the following:

SCSI subsystem driver Revision: 1.00
PCI: Found IRQ 9 for device 00:1f.1
PCI Sharing IRQ 9 with 00:1d.2
ata1: PATA mac UDMA/33 cmd 0x1F0 ctl 0c3F6 bmdma 0xF000 irq 14
ata1: dev 0 ATA, max UDMA/100, 312581808 sectors: lba48
ata1: dev 0 configured for UDMA/33
ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0xF008 irq 15
ata2: disabling port
scsi0 : ata_piix
scsi1 : ata_piix
  Vendor: ATA   Model: WDC WD1600BB-00D Rev. 75.1
  Type:   Direct-Access                 ANSI SCSI revision: 05
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
Partition check:
 sda:<1>Unable to handle kernel NULL pointer dereference at virtual address
0000 0000
 printing eip:
00000000
*pde = 00000000
O0ps: 0000
CPU: 0
EIP: 0010:[<00000000>] Not tainted
EFLAGS: 00010046
...........


Please HELP and thanks,


Ken

---
Outgoing mail is certified Virus Free.
Checked by AVG anti-virus system (http://www.grisoft.com).
Version: 6.0.687 / Virus Database: 448 - Release Date: 5/16/2004


