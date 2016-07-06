From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 02/19] qla2xxx: Add ram area DDR for fwdump template entry T262.
Date: Wed, 6 Jul 2016 11:14:18 -0400
Message-ID: <1467818075-15246-3-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:32950 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbcGFP7U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:20 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 2 ++
 drivers/scsi/qla2xxx/qla_mbx.c  | 7 +++++--
 drivers/scsi/qla2xxx/qla_tmpl.c | 9 ++++++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 47f8b9b4..7f86147 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3370,6 +3370,8 @@ struct qla_hw_data {
 
 	uint32_t	fw_shared_ram_start;
 	uint32_t	fw_shared_ram_end;
+	uint32_t	fw_ddr_ram_start;
+	uint32_t	fw_ddr_ram_end;
 
 	uint16_t	fw_options[16];         /* slots: 1,2,3,10,11 */
 	uint8_t		fw_seriallink_options[4];
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 968b846..9673a0b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -782,8 +782,9 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 	if (IS_FWI2_CAPABLE(ha))
 		mcp->in_mb |= MBX_17|MBX_16|MBX_15;
 	if (IS_QLA27XX(ha))
-		mcp->in_mb |= MBX_23 | MBX_22 | MBX_21 | MBX_20 | MBX_19 |
-		    MBX_18 | MBX_14 | MBX_13 | MBX_11 | MBX_10 | MBX_9 | MBX_8;
+		mcp->in_mb |=
+		    MBX_25|MBX_24|MBX_23|MBX_22|MBX_21|MBX_20|MBX_19|MBX_18|
+		    MBX_14|MBX_13|MBX_11|MBX_10|MBX_9|MBX_8;
 
 	mcp->flags = 0;
 	mcp->tov = MBX_TOV_SECONDS;
@@ -842,6 +843,8 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha)
 		ha->pep_version[2] = mcp->mb[14] & 0xff;
 		ha->fw_shared_ram_start = (mcp->mb[19] << 16) | mcp->mb[18];
 		ha->fw_shared_ram_end = (mcp->mb[21] << 16) | mcp->mb[20];
+		ha->fw_ddr_ram_start = (mcp->mb[23] << 16) | mcp->mb[22];
+		ha->fw_ddr_ram_end = (mcp->mb[25] << 16) | mcp->mb[24];
 	}
 
 failed:
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index c3e6225..36935c9 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -357,6 +357,13 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 			ent->t262.start_addr = start;
 			ent->t262.end_addr = end;
 		}
+	} else if (ent->t262.ram_area == T262_RAM_AREA_DDR_RAM) {
+		start = vha->hw->fw_ddr_ram_start;
+		end = vha->hw->fw_ddr_ram_end;
+		if (buf) {
+			ent->t262.start_addr = start;
+			ent->t262.end_addr = end;
+		}
 	} else {
 		ql_dbg(ql_dbg_misc, vha, 0xd022,
 		    "%s: unknown area %x\n", __func__, ent->t262.ram_area);
@@ -364,7 +371,7 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 		goto done;
 	}
 
-	if (end < start || end == 0) {
+	if (end <= start || start == 0 || end == 0) {
 		ql_dbg(ql_dbg_misc, vha, 0xd023,
 		    "%s: unusable range (start=%x end=%x)\n", __func__,
 		    ent->t262.end_addr, ent->t262.start_addr);
-- 
2.7.2

