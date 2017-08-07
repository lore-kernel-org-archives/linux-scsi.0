From: Raj Dinesh <Raj.Dinesh@microsemi.com>
Subject: =?Windows-1252?Q?We_were_facing_libsas_kernel_crash_issue_with_SLES_12_SP?=
 =?Windows-1252?Q?3_kernel_=96_4.4.70-default_when_we_had_connected_cascad?=
 =?Windows-1252?Q?ed_second_expander?=
Date: Mon, 7 Aug 2017 09:04:39 +0000
Message-ID: <1EA9DF78A5A6C34DBDE22FE1B8AC6AB133D4BA6E@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0070.outbound.protection.outlook.com ([104.47.38.70]:27684
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752487AbdHGJGD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Aug 2017 05:06:03 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hello,

I=92m working on pm80xx Linux driver. Pm80xx driver is connected with OS up=
per layer scsi_transport_sas / libsas / ses drivers.

We=92ve added the support for SLES 12 SP2 - 4.4.21-default OS. Pm80xx drive=
r works fine with cascaded second expander.

We were facing kernel crash issue with SLES 12 SP3 kernel - 4.4.70-default =
when we had connected cascaded second expander.

To explain the scenario where we face this issue.
We have HBA card and two expanders connected in cascade with another.
With cascaded second expander(remote PHY ) if we connect drives and switch =
off  the expander OS crashes with libsas.

Please find below crash dump=20



[ 1194.413817]=20
[ 1194.413818] Leftover inexact backtrace:
              =20
[ 1194.413821]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.413826] ---[ end trace fbc5b38f9c7e0903 ]---
[ 1194.413835] ------------[ cut here ]------------
[ 1194.413838] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.413840] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
15'
[ 1194.413841] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.413899]  libata
[ 1194.413899]  usbcore
[ 1194.413900]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.413909] Supported: No, Unsupported modules are loaded
[ 1194.413911] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.413913] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.413917] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.413918]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.413922]  ffffffff8107df61
[ 1194.413923]  ffff880434290648
[ 1194.413925]  ffff8804172f7d28 ffffffffa00a9280
[ 1194.413926]  ffff88043df58c00 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.413930] Call Trace:
[ 1194.413935]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.413939]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.413942]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.413946]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.413949]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.413952]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.413955]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.413958]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.413961]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.413966]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.413970]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.413973]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.413977]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.413981]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.413984]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.413987]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.413990]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.416126] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.416128]=20
[ 1194.416128] Leftover inexact backtrace:
              =20
[ 1194.416132]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.416140] ---[ end trace fbc5b38f9c7e0904 ]---
[ 1194.416159] ------------[ cut here ]------------
[ 1194.416163] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.416165] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
15'
[ 1194.416166] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.416246]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.416247] Supported: No, Unsupported modules are loaded
[ 1194.416250] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.416252] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.416259] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.416261]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.416264]  ffffffff8107df61
[ 1194.416266]  ffff88043df58c00 ffff8804172f7d78 ffffffffa00a4d80
[ 1194.416270]  ffff88044aab2438
[ 1194.416271]  0000000000000000
[ 1194.416271]  ffffffff8107dfdc
[ 1194.416272]  ffffffff81a2db58
[ 1194.416273]=20
[ 1194.416273] Call Trace:
[ 1194.416281]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.416285]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.416289]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.416293]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.416297]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.416300]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.416303]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.416309]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.416314]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.416316]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.416321]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.416326]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.416329]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.416331]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.416334]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.418416] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.418419]=20
[ 1194.418420] Leftover inexact backtrace:
              =20
[ 1194.418425]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.418427] ---[ end trace fbc5b38f9c7e0905 ]---
[ 1194.418444] ------------[ cut here ]------------
[ 1194.418449] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.418452] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
16'
[ 1194.418453] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.418514]  libata
[ 1194.418514]  usbcore
[ 1194.418515]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.418524] Supported: No, Unsupported modules are loaded
[ 1194.418526] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.418528] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.418534] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.418535]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.418539]  ffffffff8107df61
[ 1194.418539]  ffff880434290648
[ 1194.418542]  ffff8804172f7d28 ffffffffa00a9280
[ 1194.418543]  ffff8801959ce800 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.418547] Call Trace:
[ 1194.418555]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.418559]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.418562]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.418566]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.418570]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.418575]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.418578]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.418581]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.418585]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.418591]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.418597]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.418601]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.418605]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.418609]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.418613]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.418616]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.418619]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.420670] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.420671]=20
[ 1194.420672] Leftover inexact backtrace:
              =20
[ 1194.420675]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.420681] ---[ end trace fbc5b38f9c7e0906 ]---
[ 1194.420708] ------------[ cut here ]------------
[ 1194.420711] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.420714] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
16'
[ 1194.420716] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.420776]  libata
[ 1194.420779]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.420787] Supported: No, Unsupported modules are loaded
[ 1194.420791] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.420793] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.420800] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.420803]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.420804]  ffffffff8107df61 ffff8801959ce800 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.420807]  ffff88044aab2438
[ 1194.420808]  0000000000000000
[ 1194.420810]  ffffffff8107dfdc
[ 1194.420811]  ffffffff81a2db58
[ 1194.420813]=20
[ 1194.420813] Call Trace:
[ 1194.420822]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.420826]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.420829]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.420833]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.420836]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.420839]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.420843]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.420848]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.420854]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.420857]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.420861]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.420865]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.420869]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.420872]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.420876]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.422896] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.422897]=20
[ 1194.422898] Leftover inexact backtrace:
              =20
[ 1194.422900]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.422902] ---[ end trace fbc5b38f9c7e0907 ]---
[ 1194.422913] ------------[ cut here ]------------
[ 1194.422916] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.422918] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
17'
[ 1194.422919] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.422979]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.422989] Supported: No, Unsupported modules are loaded
[ 1194.422991] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.422993] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.422997] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.422998]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.423002]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.423005]  ffff880449c67800 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.423009] Call Trace:
[ 1194.423015]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.423018]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.423021]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.423024]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.423027]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.423030]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.423033]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.423037]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.423040]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.423045]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.423050]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.423053]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.423057]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.423060]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.423064]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.423066]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.423070]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.425095] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.425097]=20
[ 1194.425097] Leftover inexact backtrace:
              =20
[ 1194.425099]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.425105] ---[ end trace fbc5b38f9c7e0908 ]---
[ 1194.425121] ------------[ cut here ]------------
[ 1194.425124] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.425125] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
17'
[ 1194.425126] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.425187]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.425195] Supported: No, Unsupported modules are loaded
[ 1194.425199] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.425203] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.425209] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.425211]  0000000000000000
[ 1194.425211]  ffffffff8131fe80
[ 1194.425212]  ffff8804172f7d28
[ 1194.425214]  ffffffff81a31c80
[ 1194.425215]  ffffffff8107df61 ffff880449c67800 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.425218]  ffff88044aab2438
[ 1194.425219]  0000000000000000
[ 1194.425220]  ffffffff8107dfdc
[ 1194.425221]  ffffffff81a2db58
[ 1194.425221]=20
[ 1194.425222] Call Trace:
[ 1194.425228]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.425231]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.425235]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.425238]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.425242]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.425246]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.425248]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.425253]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.425257]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.425260]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.425265]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.425268]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.425271]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.425274]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.425277]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.427296] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.427297]=20
[ 1194.427299] Leftover inexact backtrace:
              =20
[ 1194.427301]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.427303] ---[ end trace fbc5b38f9c7e0909 ]---
[ 1194.427312] ------------[ cut here ]------------
[ 1194.427315] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.427317] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
18'
[ 1194.427318] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.427379]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.427389] Supported: No, Unsupported modules are loaded
[ 1194.427391] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.427392] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.427397] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.427398]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.427402]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.427405]  ffff880072be2000
[ 1194.427406]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1194.427409] Call Trace:
[ 1194.427414]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.427418]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.427421]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.427423]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.427427]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.427430]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.427433]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.427436]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.427439]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.427444]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.427448]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.427451]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.427455]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.427459]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.427463]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.427465]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.427469]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.429492] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.429493]=20
[ 1194.429494] Leftover inexact backtrace:
              =20
[ 1194.429496]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.429504] ---[ end trace fbc5b38f9c7e090a ]---
[ 1194.429520] ------------[ cut here ]------------
[ 1194.429523] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.429525] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
18'
[ 1194.429526] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.429582]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.429593] Supported: No, Unsupported modules are loaded
[ 1194.429595] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.429597] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.429602] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.429605]  0000000000000000
[ 1194.429606]  ffffffff8131fe80
[ 1194.429607]  ffff8804172f7d28
[ 1194.429611]  ffffffff81a31c80
[ 1194.429614]  ffffffff8107df61 ffff880072be2000 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.429616]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.429617] Call Trace:
[ 1194.429623]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.429627]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.429631]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.429635]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.429639]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.429643]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.429645]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.429649]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.429653]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.429656]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.429661]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.429665]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.429668]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.429671]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.429674]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.431692] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.431692]=20
[ 1194.431693] Leftover inexact backtrace:
              =20
[ 1194.431696]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.431698] ---[ end trace fbc5b38f9c7e090b ]---
[ 1194.431708] ------------[ cut here ]------------
[ 1194.431711] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.431713] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
19'
[ 1194.431714] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.431774]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.431784] Supported: No, Unsupported modules are loaded
[ 1194.431786] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.431788] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.431792] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.431793]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.431797]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.431800]  ffff88043d2f0c00 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.431804] Call Trace:
[ 1194.431810]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.431813]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.431816]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.431819]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.431822]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.431825]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.431828]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.431831]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.431834]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.431839]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.431844]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.431847]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.431850]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.431854]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.431858]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.431860]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.431864]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.433888] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.433888]=20
[ 1194.433888] Leftover inexact backtrace:
              =20
[ 1194.433892]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.433897] ---[ end trace fbc5b38f9c7e090c ]---
[ 1194.433913] ------------[ cut here ]------------
[ 1194.433916] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.433918] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
19'
[ 1194.433919] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.433979]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.433990] Supported: No, Unsupported modules are loaded
[ 1194.433992] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.433993] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.433998] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.434003]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.434003]  ffffffff8107df61 ffff88043d2f0c00 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.434008]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.434012] Call Trace:
[ 1194.434017]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.434021]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.434024]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.434027]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.434030]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.434033]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.434036]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.434040]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.434045]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.434048]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.434051]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.434055]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.434059]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.434061]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.434064]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.436090] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.436090]=20
[ 1194.436090] Leftover inexact backtrace:
              =20
[ 1194.436093]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.436097] ---[ end trace fbc5b38f9c7e090d ]---
[ 1194.436106] ------------[ cut here ]------------
[ 1194.436108] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.436109] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
20'
[ 1194.436109] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.436161]  libata
[ 1194.436162]  usbcore
[ 1194.436163]  usb_common
[ 1194.436163]  sg
[ 1194.436164]  dm_multipath
[ 1194.436165]  dm_mod
[ 1194.436165]  scsi_dh_rdac
[ 1194.436171]  scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last un=
loaded: ses]
[ 1194.436173] Supported: No, Unsupported modules are loaded
[ 1194.436175] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.436177] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.436181] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.436185]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.436190]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.436194]  ffff88042effd800 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.436195] Call Trace:
[ 1194.436200]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.436204]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.436208]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.436212]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.436215]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.436218]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.436221]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.436225]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.436228]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.436233]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.436238]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.436241]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.436244]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.436248]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.436252]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.436255]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.436260]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.438297] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.438299]=20
[ 1194.438299] Leftover inexact backtrace:
              =20
[ 1194.438303]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.438305] ---[ end trace fbc5b38f9c7e090e ]---
[ 1194.438330] ------------[ cut here ]------------
[ 1194.438334] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.438335] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
20'
[ 1194.438337] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.438406]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.438419] Supported: No, Unsupported modules are loaded
[ 1194.438422] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.438423] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.438429] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.438430]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.438434]  ffffffff8107df61 ffff88042effd800 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.438438]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.438443] Call Trace:
[ 1194.438451]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.438455]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.438458]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.438461]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.438464]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.438467]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.438470]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.438475]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.438479]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.438482]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.438487]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.438490]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.438493]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.438497]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.438499]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.440539] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.440539]=20
[ 1194.440540] Leftover inexact backtrace:
              =20
[ 1194.440542]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.440549] ---[ end trace fbc5b38f9c7e090f ]---
[ 1194.440560] ------------[ cut here ]------------
[ 1194.440563] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.440565] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
21'
[ 1194.440567] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.440628]  libata
[ 1194.440629]  usbcore
[ 1194.440630]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.440640] Supported: No, Unsupported modules are loaded
[ 1194.440643] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.440644] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.440648] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.440649]=20
[ 1194.440650]  0000000000000000
[ 1194.440657]  ffffffff8131fe80 ffff8804172f7cd8 ffffffff81a31c80
[ 1194.440658]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.440661]  ffff88044b56d000
[ 1194.440663]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1194.440668] Call Trace:
[ 1194.440673]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.440677]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.440680]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.440685]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.440688]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.440691]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.440694]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.440698]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.440702]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.440707]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.440711]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.440714]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.440720]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.440723]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.440726]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.440729]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.440732]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.442750] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.442751]=20
[ 1194.442752] Leftover inexact backtrace:
              =20
[ 1194.442755]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.442757] ---[ end trace fbc5b38f9c7e0910 ]---
[ 1194.442773] ------------[ cut here ]------------
[ 1194.442777] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.442778] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
21'
[ 1194.442779] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.442837]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.442847] Supported: No, Unsupported modules are loaded
[ 1194.442849] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.442851] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.442855] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.442856]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.442860]  ffffffff8107df61 ffff88044b56d000 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.442863]  ffff88044aab2438
[ 1194.442864]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1194.442867] Call Trace:
[ 1194.442873]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.442876]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.442879]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.442882]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.442885]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.442889]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.442891]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.442896]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.442900]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.442903]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.442907]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.442910]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.442914]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.442917]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.442919]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.444946] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.444948]=20
[ 1194.444951] Leftover inexact backtrace:
              =20
[ 1194.444953]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.444958] ---[ end trace fbc5b38f9c7e0911 ]---
[ 1194.444967] ------------[ cut here ]------------
[ 1194.444970] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.444973] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
22'
[ 1194.444974] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.445029]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.445039] Supported: No, Unsupported modules are loaded
[ 1194.445041] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.445042] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.445046] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.445047]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.445052]  ffffffff8107df61
[ 1194.445052]  ffff880434290648
[ 1194.445053]  ffff8804172f7d28
[ 1194.445054]  ffffffffa00a9280
[ 1194.445054]=20
[ 1194.445055]  ffff88044d226000
[ 1194.445056]  0000000000000000
[ 1194.445056]  ffffffff8107dfdc
[ 1194.445057]  ffffffff81a2db58
[ 1194.445058]=20
[ 1194.445058] Call Trace:
[ 1194.445064]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.445068]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.445071]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.445075]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.445078]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.445081]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.445083]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.445087]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.445089]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.445094]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.445098]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.445101]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.445105]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.445109]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.445113]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.445116]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.445120]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.447134] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.447134]=20
[ 1194.447136] Leftover inexact backtrace:
              =20
