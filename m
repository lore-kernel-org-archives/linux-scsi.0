From: giridhar.malavali@qlogic.com
Subject: [PATCH 6/8] qla2xxx: Add firmware ETS burst support.
Date: Thu, 18 Feb 2010 10:07:28 -0800
Message-ID: <1266516450-472-7-git-send-email-giridhar.malavali@qlogic.com>
References: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54308 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753346Ab0BRSHj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 13:07:39 -0500
In-Reply-To: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, stable@kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

Can be used to balance NIC/FCoE traffic distribution.
Cc: stable@kernel.org
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   11 ++++++++++-
 drivers/scsi/qla2xxx/qla_os.c   |    6 ++++++
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e201650..3a89bc5 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -78,6 +78,7 @@ extern int ql2xiidmaenable;
 extern int ql2xmaxqueues;
 extern int ql2xmultique_tag;
 extern int ql2xfwloadbin;
+extern int ql2xetsenable;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 96a609b..a67b2ba 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4892,6 +4892,15 @@ qla81xx_nvram_config(scsi_qla_host_t *vha)
 }
 
 void
-qla81xx_update_fw_options(scsi_qla_host_t *ha)
+qla81xx_update_fw_options(scsi_qla_host_t *vha)
 {
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!ql2xetsenable)
+		return;
+
+	/* Enable ETS Burst. */
+	memset(ha->fw_options, 0, sizeof(ha->fw_options));
+	ha->fw_options[2] |= BIT_9;
+	qla2x00_set_fw_options(vha, ha->fw_options);
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8249352..dacc674 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -107,6 +107,12 @@ MODULE_PARM_DESC(ql2xfwloadbin,
 		" 1 -- load firmware from flash.\n"
 		" 0 -- use default semantics.\n");
 
+int ql2xetsenable;
+module_param(ql2xetsenable, int, S_IRUGO|S_IRUSR);
+MODULE_PARM_DESC(ql2xetsenable,
+		"Enables firmware ETS burst."
+		"Default is 0 - skip ETS enablement.");
+
 /*
  * SCSI host template entry points
  */
-- 
1.6.2.rc1.30.gd43c

