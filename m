From: James Smart <james.smart@emulex.com>
Subject: [PATCH 06/21] lpfc: Fix host reset escalation killing all IOs.
Date: Fri, 3 Apr 2015 17:11:29 -0400
Message-ID: <1428095489.6933.34.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:1266 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbbDCVLx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2015 17:11:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix host reset escalation killing all IOs.

SLI-3 adapters will use a new host template. The template differs
from SLI-4 adapters in that it does not have an eh_host_reset_handler.

Lpfc has traditionally never had a host_reset. The host reset
handler was added when we ran into a stuck hardware condition on a
SLI-4 adapter. The host_reset will reset and reinit the pci function,
clearing the hardware condition.

Unfortunately, the host reset handler uses attach/detach code paths,
which makes scsi_add_host() and scsi_remove_host() calls. Meaning, a
host_reset will completely remove the scsi_host from the system. As a
new call to scsi_add_host() is made, the shost# changes, which results
in completely new scsi_devices and device names. All the older scsi
devices on the old shost# are now orphaned and unrecoverable.

We realize we need to re-implement the host_reset_handler so the scsi_host
stays registered across the host_reset, but that will be a rather
lengthy effort. In the short term, we had an immediate need to restore
the SLI-3 devices to their working behavior, with the easiest path being
to remove their host_reset handler.

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 11 ++++++++---
 drivers/scsi/lpfc/lpfc_scsi.c | 25 +++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 00665a5..665c88c 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -354,6 +354,7 @@ void lpfc_free_sysfs_attr(struct lpfc_vport *);
 extern struct device_attribute *lpfc_hba_attrs[];
 extern struct device_attribute *lpfc_vport_attrs[];
 extern struct scsi_host_template lpfc_template;
+extern struct scsi_host_template lpfc_template_s3;
 extern struct scsi_host_template lpfc_vport_template;
 extern struct fc_function_template lpfc_transport_functions;
 extern struct fc_function_template lpfc_vport_transport_functions;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4ba91af..74672e0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3257,12 +3257,17 @@ lpfc_create_port(struct lpfc_hba *phba, int instance, struct device *dev)
 	struct Scsi_Host  *shost;
 	int error = 0;
 
-	if (dev != &phba->pcidev->dev)
+	if (dev != &phba->pcidev->dev) {
 		shost = scsi_host_alloc(&lpfc_vport_template,
 					sizeof(struct lpfc_vport));
-	else
-		shost = scsi_host_alloc(&lpfc_template,
+	} else {
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			shost = scsi_host_alloc(&lpfc_template,
 					sizeof(struct lpfc_vport));
+		else
+			shost = scsi_host_alloc(&lpfc_template_s3,
+					sizeof(struct lpfc_vport));
+	}
 	if (!shost)
 		goto out;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 4f9222e..f623299 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5857,6 +5857,31 @@ lpfc_disable_oas_lun(struct lpfc_hba *phba, struct lpfc_name *vport_wwpn,
 	return false;
 }
 
+struct scsi_host_template lpfc_template_s3 = {
+	.module			= THIS_MODULE,
+	.name			= LPFC_DRIVER_NAME,
+	.info			= lpfc_info,
+	.queuecommand		= lpfc_queuecommand,
+	.eh_abort_handler	= lpfc_abort_handler,
+	.eh_device_reset_handler = lpfc_device_reset_handler,
+	.eh_target_reset_handler = lpfc_target_reset_handler,
+	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
+	.slave_alloc		= lpfc_slave_alloc,
+	.slave_configure	= lpfc_slave_configure,
+	.slave_destroy		= lpfc_slave_destroy,
+	.scan_finished		= lpfc_scan_finished,
+	.this_id		= -1,
+	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
+	.cmd_per_lun		= LPFC_CMD_PER_LUN,
+	.use_clustering		= ENABLE_CLUSTERING,
+	.shost_attrs		= lpfc_hba_attrs,
+	.max_sectors		= 0xFFFF,
+	.vendor_id		= LPFC_NL_VENDOR_ID,
+	.change_queue_depth	= scsi_change_queue_depth,
+	.use_blk_tags		= 1,
+	.track_queue_depth	= 1,
+};
+
 struct scsi_host_template lpfc_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
-- 
1.7.11.7




