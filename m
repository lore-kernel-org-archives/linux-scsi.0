From: "jah" <jahng@clan-rum.org>
Subject: 29160 causing server to hang
Date: Tue, 26 Aug 2003 13:58:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0bc001c36bfb$9c85e5d0$1e00000a@ARRISI.COM>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thrash.clan-rum.org ([198.78.96.19]:5541 "EHLO clan-rum.org")
	by vger.kernel.org with ESMTP id S262758AbTHZSBG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2003 14:01:06 -0400
Received: from PCJHANEY1 (client.antec.com [63.86.74.77] (may be forged))
	by clan-rum.org (8.12.8/8.12.8) with ESMTP id h7QI13H8027813
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2003 14:01:05 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I could really use and would appreciate some expert help with this problem
which has been reoccurring for over a year.  My Adaptec 29160 card is
causing my server to hang, requiring a hard reboot to reset, during periods
of sustained i/o.  The system is an Athlon 1000, Asus A7V motherboard
running Redhat 9.0, kernel 2.4.20 with an Adaptec 29160 adapter and two
Maxtor Atlas 10K IV 147 gig drives. Once a day I do a diskcopy from the
primary drive to the secondary as a backup (dd if=/dev/sda of=/dev/sdb
bs=65536). This period of intense and sustained i/o causes the system to
hang periodically (about once or twice a week).  This has been a reoccurring
problem since I installed the 29160 and ultra160 drives. The problem seems
to be independent of the operating system, kernel and scsi driver version as
well as the model of drive. Originally I was running Redhat 7.0 with the
29160 and two 18 gig Seagates. After a lot of problems and a couple of total
drive failures, I replaced the cheesy 3dcool drive coolers (which I think
were actually causing the drives to overheat rather than preventing it) with
PC Power and cooling drive bay coolers. This seemed to cure the problem
until I added two additional drives. I upgraded (or rather did a fresh
install) to Redhat 9.0 and at the same time added two additional drives,
Seagate 70 gig. The system started hanging again during the diskcopies.
Convinced that the problem was the Seagate drives, I replaced them with the
Maxtor drives (which are ultra320) but the system is still hanging during
the disk copy.  Things I have done since this started:

1. Swapped the 29160 card with an identical card from another computer
2. Upgraded the firmware on the 29160 to the latest rev (3.10.0)
3. Replaced the generic brand cable with an adaptec cable (both ultra160
certified of course)
4. Replaced the 3dcool drive cooler with PC Power and Cooling Bay-Cool (this
helped with the 18 gig drives but when I added the two 70 gig, the problem
started up again)
5. Upgraded the system from Redhat 7.0 to Redhat 9.0
6. Replaced the Seagates (ultra160) with Maxtor (ultra320) drives.

Obviously the longer the disk copy takes, the more likely the system is to
hang. The 18 gigs take about 15 minutes to copy and once I scrapped the
3dcool heatsink cooler contraption the system no longer locked up. But with
the 70 gig Seagates or 147 gig Maxtors, which take 60/120 minutes to copy,
the system continues to hang periodically.  Can anybody help?

Some of the messages I get during the dd:

