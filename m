From: vikas.chaudhary@qlogic.com
Subject: [PATCH 3/4] qla4xxx: Wait for cmd to complete before chip reset for ISP40XX
Date: Wed, 22 Aug 2012 07:45:26 -0400
Message-ID: <1345635927-22420-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1345635927-22420-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:60932 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752414Ab2HVMCD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 08:02:03 -0400
In-Reply-To: <1345635927-22420-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f06b7c5..0a0c9c5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3000,10 +3000,10 @@ static int qla4xxx_recover_adapter(struct scsi_qla_host *ha)
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			schedule_timeout(HZ);
 		}
-
+chip_reset:
 		if (!test_bit(AF_FW_RECOVERY, &ha->flags))
 			qla4xxx_cmd_wait(ha);
-chip_reset:
+
 		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
 		qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
 		DEBUG2(ql4_printk(KERN_INFO, ha,
-- 
1.7.8.GIT

