From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target/iblock: Fix failed bd claim NULL pointer
	dereference
Date: Sat, 15 Jan 2011 16:25:19 -0800
Message-ID: <1295137519.22813.17.camel@haakon2.linux-iscsi.org>
References: <1295137302-26375-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1295137302-26375-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-01-15 at 16:21 -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds an explict check for struct iblock_dev->ibd_bd in
> iblock_free_device() before calling blkdev_put(), which will otherwise hit
> the following NULL pointer dereference @ ib_dev->ibd_bd when iblock_create_virtdevice()
> fails to claim an already in-use struct block_device via blkdev_get_by_path().
> 
> [  112.528578] Target_Core_ConfigFS: Allocated struct se_subsystem_dev: ffff88001e750000 se_dev_su_ptr: ffff88001dd05d70
> [  112.534681] Target_Core_ConfigFS: Calling t->free_device() for se_dev_su_ptr: ffff88001dd05d70
> [  112.535029] BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
> [  112.535029] IP: [<ffffffff814987a3>] mutex_lock+0x14/0x35
> [  112.535029] PGD 1e5d0067 PUD 1e274067 PMD 0
> [  112.535029] Oops: 0002 [#1] SMP
> [  112.535029] last sysfs file: /sys/devices/pci0000:00/0000:00:07.1/host2/target2:0:0/2:0:0:0/type
> [  112.535029] CPU 0
> [  112.535029] Modules linked in: iscsi_target_mod target_core_stgt scsi_tgt target_core_pscsi target_core_file target_core_iblock target_core_mod configfs sr_mod cdrom sd_mod ata_piix mptspi mptscsih libata mptbase [last unloaded: scsi_wait_scan]
> [  112.535029]
> [  112.535029] Pid: 3345, comm: python2.5 Not tainted 2.6.37+ #1 440BX Desktop Reference Platform/VMware Virtual Platform
> [  112.535029] RIP: 0010:[<ffffffff814987a3>]  [<ffffffff814987a3>] mutex_lock+0x14/0x35
> [  112.535029] RSP: 0018:ffff88001e6d7d58  EFLAGS: 00010246
> [  112.535029] RAX: 0000000000000000 RBX: 0000000000000020 RCX: 0000000000000082
> [  112.535029] RDX: ffff88001e6d7fd8 RSI: 0000000000000083 RDI: 0000000000000020
> [  112.535029] RBP: ffff88001e6d7d68 R08: 0000000000000000 R09: 0000000000000000
> [  112.535029] R10: ffff8800000be860 R11: ffff88001f420000 R12: 0000000000000020
> [  112.535029] R13: 0000000000000083 R14: ffff88001d809430 R15: ffff88001d8094f8
> [  112.535029] FS:  00007ff17ca7d6e0(0000) GS:ffff88001fa00000(0000) knlGS:0000000000000000
> [  112.535029] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  112.535029] CR2: 0000000000000020 CR3: 000000001e5d2000 CR4: 00000000000006f0
> [  112.535029] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  112.535029] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  112.535029] Process python2.5 (pid: 3345, threadinfo ffff88001e6d6000, task ffff88001e2d0760)
> [  112.535029] Stack:
> [  112.535029]  ffff88001e6d7d88 0000000000000000 ffff88001e6d7d98 ffffffff811187fc
> [  112.535029]  ffff88001d809430 ffff88001dd05d70 ffff88001e750860 ffff88001e750000
> [  112.535029]  ffff88001e6d7db8 ffffffffa00e3757 ffff88001e6d7db8 0000000000000004
> [  112.535029] Call Trace:
> [  112.535029]  [<ffffffff811187fc>] blkdev_put+0x28/0x107
> [  112.535029]  [<ffffffffa00e3757>] iblock_free_device+0x1d/0x36 [target_core_iblock]
> [  112.535029]  [<ffffffffa00a319c>] target_core_drop_subdev+0x15f/0x18d [target_core_mod]
> [  112.535029]  [<ffffffffa00960db>] client_drop_item+0x25/0x31 [configfs]
> [  112.535029]  [<ffffffffa00967b5>] configfs_rmdir+0x1a1/0x223 [configfs]
> [  112.535029]  [<ffffffff810fa8cd>] vfs_rmdir+0x7e/0xd3
> [  112.535029]  [<ffffffff810fc3be>] do_rmdir+0xa3/0xf4
> [  112.535029]  [<ffffffff810fc446>] sys_rmdir+0x11/0x13
> [  112.535029]  [<ffffffff81002a92>] system_call_fastpath+0x16/0x1b
> [  112.535029] Code: 8b 04 25 88 b5 00 00 48 2d d8 1f 00 00 48 89 43 18 31 c0 5e 5b c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 e8 c4 f7 ff ff 48 89 df <3e> ff 0f 79 05 e8 1e ff ff ff 65 48 8b 04 25 88 b5 00 00 48 2d
> [  112.535029] RIP  [<ffffffff814987a3>] mutex_lock+0x14/0x35
> [  112.535029]  RSP <ffff88001e6d7d58>
> [  112.535029] CR2: 0000000000000020
> [  132.679636] ---[ end trace 05754bb48eb828f0 ]---
> 
> Note it also adds an second explict check for ib_dev->ibd_bio_set before calling
> bioset_free() to fix the same possible NULL pointer deference during an early
> iblock_create_virtdevice() failure.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_iblock.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 

Hi James,

This bugfix been pushed into lio-core-2.6.git/linus-38-rc1 and
cherry-picked into scsi-post-merge-2.6.git/for-jejb.

Please let me know if you have any questions.

Thanks!

--nab
