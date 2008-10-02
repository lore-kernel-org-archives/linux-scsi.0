From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [7/21] SCSI-ISA-DMA: Remove unchecked_isa_dma in gdth
Date: Thu,  2 Oct 2008 09:58:45 +0200 (CEST)
Message-ID: <20081002075845.36E453E6A09@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57081 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYJBH6q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:46 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


- Audited ->cmnd use and it always copies
- Allocate hostdata separately with GFP_DMA for the ISA case
- Tell scsi layer to bounce sense_buffer for ISA case
- Tell block layer to bounce for isa case
- Remove unchecked_isa_dma

Untested due to lack of hardware

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/gdth.c |   81 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 62 insertions(+), 19 deletions(-)

Index: linux/drivers/scsi/gdth.c
===================================================================
--- linux.orig/drivers/scsi/gdth.c
+++ linux/drivers/scsi/gdth.c
@@ -139,6 +139,15 @@
 #include <scsi/scsi_host.h>
 #include "gdth.h"
 
+
+struct host_ptr {
+	gdth_ha_str *host_ptr;
+	dma_addr_t dma;
+};
+
+#define gdth_shost_priv(host) (((struct host_ptr *)shost_priv(host))->host_ptr)
+#define gdth_shost_dma(host) (((struct host_ptr *)shost_priv(host))->dma)
+
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
@@ -443,7 +452,7 @@ static void gdth_scsi_done(struct scsi_c
 int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
                    int timeout, u32 *info)
 {
-    gdth_ha_str *ha = shost_priv(sdev->host);
+    gdth_ha_str *ha = gdth_shost_priv(sdev->host);
     Scsi_Cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
     DECLARE_COMPLETION_ONSTACK(wait);
@@ -3893,7 +3902,7 @@ static const char *gdth_ctr_name(gdth_ha
 
 static const char *gdth_info(struct Scsi_Host *shp)
 {
-    gdth_ha_str *ha = shost_priv(shp);
+    gdth_ha_str *ha = gdth_shost_priv(shp);
 
     TRACE2(("gdth_info()\n"));
     return ((const char *)ha->binfo.type_string);
@@ -3901,7 +3910,7 @@ static const char *gdth_info(struct Scsi
 
 static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
-    gdth_ha_str *ha = shost_priv(scp->device->host);
+    gdth_ha_str *ha = gdth_shost_priv(scp->device->host);
     int i;
     ulong flags;
     Scsi_Cmnd *cmnd;
@@ -3954,7 +3963,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
 {
     unchar b, t;
-    gdth_ha_str *ha = shost_priv(sdev->host);
+    gdth_ha_str *ha = gdth_shost_priv(sdev->host);
     struct scsi_device *sd;
     unsigned capacity;
 
@@ -3983,7 +3992,7 @@ static int gdth_bios_param(struct scsi_d
 static int gdth_queuecommand(struct scsi_cmnd *scp,
 				void (*done)(struct scsi_cmnd *))
 {
-    gdth_ha_str *ha = shost_priv(scp->device->host);
+    gdth_ha_str *ha = gdth_shost_priv(scp->device->host);
     struct gdth_cmndinfo *cmndinfo;
 
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
@@ -4636,6 +4645,13 @@ static int gdth_slave_configure(struct s
     return 0;
 }
 
+static int gdth_adjust_queue(struct scsi_device *device)
+{
+	if (device->host->sense_buffer_isa)
+		blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 static struct scsi_host_template gdth_template = {
         .name                   = "GDT SCSI Disk Array Controller",
         .info                   = gdth_info, 
@@ -4649,10 +4665,38 @@ static struct scsi_host_template gdth_te
         .this_id                = -1,
         .sg_tablesize           = GDTH_MAXSG,
         .cmd_per_lun            = GDTH_MAXC_P_L,
-        .unchecked_isa_dma      = 1,
         .use_clustering         = ENABLE_CLUSTERING,
+	.slave_alloc		= gdth_adjust_queue,
 };
 
+static struct Scsi_Host *gdth_host_alloc(struct device *dev)
+{
+	struct Scsi_Host *shost;
+	gdth_ha_str *board;
+	shost = scsi_host_alloc(&gdth_template, sizeof(struct host_ptr));
+	if (!shost)
+		return NULL;
+
+	board = dma_alloc_coherent(dev, sizeof(gdth_ha_str),
+				&gdth_shost_dma(shost), GFP_KERNEL);
+	if (!board) {
+		scsi_host_put(shost);
+		return NULL;
+	}
+
+	gdth_shost_priv(shost) = board;
+
+	return shost;
+}
+
+static void gdth_free_host(struct Scsi_Host *shost)
+{
+	gdth_ha_str *h = gdth_shost_priv(shost);
+	dma_free_coherent(h->pdev ? &h->pdev->dev : NULL, sizeof(gdth_ha_str),
+			  h, gdth_shost_dma(shost));
+	scsi_host_put(shost);
+}
+
 #ifdef CONFIG_ISA
 static int __init gdth_isa_probe_one(ulong32 isa_bios)
 {
@@ -4664,10 +4708,10 @@ static int __init gdth_isa_probe_one(ulo
 	if (!gdth_search_isa(isa_bios))
 		return -ENXIO;
 
-	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
+	shp = gdth_host_alloc(NULL);
 	if (!shp)
 		return -ENOMEM;
-	ha = shost_priv(shp);
+	ha = gdth_shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_isa(isa_bios,ha))
@@ -4691,7 +4735,7 @@ static int __init gdth_isa_probe_one(ulo
 
 	set_dma_mode(ha->drq,DMA_MODE_CASCADE);
 	enable_dma(ha->drq);
-	shp->unchecked_isa_dma = 1;
+	shp->sense_buffer_isa = 1;
 	shp->irq = ha->irq;
 	shp->dma_channel = ha->drq;
 
@@ -4780,7 +4824,7 @@ static int __init gdth_isa_probe_one(ulo
  out_free_irq:
 	free_irq(ha->irq, ha);
  out_host_put:
-	scsi_host_put(shp);
+	gdth_free_host(shp);
 	return error;
 }
 #endif /* CONFIG_ISA */
@@ -4796,10 +4840,11 @@ static int __init gdth_eisa_probe_one(us
 	if (!gdth_search_eisa(eisa_slot))
 		return -ENXIO;
 
-	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
+	/* RED-PEN NULL device ISA mask is 24bit, but EISA 32bit */
+	shp = gdth_host_alloc(NULL);
 	if (!shp)
 		return -ENOMEM;
-	ha = shost_priv(shp);
+	ha = gdth_shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_eisa(eisa_slot,ha))
@@ -4815,7 +4860,6 @@ static int __init gdth_eisa_probe_one(us
 		goto out_host_put;
 	}
 
-	shp->unchecked_isa_dma = 0;
 	shp->irq = ha->irq;
 	shp->dma_channel = 0xff;
 
@@ -4913,7 +4957,7 @@ static int __init gdth_eisa_probe_one(us
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
  out_host_put:
-	scsi_host_put(shp);
+	gdth_free_host(shp);
 	return error;
 }
 #endif /* CONFIG_EISA */
@@ -4930,10 +4974,10 @@ static int gdth_pci_probe_one(gdth_pci_s
 
 	*ha_out = NULL;
 
-	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
+	shp = gdth_host_alloc(&pcistr->pdev->dev);
 	if (!shp)
 		return -ENOMEM;
-	ha = shost_priv(shp);
+	ha = gdth_shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_pci(pdev, pcistr, ha))
@@ -4952,7 +4996,6 @@ static int gdth_pci_probe_one(gdth_pci_s
 		goto out_host_put;
 	}
 
-	shp->unchecked_isa_dma = 0;
 	shp->irq = ha->irq;
 	shp->dma_channel = 0xff;
 
@@ -5059,7 +5102,7 @@ static int gdth_pci_probe_one(gdth_pci_s
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
  out_host_put:
-	scsi_host_put(shp);
+	gdth_free_host(shp);
 	return error;
 }
 #endif /* CONFIG_PCI */
@@ -5101,7 +5144,7 @@ static void gdth_remove_one(gdth_ha_str 
 		pci_unmap_single(ha->pdev,ha->ccb_phys,
 			sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
 
-	scsi_host_put(shp);
+	gdth_free_host(shp);
 }
 
 static int gdth_halt(struct notifier_block *nb, ulong event, void *buf)
