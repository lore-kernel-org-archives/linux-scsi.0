From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 09/13] libsas: enforce eh strategy handlers only in eh
 context
Date: Fri, 10 Feb 2012 00:45:25 -0800
Message-ID: <20120210084525.25701.51128.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The strategy handlers may be called in places that are problematic for
libsas (i.e. sata resets outside of domain revalidation filtering /
libata link recovery), or problematic for userspace (non-blocking ioctl
to sleeping reset functions).  However, these routines are also called
for eh escalations and recovery of scsi_eh_prep_cmnd(), so permit them
as long as we are running in the host's error handler.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f0b9b7b..1cabedc 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -463,11 +463,14 @@ EXPORT_SYMBOL_GPL(sas_get_local_phy);
 /* Attempt to send a LUN reset message to a device */
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct domain_device *dev = cmd_to_domain_dev(cmd);
-	struct sas_internal *i =
-		to_sas_internal(dev->port->ha->core.shost->transportt);
-	struct scsi_lun lun;
 	int res;
+	struct scsi_lun lun;
+	struct Scsi_Host *host = cmd->device->host;
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct sas_internal *i = to_sas_internal(host->transportt);
+
+	if (current != host->ehandler)
+		return FAILED;
 
 	int_to_scsilun(cmd->device->lun, &lun);
 
@@ -486,8 +489,12 @@ int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct sas_phy *phy = sas_get_local_phy(dev);
+	struct Scsi_Host *host = cmd->device->host;
 	int res;
 
+	if (current != host->ehandler)
+		return FAILED;
+
 	res = sas_phy_reset(phy, 1);
 	if (res)
 		SAS_DPRINTK("Bus reset of %s failed 0x%x\n",

