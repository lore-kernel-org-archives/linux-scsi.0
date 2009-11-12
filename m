From: Glenn Maynard <glenn@zewt.org>
Subject: Re: Crash during SATA reads
Date: Thu, 12 Nov 2009 00:26:44 -0500
Message-ID: <bd36f99e0911112126j6e1fcfc9j283c4233e6550181@mail.gmail.com>
References: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>
	 <4AFA835B.9000904@garzik.org>
	 <bd36f99e0911110412hf2c7920gf06bd29ed43e240c@mail.gmail.com>
	 <bd36f99e0911111309ie8166a9h8f926948bf15d350@mail.gmail.com>
	 <4AFB2F2A.7080900@garzik.org>
	 <bd36f99e0911111419w55346c8ct18b57c787401b8b7@mail.gmail.com>
	 <878weco4r9.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752733AbZKLF0k@vger.kernel.org>
In-Reply-To: <878weco4r9.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 11, 2009 at 9:28 PM, Dmitry Monakhov <dmonakhov@openvz.org> wrote:
> Seems what you have use-after-free here.
> You probably have to add some debug info in to bio->end_io method
> May be something like this.

That's what it looks like, but won't these checks trigger on the use
(and give the same trace), when we need to know where the free is
happening?  The problem is manifesting in several places (bogus or
NULL bh->b_end_io in end_bio_bh_io_sync(); bh->b_this_page == NULL--I
think, havn't reproduced that again to confirm--in
block_invalidatepage()).  I'm not sure how to figure out where the
free might be happening; it's tricky enough in userspace with Valgrind
available.

I tried logging alloc_buffer_head and free_buffer_head, but it was too
much output (if it's not masking the problem entirely by changing the
timing too much, it would take ages to repro).

I just repro'd it (took several hours this time), on the
BUG_ON(!bh->b_page); assertion.  This one happened while doing a
partition copy (/dev/sdb2) rather than /dev/sdb.  Trace follows
(though I doubt it offers any new information).  Hopefully somebody
has an idea of where to look next...


kernel BUG at fs/buffer.c:2934!
invalid opcode: 0000 [#1] PREEMPT
last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/model
Modules linked in: netconsole atl1c rtc

Pid: 0, comm: swapper Not tainted (2.6.31.6 #16) G31M-ES2L
EIP: 0060:[<c107cce3>] EFLAGS: 00010282 CPU: 0
EIP is at end_bio_bh_io_sync+0x20/0x63
EAX: c1ae78c0 EBX: c107cce3 ECX: c1ae78c0 EDX: 00000000
ESI: c1ae78c0 EDI: d9e5c450 EBP: c1351eac ESP: c1351e74
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c1350000 task=c1356260 task.ti=c1350000)
Stack:
 c107e5b5 00000400 c1158828 00000000 df8a62c0 df8ef5a4 00000000 00000000
<0> 00012c00 0000d400 00000000 d9e5c450 00000000 d9e5c450 df8ef168 c11589a2
<0> df8a6500 00000000 c1158a59 00000000 df8a6500 00000000 d9e5c450 c1158ac8
Call Trace:
 [<c107e5b5>] ? bio_endio+0x24/0x26
 [<c1158828>] ? blk_update_request+0xdf/0x24e
 [<c11589a2>] ? blk_update_bidi_request+0xb/0x41
 [<c1158a59>] ? blk_end_bidi_request+0x10/0x4f
 [<c1158ac8>] ? blk_end_request+0x7/0xc
 [<c11abd12>] ? scsi_end_request+0x17/0x69
 [<c11ac023>] ? scsi_io_completion+0x173/0x335
 [<c11a8390>] ? scsi_finish_command+0x70/0x86
 [<c11ac706>] ? scsi_softirq_done+0xd7/0xdc
 [<c115b45d>] ? blk_done_softirq+0x51/0x5d
 [<c101bde0>] ? __do_softirq+0x5f/0xc8
 [<c101be6b>] ? do_softirq+0x22/0x26
 [<c101becd>] ? irq_exit+0x29/0x34
 [<c1004097>] ? do_IRQ+0x53/0x63
 [<c1002ea9>] ? common_interrupt+0x29/0x30
 [<c100716e>] ? mwait_idle+0x3c/0x44
 [<c1001423>] ? cpu_idle+0x19/0x3a
 [<c13885aa>] ? start_kernel+0x1a4/0x1a6
Code: 54 24 18 83 c4 48 5b 5e 5f 5d c3 56 53 89 c3 8b 48 40 8b 40 34
85 c0 75 04 0f 0b eb fe 85 c9 75 04 0f 0b eb fe 83 79 08 00 75 04 <0f>
0b eb fe 83 79 04 00 75 04 0f 0b eb fe 83 fa a1 75 08 80 4b
EIP: [<c107cce3>] end_bio_bh_io_sync+0x20/0x63 SS:ESP 0068:c1351e74

-- 
Glenn Maynard
