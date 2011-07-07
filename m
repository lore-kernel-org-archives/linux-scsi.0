From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 02/20] target: Pass 2nd param of transport_split_cdb by value
Date: Thu,  7 Jul 2011 15:33:13 -0700
Message-ID: <1310078011-15504-3-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab1GGWdm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2011 18:33:42 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Since sectors is not modified, it's more straightforward to do this.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_scdb.c      |   20 ++++++++++----------
 drivers/target/target_core_scdb.h      |   10 +++++-----
 drivers/target/target_core_transport.c |    3 +--
 include/target/target_core_base.h      |    2 +-
 4 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_scdb.c b/drivers/target/target_core_scdb.c
index dc6fed0..7284344 100644
--- a/drivers/target/target_core_scdb.c
+++ b/drivers/target/target_core_scdb.c
@@ -42,13 +42,13 @@
  */
 void split_cdb_XX_6(
 	unsigned long long lba,
-	u32 *sectors,
+	u32 sectors,
 	unsigned char *cdb)
 {
 	cdb[1] = (lba >> 16) & 0x1f;
 	cdb[2] = (lba >> 8) & 0xff;
 	cdb[3] = lba & 0xff;
-	cdb[4] = *sectors & 0xff;
+	cdb[4] = sectors & 0xff;
 }
 
 /*	split_cdb_XX_10():
@@ -57,11 +57,11 @@ void split_cdb_XX_6(
  */
 void split_cdb_XX_10(
 	unsigned long long lba,
-	u32 *sectors,
+	u32 sectors,
 	unsigned char *cdb)
 {
 	put_unaligned_be32(lba, &cdb[2]);
-	put_unaligned_be16(*sectors, &cdb[7]);
+	put_unaligned_be16(sectors, &cdb[7]);
 }
 
 /*	split_cdb_XX_12():
@@ -70,11 +70,11 @@ void split_cdb_XX_10(
  */
 void split_cdb_XX_12(
 	unsigned long long lba,
-	u32 *sectors,
+	u32 sectors,
 	unsigned char *cdb)
 {
 	put_unaligned_be32(lba, &cdb[2]);
-	put_unaligned_be32(*sectors, &cdb[6]);
+	put_unaligned_be32(sectors, &cdb[6]);
 }
 
 /*	split_cdb_XX_16():
@@ -83,11 +83,11 @@ void split_cdb_XX_12(
  */
 void split_cdb_XX_16(
 	unsigned long long lba,
-	u32 *sectors,
+	u32 sectors,
 	unsigned char *cdb)
 {
 	put_unaligned_be64(lba, &cdb[2]);
-	put_unaligned_be32(*sectors, &cdb[10]);
+	put_unaligned_be32(sectors, &cdb[10]);
 }
 
 /*
@@ -97,9 +97,9 @@ void split_cdb_XX_16(
  */
 void split_cdb_XX_32(
 	unsigned long long lba,
-	u32 *sectors,
+	u32 sectors,
 	unsigned char *cdb)
 {
 	put_unaligned_be64(lba, &cdb[12]);
-	put_unaligned_be32(*sectors, &cdb[28]);
+	put_unaligned_be32(sectors, &cdb[28]);
 }
diff --git a/drivers/target/target_core_scdb.h b/drivers/target/target_core_scdb.h
index 98cd1c0..48e9ccc 100644
--- a/drivers/target/target_core_scdb.h
+++ b/drivers/target/target_core_scdb.h
@@ -1,10 +1,10 @@
 #ifndef TARGET_CORE_SCDB_H
 #define TARGET_CORE_SCDB_H
 
-extern void split_cdb_XX_6(unsigned long long, u32 *, unsigned char *);
-extern void split_cdb_XX_10(unsigned long long, u32 *, unsigned char *);
-extern void split_cdb_XX_12(unsigned long long, u32 *, unsigned char *);
-extern void split_cdb_XX_16(unsigned long long, u32 *, unsigned char *);
-extern void split_cdb_XX_32(unsigned long long, u32 *, unsigned char *);
+extern void split_cdb_XX_6(unsigned long long, u32, unsigned char *);
+extern void split_cdb_XX_10(unsigned long long, u32, unsigned char *);
+extern void split_cdb_XX_12(unsigned long long, u32, unsigned char *);
+extern void split_cdb_XX_16(unsigned long long, u32, unsigned char *);
+extern void split_cdb_XX_32(unsigned long long, u32, unsigned char *);
 
 #endif /* TARGET_CORE_SCDB_H */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9d02f86..b98f6ff 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4762,8 +4762,7 @@ static u32 transport_allocate_tasks(
 		       scsi_command_size(cmd->t_task_cdb));
 
 		/* Update new cdb with updated lba/sectors */
-		cmd->transport_split_cdb(task->task_lba,
-					 &task->task_sectors, cdb);
+		cmd->transport_split_cdb(task->task_lba, task->task_sectors, cdb);
 
 		/*
 		 * Perform the SE OBJ plugin and/or Transport plugin specific
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 380b4c8..464ecd2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -480,7 +480,7 @@ struct se_cmd {
 	struct list_head	se_queue_node;
 	struct target_core_fabric_ops *se_tfo;
 	int (*transport_emulate_cdb)(struct se_cmd *);
-	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
+	void (*transport_split_cdb)(unsigned long long, u32, unsigned char *);
 	void (*transport_wait_for_tasks)(struct se_cmd *, int, int);
 	void (*transport_complete_callback)(struct se_cmd *);
 	int (*transport_qf_callback)(struct se_cmd *);
-- 
1.7.1

