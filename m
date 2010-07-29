From: Jan Kara <jack@suse.cz>
Subject: Re: extfs reliability
Date: Thu, 29 Jul 2010 16:26:50 +0200
Message-ID: <20100729142650.GA12690@quack.suse.cz>
References: <20100728082447.GA7668@lst.de>
 <4C4FECFE.9040509@kernel.org>
 <20100728085048.GA8884@lst.de>
 <4C4FF136.5000205@kernel.org>
 <20100728090025.GA9252@lst.de>
 <4C4FF592.9090800@kernel.org>
 <20100728092859.GA11096@lst.de>
 <20100729014431.GD4506@thunk.org>
 <20100729083142.GA30077@lst.de>
 <4C517B5A.3020905@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C517B5A.3020905@vlnb.net>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, James.Bottomley@suse.de, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org, kernel-bugs@lists.ubuntu.com
List-Id: linux-scsi@vger.kernel.org

On Thu 29-07-10 17:00:10, Vladislav Bolkhovitin wrote:
> Christoph Hellwig, on 07/29/2010 12:31 PM wrote:
> > My reading of the ext3/jbd code we explicitly wait on I/O completion
> > of dependent writes, and only require those to actually be stable
> > by issueing a flush.   If that wasn't the case the default ext3
> > barriers off behaviour would not only be dangerous on devices with
> > volatile write caches, but also on devices that do not have them,
> > which in addition to the reading of the code is not what we've seen
> > in actual power fail testing, where ext3 does well as long as there
> > is no volatile write cache.
> 
> Basically, it is so, but, unfortunately, not absolutely. I've just tried
> 2 tests on ext4 with iSCSI:
> 
> # uname -a
> Linux ini 2.6.32-22-386 #36-Ubuntu SMP Fri Jun 4 00:27:09 UTC 2010 i686 GNU/Linux
> 
> # e2fsck -f -y /dev/sdb
> e2fsck 1.41.11 (14-Mar-2010)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/sdb: 49/640000 files (0.0% non-contiguous), 56496/1280000 blocks
> root@ini:~# mount -t ext4 -o barrier=1 /dev/sdb /mnt
> root@ini:~# cd /mnt/dbench-mod/
> root@ini:/mnt/dbench-mod# ./dbench 50
> 50 clients started
> ...
> <-- Pull cable
> <-- After sometime a lot of warnings like:
> (22002) open CLIENTS/CLIENT44/~DMTMP/COREL/CDRBARS.CFG failed for handle 4235 (Read-only file system)
> (22004) open CLIENTS/CLIENT44/~DMTMP/COREL/ARTISTIC.ACL failed for handle 4236 (Read-only file system)
  ...
  These are OK. You pulled a cable and now you start getting EIO from the
kernel.

> root@ini:/mnt/dbench-mod# ^C
> root@ini:/mnt/dbench-mod# ^C
> root@ini:~# umount /mnt
> Segmentation fault
  This isn't OK of course ;)

> Kernel log:
> 
> Jul 29 19:55:35 ini kernel: [ 3044.722313] c2c28e40: 00023740 00023741 00023742 00023743  @7..A7..B7..C7..
> Jul 29 19:55:35 ini kernel: [ 3044.722320] c2c28e50: 00023744 00023745 00023746 00023747  D7..E7..F7..G7..
> Jul 29 19:55:35 ini kernel: [ 3044.722327] c2c28e60: 00023748 00023749 0002374a 0002374b  H7..I7..J7..K7..
> Jul 29 19:55:35 ini kernel: [ 3044.722334] c2c28e70: 0002372c 00000000 00000000 00000000  ,7..............
> Jul 29 19:55:35 ini kernel: [ 3044.722341] c2c28e80: 00000000 00000000 00000000 00000002  ................
...
Sadly these messages above seem to have overwritten beginning of the
message below. Hmm, but maybe it's just a warning message about inode still
being on orphan list because the next oops still shows untainted kernel.

