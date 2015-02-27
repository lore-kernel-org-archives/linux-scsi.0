From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH -resend 1/1] bfs: bfad_worker cleanup
Date: Fri, 27 Feb 2015 16:01:28 +0100
Message-ID: <1425049288-16901-1-git-send-email-jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: akpm@linux-foundation.org, anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
List-Id: linux-scsi@vger.kernel.org

This kthread is not loop at all due to break at the end of the loop.
Make that function linear, with no while loop.

And remove an unnecessary cast.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/bfa/bfad.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index e90a3742f09d..cc3b9d3d6d40 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1079,22 +1079,18 @@ bfad_start_ops(struct bfad_s *bfad) {
 int
 bfad_worker(void *ptr)
 {
-	struct bfad_s *bfad;
-	unsigned long   flags;
-
-	bfad = (struct bfad_s *)ptr;
-
-	while (!kthread_should_stop()) {
+	struct bfad_s *bfad = ptr;
+	unsigned long flags;
 
-		/* Send event BFAD_E_INIT_SUCCESS */
-		bfa_sm_send_event(bfad, BFAD_E_INIT_SUCCESS);
+	if (kthread_should_stop())
+		return 0;
 
-		spin_lock_irqsave(&bfad->bfad_lock, flags);
-		bfad->bfad_tsk = NULL;
-		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	/* Send event BFAD_E_INIT_SUCCESS */
+	bfa_sm_send_event(bfad, BFAD_E_INIT_SUCCESS);
 
-		break;
-	}
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	bfad->bfad_tsk = NULL;
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 
 	return 0;
 }
-- 
2.3.0
