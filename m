From: Dan Williams <dan.j.williams@intel.com>
Subject: [set2 PATCH 2/4] libsas: add sas_eh_abort_handler
Date: Thu, 21 Jun 2012 23:30:53 -0700
Message-ID: <20120622063053.21248.66299.stgit@dwillia2-linux.jf.intel.com>
References: <20120622063043.21248.12701.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57515 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761323Ab2FVGOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:14:16 -0400
In-Reply-To: <20120622063043.21248.12701.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jacek Danecki <jacek.danecki@intel.com>

When recovering failed eh-cmnds let the lldd attempt an abort via
scsi_abort_eh_cmnd before escalating.

Reviewed-by: Jacek Danecki <jacek.danecki@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   21 +++++++++++++++++++++
 include/scsi/libsas.h               |    1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2e0e779..875b871 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -531,6 +531,27 @@ static int sas_queue_reset(struct domain_device *dev, int reset_type, int lun, i
 	return FAILED;
 }
 
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
index ade862a..7c4bd08 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -718,6 +718,7 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
 void sas_init_dev(struct domain_device *);
 
 void sas_task_abort(struct sas_task *);
+int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd);
 

