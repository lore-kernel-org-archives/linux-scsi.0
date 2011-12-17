From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 05/24] libsas: kill sas_slave_destroy
Date: Fri, 16 Dec 2011 18:33:33 -0800
Message-ID: <20111217023333.15036.9536.stgit@localhost6.localdomain6>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Per commit 3e4ec344 "libata: kill ATA_FLAG_DISABLED" needing to set
ATA_DEV_NONE is a holdover from before libsas converted to the
"new-style" ata-eh.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/aic94xx/aic94xx_init.c |    1 -
 drivers/scsi/isci/init.c            |    1 -
 drivers/scsi/libsas/sas_scsi_host.c |    9 ---------
 drivers/scsi/mvsas/mv_init.c        |    1 -
 drivers/scsi/pm8001/pm8001_init.c   |    1 -
 include/scsi/libsas.h               |    1 -
 6 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index d5ff142..8db4e72 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -68,7 +68,6 @@ static struct scsi_host_template aic94xx_sht = {
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
-	.slave_destroy		= sas_slave_destroy,
 	.scan_finished		= asd_scan_finished,
 	.scan_start		= asd_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index a97edab..f988c16 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -146,7 +146,6 @@ static struct scsi_host_template isci_sht = {
 	.queuecommand			= sas_queuecommand,
 	.target_alloc			= sas_target_alloc,
 	.slave_configure		= sas_slave_configure,
-	.slave_destroy			= sas_slave_destroy,
 	.scan_finished			= isci_host_scan_finished,
 	.scan_start			= isci_host_scan_start,
 	.change_queue_depth		= sas_change_queue_depth,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b6e233d..e95e5e1 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -797,14 +797,6 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
 	return 0;
 }
 
-void sas_slave_destroy(struct scsi_device *scsi_dev)
-{
-	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
-
-	if (dev_is_sata(dev))
-		sas_to_ata_dev(dev)->class = ATA_DEV_NONE;
-}
-
 int sas_change_queue_depth(struct scsi_device *sdev, int depth, int reason)
 {
 	struct domain_device *dev = sdev_to_domain_dev(sdev);
@@ -1108,7 +1100,6 @@ EXPORT_SYMBOL_GPL(sas_request_addr);
 EXPORT_SYMBOL_GPL(sas_queuecommand);
 EXPORT_SYMBOL_GPL(sas_target_alloc);
 EXPORT_SYMBOL_GPL(sas_slave_configure);
-EXPORT_SYMBOL_GPL(sas_slave_destroy);
 EXPORT_SYMBOL_GPL(sas_change_queue_depth);
 EXPORT_SYMBOL_GPL(sas_change_queue_type);
 EXPORT_SYMBOL_GPL(sas_bios_param);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 6f58919..d45878b 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -60,7 +60,6 @@ static struct scsi_host_template mvs_sht = {
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
-	.slave_destroy		= sas_slave_destroy,
 	.scan_finished		= mvs_scan_finished,
 	.scan_start		= mvs_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c21a216..bd165ea 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -62,7 +62,6 @@ static struct scsi_host_template pm8001_sht = {
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
-	.slave_destroy		= sas_slave_destroy,
 	.scan_finished		= pm8001_scan_finished,
 	.scan_start		= pm8001_scan_start,
 	.change_queue_depth	= sas_change_queue_depth,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 6e64b03..2b14348 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -625,7 +625,6 @@ extern int sas_queuecommand(struct Scsi_Host * ,struct scsi_cmnd *);
 extern int sas_target_alloc(struct scsi_target *);
 extern int sas_slave_alloc(struct scsi_device *);
 extern int sas_slave_configure(struct scsi_device *);
-extern void sas_slave_destroy(struct scsi_device *);
 extern int sas_change_queue_depth(struct scsi_device *, int new_depth,
 				  int reason);
 extern int sas_change_queue_type(struct scsi_device *, int qt);

