From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 10/13] libsas: add sas_eh_abort_handler
Date: Fri, 10 Feb 2012 00:45:30 -0800
Message-ID: <20120210084530.25701.91058.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64223 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443Ab2BJIaf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 03:30:35 -0500
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

When recovering failed eh-cmnds let the lldd attempt an abort via
scsi_abort_eh_cmnd before escalating.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   21 +++++++++++++++++++++
 include/scsi/libsas.h               |    1 +
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 1cabedc..82f7532 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -460,6 +460,27 @@ struct sas_phy *sas_get_local_phy(struct domain_device *dev)
 }
 EXPORT_SYMBOL_GPL(sas_get_local_phy);
 
+int sas_eh_abort_handler(struct scsi_cmnd *cmd)
+{
+	int res;
+	struct sas_task *task = TO_SAS_TASK(cmd);
+	struct Scsi_Host *host = cmd->device->host;
+	struct sas_internal *i = to_sas_internal(host->transportt);
+
+	if (current != host->ehandler)
+		return FAILED;
+
+	if (!i->dft->lldd_abort_task)
+		return FAILED;
+
+	res = i->dft->lldd_abort_task(task);
+	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
+		return SUCCESS;
+
+	return FAILED;
+}
+EXPORT_SYMBOL_GPL(sas_eh_abort_handler);
+
 /* Attempt to send a LUN reset message to a device */
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 5f5ed1b..484bc52 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -674,6 +674,7 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
 void sas_init_dev(struct domain_device *);
 
 void sas_task_abort(struct sas_task *);
+int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd);
 

