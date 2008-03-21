From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 3/8] mvsas : interrupt handling
Date: Fri, 21 Mar 2008 19:05:22 +0800
Message-ID: <47E39672.4080902@marvell.com>
Reply-To: kewei@marvell.com, kewei.mv@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:11952 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754387AbYCULF0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 07:05:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

When a slot is busy, we will not free this slot until slot reset is 
completed.
When unplugged the disk, we should release all command tasks with 
unplugged port that have been sent.
If MVS_USE_TASKLET is defined, we can enable tasklet. Default is off.

Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |  227 
+++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 170 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 9ebf565..f302970 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -1218,10 +1218,63 @@ static void mvs_int_port(struct mvs_info *mvi, 
int phy_no, u32 events)
 
 static void mvs_int_sata(struct mvs_info *mvi)
 {
-    /* FIXME */
+    u32 tmp;
+    void __iomem *regs = mvi->regs;
+    tmp = mr32(INT_STAT_SRS);
+    mw32(INT_STAT_SRS, tmp & 0xFFFF);
+}
+
+static void mvs_slot_reset(struct mvs_info *mvi, struct sas_task *task,
+                u32 slot_idx)
+{
+    void __iomem *regs = mvi->regs;
+    struct domain_device *dev = task->dev;
+    struct asd_sas_port *sas_port = dev->port;
+    struct mvs_port *port = mvi->slot_info[slot_idx].port;
+    u32 reg_set, phy_mask;
+
+    if (!sas_protocol_ata(task->task_proto)) {
+        reg_set = 0;
+        phy_mask = (port->wide_port_phymap) ? port->wide_port_phymap :
+                sas_port->phy_mask;
+    } else {
+        reg_set = port->taskfileset;
+        phy_mask = sas_port->phy_mask;
+    }
+    mvi->tx[mvi->tx_prod] = cpu_to_le32(TXQ_MODE_I | slot_idx |
+                    (TXQ_CMD_SLOT_RESET << TXQ_CMD_SHIFT) |
+                    (phy_mask << TXQ_PHY_SHIFT) |
+                    (reg_set << TXQ_SRS_SHIFT));
+
+    mw32(TX_PROD_IDX, mvi->tx_prod);
+    mvi->tx_prod = (mvi->tx_prod + 1) & (MVS_CHIP_SLOT_SZ - 1);
 }
 
-static void mvs_slot_free(struct mvs_info *mvi, struct sas_task *task,
+static int mvs_sata_done(struct mvs_info *mvi, struct sas_task *task,
+            u32 slot_idx, int err)
+{
+    struct mvs_port *port = mvi->slot_info[slot_idx].port;
+    struct task_status_struct *tstat = &task->task_status;
+    struct ata_task_resp *resp = (struct ata_task_resp *)tstat->buf;
+    int stat = SAM_GOOD;
+
+    resp->frame_len = sizeof(struct dev_to_host_fis);
+    memcpy(&resp->ending_fis[0],
+           SATA_RECEIVED_D2H_FIS(port->taskfileset),
+           sizeof(struct dev_to_host_fis));
+    tstat->buf_valid_size = sizeof(*resp);
+    if (unlikely(err))
+        stat = SAS_PROTO_RESPONSE;
+    return stat;
+}
+
+static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
+{
+    u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
+    mvs_tag_clear(mvi, slot_idx);
+}
+
+static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *task,
               struct mvs_slot_info *slot, u32 slot_idx)
 {
     if (!sas_protocol_ata(task->task_proto))
@@ -1244,38 +1297,58 @@ static void mvs_slot_free(struct mvs_info *mvi, 
struct sas_task *task,
         /* do nothing */
         break;
     }
-
+    list_del(&slot->list);
+    task->lldd_task = NULL;
     slot->task = NULL;
-    mvs_tag_clear(mvi, slot_idx);
+    slot->port = NULL;
 }
 
-static void mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
+static int mvs_slot_err(struct mvs_info *mvi, struct sas_task *task,
              u32 slot_idx)
 {
     struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
-    u64 err_dw0 = *(u32 *) slot->response;
-    void __iomem *regs = mvi->regs;
-    u32 tmp;
+    u32 err_dw0 = le32_to_cpu(*(u32 *) (slot->response));
+    u32 err_dw1 = le32_to_cpu(*(u32 *) (slot->response + 4));
+    int stat = SAM_CHECK_COND;
 
-    if (err_dw0 & CMD_ISS_STPD)
-        if (sas_protocol_ata(task->task_proto)) {
-            tmp = mr32(INT_STAT_SRS);
-            mw32(INT_STAT_SRS, tmp & 0xFFFF);
-        }
+    if (err_dw1 & SLOT_BSY_ERR) {
+        stat = SAS_QUEUE_FULL;
+        mvs_slot_reset(mvi, task, slot_idx);
+    }
+    switch (task->task_proto) {
+    case SAS_PROTOCOL_SSP:
+        break;
+    case SAS_PROTOCOL_SMP:
+        break;
+    case SAS_PROTOCOL_SATA:
+    case SAS_PROTOCOL_STP:
+    case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+        if (err_dw0 & TFILE_ERR)
+            stat = mvs_sata_done(mvi, task, slot_idx, 1);
+        break;
+    default:
+        break;
+    }
 
-    mvs_hba_sb_dump(mvi, slot_idx, task->task_proto);
+    mvs_hexdump(16, (u8 *) slot->response, 0);
+    return stat;
 }
 
