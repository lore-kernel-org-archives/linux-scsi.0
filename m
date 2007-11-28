From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm2: Result: hostbyte=0x01
 driverbyte=0x00\nend_request: I/O error
Date: Wed, 28 Nov 2007 13:40:36 -0800
Message-ID: <20071128134036.417b3def.akpm@linux-foundation.org>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<20071128200130.GA13361@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754228AbXK1Vkn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Nov 2007 16:40:43 -0500
In-Reply-To: <20071128200130.GA13361@martell.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 28 Nov 2007 23:01:31 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Reliably spams dmesg with end_request() horrors. This happens when git
> starts checking out linux tree to fresh ext2 partition. Disk is several
> month old and there were no prolems with, say, 2.6.24-rc3:
> 
> [  225.378426] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.378659] end_request: I/O error, dev sdb, sector 141295703
> [  225.390133] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.391988] end_request: I/O error, dev sdb, sector 141295703
> [  225.392463] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.392625] end_request: I/O error, dev sdb, sector 141295703
> [  225.392999] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.393161] end_request: I/O error, dev sdb, sector 141295703
> [  225.393571] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.393731] end_request: I/O error, dev sdb, sector 141295703
> [  225.394382] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.394544] end_request: I/O error, dev sdb, sector 141295703
> [  225.395247] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.395412] end_request: I/O error, dev sdb, sector 141295703
> 
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_ACPI=y
> CONFIG_SATA_AHCI=y
> CONFIG_ATA_PIIX=y
> CONFIG_PATA_JMICRON=y

and

> [   35.229713] sd 2:0:1:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)

So that's an OK sector number.


