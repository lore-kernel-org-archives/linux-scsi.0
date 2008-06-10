From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Subject: [usb-storage] SCSI errors hang user processes indefinitely
Date: Tue, 10 Jun 2008 12:01:59 +0100
Message-ID: <484E5F27.6010803@student.cs.york.ac.uk>
References: <Pine.LNX.4.44L0.0806091527430.14688-100000@iolanthe.rowland.org>
Reply-To: alan-jenkins@tuffmail.co.uk
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010309070405080105020107"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754827AbYFJLFd@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0806091527430.14688-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net, alan-jenkins@tuffmail.co.uk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010309070405080105020107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Was: "bug report: regression - USB card reader doesn't work"
<https://lists.one-eyed-alien.net/pipermail/usb-storage/2008-June/003734.html>.

I have a buggy USB card reader which responds with "Unrecoverable read
error" for particular reads (and probably writes).  The error is
triggered immediately when I insert the device and udev runs "vol_id" on
it.  The usb-storage people have been quick to figure out a workaround,
but there is also a more general problem.

The kernel's response to this unrecoverable read error is to hang the
vol_id process.  "strace" shows that vol_id is hung on sys_read() for at
least 10 minutes.  It continues to hang even when I unplug the card
reader.  This ties up the device node (/dev/sdb) so that if I re-insert
the card reader, it uses a different device node.  It also stops me
hibernating the computer because the vol_id process is "refusing to
freeze".  Nor can the hung vol_id be killed; it's stuck in D state.  I
have reproduced all of this on linux 2.6.25.3.

I sent Alan Stern a copy of the kernel messages with
CONFIG_USB_STORAGE_DEBUG.  His conclusion was that the hang was not in
usb-storage but elsewhere.  I had also sent stack traces automatically
output after a failed hibernation which implicated a filesystem in the
hang (!).

There's a lot going on here.  Can anyone help pin down specific
problems?  I think the error handling is primarily the responsibility of
the SCSI generic layer, but I don't have any insight into what it is
supposed do.  My instinct says that SCSI error handling should be mature
and the issue is in some way specific to usb-storage, but that's just a
feeling.

As a starting point, I've attached dmesg output showing two sets of
stack traces (from Alt-SysRq-T) taken before and after the device was
removed.

Thanks!
Alan

--------------010309070405080105020107
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

