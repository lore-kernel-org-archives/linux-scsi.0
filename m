From: Nathan Shearer <mail@nathanshearer.ca>
Subject: Re: Hot Swap Problems with LSI HBA and LSI Backplane -- reproducable
 and very frustrating
Date: Fri, 20 Sep 2013 00:04:25 -0600
Message-ID: <523BE569.4020706@nathanshearer.ca>
References: <523A23D3.6030608@nathanshearer.ca> <CAC9+an+YaZ3hn+eTyk0mApgj7m30yTYEKeif=aEUrF49dinh7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from whm02.asteroidpc.com ([207.228.103.87]:59820 "EHLO
	nathanshearer.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753518Ab3ITGE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 02:04:29 -0400
In-Reply-To: <CAC9+an+YaZ3hn+eTyk0mApgj7m30yTYEKeif=aEUrF49dinh7w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Hi Baruch, thanks for the help. I rebuilt my kernel with some more 
debugging and started testing with a nice mixture of drives and 3 
different LSI HBA's (one used mptsas and worked perfectly, the other two 
use mpt2sas and have similar problems). I did get a nice error in the 
kernel logs when hot-insterting some drives:

----------------
Hardware Configuration: Supermicro AOC-USAS2-L8i (with a SAS2008 chip) 
connected to the Supermicro BPN-SAS-826EL2 backplane with one cable
Testing process: Hot insert a drive into SAS0, hot remove a drive from 
SAS0, repeat with SAS1 through SAS11. Retry a random SAS bay to verify 
it still works.

Tested several bays with a Seagate ST91000640NS. They all worked.
Tested several bays with a Western Digital WD3000BLFS-01YBU4. They all 
worked.
Tested all 12 bays with a Seagate ST3500641AS. They all worked.
Tested 12 bays with 12 Western Digital WD30EFRX-68AX9N0 simultaneously.
     All 12 worked but they took longer to become available for use and 
the kernel logs had some odd "task abort" messages:
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025010] scsi 
6:0:23:0: Direct-Access     ATA      WDC WD30EFRX-68A 0A80 PQ: 0 ANSI: 5
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025019] scsi 
6:0:23:0: SATA: handle(0x0010), sas_addr(0x500304800105a948), phy(8), 
device_name(0x4ee65001fcba033b)
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025022] scsi 
6:0:23:0: SATA: enclosure_logical_id(0x50030442523a2033), slot(4)
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025090] scsi 
6:0:23:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025093] scsi 
6:0:23:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(6), 
cmd_que(1)
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025316] sd 
6:0:23:0: Attached scsi generic sg6 type 0
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025761] sd 
6:0:23:0: [sdf] physical block alignment offset: 4096
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025765] sd 
6:0:23:0: [sdf] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
         Sep 19 23:33:15 gentoo-live-usb kernel: [ 1413.025771] sd 
6:0:23:0: [sdf] 4096-byte physical blocks
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1443.864252] sd 
6:0:23:0: attempting task abort! scmd(ffff88081d41ce00)
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1443.864257] sd 
6:0:23:0: CDB:
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1443.864259] Inquiry: 
12 01 00 00 40 00
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1443.864265] scsi 
target6:0:23: handle(0x0010), sas_address(0x500304800105a948), phy(8)
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1443.864268] scsi 
target6:0:23: enclosure_logical_id(0x50030442523a2033), slot(4)
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1444.215233] sd 
6:0:23:0: task abort: SUCCESS scmd(ffff88081d41ce00)
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1444.215238] sd 
6:0:23:0: attempting task abort! scmd(ffff88081d41cd00)
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1444.215241] sd 
6:0:23:0: CDB:
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1444.215242] Inquiry: 
12 01 83 00 20 00
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1444.215249] scsi 
target6:0:23: handle(0x0010), sas_address(0x500304800105a948), phy(8)
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1444.215251] scsi 
target6:0:23: enclosure_logical_id(0x50030442523a2033), slot(4)
         Sep 19 23:33:46 gentoo-live-usb kernel: [ 1444.215264] sd 
6:0:23:0: task abort: SUCCESS scmd(ffff88081d41cd00)
         Sep 19 23:33:47 gentoo-live-usb kernel: [ 1444.969609] sd 
