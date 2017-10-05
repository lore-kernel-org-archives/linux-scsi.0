From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Wed, 4 Oct 2017 17:48:09 -0700
Message-ID: <20171005004809.GA22940@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:46712 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdJEAsL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2017 20:48:11 -0400
Received: by mail-pf0-f180.google.com with SMTP id r68so7127803pfj.3
        for <linux-scsi@vger.kernel.org>; Wed, 04 Oct 2017 17:48:11 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: qla2xxx-upstream@qlogic.com
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  6 +++---
 drivers/scsi/qla2xxx/qla_init.c   |  4 ++--
 drivers/scsi/qla2xxx/qla_inline.h |  4 +---
 drivers/scsi/qla2xxx/qla_mid.c    |  2 +-
 drivers/scsi/qla2xxx/qla_os.c     | 11 +++++------
 5 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f852ca60c49f..3ad375f85b59 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -206,8 +206,8 @@ int qla24xx_async_abort_cmd(srb_t *);
  */
 extern struct scsi_host_template qla2xxx_driver_template;
 extern struct scsi_transport_template *qla2xxx_transport_vport_template;
-extern void qla2x00_timer(scsi_qla_host_t *);
-extern void qla2x00_start_timer(scsi_qla_host_t *, void *, unsigned long);
+extern void qla2x00_timer(struct timer_list *);
+extern void qla2x00_start_timer(scsi_qla_host_t *, unsigned long);
 extern void qla24xx_deallocate_vp_id(scsi_qla_host_t *);
 extern int qla24xx_disable_vp (scsi_qla_host_t *);
 extern int qla24xx_enable_vp (scsi_qla_host_t *);
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
index 9a2c86eacf44..17d2c20f1f75 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -269,10 +269,8 @@ qla2x00_rel_sp(srb_t *sp)
 static inline void
 qla2x00_init_timer(srb_t *sp, unsigned long tmo)
 {
-	init_timer(&sp->u.iocb_cmd.timer);
+	timer_setup(&sp->u.iocb_cmd.timer, qla2x00_sp_timeout, 0);
 	sp->u.iocb_cmd.timer.expires = jiffies + tmo * HZ;
-	sp->u.iocb_cmd.timer.data = (unsigned long)sp;
-	sp->u.iocb_cmd.timer.function = qla2x00_sp_timeout;
 	add_timer(&sp->u.iocb_cmd.timer);
 	sp->free = qla2x00_sp_free;
 	if (IS_QLAFX00(sp->vha->hw) && (sp->type == SRB_FXIOCB_DCMD))
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c0f8f6c17b79..cbf544dbf883 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -487,7 +487,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	atomic_set(&vha->loop_state, LOOP_DOWN);
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 
-	qla2x00_start_timer(vha, qla2x00_timer, WATCH_INTERVAL);
+	qla2x00_start_timer(vha, WATCH_INTERVAL);
 
 	vha->req = base_vha->req;
 	host->can_queue = base_vha->req->length + 128;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5b2437a5ea44..c3b3daa797ff 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -330,12 +330,10 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
  */
 
 __inline__ void
-qla2x00_start_timer(scsi_qla_host_t *vha, void *func, unsigned long interval)
+qla2x00_start_timer(scsi_qla_host_t *vha, unsigned long interval)
 {
-	init_timer(&vha->timer);
+	timer_setup(&vha->timer, qla2x00_timer, 0);
 	vha->timer.expires = jiffies + interval * HZ;
-	vha->timer.data = (unsigned long)vha;
-	vha->timer.function = (void (*)(unsigned long))func;
 	add_timer(&vha->timer);
 	vha->timer_active = 1;
 }
@@ -3245,7 +3243,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	base_vha->host->irq = ha->pdev->irq;
 
 	/* Initialized the timer */
-	qla2x00_start_timer(base_vha, qla2x00_timer, WATCH_INTERVAL);
+	qla2x00_start_timer(base_vha, WATCH_INTERVAL);
 	ql_dbg(ql_dbg_init, base_vha, 0x00ef,
 	    "Started qla2x00_timer with "
 	    "interval=%d.\n", WATCH_INTERVAL);
@@ -5994,8 +5992,9 @@ qla2x00_rst_aen(scsi_qla_host_t *vha)
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


-- 
Kees Cook
Pixel Security
