Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D46E748E9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbjJBP7j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238369AbjJBP7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:59:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA39101
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:59:19 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9CF6E21863;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696262357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tAhSNupTU3XXsYDheOsA5Bov/z6qMV3W+Wn4McY0Xo=;
        b=vBqLrKUtnnazokOwumgkdIgG9d/+1wbmZWzduWqEq1NWfaBwFG80AWJKds0wKWMP4IDa82
        IhHhy5UOiS029IZOEP93C6NTMeESQvaBJXX+1FJVmXWSLSOuA6LPYGAeS8GwfSVKo4gb2Z
        rEGqAl/VAZDWFFT+tD6oCf4KnUyxqVI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696262357;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4tAhSNupTU3XXsYDheOsA5Bov/z6qMV3W+Wn4McY0Xo=;
        b=4pI2KT6Xwi1hTd2nFT6kGIvojpLTtO+Qvw+5k06Id2uNp4yVcMuRAyvF56FiszhQr8e6QD
        pPUx2eNetiAKWPBA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 51CA22C143;
        Mon,  2 Oct 2023 15:59:17 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 6586851E7580; Mon,  2 Oct 2023 17:59:17 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/7] scsi: Use Scsi_Host as argument for eh_host_reset_handler
Date:   Mon,  2 Oct 2023 17:59:09 +0200
Message-Id: <20231002155915.109359-2-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002155915.109359-1-hare@suse.de>
References: <20231002155915.109359-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Issuing a host reset should not rely on any commands.
So use Scsi_Host as argument for eh_host_reset_handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_eh.rst            |  2 +-
 Documentation/scsi/scsi_mid_low_api.rst   |  4 +--
 drivers/infiniband/ulp/srp/ib_srp.c       |  6 ++--
 drivers/message/fusion/mptscsih.c         | 19 ++++++-----
 drivers/message/fusion/mptscsih.h         |  2 +-
 drivers/s390/scsi/zfcp_scsi.c             |  5 ++-
 drivers/scsi/3w-9xxx.c                    | 11 ++++---
 drivers/scsi/3w-sas.c                     | 11 ++++---
 drivers/scsi/3w-xxxx.c                    | 11 +++----
 drivers/scsi/53c700.c                     | 39 ++++++++++++-----------
 drivers/scsi/BusLogic.c                   | 14 +++-----
 drivers/scsi/NCR5380.c                    |  3 +-
 drivers/scsi/aacraid/linit.c              |  6 ++--
 drivers/scsi/advansys.c                   | 26 ++++++++-------
 drivers/scsi/aha1542.c                    | 20 ++++++------
 drivers/scsi/arm/acornscsi.c              |  8 ++---
 drivers/scsi/arm/fas216.c                 |  4 +--
 drivers/scsi/arm/fas216.h                 |  6 ++--
 drivers/scsi/atari_scsi.c                 |  4 +--
 drivers/scsi/cxlflash/main.c              |  5 ++-
 drivers/scsi/esas2r/esas2r.h              |  2 +-
 drivers/scsi/esas2r/esas2r_main.c         | 16 ++++++----
 drivers/scsi/esp_scsi.c                   |  4 +--
 drivers/scsi/fdomain.c                    |  3 +-
 drivers/scsi/fnic/fnic.h                  |  2 +-
 drivers/scsi/fnic/fnic_scsi.c             |  3 +-
 drivers/scsi/hptiop.c                     |  6 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c            |  4 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c          |  4 +--
 drivers/scsi/imm.c                        |  4 +--
 drivers/scsi/ipr.c                        |  4 +--
 drivers/scsi/ips.c                        | 22 +++++--------
 drivers/scsi/libfc/fc_fcp.c               |  5 ++-
 drivers/scsi/lpfc/lpfc_scsi.c             |  3 +-
 drivers/scsi/mac53c94.c                   |  8 ++---
 drivers/scsi/megaraid.c                   |  4 +--
 drivers/scsi/megaraid.h                   |  2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     | 14 +++-----
 drivers/scsi/megaraid/megaraid_sas_base.c | 34 ++++++++++----------
 drivers/scsi/mesh.c                       | 10 +++---
 drivers/scsi/mpi3mr/mpi3mr_os.c           | 12 +++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 11 +++----
 drivers/scsi/mvumi.c                      |  7 ++--
 drivers/scsi/myrb.c                       |  3 +-
 drivers/scsi/myrs.c                       |  3 +-
 drivers/scsi/nsp32.c                      | 12 +++----
 drivers/scsi/pcmcia/nsp_cs.c              |  4 +--
 drivers/scsi/pcmcia/nsp_cs.h              |  2 +-
 drivers/scsi/pcmcia/qlogic_stub.c         |  4 +--
 drivers/scsi/pcmcia/sym53c500_cs.c        |  8 ++---
 drivers/scsi/pmcraid.c                    |  6 ++--
 drivers/scsi/ppa.c                        |  4 +--
 drivers/scsi/qedf/qedf_main.c             |  4 +--
 drivers/scsi/qedi/qedi_iscsi.c            |  3 +-
 drivers/scsi/qla1280.c                    |  3 +-
 drivers/scsi/qla2xxx/qla_os.c             | 18 ++++-------
 drivers/scsi/qla4xxx/ql4_os.c             | 18 +++++------
 drivers/scsi/qlogicfas408.c               | 10 +++---
 drivers/scsi/qlogicfas408.h               |  2 +-
 drivers/scsi/qlogicpti.c                  |  3 +-
 drivers/scsi/scsi_debug.c                 |  8 +++--
 drivers/scsi/scsi_error.c                 |  2 +-
 drivers/scsi/snic/snic.h                  |  3 +-
 drivers/scsi/snic/snic_scsi.c             | 37 +++++----------------
 drivers/scsi/stex.c                       |  7 ++--
 drivers/scsi/storvsc_drv.c                |  4 +--
 drivers/scsi/sym53c8xx_2/sym_glue.c       |  3 +-
 drivers/scsi/vmw_pvscsi.c                 |  5 ++-
 drivers/scsi/wd33c93.c                    |  5 +--
 drivers/scsi/wd33c93.h                    |  2 +-
 drivers/scsi/wd719x.c                     |  4 +--
 drivers/ufs/core/ufshcd.c                 |  6 ++--
 drivers/usb/image/microtek.c              |  4 +--
 include/scsi/libfc.h                      |  2 +-
 include/scsi/scsi_host.h                  |  2 +-
 75 files changed, 261 insertions(+), 330 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.rst b/Documentation/scsi/scsi_eh.rst
index 104d09e9af09..da95971b4f44 100644
--- a/Documentation/scsi/scsi_eh.rst
+++ b/Documentation/scsi/scsi_eh.rst
@@ -217,7 +217,7 @@ considered to fail always.
     int (* eh_abort_handler)(struct scsi_cmnd *);
     int (* eh_device_reset_handler)(struct scsi_cmnd *);
     int (* eh_bus_reset_handler)(struct scsi_cmnd *);
-    int (* eh_host_reset_handler)(struct scsi_cmnd *);
+    int (* eh_host_reset_handler)(struct Scsi_Host *);
 
 Higher-severity actions are taken only when lower-severity actions
 cannot recover some of failed scmds.  Also, note that failure of the
diff --git a/Documentation/scsi/scsi_mid_low_api.rst b/Documentation/scsi/scsi_mid_low_api.rst
index 022198c51350..85b1384ba4fd 100644
--- a/Documentation/scsi/scsi_mid_low_api.rst
+++ b/Documentation/scsi/scsi_mid_low_api.rst
@@ -777,7 +777,7 @@ Details::
 
     /**
     *      eh_host_reset_handler - reset host (host bus adapter)
-    *      @scp: SCSI host that contains this device should be reset
+    *      @shp: SCSI host that contains this device should be reset
     *
     *      Returns SUCCESS if command aborted else FAILED
     *
@@ -794,7 +794,7 @@ Details::
     *
     *      Optionally defined in: LLD
     **/
-	int eh_host_reset_handler(struct scsi_cmnd * scp)
+	int eh_host_reset_handler(struct Scsi_Host * shp)
 
 
     /**
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1574218764e0..07a61d238d6b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2831,11 +2831,11 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	return SUCCESS;
 }
 
-static int srp_reset_host(struct scsi_cmnd *scmnd)
+static int srp_reset_host(struct Scsi_Host *shost)
 {
-	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct srp_target_port *target = host_to_target(shost);
 
-	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
+	shost_printk(KERN_ERR, shost, PFX "SRP reset_host called\n");
 
 	return srp_reconnect_rport(target->rport) == 0 ? SUCCESS : FAILED;
 }
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 9080a73b4ea6..caf045cfea0e 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1955,15 +1955,15 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mptscsih_host_reset - Perform a SCSI host adapter RESET (new_eh variant)
- *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
+ *	mptscsih_host_reset - Perform a SCSI host adapter RESET
+ *	@sh: Pointer to Scsi_Host structure, which is reset due to
  *
  *	(linux scsi_host_template.eh_host_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_host_reset(struct scsi_cmnd *SCpnt)
+mptscsih_host_reset(struct Scsi_Host *sh)
 {
 	MPT_SCSI_HOST *  hd;
 	int              status = SUCCESS;
@@ -1971,9 +1971,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	int		retval;
 
 	/*  If we can't locate the host to reset, then we failed. */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
