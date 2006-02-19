From: Dave Jones <davej@redhat.com>
Subject: sgpool-8 double free
Date: Sun, 19 Feb 2006 15:29:23 -0500
Message-ID: <20060219202923.GF32492@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from c-66-31-106-233.hsd1.ma.comcast.net ([66.31.106.233]:37571 "EHLO
	nwo.kernelslacker.org") by vger.kernel.org with ESMTP
	id S1751030AbWBSU3z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 15:29:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: bcollins@debian.org

We had a user report the following trace to us running
a 2.6.16rc4 kernel. (It's actually been there since at least 2.6.15)

He can trigger it easily with just a 'modprobe sbp2'
Whilst it sounds firewire specific, the trace doesn't finger
sbp2 at all, but points to scsi_mod.

More info at https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=182005

		Dave


Feb 18 22:30:17 fgrbhw01 kernel: sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
Feb 18 22:30:17 fgrbhw01 kernel: ieee1394: sbp2: Driver forced to serialize I/O (serialize_io=1)
Feb 18 22:30:17 fgrbhw01 kernel: ieee1394: sbp2: Try serialize_io=0 for better performance
Feb 18 22:30:17 fgrbhw01 kernel: scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
Feb 18 22:30:17 fgrbhw01 kernel: ieee1394: sbp2: Node 0-00:1023: Using 36byte inquiry workaround
Feb 18 22:30:18 fgrbhw01 kernel: ieee1394: sbp2: Logged into SBP-2 device
Feb 18 22:30:18 fgrbhw01 kernel:   Vendor: Initio    Model: 0KLAT80          Rev: 2.05
Feb 18 22:30:18 fgrbhw01 kernel:   Type:   Direct-Access                     ANSI SCSI revision: 00
Feb 18 22:30:18 fgrbhw01 kernel: SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
Feb 18 22:30:18 fgrbhw01 kernel: slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or memory outside object was overwritten
Feb 18 22:30:18 fgrbhw01 kernel:  [<c014d8bf>] cache_free_debugcheck+0xce/0x1b9
    [<c01486cb>] mempool_free+0x5f/0x63
Feb 18 22:30:18 fgrbhw01 kernel:  [<c014e230>] kmem_cache_free+0x2a/0x5c    
[<c01486cb>] mempool_free+0x5f/0x63
Feb 18 22:30:18 fgrbhw01 kernel:  [<f8864f65>] scsi_io_completion+0x65/0x3ce
[scsi_mod]     [<f8860bb3>] scsi_finish_command+0xb8/0xbd [scsi_mod]
Feb 18 22:30:18 fgrbhw01 kernel:  [<f8860ab6>] scsi_softirq+0x109/0x128
[scsi_mod]     [<c0127098>] __do_softirq+0x58/0xc2
Feb 18 22:30:18 fgrbhw01 kernel:  [<c0105f75>] do_softirq+0x46/0x4e
Feb 18 22:30:18 fgrbhw01 kernel:  =======================
Feb 18 22:30:18 fgrbhw01 kernel:  [<c0105e9a>] do_IRQ+0x72/0x7b     [<c01048fe>]
common_interrupt+0x1a/0x20
Feb 18 22:30:18 fgrbhw01 kernel:  [<f88c940b>] ext3_get_block_handle+0x0/0x2a5
[ext3]     [<f88c9714>] ext3_get_block+0x64/0x6c [ext3]
Feb 18 22:30:18 fgrbhw01 kernel:  [<f88c9f0f>] ext3_bmap+0x0/0x6d [ext3]    
[<c0165dec>] generic_block_bmap+0x28/0x35
Feb 18 22:30:18 fgrbhw01 kernel:  [<c02f599a>] io_schedule+0x26/0x30    
[<c02f5cd3>] out_of_line_wait_on_bit_lock+0x75/0x7d
Feb 18 22:30:18 fgrbhw01 kernel:  [<c01631d3>] sync_buffer+0x0/0x33    
[<f88c9f75>] ext3_bmap+0x66/0x6d [ext3]
Feb 18 22:30:18 fgrbhw01 kernel:  [<f88c96b0>] ext3_get_block+0x0/0x6c [ext3]  
  [<f88c9f0f>] ext3_bmap+0x0/0x6d [ext3]
Feb 18 22:30:18 fgrbhw01 kernel:  [<c0178e14>] bmap+0x23/0x27     [<f88961e9>]
journal_bmap+0x1d/0x64 [jbd]
Feb 18 22:30:18 fgrbhw01 kernel:  [<c01347cd>] wake_bit_function+0x0/0x3c    
[<c014d9a2>] cache_free_debugcheck+0x1b1/0x1b9
Feb 18 22:30:18 fgrbhw01 kernel:  [<f88961bd>] journal_next_log_block+0x74/0x83
[jbd]     [<f889623f>] journal_get_descriptor_buffer+0xf/0x8d [jbd]
Feb 18 22:30:19 fgrbhw01 kernel:  [<f8893709>]
journal_commit_transaction+0x61c/0xdbf [jbd]     [<c02f6269>]
_spin_lock_irqsave+0x9/0xd
Feb 18 22:30:19 fgrbhw01 kernel:  [<c012a32b>] try_to_del_timer_sync+0x44/0x4a 
   [<f88959aa>] kjournald+0xbd/0x20e [jbd]
Feb 18 22:30:19 fgrbhw01 kernel:  [<c011d4c9>] schedule_tail+0x36/0x8b    
[<f88958e8>] commit_timeout+0x0/0x5 [jbd]
Feb 18 22:30:19 fgrbhw01 kernel:  [<c01347a0>] autoremove_wake_function+0x0/0x2d
    [<f88958ed>] kjournald+0x0/0x20e [jbd]
Feb 18 22:30:19 fgrbhw01 kernel:  [<c01023a9>] kernel_thread_helper+0x5/0xb
Feb 18 22:30:19 fgrbhw01 kernel: f3fa3888: redzone 1: 0x170fc2a5, redzone 2:
0xc01485d0.

