From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/22] libata-sff: introduce ata_sff_init/exit() and ata_sff_port_init()
Date: Tue, 21 Oct 2008 18:17:49 +0900
Message-ID: <1224580680-13698-12-git-send-email-tj@kernel.org>
References: <1224580680-13698-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:46029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbYJUJUb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Oct 2008 05:20:31 -0400
In-Reply-To: <1224580680-13698-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>

In preparation of proper SFF/BMDMA separation, introduce
ata_sff_init/exit() and ata_sff_port_init().  These functions
currently don't do anything.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/libata-core.c |   23 +++++++++++++++++------
 drivers/ata/libata-sff.c  |   23 +++++++++++++++++++++++
 drivers/ata/libata.h      |   10 ++++++++++
 3 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 05e31c2..582aeb6 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5309,6 +5309,8 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->stats.unhandled_irq = 1;
 	ap->stats.idle_irq = 1;
 #endif
+	ata_sff_port_init(ap);
+
 	return ap;
 }
 
@@ -6224,28 +6226,37 @@ static void __init ata_parse_force_param(void)
 
 static int __init ata_init(void)
 {
+	int rc = -ENOMEM;
+
 	ata_parse_force_param();
 
 	ata_wq = create_workqueue("ata");
 	if (!ata_wq)
-		goto free_force_tbl;
+		goto fail;
 
 	ata_aux_wq = create_singlethread_workqueue("ata_aux");
 	if (!ata_aux_wq)
-		goto free_wq;
+		goto fail;
+
+	rc = ata_sff_init();
+	if (rc)
+		goto fail;
 
 	printk(KERN_DEBUG "libata version " DRV_VERSION " loaded.\n");
 	return 0;
 
-free_wq:
-	destroy_workqueue(ata_wq);
-free_force_tbl:
+ fail:
 	kfree(ata_force_tbl);
-	return -ENOMEM;
+	if (ata_wq)
+		destroy_workqueue(ata_wq);
+	if (ata_aux_wq)
+		destroy_workqueue(ata_aux_wq);
+	return rc;
 }
 
 static void __exit ata_exit(void)
 {
+	ata_sff_exit();
 	kfree(ata_force_tbl);
 	destroy_workqueue(ata_wq);
 	destroy_workqueue(ata_aux_wq);
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 0e4814b..41affa4 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2814,6 +2814,29 @@ void ata_pci_bmdma_init(struct ata_host *host)
 
 #endif /* CONFIG_PCI */
 
+/**
+ *	ata_sff_port_init - Initialize SFF/BMDMA ATA port
+ *	@ap: Port to initialize
+ *
+ *	Called on port allocation to initialize SFF/BMDMA specific
+ *	fields.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void ata_sff_port_init(struct ata_port *ap)
+{
+}
+
+int __init ata_sff_init(void)
+{
+	return 0;
+}
+
+void __exit ata_sff_exit(void)
+{
+}
+
 EXPORT_SYMBOL_GPL(ata_sff_port_ops);
 EXPORT_SYMBOL_GPL(ata_sff_qc_prep);
 EXPORT_SYMBOL_GPL(ata_sff_dumb_qc_prep);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 1f626b5..31d89d9 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -202,6 +202,16 @@ static inline int sata_pmp_attach(struct ata_device *dev)
 /* libata-sff.c */
 #ifdef CONFIG_ATA_SFF
 extern void ata_pio_task(struct work_struct *work);
+extern void ata_sff_port_init(struct ata_port *ap);
+extern int ata_sff_init(void);
+extern void ata_sff_exit(void);
+#else /* CONFIG_ATA_SFF */
+static inline void ata_sff_port_init(struct ata_port *ap)
+{ }
+static inline int ata_sff_init(void)
+{ return 0; }
+static inline void ata_sff_exit(void)
+{ }
 #endif /* CONFIG_ATA_SFF */
 
 #endif /* __LIBATA_H__ */
-- 
1.5.4.5

