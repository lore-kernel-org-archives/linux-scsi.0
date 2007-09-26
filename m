From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 6/8] gdth: Move probe-time error handling code to end of
	each function
Date: Wed, 26 Sep 2007 00:35:46 -0400
Message-ID: <20070926043546.GE16185@havoc.gtf.org>
References: <20070926043321.GA16055@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:37537 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758688AbXIZEfr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 00:35:47 -0400
Content-Disposition: inline
In-Reply-To: <20070926043321.GA16055@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: achim_leubner@adaptec.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>


Use standard laddered-goto error handling approach in three probe-time
functions.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index d7ef159..89ac155 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3964,13 +3964,11 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 
 	shp = scsi_register(shtp, sizeof(gdth_ext_str));
 	if (shp == NULL)
-		return 1;	/* continue looping */
+		goto err_out;
 
 	ha = HADATA(shp);
-	if (!gdth_init_isa(isa_bios, ha)) {
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
-	}
+	if (!gdth_init_isa(isa_bios, ha))
+		goto err_out_shp;
 
 #ifdef __ia64__
 	return 0;		/* end loop: success */
@@ -3981,14 +3979,11 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 
 	if (request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha)) {
 		printk("GDT-ISA: Unable to allocate IRQ\n");
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
+		goto err_out_shp;
 	}
 	if (request_dma(ha->drq, "gdth")) {
 		printk("GDT-ISA: Unable to allocate DMA channel\n");
-		free_irq(ha->irq, ha);
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
+		goto err_out_irq;
 	}
 
 	set_dma_mode(ha->drq, DMA_MODE_CASCADE);
@@ -4030,25 +4025,7 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 	if (ha->pscratch == NULL || ha->pmsg == NULL || 
 	    !gdth_search_drives(hanum)) {
 		printk("GDT-ISA: Error during device scan\n");
-		gdth_pop_shp();
-
-#ifdef INT_COAL
-		if (ha->coal_stat)
-			pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
-					    MAXOFFSETS, ha->coal_stat,
-					    ha->coal_stat_phys);
-#endif
-
-		if (ha->pscratch)
-			pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
-					    ha->pscratch, ha->scratch_phys);
-		if (ha->pmsg)
-			pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
-					    ha->pmsg, ha->msg_phys);
-
-		free_irq(ha->irq,ha);
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
+		goto err_out_ha;
 	}
 
 	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
@@ -4079,9 +4056,32 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
-#endif /* !__ia64__ */
 
 	return 1;	/* continue looping */
+
+err_out_ha:
+	gdth_pop_shp();
+
+#ifdef INT_COAL
+	if (ha->coal_stat)
+		pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
+				    MAXOFFSETS, ha->coal_stat,
+				    ha->coal_stat_phys);
+#endif
+
+	if (ha->pscratch)
+		pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
+				    ha->pscratch, ha->scratch_phys);
+	if (ha->pmsg)
+		pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
+				    ha->pmsg, ha->msg_phys);
+err_out_irq:
+	free_irq(ha->irq, ha);
+#endif /* !__ia64__ */
+err_out_shp:
+	scsi_unregister(shp);
+err_out:
+	return 1;	/* continue looping */
 }
 
 static int __init gdth_start_eisa(struct scsi_host_template *shtp,
@@ -4094,13 +4094,11 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 
 	shp = scsi_register(shtp,sizeof(gdth_ext_str));
 	if (shp == NULL)
-		return 1;	/* continue looping */
+		goto err_out;
 
 	ha = HADATA(shp);
-	if (!gdth_init_eisa(eisa_slot,ha)) {
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
-	}
+	if (!gdth_init_eisa(eisa_slot,ha))
+		goto err_out_shp;
 
 	/* controller found and initialized */
 	printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
@@ -4108,8 +4106,7 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 
 	if (request_irq(ha->irq,gdth_interrupt,IRQF_DISABLED,"gdth",ha)) {
 		printk("GDT-EISA: Unable to allocate IRQ\n");
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
+		goto err_out_shp;
 	}
 
 	shp->unchecked_isa_dma = 0;
@@ -4155,26 +4152,7 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 	if (ha->pscratch == NULL || ha->pmsg == NULL || 
 	    !gdth_search_drives(hanum)) {
 		printk("GDT-EISA: Error during device scan\n");
-		gdth_pop_shp();
-
-#ifdef INT_COAL
-		if (ha->coal_stat)
-			pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
-					MAXOFFSETS, ha->coal_stat,
-					ha->coal_stat_phys);
-#endif
-		if (ha->pscratch)
-			pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
-					ha->pscratch, ha->scratch_phys);
-		if (ha->pmsg)
-			pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
-					ha->pmsg, ha->msg_phys);
-		if (ha->ccb_phys)
-			pci_unmap_single(ha->pdev,ha->ccb_phys,
-				    sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
-		free_irq(ha->irq,ha);
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
+		goto err_out_ha;
 	}
 
 	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
@@ -4207,6 +4185,30 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 	gdth_enable_int(hanum);
 
 	return 1;	/* continue looping */
