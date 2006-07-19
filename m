From: Adam Turner <turnerac@mail.chs.spawar.navy.mil>
Subject: LSI MegaRAID New Driver problem on Dell Poweredge 650 (new)
Date: Wed, 19 Jul 2006 09:16:01 -0400
Message-ID: <44BE3091.7060403@mail.chs.spawar.navy.mil>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.spawar.navy.mil ([128.49.4.3]:44751 "EHLO
	smtp2.spawar.navy.mil") by vger.kernel.org with ESMTP
	id S964813AbWGSNa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jul 2006 09:30:29 -0400
Received: from [150.125.32.41] (bradleyj.chs.spawar.navy.mil [150.125.32.41])
	by smtp2.spawar.navy.mil (8.12.11.20060308/8.12.11) with ESMTP id k6JDULAs024813
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2006 06:30:22 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

If anyone read the last email I sent about this, I'm sorry I didn't know
how busy this list must be.  Here's the complete rundown

I have a dell pe650 server which last worked running a 2.6.7 kernel, I
think it was a development kernel. under a livecd this is the lspci,
lspci -n output so you can see exactly what card i'm using.

spci:
00:00.0 Host bridge: Broadcom GCNB-LE Host Bridge (rev 32)
00:00.1 Host bridge: Broadcom GCNB-LE Host Bridge
00:03.0 RAID bus controller: American Megatrends Inc. MegaRAID (rev 02)
00:04.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
00:0f.0 Host bridge: Broadcom CSB6 South Bridge (rev a0)
00:0f.1 IDE interface: Broadcom CSB6 RAID/IDE Controller (rev a0)
00:0f.2 USB Controller: Broadcom CSB6 OHCI USB Controller (rev 05)
00:0f.3 ISA bridge: Broadcom GCLE-2 Host Bridge
00:10.0 Host bridge: Broadcom CIOB-E I/O Bridge with Gigabit Ethernet
(rev 12)
00:10.2 Host bridge: Broadcom CIOB-E I/O Bridge with Gigabit Ethernet
(rev 12)
01:03.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet
Controller (Copper) (rev 01)
01:03.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet
Controller (Copper) (rev 01)

lspci -n:
00:00.0 0600: 1166:0017 (rev 32)
00:00.1 0600: 1166:0017
00:03.0 0104: 101e:1960 (rev 02)
00:04.0 0300: 1002:4752 (rev 27)
00:0f.0 0600: 1166:0203 (rev a0)
00:0f.1 0101: 1166:0213 (rev a0)
00:0f.2 0c03: 1166:0221 (rev 05)
00:0f.3 0601: 1166:0227
00:10.0 0600: 1166:0110 (rev 12)
00:10.2 0600: 1166:0110 (rev 12)
01:03.0 0200: 8086:1010 (rev 01)
01:03.1 0200: 8086:1010 (rev 01)


here is the bootup from the old 2.6.7 kernel:


megaraid: found 0x101e:0x1960:bus 0:slot 3:func 0
scsi0:Found MegaRAID controller at 0xf884a000, IRQ:17
megaraid: [6.62:1.03] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
megaraid: channel[1] is raid.
megaraid: channel[2] is raid.
megaraid: channel[3] is raid.
scsi0 : LSI Logic MegaRAID 6.62 254 commands 16 targs 7 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
Vendor: MegaRAID Model: LD 0 RAID1 76G Rev: 6.62
Type: Direct-Access ANSI SCSI revision: 02
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
scsi0: scanning scsi channel 5 [P1] for physical devices.
scsi0: scanning scsi channel 6 [P2] for physical devices.
scsi0: scanning scsi channel 7 [P3] for physical devices.
SCSI device sda: 156217344 512-byte hdwr sectors (79983 MB)
sda: asking for cache data failed
sda: assuming drive cache: write through
/dev/scsi/host0/bus0/target0/lun0: p1 p2 p3 p4
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 0, lun 0, type 0

after working with dsd, a gentoo developer, it was determined that on a
current kernel version (2.6.16-r9) the LSI MegaRAID New Driver is needed
for my controller.

Here is the bootup from the 2.6.16-r9 kernel:

megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
megaraid: 2.20.4.7 (Release Date: Mon Nov 14 12:27:22 EST 2005)
megaraid: probe new device 0x101e:0x1960:0x1028:0x0511: bus 0:slot 3:func 0
megaraid: fw version:[6.62] bios version:[1.03]
scsi0 : LSI Logic MegaRAID driver
scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
scsi[0]: scanning scsi channel 1 [Phy 1] for non-raid devices
scsi[0]: scanning scsi channel 2 [Phy 2] for non-raid devices
scsi[0]: scanning scsi channel 3 [Phy 3] for non-raid devices
scsi[0]: scanning scsi channel 4 [virtual] for logical drives

dsd concluded there is most likely a problem in the new driver detecting
 the hard drives and referred me to this list.  I'm pretty new to all of
this so I'm not sure what other information I can provide to help
resolve this but i would appreciate any help you could offer.

Thank you in advance,
Adam Turner
