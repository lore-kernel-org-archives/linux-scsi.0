From: Paul Menzel <pmenzel+linux-block@molgen.mpg.de>
Subject: =?UTF-8?Q?Regression_4.17-rc1:_SSD_doesn=e2=80=99t_properly_resume_?=
 =?UTF-8?Q?causing_system_hang_=28NULL_pointer_dereference=29?=
Date: Tue, 24 Apr 2018 18:14:58 +0200
Message-ID: <59ca6556-11a6-4f77-76e7-d51c7175eb32@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms060705090708020600030607"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, regressions@leemhuis.info, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060705090708020600030607
Content-Type: multipart/mixed;
 boundary="------------F4692E3659B7E74EBD99072D"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------F4692E3659B7E74EBD99072D
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Dear Linux folks,


Since Linux 4.17-rc1, resume from ACPI on the Lenovo X60 fails because=20
of a NULL pointer dereference. As the drive doesn=E2=80=99t come back, me=
ssages=20
can be seen on the display, but the system cannot be controlled anymore, =

and has to be forcefully shut down.

> 18.021: [  102.160790] BUG: unable to handle kernel NULL pointer derefe=
rence at 000000f4
> 18.022: [  102.160794] *pde =3D 00000000=20
> 18.022: [  102.160798] Oops: 0002 [#1] SMP
> 18.022: [  102.160800] Modules linked in: serport mousedev
> 18.022: [  102.166164] call 0000:05:00.2+ returned 0 after 133531 usecs=

> 18.022: [  102.166146]  binfmt_misc iTCO_wdt iTCO_vendor_support corete=
mp arc4 kvm_intel kvm snd_hda_codec_analog snd_hda_codec_generic irqbypas=
s snd_pcsp psmouse iwl3945 pcmcia iwlegacy mac80211
> 18.022: [  102.176063] call PNP0C0A:00+ returned 0 after 67496 usecs
> 18.022: [  102.176029]  snd_hda_intel snd_hda_codec sdhci_pci cqhci snd=
_hda_core firewire_ohci yenta_socket snd_hwdep lpc_ich pcmcia_rsrc cfg802=
11 mfd_core firewire_core pcmcia_core sdhci crc_itu_t mmc_core thinkpad_a=
cpi i2c_i801 rng_core snd_pcm e1000e ehci_pci snd_timer
> 18.022: [  102.186594] calling  PNP0C0A:01+ @ 603, parent: PNP0C09:00
> 18.022: [  102.186584]  nvram snd rfkill battery uhci_hcd soundcore ehc=
i_hcd usbcore video shpchp button ac acpi_cpufreq ip_tables x_tables auto=
fs4 ext4 crc16 mbcache
> 18.022: [  102.197513] calling  hdaudioC0D0+ @ 654, parent: 0000:00:1b.=
0
> 18.023: [  102.196868]  jbd2 fscrypto cbc dm_crypt dm_mod sd_mod ahci l=
ibahci libata evdev serio_raw scsi_mod fan thermal
> 18.023: [  102.196868] CPU: 0 PID: 619 Comm: kworker/u4:5 Not tainted 4=
=2E17.0-rc2+ #12
> 18.023: [  102.196868] Hardware name: LENOVO 636338U/636338U, BIOS CBET=
4000 TIMELESS 01/01/1970
> 18.023: [  102.196868] Workqueue: events_unbound async_run_entry_fn
> 18.023: [  102.208295] call hdaudioC0D0+ returned 0 after 829 usecs
> 18.023: [  102.207490] EIP: blk_set_runtime_active+0x4f/0xc0
> 18.023: [  102.207490] EFLAGS: 00010013 CPU: 0
> 18.023: [  102.207490] EAX: 00000000 EBX: f6640bc0 ECX: f6640cb8 EDX: 0=
0000000
> 18.023: [  102.207490] ESI: 00000000 EDI: ffff35b3 EBP: f1b4fe38 ESP: f=
1b4fe24
> 18.023: [  102.207490]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> 18.023: [  102.207490] CR0: 80050033 CR2: 000000f4 CR3: 34329000 CR4: 0=
00006d0
> 18.024: [  102.207490] Call Trace:
> 18.024: [  102.207490]  ? async_sdev_thaw+0x20/0x20 [scsi_mod]
> 18.024: [  102.217657] call PNP0C0A:01+ returned 0 after 20334 usecs
> 18.024: [  102.207490]  scsi_bus_resume_common+0x79/0x180 [scsi_mod]
> 18.024: [  102.207490]  scsi_bus_resume+0x12/0x20 [scsi_mod]
> 18.024: [  102.225483] calling  PNP0C0E:00+ @ 603, parent: PNP0C09:00
> 18.024: [  102.207490]  dpm_run_callback+0x47/0x1b0
> 18.024: [  102.207490]  ? scsi_bus_thaw+0x20/0x20 [scsi_mod]
> 18.024: [  102.207490]  device_resume+0x97/0x190
> 18.025: [  102.247723] call PNP0C0E:00+ returned 0 after 1 usecs
> 18.025: [  102.207490]  ? device_resume+0x190/0x190
> 18.025: [  102.207490]  async_resume+0x1e/0x50
> 18.025: [  102.207490]  async_run_entry_fn+0x61/0x3a0
> 18.025: [  102.207490]  ? try_to_wake_up+0x4d/0x790
> 18.025: [  102.207490]  ? pwq_dec_nr_in_flight+0x7c/0x150
> 18.025: [  102.276518] call usb2+ returned 0 after 117617 usecs
> 18.025: [  102.207490]  process_one_work+0x235/0x690
> 18.025: [  102.207490]  worker_thread+0x19d/0x6a0
> 18.025: [  102.207490]  kthread+0x14a/0x1f0
> 18.025: [  102.207490]  ? process_one_work+0x690/0x690
> 18.026: [  102.207490]  ? kthread_create_worker_on_cpu+0x30/0x30
> 18.026: [  102.296000] call usb5+ returned 0 after 126932 usecs
> 18.026: [  102.207490]  ret_from_fork+0x2e/0x38
> 18.026: [  102.207490] Code: 7e 8b 83=20
> 18.026: [  102.311897] calling  phy0+ @ 121, parent: 0000:02:00.0
> 18.026: [  102.207490] fc 00 00 00 e8 e0 32 53 00 8b b3 50 01 00 00 31 =

> 18.026: [  102.326676] calling  5-6+ @ 642, parent: usb5
> 18.026: [  102.207490] c0 8b 3d 20 7d 6a de 89 83 54 01 00 00 81 fe 0c =
ff=20
> 18.026: [  102.337499] call usb3+ returned 0 after 177124 usecs
> 18.026: [  102.207490] ff ff 89 7d ec 74 46 <89> be f4 00 00 00 ba 09 0=
0=20
> 18.027: [  102.345835] call usb4+ returned 0 after 185236 usecs
> 18.027: [  102.207490] 00 00 8b 83 50 01 00 00 e8 0b 25 24=20
> 18.027: [  102.207490] EIP: blk_set_runtime_active+0x4f/0xc0 SS:ESP: 00=
68:f1b4fe24
> 18.027: [  102.207490] CR2: 00000000000000f4
> 18.027: [  102.358489] call usb1+ returned 0 after 193086 usecs
> 18.029: [  102.207490] ---[ end trace 5717e021dd8debaa ]---

Please find the serial (also with coreboot messages) attached.


Kind regards,

Paul

--------------F4692E3659B7E74EBD99072D
Content-Type: text/x-log;
 name="seriallog-20180423_232310.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="seriallog-20180423_232310.log"



=3D=3D=3D=3D=3D=3D=3D Mon Apr 23 23:23:12 2018 (adjust=3D86.8us)
00.000: <00>
00.686:=20
00.686:=20
00.686: coreboot-TIMELESS Thu Jan  1 00:00:00 UTC 1970 romstage starting.=
=2E.
00.686: Dock is present
00.686:=20
00.687: Mobile Intel(R) 82945GM/GME Express Chipset
00.687: (G)MCH capable of up to FSB 800 MHz
00.687: (G)MCH capable of up to DDR2-667
00.687: Setting up static southbridge registers... done.
00.687: Disabling Watchdog reboot... done.
00.687: Setting up static northbridge registers...CBFS: 'Master Header Lo=
cator' located CBFS at [200:1fffc0)
00.689: CBFS: Locating 'cmos_layout.bin'
00.690: CBFS: Found @ offset 39100 size 6ac
00.690:  done.
00.690: Waiting for MCHBAR to come up...ok
00.690: PM1_CNT: 00000000
00.690: SMBus controller enabled.
00.690: Setting up RAM controller.
00.691: This mainboard supports Dual Channel Operation.
00.750: Reading SPD using i2c block operation.
00.752: DDR II Channel 0 Socket 0: x8DDS
00.752: DIMM 0 side 0 =3D 512 MB
00.752: DIMM 0 side 1 =3D 512 MB
00.753: DDR II Channel 0 Socket 1: N/A
00.812: Reading SPD using i2c block operation.
00.812: DDR II Channel 1 Socket 0: x8DDS
00.812: DIMM 2 side 0 =3D 512 MB
00.812: DIMM 2 side 1 =3D 512 MB
00.813: DDR II Channel 1 Socket 1: N/A
00.813: Memory will be driven at 667MT with CAS=3D5 clocks
00.813: tRAS =3D 15 cycles
00.813: tRP  =3D 5 cycles
00.813: tRCD =3D 5 cycles
00.813: tWR  =3D 5 cycles
00.814: tRFC =3D 35 cycles
00.814: Refresh: 7.8us
00.814: Setting Graphics Frequency...
00.814: FSB: 667 MHz Voltage: 1.05V Render: 250MHz Display: 200MHz
00.814: Setting Memory Frequency... CLKCFG =3D 0x00010023, CLKCFG =3D 0x0=
0010043, ok
00.815: Setting mode of operation for memory channels...Dual Channel Inte=
rleaved.
00.815: Programming Clock Crossing...MEM=3D667 FSB=3D667... ok
00.815: Setting RAM size...
00.816: C0DRB =3D 0x20202010
00.816: C1DRB =3D 0x20202010
00.816: TOLUD =3D 0x0080
00.816: Setting row attributes...
00.816: C0DRA =3D 0x0033
00.816: C1DRA =3D 0x0033
00.816: one dimm per channel config..
00.816: Initializing System Memory IO...
00.817: Programming Dual Channel RCOMP
00.817: Table Index: 18
00.817: Programming DLL Timings...
00.817: Enabling System Memory IO...
00.818: jedec enable sequence: bank 0
00.818: jedec enable sequence: bank 1
00.818: bankaddr from bank size of rank 0
00.818: jedec enable sequence: bank 4
00.818: jedec enable sequence: bank 5
00.818: bankaddr from bank size of rank 4
00.819: receive_enable_autoconfig() for channel 0
00.819:   find_strobes_low()
00.819:     set_receive_enable() medium=3D0x3, coarse=3D0x5
00.819:     set_receive_enable() medium=3D0x1, coarse=3D0x5
00.819:   find_strobes_edge()
00.819:     set_receive_enable() medium=3D0x1, coarse=3D0x5
00.820:   add_quarter_clock() mediumcoarse=3D15 fine=3Dd5
00.820:     set_receive_enable() medium=3D0x3, coarse=3D0x5
00.820:   find_preamble()
00.820:     set_receive_enable() medium=3D0x3, coarse=3D0x4
00.820:     set_receive_enable() medium=3D0x3, coarse=3D0x3
00.820:   add_quarter_clock() mediumcoarse=3D0f fine=3D55
00.820:   normalize()
00.820:     set_receive_enable() medium=3D0x0, coarse=3D0x4
00.820: receive_enable_autoconfig() for channel 1
00.820:   find_strobes_low()
00.820:     set_receive_enable() medium=3D0x3, coarse=3D0x5
00.820:     set_receive_enable() medium=3D0x1, coarse=3D0x5
00.820:   find_strobes_edge()
00.820:     set_receive_enable() medium=3D0x1, coarse=3D0x5
00.820:   add_quarter_clock() mediumcoarse=3D15 fine=3Dd5
00.820:     set_receive_enable() medium=3D0x3, coarse=3D0x5
00.820:   find_preamble()
00.820:     set_receive_enable() medium=3D0x3, coarse=3D0x4
00.820:     set_receive_enable() medium=3D0x3, coarse=3D0x3
00.820:   add_quarter_clock() mediumcoarse=3D0f fine=3D55
00.820:   normalize()
00.820:     set_receive_enable() medium=3D0x0, coarse=3D0x4
00.821: RAM initialization finished.
00.821: Setting up Egress Port RCRB
00.821: Loading port arbitration table ...ok
00.821: Wait for VC1 negotiation ...ok
00.822: Setting up DMI RCRB
00.822: Wait for VC1 negotiation ...done..
00.822: Internal graphics: enabled
00.822: Waiting for DMI hardware...ok
00.822: Enabling PCI Express x16 Link
00.822: SLOTSTS: 0000
00.822: Disabling PCI Express x16 Link
00.822: Wait for link to enter detect state... ok
00.822: Setting up Root Complex Topology
00.823: CBMEM:
00.823: IMD: root @ 7f7ff000 254 entries.
00.823: IMD: root @ 7f7fec00 62 entries.
00.832: MTRR Range: Start=3Dffe00000 End=3D0 (Size 200000)
00.832: MTRR Range: Start=3D0 End=3D1000000 (Size 1000000)
00.832: MTRR Range: Start=3D7f400000 End=3D7f800000 (Size 400000)
00.832: MTRR Range: Start=3D7f000000 End=3D7f400000 (Size 400000)
00.837: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.838: CBFS: Locating 'fallback/ramstage'
00.838: CBFS: Found @ offset 24340 size 147a9
00.838: Decompressing stage fallback/ramstage @ 0x7f789fc0 (252176 bytes)=

00.897: Loading module at 7f78a000 with entry 7f78a000. filesize: 0x32a48=
 memsize: 0x3d8d0
00.897: Processing 2833 relocs. Offset value of 0x7f68a000
00.903:=20
00.903:=20
00.903: coreboot-TIMELESS Thu Jan  1 00:00:00 UTC 1970 ramstage starting.=
=2E.
00.903: Normal boot.
00.903: BS: BS_PRE_DEVICE times (us): entry 0 run 0 exit 0
00.903: BS: BS_DEV_INIT_CHIPS times (us): entry 0 run 1 exit 0
00.903: Enumerating buses...
00.903: CPU_CLUSTER: 0 enabled
00.903: DOMAIN: 0000 enabled
00.903: PCI: pci_scan_bus for bus 00
00.903: PCI: 00:00.0 [8086/27a0] enabled
00.904: PCI: 00:02.0 [8086/27a2] enabled
00.903: PCI: 00:02.1 [8086/27a6] enabled
00.904: PCI: 00:1b.0 [8086/27d8] enabled
00.904: PCI: 00:1c.0 [8086/27d0] enabled
00.904: PCI: 00:1c.1 [8086/27d2] enabled
00.904: PCI: 00:1c.2 [8086/27d4] enabled
00.904: PCI: 00:1c.3 [8086/27d6] enabled
00.904: PCI: 00:1d.0 [8086/27c8] enabled
00.904: PCI: 00:1d.1 [8086/27c9] enabled
00.904: PCI: 00:1d.2 [8086/27ca] enabled
00.904: PCI: 00:1d.3 [8086/27cb] enabled
00.904: PCI: 00:1d.7 [8086/27cc] enabled
00.904: PCI: 00:1e.0 [8086/2448] enabled
00.904: PCI: 00:1f.0 [8086/27b9] enabled
00.904: PCI: 00:1f.1 [8086/27df] enabled
00.904: Set SATA mode early
00.904: Set SATA mode early
00.904: PCI: 00:1f.2 [8086/27c5] enabled
00.904: PCI: 00:1f.3 [8086/27da] enabled
00.904: PCI: pci_scan_bus for bus 01
00.904: PCI: 01:00.0 [8086/109a] enabled
00.904: scan_bus: scanning of bus PCI: 00:1c.0 took 5652 usecs
00.904: PCI: pci_scan_bus for bus 02
00.904: PCI: 02:00.0 [8086/4227] enabled
00.904: scan_bus: scanning of bus PCI: 00:1c.1 took 5664 usecs
00.904: PCI: pci_scan_bus for bus 03
00.904: scan_bus: scanning of bus PCI: 00:1c.2 took 2673 usecs
00.904: PCI: pci_scan_bus for bus 04
00.904: scan_bus: scanning of bus PCI: 00:1c.3 took 2673 usecs
00.904: PCI: pci_scan_bus for bus 05
00.904: PCI: 05:00.0 [1180/0476] enabled
00.904: PCI: 05:00.1 [1180/0552] enabled
00.904: PCI: 05:00.2 [1180/0822] enabled
00.904: PCI: pci_scan_bus for bus 06
00.904: scan_bus: scanning of bus PCI: 05:00.0 took 2678 usecs
00.904: scan_bus: scanning of bus PCI: 00:1e.0 took 19197 usecs
00.904: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.904: CBFS: Locating 'cmos_layout.bin'
00.904: CBFS: Found @ offset 39100 size 6ac
00.905: WARNING: No CMOS option 'touchpad'.
00.905: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.905: CBFS: Locating 'cmos_layout.bin'
00.905: CBFS: Found @ offset 39100 size 6ac
00.905: PMH7: ID 03 Revision 10
00.905: PNP: 00ff.1 enabled
00.906: EC Firmware ID 7JHT12WW-3.4, Version 3.01A
00.907: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.907: CBFS: Locating 'cmos_layout.bin'
00.907: CBFS: Found @ offset 39100 size 6ac
00.907: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.907: CBFS: Locating 'cmos_layout.bin'
00.907: CBFS: Found @ offset 39100 size 6ac
00.911: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.911: CBFS: Locating 'cmos_layout.bin'
00.911: CBFS: Found @ offset 39100 size 6ac
00.912: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.912: CBFS: Locating 'cmos_layout.bin'
00.912: CBFS: Found @ offset 39100 size 6ac
00.912: H8: BDC not installed
00.912: H8: WWAN detection not implemented. Assuming WWAN installed
00.912: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.912: CBFS: Locating 'cmos_layout.bin'
00.912: CBFS: Found @ offset 39100 size 6ac
00.913: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.913: CBFS: Locating 'cmos_layout.bin'
00.913: CBFS: Found @ offset 39100 size 6ac
00.913: WARNING: No CMOS option 'fn_ctrl_swap'.
00.913: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.913: CBFS: Locating 'cmos_layout.bin'
00.913: CBFS: Found @ offset 39100 size 6ac
00.913: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.913: CBFS: Locating 'cmos_layout.bin'
00.913: CBFS: Found @ offset 39100 size 6ac
00.914: PNP: 00ff.2 enabled
00.914: PNP: 164e.2 enabled
00.914: PNP: 164e.3 enabled
00.914: PNP: 164e.7 enabled
00.914: PNP: 164e.19 enabled
00.914: PNP: 002e.0 disabled
00.914: PNP: 002e.1 enabled
00.914: PNP: 002e.2 disabled
00.914: PNP: 002e.3 enabled
00.914: PNP: 002e.7 enabled
00.914: PNP: 002e.a disabled
00.914: scan_bus: scanning of bus PCI: 00:1f.0 took 166463 usecs
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:69 enabled
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:54 enabled
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:55 enabled
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:56 enabled
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:57 enabled
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:5c enabled
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:5d enabled
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:5e enabled
00.914: bus: PCI: 00:1f.3[0]->I2C: 01:5f enabled
00.914: scan_bus: scanning of bus PCI: 00:1f.3 took 33206 usecs
00.914: scan_bus: scanning of bus DOMAIN: 0000 took 330139 usecs
00.915: scan_bus: scanning of bus Root Device took 339237 usecs
00.914: done
00.914: BS: BS_DEV_ENUMERATE times (us): entry 0 run 346723 exit 0
00.914: found VGA at PCI: 00:02.0
00.915: Setting up VGA for PCI: 00:02.0
00.915: Setting PCI_BRIDGE_CTL_VGA for bridge DOMAIN: 0000
00.915: Setting PCI_BRIDGE_CTL_VGA for bridge Root Device
00.915: Allocating resources...
00.915: Reading resources...
00.915: Adding PCIe enhanced config space BAR 0xf0000000-0xf4000000.
00.916: PNP: 00ff.1 missing read_resources
00.916: PNP: 00ff.2 missing read_resources
00.916: Done reading resources.
00.916: skipping PNP: 00ff.2@60 fixed resource, size=3D0!
00.916: skipping PNP: 00ff.2@62 fixed resource, size=3D0!
00.916: skipping PNP: 00ff.2@64 fixed resource, size=3D0!
00.916: skipping PNP: 00ff.2@66 fixed resource, size=3D0!
00.916: skipping PNP: 164e.3@29 fixed resource, size=3D0!
00.916: skipping PNP: 164e.3@f0 fixed resource, size=3D0!
00.916: Setting resources...
00.917: pci_tolm: 0xd0000000
00.917: IGD decoded, subtracting 8M UMA
00.917: Available memory: 2088960K (2040M)
00.917: PCI: 00:02.0 10 <- [0x00e4300000 - 0x00e437ffff] size 0x00080000 =
gran 0x13 mem
00.917: PCI: 00:02.0 14 <- [0x00000050b0 - 0x00000050b7] size 0x00000008 =
gran 0x03 io
00.917: PCI: 00:02.0 18 <- [0x00d0000000 - 0x00dfffffff] size 0x10000000 =
gran 0x1c prefmem
00.917: PCI: 00:02.0 1c <- [0x00e4400000 - 0x00e443ffff] size 0x00040000 =
gran 0x12 mem
00.917: PCI: 00:02.1 10 <- [0x00e4380000 - 0x00e43fffff] size 0x00080000 =
gran 0x13 mem
00.917: PCI: 00:1b.0 10 <- [0x00e4440000 - 0x00e4443fff] size 0x00004000 =
gran 0x0e mem64
00.917: PCI: 00:1c.0 1c <- [0x0000004000 - 0x0000004fff] size 0x00001000 =
gran 0x0c bus 01 io
00.917: PCI: 00:1c.0 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 01 prefmem
00.917: PCI: 00:1c.0 20 <- [0x00e4100000 - 0x00e41fffff] size 0x00100000 =
gran 0x14 bus 01 mem
00.917: PCI: 01:00.0 10 <- [0x00e4100000 - 0x00e411ffff] size 0x00020000 =
gran 0x11 mem
00.917: PCI: 01:00.0 18 <- [0x0000004000 - 0x000000401f] size 0x00000020 =
gran 0x05 io
00.917: PCI: 00:1c.1 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 =
gran 0x0c bus 02 io
00.917: PCI: 00:1c.1 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 02 prefmem
00.917: PCI: 00:1c.1 20 <- [0x00e4200000 - 0x00e42fffff] size 0x00100000 =
gran 0x14 bus 02 mem
00.917: PCI: 02:00.0 10 <- [0x00e4200000 - 0x00e4200fff] size 0x00001000 =
gran 0x0c mem
00.917: PCI: 00:1c.2 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 =
gran 0x0c bus 03 io
00.917: PCI: 00:1c.2 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 03 prefmem
00.917: PCI: 00:1c.2 20 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 03 mem
00.917: PCI: 00:1c.3 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 =
gran 0x0c bus 04 io
00.917: PCI: 00:1c.3 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 04 prefmem
00.917: PCI: 00:1c.3 20 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 04 mem
00.917: PCI: 00:1d.0 20 <- [0x0000005000 - 0x000000501f] size 0x00000020 =
gran 0x05 io
00.917: PCI: 00:1d.1 20 <- [0x0000005020 - 0x000000503f] size 0x00000020 =
gran 0x05 io
00.917: PCI: 00:1d.2 20 <- [0x0000005040 - 0x000000505f] size 0x00000020 =
gran 0x05 io
00.917: PCI: 00:1d.3 20 <- [0x0000005060 - 0x000000507f] size 0x00000020 =
gran 0x05 io
00.917: PCI: 00:1d.7 10 <- [0x00e4444000 - 0x00e44443ff] size 0x00000400 =
gran 0x0a mem
00.917: PCI: 00:1e.0 1c <- [0x0000002000 - 0x0000003fff] size 0x00002000 =
gran 0x0c bus 05 io
00.917: PCI: 00:1e.0 24 <- [0x00e2100000 - 0x00e40fffff] size 0x02000000 =
gran 0x14 bus 05 prefmem
00.917: PCI: 00:1e.0 20 <- [0x00e0000000 - 0x00e20fffff] size 0x02100000 =
gran 0x14 bus 05 mem
00.917: PCI: 05:00.0 In set resources
00.917: PCI: 05:00.0 10 <- [0x00e2000000 - 0x00e2000fff] size 0x00001000 =
gran 0x0c mem
00.917: PCI: 05:00.0 2c <- [0x0000002000 - 0x0000002fff] size 0x00001000 =
gran 0x02 io
00.917: PCI: 05:00.0 34 <- [0x0000003000 - 0x0000003fff] size 0x00001000 =
gran 0x02 io
00.917: PCI: 05:00.0 1c <- [0x00e2100000 - 0x00e40fffff] size 0x02000000 =
gran 0x0c prefmem
00.917: PCI: 05:00.0 24 <- [0x00e0000000 - 0x00e1ffffff] size 0x02000000 =
gran 0x0c mem
00.917: PCI: 05:00.1 10 <- [0x00e2001000 - 0x00e20017ff] size 0x00000800 =
gran 0x0b mem
00.917: PCI: 05:00.2 10 <- [0x00e2002000 - 0x00e20020ff] size 0x00000100 =
gran 0x08 mem
00.917: PNP: 00ff.1 missing set_resources
00.917: PNP: 00ff.2 missing set_resources
00.917: PNP: 164e.2 60 <- [0x00000002f8 - 0x00000002ff] size 0x00000008 g=
ran 0x03 io
00.917: ERROR: PNP: 164e.2 70 irq size: 0x0000000001 not assigned
00.917: ERROR: PNP: 164e.2 74 drq size: 0x0000000001 not assigned
00.917: ERROR: PNP: 164e.2 75 drq size: 0x0000000001 not assigned
00.917: PNP: 164e.3 60 <- [0x0000000200 - 0x0000000207] size 0x00000008 g=
ran 0x03 io
00.917: PNP: 164e.3 29 <- [0x00000000b0 - 0x00000000af] size 0x00000000 g=
ran 0x00 irq
00.917: PNP: 164e.3 70 <- [0x0000000005 - 0x0000000005] size 0x00000001 g=
ran 0x00 irq
00.917: PNP: 164e.3 f0 <- [0x0000000082 - 0x0000000081] size 0x00000000 g=
ran 0x00 irq
00.917: PNP: 164e.7 60 <- [0x0000001680 - 0x000000168f] size 0x00000010 g=
ran 0x04 io
00.917: ERROR: PNP: 164e.7 70 irq size: 0x0000000001 not assigned
00.917: PNP: 164e.19 60 <- [0x000000164c - 0x000000164d] size 0x00000002 =
gran 0x01 io
00.917: ERROR: PNP: 164e.19 70 irq size: 0x0000000001 not assigned
00.917: PNP: 002e.1 60 <- [0x00000003bc - 0x00000007bb] size 0x00000400 g=
ran 0x0a io
00.917: PNP: 002e.1 70 <- [0x0000000007 - 0x0000000007] size 0x00000001 g=
ran 0x00 irq
00.917: ERROR: PNP: 002e.1 74 drq size: 0x0000000001 not assigned
00.917: PNP: 002e.3 60 <- [0x00000003f8 - 0x00000003ff] size 0x00000008 g=
ran 0x03 io
00.917: PNP: 002e.3 70 <- [0x0000000004 - 0x0000000004] size 0x00000001 g=
ran 0x00 irq
00.917: PNP: 002e.7 60 <- [0x0000001620 - 0x0000001627] size 0x00000008 g=
ran 0x03 io
00.917: ERROR: PNP: 002e.7 70 irq size: 0x0000000001 not assigned
00.917: PCI: 00:1f.1 10 <- [0x00000050b8 - 0x00000050bf] size 0x00000008 =
gran 0x03 io
00.917: PCI: 00:1f.1 14 <- [0x00000050d8 - 0x00000050db] size 0x00000004 =
gran 0x02 io
00.917: PCI: 00:1f.1 18 <- [0x00000050c0 - 0x00000050c7] size 0x00000008 =
gran 0x03 io
00.917: PCI: 00:1f.1 1c <- [0x00000050dc - 0x00000050df] size 0x00000004 =
gran 0x02 io
00.917: PCI: 00:1f.1 20 <- [0x00000050a0 - 0x00000050af] size 0x00000010 =
gran 0x04 io
00.917: PCI: 00:1f.2 10 <- [0x00000050c8 - 0x00000050cf] size 0x00000008 =
gran 0x03 io
00.917: PCI: 00:1f.2 14 <- [0x00000050e0 - 0x00000050e3] size 0x00000004 =
gran 0x02 io
00.917: PCI: 00:1f.2 18 <- [0x00000050d0 - 0x00000050d7] size 0x00000008 =
gran 0x03 io
00.917: PCI: 00:1f.2 1c <- [0x00000050e4 - 0x00000050e7] size 0x00000004 =
gran 0x02 io
00.917: PCI: 00:1f.2 20 <- [0x0000005080 - 0x000000509f] size 0x00000020 =
gran 0x05 io
00.917: PCI: 00:1f.2 24 <- [0x00e4445000 - 0x00e44453ff] size 0x00000400 =
gran 0x0a mem
00.917: Done setting resources.
00.917: Done allocating resources.
00.917: BS: BS_DEV_RESOURCES times (us): entry 0 run 539610 exit 0
00.917: Enabling resources...
00.917: PCI: 00:00.0 subsystem <- 17aa/2017
00.917: PCI: 00:00.0 cmd <- 06
00.917: PCI: 00:02.0 subsystem <- 17aa/201a
00.917: PCI: 00:02.0 cmd <- 03
00.917: PCI: 00:02.1 subsystem <- 17aa/201a
00.917: PCI: 00:02.1 cmd <- 02
00.917: PCI: 00:1b.0 subsystem <- 17aa/2010
00.917: PCI: 00:1b.0 cmd <- 102
00.918: PCI: 00:1c.0 bridge ctrl <- 0003
00.918: PCI: 00:1c.0 subsystem <- 8086/27d0
00.918: PCI: 00:1c.0 cmd <- 107
00.918: PCI: 00:1c.1 bridge ctrl <- 0003
00.918: PCI: 00:1c.1 subsystem <- 8086/27d2
00.918: PCI: 00:1c.1 cmd <- 106
00.918: PCI: 00:1c.2 bridge ctrl <- 0003
00.918: PCI: 00:1c.2 cmd <- 00
00.918: PCI: 00:1c.3 bridge ctrl <- 0003
00.918: PCI: 00:1c.3 cmd <- 00
00.918: PCI: 00:1d.0 subsystem <- 17aa/200a
00.918: PCI: 00:1d.0 cmd <- 01
00.918: PCI: 00:1d.1 subsystem <- 17aa/200a
00.918: PCI: 00:1d.1 cmd <- 01
00.918: PCI: 00:1d.2 subsystem <- 17aa/200a
00.918: PCI: 00:1d.2 cmd <- 01
00.918: PCI: 00:1d.3 subsystem <- 17aa/200a
00.918: PCI: 00:1d.3 cmd <- 01
00.918: PCI: 00:1d.7 subsystem <- 17aa/200b
00.918: PCI: 00:1d.7 cmd <- 102
00.918: PCI: 00:1e.0 bridge ctrl <- 0003
00.918: PCI: 00:1e.0 cmd <- 07
00.918: PCI: 00:1f.0 subsystem <- 17aa/2009
00.918: PCI: 00:1f.0 cmd <- 107
00.918: PCI: 00:1f.1 subsystem <- 17aa/200c
00.918: PCI: 00:1f.1 cmd <- 01
00.918: PCI: 00:1f.2 subsystem <- 17aa/200d
00.918: PCI: 00:1f.2 cmd <- 03
00.918: PCI: 00:1f.3 subsystem <- 17aa/200f
00.918: PCI: 00:1f.3 cmd <- 101
00.918: PCI: 01:00.0 cmd <- 03
00.918: PCI: 02:00.0 cmd <- 02
00.918: PCI: 05:00.0 bridge ctrl <- 0503
00.918: PCI: 05:00.0 cmd <- 03
00.918: PCI: 05:00.1 cmd <- 02
00.918: PCI: 05:00.2 cmd <- 06
00.918: done.
00.918: BS: BS_DEV_ENABLE times (us): entry 0 run 118097 exit 0
00.918: Initializing devices...
00.918: Root Device init ...
00.919: Root Device init finished in 2613 usecs
00.919: CPU_CLUSTER: 0 init ...
00.919: start_eip=3D0x00001000, code_size=3D0x00000031
00.919: Initializing SMM handler...
00.920: SMI_STS: MCSMI PM1=20
00.920: PM1_STS: PRBTNOR PWRBTN=20
00.920: GPE0_STS: GPIO15 GPIO14 GPIO13 GPIO12 GPIO11 GPIO10 GPIO7 GPIO6 G=
PIO5 GPIO4 GPIO3 GPIO2 GPIO1 GPIO0=20
00.920: ALT_GP_SMI_STS: GPI15 GPI14 GPI13 GPI12 GPI11 GPI10 GPI7 GPI6 GPI=
5 GPI4 GPI3 GPI2 GPI1 GPI0=20
00.920: TCO_STS:=20
00.921: Initializing CPU #0
00.921: CPU: vendor Intel device 6ec
00.921: CPU: family 06, model 0e, stepping 0c
00.921: Enabling cache
00.921: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.921: CBFS: Locating 'cpu_microcode_blob.bin'
00.921: CBFS: Found @ offset d2c0 size 17000
00.921: microcode: sig=3D0x6ec pf=3D0x20 revision=3D0x0
00.922: microcode: updated to revision 0x54 date=3D2006-05-01
00.923: CPU: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz.
00.923: MTRR: Physical address space:
00.923: 0x0000000000000000 - 0x00000000000a0000 size 0x000a0000 type 6
00.923: 0x00000000000a0000 - 0x00000000000c0000 size 0x00020000 type 0
00.923: 0x00000000000c0000 - 0x000000007f800000 size 0x7f740000 type 6
00.923: 0x000000007f800000 - 0x00000000d0000000 size 0x50800000 type 0
00.923: 0x00000000d0000000 - 0x00000000e0000000 size 0x10000000 type 1
00.923: 0x00000000e0000000 - 0x0000000100000000 size 0x20000000 type 0
00.923: MTRR: Fixed MSR 0x250 0x0606060606060606
00.923: MTRR: Fixed MSR 0x258 0x0606060606060606
00.923: MTRR: Fixed MSR 0x259 0x0000000000000000
00.923: MTRR: Fixed MSR 0x268 0x0606060606060606
00.923: MTRR: Fixed MSR 0x269 0x0606060606060606
00.923: MTRR: Fixed MSR 0x26a 0x0606060606060606
00.923: MTRR: Fixed MSR 0x26b 0x0606060606060606
00.923: MTRR: Fixed MSR 0x26c 0x0606060606060606
00.923: MTRR: Fixed MSR 0x26d 0x0606060606060606
00.923: MTRR: Fixed MSR 0x26e 0x0606060606060606
00.923: MTRR: Fixed MSR 0x26f 0x0606060606060606
00.924: CPU physical address size: 32 bits
00.924: MTRR: default type WB/UC MTRR counts: 5/3.
00.924: MTRR: UC selected as default type.
00.924: MTRR: 0 base 0x0000000000000000 mask 0x0000000080000000 type 6
00.924: MTRR: 1 base 0x000000007f800000 mask 0x00000000ff800000 type 0
00.924: MTRR: 2 base 0x00000000d0000000 mask 0x00000000f0000000 type 1
00.925:=20
00.925: MTRR check
00.925: Fixed MTRRs   : Enabled
00.925: Variable MTRRs: Enabled
00.925:=20
00.925: Setting up local APIC... apic_id: 0x00 done.
00.925: VMX status: enabled, locked
00.925: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.925: CBFS: Locating 'cmos_layout.bin'
00.925: CBFS: Found @ offset 39100 size 6ac
00.925: CPU: 0 2 siblings
00.925: CPU: 0 has sibling 1
00.925: CPU #0 initialized
00.937: Initializing CPU #1
00.937: Waiting for 1 CPUS to stop
00.937: CPU: vendor Intel device 6ec
00.937: CPU: family 06, model 0e, stepping 0c
00.937: Enabling cache
00.937: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
00.937: CBFS: Locating 'cpu_microcode_blob.bin'
00.938: CBFS: Found @ offset d2c0 size 17000
00.938: microcode: sig=3D0x6ec pf=3D0x20 revision=3D0x0
00.940: microcode: updated to revision 0x54 date=3D2006-05-01
00.940: CPU: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz.
00.940: MTRR: Fixed MSR 0x250 0x0606060606060606
00.940: MTRR: Fixed MSR 0x258 0x0606060606060606
00.941: MTRR: Fixed MSR 0x259 0x0000000000000000
00.941: MTRR: Fixed MSR 0x268 0x0606060606060606
00.941: MTRR: Fixed MSR 0x269 0x0606060606060606
00.941: MTRR: Fixed MSR 0x26a 0x0606060606060606
00.941: MTRR: Fixed MSR 0x26b 0x0606060606060606
00.941: MTRR: Fixed MSR 0x26c 0x0606060606060606
00.941: MTRR: Fixed MSR 0x26d 0x0606060606060606
00.941: MTRR: Fixed MSR 0x26e 0x0606060606060606
00.942: MTRR: Fixed MSR 0x26f 0x0606060606060606
00.942: CPU physical address size: 32 bits
00.943:=20
00.943: MTRR check
00.943: Fixed MTRRs   : Enabled
00.943: Variable MTRRs: Enabled
00.943:=20
00.943: Setting up local APIC... apic_id: 0x01 done.
00.943: VMX status: enabled, locked
00.943: CPU: 1 2 siblings
00.943: CPU #1 initialized
00.943: CPU 1 going down...
00.943: All AP CPUs stopped (9739 loops)
00.943: CPU_CLUSTER: 0 init finished in 322673 usecs
00.943: PCI: 00:02.0 init ...
00.943: Initializing VGA without OPROM.
01.007: No display connected on slave 2
01.023: WARNING: EDID block does NOT fully conform to EDID 1.3.
01.023: <09>Missing name descriptor
01.023: <09>Missing monitor ranges
01.023: bringing up panel at resolution 1024 x 768
01.023: Borders 0 x 0
01.023: Blank 320 x 38
01.023: Sync 136 x 6
01.023: Front porch 24 x 3
01.023: Spread spectrum clock
01.023: Single channel
01.023: Polarities 1, 1
01.023: Pixel N=3D3, M1=3D15, M2=3D4, P1=3D2
01.023: Pixel clock 65000 kHz
01.023: VGA mode: text
01.030: waiting for panel powerup
01.030: panel powered up
01.030: gtt_setup is enabled.
01.030: 8M UMA
01.031: GTT PGETBL_CTL register: 0x7ffc0001
01.031: GTT Enabled
01.034: PCI: 00:02.0 init finished in 139555 usecs
01.034: PCI: 00:02.1 init ...
01.034: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.034: CBFS: Locating 'cmos_layout.bin'
01.034: CBFS: Found @ offset 39100 size 6ac
01.035: PCI: 00:02.1 init finished in 14411 usecs
01.035: PCI: 00:1b.0 init ...
01.036: Azalia: codec type: Azalia
01.036: Azalia: base =3D e4440000
01.038: Azalia: codec_mask =3D 03
01.038: Azalia: Initializing codec #1
01.038: Azalia: codec viddid: 14f12bfa
01.038: Azalia: No verb!
01.038: Azalia: Initializing codec #0
01.038: Azalia: codec viddid: 11d41981
01.038: Azalia: verb_size: 44
01.040: Azalia: verb loaded.
01.040: PCI: 00:1b.0 init finished in 30351 usecs
01.040: PCI: 00:1c.0 init ...
01.040: Initializing ICH7 PCIe bridge.
01.040: PCI: 00:1c.0 init finished in 4837 usecs
01.040: PCI: 00:1c.1 init ...
01.040: Initializing ICH7 PCIe bridge.
01.040: PCI: 00:1c.1 init finished in 4838 usecs
01.040: PCI: 00:1c.2 init ...
01.040: Initializing ICH7 PCIe bridge.
01.040: PCI: 00:1c.2 init finished in 4838 usecs
01.040: PCI: 00:1c.3 init ...
01.040: Initializing ICH7 PCIe bridge.
01.040: PCI: 00:1c.3 init finished in 4839 usecs
01.040: PCI: 00:1d.0 init ...
01.040: UHCI: Setting up controller.. done.
01.040: PCI: 00:1d.0 init finished in 5273 usecs
01.040: PCI: 00:1d.1 init ...
01.040: UHCI: Setting up controller.. done.
01.040: PCI: 00:1d.1 init finished in 5273 usecs
01.040: PCI: 00:1d.2 init ...
01.040: UHCI: Setting up controller.. done.
01.040: PCI: 00:1d.2 init finished in 5272 usecs
01.040: PCI: 00:1d.3 init ...
01.040: UHCI: Setting up controller.. done.
01.040: PCI: 00:1d.3 init finished in 5273 usecs
01.040: PCI: 00:1d.7 init ...
01.040: EHCI: Setting up controller.. done.
01.040: PCI: 00:1d.7 init finished in 5280 usecs
01.040: PCI: 00:1e.0 init ...
01.040: PCI: 00:1e.0 init finished in 2029 usecs
01.040: PCI: 00:1f.0 init ...
01.040: i82801gx: lpc_init
01.040: IOAPIC: Initializing IOAPIC at 0xfec00000
01.040: IOAPIC: Bootstrap Processor Local APIC =3D 0x00
01.040: IOAPIC: ID =3D 0x02
01.041: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.041: CBFS: Locating 'cmos_layout.bin'
01.041: CBFS: Found @ offset 39100 size 6ac
01.041: WARNING: No CMOS option 'power_on_after_fail'.
01.041: Set power on after power failure.
01.041: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.041: CBFS: Locating 'cmos_layout.bin'
01.042: CBFS: Found @ offset 39100 size 6ac
01.042: NMI sources enabled.
01.042: rtc_failed =3D 0x0
01.042: RTC Init
01.043: Disabling ACPI via APMC:
01.043: done.
01.043: Locking SMM.
01.043: PCI: 00:1f.0 init finished in 54893 usecs
01.043: PCI: 00:1f.1 init ...
01.043: i82801gx_ide: initializing... IDE0
01.044: PCI: 00:1f.1 init finished in 5203 usecs
01.044: PCI: 00:1f.2 init ...
01.044: i82801gx_sata: initializing...
01.044: SATA controller in AHCI mode.
01.044: PCI: 00:1f.2 init finished in 7553 usecs
01.044: PCI: 01:00.0 init ...
01.044: PCI: 01:00.0 init finished in 2017 usecs
01.044: PCI: 02:00.0 init ...
01.044: PCI: 02:00.0 init finished in 2019 usecs
01.044: PCI: 05:00.0 init ...
01.044: Ricoh RL5c476: Initializing.
01.044: CF Base =3D 0
01.044: CF boot not enabled.
01.044: PCI: 05:00.0 init finished in 7727 usecs
01.044: PCI: 05:00.1 init ...
01.044: PCI: 05:00.1 init finished in 2017 usecs
01.044: PCI: 05:00.2 init ...
01.044: PCI: 05:00.2 init finished in 2019 usecs
01.044: PNP: 00ff.2 init ...
01.044: PNP: 00ff.2 init finished in 1932 usecs
01.044: PNP: 164e.2 init ...
01.044: PNP: 164e.2 init finished in 1931 usecs
01.044: PNP: 164e.3 init ...
01.044: PNP: 164e.3 init finished in 1932 usecs
01.044: PNP: 164e.7 init ...
01.044: PNP: 164e.7 init finished in 1931 usecs
01.044: PNP: 164e.19 init ...
01.044: PNP: 164e.19 init finished in 2017 usecs
01.044: PNP: 002e.1 init ...
01.044: PNP: 002e.1 init finished in 1931 usecs
01.044: PNP: 002e.3 init ...
01.044: PNP: 002e.3 init finished in 1931 usecs
01.044: PNP: 002e.7 init ...
01.044: PNP: 002e.7 init finished in 1931 usecs
01.044: smbus: PCI: 00:1f.3[0]->I2C: 01:69 init ...
01.058: Changing 12 of the 12 ck505 config bytes.
01.070: I2C: 01:69 init finished in 33851 usecs
01.070: smbus: PCI: 00:1f.3[0]->I2C: 01:54 init ...
01.070: I2C: 01:54 init finished in 3940 usecs
01.070: smbus: PCI: 00:1f.3[0]->I2C: 01:55 init ...
01.070: I2C: 01:55 init finished in 3940 usecs
01.070: smbus: PCI: 00:1f.3[0]->I2C: 01:56 init ...
01.070: I2C: 01:56 init finished in 3940 usecs
01.070: smbus: PCI: 00:1f.3[0]->I2C: 01:57 init ...
01.070: I2C: 01:57 init finished in 3939 usecs
01.070: smbus: PCI: 00:1f.3[0]->I2C: 01:5c init ...
01.070: Locking EEPROM RFID
01.092: init EEPROM done
01.092: I2C: 01:5c init finished in 28972 usecs
01.092: smbus: PCI: 00:1f.3[0]->I2C: 01:5d init ...
01.092: I2C: 01:5d init finished in 3939 usecs
01.092: smbus: PCI: 00:1f.3[0]->I2C: 01:5e init ...
01.092: I2C: 01:5e init finished in 3939 usecs
01.092: smbus: PCI: 00:1f.3[0]->I2C: 01:5f init ...
01.092: I2C: 01:5f init finished in 3941 usecs
01.092: Devices initialized
01.092: BS: BS_DEV_INIT times (us): entry 7 run 896244 exit 0
01.092: Finalize devices...
01.092: Devices finalized
01.092: BS: BS_POST_DEVICE times (us): entry 0 run 3508 exit 0
01.092: BS: BS_OS_RESUME_CHECK times (us): entry 0 run 0 exit 0
01.092: Copying Interrupt Routing Table to 0x000f0000... done.
01.092: Copying Interrupt Routing Table to 0x7f732000... done.
01.092: PIRQ table: 272 bytes.
01.092: Wrote the mp table end at: 000f0410 - 000f05cc
01.092: Wrote the mp table end at: 7f731010 - 7f7311cc
01.092: MP table: 460 bytes.
01.092: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.092: CBFS: Locating 'fallback/dsdt.aml'
01.093: CBFS: Found @ offset 39800 size 300e
01.093: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.093: CBFS: Locating 'fallback/slic'
01.093: CBFS: 'fallback/slic' not found.
01.093: ACPI: Writing ACPI tables at 7f70d000.
01.093: ACPI:    * FACS
01.093: ACPI:    * DSDT
01.100: ACPI:    * FADT
01.100: ACPI: added table 1/32, length now 40
01.100: ACPI:     * SSDT
01.126: Lenovo P/N is 636338U
01.125: Lenovo P/N 636338U is a tablet
01.125: Found 1 CPU(s) with 2 core(s) each.
01.125: clocks between 1000 and 1666 MHz.
01.125: adding 3 P-States between busratio 6 and a, incl. P0
01.125: PSS: 1666MHz power 31000 control 0xa1b status 0xa1b
01.125: PSS: 1333MHz power 22050 control 0x817 status 0x817
01.125: PSS: 1000MHz power 13100 control 0x613 status 0x613
01.125: clocks between 1000 and 1666 MHz.
01.125: adding 3 P-States between busratio 6 and a, incl. P0
01.125: PSS: 1666MHz power 31000 control 0xa1b status 0xa1b
01.125: PSS: 1333MHz power 22050 control 0x817 status 0x817
01.125: PSS: 1000MHz power 13100 control 0x613 status 0x613
01.126: ACPI: added table 2/32, length now 44
01.126: ACPI:    * MCFG
01.126: ACPI: added table 3/32, length now 48
01.126: ACPI:    * TCPA
01.126: TCPA log created at 7f6fd000
01.126: ACPI: added table 4/32, length now 52
01.126: ACPI:    * MADT
01.126: ACPI: added table 5/32, length now 56
01.126: current =3D 7f710a00
01.126: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.126: CBFS: Locating 'vbt.bin'
01.126: CBFS: 'vbt.bin' not found.
01.126: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.126: CBFS: Locating 'pci8086,27a2.rom'
01.127: CBFS: 'pci8086,27a2.rom' not found.
01.127: PCI Option ROM loading disabled for PCI: 00:02.0
01.127: GMA: locate_vbt_vbios: aa55 8086 0 0 3
01.127: GMA: Found valid VBT in legacy area
01.127: ACPI:    * HPET
01.127: ACPI: added table 6/32, length now 60
01.127: ACPI: done.
01.127: ACPI tables: 23104 bytes.
01.127: smbios_write_tables: 7f6fc000
01.289: Root Device (LENOVO ThinkPad X60)
01.289: CPU_CLUSTER: 0 (Intel i945 Northbridge)
01.289: APIC: 00 (unknown)
01.289: DOMAIN: 0000 (Intel i945 Northbridge)
01.289: PCI: 00:00.0 (Intel i945 Northbridge)
01.289: PCI: 00:02.0 (Intel i945 Northbridge)
01.289: PCI: 00:02.1 (Intel i945 Northbridge)
01.289: PCI: 00:1b.0 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1c.0 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1c.1 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1d.0 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1d.1 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1d.2 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1d.3 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1d.7 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1f.0 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PNP: 00ff.1 (Lenovo Power Management Hardware Hub 7)
01.289: PNP: 00ff.2 (Lenovo H8 EC)
01.289: PNP: 164e.2 (NSC PC87382 Docking LPC Switch)
01.289: PNP: 164e.3 (NSC PC87382 Docking LPC Switch)
01.289: PNP: 164e.7 (NSC PC87382 Docking LPC Switch)
01.289: PNP: 164e.19 (NSC PC87382 Docking LPC Switch)
01.289: PNP: 002e.0 (NSC PC87392 Super I/O)
01.289: PNP: 002e.1 (NSC PC87392 Super I/O)
01.289: PNP: 002e.2 (NSC PC87392 Super I/O)
01.289: PNP: 002e.3 (NSC PC87392 Super I/O)
01.289: PNP: 002e.7 (NSC PC87392 Super I/O)
01.289: PNP: 002e.a (NSC PC87392 Super I/O)
01.289: PCI: 00:1f.1 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1f.2 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: PCI: 00:1f.3 (Intel ICH7/ICH7-M (82801Gx) Series Southbridge)
01.289: I2C: 01:69 (CK505 Clock generator)
01.289: I2C: 01:54 (AT24RF08C)
01.289: I2C: 01:55 (AT24RF08C)
01.289: I2C: 01:56 (AT24RF08C)
01.289: I2C: 01:57 (AT24RF08C)
01.289: I2C: 01:5c (AT24RF08C)
01.289: I2C: 01:5d (AT24RF08C)
01.289: I2C: 01:5e (AT24RF08C)
01.289: I2C: 01:5f (AT24RF08C)
01.289: PCI: 00:1c.2 (unknown)
01.289: PCI: 00:1c.3 (unknown)
01.289: PCI: 00:1e.0 (unknown)
01.289: PCI: 01:00.0 (unknown)
01.289: PCI: 02:00.0 (unknown)
01.289: PCI: 05:00.0 (unknown)
01.289: PCI: 05:00.1 (unknown)
01.289: PCI: 05:00.2 (unknown)
01.289: APIC: 01 (unknown)
01.289: SMBIOS tables: 438 bytes.
01.289: Writing table forward entry at 0x00000500
01.289: Wrote coreboot table at: 00000500, 0x10 bytes, checksum 506b
01.289: Writing coreboot table at 0x7f733000
01.289: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.289: CBFS: Locating 'cmos_layout.bin'
01.290: CBFS: Found @ offset 39100 size 6ac
01.291:  0. 0000000000000000-0000000000000fff: CONFIGURATION TABLES
01.291:  1. 0000000000001000-000000000009ffff: RAM
01.291:  2. 00000000000c0000-000000007f6fbfff: RAM
01.291:  3. 000000007f6fc000-000000007f7fffff: CONFIGURATION TABLES
01.291:  4. 000000007f800000-000000007fffffff: RESERVED
01.291:  5. 00000000f0000000-00000000f3ffffff: RESERVED
01.291: Manufacturer: c2
01.291: SF: Detected MX25L1605D with sector size 0x1000, total 0x200000
01.291: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.291: FMAP: Found "FLASH" version 1.1 at 0.
01.291: FMAP: base =3D ffe00000 size =3D 200000 #areas =3D 3
01.291: Wrote coreboot table at: 7f733000, 0xa08 bytes, checksum 8d15
01.291: coreboot table: 2592 bytes.
01.291: IMD ROOT    0. 7f7ff000 00001000
01.291: IMD SMALL   1. 7f7fe000 00001000
01.291: CONSOLE     2. 7f7ce000 00030000
01.291: TIME STAMP  3. 7f7cd000 00000400
01.291: ROMSTG STCK 4. 7f7c8000 00005000
01.291: RAMSTAGE    5. 7f789000 0003f000
01.291: 57a9e100    6. 7f74b000 0003d8d0
01.291: SMM BACKUP  7. 7f73b000 00010000
01.291: COREBOOT    8. 7f733000 00008000
01.291: IRQ TABLE   9. 7f732000 00001000
01.291: SMP TABLE  10. 7f731000 00001000
01.292: ACPI       11. 7f70d000 00024000
01.292: TCPA LOG   12. 7f6fd000 00010000
01.292: SMBIOS     13. 7f6fc000 00000800
01.292: IMD small region:
01.292:   IMD ROOT    0. 7f7fec00 00000400
01.292:   CAR GLOBALS 1. 7f7feac0 00000140
01.292:   ROMSTAGE    2. 7f7feaa0 00000004
01.292:   57a9e000    3. 7f7fea80 00000018
01.292:   ACPI GNVS   4. 7f7fe980 00000100
01.292:   COREBOOTFWD 5. 7f7fe940 00000028
01.292: BS: BS_WRITE_TABLES times (us): entry 0 run 686056 exit 0
01.292: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
01.292: CBFS: Locating 'fallback/payload'
01.293: CBFS: Found @ offset 5ad00 size 57f3c
01.293: Loading segment from ROM address 0xffe5af38
01.293:   code (compression=3D1)
01.293:   New segment dstaddr 0x9000 memsize 0x17b48 srcaddr 0xffe5af8c f=
ilesize 0x8520
01.293: Loading segment from ROM address 0xffe5af54
01.293:   code (compression=3D1)
01.293:   New segment dstaddr 0x100000 memsize 0xfac68 srcaddr 0xffe634ac=
 filesize 0x4f9c8
01.293: Loading segment from ROM address 0xffe5af70
01.293:   Entry Point 0x00009000
01.293: Loading Segment: addr: 0x0000000000009000 memsz: 0x0000000000017b=
48 filesz: 0x0000000000008520
01.293: Post relocation: addr: 0x0000000000009000 memsz: 0x0000000000017b=
48 filesz: 0x0000000000008520
01.293: using LZMA
01.314: Clearing Segment: addr: 0x0000000000019103 memsz: 0x0000000000007=
a45
01.314: dest 00009000, end 00020b48, bouncebuffer ffffffff
01.314: Loading Segment: addr: 0x0000000000100000 memsz: 0x00000000000fac=
68 filesz: 0x000000000004f9c8
01.314: Post relocation: addr: 0x0000000000100000 memsz: 0x00000000000fac=
68 filesz: 0x000000000004f9c8
01.314: using LZMA
01.515: dest 00100000, end 001fac68, bouncebuffer ffffffff
01.515: BS: BS_PAYLOAD_LOAD times (us): entry 0 run 318118 exit 0
01.515: ICH7 watchdog disabled
01.515: Jumping to boot code at 00009000(7f733000)
31.117: [    0.515017] 00:07: ttyS1 at I/O 0x3f8 (irq =3D 4, base_baud =3D=
 115200) is a 16550A
31.118: [    0.523260] Linux agpgart interface v0.103
31.119: [    0.528188] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:=
PS2M] at 0x60,0x64 irq 1,12
31.130: [    0.547244] serio: i8042 KBD port at 0x60,0x64 irq 1
31.130: [    0.552286] serio: i8042 AUX port at 0x60,0x64 irq 12
31.130: [    0.557653] rtc_cmos 00:03: RTC can wake from S4
31.131: [    0.562627] rtc_cmos 00:03: registered as rtc0
31.131: [    0.567197] rtc_cmos 00:03: alarms up to one month, y3k, 242 b=
ytes nvram, hpet irqs
31.131: [    0.575045] ledtrig-cpu: registered to indicate activity on CP=
Us
31.132: [    0.581736] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D0
31.132: [    0.590831] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.132: [    0.599654] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D0
31.132: [    0.608722] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.132: [    0.617551] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D0
31.132: [    0.626630] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.132: [    0.635438] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D0
31.133: [    0.644556] input: AT Translated Set 2 keyboard as /devices/pl=
atform/i8042/serio0/input/input0
31.133: [    0.653260] NET: Registered protocol family 10
31.133: [    0.657848] random: get_random_u32 called from bucket_table_al=
loc+0x163/0x340 with crng_init=3D0
31.133: [    0.657893] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.133: [    0.666590] random: get_random_u32 called from neigh_hash_allo=
c+0x9e/0x140 with crng_init=3D0
31.133: [    0.675425] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.133: [    0.683777] random: get_random_u32 called from neigh_hash_allo=
c+0x9e/0x140 with crng_init=3D0
31.133: [    0.683786] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.134: [    0.710026] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.134: [    0.719105] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.134: [    0.727990] random: get_random_u32 called from bucket_table_al=
loc+0x163/0x340 with crng_init=3D0
31.134: [    0.736727] Segment Routing with IPv6
31.134: [    0.740513] mip6: Mobile IPv6
31.135: [    0.743553] NET: Registered protocol family 17
31.135: [    0.748110] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.135: [    0.757149] mpls_gso: MPLS GSO support
31.135: [    0.761011] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.136: [    0.770429] microcode: sig=3D0x6ec, pf=3D0x20, revision=3D0x54=

