From: giridhar.malavali@qlogic.com
Subject: [PATCH 12/16] qla2xxx: ensure flash operation and host reset via sg_reset are mutually exclusive
Date: Tue,  4 May 2010 15:01:32 -0700
Message-ID: <1273010496-43045-13-git-send-email-giridhar.malavali@qlogic.com>
References: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47176 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1760236Ab0EDWBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:41 -0400
In-Reply-To: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

The problem occurring is a hw-race where there's an outstanding read-flash
operation occurring while the chip is being reset (done via an sg_reset script).
After the chip is paused, the read-flash operation never completes and the
DPC thread, while trying to complete the reset, is never able to recover,
as the HW appears to be hung...

The fix is to wait for outstanding flash operation prior to doing a sg_reset -h.
And to wait for reset to complete before any flash operations.

Note, during the wait, if any of the operation (reset/flash) does not complete,
failure is returned to the upper layer. The upper layer either need to
fail or retry.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |    6 +++++
 drivers/scsi/qla2xxx/qla_os.c   |   46 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 62a22cf..3b70860 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -281,6 +281,12 @@ qla2x00_sysfs_write_optrom_ctl(struct kobject *kobj,
 			return count;
 		}
 
+		if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
+			qla_printk(KERN_WARNING, ha,
+				"HBA not online, failing NVRAM update.\n");
+			return -EAGAIN;
+		}
+
 		DEBUG2(qla_printk(KERN_INFO, ha,
 		    "Reading flash region -- 0x%x/0x%x.\n",
 		    ha->optrom_region_start, ha->optrom_region_size));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5104aef..0de92d3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -676,6 +676,50 @@ qla2x00_wait_for_hba_online(scsi_qla_host_t *vha)
 	return (return_status);
 }
 
+/*
+ * qla2x00_wait_for_reset_ready
+ *    Wait till the HBA is online after going through
+ *    <= MAX_RETRIES_OF_ISP_ABORT  or
+ *    finally HBA is disabled ie marked offline or flash
+ *    operations are in progress.
+ *
+ * Input:
+ *     ha - pointer to host adapter structure
+ *
+ * Note:
+ *    Does context switching-Release SPIN_LOCK
+ *    (if any) before calling this routine.
+ *
+ * Return:
+ *    Success (Adapter is online/no flash ops) : 0
+ *    Failed  (Adapter is offline/disabled/flash ops in progress) : 1
+ */
+int
+qla2x00_wait_for_reset_ready(scsi_qla_host_t *vha)
+{
+	int		return_status;
+	unsigned long	wait_online;
+	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
+
+	wait_online = jiffies + (MAX_LOOP_TIMEOUT * HZ);
+	while (((test_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags)) ||
+	    test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags) ||
+	    test_bit(ISP_ABORT_RETRY, &base_vha->dpc_flags) ||
+	    ha->optrom_state != QLA_SWAITING ||
+	    ha->dpc_active) && time_before(jiffies, wait_online))
+		msleep(1000);
+
+	if (base_vha->flags.online &&  ha->optrom_state == QLA_SWAITING)
+		return_status = QLA_SUCCESS;
+	else
+		return_status = QLA_FUNCTION_FAILED;
+
+	DEBUG2(printk("%s return_status=%d\n", __func__, return_status));
+
+	return return_status;
+}
+
 int
 qla2x00_wait_for_chip_reset(scsi_qla_host_t *vha)
 {
@@ -1081,7 +1125,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", vha->host_no, id, lun);
 
-	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS)
+	if (qla2x00_wait_for_reset_ready(vha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;
 
 	/*
-- 
1.6.2.rc1.30.gd43c

