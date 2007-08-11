From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Unexpected busfree in Message-in phase
Date: Sat, 11 Aug 2007 17:10:19 +0200
Message-ID: <9a8748490708110810u2c7d6275hbd73cdede58a023d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.226]:61547 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbXHKPKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 11 Aug 2007 11:10:21 -0400
Received: by wx-out-0506.google.com with SMTP id h31so803573wxd
        for <linux-scsi@vger.kernel.org>; Sat, 11 Aug 2007 08:10:20 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Hi,

I just noticed this in dmesg :

[ 3216.262987] (scsi0:A:4:0): Unexpected busfree in Message-in phase
[ 3216.263058] SEQADDR == 0x16c
[ 3216.263724]  target0:0:4: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 16)

That's all there is in addition to the normal bootup messages, just
those 3 lines.
The machine is doing fine at the moment, no ill effects so far, but an
explanation of what exactely could be causing that and whether or not
it is a (fixable) problem would be very nice :-)


Some details :

$ scripts/ver_linux
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux dragon 2.6.22-g1db6178c #1 SMP PREEMPT Sat Jul 14 04:10:50 CEST
2007 i686 AMD Athlon(tm) 64 X2 Dual Core Processor 4400+ AuthenticAMD
GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               Binutils
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
jfsutils               1.1.11
reiserfsprogs          3.6.19
xfsprogs               2.8.16
pcmciautils            014
quota-tools            3.13.
PPP                    2.4.4
Linux C Library        2.5
Dynamic linker (ldd)   2.5
Linux C++ Library      6.0.8
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
oprofile               0.9.2
Sh-utils               6.9
udev                   111
Modules Loaded         snd_seq_oss snd_seq_midi_event snd_seq
snd_pcm_oss snd_mixer_oss lp snd_emu10k1 snd_rawmidi firmware_class
snd_ac97_codec ac97_bus snd_pcm nvidia snd_seq_device snd_timer
snd_page_alloc snd_util_mem agpgart snd_hwdep sg evdev k8temp
via_rhine ehci_hcd


$ cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: PIONEER  Model: DVD-ROM DVD-305  Rev: 1.03
  Type:   CD-ROM                           ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.01
  Type:   CD-ROM                           ANSI  SCSI revision: 02
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: IBM      Model: DDYS-T36950N     Rev: S96H
  Type:   Direct-Access                    ANSI  SCSI revision: 03


$ cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 2
cpu MHz         : 2200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
lm 3dnowext 3dnow pni lahf_lm cmp_legacy ts fid vid ttp
bogomips        : 4402.45
clflush size    : 64

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 35
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4400+
stepping        : 2
cpu MHz         : 2200.000
cache size      : 1024 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt
lm 3dnowext 3dnow pni lahf_lm cmp_legacy ts fid vid ttp
bogomips        : 4399.54
clflush size    : 64


$ cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:12.0
01f0-01f7 : 0000:00:12.0
0290-029f : pnp 00:0d
0376-0376 : 0000:00:12.0
0378-037a : parport0
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:12.0
03f7-03f7 : floppy DIR
03f8-03ff : serial
0800-083f : 0000:00:07.1
  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0818-0827 : ACPI GPE0_BLK
  0830-0830 : ACPI PM2_CNT_BLK
0cf8-0cff : PCI conf1
d000-dfff : PCI Bus #04
  d000-d0ff : 0000:04:07.0
    d000-d0ff : via-rhine
  d400-d4ff : 0000:04:06.0
  d880-d89f : 0000:04:05.0
    d880-d89f : EMU10K1
  dc00-dc07 : 0000:04:05.1
e800-e8ff : 0000:00:11.0
ff00-ff0f : 0000:00:12.0


$ cat /proc/iomem
00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cb7ff : Video ROM
000cb800-000d0bff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7ffaffff : System RAM
  00100000-003b3449 : Kernel code
  003b344a-004dcdbb : Kernel data