[ 1194.447138]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.447140] ---[ end trace fbc5b38f9c7e0912 ]---
[ 1194.447155] ------------[ cut here ]------------
[ 1194.447158] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.447160] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
22'
[ 1194.447161] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.447220]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.447230] Supported: No, Unsupported modules are loaded
[ 1194.447232] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.447234] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.447238] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.447239]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.447243]  ffffffff8107df61
[ 1194.447244]  ffff88044d226000
[ 1194.447247]  ffff8804172f7d78 ffffffffa00a4d80
[ 1194.447248]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.447252] Call Trace:
[ 1194.447257]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.447261]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.447264]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.447267]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.447270]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.447273]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.447276]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.447280]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.447285]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.447288]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.447292]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.447295]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.447299]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.447302]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.447304]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.449328] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.449329]=20
[ 1194.449331] Leftover inexact backtrace:
              =20
[ 1194.449333]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.449339] ---[ end trace fbc5b38f9c7e0913 ]---
[ 1194.449348] ------------[ cut here ]------------
[ 1194.449350] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.449351] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
23'
[ 1194.449353] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.449414]  libata
[ 1194.449415]  usbcore
[ 1194.449415]  usb_common
[ 1194.449416]  sg
[ 1194.449417]  dm_multipath
[ 1194.449417]  dm_mod
[ 1194.449418]  scsi_dh_rdac
[ 1194.449419]  scsi_dh_emc
[ 1194.449419]  scsi_dh_alua
[ 1194.449420]  scsi_mod
[ 1194.449421]  efivarfs
[ 1194.449424]  autofs4 [last unloaded: ses]
[ 1194.449426] Supported: No, Unsupported modules are loaded
[ 1194.449429] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.449431] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.449437] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.449438]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.449441]  ffffffff8107df61
[ 1194.449441]  ffff880434290648
[ 1194.449442]  ffff8804172f7d28
[ 1194.449443]  ffffffffa00a9280
[ 1194.449444]=20
[ 1194.449445]  ffff88044c26f000
[ 1194.449446]  0000000000000000
[ 1194.449446]  ffffffff8107dfdc
[ 1194.449448]  ffffffff81a2db58
[ 1194.449450] Call Trace:
[ 1194.449455]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.449458]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.449461]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.449465]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.449469]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.449472]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.449474]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.449479]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.449482]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.449488]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.449492]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.449496]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.449502]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.449505]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.449508]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.449512]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.449516]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.451534] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.451535]=20
[ 1194.451537] Leftover inexact backtrace:
              =20
[ 1194.451540]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.451541] ---[ end trace fbc5b38f9c7e0914 ]---
[ 1194.451556] ------------[ cut here ]------------
[ 1194.451559] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.451561] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
23'
[ 1194.451562] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.451620]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.451629] Supported: No, Unsupported modules are loaded
[ 1194.451631] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.451633] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.451637] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.451638]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.451642]  ffffffff8107df61 ffff88044c26f000 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.451646]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.451650] Call Trace:
[ 1194.451655]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.451659]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.451662]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.451664]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.451667]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.451671]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.451674]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.451678]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.451682]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.451685]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.451689]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.451693]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.451696]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.451699]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.451702]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.453726] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.453728]=20
[ 1194.453729] Leftover inexact backtrace:
              =20
[ 1194.453732]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.453738] ---[ end trace fbc5b38f9c7e0915 ]---
[ 1194.453747] ------------[ cut here ]------------
[ 1194.453750] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.453752] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
24'
[ 1194.453753] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.453811]  libata
[ 1194.453812]  usbcore
[ 1194.453813]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.453822] Supported: No, Unsupported modules are loaded
[ 1194.453824] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.453826] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.453830] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.453831]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.453835]  ffffffff8107df61
[ 1194.453835]  ffff880434290648
[ 1194.453838]  ffff8804172f7d28 ffffffffa00a9280
[ 1194.453839]  ffff88044c620c00 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.453843] Call Trace:
[ 1194.453848]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.453852]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.453855]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.453858]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.453862]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.453865]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.453868]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.453871]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.453874]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.453880]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.453884]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.453887]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.453891]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.453894]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.453898]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.453901]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.453903]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.455929] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.455931]=20
[ 1194.455936] Leftover inexact backtrace:
              =20
[ 1194.455939]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.455944] ---[ end trace fbc5b38f9c7e0916 ]---
[ 1194.455960] ------------[ cut here ]------------
[ 1194.455963] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.455965] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
24'
[ 1194.455967] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.456038]  libata
[ 1194.456039]  usbcore
[ 1194.456040]  usb_common
[ 1194.456040]  sg
[ 1194.456042]  dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua s=
csi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.456051] Supported: No, Unsupported modules are loaded
[ 1194.456052] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.456054] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.456061] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.456063]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.456072]  ffffffff8107df61 ffff88044c620c00 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.456081]  ffff88044aab2438
[ 1194.456085]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1194.456086] Call Trace:
[ 1194.456091]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.456095]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.456098]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.456102]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.456106]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.456110]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.456114]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.456119]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.456123]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.456127]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.456132]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.456137]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.456141]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.456144]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.456148]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.458167] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.458167]=20
[ 1194.458167] Leftover inexact backtrace:
              =20
[ 1194.458171]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.458173] ---[ end trace fbc5b38f9c7e0917 ]---
[ 1194.458181] ------------[ cut here ]------------
[ 1194.458185] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.458186] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
25'
[ 1194.458188] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.458244]  libata
[ 1194.458244]  usbcore
[ 1194.458245]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.458254] Supported: No, Unsupported modules are loaded
[ 1194.458256] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.458258] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.458262] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.458263]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.458267]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.458270]  ffff88042c262c00 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.458275] Call Trace:
[ 1194.458280]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.458284]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.458287]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.458290]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.458293]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.458296]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.458299]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.458303]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.458306]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.458312]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.458316]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.458319]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.458323]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.458326]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.458331]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.458333]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.458336]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.460363] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.460364]=20
[ 1194.460364] Leftover inexact backtrace:
              =20
[ 1194.460367]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.460372] ---[ end trace fbc5b38f9c7e0918 ]---
[ 1194.460388] ------------[ cut here ]------------
[ 1194.460391] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.460392] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
25'
[ 1194.460393] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.460452]  libata
[ 1194.460453]  usbcore
[ 1194.460456]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.460464] Supported: No, Unsupported modules are loaded
[ 1194.460466] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.460467] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.460470] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.460472]=20
[ 1194.460478]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.460481]  ffffffff8107df61 ffff88042c262c00 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.460483]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.460488] Call Trace:
[ 1194.460493]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.460497]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.460500]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.460504]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.460508]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.460511]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.460514]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.460518]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.460522]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.460525]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.460530]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.460533]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.460538]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.460541]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.460545]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.462565] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.462565]=20
[ 1194.462567] Leftover inexact backtrace:
              =20
[ 1194.462569]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.462571] ---[ end trace fbc5b38f9c7e0919 ]---
[ 1194.462580] ------------[ cut here ]------------
[ 1194.462583] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.462584] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
26'
[ 1194.462586] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.462645]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.462655] Supported: No, Unsupported modules are loaded
[ 1194.462658] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.462659] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.462663] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.462664]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.462668]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.462672]  ffff88043a9cc000 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.462676] Call Trace:
[ 1194.462681]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.462684]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.462687]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.462690]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.462693]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.462696]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.462699]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.462702]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.462706]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.462710]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.462714]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.462718]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.462722]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.462725]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.462729]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.462731]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.462734]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.464757] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.464758]=20
[ 1194.464758] Leftover inexact backtrace:
              =20
[ 1194.464760]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.464769] ---[ end trace fbc5b38f9c7e091a ]---
[ 1194.464784] ------------[ cut here ]------------
[ 1194.464787] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.464788] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
26'
[ 1194.464788] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.464845]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.464853] Supported: No, Unsupported modules are loaded
[ 1194.464855] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.464857] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.464860] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.464861]=20
[ 1194.464862]  0000000000000000
[ 1194.464867]  ffffffff8131fe80 ffff8804172f7d28 ffffffff81a31c80
[ 1194.464868]  ffffffff8107df61 ffff88043a9cc000 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.464872]  ffff88044aab2438
[ 1194.464874]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1194.464876] Call Trace:
[ 1194.464881]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.464885]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.464888]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.464891]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.464894]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.464897]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.464900]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.464905]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.464910]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.464913]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.464917]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.464920]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.464923]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.464926]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.464930]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.466949] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.466950]=20
[ 1194.466950] Leftover inexact backtrace:
              =20
[ 1194.466954]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.466956] ---[ end trace fbc5b38f9c7e091b ]---
[ 1194.466964] ------------[ cut here ]------------
[ 1194.466967] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.466968] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
27'
[ 1194.466970] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.467026]  libata
[ 1194.467027]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.467037] Supported: No, Unsupported modules are loaded
[ 1194.467039] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.467040] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.467045] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.467046]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.467050]  ffffffff8107df61
[ 1194.467051]  ffff880434290648 ffff8804172f7d28 ffffffffa00a9280
[ 1194.467054]  ffff88044a805400
[ 1194.467057]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1194.467059] Call Trace:
[ 1194.467064]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.467067]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.467070]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.467073]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.467076]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.467080]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.467083]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.467086]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.467089]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.467094]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.467098]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.467101]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.467105]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.467108]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.467112]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.467115]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.467118]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.469143] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.469144]=20
[ 1194.469144] Leftover inexact backtrace:
              =20
[ 1194.469146]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.469152] ---[ end trace fbc5b38f9c7e091c ]---
[ 1194.469170] ------------[ cut here ]------------
[ 1194.469173] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.469174] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
27'
[ 1194.469174] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.469239]  libata
[ 1194.469241]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.469250] Supported: No, Unsupported modules are loaded
[ 1194.469252] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.469254] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.469258] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.469260]  0000000000000000
[ 1194.469260]  ffffffff8131fe80
[ 1194.469261]  ffff8804172f7d28
[ 1194.469264]  ffffffff81a31c80
[ 1194.469265]  ffffffff8107df61 ffff88044a805400 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.469269]  ffff88044aab2438
[ 1194.469270]  0000000000000000
[ 1194.469271]  ffffffff8107dfdc
[ 1194.469272]  ffffffff81a2db58
[ 1194.469272]=20
[ 1194.469273] Call Trace:
[ 1194.469279]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.469282]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.469287]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.469291]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.469295]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.469298]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.469300]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.469306]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.469310]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.469313]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.469317]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.469321]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.469325]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.469329]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.469332]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.471349] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.471350]=20
[ 1194.471350] Leftover inexact backtrace:
              =20
[ 1194.471354]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.471356] ---[ end trace fbc5b38f9c7e091d ]---
[ 1194.471365] ------------[ cut here ]------------
[ 1194.471369] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.471370] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
28'
[ 1194.471371] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.471431]  libata
[ 1194.471432]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.471441] Supported: No, Unsupported modules are loaded
[ 1194.471443] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.471445] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.471449] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.471450]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.471454]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.471458]  ffff88044c26d400 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.471462] Call Trace:
[ 1194.471467]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.471471]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.471474]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.471476]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.471480]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.471483]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.471486]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.471489]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.471493]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.471497]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.471502]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.471505]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.471509]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.471513]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.471516]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.471519]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.471522]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.473545] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.473547]=20
[ 1194.473548] Leftover inexact backtrace:
              =20
[ 1194.473550]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.473555] ---[ end trace fbc5b38f9c7e091e ]---
[ 1194.473573] ------------[ cut here ]------------
[ 1194.473576] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.473579] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
28'
[ 1194.473580] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.473632]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.473643] Supported: No, Unsupported modules are loaded
[ 1194.473644] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.473646] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.473651] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.473652]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.473655]  ffffffff8107df61 ffff88044c26d400 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.473659]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.473663] Call Trace:
[ 1194.473669]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.473673]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.473676]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.473679]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.473683]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.473685]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.473689]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.473693]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.473697]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.473700]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.473704]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.473708]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.473712]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.473715]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.473719]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.475736] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.475737]=20
[ 1194.475738] Leftover inexact backtrace:
              =20
[ 1194.475741]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.475742] ---[ end trace fbc5b38f9c7e091f ]---
[ 1194.475751] ------------[ cut here ]------------
[ 1194.475754] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.475756] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
29'
[ 1194.475757] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.475815]  libata
[ 1194.475815]  usbcore
[ 1194.475816]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.475825] Supported: No, Unsupported modules are loaded
[ 1194.475827] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.475828] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.475833] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.475834]  0000000000000000 ffffffff8131fe80 ffff8804172f7cd8 ffffffff=
81a31c80
[ 1194.475837]  ffffffff8107df61 ffff880434290648 ffff8804172f7d28 ffffffff=
a00a9280
[ 1194.475841]  ffff88043df77c00
[ 1194.475841]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1194.475845] Call Trace:
[ 1194.475850]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.475854]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.475857]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.475860]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.475863]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.475866]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.475869]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.475872]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.475875]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.475880]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1194.475884]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.475887]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.475891]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.475895]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.475898]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.475900]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.475904]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.477926] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.477926]=20
[ 1194.477928] Leftover inexact backtrace:
              =20
[ 1194.477931]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.477936] ---[ end trace fbc5b38f9c7e0920 ]---
[ 1194.477952] ------------[ cut here ]------------
[ 1194.477955] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.477956] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0:=
29'
[ 1194.477957] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.478017]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.478027] Supported: No, Unsupported modules are loaded
[ 1194.478029] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.478031] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.478035] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.478036]  0000000000000000 ffffffff8131fe80 ffff8804172f7d28 ffffffff=
81a31c80
[ 1194.478040]  ffffffff8107df61 ffff88043df77c00 ffff8804172f7d78 ffffffff=
a00a4d80
[ 1194.478043]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.478047] Call Trace:
[ 1194.478052]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.478056]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.478059]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.478061]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.478065]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.478068]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.478071]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.478075]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1194.478080]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1194.478083]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1194.478086]  [<ffffffffa01675b0>] sas_destruct_devices+0x60/0x90 [libsas=
]
[ 1194.478091]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.478094]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.478097]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.478099]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.480122] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.480124]=20
[ 1194.480125] Leftover inexact backtrace:
              =20
[ 1194.480128]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.480133] ---[ end trace fbc5b38f9c7e0921 ]---
[ 1194.480142] ------------[ cut here ]------------
[ 1194.480145] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.480147] sysfs group ffffffff81eff0e0 not found for kobject 'expander=
-1:0'
[ 1194.480148] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.480204]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.480212] Supported: No, Unsupported modules are loaded
[ 1194.480214] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.480215] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.480221] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.480224]  0000000000000000 ffffffff8131fe80 ffff8804172f7d30 ffffffff=
81a31c80
[ 1194.480228]  ffffffff8107df61
[ 1194.480228]  ffff880448c47800
[ 1194.480231]  ffff8804172f7d80 ffff88007dba8640
[ 1194.480234]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.480235] Call Trace:
[ 1194.480240]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.480244]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.480248]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.480251]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.480255]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.480258]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.480261]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.480265]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1194.480268]  [<ffffffff8130b85e>] bsg_unregister_queue+0x5e/0xa0
[ 1194.480273]  [<ffffffffa00a3039>] sas_rphy_remove+0x49/0x70 [scsi_transp=
ort_sas]
[ 1194.480279]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1194.480282]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1194.480286]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.480289]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.480293]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.480296]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.482310] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.482311]=20
[ 1194.482313] Leftover inexact backtrace:
              =20
