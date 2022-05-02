Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51717C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 22:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387795AbiEBWFZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 18:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387796AbiEBWDs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 18:03:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544595FE8
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 15:00:02 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AACB0210EE;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCYU78fc5vnfbFyCZCDND+O/Xsw5qMzwPjbzLuQ4DwU=;
        b=sUxeR723q0GexzbbMdfOuLHpOm8+gXUm5+weE90Jv1My2iObd+5YcQeSiavO9NweMVC7Dt
        e3dvXkTLnEZorsc2+nOva4XoJsz9JAzMiAz/i6im7vunw+BtlymAz5ieMUyAAIMbUU5d50
        Sog68LdOV47B9XBIxxGM+gLBKuEHQX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528800;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KCYU78fc5vnfbFyCZCDND+O/Xsw5qMzwPjbzLuQ4DwU=;
        b=yiAXsC1lEgNqghGaGnIVjdW/NvnkLpox2jTLPSsN+4dTK37XjmKTbSApsUOL/r60sF6FRT
        PZDDwOneHFq3bvCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A3C272C14E;
        Mon,  2 May 2022 22:00:00 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 9FF99519414C; Tue,  3 May 2022 00:00:00 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        James Smart <jsmart2021@gmail.com>
Subject: [PATCH 3/7] scsi: Use scsi_target as argument for eh_target_reset_handler()
Date:   Mon,  2 May 2022 23:59:41 +0200
Message-Id: <20220502215953.5463-7-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215953.5463-1-hare@suse.de>
References: <20220502215953.5463-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The target reset function should only depend on the scsi target,
not the scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: James Smart <jsmart2021@gmail.com>
---
 Documentation/scsi/scsi_eh.rst              | 10 ++++
 Documentation/scsi/scsi_mid_low_api.rst     | 18 +++++++
 drivers/message/fusion/mptsas.c             | 10 +++-
 drivers/message/fusion/mptscsih.c           | 27 ++++------
 drivers/message/fusion/mptscsih.h           |  2 +-
 drivers/message/fusion/mptspi.c             |  8 ++-
 drivers/s390/scsi/zfcp_scsi.c               |  7 ++-
 drivers/scsi/aacraid/linit.c                |  9 ++--
 drivers/scsi/be2iscsi/be_main.c             |  4 +-
 drivers/scsi/bfa/bfad_im.c                  |  5 +-
 drivers/scsi/bnx2fc/bnx2fc.h                |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  4 +-
 drivers/scsi/esas2r/esas2r.h                |  2 +-
 drivers/scsi/esas2r/esas2r_main.c           | 38 +++++++-------
 drivers/scsi/ibmvscsi/ibmvfc.c              |  3 +-
 drivers/scsi/libiscsi.c                     |  4 +-
 drivers/scsi/libsas/sas_scsi_host.c         |  9 ++--
 drivers/scsi/lpfc/lpfc_scsi.c               | 10 ++--
 drivers/scsi/megaraid/megaraid_sas.h        |  3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 10 ++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 56 +++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_os.c             | 40 ++++++---------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 31 +++++-------
 drivers/scsi/pmcraid.c                      |  8 +--
 drivers/scsi/qedf/qedf_main.c               |  3 +-
 drivers/scsi/qla2xxx/qla_os.c               | 26 +++++-----
 drivers/scsi/qla4xxx/ql4_os.c               | 13 ++---
 drivers/scsi/scsi_debug.c                   | 21 +++-----
 drivers/scsi/scsi_error.c                   |  5 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  3 +-
 drivers/target/loopback/tcm_loop.c          |  9 ++--
 include/scsi/libiscsi.h                     |  2 +-
 include/scsi/libsas.h                       |  2 +-
 include/scsi/scsi_host.h                    |  2 +-
 34 files changed, 216 insertions(+), 190 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
index 5e2d04e64005..cfa14ad55dda 100644
--- a/Documentation/scsi/scsi_eh.rst
+++ b/Documentation/scsi/scsi_eh.rst
@@ -214,6 +214,7 @@ considered to fail always.
 
     int (* eh_abort_handler)(struct scsi_cmnd *);
     int (* eh_device_reset_handler)(struct scsi_cmnd *);
+    int (* eh_target_reset_handler)(struct scsi_target *);
     int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
     int (* eh_host_reset_handler)(struct Scsi_Host *);
 
@@ -409,6 +410,15 @@ scmd->allowed.
 	    resetting clears all scmds on the sdev, there is no need
 	    to choose error-completed scmds.
 
+	2. If !list_empty(&eh_work_q), invoke scsi_eh_target_reset().
+
+	``scsi_eh_target_reset``
+
+	    hostt->eh_target_reset_handler() is invoked for each target
+	    with failed scmds.  If bus reset succeeds, all failed
+	    scmds on all ready or offline sdevs on the target are
+	    EH-finished.
+
 	3. If !list_empty(&eh_work_q), invoke scsi_eh_bus_reset()
 
 	``scsi_eh_bus_reset``
diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 1b1c37445580..0afc1b4f89af 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -758,6 +758,24 @@ Details::
 	int eh_bus_reset_handler(struct Scsi_Host * host, int channel)
 
 
