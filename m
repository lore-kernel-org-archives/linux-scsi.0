From: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
Subject: Re: [SCSI] can't plug Nokia 5300 anymore (bisected)
Date: Sat, 26 Jul 2008 11:34:30 +0200
Message-ID: <488AEFA6.5030409@belbone.be>
References: <Pine.LNX.4.44L0.0807252342570.7216-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080003030207010804060506"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:3286 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbYGZJet (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2008 05:34:49 -0400
In-Reply-To: <Pine.LNX.4.44L0.0807252342570.7216-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Kernel <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080003030207010804060506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Alan Stern wrote:
> On Fri, 25 Jul 2008, Cédric Godin wrote:
>
>   
>> resending because wrong address of lkml and cc scsi list
>>
>> Hello,
>>
>> since 2 or 3 -git kernels (Linus tree)  I have a problem with my laptop 
>> and its connection through USB to a nokia 5300 gsm.
>>
>> The logs show me a endless loop (until i unplug my USB cable) of 
>> following messages :
>>
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>
>> I bisected the kernel and found the following commit as result :
>>
>> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
>> commit 427e59f09fdba387547106de7bab980b7fff77be
>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Date:   Sat Mar 8 18:24:17 2008 -0600
>>
>>    [SCSI] make use of the residue value
>>
>>    USB sometimes doesn't return an error but instead returns a residue
>>    value indicating part (or all) of the command wasn't completed.  So if
>>    the driver _done() error processing indicates the command was fully
>>    processed, subtract off the residue so that this USB error gets
>>    propagated.
>>
>>    Cc: Alan Stern <stern@rowland.harvard.edu>
>>    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>>
>> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd 
>> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
>>
>>
>> When reverting it with 2.6.26-06077-gc010b2f , everything is back to normal.
>>     
>
> Can you post the corresponding dmesg log from a system built with 
> CONFIG_USB_STORAGE_DEBUG enabled?
>
> Alan Stern
>
>   
Sure,
i attached it



--------------080003030207010804060506
Content-Type: text/plain;
 name="messages-ok"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages-ok"

