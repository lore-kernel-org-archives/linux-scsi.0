From: Jan Lana <jan.lana@Sun.COM>
Subject: 'modprobe mptctl' fails after 'modprobe aic79xx'
Date: Mon, 25 Oct 2004 12:51:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041025105112.GQ7803@orion.czech.sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nwkea-mail-2.sun.com ([192.18.42.14]:8849 "EHLO
	nwkea-mail-2.sun.com") by vger.kernel.org with ESMTP
	id S261754AbUJYKvl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2004 06:51:41 -0400
Received: from centralmail1brm.Central.Sun.COM ([129.147.62.1])
	by nwkea-mail-2.sun.com (8.12.10/8.12.9) with ESMTP id i9PApd7q017950
	for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2004 03:51:40 -0700 (PDT)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Tomas Vesely <Tomas.Vesely@Sun.COM>

Hi,

I have found a strange behavior of module mptbase (Fusion MPT (base + ScsiHost) drivers).
There is a bugreport:


[1.] One line summary of the problem:    
     'modprobe mptbase' after 'modprobe aic79xx' fails.


[2.] Full description of the problem/report:
     I created a small distro without hotplug support. Modules are loaded by startup scripts.
     When I do:
# modprobe mptbase
     everything works fine. When I do:
# modprobe aic79xx
FATAL: Error inserting aic79xx (/lib/modules/2.6.9/kernel/drivers/scsi/aic7xxx/aic79xx.ko): No such device
# modprobe mptbase
Unable to handle kernel paging request at virtual address f8948cd8
 printing eip:
c02f0ba1
*pde = 017f1067
*pte = 00000000
Oops: 0002 [#1]
Modules linked in: mptbase
CPU:    0
EIP:    0060:[<c02f0ba1>]    Not tainted VLI
EFLAGS: 00010292   (2.6.9) 
EIP is at kobject_add+0x61/0xc0
eax: c054f280   ebx: f887e25c   ecx: f8948cd8   edx: f887e278
esi: c054f220   edi: c054f288   ebp: 00000000   esp: f6b03f4c
ds: 007b   es: 007b   ss: 0068
Process modprobe (pid: 927, threadinfo=f6b02000 task=f5cf2560)
Stack: f887e25c c054f220 f887e244 c02f0c14 f887e25c c054f220 c0353267 f887e220 
       00000000 f887e2b8 00000000 c0353718 000001fb c016b29b f6741880 00008000 
       c02fde6c f887e520 f887e560 f887e520 c053e7e0 f88910a6 c053e7f8 f887e300 
Call Trace:
 [<c02f0c14>] kobject_register+0x14/0x40
 [<c0353267>] bus_add_driver+0x37/0x90
 [<c0353718>] driver_register+0x28/0x30
 [<c016b29b>] proc_register+0xb/0x90
 [<c02fde6c>] pci_register_driver+0x4c/0x70
 [<f88910a6>] fusion_init+0xa6/0xb9 [mptbase]
 [<c012a0a2>] sys_init_module+0x1a2/0x1d0
 [<c0105d07>] syscall_call+0x7/0xb
Code: 01 00 ff ff 8d 41 48 0f c1 10 85 d2 0f 85 8f 04 00 00 85 ff 74 65 8b 43 28 8d 53 1c 83 c0 08 89 43 1c 8b 48 04 89 50 04 89 4a 04 <89> 11 8b 43 28 8b 30 8d 4e 48 89 c8 ba ff ff 00 00 0f c1 10 0f 


     I really doesn't have aic79xx hardware in my computer, so the answer of the first
     modprobe is correct. But strange is that the mptbase depends on it.


[3.] Keywords (i.e., modules, networking, kernel):
     aic79xx mptbase


[4.] Kernel version (from /proc/version):
Linux version 2.6.9 (root@tulipan.czech.sun.com) (gcc version 3.2.3 20030502 (Red Hat Linux 3.2.3-20)) #2 Mon Oct 25 10:29:48 CEST 2004


[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt)


[6.] A small shell script or example program which triggers the
     problem (if possible)
#!/bin/sh
modprobe aic79xx
modprobe mptbase


[7.] Environment
     Sun V20z Opteron machine


[7.1.] Software (add the output of the ver_linux script here)
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux votice 2.6.8-1-686 #1 Thu Oct 7 03:15:25 EDT 2004 i686 GNU/Linux
 
Gnu C                  3.3.4
Gnu make               3.80
binutils               2.15
util-linux             2.12
mount                  2.12
module-init-tools      3.1-pre6
e2fsprogs              1.35
reiserfsprogs          line
reiser4progs           line
nfs-utils              1.0.6
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 3.2.1
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.2.1
Modules Loaded         nls_cp437 loop sr_mod nfs apm sd_mod scsi_mod nfsd exportfs lockd sunrpc af_packet lp snd_sb16 snd_opl3_lib snd_sb16_dsp snd_pcm_oss snd_mixer_oss snd_pcm snd_page_alloc snd_timer snd_sb16_csp snd_sb_common snd_hwdep snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore ppp_async crc_ccitt ipv6 ppp_generic slhc ipt_MASQUERADE iptable_nat ip_conntrack ip_tables uhci_hcd usbcore pci_hotplug intel_agp agpgart analog ns558 gameport parport_pc parport floppy pcspkr evdev capability commoncap autofs4 mousedev psmouse 8139too mii crc32 ide_cd cdrom rtc msdos ext2 vfat fat isofs udf ext3 jbd mbcache ide_generic piix ide_disk ide_core unix font vesafb cfbcopyarea cfbimgblt cfbfillrect


[7.2.] Processor information (from /proc/cpuinfo):
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 5
model name	: AMD Opteron(tm) Processor 242
stepping	: 8
cpu MHz		: 1593.814
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm 3dnowext 3dnow
bogomips	: 3129.34


[7.3.] Module information (from /proc/modules):
(after 'modprobe mptscsih' only) 
mptscsih 29812 0 - Live 0xf8891000
mptbase 38496 1 mptscsih, Live 0xf8875000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
/proc/ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
0300-0310 : 82596
0376-0376 : ide1
03c0-03df : vga+
03f2-03f5 : floppy
03f7-03f7 : floppy DIR
03f8-03ff : serial
0cf8-0cff : PCI conf1
1000-100f : 0000:00:07.1
  1000-1007 : ide0
  1008-100f : ide1
15e0-15e3 : pc110pad
2000-2fff : PCI Bus #02
  2000-20ff : 0000:02:04.0
8000-8003 : PM1a_EVT_BLK
8004-8005 : PM1a_CNT_BLK
8008-800b : PM_TMR
8010-8015 : ACPI CPU throttle
8020-8023 : GPE0_BLK
80b0-80b7 : GPE1_BLK

/proc/iomem:
00000000-00099fff : System RAM
0009a000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000c8000-000c97ff : Adapter ROM
000c9800-000cafff : Adapter ROM
000cb000-000cefff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7ff6ffff : System RAM
  00100000-0048f1f9 : Kernel code
  0048f1fa-005b737f : Kernel data
7ff70000-7ff76fff : ACPI Tables
7ff77000-7ff7ffff : ACPI Non-volatile Storage
7ff80000-7fffffff : reserved
fd000000-fd000fff : 0000:00:0a.1
fd001000-fd001fff : 0000:00:0b.1
fd100000-fe7fffff : PCI Bus #01
  fd100000-fd11ffff : 0000:01:05.0
  fd120000-fd120fff : 0000:01:00.0
  fd121000-fd121fff : 0000:01:00.1
  fd800000-fdffffff : 0000:01:05.0
  fe000000-fe7fffff : 0000:01:05.0
fe800000-fe8fffff : PCI Bus #02
  fe800000-fe80ffff : 0000:02:02.0
    fe800000-fe80ffff : tg3
  fe810000-fe81ffff : 0000:02:03.0
    fe810000-fe81ffff : tg3
  fe820000-fe82ffff : 0000:02:04.0
  fe830000-fe83ffff : 0000:02:04.0
fec00000-fec003ff : reserved
fee00000-fee00fff : reserved
fff80000-ffffffff : reserved


[7.5.] PCI information ('lspci -vvv' as root)
00:06.0 Class 0604: 1022:7460 (rev 07)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 123
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=68
	Memory behind bridge: fd100000-fe7fffff
	BridgeCtl: Parity+ SERR+ NoISA+ VGA+ MAbort- >Reset- FastB2B-
	Capabilities: [c0] #08 [0086]
	Capabilities: [f0] #08 [8000]

00:07.0 Class 0601: 1022:7468 (rev 05)
	Subsystem: 1022:7468
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:07.1 Class 0101: 1022:7469 (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: 17c2:0010
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Region 4: I/O ports at 1000 [size=16]

00:07.3 Class 0680: 1022:746b (rev 05)
	Subsystem: 17c2:0010
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:0a.0 Class 0604: 1022:7450 (rev 12)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: fe800000-fe8fffff
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [a0] PCI-X bridge device.
		Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=1
		Status: Bus=0 Dev=10 Func=0 64bit+ 133MHz+ SCD- USC-, SCO-, SRD-
		: Upstream: Capacity=14, Commitment Limit=14
		: Downstream: Capacity=2, Commitment Limit=2
	Capabilities: [b8] #08 [8000]
	Capabilities: [c0] #08 [004a]

00:0a.1 Class 0800: 1022:7451 (rev 01) (prog-if 10)
	Subsystem: 17c2:0010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at fd000000 (64-bit, non-prefetchable) [size=4K]

00:0b.0 Class 0604: 1022:7450 (rev 12)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
	BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
	Capabilities: [a0] PCI-X bridge device.
		Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=3
		Status: Bus=0 Dev=11 Func=0 64bit+ 133MHz+ SCD- USC-, SCO-, SRD-
		: Upstream: Capacity=14, Commitment Limit=14
		: Downstream: Capacity=2, Commitment Limit=2
	Capabilities: [b8] #08 [8000]

00:0b.1 Class 0800: 1022:7451 (rev 01) (prog-if 10)
	Subsystem: 17c2:0010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at fd001000 (64-bit, non-prefetchable) [size=4K]

00:18.0 Class 0600: 1022:1100
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Capabilities: [80] #08 [2101]
	Capabilities: [a0] #08 [2101]
	Capabilities: [c0] #08 [2101]

00:18.1 Class 0600: 1022:1101
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.2 Class 0600: 1022:1102
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

00:18.3 Class 0600: 1022:1103
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-

01:00.0 Class 0c03: 1022:7464 (rev 0b) (prog-if 10)
	Subsystem: 17c2:0010
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (20000ns max)
	Interrupt: pin D routed to IRQ 11
	Region 0: Memory at fd120000 (32-bit, non-prefetchable) [size=4K]

01:00.1 Class 0c03: 1022:7464 (rev 0b) (prog-if 10)
	Subsystem: 17c2:0010
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (20000ns max)
	Interrupt: pin D routed to IRQ 11
	Region 0: Memory at fd121000 (32-bit, non-prefetchable) [size=4K]

01:05.0 Class 0300: 1023:9880 (rev 3a)
	Subsystem: 17c2:0010
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at fe000000 (32-bit, non-prefetchable) [size=8M]
	Region 1: Memory at fd100000 (32-bit, non-prefetchable) [size=128K]
	Region 2: Memory at fd800000 (32-bit, non-prefetchable) [size=8M]
	Expansion ROM at <unassigned> [disabled] [size=64K]
	Capabilities: [80] AGP version 1.0
		Status: RQ=33 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>
	Capabilities: [90] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:02.0 Class 0200: 14e4:16a7 (rev 02)
	Subsystem: 17c2:0010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (16000ns min), Cache Line Size: 0x10 (64 bytes)
	Interrupt: pin A routed to IRQ 5
	Region 0: Memory at fe800000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] PCI-X non-bridge device.
		Command: DPERE- ERO- RBC=0 OST=0
		Status: Bus=2 Dev=2 Func=1 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=2, DMOST=0, DMCRS=1, RSCEM-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
		Address: 000200048b220c2c  Data: 420b

02:03.0 Class 0200: 14e4:16a7 (rev 02)
	Subsystem: 17c2:0010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (16000ns min), Cache Line Size: 0x10 (64 bytes)
	Interrupt: pin A routed to IRQ 3
	Region 0: Memory at fe810000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] PCI-X non-bridge device.
		Command: DPERE- ERO- RBC=2 OST=0
		Status: Bus=2 Dev=3 Func=1 64bit+ 133MHz+ SCD- USC-, DC=simple, DMMRBC=2, DMOST=0, DMCRS=1, RSCEM-
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable-
		Address: 4028c360617a6784  Data: 9790

02:04.0 Class 0100: 1000:0030 (rev 08)
	Subsystem: 17c2:0010
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Stepping- SERR+ FastB2B-
	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 72 (4250ns min, 4500ns max), Cache Line Size: 0x10 (64 bytes)
	Interrupt: pin A routed to IRQ 11
	Region 0: I/O ports at 2000 [size=256]
	Region 1: Memory at fe830000 (64-bit, non-prefetchable) [size=64K]
	Region 3: Memory at fe820000 (64-bit, non-prefetchable) [size=64K]
	Expansion ROM at <unassigned> [disabled] [size=1M]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [68] PCI-X non-bridge device.
		Command: DPERE- ERO- RBC=2 OST=1
		Status: Bus=2 Dev=4 Func=0 64bit+ 133MHz- SCD- USC-, DC=simple, DMMRBC=2, DMOST=4, DMCRS=1, RSCEM-


[7.6.] SCSI information (from /proc/scsi/scsi)
(after 'modprobe mptscsih' only)
Attached devices:
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: SEAGATE  Model: ST336607LC       Rev: 0007
  Type:   Direct-Access                    ANSI SCSI revision: 03


[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
     I attached a part of 'dmesg' output. It contains an aic79xx module error too!
tg3: eth0: Link is up at 100 Mbps, full duplex.
tg3: eth0: Flow control is on for TX and on for RX.
kobject_register failed for aic79xx (-17)
 [<c02f0c33>] kobject_register+0x33/0x40
 [<c0353267>] bus_add_driver+0x37/0x90
 [<c0353718>] driver_register+0x28/0x30
 [<c02fde6c>] pci_register_driver+0x4c/0x70
 [<f892e85a>] ahd_linux_pci_init+0xa/0x20 [aic79xx]
 [<f8926c55>] ahd_linux_detect+0x35/0x70 [aic79xx]
 [<f886800a>] ahd_linux_init+0xa/0x1c [aic79xx]
 [<c012a0a2>] sys_init_module+0x1a2/0x1d0
 [<c0105d07>] syscall_call+0x7/0xb
kobject_register failed for aic79xx (-17)
 [<c02f0c33>] kobject_register+0x33/0x40
 [<c0353267>] bus_add_driver+0x37/0x90
 [<c0353718>] driver_register+0x28/0x30
 [<c02fde6c>] pci_register_driver+0x4c/0x70
 [<f892e85a>] ahd_linux_pci_init+0xa/0x20 [aic79xx]
 [<f8926c55>] ahd_linux_detect+0x35/0x70 [aic79xx]
 [<f886800a>] ahd_linux_init+0xa/0x1c [aic79xx]
 [<c012a0a2>] sys_init_module+0x1a2/0x1d0
 [<c0105d07>] syscall_call+0x7/0xb
Fusion MPT base driver 3.01.16
Copyright (c) 1999-2004 LSI Logic Corporation
Unable to handle kernel paging request at virtual address f8948cd8
 printing eip:
c02f0ba1
*pde = 017f1067
*pte = 00000000
.... (see [2.])


Regards,
Jan Lana
