From: Mateusz.Blaszczyk@nask.pl
Subject: Re: 2.6.9-rc4mm1:badness in drivers/scsi/scsi_lib.c
Date: Tue, 26 Oct 2004 09:57:01 +0200 (CEST)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.GSO.4.58.0410260947280.22299@boromir>
References: <Pine.LNX.4.44L0.0410211039420.2736-100000@ida.rowland.org>
Reply-To: Mateusz.Blaszczyk@nask.pl
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0410211039420.2736-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, 21 Oct 2004, Alan Stern wrote:

> On Thu, 21 Oct 2004 Mateusz.Blaszczyk@nask.pl wrote:
>
> > > > After successful write on USB DVD-R writer (HP-200j), system oops=
's when unpluging USB device.
> > > > Same thing with 2.6.9-rc2mm1.
> > >
> > > Try applying this patch:
> > >
> > > http://marc.theaimsgroup.com/?l=3Dlinux-usb-devel&m=3D1097442348293=
47&q=3Draw
> >
> > Patch applied.
> > I have done the tests at still no good.
> > I connected and disconnected the writer a couple of times. WHen I did=
n't
> > read/write on the CD there is no OOPS when disconnecting. But after r=
eading CD
> > there was OOPS when disconnecting. See below. Decoded OOPS - see more=
 below.
>
> Can you turn on the usb-storage verbose debugging option in the kernel
> configuration and then try running your test over again?  Be sure also =
to
> set up /etc/syslog.conf to capture debug-level kernel messages.


Well, I think I must admit I was wrong.

I have done some tests and there was no ooops after succesful writing or =
after
unmounting device. The oops is when I unplug USB-DVD-Recorder when there =
is
already mounted device on it.

Then there is state transition from NULL->cancel and kernel oops!
See oops and decoded oops below:


I noticed other thing. When I plug and unplug device, DVD-Recorder is see=
n on a
new scsi bus number, starting from 0. Is it ok?

------------------------------ OOPS -------------------------------------=
--
Oct 26 09:08:36 localhost kernel: klogd 1.4.1#15, log source =3D /proc/km=
sg started.
Oct 26 09:08:36 localhost kernel: Inspecting /boot/System.map-2.6.9-rc4mm=
1
Oct 26 09:08:36 localhost kernel: Loaded 33021 symbols from /boot/System.=
map-2.6.9-rc4mm1.
Oct 26 09:08:36 localhost kernel: Symbols match kernel version 2.6.9.
Oct 26 09:08:36 localhost kernel: No module symbols loaded - kernel modul=
es not enabled.
Oct 26 09:08:36 localhost kernel: PU: Intel(R) Pentium(R) M processor 130=
0MHz stepping 05
Oct 26 09:08:36 localhost kernel: Enabling fast FPU save and restore... d=
one.
Oct 26 09:08:36 localhost kernel: Enabling unmasked SIMD FPU exception su=
pport... done.
Oct 26 09:08:36 localhost kernel: Checking 'hlt' instruction... OK.
Oct 26 09:08:36 localhost kernel: ACPI: IRQ9 SCI: Edge set to Level Trigg=
er.
Oct 26 09:08:36 localhost kernel: NET: Registered protocol family 16
Oct 26 09:08:36 localhost kernel: PCI: PCI BIOS revision 2.10 entry at 0x=
fd9b2, last bus=3D3
Oct 26 09:08:36 localhost kernel: PCI: Using configuration type 1
Oct 26 09:08:36 localhost kernel: mtrr: v2.0 (20020519)
Oct 26 09:08:36 localhost kernel: ACPI: Subsystem revision 20040816
Oct 26 09:08:36 localhost kernel: ACPI: Interpreter enabled
Oct 26 09:08:36 localhost kernel: ACPI: Using PIC for interrupt routing
Oct 26 09:08:36 localhost kernel: ACPI: PCI Root Bridge [PCI0] (00:00)
Oct 26 09:08:36 localhost kernel: PCI: Probing PCI hardware (bus 00)
Oct 26 09:08:36 localhost kernel: PCI: Ignoring BAR0-3 of IDE controller =
0000:00:1f.1
Oct 26 09:08:36 localhost kernel: PCI: Transparent bridge - 0000:00:1e.0
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB=
_.PCI0._PRT]
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3=
 4 5 7 9 10 *11)
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3=
 4 5 7 9 10 *11)
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3=
 4 5 7 9 10 *11)
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3=
 4 5 7 9 10 *11)
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3=
 4 5 7 9 10 *11)
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3=
 4 5 7 9 10 11) *0, disabled.
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3=
 4 5 7 9 10 11) *0, disabled.
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3=
 4 5 7 9 10 *11)
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Routing Table [\_SB=
_.PCI0.HUB_._PRT]
Oct 26 09:08:36 localhost kernel: Linux Plug and Play Support v0.97 (c) A=
dam Belay
Oct 26 09:08:36 localhost kernel: PnPBIOS: Scanning system for PnP BIOS s=
upport...
Oct 26 09:08:36 localhost kernel: PnPBIOS: Found PnP BIOS installation st=
ructure at 0xc00f59d0
Oct 26 09:08:36 localhost kernel: PnPBIOS: PnP BIOS version 1.0, entry 0x=
f0000:0xa62a, dseg 0x400
Oct 26 09:08:36 localhost kernel: PnPBIOS: 18 nodes reported by PnP BIOS;=
 18 recorded by driver
Oct 26 09:08:36 localhost kernel: SCSI subsystem initialized
Oct 26 09:08:36 localhost kernel: Linux Kernel Card Services
Oct 26 09:08:36 localhost kernel:   options:  [pci] [cardbus] [pm]
Oct 26 09:08:36 localhost kernel: usbcore: registered new driver usbfs
Oct 26 09:08:36 localhost kernel: usbcore: registered new driver hub
Oct 26 09:08:36 localhost kernel: PCI: Using ACPI for IRQ routing
Oct 26 09:08:36 localhost kernel: ** PCI interrupts are no longer routed =
automatically.  If this
Oct 26 09:08:36 localhost kernel: ** causes a device to stop working, it =
is probably because the
Oct 26 09:08:36 localhost kernel: ** driver failed to call pci_enable_dev=
ice().  As a temporary
Oct 26 09:08:36 localhost kernel: ** workaround, the "pci=3Drouteirq" arg=
ument restores the old
Oct 26 09:08:36 localhost kernel: ** behavior.  If this argument makes th=
e device work again,
Oct 26 09:08:36 localhost kernel: ** please email the output of "lspci" t=
o bjorn.helgaas@hp.com
Oct 26 09:08:36 localhost kernel: ** so I can fix the driver.
Oct 26 09:08:36 localhost kernel: irda_init()
Oct 26 09:08:36 localhost kernel: NET: Registered protocol family 23
Oct 26 09:08:36 localhost kernel: Simple Boot Flag at 0x7f set to 0x1
Oct 26 09:08:36 localhost kernel: Machine check exception polling timer s=
tarted.
Oct 26 09:08:36 localhost kernel: Initializing Cryptographic API
Oct 26 09:08:36 localhost kernel: pci_hotplug: PCI Hot Plug PCI Core vers=
ion: 0.5
Oct 26 09:08:36 localhost kernel: acpiphp: ACPI Hot Plug PCI Controller D=
river version: 0.4
Oct 26 09:08:36 localhost kernel: vesafb: framebuffer at 0xd8000000, mapp=
ed to 0xd0080000, using 1536k, total 8000k
Oct 26 09:08:36 localhost kernel: vesafb: mode is 1024x768x8, linelength=3D=
1024, pages=3D9
Oct 26 09:08:36 localhost kernel: vesafb: protected mode interface info a=
t 00ff:44f0
Oct 26 09:08:36 localhost kernel: vesafb: scrolling: redraw
Oct 26 09:08:36 localhost kernel: vesafb: Pseudocolor: size=3D8:8:8:8, sh=
ift=3D0:0:0:0
Oct 26 09:08:36 localhost kernel: Console: switching to colour frame buff=
er device 128x48
Oct 26 09:08:36 localhost kernel: fb0: VESA VGA frame buffer device
Oct 26 09:08:36 localhost kernel: isapnp: Scanning for PnP cards...
Oct 26 09:08:36 localhost kernel: isapnp: No Plug & Play device found
Oct 26 09:08:36 localhost kernel: Real Time Clock Driver v1.12
Oct 26 09:08:36 localhost kernel: ACPI: PS/2 Keyboard Controller [KBC] at=
 I/O 0x60, 0x64, irq 1
