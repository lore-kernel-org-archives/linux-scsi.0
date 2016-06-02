From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/14] lpfc: Add config option 'lpfc_enable_stats'
Date: Thu,  2 Jun 2016 16:39:05 +0200
Message-ID: <1464878356-42407-4-git-send-email-hare@suse.de>
References: <1464878356-42407-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933013AbcFBOjZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2016 10:39:25 -0400
In-Reply-To: <1464878356-42407-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a module option lpfc_enable_stats to enable or disable
HBA statistics. Gathering statistics is done in the hot path
during lpfc_scsi_cmd_iocb_cmpl() and require the host_lock,
so disabling them increases the overall performance.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc.h      |  1 +
 drivers/scsi/lpfc/lpfc_attr.c | 10 ++++++++++
 drivers/scsi/lpfc/lpfc_scsi.c | 21 +++++++++------------
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index d5bd420..bb53b81 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -759,6 +759,7 @@ struct lpfc_hba {
 #define LPFC_FDMI_NO_SUPPORT	0	/* FDMI not supported */
 #define LPFC_FDMI_SUPPORT	1	/* FDMI supported? */
 	uint32_t cfg_enable_SmartSAN;
+	uint32_t cfg_enable_stats;
 	lpfc_vpd_t vpd;		/* vital product data */
 
 	struct pci_dev *pcidev;
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index cfec2ec..241bbd6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4697,6 +4697,14 @@ LPFC_ATTR_RW(XLanePriority, 0, 0x0, 0x7f, "CS_CTL for Express Lane Feature.");
 LPFC_ATTR_R(enable_bg, 0, 0, 1, "Enable BlockGuard Support");
 
 /*
+# lpfc_enable_stats:  Enable HBA statistics
+#       0  = HBA statistics disabled
+#       1  = HBA statistics enabled (default)
+# Value range is [0,1]. Default value is 1
+*/
+LPFC_ATTR_RW(enable_stats, 1, 0, 1, "Enable HBA statistics.");
+
+/*
 # lpfc_fcp_look_ahead: Look ahead for completions in FCP start routine
 #       0  = disabled (default)
 #       1  = enabled
@@ -4876,6 +4884,7 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_sriov_hw_max_virtfn,
 	&dev_attr_protocol,
 	&dev_attr_lpfc_xlane_supported,
+	&dev_attr_lpfc_enable_stats,
 	NULL,
 };
 
@@ -5866,6 +5875,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_request_firmware_upgrade_init(phba, lpfc_req_fw_upgrade);
 	lpfc_suppress_link_up_init(phba, lpfc_suppress_link_up);
 	lpfc_iocb_cnt_init(phba, lpfc_iocb_cnt);
+	lpfc_enable_stats_init(phba, lpfc_enable_stats);
 	phba->cfg_enable_dss = 1;
 	return;
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3bd0be6..fde5b00 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -195,31 +195,24 @@ lpfc_sli4_set_rsp_sgl_last(struct lpfc_hba *phba,
  *
  * This function is called when there is a command completion and this
  * function updates the statistical data for the command completion.
+ * Needs to be called under shost->host_lock.
  **/
 static void
-lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
+lpfc_update_stats(struct lpfc_hba *phba, struct lpfc_vport *vport,
+		  struct lpfc_scsi_buf *lpfc_cmd)
 {
 	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
-	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
-	unsigned long flags;
-	struct Scsi_Host  *shost = cmd->device->host;
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	unsigned long latency;
 	int i;
 
-	if (cmd->result)
-		return;
-
 	latency = jiffies_to_msecs((long)jiffies - (long)lpfc_cmd->start_time);
 
-	spin_lock_irqsave(shost->host_lock, flags);
 	if (!vport->stat_data_enabled ||
 		vport->stat_data_blocked ||
 		!pnode ||
 		!pnode->lat_data ||
 		(phba->bucket_type == LPFC_NO_BUCKET)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		return;
 	}
 
@@ -239,7 +232,6 @@ lpfc_update_stats(struct lpfc_hba *phba, struct  lpfc_scsi_buf *lpfc_cmd)
 	}
 
 	pnode->lat_data[i].cmd_count++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
 }
 
 /**
@@ -4100,7 +4092,12 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 				 scsi_get_resid(cmd));
 	}
 
-	lpfc_update_stats(phba, lpfc_cmd);
+	if (!cmd->result && phba->cfg_enable_stats) {
+		spin_lock_irqsave(shost->host_lock, flags);
+		lpfc_update_stats(phba, vport, lpfc_cmd);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+	}
+
 	if (vport->cfg_max_scsicmpl_time &&
 	   time_after(jiffies, lpfc_cmd->start_time +
 		msecs_to_jiffies(vport->cfg_max_scsicmpl_time))) {
-- 
1.8.5.6

