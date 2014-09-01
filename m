From: Andrew Robertson <andyrobertson101@gmail.com>
Subject: Fwd: Adaptec 71605H HBA randomly failing to detect any drives at init
Date: Mon, 1 Sep 2014 09:06:46 -0700
Message-ID: <CAKmTNecfkgOoX6p_1MeV5vNac4N1KoGTjMRcWL2GV77piR8RUw@mail.gmail.com>
References: <CAKmTNed2uSUGCDkxQSLofjgSGxLpZ154_gNpwt_NWChjR=s8iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f68.google.com ([209.85.213.68]:35668 "EHLO
	mail-yh0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaIAQGr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2014 12:06:47 -0400
Received: by mail-yh0-f68.google.com with SMTP id b6so1126111yha.7
        for <linux-scsi@vger.kernel.org>; Mon, 01 Sep 2014 09:06:46 -0700 (PDT)
In-Reply-To: <CAKmTNed2uSUGCDkxQSLofjgSGxLpZ154_gNpwt_NWChjR=s8iA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have an Adaptec 71605H HBA that's randomly failing to detect any
drives at boot.  I have two systems with this HBA, and both are
showing the exact same behavior.  I can reproduce this randomly about
3 out of 4 times, where most of the time it comes up where "lsscsi"
shows no drives attached (other than my boot disk, not attached to
this HBA) - but then occasionally it works fine (~1 out of 4 reboots)
and detects the drives.

On a "good" boot, the kernel messages include:
[   27.575091] pm80xx pm8001_exec_internal_task_abort 834:TMF task timeout.
[   27.754640] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1

On a "bad" boot, it doesn't include these messages; instead it hangs
for ~60 seconds after "Enter sas_scsi_recover_host busy" and then just
continues to boot (and that seems to never recover).  It also never
cleanly shuts down in this state (it hangs forever on "modprobe -q -r
ipmi_devintf" and I have to power-cycle the machine -- I suspect this
is more of a symptom that the kernel is busy doing other things -
possibly still trying to init scsi - isntead an ipmi-specific issue).

I'm happy to test patches/etc on this system if necessary -- and/or if
someone can help point me in the right direction, I'd appreciate it.

Thanks,
Andy


More system info:
---

Linux 3.13.0-35-generic #62-Ubuntu SMP Fri Aug 15 01:58:42 UTC 2014
x86_64 x86_64 x86_64 GNU/Linux
Using: pm80xx 0000:02:00.0: pm80xx: driver version 0.1.37

The Adaptec 71605H HBA has 2 ports, each connected to a different expander.

Bad boot:

[    5.481062] sas: DONE DISCOVERY on port 0, pid:193, result:0
[    5.481066] sas: phy2 matched wide port0
[    5.481071] sas: phy-0:2 added to port-0:0, phy_mask:0x7 (5003048001108c3f)
[    5.481115] sas: phy-0:4 added to port-0:1, phy_mask:0x10 (50030480010f713f)
[    5.481118] sas: phy3 matched wide port0
[    5.481121] sas: phy-0:3 added to port-0:0, phy_mask:0xf (5003048001108c3f)
[    5.481122] sas: phy5 matched wide port1
[    5.481124] sas: phy-0:5 added to port-0:1, phy_mask:0x30 (50030480010f713f)
[    5.481126] sas: phy7 matched wide port1
[    5.481128] sas: phy-0:7 added to port-0:1, phy_mask:0xb0 (50030480010f713f)
[    5.481130] sas: phy6 matched wide port1
[    5.481135] sas: phy-0:6 added to port-0:1, phy_mask:0xf0 (50030480010f713f)
[    5.481159] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[    5.481191] sas: ata7: end_device-0:0:12: dev error handler
[    5.481220] sas: ata8: end_device-0:0:13: dev error handler
[    5.481225] sas: ata9: end_device-0:0:14: dev error handler
[    5.481232] sas: ata10: end_device-0:0:15: dev error handler
[    5.481259] sas: ata11: end_device-0:0:16: dev error handler
[    5.481392] sas: ata12: end_device-0:0:17: dev error handler
[    7.639994] ata8.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.640190] ata7.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.640192] ata7.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.640282] ata11.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.640283] ata11.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.640468] ata10.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.640468] ata10.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.640659] ata12.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.640659] ata12.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.640736] ata7.00: configured for UDMA/133
[    7.640834] ata11.00: configured for UDMA/133
[    7.640990] ata10.00: configured for UDMA/133
[    7.641175] ata12.00: configured for UDMA/133
[    7.728884] ata8.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.736588] ata8.00: configured for UDMA/133
[   65.535289] random: init urandom read with 81 bits of entropy available

