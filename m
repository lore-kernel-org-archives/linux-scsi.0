From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] sleep in ->eh_bus_reset_handler()
Date: Fri, 27 May 2005 16:49:47 -0400
Message-ID: <429787EB.2000001@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070105040908090901050000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:55264 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S262587AbVE0Utv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 16:49:51 -0400
Received: from cpe-065-184-065-144.nc.res.rr.com ([65.184.65.144] helo=[10.10.10.88])
	by mail.dvmed.net with esmtpsa (Exim 4.51 #1 (Red Hat Linux))
	id 1Dblm8-0003fu-VU
	for linux-scsi@vger.kernel.org; Fri, 27 May 2005 20:49:51 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070105040908090901050000
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Patch 3 of 4...



--------------070105040908090901050000
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

 Documentation/scsi/scsi_mid_low_api.txt |    3 +--
 drivers/fc4/fc.c                        |    5 +++--
 drivers/message/fusion/mptscsih.c       |    3 +--
 drivers/s390/scsi/zfcp_scsi.c           |    3 ---
 drivers/scsi/53c700.c                   |    9 ++++++++-
 drivers/scsi/NCR5380.c                  |   14 ++++++++++----
 drivers/scsi/NCR53C9x.c                 |    4 +---
 drivers/scsi/NCR53c406a.c               |    6 ------
 drivers/scsi/a2091.c                    |    4 ++++
 drivers/scsi/a3000.c                    |    4 ++++
 drivers/scsi/aha1542.c                  |    4 +++-
 drivers/scsi/aic7xxx/aic79xx_osm.c      |    4 ++--
 drivers/scsi/aic7xxx/aic7xxx_osm.c      |    4 ++++
 drivers/scsi/dc395x.c                   |   12 +++++++++++-
 drivers/scsi/eata.c                     |    1 -
 drivers/scsi/fd_mcs.c                   |    5 +++++
 drivers/scsi/fdomain.c                  |    6 ++++++
 drivers/scsi/gvp11.c                    |    4 ++++
 drivers/scsi/imm.c                      |    9 +++++----
 drivers/scsi/in2000.c                   |    6 +++++-
 drivers/scsi/initio.c                   |    4 ++++
 drivers/scsi/lpfc/lpfc_scsi.c           |   12 +++++++++++-
 drivers/scsi/mvme147.c                  |    4 ++++
 drivers/scsi/nsp32.c                    |    3 +++
 drivers/scsi/ppa.c                      |    5 +++--
 drivers/scsi/qla1280.c                  |    8 +++++++-
 drivers/scsi/qla2xxx/qla_os.c           |    4 ----
 drivers/scsi/qlogicfas408.c             |    6 ++++++
 drivers/scsi/scsi_error.c               |    2 --
 drivers/scsi/seagate.c                  |    3 ++-
 drivers/scsi/sgiwd93.c                  |    4 ++++
 drivers/scsi/sym53c416.c                |    6 ------
 drivers/scsi/sym53c416.h                |    1 -
 drivers/scsi/sym53c8xx_2/sym_glue.c     |    8 +++++++-
 drivers/scsi/tmscsim.c                  |    6 +++++-
 drivers/scsi/u14-34f.c                  |    1 -
 drivers/usb/storage/scsiglue.c          |    3 ---
 37 files changed, 133 insertions(+), 57 deletions(-)


commit 28814c735a4662c10ac723854efe9351ceab0d4e
tree b2edcad724af14feb1e89c491620dd91769ff089
parent 90414553e71766d4ed43cf5f2ae380a3007ac762
author Jeff Garzik <jgarzik@pobox.com> Sat, 28 May 2005 00:46:33 -0400
committer Jeff Garzik <jgarzik@pobox.com> Sat, 28 May 2005 00:46:33 -0400

[SCSI] allow sleeping in ->eh_bus_reset_handler()

Remove the spin_lock_irq() wrap from the bus-reset handler call,
which allows LLDs to sleep in their ->eh_bus_reset_handler() method
if they so choose.

This also changes locking semantics.  The LLD is now responsible for
ensuring that the host_lock is taken, if such is needed.

--------------------------

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -954,8 +954,7 @@ Details:
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
@@ -767,10 +767,8 @@ static void fcp_scsi_done (Scsi_Cmnd *SC
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 	if (FCP_CMND(SCpnt)->done)
 		FCP_CMND(SCpnt)->done(SCpnt);
-	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
 }
 
 static int fcp_scsi_queue_it(fc_channel *fc, Scsi_Cmnd *SCpnt, fcp_cmnd *fcmd, int prepare)
@@ -985,7 +983,10 @@ int fcp_scsi_dev_reset(Scsi_Cmnd *SCpnt)
 	fc->rst_pkt->request->rq_status = RQ_SCSI_BUSY;
 
 	fc->rst_pkt->done = fcp_scsi_reset_done;
+
+	spin_lock_irqsave(SCpnt->device->host->host_lock, flags);
 	fcp_scsi_queue_it(fc, fc->rst_pkt, fcmd, 0);
+	spin_unlock_irqrestore(SCpnt->device->host->host_lock, flags);
 	
 	down(&sem);
 
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2273,7 +2273,6 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 		hd->timeouts++;
 
 	/* We are now ready to execute the task management request. */
-	spin_unlock_irq(host_lock);
 	if (mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_RESET_BUS,
 		SCpnt->device->channel, 0, 0, 0, 5 /* 5 second timeout */)
 	    < 0){
@@ -2289,7 +2288,7 @@ mptscsih_bus_reset(struct scsi_cmnd * SC
 		spin_lock_irq(host_lock);
 		return FAILED;
 	}
-	spin_lock_irq(host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -731,8 +731,6 @@ zfcp_scsi_eh_bus_reset_handler(struct sc
 	struct zfcp_unit *unit;
 	struct Scsi_Host *scsi_host = scpnt->device->host;
 
-	spin_unlock_irq(scsi_host->host_lock);
-
 	unit = (struct zfcp_unit *) scpnt->device->hostdata;
 	ZFCP_LOG_NORMAL("bus reset because of problems with "
 			"unit 0x%016Lx\n", unit->fcp_lun);
@@ -740,7 +738,6 @@ zfcp_scsi_eh_bus_reset_handler(struct sc
 	zfcp_erp_wait(unit->port->adapter);
 	retval = SUCCESS;
 
-	spin_lock_irq(scsi_host->host_lock);
 	return retval;
 }
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -1957,23 +1957,30 @@ NCR_700_bus_reset(struct scsi_cmnd * SCp
 	printk(KERN_INFO "scsi%d (%d:%d) New error handler wants BUS reset, cmd %p\n\t",
 	       SCp->device->host->host_no, SCp->device->id, SCp->device->lun, SCp);
 	scsi_print_command(SCp);
+
 	/* In theory, eh_complete should always be null because the
 	 * eh is single threaded, but just in case we're handling a
 	 * reset via sg or something */
-	while(hostdata->eh_complete != NULL) {
+	spin_lock_irq(SCp->device->host->host_lock);
+	while (hostdata->eh_complete != NULL) {
 		spin_unlock_irq(SCp->device->host->host_lock);
 		msleep_interruptible(100);
 		spin_lock_irq(SCp->device->host->host_lock);
 	}
+
 	hostdata->eh_complete = &complete;
 	NCR_700_internal_bus_reset(SCp->device->host);
+
 	spin_unlock_irq(SCp->device->host->host_lock);
 	wait_for_completion(&complete);
 	spin_lock_irq(SCp->device->host->host_lock);
+
 	hostdata->eh_complete = NULL;
 	/* Revalidate the transport parameters of the failing device */
 	if(hostdata->fast)
 		spi_schedule_dv_device(SCp->device);
+
+	spin_unlock_irq(SCp->device->host->host_lock);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2825,12 +2825,18 @@ static int NCR5380_abort(Scsi_Cmnd * cmd
  * Locks: host lock taken by caller
  */
 
-static int NCR5380_bus_reset(Scsi_Cmnd * cmd) {
+static int NCR5380_bus_reset(Scsi_Cmnd * cmd)
+{
+	struct Scsi_Host *instance = cmd->device->host;
+
 	NCR5380_local_declare();
-	NCR5380_setup(cmd->device->host);
+	NCR5380_setup(instance);
+	NCR5380_print_status(instance);
+
+	spin_lock_irq(instance->host_lock);
+	do_reset(instance);
+	spin_unlock_irq(instance->host_lock);
 
-	NCR5380_print_status(cmd->device->host);
-	do_reset(cmd->device->host);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -1467,14 +1467,12 @@ int esp_reset(Scsi_Cmnd *SCptr)
 {
 	struct NCR_ESP *esp = (struct NCR_ESP *) SCptr->device->host->hostdata;
 
+	spin_lock_irq(esp->ehost->host_lock);
 	(void) esp_do_resetbus(esp, esp->eregs);
-
 	spin_unlock_irq(esp->ehost->host_lock);
 
 	wait_event(esp->reset_queue, (esp->resetting_bus == 0));
 
-	spin_lock_irq(esp->ehost->host_lock);
-
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -735,11 +735,6 @@ static int NCR53c406a_host_reset(Scsi_Cm
 	return SUCCESS;
 }
 
-static int NCR53c406a_bus_reset(Scsi_Cmnd * SCpnt)
-{
-	return FAILED;
-}
-
 static int NCR53c406a_biosparm(struct scsi_device *disk,
                                struct block_device *dev,
 			       sector_t capacity, int *info_array)
@@ -1064,7 +1059,6 @@ static Scsi_Host_Template driver_templat
      .release            	= NCR53c406a_release,
      .info              	= NCR53c406a_info		/* info */,             
      .queuecommand      	= NCR53c406a_queue	/* queuecommand */,     
-     .eh_bus_reset_handler      = NCR53c406a_bus_reset	/* reset */,            
      .eh_host_reset_handler     = NCR53c406a_host_reset	/* reset */,            
      .bios_param        	= NCR53c406a_biosparm	/* biosparm */,         
      .can_queue         	= 1			/* can_queue */,        
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -221,7 +221,11 @@ int __init a2091_detect(Scsi_Host_Templa
 static int a2091_bus_reset(Scsi_Cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
+
+	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -208,7 +208,11 @@ fail_register:
 static int a3000_bus_reset(Scsi_Cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
+
+	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1464,8 +1464,8 @@ static int aha1542_bus_reset(Scsi_Cmnd *
 	 * check for timeout, and if we are doing something like this
 	 * we are pretty desperate anyways.
 	 */
-	spin_unlock_irq(SCpnt->device->host->host_lock);
 	ssleep(4);
+
 	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	WAIT(STATUS(SCpnt->device->host->io_port),
@@ -1503,9 +1503,11 @@ static int aha1542_bus_reset(Scsi_Cmnd *
 		}
 	}
 
+	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return SUCCESS;
 
 fail:
+	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return FAILED;
 }
 
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1591,11 +1591,11 @@ ahd_linux_bus_reset(Scsi_Cmnd *cmd)
 		printf("%s: Bus reset called for cmd %p\n",
 		       ahd_name(ahd), cmd);
 #endif
-	ahd_midlayer_entrypoint_lock(ahd, &s);
+	ahd_lock(ahd, &s);
 	found = ahd_reset_channel(ahd, cmd->device->channel + 'A',
 				  /*initiate reset*/TRUE);
 	ahd_linux_run_complete_queue(ahd);
-	ahd_midlayer_entrypoint_unlock(ahd, &s);
+	ahd_unlock(ahd, &s);
 
 	if (bootverbose)
 		printf("%s: SCSI bus reset delivered. "
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -843,10 +843,14 @@ ahc_linux_bus_reset(struct scsi_cmnd *cm
 {
 	struct ahc_softc *ahc;
 	int    found;
+	unsigned long flags;
 
 	ahc = *(struct ahc_softc **)cmd->device->host->hostdata;
+
+	ahc_lock(ahc, &flags);
 	found = ahc_reset_channel(ahc, cmd->device->channel + 'A',
 				  /*initiate reset*/TRUE);
+	ahc_unlock(ahc, &flags);
 
 	if (bootverbose)
 		printf("%s: SCSI bus reset delivered. "
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1310,7 +1310,7 @@ static void reset_dev_param(struct Adapt
  * @cmd - some command for this host (for fetching hooks)
  * Returns: SUCCESS (0x2002) on success, else FAILED (0x2003).
  */
-static int dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
+static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 {
 	struct AdapterCtlBlk *acb =
 		(struct AdapterCtlBlk *)cmd->device->host->hostdata;
@@ -1356,6 +1356,16 @@ static int dc395x_eh_bus_reset(struct sc
 	return SUCCESS;
 }
 
+static int dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
+{
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = __dc395x_eh_bus_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
+}
 
 /*
  * abort an errant SCSI command
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -518,7 +518,6 @@ static struct scsi_host_template driver_
 	.release = eata2x_release,
 	.queuecommand = eata2x_queuecommand,
 	.eh_abort_handler = eata2x_eh_abort,
-	.eh_bus_reset_handler = NULL,
 	.eh_host_reset_handler = eata2x_eh_host_reset,
 	.bios_param = eata2x_bios_param,
 	.slave_configure = eata2x_slave_configure,
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -1248,6 +1248,7 @@ static int fd_mcs_host_reset(Scsi_Cmnd *
 
 static int fd_mcs_bus_reset(Scsi_Cmnd * SCpnt) {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
+	unsigned long flags;
 
 #if DEBUG_RESET
 	static int called_once = 0;
@@ -1264,6 +1265,8 @@ static int fd_mcs_bus_reset(Scsi_Cmnd * 
 	called_once = 1;
 #endif
 
+	spin_lock_irqsave(shpnt->host_lock, flags);
+
 	outb(1, SCSI_Cntl_port);
 	do_pause(2);
 	outb(0, SCSI_Cntl_port);
@@ -1271,6 +1274,8 @@ static int fd_mcs_bus_reset(Scsi_Cmnd * 
 	outb(0, SCSI_Mode_Cntl_port);
 	outb(PARITY_MASK, TMC_Cntl_port);
 
+	spin_unlock_irqrestore(shpnt->host_lock, flags);
+
 	/* Unless this is the very first call (i.e., SCPnt == NULL), everything
 	   is probably hosed at this point.  We will, however, try to keep
 	   things going by informing the high-level code that we need help. */
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1543,12 +1543,18 @@ static int fdomain_16x0_abort(struct scs
 
 int fdomain_16x0_bus_reset(struct scsi_cmnd *SCpnt)
 {
+   unsigned long flags;
+
+   local_irq_save(flags);
+
    outb(1, port_base + SCSI_Cntl);
    do_pause( 2 );
    outb(0, port_base + SCSI_Cntl);
    do_pause( 115 );
    outb(0, port_base + SCSI_Mode_Cntl);
    outb(PARITY_MASK, port_base + TMC_Cntl);
+
+   local_irq_restore(flags);
    return SUCCESS;
 }
 
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -345,7 +345,11 @@ release:
 static int gvp11_bus_reset(Scsi_Cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
+
+	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -18,6 +18,7 @@
 #include <linux/blkdev.h>
 #include <linux/parport.h>
 #include <linux/workqueue.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
@@ -610,9 +611,9 @@ static int imm_init(imm_struct *dev)
 	if (imm_connect(dev, 0) != 1)
 		return -EIO;
 	imm_reset_pulse(dev->base);
-	udelay(1000);	/* Delay to allow devices to settle */
+	mdelay(1);	/* Delay to allow devices to settle */
 	imm_disconnect(dev);
-	udelay(1000);	/* Another delay to allow devices to settle */
+	mdelay(1);	/* Another delay to allow devices to settle */
 	return device_check(dev);
 }
 
@@ -1026,9 +1027,9 @@ static int imm_reset(struct scsi_cmnd *c
 
 	imm_connect(dev, CONNECT_NORMAL);
 	imm_reset_pulse(dev->base);
-	udelay(1000);		/* device settle delay */
+	mdelay(1);		/* device settle delay */
 	imm_disconnect(dev);
-	udelay(1000);		/* device settle delay */
+	mdelay(1);		/* device settle delay */
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -1644,14 +1644,16 @@ static int in2000_bus_reset(Scsi_Cmnd * 
 	struct Scsi_Host *instance;
 	struct IN2000_hostdata *hostdata;
 	int x;
+	unsigned long flags;
 
 	instance = cmd->device->host;
 	hostdata = (struct IN2000_hostdata *) instance->hostdata;
 
 	printk(KERN_WARNING "scsi%d: Reset. ", instance->host_no);
 
-	/* do scsi-reset here */
+	spin_lock_irqsave(instance->host_lock, flags);
 
+	/* do scsi-reset here */
 	reset_hardware(instance, RESET_CARD_AND_BUS);
 	for (x = 0; x < 8; x++) {
 		hostdata->busy[x] = 0;
@@ -1668,6 +1670,8 @@ static int in2000_bus_reset(Scsi_Cmnd * 
 	hostdata->outgoing_len = 0;
 
 	cmd->result = DID_RESET << 16;
+
+	spin_unlock_irqrestore(instance->host_lock, flags);
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -3014,7 +3014,11 @@ static int i91u_bus_reset(struct scsi_cm
 	HCS *pHCB;
 
 	pHCB = (HCS *) SCpnt->device->host->base;
+
+	spin_lock_irq(SCpnt->device->host->host_lock);
 	tul_reset_scsi(pHCB, 0);
+	spin_unlock_irq(SCpnt->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1054,7 +1054,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
  * Note: midlayer calls this function with the host_lock held
  */
 static int
-lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
+__lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
@@ -1144,6 +1144,16 @@ out:
 }
 
 static int
+lpfc_reset_bus_handler(struct scsi_cmnd *cmnd)
+{
+	int rc;
+	spin_lock_irq(cmnd->device->host->host_lock);
+	rc = __lpfc_reset_bus_handler(cmnd);
+	spin_unlock_irq(cmnd->device->host->host_lock);
+	return rc;
+}
+
+static int
 lpfc_slave_alloc(struct scsi_device *sdev)
 {
 	struct lpfc_hba *phba = (struct lpfc_hba *)sdev->host->hostdata[0];
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -116,7 +116,11 @@ int mvme147_detect(Scsi_Host_Template *t
 static int mvme147_bus_reset(Scsi_Cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
+
+	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -2987,6 +2987,8 @@ static int nsp32_eh_bus_reset(struct scs
 	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
 	unsigned int   base = SCpnt->device->host->io_port;
 
+	spin_lock_irq(SCpnt->device->host->host_lock);
+
 	nsp32_msg(KERN_INFO, "Bus Reset");	
 	nsp32_dbg(NSP32_DEBUG_BUSRESET, "SCpnt=0x%x", SCpnt);
 
@@ -2994,6 +2996,7 @@ static int nsp32_eh_bus_reset(struct scs
 	nsp32_do_bus_reset(data);
 	nsp32_write2(base, IRQ_CONTROL, 0);
 
+	spin_unlock_irq(SCpnt->device->host->host_lock);
 	return SUCCESS;	/* SCSI bus reset is succeeded at any time. */
 }
 
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -17,6 +17,7 @@
 #include <linux/blkdev.h>
 #include <linux/parport.h>
 #include <linux/workqueue.h>
+#include <linux/delay.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
@@ -891,9 +892,9 @@ static int ppa_reset(struct scsi_cmnd *c
 
 	ppa_connect(dev, CONNECT_NORMAL);
 	ppa_reset_pulse(dev->base);
-	udelay(1000);		/* device settle delay */
+	mdelay(1);		/* device settle delay */
 	ppa_disconnect(dev);
-	udelay(1000);		/* device settle delay */
+	mdelay(1);		/* device settle delay */
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1130,7 +1130,13 @@ qla1280_eh_device_reset(struct scsi_cmnd
 static int
 qla1280_eh_bus_reset(struct scsi_cmnd *cmd)
 {
-	return qla1280_error_action(cmd, BUS_RESET);
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = qla1280_error_action(cmd, BUS_RESET);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
 }
 
 /**************************************************************************
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -795,8 +795,6 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *c
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): LOOP RESET ISSUED.\n", ha->host_no, id, lun);
 
-	spin_unlock_irq(ha->host->host_lock);
-
 	if (qla2x00_wait_for_hba_online(ha) != QLA_SUCCESS) {
 		DEBUG2(printk("%s failed:board disabled\n",__func__));
 		goto eh_bus_reset_done;
@@ -818,8 +816,6 @@ eh_bus_reset_done:
 	qla_printk(KERN_INFO, ha, "%s: reset %s\n", __func__,
 	    (ret == FAILED) ? "failed" : "succeded");
 
-	spin_lock_irq(ha->host->host_lock);
-
 	return ret;
 }
 
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -511,8 +511,14 @@ int qlogicfas408_abort(Scsi_Cmnd * cmd)
 int qlogicfas408_bus_reset(Scsi_Cmnd * cmd)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_cmd(cmd);
+	unsigned long flags;
+
 	priv->qabort = 2;
+
+	spin_lock_irqsave(cmd->device->host->host_lock, flags);
 	ql_zap(priv);
+	spin_unlock_irqrestore(cmd->device->host->host_lock, flags);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1049,9 +1049,7 @@ static int scsi_try_bus_reset(struct scs
 	if (!scmd->device->host->hostt->eh_bus_reset_handler)
 		return FAILED;
 
-	spin_lock_irqsave(scmd->device->host->host_lock, flags);
 	rtn = scmd->device->host->hostt->eh_bus_reset_handler(scmd);
-	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
 	if (rtn == SUCCESS) {
 		if (!scmd->device->host->hostt->skip_settle_delay)
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -97,6 +97,7 @@
 #include <linux/delay.h>
 #include <linux/blkdev.h>
 #include <linux/stat.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
@@ -1631,7 +1632,7 @@ static int seagate_st0x_bus_reset(Scsi_C
 	/* assert  RESET signal on SCSI bus.  */
 	WRITE_CONTROL (BASE_CMD | CMD_RST);
 
-	udelay (20 * 1000);
+	mdelay (20);
 
 	WRITE_CONTROL (BASE_CMD);
 	st0x_aborted = DID_RESET;
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -310,7 +310,11 @@ int sgiwd93_release(struct Scsi_Host *in
 static int sgiwd93_bus_reset(Scsi_Cmnd *cmd)
 {
 	/* FIXME perform bus-specific reset */
+
+	spin_lock_irq(cmd->device->host->host_lock);
 	wd33c93_host_reset(cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -785,11 +785,6 @@ int sym53c416_queuecommand(Scsi_Cmnd *SC
 	return 0;
 }
 
-static int sym53c416_bus_reset(Scsi_Cmnd *SCpnt)
-{
-	return FAILED;
-}
-
 static int sym53c416_host_reset(Scsi_Cmnd *SCpnt)
 {
 	int base;
@@ -856,7 +851,6 @@ static Scsi_Host_Template driver_templat
 	.info =			sym53c416_info,	
 	.queuecommand =		sym53c416_queuecommand,
 	.eh_host_reset_handler =sym53c416_host_reset,
-	.eh_bus_reset_handler = sym53c416_bus_reset,
 	.release = 		sym53c416_release,
 	.bios_param =		sym53c416_bios_param,
 	.can_queue =		1,
diff --git a/drivers/scsi/sym53c416.h b/drivers/scsi/sym53c416.h
--- a/drivers/scsi/sym53c416.h
+++ b/drivers/scsi/sym53c416.h
@@ -27,7 +27,6 @@ static const char *sym53c416_info(struct
 static int sym53c416_release(struct Scsi_Host *);
 static int sym53c416_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static int sym53c416_host_reset(Scsi_Cmnd *);
-static int sym53c416_bus_reset(Scsi_Cmnd *);
 static int sym53c416_bios_param(struct scsi_device *, struct block_device *,
 		sector_t, int *);
 static void sym53c416_setup(char *str, int *ints);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -904,7 +904,13 @@ static int sym53c8xx_eh_device_reset_han
 
 static int sym53c8xx_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	return sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
+	int rc;
+
+	spin_lock_irq(cmd->device->host->host_lock);
+	rc = sym_eh_handler(SYM_EH_BUS_RESET, "BUS RESET", cmd);
+	spin_unlock_irq(cmd->device->host->host_lock);
+
+	return rc;
 }
 
 static int sym53c8xx_eh_host_reset_handler(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2120,6 +2120,8 @@ static int DC390_bus_reset (struct scsi_
 	struct dc390_acb*    pACB = (struct dc390_acb*) cmd->device->host->hostdata;
 	u8   bval;
 
+	spin_lock_irq(cmd->device->host->host_lock);
+
 	bval = DC390_read8(CtrlReg1) | DIS_INT_ON_SCSI_RST;
 	DC390_write8(CtrlReg1, bval);	/* disable IRQ on bus reset */
 
@@ -2127,7 +2129,7 @@ static int DC390_bus_reset (struct scsi_
 	dc390_ResetSCSIBus(pACB);
 
 	dc390_ResetDevParam(pACB);
-	udelay(1000);
+	mdelay(1);
 	pACB->pScsiHost->last_reset = jiffies + 3*HZ/2 
 		+ HZ * dc390_eepromBuf[pACB->AdapterIndex][EE_DELAY];
     
@@ -2142,6 +2144,8 @@ static int DC390_bus_reset (struct scsi_
 	bval = DC390_read8(CtrlReg1) & ~DIS_INT_ON_SCSI_RST;
 	DC390_write8(CtrlReg1, bval);	/* re-enable interrupt */
 
+	spin_unlock_irq(cmd->device->host->host_lock);
+
 	return SUCCESS;
 }
 
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -446,7 +446,6 @@ static struct scsi_host_template driver_
                 .release                 = u14_34f_release,
                 .queuecommand            = u14_34f_queuecommand,
                 .eh_abort_handler        = u14_34f_eh_abort,
-                .eh_bus_reset_handler    = NULL,
                 .eh_host_reset_handler   = u14_34f_eh_host_reset,
                 .bios_param              = u14_34f_bios_param,
                 .slave_configure         = u14_34f_slave_configure,
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -276,8 +276,6 @@ static int bus_reset(struct scsi_cmnd *s
 
 	US_DEBUGP("%s called\n", __FUNCTION__);
 
-	scsi_unlock(us_to_host(us));
-
 	/* The USB subsystem doesn't handle synchronisation between
 	 * a device's several drivers. Therefore we reset only devices
 	 * with just one interface, which we of course own. */
@@ -304,7 +302,6 @@ static int bus_reset(struct scsi_cmnd *s
 	up(&(us->dev_semaphore));
 
 	/* lock the host for the return */
-	scsi_lock(us_to_host(us));
 	return result < 0 ? FAILED : SUCCESS;
 }
 

--------------070105040908090901050000--
