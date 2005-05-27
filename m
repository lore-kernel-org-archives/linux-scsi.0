From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] sleeping in ->eh_device_reset_handler()
Date: Fri, 27 May 2005 15:09:09 -0400
Message-ID: <42977055.6040301@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020709000205050409080603"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:36832 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262548AbVE0TJ2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 15:09:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: brking@us.ibm.com

This is a multi-part message in MIME format.
--------------020709000205050409080603
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Next patch in the series, for review.



--------------020709000205050409080603
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -973,8 +973,7 @@ Details:
  *
  *      Returns SUCCESS if command aborted else FAILED
  *
- *      Locks: struct Scsi_Host::host_lock held (with irqsave) on entry
- *      and assumed to be held on return.
+ *      Locks: None held
  *
  *      Calling context: kernel thread
  *
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -2579,8 +2579,6 @@ static void sbp2scsi_complete_command(st
 				      u32 scsi_status, struct scsi_cmnd *SCpnt,
 				      void (*done)(struct scsi_cmnd *))
 {
-	unsigned long flags;
-
 	SBP2_DEBUG("sbp2scsi_complete_command");
 
 	/*
@@ -2679,11 +2677,7 @@ static void sbp2scsi_complete_command(st
 	/*
 	 * Tell scsi stack that we're done with this command
 	 */
-	spin_lock_irqsave(scsi_id->scsi_host->host_lock,flags);
 	done (SCpnt);
-	spin_unlock_irqrestore(scsi_id->scsi_host->host_lock,flags);
-
-	return;
 }
 
 
