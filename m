From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 6/8] qla4xxx: Fix sparse warning
Date: Mon, 27 Feb 2012 03:08:56 -0800
Message-ID: <1330340938-12893-7-git-send-email-vikas.chaudhary@qlogic.com>
References: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:2356
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042Ab2B0LW3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Feb 2012 06:22:29 -0500
In-Reply-To: <1330340938-12893-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Fix following warning:-
drivers/scsi/qla4xxx/ql4_os.c:35:5: warning: symbol 'ql4xdisablesysfsboot' was not declared. Should it be static?

drivers/scsi/qla4xxx/ql4_iocb.c:461:5: warning: symbol 'qla4xxx_send_mbox_iocb' was not declared. Should it be static?

drivers/scsi/qla4xxx/ql4_os.c:3025:6: warning: symbol 'qla4xxx_do_work' was not declared. Should it be static?

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_iocb.c |    4 ++--
 drivers/scsi/qla4xxx/ql4_os.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_iocb.c b/drivers/scsi/qla4xxx/ql4_iocb.c
index c70651d..2a2022a 100644
--- a/drivers/scsi/qla4xxx/ql4_iocb.c
+++ b/drivers/scsi/qla4xxx/ql4_iocb.c
@@ -458,8 +458,8 @@ static struct mrb *qla4xxx_get_new_mrb(struct scsi_qla_host *ha)
 	return mrb;
 }
 
-int qla4xxx_send_mbox_iocb(struct scsi_qla_host *ha, struct mrb *mrb,
-			   uint32_t *in_mbox)
+static int qla4xxx_send_mbox_iocb(struct scsi_qla_host *ha, struct mrb *mrb,
+				  uint32_t *in_mbox)
 {
 	int rval = QLA_SUCCESS;
 	uint32_t i;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 50074ed..d1520ad 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -32,7 +32,7 @@ static struct kmem_cache *srb_cachep;
 /*
  * Module parameter information and variables
  */
-int ql4xdisablesysfsboot = 1;
+static int ql4xdisablesysfsboot = 1;
 module_param(ql4xdisablesysfsboot, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql4xdisablesysfsboot,
 		 " Set to disable exporting boot targets to sysfs.\n"
@@ -3238,7 +3238,7 @@ int qla4xxx_post_ping_evt_work(struct scsi_qla_host *ha,
 	return QLA_SUCCESS;
 }
 
-void qla4xxx_do_work(struct scsi_qla_host *ha)
+static void qla4xxx_do_work(struct scsi_qla_host *ha)
 {
 	struct qla4_work_evt *e, *tmp;
 	unsigned long flags;
-- 
1.7.9.1.265.gb3a76


