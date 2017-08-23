From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 16/31] qla2xxx: Move logging default mask to execute once only.
Date: Wed, 23 Aug 2017 15:05:10 -0700
Message-ID: <20170823220525.3115-17-himanshu.madhani@cavium.com>
References: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0082.outbound.protection.outlook.com ([104.47.32.82]:28674
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751171AbdHWWFv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 18:05:51 -0400
In-Reply-To: <20170823220525.3115-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 2 --
 drivers/scsi/qla2xxx/qla_os.c  | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 7e7cd79038be..065449e0f347 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2520,8 +2520,6 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 static inline int
 ql_mask_match(uint32_t level)
 {
-	if (ql2xextended_error_logging == 1)
-		ql2xextended_error_logging = QL_DBG_DEFAULT1_MASK;
 	return (level & ql2xextended_error_logging) == level;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5b033e265a3b..10c3ee53ec3a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6648,6 +6648,8 @@ qla2x00_module_init(void)
 	strcpy(qla2x00_version_str, QLA2XXX_VERSION);
 	if (ql2xextended_error_logging)
 		strcat(qla2x00_version_str, "-debug");
+	if (ql2xextended_error_logging == 1)
+		ql2xextended_error_logging = QL_DBG_DEFAULT1_MASK;
 
 	qla2xxx_transport_template =
 	    fc_attach_transport(&qla2xxx_transport_functions);
-- 
2.12.0
