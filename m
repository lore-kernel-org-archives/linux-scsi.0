From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 14/47] scsi: Use Scsi_Host as argument for eh_host_reset_handler
Date: Wed, 28 Jun 2017 10:32:40 +0200
Message-ID: <1498638793-44672-15-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53814 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751580AbdF1IdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:21 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Issuing a host reset should not rely on any commands.
So use Scsi_Host as argument for eh_host_reset_handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_eh.txt                  |  2 +-
 Documentation/scsi/scsi_mid_low_api.txt         |  4 +--
 arch/ia64/hp/sim/simscsi.c                      |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c             |  6 ++--
 drivers/message/fusion/mptscsih.c               | 21 +++++++------
 drivers/message/fusion/mptscsih.h               |  2 +-
 drivers/s390/scsi/zfcp_scsi.c                   |  3 +-
 drivers/scsi/3w-9xxx.c                          | 11 +++----
 drivers/scsi/3w-sas.c                           | 11 +++----
 drivers/scsi/3w-xxxx.c                          | 11 ++++---
 drivers/scsi/53c700.c                           | 39 +++++++++++++------------
 drivers/scsi/BusLogic.c                         | 14 +++------
 drivers/scsi/NCR5380.c                          |  5 ++--
 drivers/scsi/NCR53c406a.c                       |  6 ++--
 drivers/scsi/aacraid/linit.c                    |  6 ++--
 drivers/scsi/advansys.c                         | 26 +++++++++--------
 drivers/scsi/aha152x.c                          | 11 +------
 drivers/scsi/aha152x.h                          |  2 +-
 drivers/scsi/aha1542.c                          | 17 +++++------
 drivers/scsi/arm/fas216.c                       |  4 +--
 drivers/scsi/arm/fas216.h                       |  6 ++--
 drivers/scsi/atari_scsi.c                       |  4 +--
 drivers/scsi/cxlflash/main.c                    | 13 ++-------
 drivers/scsi/dpt_i2o.c                          | 14 ++++-----
 drivers/scsi/dpti.h                             |  2 +-
 drivers/scsi/eata.c                             | 10 ++-----
 drivers/scsi/eata_pio.c                         | 29 +++++++++---------
 drivers/scsi/esas2r/esas2r.h                    |  2 +-
 drivers/scsi/esas2r/esas2r_main.c               | 16 +++++-----
 drivers/scsi/esp_scsi.c                         |  4 +--
 drivers/scsi/fdomain.c                          |  2 +-
 drivers/scsi/fdomain.h                          |  2 +-
 drivers/scsi/fnic/fnic.h                        |  2 +-
 drivers/scsi/fnic/fnic_scsi.c                   |  3 +-
 drivers/scsi/hptiop.c                           |  6 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c                  |  4 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c                |  4 +--
 drivers/scsi/imm.c                              |  6 ++--
 drivers/scsi/ipr.c                              |  4 +--
 drivers/scsi/ips.c                              | 23 +++++----------
 drivers/scsi/libfc/fc_fcp.c                     |  5 ++--
 drivers/scsi/lpfc/lpfc_scsi.c                   |  3 +-
 drivers/scsi/mac53c94.c                         |  8 ++---
 drivers/scsi/megaraid.c                         |  4 +--
 drivers/scsi/megaraid.h                         |  2 +-
 drivers/scsi/megaraid/megaraid_mbox.c           | 14 +++------
 drivers/scsi/megaraid/megaraid_sas_base.c       | 28 +++++++-----------
 drivers/scsi/mesh.c                             | 10 +++----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c            | 13 ++++-----
 drivers/scsi/mvumi.c                            |  7 ++---
 drivers/scsi/nsp32.c                            | 12 ++++----
 drivers/scsi/pcmcia/aha152x_stub.c              |  2 +-
 drivers/scsi/pcmcia/nsp_cs.c                    |  4 +--
 drivers/scsi/pcmcia/qlogic_stub.c               |  4 +--
 drivers/scsi/pcmcia/sym53c500_cs.c              |  8 ++---
 drivers/scsi/pmcraid.c                          |  6 ++--
 drivers/scsi/ppa.c                              |  6 ++--
 drivers/scsi/qedf/qedf_main.c                   |  4 +--
 drivers/scsi/qedi/qedi_iscsi.c                  |  3 +-
 drivers/scsi/qla1280.c                          |  3 +-
 drivers/scsi/qla2xxx/qla_os.c                   | 20 +++++--------
 drivers/scsi/qla4xxx/ql4_os.c                   | 18 +++++-------
 drivers/scsi/qlogicfas408.c                     | 10 +++----
 drivers/scsi/qlogicfas408.h                     |  2 +-
 drivers/scsi/scsi_debug.c                       | 16 +++++-----
 drivers/scsi/scsi_error.c                       |  2 +-
 drivers/scsi/snic/snic.h                        |  3 +-
 drivers/scsi/snic/snic_scsi.c                   | 29 +++++-------------
 drivers/scsi/stex.c                             |  7 ++---
 drivers/scsi/storvsc_drv.c                      |  4 +--
 drivers/scsi/sym53c416.c                        | 16 ++++------
 drivers/scsi/sym53c8xx_2/sym_glue.c             |  3 +-
 drivers/scsi/ufs/ufshcd.c                       |  8 ++---
 drivers/scsi/vmw_pvscsi.c                       |  5 ++--
 drivers/scsi/wd33c93.c                          |  4 +--
 drivers/scsi/wd33c93.h                          |  2 +-
 drivers/scsi/wd719x.c                           |  4 +--
 drivers/staging/unisys/visorhba/visorhba_main.c |  4 +--
 drivers/usb/image/microtek.c                    |  4 +--
 include/scsi/libfc.h                            |  2 +-
 include/scsi/scsi_host.h                        |  2 +-
 81 files changed, 290 insertions(+), 380 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 11e447b..78cd6b9 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -208,7 +208,7 @@ considered to fail always.
 int (* eh_abort_handler)(struct scsi_cmnd *);
 int (* eh_device_reset_handler)(struct scsi_cmnd *);
 int (* eh_bus_reset_handler)(struct scsi_cmnd *);
