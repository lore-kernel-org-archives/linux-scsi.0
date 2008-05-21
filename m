From: michaelc@cs.wisc.edu
Subject: [PATCH 22/25] libiscsi: fix cmds_max setting
Date: Wed, 21 May 2008 15:54:17 -0500
Message-ID: <1211403260-5487-23-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-20-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-21-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-22-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937120AbYEUUyi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:38 -0400
In-Reply-To: <1211403260-5487-22-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Drivers expect that the cmds_max value they pass to the iscsi layer
is the max scsi commands  + mgmt tasks. This patch implements that
and fixes some checks for nr cmd limits.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   49 ++++++++++++++++++++++++++++++++--------------
 include/scsi/libiscsi.h |    9 ++++---
 2 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c1af2aa..c723e60 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1893,29 +1893,48 @@ EXPORT_SYMBOL_GPL(iscsi_host_free);
  *
  * This can be used by software iscsi_transports that allocate
  * a session per scsi host.
+ *
+ * Callers should set cmds_max to the largest total numer (mgmt + scsi) of
+ * tasks they support. The iscsi layer reserves ISCSI_MGMT_CMDS_MAX tasks
+ * for nop handling and login/logout requests.
  */
 struct iscsi_cls_session *
 iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
-		    uint16_t scsi_cmds_max, int cmd_task_size,
+		    uint16_t cmds_max, int cmd_task_size,
 		    uint32_t initial_cmdsn, unsigned int id)
 {
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
-	int cmd_i, cmds_max;
-
+	int cmd_i, scsi_cmds, total_cmds = cmds_max;
 	/*
-	 * The iscsi layer needs some tasks for nop handling and tmfs.
+	 * The iscsi layer needs some tasks for nop handling and tmfs,
+	 * so the cmds_max must at least be greater than ISCSI_MGMT_CMDS_MAX
+	 * + 1 command for scsi IO.
 	 */
-	if (scsi_cmds_max < 1)
-		scsi_cmds_max = ISCSI_MGMT_CMDS_MAX;
-	if ((scsi_cmds_max + ISCSI_MGMT_CMDS_MAX) >= ISCSI_MGMT_ITT_OFFSET) {
-		printk(KERN_ERR "iscsi: invalid can_queue of %d. "
-		       "can_queue must be less than %d.\n",
-		       scsi_cmds_max,
-		       ISCSI_MGMT_ITT_OFFSET - ISCSI_MGMT_CMDS_MAX);
-		scsi_cmds_max = ISCSI_DEF_XMIT_CMDS_MAX;
+	if (total_cmds < ISCSI_TOTAL_CMDS_MIN) {
+		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
+		       "must be a power of two that is at least %d.\n",
+		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
+		return NULL;
+	}
+
+	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
+		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
+		       "must be a power of 2 less than or equal to %d.\n",
+		       cmds_max, ISCSI_TOTAL_CMDS_MAX);
+		total_cmds = ISCSI_TOTAL_CMDS_MAX;
+	}
+
+	if (!is_power_of_2(total_cmds)) {
+		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
+		       "must be a power of 2.\n", total_cmds);
+		total_cmds = rounddown_pow_of_two(total_cmds);
+		if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
+			return NULL;
+		printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
+		       total_cmds);
 	}
-	cmds_max = roundup_pow_of_two(scsi_cmds_max + ISCSI_MGMT_CMDS_MAX);
+	scsi_cmds = total_cmds - ISCSI_MGMT_CMDS_MAX;
 
 	cls_session = iscsi_alloc_session(shost, iscsit,
 					  sizeof(struct iscsi_session));
@@ -1928,8 +1947,8 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	session->fast_abort = 1;
 	session->lu_reset_timeout = 15;
 	session->abort_timeout = 10;
-	session->scsi_cmds_max = scsi_cmds_max;
-	session->cmds_max = cmds_max;
+	session->scsi_cmds_max = scsi_cmds;
+	session->cmds_max = total_cmds;
 	session->queued_cmdsn = session->cmdsn = initial_cmdsn;
 	session->exp_cmdsn = initial_cmdsn + 1;
 	session->max_cmdsn = initial_cmdsn + 1;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 21cfb1d..5bf0187 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -52,9 +52,7 @@ struct device;
 #endif
 
 #define ISCSI_DEF_XMIT_CMDS_MAX	128	/* must be power of 2 */
-#define ISCSI_MGMT_CMDS_MAX	16	/* must be power of 2 */
-
-#define ISCSI_MGMT_ITT_OFFSET	0xa00
+#define ISCSI_MGMT_CMDS_MAX	15
 
 #define ISCSI_DEF_CMD_PER_LUN		32
 #define ISCSI_MAX_CMD_PER_LUN		128
@@ -72,7 +70,10 @@ enum {
 /* Connection suspend "bit" */
 #define ISCSI_SUSPEND_BIT		1
 
-#define ISCSI_ITT_MASK			(0xfff)
+#define ISCSI_ITT_MASK			(0x1fff)
+#define ISCSI_TOTAL_CMDS_MAX		4096
+/* this must be a power of two greater than ISCSI_MGMT_CMDS_MAX */
+#define ISCSI_TOTAL_CMDS_MIN		16
 #define ISCSI_AGE_SHIFT			28
 #define ISCSI_AGE_MASK			(0xf << ISCSI_AGE_SHIFT)
 
-- 
1.5.4.1