7ffb0000-7ffbffff : ACPI Tables
7ffc0000-7ffeffff : ACPI Non-volatile Storage
7fff0000-7fffffff : reserved
88000000-880fffff : PCI Bus #04
  88000000-8801ffff : 0000:04:06.0
  88020000-8802ffff : 0000:04:07.0
cfe00000-d7efffff : PCI Bus #03
  d0000000-d3ffffff : 0000:03:00.0
  d7e80000-d7efffff : 0000:03:00.0
dc000000-dfffffff : 0000:00:04.0
e0000000-efffffff : pnp 00:09
fc700000-fc7fffff : PCI Bus #01
fc800000-fc8fffff : PCI Bus #02
fc900000-fe9fffff : PCI Bus #03
  fd000000-fdffffff : 0000:03:00.0
    fd000000-fdffffff : nvidia
  fe9f0000-fe9fffff : 0000:03:00.0
fea00000-feafffff : PCI Bus #04
  feafec00-feafecff : 0000:04:07.0
    feafec00-feafecff : via-rhine
  feaff000-feafffff : 0000:04:06.0
    feaff000-feafffff : aic7xxx
febfc000-febfcfff : 0000:00:13.2
febfd000-febfdfff : 0000:00:13.1
febfe000-febfefff : 0000:00:13.0
febff800-febff8ff : 0000:00:13.3
  febff800-febff8ff : ehci_hcd
febffc00-febffcff : 0000:00:11.0
fec00000-fec00fff : pnp 00:09
fec10000-fec10fff : pnp 00:09
fee00000-fee00fff : pnp 00:09
ff7c0000-ffffffff : reserved


# lspci -v
00:00.0 Host bridge: ALi Corporation M1695 K8 Northbridge [PCI Express
and HyperTransport]
        Flags: bus master, fast devsel, latency 0
        Capabilities: [40] HyperTransport: Slave or Primary Interface
        Capabilities: [5c] HyperTransport: MSI Mapping
        Capabilities: [68] HyperTransport: UnitID Clumping
        Capabilities: [74] HyperTransport: Interrupt Discovery and Configuration
        Capabilities: [7c] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable-

