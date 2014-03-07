From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH] qla2xxx: Fixup looking for a space in the outstanding_cmds array in qla2x00_alloc_iocbs().
Date: Fri, 7 Mar 2014 02:43:52 -0500
Message-ID: <1394178232-2070-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:38722 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbaCGIUI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Mar 2014 03:20:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8c5dec2..e607568 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1814,7 +1814,7 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 
 	/* Check for room in outstanding command list. */
 	handle = req->current_outstanding_cmd;
-	for (index = 1; req->num_outstanding_cmds; index++) {
+	for (index = 1; index < req->num_outstanding_cmds; index++) {
 		handle++;
 		if (handle == req->num_outstanding_cmds)
 			handle = 1;
-- 
1.7.7

