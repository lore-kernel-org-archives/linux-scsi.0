From: Paul Veldema <paul@basenet.nl>
Subject: Dell 2850 build in (LSI) PERC4/Di 2.6 kernel driver.
Date: Tue, 29 Mar 2005 14:11:20 +0200
Message-ID: <424945E8.4040502@basenet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:47633 "EHLO
	smtp-vbr11.xs4all.nl") by vger.kernel.org with ESMTP
	id S262248AbVC2MU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2005 07:20:56 -0500
Received: from smtp.realworks.nl (smtp.realworks.nl [194.109.157.47])
	by smtp-vbr11.xs4all.nl (8.12.11/8.12.11) with ESMTP id j2TCKpND025001
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 14:20:55 +0200 (CEST)
	(envelope-from paul@basenet.nl)
Received: from amavis by smtp.realworks.nl with virus-scanned (Exim 3.35 #1 (Debian))
	id 1DGFYt-0000MX-00
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 14:11:11 +0200
Received: from smtp.realworks.nl ([127.0.0.1])
	by localhost (rwlinux12 [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 31706-24 for <linux-scsi@vger.kernel.org>;
	Tue, 29 Mar 2005 14:11:11 +0200 (CEST)
Received: from [213.53.208.101] (helo=[127.0.0.1])
	by smtp.realworks.nl with esmtp (Exim 3.35 #1 (Debian))
	id 1DGFYt-0000MN-00
	for <linux-scsi@vger.kernel.org>; Tue, 29 Mar 2005 14:11:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello developers,

For the last two months I've been strugling with a driver problem. Our 
company bought two Dell PowerEdge 2850's
to try our production kernel version 2.6.8 (debian sarge) on since the 
2650 are no longer sold. The Dell PE 2650's had Perc4/DC cards in
them (which work fine with the drivers and kernel 2.6.X) supposedly the 
same thing as the build in Perc4/Di controllers in the PE2850's.
According to Dell the LSI chipset in the PERC4 is de LSI53C1020.

However, the megaraid drivers don't detect the Perc4/Di controllers 
resulting in a
kernel panic when linux wants to start load stuff from disk (can't find 
file bla).

On http://linux.dell.com/storage.shtml the following info has been 
posted for a while now:

    * PowerEdge 2800, PowerEdge 2850, PowerEdge 1850 - PERC4e/Di - dual
      channel, U320 SCSI, PCI Express, with battery-backed cache.
      Requires megaraid2 driver 2.00.3 or higher (on 2.4.x kernels), on
      2.6.x kernels you can use the 'megaraid' driver (now historical),
      or ideally, the 'megaraid_mbox' and 'megaraid_mm' drivers.

The mentioned "*on 2.6.x kernels you can use the 'megaraid' driver (now 
historical), or ideally, the 'megaraid_mbox' and 'megaraid_mm' 
drivers.*"  don't work (kernel 2.6.8 as well as kernel 2.6.9).

I tried the correct driver  source downloaded from 
http://www.lsilogic.com/downloads/selectDownload.do#driver: 
mptlinux-3.01.14.23.zip .
 >From source *'megaraid' driver (now historical)*:
#define MEGARAID_VERSION        \
        "v2.00.3 (Release Date: Wed Feb 19 08:51:30 EST 2003)\n"

 >From source "*megaraid_mbox*":
#define MEGARAID_VERSION        "2.20.3.1"

...

#define PCI_DEVICE_ID_PERC4E_DI_KOBUK                   0x0013
#define PCI_SUBSYS_ID_PERC4E_DI_KOBUK                   0x016d

#define PCI_DEVICE_ID_PERC4E_DI_CORVETTE                0x0013
#define PCI_SUBSYS_ID_PERC4E_DI_CORVETTE                0x016e

#define PCI_DEVICE_ID_PERC4E_DI_EXPEDITION              0x0013
#define PCI_SUBSYS_ID_PERC4E_DI_EXPEDITION              0x016f

#define PCI_DEVICE_ID_PERC4E_DI_GUADALUPE               0x0013
#define PCI_SUBSYS_ID_PERC4E_DI_GUADALUPE               0x0170

...

I tried the historical, mm and mbox drivers (together, separately, 
omitting the historical form the build, in different orders also with 
initrd ramdisk image)
nothing works. If anyone knows/has working version combinations 
(kernel+drivers) please email the information to paul@realworks.nl. Also 
where can I get newer versions of the megaraid drivers than can be 
downloaded from LSI's download page?

Here some info under the 2.4.27 kernel and megaraid2 driver on one of 
the PE2850 machines:
lsmod:
megaraid2              33768   6 (autoclean)
scsi_mod               97828   3 (autoclean) [ide-scsi sd_mod megaraid2]

dmesg:
SCSI subsystem driver Revision: 1.00
megaraid: v2.10.3 (Release Date: Thu Apr  8 16:16:05 EDT 2004)
megaraid: found 0x1028:0x0013:bus 2:slot 14:func 0
scsi0:Found MegaRAID controller at 0xf8838000, IRQ:38
megaraid: [513O:H418] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
megaraid: channel[1] is scsi.
scsi0 : LSI Logic MegaRAID 513O 254 commands 16 targs 5 chans 7 luns
blk: queue f6e45e18, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD 0 RAID5  279G  Rev: 513O
  Type:   Direct-Access                      ANSI SCSI revision: 02
blk: queue f6e45c18, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
  Vendor: PE/PV     Model: 1x6 SCSI BP       Rev: 1.0
  Type:   Processor                          ANSI SCSI revision: 02
blk: queue f6e45a18, I/O limit 4095Mb (mask 0xffffffff)
scsi0: scanning scsi channel 5 [P1] for physical devices.
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 572456960 512-byte hdwr sectors (293098 MB)
Partition check:
 /dev/scsi/host0/bus0/target0/lun0: p1 p2 p3 p4 < p5 p6 p7 >
Journalled Block Device driver loaded

I hope this is enough info, if there are fixes I'll be happy to try them 
and reply the results (dmesg errors etc.)
I have one machine freely available for testing.

With regards, Paul Veldema (Realworks B.V.).

