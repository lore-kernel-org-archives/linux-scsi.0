From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] sleeping inside ->eh_host_reset_handler()
Date: Fri, 27 May 2005 18:15:15 -0400
Message-ID: <42979BF3.5040103@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010307070009030500070101"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:32481 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262619AbVE0WP1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 18:15:27 -0400
Received: from cpe-065-184-065-144.nc.res.rr.com ([65.184.65.144] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.51 #1 (Red Hat Linux))
	id 1Dbn6t-0003jK-4C
	for linux-scsi@vger.kernel.org; Fri, 27 May 2005 22:15:22 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010307070009030500070101
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Patch 4 of 4.



--------------010307070009030500070101
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

 Documentation/scsi/scsi_mid_low_api.txt |    3 +--
 drivers/fc4/fc.c                        |   19 ++++++++++++-------
 drivers/fc4/fc_syms.c                   |    1 -
 drivers/fc4/fcp_impl.h                  |    1 -
 drivers/message/fusion/mptscsih.c       |    4 ----
 drivers/s390/scsi/zfcp_scsi.c           |    3 ---
 drivers/scsi/3w-9xxx.c                  |    3 ---
 drivers/scsi/3w-xxxx.c                  |    3 ---
 drivers/scsi/53c700.c                   |    5 +++++
 drivers/scsi/BusLogic.c                 |    8 +++++++-
 drivers/scsi/NCR5380.c                  |   14 --------------
 drivers/scsi/NCR5380.h                  |    1 -
 drivers/scsi/NCR53c406a.c               |    6 ++++++
 drivers/scsi/a2091.c                    |    3 +++
 drivers/scsi/a3000.c                    |    3 +++
 drivers/scsi/aacraid/linit.c            |    4 ++++
 drivers/scsi/aha1542.c                  |    3 ++-
 drivers/scsi/aic7xxx_old.c              |    4 +++-
 drivers/scsi/arm/cumana_1.c             |    1 -
 drivers/scsi/arm/ecoscsi.c              |    1 -
 drivers/scsi/arm/fas216.c               |    3 +++
 drivers/scsi/arm/oak.c                  |    1 -
 drivers/scsi/dmx3191d.c                 |    1 -
 drivers/scsi/dpt_i2o.c                  |   13 ++++++++++++-
 drivers/scsi/dtc.c                      |    1 -
 drivers/scsi/dtc.h                      |    2 --
 drivers/scsi/eata.c                     |    9 +++++++++
 drivers/scsi/eata_pio.c                 |    5 +++++
 drivers/scsi/fcal.c                     |    1 -
 drivers/scsi/fd_mcs.c                   |    6 ------
 drivers/scsi/g_NCR5380.c                |    1 -
 drivers/scsi/g_NCR5380.h                |    2 --
 drivers/scsi/gdth.c                     |    8 --------
 drivers/scsi/gvp11.c                    |    4 ++++
 drivers/scsi/ibmmca.c                   |   14 +++++++++++++-
 drivers/scsi/ide-scsi.c                 |   11 +++++++----
 drivers/scsi/in2000.c                   |    6 ------
 drivers/scsi/in2000.h                   |    1 -
 drivers/scsi/ipr.c                      |   13 ++++++++++++-
 drivers/scsi/ips.c                      |   14 +++++++++++++-
 drivers/scsi/mac53c94.c                 |    5 +++++
 drivers/scsi/mac_scsi.c                 |    1 -
 drivers/scsi/mac_scsi.h                 |    1 -
 drivers/scsi/mesh.c                     |    4 ++++
 drivers/scsi/mvme147.c                  |    3 +++
 drivers/scsi/nsp32.c                    |    3 +++
 drivers/scsi/pas16.c                    |    1 -
 drivers/scsi/pas16.h                    |    2 --
 drivers/scsi/pcmcia/qlogic_stub.c       |    1 -
 drivers/scsi/pcmcia/sym53c500_cs.c      |    2 ++
 drivers/scsi/pluto.c                    |    1 -
 drivers/scsi/qla1280.c                  |    8 +++++++-
 drivers/scsi/qla2xxx/qla_os.c           |    4 ----
 drivers/scsi/qlogicfas.c                |    1 -
 drivers/scsi/qlogicfas408.c             |   10 ----------
 drivers/scsi/qlogicfas408.h             |    1 -
 drivers/scsi/scsi_error.c               |    2 --
 drivers/scsi/seagate.c                  |    6 ------
 drivers/scsi/seagate.h                  |    1 -
 drivers/scsi/sgiwd93.c                  |    3 +++
 drivers/scsi/sym53c416.c                |    5 +++++
 drivers/scsi/sym53c8xx_2/sym_glue.c     |    8 +++++++-
 drivers/scsi/t128.c                     |    1 -
 drivers/scsi/t128.h                     |    2 --
 drivers/scsi/u14-34f.c                  |    6 ++++++
 drivers/scsi/wd7000.c                   |    9 ++++++++-
 66 files changed, 177 insertions(+), 120 deletions(-)


commit 999ad68afccb7bbfa9955664071d43247aa0cb01
tree a409eac39372d03f88bdb501a2ca0906a805b048
parent 28814c735a4662c10ac723854efe9351ceab0d4e
author Jeff Garzik <jgarzik@pobox.com> Sat, 28 May 2005 02:12:28 -0400
committer Jeff Garzik <jgarzik@pobox.com> Sat, 28 May 2005 02:12:28 -0400

[SCSI] allow sleeping in ->eh_host_reset_handler()

Remove the spin_lock_irq() wrap from the host-reset handler call,
which allows LLDs to sleep in their ->eh_host_reset_handler() method
if they so choose.

This also changes locking semantics.  The LLD is now responsible for
ensuring that the host_lock is taken, if such is needed.

--------------------------


diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -990,8 +990,7 @@ Details:
  *
  *      Returns SUCCESS if command aborted else FAILED
  *
- *      Locks: struct Scsi_Host::host_lock held (with irqsave) on entry
- *      and assumed to be held on return.
+ *      Locks: None held
  *
  *      Calling context: kernel thread
  *
diff --git a/drivers/fc4/fc.c b/drivers/fc4/fc.c
--- a/drivers/fc4/fc.c
+++ b/drivers/fc4/fc.c
@@ -1005,13 +1005,7 @@ int fcp_scsi_dev_reset(Scsi_Cmnd *SCpnt)
 	return SUCCESS;
 }
 
