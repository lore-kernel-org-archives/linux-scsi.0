From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [PATCH 2/4] fastboot: make scsi probes asynchronous
Date: Sun, 04 Jan 2009 18:55:50 +0000
Message-ID: <49610636.7090005@yahoo.com>
References: <fa.h0UoSd20jEtik35h1v63j+E67Io@ifi.uio.no> <fa.5PP24JO26n+WYiDr/9b4OySGjWY@ifi.uio.no> <fa.FlPVm6dv2aVhxgrZlA92A/26QC8@ifi.uio.no> <fa.xSdAPowIDNEH2rL6hWZp0t33p2U@ifi.uio.no> <fa.abMnCBprOI1BL1RNVaAvYnUsaEw@ifi.uio.no> <fa.opIcflAvDANLuO5+8NjVCjt/94o@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759892AbZADS6Q@vger.kernel.org>
In-Reply-To: <fa.opIcflAvDANLuO5+8NjVCjt/94o@ifi.uio.no>
Sender: linux-kernel-owner@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 5 Jan 2009 00:08:42 +0530
> "Jaswinder Singh Rajput" <jaswinderlinux@gmail.com> wrote:
> 
>> On Sun, Jan 4, 2009 at 11:43 PM, Arjan van de Ven
>> <arjan@infradead.org> wrote:
>>> just checked;
>>> my box has CONFIG_SCSI_SCAN_ASYNC=y set for both cases
>>> it seems to be about 0.1 seconds win still though...
>>> sounds little, but a kernel boot should be less than a second, so
>>> that is still 10%. And it's obviously also disk dependent..
>>> (I used libata connected disks obviously)
>>>
>> Do you also have boot time numbers for RAM and/or flash based
>> filesystem (disk-less)
> 
> my laptop with a pretty nice SSD shows a similar kind of behavior
> (bit shorter in time, but there the entire kernel boot is shorter as a
> whole)

I've just tested this on my EeePC 900 (on the slower SSD) and I see a 
0.41 second speed up if I look at the time up to "Write protecting the 
kernel text" message. The gap is bigger if I take the time up to the 
point when the internal network card (an Attansic) prints its irq - then 
the gap is 1.31 seconds. Everything seems to be good so I guess if it 
helps you can add a tested-by line:

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

---