31.138: [    0.775944] microcode: Microcode Update Driver: v2.2.
31.138: [    0.783319] Using IPI No-Shortcut mode
31.138: [    0.787185] random: get_random_bytes called from init_oops_id+=
0x42/0x50 with crng_init=3D0
31.139: [    0.795774] registered taskstats version 1
31.139: [    0.799963] Loading compiled-in X.509 certificates
31.139: [    0.804901] zswap: loaded using pool lzo/zbud
31.140: [    0.809627] random: get_random_bytes called from key_alloc+0x1=
fc/0x5e0 with crng_init=3D0
31.140: [    0.817761] random: get_random_bytes called from prandom_seed_=
full_state+0x65/0x120 with crng_init=3D0
31.141: [    0.827591] rtc_cmos 00:03: setting system clock to 2018-04-23=
 21:23:46 UTC (1524518626)
31.141: [    0.835868] Unstable clock detected, switching default tracing=
 clock to "global"
31.141: [    0.835868] If you want to keep using the local clock, then ad=
d:
31.141: [    0.835868]   "trace_clock=3Dlocal"
31.141: [    0.835868] on the kernel command line
31.143: [    0.858614] Freeing unused kernel memory: 884K
31.143: [    0.863309] Write protecting the kernel text: 10556k
31.143: [    0.868447] Write protecting the kernel read-only data: 2384k
31.144: [    0.874435] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.144: [    0.882717] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.144: [    0.891264] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.144: [    0.899661] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.144: [    0.907995] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.144: [    0.916355] random: get_random_bytes called from load_elf_bina=
ry+0xaf8/0x1d20 with crng_init=3D0
31.145: [    0.925080] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.145: [    0.933954] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.146: [    0.943152] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.146: [    0.952090] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.146: [    0.960362] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.146: [    0.968883] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.146: [    0.977246] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.146: [    0.985554] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.147: [    0.993909] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.147: [    1.002679] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.148: [    1.011834] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.148: [    1.020735] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.148: [    1.029010] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.148: [    1.037537] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.148: [    1.045899] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.148: [    1.054210] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.148: [    1.054226] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.149: [    1.071559] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.149: [    1.080314] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.150: [    1.089564] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.150: [    1.097838] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.150: [    1.106369] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.150: [    1.114723] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.150: [    1.123022] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.150: [    1.131382] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.151: [    1.140085] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.151: [    1.149082] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.151: [    1.158132] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.151: [    1.166406] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.152: [    1.174931] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.152: [    1.183290] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.152: [    1.191588] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.152: [    1.199949] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.153: [    1.208681] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.153: [    1.217678] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.153: [    1.226737] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.153: [    1.235015] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.153: [    1.243542] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.153: [    1.251901] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.154: [    1.260202] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.154: [    1.268561] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.154: [    1.277363] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.155: [    1.286381] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.155: [    1.295414] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.155: [    1.303688] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.155: [    1.312214] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.155: [    1.320574] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.155: [    1.328871] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.156: [    1.337230] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.156: [    1.345976] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.156: [    1.354962] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.157: [    1.364094] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.157: [    1.372365] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.157: [    1.380892] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.157: [    1.389249] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.157: [    1.397549] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.157: [    1.405907] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.158: [    1.414460] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D0
31.158: [    1.423623] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.159: [    1.432882] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.159: [    1.441156] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.159: [    1.449691] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.159: [    1.458054] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.159: [    1.466357] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.159: [    1.474732] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.160: [    1.483520] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.161: [    1.492772] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.161: [    1.501048] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.161: [    1.509577] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.161: [    1.517934] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.161: [    1.526233] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.161: [    1.534596] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D0
31.162: [    1.543285] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D0
31.164: [    1.552531] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.164: [    1.562991] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D0
31.164: [    1.571524] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D0
31.165: [    1.579884] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D0
31.165: [    1.584039] random: fast init done
31.165: [    1.588192] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.165: [    1.599969] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.166: [    1.608626] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.166: [    1.617577] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.166: [    1.626827] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.166: [    1.635100] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.166: [    1.643631] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.167: [    1.651983] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.167: [    1.660300] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.167: [    1.668660] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.167: [    1.677296] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.168: [    1.686249] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.168: [    1.695491] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.168: [    1.703771] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.168: [    1.712302] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.168: [    1.720655] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.168: [    1.728953] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.169: [    1.737311] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.171: [    1.747498] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.171: [    1.756809] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.171: [    1.765082] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.171: [    1.773614] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.171: [    1.781966] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.172: [    1.790266] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.172: [    1.798629] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.173: [    1.807761] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.173: [    1.816750] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.173: [    1.825902] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.174: [    1.834179] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.174: [    1.842706] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.174: [    1.851063] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.174: [    1.859362] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.174: [    1.867722] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.175: [    1.876433] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.175: [    1.885406] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.175: [    1.894505] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.175: [    1.902784] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.175: [    1.911325] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.176: [    1.919695] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.176: [    1.928026] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.176: [    1.936387] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.177: [    1.945386] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.177: [    1.954666] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.177: [    1.962944] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.177: [    1.971481] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.177: [    1.979834] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.178: [    1.988133] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.178: [    1.996497] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.179: [    2.005357] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.179: [    2.014343] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.179: [    2.023444] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.179: [    2.031723] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.179: [    2.040248] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.179: [    2.048609] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.180: [    2.056908] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.180: [    2.065270] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.180: [    2.074001] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.181: [    2.083257] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.181: [    2.091543] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.181: [    2.100080] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.181: [    2.108452] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.181: [    2.116769] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.181: [    2.125136] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.182: [    2.133824] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.182: [    2.143009] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.183: [    2.151289] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.183: [    2.159818] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.183: [    2.168174] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.183: [    2.176475] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.183: [    2.184834] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.183: [    2.193451] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.184: [    2.202425] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.184: [    2.211496] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.184: [    2.219777] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.184: [    2.228323] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.184: [    2.236696] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.185: [    2.245013] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.185: [    2.253380] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.296: [    2.373079] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.307: [    2.392719] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.308: [    2.402018] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.308: [    2.410302] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.308: [    2.418842] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.308: [    2.427211] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.308: [    2.435531] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.311: [    2.443901] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.311: [    2.454871] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.312: [    2.464161] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.312: [    2.472444] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.312: [    2.480968] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.312: [    2.489327] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.312: [    2.497627] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.312: [    2.505988] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.314: [    2.516064] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.315: [    2.525104] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.315: [    2.534251] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.315: [    2.534475] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.315: [    2.543760] random: systemd-udevd: uninitialized urandom read =
(16 bytes read)
31.315: [    2.552324] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.315: [    2.559409] random: systemd-udevd: uninitialized urandom read =
(16 bytes read)
31.315: [    2.567543] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.316: [    2.574775] random: systemd-udevd: uninitialized urandom read =
(16 bytes read)
31.316: [    2.583267] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.316: [    2.583280] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.316: [    2.590530] random: systemd-udevd: uninitialized urandom read =
(16 bytes read)
31.316: [    2.598882] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.316: [    2.609251] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.316: [    2.614334] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.316: [    2.622692] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.316: [    2.633391] random: udevadm: uninitialized urandom read (16 by=
tes read)
31.317: [    2.655574] random: udevadm: uninitialized urandom read (16 by=
tes read)
31.320: [    2.665182] random: udevadm: uninitialized urandom read (16 by=
tes read)
31.320: [    2.672049] random: udevadm: uninitialized urandom read (16 by=
tes read)
31.321: [    2.679538] random: udevadm: uninitialized urandom read (16 by=
tes read)
31.321: [    2.686388] random: udevadm: uninitialized urandom read (16 by=
tes read)
31.363: [    2.734444] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.363: [    2.734459] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.363: [    2.743744] random: get_random_bytes called from generate_rand=
om_uuid+0x10/0x50 with crng_init=3D1
31.363: [    2.759180] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.363: [    2.761329] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.363: [    2.770455] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.364: [    2.787172] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
31.364: [    2.787688] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.364: [    2.795740] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.364: [    2.805078] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.364: [    2.813086] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
31.364: [    2.821847] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.364: [    2.830256] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
31.364: [    2.839164] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.365: [    2.847438] random: get_random_bytes called from load_elf_bina=
ry+0xaf8/0x1d20 with crng_init=3D1
31.365: [    2.856810] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.365: [    2.864953] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
31.365: [    2.875103] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.365: [    2.891101] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.365: [    2.900111] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.366: [    2.909180] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.366: [    2.909854] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.366: [    2.918373] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.366: [    2.935948] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.366: [    2.936470] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.366: [    2.953750] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.367: [    2.962961] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.367: [    2.972041] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.368: [    2.981871] random: get_random_u32 called from module_alloc+0x=
105/0x120 with crng_init=3D1
31.368: [    2.989218] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.369: [    2.999180] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.369: [    2.999224] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.369: [    3.008084] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.369: [    3.026072] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.370: [    3.035278] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.370: [    3.044268] thermal LNXTHERM:00: registered as thermal_zone0
31.370: [    3.044357] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.370: [    3.050024] ACPI: Thermal Zone [THM0] (56 C)
31.370: [    3.059732] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.371: [    3.063888] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.371: [    3.074819] thermal LNXTHERM:01: registered as thermal_zone1
31.371: [    3.081275] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.371: [    3.086920] ACPI: Thermal Zone [THM1] (41 C)
31.382: [    3.111365] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.383: [    3.112382] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.399: [    3.145866] SCSI subsystem initialized
31.409: [    3.159069] ahci 0000:00:1f.2: SSS flag set, parallel bus scan=
 disabled
