From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/26] qla2xxx: Correct ISP abort semantics for NVRAM, VPD, and flash update.
Date: Tue, 24 Mar 2009 09:08:07 -0700
Message-ID: <1237910900-30817-14-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29880 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760552AbZCXQIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:34 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Ensure that an ISP-abort has completed before performing any
update.  After the update do not wait for an ISP-abort completion,
instead just wait until the ISP is reset.  This avoids long
delays due to waiting for loop ready in qla2x00_abort_isp().

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Additional cleanups and
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   21 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_def.h  |    1 +
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |    5 +++++
 drivers/scsi/qla2xxx/qla_os.c   |   28 ++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_sup.c  |    2 +-
 6 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 41ce1c6..117517d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -137,12 +137,21 @@ qla2x00_sysfs_write_nvram(struct kobject *kobj,
 		*iter = chksum;
 	}
 
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "HBA not online, failing NVRAM update.\n");
+		return -EAGAIN;
+	}
+
 	/* Write NVRAM. */
 	ha->isp_ops->write_nvram(vha, (uint8_t *)buf, ha->nvram_base, count);
 	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->nvram, ha->nvram_base,
 	    count);
 
+	/* NVRAM settings take effect immediately. */
 	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
+	qla2xxx_wake_dpc(vha);
+	qla2x00_wait_for_chip_reset(vha);
 
 	return (count);
 }
@@ -330,6 +339,12 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 		if (ha->optrom_state != QLA_SWRITING)
 			break;
 
+		if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+			qla_printk(KERN_WARNING, ha,
+			    "HBA not online, failing flash update.\n");
+			return -EAGAIN;
+		}
+
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "Writing flash region -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size));
@@ -380,6 +395,12 @@ qla2x00_sysfs_write_vpd(struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->vpd_size)
 		return 0;
 
+	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+		qla_printk(KERN_WARNING, ha,
+		    "HBA not online, failing VPD update.\n");
+		return -EAGAIN;
+	}
+
 	/* Write NVRAM. */
 	ha->isp_ops->write_nvram(vha, (uint8_t *)buf, ha->vpd_base, count);
 	ha->isp_ops->read_nvram(vha, (uint8_t *)ha->vpd, ha->vpd_base, count);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bca572f..421c634 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2261,6 +2261,7 @@ struct qla_hw_data {
 		uint32_t	npiv_supported		:1;
 		uint32_t	fce_enabled		:1;
 		uint32_t	fac_supported		:1;
+		uint32_t	chip_reset_done		:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 4d52bf1..c75e7f9 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -110,6 +110,7 @@ extern void qla2x00_mark_all_devices_lost(scsi_qla_host_t *, int);
 extern struct fw_blob *qla2x00_request_firmware(scsi_qla_host_t *);
 
 extern int qla2x00_wait_for_hba_online(scsi_qla_host_t *);
+extern int qla2x00_wait_for_chip_reset(scsi_qla_host_t *);
 
 extern void qla2xxx_wake_dpc(struct scsi_qla_host *);
 extern void qla2x00_alert_all_vps(struct rsp_que *, uint16_t *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c37888e..a274750 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -61,8 +61,10 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	int	rval;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
+
 	/* Clear adapter flags. */
 	vha->flags.online = 0;
+	ha->flags.chip_reset_done = 0;
 	vha->flags.reset_active = 0;
 	atomic_set(&vha->loop_down_timer, LOOP_DOWN_TIME);
 	atomic_set(&vha->loop_state, LOOP_DOWN);
@@ -131,6 +133,7 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		}
 	}
 	rval = qla2x00_init_rings(vha);
+	ha->flags.chip_reset_done = 1;
 
 	return (rval);
 }
@@ -3321,6 +3324,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 
 	if (vha->flags.online) {
 		vha->flags.online = 0;
+		ha->flags.chip_reset_done = 0;
 		clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 		ha->qla_stats.total_isp_aborts++;
 
@@ -3470,6 +3474,7 @@ qla2x00_restart_isp(scsi_qla_host_t *vha)
 
 	if (!status && !(status = qla2x00_init_rings(vha))) {
 		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
+		ha->flags.chip_reset_done = 1;
 		/* Initialize the queues in use */
 		qla25xx_init_queues(ha);
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index c795461..1c3d165 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -535,6 +535,34 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *vha)
 	return (return_status);
 }
 
+int
+qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
+{
+	int		return_status;
+	unsigned long	wait_reset;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+
+	wait_reset = jiffies + (MAX_LOOP_TIMEOUT * HZ);
+	while (((test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) ||
+	    test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
+	    ha->dpc_active) && time_before(jiffies, wait_reset)) {
+
+		msleep(1000);
+
+		if (!test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags) &&
+		    ha->flags.chip_reset_done)
+			break;
+	}
+	if (ha->flags.chip_reset_done)
+		return_status = QLA_SUCCESS;
+	else
+		return_status = QLA_FUNCTION_FAILED;
+
+	return return_status;
+}
+
 /*
  * qla2x00_wait_for_loop_ready
  *    Wait for MAX_LOOP_TIMEOUT(5 min) value for loop
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index ff5aa75..09f893d 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -1949,7 +1949,7 @@ qla2x00_resume_hba(struct scsi_qla_host *vha)
 	clear_bit(MBX_UPDATE_FLASH_ACTIVE, &ha->mbx_cmd_flags);
 	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 	qla2xxx_wake_dpc(vha);
-	qla2x00_wait_for_hba_online(vha);
+	qla2x00_wait_for_chip_reset(vha);
 	scsi_unblock_requests(vha->host);
 }
 
-- 
1.6.2.rc0.55.g30aa4f

