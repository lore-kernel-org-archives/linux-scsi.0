From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [PATCH] scsi_debug [was: scsi_debug issues]
Date: Mon, 18 Oct 2004 11:37:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041018183747.GA3530@us.ibm.com>
References: <20041015190154.GA3073@us.ibm.com> <4170C505.3000805@torque.net> <1097932370.1962.4.camel@mulgrave> <4173C8DB.8030009@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:52160 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S267333AbUJRShZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 14:37:25 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id i9IIbOEx320032
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2004 14:37:24 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id i9IIbOQu376578
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2004 12:37:24 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id i9IIbNcQ017884
	for <linux-scsi@vger.kernel.org>; Mon, 18 Oct 2004 12:37:24 -0600
Content-Disposition: inline
In-Reply-To: <4173C8DB.8030009@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@infradead.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 18, 2004 at 11:44:59PM +1000, Douglas Gilbert wrote:
> James Bottomley wrote:
> >On Sat, 2004-10-16 at 01:51, Douglas Gilbert wrote:
> >
> >>So this problem seems related to highmem.

<snip>

> The above required a fair few changes to scsi_debug.
> Attached is a patch that rolls "kmap" changes with
> patches I have sent recently for scsi_debug.
> Attachment is gzipped (due to size) and applies against
> lk 2.6.8.1 -> lk 2.6.9-rc4 .
> 
> Nishanth, could you test this with highmem?

Doug,

I ran 2.6.9-rc4 with your patch applied and had several dump_stack()s
occur (complaining about sleeping in an invalid context) and a final
panic during mkfs :) I think something is still wrong... ;) Output is
below and attached.

-Nish

