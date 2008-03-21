From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 6/8] mvsas: fix the buffer of rx DMA overflow bug
Date: Fri, 21 Mar 2008 19:06:29 +0800
Message-ID: <47E396B5.1050407@marvell.com>
Reply-To: kewei@marvell.com, kewei.mv@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:11994 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754533AbYCULGd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 07:06:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

fix the buffer of rx DMA overflow bug.
fix default queue depth.


Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index f4f7b0a..761beeb 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2240,7 +2240,7 @@ static void mvs_free(struct mvs_info *mvi)
                   mvi->rx_fis, mvi->rx_fis_dma);
     if (mvi->rx)
         dma_free_coherent(&mvi->pdev->dev,
-                  sizeof(*mvi->rx) * MVS_RX_RING_SZ,
+                  sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
                   mvi->rx, mvi->rx_dma);
     if (mvi->slot)
         dma_free_coherent(&mvi->pdev->dev,
@@ -2348,6 +2348,9 @@ static struct mvs_info *__devinit mvs_alloc(struct 
pci_dev *pdev,
         return NULL;
 
     spin_lock_init(&mvi->lock);
+#ifdef MVS_USE_TASKLET
+    tasklet_init(&mvi->tasklet, mvs_tasklet, (unsigned long)mvi);
+#endif
     mvi->pdev = pdev;
     mvi->chip = chip;
 
@@ -2371,6 +2374,10 @@ static struct mvs_info *__devinit 
mvs_alloc(struct pci_dev *pdev,
         mvs_phy_init(mvi, i);
         arr_phy[i] = &mvi->phy[i].sas_phy;
         arr_port[i] = &mvi->port[i].sas_port;
+        mvi->port[i].taskfileset = MVS_ID_NOT_MAPPED;
+        mvi->port[i].wide_port_phymap = 0;
+        mvi->port[i].port_attached = 0;
+        INIT_LIST_HEAD(&mvi->port[i].list);
     }
 
     SHOST_TO_SAS_HA(mvi->shost) = &mvi->sas;
@@ -2387,9 +2394,10 @@ static struct mvs_info *__devinit 
mvs_alloc(struct pci_dev *pdev,
     mvi->sas.sas_phy = arr_phy;
     mvi->sas.sas_port = arr_port;
     mvi->sas.num_phys = chip->n_phy;
-    mvi->sas.lldd_max_execute_num = MVS_CHIP_SLOT_SZ - 1;
+    mvi->sas.lldd_max_execute_num = 1;
     mvi->sas.lldd_queue_size = MVS_QUEUE_SIZE;
-    mvi->can_queue = (MVS_CHIP_SLOT_SZ >> 1) - 1;
+    mvi->shost->can_queue = MVS_CAN_QUEUE;
+    mvi->shost->cmd_per_lun = MVS_SLOTS / mvi->sas.num_phys;
     mvi->sas.lldd_ha = mvi;
     mvi->sas.core.shost = mvi->shost;
 
@@ -2442,11 +2450,11 @@ static struct mvs_info *__devinit 
mvs_alloc(struct pci_dev *pdev,
     memset(mvi->rx_fis, 0, MVS_RX_FISL_SZ);
 
     mvi->rx = dma_alloc_coherent(&pdev->dev,
-                     sizeof(*mvi->rx) * MVS_RX_RING_SZ,
+                     sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1),
                      &mvi->rx_dma, GFP_KERNEL);
     if (!mvi->rx)
         goto err_out;
-    memset(mvi->rx, 0, sizeof(*mvi->rx) * MVS_RX_RING_SZ);
+    memset(mvi->rx, 0, sizeof(*mvi->rx) * (MVS_RX_RING_SZ + 1));
 
     mvi->rx[0] = cpu_to_le32(0xfff);
     mvi->rx_cons = 0xfff;
@@ -2596,7 +2604,7 @@ static void __devinit mvs_phy_hacks(struct 
mvs_info *mvi)
     mvs_cw32(regs, CMD_SAS_CTL0, tmp);
 
     /* workaround for WDTIMEOUT , set to 550 ms */
-    mvs_cw32(regs, CMD_WD_TIMER, 0xffffff);
+    mvs_cw32(regs, CMD_WD_TIMER, 0x86470);
 
     /* not to halt for different port op during wideport link change */
     mvs_cw32(regs, CMD_APP_ERR_CONFIG, 0xffefbf7d);
@@ -2704,17 +2712,16 @@ static u32 mvs_is_phy_ready(struct mvs_info 
*mvi, int i)
 {
     u32 tmp;
     struct mvs_phy *phy = &mvi->phy[i];
-    struct mvs_port *port;
+    struct mvs_port *port = phy->port;;
 
     tmp = mvs_read_phy_ctl(mvi, i);
 
     if ((tmp & PHY_READY_MASK) && !(phy->irq_status & PHYEV_POOF)) {
-        if (!phy->port)
+        if (!port)
             phy->phy_attached = 1;
         return tmp;
     }
 
-    port = phy->port;
     if (port) {
         if (phy->phy_type & PORT_TYPE_SAS) {
             port->wide_port_phymap &= ~(1U << i);
-- 
1.5.4


