From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 10/10] fcoe: cleanup cpu selection for incoming requests
Date: Wed, 27 Jul 2011 15:11:10 -0700
Message-ID: <20110727221110.23675.85595.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17238 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab1G0WLL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:11:11 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Kiran Patil <kiran.patil@intel.com>, Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Cleanup to:-

- have selection for all types of frames, not just FCP.
- remove redundant cpu_online check once fcoe_select_cpu called
  as this is not required since later code flow check for offlined
  cpu.
- Simplify fcoe_select_cpu() by removing unnecessary checks to
  skip curr_cpu, this also fixes possibly infinite loop in case
  of curr_cpu is the only cpu while iterating in the loop.

This cleanup mainly applies to target as incoming request are
mostly for target, therefore Kiran has verified the patch
with target also.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Kiran Patil <kiran.patil@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   43 +++++++++++++------------------------------
 1 files changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 528b86b..ba710e3 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1270,30 +1270,20 @@ static int fcoe_cpu_callback(struct notifier_block *nfb,
 /**
  * fcoe_select_cpu() - Selects CPU to handle post-processing of incoming
  *			command.
- * @curr_cpu:   CPU which received request
  *
- * This routine selects next CPU based on cpumask.
+ * This routine selects next CPU based on cpumask to distribute
+ * incoming requests in round robin.
  *
- * Returns: int (CPU number). Caller to verify if returned CPU is online or not.
+ * Returns: int CPU number
  */
-static unsigned int fcoe_select_cpu(unsigned int curr_cpu)
+static inline unsigned int fcoe_select_cpu(void)
 {
 	static unsigned int selected_cpu;
 
-	if (num_online_cpus() == 1)
-		return curr_cpu;
-	/*
-	 * Doing following check, to skip "curr_cpu (smp_processor_id)"
-	 * from selection of CPU is intentional. This is to avoid same CPU
-	 * doing post-processing of command. "curr_cpu" to just receive
-	 * incoming request in case where rx_id is UNKNOWN and all other
-	 * CPU to actually process the command(s)
-	 */
-	do {
-		selected_cpu = cpumask_next(selected_cpu, cpu_online_mask);
-		if (selected_cpu >= nr_cpu_ids)
-			selected_cpu = cpumask_first(cpu_online_mask);
-	} while (selected_cpu == curr_cpu);
+	selected_cpu = cpumask_next(selected_cpu, cpu_online_mask);
+	if (selected_cpu >= nr_cpu_ids)
+		selected_cpu = cpumask_first(cpu_online_mask);
+
 	return selected_cpu;
 }
 
@@ -1368,23 +1358,16 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	 * In case the incoming frame's exchange is originated from
 	 * the initiator, then received frame's exchange id is ANDed
 	 * with fc_cpu_mask bits to get the same cpu on which exchange
-	 * was originated, otherwise just use the current cpu.
+	 * was originated, otherwise select cpu using rx exchange id
+	 * or fcoe_select_cpu().
 	 */
 	if (ntoh24(fh->fh_f_ctl) & FC_FC_EX_CTX)
 		cpu = ntohs(fh->fh_ox_id) & fc_cpu_mask;
 	else {
-		cpu = smp_processor_id();
-
-		if ((fh->fh_type == FC_TYPE_FCP) &&
-		    (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN)) {
-			do {
-				cpu = fcoe_select_cpu(cpu);
-			} while (!cpu_online(cpu));
-		} else  if ((fh->fh_type == FC_TYPE_FCP) &&
-			    (ntohs(fh->fh_rx_id) != FC_XID_UNKNOWN)) {
+		if (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN)
+			cpu = fcoe_select_cpu();
+		else
 			cpu = ntohs(fh->fh_rx_id) & fc_cpu_mask;
-		} else
-			cpu = smp_processor_id();
 	}
 
 	if (cpu >= nr_cpu_ids)

