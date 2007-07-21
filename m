From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/7] gdth: switch to modern scsi host registration
Date: Sat, 21 Jul 2007 19:02:16 +0200
Message-ID: <20070721170216.GH4150@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:58114 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbXGURCY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 13:02:24 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: leubner@adaptec.com, jeff@garzik.org, linux-scsi@vger.kernel.org

Use scsi_add_host and friends and track instances ourselves.  This is
the second to last step tovards proper PCI API useage.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.c	2007-07-21 13:08:15.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth.c	2007-07-21 13:21:57.000000000 +0200
@@ -119,6 +119,7 @@
 #include <linux/time.h>
 #include <linux/timer.h>
 #include <linux/dma-mapping.h>
+#include <linux/list.h>
 
 #ifdef GDTH_RTC
 #include <linux/mc146818rtc.h>
@@ -191,15 +192,6 @@ static void gdth_flush(int hanum);
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf);
 static int gdth_queuecommand(Scsi_Cmnd *scp,void (*done)(Scsi_Cmnd *));
 static void gdth_scsi_done(struct scsi_cmnd *scp);
-#ifdef CONFIG_ISA
-static int gdth_isa_probe_one(struct scsi_host_template *, ulong32);
-#endif
-#ifdef CONFIG_EISA
-static int gdth_eisa_probe_one(struct scsi_host_template *, ushort);
-#endif
-#ifdef CONFIG_PCI
-static int gdth_pci_probe_one(struct scsi_host_template *, gdth_pci_str *, int);
-#endif
 
 #ifdef DEBUG_GDTH
 static unchar   DebugState = DEBUG_GDTH;
@@ -310,8 +302,8 @@ static unchar   gdth_polling;           
 static unchar   gdth_from_wait  = FALSE;                /* gdth_wait() */
 static int      wait_index,wait_hanum;                  /* gdth_wait() */
 static int      gdth_ctr_count  = 0;                    /* controller count */
-static int      gdth_ctr_released = 0;                  /* gdth_release() */
 static struct Scsi_Host *gdth_ctr_tab[MAXHA];           /* controller table */
+static LIST_HEAD(gdth_instances);
 static unchar   gdth_write_through = FALSE;             /* write through */
 static gdth_evt_str ebuffer[MAX_EVENTS];                /* event buffer */
 static int elastidx;
@@ -3918,145 +3910,6 @@ int __init option_setup(char *str)
     return 1;
 }
 
