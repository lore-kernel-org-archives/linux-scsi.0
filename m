From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH v2 07/12] fcoe: Amends previous patch,
 Round-robin based selection of CPU for post processing of incoming
 request for FCoE target
Date: Mon, 20 Jun 2011 16:59:25 -0700
Message-ID: <20110620235925.1777.6605.stgit@localhost6.localdomain6>
References: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:42195 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab1FTX71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2011 19:59:27 -0400
In-Reply-To: <20110620235848.1777.5168.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kiran Patil <kiran.patil@intel.com>

From: Kiran Patil <kiran.patil@intel.com>

Problem: Selection of RX queue on target is based on RX-ID. FCoE used 8 Net Rx queues.
HW post the packets based on rx_id % num_rx_queue. Due to this has based filtering,
only one CPU is busy servicing incoming request including post-processing of incoming
request. This is gating factor because
1. Only one CPU is utilized 100% while others CPUs are not used at all.
2. CPU which received request assign "sequence' by selecting exchange from
   per CPU pool (num_ddp_context / num_online_cpus, approxi.). Due to which if
   if rate of incoming request is higher than rate of servicing request, existing
   code path end of sending "BUSY" response (SAM_STAT_BUSY because unable to
   allocate exchange).

Fix: Fan-out incoming request to all other CPUs excluding the CPU which is receiving
all incoiming request. This path also addresses, selecting same CPU based on rx_id
from received frame for completion of the request such as "releasing exchange
to the per CPU Pool". This fix is applicable for FCoE target since initiator
code path already takes care of selecting CPU to complete post-processing of request
once OX_ID is assigned.

Notes: N/A

Dependencines: N/A

Signed-off-by: Kiran Patil <kiran.patil@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index da73115..522fbaa 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1358,7 +1358,11 @@ int fcoe_rcv(struct sk_buff *skb, struct net_device *netdev,
 			do {
 				cpu = fcoe_select_cpu(cpu);
 			} while (!cpu_online(cpu));
-		}
+		} else  if ((fh->fh_type == FC_TYPE_FCP) &&
+			    (ntohs(fh->fh_rx_id) != FC_XID_UNKNOWN)) {
+			cpu = ntohs(fh->fh_rx_id) & fc_cpu_mask;
+		} else
+			cpu = smp_processor_id();
 	}
 	fps = &per_cpu(fcoe_percpu, cpu);
 	spin_lock_bh(&fps->fcoe_rx_list.lock);

