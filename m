From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 04/18] lpfc: NVME Initiator: Base modifications Part B
Date: Mon, 06 Feb 2017 15:08:53 -0800
Message-ID: <58990205.nqeJXupJQjiVi+3s%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33210 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751524AbdBFXI7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 18:08:59 -0500
Received: by mail-wm0-f68.google.com with SMTP id v77so24903536wmv.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 15:08:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org


NVME Initiator: Base modifications

This is part B of parts A..F.

Part B is limited to lpfc_attr.c: lpfc attribute modifications

This patch by itself will not result in a compilable driver. All parts
A..F must be applied to create a compilable driver.

*********

Refer to Part A for a description of base modifications

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
Modifications in V2:
 Note: this was patch 3 in the V1 patches
 Address review items:
  Correct typecast of void ptr assignment
 Sync with max_hw_queues/io_channel/io_channel_irqs change

 drivers/scsi/lpfc/lpfc_attr.c | 390 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 347 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 50cf402..2fec637 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -35,14 +35,17 @@
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/fc/fc_fs.h>
 
+#include <linux/nvme-fc-driver.h>
+
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
 #include "lpfc_sli.h"
 #include "lpfc_sli4.h"
 #include "lpfc_nl.h"
 #include "lpfc_disc.h"
-#include "lpfc_scsi.h"
 #include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_nvme.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_version.h"
 #include "lpfc_compat.h"
@@ -50,9 +53,9 @@
 #include "lpfc_vport.h"
 #include "lpfc_attr.h"
 
-#define LPFC_DEF_DEVLOSS_TMO 30
-#define LPFC_MIN_DEVLOSS_TMO 1
-#define LPFC_MAX_DEVLOSS_TMO 255
+#define LPFC_DEF_DEVLOSS_TMO	30
+#define LPFC_MIN_DEVLOSS_TMO	1
+#define LPFC_MAX_DEVLOSS_TMO	255
 
 /*
  * Write key size should be multiple of 4. If write key is changed
@@ -130,6 +133,124 @@ lpfc_enable_fip_show(struct device *dev, struct device_attribute *attr,
 }
 
 static ssize_t
+lpfc_nvme_info_show(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = shost_priv(shost);
+	struct lpfc_hba   *phba = vport->phba;
+	struct nvme_fc_local_port *localport;
+	struct lpfc_nvme_lport *lport;
+	struct lpfc_nvme_rport *rport;
+	struct nvme_fc_remote_port *nrport;
+	char *statep;
+	int len = 0;
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)) {
+		len += snprintf(buf, PAGE_SIZE, "NVME Disabled\n");
+		return len;
+	}
+
+	localport = vport->localport;
+	if (!localport) {
+		len = snprintf(buf, PAGE_SIZE,
+				"NVME Initiator x%llx is not allocated\n",
+				wwn_to_u64(vport->fc_portname.u.wwn));
+		return len;
+	}
+	len = snprintf(buf, PAGE_SIZE, "NVME Initiator Enabled\n");
+
+	spin_lock_irq(shost->host_lock);
+	lport = (struct lpfc_nvme_lport *)localport->private;
+
+	/* Port state is only one of two values for now. */
+	if (localport->port_id)
+		statep = "ONLINE";
+	else
+		statep = "UNKNOWN ";
+
+	len += snprintf(buf + len, PAGE_SIZE - len,
+			"%s%d WWPN x%llx WWNN x%llx DID x%06x %s\n",
+			"NVME LPORT lpfc",
+			phba->brd_no,
+			wwn_to_u64(vport->fc_portname.u.wwn),
+			wwn_to_u64(vport->fc_nodename.u.wwn),
+			localport->port_id, statep);
+
+	list_for_each_entry(rport, &lport->rport_list, list) {
+		/* local short-hand pointer. */
+		nrport = rport->remoteport;
+
+		/* Port state is only one of two values for now. */
+		switch (nrport->port_state) {
+		case FC_OBJSTATE_ONLINE:
+			statep = "ONLINE";
+			break;
+		case FC_OBJSTATE_UNKNOWN:
+			statep = "UNKNOWN ";
+			break;
+		default:
+			statep = "UNSUPPORTED";
+			break;
+		}
+
+		/* Tab in to show lport ownership. */
+		len += snprintf(buf + len, PAGE_SIZE - len,
+				"NVME RPORT       ");
+		if (phba->brd_no >= 10)
+			len += snprintf(buf + len, PAGE_SIZE - len, " ");
+
+		len += snprintf(buf + len, PAGE_SIZE - len, "WWPN x%llx ",
+				nrport->port_name);
+		len += snprintf(buf + len, PAGE_SIZE - len, "WWNN x%llx ",
+				nrport->node_name);
+		len += snprintf(buf + len, PAGE_SIZE - len, "DID x%06x ",
+				nrport->port_id);
+
+		switch (nrport->port_role) {
+		case FC_PORT_ROLE_NVME_INITIATOR:
+			len +=  snprintf(buf + len, PAGE_SIZE - len,
+					 "INITIATOR ");
+			break;
+		case FC_PORT_ROLE_NVME_TARGET:
+			len +=  snprintf(buf + len, PAGE_SIZE - len,
+					 "TARGET ");
+			break;
+		case FC_PORT_ROLE_NVME_DISCOVERY:
+			len +=  snprintf(buf + len, PAGE_SIZE - len,
+					 "DISCOVERY ");
+			break;
+		default:
+			len +=  snprintf(buf + len, PAGE_SIZE - len,
+					 "UNKNOWN_ROLE x%x",
+					 nrport->port_role);
+			break;
+		}
+		len +=  snprintf(buf + len, PAGE_SIZE - len, "%s  ", statep);
+		/* Terminate the string. */
+		len +=  snprintf(buf + len, PAGE_SIZE - len, "\n");
+	}
+	spin_unlock_irq(shost->host_lock);
+
+	len += snprintf(buf + len, PAGE_SIZE, "\nNVME Statistics\n");
+	len += snprintf(buf+len, PAGE_SIZE-len,
+			"LS: Xmt %016llx Cmpl %016llx\n",
+			phba->fc4NvmeLsRequests,
+			phba->fc4NvmeLsCmpls);
+
+	len += snprintf(buf+len, PAGE_SIZE-len,
+			"FCP: Rd %016llx Wr %016llx IO %016llx\n",
+			phba->fc4NvmeInputRequests,
+			phba->fc4NvmeOutputRequests,
+			phba->fc4NvmeControlRequests);
+
+	len += snprintf(buf+len, PAGE_SIZE-len,
+			"    Cmpl %016llx\n", phba->fc4NvmeIoCmpls);
+
+	return len;
+}
+
+static ssize_t
 lpfc_bg_info_show(struct device *dev, struct device_attribute *attr,
 		  char *buf)
 {
@@ -675,6 +796,28 @@ lpfc_issue_lip(struct Scsi_Host *shost)
 	return 0;
 }
 
