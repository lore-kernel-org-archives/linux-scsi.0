From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 11/15] qla2xxx: Conditionally disable automatic queue full tracking.
Date: Mon,  6 Apr 2009 22:33:47 -0700
Message-ID: <1239082431-19496-12-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZDGFeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:34:09 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Michael Reed <mdr@sgi.com>

From: Michael Reed <mdr@sgi.com>

Changing a lun's queue depth (/sys/block/sdX/device/queue_depth)
isn't sticky when the device is connected via a QLogic fibre
channel adapter.

The QLogic qla2xxx fibre channel driver dynamically adjusts a
lun's queue depth.  If a user has a specific need to limit the
number of commands issued to a lun (say a tape drive, or a shared
raid where the total commands issued to all luns is limited at
the controller level, for example) and writes a limiting value to
/sys/block/sdXX/device/queue_depth, the qla2xxx driver will
silently and gradually increase the queue depth back to the
driver limit of ql2xmaxqdepth.  While reducing this value (module
parameter) or increasing the interval between ramp ups
(ql2xqfullrampup) offers the potential for a work around it would
be better to have the option of just disabling the dynamic
adjustment of queue depth.

This patch implements an "off switch" as a module parameter.

Signed-off-by: Michael Reed <mdr@sgi.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 +
 drivers/scsi/qla2xxx/qla_isr.c |   10 ++++++++++
 drivers/scsi/qla2xxx/qla_os.c  |    8 ++++++++
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index b12de01..5347e35 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -65,6 +65,7 @@ extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
+extern int ql2xqfulltracking;
 extern int ql2xiidmaenable;
 extern int ql2xmaxqueues;
 extern int ql2xmultique_tag;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 41e50c2..eb35d20 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -765,6 +765,9 @@ qla2x00_adjust_sdev_qdepth_up(struct scsi_device *sdev, void *data)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = NULL;
 
+	if (!ql2xqfulltracking)
+		return;
+
 	req = vha->req;
 	if (!req)
 		return;
@@ -807,6 +810,9 @@ qla2x00_ramp_up_queue_depth(scsi_qla_host_t *vha, struct req_que *req,
 	fc_port_t *fcport;
 	struct scsi_device *sdev;
 
+	if (!ql2xqfulltracking)
+		return;
+
 	sdev = sp->cmd->device;
 	if (sdev->queue_depth >= req->max_q_depth)
 		return;
@@ -1125,6 +1131,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 			    scsi_status));
 
 			/* Adjust queue depth for all luns on the port. */
+			if (!ql2xqfulltracking)
+				break;
 			fcport->last_queue_full = jiffies;
 			starget_for_each_device(cp->device->sdev_target,
 			    fcport, qla2x00_adjust_sdev_qdepth_down);
@@ -1183,6 +1191,8 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				 * Adjust queue depth for all luns on the
 				 * port.
 				 */
+				if (!ql2xqfulltracking)
+					break;
 				fcport->last_queue_full = jiffies;
 				starget_for_each_device(
 				    cp->device->sdev_target, fcport,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 540d731..6ffd518 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -77,6 +77,14 @@ module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to report for target devices.");
 
+int ql2xqfulltracking = 1;
+module_param(ql2xqfulltracking, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2xqfulltracking,
+		"Controls whether the driver tracks queue full status "
+		"returns and dynamically adjusts a scsi device's queue "
+		"depth.  Default is 1, perform tracking.  Set to 0 to "
+		"disable dynamic tracking and adjustment of queue depth.");
+
 int ql2xqfullrampup = 120;
 module_param(ql2xqfullrampup, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xqfullrampup,
-- 
1.6.2.2.404.ge96f3

