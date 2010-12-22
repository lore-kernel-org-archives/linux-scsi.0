From: madhu.iyengar@qlogic.com
Subject: [PATCH 12/14] qla2xxx: Remove code to not reset ISP82xx on failure.
Date: Tue, 21 Dec 2010 16:00:25 -0800
Message-ID: <1292976027-12034-13-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36171 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753971Ab0LVADZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:25 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 -
 drivers/scsi/qla2xxx/qla_nx.c  |    3 +--
 drivers/scsi/qla2xxx/qla_os.c  |    7 -------
 3 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 39c4bdd..89e900a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -95,7 +95,6 @@ extern int ql2xfwloadbin;
 extern int ql2xetsenable;
 extern int ql2xshiftctondsd;
 extern int ql2xdbwr;
-extern int ql2xdontresethba;
 extern int ql2xasynctmfenable;
 extern int ql2xgffidenable;
 extern int ql2xenabledif;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 22b0d78..a971ec3 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3556,8 +3556,7 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 			qla82xx_idc_lock(ha);
 			break;
 		case QLA82XX_DEV_NEED_RESET:
-			if (!ql2xdontresethba)
-				qla82xx_need_reset_handler(vha);
+			qla82xx_need_reset_handler(vha);
 			break;
 		case QLA82XX_DEV_NEED_QUIESCENT:
 			qla82xx_need_qsnt_handler(vha);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 51e944f..c194c23 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -147,13 +147,6 @@ MODULE_PARM_DESC(ql2xdbwr,
 	" 0 -- Regular doorbell.\n"
 	" 1 -- CAMRAM doorbell (faster).\n");
 
-int ql2xdontresethba;
-module_param(ql2xdontresethba, int, S_IRUGO);
-MODULE_PARM_DESC(ql2xdontresethba,
-	"Option to specify reset behaviour\n"
-	" 0 (Default) -- Reset on failure.\n"
-	" 1 -- Do not reset on failure.\n");
-
 int ql2xtargetreset = 1;
 module_param(ql2xtargetreset, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xtargetreset,
-- 
1.6.0.2

