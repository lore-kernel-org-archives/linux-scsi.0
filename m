From: Dolev Raviv <draviv@codeaurora.org>
Subject: [RFC 01/10] scsi: ufs: Allow vendor specific initialization
Date: Mon, 11 Aug 2014 15:40:29 +0300
Message-ID: <1407760838-6406-2-git-send-email-draviv@codeaurora.org>
References: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Some vendor specific controller versions might need to configure
vendor specific - registers, clocks, voltage regulators etc. to
initialize the host controller UTP layer and Uni-Pro stack.
Provide some common initialization operations that can be used
to configure vendor specifics. The methods can be extended in
future, for example, for power mode transitions.

The operations are vendor/board specific and hence determined with
the help of compatible property in device tree.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index c007a7a..11a3237 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -164,7 +164,13 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mmio_base = pcim_iomap_table(pdev)[0];
 
-	err = ufshcd_init(&pdev->dev, &hba, mmio_base, pdev->irq);
+	err = ufshcd_alloc_host(&pdev->dev, &hba);
+	if (err) {
+		dev_err(&pdev->dev, "Allocation failed\n");
+		return err;
+	}
+
+	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
 		return err;
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 5e46232..d727b1a 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -35,9 +35,24 @@
 
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/of.h>
 
 #include "ufshcd.h"
 
+static const struct of_device_id ufs_of_match[];
+static struct ufs_hba_variant_ops *get_variant_ops(struct device *dev)
+{
+	if (dev->of_node) {
+		const struct of_device_id *match;
+
+		match = of_match_node(ufs_of_match, dev->of_node);
+		if (match)
+			return (struct ufs_hba_variant_ops *)match->data;
+	}
+
+	return NULL;
+}
+
 #ifdef CONFIG_PM
 /**
  * ufshcd_pltfrm_suspend - suspend power management function
@@ -138,8 +153,8 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	mmio_base = devm_ioremap_resource(dev, mem_res);
-	if (IS_ERR(mmio_base)) {
-		err = PTR_ERR(mmio_base);
+	if (IS_ERR(*(void **)&mmio_base)) {
+		err = PTR_ERR(*(void **)&mmio_base);
 		goto out;
 	}
 
@@ -150,10 +165,18 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 		goto out;
 	}
 
+	err = ufshcd_alloc_host(dev, &hba);
+	if (err) {
+		dev_err(&pdev->dev, "Allocation failed\n");
+		goto out;
+	}
+
+	hba->vops = get_variant_ops(&pdev->dev);
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	err = ufshcd_init(dev, &hba, mmio_base, irq);
+	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Intialization failed\n");
 		goto out_disable_rpm;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ba27215..d0565b0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3,6 +3,7 @@
  *
  * This code is based on drivers/scsi/ufs/ufshcd.c
  * Copyright (C) 2011-2013 Samsung India Software Operations
+ * Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
@@ -31,6 +32,9 @@
  * circumstances will the contributor of this Program be liable for
  * any damages of any kind arising from your use or distribution of
  * this program.
+ *
+ * The Linux Foundation chooses to take subject only to the GPLv2
+ * license terms, and distributes only under these terms.
  */
 
 #include <linux/async.h>
@@ -175,13 +179,14 @@ static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
 /**
  * ufshcd_is_device_present - Check if any device connected to
  *			      the host controller
- * @reg_hcs - host controller status register value
+ * @hba: pointer to adapter instance
  *
  * Returns 1 if device present, 0 if no device detected
  */
-static inline int ufshcd_is_device_present(u32 reg_hcs)
+static inline int ufshcd_is_device_present(struct ufs_hba *hba)
 {
-	return (DEVICE_PRESENT & reg_hcs) ? 1 : 0;
+	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
+						DEVICE_PRESENT) ? 1 : 0;
 }
 
 /**
@@ -1798,11 +1803,10 @@ out:
  * @hba: per adapter instance
  *
  * To bring UFS host controller to operational state,
- * 1. Check if device is present
- * 2. Enable required interrupts
- * 3. Configure interrupt aggregation
- * 4. Program UTRL and UTMRL base addres
- * 5. Configure run-stop-registers
+ * 1. Enable required interrupts
+ * 2. Configure interrupt aggregation
+ * 3. Program UTRL and UTMRL base addres
+ * 4. Configure run-stop-registers
  *
  * Returns 0 on success, non-zero value on failure
  */
@@ -1811,14 +1815,6 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	int err = 0;
 	u32 reg;
 
