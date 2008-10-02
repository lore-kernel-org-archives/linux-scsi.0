From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] [10/21] SCSI-ISA-DMA: Remove unchecked_isa_dma in aha152x/wd7000/sym53c416/u14-34f/NCR53c406a
Date: Thu,  2 Oct 2008 09:58:48 +0200 (CEST)
Message-ID: <20081002075848.47A343E6A07@basil.firstfloor.org>
References: <20081002958.641114646@firstfloor.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57081 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYJBH6u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2008 03:58:50 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, axboe@kernel.dk


I lumped these all together because these old ISA only drivers all look 
very unmaintained and the changes were relatively simple.

I audited them for possible use of unchecked_isa_dma and fixed the cases
who needed them:
- Allocate separate dma'able hostdata when needed
- Checked that they all always copy ->cmnd
- Checked if they need sense_buffer bouncing and enable when needed
(i'm not 100% sure what it means if a driver does not reference
sense_buffer, but all except ultrastor and u14-34f do not) 
- Add a explicit slave_alloc callback to enable block layer bouncing

Untested due to lack of hardware.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/NCR53c406a.c |    8 +++++-
 drivers/scsi/aha152x.c    |   29 +++++++++++++++++++++---
 drivers/scsi/sym53c416.c  |    9 ++++++-
 drivers/scsi/u14-34f.c    |   54 +++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/ultrastor.c  |   13 ++++++++---
 drivers/scsi/wd7000.c     |   48 +++++++++++++++++++++++++++-------------
 6 files changed, 124 insertions(+), 37 deletions(-)

Index: linux/drivers/scsi/aha152x.c
===================================================================
--- linux.orig/drivers/scsi/aha152x.c
+++ linux/drivers/scsi/aha152x.c
@@ -551,6 +551,10 @@ struct aha152x_hostdata {
 	struct list_head host_list;
 };
 
+struct aha152x_hostdata_ptr {
+	struct aha152x_hostdata *host;
+	dma_addr_t dma;
+};
 
 /*
  * host specific command extension
@@ -564,7 +568,10 @@ struct aha152x_scdata {
 
 /* access macros for hostdata */
 
-#define HOSTDATA(shpnt)		((struct aha152x_hostdata *) &shpnt->hostdata)
+#define HOSTDATA(shpnt) \
+	(((struct aha152x_hostdata_ptr *) shost_priv(shpnt))->host)
+#define HOSTDMA(shpnt) \
+	(((struct aha152x_hostdata_ptr *) shost_priv(shpnt))->dma)
 
 #define HOSTNO			((shpnt)->host_no)
 
