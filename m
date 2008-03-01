From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] Convert qla2xxx, mpt, arm, sym, a100u2w, qla1280 to target reset handler
Date: Fri, 29 Feb 2008 18:25:21 -0600
Message-ID: <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
 <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu>
 <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYCAAZg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 19:25:36 -0500
In-Reply-To: <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts the drivers that just needed a rename from
"deivce" to "target" to use the target reset handler. This includes
qla2xxx, mpt, arm/*, sym53c8xx_2, a100u2w and qla1280.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/message/fusion/mptfc.c      |    8 +++---
 drivers/message/fusion/mptsas.c     |    8 +++---
 drivers/message/fusion/mptscsih.c   |    8 +++---
 drivers/message/fusion/mptscsih.h   |    2 +-
 drivers/message/fusion/mptspi.c     |    2 +-
 drivers/scsi/a100u2w.c              |   12 +++++-----
 drivers/scsi/arm/arxescsi.c         |    2 +-
 drivers/scsi/arm/cumana_2.c         |    2 +-
 drivers/scsi/arm/eesox.c            |    2 +-
 drivers/scsi/arm/fas216.c           |    6 ++--
 drivers/scsi/arm/fas216.h           |    4 +-
 drivers/scsi/arm/powertec.c         |    2 +-
 drivers/scsi/qla1280.c              |   30 ++++++++++++------------
 drivers/scsi/qla2xxx/qla_os.c       |   42 +++++++++++++++++-----------------
 drivers/scsi/sym53c8xx_2/sym_glue.c |   10 ++++----
 15 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 3cdd4e9..53ed72b 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -102,7 +102,7 @@ static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
 static void __devexit mptfc_remove(struct pci_dev *pdev);
 static int mptfc_abort(struct scsi_cmnd *SCpnt);
-static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
+static int mptfc_target_reset(struct scsi_cmnd *SCpnt);
 static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
 static int mptfc_host_reset(struct scsi_cmnd *SCpnt);
 
@@ -120,7 +120,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptfc_abort,
-	.eh_device_reset_handler	= mptfc_dev_reset,
+	.eh_target_reset_handler	= mptfc_target_reset,
 	.eh_bus_reset_handler		= mptfc_bus_reset,
 	.eh_host_reset_handler		= mptfc_host_reset,
 	.bios_param			= mptscsih_bios_param,
@@ -235,10 +235,10 @@ mptfc_abort(struct scsi_cmnd *SCpnt)
 }
 
 static int
-mptfc_dev_reset(struct scsi_cmnd *SCpnt)
+mptfc_target_reset(struct scsi_cmnd *SCpnt)
 {
 	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_dev_reset, __FUNCTION__);
+	    mptfc_block_error_handler(SCpnt, mptscsih_target_reset, __FUNCTION__);
 }
 
 static int
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index f77b329..55563a2 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -610,7 +610,7 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
 }
 
 /**
- * mptsas_dev_reset_complete
+ * mptsas_target_reset_complete
  *
  * Completion for TARGET_RESET after NOT_RESPONDING_EVENT,
  * enable work queue to finish off removing device from upper layers.
@@ -620,7 +620,7 @@ mptsas_target_reset_queue(MPT_ADAPTER *ioc,
  *
  **/
 static void
-mptsas_dev_reset_complete(MPT_ADAPTER *ioc)
+mptsas_target_reset_complete(MPT_ADAPTER *ioc)
 {
 	MPT_SCSI_HOST	*hd = shost_priv(ioc->sh);
         struct list_head *head = &hd->target_reset_list;
@@ -711,7 +711,7 @@ mptsas_dev_reset_complete(MPT_ADAPTER *ioc)
 static int
 mptsas_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *mr)
 {
-	mptsas_dev_reset_complete(ioc);
+	mptsas_target_reset_complete(ioc);
 	return mptscsih_taskmgmt_complete(ioc, mf, mr);
 }
 
@@ -1022,7 +1022,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.slave_destroy			= mptscsih_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_target_reset_handler	= mptscsih_target_reset,
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index af1de0c..bc19593 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1870,15 +1870,15 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_dev_reset - Perform a SCSI TARGET_RESET!  new_eh variant
+ *	mptscsih_target_reset - Perform a SCSI TARGET_RESET!  new_eh variant
  *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
  *
