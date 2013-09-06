From: James Smart <james.smart@emulex.com>
Subject: [PATCH 10/18] lpfc 8.3.42: Fix crash on driver load due to cpu
 affinity logic
Date: Fri, 6 Sep 2013 12:20:36 -0400
Message-ID: <1378484436.14051.29.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:49797 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab3IFQVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:21:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix crash on driver load due to cpu affinity logic


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |    5 ++++-
 lpfc_init.c |   28 +++++++++++++++++++++++-----
 2 files changed, 27 insertions(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2013-09-06 10:58:19.799132439 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2013-09-06 10:58:46.749133052 -0400
@@ -4013,8 +4013,11 @@ LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0
 # For [0], FCP commands are issued to Work Queues ina round robin fashion.
 # For [1], FCP commands are issued to a Work Queue associated with the
 #          current CPU.
+# It would be set to 1 by the driver if it's able to set up cpu affinity
+# for FCP I/Os through Work Queue associated with the current CPU. Otherwise,
+# roundrobin scheduling of FCP I/Os through WQs will be used.
 */
-LPFC_ATTR_RW(fcp_io_sched, 0, 0, 1, "Determine scheduling algrithmn for "
+LPFC_ATTR_RW(fcp_io_sched, 0, 0, 1, "Determine scheduling algorithm for "
 		"issuing commands [0] - Round Robin, [1] - Current CPU");
 
 /*
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:58:19.639132435 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:58:46.769133053 -0400
@@ -8399,7 +8399,8 @@ static int
 lpfc_sli4_set_affinity(struct lpfc_hba *phba, int vectors)
 {
 	int i, idx, saved_chann, used_chann, cpu, phys_id;
-	int max_phys_id, num_io_channel, first_cpu;
+	int max_phys_id, min_phys_id;
+	int num_io_channel, first_cpu, chan;
 	struct lpfc_vector_map_info *cpup;
 #ifdef CONFIG_X86
 	struct cpuinfo_x86 *cpuinfo;
@@ -8417,6 +8418,7 @@ lpfc_sli4_set_affinity(struct lpfc_hba *
 		phba->sli4_hba.num_present_cpu));
 
 	max_phys_id = 0;
+	min_phys_id = 0xff;
 	phys_id = 0;
 	num_io_channel = 0;
 	first_cpu = LPFC_VECTOR_MAP_EMPTY;
@@ -8440,9 +8442,12 @@ lpfc_sli4_set_affinity(struct lpfc_hba *
 
 		if (cpup->phys_id > max_phys_id)
 			max_phys_id = cpup->phys_id;
+		if (cpup->phys_id < min_phys_id)
+			min_phys_id = cpup->phys_id;
 		cpup++;
 	}
 
+	phys_id = min_phys_id;
 	/* Now associate the HBA vectors with specific CPUs */
 	for (idx = 0; idx < vectors; idx++) {
 		cpup = phba->sli4_hba.cpu_map;
@@ -8453,13 +8458,25 @@ lpfc_sli4_set_affinity(struct lpfc_hba *
 			for (i = 1; i < max_phys_id; i++) {
 				phys_id++;
 				if (phys_id > max_phys_id)
-					phys_id = 0;
+					phys_id = min_phys_id;
 				cpu = lpfc_find_next_cpu(phba, phys_id);
 				if (cpu == LPFC_VECTOR_MAP_EMPTY)
 					continue;
 				goto found;
 			}
 
+			/* Use round robin for scheduling */
+			phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_ROUND_ROBIN;
+			chan = 0;
+			cpup = phba->sli4_hba.cpu_map;
+			for (i = 0; i < phba->sli4_hba.num_present_cpu; i++) {
+				cpup->channel_id = chan;
+				cpup++;
+				chan++;
+				if (chan >= phba->cfg_fcp_io_channel)
+					chan = 0;
+			}
+
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"3329 Cannot set affinity:"
 					"Error mapping vector %d (%d)\n",
@@ -8497,7 +8514,7 @@ found:
 		/* Spread vector mapping across multple physical CPU nodes */
 		phys_id++;
 		if (phys_id > max_phys_id)
-			phys_id = 0;
+			phys_id = min_phys_id;
 	}
 
 	/*
@@ -8507,7 +8524,7 @@ found:
 	 * Base the remaining IO channel assigned, to IO channels already
 	 * assigned to other CPUs on the same phys_id.
 	 */
-	for (i = 0; i <= max_phys_id; i++) {
+	for (i = min_phys_id; i <= max_phys_id; i++) {
 		/*
 		 * If there are no io channels already mapped to
 		 * this phys_id, just round robin thru the io_channels.
@@ -8589,10 +8606,11 @@ out:
 	if (num_io_channel != phba->sli4_hba.num_present_cpu)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3333 Set affinity mismatch:"
-				"%d chann != %d cpus: %d vactors\n",
+				"%d chann != %d cpus: %d vectors\n",
 				num_io_channel, phba->sli4_hba.num_present_cpu,
 				vectors);
 
+	/* Enable using cpu affinity for scheduling */
 	phba->cfg_fcp_io_sched = LPFC_FCP_SCHED_BY_CPU;
 	return 1;
 }



