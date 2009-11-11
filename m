From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Crash during SATA reads
Date: Wed, 11 Nov 2009 16:39:54 -0500
Message-ID: <4AFB2F2A.7080900@garzik.org>
References: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>	 <4AFA835B.9000904@garzik.org>	 <bd36f99e0911110412hf2c7920gf06bd29ed43e240c@mail.gmail.com> <bd36f99e0911111309ie8166a9h8f926948bf15d350@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35796 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758904AbZKKVjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 16:39:52 -0500
In-Reply-To: <bd36f99e0911111309ie8166a9h8f926948bf15d350@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Glenn Maynard <glenn@zewt.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On 11/11/2009 04:09 PM, Glenn Maynard wrote:
> Another trace, this time a bit deeper:
>
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c1079e7b>] end_buffer_async_read+0x59/0xc5
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> last sysfs file:
> Modules linked in: netconsole atl1c rtc
>
> Pid: 1300, comm: gzip Not tainted (2.6.31.6 #5) G31M-ES2L
> EIP: 0060:[<c1079e7b>] EFLAGS: 00010013 CPU: 0
> EIP is at end_buffer_async_read+0x59/0xc5
> EAX: 00000000 EBX: c1ae7b38 ECX: 00000000 EDX: c1079e22
> ESI: 00000202 EDI: c17b5040 EBP: 00000000 ESP: df1dde80
>   DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process gzip (pid: 1300, ti=df1dc000 task=df866420 task.ti=df1dc000)
> Stack:
>   ce632840 ce632840 df91de78 df1dded0 c107ccb9 c107cc89 c107e551 00000200
> <0>  c11587c4 00000000 00000001 df430298 00000000 00000000 0000be00 00004200
> <0>  00000000 df91de78 00000000 df91de78 df8ef168 c115893e df8a6c80 00000000
> Call Trace:
>   [<c107ccb9>] ? end_bio_bh_io_sync+0x30/0x38
>   [<c107cc89>] ? end_bio_bh_io_sync+0x0/0x38
>   [<c107e551>] ? bio_endio+0x24/0x26
>   [<c11587c4>] ? blk_update_request+0xdf/0x24e
>   [<c115893e>] ? blk_update_bidi_request+0xb/0x41
>   [<c11589f5>] ? blk_end_bidi_request+0x10/0x4f
>   [<c1158a64>] ? blk_end_request+0x7/0xc
>   [<c11abcb2>] ? scsi_end_request+0x17/0x69
>   [<c11abfc3>] ? scsi_io_completion+0x173/0x335
>   [<c11a8330>] ? scsi_finish_command+0x70/0x86
>   [<c11ac6a6>] ? scsi_softirq_done+0xd7/0xdc
>   [<c115b3f9>] ? blk_done_softirq+0x51/0x5d
>   [<c101bde0>] ? __do_softirq+0x5f/0xc8
>   [<c101be6b>] ? do_softirq+0x22/0x26
>   [<c101becd>] ? irq_exit+0x29/0x34
>   [<c1004097>] ? do_IRQ+0x53/0x63
>   [<c1002ea9>] ? common_interrupt+0x29/0x30
> Code: e8 d2 fd ff ff 80 0f 02 f6 47 01 08 75 04 0f 0b eb fe 9c 5e fa
> 89 e0 25 00 e0 ff ff ff 40 14 80 23 7f 89 d8 e8 58 fd ff ff 89 d9<8b>
> 11 b8 00 00 00 00 f6 c2 01 0f 44 e8 f6 c2 80 74 09 80 e2 04
> EIP: [<c1079e7b>] end_buffer_async_read+0x59/0xc5 SS:ESP 0068:df1dde80
> CR2: 0000000000000000
> ---[ end trace 2e93648aef49fa0e ]---
>
> It looks like buffer_tmp was NULL during end_buffer_async_read's
> buffer_uptodate(tmp).
>
>
> This one just happened when I interrupted the dd:
>
> BUG: unable to handle kernel NULL pointer dereference at 00000004
> IP: [<c107ae05>] block_invalidatepage+0x22/0x54
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT
> last sysfs file:
> Modules linked in: netconsole atl1c rtc
>
> Pid: 1296, comm: dd Not tainted (2.6.31.6 #6) G31M-ES2L
> EIP: 0060:[<c107ae05>] EFLAGS: 00010217 CPU: 0
> EIP is at block_invalidatepage+0x22/0x54
> EAX: 00000000 EBX: c14f1540 ECX: 00000002 EDX: 00001000
> ESI: 00000000 EDI: 00001000 EBP: c8d4fc88 ESP: df1d7ed0
>   DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process dd (pid: 1296, ti=df1d6000 task=df87bc00 task.ti=df1d6000)
> Stack:
>   00000000 c14f1540 00000000 c14f1540 00064156 c1048c29 c14f1540 c1048cab
> <0>  00000001 c1048def ffffffff 00000000 df4cff54 0000000e 00000000 c13f0440
> <0>  c14f1540 c14f2ae0 c13f7a40 c13f7e80 c13fd220 c13efd40 c13efd60 c13f01c0
> Call Trace:
>   [<c1048c29>] ? do_invalidatepage+0x1d/0x1f
>   [<c1048cab>] ? truncate_complete_page+0x19/0x4b
>   [<c1048def>] ? truncate_inode_pages_range+0xd1/0x2af
>   [<c1048fd6>] ? truncate_inode_pages+0x9/0xc
>   [<c107fb83>] ? __blkdev_put+0x47/0xec
>   [<c1060fe7>] ? __fput+0xc4/0x177
>   [<c105fa8a>] ? filp_close+0x4c/0x52
>   [<c105faee>] ? sys_close+0x5e/0x99
>   [<c10027f0>] ? sysenter_do_call+0x12/0x22
> Code: bf 89 d8 5b e9 ee ed ff ff 55 57 56 53 89 c3 56 89 14 24 31 d2
> 8b 00 a8 01 75 04 0f 0b eb fe f6 c4 08 74 33 8b 6b 0c 89 e8 89 d7<8b>
> 70 04 03 78 14 39 14 24 77 05 e8 97 ff ff ff 39 ee 89 fa 89
> EIP: [<c107ae05>] block_invalidatepage+0x22/0x54 SS:ESP 0068:df1d7ed0
> CR2: 0000000000000004
> ---[ end trace 64b0df80bcbb02ce ]---
>
> Here, it looks like bh is NULL in block_invalidatepage's loop, dying
> at bh->b_size.
>
> I'm not sure where to go from here.

I would poke Jens Axboe (block maintainer) and linux-scsi, the issuer of 
these commands.

Also, providing filesystem info (ext3? ext4? XFS? btrfs?) and info on 
your workload would be helpful.

	Jeff