[ 1194.482315]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.482317] ---[ end trace fbc5b38f9c7e0922 ]---
[ 1194.482367] ------------[ cut here ]------------
[ 1194.482371] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.482372] sysfs group ffffffff81eff0e0 not found for kobject 'expander=
-1:0'
[ 1194.482373] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.482431]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.482441] Supported: No, Unsupported modules are loaded
[ 1194.482443] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.482445] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.482450] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.482451]  0000000000000000 ffffffff8131fe80 ffff8804172f7d00 ffffffff=
81a31c80
[ 1194.482455]  ffffffff8107df61 ffff880434290718 ffff8804172f7d50 ffffffff=
a00a9000
[ 1194.482458]  ffff88044aab2438
[ 1194.482459]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1194.482462] Call Trace:
[ 1194.482468]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.482472]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.482475]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.482477]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.482481]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.482483]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.482487]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.482490]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.482493]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.482498]  [<ffffffffa00a3041>] sas_rphy_remove+0x51/0x70 [scsi_transp=
ort_sas]
[ 1194.482503]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1194.482507]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1194.482510]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.482514]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.482517]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.482520]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.484545] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.484546]=20
[ 1194.484546] Leftover inexact backtrace:
              =20
[ 1194.484549]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.484557] ---[ end trace fbc5b38f9c7e0923 ]---
[ 1194.484573] ------------[ cut here ]------------
[ 1194.484576] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.484579] sysfs group ffffffff81eff0e0 not found for kobject 'expander=
-1:0'
[ 1194.484580] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.484638]  libata
[ 1194.484639]  usbcore
[ 1194.484639]  usb_common
[ 1194.484640]  sg
[ 1194.484641]  dm_multipath
[ 1194.484641]  dm_mod
[ 1194.484642]  scsi_dh_rdac
[ 1194.484643]  scsi_dh_emc
[ 1194.484643]  scsi_dh_alua
[ 1194.484644]  scsi_mod
[ 1194.484645]  efivarfs
[ 1194.484645]  autofs4
[ 1194.484646]  [last unloaded: ses]
[ 1194.484646]=20
[ 1194.484647] Supported: No, Unsupported modules are loaded
[ 1194.484650] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.484652] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.484658] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.484665]  0000000000000000 ffffffff8131fe80 ffff8804172f7d00 ffffffff=
81a31c80
[ 1194.484668]  ffffffff8107df61 ffff8804342907e8 ffff8804172f7d50 ffffffff=
a00a90a0
[ 1194.484674]  ffff88044aab2438 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.484675] Call Trace:
[ 1194.484681]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.484685]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.484687]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.484691]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.484695]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.484698]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.484701]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.484705]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1194.484708]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1194.484714]  [<ffffffffa00a3041>] sas_rphy_remove+0x51/0x70 [scsi_transp=
ort_sas]
[ 1194.484718]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1194.484722]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1194.484727]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.484730]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.484732]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.484736]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.486753] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.486754]=20
[ 1194.486754] Leftover inexact backtrace:
              =20
[ 1194.486758]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.486760] ---[ end trace fbc5b38f9c7e0924 ]---
[ 1194.486775] ------------[ cut here ]------------
[ 1194.486778] WARNING: CPU: 11 PID: 3569 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1194.486779] sysfs group ffffffff81eff0e0 not found for kobject 'expander=
-1:0'
[ 1194.486780] Modules linked in: pm80xx(OEN) enclosure(OEN) st sr_mod cdro=
m fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev intel=
_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_=
intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul crc32=
_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_devint=
f igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_x86_=
64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_core c=
ryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor butt=
on btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit drm_km=
s_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc32c_i=
ntel libsas ahci libahci scsi_transport_sas ehci_pci drm ehci_hcd
[ 1194.486838]  libata
[ 1194.486838]  usbcore
[ 1194.486839]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: ses]
[ 1194.486848] Supported: No, Unsupported modules are loaded
[ 1194.486850] CPU: 11 PID: 3569 Comm: kworker/u24:0 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1194.486852] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1194.486856] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1194.486857]  0000000000000000 ffffffff8131fe80 ffff8804172f7d60 ffffffff=
81a31c80
[ 1194.486861]  ffffffff8107df61 ffff88044aab2438 ffff8804172f7db0 ffff8800=
7dba8640
[ 1194.486865]  ffff88043be23c00 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1194.486869] Call Trace:
[ 1194.486874]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1194.486877]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1194.486881]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1194.486884]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1194.486887]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1194.486890]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1194.486893]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1194.486897]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1194.486902]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1194.486905]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1194.486909]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1194.486912]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1194.486915]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1194.488939] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1194.488940]=20
[ 1194.488941] Leftover inexact backtrace:
              =20
[ 1194.488943]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1194.488950] ---[ end trace fbc5b38f9c7e0925 ]---
[ 1194.488958] pm80xx:: pm8001_dev_gone_notify 1206: found dev[4001:2] is g=
one. device ffff880415f80000  running req 250
[ 1194.488964] pm80xx:: pm8001_chip_abort_task 5206: cmd_tag =3D 0xa, abort=
 task tag =3D 0x0
[ 1194.488964] pm80xx:: send_task_abort 5189: dev id 4001 tag a=20
[ 1194.494890] pm80xx:: pm8001_mpi_task_abort_resp 4027: ABORT status =3D 0=
x0 task ffff88044b6e0700=20
[ 1194.494895] pm80xx:: pm8001_mpi_task_abort_resp 4043: ABORT IO_SUCCESS f=
or tag a ,task ffff88044b6e0700=20
[ 1260.056779] ------------[ cut here ]------------
[ 1260.056788] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.056789] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0'
[ 1260.056789] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.056848]  ehci_hcd
[ 1260.056848]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: enclo=
sure]
[ 1260.056860] Supported: No, Unsupported modules are loaded
[ 1260.056863] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.056864] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.056866]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1260.056870]  ffffffff8107df61 ffff880434290648 ffff88044be3bd50 ffffffff=
a00a9280
[ 1260.056874]  ffff880449c83800 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.056878] Call Trace:
[ 1260.056891]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.056896]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.056899]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.056904]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.056909]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.056913]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.056916]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.056921]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1260.056924]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1260.056933]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1260.056939]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.056943]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.056951]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.056966]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.056971]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.056974]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.056977]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.056981]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.056988]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.056994]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.056999]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.059232] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.059233]=20
[ 1260.059237] Leftover inexact backtrace:
              =20
[ 1260.059257] ---[ end trace fbc5b38f9c7e0926 ]---
[ 1260.059278] ------------[ cut here ]------------
[ 1260.059284] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.059286] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:0'
[ 1260.059286] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.059360]  ehci_hcd
[ 1260.059363]  libata
[ 1260.059363]  usbcore
[ 1260.059363]  usb_common
[ 1260.059364]  sg
[ 1260.059366]  dm_multipath
[ 1260.059367]  dm_mod
[ 1260.059368]  scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs aut=
ofs4 [last unloaded: enclosure]
[ 1260.059378] Supported: No, Unsupported modules are loaded
[ 1260.059381] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.059383] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.059386]  0000000000000000 ffffffff8131fe80 ffff88044be3bd50 ffffffff=
81a31c80
[ 1260.059390]  ffffffff8107df61
[ 1260.059390]  ffff880449c83800
[ 1260.059391]  ffff88044be3bda0
[ 1260.059394]  ffffffffa00a4d80
[ 1260.059394]=20
[ 1260.059395]  ffff88044b73a210
[ 1260.059397]  ffff88044e696000
[ 1260.059397]  ffffffff8107dfdc
[ 1260.059397]  ffffffff81a2db58
[ 1260.059398]=20
[ 1260.059398] Call Trace:
[ 1260.059408]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.059413]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.059418]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.059423]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.059428]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.059432]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.059435]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.059463]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1260.059468]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.059470]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.059476]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.059483]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.059487]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.059490]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.059493]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.059497]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.059504]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.059521]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.059525]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.062060] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.062064]=20
[ 1260.062066] Leftover inexact backtrace:
              =20
[ 1260.062094] ---[ end trace fbc5b38f9c7e0927 ]---
[ 1260.062104] ------------[ cut here ]------------
[ 1260.062108] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.062110] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:1'
[ 1260.062112] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.062232]  ehci_hcd
[ 1260.062233]  libata
[ 1260.062233]  usbcore
[ 1260.062234]  usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc =
scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: enclosure]
[ 1260.062245] Supported: No, Unsupported modules are loaded
[ 1260.062247] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.062248] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.062255]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1260.062260]  ffffffff8107df61 ffff880434290648 ffff88044be3bd50 ffffffff=
a00a9280
[ 1260.062265]  ffff880449749c00 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.062266] Call Trace:
[ 1260.062274]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.062280]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.062285]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.062293]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.062299]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.062306]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.062311]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.062317]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1260.062323]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1260.062330]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1260.062337]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.062343]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.062351]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.062359]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.062365]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.062370]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.062375]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.062380]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.062387]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.062392]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.062397]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.064915] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.064916]=20
[ 1260.064918] Leftover inexact backtrace:
              =20
[ 1260.064920] ---[ end trace fbc5b38f9c7e0928 ]---
[ 1260.064939] ------------[ cut here ]------------
[ 1260.064943] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.064945] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:1'
[ 1260.064947] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.065018]  ehci_hcd
[ 1260.065018]  libata
[ 1260.065019]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: enclosure]
[ 1260.065031] Supported: No, Unsupported modules are loaded
[ 1260.065035] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.065037] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.065039]  0000000000000000 ffffffff8131fe80 ffff88044be3bd50 ffffffff=
81a31c80
[ 1260.065044]  ffffffff8107df61
[ 1260.065045]  ffff880449749c00
[ 1260.065049]  ffff88044be3bda0 ffffffffa00a4d80
[ 1260.065050]  ffff88044b73a210 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.065066] Call Trace:
[ 1260.065072]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.065076]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.065079]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.065081]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.065085]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.065088]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.065091]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.065096]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1260.065100]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.065103]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.065109]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.065127]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.065132]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.065137]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.065141]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.065146]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.065153]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.065158]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.065163]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.067484] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.067486]=20
[ 1260.067487] Leftover inexact backtrace:
              =20
[ 1260.067493] ---[ end trace fbc5b38f9c7e0929 ]---
[ 1260.067519] ------------[ cut here ]------------
[ 1260.067526] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.067531] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:2'
[ 1260.067532] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.067615]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: enclosure]
[ 1260.067638] Supported: No, Unsupported modules are loaded
[ 1260.067641] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.067643] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.067644]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1260.067648]  ffffffff8107df61
[ 1260.067649]  ffff880434290648 ffff88044be3bd50 ffffffffa00a9280
[ 1260.067654]  ffff880449c6e400
[ 1260.067654]  ffff88044e696000
[ 1260.067657]  ffffffff8107dfdc ffffffff81a2db58
[ 1260.067659] Call Trace:
[ 1260.067667]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.067671]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.067675]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.067679]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.067696]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.067699]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.067702]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.067706]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1260.067709]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1260.067714]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1260.067720]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.067723]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.067729]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.067736]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.067740]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.067744]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.067747]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.067751]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.067758]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.067762]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.067765]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.069840] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.069842]=20
[ 1260.069842] Leftover inexact backtrace:
              =20
[ 1260.069846] ---[ end trace fbc5b38f9c7e092a ]---
[ 1260.069872] ------------[ cut here ]------------
[ 1260.069878] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.069879] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:2'
[ 1260.069880] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.069940]  ehci_hcd
[ 1260.069941]  libata
[ 1260.069942]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: enclosure]
[ 1260.069951] Supported: No, Unsupported modules are loaded
[ 1260.069954] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.069955] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.069956]  0000000000000000 ffffffff8131fe80 ffff88044be3bd50 ffffffff=
81a31c80
[ 1260.069960]  ffffffff8107df61 ffff880449c6e400 ffff88044be3bda0 ffffffff=
a00a4d80
[ 1260.069964]  ffff88044b73a210 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.069967] Call Trace:
[ 1260.069976]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.069980]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.069983]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.069988]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.069993]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.069996]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.069999]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.070005]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1260.070012]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.070015]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.070023]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.070034]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.070039]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.070042]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.070046]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.070050]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.070058]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.070065]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.070071]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.072120] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.072120]=20
[ 1260.072121] Leftover inexact backtrace:
              =20
[ 1260.072130] ---[ end trace fbc5b38f9c7e092b ]---
[ 1260.072144] ------------[ cut here ]------------
[ 1260.072147] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.072148] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:3'
[ 1260.072149] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.072207]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: enclosure]
[ 1260.072217] Supported: No, Unsupported modules are loaded
[ 1260.072219] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.072221] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.072222]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1260.072226]  ffffffff8107df61 ffff880434290648 ffff88044be3bd50 ffffffff=
a00a9280
[ 1260.072230]  ffff8804409ed400 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.072233] Call Trace:
[ 1260.072239]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.072243]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.072246]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.072249]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.072253]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.072256]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.072259]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.072263]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1260.072267]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1260.072272]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1260.072276]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.072279]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.072285]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.072291]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.072295]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.072299]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.072302]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.072306]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.072312]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.072315]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.072319]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.074342] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.074344]=20
[ 1260.074345] Leftover inexact backtrace:
              =20
[ 1260.074350] ---[ end trace fbc5b38f9c7e092c ]---
[ 1260.074366] ------------[ cut here ]------------
[ 1260.074369] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.074371] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:3'
[ 1260.074431] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.074440]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: enclosure]
[ 1260.074441] Supported: No, Unsupported modules are loaded
[ 1260.074443] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.074445] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.074448]  0000000000000000 ffffffff8131fe80 ffff88044be3bd50 ffffffff=
81a31c80
[ 1260.074451]  ffffffff8107df61 ffff8804409ed400 ffff88044be3bda0 ffffffff=
a00a4d80
[ 1260.074458]  ffff88044b73a210 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.074460] Call Trace:
[ 1260.074466]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.074470]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.074475]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.074478]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.074481]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.074484]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.074488]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.074493]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1260.074497]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.074500]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.074506]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.074513]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.074517]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.074521]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.074525]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.074529]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.074535]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.074539]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.074542]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.076561] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.076562]=20
[ 1260.076562] Leftover inexact backtrace:
              =20
[ 1260.076565] ---[ end trace fbc5b38f9c7e092d ]---
[ 1260.076573] ------------[ cut here ]------------
[ 1260.076576] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.076578] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:4'
[ 1260.076579] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.076637]  ehci_hcd
[ 1260.076638]  libata
[ 1260.076638]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: enclosure]
[ 1260.076647] Supported: No, Unsupported modules are loaded
[ 1260.076649] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.076651] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.076652]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1260.076655]  ffffffff8107df61 ffff880434290648 ffff88044be3bd50 ffffffff=
a00a9280
[ 1260.076659]  ffff880448f2fc00 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.076662] Call Trace:
[ 1260.076668]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.076672]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.076674]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.076677]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.076681]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.076684]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.076687]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.076690]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1260.076694]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1260.076699]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1260.076703]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.076707]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.076712]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.076718]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.076722]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.076725]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.076729]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.076733]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.076738]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.076742]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.076746]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.078770] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.078772]=20
[ 1260.078774] Leftover inexact backtrace:
              =20
