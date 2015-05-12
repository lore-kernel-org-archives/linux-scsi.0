From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 02/12] target: Convert REPORT_LUN + MODE_SENSE to RCU reader
Date: Tue, 12 May 2015 09:25:26 +0000
Message-ID: <1431422736-29125-3-git-send-email-nab@daterainc.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts SPC emulation for REPORT_LUN + MODE_SENSE to use
RCU read locks for se_node_acl->lun_entry_hlist access.

Also convert the MODE_SENSE special case in pscsi_transport_complete()

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c | 17 +++++++++++++++--
 drivers/target/target_core_spc.c   | 27 ++++++++++++++++++---------
 2 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f6c954c..9fcdcc0 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -47,6 +47,7 @@
 #include <target/target_core_backend_configfs.h>
 
 #include "target_core_alua.h"
+#include "target_core_internal.h"
 #include "target_core_pscsi.h"
 
 #define ISPRINT(a)  ((a >= ' ') && (a <= '~'))
@@ -634,12 +635,24 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
 	 * Hack to make sure that Write-Protect modepage is set if R/O mode is
 	 * forced.
 	 */
-	if (!cmd->se_deve || !cmd->data_length)
+	if (!cmd->data_length)
 		goto after_mode_sense;
 
 	if (((cdb[0] == MODE_SENSE) || (cdb[0] == MODE_SENSE_10)) &&
 	     (status_byte(result) << 1) == SAM_STAT_GOOD) {
-		if (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
+		struct se_session *sess = cmd->se_sess;
+		struct se_node_acl *nacl = sess->se_node_acl;
+		struct se_dev_entry *deve;
+		u32 lun = cmd->orig_fe_lun;
+		bool read_only = true;
+
+		rcu_read_lock();
+		deve = target_nacl_find_deve(nacl, lun);
+		if (deve)
+			read_only = (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY);
+		rcu_read_unlock();
+
+		if (read_only) {
 			unsigned char *buf;
 
 			buf = transport_kmap_data_sg(cmd);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 78c0b40..d256243 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -969,6 +969,8 @@ static int spc_modesense_long_blockdesc(unsigned char *buf, u64 blocks, u32 bloc
 static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
+	struct se_dev_entry *deve;
+	struct se_session *sess = cmd->se_sess;
 	char *cdb = cmd->t_task_cdb;
 	unsigned char buf[SE_MODE_PAGE_BUF], *rbuf;
 	int type = dev->transport->get_device_type(dev);
@@ -981,6 +983,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	int length = 0;
 	int ret;
 	int i;
+	bool read_only = true;
 
 	memset(buf, 0, SE_MODE_PAGE_BUF);
 
@@ -990,10 +993,14 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	 */
 	length = ten ? 3 : 2;
 
+	rcu_read_lock();
+	deve = target_nacl_find_deve(sess->se_node_acl, cmd->orig_fe_lun);
+	if (deve)
+		read_only = (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY);
+	rcu_read_unlock();
+
 	/* DEVICE-SPECIFIC PARAMETER */
-	if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
-	    (cmd->se_deve &&
-	     (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
+	if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) || read_only)
 		spc_modesense_write_protect(&buf[length], type);
 
 	/*
@@ -1211,8 +1218,9 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 {
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
+	struct se_node_acl *nacl = sess->se_node_acl;
 	unsigned char *buf;
-	u32 lun_count = 0, offset = 8, i;
+	u32 lun_count = 0, offset = 8, mapped_lun;
 
 	if (cmd->data_length < 16) {
 		pr_warn("REPORT LUNS allocation length %u too small\n",
@@ -1235,11 +1243,12 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		goto done;
 	}
 
-	spin_lock_irq(&sess->se_node_acl->device_list_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = sess->se_node_acl->device_list[i];
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
 		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
 			continue;
+
+		mapped_lun = deve->mapped_lun;
 		/*
 		 * We determine the correct LUN LIST LENGTH even once we
 		 * have reached the initial allocation length.
@@ -1249,10 +1258,10 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		if ((offset + 8) > cmd->data_length)
 			continue;
 
-		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
+		int_to_scsilun(mapped_lun, (struct scsi_lun *)&buf[offset]);
 		offset += 8;
 	}
-	spin_unlock_irq(&sess->se_node_acl->device_list_lock);
+	rcu_read_unlock();
 
 	/*
 	 * See SPC3 r07, page 159.
-- 
1.9.1
