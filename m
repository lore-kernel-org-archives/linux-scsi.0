From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] tcm_loop: Fixup tag handling
Date: Thu,  2 Oct 2014 09:30:55 +0200
Message-ID: <1412235055-78477-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbaJBHa6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 03:30:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The SCSI command tag is set to the tag assigned from the block
layer, not the SCSI-II tag message. So we need to convert
it into the correct SCSI-II tag message based on the
device flags, not the tag value itself.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/loopback/tcm_loop.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 340de9d..c2a9370 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -153,18 +153,11 @@ static int tcm_loop_change_queue_type(struct scsi_device *sdev, int tag)
 /*
  * Locate the SAM Task Attr from struct scsi_cmnd *
  */
-static int tcm_loop_sam_attr(struct scsi_cmnd *sc)
-{
-	if (sc->device->tagged_supported) {
-		switch (sc->tag) {
-		case HEAD_OF_QUEUE_TAG:
-			return MSG_HEAD_TAG;
-		case ORDERED_QUEUE_TAG:
-			return MSG_ORDERED_TAG;
-		default:
-			break;
-		}
-	}
+static int tcm_loop_sam_attr(struct scsi_cmnd *sc, int tag)
+{
+	if (sc->device->tagged_supported &&
+	    sc->device->ordered_tags && tag >= 0)
+		return MSG_ORDERED_TAG;
 
 	return MSG_SIMPLE_TAG;
 }
@@ -227,7 +220,7 @@ static void tcm_loop_submission_work(struct work_struct *work)
 
 	rc = target_submit_cmd_map_sgls(se_cmd, tl_nexus->se_sess, sc->cmnd,
 			&tl_cmd->tl_sense_buf[0], tl_cmd->sc->device->lun,
-			transfer_length, tcm_loop_sam_attr(sc),
+			transfer_length, tcm_loop_sam_attr(sc, tl_cmd->sc_cmd_tag),
 			sc->sc_data_direction, 0,
 			scsi_sglist(sc), scsi_sg_count(sc),
 			sgl_bidi, sgl_bidi_count,
@@ -266,7 +259,7 @@ static int tcm_loop_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	}
 
 	tl_cmd->sc = sc;
-	tl_cmd->sc_cmd_tag = sc->tag;
+	tl_cmd->sc_cmd_tag = sc->request->tag;
 	INIT_WORK(&tl_cmd->work, tcm_loop_submission_work);
 	queue_work(tcm_loop_workqueue, &tl_cmd->work);
 	return 0;
@@ -370,7 +363,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
 	 */
 	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
 	ret = tcm_loop_issue_tmr(tl_tpg, tl_nexus, sc->device->lun,
-				 sc->tag, TMR_ABORT_TASK);
+				 sc->request->tag, TMR_ABORT_TASK);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
-- 
1.8.5.2

