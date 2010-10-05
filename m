From: "Nicholas A. Bellinger" <nab@kernel.org>
Subject: Re: [Bug 19642] 2.6.36-rc6 BUG at drivers/scsi/scsi_lib.c:1113
Date: Mon, 04 Oct 2010 17:18:39 -0700
Message-ID: <1286237919.18417.311.camel@haakon2.linux-iscsi.org>
References: <20101005000309.8466.qmail@science.horizon.com>
	 <1286237419.18417.306.camel@haakon2.linux-iscsi.org>
Reply-To: nab@kernel.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:27986 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752703Ab0JEA3j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2010 20:29:39 -0400
In-Reply-To: <1286237419.18417.306.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: bugzilla-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, George Spelvin <linux@horizon.com>

Hi Neil,

Do you know if any of the recent changes into drivers/md/ code could
starting causing zero-length bio READ to be generated to MD RAID1
backstores along the lines of what George is currently seeing w/ 10x
RAID1 arrays during assembly..?

Thanks,

--nab


On Mon, 2010-10-04 at 17:10 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2010-10-04 at 20:03 -0400, George Spelvin wrote:
> > > Would you mind enabling CONFIG_SCSI_LOGGING=y in your kernel build and calling 
> > > 
> > > echo 0xffffffff > /proc/sys/dev/scsi/logging_level
> > > 
> > > so we can double check to see which CDBs are actually generating the issue..?
> > > 
> > > Thanks!
> > 
> > Here's a syslog starting at boot time for that (I also added verbose
> > SCSI errors, FWIW.)  I did
> > echo 0xffffffff > /proc/sys/dev/scsi/logging_level; echo check > /sys/block/md6/md/sync_action
> > to minimize time delay and resultany unrelated log spam.
> > 
> > Note that md6 is mirrored across *every* drive on the machine.  (It's the
> > emergency recovery /boot partition.)
> 
> <SNIP>
> 
> > 23:56:29: md: data-check of RAID array md6
> > 23:56:29: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> > 23:56:29: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> > 23:56:29: md: using 128k window, over a total of 1166912 blocks.
> > 23:56:29: sd 0:0:0:0: [sda] sd_init_command: block=0, count=0
> > 23:56:29: sd 0:0:0:0: [sda] block=0
> > 23:56:29: sd 0:0:0:0: [sda] reading 0/0 512 byte blocks.
> > 23:56:29: sd 0:0:0:0: [sda] Send: 0xffff88021984ed00 
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: buffer = 0xffff88021984ee00, bufflen = 0, queuecommand 0xffffffff812be49d
> > 23:56:29: ata1.00: WARNING: zero len r/w req
> > 23:56:29: sd 0:0:0:0: [sda] Done: 0xffff88021984ed00 RETRY
> > 23:56:29: sd 0:0:0:0: [sda]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: sd 0:0:0:0: [sda] scsi host busy 1 failed 0
> > 23:56:29: Inserting command ffff88021984ed00 into mlqueue
> > 23:56:29: sd 0:0:0:0: [sda] Send: 0xffff88021984ed00 
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: buffer = 0xffff88021984ee00, bufflen = 0, queuecommand 0xffffffff812be49d
> > 23:56:29: ata1.00: WARNING: zero len r/w req
> > 23:56:29: leaving scsi_dispatch_cmnd()
> > 23:56:29: sd 0:0:0:0: [sda] Done: 0xffff88021984ed00 RETRY
> > 23:56:29: sd 0:0:0:0: [sda]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: sd 0:0:0:0: [sda] scsi host busy 1 failed 0
> > 23:56:29: Inserting command ffff88021984ed00 into mlqueue
> > 23:56:29: sd 0:0:0:0: [sda] Send: 0xffff88021984ed00 
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: buffer = 0xffff88021984ee00, bufflen = 0, queuecommand 0xffffffff812be49d
> > 23:56:29: ata1.00: WARNING: zero len r/w req
> > 23:56:29: leaving scsi_dispatch_cmnd()
> > 23:56:29: sd 0:0:0:0: [sda] Done: 0xffff88021984ed00 RETRY
> > 23:56:29: sd 0:0:0:0: [sda]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: sd 0:0:0:0: [sda] scsi host busy 1 failed 0
> > 23:56:29: Inserting command ffff88021984ed00 into mlqueue
> > 23:56:29: sd 0:0:0:0: [sda] Send: 0xffff88021984ed00 
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: buffer = 0xffff88021984ee00, bufflen = 0, queuecommand 0xffffffff812be49d
> > 23:56:29: ata1.00: WARNING: zero len r/w req
> > 23:56:29: leaving scsi_dispatch_cmnd()
> > 23:56:29: sd 0:0:0:0: [sda] Done: 0xffff88021984ed00 RETRY
> > 23:56:29: sd 0:0:0:0: [sda]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: sd 0:0:0:0: [sda] scsi host busy 1 failed 0
> > 23:56:29: Inserting command ffff88021984ed00 into mlqueue
> > 23:56:29: sd 0:0:0:0: [sda] Send: 0xffff88021984ed00 
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: buffer = 0xffff88021984ee00, bufflen = 0, queuecommand 0xffffffff812be49d
> > 23:56:29: ata1.00: WARNING: zero len r/w req
> > 23:56:29: leaving scsi_dispatch_cmnd()
> > 23:56:29: sd 0:0:0:0: [sda] Done: 0xffff88021984ed00 RETRY
> > 23:56:29: sd 0:0:0:0: [sda]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: sd 0:0:0:0: [sda] scsi host busy 1 failed 0
> > 23:56:29: Inserting command ffff88021984ed00 into mlqueue
> > 23:56:29: sd 0:0:0:0: [sda] Send: 0xffff88021984ed00 
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: buffer = 0xffff88021984ee00, bufflen = 0, queuecommand 0xffffffff812be49d
> > 23:56:29: ata1.00: WARNING: zero len r/w req
> > 23:56:29: leaving scsi_dispatch_cmnd()
> > 23:56:29: sd 0:0:0:0: [sda] Done: 0xffff88021984ed00 SUCCESS
> > 23:56:29: sd 0:0:0:0: [sda]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
> > 23:56:29: sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 00 00
> > 23:56:29: sd 0:0:0:0: [sda] scsi host busy 1 failed 0
> > 23:56:29: sd 0:0:0:0: Notifying upper driver of completion (result 70000)
> > 23:56:29: sd 0:0:0:0: [sda]  Result: hostbyte=DID_ERROR driverbyte=DRIVER_OK
> > 23:56:29: 0 sectors total, 0 bytes done.
> > 23:56:29: leaving scsi_dispatch_cmnd()
> 
> Ok, it looks like my initial guess about FUA / BARRIER breakage was
> completely wrong here.  So the issue is in fact being caused by a
> READ_10 with a transfer length of zero generated somewhere else UPL MD
> code (perhaps something to do with MD metadata..?)
> 
> Would you be able to 'git bisect' on your system with Linus'es
> linux-2.6.git tree from commit 9fe6206f400646a (v2.6.35) to HEAD at
> v2.6.36-rc6 to help us pinpoint which commit the breakage was
> introduced..?
> 
> Thanks!
> 
> --nab
> 
> 
> > 23:56:29: ------------[ cut here ]------------
> > 23:56:29: kernel BUG at drivers/scsi/scsi_lib.c:1113!
> > 23:56:29: invalid opcode: 0000 [#1] SMP 
> > 23:56:29: last sysfs file: /sys/devices/virtual/block/md6/md/sync_action
> > 23:56:29: CPU 3 
> > 23:56:29: Modules linked in: ctr twofish_generic twofish_x86_64 twofish_common serpent xcbc sha512_generic sha256_generic crypto_null ipg 8250_pci 8250_pnp 8250 serial_core
> > 23:56:29: 
> > 23:56:29: Pid: 5446, comm: md6_resync Not tainted 2.6.36-rc6-00070-g44c064a #3 MS-7376/MS-7376
> > 23:56:29: RIP: 0010:[<ffffffff812ac592>]  [<ffffffff812ac592>] scsi_setup_fs_cmnd+0x4e/0xbb
> > 23:56:29: RSP: 0018:ffff88021af05ab0  EFLAGS: 00010046
> > 23:56:29: RAX: 0000000000000000 RBX: ffff88021f39cb88 RCX: ffff88021f2ee960
> > 23:56:29: RDX: 0000000000000000 RSI: ffff88021f39cb88 RDI: ffff88021f65bc00
> > 23:56:29: RBP: ffff88021af05ac0 R08: 00000000000003e8 R09: ffff88021f677848
> > 23:56:29: R10: 0000000000000000 R11: ffff88021f677848 R12: ffff88021f65bc00
> > 23:56:29: R13: 0000000000000000 R14: ffff88021f65bc48 R15: ffff88021f2f7000
> > 23:56:29: FS:  00007f096e6a27c0(0000) GS:ffff880028380000(0000) knlGS:0000000000000000
> > 23:56:29: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > 23:56:29: CR2: 0000003a10c1e8f0 CR3: 000000021c612000 CR4: 00000000000006e0
> > 23:56:29: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > 23:56:29: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > 23:56:29: Process md6_resync (pid: 5446, threadinfo ffff88021af04000, task ffff88021988ac00)
> > 23:56:29: Stack:
> > 23:56:29:  0000000000000000 ffff88021f39cb88 ffff88021af05b40 ffffffff812b2af8
> > 23:56:29: <0> ffff88021af05b40 ffffffff8116b8e5 0000000000000200 0000000000000000
> > 23:56:29: <0> ffff88021f511868 ffff88021f2ee960 ffff88021f511958 ffff88021f65bc00
> > 23:56:29: Call Trace:
> > 23:56:29:  [<ffffffff812b2af8>] sd_prep_fn+0x252/0xb00
> > 23:56:29:  [<ffffffff8116b8e5>] ? cfq_dispatch_requests+0x6c3/0x7ec
> > 23:56:29:  [<ffffffff81160487>] blk_peek_request+0xb3/0x177
> > 23:56:29:  [<ffffffff812abc42>] scsi_request_fn+0x8b/0x4cb
> > 23:56:29:  [<ffffffff81160d9c>] __generic_unplug_device+0x32/0x37
> > 23:56:29:  [<ffffffff81160dcc>] generic_unplug_device+0x2b/0x3a
> > 23:56:29:  [<ffffffff8115f0de>] blk_unplug+0x12/0x14
> > 23:56:29:  [<ffffffff81308275>] unplug_slaves+0x69/0x9f
> > 23:56:29:  [<ffffffff813082c3>] raid1_unplug+0x18/0x28
> > 23:56:29:  [<ffffffff8115f0de>] blk_unplug+0x12/0x14
> > 23:56:29:  [<ffffffff8131c1b6>] md_unplug+0x1d/0x33
> > 23:56:29:  [<ffffffff8131cb18>] md_do_sync+0x94c/0xba6
> > 23:56:29:  [<ffffffff8102f88f>] ? finish_task_switch+0x34/0x74
> > 23:56:29:  [<ffffffff8131d17e>] md_thread+0xf6/0x114
> > 23:56:29:  [<ffffffff8131d088>] ? md_thread+0x0/0x114
> > 23:56:29:  [<ffffffff8131d088>] ? md_thread+0x0/0x114
> > 23:56:29:  [<ffffffff81049e4f>] kthread+0x7d/0x85
> > 23:56:29:  [<ffffffff81002c94>] kernel_thread_helper+0x4/0x10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