---

Good Boot:

[    5.520647] sas: DONE DISCOVERY on port 0, pid:191, result:0
[    5.520651] sas: phy2 matched wide port0
[    5.520657] sas: phy-0:2 added to port-0:0, phy_mask:0x7 (5003048001108c3f)
[    5.520700] sas: phy-0:4 added to port-0:1, phy_mask:0x10 (50030480010f713f)
[    5.520703] sas: phy3 matched wide port0
[    5.520705] sas: phy-0:3 added to port-0:0, phy_mask:0xf (5003048001108c3f)
[    5.520707] sas: phy5 matched wide port1
[    5.520711] sas: phy-0:5 added to port-0:1, phy_mask:0x30 (50030480010f713f)
[    5.520713] sas: phy7 matched wide port1
[    5.520714] sas: phy-0:7 added to port-0:1, phy_mask:0xb0 (50030480010f713f)
[    5.520715] sas: phy6 matched wide port1
[    5.520717] sas: phy-0:6 added to port-0:1, phy_mask:0xf0 (50030480010f713f)
[    5.520739] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[    5.520762] sas: ata7: end_device-0:0:12: dev error handler
[    5.520765] sas: ata8: end_device-0:0:13: dev error handler
[    5.520784] sas: ata9: end_device-0:0:14: dev error handler
[    5.520799] sas: ata10: end_device-0:0:15: dev error handler
[    5.520809] sas: ata11: end_device-0:0:16: dev error handler
[    5.520941] sas: ata12: end_device-0:0:17: dev error handler
[    7.679569] ata7.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.679764] ata12.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.679765] ata12.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.679852] ata9.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.679853] ata9.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.680055] ata11.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.680055] ata11.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.680229] ata10.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.680230] ata10.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.680295] ata12.00: configured for UDMA/133
[    7.680597] ata9.00: configured for UDMA/133
[    7.680881] ata11.00: configured for UDMA/133
[    7.680973] ata10.00: configured for UDMA/133
[    7.768332] ata7.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.776034] ata7.00: configured for UDMA/133
[   27.575091] pm80xx pm8001_exec_internal_task_abort 834:TMF task timeout.
[   27.735815] ata8.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[   27.742599] ata8.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   27.750259] ata8.00: configured for UDMA/133
[   27.754640] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   27.763083] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.771420] scsi 0:0:1:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.779753] scsi 0:0:2:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.788082] scsi 0:0:3:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5



