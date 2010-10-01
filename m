From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: Thu, 30 Sep 2010 18:34:58 -0700
Message-ID: <1285896898.18417.156.camel@haakon2.linux-iscsi.org>
References: <20100930211006.27449.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100930211006.27449.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, Tejun Heo <tj@kernel.org>, Jeff Garzik <jeff@garzik.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-09-30 at 17:10 -0400, George Spelvin wrote:
> Supposedly 2c7d46ec192e4f2b350f67a0e185b9bce646cd6b in Linus' tree
> fixes thus bug, but I can trigger it reliably by asking for a check
> of a RAID-1 volume.  ("echo check > /sys/block/md6/md/sync_action")
> 
> This particular volume is a 10-way (!) RAID-1, but I suspect smaller
> numbers will work.
> 
> The same BUG is triggered on a RAID-10 thread for a volume that shares
> the same physical drives.  Note that a check of *that* volume (md7)
> does not trigger the problem.
> 
> 2.6.35 does NOT exhibit this problem.
> 
> Here are two full kernel logs, boot to crash.  There are some local patches,
> but they are quite unrelated.  (Mostly PPS device changes.)
> 
> 
> 18:56:20: klogd 1.5.0#6, log source = /proc/kmsg started.
> 18:56:20: Linux version 2.6.36-rc6-00070-g44c064a ($USER@$HOST) (gcc version 4.4.5 (Debian 4.4.4-17) ) #308 SMP Thu Sep 30 14:14:07 EDT 2010
> 18:56:20: Command line: auto BOOT_IMAGE=2.6 ro root=907 libata.fua=1 tsc_khz=2500210 amd64_edac_mod.ecc_enable_override=1 acpi_enforce_resources=lax k10temp.force=1

Ok, so libata.fua=1 is set here..

<SNIP>

> 20:44:45: ata4.00: SB600 AHCI: limiting to 255 sectors per cmd
> 20:44:45: ata4: EH complete
> 20:44:45: ata5.00: configured for UDMA/133
> 20:44:45: ata5: EH complete
> 20:44:45: ata6.00: configured for UDMA/133
> 20:44:45: Adding 7968124k swap on /dev/md8.  Priority:0 extents:1 across:7968124k 
> 20:44:45: EXT4-fs (md7): re-mounted. Opts: journal_checksum,journal_async_commit,delalloc,auto_da_alloc
> 20:44:45: EXT4-fs (md10): mounted filesystem with ordered data mode. Opts: journal_checksum,journal_async_commit,delalloc,auto_da_alloc
> 20:44:45: alg: No test for digest_null (digest_null-generic)
> 20:44:45: alg: No test for compress_null (compress_null-generic)
> 20:45:14: r8169 0000:03:00.0: eth0: link up
> 20:47:59: md: data-check of RAID array md6
> 20:47:59: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> 20:47:59: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> 20:47:59: md: using 128k window, over a total of 1166912 blocks.
> 20:47:59: ata1.00: WARNING: zero len r/w req

Ok, it looks like MD is sending down a zero-length CDB but still
signaling DMA_FROM_DEVICE or DMA_TO_DEVICE for the struct scsi_cmnd I/O
descriptor being translated ATA in drivers/ata/libata-scsi.c:
ata_scsi_translate().

> 20:47:59: ------------[ cut here ]------------
> 20:47:59: kernel BUG at drivers/scsi/scsi_lib.c:1113!

This BUG_ON() is getting triggered in scsi_setup_fs_cmnd() which is
called for each struct request of type REQ_TYPE_FS:

        /*
         * Filesystem requests must transfer data.
         */
        BUG_ON(!req->nr_phys_segments);

I am guessing these are related to the barrier + FUA changes in .36
that with libata.fua=1 is triggering drivers/md/raid1.c to send down a
zero-length barrier request in the form of a a struct request with the
REQ WRITE bit set:

>From a quick look drivers/md/md.c:submit_barriers():

	<SNIP>
         bi = bio_alloc(GFP_KERNEL, 0);
         bi->bi_end_io = md_end_barrier;
         bi->bi_private = rdev;
         bi->bi_bdev = rdev->bdev;
         atomic_inc(&mddev->flush_pending);
         submit_bio(WRITE_BARRIER, bi);
	<SNIP>

I wonder if this could be possibly the root culprit..?  That is
submit_bio(WRITE_BARRER, ..) setting:

	struct request->rw_flags = REQ_WRITE | REQ_SYNC 

and getting into translated into a SYCHRONIZE_CACHE CDB in drivers/scsi
and sets

	struct scsi_cmnd->sc_data_direction = DMA_TO_DEVICE;

with scsi_bufflen(sc) returning a zero length and finally hitting the
!request->nr_phys_segments hitting the BUG_ON() in scsi_setup_fs_cmnd()
show above..

