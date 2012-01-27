From: Krishna Gudipati <kgudipat@Brocade.com>
Subject: RE: [PATCH] SCSI, bfa: don't leak mem in
 bfad_im_bsg_els_ct_request()
Date: Fri, 27 Jan 2012 15:36:11 -0800
Message-ID: <B5EE62D80D50B84BB9E5174F7FCCE80A260325B189@HQ1-EXCH02.corp.brocade.com>
References: <alpine.LNX.2.00.1201280021320.13952@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1201280021320.13952@swampdragon.chaosbits.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: 'Jesper Juhl' <jj@chaosbits.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, Krishna Gudipati <kgudipat@Brocade.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Jing Huang <huangj@Brocade.COM>, "'James E.J. Bottomley'" <JBottomley@parallels.com>, 'Joe Perches' <joe@perches.com>
List-Id: linux-scsi@vger.kernel.org

Looks good. Thanks for the patch.

Acked-by: Krishna Gudipati <kgudipat@brocade.com>

---------------

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

