From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4166] New: BUG: using smp_processor_id() in
 preemptible [00000001] code: nfsd/2783
Date: Fri, 4 Feb 2005 13:48:09 -0800
Message-ID: <20050204134809.2d341367.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fw.osdl.org ([65.172.181.6]:46492 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266441AbVBDVsN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2005 16:48:13 -0500
Received: from bix (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id j14LmCl00611
	for <linux-scsi@vger.kernel.org>; Fri, 4 Feb 2005 13:48:12 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


It looks like qla2x00_queuecommand()'s use of smp_processor_id() is
just a heuristic, in which case it should be sufficient to simply
use _smp_processor_id() to quash the warning.

Begin forwarded message:

Date: Fri, 4 Feb 2005 13:37:14 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4166] New: BUG: using smp_processor_id() in preemptible [00000001] code: nfsd/2783


http://bugme.osdl.org/show_bug.cgi?id=4166

           Summary: BUG: using smp_processor_id() in preemptible [00000001]
                    code: nfsd/2783
    Kernel Version: 2.6.11-rc3
            Status: NEW
          Severity: normal
             Owner: io_other@kernel-bugs.osdl.org
         Submitter: kernel@onerussian.com


Distribution: debian sid
Hardware Environment: Fibre Channel: QLogic Corp. QLA2312 Fibre Channel Adapter
Problem Description:
 Kernel floods logs with 
caller is qla2x00_queuecommand+0x20c/0x660 [qla2xxx]
 [<c023f926>] smp_processor_id+0xa6/0xc0
 [<f8bee89c>] qla2x00_queuecommand+0x20c/0x660 [qla2xxx]
 [<f8bee89c>] qla2x00_queuecommand+0x20c/0x660 [qla2xxx]
....
Steps to reproduce:
didn't try to reproduce but the bug came with upgrade from 2.6.8.1 to 2.6.11-rc3
on the system with QLA2312
The rest of the nodes in the cluster which do not have Qlogic run fine with the
kernel

Here is full bt
BUG: using smp_processor_id() in preemptible [00000001] code: nfsd/2783
caller is qla2x00_queuecommand+0x20c/0x660 [qla2xxx]
 [<c023f926>] smp_processor_id+0xa6/0xc0
 [<f8bee89c>] qla2x00_queuecommand+0x20c/0x660 [qla2xxx]
 [<f8bee89c>] qla2x00_queuecommand+0x20c/0x660 [qla2xxx]
 [<c0407766>] _spin_lock+0x16/0x90
 [<c0407bbf>] _spin_unlock_irqrestore+0xf/0x30
 [<c01231d8>] __mod_timer+0xe8/0x130
 [<c02e20e5>] scsi_dispatch_cmd+0x135/0x1d0
 [<c02e22e0>] scsi_done+0x0/0x30
 [<c02e4c10>] scsi_times_out+0x0/0xb0
 [<c02e7977>] scsi_request_fn+0x1c7/0x350
 [<c02a2560>] elv_next_request+0x50/0x110
 [<c02a498b>] __generic_unplug_device+0x3b/0x40
 [<c02a49ae>] generic_unplug_device+0x1e/0x30
 [<c02a49db>] blk_backing_dev_unplug+0x1b/0x20
 [<c0158a4e>] sync_buffer+0x4e/0x50
 [<c0407196>] __wait_on_bit+0x56/0x60
 [<c0158a00>] sync_buffer+0x0/0x50
 [<c0158a00>] sync_buffer+0x0/0x50
 [<c0407231>] out_of_line_wait_on_bit+0x91/0xa0
 [<c012f360>] wake_bit_function+0x0/0x60
 [<c012f360>] wake_bit_function+0x0/0x60
 [<c01b3b8f>] search_by_key+0xef/0x1180
 [<c01b39fd>] is_tree_node+0x6d/0x70
 [<c03a5d54>] kfree_skbmem+0x24/0x30
 [<c03abdba>] net_tx_action+0x4a/0x120
 [<c011f6e2>] __do_softirq+0x62/0xd0
 [<c019fca1>] reiserfs_read_locked_inode+0x71/0x110
 [<c019fd40>] reiserfs_find_actor+0x0/0x30
 [<c019fe13>] reiserfs_iget+0xa3/0xb0
 [<c019fd40>] reiserfs_find_actor+0x0/0x30
 [<c019fc10>] reiserfs_init_locked_inode+0x0/0x20
 [<c019abda>] reiserfs_lookup+0x16a/0x190
 [<c0170692>] __d_lookup+0x92/0x140
 [<c0407bbf>] _spin_unlock_irqrestore+0xf/0x30
 [<c01700be>] d_alloc+0x13e/0x1a0
 [<c0166c35>] __lookup_hash+0xa5/0xe0
 [<c0166c8f>] lookup_hash+0x1f/0x30
 [<c0166d01>] lookup_one_len+0x61/0x70
 [<f919c2d2>] nfsd_lookup+0x112/0x4c0 [nfsd]
 [<c01290cd>] groups_alloc+0x3d/0xc0
 [<f91a47a1>] nfsd3_proc_lookup+0xa1/0xe0 [nfsd]
 [<f91996a9>] nfsd_dispatch+0xd9/0x230 [nfsd]
 [<f8ea0a22>] svc_process+0x4a2/0x680 [sunrpc]
 [<c0116240>] default_wake_function+0x0/0x20
 [<f919944a>] nfsd+0x1ba/0x340 [nfsd]
 [<f9199290>] nfsd+0x0/0x340 [nfsd]
 [<c01009d1>] kernel_thread_helper+0x5/0x14
printk: 460 messages suppressed.
repeats

more details about the system can be found from
http://www.onerussian.com/Linux/bugs/020405ra

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
