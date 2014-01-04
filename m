From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] [SCSI] mpt3sas: Rework the MSI-X grouping code
Date: Fri,  3 Jan 2014 19:16:56 -0500
Message-ID: <1388794616-23560-3-git-send-email-martin.petersen@oracle.com>
References: <1388794616-23560-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42757 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaADARb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2014 19:17:31 -0500
In-Reply-To: <1388794616-23560-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

On systems with a non power-of-two CPU count the existing MSI-X grouping
code failed to distribute interrupts correctly. Rework the code to
handle arbitrary processor counts.

Also remove the hardcoded upper limit on the number of processors so we
can boot on large systems.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 73 +++++++++++--------------------------
 1 file changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index fa785062e97b..35b95e61acd5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1624,66 +1624,35 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 static void
 _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct adapter_reply_queue *reply_q;
-	int cpu_id;
-	int cpu_grouping, loop, grouping, grouping_mod;
-	int reply_queue;
+	unsigned int cpu, nr_cpus, nr_msix, index = 0;
 
 	if (!_base_is_controller_msix_enabled(ioc))
 		return;
 
 	memset(ioc->cpu_msix_table, 0, ioc->cpu_msix_table_sz);
 
-	/* NUMA Hardware bug workaround - drop to less reply queues */
-	if (ioc->reply_queue_count > ioc->facts.MaxMSIxVectors) {
-		ioc->reply_queue_count = ioc->facts.MaxMSIxVectors;
-		reply_queue = 0;
-		list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-			reply_q->msix_index = reply_queue;
-			if (++reply_queue == ioc->reply_queue_count)
-				reply_queue = 0;
-		}
-	}
+	nr_cpus = num_online_cpus();
+	nr_msix = ioc->reply_queue_count = min(ioc->reply_queue_count,
+					       ioc->facts.MaxMSIxVectors);
+	if (!nr_msix)
+		return;
 
-	/* when there are more cpus than available msix vectors,
-	 * then group cpus togeather on same irq
-	 */
-	if (ioc->cpu_count > ioc->msix_vector_count) {
-		grouping = ioc->cpu_count / ioc->msix_vector_count;
-		grouping_mod = ioc->cpu_count % ioc->msix_vector_count;
-		if (grouping < 2 || (grouping == 2 && !grouping_mod))
-			cpu_grouping = 2;
-		else if (grouping < 4 || (grouping == 4 && !grouping_mod))
-			cpu_grouping = 4;
-		else if (grouping < 8 || (grouping == 8 && !grouping_mod))
-			cpu_grouping = 8;
-		else
-			cpu_grouping = 16;
-	} else
-		cpu_grouping = 0;
-
-	loop = 0;
-	reply_q = list_entry(ioc->reply_queue_list.next,
-	     struct adapter_reply_queue, list);
-	for_each_online_cpu(cpu_id) {
-		if (!cpu_grouping) {
-			ioc->cpu_msix_table[cpu_id] = reply_q->msix_index;
-			reply_q = list_entry(reply_q->list.next,
-			    struct adapter_reply_queue, list);
-		} else {
-			if (loop < cpu_grouping) {
-				ioc->cpu_msix_table[cpu_id] =
-				    reply_q->msix_index;
-				loop++;
-			} else {
-				reply_q = list_entry(reply_q->list.next,
-				    struct adapter_reply_queue, list);
-				ioc->cpu_msix_table[cpu_id] =
-				    reply_q->msix_index;
-				loop = 1;
-			}
+	cpu = cpumask_first(cpu_online_mask);
+
+	do {
+		unsigned int i, group = nr_cpus / nr_msix;
+
+		if (index < nr_cpus % nr_msix)
+			group++;
+
+		for (i = 0 ; i < group ; i++) {
+			ioc->cpu_msix_table[cpu] = index;
+			cpu = cpumask_next(cpu, cpu_online_mask);
 		}
-	}
+
+		index++;
+
+	} while (cpu < nr_cpus);
 }
 
 /**
-- 
1.8.3.1

