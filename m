From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] scsi: qla4xxx: Convert timers to use timer_setup()
Date: Wed, 25 Oct 2017 03:07:43 -0700
Message-ID: <20171025100743.GA145111@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: QLogic-Storage-Upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 64c6fa563fdb..2b8a8ce2a431 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3955,16 +3955,15 @@ void qla4xxx_update_session_conn_param(struct scsi_qla_host *ha,
 /*
  * Timer routines
  */
+static void qla4xxx_timer(struct timer_list *t);
 
-static void qla4xxx_start_timer(struct scsi_qla_host *ha, void *func,
+static void qla4xxx_start_timer(struct scsi_qla_host *ha,
 				unsigned long interval)
 {
 	DEBUG(printk("scsi: %s: Starting timer thread for adapter %d\n",
 		     __func__, ha->host->host_no));
-	init_timer(&ha->timer);
+	timer_setup(&ha->timer, qla4xxx_timer, 0);
 	ha->timer.expires = jiffies + interval * HZ;
-	ha->timer.data = (unsigned long)ha;
-	ha->timer.function = (void (*)(unsigned long))func;
 	add_timer(&ha->timer);
 	ha->timer_active = 1;
 }
@@ -4508,8 +4507,9 @@ static void qla4xxx_check_relogin_flash_ddb(struct iscsi_cls_session *cls_sess)
  * qla4xxx_timer - checks every second for work to do.
  * @ha: Pointer to host adapter structure.
  **/
-static void qla4xxx_timer(struct scsi_qla_host *ha)
+static void qla4xxx_timer(struct timer_list *t)
 {
+	struct scsi_qla_host *ha = from_timer(ha, t, timer);
 	int start_dpc = 0;
 	uint16_t w;
 
@@ -8805,7 +8805,7 @@ static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 	ha->isp_ops->enable_intrs(ha);
 
 	/* Start timer thread. */
-	qla4xxx_start_timer(ha, qla4xxx_timer, 1);
+	qla4xxx_start_timer(ha, 1);
 
 	set_bit(AF_INIT_DONE, &ha->flags);
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
