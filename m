From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/1] FC transport: Locking fix for common-code FC pass-through patch
Date: Fri, 26 Jun 2009 16:30:43 +0200
Message-ID: <20090626143517.548984000@de.ibm.com>
References: <20090626143042.117419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:58032 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760831AbZFZOfb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2009 10:35:31 -0400
Content-Disposition: inline; filename=700-fc-locking.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Fix this:
------------[ cut here ]------------
Badness at block/blk-core.c:244
CPU: 0 Tainted: G        W  2.6.31-rc1-00004-gd3a263a #3
Process zfcp_wq (pid: 901, task: 000000002fb7a038, ksp: 000000002f02bc78)
Krnl PSW : 0704300180000000 00000000002141ba (blk_remove_plug+0xb2/0xb8)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:3 PM:0 EA:3
Krnl GPRS: 0000000000000001 0000000000000001 0000000022811440 0000000022811798
           000000000027ff4e 0000000000000000 0000000000000000 000000002f00f000
           070000000006a0f4 000000002af70000 000000002af2a800 00000000228d1c00
           0000000022811440 000000000050c708 000000002f02bca8 000000002f02bc80
Krnl Code: 00000000002141b0: b9140022		lgfr	%r2,%r2
           00000000002141b4: 07fe		bcr	15,%r14
           00000000002141b6: a7f40001		brc	15,2141b8
          >00000000002141ba: a7f4ffbe		brc	15,214136
           00000000002141be: 0707		bcr	0,%r7
           00000000002141c0: ebaff0680024	stmg %r10,%r15,104(%r15)
           00000000002141c6: c0d00017c2a9	larl	%r13,50c718
           00000000002141cc: a7f13fc0		tmll	%r15,16320
Call Trace:
([<000000000050e7d8>] C.272.16122+0x88/0x110)
 [<00000000002141ec>] __blk_run_queue+0x2c/0x154
 [<000000000028013a>] fc_remote_port_add+0x85e/0x95c
 [<000000000037596e>] zfcp_scsi_rport_work+0xe6/0x148
 [<000000000006908c>] worker_thread+0x25c/0x318
 [<000000000006f10c>] kthread+0x94/0x9c
 [<000000000001c2b2>] kernel_thread_starter+0x6/0xc
 [<000000000001c2ac>] kernel_thread_starter+0x0/0xc
INFO: lockdep is turned off.
Last Breaking-Event-Address:
 [<00000000002141b6>] blk_remove_plug+0xae/0xb8

The FC pass-through support triggers the WARN_ON(!irqs_disabled()) in
blk_plug_device. Since blk_plug_device requires being called with
disabled interrupts, use spin_lock_irqsave in fc_bsg_goose_queue to
disable the interrupts before calling into the block layer.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/scsi/scsi_transport_fc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/scsi/scsi_transport_fc.c linux-2.6-patched/drivers/scsi/scsi_transport_fc.c
--- linux-2.6/drivers/scsi/scsi_transport_fc.c	2009-06-26 09:56:55.000000000 +0200
+++ linux-2.6-patched/drivers/scsi/scsi_transport_fc.c	2009-06-26 09:57:06.000000000 +0200
@@ -3670,13 +3670,14 @@ static void
 fc_bsg_goose_queue(struct fc_rport *rport)
 {
 	int flagset;
+	unsigned long flags;
 
 	if (!rport->rqst_q)
 		return;
 
 	get_device(&rport->dev);
 
-	spin_lock(rport->rqst_q->queue_lock);
+	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
 	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
 		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
 	if (flagset)
@@ -3684,7 +3685,7 @@ fc_bsg_goose_queue(struct fc_rport *rpor
 	__blk_run_queue(rport->rqst_q);
 	if (flagset)
 		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
-	spin_unlock(rport->rqst_q->queue_lock);
+	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
 
 	put_device(&rport->dev);
 }