+int
+lpfc_emptyq_wait(struct lpfc_hba *phba, struct list_head *q, spinlock_t *lock)
+{
+	int cnt = 0;
+
+	spin_lock_irq(lock);
+	while (!list_empty(q)) {
+		spin_unlock_irq(lock);
+		msleep(20);
+		if (cnt++ > 250) {  /* 5 secs */
+			lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
+					"0466 %s %s\n",
+					"Outstanding IO when ",
+					"bringing Adapter offline\n");
+				return 0;
+		}
+		spin_lock_irq(lock);
+	}
+	spin_unlock_irq(lock);
+	return 1;
+}
+
 /**
  * lpfc_do_offline - Issues a mailbox command to bring the link down
  * @phba: lpfc_hba pointer.
@@ -694,10 +837,10 @@ static int
 lpfc_do_offline(struct lpfc_hba *phba, uint32_t type)
 {
 	struct completion online_compl;
+	struct lpfc_queue *qp = NULL;
 	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	int status = 0;
-	int cnt = 0;
 	int i;
 	int rc;
 
@@ -717,20 +860,24 @@ lpfc_do_offline(struct lpfc_hba *phba, uint32_t type)
 	/* Wait a little for things to settle down, but not
 	 * long enough for dev loss timeout to expire.
 	 */
