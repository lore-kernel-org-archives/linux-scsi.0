From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [4/22] Remove unchecked_isa_dma in gdth
Date: Mon, 25 Feb 2008 00:35:17 +0100 (CET)
Message-ID: <20080224233517.0B3EB1B4183@basil.firstfloor.org>
References: <200802251235.889863872@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:51515 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYBXXvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 18:51:32 -0500
In-Reply-To: <200802251235.889863872@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com


- Audited ->cmnd use and it always copies
- Allocate hostdata separately with GFP_DMA for the ISA case
- Tell scsi layer to bounce sense_buffer for ISA case
- Tell block layer to bounce for isa case
- Remove unchecked_isa_dma

Untested due to lack of hardware

Signed-off-by: Andi Kleen <ak@suse.de>

---
 drivers/scsi/gdth.c |   79 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 60 insertions(+), 19 deletions(-)

Index: linux/drivers/scsi/gdth.c
===================================================================
--- linux.orig/drivers/scsi/gdth.c
+++ linux/drivers/scsi/gdth.c
@@ -138,6 +138,13 @@
 #include <scsi/scsi_host.h>
 #include "gdth.h"
 
+
+struct host_ptr {
+	gdth_ha_str *host_ptr;
+};
+
+#define gdth_shost_priv(host) (((struct host_ptr *)shost_priv(host))->host_ptr)
+
 static void gdth_delay(int milliseconds);
 static void gdth_eval_mapping(ulong32 size, ulong32 *cyls, int *heads, int *secs);
 static irqreturn_t gdth_interrupt(int irq, void *dev_id);
