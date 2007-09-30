From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 7/16] gdth: make some virt ctrlr code common
Date: Sun, 30 Sep 2007 22:01:56 +0200
Message-ID: <470000B4.1060504@panasas.com>
References: <46FFFC8C.6080804@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa10.bezeqint.net ([192.115.104.24]:55997 "EHLO
	sa10.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbXI3UCC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Sep 2007 16:02:02 -0400
In-Reply-To: <46FFFC8C.6080804@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>


  * New function gdth_register_virt() replaces the three
    basically-duplicate copies of virtual controller registration.

  Signed-off-by: Jeff Garzik <jeff@garzik.org>
  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/gdth.c |   80 ++++++++++++++++++++++++++-------------------------
 1 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 4fa6609..b31c5eb 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3925,6 +3925,44 @@ int __init option_setup(char *str)
     return 1;
 }
 
+static int __init gdth_register_virt(struct scsi_host_template *shtp,
+				     gdth_ha_str *ha, int hanum,
+				     struct device *dev, bool isa_dma)
+{
+	struct Scsi_Host *shp;
+	unchar b;
+	int done = 0;
+
+	if (!virt_ctr)
+		return 0;
+
+	virt_ctr = 1;
+
+	/* register addit. SCSI channels as virtual controllers */
+	for (b = 1; b < ha->bus_cnt + 1; ++b) {
+		shp = scsi_register(shtp, sizeof(gdth_num_str));
+
+		if (isa_dma) {
+			shp->unchecked_isa_dma = 1;
+			shp->dma_channel = ha->drq;
+		} else {
+			shp->unchecked_isa_dma = 0;
+			shp->dma_channel = 0xff;
+		}
+
+		shp->irq = ha->irq;
+
+		gdth_push_vshp(shp);
+
+		NUMDATA(shp)->hanum = (ushort)hanum;
+		NUMDATA(shp)->busnum = b;
+
+		done++;
+	}
+
+	return done ? 0 : -ENODEV;
+}
+
 
 static int __init gdth_detect(struct scsi_host_template *shtp)
 {
@@ -5017,19 +5055,7 @@ static int gdth_isa_probe_one(struct scsi_host_template *shtp, ulong32 isa_bios)
 	shp->max_id      = ha->tid_cnt;
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-	if (virt_ctr) {
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 1;
-			shp->irq = ha->irq;
-			shp->dma_channel = ha->drq;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}
+	gdth_register_virt(shtp, ha, hanum, NULL, true);
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
@@ -5159,19 +5185,7 @@ static int gdth_eisa_probe_one(struct scsi_host_template *shtp,
 	shp->max_id      = ha->tid_cnt;
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-	if (virt_ctr) {
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 0;
-			shp->irq = ha->irq;
-			shp->dma_channel = 0xff;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}
+	gdth_register_virt(shtp, ha, hanum, NULL, false);
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
@@ -5310,19 +5324,7 @@ static int gdth_pci_probe_one(struct scsi_host_template *shtp,
 	shp->max_id      = ha->tid_cnt;
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-	if (virt_ctr) {
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 0;
-			shp->irq = ha->irq;
-			shp->dma_channel = 0xff;
-			gdth_ctr_vtab[gdth_ctr_vcount++] = shp;
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}
+	gdth_register_virt(shtp, ha, hanum, &pcistr[ctr].pdev->dev, false);
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
