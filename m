From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH  05/14] qla2xxx: Add adapter checks for FAWWN functionality.
Date: Tue, 4 Aug 2015 13:37:55 -0400
Message-ID: <1438709884-623-6-git-send-email-himanshu.madhani@qlogic.com>
References: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:29762 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753414AbbHDSXx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 14:23:53 -0400
In-Reply-To: <1438709884-623-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c |   30 ++++++++++++++++--------------
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9ad819e..06d61a4 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3166,6 +3166,7 @@ struct qla_hw_data {
 #define IS_TGT_MODE_CAPABLE(ha)	(ha->tgt.atio_q_length)
 #define IS_SHADOW_REG_CAPABLE(ha)  (IS_QLA27XX(ha))
 #define IS_DPORT_CAPABLE(ha)  (IS_QLA83XX(ha) || IS_QLA27XX(ha))
+#define IS_FAWWN_CAPABLE(ha)	(IS_QLA83XX(ha) || IS_QLA27XX(ha))
 
 	/* HBA serial number */
 	uint8_t		serial0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index d19fe1b..5ac6577 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1135,20 +1135,22 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 			vha->fcoe_vn_port_mac[0] = mcp->mb[13] & 0xff;
 		}
 		/* If FA-WWN supported */
-		if (mcp->mb[7] & BIT_14) {
-			vha->port_name[0] = MSB(mcp->mb[16]);
-			vha->port_name[1] = LSB(mcp->mb[16]);
-			vha->port_name[2] = MSB(mcp->mb[17]);
-			vha->port_name[3] = LSB(mcp->mb[17]);
-			vha->port_name[4] = MSB(mcp->mb[18]);
-			vha->port_name[5] = LSB(mcp->mb[18]);
-			vha->port_name[6] = MSB(mcp->mb[19]);
-			vha->port_name[7] = LSB(mcp->mb[19]);
-			fc_host_port_name(vha->host) =
-			    wwn_to_u64(vha->port_name);
-			ql_dbg(ql_dbg_mbx, vha, 0x10ca,
-			    "FA-WWN acquired %016llx\n",
-			    wwn_to_u64(vha->port_name));
+		if (IS_FAWWN_CAPABLE(vha->hw)) {
+			if (mcp->mb[7] & BIT_14) {
+				vha->port_name[0] = MSB(mcp->mb[16]);
+				vha->port_name[1] = LSB(mcp->mb[16]);
+				vha->port_name[2] = MSB(mcp->mb[17]);
+				vha->port_name[3] = LSB(mcp->mb[17]);
+				vha->port_name[4] = MSB(mcp->mb[18]);
+				vha->port_name[5] = LSB(mcp->mb[18]);
+				vha->port_name[6] = MSB(mcp->mb[19]);
+				vha->port_name[7] = LSB(mcp->mb[19]);
+				fc_host_port_name(vha->host) =
+				    wwn_to_u64(vha->port_name);
+				ql_dbg(ql_dbg_mbx, vha, 0x10ca,
+				    "FA-WWN acquired %016llx\n",
+				    wwn_to_u64(vha->port_name));
+			}
 		}
 	}
 
-- 
1.7.7

