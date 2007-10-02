From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 12/16] gdth: switch to modern scsi host registration
Date: Tue, 02 Oct 2007 23:09:56 +0200
Message-ID: <4702B3A4.20506@panasas.com>
References: <4702A4A1.2080404@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa3.bezeqint.net ([192.115.104.17]:49350 "EHLO sa3.bezeqint.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271AbXJBVKG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Oct 2007 17:10:06 -0400
In-Reply-To: <4702A4A1.2080404@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kern>

From: Christoph Hellwig <hch@lst.de>

  - Use scsi_add_host and friends and track instances ourselves. And
    generally modernize the driver's structure.

  - TODO: Next we can remove the controller table
  - TODO: Fix use of deprecated pci_find_device()

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |  320 +++++++++++++++++++++++++--------------------------
 drivers/scsi/gdth.h |    1 +
 2 files changed, 157 insertions(+), 164 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index ad60239..e53b4e8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -119,6 +119,7 @@
 #include <linux/time.h>
 #include <linux/timer.h>
 #include <linux/dma-mapping.h>
+#include <linux/list.h>
 
 #ifdef GDTH_RTC
 #include <linux/mc146818rtc.h>
@@ -184,15 +185,6 @@ static void gdth_flush(gdth_ha_str *ha);
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
@@ -298,8 +290,8 @@ static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 #endif
 static unchar   gdth_polling;                           /* polling if TRUE */
 static int      gdth_ctr_count  = 0;                    /* controller count */
-static int      gdth_ctr_released = 0;                  /* gdth_release() */
 static struct Scsi_Host *gdth_ctr_tab[MAXHA];           /* controller table */
+static LIST_HEAD(gdth_instances);
 static unchar   gdth_write_through = FALSE;             /* write through */
 static gdth_evt_str ebuffer[MAX_EVENTS];                /* event buffer */
 static int elastidx;
@@ -3872,145 +3864,6 @@ int __init option_setup(char *str)
     return 1;
 }
 
-static int __init gdth_detect(struct scsi_host_template *shtp)
-{
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
-    gdth_polling = TRUE;
-    gdth_clear_events();
-
-    /* As default we do not probe for EISA or ISA controllers */
-    if (probe_eisa_isa) {    
-        /* scanning for controllers, at first: ISA controller */
-#ifdef CONFIG_ISA
-        ulong32 isa_bios;
-        for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
-             isa_bios += 0x8000UL) {
-            if (gdth_ctr_count >= MAXHA)
-                break;
-            gdth_isa_probe_one(shtp, isa_bios);
-        }
-#endif
-#ifdef CONFIG_EISA
-        {
-        ushort eisa_slot;
-        for (eisa_slot = 0x1000; eisa_slot <= 0x8000; eisa_slot += 0x1000) {
-            if (gdth_ctr_count >= MAXHA)
-                break;
-            gdth_eisa_probe_one(shtp, eisa_slot);
-        }
-        }
-#endif
-    }
-
-#ifdef CONFIG_PCI
-    /* scanning for PCI controllers */
-    {
-    gdth_pci_str pcistr[MAXHA];
-    int cnt,ctr;
-
-    cnt = gdth_search_pci(pcistr);
-    printk("GDT-HA: Found %d PCI Storage RAID Controllers\n",cnt);
-    gdth_sort_pci(pcistr,cnt);
-    for (ctr = 0; ctr < cnt; ++ctr) {
-        if (gdth_ctr_count >= MAXHA)
-            break;
-        gdth_pci_probe_one(shtp, pcistr, ctr);
-    }
-    }
-#endif /* CONFIG_PCI */
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
-
-    TRACE2(("gdth_release()\n"));
-        if (ha->sdev) {
-            scsi_free_host_dev(ha->sdev);
-            ha->sdev = NULL;
-        }
-        gdth_flush(ha);
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
 static const char *gdth_ctr_name(gdth_ha_str *ha)
 {
     TRACE2(("gdth_ctr_name()\n"));
@@ -4819,10 +4672,8 @@ static int gdth_slave_configure(struct scsi_device *sdev)
     return 0;
 }
 
