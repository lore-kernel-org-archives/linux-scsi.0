From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] Re: sleeping in scsi EH
Date: Fri, 27 May 2005 06:45:53 -0400
Message-ID: <4296FA61.4010003@pobox.com>
References: <42968560.7020608@pobox.com> <20050527070954.GA27256@infradead.org> <4296DC49.5020907@pobox.com> <20050527084220.GA29352@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050900020502000706070705"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:30430 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262429AbVE0KqE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 06:46:04 -0400
In-Reply-To: <20050527084220.GA29352@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------050900020502000706070705
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Christoph Hellwig wrote:
> On Fri, May 27, 2005 at 04:37:29AM -0400, Jeff Garzik wrote:
> 
>>Christoph Hellwig wrote:
>>
>>>You can sleep in them.  You must however release the host lock and enable
>>>irqs first and reverse that before returning.  The error handlers don't
>>>need the host lock, but we're stuck with the unfortunate calling convention
>>>for now.
>>
>>Why are we stuck with this calling convention, when everyone who cares 
>>circumvents it?
> 
> 
> Because no one found the time to do a full transition yet.  If you want to
> update all scsi drivers feel free.  One patch per method please.

Something like the attached?


--------------050900020502000706070705
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

 Documentation/scsi/scsi_mid_low_api.txt |    3 +--
 drivers/fc4/fc.c                        |    2 --
 drivers/message/fusion/mptscsih.c       |    5 -----
 drivers/s390/scsi/zfcp_scsi.c           |   13 ++++++++++++-
 drivers/scsi/NCR53c406a.c               |    7 -------
 drivers/scsi/aacraid/linit.c            |    9 ---------
 drivers/scsi/aha1542.c                  |   15 ---------------
 drivers/scsi/aha1542.h                  |    1 -
 drivers/scsi/aic7xxx/aic79xx_osm.c      |    8 ++++----
 drivers/scsi/aic7xxx/aic7xxx_osm.c      |    4 ++++
 drivers/scsi/aic7xxx_old.c              |   15 ++++++++++++++-
 drivers/scsi/gdth.c                     |    8 --------
 drivers/scsi/ibmmca.c                   |   14 +++++++++++++-
 drivers/scsi/ibmvscsi/ibmvscsi.c        |    2 --
 drivers/scsi/in2000.c                   |   12 +++++++++++-
 drivers/scsi/ipr.c                      |    8 +++++++-
 drivers/scsi/ips.c                      |    7 +++++++
 drivers/scsi/lpfc/lpfc_scsi.c           |   12 +++++++++++-
 drivers/scsi/mac53c94.c                 |    6 ------
 drivers/scsi/megaraid/megaraid_mbox.c   |   17 ++++++++++++++++-
 drivers/scsi/qla1280.c                  |    8 +++++++-
 drivers/scsi/qla2xxx/qla_os.c           |    2 --
 drivers/scsi/scsi_error.c               |   13 ++-----------
 drivers/scsi/sym53c416.c                |    6 ------
 drivers/scsi/sym53c416.h                |    1 -
 drivers/scsi/sym53c8xx_2/sym_glue.c     |    8 +++++++-
 drivers/scsi/ultrastor.c                |    4 +---
 drivers/usb/storage/scsiglue.c          |    2 --
 28 files changed, 117 insertions(+), 95 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -936,8 +936,7 @@ Details:
  *
  *      Returns SUCCESS if command aborted else FAILED
  *
- *      Locks: struct Scsi_Host::host_lock held (with irqsave) on entry 
- *      and assumed to be held on return.
+ *      Locks: None held.  EH context.
  *
  *      Calling context: kernel thread
  *
diff --git a/drivers/fc4/fc.c b/drivers/fc4/fc.c
--- a/drivers/fc4/fc.c
+++ b/drivers/fc4/fc.c
@@ -912,9 +912,7 @@ int fcp_scsi_abort(Scsi_Cmnd *SCpnt)
 		unsigned long flags;
 
 		SCpnt->result = DID_ABORT;
-		spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 		fcmd->done(SCpnt);
-		spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
 		printk("FC: soft abort\n");
 		return SUCCESS;
 	} else {
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2115,7 +2115,6 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 	MPT_FRAME_HDR	*mf;
 	u32		 ctx2abort;
 	int		 scpnt_idx;
-	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -2163,7 +2162,6 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 
 	hd->abortSCpnt = SCpnt;
 
-	spin_unlock_irq(host_lock);
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 		SCpnt->device->channel, SCpnt->device->id, SCpnt->device->lun,
 		ctx2abort, 2 /* 2 second timeout */)