31.409: [    3.165806] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports=
 1.5 Gbps 0x1 impl SATA mode
31.409: [    3.174163] ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm l=
ed clo pmp pio slum part=20
31.411: [    3.183765] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.411: [    3.193180] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.412: [    3.202364] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.412: [    3.202520] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.412: [    3.211375] scsi host0: ahci
31.412: [    3.223409] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
31.412: [    3.224232] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.413: [    3.232912] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.413: [    3.246724] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.413: [    3.251734] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.413: [    3.259695] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.413: [    3.276884] scsi host1: ahci
31.413: [    3.280087] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.414: [    3.289119] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.414: [    3.297986] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.414: [    3.306997] scsi host2: ahci
31.414: [    3.309979] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.414: [    3.318946] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.415: [    3.328026] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.415: [    3.336872] scsi host3: ahci
31.415: [    3.339980] ata1: SATA max UDMA/133 abar m1024@0xe4445000 port=
 0xe4445100 irq 28
31.417: [    3.347478] ata2: DUMMY
31.417: [    3.352205] ata3: DUMMY
31.417: [    3.354731] ata4: DUMMY
31.418: [    3.357331] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.418: [    3.366702] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.418: [    3.375526] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.419: [    3.384576] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.419: [    3.393460] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.565: [    3.548108] clocksource: timekeeping watchdog on CPU0: Marking=
 clocksource 'tsc-early' as unstable because the skew is too large:
31.565: [    3.552096] clocksource:                       'hpet' wd_now: =
324eefb wd_last: 2b6d2b8 mask: ffffffff
31.565: [    3.552096] clocksource:                       'tsc-early' cs_=
now: e0f6a8d68 cs_last: deaf2b3ca mask: ffffffffffffffff
31.565: [    3.579973] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.673: [    3.697028] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl =
300)
31.674: [    3.703724] ata1.00: ATA-9: M4-CT256M4SSD2, 070H, max UDMA/100=

