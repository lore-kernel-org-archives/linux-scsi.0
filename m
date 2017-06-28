From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/47] scsi: Use Scsi_Host and channel number as argument for eh_bus_reset_handler()
Date: Wed, 28 Jun 2017 10:32:46 +0200
Message-ID: <1498638793-44672-21-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53768 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751587AbdF1IdU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:20 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus reset should not depend on any command, but rather only
use the SCSI Host and the channel/bus number as argument.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 Documentation/scsi/scsi_eh.txt                  |  2 +-
 Documentation/scsi/scsi_mid_low_api.txt         |  5 ++--
 drivers/message/fusion/mptfc.c                  | 13 ++++-------
 drivers/message/fusion/mptscsih.c               | 21 +++++++----------
 drivers/message/fusion/mptscsih.h               |  2 +-
 drivers/scsi/a100u2w.c                          |  4 ++--
 drivers/scsi/aacraid/linit.c                    | 11 ++++-----
 drivers/scsi/aha1542.c                          |  4 ++--
 drivers/scsi/aic7xxx/aic79xx_osm.c              | 10 ++++----
 drivers/scsi/aic7xxx/aic7xxx_osm.c              |  6 ++---
 drivers/scsi/arcmsr/arcmsr_hba.c                |  9 +++----
 drivers/scsi/arm/fas216.c                       |  9 +++----
 drivers/scsi/arm/fas216.h                       |  5 ++--
 drivers/scsi/dc395x.c                           | 25 ++++++++++----------
 drivers/scsi/dpt_i2o.c                          |  9 +++----
 drivers/scsi/dpti.h                             |  2 +-
 drivers/scsi/esas2r/esas2r.h                    |  2 +-
 drivers/scsi/esas2r/esas2r_main.c               |  4 +---
 drivers/scsi/esp_scsi.c                         |  4 ++--
 drivers/scsi/gdth.c                             | 16 ++++---------
 drivers/scsi/initio.c                           | 11 +++++----
 drivers/scsi/ncr53c8xx.c                        |  4 ++--
 drivers/scsi/pcmcia/nsp_cs.c                    |  6 ++---
 drivers/scsi/pmcraid.c                          |  7 +++---
 drivers/scsi/qla1280.c                          | 10 ++++----
 drivers/scsi/qla2xxx/qla_os.c                   | 29 +++++------------------
 drivers/scsi/scsi_debug.c                       | 31 +++++++++----------------
 drivers/scsi/scsi_error.c                       |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c             |  7 +++---
 drivers/scsi/vmw_pvscsi.c                       |  5 ++--
 drivers/scsi/wd719x.c                           | 11 +++++----
 drivers/staging/unisys/visorhba/visorhba_main.c | 24 ++++++++++---------
 drivers/usb/storage/scsiglue.c                  |  4 ++--
 include/scsi/scsi_host.h                        |  2 +-
 34 files changed, 139 insertions(+), 177 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 78cd6b9..cb9f4bc22 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -207,7 +207,7 @@ considered to fail always.
 
 int (* eh_abort_handler)(struct scsi_cmnd *);
 int (* eh_device_reset_handler)(struct scsi_cmnd *);
-int (* eh_bus_reset_handler)(struct scsi_cmnd *);
+int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
 int (* eh_host_reset_handler)(struct Scsi_Host *);
 
  Higher-severity actions are taken only when lower-severity actions
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index ad517d5..e2609a63 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -855,7 +855,8 @@ Details:
 
 /**
  *      eh_bus_reset_handler - issue SCSI bus reset
- *      @scp: SCSI bus that contains this device should be reset
+ *      @shost: SCSI host that contains the bus which should be reset
+ *      @channel: Number of the SCSI bus which should be reset
  *
  *      Returns SUCCESS if command aborted else FAILED
  *
@@ -868,7 +869,7 @@ Details:
  *
  *      Optionally defined in: LLD
  **/
-     int eh_bus_reset_handler(struct scsi_cmnd * scp)
+     int eh_bus_reset_handler(struct Scsi_Host * shost, int channel)
 
 
 /**
diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index ff886bc..9e164af 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -103,7 +103,7 @@
 static void mptfc_remove(struct pci_dev *pdev);
 static int mptfc_abort(struct scsi_cmnd *SCpnt);
 static int mptfc_dev_reset(struct scsi_cmnd *SCpnt);
-static int mptfc_bus_reset(struct scsi_cmnd *SCpnt);
+static int mptfc_bus_reset(struct Scsi_Host *shost, int channel);
 
 static struct scsi_host_template mptfc_driver_template = {
 	.module				= THIS_MODULE,
@@ -260,11 +260,9 @@
 }
 
 static int
-mptfc_bus_reset(struct scsi_cmnd *SCpnt)
+mptfc_bus_reset(struct Scsi_Host *shost, int channel)
 {
-	struct Scsi_Host *shost = SCpnt->device->host;
 	MPT_SCSI_HOST *hd = shost_priv(shost);
-	int channel = SCpnt->device->channel;
 	struct mptfc_rport_info *ri;
 	int rtn;
 
@@ -281,10 +279,9 @@
 	}
 	if (rtn == 0) {
 		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
-			"%s.%d: %d:%llu, executing recovery.\n", __func__,
-			hd->ioc->name, shost->host_no,
-			SCpnt->device->id, SCpnt->device->lun));
-		rtn = mptscsih_bus_reset(SCpnt);
+			"%s.%d: 0:0, executing recovery.\n", __func__,
+			hd->ioc->name, shost->host_no));
+		rtn = mptscsih_bus_reset(shost, channel);
 	}
 	return rtn;
 }
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 6ca4799..ca79982 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1912,39 +1912,34 @@ int mptscsih_show_info(struct seq_file *m, struct Scsi_Host *host)
  *	Returns SUCCESS or FAILED.
  **/
 int
