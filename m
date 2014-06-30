From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] [SCSI] bfa: use ARRAY_SIZE instead of sizeof/sizeof[0]
Date: Mon, 30 Jun 2014 19:42:42 +0200
Message-ID: <1404150162-7973-1-git-send-email-fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use macro definition

Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/scsi/bfa/bfa_fcs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index a3ab5cc..0f19455 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -81,7 +81,7 @@ bfa_fcs_attach(struct bfa_fcs_s *fcs, struct bfa_s *bfa, struct bfad_s *bfad,
 	bfa->fcs = BFA_TRUE;
 	fcbuild_init();
 
-	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
 		mod = &fcs_modules[i];
 		if (mod->attach)
 			mod->attach(fcs);
@@ -97,7 +97,7 @@ bfa_fcs_init(struct bfa_fcs_s *fcs)
 	int	i;
 	struct bfa_fcs_mod_s  *mod;
 
-	for (i = 0; i < sizeof(fcs_modules) / sizeof(fcs_modules[0]); i++) {
+	for (i = 0; i < ARRAY_SIZE(fcs_modules); i++) {
 		mod = &fcs_modules[i];
 		if (mod->modinit)
 			mod->modinit(fcs);
@@ -184,7 +184,7 @@ bfa_fcs_exit(struct bfa_fcs_s *fcs)
 
 	bfa_wc_init(&fcs->wc, bfa_fcs_exit_comp, fcs);
 
-	nmods = sizeof(fcs_modules) / sizeof(fcs_modules[0]);
+	nmods = ARRAY_SIZE(fcs_modules);
 
 	for (i = 0; i < nmods; i++) {
 
-- 
1.8.4.5
