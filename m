From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and
 auditing
Date: Wed, 18 Jul 2007 14:58:18 -0700
Message-ID: <20070718145818.8eebbd66.rdunlap@xenotime.net>
References: <4695F76F.5000305@panasas.com>
	<20070712135750.2a4a4a54.rdunlap@xenotime.net>
	<469B38CC.50501@panasas.com>
	<20070717171607.ffc278eb.rdunlap@xenotime.net>
	<469DDD74.2060208@panasas.com>
	<20070718103320.4b6ad7b3.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:57914 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751989AbXGRVx5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 17:53:57 -0400
Received: from midway.site ([71.117.236.25]) by xenotime.net for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 14:53:55 -0700
In-Reply-To: <20070718103320.4b6ad7b3.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, "=?ISO-8859-1?Q? J=FCrgen_E._Fischer ?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Wed, 18 Jul 2007 10:33:20 -0700 Randy Dunlap wrote:

> On Wed, 18 Jul 2007 12:29:24 +0300 Boaz Harrosh wrote:
> 
> > Randy Dunlap wrote:
> > > On Mon, 16 Jul 2007 12:22:20 +0300 Boaz Harrosh wrote:
> > > 
> > >> If you could do some testing it is grate. The first 3 patches do not
> > >> need scsi-misc specifically. Any post 2.6.20 tree will do. The last patch
> > >> could be done together with attached patch on any 2.6.22 tree.
> > >> (Apply attached patch anywhere before the last patch (4/4) of the patchset)
> > >> Though I do recommend scsi-misc tree.
> > > 
> > > I took 2.6.22, backed out Christoph's aha152x.c patch (using
> > > completion for timeouts), added your 5 patches, and then tested.
> > > Does that sound OK?
> > > 
> > Yes what you did is perfect
> > I was not aware of "Christoph's aha152x.c patch" is that in scsi-misc?
> > I'm almost positive I did a git-pull before I sent the patches.
> > Sorry about that.
> > 
> > >> Testing:
> > > 
> > > I booted/tested 4 times.  2 Oopsen and 2 of
> > > could-never-mount-the-device-due-to-reset-problems.
> > > Log is attached.
> > > 
> > > 
> > > ---
> > > ~Randy
> > > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > Thank you for testing and helping me with this.
> > 
> > I found one thing that should definitely trash the Reset
> > and do funny things. But I'm not sure it is it at all.
> > If below does not work, could you pleas do a small bisect
> > of my patches.
> > 
> > first patch first, than 2nd, 3rd ,accessors thing, and 4th 
> 
> Hi,
> 
> I don't see the reset problem after applying this patch, but I'm
> still seeing an Oops in datao_run.  Log is attached.


More log after I added a printk() in datao_run:
See <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< line.


[   95.424000] aha152x datao_run: data_count=128, this_residual=1536, cur.ptr=0xf644ba00
[   95.428000] aha152x datao_run: data_count=128, this_residual=1408, cur.ptr=0xf644ba80
[   95.432000] aha152x datao_run: data_count=128, this_residual=1280, cur.ptr=0xf644bb00
[   95.436000] aha152x datao_run: data_count=128, this_residual=1152, cur.ptr=0xf644bb80
[   95.440000] aha152x datao_run: data_count=128, this_residual=1024, cur.ptr=0xf644bc00
[   95.444000] aha152x datao_run: data_count=128, this_residual=896, cur.ptr=0xf644bc80
[   95.452000] aha152x datao_run: data_count=128, this_residual=768, cur.ptr=0xf644bd00
[   95.456000] aha152x datao_run: data_count=128, this_residual=640, cur.ptr=0xf644bd80
[   95.460000] aha152x datao_run: data_count=128, this_residual=512, cur.ptr=0xf644be00
[   95.464000] aha152x datao_run: data_count=128, this_residual=384, cur.ptr=0xf644be80
[   95.468000] aha152x datao_run: data_count=128, this_residual=256, cur.ptr=0xf644bf00
[   95.472000] aha152x datao_run: data_count=128, this_residual=128, cur.ptr=0xf644bf80
[  112.816000] aha152x datao_run: data_count=128, this_residual=4096, cur.ptr=0x00000000 <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
[  112.820000] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  112.824000]  printing eip:
[  112.828000] f88792a0
[  112.828000] *pde = 00000000
[  112.832000] Oops: 0000 [#1]
[  112.832000] SMP 
[  112.832000] Modules linked in: aha152x_cs loop sr_mod yenta_socket rsrc_nonstatic pcmcia pcmcia_core ipw2200
[  112.832000] CPU:    0
[  112.832000] EIP:    0060:[<f88792a0>]    Not tainted VLI
[  112.832000] EFLAGS: 00010206   (2.6.22 #6)
[  112.832000] EIP is at datao_run+0xed/0x20f [aha152x_cs]
[  112.832000] eax: c26f6808   ebx: f7a15a34   ecx: 00000040   edx: 00002356
[  112.832000] esi: 00000000   edi: 00000040   ebp: c252bf28   esp: c252bef4
[  112.832000] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  112.832000] Process events/0 (pid: 6, ti=c252a000 task=c2506030 task.ti=c252a000)
[  112.832000] Stack: f887ad00 00000080 00001000 00000000 ffff49ff 00000000 f7a156a0 00002340 
[  112.832000]        c24ded90 00000286 f7a15a34 00000001 00000000 c252bf64 f8877332 c24d8558 
[  112.832000]        c252bf4c c0126a55 000000fa c2405ae0 0000234c f7a156a0 ffff4934 00000001 
[  112.832000] Call Trace:
[  112.832000]  [<c0103553>] show_trace_log_lvl+0x1a/0x2f
[  112.832000]  [<c0103605>] show_stack_log_lvl+0x9d/0xa5
[  112.832000]  [<c01037d0>] show_registers+0x1c3/0x295
[  112.832000]  [<c01039b3>] die+0x111/0x213
[  112.832000]  [<c033afb0>] do_page_fault+0x43c/0x50f
[  112.832000]  [<c0339942>] error_code+0x72/0x78
[  112.832000]  [<f8877332>] run+0x378/0x450 [aha152x_cs]
[  112.832000]  [<c0126322>] run_workqueue+0x80/0x105
[  112.832000]  [<c0126bfd>] worker_thread+0xcb/0xd6
[  112.832000]  [<c01291a5>] kthread+0x3b/0x62
[  112.832000]  [<c01031ef>] kernel_thread_helper+0x7/0x10
[  112.832000]  =======================
[  112.832000] Code: 8b 93 40 03 00 00 83 c2 12 ee 83 ff 01 7e 42 8b 43 04 d1 ff 89 f9 8b 90 f8 00 00 00 89 55 e0 8b 93 40 03 00 00 8b 75 e0 83 c2 16 <f3> 66 6f 8b 75 e0 8d 14 3f 6b cf fe 01 d6 89 b0 f8 00 00 00 8b 
[  112.832000] EIP: [<f88792a0>] datao_run+0xed/0x20f [aha152x_cs] SS:ESP 0068:c252bef4
[  172.816000] (scsi2:4:0) cannot abort running or disconnected command
[  172.820000] (scsi2:4:0) cannot reset current device

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