> [    0.000000] Linux version 2.6.24-rc3-mm2 (ad@core2) (gcc version 4.1.2 (Gentoo 4.1.2 p1.0.2)) #3 SMP PREEMPT Wed Nov 28 22:23:45 MSK 2007
> [    0.000000] Command line: root=/dev/sda2 netconsole=@10.10.0.42/eth0,9353@10.10.0.1/00:80:48:45:EC:73 ignore_loglevel
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
> [    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
> [    0.000000]  BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
> [    0.000000]  BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
> [    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
> [    0.000000]  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 524176) 1 entries of 256 used
> [    0.000000] Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
> [    0.000000] end_pfn_map = 1572864
> [    0.000000] DMI 2.4 present.
> [    0.000000] ACPI: RSDP 000FA980, 0024 (r2 ACPIAM)
> [    0.000000] ACPI: XSDT 7FF90100, 0054 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
> [    0.000000] ACPI: FACP 7FF90290, 00F4 (r3 MSTEST OEMFACP   2000707 MSFT       97)
> [    0.000000] ACPI: DSDT 7FF905C0, 8FA9 (r1  A0637 A0637000        0 INTL 20060113)
> [    0.000000] ACPI: FACS 7FF9E000, 0040
> [    0.000000] ACPI: APIC 7FF90390, 006C (r1 MSTEST OEMAPIC   2000707 MSFT       97)
> [    0.000000] ACPI: MCFG 7FF90400, 003C (r1 MSTEST OEMMCFG   2000707 MSFT       97)
> [    0.000000] ACPI: SLIC 7FF90440, 0176 (r1 KOZIRO FRONTIER  2000707 MSFT       97)
> [    0.000000] ACPI: OEMB 7FF9E040, 007B (r1 MSTEST AMI_OEM   2000707 MSFT       97)
> [    0.000000] ACPI: HPET 7FF99570, 0038 (r1 MSTEST OEMHPET   2000707 MSFT       97)
> [    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
> [    0.000000] Entering add_active_range(0, 256, 524176) 1 entries of 256 used
> [    0.000000] Entering add_active_range(0, 1048576, 1572864) 2 entries of 256 used
> [    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->FFFF810001200000 on node 0
> [    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->FFFF810001600000 on node 0
> [    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->FFFF810001A00000 on node 0
> [    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->FFFF810001E00000 on node 0
> [    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->FFFF810002200000 on node 0
> [    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->FFFF810002600000 on node 0
> [    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->FFFF810002A00000 on node 0
> [    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->FFFF810002E00000 on node 0
> [    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->FFFF810003200000 on node 0
> [    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->FFFF810003600000 on node 0
> [    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->FFFF810003A00000 on node 0
> [    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->FFFF810003E00000 on node 0
> [    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->FFFF810004200000 on node 0
> [    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->FFFF810004600000 on node 0
> [    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->FFFF810004A00000 on node 0
> [    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->FFFF810004E00000 on node 0
> [    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->FFFF810005200000 on node 0
> [    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->FFFF810005600000 on node 0
> [    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->FFFF810005A00000 on node 0
> [    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->FFFF810005E00000 on node 0
> [    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->FFFF810006200000 on node 0
> [    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->FFFF810006600000 on node 0
> [    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->FFFF810006A00000 on node 0
> [    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->FFFF810006E00000 on node 0
> [    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->FFFF810007200000 on node 0
> [    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->FFFF810007600000 on node 0
> [    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->FFFF810007A00000 on node 0
> [    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->FFFF810007E00000 on node 0
> [    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->FFFF810008200000 on node 0
> [    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->FFFF810008600000 on node 0
> [    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->FFFF810008A00000 on node 0
> [    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->FFFF810008E00000 on node 0
> [    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->FFFF810009200000 on node 0
> [    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->FFFF810009600000 on node 0
> [    0.000000]  [ffffe20004400000-ffffe200045fffff] PMD ->FFFF810009A00000 on node 0
> [    0.000000]  [ffffe20004600000-ffffe200047fffff] PMD ->FFFF810009E00000 on node 0
> [    0.000000]  [ffffe20004800000-ffffe200049fffff] PMD ->FFFF81000A200000 on node 0
> [    0.000000]  [ffffe20004a00000-ffffe20004bfffff] PMD ->FFFF81000A600000 on node 0
> [    0.000000]  [ffffe20004c00000-ffffe20004dfffff] PMD ->FFFF81000AA00000 on node 0
> [    0.000000]  [ffffe20004e00000-ffffe20004ffffff] PMD ->FFFF81000AE00000 on node 0
> [    0.000000]  [ffffe20005000000-ffffe200051fffff] PMD ->FFFF81000B200000 on node 0
> [    0.000000]  [ffffe20005200000-ffffe200053fffff] PMD ->FFFF81000B600000 on node 0
> [    0.000000] sizeof(struct page) = 56
> [    0.000000] Zone PFN ranges:
> [    0.000000]   DMA             0 ->     4096
> [    0.000000]   DMA32        4096 ->  1048576
> [    0.000000]   Normal    1048576 ->  1572864
> [    0.000000] Movable zone start PFN for each node
> [    0.000000] early_node_map[3] active PFN ranges
> [    0.000000]     0:        0 ->      159
> [    0.000000]     0:      256 ->   524176
> [    0.000000]     0:  1048576 ->  1572864
> [    0.000000] On node 0 totalpages: 1048367
> [    0.000000]   DMA zone: 56 pages used for memmap
> [    0.000000]   DMA zone: 1780 pages reserved
> [    0.000000]   DMA zone: 2163 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 14280 pages used for memmap
> [    0.000000]   DMA32 zone: 505800 pages, LIFO batch:31
> [    0.000000]   Normal zone: 7168 pages used for memmap
> [    0.000000]   Normal zone: 517120 pages, LIFO batch:31
> [    0.000000]   Movable zone: 0 pages used for memmap
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] Processor #0 (Bootup-CPU)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] Processor #1
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Setting APIC routing to flat
> [    0.000000] ACPI: HPET id: 0x8086a202 base: 0xfed00000
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:7ee00000)
> [    0.000000] PERCPU: Allocating 23392 bytes of per cpu data
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1025083
> [    0.000000] Kernel command line: root=/dev/sda2 netconsole=@10.10.0.42/eth0,9353@10.10.0.1/00:80:48:45:EC:73 ignore_loglevel
> [    0.000000] debug: ignoring loglevel setting.
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> [    0.000000] Extended CMOS year: 2000
> [    0.000000] hpet clockevent registered
> [    0.000000] TSC calibrated against HPET
> [   30.809404] time.c: Detected 2135.038 MHz processor.
> [   30.812136] Console: colour VGA+ 80x25
> [   30.812141] console [tty0] enabled
> [   30.828153] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> [   30.828323] ... MAX_LOCKDEP_SUBCLASSES:    8
> [   30.828434] ... MAX_LOCK_DEPTH:          30
> [   30.828537] ... MAX_LOCKDEP_KEYS:        2048
> [   30.828641] ... CLASSHASH_SIZE:           1024
> [   30.828746] ... MAX_LOCKDEP_ENTRIES:     8192
> [   30.828850] ... MAX_LOCKDEP_CHAINS:      16384
> [   30.828954] ... CHAINHASH_SIZE:          8192
> [   30.829058]  memory used by lock dependency info: 1648 kB
> [   30.829169]  per task-struct memory footprint: 1680 bytes
> [   30.829280] ------------------------
> [   30.829387] | Locking API testsuite:
> [   30.829486] ----------------------------------------------------------------------------
> [   30.831340]                                  | spin |wlock |rlock |mutex | wsem | rsem |
> [   30.831519]   --------------------------------------------------------------------------
> [   30.831693]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.832704]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.833691]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.834713]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.835735]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.836799]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.837864]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.838934]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.839890]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.840842]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
> [   30.841834]   --------------------------------------------------------------------------
> [   30.842005]               recursive read-lock:             |  ok  |             |  ok  |
> [   30.842533]            recursive read-lock #2:             |  ok  |             |  ok  |
> [   30.843054]             mixed read-write-lock:             |  ok  |             |  ok  |
> [   30.843587]             mixed write-read-lock:             |  ok  |             |  ok  |
> [   30.844111]   --------------------------------------------------------------------------
> [   30.844282]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [   30.844810]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
> [   30.845330]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [   30.845859]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
> [   30.846388]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
> [   30.846909]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
> [   30.847439]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [   30.847958]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
> [   30.848489]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [   30.849010]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
> [   30.849540]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [   30.850074]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
> [   30.850617]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [   30.851151]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
> [   30.851693]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [   30.852228]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
> [   30.852771]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [   30.853301]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
> [   30.853842]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [   30.854373]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
> [   30.854897]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [   30.855435]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
> [   30.855967]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [   30.856506]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
> [   30.857040]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [   30.857578]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
> [   30.858112]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [   30.858651]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
> [   30.859184]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [   30.859720]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
> [   30.860251]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [   30.860788]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
> [   30.861331]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [   30.861858]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
> [   30.862397]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [   30.862927]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
> [   30.863469]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [   30.863998]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
> [   30.864541]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [   30.865073]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
> [   30.865616]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [   30.866145]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
> [   30.866686]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [   30.867216]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
> [   30.867760]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [   30.868288]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
> [   30.868828]       hard-irq read-recursion/123:  ok  |
> [   30.869097]       soft-irq read-recursion/123:  ok  |
> [   30.869376]       hard-irq read-recursion/132:  ok  |
> [   30.869646]       soft-irq read-recursion/132:  ok  |
> [   30.869916]       hard-irq read-recursion/213:  ok  |
> [   30.870185]       soft-irq read-recursion/213:  ok  |
> [   30.870464]       hard-irq read-recursion/231:  ok  |
> [   30.870733]       soft-irq read-recursion/231:  ok  |
> [   30.871003]       hard-irq read-recursion/312:  ok  |
> [   30.871272]       soft-irq read-recursion/312:  ok  |
> [   30.871550]       hard-irq read-recursion/321:  ok  |
> [   30.871819]       soft-irq read-recursion/321:  ok  |
> [   30.872089] -------------------------------------------------------
> [   30.872205] Good, all 218 testcases passed! |
> [   30.872318] ---------------------------------
> [   30.874334] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [   30.877360] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [   30.877811] Checking aperture...
> [   30.877916] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [   30.908946] Placing software IO TLB between 0xbe61000 - 0xfe61000
> [   30.946667] Memory: 4026948k/6291456k available (2044k kernel code, 165884k reserved, 816k data, 200k init)
> [   30.946915] SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
> [   31.006137] Calibrating delay using timer specific routine.. 4273.18 BogoMIPS (lpj=2136592)
> [   31.006412] Mount-cache hash table entries: 256
> [   31.007012] CPU: L1 I cache: 32K, L1 D cache: 32K
> [   31.007162] CPU: L2 cache: 2048K
> [   31.007261] using mwait in idle threads.
> [   31.007362] CPU: Physical Processor ID: 0
> [   31.007465] CPU: Processor Core ID: 0
> [   31.007570] CPU0: Thermal monitoring enabled (TM2)
> [   31.007691] Freeing SMP alternatives: 16k freed
> [   31.008231] ACPI: Core revision 20070126
> [   31.057639] Using local APIC timer interrupts.
> [   31.104537] APIC timer calibration result 16679981
> [   31.104645] Detected 16.679 MHz APIC timer.
> [   31.104934] lockdep: not fixing up alternatives.
> [   31.105102] Booting processor 1/2 APIC 0x1
> [   31.115410] Initializing CPU#1
> [   31.175659] Calibrating delay using timer specific routine.. 4269.88 BogoMIPS (lpj=2134942)
> [   31.175665] CPU: L1 I cache: 32K, L1 D cache: 32K
> [   31.175666] CPU: L2 cache: 2048K
> [   31.175668] CPU: Physical Processor ID: 0
> [   31.175670] CPU: Processor Core ID: 1
> [   31.175676] CPU1: Thermal monitoring enabled (TM2)
> [   31.175960] Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 02
> [   31.176018] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> [   31.197049] Brought up 2 CPUs
> [   31.197767] net_namespace: 208 bytes
> [   31.198257] NET: Registered protocol family 16
> [   31.198913] ACPI: bus type pci registered
> [   31.199020] PCI: Using configuration type 1
> [   31.211197] ACPI: EC: Look up EC in DSDT
> [   31.244080] ACPI: Interpreter enabled
> [   31.244181] ACPI: (supports S0 S5)
> [   31.244374] ACPI: Using IOAPIC for interrupt routing
> [   31.274684] ACPI: PCI Root Bridge [PCI0] (0000:00)
> [   31.275862] PCI quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
> [   31.275982] PCI quirk: region 0480-04bf claimed by ICH6 GPIO
> [   31.276928] PCI: Transparent bridge - 0000:00:1e.0
> [   31.277111] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> [   31.278473] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
> [   31.278914] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
> [   31.279752] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
> [   31.280204] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
> [   31.280644] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
> [   31.331552] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
> [   31.332346] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
> [   31.333141] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
> [   31.333939] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
> [   31.334733] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [   31.335644] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
> [   31.336556] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
> [   31.337344] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
> [   31.338112] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  08, should be FB [20070126]
> [   31.338369] Linux Plug and Play Support v0.97 (c) Adam Belay
> [   31.338597] pnp: PnP ACPI init
> [   31.338717] ACPI: bus type pnp registered
> [   31.345055] pnp 00:09: can't allocate MMIO space at 0xffafe000
> [   31.351967] pnp: PnP ACPI: found 16 devices
> [   31.352072] ACPI: ACPI bus type pnp unregistered
> [   31.352790] SCSI subsystem initialized
> [   31.352980] libata version 3.00 loaded.
> [   31.353334] PCI: Using ACPI for IRQ routing
> [   31.353442] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> [   31.356582] PCI-GART: No AMD northbridge found.
> [   31.357487] Time: tsc clocksource has been installed.
> [   31.359656] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
> [   31.359802] system 00:08: ioport range 0x290-0x297 has been reserved
> [   31.361619] system 00:09: ioport range 0x4d0-0x4d1 has been reserved
> [   31.361738] system 00:09: ioport range 0x800-0x87f has been reserved
> [   31.361856] system 00:09: ioport range 0x480-0x4bf has been reserved
> [   31.361976] system 00:09: iomem range 0xffafe000-0xffb0cbff could not be reserved
> [   31.362147] system 00:09: iomem range 0xffb00000-0xffbfffff could not be reserved
> [   31.362316] system 00:09: iomem range 0xfed1c000-0xfed1ffff has been reserved
> [   31.362446] system 00:09: iomem range 0xfed20000-0xfed8ffff has been reserved
> [   31.362575] system 00:09: iomem range 0xfff00000-0xfffffffe could not be reserved
> [   31.362744] system 00:09: iomem range 0xfebfe000-0xfebfec00 has been reserved
> [   31.362876] system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
> [   31.363007] system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
> [   31.363184] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
> [   31.363322] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
> [   31.363442] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
> [   31.363568] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
> [   31.363693] system 00:0f: iomem range 0x100000-0x7fffffff could not be reserved
> [   31.363864] system 00:0f: iomem range 0x0-0x0 could not be reserved
> [   31.365299] PCI: Bridge: 0000:00:01.0
> [   31.365401]   IO window: a000-afff
> [   31.365502]   MEM window: f8800000-fe8fffff
> [   31.365618]   PREFETCH window: bfe00000-dfdfffff
> [   31.365726] PCI: Bridge: 0000:00:1c.0
> [   31.365826]   IO window: disabled.
> [   31.365928]   MEM window: disabled.
> [   31.366029]   PREFETCH window: dfe00000-dfefffff
> [   31.366139] PCI: Bridge: 0000:00:1c.3
> [   31.366238]   IO window: disabled.
> [   31.366340]   MEM window: fea00000-feafffff
> [   31.366445]   PREFETCH window: disabled.
> [   31.366553] PCI: Bridge: 0000:00:1c.4
> [   31.366654]   IO window: b000-bfff
> [   31.366756]   MEM window: fe900000-fe9fffff
> [   31.366861]   PREFETCH window: disabled.
> [   31.366966] PCI: Bridge: 0000:00:1e.0
> [   31.367066]   IO window: disabled.
> [   31.367167]   MEM window: disabled.
> [   31.367268]   PREFETCH window: disabled.
> [   31.367389] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
> [   31.367597] PCI: Setting latency timer of device 0000:00:01.0 to 64
> [   31.367732] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
> [   31.367936] PCI: Setting latency timer of device 0000:00:1c.0 to 64
> [   31.368072] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
> [   31.368276] PCI: Setting latency timer of device 0000:00:1c.3 to 64
> [   31.368410] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
> [   31.368617] PCI: Setting latency timer of device 0000:00:1c.4 to 64
> [   31.368743] PCI: Setting latency timer of device 0000:00:1e.0 to 64
> [   31.368876] NET: Registered protocol family 2
> [   31.378818] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
> [   31.379519] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
> [   31.381487] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
> [   31.386055] TCP: Hash tables configured (established 262144 bind 65536)
> [   31.386204] TCP reno registered
> [   31.403547] io scheduler noop registered
> [   31.404080] io scheduler cfq registered (default)
> [   31.406028] Boot video device is 0000:01:00.0
> [   31.409155] Switched to high resolution mode on CPU 1
> [   31.409732] Switched to high resolution mode on CPU 0
> [   31.414361] Real Time Clock Driver v1.12ac
> [   31.414465] Linux agpgart interface v0.103
> [   31.414852] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> [   31.415061] PCI: Setting latency timer of device 0000:03:00.0 to 64
> [   31.415597] atl1 0000:03:00.0: version 2.0.7
> [   31.451060] netconsole: local port 6665
> [   31.451162] netconsole: local IP 10.10.0.42
> [   31.451265] netconsole: interface eth0
> [   31.451365] netconsole: remote port 9353
> [   31.451467] netconsole: remote IP 10.10.0.1
> [   31.451571] netconsole: remote ethernet address 00:80:48:45:ec:73
> [   31.451696] netconsole: device eth0 not up yet, forcing it
> [   32.955843] atl1 0000:03:00.0: eth0 link is up 100 Mbps full duplex
> [   32.959943] console [netcon0] enabled
> [   33.009788] netconsole: network logging started
> [   33.012043] ahci 0000:02:00.0: version 3.0
> [   33.012187] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
> [   34.012514] ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
> [   34.012699] ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
> [   34.012834] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [   34.013333] scsi0 : ahci
> [   34.013616] scsi1 : ahci
> [   34.014002] ata1: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe100 irq 16
> [   34.014174] ata2: SATA max UDMA/133 abar m8192@0xfe9fe000 port 0xfe9fe180 irq 16
> [   34.318163] ata1: SATA link down (SStatus 0 SControl 300)
> [   34.622817] ata2: SATA link down (SStatus 0 SControl 300)
> [   34.623116] ata_piix 0000:00:1f.2: version 2.12
> [   34.623230] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> [   34.623553] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> [   34.623796] PCI: Setting latency timer of device 0000:00:1f.2 to 64
> [   34.623976] scsi2 : ata_piix
> [   34.624244] scsi3 : ata_piix
> [   34.636578] ata3: SATA max UDMA/133 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
> [   34.636705] ata4: SATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
> [   34.839027] ata3.00: ATA-7: ST3250620AS, 3.AAE, max UDMA/133
> [   34.839149] ata3.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [   34.869628] ata3.01: ATA-7: ST3500630AS, 3.AAK, max UDMA/133
> [   34.869747] ata3.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [   34.905567] ata3.00: configured for UDMA/133
> [   34.944500] ata3.01: configured for UDMA/133
> [   35.130121] ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
> [   35.130256] ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [   35.204995] ata4.00: configured for UDMA/133
> [   35.205453] scsi 2:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA PQ: 0 ANSI: 5
> [   35.206071] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> [   35.206221] sd 2:0:0:0: [sda] Write Protect is off
> [   35.206333] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   35.206496] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   35.206946] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> [   35.207096] sd 2:0:0:0: [sda] Write Protect is off
> [   35.207207] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   35.207370] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   35.207564]  sda: sda1 sda2 sda3 sda4
> [   35.228877] sd 2:0:0:0: [sda] Attached SCSI disk
> [   35.229235] scsi 2:0:1:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
> [   35.229713] sd 2:0:1:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
> [   35.229862] sd 2:0:1:0: [sdb] Write Protect is off
> [   35.229974] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [   35.230133] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   35.230430] sd 2:0:1:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
> [   35.230580] sd 2:0:1:0: [sdb] Write Protect is off
> [   35.230692] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
> [   35.230852] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   35.231036]  sdb: sdb1
> [   35.250751] sd 2:0:1:0: [sdb] Attached SCSI disk
> [   35.251164] scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
> [   35.251651] sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
> [   35.251807] sd 3:0:0:0: [sdc] Write Protect is off
> [   35.251918] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [   35.252090] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   35.252393] sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
> [   35.252549] sd 3:0:0:0: [sdc] Write Protect is off
> [   35.252666] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [   35.252832] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [   35.253020]  sdc: sdc1
> [   35.269976] sd 3:0:0:0: [sdc] Attached SCSI disk
> [   35.270221] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
> [   35.270556] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 19
> [   35.270816] PCI: Setting latency timer of device 0000:00:1f.5 to 64
> [   35.271012] scsi4 : ata_piix
> [   35.271291] scsi5 : ata_piix
> [   35.278657] ata5: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xc880 irq 19
> [   35.278783] ata6: SATA max UDMA/133 cmd 0xd000 ctl 0xcc00 bmdma 0xc888 irq 19
> [   35.610898] ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 17 (level, low) -> IRQ 17
> [   35.611159] PCI: Setting latency timer of device 0000:02:00.1 to 64
> [   35.611347] scsi6 : pata_jmicron
> [   35.611627] scsi7 : pata_jmicron
> [   35.614721] ata7: PATA max UDMA/100 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 17
> [   35.614847] ata8: PATA max UDMA/100 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 17
> [   36.069763] ata7.01: ATAPI: _NEC DV-5800C, D9S2, max UDMA/33
> [   36.220633] ata7.01: configured for UDMA/33
> [   36.404203] scsi 6:0:1:0: CD-ROM            _NEC     DV-5800C         D9S2 PQ: 0 ANSI: 5
> [   36.407494] sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
> [   36.407620] Uniform CD-ROM driver Revision: 3.20
> [   36.408021] sr 6:0:1:0: Attached scsi CD-ROM sr0
> [   36.408481] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
> [   36.408601] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
> [   36.409362] serio: i8042 KBD port at 0x60,0x64 irq 1
> [   36.409681] TCP cubic registered
> [   36.410085] NET: Registered protocol family 1
> [   36.430531] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> [   36.517238] EXT3-fs: INFO: recovery required on readonly filesystem.
> [   36.517363] EXT3-fs: write access will be enabled during recovery.
> [   36.543412] kjournald starting.  Commit interval 5 seconds
> [   36.543577] EXT3-fs: recovery complete.
> [   36.544251] EXT3-fs: mounted filesystem with ordered data mode.
> [   36.544426] VFS: Mounted root (ext3 filesystem) readonly.
> [   36.544610] Freeing unused kernel memory: 200k freed
> [   36.545338] Write protecting the kernel read-only data: 2644k
> [   38.568379] EXT3 FS on sda2, internal journal
> [   38.695881] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
> [   38.714694] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
> [   38.749809] Adding 7823644k swap on /dev/sda3.  Priority:-1 extents:1 across:7823644k
> [  225.378426] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.378659] end_request: I/O error, dev sdb, sector 141295703
> [  225.390133] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.391988] end_request: I/O error, dev sdb, sector 141295703
> [  225.392463] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.392625] end_request: I/O error, dev sdb, sector 141295703
> [  225.392999] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.393161] end_request: I/O error, dev sdb, sector 141295703
> [  225.393571] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.393731] end_request: I/O error, dev sdb, sector 141295703
> [  225.394382] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.394544] end_request: I/O error, dev sdb, sector 141295703
> [  225.395247] sd 2:0:1:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
> [  225.395412] end_request: I/O error, dev sdb, sector 141295703

I don't know whether this failure was a scsi thing or an ata thing?