Just in case it's useful, here's a dmesg | egrep 'pm80|scsi|ata' from
the good boot
---
[    0.000000] ACPI: SSDT 00000000dda5db18 000397 (v01 SataRe SataTabl
00001000 INTL 20120711)
[    0.000000] Memory: 16370400K/16736168K available (7372K kernel
code, 1144K rwdata, 3404K rodata, 1336K init, 1440K bss, 365768K
reserved)
[    1.353439] libata version 3.00 loaded.
[    3.942876] Write protecting the kernel read-only data: 12288k
[    4.068826] pm80xx 0000:02:00.0: pm80xx: driver version 0.1.37
[    4.082539] scsi1 : ahci
[    4.082608] scsi2 : ahci
[    4.082660] scsi3 : ahci
[    4.082713] scsi4 : ahci
[    4.082763] scsi5 : ahci
[    4.082816] scsi6 : ahci
[    4.082842] ata1: SATA max UDMA/133 abar m2048@0xf7432000 port
0xf7432100 irq 46
[    4.082844] ata2: SATA max UDMA/133 abar m2048@0xf7432000 port
0xf7432180 irq 46
[    4.082847] ata3: SATA max UDMA/133 abar m2048@0xf7432000 port
0xf7432200 irq 46
[    4.082849] ata4: SATA max UDMA/133 abar m2048@0xf7432000 port
0xf7432280 irq 46
[    4.082852] ata5: SATA max UDMA/133 abar m2048@0xf7432000 port
0xf7432300 irq 46
[    4.082855] ata6: SATA max UDMA/133 abar m2048@0xf7432000 port
0xf7432380 irq 46
[    4.401734] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.401756] ata1: SATA link down (SStatus 0 SControl 300)
[    4.401778] ata6: SATA link down (SStatus 0 SControl 300)
[    4.401800] ata5: SATA link down (SStatus 0 SControl 300)
[    4.401823] ata2: SATA link down (SStatus 0 SControl 300)
[    4.401861] ata4: SATA link down (SStatus 0 SControl 300)
[    4.402839] ata3.00: failed to get NCQ Send/Recv Log Emask 0x1
[    4.402840] ata3.00: ATA-9: Samsung SSD 840 PRO Series, DXM06B0Q,
max UDMA/133
[    4.402841] ata3.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    4.403118] ata3.00: failed to get NCQ Send/Recv Log Emask 0x1
[    4.403119] ata3.00: configured for UDMA/133
[    4.409854] scsi 3:0:0:0: Direct-Access     ATA      Samsung SSD
840  DXM0 PQ: 0 ANSI: 5
[    4.409966] sd 3:0:0:0: Attached scsi generic sg0 type 0
[    4.731895] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[    4.952457] scsi0 : pm80xx
[    4.955564] pm80xx 0000:02:00.0: irq 53 for MSI/MSI-X
[    4.955577] pm80xx 0000:02:00.0: irq 54 for MSI/MSI-X
[    4.955585] pm80xx 0000:02:00.0: irq 55 for MSI/MSI-X
[    4.955588] pm80xx 0000:02:00.0: irq 56 for MSI/MSI-X
[    4.955592] pm80xx 0000:02:00.0: irq 57 for MSI/MSI-X
[    4.955597] pm80xx 0000:02:00.0: irq 58 for MSI/MSI-X
[    4.955601] pm80xx 0000:02:00.0: irq 59 for MSI/MSI-X
[    4.955606] pm80xx 0000:02:00.0: irq 60 for MSI/MSI-X
[    4.955611] pm80xx 0000:02:00.0: irq 61 for MSI/MSI-X
[    4.955616] pm80xx 0000:02:00.0: irq 62 for MSI/MSI-X
[    4.955619] pm80xx 0000:02:00.0: irq 63 for MSI/MSI-X
[    4.955625] pm80xx 0000:02:00.0: irq 64 for MSI/MSI-X
[    4.955629] pm80xx 0000:02:00.0: irq 65 for MSI/MSI-X
[    4.955634] pm80xx 0000:02:00.0: irq 66 for MSI/MSI-X
[    4.955637] pm80xx 0000:02:00.0: irq 67 for MSI/MSI-X
[    4.955640] pm80xx 0000:02:00.0: irq 68 for MSI/MSI-X
[    4.955646] pm80xx 0000:02:00.0: irq 69 for MSI/MSI-X
[    4.955649] pm80xx 0000:02:00.0: irq 70 for MSI/MSI-X
[    4.955653] pm80xx 0000:02:00.0: irq 71 for MSI/MSI-X
[    4.955658] pm80xx 0000:02:00.0: irq 72 for MSI/MSI-X
[    4.955661] pm80xx 0000:02:00.0: irq 73 for MSI/MSI-X
[    4.955665] pm80xx 0000:02:00.0: irq 74 for MSI/MSI-X
[    4.955670] pm80xx 0000:02:00.0: irq 75 for MSI/MSI-X
[    4.955673] pm80xx 0000:02:00.0: irq 76 for MSI/MSI-X
[    4.955679] pm80xx 0000:02:00.0: irq 77 for MSI/MSI-X
[    4.955682] pm80xx 0000:02:00.0: irq 78 for MSI/MSI-X
[    4.955686] pm80xx 0000:02:00.0: irq 79 for MSI/MSI-X
[    4.955689] pm80xx 0000:02:00.0: irq 80 for MSI/MSI-X
[    4.955694] pm80xx 0000:02:00.0: irq 81 for MSI/MSI-X
[    4.955699] pm80xx 0000:02:00.0: irq 82 for MSI/MSI-X
[    4.955704] pm80xx 0000:02:00.0: irq 83 for MSI/MSI-X
[    4.955707] pm80xx 0000:02:00.0: irq 84 for MSI/MSI-X
[    4.955711] pm80xx 0000:02:00.0: irq 85 for MSI/MSI-X
[    4.955714] pm80xx 0000:02:00.0: irq 86 for MSI/MSI-X
[    4.955717] pm80xx 0000:02:00.0: irq 87 for MSI/MSI-X
[    4.955722] pm80xx 0000:02:00.0: irq 88 for MSI/MSI-X
[    4.955725] pm80xx 0000:02:00.0: irq 89 for MSI/MSI-X
[    4.955729] pm80xx 0000:02:00.0: irq 90 for MSI/MSI-X
[    4.955732] pm80xx 0000:02:00.0: irq 91 for MSI/MSI-X
[    4.955737] pm80xx 0000:02:00.0: irq 92 for MSI/MSI-X
[    4.955741] pm80xx 0000:02:00.0: irq 93 for MSI/MSI-X
[    4.955746] pm80xx 0000:02:00.0: irq 94 for MSI/MSI-X
[    4.955749] pm80xx 0000:02:00.0: irq 95 for MSI/MSI-X
[    4.955752] pm80xx 0000:02:00.0: irq 96 for MSI/MSI-X
[    4.955757] pm80xx 0000:02:00.0: irq 97 for MSI/MSI-X
[    4.955761] pm80xx 0000:02:00.0: irq 98 for MSI/MSI-X
[    4.955764] pm80xx 0000:02:00.0: irq 99 for MSI/MSI-X
[    4.955767] pm80xx 0000:02:00.0: irq 100 for MSI/MSI-X
[    4.955773] pm80xx 0000:02:00.0: irq 101 for MSI/MSI-X
[    4.955776] pm80xx 0000:02:00.0: irq 102 for MSI/MSI-X
[    4.955779] pm80xx 0000:02:00.0: irq 103 for MSI/MSI-X
[    4.955783] pm80xx 0000:02:00.0: irq 104 for MSI/MSI-X
[    4.955788] pm80xx 0000:02:00.0: irq 105 for MSI/MSI-X
[    4.955792] pm80xx 0000:02:00.0: irq 106 for MSI/MSI-X
[    4.955795] pm80xx 0000:02:00.0: irq 107 for MSI/MSI-X
[    4.955799] pm80xx 0000:02:00.0: irq 108 for MSI/MSI-X
[    4.955804] pm80xx 0000:02:00.0: irq 109 for MSI/MSI-X
[    4.955807] pm80xx 0000:02:00.0: irq 110 for MSI/MSI-X
[    4.955810] pm80xx 0000:02:00.0: irq 111 for MSI/MSI-X
[    4.955816] pm80xx 0000:02:00.0: irq 112 for MSI/MSI-X
[    4.955819] pm80xx 0000:02:00.0: irq 113 for MSI/MSI-X
[    4.955822] pm80xx 0000:02:00.0: irq 114 for MSI/MSI-X
[    4.955826] pm80xx 0000:02:00.0: irq 115 for MSI/MSI-X
[    4.955831] pm80xx 0000:02:00.0: irq 116 for MSI/MSI-X
[    5.520739] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[    5.520762] sas: ata7: end_device-0:0:12: dev error handler
[    5.520765] sas: ata8: end_device-0:0:13: dev error handler
[    5.520784] sas: ata9: end_device-0:0:14: dev error handler
[    5.520799] sas: ata10: end_device-0:0:15: dev error handler
[    5.520809] sas: ata11: end_device-0:0:16: dev error handler
[    5.520941] sas: ata12: end_device-0:0:17: dev error handler
[    7.679569] ata7.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.679764] ata12.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.679765] ata12.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.679852] ata9.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.679853] ata9.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.680055] ata11.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.680055] ata11.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.680229] ata10.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[    7.680230] ata10.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.680295] ata12.00: configured for UDMA/133
[    7.680597] ata9.00: configured for UDMA/133
[    7.680881] ata11.00: configured for UDMA/133
[    7.680973] ata10.00: configured for UDMA/133
[    7.768332] ata7.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.776034] ata7.00: configured for UDMA/133
[   27.575091] pm80xx pm8001_exec_internal_task_abort 834:TMF task timeout.
[   27.735815] ata8.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[   27.742599] ata8.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   27.750259] ata8.00: configured for UDMA/133
[   27.754640] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   27.763083] scsi 0:0:0:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.771420] scsi 0:0:1:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.779753] scsi 0:0:2:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.788082] scsi 0:0:3:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.796416] scsi 0:0:4:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.804754] scsi 0:0:5:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   27.813320] scsi 0:0:6:0: Enclosure         LSI      SAS2X36
  0e12 PQ: 0 ANSI: 5
