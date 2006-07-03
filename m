From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 1/2] zfcp: fix incorrect usage of erp_lock
Date: Mon, 3 Jul 2006 16:51:45 +0200
Message-ID: <20060703145145.GD9420@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:42871 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750803AbWGCOwo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jul 2006 10:52:44 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate5.de.ibm.com (8.13.6/8.13.6) with ESMTP id k63EqhHQ118418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jul 2006 14:52:43 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k63EtNNI136316
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jul 2006 16:55:23 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k63Eqg7W011930
	for <linux-scsi@vger.kernel.org>; Mon, 3 Jul 2006 16:52:42 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>
Cc: Andreas Herrmann <aherrman@de.ibm.com>, Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org

=================================
[ INFO: inconsistent lock state ]
---------------------------------
inconsistent {hardirq-on-W} -> {in-hardirq-W} usage.
swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 (&adapter->erp_lock){+-..}, at: [<000000000026c7f8>] zfcp_erp_async_handler+0x3c/0x70
{hardirq-on-W} state was registered at:
  [<000000000005f33e>] __lock_acquire+0x30a/0xed0
  [<00000000000604ae>] lock_acquire+0x9a/0xc8
  [<000000000035a7ae>] _write_lock+0x4e/0x68
  [<000000000026d822>] zfcp_erp_adapter_strategy_generic+0x286/0xd94
  [<000000000026fd72>] zfcp_erp_strategy_do_action+0x91e/0x1a94
  [<0000000000271a3a>] zfcp_erp_thread+0x21a/0x1568
  [<0000000000019096>] kernel_thread_starter+0x6/0xc
  [<0000000000019090>] kernel_thread_starter+0x0/0xc
irq event stamp: 12078
hardirqs last  enabled at (12077): [<0000000000019416>] cpu_idle+0x206/0x250
hardirqs last disabled at (12078): [<0000000000020458>] io_no_vtime+0xc/0x1c
softirqs last  enabled at (12072): [<0000000000040b62>] __do_softirq+0x13a/0x180
softirqs last disabled at (12059): [<000000000001fd58>] do_softirq+0xec/0xf0

other info that might help us debug this:
no locks held by swapper/0.

stack backtrace:
00000000012bb648 0000000000000002 0000000000000000 00000000012bb758 
       00000000012bb6c0 0000000000399122 0000000000399122 0000000000016b0a 
       0000000000000000 0000000000000001 0000000000000000 00000000004660e8 
       0000000000000000 000000000000000d 00000000012bb6b8 00000000012bb730 
       0000000000368b90 0000000000016b0a 00000000012bb6b8 00000000012bb708 
Call Trace:
([<0000000000016a26>] show_trace+0x76/0xdc)
 [<0000000000016b2c>] show_stack+0xa0/0xd0
 [<0000000000016b8a>] dump_stack+0x2e/0x3c
 [<000000000005e3da>] print_usage_bug+0x27e/0x290
 [<000000000005e934>] mark_lock+0x548/0x6c0
 [<000000000005fb0c>] __lock_acquire+0xad8/0xed0
 [<00000000000604ae>] lock_acquire+0x9a/0xc8
 [<000000000035a662>] _write_lock_irqsave+0x62/0x80
 [<000000000026c7f8>] zfcp_erp_async_handler+0x3c/0x70
 [<0000000000279178>] zfcp_fsf_req_dispatch+0xd8/0x1fa8
 [<000000000027e538>] zfcp_fsf_req_complete+0x104/0xe4c
 [<0000000000274534>] zfcp_qdio_reqid_check+0xf4/0x178
 [<000000000027469e>] zfcp_qdio_response_handler+0xe6/0x430
 [<0000000000219dd4>] tiqdio_thinint_handler+0xd20/0x213c
 [<000000000020229a>] do_adapter_IO+0xb2/0xc0
 [<0000000000206f32>] do_IRQ+0x136/0x16c
 [<0000000000020462>] io_no_vtime+0x16/0x1c
 [<0000000000019432>] cpu_idle+0x222/0x250
([<0000000000019416>] cpu_idle+0x206/0x250)
 [<000000000001405a>] rest_init+0x5a/0x68
 [<0000000000536998>] start_kernel+0x39c/0x3dc
 [<0000000000013046>] _stext+0x46/0x1000

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fix incorrect usage of erp_lock. Using the write_lock() variant is wrong,
since this might lead to deadlocks.

Acked-by: Andreas Herrmann <aherrman@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 909731b..8ec8da0 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -2168,9 +2168,9 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
 				  &adapter->status);
 		ZFCP_LOG_DEBUG("Doing exchange config data\n");
-		write_lock(&adapter->erp_lock);
+		write_lock_irq(&adapter->erp_lock);
 		zfcp_erp_action_to_running(erp_action);
-		write_unlock(&adapter->erp_lock);
+		write_unlock_irq(&adapter->erp_lock);
 		zfcp_erp_timeout_init(erp_action);
 		if (zfcp_fsf_exchange_config_data(erp_action)) {
 			retval = ZFCP_ERP_FAILED;
@@ -2236,9 +2236,9 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 	adapter = erp_action->adapter;
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
 
-	write_lock(&adapter->erp_lock);
+	write_lock_irq(&adapter->erp_lock);
 	zfcp_erp_action_to_running(erp_action);
-	write_unlock(&adapter->erp_lock);
+	write_unlock_irq(&adapter->erp_lock);
 
 	zfcp_erp_timeout_init(erp_action);
 	ret = zfcp_fsf_exchange_port_data(erp_action, adapter, NULL);
