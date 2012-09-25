From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: next-20120925: BUG at drivers/scsi/scsi_lib.c:640!
Date: Tue, 25 Sep 2012 15:57:26 -0700
Message-ID: <20120925155726.f1c0a79f.akpm@linux-foundation.org>
References: <87wqzi3rki.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2IYW51 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2012 18:57:27 -0400
In-Reply-To: <87wqzi3rki.fsf@openvz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

(cc's added)

On Tue, 25 Sep 2012 22:06:37 +0400
Dmitry Monakhov <dmonakhov@openvz.org> wrote:

> 
> Seems like barriers are broken again
> 
>  kernel BUG at drivers/scsi/scsi_lib.c:1180!
>  invalid opcode: 0000 [#1] SMP 
>  Modules linked in: coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button ext3 jbd mbcache sd_mod crc_t10dif\
> elper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
>  CPU 0 
>  Pid: 753, comm: fsck.ext3 Not tainted 3.6.0-rc7-next-20120925+ #4                  /DQ67SW
>  RIP: 0010:[<ffffffff81470dbc>]  [<ffffffff81470dbc>] scsi_setup_fs_cmnd+0xec/0x180
>  RSP: 0018:ffff880233aff9f8  EFLAGS: 00010002
>  RAX: 0000000000000003 RBX: ffff88022a741000 RCX: 0000000000000002
>  RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81f32b48
>  RBP: ffff880233affa18 R08: 0000000000000001 R09: 0000000000000000
>  R10: ffff88022a26c800 R11: 0000000000000000 R12: ffff880229369968
>  R13: 0000000000000001 R14: ffff88022a741000 R15: 0000000000000000
>  FS:  00007f1348632760(0000) GS:ffff88023e200000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000003a3dc0e550 CR3: 00000002338cf000 CR4: 00000000000407f0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process fsck.ext3 (pid: 753, threadinfo ffff880233afe000, task ffff880233f48240)
>  Stack:
>   ffff880233affa48 ffff880229369968 0000000000000001 ffff880229bdb550
>   ffff880233affaa8 ffffffffa00a8860 ffff880233affab8 0000000000000082
>   0000000000000000 ffffffff8107d696 ffff880200000000 ffffffff817410d8
>  Call Trace:
>   [<ffffffffa00a8860>] sd_prep_fn+0x140/0xfe0 [sd_mod]
>   [<ffffffff8107d696>] ? lock_timer_base+0x76/0xf0
>   [<ffffffff817410d8>] ? _raw_spin_unlock_irq+0x48/0x80
>   [<ffffffff8130023c>] blk_peek_request+0x23c/0x450
>   [<ffffffff8146fad0>] scsi_request_fn+0x70/0x820
>   [<ffffffff812f54e5>] __blk_run_queue+0x55/0x70
>   [<ffffffff8132a065>] cfq_rq_enqueued+0x155/0x1c0
>   [<ffffffff8132a386>] cfq_insert_request+0x2b6/0x2f0
>   [<ffffffff8132a11d>] ? cfq_insert_request+0x4d/0x2f0
>   [<ffffffff812f002f>] ? md5_final+0x9f/0x130
>   [<ffffffff810e5463>] ? __lock_release+0xc3/0xe0
>   [<ffffffff812fe074>] ? drive_stat_acct+0x334/0x3b0
>   [<ffffffff812f4be6>] __elv_add_request+0x2a6/0x350
>   [<ffffffff813010fb>] blk_queue_bio+0x52b/0x570
>   [<ffffffff812fd8f5>] generic_make_request+0x125/0x1c0
>   [<ffffffff812fdb68>] submit_bio+0x1d8/0x240
>   [<ffffffff81250c63>] ? bio_alloc_bioset+0x103/0x1e0
>   [<ffffffff813039e7>] blkdev_issue_flush+0x177/0x200
>   [<ffffffff81253afa>] blkdev_fsync+0x4a/0x70
>   [<ffffffff81245af6>] vfs_fsync_range+0x36/0x60
>   [<ffffffff81245b3c>] vfs_fsync+0x1c/0x20
>   [<ffffffff81245ea8>] do_fsync+0x58/0x90
>   [<ffffffff81246100>] sys_fsync+0x10/0x20
>   [<ffffffff8174e539>] system_call_fastpath+0x16/0x1b
>  Code: 00 48 c7 c7 48 2b f3 81 41 0f 94 c5 31 d2 44 89 ee e8 d9 e4 cd ff 49 63 c5 48 83 c0 02 48 83 04 c5 b0 a5 13 82 01 45 85 ed 74 04 <0f\
>  48 89 df 31 db e8 a3 f6 ff ff 48 85 c0 48 
>  RIP  [<ffffffff81470dbc>] scsi_setup_fs_cmnd+0xec/0x180
>   RSP <ffff880233aff9f8>
> 
> 
>  ------------[ cut here ]------------
>  kernel BUG at drivers/scsi/scsi_lib.c:640!
>  invalid opcode: 0000 [#1] SMP 
>  Modules linked in: coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode sg xhci_hcd button ext3 jbd mbcache sd_mod crc_t10dif\
> elper cryptd lrw aes_x86_64 xts gf128mul ahci libahci pata_acpi ata_generic dm_mirror dm_region_hash dm_log dm_mod
>  CPU 0 
>  Pid: 727, comm: fsck.ext3 Not tainted 3.6.0-rc7-next-20120925+ #5                  /DQ67SW
>  RIP: 0010:[<ffffffff81470585>]  [<ffffffff81470585>] scsi_alloc_sgtable+0x55/0xe0
>  RSP: 0018:ffff880228215aa8  EFLAGS: 00010002
>  RAX: 0000000000000003 RBX: ffff880228111a18 RCX: 0000000000000001
>  RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81f32a08
>  RBP: ffff880228215ac8 R08: 0000000000000001 R09: 0000000000000000
>  R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000000
>  R13: 0000000000000020 R14: 0000000000000001 R15: 0000000000000000
>  FS:  00007fb605f35760(0000) GS:ffff88023e200000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000003a3dc0e550 CR3: 0000000233e83000 CR4: 00000000000407f0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process fsck.ext3 (pid: 727, threadinfo ffff880228214000, task ffff880233af8c80)
>  Stack:
>   ffff880228111a18 ffff88022a0a0638 0000000000000000 ffff88022a679000
>   ffff880228215b08 ffffffff81470641 ffff8802281119c0 ffff88022a679000
>   ffff880228215b28 ffff8802281119c0 ffff88022a0a0638 0000000000000020
>  Call Trace:
>   [<ffffffff81470641>] scsi_init_sgtable+0x31/0xe0
>   [<ffffffff81470a2d>] scsi_init_io+0x3d/0x2e0
>   [<ffffffff81470e23>] scsi_setup_fs_cmnd+0x153/0x180
>   [<ffffffffa00a8860>] sd_prep_fn+0x140/0xfe0 [sd_mod]
>   [<ffffffff8135afec>] ? __list_add+0x15c/0x180
>   [<ffffffff812f445b>] ? elv_dispatch_sort+0x17b/0x180
>   [<ffffffff8130023c>] blk_peek_request+0x23c/0x450
>   [<ffffffff8146fad0>] scsi_request_fn+0x70/0x820
>   [<ffffffff812f54e5>] __blk_run_queue+0x55/0x70
>   [<ffffffff81301103>] blk_queue_bio+0x533/0x570
>   [<ffffffff812fd8f5>] generic_make_request+0x125/0x1c0
>   [<ffffffff812fdb68>] submit_bio+0x1d8/0x240
>   [<ffffffff81250c63>] ? bio_alloc_bioset+0x103/0x1e0
>   [<ffffffff813039e7>] blkdev_issue_flush+0x177/0x200
>   [<ffffffff81253afa>] blkdev_fsync+0x4a/0x70
>   [<ffffffff81245af6>] vfs_fsync_range+0x36/0x60
>   [<ffffffff81245b3c>] vfs_fsync+0x1c/0x20
>   [<ffffffff81245ea8>] do_fsync+0x58/0x90
>   [<ffffffff81246100>] sys_fsync+0x10/0x20
>   [<ffffffff8174e539>] system_call_fastpath+0x16/0x1b
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
