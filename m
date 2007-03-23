From: thomas schorpp <t.schorpp@gmx.de>
Subject: Re: aic7xxx: aic7892(B): BUG: soft lockup detected on CPU#0!
Date: Fri, 23 Mar 2007 02:26:32 +0100
Message-ID: <46032CC8.6030307@gmx.de>
References: <46029D72.3060403@gmx.de> <4602B576.6020602@gmx.de> <4602EED5.5070503@gmx.de> <46030A9A.2060604@gmx.de>
Reply-To: t.schorpp@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60087 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934264AbXCWB0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 21:26:35 -0400
In-Reply-To: <46030A9A.2060604@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

ok, overriding the first while(ahc_is_paused) that blocked before 
(i see no sense for doing this in a pci mmap test function, cause 
proper resource setup is required *before* using such I/O functions, 
otherwise the adapter had entered SEQ paused status)
i got the kernel to boot at least at pio mode.

this is surely not the correct resource and looks like a datatype 
boundary overflow, the upper 0x0f is missing:
[   49.278810] Trying to free nonexistent resource <00000000fffff000-00000000fff
fffff>

ffff-f000

tom1:~# lspci -vvv -s 00:06.0
00:06.0 SCSI storage controller: Adaptec AIC-7892B U160/m (rev 02)
        Subsystem: Adaptec 19160 Ultra160 SCSI Controller
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Step
ping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 32 (10000ns min, 6250ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        BIST result: 00
        Region 0: I/O ports at d800 [size=256]
        Region 1: Memory at ffffff000 (64-bit, non-prefetchable) [disabled] [siz
e=4K]
        Expansion ROM at fbee0000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

000f-ffff-f000

but theres a platform issue somewhere in the code, affecting 
x86_64. maintainers, pls have a look, too, thx.


[   49.181771] Loading iSCSI transport class v2.0-724.
[   49.187129] iscsi: registered transport (tcp)
[   49.191491] ahc_linux_pci_init
[   49.194682] ahc_linux_pci_dev_probe
[   49.198221] ACPI: PCI Interrupt 0000:00:06.0[A] -> GSI 17 (level, low) -> IRQ
 17
[   49.205636] ahc_pci_config
[   49.208337] set_power_state
[   49.211131] map_registers
[   49.213748] ahc_pci_map_registers enter
[   49.217574] .read_config
[   49.220110] .reserve_mem
[   49.222649] .write_config_iferr0
[   49.225869] .test_registers_iferr0
[   49.229267] ahc_pci_test_register_access enter
[   49.233704] .read_config 116
[   49.236584] .write_config_noserr
[   49.239810] .hcnctrl
[   49.241998] .paused 0
[   49.244362] .write_config
[   49.246982] .write_config
[   49.249614] .fail scb_base
[   49.252321] .ending fail err 5
[   49.255368] .read_config
[   49.257901] .write_config
[   49.260523] .clrint
[   49.262622] .seqctl
[   49.264720] .write_config
[   49.267340] ahc_pci_test_register_access leave
[   49.271775] aic7xxx: PCI Device 0:6:0 failed memory mapped test.  Using PIO.
[   49.278810] Trying to free nonexistent resource <00000000fffff000-00000000fff
fffff>
[   49.286443] .reserve_io
[   49.288894] reserve_io_ok
[   49.291510] .write_config
[   49.294129] map_registers leave
[   49.297265] read_config
[   49.299710] write_config1
[   49.302330] write_config2
[   49.304951] softc_init
[   49.307329] ahc_reset
[   49.322446] ahc_init_core
[   49.325301] ahc_pci:0:6:0: hardware scb 64 bytes; kernel scb 104 bytes; ahc_d
ma 8 bytes
[   49.519047] ENINT
[   54.513224] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   54.513226]         <Adaptec 19160B Ultra160 SCSI adapter>
[   54.513227]         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   54.513228]
[   54.534992] Adaptec aacraid driver (1.1-5[2423]-mh3)
[   54.540128] st: Version 20070203, fixed bufsize 32768, s/g segs 256
[   54.546541] osst :I: Tape driver with OnStream support version 0.99.4
[   54.546542] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   54.560110] SCSI Media Changer driver v0.25
[   54.564798] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq
 1,12
