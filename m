From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: BAD_SG_DMA panic in aha1542
Date: Tue, 1 May 2007 08:42:00 -0500 (CDT)
Message-ID: <20070501134200.D669ADBA1@gherkin.frus.com>
References: <20070501133312.GD4653@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:47230 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423503AbXEANmF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 May 2007 09:42:05 -0400
In-Reply-To: <20070501133312.GD4653@kernel.dk> "from Jens Axboe at May 1, 2007
 03:33:12 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

Jens Axboe wrote:
> Try Alan's patch, it should fix it. As mentioned earlier in this thread,
> the real fix is to get rid of the cgc stuff and inject into the block
> layer from cdrom.c. But Alan's patch should work-around the issue for
> now.

Trying that patch is the next thing on my plate.  For now, here's the
dmesg output James requested (aha1542 debug patch).  Oddly enough, when
the smoke cleared, the mount succeeded and I could access the cd :-).

Initial state: SCSI cdrom drivers not loaded.
Command: "mount -t iso9660 /dev/scd0 /mnt/cdrom -r"

sr0: scsi3-mmc drive: 16x/16x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:4:0: Attached scsi CD-ROM sr0
sgpnt[0:1] page c3489af0/0x3489af0 length 32
BUG: warning at drivers/scsi/aha1542.c:78/BAD_SG_DMA()
 [<c4819858>] aha1542_queuecommand+0x4a4/0x4ce [aha1542]
 [<c4833317>] scsi_done+0x0/0x16 [scsi_mod]
 [<c48339f2>] scsi_dispatch_cmd+0x1b0/0x223 [scsi_mod]
 [<c4837abc>] scsi_request_fn+0x22e/0x2ac [scsi_mod]
 [<c01a09d4>] __generic_unplug_device+0x1d/0x1f
 [<c01a0a3a>] blk_execute_rq_nowait+0x64/0x6a
 [<c01a0aae>] blk_execute_rq+0x6e/0x8f
 [<c01a02d0>] blk_end_sync_rq+0x0/0x1d
 [<c01354c9>] mempool_alloc+0x1c/0x97
 [<c014d2fc>] bio_phys_segments+0xe/0x14
 [<c019f456>] blk_rq_bio_prep+0x28/0x7c
 [<c483744f>] scsi_execute+0xc6/0xd9 [scsi_mod]
 [<c4942da2>] sr_do_ioctl+0x80/0x1bd [sr_mod]
 [<c483439d>] scsi_set_medium_removal+0x43/0x67 [scsi_mod]
 [<c494209b>] sr_packet+0x1a/0x1f [sr_mod]
 [<c49aad25>] cdrom_open+0x337/0x8ae [cdrom]
 [<c0275aaf>] wait_for_completion+0x5b/0x84
 [<c0111cba>] default_wake_function+0x0/0xc
 [<c0120312>] call_usermodehelper_keys+0xa6/0xb2
 [<c012031e>] __call_usermodehelper+0x0/0x43
 [<c012049b>] request_module+0xc2/0xd0
 [<c01a9b71>] kobject_get+0xf/0x13
 [<c4942324>] sr_block_open+0x74/0x81 [sr_mod]
 [<c014ec4f>] do_open+0x8a/0x313
 [<c4837b01>] scsi_request_fn+0x273/0x2ac [scsi_mod]
 [<c0275d9f>] io_schedule+0xe/0x16
 [<c0276065>] __wait_on_bit+0x50/0x58
 [<c014ad1a>] sync_buffer+0x0/0x2e
 [<c014ad1a>] sync_buffer+0x0/0x2e
 [<c02760cf>] out_of_line_wait_on_bit+0x62/0x6a
 [<c0122cf0>] wake_bit_function+0x0/0x3c
 [<c014ace5>] __wait_on_buffer+0x1c/0x1f
 [<c48852e1>] __ext3_get_inode_loc+0x263/0x2b1 [ext3]
 [<c015bbd6>] d_splice_alias+0xa9/0xc3
 [<c488b470>] ext3_lookup+0x98/0xb8 [ext3]
 [<c0153018>] do_lookup+0x4f/0x135
 [<c015b1cb>] dput+0x1a/0x10b
 [<c0154e0d>] __link_path_walk+0xa5d/0xba8
 [<c014ef2d>] blkdev_get+0x55/0x60
 [<c014f212>] open_bdev_excl+0x32/0x6e
 [<c014e1f8>] get_sb_bdev+0x14/0x115
 [<c49934c1>] isofs_get_sb+0x12/0x16 [isofs]
 [<c4993987>] isofs_fill_super+0x0/0x899 [isofs]
 [<c014df0a>] vfs_kern_mount+0x88/0xfd
 [<c014dfb2>] do_kern_mount+0x26/0x36
 [<c015eee2>] do_mount+0x589/0x5fb
 [<c015e21c>] mntput_no_expire+0x11/0x59
 [<c015e21c>] mntput_no_expire+0x11/0x59
 [<c0155007>] link_path_walk+0xaf/0xb9
 [<c013c4fc>] __handle_mm_fault+0x341/0x620
 [<c01552c4>] do_path_lookup+0x195/0x1b5
 [<c013c342>] __handle_mm_fault+0x187/0x620
 [<c0136236>] get_page_from_freelist+0x6e/0x2bb
 [<c0136ae6>] __get_free_pages+0x25/0x3e
 [<c015de80>] copy_mount_options+0x27/0x10a
 [<c015efbe>] sys_mount+0x6a/0xa2
 [<c0102a47>] syscall_call+0x7/0xb