scsi2 : scsi_debug, version 1.74 [20041018], dev_size_mb=8, opts=0x0
  Vendor: Linux     Model: scsi_debug        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:<3>Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c4792>] fill_from_dev_buffer+0x102/0x180 [scsi_debug]
 [<f88c5546>] resp_read+0xc6/0x100 [scsi_debug]
 [<f88c42c4>] scsi_debug_queuecommand+0x2c4/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c0159202>] block_sync_page+0x42/0x50
 [<c01349f6>] __lock_page+0xf6/0x100
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c0136247>] read_cache_page+0x127/0x190
 [<c018a352>] read_dev_sector+0x42/0xa0
 [<c015c0d0>] blkdev_readpage+0x0/0x20
 [<c018a7f1>] msdos_partition+0x51/0x320
 [<c011aaeb>] vprintk+0x12b/0x180
 [<c0189c56>] check_partition+0xd6/0x150
 [<c018a10d>] register_disk+0xdd/0x190
 [<c02255d0>] blk_register_region+0x40/0x50
 [<c022568c>] add_disk+0x4c/0x60
 [<c0225610>] exact_match+0x0/0x10
 [<c0225620>] exact_lock+0x0/0x20
 [<c0265e0f>] sd_probe+0x24f/0x3a0
 [<c021cc4f>] bus_match+0x3f/0x70
 [<c021cccf>] device_attach+0x4f/0xa0
 [<c01ee93a>] kobject_get+0x1a/0x30
 [<c021d00b>] bus_add_device+0x7b/0xd0
 [<c021bc33>] device_add+0x93/0x120
 [<c0243e52>] scsi_sysfs_add_sdev+0x52/0x200
 [<f88c5880>] scsi_debug_slave_configure+0x0/0xa0 [scsi_debug]
 [<c0242674>] scsi_add_lun+0x2f4/0x3b0
 [<c0242809>] scsi_probe_and_add_lun+0xd9/0x240
 [<c02430b8>] scsi_scan_target+0xa8/0x130
 [<c02431c9>] scsi_scan_channel+0x89/0xa0
 [<c02432e1>] scsi_scan_host_selected+0x101/0x140
 [<c0243350>] scsi_scan_host+0x30/0x40
 [<f88c6d8d>] sdebug_driver_probe+0x9d/0xd0 [scsi_debug]
 [<c021cc4f>] bus_match+0x3f/0x70
 [<c021cccf>] device_attach+0x4f/0xa0
 [<c01ee93a>] kobject_get+0x1a/0x30
 [<c021d00b>] bus_add_device+0x7b/0xd0
 [<c021bc33>] device_add+0x93/0x120
 [<f88c6bbf>] sdebug_add_adapter+0x12f/0x1f0 [scsi_debug]
 [<f88cf36c>] scsi_debug_init+0x16c/0x1d2 [scsi_debug]
 [<c0132f59>] sys_init_module+0x199/0x230
 [<c01060cf>] syscall_call+0x7/0xb
 unknown partition table
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
Attached scsi generic sg3 at scsi2, channel 0, id 0, lun 0,  type 0
Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c48ab>] fetch_to_dev_buffer+0x9b/0x140 [scsi_debug]
 [<c01183e0>] autoremove_wake_function+0x0/0x60
 [<f88c563d>] resp_write+0xbd/0x100 [scsi_debug]
 [<f88c44a0>] scsi_debug_queuecommand+0x4a0/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221da0>] blk_unplug_work+0x10/0x20
 [<c012ab79>] worker_thread+0x1b9/0x260
 [<c0221d90>] blk_unplug_work+0x0/0x20
 [<c0116b00>] default_wake_function+0x0/0x20
 [<c0116b00>] default_wake_function+0x0/0x20
 [<c012a9c0>] worker_thread+0x0/0x260
 [<c012edba>] kthread+0xba/0xc0
 [<c012ed00>] kthread+0x0/0xc0
 [<c0104145>] kernel_thread_helper+0x5/0x10
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:<3>Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c4792>] fill_from_dev_buffer+0x102/0x180 [scsi_debug]
 [<f88c5546>] resp_read+0xc6/0x100 [scsi_debug]
 [<f88c42c4>] scsi_debug_queuecommand+0x2c4/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c0159202>] block_sync_page+0x42/0x50
 [<c01349f6>] __lock_page+0xf6/0x100
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c0136247>] read_cache_page+0x127/0x190
 [<c018a352>] read_dev_sector+0x42/0xa0
 [<c015c0d0>] blkdev_readpage+0x0/0x20
 [<c018a7f1>] msdos_partition+0x51/0x320
 [<c011aaeb>] vprintk+0x12b/0x180
 [<c0189c56>] check_partition+0xd6/0x150
 [<c018a23b>] rescan_partitions+0x7b/0x150
 [<c02fcdf6>] schedule_timeout+0x76/0xc0
 [<c0224b5e>] blkdev_reread_part+0x7e/0x90
 [<c01671cb>] sys_ioctl+0x10b/0x2a0
 [<c01060cf>] syscall_call+0x7/0xb
 sdc1
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:<3>Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c4792>] fill_from_dev_buffer+0x102/0x180 [scsi_debug]
 [<f88c5546>] resp_read+0xc6/0x100 [scsi_debug]
 [<f88c42c4>] scsi_debug_queuecommand+0x2c4/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c0159202>] block_sync_page+0x42/0x50
 [<c01349f6>] __lock_page+0xf6/0x100
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c0136247>] read_cache_page+0x127/0x190
 [<c018a352>] read_dev_sector+0x42/0xa0
 [<c015c0d0>] blkdev_readpage+0x0/0x20
 [<c018a7f1>] msdos_partition+0x51/0x320
 [<c011aaeb>] vprintk+0x12b/0x180
 [<c0189c56>] check_partition+0xd6/0x150
 [<c018a23b>] rescan_partitions+0x7b/0x150
 [<c02fcdf6>] schedule_timeout+0x76/0xc0
 [<c0224b5e>] blkdev_reread_part+0x7e/0x90
 [<c01671cb>] sys_ioctl+0x10b/0x2a0
 [<c01060cf>] syscall_call+0x7/0xb
 sdc1
Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c4792>] fill_from_dev_buffer+0x102/0x180 [scsi_debug]
 [<f88c5546>] resp_read+0xc6/0x100 [scsi_debug]
 [<f88c42c4>] scsi_debug_queuecommand+0x2c4/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c015527f>] sync_buffer+0x3f/0x50
 [<c0155408>] __wait_on_buffer+0xa8/0xb0
 [<c0155200>] bh_wake_function+0x0/0x40
 [<c0155200>] bh_wake_function+0x0/0x40
 [<c0157706>] __block_prepare_write+0x156/0x440
 [<c01ef2cf>] radix_tree_node_alloc+0x1f/0x70
 [<c0158224>] block_prepare_write+0x34/0x50
 [<c015bf00>] blkdev_get_block+0x0/0x80
 [<c013675f>] generic_file_buffered_write+0x1cf/0x600
 [<c015bf00>] blkdev_get_block+0x0/0x80
 [<c016f540>] inode_update_time+0xd0/0xe0
 [<c0136e1a>] generic_file_aio_write_nolock+0x28a/0x4c0
 [<c01370f3>] generic_file_write_nolock+0xa3/0xc0
 [<c011328c>] do_page_fault+0x1cc/0x5f1
 [<c01183e0>] autoremove_wake_function+0x0/0x60
 [<c015d038>] blkdev_file_write+0x38/0x40
 [<c01540d8>] vfs_write+0xb8/0x130
 [<c0154221>] sys_write+0x51/0x80
 [<c01060cf>] syscall_call+0x7/0xb
