From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: [PATCH 2/2] lpfc: add option for lpfc_fcp_io_sched (LPFC_FCP_SCHED_BY_CPU_CORE)
Date: Wed,  1 Jun 2016 17:43:29 -0300
Message-ID: <201606012043.u51KNjdd020623@mx0a-001b2d01.pphosted.com>
References: <1464813809-22066-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63993 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbcFAUnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 16:43:45 -0400
Received: from pps.filterd (m0075771.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u51KNjdd020623
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 16:43:44 -0400
Received: from e24smtp05.br.ibm.com (e24smtp05.br.ibm.com [32.104.18.26])
	by mx0a-001b2d01.pphosted.com with ESMTP id 239svypu6s-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 01 Jun 2016 16:43:44 -0400
Received: from localhost
	by e24smtp05.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
	Wed, 1 Jun 2016 17:43:41 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 94BA01DC0054
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jun 2016 16:43:31 -0400 (EDT)
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u51KhcK013697402
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 17:43:38 -0300
Received: from d24av01.br.ibm.com (localhost [127.0.0.1])
	by d24av01.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u51KhbCM031590
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2016 17:43:38 -0300
In-Reply-To: <1464813809-22066-1-git-send-email-mauricfo@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dick.kennedy@avagotech.com, james.smart@avagotech.com

This commit introduces the new value 2 for parameter 'lpfc_fcp_io_sched',
which associates work queues (or IO channels) by core, that is, all CPUs
(or threads) of a particular core are assigned the same IO channel.

The IO channels are assigned to each core in a round-robin fashion.

Tested on next-20160601.

Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
---
 drivers/scsi/lpfc/lpfc_attr.c |  8 +++++--
 drivers/scsi/lpfc/lpfc_hw4.h  |  1 +
 drivers/scsi/lpfc/lpfc_init.c | 54 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_scsi.c |  3 ++-
 4 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index cfec2ec..f8db2ad 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4517,12 +4517,16 @@ LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 support");
 # For [0], FCP commands are issued to Work Queues ina round robin fashion.
 # For [1], FCP commands are issued to a Work Queue associated with the
 #          current CPU.
+# For [2], FCP commands are issued to a Work Queue associated with the
+#          current CPU core (same Work Queue for all CPUs of a core).
 # It would be set to 1 by the driver if it's able to set up cpu affinity
 # for FCP I/Os through Work Queue associated with the current CPU. Otherwise,
 # roundrobin scheduling of FCP I/Os through WQs will be used.
+# It would remain set to 2 by the driver, likewise, if 2 was requested.
 */
-LPFC_ATTR_RW(fcp_io_sched, 0, 0, 1, "Determine scheduling algorithm for "
-		"issuing commands [0] - Round Robin, [1] - Current CPU");
+LPFC_ATTR_RW(fcp_io_sched, 0, 0, 2, "Determine scheduling algorithm for "
+		"issuing commands [0] - Round Robin, [1] - Current CPU, "
+		"[2] - Current CPU core");
 
 /*
 # lpfc_fcp2_no_tgt_reset: Determine bus reset behavior
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 0c7070b..3c63063 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -191,6 +191,7 @@ struct lpfc_sli_intf {
 /* Algrithmns for scheduling FCP commands to WQs */
 #define	LPFC_FCP_SCHED_ROUND_ROBIN	0
 #define	LPFC_FCP_SCHED_BY_CPU		1
+#define	LPFC_FCP_SCHED_BY_CPU_CORE	2
 
 /* Delay Multiplier constant */
 #define LPFC_DMULT_CONST       651042
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 03d1946..917351c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8703,6 +8703,7 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 {
 	int i, idx, saved_chann, used_chann, cpu, phys_id;
 	int max_phys_id, min_phys_id;
+	int max_core_id, min_core_id, core_id, prev_core_id;
 	int num_io_channel, first_cpu, chan;
 	struct lpfc_vector_map_info *cpup;
 #ifdef CONFIG_X86
@@ -8722,6 +8723,9 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 	max_phys_id = 0;
 	min_phys_id = INT_MAX;
 	phys_id = 0;
+	max_core_id = 0;
+	min_core_id = INT_MAX;
+	core_id = 0;
 	num_io_channel = 0;
 	first_cpu = LPFC_VECTOR_MAP_EMPTY;
 
@@ -8749,6 +8753,12 @@ lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 			max_phys_id = cpup->phys_id;
 		if (cpup->phys_id < min_phys_id)
 			min_phys_id = cpup->phys_id;
+
+		if (cpup->core_id > max_core_id)
+			max_core_id = cpup->core_id;
+		if (cpup->core_id < min_core_id)
+			min_core_id = cpup->core_id;
+
 		cpup++;
 	}
 
@@ -8820,6 +8830,46 @@ found:
 	}
 
 	/*
+	 * With lpfc_fcp_io_sched per core, associate IO channels with CPUs
+	 * based only on the core numbers instead of individual CPU numbers,
+	 * and ignore/overwrite already assigned values (from MSI-x vectors).
+	 */
+	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU_CORE) {
+
+		/* The IO channel used by a core */
+		chan = -1;
+
+		/* For each core, assign its (sequential) CPUs the same IO channel */
+		prev_core_id = -1;
+		for (core_id = min_core_id; core_id <= max_core_id; core_id++) {
+
+			cpup = phba->sli4_hba.cpu_map;
+			for (cpu = 0; cpu < phba->sli4_hba.num_present_cpu; cpu++, cpup++) {
+
+				if (cpup->core_id != core_id)
+					continue;
+
+				/* Round-robin on different cores */
+				if (core_id != prev_core_id) {
+					prev_core_id = core_id;
+					chan = (chan + 1) % phba->cfg_fcp_io_channel;
+				}
+
+				cpup->channel_id = chan;
+
+				/* Don't count CPUs w/ IRQ affinity hint (already counted) */
+				if (cpup->irq == LPFC_VECTOR_MAP_EMPTY)
+					num_io_channel++;
+
+				lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+						"3336 Set IO_CHANN CPU %d channel %d coreid %d\n",
+						cpu, cpup->channel_id, cpup->core_id);
+			}
+		}
+		goto out_fcp_io_sched_per_core;
+	}
+
+	/*
 	 * Finally fill in the IO channel for any remaining CPUs.
 	 * At this point, all IO channels have been assigned to a specific
 	 * MSIx vector, mapped to a specific CPU.
@@ -8891,6 +8941,7 @@ out:
 		}
 	}
 
+out_fcp_io_sched_per_core:
 	if (phba->sli4_hba.num_online_cpu != phba->sli4_hba.num_present_cpu) {
 		cpup = phba->sli4_hba.cpu_map;
 		for (idx = 0; idx < phba->sli4_hba.num_present_cpu; idx++) {
@@ -8916,7 +8967,8 @@ out:
 				vectors);
 
 	/* Enable using cpu affinity for scheduling */
-	phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_BY_CPU;
+	if (phba->cfg_fcp_io_sched != LPFC_FCP_SCHED_BY_CPU_CORE)
+		phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_BY_CPU;
 	return 1;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3bd0be6..b34276e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3881,7 +3881,8 @@ int lpfc_sli4_scmd_to_wqidx_distr(struct lpfc_hba *phba,
 		return hwq;
 	}
 
-	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU
+	if ((phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU ||
+	     phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU_CORE)
 	    && phba->cfg_fcp_io_channel > 1) {
 		cpu = smp_processor_id();
 		if (cpu < phba->sli4_hba.num_present_cpu) {
-- 
1.8.3.1

