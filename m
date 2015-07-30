From: Yi Zhang <yizhan@redhat.com>
Subject: kernel BUG at drivers/scsi/scsi_lib.c:1101! observed during md5sum
 for one file on (RAID4->RAID0) device
Date: Thu, 30 Jul 2015 05:03:02 -0400 (EDT)
Message-ID: <1710310402.852769.1438246982906.JavaMail.zimbra@redhat.com>
References: <286306267.839569.1438244765784.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:44569 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbbG3JDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2015 05:03:03 -0400
In-Reply-To: <286306267.839569.1438244765784.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: xni@rehdat.com, Jes.Sorensen@redhat.com, Yi Zhang <yizhan@redhat.com>

Hi SCSI/RAID maintainer

During raid test with 4.2.0-rc3, I observed below kernel BUG, pls check=
 below info for the test log/environment/test steps.

Log:
[  306.741662] md: bind<sdb1>
[  306.750865] md: bind<sdc1>
[  306.753993] md: bind<sdd1>
[  306.764475] md: bind<sde1>
[  306.786156] md: bind<sdf1>
[  306.789362] md: bind<sdh1>
[  306.792555] md: bind<sdg1>
[  306.868166] raid6: sse2x1   gen() 10589 MB/s
[  306.889143] raid6: sse2x1   xor()  8218 MB/s
[  306.910121] raid6: sse2x2   gen() 13453 MB/s
[  306.931102] raid6: sse2x2   xor()  8990 MB/s
[  306.952079] raid6: sse2x4   gen() 15539 MB/s
[  306.973063] raid6: sse2x4   xor() 10771 MB/s
[  306.994039] raid6: avx2x1   gen() 20582 MB/s
[  307.015017] raid6: avx2x2   gen() 24019 MB/s
[  307.035998] raid6: avx2x4   gen() 27824 MB/s
[  307.040755] raid6: using algorithm avx2x4 gen() 27824 MB/s
[  307.046869] raid6: using avx2x2 recovery algorithm
[  307.058793] async_tx: api initialized (async)
[  307.075428] xor: automatically using best checksumming function:
[  307.091942]    avx       : 32008.000 MB/sec
[  307.147662] md: raid6 personality registered for level 6
[  307.153584] md: raid5 personality registered for level 5
[  307.159505] md: raid4 personality registered for level 4
[  307.165698] md/raid:md0: device sdf1 operational as raid disk 4
[  307.172300] md/raid:md0: device sde1 operational as raid disk 3
[  307.178899] md/raid:md0: device sdd1 operational as raid disk 2
[  307.185497] md/raid:md0: device sdc1 operational as raid disk 1
[  307.192093] md/raid:md0: device sdb1 operational as raid disk 0
[  307.199052] md/raid:md0: allocated 6482kB
[  307.203573] md/raid:md0: raid level 4 active with 5 out of 6 devices=
, algorithm 0
[  307.211958] md0: detected capacity change from 0 to 53645148160
[  307.218658] md: recovery of RAID array md0
[  307.223226] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  307.229729] md: using maximum available idle IO bandwidth (but not m=
ore than 200000 KB/sec) for recovery.
[  307.240427] md: using 128k window, over a total of 10477568k.
[  374.670951] md: md0: recovery done.
[  375.722806] EXT4-fs (md0): mounted filesystem with ordered data mode=
=2E Opts: (null)
[  447.553364] md: unbind<sdh1>
[  447.559905] md: export_rdev(sdh1)
[  447.572684] md: cannot remove active disk sdg1 from md0 ...
[  447.578909] md/raid:md0: Disk failure on sdg1, disabling device.
[  447.578909] md/raid:md0: Operation continuing on 5 devices.
[  447.594850] md: unbind<sdg1>
[  447.601834] md: export_rdev(sdg1)
[  447.615446] md: raid0 personality registered for level 0
[  447.629275] md/raid0:md0: md_size is 104775680 sectors.
[  447.635094] md: RAID0 configuration for md0 - 1 zone
[  447.640627] md: zone0=3D[sdb1/sdc1/sdd1/sde1/sdf1]
[  447.645833]       zone-offset=3D         0KB, device-offset=3D      =
   0KB, size=3D  52387840KB
