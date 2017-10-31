From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 4/4] scsi: qla2xxx: Convert qla2x00_sp_timeout() to use timer_setup()
Date: Tue, 31 Oct 2017 12:13:49 -0700
Message-ID: <1509477229-62141-5-git-send-email-keescook@chromium.org>
References: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Kees Cook <keescook@chromium.org>, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer
to all timer callbacks, switch to using the new timer_setup() and
from_timer() to pass the timer pointer explicitly for the
qla2x00_sp_timeout() callback and associated timer.

Cc: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h    | 2 +-
 drivers/scsi/qla2xxx/qla_init.c   | 4 ++--
 drivers/scsi/qla2xxx/qla_inline.h | 3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ab5b88203886..3ad375f85b59 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -753,7 +753,7 @@ extern int qla82xx_restart_isp(scsi_qla_host_t *);
 /* IOCB related functions */
 extern int qla82xx_start_scsi(srb_t *);
 extern void qla2x00_sp_free(void *);
-extern void qla2x00_sp_timeout(unsigned long);
+extern void qla2x00_sp_timeout(struct timer_list *);
 extern void qla2x00_bsg_job_done(void *, int);
 extern void qla2x00_bsg_sp_free(void *);
 extern void qla2x00_start_iocbs(struct scsi_qla_host *, struct req_que *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b5b48ddca962..44cf875a484a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -45,9 +45,9 @@ static void qla24xx_handle_prli_done_event(struct scsi_qla_host *,
 /* SRB Extensions ---------------------------------------------------------- */
 
 void
-qla2x00_sp_timeout(unsigned long __data)
+qla2x00_sp_timeout(struct timer_list *t)
 {
-	srb_t *sp = (srb_t *)__data;
+	srb_t *sp = from_timer(sp, t, u.iocb_cmd.timer);
 	struct srb_iocb *iocb;
 	scsi_qla_host_t *vha = sp->vha;
 	struct req_que *req;
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 34cdb5d9c87c..17d2c20f1f75 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -269,8 +269,7 @@ qla2x00_rel_sp(srb_t *sp)
 static inline void
 qla2x00_init_timer(srb_t *sp, unsigned long tmo)
 {
-	setup_timer(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout,
-		    (unsigned long)sp);
+	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
 	add_timer(&sp->u.iocb_cmd.timer);
 	sp->free = qla2x00_sp_free;
-- 
2.7.4