-int (* eh_host_reset_handler)(struct scsi_cmnd *);
+int (* eh_host_reset_handler)(struct Scsi_Host *);
 
  Higher-severity actions are taken only when lower-severity actions
 cannot recover some of failed scmds.  Also, note that failure of the
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index 6338400..ad517d5 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -891,7 +891,7 @@ Details:
 
 /**
  *      eh_host_reset_handler - reset host (host bus adapter)
- *      @scp: SCSI host that contains this device should be reset
+ *      @shost: SCSI host that should be reset
  *
  *      Returns SUCCESS if command aborted else FAILED
  *
@@ -908,7 +908,7 @@ Details:
  *
  *      Optionally defined in: LLD
  **/
-     int eh_host_reset_handler(struct scsi_cmnd * scp)
+     int eh_host_reset_handler(struct Scsi_Host * shost)
 
 
 /**
diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 085047f..1bff66b 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -329,7 +329,7 @@ struct disk_stat {
 static DEF_SCSI_QCMD(simscsi_queuecommand)
 
 static int
-simscsi_host_reset (struct scsi_cmnd *sc)
+simscsi_host_reset (struct Scsi_Host *shost)
 {
 	printk(KERN_ERR "simscsi_host_reset: not implemented\n");
 	return 0;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 2354c74..588fc08 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2679,11 +2679,11 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
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
index 6ba07c7..0719d6d 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1902,15 +1902,15 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
 
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
@@ -1918,9 +1918,8 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
 	int		retval;
 
 	/*  If we can't locate the host to reset, then we failed. */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
-		printk(KERN_ERR MYNAM ": host reset: "
-		    "Can't locate host! (sc=%p)\n", SCpnt);
+	if ((hd = shost_priv(sh)) == NULL){
+		printk(KERN_ERR MYNAM ": host reset: Can't locate host!\n");
 		return FAILED;
 	}
 
@@ -1928,20 +1927,20 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
 	mptscsih_flush_running_cmds(hd);
 
 	ioc = hd->ioc;
-	printk(MYIOC_s_INFO_FMT "attempting host reset! (sc=%p)\n",
-	    ioc->name, SCpnt);
+	printk(MYIOC_s_INFO_FMT "attempting host reset!\n",
+	    ioc->name);
 
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-    retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
+	retval = mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
 	if (retval < 0)
 		status = FAILED;
 	else
 		status = SUCCESS;
 
-	printk(MYIOC_s_INFO_FMT "host reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	printk(MYIOC_s_INFO_FMT "host reset: %s\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
 
 	return status;
 }
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 2baeefd..6ab8254 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -121,7 +121,7 @@ extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
-extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
+extern int mptscsih_host_reset(struct Scsi_Host *sh);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
 extern int mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3d18659..d7d4a63 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -309,9 +309,8 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 	return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
 }
 
