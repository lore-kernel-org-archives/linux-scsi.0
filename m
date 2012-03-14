From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [Lsf-pc] [Topic] Bcache
Date: Wed, 14 Mar 2012 13:24:08 -0400
Message-ID: <CAH+dOxKxZYSdZfewt5mHsvOk68VfNKzMQveibGLM+qunV6mOMw@mail.gmail.com>
References: <20120314133228.GA2284@dhcp-172-18-216-138.mtv.corp.google.com>
	<20120314155339.GC30235@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43495 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab2CNRYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Mar 2012 13:24:09 -0400
Received: by iagz16 with SMTP id z16so2589873iag.19
        for <linux-scsi@vger.kernel.org>; Wed, 14 Mar 2012 10:24:08 -0700 (PDT)
In-Reply-To: <20120314155339.GC30235@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, nauman@google.com, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Mar 14, 2012 at 11:53 AM, Vivek Goyal <vgoyal@redhat.com> wrote=
:
> On Wed, Mar 14, 2012 at 09:32:28AM -0400, Kent Overstreet wrote:
>> I'm already registered to attend, but would it be too late in the
>> process to give a talk? I'd like to give a short talk about bcache, =
what
>> it does and where it's going (more than just caching).
>
> [CCing dm-devel list]
>
> I am curious if you considered writing a device mapper driver for thi=
s? If
> yes, why that is not a good choice. It seems to be stacked device and=
 device
> mapper should be good at that. All the configuration through sysfs se=
ems
> little odd to me.

Everyone asks this. Yeah, I considered it, I tried to make it work for
a couple weeks but it was far more trouble than it was worth. I'm not
opposed to someone else working on it but I'm not going to spend any
more time on it myself.
>
> On a side note, I was playing with bcache a bit. I tried to register =
the
> cache device and it crashes. (I guess I should post this on relevant =
mailing
> list).

Can you post the full log? There was a bug where if it encountered an
error during registration, it wouldn't wait for a uuid read or write
before tearing everything down - that's what your backtrace looks like
to me.

You could try the bcache-3.2-dev branch, too. I have a newer branch
with a ton of bugfixes but I'm waiting until it's seen more testing
before I post it.

>
> # echo /dev/sdc > /sys/fs/bcache/register
>
> [ 6758.314093] Pid: 0, comm: kworker/0:1 Not tainted 3.1.0-bcache+ #2
> Hewlett-Packard HP xw6600 Workstation/0A9Ch
> [ 6758.314093] RIP: 0010:[<ffffffff8146625b>] =A0[<ffffffff8146625b>]
> closure_put+0x5b/0xe0
> [ 6758.314093] RSP: 0018:ffff88013fc83c60 =A0EFLAGS: 00010246
> [ 6758.314093] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8801281204a0 RCX:
> 0000000000000000
> [ 6758.314093] RDX: 0000000000000000 RSI: 00000000ffffffff RDI:
> ffff88013906ec48
> [ 6758.314093] RBP: ffff88013fc83c60 R08: 0000000000000000 R09:
> 0000000000000001
> [ 6758.314093] R10: 0000000000000000 R11: 0000000000000000 R12:
> 0000000000000000
> [ 6758.314093] R13: ffff880130b58560 R14: 0000000000080000 R15:
> 0000000000000000
> [ 6758.314093] FS: =A00000000000000000(0000) GS:ffff88013fc80000(0000=
)
> knlGS:0000000000000000
> [ 6758.314093] CS: =A00010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 6758.314093] CR2: 00007f9becec7000 CR3: 0000000137fe0000 CR4:
> 00000000000006e0
> [ 6758.314093] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 6758.314093] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [ 6758.314093] Process kworker/0:1 (pid: 0, threadinfo ffff88013a44a0=
00,
> task ffff88013a458000)
> [ 6758.314093] Stack:
> [ 6758.314093] =A0ffff88013fc83c80 ffffffff8145ee6d ffffffff00000000
> ffff8801281204a0
> [ 6758.314093] =A0ffff88013fc83c90 ffffffff81173a9d ffff88013fc83cc0
> ffffffff812d15d3
> [ 6758.314093] =A0ffff88013a44a000 0000000000000000 ffff8801281204a0
> 0000000000080000
> [ 6758.314093] Call Trace:
> [ 6758.314093] =A0<IRQ>
> [ 6758.314093] =A0[<ffffffff8145ee6d>] uuid_endio+0x3d/0x50
> [ 6758.314093] =A0[<ffffffff81173a9d>] bio_endio+0x1d/0x40
> [ 6758.314093] =A0[<ffffffff812d15d3>] req_bio_endio+0x83/0xc0
> [ 6758.314093] =A0[<ffffffff812d4f71>] blk_update_request+0x101/0x5c0
> [ 6758.314093] =A0[<ffffffff812d51a2>] ? blk_update_request+0x332/0x5=
c0
> [ 6758.314093] =A0[<ffffffff812d5461>] blk_update_bidi_request+0x31/0=
x90
> [ 6758.314093] =A0[<ffffffff812d54ec>] blk_end_bidi_request+0x2c/0x80
> [ 6758.314093] =A0[<ffffffff812d5580>] blk_end_request+0x10/0x20
> [ 6758.314093] =A0[<ffffffff81471b7c>] scsi_io_completion+0x9c/0x5f0
> [ 6758.314093] =A0[<ffffffff81468940>] scsi_finish_command+0xb0/0xe0
> [ 6758.314093] =A0[<ffffffff81471965>] scsi_softirq_done+0xa5/0x140
> [ 6758.314093] =A0[<ffffffff812db70b>] blk_done_softirq+0x7b/0x90
> [ 6758.314093] =A0[<ffffffff8104fc65>] __do_softirq+0xc5/0x3a0
> [ 6758.314093] =A0[<ffffffff817f6dac>] call_softirq+0x1c/0x30
> [ 6758.314093] =A0[<ffffffff8100419d>] do_softirq+0x8d/0xc0
> [ 6758.314093] =A0[<ffffffff8105027e>] irq_exit+0xae/0xe0
> [ 6758.314093] =A0[<ffffffff817f74b3>] do_IRQ+0x63/0xe0
> [ 6758.314093] =A0[<ffffffff817ecc30>] common_interrupt+0x70/0x70
> [ 6758.314093] =A0<EOI>
> [ 6758.314093] =A0[<ffffffff8100a1f6>] ? mwait_idle+0xb6/0x470
> [ 6758.314093] =A0[<ffffffff8100a1ed>] ? mwait_idle+0xad/0x470
> [ 6758.314093] =A0[<ffffffff810011df>] cpu_idle+0x8f/0xd0
> [ 6758.314093] =A0[<ffffffff817da107>] start_secondary+0x1be/0x1c2
> [ 6758.314093] Code: 00 48 8b 50 48 83 e2 08 0f 85 9c 00 00 00 48 8b =
50 48
> 83 e2 10 0f 85 8d 00 00 00 48 83 78 18 00 75 46 48 8b 40 40 48 85 c0 =
74 24
> [ 6758.314093] =A08b 50 48 48 c1 ea 04 89 d1 89 f2 83 e1 01 f0 0f c1 =
50 4c
> 83
> [ 6758.314093] RIP =A0[<ffffffff8146625b>] closure_put+0x5b/0xe0
> [ 6758.314093] =A0RSP <ffff88013fc83c60>
>
> Thanks
> Vivek
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
