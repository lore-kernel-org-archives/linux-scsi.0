From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/6] qla2xxx: Correct slab-error overwrite during vport creation and deletion.
Date: Sun,  8 Feb 2009 20:50:13 -0800
Message-ID: <1234155016-6215-4-git-send-email-andrew.vasquez@qlogic.com>
References: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7132 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbZBIEu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 23:50:26 -0500
In-Reply-To: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

The clearing of a vha's req_ques were overrunning during vport
creation.  During deletion, vport queues should be torn-down
after all cleanup has occurred.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   13 ++++++-------
 drivers/scsi/qla2xxx/qla_mid.c  |    2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 33a3c13..f4c5722 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1265,13 +1265,6 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	    test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags))
 		msleep(1000);
 
-	if (ha->mqenable) {
-		if (qla25xx_delete_queues(vha, 0) != QLA_SUCCESS)
-			qla_printk(KERN_WARNING, ha,
-				"Queue delete failed.\n");
-		vha->req_ques[0] = ha->req_q_map[0]->id;
-	}
-
 	qla24xx_disable_vp(vha);
 
 	fc_remove_host(vha->host);
@@ -1293,6 +1286,12 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 		    vha->host_no, vha->vp_idx, vha));
         }
 
+	if (ha->mqenable) {
+		if (qla25xx_delete_queues(vha, 0) != QLA_SUCCESS)
+			qla_printk(KERN_WARNING, ha,
+				"Queue delete failed.\n");
+	}
+
 	scsi_host_put(vha->host);
 	qla_printk(KERN_INFO, ha, "vport %d deleted\n", id);
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index d27ceda..3f23932 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -396,7 +396,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
 
-	memset(vha->req_ques, 0, sizeof(vha->req_ques) * QLA_MAX_HOST_QUES);
+	memset(vha->req_ques, 0, sizeof(vha->req_ques));
 	vha->req_ques[0] = ha->req_q_map[0]->id;
 	host->can_queue = ha->req_q_map[0]->length + 128;
 	host->this_id = 255;
-- 
1.6.1.48.ge9b8