-
-static int __init gdth_detect(struct scsi_host_template *shtp)
-{
-    gdth_pci_str pcistr[MAXHA];
-    ulong32 isa_bios;
-    ushort eisa_slot;
-    int cnt,ctr;
-    unchar b;
-    
- 
-#ifdef DEBUG_GDTH
-    printk("GDT: This driver contains debugging information !! Trace level = %d\n",
-        DebugState);
-    printk("     Destination of debugging information: ");
-#ifdef __SERIAL__
-#ifdef __COM2__
-    printk("Serial port COM2\n");
-#else
-    printk("Serial port COM1\n");
-#endif
-#else
-    printk("Console\n");
-#endif
-    gdth_delay(3000);
-#endif
-
-    TRACE(("gdth_detect()\n"));
-
-    if (disable) {
-        printk("GDT-HA: Controller driver disabled from command line !\n");
-        return 0;
-    }
-
-    printk("GDT-HA: Storage RAID Controller Driver. Version: %s\n",GDTH_VERSION_STR);
-    /* initializations */
-    gdth_polling = TRUE; b = 0;
-    gdth_clear_events();
-
-    /* As default we do not probe for EISA or ISA controllers */
-    if (probe_eisa_isa) {    
-        /* scanning for controllers, at first: ISA controller */
-#ifdef CONFIG_ISA
-        for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
-	     isa_bios += 0x8000UL) {
-		if (gdth_ctr_count >= MAXHA)
-                	break;
-		gdth_isa_probe_one(shtp, isa_bios);
-	}
-#endif
-#ifdef CONFIG_EISA
-	for (eisa_slot = 0x1000; eisa_slot <= 0x8000; eisa_slot += 0x1000) {
-		if (gdth_ctr_count >= MAXHA)
-			break;
-		gdth_eisa_probe_one(shtp, eisa_slot);
-	}
-    }
-#endif
-
-#ifdef CONFIG_PCI
-    /* scanning for PCI controllers */
-    cnt = gdth_search_pci(pcistr);
-    printk("GDT-HA: Found %d PCI Storage RAID Controllers\n",cnt);
-    gdth_sort_pci(pcistr,cnt);
-    for (ctr = 0; ctr < cnt; ++ctr) {
-          if (gdth_ctr_count >= MAXHA)
-              break;
-	  gdth_pci_probe_one(shtp, pcistr, ctr);
-    }
-#endif
-    
-    TRACE2(("gdth_detect() %d controller detected\n",gdth_ctr_count));
-    if (gdth_ctr_count > 0) {
-#ifdef GDTH_STATISTICS
-        TRACE2(("gdth_detect(): Initializing timer !\n"));
-        init_timer(&gdth_timer);
-        gdth_timer.expires = jiffies + HZ;
-        gdth_timer.data = 0L;
-        gdth_timer.function = gdth_timeout;
-        add_timer(&gdth_timer);
-#endif
-        major = register_chrdev(0,"gdth",&gdth_fops);
-        notifier_disabled = 0;
-        register_reboot_notifier(&gdth_notifier);
-    }
-    gdth_polling = FALSE;
-    return gdth_ctr_count;
-}
-
-static int gdth_release(struct Scsi_Host *shp)
-{
-    gdth_ha_str *ha = shost_priv(shp);
-    int hanum = ha->hanum;
-
-    TRACE2(("gdth_release()\n"));
-        if (ha->sdev) {
-            scsi_free_host_dev(ha->sdev);
-            ha->sdev = NULL;
-        }
-        gdth_flush(hanum);
-
-        if (shp->irq) {
-            free_irq(shp->irq,ha);
-        }
-#ifdef CONFIG_ISA
-        if (shp->dma_channel != 0xff) {
-            free_dma(shp->dma_channel);
-        }
-#endif
-#ifdef INT_COAL
-        if (ha->coal_stat)
-            pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
-                                MAXOFFSETS, ha->coal_stat, ha->coal_stat_phys);
-#endif
-        if (ha->pscratch)
-            pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
-                                ha->pscratch, ha->scratch_phys);
-        if (ha->pmsg)
-            pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
-                                ha->pmsg, ha->msg_phys);
-        if (ha->ccb_phys)
-            pci_unmap_single(ha->pdev,ha->ccb_phys,
-                             sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
-        gdth_ctr_released++;
-        TRACE2(("gdth_release(): HA %d of %d\n", 
-                gdth_ctr_released, gdth_ctr_count));
-
-        if (gdth_ctr_released == gdth_ctr_count) {
-#ifdef GDTH_STATISTICS
-            del_timer(&gdth_timer);
-#endif
-            unregister_chrdev(major,"gdth");
-            unregister_reboot_notifier(&gdth_notifier);
-        }
-
-    scsi_unregister(shp);
-    return 0;
-}
-            
-
 static const char *gdth_ctr_name(int hanum)
 {
     gdth_ha_str *ha;
@@ -4880,12 +4733,10 @@ static int gdth_slave_configure(struct s
     return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static struct scsi_host_template gdth_template = {
         .proc_name              = "gdth", 
         .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
-        .detect                 = gdth_detect, 
-        .release                = gdth_release,
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
@@ -4900,7 +4751,7 @@ static struct scsi_host_template driver_
 };
 
 #ifdef CONFIG_ISA
-static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
+static int gdth_isa_probe_one(ulong32 isa_bios)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -4910,7 +4761,7 @@ static int gdth_isa_probe_one(struct scs
 	if (!gdth_search_isa(isa_bios))
 		return -ENXIO;
 
-	shp = scsi_register(shtp, sizeof(gdth_ha_str));
+	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
 	ha = shost_priv(shp);
@@ -4944,6 +4795,7 @@ static int gdth_isa_probe_one(struct scs
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
 	ha->hanum = (ushort)hanum;
+	ha->shost = shp;
 
 	ha->pccb = &ha->cmdext;
 	ha->ccb_phys = 0L;
@@ -5001,6 +4853,10 @@ static int gdth_isa_probe_one(struct scs
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
 
+	error = scsi_add_host(shp, NULL);
+	if (error)
+		goto out_free_coal_stat;
+	list_add_tail(&ha->list, &gdth_instances);
 	return 0;
 
  out_free_coal_stat:
@@ -5019,14 +4875,13 @@ static int gdth_isa_probe_one(struct scs
  out_free_irq:
 	free_irq(ha->irq, ha);
  out_host_put:
-	scsi_unregister(shp);
+	scsi_host_put(shp);
 	return error;
 }
 #endif /* CONFIG_ISA */
 
 #ifdef CONFIG_EISA
-static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
-		ushort eisa_slot)
+static int gdth_eisa_probe_one(ushort eisa_slot)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -5036,7 +4891,7 @@ static int gdth_eisa_probe_one(struct sc
 	if (!gdth_search_eisa(eisa_slot))
 		return -ENXIO;
 
-	shp = scsi_register(shtp, sizeof(gdth_ha_str));
+	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
 	ha = shost_priv(shp);
@@ -5062,6 +4917,7 @@ static int gdth_eisa_probe_one(struct sc
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
 	ha->hanum = (ushort)hanum;
+	ha->shost = shp;
 	TRACE2(("EISA detect Bus 0: hanum %d\n", hanum));
 
 	ha->pccb = &ha->cmdext;
@@ -5124,6 +4980,11 @@ static int gdth_eisa_probe_one(struct sc
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
+
+	error = scsi_add_host(shp, NULL);
+	if (error)
+		goto out_free_coal_stat;
+	list_add_tail(&ha->list, &gdth_instances);
 	return 0;
 
  out_free_ccb_phys:
@@ -5144,21 +5005,20 @@ static int gdth_eisa_probe_one(struct sc
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
  out_host_put:
-	scsi_unregister(shp);
+	scsi_host_put(shp);
 	return error;
 }
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int gdth_pci_probe_one(struct scsi_host_template *shtp,
-    		gdth_pci_str *pcistr, int ctr)
+static int gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
 	int error, hanum, i;
 
-	shp = scsi_register(shtp, sizeof(gdth_ha_str));
+	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
         ha = shost_priv(shp);
@@ -5187,6 +5047,7 @@ static int gdth_pci_probe_one(struct scs
 	gdth_ctr_tab[gdth_ctr_count++] = shp;
 
 	ha->hanum = (ushort)hanum;
+	ha->shost = shp;
 
 	ha->pccb = &ha->cmdext;
 	ha->ccb_phys = 0L;
@@ -5258,6 +5119,11 @@ static int gdth_pci_probe_one(struct scs
 
         spin_lock_init(&ha->smp_lock);
         gdth_enable_int(hanum);
+
+	error = scsi_add_host(shp, &pcistr[ctr].pdev->dev);
+	if (error)
+		goto out_free_coal_stat;
+	list_add_tail(&ha->list, &gdth_instances);
 	return 0;
 
  out_free_coal_stat:
@@ -5275,12 +5141,137 @@ static int gdth_pci_probe_one(struct scs
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
  out_host_put:
-	scsi_unregister(shp);
+	scsi_host_put(shp);
 	return error;
 }
 #endif /* CONFIG_PCI */
 
-#include "scsi_module.c"
+static void gdth_remove_one(gdth_ha_str *ha)
+{
+	struct Scsi_Host *shp = ha->shost;
+
+	TRACE2(("gdth_remove_one()\n"));
+
+	scsi_remove_host(shp);
+
+	if (ha->sdev) {
+		scsi_free_host_dev(ha->sdev);
+		ha->sdev = NULL;
+	}
+
+	gdth_flush(ha->hanum);
+
+	if (shp->irq)
+		free_irq(shp->irq,ha);
+
+#ifdef CONFIG_ISA
+	if (shp->dma_channel != 0xff)
+		free_dma(shp->dma_channel);
+#endif
+#ifdef INT_COAL
+	if (ha->coal_stat)
+		pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
+			MAXOFFSETS, ha->coal_stat, ha->coal_stat_phys);
+#endif
+        if (ha->pscratch)
+		pci_free_consistent(ha->pdev, GDTH_SCRATCH,
+			ha->pscratch, ha->scratch_phys);
+	if (ha->pmsg)
+		pci_free_consistent(ha->pdev, sizeof(gdth_msg_str),
+			ha->pmsg, ha->msg_phys);
+	if (ha->ccb_phys)
+		pci_unmap_single(ha->pdev,ha->ccb_phys,
+			sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
+
+	scsi_host_put(shp);
+}
+
+static int __init gdth_init(void)
+{
+	gdth_pci_str pcistr[MAXHA];
+	ulong32 isa_bios;
+	ushort eisa_slot;
+	int cnt, ctr;
+
+	if (disable) {
+		printk("GDT-HA: Controller driver disabled from"
+			" command line !\n");
+		return 0;
+	}
+
+	printk("GDT-HA: Storage RAID Controller Driver. Version: %s\n",
+		GDTH_VERSION_STR);
+
+	/* initializations */
+	gdth_polling = TRUE;
+	gdth_clear_events();
+
+	/* As default we do not probe for EISA or ISA controllers */
+	if (probe_eisa_isa) {
+		/* scanning for controllers, at first: ISA controller */
+#ifdef CONFIG_ISA
+		for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
+			     isa_bios += 0x8000UL) {
+			if (gdth_ctr_count >= MAXHA)
+                		break;
+			gdth_isa_probe_one(isa_bios);
+		}
+#endif
+#ifdef CONFIG_EISA
+		for (eisa_slot = 0x1000; eisa_slot <= 0x8000; eisa_slot += 0x1000) {
+			if (gdth_ctr_count >= MAXHA)
+				break;
+			gdth_eisa_probe_one(eisa_slot);
+		}
+	}
+#endif
+#ifdef CONFIG_PCI
+	/* scanning for PCI controllers */
+	cnt = gdth_search_pci(pcistr);
+	printk("GDT-HA: Found %d PCI Storage RAID Controllers\n",cnt);
+	gdth_sort_pci(pcistr,cnt);
+	for (ctr = 0; ctr < cnt; ++ctr) {
+		if (gdth_ctr_count >= MAXHA)
+			break;
+		gdth_pci_probe_one(pcistr, ctr);
+	}
+#endif
+
+	TRACE2(("gdth_detect() %d controller detected\n",gdth_ctr_count));
+#ifdef GDTH_STATISTICS
+	TRACE2(("gdth_detect(): Initializing timer !\n"));
+	init_timer(&gdth_timer);
+	gdth_timer.expires = jiffies + HZ;
+	gdth_timer.data = 0L;
+	gdth_timer.function = gdth_timeout;
+	add_timer(&gdth_timer);
+#endif
+	major = register_chrdev(0,"gdth",&gdth_fops);
+	notifier_disabled = 0;
+	register_reboot_notifier(&gdth_notifier);
+
+
+	gdth_polling = FALSE;
+	return 0;
+}
+
+static void __exit gdth_exit(void)
+{
+	gdth_ha_str *ha;
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_remove_one(ha);
+
+#ifdef GDTH_STATISTICS
+	del_timer(&gdth_timer);
+#endif
+	unregister_chrdev(major,"gdth");
+	unregister_reboot_notifier(&gdth_notifier);
+}
+
+module_init(gdth_init);
+module_exit(gdth_exit);
+
 #ifndef MODULE
 __setup("gdth=", option_setup);
 #endif
Index: linux-2.6/drivers/scsi/gdth.h
===================================================================
--- linux-2.6.orig/drivers/scsi/gdth.h	2007-07-21 13:11:29.000000000 +0200
+++ linux-2.6/drivers/scsi/gdth.h	2007-07-21 13:11:58.000000000 +0200
@@ -854,6 +854,7 @@ typedef struct {
 /* controller information structure */
 typedef struct {
     struct Scsi_Host    *shost;
+    struct list_head    list;
     ushort      	hanum;
     ushort              oem_id;                 /* OEM */
     ushort              type;                   /* controller class */
