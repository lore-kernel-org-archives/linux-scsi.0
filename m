From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 02/11] qla2xxx: Add check for null fcport references in qla2xxx_queuecommand.
Date: Thu, 9 Feb 2012 11:14:04 -0800
Message-ID: <1328814853-21764-3-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:21195
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445Ab2BITa2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:28 -0500
Received: from mail184-ch1 (localhost [127.0.0.1])	by
 mail184-ch1-R.bigfish.com (Postfix) with ESMTP id 256054E029E	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:30:28 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b4b185c..5fd89d7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -625,6 +625,12 @@ qla2xxx_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 			cmd->result = DID_NO_CONNECT << 16;
 			goto qc24_fail_command;
 	}
+
+	if (!fcport) {
+		cmd->result = DID_NO_CONNECT << 16;
+		goto qc24_fail_command;
+	}
+
 	if (atomic_read(&fcport->state) != FCS_ONLINE) {
 		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
 			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
-- 
1.6.0.2


