From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 10/16] gdth: gdth_get_status() return pointer to host
 not its index
Date: Tue, 02 Oct 2007 13:10:44 +0200
Message-ID: <47022734.7000304@panasas.com>
References: <46FFFC8C.6080804@panasas.com> <47000270.8000209@panasas.com> <20070930212628.GC13343@infradead.org> <470225B7.9010204@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25404 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753436AbXJBLLD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 07:11:03 -0400
In-Reply-To: <470225B7.9010204@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

Boaz Harrosh wrote:
> On Sun, Sep 30 2007 at 23:26 +0200, Christoph Hellwig <hch@infradead.org> wrote:
>> On Sun, Sep 30, 2007 at 10:09:20PM +0200, Boaz Harrosh wrote:
>>>   - Return the interrupting host and not it's index.
>>>     NULL if intr is not by gdth.
>>>   - fix calling site
>>>
>>>   FIXME:
>>>    Why are we looping on all cards? the passed dev_id
>>>    can be used for pinpointing the exact interrupting
>>>    card. The kernel is already looping on all sharing
>>>    cards so this code makes it O(n^2).
>> This is just pre-historic code that makes no sense whatover in a modern
>> kernel.  I'd much prefer to stop doing this and use dev_id properly.
>>
> OK I'm attempting just that but please look in with me on the code
> I have some questions.
> 
>>>    What is that polling mode? can we pass dev_id to
>>>    gdth_get_status() and do a poll only if dev_id is
>>>    NULL?
>> Just loop over all host adapters in gdth_wait instead and pass in the
>> ha pointer.
>>
> 
> [Issue 1]
>   In gdth_get_status() the first check is if(ha->irq == passed_in_irq)
>   if not than no status read is attempted and 0 is returned. In this
>   case gdth_interrupt() will return with out doing any advancement of states.
> 
>   Now gdth_wait() calls with gdth_interrupt(ha->irq, ha) so it means that in
>   effect current code will loop on all devices but will actually read the status
>   of only the waiting on card.
> 
>   [Q1] So am I safe in just dropping the loop even from gdth_wait() ?
>   [Q2] When gdth_interrupt() is called by the kernel am I guaranteed that irq will
>   match the ha->irq that is passed as dev_id? (Since that is what I registered
>   as my interrupt routine)
> 
> [Issue 2]
>   In gdth_wait() and gdth_interrupt() the globals 
>   "gdth_from_wait", "wait_hanum" and "wait_index" give me the creeps.
>   We are talking about hotplug API and proper lucking of adapter's list
>   and this thing is just plain don't work with more than one card.
> 
>   [Q1] Do you understand all that business with gdth_polling and gdth_wait()?
>        It looks like if you do gdth_polling==true than you can have only one
>        card. Is that true?
>   [Q2] Should I fix that? I thought of doing a __gdth_interrupt() that is called
>        by gdth_interrupt() and passes all these members on the stack as parameters
>        to __gdth_interrupt().
>        (Actually most of them will be dropped they will not be needed)
> 
> Boaz
I've attempted a fix below. Christoph please review this is delicate stuff

Subject: [PATCH] gdth: gdth_interrupt gdth_get_status & gdth_wait fixes

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
index ddc5f1f..6181e65 100644
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
@@ -171,7 +173,7 @@ static int gdth_init_isa(ulong32 bios_adr,gdth_ha_str *ha);
 static int gdth_init_pci(gdth_pci_str *pcistr,gdth_ha_str *ha);
 
 static void gdth_enable_int(gdth_ha_str *ha);
-static int gdth_get_status(unchar *pIStatus,int irq);
+static unchar gdth_get_status(gdth_ha_str *ha, int irq);
 static int gdth_test_busy(gdth_ha_str *ha);
 static int gdth_get_cmd_index(gdth_ha_str *ha);
 static void gdth_release_event(gdth_ha_str *ha);
@@ -301,8 +303,6 @@ static struct timer_list gdth_timer;
 static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 static unchar   gdth_polling;                           /* polling if TRUE */
-static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
-static int      wait_index,wait_hanum;                  /* gdth_wait() */
 static int      gdth_ctr_count  = 0;                    /* controller count */
 static int      gdth_ctr_released = 0;                  /* gdth_release() */
 static struct Scsi_Host *gdth_ctr_tab[MAXHA];           /* controller table */
@@ -1244,41 +1244,32 @@ static void __init gdth_enable_int(gdth_ha_str *ha)
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
@@ -1435,22 +1426,21 @@ static void gdth_release_event(gdth_ha_str *ha)
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
@@ -3009,15 +2999,14 @@ static void gdth_clear_events(void)
 
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
@@ -3038,17 +3027,15 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
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
@@ -3180,7 +3167,7 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
         } else {
             TRACE2(("gdth_interrupt() unknown controller type\n"));
             if (!gdth_polling)
-                spin_unlock_irqrestore(&ha2->smp_lock, flags);
+                spin_unlock_irqrestore(&ha->smp_lock, flags);
             return IRQ_HANDLED;
         }
 
@@ -3188,15 +3175,14 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
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
@@ -3204,10 +3190,10 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
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
@@ -3216,24 +3202,24 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
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
@@ -3269,6 +3255,13 @@ static irqreturn_t gdth_interrupt(int irq,void *dev_id)
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