> Jul 29 19:55:35 ini kernel: [ 3044.722546] Pid: 1299, comm: umount Not tainted 2.6.32-22-386 #36-Ubuntu
> Jul 29 19:55:35 ini kernel: [ 3044.722550] Call Trace:
> Jul 29 19:55:35 ini kernel: [ 3044.722567]  [<c0291731>] ext4_destroy_inode+0x91/0xa0
> Jul 29 19:55:35 ini kernel: [ 3044.722577]  [<c020ecb4>] destroy_inode+0x24/0x40
> Jul 29 19:55:35 ini kernel: [ 3044.722583]  [<c020f11e>] dispose_list+0x8e/0x100
> Jul 29 19:55:35 ini kernel: [ 3044.722588]  [<c020f534>] invalidate_inodes+0xf4/0x120
> Jul 29 19:55:35 ini kernel: [ 3044.722598]  [<c023b310>] ? vfs_quota_off+0x0/0x20
> Jul 29 19:55:35 ini kernel: [ 3044.722606]  [<c01fc602>] generic_shutdown_super+0x42/0xe0
> Jul 29 19:55:35 ini kernel: [ 3044.722612]  [<c01fc6ca>] kill_block_super+0x2a/0x50
> Jul 29 19:55:35 ini kernel: [ 3044.722618]  [<c01fd4e4>] deactivate_super+0x64/0x90
> Jul 29 19:55:35 ini kernel: [ 3044.722625]  [<c021282f>] mntput_no_expire+0x8f/0xe0
> Jul 29 19:55:35 ini kernel: [ 3044.722631]  [<c0212e47>] sys_umount+0x47/0xa0
> Jul 29 19:55:35 ini kernel: [ 3044.722636]  [<c0212ebe>] sys_oldumount+0x1e/0x20
> Jul 29 19:55:35 ini kernel: [ 3044.722643]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 19:55:35 ini kernel: [ 3044.731043] sd 6:0:0:0: [sdb] Unhandled error code
> Jul 29 19:55:35 ini kernel: [ 3044.731049] sd 6:0:0:0: [sdb] Result: hostbyte=DID_TRANSPORT_FAILFAST driverbyte=DRIVER_OK
> Jul 29 19:55:35 ini kernel: [ 3044.731056] sd 6:0:0:0: [sdb] CDB: Write(10): 2a 00 00 00 00 00 00 00 01 00
> Jul 29 19:55:35 ini kernel: [ 3044.743469] __ratelimit: 37 callbacks suppressed
> Jul 29 19:55:35 ini kernel: [ 3044.755695] lost page write due to I/O error on sdb
> Jul 29 19:55:36 ini kernel: [ 3044.823044] Modules linked in: crc32c ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi w83627hf hwmon_vid fbcon tileblit font bitblit softcursor ppdev adm1021 i2c_i801 vga16fb vgastate e7xxx_edac psmouse serio_raw parport_pc shpchp edac_core lp parport qla2xxx ohci1394 scsi_transport_fc r8169 sata_via ieee1394 mii scsi_tgt e1000 floppy
  So here probably starts the real oops. But sadly we are missing the
beginning as well. Can you send me disassembly of your ext4_put_super?

> Jul 29 19:55:36 ini kernel: [ 3044.823044] 
> Jul 29 19:55:36 ini kernel: [ 3044.823044] Pid: 1299, comm: umount Not tainted (2.6.32-22-386 #36-Ubuntu) X5DPA
> Jul 29 19:55:36 ini kernel: [ 3044.823044] EIP: 0060:[<c0293c2a>] EFLAGS: 00010206 CPU: 0
> Jul 29 19:55:36 ini kernel: [ 3044.823044] EIP is at ext4_put_super+0x2ea/0x350
> Jul 29 19:55:36 ini kernel: [ 3044.823044] EAX: c2c28ea8 EBX: c307f000 ECX: ffffff52 EDX: c307f138
> Jul 29 19:55:36 ini kernel: [ 3044.823044] ESI: ca228a00 EDI: c307f0fc EBP: cec6ff30 ESP: cec6fefc
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  c06bb054 ca228b64 0000800b c2c28ec8 00008180 00000001 00000000 c307f138
> Jul 29 19:55:36 ini kernel: [ 3044.823044] <0> c307f138 c307f138 ca228a00 c0593c80 c023b310 cec6ff48 c01fc60d ca228ac0
> Jul 29 19:55:36 ini kernel: [ 3044.823044] <0> cec6ff44 cf328400 00000003 cec6ff58 c01fc6ca ca228a00 c0759d80 cec6ff6c
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c023b310>] ? vfs_quota_off+0x0/0x20
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c01fc60d>] ? generic_shutdown_super+0x4d/0xe0
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c01fc6ca>] ? kill_block_super+0x2a/0x50
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c01fd4e4>] ? deactivate_super+0x64/0x90
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c021282f>] ? mntput_no_expire+0x8f/0xe0
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c0212e47>] ? sys_umount+0x47/0xa0
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c0212ebe>] ? sys_oldumount+0x1e/0x20
> Jul 29 19:55:36 ini kernel: [ 3044.823044]  [<c01033ec>] ? syscall_call+0x7/0xb
> Jul 29 19:55:36 ini kernel: [ 3045.299442] ---[ end trace 426db011a0289db3 ]---
...
> Another test. Everything is as before, only I did not pull the cable, but
> deleted the corresponding LUN on the target, so all the command starting
> from this moment failed. Then on umount system rebooted. Kernel log:

  Nasty. But the log actually contains only traces of processes in D state
