From: vikas.chaudhary@qlogic.com
Subject: [PATCH 2/4] qla4xxx: Clear interrupt while unloading driver.
Date: Wed, 22 Aug 2012 07:45:25 -0400
Message-ID: <1345635927-22420-3-git-send-email-vikas.chaudhary@qlogic.com>
References: <1345635927-22420-1-git-send-email-vikas.chaudhary@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:51257 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752169Ab2HVMCD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Aug 2012 08:02:03 -0400
In-Reply-To: <1345635927-22420-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

while processing the stop firmware mailbox command on driver unload,
a interrupt is processed which causes kernel panic as the response
queue is not valid.

Fix is to clear the interrupt in free_adapter call just after
disabling the interrupts.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index fa1a359..f06b7c5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3487,6 +3487,15 @@ static void qla4xxx_free_adapter(struct scsi_qla_host *ha)
 		ha->isp_ops->disable_intrs(ha);
 	}
 
+	if (is_qla40XX(ha)) {
+		writel(set_rmask(CSR_SCSI_PROCESSOR_INTR),
+		       &ha->reg->ctrl_status);
+		readl(&ha->reg->ctrl_status);
+	} else if (is_qla8022(ha)) {
+		writel(0, &ha->qla4_8xxx_reg->host_int);
+		readl(&ha->qla4_8xxx_reg->host_int);
+	}
+
 	/* Remove timer thread, if present */
 	if (ha->timer_active)
 		qla4xxx_stop_timer(ha);
-- 
1.7.8.GIT

