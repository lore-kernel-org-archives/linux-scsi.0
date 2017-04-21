From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v2] target/user: PGR Support
Date: Fri, 21 Apr 2017 12:59:29 -0500
Message-ID: <1492797569-37588-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This adds initial PGR support for just TCMU, since tcmu doesn't
have the necessary IT_NEXUS info to process PGR in userspace,
so have those commands be processed in kernel.

HA support is not available yet, we will work on it if this patch
is acceptable.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_configfs.c | 10 ++++-----
 drivers/target/target_core_device.c   | 38 +++++++++++++++++++++++++++++++++++
 drivers/target/target_core_pr.c       |  2 +-
 drivers/target/target_core_pscsi.c    |  3 ++-
 include/target/target_core_backend.h  |  1 +
 5 files changed, 47 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 38b5025..edfb098 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1366,7 +1366,7 @@ static ssize_t target_pr_res_holder_show(struct config_item *item, char *page)
 	struct se_device *dev = pr_to_dev(item);
 	int ret;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "Passthrough\n");
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -1506,7 +1506,7 @@ static ssize_t target_pr_res_type_show(struct config_item *item, char *page)
 {
 	struct se_device *dev = pr_to_dev(item);
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "SPC_PASSTHROUGH\n");
 	else if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return sprintf(page, "SPC2_RESERVATIONS\n");
@@ -1519,7 +1519,7 @@ static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
 {
 	struct se_device *dev = pr_to_dev(item);
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return 0;
 
 	return sprintf(page, "APTPL Bit Status: %s\n",
@@ -1531,7 +1531,7 @@ static ssize_t target_pr_res_aptpl_metadata_show(struct config_item *item,
 {
 	struct se_device *dev = pr_to_dev(item);
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return 0;
 
 	return sprintf(page, "Ready to process PR APTPL metadata..\n");
@@ -1577,7 +1577,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	u16 tpgt = 0;
 	u8 type = 0;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return count;
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return count;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c754ae3..80106cc 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1045,6 +1045,8 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	sense_reason_t (*exec_cmd)(struct se_cmd *cmd))
 {
 	unsigned char *cdb = cmd->t_task_cdb;
+	struct se_device *dev = cmd->se_dev;
+	unsigned int size;
 
 	/*
 	 * Clear a lun set in the cdb if the initiator talking to use spoke
@@ -1076,6 +1078,42 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 		return TCM_NO_SENSE;
 	}
 
+	/*
+	 * For PERSISTENT RESERVE IN/OUT, RELEASE, and RESERVE we need to
+	 * emulate the response, since tcmu does not have the information
+	 * required to process these commands.
+	 */
+	if (!(dev->transport->transport_flags &
+	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
+		if (cdb[0] == PERSISTENT_RESERVE_IN) {
+			cmd->execute_cmd = target_scsi3_emulate_pr_in;
+			size = (cdb[7] << 8) + cdb[8];
+			return target_cmd_size_check(cmd, size);
+		}
+		if (cdb[0] == PERSISTENT_RESERVE_OUT) {
+			cmd->execute_cmd = target_scsi3_emulate_pr_out;
+			size = (cdb[7] << 8) + cdb[8];
+			return target_cmd_size_check(cmd, size);
+		}
+
+		if (cdb[0] == RELEASE || cdb[0] == RELEASE_10) {
+			cmd->execute_cmd = target_scsi2_reservation_release;
+			if (cdb[0] == RELEASE_10)
+				size = (cdb[7] << 8) | cdb[8];
+			else
+				size = cmd->data_length;
+			return target_cmd_size_check(cmd, size)
+		}
+		if (cdb[0] == RESERVE || cdb[0] == RESERVE_10) {
+			cmd->execute_cmd = target_scsi2_reservation_reserve;
+			if (cdb[0] == RESERVE_10)
+				size = (cdb[7] << 8) | cdb[8];
+			else
+				size = cmd->data_length;
+			return target_cmd_size_check(cmd, size);
+		}
+	}
+
 	/* Set DATA_CDB flag for ops that should have it */
 	switch (cdb[0]) {
 	case READ_6:
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index e180511..129ca57 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -4147,7 +4147,7 @@ target_check_reservation(struct se_cmd *cmd)
 		return 0;
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return 0;
 
 	spin_lock(&dev->dev_reservation_lock);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 94cda79..8943a62 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1081,7 +1081,8 @@ static const struct target_backend_ops pscsi_ops = {
 	.name			= "pscsi",
 	.owner			= THIS_MODULE,
 	.transport_flags	= TRANSPORT_FLAG_PASSTHROUGH |
-				  TRANSPORT_FLAG_PASSTHROUGH_ALUA,
+				  TRANSPORT_FLAG_PASSTHROUGH_ALUA |
+				  TRANSPORT_FLAG_PASSTHROUGH_PGR,
 	.attach_hba		= pscsi_attach_hba,
 	.detach_hba		= pscsi_detach_hba,
 	.pmode_enable_hba	= pscsi_pmode_enable_hba,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1b0f447..e475531 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -10,6 +10,7 @@
  * backend module.
  */
 #define TRANSPORT_FLAG_PASSTHROUGH_ALUA		0x2
+#define TRANSPORT_FLAG_PASSTHROUGH_PGR          0x4
 
 struct request_queue;
 struct scatterlist;
-- 
2.5.4 (Apple Git-61)
