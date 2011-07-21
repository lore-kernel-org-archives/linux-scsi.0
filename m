From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 001/103] target: Check LUN numbers in transport_get_lun_for_[cmd,tmr]
Date: Thu, 21 Jul 2011 00:04:37 -0700
Message-ID: <1311231979-6631-2-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm8.bullet.mail.bf1.yahoo.com ([98.139.212.167]:34441 "HELO
	nm8.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752176Ab1GUHGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:51 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

This patch checks the passed 'unpacked_lun' against TRANSPORT_MAX_LUNS_PER_TPG
before reading from struct se_node_acl->device_list[].

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index ba698ea..f5516a1 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -65,6 +65,12 @@ int transport_get_lun_for_cmd(
 	unsigned long flags;
 	int read_only = 0;
 
+	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
+		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
+		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		return -1;
+	}
+
 	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 	deve = se_cmd->se_deve =
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
@@ -187,6 +193,12 @@ int transport_get_lun_for_tmr(
 	struct se_session *se_sess = SE_SESS(se_cmd);
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 
+	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
+		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
+		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
+		return -1;
+	}
+
 	spin_lock_irq(&SE_NODE_ACL(se_sess)->device_list_lock);
 	deve = se_cmd->se_deve =
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
-- 
1.7.6

