From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 3/4] scsi: qla2xxx: Convert qla2x00_timer() to use timer_setup()
Date: Tue, 31 Oct 2017 12:13:48 -0700
Message-ID: <1509477229-62141-4-git-send-email-keescook@chromium.org>
References: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:50957 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932684AbdJaTOA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 15:14:00 -0400
Received: by mail-pg0-f65.google.com with SMTP id y5so28579pgq.7
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2017 12:14:00 -0700 (PDT)
In-Reply-To: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Kees Cook <keescook@chromium.org>, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly for the qla2x00_timer() callback and
associated timer.

Cc: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 2 +-
 drivers/scsi/qla2xxx/qla_os.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 541a087cdb45..ab5b88203886 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -206,7 +206,7 @@ int qla24xx_async_abort_cmd(srb_t *);
  */
 extern struct scsi_host_template qla2xxx_driver_template;
 extern struct scsi_transport_template *qla2xxx_transport_vport_template;
-extern void qla2x00_timer(scsi_qla_host_t *);
+extern void qla2x00_timer(struct timer_list *);
 extern void qla2x00_start_timer(scsi_qla_host_t *, unsigned long);
 extern void qla24xx_deallocate_vp_id(scsi_qla_host_t *);
 extern int qla24xx_disable_vp (scsi_qla_host_t *);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7e7e5d095c26..f97e585dee77 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -332,8 +332,7 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
 __inline__ void
 qla2x00_start_timer(scsi_qla_host_t *vha, unsigned long interval)
 {
-	setup_timer(&vha->timer, (void (*)(unsigned long))qla2x00_timer,
-		    (unsigned long)vha);
+	timer_setup(&vha->timer, qla2x00_timer, 0);
 	vha->timer.expires = jiffies + interval * HZ;
 	add_timer(&vha->timer);
 	vha->timer_active = 1;
@@ -5994,8 +5993,9 @@ qla2x00_rst_aen(scsi_qla_host_t *vha)
 * Context: Interrupt
 ***************************************************************************/
 void
-qla2x00_timer(scsi_qla_host_t *vha)
+qla2x00_timer(struct timer_list *t)
 {
+	scsi_qla_host_t *vha = from_timer(vha, t, timer);
 	unsigned long	cpu_flags = 0;
 	int		start_dpc = 0;
 	int		index;
-- 
2.7.4
