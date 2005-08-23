From: Vivek Goyal <vgoyal@in.ibm.com>
Subject: Query: Hard Resetting 53C1030 during initialization
Date: Tue, 23 Aug 2005 18:18:02 +0530
Message-ID: <20050823124802.GD3766@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tjCHc7DPkfUGtrlw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:485 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750997AbVHWMsA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 08:48:00 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7NClniN025219
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 08:47:49 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7NClncB220924
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 08:47:49 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7NCln95020343
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 08:47:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>


--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

In kdump, when second kernel is initializing after the crash of first kernel
then devices might not initialize properly in second kernel becuase devices
are not in reset state.

It was suggested that drivers can be hardened to handle this situation. 
A driver can reset the underlying device while it is initializing and then
go ahead with rest of the initialization. This reset can be performed based
on additional commandline option passed to the kernel. 

I was trying the same for MPT fusion driver but somehow reset does not
seem to be working. Diagnostic reset fails. 

I am attaching the test patch and logs. Could you please suggest what is
amiss? 

Following are the scsi controllers in my machine.

05:07.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 (rev 07)
05:07.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 (rev 07)
07:05.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02) 

Following is the error message. Full logs are attached with mail.

Fusion MPT base driver 3.03.02
Copyright (c) 1999-2005 LSI Logic Corporation
mptbase: Register for IOC reset notification
Fusion MPT SPI Host driver 3.03.02
mptspi: Registered for IOC reset notifications
ACPI: PCI Interrupt 0000:05:07.0[A] -> GSI 27 (level, low) -> IRQ 18
mptbase: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED
mptbase: Using 64 bit consistent mask
mptbase: ioc0: DbG1: diag0=00000100, diag1=00000000
mptbase: ioc0: Wrote magic DiagWriteEn sequence (180)
mptbase: ioc0: DbG2: diag0=00000180, diag1=00000000
mptbase: ioc0: Diagnostic reset performed
mptbase: ioc0: Calling IOC pre_reset handler #15
mptbase: IOC pre_reset routed to MPT base driver!
mptbase: ioc0: Calling IOC pre_reset handler #14
Firmware load failed. Waited for 60 seconds
mptbase: ioc0: DbG3: diag0=00000122, diag1=00000000
mptbase: ioc0: ERROR - Diagnostic reset FAILED! (102h)
IOC hard reset failed
mptspi: probe of 0000:05:07.0 failed with error -3
ACPI: PCI Interrupt 0000:05:07.1[B] -> GSI 28 (level, low) -> IRQ 19
mptbase: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED
mptbase: Using 64 bit consistent mask
mptbase: ioc1: DbG1: diag0=00000122, diag1=00000000
mptbase: ioc1: DbG3: diag0=00000122, diag1=00000000
mptbase: ioc1: ERROR - Diagnostic reset FAILED! (102h)
IOC hard reset failed
mptspi: probe of 0000:05:07.1 failed with error -3




This patch fixes driver hardening issues.

Signed-off-by: Vivek Goyal <vgoyal@in.ibm.com>
---

 linux-2.6.13-rc6-1M-root/drivers/message/fusion/Makefile  |    4 ++--
 linux-2.6.13-rc6-1M-root/drivers/message/fusion/mptbase.c |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~kdump-mpt-driver-hardening-reset-during-init drivers/message/fusion/mptbase.c
