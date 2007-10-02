From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 11/16] gdth: gdth_interrupt() gdth_get_status() & gdth_wait()
 fixes
Date: Tue, 02 Oct 2007 23:08:10 +0200
Message-ID: <4702B33A.1060905@panasas.com>
References: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8367 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755969AbXJBVIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:08:24 -0400
In-Reply-To: <4702A4A1.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kern>


  - gdth_get_status() returns a single device interrupt IStatus
  - gdth_interrupt split to __gdth_interrupt() that receives
    flags if is called from gdth_wait().
  - Use dev_id passed from kernel and do not loop on all
    controllers.
  - gdth_wait(), get read of all global variables and call the new
    __gdth_interrupt with these variables on the stack

Signed-off-by Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   93 +++++++++++++++++++++++---------------------------
 1 files changed, 43 insertions(+), 50 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 4553ca1..ad60239 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -139,6 +139,8 @@
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
+static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
+                                    int gdth_from_wait, int* pIndex);
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                                                                Scsi_Cmnd *scp);
 static int gdth_async_event(gdth_ha_str *ha);
@@ -161,7 +163,7 @@ static int gdth_internal_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp);
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
 static void gdth_enable_int(gdth_ha_str *ha);
-static int gdth_get_status(unchar *pIStatus,int irq);
+static unchar gdth_get_status(gdth_ha_str *ha, int irq);
 static int gdth_test_busy(gdth_ha_str *ha);
 static int gdth_get_cmd_index(gdth_ha_str *ha);
 static void gdth_release_event(gdth_ha_str *ha);
@@ -295,8 +297,6 @@ static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 #endif
 static unchar   gdth_polling;                           /* polling if TRUE */
-static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
-static int      wait_index,wait_hanum;                  /* gdth_wait() */
 static int      gdth_ctr_count  = 0;                    /* controller count */
 static int      gdth_ctr_released = 0;                  /* gdth_release() */
 static struct Scsi_Host *gdth_ctr_tab[MAXHA];           /* controller table */
@@ -1245,41 +1245,32 @@ static void __init gdth_enable_int(gdth_ha_str *ha)
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
 
-
-static int gdth_get_status(unchar *pIStatus,int irq)
+/* return IStatus if interrupt was from this card else 0 */
+static unchar gdth_get_status(gdth_ha_str *ha, int irq)
 {
-    register gdth_ha_str *ha;
-    int i;
+    unchar IStatus = 0;
+
+    TRACE(("gdth_get_status() irq %d ctr_count %d\n", irq, gdth_ctr_count));
 
-    TRACE(("gdth_get_status() irq %d ctr_count %d\n",
-           irq,gdth_ctr_count));
-    
-    *pIStatus = 0;
-    for (i=0; i<gdth_ctr_count; ++i) {
-        ha = shost_priv(gdth_ctr_tab[i]);
         if (ha->irq != (unchar)irq)             /* check IRQ */
-            continue;
+            return false;
         if (ha->type == GDT_EISA)
-            *pIStatus = inb((ushort)ha->bmic + EDOORREG);
+            IStatus = inb((ushort)ha->bmic + EDOORREG);
         else if (ha->type == GDT_ISA)
-            *pIStatus =
+            IStatus =
                 readb(&((gdt2_dpram_str __iomem *)ha->brd)->u.ic.Cmd_Index);
         else if (ha->type == GDT_PCI)
-            *pIStatus =
+            IStatus =
                 readb(&((gdt6_dpram_str __iomem *)ha->brd)->u.ic.Cmd_Index);
         else if (ha->type == GDT_PCINEW) 
-            *pIStatus = inb(PTR2USHORT(&ha->plx->edoor_reg));
+            IStatus = inb(PTR2USHORT(&ha->plx->edoor_reg));
         else if (ha->type == GDT_PCIMPR)
-            *pIStatus =
+            IStatus =
                 readb(&((gdt6m_dpram_str __iomem *)ha->brd)->i960r.edoor_reg);
-   
-        if (*pIStatus)                                  
-            return i;                           /* board found */
-    }
-    return -1;
+
+        return IStatus;
 }