Aug 25 05:49:57 server kernel: (scsi0:A:0:0): data overrun detected in
Data-in phase.  Tag == 0x25.
Aug 25 05:49:57 server kernel: (scsi0:A:0:0): Have seen Data Phase.  Length
= 131072.  NumSGs = 32.
Aug 25 05:49:57 server kernel: sg[0] - Addr 0x011de1000 : Length 4096
Aug 25 05:49:57 server kernel: sg[1] - Addr 0x0bcb7000 : Length 4096
Aug 25 05:49:57 server kernel: sg[2] - Addr 0x07e7d000 : Length 4096
Aug 25 05:49:57 server kernel: sg[3] - Addr 0x039cc000 : Length 4096
Aug 25 05:49:57 server kernel: sg[4] - Addr 0x02b5b000 : Length 4096
Aug 25 05:49:57 server kernel: sg[5] - Addr 0x01c376000 : Length 4096
Aug 25 05:49:57 server kernel: sg[6] - Addr 0x086dd000 : Length 4096
Aug 25 05:49:57 server kernel: sg[7] - Addr 0x01cdcb000 : Length 4096
Aug 25 05:49:57 server kernel: sg[8] - Addr 0x019a15000 : Length 4096
Aug 25 05:49:57 server kernel: sg[9] - Addr 0x0fe0b000 : Length 4096
Aug 25 05:49:57 server kernel: sg[10] - Addr 0x0162ae000 : Length 4096
Aug 25 05:49:57 server kernel: sg[11] - Addr 0x0dba3000 : Length 4096
Aug 25 05:49:57 server kernel: sg[12] - Addr 0x0f6f0000 : Length 4096
Aug 25 05:49:57 server kernel: sg[13] - Addr 0x013501000 : Length 4096
Aug 25 05:49:57 server kernel: sg[14] - Addr 0x01fb63000 : Length 4096
Aug 25 05:49:57 server kernel: sg[15] - Addr 0x01c7ff000 : Length 4096
Aug 25 05:49:57 server kernel: sg[16] - Addr 0x068e000 : Length 4096
Aug 25 05:49:57 server kernel: sg[17] - Addr 0x0a33000 : Length 4096
Aug 25 05:49:57 server kernel: sg[18] - Addr 0x0a32000 : Length 4096
Aug 25 05:49:57 server kernel: sg[19] - Addr 0x0d20000 : Length 4096
Aug 25 05:49:57 server kernel: sg[20] - Addr 0x0f52000 : Length 4096
Aug 25 05:49:57 server kernel: sg[21] - Addr 0x03ba000 : Length 4096
Aug 25 05:49:57 server kernel: sg[22] - Addr 0x0e57000 : Length 4096
Aug 25 05:49:57 server kernel: sg[23] - Addr 0x06ad000 : Length 4096
Aug 25 05:49:57 server kernel: sg[24] - Addr 0x0da2000 : Length 4096
Aug 25 05:49:57 server kernel: sg[25] - Addr 0x0c93000 : Length 4096
Aug 25 05:49:57 server kernel: sg[26] - Addr 0x0c27000 : Length 4096
Aug 25 05:49:57 server kernel: sg[27] - Addr 0x06d2000 : Length 4096
Aug 25 05:49:57 server kernel: sg[28] - Addr 0x0782000 : Length 4096
Aug 25 05:49:57 server kernel: sg[29] - Addr 0x03bf000 : Length 4096
Aug 25 05:49:57 server kernel: sg[30] - Addr 0x0f28000 : Length 4096
Aug 25 05:49:57 server kernel: sg[31] - Addr 0x0bd6000 : Length 4096
Aug 25 05:52:36 server kernel: (scsi0:A:1:0): data overrun detected in
Data-in phase.  Tag == 0x30.
Aug 25 05:52:36 server kernel: (scsi0:A:1:0): Have seen Data Phase.  Length
= 262144.  NumSGs = 64.
Aug 25 05:52:36 server kernel: sg[0] - Addr 0x07fb7000 : Length 4096
Aug 25 05:52:36 server kernel: sg[1] - Addr 0x05511000 : Length 4096
Aug 25 05:52:36 server kernel: sg[2] - Addr 0x0baa0000 : Length 4096
Aug 25 05:52:36 server kernel: sg[3] - Addr 0x01cf51000 : Length 4096
Aug 25 05:52:36 server kernel: sg[4] - Addr 0x0df79000 : Length 4096
Aug 25 05:52:36 server kernel: sg[5] - Addr 0x01c9f7000 : Length 4096
Aug 25 05:52:36 server kernel: sg[6] - Addr 0x0c20a000 : Length 4096
Aug 25 05:52:36 server kernel: sg[7] - Addr 0x0137bf000 : Length 4096
Aug 25 05:52:36 server kernel: sg[8] - Addr 0x0b0e2000 : Length 4096
Aug 25 05:52:36 server kernel: sg[9] - Addr 0x01736a000 : Length 4096
Aug 25 05:52:36 server kernel: sg[10] - Addr 0x0dce7000 : Length 4096
Aug 25 05:52:36 server kernel: sg[11] - Addr 0x04cc2000 : Length 4096
Aug 25 05:52:36 server kernel: sg[12] - Addr 0x012b57000 : Length 4096
Aug 25 05:52:36 server kernel: sg[13] - Addr 0x012715000 : Length 4096
Aug 25 05:52:36 server kernel: sg[14] - Addr 0x0dc2a000 : Length 4096
Aug 25 05:52:36 server kernel: sg[15] - Addr 0x03a64000 : Length 4096
Aug 25 05:52:36 server kernel: sg[16] - Addr 0x0888f000 : Length 4096
Aug 25 05:52:36 server kernel: sg[17] - Addr 0x0b5dc000 : Length 4096
Aug 25 05:52:36 server kernel: sg[18] - Addr 0x06452000 : Length 4096
Aug 25 05:52:36 server kernel: sg[19] - Addr 0x01e2a8000 : Length 4096
Aug 25 05:52:36 server kernel: sg[20] - Addr 0x01d78000 : Length 4096
Aug 25 05:52:36 server kernel: sg[21] - Addr 0x07075000 : Length 4096
Aug 25 05:52:36 server kernel: sg[22] - Addr 0x01f181000 : Length 4096
Aug 25 05:52:36 server kernel: sg[23] - Addr 0x02e15000 : Length 4096
Aug 25 05:52:36 server kernel: sg[24] - Addr 0x015af4000 : Length 4096
Aug 25 05:52:36 server kernel: sg[25] - Addr 0x016a1e000 : Length 4096
Aug 25 05:52:36 server kernel: sg[26] - Addr 0x01c63000 : Length 4096
Aug 25 05:52:36 server kernel: sg[27] - Addr 0x01a80b000 : Length 4096
Aug 25 05:52:36 server kernel: sg[28] - Addr 0x0784e000 : Length 4096
Aug 25 05:52:36 server kernel: sg[29] - Addr 0x0170bb000 : Length 4096
Aug 25 05:52:36 server kernel: sg[30] - Addr 0x0508b000 : Length 4096
Aug 25 05:52:36 server kernel: sg[31] - Addr 0x01bf9b000 : Length 4096
Aug 25 05:52:36 server kernel: sg[32] - Addr 0x05bcf000 : Length 4096
Aug 25 05:52:36 server kernel: sg[33] - Addr 0x0133e5000 : Length 4096
Aug 25 05:52:36 server kernel: sg[34] - Addr 0x0176d5000 : Length 4096
Aug 25 05:52:36 server kernel: sg[35] - Addr 0x0f4bd000 : Length 4096
Aug 25 05:52:36 server kernel: sg[36] - Addr 0x01a30000 : Length 4096
Aug 25 05:52:36 server kernel: sg[37] - Addr 0x0b7b3000 : Length 4096
Aug 25 05:52:36 server kernel: sg[38] - Addr 0x01ec80000 : Length 4096
Aug 25 05:52:36 server kernel: sg[39] - Addr 0x010f5e000 : Length 4096
Aug 25 05:52:36 server kernel: sg[40] - Addr 0x07f69000 : Length 4096
Aug 25 05:52:36 server kernel: sg[41] - Addr 0x04896000 : Length 4096
Aug 25 05:52:36 server kernel: sg[42] - Addr 0x013e70000 : Length 4096
Aug 25 05:52:36 server kernel: sg[43] - Addr 0x0f6bd000 : Length 4096
Aug 25 05:52:36 server kernel: sg[44] - Addr 0x0889f000 : Length 4096
Aug 25 05:52:36 server kernel: sg[45] - Addr 0x01c528000 : Length 4096
Aug 25 05:52:36 server kernel: sg[46] - Addr 0x019615000 : Length 4096
Aug 25 05:52:36 server kernel: sg[47] - Addr 0x01cdef000 : Length 4096
Aug 25 05:52:36 server kernel: sg[48] - Addr 0x01c6aa000 : Length 4096
Aug 25 05:52:36 server kernel: sg[49] - Addr 0x0ff82000 : Length 4096
Aug 25 05:52:36 server kernel: sg[50] - Addr 0x013294000 : Length 4096
Aug 25 05:52:36 server kernel: sg[51] - Addr 0x073bb000 : Length 4096
Aug 25 05:52:36 server kernel: sg[52] - Addr 0x08b88000 : Length 4096
Aug 25 05:52:37 server kernel: sg[53] - Addr 0x0526e000 : Length 4096
Aug 25 05:52:37 server kernel: sg[54] - Addr 0x0b06c000 : Length 4096
Aug 25 05:52:37 server kernel: sg[55] - Addr 0x07e35000 : Length 4096
Aug 25 05:52:37 server kernel: sg[56] - Addr 0x01f49a000 : Length 4096
Aug 25 05:52:37 server kernel: sg[57] - Addr 0x01016b000 : Length 4096
Aug 25 05:52:37 server kernel: sg[58] - Addr 0x01e906000 : Length 4096
Aug 25 05:52:37 server kernel: sg[59] - Addr 0x0b622000 : Length 4096
Aug 25 05:52:37 server kernel: sg[60] - Addr 0x072c9000 : Length 4096
Aug 25 05:52:37 server kernel: sg[61] - Addr 0x010eb4000 : Length 4096
Aug 25 05:52:37 server kernel: sg[62] - Addr 0x01f70c000 : Length 4096
Aug 25 05:52:37 server kernel: sg[63] - Addr 0x0fc81000 : Length 4096

