From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/20] qla2xxx: Correct queue-creation bug when driver loaded in QoS mode.
Date: Wed,  3 Jun 2009 09:55:16 -0700
Message-ID: <1244048131-56590-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZFCQze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:34 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   14 +++++++-------
 drivers/scsi/qla2xxx/qla_def.h  |    1 -
 drivers/scsi/qla2xxx/qla_os.c   |    1 +
 drivers/scsi/qla2xxx/qla_sup.c  |    8 +++-----
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 9aa00f2..2bd017f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1651,13 +1651,13 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 	qla24xx_vport_disable(fc_vport, disable);
 
 	ret = 0;
-	if (ha->cur_vport_count <= ha->flex_port_count || ql2xmultique_tag
-		|| ha->max_req_queues == 1 || !ha->npiv_info)
+	if (ql2xmaxqueues == 1 || ql2xmultique_tag || !ha->npiv_info)
 		goto vport_queue;
 	/* Create a request queue in QoS mode for the vport */
-	for (cnt = ha->flex_port_count; cnt < ha->nvram_npiv_size; cnt++) {
-		if (ha->npiv_info[cnt].port_name == vha->port_name &&
-			ha->npiv_info[cnt].node_name == vha->node_name) {
+	for (cnt = 0; cnt < ha->nvram_npiv_size; cnt++) {
+		if (memcmp(ha->npiv_info[cnt].port_name, vha->port_name, 8) == 0
+			&& memcmp(ha->npiv_info[cnt].node_name, vha->node_name,
+			8) == 0) {
 			qos = ha->npiv_info[cnt].q_qos;
 			break;
 		}
@@ -1671,8 +1671,8 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
 			vha->vp_idx);
 		else
 			DEBUG2(qla_printk(KERN_INFO, ha,
-			"Request Que:%d created for vp_idx:%d\n",
-			ret, vha->vp_idx));
+			"Request Que:%d (QoS: %d) created for vp_idx:%d\n",
+			ret, qos, vha->vp_idx));
 	}
 
 vport_queue:
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bb6bfd7..4e846ae 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2545,7 +2545,6 @@ struct qla_hw_data {
 	uint16_t        num_vsans;      /* number of vsan created */
 	uint16_t        max_npiv_vports;        /* 63 or 125 per topoloty */
 	int             cur_vport_count;
-	uint16_t	flex_port_count;
 
 	struct qla_chip_state_84xx *cs84xx;
 	struct qla_statistics qla_stats;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7415ead..181ed97 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1853,6 +1853,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ha->init_cb_size = sizeof(struct mid_init_cb_81xx);
 		ha->gid_list_info_size = 8;
 		ha->optrom_size = OPTROM_SIZE_81XX;
+		ha->nvram_npiv_size = QLA_MAX_VPORTS_QLA25XX;
 		ha->isp_ops = &qla81xx_isp_ops;
 		ha->flash_conf_off = FARX_ACCESS_FLASH_CONF_81XX;
 		ha->flash_data_off = FARX_ACCESS_FLASH_DATA_81XX;
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 22f97eb..e239203 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -920,12 +920,13 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 
 	entry = data + sizeof(struct qla_npiv_header);
 	cnt = le16_to_cpu(hdr.entries);
-	ha->flex_port_count = cnt;
 	for (i = 0; cnt; cnt--, entry++, i++) {
 		uint16_t flags;
 		struct fc_vport_identifiers vid;
 		struct fc_vport *vport;
 
+		memcpy(&ha->npiv_info[i], entry, sizeof(struct qla_npiv_entry));
+
 		flags = le16_to_cpu(entry->flags);
 		if (flags == 0xffff)
 			continue;
@@ -939,9 +940,7 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 		vid.port_name = wwn_to_u64(entry->port_name);
 		vid.node_name = wwn_to_u64(entry->node_name);
 
-		memcpy(&ha->npiv_info[i], entry, sizeof(struct qla_npiv_entry));
-
-		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
+		DEBUG2(qla_printk(KERN_INFO, ha, "NPIV[%02x]: wwpn=%llx "
 			"wwnn=%llx vf_id=0x%x Q_qos=0x%x F_qos=0x%x.\n", cnt,
 			vid.port_name, vid.node_name, le16_to_cpu(entry->vf_id),
 			entry->q_qos, entry->f_qos));
@@ -957,7 +956,6 @@ qla2xxx_flash_npiv_conf(scsi_qla_host_t *vha)
 	}
 done:
 	kfree(data);
-	ha->npiv_info = NULL;
 }
 
 static int
-- 
1.6.3.1.244.gf9275

