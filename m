From: James Smart <james.smart@emulex.com>
Subject: [PATCH 17/21] lpfc 8.3.33: Make I/O to hw queue distribution
 algorithm a module parameter
Date: Fri, 3 Aug 2012 12:36:42 -0400
Message-ID: <1344011802.6110.42.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40342 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2HCQgt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:36:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Make I/O to hw queue distribution algorithm a module parameter


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    1 +
 lpfc_attr.c |   12 ++++++++++++
 lpfc_hw4.h  |    4 ++++
 lpfc_sli.c  |    6 +++++-
 4 files changed, 22 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2012-07-22 14:26:57.421274202 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2012-07-22 14:30:08.545267563 -0400
@@ -3778,6 +3778,16 @@ static DEVICE_ATTR(lpfc_max_scsicmpl_tim
 LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 support");
 
 /*
+# lpfc_fcp_io_sched: Determine scheduling algrithmn for issuing FCP cmds
+# range is [0,1]. Default value is 0.
+# For [0], FCP commands are issued to Work Queues ina round robin fashion.
+# For [1], FCP commands are issued to a Work Queue associated with the
+#          current CPU.
+*/
+LPFC_ATTR_RW(fcp_io_sched, 0, 0, 1, "Determine scheduling algrithmn for "
+		"issuing commands [0] - Round Robin, [1] - Current CPU");
+
+/*
 # lpfc_cr_delay & lpfc_cr_count: Default values for I/O colaesing
 # cr_delay (msec) or cr_count outstanding commands. cr_delay can take
 # value [0,63]. cr_count can take value [1,255]. Default value of cr_delay
@@ -4001,6 +4011,7 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_topology,
 	&dev_attr_lpfc_scan_down,
 	&dev_attr_lpfc_link_speed,
+	&dev_attr_lpfc_fcp_io_sched,
 	&dev_attr_lpfc_cr_delay,
 	&dev_attr_lpfc_cr_count,
 	&dev_attr_lpfc_multi_ring_support,
@@ -4990,6 +5001,7 @@ struct fc_function_template lpfc_vport_t
 void
 lpfc_get_cfgparam(struct lpfc_hba *phba)
 {
+	lpfc_fcp_io_sched_init(phba, lpfc_fcp_io_sched);
 	lpfc_cr_delay_init(phba, lpfc_cr_delay);
 	lpfc_cr_count_init(phba, lpfc_cr_count);
 	lpfc_multi_ring_support_init(phba, lpfc_multi_ring_support);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-07-22 14:26:57.365274203 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2012-07-22 14:30:08.549267563 -0400
@@ -684,6 +684,7 @@ struct lpfc_hba {
 #define LPFC_FCF_FOV 1		/* Fast fcf failover */
 #define LPFC_FCF_PRIORITY 2	/* Priority fcf failover */
 	uint32_t cfg_fcf_failover_policy;
+	uint32_t cfg_fcp_io_sched;
 	uint32_t cfg_cr_delay;
 	uint32_t cfg_cr_count;
 	uint32_t cfg_multi_ring_support;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-07-22 14:26:57.427274202 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-07-22 14:30:08.557267563 -0400
@@ -187,6 +187,10 @@ struct lpfc_sli_intf {
 /* Active interrupt test count */
 #define LPFC_ACT_INTR_CNT	4
 
+/* Algrithmns for scheduling FCP commands to WQs */
+#define	LPFC_FCP_SCHED_ROUND_ROBIN	0
+#define	LPFC_FCP_SCHED_BY_CPU		1
+
 /* Delay Multiplier constant */
 #define LPFC_DMULT_CONST       651042
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 14:26:57.511274199 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-07-22 14:30:08.566267563 -0400
@@ -7816,7 +7816,11 @@ lpfc_sli4_scmd_to_wqidx_distr(struct lpf
 {
 	int i;
 
-	i = atomic_add_return(1, &phba->fcp_qidx);
+	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU)
+		i = smp_processor_id();
+	else
+		i = atomic_add_return(1, &phba->fcp_qidx);
+
 	i = (i % phba->cfg_fcp_io_channel);
 	return i;
 }



