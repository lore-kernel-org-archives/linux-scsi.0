From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 3/5] BNX2I - update CQ arming algorith for 5771x
 chipsets
Date: Mon, 7 Dec 2009 11:40:18 -0800
Message-ID: <1260214818.31468.98.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1438 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbZLGTkU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 14:40:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, mchan@broadcom.com, poswald@novell.com


    * Only affects 5771x (10G chipsets) devices
    * This is an optimized CQ arming algoritm which takes into account
      the number of outstanding tasks

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i.h      |    1 +
 drivers/scsi/bnx2i/bnx2i_hwi.c  |   36 +++++++++++++++++++++++++++---------
 drivers/scsi/bnx2i/bnx2i_init.c |    4 ++++
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i.h b/drivers/scsi/bnx2i/bnx2i.h
index 2b973f3..6cf9dc3 100644
--- a/drivers/scsi/bnx2i/bnx2i.h
+++ b/drivers/scsi/bnx2i/bnx2i.h
@@ -684,6 +684,7 @@ extern unsigned int error_mask1, error_mask2;
 extern u64 iscsi_error_mask;
 extern unsigned int en_tcp_dack;
 extern unsigned int event_coal_div;
+extern unsigned int event_coal_min;
 
 extern struct scsi_transport_template *bnx2i_scsi_xport_template;
 extern struct iscsi_transport bnx2i_iscsi_transport;
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 5c8d763..57f4ca9 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -133,21 +133,39 @@ void bnx2i_arm_cq_event_coalescing(struct bnx2i_endpoint *ep, u8 action)
 {
 	struct bnx2i_5771x_cq_db *cq_db;
 	u16 cq_index;
+	u16 next_index;
+	u32 num_active_cmds;
 
+
+	/* Coalesce CQ entries only on 10G devices */
 	if (!test_bit(BNX2I_NX2_DEV_57710, &ep->hba->cnic_dev_type))
 		return;
 
+	/* Do not update CQ DB multiple times before firmware writes
+	 * '0xFFFF' to CQDB->SQN field. Deviation may cause spurious
+	 * interrupts and other unwanted results
+	 */
+	cq_db = (struct bnx2i_5771x_cq_db *) ep->qp.cq_pgtbl_virt;
+	if (cq_db->sqn[0] && cq_db->sqn[0] != 0xFFFF)
+		return;
+
 	if (action == CNIC_ARM_CQE) {
-		cq_index = ep->qp.cqe_exp_seq_sn +
-			   ep->num_active_cmds / event_coal_div;
-		cq_index %= (ep->qp.cqe_size * 2 + 1);
-		if (!cq_index) {
+		num_active_cmds = ep->num_active_cmds;
+		if (num_active_cmds <= event_coal_min)
+			next_index = 1;
+		else
+			next_index = event_coal_min +
+				(num_active_cmds - event_coal_min) / event_coal_div;
+		if (!next_index)
+			next_index = 1;
+		cq_index = ep->qp.cqe_exp_seq_sn + next_index - 1;
+		if (cq_index > ep->qp.cqe_size * 2)
+			cq_index -= ep->qp.cqe_size * 2;
+		if (!cq_index)
 			cq_index = 1;
-			cq_db = (struct bnx2i_5771x_cq_db *)
-					ep->qp.cq_pgtbl_virt;
-			cq_db->sqn[0] = cq_index;
-		}
-	}
+
+		cq_db->sqn[0] = cq_index;
+        }
 }
 
 
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index dc6b56c..ad551c5 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -32,6 +32,10 @@ MODULE_VERSION(DRV_MODULE_VERSION);
 
 static DEFINE_MUTEX(bnx2i_dev_lock);
 
+unsigned int event_coal_min = 24;
+module_param(event_coal_min, int, 0664);
+MODULE_PARM_DESC(event_coal_min, "Event Coalescing Minimum Commands");
+
 unsigned int event_coal_div = 1;
 module_param(event_coal_div, int, 0664);
 MODULE_PARM_DESC(event_coal_div, "Event Coalescing Divide Factor");
-- 
1.6.5.1




