From: Ke Wei <kewei@marvell.com>
Subject: [PATCH 7/8] mvsas: get phy info.
Date: Fri, 21 Mar 2008 19:06:53 +0800
Message-ID: <47E396CD.9070005@marvell.com>
Reply-To: kewei@marvell.com, kewei.mv@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:12012 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753498AbYCULG5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 07:06:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

removed unused code and attached SATA address makes use of port id.
enable HBA interrupt after calling sas_register_ha();


Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas.c |   88 
++++++++++++++++++++++++--------------------------
 1 files changed, 42 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/mvsas.c b/drivers/scsi/mvsas.c
index 761beeb..b5de3d0 100644
--- a/drivers/scsi/mvsas.c
+++ b/drivers/scsi/mvsas.c
@@ -2743,7 +2743,7 @@ static void mvs_update_phyinfo(struct mvs_info 
*mvi, int i,
 {
     struct mvs_phy *phy = &mvi->phy[i];
     struct pci_dev *pdev = mvi->pdev;
-    u32 tmp, j;
+    u32 tmp;
     u64 tmp64;
 
     mvs_write_port_cfg_addr(mvi, i, PHYR_IDENTIFY);
@@ -2770,46 +2770,20 @@ static void mvs_update_phyinfo(struct mvs_info 
*mvi, int i,
         sas_phy->linkrate =
             (phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
                 PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET;
-
-        /* Updated attached_sas_addr */
-        mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);
-        phy->att_dev_sas_addr =
-                (u64) mvs_read_port_cfg_data(mvi, i) << 32;
-
-        mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_LO);
-        phy->att_dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
-
-        dev_printk(KERN_DEBUG, &pdev->dev,
-            "phy[%d] Get Attached Address 0x%llX ,"
-            " SAS Address 0x%llX\n",
-            i, phy->att_dev_sas_addr, phy->dev_sas_addr);
-        dev_printk(KERN_DEBUG, &pdev->dev,
-            "Rate = %x , type = %d\n",
-            sas_phy->linkrate, phy->phy_type);
-
-#if 1
-        /*
-        * If the device is capable of supporting a wide port
-        * on its phys, it may configure the phys as a wide port.
-        */
-        if (phy->phy_type & PORT_TYPE_SAS)
-            for (j = 0; j < mvi->chip->n_phy && j != i; ++j) {
-                if ((mvi->phy[j].phy_attached) &&
-                    (mvi->phy[j].phy_type & PORT_TYPE_SAS))
-                    if (phy->att_dev_sas_addr ==
-                    mvi->phy[j].att_dev_sas_addr - 1) {
-                        phy->att_dev_sas_addr =
-                        mvi->phy[j].att_dev_sas_addr;
-                        break;
-                    }
-            }
-
-#endif
-
-        tmp64 = cpu_to_be64(phy->att_dev_sas_addr);
-        memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);
+        phy->minimum_linkrate =
+            (phy->phy_status &
+                PHY_MIN_SPP_PHYS_LINK_RATE_MASK) >> 8;
+        phy->maximum_linkrate =
+            (phy->phy_status &
+                PHY_MAX_SPP_PHYS_LINK_RATE_MASK) >> 12;
 
         if (phy->phy_type & PORT_TYPE_SAS) {
+            /* Updated attached_sas_addr */
+            mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_HI);
+            phy->att_dev_sas_addr =
+                (u64) mvs_read_port_cfg_data(mvi, i) << 32;
+            mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_ADDR_LO);
+            phy->att_dev_sas_addr |= mvs_read_port_cfg_data(mvi, i);
             mvs_write_port_cfg_addr(mvi, i, PHYR_ATT_DEV_INFO);
             phy->att_dev_info = mvs_read_port_cfg_data(mvi, i);
             phy->identify.device_type =
