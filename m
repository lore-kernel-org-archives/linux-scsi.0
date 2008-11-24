From: Michael Reed <mdr@sgi.com>
Subject: [PATCH] qla2xxx: Conditionally disable automatic queue full tracking
Date: Mon, 24 Nov 2008 14:16:20 -0600
Message-ID: <492B0B94.3080409@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.171.31]:37013 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751597AbYKXU1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2008 15:27:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Jeremy Higdon <jeremy@sgi.com>, Hannes Reinecke <hare@suse.de>

Changing a lun's queue depth (/sys/block/sdX/device/queue_depth) isn't
sticky when the device is connected via a QLogic fibre channel adapter.

The QLogic qla2xxx fibre channel driver dynamically adjusts a lun's queue
depth.  If a user has a specific need to limit the number of commands issued
to a lun (say a tape drive, or a shared raid where the total commands issued
to all luns is limited at the controller level, for example) and writes a
limiting value to /sys/block/sdXX/device/queue_depth, the qla2xxx driver will
silently and gradually increase the queue depth back to the driver limit
of ql2xmaxqdepth.  While reducing this value (module parameter) or increasing
the interval between ramp ups (ql2xqfullrampup) offers the potential for a
work around it would be better to have the option of just disabling the
dynamic adjustment of queue depth.

This patch implements an "off switch" as a module parameter.  Applies to
2.6.28-rc6-git1.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- a/drivers/scsi/qla2xxx/qla_gbl.h	2008-11-11 08:57:26.000000000 -0600
+++ b/drivers/scsi/qla2xxx/qla_gbl.h	2008-11-24 10:11:48.948835394 -0600
@@ -62,6 +62,7 @@ extern int ql2xfdmienable;
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xqfullrampup;
+extern int ql2xqfulltracking;
 extern int ql2xiidmaenable;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
--- a/drivers/scsi/qla2xxx/qla_isr.c	2008-11-11 08:57:26.000000000 -0600
+++ b/drivers/scsi/qla2xxx/qla_isr.c	2008-11-21 17:23:46.065443427 -0600
@@ -691,6 +691,9 @@ qla2x00_adjust_sdev_qdepth_up(struct scs
 {
 	fc_port_t *fcport = data;
 
+	if (!ql2xqfulltracking)
+		return;
+
 	if (fcport->ha->max_q_depth <= sdev->queue_depth)
 		return;
 
@@ -729,6 +732,9 @@ qla2x00_ramp_up_queue_depth(scsi_qla_hos
 	fc_port_t *fcport;
 	struct scsi_device *sdev;
 
+	if (!ql2xqfulltracking)
+		return;
+
 	sdev = sp->cmd->device;
 	if (sdev->queue_depth >= ha->max_q_depth)
 		return;
@@ -1043,6 +1049,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 			    scsi_status));
 
 			/* Adjust queue depth for all luns on the port. */
+			if (!ql2xqfulltracking)
+				break;
 			fcport->last_queue_full = jiffies;
 			starget_for_each_device(cp->device->sdev_target,
 			    fcport, qla2x00_adjust_sdev_qdepth_down);
@@ -1102,6 +1110,8 @@ qla2x00_status_entry(scsi_qla_host_t *ha
 				 * Adjust queue depth for all luns on the
 				 * port.
 				 */
+				if (!ql2xqfulltracking)
+					break;
 				fcport->last_queue_full = jiffies;
 				starget_for_each_device(
 				    cp->device->sdev_target, fcport,
--- a/drivers/scsi/qla2xxx/qla_os.c	2008-11-11 08:57:26.000000000 -0600
+++ b/drivers/scsi/qla2xxx/qla_os.c	2008-11-21 17:23:46.093443556 -0600
@@ -79,6 +79,14 @@ module_param(ql2xmaxqdepth, int, S_IRUGO
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