-static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
+static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
 {
-	struct Scsi_Host *host = scpnt->device->host;
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
 	int ret = 0;
 	unsigned long flags;
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 00e7968..463e053 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1715,18 +1715,19 @@ static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
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
index b150e13..5edaa0f2 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1428,18 +1428,19 @@ static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
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
index 33261b6..f999e06 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1357,25 +1357,24 @@ static int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev
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
index 2b8cc32..9635d00 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -168,7 +168,7 @@
 
 STATIC int NCR_700_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *);
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
-STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
+STATIC int NCR_700_host_reset(struct Scsi_Host *host);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
@@ -1937,40 +1937,41 @@ STATIC DEF_SCSI_QCMD(NCR_700_queuecommand)
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
index 35380a5..44b0ec0 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2998,21 +2998,15 @@ static bool blogic_write_outbox(struct blogic_adapter *adapter,
 
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
index 429cb00..b77ce28 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2297,14 +2297,13 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 
 /**
  * NCR5380_host_reset - reset the SCSI host
- * @cmd: SCSI command undergoing EH
+ * @instance: SCSI host undergoing EH
  *
  * Returns SUCCESS
  */
 
-static int NCR5380_host_reset(struct scsi_cmnd *cmd)
+static int NCR5380_host_reset(struct Scsi_Host *instance)
 {
-	struct Scsi_Host *instance = cmd->device->host;
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	int i;
 	unsigned long flags;
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 6e110c6..002177e 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -728,11 +728,11 @@ static int NCR53c406a_queue_lck(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 
 static DEF_SCSI_QCMD(NCR53c406a_queue)
 
-static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
+static int NCR53c406a_host_reset(struct Scsi_Host * shost)
 {
 	DEB(printk("NCR53c406a_reset called\n"));
 
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
 
 	outb(C4_IMG, CONFIG4);	/* Select reg set 0 */
 	outb(CHIP_RESET, CMD_REG);
@@ -742,7 +742,7 @@ static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
 
 	rtrc(2);
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(shost->host_lock);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index c26130e..bef2c0d 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1051,13 +1051,11 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 
 /*
  *	aac_eh_host_reset	- Host reset command handling
- *	@scsi_cmd:	SCSI command block causing the reset
+ *	@host:	SCSI host to be reset
  *
  */
-int aac_eh_host_reset(struct scsi_cmnd *cmd)
+int aac_eh_host_reset(struct Scsi_Host *host)
 {
-	struct scsi_device * dev = cmd->device;
-	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	int ret = FAILED;
 	__le32 supported_options2 = 0;
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 24e57e7..7e7b203 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -7108,9 +7108,8 @@ static int AscISR(ASC_DVC_VAR *asc_dvc)
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
@@ -7120,7 +7119,7 @@ static int advansys_reset(struct scsi_cmnd *scp)
 
 	ASC_STATS(shost, reset);
 
-	scmd_printk(KERN_INFO, scp, "SCSI host reset started...\n");
+	shost_printk(KERN_INFO, shost, "SCSI host reset started...\n");
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
@@ -7131,16 +7130,18 @@ static int advansys_reset(struct scsi_cmnd *scp)
 
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
@@ -7157,12 +7158,13 @@ static int advansys_reset(struct scsi_cmnd *scp)
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
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 21e9d7c..857884a 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1205,7 +1205,7 @@ static void reset_ports(struct Scsi_Host *shpnt)
  * Reset the host (bus and controller)
  *
  */
-int aha152x_host_reset_host(struct Scsi_Host *shpnt)
+int aha152x_host_reset(struct Scsi_Host *shpnt)
 {
 	aha152x_bus_reset_host(shpnt);
 	reset_ports(shpnt);
@@ -1214,15 +1214,6 @@ int aha152x_host_reset_host(struct Scsi_Host *shpnt)
 }
 
 /*
- * Reset the host (bus and controller)
- *
- */
-static int aha152x_host_reset(Scsi_Cmnd *SCpnt)
-{
-	return aha152x_host_reset_host(SCpnt->device->host);
-}
-
-/*
  * Return the "logical geometry"
  *
  */
diff --git a/drivers/scsi/aha152x.h b/drivers/scsi/aha152x.h
index ac4bfa438b..3ccf724 100644
--- a/drivers/scsi/aha152x.h
+++ b/drivers/scsi/aha152x.h
@@ -332,6 +332,6 @@ struct aha152x_setup {
 
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
 void aha152x_release(struct Scsi_Host *);
-int aha152x_host_reset_host(struct Scsi_Host *);
+int aha152x_host_reset(struct Scsi_Host *);
 
 #endif /* _AHA152X_H */
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index a23cc9a..3d4c404 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -849,9 +849,8 @@ static int aha1542_dev_reset(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
+static int aha1542_reset(struct Scsi_Host *sh, u8 reset_cmd)
 {
-	struct Scsi_Host *sh = cmd->device->host;
 	struct aha1542_hostdata *aha1542 = shost_priv(sh);
 	unsigned long flags;
 	int i;
@@ -863,9 +862,9 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
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
@@ -876,7 +875,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	 * us again after host reset.
 	 */
 	if (reset_cmd & HRST)
-		setup_mailboxes(cmd->device->host);
+		setup_mailboxes(sh);
 
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
@@ -884,7 +883,7 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 	 * out.  We do not try and restart any commands or anything - 
 	 * the strategy handler takes care of that crap.
 	 */
-	shost_printk(KERN_WARNING, cmd->device->host, "Sent BUS RESET to scsi host %d\n", cmd->device->host->host_no);
+	shost_printk(KERN_WARNING, sh, "Sent BUS RESET to scsi host %d\n", cmd->device->host->host_no);
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
 		if (aha1542->int_cmds[i] != NULL) {
@@ -913,12 +912,12 @@ static int aha1542_reset(struct scsi_cmnd *cmd, u8 reset_cmd)
 
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
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 2438879..e4a08e8 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2650,9 +2650,9 @@ static void fas216_init_chip(FAS216_Info *info)
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
index c57c16e..e0e74ee 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -383,11 +383,11 @@
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
index 89f5154..d524dde 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -671,7 +671,7 @@ static void atari_scsi_falcon_reg_write(unsigned int reg, u8 value)
 
 #include "NCR5380.c"
 
-static int atari_scsi_host_reset(struct scsi_cmnd *cmd)
+static int atari_scsi_host_reset(struct Scsi_Host *shost)
 {
 	int rv;
 	unsigned long flags;
@@ -688,7 +688,7 @@ static int atari_scsi_host_reset(struct scsi_cmnd *cmd)
 		atari_dma_orig_addr = NULL;
 	}
 
-	rv = NCR5380_host_reset(cmd);
+	rv = NCR5380_host_reset(shost);
 
 	/* The 5380 raises its IRQ line while _RST is active but the ST DMA
 	 * "lock" has been released so this interrupt may end up handled by
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 7a787b6..462e8fc 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2466,7 +2466,7 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
 
 /**
  * cxlflash_eh_host_reset_handler() - reset the host adapter
- * @scp:	SCSI command from stack identifying host.
+ * @host:	SCSI host adapter.
  *
  * Following a reset, the state is evaluated again in case an EEH occurred
  * during the reset. In such a scenario, the host reset will either yield
@@ -2477,21 +2477,14 @@ static int cxlflash_eh_device_reset_handler(struct scsi_cmnd *scp)
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
 
-	dev_dbg(dev, "%s: (scp=%p) %d/%d/%d/%llu "
-		"cdb=(%08x-%08x-%08x-%08x)\n", __func__, scp, host->host_no,
-		scp->device->channel, scp->device->id, scp->device->lun,
-		get_unaligned_be32(&((u32 *)scp->cmnd)[0]),
-		get_unaligned_be32(&((u32 *)scp->cmnd)[1]),
-		get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
-		get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
+	dev_dbg(dev, "%s: %d/-1/-1/-1\n", __func__, host->host_no);
 
 	switch (cfg->state) {
 	case STATE_NORMAL:
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 256dd67..d28f4a4 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -797,12 +797,12 @@ static int adpt_bus_reset(struct scsi_cmnd* cmd)
 }
 
 // This version of reset is called by the eh_error_handler
-static int __adpt_reset(struct scsi_cmnd* cmd)
+static int __adpt_reset(struct Scsi_Host* shost)
 {
 	adpt_hba* pHba;
 	int rcode;
-	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
-	printk(KERN_WARNING"%s: Hba Reset: scsi id %d: tid: %d\n",pHba->name,cmd->device->channel,pHba->channel[cmd->device->channel].tid );
+	pHba = (adpt_hba*)shost->hostdata[0];
+	printk(KERN_WARNING"%s: Hba Reset\n",pHba->name);
 	rcode =  adpt_hba_reset(pHba);
 	if(rcode == 0){
 		printk(KERN_WARNING"%s: HBA reset complete\n",pHba->name);
@@ -813,13 +813,13 @@ static int __adpt_reset(struct scsi_cmnd* cmd)
 	}
 }
 
-static int adpt_reset(struct scsi_cmnd* cmd)
+static int adpt_reset(struct Scsi_Host* shost)
 {
 	int rc;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = __adpt_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
+	rc = __adpt_reset(shost);
+	spin_unlock_irq(shost->host_lock);
 
 	return rc;
 }
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index 1fa345a..ba88ceb 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -31,7 +31,7 @@
 static int adpt_detect(struct scsi_host_template * sht);
 static int adpt_queue(struct Scsi_Host *h, struct scsi_cmnd * cmd);
 static int adpt_abort(struct scsi_cmnd * cmd);
-static int adpt_reset(struct scsi_cmnd* cmd);
+static int adpt_reset(struct Scsi_Host * host);
 static int adpt_release(struct Scsi_Host *host);
 static int adpt_slave_configure(struct scsi_device *);
 
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 6501c33..187bfaf 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -507,7 +507,7 @@
 static int eata2x_release(struct Scsi_Host *);
 static int eata2x_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int eata2x_eh_abort(struct scsi_cmnd *);
-static int eata2x_eh_host_reset(struct scsi_cmnd *);
+static int eata2x_eh_host_reset(struct Scsi_Host *);
 static int eata2x_bios_param(struct scsi_device *, struct block_device *,
 			     sector_t, int *);
 static int eata2x_slave_configure(struct scsi_device *);
@@ -1896,20 +1896,16 @@ static int eata2x_eh_abort(struct scsi_cmnd *SCarg)
 	panic("%s: abort, mbox %d, invalid cp_stat.\n", ha->board_name, i);
 }
 
-static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
+static int eata2x_eh_host_reset(struct Scsi_Host *shost)
 {
 	unsigned int i, time, k, c, limit = 0;
 	struct scsi_cmnd *SCpnt;
-	struct Scsi_Host *shost = SCarg->device->host;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
 
-	scmd_printk(KERN_INFO, SCarg, "reset, enter.\n");
+	shost_printk(KERN_INFO, shost, "reset, enter.\n");
 
 	spin_lock_irq(shost->host_lock);
 
-	if (SCarg->host_scribble == NULL)
-		printk("%s: reset, inactive.\n", ha->board_name);
-
 	if (ha->in_reset) {
 		printk("%s: reset, exit, already in reset.\n", ha->board_name);
 		spin_unlock_irq(shost->host_lock);
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 4299fa4..bf42876 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -435,19 +435,18 @@ static int eata_pio_abort(struct scsi_cmnd *cmd)
 	panic("eata_pio: abort: invalid slot status\n");
 }
 
-static int eata_pio_host_reset(struct scsi_cmnd *cmd)
+static int eata_pio_host_reset(struct Scsi_Host *host)
 {
 	unsigned int x, limit = 0;
 	unsigned char success = 0;
 	struct scsi_cmnd *sp;
-	struct Scsi_Host *host = cmd->device->host;
 
-	DBG(DBG_ABNORM, scmd_printk(KERN_WARNING, cmd,
+	DBG(DBG_ABNORM, shost_printk(KERN_WARNING, host,
 		"eata_pio_reset called\n"));
 
 	spin_lock_irq(host->host_lock);
 
-	if (HD(cmd)->state == RESET) {
+	if (SD(host)->state == RESET) {
 		printk(KERN_WARNING "eata_pio_reset: exit, already in reset.\n");
 		spin_unlock_irq(host->host_lock);
 		return FAILED;
@@ -455,13 +454,13 @@ static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 
 	/* force all slots to be free */
 
-	for (x = 0; x < cmd->device->host->can_queue; x++) {
+	for (x = 0; x < host->can_queue; x++) {
 
-		if (HD(cmd)->ccb[x].status == FREE)
+		if (SD(host)->ccb[x].status == FREE)
 			continue;
 
-		sp = HD(cmd)->ccb[x].cmd;
-		HD(cmd)->ccb[x].status = RESET;
+		sp = SD(host)->ccb[x].cmd;
+		SD(host)->ccb[x].status = RESET;
 		printk(KERN_WARNING "eata_pio_reset: slot %d in reset.\n", x);
 
 		if (sp == NULL)
@@ -469,10 +468,10 @@ static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 	}
 
 	/* hard reset the HBA  */
-	outb(EATA_CMD_RESET, cmd->device->host->base + HA_WCOMMAND);
+	outb(EATA_CMD_RESET, host->base + HA_WCOMMAND);
 
 	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset: board reset done.\n"));
-	HD(cmd)->state = RESET;
+	SD(host)->state = RESET;
 
 	spin_unlock_irq(host->host_lock);
 	msleep(3000);
@@ -480,23 +479,23 @@ static int eata_pio_host_reset(struct scsi_cmnd *cmd)
 
 	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset: interrupts disabled, " "loops %d.\n", limit));
 
-	for (x = 0; x < cmd->device->host->can_queue; x++) {
+	for (x = 0; x < host->can_queue; x++) {
 
 		/* Skip slots already set free by interrupt */
-		if (HD(cmd)->ccb[x].status != RESET)
+		if (SD(host)->ccb[x].status != RESET)
 			continue;
 
-		sp = HD(cmd)->ccb[x].cmd;
+		sp = SD(host)->ccb[x].cmd;
 		sp->result = DID_RESET << 16;
 
 		/* This mailbox is terminated */
 		printk(KERN_WARNING "eata_pio_reset: reset ccb %d.\n", x);
-		HD(cmd)->ccb[x].status = FREE;
+		SD(host)->ccb[x].status = FREE;
 
 		sp->scsi_done(sp);
 	}
 
-	HD(cmd)->state = 0;
+	SD(host)->state = 0;
 
 	spin_unlock_irq(host->host_lock);
 
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index 1da6407..d130a59 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -977,7 +977,7 @@ u8 handle_hba_ioctl(struct esas2r_adapter *a,
 /* SCSI error handler (eh) functions */
 int esas2r_eh_abort(struct scsi_cmnd *cmd);
 int esas2r_device_reset(struct scsi_cmnd *cmd);
-int esas2r_host_reset(struct scsi_cmnd *cmd);
+int esas2r_host_reset(struct Scsi_Host *shost);
 int esas2r_bus_reset(struct scsi_cmnd *cmd);
 int esas2r_target_reset(struct scsi_cmnd *cmd);
 
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index f2e9d8a..4f6dbc8 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1122,10 +1122,10 @@ int esas2r_eh_abort(struct scsi_cmnd *cmd)
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
@@ -1150,18 +1150,20 @@ static int esas2r_host_bus_reset(struct scsi_cmnd *cmd, bool host_reset)
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
index 71cb05b..15185a0 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2655,9 +2655,9 @@ static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
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
index ebbe5a3..d0b9583 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1568,7 +1568,7 @@ static int fdomain_16x0_abort(struct scsi_cmnd *SCpnt)
    return SUCCESS;
 }
 
-int fdomain_16x0_host_reset(struct scsi_cmnd *SCpnt)
+int fdomain_16x0_host_reset(struct Scsi_Host *shost)
 {
    unsigned long flags;
 
diff --git a/drivers/scsi/fdomain.h b/drivers/scsi/fdomain.h
index 5cbe86b..85eab71 100644
--- a/drivers/scsi/fdomain.h
+++ b/drivers/scsi/fdomain.h
@@ -21,4 +21,4 @@
 extern struct scsi_host_template fdomain_driver_template;
 extern int fdomain_setup(char *str);
 extern struct Scsi_Host *__fdomain_16x0_detect(struct  scsi_host_template *tpnt );
-extern int fdomain_16x0_host_reset(struct scsi_cmnd *SCpnt);
+extern int fdomain_16x0_host_reset(struct Scsi_Host *shost);
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 67aab96..35a4080 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -343,7 +343,7 @@ static inline struct fnic *fnic_from_ctlr(struct fcoe_ctlr *fip)
 int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
 int fnic_device_reset(struct scsi_cmnd *);
-int fnic_host_reset(struct scsi_cmnd *);
+int fnic_host_reset(struct Scsi_Host *);
 int fnic_reset(struct Scsi_Host *);
 void fnic_scsi_cleanup(struct fc_lport *);
 void fnic_scsi_abort_io(struct fc_lport *);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 242e2ee..2716222 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2629,11 +2629,10 @@ int fnic_reset(struct Scsi_Host *shost)
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
index 2fad7f0..d8b78ba 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1104,12 +1104,12 @@ static int hptiop_reset_hba(struct hptiop_hba *hba)
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
index bb033ce..5dccf07 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2526,10 +2526,10 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
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
index 1deb0a9..262b30c 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1731,10 +1731,10 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
index 87c9419..5232dfb 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -986,11 +986,11 @@ static void imm_reset_pulse(unsigned int base)
 	w_ctr(base, 0x04);
 }
 
-static int imm_reset(struct scsi_cmnd *cmd)
+static int imm_reset(struct Scsi_Host *shost)
 {
-	imm_struct *dev = imm_dev(cmd->device->host);
+	imm_struct *dev = imm_dev(shost);
 
-	if (cmd->SCp.phase)
+	if (dev->cur_cmd->SCp.phase)
 		imm_disconnect(dev);
 	dev->cur_cmd = NULL;	/* Forget the problem */
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b0c68d2..2ab2a9e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5152,14 +5152,14 @@ static int ipr_wait_for_ops(struct ipr_ioa_cfg *ioa_cfg, void *device,
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
index 97d9cca..8507fb0 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -227,7 +227,7 @@
 static int ips_detect(struct scsi_host_template *);
 static int ips_release(struct Scsi_Host *);
 static int ips_eh_abort(struct scsi_cmnd *);
-static int ips_eh_reset(struct scsi_cmnd *);
+static int ips_eh_reset(struct Scsi_Host *);
 static int ips_queue(struct Scsi_Host *, struct scsi_cmnd *);
 static const char *ips_info(struct Scsi_Host *);
 static irqreturn_t do_ipsintr(int, void *);
@@ -834,13 +834,12 @@ int ips_eh_abort(struct scsi_cmnd *SC)
 /* NOTE: this routine is called under the io_request_lock spinlock          */
 /*                                                                          */
 /****************************************************************************/
-static int __ips_eh_reset(struct scsi_cmnd *SC)
+static int __ips_eh_reset(struct Scsi_Host *shost)
 {
 	int ret;
 	int i;
 	ips_ha_t *ha;
 	ips_scb_t *scb;
-	ips_copp_wait_item_t *item;
 
 	METHOD_TRACE("ips_eh_reset", 1);
 
@@ -848,13 +847,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
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
@@ -1003,13 +996,13 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
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
@@ -1088,7 +1081,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
-			__ips_eh_reset(SC);
+			__ips_eh_reset(SC->device->host);
 			SC->result = DID_OK << 16;
 			SC->scsi_done(SC);
 			return (0);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 772c35a..2ec903a 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2212,11 +2212,10 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 
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
index 19b1202..79981b9 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5310,9 +5310,8 @@ void lpfc_poll_timeout(unsigned long ptr)
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
index a6682c5..120a719 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -101,14 +101,14 @@ static int mac53c94_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cm
 
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
@@ -118,7 +118,7 @@ static int mac53c94_host_reset(struct scsi_cmnd *cmd)
 	mac53c94_init(state);
 	writeb(CMD_NOP, &regs->command);
 
-	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
+	spin_unlock_irqrestore(shost->host_lock, flags);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 7e504d3..f7a79f8 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1887,13 +1887,13 @@ static DEF_SCSI_QCMD(megaraid_queue)
 
 
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
index 508d65e..6fb6adf 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -963,7 +963,7 @@ struct mega_hbas {
 static void mega_free_scb(adapter_t *, scb_t *);
 
 static int megaraid_abort(Scsi_Cmnd *);
-static int megaraid_reset(Scsi_Cmnd *);
+static int megaraid_reset(struct Scsi_Host *);
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 3f914b1..85e8a2f 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -97,7 +97,7 @@
 static void megaraid_sysfs_free_resources(adapter_t *);
 
 static int megaraid_abort_handler(struct scsi_cmnd *);
-static int megaraid_reset_handler(struct scsi_cmnd *);
+static int megaraid_reset_handler(struct Scsi_Host *);
 
 static int mbox_post_sync_cmd(adapter_t *, uint8_t []);
 static int mbox_post_sync_cmd_fast(adapter_t *, uint8_t []);
@@ -2567,7 +2567,7 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
  * host.
  **/
 static int
-megaraid_reset_handler(struct scsi_cmnd *scp)
+megaraid_reset_handler(struct Scsi_Host *shost)
 {
 	adapter_t	*adapter;
 	scb_t		*scb;
@@ -2581,7 +2581,7 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 	int		i;
 	uioc_t		*kioc;
 
-	adapter		= SCP2ADAPTER(scp);
+	adapter		= (adapter_t *)SCSIHOST2ADAP(shost);
 	raid_dev	= ADAP2RAIDDEV(adapter);
 
 	// return failure if adapter is not responding
@@ -2613,15 +2613,9 @@ static DEF_SCSI_QCMD(megaraid_queue_command)
 
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
 			scb->scp->scsi_done(scb->scp);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 316c3df..89e3fd6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2691,15 +2691,14 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
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
@@ -2768,34 +2767,29 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 /**
  * megasas_reset_bus_host -	Bus & host reset handler entry point
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
 		"Controller reset is requested due to IO timeout\n"
-		"SCSI command pointer: (%p)\t SCSI host state: %d\t"
+		"SCSI host state: %d\t"
 		" SCSI host busy: %d\t FW outstanding: %d\n",
-		scmd, scmd->device->host->shost_state,
-		atomic_read((atomic_t *)&scmd->device->host->host_busy),
+		shost->shost_state,
+		atomic_read(&shost->host_busy),
 		atomic_read(&instance->fw_outstanding));
 
 	/*
 	 * First wait for all commands to complete
 	 */
 	if (instance->ctrl_context) {
-		struct megasas_cmd_fusion *cmd;
-		cmd = (struct megasas_cmd_fusion *)scmd->SCp.ptr;
-		if (cmd)
-			megasas_dump_frame(cmd->io_request,
-				sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
-		ret = megasas_reset_fusion(scmd->device->host,
+		ret = megasas_reset_fusion(shost,
 				SCSIIO_TIMEOUT_OCR);
 	} else
-		ret = megasas_generic_reset(scmd);
+		ret = megasas_generic_reset(shost);
 
 	return ret;
 }
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 1753e42..6067d3c 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1700,9 +1700,9 @@ static int mesh_abort(struct scsi_cmnd *cmd)
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
@@ -1716,7 +1716,7 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 	out_8(&mr->exception, 0xff);	/* clear all exception bits */
 	out_8(&mr->error, 0xff);	/* clear all error bits */
 	out_8(&mr->sequence, SEQ_RESETMESH);
-       	mesh_flush_io(mr);
+	mesh_flush_io(mr);
 	udelay(1);
 	out_8(&mr->intr_mask, INT_ERROR | INT_EXCEPTION | INT_CMDDONE);
 	out_8(&mr->source_id, ms->host->this_id);
@@ -1725,13 +1725,13 @@ static int mesh_host_reset(struct scsi_cmnd *cmd)
 
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
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 22998cb..6ecf672 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2643,14 +2643,13 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-scsih_host_reset(struct scsi_cmnd *scmd)
+scsih_host_reset(struct Scsi_Host *shost)
 {
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	int r, retval;
 
-	pr_info(MPT3SAS_FMT "attempting host reset! scmd(%p)\n",
-	    ioc->name, scmd);
-	scsi_print_command(scmd);
+	pr_info(MPT3SAS_FMT "attempting host reset!\n",
+	    ioc->name);
 
 	if (ioc->is_driver_loading) {
 		pr_info(MPT3SAS_FMT "Blocking the host reset\n",
@@ -2662,8 +2661,8 @@ int mpt3sas_scsih_issue_locked_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	retval = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
 out:
-	pr_info(MPT3SAS_FMT "host reset: %s scmd(%p)\n",
-	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	pr_info(MPT3SAS_FMT "host reset: %s\n",
+	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	return r;
 }
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index fe97401..d76b958 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -709,14 +709,13 @@ static int mvumi_reset_host_9143(struct mvumi_hba *mhba)
 	return mvumi_wait_for_outstanding(mhba);
 }
 
-static int mvumi_host_reset(struct scsi_cmnd *scmd)
+static int mvumi_host_reset(struct Scsi_Host *shost)
 {
 	struct mvumi_hba *mhba;
 
-	mhba = (struct mvumi_hba *) scmd->device->host->hostdata;
+	mhba = (struct mvumi_hba *) shost->hostdata;
 
-	scmd_printk(KERN_NOTICE, scmd, "RESET -%ld cmd=%x retries=%x\n",
-			scmd->serial_number, scmd->cmnd[0], scmd->retries);
+	shost_printk(KERN_NOTICE, shost, "RESET\n");
 
 	return mhba->instancet->reset_host(mhba);
 }
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 107e191..f511dd8 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2885,23 +2885,21 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
 	data->CurrentSC = NULL;
 }
 
-static int nsp32_eh_host_reset(struct scsi_cmnd *SCpnt)
+static int nsp32_eh_host_reset(struct Scsi_Host *host)
 {
-	struct Scsi_Host *host = SCpnt->device->host;
-	unsigned int      base = SCpnt->device->host->io_port;
+	unsigned int      base = host->io_port;
 	nsp32_hw_data    *data = (nsp32_hw_data *)host->hostdata;
 
-	nsp32_msg(KERN_INFO, "Host Reset");	
-	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
+	nsp32_msg(KERN_INFO, "Host Reset");
 
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
 
diff --git a/drivers/scsi/pcmcia/aha152x_stub.c b/drivers/scsi/pcmcia/aha152x_stub.c
index 7d1609f..f95abd9 100644
--- a/drivers/scsi/pcmcia/aha152x_stub.c
+++ b/drivers/scsi/pcmcia/aha152x_stub.c
@@ -197,7 +197,7 @@ static int aha152x_resume(struct pcmcia_device *link)
 {
 	scsi_info_t *info = link->priv;
 
-	aha152x_host_reset_host(info->host);
+	aha152x_host_reset(info->host);
 
 	return 0;
 }
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 5fb6eef..48ec923 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1485,9 +1485,9 @@ static int nsp_eh_bus_reset(struct scsi_cmnd *SCpnt)
 	return nsp_bus_reset(data);
 }
 
-static int nsp_eh_host_reset(struct scsi_cmnd *SCpnt)
+static int nsp_eh_host_reset(struct Scsi_Host *host)
 {
-	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	nsp_hw_data *data = (nsp_hw_data *)host->hostdata;
 
 	nsp_dbg(NSP_DEBUG_BUSRESET, "in");
 
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 0556054..ab68880 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -263,8 +263,8 @@ static int qlogic_resume(struct pcmcia_device *link)
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
index 20011c8..d0ee84c 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -586,14 +586,14 @@ enum Phase {
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
index 1cc814f..4b66b92 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3089,19 +3089,19 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
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
index 7be5823..0ce0f9a 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -857,11 +857,11 @@ static void ppa_reset_pulse(unsigned int base)
 	w_ctr(base, 0xc);
 }
 
-static int ppa_reset(struct scsi_cmnd *cmd)
+static int ppa_reset(struct Scsi_Host *shost)
 {
-	ppa_struct *dev = ppa_dev(cmd->device->host);
+	ppa_struct *dev = ppa_dev(shost);
 
-	if (cmd->SCp.phase)
+	if (dev->cur_cmd->SCp.phase)
 		ppa_disconnect(dev);
 	dev->cur_cmd = NULL;	/* Forget the problem */
 
diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index d48a13a..b06ef7c 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -666,12 +666,12 @@ static void qedf_ctx_soft_reset(struct fc_lport *lport)
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
index 87f0af3..3fa489e 100644
--- a/drivers/scsi/qedi/qedi_iscsi.c
+++ b/drivers/scsi/qedi/qedi_iscsi.c
@@ -33,9 +33,8 @@ int qedi_recover_all_conns(struct qedi_ctx *qedi)
 	return SUCCESS;
 }
 
-static int qedi_eh_host_reset(struct scsi_cmnd *cmd)
+static int qedi_eh_host_reset(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = cmd->device->host;
 	struct qedi_ctx *qedi;
 
 	qedi = iscsi_host_priv(shost);
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index d712bfe..c6240ce 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1033,10 +1033,9 @@ static void qla1280_mailbox_timeout(unsigned long __data)
  *     Reset the specified adapter (both channels)
  **************************************************************************/
 static int
-qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
+qla1280_eh_adapter_reset(struct Scsi_Host *shost)
 {
 	int rc;
-	struct Scsi_Host *shost = cmd->device->host;
 	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
 
 	spin_lock_irq(shost->host_lock);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index df57655..fe2ff0a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -275,7 +275,7 @@
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
-static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
+static int qla2xxx_eh_host_reset(struct Scsi_Host *);
 
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
@@ -1550,8 +1550,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 *    The reset function will reset the Adapter.
 *
 * Input:
-*      cmd = Linux SCSI command packet of the command that cause the
-*            adapter reset.
+*      shost = Linux SCSI host to be reset
 *
 * Returns:
 *      Either SUCCESS or FAILED.
@@ -1559,13 +1558,11 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
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
@@ -1575,11 +1572,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
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
@@ -1625,8 +1619,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 
 eh_host_reset_lock:
 	ql_log(ql_log_info, vha, 0x8017,
-	    "ADAPTER RESET %s nexus=%ld:%d:%llu.\n",
-	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
+	    "ADAPTER RESET %s host=%ld.\n",
+	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no);
 
 	return ret;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 64c6fa5..11bd2da 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -160,7 +160,7 @@ static int qla4xxx_set_chap_entry(struct Scsi_Host *shost, void  *data,
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
-static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_host_reset(struct Scsi_Host *shost);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static umode_t qla4_attr_is_visible(int param_type, int param);
 static int qla4xxx_host_reset(struct Scsi_Host *shost, int reset_type);
@@ -9367,17 +9367,17 @@ static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
 
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
 
-	ha = to_qla_host(cmd->device->host);
+	ha = to_qla_host(host);
 
 	if ((is_qla8032(ha) || is_qla8042(ha)) && ql4xdontresethba)
 		qla4_83xx_set_idc_dontreset(ha);
@@ -9393,20 +9393,18 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
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
index 8b471a9..83a17ef 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -498,20 +498,18 @@ int qlogicfas408_abort(struct scsi_cmnd *cmd)
 
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
index f6b1216..58459ba 100644
--- a/drivers/scsi/qlogicfas408.h
+++ b/drivers/scsi/qlogicfas408.h
@@ -108,7 +108,7 @@ int qlogicfas408_biosparam(struct scsi_device * disk,
 			   struct block_device *dev,
 			   sector_t capacity, int ip[]);
 int qlogicfas408_abort(struct scsi_cmnd * cmd);
-extern int qlogicfas408_host_reset(struct scsi_cmnd *cmd);
+extern int qlogicfas408_host_reset(struct Scsi_Host *host);
 const char *qlogicfas408_info(struct Scsi_Host *host);
 int qlogicfas408_get_chip_type(int qbase, int int_type);
 void qlogicfas408_setup(int qbase, int id, int int_type);
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index dc095a2..ebf525b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3878,27 +3878,27 @@ static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
 	return SUCCESS;
 }
 
-static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
+static int scsi_debug_host_reset(struct Scsi_Host * shost)
 {
 	struct sdebug_host_info * sdbg_host;
 	struct sdebug_dev_info *devip;
 	int k = 0;
 
 	++num_host_resets;
-	if ((SCpnt->device) && (SDEBUG_OPT_ALL_NOISE & sdebug_opts))
-		sdev_printk(KERN_INFO, SCpnt->device, "%s\n", __func__);
-        spin_lock(&sdebug_host_list_lock);
-        list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
+		shost_printk(KERN_INFO, shost, "%s\n", __func__);
+	spin_lock(&sdebug_host_list_lock);
+	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
 		list_for_each_entry(devip, &sdbg_host->dev_info_list,
 				    dev_list) {
 			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
 			++k;
 		}
-        }
-        spin_unlock(&sdebug_host_list_lock);
+	}
+	spin_unlock(&sdebug_host_list_lock);
 	stop_all_queued();
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, SCpnt->device,
+		shost_printk(KERN_INFO, shost,
 			    "%s: %d device(s) found\n", __func__, k);
 	return SUCCESS;
 }
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ac31964..808167f 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -745,7 +745,7 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_host_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_host_reset_handler(scmd);
+	rtn = hostt->eh_host_reset_handler(host);
 
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 46837ee9..9171b90 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -380,8 +380,7 @@ struct snic_global {
 int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
 int snic_device_reset(struct scsi_cmnd *);
-int snic_host_reset(struct scsi_cmnd *);
-int snic_reset(struct Scsi_Host *);
+int snic_host_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
 
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 56b0eb4..ec11293 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2307,8 +2307,15 @@
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
 	struct scsi_cmnd *sc = NULL;
@@ -2373,26 +2380,6 @@
 		 0, 0, 0);
 
 	return ret;
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
-
-	SNIC_SCSI_DBG(shost,
-		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
-		      sc, sc->cmnd[0], sc->request,
-		      snic_cmd_tag(sc), CMD_FLAGS(sc));
-
-	return snic_reset(shost);
 } /* end of snic_host_reset */
 
 /*
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 9b20643..c8db82c 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1441,14 +1441,13 @@ static int stex_do_reset(struct st_hba *hba)
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
index 3cc8d67..b6a58b8 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1437,9 +1437,9 @@ static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 	return 0;
 }
 
-static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
+static int storvsc_host_reset_handler(struct Scsi_Host *shost)
 {
-	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
+	struct hv_host_device *host_dev = shost_priv(shost);
 	struct hv_device *device = host_dev->dev;
 
 	struct storvsc_device *stor_device;
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 5bdcbe8..78c6bac 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -723,12 +723,9 @@ const char *sym53c416_info(struct Scsi_Host *SChost)
 	int i;
 	int base = SChost->io_port;
 	int irq = SChost->irq;
-	int scsi_id = 0;
+	int scsi_id = SChost->this_id;
 	int rev = inb(base + TC_HIGH);
 
-	for(i = 0; i < host_index; i++)
-		if(hosts[i].base == base)
-			scsi_id = hosts[i].scsi_id;
 	sprintf(info, "Symbios Logic 53c416 (rev. %d) at 0x%03x, irq %d, SCSI-ID %d, %s pio", rev, base, irq, scsi_id, (fastpio)? "fast" : "slow");
 	return info;
 }
@@ -762,21 +759,18 @@ static int sym53c416_queuecommand_lck(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *
 
 DEF_SCSI_QCMD(sym53c416_queuecommand)
 
-static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
+static int sym53c416_host_reset(struct Scsi_Host *SChost)
 {
 	int base;
-	int scsi_id = -1;	
+	int scsi_id;
 	int i;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sym53c416_lock, flags);
 
 	/* printk("sym53c416_reset\n"); */
-	base = SCpnt->device->host->io_port;
-	/* search scsi_id - fixme, we shouldn't need to iterate for this! */
-	for(i = 0; i < host_index && scsi_id == -1; i++)
-		if(hosts[i].base == base)
-			scsi_id = hosts[i].scsi_id;
+	base = SChost->io_port;
+	scsi_id = SChost->this_id;
 	outb(RESET_CHIP, base + COMMAND_REG);
 	outb(NOOP | PIO_MODE, base + COMMAND_REG);
 	outb(RESET_SCSI_BUS, base + COMMAND_REG);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 5055469..9861c45 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -687,9 +687,8 @@ static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 	return SCSI_SUCCESS;
 }
 
-static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_host_reset_handler(struct Scsi_Host *shost)
 {
-	struct Scsi_Host *shost = cmd->device->host;
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
 	struct sym_hcb *np = sym_data->ncb;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 88ccd63..47a8722 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -214,7 +214,7 @@ enum {
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
-static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
+static int ufshcd_eh_host_reset_handler(struct Scsi_Host *shost);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba);
@@ -5585,7 +5585,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * handling stage: reset and restore.
 	 */
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN)
-		return ufshcd_eh_host_reset_handler(cmd);
+		return ufshcd_eh_host_reset_handler(host);
 
 	ufshcd_hold(hba, false);
 	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
@@ -5791,13 +5791,13 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
  *
  * Returns SUCCESS/FAILED
  */
-static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int ufshcd_eh_host_reset_handler(struct Scsi_Host *shost)
 {
 	int err;
 	unsigned long flags;
 	struct ufs_hba *hba;
 
-	hba = shost_priv(cmd->device->host);
+	hba = shost_priv(shost);
 
 	ufshcd_hold(hba, false);
 	/*
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c374e3b..b99c58a 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -873,14 +873,13 @@ static void pvscsi_reset_all(struct pvscsi_adapter *adapter)
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
index 74be04f..815c9a9 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1571,13 +1571,11 @@
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
 
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index 08abe50..4d2d3cb 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -347,6 +347,6 @@ void wd33c93_init (struct Scsi_Host *instance, const wd33c93_regs regs,
 void wd33c93_intr (struct Scsi_Host *instance);
 int wd33c93_show_info(struct seq_file *, struct Scsi_Host *);
 int wd33c93_write_info(struct Scsi_Host *, char *, int);
-int wd33c93_host_reset (struct scsi_cmnd *);
+int wd33c93_host_reset (struct Scsi_Host *);
 
 #endif /* WD33C93_H */
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 2a9da2e..4c27913 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -510,9 +510,9 @@ static int wd719x_bus_reset(struct scsi_cmnd *cmd)
 	return wd719x_reset(cmd, WD719X_CMD_BUSRESET, 0);
 }
 
-static int wd719x_host_reset(struct scsi_cmnd *cmd)
+static int wd719x_host_reset(struct Scsi_Host *host)
 {
-	struct wd719x *wd = shost_priv(cmd->device->host);
+	struct wd719x *wd = shost_priv(host);
 	struct wd719x_scb *scb, *tmp;
 	unsigned long flags;
 	int result;
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index 811abfc..c58bf09 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -437,13 +437,13 @@ static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
 
 /*
  *	visorhba_host_reset_handler - Not supported
- *	@scsicmd: The scsicmd that needs aborted
+ *	@shost: The scsi host that needs resetting
  *
  *	Not supported, return SUCCESS
  *	Returns SUCCESS
  */
 static int
-visorhba_host_reset_handler(struct scsi_cmnd *scsicmd)
+visorhba_host_reset_handler(struct Scsi_Host *shost)
 {
 	/* issue TASK_MGMT_TARGET_RESET for each target on each bus for host */
 	return SUCCESS;
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index a4dbb0c..178d39c 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -344,9 +344,9 @@ static int mts_scsi_abort(struct scsi_cmnd *srb)
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
index 2109844..fe4789d 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -953,7 +953,7 @@ static inline struct fc_lport *fc_disc_lport(struct fc_disc *disc)
 int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fc_eh_abort(struct scsi_cmnd *);
 int fc_eh_device_reset(struct scsi_cmnd *);
-int fc_eh_host_reset(struct scsi_cmnd *);
+int fc_eh_host_reset(struct Scsi_Host *);
 int fc_slave_alloc(struct scsi_device *);
 
 /*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index afb0481..b85f8a5 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -148,7 +148,7 @@ struct scsi_host_template {
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
 	int (* eh_target_reset_handler)(struct scsi_cmnd *);
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
-	int (* eh_host_reset_handler)(struct scsi_cmnd *);
+	int (* eh_host_reset_handler)(struct Scsi_Host *);
 
 	/*
 	 * Before the mid layer attempts to scan for a new device where none
-- 
1.8.5.6