--- linux-2.6.13-rc6-1M/drivers/message/fusion/mptbase.c~kdump-mpt-driver-hardening-reset-during-init	2005-08-23 13:37:40.000000000 +0530
+++ linux-2.6.13-rc6-1M-root/drivers/message/fusion/mptbase.c	2005-08-23 17:57:08.000000000 +0530
@@ -1026,6 +1026,7 @@ mpt_attach(struct pci_dev *pdev, const s
 	u8		 revision;
 	u8		 pcixcmd;
 	static int	 mpt_ids = 0;
+	int		 hard_reset_done = 0;
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *dent, *ent;
 #endif
@@ -1225,6 +1226,15 @@ mpt_attach(struct pci_dev *pdev, const s
 	list_add_tail(&ioc->list, &ioc_list);
 
 	ioc->pci_irq = -1;
+
+	/* Reset the Adapter before going further. Underlying device is not
+	 * in reset state. */
+        hard_reset_done = mpt_diag_reset(ioc, 0, NO_SLEEP);
+        if (hard_reset_done < 0) {
+		printk("IOC hard reset failed\n");
+		return hard_reset_done;
+	}
+
 	if (pdev->irq) {
 		r = request_irq(pdev->irq, mpt_interrupt, SA_SHIRQ, ioc->name, ioc);
 
@@ -3072,6 +3082,10 @@ mpt_diag_reset(MPT_ADAPTER *ioc, int ign
 				}
 			}
 		}
+		if (count >= 60)
+			printk("Firmware load failed. Waited for 60 seconds\n");
+		else
+			printk("Firmware load successful\n");
 	}
 
 	diag0val = CHIPREG_READ32(&ioc->chip->Diagnostic);
diff -puN drivers/message/fusion/Makefile~kdump-mpt-driver-hardening-reset-during-init drivers/message/fusion/Makefile
--- linux-2.6.13-rc6-1M/drivers/message/fusion/Makefile~kdump-mpt-driver-hardening-reset-during-init	2005-08-23 15:08:09.000000000 +0530
+++ linux-2.6.13-rc6-1M-root/drivers/message/fusion/Makefile	2005-08-23 15:08:38.000000000 +0530
@@ -1,6 +1,6 @@
 # Fusion MPT drivers; recognized debug defines...
 #  MPT general:
-#EXTRA_CFLAGS += -DMPT_DEBUG
+EXTRA_CFLAGS += -DMPT_DEBUG
 #EXTRA_CFLAGS += -DMPT_DEBUG_MSG_FRAME
 #EXTRA_CFLAGS += -DMPT_DEBUG_SG
 #EXTRA_CFLAGS += -DMPT_DEBUG_EVENTS
@@ -17,7 +17,7 @@
 #CFLAGS_mptbase.o += -DMPT_DEBUG_CONFIG
 #CFLAGS_mptbase.o += -DMPT_DEBUG_DL
 #CFLAGS_mptbase.o += -DMPT_DEBUG_IRQ
-#CFLAGS_mptbase.o += -DMPT_DEBUG_RESET
+CFLAGS_mptbase.o += -DMPT_DEBUG_RESET
 #
 #  For mptscsih:
 #CFLAGS_mptscsih.o += -DMPT_DEBUG_DV
_

--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="serial-console-output.txt"

LILO boot: vivek-reset
Loading vivek-reset.........................................
Linux version 2.6.13-rc6-1M (root@llm05.in.ibm.com) (gcc version 3.2.2 20030222 (Red Hat Linux 3.2.2-5)) #9 SMP Tue Aug 23 17:58:02 IST 2005
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
 BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000009ffe7f40 (usable)
 BIOS-e820: 000000009ffe7f40 - 000000009ffef800 (ACPI data)
 BIOS-e820: 000000009ffef800 - 00000000a0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
user-defined physical RAM map:
 user: 0000000000000000 - 000000000009d400 (usable)
 user: 000000000009d400 - 00000000000a0000 (reserved)
 user: 00000000000e0000 - 0000000000100000 (reserved)
 user: 0000000000100000 - 0000000080000000 (usable)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
