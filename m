From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 5/5] lpfc: Add sysfs interface to post NVME RSCN
Date: Sat, 28 Oct 2017 18:14:56 -0700
Message-ID: <20171029011456.12885-6-jsmart2021@gmail.com>
References: <20171029011456.12885-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:44480 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdJ2BPI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Oct 2017 21:15:08 -0400
Received: by mail-pf0-f196.google.com with SMTP id x7so7805131pfa.1
        for <linux-scsi@vger.kernel.org>; Sat, 28 Oct 2017 18:15:08 -0700 (PDT)
In-Reply-To: <20171029011456.12885-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

To support scenarios which aren't bound to nvmetcli add port scenarios,
which is currently where the transport invokes the nvme_subsystem_changed
callback, add a syfs attribute to lpfc which can be written to cause
an RSCN to be generated for the nport.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 62 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 157788f0bc10..52d403548a3a 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -781,6 +781,7 @@ struct lpfc_hba {
 	uint32_t cfg_use_msi;
 	uint32_t cfg_auto_imax;
 	uint32_t cfg_fcp_imax;
+	uint32_t cfg_force_rscn;
 	uint32_t cfg_fcp_cpu_map;
 	uint32_t cfg_fcp_io_channel;
 	uint32_t cfg_suppress_rsp;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index c17677f494af..6e8e54e65e25 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4469,6 +4469,66 @@ static DEVICE_ATTR(lpfc_req_fw_upgrade, S_IRUGO | S_IWUSR,
 		   lpfc_request_firmware_upgrade_store);
 
 /**
+ * lpfc_force_rscn_store
+ *
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: unused string
+ * @count: unused variable.
+ *
+ * Description:
+ * Force the switch to send a RSCN to all other NPorts in our zone
+ * If we are direct connect pt2pt, build the RSCN command ourself
+ * and send to the other NPort. Not supported for private loop.
+ *
+ * Returns:
+ * 0      - on success
+ * -EIO   - if command is not sent
+ **/
+static ssize_t
+lpfc_force_rscn_store(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	int i;
+
+	i = lpfc_issue_els_rscn(vport, 0);
+	if (i)
+		return -EIO;
+	return strlen(buf);
+}
+
+/*
+ * lpfc_force_rscn: Force an RSCN to be sent to all remote NPorts
+ * connected to  the HBA.
+ *
+ * Value range is any ascii value
+ */
+static int lpfc_force_rscn;
+module_param(lpfc_force_rscn, int, 0644);
+MODULE_PARM_DESC(lpfc_force_rscn,
+		 "Force an RSCN to be sent to all remote NPorts");
+lpfc_param_show(force_rscn)
+
+/**
+ * lpfc_force_rscn_init - Force an RSCN to be sent to all remote NPorts
+ * @phba: lpfc_hba pointer.
+ * @val: unused value.
+ *
+ * Returns:
+ * zero if val saved.
+ **/
+static int
+lpfc_force_rscn_init(struct lpfc_hba *phba, int val)
+{
+	return 0;
+}
+
+static DEVICE_ATTR(lpfc_force_rscn, 0644,
+		   lpfc_force_rscn_show, lpfc_force_rscn_store);
+
+/**
  * lpfc_fcp_imax_store
  *
  * @dev: class device that is converted into a Scsi_host.
@@ -5218,6 +5278,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_nvme_oas,
 	&dev_attr_lpfc_auto_imax,
 	&dev_attr_lpfc_fcp_imax,
+	&dev_attr_lpfc_force_rscn,
 	&dev_attr_lpfc_fcp_cpu_map,
 	&dev_attr_lpfc_fcp_io_channel,
 	&dev_attr_lpfc_suppress_rsp,
@@ -6238,6 +6299,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_nvme_oas_init(phba, lpfc_nvme_oas);
 	lpfc_auto_imax_init(phba, lpfc_auto_imax);
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
+	lpfc_force_rscn_init(phba, lpfc_force_rscn);
 	lpfc_fcp_cpu_map_init(phba, lpfc_fcp_cpu_map);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
-- 
2.13.1
