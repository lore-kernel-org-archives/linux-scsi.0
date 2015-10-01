From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: req->nr_phys_segments > queue_max_segments (was Re: kernel BUG at drivers/block/virtio_blk.c:172!)
Date: Thu, 1 Oct 2015 09:09:51 -0400
Message-ID: <CAMM=eLcyT2JeWn4NJ6gjsHcRz_D8YcixLix64Spg9cVYFexGyA@mail.gmail.com>
References: <560C87F6.4080708@whissi.de> <20151001114817-mutt-send-email-mst@redhat.com>
 <560CFAD3.1030607@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:34865 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341AbbJANKM (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 09:10:12 -0400
Received: by igbkq10 with SMTP id kq10so14941189igb.0
        for <Linux-scsi@vger.kernel.org>; Thu, 01 Oct 2015 06:10:11 -0700 (PDT)
In-Reply-To: <560CFAD3.1030607@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, "Thomas D." <whissi@whissi.de>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, virtualization@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On Thu, Oct 1, 2015 at 5:20 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 10/01/2015 11:00 AM, Michael S. Tsirkin wrote:
>> On Thu, Oct 01, 2015 at 03:10:14AM +0200, Thomas D. wrote:
>>> Hi,
>>>
>>> I have a virtual machine which fails to boot linux-4.1.8 while mounting
>>> file systems:
>>>
>>>> * Mounting local filesystem ...
>>>> ------------[ cut here ]------------
>>>> kernel BUG at drivers/block/virtio_blk.c:172!
>>>> invalid opcode: 000 [#1] SMP
>>>> Modules linked in: pcspkr psmouse dm_log_userspace virtio_net e1000 fuse nfs lockd grace sunrpc fscache dm_snapshot dm_bufio dm_mirror dm_region_hash dm_log usbhid usb_storage sr_mod cdrom
>>>> CPU: 7 PIDL 2254 Comm: dmcrypt_write Not tainted 4.1.8-gentoo #1
>>>> Hardware name: Red Hat KVM, BIOS seabios-1.7.5-8.el7 04/01/2014
>>>> task: ffff88061fb70000 ti: ffff88061ff30000 task.ti: ffff88061ff30000
>>>> RIP: 0010:[<ffffffffb4557b30>] [<ffffffffb4557b30>] virtio_queue_rq+0x210/0x2b0
>>>> RSP: 0018:ffff88061ff33ba8 EFLAGS: 00010202
>>>> RAX: 00000000000000b1 RBX: ffff88061fb2fc00 RCX: ffff88061ff33c30
>>>> RDX: 0000000000000008 RSI: ffff88061ff33c50 RDI: ffff88061fb2fc00
>>>> RBP: ffff88061ff33bf8 R08: ffff88061eef3540 R09: ffff88061ff33c30
>>>> R10: 0000000000000000 R11: 00000000000000af R12: 0000000000000000
>>>> R13: ffff88061eef3540 R14: ffff88061eef3540 R15: ffff880622c7ca80
>>>> FS:  0000000000000000(0000) GS:ffff88063fdc0000(0000) knlGS:0000000000000000
>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> CR2: 0000000001ffe468 CR3: 00000000bb343000 CR4: 00000000001406e0
>>>> Stack:
>>>>  ffff880622d4c478 0000000000000000 ffff88061ff33bd8 ffff88061fb2f
>>>>  0000000000000001 ffff88061fb2fc00 ffff88061ff33c30 0000000000000
>>>>  ffff88061eef3540 0000000000000000 ffff88061ff33c98 ffffffffb43eb
>>>>
>>>> Call Trace:
>>>>  [<ffffffffb43eb500>] __blk_mq_run_hw_queue+0x1d0/0x370
>>>>  [<ffffffffb43eb315>] blk_mq_run_hw_queue+0x95/0xb0
>>>>  [<ffffffffb43ec804>] blk_mq_flush_plug_list+0x129/0x140
>>>>  [<ffffffffb43e33d8>] blk_finish_plug+0x18/0x50
>>>>  [<ffffffffb45e3bea>] dmcrypt_write+0x1da/0x1f0
>>>>  [<ffffffffb4108c90>] ? wake_up_state+0x20/0x20
>>>>  [<ffffffffb45e3a10>] ? crypt_iv_lmk_dtr+0x60/0x60
>>>>  [<ffffffffb40fb789>] kthread_create_on_node+0x180/0x180
>>>>  [<ffffffffb4705e92>] ret_from_fork+0x42/0x70
>>>>  [<ffffffffb40fb6c0>] ? kthread_create_on_node+0x180/0x180
>>>> Code: 00 0000 41 c7 85 78 01 00 00 08 00 00 00 49 c7 85 80 01 00 00 00 00 00 00 41 89 85 7c 01 00 00 e9 93 fe ff ff 66 0f 1f 44 00 00 <0f> 0b 66 0f 1f 44 00 00 49 8b 87 b0 00 00 00 41 83 e6 ef 4a 8b
>>>> RIP [<ffffffffb4557b30>] virtio_queue_rq+0x210/0x2b0
>>>>  RSP: <ffff88061ff33ba8>
>>>> ---[ end trace 8078357c459d5fc0 ]---
>>
>>
>> So this BUG_ON is from 1cf7e9c68fe84248174e998922b39e508375e7c1.
>>       commit 1cf7e9c68fe84248174e998922b39e508375e7c1
>>       Author: Jens Axboe <axboe@kernel.dk>
>>       Date:   Fri Nov 1 10:52:52 2013 -0600
>>
>>           virtio_blk: blk-mq support
>>
>>
>>       BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>>
>>
>> On probe, we do
>>         /* We can handle whatever the host told us to handle. */
>>         blk_queue_max_segments(q, vblk->sg_elems-2);
>>
>>
>> To debug this,
>> maybe you can print out sg_elems at init time and when this fails,
>> to make sure some kind of memory corruption
>> does not change sg_elems after initialization?
>>
>>
>> Jens, how may we get more segments than blk_queue_max_segments?
>> Is driver expected to validate and drop such requests?
>>
> Whee! I'm not alone anymore!
>
> I have seen similar issues even on non-mq systems; occasionally
> I'm hitting this bug in drivers/scsi/scsi_lib.c:scsi_init_io()
>
>         count = blk_rq_map_sg(req->q, req, sdb->table.sgl);
>         BUG_ON(count > sdb->table.nents);
>
> There are actually two problems here:
> The one is that blk_rq_map_sg() requires a table (ie the last
> argument), but doesn't have any indications on how large the
> table is.
> So one needs to check if the returned number of mapped sg
> elements exceeds the number of elements in the table.
> If so we already _have_ a memory overflow, and the only
> thing we can to is sit in a corner and cry.
> This really would need to be fixed up, eg by adding
> another argument for the table size.
>
> This other problem is that this _really_ shouldn't happen,
> and points to some issue with the block layer in general.
> Which I've been trying to find for several months now,
> but no avail :-(

This particular dm-crypt on virtio-blk issue is fixed with this commit:
http://git.kernel.org/linus/586b286b110e94eb31840ac5afc0c24e0881fe34

Linus pulled this into v4.3-rc3.
