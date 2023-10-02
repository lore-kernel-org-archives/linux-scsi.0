Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160C4E743C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238269AbjJBP7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238340AbjJBP7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:59:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CC710D
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:59:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A332921869;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696262357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4GRv7xVZdZ3fEX7CvIDhWd4jOXJBfSDF2jIF6KWHXX8=;
        b=cIkVMqSP8ZMCm8XTk3sNWCrv5g5TuAfyozvtKiBjRLxIY2F6dP69+5pEoqJaC/FCuW/8p0
        eCVh7o4XB2UNgNlJefxfEXG3caS0K9h8BJfGKk5hFWY3SDsfMmujQxtA8AXLSfjBmWlH77
        q3kNe3bqle3iDJbj1wWPzW8c7NEShlE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696262357;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4GRv7xVZdZ3fEX7CvIDhWd4jOXJBfSDF2jIF6KWHXX8=;
        b=68FTKZ8eVMm6IacR91LCOu4pGUqKE2AWfBCUQeJkaf5OuJdqym43+eJpoaFlg3N0PCyyHH
        2YwGWOVA2a6GP5DQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 6D7642C149;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 7CF9551E7586; Mon,  2 Oct 2023 17:59:17 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/7] scsi: Use scsi_device as argument to eh_device_reset_handler()
Date:   Mon,  2 Oct 2023 17:59:12 +0200
Message-Id: <20231002155915.109359-5-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002155915.109359-1-hare@suse.de>
References: <20231002155915.109359-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The device reset function should only depend on the scsi device,
not the scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_eh.rst          |  2 +-
 Documentation/scsi/scsi_mid_low_api.rst |  4 +--
 drivers/infiniband/ulp/srp/ib_srp.c     |  6 ++--
 drivers/message/fusion/mptfc.c          | 12 ++++----
 drivers/message/fusion/mptscsih.c       | 19 +++++-------
 drivers/message/fusion/mptscsih.h       |  2 +-
 drivers/s390/scsi/zfcp_scsi.c           |  4 +--
 drivers/scsi/a100u2w.c                  |  7 ++---
 drivers/scsi/aacraid/linit.c            |  9 +++---
 drivers/scsi/aha152x.c                  |  6 ++--
 drivers/scsi/aha1542.c                  |  8 ++---
 drivers/scsi/aic7xxx/aic79xx_osm.c      | 27 +++++++----------
 drivers/scsi/aic7xxx/aic7xxx_osm.c      |  4 +--
 drivers/scsi/arm/fas216.c               |  5 ++--
 drivers/scsi/arm/fas216.h               |  6 ++--
 drivers/scsi/be2iscsi/be_main.c         |  8 ++---
 drivers/scsi/bfa/bfad_im.c              |  3 +-
 drivers/scsi/bnx2fc/bnx2fc.h            |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c         |  6 ++--
 drivers/scsi/csiostor/csio_scsi.c       |  5 ++--
 drivers/scsi/cxlflash/main.c            |  5 ++--
 drivers/scsi/esas2r/esas2r.h            |  2 +-
 drivers/scsi/esas2r/esas2r_main.c       |  3 +-
 drivers/scsi/fnic/fnic.h                |  2 +-
 drivers/scsi/fnic/fnic_scsi.c           |  5 ++--
 drivers/scsi/hpsa.c                     | 14 ++++-----
 drivers/scsi/ibmvscsi/ibmvfc.c          |  8 ++---
 drivers/scsi/ibmvscsi/ibmvscsi.c        | 19 ++++++------
 drivers/scsi/ipr.c                      | 22 +++++++-------
 drivers/scsi/libfc/fc_fcp.c             | 13 ++++----
 drivers/scsi/libiscsi.c                 | 15 +++++-----
 drivers/scsi/libsas/sas_scsi_host.c     | 12 ++++----
 drivers/scsi/lpfc/lpfc_scsi.c           | 10 +++----
 drivers/scsi/mpi3mr/mpi3mr_os.c         | 40 +++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c    | 30 ++++++++-----------
 drivers/scsi/pcmcia/nsp_cs.h            |  2 --
 drivers/scsi/pmcraid.c                  |  6 ++--
 drivers/scsi/qedf/qedf_main.c           |  6 ++--
 drivers/scsi/qla1280.c                  | 21 +++++++++----
 drivers/scsi/qla2xxx/qla_os.c           | 24 +++++++--------
 drivers/scsi/qla4xxx/ql4_os.c           | 23 ++++++--------
 drivers/scsi/scsi_debug.c               |  3 +-
 drivers/scsi/scsi_error.c               | 35 +++++++++++++++-------
 drivers/scsi/smartpqi/smartpqi.h        |  1 -
 drivers/scsi/smartpqi/smartpqi_init.c   | 19 +++++-------
 drivers/scsi/snic/snic.h                |  2 +-
 drivers/scsi/snic/snic_scsi.c           |  4 +--
 drivers/scsi/virtio_scsi.c              | 12 ++++----
 drivers/scsi/vmw_pvscsi.c               | 10 +++----
 drivers/scsi/wd719x.c                   |  6 ++--
 drivers/scsi/xen-scsifront.c            |  6 ++--
 drivers/staging/rts5208/rtsx.c          |  6 +++-
 drivers/target/loopback/tcm_loop.c      |  8 ++---
 drivers/ufs/core/ufshcd.c               |  8 ++---
 drivers/usb/storage/scsiglue.c          |  4 +--
 drivers/usb/storage/uas.c               |  3 +-
 include/scsi/libfc.h                    |  2 +-
 include/scsi/libiscsi.h                 |  2 +-
 include/scsi/libsas.h                   |  2 +-
 include/scsi/scsi_host.h                |  2 +-
 60 files changed, 272 insertions(+), 290 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
index 85057d451a9f..c4ee5e6cf8de 100644
--- a/Documentation/scsi/scsi_eh.rst
+++ b/Documentation/scsi/scsi_eh.rst
@@ -215,7 +215,7 @@ considered to fail always.
 ::
 
     int (* eh_abort_handler)(struct scsi_cmnd *);
-    int (* eh_device_reset_handler)(struct scsi_cmnd *);
+    int (* eh_device_reset_handler)(struct scsi_device *);
     int (* eh_target_reset_handler)(struct scsi_target *);
     int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
     int (* eh_host_reset_handler)(struct Scsi_Host *);
diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 0de71d04fdf4..bcea5e065735 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -778,7 +778,7 @@ Details::
 
     /**
     *      eh_device_reset_handler - issue SCSI device reset
-    *      @scp: identifies SCSI device to be reset
+    *      @sdev: identifies SCSI device to be reset
     *
     *      Returns SUCCESS if command aborted else FAILED
     *
@@ -791,7 +791,7 @@ Details::
     *
     *      Optionally defined in: LLD
     **/
-	int eh_device_reset_handler(struct scsi_cmnd * scp)
+	int eh_device_reset_handler(struct scsi_device * sdev)
 
 
     /**
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 07a61d238d6b..698e19fe3c87 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2813,16 +2813,16 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	return ret;
 }
 
-static int srp_reset_device(struct scsi_cmnd *scmnd)
+static int srp_reset_device(struct scsi_device *sdev)
 {
-	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct srp_target_port *target = host_to_target(sdev->host);
 	struct srp_rdma_ch *ch;
 	u8 status;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
 	ch = &target->ch[0];
-	if (srp_send_tsk_mgmt(ch, SRP_TAG_NO_REQ, scmnd->device->lun,
+	if (srp_send_tsk_mgmt(ch, SRP_TAG_NO_REQ, sdev->lun,
 			      SRP_TSK_LUN_RESET, &status))
 		return FAILED;
 	if (status)
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 83718602c1c4..fb576e3f9268 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -102,7 +102,7 @@ static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
 static void mptfc_remove(struct pci_dev *pdev);
 static int mptfc_abort(struct scsi_cmnd *SCpnt);
-static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
+static int mptfc_dev_reset(struct scsi_device *sdev);
 static int mptfc_bus_reset(struct Scsi_Host *shost, int channel);
 
 static const struct scsi_host_template mptfc_driver_template = {
@@ -240,10 +240,10 @@ mptfc_abort(struct scsi_cmnd *SCpnt)
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
 
@@ -252,8 +252,8 @@ mptfc_dev_reset(struct scsi_cmnd *SCpnt)
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
index b31d74ea9cc8..312ddf43ff9e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1794,14 +1794,14 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
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
@@ -1810,18 +1810,15 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 
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
@@ -1834,8 +1831,8 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 				mptscsih_get_tm_timeout(ioc));
 
  out:
-	printk (MYIOC_s_INFO_FMT "lun reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	printk (MYIOC_s_INFO_FMT "lun reset: %s\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
 
 	if (retval == 0)
 		return SUCCESS;
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index c4eaf3554c7d..70ed021bd458 100644
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
index 6bd07f704391..e9ec2d3bd6a1 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -333,10 +333,8 @@ static int zfcp_scsi_task_mgmt_function(struct scsi_device *sdev, u8 tm_flags)
 	return retval;
 }
 
-static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
+static int zfcp_scsi_eh_device_reset_handler(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = scpnt->device;
-
 	return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
 }
 
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index a1f5f8d65e6b..41f4b13616bc 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -948,12 +948,11 @@ static int inia100_bus_reset(struct Scsi_Host * shost, int channel)
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
index bab5d9c917a8..ca001a301206 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -905,12 +905,11 @@ static void aac_tmf_callback(void *context, struct fib *fibptr)
 
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
@@ -921,8 +920,8 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 	int status;
 	u8 command;
 
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
+	bus = aac_logical_to_phys(sdev_channel(dev));
+	cid = sdev_id(dev);
 
 	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
 		return FAILED;
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index d8ace084b5a7..6bc8ce558c99 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1068,12 +1068,12 @@ static int aha152x_abort(struct scsi_cmnd *SCpnt)
  * Reset a device
  *
  */
