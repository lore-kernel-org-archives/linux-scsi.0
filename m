From: Tedheadster <tedheadster@gmail.com>
Subject: Re: aha1542 oops caused by new request_irq routines
Date: Mon, 31 May 2010 11:22:15 -0400
Message-ID: <AANLkTimA-JSwDpFvaq3qLTQNFpEbHCJm_L0zxXwFdX2f@mail.gmail.com>
References: <AANLkTilB661W9H9IPxn9TGBvv-omVnAh43r3XR5uM58m@mail.gmail.com>
	<1275316364.2823.22.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48538 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab0EaPWQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2010 11:22:16 -0400
Received: by vws9 with SMTP id 9so868448vws.19
        for <linux-scsi@vger.kernel.org>; Mon, 31 May 2010 08:22:15 -0700 (PDT)
In-Reply-To: <1275316364.2823.22.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James,
  I didn't mention that I've been fiddling with the aha1542 driver on
my own. I also get an oops message when kmalloc is called with
GFP_KERNEL, so I changed it to GFP_ATOMIC and the oops went away.

May 31 09:22:54 K6 kernel: BUG: sleeping function called from invalid
context at mm/slub.c:1598
May 31 09:22:54 K6 kernel: in_atomic(): 0, irqs_disabled(): 1, pid:
4787, name: scsi_scan_5
May 31 09:22:54 K6 kernel: Pid: 4787, comm: scsi_scan_5 Not tainted
2.6.30.10-105.2.23.RODATA.fc11.i586 #1
May 31 09:22:54 K6 kernel: Call Trace:
May 31 09:22:54 K6 kernel: [<c0422ab7>] __might_sleep+0xc4/0xc9
May 31 09:22:54 K6 kernel: [<c04a4aef>] __kmalloc+0x7e/0x121
May 31 09:22:54 K6 kernel: [<d08649fd>]
aha1542_queuecommand+0x1ba/0x3d9 [aha1542]
May 31 09:22:54 K6 kernel: [<c0437042>] ? internal_add_timer+0x93/0x97
May 31 09:22:54 K6 kernel: [<c0600eb8>] ? scsi_done+0x0/0x12
May 31 09:22:54 K6 kernel: [<c060110e>] scsi_dispatch_cmd+0x173/0x1e2
May 31 09:22:54 K6 kernel: [<c0605e67>] scsi_request_fn+0x327/0x459
May 31 09:22:54 K6 kernel: [<c055c588>] __generic_unplug_device+0x2b/0x2e
May 31 09:22:54 K6 kernel: [<c055ebc7>] blk_execute_rq_nowait+0x66/0x89
May 31 09:22:54 K6 kernel: [<c055ec5b>] blk_execute_rq+0x71/0x92
May 31 09:22:54 K6 kernel: [<c055eb34>] ? blk_end_sync_rq+0x0/0x2d
May 31 09:22:54 K6 kernel: [<c0606e04>] scsi_execute+0xcd/0x123
May 31 09:22:54 K6 kernel: [<c0606ecf>] scsi_execute_req+0x75/0xa2
May 31 09:22:54 K6 kernel: [<c0607ca0>] scsi_probe_and_add_lun+0x1fb/0x947
May 31 09:22:54 K6 kernel: [<c056fc06>] ? kvasprintf+0x3a/0x45
May 31 09:22:54 K6 kernel: [<c05f5322>] ? get_device+0x18/0x1d
May 31 09:22:54 K6 kernel: [<c0607798>] ? scsi_alloc_target+0x1bf/0x1ef
May 31 09:22:54 K6 kernel: [<c06085ba>] __scsi_scan_target+0x76/0x4d2
May 31 09:22:54 K6 kernel: [<c0421821>] ? wakeup_preempt_entity+0x119/0x13d
May 31 09:22:54 K6 kernel: [<c0423537>] ? __dequeue_entity+0x28/0x2c
May 31 09:22:54 K6 kernel: [<c04235db>] ? set_next_entity+0xa0/0x10c
May 31 09:22:54 K6 kernel: [<c0402286>] ? __switch_to+0x78/0xfbe
May 31 09:22:54 K6 kernel: [<c0424063>] ? pick_next_task_fair+0x87/0x8e
May 31 09:22:54 K6 kernel: [<c0608a5b>] scsi_scan_channel+0x45/0x6b
May 31 09:22:54 K6 kernel: [<c0608b44>] scsi_scan_host_selected+0xc3/0xfe
May 31 09:22:54 K6 kernel: [<c0608bd8>] do_scsi_scan_host+0x59/0x62
May 31 09:22:54 K6 kernel: [<c0608be1>] ? do_scan_async+0x0/0x100
May 31 09:22:54 K6 kernel: [<c0608bf9>] do_scan_async+0x18/0x100
May 31 09:22:54 K6 kernel: [<c0608be1>] ? do_scan_async+0x0/0x100
May 31 09:22:54 K6 kernel: [<c0440165>] kthread+0x4b/0x6f
May 31 09:22:54 K6 kernel: [<c044011a>] ? kthread+0x0/0x6f
May 31 09:22:54 K6 kernel: [<c0403f87>] kernel_thread_helper+0x7/0x10

- Matthew