+    /**
+    *      eh_target_reset_handler - issue SCSI target reset
+    *      @starget: identifies SCSI target to be reset
+    *
+    *      Returns SUCCESS if command aborted else FAILED
+    *
+    *      Locks: None held
+    *
+    *      Calling context: kernel thread
+    *
+    *      Notes: Invoked from scsi_eh thread. No other commands will be
+    *      queued on current host during eh.
+    *
+    *      Optionally defined in: LLD
+    **/
+	int eh_target_reset_handler(struct scsi_target * starget)
+
+
     /**
     *      eh_device_reset_handler - issue SCSI device reset
     *      @scp: identifies SCSI device to be reset
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 34901bcd1ce8..52f73e29c2d8 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1997,6 +1997,14 @@ static enum blk_eh_timer_return mptsas_eh_timed_out(struct scsi_cmnd *sc)
 }
 
 
+static int mptsas_eh_target_reset(struct scsi_target *starget)
+{
+	struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
+	MPT_ADAPTER *ioc = rphy_to_ioc(rphy);
+
+	return mptscsih_target_reset(ioc->sh, starget);
+}
+
 static struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
@@ -2012,7 +2020,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_timed_out			= mptsas_eh_timed_out,
 	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_target_reset_handler	= mptsas_eh_target_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_SAS_CAN_QUEUE,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index afdbc8138346..af140dbd63d9 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1854,48 +1854,43 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
  *	Returns SUCCESS or FAILED.
  **/
 int
-mptscsih_target_reset(struct scsi_cmnd * SCpnt)
+mptscsih_target_reset(struct Scsi_Host *shost, struct scsi_target * starget)
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
-	VirtDevice	 *vdevice;
+	VirtTarget	 *vtarget;
 	MPT_ADAPTER	*ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
-		printk(KERN_ERR MYNAM ": target reset: "
-		   "Can't locate host! (sc=%p)\n", SCpnt);
+	if ((hd = shost_priv(shost)) == NULL){
+		printk(KERN_ERR MYNAM ": target reset: Can't locate host!\n");
 		return FAILED;
 	}
 
 	ioc = hd->ioc;
-	printk(MYIOC_s_INFO_FMT "attempting target reset! (sc=%p)\n",
-	       ioc->name, SCpnt);
-	scsi_print_command(SCpnt);
-
-	vdevice = SCpnt->device->hostdata;
-	if (!vdevice || !vdevice->vtarget) {
+	printk(MYIOC_s_INFO_FMT "attempting target reset!\n", ioc->name);
+	vtarget = starget->hostdata;
+	if (!vtarget) {
 		retval = 0;
 		goto out;
 	}
 
 	/* Target reset to hidden raid component is not supported
 	 */
-	if (vdevice->vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
+	if (vtarget->tflags & MPT_TARGET_FLAGS_RAID_COMPONENT) {
 		retval = FAILED;
 		goto out;
 	}
 
 	retval = mptscsih_IssueTaskMgmt(hd,
 				MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
-				vdevice->vtarget->channel,
-				vdevice->vtarget->id, 0, 0,
+				vtarget->channel, vtarget->id, 0, 0,
 				mptscsih_get_tm_timeout(ioc));
 
  out:
-	printk (MYIOC_s_INFO_FMT "target reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	printk (MYIOC_s_INFO_FMT "target reset: %s\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
 
 	if (retval == 0)
 		return SUCCESS;
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 9f3756bd25eb..c4eaf3554c7d 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -120,7 +120,7 @@ extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
-extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
+extern int mptscsih_target_reset(struct Scsi_Host *, struct scsi_target *);
 extern int mptscsih_bus_reset(struct Scsi_Host *, int);
 extern int mptscsih_host_reset(struct Scsi_Host *sh);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 388675cc1765..12af128c2894 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -820,6 +820,12 @@ static void mptspi_slave_destroy(struct scsi_device *sdev)
 	mptscsih_slave_destroy(sdev);
 }
 
+static int mptspi_eh_target_reset(struct scsi_target *starget)
+{
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	return mptscsih_target_reset(shost, starget);
+}
+
 static struct scsi_host_template mptspi_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
@@ -834,7 +840,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.slave_destroy			= mptspi_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_target_reset_handler	= mptspi_eh_target_reset,
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 873ccc60e4d6..10bbe56189b3 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -340,9 +340,12 @@ static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 	return zfcp_scsi_task_mgmt_function(sdev, FCP_TMF_LUN_RESET);
 }
 
-static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
+/*
+ * Note: We need to select a LUN as the storage array doesn't
+ * necessarily supports LUN 0 and might refuse the target reset.
+ */
+static int zfcp_scsi_eh_target_reset_handler(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(scpnt->device);
 	struct fc_rport *rport = starget_to_rport(starget);
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct scsi_device *sdev = NULL, *tmp_sdev;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index de7e0985ac2b..a63e03203679 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -962,10 +962,9 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
  *	@scsi_cmd:	SCSI command block causing the reset
  *
  */
-static int aac_eh_target_reset(struct scsi_cmnd *cmd)
+static int aac_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_device * dev = cmd->device;
-	struct Scsi_Host * host = dev->host;
+	struct Scsi_Host * host = dev_to_shost(&starget->dev);
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	struct aac_hba_map_info *info;
 	int count;
@@ -975,8 +974,8 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 	int status;
 	u8 command;
 
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
+	bus = aac_logical_to_phys(starget->channel);
+	cid = starget->id;
 
 	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
 		return FAILED;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 55addd7f5c81..f954c6f869fb 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -370,11 +370,11 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 	return rc;
 }
 
-static int beiscsi_eh_session_reset(struct scsi_cmnd *sc)
+static int beiscsi_eh_session_reset(struct scsi_target *starget)
 {
 	struct iscsi_cls_session *cls_session;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(starget);
 	return iscsi_eh_session_reset(cls_session);
 }
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index a446aa2d6b9a..272dedfee1a7 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -362,11 +362,10 @@ bfad_im_reset_lun_handler(struct scsi_cmnd *cmnd)
  * Scsi_Host template entry, resets the target and abort all commands.
  */
 static int
-bfad_im_reset_target_handler(struct scsi_cmnd *cmnd)
+bfad_im_reset_target_handler(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = cmnd->device->host;
-	struct scsi_target *starget = scsi_target(cmnd->device);
 	struct fc_rport *rport = starget_to_rport(starget);
+	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct bfad_im_port_s *im_port =
 				(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 7e74f77da14f..b3ed22d97572 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -551,7 +551,7 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 void bnx2fc_add_2_sq(struct bnx2fc_rport *tgt, u16 xid);
 void bnx2fc_ring_doorbell(struct bnx2fc_rport *tgt);
 int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd);
-int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd);
+int bnx2fc_eh_target_reset(struct scsi_target *sc_tgt);
 int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd);
 void bnx2fc_rport_event_handler(struct fc_lport *lport,
 				struct fc_rport_priv *rport,
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 055d9424bc0d..0f5218eb9732 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1058,9 +1058,9 @@ int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req)
  * Set from SCSI host template to send task mgmt command to the target
  *	and wait for the response
  */
