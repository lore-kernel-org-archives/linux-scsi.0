From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 2/2] zfcp: fix incorrect usage of fsf_req_list_lock
Date: Mon, 3 Jul 2006 16:52:40 +0200
Message-ID: <20060703145240.GE9420@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58487 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750808AbWGCOxj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jul 2006 10:53:39 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.6/8.13.6) with ESMTP id k63ErcqK073438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jul 2006 14:53:38 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k63EuIxW102564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jul 2006 16:56:18 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k63EraEJ030427
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jul 2006 16:53:37 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>
Cc: Andreas Herrmann <aherrman@de.ibm.com>, Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org

=================================
[ INFO: inconsistent lock state ]
---------------------------------
inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
swapper/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
 (&adapter->fsf_req_list_lock){++..}, at: [<0000000000274486>] zfcp_qdio_reqid_check+0x46/0x178
{in-hardirq-W} state was registered at:
  [<000000000005fb0c>] __lock_acquire+0xad8/0xed0
  [<00000000000604ae>] lock_acquire+0x9a/0xc8
  [<000000000035a326>] _spin_lock+0x4e/0x68
  [<0000000000274486>] zfcp_qdio_reqid_check+0x46/0x178
  [<000000000027469e>] zfcp_qdio_response_handler+0xe6/0x430
  [<0000000000219dd4>] tiqdio_thinint_handler+0xd20/0x213c
  [<000000000020229a>] do_adapter_IO+0xb2/0xc0
  [<0000000000206f32>] do_IRQ+0x136/0x16c
  [<0000000000020462>] io_no_vtime+0x16/0x1c
  [<0000000000019432>] cpu_idle+0x222/0x250
irq event stamp: 129220
hardirqs last  enabled at (129220): [<00000000000411e6>] tasklet_hi_action+0x5a/0x19c
hardirqs last disabled at (129219): [<00000000000411c0>] tasklet_hi_action+0x34/0x19c
softirqs last  enabled at (129212): [<0000000000040b62>] __do_softirq+0x13a/0x180
softirqs last disabled at (129217): [<000000000001fd58>] do_softirq+0xec/0xf0

other info that might help us debug this:
no locks held by swapper/0.

stack backtrace:
00000000012bb670 0000000000000002 0000000000000000 00000000012bb780 
       00000000012bb6e8 0000000000399122 0000000000399122 0000000000016b0a 
       0000000000000000 0000000000000000 0000000000000000 00000000004660e8 
       0000000000000000 000000000000000d 00000000012bb6e0 00000000012bb758 
       0000000000368b90 0000000000016b0a 00000000012bb6e0 00000000012bb730 
Call Trace:
([<0000000000016a26>] show_trace+0x76/0xdc)
 [<0000000000016b2c>] show_stack+0xa0/0xd0
 [<0000000000016b8a>] dump_stack+0x2e/0x3c
 [<000000000005e3da>] print_usage_bug+0x27e/0x290
 [<000000000005ea9c>] mark_lock+0x6b0/0x6c0
 [<000000000005f33e>] __lock_acquire+0x30a/0xed0
 [<00000000000604ae>] lock_acquire+0x9a/0xc8
 [<000000000035a326>] _spin_lock+0x4e/0x68
 [<0000000000274486>] zfcp_qdio_reqid_check+0x46/0x178
 [<000000000027469e>] zfcp_qdio_response_handler+0xe6/0x430
 [<0000000000217bd2>] tiqdio_tl+0xd02/0x2120
 [<000000000004123a>] tasklet_hi_action+0xae/0x19c
 [<0000000000040ae4>] __do_softirq+0xbc/0x180
 [<000000000001fd58>] do_softirq+0xec/0xf0
 [<0000000000040c38>] irq_exit+0x90/0xa8
 [<0000000000206f40>] do_IRQ+0x144/0x16c
 [<0000000000020462>] io_no_vtime+0x16/0x1c
 [<0000000000019432>] cpu_idle+0x222/0x250
([<0000000000019416>] cpu_idle+0x206/0x250)
 [<000000000001405a>] rest_init+0x5a/0x68
 [<0000000000536998>] start_kernel+0x39c/0x3dc
 [<0000000000013046>] _stext+0x46/0x1000

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fix incorrect usage of fsf_req_list_lock. It's used in tasklet context
(irqs on) as well as in irq context. Therefore use the spin_lock_irqsave
variant to avoid deadlocks.

Acked-by: Andreas Herrmann <aherrman@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/scsi/zfcp_qdio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_qdio.c b/drivers/s390/scsi/zfcp_qdio.c
index 345a191..49ea5ad 100644
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -427,6 +427,7 @@ int
 zfcp_qdio_reqid_check(struct zfcp_adapter *adapter, void *sbale_addr)
 {
 	struct zfcp_fsf_req *fsf_req;
+	unsigned long flags;
 
 	/* invalid (per convention used in this driver) */
 	if (unlikely(!sbale_addr)) {
@@ -438,15 +439,15 @@ zfcp_qdio_reqid_check(struct zfcp_adapte
 	fsf_req = (struct zfcp_fsf_req *) sbale_addr;
 
 	/* serialize with zfcp_fsf_req_dismiss_all */
-	spin_lock(&adapter->fsf_req_list_lock);
+	spin_lock_irqsave(&adapter->fsf_req_list_lock, flags);
 	if (list_empty(&adapter->fsf_req_list_head)) {
-		spin_unlock(&adapter->fsf_req_list_lock);
+		spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
 		return 0;
 	}
 	list_del(&fsf_req->list);
 	atomic_dec(&adapter->fsf_reqs_active);
-	spin_unlock(&adapter->fsf_req_list_lock);
-	
+	spin_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
+
 	if (unlikely(adapter != fsf_req->adapter)) {
 		ZFCP_LOG_NORMAL("bug: invalid reqid (fsf_req=%p, "
 				"fsf_req->adapter=%p, adapter=%p)\n",
