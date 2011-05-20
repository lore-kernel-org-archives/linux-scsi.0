From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/6] target: Convert REPORT_LUNs to use int_to_scsilun
Date: Thu, 19 May 2011 20:19:13 -0700
Message-ID: <1305861554-29960-6-git-send-email-nab@linux-iscsi.org>
References: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305861554-29960-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharrosh@panasas.com>, Andrew Morton <akpm@linux-foundation.org>, Martin Svec <martin.svec@zoner.cz>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts transport_core_report_lun_response() to use
drivers/scsi/scsi_scan.c:int_to_scsilun instead of using the
struct target_core_fabric_ops->pack_lun() fabric provided API vector.

It also removes the tfo->pack_lun check from target_fabric_tf_ops_check()
and removes from struct target_core_fabric_ops->pack_lun() from
target_core_fabric_ops.h, and the following mainline scsi-misc fabric
modules:

*) tcm_loop: Drop tcm_loop_pack_lun() usage
*) tcm_fc: Drop ft_pack_lun() usage

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c      |   13 -------------
 drivers/target/target_core_configfs.c   |    4 ----
 drivers/target/target_core_device.c     |   25 +++++--------------------
 drivers/target/tcm_fc/tfc_conf.c        |    8 --------
 include/target/target_core_fabric_ops.h |    1 -
 5 files changed, 5 insertions(+), 46 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index aed4e46..09681ba 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -939,18 +939,6 @@ static u16 tcm_loop_get_fabric_sense_len(void)
 	return 0;
 }
 
-static u64 tcm_loop_pack_lun(unsigned int lun)
-{
-	u64 result;
-
-	/* LSB of lun into byte 1 big-endian */
-	result = ((lun & 0xff) << 8);
-	/* use flat space addressing method */
-	result |= 0x40 | ((lun >> 8) & 0x3f);
-
-	return cpu_to_le64(result);
-}
-
 static char *tcm_loop_dump_proto_id(struct tcm_loop_hba *tl_hba)
 {
 	switch (tl_hba->tl_proto_id) {
@@ -1481,7 +1469,6 @@ static int tcm_loop_register_configfs(void)
 	fabric->tf_ops.set_fabric_sense_len = &tcm_loop_set_fabric_sense_len;
 	fabric->tf_ops.get_fabric_sense_len = &tcm_loop_get_fabric_sense_len;
 	fabric->tf_ops.is_state_remove = &tcm_loop_is_state_remove;
-	fabric->tf_ops.pack_lun = &tcm_loop_pack_lun;
 
 	tf_cg = &fabric->tf_group;
 	/*
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a5f44a6..ee6fad9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -497,10 +497,6 @@ static int target_fabric_tf_ops_check(
 		printk(KERN_ERR "Missing tfo->is_state_remove()\n");
 		return -EINVAL;
 	}
-	if (!(tfo->pack_lun)) {
-		printk(KERN_ERR "Missing tfo->pack_lun()\n");
-		return -EINVAL;
-	}
 	/*
 	 * We at least require tfo->fabric_make_wwn(), tfo->fabric_drop_wwn()
 	 * tfo->fabric_make_tpg() and tfo->fabric_drop_tpg() in
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fc10ed4..8407f9c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -38,6 +38,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
@@ -658,8 +659,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 	struct se_session *se_sess = SE_SESS(se_cmd);
 	struct se_task *se_task;
 	unsigned char *buf = (unsigned char *)T_TASK(se_cmd)->t_task_buf;
-	u32 cdb_offset = 0, lun_count = 0, offset = 8;
-	u64 i, lun;
+	u32 cdb_offset = 0, lun_count = 0, offset = 8, i;
 
 	list_for_each_entry(se_task, &T_TASK(se_cmd)->t_task_list, t_list)
 		break;
@@ -675,15 +675,7 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 	 * a $FABRIC_MOD.  In that case, report LUN=0 only.
 	 */
 	if (!(se_sess)) {
-		lun = 0;
-		buf[offset++] = ((lun >> 56) & 0xff);
-		buf[offset++] = ((lun >> 48) & 0xff);
-		buf[offset++] = ((lun >> 40) & 0xff);
-		buf[offset++] = ((lun >> 32) & 0xff);
-		buf[offset++] = ((lun >> 24) & 0xff);
-		buf[offset++] = ((lun >> 16) & 0xff);
-		buf[offset++] = ((lun >> 8) & 0xff);
-		buf[offset++] = (lun & 0xff);
+		int_to_scsilun(0, (struct scsi_lun *)&buf[offset]);
 		lun_count = 1;
 		goto done;
 	}
@@ -703,15 +695,8 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
 		if ((cdb_offset + 8) >= se_cmd->data_length)
 			continue;
 
-		lun = cpu_to_be64(CMD_TFO(se_cmd)->pack_lun(deve->mapped_lun));
-		buf[offset++] = ((lun >> 56) & 0xff);
-		buf[offset++] = ((lun >> 48) & 0xff);
-		buf[offset++] = ((lun >> 40) & 0xff);
-		buf[offset++] = ((lun >> 32) & 0xff);
-		buf[offset++] = ((lun >> 24) & 0xff);
-		buf[offset++] = ((lun >> 16) & 0xff);
-		buf[offset++] = ((lun >> 8) & 0xff);
-		buf[offset++] = (lun & 0xff);
+		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
+		offset += 8;
 		cdb_offset += 8;
 	}
 	spin_unlock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index fcdbbff..84e868c 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -519,13 +519,6 @@ static u32 ft_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	return tpg->index;
 }
 
-static u64 ft_pack_lun(unsigned int index)
-{
-	WARN_ON(index >= 256);
-	/* Caller wants this byte-swapped */
-	return cpu_to_le64((index & 0xff) << 8);
-}
-
 static struct target_core_fabric_ops ft_fabric_ops = {
 	.get_fabric_name =		ft_get_fabric_name,
 	.get_fabric_proto_ident =	fc_get_fabric_proto_ident,
@@ -564,7 +557,6 @@ static struct target_core_fabric_ops ft_fabric_ops = {
 	.get_fabric_sense_len =		ft_get_fabric_sense_len,
 	.set_fabric_sense_len =		ft_set_fabric_sense_len,
 	.is_state_remove =		ft_is_state_remove,
-	.pack_lun =			ft_pack_lun,
 	/*
 	 * Setup function pointers for generic logic in
 	 * target_core_fabric_configfs.c
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index dc78f77..747e140 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -77,7 +77,6 @@ struct target_core_fabric_ops {
 	u16 (*set_fabric_sense_len)(struct se_cmd *, u32);
 	u16 (*get_fabric_sense_len)(void);
 	int (*is_state_remove)(struct se_cmd *);
-	u64 (*pack_lun)(unsigned int);
 	/*
 	 * fabric module calls for target_core_fabric_configfs.c
 	 */
-- 
1.7.5.1
