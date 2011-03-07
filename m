From: "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH 3/6] [SCSI] bnx2fc: common free list for cleanup
 commands
Date: Mon, 7 Mar 2011 15:42:26 -0800
Message-ID: <1299541349-2438-3-git-send-email-mchan@broadcom.com>
References: <1299541349-2438-1-git-send-email-mchan@broadcom.com>
 <1299541349-2438-2-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1204 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1CHAgj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 19:36:39 -0500
In-Reply-To: <1299541349-2438-2-git-send-email-mchan@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, michaelc@cs.wisc.edu, bprakash@broadcom.com, nsujir@broadcom.com, Michael Chan <mchan@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Cleanup commands are issued to the firmware to cleanup any stuck ios
that are supposed to be implicitly aborted. In the worst case we can
have all scsi ios filling up the free_list and we may not be able to
allocate cleanup tasks. So the driver has to reserve free_list entries
to be able to allocate the cleanup tasks. This reserve free_list common
to all cpus is allocated as one additional entry in the per cpu
free_lists.

In bnx2fc_cmd_alloc(), there is a related fix to use get_cpu() for the
free_list_index.  This will prevent using the wrong index if the CPU
is preempted.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |   13 ++++---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |   73 ++++++++++++++++++++++++-------------
 3 files changed, 57 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index df2fc09..52057fa 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -85,6 +85,8 @@
 #define BNX2FC_NUM_MAX_SESS_LOG	(ilog2(BNX2FC_NUM_MAX_SESS))
 
 #define BNX2FC_MAX_OUTSTANDING_CMNDS	4096
+#define BNX2FC_CAN_QUEUE		(BNX2FC_MAX_OUTSTANDING_CMNDS / 2)
+#define BNX2FC_ELSTM_XIDS		BNX2FC_CAN_QUEUE
 #define BNX2FC_MIN_PAYLOAD		256
 #define BNX2FC_MAX_PAYLOAD		2048
 
@@ -98,7 +100,8 @@
 #define BNX2FC_CONFQ_WQE_SIZE		(sizeof(struct fcoe_confqe))
 #define BNX2FC_5771X_DB_PAGE_SIZE	128
 
-#define BNX2FC_MAX_TASKS		BNX2FC_MAX_OUTSTANDING_CMNDS
+#define BNX2FC_MAX_TASKS		\
+			     (BNX2FC_MAX_OUTSTANDING_CMNDS + BNX2FC_ELSTM_XIDS)
 #define BNX2FC_TASK_SIZE		128
 #define	BNX2FC_TASKS_PER_PAGE		(PAGE_SIZE/BNX2FC_TASK_SIZE)
 #define BNX2FC_TASK_CTX_ARR_SZ		(BNX2FC_MAX_TASKS/BNX2FC_TASKS_PER_PAGE)
@@ -112,10 +115,10 @@
 #define BNX2FC_WRITE			(1 << 0)
 
 #define BNX2FC_MIN_XID			0
-#define BNX2FC_MAX_XID			(BNX2FC_MAX_OUTSTANDING_CMNDS - 1)
-#define FCOE_MIN_XID			(BNX2FC_MAX_OUTSTANDING_CMNDS)
-#define FCOE_MAX_XID		\
-			(BNX2FC_MAX_OUTSTANDING_CMNDS + (nr_cpu_ids * 256))
+#define BNX2FC_MAX_XID			\
+			(BNX2FC_MAX_OUTSTANDING_CMNDS + BNX2FC_ELSTM_XIDS - 1)
+#define FCOE_MIN_XID			(BNX2FC_MAX_XID + 1)
+#define FCOE_MAX_XID			(FCOE_MIN_XID + 4095)
 #define BNX2FC_MAX_LUN			0xFFFF
 #define BNX2FC_MAX_FCP_TGT		256
 #define BNX2FC_MAX_CMD_LEN		16
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index cfb49b1..a626920 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2501,7 +2501,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.change_queue_type	= fc_change_queue_type,
 	.this_id		= -1,
 	.cmd_per_lun		= 3,
-	.can_queue		= (BNX2FC_MAX_OUTSTANDING_CMNDS/2),
+	.can_queue		= BNX2FC_CAN_QUEUE,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
 	.max_sectors		= 512,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 0f1dd23..d3fc302 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -11,6 +11,9 @@
  */
 
 #include "bnx2fc.h"
