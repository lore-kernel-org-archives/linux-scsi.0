From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 04/19] qla2xxx: Set FLOGI retry in additional firmware options for P2P (N2N) mode.
Date: Wed, 6 Jul 2016 11:14:20 -0400
Message-ID: <1467818075-15246-5-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:37583 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbcGFP7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:21 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

When VP decoupling enabled, there could be a window where, FLOGI from initiators
can be dropped before VP0 is enabled, causing link level recovery.
Retry FLOGI to avoid link level recovery.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |  2 +-
 drivers/scsi/qla2xxx/qla_init.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 0671f07..907a7ac 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -16,7 +16,7 @@
  * |                              |                    | 0x016e-0x0170  |
  * | Mailbox commands             |       0x1192       |		|
  * |                              |                    |		|
- * | Device Discovery             |       0x2016       | 0x2020-0x2022, |
+ * | Device Discovery             |       0x2003       | 0x2016		|
  * |                              |                    | 0x2011-0x2012, |
  * |                              |                    | 0x2099-0x20a4  |
  * | Queue Command and IO tracing |       0x3074       | 0x300b         |
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c56cdb3..a3685b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2053,6 +2053,14 @@ qla2x00_update_fw_options(scsi_qla_host_t *vha)
 	if (IS_QLA6312(ha))
 		ha->fw_options[2] |= BIT_13;
 
+	/* Set Retry FLOGI in case of P2P connection */
+	if (ha->operating_mode == P2P) {
+		ha->fw_options[2] |= BIT_3;
+		ql_dbg(ql_dbg_disc, vha, 0x2100,
+		    "(%s): Setting FLOGI retry BIT in fw_options[2]: 0x%x\n",
+			__func__, ha->fw_options[2]);
+	}
+
 	/* Update firmware options. */
 	qla2x00_set_fw_options(vha, ha->fw_options);
 }
@@ -2070,6 +2078,14 @@ qla24xx_update_fw_options(scsi_qla_host_t *vha)
 	if (ql2xfwholdabts)
 		ha->fw_options[3] |= BIT_12;
 
+	/* Set Retry FLOGI in case of P2P connection */
+	if (ha->operating_mode == P2P) {
+		ha->fw_options[2] |= BIT_3;
+		ql_dbg(ql_dbg_disc, vha, 0x2101,
+		    "(%s): Setting FLOGI retry BIT in fw_options[2]: 0x%x\n",
+			__func__, ha->fw_options[2]);
+	}
+
 	/* Update Serial Link options. */
 	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) == 0)
 		return;
@@ -6513,6 +6529,14 @@ qla81xx_update_fw_options(scsi_qla_host_t *vha)
 	if (ql2xfwholdabts)
 		ha->fw_options[3] |= BIT_12;
 
+	/* Set Retry FLOGI in case of P2P connection */
+	if (ha->operating_mode == P2P) {
+		ha->fw_options[2] |= BIT_3;
+		ql_dbg(ql_dbg_disc, vha, 0x2103,
+		    "(%s): Setting FLOGI retry BIT in fw_options[2]: 0x%x\n",
+			__func__, ha->fw_options[2]);
+	}
+
 	if (!ql2xetsenable)
 		goto out;
 
-- 
2.7.2

