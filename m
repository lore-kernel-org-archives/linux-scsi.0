From: Gabor Burjan <buga@buvoshetes.hu>
Subject: problem with megaraid2 driver
Date: Fri, 28 Nov 2003 15:17:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031128141717.GA18376@odin.sis.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from odin.sis.hu ([212.92.23.29]:22185 "EHLO odin.sis.hu")
	by vger.kernel.org with ESMTP id S262321AbTK1ORU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Nov 2003 09:17:20 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dear Developers,

I've an LSI Logic MegaRAID SCSI 320-1 card.  The exact name from the
/proc/pci is `RAID bus controller: LSI Logic / Symbios Logic PowerEdge
Expandable RAID Controller 4 (rev 1)' the PCI ID of this device is
0x1960.  I ran into a problem with the new megaraid2 driver:

the relevant information catched on serial console:

Linux version 2.4.23-rc4 (root@mailserver) (gcc version 2.95.4 20011002=
 (Debian prerelease)) #2 Tue Nov 25 11:42:37 CET 2003
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ff30000 (usable)
 BIOS-e820: 000000001ff30000 - 000000001ff40000 (ACPI data)
 BIOS-e820: 000000001ff40000 - 000000001fff0000 (ACPI NVS)
 BIOS-e820: 000000001fff0000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
511MB LOWMEM available.
On node 0 totalpages: 130864
zone(0): 4096 pages.
zone(1): 126768 pages.
zone(2): 0 pages.
Kernel command line: root=3D/dev/sda3 console=3DttyS0 console=3Dtty0
Initializing CPU#0
[...]
SCSI subsystem driver Revision: 1.00
Loading Adaptec I2O RAID: Version 2.4 Build 5
Detecting Adaptec I2O RAID controllers...
megaraid: v2.00.9 (Release Date: Thu Sep  4 17:49:42 EDT 2003)
PCI: Found IRQ 10 for device 02:0c.0
megaraid: found 0x1000:0x1960:bus 2:slot 12:func 0
scsi0:Found MegaRAID controller at 0xe0807000, IRQ:10
megaraid: [1L19:1.04] detected 1 logical drives.
megaraid: supports extended CDBs.
megaraid: channel[0] is raid.
scsi0 : LSI Logic MegaRAID 1L19 254 commands 16 targs 4 chans 7 luns
scsi0: scanning scsi channel 0 for logical drives.
  Vendor: MegaRAID  Model: LD0 RAID5 70006R  Rev: 1L19
  Type:   Direct-Access                      ANSI SCSI revision: 02
scsi0: scanning scsi channel 1 for logical drives.
scsi0: scanning scsi channel 2 for logical drives.
scsi0: scanning scsi channel 4 [P0] for physical devices.
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 143372288 512-byte hdwr sectors (73407 MB)
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >

[... after a few hours of uptime ...]

megaraid: aborting-4027815 cmd=3D2a <c=3D0 t=3D0 l=3D0>
megarid: Waiting for 11 commands to flush: iter:0
megarid: Waiting for 11 commands to flush: iter:1000
megarid: Waiting for 11 commands to flush: iter:2000
megaraid: aborted cmd 3d75a7[76] complete.
megarid: Waiting for 8 commands to flush: iter:3000
[... 4000, 5000, 6000, ... 59000]
megarid: Waiting for 8 commands to flush: iter:60000
megaraid: critical hardware error!
megaraid: aborting-4027818 cmd=3D28 <c=3D0 t=3D0 l=3D0>
megarid: Waiting for 8 commands to flush: iter:0
megarid: Waiting for 8 commands to flush: iter:1000
megarid: Waiting for 8 commands to flush: iter:2000
megarid: Waiting for 8 commands to flush: iter:3000
[... 4000, 5000, 6000, ... 59000]
megarid: Waiting for 3 commands to flush: iter:60000
megaraid: critical hardware error!
megaraid: aborting-4027820 cmd=3D2a <c=3D0 t=3D0 l=3D0>
megarid: Waiting for 3 commands to flush: iter:0
megarid: Waiting for 3 commands to flush: iter:1000
megarid: Waiting for 3 commands to flush: iter:2000
megarid: Waiting for 3 commands to flush: iter:3000
[... 4000, 5000, 6000, ... 59000]
megarid: Waiting for 3 commands to flush: iter:60000
megaraid: critical hardware error!
megaraid: aborting-4027821 cmd=3D2a <c=3D0 t=3D0 l=3D0>
megarid: Waiting for 3 commands to flush: iter:0
megarid: Waiting for 3 commands to flush: iter:1000
megarid: Waiting for 3 commands to flush: iter:2000
megarid: Waiting for 3 commands to flush: iter:3000
[... 4000, 5000, 6000, ... 59000]
megarid: Waiting for 3 commands to flush: iter:60000
megaraid: critical hardware error!
megaraid: aborting-4027822 cmd=3D2a <c=3D0 t=3D0 l=3D0>
megarid: Waiting for 3 commands to flush: iter:0
megarid: Waiting for 3 commands to flush: iter:1000
megarid: Waiting for 3 commands to flush: iter:2000
megarid: Waiting for 3 commands to flush: iter:3000
[... 4000, 5000, 6000, ... 59000]
megarid: Waiting for 3 commands to flush: iter:60000
megaraid: critical hardware error!
megaraid: aborting-4027803 cmd=3D2a <c=3D0 t=3D0 l=3D0>
megarid: Waiting for 3 commands to flush: iter:0
megarid: Waiting for 3 commands to flush: iter:1000
megarid: Waiting for 3 commands to flush: iter:2000
megarid: Waiting for 3 commands to flush: iter:3000
[... 4000, 5000, 6000, ... 59000]
megarid: Waiting for 3 commands to flush: iter:60000
megaraid: critical hardware error!
megaraid: aborting-4027804 cmd=3D2a <c=3D0 t=3D0 l=3D0>
megarid: Waiting for 3 commands to flush: iter:0
megarid: Waiting for 3 commands to flush: iter:1000
megarid: Waiting for 3 commands to flush: iter:2000
megarid: Waiting for 3 commands to flush: iter:3000
[... 4000, 5000, 6000, ... 57000]
megarid: Waiting for 3 commands to flush: iter:58000
megarid: Waiting for 3 commands to flush: iter:59000

[... no interaction -> pressing reset button]

Is it useful in this form?  Unfortunately this is a production server
and I don't have other machine with this kind of RAID card to test on.

Now we're running the old v1.18k driver without any problem.
However I don't see any 1.x driver in v2.6, so this can't be the
long-term solution.

TIA,

G=E1bor
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