-int bnx2fc_eh_target_reset(struct scsi_cmnd *sc_cmd)
+int bnx2fc_eh_target_reset(struct scsi_target *sc_tgt)
 {
-	struct fc_rport *rport = starget_to_rport(scsi_target(sc_cmd->device));
+	struct fc_rport *rport = starget_to_rport(sc_tgt);
 	struct fc_lport *lport = shost_priv(rport_to_shost(rport));
 
 	return bnx2fc_initiate_tmf(lport, rport, 0, FCP_TMF_TGT_RESET);
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 5c1eeaffc090..56d8ff63372a 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -978,7 +978,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd);
 int esas2r_device_reset(struct scsi_cmnd *cmd);
 int esas2r_host_reset(struct Scsi_Host *shost);
 int esas2r_bus_reset(struct Scsi_Host *shost, int channel);
-int esas2r_target_reset(struct scsi_cmnd *cmd);
+int esas2r_target_reset(struct scsi_target *starget);
 
 /* Internal functions */
 int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 315b8a61d0d7..1ad39c1ae085 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1101,10 +1101,11 @@ int esas2r_bus_reset(struct Scsi_Host *shost, int channel)
 	return esas2r_host_bus_reset(shost, false);
 }
 
-static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
+static int esas2r_dev_targ_reset(struct Scsi_Host *shost, int id, u64 lun,
+				 bool target_reset)
 {
 	struct esas2r_adapter *a =
-		(struct esas2r_adapter *)cmd->device->host->hostdata;
+		(struct esas2r_adapter *)shost->hostdata;
 	struct esas2r_request *rq;
 	u8 task_management_status = RS_PENDING;
 	bool completed;
@@ -1118,34 +1119,30 @@ static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
 		if (target_reset) {
 			esas2r_log(ESAS2R_LOG_CRIT,
 				   "unable to allocate a request for a "
-				   "target reset (%d)!",
-				   cmd->device->id);
+				   "target reset (%d)!", id);
 		} else {
 			esas2r_log(ESAS2R_LOG_CRIT,
 				   "unable to allocate a request for a "
-				   "device reset (%d:%llu)!",
-				   cmd->device->id,
-				   cmd->device->lun);
+				   "device reset (%d:%llu)!", id, lun);
 		}
 
 
 		return FAILED;
 	}
 
-	rq->target_id = cmd->device->id;
-	rq->vrq->scsi.flags |= cpu_to_le32(cmd->device->lun);
+	rq->target_id = id;
+	rq->vrq->scsi.flags |= cpu_to_le32(lun);
 	rq->req_stat = RS_PENDING;
 
 	rq->comp_cb = complete_task_management_request;
 	rq->task_management_status_ptr = &task_management_status;
 
 	if (target_reset) {
-		esas2r_debug("issuing target reset (%p) to id %d", rq,
-			     cmd->device->id);
+		esas2r_debug("issuing target reset (%p) to id %d", rq, id);
 		completed = esas2r_send_task_mgmt(a, rq, 0x20);
 	} else {
-		esas2r_debug("issuing device reset (%p) to id %d lun %d", rq,
-			     cmd->device->id, cmd->device->lun);
+		esas2r_debug("issuing device reset (%p) to id %d lun %llu", rq,
+			     id, lun);
 		completed = esas2r_send_task_mgmt(a, rq, 0x10);
 	}
 
