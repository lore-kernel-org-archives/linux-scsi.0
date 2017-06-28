From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 46/47] scsi: Move eh_device_reset_handler() to use scsi_device as argument
Date: Wed, 28 Jun 2017 10:33:12 +0200
Message-ID: <1498638793-44672-47-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53831 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751538AbdF1Idp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:45 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When resetting a device we shouldn't depend on an existing SCSI
device, so use 'struct scsi_device' as argument for
eh_device_reset_handler().

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 Documentation/scsi/scsi_eh.txt                  |  2 +-
 Documentation/scsi/scsi_mid_low_api.txt         |  4 +--
 drivers/block/cciss_scsi.c                      | 14 +++++-----
 drivers/infiniband/ulp/srp/ib_srp.c             |  8 +++---
 drivers/message/fusion/mptfc.c                  | 12 ++++-----
 drivers/message/fusion/mptscsih.c               | 19 ++++++--------
 drivers/message/fusion/mptscsih.h               |  2 +-
 drivers/s390/scsi/zfcp_scsi.c                   |  4 +--
 drivers/scsi/a100u2w.c                          |  7 +++--
 drivers/scsi/aacraid/linit.c                    |  9 +++----
 drivers/scsi/aha152x.c                          |  6 ++---
 drivers/scsi/aha1542.c                          |  8 +++---
 drivers/scsi/aic7xxx/aic79xx_osm.c              | 27 ++++++++-----------
 drivers/scsi/aic7xxx/aic7xxx_osm.c              |  4 +--
 drivers/scsi/arm/fas216.c                       |  5 ++--
 drivers/scsi/be2iscsi/be_main.c                 |  8 +++---
 drivers/scsi/bfa/bfad_im.c                      |  3 +--
 drivers/scsi/bnx2fc/bnx2fc.h                    |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c                 |  6 ++---
 drivers/scsi/csiostor/csio_scsi.c               |  7 +++--
 drivers/scsi/cxlflash/main.c                    | 15 ++++-------
 drivers/scsi/dpt_i2o.c                          | 20 +++++++-------
 drivers/scsi/dpti.h                             |  2 +-
 drivers/scsi/esas2r/esas2r.h                    |  2 +-
 drivers/scsi/esas2r/esas2r_main.c               |  3 +--
 drivers/scsi/fnic/fnic.h                        |  2 +-
 drivers/scsi/fnic/fnic_scsi.c                   | 26 +++++++++---------
 drivers/scsi/hpsa.c                             | 14 +++++-----
 drivers/scsi/ibmvscsi/ibmvfc.c                  |  5 ++--
 drivers/scsi/ibmvscsi/ibmvscsi.c                | 19 +++++++-------
 drivers/scsi/ipr.c                              | 31 +++++++++++-----------
 drivers/scsi/libfc/fc_fcp.c                     |  8 +++---
 drivers/scsi/libiscsi.c                         | 15 +++++------
 drivers/scsi/libsas/sas_scsi_host.c             | 12 ++++-----
 drivers/scsi/lpfc/lpfc_scsi.c                   | 12 ++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            | 29 +++++++++-----------
 drivers/scsi/pmcraid.c                          |  6 ++---
 drivers/scsi/qedf/qedf_main.c                   |  6 ++---
 drivers/scsi/qla1280.c                          | 21 +++++++++++----
 drivers/scsi/qla2xxx/qla_os.c                   |  5 ++--
 drivers/scsi/qla4xxx/ql4_os.c                   | 28 +++++++++-----------
 drivers/scsi/scsi_debug.c                       | 18 ++++++-------
 drivers/scsi/scsi_error.c                       | 35 +++++++++++++++++--------
 drivers/scsi/smartpqi/smartpqi_init.c           |  6 ++---
 drivers/scsi/snic/snic.h                        |  2 +-
 drivers/scsi/snic/snic_scsi.c                   |  4 +--
 drivers/scsi/ufs/ufshcd.c                       | 16 +++++------
 drivers/scsi/virtio_scsi.c                      | 14 +++++-----
 drivers/scsi/vmw_pvscsi.c                       | 10 +++----
 drivers/scsi/wd719x.c                           |  6 ++---
 drivers/scsi/xen-scsifront.c                    |  4 +--
 drivers/staging/rts5208/rtsx.c                  |  4 +--
 drivers/staging/unisys/visorhba/visorhba_main.c | 14 +++-------
 drivers/target/loopback/tcm_loop.c              |  8 +++---
 drivers/usb/storage/scsiglue.c                  |  4 +--
 drivers/usb/storage/uas.c                       |  3 +--
 include/scsi/libfc.h                            |  2 +-
 include/scsi/libiscsi.h                         |  2 +-
 include/scsi/libsas.h                           |  2 +-
 include/scsi/scsi_host.h                        |  2 +-
 60 files changed, 287 insertions(+), 307 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index cb9f4bc22..f8a6566 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -206,7 +206,7 @@ hostt EH callbacks.  Callbacks may be omitted and omitted ones are
 considered to fail always.
 
 int (* eh_abort_handler)(struct scsi_cmnd *);
-int (* eh_device_reset_handler)(struct scsi_cmnd *);
+int (* eh_device_reset_handler)(struct scsi_device *);
 int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
 int (* eh_host_reset_handler)(struct Scsi_Host *);
 
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index e2609a63..28dc029 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -874,7 +874,7 @@ Details:
 
 /**
  *      eh_device_reset_handler - issue SCSI device reset
- *      @scp: identifies SCSI device to be reset
+ *      @sdev: identifies SCSI device to be reset
  *
  *      Returns SUCCESS if command aborted else FAILED
  *
@@ -887,7 +887,7 @@ Details:
  *
  *      Optionally defined in: LLD
  **/
-     int eh_device_reset_handler(struct scsi_cmnd * scp)
+     int eh_device_reset_handler(struct scsi_device * sdev)
 
 
 /**
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 01a1f7e..82a371b 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -62,7 +62,7 @@ static int cciss_scsi_show_info(struct seq_file *m,
 
 static int cciss_scsi_queue_command (struct Scsi_Host *h,
 				     struct scsi_cmnd *cmd);
-static int cciss_eh_device_reset_handler(struct scsi_cmnd *);
+static int cciss_eh_device_reset_handler(struct scsi_device *);
 static int cciss_eh_abort_handler(struct scsi_cmnd *);
 
 static struct cciss_scsi_hba_t ccissscsi[MAX_CTLR] = {
@@ -1591,23 +1591,21 @@ static int wait_for_device_to_become_ready(ctlr_info_t *h,
  * as a boot device (embedded controller on HP/Compaq systems.)
 */
 
-static int cciss_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
+static int cciss_eh_device_reset_handler(struct scsi_device *scsidev)
 {
 	int rc;
-	CommandList_struct *cmd_in_trouble;
 	unsigned char lunaddr[8];
 	ctlr_info_t *h;
 
 	/* find the controller to which the command to be aborted was sent */
-	h = (ctlr_info_t *) scsicmd->device->host->hostdata[0];
+	h = (ctlr_info_t *) scsidev->host->hostdata[0];
 	if (h == NULL) /* paranoia */
 		return FAILED;
 	dev_warn(&h->pdev->dev, "resetting tape drive or medium changer.\n");
-	/* find the command that's giving us trouble */
-	cmd_in_trouble = (CommandList_struct *) scsicmd->host_scribble;
-	if (cmd_in_trouble == NULL) /* paranoia */
+	rc = lookup_scsi3addr(h, scsidev->channel, scsidev->id,
+			      scsidev->lun, lunaddr);
+	if (rc != 0)
 		return FAILED;
-	memcpy(lunaddr, &cmd_in_trouble->Header.LUN.LunAddrBytes[0], 8);
 	/* send a reset to the SCSI LUN which the command was sent to */
 	rc = sendcmd_withirq(h, CCISS_RESET_MSG, NULL, 0, 0, lunaddr,
 		TYPE_MSG);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 588fc08..b0304a5 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2651,9 +2651,9 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	return ret;
 }
 
