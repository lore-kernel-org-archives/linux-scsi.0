From: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Subject: PROBLEM: 2.6.0-test9: SCSI mid layer tells a lie.
Date: Wed, 3 Dec 2003 15:43:56 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <016101c3b969$046cf520$2987110a@lsd.css.fujitsu.com>
Reply-To: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34728 "EHLO
	fgwmail6.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S264506AbTLCGpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 01:45:45 -0500
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76]) by fgwmail6.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id hB36jhQA014615 for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2003 15:45:43 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from s2.gw.fujitsu.co.jp by m6.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id hB36jgSj027669 for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2003 15:45:42 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from dm2.oaks.cs.fujitsu.co.jp (dm2.oaks.cs.fujitsu.co.jp [10.20.85.2]) by s2.gw.fujitsu.co.jp (8.12.10)
	id hB36jguG018690 for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2003 15:45:42 +0900
	(envelope-from ishii.hironobu@jp.fujitsu.com)
Received: from CARREN (lsd5041.lsd.css.fujitsu.com [10.17.135.41])
	by dm2.oaks.cs.fujitsu.co.jp (8.11.7/3.7W-03092116) with SMTP id hB36jfW06756
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2003 15:45:41 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Hi all,

I am verifying error recovery logics of SCSI mid layer with
pseudo target device.
In my test, I found a data corruption problem.
Please see bellow.

Thanks,
Hironobu Ishii.
---------------
[1.] One line summary of the problem:
2.6.0-test9: SCSI mid layer tells a lie.

[2.] Full description of the problem/report:
Kernel:  2.6.0-test9 vanilla

Problem:
 SCSI mid layer failed to read(or write) the device,
 but it returns normal completion to the application.

 The sequence is as follows.
 SCSI mid layer repeats (a) part 5 times(SD_MAX_RETRIES).
 I found this problem occurs with either READ or WRITE command.

  Initiator              LLD(Fusion MPT)           Target
  -----------------------------------------------------------
+- READ(or WRITE)        --------------------->   (Time out)
|
| eh_abort               --------------------->
|                        LLD issues abort msg,
|                        but it doesn't wait for its completion
|                        and eh_aobrt_handler returns 0x2003(FAILED).
|
| eh_device_reset_handler
|                        LLD issues nothing on the SCSI BUS
(a)                      and returns 0x2003(FAILED)
|
| eh_device_bus_reset_handler
|                        --------------------->   BUS RESET
|                        LLD returns 0x2002(SUCCESS)
|
| TEST UNIT READY         -------------------->
|                         <--------------------   CHK(06/0000)
|
| TEST UNIT READY         --------------------->
+-                        <---------------------  GOOD

The purpose of this test is to verify operation when there is
a medium error in disk.

I tested this problem with test6 and test9.
I got the same result with either.
I'm going to re-test with test11. But it takes for a while.
(I looked at the diff between test6 and test11, but I can't
 find a fix relating to this problem.)

Environments:
Initiator HBA: LSI Logic 53c1030(Fusion MPT)
Target:        Pseudo target device
Operation:     dd  if=/dev/sde of=/tmp/read_data count=1
              (or dd if=/tmp/data of=/dev/sde count=1)

[3.] Keywords (i.e., modules, networking, kernel):
 scsi_mod, time out

[4.] Kernel version (from /proc/version):
Linux version 2.6.0-test9 (root@lsd6129) (gcc version 3.2.2 20030222 (Red Hat
 Linux 3.2.2-5)) #2 SMP Mon Nov 10 15:48:58 JST 2003

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
[6.] A small shell script or example program which triggers the
     problem (if possible)
[7.] Environment
 See above.
[7.1.] Software
Linux lsd6129 2.6.0-test9 #2 SMP Mon Nov 10 15:48:58 JST 2003 i686 i686 i386 GNU
/Linux

Gnu C                  3.2.2
Gnu make               3.79.1
util-linux             2.11y
mount                  2.11y
module-init-tools      0.9.12
e2fsprogs              1.32
jfsutils               1.0.17
reiserfsprogs          3.6.4
pcmcia-cs              3.1.31
quota-tools            3.06.
PPP                    2.4.1
isdn4k-utils           3.1pre4
nfs-utils              1.0.1
Linux C Library        2.3.2
Dynamic linker (ldd)   2.3.2
Procps                 2.0.11
Net-tools              1.60
Kbd                    1.08
Sh-utils               4.5.3
Modules Loaded         mptscsih mptctl mptbase autofs e1000 e100 ohci1394 ieee13
94 parport_pc parport hid ehci_hcd usbcore ext3 jbd sym53c8xx sd_mod scsi_mod

