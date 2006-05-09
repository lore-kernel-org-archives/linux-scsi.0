From: todorovic.s@googlemail.com
Subject: Re: oops and lockups with aic79xx 2.6.15+
Date: Tue, 9 May 2006 20:46:21 +0100 (BST)
Message-ID: <Pine.LNX.4.63.0605092043430.4131@thor.lan>
References: <446009AC.9030406@comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:20456 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1750773AbWEITlm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 May 2006 15:41:42 -0400
Received: by nf-out-0910.google.com with SMTP id b2so1263334nfe
        for <linux-scsi@vger.kernel.org>; Tue, 09 May 2006 12:41:40 -0700 (PDT)
In-Reply-To: <446009AC.9030406@comcast.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle Davenport <kdavenpo@comcast.net>
Cc: linux-scsi@vger.kernel.org


Please accept my apologies if I get some of this wrong - I'm still
a kernelnewbie.

On Mon, 8 May 2006, Kyle Davenport wrote:

> I didn't notice any problems with my Toshiba scsi DVD-ROM SD-M1401 until
> upgrading to 2.6.15.1 from 2.6.13.4.  (this system, a Tyan Thunder K7X-Pro
> (S2469UNG) dual 2400mp, has been stable since 2.4.18).    Now, most cd/dvd's I
> try cause a long listing of scsi errors in syslog.   It could be that the
> drive is going bad, but the system no longer gracefully recovers from scsi
> errors.   The other scsi drive, a YAMAHA  CRW2100S cd-rw does not generate any
> read errors on all the cd's I have tried.   Both 2.6.15.1 and 2.6.16.12 are
> causing system lockups.   I have rebooted back into 2.6.13.4 and my system
> behaves normally, ie, CD read errors are simply reported to the shell, and
> processing continues.

Do you get lockups with 2.6.14? There's been some changes to the scsi code
around this time such as using scsi_execute_req() and scsi_execute().
It's possible something broke when the new API was introduced - I've
got a lockup with kernels 2.6.14 and above (though I don't know the
exact cause).


-snip-


> Here is the oops from 2.6.16.12:
> quickest kernel: Oops: 0000 [#1]
> quickest kernel: PREEMPT SMP
> quickest kernel: CPU:    0
> quickest kernel: EIP is at ahd_linux_run_command+0x201/0x648
> quickest kernel: eax: f45ac380   ebx: 00000001   ecx: 00000000   edx: f45ac380
> quickest kernel: esi: f45ac3d0   edi: 00000000   ebp: f7c93e60   esp: e8fa5b28
> quickest kernel: ds: 007b   es: 007b   ss: 0068
> quickest kernel: Process xmms (pid: 17463, threadinfo=e8fa4000 task=c9966560)
> quickest kernel: Stack: <0>00000000 c1708e00 00000000 00200202 f747a000
> f45ac380 f7c9b368 00200002
> quickest kernel:        c02a7fb7 f747a000 f7c9b368 f45ac380 00001055 00200202
> f7c9b800 f45ac380
> quickest kernel:        00000000 c027d129 f45ac380 c027d324 00000001 f7c37794
> f7c9b000 f7ca004c
> quickest kernel: Call Trace:
> quickest kernel:  [<c02a7fb7>] ahd_linux_queue+0x7b/0x84
> quickest kernel:  [<c027d129>] scsi_dispatch_cmd+0x135/0x1ea
> quickest kernel:  [<c027d324>] scsi_done+0x0/0x1c
> quickest kernel:  [<c0281deb>] scsi_request_fn+0x1ad/0x2c8
> quickest kernel:  [<c02073df>] elv_insert+0x147/0x14a
> quickest kernel:  [<c02074a9>] elv_add_request+0x31/0x46
> quickest kernel:  [<c020a1da>] blk_execute_rq_nowait+0x36/0x44
> quickest kernel:  [<c020a270>] blk_execute_rq+0x88/0xb0
> quickest kernel:  [<c020a43c>] blk_end_sync_rq+0x0/0x22
> quickest kernel:  [<c01555db>] bio_phys_segments+0x1b/0x20
> quickest kernel:  [<c020b3b8>] blk_rq_bio_prep+0x2a/0x86
> quickest kernel:  [<c02b31ec>] cdrom_read_cdda_bpc+0x15e/0x1bc
> quickest kernel:  [<c02b326d>] cdrom_read_cdda+0x23/0x90
> quickest kernel:  [<c02b4285>] mmc_ioctl+0x457/0x8c6
> quickest kernel:  [<f962cb3c>] _nv000419rm+0x24/0x28 [nvidia]
> quickest kernel:  [<f9525f21>] _nv002668rm+0x1d/0x2c [nvidia]
> quickest kernel:  [<f9525f2a>] _nv002668rm+0x26/0x2c [nvidia]
> quickest kernel:  [<c020d9f7>] scsi_cmd_ioctl+0x7f/0x3a0
> quickest kernel:  [<f969bd57>] _nv005436rm+0x23/0x28 [nvidia]
> quickest kernel:  [<f9525f21>] _nv002668rm+0x1d/0x2c [nvidia]
> quickest kernel:  [<f9525f21>] _nv002668rm+0x1d/0x2c [nvidia]
> quickest kernel:  [<f9525f2a>] _nv002668rm+0x26/0x2c [nvidia]
> quickest kernel:  [<f969bd57>] _nv005436rm+0x23/0x28 [nvidia]
> quickest kernel:  [<f969bd57>] _nv005436rm+0x23/0x28 [nvidia]
> quickest kernel:  [<f9525f21>] _nv002668rm+0x1d/0x2c [nvidia]
> quickest kernel:  [<f9525f2a>] _nv002668rm+0x26/0x2c [nvidia]
> quickest kernel:  [<c02b3d26>] cdrom_ioctl+0xa4c/0xad2
> quickest kernel:  [<f969b4ca>] _nv005201rm+0x8a/0x94 [nvidia]
> quickest kernel:  [<f953d576>] rm_set_interrupts+0x12e/0x164 [nvidia]
> quickest kernel:  [<c0218136>] fast_clear_page+0xa/0x5e
> quickest kernel:  [<c01395cb>] buffered_rmqueue+0x14d/0x210
> quickest kernel:  [<c02af2b7>] sr_block_ioctl+0x3f/0x5a
> quickest kernel:  [<c020bf67>] blkdev_driver_ioctl+0x3f/0x58
> quickest kernel:  [<c020c001>] blkdev_ioctl+0x81/0x1c2
> quickest kernel:  [<c015778c>] block_ioctl+0x1a/0x1e
> quickest kernel:  [<c0160141>] do_ioctl+0x55/0x68
> quickest kernel:  [<c01602a4>] vfs_ioctl+0x58/0x190
> quickest kernel:  [<c0160439>] sys_ioctl+0x5d/0x64
> quickest kernel:  [<c01029ed>] syscall_call+0x7/0xb
> quickest kernel: Code: b7 83 86 00 00 00 66 85 c0 0f 84 43 03 00 00 8b 7b 70
> 0f b7 d8 8b 44 24 2c 83 78 3c 03 0f 84 22 03 00 00 85 db 0f 84 f7 02 00 00
> <83> 7f 0c 00 0f 84 ed 02 00 00 85 db 74 29 31 c9 89 da 8b 04 0f
> 
The call trace shows calls to functions from the 'nvidia' driver (if I've
understood that correctly). Is this the nVidia graphics driver?
That driver might be buggy, and causing the lockup. You might want to
try reading the CD when the 'nvidia' driver is unloaded.

Hope this helps,

 Srdjan Todorovic

