From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 7/9] qla2xxx: fix command initialization in target mode.
Date: Wed, 10 Jun 2015 11:05:23 -0400
Message-ID: <1433948725-4073-8-git-send-email-himanshu.madhani@qlogic.com>
References: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:57584 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965995AbbFJPtL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2015 11:49:11 -0400
In-Reply-To: <1433948725-4073-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Kanoj Sarcar <kanoj.sarcar@qlogic.com>

Signed-off-by: Kanoj Sarcar <kanoj.sarcar@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b72cda6..7c43cf8 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3347,6 +3347,11 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	cmd->loop_id = sess->loop_id;
 	cmd->conf_compl_supported = sess->conf_compl_supported;
 
+	cmd->cmd_flags = 0;
+	cmd->jiffies_at_alloc = get_jiffies_64();
+
+	cmd->reset_count = vha->hw->chip_reset;
+
 	return cmd;
 }
 
@@ -3453,11 +3458,6 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 		return -ENOMEM;
 	}
 
-	cmd->cmd_flags = 0;
-	cmd->jiffies_at_alloc = get_jiffies_64();
-
-	cmd->reset_count = vha->hw->chip_reset;
-
 	cmd->cmd_in_wq = 1;
 	cmd->cmd_flags |= BIT_0;
 	INIT_WORK(&cmd->work, qlt_do_work);
-- 
1.7.7