- *	(linux scsi_host_template.eh_dev_reset_handler routine)
+ *	(linux scsi_host_template.eh_target_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  **/
 int
-mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
+mptscsih_target_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
@@ -3489,7 +3489,7 @@ EXPORT_SYMBOL(mptscsih_qcmd);
 EXPORT_SYMBOL(mptscsih_slave_destroy);
 EXPORT_SYMBOL(mptscsih_slave_configure);
 EXPORT_SYMBOL(mptscsih_abort);
-EXPORT_SYMBOL(mptscsih_dev_reset);
+EXPORT_SYMBOL(mptscsih_target_reset);
 EXPORT_SYMBOL(mptscsih_bus_reset);
 EXPORT_SYMBOL(mptscsih_host_reset);
 EXPORT_SYMBOL(mptscsih_bios_param);
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index d289e97..881efa7 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -115,7 +115,7 @@ extern int mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
-extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
+extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 25bcfcf..0e96a69 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -821,7 +821,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.slave_destroy			= mptspi_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_target_reset_handler	= mptscsih_target_reset,
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index f608d4a..82ae198 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -583,7 +583,7 @@ static int orc_reset_scsi_bus(struct orc_host * host)
 }
 
 /**
- *	orc_device_reset	-	device reset handler
+ *	orc_target_reset	-	target reset handler
  *	@host: host to reset
  *	@cmd: command causing the reset
  *	@target; target device
@@ -592,7 +592,7 @@ static int orc_reset_scsi_bus(struct orc_host * host)
  *	commands for target w/o soft reset
  */
 
-static int orc_device_reset(struct orc_host * host, struct scsi_cmnd *cmd, unsigned int target)
+static int orc_target_reset(struct orc_host * host, struct scsi_cmnd *cmd, unsigned int target)
 {				/* I need Host Control Block Information */
 	struct orc_scb *scb;
 	struct orc_extended_scb *escb;
@@ -955,17 +955,17 @@ static int inia100_bus_reset(struct scsi_cmnd * cmd)
 }
 
 /*****************************************************************************
- Function name  : inia100_device_reset
+ Function name  : inia100_target_reset
  Description    : Reset the device
  Input          : host  -       Pointer to host adapter structure
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_device_reset(struct scsi_cmnd * cmd)
+static int inia100_target_reset(struct scsi_cmnd * cmd)
 {				/* I need Host Control Block Information */
 	struct orc_host *host;
 	host = (struct orc_host *) cmd->device->host->hostdata;
-	return orc_device_reset(host, cmd, scmd_id(cmd));
+	return orc_target_reset(host, cmd, scmd_id(cmd));
 
 }
 
