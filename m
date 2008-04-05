From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 10396] BUG: soft lockup - CPU#0 stuck for 61s! [modprobe:2096]
Date: Sat,  5 Apr 2008 10:10:02 -0700 (PDT)
Message-ID: <20080405171002.15F29108060@picon.linux-foundation.org>
References: <bug-10396-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528AbYDERKf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Apr 2008 13:10:35 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m35HA2tN014635
	for <linux-scsi@vger.kernel.org>; Sat, 5 Apr 2008 10:10:03 -0700
In-Reply-To: <bug-10396-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=10396





------- Comment #6 from linux@tjworld.net  2008-04-05 10:10 -------
v2.6.25-rc8 with "pci=noacpi"

Output of Perl script dump_pirq

$ wget http://linux.dell.com/files/tools/dump_pirq
$ chmod 755 dump_pirq
$ sudo ./dump_pirq

Interrupt routing table found at address 0xfc7a0:
  Version 1.0, size 0x00d0
  Interrupt router is device 00:02.0
  PCI exclusive interrupt mask: 0x0000 []
  Compatible router: vendor 0x8086 device 0x122e

Device 00:02.0 (slot 0): 
  INTA: link 0x64, irq mask 0x4000 [14]
  INTB: link 0x65, irq mask 0x8000 [15]
  INTD: link 0x63, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 02:04.0 (slot 0): 
  INTA: link 0x65, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 02:06.0 (slot 0): 
  INTA: link 0x66, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 02:08.0 (slot 0): 
  INTA: link 0x64, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 00:06.0 (slot 1): 
  INTA: link 0x69, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTB: link 0x64, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTC: link 0x67, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTD: link 0x68, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 00:08.0 (slot 2): 
  INTA: link 0x68, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTB: link 0x69, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTC: link 0x64, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTD: link 0x67, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 00:0a.0 (slot 3): 
  INTA: link 0x67, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTB: link 0x68, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTC: link 0x69, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTD: link 0x64, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 03:01.0 (slot 4): 
  INTA: link 0x63, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTB: link 0x60, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTC: link 0x61, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTD: link 0x62, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 03:03.0 (slot 5): 
  INTA: link 0x62, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTB: link 0x63, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTC: link 0x60, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTD: link 0x61, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 03:05.0 (slot 6): 
  INTA: link 0x61, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTB: link 0x62, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTC: link 0x63, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTD: link 0x60, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Device 03:07.0 (slot 7): 
  INTA: link 0x60, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTB: link 0x61, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTC: link 0x62, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]
  INTD: link 0x63, irq mask 0x5cf8 [3,4,5,6,7,10,11,12,14]

Interrupt router at 00:02.0: Intel 82371AB PIIX4/PIIX4E PCI-to-ISA bridge
  PIRQ1 (link 0x60): unrouted
  PIRQ2 (link 0x61): unrouted
  PIRQ3 (link 0x62): irq 5
  PIRQ4 (link 0x63): unrouted
  Serial IRQ: [disabled] [quiet] [frame=21] [pulse=4]
  Level mask: 0x4e20 [5,9,10,11,14]

$ cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  0:        178          0          0          0   IO-APIC-edge      timer
  1:         33          0          2          1   IO-APIC-edge      i8042
  2:          0          0          0          0    XT-PIC-XT        cascade
  4:        235          0          1          0   IO-APIC-edge      serial
  6:          2          1          0          0   IO-APIC-edge      floppy
  7:          0          0          0          0   IO-APIC-edge      parport0
  8:          3          0          0          0   IO-APIC-edge      rtc
  9:          0          0          0          0   IO-APIC-edge      acpi
 11:       1938          1          0          0   IO-APIC-fasteoi   eth0
 12:        104          0          0          1   IO-APIC-edge      i8042
 14:        105          0          1          0   IO-APIC-fasteoi   ata_piix,
aic7xxx
 15:          0          0          0          0   IO-APIC-edge      ata_piix
 18:       2390          1          0          0   IO-APIC-fasteoi   aacraid
 20:        228          1          0          0   IO-APIC-fasteoi   aic7xxx
 21:         14          1          0          0   IO-APIC-fasteoi   aic7xxx
 22:         14          0          1          0   IO-APIC-fasteoi   aic7xxx
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      19217       8829      11373       6098   Local timer interrupts
RES:       3614       4379       3396       2418   Rescheduling interrupts
CAL:         88        203        209        220   function call interrupts
TLB:       1076       1121       1100        599   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          0
MIS:          0


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
