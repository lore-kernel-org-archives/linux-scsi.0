From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/4] qla2xxx: Correct QUEUE_FULL handling.
Date: Fri, 13 Oct 2006 09:33:39 -0700
Message-ID: <11607572202461-git-send-email-andrew.vasquez@qlogic.com>
References: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:56288 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751729AbWJMQd4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Oct 2006 12:33:56 -0400
In-Reply-To: <20061013163251.GG2132@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

- Drop queue-depths across all luns for a given fcport
  during TASK_SET_FULL statuses.
- Ramp-up I/Os after throttling.
- Consolidate completion-status handling of CS_QUEUE_FULL with
  CS_COMPLETE as ISP24xx firmware no longer reports
  CS_QUEUE_FULL.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    4 ++
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |   91 +++++++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_os.c  |   21 ++++++++-
 4 files changed, 104 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bab33f6..c4fc40f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1545,6 +1545,9 @@ typedef struct fc_port {
 	spinlock_t rport_lock;
 	struct fc_rport *rport, *drport;
 	u32 supported_classes;
+
+	unsigned long last_queue_full;
+	unsigned long last_ramp_up;
 } fc_port_t;
 
 /*
@@ -2255,6 +2258,7 @@ #define P2P_LOOP  3
 	uint16_t	mgmt_svr_loop_id;
 
         uint32_t	login_retry_count;
+	int		max_q_depth;
 
 	/* Fibre Channel Device List. */
 	struct list_head	fcports;
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ca2f660..32ebeec 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -62,6 +62,7 @@ extern int ql2xloginretrycount;
 extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
+extern int ql2xqfullrampup;
 
 extern void qla2x00_sp_compl(scsi_qla_host_t *, srb_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 626c717..d3b6df4 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -6,6 +6,8 @@
  */
 #include "qla_def.h"
 
+#include <scsi/scsi_tcq.h>
+
 static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
 static void qla2x00_async_event(scsi_qla_host_t *, uint16_t *);
 static void qla2x00_process_completed_request(struct scsi_qla_host *, uint32_t);
@@ -593,6 +595,67 @@ #define LS_UNKNOWN	2
 	}
 }
 
+static void
+qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
+{
+	fc_port_t *fcport = data;
+
+	if (fcport->ha->max_q_depth <= sdev->queue_depth)
+		return;
+
+	if (sdev->ordered_tags)
+		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG,
+		    sdev->queue_depth + 1);
+	else
+		scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG,
+		    sdev->queue_depth + 1);
+
+	fcport->last_ramp_up = jiffies;
+
+	DEBUG2(qla_printk(KERN_INFO, fcport->ha,
+	    "scsi(%ld:%d:%d:%d): Queue depth adjusted-up to %d.\n",
+	    fcport->ha->host_no, sdev->channel, sdev->id, sdev->lun,
+	    sdev->queue_depth));
+}
+
+static void
+qla2x00_adjust_sdev_qdepth_down(struct scsi_device *sdev, void *data)
+{
+	fc_port_t *fcport = data;
+
+	if (!scsi_track_queue_full(sdev, sdev->queue_depth - 1))
+		return;
+
+	DEBUG2(qla_printk(KERN_INFO, fcport->ha,
+	    "scsi(%ld:%d:%d:%d): Queue depth adjusted-down to %d.\n",
+	    fcport->ha->host_no, sdev->channel, sdev->id, sdev->lun,
+	    sdev->queue_depth));
+}
+
+static inline void
+qla2x00_ramp_up_queue_depth(scsi_qla_host_t *ha, srb_t *sp)
+{
+	fc_port_t *fcport;
+	struct scsi_device *sdev;
+
+	sdev = sp->cmd->device;
+	if (sdev->queue_depth >= ha->max_q_depth)
+		return;
+
+	fcport = sp->fcport;
+	if (time_before(jiffies,
+	    fcport->last_ramp_up + ql2xqfullrampup * HZ))
+		return;
+	if (time_before(jiffies,
+	    fcport->last_queue_full + ql2xqfullrampup * HZ))
+		return;
+
+	spin_unlock_irq(&ha->hardware_lock);
+	starget_for_each_device(sdev->sdev_target, fcport,
+	    qla2x00_adjust_sdev_qdepth_up);
+	spin_lock_irq(&ha->hardware_lock);
+}
+
 /**
  * qla2x00_process_completed_request() - Process a Fast Post response.
  * @ha: SCSI driver HA context
@@ -624,6 +687,8 @@ qla2x00_process_completed_request(struct
 
 		/* Save ISP completion status */
 		sp->cmd->result = DID_OK << 16;