31.674: [    3.709638] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (d=
epth 31/32), AA
31.675: [    3.717333] ata1.00: configured for UDMA/100
31.675: [    3.721965] scsi 0:0:0:0: Direct-Access     ATA      M4-CT256M=
4SSD2   070H PQ: 0 ANSI: 5
31.680: [    3.734907] sd 0:0:0:0: [sda] 500118192 512-byte logical block=
s: (256 GB/238 GiB)
31.680: [    3.742522] sd 0:0:0:0: [sda] Write Protect is off
31.680: [    3.747429] sd 0:0:0:0: [sda] Write cache: enabled, read cache=
: enabled, doesn't support DPO or FUA
31.681: [    3.756949] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
31.681: [    3.766271]  sda: sda1 sda2
31.681: [    3.769303] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
31.682: [    3.778617] sd 0:0:0:0: [sda] Attached SCSI disk
31.682: [    3.783324] sd 0:0:0:0: [sda] Synchronizing SCSI cache
31.689: [    3.795770] sd 0:0:0:0: [sda] Stopping disk
32.443: [    4.553878] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.443: [    4.554023] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
32.443: [    4.563576] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.444: [    4.579945] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.444: [    4.588491] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.444: [    4.596854] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.444: [    4.605175] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.444: [    4.613534] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.446: [    4.623180] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
32.479: [    4.665121] random: get_random_u32 called from bucket_table_al=
loc+0x163/0x340 with crng_init=3D1
32.480: [    4.674721] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.480: [    4.683800] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
32.480: [    4.684091] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.480: [    4.692598] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.481: [    4.700872] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.481: [    4.718354] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.481: [    4.726728] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.481: [    4.735122] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.481: [    4.743487] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.482: [    4.752295] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.483: [    4.761983] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.483: [    4.770266] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.483: [    4.778806] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.483: [    4.787169] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.483: [    4.795474] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.483: [    4.803838] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.487: [    4.815324] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
32.487: [    4.824298] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
32.487: [    4.824461] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.487: [    4.833378] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
32.487: [    4.842366] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
32.487: [    4.851380] device-mapper: uevent: version 1.0.3
32.488: [    4.851415] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
32.488: [    4.861008] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
32.488: [    4.882859] device-mapper: ioctl: 4.39.0-ioctl (2018-04-03) in=
itialised: dm-devel@redhat.com
32.488: [    4.883078] random: get_random_u32 called from bucket_table_al=
loc+0x163/0x340 with crng_init=3D1
32.488: [    4.900132] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.489: [    4.909296] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
32.492: [    4.921494] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.493: [    4.931128] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.493: [    4.939417] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.493: [    4.947961] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.493: [    4.956369] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.493: [    4.964693] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.494: [    4.973066] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.495: [    4.983018] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.496: [    4.992326] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.496: [    5.000606] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.496: [    5.009143] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.496: [    5.017508] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.496: [    5.025813] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.496: [    5.034175] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.499: [    5.044805] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.499: [    5.054121] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.500: [    5.062403] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.500: [    5.070938] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.500: [    5.079302] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.500: [    5.087613] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.500: [    5.095973] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.502: [    5.105555] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.502: [    5.114847] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.502: [    5.123126] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.502: [    5.131666] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.502: [    5.140034] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.503: [    5.148345] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.503: [    5.156706] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.504: [    5.166015] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.504: [    5.175324] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.504: [    5.183608] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.507: [    5.192150] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.507: [    5.202711] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.507: [    5.211018] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.507: [    5.219384] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.532: [    5.252653] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.533: [    5.261973] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.533: [    5.270252] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.533: [    5.278790] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.533: [    5.287154] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.533: [    5.295474] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.534: [    5.303842] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
32.536: [    5.313935] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
32.538: [    5.324835] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.538: [    5.324852] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
32.538: [    5.333129] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.538: [    5.341659] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
32.538: [    5.350041] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
32.538: [    5.358321] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.745: [    8.581031] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.745: [    8.590115] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.745: [    8.598399] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.745: [    8.606932] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.745: [    8.615292] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.745: [    8.623605] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.745: [    8.631968] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.747: [    8.641475] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.747: [    8.650630] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.748: [    8.660258] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.748: [    8.660718] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.748: [    8.669073] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.749: [    8.670209] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.749: [    8.677357] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.749: [    8.677365] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.749: [    8.712025] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.749: [    8.720345] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.749: [    8.728714] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.750: [    8.737993] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.751: [    8.747095] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.751: [    8.755382] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.751: [    8.763920] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.751: [    8.772280] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.751: [    8.780588] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.751: [    8.788947] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.752: [    8.798103] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.753: [    8.807272] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.753: [    8.815554] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.753: [    8.824089] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.753: [    8.832452] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.753: [    8.840756] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.753: [    8.849114] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.755: [    8.858430] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.755: [    8.867438] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.755: [    8.876541] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.755: [    8.885594] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.756: [    8.894865] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.756: [    8.903674] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
35.756: [    8.912732] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.757: [    8.921918] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.759: [    8.932783] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.759: [    8.941076] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.759: [    8.949612] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.759: [    8.957983] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.759: [    8.966308] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.759: [    8.974676] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.761: [    8.984924] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.762: [    8.994093] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.763: [    9.003599] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.763: [    9.011885] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.763: [    9.020431] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.763: [    9.028800] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.763: [    9.037120] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.763: [    9.045488] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.765: [    9.055489] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.765: [    9.064387] random: get_random_u32 called from bucket_table_al=
loc+0x163/0x340 with crng_init=3D1
35.766: [    9.073151] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.775: [    9.091114] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.775: [    9.099416] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.775: [    9.107959] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.775: [    9.116332] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.775: [    9.124656] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.775: [    9.133030] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.777: [    9.143184] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.778: [    9.152715] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.778: [    9.161002] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.778: [    9.169561] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.779: [    9.177964] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.779: [    9.186279] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.779: [    9.194654] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.845: [    9.268859] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.848: [    9.277923] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.848: [    9.289580] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.849: [    9.298592] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.849: [    9.307619] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.849: [    9.316441] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.849: [    9.325582] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.849: [    9.334386] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
35.849: [    9.343446] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.850: [    9.352599] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.851: [    9.362956] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.851: [    9.371260] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.852: [    9.379798] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.852: [    9.388177] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.852: [    9.396501] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.852: [    9.404871] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.854: [    9.415065] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.855: [    9.424485] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.862: [    9.440233] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.866: [    9.453590] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.868: [    9.464392] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.906: [    9.510427] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.907: [    9.520115] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.907: [    9.528391] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.907: [    9.536920] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.907: [    9.545283] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.907: [    9.553599] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.907: [    9.561968] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.911: [    9.573942] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.912: [    9.583337] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.912: [    9.591616] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.912: [    9.600153] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.912: [    9.608528] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.912: [    9.616846] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.912: [    9.625219] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.917: [    9.637489] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
35.971: [    9.701074] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.972: [    9.710476] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.972: [    9.718758] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.972: [    9.727294] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.972: [    9.735662] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.972: [    9.743972] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.973: [    9.752356] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.989: [    9.776994] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.990: [    9.786321] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.990: [    9.794608] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.990: [    9.803146] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.990: [    9.811512] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.990: [    9.819824] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.990: [    9.828195] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.991: [    9.837226] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.992: [    9.846527] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.992: [    9.854807] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.992: [    9.863345] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.992: [    9.871711] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.992: [    9.880038] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.992: [    9.888406] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.993: [    9.897308] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.994: [    9.906600] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.994: [    9.914880] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.994: [    9.923422] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.994: [    9.931793] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.994: [    9.940108] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.994: [    9.948469] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
35.995: [    9.957601] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
35.996: [    9.966896] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.996: [    9.975180] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
35.996: [    9.983718] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.996: [    9.992080] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
35.996: [   10.000390] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
35.996: [   10.008751] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.020: [   10.040598] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.021: [   10.050236] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.021: [   10.058518] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.021: [   10.067053] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.021: [   10.075428] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.021: [   10.083743] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.022: [   10.092115] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.023: [   10.101512] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.023: [   10.110876] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.023: [   10.119165] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.024: [   10.127698] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.024: [   10.136113] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.026: [   10.146271] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.027: [   10.155829] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.027: [   10.164108] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.027: [   10.172645] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.027: [   10.181012] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.027: [   10.189320] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.027: [   10.197679] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.031: [   10.207044] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.031: [   10.218540] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.031: [   10.226827] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.031: [   10.235365] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.032: [   10.243776] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.034: [   10.253908] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.034: [   10.263492] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.034: [   10.271770] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.035: [   10.280306] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.035: [   10.288719] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.037: [   10.299044] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.037: [   10.308328] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.038: [   10.316605] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.038: [   10.325149] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.038: [   10.333518] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.038: [   10.341829] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.038: [   10.350198] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.040: [   10.360210] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
36.040: [   10.360353] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.040: [   10.369297] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.042: [   10.389121] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
36.043: [   10.389270] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.043: [   10.398209] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.043: [   10.415978] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
36.043: [   10.425064] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.043: [   10.433866] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
36.043: [   10.443164] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.044: [   10.452441] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.044: [   10.461428] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.044: [   10.470411] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.045: [   10.479596] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.047: [   10.490351] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.047: [   10.499403] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
36.048: [   10.509242] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.049: [   10.518636] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.049: [   10.526933] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.049: [   10.535463] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.049: [   10.543893] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.049: [   10.552213] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.049: [   10.560590] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.050: [   10.569467] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.051: [   10.578717] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.051: [   10.586996] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.051: [   10.595525] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.051: [   10.603881] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.051: [   10.612183] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.051: [   10.620547] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.110: [   10.687800] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.110: [   10.688364] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.111: [   10.705099] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.111: [   10.705104] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.111: [   10.705119] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.111: [   10.705170] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.111: [   10.738677] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.140: [   10.775664] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.196: [   10.839813] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.197: [   10.850520] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.243: [   10.905096] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.244: [   10.914519] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.244: [   10.915367] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.244: [   10.922818] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.244: [   10.940140] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.244: [   10.948508] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.244: [   10.956827] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.244: [   10.965195] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.249: [   10.977889] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.254: [   10.991716] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.258: [   11.004047] random: get_random_u32 called from cache_random_se=
q_create+0xa3/0x1f0 with crng_init=3D1
36.258: [   11.013122] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.259: [   11.023041] EXT4-fs (dm-0): mounted filesystem with ordered da=
ta mode. Opts: (null)
36.273: [   11.044213] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.273: [   11.053576] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.273: [   11.061867] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.273: [   11.070409] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.274: [   11.078789] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.274: [   11.087109] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.274: [   11.095483] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.276: [   11.105474] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.276: [   11.114771] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.276: [   11.123059] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.276: [   11.131599] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.277: [   11.139978] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.277: [   11.148291] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.277: [   11.156660] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.278: [   11.165942] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.279: [   11.175237] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.281: [   11.183520] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.281: [   11.194258] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.281: [   11.202631] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.281: [   11.210948] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.281: [   11.219315] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.282: [   11.227999] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.282: [   11.237257] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.282: [   11.245537] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.283: [   11.254064] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.283: [   11.262423] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.283: [   11.270729] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.283: [   11.279090] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.301: [   11.304733] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.301: [   11.304741] random: get_random_u32 called from bucket_table_al=
loc+0x163/0x340 with crng_init=3D1
36.301: [   11.322786] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.301: [   11.331072] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.301: [   11.339637] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.302: [   11.348020] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.302: [   11.356335] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.302: [   11.364707] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.303: [   11.373839] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.306: [   11.386018] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.307: [   11.395332] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.307: [   11.403610] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.307: [   11.412142] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.307: [   11.420540] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.308: [   11.428967] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.308: [   11.438229] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.308: [   11.446505] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.308: [   11.455031] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.308: [   11.463388] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.308: [   11.471688] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.309: [   11.480049] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.310: [   11.489143] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.310: [   11.498404] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.310: [   11.506686] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.310: [   11.515225] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.310: [   11.523597] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.311: [   11.531915] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.311: [   11.540284] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.311: [   11.548892] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.316: [   11.561795] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.316: [   11.571114] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.316: [   11.579399] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.316: [   11.587943] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.316: [   11.596368] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.318: [   11.606056] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.341: [   11.637906] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.342: [   11.647257] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.342: [   11.655540] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.342: [   11.664068] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.342: [   11.672471] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.342: [   11.680972] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.343: [   11.690235] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.343: [   11.698514] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.343: [   11.707043] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.343: [   11.715397] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.343: [   11.723697] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.343: [   11.732057] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.349: [   11.745379] random: get_random_u32 called from copy_process.pa=
rt.33+0x186/0x2100 with crng_init=3D1
36.349: [   11.754660] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.349: [   11.762947] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.349: [   11.771488] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.349: [   11.779859] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.350: [   11.788173] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.350: [   11.796544] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.352: [   11.806962] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.355: [   11.818297] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.355: [   11.826584] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.355: [   11.835126] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.355: [   11.843563] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.362: [   11.858878] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.371: [   11.875857] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.371: [   11.884139] random: get_random_u32 called from load_elf_binary=
+0x76a/0x1d20 with crng_init=3D1
36.371: [   11.892676] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.371: [   11.901050] random: get_random_u32 called from arch_rnd.part.2=
+0x18/0x40 with crng_init=3D1
36.380: [   11.917630] random: get_random_u32 called from arch_align_stac=
k+0x45/0x70 with crng_init=3D1
36.380: [   11.926006] random: get_random_u32 called from randomize_page+=
0x42/0x57 with crng_init=3D1
36.401: [   11.955898] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.923: [   12.485686] systemd[1]: systemd 232 running in system mode. (+=
PAM +AUDIT +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP =
+GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
36.939: [   12.520286] systemd[1]: Detected architecture x86.
36.950: [   12.535636] systemd[1]: Set hostname to <gm-debian>.
36.951: [   12.541437] random: get_random_u32 called from bucket_table_al=
loc+0x163/0x340 with crng_init=3D1
36.963: [   12.561900] random: get_random_u32 called from cache_alloc_ref=
ill+0x5bb/0x13d0 with crng_init=3D1
36.965: [   12.572914] random: crng init done
37.384: [   12.995005] systemd[1]: Listening on Syslog Socket.
37.384: [   13.000548] systemd[1]: Listening on udev Kernel Socket.
37.385: [   13.006387] systemd[1]: Started Dispatch Password Requests to =
Console Directory Watch.
37.388: [   13.015061] systemd[1]: Set up automount Arbitrary Executable =
File Formats File System Automount Point.
37.388: [   13.027152] systemd[1]: Listening on Journal Socket (/dev/log)=
=2E
37.389: [   13.033801] systemd[1]: Created slice User and Session Slice.
37.390: [   13.040125] systemd[1]: Listening on Network Service Netlink S=
ocket.
37.494: [   13.150791] EXT4-fs (dm-0): re-mounted. Opts: errors=3Dremount=
-ro,discard
38.823: [   14.486802] systemd-journald[261]: Received request to flush r=
untime journal from PID 1
38.878: [   14.549752] systemd-journald[261]: File /var/log/journal/3606b=
1ddb0854918b8e3d24578588f9c/system.journal corrupted or uncleanly shut do=
wn, renaming and replacing.
39.061: [   14.746908] shpchp: Standard Hot Plug PCI Controller Driver ve=
rsion: 0.4
39.072: [   14.764543] ACPI: bus type USB registered
39.078: [   14.774861] usbcore: registered new interface driver usbfs
39.079: [   14.780671] usbcore: registered new interface driver hub
39.080: [   14.787956] usbcore: registered new device driver usb
39.098: [   14.810939] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI=
) Driver
39.102: [   14.820561] ACPI: AC Adapter [AC] (on-line)
39.106: [   14.828692] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYB=
US:00/PNP0A08:00/device:22/PNP0C09:00/PNP0C0E:00/input/input2
39.106: [   14.840443] ACPI Error: AE_NOT_FOUND, Error reading AC Adapter=
 state (20180313/ac-139)
39.107: [   14.848752] ACPI: Sleep Button [SLPB]
39.107: [   14.853151] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS=
:00/PNP0A08:00/device:22/PNP0C09:00/PNP0C0D:00/input/input3
39.108: [   14.864976] uhci_hcd: USB Universal Host Controller Interface =
driver
39.113: [   14.875748] uhci_hcd 0000:00:1d.0: UHCI Host Controller
39.115: [   14.883452] ACPI: Lid Switch [LID]
39.115: [   14.886983] uhci_hcd 0000:00:1d.0: new USB bus registered, ass=
igned bus number 1
39.116: [   14.894635] input: Power Button as /devices/LNXSYSTM:00/LNXPWR=
BN:00/input/input4
39.116: [   14.902198] uhci_hcd 0000:00:1d.0: detected 2 ports
39.117: [   14.908488] ACPI: Power Button [PWRF]
39.119: [   14.914352] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00005000
39.121: [   14.921472] usb usb1: New USB device found, idVendor=3D1d6b, i=
dProduct=3D0001, bcdDevice=3D 4.17
39.121: [   14.929888] usb usb1: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
39.121: [   14.937204] usb usb1: Product: UHCI Host Controller
39.121: [   14.942157] usb usb1: Manufacturer: Linux 4.17.0-rc2+ uhci_hcd=

39.121: [   14.948067] usb usb1: SerialNumber: 0000:00:1d.0
39.123: [   14.954861] hub 1-0:1.0: USB hub found
39.124: [   14.958734] hub 1-0:1.0: 2 ports detected
39.124: [   14.963428] uhci_hcd 0000:00:1d.1: UHCI Host Controller
39.124: [   14.968763] uhci_hcd 0000:00:1d.1: new USB bus registered, ass=
igned bus number 2
39.125: [   14.976560] uhci_hcd 0000:00:1d.1: detected 2 ports
39.125: [   14.981580] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00005020
39.127: [   14.989063] usb usb2: New USB device found, idVendor=3D1d6b, i=
dProduct=3D0001, bcdDevice=3D 4.17
39.127: [   14.997462] usb usb2: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
39.127: [   15.004790] usb usb2: Product: UHCI Host Controller
39.127: [   15.009748] usb usb2: Manufacturer: Linux 4.17.0-rc2+ uhci_hcd=

39.127: [   15.015660] usb usb2: SerialNumber: 0000:00:1d.1
39.130: [   15.022909] hub 2-0:1.0: USB hub found
39.130: [   15.026774] hub 2-0:1.0: 2 ports detected
39.131: [   15.031470] uhci_hcd 0000:00:1d.2: UHCI Host Controller
39.132: [   15.037938] uhci_hcd 0000:00:1d.2: new USB bus registered, ass=
igned bus number 3
39.132: [   15.045474] uhci_hcd 0000:00:1d.2: detected 2 ports
39.133: [   15.051159] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005040
39.133: [   15.057132] usb usb3: New USB device found, idVendor=3D1d6b, i=
dProduct=3D0001, bcdDevice=3D 4.17
39.133: [   15.065499] usb usb3: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
39.133: [   15.072814] usb usb3: Product: UHCI Host Controller
39.133: [   15.077768] usb usb3: Manufacturer: Linux 4.17.0-rc2+ uhci_hcd=

39.134: [   15.083680] usb usb3: SerialNumber: 0000:00:1d.2
39.135: [   15.089764] hub 3-0:1.0: USB hub found
39.135: [   15.093633] hub 3-0:1.0: 2 ports detected
39.136: [   15.098337] uhci_hcd 0000:00:1d.3: UHCI Host Controller
39.136: [   15.103668] uhci_hcd 0000:00:1d.3: new USB bus registered, ass=
igned bus number 4
39.137: [   15.112389] uhci_hcd 0000:00:1d.3: detected 2 ports
39.138: [   15.117430] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00005060
39.138: [   15.123405] usb usb4: New USB device found, idVendor=3D1d6b, i=
dProduct=3D0001, bcdDevice=3D 4.17
39.138: [   15.131797] usb usb4: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
39.138: [   15.139133] usb usb4: Product: UHCI Host Controller
39.138: [   15.144092] usb usb4: Manufacturer: Linux 4.17.0-rc2+ uhci_hcd=

39.138: [   15.150001] usb usb4: SerialNumber: 0000:00:1d.3
39.139: [   15.155218] hub 4-0:1.0: USB hub found
39.139: [   15.159065] hub 4-0:1.0: 2 ports detected
39.147: [   15.170918] ACPI: Battery Slot [BAT0] (battery absent)
39.148: [   15.176954] ACPI: Battery Slot [BAT1] (battery absent)
39.156: [   15.190126] Non-volatile memory driver v1.3
39.187: [   15.225157] ehci-pci: EHCI PCI platform driver
39.187: [   15.230155] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k=

39.187: [   15.236099] e1000e: Copyright(c) 1999 - 2015 Intel Corporation=
=2E
39.237: [   15.291442] e1000e 0000:01:00.0: Interrupt Throttling Rate (in=
ts/sec) set to dynamic conservative mode
39.266: [   15.330001] intel_rng: FWH not detected
39.306: [   15.373200] thinkpad_acpi: ThinkPad ACPI Extras v0.26
39.306: [   15.378343] thinkpad_acpi: http://ibm-acpi.sf.net/
39.306: [   15.383213] thinkpad_acpi: ThinkPad BIOS CBET4000 TIMELESS, EC=
 7JHT12WW-3.4
39.306: [   15.390250] thinkpad_acpi: Lenovo ThinkPad X60 Tablet, model 6=
36338U
39.320: [   15.410537] thinkpad_acpi: radio switch found; radios are disa=
bled
39.337: [   15.433850] sdhci: Secure Digital Host Controller Interface dr=
iver
39.337: [   15.440126] sdhci: Copyright(c) Pierre Ossman
39.352: [   15.459622] yenta_cardbus 0000:05:00.0: CardBus bridge found [=
0000:0000]
39.358: [   15.472509] cfg80211: Loading compiled-in X.509 certificates f=
or regulatory database
39.359: [   15.480887] ehci-pci 0000:00:1d.7: EHCI Host Controller
39.390: [   15.516719] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47a=
ef9cea7'
39.401: [   15.534257] e1000e 0000:01:00.0 eth0: (PCI Express:2.5GT/s:Wid=
th x1) 00:16:d3:b8:e3:49
39.401: [   15.542277] e1000e 0000:01:00.0 eth0: Intel(R) PRO/1000 Networ=
k Connection
39.401: [   15.549400] e1000e 0000:01:00.0 eth0: MAC: 2, PHY: 2, PBA No: =
005302-003
39.404: [   15.559535] ehci-pci 0000:00:1d.7: new USB bus registered, ass=
igned bus number 5
39.406: [   15.568315] ehci-pci 0000:00:1d.7: debug port 1
39.413: [   15.579462] thinkpad_acpi: Tablet mode switch found (type: MHK=
G), currently in laptop mode
39.420: [   15.594721] thinkpad_acpi: This ThinkPad has standard ACPI bac=
klight brightness control, supported by the ACPI video driver
39.420: [   15.595910] platform regulatory.0: Direct firmware load for re=
gulatory.db failed with error -2
39.420: [   15.605979] thinkpad_acpi: Disabling thinkpad-acpi brightness =
events by default...
39.420: [   15.614673] cfg80211: failed to load regulatory.db
39.420: [   15.622507] ehci-pci 0000:00:1d.7: irq 19, io mem 0xe4444000
39.421: [   15.634267] yenta_cardbus 0000:05:00.0: ISA IRQ mask 0x0ca8, P=
CI irq 16
39.421: [   15.640978] yenta_cardbus 0000:05:00.0: Socket status: 3000000=
6
39.422: [   15.647346] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bri=
dge window: [io  0x2000-0x3fff]
39.426: [   15.657712] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bri=
dge window: [mem 0xe0000000-0xe20fffff]
39.427: [   15.670286] ehci-pci 0000:00:1d.7: USB 2.0 started, EHCI 1.00
39.428: [   15.677015] usb usb5: New USB device found, idVendor=3D1d6b, i=
dProduct=3D0002, bcdDevice=3D 4.17
39.428: [   15.685374] usb usb5: New USB device strings: Mfr=3D3, Product=
=3D2, SerialNumber=3D1
39.428: [   15.692686] usb usb5: Product: EHCI Host Controller
39.428: [   15.697638] usb usb5: Manufacturer: Linux 4.17.0-rc2+ ehci_hcd=

39.429: [   15.703557] usb usb5: SerialNumber: 0000:00:1d.7
39.433: [   15.712543] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe=
0000000-0xe20fffff:
39.434: [   15.721070]  excluding 0xe1ef0000-0xe20fffff
39.434: [   15.725494] yenta_cardbus 0000:05:00.0: pcmcia: parent PCI bri=
dge window: [mem 0xe2100000-0xe40fffff 64bit pref]
39.437: [   15.738683] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe=
2100000-0xe40fffff:
39.439: [   15.747612] hub 5-0:1.0: USB hub found
39.448: [   15.760086] thinkpad_acpi: Standard ACPI backlight interface a=
vailable, not loading native one
39.467: [   15.788085] thinkpad_acpi: Console audio control enabled, mode=
: monitor (read only)
39.582: [   15.910960] battery: new extension: ThinkPad Battery Extension=

39.615: [   15.949486] hub 5-0:1.0: 8 ports detected
39.623: [   15.961916] input: ThinkPad Extra Buttons as /devices/platform=
/thinkpad_acpi/input/input5
39.623: [   15.962232] usb usb1: root hub lost power or was reset
39.624: [   15.971994]  excluding 0xe2100000-0xe40fffff
39.626: [   15.981784] hub 1-0:1.0: USB hub found
39.627: [   15.986723] hub 1-0:1.0: 2 ports detected
39.640: [   16.003718] usb usb2: root hub lost power or was reset
39.641: [   16.009571] hub 2-0:1.0: USB hub found
39.654: [   16.026245] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network =
Connection driver for Linux, in-tree:s
39.654: [   16.035536] iwl3945: Copyright(c) 2003-2011 Intel Corporation
39.654: [   16.041367] iwl3945: hw_scan is disabled
39.654: [   16.045433] hub 2-0:1.0: 2 ports detected
39.654: [   16.049948] usb usb3: root hub lost power or was reset
39.655: [   16.055715] hub 3-0:1.0: USB hub found
39.655: [   16.059613] hub 3-0:1.0: 2 ports detected
39.700: [   16.108110] firewire_ohci 0000:05:00.1: added OHCI v1.10 devic=
e as card 0, 4 IR + 4 IT contexts, quirks 0x11
39.704: [   16.122178] usb usb4: root hub lost power or was reset
39.704: [   16.127784] hub 4-0:1.0: USB hub found
39.710: [   16.136710] hub 4-0:1.0: 2 ports detected
39.710: [   16.137337] i801_smbus 0000:00:1f.3: SMBus using PCI interrupt=

39.715: [   16.151527] iwl3945 0000:02:00.0: Tunable channels: 11 802.11b=
g, 13 802.11a channels
39.715: [   16.158297] sdhci-pci 0000:05:00.2: SDHCI controller found [11=
80:0822] (rev 18)
39.715: [   16.159720] iwl3945 0000:02:00.0: Detected Intel Wireless WiFi=
 Link 3945ABG
39.723: [   16.182268] 1
39.725: [   16.182286] 2
39.734: [   16.196303] snd_hda_intel 0000:00:1b.0: probe_mask set to 0x1 =
for device 17aa:2010
39.735: [   16.197312] input: PC Speaker as /devices/platform/pcspkr/inpu=
t/input7
39.735: [   16.204149] 3
39.735: [   16.210643] 4
39.735: [   16.212308] 5
39.735: [   16.213979] 6
39.735: [   16.215658] 7
39.735: [   16.217366] 8
39.736: [   16.219008] 9
39.736: [   16.222962] leds_ss4200: no LED devices found
39.737: [   16.228287] sdhci-pci 0000:05:00.2: Will use DMA mode even tho=
ugh HW doesn't fully claim to support it.
39.737: [   16.237981] mmc0 bounce up to 128 segments into one, max segme=
nt size 65536 bytes
39.737: [   16.245635] sdhci-pci 0000:05:00.2: Will use DMA mode even tho=
ugh HW doesn't fully claim to support it.
39.744: [   16.261130] sdhci-pci 0000:05:00.2: Will use DMA mode even tho=
ugh HW doesn't fully claim to support it.
39.765: [   16.291952] snd_hda_codec_analog hdaudioC0D0: autoconfig for A=
D1981: line_outs=3D1 (0x5/0x0/0x0/0x0/0x0) type:speaker
39.765: [   16.302509] snd_hda_codec_analog hdaudioC0D0:    speaker_outs=3D=
0 (0x0/0x0/0x0/0x0/0x0)
39.765: [   16.310433] snd_hda_codec_analog hdaudioC0D0:    hp_outs=3D0 (=
0x0/0x0/0x0/0x0/0x0)
39.765: [   16.317630] usb 5-6: new high-speed USB device number 2 using =
ehci-pci
39.766: [   16.317929] snd_hda_codec_analog hdaudioC0D0:    mono: mono_ou=
t=3D0x0
39.766: [   16.330868] snd_hda_codec_analog hdaudioC0D0:    dig-out=3D0xa=
/0x0
39.766: [   16.336979] snd_hda_codec_analog hdaudioC0D0:    inputs:
39.819: [   16.395797] mmc0: SDHCI controller on PCI [0000:05:00.2] using=
 DMA
39.820: [   16.402725] snd_hda_codec_analog hdaudioC0D0:      Mic=3D0x8
39.822: [   16.409694] snd_hda_codec_analog hdaudioC0D0:      CD=3D0x19
39.884: [   16.477682] input: HDA Digital PCBeep as /devices/pci0000:00/0=
000:00:1b.0/sound/card0/input8
39.918: [   16.520379] usb 5-6: New USB device found, idVendor=3D17ef, id=
Product=3D1000, bcdDevice=3D 0.01
39.918: [   16.528692] usb 5-6: New USB device strings: Mfr=3D0, Product=3D=
0, SerialNumber=3D0
39.931: [   16.548492] intel_powerclamp: No package C-state available
39.966: [   16.589286] hub 5-6:1.0: USB hub found
39.978: [   16.604065] hub 5-6:1.0: 4 ports detected
40.012: [   16.642155] firewire_core 0000:05:00.1: created device fw0: GU=
ID 0000000000000000, S400
40.216: [   16.854773] psmouse serio1: trackpoint: IBM TrackPoint firmwar=
e: 0x0e, buttons: 3/3
40.244: [   16.890458] e1000e 0000:01:00.0 eth8: renamed from eth0
40.265: [   16.916120] input: TPPS/2 IBM TrackPoint as /devices/platform/=
i8042/serio1/input/input6
40.290: [   16.949526] EXT4-fs (sda1): mounted filesystem with ordered da=
ta mode. Opts: discard
40.354: [   17.021025] iTCO_vendor_support: vendor-support=3D0
40.422: [   17.093920] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
40.488: [   17.164974] IPv6: ADDRCONF(NETDEV_UP): eth8: link is not ready=

40.577: [   17.260465] iwl3945 0000:02:00.0 wlan4: renamed from wlan0
40.605: [   17.293128] mousedev: PS/2 mouse device common for all mice
40.632: [   17.325763] iTCO_wdt: Found a ICH7-M or ICH7-U TCO device (Ver=
sion=3D2, TCOBASE=3D0x0560)
40.650: [   17.352170] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayou=
t=3D0)
42.819: [   19.526426] serio: Serial port ttyS0
42.987:=20
43.000: Debian GNU/Linux 9 gm-debian ttyS1
43.000:=20
43.013: gm-debian login:=20

=3D=3D=3D=3D=3D=3D=3D Mon Apr 23 23:25:05 2018 (adjust=3D86.8us)
00.000: [   80.520289] systemd-journald[261]: File /var/log/journal/3606b=
1ddb0854918b8e3d24578588f9c/user-1000.journal corrupted or uncleanly shut=
 down, renaming and replacing.