-	for (i = 0; i < psli->num_rings; i++) {
-		pring = &psli->ring[i];
-		while (!list_empty(&pring->txcmplq)) {
-			msleep(10);
-			if (cnt++ > 500) {  /* 5 secs */
-				lpfc_printf_log(phba,
-					KERN_WARNING, LOG_INIT,
-					"0466 Outstanding IO when "
-					"bringing Adapter offline\n");
-				break;
-			}
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		for (i = 0; i < psli->num_rings; i++) {
+			pring = &psli->sli3_ring[i];
+			if (!lpfc_emptyq_wait(phba, &pring->txcmplq,
+					      &phba->hbalock))
+				goto out;
+		}
+	} else {
+		list_for_each_entry(qp, &phba->sli4_hba.lpfc_wq_list, wq_list) {
+			pring = qp->pring;
+			if (!pring)
+				continue;
+			if (!lpfc_emptyq_wait(phba, &pring->txcmplq,
+					      &pring->ring_lock))
+				goto out;
 		}
 	}
-
+out:
 	init_completion(&online_compl);
 	rc = lpfc_workq_post_event(phba, &status, &online_compl, type);
 	if (rc == 0)
@@ -1945,6 +2092,7 @@ lpfc_##attr##_store(struct device *dev, struct device_attribute *attr, \
 }
 
 
+static DEVICE_ATTR(nvme_info, 0444, lpfc_nvme_info_show, NULL);
 static DEVICE_ATTR(bg_info, S_IRUGO, lpfc_bg_info_show, NULL);
 static DEVICE_ATTR(bg_guard_err, S_IRUGO, lpfc_bg_guard_err_show, NULL);
 static DEVICE_ATTR(bg_apptag_err, S_IRUGO, lpfc_bg_apptag_err_show, NULL);
@@ -2816,9 +2964,9 @@ lpfc_txq_hw_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
+	struct lpfc_sli_ring *pring = lpfc_phba_elsring(phba);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-		phba->sli.ring[LPFC_ELS_RING].txq_max);
+	return snprintf(buf, PAGE_SIZE, "%d\n", pring->txq_max);
 }
 
 static DEVICE_ATTR(txq_hw, S_IRUGO,
@@ -2829,9 +2977,9 @@ lpfc_txcmplq_hw_show(struct device *dev, struct device_attribute *attr,
 {
 	struct Scsi_Host  *shost = class_to_shost(dev);
 	struct lpfc_hba   *phba = ((struct lpfc_vport *) shost->hostdata)->phba;
+	struct lpfc_sli_ring *pring = lpfc_phba_elsring(phba);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
-		phba->sli.ring[LPFC_ELS_RING].txcmplq_max);
+	return snprintf(buf, PAGE_SIZE, "%d\n", pring->txcmplq_max);
 }
 
 static DEVICE_ATTR(txcmplq_hw, S_IRUGO,
@@ -3030,6 +3178,41 @@ static DEVICE_ATTR(lpfc_devloss_tmo, S_IRUGO | S_IWUSR,
 		   lpfc_devloss_tmo_show, lpfc_devloss_tmo_store);
 
 /*
+ * lpfc_suppress_rsp: Enable suppress rsp feature is firmware supports it
+ * lpfc_suppress_rsp = 0  Disable
+ * lpfc_suppress_rsp = 1  Enable (default)
+ *
+ */
+LPFC_ATTR_R(suppress_rsp, 1, 0, 1,
+	    "Enable suppress rsp feature is firmware supports it");
+
+/*
+ * lpfc_enable_fc4_type: Defines what FC4 types are supported.
+ * Supported Values:  1 - register just FCP
+ *                    2 - register just NVME
+ *                    3 - register both FCP and NVME
+ * is [1,3]. Default value is 1
+ */
+LPFC_ATTR_R(enable_fc4_type, LPFC_ENABLE_FCP,
+	     LPFC_ENABLE_FCP, LPFC_ENABLE_BOTH,
+	     "Define fc4 type to register with fabric.");
+
+/*
+ * lpfc_xri_split: Defines the division of XRI resources between SCSI and NVME
+ * This parameter is only used if:
+ *     lpfc_enable_fc4_type is 3 - register both FCP and NVME
+ *
+ * ELS/CT always get 10% of XRIs, up to a maximum of 250
+ * The remaining XRIs get split up based on lpfc_xri_split per port:
+ *
+ * Supported Values are in percentages
+ * the xri_split value is the percentage the SCSI port will get. The remaining
+ * percentage will go to NVME.
+ */
+LPFC_ATTR_R(xri_split, 50, 10, 90,
+	     "Division of XRI resources between SCSI and NVME");
+
+/*
 # lpfc_log_verbose: Only turn this flag on if you are willing to risk being
 # deluged with LOTS of information.
 # You can set a bit mask to record specific types of verbose messages:
@@ -4143,13 +4326,14 @@ lpfc_fcp_imax_store(struct device *dev, struct device_attribute *attr,
 	/*
 	 * Value range for the HBA is [5000,5000000]
 	 * The value for each EQ depends on how many EQs are configured.
+	 * Allow value == 0
 	 */
-	if (val < LPFC_MIN_IMAX || val > LPFC_MAX_IMAX)
+	if (val && (val < LPFC_MIN_IMAX || val > LPFC_MAX_IMAX))
 		return -EINVAL;
 
 	phba->cfg_fcp_imax = (uint32_t)val;
-	for (i = 0; i < phba->cfg_fcp_io_channel; i += LPFC_MAX_EQ_DELAY)
-		lpfc_modify_fcp_eq_delay(phba, i);
+	for (i = 0; i < phba->io_channel_irqs; i++)
+		lpfc_modify_hba_eq_delay(phba, i);
 
 	return strlen(buf);
 }
@@ -4187,7 +4371,8 @@ lpfc_fcp_imax_init(struct lpfc_hba *phba, int val)
 		return 0;
 	}
 
