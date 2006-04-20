From: "Zhikun Wang" <raidwang@gmail.com>
Subject: might_sleep warnings in gereric_make_request
Date: Thu, 20 Apr 2006 11:05:55 +0800
Message-ID: <200604201105448287687@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pproxy.gmail.com ([64.233.166.179]:18935 "EHLO pproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1750887AbWDTDGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 23:06:19 -0400
Received: by pproxy.gmail.com with SMTP id i49so54261pye
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2006 20:06:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Eric Moore <Eric.Moore@lsil.com>

Hi:
	I want to call genric_make_request in bio->bi_end_io function. But it incurs might_sleep warnings! I wonder this method is safe in the kernel? Thanks a lot! 


cfq: depth 4 reached, tagging now on
Debug: sleeping function called from invalid context at drivers/block/ll_rw_blk.c:2878
in_atomic():1, irqs_disabled():0
 [<c0279467>] generic_make_request+0x1e/0x23a
 [<c011ad1a>] recalc_task_prio+0xc1/0x150
 [<c011adff>] activate_task+0x56/0x65
 [<e0a35dfb>] raid1_end_sync_read+0x245/0x364 [raid1]
 [<c011be66>] __wake_up_common+0x39/0x59
 [<e0a35bb6>] raid1_end_sync_read+0x0/0x364 [raid1]
 [<c0181f29>] bio_endio+0x3d/0x68
 [<c015576c>] mempool_free+0x67/0x1ca
 [<c0279a25>] __end_that_request_first+0xc1/0x1f5
 [<c0274a70>] elv_queue_empty+0x12/0x1b
 [<e0821e45>] scsi_end_request+0x1e/0x210 [scsi_mod]
 [<c015576c>] mempool_free+0x67/0x1ca
 [<c02e5460>] ip_local_deliver+0x60/0x1a2
 [<e082231b>] scsi_io_completion+0x16c/0x4c2 [scsi_mod]
 [<c011ad1a>] recalc_task_prio+0xc1/0x150
 [<c011ad1a>] recalc_task_prio+0xc1/0x150
 [<e0869fe2>] sd_rw_intr+0x137/0x3b1 [sd_mod]
 [<e081b3a9>] scsi_finish_command+0x8e/0xc1 [scsi_mod]
 [<c0103c0e>] common_interrupt+0x1a/0x20
 [<e081b2d0>] scsi_softirq+0x9e/0xc3 [scsi_mod]
 [<c0127f1e>] __do_softirq+0x3e/0x8a
 [<c0105c29>] do_softirq+0x3e/0x42
 =======================
 [<c0105b24>] do_IRQ+0x51/0x82
 [<c0105b24>] do_IRQ+0x51/0x82
 [<c0103c0e>] common_interrupt+0x1a/0x20
 [<c010101a>] default_idle+0x0/0x29
 [<c0101040>] default_idle+0x26/0x29
 [<c01010a6>] cpu_idle+0x34/0x4c
 [<c03be71f>] start_kernel+0x154/0x1ab
 [<c03be2fe>] unknown_bootoption+0x0/0x1cd
cfq: depth 4 reached, tagging now on
Debug: sleeping function called from invalid context at drivers/block/ll_rw_blk.c:2878
in_atomic():1, irqs_disabled():0
 [<c0279467>] generic_make_request+0x1e/0x23a
 [<c015576c>] mempool_free+0x67/0x1ca
 [<c0276e35>] __generic_unplug_device+0x31/0x33
 [<c011be66>] __wake_up_common+0x39/0x59
 [<e0a35dfb>] raid1_end_sync_read+0x245/0x364 [raid1]
 [<e08f67a3>] raid_done_sync+0x2b/0x4a [raid]
 [<c02cbae7>] skb_checksum+0x55/0x2cc
 [<e0a35bb6>] raid1_end_sync_read+0x0/0x364 [raid1]
 [<c0181f29>] bio_endio+0x3d/0x68
 [<c015576c>] mempool_free+0x67/0x1ca
 [<c0279a25>] __end_that_request_first+0xc1/0x1f5
 [<c0274a70>] elv_queue_empty+0x12/0x1b
 [<e0821e45>] scsi_end_request+0x1e/0x210 [scsi_mod]
 [<c015576c>] mempool_free+0x67/0x1ca
 [<c02e5460>] ip_local_deliver+0x60/0x1a2
 [<e082231b>] scsi_io_completion+0x16c/0x4c2 [scsi_mod]
 [<e0869fe2>] sd_rw_intr+0x137/0x3b1 [sd_mod]
 [<c012c59e>] cascade+0x21/0x3b
 [<e081b3a9>] scsi_finish_command+0x8e/0xc1 [scsi_mod]
 [<c0103c0e>] common_interrupt+0x1a/0x20
 [<e081b2d0>] scsi_softirq+0x9e/0xc3 [scsi_mod]
 [<c0127f1e>] __do_softirq+0x3e/0x8a
 [<c0105c29>] do_softirq+0x3e/0x42
 =======================
 [<c0105b24>] do_IRQ+0x51/0x82
 [<c0105b24>] do_IRQ+0x51/0x82
 [<c0103c0e>] common_interrupt+0x1a/0x20
 [<c010101a>] default_idle+0x0/0x29
 [<c0101040>] default_idle+0x26/0x29
 [<c01010a6>] cpu_idle+0x34/0x4c
 [<c03be71f>] start_kernel+0x154/0x1ab
 [<c03be2fe>] unknown_bootoption+0x0/0x1cd