6:0:23:0: [sdf] Write Protect is off
         Sep 19 23:33:47 gentoo-live-usb kernel: [ 1444.969614] sd 
6:0:23:0: [sdf] Mode Sense: 73 00 00 08
         Sep 19 23:33:47 gentoo-live-usb kernel: [ 1444.970478] sd 
6:0:23:0: [sdf] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
         Sep 19 23:33:47 gentoo-live-usb kernel: [ 1444.990873] sdf: 
unknown partition table
         Sep 19 23:33:47 gentoo-live-usb kernel: [ 1445.002104] sd 
6:0:23:0: [sdf] Attached SCSI disk
     All 12 workd and performed at 86MBps simultaneously with these 
simple tests:
         for DRIVE in /dev/sd[b-z]; do hdparm -tT $DRIVE & done
         for DRIVE in /dev/sd[b-z]; do dd if=$DRIVE bs=1MiB count=4096 
of=/dev/null & done
Tested several bays with a Seagate ST3000DM001-9YN166. They all worked.
Tested several bays with 6 different Seagate ST4000DM000-1F2168
     SAS11 worked
     SAS9 did not spin up the drive
     SAS10 worked
     SAS7 worked
     SAS8 caused all kinds of kernel errors:
         Sep 19 23:56:17 gentoo-live-usb kernel: [ 2795.290840] 
