From: Michael Tokarev <mjt@tls.msk.ru>
Subject: SATA (AHCI) (or disk) probs on Intel Server Board S5000PAL
Date: Wed, 04 Apr 2007 15:33:19 +0400
Message-ID: <46138CFF.9000701@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hobbit.corpit.ru ([81.13.94.6]:21314 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992865AbXDDLdZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2007 07:33:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On a regular basis now (but not very frequently - it happened
two times in a single month so far), a system based on the
abovementioned board fails to work with a hard drive, on an
idle system.  Like this (too bad it's not an 1st April joke):

Apr  1 01:36:09 ata2.00: exception Emask 0x10 SAct 0x2 SErr 0x280100 action 0x2 frozen
Apr  1 01:36:09 ata2.00: (irq_stat 0x08000000, interface fatal error)
Apr  1 01:36:09 ata2.00: cmd 60/80:08:dd:57:f8/00:00:0f:00:00/40 tag 1 cdb 0x0 data 65536 in
Apr  1 01:36:09          res 40/00:08:dd:57:f8/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:09 ata2: soft resetting port
Apr  1 01:36:10 ata2: softreset failed (1st FIS failed)
Apr  1 01:36:10 ata2: softreset failed, retrying in 5 secs
Apr  1 01:36:15 ata2: hard resetting port
Apr  1 01:36:22 ata2: port is slow to respond, please be patient (Status 0x80)
Apr  1 01:36:45 ata2: port failed to respond (30 secs, Status 0x80)
Apr  1 01:36:45 ata2: COMRESET failed (device not ready)
Apr  1 01:36:45 ata2: hardreset failed, retrying in 5 secs
Apr  1 01:36:50 ata2: hard resetting port
Apr  1 01:36:50 ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  1 01:36:50 ata2.00: configured for UDMA/133
Apr  1 01:36:50 ata2: EH complete
Apr  1 01:36:50 SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
Apr  1 01:36:50 sdb: Write Protect is off
Apr  1 01:36:50 sdb: Mode Sense: 00 3a 00 00
Apr  1 01:36:50 SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Apr  1 01:36:53 ata2.00: exception Emask 0x10 SAct 0xefffff SErr 0x280100 action 0x2 frozen
Apr  1 01:36:53 ata2.00: (irq_stat 0x08000000, interface fatal error)
Apr  1 01:36:53 ata2.00: cmd 60/80:00:5d:d5:fc/00:00:0f:00:00/40 tag 0 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:08:dd:ce:fc/00:00:0f:00:00/40 tag 1 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:10:dd:d0:fc/00:00:0f:00:00/40 tag 2 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:18:dd:d2:fc/00:00:0f:00:00/40 tag 3 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 61/10:20:ba:65:7a/00:00:00:00:00/40 tag 4 cdb 0x0 data 8192 out
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 61/10:28:92:93:bb/00:00:00:00:00/40 tag 5 cdb 0x0 data 8192 out
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 61/08:30:4a:95:bb/00:00:00:00:00/40 tag 6 cdb 0x0 data 4096 out
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 61/08:38:52:96:bb/00:00:00:00:00/40 tag 7 cdb 0x0 data 4096 out
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 61/08:40:62:96:bb/00:00:00:00:00/40 tag 8 cdb 0x0 data 4096 out
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:48:5d:d4:fc/00:00:0f:00:00/40 tag 9 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:50:5d:cf:fc/00:00:0f:00:00/40 tag 10 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:58:5d:d3:fc/00:00:0f:00:00/40 tag 11 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:60:5d:d0:fc/00:00:0f:00:00/40 tag 12 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:68:dd:d1:fc/00:00:0f:00:00/40 tag 13 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:70:dd:cd:fc/00:00:0f:00:00/40 tag 14 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:78:5d:d2:fc/00:00:0f:00:00/40 tag 15 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:80:dd:cc:fc/00:00:0f:00:00/40 tag 16 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:88:5d:cd:fc/00:00:0f:00:00/40 tag 17 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:90:dd:d3:fc/00:00:0f:00:00/40 tag 18 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:98:dd:d4:fc/00:00:0f:00:00/40 tag 19 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:a8:5d:ce:fc/00:00:0f:00:00/40 tag 21 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:b0:dd:cf:fc/00:00:0f:00:00/40 tag 22 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2.00: cmd 60/80:b8:5d:d1:fc/00:00:0f:00:00/40 tag 23 cdb 0x0 data 65536 in
Apr  1 01:36:53          res 40/00:98:dd:d4:fc/00:00:0f:00:00/40 Emask 0x10 (ATA bus error)
Apr  1 01:36:53 ata2: soft resetting port
Apr  1 01:36:53 ata2: softreset failed (1st FIS failed)
Apr  1 01:36:53 ata2: softreset failed, retrying in 5 secs
Apr  1 01:36:58 ata2: hard resetting port
Apr  1 01:37:06 ata2: port is slow to respond, please be patient (Status 0x80)
Apr  1 01:37:29 ata2: port failed to respond (30 secs, Status 0x80)
Apr  1 01:37:29 ata2: COMRESET failed (device not ready)
Apr  1 01:37:29 ata2: hardreset failed, retrying in 5 secs
Apr  1 01:37:34 ata2: hard resetting port
Apr  1 01:37:34 ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  1 01:37:34 ata2.00: configured for UDMA/133
Apr  1 01:37:34 ata2: EH complete
Apr  1 01:37:34 SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
Apr  1 01:37:34 sdb: Write Protect is off
Apr  1 01:37:34 sdb: Mode Sense: 00 3a 00 00
Apr  1 01:37:34 SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

...big skip, up to PIO0 mode...
Apr  1 04:48:12 ata2.00: configured for PIO0
Apr  1 04:48:12 sd 1:0:0:0: SCSI error: return code = 0x08000002
Apr  1 04:48:12 sdb: Current [descriptor]: sense key: Aborted Command
Apr  1 04:48:12     Additional sense: No additional sense information
Apr  1 04:48:12 Descriptor sense data with sense descriptors (in hex):
Apr  1 04:48:12         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
Apr  1 04:48:12         10 26 0c 5d
Apr  1 04:48:12 end_request: I/O error, dev sdb, sector 270927709
Apr  1 04:48:12 ata2: EH complete
Apr  1 04:48:12 ata2.00: speed down requested but no transfer mode left
Apr  1 04:48:12 ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Apr  1 04:48:12 ata2.00: cmd 24/00:80:dd:06:26/00:00:10:00:00/e0 tag 0 cdb 0x0 data 65536 in
Apr  1 04:48:12          res 40/00:48:5d:0c:26/00:00:10:00:00/40 Emask 0x4 (timeout)
Apr  1 04:48:12 ata2: soft resetting port
Apr  1 04:48:12 ata2: softreset failed (port busy but CLO unavailable)
Apr  1 04:48:12 ata2: softreset failed, retrying in 5 secs
Apr  1 04:48:12 ata2: hard resetting port
Apr  1 04:48:12 ata2: port is slow to respond, please be patient (Status 0x80)
Apr  1 04:48:12 ata2: port failed to respond (30 secs, Status 0x80)
Apr  1 04:48:12 ata2: COMRESET failed (device not ready)
Apr  1 04:48:12 ata2: hardreset failed, retrying in 5 secs
Apr  1 04:48:12 ata2: hard resetting port
Apr  1 04:48:12 ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  1 04:48:12 ata2.00: configured for PIO0
Apr  1 04:48:12 ata2: EH complete
Apr  1 04:48:12 ata2.00: speed down requested but no transfer mode left
Apr  1 04:48:12 ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
Apr  1 04:48:12 ata2.00: cmd 24/00:80:dd:06:26/00:00:10:00:00/e0 tag 0 cdb 0x0 data 65536 in
Apr  1 04:48:12          res 40/00:48:5d:0c:26/00:00:10:00:00/40 Emask 0x4 (timeout)
Apr  1 04:48:12 ata2: soft resetting port
Apr  1 04:48:12 ata2: softreset failed (port busy but CLO unavailable)
Apr  1 04:48:12 ata2: softreset failed, retrying in 5 secs
Apr  1 04:48:12 ata2: hard resetting port
Apr  1 04:48:12 ata2: port is slow to respond, please be patient (Status 0x80)
Apr  1 04:48:12 ata2: port failed to respond (30 secs, Status 0x80)
Apr  1 04:48:12 ata2: COMRESET failed (device not ready)
Apr  1 04:48:12 ata2: hardreset failed, retrying in 5 secs
Apr  1 04:48:12 ata2: hard resetting port
Apr  1 04:48:12 ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  1 04:48:12 ata2.00: configured for PIO0
Apr  1 04:48:12 ata2: EH complete
...

and so on, and so on.  The disk does not work anymore, every attempt to access it
produces a bunch of messages like the above.

Complete kernel log is at http://www.corpit.ru/mjt/kernlog-sata-failures.txt

System information
(http://www.intel.com/support/motherboards/server/s5000pal/index.htm):

00:00.0 Host bridge: Intel Corporation 5000P Chipset Memory Controller Hub (rev 93)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 Port 2-3 (rev 93)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 3 (rev 93)
00:04.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 4 (rev 93)
00:05.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 5 (rev 93)
00:06.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 6 (rev 93)
00:07.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 Port 7 (rev 93)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA Engine (rev 93)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev 93)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev 93)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset Error Reporting Registers (rev 93)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev 93)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved Registers (rev 93)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev 93)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers (rev 93)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC Interface Controller (rev 09)
00:1f.1 IDE interface: Intel Corporation 631xESB/632xESB IDE Controller (rev 09)
00:1f.2 SATA controller: Intel Corporation 631xESB/632xESB SATA Storage Controller AHCI (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E1 (rev 01)
02:01.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E2 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express Downstream Port E3 (rev 01)
05:00.0 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN Controller Copper (rev 01)
05:00.1 Ethernet controller: Intel Corporation 631xESB/632xESB DPT LAN Controller Copper (rev 01)
0c:0c.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)

(lspci -vx is at http://www.corpit.ru/mjt/lspci-sata-failures.txt)

The disks are:
Seagate Barracuda 7200.10 family  Model ST3250620AS, FW 3.AAJ,
250,059,350,016 bytes

Module used for the controller is ahci.  Kernel is vanilla 2.6.20.3,
x86-64.  The same happed with 2.6.19 (probably compiled for i686,
but I'm not entierly sure about this).  The disk comes back just
fine after power-cycling the machine.

The problematic thing is that the issue happens only after quite
some uptime, and without any load at all (maybe just cron scanning
some stuff and updating atime, I dunno), so it's difficult to say
if it's possible to trigger it somehow.  Another complication is
that after a drive has been dead like this, the system does not
work anymore (I can't log in) - it's just a chance it seems that
logs are here in /var/log.

Any guess where the problem is?  Is it disk (which - the same -
failed two times already), or controller, or driver?

Thanks!

/mjt
