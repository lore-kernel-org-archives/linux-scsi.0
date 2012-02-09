From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 01/11] qla2xxx: Propagate up abort failures.
Date: Thu, 9 Feb 2012 11:14:03 -0800
Message-ID: <1328814853-21764-2-git-send-email-chad.dupuis@qlogic.com>
References: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:36994
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758272Ab2BITa3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:30:29 -0500
Received: from mail79-ch1 (localhost [127.0.0.1])	by mail79-ch1-R.bigfish.com
 (Postfix) with ESMTP id 9212E4E0458	for <linux-scsi@vger.kernel.org>; Thu,  9
 Feb 2012 19:30:28 +0000 (UTC)
In-Reply-To: <1328814853-21764-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Arun Easi <arun.easi@qlogic.com>

Signed-off-by: Arun Easi <arun.easi@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4ed1e4a..b4b185c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -877,6 +877,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	if (ha->isp_ops->abort_command(sp)) {
+		ret = FAILED;
 		ql_dbg(ql_dbg_taskm, vha, 0x8003,
 		    "Abort command mbx failed cmd=%p.\n", cmd);
 	} else {
-- 
1.6.0.2