sgpnt[0:1] page c3489af0/0x3489af0 length 32
BUG: warning at drivers/scsi/aha1542.c:78/BAD_SG_DMA()
 [<c4819858>] aha1542_queuecommand+0x4a4/0x4ce [aha1542]
 [<c4833317>] scsi_done+0x0/0x16 [scsi_mod]
 [<c48339f2>] scsi_dispatch_cmd+0x1b0/0x223 [scsi_mod]
 [<c4837abc>] scsi_request_fn+0x22e/0x2ac [scsi_mod]
 [<c01a1662>] blk_run_queue+0x2a/0x4b
 [<c483725a>] scsi_queue_insert+0x75/0x7d [scsi_mod]
 [<c01a1598>] blk_done_softirq+0x4a/0x55
 [<c0118563>] __do_softirq+0x35/0x75
 [<c01185c5>] do_softirq+0x22/0x26
 [<c0105074>] do_IRQ+0x48/0x50
 [<c0103a9a>] common_interrupt+0x1a/0x20
 [<c48339f6>] scsi_dispatch_cmd+0x1b4/0x223 [scsi_mod]
 [<c4837abc>] scsi_request_fn+0x22e/0x2ac [scsi_mod]
 [<c01a09d4>] __generic_unplug_device+0x1d/0x1f
 [<c01a0a3a>] blk_execute_rq_nowait+0x64/0x6a
 [<c01a0aae>] blk_execute_rq+0x6e/0x8f
 [<c01a02d0>] blk_end_sync_rq+0x0/0x1d
 [<c01354c9>] mempool_alloc+0x1c/0x97
 [<c014d2fc>] bio_phys_segments+0xe/0x14
 [<c019f456>] blk_rq_bio_prep+0x28/0x7c
 [<c483744f>] scsi_execute+0xc6/0xd9 [scsi_mod]
 [<c4942da2>] sr_do_ioctl+0x80/0x1bd [sr_mod]
 [<c483439d>] scsi_set_medium_removal+0x43/0x67 [scsi_mod]
 [<c494209b>] sr_packet+0x1a/0x1f [sr_mod]
 [<c49aad25>] cdrom_open+0x337/0x8ae [cdrom]
 [<c0275aaf>] wait_for_completion+0x5b/0x84
 [<c0111cba>] default_wake_function+0x0/0xc
 [<c0120312>] call_usermodehelper_keys+0xa6/0xb2
 [<c012031e>] __call_usermodehelper+0x0/0x43
 [<c012049b>] request_module+0xc2/0xd0
 [<c01a9b71>] kobject_get+0xf/0x13
 [<c4942324>] sr_block_open+0x74/0x81 [sr_mod]
 [<c014ec4f>] do_open+0x8a/0x313
 [<c4837b01>] scsi_request_fn+0x273/0x2ac [scsi_mod]
 [<c0275d9f>] io_schedule+0xe/0x16
 [<c0276065>] __wait_on_bit+0x50/0x58
 [<c014ad1a>] sync_buffer+0x0/0x2e
 [<c014ad1a>] sync_buffer+0x0/0x2e
 [<c02760cf>] out_of_line_wait_on_bit+0x62/0x6a
 [<c0122cf0>] wake_bit_function+0x0/0x3c
 [<c014ace5>] __wait_on_buffer+0x1c/0x1f
 [<c48852e1>] __ext3_get_inode_loc+0x263/0x2b1 [ext3]
 [<c015bbd6>] d_splice_alias+0xa9/0xc3
 [<c488b470>] ext3_lookup+0x98/0xb8 [ext3]
 [<c0153018>] do_lookup+0x4f/0x135
 [<c015b1cb>] dput+0x1a/0x10b
 [<c0154e0d>] __link_path_walk+0xa5d/0xba8
 [<c014ef2d>] blkdev_get+0x55/0x60
 [<c014f212>] open_bdev_excl+0x32/0x6e
 [<c014e1f8>] get_sb_bdev+0x14/0x115
 [<c49934c1>] isofs_get_sb+0x12/0x16 [isofs]
 [<c4993987>] isofs_fill_super+0x0/0x899 [isofs]
 [<c014df0a>] vfs_kern_mount+0x88/0xfd
 [<c014dfb2>] do_kern_mount+0x26/0x36
 [<c015eee2>] do_mount+0x589/0x5fb
 [<c015e21c>] mntput_no_expire+0x11/0x59
 [<c015e21c>] mntput_no_expire+0x11/0x59
 [<c0155007>] link_path_walk+0xaf/0xb9
 [<c013c4fc>] __handle_mm_fault+0x341/0x620
 [<c01552c4>] do_path_lookup+0x195/0x1b5
 [<c013c342>] __handle_mm_fault+0x187/0x620
 [<c0136236>] get_page_from_freelist+0x6e/0x2bb
 [<c0136ae6>] __get_free_pages+0x25/0x3e
 [<c015de80>] copy_mount_options+0x27/0x10a
 [<c015efbe>] sys_mount+0x6a/0xa2
 [<c0102a47>] syscall_call+0x7/0xb