lspci -vv -a

00:00.0 Class 0600: 1106:0305 (rev 02)
 Subsystem: 1043:8033
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort+ >SERR- <PERR+
 Latency: 0
 Region 0: Memory at e7800000 (32-bit, prefetchable) [size=4M]
 Capabilities: [a0] AGP version 2.0
  Status: RQ=31 SBA+ 64bit- FW- Rate=x1,x2
  Command: RQ=0 SBA- AGP- 64bit- FW- Rate=<none>
 Capabilities: [c0] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 Class 0604: 1106:8305
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort+ >SERR- <PERR-
 Latency: 0
 Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
 BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
 Capabilities: [80] Power Management version 2
  Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.0 Class 0601: 1106:0686 (rev 22)
 Subsystem: 1043:8033
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 0

00:04.1 Class 0101: 1106:0571 (rev 10) (prog-if 8a [Master SecP PriP])
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Region 4: I/O ports at d800 [disabled] [size=16]
 Capabilities: [c0] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.4 Class 0600: 1106:3057 (rev 30)
 Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Interrupt: pin ? routed to IRQ 9
 Capabilities: [68] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.0 Class 0100: 9005:0080 (rev 02)
 Subsystem: 9005:e2a0
 Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 32 (10000ns min, 6250ns max), cache line size 08
 Interrupt: pin A routed to IRQ 12
 BIST result: 00
 Region 0: I/O ports at a400 [disabled] [size=256]
 Region 1: Memory at e4800000 (64-bit, non-prefetchable) [size=4K]
 Expansion ROM at <unassigned> [disabled] [size=128K]
 Capabilities: [dc] Power Management version 2
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0b.0 Class 0604: 1011:0024 (rev 03)
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 32, cache line size 08
 Bus: primary=00, secondary=02, subordinate=02, sec-latency=32
 I/O behind bridge: 00009000-00009fff
 Memory behind bridge: e3800000-e47fffff
 Prefetchable memory behind bridge: 00000000e5700000-00000000e7600000
 BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
 Capabilities: [dc] Power Management version 1
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=220mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
  Bridge: PM- B3+