09.566: [   90.101235] PM: suspend entry (deep)
09.709: [   90.104903] PM: Syncing filesystems ... done.
09.716: [   90.258131] Freezing user space processes ... (elapsed 0.001 s=
econds) done.
09.716: [   90.266501] OOM killer disabled.
09.718: [   90.269800] Freezing remaining freezable tasks ... (elapsed 0.=
001 seconds) done.
09.718: [   90.278769] calling  input6+ @ 603, parent: serio1
09.718: [   90.283639] call input6+ returned 0 after 2 usecs
09.718: [   90.288425] calling  coretemp.0+ @ 603, parent: platform
09.718: [   90.288465] calling  5-6+ @ 120, parent: usb5
09.719: [   90.293813] call coretemp.0+ returned 0 after 1 usecs
09.719: [   90.293829] calling  input8+ @ 603, parent: card0
09.719: [   90.308141] call input8+ returned 0 after 1 usecs
09.719: [   90.312912] calling  rfkill0+ @ 603, parent: phy0
09.719: [   90.317683] call rfkill0+ returned 0 after 1 usecs
09.719: [   90.322540] calling  phy0-led+ @ 603, parent: 0000:02:00.0
09.719: [   90.322562] calling  phy0+ @ 119, parent: 0000:02:00.0
09.719: [   90.328110] call phy0-led+ returned 0 after 2 usecs
09.719: [   90.328134] calling  mmc0::+ @ 603, parent: 0000:05:00.2
09.719: [   90.333338] call phy0+ returned 0 after 6 usecs
09.719: [   90.338276] call mmc0::+ returned 0 after 1 usecs
09.719: [   90.353020] calling  input7+ @ 603, parent: pcspkr
09.720: [   90.353036] calling  hdaudioC0D0+ @ 119, parent: 0000:00:1b.0
09.720: [   90.357877] call input7+ returned 0 after 1 usecs
09.720: [   90.357881] calling  gpio_ich.1.auto+ @ 603, parent: 0000:00:1=
f.0
09.720: [   90.374639] call gpio_ich.1.auto+ returned 0 after 1 usecs
09.720: [   90.380193] calling  iTCO_wdt.0.auto+ @ 603, parent: 0000:00:1=
f.0
09.720: [   90.386374] call iTCO_wdt.0.auto+ returned 0 after 1 usecs
09.720: [   90.392115] calling  input5+ @ 603, parent: thinkpad_acpi
09.720: [   90.397617] call input5+ returned 0 after 1 usecs
09.721: [   90.402470] calling  tpacpi::thinkvantage+ @ 603, parent: thin=
kpad_acpi
09.721: [   90.404060] call 5-6+ returned 0 after 103336 usecs
09.721: [   90.409178] call tpacpi::thinkvantage+ returned 0 after 1 usec=
s
09.721: [   90.409184] calling  tpacpi::standby+ @ 603, parent: thinkpad_=
acpi
09.721: [   90.414143] calling  usb5+ @ 118, parent: 0000:00:1d.7
09.721: [   90.415109] call usb5+ returned 0 after 939 usecs
09.721: [   90.420180] call tpacpi::standby+ returned 0 after 1 usecs
09.721: [   90.441994] calling  tpacpi::power+ @ 603, parent: thinkpad_ac=
pi
09.721: [   90.448078] call tpacpi::power+ returned 0 after 1 usecs
09.721: [   90.453470] calling  regulatory.0+ @ 603, parent: platform
09.722: [   90.459033] call regulatory.0+ returned 0 after 1 usecs
09.722: [   90.464336] calling  thinkpad_hwmon+ @ 603, parent: platform
09.722: [   90.470074] call thinkpad_hwmon+ returned 0 after 1 usecs
09.722: [   90.475550] calling  thinkpad_acpi+ @ 603, parent: platform
09.722: [   90.481432] call thinkpad_acpi+ returned 0 after 226 usecs
09.722: [   90.487018] calling  input4+ @ 603, parent: LNXPWRBN:00
09.722: [   90.487054] calling  usb3+ @ 6, parent: 0000:00:1d.2
09.722: [   90.492337] call input4+ returned 0 after 1 usecs
09.723: [   90.497446] calling  usb4+ @ 120, parent: 0000:00:1d.3
09.723: [   90.502175] calling  input3+ @ 603, parent: PNP0C0D:00
09.723: [   90.507387] calling  usb2+ @ 118, parent: 0000:00:1d.1
09.723: [   90.512603] call input3+ returned 0 after 1 usecs
09.723: [   90.512608] calling  input2+ @ 603, parent: PNP0C0E:00
09.723: [   90.524034] calling  usb1+ @ 121, parent: 0000:00:1d.0
09.723: [   90.527845] call input2+ returned 0 after 3 usecs
09.723: [   90.533049] call hdaudioC0D0+ returned 0 after 165392 usecs
09.723: [   90.537897] calling  microcode+ @ 603, parent: platform
09.723: [   90.544186] calling  0:0:0:0+ @ 119, parent: target0:0:0
09.724: [   90.548795] call microcode+ returned 0 after 1 usecs
09.724: [   90.554196] call 0:0:0:0+ returned 0 after 3 usecs
09.724: [   90.559234] calling  input0::scrolllock+ @ 603, parent: input0=

09.724: [   90.564112] calling  target0:0:0+ @ 619, parent: host0
09.724: [   90.570011] call input0::scrolllock+ returned 0 after 1 usecs
09.724: [   90.570014] calling  input0::capslock+ @ 603, parent: input0
09.724: [   90.570019] call input0::capslock+ returned 0 after 1 usecs
09.724: [   90.575234] call target0:0:0+ returned 0 after 1 usecs
09.724: [   90.575461] call usb1+ returned 0 after 41427 usecs
09.725: [   90.581094] calling  input0::numlock+ @ 603, parent: input0
09.725: [   90.581099] call input0::numlock+ returned 0 after 1 usecs
09.725: [   90.581102] calling  input0+ @ 603, parent: serio0
09.725: [   90.581107] call input0+ returned 0 after 2 usecs
09.725: [   90.581110] calling  memconsole+ @ 603, parent: platform
09.725: [   90.581115] call memconsole+ returned 0 after 2 usecs
09.725: [   90.581119] calling  rtc0+ @ 603, parent: 00:03
09.725: [   90.581123] call rtc0+ returned 0 after 1 usecs
09.725: [   90.581126] calling  serio1+ @ 603, parent: i8042
09.725: [   90.581276] call usb2+ returned 0 after 61972 usecs
09.726: [   90.586925] call usb4+ returned 0 after 77680 usecs
09.726: [   90.592574] call usb3+ returned 0 after 92972 usecs
09.726: [   90.597813] calling  host3+ @ 620, parent: ata4
09.726: [   90.603223] calling  host2+ @ 6, parent: ata3
09.726: [   90.608375] call host3+ returned 0 after 1 usecs
09.726: [   90.608427] calling  host1+ @ 621, parent: ata2
09.726: [   90.613959] call host2+ returned 0 after 1 usecs
09.726: [   90.618833] call host1+ returned 0 after 3 usecs
09.726: [   90.623739] calling  host0+ @ 619, parent: ata1
09.726: [   90.629042] calling  ata4+ @ 120, parent: 0000:00:1f.2
09.726: [   90.634143] call host0+ returned 0 after 1 usecs
09.727: [   90.638761] calling  ata3+ @ 121, parent: 0000:00:1f.2
09.727: [   90.643381] call serio1+ returned 0 after 60791 usecs
09.727: [   90.648157] calling  ata2+ @ 620, parent: 0000:00:1f.2
09.727: [   90.653127] calling  ata1+ @ 118, parent: 0000:00:1f.2
09.727: [   90.658075] call ata4+ returned 0 after 18874 usecs
09.727: [   90.663051] calling  serio0+ @ 603, parent: i8042
09.727: [   90.667678] call ata3+ returned 0 after 19076 usecs
09.727: [   90.672081] call ata1+ returned 0 after 8846 usecs
09.727: [   90.672121] call ata2+ returned 0 after 13725 usecs
09.727: [   90.676808] call serio0+ returned 0 after 4622 usecs
09.727: [   90.755588] calling  i8042+ @ 603, parent: platform
09.730: [   90.762957] call i8042+ returned 0 after 2352 usecs
09.730: [   90.767923] calling  serial8250+ @ 603, parent: platform
09.730: [   90.773313] call serial8250+ returned 0 after 2 usecs
09.730: [   90.778463] calling  alarmtimer+ @ 603, parent: platform
09.730: [   90.783862] call alarmtimer+ returned 0 after 2 usecs
09.731: [   90.788993] calling  platform-framebuffer.0+ @ 603, parent: pl=
atform
09.731: [   90.795426] call platform-framebuffer.0+ returned 0 after 1 us=
ecs
09.731: [   90.801599] calling  pcspkr+ @ 603, parent: platform
09.731: [   90.806648] call pcspkr+ returned 0 after 8 usecs
09.731: [   90.811502] calling  00:07+ @ 603, parent: pnp0
09.731: [   90.816137] call 00:07+ returned 0 after 15 usecs
09.731: [   90.820926] calling  00:06+ @ 603, parent: pnp0
09.731: [   90.825587] call 00:06+ returned 0 after 52 usecs
09.731: [   90.830370] calling  00:05+ @ 603, parent: pnp0
09.732: [   90.834982] call 00:05+ returned 0 after 1 usecs
09.732: [   90.839676] calling  00:04+ @ 603, parent: pnp0
09.732: [   90.844297] call 00:04+ returned 0 after 2 usecs
09.732: [   90.849017] calling  00:03+ @ 603, parent: pnp0
09.732: [   90.853651] call 00:03+ returned 0 after 20 usecs
09.732: [   90.858432] calling  00:02+ @ 603, parent: pnp0
09.732: [   90.863044] call 00:02+ returned 0 after 1 usecs
09.732: [   90.867739] calling  00:01+ @ 603, parent: pnp0
09.732: [   90.872350] call 00:01+ returned 0 after 1 usecs
09.732: [   90.877046] calling  00:00+ @ 603, parent: pnp0
09.733: [   90.881657] call 00:00+ returned 0 after 1 usecs
09.733: [   90.886363] calling  LNXPWRBN:00+ @ 603, parent: LNXSYSTM:00
09.733: [   90.892102] call LNXPWRBN:00+ returned 0 after 1 usecs
09.733: [   90.897317] calling  BOOT0000:00+ @ 603, parent: platform
09.733: [   90.902795] call BOOT0000:00+ returned 0 after 1 usecs
09.733: [   90.908018] calling  PNP0C0B:00+ @ 603, parent: platform
09.733: [   90.913411] call PNP0C0B:00+ returned 0 after 1 usecs
09.733: [   90.918541] calling  PNP0C04:00+ @ 603, parent: 0000:00:1f.0
09.733: [   90.924280] call PNP0C04:00+ returned 0 after 2 usecs
09.733: [   90.929417] calling  INT0800:00+ @ 603, parent: 0000:00:1f.0
09.734: [   90.935155] call INT0800:00+ returned 0 after 1 usecs
09.734: [   90.940290] calling  PNP0C0D:00+ @ 603, parent: PNP0C09:00
09.734: [   90.945858] call PNP0C0D:00+ returned 0 after 1 usecs
09.734: [   90.950989] calling  PNP0C0E:00+ @ 603, parent: PNP0C09:00
09.734: [   90.956553] call PNP0C0E:00+ returned 0 after 1 usecs
09.734: [   90.961682] calling  PNP0C0A:01+ @ 603, parent: PNP0C09:00
09.734: [   90.967257] call PNP0C0A:01+ returned 0 after 1 usecs
09.734: [   90.972395] calling  PNP0C0A:00+ @ 603, parent: PNP0C09:00
09.734: [   90.977958] call PNP0C0A:00+ returned 0 after 1 usecs
09.734: [   90.983089] calling  ACPI0003:00+ @ 603, parent: PNP0C09:00
09.735: [   90.988740] call ACPI0003:00+ returned 0 after 1 usecs
09.735: [   90.993956] calling  IBM0068:00+ @ 603, parent: PNP0C09:00
09.735: [   90.999524] call IBM0068:00+ returned 0 after 2 usecs
09.735: [   91.004661] calling  PNP0C09:00+ @ 603, parent: 0000:00:1f.0
09.735: [   91.010397] call PNP0C09:00+ returned 0 after 1 usecs
09.735: [   91.015559] calling  0000:05:00.2+ @ 121, parent: 0000:00:1e.0=

09.735: [   91.015564] calling  LNXTHERM:01+ @ 603, parent: LNXSYBUS:01
09.735: [   91.021547] call 0000:05:00.2+ returned 0 after 69 usecs
09.735: [   91.027223] call LNXTHERM:01+ returned 0 after 3 usecs
09.735: [   91.027229] calling  LNXTHERM:00+ @ 603, parent: LNXSYBUS:01
09.736: [   91.032636] calling  0000:05:00.0+ @ 120, parent: 0000:00:1e.0=

09.736: [   91.037838] call LNXTHERM:00+ returned 0 after 1 usecs
09.736: [   91.043575] call 0000:05:00.0+ returned 0 after 2 usecs
09.736: [   91.049487] calling  dock.0+ @ 603, parent: platform
09.736: [   91.049491] call dock.0+ returned 0 after 1 usecs
09.736: [   91.054714] calling  0000:02:00.0+ @ 621, parent: 0000:00:1c.1=

09.736: [   91.060042] calling  PNP0C0D:00+ @ 603, parent: PNP0C09:00
09.736: [   91.065095] call 0000:02:00.0+ returned 0 after 38 usecs
09.736: [   91.069881] call PNP0C0D:00+ returned 0 after 1 usecs
09.736: [   91.075779] calling  0000:01:00.0+ @ 621, parent: 0000:00:1c.0=

09.737: [   91.075874] calling  0000:00:1f.2+ @ 120, parent: pci0000:00
09.737: [   91.081430] calling  0000:00:1f.1+ @ 619, parent: pci0000:00
09.737: [   91.086831] call 0000:00:1f.2+ returned 0 after 6 usecs
09.737: [   91.091951] call 0000:00:1f.1+ returned 0 after 1 usecs
09.737: [   91.097867] calling  0000:00:1f.0+ @ 6, parent: pci0000:00
09.737: [   91.103606] calling  0000:05:00.1+ @ 620, parent: 0000:00:1e.0=

09.737: [   91.109343] call 0000:00:1f.0+ returned 0 after 1 usecs
09.737: [   91.114662] calling  0000:00:1d.7+ @ 619, parent: pci0000:00
09.738: [   91.119953] calling  PNP0C0E:00+ @ 603, parent: PNP0C09:00
09.738: [   91.125594] call 0000:00:1d.7+ returned 0 after 73 usecs
09.738: [   91.131449] call PNP0C0E:00+ returned 0 after 1 usecs
09.738: [   91.131460] calling  0000:00:1d.3+ @ 118, parent: pci0000:00
09.738: [   91.136778] calling  0000:00:1d.2+ @ 619, parent: pci0000:00
09.738: [   91.142849] e1000e 0000:01:00.0: Disabling ASPM L0s L1
09.738: [   91.148281] call 0000:05:00.1+ returned 0 after 32845 usecs
09.738: [   91.153659] calling  0000:00:1d.1+ @ 623, parent: pci0000:00
09.738: [   91.158796] calling  0000:00:1d.0+ @ 622, parent: pci0000:00
09.739: [   91.164545] call 0000:00:1d.1+ returned 0 after 26 usecs
09.739: [   91.170281] calling  0000:00:1e.0+ @ 121, parent: pci0000:00
09.739: [   91.175497] call 0000:00:1d.3+ returned 0 after 32224 usecs
09.739: [   91.181143] call 0000:00:1e.0+ returned 0 after 1 usecs
09.739: [   91.189587] calling  PNP0C09:00+ @ 603, parent: device:22
09.739: [   91.192749] call 0000:00:1d.2+ returned 0 after 43445 usecs
09.739: [   91.198113] call PNP0C09:00+ returned 0 after 2 usecs
09.739: [   91.198133] calling  0000:00:1c.3+ @ 119, parent: pci0000:00
09.739: [   91.203865] calling  0000:00:1c.2+ @ 620, parent: pci0000:00
09.739: [   91.209585] calling  0000:00:1c.1+ @ 624, parent: pci0000:00
09.740: [   91.214839] calling  0000:00:1b.0+ @ 120, parent: pci0000:00
09.740: [   91.220483] call 0000:00:1c.3+ returned 0 after 10714 usecs
09.740: [   91.226029] call 0000:00:1d.0+ returned 0 after 54450 usecs
09.740: [   91.231119] calling  0000:00:02.1+ @ 623, parent: pci0000:00
09.740: [   91.236867] calling  0000:00:02.0+ @ 619, parent: pci0000:00
09.740: [   91.242587] call 0000:00:02.1+ returned 0 after 1 usecs
09.740: [   91.242603] calling  0000:00:00.0+ @ 625, parent: pci0000:00
09.741: [   91.248329] call 0000:00:02.0+ returned 0 after 1 usecs
09.741: [   91.254064] call 0000:00:00.0+ returned 0 after 1 usecs
09.741: [   91.259743] call 0000:00:1c.2+ returned 0 after 43860 usecs
09.741: [   91.269634] call 0000:00:1c.1+ returned 0 after 48171 usecs
09.741: [   91.271406] call 0000:00:1b.0+ returned 0 after 44373 usecs
09.741: [   91.288462] e1000e: EEE TX LPI TIMER: 00000000
09.764: [   91.343081] call 0000:01:00.0+ returned 0 after 261033 usecs
09.764: [   91.348849] calling  0000:00:1c.0+ @ 6, parent: pci0000:00
09.766: [   91.354427] call 0000:00:1c.0+ returned 0 after 3 usecs
09.767: [   91.362262] calling  BOOT0000:00+ @ 603, parent: platform
09.767: [   91.367753] call BOOT0000:00+ returned 0 after 2 usecs
09.767: [   91.372978] calling  PNP0C0B:00+ @ 603, parent: platform
09.767: [   91.378395] call PNP0C0B:00+ returned 0 after 8 usecs
09.767: [   91.383574] calling  0000:05:00.1+ @ 118, parent: 0000:00:1e.0=

09.767: [   91.383691] calling  0000:05:00.0+ @ 621, parent: 0000:00:1e.0=

09.767: [   91.389493] call 0000:05:00.1+ returned 0 after 1 usecs
09.768: [   91.395405] call 0000:05:00.0+ returned 0 after 1 usecs
09.768: [   91.395419] calling  0000:02:00.0+ @ 120, parent: 0000:00:1c.1=

09.768: [   91.400717] calling  0000:05:00.2+ @ 6, parent: 0000:00:1e.0
09.768: [   91.406014] call 0000:02:00.0+ returned 0 after 1 usecs
09.768: [   91.406025] calling  0000:01:00.0+ @ 627, parent: 0000:00:1c.0=

09.768: [   91.411928] call 0000:05:00.2+ returned 0 after 1 usecs
09.768: [   91.417664] call 0000:01:00.0+ returned 0 after 1 usecs
09.768: [   91.422972] calling  0000:00:1f.2+ @ 118, parent: pci0000:00
09.768: [   91.428883] calling  0000:00:1f.1+ @ 626, parent: pci0000:00
09.768: [   91.434182] call 0000:00:1f.2+ returned 0 after 1 usecs
09.769: [   91.439485] call 0000:00:1f.1+ returned 0 after 1 usecs
09.769: [   91.445230] calling  0000:00:1f.0+ @ 620, parent: pci0000:00
09.769: [   91.450967] calling  0000:00:1e.0+ @ 120, parent: pci0000:00
09.769: [   91.456267] call 0000:00:1f.0+ returned 0 after 1 usecs
09.769: [   91.461568] call 0000:00:1e.0+ returned 0 after 1 usecs
09.769: [   91.467316] calling  0000:00:1d.7+ @ 619, parent: pci0000:00
09.769: [   91.473051] calling  0000:00:1d.3+ @ 621, parent: pci0000:00
09.769: [   91.478350] call 0000:00:1d.7+ returned 0 after 1 usecs
09.769: [   91.483652] call 0000:00:1d.3+ returned 0 after 1 usecs
09.769: [   91.489402] calling  0000:00:1d.2+ @ 121, parent: pci0000:00
09.769: [   91.495131] calling  0000:00:1d.1+ @ 626, parent: pci0000:00
09.770: [   91.500433] call 0000:00:1d.2+ returned 0 after 2 usecs
09.770: [   91.505734] call 0000:00:1d.1+ returned 0 after 1 usecs
09.770: [   91.505747] calling  0000:00:1d.0+ @ 627, parent: pci0000:00
09.770: [   91.511485] calling  0000:00:1c.3+ @ 622, parent: pci0000:00
09.770: [   91.517207] call 0000:00:1d.0+ returned 0 after 1 usecs
09.770: [   91.517218] calling  0000:00:1c.2+ @ 120, parent: pci0000:00
09.770: [   91.522516] call 0000:00:1c.3+ returned 0 after 1 usecs
09.770: [   91.527819] call 0000:00:1c.2+ returned 0 after 1 usecs
09.770: [   91.533567] calling  0000:00:1c.1+ @ 625, parent: pci0000:00
09.770: [   91.539299] calling  0000:00:1c.0+ @ 626, parent: pci0000:00
09.771: [   91.544598] call 0000:00:1c.1+ returned 0 after 1 usecs
09.771: [   91.544613] calling  0000:00:1b.0+ @ 625, parent: pci0000:00
09.771: [   91.550343] call 0000:00:1c.0+ returned 0 after 1 usecs
09.771: [   91.550355] calling  0000:00:02.1+ @ 624, parent: pci0000:00
09.771: [   91.555648] call 0000:00:1b.0+ returned 0 after 1 usecs
09.771: [   91.560951] call 0000:00:02.1+ returned 0 after 1 usecs
09.771: [   91.566695] calling  0000:00:02.0+ @ 623, parent: pci0000:00
09.771: [   91.572431] calling  0000:00:00.0+ @ 621, parent: pci0000:00
09.771: [   91.577731] call 0000:00:02.0+ returned 0 after 1 usecs
09.771: [   91.583469] call 0000:00:00.0+ returned 0 after 1 usecs
09.772: [   91.627387] calling  iTCO_wdt.0.auto+ @ 603, parent: 0000:00:1=
f.0
09.772: [   91.633564] call iTCO_wdt.0.auto+ returned 0 after 1 usecs
09.772: [   91.639152] calling  pcmcia_socket0+ @ 603, parent: 0000:05:00=
=2E0
09.772: [   91.645266] call pcmcia_socket0+ returned 0 after 23 usecs
09.772: [   91.651026] calling  BOOT0000:00+ @ 603, parent: platform
09.772: [   91.656508] call BOOT0000:00+ returned 0 after 1 usecs
09.773: [   91.661723] calling  PNP0C0B:00+ @ 603, parent: platform
09.773: [   91.667116] call PNP0C0B:00+ returned 0 after 1 usecs
09.773: [   91.672273] calling  0000:05:00.1+ @ 624, parent: 0000:00:1e.0=

09.773: [   91.672307] calling  PNP0C09:00+ @ 603, parent: device:22
09.773: [   91.678194] call 0000:05:00.1+ returned 0 after 1 usecs
09.773: [   91.683668] ACPI: EC: interrupt blocked
09.773: [   91.688975] calling  0000:05:00.0+ @ 119, parent: 0000:00:1e.0=

09.773: [   91.692877] call PNP0C09:00+ returned 0 after 8992 usecs
09.773: [   91.698855] call 0000:05:00.0+ returned 0 after 70 usecs
09.773: [   91.704206] calling  0000:02:00.0+ @ 6, parent: 0000:00:1c.1
09.774: [   91.709589] calling  0000:05:00.2+ @ 621, parent: 0000:00:1e.0=

09.774: [   91.709655] calling  0000:01:00.0+ @ 624, parent: 0000:00:1c.0=