debug_initcall log without fastboot:

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-rc9-00070-gc20137f-dirty 
(sits@xenon.sucs.swan.ac.uk) (gcc version 4.1.2 20070925 (Red Hat 
4.1.2-33)) #19 Sun Jan 4 18:20:58 GMT 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f780000 (usable)
[    0.000000]  BIOS-e820: 000000003f780000 - 000000003f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f790000 - 000000003f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f7d0000 - 000000003f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000003f7e0000 - 000000003f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x3f780 max_arch_pfn = 0x100000
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
[    0.000000] total RAM coverred: 1016M
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 128K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 256K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 512K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 128K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 256K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 512K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 16M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 32M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 64M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 256K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 512K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 16M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 32M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 64M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 512K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 16M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 32M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 64M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 128M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 256M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 512M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 128M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 256M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 512M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 128M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 256M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 512M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 128M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 256M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 512M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 16M 	chunk_size: 16M 	num_reg: 6  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 2G 	num_reg: 6  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 32M 	chunk_size: 32M 	num_reg: 5  	lose cover 
RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 2G 	num_reg: 5  	lose cover 
RAM: 24M
[    0.000000]  gran_size: 64M 	chunk_size: 64M 	num_reg: 4  	lose cover 
RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 2G 	num_reg: 4  	lose cover 
RAM: 56M
[    0.000000]  gran_size: 128M 	chunk_size: 128M 	num_reg: 3  	lose 
cover RAM: 120M
[    0.000000]  gran_size: 128M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 120M
[    0.000000]  gran_size: 128M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 120M
[    0.000000]  gran_size: 128M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 120M
[    0.000000]  gran_size: 128M 	chunk_size: 2G 	num_reg: 3  	lose cover 
RAM: 120M
[    0.000000]  gran_size: 256M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 248M
[    0.000000]  gran_size: 256M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 248M
[    0.000000]  gran_size: 256M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 248M
[    0.000000]  gran_size: 256M 	chunk_size: 2G 	num_reg: 2  	lose cover 
RAM: 248M
[    0.000000]  gran_size: 512M 	chunk_size: 512M 	num_reg: 1  	lose 
cover RAM: 504M
[    0.000000]  gran_size: 512M 	chunk_size: 1G 	num_reg: 1  	lose cover 
RAM: 504M
[    0.000000]  gran_size: 512M 	chunk_size: 2G 	num_reg: 1  	lose cover 
RAM: 504M
[    0.000000]  gran_size: 1G 	chunk_size: 1G 	num_reg: 0  	lose cover 
RAM: 1016M
[    0.000000]  gran_size: 1G 	chunk_size: 2G 	num_reg: 0  	lose cover 
RAM: 1016M
[    0.000000]  gran_size: 2G 	chunk_size: 2G 	num_reg: 0  	lose cover 
RAM: 1016M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000] gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose RAM: 0G
[    0.000000] range0: 0000000000000000 - 0000000040000000
[    0.000000] Setting variable MTRR 0, base: 0GB, range: 1GB, type WB
[    0.000000] hole: 000000003f800000 - 0000000040000000
[    0.000000] Setting variable MTRR 1, base: 1016MB, range: 8MB, type UC
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-d000
[    0.000000] ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3F780000, 0034 (r1 A M I  OEMRSDT   9000811 
MSFT       97)
[    0.000000] ACPI: FACP 3F780200, 0081 (r1 A M I  OEMFACP   9000811 
MSFT       97)
[    0.000000] ACPI: DSDT 3F780400, 6109 (r1  A0979 A0979034       34 
INTL 20060113)
[    0.000000] ACPI: FACS 3F790000, 0040
[    0.000000] ACPI: APIC 3F780390, 0068 (r1 A M I  OEMAPIC   9000811 
MSFT       97)
[    0.000000] ACPI: OEMB 3F790040, 0046 (r1 A M I  AMI_OEM   9000811 
MSFT       97)
[    0.000000] ACPI: MCFG 3F786510, 003C (r1 A M I  OEMMCFG   9000811 
MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00009000 - 0000ff00
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 000054208c]    TEXT DATA BSS ==> 
[0000100000 - 000054208c]
[    0.000000]   #2 [0000543000 - 0000546000]    INIT_PG_TABLE ==> 
[0000543000 - 0000546000]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> 
[000009fc00 - 0000100000]
[    0.000000]   #4 [0000007000 - 0000009000]          PGTABLE ==> 
[0000007000 - 0000009000]
[    0.000000]   #5 [0000009000 - 0000010000]          BOOTMAP ==> 
[0000009000 - 0000010000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f780
[    0.000000] On node 0 totalpages: 259871
[    0.000000] free_area_init_node: node 0, pgdat c0483f40, node_mem_map 
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 256 pages used for memmap
[    0.000000]   HighMem zone: 32386 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 
3f800000:bf600000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 257839
[    0.000000] Kernel command line: initcall_debug root=/dev/sdb2 ro quiet
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 900.107 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000999] Memory: 1025852k/1039872k available (2600k kernel code, 
13332k reserved, 1031k data, 276k init, 130568k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc048e000 - 0xc04d3000   ( 276 kB)
[    0.000999]       .data : 0xc038a300 - 0xc048bf2c   (1031 kB)
[    0.000999]       .text : 0xc0100000 - 0xc038a300   (2600 kB)
[    0.000999] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=1, Nodes=1
[    0.001013] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 1800.21 BogoMIPS (lpj=900107)
[    0.001037] Security Framework initialized
[    0.001058] Mount-cache hash table entries: 512
[    0.001277] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001283] CPU: L2 cache: 512K
[    0.001289] Intel machine check architecture supported.
[    0.001296] Intel machine check reporting enabled on CPU#0.
[    0.001308] CPU: Intel(R) Celeron(R) M processor          900MHz 
stepping 08
[    0.001321] Checking 'hlt' instruction... OK.
[    0.005652] Freeing SMP alternatives: 0k freed
[    0.005657] ACPI: Core revision 20080926
[    0.020075] calling  spawn_ksoftirqd+0x0/0x30 @ 1
[    0.020103] initcall spawn_ksoftirqd+0x0/0x30 returned 0 after 0 usecs
[    0.020110] calling  spawn_softlockup_task+0x0/0x50 @ 1
[    0.020133] initcall spawn_softlockup_task+0x0/0x50 returned 0 after 
0 usecs
[    0.020139] calling  tracer_alloc_buffers+0x0/0xf0 @ 1
[    0.021205] initcall tracer_alloc_buffers+0x0/0xf0 returned 0 after 
976 usecs
[    0.021566] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.031995] APIC calibration not consistent with PM Timer: 119ms 
instead of 100ms
[    0.031995] APIC delta adjusted to PM-Timer: 625063 (749965)
[    0.031995] calling  net_ns_init+0x0/0x1c0 @ 1
[    0.031995] net_namespace: 288 bytes
[    0.031995] initcall net_ns_init+0x0/0x1c0 returned 0 after 0 usecs
[    0.031995] calling  reboot_init+0x0/0x10 @ 1
[    0.031995] initcall reboot_init+0x0/0x10 returned 0 after 0 usecs
[    0.031995] calling  sysctl_init+0x0/0x10 @ 1
[    0.031995] initcall sysctl_init+0x0/0x10 returned 0 after 0 usecs
[    0.031995] calling  ksysfs_init+0x0/0xb0 @ 1
[    0.031995] initcall ksysfs_init+0x0/0xb0 returned 0 after 0 usecs
[    0.031995] calling  init_jiffies_clocksource+0x0/0x10 @ 1
[    0.031995] initcall init_jiffies_clocksource+0x0/0x10 returned 0 
after 0 usecs
[    0.031995] calling  pm_init+0x0/0x30 @ 1
[    0.031995] initcall pm_init+0x0/0x30 returned 0 after 0 usecs
[    0.031995] calling  filelock_init+0x0/0x30 @ 1
[    0.031995] initcall filelock_init+0x0/0x30 returned 0 after 0 usecs
[    0.031995] calling  init_script_binfmt+0x0/0x10 @ 1
[    0.031995] initcall init_script_binfmt+0x0/0x10 returned 0 after 0 usecs
[    0.031995] calling  init_elf_binfmt+0x0/0x10 @ 1
[    0.031995] initcall init_elf_binfmt+0x0/0x10 returned 0 after 0 usecs
[    0.031995] calling  debugfs_init+0x0/0x50 @ 1
[    0.031995] initcall debugfs_init+0x0/0x50 returned 0 after 0 usecs
[    0.031995] calling  random32_init+0x0/0xa0 @ 1
[    0.031995] initcall random32_init+0x0/0xa0 returned 0 after 0 usecs
[    0.031995] calling  cpuidle_init+0x0/0x20 @ 1
[    0.031995] initcall cpuidle_init+0x0/0x20 returned 0 after 0 usecs
[    0.031995] calling  sock_init+0x0/0x60 @ 1
[    0.031995] initcall sock_init+0x0/0x60 returned 0 after 0 usecs
[    0.031995] calling  netlink_proto_init+0x0/0x130 @ 1
[    0.031995] NET: Registered protocol family 16
[    0.031995] initcall netlink_proto_init+0x0/0x130 returned 0 after 0 
usecs
[    0.031995] calling  bdi_class_init+0x0/0x40 @ 1
[    0.031995] initcall bdi_class_init+0x0/0x40 returned 0 after 0 usecs
[    0.031995] calling  kobject_uevent_init+0x0/0x50 @ 1
[    0.031995] initcall kobject_uevent_init+0x0/0x50 returned 0 after 0 
usecs
[    0.031995] calling  pcibus_class_init+0x0/0x10 @ 1
[    0.031995] initcall pcibus_class_init+0x0/0x10 returned 0 after 0 usecs
[    0.031995] calling  pci_driver_init+0x0/0x10 @ 1
[    0.031995] initcall pci_driver_init+0x0/0x10 returned 0 after 0 usecs
[    0.031995] calling  backlight_class_init+0x0/0x50 @ 1
[    0.031995] initcall backlight_class_init+0x0/0x50 returned 0 after 0 
usecs
[    0.031995] calling  tty_class_init+0x0/0x30 @ 1
[    0.031995] initcall tty_class_init+0x0/0x30 returned 0 after 0 usecs
[    0.031995] calling  vtconsole_class_init+0x0/0xe0 @ 1
[    0.032052] initcall vtconsole_class_init+0x0/0xe0 returned 0 after 
976 usecs
[    0.032063] calling  amd_postcore_init+0x0/0x40 @ 1
[    0.032069] initcall amd_postcore_init+0x0/0x40 returned 0 after 0 usecs
[    0.032077] calling  arch_kdebugfs_init+0x0/0x20 @ 1
[    0.032087] initcall arch_kdebugfs_init+0x0/0x20 returned 0 after 0 usecs
[    0.032094] calling  init_pit_clocksource+0x0/0xb0 @ 1
[    0.032100] initcall init_pit_clocksource+0x0/0xb0 returned 0 after 0 
usecs
[    0.032107] calling  mtrr_if_init+0x0/0x70 @ 1
[    0.032116] initcall mtrr_if_init+0x0/0x70 returned 0 after 0 usecs
[    0.032124] calling  ffh_cstate_init+0x0/0x30 @ 1
[    0.032130] initcall ffh_cstate_init+0x0/0x30 returned 0 after 0 usecs
[    0.032139] calling  acpi_pci_init+0x0/0x60 @ 1
[    0.032143] ACPI: bus type pci registered
[    0.032149] initcall acpi_pci_init+0x0/0x60 returned 0 after 0 usecs
[    0.032157] calling  init_acpi_device_notify+0x0/0x3f @ 1
[    0.032162] initcall init_acpi_device_notify+0x0/0x3f returned 0 
after 0 usecs
[    0.032170] calling  pci_arch_init+0x0/0x50 @ 1
[    0.032218] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.032225] PCI: Not using MMCONFIG.
[    0.032437] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.032443] PCI: Using configuration type 1 for base access
[    0.032486] initcall pci_arch_init+0x0/0x50 returned 0 after 0 usecs
[    0.032495] calling  topology_init+0x0/0x10 @ 1
[    0.032556] initcall topology_init+0x0/0x10 returned 0 after 0 usecs
[    0.032565] calling  mtrr_init_finialize+0x0/0x40 @ 1
[    0.032571] initcall mtrr_init_finialize+0x0/0x40 returned 0 after 0 
usecs
[    0.032579] calling  param_sysfs_init+0x0/0x320 @ 1
[    0.036228] initcall param_sysfs_init+0x0/0x320 returned 0 after 3905 
usecs
[    0.036242] calling  pm_sysrq_init+0x0/0x20 @ 1
[    0.036248] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    0.036256] calling  readahead_init+0x0/0x40 @ 1
[    0.036333] initcall readahead_init+0x0/0x40 returned 0 after 0 usecs
[    0.036346] calling  init_bio+0x0/0xc0 @ 1
[    0.036373] initcall init_bio+0x0/0xc0 returned 0 after 0 usecs
[    0.036381] calling  cryptomgr_init+0x0/0x30 @ 1
[    0.036392] initcall cryptomgr_init+0x0/0x30 returned 0 after 0 usecs
[    0.036400] calling  blk_settings_init+0x0/0x20 @ 1
[    0.036406] initcall blk_settings_init+0x0/0x20 returned 0 after 0 usecs
[    0.036415] calling  blk_ioc_init+0x0/0x30 @ 1
[    0.036421] initcall blk_ioc_init+0x0/0x30 returned 0 after 0 usecs
[    0.036429] calling  blk_softirq_init+0x0/0x30 @ 1
[    0.036435] initcall blk_softirq_init+0x0/0x30 returned 0 after 0 usecs
[    0.036444] calling  genhd_device_init+0x0/0x60 @ 1
[    0.036529] initcall genhd_device_init+0x0/0x60 returned 0 after 0 usecs
[    0.036542] calling  pci_slot_init+0x0/0x40 @ 1
[    0.036551] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    0.036560] calling  fbmem_init+0x0/0x90 @ 1
[    0.036620] initcall fbmem_init+0x0/0x90 returned 0 after 0 usecs
[    0.036630] calling  acpi_init+0x0/0x23a @ 1
[    0.037656] ACPI: EC: Look up EC in DSDT
[    0.050566] ACPI: Interpreter enabled
[    0.050578] ACPI: (supports S0 S1 S3 S5)
[    0.050612] ACPI: Using IOAPIC for interrupt routing
[    0.050725] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.054015] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources
[    0.054020] PCI: Using MMCONFIG for extended config space
[    0.054032] initcall acpi_init+0x0/0x23a returned 0 after 17575 usecs
[    0.054042] calling  acpi_scan_init+0x0/0xea @ 1
[    0.064461] initcall acpi_scan_init+0x0/0xea returned 0 after 9764 usecs
[    0.064475] calling  acpi_ec_init+0x0/0x51 @ 1
[    0.064532] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.064537] ACPI: EC: driver started in poll mode
[    0.064599] initcall acpi_ec_init+0x0/0x51 returned 0 after 0 usecs
[    0.064607] calling  dock_init+0x0/0x79 @ 1
[    0.064820] ACPI: No dock devices found.
[    0.064824] initcall dock_init+0x0/0x79 returned 0 after 0 usecs
[    0.064832] calling  acpi_pci_root_init+0x0/0x21 @ 1
[    0.064976] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.065155] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.065163] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.065170] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.065178] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.065215] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.065310] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.065344] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.065350] pci 0000:00:1b.0: PME# disabled
[    0.065402] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.065407] pci 0000:00:1c.0: PME# disabled
[    0.065460] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.065466] pci 0000:00:1c.1: PME# disabled
[    0.065519] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.065525] pci 0000:00:1c.2: PME# disabled
[    0.065577] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.065631] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.065683] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.065735] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.065792] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.065835] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.065841] pci 0000:00:1d.7: PME# disabled
[    0.065962] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.065972] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 
ACPI/GPIO/TCO
[    0.065979] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 
GPIO
[    0.066019] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.066028] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.066036] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.066044] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.066052] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.066074] pci 0000:00:1f.2: PME# supported from D3hot
[    0.066079] pci 0000:00:1f.2: PME# disabled
[    0.066128] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.066256] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.066293] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.066308] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.066315] pci 0000:03:00.0: PME# disabled
[    0.066370] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.066434] pci 0000:01:00.0: reg 10 64bit mmio: [0xfbef0000-0xfbefffff]
[    0.066534] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.066543] pci 0000:00:1c.2: bridge 64bit mmio pref: 
[0xf0000000-0xf6ffffff]
[    0.066594] pci 0000:00:1e.0: transparent bridge
[    0.066625] bus 00 -> node 0
[    0.066643] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.067164] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.067360] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.067549] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.075233] initcall acpi_pci_root_init+0x0/0x21 returned 0 after 
10740 usecs
[    0.075246] calling  acpi_pci_link_init+0x0/0x59 @ 1
[    0.075469] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 
14 15)
[    0.075743] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 
14 15)
[    0.076028] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 
14 15)
[    0.076299] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 
14 15)
[    0.076567] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.076833] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.077111] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.077377] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 
14 15)
[    0.077536] initcall acpi_pci_link_init+0x0/0x59 returned 0 after 
1952 usecs
[    0.077546] calling  acpi_power_init+0x0/0x65 @ 1
[    0.077617] initcall acpi_power_init+0x0/0x65 returned 0 after 0 usecs
[    0.077626] calling  acpi_system_init+0x0/0x164 @ 1
[    0.077716] initcall acpi_system_init+0x0/0x164 returned 0 after 0 usecs
[    0.077724] calling  pnp_init+0x0/0x10 @ 1
[    0.077783] initcall pnp_init+0x0/0x10 returned 0 after 0 usecs
[    0.077791] calling  misc_init+0x0/0xa0 @ 1
[    0.077846] initcall misc_init+0x0/0xa0 returned 0 after 0 usecs
[    0.077854] calling  init_scsi+0x0/0x90 @ 1
[    0.078106] SCSI subsystem initialized
[    0.078113] initcall init_scsi+0x0/0x90 returned 0 after 976 usecs
[    0.078122] calling  ata_init+0x0/0x3a0 @ 1
[    0.078167] libata version 3.00 loaded.
[    0.078172] initcall ata_init+0x0/0x3a0 returned 0 after 0 usecs
[    0.078180] calling  usb_init+0x0/0x120 @ 1
[    0.078325] usbcore: registered new interface driver usbfs
[    0.078384] usbcore: registered new interface driver hub
[    0.078448] usbcore: registered new device driver usb
[    0.078457] initcall usb_init+0x0/0x120 returned 0 after 0 usecs
[    0.078466] calling  serio_init+0x0/0xb0 @ 1
[    0.078533] initcall serio_init+0x0/0xb0 returned 0 after 0 usecs
[    0.078542] calling  input_init+0x0/0x100 @ 1
[    0.078597] initcall input_init+0x0/0x100 returned 0 after 0 usecs
[    0.078606] calling  rtc_init+0x0/0x70 @ 1
[    0.078661] initcall rtc_init+0x0/0x70 returned 0 after 0 usecs
[    0.078670] calling  power_supply_class_init+0x0/0x30 @ 1
[    0.078713] initcall power_supply_class_init+0x0/0x30 returned 0 
after 0 usecs
[    0.078725] calling  hwmon_init+0x0/0x40 @ 1
[    0.078767] initcall hwmon_init+0x0/0x40 returned 0 after 0 usecs
[    0.078778] calling  thermal_init+0x0/0x30 @ 1
[    0.078820] initcall thermal_init+0x0/0x30 returned 0 after 0 usecs
[    0.078830] calling  leds_init+0x0/0x30 @ 1
[    0.078873] initcall leds_init+0x0/0x30 returned 0 after 0 usecs
[    0.078884] calling  pci_subsys_init+0x0/0x100 @ 1
[    0.078888] PCI: Using ACPI for IRQ routing
[    0.078977] initcall pci_subsys_init+0x0/0x100 returned 0 after 0 usecs
[    0.079011] calling  proto_init+0x0/0x30 @ 1
[    0.079022] initcall proto_init+0x0/0x30 returned 0 after 0 usecs
[    0.079031] calling  net_dev_init+0x0/0x100 @ 1
[    0.079096] initcall net_dev_init+0x0/0x100 returned 0 after 0 usecs
[    0.079106] calling  neigh_init+0x0/0x80 @ 1
[    0.079112] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.079121] calling  genl_init+0x0/0xd0 @ 1
[    0.079138] initcall genl_init+0x0/0xd0 returned 0 after 0 usecs
[    0.079138] calling  wireless_nlevent_init+0x0/0x20 @ 1
[    0.079138] initcall wireless_nlevent_init+0x0/0x20 returned 0 after 
0 usecs
[    0.079138] calling  cfg80211_init+0x0/0x80 @ 1
[    0.079138] cfg80211: Using static regulatory domain info
[    0.079138] cfg80211: Regulatory domain: US
[    0.079138] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[    0.079138] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.079138] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.079138] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.079138] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.079138] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.079138] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.079138] cfg80211: Calling CRDA for country: US
[    0.079140] initcall cfg80211_init+0x0/0x80 returned 0 after 0 usecs
[    0.079150] calling  ieee80211_init+0x0/0x20 @ 1
[    0.079156] initcall ieee80211_init+0x0/0x20 returned 0 after 0 usecs
[    0.079163] calling  rfkill_init+0x0/0x70 @ 1
[    0.079207] initcall rfkill_init+0x0/0x70 returned 0 after 0 usecs
[    0.079215] calling  sysctl_init+0x0/0x40 @ 1
[    0.079220] initcall sysctl_init+0x0/0x40 returned 0 after 0 usecs
[    0.079228] calling  pci_iommu_init+0x0/0x10 @ 1
[    0.079233] initcall pci_iommu_init+0x0/0x10 returned 0 after 0 usecs
[    0.079242] calling  print_all_ICs+0x0/0x880 @ 1
[    0.079248] initcall print_all_ICs+0x0/0x880 returned 0 after 0 usecs
[    0.079257] calling  hpet_late_init+0x0/0x180 @ 1
[    0.079505] hpet clockevent registered
[    0.079510] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.079519] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.079527] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.080998] initcall hpet_late_init+0x0/0x180 returned 0 after 1952 usecs
[    0.081007] calling  clocksource_done_booting+0x0/0x10 @ 1
[    0.081013] initcall clocksource_done_booting+0x0/0x10 returned 0 
after 0 usecs
[    0.081021] calling  rb_init_debugfs+0x0/0x50 @ 1
[    0.081033] initcall rb_init_debugfs+0x0/0x50 returned 0 after 0 usecs
[    0.081041] calling  tracer_init_debugfs+0x0/0x310 @ 1
[    0.081068] initcall tracer_init_debugfs+0x0/0x310 returned 0 after 0 
usecs
[    0.081076] calling  init_pipe_fs+0x0/0x50 @ 1
[    0.081094] initcall init_pipe_fs+0x0/0x50 returned 0 after 0 usecs
[    0.081102] calling  init_mnt_writers+0x0/0x10 @ 1
[    0.081107] initcall init_mnt_writers+0x0/0x10 returned 0 after 0 usecs
[    0.081115] calling  eventpoll_init+0x0/0xa0 @ 1
[    0.081126] initcall eventpoll_init+0x0/0xa0 returned 0 after 0 usecs
[    0.081133] calling  anon_inode_init+0x0/0x100 @ 1
[    0.081143] initcall anon_inode_init+0x0/0x100 returned 0 after 0 usecs
[    0.081152] calling  acpi_event_init+0x0/0x78 @ 1
[    0.081161] initcall acpi_event_init+0x0/0x78 returned 0 after 0 usecs
[    0.081161] calling  pnpacpi_init+0x0/0xa0 @ 1
[    0.081161] pnp: PnP ACPI init
[    0.081161] ACPI: bus type pnp registered
[    0.085371] pnp: PnP ACPI: found 13 devices
[    0.085376] ACPI: ACPI bus type pnp unregistered
[    0.085384] initcall pnpacpi_init+0x0/0xa0 returned 0 after 4288 usecs
[    0.085396] calling  pnp_system_init+0x0/0x10 @ 1
[    0.085417] system 00:01: iomem range 0xfed13000-0xfed19fff has been 
reserved
[    0.085435] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.085440] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.085445] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.085451] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.085462] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been 
reserved
[    0.085468] system 00:08: iomem range 0xfed20000-0xfed8ffff has been 
reserved
[    0.085474] system 00:08: iomem range 0xfff00000-0xffffffff could not 
be reserved
[    0.085484] system 00:09: iomem range 0xfec00000-0xfec00fff has been 
reserved
[    0.085490] system 00:09: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.085499] system 00:0a: iomem range 0xe0000000-0xefffffff has been 
reserved
[    0.085512] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[    0.085524] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.085529] system 00:0c: iomem range 0xe0000-0xfffff could not be 
reserved
[    0.085535] system 00:0c: iomem range 0x100000-0x3f7fffff could not 
be reserved
[    0.085592] initcall pnp_system_init+0x0/0x10 returned 0 after 185 usecs
[    0.085601] calling  chr_dev_init+0x0/0xb0 @ 1
[    0.086077] initcall chr_dev_init+0x0/0xb0 returned 0 after 457 usecs
[    0.086087] calling  firmware_class_init+0x0/0x70 @ 1
[    0.086136] initcall firmware_class_init+0x0/0x70 returned 0 after 41 
usecs
[    0.086146] calling  loopback_init+0x0/0x10 @ 1
[    0.086282] initcall loopback_init+0x0/0x10 returned 0 after 126 usecs
[    0.086292] calling  init_acpi_pm_clocksource+0x0/0x230 @ 1
[    0.120833] initcall init_acpi_pm_clocksource+0x0/0x230 returned 0 
after 33725 usecs
[    0.120843] calling  pcibios_assign_resources+0x0/0x80 @ 1
[    0.120882] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.120886] pci 0000:00:1c.0:   IO window: disabled
[    0.120893] pci 0000:00:1c.0:   MEM window: disabled
[    0.120899] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.120907] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.120911] pci 0000:00:1c.1:   IO window: disabled
[    0.120918] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.120924] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.120932] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.120936] pci 0000:00:1c.2:   IO window: disabled
[    0.120943] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.120949] pci 0000:00:1c.2:   PREFETCH window: 
0x000000f0000000-0x000000f6ffffff
[    0.120958] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.120962] pci 0000:00:1e.0:   IO window: disabled
[    0.120968] pci 0000:00:1e.0:   MEM window: disabled
[    0.120974] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.121003] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.121010] pci 0000:00:1c.0: setting latency timer to 64
[    0.121021] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.121027] pci 0000:00:1c.1: setting latency timer to 64
[    0.121038] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.121044] pci 0000:00:1c.2: setting latency timer to 64
[    0.121053] pci 0000:00:1e.0: setting latency timer to 64
[    0.121059] bus: 00 index 0 io port: [0x00-0xffff]
[    0.121063] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.121067] bus: 04 index 0 mmio: [0x0-0x0]
[    0.121071] bus: 04 index 1 mmio: [0x0-0x0]
[    0.121074] bus: 04 index 2 mmio: [0x0-0x0]
[    0.121078] bus: 04 index 3 mmio: [0x0-0x0]
[    0.121082] bus: 03 index 0 mmio: [0x0-0x0]
[    0.121086] bus: 03 index 1 mmio: [0xfbf00000-0xfbffffff]
[    0.121090] bus: 03 index 2 mmio: [0x0-0x0]
[    0.121093] bus: 03 index 3 mmio: [0x0-0x0]
[    0.121097] bus: 01 index 0 mmio: [0x0-0x0]
[    0.121101] bus: 01 index 1 mmio: [0xf8000000-0xfbefffff]
[    0.121105] bus: 01 index 2 mmio: [0xf0000000-0xf6ffffff]
[    0.121109] bus: 01 index 3 mmio: [0x0-0x0]
[    0.121113] bus: 05 index 0 mmio: [0x0-0x0]
[    0.121116] bus: 05 index 1 mmio: [0x0-0x0]
[    0.121120] bus: 05 index 2 mmio: [0x0-0x0]
[    0.121124] bus: 05 index 3 io port: [0x00-0xffff]
[    0.121128] bus: 05 index 4 mmio: [0x000000-0xffffffff]
[    0.121135] initcall pcibios_assign_resources+0x0/0x80 returned 0 
after 277 usecs
[    0.121145] calling  inet_init+0x0/0x1f0 @ 1
[    0.121161] NET: Registered protocol family 2
[    0.121263] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.121397] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.123091] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.123578] TCP: Hash tables configured (established 131072 bind 65536)
[    0.123585] TCP reno registered
[    0.123717] initcall inet_init+0x0/0x1f0 returned 0 after 2492 usecs
[    0.123735] calling  af_unix_init+0x0/0x50 @ 1
[    0.123741] NET: Registered protocol family 1
[    0.123752] initcall af_unix_init+0x0/0x50 returned 0 after 12 usecs
[    0.123764] calling  populate_rootfs+0x0/0xa0 @ 1
[    0.123976] initcall populate_rootfs+0x0/0xa0 returned 0 after 197 usecs
[    0.124005] calling  i8259A_init_sysfs+0x0/0x20 @ 1
[    0.124165] initcall i8259A_init_sysfs+0x0/0x20 returned 0 after 147 
usecs
[    0.124176] calling  sbf_init+0x0/0xb0 @ 1
[    0.124182] initcall sbf_init+0x0/0xb0 returned 0 after 0 usecs
[    0.124191] calling  i8237A_init_sysfs+0x0/0x20 @ 1
[    0.124273] initcall i8237A_init_sysfs+0x0/0x20 returned 0 after 74 usecs
[    0.124283] calling  add_rtc_cmos+0x0/0xa0 @ 1
[    0.124294] initcall add_rtc_cmos+0x0/0xa0 returned 0 after 5 usecs
[    0.124301] calling  cache_sysfs_init+0x0/0x240 @ 1
[    0.124307] initcall cache_sysfs_init+0x0/0x240 returned 0 after 0 usecs
[    0.124314] calling  thermal_throttle_init_device+0x0/0x40 @ 1
[    0.124321] initcall thermal_throttle_init_device+0x0/0x40 returned 0 
after 0 usecs
[    0.124329] calling  init_nonfatal_mce_checker+0x0/0x60 @ 1
[    0.124335] Machine check exception polling timer started.
[    0.124341] initcall init_nonfatal_mce_checker+0x0/0x60 returned 0 
after 5 usecs
[    0.124349] calling  msr_init+0x0/0xc0 @ 1
[    0.124481] initcall msr_init+0x0/0xc0 returned 0 after 122 usecs
[    0.124491] calling  cpuid_init+0x0/0xc0 @ 1
[    0.124592] initcall cpuid_init+0x0/0xc0 returned 0 after 92 usecs
[    0.124603] calling  init_lapic_sysfs+0x0/0x30 @ 1
[    0.124685] initcall init_lapic_sysfs+0x0/0x30 returned 0 after 72 usecs
[    0.124695] calling  ioapic_init_sysfs+0x0/0xa0 @ 1
[    0.124774] initcall ioapic_init_sysfs+0x0/0xa0 returned 0 after 70 usecs
[    0.124785] calling  microcode_init+0x0/0x110 @ 1
[    0.124916] Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.124928] initcall microcode_init+0x0/0x110 returned 0 after 130 usecs
[    0.124939] calling  aes_init+0x0/0x10 @ 1
[    0.124998] alg: cipher: Test 1 failed on encryption for aes-asm
[    0.125064] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08
[    0.125081] initcall aes_init+0x0/0x10 returned 0 after 131 usecs
[    0.125092] calling  proc_execdomains_init+0x0/0x30 @ 1
[    0.125105] initcall proc_execdomains_init+0x0/0x30 returned 0 after 
6 usecs
[    0.125114] calling  ioresources_init+0x0/0x40 @ 1
[    0.125123] initcall ioresources_init+0x0/0x40 returned 0 after 2 usecs
[    0.125132] calling  uid_cache_init+0x0/0x60 @ 1
[    0.125144] initcall uid_cache_init+0x0/0x60 returned 0 after 5 usecs
[    0.125152] calling  init_posix_timers+0x0/0xd0 @ 1
[    0.125159] initcall init_posix_timers+0x0/0xd0 returned 0 after 1 usecs
[    0.125166] calling  init_posix_cpu_timers+0x0/0xb0 @ 1
[    0.125172] initcall init_posix_cpu_timers+0x0/0xb0 returned 0 after 
0 usecs
[    0.125179] calling  nsproxy_cache_init+0x0/0x30 @ 1
[    0.125185] initcall nsproxy_cache_init+0x0/0x30 returned 0 after 1 usecs
[    0.125193] calling  timekeeping_init_device+0x0/0x20 @ 1
[    0.125291] initcall timekeeping_init_device+0x0/0x20 returned 0 
after 89 usecs
[    0.125301] calling  init_clocksource_sysfs+0x0/0x40 @ 1
[    0.125385] initcall init_clocksource_sysfs+0x0/0x40 returned 0 after 
76 usecs
[    0.125394] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    0.125403] initcall init_timer_list_procfs+0x0/0x30 returned 0 after 
3 usecs
[    0.125410] calling  futex_init+0x0/0x60 @ 1
[    0.125423] initcall futex_init+0x0/0x60 returned 0 after 8 usecs
[    0.125430] calling  proc_dma_init+0x0/0x30 @ 1
[    0.125437] initcall proc_dma_init+0x0/0x30 returned 0 after 1 usecs
[    0.125443] calling  kallsyms_init+0x0/0x30 @ 1
[    0.125450] initcall kallsyms_init+0x0/0x30 returned 0 after 1 usecs
[    0.125457] calling  ikconfig_init+0x0/0x40 @ 1
[    0.125464] initcall ikconfig_init+0x0/0x40 returned 0 after 1 usecs
[    0.125471] calling  utsname_sysctl_init+0x0/0x10 @ 1
[    0.125479] initcall utsname_sysctl_init+0x0/0x10 returned 0 after 3 
usecs
[    0.125487] calling  init_sched_switch_trace+0x0/0x40 @ 1
[    0.125494] initcall init_sched_switch_trace+0x0/0x40 returned 0 
after 2 usecs
[    0.125503] calling  init_per_zone_pages_min+0x0/0x50 @ 1
[    0.125574] initcall init_per_zone_pages_min+0x0/0x50 returned 0 
after 61 usecs
[    0.125581] calling  pdflush_init+0x0/0x20 @ 1
[    0.125622] initcall pdflush_init+0x0/0x20 returned 0 after 34 usecs
[    0.125630] calling  kswapd_init+0x0/0x10 @ 1
[    0.125651] initcall kswapd_init+0x0/0x10 returned 0 after 16 usecs
[    0.125659] calling  setup_vmstat+0x0/0x90 @ 1
[    0.125672] initcall setup_vmstat+0x0/0x90 returned 0 after 7 usecs
[    0.125680] calling  mm_sysfs_init+0x0/0x20 @ 1
[    0.125690] initcall mm_sysfs_init+0x0/0x20 returned 0 after 4 usecs
[    0.125697] calling  proc_vmalloc_init+0x0/0x30 @ 1
[    0.125705] initcall proc_vmalloc_init+0x0/0x30 returned 0 after 2 usecs
[    0.125713] calling  init_emergency_pool+0x0/0x70 @ 1
[    0.125752] highmem bounce pool size: 64 pages
[    0.125757] initcall init_emergency_pool+0x0/0x70 returned 0 after 37 
usecs
[    0.125765] calling  init_tmpfs+0x0/0xd0 @ 1
[    0.125794] initcall init_tmpfs+0x0/0xd0 returned 0 after 23 usecs
[    0.125801] calling  fasync_init+0x0/0x30 @ 1
[    0.125809] initcall fasync_init+0x0/0x30 returned 0 after 2 usecs
[    0.125818] calling  proc_filesystems_init+0x0/0x30 @ 1
[    0.125826] initcall proc_filesystems_init+0x0/0x30 returned 0 after 
2 usecs
[    0.125834] calling  inotify_setup+0x0/0x10 @ 1
[    0.125840] initcall inotify_setup+0x0/0x10 returned 0 after 0 usecs
[    0.125848] calling  inotify_user_setup+0x0/0xc0 @ 1
[    0.125862] initcall inotify_user_setup+0x0/0xc0 returned 0 after 8 usecs
[    0.125870] calling  proc_locks_init+0x0/0x30 @ 1
[    0.125877] initcall proc_locks_init+0x0/0x30 returned 0 after 2 usecs
[    0.125885] calling  init_mbcache+0x0/0x10 @ 1
[    0.125891] initcall init_mbcache+0x0/0x10 returned 0 after 0 usecs
[    0.125899] calling  proc_cmdline_init+0x0/0x30 @ 1
[    0.125907] initcall proc_cmdline_init+0x0/0x30 returned 0 after 2 usecs
[    0.125916] calling  proc_cpuinfo_init+0x0/0x30 @ 1
[    0.125925] initcall proc_cpuinfo_init+0x0/0x30 returned 0 after 3 usecs
[    0.125933] calling  proc_devices_init+0x0/0x30 @ 1
[    0.125940] initcall proc_devices_init+0x0/0x30 returned 0 after 1 usecs
[    0.125948] calling  proc_interrupts_init+0x0/0x30 @ 1
[    0.125956] initcall proc_interrupts_init+0x0/0x30 returned 0 after 2 
usecs
[    0.125964] calling  proc_loadavg_init+0x0/0x30 @ 1
[    0.125972] initcall proc_loadavg_init+0x0/0x30 returned 0 after 1 usecs
[    0.125980] calling  proc_meminfo_init+0x0/0x30 @ 1
[    0.125996] initcall proc_meminfo_init+0x0/0x30 returned 0 after 2 usecs
[    0.126004] calling  proc_stat_init+0x0/0x30 @ 1
[    0.126012] initcall proc_stat_init+0x0/0x30 returned 0 after 1 usecs
[    0.126020] calling  proc_uptime_init+0x0/0x30 @ 1
[    0.126032] initcall proc_uptime_init+0x0/0x30 returned 0 after 7 usecs
[    0.126041] calling  proc_version_init+0x0/0x30 @ 1
[    0.126048] initcall proc_version_init+0x0/0x30 returned 0 after 2 usecs
[    0.126058] calling  proc_kcore_init+0x0/0x50 @ 1
[    0.126065] initcall proc_kcore_init+0x0/0x50 returned 0 after 1 usecs
[    0.126073] calling  proc_kmsg_init+0x0/0x30 @ 1
[    0.126080] initcall proc_kmsg_init+0x0/0x30 returned 0 after 1 usecs
[    0.126088] calling  proc_page_init+0x0/0x50 @ 1
[    0.126098] initcall proc_page_init+0x0/0x50 returned 0 after 4 usecs
[    0.126106] calling  init_devpts_fs+0x0/0x30 @ 1
[    0.126121] initcall init_devpts_fs+0x0/0x30 returned 0 after 9 usecs
[    0.126129] calling  init_ext3_fs+0x0/0x70 @ 1
[    0.126143] initcall init_ext3_fs+0x0/0x70 returned 0 after 8 usecs
[    0.126151] calling  journal_init+0x0/0xa0 @ 1
[    0.126162] initcall journal_init+0x0/0xa0 returned 0 after 4 usecs
[    0.126169] calling  init_ext2_fs+0x0/0x70 @ 1
[    0.126179] initcall init_ext2_fs+0x0/0x70 returned 0 after 4 usecs
[    0.126188] calling  init_ramfs_fs+0x0/0x10 @ 1
[    0.126195] initcall init_ramfs_fs+0x0/0x10 returned 0 after 2 usecs
[    0.126203] calling  init_fat_fs+0x0/0x50 @ 1
[    0.126210] initcall init_fat_fs+0x0/0x50 returned 0 after 1 usecs
[    0.126217] calling  init_vfat_fs+0x0/0x10 @ 1
[    0.126225] initcall init_vfat_fs+0x0/0x10 returned 0 after 2 usecs
[    0.126233] calling  init_iso9660_fs+0x0/0x60 @ 1
[    0.126241] initcall init_iso9660_fs+0x0/0x60 returned 0 after 2 usecs
[    0.126249] calling  init_nls_cp437+0x0/0x10 @ 1
[    0.126255] initcall init_nls_cp437+0x0/0x10 returned 0 after 0 usecs
[    0.126264] calling  init_nls_cp1250+0x0/0x10 @ 1
[    0.126269] initcall init_nls_cp1250+0x0/0x10 returned 0 after 0 usecs
[    0.126278] calling  init_nls_ascii+0x0/0x10 @ 1
[    0.126283] initcall init_nls_ascii+0x0/0x10 returned 0 after 0 usecs
[    0.126292] calling  init_nls_iso8859_1+0x0/0x10 @ 1
[    0.126298] initcall init_nls_iso8859_1+0x0/0x10 returned 0 after 0 usecs
[    0.126306] calling  init_nls_utf8+0x0/0x30 @ 1
[    0.126312] initcall init_nls_utf8+0x0/0x30 returned 0 after 0 usecs
[    0.126320] calling  fuse_init+0x0/0x130 @ 1
[    0.126324] fuse init (API version 7.10)
[    0.126425] initcall fuse_init+0x0/0x130 returned 0 after 94 usecs
[    0.126437] calling  ipc_init+0x0/0x20 @ 1
[    0.126447] msgmni has been set to 1749
[    0.126458] initcall ipc_init+0x0/0x20 returned 0 after 15 usecs
[    0.126466] calling  ipc_sysctl_init+0x0/0x10 @ 1
[    0.126474] initcall ipc_sysctl_init+0x0/0x10 returned 0 after 2 usecs
[    0.126482] calling  init_mqueue_fs+0x0/0xb0 @ 1
[    0.126507] initcall init_mqueue_fs+0x0/0xb0 returned 0 after 18 usecs
[    0.126515] calling  crypto_algapi_init+0x0/0x10 @ 1
[    0.126524] initcall crypto_algapi_init+0x0/0x10 returned 0 after 2 usecs
[    0.126533] calling  chainiv_module_init+0x0/0x10 @ 1
[    0.126542] initcall chainiv_module_init+0x0/0x10 returned 0 after 3 
usecs
[    0.126552] calling  eseqiv_module_init+0x0/0x10 @ 1
[    0.126558] initcall eseqiv_module_init+0x0/0x10 returned 0 after 0 usecs
[    0.126567] calling  crypto_ecb_module_init+0x0/0x10 @ 1
[    0.126573] initcall crypto_ecb_module_init+0x0/0x10 returned 0 after 
0 usecs
[    0.126582] calling  aes_init+0x0/0x340 @ 1
[    0.126705] initcall aes_init+0x0/0x340 returned 0 after 112 usecs
[    0.126715] calling  arc4_init+0x0/0x10 @ 1
[    0.126818] initcall arc4_init+0x0/0x10 returned 0 after 94 usecs
[    0.126827] calling  krng_mod_init+0x0/0x10 @ 1
[    0.126848] alg: No test for stdrng (krng)
[    0.126860] initcall krng_mod_init+0x0/0x10 returned 0 after 25 usecs
[    0.126869] calling  proc_genhd_init+0x0/0x40 @ 1
[    0.126881] initcall proc_genhd_init+0x0/0x40 returned 0 after 6 usecs
[    0.126889] calling  noop_init+0x0/0x10 @ 1
[    0.126894] io scheduler noop registered
[    0.126899] initcall noop_init+0x0/0x10 returned 0 after 4 usecs
[    0.126908] calling  deadline_init+0x0/0x10 @ 1
[    0.126911] io scheduler deadline registered (default)
[    0.126917] initcall deadline_init+0x0/0x10 returned 0 after 3 usecs
[    0.126928] calling  pci_init+0x0/0x40 @ 1
[    0.126946] pci 0000:00:02.0: Boot video device
[    0.129784] initcall pci_init+0x0/0x40 returned 0 after 2780 usecs
[    0.129797] calling  pci_proc_init+0x0/0x70 @ 1
[    0.129862] initcall pci_proc_init+0x0/0x70 returned 0 after 58 usecs
[    0.129871] calling  pcie_portdrv_init+0x0/0x50 @ 1
[    0.129978] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.130025] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.130056] pcieport-driver 0000:00:1c.0: irq 287 for MSI/MSI-X
[    0.130071] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.130132] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.130184] pci_express 0000:00:1c.0:pcie03: allocate port service
[    0.130285] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.130325] pcieport-driver 0000:00:1c.1: found MSI capability
[    0.130351] pcieport-driver 0000:00:1c.1: irq 286 for MSI/MSI-X
[    0.130366] pci_express 0000:00:1c.1:pcie00: allocate port service
[    0.130419] pci_express 0000:00:1c.1:pcie02: allocate port service
[    0.130475] pci_express 0000:00:1c.1:pcie03: allocate port service
[    0.130576] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.130613] pcieport-driver 0000:00:1c.2: found MSI capability
[    0.130640] pcieport-driver 0000:00:1c.2: irq 285 for MSI/MSI-X
[    0.130654] pci_express 0000:00:1c.2:pcie00: allocate port service
[    0.130712] pci_express 0000:00:1c.2:pcie02: allocate port service
[    0.130766] pci_express 0000:00:1c.2:pcie03: allocate port service
[    0.130908] initcall pcie_portdrv_init+0x0/0x50 returned 0 after 1004 
usecs
[    0.130920] calling  aer_service_init+0x0/0x20 @ 1
[    0.130973] initcall aer_service_init+0x0/0x20 returned 0 after 44 usecs
[    0.131008] calling  fb_console_init+0x0/0x130 @ 1
[    0.131079] initcall fb_console_init+0x0/0x130 returned 0 after 62 usecs
[    0.131092] calling  display_class_init+0x0/0x70 @ 1
[    0.131141] initcall display_class_init+0x0/0x70 returned 0 after 40 
usecs
[    0.131152] calling  vesafb_init+0x0/0x1fb @ 1
[    0.131266] initcall vesafb_init+0x0/0x1fb returned 0 after 103 usecs
[    0.131278] calling  acpi_reserve_resources+0x0/0xc4 @ 1
[    0.131290] initcall acpi_reserve_resources+0x0/0xc4 returned 0 after 
4 usecs
[    0.131298] calling  acpi_ac_init+0x0/0x39 @ 1
[    0.131513] ACPI: AC Adapter [AC0] (on-line)
[    0.131609] initcall acpi_ac_init+0x0/0x39 returned 0 after 296 usecs
[    0.131618] calling  acpi_battery_init+0x0/0x39 @ 1
[    0.134025] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.421506] ACPI: Battery Slot [BAT0] (battery present)
[    0.421890] initcall acpi_battery_init+0x0/0x39 returned 0 after 
283458 usecs
[    0.421901] calling  acpi_button_init+0x0/0x4d @ 1
[    0.422061] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.422066] ACPI: Power Button (FF) [PWRF]
[    0.422203] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.438027] ACPI: Lid Switch [LID]
[    0.438181] input: Sleep Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.438187] ACPI: Sleep Button (CM) [SLPB]
[    0.438306] input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[    0.438312] ACPI: Power Button (CM) [PWRB]
[    0.438363] initcall acpi_button_init+0x0/0x4d returned 0 after 16067 
usecs
[    0.438373] calling  acpi_fan_init+0x0/0x28 @ 1
[    0.438442] initcall acpi_fan_init+0x0/0x28 returned 0 after 61 usecs
[    0.438451] calling  irqrouter_init_sysfs+0x0/0x2d @ 1
[    0.438533] initcall irqrouter_init_sysfs+0x0/0x2d returned 0 after 
73 usecs
[    0.438542] calling  acpi_processor_init+0x0/0x85 @ 1
[    0.439234] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.439313] processor ACPI_CPU:00: registered as cooling_device0
[    0.439321] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.439389] initcall acpi_processor_init+0x0/0x85 returned 0 after 
819 usecs
[    0.439399] calling  acpi_thermal_init+0x0/0x72 @ 1
[    0.463076] thermal LNXTHERM:01: registered as thermal_zone0
[    0.479766] ACPI: Thermal Zone [TZ00] (56 C)
[    0.479830] initcall acpi_thermal_init+0x0/0x72 returned 0 after 
39475 usecs
[    0.479842] calling  rand_initialize+0x0/0x30 @ 1
[    0.479888] initcall rand_initialize+0x0/0x30 returned 0 after 38 usecs
[    0.479895] calling  tty_init+0x0/0x110 @ 1
[    0.484038] initcall tty_init+0x0/0x110 returned 0 after 4034 usecs
[    0.484051] calling  pty_init+0x0/0x290 @ 1
[    0.484167] initcall pty_init+0x0/0x290 returned 0 after 106 usecs
[    0.484184] calling  sysrq_init+0x0/0x30 @ 1
[    0.484203] initcall sysrq_init+0x0/0x30 returned 0 after 13 usecs
[    0.484210] calling  hpet_init+0x0/0x60 @ 1
[    0.484360] initcall hpet_init+0x0/0x60 returned 0 after 139 usecs
[    0.484369] calling  nvram_init+0x0/0x80 @ 1
[    0.484437] Non-volatile memory driver v1.2
[    0.484444] initcall nvram_init+0x0/0x80 returned 0 after 67 usecs
[    0.484452] calling  agp_init+0x0/0x30 @ 1
[    0.484456] Linux agpgart interface v0.103
[    0.484461] initcall agp_init+0x0/0x30 returned 0 after 3 usecs
[    0.484469] calling  agp_intel_init+0x0/0x30 @ 1
[    0.484499] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    0.484794] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    0.488307] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.488377] initcall agp_intel_init+0x0/0x30 returned 0 after 3807 usecs
[    0.488391] calling  drm_core_init+0x0/0x100 @ 1
[    0.488454] [drm] Initialized drm 1.1.0 20060810
[    0.488460] initcall drm_core_init+0x0/0x100 returned 0 after 61 usecs
[    0.488469] calling  i915_init+0x0/0x20 @ 1
[    0.488503] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.488509] pci 0000:00:02.0: setting latency timer to 64
[    0.488588] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read 
from MCHBAR.  Disabling tiling.
[    0.488795] [drm] Initialized i915 1.6.0 20080730 on minor 0
[    0.488835] initcall i915_init+0x0/0x20 returned 0 after 351 usecs
[    0.488844] calling  loop_init+0x0/0x1c0 @ 1
[    0.489894] loop: module loaded
[    0.489902] initcall loop_init+0x0/0x1c0 returned 0 after 1026 usecs
[    0.489914] calling  eeepc_laptop_init+0x0/0x1c0 @ 1
[    0.489950] eeepc: Eee PC Hotkey Driver
[    0.490217] eeepc: Hotkey init flags 0x41
[    0.491472] eeepc: Get control methods supported: 0x101711
[    0.491616] input: Asus EeePC extra buttons as 
/devices/virtual/input/input4
[    0.495990] initcall eeepc_laptop_init+0x0/0x1c0 returned 0 after 
5924 usecs
[    0.496002] calling  atl2_init_module+0x0/0x50 @ 1
[    0.496006] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    0.496010] Copyright (c) 2007 Atheros Corporation.
[    0.496045] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.496057] atl2 0000:03:00.0: setting latency timer to 64
[    0.534415] initcall atl2_init_module+0x0/0x50 returned 0 after 37504 
usecs
[    0.534429] calling  net_olddevs_init+0x0/0x90 @ 1
[    0.534441] initcall net_olddevs_init+0x0/0x90 returned 0 after 6 usecs
[    0.534449] calling  init_ath5k_pci+0x0/0x30 @ 1
[    0.534486] ath5k_pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    0.534498] ath5k_pci 0000:01:00.0: setting latency timer to 64
[    0.534542] ath5k_pci 0000:01:00.0: registered as 'phy0'
[    0.574864] phy0: Selected rate control algorithm 'minstrel'
[    0.575138] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    0.575211] initcall init_ath5k_pci+0x0/0x30 returned 0 after 39798 usecs
[    0.575224] calling  videodev_init+0x0/0x90 @ 1
[    0.575227] Linux video capture interface: v2.00
[    0.575283] initcall videodev_init+0x0/0x90 returned 0 after 51 usecs
[    0.575292] calling  uvc_init+0x0/0x90 @ 1
[    0.575455] usbcore: registered new interface driver uvcvideo
[    0.575461] USB Video Class driver (v0.1.0)
[    0.575467] initcall uvc_init+0x0/0x90 returned 0 after 165 usecs
[    0.575476] calling  init_sd+0x0/0xa0 @ 1
[    0.575529] Driver 'sd' needs updating - please use bus_type methods
[    0.575579] initcall init_sd+0x0/0xa0 returned 0 after 95 usecs
[    0.575588] calling  piix_init+0x0/0x30 @ 1
[    0.575616] ata_piix 0000:00:1f.2: version 2.12
[    0.575639] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.575645] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    0.575705] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.575781] scsi0 : ata_piix
[    0.575954] scsi1 : ata_piix
[    0.579246] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 
irq 14
[    0.579252] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 
irq 15
[    0.580183] Switched to high resolution mode on CPU 0
[    0.897363] ata2.00: ATA-5: ASUS-PHISON OB SSD, TST2.04P, max UDMA/66
[    0.897368] ata2.00: 7880544 sectors, multi 0: LBA
[    0.897441] ata2.01: ATA-5: ASUS-PHISON SSD, TST2.04P, max UDMA/66
[    0.897445] ata2.01: 31522176 sectors, multi 0: LBA
[    0.900338] ata2.00: configured for UDMA/66
[    0.903332] ata2.01: configured for UDMA/66
[    0.903481] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON OB S 
TST2 PQ: 0 ANSI: 5
[    0.903772] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: 
(4.03 GB/3.75 GiB)
[    0.903796] sd 1:0:0:0: [sda] Write Protect is off
[    0.903800] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.903834] sd 1:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.903930] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: 
(4.03 GB/3.75 GiB)
[    0.903951] sd 1:0:0:0: [sda] Write Protect is off
[    0.903955] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.903987] sd 1:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.903992]  sda: sda1 sda2 sda3 sda4
[    0.905460] sd 1:0:0:0: [sda] Attached SCSI disk
[    0.905648] scsi 1:0:1:0: Direct-Access     ATA      ASUS-PHISON SSD 
  TST2 PQ: 0 ANSI: 5
