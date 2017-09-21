From: Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 1/1] drivers:scsi: use setup_timer
Date: Thu, 21 Sep 2017 17:13:46 +0530
Message-ID: <1505994226-11265-1-git-send-email-allen.lkml@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>
List-Id: linux-scsi@vger.kernel.org

    Use setup_timer function instead of initializing timer with the
    function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/sym53c8xx_2/sym_glue.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d32e3ba..285397d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1351,9 +1351,7 @@ static struct Scsi_Host *sym_attach(struct scsi_host_template *tpnt, int unit,
 	/*
 	 *  Start the timer daemon
 	 */
-	init_timer(&np->s.timer);
-	np->s.timer.data     = (unsigned long) np;
-	np->s.timer.function = sym53c8xx_timer;
+	setup_timer(&np->s.timer, sym53c8xx_timer, (unsigned long)np);
 	np->s.lasttime=0;
 	sym_timer (np);
 
-- 
2.7.4
