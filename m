From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 11/37] qla2xxx: Add option for use reserve exch for ELS
Date: Thu, 28 Dec 2017 12:33:19 -0800
Message-ID: <20171228203345.2702-12-himanshu.madhani@cavium.com>
References: <20171228203345.2702-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0085.outbound.protection.outlook.com ([104.47.42.85]:25600
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755233AbdL1UeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Dec 2017 15:34:10 -0500
In-Reply-To: <20171228203345.2702-1-himanshu.madhani@cavium.com>
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
index cf1f1a3baf21..aabd49ef95a3 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -148,6 +148,7 @@ extern int ql2xuctrlirq;
 extern int ql2xnvmeenable;
 extern int ql2xautodetectsfp;
 extern int ql2xenablemsix;
+extern int qla2xuseresexchforels;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 728c66f34666..39d1edc6c2b1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3348,6 +3348,12 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
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
index e1761bd552fe..487e1affacf4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -277,6 +277,12 @@ MODULE_PARM_DESC(ql2xenablemsix,
 		 " 1 -- enable MSI-X interrupt mechanism.\n"
 		 " 2 -- enable MSI interrupt mechanism.\n");
 
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
