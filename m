From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 01/11] ata: prepare to move module reference from scsi_host_template to Scsi_Host
Date: Mon, 19 Jan 2015 00:05:59 +0900
Message-ID: <1421593569-5089-2-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for moving owner module reference field from struct
scsi_host_template to struct Scsi_Host, this converts the following
functions into macros so that LLDDs can pass THIS_MODULE to
scsi_host_alloc() through them instead of scsi_host_template->module.

ata_host_alloc()
ata_host_alloc_pinfo()
ata_pci_sff_prepare_host()
ata_pci_sff_init_one()
ata_pci_bmdma_prepare_host()
ata_pci_bmdma_init_one()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
 drivers/ata/libata-core.c | 22 ++++++++++-------
 drivers/ata/libata-sff.c  | 61 +++++++++++++++++++++++++----------------------
 include/linux/libata.h    | 52 ++++++++++++++++++++++++++++------------
 3 files changed, 83 insertions(+), 52 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5c84fb5..a3cc0e3 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5700,9 +5700,10 @@ static void ata_host_release(struct device *gendev, void *res)
 }
 
 /**
- *	ata_host_alloc - allocate and init basic ATA host resources
+ *	__ata_host_alloc - allocate and init basic ATA host resources
  *	@dev: generic device this host is associated with
  *	@max_ports: maximum number of ATA ports associated with this host
+ *	@owner: module which will be the owner of the ATA host
  *
  *	Allocate and initialize basic ATA host resources.  LLD calls
  *	this function to allocate a host, initializes it fully and
@@ -5719,7 +5720,8 @@ static void ata_host_release(struct device *gendev, void *res)
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  */
-struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
+struct ata_host *__ata_host_alloc(struct device *dev, int max_ports,
+				  struct module *owner)
 {
 	struct ata_host *host;
 	size_t sz;
@@ -5744,6 +5746,7 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 	mutex_init(&host->eh_mutex);
 	host->dev = dev;
 	host->n_ports = max_ports;
+	host->module = owner;
 
 	/* allocate ports bound to this host */
 	for (i = 0; i < max_ports; i++) {
@@ -5766,10 +5769,11 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
 }
 
 /**
- *	ata_host_alloc_pinfo - alloc host and init with port_info array
+ *	__ata_host_alloc_pinfo - alloc host and init with port_info array
  *	@dev: generic device this host is associated with
  *	@ppi: array of ATA port_info to initialize host with
  *	@n_ports: number of ATA ports attached to this host
+ *	@owner: module which will be the owner of the ATA host
  *
  *	Allocate ATA host and initialize with info from @ppi.  If NULL
  *	terminated, @ppi may contain fewer entries than @n_ports.  The
@@ -5781,15 +5785,15 @@ struct ata_host *ata_host_alloc(struct device *dev, int max_ports)
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  */
-struct ata_host *ata_host_alloc_pinfo(struct device *dev,
-				      const struct ata_port_info * const * ppi,
-				      int n_ports)
+struct ata_host *__ata_host_alloc_pinfo(struct device *dev,
+					const struct ata_port_info * const *ppi,
+					int n_ports, struct module *owner)
 {
 	const struct ata_port_info *pi;
 	struct ata_host *host;
 	int i, j;
 
-	host = ata_host_alloc(dev, n_ports);
+	host = __ata_host_alloc(dev, n_ports, owner);
 	if (!host)
 		return NULL;
 
@@ -6862,8 +6866,8 @@ EXPORT_SYMBOL_GPL(ata_dev_next);
 EXPORT_SYMBOL_GPL(ata_std_bios_param);
 EXPORT_SYMBOL_GPL(ata_scsi_unlock_native_capacity);
 EXPORT_SYMBOL_GPL(ata_host_init);
-EXPORT_SYMBOL_GPL(ata_host_alloc);
-EXPORT_SYMBOL_GPL(ata_host_alloc_pinfo);
+EXPORT_SYMBOL_GPL(__ata_host_alloc);
+EXPORT_SYMBOL_GPL(__ata_host_alloc_pinfo);
 EXPORT_SYMBOL_GPL(ata_slave_link_init);
 EXPORT_SYMBOL_GPL(ata_host_start);
 EXPORT_SYMBOL_GPL(ata_host_register);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index db90aa3..323c9d8 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2349,10 +2349,11 @@ int ata_pci_sff_init_host(struct ata_host *host)
 EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
 
 /**
- *	ata_pci_sff_prepare_host - helper to prepare PCI PIO-only SFF ATA host
+ *	__ata_pci_sff_prepare_host - helper to prepare PCI PIO-only SFF ATA host
  *	@pdev: target PCI device
  *	@ppi: array of port_info, must be enough for two ports
  *	@r_host: out argument for the initialized ATA host
+ *	@owner: module which will be the owner of the ATA host
  *
  *	Helper to allocate PIO-only SFF ATA host for @pdev, acquire
  *	all PCI resources and initialize it accordingly in one go.
@@ -2363,9 +2364,9 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_init_host);
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ata_pci_sff_prepare_host(struct pci_dev *pdev,
-			     const struct ata_port_info * const *ppi,
-			     struct ata_host **r_host)
+int __ata_pci_sff_prepare_host(struct pci_dev *pdev,
+			       const struct ata_port_info * const *ppi,
+			       struct ata_host **r_host, struct module *owner)
 {
 	struct ata_host *host;
 	int rc;
@@ -2373,7 +2374,7 @@ int ata_pci_sff_prepare_host(struct pci_dev *pdev,
 	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
 		return -ENOMEM;
 
-	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 2);
+	host = __ata_host_alloc_pinfo(&pdev->dev, ppi, 2, owner);
 	if (!host) {
 		dev_err(&pdev->dev, "failed to allocate ATA host\n");
 		rc = -ENOMEM;
@@ -2392,7 +2393,7 @@ err_out:
 	devres_release_group(&pdev->dev, NULL);
 	return rc;
 }
-EXPORT_SYMBOL_GPL(ata_pci_sff_prepare_host);
+EXPORT_SYMBOL_GPL(__ata_pci_sff_prepare_host);
 
 /**
  *	ata_pci_sff_activate_host - start SFF host, request IRQ and register it
@@ -2500,7 +2501,7 @@ static const struct ata_port_info *ata_sff_find_valid_pi(
 static int ata_pci_init_one(struct pci_dev *pdev,
 		const struct ata_port_info * const *ppi,
 		struct scsi_host_template *sht, void *host_priv,
-		int hflags, bool bmdma)
+		int hflags, bool bmdma, struct module *owner)
 {
 	struct device *dev = &pdev->dev;
 	const struct ata_port_info *pi;
@@ -2525,11 +2526,11 @@ static int ata_pci_init_one(struct pci_dev *pdev,
 #ifdef CONFIG_ATA_BMDMA
 	if (bmdma)
 		/* prepare and activate BMDMA host */
-		rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
+		rc = __ata_pci_bmdma_prepare_host(pdev, ppi, &host, owner);
 	else
 #endif
 		/* prepare and activate SFF host */
-		rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
+		rc = __ata_pci_sff_prepare_host(pdev, ppi, &host, owner);
 	if (rc)
 		goto out;
 	host->private_data = host_priv;
@@ -2552,12 +2553,13 @@ out:
 }
 
 /**
- *	ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
+ *	__ata_pci_sff_init_one - Initialize/register PIO-only PCI IDE controller
  *	@pdev: Controller to be initialized
  *	@ppi: array of port_info, must be enough for two ports
  *	@sht: scsi_host_template to use when registering the host
  *	@host_priv: host private_data
  *	@hflag: host flags
+ *	@owner: module which will be the owner of the ATA host
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
@@ -2573,13 +2575,14 @@ out:
  *	RETURNS:
  *	Zero on success, negative on errno-based value on error.
  */
-int ata_pci_sff_init_one(struct pci_dev *pdev,
-		 const struct ata_port_info * const *ppi,
-		 struct scsi_host_template *sht, void *host_priv, int hflag)
+int __ata_pci_sff_init_one(struct pci_dev *pdev,
+			   const struct ata_port_info * const *ppi,
+			   struct scsi_host_template *sht, void *host_priv,
+			   int hflag, struct module *owner)
 {
-	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflag, 0);
+	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflag, 0, owner);
 }
