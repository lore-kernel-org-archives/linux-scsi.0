From: Adam Kropelin <akropel1@rochester.rr.com>
Subject: Re: aic7xxx & st: BUG at include/asm/dma-mapping.h:37
Date: Thu, 7 Aug 2003 20:19:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030807201916.A1065@mail.kroptech.com>
References: <20030806231359.A28252@mail.kroptech.com> <Pine.LNX.4.56.0308072346560.1035@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roc-24-93-20-125.rochester.rr.com ([24.93.20.125]:39152 "EHLO
	mail.kroptech.com") by vger.kernel.org with ESMTP id S271116AbTHHAX4
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Aug 2003 20:23:56 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.56.0308072346560.1035@kai.makisara.local>; from Kai.Makisara@kolumbus.fi on Fri, Aug 08, 2003 at 12:00:56AM +0300
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

On Fri, Aug 08, 2003 at 12:00:56AM +0300, Kai Makisara wrote:
> No solution but some test results...
> 
> On Wed, 6 Aug 2003, Adam Kropelin wrote:
> 
> > Steps to reproduce:
> > mt -f /dev/st0 setblk 0   # Set variable block size
> > dd if=/dev/zero of=/dev/st0 bs=1237 count=1  # Write an unusual block
> > mt -f /dev/st0 setblk 512 # Set block size to 512 fixed
> > dd if=/dev/st0 bs=512     # BUG
> >
> I tried this with a DDS4 drive and sym53c8xx_2 (with bs=1236 because the
> sym driver does not like odd counts on wide bus). The result was correct,

The exact block size doesn't seem to matter; I picked 1237 pretty much
at random. Anything different from the fixed block size appears to cause the
problem (e.g., 510, 511, 513 and 514 all BUG here, but 512 does not).

> i.e., the last dd fails and there is a message in syslog about incorrect
> block size.

I do occasionally see a report from st about an incorrect block size
immediately before the oops. Most of the time the oops prevents that
message from displaying (I think) but I've seen it a couple of times.

My knowledge of the SCSI subsystem is weak, so forgive me if this is a
stupid question. If st knows the block size to be invalid, why does the
io ever get submitted at all? Perhaps the io gets issued and
completed, at which time st learns the block size was wrong, warns about
it, and somehow the next command thru the SCSI layer hoses up? I'm
really just grasping at straws here (as you can tell).

> > kernel BUG at include/asm/dma-mapping.h:37!
> 
> This comes from 'BUG_ON(direction == DMA_NONE)' in dma_map_sg(). I
> inserted a printk into st_do_scsi() in st.c to see if DMA_NONE is used for
> some command that should transfer data. No errors seen in these printk
> results.

I tried aic7xxx_old and hit the same BUG so Justin's driver would seem
to be exonerated. The new backtrace is below. The commonality is clearly
the st driver and the SCSI midlayer. Perhaps I'll try to verbosify
things a bit in that area and see what comes up.

--Adam


kernel BUG at include/asm/dma-mapping.h:37!
invalid operand: 0000 [#1]
CPU:    1
EIP:    0060:[<c02aa956>]    Not tainted
EFLAGS: 00010046
EIP is at aic7xxx_buildscb+0x196/0x300
eax: 00000001   ebx: e7dd6000   ecx: e7da8000   edx: e7de91a0
esi: e7de91fa   edi: e7d95038   ebp: e7de4800   esp: e4657d48
ds: 007b   es: 007b   ss: 0068
Process dd (pid: 1436, threadinfo=e4656000 task=e4b38d40)
Stack: 00000001 e7da8000 e7de9260 00000246 e4656000 c01249f1 e7de4800 e7de91a0
       00000000 e7de6dbc c02aabb7 e7de6dbc e7de91a0 e7de4800 e4656000 00000297
       e7de91a0 e7de6c00 c029355b e7de91a0 c02936f0 00000001 e7de91a0 e7dd6000
Call Trace:
 [<c01249f1>] add_timer+0x81/0xc0
 [<c02aabb7>] aic7xxx_queue+0xf7/0x140
 [<c029355b>] scsi_dispatch_cmd+0x15b/0x1b0
 [<c02936f0>] scsi_done+0x0/0x70
 [<c0297f37>] scsi_request_fn+0x257/0x320
 [<c025cf38>] blk_insert_request+0x78/0xb0
 [<c025cf42>] blk_insert_request+0x82/0xb0
 [<c0296d96>] scsi_insert_special_req+0x26/0x30
 [<c0296e91>] scsi_do_req+0x71/0x80
 [<c0292fda>] scsi_allocate_request+0x1a/0x60
 [<c02ad70c>] st_do_scsi+0x10c/0x150
 [<c02ad550>] st_sleep_done+0x0/0xb0
 [<c02b0754>] st_int_ioctl+0x6d4/0xa40
 [<c02af3a6>] read_tape+0x266/0x3b0
 [<c02ae8fe>] setup_buffering+0x6e/0x100
 [<c02af765>] st_read+0x275/0x3b0
 [<c0146076>] do_brk+0x116/0x1e0
 [<c01510ea>] vfs_read+0xaa/0xe0
 [<c01512df>] sys_read+0x2f/0x50
 [<c01090ef>] syscall_call+0x7/0xb

Code: 0f 0b 25 00 80 37 37 c0 8b 04 24 85 c0 74 3e 8b 0c 24 31 d2
 <6>note: dd[1436] exited with preempt_count 1