+
+#define RESERVE_FREE_LIST_INDEX num_possible_cpus()
+
 static int bnx2fc_split_bd(struct bnx2fc_cmd *io_req, u64 addr, int sg_len,
 			   int bd_index);
 static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req);
@@ -242,8 +245,9 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba,
 	u32 mem_size;
 	u16 xid;
 	int i;
-	int num_ios;
+	int num_ios, num_pri_ios;
 	size_t bd_tbl_sz;
+	int arr_sz = num_possible_cpus() + 1;
 
 	if (max_xid <= min_xid || max_xid == FC_XID_UNKNOWN) {
 		printk(KERN_ERR PFX "cmd_mgr_alloc: Invalid min_xid 0x%x \
@@ -263,14 +267,14 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba,
 	}
 
 	cmgr->free_list = kzalloc(sizeof(*cmgr->free_list) *
-				  num_possible_cpus(), GFP_KERNEL);
+				  arr_sz, GFP_KERNEL);
 	if (!cmgr->free_list) {
 		printk(KERN_ERR PFX "failed to alloc free_list\n");
 		goto mem_err;
 	}
 
 	cmgr->free_list_lock = kzalloc(sizeof(*cmgr->free_list_lock) *
-				       num_possible_cpus(), GFP_KERNEL);
+				       arr_sz, GFP_KERNEL);
 	if (!cmgr->free_list_lock) {
 		printk(KERN_ERR PFX "failed to alloc free_list_lock\n");
 		goto mem_err;
@@ -279,13 +283,18 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba,
 	cmgr->hba = hba;
 	cmgr->cmds = (struct bnx2fc_cmd **)(cmgr + 1);
 
-	for (i = 0; i < num_possible_cpus(); i++)  {
+	for (i = 0; i < arr_sz; i++)  {
 		INIT_LIST_HEAD(&cmgr->free_list[i]);
 		spin_lock_init(&cmgr->free_list_lock[i]);
 	}
 
-	/* Pre-allocated pool of bnx2fc_cmds */
+	/*
+	 * Pre-allocated pool of bnx2fc_cmds.
+	 * Last entry in the free list array is the free list
+	 * of slow path requests.
+	 */
 	xid = BNX2FC_MIN_XID;
+	num_pri_ios = num_ios - BNX2FC_ELSTM_XIDS;
 	for (i = 0; i < num_ios; i++) {
 		io_req = kzalloc(sizeof(*io_req), GFP_KERNEL);
 
@@ -298,11 +307,13 @@ struct bnx2fc_cmd_mgr *bnx2fc_cmd_mgr_alloc(struct bnx2fc_hba *hba,
 		INIT_DELAYED_WORK(&io_req->timeout_work, bnx2fc_cmd_timeout);
 
 		io_req->xid = xid++;
-		if (io_req->xid >= BNX2FC_MAX_OUTSTANDING_CMNDS)
-			printk(KERN_ERR PFX "ERROR allocating xids - 0x%x\n",
-				io_req->xid);
-		list_add_tail(&io_req->link,
-			&cmgr->free_list[io_req->xid % num_possible_cpus()]);
+		if (i < num_pri_ios)
+			list_add_tail(&io_req->link,
+				&cmgr->free_list[io_req->xid %
+						 num_possible_cpus()]);
+		else
+			list_add_tail(&io_req->link,
+				&cmgr->free_list[num_possible_cpus()]);
 		io_req++;
 	}
 
@@ -389,7 +400,7 @@ free_cmd_pool:
 	if (!cmgr->free_list)
 		goto free_cmgr;
 
-	for (i = 0; i < num_possible_cpus(); i++)  {
+	for (i = 0; i < num_possible_cpus() + 1; i++)  {
 		struct list_head *list;
 		struct list_head *tmp;
 
@@ -413,6 +424,7 @@ struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type)
 	struct bnx2fc_cmd *io_req;
 	struct list_head *listp;
 	struct io_bdt *bd_tbl;
+	int index = RESERVE_FREE_LIST_INDEX;
 	u32 max_sqes;
 	u16 xid;
 
@@ -432,26 +444,26 @@ struct bnx2fc_cmd *bnx2fc_elstm_alloc(struct bnx2fc_rport *tgt, int type)
 	 * NOTE: Free list insertions and deletions are protected with
 	 * cmgr lock
 	 */
-	spin_lock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
-	if ((list_empty(&(cmd_mgr->free_list[smp_processor_id()]))) ||
+	spin_lock_bh(&cmd_mgr->free_list_lock[index]);
+	if ((list_empty(&(cmd_mgr->free_list[index]))) ||
 	    (tgt->num_active_ios.counter  >= max_sqes)) {
 		BNX2FC_TGT_DBG(tgt, "No free els_tm cmds available "
 			"ios(%d):sqes(%d)\n",
 			tgt->num_active_ios.counter, tgt->max_sqes);
-		if (list_empty(&(cmd_mgr->free_list[smp_processor_id()])))
+		if (list_empty(&(cmd_mgr->free_list[index])))
 			printk(KERN_ERR PFX "elstm_alloc: list_empty\n");
-		spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+		spin_unlock_bh(&cmd_mgr->free_list_lock[index]);
 		return NULL;
 	}
 
 	listp = (struct list_head *)
-			cmd_mgr->free_list[smp_processor_id()].next;
+			cmd_mgr->free_list[index].next;
 	list_del_init(listp);
 	io_req = (struct bnx2fc_cmd *) listp;
 	xid = io_req->xid;
 	cmd_mgr->cmds[xid] = io_req;
 	atomic_inc(&tgt->num_active_ios);
-	spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+	spin_unlock_bh(&cmd_mgr->free_list_lock[index]);
 
 	INIT_LIST_HEAD(&io_req->link);
 
@@ -479,27 +491,30 @@ static struct bnx2fc_cmd *bnx2fc_cmd_alloc(struct bnx2fc_rport *tgt)
 	struct io_bdt *bd_tbl;
 	u32 max_sqes;
 	u16 xid;
+	int index = get_cpu();
 
 	max_sqes = BNX2FC_SCSI_MAX_SQES;
 	/*
 	 * NOTE: Free list insertions and deletions are protected with
 	 * cmgr lock
 	 */
-	spin_lock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
-	if ((list_empty(&cmd_mgr->free_list[smp_processor_id()])) ||
+	spin_lock_bh(&cmd_mgr->free_list_lock[index]);
+	if ((list_empty(&cmd_mgr->free_list[index])) ||
 	    (tgt->num_active_ios.counter  >= max_sqes)) {
-		spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+		spin_unlock_bh(&cmd_mgr->free_list_lock[index]);
+		put_cpu();
 		return NULL;
 	}
 
 	listp = (struct list_head *)
-		cmd_mgr->free_list[smp_processor_id()].next;
+		cmd_mgr->free_list[index].next;
 	list_del_init(listp);
 	io_req = (struct bnx2fc_cmd *) listp;
 	xid = io_req->xid;
 	cmd_mgr->cmds[xid] = io_req;
 	atomic_inc(&tgt->num_active_ios);
-	spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+	spin_unlock_bh(&cmd_mgr->free_list_lock[index]);
+	put_cpu();
 
 	INIT_LIST_HEAD(&io_req->link);
 
@@ -522,8 +537,15 @@ void bnx2fc_cmd_release(struct kref *ref)
 	struct bnx2fc_cmd *io_req = container_of(ref,
 						struct bnx2fc_cmd, refcount);
 	struct bnx2fc_cmd_mgr *cmd_mgr = io_req->cmd_mgr;
+	int index;
+
+	if (io_req->cmd_type == BNX2FC_SCSI_CMD)
+		index = io_req->xid % num_possible_cpus();
+	else
+		index = RESERVE_FREE_LIST_INDEX;
 
-	spin_lock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+
+	spin_lock_bh(&cmd_mgr->free_list_lock[index]);
 	if (io_req->cmd_type != BNX2FC_SCSI_CMD)
 		bnx2fc_free_mp_resc(io_req);
 	cmd_mgr->cmds[io_req->xid] = NULL;
@@ -531,9 +553,10 @@ void bnx2fc_cmd_release(struct kref *ref)
 	list_del_init(&io_req->link);
 	/* Add it to the free list */
 	list_add(&io_req->link,
-			&cmd_mgr->free_list[smp_processor_id()]);
+			&cmd_mgr->free_list[index]);
 	atomic_dec(&io_req->tgt->num_active_ios);
-	spin_unlock_bh(&cmd_mgr->free_list_lock[smp_processor_id()]);
+	spin_unlock_bh(&cmd_mgr->free_list_lock[index]);
+
 }
 
 static void bnx2fc_free_mp_resc(struct bnx2fc_cmd *io_req)
-- 
1.6.4.GIT


