From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/7] iscsi-target: Fix iscsit_alloc_buffs() breakage with offset_in_page
Date: Fri,  3 Jun 2011 18:18:12 -0700
Message-ID: <1307150298-23921-2-git-send-email-nab@linux-iscsi.org>
References: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6.access.bullet.mail.mud.yahoo.com ([66.94.237.207]:22844
	"HELO nm6.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751703Ab1FDBSu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2011 21:18:50 -0400
In-Reply-To: <1307150298-23921-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes iscsit_alloc_buffs() w/ SCF_SCSI_CONTROL_NONSG_IO_CDB
to take into account the offset_in_page(), and also handles the case
where length and PAGE_SIZE are identical, and require nents to be incremented.

It also moves iscsit_allocate_iovecs() for the SCSI payload case until
after transport_generic_map_mem_to_cmd() has been called because the
iovec allocation depends upon cmd->se_cmd.t_tasks_se_num having been
set by the return of transport_map_sg_to_mem() done in RX thread context.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |   78 +++++++++++++++++++++++------------
 1 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 2503ef3..959f616 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -779,27 +779,17 @@ static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
 
 static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
 {
-	u32 length = cmd->se_cmd.data_length;
 	struct scatterlist *sgl;
+	void *buf, *cur;
+	u32 length = cmd->se_cmd.data_length;
 	int nents = DIV_ROUND_UP(length, PAGE_SIZE);
-	int i;
-	void *buf;
-	void *cur;
-	int ret;
-
-	/* Even no-length cmds need some iovecs, apparently? */
-	ret = iscsit_allocate_iovecs(cmd);
-	if (ret < 0)
-		return ret;
-
+	int i = 0, ret;
+	/*
+	 * If no SCSI payload is present, allocate the default iovecs used for
+	 * iSCSI PDU Header
+	 */
 	if (!length)
-		return 0;
-
-	sgl = kzalloc(sizeof(*sgl) * nents, GFP_KERNEL);
-	if (!sgl)
-		return -ENOMEM;
-	sg_init_table(sgl, nents);
-
+		return iscsit_allocate_iovecs(cmd);
 	/*
 	 * Allocate from slab if nonsg, but sgl should point
 	 * to the malloced mem.
@@ -807,17 +797,38 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
 	 * Alloc pages if sg.
 	 */
 	if (cmd->se_cmd.se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
+		int pg_off = 0, buf_size;
 
 		buf = kmalloc(length, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
+		/*
+		 * Allocate extra SGL for offset_in_page exceeding DIV_ROUND_UP
+		 */
+		pg_off = offset_in_page(buf);
+		if ((pg_off + length) > (PAGE_SIZE * nents))
+			nents++;
+
+		sgl = kzalloc(sizeof(*sgl) * nents, GFP_KERNEL);
+		if (!sgl)
+			return -ENOMEM;
+		sg_init_table(sgl, nents);
 
 		cur = buf;
 		while (length) {
-			int buf_size = min_t(int, length, PAGE_SIZE);
-
+			if (pg_off != 0) {
+				buf_size = min_t(int, PAGE_SIZE - pg_off, length);
+				pg_off = 0;
+			} else
+				buf_size = min_t(int, length, PAGE_SIZE);
+					
 			sg_set_buf(&sgl[i], cur, buf_size);
 
+			if (sgl[i].length < 0) {
+				printk("sg_set_buf: page: %p, len: %d, offset: %d\n",
+					sg_page(&sgl[i]), sgl[i].length, sgl[i].offset);
+				BUG();
+			}
 			length -= buf_size;
 			cur += buf_size;
 			i++;
@@ -826,7 +837,12 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
 		cmd->t_mem = buf;
 
 	} else {
-		i = 0;
+		sgl = kzalloc(sizeof(*sgl) * nents, GFP_KERNEL);
+		if (!sgl)
+			return -ENOMEM;
+
+		sg_init_table(sgl, nents);
+
 		while (length) {
 			int buf_size = min_t(int, length, PAGE_SIZE);
 			struct page *page;
@@ -849,6 +865,13 @@ static int iscsit_alloc_buffs(struct iscsi_cmd *cmd)
 
 	/* make se_mem list from the memory */
 	transport_generic_map_mem_to_cmd(&cmd->se_cmd, sgl, nents, NULL, 0);
+	/*
+	 * Allocate iovecs for SCSI payload after transport_generic_map_mem_to_cmd
+	 * so that cmd->se_cmd.t_tasks_se_num has been set.
+	 */
+        ret = iscsit_allocate_iovecs(cmd);
+        if (ret < 0)
+		goto page_alloc_failed;
 
 	return 0;
 
@@ -1081,12 +1104,15 @@ attach_cmd:
 	 * Active/NonOptimized primary access state..
 	 */
 	core_alua_check_nonop_delay(SE_CMD(cmd));
-
+	/*
+	 * Allocate and setup SGL used with transport_generic_map_mem_to_cmd().
+	 * also call iscsit_allocate_iovecs()
+	 */
 	ret = iscsit_alloc_buffs(cmd);
-	if (ret < 0) {
-		return ret;
-	}
-
+	if (ret < 0)
+		return iscsit_add_reject_from_cmd(
+				ISCSI_REASON_BOOKMARK_NO_RESOURCES,
+				1, 1, buf, cmd);
 	/*
 	 * Check the CmdSN against ExpCmdSN/MaxCmdSN here if
 	 * the Immediate Bit is not set, and no Immediate
-- 
1.7.2.5

