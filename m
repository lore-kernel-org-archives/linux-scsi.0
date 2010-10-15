From: madhu.iyengar@qlogic.com
Subject: [PATCH 03/12] qla2xxx: Add module parameter to enable/disable GFF_ID device type check.
Date: Fri, 15 Oct 2010 11:27:40 -0700
Message-ID: <1287167269-8034-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36958 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756093Ab0JOSg2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:28 -0400
In-Reply-To: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

Add the module parameter ql2xgffidenable to disable/enable the use of the
GFF_ID name server command to prevent non FCP SCSI devices from being added to
the driver's internal fc_port database.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    5 +++--
 drivers/scsi/qla2xxx/qla_os.c   |    5 +++++
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index c33dec8..9382a81 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -92,6 +92,7 @@ extern int ql2xshiftctondsd;
 extern int ql2xdbwr;
 extern int ql2xdontresethba;
 extern int ql2xasynctmfenable;
+extern int ql2xgffidenable;
 extern int ql2xenabledif;
 extern int ql2xenablehba_err_chk;
 extern int ql2xtargetreset;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 8c48660..6ea5376 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3284,8 +3284,9 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha,
 			continue;
 
 		/* Bypass ports whose FCP-4 type is not FCP_SCSI */
-		if (new_fcport->fc4_type != FC4_TYPE_FCP_SCSI &&
-		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN)
+		if (ql2xgffidenable &&
+		    (new_fcport->fc4_type != FC4_TYPE_FCP_SCSI &&
+		    new_fcport->fc4_type != FC4_TYPE_UNKNOWN))
 			continue;
 
 		/* Locate matching device in database. */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9d248d0..85bd0a8 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -160,6 +160,11 @@ MODULE_PARM_DESC(ql2xtargetreset,
 		 "Enable target reset."
 		 "Default is 1 - use hw defaults.");
 
+int ql2xgffidenable;
+module_param(ql2xgffidenable, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xgffidenable,
+		"Enables GFF_ID checks of port type. "
+		"Default is 0 - Do not use GFF_ID information.");
 
 int ql2xasynctmfenable;
 module_param(ql2xasynctmfenable, int, S_IRUGO|S_IRUSR);
-- 
1.6.0.2

