Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89B2C00A8F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 09:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbjJWJ3M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 05:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbjJWJ2x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 05:28:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4126BC
        for <linux-scsi@vger.kernel.org>; Mon, 23 Oct 2023 02:28:44 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1599E1FE14;
        Mon, 23 Oct 2023 09:28:43 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B5FA92CF54;
        Mon, 23 Oct 2023 09:28:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E2DE751EC348; Mon, 23 Oct 2023 11:28:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 03/10] scsi: Use scsi_target as argument for eh_target_reset_handler()
Date:   Mon, 23 Oct 2023 11:28:30 +0200
Message-Id: <20231023092837.33786-4-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231023092837.33786-1-hare@suse.de>
References: <20231023092837.33786-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [2.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         NEURAL_HAM_LONG(-3.00)[-1.000];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[6];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: 1599E1FE14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The target reset function should only depend on the scsi target,
not the scsi command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/scsi/scsi_eh.rst              |  9 ++++
 Documentation/scsi/scsi_mid_low_api.rst     | 18 +++++++
 drivers/message/fusion/mptsas.c             | 10 +++-
 drivers/message/fusion/mptscsih.c           | 38 +++++---------
 drivers/message/fusion/mptscsih.h           |  2 +-
 drivers/message/fusion/mptspi.c             |  8 ++-
 drivers/s390/scsi/zfcp_scsi.c               |  7 ++-
 drivers/scsi/aacraid/linit.c                | 11 ++---
 drivers/scsi/be2iscsi/be_main.c             |  4 +-
 drivers/scsi/bfa/bfad_im.c                  |  5 +-
 drivers/scsi/bnx2fc/bnx2fc.h                |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c             |  6 +--
 drivers/scsi/esas2r/esas2r.h                |  2 +-
 drivers/scsi/esas2r/esas2r_main.c           | 39 ++++++++-------
 drivers/scsi/ibmvscsi/ibmvfc.c              |  5 +-
 drivers/scsi/libiscsi.c                     |  6 +--
 drivers/scsi/libsas/sas_scsi_host.c         |  9 ++--
 drivers/scsi/lpfc/lpfc_scsi.c               | 12 ++---
 drivers/scsi/megaraid/megaraid_sas.h        |  3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 14 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 55 +++++++++++++--------
 drivers/scsi/mpi3mr/mpi3mr_os.c             | 45 ++++++-----------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 35 ++++++-------
 drivers/scsi/pmcraid.c                      |  8 +--
 drivers/scsi/qedf/qedf_main.c               |  3 +-
 drivers/scsi/qla2xxx/qla_os.c               | 24 +++++----
 drivers/scsi/qla4xxx/ql4_os.c               | 15 +++---
 drivers/scsi/scsi_debug.c                   | 23 ++++-----
 drivers/scsi/scsi_error.c                   | 11 +++--
 drivers/scsi/sym53c8xx_2/sym_glue.c         |  3 +-
 drivers/target/loopback/tcm_loop.c          |  9 ++--
 include/scsi/libiscsi.h                     |  2 +-
 include/scsi/libsas.h                       |  2 +-
 include/scsi/scsi_host.h                    |  2 +-
 34 files changed, 232 insertions(+), 215 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
index 553aff3062d5..cfaf841317ed 100644
--- a/Documentation/scsi/scsi_eh.rst
+++ b/Documentation/scsi/scsi_eh.rst
@@ -216,6 +216,7 @@ considered to fail always.
 
     int (* eh_abort_handler)(struct scsi_cmnd *);
     int (* eh_device_reset_handler)(struct scsi_cmnd *);
+    int (* eh_target_reset_handler)(struct scsi_target *);
     int (* eh_bus_reset_handler)(struct Scsi_Host *, unsigned int);
     int (* eh_host_reset_handler)(struct Scsi_Host *);
 
@@ -411,6 +412,14 @@ scmd->allowed.
 	    resetting clears all scmds on the sdev, there is no need
 	    to choose error-completed scmds.
 
+	2. If !list_empty(&eh_work_q), invoke scsi_eh_target_reset().
+
+	``scsi_eh_target_reset``
+
+	    hostt->eh_target_reset_handler() is invoked for each target.
+	    If target reset succeeds, all failed scmds on all ready or
+	    offline sdevs on the target are EH-finished.
+
 	3. If !list_empty(&eh_work_q), invoke scsi_eh_bus_reset()
 
 	``scsi_eh_bus_reset``
diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 43083efc554b..8a075da5641b 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -758,6 +758,24 @@ Details::
 	int eh_bus_reset_handler(struct Scsi_Host * host, unsigned int channel)
 
 
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
index 300f8e955a53..a9d274cabb37 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1997,6 +1997,14 @@ static enum scsi_timeout_action mptsas_eh_timed_out(struct scsi_cmnd *sc)
 }
 
 
