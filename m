From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 12/19] qla2xxx: Retrieve max-NPIV support capabilities from FW.
Date: Thu, 20 Sep 2007 14:07:43 -0700
Message-ID: <1190322470-15543-12-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXITVIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:08:00 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 drivers/scsi/qla2xxx/qla_def.h  |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 ++--
 drivers/scsi/qla2xxx/qla_init.c |   16 +++++++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c  |   11 +++++++----
 5 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 445d583..c90dc59 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1250,6 +1250,6 @@ qla2x00_init_host_attr(scsi_qla_host_t *ha)
 	fc_host_node_name(ha->host) = wwn_to_u64(ha->node_name);
 	fc_host_port_name(ha->host) = wwn_to_u64(ha->port_name);
 	fc_host_supported_classes(ha->host) = FC_COS_CLASS3;
-	fc_host_max_npiv_vports(ha->host) = MAX_NUM_VPORT_FABRIC;
+	fc_host_max_npiv_vports(ha->host) = ha->max_npiv_vports;;
 	fc_host_npiv_vports_inuse(ha->host) = ha->cur_vport_count;
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 511e3cd..1396f4d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2534,7 +2534,7 @@ typedef struct scsi_qla_host {
 #define VP_ERR_FAB_NORESOURCES	3
 #define VP_ERR_FAB_LOGOUT	4
 #define VP_ERR_ADAP_NORESOURCES	5
-	int		max_npiv_vports;	/* 63 or 125 per topoloty */
+	uint16_t	max_npiv_vports;	/* 63 or 125 per topoloty */
 	int		cur_vport_count;
 } scsi_qla_host_t;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index e8122e8..09cb2a9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -215,8 +215,8 @@ extern int
 qla2x00_get_id_list(scsi_qla_host_t *, void *, dma_addr_t, uint16_t *);
 
 extern int
-qla2x00_get_resource_cnts(scsi_qla_host_t *, uint16_t *, uint16_t *, uint16_t *,
-    uint16_t *);
+qla2x00_get_resource_cnts(scsi_qla_host_t *, uint16_t *, uint16_t *,
+    uint16_t *, uint16_t *, uint16_t *);
 
 extern int
 qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 45da947..191dafd 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -849,7 +849,8 @@ qla2x00_resize_request_q(scsi_qla_host_t *ha)
 		return;
 
 	/* Retrieve IOCB counts available to the firmware. */
-	rval = qla2x00_get_resource_cnts(ha, NULL, NULL, NULL, &fw_iocb_cnt);
+	rval = qla2x00_get_resource_cnts(ha, NULL, NULL, NULL, &fw_iocb_cnt,
+	    &ha->max_npiv_vports);
 	if (rval)
 		return;
 	/* No point in continuing if current settings are sufficient. */
@@ -916,9 +917,15 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 				    &ha->fw_attributes, &ha->fw_memory_size);
 				qla2x00_resize_request_q(ha);
 				ha->flags.npiv_supported = 0;
-				if (IS_QLA24XX(ha) &&
-				    (ha->fw_attributes & BIT_2))
+				if ((IS_QLA24XX(ha) || IS_QLA25XX(ha)) &&
+				    (ha->fw_attributes & BIT_2)) {
 					ha->flags.npiv_supported = 1;
+					if ((!ha->max_npiv_vports) ||
+					    ((ha->max_npiv_vports + 1) %
+					    MAX_MULTI_ID_FABRIC))
+						ha->max_npiv_vports =
+						    MAX_NUM_VPORT_FABRIC;
+				}
 
 				if (ql2xallocfwdump)
 					qla2x00_alloc_fw_dump(ha);
@@ -1155,8 +1162,7 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
 
-	mid_init_cb->count = MAX_NUM_VPORT_FABRIC;
-	ha->max_npiv_vports = MAX_NUM_VPORT_FABRIC;
+	mid_init_cb->count = ha->max_npiv_vports;
 
 	rval = qla2x00_init_firmware(ha, ha->init_cb_size);
 	if (rval) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e4f4b1f..ec48871 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1919,7 +1919,8 @@ qla2x00_get_id_list(scsi_qla_host_t *ha, void *id_list, dma_addr_t id_list_dma,
  */
 int
 qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
-    uint16_t *orig_xchg_cnt, uint16_t *cur_iocb_cnt, uint16_t *orig_iocb_cnt)
+    uint16_t *orig_xchg_cnt, uint16_t *cur_iocb_cnt,
+    uint16_t *orig_iocb_cnt, uint16_t *max_npiv_vports)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -1929,7 +1930,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 
 	mcp->mb[0] = MBC_GET_RESOURCE_COUNTS;
 	mcp->out_mb = MBX_0;
-	mcp->in_mb = MBX_10|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
+	mcp->in_mb = MBX_11|MBX_10|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(ha, mcp);
@@ -1940,9 +1941,9 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 		    ha->host_no, mcp->mb[0]));
 	} else {
 		DEBUG11(printk("%s(%ld): done. mb1=%x mb2=%x mb3=%x mb6=%x "
-		    "mb7=%x mb10=%x.\n", __func__, ha->host_no,
+		    "mb7=%x mb10=%x mb11=%x.\n", __func__, ha->host_no,
 		    mcp->mb[1], mcp->mb[2], mcp->mb[3], mcp->mb[6], mcp->mb[7],
-		    mcp->mb[10]));
+		    mcp->mb[10], mcp->mb[11]));
 
 		if (cur_xchg_cnt)
 			*cur_xchg_cnt = mcp->mb[3];
@@ -1952,6 +1953,8 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *ha, uint16_t *cur_xchg_cnt,
 			*cur_iocb_cnt = mcp->mb[7];
 		if (orig_iocb_cnt)
 			*orig_iocb_cnt = mcp->mb[10];
+		if (max_npiv_vports)
+			*max_npiv_vports = mcp->mb[11];
 	}
 
 	return (rval);
-- 
1.5.3.2.80.g077d6f

