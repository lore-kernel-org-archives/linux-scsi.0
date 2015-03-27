From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 07/22] target/pscsi: Convert MODE_SENSE special case to RCU reader
Date: Fri, 27 Mar 2015 08:04:57 +0000
Message-ID: <1427443512-8925-8-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the MODE_SENSE special case in pscsi_transport_complete()
to use RCU read path macros for se_node_acl->lun_entry_hlist[] access.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_pscsi.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f6c954c..8bffcd8 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -634,12 +634,22 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
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
+		struct se_dev_entry *deve;
+		u32 lun = cmd->orig_fe_lun;
+		bool read_only;
+
+		rcu_read_lock();
+		deve = rcu_dereference(sess->se_node_acl->lun_entry_hlist[lun]);
+		read_only = (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY);
+		rcu_read_unlock();
+
+		if (read_only) {
 			unsigned char *buf;
 
 			buf = transport_kmap_data_sg(cmd);
-- 
1.9.1
