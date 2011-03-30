From: madhu.iyengar@qlogic.com
Subject: [PATCH 14/18] qla2xxx: Add the ql2xdontresethba module_param.
Date: Wed, 30 Mar 2011 11:46:29 -0700
Message-ID: <1301510793-2492-15-git-send-email-madhu.iyengar@qlogic.com>
References: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:45801 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755795Ab1C3SvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2011 14:51:17 -0400
In-Reply-To: <1301510793-2492-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Also, change the ISP82xx code to only reset if this module_param is set
and reset is intended via the QLA82XX_DEV_NEED_RESET case.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_nx.c  |    1 +
 drivers/scsi/qla2xxx/qla_os.c  |    8 ++++++++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index cd646ca..fbb4b8f 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -102,6 +102,7 @@ extern int ql2xgffidenable;
 extern int ql2xenabledif;
 extern int ql2xenablehba_err_chk;
 extern int ql2xtargetreset;
+extern int ql2xdontresethba;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 9eadb7c..d540b73 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3585,6 +3585,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			qla82xx_idc_lock(ha);
 			break;
 		case QLA82XX_DEV_NEED_RESET:
+		    if (!ql2xdontresethba)
 			qla82xx_need_reset_handler(vha);
 			dev_init_timeout = jiffies +
 				(ha->nx_dev_init_timeout * HZ);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b36964d..7eeab98 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -164,6 +164,14 @@ module_param(ql2xasynctmfenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xasynctmfenable,
 		"Enables issue of TM IOCBs asynchronously via IOCB mechanism"
 		"Default is 0 - Issue TM IOCBs via mailbox mechanism.");
+
+int ql2xdontresethba;
+module_param(ql2xdontresethba, int, S_IRUGO);
+MODULE_PARM_DESC(ql2xdontresethba,
+	"Option to specify reset behaviour\n"
+	" 0 (Default) -- Reset on failure.\n"
+	" 1 -- Do not reset on failure.\n");
+
 /*
  * SCSI host template entry points
  */
-- 
1.6.0.2

