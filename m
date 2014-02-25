From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 01/10] qla4xxx: Do not wait for IO completion, after issuing stop_firmware
Date: Mon, 24 Feb 2014 22:06:56 -0500
Message-ID: <1393297625-928-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:20384 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbaBYDpD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Feb 2014 22:45:03 -0500
In-Reply-To: <1393297625-928-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Tej Parkash <tej.parkash@qlogic.com>

From: Tej Parkash <tej.parkash@qlogic.com>

Problem:
iSCSI stop_firmware mailbox command is not completing outstanding IO.

Solution:
Do not wait for IO completion after issuing stop_firmware mailbox
command

Signed-off-by: Tej Parkash <tej.parkash@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 459b9f7..2e95be4 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4862,9 +4862,6 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 		    ha->host_no, __func__));
 		status = ha->isp_ops->reset_firmware(ha);
 		if (status == QLA_SUCCESS) {
-			if (!test_bit(AF_FW_RECOVERY, &ha->flags))
-				qla4xxx_cmd_wait(ha);
-
 			ha->isp_ops->disable_intrs(ha);
 			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 			qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
-- 
1.8.2.GIT

