From: akpm@linux-foundation.org
Subject: [patch 21/26] drivers/scsi/bfa/bfad_im.c: eliminate useless code
Date: Thu, 11 Mar 2010 14:09:55 -0800
Message-ID: <201003112209.o2BM9tkd013676@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758348Ab0CKWKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:10:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk, huangj@brocade.com

From: Julia Lawall <julia@diku.dk>

The variable bfa_itnim is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Jing Huang <huangj@brocade.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/bfad_im.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/scsi/bfa/bfad_im.c~drivers-scsi-bfa-bfad_imc-eliminate-useless-code drivers/scsi/bfa/bfad_im.c
--- a/drivers/scsi/bfa/bfad_im.c~drivers-scsi-bfa-bfad_imc-eliminate-useless-code
+++ a/drivers/scsi/bfa/bfad_im.c
@@ -251,7 +251,6 @@ bfad_im_target_reset_send(struct bfad_s 
 	struct bfa_itnim_s *bfa_itnim;
 	bfa_status_t    rc = BFA_STATUS_OK;
 
-	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
 		BFA_DEV_PRINTF(bfad, BFA_ERR,
_
