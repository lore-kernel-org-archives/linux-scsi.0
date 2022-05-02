Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4286FC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 22:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387829AbiEBWFi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 18:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387797AbiEBWDw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 18:03:52 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8E463EE
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 15:00:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BAED31F74C;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmp4z9DYdpQj/IbiEQcJZ2cUUmoQV8KUSUeqAXJrLtk=;
        b=OjA7KgRSmpX6X3m7bINdP5BhEIRKDlgNEcmumTTW3siQCeCMprkunxD8YeUhhesnKEE7D2
        PdhR8Y10zByaMR9FLXdndmrZ/j7alvYX1DRjm7Xahks8G46VzikFfqI6RYdz0WZOXFcRHU
        kmytbrNFqShkOIyf1A4O+1kTouqD4Cw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kmp4z9DYdpQj/IbiEQcJZ2cUUmoQV8KUSUeqAXJrLtk=;
        b=3DnXGGS4Kzr1dVvmdqAc7SAXebdbOlp3o8P7DiF5N2W0Tw+3GgAyAmlOxUSdIhma2hDeMX
        m824aC3Sq/RhUgDQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B391C2C152;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id AF2585194150; Tue,  3 May 2022 00:00:00 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 4/7] scsi: Use scsi_device as argument to eh_device_reset_handler()
Date:   Mon,  2 May 2022 23:59:43 +0200
Message-Id: <20220502215953.5463-9-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
References: <20220502215953.5463-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The device reset function should only depend on the scsi device,
not the scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 Documentation/scsi/scsi_eh.rst                |  2 +-
 Documentation/scsi/scsi_mid_low_api.rst       |  4 +--
 drivers/infiniband/ulp/srp/ib_srp.c           |  6 ++--
 drivers/message/fusion/mptfc.c                | 12 +++----
 drivers/message/fusion/mptscsih.c             | 19 +++++-----
 drivers/message/fusion/mptscsih.h             |  2 +-
 drivers/s390/scsi/zfcp_scsi.c                 |  4 +--
 drivers/scsi/a100u2w.c                        |  7 ++--
 drivers/scsi/aacraid/linit.c                  |  9 +++--
 drivers/scsi/aha152x.c                        |  6 ++--
 drivers/scsi/aha1542.c                        |  8 ++---
 drivers/scsi/aic7xxx/aic79xx_osm.c            | 27 ++++++--------
 drivers/scsi/aic7xxx/aic7xxx_osm.c            |  4 +--
 drivers/scsi/arm/fas216.c                     |  5 ++-
 drivers/scsi/arm/fas216.h                     |  6 ++--
 drivers/scsi/be2iscsi/be_main.c               |  8 ++---
 drivers/scsi/bfa/bfad_im.c                    |  3 +-
 drivers/scsi/bnx2fc/bnx2fc.h                  |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c               |  6 ++--
 drivers/scsi/csiostor/csio_scsi.c             |  3 +-
 drivers/scsi/cxlflash/main.c                  |  5 ++-
 drivers/scsi/dpt_i2o.c                        | 20 ++++++-----
 drivers/scsi/dpti.h                           |  2 +-
 drivers/scsi/esas2r/esas2r.h                  |  2 +-
 drivers/scsi/esas2r/esas2r_main.c             |  3 +-
 drivers/scsi/fnic/fnic.h                      |  2 +-
 drivers/scsi/fnic/fnic_scsi.c                 |  6 ++--
 drivers/scsi/hpsa.c                           | 14 ++++----
 drivers/scsi/ibmvscsi/ibmvfc.c                |  5 ++-
 drivers/scsi/ibmvscsi/ibmvscsi.c              | 19 +++++-----
 drivers/scsi/ipr.c                            | 31 ++++++++--------
 drivers/scsi/libfc/fc_fcp.c                   | 11 +++---
 drivers/scsi/libiscsi.c                       | 15 ++++----
 drivers/scsi/libsas/sas_scsi_host.c           | 12 +++----
 drivers/scsi/lpfc/lpfc_scsi.c                 | 10 +++---
 drivers/scsi/mpi3mr/mpi3mr_os.c               | 34 +++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c          | 30 +++++++---------
 drivers/scsi/pcmcia/nsp_cs.h                  |  2 --
 drivers/scsi/pmcraid.c                        |  6 ++--
 drivers/scsi/qedf/qedf_main.c                 |  6 ++--
 drivers/scsi/qla1280.c                        | 21 ++++++++---
 drivers/scsi/qla2xxx/qla_os.c                 | 22 ++++++------
 drivers/scsi/qla4xxx/ql4_os.c                 | 23 +++++-------
 drivers/scsi/scsi_debug.c                     | 18 +++++-----
 drivers/scsi/scsi_error.c                     | 35 +++++++++++++------
 drivers/scsi/smartpqi/smartpqi_init.c         | 11 +++---
 drivers/scsi/snic/snic.h                      |  2 +-
 drivers/scsi/snic/snic_scsi.c                 |  4 +--
 drivers/scsi/ufs/ufshcd.c                     |  8 ++---
 drivers/scsi/virtio_scsi.c                    | 12 +++----
 drivers/scsi/vmw_pvscsi.c                     | 10 +++---
 drivers/scsi/wd719x.c                         |  6 ++--
 drivers/scsi/xen-scsifront.c                  | 23 +++++++-----
 drivers/staging/rts5208/rtsx.c                |  6 +++-
 .../staging/unisys/visorhba/visorhba_main.c   | 13 ++-----
 drivers/target/loopback/tcm_loop.c            |  8 ++---
 drivers/usb/storage/scsiglue.c                |  4 +--
 drivers/usb/storage/uas.c                     |  3 +-
 include/scsi/libfc.h                          |  2 +-
 include/scsi/libiscsi.h                       |  2 +-
 include/scsi/libsas.h                         |  2 +-
 include/scsi/scsi_host.h                      |  2 +-
 62 files changed, 302 insertions(+), 313 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
