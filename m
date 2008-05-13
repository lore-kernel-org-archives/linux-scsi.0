From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 07/10] qla2xxx: Extend the 'fw_dump' SYSFS node the ability to initiate a firmware dump.
Date: Mon, 12 May 2008 22:21:13 -0700
Message-ID: <1210656076-54720-7-git-send-email-andrew.vasquez@qlogic.com>
References: <20080513051948.GN22377@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52305 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109AbYEMFVZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:21:25 -0400
In-Reply-To: <20080513051948.GN22377@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

The user-initiated dump can be a useful tool in triaging complex
ISP and FC issues.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    3 +++
 drivers/scsi/qla2xxx/qla_gbl.h  |    3 +++
 drivers/scsi/qla2xxx/qla_mbx.c  |    6 +-----
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 48318d0..8dd88fc 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -70,6 +70,9 @@ qla2x00_sysfs_write_fw_dump(struct kobject *kobj,
 	case 2:
 		qla2x00_alloc_fw_dump(ha);
 		break;
+	case 3:
+		qla2x00_system_error(ha);
+		break;
 	}
 	return (count);
 }
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index f882706..9b4bebe 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -228,6 +228,9 @@ extern int qla24xx_abort_target(struct fc_port *, unsigned int);
 extern int qla24xx_lun_reset(struct fc_port *, unsigned int);
 
 extern int
+qla2x00_system_error(scsi_qla_host_t *);
+
+extern int
 qla2x00_set_serdes_params(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
 
 extern int
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index bf3a6f0..250d2f6 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2303,8 +2303,6 @@ qla24xx_lun_reset(struct fc_port *fcport, unsigned int l)
 	return __qla24xx_issue_tmf("Lun", TCF_LUN_RESET, fcport, l);
 }
 
-#if 0
-
 int
 qla2x00_system_error(scsi_qla_host_t *ha)
 {
@@ -2312,7 +2310,7 @@ qla2x00_system_error(scsi_qla_host_t *ha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	if (!IS_FWI2_CAPABLE(ha))
+	if (!IS_QLA23XX(ha) && !IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
@@ -2334,8 +2332,6 @@ qla2x00_system_error(scsi_qla_host_t *ha)
 	return rval;
 }
 
-#endif  /*  0  */
-
 /**
  * qla2x00_set_serdes_params() -
  * @ha: HA context
-- 
1.5.5.1.211.g65ea3

