From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/7] scsi: Use Scsi_Host as argument for eh_host_reset_handler
Date: Fri, 27 Jun 2014 08:27:04 +0200
Message-ID: <1403850425-89297-7-git-send-email-hare@suse.de>
References: <1403850425-89297-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbaF0G1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 02:27:09 -0400
In-Reply-To: <1403850425-89297-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Issuing a host reset should not rely on any commands.
So use Scsi_Host as argument for eh_host_reset_handler.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_eh.txt            |  2 +-
 Documentation/scsi/scsi_mid_low_api.txt   |  4 +--
 arch/ia64/hp/sim/simscsi.c                |  2 +-
 drivers/infiniband/ulp/srp/ib_srp.c       |  4 +--
 drivers/message/fusion/mptscsih.c         | 18 ++++++------
 drivers/message/fusion/mptscsih.h         |  2 +-
 drivers/s390/scsi/zfcp_scsi.c             |  3 +-
 drivers/scsi/3w-9xxx.c                    | 11 ++++----
 drivers/scsi/3w-sas.c                     | 11 ++++----
 drivers/scsi/3w-xxxx.c                    | 11 ++++----
 drivers/scsi/53c700.c                     | 15 +++++-----
 drivers/scsi/BusLogic.c                   | 13 +++------
 drivers/scsi/NCR53c406a.c                 |  6 ++--
 drivers/scsi/aacraid/linit.c              | 14 ++++-----
 drivers/scsi/aha152x.c                    | 11 +-------
 drivers/scsi/aha152x.h                    |  2 +-
 drivers/scsi/aha1542.c                    | 22 +++++++--------
 drivers/scsi/arm/fas216.c                 |  8 +++---
 drivers/scsi/arm/fas216.h                 |  2 +-
 drivers/scsi/dpt_i2o.c                    | 14 ++++-----
 drivers/scsi/dpti.h                       |  2 +-
 drivers/scsi/eata.c                       | 19 +++----------
 drivers/scsi/eata_pio.c                   | 29 +++++++++----------
 drivers/scsi/esas2r/esas2r.h              |  2 +-
 drivers/scsi/esas2r/esas2r_main.c         | 16 ++++++-----
 drivers/scsi/esp_scsi.c                   |  4 +--
 drivers/scsi/fnic/fnic.h                  |  2 +-
 drivers/scsi/fnic/fnic_scsi.c             |  3 +-
 drivers/scsi/ibmvscsi/ibmvfc.c            |  4 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c          |  4 +--
 drivers/scsi/imm.c                        |  7 ++---
 drivers/scsi/ipr.c                        |  4 +--
 drivers/scsi/ips.c                        | 40 ++++++--------------------
 drivers/scsi/libfc/fc_fcp.c               |  5 ++--
 drivers/scsi/lpfc/lpfc_scsi.c             |  3 +-
 drivers/scsi/mac53c94.c                   |  8 +++---
 drivers/scsi/megaraid.c                   | 16 +++++------
 drivers/scsi/megaraid.h                   |  2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     | 16 +++--------
 drivers/scsi/megaraid/megaraid_sas_base.c | 32 +++++----------------
 drivers/scsi/mesh.c                       | 10 +++----
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      | 13 ++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 13 ++++-----
 drivers/scsi/mvumi.c                      |  7 ++---
 drivers/scsi/nsp32.c                      | 14 ++++-----
 drivers/scsi/pcmcia/aha152x_stub.c        |  2 +-
 drivers/scsi/pcmcia/nsp_cs.c              |  4 +--
 drivers/scsi/pcmcia/sym53c500_cs.c        |  8 +++---
 drivers/scsi/pmcraid.c                    |  4 +--
 drivers/scsi/ppa.c                        |  7 ++---
 drivers/scsi/qla1280.c                    | 23 ++++++++++++---
 drivers/scsi/qla2xxx/qla_os.c             | 17 ++++-------
 drivers/scsi/qla4xxx/ql4_os.c             | 16 +++++------
 drivers/scsi/scsi_debug.c                 |  2 +-
 drivers/scsi/scsi_error.c                 |  2 +-
 drivers/scsi/sgiwd93.c                    | 15 ----------
 drivers/scsi/stex.c                       |  5 ++--
 drivers/scsi/storvsc_drv.c                |  4 +--
 drivers/scsi/sym53c416.c                  |  6 ++--
 drivers/scsi/sym53c8xx_2/sym_glue.c       | 47 +++++++++++++++++++++----------
 drivers/scsi/u14-34f.c                    | 17 ++++-------
 drivers/scsi/ultrastor.c                  |  7 ++---
 drivers/scsi/vmw_pvscsi.c                 |  5 ++--
 drivers/scsi/wd33c93.c                    |  7 ++---
 drivers/scsi/wd33c93.h                    |  2 +-
 drivers/scsi/wd7000.c                     | 10 +++----
 drivers/usb/image/microtek.c              |  4 +--
 include/scsi/libfc.h                      |  2 +-
 include/scsi/scsi_host.h                  |  2 +-
 69 files changed, 289 insertions(+), 379 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index a0c8511..c530296 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -210,7 +210,7 @@ considered to fail always.
 int (* eh_abort_handler)(struct scsi_cmnd *);
 int (* eh_device_reset_handler)(struct scsi_cmnd *);
 int (* eh_bus_reset_handler)(struct scsi_cmnd *);
-int (* eh_host_reset_handler)(struct scsi_cmnd *);
+int (* eh_host_reset_handler)(struct Scsi_Host *);
 
  Higher-severity actions are taken only when lower-severity actions
 cannot recover some of failed scmds.  Also, note that failure of the
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index d6a9bde..efed980 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -931,7 +931,7 @@ Details:
 
 /**
  *      eh_host_reset_handler - reset host (host bus adapter)
- *      @scp: SCSI host that contains this device should be reset
+ *      @shost: SCSI host that contains this device should be reset
  *
  *      Returns SUCCESS if command aborted else FAILED
  *
@@ -948,7 +948,7 @@ Details:
  *
  *      Optionally defined in: LLD
  **/
