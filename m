From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 02/23] qla2xxx: Get VPD information from common location for CNA.
Date: Fri,  8 Feb 2013 01:57:43 -0500
Message-ID: <1360306684-8286-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:10505 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752684Ab3BHHTJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Feb 2013 02:19:09 -0500
In-Reply-To: <1360306684-8286-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h  |    2 --
 drivers/scsi/qla2xxx/qla_nx.h  |    2 +-
 drivers/scsi/qla2xxx/qla_sup.c |   16 ++--------------
 3 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 7105d5e..da1a8da 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1388,9 +1388,7 @@ struct qla_flt_header {
 #define FLT_REG_FCP_PRIO_0	0x87
 #define FLT_REG_FCP_PRIO_1	0x88
 #define FLT_REG_FCOE_FW		0xA4
-#define FLT_REG_FCOE_VPD_0	0xA9
 #define FLT_REG_FCOE_NVRAM_0	0xAA
-#define FLT_REG_FCOE_VPD_1	0xAB
 #define FLT_REG_FCOE_NVRAM_1	0xAC
 
 struct qla_flt_region {
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 6c953e8..5502732 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -897,7 +897,7 @@ struct ct6_dsd {
 #define FLT_REG_BOOT_CODE_82XX	0x78
 #define FLT_REG_FW_82XX		0x74
 #define FLT_REG_GOLD_FW_82XX	0x75
-#define FLT_REG_VPD_82XX	0x81
+#define FLT_REG_VPD_8XXX	0x81
 
 #define	FA_VPD_SIZE_82XX	0x400
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 32fdc2a..f5a1a56 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -798,20 +798,8 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		case FLT_REG_BOOTLOAD_82XX:
 			ha->flt_region_bootload = start;
 			break;
-		case FLT_REG_VPD_82XX:
-			ha->flt_region_vpd = start;
-			break;
-		case FLT_REG_FCOE_VPD_0:
-			if (!IS_QLA8031(ha))
-				break;
-			ha->flt_region_vpd_nvram = start;
-			if (ha->flags.port0)
-				ha->flt_region_vpd = start;
-			break;
-		case FLT_REG_FCOE_VPD_1:
-			if (!IS_QLA8031(ha))
-				break;
-			if (!ha->flags.port0)
+		case FLT_REG_VPD_8XXX:
+			if (IS_CNA_CAPABLE(ha))
 				ha->flt_region_vpd = start;
 			break;
 		case FLT_REG_FCOE_NVRAM_0:
-- 
1.7.7