[    0.905899] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: 
(16.1 GB/15.0 GiB)
[    0.905923] sd 1:0:1:0: [sdb] Write Protect is off
[    0.905927] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    0.905960] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.906064] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: 
(16.1 GB/15.0 GiB)
[    0.906087] sd 1:0:1:0: [sdb] Write Protect is off
[    0.906091] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    0.906123] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.906129]  sdb: sdb1 sdb2
[    0.907751] sd 1:0:1:0: [sdb] Attached SCSI disk
[    0.907879] initcall piix_init+0x0/0x30 returned 0 after 324493 usecs
[    0.907891] calling  ehci_hcd_init+0x0/0x80 @ 1
[    0.907895] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.907939] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    0.907968] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.907974] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.908091] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    0.912011] ehci_hcd 0000:00:1d.7: debug port 1
[    0.912019] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.912037] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    0.921011] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.921205] usb usb1: configuration #1 chosen from 1 choice
[    0.921290] hub 1-0:1.0: USB hub found
[    0.921303] hub 1-0:1.0: 8 ports detected
[    0.921587] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.921593] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.921598] usb usb1: Product: EHCI Host Controller
[    0.921602] usb usb1: Manufacturer: Linux 
2.6.28-rc9-00070-gc20137f-dirty ehci_hcd
[    0.921606] usb usb1: SerialNumber: 0000:00:1d.7
[    0.921664] initcall ehci_hcd_init+0x0/0x80 returned 0 after 13440 usecs
[    0.921676] calling  uhci_hcd_init+0x0/0xc0 @ 1
[    0.921680] uhci_hcd: USB Universal Host Controller Interface driver
[    0.921711] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    0.921723] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.921728] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.921802] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    0.921833] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    0.922031] usb usb2: configuration #1 chosen from 1 choice
[    0.922115] hub 2-0:1.0: USB hub found
[    0.922128] hub 2-0:1.0: 2 ports detected
[    0.922327] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.922332] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.922337] usb usb2: Product: UHCI Host Controller
[    0.922341] usb usb2: Manufacturer: Linux 
2.6.28-rc9-00070-gc20137f-dirty uhci_hcd
[    0.922345] usb usb2: SerialNumber: 0000:00:1d.0
[    0.922376] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.922387] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.922392] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.922465] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    0.922502] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    0.922678] usb usb3: configuration #1 chosen from 1 choice
[    0.922768] hub 3-0:1.0: USB hub found
[    0.922781] hub 3-0:1.0: 2 ports detected
[    0.922985] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.922990] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.922995] usb usb3: Product: UHCI Host Controller
[    0.922999] usb usb3: Manufacturer: Linux 
2.6.28-rc9-00070-gc20137f-dirty uhci_hcd
[    0.923015] usb usb3: SerialNumber: 0000:00:1d.1
[    0.923045] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    0.923055] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.923060] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.923132] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    0.923165] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    0.923352] usb usb4: configuration #1 chosen from 1 choice
[    0.923438] hub 4-0:1.0: USB hub found
[    0.923450] hub 4-0:1.0: 2 ports detected
[    0.923646] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.923653] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.923657] usb usb4: Product: UHCI Host Controller
[    0.923661] usb usb4: Manufacturer: Linux 
2.6.28-rc9-00070-gc20137f-dirty uhci_hcd
[    0.923665] usb usb4: SerialNumber: 0000:00:1d.2
[    0.923693] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) 
-> IRQ 16
[    0.923703] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.923708] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.923786] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 5
[    0.923822] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    0.924035] usb usb5: configuration #1 chosen from 1 choice
[    0.924121] hub 5-0:1.0: USB hub found
[    0.924133] hub 5-0:1.0: 2 ports detected
[    0.924339] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.924345] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.924349] usb usb5: Product: UHCI Host Controller
[    0.924353] usb usb5: Manufacturer: Linux 
2.6.28-rc9-00070-gc20137f-dirty uhci_hcd
[    0.924358] usb usb5: SerialNumber: 0000:00:1d.3
[    0.924427] initcall uhci_hcd_init+0x0/0xc0 returned 0 after 2677 usecs
[    0.924440] calling  usb_stor_init+0x0/0x40 @ 1
[    0.924443] Initializing USB Mass Storage driver...
[    0.924533] usbcore: registered new interface driver usb-storage
[    0.924541] USB Mass Storage support registered.
[    0.924548] initcall usb_stor_init+0x0/0x40 returned 0 after 99 usecs
[    0.924558] calling  i8042_init+0x0/0x420 @ 1
[    0.924730] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 
0x60,0x64 irq 1,12
[    0.956821] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.956830] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.956841] initcall i8042_init+0x0/0x420 returned 0 after 31518 usecs
[    0.956851] calling  mousedev_init+0x0/0x90 @ 1
[    0.957125] mice: PS/2 mouse device common for all mice
[    0.957134] initcall mousedev_init+0x0/0x90 returned 0 after 269 usecs
[    0.957143] calling  evdev_init+0x0/0x10 @ 1
[    0.957599] initcall evdev_init+0x0/0x10 returned 0 after 436 usecs
[    0.957609] calling  atkbd_init+0x0/0x20 @ 1
[    0.957669] initcall atkbd_init+0x0/0x20 returned 0 after 52 usecs
[    0.957680] calling  psmouse_init+0x0/0x70 @ 1
[    0.958455] initcall psmouse_init+0x0/0x70 returned 0 after 750 usecs
[    0.958466] calling  cmos_init+0x0/0x40 @ 1
[    0.958503] rtc_cmos 00:03: RTC can wake from S4
[    0.958605] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.958635] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.958692] initcall cmos_init+0x0/0x40 returned 0 after 213 usecs
[    0.958703] calling  init_ladder+0x0/0x10 @ 1
[    0.958881] cpuidle: using governor ladder
[    0.958891] initcall init_ladder+0x0/0x10 returned 0 after 177 usecs
[    0.958900] calling  init_menu+0x0/0x10 @ 1
[    0.959229] cpuidle: using governor menu
[    0.959236] initcall init_menu+0x0/0x10 returned 0 after 321 usecs
[    0.959246] calling  init_soundcore+0x0/0x30 @ 1
[    0.959299] initcall init_soundcore+0x0/0x30 returned 0 after 46 usecs
[    0.959309] calling  alsa_sound_init+0x0/0x80 @ 1
[    0.959335] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    0.959341] initcall alsa_sound_init+0x0/0x80 returned 0 after 25 usecs
[    0.959350] calling  alsa_timer_init+0x0/0x160 @ 1
[    0.959438] initcall alsa_timer_init+0x0/0x160 returned 0 after 80 usecs
[    0.959449] calling  alsa_pcm_init+0x0/0x60 @ 1
[    0.959457] initcall alsa_pcm_init+0x0/0x60 returned 0 after 2 usecs
[    0.959464] calling  snd_mem_init+0x0/0x30 @ 1
[    0.959474] initcall snd_mem_init+0x0/0x30 returned 0 after 3 usecs
[    0.959482] calling  alsa_card_azx_init+0x0/0x20 @ 1
[    0.959528] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    0.959568] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.961058] Marking TSC unstable due to TSC halts in idle
[    0.961805] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input5
[    0.967927] hda_codec: Unknown model for ALC662, trying auto-probe 
from BIOS...
[    0.992789] initcall alsa_card_azx_init+0x0/0x20 returned 0 after 
32515 usecs
[    0.992805] calling  alsa_sound_last_init+0x0/0x70 @ 1
[    0.992809] ALSA device list:
[    0.992812]   #0: HDA Intel at 0xf7eb8000 irq 16
[    0.992818] initcall alsa_sound_last_init+0x0/0x70 returned 0 after 6 
usecs
[    0.992828] calling  sysctl_core_init+0x0/0x20 @ 1
[    0.992856] initcall sysctl_core_init+0x0/0x20 returned 0 after 20 usecs
[    0.992864] calling  sysctl_ipv4_init+0x0/0x40 @ 1
[    0.992883] initcall sysctl_ipv4_init+0x0/0x40 returned 0 after 11 usecs
[    0.992892] calling  inet_diag_init+0x0/0x70 @ 1
[    0.992908] initcall inet_diag_init+0x0/0x70 returned 0 after 9 usecs
[    0.992917] calling  tcp_diag_init+0x0/0x10 @ 1
[    0.992925] initcall tcp_diag_init+0x0/0x10 returned 0 after 2 usecs
[    0.992933] calling  cubictcp_register+0x0/0xb0 @ 1
[    0.992938] TCP cubic registered
[    0.992943] initcall cubictcp_register+0x0/0xb0 returned 0 after 4 usecs
[    0.992950] calling  packet_init+0x0/0x40 @ 1
[    0.992955] NET: Registered protocol family 17
[    0.992969] initcall packet_init+0x0/0x40 returned 0 after 13 usecs
[    0.992976] calling  rfkill_handler_init+0x0/0x40 @ 1
[    0.993037] initcall rfkill_handler_init+0x0/0x40 returned 0 after 53 
usecs
[    0.993048] calling  hpet_insert_resource+0x0/0x20 @ 1
[    0.993055] initcall hpet_insert_resource+0x0/0x20 returned 1 after 0 
usecs
[    0.993064] initcall hpet_insert_resource+0x0/0x20 returned with 
error code 1
[    0.993070] calling  lapic_insert_resource+0x0/0x40 @ 1
[    0.993081] initcall lapic_insert_resource+0x0/0x40 returned 0 after 
3 usecs
[    0.993089] calling  init_lapic_nmi_sysfs+0x0/0x40 @ 1
[    0.993097] initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 
usecs
[    0.993105] calling  ioapic_insert_resources+0x0/0x60 @ 1
[    0.993113] initcall ioapic_insert_resources+0x0/0x60 returned 0 
after 1 usecs
[    0.993122] calling  io_apic_bug_finalize+0x0/0x20 @ 1
[    0.993129] initcall io_apic_bug_finalize+0x0/0x20 returned 0 after 0 
usecs
[    0.993138] calling  check_early_ioremap_leak+0x0/0x70 @ 1
[    0.993146] initcall check_early_ioremap_leak+0x0/0x70 returned 0 
after 1 usecs
[    0.993155] calling  print_ipi_mode+0x0/0x30 @ 1
[    0.993159] Using IPI Shortcut mode
[    0.993165] initcall print_ipi_mode+0x0/0x30 returned 0 after 3 usecs
[    0.993175] calling  init_oops_id+0x0/0x20 @ 1
[    0.993191] initcall init_oops_id+0x0/0x20 returned 0 after 11 usecs
[    0.993200] calling  disable_boot_consoles+0x0/0x50 @ 1
[    0.993208] initcall disable_boot_consoles+0x0/0x50 returned 0 after 
0 usecs
[    0.993217] calling  pm_qos_power_init+0x0/0x80 @ 1
[    0.993424] initcall pm_qos_power_init+0x0/0x80 returned 0 after 195 
usecs
[    0.993436] calling  random32_reseed+0x0/0x60 @ 1
[    0.993457] initcall random32_reseed+0x0/0x60 returned 0 after 13 usecs
[    0.993465] calling  pci_sysfs_init+0x0/0x50 @ 1
[    0.993597] initcall pci_sysfs_init+0x0/0x50 returned 0 after 121 usecs
[    0.993606] calling  acpi_wakeup_device_init+0x0/0x66 @ 1
[    0.993614] initcall acpi_wakeup_device_init+0x0/0x66 returned 0 
after 2 usecs
[    0.993622] calling  acpi_sleep_proc_init+0x0/0x2a @ 1
[    0.993633] initcall acpi_sleep_proc_init+0x0/0x2a returned 0 after 5 
usecs
[    0.993641] calling  seqgen_init+0x0/0x10 @ 1
[    0.993676] initcall seqgen_init+0x0/0x10 returned 0 after 29 usecs
[    0.993685] calling  scsi_complete_async_scans+0x0/0xc0 @ 1
[    0.993692] initcall scsi_complete_async_scans+0x0/0xc0 returned 0 
after 1 usecs
[    0.993702] calling  rtc_hctosys+0x0/0x190 @ 1
[    0.993737] rtc_cmos 00:03: setting system clock to 2009-01-04 
18:37:20 UTC (1231094240)
[    0.993744] initcall rtc_hctosys+0x0/0x190 returned 0 after 35 usecs
[    0.993753] calling  pci_mmcfg_late_insert_resources+0x0/0x150 @ 1
[    0.993763] initcall pci_mmcfg_late_insert_resources+0x0/0x150 
returned 0 after 2 usecs
[    0.993772] calling  tcp_congestion_default+0x0/0x10 @ 1
[    0.993781] initcall tcp_congestion_default+0x0/0x10 returned 0 after 
1 usecs
[    1.079055] Clocksource tsc unstable (delta = -99044354 ns)
[    1.224061] usb 1-5: new high speed USB device using ehci_hcd and 
address 2
[    1.341816] usb 1-5: configuration #1 chosen from 1 choice
[    1.342085] scsi2 : SCSI emulation for USB Mass Storage devices
[    1.342342] usb-storage: device found at 2
[    1.342346] usb-storage: waiting for device to settle before scanning
[    1.342565] usb 1-5: New USB device found, idVendor=0951, idProduct=1606
[    1.342571] usb 1-5: New USB device strings: Mfr=1, Product=2, 
SerialNumber=4
[    1.342575] usb 1-5: Product: UB6225
[    1.342578] usb 1-5: Manufacturer: ENE
[    1.342582] usb 1-5: SerialNumber: 146030377350
[    3.021250] input: ImPS/2 Logitech Wheel Mouse as 
/devices/platform/i8042/serio1/input/input6
[    3.120056] kjournald starting.  Commit interval 5 seconds
[    3.120073] EXT3-fs: mounted filesystem with ordered data mode.
[    3.120091] VFS: Mounted root (ext3 filesystem) readonly.
[    3.120316] Freeing unused kernel memory: 276k freed
[    3.120386] Write protecting the kernel text: 2604k
[    3.120419] Write protecting the kernel read-only data: 704k
[    6.342209] usb-storage: device scan complete
[    6.342718] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0 
  0100 PQ: 0 ANSI: 0