found SMP MP-table at 0009d540
DMI 2.3 present.
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x0d] address[0xfec01000] gsi_base[16])
IOAPIC[1]: apic_id 13, version 17, address 0xfec01000, GSI 16-31
ACPI: IOAPIC (id[0x0c] address[0xfec02000] gsi_base[32])
IOAPIC[2]: apic_id 12, version 17, address 0xfec02000, GSI 32-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Enabling APIC mode:  Flat.  Using 3 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 80000000:80000000)
Built 1 zonelists
Kernel command line: auto BOOT_IMAGE=vivek-reset ro BOOT_FILE=/boot/bzImage-2.6.13-rc6-1M-reset root=/dev/sda5 console=tty0 console=ttyS0,38400 crashkernel=48M@16M mem=2G
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 2395.304 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 854900k/917504k available (3035k kernel code, 62152k reserved, 1185k data, 232k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4798.99 BogoMIPS (lpj=9597990)
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
mtrr: v2.0 (20020519)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Booting processor 1/1 eip 2000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4790.04 BogoMIPS (lpj=9580084)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Booting processor 2/6 eip 2000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4790.08 BogoMIPS (lpj=9580171)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Booting processor 3/7 eip 2000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4790.05 BogoMIPS (lpj=9580118)
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Total of 4 processors activated (19169.18 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=2 pin2=-1
checking TSC synchronization across 4 CPUs: passed.
Brought up 4 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfd7cc, last bus=10
PCI: Using configuration type 1
ACPI: Subsystem revision 20050408
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI2] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
PCI: Ignoring BAR0-3 of IDE controller 0000:00:0f.1
ACPI: PCI Root Bridge [PCI1] (0000:02)
PCI: Probing PCI hardware (bus 02)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI2] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
ACPI: PCI Root Bridge [PCI2] (0000:05)
PCI: Probing PCI hardware (bus 05)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI2] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
ACPI: PCI Root Bridge [PCI3] (0000:07)
PCI: Probing PCI hardware (bus 07)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI2] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
ACPI: PCI Root Bridge [PCI4] (0000:09)
PCI: Probing PCI hardware (bus 09)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
ACPI: Assume root bridge [\_SB_.PCI1] segment is 0
ACPI: Assume root bridge [\_SB_.PCI2] segment is 0
ACPI: Assume root bridge [\_SB_.PCI3] segment is 0
ACPI: Assume root bridge [\_SB_.PCI4] segment is 0
ACPI: PCI Interrupt Link [LP00] (IRQs *3)
ACPI: PCI Interrupt Link [LP01] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP02] (IRQs *10)
ACPI: PCI Interrupt Link [LP03] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP04] (IRQs *11)
ACPI: PCI Interrupt Link [LP05] (IRQs *10)
ACPI: PCI Interrupt Link [LP06] (IRQs *3)
ACPI: PCI Interrupt Link [LP07] (IRQs *10)
ACPI: PCI Interrupt Link [LP08] (IRQs *9)
ACPI: PCI Interrupt Link [LP09] (IRQs *5)
ACPI: PCI Interrupt Link [LP0A] (IRQs *10)
ACPI: PCI Interrupt Link [LP0B] (IRQs *9)
ACPI: PCI Interrupt Link [LP0C] (IRQs *9)
ACPI: PCI Interrupt Link [LP0D] (IRQs *11)
ACPI: PCI Interrupt Link [LP0E] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP0F] (IRQs *11)
ACPI: PCI Interrupt Link [LP10] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP11] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP12] (IRQs *5)
ACPI: PCI Interrupt Link [LP13] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP14] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP15] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP16] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP17] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP18] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP19] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP1A] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP1B] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP1C] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP1D] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP1E] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP1F] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LPUS] (IRQs *11)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 14 devices
SCSI subsystem initialized
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:00: ioport range 0x900-0x93f has been reserved
pnp: 00:00: ioport range 0x510-0x517 could not be reserved
pnp: 00:00: ioport range 0x504-0x507 could not be reserved
pnp: 00:00: ioport range 0x500-0x503 could not be reserved
pnp: 00:00: ioport range 0x520-0x53f has been reserved
pnp: 00:00: ioport range 0x420-0x427 has been reserved
pnp: 00:00: ioport range 0x460-0x461 has been reserved
pnp: 00:0b: ioport range 0x1ec-0x1ef has been reserved
pnp: 00:0b: ioport range 0x400-0x4fe could not be reserved
pnp: 00:0b: ioport range 0x600-0x600 has been reserved
pnp: 00:0b: ioport range 0x800-0x80f has been reserved
pnp: 00:0b: ioport range 0xc00-0xcfe could not be reserved
pnp: 00:0b: ioport range 0xf50-0xf58 has been reserved
Machine check exception polling timer started.
audit: initializing netlink socket (disabled)
audit(1124820107.484:1): initialized
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
ACPI: Power Button (FF) [PWRF]
ACPI: CPU3 (power states: C1[C1])
ACPI: CPU1 (power states: C1[C1])
ACPI: CPU2 (power states: C1[C1])
ACPI: CPU0 (power states: C1[C1])
lp: driver loaded but no devices found
Linux agpgart interface v0.101 (c) Dave Jones
[drm] Initialized drm 1.0.0 20040925
PNP: PS/2 controller has invalid data port 0x64; using default 0x60
PNP: PS/2 controller has invalid command port 0x60; using default 0x64
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
lp0: using parport0 (interrupt-driven).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
e100: Intel(R) PRO/100 Network Driver, 3.4.8-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 18 (level, low) -> IRQ 16
e100: eth0: e100_probe: addr 0xfbfff000, irq 16, MAC addr 00:03:47:E0:67:78
ACPI: PCI Interrupt 0000:09:06.0[A] -> GSI 31 (level, low) -> IRQ 17
e100: eth1: e100_probe: addr 0xf53ff000, irq 17, MAC addr 00:02:55:50:04:D6
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
hda: LTN486S, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: ATAPI 48X CD-ROM drive, 120kB Cache
Uniform CD-ROM driver Revision: 3.20
Fusion MPT base driver 3.03.02
Copyright (c) 1999-2005 LSI Logic Corporation
mptbase: Register for IOC reset notification
Fusion MPT SPI Host driver 3.03.02
mptspi: Registered for IOC reset notifications
ACPI: PCI Interrupt 0000:05:07.0[A] -> GSI 27 (level, low) -> IRQ 18
mptbase: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED
mptbase: Using 64 bit consistent mask
mptbase: ioc0: DbG1: diag0=00000100, diag1=00000000
mptbase: ioc0: Wrote magic DiagWriteEn sequence (180)
mptbase: ioc0: DbG2: diag0=00000180, diag1=00000000
mptbase: ioc0: Diagnostic reset performed
mptbase: ioc0: Calling IOC pre_reset handler #15
mptbase: IOC pre_reset routed to MPT base driver!
mptbase: ioc0: Calling IOC pre_reset handler #14
Firmware load failed. Waited for 60 seconds
mptbase: ioc0: DbG3: diag0=00000122, diag1=00000000
mptbase: ioc0: ERROR - Diagnostic reset FAILED! (102h)
IOC hard reset failed
mptspi: probe of 0000:05:07.0 failed with error -3
ACPI: PCI Interrupt 0000:05:07.1[B] -> GSI 28 (level, low) -> IRQ 19
mptbase: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED
mptbase: Using 64 bit consistent mask
mptbase: ioc1: DbG1: diag0=00000122, diag1=00000000
mptbase: ioc1: DbG3: diag0=00000122, diag1=00000000
mptbase: ioc1: ERROR - Diagnostic reset FAILED! (102h)
IOC hard reset failed
mptspi: probe of 0000:05:07.1 failed with error -3
ieee1394: raw1394: /dev/raw1394 device initialized
usbmon: debugs is not available
USB Universal Host Controller Interface driver v2.3
usbcore: registered new driver usblp
drivers/usb/class/usblp.c: v0.13: USB Printer Device Class driver
Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.01:USB HID core driver
mice: PS/2 mouse device common for all mice
Advanced Linux Sound Architecture Driver Version 1.0.9b (Thu Jul 28 12:20:13 2005 UTC).
ALSA device list:
  No soundcards found.
oprofile: using NMI interrupt.
NET: Registered protocol family 2
input: AT Translated Set 2 keyboard on isa0060/serio0
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
ip_conntrack version 2.1 (7168 buckets, 57344 max) - 212 bytes per conntrack
ip_tables: (C) 2000-2002 Netfilter core team
input: PS/2 Generic Mouse on isa0060/serio1
ipt_recent v0.3.1: Stephen Frost <sfrost@snowman.net>.  http://snowman.net/projects/ipt_recent/
arp_tables: (C) 2002 David S. Miller
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Starting balanced_irq
Using IPI Shortcut mode
VFS: Cannot open root device "sda5" or unknown-block(0,0)
Please append a correct "root=" boot option
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
 

--tjCHc7DPkfUGtrlw--