00:0c.0 Class 0300: 1002:4758 (rev 03)
 Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping+ SERR- FastB2B-
 Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Region 0: Memory at e2000000 (32-bit, non-prefetchable) [size=16M]
 Expansion ROM at 000c0000 [disabled] [size=64K]

00:11.0 Class 0180: 105a:0d30 (rev 02)
 Subsystem: 105a:4d33
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 32
 Interrupt: pin A routed to IRQ 11
 Region 0: I/O ports at 8800 [size=8]
 Region 1: I/O ports at 8400 [size=4]
 Region 2: I/O ports at 8000 [size=8]
 Region 3: I/O ports at 7800 [size=4]
 Region 4: I/O ports at 7400 [size=64]
 Region 5: Memory at e1800000 (32-bit, non-prefetchable) [size=128K]
 Expansion ROM at <unassigned> [disabled] [size=64K]
 Capabilities: [58] Power Management version 1
  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:04.0 Class 0200: 8086:1229 (rev 05)
 Subsystem: 8086:10f0
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 32 (2000ns min, 14000ns max), cache line size 08
 Interrupt: pin A routed to IRQ 11
 Region 0: Memory at e6800000 (32-bit, prefetchable) [size=4K]
 Region 1: I/O ports at 9800 [size=32]
 Region 2: Memory at e4000000 (32-bit, non-prefetchable) [size=1M]
 Expansion ROM at <unassigned> [disabled] [size=1M]
 Capabilities: [dc] Power Management version 1
  Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