[ 1260.078780] ---[ end trace fbc5b38f9c7e092e ]---
[ 1260.078795] ------------[ cut here ]------------
[ 1260.078798] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.078800] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:4'
[ 1260.078801] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.078860]  ehci_hcd
[ 1260.078861]  libata
[ 1260.078862]  usbcore
[ 1260.078862]  usb_common
[ 1260.078863]  sg
[ 1260.078864]  dm_multipath
[ 1260.078864]  dm_mod
[ 1260.078865]  scsi_dh_rdac
[ 1260.078866]  scsi_dh_emc
[ 1260.078866]  scsi_dh_alua
[ 1260.078867]  scsi_mod
[ 1260.078868]  efivarfs
[ 1260.078868]  autofs4
[ 1260.078872]  [last unloaded: enclosure]
[ 1260.078873] Supported: No, Unsupported modules are loaded
[ 1260.078876] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.078877] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.078879]  0000000000000000 ffffffff8131fe80 ffff88044be3bd50 ffffffff=
81a31c80
[ 1260.078883]  ffffffff8107df61
[ 1260.078884]  ffff880448f2fc00
[ 1260.078884]  ffff88044be3bda0
[ 1260.078887]  ffffffffa00a4d80
[ 1260.078888]  ffff88044b73a210 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.078891] Call Trace:
[ 1260.078897]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.078901]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.078904]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.078907]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.078910]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.078915]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.078918]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.078923]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1260.078927]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.078930]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.078937]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.078944]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.078948]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.078951]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.078954]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.078957]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.078964]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.078968]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.078971]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.080989] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.080990]=20
[ 1260.080990] Leftover inexact backtrace:
              =20
[ 1260.080993] ---[ end trace fbc5b38f9c7e092f ]---
[ 1260.081001] ------------[ cut here ]------------
[ 1260.081004] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.081006] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:5'
[ 1260.081007] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.081065]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: enclosure]
[ 1260.081075] Supported: No, Unsupported modules are loaded
[ 1260.081077] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.081079] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.081080]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1260.081084]  ffffffff8107df61 ffff880434290648 ffff88044be3bd50 ffffffff=
a00a9280
[ 1260.081088]  ffff880430a83400 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.081091] Call Trace:
[ 1260.081097]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.081100]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.081103]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.081106]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.081109]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.081113]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.081115]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.081119]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1260.081122]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1260.081127]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1260.081132]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.081135]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.081140]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.081147]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.081151]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.081154]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.081158]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.081161]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.081167]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.081171]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.081174]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.083208] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.083211]=20
[ 1260.083212] Leftover inexact backtrace:
              =20
[ 1260.083220] ---[ end trace fbc5b38f9c7e0930 ]---
[ 1260.083236] ------------[ cut here ]------------
[ 1260.083240] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.083242] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:5'
[ 1260.083242] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.083305]  ehci_hcd
[ 1260.083305]  libata
[ 1260.083306]  usbcore
[ 1260.083306]  usb_common
[ 1260.083306]  sg
[ 1260.083307]  dm_multipath
[ 1260.083308]  dm_mod
[ 1260.083309]  scsi_dh_rdac
[ 1260.083309]  scsi_dh_emc
[ 1260.083310]  scsi_dh_alua
[ 1260.083311]  scsi_mod
[ 1260.083311]  efivarfs
[ 1260.083312]  autofs4
[ 1260.083313]  [last unloaded: enclosure]
[ 1260.083313]=20
[ 1260.083314] Supported: No, Unsupported modules are loaded
[ 1260.083317] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.083319] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.083325]  0000000000000000 ffffffff8131fe80 ffff88044be3bd50 ffffffff=
81a31c80
[ 1260.083334]  ffffffff8107df61 ffff880430a83400 ffff88044be3bda0 ffffffff=
a00a4d80
[ 1260.083339]  ffff88044b73a210 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.083339] Call Trace:
[ 1260.083346]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.083349]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.083351]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.083355]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.083359]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.083363]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.083366]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.083372]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1260.083377]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.083380]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.083387]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.083394]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.083398]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.083402]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.083406]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.083409]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.083415]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.083420]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.083424]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.085441] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.085441]=20
[ 1260.085442] Leftover inexact backtrace:
              =20
[ 1260.085445] ---[ end trace fbc5b38f9c7e0931 ]---
[ 1260.085453] ------------[ cut here ]------------
[ 1260.085457] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.085459] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:6'
[ 1260.085460] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.085517]  ehci_hcd
[ 1260.085518]  libata
[ 1260.085519]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: enclosure]
[ 1260.085528] Supported: No, Unsupported modules are loaded
[ 1260.085530] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.085532] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.085533]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1260.085537]  ffffffff8107df61
[ 1260.085540]  ffff880434290648 ffff88044be3bd50 ffffffffa00a9280
[ 1260.085541]  ffff88042c42ac00 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.085545] Call Trace:
[ 1260.085550]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.085554]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.085557]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.085559]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.085563]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.085567]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.085570]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.085574]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1260.085577]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1260.085581]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1260.085586]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.085589]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.085594]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.085601]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.085605]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.085608]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.085611]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.085615]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.085621]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.085625]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.085628]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.087663] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.087664]=20
[ 1260.087664] Leftover inexact backtrace:
              =20
[ 1260.087671] ---[ end trace fbc5b38f9c7e0932 ]---
[ 1260.087691] ------------[ cut here ]------------
[ 1260.087697] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.087699] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:6'
[ 1260.087701] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.087764]  ehci_hcd
[ 1260.087764]  libata
[ 1260.087765]  usbcore
[ 1260.087765]  usb_common
[ 1260.087767]  sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alu=
a scsi_mod efivarfs autofs4 [last unloaded: enclosure]
[ 1260.087776] Supported: No, Unsupported modules are loaded
[ 1260.087778] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.087780] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.087782]  0000000000000000 ffffffff8131fe80 ffff88044be3bd50 ffffffff=
81a31c80
[ 1260.087788]  ffffffff8107df61
[ 1260.087789]  ffff88042c42ac00 ffff88044be3bda0 ffffffffa00a4d80
[ 1260.087792]  ffff88044b73a210
[ 1260.087792]  ffff88044e696000
[ 1260.087793]  ffffffff8107dfdc
[ 1260.087794]  ffffffff81a2db58
[ 1260.087794]=20
[ 1260.087795] Call Trace:
[ 1260.087802]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.087806]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.087811]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.087816]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.087820]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.087823]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.087826]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.087832]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1260.087837]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.087839]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.087846]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.087855]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.087860]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.087864]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.087867]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.087870]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.087876]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.087880]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.087884]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.089913] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.089913]=20
[ 1260.089914] Leftover inexact backtrace:
              =20
[ 1260.089916] ---[ end trace fbc5b38f9c7e0933 ]---
[ 1260.089927] ------------[ cut here ]------------
[ 1260.089931] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.089932] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:7'
[ 1260.089933] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.089994]  ehci_hcd
[ 1260.089995]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: enclo=
sure]
[ 1260.090008] Supported: No, Unsupported modules are loaded
[ 1260.090011] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.090013] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.090015]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1260.090019]  ffffffff8107df61 ffff880434290648 ffff88044be3bd50 ffffffff=
a00a9280
[ 1260.090023]  ffff88044d3f6400
[ 1260.090027]  ffff88044e696000 ffffffff8107dfdc ffffffff81a2db58
[ 1260.090029] Call Trace:
[ 1260.090037]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.090044]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.090048]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.090052]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.090059]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.090064]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.090068]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.090075]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1260.090080]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1260.090090]  [<ffffffffa00a3abe>] sas_phy_delete+0x1e/0x40 [scsi_transpo=
rt_sas]
[ 1260.090096]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.090102]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.090114]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.090124]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.090130]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.090134]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.090138]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.090142]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.090149]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.090153]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.090157]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.092181] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.092182]=20
[ 1260.092183] Leftover inexact backtrace:
              =20
[ 1260.092189] ---[ end trace fbc5b38f9c7e0934 ]---
[ 1260.092206] ------------[ cut here ]------------
[ 1260.092209] WARNING: CPU: 6 PID: 3952 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1260.092211] sysfs group ffffffff81eff0e0 not found for kobject 'phy-1:7'
[ 1260.092212] Modules linked in: ses enclosure(OEN) pm80xx(OEN-) st sr_mod=
 cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev =
intel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp=
 kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul =
crc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_d=
evintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes=
_x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_c=
ore cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor=
 button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit d=
rm_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc=
32c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1260.092270]  ehci_hcd
[ 1260.092270]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: enclo=
sure]
[ 1260.092280] Supported: No, Unsupported modules are loaded
[ 1260.092283] CPU: 6 PID: 3952 Comm: rmmod Tainted: G        W  OE   NX 4.=
4.73-5-default #1
[ 1260.092284] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1260.092285]  0000000000000000 ffffffff8131fe80 ffff88044be3bd50 ffffffff=
81a31c80
[ 1260.092289]  ffffffff8107df61 ffff88044d3f6400 ffff88044be3bda0 ffffffff=
a00a4d80
[ 1260.092293]  ffff88044b73a210 ffff88044e696000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1260.092296] Call Trace:
[ 1260.092302]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1260.092305]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1260.092309]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1260.092311]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1260.092315]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1260.092319]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1260.092322]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1260.092327]  [<ffffffffa00a3ac6>] sas_phy_delete+0x26/0x40 [scsi_transpo=
rt_sas]
[ 1260.092331]  [<ffffffffa00a4db0>] do_sas_phy_delete+0x30/0x40 [scsi_tran=
sport_sas]
[ 1260.092334]  [<ffffffff8146544d>] device_for_each_child+0x3d/0x60
[ 1260.092339]  [<ffffffffa07091d2>] pm8001_pci_remove+0x42/0x190 [pm80xx]
[ 1260.092345]  [<ffffffff8136b536>] pci_device_remove+0x36/0xb0
[ 1260.092349]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1260.092353]  [<ffffffff8146a2bb>] driver_detach+0xab/0xb0
[ 1260.092356]  [<ffffffff814692c1>] bus_remove_driver+0x51/0xd0
[ 1260.092360]  [<ffffffff8136b333>] pci_unregister_driver+0x23/0x80
[ 1260.092366]  [<ffffffffa0727c14>] pm8001_exit+0x11/0x29 [pm80xx]
[ 1260.092369]  [<ffffffff8110aa87>] SyS_delete_module+0x187/0x210
[ 1260.092373]  [<ffffffff8160916e>] entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.094409] DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x12/0x6d
[ 1260.094410]=20
[ 1260.094410] Leftover inexact backtrace:
              =20