+
+		qla2x00_ramp_up_queue_depth(ha, sp);
 		qla2x00_sp_compl(ha, sp);
 	} else {
 		DEBUG2(printk("scsi(%ld): Invalid ISP SCSI completion handle\n",
@@ -823,6 +888,7 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 	 */
 	switch (comp_status) {
 	case CS_COMPLETE:
+	case CS_QUEUE_FULL:
 		if (scsi_status == 0) {
 			cp->result = DID_OK << 16;
 			break;
@@ -849,6 +915,20 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 		}
 		cp->result = DID_OK << 16 | lscsi_status;
 
+		if (lscsi_status == SAM_STAT_TASK_SET_FULL) {
+			DEBUG2(printk(KERN_INFO
+			    "scsi(%ld): QUEUE FULL status detected "
+			    "0x%x-0x%x.\n", ha->host_no, comp_status,
+			    scsi_status));
+
+			/* Adjust queue depth for all luns on the port. */
+			fcport->last_queue_full = jiffies;
+			spin_unlock_irq(&ha->hardware_lock);
+			starget_for_each_device(cp->device->sdev_target,
+			    fcport, qla2x00_adjust_sdev_qdepth_down);
+			spin_lock_irq(&ha->hardware_lock);
+			break;
+		}
 		if (lscsi_status != SS_CHECK_CONDITION)
 			break;
 
@@ -1066,17 +1146,6 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			qla2x00_mark_device_lost(ha, fcport, 1, 1);
 		break;
 
-	case CS_QUEUE_FULL:
-		DEBUG2(printk(KERN_INFO
-		    "scsi(%ld): QUEUE FULL status detected 0x%x-0x%x.\n",
-		    ha->host_no, comp_status, scsi_status));
-
-		/* SCSI Mid-Layer handles device queue full */
-
-		cp->result = DID_OK << 16 | lscsi_status;
-
-		break;
-
 	default:
 		DEBUG3(printk("scsi(%ld): Error detected (unknown status) "
 		    "0x%x-0x%x.\n", ha->host_no, comp_status, scsi_status));
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 54f561d..208607b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -77,6 +77,19 @@ MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registratons "
 		"Default is 0 - no FDMI. 1 - perfom FDMI.");
 
+#define MAX_Q_DEPTH    32
+static int ql2xmaxqdepth = MAX_Q_DEPTH;
+module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2xmaxqdepth,
+		"Maximum queue depth to report for target devices.");
+
+int ql2xqfullrampup = 120;
+module_param(ql2xqfullrampup, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2xqfullrampup,
+		"Number of seconds to wait to begin to ramp-up the queue "
+		"depth for a device after a queue-full condition has been "
+		"detected.  Default is 120 seconds.");
+
 /*
  * SCSI host template entry points
  */
@@ -1104,9 +1117,9 @@ qla2xxx_slave_configure(struct scsi_devi
 	struct fc_rport *rport = starget_to_rport(sdev->sdev_target);
 
 	if (sdev->tagged_supported)
-		scsi_activate_tcq(sdev, 32);
+		scsi_activate_tcq(sdev, ha->max_q_depth);
 	else
-		scsi_deactivate_tcq(sdev, 32);
+		scsi_deactivate_tcq(sdev, ha->max_q_depth);
 
 	rport->dev_loss_tmo = ha->port_down_retry_count + 5;
 
@@ -1413,6 +1426,10 @@ qla2x00_probe_one(struct pci_dev *pdev, 
 	ha->link_data_rate = PORT_SPEED_UNKNOWN;
 	ha->optrom_size = OPTROM_SIZE_2300;
 
+	ha->max_q_depth = MAX_Q_DEPTH;
+	if (ql2xmaxqdepth != 0 && ql2xmaxqdepth <= 0xffffU)
+		ha->max_q_depth = ql2xmaxqdepth;
+
 	/* Assign ISP specific operations. */
 	ha->isp_ops.pci_config		= qla2100_pci_config;
 	ha->isp_ops.reset_chip		= qla2x00_reset_chip;
-- 
1.4.3.rc2.g23bed

