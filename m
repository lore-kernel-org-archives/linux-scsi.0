From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  10/14] qla2xxx: Remove decrement of sp reference count in abort handler.
Date: Tue, 4 Aug 2015 13:38:00 -0400
Message-ID: <1438709884-623-11-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:5146 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753110AbbHDSXy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:54 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Fix for memory leak when command is not found by firmware due to
mismatch in sp reference count.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8208f6a0..55a53ed 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -967,14 +967,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	rval = ha->isp_ops->abort_command(sp);
 	if (rval) {
-		if (rval == QLA_FUNCTION_PARAMETER_ERROR) {
-			/*
-			 * Decrement the ref_count since we can't find the
-			 * command
-			 */
-			atomic_dec(&sp->ref_count);
+		if (rval == QLA_FUNCTION_PARAMETER_ERROR)
 			ret = SUCCESS;
-		} else
+		else
 			ret = FAILED;
 
 		ql_dbg(ql_dbg_taskm, vha, 0x8003,
-- 
1.7.7