[   54.572940] serio: i8042 KBD port at 0x60,0x64 irq 1
[   54.578075] serio: i8042 AUX port at 0x60,0x64 irq 12
[   54.583665] mice: PS/2 mouse device common for all mice
[   54.589185] md: linear personality registered for level -1
[   54.594682] md: raid0 personality registered for level 0
[   54.600011] md: raid1 personality registered for level 1
[   54.672826] raid6: int64x1   1865 MB/s
[   54.740694] raid6: int64x2   2508 MB/s
[   54.790668] (scsi0:A:0:0): Saw Selection Timeout for SCB 0x3
[   54.808931] raid6: int64x4   2190 MB/s
[   54.880403] raid6: int64x8   1641 MB/s
[   54.948293] raid6: sse2x1    2445 MB/s
[   55.016149] raid6: sse2x2    3332 MB/s
[   55.084035] raid6: sse2x4    3666 MB/s
[   55.087774] raid6: using algorithm sse2x4 (3666 MB/s)
[   55.092819] md: raid6 personality registered for level 6
[   55.098120] md: raid5 personality registered for level 5
[   55.103423] md: raid4 personality registered for level 4
[   55.108724] raid5: automatically using best checksumming function: generic_ss
e
[   55.131933]    generic_sse:  6247.000 MB/sec
[   55.136192] raid5: using function: generic_sse (6247.000 MB/sec)
[   55.142185] md: multipath personality registered for level -4
[   55.148202] input: AT Translated Set 2 keyboard as /class/input/input0
[   55.155159] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-d
evel@redhat.com
[   55.163779] TCP cubic registered
[   55.167586] scsi: waiting for bus probes to complete ...
[   55.174490] scsi 0:0:1:0: Direct-Access     SEAGATE  ST336752LW       0003 PQ
: 0 ANSI: 3
[   55.182578] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[   55.188138]  target0:0:1: Beginning Domain Validation
[   55.199456] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0xc0
[   55.204459] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x20
[   55.209456] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x2
[   55.214407] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x1
[   55.219365] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x2
[   55.224326] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x3
[   55.229283] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x1
[   55.234275] scsi0:A:1:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
[   55.240905] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x1
[   55.245746] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x2
[   55.250579] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x3
[   55.255426] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x1
[   55.260296] scsi0:A:1:0: Asserting ATN for response
[   55.265216] scsi0:A:1:0: INITIATOR_MSG_IN PHASEMIS in Message-out phase
[   55.271840] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x1
[   55.276796] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x3
[   55.281753] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x1
[   55.286697] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x45
[   55.291735] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x0
[   55.296773] scsi0:A:1:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
[   55.303399] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x1
[   55.308243] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x3
[   55.313076] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x1
[   55.317908] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x32
[   55.322840] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x0
[   55.327654]  target0:0:1: wide asynchronous
[   55.331969] scsi0:A:1:0: INITIATOR_MSG_IN PHASEMIS in Command phase
[   55.342834] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0xc0
[   55.347834] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x20
[   55.352833] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x3
[   55.357779] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x1
[   55.362737] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x6
[   55.367695] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x4
[   55.372658] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x9
[   55.377600] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x0
[   55.382556] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x7f
[   55.387593] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x1
[   55.392532] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x2
[   55.397540] scsi0:A:1:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
[   55.404164] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x1
[   55.408994] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x6
[   55.413841] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x4
[   55.418675] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x9
[   55.423505] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x0
[   55.428355] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x3f
[   55.433273] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x1
[   55.438120] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x2
[   55.442934]  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63
)
[   55.450279] scsi0:A:1:0: INITIATOR_MSG_IN PHASEMIS in Command phase
[   55.461120] (scsi0:A:1:0): SCB 2: requests Check Status
[   55.466347] (scsi0:A:1:0): Sending Sense
[   55.470312] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x80
[   55.475315] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x1
[   55.480283] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x6
[   55.485245] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x4
[   55.490202] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x9
[   55.495163] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x0
[   55.500104] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x3f
[   55.505137] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x1
[   55.510073] scsi0:A:1:0: INITIATOR_MSG_OUT byte 0x2
[   55.515083] scsi0:A:1:0: INITIATOR_MSG_OUT PHASEMIS in Message-in phase
[   55.521707] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x1
[   55.526537] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x6
[   55.531385] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x4
[   55.536219] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x9
[   55.541051] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x0
[   55.545898] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x3f
[   55.550813] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x1
[   55.555662] scsi0:A:1:0: INITIATOR_MSG_IN byte 0x2
[   55.560608] scsi0:A:1:0: INITIATOR_MSG_IN PHASEMIS in Command phase
[   55.567063] (scsi0:A:1:0): Handled Sense Residual of 14 bytes
[   55.572813] Copied 18 bytes of sense data:
[   55.576919] 0x70 0x0 0x6 0x0 0x0 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x29 0x2 0x2 0x0