-     int eh_host_reset_handler(struct scsi_cmnd * scp)
+     int eh_host_reset_handler(struct Scsi_Host * shost)
 
 
 /**
diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 3a428f1..4dbe6b3 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -329,7 +329,7 @@ simscsi_queuecommand_lck (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *)
 static DEF_SCSI_QCMD(simscsi_queuecommand)
 
 static int
-simscsi_host_reset (struct scsi_cmnd *sc)
+simscsi_host_reset (struct Scsi_Host *sh)
 {
 	printk(KERN_ERR "simscsi_host_reset: not implemented\n");
 	return 0;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index e3c2c5b..177039b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -2405,9 +2405,9 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 	return SUCCESS;
 }
 
-static int srp_reset_host(struct scsi_cmnd *scmnd)
+static int srp_reset_host(struct Scsi_Host *shost)
 {
-	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct srp_target_port *target = host_to_target(shost);
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 39e5668..7a7d03a6 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1913,14 +1913,14 @@ mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
  *	mptscsih_host_reset - Perform a SCSI host adapter RESET (new_eh variant)
- *	@SCpnt: Pointer to scsi_cmnd structure, IO which reset is due to
+ *	@shost: Pointer to Scsi_Host structure to be reset
  *
  *	(linux scsi_host_template.eh_host_reset_handler routine)
  *
  *	Returns SUCCESS or FAILED.
  */
 int
-mptscsih_host_reset(struct scsi_cmnd *SCpnt)
+mptscsih_host_reset(struct Scsi_Host *shost)
 {
 	MPT_SCSI_HOST *  hd;
 	int              status = SUCCESS;
@@ -1928,9 +1928,9 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
 	int		retval;
 
 	/*  If we can't locate the host to reset, then we failed. */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
+	if ((hd = shost_priv(shost)) == NULL){
 		printk(KERN_ERR MYNAM ": host reset: "
-		    "Can't locate host! (sc=%p)\n", SCpnt);
+		    "Can't locate host!\n");
 		return FAILED;
 	}
 
@@ -1938,20 +1938,20 @@ mptscsih_host_reset(struct scsi_cmnd *SCpnt)
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
index e1b1a19..32067bc 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -121,7 +121,7 @@ extern int mptscsih_slave_configure(struct scsi_device *device);
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
-extern int mptscsih_host_reset(struct scsi_cmnd *SCpnt);
+extern int mptscsih_host_reset(struct Scsi_Host *shost);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
 extern int mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
 extern int mptscsih_taskmgmt_complete(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index dc42c93..fe50f69 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -281,13 +281,14 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 	return zfcp_task_mgmt_function(scpnt, FCP_TMF_TGT_RESET);
 }
 
-static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
+static int zfcp_scsi_eh_host_reset_handler(struct Scsi_Host *host)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct fc_rport *rport = zfcp_sdev->port->rport;
 	int ret;
 
+	adapter = (struct zfcp_adapter *)host->hostdata[0];
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
 	ret = fc_block_scsi_eh(rport);
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 0a73253..d3f4147 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1736,18 +1736,19 @@ static int twa_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
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
index 4de3460..d54c197 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1472,18 +1472,19 @@ static int twl_scsi_biosparam(struct scsi_device *sdev, struct block_device *bde
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
index 752624e..31b8d25 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1394,25 +1394,24 @@ static int tw_scsi_biosparam(struct scsi_device *sdev, struct block_device *bdev
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
index a3adfb4..166a4e9 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -169,7 +169,7 @@ MODULE_LICENSE("GPL");
 STATIC int NCR_700_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *);
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_bus_reset(struct scsi_cmnd * SCpnt);
-STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
+STATIC int NCR_700_host_reset(struct Scsi_Host *host);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
 STATIC int NCR_700_slave_alloc(struct scsi_device *SDpnt);
@@ -1975,17 +1975,16 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp)
 }
 
 STATIC int
