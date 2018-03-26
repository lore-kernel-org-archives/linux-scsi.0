From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH v3 41/41] cxlflash: Handle spurious interrupts
Date: Mon, 26 Mar 2018 11:35:42 -0500
Message-ID: <1522082142-58975-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1522081759-57431-1-git-send-email-ukrishn@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

The following Oops can occur when there is heavy I/O traffic and the host
is reset by a tool such as sg_reset.

[c000200fff3fbc90] c00800001690117c process_cmd_doneq+0x104/0x500
                                       [cxlflash] (unreliable)
[c000200fff3fbd80] c008000016901648 cxlflash_rrq_irq+0xd0/0x150 [cxlflash]
[c000200fff3fbde0] c000000000193130 __handle_irq_event_percpu+0xa0/0x310
[c000200fff3fbea0] c0000000001933d8 handle_irq_event_percpu+0x38/0x90
[c000200fff3fbee0] c000000000193494 handle_irq_event+0x64/0xb0
[c000200fff3fbf10] c000000000198ea0 handle_fasteoi_irq+0xc0/0x230
[c000200fff3fbf40] c00000000019182c generic_handle_irq+0x4c/0x70
[c000200fff3fbf60] c00000000001794c __do_irq+0x7c/0x1c0
[c000200fff3fbf90] c00000000002a390 call_do_irq+0x14/0x24
[c000200e5828fab0] c000000000017b2c do_IRQ+0x9c/0x130
[c000200e5828fb00] c000000000009b04 h_virt_irq_common+0x114/0x120

When a context is reset, the pending commands are flushed and the AFU
is notified. Before the AFU handles this request there could be command
completion interrupts queued to PHB which are yet to be delivered to the
context. In this scenario, a context could receive an interrupt for a
command that has been flushed, leading to a possible crash when the memory
for the flushed command is accessed.

To resolve this problem, a boolean will indicate if the hardware queue is
ready to process interrupts or not. This can be evaluated in the interrupt
handler before proessing an interrupt.

Signed-off-by: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/common.h |  1 +
 drivers/scsi/cxlflash/main.c   | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index b69fd32..3556b1d 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -224,6 +224,7 @@ struct hwq {
 	u64 *hrrq_end;
 	u64 *hrrq_curr;
 	bool toggle;
+	bool hrrq_online;
 
 	s64 room;
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index c920328..a24d7e6 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -801,6 +801,10 @@ static void term_mc(struct cxlflash_cfg *cfg, u32 index)
 		WARN_ON(cfg->ops->release_context(hwq->ctx_cookie));
 	hwq->ctx_cookie = NULL;
 
+	spin_lock_irqsave(&hwq->hrrq_slock, lock_flags);
+	hwq->hrrq_online = false;
+	spin_unlock_irqrestore(&hwq->hrrq_slock, lock_flags);
+
 	spin_lock_irqsave(&hwq->hsq_slock, lock_flags);
 	flush_pending_cmds(hwq);
 	spin_unlock_irqrestore(&hwq->hsq_slock, lock_flags);
@@ -1475,6 +1479,12 @@ static irqreturn_t cxlflash_rrq_irq(int irq, void *data)
 
 	spin_lock_irqsave(&hwq->hrrq_slock, hrrq_flags);
 
+	/* Silently drop spurious interrupts when queue is not online */
+	if (!hwq->hrrq_online) {
+		spin_unlock_irqrestore(&hwq->hrrq_slock, hrrq_flags);
+		return IRQ_HANDLED;
+	}
+
 	if (afu_is_irqpoll_enabled(afu)) {
 		irq_poll_sched(&hwq->irqpoll);
 		spin_unlock_irqrestore(&hwq->hrrq_slock, hrrq_flags);
@@ -1781,6 +1791,7 @@ static int init_global(struct cxlflash_cfg *cfg)
 
 		writeq_be((u64) hwq->hrrq_start, &hmap->rrq_start);
 		writeq_be((u64) hwq->hrrq_end, &hmap->rrq_end);
+		hwq->hrrq_online = true;
 
 		if (afu_is_sq_cmd_mode(afu)) {
 			writeq_be((u64)hwq->hsq_start, &hmap->sq_start);
-- 
2.1.0
