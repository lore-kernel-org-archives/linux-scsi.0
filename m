From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 28/31] qla2xxx: Skip zero queue count entry during FW dump capture
Date: Wed, 23 Aug 2017 15:05:22 -0700
Message-ID: <20170823220525.3115-29-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0084.outbound.protection.outlook.com ([104.47.33.84]:19264
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751005AbdHWWkk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:40:40 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

If queue count is zero while reading FW dump template, for entry
T263/T274, skip capturing those entries during FW dump capture.

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index b18646d6057f..733e8dcccf5c 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -443,8 +443,12 @@ qla27xx_fwdt_entry_t263(struct scsi_qla_host *vha,
 		qla27xx_skip_entry(ent, buf);
 	}
 
-	if (buf)
-		ent->t263.num_queues = count;
+	if (buf) {
+		if (count)
+			ent->t263.num_queues = count;
+		else
+			qla27xx_skip_entry(ent, buf);
+	}
 
 	return false;
 }
@@ -692,11 +696,12 @@ qla27xx_fwdt_entry_t274(struct scsi_qla_host *vha,
 		qla27xx_skip_entry(ent, buf);
 	}
 
-	if (buf)
-		ent->t274.num_queues = count;
-
-	if (!count)
-		qla27xx_skip_entry(ent, buf);
+	if (buf) {
+		if (count)
+			ent->t274.num_queues = count;
+		else
+			qla27xx_skip_entry(ent, buf);
+	}
 
 	return false;
 }
-- 
2.12.0
