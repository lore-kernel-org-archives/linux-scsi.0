From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 2/4] qla2xxx: Correct NPIV support for recent ISPs.
Date: Mon, 12 Nov 2007 10:30:58 -0800
Message-ID: <1194892260-27318-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20071112182950.GC20765@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33202 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbXKLSbX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Nov 2007 13:31:23 -0500
In-Reply-To: <20071112182950.GC20765@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Firmware will export to software the maximum number of vports
supported for any given firmware version and ISP type.  Use this
information rather than the current hardcoding of limitations
within the driver.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    2 +-
 drivers/scsi/qla2xxx/qla_def.h  |   10 +---------
 drivers/scsi/qla2xxx/qla_fw.h   |   16 ++++++++++------
 drivers/scsi/qla2xxx/qla_init.c |   19 +++++++------------
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_mid.c  |   33 ++++++++++++---------------------
 6 files changed, 33 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fb388b8..745283f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1124,7 +1124,7 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	down(&ha->vport_sem);
 	ha->cur_vport_count--;
-	clear_bit(vha->vp_idx, (unsigned long *)ha->vp_idx_map);
+	clear_bit(vha->vp_idx, ha->vp_idx_map);
 	up(&ha->vport_sem);
 
 	kfree(vha->node_name);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 04e8cbc..fe8f782 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2116,14 +2116,6 @@ struct qla_msix_entry {
 
 #define	WATCH_INTERVAL		1       /* number of seconds */
 
-/* NPIV */
-#define MAX_MULTI_ID_LOOP                     126
-#define MAX_MULTI_ID_FABRIC                    64
-#define MAX_NUM_VPORT_LOOP                      (MAX_MULTI_ID_LOOP - 1)
-#define MAX_NUM_VPORT_FABRIC                    (MAX_MULTI_ID_FABRIC - 1)
-#define MAX_NUM_VHBA_LOOP                       (MAX_MULTI_ID_LOOP - 1)
-#define MAX_NUM_VHBA_FABRIC                     (MAX_MULTI_ID_FABRIC - 1)
-
 /*
  * Linux Host Adapter structure
  */
@@ -2507,7 +2499,7 @@ typedef struct scsi_qla_host {
 
 	struct list_head	vp_list;	/* list of VP */
 	struct fc_vport	*fc_vport;	/* holds fc_vport * for each vport */
-	uint8_t		vp_idx_map[16];
+	unsigned long	vp_idx_map[(MAX_MULTI_ID_FABRIC / 8) / sizeof(unsigned long)];
 	uint16_t        num_vhosts;	/* number of vports created */
 	uint16_t        num_vsans;	/* number of vsan created */
 	uint16_t        vp_idx;		/* vport ID */
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 25364b1..69a5e31 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -954,7 +954,15 @@ struct device_reg_24xx {
 
 /* MID Support ***************************************************************/
 
-#define MAX_MID_VPS	125
+#define MIN_MULTI_ID_FABRIC	64	/* Must be power-of-2. */
+#define MAX_MULTI_ID_FABRIC	256	/* ... */
+
+#define for_each_mapped_vp_idx(_ha, _idx)		\
+	for (_idx = find_next_bit((_ha)->vp_idx_map,	\
+		(_ha)->max_npiv_vports + 1, 1);		\
+	    _idx <= (_ha)->max_npiv_vports;		\
+	    _idx = find_next_bit((_ha)->vp_idx_map,	\
+		(_ha)->max_npiv_vports + 1, _idx + 1))	\
 
 struct mid_conf_entry_24xx {
 	uint16_t reserved_1;
@@ -982,7 +990,7 @@ struct mid_init_cb_24xx {
 	uint16_t count;
 	uint16_t options;
 
-	struct mid_conf_entry_24xx entries[MAX_MID_VPS];
+	struct mid_conf_entry_24xx entries[MAX_MULTI_ID_FABRIC];
 };
 
 
@@ -1002,10 +1010,6 @@ struct mid_db_entry_24xx {
 	uint8_t reserved_1;
 };
 
-struct mid_db_24xx {
-	struct mid_db_entry_24xx entries[MAX_MID_VPS];
-};
-
  /*
  * Virtual Fabric ID type definition.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 191dafd..03444d6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -922,9 +922,9 @@ qla2x00_setup_chip(scsi_qla_host_t *ha)
 					ha->flags.npiv_supported = 1;
 					if ((!ha->max_npiv_vports) ||
 					    ((ha->max_npiv_vports + 1) %
-					    MAX_MULTI_ID_FABRIC))
+					    MIN_MULTI_ID_FABRIC))
 						ha->max_npiv_vports =
-						    MAX_NUM_VPORT_FABRIC;
+						    MIN_MULTI_ID_FABRIC - 1;
 				}
 
 				if (ql2xallocfwdump)
@@ -1162,7 +1162,8 @@ qla2x00_init_rings(scsi_qla_host_t *ha)
 
 	DEBUG(printk("scsi(%ld): Issue init firmware.\n", ha->host_no));
 
-	mid_init_cb->count = ha->max_npiv_vports;
+	mid_init_cb->count = cpu_to_le16(ha->max_npiv_vports);
+	mid_init_cb->options = __constant_cpu_to_le16(BIT_1);
 
 	rval = qla2x00_init_firmware(ha, ha->init_cb_size);
 	if (rval) {
@@ -2566,14 +2567,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 
 		/* Bypass virtual ports of the same host. */
 		if (pha->num_vhosts) {
-			vp_index = find_next_bit(
-			    (unsigned long *)pha->vp_idx_map,
-			    MAX_MULTI_ID_FABRIC + 1, 1);
-
-			for (;vp_index <= MAX_MULTI_ID_FABRIC;
-			    vp_index = find_next_bit(
-			    (unsigned long *)pha->vp_idx_map,
-			    MAX_MULTI_ID_FABRIC + 1, vp_index + 1)) {
+			for_each_mapped_vp_idx(pha, vp_index) {
 				empty_vp_index = 1;
 				found_vp = 0;
 				list_for_each_entry(vha, &pha->vp_list,
@@ -2592,7 +2586,8 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *ha, struct list_head *new_fcports)
 				    new_fcport->d_id.b24 == vha->d_id.b24)
 					break;
 			}
-			if (vp_index <= MAX_MULTI_ID_FABRIC)
+
+			if (vp_index <= pha->max_npiv_vports)
 				continue;
 		}
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ccd662a..031f269 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -905,7 +905,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *ha, uint16_t *id, uint8_t *al_pa,
 
 	mcp->mb[0] = MBC_GET_ADAPTER_LOOP_ID;
 	mcp->mb[9] = ha->vp_idx;
-	mcp->out_mb = MBX_0;
+	mcp->out_mb = MBX_9|MBX_0;
 	mcp->in_mb = MBX_9|MBX_7|MBX_6|MBX_3|MBX_2|MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = 0;
@@ -2873,7 +2873,7 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	DEBUG11(printk("%s(%ld): entered. Enabling index %d\n", __func__,
 	    ha->host_no, vp_index));
 
-	if (vp_index == 0 || vp_index >= MAX_MULTI_ID_LOOP)
+	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
 
 	vce = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vce_dma);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 821ee74..74096aa 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -47,16 +47,15 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 
 	/* Find an empty slot and assign an vp_id */
 	down(&ha->vport_sem);
-	vp_id = find_first_zero_bit((unsigned long *)ha->vp_idx_map,
-				MAX_MULTI_ID_FABRIC);
-	if (vp_id > MAX_MULTI_ID_FABRIC) {
-		DEBUG15(printk ("vp_id %d is bigger than MAX_MULTI_ID_FABRID\n",
-		    vp_id));
+	vp_id = find_first_zero_bit(ha->vp_idx_map, ha->max_npiv_vports + 1);
+	if (vp_id > ha->max_npiv_vports) {
+		DEBUG15(printk ("vp_id %d is bigger than max-supported %d.\n",
+		    vp_id, ha->max_npiv_vports));
 		up(&ha->vport_sem);
 		return vp_id;
 	}
 
-	set_bit(vp_id, (unsigned long *)ha->vp_idx_map);
+	set_bit(vp_id, ha->vp_idx_map);
 	ha->num_vhosts++;
 	vha->vp_idx = vp_id;
 	list_add_tail(&vha->vp_list, &ha->vp_list);
@@ -73,7 +72,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	down(&ha->vport_sem);
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
-	clear_bit(vp_id, (unsigned long *)ha->vp_idx_map);
+	clear_bit(vp_id, ha->vp_idx_map);
 	list_del(&vha->vp_list);
 	up(&ha->vport_sem);
 }
@@ -216,11 +215,7 @@ qla2x00_alert_all_vps(scsi_qla_host_t *ha, uint16_t *mb)
 	if (ha->parent)
 		return;
 
-	i = find_next_bit((unsigned long *)ha->vp_idx_map,
-	    MAX_MULTI_ID_FABRIC + 1, 1);
-	for (;i <= MAX_MULTI_ID_FABRIC;
-	    i = find_next_bit((unsigned long *)ha->vp_idx_map,
-	    MAX_MULTI_ID_FABRIC + 1, i + 1)) {
+	for_each_mapped_vp_idx(ha, i) {
 		vp_idx_matched = 0;
 
 		list_for_each_entry(vha, &ha->vp_list, vp_list) {
@@ -311,11 +306,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *ha)
 
 	clear_bit(VP_DPC_NEEDED, &ha->dpc_flags);
 
-	i = find_next_bit((unsigned long *)ha->vp_idx_map,
-	    MAX_MULTI_ID_FABRIC + 1, 1);
-	for (;i <= MAX_MULTI_ID_FABRIC;
-	    i = find_next_bit((unsigned long *)ha->vp_idx_map,
-	    MAX_MULTI_ID_FABRIC + 1, i + 1)) {
+	for_each_mapped_vp_idx(ha, i) {
 		vp_idx_matched = 0;
 
 		list_for_each_entry(vha, &ha->vp_list, vp_list) {
@@ -356,9 +347,9 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 
 	/* Check up max-npiv-supports */
 	if (ha->num_vhosts > ha->max_npiv_vports) {
-		DEBUG15(printk("scsi(%ld): num_vhosts %d is bigger than "
-		    "max_npv_vports %d.\n", ha->host_no,
-		    (uint16_t) ha->num_vhosts, (int) ha->max_npiv_vports));
+		DEBUG15(printk("scsi(%ld): num_vhosts %ud is bigger than "
+		    "max_npv_vports %ud.\n", ha->host_no,
+		    ha->num_vhosts, ha->max_npiv_vports));
 		return VPCERR_UNSUPPORTED;
 	}
 	return 0;
@@ -450,7 +441,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	num_hosts++;
 
 	down(&ha->vport_sem);
-	set_bit(vha->vp_idx, (unsigned long *)ha->vp_idx_map);
+	set_bit(vha->vp_idx, ha->vp_idx_map);
 	ha->cur_vport_count++;
 	up(&ha->vport_sem);
 
-- 
1.5.3.5.643.g40e25