index cfa14ad55dda..5b654a42de90 100644
--- a/Documentation/scsi/scsi_eh.rst
+++ b/Documentation/scsi/scsi_eh.rst
@@ -213,7 +213,7 @@ considered to fail always.
 ::
 
     int (* eh_abort_handler)(struct scsi_cmnd *);
-    int (* eh_device_reset_handler)(struct scsi_cmnd *);
+    int (* eh_device_reset_handler)(struct scsi_device *);
     int (* eh_target_reset_handler)(struct scsi_target *);
     int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
     int (* eh_host_reset_handler)(struct Scsi_Host *);
diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 0afc1b4f89af..4650c0c6a22a 100644
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
index de901dee6935..bc1200c3a101 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2824,16 +2824,16 @@ static int srp_abort(struct scsi_cmnd *scmnd)
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
index bc62f0cc0cbd..be69b8b746c0 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -102,7 +102,7 @@ static void mptfc_target_destroy(struct scsi_target *starget);
 static void mptfc_set_rport_loss_tmo(struct fc_rport *rport, uint32_t timeout);
 static void mptfc_remove(struct pci_dev *pdev);
 static int mptfc_abort(struct scsi_cmnd *SCpnt);
-static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
+static int mptfc_dev_reset(struct scsi_device *sdev);
 static int mptfc_bus_reset(struct Scsi_Host *shost, int channel);
 
 static struct scsi_host_template mptfc_driver_template = {
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
index af140dbd63d9..d5b5a850633e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1795,14 +1795,14 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
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
@@ -1811,18 +1811,15 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 
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
@@ -1835,8 +1832,8 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
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
index 10bbe56189b3..7343c7543e60 100644
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
index dab79824e2f6..23c248e35536 100644
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
index a63e03203679..9acb63cf29dd 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -896,12 +896,11 @@ static void aac_tmf_callback(void *context, struct fib *fibptr)
 
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
@@ -912,8 +911,8 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 	int status;
 	u8 command;
 
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
+	bus = aac_logical_to_phys(sdev_channel(dev));
+	cid = sdev_id(dev);
 
 	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
 		return FAILED;
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 1312dc5ef6d2..b697b33ab335 100644
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
index 797a49f927dd..d6d8b9827978 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -860,14 +860,14 @@ static int aha1542_release(struct Scsi_Host *sh)
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
index 00786c37f39f..3d9c6fbc2f2d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -770,12 +770,11 @@ ahd_linux_abort(struct scsi_cmnd *cmd)
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
@@ -784,27 +783,22 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 
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
 
@@ -813,12 +807,12 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
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
@@ -826,8 +820,8 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
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
@@ -1793,7 +1787,8 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
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
index f6c547cef26c..2b06473c2f2b 100644
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
index f954c6f869fb..b55226161f53 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -267,7 +267,7 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	return iscsi_eh_abort(sc);
 }
 