@@ -1065,7 +1065,7 @@ static struct scsi_host_template inia100_template = {
 	.queuecommand		= inia100_queue,
 	.eh_abort_handler	= inia100_abort,
 	.eh_bus_reset_handler	= inia100_bus_reset,
-	.eh_device_reset_handler = inia100_device_reset,
+	.eh_target_reset_handler = inia100_target_reset,
 	.can_queue		= 1,
 	.this_id		= 1,
 	.sg_tablesize		= SG_ALL,
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 2836fe2..d0315b9 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -266,7 +266,7 @@ static struct scsi_host_template arxescsi_template = {
 	.queuecommand			= fas216_noqueue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
-	.eh_device_reset_handler	= fas216_eh_device_reset,
+	.eh_target_reset_handler	= fas216_eh_target_reset,
 	.eh_abort_handler		= fas216_eh_abort,
 	.can_queue			= 0,
 	.this_id			= 7,
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 68a6412..6322fe5 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -386,7 +386,7 @@ static struct scsi_host_template cumanascsi2_template = {
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
-	.eh_device_reset_handler	= fas216_eh_device_reset,
+	.eh_target_reset_handler	= fas216_eh_target_reset,
 	.eh_abort_handler		= fas216_eh_abort,
 	.can_queue			= 1,
 	.this_id			= 7,
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index bb2477b..f6f4a27 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -504,7 +504,7 @@ static struct scsi_host_template eesox_template = {
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
-	.eh_device_reset_handler	= fas216_eh_device_reset,
+	.eh_target_reset_handler	= fas216_eh_target_reset,
 	.eh_abort_handler		= fas216_eh_abort,
 	.can_queue			= 1,
 	.this_id			= 7,
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index a715632..a9e666d 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2460,7 +2460,7 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 }
 
 /**
- * fas216_eh_device_reset - Reset the device associated with this command
+ * fas216_eh_target_reset - Reset the device associated with this command
  * @SCpnt: command specifing device to reset
  *
  * Reset the device associated with this command.
@@ -2468,7 +2468,7 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
  * Notes: We won't be re-entered, so we'll only have one device
  * reset on the go at one time.
  */
-int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
+int fas216_eh_target_reset(struct scsi_cmnd *SCpnt)
 {
 	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
 	unsigned long flags;
@@ -3029,7 +3029,7 @@ EXPORT_SYMBOL(fas216_intr);
 EXPORT_SYMBOL(fas216_remove);
 EXPORT_SYMBOL(fas216_release);
 EXPORT_SYMBOL(fas216_eh_abort);
-EXPORT_SYMBOL(fas216_eh_device_reset);
+EXPORT_SYMBOL(fas216_eh_target_reset);
 EXPORT_SYMBOL(fas216_eh_bus_reset);
 EXPORT_SYMBOL(fas216_eh_host_reset);
 EXPORT_SYMBOL(fas216_print_host);
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index b65f4cf..7675d3b 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -375,12 +375,12 @@ extern int fas216_print_devices(FAS216_Info *info, char *buffer);
  */
 extern int fas216_eh_abort(struct scsi_cmnd *SCpnt);
 
-/* Function: int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
+/* Function: int fas216_eh_target_reset(struct scsi_cmnd *SCpnt)
  * Purpose : Reset the device associated with this command
  * Params  : SCpnt - command specifing device to reset
  * Returns : FAILED if unable to reset
  */
-extern int fas216_eh_device_reset(struct scsi_cmnd *SCpnt);
+extern int fas216_eh_target_reset(struct scsi_cmnd *SCpnt);
 
 /* Function: int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt)
  * Purpose : Reset the complete bus associated with this command
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index d9a546d..4577c74 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -297,7 +297,7 @@ static struct scsi_host_template powertecscsi_template = {
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
 	.eh_bus_reset_handler		= fas216_eh_bus_reset,
-	.eh_device_reset_handler	= fas216_eh_device_reset,
+	.eh_target_reset_handler	= fas216_eh_target_reset,
 	.eh_abort_handler		= fas216_eh_abort,
 
 	.can_queue			= 8,
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 68c0d09..d61d70a 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -442,7 +442,7 @@ static int qla1280_nvram_config(struct scsi_qla_host *);
 static int qla1280_mailbox_command(struct scsi_qla_host *,
 				   uint8_t, uint16_t *);
 static int qla1280_bus_reset(struct scsi_qla_host *, int);
-static int qla1280_device_reset(struct scsi_qla_host *, int, int);
+static int qla1280_target_reset(struct scsi_qla_host *, int, int);
 static int qla1280_abort_device(struct scsi_qla_host *, int, int, int);
 static int qla1280_abort_command(struct scsi_qla_host *, struct srb *, int);
 static int qla1280_abort_isp(struct scsi_qla_host *);
@@ -756,7 +756,7 @@ qla1280_queuecommand(struct scsi_cmnd *cmd, void (*fn)(struct scsi_cmnd *))
 enum action {
 	ABORT_COMMAND,
 	ABORT_DEVICE,
-	DEVICE_RESET,
+	TGT_RESET,
 	BUS_RESET,
 	ADAPTER_RESET,
 	FAIL
@@ -919,12 +919,12 @@ qla1280_error_action(struct scsi_cmnd *cmd, enum action action)
 			result = SUCCESS;
 		break;
 
-	case DEVICE_RESET:
+	case TGT_RESET:
 		if (qla1280_verbose)
 			printk(KERN_INFO
-			       "scsi(%ld:%d:%d:%d): Queueing device reset "
+			       "scsi(%ld:%d:%d:%d): Queueing target reset "
 			       "command.\n", ha->host_no, bus, target, lun);
-		if (qla1280_device_reset(ha, bus, target) == 0)
+		if (qla1280_target_reset(ha, bus, target) == 0)
 			result = SUCCESS;
 		break;
 
@@ -1018,16 +1018,16 @@ qla1280_eh_abort(struct scsi_cmnd * cmd)
 }
 
 /**************************************************************************
- *   qla1280_device_reset
- *     Reset the specified SCSI device
+ *   qla1280_target_reset
+ *     Reset the specified SCSI target
  **************************************************************************/
 static int
-qla1280_eh_device_reset(struct scsi_cmnd *cmd)
+qla1280_eh_target_reset(struct scsi_cmnd *cmd)
 {
 	int rc;
 
 	spin_lock_irq(cmd->device->host->host_lock);
-	rc = qla1280_error_action(cmd, DEVICE_RESET);
+	rc = qla1280_error_action(cmd, TGT_RESET);
 	spin_unlock_irq(cmd->device->host->host_lock);
 
 	return rc;
@@ -2580,7 +2580,7 @@ qla1280_bus_reset(struct scsi_qla_host *ha, int bus)
 }
 
 /*
- * qla1280_device_reset
+ * qla1280_target_reset
  *      Issue bus device reset message to the target.
  *
  * Input:
@@ -2592,12 +2592,12 @@ qla1280_bus_reset(struct scsi_qla_host *ha, int bus)
  *      0 = success
  */
 static int
-qla1280_device_reset(struct scsi_qla_host *ha, int bus, int target)
+qla1280_target_reset(struct scsi_qla_host *ha, int bus, int target)
 {
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	int status;
 
-	ENTER("qla1280_device_reset");
+	ENTER("qla1280_target_reset");
 
 	mb[0] = MBC_ABORT_TARGET;
 	mb[1] = (bus ? (target | BIT_7) : target) << 8;
@@ -2608,9 +2608,9 @@ qla1280_device_reset(struct scsi_qla_host *ha, int bus, int target)
 	qla1280_marker(ha, bus, target, 0, MK_SYNC_ID);
 
 	if (status)
-		dprintk(2, "qla1280_device_reset: **** FAILED ****\n");
+		dprintk(2, "qla1280_target_reset: **** FAILED ****\n");
 
-	LEAVE("qla1280_device_reset");
+	LEAVE("qla1280_target_reset");
 	return status;
 }
 
@@ -4195,7 +4195,7 @@ static struct scsi_host_template qla1280_driver_template = {
 	.slave_configure	= qla1280_slave_configure,
 	.queuecommand		= qla1280_queuecommand,
 	.eh_abort_handler	= qla1280_eh_abort,
-	.eh_device_reset_handler= qla1280_eh_device_reset,
+	.eh_target_reset_handler= qla1280_eh_target_reset,
 	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
 	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
 	.bios_param		= qla1280_biosparam,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3c1b433..41e8d3e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -102,10 +102,10 @@ static int qla2x00_queuecommand(struct scsi_cmnd *cmd,
 static int qla24xx_queuecommand(struct scsi_cmnd *cmd,
 		void (*fn)(struct scsi_cmnd *));
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
-static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
+static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
-static int qla2x00_device_reset(scsi_qla_host_t *, fc_port_t *);
+static int qla2x00_target_reset(scsi_qla_host_t *, fc_port_t *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
@@ -116,7 +116,7 @@ static struct scsi_host_template qla2x00_driver_template = {
 	.queuecommand		= qla2x00_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
-	.eh_device_reset_handler = qla2xxx_eh_device_reset,
+	.eh_target_reset_handler = qla2xxx_eh_target_reset,
 	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
@@ -147,7 +147,7 @@ struct scsi_host_template qla24xx_driver_template = {
 	.queuecommand		= qla24xx_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
-	.eh_device_reset_handler = qla2xxx_eh_device_reset,
+	.eh_target_reset_handler = qla2xxx_eh_target_reset,
 	.eh_bus_reset_handler	= qla2xxx_eh_bus_reset,
 	.eh_host_reset_handler	= qla2xxx_eh_host_reset,
 
@@ -771,10 +771,10 @@ qla2x00_eh_wait_for_pending_target_commands(scsi_qla_host_t *ha, unsigned int t)
 
 
 /**************************************************************************
-* qla2xxx_eh_device_reset
+* qla2xxx_eh_target_reset
 *
 * Description:
-*    The device reset function will reset the target and abort any
+*    The target reset function will reset the target and abort any
 *    executing commands.
 *
 *    NOTE: The use of SP is undefined within this context.  Do *NOT*
@@ -790,31 +790,30 @@ qla2x00_eh_wait_for_pending_target_commands(scsi_qla_host_t *ha, unsigned int t)
 *
 **************************************************************************/
 static int
-qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *ha = shost_priv(cmd->device->host);
 	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
 	int ret = FAILED;
-	unsigned int id, lun;
+	unsigned int id;
 	unsigned long serial;
 
 	qla2x00_block_error_handler(cmd);
 
 	id = cmd->device->id;
-	lun = cmd->device->lun;
 	serial = cmd->serial_number;
 
 	if (!fcport)
 		return ret;
 
 	qla_printk(KERN_INFO, ha,
-	    "scsi(%ld:%d:%d): DEVICE RESET ISSUED.\n", ha->host_no, id, lun);
+	    "scsi(%ld:%d): TARGET RESET ISSUED.\n", ha->host_no, id);
 
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
-		goto eh_dev_reset_done;
+		goto eh_tgt_reset_done;
 
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
-		if (qla2x00_device_reset(ha, fcport) == 0)
+		if (qla2x00_target_reset(ha, fcport) == 0)
 			ret = SUCCESS;
 
 #if defined(LOGOUT_AFTER_DEVICE_RESET)
@@ -831,12 +830,12 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	}
 
 	if (ret == FAILED) {
-		DEBUG3(printk("%s(%ld): device reset failed\n",
+		DEBUG3(printk("%s(%ld): target reset failed\n",
 		    __func__, ha->host_no));
-		qla_printk(KERN_INFO, ha, "%s: device reset failed\n",
+		qla_printk(KERN_INFO, ha, "%s: target reset failed\n",
 		    __func__);
 
-		goto eh_dev_reset_done;
+		goto eh_tgt_reset_done;
 	}
 
 	/* Flush outstanding commands. */
@@ -849,9 +848,10 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		    "%s: failed while waiting for commands\n", __func__);
 	} else
 		qla_printk(KERN_INFO, ha,
-		    "scsi(%ld:%d:%d): DEVICE RESET SUCCEEDED.\n", ha->host_no,
-		    id, lun);
- eh_dev_reset_done:
+		    "scsi(%ld:%d): TARGET RESET SUCCEEDED.\n", ha->host_no,
+		    id);
+
+ eh_tgt_reset_done:
 	return ret;
 }
 
@@ -1080,7 +1080,7 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 			if (fcport->port_type != FCT_TARGET)
 				continue;
 
-			ret = qla2x00_device_reset(ha, fcport);
+			ret = qla2x00_target_reset(ha, fcport);
 			if (ret != QLA_SUCCESS) {
 				DEBUG2_3(printk("%s(%ld): bus_reset failed: "
 				    "target_reset=%d d_id=%x.\n", __func__,
@@ -1096,7 +1096,7 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
 }
 
 /*
- * qla2x00_device_reset
+ * qla2x00_target_reset
  *	Issue bus device reset message to the target.
  *
  * Input:
@@ -1109,7 +1109,7 @@ qla2x00_loop_reset(scsi_qla_host_t *ha)
  *	Kernel context.
  */
 static int
-qla2x00_device_reset(scsi_qla_host_t *ha, fc_port_t *reset_fcport)
+qla2x00_target_reset(scsi_qla_host_t *ha, fc_port_t *reset_fcport)
 {
 	/* Abort Target command will clear Reservation */
 	return ha->isp_ops->abort_target(reset_fcport);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index d39107b..6cd61c1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -578,7 +578,7 @@ static void sym53c8xx_timer(unsigned long npref)
  *  What the eh thread wants us to perform.
  */
 #define SYM_EH_ABORT		0
-#define SYM_EH_DEVICE_RESET	1
+#define SYM_EH_TARGET_RESET	1
 #define SYM_EH_BUS_RESET	2
 #define SYM_EH_HOST_RESET	3
 
@@ -646,7 +646,7 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	case SYM_EH_ABORT:
 		sts = sym_abort_scsiio(np, cmd, 1);
 		break;
-	case SYM_EH_DEVICE_RESET:
+	case SYM_EH_TARGET_RESET:
 		sts = sym_reset_scsi_target(np, cmd->device->id);
 		break;
 	case SYM_EH_BUS_RESET:
@@ -692,9 +692,9 @@ static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
 }
 
-static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_target_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
+	return sym_eh_handler(SYM_EH_TARGET_RESET, "TARGET RESET", cmd);
 }
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
@@ -1676,7 +1676,7 @@ static struct scsi_host_template sym2_template = {
 	.slave_configure	= sym53c8xx_slave_configure,
 	.slave_destroy		= sym53c8xx_slave_destroy,
 	.eh_abort_handler	= sym53c8xx_eh_abort_handler,
-	.eh_device_reset_handler = sym53c8xx_eh_device_reset_handler,
+	.eh_target_reset_handler = sym53c8xx_eh_target_reset_handler,
 	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
 	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
 	.this_id		= 7,
-- 
1.5.4.1