-static struct scsi_host_template driver_template = {
+static struct scsi_host_template gdth_template = {
         .name                   = "GDT SCSI Disk Array Controller",
-        .detect                 = gdth_detect, 
-        .release                = gdth_release,
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
@@ -4839,7 +4690,7 @@ static struct scsi_host_template driver_template = {
 };
 
 #ifdef CONFIG_ISA
-static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
+static int gdth_isa_probe_one(ulong32 isa_bios)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
@@ -4849,7 +4700,7 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 	if (!gdth_search_isa(isa_bios))
 		return -ENXIO;
 
-	shp = scsi_register(shtp, sizeof(gdth_ha_str));
+	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
 	ha = shost_priv(shp);
@@ -4941,6 +4792,10 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(ha);
 
+	error = scsi_add_host(shp, NULL);
+	if (error)
+		goto out_free_coal_stat;
+	list_add_tail(&ha->list, &gdth_instances);
 	return 0;
 
  out_free_coal_stat:
@@ -4959,14 +4814,13 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
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
@@ -4976,7 +4830,7 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 	if (!gdth_search_eisa(eisa_slot))
 		return -ENXIO;
 
-	shp = scsi_register(shtp,sizeof(gdth_ha_str));
+	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
 	ha = shost_priv(shp);
@@ -5066,6 +4920,11 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(ha);
+
+	error = scsi_add_host(shp, NULL);
+	if (error)
+		goto out_free_coal_stat;
+	list_add_tail(&ha->list, &gdth_instances);
 	return 0;
 
  out_free_ccb_phys:
@@ -5086,21 +4945,20 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
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
-		gdth_pci_str *pcistr, int ctr)
+static int gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
 	dma_addr_t scratch_dma_handle = 0;
 	int error, hanum, i;
 
-	shp = scsi_register(shtp,sizeof(gdth_ha_str));
+	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
 	if (!shp)
 		return -ENOMEM;
 	ha = shost_priv(shp);
@@ -5201,6 +5059,11 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(ha);
+
+	error = scsi_add_host(shp, &pcistr[ctr].pdev->dev);
+	if (error)
+		goto out_free_coal_stat;
+	list_add_tail(&ha->list, &gdth_instances);
 	return 0;
 
  out_free_coal_stat:
@@ -5218,12 +5081,141 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
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
+	gdth_flush(ha);
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
+	if (ha->pscratch)
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
+	if (disable) {
+		printk("GDT-HA: Controller driver disabled from"
+                       " command line !\n");
+		return 0;
+	}
+
+	printk("GDT-HA: Storage RAID Controller Driver. Version: %s\n",
+	       GDTH_VERSION_STR);
+
+	/* initializations */
+	gdth_polling = TRUE;
+	gdth_clear_events();
+
+	/* As default we do not probe for EISA or ISA controllers */
+	if (probe_eisa_isa) {
+		/* scanning for controllers, at first: ISA controller */
+#ifdef CONFIG_ISA
+		ulong32 isa_bios;
+		for (isa_bios = 0xc8000UL; isa_bios <= 0xd8000UL;
+		                isa_bios += 0x8000UL) {
+			if (gdth_ctr_count >= MAXHA)
+				break;
+			gdth_isa_probe_one(isa_bios);
+		}
+#endif
+#ifdef CONFIG_EISA
+		{
+			ushort eisa_slot;
+			for (eisa_slot = 0x1000; eisa_slot <= 0x8000;
+			                         eisa_slot += 0x1000) {
+				if (gdth_ctr_count >= MAXHA)
+					break;
+				gdth_eisa_probe_one(eisa_slot);
+			}
+		}
+#endif
+	}
+
+#ifdef CONFIG_PCI
+	/* scanning for PCI controllers */
+	{
+		gdth_pci_str pcistr[MAXHA];
+		int cnt,ctr;
+
+		cnt = gdth_search_pci(pcistr);
+		printk("GDT-HA: Found %d PCI Storage RAID Controllers\n", cnt);
+		gdth_sort_pci(pcistr,cnt);
+		for (ctr = 0; ctr < cnt; ++ctr) {
+			if (gdth_ctr_count >= MAXHA)
+				break;
+			gdth_pci_probe_one(pcistr, ctr);
+		}
+	}
+#endif /* CONFIG_PCI */
+
+	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));
+#ifdef GDTH_STATISTICS
+	TRACE2(("gdth_detect(): Initializing timer !\n"));
+	init_timer(&gdth_timer);
+	gdth_timer.expires = jiffies + HZ;
+	gdth_timer.data = 0L;
+	gdth_timer.function = gdth_timeout;
+	add_timer(&gdth_timer);
+#endif
+	major = register_chrdev(0,"gdth", &gdth_fops);
+	notifier_disabled = 0;
+	register_reboot_notifier(&gdth_notifier);
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
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index e8b9eb7..e6178c4 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -854,6 +854,7 @@ typedef struct {
 /* controller information structure */
 typedef struct {
     struct Scsi_Host    *shost;
+    struct list_head    list;
     ushort      	hanum;
     ushort              oem_id;                 /* OEM */
     ushort              type;                   /* controller class */
-- 
1.5.3.1