[  447.654949]=20
[  447.739443] EXT4-fs (md0): mounted filesystem with ordered data mode=
=2E Opts: (null)
[  447.749258] bio too big device sde1 (768 > 512)
[  447.754824] bio too big device sdf1 (1024 > 512)
[  447.759989] bio too big device sdb1 (768 > 512)
[  447.771102] bio too big device sdc1 (1024 > 512)
[  447.776276] bio too big device sdd1 (1024 > 512)
[  447.781459] bio too big device sde1 (1024 > 512)
[  447.786635] bio too big device sdf1 (768 > 512)
[  447.811156] bio too big device sdb1 (1024 > 512)
[  447.816329] bio too big device sdc1 (1024 > 512)
[  447.821513] bio too big device sdd1 (1024 > 512)
[  447.826681] bio too big device sde1 (768 > 512)
[  447.886106] bio too big device sdf1 (1024 > 512)
[  447.891269] bio too big device sdb1 (1024 > 512)
[  447.896452] bio too big device sdc1 (1024 > 512)
[  447.901628] bio too big device sdd1 (768 > 512)
[  447.930647] bio too big device sde1 (1024 > 512)
[  447.935820] bio too big device sdf1 (1024 > 512)
[  447.941003] bio too big device sdb1 (1024 > 512)
[  447.946179] bio too big device sdc1 (768 > 512)
[  447.976196] bio too big device sdd1 (1024 > 512)
[  447.981367] bio too big device sde1 (1024 > 512)
[  447.986549] bio too big device sdf1 (1024 > 512)
[  447.991728] bio too big device sdb1 (768 > 512)
[  448.033614] bio too big device sdc1 (1024 > 512)
[  448.038786] bio too big device sdd1 (1024 > 512)
[  448.043968] bio too big device sde1 (1024 > 512)
[  448.049145] bio too big device sdf1 (768 > 512)
[  448.083273] bio too big device sdb1 (1024 > 512)
[  448.088444] bio too big device sdc1 (1024 > 512)
[  448.093626] bio too big device sdd1 (1024 > 512)
[  448.098804] bio too big device sde1 (768 > 512)
[  448.128357] bio too big device sdf1 (1024 > 512)
[  448.133536] bio too big device sdb1 (1024 > 512)
[  448.138720] bio too big device sdc1 (1024 > 512)
[  448.143897] bio too big device sdd1 (768 > 512)
[  448.173456] bio too big device sde1 (1024 > 512)
[  448.178627] bio too big device sdf1 (1024 > 512)
[  448.183811] bio too big device sdb1 (1024 > 512)
[  448.188985] bio too big device sdc1 (768 > 512)
[  448.231050] bio too big device sdd1 (1024 > 512)
[  448.236221] bio too big device sde1 (1024 > 512)
[  448.241405] bio too big device sdf1 (1024 > 512)
[  448.246583] bio too big device sdb1 (768 > 512)
[  448.282548] bio too big device sdc1 (1024 > 512)
[  448.287719] bio too big device sdd1 (1024 > 512)
[  448.292904] bio too big device sde1 (1024 > 512)
[  448.298082] bio too big device sdf1 (768 > 512)
[  448.328300] bio too big device sdb1 (1024 > 512)
[  448.333471] bio too big device sdc1 (1024 > 512)
[  448.338654] bio too big device sdd1 (1024 > 512)
[  448.343830] bio too big device sde1 (768 > 512)
[  448.374081] bio too big device sdf1 (1024 > 512)
[  448.379250] bio too big device sdb1 (1024 > 512)
[  448.384433] bio too big device sdc1 (1024 > 512)
[  448.389609] bio too big device sdd1 (768 > 512)
[  448.394690] ------------[ cut here ]------------
[  448.399832] kernel BUG at drivers/scsi/scsi_lib.c:1095!
[  448.405653] invalid opcode: 0000 [#1] SMP=20
[  448.410232] Modules linked in: raid0 ext4 mbcache jbd2 raid456 async=
_raid6_recov async_memcpy async_pq async_xor xor asyd
[  448.491371] CPU: 1 PID: 11918 Comm: md5sum Not tainted 4.2.0-rc3 #2
[  448.498354] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.2=
=2E10 03/09/2015
[  448.506791] task: ffff880461f28000 ti: ffff880462e08000 task.ti: fff=
f880462e08000
[  448.515130] RIP: 0010:[<ffffffff8146aaf2>]  [<ffffffff8146aaf2>] scs=
i_init_sgtable+0x72/0x80
[  448.524548] RSP: 0018:ffff880462e0b8f8  EFLAGS: 00010002
[  448.530465] RAX: 0000000000000003 RBX: ffff8803fc03f980 RCX: 0000000=
000001000
[  448.538417] RDX: 0000000000000000 RSI: ffff8803fbb78040 RDI: 0000000=
000000000
[  448.546369] RBP: ffff880462e0b918 R08: ffff8803fbb78040 R09: 0000000=
000000000
[  448.554320] R10: 00000000000001f0 R11: ffffea000feede00 R12: ffff880=
3fba3b860
[  448.562272] R13: 0000000000000000 R14: ffff880461edc000 R15: ffff880=
3fc03f980
[  448.570224] FS:  00007f41ce7cc740(0000) GS:ffff88046d240000(0000) kn=
lGS:0000000000000000
[  448.579242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  448.585644] CR2: 0000000000e0226f CR3: 0000000467aa3000 CR4: 0000000=
0001406e0
[  448.593597] Stack:
[  448.595834]  ffff880462e0b918 ffff8803fba3b780 ffff88046072a200 ffff=
880461edc000
[  448.604113]  ffff880462e0b968 ffffffff8146ab4a ffff88046072aaf8 ffff=
8803fbb78000
[  448.612392]  ffff8803fbb78000 ffff8803fc03f980 ffff88046072a260 ffff=
88046064ec00
[  448.620669] Call Trace:
[  448.623393]  [<ffffffff8146ab4a>] scsi_init_io+0x4a/0x1c0
[  448.629410]  [<ffffffffa004ed67>] sd_setup_read_write_cmnd+0x47/0xa4=
0 [sd_mod]
[  448.637460]  [<ffffffff81462a8b>] ? scsi_host_alloc_command+0x4b/0xc=
0
[  448.644638]  [<ffffffffa00527d7>] sd_init_command+0x27/0xa0 [sd_mod]
[  448.651720]  [<ffffffff8146adb1>] scsi_setup_cmnd+0xf1/0x160
[  448.658026]  [<ffffffff8146af71>] scsi_prep_fn+0xd1/0x170
[  448.664042]  [<ffffffff81309dac>] ? deadline_dispatch_requests+0xac/=
0x160
[  448.671609]  [<ffffffff812ed683>] blk_peek_request+0x153/0x260
[  448.678110]  [<ffffffff8146ca7f>] scsi_request_fn+0x3f/0x610
[  448.684416]  [<ffffffff812e8c57>] __blk_run_queue+0x37/0x50
[  448.690626]  [<ffffffff812e8cee>] queue_unplugged+0x2e/0xa0
[  448.696836]  [<ffffffff812eda65>] blk_flush_plug_list+0x1b5/0x200
[  448.703626]  [<ffffffff812ede14>] blk_finish_plug+0x34/0x50
[  448.709836]  [<ffffffff8118cdfd>] __do_page_cache_readahead+0x1cd/0x=
240
[  448.717207]  [<ffffffff8118cfb5>] ondemand_readahead+0x145/0x270
[  448.723903]  [<ffffffff812209ba>] ? inode_congested+0xaa/0x110
[  448.730402]  [<ffffffff8118d14c>] page_cache_async_readahead+0x6c/0x=
70
[  448.737677]  [<ffffffff811811d3>] generic_file_read_iter+0x3c3/0x5e0
[  448.744760]  [<ffffffff811f7569>] __vfs_read+0xc9/0x100
[  448.750582]  [<ffffffff811f7b86>] vfs_read+0x86/0x130
[  448.756211]  [<ffffffff811f8a15>] SyS_read+0x55/0xc0
[  448.761742]  [<ffffffff81681b2e>] entry_SYSCALL_64_fastpath+0x12/0x7=
1
[  448.768920] Code: ff 41 3b 44 24 08 77 23 41 89 44 24 08 8b 43 5c 41=
 89 44 24 10 48 83 c4 08 44 89 e8 5b 41 5c 41 5d 5d =20
[  448.790490] RIP  [<ffffffff8146aaf2>] scsi_init_sgtable+0x72/0x80
[  448.797287]  RSP <ffff880462e0b8f8>
[  448.801171] ---[ end trace fa7203c8f83678c8 ]---
[  448.853171] Kernel panic - not syncing: Fatal exception
[  448.859020] Kernel Offset: disabled
[  448.862904] drm_kms_helper: panic occurred, switching back to text c=
onsole
[  448.920805] ---[ end Kernel panic - not syncing: Fatal exception
[  448.927513] ------------[ cut here ]------------
[  448.932661] WARNING: CPU: 1 PID: 11918 at arch/x86/kernel/smp.c:124 =
native_smp_send_reschedule+0x5d/0x60()
[  448.943423] Modules linked in: raid0 ext4 mbcache jbd2 raid456 async=
_raid6_recov async_memcpy async_pq async_xor xor asyd
[  449.024578] CPU: 1 PID: 11918 Comm: md5sum Tainted: G      D        =
 4.2.0-rc3 #2
[  449.032918] Hardware name: Dell Inc. PowerEdge R730/0599V5, BIOS 1.2=
=2E10 03/09/2015
[  449.041353]  0000000000000000 00000000429195bb ffff88046d243d68 ffff=
ffff8167acdd
[  449.049635]  0000000000000000 0000000000000000 ffff88046d243da8 ffff=
ffff81081a4a
[  449.057917]  ffff88046d243da8 0000000000000000 ffff88046d216780 0000=
000000000001
[  449.066198] Call Trace:
[  449.068918]  <IRQ>  [<ffffffff8167acdd>] dump_stack+0x45/0x57
[  449.075336]  [<ffffffff81081a4a>] warn_slowpath_common+0x8a/0xc0
[  449.082030]  [<ffffffff81081b7a>] warn_slowpath_null+0x1a/0x20
[  449.088530]  [<ffffffff8104d56d>] native_smp_send_reschedule+0x5d/0x=
60
[  449.095805]  [<ffffffff810be8e5>] trigger_load_balance+0x145/0x1f0
[  449.102693]  [<ffffffff810ad486>] scheduler_tick+0xa6/0xe0
[  449.108807]  [<ffffffff810f9bb0>] ? tick_sched_do_timer+0x50/0x50
[  449.115599]  [<ffffffff810ea651>] update_process_times+0x51/0x60
[  449.122293]  [<ffffffff810f9965>] tick_sched_handle.isra.17+0x25/0x6=
0
[  449.129471]  [<ffffffff810f9bf4>] tick_sched_timer+0x44/0x80
[  449.135779]  [<ffffffff810eb1e3>] __hrtimer_run_queues+0xf3/0x220
[  449.142570]  [<ffffffff810eb648>] hrtimer_interrupt+0xa8/0x1a0
[  449.149069]  [<ffffffff810500b9>] local_apic_timer_interrupt+0x39/0x=
60
[  449.156345]  [<ffffffff81684835>] smp_apic_timer_interrupt+0x45/0x60
[  449.163427]  [<ffffffff816829cb>] apic_timer_interrupt+0x6b/0x70
[  449.170118]  <EOI>  [<ffffffff816755e3>] ? panic+0x1cc/0x20d
[  449.176435]  [<ffffffff816755dc>] ? panic+0x1c5/0x20d
[  449.182065]  [<ffffffff81019428>] oops_end+0xc8/0xe0
[  449.187595]  [<ffffffff8101994b>] die+0x4b/0x70
[  449.192643]  [<ffffffff81015e6d>] do_trap+0x13d/0x150
[  449.198272]  [<ffffffff81016338>] do_error_trap+0xa8/0x170
[  449.204386]  [<ffffffff8146aaf2>] ? scsi_init_sgtable+0x72/0x80
[  449.210983]  [<ffffffff811821b5>] ? mempool_alloc_slab+0x15/0x20
[  449.217675]  [<ffffffff811822f9>] ? mempool_alloc+0x69/0x170
[  449.223980]  [<ffffffff81016850>] do_invalid_op+0x20/0x30
[  449.229996]  [<ffffffff8168348e>] invalid_op+0x1e/0x30
[  449.235721]  [<ffffffff8146aaf2>] ? scsi_init_sgtable+0x72/0x80
[  449.242317]  [<ffffffff8146aac8>] ? scsi_init_sgtable+0x48/0x80
[  449.248912]  [<ffffffff8146ab4a>] scsi_init_io+0x4a/0x1c0
[  449.254930]  [<ffffffffa004ed67>] sd_setup_read_write_cmnd+0x47/0xa4=
0 [sd_mod]
[  449.262979]  [<ffffffff81462a8b>] ? scsi_host_alloc_command+0x4b/0xc=
0
[  449.270157]  [<ffffffffa00527d7>] sd_init_command+0x27/0xa0 [sd_mod]
[  449.277239]  [<ffffffff8146adb1>] scsi_setup_cmnd+0xf1/0x160
[  449.283544]  [<ffffffff8146af71>] scsi_prep_fn+0xd1/0x170
[  449.289561]  [<ffffffff81309dac>] ? deadline_dispatch_requests+0xac/=
0x160
[  449.297128]  [<ffffffff812ed683>] blk_peek_request+0x153/0x260
[  449.303628]  [<ffffffff8146ca7f>] scsi_request_fn+0x3f/0x610
[  449.309933]  [<ffffffff812e8c57>] __blk_run_queue+0x37/0x50
[  449.316142]  [<ffffffff812e8cee>] queue_unplugged+0x2e/0xa0
[  449.322351]  [<ffffffff812eda65>] blk_flush_plug_list+0x1b5/0x200
[  449.329142]  [<ffffffff812ede14>] blk_finish_plug+0x34/0x50
[  449.335351]  [<ffffffff8118cdfd>] __do_page_cache_readahead+0x1cd/0x=
240
[  449.342722]  [<ffffffff8118cfb5>] ondemand_readahead+0x145/0x270
[  449.349416]  [<ffffffff812209ba>] ? inode_congested+0xaa/0x110
[  449.355916]  [<ffffffff8118d14c>] page_cache_async_readahead+0x6c/0x=
70
[  449.363190]  [<ffffffff811811d3>] generic_file_read_iter+0x3c3/0x5e0
[  449.370273]  [<ffffffff811f7569>] __vfs_read+0xc9/0x100
[  449.376094]  [<ffffffff811f7b86>] vfs_read+0x86/0x130
[  449.381723]  [<ffffffff811f8a15>] SyS_read+0x55/0xc0
[  449.387254]  [<ffffffff81681b2e>] entry_SYSCALL_64_fastpath+0x12/0x7=
1
[  449.394432] ---[ end trace fa7203c8f83678c9 ]---


Environment: 4.2.0-rc3
[root@storageqe-09 ~]# lsblk=20
NAME                        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb                           8:16   0 931.5G  0 disk=20
=E2=94=94=E2=94=80sdb1                        8:17   0    10G  0 part=20
sdc                           8:32   0 931.5G  0 disk=20
=E2=94=94=E2=94=80sdc1                        8:33   0    10G  0 part=20
sdd                           8:48   0 931.5G  0 disk=20
=E2=94=94=E2=94=80sdd1                        8:49   0    10G  0 part=20
sde                           8:64   0 931.5G  0 disk=20
=E2=94=94=E2=94=80sde1                        8:65   0    10G  0 part=20
sdf                           8:80   0 931.5G  0 disk=20
=E2=94=94=E2=94=80sdf1                        8:81   0    10G  0 part=20
sdg                           8:96   0   3.7T  0 disk=20
=E2=94=94=E2=94=80sdg1                        8:97   0    10G  0 part=20
sdh                           8:112  0   3.7T  0 disk=20
=E2=94=94=E2=94=80sdh1                        8:113  0    10G  0 part
=20
Reproduce-steps:
While [ 1 ]
do
mdadm --create --run /dev/md0 --level 4 --metadata 1.2 --raid-devices 6=
 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 --spare-de=
vices 1 /dev/sdh1 --chunk 512
mdadm --wait /dev/md0
mkfs -t ext4 /dev/md0
mkdir /mnt/md_test
mount /dev/md0 /mnt/md_test
dd if=3D/dev/urandom of=3D/mnt/md_test/testfile bs=3D1M count=3D1000
md5sum /mnt/md_test/testfile > md5.old
umount /dev/md0
mdadm --grow -l0 /dev/md0  --backup-file=3Dtmp0
mdadm --wait /dev/md0
mount /dev/md0 /mnt/md_test
md5sum /mnt/md_test/testfile >md5.new                // kernel BUG at d=
rivers/scsi/scsi_lib.c:1101!
umount /dev/md0
mdadm -Ss
mdadm --zero-superblock /dev/sd[bcdefgh]1
done


Best Regards,
 Yi Zhang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
