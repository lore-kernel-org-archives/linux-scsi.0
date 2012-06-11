From: Ben Collins <bcollins@ubuntu.com>
Subject: [PATCH 1/4] SCSI: AACRAID: Use resource_size_t for IO mem pointers
 and offsets
Date: Mon, 11 Jun 2012 14:05:02 -0400
Message-ID: <f32df72cbb2adbc5d87f2f4a7f4d607fe8af7fd7.1339453250.git.bcollins@ubuntu.com>
References: <cover.1339453250.git.bcollins@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2FKWkf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2012 18:40:35 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6004726dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jun 2012 15:40:34 -0700 (PDT)
In-Reply-To: <cover.1339453250.git.bcollins@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>

This also stops using the "legacy crap" in Scsi_Host (shost->base is an
unsigned long).

This affected 32-bit systems that have 64-bit resource sizes, causing the
IO address to be truncated.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/aacraid.h |    5 +++--
 drivers/scsi/aacraid/linit.c   |    2 +-
 drivers/scsi/aacraid/nark.c    |    4 ++--
 drivers/scsi/aacraid/rkt.c     |    2 +-
 drivers/scsi/aacraid/rx.c      |    4 ++--
 drivers/scsi/aacraid/sa.c      |    4 ++--
 drivers/scsi/aacraid/src.c     |    7 +++----
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3fcf627..6ab32db 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1052,10 +1052,11 @@ struct aac_dev
 	struct adapter_ops	a_ops;
 	unsigned long		fsrev;		/* Main driver's revision number */
 
-	unsigned long		dbg_base;	/* address of UART
+	resource_size_t		base_start;	/* main IO base */
+	resource_size_t		dbg_base;	/* address of UART
 						 * debug buffer */
 
-	unsigned		base_size, dbg_size;	/* Size of
+	resource_size_t		base_size, dbg_size;	/* Size of
 							 *  mapped in region */
 
 	struct aac_init		*init;		/* Holds initialization info to communicate with adapter */
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0d279c44..fdfc4be 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1145,11 +1145,11 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
 		goto out_disable_pdev;
 
 	shost->irq = pdev->irq;
-	shost->base = pci_resource_start(pdev, 0);
 	shost->unique_id = unique_id;
 	shost->max_cmd_len = 16;
 
 	aac = (struct aac_dev *)shost->hostdata;
+	aac->base_start = pci_resource_start(pdev, 0);
 	aac->scsi_host_ptr = shost;
 	aac->pdev = pdev;
 	aac->name = aac_driver_template.name;
diff --git a/drivers/scsi/aacraid/nark.c b/drivers/scsi/aacraid/nark.c
index f397d21..6c53b1d 100644
--- a/drivers/scsi/aacraid/nark.c
+++ b/drivers/scsi/aacraid/nark.c
@@ -49,14 +49,14 @@ static int aac_nark_ioremap(struct aac_dev * dev, u32 size)
 		dev->base = NULL;
 		return 0;
 	}
-	dev->scsi_host_ptr->base = pci_resource_start(dev->pdev, 2);
+	dev->base_start = pci_resource_start(dev->pdev, 2);
 	dev->regs.rx = ioremap((u64)pci_resource_start(dev->pdev, 0) |
 	  ((u64)pci_resource_start(dev->pdev, 1) << 32),
 	  sizeof(struct rx_registers) - sizeof(struct rx_inbound));
 	dev->base = NULL;
 	if (dev->regs.rx == NULL)
 		return -1;
-	dev->base = ioremap(dev->scsi_host_ptr->base, size);
+	dev->base = ioremap(dev->base_start, size);
 	if (dev->base == NULL) {
 		iounmap(dev->regs.rx);
 		dev->regs.rx = NULL;
diff --git a/drivers/scsi/aacraid/rkt.c b/drivers/scsi/aacraid/rkt.c
index be44de9..7d8013f 100644
--- a/drivers/scsi/aacraid/rkt.c
+++ b/drivers/scsi/aacraid/rkt.c
@@ -79,7 +79,7 @@ static int aac_rkt_ioremap(struct aac_dev * dev, u32 size)
 		iounmap(dev->regs.rkt);
 		return 0;
 	}