sgpnt[0:1] page c3489af0/0x3489af0 length 32
BUG: warning at drivers/scsi/aha1542.c:78/BAD_SG_DMA()
 [<c4819858>] aha1542_queuecommand+0x4a4/0x4ce [aha1542]
 [<c4833317>] scsi_done+0x0/0x16 [scsi_mod]
 [<c48339f2>] scsi_dispatch_cmd+0x1b0/0x223 [scsi_mod]
 [<c4837abc>] scsi_request_fn+0x22e/0x2ac [scsi_mod]
 [<c01a1662>] blk_run_queue+0x2a/0x4b
 [<c483725a>] scsi_queue_insert+0x75/0x7d [scsi_mod]
 [<c01a1598>] blk_done_softirq+0x4a/0x55
 [<c0118563>] __do_softirq+0x35/0x75
 [<c01185c5>] do_softirq+0x22/0x26
 [<c0105074>] do_IRQ+0x48/0x50
 [<c0103a9a>] common_interrupt+0x1a/0x20
 [<c48339f6>] scsi_dispatch_cmd+0x1b4/0x223 [scsi_mod]
 [<c4837abc>] scsi_request_fn+0x22e/0x2ac [scsi_mod]
 [<c01a09d4>] __generic_unplug_device+0x1d/0x1f
 [<c01a0a3a>] blk_execute_rq_nowait+0x64/0x6a
 [<c01a0aae>] blk_execute_rq+0x6e/0x8f
 [<c01a02d0>] blk_end_sync_rq+0x0/0x1d
 [<c01354c9>] mempool_alloc+0x1c/0x97
 [<c014d2fc>] bio_phys_segments+0xe/0x14
 [<c019f456>] blk_rq_bio_prep+0x28/0x7c
 [<c483744f>] scsi_execute+0xc6/0xd9 [scsi_mod]
 [<c4942da2>] sr_do_ioctl+0x80/0x1bd [sr_mod]
 [<c483439d>] scsi_set_medium_removal+0x43/0x67 [scsi_mod]
 [<c494209b>] sr_packet+0x1a/0x1f [sr_mod]
 [<c49aad25>] cdrom_open+0x337/0x8ae [cdrom]
 [<c0275aaf>] wait_for_completion+0x5b/0x84
 [<c0111cba>] default_wake_function+0x0/0xc
 [<c0120312>] call_usermodehelper_keys+0xa6/0xb2
 [<c012031e>] __call_usermodehelper+0x0/0x43
 [<c012049b>] request_module+0xc2/0xd0
 [<c01a9b71>] kobject_get+0xf/0x13
 [<c4942324>] sr_block_open+0x74/0x81 [sr_mod]
 [<c014ec4f>] do_open+0x8a/0x313
 [<c4837b01>] scsi_request_fn+0x273/0x2ac [scsi_mod]
 [<c0275d9f>] io_schedule+0xe/0x16
 [<c0276065>] __wait_on_bit+0x50/0x58
 [<c014ad1a>] sync_buffer+0x0/0x2e
 [<c014ad1a>] sync_buffer+0x0/0x2e
 [<c02760cf>] out_of_line_wait_on_bit+0x62/0x6a
 [<c0122cf0>] wake_bit_function+0x0/0x3c
 [<c014ace5>] __wait_on_buffer+0x1c/0x1f
 [<c48852e1>] __ext3_get_inode_loc+0x263/0x2b1 [ext3]
 [<c015bbd6>] d_splice_alias+0xa9/0xc3
 [<c488b470>] ext3_lookup+0x98/0xb8 [ext3]
 [<c0153018>] do_lookup+0x4f/0x135
 [<c015b1cb>] dput+0x1a/0x10b
 [<c0154e0d>] __link_path_walk+0xa5d/0xba8
 [<c014ef2d>] blkdev_get+0x55/0x60
 [<c014f212>] open_bdev_excl+0x32/0x6e
 [<c014e1f8>] get_sb_bdev+0x14/0x115
 [<c49934c1>] isofs_get_sb+0x12/0x16 [isofs]
 [<c4993987>] isofs_fill_super+0x0/0x899 [isofs]
 [<c014df0a>] vfs_kern_mount+0x88/0xfd
 [<c014dfb2>] do_kern_mount+0x26/0x36
 [<c015eee2>] do_mount+0x589/0x5fb
 [<c015e21c>] mntput_no_expire+0x11/0x59
 [<c015e21c>] mntput_no_expire+0x11/0x59
 [<c0155007>] link_path_walk+0xaf/0xb9
 [<c013c4fc>] __handle_mm_fault+0x341/0x620
 [<c01552c4>] do_path_lookup+0x195/0x1b5
 [<c013c342>] __handle_mm_fault+0x187/0x620
 [<c0136236>] get_page_from_freelist+0x6e/0x2bb
 [<c0136ae6>] __get_free_pages+0x25/0x3e
 [<c015de80>] copy_mount_options+0x27/0x10a
 [<c015efbe>] sys_mount+0x6a/0xa2
 [<c0102a47>] syscall_call+0x7/0xb
