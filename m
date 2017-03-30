From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] target/user: PGR Support
Date: Thu, 30 Mar 2017 09:47:49 -0500
Message-ID: <1490885269-47274-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50304 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753939AbdC3Or5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Mar 2017 10:47:57 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2UEihRg043835
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2017 10:47:56 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29gfqhdkdj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2017 10:47:56 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Thu, 30 Mar 2017 10:47:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This adds PGR support for just TCMU, since tcmu doesn't
have the necessary IT_NEXUS info to process PGR in userspace,
so have those commands be processed in kernel.

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_configfs.c | 10 +++++-----
 drivers/target/target_core_device.c   | 27 +++++++++++++++++++++++++++
 drivers/target/target_core_pr.c       |  2 +-
 drivers/target/target_core_pscsi.c    |  3 ++-
 include/target/target_core_backend.h  |  1 +
 5 files changed, 36 insertions(+), 7 deletions(-)

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
index c754ae3..83c0d77 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1045,6 +1045,7 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	sense_reason_t (*exec_cmd)(struct se_cmd *cmd))
 {
 	unsigned char *cdb = cmd->t_task_cdb;
+	struct se_device *dev = cmd->se_dev;
 
 	/*
 	 * Clear a lun set in the cdb if the initiator talking to use spoke
@@ -1076,6 +1077,32 @@ passthrough_parse_cdb(struct se_cmd *cmd,
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
+			return TCM_NO_SENSE;
+		}
+		if (cdb[0] == PERSISTENT_RESERVE_OUT) {
+			cmd->execute_cmd = target_scsi3_emulate_pr_out;
+			return TCM_NO_SENSE;
+		}
+
+		if (cdb[0] == RELEASE || cdb[0] == RELEASE_10) {
+			cmd->execute_cmd = target_scsi2_reservation_release;
+			return TCM_NO_SENSE;
+		}
+		if (cdb[0] == RESERVE || cdb[0] == RESERVE_10) {
+			cmd->execute_cmd = target_scsi2_reservation_reserve;
+			return TCM_NO_SENSE;
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
