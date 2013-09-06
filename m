From: James Smart <james.smart@emulex.com>
Subject: [PATCH 17/18] lpfc 8.3.42: Fixed issue of task management commands
 having a fixed timeout
Date: Fri, 6 Sep 2013 12:22:46 -0400
Message-ID: <1378484566.14051.36.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:49829 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3IFQXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:23:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed issue of task management commands having a fixed timeout


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    1 +
 lpfc_attr.c |    8 ++++++++
 lpfc_scsi.c |    2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-09-06 10:04:23.068058739 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-09-06 10:04:34.728059004 -0400
@@ -4115,6 +4115,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
 	     "Milliseconds driver will wait between polling FCP ring");
 
 /*
+# lpfc_task_mgmt_tmo: Maximum time to wait for task management commands
+# to complete in seconds. Value range is [5,180], default value is 60.
+*/
+LPFC_ATTR_RW(task_mgmt_tmo, 60, 5, 180,
+	     "Maximum time to wait for task management commands to complete");
+/*
 # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
 #		support this feature
 #       0  = MSI disabled
@@ -4300,6 +4306,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_issue_reset,
 	&dev_attr_lpfc_poll,
 	&dev_attr_lpfc_poll_tmo,
+	&dev_attr_lpfc_task_mgmt_tmo,
 	&dev_attr_lpfc_use_msi,
 	&dev_attr_lpfc_fcp_imax,
 	&dev_attr_lpfc_fcp_cpu_map,
@@ -5279,6 +5286,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_topology_init(phba, lpfc_topology);
 	lpfc_link_speed_init(phba, lpfc_link_speed);
 	lpfc_poll_tmo_init(phba, lpfc_poll_tmo);
+	lpfc_task_mgmt_tmo_init(phba, lpfc_task_mgmt_tmo);
 	lpfc_enable_npiv_init(phba, lpfc_enable_npiv);
 	lpfc_fcf_failover_policy_init(phba, lpfc_fcf_failover_policy);
 	lpfc_enable_rrq_init(phba, lpfc_enable_rrq);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2013-09-06 10:04:34.731059004 -0400
@@ -708,6 +708,7 @@ struct lpfc_hba {
 	uint32_t cfg_multi_ring_type;
 	uint32_t cfg_poll;
 	uint32_t cfg_poll_tmo;
+	uint32_t cfg_task_mgmt_tmo;
 	uint32_t cfg_use_msi;
 	uint32_t cfg_fcp_imax;
 	uint32_t cfg_fcp_cpu_map;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:32.486058953 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:34.787059006 -0400
@@ -5015,7 +5015,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 	lpfc_cmd = lpfc_get_scsi_buf(phba, rdata->pnode);
 	if (lpfc_cmd == NULL)
 		return FAILED;
-	lpfc_cmd->timeout = 60;
+	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
 	lpfc_cmd->rdata = rdata;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,