------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:14!
invalid operand: 0000 [#1]
SMP 
Modules linked in: scsi_debug
CPU:    1
EIP:    0060:[<c0114784>]    Not tainted VLI
EFLAGS: 00010006   (2.6.9-rc4) 
EIP is at kunmap+0x14/0x30
eax: f7f82000   ebx: 00001000   ecx: 00000000   edx: c16eeb00
esi: f7759000   edi: f93ea000   ebp: f75e1c00   esp: f7f83bf4
ds: 007b   es: 007b   ss: 0068
Process mkfs.ext2 (pid: 1573, threadinfo=f7f82000 task=f7694150)
Stack: f88c4906 c16eeb00 f7f83bfc f7f83bfc 00000000 00000000 00000000 00000006 
       00000000 f93e9000 0001c000 f88c563d f7e015c0 f93e9000 0001c000 00004000 
       00000000 000000e0 f7e01614 00000000 f88c44a0 f7e015c0 00000000 00003f20 
Call Trace:
 [<f88c4906>] fetch_to_dev_buffer+0xf6/0x140 [scsi_debug]
 [<f88c563d>] resp_write+0xbd/0x100 [scsi_debug]
 [<f88c44a0>] scsi_debug_queuecommand+0x4a0/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c023b2b3>] scsi_put_command+0x73/0xa0
 [<c0221e7d>] blk_run_queue+0x2d/0x50
 [<c02405fd>] scsi_end_request+0xdd/0xf0
 [<c024092c>] scsi_io_completion+0x15c/0x4d0
 [<c013d970>] cache_alloc_refill+0x150/0x230
 [<c0264ab8>] sd_rw_intr+0x88/0x310
 [<c023deba>] scsi_delete_timer+0x1a/0x70
 [<c023bd11>] scsi_finish_command+0x81/0xe0
 [<c023bc0e>] scsi_softirq+0xbe/0xf0
 [<c011f6ba>] __do_softirq+0xba/0xd0
 [<c011f6fd>] do_softirq+0x2d/0x30
 [<c01106fd>] smp_apic_timer_interrupt+0x8d/0x100
 [<c02fd3b5>] _spin_unlock_irqrestore+0x5/0x10
 [<c0106abe>] apic_timer_interrupt+0x1a/0x20
 [<c02fd3b5>] _spin_unlock_irqrestore+0x5/0x10
 [<c023b877>] scsi_dispatch_cmd+0x187/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c0159202>] block_sync_page+0x42/0x50
 [<c0134875>] wait_on_page_bit+0xe5/0xf0
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c013437c>] wait_on_page_writeback_range+0x10c/0x150
 [<c0134541>] filemap_fdatawait+0x71/0x80
 [<c0155599>] sync_blockdev+0x39/0x50
 [<c0155aa7>] sys_fsync+0xb7/0xf0
 [<c01060cf>] syscall_call+0x7/0xb
Code: d8 8b 5c 24 08 83 c4 0c e9 6a d5 02 00 8d 76 00 8d bc 27 00 00 00 00 b8 00 e0 ff ff 8b 54 24 04 21 e0 f7 40 14 00 ff ff 00 74 08 <0f> 0b 0e 00 82 d4 30 c0 3b 15 34 cb 44 c0 73 01 c3 89 d0 e9 e4 
 <0>Kernel panic - not syncing: Fatal exception in interrupt

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="output.file"

