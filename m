From: Vijaya Mohan Guvva <vmohan@brocade.com>
Subject: [PATCH V1 16/17] bfa: dis-associate bfa path_tov with dev_loss_tmo
Date: Mon, 13 May 2013 02:33:34 -0700
Message-ID: <1368437615-9867-17-git-send-email-vmohan@brocade.com>
References: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:50388 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab3EMJwy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 May 2013 05:52:54 -0400
In-Reply-To: <1368437615-9867-1-git-send-email-vmohan@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, adapter_linux_open_src_team@Brocade.COM, Vijaya Mohan Guvva <vmohan@Brocade.COM>

Disassoicate path_tov in the driver with the dev_loss_tmo set by the
application.

Signed-off-by: Vijaya Mohan Guvva <vmohan@brocade.com>
---
 drivers/scsi/bfa/bfad_attr.c | 33 +++++++--------------------------
 1 file changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 72f5dc3..e9a681d 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -335,23 +335,10 @@ bfad_im_reset_stats(struct Scsi_Host *shost)
 }
 
 /*
- * FC transport template entry, get rport loss timeout.
- */
-static void
-bfad_im_get_rport_loss_tmo(struct fc_rport *rport)
-{
-	struct bfad_itnim_data_s *itnim_data = rport->dd_data;
-	struct bfad_itnim_s   *itnim = itnim_data->itnim;
-	struct bfad_s         *bfad = itnim->im->bfad;
-	unsigned long   flags;
-
-	spin_lock_irqsave(&bfad->bfad_lock, flags);
-	rport->dev_loss_tmo = bfa_fcpim_path_tov_get(&bfad->bfa);
-	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-}
-
-/*
  * FC transport template entry, set rport loss timeout.
+ * Update dev_loss_tmo based on the value pushed down by the stack
+ * In case it is lesser than path_tov of driver, set it to path_tov + 1
+ * to ensure that the driver times out before the application
  */
 static void
 bfad_im_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
@@ -359,15 +346,11 @@ bfad_im_set_rport_loss_tmo(struct fc_rport *rport, u32 timeout)
 	struct bfad_itnim_data_s *itnim_data = rport->dd_data;
 	struct bfad_itnim_s   *itnim = itnim_data->itnim;
 	struct bfad_s         *bfad = itnim->im->bfad;
-	unsigned long   flags;
-
-	if (timeout > 0) {
-		spin_lock_irqsave(&bfad->bfad_lock, flags);
-		bfa_fcpim_path_tov_set(&bfad->bfa, timeout);
-		rport->dev_loss_tmo = bfa_fcpim_path_tov_get(&bfad->bfa);
-		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
-	}
+	uint16_t path_tov = bfa_fcpim_path_tov_get(&bfad->bfa);
 
+	rport->dev_loss_tmo = timeout;
+	if (timeout < path_tov)
+		rport->dev_loss_tmo = path_tov + 1;
 }
 
 static int
@@ -665,7 +648,6 @@ struct fc_function_template bfad_im_fc_function_template = {
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
 	.show_rport_dev_loss_tmo = 1,
-	.get_rport_dev_loss_tmo = bfad_im_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = bfad_im_set_rport_loss_tmo,
 	.issue_fc_host_lip = bfad_im_issue_fc_host_lip,
 	.vport_create = bfad_im_vport_create,
@@ -723,7 +705,6 @@ struct fc_function_template bfad_im_vport_fc_function_template = {
 	.show_rport_maxframe_size = 1,
 	.show_rport_supported_classes = 1,
 	.show_rport_dev_loss_tmo = 1,
-	.get_rport_dev_loss_tmo = bfad_im_get_rport_loss_tmo,
 	.set_rport_dev_loss_tmo = bfad_im_set_rport_loss_tmo,
 };
 
-- 
1.7.12

