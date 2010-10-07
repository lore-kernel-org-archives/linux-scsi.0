From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 06/15] qla4xxx: Do not wait for the outstanding commands to
 complete
Date: Wed, 6 Oct 2010 22:49:20 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406789@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37535 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab0JGFtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:49:22 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Nilesh Javali <nilesh.javali@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Do not wait for the outstanding commands to complete in case
of firmware hang.

Signed-off-by: Nilesh Javali <nilesh.javali@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 56962e5..a6455fb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1102,7 +1102,8 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 		    ha->host_no, __func__));
 		status = ha->isp_ops->reset_firmware(ha);
 		if (status == QLA_SUCCESS) {
-			qla4xxx_cmd_wait(ha);
+			if (!test_bit(AF_FW_RECOVERY, &ha->flags))
+				qla4xxx_cmd_wait(ha);
 			ha->isp_ops->disable_intrs(ha);
 			qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 			qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
@@ -1119,7 +1120,8 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 	 * or if stop_firmware fails for ISP-82xx.
 	 * This is the default case for ISP-4xxx */
 	if (!is_qla8022(ha) || reset_chip) {
-		qla4xxx_cmd_wait(ha);
+		if (!test_bit(AF_FW_RECOVERY, &ha->flags))
+			qla4xxx_cmd_wait(ha);
 		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 		qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
 		DEBUG2(ql4_printk(KERN_INFO, ha,
-- 
1.6.6

