From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 3/6] qla4xxx: Fix memory leak for ha->saved_acb
Date: Wed, 9 Apr 2014 21:12:26 -0400
Message-ID: <1397092349-25332-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:53735 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965108AbaDJBuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2014 21:50:15 -0400
In-Reply-To: <1397092349-25332-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, giridhar.malavali@qlogic.com, Nilesh Javali <nilesh.javali@qlogic.com>

From: Nilesh Javali <nilesh.javali@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_mbx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 1345c0e..0a3312c 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -2395,8 +2395,6 @@ int qla4_84xx_config_acb(struct scsi_qla_host *ha, int acb_config)
 		}
 
 		memcpy(acb, ha->saved_acb, acb_len);
-		kfree(ha->saved_acb);
-		ha->saved_acb = NULL;
 
 		rval = qla4xxx_set_acb(ha, &mbox_cmd[0], &mbox_sts[0], acb_dma);
 		if (rval != QLA_SUCCESS)
@@ -2412,6 +2410,10 @@ exit_free_acb:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct addr_ctrl_blk), acb,
 			  acb_dma);
 exit_config_acb:
+	if ((acb_config == ACB_CONFIG_SET) && ha->saved_acb) {
+		kfree(ha->saved_acb);
+		ha->saved_acb = NULL;
+	}
 	DEBUG2(ql4_printk(KERN_INFO, ha,
 			  "%s %s\n", __func__,
 			  rval == QLA_SUCCESS ? "SUCCEEDED" : "FAILED"));
-- 
1.8.2.GIT

