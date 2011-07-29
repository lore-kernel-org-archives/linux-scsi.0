From: Dan Carpenter <error27@gmail.com>
Subject: [patch] [SCSI] bfa: dereferencing freed memory in bfad_im_probe()
Date: Fri, 29 Jul 2011 11:53:06 +0300
Message-ID: <20110729085306.GH3752@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42023 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1G2IzH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2011 04:55:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "open list:BROCADE BFA FC SC..." <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org

If bfad_thread_workq(bfad) was not BFA_STATUS_OK then we freed "im"
and then dereferenced it.

I did a little clean up because it seemed nicer to return directly
instead of doing a superfluous goto.  I looked at other functions in
this file and it seems like returning directly is standard.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 0131238..7f7cca0 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -685,25 +685,21 @@ bfa_status_t
 bfad_im_probe(struct bfad_s *bfad)
 {
 	struct bfad_im_s      *im;
-	bfa_status_t    rc = BFA_STATUS_OK;
 
 	im = kzalloc(sizeof(struct bfad_im_s), GFP_KERNEL);
-	if (im == NULL) {
-		rc = BFA_STATUS_ENOMEM;
-		goto ext;
-	}
+	if (im == NULL)
+		return BFA_STATUS_ENOMEM;
 
 	bfad->im = im;
 	im->bfad = bfad;
 
 	if (bfad_thread_workq(bfad) != BFA_STATUS_OK) {
 		kfree(im);
-		rc = BFA_STATUS_FAILED;
+		return BFA_STATUS_FAILED;
 	}
 
 	INIT_WORK(&im->aen_im_notify_work, bfad_aen_im_notify_handler);
-ext:
-	return rc;
+	return BFA_STATUS_OK;
 }
 
 void