-                 
-    
+
 static int gdth_test_busy(gdth_ha_str *ha)
 {
     register int gdtsema0 = 0;
@@ -1436,22 +1427,21 @@ static void gdth_release_event(gdth_ha_str *ha)
 static int gdth_wait(gdth_ha_str *ha, int index, ulong32 time)
 {
     int answer_found = FALSE;
+    int wait_index = 0;
 
     TRACE(("gdth_wait() hanum %d index %d time %d\n", ha->hanum, index, time));
 
     if (index == 0)
         return 1;                               /* no wait required */
 
-    gdth_from_wait = TRUE;
     do {
-        gdth_interrupt((int)ha->irq,ha);
-        if (wait_hanum==ha->hanum && wait_index==index) {
+        __gdth_interrupt(ha, (int)ha->irq, true, &wait_index);
+        if (wait_index == index) {
             answer_found = TRUE;
             break;
         }
         gdth_delay(1);
     } while (--time);
-    gdth_from_wait = FALSE;
 
     while (gdth_test_busy(ha))
         gdth_delay(0);
@@ -3010,15 +3000,14 @@ static void gdth_clear_events(void)
 
 /* SCSI interface functions */
 
-static irqreturn_t gdth_interrupt(int irq,void *dev_id)
+static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
+                                    int gdth_from_wait, int* pIndex)
 {
-    gdth_ha_str *ha2 = (gdth_ha_str *)dev_id;
-    register gdth_ha_str *ha;
     gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
     gdt6_dpram_str __iomem *dp6_ptr;
     gdt2_dpram_str __iomem *dp2_ptr;
     Scsi_Cmnd *scp;
-    int hanum, rval, i;
+    int rval, i;
     unchar IStatus;
     ushort Service;
     ulong flags = 0;
@@ -3039,17 +3028,15 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
     }
 
     if (!gdth_polling)
-        spin_lock_irqsave(&ha2->smp_lock, flags);
-    wait_index = 0;
+        spin_lock_irqsave(&ha->smp_lock, flags);
 
     /* search controller */
-    if ((hanum = gdth_get_status(&IStatus,irq)) == -1) {
+    if (0 == (IStatus = gdth_get_status(ha, irq))) {
         /* spurious interrupt */
         if (!gdth_polling)
-            spin_unlock_irqrestore(&ha2->smp_lock, flags);
-            return IRQ_HANDLED;
+            spin_unlock_irqrestore(&ha->smp_lock, flags);
+        return IRQ_HANDLED;
     }
-    ha = shost_priv(gdth_ctr_tab[hanum]);
 
 #ifdef GDTH_STATISTICS
     ++act_ints;
@@ -3181,7 +3168,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         } else {
             TRACE2(("gdth_interrupt() unknown controller type\n"));
             if (!gdth_polling)
-                spin_unlock_irqrestore(&ha2->smp_lock, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
             return IRQ_HANDLED;
         }
 
@@ -3189,15 +3176,14 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
                IStatus,ha->status,ha->info));
 
         if (gdth_from_wait) {
-            wait_hanum = hanum;
-            wait_index = (int)IStatus;
+            *pIndex = (int)IStatus;
         }
 
         if (IStatus == ASYNCINDEX) {
             TRACE2(("gdth_interrupt() async. event\n"));
             gdth_async_event(ha);
             if (!gdth_polling)
-                spin_unlock_irqrestore(&ha2->smp_lock, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
             gdth_next(ha);
             return IRQ_HANDLED;
         } 
@@ -3205,10 +3191,10 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         if (IStatus == SPEZINDEX) {
             TRACE2(("Service unknown or not initialized !\n"));
             ha->dvr.size = sizeof(ha->dvr.eu.driver);
-            ha->dvr.eu.driver.ionode = hanum;
+            ha->dvr.eu.driver.ionode = ha->hanum;
             gdth_store_event(ha, ES_DRIVER, 4, &ha->dvr);
             if (!gdth_polling)
-                spin_unlock_irqrestore(&ha2->smp_lock, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
             return IRQ_HANDLED;
         }
         scp     = ha->cmd_tab[IStatus-2].cmnd;
@@ -3217,24 +3203,24 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         if (scp == UNUSED_CMND) {
             TRACE2(("gdth_interrupt() index to unused command (%d)\n",IStatus));
             ha->dvr.size = sizeof(ha->dvr.eu.driver);
-            ha->dvr.eu.driver.ionode = hanum;
+            ha->dvr.eu.driver.ionode = ha->hanum;
             ha->dvr.eu.driver.index = IStatus;
             gdth_store_event(ha, ES_DRIVER, 1, &ha->dvr);
             if (!gdth_polling)
-                spin_unlock_irqrestore(&ha2->smp_lock, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
             return IRQ_HANDLED;
         }
         if (scp == INTERNAL_CMND) {
             TRACE(("gdth_interrupt() answer to internal command\n"));
             if (!gdth_polling)
-                spin_unlock_irqrestore(&ha2->smp_lock, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
             return IRQ_HANDLED;
         }
 
         TRACE(("gdth_interrupt() sync. status\n"));
         rval = gdth_sync_event(ha,Service,IStatus,scp);
         if (!gdth_polling)
-            spin_unlock_irqrestore(&ha2->smp_lock, flags);
+            spin_unlock_irqrestore(&ha->smp_lock, flags);
         if (rval == 2) {
             gdth_putq(ha, scp,scp->SCp.this_residual);
         } else if (rval == 1) {
@@ -3270,6 +3256,13 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
     return IRQ_HANDLED;
 }
 
+static irqreturn_t gdth_interrupt(int irq, void *dev_id)
+{
+	gdth_ha_str *ha = (gdth_ha_str *)dev_id;
+
+	return __gdth_interrupt(ha, irq, false, NULL);
+}
+
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                                                               Scsi_Cmnd *scp)
 {
-- 
1.5.3.1