@@ -1179,17 +1176,22 @@ static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
 
 int esas2r_device_reset(struct scsi_cmnd *cmd)
 {
-	esas2r_log(ESAS2R_LOG_INFO, "device_reset (%p)", cmd);
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+
+	esas2r_log(ESAS2R_LOG_INFO, "device_reset");
 
-	return esas2r_dev_targ_reset(cmd, false);
+	return esas2r_dev_targ_reset(shost, sdev->id, sdev->lun, false);
 
 }
 
-int esas2r_target_reset(struct scsi_cmnd *cmd)
+int esas2r_target_reset(struct scsi_target *starget)
 {
-	esas2r_log(ESAS2R_LOG_INFO, "target_reset (%p)", cmd);
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+
+	esas2r_log(ESAS2R_LOG_INFO, "target_reset");
 
-	return esas2r_dev_targ_reset(cmd, true);
+	return esas2r_dev_targ_reset(shost, starget->id, 0, true);
 }
 
 void esas2r_log_request_failure(struct esas2r_adapter *a,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 5fb36cd70dde..9b9f6a0122e4 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2934,9 +2934,8 @@ static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
  * Returns:
  *	SUCCESS / FAST_IO_FAIL / FAILED
  **/
-static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
+static int ibmvfc_eh_target_reset_handler(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(cmd->device);
 	struct fc_rport *rport = starget_to_rport(starget);
 	struct Scsi_Host *shost = rport_to_shost(rport);
 	struct ibmvfc_host *vhost = shost_priv(shost);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 30f7737928bb..ac3708b65938 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2637,12 +2637,12 @@ static int iscsi_eh_target_reset(struct iscsi_cls_session *cls_session)
  * This will attempt to send a warm target reset. If that fails,
  * we will escalate to ERL0 session recovery.
  */
-int iscsi_eh_recover_target(struct scsi_cmnd *sc)
+int iscsi_eh_recover_target(struct scsi_target *starget)
 {
 	struct iscsi_cls_session *cls_session;
 	int rc;
 
-	cls_session = starget_to_session(scsi_target(sc->device));
+	cls_session = starget_to_session(starget);
 	rc = iscsi_eh_target_reset(cls_session);
 	if (rc == FAILED)
 		rc = iscsi_eh_session_reset(cls_session);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9c82e5dc4fcc..ae7e093eff4b 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -514,11 +514,12 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 }
 EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
 
-int sas_eh_target_reset_handler(struct scsi_cmnd *cmd)
+int sas_eh_target_reset_handler(struct scsi_target *starget)
 {
 	int res;
-	struct Scsi_Host *host = cmd->device->host;
-	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct domain_device *dev = starget_to_domain_dev(starget);
+	struct sas_rphy *rphy = dev->rphy;
+	struct Scsi_Host *host = dev_to_shost(rphy->dev.parent);
 	struct sas_internal *i = to_sas_internal(host->transportt);
 
 	if (current != host->ehandler)
@@ -551,7 +552,7 @@ static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 
 try_target_reset:
 	if (shost->hostt->eh_target_reset_handler)
-		return shost->hostt->eh_target_reset_handler(cmd);
+		return shost->hostt->eh_target_reset_handler(scsi_target(cmd->device));
 
 	return FAILED;
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0443846c9fad..834c3f31f327 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6376,15 +6376,15 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
  *  0x2002 - Success
  **/
 static int
-lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
+lpfc_target_reset_handler(struct scsi_target *starget)
 {
-	struct Scsi_Host  *shost = cmnd->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
+	struct fc_rport *rport = starget_to_rport(starget);
+	struct Scsi_Host  *shost = rport_to_shost(rport);
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
-	unsigned tgt_id = cmnd->device->id;
-	uint64_t lun_id = cmnd->device->lun;
+	unsigned tgt_id = starget->id;
+	uint64_t lun_id = 0;
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
 	u32 logit = LOG_FCP;
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 4919ea54b827..85f5ebc6c69f 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2723,7 +2723,8 @@ void megasas_setup_jbod_map(struct megasas_instance *instance);
 void megasas_update_sdev_properties(struct scsi_device *sdev);
 int megasas_reset_fusion(struct Scsi_Host *shost, int reason);
 int megasas_task_abort_fusion(struct scsi_cmnd *scmd);
-int megasas_reset_target_fusion(struct scsi_cmnd *scmd);
+int megasas_reset_target_fusion(struct Scsi_Host *shost,
+				struct scsi_target *starget);
 u32 mega_mod64(u64 dividend, u32 divisor);
 int megasas_alloc_fusion_context(struct megasas_instance *instance);
 void megasas_free_fusion_context(struct megasas_instance *instance);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0222e234f108..79ab96aa3044 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3111,17 +3111,19 @@ static int megasas_task_abort(struct scsi_cmnd *scmd)
  *                        (supported only for fusion adapters)
  * @scmd:                 SCSI command pointer
  */
-static int megasas_reset_target(struct scsi_cmnd *scmd)
+static int megasas_reset_target(struct scsi_target *starget)
 {
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret;
 	struct megasas_instance *instance;
 
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = (struct megasas_instance *)shost->hostdata;
 
 	if (instance->adapter_type != MFI_SERIES)
-		ret = megasas_reset_target_fusion(scmd);
+		ret = megasas_reset_target_fusion(shost, starget);
 	else {
-		sdev_printk(KERN_NOTICE, scmd->device, "TARGET RESET not supported\n");
+		starget_printk(KERN_NOTICE, starget,
+			       "TARGET RESET not supported\n");
 		ret = FAILED;
 	}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 54fde2661952..427312b542cb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4801,21 +4801,25 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 
 /*
  * megasas_reset_target_fusion : target reset function for fusion adapters
- * scmd: SCSI command pointer
+ * shost: SCSI host pointer
+ * starget: SCSI target pointer
  *
  * Returns SUCCESS if all commands associated with target aborted else FAILED
  */
 
-int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
+int megasas_reset_target_fusion(struct Scsi_Host *shost,
+				struct scsi_target *starget)
 {
 
 	struct megasas_instance *instance;
+	struct scsi_device *sdev;
 	int ret = FAILED;
-	u16 devhandle;
-	struct MR_PRIV_DEVICE *mr_device_priv_data;
-	mr_device_priv_data = scmd->device->hostdata;
+	u16 devhandle = USHRT_MAX;
+	struct MR_PRIV_DEVICE *mr_device_priv_data = NULL;
 
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = (struct megasas_instance *)shost->hostdata;
+	starget_printk(KERN_INFO, starget,
+		    "target reset called\n");
 
 	if (atomic_read(&instance->adprecovery) != MEGASAS_HBA_OPERATIONAL) {
 		dev_err(&instance->pdev->dev, "Controller is not OPERATIONAL,"
@@ -4824,44 +4828,52 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 		return ret;
 	}
 
+	shost_for_each_device(sdev, shost) {
+		if (!sdev->hostdata)
+			continue;
+		mr_device_priv_data = sdev->hostdata;
+		if (mr_device_priv_data->is_tm_capable) {
+			devhandle = megasas_get_tm_devhandle(sdev);
+			break;
+		}
+	}
+
 	if (!mr_device_priv_data) {
-		sdev_printk(KERN_INFO, scmd->device,
-			    "device been deleted! scmd: (0x%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
+		starget_printk(KERN_INFO, starget,
+			    "all devices have been deleted\n");
 		ret = SUCCESS;
 		goto out;
 	}
 
 	if (!mr_device_priv_data->is_tm_capable) {
+		ret = SUCCESS;
+		goto out;
+	} else if (!mr_device_priv_data->is_tm_capable) {
 		ret = FAILED;
 		goto out;
 	}
 
 	mutex_lock(&instance->reset_mutex);
-	devhandle = megasas_get_tm_devhandle(scmd->device);
-
-	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
-		sdev_printk(KERN_INFO, scmd->device,
+	if (devhandle == USHRT_MAX) {
+		starget_printk(KERN_INFO, starget,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
-		goto out;
+		return SUCCESS;
 	}
 
-	sdev_printk(KERN_INFO, scmd->device,
-		"attempting target reset! scmd(0x%p) tm_dev_handle: 0x%x\n",
-		scmd, devhandle);
+	starget_printk(KERN_INFO, starget,
+		"attempting target reset! tm_dev_handle: 0x%x\n",
+		devhandle);
 	mr_device_priv_data->tm_busy = true;
 	ret = megasas_issue_tm(instance, devhandle,
-			scmd->device->channel, scmd->device->id, 0,
+			starget->channel, starget->id, 0,
 			MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 			mr_device_priv_data);
 	mr_device_priv_data->tm_busy = false;
 	mutex_unlock(&instance->reset_mutex);
-	scmd_printk(KERN_NOTICE, scmd, "target reset %s!!\n",
-		(ret == SUCCESS) ? "SUCCESS" : "FAILED");
-
 out:
+	starget_printk(KERN_NOTICE, starget, "target reset %s!!\n",
+		(ret == SUCCESS) ? "SUCCESS" : "FAILED");
 	return ret;
 }
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 88fbd01c05d0..2c4a2f31be76 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3407,7 +3407,7 @@ static int mpi3mr_eh_bus_reset(struct Scsi_Host *shost, int channel)
 
 /**
  * mpi3mr_eh_target_reset - Target reset error handling callback
- * @scmd: SCSI command reference
+ * @starget: SCSI target reference
  *
  * Issue Target reset Task Management and verify the scmd is
  * terminated successfully and return status accordingly.
@@ -3415,50 +3415,42 @@ static int mpi3mr_eh_bus_reset(struct Scsi_Host *shost, int channel)
  * Return: SUCCESS of successful termination of the scmd else
  *         FAILED
  */
-static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
+static int mpi3mr_eh_target_reset(struct scsi_target *starget)
 {
-	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
 	struct mpi3mr_stgt_priv_data *stgt_priv_data;
-	struct mpi3mr_sdev_priv_data *sdev_priv_data;
 	u16 dev_handle;
 	u8 resp_code = 0;
 	int retval = FAILED, ret = 0;
 
-	sdev_printk(KERN_INFO, scmd->device,
-	    "Attempting Target Reset! scmd(%p)\n", scmd);
-	scsi_print_command(scmd);
+	starget_printk(KERN_INFO, starget,
+	    "Attempting Target Reset!\n");
 
-	sdev_priv_data = scmd->device->hostdata;
-	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
-		sdev_printk(KERN_INFO, scmd->device,
-		    "SCSI device is not available\n");
-		retval = SUCCESS;
-		goto out;
-	}
-
-	stgt_priv_data = sdev_priv_data->tgt_priv_data;
+	stgt_priv_data = (struct mpi3mr_stgt_priv_data *)
+		starget->hostdata;
 	dev_handle = stgt_priv_data->dev_handle;
 	if (stgt_priv_data->dev_removed) {
-		sdev_printk(KERN_INFO, scmd->device,
+		starget_printk(KERN_INFO, starget,
 		    "%s:target(handle = 0x%04x) is removed, target reset is not issued\n",
 		    mrioc->name, dev_handle);
 		retval = FAILED;
 		goto out;
 	}
-	sdev_printk(KERN_INFO, scmd->device,
+	starget_printk(KERN_INFO, starget,
 	    "Target Reset is issued to handle(0x%04x)\n",
 	    dev_handle);
 
 	ret = mpi3mr_issue_tm(mrioc,
 	    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET, dev_handle,
-	    sdev_priv_data->lun_id, MPI3MR_HOSTTAG_BLK_TMS,
-	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, scmd);
+	    /* lun */ 0, MPI3MR_HOSTTAG_BLK_TMS,
+	    MPI3MR_RESETTM_TIMEOUT, &mrioc->host_tm_cmds, &resp_code, NULL);
 
 	if (ret)
 		goto out;
 
 	if (stgt_priv_data->pend_count) {
-		sdev_printk(KERN_INFO, scmd->device,
+		starget_printk(KERN_INFO, starget,
 		    "%s: target has %d pending commands, target reset is failed\n",
 		    mrioc->name, stgt_priv_data->pend_count);
 		goto out;
@@ -3466,9 +3458,9 @@ static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
 
 	retval = SUCCESS;
 out:
-	sdev_printk(KERN_INFO, scmd->device,
-	    "%s: target reset is %s for scmd(%p)\n", mrioc->name,
-	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	starget_printk(KERN_INFO, starget,
+	    "%s: target reset is %s\n", mrioc->name,
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	return retval;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ea9a8799f89a..4c84fd9774ab 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3447,47 +3447,40 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
  * Return: SUCCESS if command aborted else FAILED
  */
 static int
-scsih_target_reset(struct scsi_cmnd *scmd)
+scsih_target_reset(struct scsi_target *starget)
 {
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
-	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	struct _sas_device *sas_device = NULL;
 	struct _pcie_device *pcie_device = NULL;
 	u16	handle;
 	u8	tr_method = 0;
 	u8	tr_timeout = 30;
 	int r;
-	struct scsi_target *starget = scmd->device->sdev_target;
 	struct MPT3SAS_TARGET *target_priv_data = starget->hostdata;
 
 	starget_printk(KERN_INFO, starget,
-	    "attempting target reset! scmd(0x%p)\n", scmd);
-	_scsih_tm_display_info(ioc, scmd);
+	    "attempting target reset!\n");
 
-	sas_device_priv_data = scmd->device->hostdata;
-	if (!sas_device_priv_data || !sas_device_priv_data->sas_target ||
-	    ioc->remove_host) {
+	if (!target_priv_data || ioc->remove_host) {
 		starget_printk(KERN_INFO, starget,
-		    "target been deleted! scmd(0x%p)\n", scmd);
-		scmd->result = DID_NO_CONNECT << 16;
-		scsi_done(scmd);
+		    "target been deleted!\n");
 		r = SUCCESS;
 		goto out;
 	}
 
 	/* for hidden raid components obtain the volume_handle */
 	handle = 0;
-	if (sas_device_priv_data->sas_target->flags &
+	if (target_priv_data->flags &
 	    MPT_TARGET_FLAGS_RAID_COMPONENT) {
 		sas_device = mpt3sas_get_sdev_from_target(ioc,
 				target_priv_data);
 		if (sas_device)
 			handle = sas_device->volume_handle;
 	} else
-		handle = sas_device_priv_data->sas_target->handle;
+		handle = target_priv_data->handle;
 
 	if (!handle) {
-		scmd->result = DID_RESET << 16;
 		r = FAILED;
 		goto out;
 	}
@@ -3500,16 +3493,16 @@ scsih_target_reset(struct scsi_cmnd *scmd)
 		tr_method = MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE;
 	} else
 		tr_method = MPI2_SCSITASKMGMT_MSGFLAGS_LINK_RESET;
-	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, scmd->device->channel,
-		scmd->device->id, 0,
+	r = mpt3sas_scsih_issue_locked_tm(ioc, handle, starget->channel,
+		starget->id, 0,
 		MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET, 0, 0,
 	    tr_timeout, tr_method);
 	/* Check for busy commands after reset */
 	if (r == SUCCESS && atomic_read(&starget->target_busy))
 		r = FAILED;
  out:
-	starget_printk(KERN_INFO, starget, "target reset: %s scmd(0x%p)\n",
-	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	starget_printk(KERN_INFO, starget, "target reset: %s\n",
+	    ((r == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	if (sas_device)
 		sas_device_put(sas_device);
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 14e90807d38c..44ff1f7fbbc0 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3061,14 +3061,14 @@ static int pmcraid_eh_bus_reset_handler(struct Scsi_Host *host, int channel)
 				    RESET_DEVICE_BUS);
 }
 
-static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
+static int pmcraid_eh_target_reset_handler(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = scmd->device->host;
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct scsi_device *scsi_dev = NULL, *tmp;
 
 	shost_for_each_device(tmp, shost) {
-		if ((tmp->channel == scmd->device->channel) &&
-		    (tmp->id == scmd->device->id)) {
+		if ((tmp->channel == starget->channel) &&
+		    (tmp->id == starget->id)) {
 			scsi_dev = tmp;
 			break;
 		}
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index c12fb3465946..c90a2c449978 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -855,9 +855,8 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	return rc;
 }
 
-static int qedf_eh_target_reset(struct scsi_cmnd *sc_cmd)
+static int qedf_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(sc_cmd->device);
 	struct fc_rport *rport = starget_to_rport(starget);
 
 	QEDF_ERR(NULL, "TARGET RESET Issued...");
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 11e7dc22b94d..35cf2c3dbe01 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1463,10 +1463,9 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
 }
 
 static int
-qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_device *sdev = cmd->device;
-	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct fc_rport *rport = starget_to_rport(starget);
 	scsi_qla_host_t *vha = shost_priv(rport_to_shost(rport));
 	struct qla_hw_data *ha = vha->hw;
 	fc_port_t *fcport = *(fc_port_t **)rport->dd_data;
@@ -1491,40 +1490,39 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		return SUCCESS;
 
 	ql_log(ql_log_info, vha, 0x8009,
-	    "TARGET RESET ISSUED nexus=%ld:%d cmd=%p.\n", vha->host_no,
-	    sdev->id, cmd);
+	    "TARGET RESET ISSUED nexus=%ld:%d.\n", vha->host_no,
+	    starget->id);
 
 	err = 0;
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800a,
-		    "Wait for hba online failed for cmd=%p.\n", cmd);
+		    "Wait for hba online failed.\n");
 		goto eh_reset_failed;
 	}
 	err = 2;
 	if (ha->isp_ops->target_reset(fcport, 0, 0) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800c,
-		    "target_reset failed for cmd=%p.\n", cmd);
+		    "target_reset failed.\n");
 		goto eh_reset_failed;
 	}
 	err = 3;
-	if (qla2x00_eh_wait_for_pending_commands(vha, sdev->id,
+	if (qla2x00_eh_wait_for_pending_commands(vha, starget->id,
 	    0, WAIT_TARGET) != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x800d,
-		    "wait for pending cmds failed for cmd=%p.\n", cmd);
+		    "wait for pending cmds failed.\n");
 		goto eh_reset_failed;
 	}
 
 	ql_log(ql_log_info, vha, 0x800e,
-	    "TARGET RESET SUCCEEDED nexus:%ld:%d cmd=%p.\n",
-	    vha->host_no, sdev->id, cmd);
+	    "TARGET RESET SUCCEEDED nexus:%ld:%d.\n",
+	    vha->host_no, starget->id);
 
 	return SUCCESS;
 
 eh_reset_failed:
 	ql_log(ql_log_info, vha, 0x800f,
-	    "TARGET RESET FAILED: %s nexus=%ld:%d:%llu cmd=%p.\n",
-	    reset_errors[err], vha->host_no, cmd->device->id, cmd->device->lun,
-	    cmd);
+	    "TARGET RESET FAILED: %s nexus=%ld:%d.\n",
+	    reset_errors[err], vha->host_no, starget->id);
 	vha->reset_cmd_err_cnt++;
 	return FAILED;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 8f89080e2580..90828d4eb26d 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -158,7 +158,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host *shost, char *buf, int len);
 static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
-static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_target_reset(struct scsi_target *starget);
 static int qla4xxx_eh_host_reset(struct Scsi_Host *shost);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static umode_t qla4_attr_is_visible(int param_type, int param);
@@ -9332,9 +9332,8 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
  *
  * This routine is called by the Linux OS to reset the target.
  **/
-static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
+static int qla4xxx_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(cmd->device);
 	struct iscsi_cls_session *cls_session = starget_to_session(starget);
 	struct iscsi_session *sess;
 	struct scsi_qla_host *ha;
@@ -9356,10 +9355,8 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		       "WARM TARGET RESET ISSUED.\n");
 
 	DEBUG2(printk(KERN_INFO
-		      "scsi%ld: TARGET_DEVICE_RESET cmd=%p jiffies = 0x%lx, "
-		      "to=%x,dpc_flags=%lx, status=%x allowed=%d\n",
-		      ha->host_no, cmd, jiffies, scsi_cmd_to_rq(cmd)->timeout / HZ,
-		      ha->dpc_flags, cmd->result, cmd->allowed));
+		      "scsi%ld: TARGET_DEVICE_RESET dpc_flags=%lx\n",
+		      ha->host_no, ha->dpc_flags));
 
 	rval = qla4xxx_isp_check_reg(ha);
 	if (rval != QLA_SUCCESS) {
@@ -9382,7 +9379,7 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 	}
 
 	/* Send marker. */
-	if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun,
+	if (qla4xxx_send_marker_iocb(ha, ddb_entry, 0,
 		MM_TGT_WARM_RESET) != QLA_SUCCESS) {
 		starget_printk(KERN_INFO, starget,
 			       "WARM TARGET DEVICE RESET FAILED - "
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f2d3271bc80b..2e9daf8c7e83 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5288,39 +5288,30 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
+static int scsi_debug_target_reset(struct scsi_target *starget)
 {
+	struct Scsi_Host *hp = dev_to_shost(&starget->dev);
 	struct sdebug_host_info *sdbg_host;
 	struct sdebug_dev_info *devip;
-	struct scsi_device *sdp;
-	struct Scsi_Host *hp;
 	int k = 0;
 
 	++num_target_resets;
-	if (!SCpnt)
-		goto lie;
-	sdp = SCpnt->device;
-	if (!sdp)
-		goto lie;
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
-	hp = sdp->host;
-	if (!hp)
-		goto lie;
+		starget_printk(KERN_INFO, starget, "%s\n", __func__);
 	sdbg_host = *(struct sdebug_host_info **)shost_priv(hp);
 	if (sdbg_host) {
 		list_for_each_entry(devip,
 				    &sdbg_host->dev_info_list,
 				    dev_list)
-			if (devip->target == sdp->id) {
+			if (devip->target == starget->id) {
 				set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
 				++k;
 			}
 	}
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp,
+		starget_printk(KERN_INFO, starget,
 			    "%s: %d device(s) found in target\n", __func__, k);
-lie:
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 148cab3e61c0..3ee4393a1f1e 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -906,14 +906,15 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
 	struct scsi_host_template *hostt = host->hostt;
+	struct scsi_target *starget = scsi_target(scmd->device);
 
 	if (!hostt->eh_target_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_target_reset_handler(scmd);
+	rtn = hostt->eh_target_reset_handler(starget);
 	if (rtn == SUCCESS) {
 		spin_lock_irqsave(host->host_lock, flags);
-		__starget_for_each_device(scsi_target(scmd->device), NULL,
+		__starget_for_each_device(starget, NULL,
 					  __scsi_report_device_reset);
 		spin_unlock_irqrestore(host->host_lock, flags);
 	}
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index aef828731995..6290f69faa47 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -619,9 +619,8 @@ static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 	return sts ? SCSI_FAILED : SCSI_SUCCESS;
 }
 
-static int sym53c8xx_eh_target_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_target_reset_handler(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(cmd->device);
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4407b56aa6d1..4dabdbf167f6 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -274,23 +274,24 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
 	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
 }
 
-static int tcm_loop_target_reset(struct scsi_cmnd *sc)
+static int tcm_loop_target_reset(struct scsi_target *starget)
 {
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_tpg *tl_tpg;
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 
 	/*
 	 * Locate the tcm_loop_hba_t pointer
 	 */
-	tl_hba = *(struct tcm_loop_hba **)shost_priv(sc->device->host);
+	tl_hba = *(struct tcm_loop_hba **)shost_priv(shost);
 	if (!tl_hba) {
 		pr_err("Unable to perform device reset without active I_T Nexus\n");
 		return FAILED;
 	}
 	/*
-	 * Locate the tl_tpg pointer from TargetID in sc->device->id
+	 * Locate the tl_tpg pointer from TargetID in starget->id
 	 */
-	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
+	tl_tpg = &tl_hba->tl_hba_tpgs[starget->id];
 	if (tl_tpg) {
 		tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
 		return SUCCESS;
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index ce8d5b5dc0d3..f27fcffa2fd9 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -390,7 +390,7 @@ struct iscsi_host {
  * scsi host template
  */
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
-extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
+extern int iscsi_eh_recover_target(struct scsi_target *starget);
 extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ff04eb6d250b..bbc4176d2d37 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -731,7 +731,7 @@ void sas_init_dev(struct domain_device *);
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
-int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
+int sas_eh_target_reset_handler(struct scsi_target *starget);
 
 extern void sas_target_destroy(struct scsi_target *);
 extern int sas_slave_alloc(struct scsi_device *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 73c9971e7334..b4acae42a2ca 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -139,7 +139,7 @@ struct scsi_host_template {
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
-	int (* eh_target_reset_handler)(struct scsi_cmnd *);
+	int (* eh_target_reset_handler)(struct scsi_target *);
 	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
 	int (* eh_host_reset_handler)(struct Scsi_Host *);
 
-- 
2.29.2

