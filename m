From: =?ISO-8859-1?Q?G=E9rard_Roudier?= <groudier@free.fr>
Subject: Re: PROBLEM: SYM53C8XX errors while reading tape
Date: Sun, 24 Nov 2002 22:56:10 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021124224205.L1073-100000@localhost.my.domain>
References: <86smxuj8f9.fsf@coulee.tdb.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <86smxuj8f9.fsf@coulee.tdb.com>
List-Id: linux-scsi@vger.kernel.org
To: Russell Senior <seniorr@aracnet.com>
Cc: linux-scsi@vger.kernel.org


Russel,

The source of the problem is a severe error reported by the chip;
Here is what the driver said about:

>   sym0:1: ERROR (0:c8) (1-21-85) (8/13/0) @ (scripta 92c:19001b14).

The relevant part is the c8 value (SIST =3D SCSI Interrupt Status).
Btw there is some notes in the file Documentation.txt supplied with the
sym53c8xx_2 driver (15.2 Understanding hardware error reports).

Here an excerpt:

-- begin --

sym0:1: ERROR (0:48) (1-21-65) (f/95/0) @ (script 7c0:19000000).
=2E....A.........B.C....D.E..F....G.H..I.......J.....K...L.......

=2E..

=46ield C : SIST io register (SCSI Interrupt Status)
  Bit 0x08 : SGE  SCSI GROSS ERROR
             Indicates that the chip detected a severe error condition
             on the SCSI BUS that prevents the SCSI protocol from funct=
ionning
             properly.
  Bit 0x04 : UDC  Undexpected Disconnection
             Indicates that the device released the SCSI BUS when the c=
hip
             was not expecting this to happen. A device may behave so t=
o
             indicate the SCSI initiator that an error condition not re=
portable              using the SCSI protocol has occured.
  Bit 0x02 : RST  SCSI BUS Reset
             Generally SCSI targets donnot reset the SCSI BUS, although=
 any
             device on the BUS can reset it at any time.
  Bit 0x01 : PAR  Parity
             SCSI parity error detected.
  On a faulty SCSI BUS, any error condition among SGE (0x08), UDC (0x04=
) and
  PAR (0x01) may be detected by the chip. If your SCSI system sometimes
  encounters such error conditions, especially SCSI GROSS ERROR, then a=
 SCSI
  BUS problem is likely the cause of these errors.

=46or fields D,E,F,G and H, you may look into the sym53c8xx_defs.h file
that contains some minimal comments on IO register bits.

-- end --

c8 contains bit 8 which indicates a SCSI GROSS ERROR reported by the ch=
ip.
Most of the time a SCSI BUS problem is the cause.

You may check the BUS, check or swap if possible cable and/or terminati=
on
and see if it makes difference.

  G=E9rard.


On 22 Nov 2002, Russell Senior wrote:

>
> [1.] One line summary of the problem:
>
> SYM53C8XX errors while reading tape
>
> [2.] Full description of the problem/report:
>
> I just installed a new Seagate Scorpion 24 tape drive (DDS3 4mm DAT)
> attached to an old NCR53c810 PCI SCSI controller and was trying it
> out.  I did a:
>
>   mt -f /dev/nst0 setblk 32768
>   tar -C / -b 64 -clvf /dev/nst0 .
>
> and that seemed to work fine, but when I tried to verify or read, wit=
h
> something like this:
>
>   mt -f /dev/nst0 rewind
>   tar -C / -b 64 -dlf /dev/nst0
>
> after a variable delay, i.e. some distance through the process, I get
> messages to the shell:
>
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: /dev/nst0: Cannot read: Input/output error
>   tar: Too many errors, quitting
>   tar: Error is not recoverable: exiting now
>
> I can still access the drive afterwards, though the block size gets
> reset.  In /var/log/messages, I see:
>
>   Nov 22 00:07:19 celilo kernel: sym0:1: ERROR (0:c8) (1-21-85) (8/13=
/0) @ (scripta 92c:19001b14).
>   Nov 22 00:07:19 celilo kernel: sym0: script cmd =3D 88080000
>   Nov 22 00:07:19 celilo kernel: sym0: regdump: da 10 80 13 47 08 01 =
1f 00 01 81 21 80 00 09 00 00 20 e9 37 08 ff ff ff.
>   Nov 22 00:07:19 celilo kernel: sym0: SCSI BUS reset detected.
>   Nov 22 00:07:20 celilo kernel: sym0: SCSI BUS has been reset.
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Current =
st09:00: sense key Unit Attention
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Power on,=
reset,or bus device reset occurred
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>   Nov 22 00:07:23 celilo kernel: st0: Error with sense data: Info fld=
=3D0x0, Current st09:00: sense key Not Ready
>   Nov 22 00:07:23 celilo kernel: Additional sense indicates Logical u=
nit is in process of becoming ready
>
> This particular set of messages came under linux-2.4.18, but I had
> seen what seemed like the same thing under linux-2.5.40 and regressed
> to 2.4.18 to see if it was a kernel specific problem.
>
> I don't know what the /sbin/fsck those messages mean, in particular
> the originating error message, codes and register dump.  Basically,
> that is what I am looking for, some indication what the problem might=
 be.
