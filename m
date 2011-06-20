From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 06/12] fcoe: Round-robin based selection of CPU for
 post-processing of incoming commands
Date: Mon, 20 Jun 2011 16:59:20 -0700
Message-ID: <20110620235920.1777.93491.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49618 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208Ab1FTX7U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:20 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Problem: Earlier mechanism of selection of CPU was, to select the same CPU
which has received incoming request. Hence in case of rx_id = 0xFFFF,
request was always posted to same NetRx queue, hence only 1 CPU is utilized
for handling the command. It was also causing problem of "running out of
exchanges from per CPU pool of exchanges (in case of DDP offload)

Fix: Implemented new algo. to select CPU for post-processing of incoming commands
when rx_id is unknown. This is simple Round robin algo. for CPU selection.

Notes/Dependencies: N/A

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 6378c58..da73115 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1245,6 +1245,36 @@ static int fcoe_cpu_callback(struct notifier_block *nfb,
 }
 
 /**
+ * fcoe_select_cpu() - Selects CPU to handle post-processing of incoming
+ *			command.
+ * @curr_cpu:   CPU which received request
+ *
+ * This routine selects next CPU based on cpumask.
+ *
+ * Returns: int (CPU number). Caller to verify if returned CPU is online or not.
+ */
+static unsigned int fcoe_select_cpu(unsigned int curr_cpu)
+{
+	static unsigned int selected_cpu;
+
+	if (num_online_cpus() == 1)
+		return curr_cpu;
+	/*
+	 * Doing following check, to skip "curr_cpu (smp_processor_id)"
+	 * from selection of CPU is intentional. This is to avoid same CPU
+	 * doing post-processing of command. "curr_cpu" to just receive
+	 * incoming request in case where rx_id is UNKNOWN and all other
+	 * CPU to actually process the command(s)
+	 */
+	do {
+		selected_cpu = cpumask_next(selected_cpu, cpu_online_mask);
+		if (selected_cpu >= nr_cpu_ids)
+			selected_cpu = cpumask_first(cpu_online_mask);
+	} while (selected_cpu == curr_cpu);
+	return selected_cpu;
+}
+
+/**
  * fcoe_rcv() - Receive packets from a net device
  * @skb:    The received packet
  * @netdev: The net device that the packet was received on
@@ -1320,9 +1350,16 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 	 */
 	if (ntoh24(fh->fh_f_ctl) & FC_FC_EX_CTX)
 		cpu = ntohs(fh->fh_ox_id) & fc_cpu_mask;
-	else
+	else {
 		cpu = smp_processor_id();
 
+		if ((fh->fh_type == FC_TYPE_FCP) &&
+		    (ntohs(fh->fh_rx_id) == FC_XID_UNKNOWN)) {
+			do {
+				cpu = fcoe_select_cpu(cpu);
+			} while (!cpu_online(cpu));
+		}
+	}
 	fps = &per_cpu(fcoe_percpu, cpu);
 	spin_lock_bh(&fps->fcoe_rx_list.lock);
 	if (unlikely(!fps->thread)) {

