From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4039] New: 3w-9xxx constant time-outs/reset
 (forever)
Date: Thu, 13 Jan 2005 19:45:20 -0800
Message-ID: <20050113194520.5280395a.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:34509 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261890AbVANDpn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 22:45:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: davidm@obsidian.com.au



Begin forwarded message:

Date: Thu, 13 Jan 2005 19:38:47 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4039] New: 3w-9xxx constant time-outs/reset (forever)


http://bugme.osdl.org/show_bug.cgi?id=4039

           Summary: 3w-9xxx constant time-outs/reset (forever)
    Kernel Version: 2.6.10
            Status: NEW
          Severity: normal
             Owner: andmike@us.ibm.com
         Submitter: davidm@obsidian.com.au


Distribution: Debian unstable
Hardware Environment: P4 3.2Ghz, Tyan Tomcat i7210, 3Ware-9500-12 in 66Mhz/64bit
PCI-X slot. 7 x 200Gb SATA drives

lspci 
0000:00:00.0 Host bridge: Intel Corp. 82875P Memory Controller Hub (rev 02)
0000:00:03.0 PCI bridge: Intel Corp. 82875P Processor to PCI to CSA Bridge (rev 02)
0000:00:1c.0 PCI bridge: Intel Corp. 6300ESB 64-bit PCI-X Bridge (rev 02)
0000:00:1d.0 USB Controller: Intel Corp. 6300ESB USB Universal Host Controller
(rev 02)
0000:00:1d.1 USB Controller: Intel Corp. 6300ESB USB Universal Host Controller
(rev 02)
0000:00:1d.4 System peripheral: Intel Corp. 6300ESB Watchdog Timer (rev 02)
0000:00:1d.5 PIC: Intel Corp. 6300ESB I/O Advanced Programmable Interrupt
Controller (rev 02)
0000:00:1d.7 USB Controller: Intel Corp. 6300ESB USB2 Enhanced Host Controller
(rev 02)
0000:00:1e.0 PCI bridge: Intel Corp. 82801 PCI Bridge (rev 0a)
0000:00:1f.0 ISA bridge: Intel Corp. 6300ESB LPC Interface Controller (rev 02)
0000:00:1f.1 IDE interface: Intel Corp. 6300ESB PATA Storage Controller (rev 02)
0000:00:1f.3 SMBus: Intel Corp. 6300ESB SMBus Controller (rev 02)
0000:01:01.0 Ethernet controller: Intel Corp. 82547GI Gigabit Ethernet Controller
0000:02:06.0 RAID bus controller: 3ware Inc 3ware ATA-RAID
0000:03:01.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
0000:03:03.0 RAID bus controller: Silicon Image, Inc. (formerly CMD Technology
Inc) SiI 3114 [SATALink/SATARaid] Serial ATA Contro)0000:03:06.0 Ethernet
controller: Realtek Semiconductor Co., Ltd. RTL-8169 Gigabit Ethernet (rev 10)


Software Environment: Vanilla kernel source tree (not Debian patched)
Problem Description: On boot, I get the following messages

3ware 9000 Storage Controller device driver for Linux v2.26.02.001.
PCI: Found IRQ 12 for device 0000:02:06.0
IRQ routing conflict for 0000:02:06.0, have irq 9, want irq 12
scsi0 : 3ware 9000 Storage Controller
3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xf6800000, IRQ: 9.
3w-9xxx: scsi0: Firmware FE9X 2.04.00.005, BIOS BE9X 2.03.01.047, Ports: 12.
3w-9xxx: scsi0: WARNING: (0x06:0x002C): Unit #0: Command (0x12) timed out,
resetting card.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=1.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=2.
3w-9xxx: scsi0: WARNING: (0x06:0x002C): Unit #0: Command (0x0) timed out,
resetting card.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=1.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=2.
3w-9xxx: scsi0: SCSI host reset started.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=1.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=2.
3w-9xxx: scsi0: SCSI host reset succeeded.
3w-9xxx: scsi0: WARNING: (0x06:0x002C): Unit #0: Command (0x0) timed out,
resetting card.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=1.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=2.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
3w-9xxx: scsi0: WARNING: (0x06:0x002C): Unit #1: Command (0x12) timed out,
resetting card.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=1.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=2.
3w-9xxx: scsi0: WARNING: (0x06:0x002C): Unit #1: Command (0x0) timed out,
resetting card.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=1.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=2.
3w-9xxx: scsi0: SCSI host reset started.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=0.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=1.
3w-9xxx: scsi0: AEN: INFO (0x04:0x005E): <NULL>:unit=2.
3w-9xxx: scsi0: SCSI host reset succeeded.

And loops like this forever.

This happens with both the kernel 3w-9xxx module and the one provided by 3Ware.
Only happened after upgrade to 2.6.10 from 2.6.8.1 (although I used 2.6.9 for a
period with none of these issues). 

Same kernel configuration (copied working 2.6.8.1 .config). Reverting to 2.6.8.1
and the problem goes away.

Steps to reproduce:

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
