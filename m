From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 02/15] qla4xxx: honor return status of qla4xxx_hw_reset
Date: Wed, 6 Oct 2010 22:48:07 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87129406785@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:37488 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab0JGFsJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2010 01:48:09 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b24bf96..6e59b59 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -935,11 +935,14 @@ int qla4xxx_soft_reset(struct scsi_qla_host *ha)
 {
 	uint32_t max_wait_time;
 	unsigned long flags = 0;
-	int status = QLA_ERROR;
+	int status;
 	uint32_t ctrl_status;
 
-	qla4xxx_hw_reset(ha);
+	status = qla4xxx_hw_reset(ha);
+	if (status != QLA_SUCCESS)
+		return status;
 
+	status = QLA_ERROR;
 	/* Wait until the Network Reset Intr bit is cleared */
 	max_wait_time = RESET_INTR_TOV;
 	do {
-- 
1.6.6