>
> [3.] Keywords (i.e., modules, networking, kernel):
>
> SCSI, error message
>
> [4.] Kernel version (from /proc/version):
>
>   Linux version 2.4.18 (root@celilo) (gcc version 2.95.4 20011002 (De=
bian prerelease)) #2 SMP Sat Jun 1 21:08:44 PDT 2002
>
> [7.] Environment
> [7.1.] Software (add the output of the ver_linux script here)
>
>   Linux celilo 2.4.18 #2 SMP Sat Jun 1 21:08:44 PDT 2002 i686 unknown=
 unknown GNU/Linux
>
>   Gnu C                  2.95.4
>   Gnu make               3.80
>   util-linux             2.11u
>   mount                  2.11u
>   modutils               2.4.19
>   e2fsprogs              1.32
>   Linux C Library        2.3.1
>   Dynamic linker (ldd)   2.3.1
>   Procps                 3.1.0
>   Net-tools              1.60
>   Kbd                    1.06
>   Sh-utils               4.5.3
>   Modules Loaded         ide-scsi
>
> [7.2.] Processor information (from /proc/cpuinfo):
>
>   processor       : 0
>   vendor_id       : GenuineIntel
>   cpu family      : 6
>   model           : 8
>   model name      : Pentium III (Coppermine)
>   stepping        : 6
>   cpu MHz         : 999.530
>   cache size      : 256 KB
>   fdiv_bug        : no
>   hlt_bug         : no
>   f00f_bug        : no
>   coma_bug        : no
>   fpu             : yes
>   fpu_exception   : yes
>   cpuid level     : 2
>   wp              : yes
>   flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr =
pge mca cmov pat pse36 mmx fxsr sse
>   bogomips        : 1992.29
>
>   processor       : 1
>   vendor_id       : GenuineIntel
>   cpu family      : 6
>   model           : 8
>   model name      : Pentium III (Coppermine)
>   stepping        : 6
>   cpu MHz         : 999.530
>   cache size      : 256 KB
>   fdiv_bug        : no
>   hlt_bug         : no
>   f00f_bug        : no
>   coma_bug        : no
>   fpu             : yes
>   fpu_exception   : yes
>   cpuid level     : 2
>   wp              : yes
>   flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr =
pge mca cmov pat pse36 mmx fxsr sse
>   bogomips        : 1998.84
>
> [7.3.] Module information (from /proc/modules):
>
>   ide-scsi                7808   0
>
> [7.4.] Loaded driver and hardware information (/proc/ioports, /proc/i=
omem)
>
>   $ cat /proc/ioports
>   0000-001f : dma1
>   0020-003f : pic1
>   0040-005f : timer
>   0060-006f : keyboard
>   0070-007f : rtc
>   0080-008f : dma page reg
>   00a0-00bf : pic2
>   00c0-00df : dma2
>   00f0-00ff : fpu
>   0170-0177 : ide1
>   01f0-01f7 : ide0
>   02f8-02ff : serial(set)
>   0376-0376 : ide1
>   03c0-03df : vga+
>   03f6-03f6 : ide0
>   03f8-03ff : serial(set)
>   0cf8-0cff : PCI conf1
>   a000-a007 : Promise Technology, Inc. 20268
>     a000-a007 : ide2
>   a400-a403 : Promise Technology, Inc. 20268
>     a402-a402 : ide2
>   a800-a807 : Promise Technology, Inc. 20268
>     a800-a807 : ide3
>   ac00-ac03 : Promise Technology, Inc. 20268
>     ac02-ac02 : ide3
>   b000-b00f : Promise Technology, Inc. 20268
>     b000-b007 : ide2
>     b008-b00f : ide3
>   b010-b01f : PDC20268
>   b400-b4ff : 3Dfx Interactive, Inc. Voodoo 3
>   b800-b8ff : LSI Logic / Symbios Logic (formerly NCR) 53c810
>     b800-b87f : sym53c8xx
>   bc00-bc1f : Creative Labs SB Live! EMU10k1
>   c000-c007 : Creative Labs SB Live!
>   c400-c407 : Promise Technology, Inc. 20267
>   c800-c803 : Promise Technology, Inc. 20267
>   cc00-cc07 : Promise Technology, Inc. 20267
>   d000-d003 : Promise Technology, Inc. 20267
>   d400-d43f : Promise Technology, Inc. 20267
>     d400-d407 : ide4
>     d408-d40f : ide5
>     d410-d43f : PDC20267
>   d800-d83f : Intel Corp. 82557 [Ethernet Pro 100]
>     d800-d83f : eepro100
>   dc00-dc0f : VIA Technologies, Inc. Bus Master IDE
>     dc00-dc07 : ide0
>     dc08-dc0f : ide1
>   e000-e01f : VIA Technologies, Inc. UHCI USB
>     e000-e01f : usb-uhci
>   e400-e41f : VIA Technologies, Inc. UHCI USB (#2)
>     e400-e41f : usb-uhci
>   e800-e81f : VIA Technologies, Inc. UHCI USB (#3)
>     e800-e81f : usb-uhci
>
>   $ cat /proc/iomem
>   00000000-0009fbff : System RAM
>   0009fc00-0009ffff : reserved
>   000a0000-000bffff : Video RAM area
>   000c0000-000c7fff : Video ROM
>   000d0000-000d27ff : Extension ROM
>   000d3000-000dafff : Extension ROM
>   000f0000-000fffff : System ROM
>   00100000-3ffeffff : System RAM
>     00100000-00266894 : Kernel code
>     00266895-002d1a9f : Kernel data
>   3fff0000-3fff2fff : ACPI Non-volatile Storage
>   3fff3000-3fffffff : ACPI Tables
>   f8000000-f9ffffff : 3Dfx Interactive, Inc. Voodoo 3
>   fa000000-fbffffff : 3Dfx Interactive, Inc. Voodoo 3
>   fd000000-fd3fffff : VIA Technologies, Inc. VT8633 [Apollo Pro266]
>   fd400000-fd4fffff : Intel Corp. 82557 [Ethernet Pro 100]
>   fd500000-fd51ffff : Promise Technology, Inc. 20267
>   fd520000-fd523fff : Promise Technology, Inc. 20268
>   fd524000-fd524fff : Intel Corp. 82557 [Ethernet Pro 100]
>     fd524000-fd524fff : eepro100
>   fd525000-fd5250ff : LSI Logic / Symbios Logic (formerly NCR) 53c810
>   fec00000-ffffffff : reserved
>
> [7.5.] PCI information ('lspci -vvv' as root)
>
>   00:00.0 Host bridge: VIA Technologies, Inc. VT8633 [Apollo Pro266] =
(rev 01)
>   	Subsystem: Super Micro Computer Inc: Unknown device 2166
>   	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort+ >SERR- <PERR-
>   	Latency: 8
>   	Region 0: Memory at fd000000 (32-bit, prefetchable) [size=3D4M]
>   	Capabilities: [a0] AGP version 2.0
>   		Status: RQ=3D31 SBA+ 64bit- FW- Rate=3Dx1,x2
>   		Command: RQ=3D0 SBA- AGP- 64bit- FW- Rate=3D<none>
>   	Capabilities: [c0] Power Management version 2
>   		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:01.0 PCI bridge: VIA Technologies, Inc. VT8633 [Apollo Pro266 AG=
P] (prog-if 00 [Normal decode])
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort+ >SERR- <PERR-
>   	Latency: 0
>   	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D=
0
>   	I/O behind bridge: 0000f000-00000fff
>   	Memory behind bridge: fff00000-000fffff
>   	Prefetchable memory behind bridge: fff00000-000fffff
>   	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
>   	Capabilities: [80] Power Management version 2
>   		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:07.0 Unknown mass storage controller: Promise Technology, Inc. 2=
0268 (rev 02) (prog-if 85)
>   	Subsystem: Promise Technology, Inc. Ultra100TX2
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=3Dslow >TAbort- <=
TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32 (1000ns min, 4500ns max), cache line size 08
>   	Interrupt: pin A routed to IRQ 5
>   	Region 0: I/O ports at a000 [size=3D8]
>   	Region 1: I/O ports at a400 [size=3D4]
>   	Region 2: I/O ports at a800 [size=3D8]
>   	Region 3: I/O ports at ac00 [size=3D4]
>   	Region 4: I/O ports at b000 [size=3D16]
>   	Region 5: Memory at fd520000 (32-bit, non-prefetchable) [size=3D16=
K]
>   	Expansion ROM at <unassigned> [disabled] [size=3D16K]
>   	Capabilities: [60] Power Management version 1
>   		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:08.0 VGA compatible controller: 3Dfx Interactive, Inc. Voodoo 3 =
(rev 01) (prog-if 00 [VGA])
>   	Subsystem: 3Dfx Interactive, Inc. Voodoo3
>   	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <=
TAbort- <MAbort- >SERR- <PERR+
>   	Interrupt: pin A routed to IRQ 10
>   	Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=3D32=
M]
>   	Region 1: Memory at fa000000 (32-bit, prefetchable) [size=3D32M]
>   	Region 2: I/O ports at b400 [size=3D256]
>   	Expansion ROM at <unassigned> [disabled] [size=3D64K]
>   	Capabilities: [60] Power Management version 1
>   		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:09.0 SCSI storage controller: LSI Logic / Symbios Logic (formerl=
y NCR) 53c810 (rev 02)
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
+ Stepping- SERR- FastB2B-
>   	Status: Cap- 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32
>   	Interrupt: pin A routed to IRQ 11
>   	Region 0: I/O ports at b800 [size=3D256]
>   	Region 1: Memory at fd525000 (32-bit, non-prefetchable) [size=3D25=
6]
>
>   00:0a.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1=
 (rev 08)
>   	Subsystem: Creative Labs: Unknown device 8071
>   	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32 (500ns min, 5000ns max)
>   	Interrupt: pin A routed to IRQ 11
>   	Region 0: I/O ports at bc00 [size=3D32]
>   	Capabilities: [dc] Power Management version 2
>   		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:0a.1 Input device controller: Creative Labs SB Live! MIDI/Game P=
ort (rev 08)
>   	Subsystem: Creative Labs Gameport Joystick
>   	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32
>   	Region 0: I/O ports at c000 [size=3D8]
>   	Capabilities: [dc] Power Management version 2
>   		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:0c.0 RAID bus controller: Promise Technology, Inc. 20267 (rev 02=
)
>   	Subsystem: Promise Technology, Inc. Fasttrak100
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32
>   	Interrupt: pin A routed to IRQ 10
>   	Region 0: I/O ports at c400 [size=3D8]
>   	Region 1: I/O ports at c800 [size=3D4]
>   	Region 2: I/O ports at cc00 [size=3D8]
>   	Region 3: I/O ports at d000 [size=3D4]
>   	Region 4: I/O ports at d400 [size=3D64]
>   	Region 5: Memory at fd500000 (32-bit, non-prefetchable) [size=3D12=
8K]
>   	Expansion ROM at <unassigned> [disabled] [size=3D64K]
>   	Capabilities: [58] Power Management version 1
>   		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:0d.0 Ethernet controller: Intel Corp. 82557/8/9 [Ethernet Pro 10=
0] (rev 08)
>   	Subsystem: Intel Corp. EtherExpress PRO/100+ Server Adapter (PILA8=
470B)
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32 (2000ns min, 14000ns max), cache line size 08
>   	Interrupt: pin A routed to IRQ 11
>   	Region 0: Memory at fd524000 (32-bit, non-prefetchable) [size=3D4K=
]
>   	Region 1: I/O ports at d800 [size=3D64]
>   	Region 2: Memory at fd400000 (32-bit, non-prefetchable) [size=3D1M=
]
>   	Expansion ROM at <unassigned> [disabled] [size=3D1M]
>   	Capabilities: [dc] Power Management version 2
>   		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3ho=
t+,D3cold+)
>   		Status: D0 PME-Enable+ DSel=3D0 DScale=3D2 PME-
>
>   00:11.0 ISA bridge: VIA Technologies, Inc. VT8233 PCI to ISA Bridge
>   	Subsystem: Super Micro Computer Inc: Unknown device 2166
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping+ SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 0
>   	Capabilities: [c0] Power Management version 2
>   		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:11.1 IDE interface: VIA Technologies, Inc. Bus Master IDE (rev 0=
6) (prog-if 8a [Master SecP PriP])
>   	Subsystem: Super Micro Computer Inc: Unknown device 2166
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32
>   	Region 4: I/O ports at dc00 [size=3D16]
>   	Capabilities: [c0] Power Management version 2
>   		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:11.2 USB Controller: VIA Technologies, Inc. USB (rev 1b) (prog-i=
f 00 [UHCI])
>   	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32, cache line size 08
>   	Interrupt: pin D routed to IRQ 11
>   	Region 4: I/O ports at e000 [size=3D32]
>   	Capabilities: [80] Power Management version 2
>   		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:11.3 USB Controller: VIA Technologies, Inc. USB (rev 1b) (prog-i=
f 00 [UHCI])
>   	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32, cache line size 08
>   	Interrupt: pin D routed to IRQ 11
>   	Region 4: I/O ports at e400 [size=3D32]
>   	Capabilities: [80] Power Management version 2
>   		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>   00:11.4 USB Controller: VIA Technologies, Inc. USB (rev 1b) (prog-i=
f 00 [UHCI])
>   	Subsystem: VIA Technologies, Inc. (Wrong ID) USB Controller
>   	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr=
- Stepping- SERR- FastB2B-
>   	Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort-=
 <TAbort- <MAbort- >SERR- <PERR-