Jul 26 10:15:50 enea Linux version 2.6.26-06078-g15749ef (cedric@enea) (gcc version 4.2.4 (Gentoo 4.2.4 p1.0)) #1 PREEMPT Sat Jul 26 10:04:40 CEST 2008
Jul 26 10:15:50 enea PAT disabled. Not yet verified on this CPU type.
Jul 26 10:15:50 enea BIOS-provided physical RAM map:
Jul 26 10:15:50 enea BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jul 26 10:15:50 enea BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jul 26 10:15:50 enea BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
Jul 26 10:15:50 enea BIOS-e820: 0000000000100000 - 000000001ffd0000 (usable)
Jul 26 10:15:50 enea BIOS-e820: 000000001ffd0000 - 000000001fff0c00 (reserved)
Jul 26 10:15:50 enea BIOS-e820: 000000001fff0c00 - 000000001fffc000 (ACPI NVS)
Jul 26 10:15:50 enea BIOS-e820: 000000001fffc000 - 0000000020000000 (reserved)
Jul 26 10:15:50 enea last_pfn = 0x1ffd0 max_arch_pfn = 0x100000
Jul 26 10:15:50 enea kernel direct mapping tables up to 1ffd0000 @ 7000-d000
Jul 26 10:15:50 enea RAMDISK: 1ff53000 - 1ffbf19e
Jul 26 10:15:50 enea DMI 2.3 present.
Jul 26 10:15:50 enea ACPI: RSDP 000F6F90, 0014 (r0 COMPAQ)
Jul 26 10:15:50 enea ACPI: RSDT 1FFF0C84, 002C (r1 HP     HP0890   22040420 CPQ         1)
Jul 26 10:15:50 enea ACPI: FACP 1FFF0C00, 0084 (r2 HP     HP0890          2 CPQ         1)
Jul 26 10:15:50 enea ACPI: DSDT 1FFF0CB0, 62D9 (r1 HP       nc6000    10000 MSFT  100000E)
Jul 26 10:15:50 enea ACPI: FACS 1FFFBE80, 0040
Jul 26 10:15:50 enea ACPI: SSDT 1FFF6F89, 028A (r1 COMPAQ  CPQGysr     1001 MSFT  100000E)
Jul 26 10:15:50 enea ACPI: DMI detected: Hewlett-Packard
Jul 26 10:15:50 enea Entering add_active_range(0, 0x0, 0x9f) 0 entries of 256 used
Jul 26 10:15:50 enea Entering add_active_range(0, 0x100, 0x1ffd0) 1 entries of 256 used
Jul 26 10:15:50 enea 511MB LOWMEM available.
Jul 26 10:15:50 enea mapped low ram: 0 - 1ffd0000
Jul 26 10:15:50 enea low ram: 00000000 - 1ffd0000
Jul 26 10:15:50 enea bootmap 00001000 - 00004ffc
Jul 26 10:15:50 enea (7 early reservations) ==> bootmem [0000000000 - 001ffd0000]
Jul 26 10:15:50 enea #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
Jul 26 10:15:50 enea #1 [0000100000 - 00004436d4]    TEXT DATA BSS ==> [0000100000 - 00004436d4]
Jul 26 10:15:50 enea #2 [001ff53000 - 001ffbf19e]          RAMDISK ==> [001ff53000 - 001ffbf19e]
Jul 26 10:15:50 enea #3 [0000444000 - 0000447000]    INIT_PG_TABLE ==> [0000444000 - 0000447000]
Jul 26 10:15:50 enea #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
Jul 26 10:15:50 enea #5 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
Jul 26 10:15:50 enea #6 [0000001000 - 0000005000]          BOOTMAP ==> [0000001000 - 0000005000]
Jul 26 10:15:50 enea Zone PFN ranges:
Jul 26 10:15:50 enea DMA      0x00000000 -> 0x00001000
Jul 26 10:15:50 enea Normal   0x00001000 -> 0x0001ffd0
Jul 26 10:15:50 enea Movable zone start PFN for each node
Jul 26 10:15:50 enea early_node_map[2] active PFN ranges
Jul 26 10:15:50 enea 0: 0x00000000 -> 0x0000009f
Jul 26 10:15:50 enea 0: 0x00000100 -> 0x0001ffd0
Jul 26 10:15:50 enea On node 0 totalpages: 130927
Jul 26 10:15:50 enea free_area_init_node: node 0, pgdat c03b0e00, node_mem_map c1000000
Jul 26 10:15:50 enea DMA zone: 32 pages used for memmap
Jul 26 10:15:50 enea DMA zone: 0 pages reserved
Jul 26 10:15:50 enea DMA zone: 3967 pages, LIFO batch:0
Jul 26 10:15:50 enea Normal zone: 992 pages used for memmap
Jul 26 10:15:50 enea Normal zone: 125936 pages, LIFO batch:31
Jul 26 10:15:50 enea Movable zone: 0 pages used for memmap
Jul 26 10:15:50 enea ACPI: PM-Timer IO Port: 0x1008
Jul 26 10:15:50 enea Local APIC disabled by BIOS -- reenabling.
Jul 26 10:15:50 enea Found and enabled local APIC!
Jul 26 10:15:50 enea mapped APIC to ffffb000 (fee00000)
Jul 26 10:15:50 enea PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Jul 26 10:15:50 enea PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
Jul 26 10:15:50 enea PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Jul 26 10:15:50 enea Allocating PCI resources starting at 30000000 (gap: 20000000:e0000000)
Jul 26 10:15:50 enea Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129903
Jul 26 10:15:50 enea Kernel command line: root=/dev/sda1 resume=/dev/sda5 vga=0x316 video=vesafb:ywrap,mtrr,1024x768-16@60 splash=silent,theme:livecd-2007.0 CONSOLE=/dev/tty1 acpi_sleep=s3_bios lapic
Jul 26 10:15:50 enea Enabling fast FPU save and restore... done.
Jul 26 10:15:50 enea Enabling unmasked SIMD FPU exception support... done.
Jul 26 10:15:50 enea Initializing CPU#0
Jul 26 10:15:50 enea PID hash table entries: 2048 (order: 11, 8192 bytes)
Jul 26 10:15:50 enea TSC calibrated against PM_TIMER
Jul 26 10:15:50 enea Detected 1594.823 MHz processor.
Jul 26 10:15:50 enea Console: colour dummy device 80x25
Jul 26 10:15:50 enea console [tty0] enabled
Jul 26 10:15:50 enea Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Jul 26 10:15:50 enea Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Jul 26 10:15:50 enea Memory: 515136k/524096k available (2077k kernel code, 8324k reserved, 776k data, 224k init, 0k highmem)
Jul 26 10:15:50 enea virtual kernel memory layout:
Jul 26 10:15:50 enea fixmap  : 0xfffb9000 - 0xfffff000   ( 280 kB)
Jul 26 10:15:50 enea vmalloc : 0xe0800000 - 0xfffb7000   ( 503 MB)
Jul 26 10:15:50 enea lowmem  : 0xc0000000 - 0xdffd0000   ( 511 MB)
Jul 26 10:15:50 enea .init : 0xc03cc000 - 0xc0404000   ( 224 kB)
Jul 26 10:15:50 enea .data : 0xc030773d - 0xc03c9908   ( 776 kB)
Jul 26 10:15:50 enea .text : 0xc0100000 - 0xc030773d   (2077 kB)
Jul 26 10:15:50 enea Checking if this processor honours the WP bit even in supervisor mode...Ok.
Jul 26 10:15:50 enea CPA: page pool initialized 1 of 1 pages preallocated
Jul 26 10:15:50 enea Calibrating delay loop (skipped), value calculated using timer frequency.. <6>3189.64 BogoMIPS (lpj=1594823)
Jul 26 10:15:50 enea Mount-cache hash table entries: 512
Jul 26 10:15:50 enea CPU: L1 I cache: 32K, L1 D cache: 32K
Jul 26 10:15:50 enea CPU: L2 cache: 2048K
Jul 26 10:15:50 enea CPU: Intel(R) Pentium(R) M processor 1.60GHz stepping 06
Jul 26 10:15:50 enea Checking 'hlt' instruction... OK.
Jul 26 10:15:50 enea Freeing SMP alternatives: 0k freed
Jul 26 10:15:50 enea ACPI: Core revision 20080609
Jul 26 10:15:50 enea ACPI: setting ELCR to 0200 (from 0c00)
Jul 26 10:15:50 enea net_namespace: 480 bytes
Jul 26 10:15:50 enea HP Compaq Laptop series board detected. Selecting BIOS-method for reboots.
Jul 26 10:15:50 enea NET: Registered protocol family 16
Jul 26 10:15:50 enea No dock devices found.
Jul 26 10:15:50 enea ACPI: bus type pci registered
Jul 26 10:15:50 enea PCI: PCI BIOS revision 2.10 entry at 0xf031f, last bus=5
Jul 26 10:15:50 enea PCI: Using configuration type 1 for base access
Jul 26 10:15:50 enea ACPI: EC: Look up EC in DSDT
Jul 26 10:15:50 enea ACPI: EC: non-query interrupt received, switching to interrupt mode
Jul 26 10:15:50 enea ACPI: Interpreter enabled
Jul 26 10:15:50 enea ACPI: (supports S0 S3 S4 S5)
Jul 26 10:15:50 enea ACPI: Using PIC for interrupt routing
Jul 26 10:15:50 enea ACPI: EC: GPE = 0x10, I/O: command/status = 0x66, data = 0x62
Jul 26 10:15:50 enea ACPI: EC: driver started in interrupt mode
Jul 26 10:15:50 enea ACPI: PCI Root Bridge [C045] (0000:00)
Jul 26 10:15:50 enea pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
Jul 26 10:15:50 enea pci 0000:00:1d.7: PME# disabled
Jul 26 10:15:50 enea HPET not enabled in BIOS. You might try hpet=force boot option
Jul 26 10:15:50 enea pci 0000:00:1f.0: Enabled i801 SMBus device
Jul 26 10:15:50 enea pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
Jul 26 10:15:50 enea pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH4 GPIO
Jul 26 10:15:50 enea pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
Jul 26 10:15:50 enea pci 0000:00:1f.5: PME# disabled
Jul 26 10:15:50 enea pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
Jul 26 10:15:50 enea pci 0000:00:1f.6: PME# disabled
Jul 26 10:15:50 enea pci 0000:01:00.0: supports D1
Jul 26 10:15:50 enea pci 0000:01:00.0: supports D2
Jul 26 10:15:50 enea pci 0000:02:06.0: supports D1
Jul 26 10:15:50 enea pci 0000:02:06.0: supports D2
Jul 26 10:15:50 enea pci 0000:02:06.0: PME# supported from D0 D1 D2 D3hot D3cold
Jul 26 10:15:50 enea pci 0000:02:06.0: PME# disabled
Jul 26 10:15:50 enea pci 0000:02:06.1: supports D1
Jul 26 10:15:50 enea pci 0000:02:06.1: supports D2
Jul 26 10:15:50 enea pci 0000:02:06.1: PME# supported from D0 D1 D2 D3hot D3cold
Jul 26 10:15:50 enea pci 0000:02:06.1: PME# disabled
Jul 26 10:15:50 enea pci 0000:02:06.2: supports D1
Jul 26 10:15:50 enea pci 0000:02:06.2: supports D2
Jul 26 10:15:50 enea pci 0000:02:06.2: PME# supported from D0 D1 D2 D3hot D3cold
Jul 26 10:15:50 enea pci 0000:02:06.2: PME# disabled
Jul 26 10:15:50 enea pci 0000:02:06.3: supports D1
Jul 26 10:15:50 enea pci 0000:02:06.3: supports D2
Jul 26 10:15:50 enea pci 0000:02:06.3: PME# supported from D0 D1 D2 D3hot D3cold
Jul 26 10:15:50 enea pci 0000:02:06.3: PME# disabled
Jul 26 10:15:50 enea pci 0000:02:0e.0: PME# supported from D3hot D3cold
Jul 26 10:15:50 enea pci 0000:02:0e.0: PME# disabled
Jul 26 10:15:50 enea pci 0000:00:1e.0: transparent bridge
Jul 26 10:15:50 enea bus 00 -> node 0
Jul 26 10:15:50 enea ACPI: PCI Interrupt Routing Table [\_SB_.C045._PRT]
Jul 26 10:15:50 enea ACPI: PCI Interrupt Routing Table [\_SB_.C045.C046._PRT]
Jul 26 10:15:50 enea ACPI: PCI Interrupt Routing Table [\_SB_.C045.C057._PRT]
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C2] (IRQs *10 11)
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C3] (IRQs 10 *11)
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C4] (IRQs *10 11)
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C5] (IRQs *10 11)
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C6] (IRQs 10 *11)
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C7] (IRQs 10 *11)
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C8] (IRQs 10 11) *0, disabled.
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C9] (IRQs *10 11)
Jul 26 10:15:50 enea ACPI: Power Resource [C16E] (on)
Jul 26 10:15:50 enea ACPI: Power Resource [C185] (on)
Jul 26 10:15:50 enea ACPI: Power Resource [C18C] (on)
Jul 26 10:15:50 enea ACPI: Power Resource [C196] (on)
Jul 26 10:15:50 enea ACPI: Power Resource [C0E7] (on)
Jul 26 10:15:50 enea ACPI: Power Resource [C202] (off)
Jul 26 10:15:50 enea ACPI: Power Resource [C203] (off)
Jul 26 10:15:50 enea ACPI: Power Resource [C204] (off)
Jul 26 10:15:50 enea ACPI: Power Resource [C205] (off)
Jul 26 10:15:50 enea Linux Plug and Play Support v0.97 (c) Adam Belay
Jul 26 10:15:50 enea pnp: PnP ACPI init
Jul 26 10:15:50 enea ACPI: bus type pnp registered
Jul 26 10:15:50 enea pnp: PnP ACPI: found 14 devices
Jul 26 10:15:50 enea ACPI: ACPI bus type pnp unregistered
Jul 26 10:15:50 enea SCSI subsystem initialized
Jul 26 10:15:50 enea libata version 3.00 loaded.
Jul 26 10:15:50 enea PCI: Using ACPI for IRQ routing
Jul 26 10:15:50 enea system 00:00: iomem range 0x0-0x9ffff could not be reserved
Jul 26 10:15:50 enea system 00:00: iomem range 0xe0000-0xfffff could not be reserved
Jul 26 10:15:50 enea system 00:00: iomem range 0x100000-0x1fffffff could not be reserved
Jul 26 10:15:50 enea system 00:0b: ioport range 0x140-0x14f has been reserved
Jul 26 10:15:50 enea system 00:0b: iomem range 0xffb00000-0xffbfffff has been reserved
Jul 26 10:15:50 enea system 00:0b: iomem range 0xfff00000-0xffffffff has been reserved
Jul 26 10:15:50 enea system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
Jul 26 10:15:50 enea system 00:0c: ioport range 0x1000-0x107f has been reserved
Jul 26 10:15:50 enea system 00:0c: ioport range 0x1100-0x113f has been reserved
Jul 26 10:15:50 enea system 00:0c: ioport range 0x1200-0x121f has been reserved
Jul 26 10:15:50 enea system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
Jul 26 10:15:50 enea system 00:0d: iomem range 0xfec01000-0xfec01fff has been reserved
Jul 26 10:15:50 enea pci 0000:02:06.0: BAR 9 too large: 0x00000000000000-0x00000003ffffff
Jul 26 10:15:50 enea pci 0000:02:06.1: BAR 9 too large: 0x00000000000000-0x00000003ffffff
Jul 26 10:15:50 enea pci 0000:02:06.3: BAR 9 too large: 0x00000000000000-0x00000003ffffff
Jul 26 10:15:50 enea pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
Jul 26 10:15:50 enea pci 0000:00:01.0:   IO window: 0x2000-0x2fff
Jul 26 10:15:50 enea pci 0000:00:01.0:   MEM window: 0x90300000-0x903fffff
Jul 26 10:15:50 enea pci 0000:00:01.0:   PREFETCH window: 0x00000098000000-0x0000009fffffff
Jul 26 10:15:50 enea pci 0000:02:06.0: CardBus bridge, secondary bus 0000:03
Jul 26 10:15:50 enea pci 0000:02:06.0:   IO window: 0x004000-0x0040ff
Jul 26 10:15:50 enea pci 0000:02:06.0:   IO window: 0x004400-0x0044ff
Jul 26 10:15:50 enea pci 0000:02:06.0:   MEM window: 0x34000000-0x37ffffff
Jul 26 10:15:50 enea pci 0000:02:06.1: CardBus bridge, secondary bus 0000:05
Jul 26 10:15:50 enea pci 0000:02:06.1:   IO window: 0x004800-0x0048ff
Jul 26 10:15:50 enea pci 0000:02:06.1:   IO window: 0x004c00-0x004cff
Jul 26 10:15:50 enea pci 0000:02:06.1:   MEM window: 0x38000000-0x3bffffff
Jul 26 10:15:50 enea pci 0000:02:06.3: CardBus bridge, secondary bus 0000:09
Jul 26 10:15:50 enea pci 0000:02:06.3:   IO window: 0x001400-0x0014ff
Jul 26 10:15:50 enea pci 0000:02:06.3:   IO window: 0x001800-0x0018ff
Jul 26 10:15:50 enea pci 0000:02:06.3:   MEM window: 0x3c000000-0x3fffffff
Jul 26 10:15:50 enea pci 0000:00:1e.0: PCI bridge, secondary bus 0000:02
Jul 26 10:15:50 enea pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
Jul 26 10:15:50 enea pci 0000:00:1e.0:   MEM window: 0x90000000-0x902fffff
Jul 26 10:15:50 enea pci 0000:00:1e.0:   PREFETCH window: 0x00000030000000-0x000000300fffff
Jul 26 10:15:50 enea PCI: Setting latency timer of device 0000:00:1e.0 to 64
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C4] enabled at IRQ 10
Jul 26 10:15:50 enea PCI: setting IRQ 10 as level-triggered
Jul 26 10:15:50 enea pci 0000:02:06.0: PCI INT A -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:50 enea pci 0000:02:06.1: PCI INT A -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:50 enea pci 0000:02:06.3: PCI INT A -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:50 enea NET: Registered protocol family 2
Jul 26 10:15:50 enea IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
Jul 26 10:15:50 enea TCP established hash table entries: 16384 (order: 5, 131072 bytes)
Jul 26 10:15:50 enea TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
Jul 26 10:15:50 enea TCP: Hash tables configured (established 16384 bind 16384)
Jul 26 10:15:50 enea TCP reno registered
Jul 26 10:15:50 enea NET: Registered protocol family 1
Jul 26 10:15:50 enea checking if image is initramfs... it is
Jul 26 10:15:50 enea Freeing initrd memory: 432k freed
Jul 26 10:15:50 enea IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
Jul 26 10:15:50 enea msgmni has been set to 1007
Jul 26 10:15:50 enea io scheduler noop registered
Jul 26 10:15:50 enea io scheduler cfq registered (default)
Jul 26 10:15:50 enea pci 0000:01:00.0: Boot video device
Jul 26 10:15:50 enea vesafb: framebuffer at 0x98000000, mapped to 0xe0880000, using 3072k, total 32704k
Jul 26 10:15:50 enea vesafb: mode is 1024x768x16, linelength=2048, pages=20
Jul 26 10:15:50 enea vesafb: protected mode interface info at c000:59e9
Jul 26 10:15:50 enea vesafb: pmi: set display start = c00c5a57, set palette = c00c5a91
Jul 26 10:15:50 enea vesafb: pmi: ports = 2010 2016 2054 2038 203c 205c 2000 2004 20b0 20b2 20b4 
Jul 26 10:15:50 enea vesafb: scrolling: ywrap using protected mode interface, yres_virtual=1536
Jul 26 10:15:50 enea vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
Jul 26 10:15:50 enea Console: switching to colour frame buffer device 128x48
Jul 26 10:15:50 enea fb0: VESA VGA frame buffer device
Jul 26 10:15:50 enea input: Power Button (FF) as /class/input/input0
Jul 26 10:15:50 enea ACPI: Power Button (FF) [PWRF]
Jul 26 10:15:50 enea input: Sleep Button (CM) as /class/input/input1
Jul 26 10:15:50 enea ACPI: Sleep Button (CM) [C13A]
Jul 26 10:15:50 enea input: Lid Switch as /class/input/input2
Jul 26 10:15:50 enea ACPI: Lid Switch [C139]
Jul 26 10:15:50 enea ACPI: Transitioning device [C206] to D3
Jul 26 10:15:50 enea fan PNP0C0B:00: registered as cooling_device0
Jul 26 10:15:50 enea ACPI: Fan [C206] (off)
Jul 26 10:15:50 enea ACPI: Transitioning device [C207] to D3
Jul 26 10:15:50 enea fan PNP0C0B:01: registered as cooling_device1
Jul 26 10:15:50 enea ACPI: Fan [C207] (off)
Jul 26 10:15:50 enea ACPI: Transitioning device [C208] to D3
Jul 26 10:15:50 enea fan PNP0C0B:02: registered as cooling_device2
Jul 26 10:15:50 enea ACPI: Fan [C208] (off)
Jul 26 10:15:50 enea ACPI: Transitioning device [C209] to D3
Jul 26 10:15:50 enea fan PNP0C0B:03: registered as cooling_device3
Jul 26 10:15:50 enea ACPI: Fan [C209] (off)
Jul 26 10:15:50 enea ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
Jul 26 10:15:50 enea processor ACPI0007:00: registered as cooling_device4
Jul 26 10:15:50 enea ACPI: Processor [CPU0] (supports 8 throttling states)
Jul 26 10:15:50 enea thermal LNXTHERM:01: registered as thermal_zone0
Jul 26 10:15:50 enea ACPI: Thermal Zone [TZ1] (60 C)
Jul 26 10:15:50 enea thermal LNXTHERM:02: registered as thermal_zone1
Jul 26 10:15:50 enea ACPI: Thermal Zone [TZ2] (47 C)
Jul 26 10:15:50 enea thermal LNXTHERM:03: registered as thermal_zone2
Jul 26 10:15:50 enea ACPI: Thermal Zone [TZ3] (36 C)
Jul 26 10:15:50 enea Real Time Clock Driver v1.12ac
Jul 26 10:15:50 enea Linux agpgart interface v0.103
Jul 26 10:15:50 enea agpgart: Detected an Intel 855PM Chipset.
Jul 26 10:15:50 enea agpgart: AGP aperture is 256M @ 0xb0000000
Jul 26 10:15:50 enea Serial: 8250/16550 driver4 ports, IRQ sharing disabled
Jul 26 10:15:50 enea serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 26 10:15:50 enea serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
Jul 26 10:15:50 enea 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C3] enabled at IRQ 11
Jul 26 10:15:50 enea PCI: setting IRQ 11 as level-triggered
Jul 26 10:15:50 enea serial 0000:00:1f.6: PCI INT B -> Link[C0C3] -> GSI 11 (level, low) -> IRQ 11
Jul 26 10:15:50 enea serial 0000:00:1f.6: PCI INT B disabled
Jul 26 10:15:50 enea brd: module loaded
Jul 26 10:15:50 enea Driver 'sd' needs updating - please use bus_type methods
Jul 26 10:15:50 enea ata_piix 0000:00:1f.1: version 2.12
Jul 26 10:15:50 enea ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
Jul 26 10:15:50 enea ata_piix 0000:00:1f.1: PCI INT A -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:50 enea PCI: Setting latency timer of device 0000:00:1f.1 to 64
Jul 26 10:15:50 enea scsi0 : ata_piix
Jul 26 10:15:50 enea scsi1 : ata_piix
Jul 26 10:15:50 enea ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x3c20 irq 14
Jul 26 10:15:50 enea ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x3c28 irq 15
Jul 26 10:15:50 enea ata1.00: ATA-6: FUJITSU MHT2040AH, 006C, max UDMA/100
Jul 26 10:15:50 enea ata1.00: 78140160 sectors, multi 16: LBA 
Jul 26 10:15:50 enea ata1.00: configured for UDMA/100
Jul 26 10:15:50 enea Switched to high resolution mode on CPU 0
Jul 26 10:15:50 enea ata2.00: ATAPI: SD-R2512, 1A04, max MWDMA2
Jul 26 10:15:50 enea ata2.00: configured for MWDMA2
Jul 26 10:15:50 enea scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHT2040A 006C PQ: 0 ANSI: 5
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] Write Protect is off
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors (40008 MB)
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] Write Protect is off
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 26 10:15:50 enea sda: sda1 sda2 sda3 < sda5 >
Jul 26 10:15:50 enea sd 0:0:0:0: [sda] Attached SCSI disk
Jul 26 10:15:50 enea scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-R2512 1A04 PQ: 0 ANSI: 5
Jul 26 10:15:50 enea PNP: PS/2 Controller [PNP0303:C193,PNP0f13:C194] at 0x60,0x64 irq 1,12
Jul 26 10:15:50 enea i8042.c: Detected active multiplexing controller, rev 1.1.
Jul 26 10:15:50 enea serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 26 10:15:50 enea serio: i8042 AUX0 port at 0x60,0x64 irq 12
Jul 26 10:15:50 enea serio: i8042 AUX1 port at 0x60,0x64 irq 12
Jul 26 10:15:50 enea serio: i8042 AUX2 port at 0x60,0x64 irq 12
Jul 26 10:15:50 enea serio: i8042 AUX3 port at 0x60,0x64 irq 12
Jul 26 10:15:50 enea mice: PS/2 mouse device common for all mice
Jul 26 10:15:50 enea input: AT Translated Set 2 keyboard as /class/input/input3
Jul 26 10:15:50 enea cpuidle: using governor ladder
Jul 26 10:15:50 enea cpuidle: using governor menu
Jul 26 10:15:50 enea TCP cubic registered
Jul 26 10:15:50 enea NET: Registered protocol family 10
Jul 26 10:15:50 enea IPv6 over IPv4 tunneling driver
Jul 26 10:15:50 enea NET: Registered protocol family 17
Jul 26 10:15:50 enea Using IPI Shortcut mode
Jul 26 10:15:50 enea Marking TSC unstable due to TSC halts in idle
Jul 26 10:15:50 enea Clocksource tsc unstable (delta = -249740425 ns)
Jul 26 10:15:50 enea Synaptics Touchpad, model: 1, fw: 5.9, id: 0x1b6eb1, caps: 0xa84793/0x100000
Jul 26 10:15:50 enea serio: Synaptics pass-through port at isa0060/serio4/input0
Jul 26 10:15:50 enea input: SynPS/2 Synaptics TouchPad as /class/input/input4
Jul 26 10:15:50 enea kjournald starting.  Commit interval 5 seconds
Jul 26 10:15:50 enea EXT3-fs: mounted filesystem with ordered data mode.
Jul 26 10:15:50 enea VFS: Mounted root (ext3 filesystem) readonly.
Jul 26 10:15:50 enea Freeing unused kernel memory: 224k freed
Jul 26 10:15:50 enea Write protecting the kernel text: 2080k
Jul 26 10:15:50 enea Write protecting the kernel read-only data: 624k
Jul 26 10:15:50 enea ACPI: AC Adapter [C135] (on-line)
Jul 26 10:15:50 enea Driver 'sr' needs updating - please use bus_type methods
Jul 26 10:15:50 enea ACPI: Battery Slot [C138] (battery present)
Jul 26 10:15:50 enea ACPI: Battery Slot [C137] (battery absent)
Jul 26 10:15:50 enea sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Jul 26 10:15:50 enea Uniform CD-ROM driver Revision: 3.20
Jul 26 10:15:50 enea sr 1:0:0:0: Attached scsi CD-ROM sr0
Jul 26 10:15:50 enea i801_smbus 0000:00:1f.3: PCI INT B -> Link[C0C3] -> GSI 11 (level, low) -> IRQ 11
Jul 26 10:15:50 enea ACPI: I/O resource 0000:00:1f.3 [0x1200-0x121f] conflicts with ACPI region C088 [0x1200-0x1205]
Jul 26 10:15:50 enea ACPI: Device needs an ACPI driver
Jul 26 10:15:50 enea tg3.c:v3.93 (May 22, 2008)
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C6] enabled at IRQ 11
Jul 26 10:15:50 enea tg3 0000:02:0e.0: PCI INT A -> Link[C0C6] -> GSI 11 (level, low) -> IRQ 11
Jul 26 10:15:50 enea eth0: Tigon3 [partno(BMC5705mA3) rev 3003 PHY(5705)] (PCI:33MHz:32-bit) 10/100/1000Base-T Ethernet 00:12:79:56:f0:f2
Jul 26 10:15:50 enea eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]
Jul 26 10:15:50 enea eth0: dma_rwctrl[763f0000] dma_mask[64-bit]
Jul 26 10:15:50 enea Yenta: CardBus bridge found at 0000:02:06.0 [103c:0890]
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.0: CardBus bridge, secondary bus 0000:03
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.0:   IO window: 0x004000-0x0040ff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.0:   IO window: 0x004400-0x0044ff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.0:   PREFETCH window: 0x30020000-0x3003ffff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.0:   MEM window: 0x34000000-0x37ffffff
Jul 26 10:15:50 enea Yenta O2: res at 0x94/0xD4: ea/00
Jul 26 10:15:50 enea Yenta O2: enabling read prefetch/write burst
Jul 26 10:15:50 enea Yenta: ISA IRQ mask 0x00b8, PCI irq 10
Jul 26 10:15:50 enea Socket status: 30000006
Jul 26 10:15:50 enea pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
Jul 26 10:15:50 enea pcmcia: parent PCI bridge Memory window: 0x90000000 - 0x902fffff
Jul 26 10:15:50 enea pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x300fffff
Jul 26 10:15:50 enea Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
Jul 26 10:15:50 enea Intel ICH 0000:00:1f.5: PCI INT B -> Link[C0C3] -> GSI 11 (level, low) -> IRQ 11
Jul 26 10:15:50 enea PCI: Setting latency timer of device 0000:00:1f.5 to 64
Jul 26 10:15:50 enea Yenta: CardBus bridge found at 0000:02:06.1 [103c:0890]
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.1: CardBus bridge, secondary bus 0000:05
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.1:   IO window: 0x004800-0x0048ff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.1:   IO window: 0x004c00-0x004cff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.1:   PREFETCH window: 0x30040000-0x3005ffff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.1:   MEM window: 0x38000000-0x3bffffff
Jul 26 10:15:50 enea usbcore: registered new interface driver usbfs
Jul 26 10:15:50 enea usbcore: registered new interface driver hub
Jul 26 10:15:50 enea usbcore: registered new device driver usb
Jul 26 10:15:50 enea USB Universal Host Controller Interface driver v3.0
Jul 26 10:15:50 enea Yenta: ISA IRQ mask 0x00b8, PCI irq 10
Jul 26 10:15:50 enea Socket status: 30000006
Jul 26 10:15:50 enea Yenta: Raising subordinate bus# of parent bus (#02) from #05 to #08
Jul 26 10:15:50 enea pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
Jul 26 10:15:50 enea pcmcia: parent PCI bridge Memory window: 0x90000000 - 0x902fffff
Jul 26 10:15:50 enea pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x300fffff
Jul 26 10:15:50 enea Yenta: CardBus bridge found at 0000:02:06.3 [103c:0890]
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.3: CardBus bridge, secondary bus 0000:09
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.3:   IO window: 0x001400-0x0014ff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.3:   IO window: 0x001800-0x0018ff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.3:   PREFETCH window: 0x30060000-0x3007ffff
Jul 26 10:15:50 enea yenta_cardbus 0000:02:06.3:   MEM window: 0x3c000000-0x3fffffff
Jul 26 10:15:50 enea Yenta: ISA IRQ mask 0x00b8, PCI irq 10
Jul 26 10:15:50 enea Socket status: 30000006
Jul 26 10:15:50 enea Yenta: Raising subordinate bus# of parent bus (#02) from #08 to #0c
Jul 26 10:15:50 enea pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
Jul 26 10:15:50 enea pcmcia: parent PCI bridge Memory window: 0x90000000 - 0x902fffff
Jul 26 10:15:50 enea pcmcia: parent PCI bridge Memory window: 0x30000000 - 0x300fffff
Jul 26 10:15:50 enea AC'97 0 analog subsections not ready
Jul 26 10:15:50 enea intel8x0_measure_ac97_clock: measured 50726 usecs
Jul 26 10:15:50 enea intel8x0: measured clock 216 rejected
Jul 26 10:15:50 enea intel8x0: clocking to 48000
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C2] enabled at IRQ 10
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.0: PCI INT A -> Link[C0C2] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:50 enea PCI: Setting latency timer of device 0000:00:1d.0 to 64
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.0: UHCI Host Controller
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.0: irq 10, io base 0x000038c0
Jul 26 10:15:50 enea usb usb1: configuration #1 chosen from 1 choice
Jul 26 10:15:50 enea hub 1-0:1.0: USB hub found
Jul 26 10:15:50 enea hub 1-0:1.0: 2 ports detected
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C9] enabled at IRQ 10
Jul 26 10:15:50 enea ehci_hcd 0000:00:1d.7: PCI INT D -> Link[C0C9] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:50 enea PCI: Setting latency timer of device 0000:00:1d.7 to 64
Jul 26 10:15:50 enea ehci_hcd 0000:00:1d.7: EHCI Host Controller
Jul 26 10:15:50 enea ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
Jul 26 10:15:50 enea ehci_hcd 0000:00:1d.7: debug port 1
Jul 26 10:15:50 enea ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
Jul 26 10:15:50 enea ehci_hcd 0000:00:1d.7: irq 10, io mem 0xa0000000
Jul 26 10:15:50 enea ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
Jul 26 10:15:50 enea usb usb2: configuration #1 chosen from 1 choice
Jul 26 10:15:50 enea hub 2-0:1.0: USB hub found
Jul 26 10:15:50 enea hub 2-0:1.0: 6 ports detected
Jul 26 10:15:50 enea ACPI: PCI Interrupt Link [C0C5] enabled at IRQ 10
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.1: PCI INT B -> Link[C0C5] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:50 enea PCI: Setting latency timer of device 0000:00:1d.1 to 64
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.1: UHCI Host Controller
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.1: irq 10, io base 0x000038e0
Jul 26 10:15:50 enea usb usb3: configuration #1 chosen from 1 choice
Jul 26 10:15:50 enea hub 3-0:1.0: USB hub found
Jul 26 10:15:50 enea hub 3-0:1.0: 2 ports detected
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.2: PCI INT C -> Link[C0C4] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:50 enea PCI: Setting latency timer of device 0000:00:1d.2 to 64
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.2: UHCI Host Controller
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
Jul 26 10:15:50 enea uhci_hcd 0000:00:1d.2: irq 10, io base 0x00003c00
Jul 26 10:15:50 enea usb usb4: configuration #1 chosen from 1 choice
Jul 26 10:15:50 enea hub 4-0:1.0: USB hub found
Jul 26 10:15:50 enea hub 4-0:1.0: 2 ports detected
Jul 26 10:15:50 enea EXT3 FS on sda1, internal journal
Jul 26 10:15:50 enea kjournald starting.  Commit interval 5 seconds
Jul 26 10:15:50 enea EXT3 FS on sda2, internal journal
Jul 26 10:15:50 enea EXT3-fs: mounted filesystem with ordered data mode.
Jul 26 10:15:50 enea microcode: CPU0 updated from revision 0x17 to 0x18, date = 10172004 
Jul 26 10:15:50 enea Adding 982760k swap on /dev/sda5.  Priority:-1 extents:1 across:982760k
Jul 26 10:15:50 enea acpid: starting up
Jul 26 10:15:50 enea acpid: 1 rule loaded
Jul 26 10:15:52 enea acpid: client connected from 2192[102:408]
Jul 26 10:15:52 enea acpid: 1 client rule loaded
Jul 26 10:15:53 enea NetworkManager: <info>  starting...
Jul 26 10:15:53 enea ADDRCONF(NETDEV_UP): eth0: link is not ready
Jul 26 10:15:53 enea NetworkManager: <debug> [1217060153.580274] GentooReadConfig(): Enabling DHCP for device eth0.
Jul 26 10:15:53 enea NetworkManager: <info>  eth0: Device is fully-supported using driver '(null)'.
Jul 26 10:15:53 enea NetworkManager: <info>  nm_device_init(): waiting for device's worker thread to start
Jul 26 10:15:53 enea NetworkManager: <info>  nm_device_init(): device's worker thread started, continuing.
Jul 26 10:15:53 enea NetworkManager: <info>  Now managing wired Ethernet (802.3) device 'eth0'.
Jul 26 10:15:53 enea NetworkManager: <info>  Deactivating device eth0.
Jul 26 10:15:53 enea NetworkManager: <info>  Will activate wired connection 'eth0' because it now has a link.
Jul 26 10:15:55 enea tg3: eth0: Link is up at 100 Mbps, full duplex.
Jul 26 10:15:55 enea tg3: eth0: Flow control is off for TX and off for RX.
Jul 26 10:15:55 enea ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Jul 26 10:15:55 enea NetworkManager: <info>  Will activate wired connection 'eth0' because it now has a link.
Jul 26 10:15:55 enea NetworkManager: <info>  SWITCH: no current connection, found better connection 'eth0'.
Jul 26 10:15:55 enea dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.reason
Jul 26 10:15:55 enea NetworkManager: <info>  Will activate connection 'eth0'.
Jul 26 10:15:55 enea NetworkManager: <info>  Device eth0 activation scheduled...
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) started...
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 1 of 5 (Device Prepare) scheduled...
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 1 of 5 (Device Prepare) started...
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 2 of 5 (Device Configure) scheduled...
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 1 of 5 (Device Prepare) complete.
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 2 of 5 (Device Configure) starting...
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 2 of 5 (Device Configure) successful.
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 3 of 5 (IP Configure Start) scheduled.
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 2 of 5 (Device Configure) complete.
Jul 26 10:15:55 enea NetworkManager: <info>  Activation (eth0) Stage 3 of 5 (IP Configure Start) started...
Jul 26 10:15:55 enea avahi-daemon[2292]: Found user 'avahi' (UID 110) and group 'avahi' (GID 1012).
Jul 26 10:15:55 enea avahi-daemon[2292]: Successfully dropped root privileges.
Jul 26 10:15:55 enea avahi-daemon[2292]: avahi-daemon 0.6.23 starting up.
Jul 26 10:15:55 enea avahi-daemon[2292]: WARNING: No NSS support for mDNS detected, consider installing nss-mdns!
Jul 26 10:15:55 enea avahi-daemon[2292]: Successfully called chroot().
Jul 26 08:15:55 enea avahi-daemon[2292]: Successfully dropped remaining capabilities.
Jul 26 08:15:55 enea avahi-daemon[2292]: Loading service file /services/sftp-ssh.service.
Jul 26 08:15:55 enea avahi-daemon[2292]: Loading service file /services/ssh.service.
Jul 26 08:15:55 enea avahi-daemon[2292]: Joining mDNS multicast group on interface eth0.IPv6 with address fe80::212:79ff:fe56:f0f2.
Jul 26 08:15:55 enea avahi-daemon[2292]: New relevant interface eth0.IPv6 for mDNS.
Jul 26 08:15:55 enea avahi-daemon[2292]: Network interface enumeration completed.
Jul 26 08:15:55 enea avahi-daemon[2292]: Registering new address record for fe80::212:79ff:fe56:f0f2 on eth0.*.
Jul 26 08:15:55 enea avahi-daemon[2292]: Registering HINFO record with values 'I686'/'LINUX'.
Jul 26 10:15:56 enea acpid: client connected from 2275[0:0]
Jul 26 10:15:56 enea acpid: 1 client rule loaded
Jul 26 10:15:56 enea NetworkManager: <info>  Activation (eth0) Beginning DHCP transaction.
Jul 26 10:15:56 enea NetworkManager: <info>  DHCP daemon state is now 12 (successfully started) for interface eth0
Jul 26 10:15:56 enea NetworkManager: <info>  Activation (eth0) Stage 3 of 5 (IP Configure Start) complete.
Jul 26 10:15:56 enea dhclient: can't create /var/lib/dhclient/dhclient-eth0.leases: No such file or directory
Jul 26 08:15:56 enea avahi-daemon[2292]: Server startup complete. Host name is enea.local. Local service cookie is 2907028272.
Jul 26 10:15:57 enea [drm] Initialized drm 1.1.0 20060810
Jul 26 08:15:57 enea avahi-daemon[2292]: Service "enea" (/services/ssh.service) successfully established.
Jul 26 08:15:57 enea avahi-daemon[2292]: Service "SFTP File Transfer on enea" (/services/sftp-ssh.service) successfully established.
Jul 26 10:15:57 enea pci 0000:01:00.0: PCI INT A -> Link[C0C2] -> GSI 10 (level, low) -> IRQ 10
Jul 26 10:15:57 enea [drm] Initialized radeon 1.29.0 20080528 on minor 0
Jul 26 10:15:57 enea NetworkManager: <debug> [1217060157.797092] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/pci_1002_4e50_drm_r300_card0').
Jul 26 10:15:57 enea ntpd[2379]: ntpd 4.2.4p4@1.1520-o Fri Oct 26 08:52:43 UTC 2007 (1)
Jul 26 10:15:57 enea ntpd[2384]: precision = 2.000 usec
Jul 26 10:15:57 enea ntpd[2384]: Listening on interface #0 wildcard, 0.0.0.0#123 Disabled
Jul 26 10:15:57 enea ntpd[2384]: Listening on interface #1 wildcard, ::#123 Disabled
Jul 26 10:15:57 enea ntpd[2384]: Listening on interface #2 lo, ::1#123 Enabled
Jul 26 10:15:57 enea ntpd[2384]: Listening on interface #3 eth0, fe80::212:79ff:fe56:f0f2#123 Enabled
Jul 26 10:15:57 enea ntpd[2384]: Listening on interface #4 lo, 127.0.0.1#123 Enabled
Jul 26 10:15:57 enea ntpd[2384]: kernel time sync status 0040
Jul 26 10:15:57 enea ntpd[2384]: frequency initialized 3.458 PPM from /var/lib/ntp/ntp.drift
Jul 26 10:15:58 enea NetworkManager: <info>  DHCP daemon state is now 1 (starting) for interface eth0
Jul 26 10:15:59 enea dhclient: DHCPDISCOVER on eth0 to 255.255.255.255 port 67 interval 4
Jul 26 10:15:59 enea smartd[2423]: smartd version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Jul 26 10:15:59 enea smartd[2423]: Home page is http://smartmontools.sourceforge.net/
Jul 26 10:15:59 enea smartd[2423]: Opened configuration file /etc/smartd.conf
Jul 26 10:15:59 enea smartd[2423]: Configuration file /etc/smartd.conf parsed.
Jul 26 10:15:59 enea smartd[2423]: Device: /dev/sda, opened
Jul 26 10:15:59 enea smartd[2423]: Device: /dev/sda, found in smartd database.
Jul 26 10:16:00 enea smartd[2423]: Device: /dev/sda, is SMART capable. Adding to "monitor" list.
Jul 26 10:16:00 enea smartd[2423]: Monitoring 1 ATA and 0 SCSI devices
Jul 26 10:16:00 enea smartd[2425]: smartd has fork()ed into background mode. New PID=2425.
Jul 26 10:16:00 enea smartd[2425]: file /var/run/smartd.pid written containing PID 2425
Jul 26 10:16:00 enea dhclient: DHCPOFFER from 192.168.10.254
Jul 26 10:16:00 enea dhclient: DHCPREQUEST on eth0 to 255.255.255.255 port 67
Jul 26 10:16:00 enea dhclient: DHCPACK from 192.168.10.254
Jul 26 08:16:00 enea avahi-daemon[2292]: Joining mDNS multicast group on interface eth0.IPv4 with address 192.168.10.14.
Jul 26 08:16:00 enea avahi-daemon[2292]: New relevant interface eth0.IPv4 for mDNS.
Jul 26 08:16:00 enea avahi-daemon[2292]: Registering new address record for 192.168.10.14 on eth0.IPv4.
Jul 26 10:16:00 enea NetworkManager: <info>  DHCP daemon state is now 2 (bound) for interface eth0
Jul 26 10:16:00 enea NetworkManager: <info>  Activation (eth0) Stage 4 of 5 (IP Configure Get) scheduled...
Jul 26 10:16:00 enea NetworkManager: <info>  Activation (eth0) Stage 4 of 5 (IP Configure Get) started...
Jul 26 10:16:00 enea dhclient: can't create /var/lib/dhclient/dhclient-eth0.leases: No such file or directory
Jul 26 10:16:00 enea dhclient: bound to 192.168.10.14 -- renewal in 41283 seconds.
Jul 26 10:16:00 enea dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_domain
Jul 26 10:16:00 enea dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.nis_servers
Jul 26 10:16:00 enea NetworkManager: <info>  Retrieved the following IP4 configuration from the DHCP daemon:
Jul 26 10:16:00 enea NetworkManager: <info>    address 192.168.10.14
Jul 26 10:16:00 enea NetworkManager: <info>    netmask 255.255.255.0
Jul 26 10:16:00 enea NetworkManager: <info>    broadcast 192.168.10.255
Jul 26 10:16:00 enea NetworkManager: <info>    gateway 192.168.10.254
Jul 26 10:16:00 enea NetworkManager: <info>    nameserver 192.168.10.254
Jul 26 10:16:00 enea NetworkManager: <info>    hostname 'enea'
Jul 26 10:16:00 enea NetworkManager: <info>    domain name 'home'
Jul 26 10:16:00 enea dhcdbd: message_handler: message handler not found under /com/redhat/dhcp/eth0 for sub-path eth0.dbus.get.interface_mtu
Jul 26 10:16:00 enea NetworkManager: <info>  Activation (eth0) Stage 5 of 5 (IP Configure Commit) scheduled...
Jul 26 10:16:00 enea NetworkManager: <info>  Activation (eth0) Stage 4 of 5 (IP Configure Get) complete.
Jul 26 10:16:00 enea NetworkManager: <info>  Activation (eth0) Stage 5 of 5 (IP Configure Commit) started...
Jul 26 08:16:00 enea avahi-daemon[2292]: Withdrawing address record for 192.168.10.14 on eth0.
Jul 26 08:16:00 enea avahi-daemon[2292]: Leaving mDNS multicast group on interface eth0.IPv4 with address 192.168.10.14.
Jul 26 08:16:00 enea avahi-daemon[2292]: Interface eth0.IPv4 no longer relevant for mDNS.
Jul 26 08:16:00 enea avahi-daemon[2292]: Withdrawing address record for fe80::212:79ff:fe56:f0f2 on eth0.
Jul 26 08:16:00 enea avahi-daemon[2292]: Leaving mDNS multicast group on interface eth0.IPv6 with address fe80::212:79ff:fe56:f0f2.
Jul 26 08:16:00 enea avahi-daemon[2292]: Interface eth0.IPv6 no longer relevant for mDNS.
Jul 26 08:16:00 enea avahi-daemon[2292]: Joining mDNS multicast group on interface eth0.IPv4 with address 192.168.10.14.
Jul 26 08:16:00 enea avahi-daemon[2292]: New relevant interface eth0.IPv4 for mDNS.
Jul 26 08:16:00 enea avahi-daemon[2292]: Registering new address record for 192.168.10.14 on eth0.IPv4.
Jul 26 10:16:00 enea agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
Jul 26 10:16:00 enea agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
Jul 26 10:16:00 enea agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
Jul 26 10:16:01 enea NetworkManager: <info>  Setting hostname to 'enea'
Jul 26 10:16:01 enea NetworkManager: <info>  Activation (eth0) successful, device activated.
Jul 26 10:16:01 enea NetworkManager: <info>  Activation (eth0) Finish handler scheduled.
Jul 26 10:16:01 enea NetworkManager: <info>  Activation (eth0) Stage 5 of 5 (IP Configure Commit) complete.
Jul 26 10:16:02 enea [drm] Setting GART location based on new memory map
Jul 26 10:16:02 enea [drm] Loading R300 Microcode
Jul 26 10:16:02 enea [drm] Num pipes: 1
Jul 26 10:16:02 enea [drm] writeback test succeeded in 2 usecs
Jul 26 08:16:03 enea avahi-daemon[2292]: Joining mDNS multicast group on interface eth0.IPv6 with address fe80::212:79ff:fe56:f0f2.
Jul 26 08:16:03 enea avahi-daemon[2292]: New relevant interface eth0.IPv6 for mDNS.
Jul 26 08:16:03 enea avahi-daemon[2292]: Registering new address record for fe80::212:79ff:fe56:f0f2 on eth0.*.
Jul 26 10:16:12 enea eth0: no IPv6 routers present
Jul 26 10:16:13 enea ntpdate[2511]: step time server 79.99.122.29 offset 0.891066 sec
Jul 26 10:16:31 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:16:31 enea acpid: notifying client 2192[102:408]
Jul 26 10:16:31 enea acpid: notifying client 2275[0:0]
Jul 26 10:16:31 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:16:31 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:16:31 enea acpid: action exited with status 0
Jul 26 10:16:31 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:17:00 enea acpid: received event "battery C138 00000080 00000001"
Jul 26 10:17:00 enea acpid: notifying client 2192[102:408]
Jul 26 10:17:00 enea acpid: notifying client 2275[0:0]
Jul 26 10:17:00 enea acpid: executing action "/etc/acpi/default.sh battery C138 00000080 00000001"
Jul 26 10:17:00 enea logger: ACPI event unhandled: battery C138 00000080 00000001
Jul 26 10:17:00 enea acpid: action exited with status 0
Jul 26 10:17:00 enea acpid: completed event "battery C138 00000080 00000001"
Jul 26 10:17:10 enea ntpd[2384]: Cannot find existing interface for address 194.78.18.221
Jul 26 10:17:10 enea ntpd_initres[2385]: ntpd indicates no data available!
Jul 26 10:17:34 enea kdm: :0[2298]: pam_unix(kde:auth): authentication failure; logname= uid=0 euid=0 tty=:0 ruser= rhost=  user=cedric
Jul 26 10:17:39 enea kdm: :0[2298]: pam_unix(kde:session): session opened for user cedric by (uid=0)
Jul 26 10:17:43 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:17:43 enea acpid: notifying client 2192[102:408]
Jul 26 10:17:43 enea acpid: notifying client 2275[0:0]
Jul 26 10:17:43 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:17:43 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:17:43 enea acpid: action exited with status 0
Jul 26 10:17:43 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:00 enea ntpd[2384]: Cannot find existing interface for address 194.78.18.221
Jul 26 10:18:00 enea ntpd_initres[2385]: ntpd indicates no data available!
Jul 26 10:18:12 enea acpid: received event "battery C138 00000080 00000001"
Jul 26 10:18:12 enea acpid: notifying client 2192[102:408]
Jul 26 10:18:12 enea acpid: notifying client 2275[0:0]
Jul 26 10:18:12 enea acpid: executing action "/etc/acpi/default.sh battery C138 00000080 00000001"
Jul 26 10:18:12 enea logger: ACPI event unhandled: battery C138 00000080 00000001
Jul 26 10:18:12 enea acpid: action exited with status 0
Jul 26 10:18:12 enea acpid: completed event "battery C138 00000080 00000001"
Jul 26 10:18:23 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:23 enea acpid: notifying client 2192[102:408]
Jul 26 10:18:23 enea acpid: notifying client 2275[0:0]
Jul 26 10:18:23 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:23 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:18:23 enea acpid: action exited with status 0
Jul 26 10:18:23 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:24 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:24 enea acpid: notifying client 2192[102:408]
Jul 26 10:18:24 enea acpid: notifying client 2275[0:0]
Jul 26 10:18:24 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:24 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:18:24 enea acpid: action exited with status 0
Jul 26 10:18:24 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:35 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:35 enea acpid: notifying client 2192[102:408]
Jul 26 10:18:35 enea acpid: notifying client 2275[0:0]
Jul 26 10:18:35 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:35 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:18:35 enea acpid: action exited with status 0
Jul 26 10:18:35 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:57 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:57 enea acpid: notifying client 2192[102:408]
Jul 26 10:18:57 enea acpid: notifying client 2275[0:0]
Jul 26 10:18:57 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:18:57 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:18:57 enea acpid: action exited with status 0
Jul 26 10:18:57 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:00 enea ntpd[2384]: Cannot find existing interface for address 194.78.18.221
Jul 26 10:19:00 enea ntpd_initres[2385]: ntpd indicates no data available!
Jul 26 10:19:07 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:07 enea acpid: notifying client 2192[102:408]
Jul 26 10:19:07 enea acpid: notifying client 2275[0:0]
Jul 26 10:19:07 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:07 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:19:07 enea acpid: action exited with status 0
Jul 26 10:19:07 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:11 enea su[2878]: Successful su for root by cedric
Jul 26 10:19:11 enea su[2878]: + pts/2 cedric:root
Jul 26 10:19:11 enea su[2878]: pam_unix(su:session): session opened for user root by (uid=1000)
Jul 26 10:19:17 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:17 enea acpid: notifying client 2192[102:408]
Jul 26 10:19:17 enea acpid: notifying client 2275[0:0]
Jul 26 10:19:17 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:17 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:19:17 enea acpid: action exited with status 0
Jul 26 10:19:17 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:24 enea acpid: received event "battery C138 00000080 00000001"
Jul 26 10:19:24 enea acpid: notifying client 2192[102:408]
Jul 26 10:19:24 enea acpid: notifying client 2275[0:0]
Jul 26 10:19:24 enea acpid: executing action "/etc/acpi/default.sh battery C138 00000080 00000001"
Jul 26 10:19:24 enea logger: ACPI event unhandled: battery C138 00000080 00000001
Jul 26 10:19:24 enea acpid: action exited with status 0
Jul 26 10:19:24 enea acpid: completed event "battery C138 00000080 00000001"
Jul 26 10:19:33 enea usb 1-2: new full speed USB device using uhci_hcd and address 2
Jul 26 10:19:33 enea usb 1-2: configuration #1 chosen from 1 choice
Jul 26 10:19:33 enea NetworkManager: <debug> [1217060373.876125] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896').
Jul 26 10:19:33 enea Initializing USB Mass Storage driver...
Jul 26 10:19:33 enea usb-storage: USB Mass Storage device detected
Jul 26 10:19:33 enea usb-storage: -- associate_dev
Jul 26 10:19:33 enea usb-storage: Vendor: 0x0421, Product: 0x04b9, Revision: 0x0551
Jul 26 10:19:33 enea usb-storage: Interface Subclass: 0x06, Protocol: 0x50
Jul 26 10:19:33 enea usb-storage: Transport: Bulk
Jul 26 10:19:33 enea usb-storage: Protocol: Transparent SCSI
Jul 26 10:19:33 enea scsi2 : SCSI emulation for USB Mass Storage devices
Jul 26 10:19:33 enea usb-storage: *** thread sleeping.
Jul 26 10:19:33 enea usbcore: registered new interface driver usb-storage
Jul 26 10:19:33 enea USB Mass Storage support registered.
Jul 26 10:19:33 enea usb-storage: device found at 2
Jul 26 10:19:33 enea usb-storage: waiting for device to settle before scanning
Jul 26 10:19:33 enea NetworkManager: <debug> [1217060373.940605] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0').
Jul 26 10:19:33 enea NetworkManager: <debug> [1217060373.962606] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_usbraw').
Jul 26 10:19:38 enea usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
Jul 26 10:19:38 enea usb-storage: GetMaxLUN command result is 1, data is 0
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command INQUIRY (6 bytes)
Jul 26 10:19:38 enea usb-storage:  12 00 00 00 24 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 36/36
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:38 enea scsi 2:0:0:0: Direct-Access     Nokia    Nokia 5300       0000 PQ: 0 ANSI: 4
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:38 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x2 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea NetworkManager: <debug> [1217060378.958610] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0_scsi_host').
Jul 26 10:19:38 enea NetworkManager: <debug> [1217060378.961520] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0_scsi_host_scsi_device_lun0').
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x2 R 0 Stat 0x0
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command READ_CAPACITY (10 bytes)
Jul 26 10:19:38 enea usb-storage:  25 00 00 00 00 00 00 00 00 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 8/8
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:38 enea sd 2:0:0:0: [sdb] 3970049 512-byte hardware sectors (2033 MB)
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command MODE_SENSE (6 bytes)
Jul 26 10:19:38 enea usb-storage:  1a 00 3f 00 c0 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
Jul 26 10:19:38 enea usb-storage: Status code -121; transferred 4/192
Jul 26 10:19:38 enea usb-storage: -- short read transfer
Jul 26 10:19:38 enea usb-storage: Bulk data transfer result 0x1
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x4 R 188 Stat 0x0
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:38 enea sd 2:0:0:0: [sdb] Write Protect is off
Jul 26 10:19:38 enea sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
Jul 26 10:19:38 enea sd 2:0:0:0: [sdb] Assuming drive cache: write through
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:38 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x5 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x5 R 0 Stat 0x0
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Jul 26 10:19:38 enea usb-storage:  1e 00 00 00 01 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x6 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x6 R 0 Stat 0x1
Jul 26 10:19:38 enea usb-storage: -- transport indicates command failure
Jul 26 10:19:38 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x7 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 18/18
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x7 R 0 Stat 0x0
Jul 26 10:19:38 enea usb-storage: -- Result from auto-sense is 0
Jul 26 10:19:38 enea usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
Jul 26 10:19:38 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x2
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:38 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x8 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x8 R 0 Stat 0x0
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command READ_CAPACITY (10 bytes)
Jul 26 10:19:38 enea usb-storage:  25 00 00 00 00 00 00 00 00 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0x9 L 8 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 8/8
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0x9 R 0 Stat 0x0
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea sd 2:0:0:0: [sdb] 3970049 512-byte hardware sectors (2033 MB)
Jul 26 10:19:38 enea usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command MODE_SENSE (6 bytes)
Jul 26 10:19:38 enea usb-storage:  1a 00 3f 00 c0 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0xa L 192 F 128 Trg 0 LUN 0 CL 6
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
Jul 26 10:19:38 enea usb-storage: Status code -121; transferred 4/192
Jul 26 10:19:38 enea usb-storage: -- short read transfer
Jul 26 10:19:38 enea usb-storage: Bulk data transfer result 0x1
Jul 26 10:19:38 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk status result = 0
Jul 26 10:19:38 enea usb-storage: Bulk Status S 0x53425355 T 0xa R 188 Stat 0x0
Jul 26 10:19:38 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:38 enea usb-storage: *** thread sleeping.
Jul 26 10:19:38 enea sd 2:0:0:0: [sdb] Write Protect is off
Jul 26 10:19:38 enea sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
Jul 26 10:19:38 enea sd 2:0:0:0: [sdb] Assuming drive cache: write through
Jul 26 10:19:38 enea sdb:<7>usb-storage: queuecommand called
Jul 26 10:19:38 enea usb-storage: *** thread awakened.
Jul 26 10:19:38 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:38 enea usb-storage:  28 00 00 00 00 00 00 00 08 00
Jul 26 10:19:38 enea usb-storage: Bulk Command S 0x43425355 T 0xb L 4096 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:38 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:38 enea usb-storage: -- transfer complete
Jul 26 10:19:38 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:38 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 4096/4096
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0xb R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea sdb1
Jul 26 10:19:39 enea sd 2:0:0:0: [sdb] Attached SCSI removable disk
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Bad target number (1:0)
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x40000
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Bad target number (2:0)
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x40000
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Bad target number (3:0)
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x40000
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Bad target number (4:0)
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x40000
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Bad target number (5:0)
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x40000
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Bad target number (6:0)
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x40000
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Bad target number (7:0)
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x40000
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: device scan complete
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:39 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0xc L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0xc R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 00 00 00 20 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0xd L 16384 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 4 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 16384/16384
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 80 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0xe L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0xe R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 81 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0xf L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0xf R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 f0 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x10 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x10 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 f1 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x11 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x11 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 20 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x12 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x12 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 21 00 00 3f 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x13 L 32256 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 32256 bytes, 8 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 32256/32256
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x13 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x14 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code -32; transferred 0/512
Jul 26 10:19:39 enea usb-storage: clearing endpoint halt for pipe 0xc0008280
Jul 26 10:19:39 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 26 10:19:39 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x2
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x14 R 512 Stat 0x1
Jul 26 10:19:39 enea usb-storage: -- transport indicates command failure
Jul 26 10:19:39 enea usb-storage: -- unexpectedly short transfer
Jul 26 10:19:39 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x15 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 18/18
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x15 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: -- Result from auto-sense is 0
Jul 26 10:19:39 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 26 10:19:39 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x2
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 26 10:19:39 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 f8 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x16 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x16 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 f9 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x17 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x17 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 c0 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x18 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x18 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 c1 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x19 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x19 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 00 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x1a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x1a R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 93 01 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x1b L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x1b R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 92 70 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x1c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x1c R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 92 71 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x1d L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x1d R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 60 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x1e L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x1e R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 61 00 00 80 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x1f L 65536 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 65536 bytes, 17 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 65536/65536
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x1f R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 e1 00 00 80 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x20 L 65536 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 65536 bytes, 17 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 65536/65536
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x20 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 01 61 00 00 7f 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x21 L 65024 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 65024 bytes, 16 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 65024/65024
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x21 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 02 00 00 00 08 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x22 L 4096 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 4096/4096
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x22 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:39 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x23 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x23 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:39 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x24 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x24 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 00 00 00 20 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x25 L 16384 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 4 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 16384/16384
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x25 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:39 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x26 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x26 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 f9 00 00 20 00
Jul 26 10:19:39 enea NetworkManager: <debug> [1217060379.656142] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/storage_serial_Nokia_Nokia_5300_359815013364896_0_0').
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x27 L 16384 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 4 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 16384/16384
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x27 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 79 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x28 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x28 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 7a 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x29 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x29 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 e9 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x2a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x2a R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 ea 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x2b L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x2b R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 01 19 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x2c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x2c R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 01 1a 00 00 3f 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x2d L 32256 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 32256 bytes, 8 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 32256/32256
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x2d R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 f9 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x2e L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x2e R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 c1 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x2f R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 c2 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x30 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x30 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 01 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x31 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x31 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 02 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x32 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x32 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 88 f9 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x33 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x33 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 88 fa 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x34 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x34 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 88 71 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x35 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x35 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 88 72 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x36 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x36 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 f1 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x37 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x37 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 f2 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x38 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x38 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 02 d9 00 00 28 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x39 L 20480 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 20480 bytes, 5 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 20480/20480
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x39 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:39 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x3a L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x3a R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 f9 00 00 20 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x3b L 16384 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 4 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 16384/16384
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x3b R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 79 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x3c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x3c R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 7a 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x3d L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x3d R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 e9 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x3e L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x3e R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 ea 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x3f L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x3f R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 01 19 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x40 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x40 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 01 1a 00 00 3f 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x41 L 32256 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 32256 bytes, 8 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 32256/32256
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x41 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 f9 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x42 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x42 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 c1 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x43 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x43 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 c2 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x44 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x44 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 01 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x45 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x45 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 02 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x46 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x46 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 88 f9 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x47 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x47 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 88 fa 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x48 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x48 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 88 71 00 00 08 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x49 L 4096 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 4096/4096
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x49 R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 f1 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x4a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x4a R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 3c 89 f2 00 00 07 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x4b L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 3584/3584
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x4b R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 02 d9 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x4c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x4c R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 02 da 00 00 27 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x4d L 19968 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 19968 bytes, 5 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 19968/19968
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x4d R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:39 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x4e L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x4e R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 00 00 00 01 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x4f L 512 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 512/512
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:39 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk status result = 0
Jul 26 10:19:39 enea usb-storage: Bulk Status S 0x53425355 T 0x4f R 0 Stat 0x0
Jul 26 10:19:39 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:39 enea usb-storage: queuecommand called
Jul 26 10:19:39 enea usb-storage: *** thread sleeping.
Jul 26 10:19:39 enea usb-storage: *** thread awakened.
Jul 26 10:19:39 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:39 enea usb-storage:  28 00 00 00 00 01 00 00 1f 00
Jul 26 10:19:39 enea usb-storage: Bulk Command S 0x43425355 T 0x50 L 15872 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:39 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:39 enea usb-storage: -- transfer complete
Jul 26 10:19:39 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:39 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 15872 bytes, 4 entries
Jul 26 10:19:40 enea usb-storage: Status code 0; transferred 15872/15872
Jul 26 10:19:40 enea usb-storage: -- transfer complete
Jul 26 10:19:40 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:40 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:40 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:40 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:40 enea usb-storage: -- transfer complete
Jul 26 10:19:40 enea usb-storage: Bulk status result = 0
Jul 26 10:19:40 enea usb-storage: Bulk Status S 0x53425355 T 0x50 R 0 Stat 0x0
Jul 26 10:19:40 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:40 enea usb-storage: *** thread sleeping.
Jul 26 10:19:40 enea NetworkManager: <debug> [1217060380.018599] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/volume_uuid_3738_3662').
Jul 26 10:19:40 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:40 enea acpid: notifying client 2192[102:408]
Jul 26 10:19:40 enea acpid: notifying client 2275[0:0]
Jul 26 10:19:40 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:40 enea acpid: action exited with status 0
Jul 26 10:19:40 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:40 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:19:42 enea usb-storage: queuecommand called
Jul 26 10:19:42 enea usb-storage: *** thread awakened.
Jul 26 10:19:42 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:42 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:42 enea usb-storage: Bulk Command S 0x43425355 T 0x51 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:42 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk status result = 0
Jul 26 10:19:42 enea usb-storage: Bulk Status S 0x53425355 T 0x51 R 0 Stat 0x0
Jul 26 10:19:42 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:42 enea usb-storage: queuecommand called
Jul 26 10:19:42 enea usb-storage: *** thread sleeping.
Jul 26 10:19:42 enea usb-storage: *** thread awakened.
Jul 26 10:19:42 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:42 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:42 enea usb-storage: Bulk Command S 0x43425355 T 0x52 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:42 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk status result = 0
Jul 26 10:19:42 enea usb-storage: Bulk Status S 0x53425355 T 0x52 R 0 Stat 0x0
Jul 26 10:19:42 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:42 enea usb-storage: queuecommand called
Jul 26 10:19:42 enea usb-storage: *** thread sleeping.
Jul 26 10:19:42 enea usb-storage: *** thread awakened.
Jul 26 10:19:42 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:42 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:42 enea usb-storage: Bulk Command S 0x43425355 T 0x53 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:42 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk status result = 0
Jul 26 10:19:42 enea usb-storage: Bulk Status S 0x53425355 T 0x53 R 0 Stat 0x0
Jul 26 10:19:42 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:42 enea usb-storage: queuecommand called
Jul 26 10:19:42 enea usb-storage: *** thread sleeping.
Jul 26 10:19:42 enea usb-storage: *** thread awakened.
Jul 26 10:19:42 enea usb-storage: Command READ_10 (10 bytes)
Jul 26 10:19:42 enea usb-storage:  28 00 00 00 00 00 00 00 20 00
Jul 26 10:19:42 enea usb-storage: Bulk Command S 0x43425355 T 0x54 L 16384 F 128 Trg 0 LUN 0 CL 10
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 4 entries
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 16384/16384
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk data transfer result 0x0
Jul 26 10:19:42 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:42 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:42 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:42 enea usb-storage: -- transfer complete
Jul 26 10:19:42 enea usb-storage: Bulk status result = 0
Jul 26 10:19:42 enea usb-storage: Bulk Status S 0x53425355 T 0x54 R 0 Stat 0x0
Jul 26 10:19:42 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:42 enea usb-storage: *** thread sleeping.
Jul 26 10:19:44 enea usb-storage: queuecommand called
Jul 26 10:19:44 enea usb-storage: *** thread awakened.
Jul 26 10:19:44 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:44 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:44 enea usb-storage: Bulk Command S 0x43425355 T 0x55 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:44 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:44 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:44 enea usb-storage: -- transfer complete
Jul 26 10:19:44 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:44 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:44 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:44 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:44 enea usb-storage: -- transfer complete
Jul 26 10:19:44 enea usb-storage: Bulk status result = 0
Jul 26 10:19:44 enea usb-storage: Bulk Status S 0x53425355 T 0x55 R 0 Stat 0x0
Jul 26 10:19:44 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:44 enea usb-storage: *** thread sleeping.
Jul 26 10:19:46 enea usb-storage: queuecommand called
Jul 26 10:19:46 enea usb-storage: *** thread awakened.
Jul 26 10:19:46 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:46 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:46 enea usb-storage: Bulk Command S 0x43425355 T 0x56 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:46 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:46 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:46 enea usb-storage: -- transfer complete
Jul 26 10:19:46 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:46 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:46 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:46 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:46 enea usb-storage: -- transfer complete
Jul 26 10:19:46 enea usb-storage: Bulk status result = 0
Jul 26 10:19:46 enea usb-storage: Bulk Status S 0x53425355 T 0x56 R 0 Stat 0x0
Jul 26 10:19:46 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:46 enea usb-storage: *** thread sleeping.
Jul 26 10:19:48 enea usb-storage: queuecommand called
Jul 26 10:19:48 enea usb-storage: *** thread awakened.
Jul 26 10:19:48 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:48 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:48 enea usb-storage: Bulk Command S 0x43425355 T 0x57 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:48 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:48 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:48 enea usb-storage: -- transfer complete
Jul 26 10:19:48 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:48 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:48 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:48 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:48 enea usb-storage: -- transfer complete
Jul 26 10:19:48 enea usb-storage: Bulk status result = 0
Jul 26 10:19:48 enea usb-storage: Bulk Status S 0x53425355 T 0x57 R 0 Stat 0x0
Jul 26 10:19:48 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:48 enea usb-storage: *** thread sleeping.
Jul 26 10:19:50 enea usb-storage: queuecommand called
Jul 26 10:19:50 enea usb-storage: *** thread awakened.
Jul 26 10:19:50 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:50 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:50 enea usb-storage: Bulk Command S 0x43425355 T 0x58 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:50 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:50 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:50 enea usb-storage: -- transfer complete
Jul 26 10:19:50 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:50 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:50 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:50 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:50 enea usb-storage: -- transfer complete
Jul 26 10:19:50 enea usb-storage: Bulk status result = 0
Jul 26 10:19:50 enea usb-storage: Bulk Status S 0x53425355 T 0x58 R 0 Stat 0x0
Jul 26 10:19:50 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:50 enea usb-storage: *** thread sleeping.
Jul 26 10:19:52 enea usb-storage: queuecommand called
Jul 26 10:19:52 enea usb-storage: *** thread awakened.
Jul 26 10:19:52 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:52 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:52 enea usb-storage: Bulk Command S 0x43425355 T 0x59 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:52 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:52 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:52 enea usb-storage: -- transfer complete
Jul 26 10:19:52 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:52 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:52 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:52 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:52 enea usb-storage: -- transfer complete
Jul 26 10:19:52 enea usb-storage: Bulk status result = 0
Jul 26 10:19:52 enea usb-storage: Bulk Status S 0x53425355 T 0x59 R 0 Stat 0x0
Jul 26 10:19:52 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:52 enea usb-storage: *** thread sleeping.
Jul 26 10:19:54 enea usb-storage: queuecommand called
Jul 26 10:19:54 enea usb-storage: *** thread awakened.
Jul 26 10:19:54 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:54 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:54 enea usb-storage: Bulk Command S 0x43425355 T 0x5a L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:54 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:54 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:54 enea usb-storage: -- transfer complete
Jul 26 10:19:54 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:54 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:54 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:54 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:54 enea usb-storage: -- transfer complete
Jul 26 10:19:54 enea usb-storage: Bulk status result = 0
Jul 26 10:19:54 enea usb-storage: Bulk Status S 0x53425355 T 0x5a R 0 Stat 0x0
Jul 26 10:19:54 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:54 enea usb-storage: *** thread sleeping.
Jul 26 10:19:56 enea usb-storage: queuecommand called
Jul 26 10:19:56 enea usb-storage: *** thread awakened.
Jul 26 10:19:56 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 26 10:19:56 enea usb-storage:  00 00 00 00 00 00
Jul 26 10:19:56 enea usb-storage: Bulk Command S 0x43425355 T 0x5b L 0 F 0 Trg 0 LUN 0 CL 6
Jul 26 10:19:56 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 26 10:19:56 enea usb-storage: Status code 0; transferred 31/31
Jul 26 10:19:56 enea usb-storage: -- transfer complete
Jul 26 10:19:56 enea usb-storage: Bulk command transfer result=0
Jul 26 10:19:56 enea usb-storage: Attempting to get CSW...
Jul 26 10:19:56 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 26 10:19:56 enea usb-storage: Status code 0; transferred 13/13
Jul 26 10:19:56 enea usb-storage: -- transfer complete
Jul 26 10:19:56 enea usb-storage: Bulk status result = 0
Jul 26 10:19:56 enea usb-storage: Bulk Status S 0x53425355 T 0x5b R 0 Stat 0x0
Jul 26 10:19:56 enea usb-storage: scsi cmd done, result=0x0
Jul 26 10:19:56 enea usb-storage: *** thread sleeping.
Jul 26 10:19:56 enea usb 1-2: USB disconnect, address 2
Jul 26 10:19:56 enea usb-storage: storage_disconnect() called
Jul 26 10:19:56 enea usb-storage: -- usb_stor_release_resources
Jul 26 10:19:56 enea usb-storage: -- sending exit command to thread
Jul 26 10:19:56 enea usb-storage: *** thread awakened.
Jul 26 10:19:56 enea usb-storage: -- exiting
Jul 26 10:19:56 enea usb-storage: -- dissociate_dev
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.003951] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/volume_uuid_3738_3662').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.015721] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/storage_serial_Nokia_Nokia_5300_359815013364896_0_0').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.017803] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0_scsi_host_scsi_device_lun0').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.018762] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0_scsi_host').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.021216] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.025349] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_usbraw').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.056462] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896').
Jul 26 10:19:57 enea usb 1-2: new full speed USB device using uhci_hcd and address 3
Jul 26 10:19:57 enea usb 1-2: configuration #1 chosen from 1 choice
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.781209] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.849978] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.865922] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if1').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.883571] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if2').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.937446] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if3').
Jul 26 10:19:57 enea NetworkManager: <debug> [1217060397.986909] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if4').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.026587] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if5').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.087227] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if6').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.102633] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if7').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.131530] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if8').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.160967] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if9').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.162257] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_0').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.163495] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_1').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.164654] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_2').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.165881] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_3').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.167039] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_4').
Jul 26 10:19:58 enea NetworkManager: <debug> [1217060398.188454] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_usbraw').
Jul 26 10:19:58 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:58 enea acpid: notifying client 2192[102:408]
Jul 26 10:19:58 enea acpid: notifying client 2275[0:0]
Jul 26 10:19:58 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:58 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:19:58 enea acpid: action exited with status 0
Jul 26 10:19:58 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:58 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:58 enea acpid: notifying client 2192[102:408]
Jul 26 10:19:58 enea acpid: notifying client 2275[0:0]
Jul 26 10:19:58 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:19:58 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:19:58 enea acpid: action exited with status 0
Jul 26 10:19:58 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:20:00 enea ntpd[2384]: Cannot find existing interface for address 194.78.18.221
Jul 26 10:20:00 enea ntpd_initres[2385]: ntpd indicates no data available!
Jul 26 10:20:04 enea usb 1-2: USB disconnect, address 3
Jul 26 10:20:04 enea NetworkManager: <debug> [1217060404.998297] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.004629] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if1').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.010534] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if2').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.014626] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if3').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.016585] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if4').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.018440] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if5').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.020385] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if6').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.022209] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if7').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.024152] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if8').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.025962] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if9').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.028667] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_0').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.032091] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_1').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.033968] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_2').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.035815] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_3').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.037629] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_if0_4').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.040382] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial_usbraw').
Jul 26 10:20:05 enea NetworkManager: <debug> [1217060405.042423] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b8_noserial').
Jul 26 10:20:13 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 26 10:20:13 enea acpid: notifying client 2192[102:408]
Jul 26 10:20:13 enea acpid: notifying client 2275[0:0]
Jul 26 10:20:13 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 26 10:20:13 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 26 10:20:13 enea acpid: action exited with status 0
Jul 26 10:20:13 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"

--------------080003030207010804060506--
