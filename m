From: vikas.chaudhary@qlogic.com
Subject: [PATCH 03/13] qla4xxx: Clear interrupt while unloading driver for ISP83XX
Date: Thu, 20 Sep 2012 07:35:03 -0400
Message-ID: <1348140913-11828-4-git-send-email-vikas.chaudhary@qlogic.com>
References: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:54058 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754166Ab2ITLxF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:05 -0400
In-Reply-To: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d2d7b25..c1093eb 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3501,6 +3501,9 @@ static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
 	} else if (is_qla8022(ha)) {
 		writel(0, &ha->qla4_82xx_reg->host_int);
 		readl(&ha->qla4_82xx_reg->host_int);
+	} else if (is_qla8032(ha)) {
+		writel(0, &ha->qla4_83xx_reg->risc_intr);
+		readl(&ha->qla4_83xx_reg->risc_intr);
 	}
 
 	/* Remove timer thread, if present */
-- 
1.7.1