[ 1260.094419] ---[ end trace fbc5b38f9c7e0935 ]---
[ 1276.473294] pm80xx 0000:07:00.0: driver version 0.1.37 / 1.4.0-11117=20
[ 1276.473298] pm80xx 0000:07:00.0: driver build on Jul 31 2017 16:09:49 [d=
rv chip ref 5]
[ 1277.469620] scsi host1: pm80xx
[ 1278.818549] pm80xx:: pm8001_init_sas_add_and_spinup_config 1711: Spinup =
group from Seeprom is 255, reset to 8
[ 1278.819132] PHY Setting Version# 1.0
[ 1294.500847] sas: phy-1:0 added to port-1:0, phy_mask:0x1 (50030480004e1e=
bf)
[ 1294.500856] sas: phy1 matched wide port0
[ 1294.500862] sas: phy-1:1 added to port-1:0, phy_mask:0x3 (50030480004e1e=
bf)
[ 1294.500863] sas: phy3 matched wide port0
[ 1294.500869] sas: phy-1:3 added to port-1:0, phy_mask:0xb (50030480004e1e=
bf)
[ 1294.500880] sas: DOING DISCOVERY on port 0, pid:3569
[ 1294.502808] sas: ex 50030480004e1ebf phy00:S:A attached: 50000d110787b00=
0 (host)
[ 1294.503046] sas: ex 50030480004e1ebf phy01:S:0 attached: 000000000000000=
0 (no device)
[ 1294.503289] sas: ex 50030480004e1ebf phy02:S:A attached: 50000d110787b00=
0 (host)
[ 1294.503638] sas: ex 50030480004e1ebf phy03:S:A attached: 50000d110787b00=
0 (host)
[ 1294.503993] sas: ex 50030480004e1ebf phy04:U:0 attached: 000000000000000=
0 (no device)
[ 1294.504318] sas: ex 50030480004e1ebf phy05:U:0 attached: 000000000000000=
0 (no device)
[ 1294.504613] sas: ex 50030480004e1ebf phy06:U:0 attached: 000000000000000=
0 (no device)
[ 1294.504942] sas: ex 50030480004e1ebf phy07:U:0 attached: 000000000000000=
0 (no device)
[ 1294.505332] sas: ex 50030480004e1ebf phy08:D:1 attached: 000000000000000=
0 (no device)
[ 1294.505730] sas: ex 50030480004e1ebf phy09:D:1 attached: 000000000000000=
0 (no device)
[ 1294.506107] sas: ex 50030480004e1ebf phy10:D:1 attached: 000000000000000=
0 (no device)
[ 1294.506570] sas: ex 50030480004e1ebf phy11:D:1 attached: 000000000000000=
0 (no device)
[ 1294.507045] sas: ex 50030480004e1ebf phy12:U:0 attached: 000000000000000=
0 (no device)
[ 1294.507494] sas: ex 50030480004e1ebf phy13:U:0 attached: 000000000000000=
0 (no device)
[ 1294.507888] sas: ex 50030480004e1ebf phy14:U:0 attached: 000000000000000=
0 (no device)
[ 1294.508243] sas: ex 50030480004e1ebf phy15:U:0 attached: 000000000000000=
0 (no device)
[ 1294.508674] sas: ex 50030480004e1ebf phy16:U:0 attached: 000000000000000=
0 (no device)
[ 1294.509234] sas: ex 50030480004e1ebf phy17:U:0 attached: 000000000000000=
0 (no device)
[ 1294.509782] sas: ex 50030480004e1ebf phy18:U:0 attached: 000000000000000=
0 (no device)
[ 1294.510236] sas: ex 50030480004e1ebf phy19:U:0 attached: 000000000000000=
0 (no device)
[ 1294.510802] sas: ex 50030480004e1ebf phy20:U:0 attached: 000000000000000=
0 (no device)
[ 1294.511836] sas: ex 50030480004e1ebf phy21:U:0 attached: 000000000000000=
0 (no device)
[ 1294.512414] sas: ex 50030480004e1ebf phy22:U:0 attached: 000000000000000=
0 (no device)
[ 1294.512932] sas: ex 50030480004e1ebf phy23:U:0 attached: 000000000000000=
0 (no device)
[ 1294.513469] sas: ex 50030480004e1ebf phy24:D:1 attached: 000000000000000=
0 (no device)
[ 1294.513986] sas: ex 50030480004e1ebf phy25:D:1 attached: 000000000000000=
0 (no device)
[ 1294.514525] sas: ex 50030480004e1ebf phy26:D:1 attached: 000000000000000=
0 (no device)
[ 1294.515299] sas: ex 50030480004e1ebf phy27:D:1 attached: 000000000000000=
0 (no device)
[ 1294.515640] sas: ex 50030480004e1ebf phy28:D:A attached: 50030480004e1eb=
d (host+target)
[ 1294.515973] sas: ex 50030480004e1ebf phy29:D:0 attached: 000000000000000=
0 (no device)
[ 1294.571050] sas: DONE DISCOVERY on port 0, pid:3569, result:0
[ 1294.574618] scsi 1:0:0:0: Enclosure         LSI      SAS2X28          0e=
0b PQ: 0 ANSI: 5
[ 1294.574773] scsi 1:0:0:0: Power-on or device reset occurred
[ 1294.653781] ses 1:0:0:0: Attached Enclosure device
[ 1294.653876] ses 1:0:0:0: Attached scsi generic sg1 type 13
[ 1294.662544] sas: phy2 matched wide port0
[ 1294.662550] sas: phy-1:2 added to port-1:0, phy_mask:0xf (50030480004e1e=
bf)
[ 1303.291720] sas: broadcast received: 9
[ 1303.291726] sas: broadcast received: 9
[ 1303.291726] sas: broadcast received: 9
[ 1303.291727] sas: broadcast received: 9
[ 1303.291729] sas: REVALIDATING DOMAIN on port 0, pid:112
[ 1303.292212] sas: Expander phy change count has changed
[ 1303.292506] sas: ex 50030480004e1ebf phy1 originated BROADCAST(CHANGE)
[ 1303.292509] sas: ex 50030480004e1ebf phy1 new device attached
[ 1303.292608] sas: ex 50030480004e1ebf phy01:S:A attached: 50000d110787b00=
0 (host)
[ 1303.292930] sas: ex 50030480004e1ebf phy4 originated BROADCAST(CHANGE)
[ 1303.292933] sas: ex 50030480004e1ebf phy4 new device attached
[ 1303.293030] sas: ex 50030480004e1ebf phy04:U:A attached: 5003048000a317b=
f (smp)
[ 1303.293886] sas: ex 5003048000a317bf phy00:S:A attached: 50030480004e1eb=
f (smp)
[ 1303.294039] sas: ex 5003048000a317bf phy01:S:A attached: 50030480004e1eb=
f (smp)
[ 1303.294221] sas: ex 5003048000a317bf phy02:S:A attached: 50030480004e1eb=
f (smp)
[ 1303.294453] sas: ex 5003048000a317bf phy03:S:A attached: 50030480004e1eb=
f (smp)
[ 1303.294681] sas: ex 5003048000a317bf phy04:U:0 attached: 000000000000000=
0 (no device)
[ 1303.294978] sas: ex 5003048000a317bf phy05:U:0 attached: 000000000000000=
0 (no device)
[ 1303.295251] sas: ex 5003048000a317bf phy06:U:0 attached: 000000000000000=
0 (no device)
[ 1303.295522] sas: ex 5003048000a317bf phy07:U:0 attached: 000000000000000=
0 (no device)
[ 1303.295788] sas: ex 5003048000a317bf phy08:D:1 attached: 000000000000000=
0 (no device)
[ 1303.296053] sas: ex 5003048000a317bf phy09:D:1 attached: 000000000000000=
0 (no device)
[ 1303.296366] sas: ex 5003048000a317bf phy10:D:1 attached: 000000000000000=
0 (no device)
[ 1303.296707] sas: ex 5003048000a317bf phy11:D:1 attached: 000000000000000=
0 (no device)
[ 1303.297091] sas: ex 5003048000a317bf phy12:U:A attached: 5003048000a317a=
c (stp pending)
[ 1303.297463] sas: ex 5003048000a317bf phy13:U:0 attached: 000000000000000=
0 (no device)
[ 1303.297882] sas: ex 5003048000a317bf phy14:U:0 attached: 000000000000000=
0 (no device)
[ 1303.298312] sas: ex 5003048000a317bf phy15:U:0 attached: 000000000000000=
0 (no device)
[ 1303.298699] sas: ex 5003048000a317bf phy16:U:0 attached: 000000000000000=
0 (no device)
[ 1303.299110] sas: ex 5003048000a317bf phy17:U:0 attached: 000000000000000=
0 (no device)
[ 1303.299563] sas: ex 5003048000a317bf phy18:U:0 attached: 000000000000000=
0 (no device)
[ 1303.299998] sas: ex 5003048000a317bf phy19:U:0 attached: 000000000000000=
0 (no device)
[ 1303.300441] sas: ex 5003048000a317bf phy20:U:0 attached: 000000000000000=
0 (no device)
[ 1303.300916] sas: ex 5003048000a317bf phy21:U:0 attached: 000000000000000=
0 (no device)
[ 1303.301458] sas: ex 5003048000a317bf phy22:U:0 attached: 000000000000000=
0 (no device)
[ 1303.301989] sas: ex 5003048000a317bf phy23:U:0 attached: 000000000000000=
0 (no device)
[ 1303.302440] sas: ex 5003048000a317bf phy24:D:1 attached: 000000000000000=
0 (no device)
[ 1303.302897] sas: ex 5003048000a317bf phy25:D:1 attached: 000000000000000=
0 (no device)
[ 1303.307209] sas: ex 5003048000a317bf phy26:D:1 attached: 000000000000000=
0 (no device)
[ 1303.307602] sas: ex 5003048000a317bf phy27:D:1 attached: 000000000000000=
0 (no device)
[ 1303.308028] sas: ex 5003048000a317bf phy28:D:A attached: 5003048000a317b=
d (host+target)
[ 1303.308371] sas: ex 5003048000a317bf phy29:D:0 attached: 000000000000000=
0 (no device)
[ 1303.308609] sas: ex 50030480004e1ebf has self-configuring routing table
[ 1303.308862] sas: ex 50030480004e1ebf has self-configuring routing table
[ 1303.363243] sas: ex 50030480004e1ebf has self-configuring routing table
[ 1303.363391] sas: ex 50030480004e1ebf phy5 originated BROADCAST(CHANGE)
[ 1303.363397] sas: ex 50030480004e1ebf phy5 new device attached
[ 1303.363559] sas: ex 50030480004e1ebf phy05:U:A attached: 5003048000a317b=
f (smp)
[ 1303.363729] sas: ex 50030480004e1ebf phy6 originated BROADCAST(CHANGE)
[ 1303.363734] sas: ex 50030480004e1ebf phy6 new device attached
[ 1303.364014] sas: ex 50030480004e1ebf phy06:U:A attached: 5003048000a317b=
f (smp)
[ 1303.364287] sas: ex 50030480004e1ebf phy7 originated BROADCAST(CHANGE)
[ 1303.364291] sas: ex 50030480004e1ebf phy7 new device attached
[ 1303.364489] sas: ex 50030480004e1ebf phy07:U:A attached: 5003048000a317b=
f (smp)
[ 1303.376018] sas: Expander phys DID NOT change
[ 1303.376161] sas: done REVALIDATING DOMAIN on port 0, pid:112, res 0x0
[ 1303.376215] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[ 1303.376231] sas: ata8: end_device-1:1:12: dev error handler
[ 1303.376246] pm80xx:: pm8001_chip_abort_task 5206: cmd_tag =3D 0xa, abort=
 task tag =3D 0x0
[ 1303.376246] pm80xx:: send_task_abort 5189: dev id 4004 tag a=20
[ 1303.387628] pm80xx:: pm8001_mpi_task_abort_resp 4027: ABORT status =3D 0=
x0 task ffff880072625e00=20
[ 1303.387632] pm80xx:: pm8001_mpi_task_abort_resp 4043: ABORT IO_SUCCESS f=
or tag a ,task ffff880072625e00=20
[ 1305.390157] pm80xx:: pm8001_I_T_nexus_reset 1366:  for device[4004]:rc=
=3D0
[ 1311.593625] sas: ata: ex 5003048000a317bf phy12:U:A attached: 5003048000=
a317ac (stp)
[ 1311.639870] ata8.00: ATA-8: TOSHIBA MG03ACA100, FL1A, max UDMA/100
[ 1311.639873] ata8.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2)
[ 1311.640703] ata8.00: configured for UDMA/100
[ 1311.640758] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries=
: 1
[ 1311.651489] scsi 1:0:1:0: Direct-Access     ATA      TOSHIBA MG03ACA1 FL=
1A PQ: 0 ANSI: 5
[ 1311.651971] sd 1:0:1:0: Attached scsi generic sg2 type 0
[ 1311.651977] sd 1:0:1:0: [sdb] 1953525168 512-byte logical blocks: (1.00 =
TB/932 GiB)
[ 1311.651997] sd 1:0:1:0: [sdb] Write Protect is off
[ 1311.652001] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[ 1311.652078] sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[ 1311.657462] scsi 1:0:2:0: Enclosure         LSI      SAS2X28          0e=
12 PQ: 0 ANSI: 5
[ 1311.657559] scsi 1:0:2:0: Power-on or device reset occurred
[ 1311.659589] ses 1:0:2:0: Attached Enclosure device
[ 1311.659759] ses 1:0:2:0: Attached scsi generic sg3 type 13
[ 1311.660704]  sdb: sdb1 sdb2
[ 1311.661224] sd 1:0:1:0: [sdb] Attached SCSI disk
[ 1311.671175] sas: broadcast received: 9
[ 1311.671177] sas: broadcast received: 9
[ 1311.671178] sas: broadcast received: 9
[ 1311.671179] sas: broadcast received: 9
[ 1311.671180] sas: REVALIDATING DOMAIN on port 0, pid:112
[ 1311.674695] sas: Expander phys DID NOT change
[ 1311.676023] sas: Expander phy change count has changed
[ 1311.677342] sas: ex 5003048000a317bf phy12 originated BROADCAST(CHANGE)
[ 1311.677560] sas: ex 5003048000a317bf phy 0xc broadcast flutter
[ 1311.682498] sas: Expander phys DID NOT change
[ 1311.682622] sas: done REVALIDATING DOMAIN on port 0, pid:112, res 0x0
[ 1328.683045] sas: broadcast received: 11
[ 1328.683055] sas: broadcast received: 11
[ 1328.683056] sas: broadcast received: 11
[ 1328.683057] sas: broadcast received: 11
[ 1328.683059] sas: REVALIDATING DOMAIN on port 0, pid:112
[ 1328.686315] sas: Expander phys DID NOT change
[ 1328.686385] sas: done REVALIDATING DOMAIN on port 0, pid:112, res 0x0
[ 1337.475297] sas: broadcast received: 11
[ 1337.475302] sas: broadcast received: 11
[ 1337.475303] sas: broadcast received: 11
[ 1337.475304] sas: broadcast received: 11
[ 1337.475306] sas: REVALIDATING DOMAIN on port 0, pid:112
[ 1337.478781] sas: Expander phys DID NOT change
[ 1337.478849] sas: done REVALIDATING DOMAIN on port 0, pid:112, res 0x0
[ 1363.694530] sas: broadcast received: 11
[ 1363.694535] sas: broadcast received: 11
[ 1363.694536] sas: broadcast received: 11
[ 1363.694539] sas: broadcast received: 11
[ 1363.694541] sas: REVALIDATING DOMAIN on port 0, pid:112
[ 1363.697656] sas: Expander phys DID NOT change
[ 1363.697725] sas: done REVALIDATING DOMAIN on port 0, pid:112, res 0x0
[ 1398.706160] sas: broadcast received: 11
[ 1398.706167] sas: broadcast received: 11
[ 1398.706167] sas: broadcast received: 11
[ 1398.706168] sas: broadcast received: 11
[ 1398.706169] sas: REVALIDATING DOMAIN on port 0, pid:4065
[ 1398.709421] sas: Expander phys DID NOT change
[ 1398.709499] sas: done REVALIDATING DOMAIN on port 0, pid:4065, res 0x0
[ 1424.666858] sas: broadcast received: 9
[ 1424.666869] sas: broadcast received: 9
[ 1424.666870] sas: broadcast received: 9
[ 1424.666871] sas: broadcast received: 9
[ 1424.666873] sas: REVALIDATING DOMAIN on port 0, pid:4065
[ 1424.670214] sas: Expander phys DID NOT change
[ 1424.671583] sas: Expander phy change count has changed
[ 1424.674319] pm80xx:: mpi_smp_completion 3153: smp IO status 0xe
[ 1424.674369] sas: smp_execute_task: task to dev 5003048000a317bf response=
: 0x0 status 0x8
[ 1426.908253] pm80xx:: mpi_smp_completion 3153: smp IO status 0x46
[ 1426.908290] pm80xx:: pm8001_chip_abort_task 5206: cmd_tag =3D 0xa, abort=
 task tag =3D 0x0
[ 1426.908290] pm80xx:: send_task_abort 5189: dev id 4004 tag a=20
[ 1426.908313] sas: smp_execute_task: task to dev 5003048000a317bf response=
: 0x0 status 0x87
[ 1426.912565] pm80xx:: pm8001_mpi_task_abort_resp 4027: ABORT status =3D 0=
x0 task ffff88044aa39900=20
[ 1426.912571] pm80xx:: pm8001_mpi_task_abort_resp 4043: ABORT IO_SUCCESS f=
or tag a ,task ffff88044aa39900=20
[ 1426.912576] pm80xx:: mpi_smp_completion 3153: smp IO status 0x39
[ 1426.912627] sas: smp_execute_task: task to dev 5003048000a317bf response=
: 0x0 status 0x80
[ 1426.912747] pm80xx:: mpi_smp_completion 3153: smp IO status 0x39
[ 1426.912779] sas: smp_execute_task: task to dev 5003048000a317bf response=
: 0x0 status 0x80
[ 1426.912942] pm80xx:: mpi_smp_completion 3153: smp IO status 0x39
[ 1426.912973] sas: smp_execute_task: task to dev 5003048000a317bf response=
: 0x0 status 0x80
[ 1426.913135] pm80xx:: mpi_smp_completion 3153: smp IO status 0x39
[ 1426.913167] sas: smp_execute_task: task to dev 5003048000a317bf response=
: 0x0 status 0x80
[ 1426.913697] sas: Expander phy change count has changed
[ 1426.914325] sas: ex 50030480004e1ebf phy4 originated BROADCAST(CHANGE)
[ 1426.914329] sas: phy4 part of wide port with phy5
[ 1426.914543] sas: ex 50030480004e1ebf phy5 originated BROADCAST(CHANGE)
[ 1426.914546] sas: phy5 part of wide port with phy6
[ 1426.914746] sas: ex 50030480004e1ebf phy6 originated BROADCAST(CHANGE)
[ 1426.914748] sas: phy6 part of wide port with phy7
[ 1426.914948] sas: ex 50030480004e1ebf phy7 originated BROADCAST(CHANGE)
[ 1426.921046] sas: Expander phys DID NOT change
[ 1426.921050] sas: done REVALIDATING DOMAIN on port 0, pid:4065, res 0xfff=
fffba
[ 1426.921053] sas: broadcast received: 9
[ 1426.921056] sas: broadcast received: 9
[ 1426.921057] sas: broadcast received: 9
[ 1426.921058] sas: broadcast received: 9
[ 1426.921069] ------------[ cut here ]------------
[ 1426.921079] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.921080] sysfs group ffffffff81eff0e0 not found for kobject '1:0:1:0'
[ 1426.921081] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.921196]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1426.921209] Supported: No, Unsupported modules are loaded
[ 1426.921212] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.921214] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.921222] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.921224]  0000000000000000 ffffffff8131fe80 ffff88044be3bcc0 ffffffff=
81a31c80
[ 1426.921228]  ffffffff8107df61
[ 1426.921229]  ffff88044a805400
[ 1426.921232]  ffff88044be3bd10 ffff88044b4db000
[ 1426.921234]  ffff880415d39980 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.921238] Call Trace:
[ 1426.921251]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.921257]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.921260]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.921265]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.921271]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.921275]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.921279]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.921283]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1426.921286]  [<ffffffff8130b85e>] bsg_unregister_queue+0x5e/0xa0
[ 1426.921301]  [<ffffffffa00261c5>] __scsi_remove_device+0xa5/0xd0 [scsi_m=
od]
[ 1426.921313]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.921322]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.921329]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.921336]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.921341]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.921347]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.921353]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.921356]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.921361]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.923604] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.923604]=20
[ 1426.923608] Leftover inexact backtrace:
              =20
