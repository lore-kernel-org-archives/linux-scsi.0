From: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 7/8] gdth: make some virt ctrlr code common; shuffle SHT
	members
Date: Wed, 26 Sep 2007 00:36:07 -0400
Message-ID: <20070926043607.GF16185@havoc.gtf.org>
References: <20070926043321.GA16055@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756827AbXIZEgg@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070926043321.GA16055@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: achim_leubner@adaptec.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


* New function gdth_register_virt() replaces the three
  basically-duplicate copies of virtual controller registration.

* shuffle scsi_host_template members such that they appear in the
  order in which they are defined in the header.  this makes is easier
  to verify when initializers are missing members.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 89ac155..f382664 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3954,6 +3954,44 @@ int __init option_setup(char *str)
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
 static int __init gdth_start_isa(struct scsi_host_template *shtp,
 				 ulong32 isa_bios)
 {
@@ -4038,21 +4076,8 @@ static int __init gdth_start_isa(struct scsi_host_template *shtp,
 	shp->max_id      = ha->tid_cnt;
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-	if (virt_ctr) {
-		unchar b;
 
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 1;
-			shp->irq = ha->irq;
-			shp->dma_channel = ha->drq;
-			gdth_push_vshp(shp);
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}  
+	gdth_register_virt(shtp, ha, hanum, NULL, true);
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
@@ -4165,21 +4190,8 @@ static int __init gdth_start_eisa(struct scsi_host_template *shtp,
 	shp->max_id      = ha->tid_cnt;
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
-	if (virt_ctr) {
-		unchar b;
 
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 0;
-			shp->irq = ha->irq;
-			shp->dma_channel = 0xff;
-			gdth_push_vshp(shp);
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}  
+	gdth_register_virt(shtp, ha, hanum, NULL, false);
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
@@ -4306,21 +4318,7 @@ static int __init gdth_start_pci(struct scsi_host_template *shtp,
 	shp->max_lun     = MAXLUN;
 	shp->max_channel = virt_ctr ? 0 : ha->bus_cnt;
 
-	if (virt_ctr) {
-		unchar b;
-
-		virt_ctr = 1;
-		/* register addit. SCSI channels as virtual controllers */
-		for (b = 1; b < ha->bus_cnt + 1; ++b) {
-			shp = scsi_register(shtp,sizeof(gdth_num_str));
-			shp->unchecked_isa_dma = 0;
-			shp->irq = ha->irq;
-			shp->dma_channel = 0xff;
-			gdth_push_vshp(shp);
-			NUMDATA(shp)->hanum = (ushort)hanum;
-			NUMDATA(shp)->busnum = b;
-		}
-	}  
+	gdth_register_virt(shtp, ha, hanum, &pcistr[ctr].pdev->dev, false);
 
 	spin_lock_init(&ha->smp_lock);
 	gdth_enable_int(hanum);
@@ -5330,17 +5328,17 @@ static int gdth_slave_configure(struct scsi_device *sdev)
 }
 
 static struct scsi_host_template driver_template = {
-        .proc_name              = "gdth", 
-        .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
         .detect                 = gdth_detect, 
         .release                = gdth_release,
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
+        .slave_configure        = gdth_slave_configure,
         .bios_param             = gdth_bios_param,
+        .proc_info              = gdth_proc_info,
+        .proc_name              = "gdth", 
         .can_queue              = GDTH_MAXCMDS,
-        .slave_configure        = gdth_slave_configure,
         .this_id                = -1,
         .sg_tablesize           = GDTH_MAXSG,
         .cmd_per_lun            = GDTH_MAXC_P_L,