sgpnt[0:1] page c3489af0/0x3489af0 length 32
BUG: warning at drivers/scsi/aha1542.c:78/BAD_SG_DMA()
 [<c4819858>] aha1542_queuecommand+0x4a4/0x4ce [aha1542]
 [<c4833317>] scsi_done+0x0/0x16 [scsi_mod]
 [<c48339f2>] scsi_dispatch_cmd+0x1b0/0x223 [scsi_mod]
 [<c4837abc>] scsi_request_fn+0x22e/0x2ac [scsi_mod]
 [<c01a1662>] blk_run_queue+0x2a/0x4b
 [<c483725a>] scsi_queue_insert+0x75/0x7d [scsi_mod]
 [<c01a1598>] blk_done_softirq+0x4a/0x55
 [<c0118563>] __do_softirq+0x35/0x75
 [<c01185c5>] do_softirq+0x22/0x26
 [<c0105074>] do_IRQ+0x48/0x50
 [<c0103a9a>] common_interrupt+0x1a/0x20
 [<c48339f6>] scsi_dispatch_cmd+0x1b4/0x223 [scsi_mod]
 [<c4837abc>] scsi_request_fn+0x22e/0x2ac [scsi_mod]
 [<c01a09d4>] __generic_unplug_device+0x1d/0x1f
 [<c01a0a3a>] blk_execute_rq_nowait+0x64/0x6a
 [<c01a0aae>] blk_execute_rq+0x6e/0x8f
 [<c01a02d0>] blk_end_sync_rq+0x0/0x1d
 [<c01354c9>] mempool_alloc+0x1c/0x97
 [<c014d2fc>] bio_phys_segments+0xe/0x14
 [<c019f456>] blk_rq_bio_prep+0x28/0x7c
 [<c483744f>] scsi_execute+0xc6/0xd9 [scsi_mod]
 [<c4942da2>] sr_do_ioctl+0x80/0x1bd [sr_mod]
 [<c483439d>] scsi_set_medium_removal+0x43/0x67 [scsi_mod]
 [<c494209b>] sr_packet+0x1a/0x1f [sr_mod]
 [<c49aad25>] cdrom_open+0x337/0x8ae [cdrom]
 [<c0275aaf>] wait_for_completion+0x5b/0x84
 [<c0111cba>] default_wake_function+0x0/0xc
 [<c0120312>] call_usermodehelper_keys+0xa6/0xb2
 [<c012031e>] __call_usermodehelper+0x0/0x43
 [<c012049b>] request_module+0xc2/0xd0
 [<c01a9b71>] kobject_get+0xf/0x13
 [<c4942324>] sr_block_open+0x74/0x81 [sr_mod]
 [<c014ec4f>] do_open+0x8a/0x313
 [<c4837b01>] scsi_request_fn+0x273/0x2ac [scsi_mod]
 [<c0275d9f>] io_schedule+0xe/0x16
 [<c0276065>] __wait_on_bit+0x50/0x58
 [<c014ad1a>] sync_buffer+0x0/0x2e
 [<c014ad1a>] sync_buffer+0x0/0x2e
 [<c02760cf>] out_of_line_wait_on_bit+0x62/0x6a
 [<c0122cf0>] wake_bit_function+0x0/0x3c
 [<c014ace5>] __wait_on_buffer+0x1c/0x1f
 [<c48852e1>] __ext3_get_inode_loc+0x263/0x2b1 [ext3]
 [<c015bbd6>] d_splice_alias+0xa9/0xc3
 [<c488b470>] ext3_lookup+0x98/0xb8 [ext3]
 [<c0153018>] do_lookup+0x4f/0x135
 [<c015b1cb>] dput+0x1a/0x10b
 [<c0154e0d>] __link_path_walk+0xa5d/0xba8
 [<c014ef2d>] blkdev_get+0x55/0x60
 [<c014f212>] open_bdev_excl+0x32/0x6e
 [<c014e1f8>] get_sb_bdev+0x14/0x115
 [<c49934c1>] isofs_get_sb+0x12/0x16 [isofs]
 [<c4993987>] isofs_fill_super+0x0/0x899 [isofs]
 [<c014df0a>] vfs_kern_mount+0x88/0xfd
 [<c014dfb2>] do_kern_mount+0x26/0x36
 [<c015eee2>] do_mount+0x589/0x5fb
 [<c015e21c>] mntput_no_expire+0x11/0x59
 [<c015e21c>] mntput_no_expire+0x11/0x59
 [<c0155007>] link_path_walk+0xaf/0xb9
 [<c013c4fc>] __handle_mm_fault+0x341/0x620
 [<c01552c4>] do_path_lookup+0x195/0x1b5
 [<c013c342>] __handle_mm_fault+0x187/0x620
 [<c0136236>] get_page_from_freelist+0x6e/0x2bb
 [<c0136ae6>] __get_free_pages+0x25/0x3e
 [<c015de80>] copy_mount_options+0x27/0x10a
 [<c015efbe>] sys_mount+0x6a/0xa2
 [<c0102a47>] syscall_call+0x7/0xb
ISO 9660 Extensions: Microsoft Joliet Level 1
ISOFS: changing to secondary root

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