-mptscsih_bus_reset(struct scsi_cmnd * SCpnt)
+mptscsih_bus_reset(struct Scsi_Host * shost, int channel)
 {
 	MPT_SCSI_HOST	*hd;
 	int		 retval;
-	VirtDevice	 *vdevice;
 	MPT_ADAPTER	*ioc;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
-	if ((hd = shost_priv(SCpnt->device->host)) == NULL){
+	if ((hd = shost_priv(shost)) == NULL){
 		printk(KERN_ERR MYNAM ": bus reset: "
-		   "Can't locate host! (sc=%p)\n", SCpnt);
+		   "Can't locate host!\n");
 		return FAILED;
 	}
 
 	ioc = hd->ioc;
-	printk(MYIOC_s_INFO_FMT "attempting bus reset! (sc=%p)\n",
-	       ioc->name, SCpnt);
-	scsi_print_command(SCpnt);
+	printk(MYIOC_s_INFO_FMT "attempting bus reset!\n",
+	       ioc->name);
 
 	if (ioc->timeouts < -1)
 		ioc->timeouts++;
 
-	vdevice = SCpnt->device->hostdata;
-	if (!vdevice || !vdevice->vtarget)
-		return SUCCESS;
 	retval = mptscsih_IssueTaskMgmt(hd,
 					MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
-					vdevice->vtarget->channel, 0, 0, 0,
+					channel, 0, 0, 0,
 					mptscsih_get_tm_timeout(ioc));
 
-	printk(MYIOC_s_INFO_FMT "bus reset: %s (sc=%p)\n",
-	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ), SCpnt);
+	printk(MYIOC_s_INFO_FMT "bus reset: %s\n",
+	    ioc->name, ((retval == 0) ? "SUCCESS" : "FAILED" ));
 
 	if (retval == 0)
 		return SUCCESS;
diff --git a/drivers/message/fusion/mptscsih.h b/drivers/message/fusion/mptscsih.h
index 50af52a..54f2604 100644
--- a/drivers/message/fusion/mptscsih.h
+++ b/drivers/message/fusion/mptscsih.h
@@ -121,7 +121,7 @@ extern int mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel,
 extern int mptscsih_abort(struct scsi_cmnd * SCpnt);
 extern int mptscsih_dev_reset(struct scsi_cmnd * SCpnt);
 extern int mptscsih_target_reset(struct scsi_cmnd * SCpnt);
-extern int mptscsih_bus_reset(struct scsi_cmnd * SCpnt);
+extern int mptscsih_bus_reset(struct Scsi_Host *, int);
 extern int mptscsih_host_reset(struct Scsi_Host *sh);
 extern int mptscsih_bios_param(struct scsi_device * sdev, struct block_device *bdev, sector_t capacity, int geom[]);
 extern int mptscsih_io_done(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf, MPT_FRAME_HDR *r);
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 8086bd0..1c61d7a 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -956,10 +956,10 @@ static int inia100_abort(struct scsi_cmnd * cmd)
  Output         : None.
  Return         : pSRB  -       Pointer to SCSI request block.
 *****************************************************************************/
-static int inia100_bus_reset(struct scsi_cmnd * cmd)
+static int inia100_bus_reset(struct Scsi_Host * shost, int channel)
 {				/* I need Host Control Block Information */
 	struct orc_host *host;
-	host = (struct orc_host *) cmd->device->host->hostdata;
+	host = (struct orc_host *) shost->hostdata;
 	return orc_reset_scsi_bus(host);
 }
 
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index bef2c0d..1e157c6 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -998,20 +998,18 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 
 /*
  *	aac_eh_bus_reset	- Bus reset command handling
- *	@scsi_cmd:	SCSI command block causing the reset
+ *	@host:	SCSI host causing the reset
+ *	@channel:	Number of the bus to be reset
  *
  */
