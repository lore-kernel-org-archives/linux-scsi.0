From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 02/22] be2iscsi: Fix the MCCQ count leakage
Date: Thu, 12 Sep 2013 22:09:52 -0700
Message-ID: <1379049014-32716-2-git-send-email-jayamohan.kallickal@emulex.com>
References: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39600 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab3IMFgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 01:36:19 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so784062pdi.5
        for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2013 22:36:18 -0700 (PDT)
In-Reply-To: <1379049014-32716-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 When MBX CMD is posted in MCCQ and if command times out,during
 mccq resource cleanup for the timed out command  mccq->count
 was not decremented. The led to BUG_ON being hit.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index bb70dcb..f7788e5 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -174,6 +174,10 @@ int beiscsi_mccq_compl(struct beiscsi_hba *phba,
 			    BEISCSI_LOG_CONFIG,
 			    "BC_%d : MBX Cmd Completion timed out\n");
 		rc = -EAGAIN;
+
+		/* decrement the mccq used count */
+		atomic_dec(&phba->ctrl.mcc_obj.q.used);
+
 		goto release_mcc_tag;
 	} else
 		rc = 0;
@@ -699,7 +703,7 @@ struct be_mcc_wrb *wrb_from_mccq(struct beiscsi_hba *phba)
 	struct be_queue_info *mccq = &phba->ctrl.mcc_obj.q;
 	struct be_mcc_wrb *wrb;
 
-	BUG_ON(atomic_read(&mccq->used) >= mccq->len);
+	WARN_ON(atomic_read(&mccq->used) >= mccq->len);
 	wrb = queue_head_node(mccq);
 	memset(wrb, 0, sizeof(*wrb));
 	wrb->tag0 = (mccq->head & 0x000000FF) << 16;
-- 
1.7.10.4