02:05.0 Class 0200: 8086:1229 (rev 05)
 Subsystem: 8086:10f0
 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B-
 Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort-
<MAbort- >SERR- <PERR-
 Latency: 32 (2000ns min, 14000ns max), cache line size 08
 Interrupt: pin A routed to IRQ 10
 Region 0: Memory at e5800000 (32-bit, prefetchable) [size=4K]
 Region 1: I/O ports at 9400 [size=32]
 Region 2: Memory at e3800000 (32-bit, non-prefetchable) [size=1M]
 Expansion ROM at <unassigned> [disabled] [size=1M]
 Capabilities: [dc] Power Management version 1
  Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
  Status: D0 PME-Enable- DSel=0 DScale=0 PME-

dmesg:

Linux version 2.4.20-20.9custom (root@localhost) (gcc version 3.2.2 20030222
(Red Hat Linux 3.2.2-5)) #2 Tue Aug 26 11:22:35 EDT 2003
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001ffec000 (usable)
 BIOS-e820: 000000001ffec000 - 000000001ffef000 (ACPI data)
 BIOS-e820: 000000001ffef000 - 000000001ffff000 (reserved)
 BIOS-e820: 000000001ffff000 - 0000000020000000 (ACPI NVS)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
511MB LOWMEM available.
On node 0 totalpages: 131052
zone(0): 4096 pages.
zone(1): 126956 pages.
zone(2): 0 pages.
Kernel command line: ro root=/dev/sda2 nomodules
Initializing CPU#0
Detected 1009.013 MHz processor.
Console: colour VGA+ 80x25
Calibrating delay loop... 2011.95 BogoMIPS
Memory: 512468k/524208k available (1554k kernel code, 9176k reserved, 331k
data, 260k init, 0k highmem)
Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
Inode cache hash table entries: 32768 (order: 6, 262144 bytes)
Mount cache hash table entries: 512 (order: 0, 4096 bytes)
Buffer-cache hash table entries: 32768 (order: 5, 131072 bytes)
Page-cache hash table entries: 131072 (order: 7, 524288 bytes)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU:     After generic, caps: 0183f9ff c1c7f9ff 00000000 00000000
CPU:             Common caps: 0183f9ff c1c7f9ff 00000000 00000000
CPU: AMD Athlon(tm) Processor stepping 02
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
mtrr: detected mtrr type: Intel
PCI: PCI BIOS revision 2.10 entry at 0xf10f0, last bus=2
PCI: Using configuration type 1
PCI: Probing PCI hardware
Disabling VIA memory write queue (PCI ID 0305, rev 02): [55] 81 & 1f -> 01
PCI: Using IRQ router VIA [1106/0686] at 00:04.0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
apm: BIOS version 1.2 Flags 0x0b (Driver version 1.16)
Starting kswapd
VFS: Disk quotas vdquot_6.5.1
Journalled Block Device driver loaded
pty: 256 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ
SERIAL_PCI ISAPNP enabled
ttyS0 at 0x03f8 (irq = 4) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
loop: loaded (max 8 devices)
eepro100.c:v1.09j-t 9/29/99 Donald Becker
http://www.scyld.com/network/eepro100.html
eepro100.c: $Revision: 1.36 $ 2000/11/17 Modified by Andrey V. Savochkin
<saw@saw.sw.com.sg> and others
eth0: Intel Corp. 82557/8/9 [Ethernet Pro 100], 00:D0:B7:5E:74:7E, IRQ 11.
  Receiver lock-up bug exists -- enabling work-around.
  Board assembly 711269-004, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x24c9f043).
  Receiver lock-up workaround activated.
