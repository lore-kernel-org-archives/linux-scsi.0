From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/7] qla4xxx: Clear the RISC interrupt bit during FW init
Date: Wed, 11 Jan 2012 02:44:18 -0800
Message-ID: <1326278661-16368-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55670 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933636Ab2AKK7X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2012 05:59:23 -0500
In-Reply-To: <1326278661-16368-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Sarang Radke <sarang.radke@qlogic.com>

From: Sarang Radke <sarang.radke@qlogic.com>

This patch fix kernel panic during kdump.

Signed-off-by: Sarang Radke <sarang.radke@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_init.c |    3 +++
 drivers/scsi/qla4xxx/ql4_nx.c   |    5 +++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 1bdfa81..90614f3 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -697,6 +697,9 @@ int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 			writel(set_rmask(CSR_SCSI_PROCESSOR_INTR),
 			       &ha->reg->ctrl_status);
 			readl(&ha->reg->ctrl_status);
+			writel(set_rmask(CSR_SCSI_COMPLETION_INTR),
+			       &ha->reg->ctrl_status);
+			readl(&ha->reg->ctrl_status);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			if (qla4xxx_get_firmware_state(ha) == QLA_SUCCESS) {
 				DEBUG2(printk("scsi%ld: %s: Get firmware "
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 8d6bc1b..78f1111 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1875,6 +1875,11 @@ exit:
 int qla4_8xxx_load_risc(struct scsi_qla_host *ha)
 {
 	int retval;
+
+	/* clear the interrupt */
+	writel(0, &ha->qla4_8xxx_reg->host_int);
+	readl(&ha->qla4_8xxx_reg->host_int);
+
 	retval = qla4_8xxx_device_state_handler(ha);
 
 	if (retval == QLA_SUCCESS && !test_bit(AF_INIT_DONE, &ha->flags))
-- 
1.7.8.rc2.3.g0911


