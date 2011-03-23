From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 03/14] target: Convert REPORT_LUNs to use int_to_scsilun
Date: Tue, 22 Mar 2011 20:06:34 -0700
Message-ID: <1300849605-12651-4-git-send-email-nab@linux-iscsi.org>
References: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm16.bullet.mail.bf1.yahoo.com ([98.139.212.175]:33169 "HELO
	nm16.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751763Ab1CWDHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2011 23:07:01 -0400
In-Reply-To: <1300849605-12651-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts transport_core_report_lun_response() to use
drivers/scsi/scsi_scan.c:int_to_scsilun instead of using the
struct target_core_fabric_ops->pack_lun() fabric provided API vector.

It also removes the tfo->pack_lun check from target_fabric_tf_ops_check()
and will be removed from struct target_core_fabric_ops in a seperate
patch.

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |    4 ----
 drivers/target/target_core_device.c   |   26 +++++---------------------
 2 files changed, 5 insertions(+), 25 deletions(-)

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
index 3fb8e32..7605967 100644
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
@@ -703,16 +695,8 @@ int transport_core_report_lun_response(struct se_cmd *se_cmd)
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
-		cdb_offset += 8;
+		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
+		cdb_offset += 16;
 	}
 	spin_unlock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 
-- 
1.7.4.1