[   27.886753] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[   27.886767] sas: ata7: end_device-0:0:12: dev error handler
[   27.886781] sas: ata8: end_device-0:0:13: dev error handler
[   27.886783] sas: ata9: end_device-0:0:14: dev error handler
[   27.886786] sas: ata10: end_device-0:0:15: dev error handler
[   27.886787] sas: ata11: end_device-0:0:16: dev error handler
[   27.886792] sas: ata12: end_device-0:0:17: dev error handler
[   27.886793] sas: ata13: end_device-0:1:12: dev error handler
[   27.886795] sas: ata14: end_device-0:1:13: dev error handler
[   27.886807] sas: ata16: end_device-0:1:15: dev error handler
[   27.886809] sas: ata15: end_device-0:1:14: dev error handler
[   27.886810] sas: ata17: end_device-0:1:16: dev error handler
[   30.045618] ata17.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[   30.045783] ata13.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[   30.045784] ata13.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   30.045973] ata14.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[   30.045974] ata14.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   30.046166] ata15.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[   30.046166] ata15.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   30.046299] ata13.00: configured for UDMA/133
[   30.046500] ata14.00: configured for UDMA/133
[   30.046684] ata15.00: configured for UDMA/133
[   30.107396] ata17.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   30.115191] ata17.00: configured for UDMA/133
[   49.889251] pm80xx pm8001_exec_internal_task_abort 834:TMF task timeout.
[   50.050029] ata16.00: ATA-9: WDC WD60EFRX-68MYMN0, 82.00A82, max UDMA/133
[   50.056903] ata16.00: 11721045168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   50.064697] ata16.00: configured for UDMA/133
[   50.069160] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   50.073261] scsi 0:0:7:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   50.081602] scsi 0:0:8:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   50.089936] scsi 0:0:9:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   50.098268] scsi 0:0:10:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   50.106687] scsi 0:0:11:0: Direct-Access     ATA      WDC
WD60EFRX-68M 82.0 PQ: 0 ANSI: 5
[   50.115423] scsi 0:0:12:0: Enclosure         LSI      SAS2X28
   0e12 PQ: 0 ANSI: 5
