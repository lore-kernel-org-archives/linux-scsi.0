From: Horms <horms@debian.org>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Tue, 8 Nov 2005 12:31:21 +0900
Message-ID: <20051108033118.GL3413@verge.net.au>
References: <20051108024523.35622.qmail@web88006.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from koto.vergenet.net ([210.128.90.7]:51675 "EHLO koto.vergenet.net")
	by vger.kernel.org with ESMTP id S932344AbVKHDej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2005 22:34:39 -0500
Content-Disposition: inline
In-Reply-To: <20051108024523.35622.qmail@web88006.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Graham Knap <graham.knap@rogers.com>, 338089@bugs.debian.org
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Mon, Nov 07, 2005 at 09:45:23PM -0500, Graham Knap wrote:
> Package: linux-image-2.6.14-1-686
> Version: 2.6.14-2
> 
> Recent versions of the aic7xxx driver will not boot on my secondary PC.
> The 2.6.8 kernel shipped with sarge works perfectly, but neither the
> 2.6.12 kernel in testing nor the 2.6.14 kernel in unstable will boot.
> 
> This is an older system: 
> Asus P2L-B, Celeron 500MHz, 384MB RAM, GeForce2 MX AGP
> Adaptec 2940UW, IBM DDYS-T09170 (9GB disk)
> 
> I can't understand what exactly is failing, but I will attach a boot
> log. (So null modem cables *are* still useful for something!)
> 
> I've tried adding "aic7xxx=dv:{0}" to the boot arguments but that
> doesn't seem to make a difference. Also, "aic7xxx=verbose" doesn't seem
> to do anything either.
> 
> I don't know if this makes a difference but my 2940UW reports its BIOS
> revision as "1.34.3" during POST.
> 
> Any help would be much appreciated.

Hi Graham, 

thanks for your detailed report. This does smell a lot like a driver
bug, and as such, its proably best passed onto the upstream maintainers.
As such I've CCed James Bottomley and linux-scsi for comment.

The other main possiblility, is that perhaps the aic7xxx_old driver would
work. Or perhaps some other module loading foo, though its seems the
module is loaded fine, it just doesn't like your card very much.

