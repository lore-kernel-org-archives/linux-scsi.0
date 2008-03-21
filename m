From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 2/8] mvsas: a tag handler implementation
Date: Fri, 21 Mar 2008 19:03:19 +0800
Message-ID: <47E395F7.5000102@marvell.com>
Reply-To: kewei@marvell.com, kewei.mv@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:11892 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753973AbYCULDW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 07:03:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

add a new tag handler to create slot num. When a slot num is busy, task 
will not hit the bit which was used.
plumb in phy speeds.


Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |  130 
+++++++++++++++++++++++++++++++++----------------
 1 files changed, 87 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 3a447fe..9ebf565 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -760,10 +760,10 @@ static void mvs_hexdump(u32 size, u8 *data, u32 
baseaddr)
     printk("\n");
 }
 
+#if _MV_DUMP
 static void mvs_hba_sb_dump(struct mvs_info *mvi, u32 tag,
                    enum sas_protocol proto)
 {
-#if _MV_DUMP
     u32 offset;
     struct pci_dev *pdev = mvi->pdev;
     struct mvs_slot_info *slot = &mvi->slot_info[tag];
@@ -774,14 +774,14 @@ static void mvs_hba_sb_dump(struct mvs_info *mvi, 
u32 tag,
             tag);
     mvs_hexdump(32, (u8 *) slot->response,
             (u32) slot->buf_dma + offset);
-#endif
 }
