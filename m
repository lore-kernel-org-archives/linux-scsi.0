From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/18] qla2xxx: Cleanup NPIV related functions
Date: Thu, 10 Jul 2008 16:55:51 -0700
Message-ID: <1215734163-40825-6-git-send-email-andrew.vasquez@qlogic.com>
References: <20080710235458.GQ29099@plap4-2.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45262 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587AbYGJX4N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:56:13 -0400
In-Reply-To: <20080710235458.GQ29099@plap4-2.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

From: Seokmann Ju <seokmann.ju@qlogic.com>

Removed repeated or unnecessary operations during vport
creation/deletion.

Signed-off-by: Shyam Sundar <shyam.sundar@qlogic.com>
Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 ------
 drivers/scsi/qla2xxx/qla_def.h  |    1 -
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 -
 drivers/scsi/qla2xxx/qla_mid.c  |   11 +++--------
 drivers/scsi/qla2xxx/qla_os.c   |    8 +-------
 5 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 5d6dd95..2775413 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1175,17 +1175,11 @@ vport_create_failed_2:
 static int
 qla24xx_vport_delete(struct fc_vport *fc_vport)
 {
-	scsi_qla_host_t *ha = shost_priv(fc_vport->shost);
 	scsi_qla_host_t *vha = fc_vport->dd_data;
 
 	qla24xx_disable_vp(vha);
 	qla24xx_deallocate_vp_id(vha);
 
-	mutex_lock(&ha->vport_lock);
-	ha->cur_vport_count--;
-	clear_bit(vha->vp_idx, ha->vp_idx_map);
-	mutex_unlock(&ha->vport_lock);
-
 	kfree(vha->node_name);
 	kfree(vha->port_name);
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2b1bc57..00c7052 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2170,7 +2170,6 @@ typedef struct scsi_qla_host {
 	struct pci_dev	*pdev;
 
 	unsigned long	host_no;
-	unsigned long	instance;
 
 	volatile struct {
 		uint32_t	init_done		:1;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 5a50fb7..1d57ddd 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -62,7 +62,6 @@ extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
-extern int num_hosts;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 62a3ad6..fa35339 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -43,6 +43,7 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 
 	set_bit(vp_id, ha->vp_idx_map);
 	ha->num_vhosts++;
+	ha->cur_vport_count++;
 	vha->vp_idx = vp_id;
 	list_add_tail(&vha->vp_list, &ha->vp_list);
 	mutex_unlock(&ha->vport_lock);
@@ -58,6 +59,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
 	mutex_lock(&ha->vport_lock);
 	vp_id = vha->vp_idx;
 	ha->num_vhosts--;
+	ha->cur_vport_count--;
 	clear_bit(vp_id, ha->vp_idx_map);
 	list_del(&vha->vp_list);
 	mutex_unlock(&ha->vport_lock);
@@ -390,7 +392,6 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	vha->parent = ha;
 	vha->fc_vport = fc_vport;
 	vha->device_flags = 0;
-	vha->instance = num_hosts;
 	vha->vp_idx = qla24xx_allocate_vp_id(vha);
 	if (vha->vp_idx > ha->max_npiv_vports) {
 		DEBUG15(printk("scsi(%ld): Couldn't allocate vp_id.\n",
@@ -428,7 +429,7 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = MAX_BUSES - 1;
 	host->max_lun = MAX_LUNS;
-	host->unique_id = vha->instance;
+	host->unique_id = host->host_no;
 	host->max_id = MAX_TARGETS_2200;
 	host->transportt = qla2xxx_transport_vport_template;
 
@@ -436,12 +437,6 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	    vha->host_no, vha));
 
 	vha->flags.init_done = 1;
-	num_hosts++;
-
-	mutex_lock(&ha->vport_lock);
-	set_bit(vha->vp_idx, ha->vp_idx_map);
-	ha->cur_vport_count++;
-	mutex_unlock(&ha->vport_lock);
 
 	return vha;
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 047ee64..e98d502 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -27,7 +27,6 @@ char qla2x00_version_str[40];
  */
 static struct kmem_cache *srb_cachep;
 
-int num_hosts;
 int ql2xlogintimeout = 20;
 module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xlogintimeout,
@@ -1663,9 +1662,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 	host->can_queue = ha->request_q_length + 128;
 
-	/* load the F/W, read paramaters, and init the H/W */
-	ha->instance = num_hosts;
-
 	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
@@ -1713,7 +1709,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	host->this_id = 255;
 	host->cmd_per_lun = 3;
-	host->unique_id = ha->instance;
+	host->unique_id = host->host_no;
 	host->max_cmd_len = MAX_CMDSZ;
 	host->max_channel = MAX_BUSES - 1;
 	host->max_lun = MAX_LUNS;
@@ -1734,8 +1730,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->flags.init_done = 1;
 	ha->flags.online = 1;
 
-	num_hosts++;
-
 	ret = scsi_add_host(host, &pdev->dev);
 	if (ret)
 		goto probe_failed;
-- 
1.5.6.2.292.ga9a3