Content-Description: 2066060778-bootlog-2.6.14.txt
> Linux version 2.6.14-1-686 (Debian 2.6.14-2) (horms@debian.org) (gcc version 4.0.3 20051023 (prerelease) (Debian 4.0.2-3)) #1 Tue Nov 1 15:51:43 JST 2005
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000017ffd000 (usable)
>  BIOS-e820: 0000000017ffd000 - 0000000017fff000 (ACPI data)
>  BIOS-e820: 0000000017fff000 - 0000000018000000 (ACPI NVS)
>  BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
> 0MB HIGHMEM available.
> 383MB LOWMEM available.
> DMI 2.0 present.
> ACPI: PM-Timer IO Port: 0xe408
> Allocating PCI resources starting at 20000000 (gap: 18000000:e7ff0000)
> Built 1 zonelists
> Kernel command line: root=/dev/sda3 ro single console=tty0 console=ttyS1,38400n8
> Local APIC disabled by BIOS -- you can enable it with "lapic"
> Initializing CPU#0
> PID hash table entries: 2048 (order: 11, 32768 bytes)
> Detected 501.254 MHz processor.
> Using pmtmr for high-res timesource
> Console: colour VGA+ 80x25
> Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> Memory: 385200k/393204k available (1803k kernel code, 7432k reserved, 512k data, 180k init, 0k highmem)
> Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Calibrating delay using timer specific routine.. 1002.82 BogoMIPS (lpj=501412)
> Security Framework v1.0.0 initialized
> SELinux:  Disabled at boot.
> Capability LSM initialized
> Mount-cache hash table entries: 512
> CPU: L1 I cache: 16K, L1 D cache: 16K
> CPU: L2 cache: 128K
> Intel machine check architecture supported.
> Intel machine check reporting enabled on CPU#0.
> mtrr: v2.0 (20020519)
> CPU: Intel Celeron (Mendocino) stepping 05
> Enabling fast FPU save and restore... done.
> Checking 'hlt' instruction... OK.
> ACPI: setting ELCR to 0200 (from 0a00)
> checking if image is initramfs... it is
> softlockup thread 0 started up.
> Freeing initrd memory: 1176k freed
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xf06d0, last bus=1
> PCI: Using configuration type 1
> ACPI: Subsystem revision 20050902
> ACPI: Interpreter enabled
> ACPI: Using PIC for interrupt routing
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Probing PCI hardware (bus 00)
> ACPI: Assume root bridge [\_SB_.PCI0] bus is 0
> PCI quirk: region e400-e43f claimed by PIIX4 ACPI
> PCI quirk: region e800-e81f claimed by PIIX4 SMB
> PIIX4 devres B PIO at 0290-0297
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> pnp: PnP ACPI: found 12 devices
> PnPBIOS: Disabled by ACPI PNP
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
> pnp: 00:01: ioport range 0xe400-0xe43f could not be reserved
> pnp: 00:01: ioport range 0xe800-0xe80f has been reserved
> pnp: 00:01: ioport range 0x294-0x297 has been reserved
> PCI: Bridge: 0000:00:01.0
>   IO window: disabled.
>   MEM window: d6000000-d7dfffff
>   PREFETCH window: d7f00000-e3ffffff
> Simple Boot Flag at 0x46 set to 0x1
> audit: initializing netlink socket (disabled)
> audit(1131398011.104:1): initialized
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> Initializing Cryptographic API
> Limiting direct PCI/PCI transfers.
> isapnp: Scanning for PnP cards...
> pnp: SB audio device quirk - increasing port range
> isapnp: Card 'Creative SB16 PnP'
> isapnp: 1 Plug & Play card detected total
> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
> serio: i8042 AUX port at 0x60,0x64 irq 12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
> ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> io scheduler noop registered
> io scheduler anticipatory registered
> io scheduler deadline registered
> io scheduler cfq registered
> RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
> NET: Registered protocol family 2
> IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> TCP established hash table entries: 16384 (order: 4, 65536 bytes)
> TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
> TCP: Hash tables configured (established 16384 bind 16384)
> TCP reno registered
> NET: Registered protocol family 8
> NET: Registered protocol family 20
> Using IPI Shortcut mode
> ACPI wakeup devices: 
> PCI0 UAR1 UAR2 PS2M USB0 
> ACPI: (supports S0 S1 S4 S5)
> Freeing unused kernel memory: 180k freed
> input: AT Translated Set 2 keyboard on isa0060/serio0
> mice: PS/2 mouse device common for all mice
> SCSI subsystem initialized
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
> PCI: setting IRQ 9 as level-triggered
> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 9 (level, low) -> IRQ 9
> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
>         <Adaptec 2940 Ultra SCSI adapter>
>         aic7880: Ultra Wide Channel A, SCSI Id=7, 16/253 SCBs
> 
>   Vendor: IBM       Model: DDYS-T09170N      Rev: S80D
>   Type:   Direct-Access                      ANSI SCSI revision: 03
> scsi0:A:0:0: Tagged Queuing enabled.  Depth 8
>  target0:0:0: Beginning Domain Validation
>  target0:0:0: wide asynchronous.
>  target0:0:0: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 8)
> scsi0:0:0:0: Attempting to queue an ABORT message
> CDB: 0x3b 0xa 0x0 0x0 0x0 0x0 0x0 0x2 0x39 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State in Data-out phase, at SEQADDR 0x84
> Card was paused
> ACCUM = 0x0, SINDEX = 0xb8, DINDEX = 0xa8, ARG_2 = 0xff
> HCNT = 0x0 SCBPTR = 0x0
> SCSISIGI[0x4]:(BSYI) ERROR[0x0] SCSIBUSL[0x8] LASTPHASE[0x0] 
> SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) SBLKCTL[0x2]:(SELWIDE) 
> SCSIRATE[0x88]:(WIDEXFER) SEQCTL[0x10]:(FASTMODE) 
> SEQ_FLAGS[0x20]:(DPHASE) SSTAT0[0x7]:(DMADONE|SPIORDY|SDONE) 
> SSTAT1[0x2]:(PHASECHG) SSTAT2[0x0] SSTAT3[0x0] 
> SIMODE0[0x0] SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
> SXFRCTL0[0xa8]:(SPIOEN|FAST20|DFON) DFCNTRL[0x4]:(DIRECTION) 
> DFSTATUS[0x6d]:(FIFOEMP|DFTHRESH|HDONE|FIFOQWDEMP|DFCACHETH) 
> STACK: 0x0 0x151 0x192 0x60
> SCB count = 4
> Kernel NEXTQSCB = 2
> Card NEXTQSCB = 2
> QINFIFO entries: 
> Waiting Queue entries: 
> Disconnected Queue entries: 
> QOUTFIFO entries: 
> Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 
> Sequencer SCB Info: 
>   0 SCB_CONTROL[0x68]:(ULTRAENB|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x80]:(SCB_XFERLEN_ODD) SCB_TAG[0x3] 
>   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
> Pending list: 
>   3 SCB_CONTROL[0x68]:(ULTRAENB|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
> Kernel Free SCB list: 1 0 
> 
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi0:0:0:0: Device is active, asserting ATN
> Recovery code sleeping
> Recovery code awake
> Timer Expired
> aic7xxx_abort returns 0x2003
> scsi0:0:0:0: Attempting to queue a TARGET RESET message
> CDB: 0x3b 0xa 0x0 0x0 0x0 0x0 0x0 0x2 0x39 0x0
> aic7xxx_dev_reset returns 0x2003
> Recovery SCB completes
> scsi0:0:0:0: Attempting to queue an ABORT message
> CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State while idle, at SEQADDR 0x157
> Card was paused
> ACCUM = 0x2, SINDEX = 0x20, DINDEX = 0xc0, ARG_2 = 0x0
> HCNT = 0x0 SCBPTR = 0x0
> SCSISIGI[0x14]:(BSYI|ATNI) ERROR[0x0] SCSIBUSL[0x8] 
> LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
> SBLKCTL[0x2]:(SELWIDE) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) 
> SEQ_FLAGS[0x40]:(NO_CDB_SENT) SSTAT0[0x5]:(DMADONE|SDONE) 
> SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x0] 
> SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
> SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION) 
> DFSTATUS[0x6d]:(FIFOEMP|DFTHRESH|HDONE|FIFOQWDEMP|DFCACHETH) 
> STACK: 0x37 0x0 0x151 0x192
> SCB count = 4
> Kernel NEXTQSCB = 3
> Card NEXTQSCB = 3
> QINFIFO entries: 
> Waiting Queue entries: 
> Disconnected Queue entries: 
> QOUTFIFO entries: 
> Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 
> Sequencer SCB Info: 
>   0 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] SCB_TAG[0x2] 
>   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
> Pending list: 
>   2 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] 
> Kernel Free SCB list: 1 0 
> 
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi0:0:0:0: Unable to deliver message
> aic7xxx_abort returns 0x2003
> scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
> scsi0 (0:0): rejecting I/O to offline device
>  target0:0:0: Write Buffer failure 10000
>  target0:0:0: Domain Validation detected failure, dropping back
> scsi0:0:0:0: Attempting to queue an ABORT message
> CDB: 0x3b 0xa 0x0 0x0 0x0 0x0 0x0 0x2 0x39 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State while idle, at SEQADDR 0x157
> Card was paused
> ACCUM = 0x2, SINDEX = 0x20, DINDEX = 0xc0, ARG_2 = 0x0
> HCNT = 0x0 SCBPTR = 0x0
> SCSISIGI[0x14]:(BSYI|ATNI) ERROR[0x0] SCSIBUSL[0x8] 
> LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
> SBLKCTL[0x2]:(SELWIDE) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) 
> SEQ_FLAGS[0x40]:(NO_CDB_SENT) SSTAT0[0x5]:(DMADONE|SDONE) 
> SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x0] 
> SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
> SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION) 
> DFSTATUS[0x6d]:(FIFOEMP|DFTHRESH|HDONE|FIFOQWDEMP|DFCACHETH) 
> STACK: 0x37 0x0 0x151 0x192
> SCB count = 4
> Kernel NEXTQSCB = 1
> Card NEXTQSCB = 3
> QINFIFO entries: 3 
> Waiting Queue entries: 
> Disconnected Queue entries: 
> QOUTFIFO entries: 
> Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 
> Sequencer SCB Info: 
>   0 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] SCB_TAG[0x2] 
>   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
> Pending list: 
>   3 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
>   2 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] 
> Kernel Free SCB list: 0 
> 
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi0:0:0:0: Cmd aborted from QINFIFO
> aic7xxx_abort returns 0x2002
> scsi0:0:0:0: Attempting to queue an ABORT message
> CDB: 0x0 0x0 0x0 0x0 0x0 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State while idle, at SEQADDR 0x157
> Card was paused
> ACCUM = 0x2, SINDEX = 0x20, DINDEX = 0xc0, ARG_2 = 0x0
> HCNT = 0x0 SCBPTR = 0x0
> SCSISIGI[0x14]:(BSYI|ATNI) ERROR[0x0] SCSIBUSL[0x8] 
> LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
> SBLKCTL[0x2]:(SELWIDE) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) 
> SEQ_FLAGS[0x40]:(NO_CDB_SENT) SSTAT0[0x5]:(DMADONE|SDONE) 
> SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x0] 
> SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
> SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION) 
> DFSTATUS[0x6d]:(FIFOEMP|DFTHRESH|HDONE|FIFOQWDEMP|DFCACHETH) 
> STACK: 0x37 0x0 0x151 0x192
> SCB count = 4
> Kernel NEXTQSCB = 3
> Card NEXTQSCB = 1
> QINFIFO entries: 1 
> Waiting Queue entries: 
> Disconnected Queue entries: 
> QOUTFIFO entries: 
> Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 
> Sequencer SCB Info: 
>   0 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] SCB_TAG[0x2] 
>   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
> Pending list: 
>   1 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] 
>   2 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] 
> Kernel Free SCB list: 0 
> 
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi0:0:0:0: Cmd aborted from QINFIFO
> aic7xxx_abort returns 0x2002
> scsi0:0:0:0: Attempting to queue a TARGET RESET message
> CDB: 0x3b 0xa 0x0 0x0 0x0 0x0 0x0 0x2 0x39 0x0
> scsi0: At time of recovery, card was not paused
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> scsi0: Dumping Card State while idle, at SEQADDR 0x157
> Card was paused
> ACCUM = 0x2, SINDEX = 0x20, DINDEX = 0xc0, ARG_2 = 0x0
> HCNT = 0x0 SCBPTR = 0x0
> SCSISIGI[0x14]:(BSYI|ATNI) ERROR[0x0] SCSIBUSL[0x8] 
> LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI) 
> SBLKCTL[0x2]:(SELWIDE) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE) 
> SEQ_FLAGS[0x40]:(NO_CDB_SENT) SSTAT0[0x5]:(DMADONE|SDONE) 
> SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x0] 
> SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
> SXFRCTL0[0x88]:(SPIOEN|DFON) DFCNTRL[0x4]:(DIRECTION) 
> DFSTATUS[0x6d]:(FIFOEMP|DFTHRESH|HDONE|FIFOQWDEMP|DFCACHETH) 
> STACK: 0x37 0x0 0x151 0x192
> SCB count = 4
> Kernel NEXTQSCB = 3
> Card NEXTQSCB = 3
> QINFIFO entries: 
> Waiting Queue entries: 
> Disconnected Queue entries: 
> QOUTFIFO entries: 
> Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 
> Sequencer SCB Info: 
>   0 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] SCB_TAG[0x2] 
>   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   2 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   3 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   4 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   5 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   6 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   7 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   8 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>   9 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  10 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  11 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  12 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
>  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) 
> SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
> Pending list: 
>   2 SCB_CONTROL[0x70]:(MK_MESSAGE|TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
> SCB_LUN[0x0] 
> Kernel Free SCB list: 1 0 
> 
> <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
> scsi0:0:0:0: Unable to deliver message
> aic7xxx_dev_reset returns 0x2003
> scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
>  target0:0:0: Write Buffer failure 20000
>  target0:0:0: Domain Validation detected failure, dropping back
>  target0:0:0: Write Buffer failure 10000
>  target0:0:0: Domain Validation detected failure, dropping back
>  target0:0:0: Write Buffer failure 10000
>  target0:0:0: Domain Validation detected failure, dropping back
>  target0:0:0: Write Buffer failure 10000
>  target0:0:0: Domain Validation detected failure, dropping back
>  target0:0:0: Write Buffer failure 10000
>  target0:0:0: Domain Validation detected failure, dropping back
>  target0:0:0: Write Buffer failure 10000
>  target0:0:0: Domain Validation detected failure, dropping back
>  target0:0:0: Write Buffer failure 10000
>  target0:0:0: Domain Validation detected failure, dropping back
>  target0:0:0: Write Buffer failure 10000
>  target0:0:0: Domain Validation Failure, dropping back to Asynchronous
>  target0:0:0: Ending Domain Validation
> sda : READ CAPACITY failed.
> sda : status=0, message=00, host=1, driver=00 
> sda : sense not available. 
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> sda : READ CAPACITY failed.
> sda : status=0, message=00, host=1, driver=00 
> sda : sense not available. 
> sda: asking for cache data failed
> sda: assuming drive cache: write through
>  sda:<6>sd 0:0:0:0: SCSI error: return code = 0x10000
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
> sd 0:0:0:0: SCSI error: return code = 0x10000
> end_request: I/O error, dev sda, sector 0
> Buffer I/O error on device sda, logical block 0
>  unable to read partition table
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> /bin/cat: /sys/block/sda/sda2/dev: No such file or directory
> Waiting 1 seconds for /sys/block/sda/sda2/dev to show up
> /bin/cat: /sys/block/sda/sda2/dev: No such file or directory
> Waiting 2 seconds for /sys/block/sda/sda2/dev to show up
> /bin/cat: /sys/block/sda/sda2/dev: No such file or directory
> Waiting 4 seconds for /sys/block/sda/sda2/dev to show up
> /bin/cat: /sys/block/sda/sda2/dev: No such file or directory
> Waiting 8 seconds for /sys/block/sda/sda2/dev to show up
> /bin/cat: /sys/block/sda/sda2/dev: No such file or directory
> Waiting 16 seconds for /sys/block/sda/sda2/dev to show up
> /bin/cat: /sys/block/sda/sda2/dev: No such file or directory
> Device /sys/block/sda/sda2/dev seems to be down.
> Debugging opportunity, type ^D to continue.
> /bin/dash: can't access tty; job control turned off
> # 


-- 
Horms
