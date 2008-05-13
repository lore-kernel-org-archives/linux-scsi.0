From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/10] qla2xxx: Convert vport_sem to a mutex
Date: Mon, 12 May 2008 22:21:11 -0700
Message-ID: <1210656076-54720-5-git-send-email-andrew.vasquez@qlogic.com>
References: <20080513051948.GN22377@plap4.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52305 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbYEMFVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:21:19 -0400
In-Reply-To: <20080513051948.GN22377@plap4.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, "matthias@kaehlcke.net" <matthias@kaehlcke.net>

From: matthias@kaehlcke.net <matthias@kaehlcke.net>

The semaphore vport_sem is used as a mutex.  Convert it to the
mutex API.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
 drivers/scsi/qla2xxx/qla_def.h  |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 ++--
 drivers/scsi/qla2xxx/qla_mid.c  |   18 +++++++++---------
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2caf841..48318d0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1176,10 +1176,10 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 	qla24xx_disable_vp(vha);
 	qla24xx_deallocate_vp_id(vha);
 
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	ha->cur_vport_count--;
 	clear_bit(vha->vp_idx, ha->vp_idx_map);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	kfree(vha->node_name);
 	kfree(vha->port_name);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 299eccf..8dd6000 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2457,7 +2457,7 @@ typedef struct scsi_qla_host {
 #define MBX_INTR_WAIT	2
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
-	struct semaphore vport_sem;	/* Virtual port synchronization */
+	struct mutex vport_lock;	/* Virtual port synchronization */
 	struct completion mbx_cmd_comp;	/* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 2100604..3800876 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2807,9 +2807,9 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	 */
 	map = (vp_index - 1) / 8;
 	pos = (vp_index - 1) & 7;
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	vce->vp_idx_map[map] |= 1 << pos;
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	rval = qla2x00_issue_iocb(ha, vce, vce_dma, 0);
 	if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index f2b0497..fc55429 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -32,12 +32,12 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	scsi_qla_host_t *ha = vha->parent;
 
 	/* Find an empty slot and assign an vp_id */
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	vp_id = find_first_zero_bit(ha->vp_idx_map, ha->max_npiv_vports + 1);
 	if (vp_id > ha->max_npiv_vports) {
 		DEBUG15(printk ("vp_id %d is bigger than max-supported %d.\n",
 		    vp_id, ha->max_npiv_vports));
-		up(&ha->vport_sem);
+		mutex_unlock(&ha->vport_lock);
 		return vp_id;
 	}
 
@@ -45,7 +45,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	ha->num_vhosts++;
 	vha->vp_idx = vp_id;
 	list_add_tail(&vha->vp_list, &ha->vp_list);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 	return vp_id;
 }
 
@@ -55,12 +55,12 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	uint16_t vp_id;
 	scsi_qla_host_t *ha = vha->parent;
 
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
 	clear_bit(vp_id, ha->vp_idx_map);
 	list_del(&vha->vp_list);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 }
 
 static scsi_qla_host_t *
@@ -145,9 +145,9 @@ qla24xx_enable_vp(scsi_qla_host_t *vha)
 	}
 
 	/* Initialize the new vport unless it is a persistent port */
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	ret = qla24xx_modify_vp_config(vha);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	if (ret != QLA_SUCCESS) {
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
@@ -437,10 +437,10 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	vha->flags.init_done = 1;
 	num_hosts++;
 
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	set_bit(vha->vp_idx, ha->vp_idx_map);
 	ha->cur_vport_count++;
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	return vha;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9982ecd..817f62f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1632,7 +1632,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* load the F/W, read paramaters, and init the H/W */
 	ha->instance = num_hosts;
 
-	init_MUTEX(&ha->vport_sem);
+	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
 	init_completion(&ha->mbx_intr_comp);
-- 
1.5.5.1.211.g65ea3