0-04bf claimed by ICH6 GPIO
[    0.248461] PCI: Transparent bridge - 0000:00:1e.0
[    0.248523] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.248680] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.258755] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.259128] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.259555] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.259926] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 11 12 14 *15)
[    0.260299] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.260729] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.261157] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.261585] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.262074] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.262147] pnp: PnP ACPI init
[    0.262193] ACPI: bus type pnp registered
[    0.265641] pnp: PnP ACPI: found 16 devices
[    0.265686] ACPI: ACPI bus type pnp unregistered
[    0.265875] SCSI subsystem initialized
[    0.265965] libata version 3.00 loaded.
[    0.266165] PCI: Using ACPI for IRQ routing
[    0.266209] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.286667] PCI-GART: No AMD northbridge found.
[    0.286718] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.286846] hpet0: 3 64-bit timers, 14318180 Hz
[    0.287921] ACPI: RTC can wake from S4
[    0.300003] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.300056] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.300108] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.300160] system 00:01: ioport range 0x290-0x297 has been reserved
[    0.300212] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.300279] system 00:0c: ioport range 0x400-0x4bf could not be reserved
[    0.300332] system 00:0e: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.300401] system 00:0f: iomem range 0xcd800-0xcffff has been reserved
[    0.300450] system 00:0f: iomem range 0xf0000-0xf7fff could not be reserved
[    0.300500] system 00:0f: iomem range 0xf8000-0xfbfff could not be reserved
[    0.300551] system 00:0f: iomem range 0xfc000-0xfffff could not be reserved
[    0.300601] system 00:0f: iomem range 0xfed00000-0xfed000ff has been reserved
[    0.300652] system 00:0f: iomem range 0x7f6e0000-0x7f6fffff could not be reserved
[    0.300718] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[    0.300768] system 00:0f: iomem range 0x100000-0x7f6dffff could not be reserved
[    0.300834] system 00:0f: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.300884] system 00:0f: iomem range 0xfed13000-0xfed1dfff has been reserved
[    0.300935] system 00:0f: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.300989] system 00:0f: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.301056] system 00:0f: iomem range 0xffb00000-0xffb7ffff has been reserved
[    0.301107] system 00:0f: iomem range 0xfff00000-0xffffffff has been reserved
[    0.301157] system 00:0f: iomem range 0xe0000-0xeffff has been reserved
[    0.301689] PCI: Bridge: 0000:00:01.0
[    0.301733]   IO window: d000-dfff
[    0.301776]   MEM window: 0xfde00000-0xfdefffff
[    0.301822]   PREFETCH window: 0x00000000fdd00000-0x00000000fddfffff
[    0.301872] PCI: Bridge: 0000:00:1e.0
[    0.301915]   IO window: e000-efff
[    0.301959]   MEM window: 0xfdc00000-0xfdcfffff
[    0.302005]   PREFETCH window: 0x00000000fdb00000-0x00000000fdbfffff
[    0.302064] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.302151] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.302159] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.302168] NET: Registered protocol family 2
[    0.330036] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.330365] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.332161] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.333410] TCP: Hash tables configured (established 262144 bind 65536)
[    0.333461] TCP reno registered
[    0.343539] checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
[    0.503311] Switched to high resolution mode on CPU 0
[    0.909188]  it is
[    1.498792] Freeing initrd memory: 12579k freed
[    1.277586] audit: initializing netlink socket (disabled)
[    1.277658] type=2000 audit(1213092944.503:1): initialized
[    1.279715] VFS: Disk quotas dquot_6.5.1
[    1.279832] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.279996] io scheduler noop registered
[    1.280040] io scheduler anticipatory registered
[    1.280085] io scheduler deadline registered
[    1.280181] io scheduler cfq registered (default)
[    1.280238] pci 0000:00:02.0: Boot video device
[    1.280382] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    1.280409] assign_interrupt_mode Found MSI capability
[    1.280479] Allocate Port Service[0000:00:01.0:pcie00]
[    1.280515] Allocate Port Service[0000:00:01.0:pcie03]
[    1.283995] hpet_resources: 0xfed00000 is busy
[    1.284054] Linux agpgart interface v0.103
[    1.284100] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.284279] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.284722] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.285551] brd: module loaded
[    1.285611] ahci 0000:00:1f.2: version 3.0
[    1.285635] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    1.309945] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[    1.310018] ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
[    1.310072] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    1.310280] scsi0 : ahci
[    1.313328] scsi1 : ahci
[    1.313422] scsi2 : ahci
[    1.313519] scsi3 : ahci
[    1.313640] ata1: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe100 irq 510
[    1.313707] ata2: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe180 irq 510
[    1.313774] ata3: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe200 irq 510
[    1.313840] ata4: SATA max UDMA/133 abar m1024@0xfdffe000 port 0xfdffe280 irq 510
[    1.363263] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.549907] ata1.00: ATA-7: WDC WD1600AAJS-22PSA0, 05.06H05, max UDMA/133
[    1.549907] ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.549907] ata1.00: configured for UDMA/133
[    1.589912] ata2: SATA link down (SStatus 0 SControl 300)
[    1.633242] ata3: SATA link down (SStatus 0 SControl 300)
[    1.673239] ata4: SATA link down (SStatus 0 SControl 300)
[    1.373253] scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-2 05.0 PQ: 0 ANSI: 5
[    1.373253] ata_piix 0000:00:1f.1: version 2.12
[    1.373253] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    1.373335] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    1.373377] scsi4 : ata_piix
[    1.373475] scsi5 : ata_piix
[    1.374063] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    1.374114] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    1.710218] ata5.01: ATAPI: LITE-ON COMBO SOHC-5232K, NK07, max UDMA/44
[    1.723491] ata5.01: configured for UDMA/44
[    1.723562] ata6: port disabled. ignoring.
[    1.387571] scsi 4:0:1:0: CD-ROM            LITE-ON  COMBO SOHC-5232K NK07 PQ: 0 ANSI: 5
[    1.387867] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.388230] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.388278] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.388426] mice: PS/2 mouse device common for all mice
[    1.388509] cpuidle: using governor ladder
[    1.388553] cpuidle: using governor menu
[    1.388896] NET: Registered protocol family 1
[    1.388992] NET: Registered protocol family 33
[    1.389140] PM: Resume from partition LABEL=swap
[    1.389141] PM: Checking hibernation image.
[    1.389150] PM: Error -6 checking image file
[    1.389152] PM: Resume from disk failed.
[    1.389172] registered taskstats version 1
[    1.389287] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    1.389336] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    1.389564] Freeing unused kernel memory: 256k freed
[    1.856583] fuse init (API version 7.9)
[    1.523183] ACPI: PNP0C0B:00 is registered as cooling_device0
[    1.523235] ACPI: Fan [FAN] (on)
[    1.864664] ACPI Error (psparse-0537): Method parse/execution failed [\_PR_.CPU0._PDC] (Node ffff81007f033900), AE_ALREADY_EXISTS
[    1.864800] ACPI: Marking method _PDC as Serialized
[    1.864982] ACPI: ACPI0007:00 is registered as cooling_device1
[    1.865190] ACPI: SSDT 7F6E8750, 00CE (r1  PmRef  Cpu1Ist     3000 INTL 20041203)
[    1.865465] ACPI: ACPI0007:01 is registered as cooling_device2
[    1.866755] ACPI: LNXTHERM:01 is registered as thermal_zone0
[    1.866928] ACPI: Thermal Zone [THRM] (25 C)
[    2.016282] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.026907] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    2.033372] snd_hwdep: Unknown symbol snd_info_register
[    2.033464] snd_hwdep: Unknown symbol snd_info_create_module_entry
[    2.033545] snd_hwdep: Unknown symbol snd_ctl_unregister_ioctl_compat
[    2.033630] snd_hwdep: Unknown symbol snd_info_free_entry
[    2.033721] snd_hwdep: Unknown symbol snd_ctl_register_ioctl
[    2.033796] snd_hwdep: Unknown symbol snd_card_file_add
[    2.033872] snd_hwdep: Unknown symbol snd_iprintf
[    2.033940] snd_hwdep: Unknown symbol snd_major
[    2.034016] snd_hwdep: Unknown symbol snd_unregister_device
[    2.034088] snd_hwdep: Unknown symbol snd_device_new
[    2.034164] snd_hwdep: Unknown symbol snd_ctl_unregister_ioctl
[    2.034243] snd_hwdep: Unknown symbol snd_lookup_minor_data
[    2.034312] snd_hwdep: Unknown symbol snd_ctl_register_ioctl_compat
[    2.034385] snd_hwdep: Unknown symbol snd_card_file_remove
[    2.034454] snd_hwdep: Unknown symbol snd_register_device_for_dev
[    1.699045] usbcore: registered new interface driver usbfs
[    1.699110] usbcore: registered new interface driver hub
[    1.699194] usbcore: registered new device driver usb
[    1.704509] USB Universal Host Controller Interface driver v3.0
[    1.704630] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    1.704764] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    1.704767] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.704939] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.705031] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fe00
[    1.705186] usb usb1: configuration #1 chosen from 1 choice
[    1.705250] hub 1-0:1.0: USB hub found
[    1.705299] hub 1-0:1.0: 2 ports detected
[    1.709676] snd_hda_intel: Unknown symbol snd_ctl_add
[    1.709759] snd_hda_intel: Unknown symbol snd_pcm_new
[    1.709834] snd_hda_intel: Unknown symbol snd_pcm_limit_hw_rates
[    1.709941] snd_hda_intel: Unknown symbol snd_card_register
[    1.710009] snd_hda_intel: Unknown symbol snd_card_free
[    1.710076] snd_hda_intel: Unknown symbol snd_pcm_lib_preallocate_pages_for_all
[    1.710163] snd_hda_intel: Unknown symbol snd_card_proc_new
[    1.710290] snd_hda_intel: Unknown symbol snd_ctl_find_id
[    1.710406] snd_hda_intel: Unknown symbol snd_ctl_new1
[    1.710505] snd_hda_intel: Unknown symbol snd_component_add
[    1.710580] snd_hda_intel: Unknown symbol snd_card_new
[    1.710647] snd_hda_intel: Unknown symbol snd_iprintf
[    1.710717] snd_hda_intel: Unknown symbol snd_pcm_lib_malloc_pages
[    1.710786] snd_hda_intel: Unknown symbol snd_ctl_boolean_mono_info
[    1.710865] snd_hda_intel: Unknown symbol snd_pcm_lib_ioctl
[    1.710936] snd_hda_intel: Unknown symbol snd_pcm_lib_free_pages
[    1.711005] snd_hda_intel: Unknown symbol snd_hwdep_new
[    1.711079] snd_hda_intel: Unknown symbol snd_pcm_set_ops
[    1.711153] snd_hda_intel: Unknown symbol snd_pcm_hw_constraint_list
[    1.711231] snd_hda_intel: Unknown symbol snd_device_new
[    1.711313] snd_hda_intel: Unknown symbol snd_pcm_suspend_all
[    1.711409] snd_hda_intel: Unknown symbol snd_card_disconnect
[    1.711477] snd_hda_intel: Unknown symbol snd_pcm_hw_constraint_integer
[    1.711589] snd_hda_intel: Unknown symbol snd_pci_quirk_lookup
[    1.711693] snd_hda_intel: Unknown symbol snd_pcm_period_elapsed
[    1.711762] snd_hda_intel: Unknown symbol snd_pcm_hw_constraint_step
[    1.711850] snd_hda_intel: Unknown symbol snd_pcm_format_width
[    2.057807] intel_rng: FWH not detected
[    1.724471] Driver 'sd' needs updating - please use bus_type methods
[    1.724600] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    1.724662] sd 0:0:0:0: [sda] Write Protect is off
[    1.724709] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.724726] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.724841] sd 0:0:0:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    1.724899] sd 0:0:0:0: [sda] Write Protect is off
[    1.724945] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.724961] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.725032]  sda: sda1 sda2 sda3 <<6>iTCO_vendor_support: vendor-support=0
[    1.750139]  sda5<6>iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[    2.087969] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0460)
[    2.088060] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.768536]  sda6 >
[    1.768779] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.806840] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    1.806950] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    1.806952] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.807136] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    1.807228] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fd00
[    1.807360] usb usb2: configuration #1 chosen from 1 choice
[    1.807423] hub 2-0:1.0: USB hub found
[    1.807469] hub 2-0:1.0: 2 ports detected
[    1.903497] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.903592] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    1.903595] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.906691] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    1.907354] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fc00
[    1.907486] usb usb3: configuration #1 chosen from 1 choice
[    1.907550] hub 3-0:1.0: USB hub found
[    1.907596] hub 3-0:1.0: 2 ports detected
[    1.973292] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    1.973390] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    1.973394] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.973470] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    1.973558] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000fb00
[    1.976626] usb usb4: configuration #1 chosen from 1 choice
[    1.976692] hub 4-0:1.0: USB hub found
[    1.976737] hub 4-0:1.0: 2 ports detected
[    2.388101] PM: Starting manual resume from disk
[    2.388147] PM: Resume from partition 8:6
[    2.388148] PM: Checking hibernation image.
[    2.388267] PM: Resume from disk failed.
[    2.390554] ACPI: PCI Interrupt 0000:02:03.0[A] -> GSI 16 (level, low) -> IRQ 16
[    2.390690] skge 1.13 addr 0xfdcfc000 irq 16 chip Yukon-Lite rev 9
[    2.392006] skge eth0: addr 00:01:6c:07:60:b1
[    2.393221] agpgart: Detected an Intel 946GZ Chipset.
[    2.394226] agpgart: Detected 7676K stolen memory.
[    2.410649] agpgart: AGP aperture is 256M @ 0xd0000000
[    2.410766] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    2.410903] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.410907] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.411007] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    2.074816] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    2.415011] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[    2.415018] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdfff000
[    2.093944] kjournald starting.  Commit interval 5 seconds
[    2.431021] EXT3-fs: mounted filesystem with ordered data mode.
[    2.519850] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.520052] usb usb5: configuration #1 chosen from 1 choice
[    2.520130] hub 5-0:1.0: USB hub found
[    2.520178] hub 5-0:1.0: 8 ports detected
[    2.693174] usb 2-1: device not accepting address 2, error -71
[    2.493188] usb 2-1: new low speed USB device using uhci_hcd and address 4
[    3.083141] usb 2-1: configuration #1 chosen from 1 choice
[    5.184856] skge eth0: enabling interface
[    5.435399] NET: Registered protocol family 17
[    5.536551] input: PC Speaker as /class/input/input0
[    8.013322] input: Power Button (FF) as /class/input/input1
[    8.039518] ACPI: Power Button (FF) [PWRF]
[    8.039629] input: Power Button (CM) as /class/input/input2
[    8.066169] ACPI: Power Button (CM) [PWRB]
[    8.098777] Driver 'sr' needs updating - please use bus_type methods
[    8.104062] sr0: scsi3-mmc drive: 0x/52x writer cd/rw xa/form2 cdda tray
[    8.104115] Uniform CD-ROM driver Revision: 3.20
[    8.104203] sr 4:0:1:0: Attached scsi CD-ROM sr0
[    8.177762] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    8.177830] sr 4:0:1:0: Attached scsi generic sg1 type 5
[    8.259383] intel_rng: FWH not detected
[    8.286398] warning: `dhclient3' uses 32-bit capabilities (legacy support in use)
[    8.647121] Floppy drive(s): fd0 is 1.44M
[    8.663320] FDC 0 is a post-1991 82077
[    6.333162] usbcore: registered new interface driver hiddev
[    8.721691] input: LITEON Technology USB Multimedia Keyboard as /class/input/input3
[    8.746123] end_request: I/O error, dev fd0, sector 0
[    8.753184] input,hidraw0: USB HID v1.10 Keyboard [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:1d.1-1
[    8.769304] input: LITEON Technology USB Multimedia Keyboard as /class/input/input4
[    8.789472] input,hidraw1: USB HID v1.10 Device [LITEON Technology USB Multimedia Keyboard] on usb-0000:00:1d.1-1
[    8.789637] usbcore: registered new interface driver usbhid
[    8.789686] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    8.956095] input: ImPS/2 Generic Wheel Mouse as /class/input/input5
[    8.976691] parport_pc 00:09: reported by Plug and Play ACPI
[    8.976785] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    9.033839] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
[    9.033971] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    9.061270] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[    9.369197] lp0: using parport0 (interrupt-driven).
[    9.415562] it87: Found IT8718F chip at 0x290, revision 1
[    9.415623] it87: in3 is VCC (+5V)
[    9.415675] it87: in7 is VCCH (+5V Stand-By)
[    9.433098] coretemp coretemp.0: Using relative temperature scale!
[    9.433184] coretemp coretemp.1: Using relative temperature scale!
[    9.491396] Adding 3941740k swap on /dev/sda6.  Priority:-1 extents:1 across:3941740k
[    7.220298] EXT3 FS on sda5, internal journal
[   10.006027] ip_tables: (C) 2000-2006 Netfilter Core Team
[   16.628943] usb 5-1: new high speed USB device using ehci_hcd and address 3
[   16.690121] usb 5-1: configuration #1 chosen from 1 choice
[   16.738927] usbcore: registered new interface driver libusual
[   16.802228] Initializing USB Mass Storage driver...
[   16.803171] scsi6 : SCSI emulation for USB Mass Storage devices
[   14.063203] usb-storage: device found at 3
[   14.063205] usb-storage: waiting for device to settle before scanning
[   16.803444] usbcore: registered new interface driver usb-storage
[   16.803447] USB Mass Storage support registered.
[   18.008845] usb-storage: device scan complete
[   18.008845] scsi 6:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[   18.008845] scsi 6:0:0:1: Direct-Access     USB2.0   CardReader SD1   0100 PQ: 0 ANSI: 0
[   18.008845] scsi 6:0:0:2: Direct-Access     USB2.0   CardReader SD2   0100 PQ: 0 ANSI: 0
[   18.155502] sd 6:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
[   18.155502] sd 6:0:0:0: [sdb] Write Protect is off
[   18.155502] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   18.155502] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   18.155528] sd 6:0:0:0: [sdb] 15660032 512-byte hardware sectors (8018 MB)
[   18.156152] sd 6:0:0:0: [sdb] Write Protect is off
[   18.156155] sd 6:0:0:0: [sdb] Mode Sense: 03 00 00 00
[   18.156157] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[   18.156211]  sdb: sdb1
[   18.158095] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[   18.158147] sd 6:0:0:0: Attached scsi generic sg2 type 0
[   18.159918] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[   18.159952] sd 6:0:0:1: Attached scsi generic sg3 type 0
[   18.161064] sd 6:0:0:2: [sdd] Attached SCSI removable disk
[   18.161096] sd 6:0:0:2: Attached scsi generic sg4 type 0
[   18.186825] sd 6:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
[   18.186830] sd 6:0:0:0: [sdb] Sense Key : Hardware Error [current] 
[   18.186833] sd 6:0:0:0: [sdb] Add. Sense: Unrecovered read error
[   18.186837] end_request: I/O error, dev sdb, sector 15660024
[   20.546218] NET: Registered protocol family 10
[   20.546563] lo: Disabled Privacy Extensions
[   20.546873] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.038968] skge eth0: disabling interface
[   24.258443] SysRq : Show State
[   24.258443]   task                        PC stack   pid father
[   24.258443] init          S 0000000000000001     0     1      0
[   24.258443]  ffff81007f0519c8 0000000000000086 0000000000000000 0000000000000246
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f04e248 ffff81007f051988 ffff81007f051978 ffff81007f051994
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff804776a5>] schedule_timeout+0x95/0xd0
[   24.258443]  [<ffffffff8024a8a9>] remove_wait_queue+0x19/0x60
[   24.258443]  [<ffffffff8024a96c>] add_wait_queue+0x1c/0x60
[   24.258443]  [<ffffffff804779e9>] mutex_lock+0x9/0x20
[   24.258443]  [<ffffffff802ce407>] inotify_poll+0x57/0x70
[   24.258443]  [<ffffffff802ae797>] do_select+0x467/0x560
[   24.258443]  [<ffffffff8029c640>] __kmalloc_track_caller+0x10/0x110
[   24.258443]  [<ffffffff802aee20>] __pollwait+0x0/0x130
[   24.258443]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258443]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258443]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258443]  [<ffffffff803dfeab>] sock_sendmsg+0x12b/0x140
[   24.258443]  [<ffffffff8033508c>] vsnprintf+0x45c/0x700
[   24.258443]  [<ffffffff80335444>] snprintf+0x44/0x50
[   24.258443]  [<ffffffff802aea99>] core_sys_select+0x209/0x300
[   24.258443]  [<ffffffff80237c4d>] release_task+0x27d/0x350
[   24.258443]  [<ffffffff8024a8a9>] remove_wait_queue+0x19/0x60
[   24.258443]  [<ffffffff80238799>] do_wait+0xa79/0xc50
[   24.258443]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258443]  [<ffffffff802aef94>] sys_select+0x44/0x1b0
[   24.258443]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   24.258443] 
[   24.258443] kthreadd      S 0000000000000001     0     2      0
[   24.258443]  ffff81007f055f00 0000000000000046 0000000000000000 ffffffff8022d168
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f04ea58 ffff81007f055ec0 ffff81007f055eb0 ffff81007f055ecc
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff8022d168>] try_to_wake_up+0x88/0x130
[   24.258443]  [<ffffffff8024a446>] kthreadd+0x166/0x170
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a2e0>] kthreadd+0x0/0x170
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] migration/0   S 0000000000000000     0     3      2
[   24.258443]  ffff81007f059ed0 0000000000000046 0000000000000000 ffff81000100e7c0
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f04f268 ffff81007f059e90 ffff81007f059e80 ffff81007f059e9c
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff802309e0>] migration_thread+0x0/0x230
[   24.258443]  [<ffffffff80230b1a>] migration_thread+0x13a/0x230
[   24.258443]  [<ffffffff802309e0>] migration_thread+0x0/0x230
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] ksoftirqd/0   S 0000000000000000     0     4      2
[   24.258443]  ffff81007f05df00 0000000000000046 0000000000000000 ffffffff8063ffc0
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f05a248 ffff81007f05dec0 ffff81007f05deb0 ffff81007f05decc
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff8023a990>] ksoftirqd+0x0/0xf0
[   24.258443]  [<ffffffff8023aa75>] ksoftirqd+0xe5/0xf0
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] watchdog/0    S 0000000000000000     0     5      2
[   24.258443]  ffff81007f05fed0 0000000000000046 ffff81007f05a810 ffff810001009fc0
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f05aa58 0000000000000006 ffff81007f05a810 ffffffff8022a32a
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff8022a32a>] __update_rq_clock+0x2a/0x100
[   24.258443]  [<ffffffff80270f70>] watchdog+0x0/0x1e0
[   24.258443]  [<ffffffff80270fe8>] watchdog+0x78/0x1e0
[   24.258443]  [<ffffffff80270f70>] watchdog+0x0/0x1e0
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] migration/1   S 0000000000000001     0     6      2
[   24.258443]  ffff81007f063ed0 0000000000000046 0000000000000000 ffff8100010057c0
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f05b268 ffff81007f063e90 ffff81007f063e80 ffff81007f063e9c
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff802309e0>] migration_thread+0x0/0x230
[   24.258443]  [<ffffffff80230b1a>] migration_thread+0x13a/0x230
[   24.258443]  [<ffffffff802309e0>] migration_thread+0x0/0x230
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] ksoftirqd/1   S 0000000000000001     0     7      2
[   24.258443]  ffff81007f06bf00 0000000000000046 0000000000000000 ffffffff8063ffc0
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f068248 ffff81007f06bec0 ffff81007f06beb0 ffff81007f06becc
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff8023a990>] ksoftirqd+0x0/0xf0
[   24.258443]  [<ffffffff8023aa75>] ksoftirqd+0xe5/0xf0
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] watchdog/1    S 0000000000000001     0     8      2
[   24.258443]  ffff81007f06ded0 0000000000000046 ffff81007f068810 ffff810001012fc0
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f068a58 0000000000000006 ffff81007f068810 ffffffff8022a32a
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff8022a32a>] __update_rq_clock+0x2a/0x100
[   24.258443]  [<ffffffff80270f70>] watchdog+0x0/0x1e0
[   24.258443]  [<ffffffff80270fe8>] watchdog+0x78/0x1e0
[   24.258443]  [<ffffffff80270f70>] watchdog+0x0/0x1e0
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] events/0      R  running task        0     9      2
[   24.258443]  ffff81007f09bec0 0000000000000046 0000000000000000 ffffffff8023f294
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f098248 ffff81007f09be80 ffff81007f09be70 ffff81007f09be8c
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff8023f294>] lock_timer_base+0x34/0x70
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258443]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] events/1      S 0000000000000001     0    10      2
[   24.258443]  ffff81007f09dec0 0000000000000046 0000000000000000 ffff81000100f920
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f098a58 ffff81007f09de80 ffff81007f09de70 ffff81007f09de8c
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258443]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] khelper       S 0000000000000001     0    11      2
[   24.258443]  ffff81007f0a1ec0 0000000000000046 ffff810001013020 0000000000000000
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f099268 ffff81007bb8e060 ffffffff80246590 0000000000000000
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff80246590>] wait_for_helper+0x0/0x80
[   24.258443]  [<ffffffff802463e4>] __call_usermodehelper+0x64/0x90
[   24.258443]  [<ffffffff80246380>] __call_usermodehelper+0x0/0x90
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258443]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] kblockd/0     S 0000000000000000     0    46      2
[   24.258443]  ffff81007f227ec0 0000000000000046 0000000000000000 ffff81007b86b258
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f224248 ffff81007f227e80 ffff81007f227e70 ffff81007f227e8c
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff8032aec9>] cfq_kick_queue+0x29/0x50
[   24.258443]  [<ffffffff80321f60>] blk_unplug_work+0x0/0x80
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258443]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] kblockd/1     S 0000000000000001     0    47      2
[   24.258443]  ffff81007f229ec0 0000000000000046 0000000000000000 ffff81007b86b258
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f224a58 ffff81007f229e80 ffff81007f229e70 ffff81007f229e8c
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff80321f60>] blk_unplug_work+0x0/0x80
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258443]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] kacpid        S 0000000000000001     0    49      2
[   24.258443]  ffff81007f22fec0 0000000000000046 0000000000000000 0000000000000000
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f225268 ffff81007f22fe80 ffff81007f22fe70 ffff81007f22fe8c
[   24.258443] Call Trace:
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258443]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258443]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258443]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258443]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258443]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258443] 
[   24.258443] kacpi_notify  S 0000000000000001     0    50      2
[   24.258443]  ffff81007f233ec0 0000000000000046 0000000000000000 0000000000000000
[   24.258443]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258443]  ffff81007f230248 ffff81007f233e80 ffff81007f233e70 ffff81007f233e8c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] ata/0         S 0000000000000000     0   131      2
[   24.258444]  ffff81007f1c5ec0 0000000000000046 ffff81007f1c5e88 ffffffff803b344e
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007f230a58 ffff81007f1c5e80 ffff81007f1c5e70 ffff81007f1c5e8c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff803b344e>] ata_hsm_move+0x12e/0x6d0
[   24.258444]  [<ffffffff803b947b>] ata_pio_task+0x5b/0xd0
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] ata/1         S 0000000000000001     0   132      2
[   24.258444]  ffff81007f251ec0 0000000000000046 0000000000000000 ffffffff803b344e
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007f231268 ffff81007f251e80 ffff81007f251e70 ffff81007f251e8c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff803b344e>] ata_hsm_move+0x12e/0x6d0
[   24.258444]  [<ffffffff803b947b>] ata_pio_task+0x5b/0xd0
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] ata_aux       S 0000000000000001     0   133      2
[   24.258444]  ffff81007f255ec0 0000000000000046 0000000000000000 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007f252248 ffff81007f255e80 ffff81007f255e70 ffff81007f255e8c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] kseriod       S 0000000000000000     0   137      2
[   24.258444]  ffff81007f25fec0 0000000000000046 0000000000000002 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007f252a58 0000000000000000 0000000000000000 ffffffff8039da60
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8039da60>] __driver_attach+0x0/0xd0
[   24.258444]  [<ffffffff8039c859>] next_device+0x9/0x30
[   24.258444]  [<ffffffff803cad7b>] serio_thread+0xeb/0x390
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff803cac90>] serio_thread+0x0/0x390
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] kondemand/0   S 0000000000000000     0   158      2
[   24.258444]  ffff81007f21dec0 0000000000000046 0000000000000000 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007f253268 ffff81007f21de80 ffff81007f21de70 ffff81007f21de8c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] kondemand/1   S 0000000000000001     0   159      2
[   24.258444]  ffff81007f275ec0 0000000000000046 0000000000000000 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007f21e248 ffff81007f275e80 ffff81007f275e70 ffff81007f275e8c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] pdflush       S 0000000000000001     0   186      2
[   24.258444]  ffff81007b871ee0 0000000000000046 0000000000000000 ffffffff8022ce3c
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007f21ea58 ffff81007b871ea0 ffff81007b871e90 ffff81007b871eac
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8022ce3c>] task_rq_lock+0x4c/0x90
[   24.258444]  [<ffffffff8027f1c0>] pdflush+0x0/0x210
[   24.258444]  [<ffffffff8027f29c>] pdflush+0xdc/0x210
[   24.258444]  [<ffffffff8027f1c0>] pdflush+0x0/0x210
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] pdflush       S 0000000000000000     0   187      2
[   24.258444]  ffff81007b875ee0 0000000000000046 0000000000000000 00000000ffff15b9
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007f21f268 ffff81007b875ea0 ffff81007b875e90 ffff81007b875eac
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8027f1c0>] pdflush+0x0/0x210
[   24.258444]  [<ffffffff8027f29c>] pdflush+0xdc/0x210
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] kswapd0       S 0000000000000001     0   188      2
[   24.258444]  ffff81007b879df0 0000000000000046 0000000000000000 ffffffff8022ce3c
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007b876248 ffffffff80230253 0000000000000000 0000000000000003
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8022ce3c>] task_rq_lock+0x4c/0x90
[   24.258444]  [<ffffffff80230253>] set_cpus_allowed+0x73/0x100
[   24.258444]  [<ffffffff8024d0be>] enqueue_hrtimer+0x6e/0x110
[   24.258444]  [<ffffffff80282fc5>] kswapd+0x525/0x540
[   24.258444]  [<ffffffff80476dc7>] thread_return+0x62/0x52b
[   24.258444]  [<ffffffff8022d168>] try_to_wake_up+0x88/0x130
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff80282aa0>] kswapd+0x0/0x540
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] aio/0         S 0000000000000000     0   234      2
[   24.258444]  ffff81007b919ec0 0000000000000046 0000000000000000 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007b876a58 ffff81007b919e80 ffff81007b919e70 ffff81007b919e8c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] aio/1         S 0000000000000001     0   235      2
[   24.258444]  ffff81007b91dec0 0000000000000046 0000000000000000 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007b877268 ffff81007b91de80 ffff81007b91de70 ffff81007b91de8c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] scsi_eh_0     S 0000000000000000     0   378      2
[   24.258444]  ffff81007bb0de70 0000000000000046 0000000000000000 ffff81007bb1a888
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007bb12248 ffff81007bb0de30 ffff81007bb0de20 ffff81007bb0de3c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff803a3af7>] __scsi_iterate_devices+0x67/0x80
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8021d760>] lapic_next_event+0x0/0x10
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] scsi_eh_1     S 0000000000000000     0   380      2
[   24.258444]  ffff81007bac1e70 0000000000000046 0000000300000000 ffff81007bb1e888
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007bb12a58 ffffffff8022bbb3 ffff81007b869800 0000000000000246
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8022bbb3>] __wake_up+0x43/0x70
[   24.258444]  [<ffffffff803a3aea>] __scsi_iterate_devices+0x5a/0x80
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] scsi_eh_2     S 0000000000000000     0   382      2
[   24.258444]  ffff81007b945e70 0000000000000046 0000000300000000 ffff81007bb22888
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007bb13268 ffffffff8022bbb3 ffff81007b86a000 0000000000000246
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8022bbb3>] __wake_up+0x43/0x70
[   24.258444]  [<ffffffff803a3aea>] __scsi_iterate_devices+0x5a/0x80
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] scsi_eh_3     S 0000000000000000     0   384      2
[   24.258444]  ffff81007b87be70 0000000000000046 0000000300000000 ffff81007bb26888
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007b894248 ffffffff8022bbb3 ffff81007b86a800 0000000000000246
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8022bbb3>] __wake_up+0x43/0x70
[   24.258444]  [<ffffffff803a3aea>] __scsi_iterate_devices+0x5a/0x80
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] scsi_eh_4     S 0000000000000000     0   389      2
[   24.258444]  ffff81007bacbe70 0000000000000046 0000000300000000 ffff81007bb16888
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007b894a58 ffffffff8022bbb3 ffff81007b86ca10 ffffffff803301b2
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8022bbb3>] __wake_up+0x43/0x70
[   24.258444]  [<ffffffff803301b2>] kobject_get+0x12/0x20
[   24.258444]  [<ffffffff803a3af7>] __scsi_iterate_devices+0x67/0x80
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] scsi_eh_5     S 0000000000000000     0   391      2
[   24.258444]  ffff81007bacfe70 0000000000000046 0000000000000000 ffff81007baea888
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007b895268 ffff81007bacfe30 ffff81007bacfe20 ffff81007bacfe3c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff803a3aea>] __scsi_iterate_devices+0x5a/0x80
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   24.258444]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] krxrpcd/0     S 0000000000000000     0   405      2
[   24.258444]  ffff81007b969ec0 0000000000000046 ffff81007b969e50 ffff810001009fc0
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007bae6248 ffffffff805ab080 ffff810001009fc0 0000000000000000
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8022d168>] try_to_wake_up+0x88/0x130
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] krxrpcd/1     S 0000000000000001     0   406      2
[   24.258444]  ffff81007b96bec0 0000000000000046 ffff81007b96be50 ffff810001012fc0
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007bae6a58 ffffffff805ab080 ffff810001012fc0 0000000000000001
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8022d168>] try_to_wake_up+0x88/0x130
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] ksuspend_usbd S 0000000000000000     0  1313      2
[   24.258444]  ffff81007badfec0 0000000000000046 ffff81007f247800 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007ba58a58 ffff81007f247db8 ffff81007f247800 0000000000000000
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff88040b70>] :usbcore:hcd_resume_work+0x0/0x70
[   24.258444]  [<ffffffff88040bb8>] :usbcore:hcd_resume_work+0x48/0x70
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] khubd         S 0000000000000000     0  1317      2
[   24.258444]  ffff81007ba25e00 0000000000000046 000000087bcca9e8 8000018000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007b813268 ffff81007f247800 0000000000000008 ffff81007f2b4938
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8803f6fd>] :usbcore:hub_thread+0x10d/0xf00
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff8803f5f0>] :usbcore:hub_thread+0x0/0xf00
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] kjournald     S 0000000000000000     0  1642      2
[   24.258444]  ffff81003786fea0 0000000000000046 0000000000000000 ffffffff880c0b92
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81003789d268 ffff81003786fe60 ffff81003786fe50 ffff81003786fe6c
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff880c0b92>] :jbd:journal_commit_transaction+0xcd2/0xdc0
[   24.258444]  [<ffffffff880c3b34>] :jbd:kjournald+0x214/0x220
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff880c3920>] :jbd:kjournald+0x0/0x220
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] udevd         S 0000000000000000     0  2636      1
[   24.258444]  ffff8100378639c8 0000000000000082 0000000000000000 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007e607268 ffff810037863988 ffff810037863978 ffff810037863994
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff80285db3>] do_wp_page+0x3a3/0x540
[   24.258444]  [<ffffffff804776a5>] schedule_timeout+0x95/0xd0
[   24.258444]  [<ffffffff802889f3>] handle_mm_fault+0x613/0x7c0
[   24.258444]  [<ffffffff8024a8a9>] remove_wait_queue+0x19/0x60
[   24.258444]  [<ffffffff8024a96c>] add_wait_queue+0x1c/0x60
[   24.258444]  [<ffffffff802a5f0d>] pipe_poll+0x2d/0xa0
[   24.258444]  [<ffffffff802ae797>] do_select+0x467/0x560
[   24.258444]  [<ffffffff802aee20>] __pollwait+0x0/0x130
[   24.258444]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258444]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258444]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258444]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258444]  [<ffffffff8027d25e>] __alloc_pages+0x9e/0x3c0
[   24.258444]  [<ffffffff802887cd>] handle_mm_fault+0x3ed/0x7c0
[   24.258444]  [<ffffffff8029b907>] kmem_cache_alloc+0x67/0xa0
[   24.258444]  [<ffffffff802aea99>] core_sys_select+0x209/0x300
[   24.258444]  [<ffffffff8029147c>] free_pages_and_swap_cache+0x8c/0xb0
[   24.258444]  [<ffffffff8028a997>] unmap_region+0x147/0x160
[   24.258444]  [<ffffffff802aef94>] sys_select+0x44/0x1b0
[   24.258444]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   24.258444] 
[   24.258444] kpsmoused     S 0000000000000001     0  3185      2
[   24.258444]  ffff81007d523ec0 0000000000000046 ffff81007d523e50 ffff810001012fc0
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007e79f268 ffff8100378e9040 ffff810001012fc0 0000000000000001
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   24.258444]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   24.258444]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258444]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258444]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258444]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258444] 
[   24.258444] sh            S 0000000000000000     0  4248      1
[   24.258444]  ffff81007e6b9e28 0000000000000086 0000000000000000 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81003740aa58 ffff81007e6b9de8 ffff81007e6b9dd8 ffff81007e6b9df4
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8023831b>] do_wait+0x5fb/0xc50
[   24.258444]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258444]  [<ffffffff802389f2>] sys_wait4+0x82/0xd0
[   24.258444]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   24.258444] 
[   24.258444] recovery-menu S 0000000000000000     0  4250   4248
[   24.258444]  ffff81007e585e28 0000000000000082 0000000000000000 0000000000000000
[   24.258444]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258444]  ffff81007e79e248 ffff81007e585de8 ffff81007e585dd8 ffff81007e585df4
[   24.258444] Call Trace:
[   24.258444]  [<ffffffff8023831b>] do_wait+0x5fb/0xc50
[   24.258444]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258445]  [<ffffffff8024028e>] sys_rt_sigaction+0x8e/0xc0
[   24.258445]  [<ffffffff802389f2>] sys_wait4+0x82/0xd0
[   24.258445]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   24.258445] 
[   24.258445] root          S 0000000000000000     0  4415   4250
[   24.258445]  ffff81007b9f9e28 0000000000000086 0000000000000000 0000000000000000
[   24.258445]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258445]  ffff81003740a248 ffff81007b9f9de8 ffff81007b9f9dd8 ffff81007b9f9df4
[   24.258445] Call Trace:
[   24.258445]  [<ffffffff8023831b>] do_wait+0x5fb/0xc50
[   24.258445]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258445]  [<ffffffff802389f2>] sys_wait4+0x82/0xd0
[   24.258445]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   24.258445] 
[   24.258445] bash          S 0000000000000001     0  4416   4415
[   24.258445]  ffff81007f2dfd78 0000000000000086 0000000000000000 ffffffff803789e1
[   24.258445]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258445]  ffff81007e79ea58 ffff81007f2dfd38 ffff81007f2dfd28 ffff81007f2dfd44
[   24.258445] Call Trace:
[   24.258445]  [<ffffffff803789e1>] tty_ldisc_try+0x41/0x60
[   24.258445]  [<ffffffff80389f3c>] do_con_write+0x1dc/0x1c30
[   24.258445]  [<ffffffff804776a5>] schedule_timeout+0x95/0xd0
[   24.258445]  [<ffffffff802424d1>] get_signal_to_deliver+0x91/0x350
[   24.258445]  [<ffffffff8024a96c>] add_wait_queue+0x1c/0x60
[   24.258445]  [<ffffffff8037f111>] read_chan+0x231/0x7a0
[   24.258445]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258445]  [<ffffffff80379c6e>] tty_ldisc_ref_wait+0xe/0xa0
[   24.258445]  [<ffffffff80378972>] tty_ldisc_deref+0x52/0x80
[   24.258445]  [<ffffffff8037bd5f>] tty_read+0xaf/0x100
[   24.258445]  [<ffffffff802a0295>] vfs_read+0xc5/0x180
[   24.258445]  [<ffffffff802a0793>] sys_read+0x53/0x90
[   24.258445]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   24.258445] 
[   24.258445] scsi_eh_6     S 0000000000000001     0  5914      2
[   24.258445]  ffff81003743be70 0000000000000046 ffff8100010137e8 ffff81000100f2f8
[   24.258445]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258445]  ffff81007e606248 ffff81007f04e848 0000000000000282 ffff8100010137e8
[   24.258445] Call Trace:
[   24.258445]  [<ffffffff8022fbd1>] hrtick_set+0x91/0x140
[   24.258445]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258445]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   24.258445]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   24.258445]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258445]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258445]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258445]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258445] 
[   24.258445] usb-storage   S 0000000000000000     0  5916      2
[   24.258445]  ffff810037431e10 0000000000000046 ffff810037431e04 0000000000000000
[   24.258445]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258445]  ffff81007e606a58 ffffffff8024fbd3 0000000000000000 00000000000050d6
[   24.258445] Call Trace:
[   24.258445]  [<ffffffff8024fbd3>] getnstimeofday+0x33/0xa0
[   24.258445]  [<ffffffff8024dc4c>] ktime_get+0xc/0x50
[   24.258445]  [<ffffffff80478adf>] __down_interruptible+0xaf/0x150
[   24.258445]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258445]  [<ffffffff804788fc>] __down_failed_interruptible+0x35/0x3a
[   24.258445]  [<ffffffff8824f1c4>] :usb_storage:usb_stor_control_thread+0x74/0x220
[   24.258445]  [<ffffffff8824f150>] :usb_storage:usb_stor_control_thread+0x0/0x220
[   24.258445]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   24.258445]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   24.258445]  [<ffffffff8024a260>] kthread+0x0/0x80
[   24.258445]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   24.258445] 
[   24.258445] udevd         S 0000000000000000     0  6263   2636
[   24.258445]  ffff8100374399c8 0000000000000082 ffff810037439990 ffffffff8024dc0b
[   24.258445]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258445]  ffff810037884a58 ffff810037439988 ffff810037439978 ffff810037439994
[   24.258445] Call Trace:
[   24.258445]  [<ffffffff8024dc0b>] ktime_get_ts+0x1b/0x50
[   24.258445]  [<ffffffff804776a5>] schedule_timeout+0x95/0xd0
[   24.258445]  [<ffffffff8024a8a9>] remove_wait_queue+0x19/0x60
[   24.258445]  [<ffffffff8024a96c>] add_wait_queue+0x1c/0x60
[   24.258445]  [<ffffffff802a5f0d>] pipe_poll+0x2d/0xa0
[   24.258445]  [<ffffffff802ae797>] do_select+0x467/0x560
[   24.258445]  [<ffffffff802aee20>] __pollwait+0x0/0x130
[   24.258445]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   24.258445]  [<ffffffff8027bc4f>] __rmqueue+0x2f/0x240
[   24.258445]  [<ffffffff803343fc>] number+0x29c/0x2c0
[   24.258445]  [<ffffffff8027ce52>] get_page_from_freelist+0x312/0x460
[   24.258445]  [<ffffffff8027d25e>] __alloc_pages+0x9e/0x3c0
[   24.258445]  [<ffffffff80286fd9>] __pte_alloc+0x99/0x100
[   24.258445]  [<ffffffff80247c24>] alloc_pid+0x24/0x3f0
[   24.258445]  [<ffffffff802aea99>] core_sys_select+0x209/0x300
[   24.258445]  [<ffffffff80285db3>] do_wp_page+0x3a3/0x540
[   24.258445]  [<ffffffff8024dc4c>] ktime_get+0xc/0x50
[   24.258445]  [<ffffffff802889f3>] handle_mm_fault+0x613/0x7c0
[   24.258445]  [<ffffffff802aef94>] sys_select+0x44/0x1b0
[   24.258445]  [<ffffffff8029d9c4>] filp_close+0x54/0x90
[   24.258445]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   24.258445] 
[   24.258445] vol_id        D 0000000000000000     0  6276   6263
[   24.258445]  ffff81007e2e5c18 0000000000000086 ffff81007e2e5b80 ffffffff8031ebcb
[   24.258445]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   24.258445]  ffff81007e2e2248 ffff81007bccc000 ffff81007bccd800 ffff810037876378
[   24.258445] Call Trace:
[   24.258445]  [<ffffffff8031ebcb>] elv_next_request+0x11b/0x260
[   24.258445]  [<ffffffff80279310>] sync_page_killable+0x0/0x40
[   24.258445]  [<ffffffff804775d8>] io_schedule+0x28/0x40
[   24.258445]  [<ffffffff802775a5>] sync_page+0x35/0x50
[   24.258445]  [<ffffffff80279319>] sync_page_killable+0x9/0x40
[   24.258445]  [<ffffffff8047778a>] __wait_on_bit_lock+0x4a/0x80
[   24.258445]  [<ffffffff802774df>] __lock_page_killable+0x5f/0x70
[   24.258445]  [<ffffffff8024a6d0>] wake_bit_function+0x0/0x30
[   24.258445]  [<ffffffff8027973b>] generic_file_aio_read+0x3ab/0x5f0
[   24.258445]  [<ffffffff8029f8e9>] do_sync_read+0xd9/0x120
[   24.258445]  [<ffffffff8027d25e>] __alloc_pages+0x9e/0x3c0
[   24.258445]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   24.258445]  [<ffffffff802887cd>] handle_mm_fault+0x3ed/0x7c0
[   24.258445]  [<ffffffff8028ba8e>] vma_merge+0x16e/0x1f0
[   24.258445]  [<ffffffff802a0295>] vfs_read+0xc5/0x180
[   24.258445]  [<ffffffff802a0793>] sys_read+0x53/0x90
[   24.258445]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   24.258445] 
[   24.258445] Sched Debug Version: v0.07, 2.6.25 #5
[   24.258445] now at 95691.182310 msecs
[   24.258445]   .sysctl_sched_latency                    : 40.000000
[   24.258445]   .sysctl_sched_min_granularity            : 8.000000
[   24.258445]   .sysctl_sched_wakeup_granularity         : 10.000000
[   24.258445]   .sysctl_sched_batch_wakeup_granularity   : 20.000000
[   24.258445]   .sysctl_sched_child_runs_first           : 0.000001
[   24.258445]   .sysctl_sched_features                   : 15
[   24.258445] 
[   24.258445] cpu#0, 2128.007 MHz
[   24.258445]   .nr_running                    : 1
[   24.258445]   .load                          : 3121
[   24.258445]   .nr_switches                   : 24311
[   24.258445]   .nr_load_updates               : 7277
[   24.258445]   .nr_uninterruptible            : -53
[   24.258445]   .jiffies                       : 4294906003
[   24.258445]   .next_balance                  : 4294.905799
[   24.258445]   .curr->pid                     : 0
[   24.258445]   .clock                         : 24258.445286
[   24.258445]   .idle_clock                    : 0.000000
[   24.258445]   .prev_clock_raw                : 121227.665692
[   24.258445]   .clock_warps                   : 0
[   24.258445]   .clock_overflows               : 29240
[   24.258445]   .clock_underflows              : 5079
[   24.258445]   .clock_deep_idle_events        : 4
[   24.258445]   .clock_max_delta               : 3.332759
[   24.258445]   .cpu_load[0]                   : 0
[   24.258445]   .cpu_load[1]                   : 0
[   24.258445]   .cpu_load[2]                   : 0
[   24.258445]   .cpu_load[3]                   : 0
[   24.258445]   .cpu_load[4]                   : 13
[   24.258445] 
[   24.258445] cfs_rq
[   24.258445]   .exec_clock                    : 0.000000
[   24.258445]   .MIN_vruntime                  : 1936.782109
[   24.258445]   .min_vruntime                  : 1936.782109
[   24.258445]   .max_vruntime                  : 1936.782109
[   24.258445]   .spread                        : 0.000000
[   24.258445]   .spread0                       : 0.000000
[   24.258445]   .nr_running                    : 1
[   24.258445]   .load                          : 2048
[   24.258445]   .nr_spread_over                : 0
[   24.258445] 
[   24.258445] cfs_rq
[   24.258445]   .exec_clock                    : 0.000000
[   24.258445]   .MIN_vruntime                  : 0.000001
[   24.258445]   .min_vruntime                  : 1936.782109
[   24.258445]   .max_vruntime                  : 0.000001
[   24.258445]   .spread                        : 0.000000
[   24.258445]   .spread0                       : 0.000000
[   24.258445]   .nr_running                    : 0
[   24.258445]   .load                          : 0
[   24.258445]   .nr_spread_over                : 0
[   24.258445] 
[   24.258445] cfs_rq
[   24.258445]   .exec_clock                    : 0.000000
[   24.258445]   .MIN_vruntime                  : 89185.244757
[   24.258445]   .min_vruntime                  : 1936.782109
[   24.258445]   .max_vruntime                  : 89185.244757
[   24.258445]   .spread                        : 0.000000
[   24.258445]   .spread0                       : 0.000000
[   24.258445]   .nr_running                    : 1
[   24.258445]   .load                          : 3121
[   24.258445]   .nr_spread_over                : 0
[   24.258445] 
[   24.258445] runnable tasks:
[   24.258445]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[   24.258445] ----------------------------------------------------------------------------------------------------------
[   24.258445]         events/0     9     89185.244757       339   115               0               0               0.000000               0.000000               0.000000
[   24.258445] 
[   24.258445] cpu#1, 2128.007 MHz
[   24.258445]   .nr_running                    : 0
[   24.258445]   .load                          : 0
[   24.258445]   .nr_switches                   : 20637
[   24.258445]   .nr_load_updates               : 6308
[   24.258445]   .nr_uninterruptible            : 54
[   24.258445]   .jiffies                       : 4294906003
[   24.258445]   .next_balance                  : 4294.901533
[   24.258445]   .curr->pid                     : 0
[   24.258445]   .clock                         : 21025.328031
[   24.258445]   .idle_clock                    : 0.000000
[   24.258445]   .prev_clock_raw                : 121129.914437
[   24.258445]   .clock_warps                   : 0
[   24.258445]   .clock_overflows               : 24179
[   24.258445]   .clock_underflows              : 4296
[   24.258445]   .clock_deep_idle_events        : 0
[   24.258445]   .clock_max_delta               : 3.333097
[   24.258445]   .cpu_load[0]                   : 0
[   24.258445]   .cpu_load[1]                   : 0
[   24.258445]   .cpu_load[2]                   : 0
[   24.258445]   .cpu_load[3]                   : 0
[   24.258445]   .cpu_load[4]                   : 0
[   24.258445] 
[   24.258445] cfs_rq
[   24.258445]   .exec_clock                    : 0.000000
[   24.258445]   .MIN_vruntime                  : 0.000001
[   24.258445]   .min_vruntime                  : 1295.758197
[   24.258445]   .max_vruntime                  : 0.000001
[   24.258445]   .spread                        : 0.000000
[   24.258445]   .spread0                       : -641.023912
[   24.258445]   .nr_running                    : 0
[   24.258445]   .load                          : 0
[   24.258445]   .nr_spread_over                : 0
[   24.258445] 
[   24.258445] cfs_rq
[   24.258445]   .exec_clock                    : 0.000000
[   24.258445]   .MIN_vruntime                  : 0.000001
[   24.258445]   .min_vruntime                  : 1295.758197
[   24.258445]   .max_vruntime                  : 0.000001
[   24.258445]   .spread                        : 0.000000
[   24.258445]   .spread0                       : -641.023912
[   24.258445]   .nr_running                    : 0
[   24.258445]   .load                          : 0
[   24.258445]   .nr_spread_over                : 0
[   24.258445] 
[   24.258445] cfs_rq
[   24.258445]   .exec_clock                    : 0.000000
[   24.258445]   .MIN_vruntime                  : 0.000001
[   24.258445]   .min_vruntime                  : 1295.758197
[   24.258445]   .max_vruntime                  : 0.000001
[   24.258445]   .spread                        : 0.000000
[   24.258445]   .spread0                       : -641.023912
[   24.258445]   .nr_running                    : 0
[   24.258445]   .load                          : 0
[   24.258445]   .nr_spread_over                : 0
[   24.258445] 
[   24.258445] runnable tasks:
[   24.258445]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[   24.258445] ----------------------------------------------------------------------------------------------------------
[   24.258445] 
[   24.745080] usb 5-1: USB disconnect, address 3
[   25.128389] SysRq : Show State
[   25.128389]   task                        PC stack   pid father
[   25.128389] init          S 0000000000000001     0     1      0
[   25.128389]  ffff81007f0519c8 0000000000000086 0000000000000000 0000000000000246
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f04e248 ffff81007f051988 ffff81007f051978 ffff81007f051994
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff804776a5>] schedule_timeout+0x95/0xd0
[   25.128389]  [<ffffffff8024a8a9>] remove_wait_queue+0x19/0x60
[   25.128389]  [<ffffffff8024a96c>] add_wait_queue+0x1c/0x60
[   25.128389]  [<ffffffff804779e9>] mutex_lock+0x9/0x20
[   25.128389]  [<ffffffff802ce407>] inotify_poll+0x57/0x70
[   25.128389]  [<ffffffff802ae797>] do_select+0x467/0x560
[   25.128389]  [<ffffffff8029c640>] __kmalloc_track_caller+0x10/0x110
[   25.128389]  [<ffffffff802aee20>] __pollwait+0x0/0x130
[   25.128389]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128389]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128389]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128389]  [<ffffffff803dfeab>] sock_sendmsg+0x12b/0x140
[   25.128389]  [<ffffffff8033508c>] vsnprintf+0x45c/0x700
[   25.128389]  [<ffffffff80335444>] snprintf+0x44/0x50
[   25.128389]  [<ffffffff802aea99>] core_sys_select+0x209/0x300
[   25.128389]  [<ffffffff80237c4d>] release_task+0x27d/0x350
[   25.128389]  [<ffffffff8024a8a9>] remove_wait_queue+0x19/0x60
[   25.128389]  [<ffffffff80238799>] do_wait+0xa79/0xc50
[   25.128389]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128389]  [<ffffffff802aef94>] sys_select+0x44/0x1b0
[   25.128389]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   25.128389] 
[   25.128389] kthreadd      S 0000000000000001     0     2      0
[   25.128389]  ffff81007f055f00 0000000000000046 0000000000000000 ffffffff8022d168
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f04ea58 ffff81007f055ec0 ffff81007f055eb0 ffff81007f055ecc
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff8022d168>] try_to_wake_up+0x88/0x130
[   25.128389]  [<ffffffff8024a446>] kthreadd+0x166/0x170
[   25.128389]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128389]  [<ffffffff8024a2e0>] kthreadd+0x0/0x170
[   25.128389]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128389] 
[   25.128389] migration/0   S 0000000000000000     0     3      2
[   25.128389]  ffff81007f059ed0 0000000000000046 0000000000000000 ffff81000100e7c0
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f04f268 ffff81007f059e90 ffff81007f059e80 ffff81007f059e9c
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff802309e0>] migration_thread+0x0/0x230
[   25.128389]  [<ffffffff80230b1a>] migration_thread+0x13a/0x230
[   25.128389]  [<ffffffff802309e0>] migration_thread+0x0/0x230
[   25.128389]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128389]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128389]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128389]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128389] 
[   25.128389] ksoftirqd/0   S 0000000000000000     0     4      2
[   25.128389]  ffff81007f05df00 0000000000000046 0000000000000000 ffffffff8063ffc0
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f05a248 ffff81007f05dec0 ffff81007f05deb0 ffff81007f05decc
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff8023a990>] ksoftirqd+0x0/0xf0
[   25.128389]  [<ffffffff8023aa75>] ksoftirqd+0xe5/0xf0
[   25.128389]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128389]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128389]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128389]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128389] 
[   25.128389] watchdog/0    S 0000000000000000     0     5      2
[   25.128389]  ffff81007f05fed0 0000000000000046 ffff81007f05a810 ffff810001009fc0
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f05aa58 0000000000000006 ffff81007f05a810 ffffffff8022a32a
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff8022a32a>] __update_rq_clock+0x2a/0x100
[   25.128389]  [<ffffffff80270f70>] watchdog+0x0/0x1e0
[   25.128389]  [<ffffffff80270fe8>] watchdog+0x78/0x1e0
[   25.128389]  [<ffffffff80270f70>] watchdog+0x0/0x1e0
[   25.128389]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128389]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128389]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128389]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128389] 
[   25.128389] migration/1   S 0000000000000001     0     6      2
[   25.128389]  ffff81007f063ed0 0000000000000046 0000000000000000 ffff8100010057c0
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f05b268 ffff81007f063e90 ffff81007f063e80 ffff81007f063e9c
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff802309e0>] migration_thread+0x0/0x230
[   25.128389]  [<ffffffff80230b1a>] migration_thread+0x13a/0x230
[   25.128389]  [<ffffffff802309e0>] migration_thread+0x0/0x230
[   25.128389]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128389]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128389]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128389]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128389] 
[   25.128389] ksoftirqd/1   S 0000000000000001     0     7      2
[   25.128389]  ffff81007f06bf00 0000000000000046 0000000000000000 ffffffff8063ffc0
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f068248 ffff81007f06bec0 ffff81007f06beb0 ffff81007f06becc
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff8023a990>] ksoftirqd+0x0/0xf0
[   25.128389]  [<ffffffff8023aa75>] ksoftirqd+0xe5/0xf0
[   25.128389]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128389]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128389]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128389]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128389] 
[   25.128389] watchdog/1    S 0000000000000001     0     8      2
[   25.128389]  ffff81007f06ded0 0000000000000046 ffff81007f068810 ffff810001012fc0
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f068a58 0000000000000006 ffff81007f068810 ffffffff8022a32a
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff8022a32a>] __update_rq_clock+0x2a/0x100
[   25.128389]  [<ffffffff80270f70>] watchdog+0x0/0x1e0
[   25.128389]  [<ffffffff80270fe8>] watchdog+0x78/0x1e0
[   25.128389]  [<ffffffff80270f70>] watchdog+0x0/0x1e0
[   25.128389]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128389]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128389]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128389]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128389] 
[   25.128389] events/0      R  running task        0     9      2
[   25.128389]  ffff81007f09bec0 0000000000000046 0000000000000000 ffffffff8023f294
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f098248 ffff81007f09be80 ffff81007f09be70 ffff81007f09be8c
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff8023f294>] lock_timer_base+0x34/0x70
[   25.128389]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128389]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128389]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128389]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128389]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128389]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128389]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128389]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128389]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128389] 
[   25.128389] events/1      S 0000000000000001     0    10      2
[   25.128389]  ffff81007f09dec0 0000000000000046 0000000000000000 ffff81000100f920
[   25.128389]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128389]  ffff81007f098a58 ffff81007f09de80 ffff81007f09de70 ffff81007f09de8c
[   25.128389] Call Trace:
[   25.128389]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128389]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128389]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] khelper       S 0000000000000001     0    11      2
[   25.128390]  ffff81007f0a1ec0 0000000000000046 ffff810001013020 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f099268 ffff81007bb8e060 ffffffff80246590 0000000000000000
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff80246590>] wait_for_helper+0x0/0x80
[   25.128390]  [<ffffffff802463e4>] __call_usermodehelper+0x64/0x90
[   25.128390]  [<ffffffff80246380>] __call_usermodehelper+0x0/0x90
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] kblockd/0     S 0000000000000000     0    46      2
[   25.128390]  ffff81007f227ec0 0000000000000046 0000000000000000 ffff81007b86b258
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f224248 ffff81007f227e80 ffff81007f227e70 ffff81007f227e8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8032aec9>] cfq_kick_queue+0x29/0x50
[   25.128390]  [<ffffffff80321f60>] blk_unplug_work+0x0/0x80
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] kblockd/1     S 0000000000000001     0    47      2
[   25.128390]  ffff81007f229ec0 0000000000000046 0000000000000000 ffff81007b86b258
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f224a58 ffff81007f229e80 ffff81007f229e70 ffff81007f229e8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff80321f60>] blk_unplug_work+0x0/0x80
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] kacpid        S 0000000000000001     0    49      2
[   25.128390]  ffff81007f22fec0 0000000000000046 0000000000000000 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f225268 ffff81007f22fe80 ffff81007f22fe70 ffff81007f22fe8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] kacpi_notify  S 0000000000000001     0    50      2
[   25.128390]  ffff81007f233ec0 0000000000000046 0000000000000000 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f230248 ffff81007f233e80 ffff81007f233e70 ffff81007f233e8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] ata/0         S 0000000000000000     0   131      2
[   25.128390]  ffff81007f1c5ec0 0000000000000046 ffff81007f1c5e88 ffffffff803b344e
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f230a58 ffff81007f1c5e80 ffff81007f1c5e70 ffff81007f1c5e8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff803b344e>] ata_hsm_move+0x12e/0x6d0
[   25.128390]  [<ffffffff803b947b>] ata_pio_task+0x5b/0xd0
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] ata/1         S 0000000000000001     0   132      2
[   25.128390]  ffff81007f251ec0 0000000000000046 0000000000000000 ffffffff803b344e
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f231268 ffff81007f251e80 ffff81007f251e70 ffff81007f251e8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff803b344e>] ata_hsm_move+0x12e/0x6d0
[   25.128390]  [<ffffffff803b947b>] ata_pio_task+0x5b/0xd0
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] ata_aux       S 0000000000000001     0   133      2
[   25.128390]  ffff81007f255ec0 0000000000000046 0000000000000000 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f252248 ffff81007f255e80 ffff81007f255e70 ffff81007f255e8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] kseriod       S 0000000000000000     0   137      2
[   25.128390]  ffff81007f25fec0 0000000000000046 0000000000000002 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f252a58 0000000000000000 0000000000000000 ffffffff8039da60
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8039da60>] __driver_attach+0x0/0xd0
[   25.128390]  [<ffffffff8039c859>] next_device+0x9/0x30
[   25.128390]  [<ffffffff803cad7b>] serio_thread+0xeb/0x390
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff803cac90>] serio_thread+0x0/0x390
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] kondemand/0   S 0000000000000000     0   158      2
[   25.128390]  ffff81007f21dec0 0000000000000046 0000000000000000 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f253268 ffff81007f21de80 ffff81007f21de70 ffff81007f21de8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] kondemand/1   S 0000000000000001     0   159      2
[   25.128390]  ffff81007f275ec0 0000000000000046 0000000000000000 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f21e248 ffff81007f275e80 ffff81007f275e70 ffff81007f275e8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] pdflush       S 0000000000000001     0   186      2
[   25.128390]  ffff81007b871ee0 0000000000000046 0000000000000000 ffffffff8022ce3c
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f21ea58 ffff81007b871ea0 ffff81007b871e90 ffff81007b871eac
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8022ce3c>] task_rq_lock+0x4c/0x90
[   25.128390]  [<ffffffff8027f1c0>] pdflush+0x0/0x210
[   25.128390]  [<ffffffff8027f29c>] pdflush+0xdc/0x210
[   25.128390]  [<ffffffff8027f1c0>] pdflush+0x0/0x210
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] pdflush       S 0000000000000000     0   187      2
[   25.128390]  ffff81007b875ee0 0000000000000046 0000000000000000 00000000ffff3305
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007f21f268 ffff81007b875ea0 ffff81007b875e90 ffff81007b875eac
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8027f1c0>] pdflush+0x0/0x210
[   25.128390]  [<ffffffff8027f29c>] pdflush+0xdc/0x210
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] kswapd0       S 0000000000000001     0   188      2
[   25.128390]  ffff81007b879df0 0000000000000046 0000000000000000 ffffffff8022ce3c
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007b876248 ffffffff80230253 0000000000000000 0000000000000003
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8022ce3c>] task_rq_lock+0x4c/0x90
[   25.128390]  [<ffffffff80230253>] set_cpus_allowed+0x73/0x100
[   25.128390]  [<ffffffff8024d0be>] enqueue_hrtimer+0x6e/0x110
[   25.128390]  [<ffffffff80282fc5>] kswapd+0x525/0x540
[   25.128390]  [<ffffffff80476dc7>] thread_return+0x62/0x52b
[   25.128390]  [<ffffffff8022d168>] try_to_wake_up+0x88/0x130
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff80282aa0>] kswapd+0x0/0x540
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] aio/0         S 0000000000000000     0   234      2
[   25.128390]  ffff81007b919ec0 0000000000000046 0000000000000000 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007b876a58 ffff81007b919e80 ffff81007b919e70 ffff81007b919e8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] aio/1         S 0000000000000001     0   235      2
[   25.128390]  ffff81007b91dec0 0000000000000046 0000000000000000 0000000000000000
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007b877268 ffff81007b91de80 ffff81007b91de70 ffff81007b91de8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] scsi_eh_0     S 0000000000000000     0   378      2
[   25.128390]  ffff81007bb0de70 0000000000000046 0000000000000000 ffff81007bb1a888
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007bb12248 ffff81007bb0de30 ffff81007bb0de20 ffff81007bb0de3c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff803a3af7>] __scsi_iterate_devices+0x67/0x80
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8021d760>] lapic_next_event+0x0/0x10
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] scsi_eh_1     S 0000000000000000     0   380      2
[   25.128390]  ffff81007bac1e70 0000000000000046 0000000300000000 ffff81007bb1e888
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007bb12a58 ffffffff8022bbb3 ffff81007b869800 0000000000000246
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8022bbb3>] __wake_up+0x43/0x70
[   25.128390]  [<ffffffff803a3aea>] __scsi_iterate_devices+0x5a/0x80
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] scsi_eh_2     S 0000000000000000     0   382      2
[   25.128390]  ffff81007b945e70 0000000000000046 0000000300000000 ffff81007bb22888
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007bb13268 ffffffff8022bbb3 ffff81007b86a000 0000000000000246
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8022bbb3>] __wake_up+0x43/0x70
[   25.128390]  [<ffffffff803a3aea>] __scsi_iterate_devices+0x5a/0x80
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] scsi_eh_3     S 0000000000000000     0   384      2
[   25.128390]  ffff81007b87be70 0000000000000046 0000000300000000 ffff81007bb26888
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007b894248 ffffffff8022bbb3 ffff81007b86a800 0000000000000246
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8022bbb3>] __wake_up+0x43/0x70
[   25.128390]  [<ffffffff803a3aea>] __scsi_iterate_devices+0x5a/0x80
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] scsi_eh_4     S 0000000000000000     0   389      2
[   25.128390]  ffff81007bacbe70 0000000000000046 0000000300000000 ffff81007bb16888
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007b894a58 ffffffff8022bbb3 ffff81007b86ca10 ffffffff803301b2
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8022bbb3>] __wake_up+0x43/0x70
[   25.128390]  [<ffffffff803301b2>] kobject_get+0x12/0x20
[   25.128390]  [<ffffffff803a3af7>] __scsi_iterate_devices+0x67/0x80
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] scsi_eh_5     S 0000000000000000     0   391      2
[   25.128390]  ffff81007bacfe70 0000000000000046 0000000000000000 ffff81007baea888
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007b895268 ffff81007bacfe30 ffff81007bacfe20 ffff81007bacfe3c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff803a3aea>] __scsi_iterate_devices+0x5a/0x80
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   25.128390]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] krxrpcd/0     S 0000000000000000     0   405      2
[   25.128390]  ffff81007b969ec0 0000000000000046 ffff81007b969e50 ffff810001009fc0
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007bae6248 ffffffff805ab080 ffff810001009fc0 0000000000000000
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8022d168>] try_to_wake_up+0x88/0x130
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] krxrpcd/1     S 0000000000000001     0   406      2
[   25.128390]  ffff81007b96bec0 0000000000000046 ffff81007b96be50 ffff810001012fc0
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007bae6a58 ffffffff805ab080 ffff810001012fc0 0000000000000001
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8022d168>] try_to_wake_up+0x88/0x130
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] ksuspend_usbd S 0000000000000000     0  1313      2
[   25.128390]  ffff81007badfec0 0000000000000046 0000000000000000 0000000000000010
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007ba58a58 ffff81007badfe80 ffff81007badfe70 ffff81007badfe8c
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128390]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128390]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128390] 
[   25.128390] khubd         S 0000000000000000     0  1317      2
[   25.128390]  ffff81007ba25e00 0000000000000046 0000000000000000 00000000ffffffff
[   25.128390]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128390]  ffff81007b813268 ffff81007ba25dc0 ffff81007ba25db0 ffff81007ba25dcc
[   25.128390] Call Trace:
[   25.128390]  [<ffffffff8803f6fd>] :usbcore:hub_thread+0x10d/0xf00
[   25.128390]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128390]  [<ffffffff8803f5f0>] :usbcore:hub_thread+0x0/0xf00
[   25.128390]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128390]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128391]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128391]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128391] 
[   25.128391] kjournald     S 0000000000000000     0  1642      2
[   25.128391]  ffff81003786fea0 0000000000000046 0000000000000000 ffffffff880c0b92
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81003789d268 ffff81003786fe60 ffff81003786fe50 ffff81003786fe6c
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff880c0b92>] :jbd:journal_commit_transaction+0xcd2/0xdc0
[   25.128391]  [<ffffffff880c3b34>] :jbd:kjournald+0x214/0x220
[   25.128391]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128391]  [<ffffffff880c3920>] :jbd:kjournald+0x0/0x220
[   25.128391]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128391]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128391]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128391]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128391] 
[   25.128391] udevd         S 0000000000000000     0  2636      1
[   25.128391]  ffff8100378639c8 0000000000000082 0000000000000000 0000000000000000
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81007e607268 ffff810037863988 ffff810037863978 ffff810037863994
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff80285c73>] do_wp_page+0x263/0x540
[   25.128391]  [<ffffffff804776a5>] schedule_timeout+0x95/0xd0
[   25.128391]  [<ffffffff802889f3>] handle_mm_fault+0x613/0x7c0
[   25.128391]  [<ffffffff8024a8a9>] remove_wait_queue+0x19/0x60
[   25.128391]  [<ffffffff8024a96c>] add_wait_queue+0x1c/0x60
[   25.128391]  [<ffffffff802a5f0d>] pipe_poll+0x2d/0xa0
[   25.128391]  [<ffffffff802ae797>] do_select+0x467/0x560
[   25.128391]  [<ffffffff802aee20>] __pollwait+0x0/0x130
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff8027d25e>] __alloc_pages+0x9e/0x3c0
[   25.128391]  [<ffffffff802887cd>] handle_mm_fault+0x3ed/0x7c0
[   25.128391]  [<ffffffff8029b907>] kmem_cache_alloc+0x67/0xa0
[   25.128391]  [<ffffffff802aea99>] core_sys_select+0x209/0x300
[   25.128391]  [<ffffffff8029147c>] free_pages_and_swap_cache+0x8c/0xb0
[   25.128391]  [<ffffffff8028a997>] unmap_region+0x147/0x160
[   25.128391]  [<ffffffff802aef94>] sys_select+0x44/0x1b0
[   25.128391]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   25.128391] 
[   25.128391] kpsmoused     S 0000000000000001     0  3185      2
[   25.128391]  ffff81007d523ec0 0000000000000046 ffff81007d523e50 ffff810001012fc0
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81007e79f268 ffff8100378e9040 ffff810001012fc0 0000000000000001
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128391]  [<ffffffff80247577>] worker_thread+0xd7/0x100
[   25.128391]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128391]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128391]  [<ffffffff802474a0>] worker_thread+0x0/0x100
[   25.128391]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128391]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128391]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128391]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128391] 
[   25.128391] sh            S 0000000000000000     0  4248      1
[   25.128391]  ffff81007e6b9e28 0000000000000086 0000000000000000 0000000000000000
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81003740aa58 ffff81007e6b9de8 ffff81007e6b9dd8 ffff81007e6b9df4
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff8023831b>] do_wait+0x5fb/0xc50
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff802389f2>] sys_wait4+0x82/0xd0
[   25.128391]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   25.128391] 
[   25.128391] recovery-menu S 0000000000000000     0  4250   4248
[   25.128391]  ffff81007e585e28 0000000000000082 0000000000000000 0000000000000000
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81007e79e248 ffff81007e585de8 ffff81007e585dd8 ffff81007e585df4
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff8023831b>] do_wait+0x5fb/0xc50
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff8024028e>] sys_rt_sigaction+0x8e/0xc0
[   25.128391]  [<ffffffff802389f2>] sys_wait4+0x82/0xd0
[   25.128391]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   25.128391] 
[   25.128391] root          S 0000000000000000     0  4415   4250
[   25.128391]  ffff81007b9f9e28 0000000000000086 0000000000000000 0000000000000000
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81003740a248 ffff81007b9f9de8 ffff81007b9f9dd8 ffff81007b9f9df4
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff8023831b>] do_wait+0x5fb/0xc50
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff802389f2>] sys_wait4+0x82/0xd0
[   25.128391]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   25.128391] 
[   25.128391] bash          S 0000000000000001     0  4416   4415
[   25.128391]  ffff81007f2dfd78 0000000000000086 0000000000000286 ffffffff8023f294
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81007e79ea58 ffffffff80332dae ffff81000100f3a8 ffff8100010137e8
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff8023f294>] lock_timer_base+0x34/0x70
[   25.128391]  [<ffffffff80332dae>] rb_insert_color+0xde/0x110
[   25.128391]  [<ffffffff8024d0be>] enqueue_hrtimer+0x6e/0x110
[   25.128391]  [<ffffffff804776a5>] schedule_timeout+0x95/0xd0
[   25.128391]  [<ffffffff8020c234>] sysret_signal+0x1c/0x27
[   25.128391]  [<ffffffff8022fbd1>] hrtick_set+0x91/0x140
[   25.128391]  [<ffffffff8024a96c>] add_wait_queue+0x1c/0x60
[   25.128391]  [<ffffffff8037f111>] read_chan+0x231/0x7a0
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff80379c6e>] tty_ldisc_ref_wait+0xe/0xa0
[   25.128391]  [<ffffffff80378972>] tty_ldisc_deref+0x52/0x80
[   25.128391]  [<ffffffff8037bd5f>] tty_read+0xaf/0x100
[   25.128391]  [<ffffffff802a0295>] vfs_read+0xc5/0x180
[   25.128391]  [<ffffffff802a0793>] sys_read+0x53/0x90
[   25.128391]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   25.128391] 
[   25.128391] scsi_eh_6     S 0000000000000001     0  5914      2
[   25.128391]  ffff81003743be70 0000000000000046 ffff8100010137e8 ffff81000100f2f8
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81007e606248 ffff81007f04e848 0000000000000282 ffff8100010137e8
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff8022fbd1>] hrtick_set+0x91/0x140
[   25.128391]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128391]  [<ffffffff803a88a7>] scsi_error_handler+0x57/0x570
[   25.128391]  [<ffffffff803a8850>] scsi_error_handler+0x0/0x570
[   25.128391]  [<ffffffff8024a2ab>] kthread+0x4b/0x80
[   25.128391]  [<ffffffff8020cfd8>] child_rip+0xa/0x12
[   25.128391]  [<ffffffff8024a260>] kthread+0x0/0x80
[   25.128391]  [<ffffffff8020cfce>] child_rip+0x0/0x12
[   25.128391] 
[   25.128391] udevd         S 0000000000000000     0  6263   2636
[   25.128391]  ffff8100374399c8 0000000000000082 ffff810037439990 ffffffff8024dc0b
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff810037884a58 ffff810037439988 ffff810037439978 ffff810037439994
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff8024dc0b>] ktime_get_ts+0x1b/0x50
[   25.128391]  [<ffffffff804776a5>] schedule_timeout+0x95/0xd0
[   25.128391]  [<ffffffff8024a8a9>] remove_wait_queue+0x19/0x60
[   25.128391]  [<ffffffff8024a96c>] add_wait_queue+0x1c/0x60
[   25.128391]  [<ffffffff802a5f0d>] pipe_poll+0x2d/0xa0
[   25.128391]  [<ffffffff802ae797>] do_select+0x467/0x560
[   25.128391]  [<ffffffff802aee20>] __pollwait+0x0/0x130
[   25.128391]  [<ffffffff8022d210>] default_wake_function+0x0/0x10
[   25.128391]  [<ffffffff8027bc4f>] __rmqueue+0x2f/0x240
[   25.128391]  [<ffffffff803343fc>] number+0x29c/0x2c0
[   25.128391]  [<ffffffff8027ce52>] get_page_from_freelist+0x312/0x460
[   25.128391]  [<ffffffff8027d25e>] __alloc_pages+0x9e/0x3c0
[   25.128391]  [<ffffffff80286fd9>] __pte_alloc+0x99/0x100
[   25.128391]  [<ffffffff80247c24>] alloc_pid+0x24/0x3f0
[   25.128391]  [<ffffffff802aea99>] core_sys_select+0x209/0x300
[   25.128391]  [<ffffffff80285db3>] do_wp_page+0x3a3/0x540
[   25.128391]  [<ffffffff8024dc4c>] ktime_get+0xc/0x50
[   25.128391]  [<ffffffff802889f3>] handle_mm_fault+0x613/0x7c0
[   25.128391]  [<ffffffff802aef94>] sys_select+0x44/0x1b0
[   25.128391]  [<ffffffff8029d9c4>] filp_close+0x54/0x90
[   25.128391]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   25.128391] 
[   25.128391] vol_id        D 0000000000000000     0  6276   6263
[   25.128391]  ffff81007e2e5c18 0000000000000086 ffff81007e2e5b80 ffffffff8031ebcb
[   25.128391]  ffffffff8063ffc0 ffffffff8063ffc0 ffffffff8063c4c0 ffffffff8063ffc0
[   25.128391]  ffff81007e2e2248 ffff81007bccc000 ffff81007bccd800 ffff810037876378
[   25.128391] Call Trace:
[   25.128391]  [<ffffffff8031ebcb>] elv_next_request+0x11b/0x260
[   25.128391]  [<ffffffff80279310>] sync_page_killable+0x0/0x40
[   25.128391]  [<ffffffff804775d8>] io_schedule+0x28/0x40
[   25.128391]  [<ffffffff802775a5>] sync_page+0x35/0x50
[   25.128391]  [<ffffffff80279319>] sync_page_killable+0x9/0x40
[   25.128391]  [<ffffffff8047778a>] __wait_on_bit_lock+0x4a/0x80
[   25.128391]  [<ffffffff802774df>] __lock_page_killable+0x5f/0x70
[   25.128391]  [<ffffffff8024a6d0>] wake_bit_function+0x0/0x30
[   25.128391]  [<ffffffff8027973b>] generic_file_aio_read+0x3ab/0x5f0
[   25.128391]  [<ffffffff8029f8e9>] do_sync_read+0xd9/0x120
[   25.128391]  [<ffffffff8027d25e>] __alloc_pages+0x9e/0x3c0
[   25.128391]  [<ffffffff8024a6a0>] autoremove_wake_function+0x0/0x30
[   25.128391]  [<ffffffff802887cd>] handle_mm_fault+0x3ed/0x7c0
[   25.128391]  [<ffffffff8028ba8e>] vma_merge+0x16e/0x1f0
[   25.128391]  [<ffffffff802a0295>] vfs_read+0xc5/0x180
[   25.128391]  [<ffffffff802a0793>] sys_read+0x53/0x90
[   25.128391]  [<ffffffff8020c1ab>] system_call_after_swapgs+0x7b/0x80
[   25.128391] 
[   25.128391] Sched Debug Version: v0.07, 2.6.25 #5
[   25.128391] now at 123611.928060 msecs
[   25.128391]   .sysctl_sched_latency                    : 40.000000
[   25.128391]   .sysctl_sched_min_granularity            : 8.000000
[   25.128391]   .sysctl_sched_wakeup_granularity         : 10.000000
[   25.128391]   .sysctl_sched_batch_wakeup_granularity   : 20.000000
[   25.128391]   .sysctl_sched_child_runs_first           : 0.000001
[   25.128391]   .sysctl_sched_features                   : 15
[   25.128391] 
[   25.128391] cpu#0, 2128.007 MHz
[   25.128391]   .nr_running                    : 1
[   25.128391]   .load                          : 3121
[   25.128391]   .nr_switches                   : 24791
[   25.128391]   .nr_load_updates               : 7538
[   25.128391]   .nr_uninterruptible            : -57
[   25.128391]   .jiffies                       : 4294914379
[   25.128391]   .next_balance                  : 4294.912721
[   25.128391]   .curr->pid                     : 0
[   25.128391]   .clock                         : 25128.391433
[   25.128391]   .idle_clock                    : 0.000000
[   25.128391]   .prev_clock_raw                : 149136.724220
[   25.128391]   .clock_warps                   : 0
[   25.128391]   .clock_overflows               : 32297
[   25.128391]   .clock_underflows              : 5154
[   25.128391]   .clock_deep_idle_events        : 4
[   25.128391]   .clock_max_delta               : 3.332759
[   25.128391]   .cpu_load[0]                   : 0
[   25.128391]   .cpu_load[1]                   : 0
[   25.128391]   .cpu_load[2]                   : 0
[   25.128391]   .cpu_load[3]                   : 0
[   25.128391]   .cpu_load[4]                   : 0
[   25.128391] 
[   25.128391] cfs_rq
[   25.128391]   .exec_clock                    : 0.000000
[   25.128391]   .MIN_vruntime                  : 1942.289236
[   25.128391]   .min_vruntime                  : 1942.289236
[   25.128391]   .max_vruntime                  : 1942.289236
[   25.128391]   .spread                        : 0.000000
[   25.128391]   .spread0                       : 0.000000
[   25.128391]   .nr_running                    : 1
[   25.128391]   .load                          : 2048
[   25.128391]   .nr_spread_over                : 0
[   25.128391] 
[   25.128391] cfs_rq
[   25.128391]   .exec_clock                    : 0.000000
[   25.128391]   .MIN_vruntime                  : 0.000001
[   25.128391]   .min_vruntime                  : 1942.289236
[   25.128391]   .max_vruntime                  : 0.000001
[   25.128391]   .spread                        : 0.000000
[   25.128391]   .spread0                       : 0.000000
[   25.128391]   .nr_running                    : 0
[   25.128391]   .load                          : 0
[   25.128391]   .nr_spread_over                : 0
[   25.128391] 
[   25.128391] cfs_rq
[   25.128391]   .exec_clock                    : 0.000000
[   25.128391]   .MIN_vruntime                  : 89413.379807
[   25.128391]   .min_vruntime                  : 1942.289236
[   25.128391]   .max_vruntime                  : 89413.379807
[   25.128391]   .spread                        : 0.000000
[   25.128391]   .spread0                       : 0.000000
[   25.128391]   .nr_running                    : 1
[   25.128391]   .load                          : 3121
[   25.128391]   .nr_spread_over                : 0
[   25.128391] 
[   25.128391] runnable tasks:
[   25.128391]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[   25.128391] ----------------------------------------------------------------------------------------------------------
[   25.128391]         events/0     9     89413.379807       517   115               0               0               0.000000               0.000000               0.000000
[   25.128391] 
[   25.128391] cpu#1, 2128.007 MHz
[   25.128391]   .nr_running                    : 0
[   25.128391]   .load                          : 0
[   25.128391]   .nr_switches                   : 20816
[   25.128391]   .nr_load_updates               : 6498
[   25.128391]   .nr_uninterruptible            : 58
[   25.128391]   .jiffies                       : 4294914379
[   25.128391]   .next_balance                  : 4294.912718
[   25.128391]   .curr->pid                     : 0
[   25.128391]   .clock                         : 21658.621514
[   25.128391]   .idle_clock                    : 0.000000
[   25.128391]   .prev_clock_raw                : 149118.172422
[   25.128391]   .clock_warps                   : 0
[   25.128391]   .clock_overflows               : 24795
[   25.128391]   .clock_underflows              : 4348
[   25.128391]   .clock_deep_idle_events        : 0
[   25.128391]   .clock_max_delta               : 3.333097
[   25.128391]   .cpu_load[0]                   : 0
[   25.128391]   .cpu_load[1]                   : 0
[   25.128391]   .cpu_load[2]                   : 0
[   25.128391]   .cpu_load[3]                   : 0
[   25.128391]   .cpu_load[4]                   : 10
[   25.128391] 
[   25.128391] cfs_rq
[   25.128391]   .exec_clock                    : 0.000000
[   25.128391]   .MIN_vruntime                  : 0.000001
[   25.128391]   .min_vruntime                  : 1354.646939
[   25.128391]   .max_vruntime                  : 0.000001
[   25.128391]   .spread                        : 0.000000
[   25.128391]   .spread0                       : -587.642297
[   25.128391]   .nr_running                    : 0
[   25.128391]   .load                          : 0
[   25.128391]   .nr_spread_over                : 0
[   25.128391] 
[   25.128391] cfs_rq
[   25.128391]   .exec_clock                    : 0.000000
[   25.128391]   .MIN_vruntime                  : 0.000001
[   25.128391]   .min_vruntime                  : 1354.646939
[   25.128391]   .max_vruntime                  : 0.000001
[   25.128391]   .spread                        : 0.000000
[   25.128391]   .spread0                       : -587.642297
[   25.128391]   .nr_running                    : 0
[   25.128391]   .load                          : 0
[   25.128391]   .nr_spread_over                : 0
[   25.128391] 
[   25.128391] cfs_rq
[   25.128391]   .exec_clock                    : 0.000000
[   25.128391]   .MIN_vruntime                  : 0.000001
[   25.128391]   .min_vruntime                  : 1354.646939
[   25.128391]   .max_vruntime                  : 0.000001
[   25.128391]   .spread                        : 0.000000
[   25.128391]   .spread0                       : -587.642297
[   25.128391]   .nr_running                    : 0
[   25.128391]   .load                          : 0
[   25.128391]   .nr_spread_over                : 0
[   25.128391] 
[   25.128391] runnable tasks:
[   25.128391]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[   25.128391] ----------------------------------------------------------------------------------------------------------
[   25.128391] 


--------------010309070405080105020107--
