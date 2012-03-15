From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Lsf-pc] [Topic] Bcache
Date: Thu, 15 Mar 2012 19:46:10 -0400
Message-ID: <20120315234610.GA8757@dhcp-172-18-216-138.mtv.corp.google.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120314155339.GC30235@redhat.com>
 <CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
 <20120315194336.GH3253@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47614 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2COXqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Mar 2012 19:46:17 -0400
Received: by yenl12 with SMTP id l12so3659785yen.19
        for <linux-scsi@vger.kernel.org>; Thu, 15 Mar 2012 16:46:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20120315194336.GH3253@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Thu, Mar 15, 2012 at 03:43:36PM -0400, Vivek Goyal wrote:
> On Wed, Mar 14, 2012 at 01:24:08PM -0400, Kent Overstreet wrote:
> 
> [..]
> > 
> > Can you post the full log? There was a bug where if it encountered an
> > error during registration, it wouldn't wait for a uuid read or write
> > before tearing everything down - that's what your backtrace looks like
> > to me.
> > 
> > You could try the bcache-3.2-dev branch, too. I have a newer branch
> > with a ton of bugfixes but I'm waiting until it's seen more testing
> > before I post it.
> 
> Faced the same issue on bcache-3.2-dev branch too.

Shoot.

Well, I know I fixed that bug (well, a bug with the same symptoms), and
I guess that branch was kind of old.

I just updated the bcache-3.2-dev branch to the newest vaguely possibly
tested code; the 3.2 version is only build tested (we're still
developing on 2.6.34).

> 
> login: [  167.532932] bio: create slab <bio-1> at 1
> [  167.539071] bcache: invalidating existing data
> [  167.547604] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  167.548573] CPU 2 
> [  167.548573] Modules linked in: floppy [last unloaded: scsi_wait_scan]
> [  167.548573] 
> [  167.548573] Pid: 0, comm: swapper/2 Not tainted 3.2.0-bcache+ #4
> Hewlett-Packard HP xw6600 Workstation/0A9Ch
> [  167.548573] RIP: 0010:[<ffffffff8144d6fe>]  [<ffffffff8144d6fe>]
> closure_put+0xe/0x20
> [  167.548573] RSP: 0018:ffff88013fc83c60  EFLAGS: 00010246
> [  167.548573] RAX: 0000000000000000 RBX: ffff8801385b04a0 RCX:
> 0000000000000000
> [  167.548573] RDX: 0000000000000000 RSI: 00000000ffffffff RDI:
> 6b6b6b6b6b6b6b6b
> [  167.548573] RBP: ffff88013fc83c60 R08: 0000000000000000 R09:
> 0000000000000001
> [  167.548573] R10: 0000000000000000 R11: 0000000000000000 R12:
> 0000000000000000
> [  167.548573] R13: ffff880137719580 R14: 0000000000080000 R15:
> 0000000000000000
> [  167.548573] FS:  0000000000000000(0000) GS:ffff88013fc80000(0000)
> knlGS:0000000000000000
> [  167.548573] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  167.548573] CR2: 00007f6e84f70240 CR3: 000000013707d000 CR4:
> 00000000000006e0
> [  167.548573] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  167.548573] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  167.548573] Process swapper/2 (pid: 0, threadinfo ffff88013a454000,
> task ffff88013a458000)
> [  167.548573] Stack:
> [  167.548573]  ffff88013fc83c80 ffffffff814448c6 ffffffff00000000
> ffff8801385b04a0
> [  167.548573]  ffff88013fc83c90 ffffffff8117ae8d ffff88013fc83cc0
> ffffffff812e2273
> [  167.548573]  ffff88013a454000 0000000000000000 ffff8801385b04a0
> 0000000000080000
> [  167.548573] Call Trace:
> [  167.548573]  <IRQ> 
> [  167.548573]  [<ffffffff814448c6>] uuid_endio+0x36/0x40
> [  167.548573]  [<ffffffff8117ae8d>] bio_endio+0x1d/0x40
> [  167.548573]  [<ffffffff812e2273>] req_bio_endio+0x83/0xc0
> [  167.548573]  [<ffffffff812e53e1>] blk_update_request+0x101/0x5c0
> [  167.548573]  [<ffffffff812e5612>] ? blk_update_request+0x332/0x5c0
> [  167.548573]  [<ffffffff812e58d1>] blk_update_bidi_request+0x31/0x90
> [  167.548573]  [<ffffffff812e595c>] blk_end_bidi_request+0x2c/0x80
> [  167.548573]  [<ffffffff812e59f0>] blk_end_request+0x10/0x20
> [  167.548573]  [<ffffffff81458fdc>] scsi_io_completion+0x9c/0x5f0
> [  167.548573]  [<ffffffff8144fcd0>] scsi_finish_command+0xb0/0xe0
> [  167.548573]  [<ffffffff81458dc5>] scsi_softirq_done+0xa5/0x140
> [  167.548573]  [<ffffffff812ec55b>] blk_done_softirq+0x7b/0x90
> [  167.548573]  [<ffffffff810512ae>] __do_softirq+0xce/0x3c0
> [  167.548573]  [<ffffffff817e84ac>] call_softirq+0x1c/0x30
> [  167.548573]  [<ffffffff8100417d>] do_softirq+0x8d/0xc0
> [  167.548573]  [<ffffffff810518de>] irq_exit+0xae/0xe0
> [  167.548573]  [<ffffffff817e8bb3>] do_IRQ+0x63/0xe0
> [  167.548573]  [<ffffffff817de1f0>] common_interrupt+0x70/0x70
> [  167.548573]  <EOI> 
> [  167.548573]  [<ffffffff8100a5f6>] ? mwait_idle+0xb6/0x490
> [  167.548573]  [<ffffffff8100a5ed>] ? mwait_idle+0xad/0x490
> [  167.548573]  [<ffffffff810011e6>] cpu_idle+0x96/0xe0
> [  167.548573]  [<ffffffff817cb475>] start_secondary+0x1be/0x1c2
> [  167.548573] Code: ee 01 00 00 10 e8 03 ff ff ff 48 85 db 75 de 5b 41 5c
> 5d c3 66 0f 1f 84 00 00 00 00 00 55 48 89 e5 66 66 66 66 90 be ff ff ff ff
> <f0> 0f c1 77 48 83 ee 01 e8 d5 fe ff ff 5d c3 0f 1f 00 55 48 89 
> [  167.548573] RIP  [<ffffffff8144d6fe>] closure_put+0xe/0x20
> [  167.548573]  RSP <ffff88013fc83c60>
> 
> Thanks
> Vivek
