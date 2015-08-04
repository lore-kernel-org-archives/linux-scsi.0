From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  11/14] qla2xxx: do not clear slot in outstanding cmd array
Date: Tue, 4 Aug 2015 13:38:01 -0400
Message-ID: <1438709884-623-12-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:3255 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752820AbbHDSXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:47 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 55a53ed..94d7a6d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -981,12 +981,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	/*
-	 * Clear the slot in the oustanding_cmds array if we can't find the
-	 * command to reclaim the resources.
-	 */
-	if (rval == QLA_FUNCTION_PARAMETER_ERROR)
-		vha->req->outstanding_cmds[sp->handle] = NULL;
 	sp->done(ha, sp, 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-- 
1.7.7

