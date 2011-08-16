From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 4/9] qla2xxx: Acquire hardware lock while manipulating dsd list.
Date: Tue, 16 Aug 2011 11:29:25 -0700
Message-ID: <1313519370-22963-5-git-send-email-chad.dupuis@qlogic.com>
References: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:24011 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752861Ab1HPSje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Aug 2011 14:39:34 -0400
In-Reply-To: <1313519370-22963-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

The dsd list shouldn't be manipulated without taking the per host hardware
lock to prevent multiple callers from trampling upon one another.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f57c292..2caab83 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -913,7 +913,10 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		    "Abort command mbx success.\n");
 		wait = 1;
 	}
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qla2x00_sp_compl(ha, sp);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Wait for the command to be returned. */
 	if (wait) {
-- 
1.6.0.2


