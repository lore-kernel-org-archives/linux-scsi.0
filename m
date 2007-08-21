From: Marc Bejarano <beej@alum.mit.edu>
Subject: mptscsih: can't re-add offlined device
Date: Tue, 21 Aug 2007 18:20:50 -0400
Message-ID: <200708212220.l7LMKu5r015912@outgoing-alum.mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ALUM-2.MIT.EDU ([18.7.21.145]:62125 "EHLO alum-2.mit.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXHUW2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Aug 2007 18:28:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

one of my 750-gig SATA seagate's in an xTore SAS enclosure hanging 
off a pcie  LSI SAS3801E HBA in a lvm2-based RAID 0 stripe set 
choked.  the drive was offlined.  i was hoping to bring it back 
online so i could check its SMART output, but failed miserably :(

machine is running CentOS 4.4 with kernel 2.6.9-42.0.10.ELsmp

i did:
echo running > /sys/bus/scsi/devices/8\:0\:19\:0/state
to put it back online, but smartctl still couldn't talk to it:
Aug 20 16:14:36 smtest kernel: SCSI error : <8 0 19 0> return code = 0x10000
reseating the drive in the enclosure didn't generate any log info.
swapping the drive with a new one didn't either.
echo "- - -" > /sys/class/scsi_host/host8/scan
didn't do anything noticeable
echo "scsi remove-single-device 8 0 19 0" >/proc/scsi/scsi
worked and removed /dev/sdq and /sys/bus/scsi/devices/8:0:19:0, but
echo "scsi add-single-device 8 0 19 0" >/proc/scsi/scsi
didn't bring either back or generate any errors or log output.

any clues?

here is the snippet from /var/log/messages when the drive was 
originally offlined:
---
Aug 20 05:09:52 smtest kernel: mptbase: ioc0: LogInfo(0x31110900): 
Originator={PL}, Code={Reset}, SubCode(0x0900)
Aug 20 05:09:54 smtest last message repeated 5 times
Aug 20 05:09:57 smtest kernel: mptbase: ioc0: LogInfo(0x31110e00): 
Originator={PL}, Code={Reset}, SubCode(0x0e00)
Aug 20 05:10:02 smtest last message repeated 2 times
Aug 20 05:10:02 smtest kernel: mptbase: ioc0: LogInfo(0x31111000): 
Originator={PL}, Code={Reset}, SubCode(0x1000)
Aug 20 05:10:06 smtest last message repeated 2 times
Aug 20 05:10:06 smtest kernel: mptbase: ioc0: LogInfo(0x31110e00): 
Originator={PL}, Code={Reset}, SubCode(0x0e00)
Aug 20 05:10:11 smtest last message repeated 2 times
Aug 20 05:10:41 smtest kernel: mptscsi: ioc0: attempting task abort! 
(sc=00000100c14f66c0)
Aug 20 05:10:41 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:10:41 smtest kernel:         command = Write (10) 00 3d 2b 
be df 00 02 e0 00
Aug 20 05:10:43 smtest kernel: mptscsi: ioc0: task abort: SUCCESS 
(sc=00000100c14f66c0)
Aug 20 05:10:53 smtest kernel: mptscsi: ioc0: attempting task abort! 
(sc=00000100c14f66c0)
Aug 20 05:10:53 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:10:53 smtest kernel:         command = Test Unit Ready 00 00 00 00 00
Aug 20 05:10:54 smtest kernel: mptbase: ioc0: LogInfo(0x31130000): 
Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Aug 20 05:10:54 smtest kernel: mptscsi: ioc0: task abort: SUCCESS 
(sc=00000100c14f66c0)
Aug 20 05:11:04 smtest kernel: mptscsi: ioc0: attempting task abort! 
(sc=000001012b46cb80)
Aug 20 05:11:04 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:11:04 smtest kernel:         command = Test Unit Ready 00 00 00 00 00
Aug 20 05:11:06 smtest kernel: mptbase: ioc0: LogInfo(0x31130000): 
Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Aug 20 05:11:06 smtest kernel: mptscsi: ioc0: task abort: SUCCESS 
(sc=000001012b46cb80)
Aug 20 05:11:16 smtest kernel: mptscsi: ioc0: attempting task abort! 
(sc=000001009db4d440)
Aug 20 05:11:16 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:11:16 smtest kernel:         command = Test Unit Ready 00 00 00 00 00
Aug 20 05:11:17 smtest kernel: mptbase: ioc0: LogInfo(0x31130000): 
Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Aug 20 05:11:18 smtest kernel: mptscsi: ioc0: task abort: SUCCESS 
(sc=000001009db4d440)
Aug 20 05:11:18 smtest kernel: mptscsi: ioc0: attempting target 
reset! (sc=00000100c14f66c0)
Aug 20 05:11:18 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:11:18 smtest kernel:         command = Write (10) 00 3d 2b 
be df 00 02 e0 00
Aug 20 05:11:19 smtest kernel: mptscsi: ioc0: target reset: SUCCESS 
(sc=00000100c14f66c0)
Aug 20 05:11:29 smtest kernel: mptscsi: ioc0: attempting task abort! 
(sc=00000100c14f66c0)
Aug 20 05:11:29 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:11:29 smtest kernel:         command = Test Unit Ready 00 00 00 00 00
Aug 20 05:11:31 smtest kernel: mptscsi: ioc0: task abort: SUCCESS 
(sc=00000100c14f66c0)
Aug 20 05:11:31 smtest kernel: mptscsi: ioc0: attempting bus reset! 
(sc=00000100c14f66c0)
Aug 20 05:11:31 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:11:31 smtest kernel:         command = Write (10) 00 3d 2b 
be df 00 02 e0 00
Aug 20 05:11:36 smtest kernel: mptscsi: ioc0: bus reset: SUCCESS 
(sc=00000100c14f66c0)
Aug 20 05:11:56 smtest kernel: mptscsi: ioc0: attempting task abort! 
(sc=00000100c14f66c0)
Aug 20 05:11:56 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:11:56 smtest kernel:         command = Test Unit Ready 00 00 00 00 00
Aug 20 05:11:58 smtest kernel: mptbase: ioc0: LogInfo(0x31130000): 
Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Aug 20 05:11:58 smtest kernel: mptscsi: ioc0: task abort: SUCCESS 
(sc=00000100c14f66c0)
Aug 20 05:12:08 smtest kernel: mptscsi: ioc0: attempting task abort! 
(sc=000001012b46cb80)
Aug 20 05:12:08 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:12:08 smtest kernel:         command = Test Unit Ready 00 00 00 00 00
Aug 20 05:12:09 smtest kernel: mptbase: ioc0: LogInfo(0x31130000): 
Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Aug 20 05:12:09 smtest kernel: mptscsi: ioc0: task abort: SUCCESS 
(sc=000001012b46cb80)
Aug 20 05:12:19 smtest kernel: mptscsi: ioc0: attempting task abort! 
(sc=000001009db4d440)
Aug 20 05:12:19 smtest kernel: scsi8 : destination target 19, lun 0
Aug 20 05:12:19 smtest kernel:         command = Test Unit Ready 00 00 00 00 00
Aug 20 05:12:21 smtest kernel: mptbase: ioc0: LogInfo(0x31130000): 
Originator={PL}, Code={IO Not Yet Executed}, SubCode(0x0000)
Aug 20 05:12:21 smtest kernel: mptscsi: ioc0: task abort: SUCCESS 
(sc=000001009db4d440)
Aug 20 05:12:21 smtest kernel: mptscsi: ioc0: Attempting host reset! 
(sc=00000100c14f66c0)
Aug 20 05:12:21 smtest kernel: mptbase: Initiating ioc0 recovery
Aug 20 05:12:54 smtest kernel: scsi: Device offlined - not ready 
after error recovery: host 8 channel 0 id 19 lun 0
Aug 20 05:12:54 smtest last message repeated 2 times
Aug 20 05:12:54 smtest kernel: SCSI error : <8 0 19 0> return code = 0x10000
Aug 20 05:12:54 smtest kernel: end_request: I/O error, dev sdq, 
sector 1026277087
Aug 20 05:12:54 smtest kernel: scsi8 (19:0): rejecting I/O to offline device
Aug 20 05:12:54 smtest kernel: SCSI error : <8 0 19 0> return code = 0x10000
Aug 20 05:12:54 smtest kernel: end_request: I/O error, dev sdq, 
sector 1026278847
Aug 20 05:12:54 smtest kernel: scsi8 (19:0): rejecting I/O to offline device
Aug 20 05:12:54 smtest kernel: SCSI error : <8 0 19 0> return code = 0x10000
Aug 20 05:12:54 smtest kernel: end_request: I/O error, dev sdq, 
sector 1026277823
Aug 20 05:12:54 smtest kernel: scsi8 (19:0): rejecting I/O to offline device
Aug 20 05:13:27 smtest kernel: scsi8 (19:0): rejecting I/O to offline device
Aug 20 05:13:27 smtest kernel: Buffer I/O error on device dm-9, 
logical block 588748743
Aug 20 05:13:27 smtest kernel: lost page write due to I/O error on dm-9
Aug 20 05:13:32 smtest kernel: scsi8 (19:0): rejecting I/O to offline device
Aug 20 05:13:32 smtest kernel: Buffer I/O error on device dm-9, 
logical block 587954137
Aug 20 05:13:32 smtest kernel: lost page write due to I/O error on dm-9
---

and here is the meat from the boot:
---
Aug  8 22:53:30 smtest syslogd 1.4.1: restart.
Aug  8 22:53:31 smtest syslog: syslogd startup succeeded
Aug  8 22:53:31 smtest kernel: klogd 1.4.1, log source = /proc/kmsg started.
Aug  8 22:53:31 smtest kernel: Bootdata ok (command line is ro 
root=/dev/VolGroup00/LogVol00 rhgb quiet)
Aug  8 22:53:31 smtest kernel: Linux version 2.6.9-42.0.10.ELsmp 
(mockbuild@builder5.centos.org) (gcc version 3.4.6 20060404 (Red Hat 
3.4.6-3)) #1 SMP Tue Feb 27 09:40:21 EST 2007
Aug  8 22:53:31 smtest kernel: BIOS-provided physical RAM map:
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 0000000000000000 - 
000000000009bc00 (usable)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 000000000009bc00 - 
00000000000a0000 (reserved)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000000cc000 - 
00000000000d4000 (reserved)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000000e4000 - 
0000000000100000 (reserved)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 0000000000100000 - 
00000000cff60000 (usable)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000cff60000 - 
00000000cff69000 (ACPI data)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000cff69000 - 
00000000cff80000 (ACPI NVS)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000cff80000 - 
00000000d0000000 (reserved)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000e0000000 - 
00000000f0000000 (reserved)
Aug  8 22:53:31 smtest syslog: klogd startup succeeded
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000fec00000 - 
00000000fec10000 (reserved)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000fee00000 - 
00000000fee01000 (reserved)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 00000000ff000000 - 
0000000100000000 (reserved)
Aug  8 22:53:31 smtest kernel:  BIOS-e820: 0000000100000000 - 
0000000830000000 (usable)
Aug  8 22:53:31 smtest irqbalance: irqbalance startup succeeded
Aug  8 22:53:31 smtest portmap: portmap startup succeeded
Aug  8 22:53:31 smtest kernel: No NUMA configuration found
Aug  8 22:53:31 smtest kernel: Faking a node at 
0000000000000000-0000000830000000
Aug  8 22:53:31 smtest kernel: Bootmem setup node 0 
0000000000000000-0000000830000000
Aug  8 22:53:31 smtest kernel: No mptable found.
Aug  8 22:53:31 smtest kernel: DMI present.
Aug  8 22:53:31 smtest kernel: ACPI: PM-Timer IO Port: 0x1008
Aug  8 22:53:31 smtest kernel: ACPI: LAPIC (acpi_id[0x00] 
lapic_id[0x00] enabled)
Aug  8 22:53:31 smtest kernel: Processor #0 6:15 APIC version 16
Aug  8 22:53:31 smtest kernel: ACPI: LAPIC (acpi_id[0x01] 
lapic_id[0x01] enabled)
Aug  8 22:53:31 smtest rpc.statd[7271]: Version 1.0.6 Starting
Aug  8 22:53:31 smtest kernel: Processor #1 6:15 APIC version 16
Aug  8 22:53:31 smtest kernel: ACPI: LAPIC (acpi_id[0x02] 
lapic_id[0x02] enabled)
Aug  8 22:53:31 smtest kernel: Processor #2 6:15 APIC version 16
Aug  8 22:53:31 smtest kernel: ACPI: LAPIC (acpi_id[0x03] 
lapic_id[0x03] enabled)
Aug  8 22:53:31 smtest kernel: Processor #3 6:15 APIC version 16
Aug  8 22:53:31 smtest kernel: ACPI: LAPIC_NMI (acpi_id[0x00] high 
edge lint[0x1])
Aug  8 22:53:31 smtest kernel: ACPI: LAPIC_NMI (acpi_id[0x01] high 
edge lint[0x1])
Aug  8 22:53:31 smtest kernel: ACPI: LAPIC_NMI (acpi_id[0x02] high 
edge lint[0x1])
Aug  8 22:53:31 smtest kernel: ACPI: LAPIC_NMI (acpi_id[0x03] high 
edge lint[0x1])
Aug  8 22:53:31 smtest rpc.statd[7271]: statd running as root. chown 
/var/lib/nfs/statd/sm to choose different user
Aug  8 22:53:31 smtest kernel: Setting APIC routing to flat
Aug  8 22:53:31 smtest nfslock: rpc.statd startup succeeded
Aug  8 22:53:31 smtest kernel: ACPI: IOAPIC (id[0x04] 
address[0xfec00000] gsi_base[0])
Aug  8 22:53:31 smtest kernel: IOAPIC[0]: apic_id 4, version 32, 
address 0xfec00000, GSI 0-23
Aug  8 22:53:31 smtest kernel: ACPI: IOAPIC (id[0x05] 
address[0xfec80000] gsi_base[24])
Aug  8 22:53:31 smtest kernel: IOAPIC[1]: apic_id 5, version 32, 
address 0xfec80000, GSI 24-47
Aug  8 22:53:31 smtest kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 
global_irq 2 high edge)
Aug  8 22:53:31 smtest kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 
global_irq 9 high level)
Aug  8 22:53:31 smtest kernel: Using ACPI (MADT) for SMP 
configuration information
Aug  8 22:53:31 smtest kernel: Allocating PCI resources starting at 
d1000000 (gap: d0000000:10000000)
Aug  8 22:53:31 smtest kernel: Checking aperture...
Aug  8 22:53:31 smtest kernel: Built 1 zonelists
Aug  8 22:53:31 smtest kernel: Kernel command line: ro 
root=/dev/VolGroup00/LogVol00 rhgb quiet console=tty0
Aug  8 22:53:31 smtest kernel: Initializing CPU#0
Aug  8 22:53:31 smtest kernel: PID hash table entries: 4096 (order: 
12, 131072 bytes)
Aug  8 22:53:31 smtest kernel: time.c: Using 3.579545 MHz PM timer.
Aug  8 22:53:31 smtest kernel: time.c: Detected 2666.741 MHz processor.
Aug  8 22:53:31 smtest kernel: Console: colour VGA+ 80x25
Aug  8 22:53:31 smtest kernel: Dentry cache hash table entries: 
8388608 (order: 14, 67108864 bytes)
Aug  8 22:53:31 smtest kernel: Inode-cache hash table entries: 
4194304 (order: 13, 33554432 bytes)
Aug  8 22:53:31 smtest kernel: Placing software IO TLB between 
0x7183000 - 0xb183000
Aug  8 22:53:31 smtest kernel: Memory: 32911580k/34340864k available 
(2106k kernel code, 0k reserved, 1299k data, 196k init)
Aug  8 22:53:31 smtest kernel: Calibrating delay using timer specific 
routine.. 5339.11 BogoMIPS (lpj=2669556)
Aug  8 22:53:31 smtest kernel: Security Scaffold v1.0.0 initialized
Aug  8 22:53:31 smtest kernel: SELinux:  Initializing.
Aug  8 22:53:31 smtest kernel: SELinux:  Starting in permissive mode
Aug  8 22:53:31 smtest kernel: There is already a security framework 
initialized, register_security failed.
Aug  8 22:53:31 smtest kernel: 
selinux_register_security:  Registering secondary module capability
Aug  8 22:53:31 smtest kernel: Capability LSM initialized as secondary
Aug  8 22:53:31 smtest kernel: Mount-cache hash table entries: 256 
(order: 0, 4096 bytes)
Aug  8 22:53:31 smtest kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Aug  8 22:53:31 smtest kernel: CPU: L2 cache: 4096K
Aug  8 22:53:31 smtest rpcidmapd: rpc.idmapd startup succeeded
Aug  8 22:53:31 smtest kernel: using mwait in idle threads.
Aug  8 22:53:31 smtest kernel: CPU0: Physical Processor ID: 0
Aug  8 22:53:31 smtest kernel: CPU0: Processor Core ID: 0
Aug  8 22:53:31 smtest kernel: CPU0: Initial APIC ID: 0
Aug  8 22:53:31 smtest kernel: Using IO APIC NMI watchdog
Aug  8 22:53:31 smtest kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Aug  8 22:53:31 smtest kernel: CPU: L2 cache: 4096K
Aug  8 22:53:31 smtest kernel: CPU0: Physical Processor ID: 0
Aug  8 22:53:31 smtest kernel: CPU0: Processor Core ID: 0
Aug  8 22:53:31 smtest kernel: CPU0: Initial APIC ID: 0
Aug  8 22:53:31 smtest kernel: CPU0: Intel(R) Xeon(R) 
CPU           X5355  @ 2.66GHz stepping 07
Aug  8 22:53:31 smtest kernel: per-CPU timeslice cutoff: 874.73 usecs.
Aug  8 22:53:31 smtest kernel: task migration cache decay timeout: 1 msecs.
Aug  8 22:53:31 smtest kernel: Booting processor 1/1 rip 6000 rsp 10813505f58
Aug  8 22:53:31 smtest kernel: Initializing CPU#1
Aug  8 22:53:31 smtest kernel: Calibrating delay using timer specific 
routine.. 5332.59 BogoMIPS (lpj=2666295)
Aug  8 22:53:31 smtest kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Aug  8 22:53:31 smtest kernel: CPU: L2 cache: 4096K
Aug  8 22:53:31 smtest kernel: CPU1: Physical Processor ID: 0
Aug  8 22:53:31 smtest kernel: CPU1: Processor Core ID: 1
Aug  8 22:53:31 smtest kernel: CPU1: Initial APIC ID: 1
Aug  8 22:53:31 smtest kernel: Intel(R) Xeon(R) 
CPU           X5355  @ 2.66GHz stepping 07
Aug  8 22:53:31 smtest kernel: Booting processor 2/2 rip 6000 rsp 1081353df58
Aug  8 22:53:31 smtest kernel: Initializing CPU#2
Aug  8 22:53:31 smtest kernel: Calibrating delay using timer specific 
routine.. 5332.61 BogoMIPS (lpj=2666305)
Aug  8 22:53:31 smtest kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Aug  8 22:53:31 smtest kernel: CPU: L2 cache: 4096K
Aug  8 22:53:31 smtest kernel: CPU2: Physical Processor ID: 0
Aug  8 22:53:31 smtest kernel: CPU2: Processor Core ID: 2
Aug  8 22:53:31 smtest kernel: CPU2: Initial APIC ID: 2
Aug  8 22:53:31 smtest kernel: Intel(R) Xeon(R) 
CPU           X5355  @ 2.66GHz stepping 07
Aug  8 22:53:31 smtest kernel: Booting processor 3/3 rip 6000 rsp 10813573f58
Aug  8 22:53:31 smtest kernel: Initializing CPU#3
Aug  8 22:53:31 smtest kernel: Calibrating delay using timer specific 
routine.. 5332.65 BogoMIPS (lpj=2666327)
Aug  8 22:53:31 smtest kernel: CPU: L1 I cache: 32K, L1 D cache: 32K
Aug  8 22:53:31 smtest kernel: CPU: L2 cache: 4096K
Aug  8 22:53:31 smtest kernel: CPU3: Physical Processor ID: 0
Aug  8 22:53:31 smtest kernel: CPU3: Processor Core ID: 3
Aug  8 22:53:31 smtest kernel: CPU3: Initial APIC ID: 3
Aug  8 22:53:31 smtest kernel: Intel(R) Xeon(R) 
CPU           X5355  @ 2.66GHz stepping 07
Aug  8 22:53:31 smtest kernel: Total of 4 processors activated 
(21336.96 BogoMIPS).
Aug  8 22:53:31 smtest kernel: activating NMI Watchdog ... done.
Aug  8 22:53:31 smtest kernel: testing NMI watchdog ... OK.
Aug  8 22:53:31 smtest kernel: Using local APIC timer interrupts.
Aug  8 22:53:31 smtest kernel: Detected 20.833 MHz APIC timer.
Aug  8 22:53:31 smtest kernel: checking TSC synchronization across 4 
CPUs: passed.
Aug  8 22:53:31 smtest kernel: Brought up 4 CPUs
Aug  8 22:53:31 smtest kernel: time.c: Using PIT/TSC based timekeeping.
Aug  8 22:53:31 smtest kernel: checking if image is initramfs... it is
Aug  8 22:53:31 smtest kernel: NET: Registered protocol family 16
Aug  8 22:53:31 smtest kernel: PCI: Using configuration type 1
Aug  8 22:53:31 smtest kernel: PCI: Using MMCONFIG at e0000000
Aug  8 22:53:31 smtest kernel: mtrr: v2.0 (20020519)
Aug  8 22:53:31 smtest kernel: ACPI: Subsystem revision 20040816
Aug  8 22:53:31 smtest kernel: ACPI: Interpreter enabled
Aug  8 22:53:31 smtest kernel: ACPI: Using IOAPIC for interrupt routing
Aug  8 22:53:31 smtest kernel: ACPI: PCI Root Bridge [PCI0] (00:00)
Aug  8 22:53:31 smtest kernel: PCI: Probing PCI hardware (bus 00)
Aug  8 22:53:31 smtest kernel: PCI: Ignoring BAR0-3 of IDE controller 
0000:00:1f.1
Aug  8 22:53:31 smtest kernel: PCI: Transparent bridge - 0000:00:1e.0
Aug  8 22:53:31 smtest kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 
3 4 5 6 7 10 11 14 15) *9
Aug  8 22:53:31 smtest kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 
3 4 *5 6 7 10 11 14 15)
Aug  8 22:53:31 smtest kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 
3 4 5 6 7 10 *11 14 15)
Aug  8 22:53:31 smtest kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 
3 4 5 6 7 *10 11 14 15)
Aug  8 22:53:31 smtest kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 
3 4 5 6 7 10 11 14 15) *0, disabled.
Aug  8 22:53:31 smtest kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 
4 5 6 7 10 11 14 15) *0, disabled.
Aug  8 22:53:31 smtest kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 
3 4 5 6 7 10 11 14 15) *0, disabled.
Aug  8 22:53:31 smtest kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 
4 5 6 7 10 11 14 15) *0, disabled.
Aug  8 22:53:31 smtest kernel: usbcore: registered new driver usbfs
Aug  8 22:53:31 smtest kernel: usbcore: registered new driver hub
Aug  8 22:53:31 smtest kernel: PCI: Using ACPI for IRQ routing
Aug  8 22:53:31 smtest kernel: GSI 16 sharing vector 0xA9 and IRQ 16
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:00.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:02.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:04.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:06.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:08.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: GSI 17 sharing vector 0xB1 and IRQ 17
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1c.0[A] -> 
GSI 17 (level, low) -> IRQ 177
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1d.0[A] -> 
GSI 17 (level, low) -> IRQ 177
Aug  8 22:53:31 smtest kernel: GSI 18 sharing vector 0xB9 and IRQ 18
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1d.1[B] -> 
GSI 19 (level, low) -> IRQ 185
Aug  8 22:53:31 smtest kernel: GSI 19 sharing vector 0xC1 and IRQ 19
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1d.2[C] -> 
GSI 18 (level, low) -> IRQ 193
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1d.7[A] -> 
GSI 17 (level, low) -> IRQ 177
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1f.1[A] -> 
GSI 18 (level, low) -> IRQ 193
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1f.2[B] -> 
GSI 19 (level, low) -> IRQ 185
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1f.3[B] -> 
GSI 19 (level, low) -> IRQ 185
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:01:00.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:02:00.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:02:02.0[A] -> 
GSI 18 (level, low) -> IRQ 193
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:05:01.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:06:00.0[A] -> 
GSI 18 (level, low) -> IRQ 193
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:06:00.1[B] -> 
GSI 19 (level, low) -> IRQ 185
Aug  8 22:53:31 smtest kernel: GSI 20 sharing vector 0xC9 and IRQ 20
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:07:01.0[A] -> 
GSI 24 (level, low) -> IRQ 201
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:08:00.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:0b:01.0[A] -> 
GSI 18 (level, low) -> IRQ 193
Aug  8 22:53:31 smtest kernel: PCI: Cannot allocate resource region 0 
of device 0000:00:08.0
Aug  8 22:53:31 smtest kernel: PCI-DMA: Using software bounce 
buffering for IO (SWIOTLB)
Aug  8 22:53:31 smtest kernel: Simple Boot Flag at 0x38 set to 0x1
Aug  8 22:53:31 smtest kernel: IA32 emulation $Id: sys_ia32.c,v 1.32 
2002/03/24 13:02:28 ak Exp $
Aug  8 22:53:31 smtest kernel: audit: initializing netlink socket (disabled)
Aug  8 22:53:31 smtest kernel: audit(1186613526.291:1): initialized
Aug  8 22:53:31 smtest kernel: Total HugeTLB memory allocated, 0
Aug  8 22:53:31 smtest kernel: VFS: Disk quotas dquot_6.5.1
Aug  8 22:53:31 smtest kernel: Dquot-cache hash table entries: 512 
(order 0, 4096 bytes)
Aug  8 22:53:31 smtest kernel: SELinux:  Registering netfilter hooks
Aug  8 22:53:31 smtest kernel: Initializing Cryptographic API
Aug  8 22:53:31 smtest kernel: ksign: Installing public key data
Aug  8 22:53:31 smtest kernel: Loading keyring
Aug  8 22:53:31 smtest kernel: - Added public key F6CD757FDE265743
Aug  8 22:53:31 smtest kernel: - User ID: CentOS (Kernel Module GPG key)
Aug  8 22:53:31 smtest kernel: pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Aug  8 22:53:31 smtest kernel: ACPI: Processor [CPU0] (supports C1, 8 
throttling states)
Aug  8 22:53:31 smtest kernel: ACPI: Processor [CPU1] (supports C1, 8 
throttling states)
Aug  8 22:53:31 smtest kernel: ACPI: Processor [CPU2] (supports C1, 8 
throttling states)
Aug  8 22:53:31 smtest kernel: ACPI: Processor [CPU3] (supports C1, 8 
throttling states)
Aug  8 22:53:31 smtest kernel: Real Time Clock Driver v1.12
Aug  8 22:53:31 smtest kernel: Linux agpgart interface v0.100 (c) Dave Jones
Aug  8 22:53:31 smtest kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Aug  8 22:53:31 smtest kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Aug  8 22:53:31 smtest kernel: Serial: 8250/16550 driver $Revision: 
1.90 $ 8 ports, IRQ sharing enabled
Aug  8 22:53:31 smtest kernel: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Aug  8 22:53:31 smtest kernel: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
Aug  8 22:53:31 smtest kernel: RAMDISK driver initialized: 16 RAM 
disks of 16384K size 1024 blocksize
Aug  8 22:53:31 smtest kernel: Uniform Multi-Platform E-IDE driver 
Revision: 7.00alpha2
Aug  8 22:53:31 smtest kernel: ide: Assuming 33MHz system bus speed 
for PIO modes; override with idebus=xx
Aug  8 22:53:31 smtest kernel: ESB2: IDE controller at PCI slot 0000:00:1f.1
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1f.1[A] -> 
GSI 18 (level, low) -> IRQ 193
Aug  8 22:53:31 smtest kernel: ESB2: chipset revision 9
Aug  8 22:53:31 smtest kernel: ESB2: not 100% native mode: will probe 
irqs later
Aug  8 22:53:31 smtest kernel:     ide0: BM-DMA at 0x1860-0x1867, 
BIOS settings: hda:pio, hdb:pio
Aug  8 22:53:31 smtest kernel: ide-floppy driver 0.99.newide
Aug  8 22:53:31 smtest kernel: usbcore: registered new driver hiddev
Aug  8 22:53:31 smtest kernel: usbcore: registered new driver usbhid
Aug  8 22:53:31 smtest kernel: drivers/usb/input/hid-core.c: v2.0:USB 
HID core driver
Aug  8 22:53:31 smtest kernel: mice: PS/2 mouse device common for all mice
Aug  8 22:53:31 smtest kernel: input: AT Translated Set 2 keyboard on 
isa0060/serio0
Aug  8 22:53:31 smtest kernel: input: PS/2 Generic Mouse on isa0060/serio1
Aug  8 22:53:31 smtest kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, 
MD_SB_DISKS=27
Aug  8 22:53:31 smtest kernel: NET: Registered protocol family 2
Aug  8 22:53:31 smtest kernel: IP route cache hash table entries: 
524288 (order: 10, 4194304 bytes)
Aug  8 22:53:31 smtest kernel: TCP established hash table entries: 
262144 (order: 10, 4194304 bytes)
Aug  8 22:53:31 smtest kernel: TCP bind hash table entries: 262144 
(order: 10, 4194304 bytes)
Aug  8 22:53:31 smtest kernel: TCP: Hash tables configured 
(established 262144 bind 262144)
Aug  8 22:53:31 smtest kernel: Initializing IPsec netlink socket
Aug  8 22:53:31 smtest kernel: NET: Registered protocol family 1
Aug  8 22:53:31 smtest kernel: NET: Registered protocol family 17
Aug  8 22:53:31 smtest kernel: ACPI: (supports S0 S1 S4 S5)
Aug  8 22:53:31 smtest kernel: ACPI wakeup devices:
Aug  8 22:53:31 smtest kernel: PXH0 PXH1 BPD2 BMF3 P0P4 P0P6 PEX0 
USB1 USB2 USB3 EUSB PCIB KBC0 MSE0 COM1 COM2
Aug  8 22:53:31 smtest kernel: Freeing unused kernel memory: 196k freed
Aug  8 22:53:31 smtest kernel: SCSI subsystem initialized
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:00:1f.2[B] -> 
GSI 19 (level, low) -> IRQ 185
Aug  8 22:53:31 smtest kernel: MSI INIT SUCCESS
Aug  8 22:53:31 smtest kernel: ahci 0000:00:1f.2: AHCI 0001.0100 32 
slots 6 ports ? Gbps 0x3f impl SATA mode
Aug  8 22:53:31 smtest kernel: ahci 0000:00:1f.2: flags: 64bit stag led pmp
Aug  8 22:53:31 smtest kernel: ata1: SATA max UDMA/133 cmd 
0xFFFFFF000001C500 ctl 0x0 bmdma 0x0 irq 185
Aug  8 22:53:31 smtest kernel: ata2: SATA max UDMA/133 cmd 
0xFFFFFF000001C580 ctl 0x0 bmdma 0x0 irq 185
Aug  8 22:53:31 smtest kernel: ata3: SATA max UDMA/133 cmd 
0xFFFFFF000001C600 ctl 0x0 bmdma 0x0 irq 185
Aug  8 22:53:31 smtest kernel: ata4: SATA max UDMA/133 cmd 
0xFFFFFF000001C680 ctl 0x0 bmdma 0x0 irq 185
Aug  8 22:53:31 smtest kernel: ata5: SATA max UDMA/133 cmd 
0xFFFFFF000001C700 ctl 0x0 bmdma 0x0 irq 185
Aug  8 22:53:31 smtest kernel: ata6: SATA max UDMA/133 cmd 
0xFFFFFF000001C780 ctl 0x0 bmdma 0x0 irq 185
Aug  8 22:53:31 smtest kernel: ata1: SATA link up 3.0 Gbps (SStatus 123)
Aug  8 22:53:31 smtest kernel: ata1: dev 0 ATA-7, max UDMA/133, 
625142448 sectors: LBA48
Aug  8 22:53:31 smtest kernel: ata1: dev 0 configured for UDMA/133
Aug  8 22:53:31 smtest kernel: scsi0 : ahci
Aug  8 22:53:31 smtest kernel: ata2: SATA link up 1.5 Gbps (SStatus 113)
Aug  8 22:53:31 smtest kernel: ata2: dev 0 ATA-7, max UDMA/133, 
625142448 sectors: LBA48
Aug  8 22:53:31 smtest kernel: ata2: dev 0 configured for UDMA/133
Aug  8 22:53:31 smtest kernel: scsi1 : ahci
Aug  8 22:53:31 smtest kernel: ata3: SATA link up 1.5 Gbps (SStatus 113)
Aug  8 22:53:31 smtest kernel: ata3: dev 0 ATA-7, max UDMA/133, 
625142448 sectors: LBA48
Aug  8 22:53:31 smtest kernel: ata3: dev 0 configured for UDMA/133
Aug  8 22:53:31 smtest kernel: scsi2 : ahci
Aug  8 22:53:31 smtest kernel: ata4: SATA link up 1.5 Gbps (SStatus 113)
Aug  8 22:53:31 smtest kernel: ata4: dev 0 ATA-7, max UDMA/133, 
625142448 sectors: LBA48
Aug  8 22:53:31 smtest kernel: ata4: dev 0 configured for UDMA/133
Aug  8 22:53:31 smtest kernel: scsi3 : ahci
Aug  8 22:53:31 smtest kernel: ata5: SATA link up 1.5 Gbps (SStatus 113)
Aug  8 22:53:31 smtest kernel: ata5: dev 0 ATA-7, max UDMA/133, 
625142448 sectors: LBA48
Aug  8 22:53:31 smtest kernel: ata5: dev 0 configured for UDMA/133
Aug  8 22:53:31 smtest kernel: scsi4 : ahci
Aug  8 22:53:31 smtest kernel: ata6: SATA link up 3.0 Gbps (SStatus 123)
Aug  8 22:53:31 smtest kernel: ata6: dev 0 ATA-7, max UDMA/133, 
1465149168 sectors: LBA48
Aug  8 22:53:31 smtest kernel: ata6: dev 0 configured for UDMA/133
Aug  8 22:53:31 smtest kernel: scsi5 : ahci
Aug  8 22:53:31 smtest kernel: Using cfq io scheduler
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3320620AS       Rev: 3.AA
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sda: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sda: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sda: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sda: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sda: sda1 sda2
Aug  8 22:53:31 smtest kernel: Attached scsi disk sda at scsi0, 
channel 0, id 0, lun 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3320620AS       Rev: 3.AA
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdb: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdb: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdb: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdb: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdb: sdb1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdb at scsi1, 
channel 0, id 0, lun 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3320620AS       Rev: 3.AA
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdc: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdc: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdc: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdc: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdc: sdc1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdc at scsi2, 
channel 0, id 0, lun 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3320620AS       Rev: 3.AA
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdd: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdd: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdd: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdd: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdd: sdd1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdd at scsi3, 
channel 0, id 0, lun 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3320620AS       Rev: 3.AA
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sde: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sde: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sde: 625142448 512-byte 
hdwr sectors (320073 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sde: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sde: sde1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sde at scsi4, 
channel 0, id 0, lun 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: 3.AA
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdf: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdf: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdf: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdf: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdf: sdf1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdf at scsi5, 
channel 0, id 0, lun 0
Aug  8 22:53:31 smtest kernel: si3124r5: no version for 
"struct_module" found: kernel tainted.
Aug  8 22:53:31 smtest kernel: si3124r5: module license 'Silicon 
Image' taints kernel.
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:05:01.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel:
Aug  8 22:53:31 smtest kernel:  --- pshost this_id: 3124, 
max_channel: 3, max_id: 20, max_lun: 1
Aug  8 22:53:31 smtest kernel: scsi6 : SiI SATA RAID Controller 
driver 3x and 6x Series
Aug  8 22:53:31 smtest kernel:       Rev: 0x1000900, Date: Sep 19 2006 00:17:33
Aug  8 22:53:31 smtest kernel:       Memory (unique_id) at 0x00000000,  Irq 169
Aug  8 22:53:31 smtest kernel:
Aug  8 22:53:31 smtest kernel:   Vendor: SI        Model: Pseudo 
Device     Rev: 0000
Aug  8 22:53:31 smtest 
kernel:   Type:   Processor                          ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:07:01.0[A] -> 
GSI 24 (level, low) -> IRQ 201
Aug  8 22:53:31 smtest kernel:
Aug  8 22:53:31 smtest kernel:  --- pshost this_id: 3124, 
max_channel: 3, max_id: 20, max_lun: 1
Aug  8 22:53:31 smtest kernel: scsi7 : SiI SATA RAID Controller 
driver 3x and 6x Series
Aug  8 22:53:31 smtest kernel:       Rev: 0x1000900, Date: Sep 19 2006 00:17:33
Aug  8 22:53:31 smtest kernel:       Memory (unique_id) at 0x00000001,  Irq 201
Aug  8 22:53:31 smtest kernel:
Aug  8 22:53:31 smtest kernel:   Vendor: SI        Model: Pseudo 
Device     Rev: 0000
Aug  8 22:53:31 smtest 
kernel:   Type:   Processor                          ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: Major number .. 254
Aug  8 22:53:31 smtest kernel: device-mapper: 4.5.0-ioctl 
(2005-10-04) initialised: dm-devel@redhat.com
Aug  8 22:53:31 smtest kernel: EXT3-fs: INFO: recovery required on 
readonly filesystem.
Aug  8 22:53:31 smtest kernel: EXT3-fs: write access will be enabled 
during recovery.
Aug  8 22:53:31 smtest kernel: kjournald starting.  Commit interval 5 seconds
Aug  8 22:53:31 smtest kernel: EXT3-fs: dm-0: orphan cleanup on readonly fs
Aug  8 22:53:31 smtest kernel: EXT3-fs: dm-0: 13 orphan inodes deleted
Aug  8 22:53:31 smtest kernel: EXT3-fs: recovery complete.
Aug  8 22:53:31 smtest kernel: EXT3-fs: mounted filesystem with 
ordered data mode.
Aug  8 22:53:31 smtest kernel: SELinux:  Disabled at runtime.
Aug  8 22:53:31 smtest kernel: SELinux:  Unregistering netfilter hooks
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg0 at scsi0, 
channel 0, id 0, lun 0,  type 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg1 at scsi1, 
channel 0, id 0, lun 0,  type 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg2 at scsi2, 
channel 0, id 0, lun 0,  type 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg3 at scsi3, 
channel 0, id 0, lun 0,  type 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg4 at scsi4, 
channel 0, id 0, lun 0,  type 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg5 at scsi5, 
channel 0, id 0, lun 0,  type 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg6 at scsi6, 
channel 3, id 31, lun 0,  type 3
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg7 at scsi7, 
channel 3, id 31, lun 0,  type 3
Aug  8 22:53:31 smtest kernel: Fusion MPT base driver 3.02.62.01rh
Aug  8 22:53:31 smtest kernel: Copyright (c) 1999-2005 LSI Logic Corporation
Aug  8 22:53:31 smtest kernel: Fusion MPT SAS Host driver 3.02.62.01rh
Aug  8 22:53:31 smtest kernel: ACPI: PCI interrupt 0000:08:00.0[A] -> 
GSI 16 (level, low) -> IRQ 169
Aug  8 22:53:31 smtest kernel: mptbase: Initiating ioc0 bringup
Aug  8 22:53:31 smtest kernel: ioc0: SAS1068E: Capabilities={Initiator}
Aug  8 22:53:31 smtest kernel: scsi8 : ioc0: LSISAS1068E, 
FwRev=01120000h, Ports=1, MaxQ=267, IRQ=169
Aug  8 22:53:31 smtest kernel:   Vendor: AIC       Model: 
EM16-53C-01A2     Rev: 109G
Aug  8 22:53:31 smtest 
kernel:   Type:   Enclosure                          ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg8 at scsi8, 
channel 0, id 8, lun 0,  type 13
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdg: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdg: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdg: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdg: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdg: sdg1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdg at scsi8, 
channel 0, id 9, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg9 at scsi8, 
channel 0, id 9, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdh: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdh: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdh: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdh: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdh: sdh1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdh at scsi8, 
channel 0, id 10, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg10 at scsi8, 
channel 0, id 10, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: J
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdi: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdi: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdi: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdi: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdi: sdi1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdi at scsi8, 
channel 0, id 11, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg11 at scsi8, 
channel 0, id 11, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: J
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdj: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdj: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdj: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdj: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdj: sdj1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdj at scsi8, 
channel 0, id 12, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg12 at scsi8, 
channel 0, id 12, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: J
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdk: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdk: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdk: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdk: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdk: sdk1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdk at scsi8, 
channel 0, id 13, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg13 at scsi8, 
channel 0, id 13, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: J
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdl: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdl: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdl: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdl: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdl: sdl1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdl at scsi8, 
channel 0, id 14, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg14 at scsi8, 
channel 0, id 14, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: J
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdm: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdm: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdm: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdm: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdm: sdm1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdm at scsi8, 
channel 0, id 15, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg15 at scsi8, 
channel 0, id 15, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdn: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdn: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdn: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdn: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdn: sdn1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdn at scsi8, 
channel 0, id 16, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg16 at scsi8, 
channel 0, id 16, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdo: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdo: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdo: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdo: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdo: sdo1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdo at scsi8, 
channel 0, id 17, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg17 at scsi8, 
channel 0, id 17, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: J
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdp: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdp: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdp: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdp: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdp: sdp1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdp at scsi8, 
channel 0, id 18, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg18 at scsi8, 
channel 0, id 18, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: D
Aug  8 22:53:31 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:31 smtest kernel: SCSI device sdq: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdq: drive cache: write back
Aug  8 22:53:31 smtest kernel: SCSI device sdq: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:31 smtest kernel: SCSI device sdq: drive cache: write back
Aug  8 22:53:31 smtest kernel:  sdq: sdq1
Aug  8 22:53:31 smtest kernel: Attached scsi disk sdq at scsi8, 
channel 0, id 19, lun 0
Aug  8 22:53:31 smtest kernel: Attached scsi generic sg19 at scsi8, 
channel 0, id 19, lun 0,  type 0
Aug  8 22:53:31 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: C
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdr: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdr: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdr: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdr: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdr: sdr1
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdr at scsi8, 
channel 0, id 20, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg20 at scsi8, 
channel 0, id 20, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: C
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sds: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sds: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sds: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sds: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sds: sds1
Aug  8 22:53:32 smtest kernel: Attached scsi disk sds at scsi8, 
channel 0, id 21, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg21 at scsi8, 
channel 0, id 21, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: C
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdt: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdt: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdt: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdt: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdt: sdt1
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdt at scsi8, 
channel 0, id 22, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg22 at scsi8, 
channel 0, id 22, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: C
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdu: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdu: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdu: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdu: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdu: sdu1
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdu at scsi8, 
channel 0, id 23, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg23 at scsi8, 
channel 0, id 23, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: C
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdv: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdv: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdv: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdv: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdv: sdv1
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdv at scsi8, 
channel 0, id 24, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg24 at scsi8, 
channel 0, id 24, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: AIC       Model: 
EM16-53C-01A2     Rev: 109G
Aug  8 22:53:32 smtest 
kernel:   Type:   Enclosure                          ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg25 at scsi8, 
channel 0, id 25, lun 0,  type 13
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdw: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdw: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdw: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdw: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdw: sdw1 sdw2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdw at scsi8, 
channel 0, id 26, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg26 at scsi8, 
channel 0, id 26, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdx: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdx: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdx: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdx: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdx: sdx1 sdx2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdx at scsi8, 
channel 0, id 27, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg27 at scsi8, 
channel 0, id 27, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdy: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdy: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdy: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdy: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdy: sdy1 sdy2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdy at scsi8, 
channel 0, id 28, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg28 at scsi8, 
channel 0, id 28, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdz: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdz: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdz: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdz: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdz: sdz1 sdz2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdz at scsi8, 
channel 0, id 29, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg29 at scsi8, 
channel 0, id 29, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdaa: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdaa: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdaa: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdaa: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdaa: sdaa1 sdaa2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdaa at scsi8, 
channel 0, id 30, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg30 at scsi8, 
channel 0, id 30, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdab: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdab: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdab: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdab: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdab: sdab1 sdab2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdab at scsi8, 
channel 0, id 31, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg31 at scsi8, 
channel 0, id 31, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdac: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdac: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdac: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdac: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdac: sdac1 sdac2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdac at scsi8, 
channel 0, id 32, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg32 at scsi8, 
channel 0, id 32, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdad: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdad: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdad: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdad: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdad: sdad1 sdad2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdad at scsi8, 
channel 0, id 33, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg33 at scsi8, 
channel 0, id 33, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdae: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdae: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdae: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdae: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdae: sdae1 sdae2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdae at scsi8, 
channel 0, id 34, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg34 at scsi8, 
channel 0, id 34, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdaf: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdaf: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdaf: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdaf: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdaf: sdaf1 sdaf2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdaf at scsi8, 
channel 0, id 35, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg35 at scsi8, 
channel 0, id 35, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdag: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdag: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdag: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdag: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdag: sdag1 sdag2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdag at scsi8, 
channel 0, id 36, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg36 at scsi8, 
channel 0, id 36, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdah: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdah: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdah: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdah: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdah: sdah1 sdah2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdah at scsi8, 
channel 0, id 37, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg37 at scsi8, 
channel 0, id 37, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdai: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdai: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdai: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdai: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdai: sdai1 sdai2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdai at scsi8, 
channel 0, id 38, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg38 at scsi8, 
channel 0, id 38, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdaj: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdaj: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdaj: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdaj: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdaj: sdaj1 sdaj2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdaj at scsi8, 
channel 0, id 39, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg39 at scsi8, 
channel 0, id 39, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: E
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdak: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdak: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdak: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdak: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdak: sdak1 sdak2
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdak at scsi8, 
channel 0, id 40, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg40 at scsi8, 
channel 0, id 40, lun 0,  type 0
Aug  8 22:53:32 smtest kernel:   Vendor: ATA       Model: 
ST3750640AS       Rev: J
Aug  8 22:53:32 smtest 
kernel:   Type:   Direct-Access                      ANSI SCSI revision: 05
Aug  8 22:53:32 smtest kernel: SCSI device sdal: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdal: drive cache: write back
Aug  8 22:53:32 smtest kernel: SCSI device sdal: 1465149168 512-byte 
hdwr sectors (750156 MB)
Aug  8 22:53:32 smtest kernel: SCSI device sdal: drive cache: write back
Aug  8 22:53:32 smtest kernel:  sdal: sdal1
Aug  8 22:53:32 smtest kernel: Attached scsi disk sdal at scsi8, 
channel 0, id 41, lun 0
Aug  8 22:53:32 smtest kernel: Attached scsi generic sg41 at scsi8, 
channel 0, id 41, lun 0,  type 0
Aug  8 22:53:32 smtest kernel: Fusion MPT SPI Host driver 3.02.62.01rh
Aug  8 22:53:32 smtest kernel: Fusion MPT FC Host driver 3.02.62.01rh
---

tia,
marc

