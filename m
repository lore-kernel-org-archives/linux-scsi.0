From: Reartes Guillermo <rtguille@gmail.com>
Subject: Hard Freeze with ASMedia SATA (1b21:0612) (PCIe) and Optical Drive
 (iHBS112) [Fedora 17]
Date: Fri, 25 Jan 2013 19:31:11 -0300
Message-ID: <CAPVzhpxVTuA-JAjHC1WPDdUcwaVj15qmP+uUpr9DjXyZc0CU5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f54.google.com ([209.85.210.54]:44016 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3AYWbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2013 17:31:11 -0500
Received: by mail-da0-f54.google.com with SMTP id n2so375154dad.41
        for <linux-scsi@vger.kernel.org>; Fri, 25 Jan 2013 14:31:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I recently installed a PCIe 1X SATA Controller on a free PCIe Slot:

# lspci -nn
06:00.0 SATA controller [0106]: ASMedia Technology Inc. Device
[1b21:0612] (rev 01)
        Subsystem: ASMedia Technology Inc. Device [1b21:1060]
        Kernel driver in use: ahci

Which corresponds to:

# lsscsi
[11:0:0:0]   cd/dvd  ATAPI    iHBS112   2      CL0K  /dev/sr0

DMESG:
[    3.441070] ata12: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.444902] ata12.00: ATAPI: ATAPI   iHBS112   2, CL0K, max UDMA/100
[    3.446528] ata12.00: configured for UDMA/100

[    2.091681] ata11: SATA max UDMA/133 abar m512@0xfe510000 port
0xfe510100 irq 73
[    2.091683] ata12: SATA max UDMA/133 abar m512@0xfe510000 port
0xfe510180 irq 73

Under: 3.7.3-101.fc17.x86_64 (Fedora 17 X86_64)

HW: FX-6100 on 990FX (Asus Sabertooth 990FX, Bios: 1304)

On the ASMedia controller, one port goes to the BluRay Writer
(iHBS112) and the other port goes to the chassis eSATA port (not
tested yet).

I planed to use this controller for two sata hot-swap bays but the
sata cables were short and did not reach the pcie card, so i was only
able to plug both the optical drive and the chassis esata port on this
controller.

The optical drive is detected, but when i first tryied to burn a
bluray, it gave an i/o error (since i was diagnosing a previous
growisofs bug-report i got a strace) then i ejected and reinserted the
media and the system froze.

Then i reset it, but it froze again when the disc was inserted. Then i
power it off and on again and inserted a blank dvd+rw this time to
burn a regular dvd+ but it also froze...

It does not froze if the optical drive is empty. This writer worked ok
while it was connected to the onboard sb950 sata controller.

And the "freeze" does not allways happen on insertion, for some
reason. But i cannot burn with the optical drive without expecting
occasional freezes (or i/o errors).

In the next test, i was able to burn a dvd+r and verify it with K3b. I
also reinserted the media and played some videos, then ejected it.
After that, i wanted to burn another dvd+r and inserted a blank media
and the system froze.

Since my laptop was connected via ssh and doing a tail to the messages
files, i got:

Jan 25 18:56:45 ulquiorra dbus-daemon[1174]: ** Message: No devices in use, exit
Jan 25 19:06:40 ulquiorra udevd[497]: worker [711] timeout, kill it
Jan 25 19:06:40 ulquiorra udevd[497]: seq 2760
'/devices/pci0000:00/0000:00:0d.0/0000:06:00.0/ata12/host11/target11:0:0/11:0:0:0/block/sr0'
killed
Jan 25 19:06:40 ulquiorra udevd[497]: worker [711] terminated by
signal 9 (Killed)
Jan 25 19:06:41 ulquiorra kernel: [ 3901.881021] ata12.00: exception
Emask 0x52 SAct 0x0 SErr 0xffffffff action 0xe frozen
Jan 25 19:06:41 ulquiorra kernel: [ 3901.881043] ata12: SError: {
RecovData RecovComm UnrecovData Persist Proto HostInt PHYRdyChg PHYInt
CommWake 10B8B Dispar BadCRC Handshk LinkSeq TrStaTrns UnrecFIS
DevExch }
Jan 25 19:06:41 ulquiorra kernel: [ 3901.881051] ata12.00: failed
command: IDENTIFY PACKET DEVICE
Jan 25 19:06:41 ulquiorra kernel: [ 3901.881063] ata12.00: cmd
a1/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
Jan 25 19:06:41 ulquiorra kernel: [ 3901.881063]          res
40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x56 (ATA bus error)
Jan 25 19:06:41 ulquiorra kernel: [ 3901.881069] ata12.00: status: { DRDY }
Jan 25 19:06:41 ulquiorra kernel: [ 3901.881079] ata12: hard resetting link

After that, it is either reset or power-cycle.

Thanks in advance.
