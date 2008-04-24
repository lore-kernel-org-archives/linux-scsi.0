From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 08/10] qla2xxx: Correct misc. endian and byte-ordering issues.
Date: Thu, 24 Apr 2008 15:21:29 -0700
Message-ID: <1209075691-6539-8-git-send-email-andrew.vasquez@qlogic.com>
References: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20337 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbYDXWVl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 18:21:41 -0400
In-Reply-To: <20080424221945.GC4359@n8027av35btxc1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

There were several places in the driver which could cause byte
ordering problem as provided by Al Viro
<viro@ZenIV.linux.org.uk>.

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h   |   26 +++++---------------------
 drivers/scsi/qla2xxx/qla_gs.c   |    4 ++--
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |   13 ++++++-------
 4 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 078f2a1..cf19451 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1036,22 +1036,6 @@ struct mid_db_entry_24xx {
 	uint8_t reserved_1;
 };
 
- /*
- * Virtual Fabric ID type definition.
- */
-typedef struct vf_id {
-        uint16_t id : 12;
-        uint16_t priority : 4;
-} vf_id_t;
-
-/*
- * Virtual Fabric HopCt type definition.
- */
-typedef struct vf_hopct {
-        uint16_t reserved : 8;
-        uint16_t hopct : 8;
-} vf_hopct_t;
-
 /*
  * Virtual Port Control IOCB
  */
@@ -1082,10 +1066,10 @@ struct vp_ctrl_entry_24xx {
 
 	uint8_t vp_idx_map[16];
 	uint16_t flags;
-	struct vf_id    id;
+	uint16_t id;
 	uint16_t reserved_4;
-	struct vf_hopct  hopct;
-	uint8_t reserved_5[8];
+	uint16_t hopct;
+	uint8_t reserved_5[24];
 };
 
 /*
@@ -1132,9 +1116,9 @@ struct vp_config_entry_24xx {
 	uint16_t reserved_vp2;
 	uint8_t port_name_idx2[WWN_SIZE];
 	uint8_t node_name_idx2[WWN_SIZE];
-	struct vf_id    id;
+	uint16_t id;
 	uint16_t reserved_4;
-	struct vf_hopct  hopct;
+	uint16_t hopct;
 	uint8_t reserved_5;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 750d7ef..4cb80b4 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1583,8 +1583,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *ha)
 	eiter->type = __constant_cpu_to_be16(FDMI_PORT_MAX_FRAME_SIZE);
 	eiter->len = __constant_cpu_to_be16(4 + 4);
 	max_frame_size = IS_FWI2_CAPABLE(ha) ?
-		(uint32_t) icb24->frame_payload_size:
-		(uint32_t) ha->init_cb->frame_payload_size;
+	    le16_to_cpu(icb24->frame_payload_size):
+	    le16_to_cpu(ha->init_cb->frame_payload_size);
 	eiter->a.max_frame_size = cpu_to_be32(max_frame_size);
 	size += 4 + 4;
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 01e2608..bbbc5a6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3645,7 +3645,7 @@ qla24xx_nvram_config(scsi_qla_host_t *ha)
 	if (le16_to_cpu(nv->login_timeout) < 4)
 		nv->login_timeout = __constant_cpu_to_le16(4);
 	ha->login_timeout = le16_to_cpu(nv->login_timeout);
-	icb->login_timeout = cpu_to_le16(nv->login_timeout);
+	icb->login_timeout = nv->login_timeout;
 
 	/* Set minimum RATOV to 100 tenths of a second. */
 	ha->r_a_tov = 100;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 875c418..2100604 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1468,7 +1468,7 @@ qla24xx_login_fabric(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = cpu_to_le16(ha->vp_idx);
+	lg->vp_index = ha->vp_idx;
 	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Login IOCB "
@@ -1723,7 +1723,7 @@ qla24xx_fabric_logout(scsi_qla_host_t *ha, uint16_t loop_id, uint8_t domain,
 	lg->port_id[0] = al_pa;
 	lg->port_id[1] = area;
 	lg->port_id[2] = domain;
-	lg->vp_index = cpu_to_le16(ha->vp_idx);
+	lg->vp_index = ha->vp_idx;
 	rval = qla2x00_issue_iocb(ha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
 		DEBUG2_3_11(printk("%s(%ld): failed to issue Logout IOCB "
@@ -2642,12 +2642,11 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 	struct vp_rpt_id_entry_24xx *rptid_entry)
 {
 	uint8_t vp_idx;
+	uint16_t stat = le16_to_cpu(rptid_entry->vp_idx);
 	scsi_qla_host_t *vha;
 
 	if (rptid_entry->entry_status != 0)
 		return;
-	if (rptid_entry->entry_status != __constant_cpu_to_le16(CS_COMPLETE))
-		return;
 
 	if (rptid_entry->format == 0) {
 		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs setup %d,"
@@ -2657,17 +2656,17 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *ha,
 			rptid_entry->port_id[2], rptid_entry->port_id[1],
 			rptid_entry->port_id[0]));
 	} else if (rptid_entry->format == 1) {
-		vp_idx = LSB(rptid_entry->vp_idx);
+		vp_idx = LSB(stat);
 		DEBUG15(printk("%s:format 1: scsi(%ld): VP[%d] enabled "
 		    "- status %d - "
 		    "with port id %02x%02x%02x\n",__func__,ha->host_no,
-		    vp_idx, MSB(rptid_entry->vp_idx),
+		    vp_idx, MSB(stat),
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]));
 		if (vp_idx == 0)
 			return;
 
-		if (MSB(rptid_entry->vp_idx) == 1)
+		if (MSB(stat) == 1)
 			return;
 
 		list_for_each_entry(vha, &ha->vp_list, vp_list)
-- 
1.5.5.1.67.gbdb8

