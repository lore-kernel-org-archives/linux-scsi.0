From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 5/9] drivers/scsi: Eliminate useless code
Date: Sat, 16 Jan 2010 16:58:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1001161658410.28745@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754961Ab0APP7H@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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

---
 drivers/scsi/bfa/bfad_im.c          |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f788c2a..37b0fa1 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -243,9 +243,8 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct scsi_cmnd *cmnd,
 	struct bfa_itnim_s *bfa_itnim;
 	bfa_status_t    rc = BFA_STATUS_OK;
 
-	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
 	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
 	if (!tskim) {
 		BFA_DEV_PRINTF(bfad, BFA_ERR,