scsi2 : scsi_debug, version 1.74 [20041018], dev_size_mb=8, opts=0x0
  Vendor: Linux     Model: scsi_debug        Rev: 0004
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:<3>Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c4792>] fill_from_dev_buffer+0x102/0x180 [scsi_debug]
 [<f88c5546>] resp_read+0xc6/0x100 [scsi_debug]
 [<f88c42c4>] scsi_debug_queuecommand+0x2c4/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c0159202>] block_sync_page+0x42/0x50
 [<c01349f6>] __lock_page+0xf6/0x100
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c0136247>] read_cache_page+0x127/0x190
 [<c018a352>] read_dev_sector+0x42/0xa0
 [<c015c0d0>] blkdev_readpage+0x0/0x20
 [<c018a7f1>] msdos_partition+0x51/0x320
 [<c011aaeb>] vprintk+0x12b/0x180
 [<c0189c56>] check_partition+0xd6/0x150
 [<c018a10d>] register_disk+0xdd/0x190
 [<c02255d0>] blk_register_region+0x40/0x50
 [<c022568c>] add_disk+0x4c/0x60
 [<c0225610>] exact_match+0x0/0x10
 [<c0225620>] exact_lock+0x0/0x20
 [<c0265e0f>] sd_probe+0x24f/0x3a0
 [<c021cc4f>] bus_match+0x3f/0x70
 [<c021cccf>] device_attach+0x4f/0xa0
 [<c01ee93a>] kobject_get+0x1a/0x30
 [<c021d00b>] bus_add_device+0x7b/0xd0
 [<c021bc33>] device_add+0x93/0x120
 [<c0243e52>] scsi_sysfs_add_sdev+0x52/0x200
 [<f88c5880>] scsi_debug_slave_configure+0x0/0xa0 [scsi_debug]
 [<c0242674>] scsi_add_lun+0x2f4/0x3b0
 [<c0242809>] scsi_probe_and_add_lun+0xd9/0x240
 [<c02430b8>] scsi_scan_target+0xa8/0x130
 [<c02431c9>] scsi_scan_channel+0x89/0xa0
 [<c02432e1>] scsi_scan_host_selected+0x101/0x140
 [<c0243350>] scsi_scan_host+0x30/0x40
 [<f88c6d8d>] sdebug_driver_probe+0x9d/0xd0 [scsi_debug]
 [<c021cc4f>] bus_match+0x3f/0x70
 [<c021cccf>] device_attach+0x4f/0xa0
 [<c01ee93a>] kobject_get+0x1a/0x30
 [<c021d00b>] bus_add_device+0x7b/0xd0
 [<c021bc33>] device_add+0x93/0x120
 [<f88c6bbf>] sdebug_add_adapter+0x12f/0x1f0 [scsi_debug]
 [<f88cf36c>] scsi_debug_init+0x16c/0x1d2 [scsi_debug]
 [<c0132f59>] sys_init_module+0x199/0x230
 [<c01060cf>] syscall_call+0x7/0xb
 unknown partition table
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
Attached scsi generic sg3 at scsi2, channel 0, id 0, lun 0,  type 0
Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c48ab>] fetch_to_dev_buffer+0x9b/0x140 [scsi_debug]
 [<c01183e0>] autoremove_wake_function+0x0/0x60
 [<f88c563d>] resp_write+0xbd/0x100 [scsi_debug]
 [<f88c44a0>] scsi_debug_queuecommand+0x4a0/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221da0>] blk_unplug_work+0x10/0x20
 [<c012ab79>] worker_thread+0x1b9/0x260
 [<c0221d90>] blk_unplug_work+0x0/0x20
 [<c0116b00>] default_wake_function+0x0/0x20
 [<c0116b00>] default_wake_function+0x0/0x20
 [<c012a9c0>] worker_thread+0x0/0x260
 [<c012edba>] kthread+0xba/0xc0
 [<c012ed00>] kthread+0x0/0xc0
 [<c0104145>] kernel_thread_helper+0x5/0x10
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:<3>Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c4792>] fill_from_dev_buffer+0x102/0x180 [scsi_debug]
 [<f88c5546>] resp_read+0xc6/0x100 [scsi_debug]
 [<f88c42c4>] scsi_debug_queuecommand+0x2c4/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c0159202>] block_sync_page+0x42/0x50
 [<c01349f6>] __lock_page+0xf6/0x100
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c0136247>] read_cache_page+0x127/0x190
 [<c018a352>] read_dev_sector+0x42/0xa0
 [<c015c0d0>] blkdev_readpage+0x0/0x20
 [<c018a7f1>] msdos_partition+0x51/0x320
 [<c011aaeb>] vprintk+0x12b/0x180
 [<c0189c56>] check_partition+0xd6/0x150
 [<c018a23b>] rescan_partitions+0x7b/0x150
 [<c02fcdf6>] schedule_timeout+0x76/0xc0
 [<c0224b5e>] blkdev_reread_part+0x7e/0x90
 [<c01671cb>] sys_ioctl+0x10b/0x2a0
 [<c01060cf>] syscall_call+0x7/0xb
 sdc1
