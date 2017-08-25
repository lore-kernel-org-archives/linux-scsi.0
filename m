From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 07/26] libsas: move bus_reset_handler() to target_reset_handler()
Date: Fri, 25 Aug 2017 13:57:02 +0200
Message-ID: <1503662241-127788-8-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49607 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756500AbdHYL6B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:01 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus reset handler is calling I_T Nexus reset, which logically
is a target reset as it need to specify both the initiator and
the target.
So move it to target reset.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/aic94xx/aic94xx_init.c   |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c |  2 +-
 drivers/scsi/isci/init.c              |  2 +-
 drivers/scsi/libsas/sas_scsi_host.c   | 12 ++++++------
 drivers/scsi/mvsas/mv_init.c          |  2 +-
 drivers/scsi/pm8001/pm8001_init.c     |  2 +-
 include/scsi/libsas.h                 |  2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index a240fee..6c83886 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -70,7 +70,7 @@
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler	= sas_eh_device_reset_handler,
-	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
+	.eh_target_reset_handler	= sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.track_queue_depth	= 1,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index bdef111..16664f2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1562,7 +1562,7 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
-	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
+	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 };
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 4537117..922e3e5 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -166,7 +166,7 @@ struct device_attribute *isci_host_attrs[] = {
 	.use_clustering			= ENABLE_CLUSTERING,
 	.eh_abort_handler		= sas_eh_abort_handler,
 	.eh_device_reset_handler        = sas_eh_device_reset_handler,
-	.eh_bus_reset_handler           = sas_eh_bus_reset_handler,
+	.eh_target_reset_handler        = sas_eh_target_reset_handler,
 	.target_destroy			= sas_target_destroy,
 	.ioctl				= sas_ioctl,
 	.shost_attrs			= isci_host_attrs,
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 87e5079..3c51da8 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -526,7 +526,7 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	return FAILED;
 }
 
-int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd)
+int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
 {
 	int res;
 	struct Scsi_Host *host = cmd->device->host;
@@ -554,15 +554,15 @@ static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 	struct Scsi_Host *shost = cmd->device->host;
 
 	if (!shost->hostt->eh_device_reset_handler)
-		goto try_bus_reset;
+		goto try_target_reset;
 
 	res = shost->hostt->eh_device_reset_handler(cmd);
 	if (res == SUCCESS)
 		return res;
 
-try_bus_reset:
-	if (shost->hostt->eh_bus_reset_handler)
-		return shost->hostt->eh_bus_reset_handler(cmd);
+try_target_reset:
+	if (shost->hostt->eh_target_reset_handler)
+		return shost->hostt->eh_target_reset_handler(cmd);
 
 	return FAILED;
 }
@@ -996,6 +996,6 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr)
 EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
 EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
-EXPORT_SYMBOL_GPL(sas_eh_bus_reset_handler);
+EXPORT_SYMBOL_GPL(sas_eh_target_reset_handler);
 EXPORT_SYMBOL_GPL(sas_target_destroy);
 EXPORT_SYMBOL_GPL(sas_ioctl);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index f0a096a..718c88d 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -61,7 +61,7 @@
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
-	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
+	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= mvst_host_attrs,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 2908881..0e013f7 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -86,7 +86,7 @@
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
-	.eh_bus_reset_handler	= sas_eh_bus_reset_handler,
+	.eh_target_reset_handler = sas_eh_target_reset_handler,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 	.shost_attrs		= pm8001_host_attrs,
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index cfaeed2..e7c012c 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -714,7 +714,7 @@ extern int sas_bios_param(struct scsi_device *,
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
-int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd);
+int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
 
 extern void sas_target_destroy(struct scsi_target *);
 extern int sas_slave_alloc(struct scsi_device *);
-- 
1.8.5.6
