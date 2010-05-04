From: giridhar.malavali@qlogic.com
Subject: [PATCH 13/16] qla2xxx: Optionally disable target reset.
Date: Tue,  4 May 2010 15:01:33 -0700
Message-ID: <1273010496-43045-14-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47178 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760240Ab0EDWBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:41 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_os.c  |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 3e946da..8217c3b 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -96,6 +96,7 @@ extern int ql2xdontresethba;
 extern int ql2xasynctmfenable;
 extern int ql2xenabledif;
 extern int ql2xenablehba_err_chk;
+extern int ql2xtargetreset;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0de92d3..be1a8fc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -154,6 +154,12 @@ MODULE_PARM_DESC(ql2xdontresethba,
 	" 0 (Default) -- Reset on failure.\n"
 	" 1 -- Do not reset on failure.\n");
 
+int ql2xtargetreset = 1;
+module_param(ql2xtargetreset, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xtargetreset,
+		 "Enable target reset."
+		 "Default is 1 - use hw defaults.");
+
 
 int ql2xasynctmfenable;
 module_param(ql2xasynctmfenable, int, S_IRUGO|S_IRUSR);
@@ -1193,7 +1199,7 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	struct fc_port *fcport;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (ha->flags.enable_target_reset) {
+	if (ql2xtargetreset == 1 && ha->flags.enable_target_reset) {
 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
 			if (fcport->port_type != FCT_TARGET)
 				continue;
-- 
1.6.2.rc1.30.gd43c