eth1: Intel Corp. 82557/8/9 [Ethernet Pro 100] (#2), 00:D0:B7:5E:74:7F, IRQ
10.
  Receiver lock-up bug exists -- enabling work-around.
  Board assembly 711269-004, Physical connectors present: RJ45
  Primary interface chip i82555 PHY #1.
  General self-test: passed.
  Serial sub-system self-test: passed.
  Internal registers self-test: passed.
  ROM checksum self-test: passed (0x24c9f043).
  Receiver lock-up workaround activated.
SCSI subsystem driver Revision: 1.00
PCI: Found IRQ 12 for device 00:09.0
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

  Vendor: MAXTOR    Model: ATLAS10K4_146WLS  Rev: DFL0
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: MAXTOR    Model: ATLAS10K4_146WLS  Rev: DFL0
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: TOSHIBA   Model: CD-ROM XM-3601TA  Rev: 0725
  Type:   CD-ROM                             ANSI SCSI revision: 02
scsi0:A:0:0: Tagged Queuing enabled.  Depth 253
scsi0:A:1:0: Tagged Queuing enabled.  Depth 253
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
(scsi0:A:0): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
SCSI device sda: 287332384 512-byte hdwr sectors (147114 MB)
Partition check:
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 sda13
sda14 sda15 >
(scsi0:A:1): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
SCSI device sdb: 287332384 512-byte hdwr sectors (147114 MB)
 sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 sdb9 sdb10 sdb11 sdb12 sdb13
sdb14 sdb15 >
Attached scsi CD-ROM sr0 at scsi0, channel 0, id 5, lun 0
sr0: scsi-1 drive
Uniform CD-ROM driver Revision: 3.12
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP
IP: routing cache hash table of 4096 buckets, 32Kbytes
TCP: Hash tables configured (established 32768 bind 65536)
ip_conntrack version 2.1 (4095 buckets, 32760 max) - 152 bytes per conntrack
ip_tables: (C) 2000-2002 Netfilter core team
arp_tables: (C) 2002 David S. Miller
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 260k freed
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,2), internal journal
Adding Swap: 248996k swap-space (priority -1)
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,5), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,6), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,8), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,7), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,9), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,10), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,11), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,12), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,13), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,14), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on sd(8,15), internal journal
EXT3-fs: mounted filesystem with ordered data mode.