+
+err_out_ha:
+	gdth_pop_shp();
+
+#ifdef INT_COAL
+	if (ha->coal_stat)
+		pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
+				MAXOFFSETS, ha->coal_stat,
+				ha->coal_stat_phys);
+#endif
+	if (ha->pscratch)
+		pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
+				ha->pscratch, ha->scratch_phys);
+	if (ha->pmsg)
+		pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
+				ha->pmsg, ha->msg_phys);
+	if (ha->ccb_phys)
+		pci_unmap_single(ha->pdev,ha->ccb_phys,
+			    sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
+	free_irq(ha->irq, ha);
+err_out_shp:
+	scsi_unregister(shp);
+err_out:
+	return 1;	/* continue looping */
 }
 
 static int __init gdth_start_pci(struct scsi_host_template *shtp,
@@ -4215,19 +4217,17 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 	struct Scsi_Host *shp;
 	dma_addr_t scratch_dma_handle = 0;
 	gdth_ha_str *ha;
-	int i, hanum, err;
+	int i, hanum;
 
 	if (gdth_ctr_count >= MAXHA)
 		return 0;	/* end loop: success */
 	shp = scsi_register(shtp,sizeof(gdth_ext_str));
 	if (shp == NULL)
-		return 1;	/* continue looping */
+		goto err_out;
 
 	ha = HADATA(shp);
-	if (!gdth_init_pci(&pcistr[ctr],ha)) {
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
-	}
+	if (!gdth_init_pci(&pcistr[ctr],ha))
+		goto err_out_shp;
 
 	/* controller found and initialized */
 	printk("Configuring GDT-PCI HA at %d/%d IRQ %u\n",
@@ -4237,8 +4237,7 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 	if (request_irq(ha->irq, gdth_interrupt,
 			IRQF_DISABLED | IRQF_SHARED, "gdth", ha)) {
 		printk("GDT-PCI: Unable to allocate IRQ\n");
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
+		goto err_out_shp;
 	}
 
 	shp->unchecked_isa_dma = 0;
@@ -4275,58 +4274,32 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 		ha->cmd_tab[i].cmnd = UNUSED_CMND;
 	ha->scan_mode = rescan ? 0x10 : 0;
 
-	err = FALSE;
 	if (ha->pscratch == NULL || ha->pmsg == NULL || 
-	    !gdth_search_drives(hanum)) {
-		err = TRUE;
-	} else {
-		if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
-			hdr_channel = ha->bus_cnt;
-		ha->virt_bus = hdr_channel;
-
-		if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat &
-		      GDT_64BIT) ||
-			/* 64-bit DMA only supported from FW >= x.43 */
-		    (!ha->dma64_support)) {
-			if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)){
-				printk(KERN_WARNING "GDT-PCI %d: Unable to "
-				       "set 32-bit DMA\n", hanum);
-				err = TRUE;
-			}
-		} else {
-			shp->max_cmd_len = 16;
-			if (!pci_set_dma_mask(pcistr[ctr].pdev,DMA_64BIT_MASK)){
-				printk("GDT-PCI %d: 64-bit DMA enabled\n",
-				       hanum);
-			} else if (pci_set_dma_mask(pcistr[ctr].pdev,
-						    DMA_32BIT_MASK)) {
-				printk(KERN_WARNING "GDT-PCI %d: Unable to set "
-				       "64/32-bit DMA\n", hanum);
-				err = TRUE;
-			}
-		}
-	}
+	    !gdth_search_drives(hanum))
+		goto err_out_ha;
 
-	if (err) {
-		printk("GDT-PCI %d: Error during device scan\n", hanum);
-		gdth_pop_shp();
-
-#ifdef INT_COAL
-		if (ha->coal_stat)
-			pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
-					MAXOFFSETS, ha->coal_stat,
-					ha->coal_stat_phys);
-#endif
+	if (hdr_channel < 0 || hdr_channel > ha->bus_cnt)
+		hdr_channel = ha->bus_cnt;
+	ha->virt_bus = hdr_channel;
 
-		if (ha->pscratch)
-			pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
-					ha->pscratch, ha->scratch_phys);
-		if (ha->pmsg)
-			pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
-					ha->pmsg, ha->msg_phys);
-		free_irq(ha->irq,ha);
-		scsi_unregister(shp);
-		return 1;	/* continue looping */
+	if (!(ha->cache_feat & ha->raw_feat & ha->screen_feat & GDT_64BIT) ||
+		/* 64-bit DMA only supported from FW >= x.43 */
+	    (!ha->dma64_support)) {
+		if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)){
+			printk(KERN_WARNING "GDT-PCI %d: Unable to "
+			       "set 32-bit DMA\n", hanum);
+			goto err_out_ha;
+		}
+	} else {
+		shp->max_cmd_len = 16;
+		if (!pci_set_dma_mask(pcistr[ctr].pdev, DMA_64BIT_MASK)) {
+			printk("GDT-PCI %d: 64-bit DMA enabled\n",
+			       hanum);
+		} else if (pci_set_dma_mask(pcistr[ctr].pdev, DMA_32BIT_MASK)) {
+			printk(KERN_WARNING "GDT-PCI %d: Unable to set "
+			       "64/32-bit DMA\n", hanum);
+			goto err_out_ha;
+		}
 	}
 
 	shp->max_id      = ha->tid_cnt;
@@ -4353,6 +4326,28 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 	gdth_enable_int(hanum);
 
 	return 1;	/* continue looping */
+
+err_out_ha:
+	gdth_pop_shp();
+
+#ifdef INT_COAL
+	if (ha->coal_stat)
+		pci_free_consistent(ha->pdev, sizeof(gdth_coal_status) *
+				MAXOFFSETS, ha->coal_stat,
+				ha->coal_stat_phys);
+#endif
+
+	if (ha->pscratch)
+		pci_free_consistent(ha->pdev, GDTH_SCRATCH, 
+				ha->pscratch, ha->scratch_phys);
+	if (ha->pmsg)
+		pci_free_consistent(ha->pdev, sizeof(gdth_msg_str), 
+				ha->pmsg, ha->msg_phys);
+	free_irq(ha->irq, ha);
+err_out_shp:
+	scsi_unregister(shp);
+err_out:
+	return 1;	/* continue looping */
 }
 
 static int __init gdth_detect(struct scsi_host_template *shtp)
