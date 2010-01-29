From: Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] qla2xxx: make msix interrupt handler safe for irq
Date: Fri, 29 Jan 2010 18:09:30 +0800
Message-ID: <1264759770-4093-1-git-send-email-dfeng@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932360Ab0A2KJp@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>, Santosh Vernekar <santosh.vernekar@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Yinghai has reported a lockdep warning on qla2xxx:

[   77.965784] WARNING: at kernel/lockdep.c:2332
trace_hardirqs_on_caller+0xc6/0x14b()
[   77.977492] Hardware name: Sun
[   77.979485] Modules linked in:
[   77.994337] Pid: 0, comm: swapper Not tainted
2.6.33-rc4-tip-yh-03949-g3a8e3f5-dirty #64
[   78.000120] Call Trace:
[   78.013298]  <IRQ>  [<ffffffff81076b54>] warn_slowpath_common+0x7c/0x94
[   78.017746]  [<ffffffff81cd712c>] ? _raw_spin_unlock_irq+0x30/0x36
[   78.035171]  [<ffffffff81076b80>] warn_slowpath_null+0x14/0x16
[   78.040152]  [<ffffffff810a2ae8>] trace_hardirqs_on_caller+0xc6/0x14b
[   78.055400]  [<ffffffff810a2b7a>] trace_hardirqs_on+0xd/0xf
[   78.058951]  [<ffffffff81cd712c>] _raw_spin_unlock_irq+0x30/0x36
[   78.074889]  [<ffffffff816461ef>] qla24xx_msix_default+0x243/0x281
[   78.091598]  [<ffffffff810a5752>] ? __lock_release+0xa5/0xae
[   78.096799]  [<ffffffff810c02ae>] handle_IRQ_event+0x53/0x113
[   78.111568]  [<ffffffff810c2061>] handle_edge_irq+0xf3/0x13b
[   78.116255]  [<ffffffff81035109>] handle_irq+0x24/0x2f
[   78.132063]  [<ffffffff81cdc4b4>] do_IRQ+0x5c/0xc3
[   78.134684]  [<ffffffff81cd7393>] ret_from_intr+0x0/0xf
[   78.137903]  <EOI>  [<ffffffff81039a56>] ? mwait_idle+0xaf/0xbb
[   78.155674]  [<ffffffff81039a4d>] ? mwait_idle+0xa6/0xbb
[   78.158600]  [<ffffffff81031c7c>] cpu_idle+0x61/0xa1
[   78.174333]  [<ffffffff81c85d7a>] rest_init+0x7e/0x80
[   78.178122]  [<ffffffff82832d1f>] start_kernel+0x316/0x31d
[   78.193623]  [<ffffffff82832297>] x86_64_start_reservations+0xa7/0xab
[   78.198924]  [<ffffffff8283237f>] x86_64_start_kernel+0xe4/0xeb
[   78.214540] ---[ end trace be4529f30a2e4ef5 ]---

This was happened when qla2xxx msix interrupt handler is trying to enable
IRQs by spin_unlock_irq(). We should make interrupt handler safe for IRQs,
use spin_lock_irqsave/spin_unlock_irqrestore, this will not break the IRQs
status in interrupt handler.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: Santosh Vernekar <santosh.vernekar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ffd0efd..0ced91c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1917,6 +1917,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
 	struct scsi_qla_host *vha;
+	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1927,7 +1928,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 	ha = rsp->hw;
 	reg = &ha->iobase->isp24;
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	vha = qla25xx_get_host(rsp);
 	qla24xx_process_response_queue(vha, rsp);
@@ -1935,7 +1936,7 @@ qla24xx_msix_rsp_q(int irq, void *dev_id)
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 		RD_REG_DWORD_RELAXED(&reg->hccr);
 	}
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -1946,6 +1947,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	struct qla_hw_data *ha;
 	struct rsp_que *rsp;
 	struct device_reg_24xx __iomem *reg;
+	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1958,10 +1960,10 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	/* Clear the interrupt, if enabled, for this response queue */
 	if (rsp->options & ~BIT_6) {
 		reg = &ha->iobase->isp24;
-		spin_lock_irq(&ha->hardware_lock);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 		RD_REG_DWORD_RELAXED(&reg->hccr);
-		spin_unlock_irq(&ha->hardware_lock);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 	queue_work_on((int) (rsp->id - 1), ha->wq, &rsp->q_work);
 
@@ -1979,6 +1981,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	uint32_t	stat;
 	uint32_t	hccr;
 	uint16_t	mb[4];
+	unsigned long flags;
 
 	rsp = (struct rsp_que *) dev_id;
 	if (!rsp) {
@@ -1990,7 +1993,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 	reg = &ha->iobase->isp24;
 	status = 0;
 
-	spin_lock_irq(&ha->hardware_lock);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
 	do {
 		stat = RD_REG_DWORD(&reg->host_status);
@@ -2039,7 +2042,7 @@ qla24xx_msix_default(int irq, void *dev_id)
 		}
 		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
 	} while (0);
-	spin_unlock_irq(&ha->hardware_lock);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
 	    (status & MBX_INTERRUPT) && ha->flags.mbox_int) {
-- 
1.6.6
