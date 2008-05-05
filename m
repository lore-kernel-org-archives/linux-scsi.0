From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/2] gdth: fix timer handling
Date: Sun, 04 May 2008 22:34:49 -0500
Message-ID: <1209958489.16283.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51536 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488AbYEEDew (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 23:34:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 5B9A5A252
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2008 22:34:51 -0500 (CDT)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TfrnJqtBhGDE for <linux-scsi@vger.kernel.org>;
	Sun,  4 May 2008 22:34:50 -0500 (CDT)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 35A64842B
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2008 22:34:50 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The global timer handling is problematic in that if someone unbinds a
PCI gdth instance, the BUG_ON() in the timer will cause a panic.

Fix this by making the timer start and stop depending on whether there
are instances present.  This should also permit binding and unbinding
to work.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/gdth.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 8e2e964..16785a2 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3724,6 +3724,8 @@ static void gdth_log_event(gdth_evt_data *dvr, char *buffer)
 }
 
 #ifdef GDTH_STATISTICS
+static unchar	gdth_timer_running;
+
 static void gdth_timeout(ulong data)
 {
     ulong32 i;
@@ -3731,7 +3733,10 @@ static void gdth_timeout(ulong data)
     gdth_ha_str *ha;
     ulong flags;
 
-    BUG_ON(list_empty(&gdth_instances));
+    if(unlikely(list_empty(&gdth_instances))) {
+	    gdth_timer_running = 0;
+	    return;
+    }
 
     ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -3751,6 +3756,22 @@ static void gdth_timeout(ulong data)
     add_timer(&gdth_timer);
     spin_unlock_irqrestore(&ha->smp_lock, flags);
 }
+
+static void gdth_timer_init(void)
+{
+	if (gdth_timer_running)
+		return;
+	gdth_timer_running = 1;
+	TRACE2(("gdth_detect(): Initializing timer !\n"));
+	gdth_timer.expires = jiffies + HZ;
+	gdth_timer.data = 0L;
+	gdth_timer.function = gdth_timeout;
+	add_timer(&gdth_timer);
+}
+#else
+static inline void gdth_timer_init(void)
+{
+}
 #endif
 
 static void __init internal_setup(char *str,int *ints)
@@ -4735,6 +4756,7 @@ static int __init gdth_isa_probe_one(ulong32 isa_bios)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -4865,6 +4887,7 @@ static int __init gdth_eisa_probe_one(ushort eisa_slot)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -5011,6 +5034,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 	list_add_tail(&ha->list, &gdth_instances);
 
 	pci_set_drvdata(ha->pdev, ha);
+	gdth_timer_init();
 
 	scsi_scan_host(shp);
 
@@ -5110,6 +5134,7 @@ static int __init gdth_init(void)
 	/* initializations */
 	gdth_polling = TRUE;
 	gdth_clear_events();
+	init_timer(&gdth_timer);
 
 	/* As default we do not probe for EISA or ISA controllers */
 	if (probe_eisa_isa) {
@@ -5138,17 +5163,6 @@ static int __init gdth_init(void)
 
 	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
 
-	if (list_empty(&gdth_instances))
-		return -ENODEV;
-
-#ifdef GDTH_STATISTICS
-	TRACE2(("gdth_detect(): Initializing timer !\n"));
-	init_timer(&gdth_timer);
-	gdth_timer.expires = jiffies + HZ;
-	gdth_timer.data = 0L;
-	gdth_timer.function = gdth_timeout;
-	add_timer(&gdth_timer);
-#endif
 	major = register_chrdev(0,"gdth", &gdth_fops);
 	register_reboot_notifier(&gdth_notifier);
 	gdth_polling = FALSE;
-- 
1.5.4.4



