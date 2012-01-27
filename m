From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] SCSI, bfa: don't leak mem in bfad_im_bsg_els_ct_request()
Date: Sat, 28 Jan 2012 00:23:41 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1201280021320.13952@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Joe Perches <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

If 'drv_fcxp = kzalloc(sizeof(struct bfad_fcxp), GFP_KERNEL);' fails
and returns NULL, then we'll leak the memory allocated to 'bsg_fcpt'
when we jump to 'out:' and the variable subsequently goes out of
scope.

Also remove the cast of the kzalloc() return value. kzalloc() returns
a void* which is implicitly converted, so the explicit cast is
pointless.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/scsi/bfa/bfad_bsg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

 Compile tested only, as I have no hardware to test for real.

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 530de2b..8005c6c 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3047,8 +3047,7 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 	 * Allocate buffer for bsg_fcpt and do a copy_from_user op for payload
 	 * buffer of size bsg_data->payload_len
 	 */
-	bsg_fcpt = (struct bfa_bsg_fcpt_s *)
-		   kzalloc(bsg_data->payload_len, GFP_KERNEL);
+	bsg_fcpt = kzalloc(bsg_data->payload_len, GFP_KERNEL);
 	if (!bsg_fcpt)
 		goto out;
 
@@ -3060,6 +3059,7 @@ bfad_im_bsg_els_ct_request(struct fc_bsg_job *job)
 
 	drv_fcxp = kzalloc(sizeof(struct bfad_fcxp), GFP_KERNEL);
 	if (drv_fcxp == NULL) {
+		kfree(bsg_fcpt);
 		rc = -ENOMEM;
 		goto out;
 	}
-- 
1.7.8.4


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