[ 1426.923612]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.923623] ---[ end trace fbc5b38f9c7e0936 ]---
[ 1426.923682] ------------[ cut here ]------------
[ 1426.923686] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.923687] sysfs group ffffffff81eff0e0 not found for kobject '1:0:1:0'
[ 1426.923689] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.923748]  ehci_hcd
[ 1426.923749]  libata
[ 1426.923749]  usbcore
[ 1426.923750]  usb_common
[ 1426.923751]  sg
[ 1426.923751]  dm_multipath
[ 1426.923752]  dm_mod
[ 1426.923753]  scsi_dh_rdac
[ 1426.923753]  scsi_dh_emc
[ 1426.923754]  scsi_dh_alua
[ 1426.923761]  scsi_mod efivarfs autofs4 [last unloaded: pm80xx]
[ 1426.923763] Supported: No, Unsupported modules are loaded
[ 1426.923766] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.923768] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.923772] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.923776]  0000000000000000 ffffffff8131fe80 ffff88044be3bcd0 ffffffff=
81a31c80
[ 1426.923779]  ffffffff8107df61 ffff880415d39c60 ffff88044be3bd20 ffff8804=
4b4db000
[ 1426.923783]  ffff880415d39980 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.923784] Call Trace:
[ 1426.923792]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.923795]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.923798]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.923800]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.923804]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.923807]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.923810]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.923813]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1426.923823]  [<ffffffffa00261d1>] __scsi_remove_device+0xb1/0xd0 [scsi_m=
od]
[ 1426.923834]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.923841]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.923846]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.923851]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.923855]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.923859]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.923863]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.923867]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.923870]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.925991] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.925992]=20
[ 1426.925993] Leftover inexact backtrace:
              =20
[ 1426.925997]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.926000] ---[ end trace fbc5b38f9c7e0937 ]---
[ 1426.926007] ------------[ cut here ]------------
[ 1426.926010] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.926012] sysfs group ffffffff81eff0e0 not found for kobject 'sg2'
[ 1426.926013] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.926073]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1426.926083] Supported: No, Unsupported modules are loaded
[ 1426.926086] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.926087] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.926092] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.926093]  0000000000000000 ffffffff8131fe80 ffff88044be3bc30 ffffffff=
81a31c80
[ 1426.926097]  ffffffff8107df61
[ 1426.926097]  ffff88007257e000 ffff88044be3bc80 ffff880072415990
[ 1426.926101]  ffff880415d39980
[ 1426.926101]  ffff8800724159a0
[ 1426.926104]  ffffffff8107dfdc ffffffff81a2db58
[ 1426.926105] Call Trace:
[ 1426.926111]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.926116]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.926118]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.926122]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.926126]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.926129]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.926132]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.926135]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1426.926138]  [<ffffffff81465afa>] device_destroy+0x3a/0x40
[ 1426.926142]  [<ffffffffa00bd59b>] sg_remove_device+0xdb/0x150 [sg]
[ 1426.926146]  [<ffffffff814658ba>] device_del+0xca/0x240
[ 1426.926149]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1426.926159]  [<ffffffffa00261d1>] __scsi_remove_device+0xb1/0xd0 [scsi_m=
od]
[ 1426.926167]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.926174]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.926179]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.926185]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.926189]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.926193]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.926197]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.926199]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.926202]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.928311] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.928312]=20
[ 1426.928313] Leftover inexact backtrace:
              =20
[ 1426.928317]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.928327] ---[ end trace fbc5b38f9c7e0938 ]---
[ 1426.928398] ------------[ cut here ]------------
[ 1426.928403] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.928406] sysfs group ffffffff81eff0e0 not found for kobject 'Slot 01'
[ 1426.928407] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.928473]  ehci_hcd
[ 1426.928475]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: pm80x=
x]
[ 1426.928486] Supported: No, Unsupported modules are loaded
[ 1426.928490] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.928491] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.928499] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.928503]  0000000000000000 ffffffff8131fe80 ffff88044be3bc58 ffffffff=
81a31c80
[ 1426.928508]  ffffffff8107df61 ffff88044c39c308 ffff88044be3bca8 ffff8804=
4c39c310
[ 1426.928511]  ffff88044c39c018 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.928513] Call Trace:
[ 1426.928521]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.928524]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.928527]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.928531]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.928534]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.928538]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.928542]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.928547]  [<ffffffffa0145d0c>] enclosure_remove_device+0x7c/0xa8 [enc=
losure]
[ 1426.928564]  [<ffffffffa02390d7>] ses_intf_remove+0x87/0xc0 [ses]
[ 1426.928568]  [<ffffffff814658ba>] device_del+0xca/0x240
[ 1426.928571]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1426.928583]  [<ffffffffa00261d1>] __scsi_remove_device+0xb1/0xd0 [scsi_m=
od]
[ 1426.928592]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.928599]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.928605]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.928609]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.928613]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.928618]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.928621]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.928624]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.928627]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.930759] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.930760]=20
[ 1426.930762] Leftover inexact backtrace:
              =20
[ 1426.930765]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.930766] ---[ end trace fbc5b38f9c7e0939 ]---
[ 1426.930777] ------------[ cut here ]------------
[ 1426.930781] WARNING: CPU: 11 PID: 4065 at ../lib/kobject.c:244 kobject_a=
dd_internal+0x113/0x330()
[ 1426.930783] kobject_add_internal failed for Slot 01 (error: -2 parent: 1=
:0:2:0)
[ 1426.930784] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.930845]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1426.930856] Supported: No, Unsupported modules are loaded
[ 1426.930858] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.930860] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.930865] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.930866]  0000000000000000 ffffffff8131fe80 ffff88044be3bbb8 ffffffff=
81a47493
[ 1426.930870]  ffffffff8107df61 ffff88044c39c320 ffff88044be3bc08 00000000=
fffffffe
[ 1426.930873]  ffff88044c39c028 ffff880437633000 ffffffff8107dfdc ffffffff=
81a47898
[ 1426.930877] Call Trace:
[ 1426.930883]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.930887]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.930889]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.930892]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.930896]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.930899]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.930903]  [<ffffffff81322973>] kobject_add_internal+0x113/0x330
[ 1426.930906]  [<ffffffff81322d65>] kobject_add+0x65/0xb0
[ 1426.930910]  [<ffffffff81466b63>] device_add+0x123/0x5f0
[ 1426.930914]  [<ffffffffa02390d7>] ses_intf_remove+0x87/0xc0 [ses]
[ 1426.930920]  [<ffffffff814658ba>] device_del+0xca/0x240
[ 1426.930923]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1426.930932]  [<ffffffffa00261d1>] __scsi_remove_device+0xb1/0xd0 [scsi_m=
od]
[ 1426.930940]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.930947]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.930952]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.930957]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.930961]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.930964]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.930968]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.930971]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.930974]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.933112] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.933114]=20
[ 1426.933115] Leftover inexact backtrace:
              =20
[ 1426.933119]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.933129] ---[ end trace fbc5b38f9c7e093a ]---
[ 1426.933162] ------------[ cut here ]------------
[ 1426.933165] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.933167] sysfs group ffffffff81eff0e0 not found for kobject '1:0:1:0'
[ 1426.933207] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.933214]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1426.933215] Supported: No, Unsupported modules are loaded
[ 1426.933218] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.933220] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.933226] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.933233]  0000000000000000 ffffffff8131fe80 ffff88044be3bce0 ffffffff=
81a31c80
[ 1426.933235]  ffffffff8107df61 ffff880415d39800 ffff88044be3bd30 ffff8804=
4b4db000
[ 1426.933239]  ffff880079001428 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.933244] Call Trace:
[ 1426.933253]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.933260]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.933266]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.933271]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.933277]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.933283]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.933288]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.933301]  [<ffffffffa00261e1>] __scsi_remove_device+0xc1/0xd0 [scsi_m=
od]
[ 1426.933316]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.933329]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.933337]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.933345]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.933351]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.933357]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.933363]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.933369]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.933373]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.935549] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.935550]=20
[ 1426.935550] Leftover inexact backtrace:
              =20
[ 1426.935553]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.935564] ---[ end trace fbc5b38f9c7e093b ]---
[ 1426.935580] ------------[ cut here ]------------
[ 1426.935584] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.935585] sysfs group ffffffff81eff0e0 not found for kobject '1:0:1:0'
[ 1426.935586] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.935649]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1426.935661] Supported: No, Unsupported modules are loaded
[ 1426.935663] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.935665] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.935671] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.935673]  0000000000000000 ffffffff8131fe80 ffff88044be3bc28 ffffffff=
81a31c80
[ 1426.935677]  ffffffff8107df61
[ 1426.935681]  ffff88044d148400 ffff88044be3bc78 ffff88044d148410
[ 1426.935684]  ffff880415d39980 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.935685] Call Trace:
[ 1426.935692]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.935696]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.935699]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.935703]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.935707]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.935710]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.935713]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.935717]  [<ffffffffa0117f50>] sd_remove+0x50/0xc0 [sd_mod]
[ 1426.935723]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1426.935728]  [<ffffffff8146a1ee>] device_release_driver+0x1e/0x30
[ 1426.935731]  [<ffffffff81468f79>] bus_remove_device+0xf9/0x170
[ 1426.935734]  [<ffffffff81465917>] device_del+0x127/0x240
[ 1426.935744]  [<ffffffffa00261e1>] __scsi_remove_device+0xc1/0xd0 [scsi_m=
od]
[ 1426.935753]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.935759]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.935765]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.935770]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.935774]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.935779]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.935783]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.935786]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.935789]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.937859] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.937861]=20
[ 1426.937862] Leftover inexact backtrace:
              =20
[ 1426.937865]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.937866] ---[ end trace fbc5b38f9c7e093c ]---
[ 1426.937904] ------------[ cut here ]------------
[ 1426.937910] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.937912] sysfs group ffffffff81eff0e0 not found for kobject 'sdb2'
[ 1426.937913] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.937980]  ehci_hcd
[ 1426.937981]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: pm80x=
x]
[ 1426.937993] Supported: No, Unsupported modules are loaded
[ 1426.937996] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.937998] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.938004] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.938006]  0000000000000000
[ 1426.938008]  ffffffff8131fe80 ffff88044be3bbe0 ffffffff81a31c80
[ 1426.938011]  ffffffff8107df61 ffff88044b649400 ffff88044be3bc30 ffff8804=
4dbc1088
[ 1426.938016]  ffff88044dbc1078 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.938020] Call Trace:
[ 1426.938029]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.938035]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.938041]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.938044]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.938051]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.938055]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.938061]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.938068]  [<ffffffff81303307>] delete_partition+0x47/0x60
[ 1426.938073]  [<ffffffff81301934>] del_gendisk+0xc4/0x270
[ 1426.938080]  [<ffffffffa0117f5c>] sd_remove+0x5c/0xc0 [sd_mod]
[ 1426.938087]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1426.938093]  [<ffffffff8146a1ee>] device_release_driver+0x1e/0x30
[ 1426.938097]  [<ffffffff81468f79>] bus_remove_device+0xf9/0x170
[ 1426.938103]  [<ffffffff81465917>] device_del+0x127/0x240
[ 1426.938116]  [<ffffffffa00261e1>] __scsi_remove_device+0xc1/0xd0 [scsi_m=
od]
[ 1426.938130]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.938142]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.938151]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.938159]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.938166]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.938173]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.938178]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.938182]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.938188]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.940280] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.940281]=20
[ 1426.940282] Leftover inexact backtrace:
              =20
[ 1426.940284]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.940294] ---[ end trace fbc5b38f9c7e093d ]---
[ 1426.940365] ------------[ cut here ]------------
[ 1426.940371] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 sysfs_=
remove_groups+0x29/0x40()
[ 1426.940372] sysfs group ffffffff81e911c0 not found for kobject 'sdb2'
[ 1426.940372] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.940432]  ehci_hcd
[ 1426.940432]  libata
[ 1426.940433]  usbcore
[ 1426.940433]  usb_common
[ 1426.940435]  sg dm_multipath dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alu=
a scsi_mod efivarfs autofs4 [last unloaded: pm80xx]
[ 1426.940442] Supported: No, Unsupported modules are loaded
[ 1426.940445] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.940447] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.940451] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.940453]=20
[ 1426.940460]  0000000000000000 ffffffff8131fe80 ffff88044be3bb98 ffffffff=
81a31c80
[ 1426.940463]  ffffffff8107df61 0000000000000002 ffff88044be3bbe8 ffff8804=
4b649438
[ 1426.940468]  ffffffff81eddbc0 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.940469] Call Trace:
[ 1426.940476]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.940480]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.940483]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.940487]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.940490]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.940494]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.940498]  [<ffffffff8127e869>] sysfs_remove_groups+0x29/0x40
[ 1426.940503]  [<ffffffff81464fe8>] device_remove_attrs+0x58/0x80
[ 1426.940507]  [<ffffffff8146590f>] device_del+0x11f/0x240
[ 1426.940510]  [<ffffffff81303307>] delete_partition+0x47/0x60
[ 1426.940514]  [<ffffffff81301934>] del_gendisk+0xc4/0x270
[ 1426.940517]  [<ffffffffa0117f5c>] sd_remove+0x5c/0xc0 [sd_mod]
[ 1426.940522]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1426.940525]  [<ffffffff8146a1ee>] device_release_driver+0x1e/0x30
[ 1426.940528]  [<ffffffff81468f79>] bus_remove_device+0xf9/0x170
[ 1426.940531]  [<ffffffff81465917>] device_del+0x127/0x240
[ 1426.940541]  [<ffffffffa00261e1>] __scsi_remove_device+0xc1/0xd0 [scsi_m=
od]
[ 1426.940550]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.940558]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.940563]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.940568]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.940572]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.940576]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.940579]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.940583]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.940586]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.942605] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.942608]=20
[ 1426.942609] Leftover inexact backtrace:
              =20
[ 1426.942613]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.942615] ---[ end trace fbc5b38f9c7e093e ]---
[ 1426.942640] ------------[ cut here ]------------
[ 1426.942644] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.942646] sysfs group ffffffff81eff0e0 not found for kobject 'sdb1'
[ 1426.942647] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.942705]  ehci_hcd
[ 1426.942706]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: pm80x=
x]
[ 1426.942716] Supported: No, Unsupported modules are loaded
[ 1426.942720] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.942723] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.942729] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.942730]  0000000000000000 ffffffff8131fe80 ffff88044be3bbe0 ffffffff=
81a31c80
[ 1426.942736]  ffffffff8107df61 ffff88007daee400 ffff88044be3bc30 ffff8804=
4dbc1088
[ 1426.942740]  ffff88044dbc1078
[ 1426.942741]  ffff880437633000 ffffffff8107dfdc ffffffff81a2db58
[ 1426.942746] Call Trace:
[ 1426.942754]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.942759]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.942764]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.942768]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.942772]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.942777]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.942782]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.942786]  [<ffffffff81303307>] delete_partition+0x47/0x60
[ 1426.942791]  [<ffffffff81301934>] del_gendisk+0xc4/0x270
[ 1426.942797]  [<ffffffffa0117f5c>] sd_remove+0x5c/0xc0 [sd_mod]
[ 1426.942802]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1426.942807]  [<ffffffff8146a1ee>] device_release_driver+0x1e/0x30
[ 1426.942812]  [<ffffffff81468f79>] bus_remove_device+0xf9/0x170
[ 1426.942816]  [<ffffffff81465917>] device_del+0x127/0x240
[ 1426.942830]  [<ffffffffa00261e1>] __scsi_remove_device+0xc1/0xd0 [scsi_m=
od]
[ 1426.942842]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.942853]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.942861]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.942868]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.942874]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.942878]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.942885]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.942889]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.942893]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.944967] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.944967]=20
[ 1426.944968] Leftover inexact backtrace:
              =20
