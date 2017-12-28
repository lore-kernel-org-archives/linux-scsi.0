From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 17/37] qla2xxx: Use known NPort ID for Management Server login
Date: Thu, 28 Dec 2017 12:33:25 -0800
Message-ID: <20171228203345.2702-18-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0074.outbound.protection.outlook.com ([104.47.42.74]:17440
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751220AbdL1UeI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:08 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h | 4 ++--
 drivers/scsi/qla2xxx/qla_mid.c | 2 +-
 drivers/scsi/qla2xxx/qla_os.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a7b810213aac..bf50b4fbe648 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -246,8 +246,8 @@
  * There is no correspondence between an N-PORT id and an AL_PA.  Therefore the
  * valid range of an N-PORT id is 0 through 0x7ef.
  */
-#define NPH_LAST_HANDLE		0x7ef
-#define NPH_MGMT_SERVER		0x7fa		/*  FFFFFA */
+#define NPH_LAST_HANDLE		0x7ee
+#define NPH_MGMT_SERVER		0x7ef		/*  FFFFEF */
 #define NPH_SNS			0x7fc		/*  FFFFFC */
 #define NPH_FABRIC_CONTROLLER	0x7fd		/*  FFFFFD */
 #define NPH_F_PORT		0x7fe		/*  FFFFFE */
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 966ff0f1bed4..2570146beae4 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -477,7 +477,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 		    "Couldn't allocate vp_id.\n");
 		goto create_vhost_failed;
 	}
-	vha->mgmt_svr_loop_id = 10 + vha->vp_idx;
+	vha->mgmt_svr_loop_id = NPH_MGMT_SERVER;
 
 	vha->dpc_flags = 0L;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 38d6d12571f7..4c3527f54b74 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3047,7 +3047,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	host = base_vha->host;
 	base_vha->req = req;
 	if (IS_QLA2XXX_MIDTYPE(ha))
-		base_vha->mgmt_svr_loop_id = 10 + base_vha->vp_idx;
+		base_vha->mgmt_svr_loop_id = NPH_MGMT_SERVER;
 	else
 		base_vha->mgmt_svr_loop_id = MANAGEMENT_SERVER +
 						base_vha->vp_idx;
-- 
2.12.0