-		printk(KERN_ERR MYNAM ": host reset: "
-		    "Can't locate host! (sc=%p)\n", SCpnt);
+	if ((hd = shost_priv(sh)) == NULL){
+		printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
 		return FAILED;
 	}
 
@@ -1981,8 +1980,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	mptscsih_flush_running_cmds(hd);
 
 	ioc = hd->ioc;
-	printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
-	    ioc->name, SCpnt);
+	printk(MYIOC_s_INFO_FMT "attempting host reset!\n",
+	    ioc->name);
 
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
@@ -1993,8 +1992,8 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	else
 		status = SUCCESS;
 
-	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	printk(MYIOC_s_INFO_FMT "host reset: %s\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
 
 	return status;
 }
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index e3d92c392673..0faefe9c7541 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -122,7 +122,7 @@ extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
-extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
+extern int mptscsih_host_reset(struct Scsi_Host *sh);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
 extern int mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 14f929cca271..60ef1e2ab3cd 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -371,10 +371,9 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 	return ret;
 }
 
-static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
+static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
 {
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
-	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
 	int ret = SUCCESS, fc_ret;
 
 	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index f925f8664c2c..f0efdfcdac44 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1717,18 +1717,19 @@ static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
 } /* End twa_scsi_biosparam() */
 
 /* This is the new scsi eh reset function */
-static int twa_scsi_eh_reset(struct scsi_cmnd *SCpnt)
+static int twa_scsi_eh_reset(struct Scsi_Host *shost)
 {
 	TW_Device_Extension *tw_dev = NULL;
 	int retval = FAILED;
 
-	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
+	tw_dev = (TW_Device_Extension *)shost->hostdata;
 
 	tw_dev->num_resets++;
 
-	sdev_printk(KERN_WARNING, SCpnt->device,
-		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
-		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
+	shost_printk(KERN_WARNING, shost,
+		     "WARNING: (0x%02X:0x%04X): "
+		     "Command timed out, resetting card.\n",
+		     TW_DRIVER, 0x2c);
 
 	/* Make sure we are not issuing an ioctl or resetting from ioctl */
 	mutex_lock(&tw_dev->ioctl_lock);
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 55989eaa2d9f..80885200ba52 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1423,18 +1423,19 @@ static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
 } /* End twl_scsi_biosparam() */
 
 /* This is the new scsi eh reset function */
-static int twl_scsi_eh_reset(struct scsi_cmnd *SCpnt)
+static int twl_scsi_eh_reset(struct Scsi_Host *shost)
 {
 	TW_Device_Extension *tw_dev = NULL;
 	int retval = FAILED;
 
-	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
+	tw_dev = (TW_Device_Extension *)shost->hostdata;
 
 	tw_dev->num_resets++;
 
-	sdev_printk(KERN_WARNING, SCpnt->device,
-		"WARNING: (0x%02X:0x%04X): Command (0x%x) timed out, resetting card.\n",
-		TW_DRIVER, 0x2c, SCpnt->cmnd[0]);
+	shost_printk(KERN_WARNING, shost,
+		     "WARNING: (0x%02X:0x%04X): "
+		     "Command timed out, resetting card.\n",
+		     TW_DRIVER, 0x2c);
 
 	/* Make sure we are not issuing an ioctl or resetting from ioctl */
 	mutex_lock(&tw_dev->ioctl_lock);
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index f39c9ec2e781..73c4becaea05 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1366,25 +1366,24 @@ static int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev
 } /* End tw_scsi_biosparam() */
 
 /* This is the new scsi eh reset function */
-static int tw_scsi_eh_reset(struct scsi_cmnd *SCpnt)
+static int tw_scsi_eh_reset(struct Scsi_Host *shost)
 {
 	TW_Device_Extension *tw_dev=NULL;
 	int retval = FAILED;
 
-	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
+	tw_dev = (TW_Device_Extension *)shost->hostdata;
 
 	tw_dev->num_resets++;
 
-	sdev_printk(KERN_WARNING, SCpnt->device,
-		"WARNING: Command (0x%x) timed out, resetting card.\n",
-		SCpnt->cmnd[0]);
+	shost_printk(KERN_WARNING, shost,
+		"WARNING: Command timed out, resetting card.\n");
 
 	/* Make sure we are not issuing an ioctl or resetting from ioctl */
 	mutex_lock(&tw_dev->ioctl_lock);
 
 	/* Now reset the card and some of the device extension data */
 	if (tw_reset_device_extension(tw_dev)) {
-		printk(KERN_WARNING "3w-xxxx: scsi%d: Reset failed.\n", tw_dev->host->host_no);
+		shost_printk(KERN_WARNING, shost, "Reset failed.\n");
 		goto out;
 	}
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 857be0f3ae5b..7cdea2f0f66a 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -155,7 +155,7 @@ MODULE_LICENSE("GPL");
 
 STATIC int NCR_700_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *);
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
-STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
+STATIC int NCR_700_host_reset(struct Scsi_Host *host);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
@@ -1934,40 +1934,41 @@ NCR_700_abort(struct scsi_cmnd * SCp)
 }
 
 STATIC int