[ 1426.944971]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.944980] ---[ end trace fbc5b38f9c7e093f ]---
[ 1426.945008] ------------[ cut here ]------------
[ 1426.945012] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 sysfs_=
remove_groups+0x29/0x40()
[ 1426.945014] sysfs group ffffffff81e911c0 not found for kobject 'sdb1'
[ 1426.945015] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.945069]  ehci_hcd
[ 1426.945070]  libata
[ 1426.945070]  usbcore
[ 1426.945071]  usb_common
[ 1426.945071]  sg
[ 1426.945072]  dm_multipath
[ 1426.945073]  dm_mod scsi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efiva=
rfs autofs4 [last unloaded: pm80xx]
[ 1426.945081] Supported: No, Unsupported modules are loaded
[ 1426.945083] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.945085] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.945088] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.945089]=20
[ 1426.945090]  0000000000000000
[ 1426.945091]  ffffffff8131fe80
[ 1426.945096]  ffff88044be3bb98 ffffffff81a31c80
[ 1426.945104]  ffffffff8107df61 0000000000000002 ffff88044be3bbe8 ffff8800=
7daee438
[ 1426.945108]  ffffffff81eddbc0 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.945109] Call Trace:
[ 1426.945116]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.945119]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.945122]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.945126]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.945129]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.945133]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.945136]  [<ffffffff8127e869>] sysfs_remove_groups+0x29/0x40
[ 1426.945141]  [<ffffffff81464fe8>] device_remove_attrs+0x58/0x80
[ 1426.945145]  [<ffffffff8146590f>] device_del+0x11f/0x240
[ 1426.945149]  [<ffffffff81303307>] delete_partition+0x47/0x60
[ 1426.945153]  [<ffffffff81301934>] del_gendisk+0xc4/0x270
[ 1426.945157]  [<ffffffffa0117f5c>] sd_remove+0x5c/0xc0 [sd_mod]
[ 1426.945163]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1426.945166]  [<ffffffff8146a1ee>] device_release_driver+0x1e/0x30
[ 1426.945170]  [<ffffffff81468f79>] bus_remove_device+0xf9/0x170
[ 1426.945173]  [<ffffffff81465917>] device_del+0x127/0x240
[ 1426.945181]  [<ffffffffa00261e1>] __scsi_remove_device+0xc1/0xd0 [scsi_m=
od]
[ 1426.945189]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.945197]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.945203]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.945207]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.945212]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.945215]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.945219]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.945222]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.945225]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.947369] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.947370]=20
[ 1426.947372] Leftover inexact backtrace:
              =20
[ 1426.947376]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.947385] ---[ end trace fbc5b38f9c7e0940 ]---
[ 1426.947409] ------------[ cut here ]------------
[ 1426.947414] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 blk_un=
register_queue+0x6f/0xa0()
[ 1426.947415] sysfs group ffffffff81e911c0 not found for kobject 'sdb'
[ 1426.947417] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.947475]  ehci_hcd
[ 1426.947477]  libata
[ 1426.947477]  usbcore
[ 1426.947478]  usb_common
[ 1426.947480]  sg
[ 1426.947480]  dm_multipath
[ 1426.947480]  dm_mod
[ 1426.947483]  scsi_dh_rdac
[ 1426.947483]  scsi_dh_emc
[ 1426.947484]  scsi_dh_alua
[ 1426.947484]  scsi_mod
[ 1426.947484]  efivarfs
[ 1426.947490]  autofs4 [last unloaded: pm80xx]
[ 1426.947491] Supported: No, Unsupported modules are loaded
[ 1426.947496] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.947498] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.947504] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.947511]  0000000000000000 ffffffff8131fe80 ffff88044be3bc10 ffffffff=
81a31c80
[ 1426.947515]  ffffffff8107df61 ffff88044d9a2928 ffff88044be3bc60 ffff8804=
4dbc1078
[ 1426.947521]  0000000000800010 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.947522] Call Trace:
[ 1426.947528]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.947532]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.947534]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.947538]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.947542]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.947547]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.947550]  [<ffffffff812f25ef>] blk_unregister_queue+0x6f/0xa0
[ 1426.947554]  [<ffffffff8130199e>] del_gendisk+0x12e/0x270
[ 1426.947559]  [<ffffffffa0117f5c>] sd_remove+0x5c/0xc0 [sd_mod]
[ 1426.947564]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1426.947567]  [<ffffffff8146a1ee>] device_release_driver+0x1e/0x30
[ 1426.947571]  [<ffffffff81468f79>] bus_remove_device+0xf9/0x170
[ 1426.947574]  [<ffffffff81465917>] device_del+0x127/0x240
[ 1426.947584]  [<ffffffffa00261e1>] __scsi_remove_device+0xc1/0xd0 [scsi_m=
od]
[ 1426.947593]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.947602]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.947608]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.947612]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.947617]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.947620]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.947624]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.947628]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.947631]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.949828] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.949830]=20
[ 1426.949831] Leftover inexact backtrace:
              =20
[ 1426.949835]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.949837] ---[ end trace fbc5b38f9c7e0941 ]---
[ 1426.949863] ------------[ cut here ]------------
[ 1426.949868] WARNING: CPU: 11 PID: 4065 at ../fs/sysfs/group.c:237 device=
_del+0x54/0x240()
[ 1426.949869] sysfs group ffffffff81eff0e0 not found for kobject 'sdb'
[ 1426.949870] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1426.949931]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1426.949941] Supported: No, Unsupported modules are loaded
[ 1426.949944] CPU: 11 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  O=
E   NX 4.4.73-5-default #1
[ 1426.949946] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1426.949952] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1426.949953]  0000000000000000 ffffffff8131fe80 ffff88044be3bbf0 ffffffff=
81a31c80
[ 1426.949958]  ffffffff8107df61
[ 1426.949958]  ffffffff81f55cc0
[ 1426.949961]  ffff88044be3bc40 0000000000000000
[ 1426.949962]  ffff880415d39980 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1426.949966] Call Trace:
[ 1426.949974]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1426.949978]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1426.949981]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1426.949984]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1426.949988]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1426.949991]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1426.949994]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1426.949999]  [<ffffffff81301ac5>] del_gendisk+0x255/0x270
[ 1426.950003]  [<ffffffffa0117f5c>] sd_remove+0x5c/0xc0 [sd_mod]
[ 1426.950009]  [<ffffffff8146a13d>] __device_release_driver+0x8d/0x120
[ 1426.950013]  [<ffffffff8146a1ee>] device_release_driver+0x1e/0x30
[ 1426.950016]  [<ffffffff81468f79>] bus_remove_device+0xf9/0x170
[ 1426.950019]  [<ffffffff81465917>] device_del+0x127/0x240
[ 1426.950031]  [<ffffffffa00261e1>] __scsi_remove_device+0xc1/0xd0 [scsi_m=
od]
[ 1426.950040]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1426.950048]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1426.950053]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1426.950058]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1426.950063]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1426.950066]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1426.950071]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1426.950074]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1426.950078]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1426.952200] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1426.952201]=20
[ 1426.952202] Leftover inexact backtrace:
              =20
[ 1426.952205]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1426.952213] ---[ end trace fbc5b38f9c7e0942 ]---
[ 1426.952279] sd 1:0:1:0: [sdb] Synchronizing SCSI cache
[ 1426.952355] sd 1:0:1:0: [sdb] Synchronize Cache(10) failed: Result: host=
byte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
[ 1426.952359] sd 1:0:1:0: [sdb] Stopping disk
[ 1426.952383] sd 1:0:1:0: [sdb] Start/Stop Unit failed: Result: hostbyte=
=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
[ 1427.023250] ------------[ cut here ]------------
[ 1427.023261] WARNING: CPU: 0 PID: 4065 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1427.023262] sysfs group ffffffff81eff0e0 not found for kobject 'target1:=
0:1'
[ 1427.023263] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1427.023323]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1427.023335] Supported: No, Unsupported modules are loaded
[ 1427.023338] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.023340] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.023347] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.023349]  0000000000000000 ffffffff8131fe80 ffff88044be3bcf8 ffffffff=
81a31c80
[ 1427.023353]  ffffffff8107df61
[ 1427.023355]  ffff880079001400 ffff88044be3bd48 ffff88044b4db000
[ 1427.023358]  ffff88044b4db000 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1427.023361] Call Trace:
[ 1427.023374]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1427.023379]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1427.023382]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1427.023386]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1427.023391]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1427.023395]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1427.023398]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.023412]  [<ffffffffa0022118>] scsi_target_reap_ref_release+0x28/0x40=
 [scsi_mod]
[ 1427.023422]  [<ffffffffa00263cc>] scsi_remove_target+0x17c/0x1b0 [scsi_m=
od]
[ 1427.023429]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1427.023435]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.023440]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.023445]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.023450]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.023453]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.023457]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.025525] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.025525]=20
[ 1427.025526] Leftover inexact backtrace:
              =20
[ 1427.025529]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.025531] ---[ end trace fbc5b38f9c7e0943 ]---
[ 1427.025561] ------------[ cut here ]------------
[ 1427.025565] WARNING: CPU: 0 PID: 4065 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1427.025566] sysfs group ffffffff81eff0e0 not found for kobject 'end_devi=
ce-1:1:12'
[ 1427.025566] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1427.025617]  ehci_hcd
[ 1427.025617]  libata
[ 1427.025618]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: pm80xx]
[ 1427.025627] Supported: No, Unsupported modules are loaded
[ 1427.025630] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.025631] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.025636] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.025637]  0000000000000000 ffffffff8131fe80 ffff88044be3bd30 ffffffff=
81a31c80
[ 1427.025641]  ffffffff8107df61 ffff880079001c00 ffff88044be3bd80 ffff8804=
4a0a8640
[ 1427.025644]  ffff88044b4db000 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1427.025647] Call Trace:
[ 1427.025653]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1427.025657]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1427.025660]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1427.025663]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1427.025667]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1427.025670]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1427.025673]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.025676]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1427.025680]  [<ffffffff8130b85e>] bsg_unregister_queue+0x5e/0xa0
[ 1427.025684]  [<ffffffffa00a3039>] sas_rphy_remove+0x49/0x70 [scsi_transp=
ort_sas]
[ 1427.025688]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.025692]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.025696]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.025699]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.025703]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.025705]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.027741] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.027743]=20
[ 1427.027743] Leftover inexact backtrace:
              =20
[ 1427.027747]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.027758] ---[ end trace fbc5b38f9c7e0944 ]---
[ 1427.028077] ------------[ cut here ]------------
[ 1427.028084] WARNING: CPU: 0 PID: 4065 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1427.028089] sysfs group ffffffff81eff0e0 not found for kobject 'end_devi=
ce-1:1:12'
[ 1427.028090] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1427.028173]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1427.028173] Supported: No, Unsupported modules are loaded
[ 1427.028176] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.028178] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.028184] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.028187]  0000000000000000
[ 1427.028187]  ffffffff8131fe80
[ 1427.028191]  ffff88044be3bd00 ffffffff81a31c80
[ 1427.028194]  ffffffff8107df61 ffff88006cca2718 ffff88044be3bd50 ffffffff=
a00a9000
[ 1427.028198]  ffff88044b4db000 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1427.028198] Call Trace:
[ 1427.028208]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1427.028212]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1427.028215]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1427.028219]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1427.028223]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1427.028227]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1427.028231]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.028235]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1427.028239]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1427.028244]  [<ffffffffa00a3041>] sas_rphy_remove+0x51/0x70 [scsi_transp=
ort_sas]
[ 1427.028249]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.028254]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.028258]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.028262]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.028264]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.028268]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.031201] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.031203]=20
[ 1427.031203] Leftover inexact backtrace:
              =20
[ 1427.031207]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.031217] ---[ end trace fbc5b38f9c7e0945 ]---
[ 1427.031244] ------------[ cut here ]------------
[ 1427.031248] WARNING: CPU: 0 PID: 4065 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1427.031250] sysfs group ffffffff81eff0e0 not found for kobject 'end_devi=
ce-1:1:12'
[ 1427.031251] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1427.031309]  ehci_hcd
[ 1427.031310]  libata
[ 1427.031310]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: pm80xx]
[ 1427.031320] Supported: No, Unsupported modules are loaded
[ 1427.031322] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.031324] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.031329] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.031330]  0000000000000000 ffffffff8131fe80 ffff88044be3bd00 ffffffff=
81a31c80
[ 1427.031333]  ffffffff8107df61
[ 1427.031334]  ffff88006cca2780 ffff88044be3bd50 ffffffffa00a9140
[ 1427.031337]  ffff88044b4db000
[ 1427.031338]  0000000000000000 ffffffff8107dfdc ffffffff81a2db58
[ 1427.031342] Call Trace:
[ 1427.031348]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1427.031352]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1427.031355]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1427.031358]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1427.031362]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1427.031365]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1427.031368]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.031372]  [<ffffffff8146e62a>] transport_remove_classdev+0x4a/0x60
[ 1427.031376]  [<ffffffff8146e0b6>] attribute_container_device_trigger+0xa=
6/0xb0
[ 1427.031382]  [<ffffffffa00a3041>] sas_rphy_remove+0x51/0x70 [scsi_transp=
ort_sas]
[ 1427.031387]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.031391]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.031395]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.031398]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.031402]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.031405]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.033448] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.033448]=20
[ 1427.033450] Leftover inexact backtrace:
              =20
[ 1427.033453]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.033455] ---[ end trace fbc5b38f9c7e0946 ]---
[ 1427.033472] ------------[ cut here ]------------
[ 1427.033476] WARNING: CPU: 0 PID: 4065 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1427.033477] sysfs group ffffffff81eff0e0 not found for kobject 'end_devi=
ce-1:1:12'
[ 1427.033478] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1427.033539]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1427.033550] Supported: No, Unsupported modules are loaded
[ 1427.033552] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.033554] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.033558] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.033560]  0000000000000000 ffffffff8131fe80 ffff88044be3bd60 ffffffff=
81a31c80
[ 1427.033563]  ffffffff8107df61 ffff88044b4db000 ffff88044be3bdb0 ffff8804=
4a0a8640
[ 1427.033567]  ffff880437761800 0000000000000000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1427.033570] Call Trace:
[ 1427.033576]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1427.033580]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1427.033582]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1427.033585]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1427.033589]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1427.033592]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1427.033595]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.033600]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.033605]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.033608]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.033611]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.033615]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.033617]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.035649] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.035649]=20
[ 1427.035650] Leftover inexact backtrace:
              =20
[ 1427.035652]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.035658] ---[ end trace fbc5b38f9c7e0947 ]---
[ 1427.035667] pm80xx:: pm8001_dev_gone_notify 1206: found dev[4004:9] is g=
one. device ffff88040d0e00a8  running req -530
[ 1427.035672] pm80xx:: pm8001_chip_abort_task 5206: cmd_tag =3D 0xa, abort=
 task tag =3D 0x0