[    6.711124] EXT3 FS on sdb2, internal journal
[    6.860063] sd 2:0:0:0: [sdc] 15661056 512-byte hardware sectors: 
(8.01 GB/7.46 GiB)
[    6.860552] sd 2:0:0:0: [sdc] Write Protect is on
[    6.860557] sd 2:0:0:0: [sdc] Mode Sense: 03 00 80 00
[    6.860562] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    6.870403] sd 2:0:0:0: [sdc] 15661056 512-byte hardware sectors: 
(8.01 GB/7.46 GiB)
[    6.871536] sd 2:0:0:0: [sdc] Write Protect is on
[    6.871543] sd 2:0:0:0: [sdc] Mode Sense: 03 00 80 00
[    6.871548] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    6.871615]  sdc: sdc1 sdc2
[    6.879637] sd 2:0:0:0: [sdc] Attached SCSI removable disk
[    9.659179] warning: `avahi-daemon' uses 32-bit capabilities (legacy 
support in use)
[   10.932457] atl2 0000:03:00.0: irq 284 for MSI/MSI-X
[   37.301047] kjournald starting.  Commit interval 5 seconds
[   37.301075] EXT3-fs: mounted filesystem with ordered data mode.
[   41.174928] wlan0: authenticate with AP 00:0f:b5:cc:c9:36
[   41.176864] wlan0: authenticated
[   41.176874] wlan0: associate with AP 00:0f:b5:cc:c9:36
[   41.179183] wlan0: RX AssocResp from 00:0f:b5:cc:c9:36 (capab=0x431 
status=0 aid=2)
[   41.179190] wlan0: associated

debug_initcall log with fastboot:

[    0.000000] BIOS EBDA/lowmem at: 0009fc00/0009fc00
[    0.000000] Linux version 2.6.28-00001-g55bd644-dirty 
(sits@xenon.sucs.swan.ac.uk) (gcc version 4.1.2 20070925 (Red Hat 
4.1.2-33)) #18 Sun Jan 4 18:13:12 GMT 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f780000 (usable)
[    0.000000]  BIOS-e820: 000000003f780000 - 000000003f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f790000 - 000000003f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f7d0000 - 000000003f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000003f7e0000 - 000000003f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] last_pfn = 0x3f780 max_arch_pfn = 0x100000
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 1016MB, range: 8MB, type UC
[    0.000000] total RAM coverred: 1016M
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 128K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 256K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 512K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 64K 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 128K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 256K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 512K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 16M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 32M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 64M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 128K 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 256K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 512K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 16M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 32M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 64M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 256K 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 512K 	num_reg: 7  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 16M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 32M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 64M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 512K 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 1M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 128M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 256M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 512M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 1M 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 2M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 128M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 256M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 512M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 2M 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 4M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 128M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 256M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 512M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 4M 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 8M 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 16M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 128M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 256M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 512M 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 8M 	chunk_size: 2G 	num_reg: 7  	lose cover 
RAM: 0G
[    0.000000]  gran_size: 16M 	chunk_size: 16M 	num_reg: 6  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 32M 	num_reg: 2  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 16M 	chunk_size: 2G 	num_reg: 6  	lose cover 
RAM: 8M
[    0.000000]  gran_size: 32M 	chunk_size: 32M 	num_reg: 5  	lose cover 
RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 64M 	num_reg: 2  	lose cover 
RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 24M
[    0.000000]  gran_size: 32M 	chunk_size: 2G 	num_reg: 5  	lose cover 
RAM: 24M
[    0.000000]  gran_size: 64M 	chunk_size: 64M 	num_reg: 4  	lose cover 
RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 128M 	num_reg: 2  	lose 
cover RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 56M
[    0.000000]  gran_size: 64M 	chunk_size: 2G 	num_reg: 4  	lose cover 
RAM: 56M
[    0.000000]  gran_size: 128M 	chunk_size: 128M 	num_reg: 3  	lose 
cover RAM: 120M
[    0.000000]  gran_size: 128M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 120M
[    0.000000]  gran_size: 128M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 120M
[    0.000000]  gran_size: 128M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 120M
[    0.000000]  gran_size: 128M 	chunk_size: 2G 	num_reg: 3  	lose cover 
RAM: 120M
[    0.000000]  gran_size: 256M 	chunk_size: 256M 	num_reg: 2  	lose 
cover RAM: 248M
[    0.000000]  gran_size: 256M 	chunk_size: 512M 	num_reg: 2  	lose 
cover RAM: 248M
[    0.000000]  gran_size: 256M 	chunk_size: 1G 	num_reg: 2  	lose cover 
RAM: 248M
[    0.000000]  gran_size: 256M 	chunk_size: 2G 	num_reg: 2  	lose cover 
RAM: 248M
[    0.000000]  gran_size: 512M 	chunk_size: 512M 	num_reg: 1  	lose 
cover RAM: 504M
[    0.000000]  gran_size: 512M 	chunk_size: 1G 	num_reg: 1  	lose cover 
RAM: 504M
[    0.000000]  gran_size: 512M 	chunk_size: 2G 	num_reg: 1  	lose cover 
RAM: 504M
[    0.000000]  gran_size: 1G 	chunk_size: 1G 	num_reg: 0  	lose cover 
RAM: 1016M
[    0.000000]  gran_size: 1G 	chunk_size: 2G 	num_reg: 0  	lose cover 
RAM: 1016M
[    0.000000]  gran_size: 2G 	chunk_size: 2G 	num_reg: 0  	lose cover 
RAM: 1016M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000] gran_size: 64K 	chunk_size: 16M 	num_reg: 2  	lose RAM: 0G
[    0.000000] range0: 0000000000000000 - 0000000040000000
[    0.000000] Setting variable MTRR 0, base: 0GB, range: 1GB, type WB
[    0.000000] hole: 000000003f800000 - 0000000040000000
[    0.000000] Setting variable MTRR 1, base: 1016MB, range: 8MB, type UC
[    0.000000] kernel direct mapping tables up to 377fe000 @ 7000-d000
[    0.000000] ACPI: RSDP 000FBE60, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 3F780000, 0034 (r1 A M I  OEMRSDT   9000811 
MSFT       97)
[    0.000000] ACPI: FACP 3F780200, 0081 (r1 A M I  OEMFACP   9000811 
MSFT       97)
[    0.000000] ACPI: DSDT 3F780400, 6109 (r1  A0979 A0979034       34 
INTL 20060113)
[    0.000000] ACPI: FACS 3F790000, 0040
[    0.000000] ACPI: APIC 3F780390, 0068 (r1 A M I  OEMAPIC   9000811 
MSFT       97)
[    0.000000] ACPI: OEMB 3F790040, 0046 (r1 A M I  AMI_OEM   9000811 
MSFT       97)
[    0.000000] ACPI: MCFG 3F786510, 003C (r1 A M I  OEMMCFG   9000811 
MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 127MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 00000000 - 377fe000
[    0.000000]   bootmap 00009000 - 0000ff00
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00377fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> 
[0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 000054208c]    TEXT DATA BSS ==> 
[0000100000 - 000054208c]
[    0.000000]   #2 [0000543000 - 0000546000]    INIT_PG_TABLE ==> 
[0000543000 - 0000546000]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> 
[000009fc00 - 0000100000]
[    0.000000]   #4 [0000007000 - 0000009000]          PGTABLE ==> 
[0000007000 - 0000009000]
[    0.000000]   #5 [0000009000 - 0000010000]          BOOTMAP ==> 
[0000009000 - 0000010000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x0003f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f780
[    0.000000] On node 0 totalpages: 259871
[    0.000000] free_area_init_node: node 0, pgdat c0483f60, node_mem_map 
c1000000
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 256 pages used for memmap
[    0.000000]   HighMem zone: 32386 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Allocating PCI resources starting at 40000000 (gap: 
3f800000:bf600000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 257839
[    0.000000] Kernel command line: initcall_debug root=/dev/sdb2 ro quiet
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 900.153 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 
bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 
bytes)
[    0.000999] Memory: 1025852k/1039872k available (2602k kernel code, 
13332k reserved, 1029k data, 276k init, 130568k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfffac000 - 0xfffff000   ( 332 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc048e000 - 0xc04d3000   ( 276 kB)
[    0.000999]       .data : 0xc038a960 - 0xc048bf2c   (1029 kB)
[    0.000999]       .text : 0xc0100000 - 0xc038a960   (2602 kB)
[    0.000999] Checking if this processor honours the WP bit even in 
supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=1, Nodes=1
[    0.001014] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 1800.30 BogoMIPS (lpj=900153)
[    0.001041] Security Framework initialized
[    0.001061] Mount-cache hash table entries: 512
[    0.001280] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001286] CPU: L2 cache: 512K
[    0.001291] Intel machine check architecture supported.
[    0.001298] Intel machine check reporting enabled on CPU#0.
[    0.001311] CPU: Intel(R) Celeron(R) M processor          900MHz 
stepping 08
[    0.001321] Checking 'hlt' instruction... OK.
[    0.005651] Freeing SMP alternatives: 0k freed
[    0.005655] ACPI: Core revision 20080926
[    0.020077] calling  spawn_ksoftirqd+0x0/0x30 @ 1
[    0.020105] initcall spawn_ksoftirqd+0x0/0x30 returned 0 after 0 usecs
[    0.020112] calling  spawn_softlockup_task+0x0/0x50 @ 1
[    0.020136] initcall spawn_softlockup_task+0x0/0x50 returned 0 after 
0 usecs
[    0.020142] calling  tracer_alloc_buffers+0x0/0xf0 @ 1
[    0.020473] initcall tracer_alloc_buffers+0x0/0xf0 returned 0 after 0 
usecs
[    0.020837] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.030995] calling  net_ns_init+0x0/0x1c0 @ 1
[    0.030995] net_namespace: 288 bytes
[    0.030995] initcall net_ns_init+0x0/0x1c0 returned 0 after 0 usecs
[    0.030995] calling  reboot_init+0x0/0x10 @ 1
[    0.030995] initcall reboot_init+0x0/0x10 returned 0 after 0 usecs
[    0.030995] calling  sysctl_init+0x0/0x10 @ 1
[    0.030995] initcall sysctl_init+0x0/0x10 returned 0 after 0 usecs
[    0.030995] calling  ksysfs_init+0x0/0xb0 @ 1
[    0.030995] initcall ksysfs_init+0x0/0xb0 returned 0 after 0 usecs
[    0.030995] calling  async_init+0x0/0x40 @ 1
[    0.030995] initcall async_init+0x0/0x40 returned 0 after 0 usecs
[    0.030995] calling  init_jiffies_clocksource+0x0/0x10 @ 1
[    0.030995] initcall init_jiffies_clocksource+0x0/0x10 returned 0 
after 0 usecs
[    0.030995] calling  pm_init+0x0/0x30 @ 1
[    0.030995] initcall pm_init+0x0/0x30 returned 0 after 0 usecs
[    0.030995] calling  filelock_init+0x0/0x30 @ 1
[    0.030995] initcall filelock_init+0x0/0x30 returned 0 after 0 usecs
[    0.030995] calling  init_script_binfmt+0x0/0x10 @ 1
[    0.030995] initcall init_script_binfmt+0x0/0x10 returned 0 after 0 usecs
[    0.030995] calling  init_elf_binfmt+0x0/0x10 @ 1
[    0.030995] initcall init_elf_binfmt+0x0/0x10 returned 0 after 0 usecs
[    0.030995] calling  debugfs_init+0x0/0x50 @ 1
[    0.030995] initcall debugfs_init+0x0/0x50 returned 0 after 0 usecs
[    0.030995] calling  random32_init+0x0/0xa0 @ 1
[    0.030995] initcall random32_init+0x0/0xa0 returned 0 after 0 usecs
[    0.030995] calling  cpuidle_init+0x0/0x20 @ 1
[    0.030995] initcall cpuidle_init+0x0/0x20 returned 0 after 0 usecs
[    0.030995] calling  sock_init+0x0/0x60 @ 1
[    0.030995] initcall sock_init+0x0/0x60 returned 0 after 0 usecs
[    0.030995] calling  netlink_proto_init+0x0/0x130 @ 1
[    0.030995] NET: Registered protocol family 16
[    0.030995] initcall netlink_proto_init+0x0/0x130 returned 0 after 0 
usecs
[    0.030995] calling  bdi_class_init+0x0/0x40 @ 1
[    0.030995] initcall bdi_class_init+0x0/0x40 returned 0 after 0 usecs
[    0.030995] calling  kobject_uevent_init+0x0/0x50 @ 1
[    0.030995] initcall kobject_uevent_init+0x0/0x50 returned 0 after 0 
usecs
[    0.030995] calling  pcibus_class_init+0x0/0x10 @ 1
[    0.030995] initcall pcibus_class_init+0x0/0x10 returned 0 after 0 usecs
[    0.030995] calling  pci_driver_init+0x0/0x10 @ 1
[    0.030995] initcall pci_driver_init+0x0/0x10 returned 0 after 0 usecs
[    0.030995] calling  backlight_class_init+0x0/0x50 @ 1
[    0.030995] initcall backlight_class_init+0x0/0x50 returned 0 after 0 
usecs
[    0.030995] calling  tty_class_init+0x0/0x30 @ 1
[    0.030995] initcall tty_class_init+0x0/0x30 returned 0 after 0 usecs
[    0.030995] calling  vtconsole_class_init+0x0/0xe0 @ 1
[    0.031077] initcall vtconsole_class_init+0x0/0xe0 returned 0 after 
976 usecs
[    0.031088] calling  amd_postcore_init+0x0/0x40 @ 1
[    0.031093] initcall amd_postcore_init+0x0/0x40 returned 0 after 0 usecs
[    0.031102] calling  arch_kdebugfs_init+0x0/0x20 @ 1
[    0.031112] initcall arch_kdebugfs_init+0x0/0x20 returned 0 after 0 usecs
[    0.031119] calling  init_pit_clocksource+0x0/0xb0 @ 1
[    0.031125] initcall init_pit_clocksource+0x0/0xb0 returned 0 after 0 
usecs
[    0.031133] calling  mtrr_if_init+0x0/0x70 @ 1
[    0.031142] initcall mtrr_if_init+0x0/0x70 returned 0 after 0 usecs
[    0.031150] calling  ffh_cstate_init+0x0/0x30 @ 1
[    0.031155] initcall ffh_cstate_init+0x0/0x30 returned 0 after 0 usecs
[    0.031164] calling  acpi_pci_init+0x0/0x60 @ 1
[    0.031169] ACPI: bus type pci registered
[    0.031175] initcall acpi_pci_init+0x0/0x60 returned 0 after 0 usecs
[    0.031183] calling  init_acpi_device_notify+0x0/0x3f @ 1
[    0.031189] initcall init_acpi_device_notify+0x0/0x3f returned 0 
after 0 usecs
[    0.031197] calling  pci_arch_init+0x0/0x50 @ 1
[    0.031244] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.031250] PCI: Not using MMCONFIG.
[    0.031465] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.031469] PCI: Using configuration type 1 for base access
[    0.031513] initcall pci_arch_init+0x0/0x50 returned 0 after 0 usecs
[    0.031522] calling  topology_init+0x0/0x10 @ 1
[    0.031584] initcall topology_init+0x0/0x10 returned 0 after 0 usecs
[    0.031595] calling  mtrr_init_finialize+0x0/0x40 @ 1
[    0.031601] initcall mtrr_init_finialize+0x0/0x40 returned 0 after 0 
usecs
[    0.031609] calling  param_sysfs_init+0x0/0x320 @ 1
[    0.035308] initcall param_sysfs_init+0x0/0x320 returned 0 after 3905 
usecs
[    0.035323] calling  pm_sysrq_init+0x0/0x20 @ 1
[    0.035329] initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
[    0.035337] calling  readahead_init+0x0/0x40 @ 1
[    0.035415] initcall readahead_init+0x0/0x40 returned 0 after 0 usecs
[    0.035425] calling  init_bio+0x0/0xc0 @ 1
[    0.035453] initcall init_bio+0x0/0xc0 returned 0 after 0 usecs
[    0.035461] calling  cryptomgr_init+0x0/0x30 @ 1
[    0.035475] initcall cryptomgr_init+0x0/0x30 returned 0 after 0 usecs
[    0.035483] calling  blk_settings_init+0x0/0x20 @ 1
[    0.035489] initcall blk_settings_init+0x0/0x20 returned 0 after 0 usecs
[    0.035498] calling  blk_ioc_init+0x0/0x30 @ 1
[    0.035504] initcall blk_ioc_init+0x0/0x30 returned 0 after 0 usecs
[    0.035513] calling  blk_softirq_init+0x0/0x30 @ 1
[    0.035518] initcall blk_softirq_init+0x0/0x30 returned 0 after 0 usecs
[    0.035527] calling  genhd_device_init+0x0/0x60 @ 1
[    0.035615] initcall genhd_device_init+0x0/0x60 returned 0 after 0 usecs
[    0.035628] calling  pci_slot_init+0x0/0x40 @ 1
[    0.035639] initcall pci_slot_init+0x0/0x40 returned 0 after 0 usecs
[    0.035648] calling  fbmem_init+0x0/0x90 @ 1
[    0.035708] initcall fbmem_init+0x0/0x90 returned 0 after 0 usecs
[    0.035719] calling  acpi_init+0x0/0x23a @ 1
[    0.036754] ACPI: EC: Look up EC in DSDT
[    0.050470] ACPI: Interpreter enabled
[    0.050484] ACPI: (supports S0 S1 S3 S5)
[    0.050516] ACPI: Using IOAPIC for interrupt routing
[    0.050628] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 255
[    0.053911] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources
[    0.053917] PCI: Using MMCONFIG for extended config space
[    0.053928] initcall acpi_init+0x0/0x23a returned 0 after 17575 usecs
[    0.053938] calling  acpi_scan_init+0x0/0xea @ 1
[    0.064432] initcall acpi_scan_init+0x0/0xea returned 0 after 10740 usecs
[    0.064445] calling  acpi_ec_init+0x0/0x51 @ 1
[    0.064456] initcall acpi_ec_init+0x0/0x51 returned 0 after 0 usecs
[    0.064464] calling  dock_init+0x0/0x79 @ 1
[    0.064673] ACPI: No dock devices found.
[    0.064677] initcall dock_init+0x0/0x79 returned 0 after 0 usecs
[    0.064684] calling  acpi_pci_root_init+0x0/0x21 @ 1
[    0.064690] initcall acpi_pci_root_init+0x0/0x21 returned 0 after 0 usecs
[    0.064697] calling  acpi_pci_link_init+0x0/0x59 @ 1
[    0.064703] initcall acpi_pci_link_init+0x0/0x59 returned 0 after 0 usecs
[    0.064710] calling  acpi_power_init+0x0/0x65 @ 1
[    0.064718] initcall acpi_power_init+0x0/0x65 returned 0 after 0 usecs
[    0.064725] calling  acpi_system_init+0x0/0x164 @ 1
[    0.064818] initcall acpi_system_init+0x0/0x164 returned 0 after 0 usecs
[    0.064825] calling  pnp_init+0x0/0x10 @ 1
[    0.064905] initcall pnp_init+0x0/0x10 returned 0 after 0 usecs
[    0.064914] calling  misc_init+0x0/0xa0 @ 1
[    0.064969] calling  1_acpi_bus_register_async+0x0/0x4b @ 151
[    0.064974] async_waiting @ 151
[    0.064977] async_continuing @ 151 after 0 usec
[    0.065049] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.065053] ACPI: EC: driver started in poll mode
[    0.065126] initcall misc_init+0x0/0xa0 returned 0 after 976 usecs
[    0.065135] calling  init_scsi+0x0/0x90 @ 1
[    0.065300] initcall 1_acpi_bus_register_async+0x0/0x4b returned 0 
after 976 usecs
[    0.065309] calling  2_acpi_bus_register_async+0x0/0x4b @ 151
[    0.065312] async_waiting @ 151
[    0.065315] async_continuing @ 151 after 0 usec
[    0.065470] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.065543] calling  3_acpi_bus_register_async+0x0/0x4b @ 154
[    0.065547] async_waiting @ 154
[    0.065700] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.065708] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.065716] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.065724] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.065761] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.065855] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.065888] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.065894] pci 0000:00:1b.0: PME# disabled
[    0.065946] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.065951] pci 0000:00:1c.0: PME# disabled
[    0.066013] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.066019] pci 0000:00:1c.1: PME# disabled
[    0.066072] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.066078] pci 0000:00:1c.2: PME# disabled
[    0.066130] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.066184] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.066237] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.066289] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.066346] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.066389] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.066395] pci 0000:00:1d.7: PME# disabled
[    0.066517] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.066526] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 
ACPI/GPIO/TCO
[    0.066533] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 
GPIO
[    0.066565] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.066573] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.066581] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.066589] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.066598] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.066618] pci 0000:00:1f.2: PME# supported from D3hot
[    0.066624] pci 0000:00:1f.2: PME# disabled
[    0.066673] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.066806] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.066843] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.066858] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.066864] pci 0000:03:00.0: PME# disabled
[    0.066919] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.066982] pci 0000:01:00.0: reg 10 64bit mmio: [0xfbef0000-0xfbefffff]
[    0.067105] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.067114] pci 0000:00:1c.2: bridge 64bit mmio pref: 
[0xf0000000-0xf6ffffff]
[    0.067167] pci 0000:00:1e.0: transparent bridge
[    0.067197] bus 00 -> node 0
[    0.067214] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.067717] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.067910] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.068109] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.068841] calling  4_acpi_bus_register_async+0x0/0x4b @ 157
[    0.068845] async_waiting @ 157
[    0.069404] SCSI subsystem initialized
[    0.069414] initcall init_scsi+0x0/0x90 returned 0 after 3905 usecs
[    0.069424] calling  ata_init+0x0/0x3a0 @ 1
[    0.069477] libata version 3.00 loaded.
[    0.069483] initcall ata_init+0x0/0x3a0 returned 0 after 0 usecs
[    0.069491] calling  usb_init+0x0/0x120 @ 1
[    0.071818] usbcore: registered new interface driver usbfs
[    0.072331] usbcore: registered new interface driver hub
[    0.072833] usbcore: registered new device driver usb
[    0.072843] initcall usb_init+0x0/0x120 returned 0 after 2929 usecs
[    0.072853] calling  serio_init+0x0/0xb0 @ 1
[    0.073391] initcall serio_init+0x0/0xb0 returned 0 after 976 usecs
[    0.073403] calling  input_init+0x0/0x100 @ 1
[    0.073881] initcall input_init+0x0/0x100 returned 0 after 0 usecs
[    0.073893] calling  rtc_init+0x0/0x70 @ 1
[    0.074404] initcall rtc_init+0x0/0x70 returned 0 after 976 usecs
[    0.074414] calling  power_supply_class_init+0x0/0x30 @ 1
[    0.074898] initcall power_supply_class_init+0x0/0x30 returned 0 
after 0 usecs
[    0.074909] calling  hwmon_init+0x0/0x40 @ 1
[    0.075400] initcall hwmon_init+0x0/0x40 returned 0 after 976 usecs
[    0.075411] calling  thermal_init+0x0/0x30 @ 1
[    0.075888] initcall thermal_init+0x0/0x30 returned 0 after 0 usecs
[    0.075898] calling  leds_init+0x0/0x30 @ 1
[    0.076400] initcall leds_init+0x0/0x30 returned 0 after 976 usecs
[    0.076411] calling  pci_subsys_init+0x0/0x100 @ 1
[    0.076415] PCI: Using ACPI for IRQ routing
[    0.076485] initcall pci_subsys_init+0x0/0x100 returned 0 after 0 usecs
[    0.076494] calling  proto_init+0x0/0x30 @ 1
[    0.076504] initcall proto_init+0x0/0x30 returned 0 after 0 usecs
[    0.076512] calling  net_dev_init+0x0/0x100 @ 1
[    0.076636] initcall net_dev_init+0x0/0x100 returned 0 after 0 usecs
[    0.076646] calling  neigh_init+0x0/0x80 @ 1
[    0.076653] initcall neigh_init+0x0/0x80 returned 0 after 0 usecs
[    0.076661] calling  genl_init+0x0/0xd0 @ 1
[    0.077089] initcall 2_acpi_bus_register_async+0x0/0x4b returned 0 
after 11716 usecs
[    0.077099] async_continuing @ 154 after 11716 usec
[    0.077330] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 
14 15)
[    0.077607] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 
14 15)
[    0.077873] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 
14 15)
[    0.078174] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 
14 15)
[    0.078441] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.078715] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.078982] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 
14 15) *0, disabled.
[    0.079259] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 
14 15)
[    0.079414] initcall 3_acpi_bus_register_async+0x0/0x4b returned 0 
after 13669 usecs
[    0.079422] async_continuing @ 157 after 10740 usec
[    0.079486] initcall 4_acpi_bus_register_async+0x0/0x4b returned 0 
after 10740 usecs
[    0.079494] initcall genl_init+0x0/0xd0 returned 0 after 2929 usecs
[    0.079494] calling  wireless_nlevent_init+0x0/0x20 @ 1
[    0.079494] initcall wireless_nlevent_init+0x0/0x20 returned 0 after 
0 usecs
[    0.079494] calling  cfg80211_init+0x0/0x80 @ 1
[    0.079494] cfg80211: Using static regulatory domain info
[    0.079494] cfg80211: Regulatory domain: US
[    0.079494] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[    0.079494] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.079494] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.079494] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.079494] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.079494] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.079494] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.079494] cfg80211: Calling CRDA for country: US
[    0.079494] initcall cfg80211_init+0x0/0x80 returned 0 after 0 usecs
[    0.079494] calling  ieee80211_init+0x0/0x20 @ 1
[    0.079494] initcall ieee80211_init+0x0/0x20 returned 0 after 0 usecs
[    0.079494] calling  rfkill_init+0x0/0x70 @ 1
[    0.079494] initcall rfkill_init+0x0/0x70 returned 0 after 0 usecs
[    0.079494] calling  sysctl_init+0x0/0x40 @ 1
[    0.079494] initcall sysctl_init+0x0/0x40 returned 0 after 0 usecs
[    0.079494] calling  pci_iommu_init+0x0/0x10 @ 1
[    0.079494] initcall pci_iommu_init+0x0/0x10 returned 0 after 0 usecs
[    0.079494] calling  print_all_ICs+0x0/0x880 @ 1
[    0.079494] initcall print_all_ICs+0x0/0x880 returned 0 after 0 usecs
[    0.079494] calling  hpet_late_init+0x0/0x180 @ 1
[    0.080170] hpet clockevent registered
[    0.080175] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.080184] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.080192] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.081998] initcall hpet_late_init+0x0/0x180 returned 0 after 2929 usecs
[    0.082009] calling  clocksource_done_booting+0x0/0x10 @ 1
[    0.082015] initcall clocksource_done_booting+0x0/0x10 returned 0 
after 0 usecs
[    0.082023] calling  rb_init_debugfs+0x0/0x50 @ 1
[    0.082035] initcall rb_init_debugfs+0x0/0x50 returned 0 after 0 usecs
[    0.082043] calling  tracer_init_debugfs+0x0/0x310 @ 1
[    0.082073] initcall tracer_init_debugfs+0x0/0x310 returned 0 after 0 
usecs
[    0.082081] calling  init_pipe_fs+0x0/0x50 @ 1
[    0.082099] initcall init_pipe_fs+0x0/0x50 returned 0 after 0 usecs
[    0.082107] calling  init_mnt_writers+0x0/0x10 @ 1
[    0.082113] initcall init_mnt_writers+0x0/0x10 returned 0 after 0 usecs
[    0.082121] calling  eventpoll_init+0x0/0xa0 @ 1
[    0.082131] initcall eventpoll_init+0x0/0xa0 returned 0 after 0 usecs
[    0.082139] calling  anon_inode_init+0x0/0x100 @ 1
[    0.082149] initcall anon_inode_init+0x0/0x100 returned 0 after 0 usecs
[    0.082157] calling  acpi_event_init+0x0/0x78 @ 1
[    0.082170] initcall acpi_event_init+0x0/0x78 returned 0 after 0 usecs
[    0.082170] calling  pnpacpi_init+0x0/0xa0 @ 1
[    0.082170] pnp: PnP ACPI init
[    0.082170] ACPI: bus type pnp registered
[    0.086407] pnp: PnP ACPI: found 13 devices
[    0.086414] ACPI: ACPI bus type pnp unregistered
[    0.086423] initcall pnpacpi_init+0x0/0xa0 returned 0 after 4326 usecs
[    0.086433] calling  pnp_system_init+0x0/0x10 @ 1
[    0.086457] system 00:01: iomem range 0xfed13000-0xfed19fff has been 
reserved
[    0.086475] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.086480] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.086485] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.086491] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.086501] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been 
reserved
[    0.086507] system 00:08: iomem range 0xfed20000-0xfed8ffff has been 
reserved
[    0.086513] system 00:08: iomem range 0xfff00000-0xffffffff could not 
be reserved
[    0.086523] system 00:09: iomem range 0xfec00000-0xfec00fff has been 
reserved
[    0.086529] system 00:09: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.086538] system 00:0a: iomem range 0xe0000000-0xefffffff has been 
reserved
[    0.086551] system 00:0b: iomem range 0xe0000000-0xefffffff has been 
reserved
[    0.086562] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.086568] system 00:0c: iomem range 0xe0000-0xfffff could not be 
reserved
[    0.086573] system 00:0c: iomem range 0x100000-0x3f7fffff could not 
be reserved
[    0.086633] initcall pnp_system_init+0x0/0x10 returned 0 after 188 usecs
[    0.086643] calling  chr_dev_init+0x0/0xb0 @ 1
[    0.087144] initcall chr_dev_init+0x0/0xb0 returned 0 after 482 usecs
[    0.087154] calling  firmware_class_init+0x0/0x70 @ 1
[    0.087204] initcall firmware_class_init+0x0/0x70 returned 0 after 42 
usecs
[    0.087213] calling  loopback_init+0x0/0x10 @ 1
[    0.087352] initcall loopback_init+0x0/0x10 returned 0 after 129 usecs
[    0.087362] calling  init_acpi_pm_clocksource+0x0/0x230 @ 1
[    0.121906] initcall init_acpi_pm_clocksource+0x0/0x230 returned 0 
after 33727 usecs
[    0.121916] calling  pcibios_assign_resources+0x0/0x80 @ 1
[    0.121964] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.121969] pci 0000:00:1c.0:   IO window: disabled
[    0.121979] pci 0000:00:1c.0:   MEM window: disabled
[    0.121985] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.122000] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.122004] pci 0000:00:1c.1:   IO window: disabled
[    0.122011] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.122017] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.122032] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.122036] pci 0000:00:1c.2:   IO window: disabled
[    0.122043] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.122050] pci 0000:00:1c.2:   PREFETCH window: 
0x000000f0000000-0x000000f6ffffff
[    0.122059] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.122062] pci 0000:00:1e.0:   IO window: disabled
[    0.122069] pci 0000:00:1e.0:   MEM window: disabled
[    0.122074] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.122098] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.122107] pci 0000:00:1c.0: setting latency timer to 64
[    0.122118] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.122124] pci 0000:00:1c.1: setting latency timer to 64
[    0.122136] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.122142] pci 0000:00:1c.2: setting latency timer to 64
[    0.122151] pci 0000:00:1e.0: setting latency timer to 64
[    0.122157] bus: 00 index 0 io port: [0x00-0xffff]
[    0.122161] bus: 00 index 1 mmio: [0x000000-0xffffffff]
[    0.122165] bus: 04 index 0 mmio: [0x0-0x0]
[    0.122169] bus: 04 index 1 mmio: [0x0-0x0]
[    0.122173] bus: 04 index 2 mmio: [0x0-0x0]
[    0.122176] bus: 04 index 3 mmio: [0x0-0x0]
[    0.122180] bus: 03 index 0 mmio: [0x0-0x0]
[    0.122184] bus: 03 index 1 mmio: [0xfbf00000-0xfbffffff]
[    0.122188] bus: 03 index 2 mmio: [0x0-0x0]
[    0.122191] bus: 03 index 3 mmio: [0x0-0x0]
[    0.122195] bus: 01 index 0 mmio: [0x0-0x0]
[    0.122199] bus: 01 index 1 mmio: [0xf8000000-0xfbefffff]
[    0.122203] bus: 01 index 2 mmio: [0xf0000000-0xf6ffffff]
[    0.122207] bus: 01 index 3 mmio: [0x0-0x0]
[    0.122211] bus: 05 index 0 mmio: [0x0-0x0]
[    0.122215] bus: 05 index 1 mmio: [0x0-0x0]
[    0.122218] bus: 05 index 2 mmio: [0x0-0x0]
[    0.122222] bus: 05 index 3 io port: [0x00-0xffff]
[    0.122226] bus: 05 index 4 mmio: [0x000000-0xffffffff]
[    0.122234] initcall pcibios_assign_resources+0x0/0x80 returned 0 
after 303 usecs
[    0.122244] calling  inet_init+0x0/0x1f0 @ 1
[    0.122260] NET: Registered protocol family 2
[    0.122365] IP route cache hash table entries: 32768 (order: 5, 
131072 bytes)
[    0.122498] TCP established hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.124208] TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
[    0.124624] TCP: Hash tables configured (established 131072 bind 65536)
[    0.124631] TCP reno registered
[    0.124757] initcall inet_init+0x0/0x1f0 returned 0 after 2437 usecs
[    0.124777] calling  af_unix_init+0x0/0x50 @ 1
[    0.124783] NET: Registered protocol family 1
[    0.124795] initcall af_unix_init+0x0/0x50 returned 0 after 12 usecs
[    0.124806] calling  populate_rootfs+0x0/0xa0 @ 1
[    0.125040] initcall populate_rootfs+0x0/0xa0 returned 0 after 218 usecs
[    0.125053] calling  i8259A_init_sysfs+0x0/0x20 @ 1
[    0.125210] initcall i8259A_init_sysfs+0x0/0x20 returned 0 after 146 
usecs
[    0.125222] calling  sbf_init+0x0/0xb0 @ 1
[    0.125228] initcall sbf_init+0x0/0xb0 returned 0 after 0 usecs
[    0.125237] calling  i8237A_init_sysfs+0x0/0x20 @ 1
[    0.125316] initcall i8237A_init_sysfs+0x0/0x20 returned 0 after 71 usecs
[    0.125325] calling  add_rtc_cmos+0x0/0xa0 @ 1
[    0.125336] initcall add_rtc_cmos+0x0/0xa0 returned 0 after 5 usecs
[    0.125344] calling  cache_sysfs_init+0x0/0x240 @ 1
[    0.125349] initcall cache_sysfs_init+0x0/0x240 returned 0 after 0 usecs
[    0.125357] calling  thermal_throttle_init_device+0x0/0x40 @ 1
[    0.125363] initcall thermal_throttle_init_device+0x0/0x40 returned 0 
after 0 usecs
[    0.125372] calling  init_nonfatal_mce_checker+0x0/0x60 @ 1
[    0.125378] Machine check exception polling timer started.
[    0.125384] initcall init_nonfatal_mce_checker+0x0/0x60 returned 0 
after 6 usecs
[    0.125392] calling  msr_init+0x0/0xc0 @ 1
[    0.125525] initcall msr_init+0x0/0xc0 returned 0 after 122 usecs
[    0.125535] calling  cpuid_init+0x0/0xc0 @ 1
[    0.125643] initcall cpuid_init+0x0/0xc0 returned 0 after 98 usecs
[    0.125655] calling  init_lapic_sysfs+0x0/0x30 @ 1
[    0.125735] initcall init_lapic_sysfs+0x0/0x30 returned 0 after 71 usecs
[    0.125745] calling  ioapic_init_sysfs+0x0/0xa0 @ 1
[    0.125827] initcall ioapic_init_sysfs+0x0/0xa0 returned 0 after 73 usecs
[    0.125837] calling  microcode_init+0x0/0x110 @ 1
[    0.125968] Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.125989] initcall microcode_init+0x0/0x110 returned 0 after 140 usecs
[    0.126003] calling  aes_init+0x0/0x10 @ 1
[    0.126055] alg: cipher: Test 1 failed on encryption for aes-asm
[    0.126120] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08
[    0.126137] initcall aes_init+0x0/0x10 returned 0 after 124 usecs
[    0.126147] calling  proc_execdomains_init+0x0/0x30 @ 1
[    0.126161] initcall proc_execdomains_init+0x0/0x30 returned 0 after 
7 usecs
[    0.126169] calling  ioresources_init+0x0/0x40 @ 1
[    0.126177] initcall ioresources_init+0x0/0x40 returned 0 after 3 usecs
[    0.126184] calling  uid_cache_init+0x0/0x60 @ 1
[    0.126194] initcall uid_cache_init+0x0/0x60 returned 0 after 4 usecs
[    0.126201] calling  init_posix_timers+0x0/0xd0 @ 1
[    0.126208] initcall init_posix_timers+0x0/0xd0 returned 0 after 1 usecs
[    0.126215] calling  init_posix_cpu_timers+0x0/0xb0 @ 1
[    0.126221] initcall init_posix_cpu_timers+0x0/0xb0 returned 0 after 
0 usecs
[    0.126228] calling  nsproxy_cache_init+0x0/0x30 @ 1
[    0.126234] initcall nsproxy_cache_init+0x0/0x30 returned 0 after 1 usecs
[    0.126242] calling  timekeeping_init_device+0x0/0x20 @ 1
[    0.126339] initcall timekeeping_init_device+0x0/0x20 returned 0 
after 88 usecs
[    0.126348] calling  init_clocksource_sysfs+0x0/0x40 @ 1
[    0.126431] initcall init_clocksource_sysfs+0x0/0x40 returned 0 after 
74 usecs
[    0.126440] calling  init_timer_list_procfs+0x0/0x30 @ 1
[    0.126449] initcall init_timer_list_procfs+0x0/0x30 returned 0 after 
3 usecs
[    0.126456] calling  futex_init+0x0/0x60 @ 1
[    0.126470] initcall futex_init+0x0/0x60 returned 0 after 9 usecs
[    0.126477] calling  proc_dma_init+0x0/0x30 @ 1
[    0.126483] initcall proc_dma_init+0x0/0x30 returned 0 after 1 usecs
[    0.126490] calling  kallsyms_init+0x0/0x30 @ 1
[    0.126497] initcall kallsyms_init+0x0/0x30 returned 0 after 2 usecs
[    0.126504] calling  ikconfig_init+0x0/0x40 @ 1
[    0.126511] initcall ikconfig_init+0x0/0x40 returned 0 after 1 usecs
[    0.126518] calling  utsname_sysctl_init+0x0/0x10 @ 1
[    0.126526] initcall utsname_sysctl_init+0x0/0x10 returned 0 after 3 
usecs
[    0.126535] calling  init_sched_switch_trace+0x0/0x40 @ 1
[    0.126542] initcall init_sched_switch_trace+0x0/0x40 returned 0 
after 1 usecs
[    0.126550] calling  init_per_zone_pages_min+0x0/0x50 @ 1
[    0.126620] initcall init_per_zone_pages_min+0x0/0x50 returned 0 
after 61 usecs
[    0.126628] calling  pdflush_init+0x0/0x20 @ 1
[    0.126668] initcall pdflush_init+0x0/0x20 returned 0 after 33 usecs
[    0.126676] calling  kswapd_init+0x0/0x10 @ 1
[    0.126698] initcall kswapd_init+0x0/0x10 returned 0 after 16 usecs
[    0.126706] calling  setup_vmstat+0x0/0x90 @ 1
[    0.126719] initcall setup_vmstat+0x0/0x90 returned 0 after 7 usecs
[    0.126727] calling  mm_sysfs_init+0x0/0x20 @ 1
[    0.126736] initcall mm_sysfs_init+0x0/0x20 returned 0 after 4 usecs
[    0.126744] calling  proc_vmalloc_init+0x0/0x30 @ 1
[    0.126751] initcall proc_vmalloc_init+0x0/0x30 returned 0 after 2 usecs
[    0.126759] calling  init_emergency_pool+0x0/0x70 @ 1
[    0.126796] highmem bounce pool size: 64 pages
[    0.126802] initcall init_emergency_pool+0x0/0x70 returned 0 after 35 
usecs
[    0.126810] calling  init_tmpfs+0x0/0xd0 @ 1
[    0.126840] initcall init_tmpfs+0x0/0xd0 returned 0 after 24 usecs
[    0.126848] calling  fasync_init+0x0/0x30 @ 1
[    0.126856] initcall fasync_init+0x0/0x30 returned 0 after 2 usecs
[    0.126865] calling  proc_filesystems_init+0x0/0x30 @ 1
[    0.126874] initcall proc_filesystems_init+0x0/0x30 returned 0 after 
3 usecs
[    0.126882] calling  inotify_setup+0x0/0x10 @ 1
[    0.126889] initcall inotify_setup+0x0/0x10 returned 0 after 1 usecs
[    0.126897] calling  inotify_user_setup+0x0/0xc0 @ 1
[    0.126910] initcall inotify_user_setup+0x0/0xc0 returned 0 after 7 usecs
[    0.126918] calling  proc_locks_init+0x0/0x30 @ 1
[    0.126925] initcall proc_locks_init+0x0/0x30 returned 0 after 2 usecs
[    0.126933] calling  init_mbcache+0x0/0x10 @ 1
[    0.126939] initcall init_mbcache+0x0/0x10 returned 0 after 0 usecs
[    0.126948] calling  proc_cmdline_init+0x0/0x30 @ 1
[    0.126956] initcall proc_cmdline_init+0x0/0x30 returned 0 after 2 usecs
[    0.126964] calling  proc_cpuinfo_init+0x0/0x30 @ 1
[    0.126982] initcall proc_cpuinfo_init+0x0/0x30 returned 0 after 10 usecs
[    0.126990] calling  proc_devices_init+0x0/0x30 @ 1
[    0.126997] initcall proc_devices_init+0x0/0x30 returned 0 after 1 usecs
[    0.127006] calling  proc_interrupts_init+0x0/0x30 @ 1
[    0.127014] initcall proc_interrupts_init+0x0/0x30 returned 0 after 2 
usecs
[    0.127024] calling  proc_loadavg_init+0x0/0x30 @ 1
[    0.127031] initcall proc_loadavg_init+0x0/0x30 returned 0 after 1 usecs
[    0.127039] calling  proc_meminfo_init+0x0/0x30 @ 1
[    0.127046] initcall proc_meminfo_init+0x0/0x30 returned 0 after 1 usecs
[    0.127054] calling  proc_stat_init+0x0/0x30 @ 1
[    0.127062] initcall proc_stat_init+0x0/0x30 returned 0 after 1 usecs
[    0.127070] calling  proc_uptime_init+0x0/0x30 @ 1
[    0.127083] initcall proc_uptime_init+0x0/0x30 returned 0 after 7 usecs
[    0.127091] calling  proc_version_init+0x0/0x30 @ 1
[    0.127098] initcall proc_version_init+0x0/0x30 returned 0 after 2 usecs
[    0.127107] calling  proc_kcore_init+0x0/0x50 @ 1
[    0.127114] initcall proc_kcore_init+0x0/0x50 returned 0 after 2 usecs
[    0.127122] calling  proc_kmsg_init+0x0/0x30 @ 1
[    0.127129] initcall proc_kmsg_init+0x0/0x30 returned 0 after 1 usecs
[    0.127137] calling  proc_page_init+0x0/0x50 @ 1
[    0.127147] initcall proc_page_init+0x0/0x50 returned 0 after 4 usecs
[    0.127155] calling  init_devpts_fs+0x0/0x30 @ 1
[    0.127171] initcall init_devpts_fs+0x0/0x30 returned 0 after 9 usecs
[    0.127179] calling  init_ext3_fs+0x0/0x70 @ 1
[    0.127192] initcall init_ext3_fs+0x0/0x70 returned 0 after 6 usecs
[    0.127200] calling  journal_init+0x0/0xa0 @ 1
[    0.127210] initcall journal_init+0x0/0xa0 returned 0 after 4 usecs
[    0.127219] calling  init_ext2_fs+0x0/0x70 @ 1
[    0.127228] initcall init_ext2_fs+0x0/0x70 returned 0 after 4 usecs
[    0.127236] calling  init_ramfs_fs+0x0/0x10 @ 1
[    0.127244] initcall init_ramfs_fs+0x0/0x10 returned 0 after 1 usecs
[    0.127252] calling  init_fat_fs+0x0/0x50 @ 1
[    0.127258] initcall init_fat_fs+0x0/0x50 returned 0 after 1 usecs
[    0.127266] calling  init_vfat_fs+0x0/0x10 @ 1
[    0.127273] initcall init_vfat_fs+0x0/0x10 returned 0 after 2 usecs
[    0.127282] calling  init_iso9660_fs+0x0/0x60 @ 1
[    0.127290] initcall init_iso9660_fs+0x0/0x60 returned 0 after 2 usecs
[    0.127298] calling  init_nls_cp437+0x0/0x10 @ 1
[    0.127304] initcall init_nls_cp437+0x0/0x10 returned 0 after 0 usecs
[    0.127313] calling  init_nls_cp1250+0x0/0x10 @ 1
[    0.127318] initcall init_nls_cp1250+0x0/0x10 returned 0 after 0 usecs
[    0.127327] calling  init_nls_ascii+0x0/0x10 @ 1
[    0.127332] initcall init_nls_ascii+0x0/0x10 returned 0 after 0 usecs
[    0.127341] calling  init_nls_iso8859_1+0x0/0x10 @ 1
[    0.127346] initcall init_nls_iso8859_1+0x0/0x10 returned 0 after 0 usecs
[    0.127355] calling  init_nls_utf8+0x0/0x30 @ 1
[    0.127361] initcall init_nls_utf8+0x0/0x30 returned 0 after 0 usecs
[    0.127369] calling  fuse_init+0x0/0x130 @ 1
[    0.127373] fuse init (API version 7.10)
[    0.127474] initcall fuse_init+0x0/0x130 returned 0 after 93 usecs
[    0.127486] calling  ipc_init+0x0/0x20 @ 1
[    0.127496] msgmni has been set to 1749
[    0.127508] initcall ipc_init+0x0/0x20 returned 0 after 16 usecs
[    0.127516] calling  ipc_sysctl_init+0x0/0x10 @ 1
[    0.127524] initcall ipc_sysctl_init+0x0/0x10 returned 0 after 1 usecs
[    0.127532] calling  init_mqueue_fs+0x0/0xb0 @ 1
[    0.127557] initcall init_mqueue_fs+0x0/0xb0 returned 0 after 18 usecs
[    0.127567] calling  crypto_algapi_init+0x0/0x10 @ 1
[    0.127575] initcall crypto_algapi_init+0x0/0x10 returned 0 after 2 usecs
[    0.127586] calling  chainiv_module_init+0x0/0x10 @ 1
[    0.127594] initcall chainiv_module_init+0x0/0x10 returned 0 after 1 
usecs
[    0.127603] calling  eseqiv_module_init+0x0/0x10 @ 1
[    0.127609] initcall eseqiv_module_init+0x0/0x10 returned 0 after 0 usecs
[    0.127618] calling  crypto_ecb_module_init+0x0/0x10 @ 1
[    0.127624] initcall crypto_ecb_module_init+0x0/0x10 returned 0 after 
0 usecs
[    0.127633] calling  aes_init+0x0/0x340 @ 1
[    0.127754] initcall aes_init+0x0/0x340 returned 0 after 110 usecs
[    0.127763] calling  arc4_init+0x0/0x10 @ 1
[    0.127863] initcall arc4_init+0x0/0x10 returned 0 after 91 usecs
[    0.127872] calling  krng_mod_init+0x0/0x10 @ 1
[    0.127893] alg: No test for stdrng (krng)
[    0.127905] initcall krng_mod_init+0x0/0x10 returned 0 after 26 usecs
[    0.127914] calling  proc_genhd_init+0x0/0x40 @ 1
[    0.127928] initcall proc_genhd_init+0x0/0x40 returned 0 after 8 usecs
[    0.127937] calling  noop_init+0x0/0x10 @ 1
[    0.127942] io scheduler noop registered
[    0.127947] initcall noop_init+0x0/0x10 returned 0 after 4 usecs
[    0.127955] calling  deadline_init+0x0/0x10 @ 1
[    0.127959] io scheduler deadline registered (default)
[    0.127965] initcall deadline_init+0x0/0x10 returned 0 after 3 usecs
[    0.127986] calling  pci_init+0x0/0x40 @ 1
[    0.128004] pci 0000:00:02.0: Boot video device
[    0.130840] initcall pci_init+0x0/0x40 returned 0 after 2777 usecs
[    0.130853] calling  pci_proc_init+0x0/0x70 @ 1
[    0.130923] initcall pci_proc_init+0x0/0x70 returned 0 after 61 usecs
[    0.130932] calling  pcie_portdrv_init+0x0/0x50 @ 1
[    0.131050] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.131091] pcieport-driver 0000:00:1c.0: found MSI capability
[    0.131123] pcieport-driver 0000:00:1c.0: irq 287 for MSI/MSI-X
[    0.131139] pci_express 0000:00:1c.0:pcie00: allocate port service
[    0.131203] pci_express 0000:00:1c.0:pcie02: allocate port service
[    0.131256] pci_express 0000:00:1c.0:pcie03: allocate port service
[    0.131362] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.131399] pcieport-driver 0000:00:1c.1: found MSI capability
[    0.131425] pcieport-driver 0000:00:1c.1: irq 286 for MSI/MSI-X
[    0.131439] pci_express 0000:00:1c.1:pcie00: allocate port service
[    0.131496] pci_express 0000:00:1c.1:pcie02: allocate port service
[    0.131549] pci_express 0000:00:1c.1:pcie03: allocate port service
[    0.131652] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.131690] pcieport-driver 0000:00:1c.2: found MSI capability
[    0.131717] pcieport-driver 0000:00:1c.2: irq 285 for MSI/MSI-X
[    0.131731] pci_express 0000:00:1c.2:pcie00: allocate port service
[    0.131787] pci_express 0000:00:1c.2:pcie02: allocate port service
[    0.131843] pci_express 0000:00:1c.2:pcie03: allocate port service
[    0.132016] initcall pcie_portdrv_init+0x0/0x50 returned 0 after 1048 
usecs
[    0.132028] calling  aer_service_init+0x0/0x20 @ 1
[    0.132083] initcall aer_service_init+0x0/0x20 returned 0 after 47 usecs
[    0.132094] calling  fb_console_init+0x0/0x130 @ 1
[    0.132166] initcall fb_console_init+0x0/0x130 returned 0 after 62 usecs
[    0.132177] calling  display_class_init+0x0/0x70 @ 1
[    0.132228] initcall display_class_init+0x0/0x70 returned 0 after 42 
usecs
[    0.132239] calling  vesafb_init+0x0/0x1fb @ 1
[    0.132354] initcall vesafb_init+0x0/0x1fb returned 0 after 103 usecs
[    0.132364] calling  acpi_reserve_resources+0x0/0xc4 @ 1
[    0.132376] initcall acpi_reserve_resources+0x0/0xc4 returned 0 after 
6 usecs
[    0.132383] calling  acpi_ac_init+0x0/0x39 @ 1
[    0.132400] initcall acpi_ac_init+0x0/0x39 returned 0 after 12 usecs
[    0.132407] calling  acpi_battery_init+0x0/0x39 @ 1
[    0.132415] initcall acpi_battery_init+0x0/0x39 returned 0 after 2 usecs
[    0.132422] calling  acpi_button_init+0x0/0x4d @ 1
[    0.132429] initcall acpi_button_init+0x0/0x4d returned 0 after 2 usecs
[    0.132436] calling  acpi_fan_init+0x0/0x28 @ 1
[    0.132441] initcall acpi_fan_init+0x0/0x28 returned 0 after 0 usecs
[    0.132449] calling  irqrouter_init_sysfs+0x0/0x2d @ 1
[    0.132475] calling  5_acpi_bus_register_async+0x0/0x4b @ 160
[    0.132479] async_waiting @ 160
[    0.132482] async_continuing @ 160 after 0 usec
[    0.132652] calling  6_acpi_bus_register_async+0x0/0x4b @ 157
[    0.132657] async_waiting @ 157
[    0.132665] calling  7_acpi_bus_register_async+0x0/0x4b @ 154
[    0.132668] async_waiting @ 154
[    0.132675] calling  8_acpi_bus_register_async+0x0/0x4b @ 151
[    0.132679] async_waiting @ 151
[    0.132784] ACPI: AC Adapter [AC0] (on-line)
[    0.132875] initcall irqrouter_init_sysfs+0x0/0x2d returned 0 after 
408 usecs
[    0.132885] calling  acpi_processor_init+0x0/0x85 @ 1
[    0.132904] initcall acpi_processor_init+0x0/0x85 returned 0 after 13 
usecs
[    0.132912] calling  acpi_thermal_init+0x0/0x72 @ 1
[    0.132926] initcall acpi_thermal_init+0x0/0x72 returned 0 after 8 usecs
[    0.132938] calling  rand_initialize+0x0/0x30 @ 1
[    0.132991] initcall rand_initialize+0x0/0x30 returned 0 after 46 usecs
[    0.132998] calling  tty_init+0x0/0x110 @ 1
[    0.133077] calling  9_acpi_bus_register_async+0x0/0x4b @ 280
[    0.133081] async_waiting @ 280
[    0.133123] calling  10_acpi_bus_register_async+0x0/0x4b @ 281
[    0.133127] async_waiting @ 281
[    0.133146] initcall 5_acpi_bus_register_async+0x0/0x4b returned 0 
after 647 usecs
[    0.133157] async_continuing @ 157 after 484 usec
[    0.134644] ACPI: EC: non-query interrupt received, switching to 
interrupt mode
[    0.139017] initcall tty_init+0x0/0x110 returned 0 after 5867 usecs
[    0.139030] calling  pty_init+0x0/0x290 @ 1
[    0.139134] initcall pty_init+0x0/0x290 returned 0 after 95 usecs
[    0.139177] calling  sysrq_init+0x0/0x30 @ 1
[    0.139218] initcall sysrq_init+0x0/0x30 returned 0 after 21 usecs
[    0.139225] calling  hpet_init+0x0/0x60 @ 1
[    0.139318] initcall hpet_init+0x0/0x60 returned 0 after 84 usecs
[    0.139327] calling  nvram_init+0x0/0x80 @ 1
[    0.139372] calling  11_acpi_bus_register_async+0x0/0x4b @ 160
[    0.139376] async_waiting @ 160
[    0.139424] Non-volatile memory driver v1.2
[    0.139431] initcall nvram_init+0x0/0x80 returned 0 after 95 usecs
[    0.139440] calling  agp_init+0x0/0x30 @ 1
[    0.139444] Linux agpgart interface v0.103
[    0.139449] initcall agp_init+0x0/0x30 returned 0 after 3 usecs
[    0.139456] calling  agp_intel_init+0x0/0x30 @ 1
[    0.139487] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    0.139787] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    0.143481] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.143555] initcall agp_intel_init+0x0/0x30 returned 0 after 3994 usecs
[    0.143568] calling  drm_core_init+0x0/0x100 @ 1
[    0.143635] [drm] Initialized drm 1.1.0 20060810
[    0.143642] initcall drm_core_init+0x0/0x100 returned 0 after 66 usecs
[    0.143651] calling  i915_init+0x0/0x20 @ 1
[    0.143689] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.143695] pci 0000:00:02.0: setting latency timer to 64
[    0.143772] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read 
from MCHBAR.  Disabling tiling.
[    0.143996] [drm] Initialized i915 1.6.0 20080730 on minor 0
[    0.144037] initcall i915_init+0x0/0x20 returned 0 after 370 usecs
[    0.144047] calling  loop_init+0x0/0x1c0 @ 1
[    0.145278] loop: module loaded
[    0.145287] initcall loop_init+0x0/0x1c0 returned 0 after 1203 usecs
[    0.145299] calling  eeepc_laptop_init+0x0/0x1c0 @ 1
[    0.145313] initcall eeepc_laptop_init+0x0/0x1c0 returned -19 after 8 
usecs
[    0.145320] calling  atl2_init_module+0x0/0x50 @ 1
[    0.145325] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    0.145328] Copyright (c) 2007 Atheros Corporation.
[    0.145363] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.145375] atl2 0000:03:00.0: setting latency timer to 64
[    0.145468] calling  12_acpi_bus_register_async+0x0/0x4b @ 375
[    0.145472] async_waiting @ 375
[    0.215208] initcall atl2_init_module+0x0/0x50 returned 0 after 68239 
usecs
[    0.215222] calling  net_olddevs_init+0x0/0x90 @ 1
[    0.215236] initcall net_olddevs_init+0x0/0x90 returned 0 after 7 usecs
[    0.215244] calling  init_ath5k_pci+0x0/0x30 @ 1
[    0.215281] ath5k_pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    0.215294] ath5k_pci 0000:01:00.0: setting latency timer to 64
[    0.215345] ath5k_pci 0000:01:00.0: registered as 'phy0'
[    0.255667] phy0: Selected rate control algorithm 'minstrel'
[    0.255925] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    0.255999] initcall init_ath5k_pci+0x0/0x30 returned 0 after 39788 usecs
[    0.256012] calling  videodev_init+0x0/0x90 @ 1
[    0.256016] Linux video capture interface: v2.00
[    0.256071] initcall videodev_init+0x0/0x90 returned 0 after 51 usecs
[    0.256080] calling  uvc_init+0x0/0x90 @ 1
[    0.256346] usbcore: registered new interface driver uvcvideo
[    0.256353] USB Video Class driver (v0.1.0)
[    0.256359] initcall uvc_init+0x0/0x90 returned 0 after 267 usecs
[    0.256368] calling  init_sd+0x0/0xa0 @ 1
[    0.256423] Driver 'sd' needs updating - please use bus_type methods
[    0.256471] initcall init_sd+0x0/0xa0 returned 0 after 94 usecs
[    0.256479] calling  piix_init+0x0/0x30 @ 1
[    0.256508] ata_piix 0000:00:1f.2: version 2.12
[    0.256531] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.256537] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    0.256600] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.256674] scsi0 : ata_piix
[    0.256849] scsi1 : ata_piix
[    0.260209] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 
irq 14
[    0.260217] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 
irq 15
[    0.260231] async_waiting @ 1
[    0.260279] calling  13_async_port_probe+0x0/0x80 @ 395
[    0.447870] initcall 13_async_port_probe+0x0/0x80 returned 0 after 
183184 usecs
[    0.447888] calling  14_async_port_probe+0x0/0x80 @ 395
[    0.448011] async_continuing @ 375 after 295444 usec
[    0.448050] eeepc: Eee PC Hotkey Driver
[    0.448255] eeepc: Hotkey init flags 0x41
[    0.449483] eeepc: Get control methods supported: 0x101711
[    0.449582] async_continuing @ 160 after 302931 usec
[    0.449621] async_continuing @ 281 after 309072 usec
[    0.449816] async_continuing @ 154 after 309710 usec
[    0.449947] async_continuing @ 151 after 309828 usec
[    0.449980] async_continuing @ 280 after 309468 usec
[    0.450056] input: Asus EeePC extra buttons as 
/devices/virtual/input/input0
[    0.450100] initcall 11_acpi_bus_register_async+0x0/0x4b returned 0 
after 303433 usecs
[    0.450504] input: Power Button (FF) as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.450532] initcall 8_acpi_bus_register_async+0x0/0x4b returned 0 
after 310398 usecs
[    0.452163] initcall 12_acpi_bus_register_async+0x0/0x4b returned 0 
after 299496 usecs
[    0.452194] ACPI: Power Button (FF) [PWRF]
[    0.452998] input: Lid Switch as 
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
[    0.453055] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.453136] processor ACPI_CPU:00: registered as cooling_device0
[    0.453145] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.453224] initcall 9_acpi_bus_register_async+0x0/0x4b returned 0 
after 312634 usecs
[    0.458702] thermal LNXTHERM:01: registered as thermal_zone0
[    0.465844] ACPI: Lid Switch [LID]
[    0.465995] input: Sleep Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
[    0.466020] ACPI: Sleep Button (CM) [SLPB]
[    0.466139] input: Power Button (CM) as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
[    0.466164] ACPI: Power Button (CM) [PWRB]
[    0.466217] initcall 7_acpi_bus_register_async+0x0/0x4b returned 0 
after 325724 usecs
[    0.498770] ACPI: Battery Slot [BAT0] (battery present)
[    0.499161] initcall 6_acpi_bus_register_async+0x0/0x4b returned 0 
after 357908 usecs
[    0.509372] ACPI: Thermal Zone [TZ00] (54 C)
[    0.509455] initcall 10_acpi_bus_register_async+0x0/0x4b returned 0 
after 367503 usecs
[    0.589924] Switched to high resolution mode on CPU 0
[    0.596364] ata2.00: ATA-5: ASUS-PHISON OB SSD, TST2.04P, max UDMA/66
[    0.596369] ata2.00: 7880544 sectors, multi 0: LBA
[    0.596442] ata2.01: ATA-5: ASUS-PHISON SSD, TST2.04P, max UDMA/66
[    0.596447] ata2.01: 31522176 sectors, multi 0: LBA
[    0.599341] ata2.00: configured for UDMA/66
[    0.602333] ata2.01: configured for UDMA/66
[    0.602350] initcall 14_async_port_probe+0x0/0x80 returned 0 after 
150833 usecs
[    0.602358] async_continuing @ 1 after 334105 usec
[    0.602508] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON OB S 
TST2 PQ: 0 ANSI: 5
[    0.602727] calling  15_sd_probe_async+0x0/0x250 @ 395
[    0.602938] scsi 1:0:1:0: Direct-Access     ATA      ASUS-PHISON SSD 
  TST2 PQ: 0 ANSI: 5
[    0.603060] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: 
(4.03 GB/3.75 GiB)
[    0.603084] sd 1:0:0:0: [sda] Write Protect is off
[    0.603089] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.603123] sd 1:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.603226] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: 
(4.03 GB/3.75 GiB)
[    0.603246] sd 1:0:0:0: [sda] Write Protect is off
[    0.603250] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.603281] sd 1:0:0:0: [sda] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.603287]  sda:calling  16_sd_probe_async+0x0/0x250 @ 375
[    0.603731] initcall piix_init+0x0/0x30 returned 0 after 339104 usecs
[    0.603748] calling  ehci_hcd_init+0x0/0x80 @ 1
[    0.603752] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.603798] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    0.603828] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.603833] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.603940] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    0.607880] ehci_hcd 0000:00:1d.7: debug port 1
[    0.607889] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.607909] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    0.611841] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: 
(16.1 GB/15.0 GiB)
[    0.611864] sd 1:0:1:0: [sdb] Write Protect is off
[    0.611868] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    0.611901] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.611999] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: 
(16.1 GB/15.0 GiB)
[    0.612029] sd 1:0:1:0: [sdb] Write Protect is off
[    0.612033] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    0.612065] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[    0.612070]  sdb: sda1 sda2 sda3 sda4
[    0.612572] sd 1:0:0:0: [sda] Attached SCSI disk
[    0.612584] initcall 15_sd_probe_async+0x0/0x250 returned 0 after 
9614 usecs
[    0.613427]  sdb1 sdb2
[    0.613695] sd 1:0:1:0: [sdb] Attached SCSI disk
[    0.613705] initcall 16_sd_probe_async+0x0/0x250 returned 0 after 
9905 usecs
[    0.617014] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.617188] usb usb1: configuration #1 chosen from 1 choice
[    0.617278] hub 1-0:1.0: USB hub found
[    0.617294] hub 1-0:1.0: 8 ports detected
[    0.617567] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.617572] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.617578] usb usb1: Product: EHCI Host Controller
[    0.617582] usb usb1: Manufacturer: Linux 2.6.28-00001-g55bd644-dirty 
ehci_hcd
[    0.617586] usb usb1: SerialNumber: 0000:00:1d.7
[    0.617646] initcall ehci_hcd_init+0x0/0x80 returned 0 after 13563 usecs
[    0.617658] calling  uhci_hcd_init+0x0/0xc0 @ 1
[    0.617662] uhci_hcd: USB Universal Host Controller Interface driver
[    0.617699] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    0.617711] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.617717] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.617799] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    0.617831] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    0.618024] usb usb2: configuration #1 chosen from 1 choice
[    0.618107] hub 2-0:1.0: USB hub found
[    0.618121] hub 2-0:1.0: 2 ports detected
[    0.618316] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    0.618321] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.618326] usb usb2: Product: UHCI Host Controller
[    0.618330] usb usb2: Manufacturer: Linux 2.6.28-00001-g55bd644-dirty 
uhci_hcd
[    0.618334] usb usb2: SerialNumber: 0000:00:1d.0
[    0.618367] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.618377] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.618382] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.618461] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    0.618500] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    0.618670] usb usb3: configuration #1 chosen from 1 choice
[    0.618751] hub 3-0:1.0: USB hub found
[    0.618764] hub 3-0:1.0: 2 ports detected
[    0.618965] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.618970] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.618975] usb usb3: Product: UHCI Host Controller
[    0.618979] usb usb3: Manufacturer: Linux 2.6.28-00001-g55bd644-dirty 
uhci_hcd
[    0.618983] usb usb3: SerialNumber: 0000:00:1d.1
[    0.619025] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    0.619036] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.619041] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.619117] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    0.619146] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    0.619331] usb usb4: configuration #1 chosen from 1 choice
[    0.619413] hub 4-0:1.0: USB hub found
[    0.619424] hub 4-0:1.0: 2 ports detected
[    0.619625] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.619630] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.619635] usb usb4: Product: UHCI Host Controller
[    0.619639] usb usb4: Manufacturer: Linux 2.6.28-00001-g55bd644-dirty 
uhci_hcd
[    0.619643] usb usb4: SerialNumber: 0000:00:1d.2
[    0.619677] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) 
-> IRQ 16
[    0.619687] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    0.619692] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.619766] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 5
[    0.619802] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    0.619984] usb usb5: configuration #1 chosen from 1 choice
[    0.620106] hub 5-0:1.0: USB hub found
[    0.620119] hub 5-0:1.0: 2 ports detected
[    0.620320] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.620325] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    0.620329] usb usb5: Product: UHCI Host Controller
[    0.620333] usb usb5: Manufacturer: Linux 2.6.28-00001-g55bd644-dirty 
uhci_hcd
[    0.620337] usb usb5: SerialNumber: 0000:00:1d.3
[    0.620407] initcall uhci_hcd_init+0x0/0xc0 returned 0 after 2672 usecs
[    0.620422] calling  usb_stor_init+0x0/0x40 @ 1
[    0.620425] Initializing USB Mass Storage driver...
[    0.620515] usbcore: registered new interface driver usb-storage
[    0.620522] USB Mass Storage support registered.
[    0.620528] initcall usb_stor_init+0x0/0x40 returned 0 after 98 usecs
[    0.620539] calling  i8042_init+0x0/0x420 @ 1
[    0.620704] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 
0x60,0x64 irq 1,12
[    0.652020] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.652028] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.652041] initcall i8042_init+0x0/0x420 returned 0 after 30755 usecs
[    0.652051] calling  mousedev_init+0x0/0x90 @ 1
[    0.652312] mice: PS/2 mouse device common for all mice
[    0.652320] initcall mousedev_init+0x0/0x90 returned 0 after 255 usecs
[    0.652329] calling  evdev_init+0x0/0x10 @ 1
[    0.652800] initcall evdev_init+0x0/0x10 returned 0 after 453 usecs
[    0.652810] calling  atkbd_init+0x0/0x20 @ 1
[    0.652870] initcall atkbd_init+0x0/0x20 returned 0 after 51 usecs
[    0.652879] calling  psmouse_init+0x0/0x70 @ 1
[    0.653659] initcall psmouse_init+0x0/0x70 returned 0 after 754 usecs
[    0.653668] calling  cmos_init+0x0/0x40 @ 1
[    0.653706] rtc_cmos 00:03: RTC can wake from S4
[    0.653802] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.653832] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.653890] initcall cmos_init+0x0/0x40 returned 0 after 208 usecs
[    0.653900] calling  init_ladder+0x0/0x10 @ 1
[    0.654081] cpuidle: using governor ladder
[    0.654088] initcall init_ladder+0x0/0x10 returned 0 after 178 usecs
[    0.654097] calling  init_menu+0x0/0x10 @ 1
[    0.654410] cpuidle: using governor menu
[    0.654417] initcall init_menu+0x0/0x10 returned 0 after 306 usecs
[    0.654427] calling  init_soundcore+0x0/0x30 @ 1
[    0.654480] initcall init_soundcore+0x0/0x30 returned 0 after 45 usecs
[    0.654489] calling  alsa_sound_init+0x0/0x80 @ 1
[    0.654514] Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
[    0.654520] initcall alsa_sound_init+0x0/0x80 returned 0 after 24 usecs
[    0.654528] calling  alsa_timer_init+0x0/0x160 @ 1
[    0.654621] initcall alsa_timer_init+0x0/0x160 returned 0 after 84 usecs
[    0.654631] calling  alsa_pcm_init+0x0/0x60 @ 1
[    0.654639] initcall alsa_pcm_init+0x0/0x60 returned 0 after 2 usecs
[    0.654647] calling  snd_mem_init+0x0/0x30 @ 1
[    0.654657] initcall snd_mem_init+0x0/0x30 returned 0 after 3 usecs
[    0.654665] calling  alsa_card_azx_init+0x0/0x20 @ 1
[    0.654708] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) 
-> IRQ 16
[    0.654748] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.656056] Marking TSC unstable due to TSC halts in idle
[    0.656780] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input5
[    0.661942] hda_codec: Unknown model for ALC662, trying auto-probe 
from BIOS...
[    0.686794] initcall alsa_card_azx_init+0x0/0x20 returned 0 after 
31364 usecs
[    0.686810] calling  alsa_sound_last_init+0x0/0x70 @ 1
[    0.686814] ALSA device list:
[    0.686817]   #0: HDA Intel at 0xf7eb8000 irq 16
[    0.686824] initcall alsa_sound_last_init+0x0/0x70 returned 0 after 6 
usecs
[    0.686833] calling  sysctl_core_init+0x0/0x20 @ 1
[    0.686856] initcall sysctl_core_init+0x0/0x20 returned 0 after 16 usecs
[    0.686864] calling  sysctl_ipv4_init+0x0/0x40 @ 1
[    0.686882] initcall sysctl_ipv4_init+0x0/0x40 returned 0 after 11 usecs
[    0.686888] calling  inet_diag_init+0x0/0x70 @ 1
[    0.686903] initcall inet_diag_init+0x0/0x70 returned 0 after 8 usecs
[    0.686909] calling  tcp_diag_init+0x0/0x10 @ 1
[    0.686915] initcall tcp_diag_init+0x0/0x10 returned 0 after 1 usecs
[    0.686922] calling  cubictcp_register+0x0/0xb0 @ 1
[    0.686927] TCP cubic registered
[    0.686932] initcall cubictcp_register+0x0/0xb0 returned 0 after 4 usecs
[    0.686939] calling  packet_init+0x0/0x40 @ 1
[    0.686944] NET: Registered protocol family 17
[    0.686958] initcall packet_init+0x0/0x40 returned 0 after 14 usecs
[    0.686965] calling  rfkill_handler_init+0x0/0x40 @ 1
[    0.687028] initcall rfkill_handler_init+0x0/0x40 returned 0 after 54 
usecs
[    0.687040] calling  hpet_insert_resource+0x0/0x20 @ 1
[    0.687047] initcall hpet_insert_resource+0x0/0x20 returned 1 after 0 
usecs
[    0.687056] initcall hpet_insert_resource+0x0/0x20 returned with 
error code 1
[    0.687062] calling  lapic_insert_resource+0x0/0x40 @ 1
[    0.687074] initcall lapic_insert_resource+0x0/0x40 returned 0 after 
5 usecs
[    0.687083] calling  init_lapic_nmi_sysfs+0x0/0x40 @ 1
[    0.687091] initcall init_lapic_nmi_sysfs+0x0/0x40 returned 0 after 0 
usecs
[    0.687099] calling  ioapic_insert_resources+0x0/0x60 @ 1
[    0.687107] initcall ioapic_insert_resources+0x0/0x60 returned 0 
after 1 usecs
[    0.687116] calling  io_apic_bug_finalize+0x0/0x20 @ 1
[    0.687123] initcall io_apic_bug_finalize+0x0/0x20 returned 0 after 0 
usecs
[    0.687132] calling  check_early_ioremap_leak+0x0/0x70 @ 1
[    0.687140] initcall check_early_ioremap_leak+0x0/0x70 returned 0 
after 1 usecs
[    0.687149] calling  print_ipi_mode+0x0/0x30 @ 1
[    0.687153] Using IPI Shortcut mode
[    0.687159] initcall print_ipi_mode+0x0/0x30 returned 0 after 3 usecs
[    0.687169] calling  init_oops_id+0x0/0x20 @ 1
[    0.687188] initcall init_oops_id+0x0/0x20 returned 0 after 13 usecs
[    0.687196] calling  disable_boot_consoles+0x0/0x50 @ 1
[    0.687204] initcall disable_boot_consoles+0x0/0x50 returned 0 after 
0 usecs
[    0.687213] calling  pm_qos_power_init+0x0/0x80 @ 1
[    0.687431] initcall pm_qos_power_init+0x0/0x80 returned 0 after 206 
usecs
[    0.687443] calling  random32_reseed+0x0/0x60 @ 1
[    0.687463] initcall random32_reseed+0x0/0x60 returned 0 after 13 usecs
[    0.687473] calling  pci_sysfs_init+0x0/0x50 @ 1
[    0.687606] initcall pci_sysfs_init+0x0/0x50 returned 0 after 123 usecs
[    0.687615] calling  acpi_wakeup_device_init+0x0/0x66 @ 1
[    0.687624] initcall acpi_wakeup_device_init+0x0/0x66 returned 0 
after 3 usecs
[    0.687634] calling  acpi_sleep_proc_init+0x0/0x2a @ 1
[    0.687645] initcall acpi_sleep_proc_init+0x0/0x2a returned 0 after 5 
usecs
[    0.687653] calling  seqgen_init+0x0/0x10 @ 1
[    0.687689] initcall seqgen_init+0x0/0x10 returned 0 after 29 usecs
[    0.687698] calling  scsi_complete_async_scans+0x0/0xd0 @ 1
[    0.687705] initcall scsi_complete_async_scans+0x0/0xd0 returned 0 
after 1 usecs
[    0.687714] calling  rtc_hctosys+0x0/0x190 @ 1
[    0.687747] rtc_cmos 00:03: setting system clock to 2009-01-04 
18:25:04 UTC (1231093504)
[    0.687754] initcall rtc_hctosys+0x0/0x190 returned 0 after 34 usecs
[    0.687763] calling  pci_mmcfg_late_insert_resources+0x0/0x150 @ 1
[    0.687786] initcall pci_mmcfg_late_insert_resources+0x0/0x150 
returned 0 after 15 usecs
[    0.687797] calling  tcp_congestion_default+0x0/0x10 @ 1
[    0.687805] initcall tcp_congestion_default+0x0/0x10 returned 0 after 
1 usecs
[    0.920083] usb 1-5: new high speed USB device using ehci_hcd and 
address 2
[    1.035410] usb 1-5: configuration #1 chosen from 1 choice
[    1.035659] scsi2 : SCSI emulation for USB Mass Storage devices
[    1.035903] usb-storage: device found at 2
[    1.035906] usb-storage: waiting for device to settle before scanning
[    1.036147] usb 1-5: New USB device found, idVendor=0951, idProduct=1606
[    1.036153] usb 1-5: New USB device strings: Mfr=1, Product=2, 
SerialNumber=4
[    1.036157] usb 1-5: Product: UB6225
[    1.036160] usb 1-5: Manufacturer: ENE
[    1.036163] usb 1-5: SerialNumber: 146030377350
[    1.080020] Clocksource tsc unstable (delta = -321716980 ns)
[    2.697478] input: ImPS/2 Logitech Wheel Mouse as 
/devices/platform/i8042/serio1/input/input6
[    2.710044] kjournald starting.  Commit interval 5 seconds
[    2.710059] EXT3-fs: mounted filesystem with ordered data mode.
[    2.710076] VFS: Mounted root (ext3 filesystem) readonly.
[    2.710119] async_waiting @ 1
[    2.710124] async_continuing @ 1 after 0 usec
[    2.710311] Freeing unused kernel memory: 276k freed
[    2.710380] Write protecting the kernel text: 2604k
[    2.710411] Write protecting the kernel read-only data: 704k
[    5.917853] EXT3 FS on sdb2, internal journal
[    6.035218] usb-storage: device scan complete
[    6.035675] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0 
  0100 PQ: 0 ANSI: 0
[    6.042393] calling  17_sd_probe_async+0x0/0x250 @ 1436
[    6.555027] sd 2:0:0:0: [sdc] 15661056 512-byte hardware sectors: 
(8.01 GB/7.46 GiB)
[    6.555507] sd 2:0:0:0: [sdc] Write Protect is on
[    6.555512] sd 2:0:0:0: [sdc] Mode Sense: 03 00 80 00
[    6.555516] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    6.557135] sd 2:0:0:0: [sdc] 15661056 512-byte hardware sectors: 
(8.01 GB/7.46 GiB)
[    6.557653] sd 2:0:0:0: [sdc] Write Protect is on
[    6.557658] sd 2:0:0:0: [sdc] Mode Sense: 03 00 80 00
[    6.557663] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    6.557746]  sdc: sdc1 sdc2
[    6.560603] sd 2:0:0:0: [sdc] Attached SCSI removable disk
[    6.560618] initcall 17_sd_probe_async+0x0/0x250 returned 0 after 
506065 usecs
[   10.967884] warning: `avahi-daemon' uses 32-bit capabilities (legacy 
support in use)
[   12.242904] atl2 0000:03:00.0: irq 284 for MSI/MSI-X
[   35.712381] kjournald starting.  Commit interval 5 seconds
[   35.712412] EXT3-fs: mounted filesystem with ordered data mode.
[   40.411827] wlan0: authenticate with AP 00:0f:b5:cc:c9:36
[   40.413427] wlan0: authenticated
[   40.413437] wlan0: associate with AP 00:0f:b5:cc:c9:36
[   40.415763] wlan0: RX AssocResp from 00:0f:b5:cc:c9:36 (capab=0x431 
status=0 aid=2)
[   40.415770] wlan0: associated