-	dev->base = dev->regs.rkt = ioremap(dev->scsi_host_ptr->base, size);
+	dev->base = dev->regs.rkt = ioremap(dev->base_start, size);
 	if (dev->base == NULL)
 		return -1;
 	dev->IndexRegs = &dev->regs.rkt->IndexRegs;
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index b029c7c..dada38a 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -471,7 +471,7 @@ static int aac_rx_ioremap(struct aac_dev * dev, u32 size)
 		iounmap(dev->regs.rx);
 		return 0;
 	}
-	dev->base = dev->regs.rx = ioremap(dev->scsi_host_ptr->base, size);
+	dev->base = dev->regs.rx = ioremap(dev->base_start, size);
 	if (dev->base == NULL)
 		return -1;
 	dev->IndexRegs = &dev->regs.rx->IndexRegs;
@@ -653,7 +653,7 @@ int _aac_rx_init(struct aac_dev *dev)
 			name, instance);
 		goto error_iounmap;
 	}
-	dev->dbg_base = dev->scsi_host_ptr->base;
+	dev->dbg_base = dev->base_start;
 	dev->dbg_base_mapped = dev->base;
 	dev->dbg_size = dev->base_size;
 
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index beb5336..2244f31 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -305,7 +305,7 @@ static int aac_sa_ioremap(struct aac_dev * dev, u32 size)
 		iounmap(dev->regs.sa);
 		return 0;
 	}
-	dev->base = dev->regs.sa = ioremap(dev->scsi_host_ptr->base, size);
+	dev->base = dev->regs.sa = ioremap(dev->base_start, size);
 	return (dev->base == NULL) ? -1 : 0;
 }
 
@@ -393,7 +393,7 @@ int aac_sa_init(struct aac_dev *dev)
 			name, instance);
 		goto error_iounmap;
 	}
-	dev->dbg_base = dev->scsi_host_ptr->base;
+	dev->dbg_base = dev->base_start;
 	dev->dbg_base_mapped = dev->base;
 	dev->dbg_size = dev->base_size;
 
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 7628206..27a3e77 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -435,8 +435,7 @@ static int aac_src_ioremap(struct aac_dev *dev, u32 size)
 	dev->base = NULL;
 	if (dev->regs.src.bar1 == NULL)
 		return -1;
-	dev->base = dev->regs.src.bar0 = ioremap(dev->scsi_host_ptr->base,
-				size);
+	dev->base = dev->regs.src.bar0 = ioremap(dev->base_start, size);
 	if (dev->base == NULL) {
 		iounmap(dev->regs.src.bar1);
 		dev->regs.src.bar1 = NULL;
@@ -459,7 +458,7 @@ static int aac_srcv_ioremap(struct aac_dev *dev, u32 size)
 		dev->base = dev->regs.src.bar0 = NULL;
 		return 0;
 	}
-	dev->base = dev->regs.src.bar0 = ioremap(dev->scsi_host_ptr->base, size);
+	dev->base = dev->regs.src.bar0 = ioremap(dev->base_start, size);
 	if (dev->base == NULL)
 		return -1;
 	dev->IndexRegs = &((struct src_registers __iomem *)
@@ -764,7 +763,7 @@ int aac_srcv_init(struct aac_dev *dev)
 			name, instance);
 		goto error_iounmap;
 	}
-	dev->dbg_base = dev->scsi_host_ptr->base;
+	dev->dbg_base = dev->base_start;
 	dev->dbg_base_mapped = dev->base;
 	dev->dbg_size = dev->base_size;
 
-- 
1.7.9.5