I have not been able to pinpoint the actual breakage just yet, but
hopefully Jens and Tejun can have a look soon and add their comments so
this can be resolved for .36-rc7.

Thanks for reporting!

--nab


> 20:47:59: invalid opcode: 0000 [#1] SMP 
> 20:47:59: last sysfs file: /sys/devices/virtual/block/md6/md/sync_action
> 20:47:59: CPU 2 
> 20:47:59: Modules linked in: ctr twofish_generic twofish_x86_64 twofish_common serpent xcbc sha512_generic sha256_generic crypto_null ipg 8250_pci 8250_pnp 8250 serial_core
> 20:47:59: 
> 20:47:59: Pid: 9537, comm: md6_resync Not tainted 2.6.36-rc6-00070-g44c064a #308 MS-7376/MS-7376
> 20:47:59: RIP: 0010:[<ffffffff812ab746>]  [<ffffffff812ab746>] scsi_setup_fs_cmnd+0x4e/0xbb
> 20:47:59: RSP: 0018:ffff880218de3ad0  EFLAGS: 00010046
> 20:47:59: RAX: 0000000000000000 RBX: ffff88021a8b4b88 RCX: ffff88021f3c2320
> 20:47:59: RDX: 0000000000000000 RSI: ffff88021a8b4b88 RDI: ffff88021f513000
> 20:47:59: RBP: ffff880218de3ae0 R08: 00000000000003e8 R09: ffff880218de3ae0
> 20:47:59: R10: 0000000000000000 R11: ffff880218de3ae0 R12: ffff88021f513000
> 20:47:59: R13: ffff880218de3b58 R14: 0000000000000000 R15: ffff88021f512c00
> 20:47:59: FS:  00007fdf8b89f700(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
> 20:47:59: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> 20:47:59: CR2: 0000003a10c1e8f0 CR3: 000000000164a000 CR4: 00000000000006e0
> 20:47:59: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> 20:47:59: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 20:47:59: Process md6_resync (pid: 9537, threadinfo ffff880218de2000, task ffff88021c53ac00)
> 20:47:59: Stack:
> 20:47:59:  ffff88021a8b4b88 ffff88021f513000 ffff880218de3b40 ffffffff812b171d
> 20:47:59: <0> ffff88021f604068 ffff88021f6040b8 000000001f604158 ffff88021f3c2320
> 20:47:59: <0> ffff880218de3b40 ffff88021a8b4b88 ffff88021f3c2320 ffff880218de3b58
> 20:47:59: Call Trace:
> 20:47:59:  [<ffffffff812b171d>] sd_prep_fn+0x241/0x868
> 20:47:59:  [<ffffffff81160487>] blk_peek_request+0xb3/0x177
> 20:47:59:  [<ffffffff812aae96>] scsi_request_fn+0x84/0x424
> 20:47:59:  [<ffffffff81160d9c>] __generic_unplug_device+0x32/0x37
> 20:47:59:  [<ffffffff81160dcc>] generic_unplug_device+0x2b/0x3a
> 20:47:59:  [<ffffffff8115f0de>] blk_unplug+0x12/0x14
> 20:47:59:  [<ffffffff81306b31>] unplug_slaves+0x69/0x9f
> 20:47:59:  [<ffffffff81306b7f>] raid1_unplug+0x18/0x28
> 20:47:59:  [<ffffffff8115f0de>] blk_unplug+0x12/0x14
> 20:47:59:  [<ffffffff8131aa72>] md_unplug+0x1d/0x33
> 20:47:59:  [<ffffffff8131b3d4>] md_do_sync+0x94c/0xba6
> 20:47:59:  [<ffffffff8102f88f>] ? finish_task_switch+0x34/0x74
> 20:47:59:  [<ffffffff8131ba3a>] md_thread+0xf6/0x114
> 20:47:59:  [<ffffffff8131b944>] ? md_thread+0x0/0x114
> 20:47:59:  [<ffffffff8131b944>] ? md_thread+0x0/0x114
> 20:47:59:  [<ffffffff81049e4f>] kthread+0x7d/0x85
> 20:47:59:  [<ffffffff81002c94>] kernel_thread_helper+0x4/0x10
> 20:47:59:  [<ffffffff81049dd2>] ? kthread+0x0/0x85
> 20:47:59:  [<ffffffff81002c90>] ? kernel_thread_helper+0x0/0x10
> 20:47:59: Code: 85 c0 74 1d 48 8b 00 48 85 c0 74 15 48 8b 40 48 48 85 c0 74 0c 48 89 de 4c 89 e7 ff d0 85 c0 75 72 66 83 bb c0 00 00 00 00 75 04 <0f> 0b eb fe 48 8b 93 c8 00 00 00 48 85 d2 75 21 be 20 00 00 00 
> 20:47:59: RIP  [<ffffffff812ab746>] scsi_setup_fs_cmnd+0x4e/0xbb
> 20:47:59:  RSP <ffff880218de3ad0>
> 20:47:59: ---[ end trace 1e250084e0863623 ]---
> 20:48:01: ------------[ cut here ]------------
> 20:48:01: kernel BUG at drivers/scsi/scsi_lib.c:1113!
> 20:48:01: invalid opcode: 0000 [#2] SMP 
> 20:48:01: last sysfs file: /sys/devices/virtual/block/md6/md/sync_action
> 20:48:01: CPU 3 
> 20:48:01: Modules linked in: ctr twofish_generic twofish_x86_64 twofish_common serpent xcbc sha512_generic sha256_generic crypto_null ipg 8250_pci 8250_pnp 8250 serial_core
> 20:48:01: 
> 20:48:01: Pid: 947, comm: md7_raid10 Tainted: G      D     2.6.36-rc6-00070-g44c064a #308 MS-7376/MS-7376
> 20:48:01: RIP: 0010:[<ffffffff812ab746>]  [<ffffffff812ab746>] scsi_setup_fs_cmnd+0x4e/0xbb
> 20:48:01: RSP: 0018:ffff88021f4b1930  EFLAGS: 00010046
> 20:48:01: RAX: 0000000000000000 RBX: ffff88021a8b4f60 RCX: 0000000000000000
> 20:48:01: RDX: 0000000000000000 RSI: ffff88021a8b4f60 RDI: ffff88021f3ca400
> 20:48:01: RBP: ffff88021f4b1940 R08: 0000000000052800 R09: 0000000000000000
> 20:48:01: R10: ffff88021f4b19d0 R11: ffff88021f4b19f0 R12: ffff88021f3ca400
> 20:48:01: R13: ffff88021f4b19b8 R14: 0000000000000000 R15: ffff88021f3cbc00
> 20:48:01: FS:  00007fce18ce5720(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
> 20:48:01: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> 20:48:01: CR2: 0000003a10c6e5a0 CR3: 000000021b00c000 CR4: 00000000000006e0
> 20:48:01: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> 20:48:01: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> 20:48:01: Process md7_raid10 (pid: 947, threadinfo ffff88021f4b0000, task ffff88021f384200)
> 20:48:01: Stack:
> 20:48:01:  ffff88021a8b4f60 ffff88021f3ca400 ffff88021f4b19a0 ffffffff812b171d
> 20:48:01: <0> ffff88021f4b1970 ffffffff8115eb7e 000000001f597008 ffff88021e821a58
> 20:48:01: <0> ffff88021f4b1990 ffff88021a8b4f60 ffff88021e821a58 ffff88021f4b19b8
> 20:48:01: Call Trace:
> 20:48:01:  [<ffffffff812b171d>] sd_prep_fn+0x241/0x868
> 20:48:01:  [<ffffffff8115eb7e>] ? elv_rb_del+0x30/0x49
> 20:48:01:  [<ffffffff81160487>] blk_peek_request+0xb3/0x177
> 20:48:01:  [<ffffffff812aae96>] scsi_request_fn+0x84/0x424
> 20:48:01:  [<ffffffff8103f279>] ? del_timer+0x7f/0x89
> 20:48:01:  [<ffffffff81160c18>] __blk_run_queue+0x3f/0x72
> 20:48:01:  [<ffffffff8115e831>] elv_insert+0x80/0x1a8
> 20:48:01:  [<ffffffff8115e9f1>] __elv_add_request+0x98/0x9f
> 20:48:01:  [<ffffffff8116174e>] __make_request+0x34a/0x3cd
> 20:48:01:  [<ffffffff8115feda>] generic_make_request+0x19a/0x204
> 20:48:01:  [<ffffffff8116000b>] submit_bio+0xc7/0xd0
> 20:48:01:  [<ffffffff810bb519>] ? bio_clone+0x39/0x44
> 20:48:01:  [<ffffffff8131be2b>] md_super_write+0xab/0xba
> 20:48:01:  [<ffffffff81322c77>] write_page+0x161/0x2c9
> 20:48:01:  [<ffffffff8102ad35>] ? dequeue_task_fair+0x201/0x210
> 20:48:01:  [<ffffffff81322eb6>] bitmap_update_sb+0xd7/0xdc
> 20:48:01:  [<ffffffff8131c210>] md_update_sb+0x1f6/0x2c9
> 20:48:01:  [<ffffffff8131dc20>] md_check_recovery+0x1b7/0x43f
> 20:48:01:  [<ffffffff8130af28>] raid10d+0x34/0x804
> 20:48:01:  [<ffffffff8103f1ce>] ? try_to_del_timer_sync+0x83/0x8f
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