SCSI device sdc: 16384 512-byte hdwr sectors (8 MB)
SCSI device sdc: drive cache: write back
 sdc:<3>Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c4792>] fill_from_dev_buffer+0x102/0x180 [scsi_debug]
 [<f88c5546>] resp_read+0xc6/0x100 [scsi_debug]
 [<f88c42c4>] scsi_debug_queuecommand+0x2c4/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c0159202>] block_sync_page+0x42/0x50
 [<c01349f6>] __lock_page+0xf6/0x100
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c0136247>] read_cache_page+0x127/0x190
 [<c018a352>] read_dev_sector+0x42/0xa0
 [<c015c0d0>] blkdev_readpage+0x0/0x20
 [<c018a7f1>] msdos_partition+0x51/0x320
 [<c011aaeb>] vprintk+0x12b/0x180
 [<c0189c56>] check_partition+0xd6/0x150
 [<c018a23b>] rescan_partitions+0x7b/0x150
 [<c02fcdf6>] schedule_timeout+0x76/0xc0
 [<c0224b5e>] blkdev_reread_part+0x7e/0x90
 [<c01671cb>] sys_ioctl+0x10b/0x2a0
 [<c01060cf>] syscall_call+0x7/0xb
 sdc1
Debug: sleeping function called from invalid context at arch/i386/mm/highmem.c:5
in_atomic():0, irqs_disabled():1
 [<c0117f88>] __might_sleep+0x98/0xa0
 [<c0114740>] kmap+0x20/0x50
 [<f88c4792>] fill_from_dev_buffer+0x102/0x180 [scsi_debug]
 [<f88c5546>] resp_read+0xc6/0x100 [scsi_debug]
 [<f88c42c4>] scsi_debug_queuecommand+0x2c4/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c015527f>] sync_buffer+0x3f/0x50
 [<c0155408>] __wait_on_buffer+0xa8/0xb0
 [<c0155200>] bh_wake_function+0x0/0x40
 [<c0155200>] bh_wake_function+0x0/0x40
 [<c0157706>] __block_prepare_write+0x156/0x440
 [<c01ef2cf>] radix_tree_node_alloc+0x1f/0x70
 [<c0158224>] block_prepare_write+0x34/0x50
 [<c015bf00>] blkdev_get_block+0x0/0x80
 [<c013675f>] generic_file_buffered_write+0x1cf/0x600
 [<c015bf00>] blkdev_get_block+0x0/0x80
 [<c016f540>] inode_update_time+0xd0/0xe0
 [<c0136e1a>] generic_file_aio_write_nolock+0x28a/0x4c0
 [<c01370f3>] generic_file_write_nolock+0xa3/0xc0
 [<c011328c>] do_page_fault+0x1cc/0x5f1
 [<c01183e0>] autoremove_wake_function+0x0/0x60
 [<c015d038>] blkdev_file_write+0x38/0x40
 [<c01540d8>] vfs_write+0xb8/0x130
 [<c0154221>] sys_write+0x51/0x80
 [<c01060cf>] syscall_call+0x7/0xb
