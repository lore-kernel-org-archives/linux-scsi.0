From: Jens Axboe <axboe@kernel.dk>
Subject: Re: virtio_blk - kernel BUG at drivers/virtio/virtio_ring.c:160!
Date: Tue, 21 Oct 2014 14:05:16 -0600
Message-ID: <5446BC7C.9080607@kernel.dk>
References: <20141016151738.GC57207@bfoster.bfoster> <20141017132721.GN16538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61140 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbaJUUFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 16:05:18 -0400
Received: by mail-pa0-f45.google.com with SMTP id lj1so2114987pab.4
        for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2014 13:05:17 -0700 (PDT)
In-Reply-To: <20141017132721.GN16538@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>
Cc: linux-scsi@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>

On 10/17/2014 07:27 AM, Christoph Hellwig wrote:
> On Thu, Oct 16, 2014 at 11:17:39AM -0400, Brian Foster wrote:
>> Hi all,
>>
>> Hopefully this is the right list for this report...
>>
>> I hit the following kernel bug reliably by running xfstests test
>> generic/234 against XFS using 10GB LVM test/scratch volumes on top of a
>> ~100GB virtio_blk block device. The virt block device is file-backed on
>> the host.
> 
> Jens, I thought the segment merging bug was fixed a while ago.  Did we
> manage to not include parts of it for 3.17?

Mings patch went in after 3.17, iirc. Ming?

>> ------------[ cut here ]------------
>> kernel BUG at drivers/virtio/virtio_ring.c:160!
>> invalid opcode: 0000 [#1] SMP
>> Modules linked in: xfs libcrc32c cfg80211 rfkill snd_hda_codec_generic ppdev snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd serio_raw virtio_balloon soundcore virtio_console parport_pc parport i2c_piix4 sunrpc virtio_blk virtio_net qxl drm_kms_helper ttm ata_generic virtio_pci virtio_ring drm virtio pata_acpi
>> CPU: 0 PID: 1442 Comm: xfsaild/dm-3 Not tainted 3.17.0+ #97
>> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
>> task: ffff8800c6483460 ti: ffff880118034000 task.ti: ffff880118034000
>> RIP: 0010:[<ffffffffa00729e5>]  [<ffffffffa00729e5>] virtqueue_add_sgs+0x415/0x430 [virtio_ring]
>> RSP: 0018:ffff880118037678  EFLAGS: 00010002
>> RAX: ffff88011808b000 RBX: ffff8801180377e8 RCX: 0000000000000003
>> RDX: ffffea0003667102 RSI: ffff8801180377d0 RDI: ffff880118037730
>> RBP: ffff8801180376e8 R08: ffff8800d78caf70 R09: 0000000000000020
>> R10: ffff8800c6483460 R11: ffff8800c6484050 R12: ffff8801180377e8
>> R13: 0000000000000002 R14: 0000000000000081 R15: 0000000000000020
>> FS:  0000000000000000(0000) GS:ffff88011ae00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 00007fffa85ff0c0 CR3: 0000000001e14000 CR4: 00000000000006f0
>> Stack:
>>  ffff880118037698 0000000000000304 ffff8800d78caf70 ffff8801180377d0
>>  0000000300000000 ffff88011808b000 ffff880118037730 ffff880000000002
>>  ffff8801180376e8 ffff8800d78caf70 ffff880118037730 0000000000000002
>> Call Trace:
>>  [<ffffffffa006a42f>] __virtblk_add_req+0xdf/0x1c0 [virtio_blk]
>>  [<ffffffffa006a5f2>] ? virtio_queue_rq+0xe2/0x280 [virtio_blk]
>>  [<ffffffffa006a616>] virtio_queue_rq+0x106/0x280 [virtio_blk]
>>  [<ffffffff813d71f1>] __blk_mq_run_hw_queue+0x1d1/0x350
>>  [<ffffffff813d7bb0>] blk_mq_run_hw_queue+0x70/0xa0
>>  [<ffffffff813d8a6d>] blk_mq_insert_requests+0xfd/0x2d0
>>  [<ffffffff813d9a2b>] blk_mq_flush_plug_list+0x13b/0x160
>>  [<ffffffff813cd5c1>] blk_flush_plug_list+0xc1/0x240
>>  [<ffffffff813d8f2a>] blk_sq_make_request+0x2ea/0x5d0
>>  [<ffffffff81656395>] ? dm_get_live_table+0x5/0xb0
>>  [<ffffffff813c7760>] generic_make_request+0xe0/0x130
>>  [<ffffffff813c7828>] submit_bio+0x78/0x160
>>  [<ffffffffa02ffcc6>] _xfs_buf_ioapply+0x2e6/0x420 [xfs]
>>  [<ffffffffa0300328>] ? __xfs_buf_delwri_submit+0x1d8/0x5b0 [xfs]
>>  [<ffffffffa02fff22>] xfs_buf_submit+0xd2/0x300 [xfs]
>>  [<ffffffffa0300328>] __xfs_buf_delwri_submit+0x1d8/0x5b0 [xfs]
>>  [<ffffffffa03021af>] ? xfs_buf_delwri_submit_nowait+0x2f/0x50 [xfs]
>>  [<ffffffffa03021af>] xfs_buf_delwri_submit_nowait+0x2f/0x50 [xfs]
>>  [<ffffffffa0340635>] xfsaild+0x275/0xe30 [xfs]
>>  [<ffffffffa03403c0>] ? xfs_trans_ail_cursor_first+0xb0/0xb0 [xfs]
>>  [<ffffffff810cda79>] kthread+0xf9/0x110
>>  [<ffffffff810cd980>] ? kthread_create_on_node+0x250/0x250
>>  [<ffffffff8182717c>] ret_from_fork+0x7c/0xb0
>>  [<ffffffff810cd980>] ? kthread_create_on_node+0x250/0x250
>> Code: ff 0f 1f 44 00 00 eb 84 48 8b 4d b8 8b 55 b0 48 c7 c6 19 42 07 a0 48 c7 c7 78 50 07 a0 31 c0 31 db e8 10 5d 3b e1 e9 4d fd ff ff <0f> 0b bb fb ff ff ff e9 41 fd ff ff 66 66 66 66 66 66 2e 0f 1f
>> RIP  [<ffffffffa00729e5>] virtqueue_add_sgs+0x415/0x430 [virtio_ring]
>>  RSP <ffff880118037678>
>> ---[ end trace 823f74f9a11abe26 ]---
>>
>> This occurs on the latest tot kernel (commit 0429fbc0bdc2) but appears
>> to originate sometime during the 3.16 development cycle. A bisect lands
>> on the following commit:
>>
>> 05f1dd53 block: add queue flag for disabling SG merging
>>
>> To corroborate that, the appended diff appears to work around the
>> problem for me (included as a data point, not a fix, as I'm not familiar
>> with the block layer). Let me know if I can provide any more info,
>> thanks!
>>
>> Brian
>>
>> ---8<---
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 0a58140..5861bd72 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -634,7 +634,7 @@ static int virtblk_probe(struct virtio_device *vdev)
>>  	vblk->tag_set.ops = &virtio_mq_ops;
>>  	vblk->tag_set.queue_depth = virtblk_queue_depth;
>>  	vblk->tag_set.numa_node = NUMA_NO_NODE;
>> -	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
>> +	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE|BLK_MQ_F_SG_MERGE;
>>  	vblk->tag_set.cmd_size =
>>  		sizeof(struct virtblk_req) +
>>  		sizeof(struct scatterlist) * sg_elems;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> 


-- 
Jens Axboe