00:01.0 PCI bridge: ALi Corporation PCI Express Root Port (prog-if 00
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Memory behind bridge: fc700000-fc7fffff
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable+
        Capabilities: [58] Express Root Port (Slot+) IRQ 0
        Capabilities: [7c] HyperTransport: MSI Mapping
        Capabilities: [88] HyperTransport: Revision ID: 1.05

00:02.0 PCI bridge: ALi Corporation PCI Express Root Port (prog-if 00
[Normal decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        Memory behind bridge: fc800000-fc8fffff
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Message Signalled Interrupts: Mask- 64bit+
Queue=0/1 Enable+
        Capabilities: [58] Express Root Port (Slot+) IRQ 0
        Capabilities: [7c] HyperTransport: MSI Mapping
        Capabilities: [88] HyperTransport: Revision ID: 1.05

00:04.0 Host bridge: ALi Corporation M1689 K8 Northbridge [Super K8 Single Chip]
        Flags: bus master, fast devsel, latency 0
        Memory at dc000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [40] HyperTransport: Slave or Primary Interface
        Capabilities: [60] HyperTransport: Interrupt Discovery and Configuration
        Capabilities: [80] AGP version 3.0

00:05.0 PCI bridge: ALi Corporation AGP8X Controller (prog-if 00
[Normal decode])
        Flags: bus master, 66MHz, fast devsel, latency 0
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=64
        Memory behind bridge: fc900000-fe9fffff
        Prefetchable memory behind bridge: cfe00000-d7efffff

00:06.0 PCI bridge: ALi Corporation M5249 HTT to PCI Bridge (prog-if
01 [Subtractive decode])
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fea00000-feafffff
        Prefetchable memory behind bridge: 88000000-880fffff

00:07.0 ISA bridge: ALi Corporation M1563 HyperTransport South Bridge (rev 70)
        Subsystem: ASRock Incorporation Unknown device 1563
        Flags: bus master, medium devsel, latency 0

00:07.1 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
        Subsystem: ASRock Incorporation Unknown device 7101
        Flags: medium devsel

00:11.0 Ethernet controller: ALi Corporation ULi 1689,1573 integrated
ethernet. (rev 40)
        Subsystem: ASRock Incorporation Unknown device 5263
        Flags: bus master, medium devsel, latency 32, IRQ 10
        I/O ports at e800 [size=256]
        Memory at febffc00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2

00:12.0 IDE interface: ALi Corporation M5229 IDE (rev c7) (prog-if 8a
[Master SecP PriP])
        Subsystem: ASRock Incorporation ASRock 939Dual-SATA2
Motherboard IDE (PATA)
        Flags: bus master, 66MHz, medium devsel, latency 32
        I/O ports at 01f0 [size=8]
        I/O ports at 03f4 [size=1]
        I/O ports at 0170 [size=8]
        I/O ports at 0374 [size=1]
        I/O ports at ff00 [size=16]

00:13.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
(prog-if 10 [OHCI])
        Subsystem: ASRock Incorporation Unknown device 5237
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 11
        Memory at febfe000 (32-bit, non-prefetchable) [size=4K]

00:13.1 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
(prog-if 10 [OHCI])
        Subsystem: ASRock Incorporation Unknown device 5237
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 3
        Memory at febfd000 (32-bit, non-prefetchable) [size=4K]

00:13.2 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
(prog-if 10 [OHCI])
        Subsystem: ASRock Incorporation Unknown device 5237
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 11
        Memory at febfc000 (32-bit, non-prefetchable) [size=4K]

00:13.3 USB Controller: ALi Corporation USB 2.0 Controller (rev 01)
(prog-if 20 [EHCI])
        Subsystem: ASRock Incorporation Unknown device 5239
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 19
        Memory at febff800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
        Capabilities: [58] Debug port

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration
        Flags: fast devsel
        Capabilities: [80] HyperTransport: Host or Secondary Interface

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map
        Flags: fast devsel

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller
        Flags: fast devsel

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control
        Flags: fast devsel

03:00.0 VGA compatible controller: nVidia Corporation NV20 [GeForce3]
(rev a3) (prog-if 00 [VGA])
        Flags: bus master, 66MHz, medium devsel, latency 248, IRQ 21
        Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Memory at d0000000 (32-bit, prefetchable) [size=64M]
        Memory at d7e80000 (32-bit, prefetchable) [size=512K]
        [virtual] Expansion ROM at fe9f0000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 2
        Capabilities: [44] AGP version 2.0

04:05.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev 0a)
        Subsystem: Creative Labs SBLive! 5.1 eMicro 28028
        Flags: bus master, medium devsel, latency 32, IRQ 22
        I/O ports at d880 [size=32]
        Capabilities: [dc] Power Management version 1

04:05.1 Input device controller: Creative Labs SB Live! Game Port (rev 0a)
        Subsystem: Creative Labs Gameport Joystick
        Flags: bus master, medium devsel, latency 32
        I/O ports at dc00 [size=8]
        Capabilities: [dc] Power Management version 1

04:06.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
        Subsystem: Adaptec 29160N Ultra160 SCSI Controller
        Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 18
        BIST result: 00
        I/O ports at d400 [disabled] [size=256]
        Memory at feaff000 (64-bit, non-prefetchable) [size=4K]
        Expansion ROM at 88000000 [disabled] [size=128K]
        Capabilities: [dc] Power Management version 2

04:07.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 42)
        Subsystem: D-Link System Inc DFE-530TX rev B
        Flags: bus master, medium devsel, latency 32, IRQ 20
        I/O ports at d000 [size=256]
        Memory at feafec00 (32-bit, non-prefetchable) [size=256]
        Expansion ROM at 88020000 [disabled] [size=64K]
        Capabilities: [40] Power Management version 2


If you need anything else (like my .config etc), just ask.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