-static int aha152x_device_reset(struct scsi_cmnd * SCpnt)
+static int aha152x_device_reset(struct scsi_device * sdev)
 {
-	struct scsi_device *sdev = SCpnt->device;
 	struct Scsi_Host *shpnt = sdev->host;
+	struct scsi_cmnd *SCpnt;
 	DECLARE_COMPLETION(done);
-	int ret, issued, disconnected;
+	int ret, issued, disconnected = 0;
 	unsigned char old_cmd_len;
 	unsigned long flags;
 	unsigned long timeleft;
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 89c0e2c7d9da..584b08d5c164 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -861,14 +861,14 @@ static int aha1542_release(struct Scsi_Host *sh)
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
index a43f643622a9..9390e83557bc 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -767,12 +767,11 @@ ahd_linux_abort(struct scsi_cmnd *cmd)
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
 	struct	ahd_initiator_tinfo *tinfo;
 	struct	ahd_tmode_tstate *tstate;
@@ -781,27 +780,22 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 
 	reset_scb = NULL;
 
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
 
@@ -810,12 +804,12 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
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
@@ -823,8 +817,8 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	ahd_set_sense_residual(reset_scb, 0);
 	reset_scb->platform_data->xfer_len = 0;
 	reset_scb->hscb->control = 0;
-	reset_scb->hscb->scsiid = ahd_build_scsiid(ahd, cmd->device);
-	reset_scb->hscb->lun = cmd->device->lun;
+	reset_scb->hscb->scsiid = ahd_build_scsiid(ahd, sdev);
+	reset_scb->hscb->lun = sdev->lun;
 	reset_scb->hscb->cdb_len = 0;
 	reset_scb->hscb->task_management = SIU_TASKMGMT_LUN_RESET;
 	reset_scb->flags |= SCB_DEVICE_RESET|SCB_RECOVERY_SCB|SCB_ACTIVE;
@@ -1790,7 +1784,8 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 	 * was retrieved anytime the first byte of
 	 * the sense buffer looks "sane".
 	 */
-	cmd->sense_buffer[0] = 0;
+	if (cmd)
+		cmd->sense_buffer[0] = 0;
 	if (ahd_get_transaction_status(scb) == CAM_REQ_INPROG) {
 #ifdef AHD_REPORT_UNDERFLOWS
 		uint32_t amount_xferred;
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 6d42d39806a0..5a3f34e35770 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -739,11 +739,11 @@ ahc_linux_abort(struct scsi_cmnd *cmd)
  * Attempt to send a target reset message to the device that timed out.
  */
 static int
-ahc_linux_dev_reset(struct scsi_cmnd *cmd)
+ahc_linux_dev_reset(struct scsi_device *sdev)
 {
 	int error;
 
-	error = ahc_linux_queue_recovery_cmd(cmd->device, NULL);
+	error = ahc_linux_queue_recovery_cmd(sdev, NULL);
 	if (error != SUCCESS)
 		printk("aic7xxx_dev_reset returns 0x%x\n", error);
 	return (error);
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index c27b49c42c4f..9015755d26bd 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2474,16 +2474,15 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
 
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
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 27a4b564f054..af405ecc2128 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -380,12 +380,12 @@ extern void fas216_print_devices(FAS216_Info *info, struct seq_file *m);
  */
 extern int fas216_eh_abort(struct scsi_cmnd *SCpnt);
 
-/* Function: int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
+/* Function: int fas216_eh_device_reset(struct scsi_device *sdev)
  * Purpose : Reset the device associated with this command
- * Params  : SCpnt - command specifing device to reset
+ * Params  : sdev - device to be reset
  * Returns : FAILED if unable to reset
  */
-extern int fas216_eh_device_reset(struct scsi_cmnd *SCpnt);
+extern int fas216_eh_device_reset(struct scsi_device *sdev);
 
 /* Function: int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt)
  * Purpose : Reset the complete bus associated with this command
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 399fbb452740..aad523e9cfa2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -274,7 +274,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	return iscsi_eh_abort(sc);
 }
 
-static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
+static int beiscsi_eh_device_reset(struct scsi_device *sdev)
 {
 	struct beiscsi_invldt_cmd_tbl {
 		struct invldt_cmd_tbl tbl[BE_INVLDT_CMD_TBL_SZ];
@@ -290,7 +290,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	unsigned int i, nents;
 	int rc, more = 0;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(scsi_target(sdev));
 	session = cls_session->dd_data;
 
 	spin_lock_bh(&session->frwd_lock);
@@ -318,7 +318,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		if (!task->sc)
 			continue;
 
-		if (sc->device->lun != task->sc->device->lun)
+		if (sdev->lun != task->sc->device->lun)
 			continue;
 		/**
 		 * Can't fit in more cmds? Normally this won't happen b'coz
@@ -381,7 +381,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	kfree(inv_tbl);
 
 	if (rc == SUCCESS)
-		rc = iscsi_eh_device_reset(sc);
+		rc = iscsi_eh_device_reset(sdev);
 	return rc;
 }
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 87603f9f79db..4aac948cbd96 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -283,9 +283,8 @@ bfad_im_target_reset_send(struct bfad_s *bfad,
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
index b3ed22d97572..8c47e2a39d91 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -552,7 +552,7 @@ void bnx2fc_add_2_sq(struct bnx2fc_rport *tgt, u16 xid);
 void bnx2fc_ring_doorbell(struct bnx2fc_rport *tgt);
 int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd);
 int bnx2fc_eh_target_reset(struct scsi_target *sc_tgt);
-int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
+int bnx2fc_eh_device_reset(struct scsi_device *sdev);
 void bnx2fc_rport_event_handler(struct fc_lport *lport,
 				struct fc_rport_priv *rport,
 				enum fc_rport_event event);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 0f4a642aca67..9ea0cedb5323 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1072,12 +1072,12 @@ int bnx2fc_eh_target_reset(struct scsi_target *sc_tgt)
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
index 08597de49b7f..4c57265b966e 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2066,9 +2066,8 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 }
 
 static int
-csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
+csio_eh_lun_reset_handler(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmnd->device;
 	struct csio_lnode *ln = shost_priv(sdev->host);
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 	struct csio_scsim *scsim = csio_hw_to_scsim(hw);
@@ -2098,7 +2097,7 @@ csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
 	}
 
 	/* Lnode is ready, now wait on rport node readiness */
-	ret = fc_block_scsi_eh(cmnd);
+	ret = fc_block_rport(rn->rport);
 	if (ret)
 		return ret;
 
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 187757ae7c1f..7027c580c701 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2438,16 +2438,15 @@ static int cxlflash_eh_abort_handler(struct scsi_cmnd *scp)
 
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
-	struct scsi_device *sdev = scp->device;
 	struct Scsi_Host *host = sdev->host;
 	struct cxlflash_cfg *cfg = shost_priv(host);
 	struct device *dev = &cfg->dev->dev;
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 56d8ff63372a..eb5d1dc3049d 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -975,7 +975,7 @@ long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 
 /* SCSI error handler (eh) functions */
 int esas2r_eh_abort(struct scsi_cmnd *cmd);
-int esas2r_device_reset(struct scsi_cmnd *cmd);
+int esas2r_device_reset(struct scsi_device *sdev);
 int esas2r_host_reset(struct Scsi_Host *shost);
 int esas2r_bus_reset(struct Scsi_Host *shost, int channel);
 int esas2r_target_reset(struct scsi_target *starget);
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 056feafaf4e7..b6f68b0b3808 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1177,9 +1177,8 @@ static int esas2r_dev_targ_reset(struct Scsi_Host *shost, int id, u64 lun,
 	return SUCCESS;
 }
 
-int esas2r_device_reset(struct scsi_cmnd *cmd)
+int esas2r_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
 
 	esas2r_log(ESAS2R_LOG_INFO, "device_reset");
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 2e2b49ba8cdf..703594a04b11 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -346,7 +346,7 @@ void fnic_update_mac_locked(struct fnic *, u8 *new);
 
 int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
-int fnic_device_reset(struct scsi_cmnd *);
+int fnic_device_reset(struct scsi_device *);
 int fnic_host_reset(struct Scsi_Host *);
 int fnic_reset(struct Scsi_Host *);
 void fnic_scsi_cleanup(struct fc_lport *);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 324058bd594d..d1c53ae72ffa 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2162,10 +2162,10 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
  * fail to get aborted. It calls driver's eh_device_reset with a SCSI command
  * on the LUN.
  */
-int fnic_device_reset(struct scsi_cmnd *sc)
+int fnic_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = sc->device;
 	struct request *req;
+	struct scsi_cmnd *sc;
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
@@ -2193,7 +2193,6 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	fnic = lport_priv(lp);
 	fnic_stats = &fnic->fnic_stats;
 	reset_stats = &fnic->fnic_stats.reset_stats;
-
 	atomic64_inc(&reset_stats->device_resets);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index af18d20f3079..1cb1f39890d4 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -282,7 +282,7 @@ static int hpsa_scan_finished(struct Scsi_Host *sh,
 	unsigned long elapsed_time);
 static int hpsa_change_queue_depth(struct scsi_device *sdev, int qdepth);
 
-static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd);
+static int hpsa_eh_device_reset_handler(struct scsi_device *sdev);
 static int hpsa_slave_alloc(struct scsi_device *sdev);
 static int hpsa_slave_configure(struct scsi_device *sdev);
 static void hpsa_slave_destroy(struct scsi_device *sdev);
@@ -6021,7 +6021,7 @@ static int wait_for_device_to_become_ready(struct ctlr_info *h,
 /* Need at least one of these error handlers to keep ../scsi/hosts.c from
  * complaining.  Doing a host- or bus-reset can't do anything good here.
  */
-static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
+static int hpsa_eh_device_reset_handler(struct scsi_device *sdev)
 {
 	int rc = SUCCESS;
 	int i;
@@ -6032,7 +6032,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	unsigned long flags;
 
 	/* find the controller to which the command to be aborted was sent */
-	h = sdev_to_hba(scsicmd->device);
+	h = sdev_to_hba(sdev);
 	if (h == NULL) /* paranoia */
 		return FAILED;
 
@@ -6045,7 +6045,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 		goto return_reset_status;
 	}
 
-	dev = scsicmd->device->hostdata;
+	dev = sdev->hostdata;
 	if (!dev) {
 		dev_err(&h->pdev->dev, "%s: device lookup failed\n", __func__);
 		rc = FAILED;
@@ -6060,8 +6060,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
 	/* if controller locked up, we can guarantee command won't complete */
 	if (lockup_detected(h)) {
 		snprintf(msg, sizeof(msg),
-			 "cmd %d RESET FAILED, lockup detected",
-			 hpsa_get_cmd_index(scsicmd));
+			 "RESET FAILED, lockup detected");
 		hpsa_show_dev_msg(KERN_WARNING, h, dev, msg);
 		rc = FAILED;
 		goto return_reset_status;
@@ -6070,8 +6069,7 @@ static int hpsa_eh_device_reset_handler(struct scsi_cmnd *scsicmd)
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
index 52601c8c16bc..97f8b6a925fb 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2887,20 +2887,20 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 
 /**
  * ibmvfc_eh_device_reset_handler - Reset a single LUN
- * @cmd:	scsi command struct
+ * @sdev:	scsi devicestruct
  *
  * Returns:
  *	SUCCESS / FAST_IO_FAIL / FAILED
  **/
-static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
+static int ibmvfc_eh_device_reset_handler(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, block_rc, reset_rc = 0;
 	int rc = FAILED;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_rport(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index da131fc34c2a..e227de98734a 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1624,16 +1624,16 @@ static int ibmvscsi_eh_abort_handler(struct scsi_cmnd *cmd)
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
@@ -1642,7 +1642,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 		evt = get_event_struct(&hostdata->pool);
 		if (evt == NULL) {
 			spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-			sdev_printk(KERN_ERR, cmd->device,
+			sdev_printk(KERN_ERR, sdev,
 				"failed to allocate reset event\n");
 			return FAILED;
 		}
@@ -1676,12 +1676,12 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
@@ -1689,7 +1689,8 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	/* make sure we got a good response */
 	if (unlikely(srp_rsp.srp.rsp.opcode != SRP_RSP)) {
 		if (printk_ratelimit())
-			sdev_printk(KERN_WARNING, cmd->device, "reset bad SRP RSP type %d\n",
+			sdev_printk(KERN_WARNING, sdev,
+				    "reset bad SRP RSP type %d\n",
 				    srp_rsp.srp.rsp.opcode);
 		return FAILED;
 	}
@@ -1701,7 +1702,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 
 	if (rsp_rc) {
 		if (printk_ratelimit())
-			sdev_printk(KERN_WARNING, cmd->device,
+			sdev_printk(KERN_WARNING, sdev,
 				    "reset code %d for task tag 0x%llx\n",
 				    rsp_rc, tsk_mgmt->task_tag);
 		return FAILED;
@@ -1712,7 +1713,7 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	 */
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	list_for_each_entry_safe(tmp_evt, pos, &hostdata->sent, list) {
-		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == cmd->device)) {
+		if ((tmp_evt->cmnd) && (tmp_evt->cmnd->device == sdev)) {
 			if (tmp_evt->cmnd)
 				tmp_evt->cmnd->result = (DID_RESET << 16);
 			list_del(&tmp_evt->list);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index df012977a25e..8e0696448590 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5037,7 +5037,7 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
 
 /**
  * __ipr_eh_dev_reset - Reset the device
- * @scsi_cmd:	scsi command struct
+ * @scsi_dev:	scsi device struct
  *
  * This function issues a device reset to the affected device.
  * A LUN reset will be sent to the device first. If that does
@@ -5046,15 +5046,15 @@ static int ipr_device_reset(struct ipr_ioa_cfg *ioa_cfg,
  * Return value:
  *	SUCCESS / FAILED
  **/
-static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
+static int __ipr_eh_dev_reset(struct scsi_device *scsi_dev)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_resource_entry *res;
 	int rc = 0;
 
 	ENTER;
-	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
-	res = scsi_cmd->device->hostdata;
+	ioa_cfg = (struct ipr_ioa_cfg *) scsi_dev->host->hostdata;
+	res = scsi_dev->hostdata;
 
 	/*
 	 * If we are currently going through reset/reload, return failed. This will force the
@@ -5067,7 +5067,7 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 		return FAILED;
 
 	res->resetting_device = 1;
-	scmd_printk(KERN_ERR, scsi_cmd, "Resetting device\n");
+	sdev_printk(KERN_ERR, scsi_dev, "Resetting device\n");
 
 	rc = ipr_device_reset(ioa_cfg, res);
 	res->resetting_device = 0;
@@ -5077,21 +5077,21 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
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
 
 	if (rc == SUCCESS)
 		rc = ipr_wait_for_ops(ioa_cfg, cmd->device, ipr_match_lun);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 2ee697dd4ce3..52db6587cbc4 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2135,24 +2135,23 @@ EXPORT_SYMBOL(fc_eh_abort);
 
 /**
  * fc_eh_device_reset() - Reset a single LUN
- * @sc_cmd: The SCSI command which identifies the device whose
- *	    LUN is to be reset
+ * @sdev: The SCSI device whose LUN is to be reset
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
 
-	rval = fc_block_scsi_eh(sc_cmd);
+	rval = fc_block_rport(rport);
 	if (rval)
 		return rval;
 
-	lport = shost_priv(sc_cmd->device->host);
+	lport = shost_priv(sdev->host);
 
 	if (lport->state != LPORT_ST_READY)
 		return rc;
@@ -2175,7 +2174,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	/*
 	 * flush outstanding commands
 	 */
-	rc = fc_lun_reset(lport, fsp, scmd_id(sc_cmd), sc_cmd->device->lun);
+	rc = fc_lun_reset(lport, fsp, sdev->id, sdev->lun);
 	fsp->state = FC_SRB_FREE;
 	fc_fcp_pkt_release(fsp);
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index cea78a8cc712..82742aca5625 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2496,17 +2496,17 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
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
@@ -2514,11 +2514,10 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
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
@@ -2536,7 +2535,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	session->tmf_state = TMF_QUEUED;
 
 	hdr = &session->tmhdr;
-	iscsi_prep_lun_reset_pdu(sc, hdr);
+	iscsi_prep_lun_reset_pdu(sdev, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->lu_reset_timeout)) {
@@ -2563,7 +2562,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
-	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
+	fail_scsi_tasks(conn, sdev->lun, DID_ERROR);
 	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 3fa0c55a2234..34cdfc456fd7 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -454,18 +454,18 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
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
-		return sas_queue_reset(dev, SAS_DEV_LU_RESET, cmd->device->lun);
+		return sas_queue_reset(dev, SAS_DEV_LU_RESET, sdev->lun);
 
-	int_to_scsilun(cmd->device->lun, &lun);
+	int_to_scsilun(sdev->lun, &lun);
 
 	if (!i->dft->lldd_lu_reset)
 		return FAILED;
@@ -510,7 +510,7 @@ static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 	if (!shost->hostt->eh_device_reset_handler)
 		goto try_target_reset;
 
-	res = shost->hostt->eh_device_reset_handler(cmd);
+	res = shost->hostt->eh_device_reset_handler(cmd->device);
 	if (res == SUCCESS)
 		return res;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index e21433394a0e..3176de7ef8fe 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5967,15 +5967,15 @@ lpfc_reset_flush_io_context(struct lpfc_vport *vport, uint16_t tgt_id,
  *  0x2002 - Success
  **/
 static int
-lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
+lpfc_device_reset_handler(struct scsi_device *sdev)
 {
-	struct Scsi_Host  *shost = cmnd->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+	struct Scsi_Host  *shost = sdev->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
-	unsigned tgt_id = cmnd->device->id;
-	uint64_t lun_id = cmnd->device->lun;
+	unsigned tgt_id = sdev->id;
+	uint64_t lun_id = sdev->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 	u32 logit = LOG_FCP;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 11ee2908757b..114ef1c0f812 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4142,30 +4142,28 @@ static int mpi3mr_eh_target_reset(struct scsi_target *starget)
 
 /**
  * mpi3mr_eh_dev_reset- Device reset error handling callback
- * @scmd: SCSI command reference
+ * @sdev: SCSI device reference
  *
- * Issue lun reset Task Management and verify the scmd is
- * terminated successfully and return status accordingly.
+ * Issue lun reset Task Management and return status accordingly.
  *
- * Return: SUCCESS of successful termination of the scmd else
+ * Return: SUCCESS of successful lun reset else
  *         FAILED
  */
-static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
+static int mpi3mr_eh_dev_reset(struct scsi_device *sdev)
 {
-	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct mpi3mr_ioc *mrioc = shost_priv(sdev->host);
 	struct mpi3mr_stgt_priv_data *stgt_priv_data;
 	struct mpi3mr_sdev_priv_data *sdev_priv_data;
 	u16 dev_handle;
 	u8 resp_code = 0;
 	int retval = FAILED, ret = 0;
 
-	sdev_printk(KERN_INFO, scmd->device,
-	    "Attempting Device(lun) Reset! scmd(%p)\n", scmd);
-	scsi_print_command(scmd);
+	sdev_printk(KERN_INFO, sdev,
+	    "Attempting Device(lun) Reset!\n");
 
-	sdev_priv_data = scmd->device->hostdata;
+	sdev_priv_data = sdev->hostdata;
 	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
-		sdev_printk(KERN_INFO, scmd->device,
+		sdev_printk(KERN_INFO, sdev,
 		    "SCSI device is not available\n");
 		retval = SUCCESS;
 		goto out;
@@ -4174,38 +4172,34 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
 	stgt_priv_data = sdev_priv_data->tgt_priv_data;
 	dev_handle = stgt_priv_data->dev_handle;
 	if (stgt_priv_data->dev_removed) {
-		struct scmd_priv *cmd_priv = scsi_cmd_priv(scmd);
-		sdev_printk(KERN_INFO, scmd->device,
+		sdev_printk(KERN_INFO, sdev,
 		    "%s: device(handle = 0x%04x) is removed, device(LUN) reset is not issued\n",
 		    mrioc->name, dev_handle);
-		if (!cmd_priv->in_lld_scope || cmd_priv->host_tag == MPI3MR_HOSTTAG_INVALID)
-			retval = SUCCESS;
-		else
-			retval = FAILED;
+		retval = FAILED;
 		goto out;
 	}
-	sdev_printk(KERN_INFO, scmd->device,
+	sdev_printk(KERN_INFO, sdev,
 	    "Device(lun) Reset is issued to handle(0x%04x)\n", dev_handle);
 
 	ret = mpi3mr_issue_tm(mrioc,
 	    MPI3_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, dev_handle,
 	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
-	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, scmd);
+	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
 
 	if (ret)
 		goto out;
 
 	if (sdev_priv_data->pend_count) {
-		sdev_printk(KERN_INFO, scmd->device,
+		sdev_printk(KERN_INFO, sdev,
 		    "%s: device has %d pending commands, device(LUN) reset is failed\n",
 		    mrioc->name, sdev_priv_data->pend_count);
 		goto out;
 	}
 	retval = SUCCESS;
 out:
-	sdev_printk(KERN_INFO, scmd->device,
-	    "%s: device(LUN) reset is %s for scmd(%p)\n", mrioc->name,
-	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	sdev_printk(KERN_INFO, sdev,
+	    "%s: device(LUN) reset is %s\n", mrioc->name,
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	return retval;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c6dd00b034f4..530a043e40d2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3365,9 +3365,9 @@ scsih_abort(struct scsi_cmnd *scmd)
  * Return: SUCCESS if command aborted else FAILED
  */
 static int
-scsih_dev_reset(struct scsi_cmnd *scmd)
+scsih_dev_reset(struct scsi_device *sdev)
 {
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(sdev->host);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct _sas_device *sas_device = NULL;
 	struct _pcie_device *pcie_device = NULL;
@@ -3376,20 +3376,17 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	u8	tr_timeout = 30;
 	int r;
 
-	struct scsi_target *starget = scmd->device->sdev_target;
+	struct scsi_target *starget = sdev->sdev_target;
 	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
 
-	sdev_printk(KERN_INFO, scmd->device,
-	    "attempting device reset! scmd(0x%p)\n", scmd);
-	_scsih_tm_display_info(ioc, scmd);
+	sdev_printk(KERN_INFO, sdev,
+	    "attempting device reset!\n");
 
-	sas_device_priv_data = scmd->device->hostdata;
+	sas_device_priv_data = sdev->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
 	    ioc->remove_host) {
-		sdev_printk(KERN_INFO, scmd->device,
-		    "device been deleted! scmd(0x%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
-		scsi_done(scmd);
+		sdev_printk(KERN_INFO, sdev,
+		    "device been deleted!\n");
 		r = SUCCESS;
 		goto out;
 	}
@@ -3406,7 +3403,6 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		handle = sas_device_priv_data->sas_target->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
 		r = FAILED;
 		goto out;
 	}
@@ -3420,16 +3416,16 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 	} else
 		tr_method = MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET;
 
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
-		scmd->device->id, scmd->device->lun,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, sdev->channel,
+		sdev->id, sdev->lun,
 		MPI2_SCSITASKMGMT_TASKTYPE_LOGICAL_UNIT_RESET, 0, 0,
 		tr_timeout, tr_method);
 	/* Check for busy commands after reset */
-	if (r == SUCCESS && scsi_device_busy(scmd->device))
+	if (r == SUCCESS && scsi_device_busy(sdev))
 		r = FAILED;
  out:
-	sdev_printk(KERN_INFO, scmd->device, "device reset: %s scmd(0x%p)\n",
-	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	sdev_printk(KERN_INFO, sdev, "device reset: %s\n",
+	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	if (sas_device)
 		sas_device_put(sas_device);
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 8636f0053c02..c2b522a194fc 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -297,8 +297,6 @@ static        int        nsp_show_info  (struct seq_file *m,
 static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
 
 /* Error handler */
-/*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
-/*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/
 static int nsp_eh_bus_reset    (struct Scsi_Host *host, int channel);
 static int nsp_eh_host_reset   (struct Scsi_Host *host);
 static int nsp_bus_reset       (nsp_hw_data *data);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index d806576edb87..92ed0b86ad80 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3014,11 +3014,11 @@ static int pmcraid_eh_abort_handler(struct scsi_cmnd *scsi_cmd)
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
index f6876307c304..bf169950834c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -864,12 +864,12 @@ static int qedf_eh_target_reset(struct scsi_target *starget)
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
 
 bool qedf_wait_for_upload(struct qedf_ctx *qedf)
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1df3deb618e4..cb010aa271ce 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -963,13 +963,24 @@ qla1280_eh_abort(struct scsi_cmnd * cmd)
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
index 53bb73e07c3a..5c160f8ef013 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1445,9 +1445,8 @@ static char *reset_errors[] = {
 };
 
 static int
-qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
@@ -1473,42 +1472,41 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		return FAILED;
 
 	ql_log(ql_log_info, vha, 0x8009,
-	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu cmd=%p.\n", vha->host_no,
-	    sdev->id, sdev->lun, cmd);
+	    "DEVICE RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no,
+	    sdev->id, sdev->lun);
 
 	err = 0;
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800a,
-		    "Wait for hba online failed for cmd=%p.\n", cmd);
+		    "Wait for hba online failed.\n");
 		goto eh_reset_failed;
 	}
 	err = 2;
 	if (ha->isp_ops->lun_reset(fcport, sdev->lun, 1)
 		!= QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800c,
-		    "do_reset failed for cmd=%p.\n", cmd);
+		    "do_reset failed.\n");
 		goto eh_reset_failed;
 	}
 	err = 3;
 	if (qla2x00_eh_wait_for_pending_commands(vha, fcport->d_id.b24,
-						 cmd->device->lun,
+						 sdev->lun,
 						 WAIT_LUN) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
-		    "wait for pending cmds failed for cmd=%p.\n", cmd);
+		    "wait for pending cmds failed.\n");
 		goto eh_reset_failed;
 	}
 
 	ql_log(ql_log_info, vha, 0x800e,
-	    "DEVICE RESET SUCCEEDED nexus:%ld:%d:%llu cmd=%p.\n",
-	    vha->host_no, sdev->id, sdev->lun, cmd);
+	    "DEVICE RESET SUCCEEDED nexus:%ld:%d:%llu.\n",
+	    vha->host_no, sdev->id, sdev->lun);
 
 	return SUCCESS;
 
 eh_reset_failed:
 	ql_log(ql_log_info, vha, 0x800f,
-	    "DEVICE RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n",
-	    reset_errors[err], vha->host_no, sdev->id, sdev->lun,
-	    cmd);
+	    "DEVICE RESET FAILED: %s nexus=%ld:%d:%llu.\n",
+	    reset_errors[err], vha->host_no, sdev->id, sdev->lun);
 	vha->reset_cmd_err_cnt++;
 	return FAILED;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6725830855f9..f99f0dd8686c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -157,7 +157,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len);
  */
 static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
-static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_device_reset(struct scsi_device *sdev);
 static int qla4xxx_eh_target_reset(struct scsi_target *starget);
 static int qla4xxx_eh_host_reset(struct Scsi_Host *shost);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
@@ -9270,9 +9270,8 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
  * This routine is called by the Linux OS to reset all luns on the
  * specified target.
  **/
-static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
+static int qla4xxx_eh_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
 	struct scsi_qla_host *ha = to_qla_host(sdev->host);
 	struct iscsi_cls_session *session;
 	struct ddb_entry *ddb_entry = sdev->hostdata;
@@ -9290,13 +9289,11 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 
 	ql4_printk(KERN_INFO, ha,
 		   "scsi%ld:%d:%d:%llu: DEVICE RESET ISSUED.\n", ha->host_no,
-		   cmd->device->channel, cmd->device->id, cmd->device->lun);
+		   sdev->channel, sdev->id, sdev->lun);
 
 	DEBUG2(printk(KERN_INFO
-		      "scsi%ld: DEVICE_RESET cmd=%p jiffies = 0x%lx, to=%x,"
-		      "dpc_flags=%lx, status=%x allowed=%d\n", ha->host_no,
-		      cmd, jiffies, scsi_cmd_to_rq(cmd)->timeout / HZ,
-		      ha->dpc_flags, cmd->result, cmd->allowed));
+		      "scsi%ld: DEVICE_RESET dpc_flags=%lx\n",
+		      ha->host_no, ha->dpc_flags));
 
 	rval = qla4xxx_isp_check_reg(ha);
 	if (rval != QLA_SUCCESS) {
@@ -9305,14 +9302,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 	}
 
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
@@ -9320,14 +9316,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
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
index e1ba3ca8c89b..15a5d4bed51a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5306,9 +5306,8 @@ static void scsi_debug_stop_all_queued(struct scsi_device *sdp)
 				scsi_debug_stop_all_queued_iter, sdp);
 }
 
-static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
+static int scsi_debug_device_reset(struct scsi_device *sdp)
 {
-	struct scsi_device *sdp = SCpnt->device;
 	struct sdebug_dev_info *devip = sdp->hostdata;
 
 	++num_dev_resets;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index a5c93b53aa7b..3e312601cf22 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -980,7 +980,7 @@ static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd);
+	rtn = hostt->eh_device_reset_handler(scmd->device);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
@@ -1265,6 +1265,7 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
  * @done_q:	Queue for processed commands.
+ * @result:	Final command status to be set
  *
  * Notes:
  *    We don't want to use the normal command completion while we are are
@@ -1273,10 +1274,18 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
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
@@ -1451,7 +1460,8 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 				if (finish_cmds &&
 				    (try_stu ||
 				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
-					scsi_eh_finish_cmd(scmd, done_q);
+					__scsi_eh_finish_cmd(scmd, done_q,
+							     DID_RESET);
 				else
 					list_move_tail(&scmd->eh_entry, work_q);
 			}
@@ -1600,8 +1610,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
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
@@ -1669,7 +1680,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			if (rtn == SUCCESS)
 				list_move_tail(&scmd->eh_entry, &check_list);
 			else if (rtn == FAST_IO_FAIL)
-				scsi_eh_finish_cmd(scmd, done_q);
+				__scsi_eh_finish_cmd(scmd, done_q,
+						     DID_TRANSPORT_DISRUPTED);
 			else
 				/* push back on work queue for further processing */
 				list_move(&scmd->eh_entry, work_q);
@@ -1734,8 +1746,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
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
@@ -1778,9 +1791,9 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
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
diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 041940183516..93339f7e2bbd 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1093,7 +1093,6 @@ struct pqi_tmf_work {
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_scsi_dev *device;
 	u8	lun;
-	u8	scsi_opcode;
 };
 
 struct pqi_scsi_dev {
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9a58df9312fa..4da9b1d59f17 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6351,15 +6351,15 @@ static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev
 	return rc;
 }
 
-static int pqi_device_reset_handler(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device, u8 lun, struct scsi_cmnd *scmd, u8 scsi_opcode)
+static int pqi_device_reset_handler(struct pqi_ctrl_info *ctrl_info, struct pqi_scsi_dev *device, u8 lun)
 {
 	int rc;
 
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"resetting scsi %d:%d:%d:%u SCSI cmd at %p due to cmd opcode 0x%02x\n",
-		ctrl_info->scsi_host->host_no, device->bus, device->target, lun, scmd, scsi_opcode);
+		"resetting scsi %d:%d:%d:%u\n",
+		ctrl_info->scsi_host->host_no, device->bus, device->target, lun);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
@@ -6377,19 +6377,17 @@ static int pqi_device_reset_handler(struct pqi_ctrl_info *ctrl_info, struct pqi_
 	return rc;
 }
 
-static int pqi_eh_device_reset_handler(struct scsi_cmnd *scmd)
+static int pqi_eh_device_reset_handler(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost;
 	struct pqi_ctrl_info *ctrl_info;
 	struct pqi_scsi_dev *device;
-	u8 scsi_opcode;
 
-	shost = scmd->device->host;
+	shost = sdev->host;
 	ctrl_info = shost_to_hba(shost);
-	device = scmd->device->hostdata;
-	scsi_opcode = scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff;
+	device = sdev->hostdata;
 
-	return pqi_device_reset_handler(ctrl_info, device, (u8)scmd->device->lun, scmd, scsi_opcode);
+	return pqi_device_reset_handler(ctrl_info, device, (u8)sdev->lun);
 }
 
 static void pqi_tmf_worker(struct work_struct *work)
@@ -6400,7 +6398,7 @@ static void pqi_tmf_worker(struct work_struct *work)
 	tmf_work = container_of(work, struct pqi_tmf_work, work_struct);
 	scmd = (struct scsi_cmnd *)xchg(&tmf_work->scmd, NULL);
 
-	pqi_device_reset_handler(tmf_work->ctrl_info, tmf_work->device, tmf_work->lun, scmd, tmf_work->scsi_opcode);
+	pqi_device_reset_handler(tmf_work->ctrl_info, tmf_work->device, tmf_work->lun);
 }
 
 static int pqi_eh_abort_handler(struct scsi_cmnd *scmd)
@@ -6433,7 +6431,6 @@ static int pqi_eh_abort_handler(struct scsi_cmnd *scmd)
 		tmf_work->ctrl_info = ctrl_info;
 		tmf_work->device = device;
 		tmf_work->lun = (u8)scmd->device->lun;
-		tmf_work->scsi_opcode = scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff;
 		schedule_work(&tmf_work->work_struct);
 	}
 
diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 27acc50bd1a5..52eab57d8cd0 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -364,7 +364,7 @@ extern const struct attribute_group *snic_host_groups[];
 
 int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
-int snic_device_reset(struct scsi_cmnd *);
+int snic_device_reset(struct scsi_device *);
 int snic_host_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index c167fe55226e..defae60f88b2 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2089,9 +2089,8 @@ snic_unlink_and_release_req(struct snic *snic, struct scsi_cmnd *sc, int flag)
  * command on the LUN.
  */
 int
-snic_device_reset(struct scsi_cmnd *sc)
+snic_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = sc->device;
 	struct Scsi_Host *shost = sdev->host;
 	struct snic *snic = shost_priv(shost);
 	struct request *req;
@@ -2099,6 +2098,7 @@ snic_device_reset(struct scsi_cmnd *sc)
 	int start_time = jiffies;
 	int ret = FAILED;
 	int dr_supp = 0;
+	struct scsi_cmnd tmf_sc, *sc = &tmf_sc;
 
 	SNIC_SCSI_DBG(shost, "dev_reset\n");
 	dr_supp = snic_dev_reset_supported(sdev);
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 9d1bdcdc1331..1826fdc3ed36 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -638,12 +638,12 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
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
@@ -654,9 +654,9 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
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
index 9c62d446ea9e..1624c9b400e9 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -971,14 +971,14 @@ static int pvscsi_bus_reset(struct Scsi_Host *host, int channel)
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
@@ -988,7 +988,7 @@ static int pvscsi_device_reset(struct scsi_cmnd *cmd)
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
 	pvscsi_process_request_ring(adapter);
-	ll_device_reset(adapter, cmd->device->id);
+	ll_device_reset(adapter, sdev->id);
 	pvscsi_process_completion_ring(adapter);
 
 	spin_unlock_irqrestore(&adapter->hw_lock, flags);
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index bc48152e74b8..18a12b17e4b1 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -510,10 +510,10 @@ static int wd719x_reset(struct Scsi_Host *shost, u8 opcode, u8 device)
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
index 26dd229aeb22..e5ef3e880dbf 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -698,7 +698,7 @@ static int scsifront_action_handler(struct scsi_device *sdev, struct scsi_cmnd *
 		if (scsifront_enter(info))
 			goto fail;
 
-		if (!scsifront_do_request(sc->device, info, shadow))
+		if (!scsifront_do_request(sdev, info, shadow))
 			break;
 
 		scsifront_return(info);
@@ -742,10 +742,10 @@ static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
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
index 08543a3936da..8ddc0f8e68b3 100644
--- a/drivers/staging/rts5208/rtsx.c
+++ b/drivers/staging/rts5208/rtsx.c
@@ -182,8 +182,12 @@ static int command_abort(struct scsi_cmnd *srb)
  * This invokes the transport reset mechanism to reset the state of the
  * device
  */
-static int device_reset(struct scsi_cmnd *srb)
+static int device_reset(struct scsi_device *sdev)
 {
+	struct rtsx_dev *dev = host_to_rtsx(sdev->host);
+
+	dev_info(&dev->pci->dev, "%s called\n", __func__);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 07565c0ed139..e36d7500b5da 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -250,7 +250,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
  * Called from SCSI EH process context to issue a LUN_RESET TMR
  * to struct scsi_device
  */
-static int tcm_loop_device_reset(struct scsi_cmnd *sc)
+static int tcm_loop_device_reset(struct scsi_device *sdev)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
@@ -259,10 +259,10 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
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
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6ccf4d949171..fd8db6a2dbc9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7300,11 +7300,11 @@ int ufshcd_advanced_rpmb_req_handler(struct ufs_hba *hba, struct utp_upiu_req *r
 
 /**
  * ufshcd_eh_device_reset_handler() - Reset a single logical unit.
- * @cmd: SCSI command pointer
+ * @sdev: SCSI device pointer
  *
  * Return: SUCCESS or FAILED.
  */
-static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
+static int ufshcd_eh_device_reset_handler(struct scsi_device *sdev)
 {
 	unsigned long flags, pending_reqs = 0, not_cleared = 0;
 	struct Scsi_Host *host;
@@ -7315,10 +7315,10 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	int err;
 	u8 resp = 0xF, lun;
 
-	host = cmd->device->host;
+	host = sdev->host;
 	hba = shost_priv(host);
 
-	lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
+	lun = ufshcd_scsi_to_upiu_lun(sdev->lun);
 	err = ufshcd_issue_tm_cmd(hba, lun, 0, UFS_LOGICAL_RESET, &resp);
 	if (err || resp != UPIU_TASK_MANAGEMENT_FUNC_COMPL) {
 		if (!err)
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 4b5b10d64931..e1ae5d9d8b72 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -459,9 +459,9 @@ static int command_abort(struct scsi_cmnd *srb)
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
index 2583ee9815c5..518e07148816 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -762,9 +762,8 @@ static int uas_eh_abort_handler(struct scsi_cmnd *cmnd)
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
index dd71e198b360..6f91254847b3 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -949,7 +949,7 @@ void fc_fcp_destroy(struct fc_lport *);
  *****************************/
 int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fc_eh_abort(struct scsi_cmnd *);
-int fc_eh_device_reset(struct scsi_cmnd *);
+int fc_eh_device_reset(struct scsi_device *);
 int fc_eh_host_reset(struct Scsi_Host *);
 int fc_slave_alloc(struct scsi_device *);
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 73d3c79f86c3..a55ce76ee060 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -391,7 +391,7 @@ struct iscsi_host {
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_target *starget);
 extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
-extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_device_reset(struct scsi_device *sdev);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
 extern enum scsi_timeout_action iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ee535f3d3931..79b2fc5620b1 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -715,7 +715,7 @@ void sas_init_dev(struct domain_device *);
 
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
-int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
+int sas_eh_device_reset_handler(struct scsi_device *sdev);
 int sas_eh_target_reset_handler(struct scsi_target *starget);
 
 extern void sas_target_destroy(struct scsi_target *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index fa0bc5b3ead0..be3099c9373e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -150,7 +150,7 @@ struct scsi_host_template {
 	 * Status: REQUIRED	(at least one of them)
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
-	int (* eh_device_reset_handler)(struct scsi_cmnd *);
+	int (* eh_device_reset_handler)(struct scsi_device *);
 	int (* eh_target_reset_handler)(struct scsi_target *);
 	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
 	int (* eh_host_reset_handler)(struct Scsi_Host *);
-- 
2.35.3

