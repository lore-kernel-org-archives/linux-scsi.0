From: Dmitry Vyukov <dvyukov@google.com>
Subject: Potential data race in __scsi_init_queue/ata_sg_setup
Date: Mon, 21 Sep 2015 11:58:35 +0200
Message-ID: <CACT4Y+YTn7eGYaP1aHM1L+6CYoXOTe0ArnKHQs02ELzYPjnwhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: JBottomley@odin.com, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Cc: Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@google.com>, ktsan@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

Hello,

We are working on a data race detector for kernel, KernelThreadSanitize=
r (KTSAN.
I am getting the following reports (on 4.2 rc2) between
__scsi_init_queue and ata_sg_setup. The reports suggest that
dev->dma_parms->max_segment_size is being used before it is
initialized. I would expect that request_queue somehow becomes
accessible to other threads before all the associated data structures
are completely initialized. I've tried to verify that hypothesis but
got lost along the way.
Can somebody familiar with this code please take a look? I will
appreciate if you either confirm that this is a bug, or explain why
this is not a bug (how the accesses are synchronized with each other).
Thank you in advance.


ThreadSanitizer: data-race in __scsi_init_queue

Write at 0xffff880484c87070 of size 8 by thread 6 on CPU 0:
 [<     inline     >] dma_set_seg_boundary include/linux/dma-mapping.h:=
170
 [<ffffffff81899e81>] __scsi_init_queue+0x151/0x290 drivers/scsi/scsi_l=
ib.c:2119
 [<ffffffff81899ff3>] __scsi_alloc_queue+0x33/0x40 drivers/scsi/scsi_li=
b.c:2142
 [<ffffffff8189f43c>] scsi_alloc_queue+0x2c/0x90 drivers/scsi/scsi_lib.=
c:2151
 [<ffffffff818a098f>] scsi_alloc_sdev+0x3cf/0x600 drivers/scsi/scsi_sca=
n.c:266
 [<ffffffff818a1a24>] scsi_probe_and_add_lun+0xd34/0x1180
drivers/scsi/scsi_scan.c:1079
 [<ffffffff818a271d>] __scsi_add_device+0x13d/0x150
drivers/scsi/scsi_scan.c:1487
 [<ffffffff818daf96>] ata_scsi_scan_host+0xf6/0x270
drivers/ata/libata-scsi.c:3736
 [<ffffffff818d2f1e>] async_port_probe+0x6e/0x90 drivers/ata/libata-cor=
e.c:6096
 [<ffffffff810c038d>] async_run_entry_fn+0x7d/0x1e0 kernel/async.c:123
 [<ffffffff810b1d6e>] process_one_work+0x47e/0x930 kernel/workqueue.c:2=
036
 [<ffffffff810b22d0>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S=
:529

Previous read at 0xffff880484c87070 of size 8 by thread 763 on CPU 4:
 [<     inline     >] dma_get_seg_boundary include/linux/dma-mapping.h:=
164
 [<ffffffff815843c0>] swiotlb_tbl_map_single+0x70/0x410 lib/swiotlb.c:4=
41
 [<     inline     >] map_single lib/swiotlb.c:546
 [<ffffffff81585972>] swiotlb_map_sg_attrs+0x172/0x240 lib/swiotlb.c:89=
3
 [<     inline     >] dma_map_sg_attrs
include/asm-generic/dma-mapping-common.h:57
 [<     inline     >] ata_sg_setup drivers/ata/libata-core.c:4719
 [<ffffffff818cb5e3>] ata_qc_issue+0x533/0x750 drivers/ata/libata-core.=
c:5078
 [<ffffffff818d5999>] ata_scsi_translate+0x189/0x2c0
drivers/ata/libata-scsi.c:1864
 [<     inline     >] __ata_scsi_queuecmd drivers/ata/libata-scsi.c:348=
1
 [<ffffffff818da62e>] ata_scsi_queuecmd+0x11e/0x370
drivers/ata/libata-scsi.c:3530
 [<ffffffff8189a1d3>] scsi_dispatch_cmd+0x183/0x2f0 drivers/scsi/scsi_l=
ib.c:1718
 [<ffffffff8189e823>] scsi_request_fn+0x903/0xb20 drivers/scsi/scsi_lib=
=2Ec:1853
 [<     inline     >] __blk_run_queue_uncond block/blk-core.c:310
 [<ffffffff8150c06f>] __blk_run_queue+0x6f/0xa0 block/blk-core.c:328
 [<ffffffff815099b1>] __elv_add_request+0x191/0x4e0 block/elevator.c:63=
3
 [<     inline     >] add_acct_request block/blk-core.c:1336
 [<ffffffff81516911>] blk_queue_bio+0x511/0x520 block/blk-core.c:1710
 [<ffffffff8150e30b>] generic_make_request+0x17b/0x1f0 block/blk-core.c=
:1970
 [<ffffffff8150e432>] submit_bio+0xb2/0x250 block/blk-core.c:2022
 [<ffffffff812ba1fa>] submit_bh_wbc.isra.34+0x23a/0x270 fs/buffer.c:306=
8
 [<     inline     >] submit_bh fs/buffer.c:3080
 [<ffffffff812ba7ad>] block_read_full_page+0x3ad/0x440 fs/buffer.c:2262
 [<ffffffff812be784>] blkdev_readpage+0x24/0x40 fs/block_dev.c:294
 [<     inline     >] __read_cache_page mm/filemap.c:2188
 [<ffffffff811cd3a1>] do_read_cache_page+0x81/0x1d0 mm/filemap.c:2210
 [<ffffffff811cd535>] read_cache_page+0x45/0x60 mm/filemap.c:2257
 [<     inline     >] read_mapping_page include/linux/pagemap.h:381
 [<ffffffff81532798>] read_dev_sector+0x68/0xf0 block/partition-generic=
=2Ec:557
 [<     inline     >] read_part_sector block/partitions/check.h:37
 [<ffffffff815344f0>] amiga_partition+0xa0/0x6a0 block/partitions/amiga=
=2Ec:42
 [<ffffffff81534225>] check_partition+0x1b5/0x300 block/partitions/chec=
k.c:166
 [<ffffffff81533377>] rescan_partitions+0x127/0x400
block/partition-generic.c:433 (discriminator 1)
 [<ffffffff812c0758>] __blkdev_get+0x418/0x650 fs/block_dev.c:1220
 [<ffffffff812c0e18>] blkdev_get+0x1c8/0x5f0 fs/block_dev.c:1324
 [<     inline     >] register_disk block/genhd.c:557
 [<ffffffff8152f9e8>] add_disk+0x688/0x760 block/genhd.c:619
 [<ffffffff818b72c8>] sd_probe_async+0x298/0x370 drivers/scsi/sd.c:2896
 [<ffffffff810c038d>] async_run_entry_fn+0x7d/0x1e0 kernel/async.c:123
 [<ffffffff810b1d6e>] process_one_work+0x47e/0x930 kernel/workqueue.c:2=
036
 [<ffffffff810b22d0>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S=
:529

Mutexes locked by thread 6:
Mutex 98677 is locked here:
 [<ffffffff81ee0407>] mutex_lock+0x57/0x70 kernel/locking/mutex.c:108
 [<ffffffff818a268c>] __scsi_add_device+0xac/0x150 drivers/scsi/scsi_sc=
an.c:1482
 [<ffffffff818daf96>] ata_scsi_scan_host+0xf6/0x270
drivers/ata/libata-scsi.c:3736
 [<ffffffff818d2f1e>] async_port_probe+0x6e/0x90 drivers/ata/libata-cor=
e.c:6096
 [<ffffffff810c038d>] async_run_entry_fn+0x7d/0x1e0 kernel/async.c:123
 [<ffffffff810b1d6e>] process_one_work+0x47e/0x930 kernel/workqueue.c:2=
036
 [<ffffffff810b22d0>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S=
:529

Mutexes locked by thread 763:
Mutex 106894 is locked here:
 [<ffffffff81ee0407>] mutex_lock+0x57/0x70 kernel/locking/mutex.c:108
 [<ffffffff812c03c7>] __blkdev_get+0x87/0x650 fs/block_dev.c:1177
 [<ffffffff812c0e18>] blkdev_get+0x1c8/0x5f0 fs/block_dev.c:1324
 [<     inline     >] register_disk block/genhd.c:557
 [<ffffffff8152f9e8>] add_disk+0x688/0x760 block/genhd.c:619
 [<ffffffff818b72c8>] sd_probe_async+0x298/0x370 drivers/scsi/sd.c:2896
 [<ffffffff810c038d>] async_run_entry_fn+0x7d/0x1e0 kernel/async.c:123
 [<ffffffff810b1d6e>] process_one_work+0x47e/0x930 kernel/workqueue.c:2=
036
 [<ffffffff810b22d0>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S=
:529

Mutex 103680 is locked here:
 [<     inline     >] __raw_spin_lock_irqsave
include/linux/spinlock_api_smp.h:129
 [<ffffffff81ee3b84>] _raw_spin_lock_irqsave+0x64/0x80
kernel/locking/spinlock.c:159
 [<ffffffff818da567>] ata_scsi_queuecmd+0x57/0x370
drivers/ata/libata-scsi.c:3524
 [<ffffffff8189a1d3>] scsi_dispatch_cmd+0x183/0x2f0 drivers/scsi/scsi_l=
ib.c:1718
 [<ffffffff8189e823>] scsi_request_fn+0x903/0xb20 drivers/scsi/scsi_lib=
=2Ec:1853
 [<     inline     >] __blk_run_queue_uncond block/blk-core.c:310
 [<ffffffff8150c06f>] __blk_run_queue+0x6f/0xa0 block/blk-core.c:328
 [<ffffffff815099b1>] __elv_add_request+0x191/0x4e0 block/elevator.c:63=
3
 [<     inline     >] add_acct_request block/blk-core.c:1336
 [<ffffffff81516911>] blk_queue_bio+0x511/0x520 block/blk-core.c:1710
 [<ffffffff8150e30b>] generic_make_request+0x17b/0x1f0 block/blk-core.c=
:1970
 [<ffffffff8150e432>] submit_bio+0xb2/0x250 block/blk-core.c:2022
 [<ffffffff812ba1fa>] submit_bh_wbc.isra.34+0x23a/0x270 fs/buffer.c:306=
8
 [<     inline     >] submit_bh fs/buffer.c:3080
 [<ffffffff812ba7ad>] block_read_full_page+0x3ad/0x440 fs/buffer.c:2262
 [<ffffffff812be784>] blkdev_readpage+0x24/0x40 fs/block_dev.c:294
 [<     inline     >] __read_cache_page mm/filemap.c:2188
 [<ffffffff811cd3a1>] do_read_cache_page+0x81/0x1d0 mm/filemap.c:2210
 [<ffffffff811cd535>] read_cache_page+0x45/0x60 mm/filemap.c:2257
 [<     inline     >] read_mapping_page include/linux/pagemap.h:381
 [<ffffffff81532798>] read_dev_sector+0x68/0xf0 block/partition-generic=
=2Ec:557
 [<     inline     >] read_part_sector block/partitions/check.h:37
 [<ffffffff815344f0>] amiga_partition+0xa0/0x6a0 block/partitions/amiga=
=2Ec:42
 [<ffffffff81534225>] check_partition+0x1b5/0x300 block/partitions/chec=
k.c:166
 [<ffffffff81533377>] rescan_partitions+0x127/0x400
block/partition-generic.c:433 (discriminator 1)
 [<ffffffff812c0758>] __blkdev_get+0x418/0x650 fs/block_dev.c:1220
 [<ffffffff812c0e18>] blkdev_get+0x1c8/0x5f0 fs/block_dev.c:1324
 [<     inline     >] register_disk block/genhd.c:557
 [<ffffffff8152f9e8>] add_disk+0x688/0x760 block/genhd.c:619
 [<ffffffff818b72c8>] sd_probe_async+0x298/0x370 drivers/scsi/sd.c:2896
 [<ffffffff810c038d>] async_run_entry_fn+0x7d/0x1e0 kernel/async.c:123
 [<ffffffff810b1d6e>] process_one_work+0x47e/0x930 kernel/workqueue.c:2=
036
 [<ffffffff810b22d0>] worker_thread+0xb0/0x900 kernel/workqueue.c:2170
 [<ffffffff810bba40>] kthread+0x150/0x170 kernel/kthread.c:209
 [<ffffffff81ee420f>] ret_from_fork+0x3f/0x70 arch/x86/entry/entry_64.S=
:529


--=20
Dmitry Vyukov, Software Engineer, dvyukov@google.com
Google Germany GmbH, Dienerstra=C3=9Fe 12, 80331, M=C3=BCnchen
Gesch=C3=A4ftsf=C3=BChrer: Graham Law, Christine Elizabeth Flores
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
Diese E-Mail ist vertraulich. Wenn Sie nicht der richtige Adressat
sind, leiten Sie diese bitte nicht weiter, informieren Sie den
Absender und l=C3=B6schen Sie die E-Mail und alle Anh=C3=A4nge. Vielen =
Dank.
This e-mail is confidential. If you are not the right addressee please
do not forward it, please inform the sender, and please erase this
e-mail including any attachments. Thanks.