(generally waiting for a page to be unlocked). Do you have any sort of
watchdog which might have rebooted the machine?

> Jul 29 20:20:42 ini kernel: [ 1320.251393] umount        D 00478e55     0  1234    924 0x00000000
> Jul 29 20:20:42 ini kernel: [ 1320.251403]  ce579e10 00000086 00000082 00478e55 00000000 c082b330 cef574dc c082b330
> Jul 29 20:20:42 ini kernel: [ 1320.251415]  c082b330 c082b330 cef574dc 0355459b 0000010d c082b330 c082b330 ce652000
> Jul 29 20:20:42 ini kernel: [ 1320.251425]  0000010d cef57230 c1407330 cef57230 ce579e5c ce579e20 c057745a ce579e54
> Jul 29 20:20:42 ini kernel: [ 1320.251436] Call Trace:
> Jul 29 20:20:42 ini kernel: [ 1320.251452]  [<c057745a>] io_schedule+0x3a/0x60
> Jul 29 20:20:42 ini kernel: [ 1320.251463]  [<c01bd95d>] sync_page+0x3d/0x50
> Jul 29 20:20:42 ini kernel: [ 1320.251470]  [<c0577aa7>] __wait_on_bit_lock+0x47/0x90
> Jul 29 20:20:42 ini kernel: [ 1320.251476]  [<c01bd920>] ? sync_page+0x0/0x50
> Jul 29 20:20:42 ini kernel: [ 1320.251483]  [<c01bd8ee>] __lock_page+0x7e/0x90
> Jul 29 20:20:42 ini kernel: [ 1320.251491]  [<c01624d0>] ? wake_bit_function+0x0/0x50
> Jul 29 20:20:42 ini kernel: [ 1320.251499]  [<c01c7219>] truncate_inode_pages_range+0x2a9/0x2c0
> Jul 29 20:20:42 ini kernel: [ 1320.251510]  [<c02916c6>] ? ext4_destroy_inode+0x26/0xa0
> Jul 29 20:20:42 ini kernel: [ 1320.251517]  [<c01c724f>] truncate_inode_pages+0x1f/0x30
> Jul 29 20:20:42 ini kernel: [ 1320.251523]  [<c020f15c>] dispose_list+0xcc/0x100
> Jul 29 20:20:42 ini kernel: [ 1320.251529]  [<c020f534>] invalidate_inodes+0xf4/0x120
> Jul 29 20:20:42 ini kernel: [ 1320.251538]  [<c023b310>] ? vfs_quota_off+0x0/0x20
> Jul 29 20:20:42 ini kernel: [ 1320.251546]  [<c01fc602>] generic_shutdown_super+0x42/0xe0
> Jul 29 20:20:42 ini kernel: [ 1320.251553]  [<c01fc6ca>] kill_block_super+0x2a/0x50
> Jul 29 20:20:42 ini kernel: [ 1320.251559]  [<c01fd4e4>] deactivate_super+0x64/0x90
> Jul 29 20:20:42 ini kernel: [ 1320.251566]  [<c021282f>] mntput_no_expire+0x8f/0xe0
> Jul 29 20:20:42 ini kernel: [ 1320.251573]  [<c0212e47>] sys_umount+0x47/0xa0
> Jul 29 20:20:42 ini kernel: [ 1320.251579]  [<c0212ebe>] sys_oldumount+0x1e/0x20
> Jul 29 20:20:42 ini kernel: [ 1320.251586]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:22:42 ini kernel: [ 1440.285910] umount        D 00478e55     0  1234    924 0x00000004
> Jul 29 20:22:42 ini kernel: [ 1440.285919]  ce579e10 00000086 00000082 00478e55 00000000 c082b330 cef574dc c082b330
> Jul 29 20:22:42 ini kernel: [ 1440.285931]  c082b330 c082b330 cef574dc 0355459b 0000010d c082b330 c082b330 ce652000
> Jul 29 20:22:42 ini kernel: [ 1440.285942]  0000010d cef57230 c1407330 cef57230 ce579e5c ce579e20 c057745a ce579e54
> Jul 29 20:22:42 ini kernel: [ 1440.285953] Call Trace:
> Jul 29 20:22:42 ini kernel: [ 1440.285969]  [<c057745a>] io_schedule+0x3a/0x60
> Jul 29 20:22:42 ini kernel: [ 1440.285980]  [<c01bd95d>] sync_page+0x3d/0x50
> Jul 29 20:22:42 ini kernel: [ 1440.285987]  [<c0577aa7>] __wait_on_bit_lock+0x47/0x90
> Jul 29 20:22:42 ini kernel: [ 1440.285994]  [<c01bd920>] ? sync_page+0x0/0x50
> Jul 29 20:22:42 ini kernel: [ 1440.286001]  [<c01bd8ee>] __lock_page+0x7e/0x90
> Jul 29 20:22:42 ini kernel: [ 1440.286010]  [<c01624d0>] ? wake_bit_function+0x0/0x50
> Jul 29 20:22:42 ini kernel: [ 1440.286018]  [<c01c7219>] truncate_inode_pages_range+0x2a9/0x2c0
> Jul 29 20:22:42 ini kernel: [ 1440.286028]  [<c02916c6>] ? ext4_destroy_inode+0x26/0xa0
> Jul 29 20:22:42 ini kernel: [ 1440.286035]  [<c01c724f>] truncate_inode_pages+0x1f/0x30
> Jul 29 20:22:42 ini kernel: [ 1440.286041]  [<c020f15c>] dispose_list+0xcc/0x100
> Jul 29 20:22:42 ini kernel: [ 1440.286047]  [<c020f534>] invalidate_inodes+0xf4/0x120
> Jul 29 20:22:42 ini kernel: [ 1440.286056]  [<c023b310>] ? vfs_quota_off+0x0/0x20
> Jul 29 20:22:42 ini kernel: [ 1440.286064]  [<c01fc602>] generic_shutdown_super+0x42/0xe0
> Jul 29 20:22:42 ini kernel: [ 1440.286071]  [<c01fc6ca>] kill_block_super+0x2a/0x50
> Jul 29 20:22:42 ini kernel: [ 1440.286077]  [<c01fd4e4>] deactivate_super+0x64/0x90
> Jul 29 20:22:42 ini kernel: [ 1440.286084]  [<c021282f>] mntput_no_expire+0x8f/0xe0
> Jul 29 20:22:42 ini kernel: [ 1440.286091]  [<c0212e47>] sys_umount+0x47/0xa0
> Jul 29 20:22:42 ini kernel: [ 1440.286097]  [<c0212ebe>] sys_oldumount+0x1e/0x20
> Jul 29 20:22:42 ini kernel: [ 1440.286104]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:24:42 ini kernel: [ 1560.321709] umount        D 00478e55     0  1234    924 0x00000004
> Jul 29 20:24:42 ini kernel: [ 1560.321718]  ce579e10 00000086 00000082 00478e55 00000000 c082b330 cef574dc c082b330
> Jul 29 20:24:42 ini kernel: [ 1560.321730]  c082b330 c082b330 cef574dc 0355459b 0000010d c082b330 c082b330 ce652000
> Jul 29 20:24:42 ini kernel: [ 1560.321741]  0000010d cef57230 c1407330 cef57230 ce579e5c ce579e20 c057745a ce579e54
> Jul 29 20:24:42 ini kernel: [ 1560.321751] Call Trace:
> Jul 29 20:24:42 ini kernel: [ 1560.321767]  [<c057745a>] io_schedule+0x3a/0x60
> Jul 29 20:24:42 ini kernel: [ 1560.321777]  [<c01bd95d>] sync_page+0x3d/0x50
> Jul 29 20:24:42 ini kernel: [ 1560.321784]  [<c0577aa7>] __wait_on_bit_lock+0x47/0x90
> Jul 29 20:24:42 ini kernel: [ 1560.321791]  [<c01bd920>] ? sync_page+0x0/0x50
> Jul 29 20:24:42 ini kernel: [ 1560.321797]  [<c01bd8ee>] __lock_page+0x7e/0x90
> Jul 29 20:24:42 ini kernel: [ 1560.321805]  [<c01624d0>] ? wake_bit_function+0x0/0x50
> Jul 29 20:24:42 ini kernel: [ 1560.321814]  [<c01c7219>] truncate_inode_pages_range+0x2a9/0x2c0
> Jul 29 20:24:42 ini kernel: [ 1560.321824]  [<c02916c6>] ? ext4_destroy_inode+0x26/0xa0
> Jul 29 20:24:42 ini kernel: [ 1560.321831]  [<c01c724f>] truncate_inode_pages+0x1f/0x30
> Jul 29 20:24:42 ini kernel: [ 1560.321837]  [<c020f15c>] dispose_list+0xcc/0x100
> Jul 29 20:24:42 ini kernel: [ 1560.321845]  [<c020f534>] invalidate_inodes+0xf4/0x120
> Jul 29 20:24:42 ini kernel: [ 1560.321855]  [<c023b310>] ? vfs_quota_off+0x0/0x20
> Jul 29 20:24:42 ini kernel: [ 1560.321864]  [<c01fc602>] generic_shutdown_super+0x42/0xe0
> Jul 29 20:24:42 ini kernel: [ 1560.321870]  [<c01fc6ca>] kill_block_super+0x2a/0x50
> Jul 29 20:24:42 ini kernel: [ 1560.321877]  [<c01fd4e4>] deactivate_super+0x64/0x90
> Jul 29 20:24:42 ini kernel: [ 1560.321885]  [<c021282f>] mntput_no_expire+0x8f/0xe0
> Jul 29 20:24:42 ini kernel: [ 1560.321892]  [<c0212e47>] sys_umount+0x47/0xa0
> Jul 29 20:24:42 ini kernel: [ 1560.321898]  [<c0212ebe>] sys_oldumount+0x1e/0x20
> Jul 29 20:24:42 ini kernel: [ 1560.321905]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:24:42 ini kernel: [ 1560.358795] sync          D 0004beb0     0  1265   1255 0x00000004
> Jul 29 20:24:42 ini kernel: [ 1560.358803]  cea6ff2c 00000086 00000001 0004beb0 00000000 c082b330 cde3db7c c082b330
> Jul 29 20:24:42 ini kernel: [ 1560.358815]  c082b330 c082b330 cde3db7c 15c42f3f 00000140 c082b330 c082b330 ce653200
> Jul 29 20:24:42 ini kernel: [ 1560.358826]  00000140 cde3d8d0 cea6ff60 cde3d8d0 cefef23c cea6ff58 c0578de5 fffeffff
> Jul 29 20:24:42 ini kernel: [ 1560.358837] Call Trace:
> Jul 29 20:24:42 ini kernel: [ 1560.358845]  [<c0578de5>] rwsem_down_failed_common+0x75/0x1a0
> Jul 29 20:24:42 ini kernel: [ 1560.358852]  [<c0578f5d>] rwsem_down_read_failed+0x1d/0x30
> Jul 29 20:24:42 ini kernel: [ 1560.358858]  [<c0578fb7>] call_rwsem_down_read_failed+0x7/0x10
> Jul 29 20:24:42 ini kernel: [ 1560.358863]  [<c057850c>] ? down_read+0x1c/0x20
> Jul 29 20:24:42 ini kernel: [ 1560.358870]  [<c021cb6d>] sync_filesystems+0xbd/0x110
> Jul 29 20:24:42 ini kernel: [ 1560.358876]  [<c021cc16>] sys_sync+0x16/0x40
> Jul 29 20:24:42 ini kernel: [ 1560.358881]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:26:42 ini kernel: [ 1680.392190] umount        D 00478e55     0  1234    924 0x00000004
> Jul 29 20:26:42 ini kernel: [ 1680.392200]  ce579e10 00000086 00000082 00478e55 00000000 c082b330 cef574dc c082b330
> Jul 29 20:26:42 ini kernel: [ 1680.392212]  c082b330 c082b330 cef574dc 0355459b 0000010d c082b330 c082b330 ce652000
> Jul 29 20:26:42 ini kernel: [ 1680.392223]  0000010d cef57230 c1407330 cef57230 ce579e5c ce579e20 c057745a ce579e54
> Jul 29 20:26:42 ini kernel: [ 1680.392233] Call Trace:
> Jul 29 20:26:42 ini kernel: [ 1680.392250]  [<c057745a>] io_schedule+0x3a/0x60
> Jul 29 20:26:42 ini kernel: [ 1680.392260]  [<c01bd95d>] sync_page+0x3d/0x50
> Jul 29 20:26:42 ini kernel: [ 1680.392267]  [<c0577aa7>] __wait_on_bit_lock+0x47/0x90
> Jul 29 20:26:42 ini kernel: [ 1680.392274]  [<c01bd920>] ? sync_page+0x0/0x50
> Jul 29 20:26:42 ini kernel: [ 1680.392280]  [<c01bd8ee>] __lock_page+0x7e/0x90
> Jul 29 20:26:42 ini kernel: [ 1680.392289]  [<c01624d0>] ? wake_bit_function+0x0/0x50
> Jul 29 20:26:42 ini kernel: [ 1680.392298]  [<c01c7219>] truncate_inode_pages_range+0x2a9/0x2c0
> Jul 29 20:26:42 ini kernel: [ 1680.392308]  [<c02916c6>] ? ext4_destroy_inode+0x26/0xa0
> Jul 29 20:26:42 ini kernel: [ 1680.392314]  [<c01c724f>] truncate_inode_pages+0x1f/0x30
> Jul 29 20:26:42 ini kernel: [ 1680.392321]  [<c020f15c>] dispose_list+0xcc/0x100
> Jul 29 20:26:42 ini kernel: [ 1680.392327]  [<c020f534>] invalidate_inodes+0xf4/0x120
> Jul 29 20:26:42 ini kernel: [ 1680.392336]  [<c023b310>] ? vfs_quota_off+0x0/0x20
> Jul 29 20:26:42 ini kernel: [ 1680.392344]  [<c01fc602>] generic_shutdown_super+0x42/0xe0
> Jul 29 20:26:42 ini kernel: [ 1680.392351]  [<c01fc6ca>] kill_block_super+0x2a/0x50
> Jul 29 20:26:42 ini kernel: [ 1680.392357]  [<c01fd4e4>] deactivate_super+0x64/0x90
> Jul 29 20:26:42 ini kernel: [ 1680.392364]  [<c021282f>] mntput_no_expire+0x8f/0xe0
> Jul 29 20:26:42 ini kernel: [ 1680.392371]  [<c0212e47>] sys_umount+0x47/0xa0
> Jul 29 20:26:42 ini kernel: [ 1680.392378]  [<c0212ebe>] sys_oldumount+0x1e/0x20
> Jul 29 20:26:42 ini kernel: [ 1680.392384]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:26:42 ini kernel: [ 1680.427874] sync          D 0004beb0     0  1265   1255 0x00000004
> Jul 29 20:26:42 ini kernel: [ 1680.427883]  cea6ff2c 00000086 00000001 0004beb0 00000000 c082b330 cde3db7c c082b330
> Jul 29 20:26:42 ini kernel: [ 1680.427894]  c082b330 c082b330 cde3db7c 15c42f3f 00000140 c082b330 c082b330 ce653200
> Jul 29 20:26:42 ini kernel: [ 1680.427904]  00000140 cde3d8d0 cea6ff60 cde3d8d0 cefef23c cea6ff58 c0578de5 fffeffff
> Jul 29 20:26:42 ini kernel: [ 1680.427915] Call Trace:
> Jul 29 20:26:42 ini kernel: [ 1680.427922]  [<c0578de5>] rwsem_down_failed_common+0x75/0x1a0
> Jul 29 20:26:42 ini kernel: [ 1680.427929]  [<c0578f5d>] rwsem_down_read_failed+0x1d/0x30
> Jul 29 20:26:42 ini kernel: [ 1680.427935]  [<c0578fb7>] call_rwsem_down_read_failed+0x7/0x10
> Jul 29 20:26:42 ini kernel: [ 1680.427940]  [<c057850c>] ? down_read+0x1c/0x20
> Jul 29 20:26:42 ini kernel: [ 1680.427947]  [<c021cb6d>] sync_filesystems+0xbd/0x110
> Jul 29 20:26:42 ini kernel: [ 1680.427953]  [<c021cc16>] sys_sync+0x16/0x40
> Jul 29 20:26:42 ini kernel: [ 1680.427958]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:28:42 ini kernel: [ 1800.458856] umount        D 00478e55     0  1234    924 0x00000004
> Jul 29 20:28:42 ini kernel: [ 1800.458866]  ce579e10 00000086 00000082 00478e55 00000000 c082b330 cef574dc c082b330
> Jul 29 20:28:42 ini kernel: [ 1800.458877]  c082b330 c082b330 cef574dc 0355459b 0000010d c082b330 c082b330 ce652000
> Jul 29 20:28:42 ini kernel: [ 1800.458888]  0000010d cef57230 c1407330 cef57230 ce579e5c ce579e20 c057745a ce579e54
> Jul 29 20:28:42 ini kernel: [ 1800.458899] Call Trace:
> Jul 29 20:28:42 ini kernel: [ 1800.458915]  [<c057745a>] io_schedule+0x3a/0x60
> Jul 29 20:28:42 ini kernel: [ 1800.458925]  [<c01bd95d>] sync_page+0x3d/0x50
> Jul 29 20:28:42 ini kernel: [ 1800.458932]  [<c0577aa7>] __wait_on_bit_lock+0x47/0x90
> Jul 29 20:28:42 ini kernel: [ 1800.458938]  [<c01bd920>] ? sync_page+0x0/0x50
> Jul 29 20:28:42 ini kernel: [ 1800.458945]  [<c01bd8ee>] __lock_page+0x7e/0x90
> Jul 29 20:28:42 ini kernel: [ 1800.458953]  [<c01624d0>] ? wake_bit_function+0x0/0x50
> Jul 29 20:28:42 ini kernel: [ 1800.458961]  [<c01c7219>] truncate_inode_pages_range+0x2a9/0x2c0
> Jul 29 20:28:42 ini kernel: [ 1800.458971]  [<c02916c6>] ? ext4_destroy_inode+0x26/0xa0
> Jul 29 20:28:42 ini kernel: [ 1800.458978]  [<c01c724f>] truncate_inode_pages+0x1f/0x30
> Jul 29 20:28:42 ini kernel: [ 1800.458984]  [<c020f15c>] dispose_list+0xcc/0x100
> Jul 29 20:28:42 ini kernel: [ 1800.458991]  [<c020f534>] invalidate_inodes+0xf4/0x120
> Jul 29 20:28:42 ini kernel: [ 1800.458999]  [<c023b310>] ? vfs_quota_off+0x0/0x20
> Jul 29 20:28:42 ini kernel: [ 1800.459007]  [<c01fc602>] generic_shutdown_super+0x42/0xe0
> Jul 29 20:28:42 ini kernel: [ 1800.459013]  [<c01fc6ca>] kill_block_super+0x2a/0x50
> Jul 29 20:28:42 ini kernel: [ 1800.459020]  [<c01fd4e4>] deactivate_super+0x64/0x90
> Jul 29 20:28:42 ini kernel: [ 1800.459027]  [<c021282f>] mntput_no_expire+0x8f/0xe0
> Jul 29 20:28:42 ini kernel: [ 1800.459033]  [<c0212e47>] sys_umount+0x47/0xa0
> Jul 29 20:28:42 ini kernel: [ 1800.459039]  [<c0212ebe>] sys_oldumount+0x1e/0x20
> Jul 29 20:28:42 ini kernel: [ 1800.459046]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:28:42 ini kernel: [ 1800.493768] sync          D 0004beb0     0  1265   1255 0x00000004
> Jul 29 20:28:42 ini kernel: [ 1800.493777]  cea6ff2c 00000086 00000001 0004beb0 00000000 c082b330 cde3db7c c082b330
> Jul 29 20:28:42 ini kernel: [ 1800.493788]  c082b330 c082b330 cde3db7c 15c42f3f 00000140 c082b330 c082b330 ce653200
> Jul 29 20:28:42 ini kernel: [ 1800.493798]  00000140 cde3d8d0 cea6ff60 cde3d8d0 cefef23c cea6ff58 c0578de5 fffeffff
> Jul 29 20:28:42 ini kernel: [ 1800.493809] Call Trace:
> Jul 29 20:28:42 ini kernel: [ 1800.493816]  [<c0578de5>] rwsem_down_failed_common+0x75/0x1a0
> Jul 29 20:28:42 ini kernel: [ 1800.493823]  [<c0578f5d>] rwsem_down_read_failed+0x1d/0x30
> Jul 29 20:28:42 ini kernel: [ 1800.493828]  [<c0578fb7>] call_rwsem_down_read_failed+0x7/0x10
> Jul 29 20:28:42 ini kernel: [ 1800.493834]  [<c057850c>] ? down_read+0x1c/0x20
> Jul 29 20:28:42 ini kernel: [ 1800.493841]  [<c021cb6d>] sync_filesystems+0xbd/0x110
> Jul 29 20:28:42 ini kernel: [ 1800.493847]  [<c021cc16>] sys_sync+0x16/0x40
> Jul 29 20:28:42 ini kernel: [ 1800.493853]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:30:42 ini kernel: [ 1920.526729] umount        D 00478e55     0  1234    924 0x00000004
> Jul 29 20:30:42 ini kernel: [ 1920.526739]  ce579e10 00000086 00000082 00478e55 00000000 c082b330 cef574dc c082b330
> Jul 29 20:30:42 ini kernel: [ 1920.526750]  c082b330 c082b330 cef574dc 0355459b 0000010d c082b330 c082b330 ce652000
> Jul 29 20:30:42 ini kernel: [ 1920.526761]  0000010d cef57230 c1407330 cef57230 ce579e5c ce579e20 c057745a ce579e54
> Jul 29 20:30:42 ini kernel: [ 1920.526772] Call Trace:
> Jul 29 20:30:42 ini kernel: [ 1920.526788]  [<c057745a>] io_schedule+0x3a/0x60
> Jul 29 20:30:42 ini kernel: [ 1920.526798]  [<c01bd95d>] sync_page+0x3d/0x50
> Jul 29 20:30:42 ini kernel: [ 1920.526805]  [<c0577aa7>] __wait_on_bit_lock+0x47/0x90
> Jul 29 20:30:42 ini kernel: [ 1920.526813]  [<c01bd920>] ? sync_page+0x0/0x50
> Jul 29 20:30:42 ini kernel: [ 1920.526819]  [<c01bd8ee>] __lock_page+0x7e/0x90
> Jul 29 20:30:42 ini kernel: [ 1920.526827]  [<c01624d0>] ? wake_bit_function+0x0/0x50
> Jul 29 20:30:42 ini kernel: [ 1920.526836]  [<c01c7219>] truncate_inode_pages_range+0x2a9/0x2c0
> Jul 29 20:30:42 ini kernel: [ 1920.526845]  [<c02916c6>] ? ext4_destroy_inode+0x26/0xa0
> Jul 29 20:30:42 ini kernel: [ 1920.526853]  [<c01c724f>] truncate_inode_pages+0x1f/0x30
> Jul 29 20:30:42 ini kernel: [ 1920.526859]  [<c020f15c>] dispose_list+0xcc/0x100
> Jul 29 20:30:42 ini kernel: [ 1920.526866]  [<c020f534>] invalidate_inodes+0xf4/0x120
> Jul 29 20:30:42 ini kernel: [ 1920.526874]  [<c023b310>] ? vfs_quota_off+0x0/0x20
> Jul 29 20:30:42 ini kernel: [ 1920.526882]  [<c01fc602>] generic_shutdown_super+0x42/0xe0
> Jul 29 20:30:42 ini kernel: [ 1920.526889]  [<c01fc6ca>] kill_block_super+0x2a/0x50
> Jul 29 20:30:42 ini kernel: [ 1920.526895]  [<c01fd4e4>] deactivate_super+0x64/0x90
> Jul 29 20:30:42 ini kernel: [ 1920.526902]  [<c021282f>] mntput_no_expire+0x8f/0xe0
> Jul 29 20:30:42 ini kernel: [ 1920.526908]  [<c0212e47>] sys_umount+0x47/0xa0
> Jul 29 20:30:42 ini kernel: [ 1920.526915]  [<c0212ebe>] sys_oldumount+0x1e/0x20
> Jul 29 20:30:42 ini kernel: [ 1920.526922]  [<c01033ec>] syscall_call+0x7/0xb
> Jul 29 20:30:42 ini kernel: [ 1920.563739] sync          D 0004beb0     0  1265   1255 0x00000004
> Jul 29 20:30:42 ini kernel: [ 1920.563747]  cea6ff2c 00000086 00000001 0004beb0 00000000 c082b330 cde3db7c c082b330
> Jul 29 20:30:42 ini kernel: [ 1920.563758]  c082b330 c082b330 cde3db7c 15c42f3f 00000140 c082b330 c082b330 ce653200
> Jul 29 20:30:42 ini kernel: [ 1920.563768]  00000140 cde3d8d0 cea6ff60 cde3d8d0 cefef23c cea6ff58 c0578de5 fffeffff
> Jul 29 20:30:42 ini kernel: [ 1920.563779] Call Trace:
> Jul 29 20:30:42 ini kernel: [ 1920.563787]  [<c0578de5>] rwsem_down_failed_common+0x75/0x1a0
> Jul 29 20:30:42 ini kernel: [ 1920.563793]  [<c0578f5d>] rwsem_down_read_failed+0x1d/0x30
> Jul 29 20:30:42 ini kernel: [ 1920.563799]  [<c0578fb7>] call_rwsem_down_read_failed+0x7/0x10
> Jul 29 20:30:42 ini kernel: [ 1920.563804]  [<c057850c>] ? down_read+0x1c/0x20
> Jul 29 20:30:42 ini kernel: [ 1920.563812]  [<c021cb6d>] sync_filesystems+0xbd/0x110
> Jul 29 20:30:42 ini kernel: [ 1920.563817]  [<c021cc16>] sys_sync+0x16/0x40
> Jul 29 20:30:42 ini kernel: [ 1920.563823]  [<c01033ec>] syscall_call+0x7/0xb
> 
> Although in both cases the FS remained consistent:
  Yes, at least something positive in the end ;).

> root@ini:~# mount -t ext4 /dev/sdb /mnt
> root@ini:~# umount /mnt
> root@ini:~# e2fsck -f -y /dev/sdb
> e2fsck 1.41.11 (14-Mar-2010)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> 
> /dev/sdb: ***** FILE SYSTEM WAS MODIFIED *****
> /dev/sdb: 4194/640000 files (74.2% non-contiguous), 334774/1280000 blocks
> 
> You can find full kernel logs starting from iSCSI load in the attachments. 
> 
> I already reported such issues some time ago, but my reports were not too much welcomed, so I gave up. Anyway, anybody can easily do my tests at any time. They don't need any special hardware, just 2 Linux boxes: one for iSCSI target and one for iSCSI initiator (the test box itself). But they are generic for other transports as well. You can see there's nothing iSCSI specific in the traces.
  Thanks for running the test.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
