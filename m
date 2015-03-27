From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 06/22] target/spc: Convert REPORT_LUN + MODE_SENSE to RCU reader
Date: Fri, 27 Mar 2015 08:04:56 +0000
Message-ID: <1427443512-8925-7-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts SPC emulation for REPORT_LUN + MODE_SENSE to use
RCU read path macros for se_node_acl->lun_entry_hlist[] access.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_spc.c  | 28 ++++++++++++++++++----------
 include/target/target_core_base.h |  1 -
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 5b6a0af..12cb045 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -986,6 +986,8 @@ static int spc_modesense_long_blockdesc(unsigned char *buf, u64 blocks, u32 bloc
 static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
+	struct se_dev_entry *deve;
+	struct se_session *sess = cmd->se_sess;
 	char *cdb = cmd->t_task_cdb;
 	unsigned char buf[SE_MODE_PAGE_BUF], *rbuf;
 	int type = dev->transport->get_device_type(dev);
@@ -998,6 +1000,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	int length = 0;
 	int ret;
 	int i;
+	bool read_only;
 
 	memset(buf, 0, SE_MODE_PAGE_BUF);
 
@@ -1007,10 +1010,13 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	 */
 	length = ten ? 3 : 2;
 
+	rcu_read_lock();
+	deve = rcu_dereference(sess->se_node_acl->lun_entry_hlist[cmd->orig_fe_lun]);
+	read_only = (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY);
+	rcu_read_unlock();
+
 	/* DEVICE-SPECIFIC PARAMETER */
-	if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
-	    (cmd->se_deve &&
-	     (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
+	if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) || read_only)
 		spc_modesense_write_protect(&buf[length], type);
 
 	if ((spc_check_dev_wce(dev)) &&
@@ -1225,7 +1231,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
 	unsigned char *buf;
-	u32 lun_count = 0, offset = 8, i;
+	u32 lun_count = 0, offset = 8, i, mapped_lun;
 
 	if (cmd->data_length < 16) {
 		pr_warn("REPORT LUNS allocation length %u too small\n",
@@ -1248,11 +1254,15 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		goto done;
 	}
 
-	spin_lock_irq(&sess->se_node_acl->device_list_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = sess->se_node_acl->device_list[i];
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+		rcu_read_lock();
+		deve = rcu_dereference(sess->se_node_acl->lun_entry_hlist[i]);
+		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)) {
+			rcu_read_unlock();
 			continue;
+		}
+		mapped_lun = deve->mapped_lun;
+		rcu_read_unlock();
 		/*
 		 * We determine the correct LUN LIST LENGTH even once we
 		 * have reached the initial allocation length.
@@ -1262,11 +1272,9 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		if ((offset + 8) > cmd->data_length)
 			continue;
 
-		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
+		int_to_scsilun(mapped_lun, (struct scsi_lun *)&buf[offset]);
 		offset += 8;
 	}
-	spin_unlock_irq(&sess->se_node_acl->device_list_lock);
-
 	/*
 	 * See SPC3 r07, page 159.
 	 */
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 06ecd7b..a826e6f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -512,7 +512,6 @@ struct se_cmd {
 	struct list_head	se_delayed_node;
 	struct list_head	se_qf_node;
 	struct se_device      *se_dev;
-	struct se_dev_entry   *se_deve;
 	struct se_lun		*se_lun;
 	/* Only used for internal passthrough and legacy TCM fabric modules */
 	struct se_session	*se_sess;
-- 
1.9.1
