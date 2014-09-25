From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 08/17] qla2xxx: fix crash due to task mgmt cmd type
Date: Thu, 25 Sep 2014 06:14:50 -0400
Message-ID: <1411640099-7856-9-git-send-email-saurav.kashyap@qlogic.com>
References: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:10531 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbaIYKtA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 06:49:00 -0400
In-Reply-To: <1411640099-7856-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

tcm_qla2xxx_get_task_tag incorrectly assume command is
qla_tgt_cmd.  Add check to see if it's a scsi cmd or
task mgmt command.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 09d2931..9f95407 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -515,8 +515,13 @@ static void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *nacl)
 
 static u32 tcm_qla2xxx_get_task_tag(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd;
+
+	/* check for task mgmt cmd */
+	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		return 0xffffffff;
+
+	cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
 
 	return cmd->tag;
 }
-- 
1.7.7

