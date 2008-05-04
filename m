From: matthias@kaehlcke.net
Subject: [patch 2/2] QLA2xxx: Convert vport_sem in a mutex
Date: Sun, 04 May 2008 20:46:01 +0200
Message-ID: <20080504184600.556630258@kaehlcke.net>
References: <20080504184559.243525572@kaehlcke.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:39008 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758134AbYEDTZy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 May 2008 15:25:54 -0400
Content-Disposition: inline; filename=scsi-qla2xxx-vport_sem-to-mutex.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-driver@qlogic.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Matthias Kaehlcke <matthias@kaehlcke.net>

QLA2XXX driver: The semaphore vport_sem is used as a mutex. 
Convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/scsi/qla2xxx/qla_attr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_attr.c	2008-05-04 19:24:14.000000000 +0200
+++ linux-2.6/drivers/scsi/qla2xxx/qla_attr.c	2008-05-04 19:24:59.000000000 +0200
@@ -1154,10 +1154,10 @@
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
Index: linux-2.6/drivers/scsi/qla2xxx/qla_def.h
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_def.h	2008-05-04 19:24:18.000000000 +0200
+++ linux-2.6/drivers/scsi/qla2xxx/qla_def.h	2008-05-04 19:25:47.000000000 +0200
@@ -2410,7 +2410,7 @@
 #define MBX_INTR_WAIT	2
 #define MBX_UPDATE_FLASH_ACTIVE	3
 
-	struct semaphore vport_sem;	/* Virtual port synchronization */
+	struct mutex vport_lock;	/* Virtual port synchronization */
 	struct completion mbx_cmd_comp;	/* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 
Index: linux-2.6/drivers/scsi/qla2xxx/qla_mbx.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_mbx.c	2008-05-04 19:24:22.000000000 +0200
+++ linux-2.6/drivers/scsi/qla2xxx/qla_mbx.c	2008-05-04 19:26:08.000000000 +0200
@@ -2753,9 +2753,9 @@
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
Index: linux-2.6/drivers/scsi/qla2xxx/qla_mid.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_mid.c	2008-05-04 19:24:24.000000000 +0200
+++ linux-2.6/drivers/scsi/qla2xxx/qla_mid.c	2008-05-04 19:26:19.000000000 +0200
@@ -46,12 +46,12 @@
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
 
@@ -59,7 +59,7 @@
 	ha->num_vhosts++;
 	vha->vp_idx = vp_id;
 	list_add_tail(&vha->vp_list, &ha->vp_list);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 	return vp_id;
 }
 
@@ -69,12 +69,12 @@
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
@@ -159,9 +159,9 @@
 	}
 
 	/* Initialize the new vport unless it is a persistent port */
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	ret = qla24xx_modify_vp_config(vha);
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	if (ret != QLA_SUCCESS) {
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_FAILED);
@@ -443,10 +443,10 @@
 	vha->flags.init_done = 1;
 	num_hosts++;
 
-	down(&ha->vport_sem);
+	mutex_lock(&ha->vport_lock);
 	set_bit(vha->vp_idx, ha->vp_idx_map);
 	ha->cur_vport_count++;
-	up(&ha->vport_sem);
+	mutex_unlock(&ha->vport_lock);
 
 	return vha;
 
Index: linux-2.6/drivers/scsi/qla2xxx/qla_os.c
===================================================================
--- linux-2.6.orig/drivers/scsi/qla2xxx/qla_os.c	2008-05-04 19:24:27.000000000 +0200
+++ linux-2.6/drivers/scsi/qla2xxx/qla_os.c	2008-05-04 19:26:36.000000000 +0200
@@ -1705,7 +1705,7 @@
 	/* load the F/W, read paramaters, and init the H/W */
 	ha->instance = num_hosts;
 
-	init_MUTEX(&ha->vport_sem);
+	mutex_init(&ha->vport_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
 	init_completion(&ha->mbx_intr_comp);

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