[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 11
model name      : Intel(R) Pentium(R) III CPU - S         1266MHz
stepping        : 4
cpu MHz         : 1261.632
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 mmx fxsr sse
bogomips        : 2490.36

[7.3.] Module information (from /proc/modules):
mptscsih 46396 0 - Live 0xe0a6e000
mptctl 26720 0 - Live 0xe087b000
mptbase 47904 2 mptscsih,mptctl, Live 0xe0a0e000
autofs 18112 0 - Live 0xe0a08000
e1000 84864 0 - Live 0xe0a49000
e100 65828 0 - Live 0xe0a37000
ohci1394 36800 0 - Live 0xe09ec000
ieee1394 84844 1 ohci1394, Live 0xe0a21000
parport_pc 27624 0 - Live 0xe088c000
parport 45376 1 parport_pc, Live 0xe09fb000
hid 17984 0 - Live 0xe089d000
ehci_hcd 25696 0 - Live 0xe0895000
usbcore 114100 3 hid,ehci_hcd, Live 0xe08ce000
ext3 121096 3 - Live 0xe08af000
jbd 69656 1 ext3, Live 0xe082b000
sym53c8xx 78180 4 - Live 0xe085d000
sd_mod 16416 5 - Live 0xe081e000
scsi_mod 121692 3 mptscsih,sym53c8xx,sd_mod, Live 0xe083e000

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-005f : timer
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
02f8-02ff : serial
0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f8-03ff : serial
0cf8-0cff : PCI conf1
1000-10ff : 0000:00:04.0
1400-143f : 0000:00:0a.0
  1400-143f : e100
1800-180f : 0000:00:0f.1
  1800-1807 : ide0
  1808-180f : ide1
1c00-1cff : 0000:01:0a.0
  1c00-1cff : sym53c8xx
2000-20ff : 0000:03:08.0
2400-24ff : 0000:03:08.1
2800-28ff : 0000:03:09.0
2c00-2cff : 0000:03:09.0
3000-30ff : 0000:03:09.1
3400-34ff : 0000:03:09.1

cat /proc/iomem
00000000-0009d3ff : System RAM
0009d400-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c9000-000ccfff : Extension ROM
000cd000-000cdfff : Extension ROM
000ce000-000cf7ff : Extension ROM
000cf800-000d37ff : Extension ROM
000f0000-000fffff : System ROM
00100000-1feeffff : System RAM
  00100000-002fab1e : Kernel code
  002fab1f-003c633f : Kernel data
1fef0000-1fefefff : ACPI Tables
1feff000-1fefffff : ACPI Non-volatile Storage
1ff00000-1fffffff : System RAM
f8000000-f801ffff : 0000:00:0a.0
  f8000000-f801ffff : e100
f8020000-f8020fff : 0000:00:04.0
f8021000-f8021fff : 0000:00:0a.0
  f8021000-f8021fff : e100
f8022000-f8022fff : 0000:00:0f.2
f9000000-f9ffffff : 0000:00:04.0
fa000000-fa00ffff : 0000:01:09.0
fa010000-fa011fff : 0000:01:0a.0
  fa010000-fa011fff : sym53c8xx
fa012000-fa0123ff : 0000:01:0a.0
  fa012000-fa0123ff : sym53c8xx
fc000000-fdffffff : 0000:01:08.1
fe000000-fe00ffff : 0000:03:08.0
fe010000-fe01ffff : 0000:03:08.0
fe020000-fe02ffff : 0000:03:08.1
fe030000-fe03ffff : 0000:03:08.1
fe040000-fe041fff : 0000:03:09.0
fe042000-fe043fff : 0000:03:09.1
fec00000-fec0ffff : reserved
fee00000-fee00fff : reserved
ffc00000-ffffffff : reserved


[7.5.] PCI information ('lspci -vvv' as root)
/sbin/lspci -vvvv
00:00.0 Host bridge: ServerWorks CNB20HE Host Bridge (rev 23)
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step
ping- SERR- FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR-

00:00.1 Host bridge: ServerWorks CNB20HE Host Bridge (rev 01)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort+ >SERR- <PERR-
        Latency: 64, cache line size 08

00:00.2 Host bridge: ServerWorks: Unknown device 0006 (rev 01)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort+ >SERR- <PERR-

00:00.3 Host bridge: ServerWorks: Unknown device 0006 (rev 01)
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort+ >SERR- <PERR-

00:04.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) (prog-i
f 00 [VGA])
        Subsystem: Siemens Nixdorf AG: Unknown device 007a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step
