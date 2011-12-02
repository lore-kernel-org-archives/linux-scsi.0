From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 5/9] qla4xxx: Wait for disable_acb before doing set_acb
Date: Thu, 1 Dec 2011 22:42:10 -0800
Message-ID: <1322808134-21665-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:57703
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752469Ab1LBGzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Dec 2011 01:55:53 -0500
In-Reply-To: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

In function qla4xxx_iface_set_param wait for disable_acb to
complete so that set_acb will not fail.

JIRA Key: UPSISCSI-121

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c5ae676..c6f9e7b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -935,7 +935,16 @@ qla4xxx_iface_set_param(struct Scsi_Host *shost, void *data, uint32_t len)
 		goto exit_init_fw_cb;
 	}
 
-	qla4xxx_disable_acb(ha);
+	rval = qla4xxx_disable_acb(ha);
+	if (rval != QLA_SUCCESS) {
+		ql4_printk(KERN_ERR, ha, "%s: disable acb mbx failed\n",
+			   __func__);
+		rval = -EIO;
+		goto exit_init_fw_cb;
+	}
+
+	wait_for_completion_timeout(&ha->disable_acb_comp,
+				    DISABLE_ACB_TOV * HZ);
 
 	qla4xxx_initcb_to_acb(init_fw_cb);
 
-- 
1.7.8.rc2.3.g0911