-NCR_700_host_reset(struct scsi_cmnd * SCp)
+NCR_700_host_reset(struct Scsi_Host * host)
 {
 	DECLARE_COMPLETION_ONSTACK(complete);
-	struct NCR_700_Host_Parameters *hostdata = 
-		(struct NCR_700_Host_Parameters *)SCp->device->host->hostdata[0];
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
 
-	scmd_printk(KERN_INFO, SCp,
-		"New error handler wants HOST reset, cmd %p\n\t", SCp);
-	scsi_print_command(SCp);
+	shost_printk(KERN_INFO, host,
+		"New error handler wants HOST reset\n");
 
 	/* In theory, eh_complete should always be null because the
 	 * eh is single threaded, but just in case we're handling a
 	 * reset via sg or something */
-	spin_lock_irq(SCp->device->host->host_lock);
+	spin_lock_irq(host->host_lock);
 	while (hostdata->eh_complete != NULL) {
-		spin_unlock_irq(SCp->device->host->host_lock);
+		spin_unlock_irq(host->host_lock);
 		msleep_interruptible(100);
-		spin_lock_irq(SCp->device->host->host_lock);
+		spin_lock_irq(host->host_lock);
 	}
 
 	hostdata->eh_complete = &complete;
-	NCR_700_internal_bus_reset(SCp->device->host);
-	NCR_700_chip_reset(SCp->device->host);
+	NCR_700_internal_bus_reset(host);
+	NCR_700_chip_reset(host);
 
-	spin_unlock_irq(SCp->device->host->host_lock);
+	spin_unlock_irq(host->host_lock);
 	wait_for_completion(&complete);
-	spin_lock_irq(SCp->device->host->host_lock);
+	spin_lock_irq(host->host_lock);
 
 	hostdata->eh_complete = NULL;
-	/* Revalidate the transport parameters of the failing device */
-	if(hostdata->fast)
-		spi_schedule_dv_device(SCp->device);
-
-	spin_unlock_irq(SCp->device->host->host_lock);
+	/* Revalidate the transport parameters for attached devices */
+	if(hostdata->fast) {
+		struct scsi_device *sdev;
+		__shost_for_each_device(sdev, host)
+			spi_schedule_dv_device(sdev);
+	}
+	spin_unlock_irq(host->host_lock);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 72ceaf650b0d..3bbd8e204ec9 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2852,21 +2852,15 @@ static bool blogic_write_outbox(struct blogic_adapter *adapter,
 
 /* Error Handling (EH) support */
 
-static int blogic_hostreset(struct scsi_cmnd *SCpnt)
+static int blogic_hostreset(struct Scsi_Host *shost)
 {
 	struct blogic_adapter *adapter =
-		(struct blogic_adapter *) SCpnt->device->host->hostdata;
-
-	unsigned int id = SCpnt->device->id;
-	struct blogic_tgt_stats *stats = &adapter->tgt_stats[id];
+		(struct blogic_adapter *) shost->hostdata;
 	int rc;
 
-	spin_lock_irq(SCpnt->device->host->host_lock);
-
-	blogic_inc_count(&stats->adapter_reset_req);
-
+	spin_lock_irq(shost->host_lock);
 	rc = blogic_resetadapter(adapter, false);
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(shost->host_lock);
 	return rc;
 }
 
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index cea3a79d538e..80ef73f119ad 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2379,9 +2379,8 @@ static void bus_reset_cleanup(struct Scsi_Host *instance)
  * Returns SUCCESS
  */
 
-static int NCR5380_host_reset(struct scsi_cmnd *cmd)
+static int NCR5380_host_reset(struct Scsi_Host *instance)
 {
-	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned long flags;
 	struct NCR5380_cmd *ncmd;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index c4a36c0be527..121b6447baa6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1087,13 +1087,11 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 
 /*
  *	aac_eh_host_reset	- Host reset command handling
- *	@scsi_cmd:	SCSI command block causing the reset
+ *	@host:	SCSI host to be reset
  *
  */
-static int aac_eh_host_reset(struct scsi_cmnd *cmd)
+static int aac_eh_host_reset(struct Scsi_Host *host)
 {
-	struct scsi_device * dev = cmd->device;
-	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	int ret = FAILED;
 	__le32 supported_options2 = 0;
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ab066bb27a57..b21e3987229f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7016,9 +7016,8 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
  * sleeping is allowed and no locking other than for host structures is
  * required. Returns SUCCESS or FAILED.
  */
-static int advansys_reset(struct scsi_cmnd *scp)
+static int advansys_reset(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = scp->device->host;
 	struct asc_board *boardp = shost_priv(shost);
 	unsigned long flags;
 	int status;
@@ -7028,7 +7027,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 
 	ASC_STATS(shost, reset);
 
-	scmd_printk(KERN_INFO, scp, "SCSI host reset started...\n");
+	shost_printk(KERN_INFO, shost, "SCSI host reset started...\n");
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
@@ -7039,16 +7038,18 @@ static int advansys_reset(struct scsi_cmnd *scp)
 
 		/* Refer to ASC_IERR_* definitions for meaning of 'err_code'. */
 		if (asc_dvc->err_code || !asc_dvc->overrun_dma) {
-			scmd_printk(KERN_INFO, scp, "SCSI host reset error: "
-				    "0x%x, status: 0x%x\n", asc_dvc->err_code,
+			shost_printk(KERN_INFO, shost,
+				     "SCSI host reset error: 0x%x, status: 0x%x\n",
+				     asc_dvc->err_code,
 				    status);
 			ret = FAILED;
 		} else if (status) {
-			scmd_printk(KERN_INFO, scp, "SCSI host reset warning: "
-				    "0x%x\n", status);
+			shost_printk(KERN_INFO, shost,
+				     "SCSI host reset warning: 0x%x\n",
+				     status);
 		} else {
-			scmd_printk(KERN_INFO, scp, "SCSI host reset "
-				    "successful\n");
+			shost_printk(KERN_INFO, shost,
+				     "SCSI host reset successful\n");
 		}
 
 		ASC_DBG(1, "after AscInitAsc1000Driver()\n");
@@ -7065,12 +7066,13 @@ static int advansys_reset(struct scsi_cmnd *scp)
 		ASC_DBG(1, "before AdvResetChipAndSB()\n");
 		switch (AdvResetChipAndSB(adv_dvc)) {
 		case ASC_TRUE:
-			scmd_printk(KERN_INFO, scp, "SCSI host reset "
-				    "successful\n");
+			shost_printk(KERN_INFO, shost,
+				     "SCSI host reset successful\n");
 			break;
 		case ASC_FALSE:
 		default:
-			scmd_printk(KERN_INFO, scp, "SCSI host reset error\n");
+			shost_printk(KERN_INFO, shost,
+				     "SCSI host reset error\n");
 			ret = FAILED;
 			break;
 		}
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 9503996c6325..2a88e1c6ffda 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -914,15 +914,14 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 	aha1542_outb(sh->io_port, CMD_START_SCSI);
 	spin_unlock_irqrestore(sh->host_lock, flags);
 
-	scmd_printk(KERN_WARNING, cmd,
+	sdev_printk(KERN_WARNING, sdev,
 		"Trying device reset for target\n");
 
 	return SUCCESS;
 }
 
-static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
+static int aha1542_reset(struct Scsi_Host *sh, u8 reset_cmd)
 {
-	struct Scsi_Host *sh = cmd->device->host;
 	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	unsigned long flags;
 	int i;
@@ -934,9 +933,9 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	 * we do this?  Try this first, and we can add that later
 	 * if it turns out to be useful.
 	 */
-	outb(reset_cmd, CONTROL(cmd->device->host->io_port));
+	outb(reset_cmd, CONTROL(sh->io_port));
 
-	if (!wait_mask(STATUS(cmd->device->host->io_port),
+	if (!wait_mask(STATUS(sh->io_port),
 	     STATMASK, IDLE, STST | DIAGF | INVDCMD | DF | CDF, 0)) {
 		spin_unlock_irqrestore(sh->host_lock, flags);
 		return FAILED;
@@ -947,7 +946,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	 * us again after host reset.
 	 */
 	if (reset_cmd & HRST)
-		setup_mailboxes(cmd->device->host);
+		setup_mailboxes(sh);
 
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
@@ -955,7 +954,8 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	 * out.  We do not try and restart any commands or anything -
 	 * the strategy handler takes care of that crap.
 	 */
-	shost_printk(KERN_WARNING, cmd->device->host, "Sent BUS RESET to scsi host %d\n", cmd->device->host->host_no);
+	shost_printk(KERN_WARNING, sh, "Sent BUS RESET to scsi host %d\n",
+		     sh->host_no);
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (aha1542->int_cmds[i] != NULL) {
@@ -983,12 +983,12 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 
 static int aha1542_bus_reset(struct scsi_cmnd *cmd)
 {
-	return aha1542_reset(cmd, SCRST);
+	return aha1542_reset(cmd->device->host, SCRST);
 }
 
-static int aha1542_host_reset(struct scsi_cmnd *cmd)
+static int aha1542_host_reset(struct Scsi_Host *sh)
 {
-	return aha1542_reset(cmd, HRST | SCRST);
+	return aha1542_reset(sh, HRST | SCRST);
 }
 
 static int aha1542_biosparam(struct scsi_device *sdev,
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 0b046e4b395c..ffb518fe7164 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2631,13 +2631,13 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
 /*
  * Prototype: int acornscsi_reset(struct scsi_cmnd *SCpnt)
  * Purpose  : reset a command on this host/reset this host
- * Params   : SCpnt  - command causing reset
+ * Params   : shost  - host to be reset
  * Returns  : one of SCSI_RESET_ macros
  */
-int acornscsi_host_reset(struct scsi_cmnd *SCpnt)
+int acornscsi_host_reset(struct Scsi_Host *shost)
 {
-	AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
-	struct scsi_cmnd *SCptr;
+    AS_Host *host = (AS_Host *)shost->hostdata;
+    struct scsi_cmnd *SCptr;
     
     host->stats.resets += 1;
 
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index e6289c6af5ef..38eec967155d 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2656,9 +2656,9 @@ static void fas216_init_chip(FAS216_Info *info)
  * Returns: FAILED if unable to reset.
  * Notes: io_request_lock is taken, and irqs are disabled
  */
-int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
+int fas216_eh_host_reset(struct Scsi_Host *shost)
 {
-	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
+	FAS216_Info *info = (FAS216_Info *)shost->hostdata;
 
 	spin_lock_irq(info->host->host_lock);
 
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 08113277a2a9..f17583f143b3 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -394,11 +394,11 @@ extern int fas216_eh_device_reset(struct scsi_cmnd *SCpnt);
  */
 extern int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt);
 
-/* Function: int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
+/* Function: int fas216_eh_host_reset(struct Scsi_Host *shost)
  * Purpose : Reset the host associated with this command
- * Params  : SCpnt - command specifing host to reset
+ * Params  : shost - host to reset
  * Returns : FAILED if unable to reset
  */
-extern int fas216_eh_host_reset(struct scsi_cmnd *SCpnt);
+extern int fas216_eh_host_reset(struct Scsi_Host *shost);
 
 #endif /* FAS216_H */
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index d401cf27113a..d967141f366c 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -667,7 +667,7 @@ static void atari_scsi_falcon_reg_write(unsigned int reg, u8 value)
 
 #include "NCR5380.c"
 
-static int atari_scsi_host_reset(struct scsi_cmnd *cmd)
+static int atari_scsi_host_reset(struct Scsi_Host *shost)
 {
 	int rv;
 	unsigned long flags;
@@ -684,7 +684,7 @@ static int atari_scsi_host_reset(struct scsi_cmnd *cmd)
 		atari_dma_orig_addr = NULL;
 	}
 
-	rv = NCR5380_host_reset(cmd);
+	rv = NCR5380_host_reset(shost);
 
 	/* The 5380 raises its IRQ line while _RST is active but the ST DMA
 	 * "lock" has been released so this interrupt may end up handled by
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index debd36974119..187757ae7c1f 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2476,7 +2476,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 
 /**
  * cxlflash_eh_host_reset_handler() - reset the host adapter
- * @scp:	SCSI command from stack identifying host.
+ * @host:	SCSI host adapter.
  *
  * Following a reset, the state is evaluated again in case an EEH occurred
  * during the reset. In such a scenario, the host reset will either yield
@@ -2487,11 +2487,10 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
  *	SUCCESS as defined in scsi/scsi.h
  *	FAILED as defined in scsi/scsi.h
  */
-static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
+static int cxlflash_eh_host_reset_handler(struct Scsi_Host *host)
 {
 	int rc = SUCCESS;
 	int rcr = 0;
-	struct Scsi_Host *host = scp->device->host;
 	struct cxlflash_cfg *cfg = shost_priv(host);
 	struct device *dev = &cfg->dev->dev;
 
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index ed63f7a9ea54..a104d1a3a9da 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -976,7 +976,7 @@ long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 /* SCSI error handler (eh) functions */
 int esas2r_eh_abort(struct scsi_cmnd *cmd);
 int esas2r_device_reset(struct scsi_cmnd *cmd);
-int esas2r_host_reset(struct scsi_cmnd *cmd);
+int esas2r_host_reset(struct Scsi_Host *shost);
 int esas2r_bus_reset(struct scsi_cmnd *cmd);
 int esas2r_target_reset(struct scsi_cmnd *cmd);
 
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index f700a16cd885..168f01a34acc 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1062,10 +1062,10 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-static int esas2r_host_bus_reset(struct scsi_cmnd *cmd, bool host_reset)
+static int esas2r_host_bus_reset(struct Scsi_Host *shost, bool host_reset)
 {
 	struct esas2r_adapter *a =
-		(struct esas2r_adapter *)cmd->device->host->hostdata;
+		(struct esas2r_adapter *)shost->hostdata;
 
 	if (test_bit(AF_DEGRADED_MODE, &a->flags))
 		return FAILED;
@@ -1090,18 +1090,20 @@ static int esas2r_host_bus_reset(struct scsi_cmnd *cmd, bool host_reset)
 	return SUCCESS;
 }
 
-int esas2r_host_reset(struct scsi_cmnd *cmd)
+int esas2r_host_reset(struct Scsi_Host *shost)
 {
-	esas2r_log(ESAS2R_LOG_INFO, "host_reset (%p)", cmd);
+	esas2r_log(ESAS2R_LOG_INFO, "host_reset (%p)", shost);
 
-	return esas2r_host_bus_reset(cmd, true);
+	return esas2r_host_bus_reset(shost, true);
 }
 
 int esas2r_bus_reset(struct scsi_cmnd *cmd)
 {
-	esas2r_log(ESAS2R_LOG_INFO, "bus_reset (%p)", cmd);
+	struct Scsi_Host *shost = cmd->device->host;
+
+	esas2r_log(ESAS2R_LOG_INFO, "bus_reset (%p)", shost);
 
-	return esas2r_host_bus_reset(cmd, false);
+	return esas2r_host_bus_reset(shost, false);
 }
 
 static int esas2r_dev_targ_reset(struct scsi_cmnd *cmd, bool target_reset)
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 97816a0e6240..355fec046220 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2640,9 +2640,9 @@ static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 }
 
 /* All bets are off, reset the entire device.  */
-static int esp_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int esp_eh_host_reset_handler(struct Scsi_Host *shost)
 {
-	struct esp *esp = shost_priv(cmd->device->host);
+	struct esp *esp = shost_priv(shost);
 	unsigned long flags;
 
 	spin_lock_irqsave(esp->host->host_lock, flags);
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 504c4e0c5d17..347fb668bf29 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -456,9 +456,8 @@ static int fdomain_abort(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-static int fdomain_host_reset(struct scsi_cmnd *cmd)
+static int fdomain_host_reset(struct Scsi_Host *sh)
 {
-	struct Scsi_Host *sh = cmd->device->host;
 	struct fdomain *fd = shost_priv(sh);
 	unsigned long flags;
 
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 8ffcafb4687f..2e2b49ba8cdf 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -347,7 +347,7 @@ void fnic_update_mac_locked(struct fnic *, u8 *new);
 int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
 int fnic_device_reset(struct scsi_cmnd *);
-int fnic_host_reset(struct scsi_cmnd *);
+int fnic_host_reset(struct Scsi_Host *);
 int fnic_reset(struct Scsi_Host *);
 void fnic_scsi_cleanup(struct fc_lport *);
 void fnic_scsi_abort_io(struct fc_lport *);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 25af91081baf..324058bd594d 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2448,11 +2448,10 @@ int fnic_reset(struct Scsi_Host *shost)
  * host is offlined by SCSI.
  *
  */
-int fnic_host_reset(struct scsi_cmnd *sc)
+int fnic_host_reset(struct Scsi_Host *shost)
 {
 	int ret;
 	unsigned long wait_host_tmo;
-	struct Scsi_Host *shost = sc->device->host;
 	struct fc_lport *lp = shost_priv(shost);
 	struct fnic *fnic = lport_priv(lp);
 	unsigned long flags;
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index f5334ccbf2ca..cc9ed9e6c666 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1088,12 +1088,12 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
 	return 0;
 }
 
-static int hptiop_reset(struct scsi_cmnd *scp)
+static int hptiop_reset(struct Scsi_Host *host)
 {
-	struct hptiop_hba * hba = (struct hptiop_hba *)scp->device->host->hostdata;
+	struct hptiop_hba * hba = (struct hptiop_hba *)host->hostdata;
 
 	printk(KERN_WARNING "hptiop_reset(%d/%d/%d)\n",
-	       scp->device->host->host_no, -1, -1);
+	       host->host_no, -1, -1);
 
 	return hptiop_reset_hba(hba)? FAILED : SUCCESS;
 }
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 42dc5b7df5d5..cef7333c5586 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2987,10 +2987,10 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
  * @cmd:	struct scsi_cmnd having problems
  *
  **/
-static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int ibmvfc_eh_host_reset_handler(struct Scsi_Host *shost)
 {
 	int rc;
-	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
+	struct ibmvfc_host *vhost = shost_priv(shost);
 
 	dev_err(vhost->dev, "Resetting connection due to error recovery\n");
 	rc = ibmvfc_issue_fc_host_lip(vhost->host);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 59599299615d..da131fc34c2a 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1735,10 +1735,10 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
  * ibmvscsi_eh_host_reset_handler - Reset the connection to the server
  * @cmd:	struct scsi_cmnd having problems
 */
-static int ibmvscsi_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int ibmvscsi_eh_host_reset_handler(struct Scsi_Host *shost)
 {
 	unsigned long wait_switch = 0;
-	struct ibmvscsi_host_data *hostdata = shost_priv(cmd->device->host);
+	struct ibmvscsi_host_data *hostdata = shost_priv(shost);
 
 	dev_err(hostdata->dev, "Resetting connection due to error recovery\n");
 
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 07db98161a03..99ddc7e0bf89 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -984,9 +984,9 @@ static void imm_reset_pulse(unsigned int base)
 	w_ctr(base, 0x04);
 }
 
-static int imm_reset(struct scsi_cmnd *cmd)
+static int imm_reset(struct Scsi_Host *host)
 {
-	imm_struct *dev = imm_dev(cmd->device->host);
+	imm_struct *dev = imm_dev(host);
 
 	if (imm_scsi_pointer(cmd)->phase)
 		imm_disconnect(dev);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 4e13797b2a4a..df012977a25e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4959,14 +4959,14 @@ static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
 	return SUCCESS;
 }
 
-static int ipr_eh_host_reset(struct scsi_cmnd *cmd)
+static int ipr_eh_host_reset(struct Scsi_Host *shost)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	unsigned long lock_flags = 0;
 	int rc = SUCCESS;
 
 	ENTER;
-	ioa_cfg = (struct ipr_ioa_cfg *) cmd->device->host->hostdata;
+	ioa_cfg = (struct ipr_ioa_cfg *) shost->hostdata;
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 
 	if (!ioa_cfg->in_reset_reload && !ioa_cfg->hrrq[IPR_INIT_HRRQ].ioa_is_dead) {
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 10cf5775a939..58978009b151 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -229,7 +229,7 @@ module_param(ips, charp, 0);
  * Function prototypes
  */
 static int ips_eh_abort(struct scsi_cmnd *);
-static int ips_eh_reset(struct scsi_cmnd *);
+static int ips_eh_reset(struct Scsi_Host *);
 static int ips_queue(struct Scsi_Host *, struct scsi_cmnd *);
 static const char *ips_info(struct Scsi_Host *);
 static irqreturn_t do_ipsintr(int, void *);
@@ -829,7 +829,7 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 /* NOTE: this routine is called under the io_request_lock spinlock          */
 /*                                                                          */
 /****************************************************************************/
-static int __ips_eh_reset(struct scsi_cmnd *SC)
+static int __ips_eh_reset(struct Scsi_Host *shost)
 {
 	int ret;
 	int i;
@@ -842,13 +842,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 	return (FAILED);
 #else
 
-	if (!SC) {
-		DEBUG(1, "Reset called with NULL scsi command");
-
-		return (FAILED);
-	}
-
-	ha = (ips_ha_t *) SC->device->host->hostdata;
+	ha = (ips_ha_t *) shost->hostdata;
 
 	if (!ha) {
 		DEBUG(1, "Reset called with NULL ha struct");
@@ -994,13 +988,13 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
 }
 
-static int ips_eh_reset(struct scsi_cmnd *SC)
+static int ips_eh_reset(struct Scsi_Host *shost)
 {
 	int rc;
 
-	spin_lock_irq(SC->device->host->host_lock);
-	rc = __ips_eh_reset(SC);
-	spin_unlock_irq(SC->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
+	rc = __ips_eh_reset(shost);
+	spin_unlock_irq(shost->host_lock);
 
 	return rc;
 }
@@ -1078,7 +1072,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC)
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
-			__ips_eh_reset(SC);
+			__ips_eh_reset(SC->device->host);
 			SC->result = DID_OK << 16;
 			scsi_done(SC);
 			return (0);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 945adca5e72f..2ee697dd4ce3 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2186,11 +2186,10 @@ EXPORT_SYMBOL(fc_eh_device_reset);
 
 /**
  * fc_eh_host_reset() - Reset a Scsi_Host.
- * @sc_cmd: The SCSI command that identifies the SCSI host to be reset
+ * @shost: The SCSI host to be reset
  */
-int fc_eh_host_reset(struct scsi_cmnd *sc_cmd)
+int fc_eh_host_reset(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = sc_cmd->device->host;
 	struct fc_lport *lport = shost_priv(shost);
 	unsigned long wait_tmo;
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d26941b131fd..6ee444ff7532 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -6175,9 +6175,8 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
  *  0x2002 - Success
  **/
 static int
-lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
+lpfc_host_reset_handler(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	int rc, ret = SUCCESS;
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index 6a019132109c..497099158909 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -100,14 +100,14 @@ static int mac53c94_queue_lck(struct scsi_cmnd *cmd)
 
 static DEF_SCSI_QCMD(mac53c94_queue)
 
-static int mac53c94_host_reset(struct scsi_cmnd *cmd)
+static int mac53c94_host_reset(struct Scsi_Host *shost)
 {
-	struct fsc_state *state = (struct fsc_state *) cmd->device->host->hostdata;
+	struct fsc_state *state = (struct fsc_state *) shost->hostdata;
 	struct mac53c94_regs __iomem *regs = state->regs;
 	struct dbdma_regs __iomem *dma = state->dma;
 	unsigned long flags;
 
-	spin_lock_irqsave(cmd->device->host->host_lock, flags);
+	spin_lock_irqsave(shost->host_lock, flags);
 
 	writel((RUN|PAUSE|FLUSH|WAKE) << 16, &dma->control);
 	writeb(CMD_SCSI_RESET, &regs->command);	/* assert RST */
@@ -117,7 +117,7 @@ static int mac53c94_host_reset(struct scsi_cmnd *cmd)
 	mac53c94_init(state);
 	writeb(CMD_NOP, &regs->command);
 
-	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 329c3da88416..80493b1ad633 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1876,13 +1876,13 @@ megaraid_abort(struct scsi_cmnd *cmd)
 
 
 static int
-megaraid_reset(struct scsi_cmnd *cmd)
+megaraid_reset(struct Scsi_Host *shost)
 {
 	adapter_t	*adapter;
 	megacmd_t	mc;
 	int		rval;
 
-	adapter = (adapter_t *)cmd->device->host->hostdata;
+	adapter = (adapter_t *)shost->hostdata;
 
 #if MEGA_HAVE_CLUSTERING
 	mc.cmd = MEGA_CLUSTER_CMD;
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 013fbfb911b9..43acad67d95f 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -973,7 +973,7 @@ static irqreturn_t megaraid_isr_iomapped(int, void *);
 static void mega_free_scb(adapter_t *, scb_t *);
 
 static int megaraid_abort(struct scsi_cmnd *);
-static int megaraid_reset(struct scsi_cmnd *);
+static int megaraid_reset(struct Scsi_Host *);
 static int megaraid_abort_and_reset(adapter_t *, struct scsi_cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index bc867da650b6..8a390677b11a 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -92,7 +92,7 @@ static int megaraid_sysfs_alloc_resources(adapter_t *);
 static void megaraid_sysfs_free_resources(adapter_t *);
 
 static int megaraid_abort_handler(struct scsi_cmnd *);
-static int megaraid_reset_handler(struct scsi_cmnd *);
+static int megaraid_reset_handler(struct Scsi_Host *);
 
 static int mbox_post_sync_cmd(adapter_t *, uint8_t []);
 static int mbox_post_sync_cmd_fast(adapter_t *, uint8_t []);
@@ -2512,7 +2512,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
  * host.
  **/
 static int
-megaraid_reset_handler(struct scsi_cmnd *scp)
+megaraid_reset_handler(struct Scsi_Host *shost)
 {
 	adapter_t	*adapter;
 	scb_t		*scb;
@@ -2525,7 +2525,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 	int		i;
 	uioc_t		*kioc;
 
-	adapter		= SCP2ADAPTER(scp);
+	adapter		= (adapter_t *)SCSIHOST2ADAP(shost);
 	raid_dev	= ADAP2RAIDDEV(adapter);
 
 	// return failure if adapter is not responding
@@ -2556,15 +2556,9 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 
 			megaraid_mbox_mm_done(adapter, scb);
 		} else {
-			if (scb->scp == scp) {	// Found command
-				con_log(CL_ANN, (KERN_WARNING
-					"megaraid: %d[%d:%d], reset from pending list\n",
-					scb->sno, scb->dev_channel, scb->dev_target));
-			} else {
-				con_log(CL_ANN, (KERN_WARNING
+			con_log(CL_ANN, (KERN_WARNING
 				"megaraid: IO packet with %d[%d:%d] being reset\n",
 				scb->sno, scb->dev_channel, scb->dev_target));
-			}
 
 			scb->scp->result = (DID_RESET << 16);
 			scsi_done(scb->scp);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b9d46dcb5210..87f6d12dd812 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2896,15 +2896,14 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
  * reset requests. Device, bus and host specific reset handlers can use this
  * function after they do their specific tasks.
  */
-static int megasas_generic_reset(struct scsi_cmnd *scmd)
+static int megasas_generic_reset(struct Scsi_Host *shost)
 {
 	int ret_val;
 	struct megasas_instance *instance;
 
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = (struct megasas_instance *)shost->hostdata;
 
-	scmd_printk(KERN_NOTICE, scmd, "megasas: RESET cmd=%x retries=%x\n",
-		 scmd->cmnd[0], scmd->retries);
+	shost_printk(KERN_NOTICE, shost, "megasas: RESET\n");
 
 	if (atomic_read(&instance->adprecovery) == MEGASAS_HW_CRITICAL_ERROR) {
 		dev_err(&instance->pdev->dev, "cannot recover from previous reset failures\n");
@@ -3056,31 +3055,30 @@ megasas_dump_sys_regs(void __iomem *reg_set, char *buf)
  * megasas_reset_bus_host -	Bus & host reset handler entry point
  * @scmd:			Mid-layer SCSI command
  */
-static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
+static int megasas_reset_bus_host(struct Scsi_Host *shost)
 {
 	int ret;
 	struct megasas_instance *instance;
 
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = (struct megasas_instance *)shost->hostdata;
 
-	scmd_printk(KERN_INFO, scmd,
+	shost_printk(KERN_INFO, shost,
 		"OCR is requested due to IO timeout!!\n");
 
-	scmd_printk(KERN_INFO, scmd,
-		"SCSI host state: %d  SCSI host busy: %d  FW outstanding: %d\n",
-		scmd->device->host->shost_state,
-		scsi_host_busy(scmd->device->host),
+	shost_printk(KERN_INFO, shost,
+		"Controller reset is requested due to IO timeout\n"
+		"SCSI host state: %d\t"
+		" SCSI host busy: %d\t FW outstanding: %d\n",
+		shost->shost_state,
+		scsi_host_busy(shost),
 		atomic_read(&instance->fw_outstanding));
 	/*
 	 * First wait for all commands to complete
 	 */
-	if (instance->adapter_type == MFI_SERIES) {
-		ret = megasas_generic_reset(scmd);
-	} else {
-		megasas_dump_fusion_io(scmd);
-		ret = megasas_reset_fusion(scmd->device->host,
-				SCSIIO_TIMEOUT_OCR);
-	}
+	if (instance->adapter_type == MFI_SERIES)
+		ret = megasas_generic_reset(shost);
+	else
+		ret = megasas_reset_fusion(shost, SCSIIO_TIMEOUT_OCR);
 
 	return ret;
 }
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index e276583c590c..4a7cab3edbdb 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1699,9 +1699,9 @@ static int mesh_abort(struct scsi_cmnd *cmd)
  * The midlayer will wait for devices to come back, we don't need
  * to do that ourselves
  */
-static int mesh_host_reset(struct scsi_cmnd *cmd)
+static int mesh_host_reset(struct Scsi_Host *shost)
 {
-	struct mesh_state *ms = (struct mesh_state *) cmd->device->host->hostdata;
+	struct mesh_state *ms = (struct mesh_state *) shost->hostdata;
 	volatile struct mesh_regs __iomem *mr = ms->mesh;
 	volatile struct dbdma_regs __iomem *md = ms->dma;
 	unsigned long flags;
@@ -1718,7 +1718,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 	out_8(&mr->exception, 0xff);	/* clear all exception bits */
 	out_8(&mr->error, 0xff);	/* clear all error bits */
 	out_8(&mr->sequence, SEQ_RESETMESH);
-       	mesh_flush_io(mr);
+	mesh_flush_io(mr);
 	udelay(1);
 	out_8(&mr->intr_mask, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
 	out_8(&mr->source_id, ms->host->this_id);
@@ -1727,13 +1727,13 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 
 	/* Reset the bus */
 	out_8(&mr->bus_status1, BS1_RST);	/* assert RST */
-       	mesh_flush_io(mr);
+	mesh_flush_io(mr);
 	udelay(30);			/* leave it on for >= 25us */
 	out_8(&mr->bus_status1, 0);	/* negate RST */
 
 	/* Complete pending commands */
 	handle_reset(ms);
-	
+
 	spin_unlock_irqrestore(ms->host->host_lock, flags);
 	return SUCCESS;
 }
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 040031eb0c12..d52412870b54 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4010,15 +4010,15 @@ static inline void mpi3mr_setup_divert_ws(struct mpi3mr_ioc *mrioc,
 
 /**
  * mpi3mr_eh_host_reset - Host reset error handling callback
- * @scmd: SCSI command reference
+ * @shost: SCSI host reference
  *
  * Issue controller reset
  *
  * Return: SUCCESS of successful reset else FAILED
  */
-static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
+static int mpi3mr_eh_host_reset(struct Scsi_Host *shost)
 {
-	struct mpi3mr_ioc *mrioc = shost_priv(scmd->device->host);
+	struct mpi3mr_ioc *mrioc = shost_priv(shost);
 	int retval = FAILED, ret;
 
 	ret = mpi3mr_soft_reset_handler(mrioc,
@@ -4028,9 +4028,9 @@ static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
 
 	retval = SUCCESS;
 out:
-	sdev_printk(KERN_INFO, scmd->device,
-	    "Host reset is %s for scmd(%p)\n",
-	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	shost_printk(KERN_INFO, shost,
+	    "Host reset is %s\n",
+	    ((retval == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	return retval;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c3c1f466fe01..8344ea122477 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3525,13 +3525,12 @@ scsih_target_reset(struct scsi_cmnd *scmd)
  * Return: SUCCESS if command aborted else FAILED
  */
 static int
-scsih_host_reset(struct scsi_cmnd *scmd)
+scsih_host_reset(struct Scsi_Host *shost)
 {
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	int r, retval;
 
-	ioc_info(ioc, "attempting host reset! scmd(0x%p)\n", scmd);
-	scsi_print_command(scmd);
+	ioc_info(ioc, "attempting host reset\n");
 
 	if (ioc->is_driver_loading || ioc->remove_host) {
 		ioc_info(ioc, "Blocking the host reset\n");
@@ -3542,8 +3541,8 @@ scsih_host_reset(struct scsi_cmnd *scmd)
 	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
 out:
-	ioc_info(ioc, "host reset: %s scmd(0x%p)\n",
-		 r == SUCCESS ? "SUCCESS" : "FAILED", scmd);
+	ioc_info(ioc, "host reset: %s\n",
+		 r == SUCCESS ? "SUCCESS" : "FAILED");
 
 	return r;
 }
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index d9d366ec17dc..905d53a17d79 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -695,14 +695,13 @@ static int mvumi_reset_host_9143(struct mvumi_hba *mhba)
 	return mvumi_wait_for_outstanding(mhba);
 }
 
-static int mvumi_host_reset(struct scsi_cmnd *scmd)
+static int mvumi_host_reset(struct Scsi_Host *shost)
 {
 	struct mvumi_hba *mhba;
 
-	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
+	mhba = (struct mvumi_hba *) shost->hostdata;
 
-	scmd_printk(KERN_NOTICE, scmd, "RESET -%u cmd=%x retries=%x\n",
-			scsi_cmd_to_rq(scmd)->tag, scmd->cmnd[0], scmd->retries);
+	shost_printk(KERN_NOTICE, shost, "RESET\n");
 
 	return mhba->instancet->reset_host(mhba);
 }
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index ca2e932dd9b7..2b81a39e910f 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1252,9 +1252,8 @@ static void myrb_cleanup(struct myrb_hba *cb)
 	scsi_host_put(cb->host);
 }
 
-static int myrb_host_reset(struct scsi_cmnd *scmd)
+static int myrb_host_reset(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = scmd->device->host;
 	struct myrb_hba *cb = shost_priv(shost);
 
 	cb->reset(cb->io_base);
diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index a1eec65a9713..2f2470fdfb86 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -1529,9 +1529,8 @@ ATTRIBUTE_GROUPS(myrs_shost);
 /*
  * SCSI midlayer interface
  */
-static int myrs_host_reset(struct scsi_cmnd *scmd)
+static int myrs_host_reset(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = scmd->device->host;
 	struct myrs_hba *cs = shost_priv(shost);
 
 	cs->reset(cs->io_base);
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index b7987019686e..38fce90e1780 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -191,7 +191,7 @@ static int	   nsp32_release     (struct Scsi_Host *);
 
 /* SCSI error handler */
 static int	   nsp32_eh_abort     (struct scsi_cmnd *);
-static int	   nsp32_eh_host_reset(struct scsi_cmnd *);
+static int	   nsp32_eh_host_reset(struct Scsi_Host *);
 
 /* generate SCSI message */
 static void nsp32_build_identify(struct scsi_cmnd *);
@@ -2876,23 +2876,21 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	data->CurrentSC = NULL;
 }
 
-static int nsp32_eh_host_reset(struct scsi_cmnd *SCpnt)
+static int nsp32_eh_host_reset(struct Scsi_Host *host)
 {
-	struct Scsi_Host *host = SCpnt->device->host;
-	unsigned int      base = SCpnt->device->host->io_port;
+	unsigned int      base = host->io_port;
 	nsp32_hw_data    *data = (nsp32_hw_data *)host->hostdata;
 
 	nsp32_msg(KERN_INFO, "Host Reset");
-	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
 
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(host->host_lock);
 
 	nsp32hw_init(data);
 	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
 	nsp32_do_bus_reset(data);
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(host->host_lock);
 	return SUCCESS;	/* Host reset is succeeded at any time. */
 }
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index a5a1406a2bde..104647a6170e 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1495,9 +1495,9 @@ static int nsp_eh_bus_reset(struct scsi_cmnd *SCpnt)
 	return nsp_bus_reset(data);
 }
 
-static int nsp_eh_host_reset(struct scsi_cmnd *SCpnt)
+static int nsp_eh_host_reset(struct Scsi_Host *host)
 {
-	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	nsp_hw_data *data = (nsp_hw_data *)host->hostdata;
 
 	nsp_dbg(NSP_DEBUG_BUSRESET, "in");
 
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index e1ee8ef90ad3..f532adb5f166 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -300,7 +300,7 @@ static int nsp_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *SCpnt);
 /*static int nsp_eh_abort       (struct scsi_cmnd *SCpnt);*/
 /*static int nsp_eh_device_reset(struct scsi_cmnd *SCpnt);*/
 static int nsp_eh_bus_reset    (struct scsi_cmnd *SCpnt);
-static int nsp_eh_host_reset   (struct scsi_cmnd *SCpnt);
+static int nsp_eh_host_reset   (struct Scsi_Host *host);
 static int nsp_bus_reset       (nsp_hw_data *data);
 
 /* */
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 310d0b6586a6..59893db166c9 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -270,8 +270,8 @@ static int qlogic_resume(struct pcmcia_device *link)
 		outb(0x24, link->resource[0]->start + 0x9);
 		outb(0x04, link->resource[0]->start + 0xd);
 	}
-	/* Ugggglllyyyy!!! */
-	qlogicfas408_host_reset(NULL);
+
+	qlogicfas408_host_reset(info->host);
 
 	return 0;
 }
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 278c78d066c4..1c5415ede9b2 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -583,14 +583,14 @@ static int SYM53C500_queue_lck(struct scsi_cmnd *SCpnt)
 static DEF_SCSI_QCMD(SYM53C500_queue)
 
 static int 
-SYM53C500_host_reset(struct scsi_cmnd *SCpnt)
+SYM53C500_host_reset(struct Scsi_Host *shost)
 {
-	int port_base = SCpnt->device->host->io_port;
+	int port_base = shost->io_port;
 
 	DEB(printk("SYM53C500_host_reset called\n"));
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
 	SYM53C500_int_host_reset(port_base);
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(shost->host_lock);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index a831b34c08a4..4cf7a0b1c39f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3086,19 +3086,19 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 /**
  * pmcraid_eh_host_reset_handler - adapter reset handler callback
  *
- * @scmd: pointer to scsi_cmd that was sent to a resource of adapter
+ * @shost: pointer to scsi_host
  *
  * Initiates adapter reset to bring it up to operational state
  *
  * Return value
  *	SUCCESS or FAILED
  */
-static int pmcraid_eh_host_reset_handler(struct scsi_cmnd *scmd)
+static int pmcraid_eh_host_reset_handler(struct Scsi_Host *shost)
 {
 	unsigned long interval = 10000; /* 10 seconds interval */
 	int waits = jiffies_to_msecs(PMCRAID_RESET_HOST_TIMEOUT) / interval;
 	struct pmcraid_instance *pinstance =
-		(struct pmcraid_instance *)(scmd->device->host->hostdata);
+		(struct pmcraid_instance *)(shost->hostdata);
 
 
 	/* wait for an additional 150 seconds just in case firmware could come
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 19f0b93fa3d8..5974fde3ee2a 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -887,9 +887,9 @@ static void ppa_reset_pulse(unsigned int base)
 	w_ctr(base, 0xc);
 }
 
-static int ppa_reset(struct scsi_cmnd *cmd)
+static int ppa_reset(struct Scsi_Host *host)
 {
-	ppa_struct *dev = ppa_dev(cmd->device->host);
+	ppa_struct *dev = ppa_dev(host);
 
 	if (ppa_scsi_pointer(cmd)->phase)
 		ppa_disconnect(dev);
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 14c6731ec912..413a5a0da433 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -953,12 +953,12 @@ void qedf_ctx_soft_reset(struct fc_lport *lport)
 }
 
 /* Reset the host by gracefully logging out and then logging back in */
-static int qedf_eh_host_reset(struct scsi_cmnd *sc_cmd)
+static int qedf_eh_host_reset(struct Scsi_Host *shost)
 {
 	struct fc_lport *lport;
 	struct qedf_ctx *qedf;
 
-	lport = shost_priv(sc_cmd->device->host);
+	lport = shost_priv(shost);
 	qedf = lport_priv(lport);
 
 	if (atomic_read(&qedf->link_state) == QEDF_LINK_DOWN ||
diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
index 6ed8ef97642c..4b3df87cafdf 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -30,9 +30,8 @@ int qedi_recover_all_conns(struct qedi_ctx *qedi)
 	return SUCCESS;
 }
 
-static int qedi_eh_host_reset(struct scsi_cmnd *cmd)
+static int qedi_eh_host_reset(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = cmd->device->host;
 	struct qedi_ctx *qedi;
 
 	qedi = iscsi_host_priv(shost);
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 27bce80262c2..178f249057e7 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -995,10 +995,9 @@ qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
  *     Reset the specified adapter (both channels)
  **************************************************************************/
 static int
-qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
+qla1280_eh_adapter_reset(struct Scsi_Host *shost)
 {
 	int rc = SUCCESS;
-	struct Scsi_Host *shost = cmd->device->host;
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
 
 	spin_lock_irq(shost->host_lock);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 50db08265c51..bb0323d05640 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1655,8 +1655,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 *    The reset function will reset the Adapter.
 *
 * Input:
-*      cmd = Linux SCSI command packet of the command that cause the
-*            adapter reset.
+*      shost = Linux SCSI host to be reset
 *
 * Returns:
 *      Either SUCCESS or FAILED.
@@ -1664,13 +1663,11 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 * Note:
 **************************************************************************/
 static int
-qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_host_reset(struct Scsi_Host *shost)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
+	scsi_qla_host_t *vha = shost_priv(shost);
 	struct qla_hw_data *ha = vha->hw;
 	int ret = FAILED;
-	unsigned int id;
-	uint64_t lun;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	if (qla2x00_isp_reg_stat(ha)) {
@@ -1680,11 +1677,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		return SUCCESS;
 	}
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
-
 	ql_log(ql_log_info, vha, 0x8018,
-	    "ADAPTER RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no, id, lun);
+	    "ADAPTER RESET ISSUED host=%ld.\n", vha->host_no);
 
 	/*
 	 * No point in issuing another reset if one is active.  Also do not
@@ -1730,8 +1724,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 
 eh_host_reset_lock:
 	ql_log(ql_log_info, vha, 0x8017,
-	    "ADAPTER RESET %s nexus=%ld:%d:%llu.\n",
-	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
+	    "ADAPTER RESET %s host=%ld.\n",
+	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no);
 
 	return ret;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 961fe65bbe65..70757ef5b4fd 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -159,7 +159,7 @@ static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
-static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_host_reset(struct Scsi_Host *shost);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static umode_t qla4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
@@ -9421,18 +9421,18 @@ static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
 
 /**
  * qla4xxx_eh_host_reset - kernel callback
- * @cmd: Pointer to Linux's SCSI command structure
+ * @host: Pointer to Linux's SCSI host structure
  *
  * This routine is invoked by the Linux kernel to perform fatal error
  * recovery on the specified adapter.
  **/
-static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
+static int qla4xxx_eh_host_reset(struct Scsi_Host *host)
 {
 	int return_status = FAILED;
 	struct scsi_qla_host *ha;
 	int rval;
 
-	ha = to_qla_host(cmd->device->host);
+	ha = to_qla_host(host);
 
 	rval = qla4xxx_isp_check_reg(ha);
 	if (rval != QLA_SUCCESS) {
@@ -9454,20 +9454,18 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 		     ha->host_no, __func__));
 
 		/* Clear outstanding srb in queues */
-		if (qla4xxx_is_eh_active(cmd->device->host))
+		if (qla4xxx_is_eh_active(host))
 			qla4xxx_abort_active_cmds(ha, DID_ABORT << 16);
 
 		return FAILED;
 	}
 
 	ql4_printk(KERN_INFO, ha,
-		   "scsi(%ld:%d:%d:%llu): HOST RESET ISSUED.\n", ha->host_no,
-		   cmd->device->channel, cmd->device->id, cmd->device->lun);
+		   "scsi%ld: HOST RESET ISSUED.\n", ha->host_no);
 
 	if (qla4xxx_wait_for_hba_online(ha) != QLA_SUCCESS) {
-		DEBUG2(printk("scsi%ld:%d: %s: Unable to reset host.  Adapter "
-			      "DEAD.\n", ha->host_no, cmd->device->channel,
-			      __func__));
+		DEBUG2(printk("scsi%ld: %s: Unable to reset host.  Adapter "
+			      "DEAD.\n", ha->host_no, __func__));
 
 		return FAILED;
 	}
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 3e065d5fc80c..008e908e3aff 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -525,20 +525,18 @@ int qlogicfas408_abort(struct scsi_cmnd *cmd)
 
 /*
  *	Reset SCSI bus
- *	FIXME: This function is invoked with cmd = NULL directly by
- *	the PCMCIA qlogic_stub code. This wants fixing
  */
 
-int qlogicfas408_host_reset(struct scsi_cmnd *cmd)
+int qlogicfas408_host_reset(struct Scsi_Host *host)
 {
-	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	struct qlogicfas408_priv *priv = get_priv_by_host(host);
 	unsigned long flags;
 
 	priv->qabort = 2;
 
-	spin_lock_irqsave(cmd->device->host->host_lock, flags);
+	spin_lock_irqsave(host->host_lock, flags);
 	ql_zap(priv);
-	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
+	spin_unlock_irqrestore(host->host_lock, flags);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
index a971db11d293..c1b6e9fea9ce 100644
--- a/drivers/scsi/qlogicfas408.h
+++ b/drivers/scsi/qlogicfas408.h
@@ -109,7 +109,7 @@ int qlogicfas408_biosparam(struct scsi_device * disk,
 			   struct block_device *dev,
 			   sector_t capacity, int ip[]);
 int qlogicfas408_abort(struct scsi_cmnd * cmd);
-extern int qlogicfas408_host_reset(struct scsi_cmnd *cmd);
+extern int qlogicfas408_host_reset(struct Scsi_Host *host);
 const char *qlogicfas408_info(struct Scsi_Host *host);
 int qlogicfas408_get_chip_type(int qbase, int int_type);
 void qlogicfas408_setup(int qbase, int id, int int_type);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 3b95f7a6216f..b7c16bd49f23 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1261,10 +1261,9 @@ static int qlogicpti_abort(struct scsi_cmnd *Cmnd)
 	return return_status;
 }
 
-static int qlogicpti_reset(struct scsi_cmnd *Cmnd)
+static int qlogicpti_reset(struct Scsi_Host *host)
 {
 	u_short param[6];
-	struct Scsi_Host *host = Cmnd->device->host;
 	struct qlogicpti *qpti = (struct qlogicpti *) host->hostdata;
 	int return_status = SUCCESS;
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9c0af50501f9..fff18af80068 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5371,7 +5371,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
+static int scsi_debug_host_reset(struct Scsi_Host *shost)
 {
 	struct sdebug_host_info *sdbg_host;
 	struct sdebug_dev_info *devip;
@@ -5379,9 +5379,11 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 
 	++num_host_resets;
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, SCpnt->device, "%s\n", __func__);
+		shost_printk(KERN_INFO, shost, "%s\n", __func__);
 	mutex_lock(&sdebug_host_list_mutex);
 	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+		if (sdbg_host->shost != shost)
+			continue;
 		list_for_each_entry(devip, &sdbg_host->dev_info_list,
 				    dev_list) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
@@ -5391,7 +5393,7 @@ static int scsi_debug_host_reset(struct scsi_cmnd *SCpnt)
 	mutex_unlock(&sdebug_host_list_mutex);
 	stop_all_queued();
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, SCpnt->device,
+		shost_printk(KERN_INFO, shost,
 			    "%s: %d device(s) found\n", __func__, k);
 	return SUCCESS;
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..f022bb1c3e4a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -881,7 +881,7 @@ static enum scsi_disposition scsi_try_host_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_host_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_host_reset_handler(scmd);
+	rtn = hostt->eh_host_reset_handler(host);
 
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 0b7411624bcf..27acc50bd1a5 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -365,8 +365,7 @@ extern const struct attribute_group *snic_host_groups[];
 int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
 int snic_device_reset(struct scsi_cmnd *);
-int snic_host_reset(struct scsi_cmnd *);
-int snic_reset(struct Scsi_Host *);
+int snic_host_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
 
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 67b78029e557..c167fe55226e 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2250,8 +2250,15 @@ snic_issue_hba_reset(struct snic *snic)
 	return ret;
 } /* end of snic_issue_hba_reset */
 
+/*
+ * SCSI Error handling calls driver's eh_host_reset if all prior
+ * error handling levels return FAILED.
+ *
+ * Host Reset is the highest level of error recovery. If this fails, then
+ * host is offlined by SCSI.
+ */
 int
-snic_reset(struct Scsi_Host *shost)
+snic_host_reset(struct Scsi_Host *shost)
 {
 	struct snic *snic = shost_priv(shost);
 	enum snic_state sv_state;
@@ -2297,34 +2304,6 @@ snic_reset(struct Scsi_Host *shost)
 	ret = SUCCESS;
 
 reset_end:
-	return ret;
-} /* end of snic_reset */
-
-/*
- * SCSI Error handling calls driver's eh_host_reset if all prior
- * error handling levels return FAILED.
- *
- * Host Reset is the highest level of error recovery. If this fails, then
- * host is offlined by SCSI.
- */
-int
-snic_host_reset(struct scsi_cmnd *sc)
-{
-	struct Scsi_Host *shost = sc->device->host;
-	u32 start_time  = jiffies;
-	int ret;
-
-	SNIC_SCSI_DBG(shost,
-		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
-		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
-		      snic_cmd_tag(sc), CMD_FLAGS(sc));
-
-	ret = snic_reset(shost);
-
-	SNIC_TRC(shost->host_no, snic_cmd_tag(sc), (ulong) sc,
-		 jiffies_to_msecs(jiffies - start_time),
-		 0, SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
-
 	return ret;
 } /* end of snic_host_reset */
 
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 8ffb75be99bc..5e5ecea265ad 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1438,14 +1438,13 @@ static int stex_do_reset(struct st_hba *hba)
 	return -1;
 }
 
-static int stex_reset(struct scsi_cmnd *cmd)
+static int stex_reset(struct Scsi_Host *shost)
 {
 	struct st_hba *hba;
 
-	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
+	hba = (struct st_hba *) &shost->hostdata[0];
 
-	shost_printk(KERN_INFO, cmd->device->host,
-		     "resetting host\n");
+	shost_printk(KERN_INFO, shost, "resetting host\n");
 
 	return stex_do_reset(hba) ? FAILED : SUCCESS;
 }
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a95936b18f69..7a71d0526f6d 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1624,9 +1624,9 @@ static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 	return 0;
 }
 
-static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
+static int storvsc_host_reset_handler(struct Scsi_Host *shost)
 {
-	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
+	struct hv_host_device *host_dev = shost_priv(shost);
 	struct hv_device *device = host_dev->dev;
 
 	struct storvsc_device *stor_device;
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index a2560cc807d3..2ecc0ed60084 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -693,9 +693,8 @@ static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 	return SCSI_SUCCESS;
 }
 
-static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_host_reset_handler(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = cmd->device->host;
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
 	struct sym_hcb *np = sym_data->ncb;
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index f88ecdb93a8a..ddf1837babc0 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -894,14 +894,13 @@ static void pvscsi_reset_all(struct pvscsi_adapter *adapter)
 	}
 }
 
-static int pvscsi_host_reset(struct scsi_cmnd *cmd)
+static int pvscsi_host_reset(struct Scsi_Host *host)
 {
-	struct Scsi_Host *host = cmd->device->host;
 	struct pvscsi_adapter *adapter = shost_priv(host);
 	unsigned long flags;
 	bool use_msg;
 
-	scmd_printk(KERN_INFO, cmd, "SCSI Host reset\n");
+	shost_printk(KERN_INFO, host, "SCSI Host reset\n");
 
 	spin_lock_irqsave(&adapter->hw_lock, flags);
 
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index e4fafc77bd20..5fe972dd01cf 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1508,13 +1508,11 @@ reset_wd33c93(struct Scsi_Host *instance)
 }
 
 int
-wd33c93_host_reset(struct scsi_cmnd * SCpnt)
+wd33c93_host_reset(struct Scsi_Host * instance)
 {
-	struct Scsi_Host *instance;
 	struct WD33C93_hostdata *hostdata;
 	int i;
 
-	instance = SCpnt->device->host;
 	spin_lock_irq(instance->host_lock);
 	hostdata = (struct WD33C93_hostdata *) instance->hostdata;
 
@@ -1539,7 +1537,6 @@ wd33c93_host_reset(struct scsi_cmnd * SCpnt)
 	hostdata->outgoing_len = 0;
 
 	reset_wd33c93(instance);
-	SCpnt->result = DID_RESET << 16;
 	enable_irq(instance->irq);
 	spin_unlock_irq(instance->host_lock);
 	return SUCCESS;
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index e5e4254b1477..e3c2d3850f74 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -336,6 +336,6 @@ int wd33c93_queuecommand (struct Scsi_Host *h, struct scsi_cmnd *cmd);
 void wd33c93_intr (struct Scsi_Host *instance);
 int wd33c93_show_info(struct seq_file *, struct Scsi_Host *);
 int wd33c93_write_info(struct Scsi_Host *, char *, int);
-int wd33c93_host_reset (struct scsi_cmnd *);
+int wd33c93_host_reset (struct Scsi_Host *);
 
 #endif /* WD33C93_H */
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 5a380eecfc75..42134f9510d5 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -520,9 +520,9 @@ static int wd719x_bus_reset(struct scsi_cmnd *cmd)
 	return wd719x_reset(cmd, WD719X_CMD_BUSRESET, 0);
 }
 
-static int wd719x_host_reset(struct scsi_cmnd *cmd)
+static int wd719x_host_reset(struct Scsi_Host *host)
 {
-	struct wd719x *wd = shost_priv(cmd->device->host);
+	struct wd719x *wd = shost_priv(host);
 	struct wd719x_scb *scb, *tmp;
 	unsigned long flags;
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 93417518c04d..6ccf4d949171 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -264,7 +264,7 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 static irqreturn_t ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
-static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
+static int ufshcd_eh_host_reset_handler(struct Scsi_Host *shost);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool init_dev_params);
@@ -7707,13 +7707,13 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
  *
  * Return: SUCCESS or FAILED.
  */
-static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int ufshcd_eh_host_reset_handler(struct Scsi_Host *shost)
 {
 	int err = SUCCESS;
 	unsigned long flags;
 	struct ufs_hba *hba;
 
-	hba = shost_priv(cmd->device->host);
+	hba = shost_priv(shost);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->force_reset = true;
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 8c8fa71c69c4..10cd299d2e7d 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -345,9 +345,9 @@ static int mts_scsi_abort(struct scsi_cmnd *srb)
 	return FAILED;
 }
 
-static int mts_scsi_host_reset(struct scsi_cmnd *srb)
+static int mts_scsi_host_reset(struct Scsi_Host *shost)
 {
-	struct mts_desc* desc = (struct mts_desc*)(srb->device->host->hostdata[0]);
+	struct mts_desc* desc = (struct mts_desc*)(shost->hostdata[0]);
 	int result;
 
 	MTS_DEBUG_GOT_HERE();
diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index eca6fd42d7f7..dd71e198b360 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -950,7 +950,7 @@ void fc_fcp_destroy(struct fc_lport *);
 int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fc_eh_abort(struct scsi_cmnd *);
 int fc_eh_device_reset(struct scsi_cmnd *);
-int fc_eh_host_reset(struct scsi_cmnd *);
+int fc_eh_host_reset(struct Scsi_Host *);
 int fc_slave_alloc(struct scsi_device *);
 
 /*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 49f768d0ff37..9e3ec411cdc6 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -153,7 +153,7 @@ struct scsi_host_template {
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
 	int (* eh_target_reset_handler)(struct scsi_cmnd *);
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
-	int (* eh_host_reset_handler)(struct scsi_cmnd *);
+	int (* eh_host_reset_handler)(struct Scsi_Host *);
 
 	/*
 	 * Before the mid layer attempts to scan for a new device where none
-- 
2.35.3