@@ -2828,6 +2802,7 @@ static void mvs_update_phyinfo(struct mvs_info 
*mvi, int i,
         } else if (phy->phy_type & PORT_TYPE_SATA) {
             phy->identify.target_port_protocols = SAS_PROTOCOL_STP;
             if (mvs_is_sig_fis_received(phy->irq_status)) {
+                phy->att_dev_sas_addr = i;    /* temp */
                 if (phy_st & PHY_OOB_DTCTD)
                     sas_phy->oob_mode = SATA_OOB_MODE;
                 phy->frame_rcvd_size =
@@ -2837,20 +2812,34 @@ static void mvs_update_phyinfo(struct mvs_info 
*mvi, int i,
             } else {
                 dev_printk(KERN_DEBUG, &pdev->dev,
                     "No sig fis\n");
+                phy->phy_type &= ~(PORT_TYPE_SATA);
+                goto out_done;
             }
         }
+        tmp64 = cpu_to_be64(phy->att_dev_sas_addr);
+        memcpy(sas_phy->attached_sas_addr, &tmp64, SAS_ADDR_SIZE);
+
+        dev_printk(KERN_DEBUG, &pdev->dev,
+            "phy[%d] Get Attached Address 0x%llX ,"
+            " SAS Address 0x%llX\n",
+            i, phy->att_dev_sas_addr, phy->dev_sas_addr);
+        dev_printk(KERN_DEBUG, &pdev->dev,
+            "Rate = %x , type = %d\n",
+            sas_phy->linkrate, phy->phy_type);
+
         /* workaround for HW phy decoding error on 1.5g disk drive */
         mvs_write_port_vsr_addr(mvi, i, VSR_PHY_MODE6);
         tmp = mvs_read_port_vsr_data(mvi, i);
         if (((phy->phy_status & PHY_NEG_SPP_PHYS_LINK_RATE_MASK) >>
              PHY_NEG_SPP_PHYS_LINK_RATE_MASK_OFFSET) ==
             SAS_LINK_RATE_1_5_GBPS)
-            tmp &= ~PHY_MODE6_DTL_SPEED;
+            tmp &= ~PHY_MODE6_LATECLK;
         else
-            tmp |= PHY_MODE6_DTL_SPEED;
+            tmp |= PHY_MODE6_LATECLK;
         mvs_write_port_vsr_data(mvi, i, tmp);
 
     }
+out_done:
     if (get_st)
         mvs_write_port_irq_stat(mvi, i, phy->irq_status);
 }
@@ -2875,6 +2864,11 @@ static void mvs_port_formed(struct asd_sas_phy 
*sas_phy)
     spin_unlock_irqrestore(&mvi->lock, flags);
 }
 
+static int mvs_I_T_nexus_reset(struct domain_device *dev)
+{
+    return TMF_RESP_FUNC_FAILED;
+}
+
 static int __devinit mvs_hw_init(struct mvs_info *mvi)
 {
     void __iomem *regs = mvi->regs;
@@ -3036,13 +3030,12 @@ static int __devinit mvs_hw_init(struct mvs_info 
*mvi)
     /* enable CMD/CMPL_Q/RESP mode */
     mw32(PCS, PCS_SATA_RETRY | PCS_FIS_RX_EN | PCS_CMD_EN);
 
-    /* re-enable interrupts globally */
-    mvs_hba_interrupt_enable(mvi);
-
     /* enable completion queue interrupt */
-    tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM);
+    tmp = (CINT_PORT_MASK | CINT_DONE | CINT_MEM | CINT_SRS);
     mw32(INT_MASK, tmp);
 
+    /* Enable SRS interrupt */
+    mw32(INT_MASK_SRS, 0xFF);
     return 0;
 }
 
@@ -3116,6 +3109,8 @@ static int __devinit mvs_pci_init(struct pci_dev 
*pdev,
 
     mvs_print_info(mvi);
 
+    mvs_hba_interrupt_enable(mvi);
+
     scsi_scan_host(mvi->shost);
 
     return 0;
@@ -3161,7 +3156,8 @@ static struct sas_domain_function_template 
mvs_transport_ops = {
     .lldd_execute_task    = mvs_task_exec,
     .lldd_control_phy    = mvs_phy_control,
     .lldd_abort_task    = mvs_task_abort,
-    .lldd_port_formed    = mvs_port_formed
+    .lldd_port_formed    = mvs_port_formed,
+    .lldd_I_T_nexus_reset    = mvs_I_T_nexus_reset,
 };
 
 static struct pci_device_id __devinitdata mvs_pci_table[] = {
-- 
1.5.4