>   	Latency: 32, cache line size 08
>   	Interrupt: pin D routed to IRQ 11
>   	Region 4: I/O ports at e800 [size=3D32]
>   	Capabilities: [80] Power Management version 2
>   		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3ho=
t-,D3cold-)
>   		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>
>
>
> [7.6.] SCSI information (from /proc/scsi/scsi)
>
>   $ cat /proc/scsi/scsi
>   Attached devices:
>   Host: scsi0 Channel: 00 Id: 01 Lun: 00
>     Vendor: ARCHIVE  Model: Python 04106-XXX Rev: 7350
>     Type:   Sequential-Access                ANSI SCSI revision: 02
>   Host: scsi1 Channel: 00 Id: 00 Lun: 00
>     Vendor: DualPort Model:  Reader 2        Rev:
>     Type:   Direct-Access                    ANSI SCSI revision: 02
>   Host: scsi1 Channel: 00 Id: 00 Lun: 01
>     Vendor: DualPort Model:  Reader 2        Rev:
>     Type:   Direct-Access                    ANSI SCSI revision: 02
>
>
> [7.7.] Other information that might be relevant to the problem
>        (please look in /proc and include all information that you
>        think to be relevant):
>
> Here are the relevant messages from dmesg:
>
>   SCSI subsystem driver Revision: 1.00
>   sym.0.9.0: setting PCI_COMMAND_PARITY...
>   sym0: <810> rev 0x2 on pci bus 0 device 9 function 0 irq 11
>   sym0: No NVRAM, ID 7, Fast-10, SE, parity checking
>   sym0: SCSI BUS has been reset.
>   scsi0 : sym-2.1.17a
>     Vendor: ARCHIVE   Model: Python 04106-XXX  Rev: 7350
>     Type:   Sequential-Access                  ANSI SCSI revision: 02
>   st: Version 20020205, bufsize 32768, wrt 30720, max init. bufs 4, s=
/g segs 16
>   Attached scsi tape st0 at scsi0, channel 0, id 1, lun 0
>
>   [...]
>
>   sym0:1: FAST-10 SCSI 10.0 MB/s ST (100.0 ns, offset 8)
>   st0: Block limits 1 - 16777215 bytes.
>
> This is the end of the boot messages, then when the error occurs, I
> get the following:
>
>   sym0:1: ERROR (0:c8) (1-21-85) (8/13/0) @ (scripta 92c:19001b14).
>   sym0: script cmd =3D 88080000
>   sym0: regdump: da 10 80 13 47 08 01 1f 00 01 81 21 80 00 09 00 00 2=
0 e9 37 08 ff ff ff.
>   sym0: SCSI BUS reset detected.
>   sym0: SCSI BUS has been reset.
>   st0: Error with sense data: Current st09:00: sense key Unit Attenti=
on
>   Additional sense indicates Power on,reset,or bus device reset occur=
red
>   st0: Error with sense data: Info fld=3D0x0, Current st09:00: sense =
key Not Ready
>   Additional sense indicates Logical unit is in process of becoming r=
eady
>
>   [...]
>
>
> --
> Russell Senior         ``I've seen every kind of critter God ever mad=
e,
> seniorr@aracnet.com      and I ain't never seen a meaner, lower, more
>                          stinkin' yellow hypocrite than you!''
>                                         -- Burl Ives as Rufus Henness=
y
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