[   55.584392] 0x0 0x0
[   55.590422]  target0:0:1: Ending Domain Validation
[   55.595458] (scsi0:A:1:0): Handled Residual of 4080 bytes
[   55.856881] (scsi0:A:2:0): Saw Selection Timeout for SCB 0x2
[   56.118816] (scsi0:A:3:0): Saw Selection Timeout for SCB 0x3
[   56.380734] (scsi0:A:4:0): Saw Selection Timeout for SCB 0x2
[   56.642649] (scsi0:A:5:0): Saw Selection Timeout for SCB 0x3
[   56.904565] (scsi0:A:6:0): Saw Selection Timeout for SCB 0x2
[   57.166480] (scsi0:A:8:0): Saw Selection Timeout for SCB 0x3
[   57.428389] (scsi0:A:9:0): Saw Selection Timeout for SCB 0x2
[   57.690302] (scsi0:A:10:0): Saw Selection Timeout for SCB 0x3
[   57.952303] (scsi0:A:11:0): Saw Selection Timeout for SCB 0x2
[   58.214304] (scsi0:A:12:0): Saw Selection Timeout for SCB 0x3
[   58.476306] (scsi0:A:13:0): Saw Selection Timeout for SCB 0x2
[   58.738307] (scsi0:A:14:0): Saw Selection Timeout for SCB 0x3
[   59.000317] (scsi0:A:15:0): Saw Selection Timeout for SCB 0x2
[   59.007520] SCSI device sda: 71687369 512-byte hdwr sectors (36704 MB)
[   59.015053] sda: Write Protect is off
[   59.020225] SCSI device sda: write cache: enabled, read cache: enabled, suppo
rts DPO and FUA
[   59.029570] SCSI device sda: 71687369 512-byte hdwr sectors (36704 MB)
[   59.037102] sda: Write Protect is off
[   59.042273] SCSI device sda: write cache: enabled, read cache: enabled, suppo
rts DPO and FUA
[   59.050720]  sda: sda1 sda2 sda3
[   59.068842] sd 0:0:1:0: Attached scsi disk sda
[   59.073583] sd 0:0:1:0: Attached scsi generic sg0 type 0
[   59.078945] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[   59.085714] md: Autodetecting RAID arrays.
[   59.089820] md: autorun ...
[   59.092614] md: ... autorun DONE.
[   59.106354] kjournald starting.  Commit interval 5 seconds
[   59.111969] EXT3-fs: mounted filesystem with ordered data mode.
[   59.118031] VFS: Mounted root (ext3 filesystem) readonly.
[   59.123508] Freeing unused kernel memory: 224k freed
[   59.128929] Write protecting the kernel read-only data: 1416k
INIT: version 2.86 booting
[   59.535079] NET: Registered protocol family 1
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...[   60.246648] (scsi0:A:1:0): Handled R
esidual of 241 bytes
[   60.270540] (scsi0:A:1:0): Handled Residual of 230 bytes