@@ -2180,8 +2178,6 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
 
-		spin_lock_irq(host_lock);
-
 		/* Unmap the DMA buffers, if any. */
 		if (SCpnt->use_sg) {
 			pci_unmap_sg(ioc->pcidev, (struct scatterlist *) SCpnt->request_buffer,
@@ -2197,7 +2193,6 @@ mptscsih_abort(struct scsi_cmnd * SCpnt)
 		mpt_free_msg_frame(ioc, mf);
 		return FAILED;
 	}
-	spin_lock_irq(host_lock);
 	return SUCCESS;
 }
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -433,7 +433,7 @@ zfcp_port_lookup(struct zfcp_adapter *ad
  *		FAILED	- otherwise
  */
 int
-zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
+__zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
 {
 	int retval = SUCCESS;
 	struct zfcp_fsf_req *new_fsf_req, *old_fsf_req;
@@ -611,6 +611,17 @@ zfcp_scsi_eh_abort_handler(struct scsi_c
 	return retval;
 }
 
+int
+zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
+{
+	int rc;
+	struct Scsi_Host *scsi_host = scpnt->device->host;
+	spin_lock_irq(scsi_host->host_lock);
+	rc = __zfcp_scsi_eh_abort_handler(scpnt);
+	spin_unlock_irq(scsi_host->host_lock);
+	return rc;
+}
+
 /*
  * function:	zfcp_scsi_eh_device_reset_handler
  *
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -722,12 +722,6 @@ static int NCR53c406a_queue(Scsi_Cmnd * 
 	return 0;
 }
 
-static int NCR53c406a_abort(Scsi_Cmnd * SCpnt)
-{
-	DEB(printk("NCR53c406a_abort called\n"));
-	return FAILED;		/* Don't know how to abort */
-}
-
 static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
 {
 	DEB(printk("NCR53c406a_reset called\n"));
@@ -1075,7 +1069,6 @@ static Scsi_Host_Template driver_templat
      .release            	= NCR53c406a_release,
      .info              	= NCR53c406a_info		/* info */,             
      .queuecommand      	= NCR53c406a_queue	/* queuecommand */,     
-     .eh_abort_handler  	= NCR53c406a_abort	/* abort */,            
      .eh_bus_reset_handler      = NCR53c406a_bus_reset	/* reset */,            
      .eh_device_reset_handler   = NCR53c406a_device_reset	/* reset */,            
      .eh_host_reset_handler     = NCR53c406a_host_reset	/* reset */,            
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -361,14 +361,6 @@ static int aac_ioctl(struct scsi_device 
 }
 
 /*
- * XXX: does aac really need no error handling??
- */
-static int aac_eh_abort(struct scsi_cmnd *cmd)
-{
-	return FAILED;
-}
-
-/*
  *	aac_eh_reset	- Reset command handling
  *	@scsi_cmd:	SCSI command block causing the reset
  *
@@ -547,7 +539,6 @@ static struct scsi_host_template aac_dri
 	.queuecommand   		= aac_queuecommand,
 	.bios_param     		= aac_biosparm,	
 	.slave_configure		= aac_slave_configure,
-	.eh_abort_handler		= aac_eh_abort,
 	.eh_host_reset_handler		= aac_eh_reset,
 	.can_queue      		= AAC_NUM_IO_FIB,	
 	.this_id        		= 16,
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1348,20 +1348,6 @@ static int aha1542_restart(struct Scsi_H
 	return 0;
 }
 
-static int aha1542_abort(Scsi_Cmnd * SCpnt)
-{
-
-	/*
-	 * The abort command does not leave the device in a clean state where
-	 *  it is available to be used again.  Until this gets worked out, we
-	 * will leave it commented out.  
-	 */
-
-	printk(KERN_ERR "aha1542.c: Unable to abort command for target %d\n",
-	       SCpnt->device->id);
-	return FAILED;
-}
-
 /*
  * This is a device reset.  This is handled by sending a special command
  * to the device.
@@ -1817,7 +1803,6 @@ static Scsi_Host_Template driver_templat
 	.detect			= aha1542_detect,
 	.release		= aha1542_release,
 	.queuecommand		= aha1542_queuecommand,
-	.eh_abort_handler	= aha1542_abort,
 	.eh_device_reset_handler= aha1542_dev_reset,
 	.eh_bus_reset_handler	= aha1542_bus_reset,
 	.eh_host_reset_handler	= aha1542_host_reset,
diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
--- a/drivers/scsi/aha1542.h
+++ b/drivers/scsi/aha1542.h
@@ -133,7 +133,6 @@ struct ccb {			/* Command Control Block 
 
 static int aha1542_detect(Scsi_Host_Template *);
 static int aha1542_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int aha1542_abort(Scsi_Cmnd * SCpnt);
 static int aha1542_bus_reset(Scsi_Cmnd * SCpnt);
 static int aha1542_dev_reset(Scsi_Cmnd * SCpnt);
 static int aha1542_host_reset(Scsi_Cmnd * SCpnt);
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -941,7 +941,7 @@ ahd_linux_queue(Scsi_Cmnd * cmd, void (*
 	 */
 	cmd->scsi_done = scsi_done;
 
-	ahd_midlayer_entrypoint_lock(ahd, &flags);
+	ahd_lock(ahd, &flags);
 
 	/*
 	 * Close the race of a command that was in the process of
@@ -955,7 +955,7 @@ ahd_linux_queue(Scsi_Cmnd * cmd, void (*
 		ahd_cmd_set_transaction_status(cmd, CAM_REQUEUE_REQ);
 		ahd_linux_queue_cmd_complete(ahd, cmd);
 		ahd_schedule_completeq(ahd);
-		ahd_midlayer_entrypoint_unlock(ahd, &flags);
+		ahd_unlock(ahd, &flags);
 		return (0);
 	}
 	dev = ahd_linux_get_device(ahd, cmd->device->channel,
@@ -965,7 +965,7 @@ ahd_linux_queue(Scsi_Cmnd * cmd, void (*
 		ahd_cmd_set_transaction_status(cmd, CAM_RESRC_UNAVAIL);
 		ahd_linux_queue_cmd_complete(ahd, cmd);
 		ahd_schedule_completeq(ahd);
-		ahd_midlayer_entrypoint_unlock(ahd, &flags);
+		ahd_unlock(ahd, &flags);
 		printf("%s: aic79xx_linux_queue - Unable to allocate device!\n",
 		       ahd_name(ahd));
 		return (0);
@@ -979,7 +979,7 @@ ahd_linux_queue(Scsi_Cmnd * cmd, void (*
 		dev->flags |= AHD_DEV_ON_RUN_LIST;
 		ahd_linux_run_device_queues(ahd);
 	}
-	ahd_midlayer_entrypoint_unlock(ahd, &flags);
+	ahd_unlock(ahd, &flags);
 	return (0);
 }
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -2361,6 +2361,8 @@ ahc_linux_queue_recovery_cmd(struct scsi
 		printf(" 0x%x", cmd->cmnd[cdb_byte]);
 	printf("\n");
 
+	spin_lock_irq(&ahc->platform_data->spin_lock);
+
 	/*
 	 * First determine if we currently own this command.
 	 * Start by searching the device queue.  If not found
@@ -2616,6 +2618,8 @@ done:
 		}
 		spin_lock_irq(&ahc->platform_data->spin_lock);
 	}
+
+	spin_unlock_irq(&ahc->platform_data->spin_lock);
 	return (retval);
 }
 
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -10585,7 +10585,7 @@ aic7xxx_panic_abort(struct aic7xxx_host 
  *   Abort the current SCSI command(s).
  *-F*************************************************************************/
 static int
-aic7xxx_abort(Scsi_Cmnd *cmd)
+__aic7xxx_abort(Scsi_Cmnd *cmd)
 {
   struct aic7xxx_scb  *scb = NULL;
   struct aic7xxx_host *p;
@@ -10802,6 +10802,19 @@ success:
   return SUCCESS;
 }
 
+static int
+aic7xxx_abort(Scsi_Cmnd *cmd)
+{
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = __aic7xxx_abort(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
+}
+
+
 /*+F*************************************************************************
  * Function:
  *   aic7xxx_reset
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4703,13 +4703,6 @@ static const char *gdth_info(struct Scsi
     return ((const char *)ha->binfo.type_string);
 }
 
-/* new error handling */
-static int gdth_eh_abort(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_eh_abort()\n"));
-    return FAILED;
-}
-
 static int gdth_eh_device_reset(Scsi_Cmnd *scp)
 {
     TRACE2(("gdth_eh_device_reset()\n"));
@@ -5713,7 +5706,6 @@ static Scsi_Host_Template driver_templat
         .release                = gdth_release,
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
-        .eh_abort_handler       = gdth_eh_abort, 
         .eh_device_reset_handler = gdth_eh_device_reset,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
         .eh_host_reset_handler  = gdth_eh_host_reset,
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -2118,7 +2118,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd
 	return 0;
 }
 
-static int ibmmca_abort(Scsi_Cmnd * cmd)
+static int __ibmmca_abort(Scsi_Cmnd * cmd)
 {
 	/* Abort does not work, as the adapter never generates an interrupt on
 	 * whatever situation is simulated, even when really pending commands
@@ -2225,6 +2225,18 @@ static int ibmmca_abort(Scsi_Cmnd * cmd)
 	}
 }
 
+static int ibmmca_abort(Scsi_Cmnd * cmd)
+{
+	struct Scsi_Host *shpnt = cmd->device->host;
+	int rc;
+
+	spin_lock_irq(shpnt->host_lock);
+	rc = __ibmmca_abort(cmd);
+	spin_unlock_irq(shpnt->host_lock);
+
+	return rc;
+}
+
 static int ibmmca_host_reset(Scsi_Cmnd * cmd)
 {
 	struct Scsi_Host *shpnt;
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -874,9 +874,7 @@ static int ibmvscsi_eh_abort_handler(str
 		return FAILED;
 	}
 
-	spin_unlock_irq(hostdata->host->host_lock);
 	wait_for_completion(&evt->comp);
-	spin_lock_irq(hostdata->host->host_lock);
 
 	/* make sure we got a good response */
 	if (unlikely(srp_rsp.srp.generic.type != SRP_RSP_TYPE)) {
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -1682,7 +1682,7 @@ static int in2000_device_reset(Scsi_Cmnd
 }
 
 
-static int in2000_abort(Scsi_Cmnd * cmd)
+static int __in2000_abort(Scsi_Cmnd * cmd)
 {
 	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hostdata;
@@ -1803,6 +1803,16 @@ static int in2000_abort(Scsi_Cmnd * cmd)
 	return SUCCESS;
 }
 
+static int in2000_abort(Scsi_Cmnd * cmd)
+{
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = __in2000_abort(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
+}
 
 
 #define MAX_IN2000_HOSTS 3
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3119,6 +3119,8 @@ static int ipr_cancel_op(struct scsi_cmn
 static int ipr_eh_abort(struct scsi_cmnd * scsi_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
+	unsigned long flags;
+	int rc;
 
 	ENTER;
 	ioa_cfg = (struct ipr_ioa_cfg *) scsi_cmd->device->host->hostdata;
@@ -3133,8 +3135,12 @@ static int ipr_eh_abort(struct scsi_cmnd
 	if (!scsi_cmd->device->hostdata)
 		return FAILED;
 
+	spin_lock_irqsave(scsi_cmd->device->host->host_lock, flags);
+	rc = ipr_cancel_op(scsi_cmd);
+	spin_unlock_irqrestore(scsi_cmd->device->host->host_lock, flags);
+
 	LEAVE;
-	return ipr_cancel_op(scsi_cmd);
+	return rc;
 }
 
 /**
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -819,12 +819,15 @@ ips_eh_abort(Scsi_Cmnd * SC)
 	ips_ha_t *ha;
 	ips_copp_wait_item_t *item;
 	int ret;
+	unsigned long cpu_flags;
+	struct Scsi_Host *host;
 
 	METHOD_TRACE("ips_eh_abort", 1);
 
 	if (!SC)
 		return (FAILED);
 
+	host = SC->device->host;
 	ha = (ips_ha_t *) SC->device->host->hostdata;
 
 	if (!ha)
@@ -833,6 +836,8 @@ ips_eh_abort(Scsi_Cmnd * SC)
 	if (!ha->active)
 		return (FAILED);
 
+	IPS_LOCK_SAVE(host->host_lock, cpu_flags);
+
 	/* See if the command is on the copp queue */
 	item = ha->copp_waitlist.head;
 	while ((item) && (item->scsi_cmd != SC))
@@ -851,6 +856,8 @@ ips_eh_abort(Scsi_Cmnd * SC)
 		/* command must have already been sent */
 		ret = (FAILED);
 	}
+
+	IPS_UNLOCK_RESTORE(host->host_lock, cpu_flags);
 	return ret;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -798,7 +798,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 }
 
 static int
-lpfc_abort_handler(struct scsi_cmnd *cmnd)
+__lpfc_abort_handler(struct scsi_cmnd *cmnd)
 {
 	struct lpfc_hba *phba =
 			(struct lpfc_hba *)cmnd->device->host->hostdata[0];
@@ -918,6 +918,16 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 }
 
 static int
+lpfc_abort_handler(struct scsi_cmnd *cmnd)
+{
+	int rc;
+	spin_lock_irq(cmnd->device->host->host_lock);
+	rc = __lpfc_abort_handler(cmnd);
+	spin_unlock_irq(cmnd->device->host->host_lock);
+	return rc;
+}
+
+static int
 lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -98,11 +98,6 @@ static int mac53c94_queue(struct scsi_cm
 	return 0;
 }
 
-static int mac53c94_abort(struct scsi_cmnd *cmd)
-{
-	return FAILED;
-}
-
 static int mac53c94_host_reset(struct scsi_cmnd *cmd)
 {
 	struct fsc_state *state = (struct fsc_state *) cmd->device->host->hostdata;
@@ -416,7 +411,6 @@ static struct scsi_host_template mac53c9
 	.proc_name	= "53c94",
 	.name		= "53C94",
 	.queuecommand	= mac53c94_queue,
-	.eh_abort_handler = mac53c94_abort,
 	.eh_host_reset_handler = mac53c94_host_reset,
 	.can_queue	= 1,
 	.this_id	= 7,
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2661,7 +2661,7 @@ megaraid_mbox_dpc(unsigned long devp)
  * aborted. All the commands issued to the F/W must complete.
  **/
 static int
-megaraid_abort_handler(struct scsi_cmnd *scp)
+__megaraid_abort_handler(struct scsi_cmnd *scp)
 {
 	adapter_t		*adapter;
 	mraid_device_t		*raid_dev;
@@ -2794,6 +2794,21 @@ megaraid_abort_handler(struct scsi_cmnd 
 	return FAILED;
 }
 
+static int
+megaraid_abort_handler(struct scsi_cmnd *scp)
+{
+	adapter_t	*adapter;
+	int rc;
+
+	adapter		= SCP2ADAPTER(scp);
+
+	spin_lock_irq(adapter->host_lock);
+	rc = __megaraid_abort_handler(scp);
+	spin_unlock_irq(adapter->host_lock);
+
+	return rc;
+}
+
 
 /**
  * megaraid_reset_handler - device reset hadler for mailbox based driver
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1098,7 +1098,13 @@ qla1280_error_action(struct scsi_cmnd *c
 static int
 qla1280_eh_abort(struct scsi_cmnd * cmd)
 {
-	return qla1280_error_action(cmd, ABORT_COMMAND);
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = qla1280_error_action(cmd, ABORT_COMMAND);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
 }
 
 /**************************************************************************
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -518,7 +518,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	serial = cmd->serial_number;
 
 	/* Check active list for command command. */
-	spin_unlock_irq(ha->host->host_lock);
 	spin_lock(&ha->hardware_lock);
 	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
 		sp = ha->outstanding_cmds[i];
@@ -558,7 +557,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		}
 		spin_lock(&ha->hardware_lock);
 	}
-	spin_lock_irq(ha->host->host_lock);
 
 	qla_printk(KERN_INFO, ha, 
 	    "scsi(%ld:%d:%d): Abort command issued -- %lx %x.\n", ha->host_no,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -528,10 +528,8 @@ static int scsi_send_eh_cmnd(struct scsi
 		 * abort a timed out command or not.  not sure how
 		 * we should treat them differently anyways.
 		 */
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (shost->hostt->eh_abort_handler)
 			shost->hostt->eh_abort_handler(scmd);
-		spin_unlock_irqrestore(shost->host_lock, flags);
 			
 		scmd->request->rq_status = RQ_SCSI_DONE;
 		scmd->owner = SCSI_OWNER_ERROR_HANDLER;
@@ -737,11 +735,8 @@ static int scsi_eh_get_sense(struct list
  **/
 static int scsi_try_to_abort_cmd(struct scsi_cmnd *scmd)
 {
-	unsigned long flags;
-	int rtn = FAILED;
-
 	if (!scmd->device->host->hostt->eh_abort_handler)
-		return rtn;
+		return FAILED;
 
 	/*
 	 * scsi_done was called just after the command timed out and before
@@ -752,11 +747,7 @@ static int scsi_try_to_abort_cmd(struct 
 
 	scmd->owner = SCSI_OWNER_LOWLEVEL;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
-	rtn = scmd->device->host->hostt->eh_abort_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
-
-	return rtn;
+	return scmd->device->host->hostt->eh_abort_handler(scmd);
 }
 
 /**
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -785,11 +785,6 @@ int sym53c416_queuecommand(Scsi_Cmnd *SC
 	return 0;
 }
 
-static int sym53c416_abort(Scsi_Cmnd *SCpnt)
-{
-	return FAILED;
-}
-
 static int sym53c416_bus_reset(Scsi_Cmnd *SCpnt)
 {
 	return FAILED;
@@ -865,7 +860,6 @@ static Scsi_Host_Template driver_templat
 	.detect =		sym53c416_detect,
 	.info =			sym53c416_info,	
 	.queuecommand =		sym53c416_queuecommand,
-	.eh_abort_handler =	sym53c416_abort,
 	.eh_host_reset_handler =sym53c416_host_reset,
 	.eh_bus_reset_handler = sym53c416_bus_reset,
 	.eh_device_reset_handler =sym53c416_device_reset,
diff --git a/drivers/scsi/sym53c416.h b/drivers/scsi/sym53c416.h
--- a/drivers/scsi/sym53c416.h
+++ b/drivers/scsi/sym53c416.h
@@ -26,7 +26,6 @@ static int sym53c416_detect(Scsi_Host_Te
 static const char *sym53c416_info(struct Scsi_Host *);
 static int sym53c416_release(struct Scsi_Host *);
 static int sym53c416_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int sym53c416_abort(Scsi_Cmnd *);
 static int sym53c416_host_reset(Scsi_Cmnd *);
 static int sym53c416_bus_reset(Scsi_Cmnd *);
 static int sym53c416_device_reset(Scsi_Cmnd *);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -882,7 +882,13 @@ prepare:
  */
 static int sym53c8xx_eh_abort_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = sym_eh_handler(SYM_EH_ABORT, "ABORT", cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
 }
 
 static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -879,7 +879,7 @@ static int ultrastor_abort(Scsi_Cmnd *SC
 	ogm_addr = (unsigned int)isa_bus_to_virt(inl(port0 + 23));
 	icm_status = inb(port0 + 27);
 	icm_addr = (unsigned int)isa_bus_to_virt(inl(port0 + 28));
-	spin_lock_irqsave(host->host_lock, flags);
+	spin_unlock_irqrestore(host->host_lock, flags);
       }
 
     /* First check to see if an interrupt is pending.  I suspect the SiS
@@ -954,9 +954,7 @@ static int ultrastor_abort(Scsi_Cmnd *SC
     SCpnt->result = DID_ABORT << 16;
     
     /* Take the host lock to guard against scsi layer re-entry */
-    spin_lock_irqsave(host->host_lock, flags);
     done(SCpnt);
-    spin_unlock_irqrestore(host->host_lock, flags);
 
     /* Need to set a timeout here in case command never completes.  */
     return SUCCESS;
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -233,13 +233,11 @@ static int command_abort(struct scsi_cmn
 		set_bit(US_FLIDX_ABORTING, &us->flags);
 		usb_stor_stop_transport(us);
 	}
-	scsi_unlock(us_to_host(us));
 
 	/* Wait for the aborted command to finish */
 	wait_for_completion(&us->notify);
 
 	/* Reacquire the lock and allow USB transfers to resume */
-	scsi_lock(us_to_host(us));
 	clear_bit(US_FLIDX_ABORTING, &us->flags);
 	clear_bit(US_FLIDX_TIMED_OUT, &us->flags);
 	return SUCCESS;

--------------050900020502000706070705--