-static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
+static int aac_eh_bus_reset(struct Scsi_Host *host, int channel)
 {
-	struct scsi_device * dev = cmd->device;
-	struct Scsi_Host * host = dev->host;
 	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	int count;
 	u32 cmd_bus;
 	int status = 0;
 
-
-	cmd_bus = aac_logical_to_phys(scmd_channel(cmd));
+	cmd_bus = aac_logical_to_phys(channel);
 	/* Mark the assoc. FIB to not complete, eh handler does this */
 	for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
 		struct fib *fib = &aac->fibs[count];
@@ -1019,6 +1017,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 		if (fib->hw_fib_va->header.XferState &&
 		    (fib->flags & FIB_CONTEXT_FLAG) &&
 		    (fib->flags & FIB_CONTEXT_FLAG_SCSI_CMD)) {
+			struct scsi_cmnd *cmd;
 			struct aac_hba_map_info *info;
 			u32 bus, cid;
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 3d4c404..ed44e1e 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -910,9 +910,9 @@ static int aha1542_reset(struct Scsi_Host *sh, u8 reset_cmd)
 	return SUCCESS;
 }
 
-static int aha1542_bus_reset(struct scsi_cmnd *cmd)
+static int aha1542_bus_reset(struct Scsi_Host *sh, int channel)
 {
-	return aha1542_reset(cmd->device->host, SCRST);
+	return aha1542_reset(sh, SCRST);
 }
 
 static int aha1542_host_reset(struct Scsi_Host *sh)
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 2588b8f..0797c2f 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -877,21 +877,21 @@ static DEF_SCSI_QCMD(ahd_linux_queue)
  * Reset the SCSI bus.
  */
 static int
-ahd_linux_bus_reset(struct scsi_cmnd *cmd)
+ahd_linux_bus_reset(struct Scsi_Host *shost, int channel)
 {
 	struct ahd_softc *ahd;
 	int    found;
 	unsigned long flags;
 
-	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;
+	ahd = *(struct ahd_softc **)shost->hostdata;
 #ifdef AHD_DEBUG
 	if ((ahd_debug & AHD_SHOW_RECOVERY) != 0)
-		printk("%s: Bus reset called for cmd %p\n",
-		       ahd_name(ahd), cmd);
+		printk("%s: Bus reset called for channel %d\n",
+		       ahd_name(ahd), channel);
 #endif
 	ahd_lock(ahd, &flags);
 
-	found = ahd_reset_channel(ahd, scmd_channel(cmd) + 'A',
+	found = ahd_reset_channel(ahd, channel + 'A',
 				  /*initiate reset*/TRUE);
 	ahd_unlock(ahd, &flags);
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index fc6a831..5f9d2ae 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -769,16 +769,16 @@ static DEF_SCSI_QCMD(ahc_linux_queue)
  * Reset the SCSI bus.
  */
 static int
-ahc_linux_bus_reset(struct scsi_cmnd *cmd)
+ahc_linux_bus_reset(struct Scsi_Host *shost, int channel)
 {
 	struct ahc_softc *ahc;
 	int    found;
 	unsigned long flags;
 
-	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
+	ahc = *(struct ahc_softc **)shost->hostdata;
 
 	ahc_lock(ahc, &flags);
-	found = ahc_reset_channel(ahc, scmd_channel(cmd) + 'A',
+	found = ahc_reset_channel(ahc, channel + 'A',
 				  /*initiate reset*/TRUE);
 	ahc_unlock(ahc, &flags);
 
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index af032c4..7fe7e21 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -83,7 +83,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
 					struct scsi_cmnd *cmd);
 static int arcmsr_iop_confirm(struct AdapterControlBlock *acb);
 static int arcmsr_abort(struct scsi_cmnd *);
-static int arcmsr_bus_reset(struct scsi_cmnd *);
+static int arcmsr_bus_reset(struct Scsi_Host *, int);
 static int arcmsr_bios_param(struct scsi_device *sdev,
 		struct block_device *bdev, sector_t capacity, int *info);
 static int arcmsr_queue_command(struct Scsi_Host *h, struct scsi_cmnd *cmd);
@@ -3726,14 +3726,15 @@ static uint8_t arcmsr_iop_reset(struct AdapterControlBlock *acb)
 	return rtnval;
 }
 
-static int arcmsr_bus_reset(struct scsi_cmnd *cmd)
+static int arcmsr_bus_reset(struct Scsi_Host *shost, int channel)
 {
 	struct AdapterControlBlock *acb;
 	uint32_t intmask_org, outbound_doorbell;
 	int retry_count = 0;
 	int rtn = FAILED;
-	acb = (struct AdapterControlBlock *) cmd->device->host->hostdata;
-	printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets = %d, num_aborts = %d \n", acb->num_resets, acb->num_aborts);
+	acb = (struct AdapterControlBlock *) shost->hostdata;
+	printk(KERN_ERR "arcmsr: executing bus reset eh.....num_resets = %d, "
+	       "num_aborts = %d \n", acb->num_resets, acb->num_aborts);
 	acb->num_resets++;
 
 	switch(acb->adapter_type){
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index e4a08e8..c93ad3a 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2544,15 +2544,16 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 
 /**
  * fas216_eh_bus_reset - Reset the bus associated with the command
- * @SCpnt: command specifing bus to reset
+ * @shost: host to be reset
+ * @channel: bus number to reset
  *
- * Reset the bus associated with the command.
+ * Reset the bus.
  * Returns: FAILED if unable to reset.
  * Notes: Further commands are blocked.
  */
-int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt)
+int fas216_eh_bus_reset(struct Scsi_Host *shost, int channel)
 {
-	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
+	FAS216_Info *info = (FAS216_Info *)shost->hostdata;
 	unsigned long flags;
 	struct scsi_device *SDpnt;
 
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index e0e74ee..4ea1a38 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -378,10 +378,11 @@
 
 /* Function: int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt)
  * Purpose : Reset the complete bus associated with this command
- * Params  : SCpnt - command specifing bus to reset
+ * Params  : shost - host to be reset
+ *           channel - bus to be reset
  * Returns : FAILED if unable to reset
  */
-extern int fas216_eh_bus_reset(struct scsi_cmnd *SCpnt);
+extern int fas216_eh_bus_reset(struct Scsi_Host *shost, int channel);
 
 /* Function: int fas216_eh_host_reset(struct Scsi_Host *shost)
  * Purpose : Reset the host associated with this command
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 5ee7f44..0d2b7b6 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1296,19 +1296,18 @@ static void reset_dev_param(struct AdapterCtlBlk *acb)
  * @cmd - some command for this host (for fetching hooks)
  * Returns: SUCCESS (0x2002) on success, else FAILED (0x2003).
  */
-static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
+static int __dc395x_eh_bus_reset(struct Scsi_Host *shost, int channel)
 {
 	struct AdapterCtlBlk *acb =
-		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
+		(struct AdapterCtlBlk *)shost->hostdata;
 	dprintkl(KERN_INFO,
-		"eh_bus_reset: (0%p) target=<%02i-%i> cmd=%p\n",
-		cmd, cmd->device->id, (u8)cmd->device->lun, cmd);
+		 "eh_bus_reset: bus=<%02i>\n", channel);
 
 	if (timer_pending(&acb->waiting_timer))
 		del_timer(&acb->waiting_timer);
 
 	/*
-	 * disable interrupt    
+	 * disable interrupt
 	 */
 	DC395x_write8(acb, TRM_S1040_DMA_INTEN, 0x00);
 	DC395x_write8(acb, TRM_S1040_SCSI_INTEN, 0x00);
@@ -1324,7 +1323,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 	    HZ * acb->eeprom.delay_time;
 
 	/*
-	 * re-enable interrupt      
+	 * re-enable interrupt
 	 */
 	/* Clear SCSI FIFO          */
 	DC395x_write8(acb, TRM_S1040_DMA_CONTROL, CLRXFIFO);
@@ -1334,7 +1333,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 	set_basic_config(acb);
 
 	reset_dev_param(acb);
-	doing_srb_done(acb, DID_RESET, cmd, 0);
+	doing_srb_done(acb, DID_RESET, NULL, 0);
 	acb->active_dcb = NULL;
 	acb->acb_flag = 0;	/* RESET_DETECT, RESET_DONE ,RESET_DEV */
 	waiting_process_next(acb);
@@ -1342,13 +1341,13 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-static int dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
+static int dc395x_eh_bus_reset(struct Scsi_Host *shost, int channel)
 {
 	int rc;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = __dc395x_eh_bus_reset(cmd);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
+	rc = __dc395x_eh_bus_reset(shost, channel);
+	spin_unlock_irq(shost->host_lock);
 
 	return rc;
 }
@@ -3520,7 +3519,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struct DeviceCtlBlk *dcb,
 
 /* abort all cmds in our queues */
 static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
-		struct scsi_cmnd *cmd, u8 force)
+			   struct scsi_cmnd *cmd, u8 force)
 {
 	struct DeviceCtlBlk *dcb;
 	dprintkl(KERN_INFO, "doing_srb_done: pids ");
@@ -3574,7 +3573,7 @@ static void doing_srb_done(struct AdapterCtlBlk *acb, u8 did_flag,
 			p->result = result;
 			pci_unmap_srb_sense(acb, srb);
 			pci_unmap_srb(acb, srb);
-			if (force) {
+			if (force && cmd) {
 				/* For new EH, we normally don't need to give commands back,
 				 * as they all complete or all time out */
 				cmd->scsi_done(cmd);
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index d28f4a4..da1c461 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -769,17 +769,18 @@ static int adpt_device_reset(struct scsi_cmnd* cmd)
 
 #define I2O_HBA_BUS_RESET 0x87
 // This version of bus reset is called by the eh_error handler
-static int adpt_bus_reset(struct scsi_cmnd* cmd)
+static int adpt_bus_reset(struct Scsi_Host *shost, int channel)
 {
 	adpt_hba* pHba;
 	u32 msg[4];
 	u32 rcode;
 
-	pHba = (adpt_hba*)cmd->device->host->hostdata[0];
+	pHba = (adpt_hba*)shost->hostdata[0];
 	memset(msg, 0, sizeof(msg));
-	printk(KERN_WARNING"%s: Bus reset: SCSI Bus %d: tid: %d\n",pHba->name, cmd->device->channel,pHba->channel[cmd->device->channel].tid );
+	printk(KERN_WARNING"%s: Bus reset: SCSI Bus %d: tid: %d\n",
+	       pHba->name, channel, pHba->channel[channel].tid );
 	msg[0] = FOUR_WORD_MSG_SIZE|SGL_OFFSET_0;
-	msg[1] = (I2O_HBA_BUS_RESET<<24|HOST_TID<<12|pHba->channel[cmd->device->channel].tid);
+	msg[1] = (I2O_HBA_BUS_RESET<<24|HOST_TID<<12|pHba->channel[channel].tid);
 	msg[2] = 0;
 	msg[3] = 0;
 	if (pHba->host)
diff --git a/drivers/scsi/dpti.h b/drivers/scsi/dpti.h
index ba88ceb..48a9139 100644
--- a/drivers/scsi/dpti.h
+++ b/drivers/scsi/dpti.h
@@ -39,7 +39,7 @@
 static int adpt_bios_param(struct scsi_device * sdev, struct block_device *dev,
 		sector_t, int geom[]);
 
-static int adpt_bus_reset(struct scsi_cmnd* cmd);
+static int adpt_bus_reset(struct Scsi_Host* shost, int channel);
 static int adpt_device_reset(struct scsi_cmnd* cmd);
 
 
diff --git a/drivers/scsi/esas2r/esas2r.h b/drivers/scsi/esas2r/esas2r.h
index d130a59..b63bab9 100644
--- a/drivers/scsi/esas2r/esas2r.h
+++ b/drivers/scsi/esas2r/esas2r.h
@@ -978,7 +978,7 @@ u8 handle_hba_ioctl(struct esas2r_adapter *a,
 int esas2r_eh_abort(struct scsi_cmnd *cmd);
 int esas2r_device_reset(struct scsi_cmnd *cmd);
 int esas2r_host_reset(struct Scsi_Host *shost);
-int esas2r_bus_reset(struct scsi_cmnd *cmd);
+int esas2r_bus_reset(struct Scsi_Host *shost, int channel);
 int esas2r_target_reset(struct scsi_cmnd *cmd);
 
 /* Internal functions */
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 4f6dbc8..606bb82 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1157,10 +1157,8 @@ int esas2r_host_reset(struct Scsi_Host *shost)
 	return esas2r_host_bus_reset(shost, true);
 }
 
-int esas2r_bus_reset(struct scsi_cmnd *cmd)
+int esas2r_bus_reset(struct Scsi_Host *shost, int channel)
 {
-	struct Scsi_Host *shost = cmd->device->host;
-
 	esas2r_log(ESAS2R_LOG_INFO, "bus_reset (%p)", shost);
 
 	return esas2r_host_bus_reset(shost, false);
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 15185a0..0b5ff0d 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2619,9 +2619,9 @@ static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
 	return FAILED;
 }
 
-static int esp_eh_bus_reset_handler(struct scsi_cmnd *cmd)
+static int esp_eh_bus_reset_handler(struct Scsi_Host *shost, int channel)
 {
-	struct esp *esp = shost_priv(cmd->device->host);
+	struct esp *esp = shost_priv(shost);
 	struct completion eh_reset;
 	unsigned long flags;
 
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index facc727..dbcd881 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3911,9 +3911,9 @@ static enum blk_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
 }
 
 
-static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
+static int gdth_eh_bus_reset(struct Scsi_Host *sh, int channel)
 {
-    gdth_ha_str *ha = shost_priv(scp->device->host);
+    gdth_ha_str *ha = shost_priv(sh);
     int i;
     unsigned long flags;
     Scsi_Cmnd *cmnd;
@@ -3921,7 +3921,7 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 
     TRACE2(("gdth_eh_bus_reset()\n"));
 
-    b = scp->device->channel;
+    b = channel;
 
     /* clear command tab */
     spin_lock_irqsave(&ha->smp_lock, flags);
@@ -4467,7 +4467,6 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
     gdth_ha_str *ha; 
-    Scsi_Cmnd *scp;
     unsigned long flags;
     char cmnd[MAX_COMMAND_SIZE];   
     void __user *argp = (void __user *)arg;
@@ -4588,15 +4587,8 @@ static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
             (NULL == (ha = gdth_find_ha(res.ionode))))
             return -EFAULT;
 
-        scp  = kzalloc(sizeof(*scp), GFP_KERNEL);
-        if (!scp)
-            return -ENOMEM;
-        scp->device = ha->sdev;
-        scp->cmd_len = 12;
-        scp->device->channel = res.number;
-        rval = gdth_eh_bus_reset(scp);
+	rval = gdth_eh_bus_reset(ha->shost, res.number);
         res.status = (rval == SUCCESS ? S_OK : S_GENERR);
-        kfree(scp);
 
         if (copy_to_user(argp, &res, sizeof(gdth_ioctl_reset)))
             return -EFAULT;
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 7a91cf3..b363e0a 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2644,20 +2644,21 @@ static DEF_SCSI_QCMD(i91u_queuecommand)
 
 /**
  *	i91u_bus_reset		-	reset the SCSI bus
- *	@cmnd: Command block we want to trigger the reset for
+ *	@shost: SCSI host to be reset
+ *	@channel: Bus number to be reset
  *
  *	Initiate a SCSI bus reset sequence
  */
 
-static int i91u_bus_reset(struct scsi_cmnd * cmnd)
+static int i91u_bus_reset(struct Scsi_Host * shost, int channel)
 {
 	struct initio_host *host;
 
-	host = (struct initio_host *) cmnd->device->host->hostdata;
+	host = (struct initio_host *) shost->hostdata;
 
-	spin_lock_irq(cmnd->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
 	initio_reset_scsi(host, 0);
-	spin_unlock_irq(cmnd->device->host->host_lock);
+	spin_unlock_irq(shost->host_lock);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 5b93ed8..f0fa8b4 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8109,9 +8109,9 @@ static void ncr53c8xx_timeout(unsigned long npref)
 		ncr_flush_done_cmds(done_list);
 }
 
-static int ncr53c8xx_bus_reset(struct scsi_cmnd *cmd)
+static int ncr53c8xx_bus_reset(struct Scsi_Host *host, int channel)
 {
-	struct ncb *np = ((struct host_data *) cmd->device->host->hostdata)->ncb;
+	struct ncb *np = ((struct host_data *) host->hostdata)->ncb;
 	int sts;
 	unsigned long flags;
 	struct scsi_cmnd *done_list;
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 48ec923..563bf21 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -1476,11 +1476,11 @@ static int nsp_bus_reset(nsp_hw_data *data)
 	return SUCCESS;
 }
 
-static int nsp_eh_bus_reset(struct scsi_cmnd *SCpnt)
+static int nsp_eh_bus_reset(struct Scsi_Host *host, int channel)
 {
-	nsp_hw_data *data = (nsp_hw_data *)SCpnt->device->host->hostdata;
+	nsp_hw_data *data = (nsp_hw_data *)host->hostdata;
 
-	nsp_dbg(NSP_DEBUG_BUSRESET, "SCpnt=0x%p", SCpnt);
+	nsp_dbg(NSP_DEBUG_BUSRESET, "channel=0x%d", channel);
 
 	return nsp_bus_reset(data);
 }
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 9f0517d..35a6e34 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3068,9 +3068,8 @@ static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
 				    RESET_DEVICE_LUN);
 }
 
-static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
+static int pmcraid_eh_bus_reset_handler(struct Scsi_Host *host, int channel)
 {
-	struct Scsi_Host *host = scmd->device->host;
 	struct pmcraid_instance *pinstance =
 		(struct pmcraid_instance *)host->hostdata;
 	struct pmcraid_resource_entry *res = NULL;
@@ -3084,11 +3083,11 @@ static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
 	 */
 	spin_lock_irqsave(&pinstance->resource_lock, lock_flags);
 	list_for_each_entry(temp, &pinstance->used_res_q, queue) {
-		if (scmd->device->channel == PMCRAID_VSET_BUS_ID &&
+		if (channel == PMCRAID_VSET_BUS_ID &&
 		    RES_IS_VSET(temp->cfg_entry)) {
 			res = temp;
 			break;
-		} else if (scmd->device->channel == PMCRAID_PHYS_BUS_ID &&
+		} else if (channel == PMCRAID_PHYS_BUS_ID &&
 			   RES_IS_GSCSI(temp->cfg_entry)) {
 			res = temp;
 			break;
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index c6240ce..b5484a49 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1017,13 +1017,15 @@ static void qla1280_mailbox_timeout(unsigned long __data)
  *     Reset the specified bus.
  **************************************************************************/
 static int
-qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
+qla1280_eh_bus_reset(struct Scsi_Host *shost, int bus)
 {
 	int rc;
+	struct scsi_qla_host *ha = (struct scsi_qla_host *)shost->hostdata;
 
-	spin_lock_irq(cmd->device->host->host_lock);
-	rc = qla1280_error_action(cmd, BUS_RESET);
-	spin_unlock_irq(cmd->device->host->host_lock);
+	spin_lock_irq(shost->host_lock);
+	if (qla1280_bus_reset(ha, bus) == 0)
+		rc = qla1280_wait_for_pending_commands(ha, 1, 0);
+	spin_unlock_irq(shost->host_lock);
 
 	return rc;
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 35180aa..a43f249 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -274,7 +274,7 @@
 static int qla2xxx_eh_abort(struct scsi_cmnd *);
 static int qla2xxx_eh_device_reset(struct scsi_cmnd *);
 static int qla2xxx_eh_target_reset(struct scsi_cmnd *);
-static int qla2xxx_eh_bus_reset(struct scsi_cmnd *);
+static int qla2xxx_eh_bus_reset(struct Scsi_Host *, int);
 static int qla2xxx_eh_host_reset(struct Scsi_Host *);
 
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
@@ -1488,13 +1488,10 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 *
 **************************************************************************/
 static int
-qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
+qla2xxx_eh_bus_reset(struct Scsi_Host *shost, int channel)
 {
-	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
-	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	scsi_qla_host_t *vha = shost_priv(shost);
 	int ret = FAILED;
-	unsigned int id;
-	uint64_t lun;
 	struct qla_hw_data *ha = vha->hw;
 
 	if (qla2x00_isp_reg_stat(ha)) {
@@ -1503,22 +1500,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		return FAILED;
 	}
 
-	id = cmd->device->id;
-	lun = cmd->device->lun;
-
-	if (!fcport) {
-		return ret;
-	}
-
-	if (fcport->rport) {
-		ret = fc_block_scsi_eh(fcport->rport);
-		if (ret != 0)
-			return ret;
-		ret = FAILED;
-	}
-
 	ql_log(ql_log_info, vha, 0x8012,
-	    "BUS RESET ISSUED nexus=%ld:%d:%llu.\n", vha->host_no, id, lun);
+	    "BUS RESET ISSUED channel=%ld:%d.\n", vha->host_no, channel);
 
 	if (qla2x00_wait_for_hba_online(vha) != QLA_SUCCESS) {
 		ql_log(ql_log_fatal, vha, 0x8013,
@@ -1542,8 +1525,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 
 eh_bus_reset_done:
 	ql_log(ql_log_warn, vha, 0x802b,
-	    "BUS RESET %s nexus=%ld:%d:%llu.\n",
-	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, id, lun);
+	    "BUS RESET %s nexus=%ld:%d.\n",
+	    (ret == FAILED) ? "FAILED" : "SUCCEEDED", vha->host_no, channel);
 
 	return ret;
 }
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index ebf525b..1e89598 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3845,36 +3845,27 @@ static int scsi_debug_target_reset(struct scsi_cmnd *SCpnt)
 	return SUCCESS;
 }
 
-static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
+static int scsi_debug_bus_reset(struct Scsi_Host * hp, int channel)
 {
-	struct sdebug_host_info *sdbg_host;
+	struct sdebug_host_info *sdbg_host =
+		*(struct sdebug_host_info **)shost_priv(hp);
 	struct sdebug_dev_info *devip;
-        struct scsi_device * sdp;
-        struct Scsi_Host * hp;
 	int k = 0;
 
 	++num_bus_resets;
-	if (!(SCpnt && SCpnt->device))
-		goto lie;
-	sdp = SCpnt->device;
 	if (SDEBUG_OPT_ALL_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp, "%s\n", __func__);
-	hp = sdp->host;
-	if (hp) {
-		sdbg_host = *(struct sdebug_host_info **)shost_priv(hp);
-		if (sdbg_host) {
-			list_for_each_entry(devip,
-                                            &sdbg_host->dev_info_list,
-					    dev_list) {
-				set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
-				++k;
-			}
+		shost_printk(KERN_INFO, hp, "%s\n", __func__);
+	if (sdbg_host) {
+		list_for_each_entry(devip,
+				    &sdbg_host->dev_info_list,
+				    dev_list) {
+			set_bit(SDEBUG_UA_BUS_RESET, devip->uas_bm);
+			++k;
 		}
 	}
 	if (SDEBUG_OPT_RESET_NOISE & sdebug_opts)
-		sdev_printk(KERN_INFO, sdp,
+		shost_printk(KERN_INFO, hp,
 			    "%s: %d device(s) found in host\n", __func__, k);
-lie:
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 808167f..9dd51ed 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -775,7 +775,7 @@ static int scsi_try_bus_reset(struct scsi_cmnd *scmd)
 	if (!hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	rtn = hostt->eh_bus_reset_handler(scmd);
+	rtn = hostt->eh_bus_reset_handler(host, scmd_channel(scmd));
 
 	if (rtn == SUCCESS) {
 		if (!hostt->skip_settle_delay)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 9861c45..69d23bb 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -664,14 +664,13 @@ static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
 }
 
-static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
+static int sym53c8xx_eh_bus_reset_handler(struct Scsi_Host *shost, int channel)
 {
-	struct Scsi_Host *shost = cmd->device->host;
 	struct sym_data *sym_data = shost_priv(shost);
 	struct pci_dev *pdev = sym_data->pdev;
 	struct sym_hcb *np = sym_data->ncb;
 
-	scmd_printk(KERN_WARNING, cmd, "BUS RESET operation started\n");
+	shost_printk(KERN_WARNING, shost, "BUS RESET operation started\n");
 
 	/*
 	 * Escalate to host reset if the PCI bus went down
@@ -683,7 +682,7 @@ static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 	sym_reset_scsi_bus(np, 1);
 	spin_unlock_irq(shost->host_lock);
 
-	dev_warn(&cmd->device->sdev_gendev, "BUS RESET operation complete.\n");
+	shost_printk(KERN_WARNING, shost, "BUS RESET operation complete.\n");
 	return SCSI_SUCCESS;
 }
 
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index b99c58a..521cd9e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -926,13 +926,12 @@ static int pvscsi_host_reset(struct Scsi_Host *host)
 	return SUCCESS;
 }
 
-static int pvscsi_bus_reset(struct scsi_cmnd *cmd)
+static int pvscsi_bus_reset(struct Scsi_Host *host, int channel)
 {
-	struct Scsi_Host *host = cmd->device->host;
 	struct pvscsi_adapter *adapter = shost_priv(host);
 	unsigned long flags;
 
-	scmd_printk(KERN_INFO, cmd, "SCSI Bus reset\n");
+	shost_printk(KERN_INFO, host, "SCSI Bus reset\n");
 
 	/*
 	 * We don't want to queue new requests for this bus after
diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 4c27913..a302943 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -481,11 +481,11 @@ static int wd719x_abort(struct scsi_cmnd *cmd)
 	return SUCCESS;
 }
 
-static int wd719x_reset(struct scsi_cmnd *cmd, u8 opcode, u8 device)
+static int wd719x_reset(struct Scsi_Host *shost, u8 opcode, u8 device)
 {
 	int result;
 	unsigned long flags;
-	struct wd719x *wd = shost_priv(cmd->device->host);
+	struct wd719x *wd = shost_priv(shost);
 
 	dev_info(&wd->pdev->dev, "%s reset requested\n",
 		 (opcode == WD719X_CMD_BUSRESET) ? "bus" : "device");
@@ -502,12 +502,13 @@ static int wd719x_reset(struct scsi_cmnd *cmd, u8 opcode, u8 device)
 
 static int wd719x_dev_reset(struct scsi_cmnd *cmd)
 {
-	return wd719x_reset(cmd, WD719X_CMD_RESET, cmd->device->id);
+	return wd719x_reset(cmd->device->host, WD719X_CMD_RESET,
+			    cmd->device->id);
 }
 
-static int wd719x_bus_reset(struct scsi_cmnd *cmd)
+static int wd719x_bus_reset(struct Scsi_Host *host, int channel)
 {
-	return wd719x_reset(cmd, WD719X_CMD_BUSRESET, 0);
+	return wd719x_reset(host, WD719X_CMD_BUSRESET, 0);
 }
 
 static int wd719x_host_reset(struct Scsi_Host *host)
diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
index c58bf09..ba66cd1 100644
--- a/drivers/staging/unisys/visorhba/visorhba_main.c
+++ b/drivers/staging/unisys/visorhba/visorhba_main.c
@@ -101,6 +101,10 @@ struct visorhba_devices_open {
 	struct visorhba_devdata *devdata;
 };
 
+#define for_each_vbus_match(iter, list, match) \
+	for (iter = &list->head; iter->next; iter = iter->next) \
+		if ((iter->channel == match->channel))
+
 /*
  *	visor_thread_start - starts a thread for the device
  *	@threadfn: Function the thread starts
@@ -413,25 +417,23 @@ static int visorhba_device_reset_handler(struct scsi_cmnd *scsicmd)
  *
  *	Returns SUCCESS
  */
-static int visorhba_bus_reset_handler(struct scsi_cmnd *scsicmd)
+static int visorhba_bus_reset_handler(struct Scsi_Host *scsihost, int channel)
 {
-	struct scsi_device *scsidev;
+	struct scsi_device *scsidev = NULL, *tmp;
 	struct visordisk_info *vdisk;
-	int rtn;
+	int rtn = SUCCESS;
 
-	scsidev = scsicmd->device;
-	shost_for_each_device(scsidev, scsidev->host) {
-		vdisk = scsidev->hostdata;
+	shost_for_each_device(tmp, scsihost) {
+		vdisk = tmp->hostdata;
 		if (atomic_read(&vdisk->error_count) < VISORHBA_ERROR_COUNT)
 			atomic_inc(&vdisk->error_count);
 		else
 			atomic_set(&vdisk->ios_threshold, IOS_ERROR_THRESHOLD);
+		if (!scsidev)
+			scsidev = tmp;
 	}
-	rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
-	if (rtn == SUCCESS) {
-		scsicmd->result = DID_RESET << 16;
-		scsicmd->scsi_done(scsicmd);
-	}
+	if (scsidev)
+		rtn = forward_taskmgmt_command(TASK_MGMT_BUS_RESET, scsidev);
 	return rtn;
 }
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 8cd2926..04f8fb7 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -465,9 +465,9 @@ static int device_reset(struct scsi_cmnd *srb)
 }
 
 /* Simulate a SCSI bus reset by resetting the device's USB port. */
-static int bus_reset(struct scsi_cmnd *srb)
+static int bus_reset(struct Scsi_Host *shost, int channel)
 {
-	struct us_data *us = host_to_us(srb->device->host);
+	struct us_data *us = host_to_us(shost);
 	int result;
 
 	usb_stor_dbg(us, "%s called\n", __func__);
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b85f8a5..0c5ce78 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -147,7 +147,7 @@ struct scsi_host_template {
 	int (* eh_abort_handler)(struct scsi_cmnd *);
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
 	int (* eh_target_reset_handler)(struct scsi_cmnd *);
-	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
+	int (* eh_bus_reset_handler)(struct Scsi_Host *, int);
 	int (* eh_host_reset_handler)(struct Scsi_Host *);
 
 	/*
-- 
1.8.5.6