-	/* check if device present */
-	reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
-	if (!ufshcd_is_device_present(reg)) {
-		dev_err(hba->dev, "cc: Device not present\n");
-		err = -ENXIO;
-		goto out;
-	}
-
 	/* Enable required interrupts */
 	ufshcd_enable_intr(hba, UFSHCD_ENABLE_INTRS);
 
@@ -1839,6 +1835,7 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 	 * UCRDY, UTMRLDY and UTRLRDY bits must be 1
 	 * DEI, HEI bits must be 0
 	 */
+	reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
 	if (!(ufshcd_get_lists_status(reg))) {
 		ufshcd_enable_run_stop_reg(hba);
 	} else {
@@ -1885,6 +1882,9 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		msleep(5);
 	}
 
+	if (hba->vops && hba->vops->hce_enable_notify)
+		hba->vops->hce_enable_notify(hba, PRE_CHANGE);
+
 	/* start controller initialization sequence */
 	ufshcd_hba_start(hba);
 
@@ -1912,6 +1912,10 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 		}
 		msleep(5);
 	}
+
+	if (hba->vops && hba->vops->hce_enable_notify)
+		hba->vops->hce_enable_notify(hba, POST_CHANGE);
+
 	return 0;
 }
 
@@ -1928,12 +1932,28 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 	/* enable UIC related interrupts */
 	ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 
+	if (hba->vops && hba->vops->link_startup_notify)
+		hba->vops->link_startup_notify(hba, PRE_CHANGE);
+
 	ret = ufshcd_dme_link_startup(hba);
 	if (ret)
 		goto out;
 
-	ret = ufshcd_make_hba_operational(hba);
+	/* check if device is detected by inter-connect layer */
+	if (!ufshcd_is_device_present(hba)) {
+		dev_err(hba->dev, "%s: Device not present\n", __func__);
+		ret = -ENXIO;
+		goto out;
+	}
+
+	/* Include any host controller configuration via UIC commands */
+	if (hba->vops && hba->vops->link_startup_notify) {
+		ret = hba->vops->link_startup_notify(hba, POST_CHANGE);
+		if (ret)
+			goto out;
+	}
 
+	ret = ufshcd_make_hba_operational(hba);
 out:
 	if (ret)
 		dev_err(hba->dev, "link startup failed %d\n", ret);
@@ -3173,6 +3193,61 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.can_queue		= UFSHCD_CAN_QUEUE,
 };
 
+static int ufshcd_variant_hba_init(struct ufs_hba *hba)
+{
+	int err = 0;
+
+	if (!hba->vops)
+		goto out;
+
+	if (hba->vops->init) {
+		err = hba->vops->init(hba);
+		if (err)
+			goto out;
+	}
+
+	if (hba->vops->setup_clocks) {
+		err = hba->vops->setup_clocks(hba, true);
+		if (err)
+			goto out_exit;
+	}
+
+	if (hba->vops->setup_regulators) {
+		err = hba->vops->setup_regulators(hba, true);
+		if (err)
+			goto out_clks;
+	}
+
+	goto out;
+
+out_clks:
+	if (hba->vops->setup_clocks)
+		hba->vops->setup_clocks(hba, false);
+out_exit:
+	if (hba->vops->exit)
+		hba->vops->exit(hba);
+out:
+	if (err)
+		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
+			__func__, hba->vops ? hba->vops->name : "", err);
+	return err;
+}
+
+static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
+{
+	if (!hba->vops)
+		return;
+
+	if (hba->vops->setup_clocks)
+		hba->vops->setup_clocks(hba, false);
+
+	if (hba->vops->setup_regulators)
+		hba->vops->setup_regulators(hba, false);
+
+	if (hba->vops->exit)
+		hba->vops->exit(hba);
+}
+
 /**
  * ufshcd_suspend - suspend power management function
  * @hba: per adapter instance
@@ -3257,6 +3332,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_hba_stop(hba);
 
 	scsi_host_put(hba->host);
+
+	ufshcd_variant_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
@@ -3277,19 +3354,16 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 }
 
 /**
- * ufshcd_init - Driver initialization routine
+ * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
  * @hba_handle: driver private handle
- * @mmio_base: base register address
- * @irq: Interrupt line of device
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
-		 void __iomem *mmio_base, unsigned int irq)
+int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
-	int err;
+	int err = 0;
 
 	if (!dev) {
 		dev_err(dev,
@@ -3298,13 +3372,6 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 		goto out_error;
 	}
 
-	if (!mmio_base) {
-		dev_err(dev,
-		"Invalid memory reference for mmio_base is NULL\n");
-		err = -ENODEV;
-		goto out_error;
-	}
-
 	host = scsi_host_alloc(&ufshcd_driver_template,
 				sizeof(struct ufs_hba));
 	if (!host) {
@@ -3315,9 +3382,40 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
+	*hba_handle = hba;
+
+out_error:
+	return err;
+}
+EXPORT_SYMBOL(ufshcd_alloc_host);
+
+/**
+ * ufshcd_init - Driver initialization routine
+ * @hba: per-adapter instance
+ * @mmio_base: base register address
+ * @irq: Interrupt line of device
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
+{
+	int err;
+	struct Scsi_Host *host = hba->host;
+	struct device *dev = hba->dev;
+
+	if (!mmio_base) {
+		dev_err(hba->dev,
+		"Invalid memory reference for mmio_base is NULL\n");
+		err = -ENODEV;
+		goto out_error;
+	}
+
 	hba->mmio_base = mmio_base;
 	hba->irq = irq;
 
+	err = ufshcd_variant_hba_init(hba);
+	if (err)
+		goto out_error;
+
 	/* Read capabilities registers */
 	ufshcd_hba_capabilities(hba);
 