mpt2sas0: device is not present handle(0x0012), no sas_device!!!
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039249] 
------------[ cut here ]------------
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039260] WARNING: 
at fs/sysfs/inode.c:324 sysfs_hash_and_remove+0xa9/0xb0()
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039263] sysfs: 
can not remove 'device', no directory
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039265] Modules 
linked in: ipv6 acpi_cpufreq mperf freq_table kvm_amd kvm joydev igb ses 
enclosure pcspkr i2c_algo_bit processor dca amd64_edac_mod edac_core 
serio_raw i2c_piix4 k10temp xts ablk_helper cryptd glue_helper lrw 
gf128mul aes_x86_64 sha256_generic iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi tg3 e1000 fuse xfs exportfs nfs fscache lockd 
sunrpc jfs reiserfs btrfs zlib_deflate libcrc32c ext3 jbd ext2 multipath 
linear raid0 dm_raid raid10 raid1 raid456 async_raid6_recov async_pq 
async_xor xor raid6_pq async_memcpy async_tx dm_snapshot dm_crypt 
hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration 
sl811_hcd hid_generic usbhid xhci_hcd ohci_hcd uhci_hcd usb_storage 
ehci_pci ehci_hcd usbcore usb_common mpt2sas raid_class aic94xx libsas 
lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 
DAC960 hpsa cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc 
scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x 
qla1280 dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx 
aic79xx sr_mod cdrom pdc_adma sata_inic162x sata_mv sata_qstor sata_vsc 
sata_uli sata_sis sata_nv sata_via sata_svw sata_sil24 sata_sil 
sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron 
pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old 
pata_triflex pata_atiixp pata_ali pata_pcmcia pata_ns87415 pata_ns87410 
pata_serverworks pata_cypress pata_artop pata_it821x pata_hpt3x2n 
pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 
pata_sil680 pata_pdc2027x pata_mpiix
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039385] CPU: 8 
PID: 16428 Comm: kworker/u67:3 Not tainted 3.10.12 #1
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039387] Hardware 
name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS 2.0a 11/10/2011
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039398] 
Workqueue: fw_event0 _firmware_event_work [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039401] 
ffffffff8174568a ffff88081ccd5828 ffffffff8157bca2 ffff88081ccd5868
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039404] 
ffffffff8105004b ffff88081ccd5868 0000000000000000 0000000000000000
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039406] 
ffffffffa0d16b58 ffff88081d091598 ffff88081d4c0010 ffff88081ccd58c8
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039409] Call Trace:
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039416] 
[<ffffffff8157bca2>] dump_stack+0x19/0x1b
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039422] 
[<ffffffff8105004b>] warn_slowpath_common+0x6b/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039426] 
[<ffffffff81050121>] warn_slowpath_fmt+0x41/0x50
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039429] 
[<ffffffff811c8a79>] sysfs_hash_and_remove+0xa9/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039432] 
[<ffffffff811cb001>] sysfs_remove_link+0x21/0x30
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039436] 
[<ffffffffa0d16269>] enclosure_remove_links+0x39/0x40 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039440] 
[<ffffffffa0d1635f>] enclosure_component_release+0x1f/0x40 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039445] 
[<ffffffff81382119>] device_release+0x39/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039450] 
[<ffffffff8129218c>] kobject_release+0x4c/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039453] 
[<ffffffff8129204c>] kobject_put+0x2c/0x60
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039455] 
[<ffffffff81381f72>] put_device+0x12/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039459] 
[<ffffffff81382e59>] device_unregister+0x19/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039463] 
[<ffffffffa0d1680a>] enclosure_unregister+0x8a/0xc0 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039466] 
[<ffffffffa0d1c0ce>] ses_intf_remove+0xbe/0xd0 [ses]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039469] 
[<ffffffff81382d61>] device_del+0xb1/0x190
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039472] 
[<ffffffff81382e51>] device_unregister+0x11/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039477] 
[<ffffffff813b1d35>] __scsi_remove_device+0xa5/0xc0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039480] 
[<ffffffff813b1d7a>] scsi_remove_device+0x2a/0x40
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039483] 
[<ffffffff813b1f12>] scsi_remove_target+0x162/0x210
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039491] 
[<ffffffffa0263e25>] sas_rphy_remove+0x55/0x60 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039497] 
[<ffffffffa0264d31>] sas_rphy_delete+0x11/0x20 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039502] 
[<ffffffffa0264d65>] sas_port_delete+0x25/0x160 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039505] 
[<ffffffff811cb001>] ? sysfs_remove_link+0x21/0x30
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039512] 
[<ffffffffa04ed272>] mpt2sas_transport_port_remove+0x1d2/0x1f0 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039518] 
[<ffffffffa04e0ad8>] _scsih_remove_device+0xb8/0x110 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039524] 
[<ffffffffa04e2ae3>] _scsih_device_remove_by_handle.part.39+0x83/0xb0 
[mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039530] 
[<ffffffffa04e766b>] _firmware_event_work+0x3eb/0x1c10 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039535] 
[<ffffffff8107f48b>] ? update_rq_clock+0x2b/0x50
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039540] 
[<ffffffff8101155a>] ? __switch_to+0x12a/0x4a0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039545] 
[<ffffffff8106cf23>] process_one_work+0x183/0x4a0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039548] 
[<ffffffff8106e25b>] worker_thread+0x11b/0x370
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039551] 
[<ffffffff8106e140>] ? manage_workers.isra.21+0x2d0/0x2d0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039581] 
[<ffffffff8107437b>] kthread+0xbb/0xc0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039585] 
[<ffffffff81010000>] ? perf_trace_xen_mc_flush+0x50/0xe0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039588] 
[<ffffffff810742c0>] ? flush_kthread_worker+0xa0/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039592] 
[<ffffffff815895bc>] ret_from_fork+0x7c/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039595] 
[<ffffffff810742c0>] ? flush_kthread_worker+0xa0/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039598] ---[ end 
trace c9d125ebbe07906e ]---
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039635] 
------------[ cut here ]------------
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039638] WARNING: 
at fs/sysfs/inode.c:324 sysfs_hash_and_remove+0xa9/0xb0()
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039640] sysfs: 
can not remove 'device', no directory
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039641] Modules 
linked in: ipv6 acpi_cpufreq mperf freq_table kvm_amd kvm joydev igb ses 
enclosure pcspkr i2c_algo_bit processor dca amd64_edac_mod edac_core 
serio_raw i2c_piix4 k10temp xts ablk_helper cryptd glue_helper lrw 
gf128mul aes_x86_64 sha256_generic iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi tg3 e1000 fuse xfs exportfs nfs fscache lockd 
sunrpc jfs reiserfs btrfs zlib_deflate libcrc32c ext3 jbd ext2 multipath 
linear raid0 dm_raid raid10 raid1 raid456 async_raid6_recov async_pq 
async_xor xor raid6_pq async_memcpy async_tx dm_snapshot dm_crypt 
hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration 
sl811_hcd hid_generic usbhid xhci_hcd ohci_hcd uhci_hcd usb_storage 
ehci_pci ehci_hcd usbcore usb_common mpt2sas raid_class aic94xx libsas 
lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 
DAC960 hpsa cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc 
scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x 
qla1280 dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx 
aic79xx sr_mod cdrom pdc_adma sata_inic162x sata_mv sata_qstor sata_vsc 
sata_uli sata_sis sata_nv sata_via sata_svw sata_sil24 sata_sil 
sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron 
pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old 
pata_triflex pata_atiixp pata_ali pata_pcmcia pata_ns87415 pata_ns87410 
pata_serverworks pata_cypress pata_artop pata_it821x pata_hpt3x2n 
pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 
pata_sil680 pata_pdc2027x pata_mpiix
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039801] CPU: 8 
PID: 16428 Comm: kworker/u67:3 Tainted: G        W 3.10.12 #1
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039802] Hardware 
name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS 2.0a 11/10/2011
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039807] 
Workqueue: fw_event0 _firmware_event_work [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039809] 
ffffffff8174568a ffff88081ccd5828 ffffffff8157bca2 ffff88081ccd5868
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039811] 
ffffffff8105004b ffff88081ccd5868 0000000000000000 0000000000000000
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039814] 
ffffffffa0d16b58 ffff88081d091da8 ffff88081d4c0010 ffff88081ccd58c8
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039816] Call Trace:
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039819] 
[<ffffffff8157bca2>] dump_stack+0x19/0x1b
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039823] 
[<ffffffff8105004b>] warn_slowpath_common+0x6b/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039826] 
[<ffffffff81050121>] warn_slowpath_fmt+0x41/0x50
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039829] 
[<ffffffff811c8a79>] sysfs_hash_and_remove+0xa9/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039832] 
[<ffffffff811cb001>] sysfs_remove_link+0x21/0x30
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039835] 
[<ffffffffa0d16269>] enclosure_remove_links+0x39/0x40 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039838] 
[<ffffffffa0d1635f>] enclosure_component_release+0x1f/0x40 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039841] 
[<ffffffff81382119>] device_release+0x39/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039844] 
[<ffffffff8129218c>] kobject_release+0x4c/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039847] 
[<ffffffff8129204c>] kobject_put+0x2c/0x60
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039850] 
[<ffffffff81381f72>] put_device+0x12/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039853] 
[<ffffffff81382e59>] device_unregister+0x19/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039856] 
[<ffffffffa0d1680a>] enclosure_unregister+0x8a/0xc0 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039859] 
[<ffffffffa0d1c0ce>] ses_intf_remove+0xbe/0xd0 [ses]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039862] 
[<ffffffff81382d61>] device_del+0xb1/0x190
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039865] 
[<ffffffff81382e51>] device_unregister+0x11/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039868] 
[<ffffffff813b1d35>] __scsi_remove_device+0xa5/0xc0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039871] 
[<ffffffff813b1d7a>] scsi_remove_device+0x2a/0x40
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039874] 
[<ffffffff813b1f12>] scsi_remove_target+0x162/0x210
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039880] 
[<ffffffffa0263e25>] sas_rphy_remove+0x55/0x60 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039885] 
[<ffffffffa0264d31>] sas_rphy_delete+0x11/0x20 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039890] 
[<ffffffffa0264d65>] sas_port_delete+0x25/0x160 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039893] 
[<ffffffff811cb001>] ? sysfs_remove_link+0x21/0x30
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039899] 
[<ffffffffa04ed272>] mpt2sas_transport_port_remove+0x1d2/0x1f0 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039905] 
[<ffffffffa04e0ad8>] _scsih_remove_device+0xb8/0x110 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039911] 
[<ffffffffa04e2ae3>] _scsih_device_remove_by_handle.part.39+0x83/0xb0 
[mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039917] 
[<ffffffffa04e766b>] _firmware_event_work+0x3eb/0x1c10 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039920] 
[<ffffffff8107f48b>] ? update_rq_clock+0x2b/0x50
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039923] 
[<ffffffff8101155a>] ? __switch_to+0x12a/0x4a0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039926] 
[<ffffffff8106cf23>] process_one_work+0x183/0x4a0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039929] 
[<ffffffff8106e25b>] worker_thread+0x11b/0x370
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039933] 
[<ffffffff8106e140>] ? manage_workers.isra.21+0x2d0/0x2d0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039935] 
[<ffffffff8107437b>] kthread+0xbb/0xc0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039938] 
[<ffffffff81010000>] ? perf_trace_xen_mc_flush+0x50/0xe0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039941] 
[<ffffffff810742c0>] ? flush_kthread_worker+0xa0/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039944] 
[<ffffffff815895bc>] ret_from_fork+0x7c/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039946] 
[<ffffffff810742c0>] ? flush_kthread_worker+0xa0/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039948] ---[ end 
trace c9d125ebbe07906f ]---
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039962] 
------------[ cut here ]------------
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039965] WARNING: 
at fs/sysfs/inode.c:324 sysfs_hash_and_remove+0xa9/0xb0()
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039966] sysfs: 
can not remove 'device', no directory
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.039967] Modules 
linked in: ipv6 acpi_cpufreq mperf freq_table kvm_amd kvm joydev igb ses 
enclosure pcspkr i2c_algo_bit processor dca amd64_edac_mod edac_core 
serio_raw i2c_piix4 k10temp xts ablk_helper cryptd glue_helper lrw 
gf128mul aes_x86_64 sha256_generic iscsi_tcp libiscsi_tcp libiscsi 
scsi_transport_iscsi tg3 e1000 fuse xfs exportfs nfs fscache lockd 
sunrpc jfs reiserfs btrfs zlib_deflate libcrc32c ext3 jbd ext2 multipath 
linear raid0 dm_raid raid10 raid1 raid456 async_raid6_recov async_pq 
async_xor xor raid6_pq async_memcpy async_tx dm_snapshot dm_crypt 
hid_sunplus hid_sony hid_samsung hid_pl hid_petalynx hid_gyration 
sl811_hcd hid_generic usbhid xhci_hcd ohci_hcd uhci_hcd usb_storage 
ehci_pci ehci_hcd usbcore usb_common mpt2sas raid_class aic94xx libsas 
lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm megaraid aacraid sx8 
DAC960 hpsa cciss 3w_9xxx 3w_xxxx mptsas scsi_transport_sas mptfc 
scsi_transport_fc scsi_tgt mptspi mptscsih mptbase atp870u dc395x 
qla1280 dmx3191d sym53c8xx gdth advansys initio BusLogic arcmsr aic7xxx 
aic79xx sr_mod cdrom pdc_adma sata_inic162x sata_mv sata_qstor sata_vsc 
sata_uli sata_sis sata_nv sata_via sata_svw sata_sil24 sata_sil 
sata_promise pata_sl82c105 pata_cs5530 pata_cs5520 pata_via pata_jmicron 
pata_marvell pata_sis pata_netcell pata_sc1200 pata_pdc202xx_old 
pata_triflex pata_atiixp pata_ali pata_pcmcia pata_ns87415 pata_ns87410 
pata_serverworks pata_cypress pata_artop pata_it821x pata_hpt3x2n 
pata_hpt3x3 pata_hpt37x pata_hpt366 pata_cmd64x pata_efar pata_rz1000 
pata_sil680 pata_pdc2027x pata_mpiix
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040040] CPU: 8 
PID: 16428 Comm: kworker/u67:3 Tainted: G        W 3.10.12 #1
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040041] Hardware 
name: Supermicro H8DG6/H8DGi/H8DG6/H8DGi, BIOS 2.0a 11/10/2011
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040045] 
Workqueue: fw_event0 _firmware_event_work [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040045] 
ffffffff8174568a ffff88081ccd5828 ffffffff8157bca2 ffff88081ccd5868
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040048] 
ffffffff8105004b ffff88081ccd5868 0000000000000000 0000000000000000
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040050] 
ffffffffa0d16b58 ffff88081d092058 ffff88081d4c0010 ffff88081ccd58c8
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040051] Call Trace:
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040052] 
[<ffffffff8157bca2>] dump_stack+0x19/0x1b
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040054] 
[<ffffffff8105004b>] warn_slowpath_common+0x6b/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040057] 
[<ffffffff81050121>] warn_slowpath_fmt+0x41/0x50
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040059] 
[<ffffffff811c8a79>] sysfs_hash_and_remove+0xa9/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040061] 
[<ffffffff811cb001>] sysfs_remove_link+0x21/0x30
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040063] 
[<ffffffffa0d16269>] enclosure_remove_links+0x39/0x40 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040065] 
[<ffffffffa0d1635f>] enclosure_component_release+0x1f/0x40 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040068] 
[<ffffffff81382119>] device_release+0x39/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040070] 
[<ffffffff8129218c>] kobject_release+0x4c/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040072] 
[<ffffffff8129204c>] kobject_put+0x2c/0x60
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040074] 
[<ffffffff81381f72>] put_device+0x12/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040075] 
[<ffffffff81382e59>] device_unregister+0x19/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040078] 
[<ffffffffa0d1680a>] enclosure_unregister+0x8a/0xc0 [enclosure]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040080] 
[<ffffffffa0d1c0ce>] ses_intf_remove+0xbe/0xd0 [ses]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040082] 
[<ffffffff81382d61>] device_del+0xb1/0x190
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040084] 
[<ffffffff81382e51>] device_unregister+0x11/0x20
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040086] 
[<ffffffff813b1d35>] __scsi_remove_device+0xa5/0xc0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040088] 
[<ffffffff813b1d7a>] scsi_remove_device+0x2a/0x40
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040091] 
[<ffffffff813b1f12>] scsi_remove_target+0x162/0x210
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040094] 
[<ffffffffa0263e25>] sas_rphy_remove+0x55/0x60 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040099] 
[<ffffffffa0264d31>] sas_rphy_delete+0x11/0x20 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040103] 
[<ffffffffa0264d65>] sas_port_delete+0x25/0x160 [scsi_transport_sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040107] 
[<ffffffff811cb001>] ? sysfs_remove_link+0x21/0x30
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040110] 
[<ffffffffa04ed272>] mpt2sas_transport_port_remove+0x1d2/0x1f0 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040115] 
[<ffffffffa04e0ad8>] _scsih_remove_device+0xb8/0x110 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040120] 
[<ffffffffa04e2ae3>] _scsih_device_remove_by_handle.part.39+0x83/0xb0 
[mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040125] 
[<ffffffffa04e766b>] _firmware_event_work+0x3eb/0x1c10 [mpt2sas]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040129] 
[<ffffffff8107f48b>] ? update_rq_clock+0x2b/0x50
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040131] 
[<ffffffff8101155a>] ? __switch_to+0x12a/0x4a0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040134] 
[<ffffffff8106cf23>] process_one_work+0x183/0x4a0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040136] 
[<ffffffff8106e25b>] worker_thread+0x11b/0x370
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040138] 
[<ffffffff8106e140>] ? manage_workers.isra.21+0x2d0/0x2d0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040140] 
[<ffffffff8107437b>] kthread+0xbb/0xc0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040142] 
[<ffffffff81010000>] ? perf_trace_xen_mc_flush+0x50/0xe0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040144] 
[<ffffffff810742c0>] ? flush_kthread_worker+0xa0/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040146] 
[<ffffffff815895bc>] ret_from_fork+0x7c/0xb0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040148] 
[<ffffffff810742c0>] ? flush_kthread_worker+0xa0/0xa0
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040151] ---[ end 
trace c9d125ebbe079070 ]---
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040429] 
mpt2sas0: removing handle(0x000a), sas_addr(0x500304800105a97d)
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040438] 
mpt2sas0: removing handle(0x000b), sas_addr(0x500304800105a94f)
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040447] 
mpt2sas0: removing handle(0x0016), sas_addr(0x500304800105a94e)
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.040455] 
mpt2sas0: removing handle(0x0014), sas_addr(0x500304800105a94b)
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.041046] sd 
6:0:36:0: [sdb] Synchronizing SCSI cache
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.041121] sd 
6:0:36:0: [sdb]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.041123] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.043318] sd 
6:0:37:0: [sdc] Synchronizing SCSI cache
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.043368] sd 
6:0:37:0: [sdc]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.043369] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.046487] sd 
6:0:38:0: [sdd] Synchronizing SCSI cache
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.046509] sd 
6:0:38:0: [sdd]
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.046510] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
         Sep 19 23:56:28 gentoo-live-usb kernel: [ 2806.048895] 
