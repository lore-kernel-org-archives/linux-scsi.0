From: Anton Blanchard <anton@samba.org>
Subject: Re: Emulex lpfcdriver v8.0.2 available
Date: Wed, 2 Jun 2004 04:52:00 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040601185200.GB4239@krispykreme>
References: <3356669BBE90C448AD4645C843E2BF28034F93F1@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:1707 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S265134AbUFASzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2004 14:55:50 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F93F1@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


Hi James,

> FYI - we've updated the image on SourceForge. In this drop, we've addressed
> many of your comments, including those on moving the discovery tasklet to a
> thread, and moving the timer functions inline. The full changelog is up on
> SF.

We gave it a spin on a ppc64 box and managed to hit the following
backtrace when doing heavy writeout. I wonder if a number of these
atomic allocations (in lpfc_get_scsi_buf etc) should be using a mempool,
otherwise we could deadlock on writeout.

Anton

md0_raid5: page allocation failure. order:0, mode:0x20
Call Trace:
[c000000000078e80] .__alloc_pages+0x448/0x450 (unreliable)
[c00000000009be0c] .alloc_pages_current+0xc0/0xe4
[c000000000078edc] .__get_free_pages+0x54/0x1e0
[c00000000007df40] .kmem_getpages+0x48/0x210
[c00000000007e3f8] .cache_alloc_refill+0x2f0/0x67c
[c00000000007e8dc] .kmem_cache_alloc+0x74/0x78
[d0000000003bdd98] .lpfc_get_scsi_buf+0x40/0x2bc [lpfc]
[d0000000003be1c4] .lpfc_queuecommand+0xa0/0xac4 [lpfc]
[d00000000006e06c] .scsi_dispatch_cmd+0x22c/0x378 [scsi_mod]
[d000000000074b74] .scsi_request_fn+0x2e4/0x590 [scsi_mod]
[c00000000021b5c0] .blk_run_queue+0x60/0x90
[d000000000073dd8] .scsi_run_queue+0x134/0x2a8 [scsi_mod]
[d000000000075068] .scsi_end_request+0x12c/0x168 [scsi_mod]
[d000000000075220] .scsi_io_completion+0x17c/0x524 [scsi_mod]
[d00000000003a5fc] .sd_rw_intr+0xac/0x304 [sd_mod]
[d00000000006d8b4] .scsi_finish_command+0xd8/0x130 [scsi_mod]
[d00000000006e4e8] .scsi_softirq+0x178/0x188 [scsi_mod]
[c000000000053120] .__do_softirq+0xa8/0x16c
[c0000000000171c8] .call_do_softirq+0x14/0x24
[c000000000011ddc] .do_softirq+0x90/0xa0
[c000000000012b54] .do_IRQ+0xf8/0x118
[c00000000000b034] HardwareInterrupt_entry+0x14/0x18
--- Exception: 500 at .__make_request+0x428/0x810
    LR = .__make_request+0x3b8/0x810
[c0000000002197c4] .generic_make_request+0x138/0x21c
[d0000000004485d4] .handle_stripe+0x1160/0x13d8 [raid5]
[d000000000449f7c] .raid5d+0xe0/0x248 [raid5]
[c00000000028e28c] .md_thread+0x204/0x294
[c000000000017764] .kernel_thread+0x4c/0x68
