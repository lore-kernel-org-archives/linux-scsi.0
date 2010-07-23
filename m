From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug 16449] New: can't watch dvd using pata-ali or ata-generic
Date: Fri, 23 Jul 2010 12:49:03 -0700
Message-ID: <20100723124903.1d8d4e2c.akpm@linux-foundation.org>
References: <bug-16449-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bug-16449-11613@https.bugzilla.kernel.org/>
Sender: linux-ide-owner@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(cc linux-ide)

On Fri, 23 Jul 2010 19:17:17 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=16449
> 
>            Summary: can't watch dvd using pata-ali or ata-generic
>            Product: SCSI Drivers
>            Version: 2.5
>     Kernel Version: 2.6.35
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>         AssignedTo: scsi_drivers-other@kernel-bugs.osdl.org
>         ReportedBy: paulatgm@gmail.com
>         Regression: No
> 
> 
> I'm trying to use my old toshiba laptop with more recent kernels to watch dvd's
> and the dvd is jerky and drops frames.  Basically unusable.
> 
> I have an older ubuntu 8.04.4 with the older kernel 2.6.24 that plays fine.  It
> uses the older ide-core / ata-generic series kernel modules.
> 
> I have tried to upgrade to newer versions of ubuntu, and all fail to be able to
> watch dvd's.  All use the newer pata-ali kernel module.
> 
> I recently tried the 2.6.35-9 kernel and have the same bad experience with the
> pata-ali module.  Here's the relevent dmesg messages:
> 
> [    0.000000] Linux version 2.6.35-9-generic (buildd@samarium) (gcc version
> 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #14~lucid1-Ubuntu SMP Sun Jul 18 13:11:45 UTC
> 2010 (Ubuntu 2.6.35-9.14~lucid1-generic 2.6.35-rc5)
> 
> [    0.550305] pata_acpi 0000:00:04.0: can't derive routing for PCI INT A
> [    0.550881] pata_acpi 0000:00:04.0: can't derive routing for PCI INT A
> 
> [    3.750815] pata_ali 0000:00:04.0: can't derive routing for PCI INT A
> [    3.770182] scsi0 : pata_ali
> [    3.782889] scsi1 : pata_ali
> [    3.786157] ata1: PATA max UDMA/66 cmd 0x1f0 ctl 0x3f6 bmdma 0xeff0 irq 14
> [    3.786283] ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xeff8 irq 15
> [    4.468712] ata1.00: ATA-5: TOSHIBA MK1017GAP, A4.03 A, max UDMA/66
> [    4.468832] ata1.00: 19640880 sectors, multi 16: LBA 
> [    4.468977] ata1.00: limited to UDMA/33 due to 40-wire cable
> [    4.476497] ata1.00: configured for UDMA/33
> [    4.477164] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1017GA A4.0
> PQ: 0 ANSI: 5
> [    4.478003] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    4.478862] sd 0:0:0:0: [sda] 19640880 512-byte logical blocks: (10.0
> GB/9.36 GiB)
> [    4.479335] sd 0:0:0:0: [sda] Write Protect is off
> [    4.479425] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    4.479587] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    4.482837]  sda:
> [    4.656584] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
> [    4.672480] ata2.00: configured for UDMA/33
> [    4.675653] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 1313
> PQ: 0 ANSI: 5
> [    4.685925] sr0: scsi3-mmc drive: 24x/24x cd/rw xa/form2 cdda tray
> [    4.686051] Uniform CD-ROM driver Revision: 3.20
> [    4.690262] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [    4.692657] sr 1:0:0:0: Attached scsi generic sg1 type 5
> 
> 
> I found a bug report at ubuntu (#228302) where other people had tried
> blacklisting the pata-ali module and using the ata_generic instead.  I wanted
> to try this to see if dvd playback would improve, but could not get it to work.
> 
> The bootup took a lot longer than normal, and when I tried to access the dvd,
> it failed with a time out message.  I could not get it to mount or to play
> dvd's under mplayer or other player software.
> 
> When I booted up with the ata_generic enabled, I noticed these ata related
> messages:
> 
> [    0.000000] Linux version 2.6.35-9-generic (buildd@samarium) (gcc version
> 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #14~lucid1-Ubuntu SMP Sun Jul 18 13:11:45 UTC
> 2010 (Ubuntu 2.6.35-9.14~lucid1-generic 2.6.35-rc5)
> 
> [    0.554122] pata_acpi 0000:00:04.0: can't derive routing for PCI INT A
> [    0.554763] pata_acpi 0000:00:04.0: can't derive routing for PCI INT A
> [    0.555136] ata_generic 0000:00:04.0: can't derive routing for PCI INT A
> [    0.560295] scsi0 : ata_generic
> [    0.561132] scsi1 : ata_generic
> [    0.563429] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xeff0 irq 14
> [    0.563558] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xeff8 irq 15
> 
> [    1.212796] ata1.00: ATA-5: TOSHIBA MK1017GAP, A4.03 A, max UDMA/66
> [    1.212907] ata1.00: 19640880 sectors, multi 16: LBA 
> [    1.213048] ata1.00: configured for UDMA/66
> [    1.214383] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK1017GA A4.0
> PQ: 0 ANSI: 5
> [    1.215692] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    1.217201] sd 0:0:0:0: [sda] 19640880 512-byte logical blocks: (10.0
> GB/9.36 GiB)
> [    1.217802] sd 0:0:0:0: [sda] Write Protect is off
> [    1.217899] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    1.220893] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> [    1.222768]  sda:
> [    1.397792] ata2.00: ATAPI: TOSHIBA DVD-ROM SD-C2502, 1313, max UDMA/33
> [    1.398060] ata2.00: configured for UDMA/33
> [    1.636857]  sda1 sda2 < sda5 sda6 sda7 >
> [    1.706255] sd 0:0:0:0: [sda] Attached SCSI disk
> [    2.057252] Freeing initrd memory: 8320k freed
> [   22.880145] ata2: lost interrupt (Status 0x58)
> [   22.884024] ata2: drained 65536 bytes to clear DRQ.
> [   22.940402] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [   22.940504] scsi 1:0:0:0: CDB: Inquiry: 12 00 00 00 60 00
> [   22.940974] ata2.00: cmd a0/01:00:00:60:00/00:00:00:00:00/a0 tag 0 dma 96 in
> [   22.940980]          res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [   22.941161] ata2.00: status: { DRDY }
> [   22.941266] ata2: soft resetting link
> [   23.128778] ata2.00: configured for UDMA/33
> [   23.129642] ata2: EH complete
> [   43.872106] ata2: lost interrupt (Status 0x58)
> [   43.876025] ata2: drained 65536 bytes to clear DRQ.
> [   43.932386] ata2.00: limiting speed to UDMA/133:PIO6
> [   43.932477] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [   43.932577] scsi 1:0:0:0: CDB: Inquiry: 12 00 00 00 60 00
> [   43.933048] ata2.00: cmd a0/01:00:00:60:00/00:00:00:00:00/a0 tag 0 dma 96 in
> [   43.933054]          res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [   43.933236] ata2.00: status: { DRDY }
> [   43.933354] ata2: soft resetting link
> [   44.112685] ata2.00: configured for UDMA/33
> [   44.113571] ata2: EH complete
> [   64.864107] ata2: lost interrupt (Status 0x58)
> [   64.868024] ata2: drained 65536 bytes to clear DRQ.
> [   64.924393] ata2.00: limiting speed to UDMA/33:PIO6
> [   64.924481] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [   64.924580] scsi 1:0:0:0: CDB: Inquiry: 12 00 00 00 60 00
> [   64.925049] ata2.00: cmd a0/01:00:00:60:00/00:00:00:00:00/a0 tag 0 dma 96 in
> [   64.925054]          res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [   64.925235] ata2.00: status: { DRDY }
> [   64.925340] ata2: soft resetting link
> [   64.925340] ata2: soft resetting link
> [   65.104636] ata2.00: configured for UDMA/33
> [   65.105454] ata2: EH complete
> [   85.856144] ata2: lost interrupt (Status 0x58)
> [   85.860029] ata2: drained 65536 bytes to clear DRQ.
> [   85.916425] ata2.00: limiting speed to PIO6
> [   85.916511] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [   85.916611] scsi 1:0:0:0: CDB: Inquiry: 12 00 00 00 60 00
> [   85.917078] ata2.00: cmd a0/01:00:00:60:00/00:00:00:00:00/a0 tag 0 dma 96 in
> [   85.917084]          res 40/00:02:00:24:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [   85.917265] ata2.00: status: { DRDY }
> [   85.917372] ata2: soft resetting link
> [   86.096633] ata2.00: configured for UDMA/33
> [   86.097548] ata2: EH complete
> [   86.097696] scsi scan: 96 byte inquiry failed.  Consider BLIST_INQUIRY_36
> for this device
> [   86.099133] scsi 1:0:0:0: CD-ROM            TOSHIBA  DVD-ROM SD-C2502 1313
> PQ: 0 ANSI: 5
> [  116.832137] ata2: lost interrupt (Status 0x58)
> [  116.836024] ata2: drained 65536 bytes to clear DRQ.
> [  116.892446] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [  116.892547] sr 1:0:0:0: CDB: Mode Sense(10): 5a 00 2a 00 00 00 00 00 80 00
> [  116.893187] ata2.00: cmd a0/01:00:00:80:00/00:00:00:00:00/a0 tag 0 dma 16512
> in
> [  116.893192]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [  116.893391] ata2.00: status: { DRDY }
> [  116.893501] ata2: soft resetting link
> [  117.096652] ata2.00: configured for UDMA/33
> [  117.097492] ata2: EH complete
> [  147.936122] ata2: lost interrupt (Status 0x58)
> [  147.940025] ata2: drained 65536 bytes to clear DRQ.
> [  147.996432] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [  147.996531] sr 1:0:0:0: CDB: Mode Sense(10): 5a 00 2a 00 00 00 00 00 80 00
> [  147.997168] ata2.00: cmd a0/01:00:00:80:00/00:00:00:00:00/a0 tag 0 dma 16512
> in
> [  147.997173]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [  147.997373] ata2.00: status: { DRDY }
> [  147.997486] ata2: soft resetting link
> [  148.176646] ata2.00: configured for UDMA/33
> [  148.177418] ata2: EH complete
> [  178.912125] ata2: lost interrupt (Status 0x58)
> [  178.916024] ata2: drained 65536 bytes to clear DRQ.
> [  178.972500] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [  178.972596] sr 1:0:0:0: CDB: Mode Sense(10): 5a 00 2a 00 00 00 00 00 80 00
> [  178.973232] ata2.00: cmd a0/01:00:00:80:00/00:00:00:00:00/a0 tag 0 dma 16512
> in
> [  178.973237]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [  178.973437] ata2.00: status: { DRDY }
> [  178.973554] ata2: soft resetting link
> [  179.152650] ata2.00: configured for UDMA/33
> [  179.153530] ata2: EH complete
> [  209.888148] ata2: lost interrupt (Status 0x58)
> [  209.892025] ata2: drained 65536 bytes to clear DRQ.
> [  209.948425] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [  209.948525] sr 1:0:0:0: CDB: Mode Sense(10): 5a 00 2a 00 00 00 00 00 80 00
> [  209.949162] ata2.00: cmd a0/01:00:00:80:00/00:00:00:00:00/a0 tag 0 dma 16512
> in
> [  209.949168]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [  209.949365] ata2.00: status: { DRDY }
> [  209.949467] ata2: soft resetting link
> [  210.128589] ata2.00: configured for UDMA/33
> [  210.129331] ata2: EH complete
> [  210.129443] sr0: scsi-1 drive
> [  210.129518] Uniform CD-ROM driver Revision: 3.20
> [  210.132388] sr 1:0:0:0: Attached scsi CD-ROM sr0
> [  210.132950] sr 1:0:0:0: Attached scsi generic sg1 type 5
> [  210.133647] Freeing unused kernel memory: 684k freed
> [  210.142025] Write protecting the kernel text: 4944k
> [  210.142285] Write protecting the kernel read-only data: 2016k
> [  210.310649] udev: starting version 151
> [  211.693067] Floppy drive(s): fd0 is 1.44M
> [  211.722016] FDC 0 is a post-1991 82077
> [  212.838085] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts:
> (null)
> [  217.824138] ata2: lost interrupt (Status 0x58)
> [  217.828030] ata2: drained 65536 bytes to clear DRQ.
> [  217.884599] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [  217.884714] sr 1:0:0:0: [sr0] CDB: Inquiry: 12 00 00 00 fe 00
> [  217.885182] ata2.00: cmd a0/01:00:00:fe:00/00:00:00:00:00/a0 tag 0 dma 16640
> in
> [  217.885188]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [  217.885387] ata2.00: status: { DRDY }
> [  217.885498] ata2: soft resetting link
> [  218.088730] ata2.00: configured for UDMA/33
> [  218.089575] ata2: EH complete
> 
> 
> [  235.840257] ata2: lost interrupt (Status 0x58)
> [  235.844062] ata2: drained 65536 bytes to clear DRQ.
> [  235.900533] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [  235.900557] sr 1:0:0:0: [sr0] CDB: Inquiry: 12 00 00 00 fe 00
> [  235.900593] ata2.00: cmd a0/01:00:00:fe:00/00:00:00:00:00/a0 tag 0 dma 16640
> in
> [  235.900599]          res 40/00:03:00:00:00/00:00:00:00:00/a0 Emask 0x4
> (timeout)
> [  235.900611] ata2.00: status: { DRDY }
> [  235.900645] ata2: soft resetting link
> [  236.080803] ata2.00: configured for UDMA/33
> [  236.081595] ata2: EH complete
> 
> Just for comparison, following are the relevant pages from the 2.6.24 kernel:
> 
> [    0.000000] Linux version 2.6.24-28-generic (buildd@rothera) (gcc version
> 4.2.4 (Ubuntu 4.2.4-1ubuntu4)) #1 SMP Fri Jun 18 12:02:15 UTC 2010 (Ubuntu
> 2.6.24-28.71-generic)
> 
> [ 1399.542690] ACPI: Unable to derive IRQ for device 0000:00:04.0
> [ 1399.542899] ACPI: Unable to derive IRQ for device 0000:00:04.0
> [ 1399.735610] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
> [ 1399.741476] ide: Assuming 33MHz system bus speed for PIO modes; override
> with idebus=xx
> [ 1399.749901] Floppy drive(s): fd0 is 1.44M
> [ 1399.768554] FDC 0 is a post-1991 82077
> [ 1399.768909] ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc3) at  PCI slot
> 0000:00:04.0
> [ 1399.768945] ACPI: Unable to derive IRQ for device 0000:00:04.0
> [ 1399.768978] ALI15X3: not 100% native mode: will probe irqs later
> [ 1399.769028] ALI15X3: simplex device: DMA forced
> [ 1399.769043]     ide0: BM-DMA at 0xeff0-0xeff7, BIOS settings: hda:DMA,
> hdb:pio
> [ 1399.769081]     ide1: BM-DMA at 0xeff8-0xefff, BIOS settings: hdc:DMA,
> hdd:pio
> [ 1399.769113] Probing IDE interface ide0...
> [ 1400.731125] hda: TOSHIBA MK1017GAP, ATA DISK drive
> [ 1400.731294] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> [ 1400.731399] hda: host side 80-wire cable detection failed, limiting max
> speed to UDMA33
> [ 1400.731407] hda: UDMA/33 mode selected
> [ 1400.731573] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
> [ 1401.080084] Probing IDE interface ide1...
> [ 1402.485073] hdc: TOSHIBA DVD-ROM SD-C2502, ATAPI CD/DVD-ROM drive
> [ 1402.485227] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> [ 1402.485594] hdc: UDMA/33 mode selected
> [ 1402.486533] ide1 at 0x170-0x177,0x376 on irq 15
> [ 1402.544664] hda: max request size: 128KiB
> [ 1402.550443] hda: 19640880 sectors (10056 MB), CHS=19485/16/63
> [ 1402.550462] hda: cache flushes not supported
> [ 1402.550589]  hda: hda1 hda2 hda3 hda4
> [ 1402.655717]  hda4: <bsd: hda5 hda6 >
> [ 1402.680781] hdc: ATAPI 24X DVD-ROM drive, 128kB Cache
> [ 1402.680813] Uniform CD-ROM driver Revision: 3.20
> 
> My questions are:
> 
> 1. Is there something else I can try to get better ata performance on newer
> linux kernels (so I can watch dvd's)?
> 
> 2. If I'm supposed to use the ata_generic module, how can I deal with the
> message "Consider BLIST_INQUIRY_36 for this device" and get it working.
> 
> If you need more information about my hardware, I can supply it.  Let me know. 
> Following is the lspci -vvv and lspci -n output:
> 
> 00:00.0 Host bridge: ALi Corporation M1644/M1644T Northbridge+Trident (rev 01)
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort+ >SERR- <PERR+
>     Latency: 0
>     Region 0: Memory at f0000000 (32-bit, prefetchable) [size=64M]
>     Capabilities: [b0] AGP version 2.0
>         Status: RQ=28 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
> FW- AGP3- Rate=x1,x2,x4
>         Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
>     Capabilities: [a4] Power Management version 1
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:01.0 PCI bridge: ALi Corporation PCI to AGP Controller (prog-if 00 [Normal
> decode])
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort-
> <MAbort- >SERR- <PERR-
>     Latency: 0
>     Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>     I/O behind bridge: 0000f000-00000fff
>     Memory behind bridge: f7f00000-fdffffff
>     Prefetchable memory behind bridge: 30000000-300fffff
>     Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort+ <SERR- <PERR+
>     BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
> 
> 00:02.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03) (prog-if 10
> [OHCI])
>     Subsystem: Toshiba America Info Systems Unknown device 0004
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR-
>     Latency: 64 (20000ns max), Cache Line Size: 32 bytes
>     Interrupt: pin A routed to IRQ 11
>     Region 0: Memory at f7eff000 (32-bit, non-prefetchable) [size=4K]
>     Capabilities: [60] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:04.0 IDE interface: ALi Corporation M5229 IDE (rev c3) (prog-if f0)
>     Subsystem: Toshiba America Info Systems Unknown device 0004
>     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR-
>     Latency: 64 (500ns min, 1000ns max)
>     Interrupt: pin A routed to IRQ 255
>     Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
> [disabled] [size=8]
>     Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
> [disabled] [size=1]
>     Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
> [disabled] [size=8]
>     Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
> [disabled] [size=1]
>     Region 4: I/O ports at eff0 [size=16]
>     Capabilities: [60] Power Management version 2
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:06.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link
> Controller Audio Device (rev 01)
>     Subsystem: Toshiba America Info Systems Unknown device 0001
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR+ <PERR+
>     Latency: 64 (500ns min, 6000ns max)
>     Interrupt: pin A routed to IRQ 11
>     Region 0: I/O ports at 1000 [size=256]
>     Region 1: Memory at 30100000 (32-bit, non-prefetchable) [size=4K]
>     Capabilities: [dc] Power Management version 2
>         Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2+,D3hot+,D3cold+)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:07.0 ISA bridge: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin
> IV/V/V+]
>     Subsystem: Toshiba America Info Systems Unknown device 0004
>     Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR-
>     Latency: 0
>     Capabilities: [a0] Power Management version 1
>         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:08.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
>     Subsystem: Toshiba America Info Systems Unknown device 0001
>     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR-
> 
> 00:11.0 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbus
> Bridge with ZV Support (rev 32)
>     Subsystem: Toshiba America Info Systems Unknown device 0001
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort-
> <MAbort- >SERR- <PERR-
>     Latency: 168
>     Interrupt: pin A routed to IRQ 11
>     Region 0: Memory at 30101000 (32-bit, non-prefetchable) [size=4K]
>     Bus: primary=00, secondary=02, subordinate=05, sec-latency=0
>     Memory window 0: 20000000-23fff000 (prefetchable)
>     Memory window 1: 24000000-27fff000
>     I/O window 0: 00001400-000014ff
>     I/O window 1: 00001800-000018ff
>     BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
>     16-bit legacy interface ports at 0001
> 
> 00:11.1 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbus
> Bridge with ZV Support (rev 32)
>     Subsystem: Toshiba America Info Systems Unknown device 0001
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=slow >TAbort- <TAbort-
> <MAbort- >SERR- <PERR-
>     Latency: 168
>     Interrupt: pin B routed to IRQ 11
>     Region 0: Memory at 30102000 (32-bit, non-prefetchable) [size=4K]
>     Bus: primary=00, secondary=06, subordinate=09, sec-latency=0
>     Memory window 0: 28000000-2bfff000 (prefetchable)
>     Memory window 1: 2c000000-2ffff000
>     I/O window 0: 00001c00-00001cff
>     I/O window 1: 00002000-000020ff
>     BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
>     16-bit legacy interface ports at 0001
> 
> 01:00.0 VGA compatible controller: Trident Microsystems CyberBlade XPAi1 (rev
> 82) (prog-if 00 [VGA controller])
>     Subsystem: Toshiba America Info Systems Unknown device 0001
>     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B-
>     Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
> <MAbort- >SERR- <PERR-
>     Latency: 8
>     Interrupt: pin A routed to IRQ 11
>     Region 0: Memory at fc000000 (32-bit, non-prefetchable) [size=32M]
>     Region 1: Memory at fbc00000 (32-bit, non-prefetchable) [size=4M]
>     Region 2: Memory at f8000000 (32-bit, non-prefetchable) [size=32M]
>     Region 3: Memory at f7ff8000 (32-bit, non-prefetchable) [size=32K]
>     [virtual] Expansion ROM at 30000000 [disabled] [size=64K]
>     Capabilities: [80] AGP version 2.0
>         Status: RQ=33 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit-
> FW- AGP3- Rate=x1,x2,x4
>         Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
>     Capabilities: [90] Power Management version 2
>         Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>         Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:00.0 0600: 10b9:1644 (rev 01)
> 00:01.0 0604: 10b9:5247
> 00:02.0 0c03: 10b9:5237 (rev 03)
> 00:04.0 0101: 10b9:5229 (rev c3)
> 00:06.0 0401: 10b9:5451 (rev 01)
> 00:07.0 0601: 10b9:1533
> 00:08.0 0680: 10b9:7101
> 00:11.0 0607: 1179:0617 (rev 32)
> 00:11.1 0607: 1179:0617 (rev 32)
> 01:00.0 0300: 1023:8820 (rev 82)
> 