@@ -490,7 +497,7 @@ static void gdth_scsi_done(struct scsi_c
 int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
                    int timeout, u32 *info)
 {
-    gdth_ha_str *ha = shost_priv(sdev->host);
+    gdth_ha_str *ha = gdth_shost_priv(sdev->host);
     Scsi_Cmnd *scp;
     struct gdth_cmndinfo cmndinfo;
     struct scatterlist one_sg;
@@ -3933,7 +3940,7 @@ static const char *gdth_ctr_name(gdth_ha
 
 static const char *gdth_info(struct Scsi_Host *shp)
 {
-    gdth_ha_str *ha = shost_priv(shp);
+    gdth_ha_str *ha = gdth_shost_priv(shp);
 
     TRACE2(("gdth_info()\n"));
     return ((const char *)ha->binfo.type_string);
@@ -3941,7 +3948,7 @@ static const char *gdth_info(struct Scsi
 
 static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
-    gdth_ha_str *ha = shost_priv(scp->device->host);
+    gdth_ha_str *ha = gdth_shost_priv(scp->device->host);
     int i;
     ulong flags;
     Scsi_Cmnd *cmnd;
@@ -3994,7 +4001,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
 {
     unchar b, t;
-    gdth_ha_str *ha = shost_priv(sdev->host);
+    gdth_ha_str *ha = gdth_shost_priv(sdev->host);
     struct scsi_device *sd;
     unsigned capacity;
 
@@ -4023,7 +4030,7 @@ static int gdth_bios_param(struct scsi_d
 static int gdth_queuecommand(struct scsi_cmnd *scp,
 				void (*done)(struct scsi_cmnd *))
 {
-    gdth_ha_str *ha = shost_priv(scp->device->host);
+    gdth_ha_str *ha = gdth_shost_priv(scp->device->host);
     struct gdth_cmndinfo *cmndinfo;
 
     TRACE(("gdth_queuecommand() cmd 0x%x\n", scp->cmnd[0]));
@@ -4717,6 +4724,13 @@ static int gdth_slave_configure(struct s
     return 0;
 }
 
+static int gdth_adjust_queue(struct scsi_device *device)
+{
+	if (device->host->sense_buffer_mask)
+		blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 static struct scsi_host_template gdth_template = {
         .name                   = "GDT SCSI Disk Array Controller",
         .info                   = gdth_info, 
@@ -4730,10 +4744,39 @@ static struct scsi_host_template gdth_te
         .this_id                = -1,
         .sg_tablesize           = GDTH_MAXSG,
         .cmd_per_lun            = GDTH_MAXC_P_L,
-        .unchecked_isa_dma      = 1,
         .use_clustering         = ENABLE_CLUSTERING,
+	.slave_alloc 		= gdth_adjust_queue,
 };
 
+static struct Scsi_Host *gdth_host_alloc(gfp_t gfp)
+{
+	struct Scsi_Host *shost;
+	gdth_ha_str *board;
+	shost = scsi_host_alloc(&gdth_template, sizeof(struct host_ptr));
+	if (!shost)
+		return NULL;
+
+	board = (void *)__get_free_pages(gfp|GFP_KERNEL,
+					 get_order(sizeof(gdth_ha_str)));
+	if (!board) {
+		scsi_host_put(shost);
+		return NULL;
+	}
+
+	memset(board, 0, sizeof(gdth_ha_str));
+	gdth_shost_priv(shost) = board;
+
+	return shost;
+}
+
+static void gdth_free_host(struct Scsi_Host *shost)
+{
+	free_pages((unsigned long)gdth_shost_priv(shost),
+		     get_order(sizeof(gdth_ha_str)));
+	scsi_host_put(shost);
+}
+
+
 #ifdef CONFIG_ISA
 static int __init gdth_isa_probe_one(ulong32 isa_bios)
 {
@@ -4745,10 +4788,10 @@ static int __init gdth_isa_probe_one(ulo
 	if (!gdth_search_isa(isa_bios))
 		return -ENXIO;
 
-	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
+	shp = gdth_host_alloc(GFP_DMA);
 	if (!shp)
 		return -ENOMEM;
-	ha = shost_priv(shp);
+	ha = gdth_shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_isa(isa_bios,ha))
@@ -4772,7 +4815,7 @@ static int __init gdth_isa_probe_one(ulo
 
 	set_dma_mode(ha->drq,DMA_MODE_CASCADE);
 	enable_dma(ha->drq);
-	shp->unchecked_isa_dma = 1;
+	shp->sense_buffer_mask = DMA_24BIT_MASK;
 	shp->irq = ha->irq;
 	shp->dma_channel = ha->drq;
 
@@ -4860,7 +4903,7 @@ static int __init gdth_isa_probe_one(ulo
  out_free_irq:
 	free_irq(ha->irq, ha);
  out_host_put:
-	scsi_host_put(shp);
+	gdth_free_host(shp);
 	return error;
 }
 #endif /* CONFIG_ISA */
@@ -4876,10 +4919,10 @@ static int __init gdth_eisa_probe_one(us
 	if (!gdth_search_eisa(eisa_slot))
 		return -ENXIO;
 
-	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
+	shp = gdth_host_alloc(0);
 	if (!shp)
 		return -ENOMEM;
-	ha = shost_priv(shp);
+	ha = gdth_shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_eisa(eisa_slot,ha))
@@ -4895,7 +4938,6 @@ static int __init gdth_eisa_probe_one(us
 		goto out_host_put;
 	}
 
-	shp->unchecked_isa_dma = 0;
 	shp->irq = ha->irq;
 	shp->dma_channel = 0xff;
 
@@ -4992,7 +5034,7 @@ static int __init gdth_eisa_probe_one(us
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
  out_host_put:
-	scsi_host_put(shp);
+	gdth_free_host(shp);
 	return error;
 }
 #endif /* CONFIG_EISA */
@@ -5005,10 +5047,10 @@ static int __init gdth_pci_probe_one(gdt
 	dma_addr_t scratch_dma_handle = 0;
 	int error, i;
 
-	shp = scsi_host_alloc(&gdth_template, sizeof(gdth_ha_str));
+	shp = gdth_host_alloc(0);
 	if (!shp)
 		return -ENOMEM;
-	ha = shost_priv(shp);
+	ha = gdth_shost_priv(shp);
 
 	error = -ENODEV;
 	if (!gdth_init_pci(&pcistr[ctr],ha))
@@ -5027,7 +5069,6 @@ static int __init gdth_pci_probe_one(gdt
 		goto out_host_put;
 	}
 
-	shp->unchecked_isa_dma = 0;
 	shp->irq = ha->irq;
 	shp->dma_channel = 0xff;
 
@@ -5129,7 +5170,7 @@ static int __init gdth_pci_probe_one(gdt
 	free_irq(ha->irq, ha);
 	gdth_ctr_count--;
  out_host_put:
-	scsi_host_put(shp);
+	gdth_free_host(shp);
 	return error;
 }
 #endif /* CONFIG_PCI */
@@ -5171,7 +5212,7 @@ static void gdth_remove_one(gdth_ha_str 
 		pci_unmap_single(ha->pdev,ha->ccb_phys,
 			sizeof(gdth_cmd_str),PCI_DMA_BIDIRECTIONAL);
 
-	scsi_host_put(shp);
+	gdth_free_host(shp);
 }
 
 static int __init gdth_init(void)
