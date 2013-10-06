From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [SCSI] misc drivers: remove deprecated IRQF_DISABLED
Date: Sun,  6 Oct 2013 07:54:06 +0200
Message-ID: <1381038846-11686-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linuxdrivers@attotech.com, achim_leubner@adaptec.com, xjtuwjp@gmail.com, lindar_liu@usish.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/aic7xxx_old.c        | 2 +-
 drivers/scsi/dtc.c                | 2 +-
 drivers/scsi/esas2r/esas2r_init.c | 2 +-
 drivers/scsi/g_NCR5380.c          | 2 +-
 drivers/scsi/gdth.c               | 6 +++---
 drivers/scsi/in2000.c             | 2 +-
 drivers/scsi/initio.c             | 2 +-
 drivers/scsi/pas16.c              | 2 +-
 drivers/scsi/pm8001/pm8001_init.c | 2 --
 drivers/scsi/t128.c               | 2 +-
 10 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 33ec9c6..cdcc0df 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -8306,7 +8306,7 @@ aic7xxx_register(struct scsi_host_template *template, struct aic7xxx_host *p,
               "aic7xxx", p));
     if (result < 0)
     {
-      result = (request_irq(p->irq, do_aic7xxx_isr, IRQF_DISABLED | IRQF_SHARED,
+      result = (request_irq(p->irq, do_aic7xxx_isr, IRQF_SHARED,
               "aic7xxx", p));
     }
   }
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index d01f016..eb29fe7 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -277,7 +277,7 @@ found:
 		/* With interrupts enabled, it will sometimes hang when doing heavy
 		 * reads. So better not enable them until I finger it out. */
 		if (instance->irq != SCSI_IRQ_NONE)
-			if (request_irq(instance->irq, dtc_intr, IRQF_DISABLED,
+			if (request_irq(instance->irq, dtc_intr, 0,
 					"dtc", instance)) {
 				printk(KERN_ERR "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index da1869d..d28c29e 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -231,7 +231,7 @@ use_legacy_interrupts:
 
 static void esas2r_claim_interrupts(struct esas2r_adapter *a)
 {
-	unsigned long flags = IRQF_DISABLED;
+	unsigned long flags = 0;
 
 	if (a->intr_mode == INTR_MODE_LEGACY)
 		flags |= IRQF_SHARED;
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 5cec6c6..7176365 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -461,7 +461,7 @@ int __init generic_NCR5380_detect(struct scsi_host_template * tpnt)
 
 		if (instance->irq != SCSI_IRQ_NONE)
 			if (request_irq(instance->irq, generic_NCR5380_intr,
-					IRQF_DISABLED, "NCR5380", instance)) {
+					0, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 6d55b4e..5a275c7 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4712,7 +4712,7 @@ static int __init gdth_isa_probe_one(u32 isa_bios)
 	printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
 		isa_bios, ha->irq, ha->drq);
 
-	error = request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha);
+	error = request_irq(ha->irq, gdth_interrupt, 0, "gdth", ha);
 	if (error) {
 		printk("GDT-ISA: Unable to allocate IRQ\n");
 		goto out_host_put;
@@ -4844,7 +4844,7 @@ static int __init gdth_eisa_probe_one(u16 eisa_slot)
 	printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
 		eisa_slot >> 12, ha->irq);
 
-	error = request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha);
+	error = request_irq(ha->irq, gdth_interrupt, 0, "gdth", ha);
 	if (error) {
 		printk("GDT-EISA: Unable to allocate IRQ\n");
 		goto out_host_put;
@@ -4980,7 +4980,7 @@ static int gdth_pci_probe_one(gdth_pci_str *pcistr, gdth_ha_str **ha_out)
 		ha->irq);
 
 	error = request_irq(ha->irq, gdth_interrupt,
-				IRQF_DISABLED|IRQF_SHARED, "gdth", ha);
+				IRQF_SHARED, "gdth", ha);
 	if (error) {
 		printk("GDT-PCI: Unable to allocate IRQ\n");
 		goto out_host_put;
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index bf02821..b1c4d83 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -2015,7 +2015,7 @@ static int __init in2000_detect(struct scsi_host_template * tpnt)
 		write1_io(0, IO_FIFO_READ);	/* start fifo out in read mode */
 		write1_io(0, IO_INTR_MASK);	/* allow all ints */
 		x = int_tab[(switches & (SW_INT0 | SW_INT1)) >> SW_INT_SHIFT];
-		if (request_irq(x, in2000_intr, IRQF_DISABLED, "in2000", instance)) {
+		if (request_irq(x, in2000_intr, 0, "in2000", instance)) {
 			printk("in2000_detect: Unable to allocate IRQ.\n");
 			detect_count--;
 			continue;
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 280d5af..e5dae7b 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2931,7 +2931,7 @@ static int initio_probe_one(struct pci_dev *pdev,
 	shost->base = host->addr;
 	shost->sg_tablesize = TOTAL_SG_ENTRY;
 
-	error = request_irq(pdev->irq, i91u_intr, IRQF_DISABLED|IRQF_SHARED, "i91u", shost);
+	error = request_irq(pdev->irq, i91u_intr, IRQF_SHARED, "i91u", shost);
 	if (error < 0) {
 		printk(KERN_WARNING "initio: Unable to request IRQ %d\n", pdev->irq);
 		goto out_free_scbs;
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index 62f1a60..0d78a4d 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -453,7 +453,7 @@ int __init pas16_detect(struct scsi_host_template * tpnt)
 	    instance->irq = NCR5380_probe_irq(instance, PAS16_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, pas16_intr, IRQF_DISABLED,
+	    if (request_irq(instance->irq, pas16_intr, 0,
 			    "pas16", instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f7c1896..f2a30a5 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -682,11 +682,9 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 	/* SPCv controllers supports 64 msi-x */
 	if (pm8001_ha->chip_id == chip_8001) {
 		number_of_intr = 1;
-		flag |= IRQF_DISABLED;
 	} else {
 		number_of_intr = PM8001_MAX_MSIX_VEC;
 		flag &= ~IRQF_SHARED;
-		flag |= IRQF_DISABLED;
 	}
 
 	max_entry = sizeof(pm8001_ha->msix_entries) /
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index f1e4b41..a4abce9 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -259,7 +259,7 @@ found:
 	    instance->irq = NCR5380_probe_irq(instance, T128_IRQS);
 
 	if (instance->irq != SCSI_IRQ_NONE) 
-	    if (request_irq(instance->irq, t128_intr, IRQF_DISABLED, "t128",
+	    if (request_irq(instance->irq, t128_intr, 0, "t128",
 			    instance)) {
 		printk("scsi%d : IRQ%d not free, interrupts disabled\n", 
 		    instance->host_no, instance->irq);
-- 
1.8.1.2