09.774: [   91.715553] calling  0000:00:1f.2+ @ 120, parent: pci0000:00
09.774: [   91.721523] calling  0000:00:1f.1+ @ 119, parent: pci0000:00
09.774: [   91.727452] calling  0000:00:1f.0+ @ 626, parent: pci0000:00
09.774: [   91.733185] call 0000:00:1f.1+ returned 0 after 43 usecs
09.774: [   91.738959] call 0000:00:1f.0+ returned 0 after 56 usecs
09.774: [   91.744665] call 0000:05:00.2+ returned 0 after 34249 usecs
09.775: [   91.750067] calling  0000:00:1d.7+ @ 625, parent: pci0000:00
09.775: [   91.755463] calling  0000:00:1d.3+ @ 621, parent: pci0000:00
09.775: [   91.761166] calling  0000:00:1d.2+ @ 623, parent: pci0000:00
09.775: [   91.766901] calling  0000:00:1d.1+ @ 119, parent: pci0000:00
09.775: [   91.772651] calling  0000:00:1d.0+ @ 118, parent: pci0000:00
09.775: [   91.778465] call 0000:01:00.0+ returned 0 after 55719 usecs
09.775: [   91.784223] calling  0000:00:1c.3+ @ 620, parent: pci0000:00
09.775: [   91.789995] call 0000:00:1d.3+ returned 0 after 22599 usecs
09.775: [   91.795671] call 0000:00:1c.3+ returned 0 after 82 usecs
09.776: [   91.801358] calling  0000:00:1c.2+ @ 624, parent: pci0000:00
09.776: [   91.807018] calling  0000:00:1c.0+ @ 121, parent: pci0000:00
09.776: [   91.812471] call 0000:00:1c.2+ returned 0 after 75 usecs
09.776: [   91.818241] call 0000:00:1c.0+ returned 0 after 80 usecs
09.776: [   91.823947] calling  0000:00:1b.0+ @ 622, parent: pci0000:00
09.776: [   91.829352] calling  0000:00:1e.0+ @ 627, parent: pci0000:00
09.776: [   91.834897] call 0000:00:1d.1+ returned 0 after 55218 usecs
09.776: [   91.840518] call 0000:00:1e.0+ returned 0 after 48 usecs
09.776: [   91.846239] calling  0000:00:02.1+ @ 621, parent: pci0000:00
09.777: [   91.851899] calling  0000:00:02.0+ @ 628, parent: pci0000:00
09.777: [   91.857292] call 0000:00:02.1+ returned 0 after 32 usecs
09.777: [   91.863033] call 0000:00:02.0+ returned 0 after 33 usecs
09.777: [   91.868753] call 0000:00:1b.0+ returned 0 after 33252 usecs
09.777: [   91.874237] calling  0000:00:00.0+ @ 629, parent: pci0000:00
09.777: [   91.879614] call 0000:02:00.0+ returned 0 after 160411 usecs
09.777: [   91.885261] call 0000:00:00.0+ returned 0 after 16 usecs
09.777: [   91.891006] call 0000:00:1f.2+ returned 0 after 159782 usecs
09.777: [   91.896739] calling  0000:00:1c.1+ @ 619, parent: pci0000:00
09.778: [   91.902192] call 0000:00:1d.2+ returned 0 after 126552 usecs
09.778: [   91.907942] call 0000:00:1c.1+ returned 0 after 75 usecs
09.778: [   91.913679] call 0000:00:1d.0+ returned 0 after 126471 usecs
09.778: [   91.924787] call 0000:00:1d.7+ returned 0 after 159845 usecs
09.778: [   91.936557] ACPI: Preparing to enter system sleep state S3
09.792: [   91.955621] ACPI: EC: event blocked
09.792: [   91.956007] ACPI: EC: EC stopped
09.792: [   91.962486] PM: Saving platform NVS memory
09.792: [   91.966663] Disabling non-boot CPUs ...
09.806: [   91.984416] IRQ 1: no longer affine to CPU1
09.806: [   91.988009] IRQ 9: no longer affine to CPU1
09.806: [   91.988009] IRQ 12: no longer affine to CPU1
09.806: [   91.988009] IRQ 19: no longer affine to CPU1
09.806: [   91.988009] IRQ 28: no longer affine to CPU1
09.807: [   92.006686] smpboot: CPU 1 is now offline
09.808: [   92.011299] PM: Calling kvm_suspend+0x0/0x30 [kvm]
09.808: [   92.014777] PM: Calling mce_syscore_suspend+0x0/0x30
09.808: [   92.014777] PM: Calling ledtrig_cpu_syscore_suspend+0x0/0x20
09.808: [   92.014777] PM: Calling timekeeping_suspend+0x0/0x500
09.808: [   92.014777] PM: Calling irq_gc_suspend+0x0/0x90
09.808: [   92.014777] PM: Calling save_ioapic_entries+0x0/0x260
09.808: [   92.014777] PM: Calling i8259A_suspend+0x0/0x30
09.809: [   92.014777] PM: Calling fw_suspend+0x0/0x20
09.809: [   92.014777] PM: Calling acpi_save_bm_rld+0x0/0x20
09.809: [   92.014777] PM: Calling lapic_suspend+0x0/0x310
17.454: <00>
17.655:=20
17.655:=20
17.655: coreboot-TIMELESS Thu Jan  1 00:00:00 UTC 1970 romstage starting.=
=2E.
17.655: Dock is present
17.655:=20
17.655: Mobile Intel(R) 82945GM/GME Express Chipset
17.656: (G)MCH capable of up to FSB 800 MHz
17.656: (G)MCH capable of up to DDR2-667
17.656: Setting up static southbridge registers... done.
17.656: Disabling Watchdog reboot... done.
17.656: Setting up static northbridge registers...CBFS: 'Master Header Lo=
cator' located CBFS at [200:1fffc0)
17.658: CBFS: Locating 'cmos_layout.bin'
17.658: CBFS: Found @ offset 39100 size 6ac
17.659:  done.
17.659: Waiting for MCHBAR to come up...ok
17.659: PM1_CNT: 00001400
17.659: Resume from S3 detected.
17.659: SMBus controller enabled.
17.659: Setting up RAM controller.
17.660: This mainboard supports Dual Channel Operation.
17.719: Reading SPD using i2c block operation.
17.720: DDR II Channel 0 Socket 0: x8DDS
17.721: DIMM 0 side 0 =3D 512 MB
17.721: DIMM 0 side 1 =3D 512 MB
17.722: DDR II Channel 0 Socket 1: N/A
17.781: Reading SPD using i2c block operation.
17.781: DDR II Channel 1 Socket 0: x8DDS
17.781: DIMM 2 side 0 =3D 512 MB
17.781: DIMM 2 side 1 =3D 512 MB
17.782: DDR II Channel 1 Socket 1: N/A
17.782: Memory will be driven at 667MT with CAS=3D5 clocks
17.782: tRAS =3D 15 cycles
17.782: tRP  =3D 5 cycles
17.782: tRCD =3D 5 cycles
17.782: tWR  =3D 5 cycles
17.782: tRFC =3D 35 cycles
17.782: Refresh: 7.8us
17.783: Setting Graphics Frequency...
17.783: FSB: 667 MHz Voltage: 1.05V Render: 250MHz Display: 200MHz
17.783: Setting Memory Frequency... CLKCFG =3D 0x00010023, CLKCFG =3D 0x0=
0010043, ok
17.783: Setting mode of operation for memory channels...Dual Channel Inte=
rleaved.
17.784: Programming Clock Crossing...MEM=3D667 FSB=3D667... ok
17.784: Setting RAM size...
17.785: C0DRB =3D 0x20202010
17.785: C1DRB =3D 0x20202010
17.785: TOLUD =3D 0x0080
17.785: Setting row attributes...
17.785: C0DRA =3D 0x0033
17.785: C1DRA =3D 0x0033
17.785: one dimm per channel config..
17.786: Initializing System Memory IO...
17.786: Programming Dual Channel RCOMP
17.786: Table Index: 18
17.786: Programming DLL Timings...
17.786: Enabling System Memory IO...
17.788: RAM initialization finished.
17.788: Setting up Egress Port RCRB
17.788: Loading port arbitration table ...ok
17.788: Wait for VC1 negotiation ...ok
17.788: Setting up DMI RCRB
17.788: Wait for VC1 negotiation ...done..
17.789: Internal graphics: enabled
17.789: Waiting for DMI hardware...ok
17.789: Enabling PCI Express x16 Link
17.789: SLOTSTS: 0000
17.789: Disabling PCI Express x16 Link
17.789: Wait for link to enter detect state... ok
17.789: Setting up Root Complex Topology
17.796: MTRR Range: Start=3Dffe00000 End=3D0 (Size 200000)
17.796: MTRR Range: Start=3D0 End=3D1000000 (Size 1000000)
17.796: MTRR Range: Start=3D7f400000 End=3D7f800000 (Size 400000)
17.796: MTRR Range: Start=3D7f000000 End=3D7f400000 (Size 400000)
17.801: Jumping to image.
17.802:=20
17.802:=20
17.802: coreboot-TIMELESS Thu Jan  1 00:00:00 UTC 1970 ramstage starting.=
=2E.
17.802: S3 Resume.
17.802: BS: BS_PRE_DEVICE times (us): entry 0 run 0 exit 0
17.802: BS: BS_DEV_INIT_CHIPS times (us): entry 0 run 1 exit 0
17.802: Enumerating buses...
17.802: CPU_CLUSTER: 0 enabled
17.802: DOMAIN: 0000 enabled
17.802: PCI: pci_scan_bus for bus 00
17.802: PCI: 00:00.0 [8086/27a0] enabled
17.802: PCI: 00:02.0 [8086/27a2] enabled
17.802: PCI: 00:02.1 [8086/27a6] enabled
17.802: PCI: 00:1b.0 [8086/27d8] enabled
17.802: PCI: 00:1c.0 [8086/27d0] enabled
17.802: PCI: 00:1c.1 [8086/27d2] enabled
17.802: PCI: 00:1c.2 [8086/27d4] enabled
17.802: PCI: 00:1c.3 [8086/27d6] enabled
17.802: PCI: 00:1d.0 [8086/27c8] enabled
17.802: PCI: 00:1d.1 [8086/27c9] enabled
17.802: PCI: 00:1d.2 [8086/27ca] enabled
17.802: PCI: 00:1d.3 [8086/27cb] enabled
17.802: PCI: 00:1d.7 [8086/27cc] enabled
17.802: PCI: 00:1e.0 [8086/2448] enabled
17.802: PCI: 00:1f.0 [8086/27b9] enabled
17.802: PCI: 00:1f.1 [8086/27df] enabled
17.802: Set SATA mode early
17.802: Set SATA mode early
17.802: PCI: 00:1f.2 [8086/27c5] enabled
17.802: PCI: 00:1f.3 [8086/27da] enabled
17.802: PCI: pci_scan_bus for bus 01
17.802: PCI: 01:00.0 [8086/109a] enabled
17.802: scan_bus: scanning of bus PCI: 00:1c.0 took 5651 usecs
17.802: PCI: pci_scan_bus for bus 02
17.802: PCI: 02:00.0 [8086/4227] enabled
17.802: scan_bus: scanning of bus PCI: 00:1c.1 took 5664 usecs
17.802: PCI: pci_scan_bus for bus 03
17.802: scan_bus: scanning of bus PCI: 00:1c.2 took 2673 usecs
17.802: PCI: pci_scan_bus for bus 04
17.802: scan_bus: scanning of bus PCI: 00:1c.3 took 2671 usecs
17.802: PCI: pci_scan_bus for bus 05
17.802: PCI: 05:00.0 [1180/0476] enabled
17.802: PCI: 05:00.1 [1180/0552] enabled
17.802: PCI: 05:00.2 [1180/0822] enabled
17.802: PCI: pci_scan_bus for bus 06
17.803: scan_bus: scanning of bus PCI: 05:00.0 took 2676 usecs
17.803: scan_bus: scanning of bus PCI: 00:1e.0 took 19178 usecs
17.803: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.803: CBFS: Locating 'cmos_layout.bin'
17.803: CBFS: Found @ offset 39100 size 6ac
17.803: WARNING: No CMOS option 'touchpad'.
17.803: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.803: CBFS: Locating 'cmos_layout.bin'
17.803: CBFS: Found @ offset 39100 size 6ac
17.803: PMH7: ID 03 Revision 10
17.803: PNP: 00ff.1 enabled
17.805: EC Firmware ID 7JHT12WW-3.4, Version 3.01A
17.805: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.805: CBFS: Locating 'cmos_layout.bin'
17.805: CBFS: Found @ offset 39100 size 6ac
17.805: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.805: CBFS: Locating 'cmos_layout.bin'
17.805: CBFS: Found @ offset 39100 size 6ac
17.809: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.809: CBFS: Locating 'cmos_layout.bin'
17.809: CBFS: Found @ offset 39100 size 6ac
17.809: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.809: CBFS: Locating 'cmos_layout.bin'
17.809: CBFS: Found @ offset 39100 size 6ac
17.810: H8: BDC not installed
17.810: H8: WWAN detection not implemented. Assuming WWAN installed
17.810: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.810: CBFS: Locating 'cmos_layout.bin'
17.810: CBFS: Found @ offset 39100 size 6ac
17.810: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.810: CBFS: Locating 'cmos_layout.bin'
17.810: CBFS: Found @ offset 39100 size 6ac
17.810: WARNING: No CMOS option 'fn_ctrl_swap'.
17.811: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.811: CBFS: Locating 'cmos_layout.bin'
17.811: CBFS: Found @ offset 39100 size 6ac
17.811: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.811: CBFS: Locating 'cmos_layout.bin'
17.811: CBFS: Found @ offset 39100 size 6ac
17.812: PNP: 00ff.2 enabled
17.812: PNP: 164e.2 enabled
17.812: PNP: 164e.3 enabled
17.812: PNP: 164e.7 enabled
17.812: PNP: 164e.19 enabled
17.812: PNP: 002e.0 disabled
17.812: PNP: 002e.1 enabled
17.812: PNP: 002e.2 disabled
17.812: PNP: 002e.3 enabled
17.812: PNP: 002e.7 enabled
17.812: PNP: 002e.a disabled
17.812: scan_bus: scanning of bus PCI: 00:1f.0 took 166050 usecs
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:69 enabled
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:54 enabled
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:55 enabled
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:56 enabled
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:57 enabled
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:5c enabled
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:5d enabled
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:5e enabled
17.812: bus: PCI: 00:1f.3[0]->I2C: 01:5f enabled
17.812: scan_bus: scanning of bus PCI: 00:1f.3 took 33207 usecs
17.812: scan_bus: scanning of bus DOMAIN: 0000 took 329698 usecs
17.812: scan_bus: scanning of bus Root Device took 338796 usecs
17.812: done
17.812: BS: BS_DEV_ENUMERATE times (us): entry 0 run 346283 exit 0
17.812: found VGA at PCI: 00:02.0
17.812: Setting up VGA for PCI: 00:02.0
17.812: Setting PCI_BRIDGE_CTL_VGA for bridge DOMAIN: 0000
17.812: Setting PCI_BRIDGE_CTL_VGA for bridge Root Device
17.812: Allocating resources...
17.812: Reading resources...
17.812: Adding PCIe enhanced config space BAR 0xf0000000-0xf4000000.
17.814: PNP: 00ff.1 missing read_resources
17.814: PNP: 00ff.2 missing read_resources
17.814: Done reading resources.
17.814: skipping PNP: 00ff.2@60 fixed resource, size=3D0!
17.814: skipping PNP: 00ff.2@62 fixed resource, size=3D0!
17.814: skipping PNP: 00ff.2@64 fixed resource, size=3D0!
17.814: skipping PNP: 00ff.2@66 fixed resource, size=3D0!
17.814: skipping PNP: 164e.3@29 fixed resource, size=3D0!
17.814: skipping PNP: 164e.3@f0 fixed resource, size=3D0!
17.814: Setting resources...
17.814: pci_tolm: 0xd0000000
17.814: IGD decoded, subtracting 8M UMA
17.814: Available memory: 2088960K (2040M)
17.814: PCI: 00:02.0 10 <- [0x00e4300000 - 0x00e437ffff] size 0x00080000 =
gran 0x13 mem
17.814: PCI: 00:02.0 14 <- [0x00000050b0 - 0x00000050b7] size 0x00000008 =
gran 0x03 io
17.814: PCI: 00:02.0 18 <- [0x00d0000000 - 0x00dfffffff] size 0x10000000 =
gran 0x1c prefmem
17.814: PCI: 00:02.0 1c <- [0x00e4400000 - 0x00e443ffff] size 0x00040000 =
gran 0x12 mem
17.814: PCI: 00:02.1 10 <- [0x00e4380000 - 0x00e43fffff] size 0x00080000 =
gran 0x13 mem
17.814: PCI: 00:1b.0 10 <- [0x00e4440000 - 0x00e4443fff] size 0x00004000 =
gran 0x0e mem64
17.814: PCI: 00:1c.0 1c <- [0x0000004000 - 0x0000004fff] size 0x00001000 =
gran 0x0c bus 01 io
17.814: PCI: 00:1c.0 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 01 prefmem
17.814: PCI: 00:1c.0 20 <- [0x00e4100000 - 0x00e41fffff] size 0x00100000 =
gran 0x14 bus 01 mem
17.814: PCI: 01:00.0 10 <- [0x00e4100000 - 0x00e411ffff] size 0x00020000 =
gran 0x11 mem
17.814: PCI: 01:00.0 18 <- [0x0000004000 - 0x000000401f] size 0x00000020 =
gran 0x05 io
17.814: PCI: 00:1c.1 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 =
gran 0x0c bus 02 io
17.815: PCI: 00:1c.1 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 02 prefmem
17.814: PCI: 00:1c.1 20 <- [0x00e4200000 - 0x00e42fffff] size 0x00100000 =
gran 0x14 bus 02 mem
17.815: PCI: 02:00.0 10 <- [0x00e4200000 - 0x00e4200fff] size 0x00001000 =
gran 0x0c mem
17.815: PCI: 00:1c.2 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 =
gran 0x0c bus 03 io
17.815: PCI: 00:1c.2 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 03 prefmem
17.815: PCI: 00:1c.2 20 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 03 mem
17.815: PCI: 00:1c.3 1c <- [0x000000ffff - 0x000000fffe] size 0x00000000 =
gran 0x0c bus 04 io
17.815: PCI: 00:1c.3 24 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 04 prefmem
17.815: PCI: 00:1c.3 20 <- [0x00efffffff - 0x00effffffe] size 0x00000000 =
gran 0x14 bus 04 mem
17.815: PCI: 00:1d.0 20 <- [0x0000005000 - 0x000000501f] size 0x00000020 =
gran 0x05 io
17.815: PCI: 00:1d.1 20 <- [0x0000005020 - 0x000000503f] size 0x00000020 =
gran 0x05 io
17.815: PCI: 00:1d.2 20 <- [0x0000005040 - 0x000000505f] size 0x00000020 =
gran 0x05 io
17.815: PCI: 00:1d.3 20 <- [0x0000005060 - 0x000000507f] size 0x00000020 =
gran 0x05 io
17.815: PCI: 00:1d.7 10 <- [0x00e4444000 - 0x00e44443ff] size 0x00000400 =
gran 0x0a mem
17.815: PCI: 00:1e.0 1c <- [0x0000002000 - 0x0000003fff] size 0x00002000 =
gran 0x0c bus 05 io
17.815: PCI: 00:1e.0 24 <- [0x00e2100000 - 0x00e40fffff] size 0x02000000 =
gran 0x14 bus 05 prefmem
17.815: PCI: 00:1e.0 20 <- [0x00e0000000 - 0x00e20fffff] size 0x02100000 =
gran 0x14 bus 05 mem
17.815: PCI: 05:00.0 In set resources
17.815: PCI: 05:00.0 10 <- [0x00e2000000 - 0x00e2000fff] size 0x00001000 =
gran 0x0c mem
17.815: PCI: 05:00.0 2c <- [0x0000002000 - 0x0000002fff] size 0x00001000 =
gran 0x02 io
17.815: PCI: 05:00.0 34 <- [0x0000003000 - 0x0000003fff] size 0x00001000 =
gran 0x02 io
17.815: PCI: 05:00.0 1c <- [0x00e2100000 - 0x00e40fffff] size 0x02000000 =
gran 0x0c prefmem
17.815: PCI: 05:00.0 24 <- [0x00e0000000 - 0x00e1ffffff] size 0x02000000 =
gran 0x0c mem
17.815: PCI: 05:00.1 10 <- [0x00e2001000 - 0x00e20017ff] size 0x00000800 =
gran 0x0b mem
17.815: PCI: 05:00.2 10 <- [0x00e2002000 - 0x00e20020ff] size 0x00000100 =
gran 0x08 mem
17.815: PNP: 00ff.1 missing set_resources
17.815: PNP: 00ff.2 missing set_resources
17.815: PNP: 164e.2 60 <- [0x00000002f8 - 0x00000002ff] size 0x00000008 g=
ran 0x03 io
17.815: ERROR: PNP: 164e.2 70 irq size: 0x0000000001 not assigned
17.815: ERROR: PNP: 164e.2 74 drq size: 0x0000000001 not assigned
17.815: ERROR: PNP: 164e.2 75 drq size: 0x0000000001 not assigned
17.815: PNP: 164e.3 60 <- [0x0000000200 - 0x0000000207] size 0x00000008 g=
ran 0x03 io
17.815: PNP: 164e.3 29 <- [0x00000000b0 - 0x00000000af] size 0x00000000 g=
ran 0x00 irq
17.815: PNP: 164e.3 70 <- [0x0000000005 - 0x0000000005] size 0x00000001 g=
ran 0x00 irq
17.815: PNP: 164e.3 f0 <- [0x0000000082 - 0x0000000081] size 0x00000000 g=
ran 0x00 irq
17.815: PNP: 164e.7 60 <- [0x0000001680 - 0x000000168f] size 0x00000010 g=
ran 0x04 io
17.815: ERROR: PNP: 164e.7 70 irq size: 0x0000000001 not assigned
17.815: PNP: 164e.19 60 <- [0x000000164c - 0x000000164d] size 0x00000002 =
gran 0x01 io
17.815: ERROR: PNP: 164e.19 70 irq size: 0x0000000001 not assigned
17.815: PNP: 002e.1 60 <- [0x00000003bc - 0x00000007bb] size 0x00000400 g=
ran 0x0a io
17.815: PNP: 002e.1 70 <- [0x0000000007 - 0x0000000007] size 0x00000001 g=
ran 0x00 irq
17.815: ERROR: PNP: 002e.1 74 drq size: 0x0000000001 not assigned
17.815: PNP: 002e.3 60 <- [0x00000003f8 - 0x00000003ff] size 0x00000008 g=
ran 0x03 io
17.815: PNP: 002e.3 70 <- [0x0000000004 - 0x0000000004] size 0x00000001 g=
ran 0x00 irq
17.815: PNP: 002e.7 60 <- [0x0000001620 - 0x0000001627] size 0x00000008 g=
ran 0x03 io
17.815: ERROR: PNP: 002e.7 70 irq size: 0x0000000001 not assigned
17.815: PCI: 00:1f.1 10 <- [0x00000050b8 - 0x00000050bf] size 0x00000008 =
gran 0x03 io
17.815: PCI: 00:1f.1 14 <- [0x00000050d8 - 0x00000050db] size 0x00000004 =
gran 0x02 io
17.815: PCI: 00:1f.1 18 <- [0x00000050c0 - 0x00000050c7] size 0x00000008 =
gran 0x03 io
17.815: PCI: 00:1f.1 1c <- [0x00000050dc - 0x00000050df] size 0x00000004 =
gran 0x02 io
17.815: PCI: 00:1f.1 20 <- [0x00000050a0 - 0x00000050af] size 0x00000010 =
gran 0x04 io
17.815: PCI: 00:1f.2 10 <- [0x00000050c8 - 0x00000050cf] size 0x00000008 =
gran 0x03 io
17.815: PCI: 00:1f.2 14 <- [0x00000050e0 - 0x00000050e3] size 0x00000004 =
gran 0x02 io
17.815: PCI: 00:1f.2 18 <- [0x00000050d0 - 0x00000050d7] size 0x00000008 =
gran 0x03 io
17.815: PCI: 00:1f.2 1c <- [0x00000050e4 - 0x00000050e7] size 0x00000004 =
gran 0x02 io
17.815: PCI: 00:1f.2 20 <- [0x0000005080 - 0x000000509f] size 0x00000020 =
gran 0x05 io
17.815: PCI: 00:1f.2 24 <- [0x00e4445000 - 0x00e44453ff] size 0x00000400 =
gran 0x0a mem
17.815: Done setting resources.
17.815: Done allocating resources.
17.815: BS: BS_DEV_RESOURCES times (us): entry 0 run 539612 exit 0
17.815: Enabling resources...
17.815: PCI: 00:00.0 subsystem <- 17aa/2017
17.815: PCI: 00:00.0 cmd <- 06
17.815: PCI: 00:02.0 subsystem <- 17aa/201a
17.815: PCI: 00:02.0 cmd <- 03
17.815: PCI: 00:02.1 subsystem <- 17aa/201a
17.815: PCI: 00:02.1 cmd <- 02
17.815: PCI: 00:1b.0 subsystem <- 17aa/2010
17.815: PCI: 00:1b.0 cmd <- 102
17.815: PCI: 00:1c.0 bridge ctrl <- 0003
17.815: PCI: 00:1c.0 subsystem <- 8086/27d0
17.815: PCI: 00:1c.0 cmd <- 107
17.815: PCI: 00:1c.1 bridge ctrl <- 0003
17.815: PCI: 00:1c.1 subsystem <- 8086/27d2
17.815: PCI: 00:1c.1 cmd <- 106
17.815: PCI: 00:1c.2 bridge ctrl <- 0003
17.815: PCI: 00:1c.2 cmd <- 00
17.815: PCI: 00:1c.3 bridge ctrl <- 0003
17.815: PCI: 00:1c.3 cmd <- 00
17.815: PCI: 00:1d.0 subsystem <- 17aa/200a
17.815: PCI: 00:1d.0 cmd <- 01
17.815: PCI: 00:1d.1 subsystem <- 17aa/200a
17.815: PCI: 00:1d.1 cmd <- 01
17.815: PCI: 00:1d.2 subsystem <- 17aa/200a
17.815: PCI: 00:1d.2 cmd <- 01
17.815: PCI: 00:1d.3 subsystem <- 17aa/200a
17.815: PCI: 00:1d.3 cmd <- 01
17.815: PCI: 00:1d.7 subsystem <- 17aa/200b
17.815: PCI: 00:1d.7 cmd <- 102
17.815: PCI: 00:1e.0 bridge ctrl <- 0003
17.815: PCI: 00:1e.0 cmd <- 07
17.816: PCI: 00:1f.0 subsystem <- 17aa/2009
17.816: PCI: 00:1f.0 cmd <- 107
17.816: PCI: 00:1f.1 subsystem <- 17aa/200c
17.816: PCI: 00:1f.1 cmd <- 01
17.816: PCI: 00:1f.2 subsystem <- 17aa/200d
17.816: PCI: 00:1f.2 cmd <- 03
17.816: PCI: 00:1f.3 subsystem <- 17aa/200f
17.816: PCI: 00:1f.3 cmd <- 101
17.816: PCI: 01:00.0 cmd <- 03
17.816: PCI: 02:00.0 cmd <- 02
17.816: PCI: 05:00.0 bridge ctrl <- 0503
17.816: PCI: 05:00.0 cmd <- 03
17.816: PCI: 05:00.1 cmd <- 02
17.816: PCI: 05:00.2 cmd <- 06
17.816: done.
17.816: BS: BS_DEV_ENABLE times (us): entry 0 run 118106 exit 0
17.816: Initializing devices...
17.816: Root Device init ...
17.817: Root Device init finished in 2691 usecs
17.817: CPU_CLUSTER: 0 init ...
17.817: start_eip=3D0x00001000, code_size=3D0x00000031
17.817: Initializing SMM handler...
17.817: SMI_STS: MCSMI PM1=20
17.817: PM1_STS: WAK PWRBTN=20
17.817: GPE0_STS: GPIO15 GPIO14 GPIO13 GPIO12 GPIO11 GPIO10 GPIO7 GPIO6 G=
PIO5 GPIO4 GPIO3 GPIO2 GPIO1 GPIO0=20
17.818: ALT_GP_SMI_STS: GPI15 GPI14 GPI13 GPI12 GPI11 GPI10 GPI7 GPI6 GPI=
5 GPI4 GPI3 GPI2 GPI1 GPI0=20
17.818: TCO_STS:=20
17.818: Initializing CPU #0
17.818: CPU: vendor Intel device 6ec
17.818: CPU: family 06, model 0e, stepping 0c
17.818: Enabling cache
17.818: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.818: CBFS: Locating 'cpu_microcode_blob.bin'
17.818: CBFS: Found @ offset d2c0 size 17000
17.818: microcode: sig=3D0x6ec pf=3D0x20 revision=3D0x0
17.820: microcode: updated to revision 0x54 date=3D2006-05-01
17.820: CPU: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz.
17.820: MTRR: Physical address space:
17.820: 0x0000000000000000 - 0x00000000000a0000 size 0x000a0000 type 6
17.820: 0x00000000000a0000 - 0x00000000000c0000 size 0x00020000 type 0
17.820: 0x00000000000c0000 - 0x000000007f800000 size 0x7f740000 type 6
17.820: 0x000000007f800000 - 0x00000000d0000000 size 0x50800000 type 0
17.820: 0x00000000d0000000 - 0x00000000e0000000 size 0x10000000 type 1
17.820: 0x00000000e0000000 - 0x0000000100000000 size 0x20000000 type 0
17.820: MTRR: Fixed MSR 0x250 0x0606060606060606
17.820: MTRR: Fixed MSR 0x258 0x0606060606060606
17.820: MTRR: Fixed MSR 0x259 0x0000000000000000
17.820: MTRR: Fixed MSR 0x268 0x0606060606060606
17.820: MTRR: Fixed MSR 0x269 0x0606060606060606
17.820: MTRR: Fixed MSR 0x26a 0x0606060606060606
17.820: MTRR: Fixed MSR 0x26b 0x0606060606060606
17.820: MTRR: Fixed MSR 0x26c 0x0606060606060606
17.820: MTRR: Fixed MSR 0x26d 0x0606060606060606
17.820: MTRR: Fixed MSR 0x26e 0x0606060606060606
17.820: MTRR: Fixed MSR 0x26f 0x0606060606060606
17.821: CPU physical address size: 32 bits
17.821: MTRR: default type WB/UC MTRR counts: 5/3.
17.821: MTRR: UC selected as default type.
17.821: MTRR: 0 base 0x0000000000000000 mask 0x0000000080000000 type 6
17.821: MTRR: 1 base 0x000000007f800000 mask 0x00000000ff800000 type 0
17.821: MTRR: 2 base 0x00000000d0000000 mask 0x00000000f0000000 type 1
17.822:=20
17.822: MTRR check
17.822: Fixed MTRRs   : Enabled
17.822: Variable MTRRs: Enabled
17.822:=20
17.822: Setting up local APIC... apic_id: 0x00 done.
17.822: VMX status: enabled, locked
17.822: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.822: CBFS: Locating 'cmos_layout.bin'
17.822: CBFS: Found @ offset 39100 size 6ac
17.823: CPU: 0 2 siblings
17.823: CPU: 0 has sibling 1
17.823: CPU #0 initialized
17.834: Initializing CPU #1
17.834: Waiting for 1 CPUS to stop
17.834: CPU: vendor Intel device 6ec
17.834: CPU: family 06, model 0e, stepping 0c
17.834: Enabling cache
17.834: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.835: CBFS: Locating 'cpu_microcode_blob.bin'
17.835: CBFS: Found @ offset d2c0 size 17000
17.835: microcode: sig=3D0x6ec pf=3D0x20 revision=3D0x0
17.837: microcode: updated to revision 0x54 date=3D2006-05-01
17.837: CPU: Intel(R) Core(TM) Duo CPU      L2400  @ 1.66GHz.
17.838: MTRR: Fixed MSR 0x250 0x0606060606060606
17.838: MTRR: Fixed MSR 0x258 0x0606060606060606
17.838: MTRR: Fixed MSR 0x259 0x0000000000000000
17.838: MTRR: Fixed MSR 0x268 0x0606060606060606
17.838: MTRR: Fixed MSR 0x269 0x0606060606060606
17.838: MTRR: Fixed MSR 0x26a 0x0606060606060606
17.838: MTRR: Fixed MSR 0x26b 0x0606060606060606
17.838: MTRR: Fixed MSR 0x26c 0x0606060606060606
17.838: MTRR: Fixed MSR 0x26d 0x0606060606060606
17.839: MTRR: Fixed MSR 0x26e 0x0606060606060606
17.839: MTRR: Fixed MSR 0x26f 0x0606060606060606
17.840: CPU physical address size: 32 bits
17.840:=20
17.840: MTRR check
17.840: Fixed MTRRs   : Enabled
17.840: Variable MTRRs: Enabled
17.840:=20
17.840: Setting up local APIC... apic_id: 0x01 done.
17.840: VMX status: enabled, locked
17.840: CPU: 1 2 siblings
17.840: CPU #1 initialized
17.840: CPU 1 going down...
17.840: All AP CPUs stopped (9740 loops)
17.840: CPU_CLUSTER: 0 init finished in 321804 usecs
17.840: PCI: 00:02.0 init ...
17.840: Initializing VGA without OPROM.
17.905: No display connected on slave 2
17.920: WARNING: EDID block does NOT fully conform to EDID 1.3.
17.920: <09>Missing name descriptor
17.920: <09>Missing monitor ranges
17.920: bringing up panel at resolution 1024 x 768
17.920: Borders 0 x 0
17.920: Blank 320 x 38
17.920: Sync 136 x 6
17.920: Front porch 24 x 3
17.920: Spread spectrum clock
17.920: Single channel
17.920: Polarities 1, 1
17.920: Pixel N=3D3, M1=3D15, M2=3D4, P1=3D2
17.920: Pixel clock 65000 kHz
17.920: VGA mode: text
17.927: waiting for panel powerup
17.927: panel powered up
17.927: gtt_setup is enabled.
17.927: 8M UMA
17.928: GTT PGETBL_CTL register: 0x7ffc0001
17.928: GTT Enabled
17.931: PCI: 00:02.0 init finished in 139540 usecs
17.931: PCI: 00:02.1 init ...
17.931: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.931: CBFS: Locating 'cmos_layout.bin'
17.931: CBFS: Found @ offset 39100 size 6ac
17.932: PCI: 00:02.1 init finished in 14413 usecs
17.932: PCI: 00:1b.0 init ...
17.933: Azalia: codec type: Azalia
17.933: Azalia: base =3D e4440000
17.935: Azalia: codec_mask =3D 03
17.935: Azalia: Initializing codec #1
17.935: Azalia: codec viddid: 14f12bfa
17.935: Azalia: No verb!
17.935: Azalia: Initializing codec #0
17.935: Azalia: codec viddid: 11d41981
17.935: Azalia: verb_size: 44
17.937: Azalia: verb loaded.
17.937: PCI: 00:1b.0 init finished in 30349 usecs
17.937: PCI: 00:1c.0 init ...
17.937: Initializing ICH7 PCIe bridge.
17.937: PCI: 00:1c.0 init finished in 4839 usecs
17.937: PCI: 00:1c.1 init ...
17.937: Initializing ICH7 PCIe bridge.
17.937: PCI: 00:1c.1 init finished in 4839 usecs
17.937: PCI: 00:1c.2 init ...
17.937: Initializing ICH7 PCIe bridge.
17.937: PCI: 00:1c.2 init finished in 4838 usecs
17.937: PCI: 00:1c.3 init ...
17.937: Initializing ICH7 PCIe bridge.
17.937: PCI: 00:1c.3 init finished in 4838 usecs
17.937: PCI: 00:1d.0 init ...
17.937: UHCI: Setting up controller.. done.
17.937: PCI: 00:1d.0 init finished in 5272 usecs
17.937: PCI: 00:1d.1 init ...
17.937: UHCI: Setting up controller.. done.
17.937: PCI: 00:1d.1 init finished in 5273 usecs
17.937: PCI: 00:1d.2 init ...
17.937: UHCI: Setting up controller.. done.
17.937: PCI: 00:1d.2 init finished in 5273 usecs
17.937: PCI: 00:1d.3 init ...
17.937: UHCI: Setting up controller.. done.
17.938: PCI: 00:1d.3 init finished in 5271 usecs
17.937: PCI: 00:1d.7 init ...
17.937: EHCI: Setting up controller.. done.
17.938: PCI: 00:1d.7 init finished in 5282 usecs
17.938: PCI: 00:1e.0 init ...
17.938: PCI: 00:1e.0 init finished in 2031 usecs
17.938: PCI: 00:1f.0 init ...
17.938: i82801gx: lpc_init
17.938: IOAPIC: Initializing IOAPIC at 0xfec00000
17.938: IOAPIC: Bootstrap Processor Local APIC =3D 0x00
17.938: IOAPIC: ID =3D 0x02
17.938: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.938: CBFS: Locating 'cmos_layout.bin'
17.938: CBFS: Found @ offset 39100 size 6ac
17.939: WARNING: No CMOS option 'power_on_after_fail'.
17.939: Set power on after power failure.
17.939: CBFS: 'Master Header Locator' located CBFS at [200:1fffc0)
17.939: CBFS: Locating 'cmos_layout.bin'
17.939: CBFS: Found @ offset 39100 size 6ac
17.939: NMI sources enabled.
17.939: rtc_failed =3D 0x0
17.939: S3 wakeup, enabling ACPI via APMC
17.940: Locking SMM.
17.940: PCI: 00:1f.0 init finished in 53325 usecs
17.940: PCI: 00:1f.1 init ...
17.940: i82801gx_ide: initializing... IDE0
17.940: PCI: 00:1f.1 init finished in 5203 usecs
17.940: PCI: 00:1f.2 init ...
17.940: i82801gx_sata: initializing...
17.940: SATA controller in AHCI mode.
17.940: PCI: 00:1f.2 init finished in 7553 usecs
17.940: PCI: 01:00.0 init ...
17.940: PCI: 01:00.0 init finished in 2019 usecs
17.940: PCI: 02:00.0 init ...
17.940: PCI: 02:00.0 init finished in 2018 usecs
17.940: PCI: 05:00.0 init ...
17.940: Ricoh RL5c476: Initializing.
17.940: CF Base =3D 0
17.940: CF boot not enabled.
17.940: PCI: 05:00.0 init finished in 7725 usecs
17.940: PCI: 05:00.1 init ...
17.940: PCI: 05:00.1 init finished in 2019 usecs
17.940: PCI: 05:00.2 init ...
17.940: PCI: 05:00.2 init finished in 2017 usecs
17.940: PNP: 00ff.2 init ...
17.940: PNP: 00ff.2 init finished in 1930 usecs
17.940: PNP: 164e.2 init ...
17.940: PNP: 164e.2 init finished in 1929 usecs
17.940: PNP: 164e.3 init ...
17.940: PNP: 164e.3 init finished in 1932 usecs
17.940: PNP: 164e.7 init ...
17.940: PNP: 164e.7 init finished in 1931 usecs
17.940: PNP: 164e.19 init ...
17.940: PNP: 164e.19 init finished in 2019 usecs
17.940: PNP: 002e.1 init ...
17.940: PNP: 002e.1 init finished in 1930 usecs
17.940: PNP: 002e.3 init ...
17.940: PNP: 002e.3 init finished in 1929 usecs
17.940: PNP: 002e.7 init ...
17.940: PNP: 002e.7 init finished in 1931 usecs
17.940: smbus: PCI: 00:1f.3[0]->I2C: 01:69 init ...
17.954: Changing 12 of the 12 ck505 config bytes.
17.967: I2C: 01:69 init finished in 33854 usecs
17.966: smbus: PCI: 00:1f.3[0]->I2C: 01:54 init ...
17.966: I2C: 01:54 init finished in 3941 usecs
17.966: smbus: PCI: 00:1f.3[0]->I2C: 01:55 init ...
17.967: I2C: 01:55 init finished in 3940 usecs
17.967: smbus: PCI: 00:1f.3[0]->I2C: 01:56 init ...
17.967: I2C: 01:56 init finished in 3939 usecs
17.967: smbus: PCI: 00:1f.3[0]->I2C: 01:57 init ...
17.967: I2C: 01:57 init finished in 3940 usecs
17.967: smbus: PCI: 00:1f.3[0]->I2C: 01:5c init ...
17.967: Locking EEPROM RFID
17.988: init EEPROM done
17.988: I2C: 01:5c init finished in 28969 usecs
17.988: smbus: PCI: 00:1f.3[0]->I2C: 01:5d init ...
17.988: I2C: 01:5d init finished in 3938 usecs
17.988: smbus: PCI: 00:1f.3[0]->I2C: 01:5e init ...
17.988: I2C: 01:5e init finished in 3940 usecs
17.988: smbus: PCI: 00:1f.3[0]->I2C: 01:5f init ...
17.988: I2C: 01:5f init finished in 3941 usecs
17.988: Devices initialized
17.988: BS: BS_DEV_INIT times (us): entry 7 run 893858 exit 0
17.988: Finalize devices...
17.988: Devices finalized
17.988: BS: BS_POST_DEVICE times (us): entry 0 run 3506 exit 0
17.988: Trying to find the wakeup vector...
17.988: Looking on 000f0800 for valid checksum
17.988: Checksum 1 passed
17.988: Checksum 2 passed all OK
17.988: RSDP found at 000f0800
17.988: RSDT found at 7f70d030 ends at 7f70d06c
17.988: FADT found at 7f7102a0
17.989: FACS found at 7f70d240
17.989: OS waking vector is 0009c090
17.989: BS: BS_OS_RESUME_CHECK times (us): entry 0 run 23170 exit 0
17.990: [   92.014777] ACPI: Low-level resume complete
17.990: [   92.014777] ACPI: EC: EC started
17.990: [   92.014777] PM: Restoring platform NVS memory
17.990: [   92.014777] PM: Calling bsp_resume+0x0/0x30
17.990: [   92.014777] PM: Calling lapic_resume+0x0/0x4c0
17.990: [   92.014777] PM: Calling acpi_restore_bm_rld+0x0/0x60
17.990: [   92.014777] PM: Calling irqrouter_resume+0x0/0x60
17.990: [   92.014777] PM: Calling i8259A_resume+0x0/0x30
17.991: [   92.014777] PM: Calling i8237A_resume+0x0/0xc0
17.991: [   92.014777] PM: Calling ioapic_resume+0x0/0x1e0
17.991: [   92.014777] PM: Calling irq_gc_resume+0x0/0x90
17.991: [   92.014777] PM: Calling irq_pm_syscore_resume+0x0/0x20
17.991: [   92.014777] PM: Calling timekeeping_resume+0x0/0x420
17.991: [   92.014777] PM: Calling ledtrig_cpu_syscore_resume+0x0/0x20
17.991: [   92.014777] PM: Calling mce_syscore_resume+0x0/0x30
17.991: [   92.014777] PM: Calling mc_bp_resume+0x0/0x140
17.992: [   92.014777] PM: Calling kvm_resume+0x0/0x40 [kvm]
17.992: [  101.347649] Enabling non-boot CPUs ...
17.992: [  101.351643] x86: Booting SMP configuration:
17.992: [  101.355911] smpboot: Booting Node 0 Processor 1 APIC 0x1
17.993: [   91.988009] Initializing CPU#1
17.993: [   91.988009] Disabled fast string operations
17.993: [  101.369674]  cache: parent cpu1 should not be sleeping
17.994: [  101.375240] CPU1 is up
17.996: [  101.379335] ACPI: Waking up from system sleep state S3
18.002: [  101.390539] calling  0000:00:00.0+ @ 630, parent: pci0000:00
18.002: [  101.390661] calling  PNP0C09:00+ @ 603, parent: device:22
18.002: [  101.396340] call 0000:00:00.0+ returned 0 after 47 usecs
18.002: [  101.401765] ACPI: EC: interrupt unblocked
18.002: [  101.401770] call PNP0C09:00+ returned 0 after 3 usecs
18.002: [  101.407174] calling  0000:00:02.0+ @ 625, parent: pci0000:00
18.002: [  101.411259] calling  0000:00:02.1+ @ 118, parent: pci0000:00
18.002: [  101.416430] call 0000:00:02.0+ returned 0 after 45 usecs
18.002: [  101.422161] call 0000:00:02.1+ returned 0 after 40 usecs
18.003: [  101.427877] calling  0000:00:1b.0+ @ 630, parent: pci0000:00
18.003: [  101.433271] calling  0000:00:1c.0+ @ 623, parent: pci0000:00
18.003: [  101.438674] calling  0000:00:1c.1+ @ 120, parent: pci0000:00
18.003: [  101.444547] call 0000:00:1c.0+ returned 0 after 152 usecs
18.003: [  101.450331] call 0000:00:1c.1+ returned 0 after 154 usecs
18.003: [  101.455973] calling  0000:00:1c.2+ @ 118, parent: pci0000:00
18.003: [  101.461436] calling  0000:00:1c.3+ @ 6, parent: pci0000:00
18.003: [  101.467055] call 0000:00:1c.2+ returned 0 after 152 usecs
18.003: [  101.472836] call 0000:00:1c.3+ returned 0 after 155 usecs
18.004: [  101.478281] calling  0000:00:1d.0+ @ 623, parent: pci0000:00
18.004: [  101.483765] calling  0000:00:1d.1+ @ 622, parent: pci0000:00
18.004: [  101.489283] call 0000:00:1d.0+ returned 0 after 50 usecs
18.004: [  101.495035] call 0000:00:1d.1+ returned 0 after 50 usecs
18.004: [  101.500743] calling  0000:00:1d.2+ @ 118, parent: pci0000:00
18.004: [  101.506136] calling  0000:00:1d.3+ @ 621, parent: pci0000:00
18.004: [  101.511562] call 0000:00:1d.2+ returned 0 after 47 usecs
18.004: [  101.517327] call 0000:00:1d.3+ returned 0 after 47 usecs
18.004: [  101.523026] calling  0000:00:1d.7+ @ 623, parent: pci0000:00
18.004: [  101.523038] calling  0000:00:1e.0+ @ 118, parent: pci0000:00
18.005: [  101.528434] calling  0000:00:1f.0+ @ 624, parent: pci0000:00
18.005: [  101.533863] call 0000:00:1e.0+ returned 0 after 50 usecs
18.005: [  101.539633] call 0000:00:1f.0+ returned 0 after 61 usecs
18.005: [  101.545340] calling  0000:00:1f.1+ @ 118, parent: pci0000:00
18.005: [  101.551076] calling  0000:00:1f.2+ @ 626, parent: pci0000:00
18.005: [  101.556506] call 0000:00:1f.1+ returned 0 after 48 usecs
18.005: [  101.561888] calling  0000:01:00.0+ @ 119, parent: 0000:00:1c.0=