Oct 26 09:08:36 localhost kernel: ACPI: PS/2 Mouse Controller [PS2M] at i=
rq 12
Oct 26 09:08:36 localhost kernel: i8042.c: Detected active multiplexing c=
ontroller, rev 1.9.
Oct 26 09:08:36 localhost kernel: serio: i8042 AUX0 port at 0x60,0x64 irq=
 12
Oct 26 09:08:36 localhost kernel: serio: i8042 AUX1 port at 0x60,0x64 irq=
 12
Oct 26 09:08:36 localhost kernel: serio: i8042 AUX2 port at 0x60,0x64 irq=
 12
Oct 26 09:08:36 localhost kernel: serio: i8042 AUX3 port at 0x60,0x64 irq=
 12
Oct 26 09:08:36 localhost kernel: serio: i8042 KBD port at 0x60,0x64 irq =
1
Oct 26 09:08:36 localhost kernel: Serial: 8250/16550 driver $Revision: 1.=
90 $ 8 ports, IRQ sharing disabled
Oct 26 09:08:36 localhost kernel: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 165=
50A
Oct 26 09:08:36 localhost kernel: ttyS3 at I/O 0x2e8 (irq =3D 3) is a 165=
50A
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKB] enabled=
 at IRQ 11
Oct 26 09:08:36 localhost kernel: PCI: setting IRQ 11 as level-triggered
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:00:1f.6[B] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: io scheduler noop registered
Oct 26 09:08:36 localhost kernel: io scheduler cfq registered
Oct 26 09:08:36 localhost kernel: loop: loaded (max 8 devices)
Oct 26 09:08:36 localhost kernel: Uniform Multi-Platform E-IDE driver Rev=
ision: 7.00alpha2
Oct 26 09:08:36 localhost kernel: ide: Assuming 33MHz system bus speed fo=
r PIO modes; override with idebus=3Dxx
Oct 26 09:08:36 localhost kernel: ICH4: IDE controller at PCI slot 0000:0=
0:1f.1
Oct 26 09:08:36 localhost kernel: PCI: Enabling device 0000:00:1f.1 (0005=
 -> 0007)
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKC] enabled=
 at IRQ 11
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:00:1f.1[A] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: ICH4: chipset revision 3
Oct 26 09:08:36 localhost kernel: ICH4: not 100%% native mode: will probe=
 irqs later
Oct 26 09:08:36 localhost kernel:     ide0: BM-DMA at 0x1810-0x1817, BIOS=
 settings: hda:DMA, hdb:pio
Oct 26 09:08:36 localhost kernel:     ide1: BM-DMA at 0x1818-0x181f, BIOS=
 settings: hdc:DMA, hdd:pio
Oct 26 09:08:36 localhost kernel: Probing IDE interface ide0...
Oct 26 09:08:36 localhost kernel: hda: FUJITSU MHT2020AT, ATA DISK drive
Oct 26 09:08:36 localhost kernel: elevator: using cfq as default io sched=
uler
Oct 26 09:08:36 localhost kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Oct 26 09:08:36 localhost kernel: Probing IDE interface ide1...
Oct 26 09:08:36 localhost kernel: hdc: TOSHIBA DVD-ROM SD-R2412, ATAPI CD=
/DVD-ROM drive
Oct 26 09:08:36 localhost kernel: ide1 at 0x170-0x177,0x376 on irq 15
Oct 26 09:08:36 localhost kernel: Probing IDE interface ide2...
Oct 26 09:08:36 localhost kernel: ide2: Wait for ready failed before prob=
e !
Oct 26 09:08:36 localhost kernel: Probing IDE interface ide3...
Oct 26 09:08:36 localhost kernel: ide3: Wait for ready failed before prob=
e !
Oct 26 09:08:36 localhost kernel: Probing IDE interface ide4...
Oct 26 09:08:36 localhost kernel: ide4: Wait for ready failed before prob=
e !
Oct 26 09:08:36 localhost kernel: Probing IDE interface ide5...
Oct 26 09:08:36 localhost kernel: ide5: Wait for ready failed before prob=
e !
Oct 26 09:08:36 localhost kernel: hda: max request size: 128KiB
Oct 26 09:08:36 localhost kernel: hda: 39070080 sectors (20003 MB) w/2048=
KiB Cache, CHS=3D38760/16/63, UDMA(100)
Oct 26 09:08:36 localhost kernel: hda: cache flushes supported
Oct 26 09:08:36 localhost kernel:  hda: hda1 hda2 hda4
Oct 26 09:08:36 localhost kernel: hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2=
048kB Cache, UDMA(33)
Oct 26 09:08:36 localhost kernel: Uniform CD-ROM driver Revision: 3.20
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKA] enabled=
 at IRQ 11
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:01:0a.0[A] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: Yenta: CardBus bridge found at 0000:01:=
0a.0 [10cf:10e7]
Oct 26 09:08:36 localhost kernel: Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Oct 26 09:08:36 localhost kernel: Socket status: 30000006
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:01:0a.1[B] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: Yenta: CardBus bridge found at 0000:01:=
0a.1 [10cf:10e7]
Oct 26 09:08:36 localhost kernel: Yenta: ISA IRQ mask 0x04b8, PCI irq 11
Oct 26 09:08:36 localhost kernel: Socket status: 30000006
Oct 26 09:08:36 localhost kernel: ehci_hcd: block sizes: qh 128 qtd 96 it=
d 192 sitd 96
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKH] enabled=
 at IRQ 11
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:00:1d.7[D] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: Intel Corp. 8280=
1DB/DBM (ICH4/ICH4-M) USB 2.0 EHCI Controller
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: reset hcs_params=
 0x103206 dbg=3D1 cc=3D3 pcc=3D2 ordered !ppc ports=3D6
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: reset hcc_params=
 6871 thresh 7 uframes 1024 64 bit addr
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: capability 0001 =
at 68
Oct 26 09:08:36 localhost kernel: PCI: Setting latency timer of device 00=
00:00:1d.7 to 64
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: irq 11, pci mem =
0xd0100000
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: new USB bus regi=
stered, assigned bus number 1
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: reset command 08=
0002 (park)=3D0 ithresh=3D8 period=3D1024 Reset HALT
Oct 26 09:08:36 localhost kernel: PCI: cache line size of 32 is not suppo=
rted by device 0000:00:1d.7
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: init command 010=
001 (park)=3D0 ithresh=3D1 period=3D1024 RUN
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: USB 2.0 enabled,=
 EHCI 1.00, driver 2004-May-10
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: supports USB rem=
ote wakeup
Oct 26 09:08:36 localhost kernel: usb usb1: new device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Oct 26 09:08:36 localhost kernel: usb usb1: default language 0x0409
Oct 26 09:08:36 localhost kernel: usb usb1: Product: Intel Corp. 82801DB/=
DBM (ICH4/ICH4-M) USB 2.0 EHCI Controller
Oct 26 09:08:36 localhost kernel: usb usb1: Manufacturer: Linux 2.6.9-rc4=
mm1 ehci_hcd
Oct 26 09:08:36 localhost kernel: usb usb1: SerialNumber: 0000:00:1d.7
Oct 26 09:08:36 localhost kernel: usb usb1: hotplug
Oct 26 09:08:36 localhost kernel: usb usb1: adding 1-0:1.0 (config #1, in=
terface 0)
Oct 26 09:08:36 localhost kernel: usb 1-0:1.0: hotplug
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: usb_probe_interface
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: usb_probe_interface - got =
id
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: USB hub found
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: 6 ports detected
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: standalone hub
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: ganged power switching
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: individual port over-curre=
nt protection
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: Single TT
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: TT requires at most 8 FS b=
it times
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: power on to power good tim=
e: 20ms
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: local power source is good
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: enabling power on all port=
s
Oct 26 09:08:36 localhost kernel: USB Universal Host Controller Interface=
 driver v2.2
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:00:1d.0[A] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.0: Intel Corp. 8280=
1DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: GetStatus port 3=
 status 001403 POWER sig=3Dk  CSC CONNECT
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: port 3, status 0501, chang=
e 0001, 480 Mb/s
Oct 26 09:08:36 localhost kernel: PCI: Setting latency timer of device 00=
00:00:1d.0 to 64
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.0: irq 11, io base =
0x1820
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.0: new USB bus regi=
stered, assigned bus number 2
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.0: detected 2 ports
Oct 26 09:08:36 localhost kernel: usb usb2: new device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Oct 26 09:08:36 localhost kernel: usb usb2: default language 0x0409
Oct 26 09:08:36 localhost kernel: usb usb2: Product: Intel Corp. 82801DB/=
DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1
Oct 26 09:08:36 localhost kernel: usb usb2: Manufacturer: Linux 2.6.9-rc4=
mm1 uhci_hcd
Oct 26 09:08:36 localhost kernel: usb usb2: SerialNumber: 0000:00:1d.0
Oct 26 09:08:36 localhost kernel: usb usb2: hotplug
Oct 26 09:08:36 localhost kernel: usb usb2: adding 2-0:1.0 (config #1, in=
terface 0)
Oct 26 09:08:36 localhost kernel: usb 2-0:1.0: hotplug
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: usb_probe_interface
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: usb_probe_interface - got =
id
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: USB hub found
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: 2 ports detected
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: standalone hub
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: no power switching (usb 1.=
0)
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: individual port over-curre=
nt protection
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: power on to power good tim=
e: 2ms
Oct 26 09:08:36 localhost kernel: hub 2-0:1.0: local power source is good
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKD] enabled=
 at IRQ 11
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:00:1d.1[B] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.1: Intel Corp. 8280=
1DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2
Oct 26 09:08:36 localhost kernel: hub 1-0:1.0: debounce: port 3: total 10=
0ms stable 100ms status 0x501
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: port 3 low speed=
 --> companion