ping+ SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 66 (2000ns min), cache line size 08
        Region 0: Memory at f9000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: I/O ports at 1000 [size=256]
        Region 2: Memory at f8020000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at <unassigned> [disabled] [size=128K]
        Capabilities: [5c] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 100] (rev 09)
        Subsystem: Siemens Nixdorf AG: Unknown device 004b
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 66 (2000ns min, 14000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 30
        Region 0: Memory at f8021000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at 1400 [size=64]
        Region 2: Memory at f8000000 (32-bit, non-prefetchable) [size=128K]
        Expansion ROM at <unassigned> [disabled] [size=1M]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot
+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

00:0f.0 ISA bridge: ServerWorks OSB4 South Bridge (rev 51)
        Subsystem: ServerWorks OSB4 South Bridge
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 0

00:0f.1 IDE interface: ServerWorks OSB4 IDE Controller (prog-if 8a [Master SecP
PriP])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 4: I/O ports at 1800 [size=16]

00:0f.2 USB Controller: ServerWorks OSB4/CSB5 OHCI USB Controller (rev 04) (prog
-if 10 [OHCI])
        Subsystem: ServerWorks OSB4/CSB5 OHCI USB Controller
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 64 (20000ns max), cache line size 08
        Interrupt: pin A routed to IRQ 28
        Region 0: Memory at f8022000 (32-bit, non-prefetchable) [size=4K]

01:08.0 PCI bridge: Distributed Processing Technology PCI Bridge (rev 02) (prog-
if 00 [Normal decode])
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 64, cache line size 08
        Bus: primary=01, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: 00100000-000fffff
        Prefetchable memory behind bridge: 00100000-000fffff
        BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: [68] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:08.1 I2O: Distributed Processing Technology SmartRAID V Controller (rev 02) (
prog-if 01)
        Subsystem: Distributed Processing Technology 2000S Ultra3 Single Channel
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 64 (250ns min, 250ns max), cache line size 08
        Interrupt: pin A routed to IRQ 20
        BIST result: 00
        Region 0: Memory at fc000000 (32-bit, prefetchable) [size=32M]
        Expansion ROM at <unassigned> [disabled] [size=32K]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:09.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5703 Gigabit Ethe
rnet (rev 02)
        Subsystem: Broadcom Corporation NetXtreme BCM5703 1000Base-T
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 64 (16000ns min), cache line size 08
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fa000000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at <unassigned> [disabled] [size=64K]
        Capabilities: [40] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=0
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple,
DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-      Capabilities: [48] Power Management vers
ion 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/3 Enable
-
                Address: 024000006cc00080  Data: 2221

01:0a.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 66MHz  Ultra3
 SCSI Adapter (rev 01)
        Subsystem: Siemens Nixdorf AG: Unknown device 6030
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 140 (4250ns min, 4500ns max), cache line size 08
        Interrupt: pin A routed to IRQ 29
        Region 0: I/O ports at 1c00 [size=256]
        Region 1: Memory at fa012000 (64-bit, non-prefetchable) [size=1K]
        Region 3: Memory at fa010000 (64-bit, non-prefetchable) [size=8K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

03:08.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 (rev 07)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 1010
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 128 (4000ns min, 1500ns max), cache line size 08
        Interrupt: pin A routed to IRQ 24
        Region 0: I/O ports at 2000 [size=256]
        Region 1: Memory at fe010000 (64-bit, non-prefetchable) [size=64K]
        Region 3: Memory at fe000000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at <unassigned> [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable
-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=0
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple,
DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
03:08.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 (rev 07)
        Subsystem: LSI Logic / Symbios Logic: Unknown device 1010
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 128 (4000ns min, 1500ns max), cache line size 08
        Interrupt: pin B routed to IRQ 25
        Region 0: I/O ports at 2400 [size=256]
        Region 1: Memory at fe030000 (64-bit, non-prefetchable) [size=64K]
        Region 3: Memory at fe020000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at <unassigned> [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable
-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=0
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple,
DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
03:09.0 SCSI storage controller: Adaptec ASC-32320D U320 (rev 03)
        Subsystem: Adaptec ASC-39320D U320
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 72 (10000ns min, 6250ns max), cache line size 08
        Interrupt: pin A routed to IRQ 26
        Region 0: I/O ports at 2c00 [size=256]
        Region 1: Memory at fe040000 (64-bit, non-prefetchable) [size=8K]
        Region 3: I/O ports at 2800 [size=256]
        Expansion ROM at <unassigned> [disabled] [size=512K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable
-
                Address: 0000000000000000  Data: 0000
        Capabilities: [94] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=4
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple,
DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-
03:09.1 SCSI storage controller: Adaptec ASC-32320D U320 (rev 03)
        Subsystem: Adaptec ASC-39320D U320
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr+ Step
ping- SERR+ FastB2B-
        Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort
- <MAbort- >SERR- <PERR-
        Latency: 72 (10000ns min, 6250ns max), cache line size 08
        Interrupt: pin B routed to IRQ 27
        Region 0: I/O ports at 3400 [size=256]
        Region 1: Memory at fe042000 (64-bit, non-prefetchable) [size=8K]
        Region 3: I/O ports at 3000 [size=256]
        Expansion ROM at <unassigned> [disabled] [size=512K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot
-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [a0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable
-
                Address: 0000000000000000  Data: 0000
        Capabilities: [94] PCI-X non-bridge device.
                Command: DPERE- ERO+ RBC=0 OST=4
                Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple,
DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

[7.6.] SCSI information (from /proc/scsi/scsi)
cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 5205
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 5205
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 5205
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 5205
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 08 Lun: 00
  Vendor: SDR      Model: GEM318           Rev: 0
  Type:   Processor                        ANSI SCSI revision: 02

Host: scsi5 Channel: 00 Id: 00 Lun: 00  <<<<This is pseudo target>>>>
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 5306
  Type:   Direct-Access                    ANSI SCSI revision: 03

[7.7.] Other information that might be relevant to the problem
[X.] Other notes, patches, fixes, workarounds:

