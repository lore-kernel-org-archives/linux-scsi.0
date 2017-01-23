From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: Re: Booting qla2x00_mailbox_command+0x8ac/0xec0
Date: Mon, 23 Jan 2017 10:38:15 -0500
Message-ID: <20170123153814.pp4oec3ynssvzlly@oracle.com>
References: <1485045213.3904.4.camel@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485045213.3904.4.camel@xs4all.nl>
Sender: sparclinux-owner@vger.kernel.org
To: Frans van Berckel <fberckel@xs4all.nl>
Cc: Sparc kernel list <sparclinux@vger.kernel.org>, Linux Scsi list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

* Frans van Berckel <fberckel@xs4all.nl> [170121 19:34]:
> Anyone a idea what could be wrong while booting from the scsi disk on
> sparc64. 4.9.0 is mailboxing this error and dumps into initramfs.
> 
> [   78.162677] ERROR(0): Cheetah error trap taken
> afsr[0000080000000000] afar[000007fd00100040] TL1(0)
> [   78.165632] ERROR(0): TPC[101ade8c] TNPC[101ade90] O7[101ade80]
> TSTATE[9911001603]
> [   78.168591] ERROR(0): 
> [   78.168988] TPC<qla2x00_mailbox_command+0x8ac/0xec0 [qla2xxx]>
> [   78.171864] ERROR(0): M_SYND(0),  E_SYND(0)
> [   78.174808] ERROR(0): Highest priority error (0000080000000000) "Bus
> error response from system bus"
> [   78.177788] ERROR(0): D-cache idx[0] tag[0000000000000000]
> utag[0000000000000000] stag[0000000000000000]
> [   78.180771] ERROR(0): D-cache data0[0000000000000000]
> data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
> [   78.183808] ERROR(0): I-cache idx[0] tag[0000000000000000]
> utag[0000000000000000] stag[0000000000000000] u[0000000000000000]
> l[0000000000000000]
> [   78.186839] ERROR(0): I-cache INSN0[0000000000000000]
> INSN1[0000000000000000] INSN2[0000000000000000] INSN3[0000000000000000]
> [   78.189899] ERROR(0): I-cache INSN4[0000000000000000]
> INSN5[0000000000000000] INSN6[0000000000000000] INSN7[0000000000000000]
> [   78.192971] ERROR(0): E-cache idx[100040] tag[00000000e48dc920]
> [   78.196010] ERROR(0): E-cache data0[0000000000000000]
> data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
> [   78.199157] Kernel panic - not syncing: Irrecoverable deferred error
> trap.
> 
> lsmod does ...
> 
> Module                  Size  Used by    Not tainted
> hid_generic             1321  0 
> usbhid                 48130  0 
> hid                   107802  2 hid_generic,usbhid
> ohci_pci                4680  0 
> ehci_pci                4847  0 
> ohci_hcd               41274  1 ohci_pci
> qla2xxx               715279  1 
> ehci_hcd               69278  1 ehci_pci
> usbcore               209214  5
> usbhid,ohci_pci,ehci_pci,ohci_hcd,ehci_hcd
> firewire_ohci          33604  0 
> scsi_transport_fc      46940  1 qla2xxx
> sym53c8xx              75770  0 
> scsi_transport_spi     22583  1 sym53c8xx
> usb_common              3976  1 usbcore
> scsi_mod              196717  4
> qla2xxx,scsi_transport_fc,sym53c8xx,scsi_transport_spi
> firewire_core          54166  1 firewire_ohci
> crc_itu_t               1595  1 firewire_core
> sungem                 29777  0 
> sungem_phy             10858  1 sungem
> 
> Attaching dmesg output ...
> 
> Thanks,
> 
> Frans van Berckel


< removed most of dmesg >

> [   64.557099] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [   64.633786] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.38-k.
> [   64.633966] PCI: Enabling device: (0001:00:04.0), cmd 3
> [   64.634261] qla2xxx [0001:00:04.0]-001d: : Found an ISP2200 irq 20 iobase 0x000007fd00100000.
> [   64.647517] sym0: No NVRAM, ID 7, Fast-20, SE, parity checking
> [   64.652483] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [   64.655670] qla2xxx [0001:00:04.0]-0050:1: No matching ROM signature.

Is this normal?

> [   64.656401] ehci-pci: EHCI PCI platform driver
> [   64.657269] ohci-pci: OHCI PCI platform driver
> [   64.664424] sym0: SCSI BUS has been reset.
> [   64.667307] scsi host0: sym-2.2.3
> [   64.679180] PCI: Enabling device: (0000:00:06.1), cmd 147
> [   64.680362] sym1: <875> rev 0x37 at pci 0000:00:06.1 irq 17
> [   64.713347] gem 0000:00:05.1 enp0s5f1: renamed from eth0
> [   64.758542] qla2xxx [0001:00:04.0]-0064:1: Inconsistent NVRAM detected: checksum=0x0 id=
> [   64.764091] qla2xxx [0001:00:04.0]-0069:1: NVRAM configuration failed.

Does this happen in the success case?

