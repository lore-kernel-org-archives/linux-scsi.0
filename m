From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: Crash during SATA reads
Date: Thu, 12 Nov 2009 05:28:58 +0300
Message-ID: <878weco4r9.fsf@openvz.org>
References: <bd36f99e0911110118v6dc7f87ao98968ba234fad7fc@mail.gmail.com>
 <4AFA835B.9000904@garzik.org>
 <bd36f99e0911110412hf2c7920gf06bd29ed43e240c@mail.gmail.com>
 <bd36f99e0911111309ie8166a9h8f926948bf15d350@mail.gmail.com>
 <4AFB2F2A.7080900@garzik.org>
 <bd36f99e0911111419w55346c8ct18b57c787401b8b7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759901AbZKLB2n@vger.kernel.org>
In-reply-to: <bd36f99e0911111419w55346c8ct18b57c787401b8b7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Glenn Maynard <glenn@zewt.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Glenn Maynard <glenn@zewt.org> writes:

> On Wed, Nov 11, 2009 at 4:39 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> I would poke Jens Axboe (block maintainer) and linux-scsi, the issuer of
>> these commands.
>
> (Looks like you poked for me; thanks.)
>
>> Also, providing filesystem info (ext3? ext4? XFS? btrfs?) and info on your
>> workload would be helpful.
>
> These crashes happen while running "dd if=/dev/sdb | gzip > /dev/null"
> in 2.6.31.6.  I'm just making a raw image of another drive.  Removing
> gzip masks the problem.  It happens anywhere between almost
> immediately to after running for 15-30 minutes.
>
> All filesystems are XFS, but none of sdb's partitions are mounted and
> I'm reading the device directly (/dev/sdb, not a partition).  The
> system that's making the image is mounted read-only and isn't running
> anything else.
>
> (Another backtrace at http://lkml.org/lkml/2009/11/11/81.)
Seems what you have use-after-free here.
You probably have to add some debug info in to bio->end_io method
May be something like this.
diff --git a/fs/buffer.c b/fs/buffer.c
index 6fa5302..ce95791 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2930,6 +2930,10 @@ EXPORT_SYMBOL(generic_block_bmap);
 static void end_bio_bh_io_sync(struct bio *bio, int err)
 {
 	struct buffer_head *bh = bio->bi_private;
+	BIO_BUG_ON(!atomic_read(&bio->bi_cnt));
+	BUG_ON(!bh);
+	BUG_ON(!bh->b_page);
+	BUG_ON(!bh->b_this_page);
 
 	if (err == -EOPNOTSUPP) {
 		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);


>
> Here's a curious one; EIP appears to be in data:
>
> Pid: 1312, comm: gzip Not tainted (2.6.31.6 #6) G31M-ES2L
> EIP: 0060:[<c1ae78e4>] EFLAGS: 00010286 CPU: 0
> EIP is at 0xc1ae78e4
> EAX: c1ae78c0 EBX: c107ccb1 ECX: c1ae78c0 EDX: 00000001
> ESI: c1ae78c0 EDI: dfa39069 EBP: c7d29ed0 ESP: c7d29e94
>  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> Process gzip (pid: 1312, ti=c7d28000 task=df8b6080 task.ti=c7d28000)
> Stack:
>  c107ccc1 c107e559 00000200 c11587cc 00000000 df8a6c80 dfa07168 00000000
> <0> 00000000 0000c000 00004000 00000000 dfa39068 00000000 dfa39068 dfa07168
> <0> c1158946 df8a6c80 00000000 c11589fd 00000000 df8a6c80 00000000 dfa39068
> Call Trace:
>  [<c107ccc1>] ? end_bio_bh_io_sync+0x30/0x38
>  [<c107e559>] ? bio_endio+0x24/0x26
>  [<c11587cc>] ? blk_update_request+0xdf/0x24e
>  [<c1158946>] ? blk_update_bidi_request+0xb/0x41
>  [<c11589fd>] ? blk_end_bidi_request+0x10/0x4f
>  [<c1158a6c>] ? blk_end_request+0x7/0xc
>  [<c11abcc2>] ? scsi_end_request+0x17/0x69
>  [<c11abfd3>] ? scsi_io_completion+0x173/0x335
>  [<c11a8340>] ? scsi_finish_command+0x70/0x86
>  [<c11ac6b6>] ? scsi_softirq_done+0xd7/0xdc
>  [<c115b401>] ? blk_done_softirq+0x51/0x5d
>  [<c101bde0>] ? __do_softirq+0x5f/0xc8
>  [<c101be6b>] ? do_softirq+0x22/0x26
>  [<c101becd>] ? irq_exit+0x29/0x34
>  [<c1004097>] ? do_IRQ+0x53/0x63
>  [<c1002ea9>] ? common_interrupt+0x29/0x30
> Code: 00 00 00 00 00 00 00 c0 72 77 83 00 00 00 00 40 79 ae c1 40 8e
> 4c df 09 00 00 f0 00 00 00 00 01 00 00 00 01 00 00 00 00 00 00 00 <00>
> 02 00 00 00 02 00 00 04 00 00 00 ff ff ff ff 01 00 00 00 08
> EIP: [<c1ae78e4>] 0xc1ae78e4 SS:ESP 0068:c7d29e94
> CR2: 0000000000000001
> ---[ end trace fb168fcf160f6893 ]---