+#endif
 
 static void mvs_hba_memory_dump(struct mvs_info *mvi, u32 tag,
                 enum sas_protocol proto)
 {
 #if _MV_DUMP
-    u32 sz, w_ptr, r_ptr;
+    u32 sz, w_ptr;
     u64 addr;
     void __iomem *regs = mvi->regs;
     struct pci_dev *pdev = mvi->pdev;
@@ -789,12 +789,10 @@ static void mvs_hba_memory_dump(struct mvs_info 
*mvi, u32 tag,
 
     /*Delivery Queue */
     sz = mr32(TX_CFG) & TX_RING_SZ_MASK;
-    w_ptr = mr32(TX_PROD_IDX) & TX_RING_SZ_MASK;
-    r_ptr = mr32(TX_CONS_IDX) & TX_RING_SZ_MASK;
+    w_ptr = slot->tx;
     addr = mr32(TX_HI) << 16 << 16 | mr32(TX_LO);
     dev_printk(KERN_DEBUG, &pdev->dev,
-        "Delivery Queue Size=%04d , WRT_PTR=%04X , RD_PTR=%04X\n",
-        sz, w_ptr, r_ptr);
+        "Delivery Queue Size=%04d , WRT_PTR=%04X\n", sz, w_ptr);
     dev_printk(KERN_DEBUG, &pdev->dev,
         "Delivery Queue Base Address=0x%llX (PA)"
         "(tx_dma=0x%llX), Entry=%04d\n",
@@ -802,11 +800,11 @@ static void mvs_hba_memory_dump(struct mvs_info 
*mvi, u32 tag,
     mvs_hexdump(sizeof(u32), (u8 *)(&mvi->tx[mvi->tx_prod]),
             (u32) mvi->tx_dma + sizeof(u32) * w_ptr);
     /*Command List */
-    addr = mr32(CMD_LIST_HI) << 16 << 16 | mr32(CMD_LIST_LO);
+    addr = mvi->slot_dma;
     dev_printk(KERN_DEBUG, &pdev->dev,
         "Command List Base Address=0x%llX (PA)"
         "(slot_dma=0x%llX), Header=%03d\n",
-        addr, mvi->slot_dma, tag);
+        addr, slot->buf_dma, tag);
     dev_printk(KERN_DEBUG, &pdev->dev, "Command Header[%03d]:\n", tag);
     /*mvs_cmd_hdr */
     mvs_hexdump(sizeof(struct mvs_cmd_hdr), (u8 *)(&mvi->slot[tag]),
@@ -830,7 +828,7 @@ static void mvs_hba_memory_dump(struct mvs_info 
*mvi, u32 tag,
 
 static void mvs_hba_cq_dump(struct mvs_info *mvi)
 {
-#if _MV_DUMP
+#if (_MV_DUMP > 2)
     u64 addr;
     void __iomem *regs = mvi->regs;
     struct pci_dev *pdev = mvi->pdev;
@@ -839,8 +837,8 @@ static void mvs_hba_cq_dump(struct mvs_info *mvi)
 
     /*Completion Queue */
     addr = mr32(RX_HI) << 16 << 16 | mr32(RX_LO);
-    dev_printk(KERN_DEBUG, &pdev->dev, "Completion Task = 0x%08X\n",
-           (u32) mvi->slot_info[rx_desc & RXQ_SLOT_MASK].task);
+    dev_printk(KERN_DEBUG, &pdev->dev, "Completion Task = 0x%p\n",
+           mvi->slot_info[rx_desc & RXQ_SLOT_MASK].task);
     dev_printk(KERN_DEBUG, &pdev->dev,
         "Completion List Base Address=0x%llX (PA), "
         "CQ_Entry=%04d, CQ_WP=0x%08X\n",
@@ -905,34 +903,53 @@ static int pci_go_64(struct pci_dev *pdev)
     return rc;
 }
 
+static int mvs_find_tag(struct mvs_info *mvi, struct sas_task *task, 
u32 *tag)
+{
+    if (task->lldd_task) {
+        struct mvs_slot_info *slot;
+        slot = (struct mvs_slot_info *) task->lldd_task;
+        *tag = slot - mvi->slot_info;
+        return 1;
+    }
+    return 0;
+}
+
 static void mvs_tag_clear(struct mvs_info *mvi, u32 tag)
 {
-    mvi->tag_in = (mvi->tag_in + 1) & (MVS_SLOTS - 1);
-    mvi->tags[mvi->tag_in] = tag;
+    void *bitmap = (void *) &mvi->tags;
+    clear_bit(tag, bitmap);
 }
 
 static void mvs_tag_free(struct mvs_info *mvi, u32 tag)
 {
-    mvi->tag_out = (mvi->tag_out - 1) & (MVS_SLOTS - 1);
+    mvs_tag_clear(mvi, tag);
+}
+
+static void mvs_tag_set(struct mvs_info *mvi, unsigned int tag)
+{
+    void *bitmap = (void *) &mvi->tags;
+    set_bit(tag, bitmap);
 }
 
 static int mvs_tag_alloc(struct mvs_info *mvi, u32 *tag_out)
 {
-    if (mvi->tag_out != mvi->tag_in) {
-        *tag_out = mvi->tags[mvi->tag_out];
-        mvi->tag_out = (mvi->tag_out + 1) & (MVS_SLOTS - 1);
-        return 0;
-    }
-    return -EBUSY;
+    unsigned int index, tag;
+    void *bitmap = (void *) &mvi->tags;
+
+    index = find_first_zero_bit(bitmap, MVS_SLOTS);
+    tag = index;
+    if (tag >= MVS_SLOTS)
+        return -SAS_QUEUE_FULL;
+    mvs_tag_set(mvi, tag);
+    *tag_out = tag;
+    return 0;
 }
 
 static void mvs_tag_init(struct mvs_info *mvi)
 {
     int i;
     for (i = 0; i < MVS_SLOTS; ++i)
-        mvi->tags[i] = i;
-    mvi->tag_out = 0;
-    mvi->tag_in = MVS_SLOTS - 1;
+        mvs_tag_clear(mvi, i);
 }
 
 #ifndef MVS_DISABLE_NVRAM
@@ -1064,10 +1081,21 @@ err_out:
 static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 {
     struct mvs_phy *phy = &mvi->phy[i];
+    struct asd_sas_phy *sas_phy = mvi->sas.sas_phy[i];
 
     if (!phy->phy_attached)
         return;
 
+    if (sas_phy->phy) {
+        struct sas_phy *sphy = sas_phy->phy;
+
+        sphy->negotiated_linkrate = sas_phy->linkrate;
+        sphy->minimum_linkrate = phy->minimum_linkrate;
+        sphy->minimum_linkrate_hw = SAS_LINK_RATE_1_5_GBPS;
+        sphy->maximum_linkrate = phy->maximum_linkrate;
+        sphy->maximum_linkrate_hw = SAS_LINK_RATE_3_0_GBPS;
+    }
+
     if (phy->phy_type & PORT_TYPE_SAS) {
         struct sas_identify_frame *id;
 
@@ -1104,72 +1132,88 @@ static void mvs_scan_start(struct Scsi_Host *shost)
     }
 }
 
-static int mvs_sas_slave_alloc(struct scsi_device *scsi_dev)
+static int mvs_slave_configure(struct scsi_device *sdev)
 {
-    int rc;
+    struct domain_device *dev = sdev_to_domain_dev(sdev);
+    int ret = sas_slave_configure(sdev);
 
-    rc = sas_slave_alloc(scsi_dev);
+    if (ret)
+        return ret;
 
-    return rc;
+    if (dev_is_sata(dev)) {
+        /* struct ata_port *ap = dev->sata_dev.ap; */
+        /* struct ata_device *adev = ap->link.device; */
+
+        /* clamp at no NCQ for the time being */
+        /* adev->flags |= ATA_DFLAG_NCQ_OFF; */
+        scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, 1);
+    }
+    return 0;
 }
 
-static void mvs_int_port(struct mvs_info *mvi, int port_no, u32 events)
+static void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 {
     struct pci_dev *pdev = mvi->pdev;
     struct sas_ha_struct *sas_ha = &mvi->sas;
-    struct mvs_phy *phy = &mvi->phy[port_no];
+    struct mvs_phy *phy = &mvi->phy[phy_no];
     struct asd_sas_phy *sas_phy = &phy->sas_phy;
 
-    phy->irq_status = mvs_read_port_irq_stat(mvi, port_no);
+    phy->irq_status = mvs_read_port_irq_stat(mvi, phy_no);
     /*
     * events is port event now ,
     * we need check the interrupt status which belongs to per port.
     */
     dev_printk(KERN_DEBUG, &pdev->dev,
         "Port %d Event = %X\n",
-        port_no, phy->irq_status);
+        phy_no, phy->irq_status);
 
     if (phy->irq_status & (PHYEV_POOF | PHYEV_DEC_ERR)) {
-        if (!mvs_is_phy_ready(mvi, port_no)) {
+        mvs_release_task(mvi, phy_no);
+        if (!mvs_is_phy_ready(mvi, phy_no)) {
             sas_phy_disconnected(sas_phy);
             sas_ha->notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
+            dev_printk(KERN_INFO, &pdev->dev,
+                "Port %d Unplug Notice\n", phy_no);
+
         } else
             mvs_phy_control(sas_phy, PHY_FUNC_LINK_RESET, NULL);
     }
     if (!(phy->irq_status & PHYEV_DEC_ERR)) {
         if (phy->irq_status & PHYEV_COMWAKE) {
-            u32 tmp = mvs_read_port_irq_mask(mvi, port_no);
-            mvs_write_port_irq_mask(mvi, port_no,
+            u32 tmp = mvs_read_port_irq_mask(mvi, phy_no);
+            mvs_write_port_irq_mask(mvi, phy_no,
                         tmp | PHYEV_SIG_FIS);
         }
         if (phy->irq_status & (PHYEV_SIG_FIS | PHYEV_ID_DONE)) {
-            phy->phy_status = mvs_is_phy_ready(mvi, port_no);
+            phy->phy_status = mvs_is_phy_ready(mvi, phy_no);
             if (phy->phy_status) {
-                mvs_detect_porttype(mvi, port_no);
+                mvs_detect_porttype(mvi, phy_no);
 
                 if (phy->phy_type & PORT_TYPE_SATA) {
                     u32 tmp = mvs_read_port_irq_mask(mvi,
-                                port_no);
+                                phy_no);
                     tmp &= ~PHYEV_SIG_FIS;
                     mvs_write_port_irq_mask(mvi,
-                                port_no, tmp);
+                                phy_no, tmp);
                 }
 
-                mvs_update_phyinfo(mvi, port_no, 0);
+                mvs_update_phyinfo(mvi, phy_no, 0);
                 sas_ha->notify_phy_event(sas_phy,
                             PHYE_OOB_DONE);
-                mvs_bytes_dmaed(mvi, port_no);
+                mvs_bytes_dmaed(mvi, phy_no);
             } else {
                 dev_printk(KERN_DEBUG, &pdev->dev,
                     "plugin interrupt but phy is gone\n");
                 mvs_phy_control(sas_phy, PHY_FUNC_LINK_RESET,
                             NULL);
             }
-        } else if (phy->irq_status & PHYEV_BROAD_CH)
+        } else if (phy->irq_status & PHYEV_BROAD_CH) {
+            mvs_release_task(mvi, phy_no);
             sas_ha->notify_port_event(sas_phy,
                         PORTE_BROADCAST_RCVD);
+        }
     }
-    mvs_write_port_irq_stat(mvi, port_no, phy->irq_status);
+    mvs_write_port_irq_stat(mvi, phy_no, phy->irq_status);
 }
 
 static void mvs_int_sata(struct mvs_info *mvi)
-- 
1.5.4



