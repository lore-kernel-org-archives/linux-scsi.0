From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 03/14] qla2xxx: Increase the wait time for firmware to be ready for P3P.
Date: Thu, 9 Apr 2015 14:59:57 -0400
Message-ID: <1428606008-14976-4-git-send-email-himanshu.madhani@qlogic.com>
References: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:10087 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933300AbbDITmH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 15:42:07 -0400
In-Reply-To: <1428606008-14976-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e59f25b..cb294e5 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2243,8 +2243,11 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 
 	rval = QLA_SUCCESS;
 
-	/* 20 seconds for loop down. */
-	min_wait = 20;
+	/* Time to wait for loop down */
+	if (IS_P3P_TYPE(ha))
+		min_wait = 30;
+	else
+		min_wait = 20;
 
 	/*
 	 * Firmware should take at most one RATOV to login, plus 5 seconds for
-- 
1.7.7

