From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 4/4] gdth: convert to modern SCSI host alloc/scan
Date: Sat, 21 Jul 2007 16:36:06 -0400
Message-ID: <20070721203606.GE1004@havoc.gtf.org>
References: <20070721203410.GA1004@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:50658 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761869AbXGUUgH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jul 2007 16:36:07 -0400
Content-Disposition: inline
In-Reply-To: <20070721203410.GA1004@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>


commit 3a8d6339b89cee3c3dbffdde8ca5dfd8184fdb07
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sat Jul 21 06:22:20 2007 -0400

    [SCSI] gdth: convert to modern SCSI host alloc/scan
    
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

 drivers/scsi/gdth.c |  131 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 101 insertions(+), 30 deletions(-)

3a8d6339b89cee3c3dbffdde8ca5dfd8184fdb07
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 7235b1e..10b3bf8 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3960,7 +3960,7 @@ static int __init gdth_register_virt(struct scsi_host_template *shtp,
 {
 	struct Scsi_Host *shp;
 	unchar b;
-	int done = 0;
+	int rc, done = 0;
 
 	if (!virt_ctr)
 		return 0;
@@ -3969,7 +3969,7 @@ static int __init gdth_register_virt(struct scsi_host_template *shtp,
 
 	/* register addit. SCSI channels as virtual controllers */
 	for (b = 1; b < ha->bus_cnt + 1; ++b) {
-		shp = scsi_register(shtp, sizeof(gdth_num_str));
+		shp = scsi_host_alloc(shtp, sizeof(gdth_num_str));
 
 		if (isa_dma) {
 			shp->unchecked_isa_dma = 1;
@@ -3981,12 +3981,17 @@ static int __init gdth_register_virt(struct scsi_host_template *shtp,
 
 		shp->irq = ha->irq;
 
-		gdth_push_vshp(shp);
+		rc = scsi_add_host(shp, dev);
+		if (rc)
+			scsi_host_put(shp);
+		else {
+			gdth_push_vshp(shp);
 
-		NUMDATA(shp)->hanum = (ushort)hanum;
-		NUMDATA(shp)->busnum = b;
+			NUMDATA(shp)->hanum = (ushort)hanum;
+			NUMDATA(shp)->busnum = b;
 
-		done++;
+			done++;
+		}
 	}
 
 	return done ? 0 : -ENODEV;
@@ -3997,10 +4002,10 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
-	int i, hanum;
+	int i, hanum, rc;
 	dma_addr_t scratch_dma_handle = 0;
 
-	shp = scsi_register(shtp, sizeof(gdth_ext_str));
+	shp = scsi_host_alloc(shtp, sizeof(gdth_ext_str));
 	if (shp == NULL)
 		goto err_out;
 
@@ -4009,6 +4014,8 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 		goto err_out_shp;
 
 #ifdef __ia64__
+	if (scsi_add_host(shp, NULL))
+		scsi_host_put(shp);
 	return 0;		/* end loop: success */
 #else
 	/* controller found and initialized */
@@ -4077,13 +4084,26 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
 
-	gdth_register_virt(shtp, ha, hanum, NULL, true);
-
 	spin_lock_init(&ha->smp_lock);
+
+	rc = scsi_add_host(shp, NULL);
+	if (rc) {
+		printk("GDT-ISA: Error adding host\n");
+		goto err_out_ha;
+	}
+
+	rc = gdth_register_virt(shtp, ha, hanum, NULL, true);
+	if (rc) {
+		printk("GDT-ISA: Error adding virt controllers\n");
+		goto err_out_host;
+	}
+
 	gdth_enable_int(hanum);
 
 	return 1;	/* continue looping */
 
+err_out_host:
+	scsi_remove_host(shp);
 err_out_ha:
 	gdth_pop_shp();
 
@@ -4104,7 +4124,7 @@ err_out_irq:
 	free_irq(ha->irq, ha);
 #endif /* !__ia64__ */
 err_out_shp:
-	scsi_unregister(shp);
+	scsi_host_put(shp);
 err_out:
 	return 1;	/* continue looping */
 }
@@ -4114,10 +4134,10 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 {
 	struct Scsi_Host *shp;
 	gdth_ha_str *ha;
-	int i, hanum;
+	int i, hanum, rc;
 	dma_addr_t scratch_dma_handle = 0;
 
-	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	shp = scsi_host_alloc(shtp, sizeof(gdth_ext_str));
 	if (shp == NULL)
 		goto err_out;
 
@@ -4191,13 +4211,26 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
 
-	gdth_register_virt(shtp, ha, hanum, NULL, false);
-
 	spin_lock_init(&ha->smp_lock);
+
+	rc = scsi_add_host(shp, NULL);
+	if (rc) {
+		printk("GDT-EISA: Error adding host\n");
+		goto err_out_ha;
+	}
+
+	rc = gdth_register_virt(shtp, ha, hanum, NULL, false);
+	if (rc) {
+		printk("GDT-EISA: Error adding virt controllers\n");
+		goto err_out_host;
+	}
+
 	gdth_enable_int(hanum);
 
 	return 1;	/* continue looping */
 
+err_out_host:
+	scsi_remove_host(shp);
 err_out_ha:
 	gdth_pop_shp();
 
@@ -4218,7 +4251,7 @@ err_out_ha:
 			    sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
 	free_irq(ha->irq, ha);
 err_out_shp:
-	scsi_unregister(shp);
+	scsi_host_put(shp);
 err_out:
 	return 1;	/* continue looping */
 }
@@ -4229,11 +4262,11 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 	struct Scsi_Host *shp;
 	dma_addr_t scratch_dma_handle = 0;
 	gdth_ha_str *ha;
-	int i, hanum;
+	int i, hanum, rc;
 
 	if (gdth_ctr_count >= MAXHA)
 		return 0;	/* end loop: success */
-	shp = scsi_register(shtp,sizeof(gdth_ext_str));
+	shp = scsi_host_alloc(shtp, sizeof(gdth_ext_str));
 	if (shp == NULL)
 		goto err_out;
 
@@ -4318,13 +4351,26 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
 
-	gdth_register_virt(shtp, ha, hanum, &pcistr[ctr].pdev->dev, false);
-
 	spin_lock_init(&ha->smp_lock);
+
+	rc = scsi_add_host(shp, NULL);
+	if (rc) {
+		printk("GDT-PCI: Error adding host\n");
+		goto err_out_ha;
+	}
+
+	rc = gdth_register_virt(shtp, ha, hanum, &pcistr[ctr].pdev->dev, false);
+	if (rc) {
+		printk("GDT-PCI: Error adding virt controllers\n");
+		goto err_out_host;
+	}
+
 	gdth_enable_int(hanum);
 
 	return 1;	/* continue looping */
 
+err_out_host:
+	scsi_remove_host(shp);
 err_out_ha:
 	gdth_pop_shp();
 
@@ -4343,7 +4389,7 @@ err_out_ha:
 				ha->pmsg, ha->msg_phys);
 	free_irq(ha->irq, ha);
 err_out_shp:
-	scsi_unregister(shp);
+	scsi_host_put(shp);
 err_out:
 	return 1;	/* continue looping */
 }
@@ -4351,7 +4397,7 @@ err_out:
 static int __init gdth_detect(struct scsi_host_template *shtp)
 {
     gdth_pci_str pcistr[MAXHA];
-    int cnt,ctr;
+    int cnt, ctr, i;
     unchar b;
  
 #ifdef DEBUG_GDTH
@@ -4374,7 +4420,7 @@ static int __init gdth_detect(struct scsi_host_template *shtp)
 
     if (disable) {
         printk("GDT-HA: Controller driver disabled from command line !\n");
-        return 0;
+        return -ENODEV;
     }
 
     printk("GDT-HA: Storage RAID Controller Driver. Version: %s\n",GDTH_VERSION_STR);
@@ -4438,14 +4484,22 @@ static int __init gdth_detect(struct scsi_host_template *shtp)
         register_reboot_notifier(&gdth_notifier);
     }
     gdth_polling = FALSE;
-    return gdth_ctr_vcount;
+
+    for (i = 0; i < gdth_ctr_vcount; i++)
+    	if (gdth_ctr_vtab[i])
+    	    scsi_scan_host(gdth_ctr_vtab[i]);
+
+    return gdth_ctr_vcount > 0 ? 0 : -ENODEV;
 }
 
-static int gdth_release(struct Scsi_Host *shp)
+static void __exit gdth_release(struct Scsi_Host *shp)
 {
     int hanum;
     gdth_ha_str *ha;
 
+    if (!shp)
+    	return;
+
     TRACE2(("gdth_release()\n"));
     if (NUMDATA(shp)->busnum == 0) {
         hanum = NUMDATA(shp)->hanum;
@@ -4491,8 +4545,7 @@ static int gdth_release(struct Scsi_Host *shp)
         }
     }
 
-    scsi_unregister(shp);
-    return 0;
+    scsi_host_put(shp);
 }
             
 
@@ -5329,9 +5382,8 @@ static int gdth_slave_configure(struct scsi_device *sdev)
 }
 
 static struct scsi_host_template driver_template = {
+	.module			= THIS_MODULE,
         .name                   = "GDT SCSI Disk Array Controller",
-        .detect                 = gdth_detect, 
-        .release                = gdth_release,
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
@@ -5347,7 +5399,26 @@ static struct scsi_host_template driver_template = {
         .use_clustering         = ENABLE_CLUSTERING,
 };
 
-#include "scsi_module.c"
 #ifndef MODULE
 __setup("gdth=", option_setup);
 #endif
+
+static int __init gdth_mod_init(void)
+{
+	return gdth_detect(&driver_template);
+}
+
+static void __exit gdth_mod_exit(void)
+{
+	int i;
+
+	for (i = 0; i < gdth_ctr_vcount; i++)
+		if (gdth_ctr_vtab[i])
+			scsi_remove_host(gdth_ctr_vtab[i]);
+	for (i = 0; i < gdth_ctr_vcount; i++)
+		gdth_release(gdth_ctr_vtab[i]);
+}
+
+module_init(gdth_mod_init);
+module_exit(gdth_mod_exit);
+
