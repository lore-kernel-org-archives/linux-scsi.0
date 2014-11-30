From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 2/4] drivers/scsi/bfa/bfa_svc.c: remove unneeded structure
Date: Sun, 30 Nov 2014 19:14:13 +0100
Message-ID: <1417371255-2282-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417371255-2282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: kernel-janitors@vger.kernel.org, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete a local structure that is only used to be initialized by memset.

A semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x,i;
@@

{
... when any
-struct i x;
<+... when != x
- memset(&x,...);
...+>
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/bfa/bfa_svc.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 625225f..cf46683 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -404,13 +404,10 @@ bfa_plog_fchdr(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 			enum bfa_plog_eid event,
 			u16 misc, struct fchs_s *fchdr)
 {
-	struct bfa_plog_rec_s  lp;
 	u32	*tmp_int = (u32 *) fchdr;
 	u32	ints[BFA_PL_INT_LOG_SZ];
 
 	if (plog->plog_enabled) {
-		memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
-
 		ints[0] = tmp_int[0];
 		ints[1] = tmp_int[1];
 		ints[2] = tmp_int[4];
@@ -424,13 +421,10 @@ bfa_plog_fchdr_and_pl(struct bfa_plog_s *plog, enum bfa_plog_mid mid,
 		      enum bfa_plog_eid event, u16 misc, struct fchs_s *fchdr,
 		      u32 pld_w0)
 {
-	struct bfa_plog_rec_s  lp;
 	u32	*tmp_int = (u32 *) fchdr;
 	u32	ints[BFA_PL_INT_LOG_SZ];
 
 	if (plog->plog_enabled) {
-		memset(&lp, 0, sizeof(struct bfa_plog_rec_s));
-
 		ints[0] = tmp_int[0];
 		ints[1] = tmp_int[1];
 		ints[2] = tmp_int[4];
