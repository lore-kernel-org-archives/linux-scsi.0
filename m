From: vikas.chaudhary@qlogic.com
Subject: [PATCH 11/13] qla4xxx: Fix double clearing of risc_intr for ISP83XX
Date: Thu, 20 Sep 2012 07:35:11 -0400
Message-ID: <1348140913-11828-12-git-send-email-vikas.chaudhary@qlogic.com>
References: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:15378 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754192Ab2ITLxG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Sep 2012 07:53:06 -0400
In-Reply-To: <1348140913-11828-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Dusane <manish.dusane@qlogic.com>

From: Manish Dusane <manish.dusane@qlogic.com>

Issue:
For ISP83XX risc_intr getting clear two times in case of polling mode.
risc_intr getting clear from interrupt_service_routine() as well
from process_mbox_intr() because of this driver may clear risc_intr
without processing interrupt.

Fix:
Do not clear risc_intr from process_mbox_intr().

Signed-off-by: Manish Dusane <manish.dusane@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_83xx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_83xx.c b/drivers/scsi/qla4xxx/ql4_83xx.c
index f963b06..8b367ef 100644
--- a/drivers/scsi/qla4xxx/ql4_83xx.c
+++ b/drivers/scsi/qla4xxx/ql4_83xx.c
@@ -1402,7 +1402,6 @@ void qla4_83xx_process_mbox_intr(struct scsi_qla_host *ha, int outcount)
 		ha->mbox_status_count = outcount;
 		ha->isp_ops->interrupt_service_routine(ha, intr_status);
 	}
-	writel(0, &ha->qla4_83xx_reg->risc_intr);
 }
 
 /**
-- 
1.7.1