[   50.139025] sd 0:0:0:0: Attached scsi generic sg1 type 0
[   50.139118] sd 0:0:1:0: Attached scsi generic sg2 type 0
[   50.139215] sd 0:0:2:0: Attached scsi generic sg3 type 0
[   50.139305] sd 0:0:3:0: Attached scsi generic sg4 type 0
[   50.139387] sd 0:0:4:0: Attached scsi generic sg5 type 0
[   50.139483] sd 0:0:5:0: Attached scsi generic sg6 type 0
[   50.139556] scsi 0:0:6:0: Attached scsi generic sg7 type 13
[   50.139623] sd 0:0:7:0: Attached scsi generic sg8 type 0
[   50.139721] sd 0:0:8:0: Attached scsi generic sg9 type 0
[   50.139806] sd 0:0:9:0: Attached scsi generic sg10 type 0
[   50.139888] sd 0:0:10:0: Attached scsi generic sg11 type 0
[   50.139985] sd 0:0:11:0: Attached scsi generic sg12 type 0
[   50.140049] scsi 0:0:12:0: Attached scsi generic sg13 type 13
[   51.852181] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[   51.852185] sas: ata10: end_device-0:0:15: cmd error handler
[   51.852197] sas: ata7: end_device-0:0:12: dev error handler
[   51.852202] sas: ata8: end_device-0:0:13: dev error handler
[   51.852207] sas: ata9: end_device-0:0:14: dev error handler
[   51.852208] sas: ata10: end_device-0:0:15: dev error handler
[   51.852214] sas: ata11: end_device-0:0:16: dev error handler
[   51.852218] sas: ata12: end_device-0:0:17: dev error handler
[   51.852219] sas: ata13: end_device-0:1:12: dev error handler
[   51.852223] sas: ata14: end_device-0:1:13: dev error handler
[   51.852224] sas: ata15: end_device-0:1:14: dev error handler
[   51.852227] sas: ata16: end_device-0:1:15: dev error handler
[   51.852229] sas: ata17: end_device-0:1:16: dev error handler
[   51.852233] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   51.852711] sas: Enter sas_scsi_recover_host busy: 3 failed: 3
[   51.852712] sas: ata11: end_device-0:0:16: cmd error handler
[   51.852714] sas: ata7: end_device-0:0:12: cmd error handler
[   51.852714] sas: ata8: end_device-0:0:13: cmd error handler
[   51.852736] sas: ata7: end_device-0:0:12: dev error handler
[   51.852743] sas: ata8: end_device-0:0:13: dev error handler
[   51.852745] sas: ata9: end_device-0:0:14: dev error handler
[   51.852747] sas: ata10: end_device-0:0:15: dev error handler
[   51.852749] sas: ata11: end_device-0:0:16: dev error handler
[   51.852752] sas: ata12: end_device-0:0:17: dev error handler
[   51.852753] sas: ata13: end_device-0:1:12: dev error handler
[   51.852755] sas: ata14: end_device-0:1:13: dev error handler
[   51.852756] sas: ata15: end_device-0:1:14: dev error handler
[   51.852758] sas: ata16: end_device-0:1:15: dev error handler
[   51.852760] sas: ata17: end_device-0:1:16: dev error handler
[   51.852764] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   51.853243] sas: Enter sas_scsi_recover_host busy: 4 failed: 4
[   51.853245] sas: ata9: end_device-0:0:14: cmd error handler
[   51.853247] sas: ata16: end_device-0:1:15: cmd error handler
[   51.853248] sas: ata14: end_device-0:1:13: cmd error handler
[   51.853250] sas: ata17: end_device-0:1:16: cmd error handler
[   51.853331] sas: ata7: end_device-0:0:12: dev error handler
[   51.853337] sas: ata8: end_device-0:0:13: dev error handler
[   51.853339] sas: ata9: end_device-0:0:14: dev error handler
[   51.853345] sas: ata10: end_device-0:0:15: dev error handler
[   51.853348] sas: ata11: end_device-0:0:16: dev error handler
[   51.853353] sas: ata12: end_device-0:0:17: dev error handler
[   51.853354] sas: ata13: end_device-0:1:12: dev error handler
[   51.853355] sas: ata14: end_device-0:1:13: dev error handler
[   51.853356] sas: ata15: end_device-0:1:14: dev error handler
[   51.853359] sas: ata16: end_device-0:1:15: dev error handler
[   51.853361] sas: ata17: end_device-0:1:16: dev error handler
[   51.853368] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   51.868638] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[   51.868642] sas: ata15: end_device-0:1:14: cmd error handler
[   51.868653] sas: ata7: end_device-0:0:12: dev error handler
[   51.868656] sas: ata8: end_device-0:0:13: dev error handler
[   51.868658] sas: ata9: end_device-0:0:14: dev error handler
[   51.868662] sas: ata10: end_device-0:0:15: dev error handler
[   51.868663] sas: ata11: end_device-0:0:16: dev error handler
[   51.868664] sas: ata12: end_device-0:0:17: dev error handler
[   51.868665] sas: ata13: end_device-0:1:12: dev error handler
[   51.868666] sas: ata14: end_device-0:1:13: dev error handler
[   51.868667] sas: ata15: end_device-0:1:14: dev error handler
[   51.868668] sas: ata16: end_device-0:1:15: dev error handler
[   51.868668] sas: ata17: end_device-0:1:16: dev error handler
[   51.868677] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[   51.889624] sas: Enter sas_scsi_recover_host busy: 2 failed: 2
[   51.889627] sas: ata13: end_device-0:1:12: cmd error handler
[   51.889628] sas: ata12: end_device-0:0:17: cmd error handler
[   51.889644] sas: ata7: end_device-0:0:12: dev error handler
[   51.889650] sas: ata8: end_device-0:0:13: dev error handler
[   51.889653] sas: ata9: end_device-0:0:14: dev error handler
[   51.889655] sas: ata10: end_device-0:0:15: dev error handler
[   51.889659] sas: ata12: end_device-0:0:17: dev error handler
[   51.889660] sas: ata11: end_device-0:0:16: dev error handler
[   51.889662] sas: ata13: end_device-0:1:12: dev error handler
[   51.889664] sas: ata14: end_device-0:1:13: dev error handler
[   51.889667] sas: ata15: end_device-0:1:14: dev error handler
[   51.889670] sas: ata16: end_device-0:1:15: dev error handler
[   51.889671] sas: ata17: end_device-0:1:16: dev error handler
[   51.889678] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
---
