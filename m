From: akpm@linux-foundation.org
Subject: [patch 13/23] SCSI/gdth: kill unneeded 'irq' argument
Date: Wed, 21 Nov 2007 15:12:25 -0800
Message-ID: <200711212312.lALNCPDn014142@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960AbXKUXRz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2007 18:17:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jeff@garzik.org, bharrosh@panasas.com, jgarzik@redhat.com

From: Jeff Garzik <jeff@garzik.org>

Neither gdth_get_status() nor __gdth_interrupt() need their 'irq' argument,
so remove it.

[akpm@linux-foundation.org: coding style fixes]
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/gdth.c~scsi-gdth-kill-unneeded-irq-argument drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-gdth-kill-unneeded-irq-argument
+++ a/drivers/scsi/gdth.c
@@ -141,7 +141,7 @@
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
-static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
+static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex);
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
                                                                Scsi_Cmnd *scp);
@@ -165,7 +165,6 @@ static int gdth_internal_cache_cmd(gdth_
 static int gdth_fill_cache_cmd(gdth_ha_str *ha, Scsi_Cmnd *scp, ushort hdrive);
 
 static void gdth_enable_int(gdth_ha_str *ha);
-static unchar gdth_get_status(gdth_ha_str *ha, int irq);
 static int gdth_test_busy(gdth_ha_str *ha);
 static int gdth_get_cmd_index(gdth_ha_str *ha);
 static void gdth_release_event(gdth_ha_str *ha);
@@ -1334,14 +1333,12 @@ static void __init gdth_enable_int(gdth_
 }
 
 /* return IStatus if interrupt was from this card else 0 */
-static unchar gdth_get_status(gdth_ha_str *ha, int irq)
+static unchar gdth_get_status(gdth_ha_str *ha)
 {
     unchar IStatus = 0;
 
-    TRACE(("gdth_get_status() irq %d ctr_count %d\n", irq, gdth_ctr_count));
+    TRACE(("gdth_get_status() irq %d ctr_count %d\n", ha->irq, gdth_ctr_count));
 
-        if (ha->irq != (unchar)irq)             /* check IRQ */
-            return false;
         if (ha->type == GDT_EISA)
             IStatus = inb((ushort)ha->bmic + EDOORREG);
         else if (ha->type == GDT_ISA)
@@ -1523,7 +1520,7 @@ static int gdth_wait(gdth_ha_str *ha, in
         return 1;                               /* no wait required */
 
     do {
-        __gdth_interrupt(ha, (int)ha->irq, true, &wait_index);
+	__gdth_interrupt(ha, true, &wait_index);
         if (wait_index == index) {
             answer_found = TRUE;
             break;
@@ -3036,7 +3033,7 @@ static void gdth_clear_events(void)
 
 /* SCSI interface functions */
 
-static irqreturn_t __gdth_interrupt(gdth_ha_str *ha, int irq,
+static irqreturn_t __gdth_interrupt(gdth_ha_str *ha,
                                     int gdth_from_wait, int* pIndex)
 {
     gdt6m_dpram_str __iomem *dp6m_ptr = NULL;
@@ -3054,7 +3051,7 @@ static irqreturn_t __gdth_interrupt(gdth
     int act_int_coal = 0;       
 #endif
 
-    TRACE(("gdth_interrupt() IRQ %d\n",irq));
+    TRACE(("gdth_interrupt() IRQ %d\n", ha->irq));
 
     /* if polling and not from gdth_wait() -> return */
     if (gdth_polling) {
@@ -3067,7 +3064,8 @@ static irqreturn_t __gdth_interrupt(gdth
         spin_lock_irqsave(&ha->smp_lock, flags);
 
     /* search controller */
-    if (0 == (IStatus = gdth_get_status(ha, irq))) {
+    IStatus = gdth_get_status(ha);
+    if (IStatus == 0) {
         /* spurious interrupt */
         if (!gdth_polling)
             spin_unlock_irqrestore(&ha->smp_lock, flags);
@@ -3294,9 +3292,9 @@ static irqreturn_t __gdth_interrupt(gdth
 
 static irqreturn_t gdth_interrupt(int irq, void *dev_id)
 {
-	gdth_ha_str *ha = (gdth_ha_str *)dev_id;
+	gdth_ha_str *ha = dev_id;
 
-	return __gdth_interrupt(ha, irq, false, NULL);
+	return __gdth_interrupt(ha, false, NULL);
 }
 
 static int gdth_sync_event(gdth_ha_str *ha, int service, unchar index,
_
