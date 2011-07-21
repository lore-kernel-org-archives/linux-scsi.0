From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 049/103] target: Simplify transport_memcpy_se_mem_read_contig
Date: Thu, 21 Jul 2011 00:08:01 -0700
Message-ID: <1311232135-6653-50-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm28-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.190]:22945
	"HELO nm28-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751924Ab1GUHEc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:32 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

transport_memcpy_se_mem_read_contig() doesn't need to take a *cmd as a
parameter, as it just needs the data_length so go ahead and pass this
directly.

Also use min_t for great justice.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index c01a81b..df9a9a2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -218,8 +218,8 @@ static int transport_get_sectors(struct se_cmd *cmd);
 static int transport_map_sg_to_mem(struct se_cmd *cmd,
 		struct list_head *se_mem_list, struct scatterlist *sgl,
 		u32 *se_mem_cnt);
-static void transport_memcpy_se_mem_read_contig(struct se_cmd *cmd,
-		unsigned char *dst, struct list_head *se_mem_list);
+static void transport_memcpy_se_mem_read_contig(unsigned char *dst,
+		struct list_head *se_mem_list, u32 len);
 static void transport_release_fe_cmd(struct se_cmd *cmd);
 static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		struct se_queue_obj *qobj);
@@ -2802,7 +2802,8 @@ static void transport_xor_callback(struct se_cmd *cmd)
 	 * Copy the scatterlist WRITE buffer located at cmd->t_task.t_mem_list
 	 * into the locally allocated *buf
 	 */
-	transport_memcpy_se_mem_read_contig(cmd, buf, &cmd->t_task.t_mem_list);
+	transport_memcpy_se_mem_read_contig(buf, &cmd->t_task.t_mem_list,
+					    cmd->data_length);
 	/*
 	 * Now perform the XOR against the BIDI read memory located at
 	 * cmd->t_task.t_mem_bidi_list
@@ -3543,27 +3544,21 @@ out_invalid_cdb_field:
 static inline void transport_release_tasks(struct se_cmd *);
 
 static void transport_memcpy_se_mem_read_contig(
-	struct se_cmd *cmd,
 	unsigned char *dst,
-	struct list_head *se_mem_list)
+	struct list_head *se_mem_list,
+	u32 tot_len)
 {
 	struct se_mem *se_mem;
 	void *src;
-	u32 length = 0, total_length = cmd->data_length;
+	u32 length;
 
 	list_for_each_entry(se_mem, se_mem_list, se_list) {
-		length = se_mem->se_len;
-
-		if (length > total_length)
-			length = total_length;
-
+		length = min_t(u32, se_mem->se_len, tot_len);
 		src = page_address(se_mem->se_page) + se_mem->se_off;
-
 		memcpy(dst, src, length);
-
-		if (!(total_length -= length))
-			return;
-
+		tot_len -= length;
+		if (!tot_len)
+			break;
 		dst += length;
 	}
 }
-- 
1.7.6

