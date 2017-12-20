From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 14/43] qla2xxx: Add option for use reserve exch for ELS
Date: Tue, 19 Dec 2017 22:56:15 -0800
Message-ID: <20171220065644.21511-15-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0040.outbound.protection.outlook.com ([104.47.40.40]:43985
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932412AbdLTG5J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:09 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Add option to tell FW to reserve 1/2 of emergency exchanges for ELS.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  | 1 +
 drivers/scsi/qla2xxx/qla_init.c | 6 ++++++
 drivers/scsi/qla2xxx/qla_os.c   | 6 ++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fb1c9ffdc05a..88c7746c023a 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -149,6 +149,7 @@ extern int ql2xnvmeenable;
 extern int ql2xautodetectsfp;
 extern int ql2xenablemsix;
 extern int ql2xtrackfwres;
+extern int qla2xuseresexchforels;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 61b74fd220a3..6223dfe20767 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3387,6 +3387,12 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 			ha->fw_options[2] |= BIT_4;
 		else
 			ha->fw_options[2] &= ~BIT_4;
+
+		/* Reserve 1/2 of emergency exchanges for ELS.*/
+		if (qla2xuseresexchforels)
+			ha->fw_options[2] |= BIT_8;
+		else
+			ha->fw_options[2] &= ~BIT_8;
 	}
 
 	ql_dbg(ql_dbg_init, vha, 0x00e8,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 66e6fe73a035..fd107c4feda5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -282,6 +282,12 @@ module_param(ql2xtrackfwres, int, 0444);
 MODULE_PARM_DESC(ql2xtrackfwres,
 		 "Track FW resource.  0(default): disabled");
 
+int qla2xuseresexchforels;
+module_param(qla2xuseresexchforels, int, 0444);
+MODULE_PARM_DESC(qla2xuseresexchforels,
+		 "Reserve 1/2 of emergency exchanges for ELS.\n"
+		 " 0 (default): disabled");
+
 /*
  * SCSI host template entry points
  */
-- 
2.12.0