+static int mptsas_eh_target_reset(struct scsi_target *starget)
+{
+	struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
+	MPT_ADAPTER *ioc = rphy_to_ioc(rphy);
+
+	return mptscsih_target_reset(ioc->sh, starget);
+}
+
 static const struct scsi_host_template mptsas_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptsas",
@@ -2012,7 +2020,7 @@ static const struct scsi_host_template mptsas_driver_template = {
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_timed_out			= mptsas_eh_timed_out,
 	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_target_reset_handler	= mptsas_eh_target_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
 	.can_queue			= MPT_SAS_CAN_QUEUE,
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 20d582b01b59..ebab55162b54 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1846,55 +1846,43 @@ mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_target_reset - Perform a SCSI TARGET_RESET!
- *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
+ *	@shost: Pointer to scsi_host structure
+ *	@starget: Pointer to scsi_target structure which reset is due to
  *
  *	(linux scsi_host_template.eh_target_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  **/
 int
-mptscsih_target_reset(struct scsi_cmnd * SCpnt)
+mptscsih_target_reset(struct Scsi_Host *shost, struct scsi_target * starget)
 {
-	MPT_SCSI_HOST	*hd;
+	MPT_SCSI_HOST	*hd = shost_priv(shost);
 	int		 retval;
-	VirtDevice	 *vdevice;
-	MPT_ADAPTER	*ioc;
-
-	/* If we can't locate our host adapter structure, return FAILED status.
-	 */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
-		printk(KERN_ERR MYNAM ": target reset: "
-		   "Can't locate host! (sc=%p)\n", SCpnt);
-		return FAILED;
-	}
-
-	ioc = hd->ioc;
-	printk(MYIOC_s_INFO_FMT "attempting target reset! (sc=%p)\n",
-	       ioc->name, SCpnt);
-	scsi_print_command(SCpnt);
+	VirtTarget	 *vtarget;
+	MPT_ADAPTER	*ioc = hd->ioc;
 
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
index 4610fe6e64ef..d1887e3e8336 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -120,7 +120,7 @@ extern void mptscsih_slave_destroy(struct scsi_device *device);
 extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
-extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
+extern int mptscsih_target_reset(struct Scsi_Host *, struct scsi_target *);
 extern int mptscsih_bus_reset(struct Scsi_Host *, unsigned int);
 extern int mptscsih_host_reset(struct Scsi_Host *sh);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 6c5920db1e9d..d379dea7074c 100644
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
 static const struct scsi_host_template mptspi_driver_template = {
 	.module				= THIS_MODULE,
 	.proc_name			= "mptspi",
@@ -834,7 +840,7 @@ static const struct scsi_host_template mptspi_driver_template = {
 	.slave_destroy			= mptspi_slave_destroy,
 	.change_queue_depth 		= mptscsih_change_queue_depth,
 	.eh_abort_handler		= mptscsih_abort,
-	.eh_device_reset_handler	= mptscsih_dev_reset,
+	.eh_target_reset_handler	= mptspi_eh_target_reset,
 	.eh_bus_reset_handler		= mptscsih_bus_reset,
 	.eh_host_reset_handler		= mptscsih_host_reset,
 	.bios_param			= mptscsih_bios_param,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 76c136d39bf1..5c9a7c9f9a98 100644
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
index 22e431517389..b1b6aca54da6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -968,13 +968,12 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 
 /*
  *	aac_eh_target_reset	- Target reset command handling
- *	@scsi_cmd:	SCSI command block causing the reset
+ *	@starget:	SCSI target to be reset
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
@@ -984,8 +983,8 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 	int status;
 	u8 command;
 
-	bus = aac_logical_to_phys(scmd_channel(cmd));
-	cid = scmd_id(cmd);
+	bus = aac_logical_to_phys(starget->channel);
+	cid = starget->id;
 
 	if (bus >= AAC_MAX_BUSES || cid >= AAC_MAX_TARGETS)
 		return FAILED;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 441ad2ebc5d5..399fbb452740 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -385,11 +385,11 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
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
index ef352fc59458..87603f9f79db 100644
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
index 33057908f147..f07a667de37f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1051,14 +1051,14 @@ int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req)
 /**
  * bnx2fc_eh_target_reset: Reset a target
  *
- * @sc_cmd:	SCSI command
+ * @sc_tgt:	SCSI target
  *
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
index 9293a69edc08..c834f2f27ac9 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -978,7 +978,7 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd);
 int esas2r_device_reset(struct scsi_cmnd *cmd);
 int esas2r_host_reset(struct Scsi_Host *shost);
 int esas2r_bus_reset(struct Scsi_Host *shost, unsigned int channel);
-int esas2r_target_reset(struct scsi_cmnd *cmd);
+int esas2r_target_reset(struct scsi_target *starget);
 
 /* Internal functions */
 int esas2r_init_adapter(struct Scsi_Host *host, struct pci_dev *pcid,
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 6c436f75ff88..ef2e43c2803a 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1103,10 +1103,10 @@ int esas2r_bus_reset(struct Scsi_Host *shost, unsigned int channel)
 	return esas2r_host_bus_reset(shost, false);
 }
 
-static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
+static int esas2r_dev_targ_reset(struct Scsi_Host *shost, int id, u64 lun,
+				 bool target_reset)
 {
-	struct esas2r_adapter *a =
-		(struct esas2r_adapter *)cmd->device->host->hostdata;
+	struct esas2r_adapter *a = shost_priv(shost);
 	struct esas2r_request *rq;
 	u8 task_management_status = RS_PENDING;
 	bool completed;
@@ -1120,34 +1120,30 @@ static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
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
 
@@ -1181,17 +1177,22 @@ static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
 
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
index 048a0958766f..cad1ea954fad 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2997,14 +2997,13 @@ static void ibmvfc_dev_cancel_all_noreset(struct scsi_device *sdev, void *data)
 
 /**
  * ibmvfc_eh_target_reset_handler - Reset the target
- * @cmd:	scsi command struct
+ * @starget:	scsi target struct
  *
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
index 3b9e1c35936e..3afa0cc067ce 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2738,17 +2738,17 @@ static int iscsi_eh_target_reset(struct iscsi_cls_session *cls_session)
 
 /**
  * iscsi_eh_recover_target - reset target and possibly the session
- * @sc: scsi command
+ * @starget: scsi target
  *
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
index 9047cfcd1072..3fa0c55a2234 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -478,11 +478,12 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
@@ -515,7 +516,7 @@ static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 
 try_target_reset:
 	if (shost->hostt->eh_target_reset_handler)
-		return shost->hostt->eh_target_reset_handler(cmd);
+		return shost->hostt->eh_target_reset_handler(scsi_target(cmd->device));
 
 	return FAILED;
 }
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 98aa17a6448a..244b7a6f8616 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6035,7 +6035,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 
 /**
  * lpfc_target_reset_handler - scsi_host_template eh_target_reset entry point
- * @cmnd: Pointer to scsi_cmnd data structure.
+ * @starget: Pointer to scsi_target data structure.
  *
  * This routine does a target reset by sending a TARGET_RESET task management
  * command.
@@ -6045,15 +6045,15 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
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
index 56624cbf7fa5..29fc5f22af63 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2725,7 +2725,8 @@ void megasas_setup_jbod_map(struct megasas_instance *instance);
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
index cdd56144c841..75de40af2521 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3104,19 +3104,19 @@ static int megasas_task_abort(struct scsi_cmnd *scmd)
 /**
  * megasas_reset_target:  Issues target reset request to firmware
  *                        (supported only for fusion adapters)
- * @scmd:                 SCSI command pointer
+ * @starget:              SCSI target
  */
-static int megasas_reset_target(struct scsi_cmnd *scmd)
+static int megasas_reset_target(struct scsi_target *starget)
 {
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	int ret;
-	struct megasas_instance *instance;
-
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	struct megasas_instance *instance = shost_priv(shost);
 
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
index c60014e07b44..bee950f11576 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4804,21 +4804,25 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 
 /*
  * megasas_reset_target_fusion : target reset function for fusion adapters
- * scmd: SCSI command pointer
+ * @shost: SCSI host pointer
+ * @starget: SCSI target pointer
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
@@ -4827,10 +4831,22 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 		return ret;
 	}
 
+	shost_for_each_device(sdev, shost) {
+		if (!sdev->hostdata)
+			continue;
+		if (sdev->sdev_target != starget)
+			continue;
+		mr_device_priv_data = sdev->hostdata;
+		if (mr_device_priv_data->is_tm_capable) {
+			devhandle = megasas_get_tm_devhandle(sdev);
+			scsi_device_put(sdev);
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
@@ -4841,30 +4857,27 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	}
 
 	mutex_lock(&instance->reset_mutex);
-	devhandle = megasas_get_tm_devhandle(scmd->device);
 
-	if (devhandle == (u16)ULONG_MAX) {
-		ret = FAILED;
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
index 381e07f2b718..63d95aa8a5f3 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4082,7 +4082,7 @@ static int mpi3mr_eh_bus_reset(struct Scsi_Host *shost, unsigned int channel)
 
 /**
  * mpi3mr_eh_target_reset - Target reset error handling callback
- * @scmd: SCSI command reference
+ * @starget: SCSI target reference
  *
  * Issue Target reset Task Management and verify the scmd is
  * terminated successfully and return status accordingly.
@@ -4090,54 +4090,41 @@ static int mpi3mr_eh_bus_reset(struct Scsi_Host *shost, unsigned int channel)
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
-
-	sdev_priv_data = scmd->device->hostdata;
-	if (!sdev_priv_data || !sdev_priv_data->tgt_priv_data) {
-		sdev_printk(KERN_INFO, scmd->device,
-		    "SCSI device is not available\n");
-		retval = SUCCESS;
-		goto out;
-	}
+	starget_printk(KERN_INFO, starget,
+	    "Attempting Target Reset!\n");
 
-	stgt_priv_data = sdev_priv_data->tgt_priv_data;
+	stgt_priv_data = starget->hostdata;
 	dev_handle = stgt_priv_data->dev_handle;
 	if (stgt_priv_data->dev_removed) {
-		struct scmd_priv *cmd_priv = scsi_cmd_priv(scmd);
-		sdev_printk(KERN_INFO, scmd->device,
+		starget_printk(KERN_INFO, starget,
 		    "%s:target(handle = 0x%04x) is removed, target reset is not issued\n",
 		    mrioc->name, dev_handle);
-		if (!cmd_priv->in_lld_scope || cmd_priv->host_tag == MPI3MR_HOSTTAG_INVALID)
-			retval = SUCCESS;
-		else
-			retval = FAILED;
+		retval = FAILED;
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
@@ -4145,9 +4132,9 @@ static int mpi3mr_eh_target_reset(struct scsi_cmnd *scmd)
 
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
index 58ccf8e66445..1f3ce2aafed6 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3441,52 +3441,45 @@ scsih_dev_reset(struct scsi_cmnd *scmd)
 
 /**
  * scsih_target_reset - eh threads main target reset routine
- * @scmd: pointer to scsi command object
+ * @starget: pointer to scsi target object
  *
- * Return: SUCCESS if command aborted else FAILED
+ * Return: SUCCESS if target reset suceeded else FAILED
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
@@ -3499,16 +3492,16 @@ scsih_target_reset(struct scsi_cmnd *scmd)
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
index 84fcec476ef1..61fcd0420029 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3061,15 +3061,15 @@ static int pmcraid_eh_bus_reset_handler(struct Scsi_Host *host,
 				    RESET_DEVICE_BUS);
 }
 
-static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
+static int pmcraid_eh_target_reset_handler(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = scmd->device->host;
+	struct Scsi_Host *shost = dev_to_shost(&starget->dev);
 	struct scsi_device *scsi_dev = NULL, *tmp;
 	int ret;
 
 	shost_for_each_device(tmp, shost) {
-		if ((tmp->channel == scmd->device->channel) &&
-		    (tmp->id == scmd->device->id)) {
+		if ((tmp->channel == starget->channel) &&
+		    (tmp->id == starget->id)) {
 			scsi_dev = tmp;
 			break;
 		}
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 0e5f9f20e5fc..2a7eab4fb1b9 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -856,9 +856,8 @@ static int qedf_eh_abort(struct scsi_cmnd *sc_cmd)
 	return rc;
 }
 
-static int qedf_eh_target_reset(struct scsi_cmnd *sc_cmd)
+static int qedf_eh_target_reset(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(sc_cmd->device);
 	struct fc_rport *rport = starget_to_rport(starget);
 
 	QEDF_ERR(NULL, "TARGET RESET Issued...");
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1803baa00600..fd273f65c69e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1515,10 +1515,9 @@ qla2xxx_eh_device_reset(struct scsi_cmnd *cmd)
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
@@ -1543,40 +1542,39 @@ qla2xxx_eh_target_reset(struct scsi_cmnd *cmd)
 		return FAILED;
 
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
 	if (qla2x00_eh_wait_for_pending_commands(vha, fcport->d_id.b24, 0,
 						 WAIT_TARGET) != QLA_SUCCESS) {
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
index 70757ef5b4fd..7a725066551b 100644
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
@@ -9338,13 +9338,12 @@ static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd)
 
 /**
  * qla4xxx_eh_target_reset - callback for target reset.
- * @cmd: Pointer to Linux's SCSI command structure
+ * @starget: Pointer to Linux's SCSI target structure
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
@@ -9366,10 +9365,8 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
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
@@ -9392,7 +9389,7 @@ static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd)
 	}
 
 	/* Send marker. */
-	if (qla4xxx_send_marker_iocb(ha, ddb_entry, cmd->device->lun,
+	if (qla4xxx_send_marker_iocb(ha, ddb_entry, 0,
 		MM_TGT_WARM_RESET) != QLA_SUCCESS) {
 		starget_printk(KERN_INFO, starget,
 			       "WARM TARGET DEVICE RESET FAILED - "
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index a2b66cf0549c..641045adee37 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5737,9 +5737,8 @@ static int scsi_debug_device_reset(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static int sdebug_fail_target_reset(struct scsi_cmnd *cmnd)
+static int sdebug_fail_target_reset(struct scsi_target *starget)
 {
-	struct scsi_target *starget = scsi_target(cmnd->device);
 	struct sdebug_target_info *targetip =
 		(struct sdebug_target_info *)starget->hostdata;
 
@@ -5749,33 +5748,29 @@ static int sdebug_fail_target_reset(struct scsi_cmnd *cmnd)
 	return 0;
 }
 
-static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
+static int scsi_debug_target_reset(struct scsi_target *starget)
 {
-	struct scsi_device *sdp = SCpnt->device;
-	struct sdebug_host_info *sdbg_host = shost_to_sdebug_host(sdp->host);
+	struct Scsi_Host *hp = dev_to_shost(&starget->dev);
+	struct sdebug_host_info *sdbg_host = shost_to_sdebug_host(hp);
 	struct sdebug_dev_info *devip;
-	u8 *cmd = SCpnt->cmnd;
-	u8 opcode = cmd[0];
 	int k = 0;
 
 	++num_target_resets;
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
-
+		starget_printk(KERN_INFO, starget, "%s\n", __func__);
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
-		if (devip->target == sdp->id) {
+		if (devip->target == starget->id) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
 			++k;
 		}
 	}
 
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp,
+		starget_printk(KERN_INFO, starget,
 			    "%s: %d device(s) found in target\n", __func__, k);
 
-	if (sdebug_fail_target_reset(SCpnt)) {
-		scmd_printk(KERN_INFO, SCpnt, "fail target reset 0x%x\n",
-			    opcode);
+	if (sdebug_fail_target_reset(starget)) {
+		starget_printk(KERN_INFO, starget, "fail target reset\n");
 		return FAILED;
 	}
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f82551783feb..fc0510cd367c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -946,14 +946,15 @@ static enum scsi_disposition scsi_try_target_reset(struct scsi_cmnd *scmd)
 	enum scsi_disposition rtn;
 	struct Scsi_Host *host = scmd->device->host;
 	const struct scsi_host_template *hostt = host->hostt;
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
@@ -1634,7 +1635,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 	while (!list_empty(&tmp_list)) {
 		struct scsi_cmnd *next, *scmd;
 		enum scsi_disposition rtn;
-		unsigned int id;
+		unsigned int channel, id;
 
 		if (scsi_host_eh_past_deadline(shost)) {
 			/* push back on work queue for further processing */
@@ -1648,6 +1649,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		}
 
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
+		channel = scmd_channel(scmd);
 		id = scmd_id(scmd);
 
 		SCSI_LOG_ERROR_RECOVERY(3,
@@ -1662,7 +1664,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 					     " target: %d\n",
 					     current->comm, id));
 		list_for_each_entry_safe(scmd, next, &tmp_list, eh_entry) {
-			if (scmd_id(scmd) != id)
+			if (scmd_channel(scmd) != channel ||
+			    scmd_id(scmd) != id)
 				continue;
 
 			if (rtn == SUCCESS)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 18be7391314e..56fd40d40f67 100644
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
index 8e4035ff3674..3655ff2a9865 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -267,23 +267,24 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
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
index 7dddf785edd0..73d3c79f86c3 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -389,7 +389,7 @@ struct iscsi_host {
  * scsi host template
  */
 extern int iscsi_eh_abort(struct scsi_cmnd *sc);
-extern int iscsi_eh_recover_target(struct scsi_cmnd *sc);
+extern int iscsi_eh_recover_target(struct scsi_target *starget);
 extern int iscsi_eh_session_reset(struct iscsi_cls_session *cls_session);
 extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index f5257103fdb6..5d9a7439ee14 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -699,7 +699,7 @@ extern struct device_attribute dev_attr_phy_event_threshold;
 void sas_task_abort(struct sas_task *);
 int sas_eh_abort_handler(struct scsi_cmnd *cmd);
 int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
-int sas_eh_target_reset_handler(struct scsi_cmnd *cmd);
+int sas_eh_target_reset_handler(struct scsi_target *starget);
 
 extern void sas_target_destroy(struct scsi_target *);
 extern int sas_slave_alloc(struct scsi_device *);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 8feb2e8e312e..44ccca4b401d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -151,7 +151,7 @@ struct scsi_host_template {
 	 */
 	int (* eh_abort_handler)(struct scsi_cmnd *);
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
-	int (* eh_target_reset_handler)(struct scsi_cmnd *);
+	int (* eh_target_reset_handler)(struct scsi_target *);
 	int (* eh_bus_reset_handler)(struct Scsi_Host *, unsigned int);
 	int (* eh_host_reset_handler)(struct Scsi_Host *);
 
-- 
2.35.3