-	if (val >= LPFC_MIN_IMAX && val <= LPFC_MAX_IMAX) {
+	if ((val >= LPFC_MIN_IMAX && val <= LPFC_MAX_IMAX) ||
+	    (val == 0)) {
 		phba->cfg_fcp_imax = val;
 		return 0;
 	}
@@ -4377,6 +4562,17 @@ LPFC_VPORT_ATTR_RW(first_burst_size, 0, 0, 65536,
 		   "First burst size for Targets that support first burst");
 
 /*
+* lpfc_nvme_enable_fb: Enable NVME first burst on I and T functions.
+* For the Initiator (I), enabling this parameter means that an NVME
+* PRLI response with FBA enabled and an FB_SIZE set to a nonzero value
+* will be processed by the initiator for subsequent NVME FCP IO.
+* Parameter supported on physical port only - no NPIV support.
+* Value range is [0,1]. Default value is 0 (disabled).
+*/
+LPFC_ATTR_RW(nvme_enable_fb, 0, 0, 1,
+	     "Enable First Burst feature on I and T functions.");
+
+/*
 # lpfc_max_scsicmpl_time: Use scsi command completion time to control I/O queue
 # depth. Default value is 0. When the value of this parameter is zero the
 # SCSI command completion time is not used for controlling I/O queue depth. When
@@ -4423,17 +4619,25 @@ static DEVICE_ATTR(lpfc_max_scsicmpl_time, S_IRUGO | S_IWUSR,
 LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 support");
 
 /*
-# lpfc_fcp_io_sched: Determine scheduling algrithmn for issuing FCP cmds
-# range is [0,1]. Default value is 0.
-# For [0], FCP commands are issued to Work Queues ina round robin fashion.
-# For [1], FCP commands are issued to a Work Queue associated with the
-#          current CPU.
-# It would be set to 1 by the driver if it's able to set up cpu affinity
-# for FCP I/Os through Work Queue associated with the current CPU. Otherwise,
-# roundrobin scheduling of FCP I/Os through WQs will be used.
-*/
-LPFC_ATTR_RW(fcp_io_sched, 0, 0, 1, "Determine scheduling algorithm for "
-		"issuing commands [0] - Round Robin, [1] - Current CPU");
+ * lpfc_io_sched: Determine scheduling algrithmn for issuing FCP cmds
+ * range is [0,1]. Default value is 0.
+ * For [0], FCP commands are issued to Work Queues ina round robin fashion.
+ * For [1], FCP commands are issued to a Work Queue associated with the
+ *          current CPU.
+ *
+ * LPFC_FCP_SCHED_ROUND_ROBIN == 0
+ * LPFC_FCP_SCHED_BY_CPU == 1
+ *
+ * The driver dynamically sets this to 1 (BY_CPU) if it's able to set up cpu
+ * affinity for FCP/NVME I/Os through Work Queues associated with the current
+ * CPU. Otherwise, the default 0 (Round Robin) scheduling of FCP/NVME I/Os
+ * through WQs will be used.
+ */
+LPFC_ATTR_RW(fcp_io_sched, LPFC_FCP_SCHED_ROUND_ROBIN,
+	     LPFC_FCP_SCHED_ROUND_ROBIN,
+	     LPFC_FCP_SCHED_BY_CPU,
+	     "Determine scheduling algorithm for "
+	     "issuing commands [0] - Round Robin, [1] - Current CPU");
 
 /*
 # lpfc_fcp2_no_tgt_reset: Determine bus reset behavior
@@ -4560,15 +4764,54 @@ LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
 	    "MSI-X (2), if possible");
 
 /*
-# lpfc_fcp_io_channel: Set the number of FCP EQ/CQ/WQ IO channels
-#
-# Value range is [1,7]. Default value is 4.
-*/
-LPFC_ATTR_R(fcp_io_channel, LPFC_FCP_IO_CHAN_DEF, LPFC_FCP_IO_CHAN_MIN,
-	    LPFC_FCP_IO_CHAN_MAX,
+ * lpfc_nvme_oas: Use the oas bit when sending NVME IOs
+ *
+ *      0  = NVME OAS disabled
+ *      1  = NVME OAS enabled
+ *
+ * Value range is [0,1]. Default value is 0.
+ */
+LPFC_ATTR_RW(nvme_oas, 0, 0, 1,
+	     "Use OAS bit on NVME IOs");
+
+/*
+ * lpfc_fcp_io_channel: Set the number of FCP IO channels the driver
+ * will advertise it supports to the SCSI layer. This also will map to
+ * the number of WQs the driver will create.
+ *
+ *      0    = Configure the number of io channels to the number of active CPUs.
+ *      1,32 = Manually specify how many io channels to use.
+ *
+ * Value range is [0,32]. Default value is 4.
+ */
+LPFC_ATTR_R(fcp_io_channel,
+	    LPFC_FCP_IO_CHAN_DEF,
+	    LPFC_HBA_IO_CHAN_MIN, LPFC_HBA_IO_CHAN_MAX,
 	    "Set the number of FCP I/O channels");
 
 /*
+ * lpfc_nvme_io_channel: Set the number of IO hardware queues the driver
+ * will advertise it supports to the NVME layer. This also will map to
+ * the number of WQs the driver will create.
+ *
+ * This module parameter is valid when lpfc_enable_fc4_type is set
+ * to support NVME.
+ *
+ * The NVME Layer will try to create this many, plus 1 administrative
+ * hardware queue. The administrative queue will always map to WQ 0
+ * A hardware IO queue maps (qidx) to a specific driver WQ.
+ *
+ *      0    = Configure the number of io channels to the number of active CPUs.
+ *      1,32 = Manually specify how many io channels to use.
+ *
+ * Value range is [0,32]. Default value is 0.
+ */
+LPFC_ATTR_R(nvme_io_channel,
+	    LPFC_NVME_IO_CHAN_DEF,
+	    LPFC_HBA_IO_CHAN_MIN, LPFC_HBA_IO_CHAN_MAX,
+	    "Set the number of NVME I/O channels");
+
+/*
 # lpfc_enable_hba_reset: Allow or prevent HBA resets to the hardware.
 #       0  = HBA resets disabled
 #       1  = HBA resets enabled (default)
@@ -4692,6 +4935,7 @@ LPFC_ATTR_R(sg_seg_cnt, LPFC_DEFAULT_SG_SEG_CNT, LPFC_DEFAULT_SG_SEG_CNT,
 LPFC_ATTR_R(enable_mds_diags, 0, 0, 1, "Enable MDS Diagnostics");
 
 struct device_attribute *lpfc_hba_attrs[] = {
+	&dev_attr_nvme_info,
 	&dev_attr_bg_info,
 	&dev_attr_bg_guard_err,
 	&dev_attr_bg_apptag_err,
@@ -4718,6 +4962,8 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_peer_port_login,
 	&dev_attr_lpfc_nodev_tmo,
 	&dev_attr_lpfc_devloss_tmo,
+	&dev_attr_lpfc_enable_fc4_type,
+	&dev_attr_lpfc_xri_split,
 	&dev_attr_lpfc_fcp_class,
 	&dev_attr_lpfc_use_adisc,
 	&dev_attr_lpfc_first_burst_size,
@@ -4752,9 +4998,13 @@ struct device_attribute *lpfc_hba_attrs[] = {
 	&dev_attr_lpfc_poll_tmo,
 	&dev_attr_lpfc_task_mgmt_tmo,
 	&dev_attr_lpfc_use_msi,
+	&dev_attr_lpfc_nvme_oas,
 	&dev_attr_lpfc_fcp_imax,
 	&dev_attr_lpfc_fcp_cpu_map,
 	&dev_attr_lpfc_fcp_io_channel,
+	&dev_attr_lpfc_suppress_rsp,
+	&dev_attr_lpfc_nvme_io_channel,
+	&dev_attr_lpfc_nvme_enable_fb,
 	&dev_attr_lpfc_enable_bg,
 	&dev_attr_lpfc_soft_wwnn,
 	&dev_attr_lpfc_soft_wwpn,
@@ -5764,15 +6014,17 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_fdmi_on_init(phba, lpfc_fdmi_on);
 	lpfc_enable_SmartSAN_init(phba, lpfc_enable_SmartSAN);
 	lpfc_use_msi_init(phba, lpfc_use_msi);
+	lpfc_nvme_oas_init(phba, lpfc_nvme_oas);
 	lpfc_fcp_imax_init(phba, lpfc_fcp_imax);
 	lpfc_fcp_cpu_map_init(phba, lpfc_fcp_cpu_map);
-	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
 	lpfc_enable_hba_reset_init(phba, lpfc_enable_hba_reset);
 	lpfc_enable_hba_heartbeat_init(phba, lpfc_enable_hba_heartbeat);
+
 	lpfc_EnableXLane_init(phba, lpfc_EnableXLane);
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		phba->cfg_EnableXLane = 0;
 	lpfc_XLanePriority_init(phba, lpfc_XLanePriority);
+
 	memset(phba->cfg_oas_tgt_wwpn, 0, (8 * sizeof(uint8_t)));
 	memset(phba->cfg_oas_vpt_wwpn, 0, (8 * sizeof(uint8_t)));
 	phba->cfg_oas_lun_state = 0;
@@ -5786,9 +6038,41 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 		phba->cfg_poll = 0;
 	else
 		phba->cfg_poll = lpfc_poll;
+	lpfc_suppress_rsp_init(phba, lpfc_suppress_rsp);
+
+	lpfc_enable_fc4_type_init(phba, lpfc_enable_fc4_type);
+
+	/* Initialize first burst. Target vs Initiator are different. */
+	lpfc_nvme_enable_fb_init(phba, lpfc_nvme_enable_fb);
+	lpfc_fcp_io_channel_init(phba, lpfc_fcp_io_channel);
+	lpfc_nvme_io_channel_init(phba, lpfc_nvme_io_channel);
+
+	/* NVME only supported on SLI4 */
+	if (phba->sli_rev != LPFC_SLI_REV4) {
+		phba->nvmet_support = 0;
+		phba->cfg_enable_fc4_type &= ~LPFC_ENABLE_NVME;
+	}
+
+	/* A value of 0 means use the number of CPUs found in the system */
+	if (phba->cfg_nvme_io_channel == 0)
+		phba->cfg_nvme_io_channel = phba->sli4_hba.num_present_cpu;
+	if (phba->cfg_fcp_io_channel == 0)
+		phba->cfg_fcp_io_channel = phba->sli4_hba.num_present_cpu;
+
+	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_FCP)
+		phba->cfg_nvme_io_channel = 0;
+
+	if (phba->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
+		phba->cfg_fcp_io_channel = 0;
+
+	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
+	else
+		phba->io_channel_irqs = phba->cfg_nvme_io_channel;
 
 	phba->cfg_soft_wwnn = 0L;
 	phba->cfg_soft_wwpn = 0L;
+	lpfc_xri_split_init(phba, lpfc_xri_split);
 	lpfc_sg_seg_cnt_init(phba, lpfc_sg_seg_cnt);
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
@@ -5805,6 +6089,26 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_nvme_mod_param_dep - Adjust module parameter value based on
+ * dependencies between protocols and roles.
+ * @phba: lpfc_hba pointer.
+ **/
+void
+lpfc_nvme_mod_param_dep(struct lpfc_hba *phba)
+{
+	phba->nvmet_support = 0;
+	if (phba->cfg_nvme_io_channel > phba->sli4_hba.num_present_cpu)
+		phba->cfg_nvme_io_channel = phba->sli4_hba.num_present_cpu;
+	if (phba->cfg_fcp_io_channel > phba->sli4_hba.num_present_cpu)
+		phba->cfg_fcp_io_channel = phba->sli4_hba.num_present_cpu;
+
+	if (phba->cfg_fcp_io_channel > phba->cfg_nvme_io_channel)
+		phba->io_channel_irqs = phba->cfg_fcp_io_channel;
+	else
+		phba->io_channel_irqs = phba->cfg_nvme_io_channel;
+}
+
+/**
  * lpfc_get_vport_cfgparam - Used during port create, init the vport structure
  * @vport: lpfc_vport pointer.
  **/
-- 
2.5.0
