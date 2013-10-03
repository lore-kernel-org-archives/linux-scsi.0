From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: Remove entry in outstanding_cmds array if we fail to abort a request.
Date: Thu, 3 Oct 2013 03:21:14 -0400
Message-ID: <1380784874-15457-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1380784874-15457-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:38417 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561Ab3JCHwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2013 03:52:11 -0400
In-Reply-To: <1380784874-15457-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

If the call to abort a request fails we need to clear it's entry in the in-flight
commands array as it won't be cleared in interrupt context.  Not doing so could
potentially lead to a double completion.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9f01bbb..66ed1c9 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -951,6 +951,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
+	uint32_t handle = 0;
 
 	if (!CMD_SP(cmd))
 		return SUCCESS;
@@ -989,7 +990,14 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
+	handle = sp->handle;
 	sp->done(ha, sp, 0);
+	/*
+	 * If the mailbox command failed, clear the entry in the in-flight
+	 * commands array as the entry won't be cleared in interrupt context.
+	 */
+	if (ret == FAILED)
+		vha->req->outstanding_cmds[handle] = NULL;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Did the command return during mailbox execution? */
-- 
1.7.7

