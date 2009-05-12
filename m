From: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [2.6.30-rc2] CD-R: wodim intermittent failures: [sr0] Add. Sense:
 Logical block address out of range, sector 0
Date: Tue, 12 May 2009 17:23:57 -0600
Message-ID: <4A0A050D.4000804@gmail.com>
References: <20090421015234.GA7014@hexapodia.org> <20090422144904.407df635.akpm@linux-foundation.org> <49F00EBB.7040504@gmail.com> <20090423070713.GF19113@hexapodia.org> <20090512215256.GA22095@hexapodia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090512215256.GA22095@hexapodia.org>
Sender: linux-ide-owner@vger.kernel.org
To: Andy Isaacson <adi@hexapodia.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Andy Isaacson wrote:
> On Thu, Apr 23, 2009 at 12:07:13AM -0700, Andy Isaacson wrote:
>> On Thu, Apr 23, 2009 at 12:46:19AM -0600, Robert Hancock wrote:
>>>> Oh well, let's tentatively assume that we have a post-2.6.29 regression
>>>> in the libata ahci driver.
>>> I tend to doubt it's a problem in ahci itself, I would guess it's higher 
>>> up the stack. Or could be that it's not a kernel bug, just some change 
>>> in timing that triggers the problem.
>>>
>>> What's supposed to stop udev/hal from poking at the drive while wodim is 
>>> writing to the disc, anyway?
>> wodim opens O_EXCL, and it does occasionally complain about not being
>> able to open, then sleeping and retrying.
> 
> I just saw this again with 2.6.30-rc5-00096-ga4d7749 and got some nice
> stack traces, for both hald-addon-storage and wodim:
> 
> [ 2041.201084] INFO: task hald-addon-stor:3804 blocked for more than 120 seconds.
> [ 2041.201108]  ffff8801145056f8 0000000000000086 ffff880118c66120 0000000000000086
> [ 2041.201118]  00000000000110c0 000000000000c848 ffff8801144b2cc0 ffff8800d8008000
> [ 2041.201127]  ffff8801144b3060 0000000118ddd460 ffff8801145056b8 ffffffff81296405
> [ 2041.201135] Call Trace:
> [ 2041.201153]  [<ffffffff81296405>] ? scsi_setup_blk_pc_cmnd+0x145/0x180
> [ 2041.201162]  [<ffffffff8128f32c>] ? scsi_pool_alloc_command+0x2c/0x80
> [ 2041.201171]  [<ffffffff812a70ad>] ? sr_prep_fn+0x4d/0x5b0
> [ 2041.201180]  [<ffffffff81413ae9>] schedule+0x9/0x20
> [ 2041.201187]  [<ffffffff81413fa5>] schedule_timeout+0x145/0x180
> [ 2041.201196]  [<ffffffff811d32a7>] ? kobject_put+0x27/0x60
> [ 2041.201203]  [<ffffffff81413d4d>] wait_for_common+0x14d/0x180
> [ 2041.201214]  [<ffffffff81038e30>] ? default_wake_function+0x0/0x10
> [ 2041.201224]  [<ffffffff811c02b3>] ? __generic_unplug_device+0x33/0x40
> [ 2041.201231]  [<ffffffff81413e18>] wait_for_completion+0x18/0x20
> [ 2041.201239]  [<ffffffff811c4cd5>] blk_execute_rq+0x65/0xb0
> [ 2041.201246]  [<ffffffff811c0fd0>] ? freed_request+0x30/0x60
> [ 2041.201255]  [<ffffffff81296f22>] scsi_execute+0xf2/0x150
> [ 2041.201262]  [<ffffffff812971a8>] scsi_execute_req+0xd8/0x150
> [ 2041.201271]  [<ffffffff812a6796>] sr_test_unit_ready+0x66/0x100
> [ 2041.201280]  [<ffffffff810d6e49>] ? kmem_cache_alloc+0x79/0x110
> [ 2041.201288]  [<ffffffff812a76ca>] sr_media_change+0xba/0x2f0
> [ 2041.201298]  [<ffffffff8105d6dc>] ? lock_hrtimer_base+0x2c/0x60
> [ 2041.201308]  [<ffffffff8130f3b8>] media_changed+0x68/0xb0
> [ 2041.201316]  [<ffffffff8130f437>] cdrom_media_changed+0x37/0x40
> [ 2041.201324]  [<ffffffff812a68a4>] sr_block_media_changed+0x14/0x20
> [ 2041.201333]  [<ffffffff811090fe>] check_disk_change+0x2e/0x70
> [ 2041.201341]  [<ffffffff81313ddb>] cdrom_open+0x1ab/0xb60
> [ 2041.201349]  [<ffffffff8105a566>] ? remove_wait_queue+0x46/0x60
> [ 2041.201357]  [<ffffffff810ee496>] ? poll_freewait+0x46/0xb0
> [ 2041.201365]  [<ffffffff810ee8e9>] ? do_sys_poll+0x3e9/0x4c0
> [ 2041.201372]  [<ffffffff810ef340>] ? __pollwait+0x0/0x100
> [ 2041.201380]  [<ffffffff810ef440>] ? pollwake+0x0/0x50
> [ 2041.201387]  [<ffffffff811d361a>] ? kobject_get+0x1a/0x30
> [ 2041.201394]  [<ffffffff811c70bf>] ? get_disk+0x2f/0x90
> [ 2041.201401]  [<ffffffff811d361a>] ? kobject_get+0x1a/0x30
> [ 2041.201409]  [<ffffffff812a6a6a>] sr_block_open+0x7a/0xd0
> [ 2041.201417]  [<ffffffff8110a24e>] __blkdev_get+0x21e/0x3a0
> [ 2041.201426]  [<ffffffff810f761a>] ? mntput_no_expire+0x2a/0x140
> [ 2041.201433]  [<ffffffff8110a3db>] blkdev_get+0xb/0x10
> [ 2041.201440]  [<ffffffff8110a44c>] blkdev_open+0x6c/0xc0
> [ 2041.201449]  [<ffffffff810dc5d6>] __dentry_open+0xe6/0x2e0
> [ 2041.201456]  [<ffffffff8110a3e0>] ? blkdev_open+0x0/0xc0
> [ 2041.201463]  [<ffffffff810dc8d7>] nameidata_to_filp+0x57/0x70
> [ 2041.201471]  [<ffffffff810eb6f2>] do_filp_open+0x2a2/0x9d0
> [ 2041.201479]  [<ffffffff810cb5ad>] ? free_pages_and_swap_cache+0x8d/0xb0
> [ 2041.201489]  [<ffffffff810c2640>] ? unmap_region+0x140/0x160
> [ 2041.201496]  [<ffffffff810f5c8a>] ? alloc_fd+0x4a/0x140
> [ 2041.201503]  [<ffffffff810dc41b>] do_sys_open+0x7b/0x100
> [ 2041.201510]  [<ffffffff810dc4cb>] sys_open+0x1b/0x20
> [ 2041.201519]  [<ffffffff8100bf2b>] system_call_fastpath+0x16/0x1b
> [ 2041.201542] INFO: task wodim:6398 blocked for more than 120 seconds.
> [ 2041.201562] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 2041.201568] wodim         D 0000000000000000     0  6398   5313
> [ 2041.201575]  ffff8800d805d868 0000000000000082 ffff880118ed40d0 0000000000000000
> [ 2041.201584]  00000000000110c0 000000000000c848 ffff8800d4164320 ffff88011b884320
> [ 2041.201593]  ffff8800d41646c0 0000000118ed5e48 000000010005d5b2 ffff880118ed4000
> [ 2041.201602] Call Trace:
> [ 2041.201610]  [<ffffffff81413ae9>] schedule+0x9/0x20
> [ 2041.201617]  [<ffffffff81413fa5>] schedule_timeout+0x145/0x180
> [ 2041.201625]  [<ffffffff81295590>] ? scsi_request_fn+0xd0/0x570
> [ 2041.201632]  [<ffffffff81413d4d>] wait_for_common+0x14d/0x180
> [ 2041.201641]  [<ffffffff81038e30>] ? default_wake_function+0x0/0x10
> [ 2041.201649]  [<ffffffff811c029a>] ? __generic_unplug_device+0x1a/0x40
> [ 2041.201656]  [<ffffffff81413e18>] wait_for_completion+0x18/0x20
> [ 2041.201663]  [<ffffffff811c4cd5>] blk_execute_rq+0x65/0xb0
> [ 2041.201669]  [<ffffffff811c4896>] ? blk_rq_append_bio+0x26/0x70
> [ 2041.201676]  [<ffffffff811c4a8a>] ? blk_rq_map_user+0x1aa/0x2a0
> [ 2041.201684]  [<ffffffff8104bc4e>] ? capable+0xe/0x50
> [ 2041.201691]  [<ffffffff811c8734>] sg_io+0x1d4/0x400
> [ 2041.201699]  [<ffffffff810a8cd2>] ? mempool_free_slab+0x12/0x20
> [ 2041.201707]  [<ffffffff811c9015>] scsi_cmd_ioctl+0x2e5/0x4d0
> [ 2041.201715]  [<ffffffff81038c48>] ? try_to_wake_up+0x148/0x330
> [ 2041.201723]  [<ffffffff81038e3d>] ? default_wake_function+0xd/0x10
> [ 2041.201732]  [<ffffffff81312add>] cdrom_ioctl+0x3d/0x1050
> [ 2041.201741]  [<ffffffff8124d1f2>] ? n_tty_receive_buf+0x772/0x11e0
> [ 2041.201750]  [<ffffffff812a690b>] sr_block_ioctl+0x5b/0xb0
> [ 2041.201757]  [<ffffffff811c606e>] __blkdev_driver_ioctl+0x8e/0xa0
> [ 2041.201765]  [<ffffffff811c616d>] blkdev_ioctl+0xad/0x9e0
> [ 2041.201772]  [<ffffffff810a6df4>] ? filemap_fault+0x144/0x450
> [ 2041.201778]  [<ffffffff810a68f2>] ? unlock_page+0x22/0x30
> [ 2041.201786]  [<ffffffff810bc2bd>] ? __do_fault+0x42d/0x4e0
> [ 2041.201795]  [<ffffffff81108eb5>] block_ioctl+0x35/0x40
> [ 2041.201802]  [<ffffffff810ed0c1>] vfs_ioctl+0x31/0xa0
> [ 2041.201809]  [<ffffffff810ed1ba>] do_vfs_ioctl+0x8a/0x570
> [ 2041.201816]  [<ffffffff811d77b1>] ? __up_read+0x91/0xb0
> [ 2041.201824]  [<ffffffff8105dff9>] ? up_read+0x9/0x10
> [ 2041.201831]  [<ffffffff810ed739>] sys_ioctl+0x99/0xa0
> [ 2041.201840]  [<ffffffff8100bf2b>] system_call_fastpath+0x16/0x1b
> 
> Looking at hald/linux/addons/addon-storage.c it does appear to
> open(O_EXCL) as well, so perhaps the O_EXCL multiple-open logic broke
> recently?
> 
> Complete dmesg, kconfig, and so on at
> 
> http://web.hexapodia.org/~adi/sysinfo/1242164411_cvpe4300_2.6.30-rc5-dmar-00096-ga4d7749/
> 
> -andy

I'm not sure how this is supposed to work. The only place I can see any 
O_EXCL handling is in the sg driver. But if you access the sr device 
directly, it doesn't seem like that would have any effect.

CCing linux-scsi. Could be there's a bad user-space assumption here, or 
something.
