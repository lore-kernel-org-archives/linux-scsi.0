From: Glenn Maynard <glenn@zewt.org>
Subject: Re: Crash during SATA reads
Date: Thu, 12 Nov 2009 04:48:20 -0500
Message-ID: <bd36f99e0911120148t43a267cbwd1899d3e68468cc@mail.gmail.com>
References: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>
	 <4AFA835B.9000904@garzik.org>
	 <bd36f99e0911110412hf2c7920gf06bd29ed43e240c@mail.gmail.com>
	 <bd36f99e0911111309ie8166a9h8f926948bf15d350@mail.gmail.com>
	 <4AFB2F2A.7080900@garzik.org> <20091112091602.GC8742@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:39202 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZKLJsP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Nov 2009 04:48:15 -0500
In-Reply-To: <20091112091602.GC8742@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Nov 12, 2009 at 4:16 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> So the device isn't mounted, which means that we'll default to 1k
> blocks. I think that's a big clue here, as you'll have 4 buffer_heads
> pointing to the same page. And one of your oopses is indeed in the
> ->b_this_page unroll.
>
> Can you trigger this if you mount/umount the device first?

Yeah.  I've reproduced it reading from /dev/sda (the drive the root
partition is mounted on) with no second drive attached, too.

I'm currently reproducing it with "dd if=/dev/sda of=/dev/sdb", since
that reproduces faster and more reproducably than just reading.
Here's a trace from one of these:

BUG: unable to handle kernel NULL pointer dereference at 000000c0
IP: [<c1097067>] bdevname+0x8/0x13
*pde = 00000000
Oops: 0000 [#1] PREEMPT
last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/model
Modules linked in: netconsole atl1c rtc

Pid: 151, comm: pdflush Not tainted (2.6.31.6 #17) G31M-ES2L
EIP: 0060:[<c1097067>] EFLAGS: 00010246 CPU: 0
EIP is at bdevname+0x8/0x13
EAX: df4ddcf0 EBX: 00000000 ECX: df87fd54 EDX: 00000000
ESI: d5cfa0c0 EDI: 00000000 EBP: 00000001 ESP: df87fd38
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process pdflush (pid: 151, ti=df87e000 task=df8caae0 task.ti=df87e000)
Stack:
 c11582ff 0006d250 00000000 fffffffb 00000002 00000246 c1ae7e80 00011200
<0> 00011210 df83a9e0 c1043b26 df87fd60 00000004 00000101 c101be1c 00000000
<0> 00000000 d5cfa0c0 00000001 c11583e4 00000001 df83aa00 df83aa00 c107d6db
Call Trace:
 [<c11582ff>] ? generic_make_request+0x1cc/0x209
 [<c1043b26>] ? mempool_alloc+0x1e/0xd6
 [<c101be1c>] ? __do_softirq+0x9b/0xc8
 [<c11583e4>] ? submit_bio+0xa8/0xb0
 [<c107d6db>] ? bio_alloc_bioset+0x3e/0xa4
 [<c107ce92>] ? submit_bh+0x127/0x152
 [<c107b117>] ? __block_write_full_page+0x1ff/0x2d8
 [<c107eafd>] ? blkdev_get_block+0x0/0x46
 [<c107cc5e>] ? block_write_full_page_endio+0xe2/0xec
 [<c1079ef7>] ? end_buffer_async_write+0x0/0xd4
 [<c107eafd>] ? blkdev_get_block+0x0/0x46
 [<c107cc72>] ? block_write_full_page+0xa/0xc
 [<c1079ef7>] ? end_buffer_async_write+0x0/0xd4
 [<c104750c>] ? __writepage+0x8/0x1d
 [<c1047407>] ? write_cache_pages+0x1bf/0x2bc
 [<c1047504>] ? __writepage+0x0/0x1d
 [<c1047521>] ? generic_writepages+0x0/0x1f
 [<c104753d>] ? generic_writepages+0x1c/0x1f
 [<c1047562>] ? do_writepages+0x22/0x32
 [<c1076444>] ? writeback_single_inode+0xad/0x1b2
 [<c1076672>] ? generic_sync_sb_inodes+0x129/0x26e
 [<c1047c80>] ? pdflush+0x0/0x2d
 [<c1076820>] ? writeback_inodes+0x64/0xb4
 [<c1047040>] ? background_writeout+0x5f/0x91
 [<c1047bab>] ? __pdflush+0xcf/0x1a4
 [<c1047ca9>] ? pdflush+0x29/0x2d
 [<c1046fe1>] ? background_writeout+0x0/0x91
 [<c1047c80>] ? pdflush+0x0/0x2d
 [<c1026d72>] ? kthread+0x6b/0x70
 [<c1026d07>] ? kthread+0x0/0x70
 [<c1002f93>] ? kernel_thread_helper+0x7/0x10
Code: 09 56 53 68 f7 09 2e c1 eb 07 56 53 68 90 0a 2e c1 6a 20 55 e8
f0 01 0d 00 83 c4 14 5b 89 e8 5e 5f 5d c3 89 d1 8b 50 48 8b 40 54 <8b>
92 c0 00 00 00 e9 92 ff ff ff 53 89 d3 89 c2 81 e2 ff ff 0f
EIP: [<c1097067>] bdevname+0x8/0x13 SS:ESP 0068:df87fd38
CR2: 00000000000000c0

-- 
Glenn Maynard
