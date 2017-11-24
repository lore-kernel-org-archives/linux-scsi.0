From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: bfa: use setup_timer instead of init_timer
Date: Fri, 24 Nov 2017 13:44:02 +0000
Message-ID: <20171124134402.32739-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Use setup_timer function instead of initializing timer with the
function and data fields.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bfa/bfad.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 5caf5f3ff642..c910b238bc9e 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -719,10 +719,7 @@ bfad_bfa_tmo(unsigned long data)
 void
 bfad_init_timer(struct bfad_s *bfad)
 {
-	init_timer(&bfad->hal_tmo);
-	bfad->hal_tmo.function = bfad_bfa_tmo;
-	bfad->hal_tmo.data = (unsigned long)bfad;
-
+	setup_timer(&bfad->hal_tmo, bfad_bfa_tmo, (unsigned long)bfad);
 	mod_timer(&bfad->hal_tmo,
 		  jiffies + msecs_to_jiffies(BFA_TIMER_FREQ));
 }
-- 
2.14.1