------------[ cut here ]------------
kernel BUG at arch/i386/mm/highmem.c:14!
invalid operand: 0000 [#1]
SMP 
Modules linked in: scsi_debug
CPU:    1
EIP:    0060:[<c0114784>]    Not tainted VLI
EFLAGS: 00010006   (2.6.9-rc4) 
EIP is at kunmap+0x14/0x30
eax: f7f82000   ebx: 00001000   ecx: 00000000   edx: c16eeb00
esi: f7759000   edi: f93ea000   ebp: f75e1c00   esp: f7f83bf4
ds: 007b   es: 007b   ss: 0068
Process mkfs.ext2 (pid: 1573, threadinfo=f7f82000 task=f7694150)
Stack: f88c4906 c16eeb00 f7f83bfc f7f83bfc 00000000 00000000 00000000 00000006 
       00000000 f93e9000 0001c000 f88c563d f7e015c0 f93e9000 0001c000 00004000 
       00000000 000000e0 f7e01614 00000000 f88c44a0 f7e015c0 00000000 00003f20 
Call Trace:
 [<f88c4906>] fetch_to_dev_buffer+0xf6/0x140 [scsi_debug]
 [<f88c563d>] resp_write+0xbd/0x100 [scsi_debug]
 [<f88c44a0>] scsi_debug_queuecommand+0x4a0/0x600 [scsi_debug]
 [<c023b86b>] scsi_dispatch_cmd+0x17b/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c023b2b3>] scsi_put_command+0x73/0xa0
 [<c0221e7d>] blk_run_queue+0x2d/0x50
 [<c02405fd>] scsi_end_request+0xdd/0xf0
 [<c024092c>] scsi_io_completion+0x15c/0x4d0
 [<c013d970>] cache_alloc_refill+0x150/0x230
 [<c0264ab8>] sd_rw_intr+0x88/0x310
 [<c023deba>] scsi_delete_timer+0x1a/0x70
 [<c023bd11>] scsi_finish_command+0x81/0xe0
 [<c023bc0e>] scsi_softirq+0xbe/0xf0
 [<c011f6ba>] __do_softirq+0xba/0xd0
 [<c011f6fd>] do_softirq+0x2d/0x30
 [<c01106fd>] smp_apic_timer_interrupt+0x8d/0x100
 [<c02fd3b5>] _spin_unlock_irqrestore+0x5/0x10
 [<c0106abe>] apic_timer_interrupt+0x1a/0x20
 [<c02fd3b5>] _spin_unlock_irqrestore+0x5/0x10
 [<c023b877>] scsi_dispatch_cmd+0x187/0x240
 [<c023bab0>] scsi_done+0x0/0x30
 [<c023df10>] scsi_times_out+0x0/0xc0
 [<c0241243>] scsi_request_fn+0x203/0x3e0
 [<c021ff2e>] elv_next_request+0x4e/0x110
 [<c0221d21>] __generic_unplug_device+0x41/0x50
 [<c0221d4e>] generic_unplug_device+0x1e/0x30
 [<c0221d7f>] blk_backing_dev_unplug+0x1f/0x30
 [<c0159202>] block_sync_page+0x42/0x50
 [<c0134875>] wait_on_page_bit+0xe5/0xf0
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c01346c0>] page_wake_function+0x0/0x50
 [<c013437c>] wait_on_page_writeback_range+0x10c/0x150
 [<c0134541>] filemap_fdatawait+0x71/0x80
 [<c0155599>] sync_blockdev+0x39/0x50
 [<c0155aa7>] sys_fsync+0xb7/0xf0
 [<c01060cf>] syscall_call+0x7/0xb
Code: d8 8b 5c 24 08 83 c4 0c e9 6a d5 02 00 8d 76 00 8d bc 27 00 00 00 00 b8 00 e0 ff ff 8b 54 24 04 21 e0 f7 40 14 00 ff ff 00 74 08 <0f> 0b 0e 00 82 d4 30 c0 3b 15 34 cb 44 c0 73 01 c3 89 d0 e9 e4 
 <0>Kernel panic - not syncing: Fatal exception in interrupt

--ibTvN161/egqYuK8--
