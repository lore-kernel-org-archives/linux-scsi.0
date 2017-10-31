From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 2/4] scsi: qla2xxx: Refactor qla2x00_start_timer()
Date: Tue, 31 Oct 2017 12:13:47 -0700
Message-ID: <1509477229-62141-3-git-send-email-keescook@chromium.org>
References: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:43779 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932845AbdJaTOB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 15:14:01 -0400
Received: by mail-pf0-f193.google.com with SMTP id a8so35414pfc.0
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2017 12:14:01 -0700 (PDT)
In-Reply-To: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Kees Cook <keescook@chromium.org>, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, this refactors qla2x00_start_timer() to not pass a
callback argument, since all callers use the same callback.

Cc: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/qla2xxx/qla_gbl.h | 2 +-
 drivers/scsi/qla2xxx/qla_mid.c | 2 +-
 drivers/scsi/qla2xxx/qla_os.c  | 6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f852ca60c49f..541a087cdb45 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -207,7 +207,7 @@ int qla24xx_async_abort_cmd(srb_t *);
 extern struct scsi_host_template qla2xxx_driver_template;
 extern struct scsi_transport_template *qla2xxx_transport_vport_template;
 extern void qla2x00_timer(scsi_qla_host_t *);
-extern void qla2x00_start_timer(scsi_qla_host_t *, void *, unsigned long);
+extern void qla2x00_start_timer(scsi_qla_host_t *, unsigned long);
 extern void qla24xx_deallocate_vp_id(scsi_qla_host_t *);
 extern int qla24xx_disable_vp (scsi_qla_host_t *);
 extern int qla24xx_enable_vp (scsi_qla_host_t *);
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
index 6c10a7b970c0..7e7e5d095c26 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -330,9 +330,9 @@ struct scsi_transport_template *qla2xxx_transport_vport_template = NULL;
  */
 
 __inline__ void
-qla2x00_start_timer(scsi_qla_host_t *vha, void *func, unsigned long interval)
+qla2x00_start_timer(scsi_qla_host_t *vha, unsigned long interval)
 {
-	setup_timer(&vha->timer, (void (*)(unsigned long))func,
+	setup_timer(&vha->timer, (void (*)(unsigned long))qla2x00_timer,
 		    (unsigned long)vha);
 	vha->timer.expires = jiffies + interval * HZ;
 	add_timer(&vha->timer);
@@ -3245,7 +3245,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	base_vha->host->irq = ha->pdev->irq;
 
 	/* Initialized the timer */
-	qla2x00_start_timer(base_vha, qla2x00_timer, WATCH_INTERVAL);
+	qla2x00_start_timer(base_vha, WATCH_INTERVAL);
 	ql_dbg(ql_dbg_init, base_vha, 0x00ef,
 	    "Started qla2x00_timer with "
 	    "interval=%d.\n", WATCH_INTERVAL);
-- 
2.7.4