Oct 26 09:08:36 localhost kernel: PCI: Setting latency timer of device 00=
00:00:1d.1 to 64
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.1: irq 11, io base =
0x1840
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.1: new USB bus regi=
stered, assigned bus number 3
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.1: detected 2 ports
Oct 26 09:08:36 localhost kernel: usb usb3: new device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Oct 26 09:08:36 localhost kernel: usb usb3: default language 0x0409
Oct 26 09:08:36 localhost kernel: usb usb3: Product: Intel Corp. 82801DB/=
DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2
Oct 26 09:08:36 localhost kernel: usb usb3: Manufacturer: Linux 2.6.9-rc4=
mm1 uhci_hcd
Oct 26 09:08:36 localhost kernel: usb usb3: SerialNumber: 0000:00:1d.1
Oct 26 09:08:36 localhost kernel: usb usb3: hotplug
Oct 26 09:08:36 localhost kernel: usb usb3: adding 3-0:1.0 (config #1, in=
terface 0)
Oct 26 09:08:36 localhost kernel: usb 3-0:1.0: hotplug
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: usb_probe_interface
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: usb_probe_interface - got =
id
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: USB hub found
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: 2 ports detected
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: standalone hub
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: no power switching (usb 1.=
0)
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: individual port over-curre=
nt protection
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: power on to power good tim=
e: 2ms
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: local power source is good
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:00:1d.2[C] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.2: Intel Corp. 8280=
1DB/DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3
Oct 26 09:08:36 localhost kernel: ehci_hcd 0000:00:1d.7: GetStatus port 3=
 status 003002 POWER OWNER sig=3Dse0  CSC
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.1: port 1 portsc 01=
a3,00
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: port 1, status 0301, chang=
e 0001, 1.5 Mb/s
Oct 26 09:08:36 localhost kernel: PCI: Setting latency timer of device 00=
00:00:1d.2 to 64
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.2: irq 11, io base =
0x1860
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.2: new USB bus regi=
stered, assigned bus number 4
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.2: detected 2 ports
Oct 26 09:08:36 localhost kernel: usb usb4: new device strings: Mfr=3D3, =
Product=3D2, SerialNumber=3D1
Oct 26 09:08:36 localhost kernel: usb usb4: default language 0x0409
Oct 26 09:08:36 localhost kernel: usb usb4: Product: Intel Corp. 82801DB/=
DBL/DBM (ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3
Oct 26 09:08:36 localhost kernel: usb usb4: Manufacturer: Linux 2.6.9-rc4=
mm1 uhci_hcd
Oct 26 09:08:36 localhost kernel: usb usb4: SerialNumber: 0000:00:1d.2
Oct 26 09:08:36 localhost kernel: usb usb4: hotplug
Oct 26 09:08:36 localhost kernel: usb usb4: adding 4-0:1.0 (config #1, in=
terface 0)
Oct 26 09:08:36 localhost kernel: usb 4-0:1.0: hotplug
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: usb_probe_interface
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: usb_probe_interface - got =
id
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: USB hub found
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: 2 ports detected
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: standalone hub
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: no power switching (usb 1.=
0)
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: individual port over-curre=
nt protection
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: power on to power good tim=
e: 2ms
Oct 26 09:08:36 localhost kernel: hub 4-0:1.0: local power source is good
Oct 26 09:08:36 localhost kernel: mice: PS/2 mouse device common for all =
mice
Oct 26 09:08:36 localhost kernel: hub 3-0:1.0: debounce: port 1: total 10=
0ms stable 100ms status 0x301
Oct 26 09:08:36 localhost kernel: usb 3-1: new low speed USB device using=
 address 2
Oct 26 09:08:36 localhost kernel: input: AT Translated Set 2 keyboard on =
isa0060/serio0
Oct 26 09:08:36 localhost kernel: usb 3-1: skipped 1 descriptor after int=
erface
Oct 26 09:08:36 localhost kernel: usb 3-1: new device strings: Mfr=3D1, P=
roduct=3D2, SerialNumber=3D0
Oct 26 09:08:36 localhost kernel: usb 3-1: default language 0x0409
Oct 26 09:08:36 localhost kernel: usb 3-1: Product: USB Optical Mouse
Oct 26 09:08:36 localhost kernel: usb 3-1: Manufacturer: A4Tech
Oct 26 09:08:36 localhost kernel: usb 3-1: hotplug
Oct 26 09:08:36 localhost kernel: usb 3-1: adding 3-1:1.0 (config #1, int=
erface 0)
Oct 26 09:08:36 localhost kernel: usb 3-1:1.0: hotplug
Oct 26 09:08:36 localhost kernel: input: PS/2 Generic Mouse on isa0060/se=
rio4
Oct 26 09:08:36 localhost kernel: Please email the following PERFCTR INIT=
 lines to mikpe@csd.uu.se
Oct 26 09:08:36 localhost kernel: To remove this message, rebuild the dri=
ver with CONFIG_PERFCTR_INIT_TESTS=3Dn
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: vendor 0, family 6, model=
 9, stepping 5, clock 1300497 kHz
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: NITER =3D=3D 64
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: loop overhead is 277 cycl=
es
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: rdtsc cost is 49.6 cycles=
 (3457 total)
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: rdpmc cost is 41.3 cycles=
 (2923 total)
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: rdmsr (counter) cost is 9=
5.2 cycles (6372 total)
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: rdmsr (evntsel) cost is 8=
0.8 cycles (5453 total)
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: wrmsr (counter) cost is 1=
43.3 cycles (9450 total)
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: wrmsr (evntsel) cost is 1=
31.8 cycles (8716 total)
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: read cr4 cost is 2.5 cycl=
es (443 total)
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: write cr4 cost is 49.6 cy=
cles (3454 total)
Oct 26 09:08:36 localhost kernel: PERFCTR INIT: sync_core cost is 141.0 c=
ycles (9306 total)
Oct 26 09:08:36 localhost kernel: perfctr: driver 2.7.5, cpu type Intel P=
6 at 1300497 kHz
Oct 26 09:08:36 localhost kernel: Advanced Linux Sound Architecture Drive=
r Version 1.0.6 (Sun Aug 15 07:17:53 2004 UTC).
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:00:1f.5[B] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: PCI: Setting latency timer of device 00=
00:00:1f.5 to 64
Oct 26 09:08:36 localhost kernel: ALSA sound/pci/ac97/ac97_codec.c:2498: =
ac97 quirk for Fujitsu-Siemens E4010 (10cf:11c3)
Oct 26 09:08:36 localhost kernel: intel8x0_measure_ac97_clock: measured 4=
9346 usecs
Oct 26 09:08:36 localhost kernel: intel8x0: clocking to 48000
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:00:1f.6[B] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: PCI: Setting latency timer of device 00=
00:00:1f.6 to 64
Oct 26 09:08:36 localhost kernel: ALSA device list:
Oct 26 09:08:36 localhost kernel:   #0: Intel 82801DB-ICH4 with STAC9766/=
67 at 0xd0100c00, irq 11
Oct 26 09:08:36 localhost kernel:   #1: Intel 82801DB-ICH4 Modem at 0x240=
0, irq 11
Oct 26 09:08:36 localhost kernel: NET: Registered protocol family 2
Oct 26 09:08:36 localhost kernel: IP: routing cache hash table of 2048 bu=
ckets, 16Kbytes
Oct 26 09:08:36 localhost kernel: TCP: Hash tables configured (establishe=
d 16384 bind 32768)
Oct 26 09:08:36 localhost kernel: NET: Registered protocol family 1
Oct 26 09:08:36 localhost kernel: IrCOMM protocol (Dag Brattli)
Oct 26 09:08:36 localhost kernel: speedstep-centrino: found "Intel(R) Pen=
tium(R) M processor 1300MHz": max frequency: 1300000kHz
Oct 26 09:08:36 localhost kernel: ACPI: (supports S0 S3 S4 S5)
Oct 26 09:08:36 localhost kernel: ACPI wakeup devices:
Oct 26 09:08:36 localhost kernel: UAR1  HUB A97M  LID
Oct 26 09:08:36 localhost kernel: ReiserFS: hda1: found reiserfs format "=
3.6" with standard journal
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.0: suspend_hc
Oct 26 09:08:36 localhost kernel: uhci_hcd 0000:00:1d.2: suspend_hc
Oct 26 09:08:36 localhost kernel: ReiserFS: hda1: using ordered data mode
Oct 26 09:08:36 localhost kernel: ReiserFS: hda1: journal params: device =
hda1, size 8192, journal first block 18, max trans len 1024, max batch 90=
0, max commit age 30, max trans age 30
Oct 26 09:08:36 localhost kernel: ReiserFS: hda1: checking transaction lo=
g (hda1)
Oct 26 09:08:36 localhost kernel: ReiserFS: hda1: replayed 55 transaction=
s in 13 seconds
Oct 26 09:08:36 localhost kernel: ReiserFS: hda1: Using r5 hash to sort n=
ames
Oct 26 09:08:36 localhost kernel: VFS: Mounted root (reiserfs filesystem)=
 readonly.
Oct 26 09:08:36 localhost kernel: Freeing unused kernel memory: 148k free=
d
Oct 26 09:08:36 localhost kernel: Adding 1020116k swap on /dev/hda4.  Pri=
ority:-1 extents:1
Oct 26 09:08:36 localhost kernel: input: PC Speaker
Oct 26 09:08:36 localhost kernel: parport: PnPBIOS parport detected.
Oct 26 09:08:36 localhost kernel: parport0: PC-style at 0x378, irq 7 [PCS=
PP(,...)]
Oct 26 09:08:36 localhost kernel: Linux agpgart interface v0.100 (c) Dave=
 Jones
Oct 26 09:08:36 localhost kernel: agpgart: Detected an Intel 855 Chipset.
Oct 26 09:08:36 localhost kernel: agpgart: Maximum main memory to use for=
 agp memory: 195M
Oct 26 09:08:36 localhost kernel: agpgart: Detected 8060K stolen memory.
Oct 26 09:08:36 localhost kernel: agpgart: AGP aperture is 128M @ 0xd8000=
000
Oct 26 09:08:36 localhost kernel: hw_random hardware driver 1.0.0 loaded
Oct 26 09:08:36 localhost kernel: 8139too Fast Ethernet driver 0.9.27
Oct 26 09:08:36 localhost kernel: ACPI: PCI Interrupt Link [LNKE] enabled=
 at IRQ 11
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:01:0c.0[A] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: eth0: RealTek RTL8139 at 0xd0070000, 00=
:0b:5d:06:94:1c, IRQ 11
Oct 26 09:08:36 localhost kernel: eth0:  Identified 8139 chip type 'RTL-8=
100B/8139D'
Oct 26 09:08:36 localhost kernel: ieee80211_crypt: registered algorithm '=
NULL'
Oct 26 09:08:36 localhost kernel: ipw2100: Intel(R) PRO/Wireless 2100 Net=
work Driver, 0.56
Oct 26 09:08:36 localhost kernel: ipw2100: Copyright(c) 2003-2004 Intel C=
orporation
Oct 26 09:08:36 localhost kernel: ACPI: PCI interrupt 0000:01:0d.0[A] -> =
GSI 11 (level, low) -> IRQ 11
Oct 26 09:08:36 localhost kernel: usbcore: registered new driver hiddev
Oct 26 09:08:36 localhost kernel: usbhid 3-1:1.0: usb_probe_interface
Oct 26 09:08:36 localhost kernel: usbhid 3-1:1.0: usb_probe_interface - g=
ot id
Oct 26 09:08:36 localhost kernel: input: USB HID v1.10 Mouse [A4Tech USB =
Optical Mouse] on usb-0000:00:1d.1-1
Oct 26 09:08:36 localhost kernel: usbcore: registered new driver usbhid
Oct 26 09:08:36 localhost kernel: drivers/usb/input/hid-core.c: v2.0:USB =
HID core driver
Oct 26 09:08:36 localhost kernel: eth0: link up, 100Mbps, full-duplex, lp=
a 0x41E1
Oct 26 09:08:36 localhost kernel: ip_tables: (C) 2000-2002 Netfilter core=
 team
Oct 26 09:08:36 localhost kernel: ip_conntrack version 2.1 (1975 buckets,=
 15800 max) - 300 bytes per conntrack
Oct 26 09:08:36 localhost kernel: ACPI: Battery Slot [CMB1] (battery pres=
ent)
Oct 26 09:08:36 localhost kernel: ACPI: Battery Slot [CMB2] (battery abse=
nt)
Oct 26 09:08:36 localhost kernel: ACPI: AC Adapter [AC] (on-line)
Oct 26 09:08:36 localhost kernel: ACPI: Processor [CPU0] (supports C1 C2 =
C3)
Oct 26 09:08:36 localhost kernel: ACPI: Power Button (FF) [PWRF]
Oct 26 09:08:36 localhost kernel: ACPI: Lid Switch [LID]
Oct 26 09:08:43 localhost kernel: lp0: using parport0 (interrupt-driven).
Oct 26 09:08:52 localhost kernel: sirdev_get_instance - ttyS3
Oct 26 09:08:52 localhost kernel: irtty_open - ttyS3: irda line disciplin=
e opened
Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0100-0x04ff: exclud=
ing 0x400-0x407 0x4d0-0x4d7
Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0800-0x08ff: clean.
Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0c00-0x0cff: clean.
Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0a00-0x0aff: clean.
Oct 26 09:08:53 localhost kernel: irlap_change_speed(), setting speed to =
9600
Oct 26 09:08:57 localhost kernel: pktcdvd: v0.2.0a 2004-07-14 Jens Axboe =
(axboe@suse.de) and petero2@telia.com
Oct 26 09:08:57 localhost kernel: cdrom: This disc doesn't have any track=
s I recognize!
Oct 26 09:08:57 localhost kernel: pktcdvd: writer pktcdvd0 mapped to hdc
Oct 26 09:09:21 localhost kernel: ehci_hcd 0000:00:1d.7: GetStatus port 1=
 status 001803 POWER sig=3Dj  CSC CONNECT
Oct 26 09:09:21 localhost kernel: hub 1-0:1.0: port 1, status 0501, chang=
e 0001, 480 Mb/s
Oct 26 09:09:21 localhost kernel: hub 1-0:1.0: debounce: port 1: total 10=
0ms stable 100ms status 0x501
Oct 26 09:09:21 localhost kernel: hub 1-0:1.0: port 1 not reset yet, wait=
ing 50ms
Oct 26 09:09:21 localhost kernel: ehci_hcd 0000:00:1d.7: port 1 high spee=
d
Oct 26 09:09:21 localhost kernel: ehci_hcd 0000:00:1d.7: GetStatus port 1=
 status 001005 POWER sig=3Dse0  PE CONNECT
Oct 26 09:09:21 localhost kernel: usb 1-1: new high speed USB device usin=
g address 3
Oct 26 09:09:22 localhost kernel: usb 1-1: new device strings: Mfr=3D73, =
Product=3D89, SerialNumber=3D109
Oct 26 09:09:22 localhost kernel: usb 1-1: default language 0x0409
Oct 26 09:09:22 localhost kernel: usb 1-1: Product: USB Storage Adapter
Oct 26 09:09:22 localhost kernel: usb 1-1: Manufacturer: Hewlett-Packard
Oct 26 09:09:22 localhost kernel: usb 1-1: SerialNumber: 0000000000032558
Oct 26 09:09:22 localhost kernel: usb 1-1: hotplug
Oct 26 09:09:22 localhost kernel: usb 1-1: adding 1-1:2.0 (config #2, int=
erface 0)
Oct 26 09:09:22 localhost kernel: usb 1-1:2.0: hotplug
Oct 26 09:09:22 localhost kernel: Initializing USB Mass Storage driver...
Oct 26 09:09:22 localhost kernel: usb-storage 1-1:2.0: usb_probe_interfac=
e
Oct 26 09:09:22 localhost kernel: usb-storage 1-1:2.0: usb_probe_interfac=
e - got id
Oct 26 09:09:22 localhost kernel: usb-storage: USB Mass Storage device de=
tected
Oct 26 09:09:22 localhost kernel: usb-storage: -- associate_dev
Oct 26 09:09:22 localhost kernel: usb-storage: Vendor: 0x03f0, Product: 0=
x0507, Revision: 0x0310
Oct 26 09:09:22 localhost kernel: usb-storage: Interface Subclass: 0x06, =
Protocol: 0x50
Oct 26 09:09:22 localhost kernel: usb-storage: Vendor: Hewlett-Packard,  =
Product: USB Storage Adapter
Oct 26 09:09:22 localhost kernel: usb-storage: Transport: Bulk
Oct 26 09:09:22 localhost kernel: usb-storage: Protocol: Transparent SCSI
Oct 26 09:09:22 localhost kernel: usb-storage: usb_stor_control_msg: rq=3D=
fe rqtype=3Da1 value=3D0000 index=3D00 len=3D1
Oct 26 09:09:22 localhost kernel: usb-storage: GetMaxLUN command result i=
s 1, data is 0
Oct 26 09:09:23 localhost kernel: scsi0 : SCSI emulation for USB Mass Sto=
rage devices
Oct 26 09:09:23 localhost kernel: usbcore: registered new driver usb-stor=
age
Oct 26 09:09:23 localhost kernel: USB Mass Storage support registered.
Oct 26 09:09:23 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:23 localhost kernel: usb-storage: device found at 3
Oct 26 09:09:23 localhost kernel: usb-storage: waiting for device to sett=
le before scanning
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Command INQUIRY (6 bytes)
Oct 26 09:09:28 localhost kernel: usb-storage:  12 00 00 00 24 00
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:28 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 36 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code 0; transferred=
 36/36
Oct 26 09:09:28 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:28 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:28 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x1 R 0 Stat 0x0
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel:   Vendor: HP        Model: DVD Writer 2=
00j   Rev: 1.06
Oct 26 09:09:28 localhost kernel:   Type:   CD-ROM                       =
      ANSI SCSI revision: 00
Oct 26 09:09:28 localhost kernel: Attached scsi generic sg0 at scsi0, cha=
nnel 0, id 0, lun 0,  type 5
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Bad LUN (0:1)
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
40000
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Bad target number (1:0)
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
40000
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Bad target number (2:0)
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
40000
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Bad target number (3:0)
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
40000
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Bad target number (4:0)
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
40000
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Bad target number (5:0)
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
40000
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Bad target number (6:0)
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
40000
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Bad target number (7:0)
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
40000
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: device scan complete
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Command TEST_UNIT_READY (6=
 bytes)
Oct 26 09:09:28 localhost kernel: usb-storage:  00 00 00 00 00 00
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0xa L 0 F 0 Trg 0 LUN 0 CL 6
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:28 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:28 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:28 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0xa R 0 Stat 0x0
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:28 localhost kernel: usb-storage: Command MODE_SENSE_10 (10 =
bytes)
Oct 26 09:09:28 localhost kernel: usb-storage:  5a 00 2a 00 00 00 00 00 8=
0 00
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0xb L 128 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:28 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 128 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code 0; transferred=
 34/128
Oct 26 09:09:28 localhost kernel: usb-storage: -- short transfer
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk data transfer result =
0x1
Oct 26 09:09:28 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code -32; transferr=
ed 0/13
Oct 26 09:09:28 localhost kernel: usb-storage: clearing endpoint halt for=
 pipe 0xc0010380
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_control_msg: rq=3D=
01 rqtype=3D02 value=3D0000 index=3D82 len=3D0
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_clear_halt: resul=
t =3D 0
Oct 26 09:09:28 localhost kernel: usb-storage: Attempting to get CSW (2nd=
 try)...
Oct 26 09:09:28 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:28 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:28 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:28 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0xb R 94 Stat 0x0
Oct 26 09:09:28 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:28 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:28 localhost kernel: sr0: scsi3-mmc drive: 32x/32x writer cd=
/rw xa/form2 cdda tray
Oct 26 09:09:28 localhost kernel: Attached scsi CD-ROM sr0 at scsi0, chan=
nel 0, id 0, lun 0
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command TEST_UNIT_READY (6=
 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  00 00 00 00 00 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0xc L 0 F 0 Trg 0 LUN 0 CL 6
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0xc R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_TOC (10 bytes=
)
Oct 26 09:09:56 localhost kernel: usb-storage:  43 00 00 00 00 00 00 00 0=
c 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0xd L 12 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 12 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 12/12
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0xd R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_TOC (10 bytes=
)
Oct 26 09:09:56 localhost kernel: usb-storage:  43 02 00 00 00 00 01 00 0=
c 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0xe L 12 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 12 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 12/12
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0xe R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_CAPACITY (10 =
bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  25 00 00 00 00 00 00 00 0=
0 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0xf L 8 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 8 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 8/8
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0xf R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command ALLOW_MEDIUM_REMOV=
AL (6 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  1e 00 00 00 01 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x10 L 0 F 0 Trg 0 LUN 0 CL 6
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x10 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command (unknown command) =
(10 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  46 00 00 00 00 00 00 00 2=
0 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x11 L 32 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 32 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 32/32
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x11 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: cdrom: sr0: mmc-3 profile capable, curr=
ent profile: Ah
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command (unknown command) =
(10 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  46 00 00 28 00 00 00 00 1=
0 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x12 L 16 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 16 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 16/16
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x12 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command MODE_SENSE_10 (10 =
bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  5a 00 03 00 00 00 00 00 1=
0 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x13 L 16 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 16 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 0/16
Oct 26 09:09:56 localhost kernel: usb-storage: -- short transfer
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x1
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code -32; transferr=
ed 0/13
Oct 26 09:09:56 localhost kernel: usb-storage: clearing endpoint halt for=
 pipe 0xc0010380
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_control_msg: rq=3D=
01 rqtype=3D02 value=3D0000 index=3D82 len=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_clear_halt: resul=
t =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW (2nd=
 try)...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x13 R 16 Stat 0x1
Oct 26 09:09:56 localhost kernel: usb-storage: -- transport indicates com=
mand failure
Oct 26 09:09:56 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x80000013 L 18 F 128 Trg 0 LUN 0 CL 6
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 18 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 18/18
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x80000013 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: -- Result from auto-sense =
is 0
Oct 26 09:09:56 localhost kernel: usb-storage: -- code: 0x70, key: 0x5, A=
SC: 0x24, ASCQ: 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Illegal Request: Invalid f=
ield in cdb
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
2
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command MODE_SENSE_10 (10 =
bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  5a 00 2c 00 00 00 00 00 1=
0 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x14 L 16 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 16 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 0/16
Oct 26 09:09:56 localhost kernel: usb-storage: -- short transfer
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x1
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code -32; transferr=
ed 0/13
Oct 26 09:09:56 localhost kernel: usb-storage: clearing endpoint halt for=
 pipe 0xc0010380
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_control_msg: rq=3D=
01 rqtype=3D02 value=3D0000 index=3D82 len=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_clear_halt: resul=
t =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW (2nd=
 try)...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x14 R 16 Stat 0x1
Oct 26 09:09:56 localhost kernel: usb-storage: -- transport indicates com=
mand failure
Oct 26 09:09:56 localhost kernel: usb-storage: Issuing auto-REQUEST_SENSE
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x80000014 L 18 F 128 Trg 0 LUN 0 CL 6
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 18 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 18/18
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x80000014 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: -- Result from auto-sense =
is 0
Oct 26 09:09:56 localhost kernel: usb-storage: -- code: 0x70, key: 0x5, A=
SC: 0x24, ASCQ: 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Illegal Request: Invalid f=
ield in cdb
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
2
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command (unknown command) =
(10 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  46 00 00 20 00 00 00 00 1=
8 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x15 L 24 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 24 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 24/24
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x15 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command TEST_UNIT_READY (6=
 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  00 00 00 00 00 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x16 L 0 F 0 Trg 0 LUN 0 CL 6
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x16 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_TOC (10 bytes=
)
Oct 26 09:09:56 localhost kernel: usb-storage:  43 00 00 00 00 00 00 00 0=
c 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x17 L 12 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 12 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 12/12
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x17 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_TOC (10 bytes=
)
Oct 26 09:09:56 localhost kernel: usb-storage:  43 02 00 00 00 00 01 00 0=
c 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x18 L 12 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 12 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 12/12
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x18 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command ALLOW_MEDIUM_REMOV=
AL (6 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  1e 00 00 00 01 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x19 L 0 F 0 Trg 0 LUN 0 CL 6
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x19 R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command (unknown command) =
(10 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  46 00 00 00 00 00 00 00 2=
0 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x1a L 32 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 32 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 32/32
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x1a R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: cdrom: sr0: mmc-3 profile capable, curr=
ent profile: Ah
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command TEST_UNIT_READY (6=
 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  00 00 00 00 00 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x1b L 0 F 0 Trg 0 LUN 0 CL 6
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x1b R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_TOC (10 bytes=
)
Oct 26 09:09:56 localhost kernel: usb-storage:  43 00 00 00 00 00 00 00 0=
c 40
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x1c L 12 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 12 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 12/12
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x1c R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_TOC (10 bytes=
)
Oct 26 09:09:56 localhost kernel: usb-storage:  43 00 00 00 00 00 00 00 0=
c 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x1d L 12 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 12 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 12/12
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x1d R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_TOC (10 bytes=
)
Oct 26 09:09:56 localhost kernel: usb-storage:  43 00 00 00 00 00 01 00 0=
c 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x1e L 12 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 12 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 12/12
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:56 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x1e R 0 Stat 0x0
Oct 26 09:09:56 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:56 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:56 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:56 localhost kernel: usb-storage: Command READ_10 (10 bytes)
Oct 26 09:09:56 localhost kernel: usb-storage:  28 00 00 00 00 10 00 00 0=
1 00
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x1f L 2048 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:56 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:56 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:56 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:56 localhost kernel: usb-storage: usb_stor_bulk_transfer_sgl=
ist: xfer 2048 bytes, 1 entries
Oct 26 09:09:58 localhost kernel: usb-storage: Status code 0; transferred=
 2048/2048
Oct 26 09:09:58 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:58 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:09:58 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:09:58 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:09:58 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:09:58 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:58 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:09:58 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x1f R 0 Stat 0x0
Oct 26 09:09:58 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:09:58 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:09:58 localhost kernel: usb-storage: queuecommand called
Oct 26 09:09:58 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:09:58 localhost kernel: usb-storage: Command READ_10 (10 bytes)
Oct 26 09:09:58 localhost kernel: usb-storage:  28 00 00 00 00 11 00 00 0=
1 00
Oct 26 09:09:58 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x20 L 2048 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:09:58 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:09:58 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:09:58 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:09:58 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:09:58 localhost kernel: usb-storage: usb_stor_bulk_transfer_sgl=
ist: xfer 2048 bytes, 1 entries
Oct 26 09:10:00 localhost kernel: usb-storage: Status code 0; transferred=
 2048/2048
Oct 26 09:10:00 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:10:00 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:10:00 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:10:00 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:10:00 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x20 R 0 Stat 0x0
Oct 26 09:10:00 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:10:00 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:10:00 localhost kernel: ISO 9660 Extensions: Microsoft Joliet L=
evel 3
Oct 26 09:10:00 localhost kernel: usb-storage: queuecommand called
Oct 26 09:10:00 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:10:00 localhost kernel: usb-storage: Command READ_10 (10 bytes)
Oct 26 09:10:00 localhost kernel: usb-storage:  28 00 00 00 00 1c 00 00 0=
1 00
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x21 L 2048 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:10:00 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:10:00 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:10:00 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:10:00 localhost kernel: usb-storage: usb_stor_bulk_transfer_sgl=
ist: xfer 2048 bytes, 1 entries
Oct 26 09:10:00 localhost kernel: usb-storage: Status code 0; transferred=
 2048/2048
Oct 26 09:10:00 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:10:00 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:10:00 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:10:00 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:10:00 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x21 R 0 Stat 0x0
Oct 26 09:10:00 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:10:00 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:10:00 localhost kernel: usb-storage: queuecommand called
Oct 26 09:10:00 localhost kernel: usb-storage: *** thread awakened.
Oct 26 09:10:00 localhost kernel: usb-storage: Command READ_10 (10 bytes)
Oct 26 09:10:00 localhost kernel: usb-storage:  28 00 00 00 00 1e 00 00 0=
1 00
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk Command S 0x43425355 =
T 0x22 L 2048 F 128 Trg 0 LUN 0 CL 10
Oct 26 09:10:00 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 31 bytes
Oct 26 09:10:00 localhost kernel: usb-storage: Status code 0; transferred=
 31/31
Oct 26 09:10:00 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk command transfer resu=
lt=3D0
Oct 26 09:10:00 localhost kernel: usb-storage: usb_stor_bulk_transfer_sgl=
ist: xfer 2048 bytes, 1 entries
Oct 26 09:10:00 localhost kernel: usb-storage: Status code 0; transferred=
 2048/2048
Oct 26 09:10:00 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk data transfer result =
0x0
Oct 26 09:10:00 localhost kernel: usb-storage: Attempting to get CSW...
Oct 26 09:10:00 localhost kernel: usb-storage: usb_stor_bulk_transfer_buf=
: xfer 13 bytes
Oct 26 09:10:00 localhost kernel: usb-storage: Status code 0; transferred=
 13/13
Oct 26 09:10:00 localhost kernel: usb-storage: -- transfer complete
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk status result =3D 0
Oct 26 09:10:00 localhost kernel: usb-storage: Bulk Status S 0x53425355 T=
 0x22 R 0 Stat 0x0
Oct 26 09:10:00 localhost kernel: usb-storage: scsi cmd done, result=3D0x=
0
Oct 26 09:10:00 localhost kernel: usb-storage: *** thread sleeping.
Oct 26 09:10:00 localhost kernel: ISO 9660 Extensions: RRIP_1991A
Oct 26 09:10:03 localhost kernel: ehci_hcd 0000:00:1d.7: GetStatus port 1=
 status 001002 POWER sig=3Dse0  CSC
Oct 26 09:10:03 localhost kernel: hub 1-0:1.0: port 1, status 0100, chang=
e 0001, 12 Mb/s
Oct 26 09:10:03 localhost kernel: usb 1-1: USB disconnect, address 3
Oct 26 09:10:03 localhost kernel: usb 1-1: usb_disable_device nuking all =
URBs
Oct 26 09:10:03 localhost kernel: usb 1-1: unregistering interface 1-1:2.=
0
Oct 26 09:10:03 localhost kernel: usb-storage: storage_disconnect() calle=
d
Oct 26 09:10:03 localhost kernel: usb-storage: usb_stor_stop_transport ca=
lled
Oct 26 09:10:03 localhost kernel:  target0:0:0: Illegal state transition =
<NULL>->cancel
Oct 26 09:10:03 localhost kernel: Badness in scsi_device_set_state at dri=
vers/scsi/scsi_lib.c:1713
Oct 26 09:10:03 localhost kernel:  [scsi_device_set_state+199/210] scsi_d=
evice_set_state+0xc7/0xd2
Oct 26 09:10:03 localhost kernel:  [scsi_device_cancel+38/257] scsi_devic=
e_cancel+0x26/0x101
Oct 26 09:10:03 localhost kernel:  [scsi_device_cancel_cb+0/12] scsi_devi=
ce_cancel_cb+0x0/0xc
Oct 26 09:10:03 localhost kernel:  [device_for_each_child+52/91] device_f=
or_each_child+0x34/0x5b
Oct 26 09:10:03 localhost kernel:  [scsi_host_cancel+37/176] scsi_host_ca=
ncel+0x25/0xb0
Oct 26 09:10:03 localhost kernel:  [dput+27/569] dput+0x1b/0x239
Oct 26 09:10:03 localhost kernel:  [device_del+101/117] device_del+0x65/0=
x75
Oct 26 09:10:03 localhost kernel:  [scsi_remove_device+112/128] scsi_remo=
ve_device+0x70/0x80
Oct 26 09:10:03 localhost kernel:  [scsi_forget_host+112/140] scsi_forget=
_host+0x70/0x8c
Oct 26 09:10:03 localhost kernel:  [scsi_remove_host+17/75] scsi_remove_h=
ost+0x11/0x4b
Oct 26 09:10:03 localhost kernel:  [pg0+268324036/1068930048] storage_dis=
connect+0x7a/0x89 [usb_storage]
Oct 26 09:10:03 localhost kernel:  [usb_unbind_interface+51/94] usb_unbin=
d_interface+0x33/0x5e
Oct 26 09:10:03 localhost kernel:  [device_release_driver+60/70] device_r=
elease_driver+0x3c/0x46
Oct 26 09:10:03 localhost kernel:  [bus_remove_device+63/118] bus_remove_=
device+0x3f/0x76
Oct 26 09:10:03 localhost kernel:  [device_del+86/117] device_del+0x56/0x=
75
Oct 26 09:10:03 localhost kernel:  [usb_disable_device+194/301] usb_disab=
le_device+0xc2/0x12d
Oct 26 09:10:03 localhost kernel:  [usb_disconnect+173/342] usb_disconnec=
t+0xad/0x156
Oct 26 09:10:03 localhost kernel:  [hub_port_connect_change+179/971] hub_=
port_connect_change+0xb3/0x3cb
Oct 26 09:10:03 localhost kernel:  [hub_events+824/1057] hub_events+0x338=
/0x421
Oct 26 09:10:03 localhost kernel:  [prepare_to_wait+76/104] prepare_to_wa=
it+0x4c/0x68
Oct 26 09:10:03 localhost kernel:  [hub_thread+0/258] hub_thread+0x0/0x10=
2
Oct 26 09:10:03 localhost kernel:  [hub_thread+30/258] hub_thread+0x1e/0x=
102
Oct 26 09:10:03 localhost kernel:  [autoremove_wake_function+0/45] autore=
move_wake_function+0x0/0x2d
Oct 26 09:10:03 localhost kernel:  [hub_thread+0/258] hub_thread+0x0/0x10=
2
Oct 26 09:10:03 localhost kernel:  [autoremove_wake_function+0/45] autore=
move_wake_function+0x0/0x2d
Oct 26 09:10:03 localhost kernel:  [kernel_thread_helper+5/11] kernel_thr=
ead_helper+0x5/0xb
Oct 26 09:10:03 localhost kernel: Unable to handle kernel NULL pointer de=
reference at virtual address 00000000
Oct 26 09:10:03 localhost kernel:  printing eip:
Oct 26 09:10:03 localhost kernel: c025287b
Oct 26 09:10:03 localhost kernel: *pde =3D 00000000
Oct 26 09:10:03 localhost kernel: Oops: 0000 [#1]
Oct 26 09:10:03 localhost kernel: PREEMPT
Oct 26 09:10:03 localhost kernel: Modules linked in: nls_iso8859_2 isofs =
nls_base zlib_inflate sr_mod usb_storage pktcdvd lp button processor ac b=
attery ipt_REJECT ipt_pkttype ipt_LOG ipt_state ipt_multiport ipt_conntra=
ck iptable_mangle ip_nat_irc ip_nat_tftp ip_nat_ftp iptable_nat ip_conntr=
ack_irc ip_conntrack_tftp ip_conntrack_ftp ip_conntrack iptable_filter ip=
_tables usbhid ipw2100 ieee80211 ieee80211_crypt 8139too mii crc32 hw_ran=
dom intel_agp agpgart parport_pc parport irtty_sir sir_dev pcspkr
Oct 26 09:10:03 localhost kernel: CPU:    0
Oct 26 09:10:03 localhost kernel: EIP:    0060:[scsi_device_cancel+57/257=
]    Not tainted VLI
Oct 26 09:10:03 localhost kernel: EFLAGS: 00010013   (2.6.9-rc4mm1)
Oct 26 09:10:03 localhost kernel: EIP is at scsi_device_cancel+0x39/0x101
Oct 26 09:10:03 localhost kernel: eax: 00000001   ebx: fffffff0   ecx: 00=
000001   edx: 00000000
Oct 26 09:10:03 localhost kernel: esi: cb794a80   edi: c13d1e5c   ebp: 00=
000282   esp: c13d1e58
Oct 26 09:10:03 localhost kernel: ds: 007b   es: 007b   ss: 0068
Oct 26 09:10:03 localhost kernel: Process khubd (pid: 145, threadinfo=3Dc=
13d0000 task=3Dc12655a0)
Oct 26 09:10:03 localhost kernel: Stack: 00000000 c13d1e5c c13d1e5c cb794=
c04 cdcb78b4 c03ed008 c0252982 c023414f
Oct 26 09:10:03 localhost kernel:        c13d1e90 cdcb7800 d048cea0 cbae6=
0c0 cf4641c0 c02529b3 00000000 cb0f8054
Oct 26 09:10:03 localhost kernel:        c0159d5c cdd45da8 cb794c04 cdd45=
d84 cdd45d84 cb794c04 c02340fb cdd45c00
Oct 26 09:10:03 localhost kernel: Call Trace:
Oct 26 09:10:03 localhost kernel:  [scsi_device_cancel_cb+0/12] scsi_devi=
ce_cancel_cb+0x0/0xc
Oct 26 09:10:03 localhost kernel:  [device_for_each_child+52/91] device_f=
or_each_child+0x34/0x5b
Oct 26 09:10:03 localhost kernel:  [scsi_host_cancel+37/176] scsi_host_ca=
ncel+0x25/0xb0
Oct 26 09:10:03 localhost kernel:  [dput+27/569] dput+0x1b/0x239
Oct 26 09:10:03 localhost kernel:  [device_del+101/117] device_del+0x65/0=
x75
Oct 26 09:10:03 localhost kernel:  [scsi_remove_device+112/128] scsi_remo=
ve_device+0x70/0x80
Oct 26 09:10:03 localhost kernel:  [scsi_forget_host+112/140] scsi_forget=
_host+0x70/0x8c
Oct 26 09:10:03 localhost kernel:  [scsi_remove_host+17/75] scsi_remove_h=
ost+0x11/0x4b
Oct 26 09:10:03 localhost kernel:  [pg0+268324036/1068930048] storage_dis=
connect+0x7a/0x89 [usb_storage]
Oct 26 09:10:03 localhost kernel:  [usb_unbind_interface+51/94] usb_unbin=
d_interface+0x33/0x5e
Oct 26 09:10:03 localhost kernel:  [device_release_driver+60/70] device_r=
elease_driver+0x3c/0x46
Oct 26 09:10:03 localhost kernel:  [bus_remove_device+63/118] bus_remove_=
device+0x3f/0x76
Oct 26 09:10:03 localhost kernel:  [device_del+86/117] device_del+0x56/0x=
75
Oct 26 09:10:03 localhost kernel:  [usb_disable_device+194/301] usb_disab=
le_device+0xc2/0x12d
Oct 26 09:10:03 localhost kernel:  [usb_disconnect+173/342] usb_disconnec=
t+0xad/0x156
Oct 26 09:10:03 localhost kernel:  [hub_port_connect_change+179/971] hub_=
port_connect_change+0xb3/0x3cb
Oct 26 09:10:03 localhost kernel:  [hub_events+824/1057] hub_events+0x338=
/0x421
Oct 26 09:10:03 localhost kernel:  [prepare_to_wait+76/104] prepare_to_wa=
it+0x4c/0x68
Oct 26 09:10:03 localhost kernel:  [hub_thread+0/258] hub_thread+0x0/0x10=
2
Oct 26 09:10:03 localhost kernel:  [hub_thread+30/258] hub_thread+0x1e/0x=
102
Oct 26 09:10:03 localhost kernel:  [autoremove_wake_function+0/45] autore=
move_wake_function+0x0/0x2d
Oct 26 09:10:03 localhost kernel:  [hub_thread+0/258] hub_thread+0x0/0x10=
2
Oct 26 09:10:03 localhost kernel:  [autoremove_wake_function+0/45] autore=
move_wake_function+0x0/0x2d
Oct 26 09:10:03 localhost kernel:  [kernel_thread_helper+5/11] kernel_thr=
ead_helper+0x5/0xb
Oct 26 09:10:03 localhost kernel: Code: 14 24 89 c7 ba 03 00 00 00 89 44 =
24 04 89 44 24 08 89 f0 e8 b2 41 00 00 9c 5d fa b8 01 00 00 00 e8 b6 1c e=
c ff 8b 56 1c 8d 5a f0 <8b> 43 10 0f 18 00 90 8d 46 1c 39 c2 74 40 8b 83 =
b8 00 00 00 85
Oct 26 09:10:03 localhost kernel:  <6>note: khubd[145] exited with preemp=
t_count 1
Oct 26 09:10:22 localhost kernel: scsi0 (0:0): rejecting I/O to dead devi=
ce
Oct 26 09:10:22 localhost kernel: SCSI error: host 0 id 0 lun 0 return co=
de =3D 4000000
Oct 26 09:10:22 localhost kernel: ^ISense class 0, sense error 0, extende=
d sense 0
------------------------------------ END OF OOPS ------------------------=
------------
----------------------------------- DECODED OOPS ------------------------=
------------
ksymoops 2.4.9 on i686 2.6.9-rc4mm1.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.9-rc4mm1/ (default)
     -m /boot/System.map-2.6.9-rc4mm1 (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
Oct 26 09:08:36 localhost kernel: Machine check exception polling timer s=
tarted.
Oct 26 09:08:36 localhost kernel: 8139too Fast Ethernet driver 0.9.27
Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0100-0x04ff: exclud=
ing 0x400-0x407 0x4d0-0x4d7
Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0800-0x08ff: clean.
Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0c00-0x0cff: clean.
Oct 26 09:08:52 localhost kernel: cs: IO port probe 0x0a00-0x0aff: clean.
Oct 26 09:10:03 localhost kernel: Unable to handle kernel NULL pointer de=
reference at virtual address 00000000
Oct 26 09:10:03 localhost kernel: c025287b
Oct 26 09:10:03 localhost kernel: *pde =3D 00000000
Oct 26 09:10:03 localhost kernel: Oops: 0000 [#1]
Oct 26 09:10:03 localhost kernel: CPU:    0
Oct 26 09:10:03 localhost kernel: EIP:    0060:[scsi_device_cancel+57/257=
]    Not tainted VLI
Oct 26 09:10:03 localhost kernel: EFLAGS: 00010013   (2.6.9-rc4mm1)
Oct 26 09:10:03 localhost kernel: eax: 00000001   ebx: fffffff0   ecx: 00=
000001   edx: 00000000
Oct 26 09:10:03 localhost kernel: esi: cb794a80   edi: c13d1e5c   ebp: 00=
000282   esp: c13d1e58
Oct 26 09:10:03 localhost kernel: ds: 007b   es: 007b   ss: 0068
Oct 26 09:10:03 localhost kernel: Stack: 00000000 c13d1e5c c13d1e5c cb794=
c04 cdcb78b4 c03ed008 c0252982 c023414f
Oct 26 09:10:03 localhost kernel:        c13d1e90 cdcb7800 d048cea0 cbae6=
0c0 cf4641c0 c02529b3 00000000 cb0f8054
Oct 26 09:10:03 localhost kernel:        c0159d5c cdd45da8 cb794c04 cdd45=
d84 cdd45d84 cb794c04 c02340fb cdd45c00
Oct 26 09:10:03 localhost kernel: Call Trace:
Warning (Oops_read): Code line not seen, dumping what data is available


>>ebx; fffffff0 <__kernel_rt_sigreturn+1bb0/????>
>>esi; cb794a80 <pg0+b2ffa80/3fb69400>
>>edi; c13d1e5c <pg0+f3ce5c/3fb69400>
>>esp; c13d1e58 <pg0+f3ce58/3fb69400>

Oct 26 09:10:03 localhost kernel: Code: 14 24 89 c7 ba 03 00 00 00 89 44 =
24 04 89 44 24 08 89 f0 e8 b2 41 00 00 9c 5d fa b8 01 00 00 00 e8 b6 1c e=
c ff 8b 56 1c 8d 5a f0 <8b> 43 10 0f 18 00 90 8d 46 1c 39 c2 74 40 8b 83 =
b8 00 00 00 85
Using defaults from ksymoops -t elf32-i386 -a i386


Code;  ffffffd5 <__kernel_rt_sigreturn+1b95/????>
00000000 <_EIP>:
Code;  ffffffd5 <__kernel_rt_sigreturn+1b95/????>
   0:   14 24                     adc    $0x24,%al
Code;  ffffffd7 <__kernel_rt_sigreturn+1b97/????>
   2:   89 c7                     mov    %eax,%edi
Code;  ffffffd9 <__kernel_rt_sigreturn+1b99/????>
   4:   ba 03 00 00 00            mov    $0x3,%edx
Code;  ffffffde <__kernel_rt_sigreturn+1b9e/????>
   9:   89 44 24 04               mov    %eax,0x4(%esp)
Code;  ffffffe2 <__kernel_rt_sigreturn+1ba2/????>
   d:   89 44 24 08               mov    %eax,0x8(%esp)
Code;  ffffffe6 <__kernel_rt_sigreturn+1ba6/????>
  11:   89 f0                     mov    %esi,%eax
Code;  ffffffe8 <__kernel_rt_sigreturn+1ba8/????>
  13:   e8 b2 41 00 00            call   41ca <_EIP+0x41ca>
Code;  ffffffed <__kernel_rt_sigreturn+1bad/????>
  18:   9c                        pushf
Code;  ffffffee <__kernel_rt_sigreturn+1bae/????>
  19:   5d                        pop    %ebp
Code;  ffffffef <__kernel_rt_sigreturn+1baf/????>
  1a:   fa                        cli
Code;  fffffff0 <__kernel_rt_sigreturn+1bb0/????>
  1b:   b8 01 00 00 00            mov    $0x1,%eax
Code;  fffffff5 <__kernel_rt_sigreturn+1bb5/????>
  20:   e8 b6 1c ec ff            call   ffec1cdb <_EIP+0xffec1cdb>
Code;  fffffffa <__kernel_rt_sigreturn+1bba/????>
  25:   8b 56 1c                  mov    0x1c(%esi),%edx
Code;  fffffffd <__kernel_rt_sigreturn+1bbd/????>
  28:   8d 5a f0                  lea    0xfffffff0(%edx),%ebx
Code;  00000000 Before first symbol
  2b:   8b 43 10                  mov    0x10(%ebx),%eax
Code;  00000003 Before first symbol
  2e:   0f 18 00                  prefetchnta (%eax)
Code;  00000006 Before first symbol
  31:   90                        nop
Code;  00000007 Before first symbol
  32:   8d 46 1c                  lea    0x1c(%esi),%eax
Code;  0000000a Before first symbol
  35:   39 c2                     cmp    %eax,%edx
Code;  0000000c Before first symbol
  37:   74 40                     je     79 <_EIP+0x79>
Code;  0000000e Before first symbol
  39:   8b 83 b8 00 00 00         mov    0xb8(%ebx),%eax
Code;  00000014 Before first symbol
  3f:   85                        .byte 0x85


2 warnings and 1 error issued.  Results may not be reliable.
---------------------------- END OF DECODED OOPS ------------------------=
------------

>
> Alan Stern
>

-mat

--=20
Pozdrowienia,Regards,Cheers,Gr=FC=DFe,A plus!,


-------------------------------------------------------
This SF.net email is sponsored by: IT Product Guide on ITManagersJournal
Use IT products in your business? Tell us what you think of them. Give us
Your Opinions, Get Free ThinkGeek Gift Certificates! Click to find out more
http://productguide.itmanagersjournal.com/guidepromo.tmpl
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