18.005: [  101.567686] call 0000:00:1d.7+ returned 0 after 43609 usecs
18.005: [  101.573400] calling  0000:02:00.0+ @ 629, parent: 0000:00:1c.1=

18.008: [  101.578771] calling  0000:05:00.0+ @ 625, parent: 0000:00:1e.0=

18.008: [  101.578878] yenta_cardbus 0000:05:00.0: calling  ricoh_mmc_fix=
up_rl5c476+0x0/0x110 @ 625
18.008: [  101.584743] calling  0000:05:00.1+ @ 619, parent: 0000:00:1e.0=

18.008: [  101.590384] yenta_cardbus 0000:05:00.0: ricoh_mmc_fixup_rl5c47=
6+0x0/0x110 took 5 usecs
18.008: [  101.596315] calling  0000:05:00.2+ @ 628, parent: 0000:00:1e.0=

18.008: [  101.604396] yenta_cardbus 0000:05:00.0: calling  quirk_cardbus=
_legacy+0x0/0x20 @ 625
18.008: [  101.604405] yenta_cardbus 0000:05:00.0: quirk_cardbus_legacy+0=
x0/0x20 took 2 usecs
18.009: [  101.612919] call 0000:00:1f.2+ returned 0 after 49855 usecs
18.009: [  101.618533] call 0000:05:00.0+ returned 0 after 38826 usecs
18.009: [  101.626973] call 0000:02:00.0+ returned 0 after 41262 usecs
18.009: [  101.632458] calling  PNP0C0B:00+ @ 603, parent: platform
18.009: [  101.640429] call 0000:01:00.0+ returned 0 after 65474 usecs
18.009: [  101.648029] call PNP0C0B:00+ returned 0 after 2 usecs
18.009: [  101.648130] call 0000:00:1b.0+ returned 0 after 204562 usecs
18.009: [  101.653788] call 0000:05:00.1+ returned 0 after 56139 usecs
18.009: [  101.659399] calling  BOOT0000:00+ @ 603, parent: platform
18.010: [  101.665110] call 0000:05:00.2+ returned 0 after 51301 usecs
18.010: [  101.670453] call BOOT0000:00+ returned 0 after 1 usecs
18.010: [  101.670523] calling  i8042+ @ 603, parent: platform
18.010: [  101.713920] call i8042+ returned 0 after 1 usecs
18.010: [  101.718672] calling  pcmcia_socket0+ @ 603, parent: 0000:05:00=
=2E0
18.010: [  101.724893] call pcmcia_socket0+ returned 0 after 125 usecs
18.010: [  101.730544] calling  iTCO_wdt.0.auto+ @ 603, parent: 0000:00:1=
f.0
18.010: [  101.736722] call iTCO_wdt.0.auto+ returned 0 after 1 usecs
18.011: [  101.742433] pciehp 0000:00:1c.0:pcie004: Slot(0): Link Up
18.011: [  101.748171] calling  PNP0C0B:00+ @ 603, parent: platform
18.013: [  101.755264] call PNP0C0B:00+ returned 0 after 1653 usecs
18.013: [  101.760673] calling  BOOT0000:00+ @ 603, parent: platform
18.013: [  101.766150] call BOOT0000:00+ returned 0 after 1 usecs
18.013: [  101.771536] calling  0000:00:00.0+ @ 629, parent: pci0000:00
18.013: [  101.771604] calling  PNP0C09:00+ @ 603, parent: device:22
18.013: [  101.777280] call 0000:00:00.0+ returned 0 after 2 usecs
18.014: [  101.782755] ACPI: EC: event unblocked
18.014: [  101.788060] calling  0000:00:02.0+ @ 628, parent: pci0000:00
18.014: [  101.791798] call PNP0C09:00+ returned 0 after 8830 usecs
18.014: [  101.797515] call 0000:00:02.0+ returned 0 after 1 usecs
18.014: [  101.802908] calling  0000:00:02.1+ @ 119, parent: pci0000:00
18.014: [  101.808205] calling  0000:00:1b.0+ @ 629, parent: pci0000:00
18.014: [  101.808370] calling  0000:00:1c.0+ @ 628, parent: pci0000:00
18.014: [  101.813964] call 0000:00:02.1+ returned 0 after 1 usecs
18.014: [  101.819722] calling  ACPI0003:00+ @ 603, parent: PNP0C09:00
18.014: [  101.825440] calling  0000:00:1c.1+ @ 626, parent: pci0000:00
18.015: [  101.830761] pciehp 0000:00:1c.0:pcie004: Timeout on hotplug co=
mmand 0x1038 (issued 92020 msec ago)
18.015: [  101.836404] call 0000:00:1c.1+ returned 0 after 11 usecs
18.015: [  101.842357] calling  0000:00:1c.2+ @ 619, parent: pci0000:00
18.015: [  101.851243] calling  0000:00:1c.3+ @ 624, parent: pci0000:00
18.015: [  101.851260] call 0000:00:1c.3+ returned 0 after 14 usecs
18.015: [  101.851263] calling  0000:00:1d.0+ @ 624, parent: pci0000:00
18.015: [  101.851373] usb usb1: root hub lost power or was reset
18.015: [  101.856774] call 0000:00:1c.2+ returned 0 after 17 usecs
18.015: [  101.862507] call 0000:00:1d.0+ returned 0 after 10975 usecs
18.016: [  101.868259] call 0000:00:1b.0+ returned 0 after 58642 usecs
18.016: [  101.873635] calling  0000:00:1d.1+ @ 622, parent: pci0000:00
18.016: [  101.879461] calling  0000:00:1d.2+ @ 629, parent: pci0000:00
18.016: [  101.884606] calling  0000:00:1d.3+ @ 625, parent: pci0000:00
18.016: [  101.890095] usb usb3: root hub lost power or was reset
18.016: [  101.895656] calling  0000:00:1d.7+ @ 621, parent: pci0000:00
18.016: [  101.901307] call 0000:00:1d.2+ returned 0 after 11061 usecs
18.016: [  101.907041] calling  0000:00:1e.0+ @ 121, parent: pci0000:00
18.016: [  101.912777] calling  0000:00:1f.0+ @ 630, parent: pci0000:00
18.016: [  101.918527] call 0000:00:1e.0+ returned 0 after 19 usecs
18.017: [  101.923725] call 0000:00:1f.0+ returned 0 after 1 usecs
18.017: [  101.929563] usb usb2: root hub lost power or was reset
18.017: [  101.935129] calling  0000:00:1f.1+ @ 120, parent: pci0000:00
18.017: [  101.940874] call 0000:00:1d.1+ returned 0 after 54971 usecs
18.017: [  101.946592] call 0000:00:1f.1+ returned 0 after 1 usecs
18.017: [  101.952107] usb usb4: root hub lost power or was reset
18.017: [  101.957296] calling  0000:00:1f.2+ @ 118, parent: pci0000:00
18.017: [  101.962518] call 0000:00:1d.3+ returned 0 after 65301 usecs
18.017: [  101.968278] call 0000:00:1f.2+ returned 0 after 38 usecs
18.017: [  101.973965] call 0000:00:1d.7+ returned 0 after 65363 usecs
18.018: [  101.979232] calling  0000:02:00.0+ @ 119, parent: 0000:00:1c.1=

18.018: [  101.984452] calling  0000:05:00.0+ @ 635, parent: 0000:00:1e.0=

18.018: [  101.990208] call 0000:02:00.0+ returned 0 after 22 usecs
18.018: [  101.995849] call 0000:05:00.0+ returned 0 after 2 usecs
18.018: [  102.001274] call ACPI0003:00+ returned 0 after 166534 usecs
18.018: [  102.006895] calling  0000:05:00.1+ @ 634, parent: 0000:00:1e.0=

18.018: [  102.012832] call 0000:00:1c.0+ returned 0 after 188612 usecs
18.018: [  102.018746] calling  0000:05:00.2+ @ 627, parent: 0000:00:1e.0=