-NCR_700_host_reset(struct scsi_cmnd * SCp)
+NCR_700_host_reset(struct Scsi_Host * host)
 {
-	scmd_printk(KERN_INFO, SCp, "New error handler wants HOST reset\n\t");
-	scsi_print_command(SCp);
+	shost_printk(KERN_INFO, shost, "SCSI EH wants HOST reset\n\t");
 
-	spin_lock_irq(SCp->device->host->host_lock);
+	spin_lock_irq(host->host_lock);
 
-	NCR_700_internal_bus_reset(SCp->device->host);
-	NCR_700_chip_reset(SCp->device->host);
+	NCR_700_internal_bus_reset(host);
+	NCR_700_chip_reset(host);
 
-	spin_unlock_irq(SCp->device->host->host_lock);
+	spin_unlock_irq(host->host_lock);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 972f817..8bb5fa2 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2998,21 +2998,16 @@ static bool blogic_write_outbox(struct blogic_adapter *adapter,
 
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
-	blogic_inc_count(&stats->adatper_reset_req);
+	spin_lock_irq(shost->host_lock);
 
 	rc = blogic_resetadapter(adapter, false);
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(shost->host_lock);
 	return rc;
 }
 
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index c91888a..32363a3 100644
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
index 63f576c..29396bf 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -598,11 +598,10 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
  *	@scsi_cmd:	SCSI command block causing the reset
  *
  */
-static int aac_eh_reset(struct scsi_cmnd* cmd)
+static int aac_eh_reset(struct Scsi_Host * host)
 {
-	struct scsi_device * dev = cmd->device;
-	struct Scsi_Host * host = dev->host;
 	struct scsi_cmnd * command;
+	struct scsi_device *dev;
 	int count;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	unsigned long flags;
@@ -611,10 +610,10 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 	for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
 		struct fib * fib = &aac->fibs[count];
 		if (fib->hw_fib_va->header.XferState &&
-		  (fib->flags & FIB_CONTEXT_FLAG) &&
-		  (fib->callback_data == cmd)) {
+		    (fib->flags & FIB_CONTEXT_FLAG)) {
 			fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
-			cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+			command = fib->callback_data;
+			command->SCp.phase = AAC_OWNER_ERROR_HANDLER;
 		}
 	}
 	printk(KERN_ERR "%s: Host adapter reset request. SCSI hang ?\n",
@@ -633,8 +632,7 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 		__shost_for_each_device(dev, host) {
 			spin_lock_irqsave(&dev->list_lock, flags);
 			list_for_each_entry(command, &dev->cmd_list, list) {
-				if ((command != cmd) &&
-				    (command->SCp.phase == AAC_OWNER_FIRMWARE)) {
+				if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
 					active++;
 					break;
 				}
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e77b72f..fc78bb1 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1331,7 +1331,7 @@ static void reset_ports(struct Scsi_Host *shpnt)
  * Reset the host (bus and controller)
  *
  */
-int aha152x_host_reset_host(struct Scsi_Host *shpnt)
+int aha152x_host_reset(struct Scsi_Host *shpnt)
 {
 	DPRINTK(debug_eh, KERN_DEBUG "scsi%d: host reset\n", shpnt->host_no);
 
@@ -1344,15 +1344,6 @@ int aha152x_host_reset_host(struct Scsi_Host *shpnt)
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
index 770c48d..dd92308 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1379,7 +1379,7 @@ fail:
 	return FAILED;
 }
 
-static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
+static int aha1542_host_reset(struct Scsi_Host * shost)
 {
 	int i;
 
@@ -1389,7 +1389,7 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 	 * we do this?  Try this first, and we can add that later
 	 * if it turns out to be useful.
 	 */
-	outb(HRST | SCRST, CONTROL(SCpnt->device->host->io_port));
+	outb(HRST | SCRST, CONTROL(shost->io_port));
 
 	/*
 	 * Wait for the thing to settle down a bit.  Unfortunately
@@ -1399,16 +1399,16 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 	 * we are pretty desperate anyways.
 	 */
 	ssleep(4);
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
 
-	WAIT(STATUS(SCpnt->device->host->io_port),
+	WAIT(STATUS(shost->io_port),
 	     STATMASK, INIT | IDLE, STST | DIAGF | INVDCMD | DF | CDF);
 
 	/*
 	 * We need to do this too before the 1542 can interact with
 	 * us again.
 	 */
-	setup_mailboxes(SCpnt->device->host->io_port, SCpnt->device->host);
+	setup_mailboxes(shost->io_port, shost);
 
 	/*
 	 * Now try to pick up the pieces.  For all pending commands,
@@ -1416,12 +1416,12 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 	 * out.  We do not try and restart any commands or anything - 
 	 * the strategy handler takes care of that crap.
 	 */
-	printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", SCpnt->device->host->host_no);
+	printk(KERN_WARNING "Sent BUS RESET to scsi host %d\n", shost->host_no);
 
 	for (i = 0; i < AHA1542_MAILBOXES; i++) {
-		if (HOSTDATA(SCpnt->device->host)->SCint[i] != NULL) {
+		if (HOSTDATA(shost)->SCint[i] != NULL) {
 			Scsi_Cmnd *SCtmp;
-			SCtmp = HOSTDATA(SCpnt->device->host)->SCint[i];
+			SCtmp = HOSTDATA(shost)->SCint[i];
 
 			if (SCtmp->device->soft_reset) {
 				/*
@@ -1434,12 +1434,12 @@ static int aha1542_host_reset(Scsi_Cmnd * SCpnt)
 			}
 			kfree(SCtmp->host_scribble);
 			SCtmp->host_scribble = NULL;
-			HOSTDATA(SCpnt->device->host)->SCint[i] = NULL;
-			HOSTDATA(SCpnt->device->host)->mb[i].status = 0;
+			HOSTDATA(shost)->SCint[i] = NULL;
+			HOSTDATA(shost)->mb[i].status = 0;
 		}
 	}
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(shost->host_lock);
 	return SUCCESS;
 
 fail:
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index b46a6f6..753b2ed 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2653,16 +2653,16 @@ static void fas216_init_chip(FAS216_Info *info)
  * Returns: FAILED if unable to reset.
  * Notes: io_request_lock is taken, and irqs are disabled
  */
-int fas216_eh_host_reset(struct scsi_cmnd *SCpnt)
+int fas216_eh_host_reset(struct Scsi_Host *shost)
 {
-	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
+	FAS216_Info *info = (FAS216_Info *)shost->hostdata;
 
 	spin_lock_irq(info->host->host_lock);
 
 	fas216_checkmagic(info);
 
-	printk("scsi%d.%c: %s: resetting host\n",
-		info->host->host_no, '0' + SCpnt->device->id, __func__);
+	printk("scsi%d: %s: resetting host\n",
+		info->host->host_no, __func__);
 
 	/*
 	 * Reset the SCSI chip.
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index c57c16e..9741c4c 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -388,6 +388,6 @@ extern int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt);
  * Params  : SCpnt - command specifing host to reset
  * Returns : FAILED if unable to reset
  */
-extern int fas216_eh_host_reset(struct scsi_cmnd *SCpnt);
+extern int fas216_eh_host_reset(struct Scsi_Host *shost);
 
 #endif /* FAS216_H */
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index c0ae8fa..b1c22a3 100644
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
index aeb0461..0d82d77 100644
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
index 03372cf..cd893bf 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -507,7 +507,7 @@ static int eata2x_detect(struct scsi_host_template *);
 static int eata2x_release(struct Scsi_Host *);
 static int eata2x_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int eata2x_eh_abort(struct scsi_cmnd *);
-static int eata2x_eh_host_reset(struct scsi_cmnd *);
+static int eata2x_eh_host_reset(struct Scsi_Host *);
 static int eata2x_bios_param(struct scsi_device *, struct block_device *,
 			     sector_t, int *);
 static int eata2x_slave_configure(struct scsi_device *);
@@ -1908,21 +1908,16 @@ static int eata2x_eh_abort(struct scsi_cmnd *SCarg)
 	panic("%s: abort, mbox %d, invalid cp_stat.\n", ha->board_name, i);
 }
 
-static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
+static int eata2x_eh_host_reset(struct Scsi_Host *shost)
 {
 	unsigned int i, time, k, c, limit = 0;
-	int arg_done = 0;
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
@@ -1979,9 +1974,6 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 		if (SCpnt->scsi_done == NULL)
 			panic("%s: reset, mbox %d, SCpnt->scsi_done == NULL.\n",
 			      ha->board_name, i);
-
-		if (SCpnt == SCarg)
-			arg_done = 1;
 	}
 
 	if (do_dma(shost->io_port, 0, RESET_PIO)) {
@@ -2049,10 +2041,7 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 	ha->in_reset = 0;
 	do_trace = 0;
 
-	if (arg_done)
-		printk("%s: reset, exit, done.\n", ha->board_name);
-	else
-		printk("%s: reset, exit.\n", ha->board_name);
+	printk("%s: reset, exit.\n", ha->board_name);
 
 	spin_unlock_irq(shost->host_lock);
 	return SUCCESS;
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index 8319d2b..b5470ceb3 100644
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
index 3fd305d..9f12a50 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -982,7 +982,7 @@ long esas2r_proc_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
 /* SCSI error handler (eh) functions */
 int esas2r_eh_abort(struct scsi_cmnd *cmd);
 int esas2r_device_reset(struct scsi_cmnd *cmd);
-int esas2r_host_reset(struct scsi_cmnd *cmd);
+int esas2r_host_reset(struct Scsi_Host *shost);
 int esas2r_bus_reset(struct scsi_cmnd *cmd);
 int esas2r_target_reset(struct scsi_cmnd *cmd);
 
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 6504a19..1fa2baa 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1126,10 +1126,10 @@ check_active_queue:
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
@@ -1154,18 +1154,20 @@ static int esas2r_host_bus_reset(struct scsi_cmnd *cmd, bool host_reset)
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
index 55548dc..f0b58b7 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2592,9 +2592,9 @@ static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 }
 
 /* All bets are off, reset the entire device.  */
-static int esp_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int esp_eh_host_reset_handler(struct Scsi_Host *shost)
 {
-	struct esp *esp = shost_priv(cmd->device->host);
+	struct esp *esp = shost_priv(shost);
 	unsigned long flags;
 
 	spin_lock_irqsave(esp->host->host_lock, flags);
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 1d3521e..0e0a87a 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -343,7 +343,7 @@ void fnic_update_mac_locked(struct fnic *, u8 *new);
 int fnic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fnic_abort_cmd(struct scsi_cmnd *);
 int fnic_device_reset(struct scsi_cmnd *);
-int fnic_host_reset(struct scsi_cmnd *);
+int fnic_host_reset(struct Scsi_Host *);
 int fnic_reset(struct Scsi_Host *);
 void fnic_scsi_cleanup(struct fc_lport *);
 void fnic_scsi_abort_io(struct fc_lport *);
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 1fa1a87..ba90ccb 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2465,11 +2465,10 @@ int fnic_reset(struct Scsi_Host *shost)
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
 
 	/*
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index fee80fa..f2ed70c 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2528,10 +2528,10 @@ static int ibmvfc_eh_target_reset_handler(struct scsi_cmnd *cmd)
  * @cmd:	struct scsi_cmnd having problems
  *
  **/
-static int ibmvfc_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int ibmvfc_eh_host_reset_handler(struct Scsi_Host *shost)
 {
 	int rc, block_rc;
-	struct ibmvfc_host *vhost = shost_priv(cmd->device->host);
+	struct ibmvfc_host *vhost = shost_priv(shost);
 
 	dev_err(vhost->dev, "Resetting connection due to error recovery\n");
 	rc = ibmvfc_issue_fc_host_lip(vhost->host);
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 2ebfb2b..3b3de48 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1719,10 +1719,10 @@ static int ibmvscsi_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
index 89a8266..c5b97d7 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -984,11 +984,11 @@ static void imm_reset_pulse(unsigned int base)
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
 
@@ -1104,7 +1104,6 @@ static struct scsi_host_template imm_template = {
 	.name			= "Iomega VPI2 (imm) interface",
 	.queuecommand		= imm_queuecommand,
 	.eh_abort_handler	= imm_abort,
-	.eh_bus_reset_handler	= imm_reset,
 	.eh_host_reset_handler	= imm_reset,
 	.bios_param		= imm_biosparam,
 	.this_id		= 7,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 924b0ba..26d3fd02 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4843,14 +4843,14 @@ static int ipr_slave_alloc(struct scsi_device *sdev)
 	return rc;
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
index 52a216f..7615f05 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -231,7 +231,7 @@ module_param(ips, charp, 0);
 static int ips_detect(struct scsi_host_template *);
 static int ips_release(struct Scsi_Host *);
 static int ips_eh_abort(struct scsi_cmnd *);
-static int ips_eh_reset(struct scsi_cmnd *);
+static int ips_eh_reset(struct Scsi_Host *);
 static int ips_queue(struct Scsi_Host *, struct scsi_cmnd *);
 static const char *ips_info(struct Scsi_Host *);
 static irqreturn_t do_ipsintr(int, void *);
@@ -838,13 +838,12 @@ int ips_eh_abort(struct scsi_cmnd *SC)
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
 
@@ -852,13 +851,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
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
@@ -869,23 +862,6 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 	if (!ha->active)
 		return (FAILED);
 
-	/* See if the command is on the copp queue */
-	item = ha->copp_waitlist.head;
-	while ((item) && (item->scsi_cmd != SC))
-		item = item->next;
-
-	if (item) {
-		/* Found it */
-		ips_removeq_copp(&ha->copp_waitlist, item);
-		return (SUCCESS);
-	}
-
-	/* See if the command is on the wait queue */
-	if (ips_removeq_wait(&ha->scb_waitlist, SC)) {
-		/* command not sent yet */
-		return (SUCCESS);
-	}
-
 	/* An explanation for the casual observer:                              */
 	/* Part of the function of a RAID controller is automatic error         */
 	/* detection and recovery.  As such, the only problem that physically   */
@@ -1024,13 +1000,13 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
 
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
@@ -1109,7 +1085,7 @@ static int ips_queue_lck(struct scsi_cmnd *SC, void (*done) (struct scsi_cmnd *)
 				return (0);
 			}
 			ha->ioctl_reset = 1;	/* This reset request is from an IOCTL */
-			__ips_eh_reset(SC);
+			__ips_eh_reset(SC->device->host);
 			SC->result = DID_OK << 16;
 			SC->scsi_done(SC);
 			return (0);
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 40f26ea..ab7ec74 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2116,11 +2116,10 @@ EXPORT_SYMBOL(fc_eh_device_reset);
 
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
index 832cb9f..df4a43c 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5465,9 +5465,8 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
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
index e5cd8d8..f664f79 100644
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
index ac5d94c..e8ed321 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1889,13 +1889,13 @@ megaraid_abort(Scsi_Cmnd *cmd)
 
 
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
@@ -1912,7 +1912,7 @@ megaraid_reset(struct scsi_cmnd *cmd)
 
 	spin_lock_irq(&adapter->lock);
 
-	rval =  megaraid_abort_and_reset(adapter, cmd, SCB_RESET);
+	rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
 
 	/*
 	 * This is required here to complete any completed requests
@@ -1938,6 +1938,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 {
 	struct list_head	*pos, *next;
 	scb_t			*scb;
+	int failed = 0;
 
 	printk(KERN_WARNING "megaraid: %s cmd=%x <c=%d t=%d l=%d>\n",
 	     (aor == SCB_ABORT)? "ABORTING":"RESET",
@@ -1951,7 +1952,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 
 		scb = list_entry(pos, scb_t, list);
 
-		if (scb->cmd == cmd) { /* Found command */
+		if (!cmd || scb->cmd == cmd) { /* Found command */
 
 			scb->state |= aor;
 
@@ -1968,7 +1969,7 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 					(aor==SCB_ABORT) ? "ABORTING":"RESET",
 					scb->idx);
 
-				return FALSE;
+				failed++;
 			}
 			else {
 
@@ -1993,12 +1994,11 @@ megaraid_abort_and_reset(adapter_t *adapter, Scsi_Cmnd *cmd, int aor)
 				list_add_tail(SCSI_LIST(cmd),
 						&adapter->completed_list);
 
-				return TRUE;
 			}
 		}
 	}
 
-	return FALSE;
+	return failed ? FALSE : TRUE;
 }
 
 static inline int
@@ -4183,8 +4183,6 @@ static struct scsi_host_template megaraid_template = {
 	.cmd_per_lun			= DEF_CMD_PER_LUN,
 	.use_clustering			= ENABLE_CLUSTERING,
 	.eh_abort_handler		= megaraid_abort,
-	.eh_device_reset_handler	= megaraid_reset,
-	.eh_bus_reset_handler		= megaraid_reset,
 	.eh_host_reset_handler		= megaraid_reset,
 	.no_write_same			= 1,
 };
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 508d65e..6fb6adf 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -963,7 +963,7 @@ static irqreturn_t megaraid_isr_iomapped(int, void *);
 static void mega_free_scb(adapter_t *, scb_t *);
 
 static int megaraid_abort(Scsi_Cmnd *);
-static int megaraid_reset(Scsi_Cmnd *);
+static int megaraid_reset(struct Scsi_Host *);
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
 static int megaraid_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int []);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index e2237a9..6321d2a 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -97,7 +97,7 @@ static int megaraid_sysfs_alloc_resources(adapter_t *);
 static void megaraid_sysfs_free_resources(adapter_t *);
 
 static int megaraid_abort_handler(struct scsi_cmnd *);
-static int megaraid_reset_handler(struct scsi_cmnd *);
+static int megaraid_reset_handler(struct Scsi_Host *);
 
 static int mbox_post_sync_cmd(adapter_t *, uint8_t []);
 static int mbox_post_sync_cmd_fast(adapter_t *, uint8_t []);
@@ -362,8 +362,6 @@ static struct scsi_host_template megaraid_template_g = {
 	.proc_name			= "megaraid",
 	.queuecommand			= megaraid_queue_command,
 	.eh_abort_handler		= megaraid_abort_handler,
-	.eh_device_reset_handler	= megaraid_reset_handler,
-	.eh_bus_reset_handler		= megaraid_reset_handler,
 	.eh_host_reset_handler		= megaraid_reset_handler,
 	.change_queue_depth		= megaraid_change_queue_depth,
 	.use_clustering			= ENABLE_CLUSTERING,
@@ -2591,7 +2589,7 @@ megaraid_abort_handler(struct scsi_cmnd *scp)
  * host.
  **/
 static int
-megaraid_reset_handler(struct scsi_cmnd *scp)
+megaraid_reset_handler(struct Scsi_Host *shost)
 {
 	adapter_t	*adapter;
 	scb_t		*scb;
@@ -2605,7 +2603,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 	int		i;
 	uioc_t		*kioc;
 
-	adapter		= SCP2ADAPTER(scp);
+	adapter		= (adapter_t *)SCSIHOST2ADAP(shost);
 	raid_dev	= ADAP2RAIDDEV(adapter);
 
 	// return failure if adapter is not responding
@@ -2637,15 +2635,9 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 
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
index 112799b..697d7ca 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2291,15 +2291,14 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
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
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
 		printk(KERN_ERR "megasas: cannot recover from previous reset "
@@ -2349,28 +2348,13 @@ blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 }
 
 /**
- * megasas_reset_device -	Device reset handler entry point
- */
-static int megasas_reset_device(struct scsi_cmnd *scmd)
-{
-	int ret;
-
-	/*
-	 * First wait for all commands to complete
-	 */
-	ret = megasas_generic_reset(scmd);
-
-	return ret;
-}
-
-/**
  * megasas_reset_bus_host -	Bus & host reset handler entry point
  */
-static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
+static int megasas_reset_bus_host(struct Scsi_Host *shost)
 {
 	int ret;
 	struct megasas_instance *instance;
-	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	instance = (struct megasas_instance *)shost->hostdata;
 
 	/*
 	 * First wait for all commands to complete
@@ -2379,9 +2363,9 @@ static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
-		ret = megasas_reset_fusion(scmd->device->host, 1);
+		ret = megasas_reset_fusion(shost, 1);
 	else
-		ret = megasas_generic_reset(scmd);
+		ret = megasas_generic_reset(shost);
 
 	return ret;
 }
@@ -2504,8 +2488,6 @@ static struct scsi_host_template megasas_template = {
 	.slave_configure = megasas_slave_configure,
 	.slave_alloc = megasas_slave_alloc,
 	.queuecommand = megasas_queue_command,
-	.eh_device_reset_handler = megasas_reset_device,
-	.eh_bus_reset_handler = megasas_reset_bus_host,
 	.eh_host_reset_handler = megasas_reset_bus_host,
 	.eh_timed_out = megasas_reset_timer,
 	.bios_param = megasas_bios_param,
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index e8a04ae..8c2935d 100644
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
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5055f92..ccdbe0c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2769,20 +2769,19 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-_scsih_host_reset(struct scsi_cmnd *scmd)
+_scsih_host_reset(struct Scsi_Host *shost)
 {
-	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 	int r, retval;
 
-	printk(MPT2SAS_INFO_FMT "attempting host reset! scmd(%p)\n",
-	    ioc->name, scmd);
-	scsi_print_command(scmd);
+	printk(MPT2SAS_INFO_FMT "attempting host reset!\n",
+	    ioc->name);
 
 	retval = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 	    FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
-	printk(MPT2SAS_INFO_FMT "host reset: %s scmd(%p)\n",
-	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	printk(MPT2SAS_INFO_FMT "host reset: %s\n",
+	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	return r;
 }
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 0274ac3..1daae9e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2427,20 +2427,19 @@ _scsih_target_reset(struct scsi_cmnd *scmd)
  * Returns SUCCESS if command aborted else FAILED
  */
 static int
-_scsih_host_reset(struct scsi_cmnd *scmd)
+_scsih_host_reset(struct Scsi_Host *shost)
 {
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	int r, retval;
 
-	pr_info(MPT3SAS_FMT "attempting host reset! scmd(%p)\n",
-	    ioc->name, scmd);
-	scsi_print_command(scmd);
+	pr_info(MPT3SAS_FMT "attempting host reset!\n",
+	    ioc->name);
 
 	retval = mpt3sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 	    FORCE_BIG_HAMMER);
 	r = (retval < 0) ? FAILED : SUCCESS;
-	pr_info(MPT3SAS_FMT "host reset: %s scmd(%p)\n",
-	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"), scmd);
+	pr_info(MPT3SAS_FMT "host reset: %s\n",
+	    ioc->name, ((r == SUCCESS) ? "SUCCESS" : "FAILED"));
 
 	return r;
 }
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index edbee8d..9ee3a3c 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -723,14 +723,13 @@ static int mvumi_reset_host_9143(struct mvumi_hba *mhba)
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
index 0665f9c..953d0bc 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -202,7 +202,7 @@ static int         nsp32_release     (struct Scsi_Host *);
 /* SCSI error handler */
 static int         nsp32_eh_abort     (struct scsi_cmnd *);
 static int         nsp32_eh_bus_reset (struct scsi_cmnd *);
-static int         nsp32_eh_host_reset(struct scsi_cmnd *);
+static int         nsp32_eh_host_reset(struct Scsi_Host *);
 
 /* generate SCSI message */
 static void nsp32_build_identify(struct scsi_cmnd *);
@@ -2909,23 +2909,21 @@ static void nsp32_do_bus_reset(nsp32_hw_data *data)
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
index 987fbb1..e8136b1 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1490,9 +1490,9 @@ static int nsp_eh_bus_reset(struct scsi_cmnd *SCpnt)
 	return nsp_bus_reset(data);
 }
 
-static int nsp_eh_host_reset(struct scsi_cmnd *SCpnt)
+static int nsp_eh_host_reset(struct Scsi_Host *host)
 {
-	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	nsp_hw_data *data = (nsp_hw_data *)host->hostdata;
 
 	nsp_dbg(NSP_DEBUG_BUSRESET, "in");
 
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index f5b5273..3d174a5 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -586,14 +586,14 @@ SYM53C500_queue_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
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
index 017f8b9..4e274f9 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3150,12 +3150,12 @@ static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
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
index 1db8b26..b542fe4 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -856,11 +856,11 @@ static void ppa_reset_pulse(unsigned int base)
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
 
@@ -969,7 +969,6 @@ static struct scsi_host_template ppa_template = {
 	.name			= "Iomega VPI0 (ppa) interface",
 	.queuecommand		= ppa_queuecommand,
 	.eh_abort_handler	= ppa_abort,
-	.eh_bus_reset_handler	= ppa_reset,
 	.eh_host_reset_handler	= ppa_reset,
 	.bios_param		= ppa_biosparam,
 	.this_id		= -1,
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 1580205..4bea9b9d 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1047,13 +1047,28 @@ qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
  *     Reset the specified adapter (both channels)
  **************************************************************************/
 static int
-qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
+qla1280_eh_adapter_reset(struct Scsi_Host *shost)
 {
 	int rc;
+	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = qla1280_error_action(cmd, ADAPTER_RESET);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
+	if (qla1280_verbose) {
+		printk(KERN_INFO
+		       "scsi(%ld): Issued ADAPTER RESET\n",
+		       ha->host_no);
+		printk(KERN_INFO "scsi(%ld): I/O processing will "
+		       "continue automatically\n", ha->host_no);
+	}
+	ha->flags.reset_active = 1;
+
+	if (qla1280_abort_isp(ha) != 0) {	/* it's dead */
+		rc = FAILED;
+	}
+
+	ha->flags.reset_active = 0;
+
+	spin_unlock_irq(shost->host_lock);
 
 	return rc;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index cd30445..96ff099 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -234,7 +234,7 @@ static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
-static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
+static int qla2xxx_eh_host_reset(struct Scsi_Host *);
 
 static int qla2x00_change_queue_depth(struct scsi_device *, int, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
@@ -1222,20 +1222,15 @@ eh_bus_reset_done:
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
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
-
 	ql_log(ql_log_info, vha, 0x8018,
-	    "ADAPTER RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no, id, lun);
+	    "ADAPTER RESET ISSUED host=%ld.\n", vha->host_no);
 
 	/*
 	 * No point in issuing another reset if one is active.  Also do not
@@ -1281,8 +1276,8 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 
 eh_host_reset_lock:
 	ql_log(ql_log_info, vha, 0x8017,
-	    "ADAPTER RESET %s nexus=%ld:%d:%llu.\n",
-	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
+	    "ADAPTER RESET %s host=%ld.\n",
+	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no);
 
 	return ret;
 }
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index c5d9564..62706dd 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -160,7 +160,7 @@ static int qla4xxx_queuecommand(struct Scsi_Host *h, struct scsi_cmnd *cmd);
 static int qla4xxx_eh_abort(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_device_reset(struct scsi_cmnd *cmd);
 static int qla4xxx_eh_target_reset(struct scsi_cmnd *cmd);
-static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd);
+static int qla4xxx_eh_host_reset(struct Scsi_Host *shost);
 static int qla4xxx_slave_alloc(struct scsi_device *device);
 static int qla4xxx_slave_configure(struct scsi_device *device);
 static void qla4xxx_slave_destroy(struct scsi_device *sdev);
@@ -9412,12 +9412,12 @@ static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
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
@@ -9433,20 +9433,18 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
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
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 6ed43fd..ae7e1ae 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2614,7 +2614,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
 	return SUCCESS;
 }
 
-static int scsi_debug_host_reset(struct scsi_cmnd * SCpnt)
+static int scsi_debug_host_reset(struct Scsi_Host * shost)
 {
 	struct sdebug_host_info * sdbg_host;
         struct sdebug_dev_info * dev_info;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index e4a5324..ff069780 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -765,7 +765,7 @@ static int scsi_try_host_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_host_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_host_reset_handler(scmd);
+	rtn = hostt->eh_host_reset_handler(host);
 
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index a464d95..9ceb12c 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -192,20 +192,6 @@ static inline void init_hpc_chain(struct ip22_hostdata *hdata)
 	hcp->desc.pnext = hdata->dma;
 }
 
-static int sgiwd93_bus_reset(struct scsi_cmnd *cmd)
-{
-	/* FIXME perform bus-specific reset */
-
-	/* FIXME 2: kill this function, and let midlayer fallback
-	   to the same result, calling wd33c93_host_reset() */
-
-	spin_lock_irq(cmd->device->host->host_lock);
-	wd33c93_host_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
-
-	return SUCCESS;
-}
-
 /*
  * Kludge alert - the SCSI code calls the abort and reset method with int
  * arguments not with pointers.  So this is going to blow up beautyfully
@@ -217,7 +203,6 @@ static struct scsi_host_template sgiwd93_template = {
 	.name			= "SGI WD93",
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
-	.eh_bus_reset_handler	= sgiwd93_bus_reset,
 	.eh_host_reset_handler	= wd33c93_host_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1aa4bef..2868f80 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1346,15 +1346,14 @@ static int stex_do_reset(struct st_hba *hba)
 	return -1;
 }
 
-static int stex_reset(struct scsi_cmnd *cmd)
+static int stex_reset(struct Scsi_Host *shost)
 {
 	struct st_hba *hba;
 
-	hba = (struct st_hba *) &cmd->device->host->hostdata[0];
+	hba = (struct st_hba *) &shost->hostdata[0];
 
 	printk(KERN_INFO DRV_NAME
 		"(%s): resetting host\n", pci_name(hba->pdev));
-	scsi_print_command(cmd);
 
 	return stex_do_reset(hba) ? FAILED : SUCCESS;
 }
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9969fa1..9b59609 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1467,9 +1467,9 @@ static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
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
index 0b7819f..3e8a615 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -762,17 +762,17 @@ static int sym53c416_queuecommand_lck(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *
 
 DEF_SCSI_QCMD(sym53c416_queuecommand)
 
-static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
+static int sym53c416_host_reset(struct Scsi_Host *shost)
 {
 	int base;
-	int scsi_id = -1;	
+	int scsi_id = -1;
 	int i;
 	unsigned long flags;
 
 	spin_lock_irqsave(&sym53c416_lock, flags);
 
 	/* printk("sym53c416_reset\n"); */
-	base = SCpnt->device->host->io_port;
+	base = shost->io_port;
 	/* search scsi_id - fixme, we shouldn't need to iterate for this! */
 	for(i = 0; i < host_index && scsi_id == -1; i++)
 		if(hosts[i].base == base)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index e59e6f9..645eb0f 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -588,10 +588,10 @@ static void sym53c8xx_timer(unsigned long npref)
  *  Generic method for our eh processing.
  *  The 'op' argument tells what we have to do.
  */
-static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
+static int sym_eh_handler(int op, char *opname,
+			  struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	struct sym_ucmd *ucmd = SYM_UCMD_PTR(cmd);
-	struct Scsi_Host *shost = cmd->device->host;
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
 	struct sym_hcb *np = sym_data->ncb;
@@ -600,7 +600,12 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 	int sts = -1;
 	struct completion eh_done;
 
-	scmd_printk(KERN_WARNING, cmd, "%s operation started\n", opname);
+	if (cmd)
+		scmd_printk(KERN_WARNING, cmd, "%s operation started\n",
+			    opname);
+	else
+		shost_printk(KERN_WARNING, shost, "%s operation started\n",
+			     opname);
 
 	/* We may be in an error condition because the PCI bus
 	 * went down. In this case, we need to wait until the
@@ -634,11 +639,14 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 
 	spin_lock_irq(shost->host_lock);
 	/* This one is queued in some place -> to wait for completion */
-	FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
-		struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb, link_ccbq);
-		if (cp->cmd == cmd) {
-			cmd_queued = 1;
-			break;
+	if (cmd) {
+		FOR_EACH_QUEUED_ELEMENT(&np->busy_ccbq, qp) {
+			struct sym_ccb *cp = sym_que_entry(qp, struct sym_ccb,
+							   link_ccbq);
+			if (cp->cmd == cmd) {
+				cmd_queued = 1;
+				break;
+			}
 		}
 	}
 
@@ -680,8 +688,15 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
 		spin_unlock_irq(shost->host_lock);
 	}
 
-	dev_warn(&cmd->device->sdev_gendev, "%s operation %s.\n", opname,
-			sts==0 ? "complete" :sts==-2 ? "timed-out" : "failed");
+	if (cmd)
+		scmd_printk(KERN_WARNING, cmd, "%s operation %s.\n", opname,
+			    sts==0 ? "complete" :
+			    sts==-2 ? "timed-out" : "failed");
+	else
+		shost_printk(KERN_WARNING, shost, "%s operation %s.\n", opname,
+			     sts==0 ? "complete" :
+			     sts==-2 ? "timed-out" : "failed");
+
 	return sts ? SCSI_FAILED : SCSI_SUCCESS;
 }
 
@@ -691,22 +706,24 @@ static int sym_eh_handler(int op, char *opname, struct scsi_cmnd *cmd)
  */
 static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
+	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd->device->host, cmd);
 }
 
 static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
+	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET",
+			      cmd->device->host, cmd);
 }
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
+	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET",
+			      cmd->device->host, cmd);
 }
 
-static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_host_reset_handler(struct Scsi_Host *shost)
 {
-	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
+	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", shost, NULL);
 }
 
 /*
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 5a03bb3..773b811 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -434,7 +434,7 @@ static int u14_34f_detect(struct scsi_host_template *);
 static int u14_34f_release(struct Scsi_Host *);
 static int u14_34f_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 static int u14_34f_eh_abort(struct scsi_cmnd *);
-static int u14_34f_eh_host_reset(struct scsi_cmnd *);
+static int u14_34f_eh_host_reset(struct Scsi_Host *);
 static int u14_34f_bios_param(struct scsi_device *, struct block_device *,
                               sector_t, int *);
 static int u14_34f_slave_configure(struct scsi_device *);
@@ -1392,20 +1392,15 @@ static int u14_34f_eh_abort(struct scsi_cmnd *SCarg) {
    panic("%s: abort, mbox %d, invalid cp_stat.\n", BN(j), i);
 }
 
-static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
+static int u14_34f_eh_host_reset(struct Scsi_Host *shost) {
    unsigned int i, j, k, c, limit = 0;
    unsigned long time;
-   int arg_done = FALSE;
-   struct scsi_cmnd *SCpnt;
 
-   j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
-   scmd_printk(KERN_INFO, SCarg, "reset, enter.\n");
+   j = ((struct hostdata *) shost->hostdata)->board_number;
+   shost_printk(KERN_INFO, shost, "reset, enter.\n");
 
    spin_lock_irq(sh[j]->host_lock);
 
-   if (SCarg->host_scribble == NULL)
-      printk("%s: reset, inactive.\n", BN(j));
-
    if (HD(j)->in_reset) {
       printk("%s: reset, exit, already in reset.\n", BN(j));
       spin_unlock_irq(sh[j]->host_lock);
@@ -1458,7 +1453,6 @@ static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
       if (SCpnt->scsi_done == NULL)
          panic("%s: reset, mbox %d, SCpnt->scsi_done == NULL.\n", BN(j), i);
 
-      if (SCpnt == SCarg) arg_done = TRUE;
       }
 
    if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
@@ -1520,8 +1514,7 @@ static int u14_34f_eh_host_reset(struct scsi_cmnd *SCarg) {
    HD(j)->in_reset = FALSE;
    do_trace = FALSE;
 
-   if (arg_done) printk("%s: reset, exit, done.\n", BN(j));
-   else          printk("%s: reset, exit.\n", BN(j));
+   printk("%s: reset, exit.\n", BN(j));
 
    spin_unlock_irq(sh[j]->host_lock);
    return SUCCESS;
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 14e0c40..406299c 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -969,18 +969,17 @@ static int ultrastor_abort(struct scsi_cmnd *SCpnt)
     return SUCCESS;
 }
 
-static int ultrastor_host_reset(struct scsi_cmnd * SCpnt)
+static int ultrastor_host_reset(struct Scsi_Host * host)
 {
     unsigned long flags;
     int i;
-    struct Scsi_Host *host = SCpnt->device->host;
-    
+
 #if (ULTRASTOR_DEBUG & UD_RESET)
     printk("US14F: reset: called\n");
 #endif
 
     if(config.slot)
-    	return FAILED;
+	return FAILED;
 
     spin_lock_irqsave(host->host_lock, flags);
     /* Reset the adapter and SCSI bus.  The SCSI bus reset can be
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c88e146..a82d3d5 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -868,14 +868,13 @@ static void pvscsi_reset_all(struct pvscsi_adapter *adapter)
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
index 41883a8..b9fb855 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1570,16 +1570,14 @@ reset_wd33c93(struct Scsi_Host *instance)
 }
 
 int
-wd33c93_host_reset(struct scsi_cmnd * SCpnt)
+wd33c93_host_reset(struct Scsi_Host * instance)
 {
-	struct Scsi_Host *instance;
 	struct WD33C93_hostdata *hostdata;
 	int i;
 
-	instance = SCpnt->device->host;
 	hostdata = (struct WD33C93_hostdata *) instance->hostdata;
 
-	printk("scsi%d: reset. ", instance->host_no);
+	shost_printk(KERN_INFO, instance, "reset. ");
 	disable_irq(instance->irq);
 
 	hostdata->dma_stop(instance, NULL, 0);
@@ -1600,7 +1598,6 @@ wd33c93_host_reset(struct scsi_cmnd * SCpnt)
 	hostdata->outgoing_len = 0;
 
 	reset_wd33c93(instance);
-	SCpnt->result = DID_RESET << 16;
 	enable_irq(instance->irq);
 	return SUCCESS;
 }
diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
index 08abe50..4d2d3cb 100644
--- a/drivers/scsi/wd33c93.h
+++ b/drivers/scsi/wd33c93.h
@@ -347,6 +347,6 @@ int wd33c93_queuecommand (struct Scsi_Host *h, struct scsi_cmnd *cmd);
 void wd33c93_intr (struct Scsi_Host *instance);
 int wd33c93_show_info(struct seq_file *, struct Scsi_Host *);
 int wd33c93_write_info(struct Scsi_Host *, char *, int);
-int wd33c93_host_reset (struct scsi_cmnd *);
+int wd33c93_host_reset (struct Scsi_Host *);
 
 #endif /* WD33C93_H */
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 3267423..91ad166 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1568,20 +1568,20 @@ static int wd7000_abort(Scsi_Cmnd * SCpnt)
  *  Last resort. Reinitialize the board.
  */
 
-static int wd7000_host_reset(struct scsi_cmnd *SCpnt)
+static int wd7000_host_reset(struct Scsi_Host *shost)
 {
-	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
+	Adapter *host = (Adapter *) shost->hostdata;
 
-	spin_lock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
 
 	if (wd7000_adapter_reset(host) < 0) {
-		spin_unlock_irq(SCpnt->device->host->host_lock);
+		spin_unlock_irq(shost->host_lock);
 		return FAILED;
 	}
 
 	wd7000_enable_intr(host);
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_unlock_irq(shost->host_lock);
 	return SUCCESS;
 }
 
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 37b44b0..d8c26fd 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -346,9 +346,9 @@ static int mts_scsi_abort(struct scsi_cmnd *srb)
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
index 52beadf..e5d348f 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -1103,7 +1103,7 @@ void fc_fcp_destroy(struct fc_lport *);
 int fc_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int fc_eh_abort(struct scsi_cmnd *);
 int fc_eh_device_reset(struct scsi_cmnd *);
-int fc_eh_host_reset(struct scsi_cmnd *);
+int fc_eh_host_reset(struct Scsi_Host *);
 int fc_slave_alloc(struct scsi_device *);
 int fc_change_queue_depth(struct scsi_device *, int qdepth, int reason);
 int fc_change_queue_type(struct scsi_device *, int tag_type);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index abb6958..95a8cbd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -174,7 +174,7 @@ struct scsi_host_template {
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
 	int (* eh_target_reset_handler)(struct scsi_cmnd *);
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
-	int (* eh_host_reset_handler)(struct scsi_cmnd *);
+	int (* eh_host_reset_handler)(struct Scsi_Host *);
 
 	/*
 	 * Before the mid layer attempts to scan for a new device where none
-- 
1.7.12.4