-static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc)
+static int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
 {
     u32 slot_idx = rx_desc & RXQ_SLOT_MASK;
     struct mvs_slot_info *slot = &mvi->slot_info[slot_idx];
     struct sas_task *task = slot->task;
-    struct task_status_struct *tstat = &task->task_status;
-    struct mvs_port *port = &mvi->port[task->dev->port->id];
+    struct task_status_struct *tstat;
+    struct mvs_port *port;
     bool aborted;
     void *to;
 
+    if (unlikely(!task || !task->lldd_task))
+        return -1;
+
+    mvs_hba_cq_dump(mvi);
+
     spin_lock(&task->task_state_lock);
     aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
     if (!aborted) {
@@ -1285,22 +1358,27 @@ static int mvs_slot_complete(struct mvs_info 
*mvi, u32 rx_desc)
     }
     spin_unlock(&task->task_state_lock);
 
-    if (aborted)
+    if (aborted) {
+        mvs_slot_task_free(mvi, task, slot, slot_idx);
+        mvs_slot_free(mvi, rx_desc);
         return -1;
+    }
 
+    port = slot->port;
+    tstat = &task->task_status;
     memset(tstat, 0, sizeof(*tstat));
     tstat->resp = SAS_TASK_COMPLETE;
 
-
-    if (unlikely(!port->port_attached)) {
-        tstat->stat = SAS_PHY_DOWN;
+    if (unlikely(!port->port_attached || flags)) {
+        mvs_slot_err(mvi, task, slot_idx);
+        if (!sas_protocol_ata(task->task_proto))
+            tstat->stat = SAS_PHY_DOWN;
         goto out;
     }
 
     /* error info record present */
-    if ((rx_desc & RXQ_ERR) && (*(u64 *) slot->response)) {
-        tstat->stat = SAM_CHECK_COND;
-        mvs_slot_err(mvi, task, slot_idx);
+    if (unlikely((rx_desc & RXQ_ERR) && (*(u64 *) slot->response))) {
+        tstat->stat = mvs_slot_err(mvi, task, slot_idx);
         goto out;
     }
 
@@ -1337,21 +1415,7 @@ static int mvs_slot_complete(struct mvs_info 
*mvi, u32 rx_desc)
     case SAS_PROTOCOL_SATA:
     case SAS_PROTOCOL_STP:
     case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP: {
-            struct ata_task_resp *resp =
-                (struct ata_task_resp *)tstat->buf;
-
-            if ((rx_desc & (RXQ_DONE | RXQ_ERR | RXQ_ATTN)) ==
-                RXQ_DONE)
-                tstat->stat = SAM_GOOD;
-            else
-                tstat->stat = SAM_CHECK_COND;
-
-            resp->frame_len = sizeof(struct dev_to_host_fis);
-            memcpy(&resp->ending_fis[0],
-                   SATA_RECEIVED_D2H_FIS(port->taskfileset),
-                   sizeof(struct dev_to_host_fis));
-            if (resp->ending_fis[2] & ATA_ERR)
-                mvs_hexdump(16, resp->ending_fis, 0);
+            tstat->stat = mvs_sata_done(mvi, task, slot_idx, 0);
             break;
         }
 
@@ -1361,11 +1425,34 @@ static int mvs_slot_complete(struct mvs_info 
*mvi, u32 rx_desc)
     }
 
 out:
-    mvs_slot_free(mvi, task, slot, slot_idx);
+    mvs_slot_task_free(mvi, task, slot, slot_idx);
+    if (unlikely(tstat->stat != SAS_QUEUE_FULL))
+        mvs_slot_free(mvi, rx_desc);
+
+    spin_unlock(&mvi->lock);
     task->task_done(task);
+    spin_lock(&mvi->lock);
     return tstat->stat;
 }
 
+static void mvs_release_task(struct mvs_info *mvi, int phy_no)
+{
+    struct list_head *pos, *n;
+    struct mvs_slot_info *slot;
+    struct mvs_phy *phy = &mvi->phy[phy_no];
+    struct mvs_port *port = phy->port;
+    u32 rx_desc;
+
+    if (!port)
+        return;
+
+    list_for_each_safe(pos, n, &port->list) {
+        slot = container_of(pos, struct mvs_slot_info, list);
+        rx_desc = (u32) (slot - mvi->slot_info);
+        mvs_slot_complete(mvi, rx_desc, 1);
+    }
+}
+
 static void mvs_int_full(struct mvs_info *mvi)
 {
     void __iomem *regs = mvi->regs;
@@ -1400,40 +1487,43 @@ static int mvs_int_rx(struct mvs_info *mvi, bool 
self_clear)
      * we don't have to stall the CPU reading that register.
      * The actual RX ring is offset by one dword, due to this.
      */
-    rx_prod_idx = mr32(RX_CONS_IDX) & RX_RING_SZ_MASK;
-    if (rx_prod_idx == 0xfff) {    /* h/w hasn't touched RX ring yet */
-        mvi->rx_cons = 0xfff;
+    rx_prod_idx = mvi->rx_cons;
+    mvi->rx_cons = le32_to_cpu(mvi->rx[0]);
+    if (mvi->rx_cons == 0xfff)    /* h/w hasn't touched RX ring yet */
         return 0;
-    }
 
     /* The CMPL_Q may come late, read from register and try again
     * note: if coalescing is enabled,
     * it will need to read from register every time for sure
     */
     if (mvi->rx_cons == rx_prod_idx)
-        return 0;
+        mvi->rx_cons = mr32(RX_CONS_IDX) & RX_RING_SZ_MASK;
 
-    if (mvi->rx_cons == 0xfff)
-        mvi->rx_cons = MVS_RX_RING_SZ - 1;
+    if (mvi->rx_cons == rx_prod_idx)
+        return 0;
 
     while (mvi->rx_cons != rx_prod_idx) {
 
         /* increment our internal RX consumer pointer */
-        mvi->rx_cons = (mvi->rx_cons + 1) & (MVS_RX_RING_SZ - 1);
-
-        rx_desc = le32_to_cpu(mvi->rx[mvi->rx_cons + 1]);
+        rx_prod_idx = (rx_prod_idx + 1) & (MVS_RX_RING_SZ - 1);
 
-        mvs_hba_cq_dump(mvi);
+        rx_desc = le32_to_cpu(mvi->rx[rx_prod_idx + 1]);
 
         if (likely(rx_desc & RXQ_DONE))
-            mvs_slot_complete(mvi, rx_desc);
+            mvs_slot_complete(mvi, rx_desc, 0);
         if (rx_desc & RXQ_ATTN) {
             attn = true;
             dev_printk(KERN_DEBUG, &pdev->dev, "ATTN %X\n",
                 rx_desc);
         } else if (rx_desc & RXQ_ERR) {
+            if (!(rx_desc & RXQ_DONE))
+                mvs_slot_complete(mvi, rx_desc, 0);
             dev_printk(KERN_DEBUG, &pdev->dev, "RXQ_ERR %X\n",
                 rx_desc);
+        } else if (rx_desc & RXQ_SLOT_RESET) {
+            dev_printk(KERN_DEBUG, &pdev->dev, "Slot reset[%X]\n",
+                rx_desc);
+            mvs_slot_free(mvi, rx_desc);
         }
     }
 
@@ -1443,6 +1533,23 @@ static int mvs_int_rx(struct mvs_info *mvi, bool 
self_clear)
     return 0;
 }
 
+#ifdef MVS_USE_TASKLET
+static void mvs_tasklet(unsigned long data)
+{
+    struct mvs_info *mvi = (struct mvs_info *) data;
+    unsigned long flags;
+
+    spin_lock_irqsave(&mvi->lock, flags);
+
+#ifdef MVS_DISABLE_MSI
+    mvs_int_full(mvi);
+#else
+    mvs_int_rx(mvi, true);
+#endif
+    spin_unlock_irqrestore(&mvi->lock, flags);
+}
+#endif
+
 static irqreturn_t mvs_interrupt(int irq, void *opaque)
 {
     struct mvs_info *mvi = opaque;
@@ -1451,18 +1558,21 @@ static irqreturn_t mvs_interrupt(int irq, void 
*opaque)
 
     stat = mr32(GBL_INT_STAT);
 
-    /* clear CMD_CMPLT ASAP */
-    mw32_f(INT_STAT, CINT_DONE);
-
     if (stat == 0 || stat == 0xffffffff)
         return IRQ_NONE;
 
+    /* clear CMD_CMPLT ASAP */
+    mw32_f(INT_STAT, CINT_DONE);
+
+#ifndef MVS_USE_TASKLET
     spin_lock(&mvi->lock);
 
     mvs_int_full(mvi);
 
     spin_unlock(&mvi->lock);
-
+#else
+    tasklet_schedule(&mvi->tasklet);
+#endif
     return IRQ_HANDLED;
 }
 
@@ -1471,12 +1581,15 @@ static irqreturn_t mvs_msi_interrupt(int irq, 
void *opaque)
 {
     struct mvs_info *mvi = opaque;
 
+#ifndef MVS_USE_TASKLET
     spin_lock(&mvi->lock);
 
     mvs_int_rx(mvi, true);
 
     spin_unlock(&mvi->lock);
-
+#else
+    tasklet_schedule(&mvi->tasklet);
+#endif
     return IRQ_HANDLED;
 }
 #endif
-- 
1.5.4