@@ -771,14 +778,24 @@ static irqreturn_t swintr(int irqno, voi
 struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 {
 	struct Scsi_Host *shpnt;
+	struct aha152x_hostdata *host;
 
-	shpnt = scsi_host_alloc(&aha152x_driver_template, sizeof(struct aha152x_hostdata));
+	shpnt = scsi_host_alloc(&aha152x_driver_template,
+				sizeof(struct aha152x_hostdata_ptr));
 	if (!shpnt) {
 		printk(KERN_ERR "aha152x: scsi_host_alloc failed\n");
 		return NULL;
 	}
 
-	memset(HOSTDATA(shpnt), 0, sizeof *HOSTDATA(shpnt));
+	host = dma_alloc_coherent(NULL, sizeof(struct aha152x_hostdata),
+				  &HOSTDMA(shpnt), GFP_KERNEL);
+	HOSTDATA(shpnt) = host;
+	if (!host) {
+		scsi_host_put(shpnt);
+		printk(KERN_ERR "aha152x: dma alloc of hostdata failed\n");
+		return NULL;
+	}
+
 	INIT_LIST_HEAD(&HOSTDATA(shpnt)->host_list);
 
 	/* need to have host registered before triggering any interrupt */
@@ -899,6 +916,8 @@ struct Scsi_Host *aha152x_probe_one(stru
 
 out_host_put:
 	list_del(&HOSTDATA(shpnt)->host_list);
+	dma_free_coherent(NULL, sizeof(struct aha152x_hostdata),
+			  HOSTDATA(shpnt), HOSTDMA(shpnt));
 	scsi_host_put(shpnt);
 
 	return NULL;
@@ -924,6 +943,8 @@ void aha152x_release(struct Scsi_Host *s
 #endif
 
 	list_del(&HOSTDATA(shpnt)->host_list);
+	dma_free_coherent(NULL, sizeof(struct aha152x_hostdata),
+			  HOSTDATA(shpnt), HOSTDMA(shpnt));
 	scsi_host_put(shpnt);
 }
 
@@ -3451,7 +3472,7 @@ static int aha152x_proc_info(struct Scsi
 
 static int aha152x_adjust_queue(struct scsi_device *device)
 {
-	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
 	return 0;
 }
 
Index: linux/drivers/scsi/wd7000.c
===================================================================
--- linux.orig/drivers/scsi/wd7000.c
+++ linux/drivers/scsi/wd7000.c
@@ -189,7 +189,6 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
 
-
 #undef  WD7000_DEBUG		/* general debug                */
 #ifdef WD7000_DEBUG
 #define dprintk printk
@@ -260,6 +259,14 @@ typedef struct adapter {
 	unchar rev1, rev2;	/* filled in by wd7000_revision      */
 } Adapter;
 
+struct adapter_ptr {
+	Adapter *host;
+	dma_addr_t dma;
+};
+
+#define wd_host(shost) (((struct adapter_ptr *)shost_priv(shost))->host)
+#define wd_host_dma(shost) (((struct adapter_ptr *)shost_priv(shost))->dma)
+
 /*
  * (linear) base address for ROM BIOS
  */
@@ -1092,7 +1099,7 @@ static int wd7000_queuecommand(struct sc
 	unchar idlun;
 	short cdblen;
 	int nseg;
-	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
+	Adapter *host = wd_host(SCpnt->device->host);
 
 	cdblen = SCpnt->cmd_len;
 	idlun = ((SCpnt->device->id << 5) & 0xe0) | (SCpnt->device->lun & 7);
@@ -1312,7 +1319,7 @@ static int wd7000_set_info(char *buffer,
 
 static int wd7000_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t offset, int length,  int inout)
 {
-	Adapter *adapter = (Adapter *)host->hostdata;
+	Adapter *adapter = wd_host(host);
 	unsigned long flags;
 	char *pos = buffer;
 #ifdef WD7000_DEBUG
@@ -1485,18 +1492,17 @@ static __init int wd7000_detect(struct s
 				dprintk("ok!\n");
 
 			if (inb(iobase + ASC_INTR_STAT) == 1) {
-				/*
-				 *  We register here, to get a pointer to the extra space,
-				 *  which we'll use as the Adapter structure (host) for
-				 *  this adapter.  It is located just after the registered
-				 *  Scsi_Host structure (sh), and is located by the empty
-				 *  array hostdata.
-				 */
-				sh = scsi_register(tpnt, sizeof(Adapter));
+				sh = scsi_register(tpnt, sizeof(struct adapter_ptr));
 				if (sh == NULL)
 					goto err_release;
 
-				host = (Adapter *) sh->hostdata;
+				host = dma_alloc_coherent(NULL, sizeof(Adapter),
+							  &wd_host_dma(sh),
+							  GFP_KERNEL);
+				if (!host)
+					goto err_unregister;
+
+				wd_host(sh) = host;
 
 				dprintk("wd7000_detect: adapter allocated at 0x%x\n", (int) host);
 				memset(host, 0, sizeof(Adapter));
@@ -1513,7 +1519,7 @@ static __init int wd7000_detect(struct s
 				dprintk("wd7000_detect: Trying init WD-7000 card at IO " "0x%x, IRQ %d, DMA %d...\n", host->iobase, host->irq, host->dma);
 
 				if (!wd7000_init(host))	/* Initialization failed */
-					goto err_unregister;
+					goto err_free_host;
 
 				/*
 				 *  OK from here - we'll use this adapter/configuration.
@@ -1540,6 +1546,8 @@ static __init int wd7000_detect(struct s
 
 		continue;
 
+	      err_free_host:
+		dma_free_coherent(NULL, sizeof(Adapter), host,wd_host_dma(sh));
 	      err_unregister:
 		scsi_unregister(sh);
 	      err_release:
@@ -1559,6 +1567,8 @@ static int wd7000_release(struct Scsi_Ho
 		free_irq(shost->irq, NULL);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
+	dma_free_coherent(NULL, sizeof(Adapter), wd_host(shost),
+			  wd_host_dma(shost));
 	scsi_unregister(shost);
 	return 0;
 }
@@ -1569,7 +1579,7 @@ static int wd7000_release(struct Scsi_Ho
  */
 static int wd7000_abort(Scsi_Cmnd * SCpnt)
 {
-	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
+	Adapter *host = wd_host(SCpnt->device->host);
 
 	if (inb(host->iobase + ASC_STAT) & INT_IM) {
 		printk("wd7000_abort: lost interrupt\n");
@@ -1586,7 +1596,7 @@ static int wd7000_abort(Scsi_Cmnd * SCpn
 
 static int wd7000_host_reset(struct scsi_cmnd *SCpnt)
 {
-	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
+	Adapter *host = wd_host(SCpnt->device->host);
 
 	spin_unlock_irq(SCpnt->device->host->host_lock);
 
@@ -1652,6 +1662,12 @@ static int wd7000_biosparam(struct scsi_
 	return (0);
 }
 
+static int wd7000_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 MODULE_AUTHOR("Thomas Wuensche, John Boyd, Miroslav Zagorac");
 MODULE_DESCRIPTION("Driver for the WD7000 series ISA controllers");
 MODULE_LICENSE("GPL");
@@ -1669,7 +1685,7 @@ static struct scsi_host_template driver_
 	.this_id		= 7,
 	.sg_tablesize		= WD7000_SG,
 	.cmd_per_lun		= 1,
-	.unchecked_isa_dma	= 1,
+	.slave_alloc		= wd7000_adjust_queue,
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
Index: linux/drivers/scsi/NCR53c406a.c
===================================================================
--- linux.orig/drivers/scsi/NCR53c406a.c
+++ linux/drivers/scsi/NCR53c406a.c
@@ -1045,6 +1045,12 @@ static void __init calc_port_addr(void)
 
 MODULE_LICENSE("GPL");
 
+static int NCR53c406a_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 /* NOTE:  scatter-gather support only works in PIO mode.
  * Use SG_NONE if DMA mode is enabled!
  */
@@ -1063,8 +1069,8 @@ static struct scsi_host_template driver_
      .this_id           	= 7			/* SCSI ID of the chip */,
      .sg_tablesize      	= 32			/*SG_ALL*/ /*SG_NONE*/, 
      .cmd_per_lun       	= 1			/* commands per lun */, 
-     .unchecked_isa_dma 	= 1			/* unchecked_isa_dma */,
      .use_clustering    	= ENABLE_CLUSTERING,
+     .slave_alloc		= NCR53c406a_adjust_queue,
 };
 
 #include "scsi_module.c"
Index: linux/drivers/scsi/u14-34f.c
===================================================================
--- linux.orig/drivers/scsi/u14-34f.c
+++ linux/drivers/scsi/u14-34f.c
@@ -439,6 +439,12 @@ static int u14_34f_bios_param(struct scs
                               sector_t, int *);
 static int u14_34f_slave_configure(struct scsi_device *);
 
+static int u14_34f_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 static struct scsi_host_template driver_template = {
                 .name                    = "UltraStor 14F/34F rev. 8.10.00 ",
                 .detect                  = u14_34f_detect,
@@ -449,8 +455,9 @@ static struct scsi_host_template driver_
                 .bios_param              = u14_34f_bios_param,
                 .slave_configure         = u14_34f_slave_configure,
                 .this_id                 = 7,
-                .unchecked_isa_dma       = 1,
                 .use_clustering          = ENABLE_CLUSTERING,
+		.sense_buffer_isa	 = 1,
+		.slave_alloc		 = u14_34f_adjust_queue,
                 };
 
 #if !defined(__BIG_ENDIAN_BITFIELD) && !defined(__LITTLE_ENDIAN_BITFIELD)
@@ -606,6 +613,11 @@ struct hostdata {
    char board_id[256];                  /* data from INQUIRY on this board */
    };
 
+struct hostdata_ptr {
+	struct hostdata *host;
+	dma_addr_t dma;
+};
+
 static struct Scsi_Host *sh[MAX_BOARDS + 1];
 static const char *driver_name = "Ux4F";
 static char sha[MAX_BOARDS];
@@ -627,7 +639,9 @@ static unsigned long io_port[] = {
    0x0
    };
 
-#define HD(board) ((struct hostdata *) &sh[board]->hostdata)
+#define HOSTDATA(shost) (((struct hostdata_ptr *)shost_priv(shost))->host)
+#define HOSTDMA(shost) (((struct hostdata_ptr *)shost_priv(shost))->dma)
+#define HD(board) HOSTDATA(sh[board])
 #define BN(board) (HD(board)->board_name)
 
 /* Device is Little Endian */
@@ -688,7 +702,7 @@ static int u14_34f_slave_configure(struc
    char *tag_suffix, *link_suffix;
    struct Scsi_Host *host = dev->host;
 
-   j = ((struct hostdata *) host->hostdata)->board_number;
+   j = HOSTDATA(host)->board_number;
 
    utqd = MAX_CMD_PER_LUN;
    tqd = max_queue_depth;
@@ -799,6 +813,8 @@ static int port_detect \
    unsigned char irq, dma_channel, subversion, i;
    unsigned char in_byte;
    char *bus_type, dma_name[16];
+   struct hostdata *host;
+   dma_addr_t dma;
 
    /* Allowed BIOS base addresses (NULL indicates reserved) */
    unsigned long bios_segment_table[8] = {
@@ -888,13 +904,26 @@ static int port_detect \
    if (have_old_firmware) tpnt->use_clustering = DISABLE_CLUSTERING;
 
    spin_unlock_irq(&driver_lock);
-   sh[j] = scsi_register(tpnt, sizeof(struct hostdata));
+
+   host = dma_alloc_coherent(NULL, sizeof(struct hostdata), &dma, GFP_KERNEL);
+   if (!host) {
+	   printk("%s: unable to allocate dma data\n", name);
+	   spin_lock_irq(&driver_lock);
+	   goto freedma;
+   }
+
+   sh[j] = scsi_register(tpnt, sizeof(struct hostdata_ptr));
+   if (sh[j])
+     HOSTDMA(sh[j]) = dma;
+
    spin_lock_irq(&driver_lock);
 
    if (sh[j] == NULL) {
       printk("%s: unable to register host, detaching.\n", name);
-      goto freedma;
-      }
+      goto freebounce;
+   }
+   HOSTDATA(sh[j]) = host;
+   memset(host, 0, sizeof(struct hostdata));
 
    sh[j]->io_port = port_base;
    sh[j]->unique_id = port_base;
@@ -932,14 +961,12 @@ static int port_detect \
    if (have_old_firmware) sh[j]->sg_tablesize = MAX_SAFE_SGLIST;
 
    if (HD(j)->subversion == ESA) {
-      sh[j]->unchecked_isa_dma = FALSE;
       sh[j]->dma_channel = NO_DMA;
       sprintf(BN(j), "U34F%d", j);
       bus_type = "VESA";
       }
    else {
       unsigned long flags;
-      sh[j]->unchecked_isa_dma = TRUE;
 
       flags=claim_dma_lock();
       disable_dma(dma_channel);
@@ -981,7 +1008,7 @@ static int port_detect \
    for (i = 0; i < sh[j]->can_queue; i++)
       if (! ((&HD(j)->cp[i])->sglist = kmalloc(
             sh[j]->sg_tablesize * sizeof(struct sg_list),
-            (sh[j]->unchecked_isa_dma ? GFP_DMA : 0) | GFP_ATOMIC))) {
+	    ((HD(j)->subversion != ESA) ? __GFP_DMA : 0) | GFP_ATOMIC))) {
          printk("%s: kmalloc SGlist failed, mbox %d, detaching.\n", BN(j), i);
          goto release;
          }
@@ -1015,6 +1042,8 @@ static int port_detect \
 
    return TRUE;
 
+freebounce:
+   dma_free_coherent(NULL, sizeof(struct hostdata), host, HOSTDMA(sh[j]));
 freedma:
    if (subversion == ISA) free_dma(dma_channel);
 freeirq:
@@ -1251,7 +1280,7 @@ static int u14_34f_queuecommand(struct s
    struct mscp *cpp;
 
    /* j is the board number */
-   j = ((struct hostdata *) SCpnt->device->host->hostdata)->board_number;
+   j = HOSTDATA(SCpnt->device->host)->board_number;
 
    if (SCpnt->host_scribble)
       panic("%s: qcomm, pid %ld, SCpnt %p already active.\n",
@@ -1330,7 +1359,7 @@ static int u14_34f_queuecommand(struct s
 static int u14_34f_eh_abort(struct scsi_cmnd *SCarg) {
    unsigned int i, j;
 
-   j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
+   j = HOSTDATA(SCarg->device->host)->board_number;
 
    if (SCarg->host_scribble == NULL) {
       scmd_printk(KERN_INFO, SCarg, "abort, pid %ld inactive.\n",
@@ -1398,7 +1427,7 @@ static int u14_34f_eh_host_reset(struct 
    int arg_done = FALSE;
    struct scsi_cmnd *SCpnt;
 
-   j = ((struct hostdata *) SCarg->device->host->hostdata)->board_number;
+   j = HOSTDATA(SCarg->device->host)->board_number;
    scmd_printk(KERN_INFO, SCarg, "reset, enter, pid %ld.\n", SCarg->serial_number);
 
    spin_lock_irq(sh[j]->host_lock);
@@ -1962,6 +1991,7 @@ static int u14_34f_release(struct Scsi_H
       free_dma(sh[j]->dma_channel);
 
    release_region(sh[j]->io_port, sh[j]->n_io_port);
+   dma_free_coherent(NULL, sizeof(struct hostdata), sh[j], HOSTDMA(sh[j]));
    scsi_unregister(sh[j]);
    return FALSE;
 }
Index: linux/drivers/scsi/sym53c416.c
===================================================================
--- linux.orig/drivers/scsi/sym53c416.c
+++ linux/drivers/scsi/sym53c416.c
@@ -825,6 +825,12 @@ module_param_array(sym53c416_3, uint, NU
 
 #endif
 
+static int sym53c416_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 static struct scsi_host_template driver_template = {
 	.proc_name =		"sym53c416",
 	.name =			"Symbios Logic 53c416",
@@ -838,7 +844,8 @@ static struct scsi_host_template driver_
 	.this_id =		SYM53C416_SCSI_ID,
 	.sg_tablesize =		32,
 	.cmd_per_lun =		1,
-	.unchecked_isa_dma =	1,
 	.use_clustering =	ENABLE_CLUSTERING,
+	.slave_alloc =		sym53c416_adjust_queue,
+
 };
 #include "scsi_module.c"
Index: linux/drivers/scsi/ultrastor.c
===================================================================
--- linux.orig/drivers/scsi/ultrastor.c
+++ linux/drivers/scsi/ultrastor.c
@@ -350,6 +350,12 @@ static void log_ultrastor_abort(struct u
 }
 #endif
 
+static int ultrastor_adjust_queue(struct scsi_device *device)
+{
+	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_ISA);
+	return 0;
+}
+
 static int ultrastor_14f_detect(struct scsi_host_template * tpnt)
 {
     size_t i;
@@ -501,7 +507,10 @@ static int ultrastor_14f_detect(struct s
 	   config.dma_channel, config.ha_scsi_id, config.subversion);
 #endif
     tpnt->this_id = config.ha_scsi_id;
-    tpnt->unchecked_isa_dma = (config.subversion != U34F);
+    if (config.subversion != U34F) {
+	tpnt->sense_buffer_isa = 1;
+	tpnt->slave_alloc = ultrastor_adjust_queue;
+    }
 
 #if ULTRASTOR_MAX_CMDS > 1
     config.mscp_free = ~0;
@@ -605,7 +614,6 @@ static int ultrastor_24f_detect(struct s
 	     config.interrupt, config.ha_scsi_id);
 #endif
       tpnt->this_id = config.ha_scsi_id;
-      tpnt->unchecked_isa_dma = 0;
       tpnt->sg_tablesize = ULTRASTOR_24F_MAX_SG;
 
       shpnt = scsi_register(tpnt, 0);
@@ -1202,7 +1210,6 @@ static struct scsi_host_template driver_
 	.can_queue         = ULTRASTOR_MAX_CMDS,
 	.sg_tablesize      = ULTRASTOR_14F_MAX_SG,
 	.cmd_per_lun       = ULTRASTOR_MAX_CMDS_PER_LUN,
-	.unchecked_isa_dma = 1,
 	.use_clustering    = ENABLE_CLUSTERING,
 };
 #include "scsi_module.c"
