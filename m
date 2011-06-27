From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 38312] New: Oops in kmem_cache_alloc
Date: Mon, 27 Jun 2011 15:41:40 -0500
Message-ID: <1309207300.2605.4.camel@mulgrave>
References: <bug-38312-10286@https.bugzilla.kernel.org/>
	 <20110627133007.f6cba848.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48924 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab1F0Ulm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2011 16:41:42 -0400
In-Reply-To: <20110627133007.f6cba848.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, sgunderson@bigfoot.com

On Mon, 2011-06-27 at 13:30 -0700, Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Sun, 26 Jun 2011 21:48:27 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=38312
> > 
> >            Summary: Oops in kmem_cache_alloc
> >            Product: Memory Management
> >            Version: 2.5
> >     Kernel Version: 3.0.0-rc4
> >           Platform: All
> >         OS/Version: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: high
> >           Priority: P1
> >          Component: Other
> >         AssignedTo: akpm@linux-foundation.org
> >         ReportedBy: sgunderson@bigfoot.com
> >         Regression: Yes
> > 
> > 
> > Hi,
> > 
> > 3.0.0-rc4 oopsed on me under an hour after boot. This didn't happen with -rc2,
> > nor 2.6.39 or any of the previous kernels I've been running (the machine is a
> > few years old). There were two oopses, with entirely different backtraces, so I
> > take it this is some MM bug. The oopses are
> > 
> > [ 2370.071691] general protection fault: 0000 [#1] SMP 
> > [ 2370.076925] CPU 8 
> > [ 2370.078770] Modules linked in: sha256_generic cryptd aes_x86_64 aes_generic
> > af_packet microcode ext4 jbd2 crc16 ext2 fuse dm_crypt coretemp w83627ehf
> > hwmon_vid ip_gre gre ide_generic ide_gd_mod ide_cd_mod cdrom forcedeth psmouse
> > ghes serio_raw evdev pcspkr i2c_i801 i2c_core hed rtc_cmos ext3 jbd mbcache
> > dm_mod raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq
> > async_tx raid1 md_mod usbhid ide_pci_generic ide_core uhci_hcd ata_piix e1000e
> > ehci_hcd sd_mod unix [last unloaded: scsi_wait_scan]
> > [ 2370.126789] 
> > [ 2370.128495] Pid: 24783, comm: apache2 Not tainted 3.0.0-rc4 #1 Supermicro
> > X8DTL/X8DTL
> > [ 2370.136782] RIP: 0010:[<ffffffff810d14db>]  [<ffffffff810d14db>]
> > kmem_cache_alloc+0x4f/0xd7
> > [ 2370.145554] RSP: 0018:ffff8805ecc9b6d8  EFLAGS: 00010086
> > [ 2370.151067] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> > 0000000000052ffa
> > [ 2370.158394] RDX: 0000000000052ff9 RSI: 0000000000008020 RDI:
> > ffffffff812071fa
> > [ 2370.165728] RBP: ffff8805ecc9b718 R08: 0000000000000002 R09:
> > ffff8806249cb8d0
> > [ 2370.173053] R10: ffff880500000000 R11: ffff880624b86000 R12:
> > 8000000000020021
> > [ 2370.180389] R13: ffff8806270026c0 R14: 0000000000008020 R15:
> > ffff880624841400
> > [ 2370.187718] FS:  00007f0c9207a740(0000) GS:ffff88063fb00000(0000)
> > knlGS:0000000000000000
> > [ 2370.196202] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [ 2370.202141] CR2: 00007f3125719000 CR3: 00000005be1dd000 CR4:
> > 00000000000006e0
> > [ 2370.209474] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > 0000000000000000
> > [ 2370.216802] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > 0000000000000400
> > [ 2370.224130] Process apache2 (pid: 24783, threadinfo ffff8805ecc9a000, task
> > ffff880623192ce0)
> > [ 2370.232973] Stack:
> > [ 2370.235191]  ffff8805ecc9b718 0000000000000080 ffff8805ecc9b738
> > 0000000000000000
> > [ 2370.243070]  ffffffff8158d230 0000000000000020 ffff8806249cbbd8
> > ffff880624841400
> > [ 2370.250949]  ffff8805ecc9b748 ffffffff812071fa ffff8805ecc9b798
> > 0000000000000000
> > [ 2370.258818] Call Trace:
> > [ 2370.261470]  [<ffffffff812071fa>] scsi_pool_alloc_command+0x27/0x67
> > [ 2370.267936]  [<ffffffff8120727b>] scsi_host_alloc_command+0x1c/0x67
> > [ 2370.274400]  [<ffffffff81207378>] __scsi_get_command+0x15/0x90
> > [ 2370.280431]  [<ffffffff8120742a>] scsi_get_command+0x37/0xa5
> > [ 2370.286285]  [<ffffffff8120ce5d>] scsi_setup_fs_cmnd+0x6b/0xbf
> > [ 2370.292321]  [<ffffffffa000ebdd>] sd_prep_fn+0x2cb/0xb7a [sd_mod]
> > [ 2370.298612]  [<ffffffff811770c5>] ? deadline_remove_request+0x82/0x89
> > [ 2370.305248]  [<ffffffff8116d4e9>] blk_peek_request+0xe8/0x1d2
> > [ 2370.311191]  [<ffffffff8120c4ec>] scsi_request_fn+0x86/0x49e
> > [ 2370.317046]  [<ffffffff81168fdd>] __blk_run_queue+0x16/0x18
> > [ 2370.322817]  [<ffffffff8116e66d>] queue_unplugged+0x74/0x8a
> > [ 2370.328590]  [<ffffffff8116e7c6>] blk_flush_plug_list+0x143/0x1a8
> > [ 2370.334880]  [<ffffffff8116e83e>] blk_finish_plug+0x13/0x35
> > [ 2370.340653]  [<ffffffff810a63c9>] __do_page_cache_readahead+0x1c0/0x1e3
> > 
> > [ 2370.347460]  [<ffffffff810a6408>] ra_submit+0x1c/0x20
> > [ 2370.352711]  [<ffffffff810a6668>] ondemand_readahead+0x189/0x19c
> > [ 2370.358915]  [<ffffffff810a66ef>] page_cache_async_readahead+0x74/0x7d
> > [ 2370.365642]  [<ffffffff810f9fe8>] __generic_file_splice_read+0x246/0x42f
> > [ 2370.372532]  [<ffffffff810f8172>] ? splice_from_pipe_begin+0x12/0x12
> > [ 2370.379090]  [<ffffffff812cc7fe>] ? inet_sendpage+0xa0/0xb5
> > [ 2370.384860]  [<ffffffff813420ce>] ? apic_timer_interrupt+0xe/0x20
> > [ 2370.391147]  [<ffffffff81269f11>] ? kernel_sendpage+0x48/0x59
> > [ 2370.397090]  [<ffffffff81269f58>] ? sock_sendpage+0x36/0x3a
> > [ 2370.402861]  [<ffffffff810f8eb2>] ? page_cache_pipe_buf_release+0x14/0x1c
> > [ 2370.409847]  [<ffffffff810f8eba>] ? page_cache_pipe_buf_release+0x1c/0x1c
> > [ 2370.416829]  [<ffffffff810fa218>] generic_file_splice_read+0x47/0x73
> > [ 2370.423377]  [<ffffffff810f892f>] do_splice_to+0x6f/0x7c
> > [ 2370.428886]  [<ffffffff810f8f8c>] splice_direct_to_actor+0xbe/0x189
> > [ 2370.435352]  [<ffffffff810f88a3>] ? do_splice_from+0x81/0x81
> > [ 2370.441210]  [<ffffffff81339620>] ? schedule+0x934/0x9c5
> > [ 2370.446723]  [<ffffffff810f909e>] do_splice_direct+0x47/0x5a
> > [ 2370.452577]  [<ffffffff810d89d4>] do_sendfile+0x12f/0x1b9
> > [ 2370.458171]  [<ffffffff810d8aab>] sys_sendfile64+0x4d/0x88
> > [ 2370.463852]  [<ffffffff813417bb>] system_call_fastpath+0x16/0x1b
> > [ 2370.470053] Code: 60 c4 00 00 48 8b 51 08 4c 8b 21 4d 85 e4 75 13 48 89 fa
> > 44 89 f6 4c 89 ef e8 70 fd ff ff 49 89 c4 eb 1f 49 63 45 20 48 8d 4a 01 
> > [ 2370.484262]  8b 1c 04 49 8b 75 00 4c 89 e0 65 48 0f c7 0e 0f 94 c0 84 c0 
> > [ 2370.492127] RIP  [<ffffffff810d14db>] kmem_cache_alloc+0x4f/0xd7
> > [ 2370.498355]  RSP <ffff8805ecc9b6d8>
> 
> Could be that scsi passed a junk address into kmem_cache_alloc(). 
> There have been some recent fixes in that area, but I *think* they were
> present in 3.0-rc4.  James, do you recall?

Possibly ... if it's a refcounting bug on the host structure (which
would cause shost->pool to have bogus data).  However, in that case,
there should be some reference to freeing the host in the logs above the
oops (or some event that triggered it).   For just a running system, we
don't ever free the host structure until all the devices are gone.

You're right, all the refcounting fixes I know are in -rc4.

James