-int fcp_scsi_bus_reset(Scsi_Cmnd *SCpnt)
-{
-	printk ("FC: bus reset!\n");
-	return FAILED;
-}
-
-int fcp_scsi_host_reset(Scsi_Cmnd *SCpnt)
+static int __fcp_scsi_host_reset(Scsi_Cmnd *SCpnt)
 {
 	fc_channel *fc = FC_SCMND(SCpnt);
 	fcp_cmnd *fcmd = FCP_CMND(SCpnt);
@@ -1032,6 +1026,17 @@ int fcp_scsi_host_reset(Scsi_Cmnd *SCpnt
 	else return FAILED;
 }
 
+int fcp_scsi_host_reset(Scsi_Cmnd *SCpnt)
+{
+	int rc;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
+	rc = __fcp_scsi_host_reset(SCpnt);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
+
+	return rc;
+}
+
 static int fcp_els_queue_it(fc_channel *fc, fcp_cmnd *fcmd)
 {
 	long i;
diff --git a/drivers/fc4/fc_syms.c b/drivers/fc4/fc_syms.c
--- a/drivers/fc4/fc_syms.c
+++ b/drivers/fc4/fc_syms.c
@@ -27,7 +27,6 @@ EXPORT_SYMBOL(fc_do_prli);
 EXPORT_SYMBOL(fcp_scsi_queuecommand);
 EXPORT_SYMBOL(fcp_scsi_abort);
 EXPORT_SYMBOL(fcp_scsi_dev_reset);
-EXPORT_SYMBOL(fcp_scsi_bus_reset);
 EXPORT_SYMBOL(fcp_scsi_host_reset);
 
 #endif /* CONFIG_MODULES */
diff --git a/drivers/fc4/fcp_impl.h b/drivers/fc4/fcp_impl.h
--- a/drivers/fc4/fcp_impl.h
+++ b/drivers/fc4/fcp_impl.h
@@ -158,7 +158,6 @@ int fc_do_prli(fc_channel *, unsigned ch
 int fcp_scsi_queuecommand(Scsi_Cmnd *, void (* done)(Scsi_Cmnd *));
 int fcp_scsi_abort(Scsi_Cmnd *);
 int fcp_scsi_dev_reset(Scsi_Cmnd *);
-int fcp_scsi_bus_reset(Scsi_Cmnd *);
 int fcp_scsi_host_reset(Scsi_Cmnd *);
 
 #endif /* !(_FCP_SCSI_H) */
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2307,7 +2307,6 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 {
 	MPT_SCSI_HOST *  hd;
 	int              status = SUCCESS;
-	spinlock_t	*host_lock = SCpnt->device->host->host_lock;
 
 	/*  If we can't locate the host to reset, then we failed. */
 	if ((hd = (MPT_SCSI_HOST *) SCpnt->device->host->hostdata) == NULL){
@@ -2323,7 +2322,6 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 	/*  If our attempts to reset the host failed, then return a failed
 	 *  status.  The host will be taken off line by the SCSI mid-layer.
 	 */
-	spin_unlock_irq(host_lock);
 	if (mpt_HardResetHandler(hd->ioc, CAN_SLEEP) < 0){
 		status = FAILED;
 	} else {
@@ -2333,8 +2331,6 @@ mptscsih_host_reset(struct scsi_cmnd *SC
 		hd->tmPending = 0;
 		hd->tmState = TM_STATE_NONE;
 	}
-	spin_lock_irq(host_lock);
-
 
 	dtmprintk( ( KERN_WARNING MYNAM ": mptscsih_host_reset: "
 		     "Status = %s\n",
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -755,8 +755,6 @@ zfcp_scsi_eh_host_reset_handler(struct s
 	struct zfcp_unit *unit;
 	struct Scsi_Host *scsi_host = scpnt->device->host;
 
-	spin_unlock_irq(scsi_host->host_lock);
-
 	unit = (struct zfcp_unit *) scpnt->device->hostdata;
 	ZFCP_LOG_NORMAL("host reset because of problems with "
 			"unit 0x%016Lx\n", unit->fcp_lun);
@@ -764,7 +762,6 @@ zfcp_scsi_eh_host_reset_handler(struct s
 	zfcp_erp_wait(unit->port->adapter);
 	retval = SUCCESS;
 
-	spin_lock_irq(scsi_host->host_lock);
 	return retval;
 }
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1695,8 +1695,6 @@ static int twa_scsi_eh_reset(struct scsi
 
 	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
-	spin_unlock_irq(tw_dev->host->host_lock);
-
 	tw_dev->num_resets++;
 
 	printk(KERN_WARNING "3w-9xxx: scsi%d: WARNING: (0x%02X:0x%04X): Unit #%d: Command (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, TW_DRIVER, 0x2c, SCpnt->device->id, SCpnt->cmnd[0]);
@@ -1709,7 +1707,6 @@ static int twa_scsi_eh_reset(struct scsi
 
 	retval = SUCCESS;
 out:
-	spin_lock_irq(tw_dev->host->host_lock);
 	return retval;
 } /* End twa_scsi_eh_reset() */
 
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1430,8 +1430,6 @@ static int tw_scsi_eh_reset(struct scsi_
 
 	tw_dev = (TW_Device_Extension *)SCpnt->device->host->hostdata;
 
-	spin_unlock_irq(tw_dev->host->host_lock);
-
 	tw_dev->num_resets++;
 
 	printk(KERN_WARNING "3w-xxxx: scsi%d: WARNING: Unit #%d: Command (0x%x) timed out, resetting card.\n", tw_dev->host->host_no, SCpnt->device->id, SCpnt->cmnd[0]);
@@ -1444,7 +1442,6 @@ static int tw_scsi_eh_reset(struct scsi_
 
 	retval = SUCCESS;
 out:
-	spin_lock_irq(tw_dev->host->host_lock);
 	return retval;
 } /* End tw_scsi_eh_reset() */
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1991,8 +1991,13 @@ NCR_700_host_reset(struct scsi_cmnd * SC
 	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun);
 	scsi_print_command(SCp);
 
+	spin_lock_irq(SCp->device->host->host_lock);
+
 	NCR_700_internal_bus_reset(SCp->device->host);
 	NCR_700_chip_reset(SCp->device->host);
+
+	spin_unlock_irq(SCp->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2746,9 +2746,15 @@ static int BusLogic_host_reset(struct sc
 
 	unsigned int id = SCpnt->device->id;
 	struct BusLogic_TargetStatistics *stats = &HostAdapter->TargetStatistics[id];
+	int rc;
+
+	spin_lock_irq(SCpnt->device->host->host_lock);
+
 	BusLogic_IncrementErrorCounter(&stats->HostAdapterResetsRequested);
 
-	return BusLogic_ResetHostAdapter(HostAdapter, false);
+	rc = BusLogic_ResetHostAdapter(HostAdapter, false);
+	spin_unlock_irq(SCpnt->device->host->host_lock);
+	return rc;
 }
 
 /*
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2839,17 +2839,3 @@ static int NCR5380_bus_reset(Scsi_Cmnd *
 
 	return SUCCESS;
 }
-
-/* 
- * Function : int NCR5380_host_reset (Scsi_Cmnd *cmd)
- * 
- * Purpose : reset a SCSI device
- *
- * Returns : FAILED
- *
- * Locks: io_request_lock held by caller
- */
-
-static int NCR5380_host_reset(Scsi_Cmnd * cmd) {
-	return FAILED;
-}
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -306,7 +306,6 @@ static void NCR5380_print(struct Scsi_Ho
 #endif
 static int NCR5380_abort(Scsi_Cmnd * cmd);
 static int NCR5380_bus_reset(Scsi_Cmnd * cmd);
-static int NCR5380_host_reset(Scsi_Cmnd * cmd);
 static int NCR5380_queue_command(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
 static int NCR5380_proc_info(struct Scsi_Host *instance, char *buffer, char **start,
 off_t offset, int length, int inout);
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -725,6 +725,9 @@ static int NCR53c406a_queue(Scsi_Cmnd * 
 static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
 {
 	DEB(printk("NCR53c406a_reset called\n"));
+
+	spin_lock_irq(SCpnt->device->host->host_lock);
+
 	outb(C4_IMG, CONFIG4);	/* Select reg set 0 */
 	outb(CHIP_RESET, CMD_REG);
 	outb(SCSI_NOP, CMD_REG);	/* required after reset */
@@ -732,6 +735,9 @@ static int NCR53c406a_host_reset(Scsi_Cm
 	chip_init();
 
 	rtrc(2);
+
+	spin_unlock_irq(SCpnt->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -222,6 +222,9 @@ static int a2091_bus_reset(Scsi_Cmnd *cm
 {
 	/* FIXME perform bus-specific reset */
 
+	/* FIXME 2: kill this function, and let midlayer fall back
+	   to the same action, calling wd33c93_host_reset() */
+
 	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -208,6 +208,9 @@ fail_register:
 static int a3000_bus_reset(Scsi_Cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
+	
+	/* FIXME 2: kill this entire function, which should
+	   cause mid-layer to call wd33c93_host_reset anyway? */
 
 	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -378,10 +378,13 @@ static int aac_eh_reset(struct scsi_cmnd
 					AAC_DRIVERNAME);
 
 
+	spin_lock_irq(host->host_lock);
+
 	aac = (struct aac_dev *)host->hostdata;
 	if (aac_adapter_check_health(aac)) {
 		printk(KERN_ERR "%s: Host adapter appears dead\n", 
 				AAC_DRIVERNAME);
+		spin_unlock_irq(host->host_lock);
 		return -ENODEV;
 	}
 	/*
@@ -412,6 +415,7 @@ static int aac_eh_reset(struct scsi_cmnd
 		ssleep(1);
 		spin_lock_irq(host->host_lock);
 	}
+	spin_unlock_irq(host->host_lock);
 	printk(KERN_ERR "%s: SCSI bus appears hung\n", AAC_DRIVERNAME);
 	return -ETIMEDOUT;
 }
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1530,7 +1530,6 @@ static int aha1542_host_reset(Scsi_Cmnd 
 	 * check for timeout, and if we are doing something like this
 	 * we are pretty desperate anyways.
 	 */
-	spin_unlock_irq(SCpnt->device->host->host_lock);
 	ssleep(4);
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
@@ -1574,9 +1573,11 @@ static int aha1542_host_reset(Scsi_Cmnd 
 		}
 	}
 
+	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return SUCCESS;
 
 fail:
+	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return FAILED;
 }
 
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -10845,6 +10845,8 @@ aic7xxx_reset(Scsi_Cmnd *cmd)
   struct aic_dev_data *aic_dev;
 
   p = (struct aic7xxx_host *) cmd->device->host->hostdata;
+  spin_lock_irq(p->host->host_lock);
+
   aic_dev = AIC_DEV(cmd);
   if(aic7xxx_position(cmd) < p->scb_data->numscbs)
   {
@@ -10884,6 +10886,7 @@ aic7xxx_reset(Scsi_Cmnd *cmd)
      * longer have it.
      */
     unpause_sequencer(p, FALSE);
+    spin_unlock_irq(p->host->host_lock);
     return SUCCESS;
   }
     
@@ -10907,7 +10910,6 @@ aic7xxx_reset(Scsi_Cmnd *cmd)
   unpause_sequencer(p, FALSE);
   spin_unlock_irq(p->host->host_lock);
   ssleep(2);
-  spin_lock_irq(p->host->host_lock);
   return SUCCESS;
 }
 
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -245,7 +245,6 @@ static Scsi_Host_Template cumanascsi_tem
 	.queuecommand		= cumanascsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
-	.eh_host_reset_handler	= NCR5380_host_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
diff --git a/drivers/scsi/arm/ecoscsi.c b/drivers/scsi/arm/ecoscsi.c
--- a/drivers/scsi/arm/ecoscsi.c
+++ b/drivers/scsi/arm/ecoscsi.c
@@ -163,7 +163,6 @@ static Scsi_Host_Template ecoscsi_templa
 	.queuecommand	= ecoscsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
-	.eh_host_reset_handler	= NCR5380_host_reset,
 	.can_queue	= 16,
 	.this_id	= 7,
 	.sg_tablesize	= SG_ALL,
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2659,6 +2659,8 @@ int fas216_eh_host_reset(Scsi_Cmnd *SCpn
 {
 	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
 
+	spin_lock_irq(info->host->host_lock);
+
 	fas216_checkmagic(info);
 
 	printk("scsi%d.%c: %s: resetting host\n",
@@ -2686,6 +2688,7 @@ int fas216_eh_host_reset(Scsi_Cmnd *SCpn
 
 	fas216_init_chip(info);
 
+	spin_unlock_irq(info->host->host_lock);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -119,7 +119,6 @@ static Scsi_Host_Template oakscsi_templa
 	.queuecommand		= oakscsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
-	.eh_host_reset_handler	= NCR5380_host_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -61,7 +61,6 @@ static struct scsi_host_template dmx3191
 	.queuecommand		= NCR5380_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
-	.eh_host_reset_handler	= NCR5380_host_reset,
 	.can_queue		= 32,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -747,7 +747,7 @@ static int adpt_bus_reset(struct scsi_cm
 }
 
 // This version of reset is called by the eh_error_handler
-static int adpt_reset(struct scsi_cmnd* cmd)
+static int __adpt_reset(struct scsi_cmnd* cmd)
 {
 	adpt_hba* pHba;
 	int rcode;
@@ -763,6 +763,17 @@ static int adpt_reset(struct scsi_cmnd* 
 	}
 }
 
+static int adpt_reset(struct scsi_cmnd* cmd)
+{
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = __adpt_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
+}
+
 // This version of reset is called by the ioctls and indirectly from eh_error_handler via adpt_reset
 static int adpt_hba_reset(adpt_hba* pHba)
 {
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -482,7 +482,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand			= dtc_queue_command,
 	.eh_abort_handler		= dtc_abort,
 	.eh_bus_reset_handler		= dtc_bus_reset,
-	.eh_host_reset_handler          = dtc_host_reset,
 	.bios_param     		= dtc_biosparam,
 	.can_queue      		= CAN_QUEUE,
 	.this_id        		= 7,
diff --git a/drivers/scsi/dtc.h b/drivers/scsi/dtc.h
--- a/drivers/scsi/dtc.h
+++ b/drivers/scsi/dtc.h
@@ -34,7 +34,6 @@ static int dtc_biosparam(struct scsi_dev
 static int dtc_detect(Scsi_Host_Template *);
 static int dtc_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int dtc_bus_reset(Scsi_Cmnd *);
-static int dtc_host_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
@@ -85,7 +84,6 @@ static int dtc_host_reset(Scsi_Cmnd *);
 #define NCR5380_queue_command		dtc_queue_command
 #define NCR5380_abort			dtc_abort
 #define NCR5380_bus_reset		dtc_bus_reset
-#define NCR5380_host_reset		dtc_host_reset
 #define NCR5380_proc_info		dtc_proc_info 
 
 /* 15 12 11 10
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1948,16 +1948,20 @@ static int eata2x_eh_host_reset(struct s
 	       ha->board_name, SCarg->device->channel, SCarg->device->id,
 	       SCarg->device->lun, SCarg->pid);
 
+	spin_lock_irq(shost->host_lock);
+
 	if (SCarg->host_scribble == NULL)
 		printk("%s: reset, pid %ld inactive.\n", ha->board_name, SCarg->pid);
 
 	if (ha->in_reset) {
 		printk("%s: reset, exit, already in reset.\n", ha->board_name);
+		spin_unlock_irq(shost->host_lock);
 		return FAILED;
 	}
 
 	if (wait_on_busy(shost->io_port, MAXLOOP)) {
 		printk("%s: reset, exit, timeout error.\n", ha->board_name);
+		spin_unlock_irq(shost->host_lock);
 		return FAILED;
 	}
 
@@ -2012,6 +2016,7 @@ static int eata2x_eh_host_reset(struct s
 
 	if (do_dma(shost->io_port, 0, RESET_PIO)) {
 		printk("%s: reset, cannot reset, timeout error.\n", ha->board_name);
+		spin_unlock_irq(shost->host_lock);
 		return FAILED;
 	}
 
@@ -2024,9 +2029,12 @@ static int eata2x_eh_host_reset(struct s
 	ha->in_reset = 1;
 
 	spin_unlock_irq(shost->host_lock);
+
+	/* FIXME: use a sleep instead */
 	time = jiffies;
 	while ((jiffies - time) < (10 * HZ) && limit++ < 200000)
 		udelay(100L);
+
 	spin_lock_irq(shost->host_lock);
 
 	printk("%s: reset, interrupts disabled, loops %d.\n", ha->board_name, limit);
@@ -2076,6 +2084,7 @@ static int eata2x_eh_host_reset(struct s
 	else
 		printk("%s: reset, exit.\n", ha->board_name);
 
+	spin_unlock_irq(shost->host_lock);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -486,8 +486,11 @@ static int eata_pio_host_reset(struct sc
 
 	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset called pid:%ld target:" " %x lun: %x reason %x\n", cmd->pid, cmd->device->id, cmd->device->lun, cmd->abort_reason));
 
+	spin_lock_irq(host->host_lock);
+
 	if (HD(cmd)->state == RESET) {
 		printk(KERN_WARNING "eata_pio_reset: exit, already in reset.\n");
+		spin_unlock_irq(host->host_lock);
 		return FAILED;
 	}
 
@@ -536,6 +539,8 @@ static int eata_pio_host_reset(struct sc
 
 	HD(cmd)->state = 0;
 
+	spin_unlock_irq(host->host_lock);
+
 	if (success) {		/* hmmm... */
 		DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset: exit, success.\n"));
 		return SUCCESS;
diff --git a/drivers/scsi/fcal.c b/drivers/scsi/fcal.c
--- a/drivers/scsi/fcal.c
+++ b/drivers/scsi/fcal.c
@@ -311,7 +311,6 @@ static Scsi_Host_Template driver_templat
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_abort_handler	= fcp_scsi_abort,
 	.eh_device_reset_handler = fcp_scsi_dev_reset,
-	.eh_bus_reset_handler	= fcp_scsi_bus_reset,
 	.eh_host_reset_handler	= fcp_scsi_host_reset,
 };
 #include "scsi_module.c"
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -1241,11 +1241,6 @@ static int fd_mcs_abort(Scsi_Cmnd * SCpn
 	return SUCCESS;
 }
 
-static int fd_mcs_host_reset(Scsi_Cmnd * SCpnt)
-{
-	return FAILED;
-}
-
 static int fd_mcs_bus_reset(Scsi_Cmnd * SCpnt) {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
@@ -1357,7 +1352,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand   		= fd_mcs_queue, 
 	.eh_abort_handler		= fd_mcs_abort,
 	.eh_bus_reset_handler		= fd_mcs_bus_reset,
-	.eh_host_reset_handler		= fd_mcs_host_reset,
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
-	.eh_host_reset_handler	= generic_NCR5380_host_reset,
 	.bios_param     	= NCR5380_BIOSPARAM,
 	.can_queue      	= CAN_QUEUE,
         .this_id        	= 7,
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -49,7 +49,6 @@ static int generic_NCR5380_detect(Scsi_H
 static int generic_NCR5380_release_resources(struct Scsi_Host *);
 static int generic_NCR5380_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int generic_NCR5380_bus_reset(Scsi_Cmnd *);
-static int generic_NCR5380_host_reset(Scsi_Cmnd *);
 static const char* generic_NCR5380_info(struct Scsi_Host *);
 
 #ifndef CMD_PER_LUN
@@ -113,7 +112,6 @@ static const char* generic_NCR5380_info(
 #define NCR5380_queue_command generic_NCR5380_queue_command
 #define NCR5380_abort generic_NCR5380_abort
 #define NCR5380_bus_reset generic_NCR5380_bus_reset
-#define NCR5380_host_reset generic_NCR5380_host_reset
 #define NCR5380_pread generic_NCR5380_pread
 #define NCR5380_pwrite generic_NCR5380_pwrite
 #define NCR5380_proc_info notyet_generic_proc_info
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -4757,13 +4757,6 @@ static int gdth_eh_bus_reset(Scsi_Cmnd *
     return SUCCESS;
 }
 
-static int gdth_eh_host_reset(Scsi_Cmnd *scp)
-{
-    TRACE2(("gdth_eh_host_reset()\n"));
-    return FAILED;
-}
-
-
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,sector_t cap,int *ip)
 #else
@@ -5701,7 +5694,6 @@ static Scsi_Host_Template driver_templat
         .info                   = gdth_info, 
         .queuecommand           = gdth_queuecommand,
         .eh_bus_reset_handler   = gdth_eh_bus_reset,
-        .eh_host_reset_handler  = gdth_eh_host_reset,
         .bios_param             = gdth_bios_param,
         .can_queue              = GDTH_MAXCMDS,
         .this_id                = -1,
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -346,6 +346,10 @@ static int gvp11_bus_reset(Scsi_Cmnd *cm
 {
 	/* FIXME perform bus-specific reset */
 
+	/* FIXME 2: shouldn't we no-op this function (return
+	   FAILED), and fall back to host reset function,
+	   wd33c93_host_reset ? */
+
 	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -2237,7 +2237,7 @@ static int ibmmca_abort(Scsi_Cmnd * cmd)
 	return rc;
 }
 
-static int ibmmca_host_reset(Scsi_Cmnd * cmd)
+static int __ibmmca_host_reset(Scsi_Cmnd * cmd)
 {
 	struct Scsi_Host *shpnt;
 	Scsi_Cmnd *cmd_aid;
@@ -2324,6 +2324,18 @@ static int ibmmca_host_reset(Scsi_Cmnd *
 	return SUCCESS;
 }
 
+static int ibmmca_host_reset(Scsi_Cmnd * cmd)
+{
+	struct Scsi_Host *shpnt = cmd->device->host;
+	int rc;
+
+	spin_lock_irq(shpnt->host_lock);
+	rc = __ibmmca_host_reset(cmd);
+	spin_unlock_irq(shpnt->host_lock);
+
+	return rc;
+}
+
 static int ibmmca_biosparam(struct scsi_device *sdev, struct block_device *bdev, sector_t capacity, int *info)
 {
 	int size = capacity;
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -46,6 +46,7 @@
 #include <linux/slab.h>
 #include <linux/ide.h>
 #include <linux/scatterlist.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/bitops.h>
@@ -1026,11 +1027,13 @@ static int idescsi_eh_reset (struct scsi
 		return FAILED;
 	}
 
-	spin_lock_irq(&ide_lock);
+	spin_lock_irq(cmd->device->host->host_lock);
+	spin_lock(&ide_lock);
 
 	if (!scsi->pc || (req = scsi->pc->rq) != HWGROUP(drive)->rq || !HWGROUP(drive)->handler) {
 		printk (KERN_WARNING "ide-scsi: No active request in idescsi_eh_reset\n");
 		spin_unlock(&ide_lock);
+		spin_unlock_irq(cmd->device->host->host_lock);
 		return FAILED;
 	}
 
@@ -1052,16 +1055,15 @@ static int idescsi_eh_reset (struct scsi
 	HWGROUP(drive)->rq = NULL;
 	HWGROUP(drive)->handler = NULL;
 	HWGROUP(drive)->busy = 1;		/* will set this to zero when ide reset finished */
-	spin_unlock_irq(&ide_lock);
+	spin_unlock(&ide_lock);
 
 	ide_do_reset(drive);
 
 	/* ide_do_reset starts a polling handler which restarts itself every 50ms until the reset finishes */
 
 	do {
-		set_current_state(TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(cmd->device->host->host_lock);
-		schedule_timeout(HZ/20);
+		msleep(50);
 		spin_lock_irq(cmd->device->host->host_lock);
 	} while ( HWGROUP(drive)->handler );
 
@@ -1072,6 +1074,7 @@ static int idescsi_eh_reset (struct scsi
 		ret = FAILED;
 	}
 
+	spin_unlock_irq(cmd->device->host->host_lock);
 	return ret;
 }
 
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -1675,11 +1675,6 @@ static int in2000_bus_reset(Scsi_Cmnd * 
 	return SUCCESS;
 }
 
-static int in2000_host_reset(Scsi_Cmnd * cmd)
-{
-	return FAILED;
-}
-
 static int __in2000_abort(Scsi_Cmnd * cmd)
 {
 	struct Scsi_Host *instance;
@@ -2319,7 +2314,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand    		= in2000_queuecommand,
 	.eh_abort_handler		= in2000_abort,
 	.eh_bus_reset_handler		= in2000_bus_reset,
-	.eh_host_reset_handler	= in2000_host_reset, 
 	.bios_param      		= in2000_biosparam, 
 	.can_queue       		= IN2000_CAN_Q,
 	.this_id         		= IN2000_HOST_ID,
diff --git a/drivers/scsi/in2000.h b/drivers/scsi/in2000.h
--- a/drivers/scsi/in2000.h
+++ b/drivers/scsi/in2000.h
@@ -401,7 +401,6 @@ static int in2000_abort(Scsi_Cmnd *);
 static void in2000_setup(char *, int *) in2000__INIT;
 static int in2000_biosparam(struct scsi_device *, struct block_device *,
 		sector_t, int *);
-static int in2000_host_reset(Scsi_Cmnd *);
 static int in2000_bus_reset(Scsi_Cmnd *);
 
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2885,7 +2885,7 @@ static int ipr_slave_alloc(struct scsi_d
  * Return value:
  * 	SUCCESS / FAILED
  **/
-static int ipr_eh_host_reset(struct scsi_cmnd * scsi_cmd)
+static int __ipr_eh_host_reset(struct scsi_cmnd * scsi_cmd)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
 	int rc;
@@ -2905,6 +2905,17 @@ static int ipr_eh_host_reset(struct scsi
 	return rc;
 }
 
+static int ipr_eh_host_reset(struct scsi_cmnd * cmd)
+{
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = __ipr_eh_host_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
+}
+
 /**
  * ipr_eh_dev_reset - Reset the device
  * @scsi_cmd:	scsi command struct
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -873,7 +873,7 @@ ips_eh_abort(Scsi_Cmnd * SC)
 /*                                                                          */
 /****************************************************************************/
 static int
-ips_eh_reset(Scsi_Cmnd * SC)
+__ips_eh_reset(Scsi_Cmnd * SC)
 {
 	int ret;
 	int i;
@@ -1060,6 +1060,18 @@ ips_eh_reset(Scsi_Cmnd * SC)
 
 }
 
+static int
+ips_eh_reset(Scsi_Cmnd * SC)
+{
+	int rc;
+
+	spin_lock_irq(SC->device->host->host_lock);
+	rc = __ips_eh_reset(SC);
+	spin_unlock_irq(SC->device->host->host_lock);
+
+	return rc;
+}
+
 /****************************************************************************/
 /*                                                                          */
 /* Routine Name: ips_queue                                                  */
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -103,6 +103,9 @@ static int mac53c94_host_reset(struct sc
 	struct fsc_state *state = (struct fsc_state *) cmd->device->host->hostdata;
 	struct mac53c94_regs __iomem *regs = state->regs;
 	struct dbdma_regs __iomem *dma = state->dma;
+	unsigned long flags;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, flags);
 
 	writel((RUN|PAUSE|FLUSH|WAKE) << 16, &dma->control);
 	writeb(CMD_SCSI_RESET, &regs->command);	/* assert RST */
@@ -111,6 +114,8 @@ static int mac53c94_host_reset(struct sc
 	udelay(20);
 	mac53c94_init(state);
 	writeb(CMD_NOP, &regs->command);
+
+	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -591,7 +591,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand			= macscsi_queue_command,
 	.eh_abort_handler		= macscsi_abort,
 	.eh_bus_reset_handler		= macscsi_bus_reset,
-	.eh_host_reset_handler		= macscsi_host_reset,
 	.can_queue			= CAN_QUEUE,
 	.this_id			= 7,
 	.sg_tablesize			= SG_ALL,
diff --git a/drivers/scsi/mac_scsi.h b/drivers/scsi/mac_scsi.h
--- a/drivers/scsi/mac_scsi.h
+++ b/drivers/scsi/mac_scsi.h
@@ -72,7 +72,6 @@
 #define NCR5380_queue_command macscsi_queue_command
 #define NCR5380_abort macscsi_abort
 #define NCR5380_bus_reset macscsi_bus_reset
-#define NCR5380_host_reset macscsi_host_reset
 #define NCR5380_proc_info macscsi_proc_info
 
 #define BOARD_NORMAL	0
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1715,9 +1715,12 @@ static int mesh_host_reset(struct scsi_c
 	struct mesh_state *ms = (struct mesh_state *) cmd->device->host->hostdata;
 	volatile struct mesh_regs __iomem *mr = ms->mesh;
 	volatile struct dbdma_regs __iomem *md = ms->dma;
+	unsigned long flags;
 
 	printk(KERN_DEBUG "mesh_host_reset\n");
 
+	spin_lock_irqsave(ms->host->host_lock, flags);
+
 	/* Reset the controller & dbdma channel */
 	out_le32(&md->control, (RUN|PAUSE|FLUSH|WAKE) << 16);	/* stop dma */
 	out_8(&mr->exception, 0xff);	/* clear all exception bits */
@@ -1739,6 +1742,7 @@ static int mesh_host_reset(struct scsi_c
 	/* Complete pending commands */
 	handle_reset(ms);
 	
+	spin_unlock_irqrestore(ms->host->host_lock, flags);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -117,6 +117,9 @@ static int mvme147_bus_reset(Scsi_Cmnd *
 {
 	/* FIXME perform bus-specific reset */
 
+	/* FIXME 2: kill this function, and let midlayer fallback to 
+	   the same result, calling wd33c93_host_reset() */
+
 	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -3051,11 +3051,14 @@ static int nsp32_eh_host_reset(struct sc
 	nsp32_msg(KERN_INFO, "Host Reset");	
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
 
+	spin_lock_irq(SCpnt->device->host->host_lock);
+
 	nsp32hw_init(data);
 	nsp32_write2(base, IRQ_CONTROL, IRQ_CONTROL_ALL_IRQ_MASK);
 	nsp32_do_bus_reset(data);
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
+	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return SUCCESS;	/* Host reset is succeeded at any time. */
 }
 
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -621,7 +621,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand   = pas16_queue_command,
 	.eh_abort_handler = pas16_abort,
 	.eh_bus_reset_handler = pas16_bus_reset,
-	.eh_host_reset_handler = pas16_host_reset,
 	.bios_param     = pas16_biosparam, 
 	.can_queue      = CAN_QUEUE,
 	.this_id        = 7,
diff --git a/drivers/scsi/pas16.h b/drivers/scsi/pas16.h
--- a/drivers/scsi/pas16.h
+++ b/drivers/scsi/pas16.h
@@ -120,7 +120,6 @@ static int pas16_biosparam(struct scsi_d
 static int pas16_detect(Scsi_Host_Template *);
 static int pas16_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int pas16_bus_reset(Scsi_Cmnd *);
-static int pas16_host_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
@@ -164,7 +163,6 @@ static int pas16_host_reset(Scsi_Cmnd *)
 #define NCR5380_queue_command pas16_queue_command
 #define NCR5380_abort pas16_abort
 #define NCR5380_bus_reset pas16_bus_reset
-#define NCR5380_host_reset pas16_host_reset
 #define NCR5380_proc_info pas16_proc_info
 
 /* 15 14 12 10 7 5 3 
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -81,7 +81,6 @@ static Scsi_Host_Template qlogicfas_driv
 	.queuecommand		= qlogicfas408_queuecommand,
 	.eh_abort_handler	= qlogicfas408_abort,
 	.eh_bus_reset_handler	= qlogicfas408_bus_reset,
-	.eh_host_reset_handler	= qlogicfas408_host_reset,
 	.bios_param		= qlogicfas408_biosparam,
 	.can_queue		= 1,
 	.this_id		= -1,
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -627,7 +627,9 @@ SYM53C500_host_reset(struct scsi_cmnd *S
 	int port_base = SCpnt->device->host->io_port;
 
 	DEB(printk("SYM53C500_host_reset called\n"));
+	spin_lock_irq(SCpnt->device->host->host_lock);
 	SYM53C500_int_host_reset(port_base);
+	spin_unlock_irq(SCpnt->device->host->host_lock);
 
 	return SUCCESS;
 }
diff --git a/drivers/scsi/pluto.c b/drivers/scsi/pluto.c
--- a/drivers/scsi/pluto.c
+++ b/drivers/scsi/pluto.c
@@ -354,7 +354,6 @@ static Scsi_Host_Template driver_templat
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_abort_handler	= fcp_scsi_abort,
 	.eh_device_reset_handler = fcp_scsi_dev_reset,
-	.eh_bus_reset_handler	= fcp_scsi_bus_reset,
 	.eh_host_reset_handler	= fcp_scsi_host_reset,
 };
 
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1146,7 +1146,13 @@ qla1280_eh_bus_reset(struct scsi_cmnd *c
 static int
 qla1280_eh_adapter_reset(struct scsi_cmnd *cmd)
 {
-	return qla1280_error_action(cmd, ADAPTER_RESET);
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = qla1280_error_action(cmd, ADAPTER_RESET);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
 }
 
 static int
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -857,8 +857,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): ADAPTER RESET ISSUED.\n", ha->host_no, id, lun);
 
-	spin_unlock_irq(ha->host->host_lock);
-
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS)
 		goto eh_host_reset_lock;
 
@@ -887,8 +885,6 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *
 		ret = SUCCESS;
 
 eh_host_reset_lock:
-	spin_lock_irq(ha->host->host_lock);
-
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
 	    (ret == FAILED) ? "failed" : "succeded");
 
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -191,7 +191,6 @@ static Scsi_Host_Template qlogicfas_driv
 	.queuecommand		= qlogicfas408_queuecommand,
 	.eh_abort_handler	= qlogicfas408_abort,
 	.eh_bus_reset_handler	= qlogicfas408_bus_reset,
-	.eh_host_reset_handler	= qlogicfas408_host_reset,
 	.bios_param		= qlogicfas408_biosparam,
 	.can_queue		= 1,
 	.this_id		= -1,
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -522,15 +522,6 @@ int qlogicfas408_bus_reset(Scsi_Cmnd * c
 	return SUCCESS;
 }
 
-/* 
- *	Reset SCSI host controller
- */
-
-int qlogicfas408_host_reset(Scsi_Cmnd * cmd)
-{
-	return FAILED;
-}
-
 /*
  *	Return info string
  */
@@ -623,7 +614,6 @@ EXPORT_SYMBOL(qlogicfas408_info);
 EXPORT_SYMBOL(qlogicfas408_queuecommand);
 EXPORT_SYMBOL(qlogicfas408_abort);
 EXPORT_SYMBOL(qlogicfas408_bus_reset);
-EXPORT_SYMBOL(qlogicfas408_host_reset);
 EXPORT_SYMBOL(qlogicfas408_biosparam);
 EXPORT_SYMBOL(qlogicfas408_ihandl);
 EXPORT_SYMBOL(qlogicfas408_get_chip_type);
diff --git a/drivers/scsi/qlogicfas408.h b/drivers/scsi/qlogicfas408.h
--- a/drivers/scsi/qlogicfas408.h
+++ b/drivers/scsi/qlogicfas408.h
@@ -109,7 +109,6 @@ int qlogicfas408_biosparam(struct scsi_d
 			sector_t capacity, int ip[]);
 int qlogicfas408_abort(Scsi_Cmnd * cmd);
 int qlogicfas408_bus_reset(Scsi_Cmnd * cmd);
-int qlogicfas408_host_reset(Scsi_Cmnd * cmd);
 const char *qlogicfas408_info(struct Scsi_Host *host);
 int qlogicfas408_get_chip_type(int qbase, int int_type);
 void qlogicfas408_setup(int qbase, int id, int int_type);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1078,9 +1078,7 @@ static int scsi_try_host_reset(struct sc
 	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	rtn = scmd->device->host->hostt->eh_host_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
 		if (!scmd->device->host->hostt->skip_settle_delay)
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -1641,11 +1641,6 @@ static int seagate_st0x_bus_reset(Scsi_C
 	return SUCCESS;
 }
 
-static int seagate_st0x_host_reset(Scsi_Cmnd *SCpnt)
-{
-	return FAILED;
-}
-
 static int seagate_st0x_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
@@ -1661,7 +1656,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand   	= seagate_st0x_queue_command,
 	.eh_abort_handler	= seagate_st0x_abort,
 	.eh_bus_reset_handler	= seagate_st0x_bus_reset,
-	.eh_host_reset_handler	= seagate_st0x_host_reset,
 	.can_queue      	= 1,
 	.this_id        	= 7,
 	.sg_tablesize   	= SG_ALL,
diff --git a/drivers/scsi/seagate.h b/drivers/scsi/seagate.h
--- a/drivers/scsi/seagate.h
+++ b/drivers/scsi/seagate.h
@@ -15,6 +15,5 @@ static int seagate_st0x_queue_command(Sc
 static int seagate_st0x_abort(Scsi_Cmnd *);
 static const char *seagate_st0x_info(struct Scsi_Host *);
 static int seagate_st0x_bus_reset(Scsi_Cmnd *);
-static int seagate_st0x_host_reset(Scsi_Cmnd *);
 
 #endif /* _SEAGATE_H */
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -311,6 +311,9 @@ static int sgiwd93_bus_reset(Scsi_Cmnd *
 {
 	/* FIXME perform bus-specific reset */
 
+	/* FIXME 2: kill this function, and let midlayer fallback
+	   to the same result, calling wd33c93_host_reset() */
+
 	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
 	spin_unlock_irq(cmd->device->host->host_lock);
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -790,6 +790,9 @@ static int sym53c416_host_reset(Scsi_Cmn
 	int base;
 	int scsi_id = -1;	
 	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sym53c416_lock, flags);
 
 	/* printk("sym53c416_reset\n"); */
 	base = SCpnt->device->host->io_port;
@@ -801,6 +804,8 @@ static int sym53c416_host_reset(Scsi_Cmn
 	outb(NOOP | PIO_MODE, base + COMMAND_REG);
 	outb(RESET_SCSI_BUS, base + COMMAND_REG);
 	sym53c416_init(base, scsi_id);
+
+	spin_unlock_irqrestore(&sym53c416_lock, flags);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -915,7 +915,13 @@ static int sym53c8xx_eh_bus_reset_handle
 
 static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = sym_eh_handler(SYM_EH_HOST_RESET, "HOST RESET", cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
 }
 
 /*
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -437,7 +437,6 @@ static Scsi_Host_Template driver_templat
 	.queuecommand   = t128_queue_command,
 	.eh_abort_handler = t128_abort,
 	.eh_bus_reset_handler    = t128_bus_reset,
-	.eh_host_reset_handler   = t128_host_reset,
 	.bios_param     = t128_biosparam,
 	.can_queue      = CAN_QUEUE,
         .this_id        = 7,
diff --git a/drivers/scsi/t128.h b/drivers/scsi/t128.h
--- a/drivers/scsi/t128.h
+++ b/drivers/scsi/t128.h
@@ -96,7 +96,6 @@ static int t128_biosparam(struct scsi_de
 			  sector_t, int*);
 static int t128_detect(Scsi_Host_Template *);
 static int t128_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int t128_host_reset(Scsi_Cmnd *);
 static int t128_bus_reset(Scsi_Cmnd *);
 
 #ifndef CMD_PER_LUN
@@ -139,7 +138,6 @@ static int t128_bus_reset(Scsi_Cmnd *);
 #define do_NCR5380_intr do_t128_intr
 #define NCR5380_queue_command t128_queue_command
 #define NCR5380_abort t128_abort
-#define NCR5380_host_reset t128_host_reset
 #define NCR5380_bus_reset t128_bus_reset
 #define NCR5380_proc_info t128_proc_info
 
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1417,16 +1417,20 @@ static int u14_34f_eh_host_reset(struct 
    printk("%s: reset, enter, target %d.%d:%d, pid %ld.\n",
           BN(j), SCarg->device->channel, SCarg->device->id, SCarg->device->lun, SCarg->pid);
 
+   spin_lock_irq(sh[j]->host_lock);
+
    if (SCarg->host_scribble == NULL)
       printk("%s: reset, pid %ld inactive.\n", BN(j), SCarg->pid);
 
    if (HD(j)->in_reset) {
       printk("%s: reset, exit, already in reset.\n", BN(j));
+      spin_unlock_irq(sh[j]->host_lock);
       return FAILED;
       }
 
    if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
       printk("%s: reset, exit, timeout error.\n", BN(j));
+      spin_unlock_irq(sh[j]->host_lock);
       return FAILED;
       }
 
@@ -1477,6 +1481,7 @@ static int u14_34f_eh_host_reset(struct 
 
    if (wait_on_busy(sh[j]->io_port, MAXLOOP)) {
       printk("%s: reset, cannot reset, timeout error.\n", BN(j));
+      spin_unlock_irq(sh[j]->host_lock);
       return FAILED;
       }
 
@@ -1538,6 +1543,7 @@ static int u14_34f_eh_host_reset(struct 
    if (arg_done) printk("%s: reset, exit, pid %ld done.\n", BN(j), SCarg->pid);
    else          printk("%s: reset, exit.\n", BN(j));
 
+   spin_unlock_irq(sh[j]->host_lock);
    return SUCCESS;
 }
 
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1586,9 +1586,16 @@ static int wd7000_host_reset(struct scsi
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
-	if (wd7000_adapter_reset(host) < 0)
+	spin_unlock_irq(SCpnt->device->host->host_lock);
+
+	if (wd7000_adapter_reset(host) < 0) {
+		spin_unlock_irq(SCpnt->device->host->host_lock);
 		return FAILED;
+	}
+
 	wd7000_enable_intr(host);
+
+	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return SUCCESS;
 }
 

--------------010307070009030500070101--
