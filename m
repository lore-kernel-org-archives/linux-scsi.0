From: "Jon Watte" <jwatte@gmail.com>
Subject: AHCI finds disks; no /dev/sd inodes bound?
Date: Tue, 8 Jan 2008 23:40:12 -0800
Message-ID: <c7bcbd620801082340j46839c22n3081c2f5ad6af0ff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:15656 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbYAIHkN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jan 2008 02:40:13 -0500
Received: by py-out-1112.google.com with SMTP id u52so236505pyb.10
        for <linux-scsi@vger.kernel.org>; Tue, 08 Jan 2008 23:40:12 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I ran out of PATA ports, and figured I'd use the un-used SATA ports on
the motherboard of the current machine (Intel G33/ICH9 based) to
expand storage that has run out again (like storage usually does). I
shut down the machine, put in the disks, booted up, made sure the BIOS
said enhanced/AHCI mode, and gave it a spin. Unfortunately, while the
AHCI system sees the disks, they appear to not get mapped to any block
devices in /dev, so I can't actually partition and mount them. What am
I missing, to make the devices bind to (I assume) /dev/sda and
/dev/sdb, or similar? (They also don't bind to /dev/sgX).

I've tried to google for this particular problem, but because I'm not
using a specific distribution, all I'm getting is various information
about how to write SCSI subsystem modules, or how to use tools when
the device binding has already happened -- nothing about what makes
that happen, and what's missing on my machine to make it so. (I'm
assuming it's something I'm missing in my init scripts here -- but
that assumption could be wrong, too)

Here is the output from dmesg that has to do with AHCI (before it is
PATA output; after it is 1394 output).

ahci 0000:00:1f.2: version 2.2
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 22 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pmp pio slum part
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 cmd 0xf8822900 ctl 0x00000000 bmdma 0x00000000 irq 221
ata2: SATA max UDMA/133 cmd 0xf8822980 ctl 0x00000000 bmdma 0x00000000 irq 221
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 cmd 0xf8822b00 ctl 0x00000000 bmdma 0x00000000 irq 221
ata6: SATA max UDMA/133 cmd 0xf8822b80 ctl 0x00000000 bmdma 0x00000000 irq 221
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST3500630SV, 3.ACH, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: WDC WD5000ABYS-01TNA0, 12.01C01, max UDMA/133
ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3500630SV      3.AC PQ: 0 ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      WDC WD5000ABYS-0 12.0 PQ: 0 ANSI: 5


Here is the output of # ls -l /sys/bus/scsi/devices
total 0
lrwxrwxrwx    1 root     root            0 Jan  8 22:48 0:0:0:0 ->
../../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/
lrwxrwxrwx    1 root     root            0 Jan  8 22:48 1:0:0:0 ->
../../../devices/pci0000:00/0000:00: 1f.2/host1/target1:0:0/1:0:0:0/

And the output of # ls -l
/sys/devices/pci0000\:00/0000\:00\:1f.2/host0/target0\:0\:0/0\:0\:0\:0/
total 0
lrwxrwxrwx    1 root     root            0 Jan  8 22:48 bus ->
../../../../../../bus/scsi/
--w-------    1 root     root         4096 Jan  8 22:48 delete
-r--r--r--    1 root     root         4096 Jan  8 22:48 device_blocked
-r--r--r--    1 root     root         4096 Jan  8 22:48 iocounterbits
-r--r--r--    1 root     root         4096 Jan  8 22:48 iodone_cnt
-r--r--r--    1 root     root         4096 Jan  8 22:48 ioerr_cnt
-r--r--r--    1 root     root         4096 Jan  8 22:48 iorequest_cnt
-r--r--r--    1 root     root         4096 Jan  8 22:48 modalias
-r--r--r--    1 root     root         4096 Jan  8 22:48 model
drwxr-xr-x    2 root     root            0 Jan  8 22:28 power/
-rw-r--r--    1 root     root         4096 Jan  8 22:48 queue_depth
-r--r--r--    1 root     root         4096 Jan  8 22:48 queue_type
--w-------    1 root     root         4096 Jan  8 22:48 rescan
-r--r--r--    1 root     root         4096 Jan  8 22:48 rev
lrwxrwxrwx    1 root     root            0 Jan  8 22:48
scsi_device:0:0:0:0 -> ../../../../../../class/scsi_device/0:0:0:0/
-r--r--r--    1 root     root         4096 Jan  8 22:48 scsi_level
-rw-r--r--    1 root     root         4096 Jan  8 22:48 state
lrwxrwxrwx    1 root     root            0 Jan  8 22:48 subsystem ->
../../../../../../bus/scsi/
-rw-r--r--    1 root     root         4096 Jan  8 22:48 timeout
-r--r--r--    1 root     root         4096 Jan  8 22:48 type
-rw-r--r--    1 root     root         4096 Jan  8 22:48 uevent
-r--r--r--    1 root     root         4096 Jan  8 22:48 vendor


NOTE: there is no "dev" entry for this device, so there's apparently
no mapped inode in /dev.

I have been running a home server for about 10 years (it started out
as a Pentium 120). Back then, "distributions" weren't really all that
fancy. This server has undergone many hardware and software upgrades,
but only ever the minimum to make it work at each time. Currently,
it's running kernel 2.6.22, but /dev/ has inodes from the 2.2 or 2.4
days, and rc scripts are whatever I've cobbled together. There are a
myriad services on the machine, many of which family and friends
depend on, and I fear that trying to migrate it all (including a large
storage array) to some "cooked" distribution would take days and be
very disruptive.

Any help or pointers to self-help would be appreciated!

Cheers,

                   / h+

--
Americans might object: there is no way we would sacrifice our living
standards for the benefit of people in the rest of the world.
Nevertheless, whether we get there willingly or not, we shall soon
have lower consumption rates, because our present rates are
unsustainable.