18.018: [  102.024144] calling  ata1+ @ 623, parent: 0000:00:1f.2
18.018: [  102.029430] sdhci-pci 0000:05:00.2: Will use DMA mode even tho=
ugh HW doesn't fully claim to support it.
18.018: [  102.035084] call ata1+ returned 0 after 10 usecs
18.019: [  102.040997] sdhci-pci 0000:05:00.2: Will use DMA mode even tho=
ugh HW doesn't fully claim to support it.
18.019: [  102.046722] calling  0000:01:00.0+ @ 6, parent: 0000:00:1c.0
18.019: [  102.052643] calling  ata2+ @ 626, parent: 0000:00:1f.2
18.019: [  102.057863] calling  ata3+ @ 631, parent: 0000:00:1f.2
18.019: [  102.067346] call ata2+ returned 0 after 7 usecs
18.019: [  102.072038] call ata3+ returned 0 after 7 usecs
18.019: [  102.074973] calling  ata4+ @ 628, parent: 0000:00:1f.2
18.019: [  102.081560] calling  host0+ @ 633, parent: ata1
18.019: [  102.087300] call ata4+ returned 0 after 8 usecs
18.020: [  102.092514] call host0+ returned 0 after 2 usecs
18.020: [  102.097728] calling  PNP0C0A:00+ @ 603, parent: PNP0C09:00
18.020: [  102.102369] calling  host1+ @ 632, parent: ata2
18.020: [  102.106987] calling  host2+ @ 118, parent: ata3
18.020: [  102.112187] call host1+ returned 0 after 1 usecs
18.020: [  102.116792] call host2+ returned 0 after 1 usecs
18.020: [  102.121521] call 0000:05:00.1+ returned 0 after 100386 usecs
18.020: [  102.126118] calling  host3+ @ 631, parent: ata4
18.020: [  102.131707] calling  target0:0:0+ @ 624, parent: host0
18.021: [  102.136299] call host3+ returned 0 after 1 usecs
18.021: [  102.140911] call target0:0:0+ returned 0 after 1 usecs
18.021: [  102.150430] calling  usb1+ @ 623, parent: 0000:00:1d.0
18.021: [  102.156073] calling  usb2+ @ 621, parent: 0000:00:1d.1
18.021: [  102.156118] calling  usb3+ @ 634, parent: 0000:00:1d.2
18.021: [  102.156149] calling  usb4+ @ 625, parent: 0000:00:1d.3
18.021: [  102.156178] calling  usb5+ @ 632, parent: 0000:00:1d.7
18.021: [  102.160779] calling  0:0:0:0+ @ 619, parent: target0:0:0
18.021: [  102.160790] BUG: unable to handle kernel NULL pointer derefere=
nce at 000000f4
18.022: [  102.160794] *pde =3D 00000000=20
18.022: [  102.160798] Oops: 0002 [#1] SMP
18.022: [  102.160800] Modules linked in: serport mousedev
18.022: [  102.166164] call 0000:05:00.2+ returned 0 after 133531 usecs
18.022: [  102.166146]  binfmt_misc iTCO_wdt iTCO_vendor_support coretemp=
 arc4 kvm_intel kvm snd_hda_codec_analog snd_hda_codec_generic irqbypass =
snd_pcsp psmouse iwl3945 pcmcia iwlegacy mac80211
18.022: [  102.176063] call PNP0C0A:00+ returned 0 after 67496 usecs
18.022: [  102.176029]  snd_hda_intel snd_hda_codec sdhci_pci cqhci snd_h=
da_core firewire_ohci yenta_socket snd_hwdep lpc_ich pcmcia_rsrc cfg80211=
 mfd_core firewire_core pcmcia_core sdhci crc_itu_t mmc_core thinkpad_acp=
i i2c_i801 rng_core snd_pcm e1000e ehci_pci snd_timer
18.022: [  102.186594] calling  PNP0C0A:01+ @ 603, parent: PNP0C09:00
18.022: [  102.186584]  nvram snd rfkill battery uhci_hcd soundcore ehci_=
hcd usbcore video shpchp button ac acpi_cpufreq ip_tables x_tables autofs=
4 ext4 crc16 mbcache
18.022: [  102.197513] calling  hdaudioC0D0+ @ 654, parent: 0000:00:1b.0
18.023: [  102.196868]  jbd2 fscrypto cbc dm_crypt dm_mod sd_mod ahci lib=
ahci libata evdev serio_raw scsi_mod fan thermal
18.023: [  102.196868] CPU: 0 PID: 619 Comm: kworker/u4:5 Not tainted 4.1=
7.0-rc2+ #12
18.023: [  102.196868] Hardware name: LENOVO 636338U/636338U, BIOS CBET40=
00 TIMELESS 01/01/1970
18.023: [  102.196868] Workqueue: events_unbound async_run_entry_fn
18.023: [  102.208295] call hdaudioC0D0+ returned 0 after 829 usecs
18.023: [  102.207490] EIP: blk_set_runtime_active+0x4f/0xc0
18.023: [  102.207490] EFLAGS: 00010013 CPU: 0
18.023: [  102.207490] EAX: 00000000 EBX: f6640bc0 ECX: f6640cb8 EDX: 000=
00000
18.023: [  102.207490] ESI: 00000000 EDI: ffff35b3 EBP: f1b4fe38 ESP: f1b=
4fe24
18.023: [  102.207490]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
18.023: [  102.207490] CR0: 80050033 CR2: 000000f4 CR3: 34329000 CR4: 000=
006d0
18.024: [  102.207490] Call Trace:
18.024: [  102.207490]  ? async_sdev_thaw+0x20/0x20 [scsi_mod]
18.024: [  102.217657] call PNP0C0A:01+ returned 0 after 20334 usecs
18.024: [  102.207490]  scsi_bus_resume_common+0x79/0x180 [scsi_mod]
18.024: [  102.207490]  scsi_bus_resume+0x12/0x20 [scsi_mod]
18.024: [  102.225483] calling  PNP0C0E:00+ @ 603, parent: PNP0C09:00
18.024: [  102.207490]  dpm_run_callback+0x47/0x1b0
18.024: [  102.207490]  ? scsi_bus_thaw+0x20/0x20 [scsi_mod]
18.024: [  102.207490]  device_resume+0x97/0x190
18.025: [  102.247723] call PNP0C0E:00+ returned 0 after 1 usecs
18.025: [  102.207490]  ? device_resume+0x190/0x190
18.025: [  102.207490]  async_resume+0x1e/0x50
18.025: [  102.207490]  async_run_entry_fn+0x61/0x3a0
18.025: [  102.207490]  ? try_to_wake_up+0x4d/0x790
18.025: [  102.207490]  ? pwq_dec_nr_in_flight+0x7c/0x150
18.025: [  102.276518] call usb2+ returned 0 after 117617 usecs
18.025: [  102.207490]  process_one_work+0x235/0x690
18.025: [  102.207490]  worker_thread+0x19d/0x6a0
18.025: [  102.207490]  kthread+0x14a/0x1f0
18.025: [  102.207490]  ? process_one_work+0x690/0x690
18.026: [  102.207490]  ? kthread_create_worker_on_cpu+0x30/0x30
18.026: [  102.296000] call usb5+ returned 0 after 126932 usecs
18.026: [  102.207490]  ret_from_fork+0x2e/0x38
18.026: [  102.207490] Code: 7e 8b 83=20
18.026: [  102.311897] calling  phy0+ @ 121, parent: 0000:02:00.0
18.026: [  102.207490] fc 00 00 00 e8 e0 32 53 00 8b b3 50 01 00 00 31=20
18.026: [  102.326676] calling  5-6+ @ 642, parent: usb5
18.026: [  102.207490] c0 8b 3d 20 7d 6a de 89 83 54 01 00 00 81 fe 0c ff=
=20
18.026: [  102.337499] call usb3+ returned 0 after 177124 usecs
18.026: [  102.207490] ff ff 89 7d ec 74 46 <89> be f4 00 00 00 ba 09 00 =

18.027: [  102.345835] call usb4+ returned 0 after 185236 usecs
18.027: [  102.207490] 00 00 8b 83 50 01 00 00 e8 0b 25 24=20
18.027: [  102.207490] EIP: blk_set_runtime_active+0x4f/0xc0 SS:ESP: 0068=
:f1b4fe24
18.027: [  102.207490] CR2: 00000000000000f4
18.027: [  102.358489] call usb1+ returned 0 after 193086 usecs
18.029: [  102.207490] ---[ end trace 5717e021dd8debaa ]---
18.029: [  102.368583] call phy0+ returned 0 after 40937 usecs
18.029: [  102.370379] calling  PNP0C0D:00+ @ 603, parent: PNP0C09:00
18.030: [  102.388655] call 0000:01:00.0+ returned 0 after 323053 usecs
18.030: [  102.393664] ACPI: button: The lid device is not compliant to S=
W_LID.
18.030: [  102.470479] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl =
300)
18.030: [  102.471457] call PNP0C0D:00+ returned 0 after 80739 usecs
18.030: [  102.492067] usb 5-6: reset high-speed USB device number 2 usin=
g ehci-pci
18.030: [  102.495920] calling  dock.0+ @ 603, parent: platform
18.030: [  102.584691] call dock.0+ returned 0 after 1 usecs
18.030: [  102.589474] calling  LNXTHERM:00+ @ 603, parent: LNXSYBUS:01
18.030: [  102.595248] call LNXTHERM:00+ returned 0 after 36 usecs
18.030: [  102.600557] calling  LNXTHERM:01+ @ 603, parent: LNXSYBUS:01
18.030: [  102.606300] call LNXTHERM:01+ returned 0 after 3 usecs
18.031: [  102.611540] calling  PNP0C09:00+ @ 603, parent: 0000:00:1f.0
18.031: [  102.617283] call PNP0C09:00+ returned 0 after 1 usecs
18.031: [  102.622412] calling  IBM0068:00+ @ 603, parent: PNP0C09:00
18.031: [  102.627974] call IBM0068:00+ returned 0 after 1 usecs
18.031: [  102.633105] calling  ACPI0003:00+ @ 603, parent: PNP0C09:00
18.031: [  102.638757] call ACPI0003:00+ returned 0 after 1 usecs
18.031: [  102.643970] calling  PNP0C0A:00+ @ 603, parent: PNP0C09:00
18.031: [  102.649556] call PNP0C0A:00+ returned 0 after 1 usecs
18.031: [  102.654691] calling  PNP0C0A:01+ @ 603, parent: PNP0C09:00
18.031: [  102.660092] firewire_core 0000:05:00.1: rediscovered device fw=
0
18.032: [  102.660257] call PNP0C0A:01+ returned 0 after 1 usecs
18.032: [  102.671389] calling  PNP0C0E:00+ @ 603, parent: PNP0C09:00
18.032: [  102.676956] call PNP0C0E:00+ returned 0 after 0 usecs
18.032: [  102.682084] calling  PNP0C0D:00+ @ 603, parent: PNP0C09:00
18.032: [  102.687654] call PNP0C0D:00+ returned 0 after 1 usecs
18.032: [  102.692795] calling  INT0800:00+ @ 603, parent: 0000:00:1f.0
18.032: [  102.698533] call INT0800:00+ returned 0 after 1 usecs
18.032: [  102.703665] calling  PNP0C04:00+ @ 603, parent: 0000:00:1f.0
18.032: [  102.709408] call PNP0C04:00+ returned 0 after 1 usecs
18.032: [  102.714538] calling  PNP0C0B:00+ @ 603, parent: platform
18.033: [  102.719953] call PNP0C0B:00+ returned 0 after 25 usecs
18.033: [  102.725215] calling  LNXPWRBN:00+ @ 603, parent: LNXSYSTM:00
18.033: [  102.730951] call LNXPWRBN:00+ returned 0 after 1 usecs
18.033: [  102.736172] calling  00:00+ @ 603, parent: pnp0
18.033: [  102.740786] call 00:00+ returned 0 after 1 usecs
18.033: [  102.745481] calling  00:01+ @ 603, parent: pnp0
18.033: [  102.750095] call 00:01+ returned 0 after 1 usecs
18.033: [  102.754789] calling  00:02+ @ 603, parent: pnp0
18.033: [  102.759397] call 00:02+ returned 0 after 1 usecs
18.033: [  102.764100] calling  00:03+ @ 603, parent: pnp0
18.034: [  102.768782] call 00:03+ returned 0 after 74 usecs
18.034: [  102.772614] call 5-6+ returned 0 after 424979 usecs
18.034: [  102.773567] calling  00:04+ @ 603, parent: pnp0
18.034: [  102.783134] call 00:04+ returned 0 after 1 usecs
18.034: [  102.787837] calling  00:05+ @ 603, parent: pnp0
18.034: [  102.792450] call 00:05+ returned 0 after 1 usecs
18.034: [  102.797147] calling  00:06+ @ 603, parent: pnp0
18.034: [  102.801870] call 00:06+ returned 0 after 107 usecs
18.035: [  102.806756] calling  00:07+ @ 603, parent: pnp0
18.035: [  102.811395] call 00:07+ returned 0 after 24 usecs
18.035: [  102.816225] calling  pcspkr+ @ 603, parent: platform
18.035: [  102.821266] call pcspkr+ returned 0 after 1 usecs
18.035: [  102.826047] calling  platform-framebuffer.0+ @ 603, parent: pl=
atform
18.035: [  102.832477] call platform-framebuffer.0+ returned 0 after 1 us=
ecs
18.035: [  102.838649] calling  alarmtimer+ @ 603, parent: platform
18.035: [  102.838896] ata1.00: configured for UDMA/100
18.035: [  102.844043] call alarmtimer+ returned 0 after 2 usecs
18.036: [  102.853528] calling  serial8250+ @ 603, parent: platform
18.036: [  102.858918] call serial8250+ returned 0 after 2 usecs
18.036: [  102.864052] calling  i8042+ @ 603, parent: platform
18.038: [  102.871682] call i8042+ returned 0 after 2615 usecs
18.039: [  102.876640] calling  serio0+ @ 603, parent: i8042
18.039: [  102.881427] call serio0+ returned 0 after 5 usecs
18.039: [  102.886223] calling  serio1+ @ 603, parent: i8042
18.039: [  102.891028] call serio1+ returned 0 after 17 usecs
18.039: [  102.895915] calling  rtc0+ @ 603, parent: 00:03
18.039: [  102.900528] call rtc0+ returned 0 after 2 usecs
18.039: [  102.905153] calling  memconsole+ @ 603, parent: platform
18.039: [  102.910544] call memconsole+ returned 0 after 2 usecs
18.039: [  102.915691] calling  input0+ @ 603, parent: serio0
18.040: [  102.920565] call input0+ returned 0 after 4 usecs
18.040: [  102.925361] calling  input0::numlock+ @ 603, parent: input0
18.040: [  102.931012] call input0::numlock+ returned 0 after 2 usecs
18.040: [  102.936592] calling  input0::capslock+ @ 603, parent: input0
18.040: [  102.942332] call input0::capslock+ returned 0 after 2 usecs
18.040: [  102.948222] calling  input0::scrolllock+ @ 603, parent: input0=

18.040: [  102.954141] call input0::scrolllock+ returned 0 after 2 usecs
18.041: [  102.960025] calling  microcode+ @ 603, parent: platform
18.041: [  102.965334] call microcode+ returned 0 after 1 usecs
20.276: [  105.205086] e1000e: eth8 NIC Link is Up 1000 Mbps Full Duplex,=
 Flow Control: Rx/Tx
20.276: [  105.212932] IPv6: ADDRCONF(NETDEV_CHANGE): eth8: link becomes =
ready

--------------F4692E3659B7E74EBD99072D--

--------------ms060705090708020600030607
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
EFowggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYT
AkRFMSswKQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYD
VQQLDBZULVN5c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFs
Um9vdCBDbGFzcyAyMB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNV
BAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVu
IEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERG
Ti1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAMtg1/9moUHN0vqHl4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZs
FVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8FXRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0p
eQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+BaL2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0
WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qLNupOkSk9s1FcragMvp0049ENF4N1
xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz9AkH4wKGMUZrAcUQDBHHWekC
AwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQUk+PYMiba1fFKpZFK4OpL
4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYDVR0TAQH/BAgwBgEB
/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGCLB4wCAYGZ4EM
AQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUvcmwvVGVs
ZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYBBQUH
MAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5j
ZXIwDQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4
eTizDnS6dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/
MOaZ/SLick0+hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3S
PXez7vTXTf/D6OWST1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc2
2CzeIs2LgtjZeOJVEqM7h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bP
ZYoaorVyGTkwggWNMIIEdaADAgECAgwcOtRQhH7u81j4jncwDQYJKoZIhvcNAQELBQAwgZUx
CzAJBgNVBAYTAkRFMUUwQwYDVQQKEzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1
dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNV
BAMTJERGTi1WZXJlaW4gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgMjAeFw0xNjExMDMxNTI0
NDhaFw0zMTAyMjIyMzU5NTlaMGoxCzAJBgNVBAYTAkRFMQ8wDQYDVQQIDAZCYXllcm4xETAP
BgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxhbmNrLUdlc2VsbHNjaGFmdDEVMBMG
A1UEAwwMTVBHIENBIC0gRzAyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnhx4
59Lh4WqgOs/Md04XxU2yFtfM15ZuJV0PZP7BmqSJKLLPyqmOrADfNdJ5PIGBto2JBhtRRBHd
G0GROOvTRHjzOga95WOTeura79T21FWwwAwa29OFnD3ZplQs6HgdwQrZWNi1WHNJxn/4mA19
rNEBUc5urSIpZPvZi5XmlF3v3JHOlx3KWV7mUteB4pwEEfGTg4npPAJbp2o7arxQdoIq+Pu2
OsvqhD7Rk4QeaX+EM1QS4lqd1otW4hE70h/ODPy1xffgbZiuotWQLC6nIwa65Qv6byqlIX0q
Zuu99Vsu+r3sWYsL5SBkgecNI7fMJ5tfHrjoxfrKl/ErTAt8GQIDAQABo4ICBTCCAgEwEgYD
VR0TAQH/BAgwBgEB/wIBATAOBgNVHQ8BAf8EBAMCAQYwKQYDVR0gBCIwIDANBgsrBgEEAYGt
IYIsHjAPBg0rBgEEAYGtIYIsAQEEMB0GA1UdDgQWBBTEiKUH7rh7qgwTv9opdGNSG0lwFjAf
BgNVHSMEGDAWgBST49gyJtrV8UqlkUrg6kviogzP4TCBjwYDVR0fBIGHMIGEMECgPqA8hjpo
dHRwOi8vY2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jcmwvY2Fjcmwu
Y3JsMECgPqA8hjpodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1
Yi9jcmwvY2FjcmwuY3JsMIHdBggrBgEFBQcBAQSB0DCBzTAzBggrBgEFBQcwAYYnaHR0cDov
L29jc3AucGNhLmRmbi5kZS9PQ1NQLVNlcnZlci9PQ1NQMEoGCCsGAQUFBzAChj5odHRwOi8v
Y2RwMS5wY2EuZGZuLmRlL2dsb2JhbC1yb290LWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNy
dDBKBggrBgEFBQcwAoY+aHR0cDovL2NkcDIucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1j
YS9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwDQYJKoZIhvcNAQELBQADggEBABLpeD5FygzqOjj+
/lAOy20UQOGWlx0RMuPcI4nuyFT8SGmK9lD7QCg/HoaJlfU/r78ex+SEide326evlFAoJXIF
jVyzNltDhpMKrPIDuh2N12zyn1EtagqPL6hu4pVRzcBpl/F2HCvtmMx5K4WN1L1fmHWLcSap
dhXLvAZ9RG/B3rqyULLSNN8xHXYXpmtvG0VGJAndZ+lj+BH7uvd3nHWnXEHC2q7iQlDUqg0a
wIqWJgdLlx1Q8Dg/sodv0m+LN0kOzGvVDRCmowBdWGhhusD+duKV66pBl+qhC+4LipariWaM
qK5ppMQROATjYeNRvwI+nDcEXr2vDaKmdbxgDVwwggWvMIIEl6ADAgECAgweKlJIhfynPMVG
/KIwDQYJKoZIhvcNAQELBQAwajELMAkGA1UEBhMCREUxDzANBgNVBAgMBkJheWVybjERMA8G
A1UEBwwITXVlbmNoZW4xIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MRUwEwYD
VQQDDAxNUEcgQ0EgLSBHMDIwHhcNMTcxMTE0MTEzNDE2WhcNMjAxMTEzMTEzNDE2WjCBizEL
MAkGA1UEBhMCREUxIDAeBgNVBAoMF01heC1QbGFuY2stR2VzZWxsc2NoYWZ0MTQwMgYDVQQL
DCtNYXgtUGxhbmNrLUluc3RpdHV0IGZ1ZXIgbW9sZWt1bGFyZSBHZW5ldGlrMQ4wDAYDVQQL
DAVNUElNRzEUMBIGA1UEAwwLUGF1bCBNZW56ZWwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDIh/UR/AX/YQ48VWWDMLTYtXjYJyhRHMc81ZHMMoaoG66lWB9MtKRTnB5lovLZ
enTIUyPsCrMhTqV9CWzDf6v9gOTWVxHEYqrUwK5H1gx4XoK81nfV8oGV4EKuVmmikTXiztGz
peyDmOY8o/EFNWP7YuRkY/lPQJQBeBHYq9AYIgX4StuXu83nusq4MDydygVOeZC15ts0tv3/
6WmibmZd1OZRqxDOkoBbY3Djx6lERohs3IKS6RKiI7e90rCSy9rtidJBOvaQS9wvtOSKPx0a
+2pAgJEVzZFjOAfBcXydXtqXhcpOi2VCyl+7+LnnTz016JJLsCBuWEcB3kP9nJYNAgMBAAGj
ggIxMIICLTAJBgNVHRMEAjAAMA4GA1UdDwEB/wQEAwIF4DAdBgNVHSUEFjAUBggrBgEFBQcD
AgYIKwYBBQUHAwQwHQYDVR0OBBYEFHM0Mc3XjMLlhWpp4JufRELL4A/qMB8GA1UdIwQYMBaA
FMSIpQfuuHuqDBO/2il0Y1IbSXAWMCAGA1UdEQQZMBeBFXBtZW56ZWxAbW9sZ2VuLm1wZy5k
ZTB9BgNVHR8EdjB0MDigNqA0hjJodHRwOi8vY2RwMS5wY2EuZGZuLmRlL21wZy1nMi1jYS9w
dWIvY3JsL2NhY3JsLmNybDA4oDagNIYyaHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctZzIt
Y2EvcHViL2NybC9jYWNybC5jcmwwgc0GCCsGAQUFBwEBBIHAMIG9MDMGCCsGAQUFBzABhido
dHRwOi8vb2NzcC5wY2EuZGZuLmRlL09DU1AtU2VydmVyL09DU1AwQgYIKwYBBQUHMAKGNmh0
dHA6Ly9jZHAxLnBjYS5kZm4uZGUvbXBnLWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDBC
BggrBgEFBQcwAoY2aHR0cDovL2NkcDIucGNhLmRmbi5kZS9tcGctZzItY2EvcHViL2NhY2Vy
dC9jYWNlcnQuY3J0MEAGA1UdIAQ5MDcwDwYNKwYBBAGBrSGCLAEBBDARBg8rBgEEAYGtIYIs
AQEEAwYwEQYPKwYBBAGBrSGCLAIBBAMGMA0GCSqGSIb3DQEBCwUAA4IBAQCQs6bUDROpFO2F
Qz2FMgrdb39VEo8P3DhmpqkaIMC5ZurGbbAL/tAR6lpe4af682nEOJ7VW86ilsIJgm1j0ueY
aOuL8jrN4X7IF/8KdZnnNnImW3QVni6TCcc+7+ggci9JHtt0IDCj5vPJBpP/dKXLCN4M+exl
GXYpfHgxh8gclJPY1rquhQrihCzHfKB01w9h9tWZDVMtSoy9EUJFhCXw7mYUsvBeJwZesN2B
fndPkrXx6XWDdU3S1LyKgHlLIFtarLFm2Hb5zAUR33h+26cN6ohcGqGEEzgIG8tXS8gztEaj
1s2RyzmKd4SXTkKR3GhkZNVWy+gM68J7jP6zzN+cMYIDmjCCA5YCAQEwejBqMQswCQYDVQQG
EwJERTEPMA0GA1UECAwGQmF5ZXJuMREwDwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4
LVBsYW5jay1HZXNlbGxzY2hhZnQxFTATBgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzF
RvyiMA0GCWCGSAFlAwQCAQUAoIIB8TAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0xODA0MjQxNjE0NThaMC8GCSqGSIb3DQEJBDEiBCA0LhH4qsZyGk3v1oeN
CICQ5IgsP9cyZxhQ4bzGa3C5xjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcG
BSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGJBgkrBgEEAYI3EAQxfDB6MGoxCzAJBgNVBAYTAkRF
MQ8wDQYDVQQIDAZCYXllcm4xETAPBgNVBAcMCE11ZW5jaGVuMSAwHgYDVQQKDBdNYXgtUGxh
bmNrLUdlc2VsbHNjaGFmdDEVMBMGA1UEAwwMTVBHIENBIC0gRzAyAgweKlJIhfynPMVG/KIw
gYsGCyqGSIb3DQEJEAILMXygejBqMQswCQYDVQQGEwJERTEPMA0GA1UECAwGQmF5ZXJuMREw
DwYDVQQHDAhNdWVuY2hlbjEgMB4GA1UECgwXTWF4LVBsYW5jay1HZXNlbGxzY2hhZnQxFTAT
BgNVBAMMDE1QRyBDQSAtIEcwMgIMHipSSIX8pzzFRvyiMA0GCSqGSIb3DQEBAQUABIIBAB0h
Cjaxgq1cDaklbUxTNB6KtR9oYRWZFCKhgIZv5u0g4vLh+evj1w3pC4eBjMjxyZMQcMHiURt5
muqeBq/WKwaUmWIlsgjZvA4+U1pdEjDbvYFL51qOcV2U9OerGHzd2AnR8gxuDmMAV0thWFQw
qJwNTH01S7X4gkhGdklGk/ir7/W+ynV1RqXj1lewdiyaDHIuO+8MBStUzSiT8uIxnhVaa/a1
vVuVAQxJOHwD2z9ELtOn7wZI37HDvo4L3bVNzmvGmoZ7e+PQHRHGa8CLsxTEpdeuTEY/UpKu
NeVZs1S3aw29CrqTS3kTxwyPmuaAuqPxcz8kdSsCxueXSji2Z1UAAAAAAAA=
--------------ms060705090708020600030607--
