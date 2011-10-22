From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 24/49] SCSI: irq: Remove IRQF_DISABLED
Date: Sat, 22 Oct 2011 17:56:36 +0800
Message-ID: <1319277421-9203-25-git-send-email-yong.zhang0@gmail.com>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, "James E.J. Bottomley" <JBottomley@parallels.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "Juergen E. Fischer" <fischer@norbit.de>, Russell King <linux@arm.linux.org.uk>, Michael Neuffer <mike@i-Connect.Net>, Dario Ballabio <ballabio_dario@emc.com>, Achim Leubner <achim_leubner@adaptec.com>, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, jack_wang@usish.com, lindar_liu@usish.com, Miroslav Zagorac <zaga@fly.cc.fer.hr>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-eata@i-connect.net, iss_storagedev@hp.com
List-Id: linux-scsi@vger.kernel.org

Since commit [e58aa3d2: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Jack Wang <jack_wang@usish.com>
---
 drivers/scsi/NCR5380.c            |    2 +-
 drivers/scsi/aacraid/rx.c         |    2 +-
 drivers/scsi/aacraid/sa.c         |    2 +-
 drivers/scsi/aacraid/src.c        |    2 +-
 drivers/scsi/aha152x.c            |    4 ++--
 drivers/scsi/aic7xxx_old.c        |    2 +-
 drivers/scsi/arm/acornscsi.c      |    2 +-
 drivers/scsi/arm/cumana_1.c       |    2 +-
 drivers/scsi/arm/cumana_2.c       |    2 +-
 drivers/scsi/arm/powertec.c       |    2 +-
 drivers/scsi/dtc.c                |    2 +-
 drivers/scsi/eata.c               |    2 +-
 drivers/scsi/eata_pio.c           |    4 ++--
 drivers/scsi/g_NCR5380.c          |    2 +-
 drivers/scsi/gdth.c               |    6 +++---
 drivers/scsi/hpsa.c               |    4 ++--
 drivers/scsi/ibmvscsi/ibmvstgt.c  |    2 +-
 drivers/scsi/in2000.c             |    2 +-
 drivers/scsi/initio.c             |    2 +-
 drivers/scsi/pas16.c              |    2 +-
 drivers/scsi/pm8001/pm8001_init.c |    4 +---
 drivers/scsi/t128.c               |    2 +-
 drivers/scsi/u14-34f.c            |    2 +-
 drivers/scsi/wd7000.c             |    2 +-
 24 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 165e4dd..9f6de17 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -584,7 +584,7 @@ static int __init __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 	NCR5380_setup(instance);
 
 	for (trying_irqs = i = 0, mask = 1; i < 16; ++i, mask <<= 1)
-		if ((mask & possible) && (request_irq(i, &probe_intr, IRQF_DISABLED, "NCR-probe", NULL) == 0))
+		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
 			trying_irqs |= mask;
 
 	timeout = jiffies + (250 * HZ / 1000);
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index ce530f1..d1e2a2a 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -645,7 +645,7 @@ int _aac_rx_init(struct aac_dev *dev)
 	aac_adapter_comm(dev, dev->comm_interface);
 	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+			IRQF_SHARED, "aacraid", dev) < 0) {
 		if (dev->msi)
 			pci_disable_msi(dev->pdev);
 		printk(KERN_ERR "%s%d: Interrupt unavailable.\n",
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index e5d4457..c3e1f6b 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -386,7 +386,7 @@ int aac_sa_init(struct aac_dev *dev)
 	if(aac_init_adapter(dev) == NULL)
 		goto error_irq;
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED,
+			IRQF_SHARED,
 			"aacraid", (void *)dev ) < 0) {
 		printk(KERN_WARNING "%s%d: Interrupt unavailable.\n",
 			name, instance);
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 957595a..68374e4 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -565,7 +565,7 @@ int aac_src_init(struct aac_dev *dev)
 	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
 
 	if (request_irq(dev->pdev->irq, dev->a_ops.adapter_intr,
-			IRQF_SHARED|IRQF_DISABLED, "aacraid", dev) < 0) {
+			IRQF_SHARED, "aacraid", dev) < 0) {
 
 		if (dev->msi)
 			pci_disable_msi(dev->pdev);
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f17c92c..46e7a53 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -858,7 +858,7 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	SETPORT(SIMODE0, 0);
 	SETPORT(SIMODE1, 0);
 
-	if( request_irq(shpnt->irq, swintr, IRQF_DISABLED|IRQF_SHARED, "aha152x", shpnt) ) {
+	if( request_irq(shpnt->irq, swintr, IRQF_SHARED, "aha152x", shpnt) ) {
 		printk(KERN_ERR "aha152x%d: irq %d busy.\n", shpnt->host_no, shpnt->irq);
 		goto out_host_put;
 	}
@@ -892,7 +892,7 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	SETPORT(SSTAT0, 0x7f);
 	SETPORT(SSTAT1, 0xef);
 
-	if ( request_irq(shpnt->irq, intr, IRQF_DISABLED|IRQF_SHARED, "aha152x", shpnt) ) {
+	if ( request_irq(shpnt->irq, intr, IRQF_SHARED, "aha152x", shpnt) ) {
 		printk(KERN_ERR "aha152x%d: failed to reassign irq %d.\n", shpnt->host_no, shpnt->irq);
 		goto out_host_put;
 	}
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 5b212f0..c3499dd 100644
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
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index c454e44..d58ea8e 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2997,7 +2997,7 @@ acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 	ec->irqaddr	= ashost->fast + INT_REG;
 	ec->irqmask	= 0x0a;
 
-	ret = request_irq(host->irq, acornscsi_intr, IRQF_DISABLED, "acornscsi", ashost);
+	ret = request_irq(host->irq, acornscsi_intr, 0, "acornscsi", ashost);
 	if (ret) {
 		printk(KERN_CRIT "scsi%d: IRQ%d not free: %d\n",
 			host->host_no, ashost->scsi.irq, ret);
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index a3398fe..c5f46ba 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -264,7 +264,7 @@ cumanascsi1_probe(struct expansion_card *ec, const struct ecard_id *id)
 		goto out_unmap;
 	}
 
-	ret = request_irq(host->irq, cumanascsi_intr, IRQF_DISABLED,
+	ret = request_irq(host->irq, cumanascsi_intr, 0,
 			  "CumanaSCSI-1", host);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 547987b..084ed7b 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -456,7 +456,7 @@ cumanascsi2_probe(struct expansion_card *ec, const struct ecard_id *id)
 		goto out_free;
 
 	ret = request_irq(ec->irq, cumanascsi_2_intr,
-			  IRQF_DISABLED, "cumanascsi2", info);
+			  0, "cumanascsi2", info);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
 		       host->host_no, ec->irq, ret);
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 9274c06..49ac0c2 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -369,7 +369,7 @@ powertecscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 		goto out_free;
 
 	ret = request_irq(ec->irq, powertecscsi_intr,
-			  IRQF_DISABLED, "powertec", info);
+			  0, "powertec", info);
 	if (ret) {
 		printk("scsi%d: IRQ%d not free: %d\n",
 		       host->host_no, ec->irq, ret);
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index c2677ba..c77c820 100644
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
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 94de889..bc2e02e 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1221,7 +1221,7 @@ static int port_detect(unsigned long port_base, unsigned int j,
 
 	/* Board detected, allocate its IRQ */
 	if (request_irq(irq, do_interrupt_handler,
-			IRQF_DISABLED | ((subversion == ESA) ? IRQF_SHARED : 0),
+			((subversion == ESA) ? IRQF_SHARED : 0),
 			driver_name, (void *)&sha[j])) {
 		printk("%s: unable to allocate IRQ %u, detaching.\n", name,
 		       irq);
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index d5f8362..dcc9820 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -723,7 +723,7 @@ static int register_pio_HBA(long base, struct get_conf *gc, struct pci_dev *pdev
 		return 0;
 
 	if (!reg_IRQ[gc->IRQ]) {	/* Interrupt already registered ? */
-		if (!request_irq(gc->IRQ, do_eata_pio_int_handler, IRQF_DISABLED, "EATA-PIO", sh)) {
+		if (!request_irq(gc->IRQ, do_eata_pio_int_handler, 0, "EATA-PIO", sh)) {
 			reg_IRQ[gc->IRQ]++;
 			if (!gc->IRQ_TR)
 				reg_IRQL[gc->IRQ] = 1;	/* IRQ is edge triggered */
@@ -957,7 +957,7 @@ static int eata_pio_detect(struct scsi_host_template *tpnt)
 
 	for (i = 0; i <= MAXIRQ; i++)
 		if (reg_IRQ[i])
-			request_irq(i, do_eata_pio_int_handler, IRQF_DISABLED, "EATA-PIO", NULL);
+			request_irq(i, do_eata_pio_int_handler, 0, "EATA-PIO", NULL);
 
 	HBA_ptr = first_HBA;
 
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 81182ba..72cf40f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -462,7 +462,7 @@ int __init generic_NCR5380_detect(struct scsi_host_template * tpnt)
 
 		if (instance->irq != SCSI_IRQ_NONE)
 			if (request_irq(instance->irq, generic_NCR5380_intr,
-					IRQF_DISABLED, "NCR5380", instance)) {
+					0, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = SCSI_IRQ_NONE;
 			}
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3242bca..045cc61 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4718,7 +4718,7 @@ static int __init gdth_isa_probe_one(u32 isa_bios)
 	printk("Configuring GDT-ISA HA at BIOS 0x%05X IRQ %u DRQ %u\n",
 		isa_bios, ha->irq, ha->drq);
 
-	error = request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha);
+	error = request_irq(ha->irq, gdth_interrupt, 0, "gdth", ha);
 	if (error) {
 		printk("GDT-ISA: Unable to allocate IRQ\n");
 		goto out_host_put;
@@ -4850,7 +4850,7 @@ static int __init gdth_eisa_probe_one(u16 eisa_slot)
 	printk("Configuring GDT-EISA HA at Slot %d IRQ %u\n",
 		eisa_slot >> 12, ha->irq);
 
-	error = request_irq(ha->irq, gdth_interrupt, IRQF_DISABLED, "gdth", ha);
+	error = request_irq(ha->irq, gdth_interrupt, 0, "gdth", ha);
 	if (error) {
 		printk("GDT-EISA: Unable to allocate IRQ\n");
 		goto out_host_put;
@@ -4987,7 +4987,7 @@ static int __devinit gdth_pci_probe_one(gdth_pci_str *pcistr,
 		ha->irq);
 
 	error = request_irq(ha->irq, gdth_interrupt,
-				IRQF_DISABLED|IRQF_SHARED, "gdth", ha);
+				IRQF_SHARED, "gdth", ha);
 	if (error) {
 		printk("GDT-PCI: Unable to allocate IRQ\n");
 		goto out_host_put;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b200b73..444ea3b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4025,10 +4025,10 @@ static int hpsa_request_irq(struct ctlr_info *h,
 
 	if (h->msix_vector || h->msi_vector)
 		rc = request_irq(h->intr[h->intr_mode], msixhandler,
-				IRQF_DISABLED, h->devname, h);
+				0, h->devname, h);
 	else
 		rc = request_irq(h->intr[h->intr_mode], intxhandler,
-				IRQF_DISABLED, h->devname, h);
+				0, h->devname, h);
 	if (rc) {
 		dev_err(&h->pdev->dev, "unable to get irq %d for %s\n",
 		       h->intr[h->intr_mode], h->devname);
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index 2256bab..41d42f2 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -589,7 +589,7 @@ static int crq_queue_create(struct crq_queue *queue, struct srp_target *target)
 	}
 
 	err = request_irq(vport->dma_dev->irq, &ibmvstgt_interrupt,
-			  IRQF_DISABLED, "ibmvstgt", target);
+			  0, "ibmvstgt", target);
 	if (err)
 		goto req_irq_failed;
 
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 112f1be..1efb20b 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -2016,7 +2016,7 @@ static int __init in2000_detect(struct scsi_host_template * tpnt)
 		write1_io(0, IO_FIFO_READ);	/* start fifo out in read mode */
 		write1_io(0, IO_INTR_MASK);	/* allow all ints */
 		x = int_tab[(switches & (SW_INT0 | SW_INT1)) >> SW_INT_SHIFT];
-		if (request_irq(x, in2000_intr, IRQF_DISABLED, "in2000", instance)) {
+		if (request_irq(x, in2000_intr, 0, "in2000", instance)) {
 			printk("in2000_detect: Unable to allocate IRQ.\n");
 			detect_count--;
 			continue;
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index dd741bc..4c80c7d 100644
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
index f2018b4..e75d43d 100644
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
index c21a216..12204c8 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -553,12 +553,10 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,
 {
 	u32 i = 0, j = 0;
 	u32 number_of_intr = 1;
-	int flag = 0;
 	u32 max_entry;
 	int rc;
 	max_entry = sizeof(pm8001_ha->msix_entries) /
 		sizeof(pm8001_ha->msix_entries[0]);
-	flag |= IRQF_DISABLED;
 	for (i = 0; i < max_entry ; i++)
 		pm8001_ha->msix_entries[i].entry = i;
 	rc = pci_enable_msix(pm8001_ha->pdev, pm8001_ha->msix_entries,
@@ -567,7 +565,7 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha,
 	if (!rc) {
 		for (i = 0; i < number_of_intr; i++) {
 			if (request_irq(pm8001_ha->msix_entries[i].vector,
-				irq_handler, flag, DRV_NAME,
+				irq_handler, 0, DRV_NAME,
 				SHOST_TO_SAS_HA(pm8001_ha->shost))) {
 				for (j = 0; j < i; j++)
 					free_irq(
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 041eaaa..d9142a2 100644
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
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 90e104d..5c50f9c 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -874,7 +874,7 @@ static int port_detect \
 
    /* Board detected, allocate its IRQ */
    if (request_irq(irq, do_interrupt_handler,
-             IRQF_DISABLED | ((subversion == ESA) ? IRQF_SHARED : 0),
+             ((subversion == ESA) ? IRQF_SHARED : 0),
              driver_name, (void *) &sha[j])) {
       printk("%s: unable to allocate IRQ %u, detaching.\n", name, irq);
       goto freelock;
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 9ee0afe..8cab246 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1253,7 +1253,7 @@ static int wd7000_init(Adapter * host)
 		return 0;
 
 
-	if (request_irq(host->irq, wd7000_intr, IRQF_DISABLED, "wd7000", host)) {
+	if (request_irq(host->irq, wd7000_intr, 0, "wd7000", host)) {
 		printk("wd7000_init: can't get IRQ %d.\n", host->irq);
 		return (0);
 	}
-- 
1.7.1