-static int srp_reset_device(struct scsi_cmnd *scmnd)
+static int srp_reset_device(struct scsi_device *sdev)
 {
-	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct srp_target_port *target = host_to_target(sdev->host);
 	struct srp_rdma_ch *ch;
 	int i;
 	u8 status;
@@ -2661,7 +2661,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
 	ch = &target->ch[0];
-	if (srp_send_tsk_mgmt(ch, SRP_TAG_NO_REQ, scmnd->device->lun,
+	if (srp_send_tsk_mgmt(ch, SRP_TAG_NO_REQ, sdev->lun,
 			      SRP_TSK_LUN_RESET, &status))
 		return FAILED;
 	if (status)
@@ -2672,7 +2672,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 		for (i = 0; i < target->req_ring_size; ++i) {
 			struct srp_request *req = &ch->req_ring[i];
 
-			srp_finish_req(ch, req, scmnd->device, DID_RESET << 16);
+			srp_finish_req(ch, req, sdev, DID_RESET << 16);
 		}
 	}
 
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 9e164af..c7d7568 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -102,7 +102,7 @@
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
 static void mptfc_remove(struct pci_dev *pdev);
 static int mptfc_abort(struct scsi_cmnd *SCpnt);
-static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
+static int mptfc_dev_reset(struct scsi_device *sdev);
 static int mptfc_bus_reset(struct Scsi_Host *shost, int channel);
 
 static struct scsi_host_template mptfc_driver_template = {
@@ -241,10 +241,10 @@
 }
 
 static int
-mptfc_dev_reset(struct scsi_cmnd *SCpnt)
+mptfc_dev_reset(struct scsi_device *sdev)
 {
-	struct Scsi_Host *shost = SCpnt->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(SCpnt->device));
+	struct Scsi_Host *shost = sdev->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
 	int rtn;
 
@@ -253,8 +253,8 @@
 		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
 			"%s.%d: %d:%llu, executing recovery.\n", __func__,
 			hd->ioc->name, shost->host_no,
-			SCpnt->device->id, SCpnt->device->lun));
-		rtn = mptscsih_dev_reset(SCpnt);
+			sdev->id, sdev->lun));
+		rtn = mptscsih_dev_reset(sdev);
 	}
 	return rtn;
 }
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 0f25a2a..c7f5e73 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1793,14 +1793,14 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_dev_reset - Perform a SCSI LOGICAL_UNIT_RESET!
- *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
+ *	@device: Pointer to scsi_device structure, which reset is due to
  *
  *	(linux scsi_host_template.eh_dev_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  **/
 int
-mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
+mptscsih_dev_reset(struct scsi_device * device)
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
@@ -1809,18 +1809,15 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
-		printk(KERN_ERR MYNAM ": lun reset: "
-		   "Can't locate host! (sc=%p)\n", SCpnt);
+	if ((hd = shost_priv(device->host)) == NULL){
+		printk(KERN_ERR MYNAM ": lun reset: Can't locate host!\n");
 		return FAILED;
 	}
 
 	ioc = hd->ioc;
-	printk(MYIOC_s_INFO_FMT "attempting lun reset! (sc=%p)\n",
-	       ioc->name, SCpnt);
-	scsi_print_command(SCpnt);
+	printk(MYIOC_s_INFO_FMT "attempting lun reset!\n", ioc->name);
 
-	vdevice = SCpnt->device->hostdata;
+	vdevice = device->hostdata;
 	if (!vdevice || !vdevice->vtarget) {
 		retval = 0;
 		goto out;
@@ -1833,8 +1830,8 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
 				mptscsih_get_tm_timeout(ioc));
 
  out:
-	printk (MYIOC_s_INFO_FMT "lun reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	printk (MYIOC_s_INFO_FMT "lun reset: %s\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
 
 	if (retval == 0)
 		return SUCCESS;
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index a5069a84..a7eabef 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -119,7 +119,7 @@ extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
-extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
+extern int mptscsih_dev_reset(struct scsi_device *);
 extern int mptscsih_target_reset(struct Scsi_Host *, struct scsi_target *);
 extern int mptscsih_bus_reset(struct Scsi_Host *, int);
 extern int mptscsih_host_reset(struct Scsi_Host *sh);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 92a3902..23b5a7d 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -304,9 +304,9 @@ static int zfcp_task_mgmt_function(struct scsi_device *sdev, u8 tm_flags)
 	return retval;
 }
 
-static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
+static int zfcp_scsi_eh_device_reset_handler(struct scsi_device *sdev)
 {
-	return zfcp_task_mgmt_function(scpnt->device, FCP_TMF_LUN_RESET);
+	return zfcp_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
 }
 
 /*
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 8802d23..cfc0cc2 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -951,12 +951,11 @@ static int inia100_bus_reset(struct Scsi_Host * shost, int channel)
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_device_reset(struct scsi_cmnd * cmd)
+static int inia100_device_reset(struct scsi_device * dev)
 {				/* I need Host Control Block Information */
 	struct orc_host *host;
-	host = (struct orc_host *) cmd->device->host->hostdata;
-	return orc_device_reset(host, cmd->device);
-
+	host = (struct orc_host *) dev->host->hostdata;
+	return orc_device_reset(host, dev);
 }
 
 /**
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 7214600..8247e8b 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -888,12 +888,11 @@ void aac_tmf_callback(void *context, struct fib *fibptr)
 
 /*
  *	aac_eh_dev_reset	- Device reset command handling
- *	@scsi_cmd:	SCSI command block causing the reset
+ *	@dev:	SCSI device to be reset
  *
  */
-static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
+static int aac_eh_dev_reset(struct scsi_device *dev)
 {
-	struct scsi_device * dev = cmd->device;
 	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	struct aac_hba_map_info *info;
@@ -904,8 +903,8 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 	int status;
 	u8 command;
 
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
+	bus = aac_logical_to_phys(sdev_channel(dev));
+	cid = sdev_id(dev);
 	info = &aac->hba_map[bus][cid];
 	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS ||
 	    info->devtype != AAC_DEVTYPE_NATIVE_RAW)
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 896c36e..ed21ed0 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1052,10 +1052,10 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
  * Reset a device
  *
  */