> [   64.786902] qla2xxx 0001:00:04.0: firmware: direct-loading firmware ql2200_fw.bin
> [   64.833101] sym1: No NVRAM, ID 7, Fast-20, SE, parity checking
> [   64.843136] sym1: SCSI BUS has been reset.
> [   64.845936] scsi host2: sym-2.2.3
> [   64.906524] firewire_ohci 0000:00:05.2: added OHCI v1.0 device as card 0, 4 IR + 4 IT contexts, quirks 0x0
> [   64.909396] ohci-pci 0000:00:05.3: OHCI PCI host controller
> [   64.912390] ohci-pci 0000:00:05.3: new USB bus registered, assigned bus number 1
> [   64.915276] ohci-pci 0000:00:05.3: irq 15, io mem 0x7fe01000000
> [   64.978669] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> [   64.981341] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [   64.984123] usb usb1: Product: OHCI PCI host controller
> [   64.986896] usb usb1: Manufacturer: Linux 4.9.0-1-sparc64-smp ohci_hcd
> [   64.989658] usb usb1: SerialNumber: 0000:00:05.3
> [   64.993318] hub 1-0:1.0: USB hub found
> [   64.996058] hub 1-0:1.0: 4 ports detected
> [   65.386444] usb 1-3: new low-speed USB device number 2 using ohci-pci
> [   65.422815] firewire_core 0000:00:05.2: created device fw0: GUID 0003bafffe099239, S400
> [   65.605176] usb 1-3: New USB device found, idVendor=0430, idProduct=0005
> [   65.607868] usb 1-3: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [   65.621366] hidraw: raw HID events driver (C) Jiri Kosina
> [   65.632119] usbcore: registered new interface driver usbhid
> [   65.634937] usbhid: USB HID core driver
> [   65.641177] input: HID 0430:0005 as /devices/root/f0061680/pci0000:00/0000:00:05.3/usb1/1-3/1-3:1.0/0003:0430:0005.0001/input/input0
> [   65.703559] hid-generic 0003:0430:0005.0001: input,hidraw0: USB HID v1.00 Keyboard [HID 0430:0005] on usb-0000:00:05.3-3/input0
> [   78.162677] ERROR(0): Cheetah error trap taken afsr[0000080000000000] afar[000007fd00100040] TL1(0)
> [   78.165632] ERROR(0): TPC[101ade8c] TNPC[101ade90] O7[101ade80] TSTATE[9911001603]
> [   78.168591] ERROR(0): 
> [   78.168988] TPC<qla2x00_mailbox_command+0x8ac/0xec0 [qla2xxx]>
> [   78.171864] ERROR(0): M_SYND(0),  E_SYND(0)
> [   78.174808] ERROR(0): Highest priority error (0000080000000000) "Bus error response from system bus"
> [   78.177788] ERROR(0): D-cache idx[0] tag[0000000000000000] utag[0000000000000000] stag[0000000000000000]
> [   78.180771] ERROR(0): D-cache data0[0000000000000000] data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
> [   78.183808] ERROR(0): I-cache idx[0] tag[0000000000000000] utag[0000000000000000] stag[0000000000000000] u[0000000000000000] l[0000000000000000]
> [   78.186839] ERROR(0): I-cache INSN0[0000000000000000] INSN1[0000000000000000] INSN2[0000000000000000] INSN3[0000000000000000]
> [   78.189899] ERROR(0): I-cache INSN4[0000000000000000] INSN5[0000000000000000] INSN6[0000000000000000] INSN7[0000000000000000]
> [   78.192971] ERROR(0): E-cache idx[100040] tag[00000000e48dc920]
> [   78.196010] ERROR(0): E-cache data0[0000000000000000] data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
> [   78.199157] Kernel panic - not syncing: Irrecoverable deferred error trap.
> [   78.199157] 
> [   78.205490] CPU: 0 PID: 80 Comm: systemd-udevd Not tainted 4.9.0-1-sparc64-smp #1 Debian 4.9.2-2
> [   78.208768] Call Trace:
> [   78.212074]  [000000000056b7a8] panic+0xe8/0x298
> [   78.215400]  [0000000000429b8c] cheetah_deferred_handler+0x1ec/0x460
> [   78.218727]  [0000000000405e44] c_deferred+0x18/0x24
> [   78.222092]  [00000000101ade8c] qla2x00_mailbox_command+0x8ac/0xec0 [qla2xxx]
> [   78.225391]  [00000000101b04e8] qla2x00_init_firmware+0xe8/0x1e0 [qla2xxx]
> [   78.228692]  [00000000101a53ec] qla2x00_init_rings+0x3ac/0x400 [qla2xxx]
> [   78.231985]  [00000000101ac410] qla2x00_initialize_adapter+0x470/0x6e0 [qla2xxx]
> [   78.235306]  [000000001019e870] qla2x00_probe_one+0xff0/0x29a0 [qla2xxx]
> [   78.238540]  [0000000000766d60] pci_device_probe+0x80/0x100
> [   78.241858]  [00000000007e6480] driver_probe_device+0x180/0x420
> [   78.245132]  [00000000007e6820] __driver_attach+0x100/0x120
> [   78.248395]  [00000000007e3e9c] bus_for_each_dev+0x5c/0xa0
> [   78.251625]  [00000000007e5b7c] driver_attach+0x1c/0x40
> [   78.254818]  [00000000007e5564] bus_add_driver+0x164/0x2a0
> [   78.258016]  [00000000007e7314] driver_register+0x74/0x120
> [   78.261209]  [0000000000765638] __pci_register_driver+0x38/0x60
> [   78.264419] Press Stop-A (L1-A) to return to the boot prom
> [   78.267612] ---[ end Kernel panic - not syncing: Irrecoverable deferred error trap.
> [   78.267612] 
> [  291.373806] random: crng init done

I am not familiar with cheetah or the qla2xxx card, but it looks like
qla2x00_mailbox_command is accessing the PCI bus which is not mapped.
Have a look at trap_64 in cheetah_deferred_handler.  There is a
pci_poke_faulted variable that is used to flag these errors and to skip
the instruction.  From a quick look at the driver, this shouldn't be
happening.  The PCI space should be configured first.  I would enable
ql_dbg output to see more of what is going on.  Perhaps one of the
messages above indicate an issue and the return value isn't being
validated correctly?  Or perhaps the error path assumes it is safe to
access the PCI bus when it's not safe?

Thanks,
Liam