-EXPORT_SYMBOL_GPL(ata_pci_sff_init_one);
+EXPORT_SYMBOL_GPL(__ata_pci_sff_init_one);
 
 #endif /* CONFIG_PCI */
 
@@ -3245,10 +3248,11 @@ void ata_pci_bmdma_init(struct ata_host *host)
 EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
 
 /**
- *	ata_pci_bmdma_prepare_host - helper to prepare PCI BMDMA ATA host
+ *	__ata_pci_bmdma_prepare_host - helper to prepare PCI BMDMA ATA host
  *	@pdev: target PCI device
  *	@ppi: array of port_info, must be enough for two ports
  *	@r_host: out argument for the initialized ATA host
+ *	@owner: module which will be the owner of the ATA host
  *
  *	Helper to allocate BMDMA ATA host for @pdev, acquire all PCI
  *	resources and initialize it accordingly in one go.
@@ -3259,28 +3263,29 @@ EXPORT_SYMBOL_GPL(ata_pci_bmdma_init);
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-int ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
-			       const struct ata_port_info * const * ppi,
-			       struct ata_host **r_host)
+int __ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
+				 const struct ata_port_info * const *ppi,
+				 struct ata_host **r_host, struct module *owner)
 {
 	int rc;
 
-	rc = ata_pci_sff_prepare_host(pdev, ppi, r_host);
+	rc = __ata_pci_sff_prepare_host(pdev, ppi, r_host, owner);
 	if (rc)
 		return rc;
 
 	ata_pci_bmdma_init(*r_host);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(ata_pci_bmdma_prepare_host);
+EXPORT_SYMBOL_GPL(__ata_pci_bmdma_prepare_host);
 
 /**
- *	ata_pci_bmdma_init_one - Initialize/register BMDMA PCI IDE controller
+ *	__ata_pci_bmdma_init_one - Initialize/register BMDMA PCI IDE controller
  *	@pdev: Controller to be initialized
  *	@ppi: array of port_info, must be enough for two ports
  *	@sht: scsi_host_template to use when registering the host
  *	@host_priv: host private_data
  *	@hflags: host flags
+ *	@owner: module which will be the owner of the ATA host
  *
  *	This function is similar to ata_pci_sff_init_one() but also
  *	takes care of BMDMA initialization.
@@ -3291,14 +3296,14 @@ EXPORT_SYMBOL_GPL(ata_pci_bmdma_prepare_host);
  *	RETURNS:
  *	Zero on success, negative on errno-based value on error.
  */
