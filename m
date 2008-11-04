From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/8] zfcp: fix req_list_locking.
Date: Tue, 04 Nov 2008 16:35:06 +0100
Message-ID: <20081104153626.861301000@de.ibm.com>
References: <20081104153504.606043000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:58017 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYKDPga (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 10:36:30 -0500
Content-Disposition: inline; filename=718-zfcp-lockdep.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmit@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The per adapter req_list_lock must be held with interrupts disabled, otherwise
we might end up with nice deadlocks as lockdep tells us (see below).

zfcp 0.0.1804: QDIO problem occurred.

=========================================================
[ INFO: possible irq lock inversion dependency detected ]
2.6.27-rc8-00035-g4a77035-dirty #86
---------------------------------------------------------
swapper/0 just changed the state of lock:
 (&adapter->erp_lock){++..}, at: [<00000000002c82ae>] zfcp_erp_adapter_reopen+0x4e/0x8c
but this lock took another, hard-irq-unsafe lock in the past:
 (&adapter->req_list_lock){-+..}

and interrupts could create inverse lock ordering between them.

[tons of backtraces, but only the interesting part follows]

the second lock's dependencies:
-> (&adapter->req_list_lock){-+..} ops: 2280627634176 {
   initial-use  at:
                        [<0000000000071f10>] __lock_acquire+0x504/0x18bc
                        [<000000000007335c>] lock_acquire+0x94/0xbc
                        [<00000000003d7224>] _spin_lock_irqsave+0x6c/0xb0
                        [<00000000002cf684>] zfcp_fsf_req_dismiss_all+0x50/0x140
                        [<00000000002c87ee>] zfcp_erp_adapter_strategy_generic+0x66/0x3d0
                        [<00000000002c9498>] zfcp_erp_thread+0x88c/0x1318
                        [<000000000001b0d2>] kernel_thread_starter+0x6/0xc
                        [<000000000001b0cc>] kernel_thread_starter+0x0/0xc
   in-softirq-W at:
                        [<0000000000072172>] __lock_acquire+0x766/0x18bc
                        [<000000000007335c>] lock_acquire+0x94/0xbc
                        [<00000000003d7224>] _spin_lock_irqsave+0x6c/0xb0
                        [<00000000002ca73e>] zfcp_qdio_int_resp+0xbe/0x2ac
                        [<000000000027a1d6>] qdio_kick_inbound_handler+0x82/0xa0
                        [<000000000027daba>] tiqdio_inbound_processing+0x62/0xf8
                        [<0000000000047ba4>] tasklet_action+0x100/0x1f4
                        [<0000000000048b5a>] __do_softirq+0xae/0x154
                        [<0000000000021e4a>] do_softirq+0xea/0xf0
                        [<00000000000485de>] irq_exit+0xde/0xe8
                        [<0000000000268c64>] do_IRQ+0x160/0x1fc
                        [<00000000000261a2>] io_return+0x0/0x8
                        [<000000000001b8f8>] cpu_idle+0x17c/0x224
   hardirq-on-W at:
                        [<0000000000072190>] __lock_acquire+0x784/0x18bc
                        [<000000000007335c>] lock_acquire+0x94/0xbc
                        [<00000000003d702c>] _spin_lock+0x5c/0x9c
                        [<00000000002caff6>] zfcp_fsf_req_send+0x3e/0x158
                        [<00000000002ce7fe>] zfcp_fsf_exchange_config_data+0x106/0x124
                        [<00000000002c8948>] zfcp_erp_adapter_strategy_generic+0x1c0/0x3d0
                        [<00000000002c98ea>] zfcp_erp_thread+0xcde/0x1318
                        [<000000000001b0d2>] kernel_thread_starter+0x6/0xc
                        [<000000000001b0cc>] kernel_thread_starter+0x0/0xc
 }
 ... key      at: [<0000000000e356c8>] __key.26629+0x0/0x8

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmit@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-11-04 14:44:04.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-11-04 14:44:17.000000000 +0100
@@ -770,13 +770,14 @@ static int zfcp_fsf_req_send(struct zfcp
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+	unsigned long flags;
 	int idx;
 
 	/* put allocated FSF request into hash table */
-	spin_lock(&adapter->req_list_lock);
+	spin_lock_irqsave(&adapter->req_list_lock, flags);
 	idx = zfcp_reqlist_hash(req->req_id);
 	list_add_tail(&req->list, &adapter->req_list[idx]);
-	spin_unlock(&adapter->req_list_lock);
+	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
 	req->qdio_outb_usage = atomic_read(&req_q->count);
 	req->issued = get_clock();

-- 