@@ -3395,8 +3493,6 @@ int ufshcd_init(struct device *dev, struct ufs_hba **hba_handle,
 		goto out_remove_scsi_host;
 	}
 
-	*hba_handle = hba;
-
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
 
@@ -3408,6 +3504,7 @@ out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 out_disable:
 	scsi_host_put(host);
+	ufshcd_variant_hba_exit(hba);
 out_error:
 	return err;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index acf318e..8c6bec0 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -68,6 +68,8 @@
 #define UFSHCD "ufshcd"
 #define UFSHCD_DRIVER_VERSION "0.2"
 
+struct ufs_hba;
+
 enum dev_cmd_type {
 	DEV_CMD_TYPE_NOP		= 0x0,
 	DEV_CMD_TYPE_QUERY		= 0x1,
@@ -152,6 +154,30 @@ struct ufs_dev_cmd {
 	struct ufs_query query;
 };
 
+#define PRE_CHANGE      0
+#define POST_CHANGE     1
+/**
+ * struct ufs_hba_variant_ops - variant specific callbacks
+ * @name: variant name
+ * @init: called when the driver is initialized
+ * @exit: called to cleanup everything done in init
+ * @setup_clocks: called before touching any of the controller registers
+ * @setup_regulators: called before accessing the host controller
+ * @hce_enable_notify: called before and after HCE enable bit is set to allow
+ *                     variant specific Uni-Pro initialization.
+ * @link_startup_notify: called before and after Link startup is carried out
+ *                       to allow variant specific Uni-Pro initialization.
+ */
+struct ufs_hba_variant_ops {
+	const char *name;
+	int	(*init)(struct ufs_hba *);
+	void    (*exit)(struct ufs_hba *);
+	int     (*setup_clocks)(struct ufs_hba *, bool);
+	int     (*setup_regulators)(struct ufs_hba *, bool);
+	int     (*hce_enable_notify)(struct ufs_hba *, bool);
+	int     (*link_startup_notify)(struct ufs_hba *, bool);
+};
+
 /**
  * struct ufs_hba - per adapter private structure
  * @mmio_base: UFSHCI base register address
@@ -171,6 +197,8 @@ struct ufs_dev_cmd {
  * @nutrs: Transfer Request Queue depth supported by controller
  * @nutmrs: Task Management Queue depth supported by controller
  * @ufs_version: UFS Version to which controller complies
+ * @vops: pointer to variant specific operations
+ * @priv: pointer to variant specific private data
  * @irq: Irq number of the controller
  * @active_uic_cmd: handle of active UIC command
  * @uic_cmd_mutex: mutex for uic command
@@ -218,6 +246,8 @@ struct ufs_hba {
 	int nutrs;
 	int nutmrs;
 	u32 ufs_version;
+	struct ufs_hba_variant_ops *vops;
+	void *priv;
 	unsigned int irq;
 
 	struct uic_command *active_uic_cmd;
@@ -256,8 +286,8 @@ struct ufs_hba {
 #define ufshcd_readl(hba, reg)	\
 	readl((hba)->mmio_base + (reg))
 
-int ufshcd_init(struct device *, struct ufs_hba ** , void __iomem * ,
-			unsigned int);
+int ufshcd_alloc_host(struct device *, struct ufs_hba **);
+int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
 void ufshcd_remove(struct ufs_hba *);
 
 /**
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