[ 1427.035672] pm80xx:: send_task_abort 5189: dev id 4004 tag a=20
[ 1427.037511] pm80xx:: pm8001_mpi_task_abort_resp 4027: ABORT status =3D 0=
x0 task ffff88044b6c2900=20
[ 1427.037516] pm80xx:: pm8001_mpi_task_abort_resp 4043: ABORT IO_SUCCESS f=
or tag a ,task ffff88044b6c2900=20
[ 1427.037720] ------------[ cut here ]------------
[ 1427.037726] WARNING: CPU: 0 PID: 4065 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1427.037727] sysfs group ffffffff81eff0e0 not found for kobject '1:0:2:0'
[ 1427.037727] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1427.037779]  ehci_hcd
[ 1427.037780]  libata usbcore usb_common sg dm_multipath dm_mod scsi_dh_rd=
ac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: pm80x=
x]
[ 1427.037791] Supported: No, Unsupported modules are loaded
[ 1427.037793] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.037795] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.037800] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.037802]  0000000000000000 ffffffff8131fe80 ffff88044be3bcc0 ffffffff=
81a31c80
[ 1427.037806]  ffffffff8107df61 ffff88006cd03400 ffff88044be3bd10 ffff8804=
49c6e800
[ 1427.037809]  ffff88003f670980 ffff880437633000 ffffffff8107dfdc ffffffff=
81a2db58
[ 1427.037812] Call Trace:
[ 1427.037821]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1427.037825]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1427.037828]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1427.037831]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1427.037835]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1427.037838]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1427.037842]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.037845]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1427.037847]  [<ffffffff8130b85e>] bsg_unregister_queue+0x5e/0xa0
[ 1427.037858]  [<ffffffffa00261c5>] __scsi_remove_device+0xa5/0xd0 [scsi_m=
od]
[ 1427.037869]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1427.037877]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1427.037882]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1427.037888]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.037892]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.037896]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.037900]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.037903]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.037906]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.039939] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.039940]=20
[ 1427.039941] Leftover inexact backtrace:
              =20
[ 1427.039943]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.039955] ---[ end trace fbc5b38f9c7e0948 ]---
[ 1427.040153] ------------[ cut here ]------------
[ 1427.040158] WARNING: CPU: 0 PID: 4065 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1427.040160] sysfs group ffffffff81eff0e0 not found for kobject '1:0:2:0'
[ 1427.040161] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1427.040231]  ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unload=
ed: pm80xx]
[ 1427.040241] Supported: No, Unsupported modules are loaded
[ 1427.040244] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.040246] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.040253] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.040257]  0000000000000000 ffffffff8131fe80 ffff88044be3bcd0 ffffffff=
81a31c80
[ 1427.040258]  ffffffff8107df61 ffff88003f670c60 ffff88044be3bd20 ffff8804=
49c6e800
[ 1427.040262]  ffff88003f670980
[ 1427.040265]  ffff880437633000 ffffffff8107dfdc ffffffff81a2db58
[ 1427.040266] Call Trace:
[ 1427.040275]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1427.040280]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1427.040283]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1427.040286]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1427.040290]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1427.040293]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1427.040296]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.040300]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1427.040310]  [<ffffffffa00261d1>] __scsi_remove_device+0xb1/0xd0 [scsi_m=
od]
[ 1427.040321]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1427.040329]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1427.040334]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1427.040340]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.040344]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.040348]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.040352]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.040355]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.040358]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.042539] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.042540]=20
[ 1427.042542] Leftover inexact backtrace:
              =20
[ 1427.042545]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.042548] ---[ end trace fbc5b38f9c7e0949 ]---
[ 1427.042555] ------------[ cut here ]------------
[ 1427.042559] WARNING: CPU: 0 PID: 4065 at ../fs/sysfs/group.c:237 device_=
del+0x54/0x240()
[ 1427.042561] sysfs group ffffffff81eff0e0 not found for kobject 'sg3'
[ 1427.042562] Modules linked in: pm80xx(OEN) ses enclosure(OEN) st sr_mod =
cdrom fuse af_packet iscsi_ibft iscsi_boot_sysfs msr xfs libcrc32c joydev i=
ntel_rapl sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp =
kvm_intel nls_iso8859_1 nls_cp437 kvm irqbypass vfat fat crct10dif_pclmul c=
rc32_pclmul ghash_clmulni_intel drbg ansi_cprng serio_raw ipmi_ssif ipmi_de=
vintf igb ptp pps_core iTCO_wdt pcspkr iTCO_vendor_support aesni_intel aes_=
x86_64 lrw gf128mul glue_helper ablk_helper i2c_i801 ipmi_si lpc_ich mfd_co=
re cryptd ipmi_msghandler wmi ioatdma fjes mei_me mei dca shpchp processor =
button btrfs xor raid6_pq hid_generic usbhid sd_mod mgag200 i2c_algo_bit dr=
m_kms_helper isci(X) syscopyarea sysfillrect sysimgblt fb_sys_fops ttm crc3=
2c_intel libsas ahci libahci scsi_transport_sas ehci_pci drm
[ 1427.042616]  ehci_hcd
[ 1427.042617]  libata
[ 1427.042618]  usbcore usb_common sg dm_multipath dm_mod scsi_dh_rdac scsi=
_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: pm80xx]
[ 1427.042627] Supported: No, Unsupported modules are loaded
[ 1427.042630] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.042632] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.042637] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.042638]  0000000000000000 ffffffff8131fe80 ffff88044be3bc30 ffffffff=
81a31c80
[ 1427.042643]  ffffffff8107df61
[ 1427.042646]  ffff88044a7e5800 ffff88044be3bc80 ffff88043bd825d0
[ 1427.042648]  ffff88003f670980 ffff88043bd825e0 ffffffff8107dfdc ffffffff=
81a2db58
[ 1427.042652] Call Trace:
[ 1427.042658]  [<ffffffff81019b19>] dump_trace+0x59/0x310
[ 1427.042662]  [<ffffffff81019eba>] show_stack_log_lvl+0xea/0x170
[ 1427.042665]  [<ffffffff8101ac41>] show_stack+0x21/0x40
[ 1427.042668]  [<ffffffff8131fe80>] dump_stack+0x5c/0x7c
[ 1427.042672]  [<ffffffff8107df61>] warn_slowpath_common+0x81/0xb0
[ 1427.042675]  [<ffffffff8107dfdc>] warn_slowpath_fmt+0x4c/0x50
[ 1427.042678]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.042680]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1427.042683]  [<ffffffff81465afa>] device_destroy+0x3a/0x40
[ 1427.042687]  [<ffffffffa00bd59b>] sg_remove_device+0xdb/0x150 [sg]
[ 1427.042691]  [<ffffffff814658ba>] device_del+0xca/0x240
[ 1427.042695]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1427.042704]  [<ffffffffa00261d1>] __scsi_remove_device+0xb1/0xd0 [scsi_m=
od]
[ 1427.042713]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1427.042720]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1427.042726]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1427.042730]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.042734]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.042737]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.042741]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.042744]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.042746]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.045173] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.045175]=20
[ 1427.045176] Leftover inexact backtrace:
              =20
[ 1427.045179]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.045189] ---[ end trace fbc5b38f9c7e094a ]---
[ 1427.045318] dbg: in enclosure_unregister &edev->component[i].cdev =3D 4C=
39C310=20
[ 1427.045321] dbg: device: 'Slot 01': in enclosure_unregister
[ 1427.045332] BUG: unable to handle kernel NULL pointer dereference at 000=
0000000000068
[ 1427.051989] IP:
[ 1427.051992]  [<ffffffff8127b3b3>] kernfs_find_ns+0x13/0xd0
[ 1427.051993] PGD 0=20
[ 1427.051993]=20
[ 1427.051994] Oops: 0000 [#1]=20
[ 1427.051995] SMP=20
[ 1427.051995]=20
[ 1427.051996] Modules linked in:
[ 1427.051997]  pm80xx(OEN)
[ 1427.051997]  ses
[ 1427.051998]  enclosure(OEN)
[ 1427.051998]  st
[ 1427.051998]  sr_mod
[ 1427.051999]  cdrom
[ 1427.051999]  fuse
[ 1427.052000]  af_packet
[ 1427.052000]  iscsi_ibft
[ 1427.052000]  iscsi_boot_sysfs
[ 1427.052001]  msr
[ 1427.052001]  xfs
[ 1427.052002]  libcrc32c
[ 1427.052002]  joydev
[ 1427.052002]  intel_rapl
[ 1427.052003]  sb_edac
[ 1427.052003]  edac_core
[ 1427.052003]  x86_pkg_temp_thermal
[ 1427.052004]  intel_powerclamp
[ 1427.052004]  coretemp
[ 1427.052004]  kvm_intel
[ 1427.052005]  nls_iso8859_1
[ 1427.052005]  nls_cp437
[ 1427.052006]  kvm
[ 1427.052006]  irqbypass
[ 1427.052006]  vfat
[ 1427.052007]  fat
[ 1427.052007]  crct10dif_pclmul
[ 1427.052007]  crc32_pclmul
[ 1427.052008]  ghash_clmulni_intel
[ 1427.052008]  drbg
[ 1427.052008]  ansi_cprng
[ 1427.052009]  serio_raw
[ 1427.052009]  ipmi_ssif
[ 1427.052009]  ipmi_devintf
[ 1427.052010]  igb
[ 1427.052010]  ptp
[ 1427.052011]  pps_core
[ 1427.052011]  iTCO_wdt
[ 1427.052011]  pcspkr
[ 1427.052012]  iTCO_vendor_support
[ 1427.052012]  aesni_intel
[ 1427.052013]  aes_x86_64
[ 1427.052013]  lrw
[ 1427.052013]  gf128mul
[ 1427.052014]  glue_helper
[ 1427.052014]  ablk_helper
[ 1427.052015]  i2c_i801
[ 1427.052015]  ipmi_si
[ 1427.052015]  lpc_ich
[ 1427.052016]  mfd_core
[ 1427.052016]  cryptd
[ 1427.052016]  ipmi_msghandler
[ 1427.052017]  wmi
[ 1427.052017]  ioatdma
[ 1427.052017]  fjes
[ 1427.052018]  mei_me
[ 1427.052018]  mei
[ 1427.052018]  dca
[ 1427.052019]  shpchp
[ 1427.052031]  processor button btrfs xor raid6_pq hid_generic usbhid sd_m=
od mgag200 i2c_algo_bit drm_kms_helper isci(X) syscopyarea sysfillrect sysi=
mgblt fb_sys_fops ttm crc32c_intel libsas ahci libahci scsi_transport_sas e=
hci_pci drm ehci_hcd libata usbcore usb_common sg dm_multipath dm_mod scsi_=
dh_rdac scsi_dh_emc scsi_dh_alua scsi_mod efivarfs autofs4 [last unloaded: =
pm80xx]
[ 1427.052031] Supported: No, Unsupported modules are loaded
[ 1427.052033] CPU: 0 PID: 4065 Comm: kworker/u24:3 Tainted: G        W  OE=
   NX 4.4.73-5-default #1
[ 1427.052034] Hardware name: Supermicro X9SRE/X9SRE-3F/X9SRi/X9SRi-3F/X9SR=
E/X9SRE-3F/X9SRi/X9SRi-3F, BIOS 3.2 01/16/2015
[ 1427.052038] Workqueue: scsi_wq_1 sas_destruct_devices [libsas]
[ 1427.052040] task: ffff880415de1880 ti: ffff88044be38000 task.ti: ffff880=
44be38000
[ 1427.052042] RIP: 0010:[<ffffffff8127b3b3>]  [<ffffffff8127b3b3>] kernfs_=
find_ns+0x13/0xd0
[ 1427.052043] RSP: 0018:ffff88044be3bc30  EFLAGS: 00010246
[ 1427.052044] RAX: ffff880415de1880 RBX: 0000000000000000 RCX: 00000000000=
00000
[ 1427.052045] RDX: 0000000000000000 RSI: ffffffff8189cad9 RDI: 00000000000=
00000
[ 1427.052046] RBP: ffffffff8189cad9 R08: 000000000000002f R09: ffffffff822=
58ef7
[ 1427.052046] R10: 00000000000153e8 R11: 0000000000000000 R12: 00000000000=
00000
[ 1427.052047] R13: ffffffff8189cad9 R14: ffff880437633000 R15: ffff8804376=
33000
[ 1427.052049] FS:  0000000000000000(0000) GS:ffff88047f200000(0000) knlGS:=
0000000000000000
[ 1427.052049] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1427.052050] CR2: 0000000000000068 CR3: 0000000001e0b000 CR4: 00000000000=
406f0
[ 1427.052051] Stack:
[ 1427.052053]  0000000000000000 ffffffff8189cad9 0000000000000000 ffff8804=
4c39c018
[ 1427.052054]  ffffffff8127b49c ffffffff81efef40 ffff88044c39c310 ffff8804=
4c39c310
[ 1427.052056]  ffffffff8127e218 ffff88044c39c320 ffff88044c39c310 ffffffff=
81471bcd
[ 1427.052056] Call Trace:
[ 1427.052060]  [<ffffffff8127b49c>] kernfs_find_and_get_ns+0x2c/0x50
[ 1427.052064]  [<ffffffff8127e218>] sysfs_unmerge_group+0x18/0x60
[ 1427.052068]  [<ffffffff81471bcd>] dpm_sysfs_remove+0x1d/0x60
[ 1427.052071]  [<ffffffff81465844>] device_del+0x54/0x240
[ 1427.052073]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1427.052077]  [<ffffffffa01454bc>] enclosure_unregister+0xcc/0xe0 [enclos=
ure]
[ 1427.052091]  [<ffffffffa0239088>] ses_intf_remove+0x38/0xc0 [ses]
[ 1427.052094]  [<ffffffff814658ba>] device_del+0xca/0x240
[ 1427.052097]  [<ffffffff81465a4a>] device_unregister+0x1a/0x60
[ 1427.052106]  [<ffffffffa00261d1>] __scsi_remove_device+0xb1/0xd0 [scsi_m=
od]
[ 1427.052115]  [<ffffffffa0026211>] scsi_remove_device+0x21/0x30 [scsi_mod=
]
[ 1427.052122]  [<ffffffffa00263a5>] scsi_remove_target+0x155/0x1b0 [scsi_m=
od]
[ 1427.052127]  [<ffffffffa00a304f>] sas_rphy_remove+0x5f/0x70 [scsi_transp=
ort_sas]
[ 1427.052131]  [<ffffffffa00a306e>] sas_rphy_delete+0xe/0x20 [scsi_transpo=
rt_sas]
[ 1427.052135]  [<ffffffffa01675b9>] sas_destruct_devices+0x69/0x90 [libsas=
]
[ 1427.052139]  [<ffffffff8109593e>] process_one_work+0x14e/0x410
[ 1427.052142]  [<ffffffff81096196>] worker_thread+0x116/0x490
[ 1427.052144]  [<ffffffff8109b667>] kthread+0xc7/0xe0
[ 1427.052147]  [<ffffffff816094bf>] ret_from_fork+0x3f/0x70
[ 1427.054161] DWARF2 unwinder stuck at ret_from_fork+0x3f/0x70
[ 1427.054161]=20
[ 1427.054162] Leftover inexact backtrace:
              =20
[ 1427.054164]  [<ffffffff8109b5a0>] ? kthread_park+0x50/0x50
[ 1427.054179] Code: 31 c0 83 e2 0f 66 83 fa 01 75 c6 48 8b 55 08 48 83 42 =
40 01 5b 5d c3 90 66 66 66 66 90 41 55 49 89 f5 41 54 49 89 d4 31 d2 55 53 =
<0f> b7 47 68 48 8b 5f 48 66 c1 e8 05 83 e0 01 4d 85 e4 0f b6 c8=20
[ 1427.054181] RIP  [<ffffffff8127b3b3>] kernfs_find_ns+0x13/0xd0
[ 1427.054181]  RSP <ffff88044be3bc30>
[ 1427.054182] CR2: 0000000000000068


Regards ,
Raj Dinesh
