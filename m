From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 07/11] qla2xxx: Remove check for null fcport from host reset handler.
Date: Thu, 9 Feb 2012 11:14:09 -0800
Message-ID: <1328814853-21764-8-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39843
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758295Ab2BITaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:30 -0500
Received: from mail47-ch1 (localhost [127.0.0.1])	by mail47-ch1-R.bigfish.com
 (Postfix) with ESMTP id A597C260533	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:30:29 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Michael Christie <mchristi@redhat.com>

Remove the check for a NULL fcport so that the host reset will run
unconditionally to unwedge any commands before the device is offlined and to
prevent a quick runthrough of the SCSI error handling.

Signed-off-by: Michael Christie <mchristi@redhat.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7e617a6..036030c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1131,7 +1131,6 @@ static int
 qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	struct qla_hw_data *ha = vha->hw;
 	int ret = FAILED;
 	unsigned int id, lun;
@@ -1140,15 +1139,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 
-	if (!fcport) {
-		return ret;
-	}
-
-	ret = fc_block_scsi_eh(cmd);
-	if (ret != 0)
-		return ret;
-	ret = FAILED;
-
 	ql_log(ql_log_info, vha, 0x8018,
 	    "ADAPTER RESET ISSUED nexus=%ld:%d:%d.\n", vha->host_no, id, lun);
 
-- 
1.6.0.2


