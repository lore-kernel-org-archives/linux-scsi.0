From: akpm@osdl.org
Subject: [patch 39/45] SCSI/qla2xxx: handle sysfs errors
Date: Fri, 20 Oct 2006 14:48:35 -0700
Message-ID: <200610202148.k9KLmZ3x004192@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:14727 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992865AbWJTVtV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:49:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, jeff@garzik.org, romieu@fr.zoreil.com

From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/qla2xxx/qla_attr.c |   50 ++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 --
 drivers/scsi/qla2xxx/qla_os.c   |    7 +++-
 3 files changed, 47 insertions(+), 14 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_attr.c~scsi-qla2xxx-handle-sysfs-errors drivers/scsi/qla2xxx/qla_attr.c
--- a/drivers/scsi/qla2xxx/qla_attr.c~scsi-qla2xxx-handle-sysfs-errors
+++ a/drivers/scsi/qla2xxx/qla_attr.c
@@ -379,22 +379,52 @@ static struct bin_attribute sysfs_sfp_at
 	.read = qla2x00_sysfs_read_sfp,
 };
 
-void
+int
 qla2x00_alloc_sysfs_attr(scsi_qla_host_t *ha)
 {
 	struct Scsi_Host *host = ha->host;
+	int rc;
 
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_fw_dump_attr);
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_nvram_attr);
-	sysfs_create_bin_file(&host->shost_gendev.kobj, &sysfs_optrom_attr);
-	sysfs_create_bin_file(&host->shost_gendev.kobj,
-	    &sysfs_optrom_ctl_attr);
+	rc = sysfs_create_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_fw_dump_attr);
+	if (rc) goto err;
+	rc = sysfs_create_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_nvram_attr);
+	if (rc) goto err_fwd;
+	rc = sysfs_create_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_optrom_attr);
+	if (rc) goto err_nvr;
+	rc = sysfs_create_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_optrom_ctl_attr);
+	if (rc) goto err_optrom;
 	if (IS_QLA24XX(ha) || IS_QLA54XX(ha)) {
-		sysfs_create_bin_file(&host->shost_gendev.kobj,
-		    &sysfs_vpd_attr);
-		sysfs_create_bin_file(&host->shost_gendev.kobj,
-		    &sysfs_sfp_attr);
+		rc = sysfs_create_bin_file(&host->shost_gendev.kobj,
+					   &sysfs_vpd_attr);
+		if (rc) goto err_opt_ctl;
+		rc = sysfs_create_bin_file(&host->shost_gendev.kobj,
+					   &sysfs_sfp_attr);
+		if (rc) goto err_vpd;
 	}
+
+	return 0;
+
+err_vpd:
+	sysfs_remove_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_vpd_attr);
+err_opt_ctl:
+	sysfs_remove_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_optrom_ctl_attr);
+err_optrom:
+	sysfs_remove_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_optrom_attr);
+err_nvr:
+	sysfs_remove_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_nvram_attr);
+err_fwd:
+	sysfs_remove_bin_file(&host->shost_gendev.kobj,
+				   &sysfs_fw_dump_attr);
+err:
+	return rc;
 }
 
 void
diff -puN drivers/scsi/qla2xxx/qla_gbl.h~scsi-qla2xxx-handle-sysfs-errors drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h~scsi-qla2xxx-handle-sysfs-errors
+++ a/drivers/scsi/qla2xxx/qla_gbl.h
@@ -296,9 +296,7 @@ struct class_device_attribute;
 extern struct class_device_attribute *qla2x00_host_attrs[];
 struct fc_function_template;
 extern struct fc_function_template qla2xxx_transport_functions;
-extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
+extern int qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
 extern void qla2x00_init_host_attr(scsi_qla_host_t *);
-extern void qla2x00_alloc_sysfs_attr(scsi_qla_host_t *);
-extern void qla2x00_free_sysfs_attr(scsi_qla_host_t *);
 #endif /* _QLA_GBL_H */
diff -puN drivers/scsi/qla2xxx/qla_os.c~scsi-qla2xxx-handle-sysfs-errors drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c~scsi-qla2xxx-handle-sysfs-errors
+++ a/drivers/scsi/qla2xxx/qla_os.c
@@ -1638,7 +1638,9 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	if (ret)
 		goto probe_failed;
 
-	qla2x00_alloc_sysfs_attr(ha);
+	ret = qla2x00_alloc_sysfs_attr(ha);
+	if (ret)
+		goto probe_failed_rmhost;
 
 	qla2x00_init_host_attr(ha);
 
@@ -1658,6 +1660,9 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 
 	return 0;
 
+probe_failed_rmhost:
+	scsi_remove_host(host);
+
 probe_failed:
 	qla2x00_free_device(ha);
 
_
