From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/9] target: Add return for se_cmd->transport_complete_callback
Date: Tue, 20 Aug 2013 20:07:53 +0000
Message-ID: <1377029280-19144-3-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch adds a sense_reason_t return to ->transport_complete_callback(),
and updates target_complete_ok_work() to invoke the call if necessary to
transport_send_check_condition_and_sense() during the failure case.

Also update xdreadwrite_callback() to use this return value.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_sbc.c       |   13 ++++++++-----
 drivers/target/target_core_transport.c |   20 +++++++++++++++++---
 include/target/target_core_base.h      |    2 +-
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 8a46277..be5234a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -280,13 +280,13 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	return 0;
 }
 
-static void xdreadwrite_callback(struct se_cmd *cmd)
+static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd)
 {
 	unsigned char *buf, *addr;
 	struct scatterlist *sg;
 	unsigned int offset;
-	int i;
-	int count;
+	sense_reason_t ret = TCM_NO_SENSE;
+	int i, count;
 	/*
 	 * From sbc3r22.pdf section 5.48 XDWRITEREAD (10) command
 	 *
@@ -301,7 +301,7 @@ static void xdreadwrite_callback(struct se_cmd *cmd)
 	buf = kmalloc(cmd->data_length, GFP_KERNEL);
 	if (!buf) {
 		pr_err("Unable to allocate xor_callback buf\n");
-		return;
+		return TCM_OUT_OF_RESOURCES;
 	}
 	/*
 	 * Copy the scatterlist WRITE buffer located at cmd->t_data_sg
@@ -320,8 +320,10 @@ static void xdreadwrite_callback(struct se_cmd *cmd)
 	offset = 0;
 	for_each_sg(cmd->t_bidi_data_sg, sg, cmd->t_bidi_data_nents, count) {
 		addr = kmap_atomic(sg_page(sg));
-		if (!addr)
+		if (!addr) {
+			ret = TCM_OUT_OF_RESOURCES;
 			goto out;
+		}
 
 		for (i = 0; i < sg->length; i++)
 			*(addr + sg->offset + i) ^= *(buf + offset + i);
@@ -332,6 +334,7 @@ static void xdreadwrite_callback(struct se_cmd *cmd)
 
 out:
 	kfree(buf);
+	return ret;
 }
 
 sense_reason_t
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 98ec711..53d1d75 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1904,10 +1904,24 @@ static void target_complete_ok_work(struct work_struct *work)
 	}
 	/*
 	 * Check for a callback, used by amongst other things
-	 * XDWRITE_READ_10 emulation.
+	 * XDWRITE_READ_10 and COMPARE_AND_WRITE emulation.
 	 */
-	if (cmd->transport_complete_callback)
-		cmd->transport_complete_callback(cmd);
+	if (cmd->transport_complete_callback) {
+		sense_reason_t rc;
+
+		rc = cmd->transport_complete_callback(cmd);
+		if (!rc)
+			return;
+
+		ret = transport_send_check_condition_and_sense(cmd,
+					rc, 0);
+		if (ret == -EAGAIN || ret == -ENOMEM)
+			goto queue_full;
+
+		transport_lun_remove_cmd(cmd);
+		transport_cmd_check_stop_to_fabric(cmd);
+		return;
+	}
 
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 360e4a3..6e946f3 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -447,7 +447,7 @@ struct se_cmd {
 	struct kref		cmd_kref;
 	struct target_core_fabric_ops *se_tfo;
 	sense_reason_t		(*execute_cmd)(struct se_cmd *);
-	void (*transport_complete_callback)(struct se_cmd *);
+	sense_reason_t (*transport_complete_callback)(struct se_cmd *);
 
 	unsigned char		*t_task_cdb;
 	unsigned char		__t_task_cdb[TCM_MAX_COMMAND_SIZE];
-- 
1.7.10.4
