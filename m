From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 10/16] gdth: gdth_get_status() return pointer to host not
 its index
Date: Sun, 30 Sep 2007 22:09:20 +0200
Message-ID: <47000270.8000209@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa14.bezeqint.net ([192.115.104.29]:51967 "EHLO
	sa14.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbXI3UJ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 16:09:26 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  - Return the interrupting host and not it's index.
    NULL if intr is not by gdth.
  - fix calling site

  FIXME:
   Why are we looping on all cards? the passed dev_id
   can be used for pinpointing the exact interrupting
   card. The kernel is already looping on all sharing
   cards so this code makes it O(n^2).
   What is that polling mode? can we pass dev_id to
   gdth_get_status() and do a poll only if dev_id is
   NULL?

Signed-off-by Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   26 +++++++++++---------------
 1 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 6fa7e27..b08bea3 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -171,7 +171,7 @@ static int gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha);
 static int gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha);
 
 static void gdth_enable_int(gdth_ha_str *ha);
-static int gdth_get_status(unchar *pIStatus,int irq);
+static gdth_ha_str *gdth_get_status(unchar *pIStatus, int irq);
 static int gdth_test_busy(gdth_ha_str *ha);
 static int gdth_get_cmd_index(gdth_ha_str *ha);
 static void gdth_release_event(gdth_ha_str *ha);
@@ -1240,17 +1240,15 @@ static void __init gdth_enable_int(gdth_ha_str *ha)
 }
 
 
-static int gdth_get_status(unchar *pIStatus,int irq)
+static gdth_ha_str *gdth_get_status(unchar *pIStatus, int irq)
 {
     register gdth_ha_str *ha;
-    int i;
 
     TRACE(("gdth_get_status() irq %d ctr_count %d\n",
            irq,gdth_ctr_count));
     
     *pIStatus = 0;
-    for (i=0; i<gdth_ctr_count; ++i) {
-        ha = shost_priv(gdth_ctr_tab[i]);
+    list_for_each_entry(ha, &gdth_instances, list) {
         if (ha->irq != (unchar)irq)             /* check IRQ */
             continue;
         if (ha->type == GDT_EISA)
@@ -1268,12 +1266,11 @@ static int gdth_get_status(unchar *pIStatus,int irq)
                 readb(&((gdt6m_dpram_str __iomem *)ha->brd)->i960r.edoor_reg);
    
         if (*pIStatus)                                  
-            return i;                           /* board found */
+            return ha;                           /* board found */
     }
-    return -1;
+    return NULL;
 }
-                 
-    
+
 static int gdth_test_busy(gdth_ha_str *ha)
 {
     register int gdtsema0 = 0;
@@ -3012,7 +3009,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
     gdt6_dpram_str __iomem *dp6_ptr;
     gdt2_dpram_str __iomem *dp2_ptr;
     Scsi_Cmnd *scp;
-    int hanum, rval, i;
+    int rval, i;
     unchar IStatus;
     ushort Service;
     ulong flags = 0;
@@ -3037,13 +3034,12 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
     wait_index = 0;
 
     /* search controller */
-    if ((hanum = gdth_get_status(&IStatus,irq)) == -1) {
+    if ((ha = gdth_get_status(&IStatus,irq)) == NULL) {
         /* spurious interrupt */
         if (!gdth_polling)
             spin_unlock_irqrestore(&ha2->smp_lock, flags);
             return IRQ_HANDLED;
     }
-    ha = shost_priv(gdth_ctr_tab[hanum]);
 
 #ifdef GDTH_STATISTICS
     ++act_ints;
@@ -3183,7 +3179,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
                IStatus,ha->status,ha->info));
 
         if (gdth_from_wait) {
-            wait_hanum = hanum;
+            wait_hanum = ha->hanum;
             wait_index = (int)IStatus;
         }
 
@@ -3199,7 +3195,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         if (IStatus == SPEZINDEX) {
             TRACE2(("Service unknown or not initialized !\n"));
             ha->dvr.size = sizeof(ha->dvr.eu.driver);
-            ha->dvr.eu.driver.ionode = hanum;
+            ha->dvr.eu.driver.ionode = ha->hanum;
             gdth_store_event(ha, ES_DRIVER, 4, &ha->dvr);
             if (!gdth_polling)
                 spin_unlock_irqrestore(&ha2->smp_lock, flags);
@@ -3211,7 +3207,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         if (scp == UNUSED_CMND) {
             TRACE2(("gdth_interrupt() index to unused command (%d)\n",IStatus));
             ha->dvr.size = sizeof(ha->dvr.eu.driver);
-            ha->dvr.eu.driver.ionode = hanum;
+            ha->dvr.eu.driver.ionode = ha->hanum;
             ha->dvr.eu.driver.index = IStatus;
             gdth_store_event(ha, ES_DRIVER, 1, &ha->dvr);
             if (!gdth_polling)