@@ -2746,7 +2740,7 @@ static int sbp2scsi_abort(struct scsi_cm
 /*
  * Called by scsi stack when something has really gone wrong.
  */
-static int sbp2scsi_reset(struct scsi_cmnd *SCpnt)
+static int __sbp2scsi_reset(struct scsi_cmnd *SCpnt)
 {
 	struct scsi_id_instance_data *scsi_id =
 		(struct scsi_id_instance_data *)SCpnt->device->host->hostdata[0];
@@ -2761,6 +2755,18 @@ static int sbp2scsi_reset(struct scsi_cm
 	return(SUCCESS);
 }
 
+static int sbp2scsi_reset(struct scsi_cmnd *SCpnt)
+{
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
+	rc = __sbp2scsi_reset(SCpnt);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
+
+	return rc;
+}
+
 static const char *sbp2scsi_info (struct Scsi_Host *host)
 {
         return "SCSI emulation for IEEE-1394 SBP-2 Devices";
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2209,7 +2209,6 @@ static int
 mptscsih_dev_reset(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
-	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
 
 	/* If we can't locate our host adapter structure, return FAILED status.
 	 */
@@ -2226,7 +2225,6 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 	printk(KERN_WARNING MYNAM ": %s: >> Attempting target reset! (sc=%p)\n",
 	       hd->ioc->name, SCpnt);
 
-	spin_unlock_irq(host_lock);
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
 		SCpnt->device->channel, SCpnt->device->id,
 		0, 0, 5 /* 5 second timeout */)
@@ -2238,12 +2236,10 @@ mptscsih_dev_reset(struct scsi_cmnd * SC
 		 		hd->ioc->name, SCpnt);
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
-		spin_lock_irq(host_lock);
 		return FAILED;
 	}
-	spin_lock_irq(host_lock);
-	return SUCCESS;
 
+	return SUCCESS;
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -636,8 +636,6 @@ zfcp_scsi_eh_device_reset_handler(struct
 	struct zfcp_unit *unit = (struct zfcp_unit *) scpnt->device->hostdata;
 	struct Scsi_Host *scsi_host = scpnt->device->host;
 
-	spin_unlock_irq(scsi_host->host_lock);
-
 	if (!unit) {
 		ZFCP_LOG_NORMAL("bug: Tried reset for nonexistent unit\n");
 		retval = SUCCESS;
@@ -680,7 +678,6 @@ zfcp_scsi_eh_device_reset_handler(struct
 		retval = SUCCESS;
 	}
  out:
-	spin_lock_irq(scsi_host->host_lock);
 	return retval;
 }
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -170,7 +170,6 @@ MODULE_LICENSE("GPL");
 STATIC int NCR_700_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
 STATIC int NCR_700_abort(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_bus_reset(struct scsi_cmnd * SCpnt);
-STATIC int NCR_700_dev_reset(struct scsi_cmnd * SCpnt);
 STATIC int NCR_700_host_reset(struct scsi_cmnd * SCpnt);
 STATIC void NCR_700_chip_setup(struct Scsi_Host *host);
 STATIC void NCR_700_chip_reset(struct Scsi_Host *host);
@@ -330,7 +329,6 @@ NCR_700_detect(struct scsi_host_template
 	/* Fill in the missing routines from the host template */
 	tpnt->queuecommand = NCR_700_queuecommand;
 	tpnt->eh_abort_handler = NCR_700_abort;
-	tpnt->eh_device_reset_handler = NCR_700_dev_reset;
 	tpnt->eh_bus_reset_handler = NCR_700_bus_reset;
 	tpnt->eh_host_reset_handler = NCR_700_host_reset;
 	tpnt->can_queue = NCR_700_COMMAND_SLOTS_PER_HOST;
@@ -1980,16 +1978,6 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 }
 
 STATIC int
-NCR_700_dev_reset(struct scsi_cmnd * SCp)
-{
-	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants device reset\n\t",
-	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
-	scsi_print_command(SCp);
-	
-	return FAILED;
-}
-
-STATIC int
 NCR_700_host_reset(struct scsi_cmnd * SCp)
 {
 	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants HOST reset\n\t",
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2835,20 +2835,6 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 }
 
 /* 
- * Function : int NCR5380_device_reset (Scsi_Cmnd *cmd)
- * 
- * Purpose : reset a SCSI device
- *
- * Returns : FAILED
- *
- * Locks: io_request_lock held by caller
- */
-
-static int NCR5380_device_reset(Scsi_Cmnd * cmd) {
-	return FAILED;
-}
-
-/* 
  * Function : int NCR5380_host_reset (Scsi_Cmnd *cmd)
  * 
  * Purpose : reset a SCSI device
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -307,7 +307,6 @@ static void NCR5380_print(struct Scsi_Ho
 static int NCR5380_abort(Scsi_Cmnd * cmd);
 static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
 static int NCR5380_host_reset(Scsi_Cmnd * cmd);
-static int NCR5380_device_reset(Scsi_Cmnd * cmd);
 static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
 static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
 off_t offset, int length, int inout);
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -735,11 +735,6 @@ static int NCR53c406a_host_reset(Scsi_Cm
 	return SUCCESS;
 }
 
-static int NCR53c406a_device_reset(Scsi_Cmnd * SCpnt)
-{
-	return FAILED;
-}
-
 static int NCR53c406a_bus_reset(Scsi_Cmnd * SCpnt)
 {
 	return FAILED;
@@ -1070,7 +1065,6 @@ static Scsi_Host_Template driver_templat
      .info              	= NCR53c406a_info		/* info */,             
      .queuecommand      	= NCR53c406a_queue	/* queuecommand */,     
      .eh_bus_reset_handler      = NCR53c406a_bus_reset	/* reset */,            
-     .eh_device_reset_handler   = NCR53c406a_device_reset	/* reset */,            
      .eh_host_reset_handler     = NCR53c406a_host_reset	/* reset */,            
      .bios_param        	= NCR53c406a_biosparm	/* biosparm */,         
      .can_queue         	= 1			/* can_queue */,        
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1225,8 +1225,6 @@ static int aha152x_device_reset(Scsi_Cmn
 	}
 
 	DO_UNLOCK(flags);
-
-	spin_lock_irq(shpnt->host_lock);
 	return ret;
 }
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1511,17 +1511,17 @@ ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 		       ahd_name(ahd), cmd->device->channel, cmd->device->id,
 		       cmd->device->lun, cmd);
 #endif
-	ahd_midlayer_entrypoint_lock(ahd, &s);
+	ahd_lock(ahd, &s);
 
 	dev = ahd_linux_get_device(ahd, cmd->device->channel, cmd->device->id,
 				   cmd->device->lun, /*alloc*/FALSE);
 	if (dev == NULL) {
-		ahd_midlayer_entrypoint_unlock(ahd, &s);
+		ahd_unlock(ahd, &s);
 		kfree(recovery_cmd);
 		return (FAILED);
 	}
 	if ((scb = ahd_get_scb(ahd, AHD_NEVER_COL_IDX)) == NULL) {
-		ahd_midlayer_entrypoint_unlock(ahd, &s);
+		ahd_unlock(ahd, &s);
 		kfree(recovery_cmd);
 		return (FAILED);
 	}
@@ -1570,7 +1570,7 @@ ahd_linux_dev_reset(Scsi_Cmnd *cmd)
 	spin_lock_irq(&ahd->platform_data->spin_lock);
 	ahd_schedule_runq(ahd);
 	ahd_linux_run_complete_queue(ahd);
-	ahd_midlayer_entrypoint_unlock(ahd, &s);
+	ahd_unlock(ahd, &s);
 	printf("%s: Device reset returning 0x%x\n", ahd_name(ahd), retval);
 	return (retval);
 }
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -10358,7 +10358,7 @@ aic7xxx_queue(Scsi_Cmnd *cmd, void (*fn)
  *   Returns an enumerated type that indicates the status of the operation.
  *-F*************************************************************************/
 static int
-aic7xxx_bus_device_reset(Scsi_Cmnd *cmd)
+__aic7xxx_bus_device_reset(Scsi_Cmnd *cmd)
 {
   struct aic7xxx_host  *p;
   struct aic7xxx_scb   *scb;
@@ -10551,6 +10551,18 @@ aic7xxx_bus_device_reset(Scsi_Cmnd *cmd)
     return SUCCESS;
 }
 
+static int
+aic7xxx_bus_device_reset(Scsi_Cmnd *cmd)
+{
+      int rc;
+
+      spin_lock_irq(cmd->device->host->host_lock);
+      rc = __aic7xxx_bus_device_reset(cmd);
+      spin_unlock_irq(cmd->device->host->host_lock);
+
+      return rc;
+}
+
 
 /*+F*************************************************************************
  * Function:
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -244,7 +244,6 @@ static Scsi_Host_Template cumanascsi_tem
 	.info			= cumanascsi_info,
 	.queuecommand		= cumanascsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
-	.eh_device_reset_handler= NCR5380_device_reset,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
 	.eh_host_reset_handler	= NCR5380_host_reset,
 	.can_queue		= 16,
diff --git a/drivers/scsi/arm/ecoscsi.c b/drivers/scsi/arm/ecoscsi.c
--- a/drivers/scsi/arm/ecoscsi.c
+++ b/drivers/scsi/arm/ecoscsi.c
@@ -162,7 +162,6 @@ static Scsi_Host_Template ecoscsi_templa
 	.info		= ecoscsi_info,
 	.queuecommand	= ecoscsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
-	.eh_device_reset_handler= NCR5380_device_reset,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
 	.eh_host_reset_handler	= NCR5380_host_reset,
 	.can_queue	= 16,
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -118,7 +118,6 @@ static Scsi_Host_Template oakscsi_templa
 	.info			= oakscsi_info,
 	.queuecommand		= oakscsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
-	.eh_device_reset_handler= NCR5380_device_reset,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
 	.eh_host_reset_handler	= NCR5380_host_reset,
 	.can_queue		= 16,
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -61,7 +61,6 @@ static struct scsi_host_template dmx3191
 	.queuecommand		= NCR5380_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
-	.eh_device_reset_handler= NCR5380_device_reset,
 	.eh_host_reset_handler	= NCR5380_host_reset,
 	.can_queue		= 32,
 	.this_id		= 7,
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -482,7 +482,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand			= dtc_queue_command,
 	.eh_abort_handler		= dtc_abort,
 	.eh_bus_reset_handler		= dtc_bus_reset,
-	.eh_device_reset_handler	= dtc_device_reset,
 	.eh_host_reset_handler          = dtc_host_reset,
 	.bios_param     		= dtc_biosparam,
 	.can_queue      		= CAN_QUEUE,
diff --git a/drivers/scsi/dtc.h b/drivers/scsi/dtc.h
--- a/drivers/scsi/dtc.h
+++ b/drivers/scsi/dtc.h
@@ -34,7 +34,6 @@ static int dtc_biosparam(struct scsi_dev
 static int dtc_detect(Scsi_Host_Template *);
 static int dtc_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int dtc_bus_reset(Scsi_Cmnd *);
-static int dtc_device_reset(Scsi_Cmnd *);
 static int dtc_host_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
@@ -86,7 +85,6 @@ static int dtc_host_reset(Scsi_Cmnd *);
 #define NCR5380_queue_command		dtc_queue_command
 #define NCR5380_abort			dtc_abort
 #define NCR5380_bus_reset		dtc_bus_reset
-#define NCR5380_device_reset		dtc_device_reset
 #define NCR5380_host_reset		dtc_host_reset
 #define NCR5380_proc_info		dtc_proc_info 
 
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -518,7 +518,6 @@ static struct scsi_host_template driver_
 	.release = eata2x_release,
 	.queuecommand = eata2x_queuecommand,
 	.eh_abort_handler = eata2x_eh_abort,
-	.eh_device_reset_handler = NULL,
 	.eh_bus_reset_handler = NULL,
 	.eh_host_reset_handler = eata2x_eh_host_reset,
 	.bios_param = eata2x_bios_param,
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -1246,11 +1246,6 @@ static int fd_mcs_host_reset(Scsi_Cmnd *
 	return FAILED;
 }
 
-static int fd_mcs_device_reset(Scsi_Cmnd * SCpnt) 
-{
-	return FAILED;
-}
-
 static int fd_mcs_bus_reset(Scsi_Cmnd * SCpnt) {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 
@@ -1358,7 +1353,6 @@ static Scsi_Host_Template driver_templat
 	.eh_abort_handler		= fd_mcs_abort,
 	.eh_bus_reset_handler		= fd_mcs_bus_reset,
 	.eh_host_reset_handler		= fd_mcs_host_reset,
-	.eh_device_reset_handler	= fd_mcs_device_reset,
 	.bios_param     		= fd_mcs_biosparam,
 	.can_queue      		= 1,
 	.this_id        		= 7,
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -908,7 +908,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand   	= generic_NCR5380_queue_command,
 	.eh_abort_handler	= generic_NCR5380_abort,
 	.eh_bus_reset_handler	= generic_NCR5380_bus_reset,
-	.eh_device_reset_handler = generic_NCR5380_device_reset,
 	.eh_host_reset_handler	= generic_NCR5380_host_reset,
 	.bios_param     	= NCR5380_BIOSPARAM,
 	.can_queue      	= CAN_QUEUE,
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -50,7 +50,6 @@ static int generic_NCR5380_release_resou
 static int generic_NCR5380_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int generic_NCR5380_bus_reset(Scsi_Cmnd *);
 static int generic_NCR5380_host_reset(Scsi_Cmnd *);
-static int generic_NCR5380_device_reset(Scsi_Cmnd *);
 static const char* generic_NCR5380_info(struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN
@@ -114,7 +113,6 @@ static const char* generic_NCR5380_info(
 #define NCR5380_queue_command generic_NCR5380_queue_command
 #define NCR5380_abort generic_NCR5380_abort
 #define NCR5380_bus_reset generic_NCR5380_bus_reset
-#define NCR5380_device_reset generic_NCR5380_device_reset
 #define NCR5380_host_reset generic_NCR5380_host_reset
 #define NCR5380_pread generic_NCR5380_pread
 #define NCR5380_pwrite generic_NCR5380_pwrite
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4703,12 +4703,6 @@ static const char *gdth_info(struct Scsi
     return ((const char *)ha->binfo.type_string);
 }
 
-static int gdth_eh_device_reset(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_eh_device_reset()\n"));
-    return FAILED;
-}
-
 static int gdth_eh_bus_reset(Scsi_Cmnd *scp)
 {
     int i, hanum;
@@ -5706,7 +5700,6 @@ static Scsi_Host_Template driver_templat
         .release                = gdth_release,
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
-        .eh_device_reset_handler = gdth_eh_device_reset,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
         .eh_host_reset_handler  = gdth_eh_host_reset,
         .bios_param             = gdth_bios_param,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -976,9 +976,7 @@ static int ibmvscsi_eh_device_reset_hand
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
@@ -1676,12 +1676,6 @@ static int in2000_host_reset(Scsi_Cmnd *
 	return FAILED;
 }
 
-static int in2000_device_reset(Scsi_Cmnd * cmd)
-{
-	return FAILED;
-}
-
-
 static int __in2000_abort(Scsi_Cmnd * cmd)
 {
 	struct Scsi_Host *instance;
@@ -2321,7 +2315,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand    		= in2000_queuecommand,
 	.eh_abort_handler		= in2000_abort,
 	.eh_bus_reset_handler		= in2000_bus_reset,
-	.eh_device_reset_handler	= in2000_device_reset,
 	.eh_host_reset_handler	= in2000_host_reset, 
 	.bios_param      		= in2000_biosparam, 
 	.can_queue       		= IN2000_CAN_Q,
diff --git a/drivers/scsi/in2000.h b/drivers/scsi/in2000.h
--- a/drivers/scsi/in2000.h
+++ b/drivers/scsi/in2000.h
@@ -403,7 +403,6 @@ static int in2000_biosparam(struct scsi_
 		sector_t, int *);
 static int in2000_host_reset(Scsi_Cmnd *);
 static int in2000_bus_reset(Scsi_Cmnd *);
-static int in2000_device_reset(Scsi_Cmnd *);
 
 
 #define IN2000_CAN_Q    16
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2916,7 +2916,7 @@ static int ipr_eh_host_reset(struct scsi
  * Return value:
  *	SUCCESS / FAILED
  **/
-static int ipr_eh_dev_reset(struct scsi_cmnd * scsi_cmd)
+static int __ipr_eh_dev_reset(struct scsi_cmnd * scsi_cmd)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -2970,6 +2970,17 @@ static int ipr_eh_dev_reset(struct scsi_
 	return (IPR_IOASC_SENSE_KEY(ioasc) ? FAILED : SUCCESS);
 }
 
+static int ipr_eh_dev_reset(struct scsi_cmnd * cmd)
+{
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = __ipr_eh_dev_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
+}
+
 /**
  * ipr_bus_reset_done - Op done function for bus reset.
  * @ipr_cmd:	ipr command struct
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -928,7 +928,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 }
 
 static int
-lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
+__lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
@@ -1040,6 +1040,16 @@ out:
 	return ret;
 }
 
+static int
+lpfc_reset_lun_handler(struct scsi_cmnd *cmnd)
+{
+	int rc;
+	spin_lock_irq(cmnd->device->host->host_lock);
+	rc = __lpfc_reset_lun_handler(cmnd);
+	spin_unlock_irq(cmnd->device->host->host_lock);
+	return rc;
+}
+
 /*
  * Note: midlayer calls this function with the host_lock held
  */
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -591,7 +591,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand			= macscsi_queue_command,
 	.eh_abort_handler		= macscsi_abort,
 	.eh_bus_reset_handler		= macscsi_bus_reset,
-	.eh_device_reset_handler	= macscsi_device_reset,
 	.eh_host_reset_handler		= macscsi_host_reset,
 	.can_queue			= CAN_QUEUE,
 	.this_id			= 7,
diff --git a/drivers/scsi/mac_scsi.h b/drivers/scsi/mac_scsi.h
--- a/drivers/scsi/mac_scsi.h
+++ b/drivers/scsi/mac_scsi.h
@@ -72,7 +72,6 @@
 #define NCR5380_queue_command macscsi_queue_command
 #define NCR5380_abort macscsi_abort
 #define NCR5380_bus_reset macscsi_bus_reset
-#define NCR5380_device_reset macscsi_device_reset
 #define NCR5380_host_reset macscsi_host_reset
 #define NCR5380_proc_info macscsi_proc_info
 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -1938,7 +1938,7 @@ megaraid_abort(Scsi_Cmnd *cmd)
 
 
 static int
-megaraid_reset(Scsi_Cmnd *cmd)
+__megaraid_reset(Scsi_Cmnd *cmd)
 {
 	adapter_t	*adapter;
 	megacmd_t	mc;
@@ -1972,6 +1972,18 @@ megaraid_reset(Scsi_Cmnd *cmd)
 	return rval;
 }
 
+static int
+megaraid_reset(Scsi_Cmnd *cmd)
+{
+	adapter = (adapter_t *)cmd->device->host->hostdata;
+	int rc;
+
+	spin_lock_irq(&adapter->lock);
+	rc = __megaraid_reset(cmd);
+	spin_unlock_irq(&adapter->lock);
+
+	return rc;
+}
 
 
 /**
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2821,7 +2821,7 @@ megaraid_abort_handler(struct scsi_cmnd 
  * host
  **/
 static int
-megaraid_reset_handler(struct scsi_cmnd *scp)
+__megaraid_reset_handler(struct scsi_cmnd *scp)
 {
 	adapter_t	*adapter;
 	scb_t		*scb;
@@ -2942,6 +2942,18 @@ megaraid_reset_handler(struct scsi_cmnd 
 	return rval;
 }
 
+static int
+megaraid_reset_handler(struct scsi_cmnd *cmd)
+{
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = __megaraid_reset_handler(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
+}
+
 
 /*
  * START: internal commands library
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -294,7 +294,6 @@ static struct scsi_host_template nsp32_t
 	.this_id			= NSP32_HOST_SCSIID,
 	.use_clustering			= DISABLE_CLUSTERING,
 	.eh_abort_handler       	= nsp32_eh_abort,
-/*	.eh_device_reset_handler	= NULL, */
 	.eh_bus_reset_handler		= nsp32_eh_bus_reset,
 	.eh_host_reset_handler		= nsp32_eh_host_reset,
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,74))
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -621,7 +621,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand   = pas16_queue_command,
 	.eh_abort_handler = pas16_abort,
 	.eh_bus_reset_handler = pas16_bus_reset,
-	.eh_device_reset_handler = pas16_device_reset,
 	.eh_host_reset_handler = pas16_host_reset,
 	.bios_param     = pas16_biosparam, 
 	.can_queue      = CAN_QUEUE,
diff --git a/drivers/scsi/pas16.h b/drivers/scsi/pas16.h
--- a/drivers/scsi/pas16.h
+++ b/drivers/scsi/pas16.h
@@ -121,7 +121,6 @@ static int pas16_detect(Scsi_Host_Templa
 static int pas16_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int pas16_bus_reset(Scsi_Cmnd *);
 static int pas16_host_reset(Scsi_Cmnd *);
-static int pas16_device_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
@@ -164,7 +163,6 @@ static int pas16_device_reset(Scsi_Cmnd 
 #define do_NCR5380_intr do_pas16_intr
 #define NCR5380_queue_command pas16_queue_command
 #define NCR5380_abort pas16_abort
-#define NCR5380_device_reset pas16_device_reset
 #define NCR5380_bus_reset pas16_bus_reset
 #define NCR5380_host_reset pas16_host_reset
 #define NCR5380_proc_info pas16_proc_info
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -94,7 +94,6 @@ static Scsi_Host_Template nsp_driver_tem
 	.queuecommand		 = nsp_queuecommand,
 /*	.eh_strategy_handler	 = nsp_eh_strategy,*/
 /*	.eh_abort_handler	 = nsp_eh_abort,*/
-/*	.eh_device_reset_handler = nsp_eh_device_reset,*/
 	.eh_bus_reset_handler	 = nsp_eh_bus_reset,
 	.eh_host_reset_handler	 = nsp_eh_host_reset,
 	.can_queue		 = 1,
@@ -1549,14 +1548,6 @@ static int nsp_eh_abort(Scsi_Cmnd *SCpnt
 	return nsp_eh_bus_reset(SCpnt);
 }*/
 
-/*
-static int nsp_eh_device_reset(Scsi_Cmnd *SCpnt)
-{
-	nsp_dbg(NSP_DEBUG_BUSRESET, "%s: SCpnt=0x%p", SCpnt);
-
-	return FAILED;
-}*/
-
 static int nsp_bus_reset(nsp_hw_data *data)
 {
 	unsigned int base = data->BaseAddress;
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -81,7 +81,6 @@ static Scsi_Host_Template qlogicfas_driv
 	.queuecommand		= qlogicfas408_queuecommand,
 	.eh_abort_handler	= qlogicfas408_abort,
 	.eh_bus_reset_handler	= qlogicfas408_bus_reset,
-	.eh_device_reset_handler= qlogicfas408_device_reset,
 	.eh_host_reset_handler	= qlogicfas408_host_reset,
 	.bios_param		= qlogicfas408_biosparam,
 	.can_queue		= 1,
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1114,7 +1114,13 @@ qla1280_eh_abort(struct scsi_cmnd * cmd)
 static int
 qla1280_eh_device_reset(struct scsi_cmnd *cmd)
 {
-	return qla1280_error_action(cmd, DEVICE_RESET);
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = qla1280_error_action(cmd, DEVICE_RESET);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
 }
 
 /**************************************************************************
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -655,12 +655,8 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): DEVICE RESET ISSUED.\n", ha->host_no, id, lun);
 
-	spin_unlock_irq(ha->host->host_lock);
-
-	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
-		spin_lock_irq(ha->host->host_lock);
+	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
 		goto eh_dev_reset_done;
-	}
 
 	if (qla2x00_wait_for_loop_ready(ha) == QLA_SUCCESS) {
 		if (qla2x00_device_reset(ha, fcport) == 0)
@@ -711,8 +707,6 @@ qla2xxx_eh_device_reset(struct scsi_cmnd
 	    "scsi(%ld:%d:%d): DEVICE RESET SUCCEEDED.\n", ha->host_no, id, lun);
 
 eh_dev_reset_done:
-	spin_lock_irq(ha->host->host_lock);
-
 	return ret;
 }
 
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -191,7 +191,6 @@ static Scsi_Host_Template qlogicfas_driv
 	.queuecommand		= qlogicfas408_queuecommand,
 	.eh_abort_handler	= qlogicfas408_abort,
 	.eh_bus_reset_handler	= qlogicfas408_bus_reset,
-	.eh_device_reset_handler= qlogicfas408_device_reset,
 	.eh_host_reset_handler	= qlogicfas408_host_reset,
 	.bios_param		= qlogicfas408_biosparam,
 	.can_queue		= 1,
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -525,15 +525,6 @@ int qlogicfas408_host_reset(Scsi_Cmnd * 
 	return FAILED;
 }
 
-/* 
- *	Reset SCSI device
- */
-
-int qlogicfas408_device_reset(Scsi_Cmnd * cmd)
-{
-	return FAILED;
-}
-
 /*
  *	Return info string
  */
@@ -626,7 +617,6 @@ EXPORT_SYMBOL(qlogicfas408_info);
 EXPORT_SYMBOL(qlogicfas408_queuecommand);
 EXPORT_SYMBOL(qlogicfas408_abort);
 EXPORT_SYMBOL(qlogicfas408_bus_reset);
-EXPORT_SYMBOL(qlogicfas408_device_reset);
 EXPORT_SYMBOL(qlogicfas408_host_reset);
 EXPORT_SYMBOL(qlogicfas408_biosparam);
 EXPORT_SYMBOL(qlogicfas408_ihandl);
diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
--- a/drivers/scsi/qlogicfas408.h
+++ b/drivers/scsi/qlogicfas408.h
@@ -110,7 +110,6 @@ int qlogicfas408_biosparam(struct scsi_d
 int qlogicfas408_abort(Scsi_Cmnd * cmd);
 int qlogicfas408_bus_reset(Scsi_Cmnd * cmd);
 int qlogicfas408_host_reset(Scsi_Cmnd * cmd);
-int qlogicfas408_device_reset(Scsi_Cmnd * cmd);
 const char *qlogicfas408_info(struct Scsi_Host *host);
 int qlogicfas408_get_chip_type(int qbase, int int_type);
 void qlogicfas408_setup(int qbase, int id, int int_type);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -856,17 +856,14 @@ static int scsi_eh_abort_cmds(struct lis
  **/
 static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 {
-	unsigned long flags;
-	int rtn = FAILED;
+	int rtn;
 
 	if (!scmd->device->host->hostt->eh_device_reset_handler)
-		return rtn;
+		return FAILED;
 
 	scmd->owner = SCSI_OWNER_LOWLEVEL;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
 		scmd->device->was_reset = 1;
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -1645,11 +1645,6 @@ static int seagate_st0x_host_reset(Scsi_
 	return FAILED;
 }
 
-static int seagate_st0x_device_reset(Scsi_Cmnd *SCpnt)
-{
-	return FAILED;
-}
-
 static int seagate_st0x_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
@@ -1666,7 +1661,6 @@ static Scsi_Host_Template driver_templat
 	.eh_abort_handler	= seagate_st0x_abort,
 	.eh_bus_reset_handler	= seagate_st0x_bus_reset,
 	.eh_host_reset_handler	= seagate_st0x_host_reset,
-	.eh_device_reset_handler = seagate_st0x_device_reset,
 	.can_queue      	= 1,
 	.this_id        	= 7,
 	.sg_tablesize   	= SG_ALL,
diff --git a/drivers/scsi/seagate.h b/drivers/scsi/seagate.h
--- a/drivers/scsi/seagate.h
+++ b/drivers/scsi/seagate.h
@@ -15,7 +15,6 @@ static int seagate_st0x_queue_command(Sc
 static int seagate_st0x_abort(Scsi_Cmnd *);
 static const char *seagate_st0x_info(struct Scsi_Host *);
 static int seagate_st0x_bus_reset(Scsi_Cmnd *);
-static int seagate_st0x_device_reset(Scsi_Cmnd *);
 static int seagate_st0x_host_reset(Scsi_Cmnd *);
 
 #endif /* _SEAGATE_H */
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -790,11 +790,6 @@ static int sym53c416_bus_reset(Scsi_Cmnd
 	return FAILED;
 }
 
-static int sym53c416_device_reset(Scsi_Cmnd *SCpnt)
-{
-	return FAILED;
-}
-
 static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
 {
 	int base;
@@ -862,7 +857,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand =		sym53c416_queuecommand,
 	.eh_host_reset_handler =sym53c416_host_reset,
 	.eh_bus_reset_handler = sym53c416_bus_reset,
-	.eh_device_reset_handler =sym53c416_device_reset,
 	.release = 		sym53c416_release,
 	.bios_param =		sym53c416_bios_param,
 	.can_queue =		1,
diff --git a/drivers/scsi/sym53c416.h b/drivers/scsi/sym53c416.h
--- a/drivers/scsi/sym53c416.h
+++ b/drivers/scsi/sym53c416.h
@@ -28,7 +28,6 @@ static int sym53c416_release(struct Scsi
 static int sym53c416_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int sym53c416_host_reset(Scsi_Cmnd *);
 static int sym53c416_bus_reset(Scsi_Cmnd *);
-static int sym53c416_device_reset(Scsi_Cmnd *);
 static int sym53c416_bios_param(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 static void sym53c416_setup(char *str, int *ints);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -893,7 +893,13 @@ static int sym53c8xx_eh_abort_handler(st
 
 static int sym53c8xx_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = sym_eh_handler(SYM_EH_DEVICE_RESET, "DEVICE RESET", cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
 }
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -438,7 +438,6 @@ static Scsi_Host_Template driver_templat
 	.eh_abort_handler = t128_abort,
 	.eh_bus_reset_handler    = t128_bus_reset,
 	.eh_host_reset_handler   = t128_host_reset,
-	.eh_device_reset_handler = t128_device_reset,
 	.bios_param     = t128_biosparam,
 	.can_queue      = CAN_QUEUE,
         .this_id        = 7,
diff --git a/drivers/scsi/t128.h b/drivers/scsi/t128.h
--- a/drivers/scsi/t128.h
+++ b/drivers/scsi/t128.h
@@ -98,7 +98,6 @@ static int t128_detect(Scsi_Host_Templat
 static int t128_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int t128_host_reset(Scsi_Cmnd *);
 static int t128_bus_reset(Scsi_Cmnd *);
-static int t128_device_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
@@ -141,7 +140,6 @@ static int t128_device_reset(Scsi_Cmnd *
 #define NCR5380_queue_command t128_queue_command
 #define NCR5380_abort t128_abort
 #define NCR5380_host_reset t128_host_reset
-#define NCR5380_device_reset t128_device_reset
 #define NCR5380_bus_reset t128_bus_reset
 #define NCR5380_proc_info t128_proc_info
 
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -446,7 +446,6 @@ static struct scsi_host_template driver_
                 .release                 = u14_34f_release,
                 .queuecommand            = u14_34f_queuecommand,
                 .eh_abort_handler        = u14_34f_eh_abort,
-                .eh_device_reset_handler = NULL,
                 .eh_bus_reset_handler    = NULL,
                 .eh_host_reset_handler   = u14_34f_eh_host_reset,
                 .bios_param              = u14_34f_bios_param,
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -253,8 +253,6 @@ static int device_reset(struct scsi_cmnd
 
 	US_DEBUGP("%s called\n", __FUNCTION__);
 
-	scsi_unlock(us_to_host(us));
-
 	/* lock the device pointers and do the reset */
 	down(&(us->dev_semaphore));
 	if (test_bit(US_FLIDX_DISCONNECTING, &us->flags)) {
@@ -264,8 +262,6 @@ static int device_reset(struct scsi_cmnd
 		result = us->transport_reset(us);
 	up(&(us->dev_semaphore));
 
-	/* lock the host for the return */
-	scsi_lock(us_to_host(us));
 	return result;
 }
 

--------------020709000205050409080603--
