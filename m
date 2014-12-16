From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [SCSI] bfa: fix bfa_fcb_itnim_alloc() error handling
Date: Wed, 17 Dec 2014 02:51:44 +0300
Message-ID: <20141216235144.GA31467@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35197 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbaLPXw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2014 18:52:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

The caller assumes that "itnim" is NULL on error and non-NULL on
success but really "itnim" is uninitialized on error.  This
function should just use normal error handling where it returns zero on
success and negative on failure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Static checker stuff.  Not tested.

diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 42bcb97..af220e9 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -873,8 +873,8 @@ bfa_status_t bfa_fcb_rport_alloc(struct bfad_s *bfad,
 /*
  * itnim callbacks
  */
-void bfa_fcb_itnim_alloc(struct bfad_s *bfad, struct bfa_fcs_itnim_s **itnim,
-			 struct bfad_itnim_s **itnim_drv);
+int bfa_fcb_itnim_alloc(struct bfad_s *bfad, struct bfa_fcs_itnim_s **itnim,
+			struct bfad_itnim_s **itnim_drv);
 void bfa_fcb_itnim_free(struct bfad_s *bfad,
 			struct bfad_itnim_s *itnim_drv);
 void bfa_fcb_itnim_online(struct bfad_itnim_s *itnim_drv);
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 7223b00..31426ae 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -413,13 +413,13 @@ bfad_im_slave_destroy(struct scsi_device *sdev)
  * BFA FCS itnim alloc callback, after successful PRLI
  * Context: Interrupt
  */
-void
+int
 bfa_fcb_itnim_alloc(struct bfad_s *bfad, struct bfa_fcs_itnim_s **itnim,
 		    struct bfad_itnim_s **itnim_drv)
 {
 	*itnim_drv = kzalloc(sizeof(struct bfad_itnim_s), GFP_ATOMIC);
 	if (*itnim_drv == NULL)
-		return;
+		return -ENOMEM;
 
 	(*itnim_drv)->im = bfad->im;
 	*itnim = &(*itnim_drv)->fcs_itnim;
@@ -430,6 +430,7 @@ bfa_fcb_itnim_alloc(struct bfad_s *bfad, struct bfa_fcs_itnim_s **itnim,
 	 */
 	INIT_WORK(&(*itnim_drv)->itnim_work, bfad_im_itnim_work_handler);
 	bfad->bfad_flags |= BFAD_RPORT_ONLINE;
+	return 0;
 }
 
 /*
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 6dc7926..829247e 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -587,12 +587,13 @@ bfa_fcs_itnim_create(struct bfa_fcs_rport_s *rport)
 	struct bfa_fcs_lport_s *port = rport->port;
 	struct bfa_fcs_itnim_s *itnim;
 	struct bfad_itnim_s   *itnim_drv;
+	int ret;
 
 	/*
 	 * call bfad to allocate the itnim
 	 */
-	bfa_fcb_itnim_alloc(port->fcs->bfad, &itnim, &itnim_drv);
-	if (itnim == NULL) {
+	ret = bfa_fcb_itnim_alloc(port->fcs->bfad, &itnim, &itnim_drv);
+	if (ret) {
 		bfa_trc(port->fcs, rport->pwwn);
 		return NULL;
 	}