-static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
+static int beiscsi_eh_device_reset(struct scsi_device *sdev)
 {
 	struct beiscsi_invldt_cmd_tbl {
 		struct invldt_cmd_tbl tbl[BE_INVLDT_CMD_TBL_SZ];
@@ -283,7 +283,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	unsigned int i, nents;
 	int rc, more = 0;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(scsi_target(sdev));
 	session = cls_session->dd_data;
 
 	spin_lock_bh(&session->frwd_lock);
@@ -311,7 +311,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		if (!task->sc)
 			continue;
 
-		if (sc->device->lun != task->sc->device->lun)
+		if (sdev->lun != task->sc->device->lun)
 			continue;
 		/**
 		 * Can't fit in more cmds? Normally this won't happen b'coz
@@ -366,7 +366,7 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	kfree(inv_tbl);
 
 	if (rc == SUCCESS)
-		rc = iscsi_eh_device_reset(sc);
+		rc = iscsi_eh_device_reset(sdev);
 	return rc;
 }
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 272dedfee1a7..39d3fb80b2fc 100644
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
index 0f5218eb9732..3968a99c89da 100644
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
index b21aa2c43051..f1a647d8a6a4 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -2060,9 +2060,8 @@ csio_tm_cbfn(struct csio_hw *hw, struct csio_ioreq *req)
 }
 
 static int
-csio_eh_lun_reset_handler(struct scsi_cmnd *cmnd)
+csio_eh_lun_reset_handler(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmnd->device;
 	struct csio_lnode *ln = shost_priv(sdev->host);
 	struct csio_hw *hw = csio_lnode_to_hw(ln);
 	struct csio_scsim *scsim = csio_hw_to_scsim(hw);
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 50c04ba85b0b..2bc18f775385 100644
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
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index b1ab772aff0e..480735cc00d3 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -674,18 +674,19 @@ static int adpt_abort(struct scsi_cmnd * cmd)
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
@@ -698,19 +699,20 @@ static int adpt_device_reset(struct scsi_cmnd* cmd)
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
index 48878e69ab2c..763b4cadb21e 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -36,7 +36,7 @@ static int adpt_bios_param(struct scsi_device * sdev, struct block_device *dev,
 		sector_t, int geom[]);
 
 static int adpt_bus_reset(struct Scsi_Host* shost, int channel);
-static int adpt_device_reset(struct scsi_cmnd* cmd);
+static int adpt_device_reset(struct scsi_device * sdev);
 
 
 /*
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
index 1ad39c1ae085..1c5e93a85af9 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1174,9 +1174,8 @@ static int esas2r_dev_targ_reset(struct Scsi_Host *shost, int id, u64 lun,
 	return SUCCESS;
 }
 
-int esas2r_device_reset(struct scsi_cmnd *cmd)
+int esas2r_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
 
 	esas2r_log(ESAS2R_LOG_INFO, "device_reset");
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 7b81bea3ffa2..73329f9fd343 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -358,7 +358,7 @@ void fnic_update_mac_locked(struct fnic *, u8 *new);
 
 int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
-int fnic_device_reset(struct scsi_cmnd *);
+int fnic_device_reset(struct scsi_device *);
 int fnic_host_reset(struct Scsi_Host *);
 int fnic_reset(struct Scsi_Host *);
 void fnic_scsi_cleanup(struct fc_lport *);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index b286d5feaca1..3ab2ad49abf7 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2177,9 +2177,9 @@ static int fnic_clean_pending_aborts(struct fnic *fnic,
  * fail to get aborted. It calls driver's eh_device_reset with a SCSI command
  * on the LUN.
  */
-int fnic_device_reset(struct scsi_cmnd *sc)
+int fnic_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = sc->device;
+	struct scsi_cmnd *sc;
 	struct fc_lport *lp;
 	struct fnic *fnic;
 	struct fnic_io_req *io_req = NULL;
@@ -2207,7 +2207,7 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 	fnic = lport_priv(lp);
 	fnic_stats = &fnic->fnic_stats;
 	reset_stats = &fnic->fnic_stats.reset_stats;
-
+	tag = fnic->fnic_max_tag_id - 1;
 	atomic64_inc(&reset_stats->device_resets);
 
 	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a47bcce3c9c7..844efffcfe27 100644
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
index 9b9f6a0122e4..06dfff541f24 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2883,14 +2883,13 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 
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
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, block_rc, reset_rc = 0;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 892d79e2e7e1..2fd63fc85b63 100644
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
index 29893dae7f24..c980c4c58a29 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5326,7 +5326,7 @@ static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
 
 /**
  * __ipr_eh_dev_reset - Reset the device
- * @scsi_cmd:	scsi command struct
+ * @scsi_dev:	scsi device struct
  *
  * This function issues a device reset to the affected device.
  * A LUN reset will be sent to the device first. If that does
@@ -5335,7 +5335,7 @@ static int ipr_sata_reset(struct ata_link *link, unsigned int *classes,
  * Return value:
  *	SUCCESS / FAILED
  **/
-static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
+static int __ipr_eh_dev_reset(struct scsi_device *scsi_dev)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -5345,8 +5345,8 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 	struct ipr_hrr_queue *hrrq;
 
 	ENTER;
-	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
-	res = scsi_cmd->device->hostdata;
+	ioa_cfg = (struct ipr_ioa_cfg *) scsi_dev->host->hostdata;
+	res = scsi_dev->hostdata;
 
 	/*
 	 * If we are currently going through reset/reload, return failed. This will force the
@@ -5363,7 +5363,8 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
 		for (i = hrrq->min_cmd_id; i <= hrrq->max_cmd_id; i++) {
 			ipr_cmd = ioa_cfg->ipr_cmnd_list[i];
 
-			if (ipr_cmd->ioarcb.res_handle == res->res_handle) {
+			if (ipr_cmd->scsi_cmd &&
+			    ipr_cmd->scsi_cmd->device == scsi_dev) {
 				if (!ipr_cmd->qc)
 					continue;
 				if (ipr_cmnd_is_free(ipr_cmd))
@@ -5379,13 +5380,13 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
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
@@ -5395,27 +5396,27 @@ static int __ipr_eh_dev_reset(struct scsi_cmnd *scsi_cmd)
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
index ab4a1c01a353..c71e24730ac2 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2144,16 +2144,15 @@ EXPORT_SYMBOL(fc_eh_abort);
 
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
 
@@ -2161,7 +2160,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	if (rval)
 		return rval;
 
-	lport = shost_priv(sc_cmd->device->host);
+	lport = shost_priv(sdev->host);
 
 	if (lport->state != LPORT_ST_READY)
 		return rc;
@@ -2184,7 +2183,7 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	/*
 	 * flush outstanding commands
 	 */
-	rc = fc_lun_reset(lport, fsp, scmd_id(sc_cmd), sc_cmd->device->lun);
+	rc = fc_lun_reset(lport, fsp, sdev->id, sdev->lun);
 	fsp->state = FC_SRB_FREE;
 	fc_fcp_pkt_release(fsp);
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index ac3708b65938..c76df7152b5c 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2390,17 +2390,17 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
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
@@ -2408,11 +2408,10 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
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
@@ -2430,7 +2429,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 	session->tmf_state = TMF_QUEUED;
 
 	hdr = &session->tmhdr;
-	iscsi_prep_lun_reset_pdu(sc, hdr);
+	iscsi_prep_lun_reset_pdu(sdev, hdr);
 
 	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
 				    session->lu_reset_timeout)) {
@@ -2457,7 +2456,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 
 	spin_lock_bh(&session->frwd_lock);
 	memset(hdr, 0, sizeof(*hdr));
-	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
+	fail_scsi_tasks(conn, sdev->lun, DID_ERROR);
 	session->tmf_state = TMF_INITIAL;
 	spin_unlock_bh(&session->frwd_lock);
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index ae7e093eff4b..e8a8c14ad1af 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -490,18 +490,18 @@ int sas_eh_abort_handler(struct scsi_cmnd *cmd)
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
@@ -546,7 +546,7 @@ static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 	if (!shost->hostt->eh_device_reset_handler)
 		goto try_target_reset;
 
-	res = shost->hostt->eh_device_reset_handler(cmd);
+	res = shost->hostt->eh_device_reset_handler(cmd->device);
 	if (res == SUCCESS)
 		return res;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 834c3f31f327..3895ab41a1cb 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6301,15 +6301,15 @@ lpfc_reset_flush_io_context(struct lpfc_vport *vport, uint16_t tgt_id,
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
index 2c4a2f31be76..f215b866bddb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3467,30 +3467,28 @@ static int mpi3mr_eh_target_reset(struct scsi_target *starget)
 
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
@@ -3499,34 +3497,34 @@ static int mpi3mr_eh_dev_reset(struct scsi_cmnd *scmd)
 	stgt_priv_data = sdev_priv_data->tgt_priv_data;
 	dev_handle = stgt_priv_data->dev_handle;
 	if (stgt_priv_data->dev_removed) {
-		sdev_printk(KERN_INFO, scmd->device,
+		sdev_printk(KERN_INFO, sdev,
 		    "%s: device(handle = 0x%04x) is removed, device(LUN) reset is not issued\n",
 		    mrioc->name, dev_handle);
 		retval = FAILED;
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
index 4c84fd9774ab..f59a0749ae8c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3366,9 +3366,9 @@ scsih_abort(struct scsi_cmnd *scmd)
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
@@ -3377,20 +3377,17 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
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
@@ -3407,7 +3404,6 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 		handle = sas_device_priv_data->sas_target->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
 		r = FAILED;
 		goto out;
 	}
@@ -3421,16 +3417,16 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
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
index 44ff1f7fbbc0..86d8e6a06831 100644
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
index c90a2c449978..21c94ba448af 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -863,12 +863,12 @@ static int qedf_eh_target_reset(struct scsi_target *starget)
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
index f32f00c7a390..44f4359777ae 100644
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
index 35cf2c3dbe01..1bcbadb8b664 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1395,9 +1395,8 @@ static char *reset_errors[] = {
 };
 
 static int
-qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_device_reset(struct scsi_device *sdev)
 {
-	struct scsi_device *sdev = cmd->device;
 	scsi_qla_host_t *vha = shost_priv(sdev->host);
 	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	fc_port_t *fcport = (struct fc_port *) sdev->hostdata;
@@ -1423,41 +1422,40 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 		return SUCCESS;
 
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
 	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
 	    sdev->lun, WAIT_LUN) != QLA_SUCCESS) {
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
index 90828d4eb26d..6a6c159b618c 100644
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
@@ -9260,9 +9260,8 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
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
@@ -9280,13 +9279,11 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 
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
@@ -9295,14 +9292,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
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
@@ -9310,14 +9306,13 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
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
index 2e9daf8c7e83..b7f3d728d13e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5272,19 +5272,17 @@ static int scsi_debug_abort(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
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
index 3ee4393a1f1e..93f7006982d8 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -940,7 +940,7 @@ static enum scsi_disposition scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_device_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_device_reset_handler(scmd);
+	rtn = hostt->eh_device_reset_handler(scmd->device);
 	if (rtn == SUCCESS)
 		__scsi_report_device_reset(scmd->device, NULL);
 	return rtn;
@@ -1225,6 +1225,7 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
  * scsi_eh_finish_cmd - Handle a cmd that eh is finished with.
  * @scmd:	Original SCSI cmd that eh has finished.
  * @done_q:	Queue for processed commands.
+ * @result:	Final command status to be set
  *
  * Notes:
  *    We don't want to use the normal command completion while we are are
@@ -1233,10 +1234,18 @@ scsi_eh_action(struct scsi_cmnd *scmd, enum scsi_disposition rtn)
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
@@ -1411,7 +1420,8 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 				if (finish_cmds &&
 				    (try_stu ||
 				     scsi_eh_action(scmd, SUCCESS) == SUCCESS))
-					scsi_eh_finish_cmd(scmd, done_q);
+					__scsi_eh_finish_cmd(scmd, done_q,
+							     DID_RESET);
 				else
 					list_move_tail(&scmd->eh_entry, work_q);
 			}
@@ -1560,8 +1570,9 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
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
@@ -1629,7 +1640,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 			if (rtn == SUCCESS)
 				list_move_tail(&scmd->eh_entry, &check_list);
 			else if (rtn == FAST_IO_FAIL)
-				scsi_eh_finish_cmd(scmd, done_q);
+				__scsi_eh_finish_cmd(scmd, done_q,
+						     DID_TRANSPORT_DISRUPTED);
 			else
 				/* push back on work queue for further processing */
 				list_move(&scmd->eh_entry, work_q);
@@ -1694,8 +1706,9 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
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
@@ -1738,9 +1751,9 @@ static int scsi_eh_host_reset(struct Scsi_Host *shost,
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
index 7c0d069a3158..cca67898384e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6289,24 +6289,23 @@ static int pqi_device_reset(struct pqi_ctrl_info *ctrl_info,
 	return rc;
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
 
 	mutex_lock(&ctrl_info->lun_reset_mutex);
 
 	dev_err(&ctrl_info->pci_dev->dev,
-		"resetting scsi %d:%d:%d:%d due to cmd 0x%02x\n",
+		"resetting scsi %d:%d:%d:%d\n",
 		shost->host_no,
-		device->bus, device->target, device->lun,
-		scmd->cmd_len > 0 ? scmd->cmnd[0] : 0xff);
+		device->bus, device->target, device->lun);
 
 	pqi_check_ctrl_health(ctrl_info);
 	if (pqi_ctrl_offline(ctrl_info))
diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 79916e803b26..cab74d300eca 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -379,7 +379,7 @@ extern const struct attribute_group *snic_host_groups[];
 
 int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
-int snic_device_reset(struct scsi_cmnd *);
+int snic_device_reset(struct scsi_device *);
 int snic_host_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 3722383fb529..8f459c9c407f 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2126,15 +2126,15 @@ snic_unlink_and_release_req(struct snic *snic, struct scsi_cmnd *sc, int flag)
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
index d1f065d4bcce..376e661fd353 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6957,11 +6957,11 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
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
@@ -6969,10 +6969,10 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 578c4b6d0f7d..d69e37943130 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -630,12 +630,12 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
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
@@ -646,9 +646,9 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
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
index fd297c7517cd..1cda6f20ff88 100644
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
index 9de099532f8b..3dd5d62d5433 100644
--- a/drivers/scsi/xen-scsifront.c
+++ b/drivers/scsi/xen-scsifront.c
@@ -592,21 +592,26 @@ static int scsifront_queuecommand(struct Scsi_Host *shost,
  * We have to wait until an answer is returned. This answer contains the
  * result to be returned to the requestor.
  */
-static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
+static int scsifront_action_handler(struct scsi_device *sdev,
+				    struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *host = sc->device->host;
+	struct Scsi_Host *host = sdev->host;
 	struct vscsifrnt_info *info = shost_priv(host);
-	struct vscsifrnt_shadow *shadow, *s = scsi_cmd_priv(sc);
+	struct vscsifrnt_shadow *shadow;
 	int err = 0;
 
 	shadow = kzalloc(sizeof(*shadow), GFP_NOIO);
 	if (!shadow)
 		return FAILED;
 
-	shadow->act = act;
+	shadow->act = sc ? VSCSIIF_ACT_SCSI_ABORT : VSCSIIF_ACT_SCSI_RESET;
 	shadow->rslt_reset = RSLT_RESET_WAITING;
 	shadow->sc = sc;
-	shadow->ref_rqid = s->rqid;
+	if (sc) {
+		struct vscsifrnt_shadow *s = scsi_cmd_priv(sc);
+
+		shadow->ref_rqid = s->rqid;
+	}
 	init_waitqueue_head(&shadow->wq_reset);
 
 	spin_lock_irq(host->host_lock);
@@ -615,7 +620,7 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 		if (scsifront_enter(info))
 			goto fail;
 
-		if (!scsifront_do_request(sc->device, info, shadow))
+		if (!scsifront_do_request(sdev, info, shadow))
 			break;
 
 		scsifront_return(info);
@@ -656,13 +661,13 @@ static int scsifront_action_handler(struct scsi_cmnd *sc, uint8_t act)
 static int scsifront_eh_abort_handler(struct scsi_cmnd *sc)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_ABORT);
+	return scsifront_action_handler(sc->device, sc);
 }
 
-static int scsifront_dev_reset_handler(struct scsi_cmnd *sc)
+static int scsifront_dev_reset_handler(struct scsi_device *sdev)
 {
 	pr_debug("%s\n", __func__);
-	return scsifront_action_handler(sc, VSCSIIF_ACT_SCSI_RESET);
+	return scsifront_action_handler(sdev, NULL);
 }
 
 static int scsifront_sdev_configure(struct scsi_device *sdev)
diff --git a/drivers/staging/rts5208/rtsx.c b/drivers/staging/rts5208/rtsx.c
index 2284a96abcff..1f3b9382f894 100644
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
 
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 28c59218077d..939e83eef2a6 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -334,29 +334,22 @@ static int visorhba_abort_handler(struct scsi_cmnd *scsicmd)
 
 /*
  * visorhba_device_reset_handler - Send TASK_MGMT_LUN_RESET
- * @scsicmd: The scsicmd that needs aborted
+ * @scsidev: The scsidev that needs to reset
  *
  * Return: SUCCESS if inserted, FAILED otherwise
  */
-static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
+static int visorhba_device_reset_handler(struct scsi_device *scsidev)
 {
 	/* issue TASK_MGMT_LUN_RESET */
-	struct scsi_device *scsidev;
 	struct visordisk_info *vdisk;
 	int rtn;
 
-	scsidev = scsicmd->device;
 	vdisk = scsidev->hostdata;
 	if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
 		atomic_inc(&vdisk->error_count);
 	else
 		atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
-	rtn = forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
-	if (rtn == SUCCESS) {
-		scsicmd->result = DID_RESET << 16;
-		scsi_done(scsicmd);
-	}
-	return rtn;
+	return forward_taskmgmt_command(TASK_MGMT_LUN_RESET, scsidev);
 }
 
 /*
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4dabdbf167f6..089e7300a115 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -257,7 +257,7 @@ static int tcm_loop_abort_task(struct scsi_cmnd *sc)
  * Called from SCSI EH process context to issue a LUN_RESET TMR
  * to struct scsi_device
  */
-static int tcm_loop_device_reset(struct scsi_cmnd *sc)
+static int tcm_loop_device_reset(struct scsi_device *sdev)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
@@ -266,10 +266,10 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
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
index 17dabfba6b2b..7a5462e3927f 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -448,9 +448,9 @@ static int command_abort(struct scsi_cmnd *srb)
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
index 84dc270f6f73..95a5abad81da 100644
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
index 31f60d2ad318..d11f024e3f0b 100644
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
index f27fcffa2fd9..205db854b3a4 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -392,7 +392,7 @@ struct iscsi_host {
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
 extern int iscsi_eh_recover_target(struct scsi_target *starget);
 extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
-extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
+extern int iscsi_eh_device_reset(struct scsi_device *sdev);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
 extern enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc);
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index bbc4176d2d37..bf57ff3b2df3 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -730,7 +730,7 @@ void sas_init_dev(struct domain_device *);
 
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
-int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
+int sas_eh_device_reset_handler(struct scsi_device *sdev);
 int sas_eh_target_reset_handler(struct scsi_target *starget);
 
 extern void sas_target_destroy(struct scsi_target *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b4acae42a2ca..2faa11035d7f 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -138,7 +138,7 @@ struct scsi_host_template {
 	 * Status: REQUIRED	(at least one of them)
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
-	int (* eh_device_reset_handler)(struct scsi_cmnd *);
+	int (* eh_device_reset_handler)(struct scsi_device *);
 	int (* eh_target_reset_handler)(struct scsi_target *);
 	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
 	int (* eh_host_reset_handler)(struct Scsi_Host *);
-- 
2.29.2