-int ata_pci_bmdma_init_one(struct pci_dev *pdev,
-			   const struct ata_port_info * const * ppi,
-			   struct scsi_host_template *sht, void *host_priv,
-			   int hflags)
+int __ata_pci_bmdma_init_one(struct pci_dev *pdev,
+			     const struct ata_port_info * const *ppi,
+			     struct scsi_host_template *sht, void *host_priv,
+			     int hflags, struct module *owner)
 {
-	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflags, 1);
+	return ata_pci_init_one(pdev, ppi, sht, host_priv, hflags, 1, owner);
 }
-EXPORT_SYMBOL_GPL(ata_pci_bmdma_init_one);
+EXPORT_SYMBOL_GPL(__ata_pci_bmdma_init_one);
 
 #endif /* CONFIG_PCI */
 #endif /* CONFIG_ATA_BMDMA */
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 2d18241..541ceb1 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -598,6 +598,7 @@ struct ata_host {
 	void			*private_data;
 	struct ata_port_operations *ops;
 	unsigned long		flags;
+	struct module		*module;
 
 	struct mutex		eh_mutex;
 	struct task_struct	*eh_owner;
@@ -1106,9 +1107,15 @@ extern int sata_std_hardreset(struct ata_link *link, unsigned int *class,
 			      unsigned long deadline);
 extern void ata_std_postreset(struct ata_link *link, unsigned int *classes);
 
-extern struct ata_host *ata_host_alloc(struct device *dev, int max_ports);
-extern struct ata_host *ata_host_alloc_pinfo(struct device *dev,
-			const struct ata_port_info * const * ppi, int n_ports);
+extern struct ata_host *__ata_host_alloc(struct device *dev, int max_ports,
+					struct module *owner);
+#define ata_host_alloc(dev, max_ports) \
+	__ata_host_alloc(dev, max_ports, THIS_MODULE)
+extern struct ata_host *__ata_host_alloc_pinfo(struct device *dev,
+			const struct ata_port_info * const *ppi, int n_ports,
+			struct module *owner);
+#define ata_host_alloc_pinfo(dev, ppi, n_ports) \
+	__ata_host_alloc_pinfo(dev, ppi, n_ports, THIS_MODULE)
 extern int ata_slave_link_init(struct ata_port *ap);
 extern int ata_host_start(struct ata_host *host);
 extern int ata_host_register(struct ata_host *host,
@@ -1835,15 +1842,22 @@ extern void ata_sff_error_handler(struct ata_port *ap);
 extern void ata_sff_std_ports(struct ata_ioports *ioaddr);
 #ifdef CONFIG_PCI
 extern int ata_pci_sff_init_host(struct ata_host *host);
-extern int ata_pci_sff_prepare_host(struct pci_dev *pdev,
-				    const struct ata_port_info * const * ppi,
-				    struct ata_host **r_host);
+extern int __ata_pci_sff_prepare_host(struct pci_dev *pdev,
+				      const struct ata_port_info * const *ppi,
+				      struct ata_host **r_host,
+				      struct module *owner);
+#define ata_pci_sff_prepare_host(pdev, ppi, r_host) \
+	__ata_pci_sff_prepare_host(pdev, ppi, r_host, THIS_MODULE)
 extern int ata_pci_sff_activate_host(struct ata_host *host,
 				     irq_handler_t irq_handler,
 				     struct scsi_host_template *sht);
-extern int ata_pci_sff_init_one(struct pci_dev *pdev,
+extern int __ata_pci_sff_init_one(struct pci_dev *pdev,
 		const struct ata_port_info * const * ppi,
-		struct scsi_host_template *sht, void *host_priv, int hflags);
+		struct scsi_host_template *sht, void *host_priv, int hflags,
+		struct module *owner);
+#define ata_pci_sff_init_one(pdev, ppi, sht, host_priv, hflag)	\
+	__ata_pci_sff_init_one(pdev, ppi, sht, host_priv, hflag, THIS_MODULE)
+
 #endif /* CONFIG_PCI */
 
 #ifdef CONFIG_ATA_BMDMA
@@ -1874,13 +1888,21 @@ extern int ata_bmdma_port_start32(struct ata_port *ap);
 #ifdef CONFIG_PCI
 extern int ata_pci_bmdma_clear_simplex(struct pci_dev *pdev);
 extern void ata_pci_bmdma_init(struct ata_host *host);
-extern int ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
-				      const struct ata_port_info * const * ppi,
-				      struct ata_host **r_host);
-extern int ata_pci_bmdma_init_one(struct pci_dev *pdev,
-				  const struct ata_port_info * const * ppi,
-				  struct scsi_host_template *sht,
-				  void *host_priv, int hflags);
+extern int __ata_pci_bmdma_prepare_host(struct pci_dev *pdev,
+					const struct ata_port_info * const *ppi,
+					struct ata_host **r_host,
+					struct module *owner);
+#define ata_pci_bmdma_prepare_host(pdev, ppi, r_host) \
+	__ata_pci_bmdma_prepare_host(pdev, ppi, r_host, THIS_MODULE)
+
+extern int __ata_pci_bmdma_init_one(struct pci_dev *pdev,
+				    const struct ata_port_info * const *ppi,
+				    struct scsi_host_template *sht,
+				    void *host_priv, int hflags,
+				    struct module *owner);
+#define ata_pci_bmdma_init_one(pdev, ppi, sht, host_priv, hflags) \
+	__ata_pci_bmdma_init_one(pdev, ppi, sht, host_priv, hflags, THIS_MODULE)
+
 #endif /* CONFIG_PCI */
 #endif /* CONFIG_ATA_BMDMA */
 
-- 
1.9.1

