From: Scott Bauer <scott.bauer@intel.com>
Subject: BUG: KASAN: use-after-free in scsi_exit_rq
Date: Thu, 20 Apr 2017 15:18:51 -0600
Message-ID: <20170420211849.GB7387@sbauer-Z170X-UD5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:62306 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033765AbdDTVbC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Apr 2017 17:31:02 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@fb.com, hch@lst.de, linux-block@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

Hi all,

While running xfs test testing some other features scheduled for 4.12
I came across this KASAN dump:


[  638.913813] XFS (nvme0n1): Mounting V5 Filesystem
[  638.917934] XFS (nvme0n1): Ending clean mount
[  639.035070] blk_update_request: I/O error, dev nvme1n1, sector 0
[  639.071764] XFS (nvme1n1): Mounting V5 Filesystem
[  639.077052] XFS (nvme1n1): Ending clean mount
[  639.110634] XFS (nvme0n1): Unmounting Filesystem
[  639.260132] XFS (nvme0n1): Mounting V5 Filesystem
[  639.264141] XFS (nvme0n1): Ending clean mount
[  639.282112] run fstests generic/108 at 2017-04-20 14:30:05
[  639.525274] XFS (nvme1n1): Unmounting Filesystem
[  639.570999] scsi host2: scsi_debug: version 1.86 [20160430]
[  639.570999]   dev_size_mb=128, opts=0x0, submit_queues=1, statistics=0
[  639.573698] scsi 2:0:0:0: Direct-Access     Linux    scsi_debug       0186 PQ: 0 ANSI: 7
[  639.595927] sd 2:0:0:0: Attached scsi generic sg1 type 0
[  639.598290] sd 2:0:0:0: [sda] 262144 512-byte logical blocks: (134 MB/128 MiB)
[  639.599884] sd 2:0:0:0: [sda] Write Protect is off
[  639.600246] sd 2:0:0:0: [sda] Mode Sense: 73 00 10 08
[  639.602747] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
[  639.626440] sd 2:0:0:0: [sda] Attached SCSI disk
[  641.264666] XFS (dm-0): Mounting V5 Filesystem
[  641.278227] XFS (dm-0): Ending clean mount
[  641.394865] sd 2:0:0:0: rejecting I/O to offline device
[  641.395353] sd 2:0:0:0: rejecting I/O to offline device
[  641.395903] sd 2:0:0:0: rejecting I/O to offline device
[  641.396362] sd 2:0:0:0: rejecting I/O to offline device
[  641.396896] sd 2:0:0:0: rejecting I/O to offline device
[  641.397347] sd 2:0:0:0: rejecting I/O to offline device
[  641.397888] sd 2:0:0:0: rejecting I/O to offline device
[  641.398358] sd 2:0:0:0: rejecting I/O to offline device
[  641.400009] sd 2:0:0:0: rejecting I/O to offline device
[  641.400378] blk_update_request: I/O error, dev sda, sector 0
[  641.423308] XFS (dm-0): Unmounting Filesystem
[  642.585631] sd 2:0:0:0: [sda] Synchronizing SCSI cache
[  642.637953] ==================================================================
[  642.638860] BUG: KASAN: use-after-free in scsi_exit_rq+0xf3/0x120 at addr ffff8802b7fedf00
[  642.639362] Read of size 1 by task rcuos/5/53
[  642.639713] CPU: 7 PID: 53 Comm: rcuos/6 Not tainted 4.11.0-rc5+ #13
[  642.640170] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
[  642.640923] Call Trace:
[  642.641080]  dump_stack+0x63/0x8f
[  642.641289]  kasan_object_err+0x21/0x70
[  642.641531]  kasan_report.part.1+0x231/0x500
[  642.641823]  ? scsi_exit_rq+0xf3/0x120
[  642.642054]  ? _raw_spin_unlock_irqrestore+0xe/0x10
[  642.642353]  ? free_percpu+0x1b7/0x340
[  642.642586]  ? put_task_stack+0x117/0x2b0
[  642.642837]  __asan_report_load1_noabort+0x2e/0x30
[  642.643138]  scsi_exit_rq+0xf3/0x120
[  642.643366]  free_request_size+0x44/0x60
[  642.643614]  mempool_destroy.part.6+0x9b/0x150
[  642.643899]  ? kasan_slab_free+0x87/0xb0
[  642.644152]  mempool_destroy+0x13/0x20
[  642.644394]  blk_exit_rl+0x36/0x40
[  642.644614]  blkg_free+0x146/0x200
[  642.644836]  __blkg_release_rcu+0x121/0x220
[  642.645112]  rcu_nocb_kthread+0x61f/0xca0
[  642.645376]  ? get_state_synchronize_rcu+0x20/0x20
[  642.645690]  ? pci_mmcfg_check_reserved+0x110/0x110
[  642.646011]  kthread+0x298/0x390
[  642.646224]  ? get_state_synchronize_rcu+0x20/0x20
[  642.646535]  ? kthread_park+0x160/0x160
[  642.646787]  ret_from_fork+0x2c/0x40
[  642.647020] Object at ffff8802b7fedd80, in cache kmalloc-2048 size: 2048
[  642.647435] Allocated:
[  642.647591] PID = 3992
[  642.647750]  save_stack_trace+0x1b/0x20
[  642.648000]  save_stack+0x46/0xd0
[  642.648208]  kasan_kmalloc+0xad/0xe0
[  642.648441]  __kmalloc+0x134/0x220
[  642.648664]  scsi_host_alloc+0x6b/0x11c0
[  642.648919]  0xffffffffc101d94a
[  642.649124]  driver_probe_device+0x49e/0xc60
[  642.649398]  __device_attach_driver+0x1d3/0x2a0
[  642.649684]  bus_for_each_drv+0x11a/0x1d0
[  642.649946]  __device_attach+0x1e1/0x2c0
[  642.650200]  device_initial_probe+0x13/0x20
[  642.650557]  bus_probe_device+0x19b/0x240
[  642.651029]  device_add+0x86d/0x1450
[  642.651472]  device_register+0x1a/0x20
[  642.651778]  0xffffffffc10270ce
[  642.651990]  0xffffffffc1048a62
[  642.652197]  do_one_initcall+0xa7/0x250
[  642.652445]  do_init_module+0x1d0/0x55d
[  642.652696]  load_module+0x7c9f/0x9850
[  642.652937]  SYSC_finit_module+0x189/0x1c0
[  642.653200]  SyS_finit_module+0xe/0x10
[  642.653441]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[  642.653735] Freed:
[  642.653875] PID = 4128
[  642.654304]  save_stack_trace+0x1b/0x20
[  642.654991]  save_stack+0x46/0xd0
[  642.655200]  kasan_slab_free+0x71/0xb0
[  642.655434]  kfree+0x8d/0x1b0
[  642.655624]  scsi_host_dev_release+0x2cb/0x430
[  642.655898]  device_release+0x76/0x1e0
[  642.656141]  kobject_release+0x107/0x370
[  642.656387]  kobject_put+0x56/0xb0
[  642.656596]  put_device+0x17/0x20
[  642.656800]  scsi_host_put+0x15/0x20
[  642.657027]  0xffffffffc101fcd7
[  642.657225]  device_release_driver_internal+0x26a/0x4e0
[  642.657550]  device_release_driver+0x12/0x20
[  642.657821]  bus_remove_device+0x2d0/0x590
[  642.658071]  device_del+0x55b/0x920
[  642.658287]  device_unregister+0x1a/0xa0
[  642.658528]  0xffffffffc101e0ca
[  642.658723]  0xffffffffc102fccc
[  642.658933]  SyS_delete_module+0x334/0x3e0
[  642.659203]  entry_SYSCALL_64_fastpath+0x1a/0xa9
[  642.659505] Memory state around the buggy address:
[  642.659815]  ffff8802b7fede00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  642.660262]  ffff8802b7fede80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  642.660725] >ffff8802b7fedf00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  642.661187]                    ^
[  642.661398]  ffff8802b7fedf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  642.661854]  ffff8802b7fee000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[  642.662315] ==================================================================


I triggered this while running xfstests: generic/108.

I don't know how to fix this but I did debug it a bit and exposed a bit of the call chain
leading up to the bug.

The scsi code in scsi_alloc_queue sets up a prep_request fn:
blk_queue_prep_rq(q, scsi_prep_fn);

This function fails due to the: [  641.397347] sd 2:0:0:0: rejecting I/O to offline device

So we kick out a BLKPREP_KILL error. In blk-core.c: blk_peek_request we end up calling

__blk_end_request_all
  __blk_end_bidi_request
    blk_finish_request
      __blk_put_request
        blk_put_rl
	 * Triggers __blkg_release_rcu * which goes down the UAF call chain at the top



I'm not exactly sure who is causing a put_device causing the release(), I had an idea but
turned out to be wrong, so now I'm not sure why the driver is getting nuked.
I'm running on top of Jens' for-next tree with most recent commit:

commit b74baaabbc2da23c7870859316f9e15d10f876fe
Merge: 5e9a6fc caf7df1
Author: Jens Axboe <axboe@fb.com>
Date:   Thu Apr 20 12:16:19 2017 -0600

    Merge branch 'for-4.12/block' into for-next


I can test some patches, if necessary.
