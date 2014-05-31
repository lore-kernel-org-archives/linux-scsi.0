From: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 5/11] drivers/scsi/bfa/bfad_bsg.c: Remove useless return variables
Date: Sat, 31 May 2014 10:14:05 -0300
Message-ID: <1401542051-3174-5-git-send-email-peter.senna@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: kernel-janitors@vger.kernel.org, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch remove variables that are initialized with a constant,
are never updated, and are only used as parameter of return.
Return the constant instead of using a variable.

Verified by compilation only.

The coccinelle script that find and fixes this issue is:
// <smpl>
@@
type T;
constant C;
identifier ret;
@@
- T ret = C;
... when != ret
    when strict
return
- ret
+ C
;
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/scsi/bfa/bfad_bsg.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 8994fb8..a6ee1cf 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -26,7 +26,6 @@ int
 bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
-	int	rc = 0;
 	unsigned long	flags;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
@@ -34,7 +33,7 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 	if (!bfa_ioc_is_disabled(&bfad->bfa.ioc)) {
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		iocmd->status = BFA_STATUS_OK;
-		return rc;
+		return 0;
 	}
 
 	init_completion(&bfad->enable_comp);
@@ -43,21 +42,20 @@ bfad_iocmd_ioc_enable(struct bfad_s *bfad, void *cmd)
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	wait_for_completion(&bfad->enable_comp);
 
-	return rc;
+	return 0;
 }
 
 int
 bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
-	int	rc = 0;
 	unsigned long	flags;
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	if (bfa_ioc_is_disabled(&bfad->bfa.ioc)) {
 		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 		iocmd->status = BFA_STATUS_OK;
-		return rc;
+		return 0;
 	}
 
 	if (bfad->disable_active) {
@@ -74,7 +72,7 @@ bfad_iocmd_ioc_disable(struct bfad_s *bfad, void *cmd)
 	bfad->disable_active = BFA_FALSE;
 	iocmd->status = BFA_STATUS_OK;
 
-	return rc;
+	return 0;
 }
 
 static int