-static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
+static int aha152x_device_reset(struct scsi_device * sdev)
 {
-	struct Scsi_Host *shpnt = SCpnt->device->host;
-	struct scsi_cmnd *SCprev = NULL;
+	struct Scsi_Host *shpnt = sdev->host;
+	struct scsi_cmnd *SCpnt, *SCprev = NULL;
 	DECLARE_COMPLETION(done);
 	int ret, issued, disconnected;
 	unsigned char old_cmd_len;
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ed44e1e..14752df 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -792,14 +792,14 @@ static int aha1542_release(struct Scsi_Host *sh)
  * This is a device reset.  This is handled by sending a special command
  * to the device.
  */
-static int aha1542_dev_reset(struct scsi_cmnd *cmd)
+static int aha1542_dev_reset(struct scsi_device *sdev)
 {
-	struct Scsi_Host *sh = cmd->device->host;
+	struct Scsi_Host *sh = sdev->host;
 	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	unsigned long flags;
 	struct mailbox *mb = aha1542->mb;
-	u8 target = cmd->device->id;
-	u8 lun = cmd->device->lun;
+	u8 target = sdev->id;
+	u8 lun = sdev->lun;
 	int mbo;
 	struct ccb *ccb = aha1542->ccb;
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 695e93e..56f94be 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -780,12 +780,11 @@ static DEF_SCSI_QCMD(ahd_linux_queue)
  * Attempt to send a target reset message to the device that timed out.
  */
 static int
-ahd_linux_dev_reset(struct scsi_cmnd *cmd)
+ahd_linux_dev_reset(struct scsi_device *sdev)
 {
 	struct ahd_softc *ahd;
 	struct ahd_linux_device *dev;
 	struct scb *reset_scb;
-	u_int  cdb_byte;
 	int    retval = SUCCESS;
 	int    paused;
 	int    wait;
@@ -797,27 +796,22 @@ static DEF_SCSI_QCMD(ahd_linux_queue)
 	reset_scb = NULL;
 	paused = FALSE;
 	wait = FALSE;
-	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
+	ahd = *(struct ahd_softc **)sdev->host->hostdata;
 
-	scmd_printk(KERN_INFO, cmd,
+	sdev_printk(KERN_INFO, sdev,
 		    "Attempting to queue a TARGET RESET message:");
 
-	printk("CDB:");
-	for (cdb_byte = 0; cdb_byte < cmd->cmd_len; cdb_byte++)
-		printk(" 0x%x", cmd->cmnd[cdb_byte]);
-	printk("\n");
-
 	/*
 	 * Determine if we currently own this command.
 	 */
-	dev = scsi_transport_device_data(cmd->device);
+	dev = scsi_transport_device_data(sdev);
 
 	if (dev == NULL) {
 		/*
 		 * No target device for this command exists,
 		 * so we must not still own the command.
 		 */
-		scmd_printk(KERN_INFO, cmd, "Is not an active device\n");
+		sdev_printk(KERN_INFO, sdev, "Is not an active device\n");
 		return SUCCESS;
 	}
 
@@ -826,12 +820,12 @@ static DEF_SCSI_QCMD(ahd_linux_queue)
 	 */
 	reset_scb = ahd_get_scb(ahd, AHD_NEVER_COL_IDX);
 	if (!reset_scb) {
-		scmd_printk(KERN_INFO, cmd, "No SCB available\n");
+		sdev_printk(KERN_INFO, sdev, "No SCB available\n");
 		return FAILED;
 	}
 
 	tinfo = ahd_fetch_transinfo(ahd, 'A', ahd->our_id,
-				    cmd->device->id, &tstate);
+				    sdev->id, &tstate);
 	reset_scb->io_ctx = NULL;
 	reset_scb->platform_data->dev = dev;
 	reset_scb->sg_count = 0;
@@ -839,8 +833,8 @@ static DEF_SCSI_QCMD(ahd_linux_queue)
 	ahd_set_sense_residual(reset_scb, 0);
 	reset_scb->platform_data->xfer_len = 0;
 	reset_scb->hscb->control = 0;
-	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd, cmd->device);
-	reset_scb->hscb->lun = cmd->device->lun;
+	reset_scb->hscb->scsiid = BUILD_SCSIID(ahd, sdev);
+	reset_scb->hscb->lun = sdev->lun;
 	reset_scb->hscb->cdb_len = 0;
 	reset_scb->hscb->task_management = SIU_TASKMGMT_LUN_RESET;
 	reset_scb->flags |= SCB_DEVICE_RESET|SCB_RECOVERY_SCB|SCB_ACTIVE;
@@ -1808,7 +1802,8 @@ struct scsi_host_template aic79xx_driver_template = {
 	 * was retrieved anytime the first byte of
 	 * the sense buffer looks "sane".
 	 */
-	cmd->sense_buffer[0] = 0;
+	if (cmd)
+		cmd->sense_buffer[0] = 0;
 	if (ahd_get_transaction_status(scb) == CAM_REQ_INPROG) {
 		uint32_t amount_xferred;
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index fe8f675..ee861f6 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -756,11 +756,11 @@ static DEF_SCSI_QCMD(ahc_linux_queue)
  * Attempt to send a target reset message to the device that timed out.
  */
 static int
-ahc_linux_dev_reset(struct scsi_cmnd *cmd)
+ahc_linux_dev_reset(struct scsi_device *sdev)
 {
 	int error;
 
-	error = ahc_linux_queue_recovery_cmd(cmd->device, NULL);
+	error = ahc_linux_queue_recovery_cmd(sdev, NULL);
 	if (error != 0)
 		printk("aic7xxx_dev_reset returns 0x%x\n", error);
 	return (error);
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index e3ff1c3..913485f 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2467,16 +2467,15 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 
 /**
  * fas216_eh_device_reset - Reset the device associated with this command
- * @SCpnt: command specifing device to reset
+ * @sdev: device to reset
  *
  * Reset the device associated with this command.
  * Returns: FAILED if unable to reset.
  * Notes: We won't be re-entered, so we'll only have one device
  * reset on the go at one time.
  */
-int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
+int fas216_eh_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = SCpnt->device;
 	FAS216_Info *info = (FAS216_Info *)sdev->host->hostdata;
 	unsigned long flags;
 	int i, res = FAILED, target = sdev->id;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 2b0d14c..34f7047 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -260,7 +260,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	return iscsi_eh_abort(sc);
 }
 
-static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
+static int beiscsi_eh_device_reset(struct scsi_device *sdev)
 {
 	struct beiscsi_invldt_cmd_tbl {
 		struct invldt_cmd_tbl tbl[BE_INVLDT_CMD_TBL_SZ];
@@ -276,7 +276,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	unsigned int i, nents;
 	int rc, more = 0;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(scsi_target(sdev));
 	session = cls_session->dd_data;
 
 	spin_lock_bh(&session->frwd_lock);
@@ -304,7 +304,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		if (!task->sc)
 			continue;
 
-		if (sc->device->lun != task->sc->device->lun)
+		if (sdev->lun != task->sc->device->lun)
 			continue;
 		/**
 		 * Can't fit in more cmds? Normally this won't happen b'coz
@@ -359,7 +359,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	kfree(inv_tbl);
 
 	if (rc == SUCCESS)
-		rc = iscsi_eh_device_reset(sc);
+		rc = iscsi_eh_device_reset(sdev);
 	return rc;
 }
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 6613ef3..2ddfe7e 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -293,9 +293,8 @@ static void bfad_im_fc_rport_add(struct bfad_im_port_s  *im_port,
  *
  */
 static int
-bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
+bfad_im_reset_lun_handler(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmnd->device;
 	struct Scsi_Host *shost = sdev->host;
 	struct bfad_im_port_s *im_port =
 			(struct bfad_im_port_s *) shost->hostdata[0];
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index d115281..db63da1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -541,7 +541,7 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 void bnx2fc_ring_doorbell(struct bnx2fc_rport *tgt);
 int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd);
 int bnx2fc_eh_target_reset(struct scsi_target *sc_tgt);
-int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
+int bnx2fc_eh_device_reset(struct scsi_device *sdev);
 void bnx2fc_rport_event_handler(struct fc_lport *lport,
 				struct fc_rport_priv *rport,
 				enum fc_rport_event event);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 7b8de5e..279de8b 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1074,12 +1074,12 @@ int bnx2fc_eh_target_reset(struct scsi_target *sc_tgt)
  * Set from SCSI host template to send task mgmt command to the target
  *	and wait for the response
  */
-int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
+int bnx2fc_eh_device_reset(struct scsi_device *sdev)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct fc_lport *lport = shost_priv(rport_to_shost(rport));
 
-	return bnx2fc_initiate_tmf(lport, rport, sc_cmd->device->lun,
+	return bnx2fc_initiate_tmf(lport, rport, sdev->lun,
 				   FCP_TMF_LUN_RESET);
 }
 
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 133f683..99347b0 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2059,9 +2059,8 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 }
 
 static int
-csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
+csio_eh_lun_reset_handler(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmnd->device;
 	struct csio_lnode *ln = shost_priv(sdev->host);
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 	struct csio_scsim *scsim = csio_hw_to_scsim(hw);
@@ -2172,12 +2171,12 @@ static DEVICE_ATTR(dbg_level, S_IRUGO | S_IWUSR, csio_show_dbg_level,
 	csio_dbg(hw, "Waiting max %d secs for LUN reset completion\n",
 		    count * (CSIO_SCSI_TM_POLL_MS / 1000));
 	/* Wait for completion */
-	while ((((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd)
+	while ((((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == tmf_cmnd)
 								&& count--)
 		msleep(CSIO_SCSI_TM_POLL_MS);
 
 	/* LUN reset timed-out */
-	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == cmnd) {
+	if (((struct scsi_cmnd *)csio_scsi_cmnd(ioreq)) == tmf_cmnd) {
 		csio_err(hw, "LUN reset (%d:%llu) timed out\n",
 			 sdev->id, sdev->lun);
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index b33e3e7..e146339 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2431,28 +2431,23 @@ static int cxlflash_eh_abort_handler(struct scsi_cmnd *scp)
 
 /**
  * cxlflash_eh_device_reset_handler() - reset a single LUN
- * @scp:	SCSI command to send.
+ * @sdev:	SCSI device to be reset.
  *
  * Return:
  *	SUCCESS as defined in scsi/scsi.h
  *	FAILED as defined in scsi/scsi.h
  */
-static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
+static int cxlflash_eh_device_reset_handler(struct scsi_device *sdev)
 {
 	int rc = SUCCESS;
-	struct Scsi_Host *host = scp->device->host;
+	struct Scsi_Host *host = sdev->host;
 	struct cxlflash_cfg *cfg = shost_priv(host);
 	struct device *dev = &cfg->dev->dev;
 	struct afu *afu = cfg->afu;
 	int rcr = 0;
 
-	dev_dbg(dev, "%s: (scp=%p) %d/%d/%d/%llu "
-		"cdb=(%08x-%08x-%08x-%08x)\n", __func__, scp, host->host_no,
-		scp->device->channel, scp->device->id, scp->device->lun,
-		get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
-		get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
-		get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
-		get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+	dev_dbg(dev, "%s: %d/%d/%d/%llu\n", __func__, host->host_no,
+		sdev->channel, sdev->id, sdev->lun);
 
 retry:
 	switch (cfg->state) {
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index da1c461..aa7870d 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -725,18 +725,19 @@ static int adpt_abort(struct scsi_cmnd * cmd)
 // This is the same for BLK and SCSI devices
 // NOTE this is wrong in the i2o.h definitions
 // This is not currently supported by our adapter but we issue it anyway
-static int adpt_device_reset(struct scsi_cmnd* cmd)
+static int adpt_device_reset(struct scsi_device * sdev)
 {
 	adpt_hba* pHba;
 	u32 msg[4];
 	u32 rcode;
 	int old_state;
-	struct adpt_device* d = cmd->device->hostdata;
+	struct adpt_device* d = sdev->hostdata;
 
-	pHba = (void*) cmd->device->host->hostdata[0];
-	printk(KERN_INFO"%s: Trying to reset device\n",pHba->name);
+	pHba = (void*) sdev->host->hostdata[0];
+	printk(KERN_INFO "%s: Trying to reset device\n", pHba->name);
 	if (!d) {
-		printk(KERN_INFO"%s: Reset Device: Device Not found\n",pHba->name);
+		printk(KERN_INFO "%s: Reset Device: Device Not found\n",
+		       pHba->name);
 		return FAILED;
 	}
 	memset(msg, 0, sizeof(msg));
@@ -749,19 +750,20 @@ static int adpt_device_reset(struct scsi_cmnd* cmd)
 		spin_lock_irq(pHba->host->host_lock);
 	old_state = d->state;
 	d->state |= DPTI_DEV_RESET;
-	rcode = adpt_i2o_post_wait(pHba, msg,sizeof(msg), FOREVER);
+	rcode = adpt_i2o_post_wait(pHba, msg, sizeof(msg), FOREVER);
 	d->state = old_state;
 	if (pHba->host)
 		spin_unlock_irq(pHba->host->host_lock);
 	if (rcode != 0) {
 		if(rcode == -EOPNOTSUPP ){
-			printk(KERN_INFO"%s: Device reset not supported\n",pHba->name);
+			printk(KERN_INFO "%s: Device reset not supported\n",
+			       pHba->name);
 			return FAILED;
 		}
-		printk(KERN_INFO"%s: Device reset failed\n",pHba->name);
+		printk(KERN_INFO "%s: Device reset failed\n", pHba->name);
 		return FAILED;
 	} else {
-		printk(KERN_INFO"%s: Device reset successful\n",pHba->name);
+		printk(KERN_INFO "%s: Device reset successful\n", pHba->name);
 		return SUCCESS;
 	}
 }
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 48a9139..efa266d 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -40,7 +40,7 @@ static int adpt_bios_param(struct scsi_device * sdev, struct block_device *dev,
 		sector_t, int geom[]);
 
 static int adpt_bus_reset(struct Scsi_Host* shost, int channel);
-static int adpt_device_reset(struct scsi_cmnd* cmd);
+static int adpt_device_reset(struct scsi_device * sdev);
 
 
 /*
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 3ed1aca..0b8e12c 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -976,7 +976,7 @@ u8 handle_hba_ioctl(struct esas2r_adapter *a,
 
 /* SCSI error handler (eh) functions */
 int esas2r_eh_abort(struct scsi_cmnd *cmd);
-int esas2r_device_reset(struct scsi_cmnd *cmd);
+int esas2r_device_reset(struct scsi_device *sdev);
 int esas2r_host_reset(struct Scsi_Host *shost);
 int esas2r_bus_reset(struct Scsi_Host *shost, int channel);
 int esas2r_target_reset(struct scsi_target *starget);
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index f0aa2d4..3b8fd41 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1237,9 +1237,8 @@ static int esas2r_dev_targ_reset(struct Scsi_Host *shost, int id, u64 lun,
 	return SUCCESS;
 }
 
-int esas2r_device_reset(struct scsi_cmnd *cmd)
+int esas2r_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
 
 	esas2r_log(ESAS2R_LOG_INFO, "device_reset");
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 35a4080..a9df966 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -342,7 +342,7 @@ static inline struct fnic *fnic_from_ctlr(struct fcoe_ctlr *fip)
 
 int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
-int fnic_device_reset(struct scsi_cmnd *);
+int fnic_device_reset(struct scsi_device *);
 int fnic_host_reset(struct Scsi_Host *);
 int fnic_reset(struct Scsi_Host *);
 void fnic_scsi_cleanup(struct fc_lport *);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index acf7d1d..d633d6c 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2330,9 +2330,8 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
  * fail to get aborted. It calls driver's eh_device_reset with a SCSI command
  * on the LUN.
  */
-int fnic_device_reset(struct scsi_cmnd *sc)
+int fnic_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = sc->device;
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
@@ -2345,8 +2344,10 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	struct scsi_lun fc_lun;
 	struct fnic_stats *fnic_stats;
 	struct reset_stats *reset_stats;
-	int tag = 0;
+	int tag;
+	u64 sc_state = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
+	struct scsi_cmnd *sc;
 
 	/* Wait for rport to unblock */
 	rport = starget_to_rport(scsi_target(sdev));
@@ -2361,7 +2362,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	fnic = lport_priv(lp);
 	fnic_stats = &fnic->fnic_stats;
 	reset_stats = &fnic->fnic_stats.reset_stats;
-
+	tag = fnic->fnic_max_tag_id - 1;
 	atomic64_inc(&reset_stats->device_resets);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
@@ -2377,10 +2378,10 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 		goto fnic_device_reset_end;
 	}
 	/* The last tag is reserved for device reset */
-	sc = scsi_host_find_tag(sdev->host, fnic->fnic_max_tag_id - 1);
+	sc = scsi_host_find_tag(sdev->host, tag);
 	io_lock = fnic_io_lock_hash(fnic, sc);
 	spin_lock_irqsave(io_lock, flags);
-	if (CMD_SP(sc)) {
+	if (!sc || CMD_SP(sc)) {
 		/*
 		 * Reset tag busy
 		 */
@@ -2541,13 +2542,12 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	}
 
 fnic_device_reset_end:
-	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no,
-		  sc->request->tag, sc,
-		  jiffies_to_msecs(jiffies - start_time),
-		  0, ((u64)sc->cmnd[0] << 32 |
-		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
-		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
-		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
+	if (sc)
+		sc_state = ((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc);
+	FNIC_TRACE(fnic_device_reset, sdev->host->host_no,
+		   tag, sc,
+		   jiffies_to_msecs(jiffies - start_time),
+		   0, 0, sc_state);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 		      "Returning from device reset %s\n",
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8914eab..bc781ba 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -257,7 +257,7 @@ static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time);
 static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth);
 
-static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
+static int hpsa_eh_device_reset_handler(struct scsi_device *sdev);
 static int hpsa_slave_alloc(struct scsi_device *sdev);
 static int hpsa_slave_configure(struct scsi_device *sdev);
 static void hpsa_slave_destroy(struct scsi_device *sdev);
@@ -5748,7 +5748,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 /* Need at least one of these error handlers to keep ../scsi/hosts.c from
  * complaining.  Doing a host- or bus-reset can't do anything good here.
  */
-static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
+static int hpsa_eh_device_reset_handler(struct scsi_device *sdev)
 {
 	int rc = SUCCESS;
 	struct ctlr_info *h;
@@ -5758,7 +5758,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	unsigned long flags;
 
 	/* find the controller to which the command to be aborted was sent */
-	h = sdev_to_hba(scsicmd->device);
+	h = sdev_to_hba(sdev);
 	if (h == NULL) /* paranoia */
 		return FAILED;
 
@@ -5771,7 +5771,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 		goto return_reset_status;
 	}
 
-	dev = scsicmd->device->hostdata;
+	dev = sdev->hostdata;
 	if (!dev) {
 		dev_err(&h->pdev->dev, "%s: device lookup failed\n", __func__);
 		rc = FAILED;
@@ -5786,8 +5786,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	/* if controller locked up, we can guarantee command won't complete */
 	if (lockup_detected(h)) {
 		snprintf(msg, sizeof(msg),
-			 "cmd %d RESET FAILED, lockup detected",
-			 hpsa_get_cmd_index(scsicmd));
+			 "RESET FAILED, lockup detected");
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 		rc = FAILED;
 		goto return_reset_status;
@@ -5796,8 +5795,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	/* this reset request might be the result of a lockup; check */
 	if (detect_controller_lockup(h)) {
 		snprintf(msg, sizeof(msg),
-			 "cmd %d RESET FAILED, new lockup detected",
-			 hpsa_get_cmd_index(scsicmd));
+			 "RESET FAILED, new lockup detected");
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 		rc = FAILED;
 		goto return_reset_status;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index f7b9601..7cfade3 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2431,14 +2431,13 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 
 /**
  * ibmvfc_eh_device_reset_handler - Reset a single LUN
- * @cmd:	scsi command struct
+ * @sdev:	scsi device struct
  *
  * Returns:
  *	SUCCESS / FAST_IO_FAIL / FAILED
  **/
-static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
+static int ibmvfc_eh_device_reset_handler(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	int cancel_rc, block_rc, reset_rc = 0;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 262b30c..9fe323a 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1620,16 +1620,16 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
  * template send this over to the server and wait synchronously for the 
  * response
  */
-static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
+static int ibmvscsi_eh_device_reset_handler(struct scsi_device *sdev)
 {
-	struct ibmvscsi_host_data *hostdata = shost_priv(cmd->device->host);
+	struct ibmvscsi_host_data *hostdata = shost_priv(sdev->host);
 	struct srp_tsk_mgmt *tsk_mgmt;
 	struct srp_event_struct *evt;
 	struct srp_event_struct *tmp_evt, *pos;
 	union viosrp_iu srp_rsp;
 	int rsp_rc;
 	unsigned long flags;
-	u16 lun = lun_from_dev(cmd->device);
+	u16 lun = lun_from_dev(sdev);
 	unsigned long wait_switch = 0;
 
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
@@ -1638,7 +1638,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 		evt = get_event_struct(&hostdata->pool);
 		if (evt == NULL) {
 			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-			sdev_printk(KERN_ERR, cmd->device,
+			sdev_printk(KERN_ERR, sdev,
 				"failed to allocate reset event\n");
 			return FAILED;
 		}
@@ -1672,12 +1672,12 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 
 	if (rsp_rc != 0) {
-		sdev_printk(KERN_ERR, cmd->device,
+		sdev_printk(KERN_ERR, sdev,
 			    "failed to send reset event. rc=%d\n", rsp_rc);
 		return FAILED;
 	}
 
-	sdev_printk(KERN_INFO, cmd->device, "resetting device. lun 0x%llx\n",
+	sdev_printk(KERN_INFO, sdev, "resetting device. lun 0x%llx\n",
 		    (((u64) lun) << 48));
 
 	wait_for_completion(&evt->comp);
@@ -1685,7 +1685,8 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	/* make sure we got a good response */
 	if (unlikely(srp_rsp.srp.rsp.opcode != SRP_RSP)) {
 		if (printk_ratelimit())
-			sdev_printk(KERN_WARNING, cmd->device, "reset bad SRP RSP type %d\n",
+			sdev_printk(KERN_WARNING, sdev,
+				    "reset bad SRP RSP type %d\n",
 				    srp_rsp.srp.rsp.opcode);
 		return FAILED;
 	}
@@ -1697,7 +1698,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	if (rsp_rc) {
 		if (printk_ratelimit())
-			sdev_printk(KERN_WARNING, cmd->device,
+			sdev_printk(KERN_WARNING, sdev,
 				    "reset code %d for task tag 0x%llx\n",
 				    rsp_rc, tsk_mgmt->task_tag);
 		return FAILED;
@@ -1708,7 +1709,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	 */
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
-		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == cmd->device)) {
+		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == sdev)) {
 			if (tmp_evt->cmnd)
 				tmp_evt->cmnd->result = (DID_RESET << 16);
 			list_del(&tmp_evt->list);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 2ab2a9e..3824c63 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5296,7 +5296,7 @@ static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
 
 /**
  * ipr_eh_dev_reset - Reset the device
- * @scsi_cmd:	scsi command struct
+ * @scsi_dev:	scsi device struct
  *
  * This function issues a device reset to the affected device.
  * A LUN reset will be sent to the device first. If that does
@@ -5305,7 +5305,7 @@ static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
  * Return value:
  *	SUCCESS / FAILED
  **/
-static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
+static int __ipr_eh_dev_reset(struct scsi_device *scsi_dev)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -5315,8 +5315,8 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 	struct ipr_hrr_queue *hrrq;
 
 	ENTER;
-	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
-	res = scsi_cmd->device->hostdata;
+	ioa_cfg = (struct ipr_ioa_cfg *) scsi_dev->host->hostdata;
+	res = scsi_dev->hostdata;
 
 	/*
 	 * If we are currently going through reset/reload, return failed. This will force the
@@ -5333,7 +5333,8 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 		for (i = hrrq->min_cmd_id; i <= hrrq->max_cmd_id; i++) {
 			ipr_cmd = ioa_cfg->ipr_cmnd_list[i];
 
-			if (ipr_cmd->ioarcb.res_handle == res->res_handle) {
+			if (ipr_cmd->scsi_cmd &&
+			    ipr_cmd->scsi_cmd->device == scsi_dev) {
 				if (!ipr_cmd->qc)
 					continue;
 				if (ipr_cmnd_is_free(ipr_cmd))
@@ -5349,13 +5350,13 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 		spin_unlock(&hrrq->_lock);
 	}
 	res->resetting_device = 1;
-	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
+	sdev_printk(KERN_ERR, scsi_dev, "Resetting device\n");
 
 	if (ipr_is_gata(res) && res->sata_port) {
 		ap = res->sata_port->ap;
-		spin_unlock_irq(scsi_cmd->device->host->host_lock);
+		spin_unlock_irq(scsi_dev->host->host_lock);
 		ata_std_error_handler(ap);
-		spin_lock_irq(scsi_cmd->device->host->host_lock);
+		spin_lock_irq(scsi_dev->host->host_lock);
 	} else
 		rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
@@ -5365,27 +5366,27 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 	return rc ? FAILED : SUCCESS;
 }
 
-static int ipr_eh_dev_reset(struct scsi_cmnd *cmd)
+static int ipr_eh_dev_reset(struct scsi_device *sdev)
 {
 	int rc;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
 
-	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
-	res = cmd->device->hostdata;
+	ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
+	res = sdev->hostdata;
 
 	if (!res)
 		return FAILED;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = __ipr_eh_dev_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(sdev->host->host_lock);
+	rc = __ipr_eh_dev_reset(sdev);
+	spin_unlock_irq(sdev->host->host_lock);
 
 	if (rc == SUCCESS) {
 		if (ipr_is_gata(res) && res->sata_port)
 			rc = ipr_wait_for_ops(ioa_cfg, res, ipr_match_res);
 		else
-			rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
+			rc = ipr_wait_for_ops(ioa_cfg, sdev, ipr_match_lun);
 	}
 
 	return rc;
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index ef6c8bc..c510c3e 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2167,11 +2167,11 @@ int fc_eh_abort(struct scsi_cmnd *sc_cmd)
  *
  * Set from SCSI host template.
  */
-int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
+int fc_eh_device_reset(struct scsi_device *sdev)
 {
 	struct fc_lport *lport;
 	struct fc_fcp_pkt *fsp;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	int rc = FAILED;
 	int rval;
 
@@ -2179,7 +2179,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	if (rval)
 		return rval;
 
-	lport = shost_priv(sc_cmd->device->host);
+	lport = shost_priv(sdev->host);
 
 	if (lport->state != LPORT_ST_READY)
 		return rc;
@@ -2202,7 +2202,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	/*
 	 * flush outstanding commands
 	 */
-	rc = fc_lun_reset(lport, fsp, scmd_id(sc_cmd), sc_cmd->device->lun);
+	rc = fc_lun_reset(lport, fsp, sdev->id, sdev->lun);
 	fsp->state = FC_SRB_FREE;
 	fc_fcp_pkt_release(fsp);
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d51c9ba..97e4b24 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2273,17 +2273,17 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
 }
 EXPORT_SYMBOL_GPL(iscsi_eh_abort);
 
-static void iscsi_prep_lun_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
+static void iscsi_prep_lun_reset_pdu(struct scsi_device *sdev, struct iscsi_tm *hdr)
 {
 	memset(hdr, 0, sizeof(*hdr));
 	hdr->opcode = ISCSI_OP_SCSI_TMFUNC | ISCSI_OP_IMMEDIATE;
 	hdr->flags = ISCSI_TM_FUNC_LOGICAL_UNIT_RESET & ISCSI_FLAG_TM_FUNC_MASK;
 	hdr->flags |= ISCSI_FLAG_CMD_FINAL;
-	int_to_scsilun(sc->device->lun, &hdr->lun);
+	int_to_scsilun(sdev->lun, &hdr->lun);
 	hdr->rtt = RESERVED_ITT;
 }
 
-int iscsi_eh_device_reset(struct scsi_cmnd *sc)
+int iscsi_eh_device_reset(struct scsi_device *sdev)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
@@ -2291,11 +2291,10 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	struct iscsi_tm *hdr;
 	int rc = FAILED;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(scsi_target(sdev));
 	session = cls_session->dd_data;
 
-	ISCSI_DBG_EH(session, "LU Reset [sc %p lun %llu]\n", sc,
-		     sc->device->lun);
+	ISCSI_DBG_EH(session, "LU Reset [lun %llu]\n", sdev->lun);
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->frwd_lock);
@@ -2313,7 +2312,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	conn->tmf_state = TMF_QUEUED;
 
 	hdr = &conn->tmhdr;
-	iscsi_prep_lun_reset_pdu(sc, hdr);
+	iscsi_prep_lun_reset_pdu(sdev, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->lu_reset_timeout)) {
@@ -2340,7 +2339,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
-	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
+	fail_scsi_tasks(conn, sdev->lun, DID_ERROR);
 	conn->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 2001a6e..b966ec1 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -503,18 +503,18 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
 EXPORT_SYMBOL_GPL(sas_eh_abort_handler);
 
 /* Attempt to send a LUN reset message to a device */
-int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
+int sas_eh_device_reset_handler(struct scsi_device *sdev)
 {
 	int res;
 	struct scsi_lun lun;
-	struct Scsi_Host *host = cmd->device->host;
-	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct Scsi_Host *host = sdev->host;
+	struct domain_device *dev = sdev_to_domain_dev(sdev);
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
 	if (current != host->ehandler)
-		return sas_queue_reset(dev, SAS_DEV_LU_RESET, cmd->device->lun, 0);
+		return sas_queue_reset(dev, SAS_DEV_LU_RESET, sdev->lun, 0);
 
-	int_to_scsilun(cmd->device->lun, &lun);
+	int_to_scsilun(sdev->lun, &lun);
 
 	if (!i->dft->lldd_lu_reset)
 		return FAILED;
@@ -557,7 +557,7 @@ static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 	if (!shost->hostt->eh_device_reset_handler)
 		goto try_target_reset;
 
-	res = shost->hostt->eh_device_reset_handler(cmd);
+	res = shost->hostt->eh_device_reset_handler(cmd->device);
 	if (res == SUCCESS)
 		return res;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 573bd43..0fe6d83 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5154,19 +5154,19 @@ void lpfc_poll_timeout(unsigned long ptr)
  *  0x2002 - Success
  **/
 static int
-lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
+lpfc_device_reset_handler(struct scsi_device *sdev)
 {
-	struct Scsi_Host  *shost = cmnd->device->host;
+	struct Scsi_Host  *shost = sdev->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
-	unsigned tgt_id = cmnd->device->id;
-	uint64_t lun_id = cmnd->device->lun;
+	unsigned tgt_id = sdev->id;
+	uint64_t lun_id = sdev->lun;
 	struct lpfc_scsi_event_header scsi_event;
-	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	int status;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = lpfc_rport_data_from_scsi_device(sdev);
 	if (!rdata || !rdata->pnode) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0798 Device Reset rport failure: rdata x%p\n",
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index f3c2310..33b7c66 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2517,27 +2517,23 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-scsih_dev_reset(struct scsi_cmnd *scmd)
+scsih_dev_reset(struct scsi_device *sdev)
 {
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct _sas_device *sas_device = NULL;
 	u16	handle;
 	int r;
-
-	struct scsi_target *starget = scmd->device->sdev_target;
+	struct scsi_target *starget = scsi_target(sdev);
 	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
 
-	sdev_printk(KERN_INFO, scmd->device,
-		"attempting device reset! scmd(%p)\n", scmd);
-	_scsih_tm_display_info(ioc, scmd);
+	sdev_printk(KERN_INFO, sdev,
+		"attempting device reset!\n");
 
-	sas_device_priv_data = scmd->device->hostdata;
+	sas_device_priv_data = sdev->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
-		sdev_printk(KERN_INFO, scmd->device,
-			"device been deleted! scmd(%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
-		scmd->scsi_done(scmd);
+		sdev_printk(KERN_INFO, sdev,
+			"device been deleted!\n");
 		r = SUCCESS;
 		goto out;
 	}
@@ -2554,18 +2550,17 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		handle = sas_device_priv_data->sas_target->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
 		r = FAILED;
 		goto out;
 	}
 
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
-	    scmd->device->id, scmd->device->lun,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, sdev->channel,
+	    sdev->id, sdev->lun,
 	    MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 30);
 
  out:
-	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(%p)\n",
-	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	sdev_printk(KERN_INFO, sdev, "device reset: %s\n",
+	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	if (sas_device)
 		sas_device_put(sas_device);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 289edfe..f8fe609 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3059,11 +3059,11 @@ static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
  * Return value
  *	SUCCESS or FAILED
  */
-static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
+static int pmcraid_eh_device_reset_handler(struct scsi_device *sdev)
 {
-	scmd_printk(KERN_INFO, scmd,
+	sdev_printk(KERN_INFO, sdev,
 		    "resetting device due to an I/O command timeout.\n");
-	return pmcraid_reset_device(scmd->device,
+	return pmcraid_reset_device(sdev,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_LUN);
 }
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 5ccfb14..8feab7e 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -625,12 +625,12 @@ static int qedf_eh_target_reset(struct scsi_target *starget)
 	return qedf_initiate_tmf(rport, 0, FCP_TMF_TGT_RESET);
 }
 
-static int qedf_eh_device_reset(struct scsi_cmnd *sc_cmd)
+static int qedf_eh_device_reset(struct scsi_device *sdev)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 
 	QEDF_ERR(NULL, "LUN RESET Issued...\n");
-	return qedf_initiate_tmf(rport, sc_cmd->device->lun, FCP_TMF_LUN_RESET);
+	return qedf_initiate_tmf(rport, sdev->lun, FCP_TMF_LUN_RESET);
 }
 
 void qedf_wait_for_upload(struct qedf_ctx *qedf)
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index b5484a49..338fe5b 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1001,13 +1001,24 @@ static void qla1280_mailbox_timeout(unsigned long __data)
  *     Reset the specified SCSI device
  **************************************************************************/
 static int
-qla1280_eh_device_reset(struct scsi_cmnd *cmd)
+qla1280_eh_device_reset(struct scsi_device *sdev)
 {
-	int rc;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
+	int rc = FAILED;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = qla1280_error_action(cmd, DEVICE_RESET);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
+	if (qla1280_verbose)
+		printk(KERN_INFO
+		       "scsi(%ld:%d:%d:%llu): Queueing device reset "
+		       "command.\n", ha->host_no, sdev->channel,
+		       sdev->id, sdev->lun);
+	if (qla1280_device_reset(ha, sdev->channel, sdev->id) == 0) {
+		/* issued device reset, set wait conditions */
+		rc = qla1280_wait_for_pending_commands(ha,
+			sdev->channel, sdev->id);
+	}
+	spin_unlock_irq(shost->host_lock);
 
 	return rc;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2345695..14bf189 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -272,7 +272,7 @@
 static void qla2xxx_slave_destroy(struct scsi_device *);
 static int qla2xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
-static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
+static int qla2xxx_eh_device_reset(struct scsi_device *);
 static int qla2xxx_eh_target_reset(struct scsi_target *);
 static int qla2xxx_eh_bus_reset(struct Scsi_Host *, int);
 static int qla2xxx_eh_host_reset(struct Scsi_Host *);
@@ -1384,9 +1384,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 };
 
 static int
-qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct qla_hw_data *ha = vha->hw;
 	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0ce84d6..5271c78 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -158,7 +158,7 @@ static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void  *data,
  */
 static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
-static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_device_reset(struct scsi_device *sdev);
 static int qla4xxx_eh_target_reset(struct scsi_target *starget);
 static int qla4xxx_eh_host_reset(struct Scsi_Host *shost);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
@@ -9238,17 +9238,17 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
  * This routine is called by the Linux OS to reset all luns on the
  * specified target.
  **/
-static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
+static int qla4xxx_eh_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
+	struct scsi_qla_host *ha = to_qla_host(sdev->host);
 	struct iscsi_cls_session *session;
-	struct ddb_entry *ddb_entry = cmd->device->hostdata;
+	struct ddb_entry *ddb_entry = sdev->hostdata;
 	int ret = FAILED, stat;
 
 	if (!ddb_entry)
 		return ret;
 
-	session = starget_to_session(scsi_target(cmd->device));
+	session = starget_to_session(scsi_target(sdev));
 	ret = iscsi_block_scsi_eh(session);
 	if (ret)
 		return ret;
@@ -9256,23 +9256,20 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 
 	ql4_printk(KERN_INFO, ha,
 		   "scsi%ld:%d:%d:%llu: DEVICE RESET ISSUED.\n", ha->host_no,
-		   cmd->device->channel, cmd->device->id, cmd->device->lun);
+		   sdev->channel, sdev->id, sdev->lun);
 
 	DEBUG2(printk(KERN_INFO
-		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
-		      "dpc_flags=%lx, status=%x allowed=%d\n", ha->host_no,
-		      cmd, jiffies, cmd->request->timeout / HZ,
-		      ha->dpc_flags, cmd->result, cmd->allowed));
+		      "scsi%ld: DEVICE_RESET dpc_flags=%lx\n",
+		      ha->host_no, ha->dpc_flags));
 
 	/* FIXME: wait for hba to go online */
-	stat = qla4xxx_reset_lun(ha, ddb_entry, cmd->device->lun);
+	stat = qla4xxx_reset_lun(ha, ddb_entry, sdev->lun);
 	if (stat != QLA_SUCCESS) {
 		ql4_printk(KERN_INFO, ha, "DEVICE RESET FAILED. %d\n", stat);
 		goto eh_dev_reset_done;
 	}
 
-	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(cmd->device),
-					 cmd->device)) {
+	if (qla4xxx_eh_wait_for_commands(ha, scsi_target(sdev), sdev)) {
 		ql4_printk(KERN_INFO, ha,
 			   "DEVICE RESET FAILED - waiting for "
 			   "commands.\n");
@@ -9280,14 +9277,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	}
 
 	/* Send marker. */
-	if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun,
+	if (qla4xxx_send_marker_iocb(ha, ddb_entry, sdev->lun,
 		MM_LUN_RESET) != QLA_SUCCESS)
 		goto eh_dev_reset_done;
 
 	ql4_printk(KERN_INFO, ha,
 		   "scsi(%ld:%d:%d:%llu): DEVICE RESET SUCCEEDED.\n",
-		   ha->host_no, cmd->device->channel, cmd->device->id,
-		   cmd->device->lun);
+		   ha->host_no, sdev->channel, sdev->id, sdev->lun);
 
 	ret = SUCCESS;
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 37e511f..9029500 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3793,19 +3793,17 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static int scsi_debug_device_reset(struct scsi_cmnd * SCpnt)
+static int scsi_debug_device_reset(struct scsi_device * sdp)
 {
+	struct sdebug_dev_info *devip =
+		(struct sdebug_dev_info *)sdp->hostdata;
+
 	++num_dev_resets;
-	if (SCpnt && SCpnt->device) {
-		struct scsi_device *sdp = SCpnt->device;
-		struct sdebug_dev_info *devip =
-				(struct sdebug_dev_info *)sdp->hostdata;
 
-		if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-			sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
-		if (devip)
-			set_bit(SDEBUG_UA_POR, devip->uas_bm);
-	}
+	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
+		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
+	if (devip)
+		set_bit(SDEBUG_UA_POR, devip->uas_bm);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 368a961..4a7fe97f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -844,7 +844,7 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd);
+	rtn = hostt->eh_device_reset_handler(scmd->device);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
@@ -1106,6 +1106,7 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
  * @done_q:	Queue for processed commands.
+ * @result:	Final command status to be set
  *
  * Notes:
  *    We don't want to use the normal command completion while we are are
@@ -1114,10 +1115,18 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
  *    keep a list of pending commands for final completion, and once we
  *    are ready to leave error handling we handle completion for real.
  */
-void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
+void __scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q,
+			int host_byte)
 {
+	if (host_byte)
+		set_host_byte(scmd, host_byte);
 	list_move_tail(&scmd->eh_entry, done_q);
 }
+
+void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
+{
+	__scsi_eh_finish_cmd(scmd, done_q, 0);
+}
 EXPORT_SYMBOL(scsi_eh_finish_cmd);
 
 /**
@@ -1284,7 +1293,8 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 				if (finish_cmds &&
 				    (try_stu ||
 				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
-					scsi_eh_finish_cmd(scmd, done_q);
+					__scsi_eh_finish_cmd(scmd, done_q,
+							     DID_RESET);
 				else
 					list_move_tail(&scmd->eh_entry, work_q);
 			}
@@ -1429,8 +1439,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 							 work_q, eh_entry) {
 					if (scmd->device == sdev &&
 					    scsi_eh_action(scmd, rtn) != FAILED)
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
+						__scsi_eh_finish_cmd(scmd,
+								     done_q,
+								     DID_RESET);
 				}
 			}
 		} else {
@@ -1498,7 +1509,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			if (rtn == SUCCESS)
 				list_move_tail(&scmd->eh_entry, &check_list);
 			else if (rtn == FAST_IO_FAIL)
-				scsi_eh_finish_cmd(scmd, done_q);
+				__scsi_eh_finish_cmd(scmd, done_q,
+						     DID_TRANSPORT_DISRUPTED);
 			else
 				/* push back on work queue for further processing */
 				list_move(&scmd->eh_entry, work_q);
@@ -1563,8 +1575,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 				if (channel == scmd_channel(scmd)) {
 					if (rtn == FAST_IO_FAIL)
-						scsi_eh_finish_cmd(scmd,
-								   done_q);
+						__scsi_eh_finish_cmd(scmd,
+								     done_q,
+								     DID_TRANSPORT_DISRUPTED);
 					else
 						list_move_tail(&scmd->eh_entry,
 							       &check_list);
@@ -1607,9 +1620,9 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
 		if (rtn == SUCCESS) {
 			list_splice_init(work_q, &check_list);
 		} else if (rtn == FAST_IO_FAIL) {
-			list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
-					scsi_eh_finish_cmd(scmd, done_q);
-			}
+			list_for_each_entry_safe(scmd, next, work_q, eh_entry)
+				__scsi_eh_finish_cmd(scmd, done_q,
+						     DID_TRANSPORT_DISRUPTED);
 		} else {
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index cb8f886..e830d0e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5259,16 +5259,16 @@ static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
 	return rc == 0 ? SUCCESS : FAILED;
 }
 
-static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
+static int pqi_eh_device_reset_handler(struct scsi_device *sdev)
 {
 	int rc;
 	struct Scsi_Host *shost;
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_scsi_dev *device;
 
-	shost = scmd->device->host;
+	shost = sdev->host;
 	ctrl_info = shost_to_hba(shost);
-	device = scmd->device->hostdata;
+	device = sdev->hostdata;
 
 	dev_err(&ctrl_info->pci_dev->dev,
 		"resetting scsi %d:%d:%d:%d\n",
diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 9171b90..b27e130 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -379,7 +379,7 @@ struct snic_global {
 
 int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
-int snic_device_reset(struct scsi_cmnd *);
+int snic_device_reset(struct scsi_device *);
 int snic_host_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index f50d274..90990cf 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2134,15 +2134,15 @@
  * command on the LUN.
  */
 int
-snic_device_reset(struct scsi_cmnd *sc)
+snic_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = sc->device;
 	struct Scsi_Host *shost = sdev->host;
 	struct snic *snic = shost_priv(shost);
 	struct snic_req_info *rqi = NULL;
 	int start_time = jiffies;
 	int ret = FAILED;
 	int dr_supp = 0;
+	struct scsi_cmnd tmf_sc, *sc = &tmf_sc;
 
 	SNIC_SCSI_DBG(shost, "dev_reset\n");
 	dr_supp = snic_dev_reset_supported(sdev);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 47a8722..3b95b0c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5481,27 +5481,25 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 /**
  * ufshcd_eh_device_reset_handler - device reset handler registered to
  *                                    scsi layer.
- * @cmd: SCSI command pointer
+ * @sdev: SCSI device pointer
  *
  * Returns SUCCESS/FAILED
  */
-static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
+static int ufshcd_eh_device_reset_handler(struct scsi_device *sdev)
 {
 	struct Scsi_Host *host;
 	struct ufs_hba *hba;
-	unsigned int tag;
+	unsigned int lun;
 	u32 pos;
 	int err;
 	u8 resp = 0xF;
-	struct ufshcd_lrb *lrbp;
 	unsigned long flags;
 
-	host = cmd->device->host;
+	host = sdev->host;
 	hba = shost_priv(host);
-	tag = cmd->request->tag;
+	lun = ufshcd_scsi_to_upiu_lun(sdev->lun);
 
-	lrbp = &hba->lrb[tag];
-	err = ufshcd_issue_tm_cmd(hba, lrbp->lun, 0, UFS_LOGICAL_RESET, &resp);
+	err = ufshcd_issue_tm_cmd(hba, lun, 0, UFS_LOGICAL_RESET, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
 		if (!err)
 			err = resp;
@@ -5510,7 +5508,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	/* clear the commands that were pending for corresponding LUN */
 	for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
-		if (hba->lrb[pos].lun == lrbp->lun) {
+		if (hba->lrb[pos].lun == lun) {
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 8b93197..bc97e41 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -681,26 +681,26 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 	return ret;
 }
 
-static int virtscsi_device_reset(struct scsi_cmnd *sc)
+static int virtscsi_device_reset(struct scsi_device *sdev)
 {
-	struct virtio_scsi *vscsi = shost_priv(sc->device->host);
+	struct virtio_scsi *vscsi = shost_priv(sdev->host);
 	struct virtio_scsi_cmd *cmd;
 
-	sdev_printk(KERN_INFO, sc->device, "device reset\n");
+	sdev_printk(KERN_INFO, sdev, "device reset\n");
 	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
 	if (!cmd)
 		return FAILED;
 
 	memset(cmd, 0, sizeof(*cmd));
-	cmd->sc = sc;
+	cmd->sc = NULL;
 	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
 		.type = VIRTIO_SCSI_T_TMF,
 		.subtype = cpu_to_virtio32(vscsi->vdev,
 					     VIRTIO_SCSI_T_TMF_LOGICAL_UNIT_RESET),
 		.lun[0] = 1,
-		.lun[1] = sc->device->id,
-		.lun[2] = (sc->device->lun >> 8) | 0x40,
-		.lun[3] = sc->device->lun & 0xff,
+		.lun[1] = sdev->id,
+		.lun[2] = (sdev->lun >> 8) | 0x40,
+		.lun[3] = sdev->lun & 0xff,
 	};
 	return virtscsi_tmf(vscsi, cmd);
 }
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 521cd9e..e6c49ea 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -950,14 +950,14 @@ static int pvscsi_bus_reset(struct Scsi_Host *host, int channel)
 	return SUCCESS;
 }
 
-static int pvscsi_device_reset(struct scsi_cmnd *cmd)
+static int pvscsi_device_reset(struct scsi_device *sdev)
 {
-	struct Scsi_Host *host = cmd->device->host;
+	struct Scsi_Host *host = sdev->host;
 	struct pvscsi_adapter *adapter = shost_priv(host);
 	unsigned long flags;
 
-	scmd_printk(KERN_INFO, cmd, "SCSI device reset on scsi%u:%u\n",
-		    host->host_no, cmd->device->id);
+	sdev_printk(KERN_INFO, sdev, "SCSI device reset on scsi%u:%u\n",
+		    host->host_no, sdev->id);
 
 	/*
 	 * We don't want to queue new requests for this device after flushing
@@ -967,7 +967,7 @@ static int pvscsi_device_reset(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
 	pvscsi_process_request_ring(adapter);
-	ll_device_reset(adapter, cmd->device->id);
+	ll_device_reset(adapter, sdev->id);
 	pvscsi_process_completion_ring(adapter);
 
 	spin_unlock_irqrestore(&adapter->hw_lock, flags);
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index a302943..0fb444f 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -500,10 +500,10 @@ static int wd719x_reset(struct Scsi_Host *shost, u8 opcode, u8 device)
 	return SUCCESS;
 }
 
-static int wd719x_dev_reset(struct scsi_cmnd *cmd)
+static int wd719x_dev_reset(struct scsi_device *sdev)
 {
-	return wd719x_reset(cmd->device->host, WD719X_CMD_RESET,
-			    cmd->device->id);
+	return wd719x_reset(sdev->host, WD719X_CMD_RESET,
+			    sdev->id);
 }
 
 static int wd719x_bus_reset(struct Scsi_Host *host, int channel)
diff --git a/drivers/scsi/xen-scsifront.c b/drivers/scsi/xen-scsifront.c
index b093619..91b0fd06 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -655,10 +655,10 @@ static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
 	return scsifront_action_handler(sc->device, sc);
 }
 
-static int scsifront_dev_reset_handler(struct scsi_cmnd *sc)
+static int scsifront_dev_reset_handler(struct scsi_device *sdev)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc->device, NULL);
+	return scsifront_action_handler(sdev, NULL);
 }
 
 static int scsifront_sdev_configure(struct scsi_device *sdev)
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index e719b1e..6df7754 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -196,9 +196,9 @@ static int command_abort(struct scsi_cmnd *srb)
  * This invokes the transport reset mechanism to reset the state of the
  * device
  */
-static int device_reset(struct scsi_cmnd *srb)
+static int device_reset(struct scsi_device *sdev)
 {
-	struct rtsx_dev *dev = host_to_rtsx(srb->device->host);
+	struct rtsx_dev *dev = host_to_rtsx(sdev->host);
 
 	dev_info(&dev->pci->dev, "%s called\n", __func__);
 
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index ba66cd1..ce98a30 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -385,29 +385,21 @@ static int visorhba_abort_handler(struct scsi_cmnd *scsicmd)
 
 /*
  *	visorhba_device_reset_handler - Send TASK_MGMT_LUN_RESET
- *	@scsicmd: The scsicmd that needs aborted
+ *	@scsidev: The scsidev to be reset
  *
  *	Returns SUCCESS if inserted, failure otherwise
  */
-static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
+static int visorhba_device_reset_handler(struct scsi_device *scsidev)
 {
 	/* issue TASK_MGMT_LUN_RESET */
-	struct scsi_device *scsidev;
 	struct visordisk_info *vdisk;
-	int rtn;
 
-	scsidev = scsicmd->device;
 	vdisk = scsidev->hostdata;
 	if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
 		atomic_inc(&vdisk->error_count);
 	else
 		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
-	rtn = forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
-	if (rtn == SUCCESS) {
-		scsicmd->result = DID_RESET << 16;
-		scsicmd->scsi_done(scsicmd);
-	}
-	return rtn;
+	return forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
 }
 
 /*
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 1a10270..f2a6a3e 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -311,7 +311,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
  * Called from SCSI EH process context to issue a LUN_RESET TMR
  * to struct scsi_device
  */
-static int tcm_loop_device_reset(struct scsi_cmnd *sc)
+static int tcm_loop_device_reset(struct scsi_device *sdev)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
@@ -320,10 +320,10 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	/*
 	 * Locate the tcm_loop_hba_t pointer
 	 */
-	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
-	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
+	tl_hba = *(struct tcm_loop_hba **)shost_priv(sdev->host);
+	tl_tpg = &tl_hba->tl_hba_tpgs[sdev->id];
 
-	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun,
+	ret = tcm_loop_issue_tmr(tl_tpg, sdev->lun,
 				 0, TMR_LUN_RESET);
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 04f8fb7..2898112 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -449,9 +449,9 @@ static int command_abort(struct scsi_cmnd *srb)
  * This invokes the transport reset mechanism to reset the state of the
  * device
  */
-static int device_reset(struct scsi_cmnd *srb)
+static int device_reset(struct scsi_device *sdev)
 {
-	struct us_data *us = host_to_us(srb->device->host);
+	struct us_data *us = host_to_us(sdev->host);
 	int result;
 
 	usb_stor_dbg(us, "%s called\n", __func__);
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index cfb1e3b..82a2256 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -737,9 +737,8 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
 	return FAILED;
 }
 
-static int uas_eh_device_reset_handler(struct scsi_cmnd *cmnd)
+static int uas_eh_device_reset_handler(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmnd->device;
 	struct uas_dev_info *devinfo = sdev->hostdata;
 	struct usb_device *udev = devinfo->udev;
 	unsigned long flags;
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index fe4789d..bb68735 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -952,7 +952,7 @@ static inline struct fc_lport *fc_disc_lport(struct fc_disc *disc)
  *****************************/
 int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fc_eh_abort(struct scsi_cmnd *);
-int fc_eh_device_reset(struct scsi_cmnd *);
+int fc_eh_device_reset(struct scsi_device *);
 int fc_eh_host_reset(struct Scsi_Host *);
 int fc_slave_alloc(struct scsi_device *);
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index a8fff96..34d6d90 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -383,7 +383,7 @@ struct iscsi_host {
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_target *starget);
 extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
-extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_device_reset(struct scsi_device *sdev);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
 extern enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 5953bcb..3d0242f 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -713,7 +713,7 @@ extern int sas_bios_param(struct scsi_device *,
 
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
-int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
+int sas_eh_device_reset_handler(struct scsi_device *sdev);
 int sas_eh_target_reset_handler(struct scsi_target *starget);
 
 extern void sas_target_destroy(struct scsi_target *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 33bc523..7095076 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -145,7 +145,7 @@ struct scsi_host_template {
 	 * Status: REQUIRED	(at least one of them)
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
-	int (* eh_device_reset_handler)(struct scsi_cmnd *);
+	int (* eh_device_reset_handler)(struct scsi_device *);
 	int (* eh_target_reset_handler)(struct scsi_target *);
 	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
 	int (* eh_host_reset_handler)(struct Scsi_Host *);
-- 
1.8.5.6
