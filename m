From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/4] scsi: qla2xxx: Convert timers to use setup_timer()
Date: Tue, 31 Oct 2017 12:13:46 -0700
Message-ID: <1509477229-62141-2-git-send-email-keescook@chromium.org>
References: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:51005 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932859AbdJaTOC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 15:14:02 -0400
Received: by mail-pf0-f196.google.com with SMTP id b6so21408pfh.7
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2017 12:14:02 -0700 (PDT)
In-Reply-To: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Kees Cook <keescook@chromium.org>, Bart Van Assche <bart.vanassche@wdc.com>, qla2xxx-upstream@qlogic.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, take the first step by switching from init_timer() and
open-coded .function and .data assignments to using the old setup_timer()
API.

Cc: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: qla2xxx-upstream@qlogic.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/qla2xxx/qla_inline.h | 5 ++---
 drivers/scsi/qla2xxx/qla_os.c     | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 9a2c86eacf44..34cdb5d9c87c 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -269,10 +269,9 @@ qla2x00_rel_sp(srb_t *sp)
 static inline void
 qla2x00_init_timer(srb_t *sp, unsigned long tmo)
 {
-	init_timer(&sp->u.iocb_cmd.timer);
+	setup_timer(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout,
+		    (unsigned long)sp);
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
-	sp->u.iocb_cmd.timer.data = (unsigned long)sp;
-	sp->u.iocb_cmd.timer.function = qla2x00_sp_timeout;
 	add_timer(&sp->u.iocb_cmd.timer);
 	sp->free = qla2x00_sp_free;
 	if (IS_QLAFX00(sp->vha->hw) && (sp->type == SRB_FXIOCB_DCMD))
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3bd956d3bc5d..6c10a7b970c0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -332,10 +332,9 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
 __inline__ void
 qla2x00_start_timer(scsi_qla_host_t *vha, void *func, unsigned long interval)
 {
-	init_timer(&vha->timer);
+	setup_timer(&vha->timer, (void (*)(unsigned long))func,
+		    (unsigned long)vha);
 	vha->timer.expires = jiffies + interval * HZ;
-	vha->timer.data = (unsigned long)vha;
-	vha->timer.function = (void (*)(unsigned long))func;
 	add_timer(&vha->timer);
 	vha->timer_active = 1;
 }
-- 
2.7.4
