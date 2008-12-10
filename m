From: Mark Nelson <markn@au1.ibm.com>
Subject: [PATCH] ipr: fix lockdep warning from ipr_ioa_reset_done
Date: Wed, 10 Dec 2008 12:23:20 +1100
Message-ID: <200812101223.20752.markn@au1.ibm.com>
References: <200812091757.51481.markn@au1.ibm.com> <493EF151.8050803@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:48260 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYLJBWU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 20:22:20 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id mBA1MFET007547
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 12:22:15 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBA1MoZi3530872
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 12:22:50 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mBA1MIIv025343
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2008 12:22:18 +1100
In-Reply-To: <493EF151.8050803@linux.vnet.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Brian King <brking@us.ibm.com>, linux-scsi@vger.kernel.org, Wayne Boyer <wayneb@linux.vnet.ibm.com>

To fix the following lockdep warning we turn the spin_unlock_irq() into
a spin_unlock() and similarly for the corresponding spin_lock_irq(). We
can do this because there is no need to enable interrupts in this path
(thanks to Bring King for the tip).

Badness at kernel/lockdep.c:2193
NIP: c0000000000855d0 LR: c0000000000855b4 CTR: c0000000000482d0
REGS: c00000000fffb8d0 TRAP: 0700   Not tainted  (2.6.28-rc5-autokern1)
MSR: 8000000000021032 <ME,IR,DR>  CR: 28000022  XER: 00000004
TASK = c00000000091fa80[0] 'swapper' THREAD: c000000000a3c000 CPU: 0
GPR00: 0000000000000000 c00000000fffbb50 c000000000a3c2e0 0000000000000001
GPR04: 000000000000a580 c0000000003870d4 0000000000000000 0000000000000001
GPR08: 0000000000000000 c00000000112fdf0 c0000000008ed918 c000000000abcfd0
GPR12: 0000000048000088 c000000000a7f300 0000000000000000 0000000002100000
GPR16: c000000000644bd0 c000000000643390 0000000000000000 00000000003d0c00
GPR20: 00000000028372d8 c0000000007372d8 0000000002837548 c000000000737548
GPR24: c000000000644660 00000000028372d8 000000000000001a c000000076760000
GPR28: 0000000000000004 c0000000004e8450 c0000000009aafb0 c00000000091fa80
NIP [c0000000000855d0] .trace_hardirqs_on_caller+0x10c/0x194
LR [c0000000000855b4] .trace_hardirqs_on_caller+0xf0/0x194
Call Trace:
[c00000000fffbb50] [c00000000fffbbe0] 0xc00000000fffbbe0 (unreliable)
[c00000000fffbbe0] [c0000000004e8450] ._spin_unlock_irq+0x38/0x5c
[c00000000fffbc70] [c0000000003870d4] .ipr_ioa_reset_done+0x204/0x284
[c00000000fffbd10] [c00000000037d234] .ipr_reset_ioa_job+0xc4/0xec
[c00000000fffbda0] [c000000000385ce0] .ipr_isr+0x208/0x484
[c00000000fffbe50] [c0000000000aaf3c] .handle_IRQ_event+0x58/0xd4
[c00000000fffbef0] [c0000000000ad978] .handle_fasteoi_irq+0x110/0x1ac
[c00000000fffbf90] [c000000000025214] .call_handle_irq+0x1c/0x2c
[c000000000a3f9a0] [c00000000000d168] .do_IRQ+0x120/0x210
[c000000000a3fa40] [c000000000004804] hardware_interrupt_entry+0x1c/0x98
--- Exception: 501 at .pseries_dedicated_idle_sleep+0xec/0x1cc
    LR = .pseries_dedicated_idle_sleep+0xdc/0x1cc
[c000000000a3fd30] [c000000000038208] .pseries_dedicated_idle_sleep+0x74/0x1cc (unreliable)
[c000000000a3fdd0] [c000000000012134] .cpu_idle+0x114/0x1dc
[c000000000a3fe60] [c0000000004ecb18] .rest_init+0x7c/0x94
[c000000000a3fee0] [c000000000700a40] .start_kernel+0x4b8/0x4e0
[c000000000a3ff90] [c000000000008368] .start_here_common+0x1c/0x34
Instruction dump:
e92d01b0 80090894 2f800000 41be002c 481ed1d1 60000000 2fa30000 419e0080
e93e8090 80090000 2f800000 409e0070 <0fe00000> 48000068 7fe3fb78 38800001

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
---
	Is this patch OK? It makes silences the warning and so far has no side effects

 drivers/scsi/ipr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: upstream/drivers/scsi/ipr.c
===================================================================
--- upstream.orig/drivers/scsi/ipr.c
+++ upstream/drivers/scsi/ipr.c
@@ -5389,9 +5389,9 @@ static int ipr_ioa_reset_done(struct ipr
 	list_add_tail(&ipr_cmd->queue, &ioa_cfg->free_q);
 	wake_up_all(&ioa_cfg->reset_wait_q);
 
-	spin_unlock_irq(ioa_cfg->host->host_lock);
+	spin_unlock(ioa_cfg->host->host_lock);
 	scsi_unblock_requests(ioa_cfg->host);
-	spin_lock_irq(ioa_cfg->host->host_lock);
+	spin_lock(ioa_cfg->host->host_lock);
 
 	if (!ioa_cfg->allow_cmds)
 		scsi_block_requests(ioa_cfg->host);
