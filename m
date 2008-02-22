From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LSI Logic MegaRAID SATA 150-4 / LSI Logic New Generation RAID
 Device Drivers (MEGARAID_NEWGEN) problems (megaraid abort: scsi cmd:14600,
 do now own)
Date: Fri, 22 Feb 2008 00:13:44 -0800
Message-ID: <20080222001344.b5c41b75.akpm@linux-foundation.org>
References: <47BA3A52.3020106@shellpower.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1765206AbYBVIO7@vger.kernel.org>
In-Reply-To: <47BA3A52.3020106@shellpower.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-kernel@vger.kernel.org, Bo Yang <bo.yang@lsi.com>, Sumant Patro <sumant.patro@lsi.com>, "Kolli, Neela Syam" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(cc's added)

On Mon, 18 Feb 2008 21:09:22 -0500 "David M. Strang" <dstrang@shellpower.net> wrote:

> Greetings -
> 
> A couple months back I purchased a LSI Logic MegaRAID ATA 150-4 
> controller, as well as 3 Seagate 500GB SATA-II hard drives to use in my 
> system. Previously, I was using a pair of WD4000YR's in software raid, 
> which seemed to work well. I've just not gotten around to working on 
> migrating my data to these new drivers + controller, and it's giving me 
> some issues. As with most, I'm having some severe performance issues, 
> the performance is simply abysmal. Before getting into the details, here 
> is a quick overview of my configuration:
> 
> System:
> Tyan Tiger i7320/R (S5350) System Board
> 2x Intel Xeon 3.0 GHz
> 4GB RAM
> 
> LSI Logic MegaRAID ATA 150-4 controller -  Firmware Revision: 713S
> 3x Seagate 7200.10 (Perpendicular Recording) ST3500630AS 500GB SATA-II 
> drives configured as a RAID-1 array with a HotSpare.
> 
> Also, connected to the onboard controller is a WD4000YR, where all of my 
> data currently resides.
> 
> I'm running Gentoo Hardended AMD64 MultiLib 
> (/usr/portage/profiles/hardened/amd64/multilib)
> 
> My current kernel revision is 2.6.23-hardened-r7.
> 
> Here are some (possibly) relevant snippets from dmesg during startup:
> 
> ...
> megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
> megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
> megaraid: probe new device 0x1000:0x1960:0x1000:0x4523: bus 3:slot 3:func 0
> ACPI: PCI Interrupt 0000:03:03.0[A] -> GSI 24 (level, low) -> IRQ 24
> megaraid: fw version:[713S] bios version:[G121]
> scsi0 : LSI Logic MegaRAID driver
> scsi[0]: scanning scsi channel 0 [Phy 0] for non-raid devices
> scsi[0]: scanning scsi channel 1 [virtual] for logical drives
> scsi 0:1:0:0: Direct-Access     MegaRAID LD 0 RAID1  476G 713S PQ: 0 ANSI: 2
> sd 0:1:0:0: [sda] 976762880 512-byte hardware sectors (500103 MB)
> sd 0:1:0:0: [sda] Write Protect is off
> sd 0:1:0:0: [sda] Mode Sense: 00 00 00 00
> sd 0:1:0:0: [sda] Asking for cache data failed
> sd 0:1:0:0: [sda] Assuming drive cache: write through
> sd 0:1:0:0: [sda] 976762880 512-byte hardware sectors (500103 MB)
> sd 0:1:0:0: [sda] Write Protect is off
> sd 0:1:0:0: [sda] Mode Sense: 00 00 00 00
> sd 0:1:0:0: [sda] Asking for cache data failed
> sd 0:1:0:0: [sda] Assuming drive cache: write through
>  sda: sda1 sda2 sda3 sda4
> sd 0:1:0:0: [sda] Attached SCSI disk
> ata_piix 0000:00:1f.2: version 2.12
> ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
> ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> scsi1 : ata_piix
> scsi2 : ata_piix
> ata1: SATA max UDMA/133 cmd 0x00000000000114a0 ctl 0x000000000001149a 
> bmdma 0x0000000000011470 irq 18
> ata2: SATA max UDMA/133 cmd 0x0000000000011490 ctl 0x0000000000011486 
> bmdma 0x0000000000011478 irq 18
> ata1.00: ATA-7: WDC WD4000YR-01PLB0, 01.06A01, max UDMA/133
> ata1.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata1.00: configured for UDMA/133
> scsi 1:0:0:0: Direct-Access     ATA      WDC WD4000YR-01P 01.0 PQ: 0 ANSI: 5
> sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
> sd 1:0:0:0: [sdb] Write Protect is off
> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 1:0:0:0: [sdb] 781422768 512-byte hardware sectors (400088 MB)
> sd 1:0:0:0: [sdb] Write Protect is off
> sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
>  sdb: sdb1 sdb2 sdb3 sdb4
> sd 1:0:0:0: [sdb] Attached SCSI disk
> ...
> 
> My controller is configured for Write Back Caching, Adaptive Read Ahead, 
> and Direct I/O (I've also tried cached I/O but it scared me...)
> 
> The first thing I'm noticing is the horrible performance on the raid 
> disk, compared to the single standalone hard disk. Here is the output 
> from hdparm -tT on the single disk:
> 
> -(root@server)-(~)- # hdparm -tT /dev/sdb1
> 
> /dev/sdb1:
>  Timing cached reads:   1670 MB in  2.00 seconds = 835.00 MB/sec
>  Timing buffered disk reads:  140 MB in  3.01 seconds =  46.45 MB/sec
> 
> And then, the output from the raid-1 array:
> 
> -(root@server)-(~)- # hdparm -tT /dev/sda1
> 
> /dev/sda1:
>  Timing cached reads:   1718 MB in  2.00 seconds = 859.65 MB/sec
>  Timing buffered disk reads:   92 MB in  3.09 seconds =  29.76 MB/sec
> 
> I'm not sure what the deal is with the buffered disk reads being so much 
> WORSE than a single disk. So poor performance is a concern, but what's 
> more alarming are the messages showing up in DMESG. When I first tried 
> Cached IO - performance seemed good... except, dmesg was littered with 
> these errors (?):
> 
> megaraid: aborting-14610 cmd=2a <c=1 t=0 l=0>
> megaraid abort: scsi cmd:14610, do now own
> megaraid: aborting-14612 cmd=2a <c=1 t=0 l=0>
> megaraid abort: scsi cmd:14612, do now own
> megaraid: aborting-14614 cmd=2a <c=1 t=0 l=0>
> megaraid abort: scsi cmd:14614, do now own
> ...
> megaraid: 38 outstanding commands. Max wait 300 sec
> megaraid mbox: Wait for 38 commands to complete:300
> megaraid mbox: reset sequence completed sucessfully
> 
> I'm not certain what these mean... why am I getting aborts?
> 
> So, I rebooted the box - and I switched back to direct I/O instead of 
> cached... and while not as prevelant as before, I still get the above 
> listed errors as well as these ones:
> 
> megaraid abort: 14687:62[255:128], fw owner
> megaraid: aborting-14689 cmd=2a <c=1 t=0 l=0>
> megaraid abort: 14689:25[255:128], fw owner
> megaraid: aborting-14691 cmd=2a <c=1 t=0 l=0>
> megaraid abort: 14691:40[255:128], fw owner
> megaraid: aborting-14693 cmd=2a <c=1 t=0 l=0>
> megaraid abort: 14693:10[255:128], fw owner
> megaraid: aborting-14695 cmd=2a <c=1 t=0 l=0>
> megaraid abort: 14695:9[255:128], fw owner
> 
> 
> I'm also a bit concerned by the dmesg output from the drive 
> initialization; I have it set for Write Back caching, but this shows up:
> 
> sd 0:1:0:0: [sda] Asking for cache data failed
> sd 0:1:0:0: [sda] Assuming drive cache: write through
> 
> Why?
> 
> I would really like to get my data over to my hardware mirror, but 
> frankly - I'm nervous about this controller's behavior. Other than error 
> messages in dmesg, and high cpu during file i/o -- it SEEMS ok, but is 
> it really? I somehow don't think I should be getting these types of 
> messages. I've searched the list archive, and I see similar messages 
> follow by failed resets, but my reset sequence always completes 
> successfully.
> 
> Regards,
> David M. Strang
