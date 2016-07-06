From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 12/19] qla2xxx: Let DPORT be enabled purely by nvram.
Date: Wed, 6 Jul 2016 11:14:28 -0400
Message-ID: <1467818075-15246-13-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:26279 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbcGFP7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:52 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |  2 +-
 drivers/scsi/qla2xxx/qla_def.h  |  1 +
 drivers/scsi/qla2xxx/qla_init.c | 12 ++++++------
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 2a1eb02..eebd1a58 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x018f       | 0x0146         |
+ * | Module Init and Probe        |       0x0191       | 0x0146         |
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e		|
  * | Mailbox commands             |       0x1196       |		|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 7d4bd7d..c04d83e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3029,6 +3029,7 @@ struct qla_hw_data {
 		uint32_t        mr_reset_hdlr_active:1;
 		uint32_t        mr_intr_valid:1;
 
+		uint32_t        dport_enabled:1;
 		uint32_t	fawwpn_enabled:1;
 		uint32_t	exlogins_enabled:1;
 		uint32_t	exchoffld_enabled:1;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 68e9309..5b09296 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2288,13 +2288,13 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 		mid_init_cb->options = cpu_to_le16(BIT_1);
 		mid_init_cb->init_cb.execution_throttle =
 		    cpu_to_le16(ha->cur_fw_xcb_count);
-		/* D-Port Status */
-		if (IS_DPORT_CAPABLE(ha))
-			mid_init_cb->init_cb.firmware_options_1 |=
-			    cpu_to_le16(BIT_7);
-		/* Enable FA-WWPN */
+		ha->flags.dport_enabled =
+		    (mid_init_cb->init_cb.firmware_options_1 & BIT_7) != 0;
+		ql_dbg(ql_dbg_init, vha, 0x0191, "DPORT Support: %s.\n",
+		    (ha->flags.dport_enabled) ? "enabled" : "disabled");
+		/* FA-WWPN Status */
 		ha->flags.fawwpn_enabled =
-		    (mid_init_cb->init_cb.firmware_options_1 & BIT_6) ? 1 : 0;
+		    (mid_init_cb->init_cb.firmware_options_1 & BIT_6) != 0;
 		ql_dbg(ql_dbg_init, vha, 0x0141, "FA-WWPN Support: %s.\n",
 		    (ha->flags.fawwpn_enabled) ? "enabled" : "disabled");
 	}
-- 
2.7.2

