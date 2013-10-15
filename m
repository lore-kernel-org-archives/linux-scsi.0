From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH] qla4xxx: Fix memory leak in func qla4_84xx_config_acb()
Date: Tue, 15 Oct 2013 04:55:56 -0400
Message-ID: <1381827356-24408-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:29362 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002Ab3JOJ1w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Oct 2013 05:27:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Use correct goto statement to free dma memory in case of
failure in function qla4_84xx_config_acb()

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 22cbd00..1bb3fde 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -2281,7 +2281,7 @@ int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config)
 			ql4_printk(KERN_ERR, ha, "%s: Unable to alloc acb\n",
 				   __func__);
 			rval = QLA_ERROR;
-			goto exit_config_acb;
+			goto exit_free_acb;
 		}
 		memcpy(ha->saved_acb, acb, acb_len);
 		break;
-- 
1.8.2.GIT

