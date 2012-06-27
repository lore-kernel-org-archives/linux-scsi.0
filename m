From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch -resend] [SCSI] bfa: dereferencing freed memory in
 bfad_im_probe()
Date: Wed, 27 Jun 2012 11:59:58 +0300
Message-ID: <20120627085958.GB31212@elgon.mountain>
References: <20120627085800.GA3007@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: Krishna C Gudipati <kgudipat@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If bfad_thread_workq(bfad) was not BFA_STATUS_OK then we freed "im"
and then dereferenced it.

I did a little clean up because it seemed nicer to return directly
instead of doing a superfluous goto.  I looked at other functions in
this file and it seems like returning directly is standard.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
This is the third time I have sent this patch.  It was previously sent
on Fri, 29 Jul 2011 and Wed, 29 Feb 2012.

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 1ac09af..2eebf8d 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -687,25 +687,21 @@ bfa_status_t
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