mpt2sas0: expander_remove: handle(0x0009), sas_addr(0x500304800105a97f)
     And now the whole backplane is dead. I'll have to cold boot the 
system to get it working again.

On 09/19/2013 12:16 AM, Baruch Even wrote:
>
> mpt2sas driver has debug messages that can be turned on via sysfs. I 
> suggest that you turn them on and see if you get anything, they 
> include low level SAS events which may tell something about what 
> happens. In most likelyhood the issue is at the protocol layer and not 
> something that the kernel or driver can help with.
>
> Baruch
>
> On Sep 19, 2013 2:07 AM, "Nathan Shearer" <mail@nathanshearer.ca 
> <mailto:mail@nathanshearer.ca>> wrote:
>
>     Hi
>
>     I'm having problems with two systems where hot-swapping sata
>     drives results in their bay being permanently disabled until I
>     cold boot the system. My hardware configuration is fairly straight
>     forward:
>
>     Host Bus Adapter: LSI SAS9207-8i  (contains the LSISAS2308)
>     Case: Supermicro SuperChassis 826E2-R800LPB (contains the
>     BPN-SAS-826EL2 backplane)
>     Backplane: Supermicro BPN-SAS-826EL2 (contains two LSISASx28 SAS
>     Expanders)
>     Hard Drives: Western Digital WD3000BLFS-01YBU4, Western Digital
>     WD20EARS, Seagate ST3000DM001, Seagate ST4000DM000 (I have many
>     other types and sizes to test with)
>
>     Some links to technical information that might be relevant:
>     LSI SAS9207-8i Host Bus
>     Adapterhttp://www.lsi.com/products/storagecomponents/Pages/LSISAS9207-8i.aspx#two
>     <http://www.lsi.com/products/storagecomponents/Pages/LSISAS9207-8i.aspx#two>
>     LSISAS2308
>     http://www.lsi.com/products/storagecomponents/Pages/LSISAS2308.aspx
>     Supermicro SuperChassis 826E2-R800LPB
>     http://www.supermicro.com/products/chassis/2u/826/sc826e2-r800lp.cfm
>     LSISASx28 SAS Expander
>     http://www.lsi.com/products/storagecomponents/Pages/LSISASx28.aspx
>
>     Problem in detail
>     Ultimately I will be booting from a software RAID1 from the 12
>     drives in this system. During my testing I discovered this problem
>     and I have been booting from a Gentoo USB drive so I can test all
>     12 SAS bays (labeled SAS0 through SAS11 on the backplane). If I
>     boot the system from the USB drive, then insert a Western Digital
>     WD3000BLFS-01YBU4 into SAS0, the drive spins up and is detected.
>     Everything works as expected. I can pull the drive, mpt2sas
>     removes the handle and I can repeate the process with the other
>     SAS1 through SAS11 bays. Repeating the process with a Western
>     Digital WD20EARS has the same results. All 12 bays work. Repeating
>     with a Seagate ST4000DM000 and I find that some bays do not spin
>     up the drive. When this happens that bay is dead and I can even
>     use the previously working Western Digital WD3000BLFS-01YBU4 in
>     it. The only thing that gets the bays working again is a cold boot
>     after powering off the system and actually unplugging it for an
>     extended period (>5 minutes).
>
>     While doing this testing I did see some strange errors in the
>     kernel logs, but only after switching my HBA out for a Supermicro
>     AOC-USAS2-L8i (which contains the LSISAS2008 and uses the same
>     mpt2sas driver):
>     Testing SAS8 with ST4000DM000 worked (but there were strange
>     kernel errors):
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322489] scsi
>     6:0:35:0: Direct-Access     ATA      ST4000DM000-1F21 CC51 PQ: 0
>     ANSI: 5
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322499] scsi
>     6:0:35:0: SATA: handle(0x000b), sas_addr(0x500304800105a94c),
>     phy(12), device_name(0xc500500017534f84)
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322503] scsi
>     6:0:35:0: SATA: enclosure_logical_id(0x50030442523a2033), slot(8)
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322572] scsi
>     6:0:35:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y),
>     sw_preserve(y)
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322575] scsi
>     6:0:35:0: qdepth(32), tagged(1), simple(0), ordered(0),
>     scsi_level(6), cmd_que(1)
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.322762] sd
>     6:0:35:0: Attached scsi generic sg2 type 0
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.323340] sd
>     6:0:35:0: [sdb] physical block alignment offset: 4096
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.323345] sd
>     6:0:35:0: [sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.323347] sd
>     6:0:35:0: [sdb] 4096-byte physical blocks
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.400933] sd
>     6:0:35:0: [sdb] Write Protect is off
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.400938] sd
>     6:0:35:0: [sdb] Mode Sense: 73 00 00 08
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.401764] sd
>     6:0:35:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
>     support DPO or FUA
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.524835]  sdb:
>     sdb1 sdb2 sdb3
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.527592] AMD-Vi:
>     Event logged [IO_PAGE_FAULT device=41:00.0 domain=0x0014
>     address=0x0000000010000000 flags=0x0020]
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.527598] AMD-Vi:
>     Event logged [IO_PAGE_FAULT device=41:00.0 domain=0x0014
>     address=0x0000000010000040 flags=0x0020]
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.527601] AMD-Vi:
>     Event logged [IO_PAGE_FAULT device=41:00.0 domain=0x0014
>     address=0x0000000010000010 flags=0x0020]
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.527609] AMD-Vi:
>     Event logged [IO_PAGE_FAULT device=41:00.0 domain=0x0014
>     address=0x0000000010000020 flags=0x0020]
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.613861] sd
>     6:0:35:0: [sdb] Attached SCSI disk
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.739109] md:
>     bind<sdb2>
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.742970] md:
>     bind<sdb3>
>         Sep 17 22:23:18 gentoo-live-usb kernel: [ 1532.746619] md:
>     bind<sdb1>
>     Removed ST4000DM000 from SAS8 and inserted it into SAS6:
>         Sep 17 22:23:49 gentoo-live-usb kernel: [ 1563.287575]
>     mpt2sas0: removing handle(0x000b), sas_addr(0x500304800105a94c)
>         Sep 17 22:24:16 gentoo-live-usb kernel: [ 1590.287517]
>     mpt2sas0: device is not present handle(0x000b), no sas_device!!!
>         Sep 17 22:24:26 gentoo-live-usb kernel: [ 1601.035876]
>     mpt2sas0: removing handle(0x000a), sas_addr(0x500304800105a97d)
>         Sep 17 22:24:26 gentoo-live-usb kernel: [ 1601.037113]
>     mpt2sas0: expander_remove: handle(0x0009), sas_addr(0x500304800105a97f
>     Removed ST4000DM000 from SAS6 and inserted into SAS8 failed. No
>     activity in /var/log/messages. Drive does not spin up.
>     Removed ST4000DM000 from SAS8 and inserted into SAS6 failed. No
>     activity in /var/log/messages. Drive does not spin up.
>
>     The "device is not present" "no sas_device!!!" is interesting.
>     What does it mean because there certainly is a drive in that SAS
>     bay. I googled AMD-Vi and it seems related to IOMMU so i disabled
>     that in the BIOS. I'm not doing PCI passthrough on this system but
>     I did plan to use it as a Xen/KVM host later on. Disabling the
>     IOMMU feature in the BIOS did suppress the AMD-Vi page fault, but
>     I wonder if things are still broken somewhere and that is
>     triggering other problems alter on which causes my SAS bays to get
>     disabled untill I drain the power from the system.
>
>     Any help would be greatly appreciated.
>     --
>     To unsubscribe from this list: send the line "unsubscribe
>     linux-scsi" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>

