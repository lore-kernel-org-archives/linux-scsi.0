From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH] target: Unsupported SCSI Opcode Fix
Date: Thu, 30 Jun 2016 13:50:18 -0500
Message-ID: <1467312618-21592-1-git-send-email-bryantly@linux.vnet.ibm.com>
References: <B4AAE167-F030-4EDD-9221-2CD07ECD4B61@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35918 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750929AbcF3SuZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jun 2016 14:50:25 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5UInLu7126608
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2016 14:50:25 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23w76nuxay-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2016 14:50:24 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
	Thu, 30 Jun 2016 14:50:24 -0400
In-Reply-To: <B4AAE167-F030-4EDD-9221-2CD07ECD4B61@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: mikecyr@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

If a Simple command is sent with a failure,
target_setup_cmd_from_cdb returns with TCM_UNSUPPORTED_SCSI_OPCODE
or TCM_INVALID_CDB_FIELD. So in the cases where target_setup_cmd_from_cdb
returns an error, we never get far enough to call target_execute_cmd to
increment simple_cmds. Since simple_cmds isn't incremented, the
result of the failure from target_setup_cmd_from_cdb causes
transport_generic_request_failure to decrement
simple_cmds, due to call to transport_complete_task_attr.
With this dev->simple_cmds or dev->dev_ordered_sync is now -1, not 0.
So when a subsequent command with an Ordered Task is sent, it causes
a hang, since dev->simple_cmds is at -1.

Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_transport.c | 6 ++++++
 include/target/target_core_base.h      | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0a8f0a6..a2e447a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1824,6 +1824,8 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return false;
 
+	cmd->se_cmd_flags |= SCF_TASK_ATTR_SET;
+
 	/*
 	 * Check for the existence of HEAD_OF_QUEUE, and if true return 1
 	 * to allow the passed struct se_cmd list of tasks to the front of the list.
@@ -1946,6 +1948,9 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return;
 
+	if (!(cmd->se_cmd_flags & SCF_TASK_ATTR_SET))
+		goto restart;
+
 	if (cmd->sam_task_attr == TCM_SIMPLE_TAG) {
 		atomic_dec_mb(&dev->simple_cmds);
 		dev->dev_cur_ordered_id++;
@@ -1963,6 +1968,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 			 dev->dev_cur_ordered_id);
 	}
 
+restart:
 	target_restart_delayed_cmds(dev);
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e5d0948..276f5a5 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -139,7 +139,8 @@ enum se_cmd_flags_table {
 	SCF_COMPARE_AND_WRITE_POST	= 0x00100000,
 	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
 	SCF_ACK_KREF			= 0x00400000,
-	SCF_USE_CPUID			= 0x00800000,
+	SCF_USE_CPUID                   = 0x00800000,
+	SCF_TASK_ATTR_SET               = 0x01000000,
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
-- 
2.5.4 (Apple Git-61)

