From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aha152x pcmcia updates
Date: Thu, 27 Mar 2003 16:03:55 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030327160355.A10288@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

(1) use new pcmcia_register_driver() & co API
(2) use scsi_add_host & co.  This needed some restructuring in aha152x.c
(3) add a bunch of missing statics to aha152x.c
(4) move prototypes for functions used by aha152x_stub.c to aha152x.h


--- 1.26/drivers/scsi/aha152x.c	Tue Mar 25 12:10:39 2003
+++ edited/drivers/scsi/aha152x.c	Thu Mar 27 14:31:56 2003
@@ -404,25 +404,11 @@
 #endif /* ISAPNP */
 
 /* set by aha152x_setup according to the command line */
-static int setup_count = 0;
-static int registered_count = 0;
-static struct aha152x_setup {
-	int io_port;
-	int irq;
-	int scsiid;
-	int reconnect;
-	int parity;
-	int synchronous;
-	int delay;
-	int ext_trans;
-	int tc1550;
-#if defined(AHA152X_DEBUG)
-	int debug;
-#endif
-	char *conf;
-} setup[2];
-
+static int setup_count;
+static int registered_count;
+static struct aha152x_setup setup[2];
 static struct Scsi_Host *aha152x_host[2];
+static Scsi_Host_Template aha152x_driver_template;
 
 /*
  * internal states of the host
@@ -806,7 +792,7 @@
 }
 
 #if defined(PCMCIA) || !defined(MODULE)
-void aha152x_setup(char *str, int *ints)
+static void aha152x_setup(char *str, int *ints)
 {
 	if(setup_count>=ARRAY_SIZE(setup)) {
 		printk(KERN_ERR "aha152x: you can only configure up to two controllers\n");
@@ -832,10 +818,8 @@
 		printk(KERN_NOTICE "aha152x: usage: aha152x=<IOBASE>[,<IRQ>[,<SCSI ID>"
 		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>]]]]]]]\n");
 #endif
-		return;
 	} else {
 		setup_count++;
-		return;
 	}
 }
 #endif
@@ -970,7 +954,142 @@
 static struct pnp_dev *pnpdev[2];
 static int num_pnpdevs;
 #endif
-int aha152x_detect(Scsi_Host_Template * tpnt)
+
+struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
+{
+	struct Scsi_Host *shost, *shpnt;
+	struct aha152x_hostdata *aha;
+
+	/* XXX: shpnt is needed for some broken macros */
+	shost = shpnt = scsi_register(&aha152x_driver_template,
+					sizeof(struct aha152x_hostdata));
+	if (!shost) {
+		printk(KERN_ERR "aha152x: scsi_register failed\n");
+		return NULL;
+	}
+
+	aha = (struct aha152x_hostdata *)&shost->hostdata;
+	memset(aha, 0, sizeof(*aha));
+
+	shost->io_port   = setup->io_port;
+	shost->n_io_port = IO_RANGE;
+	shost->irq       = setup->irq;
+
+	if (!setup->tc1550) {
+		aha->io_port0 = setup->io_port;
+		aha->io_port1 = setup->io_port;
+	} else {
+		aha->io_port0 = setup->io_port+0x10;
+		aha->io_port1 = setup->io_port-0x10;
+	}
+
+	spin_lock_init(&aha->lock);
+	aha->reconnect = setup->reconnect;
+	aha->synchronous = setup->synchronous;
+	aha->parity = setup->parity;
+	aha->delay = setup->delay;
+	aha->ext_trans = setup->ext_trans;
+
+#if defined(AHA152X_DEBUG)
+	aha->debug = setup->debug;
+#endif
+
+	SETPORT(SCSIID, setup->scsiid << 4);
+	shost->this_id = setup->scsiid;
+
+	if (setup->reconnect)
+		shost->can_queue = AHA152X_MAXQUEUE;
+
+	/* RESET OUT */
+	printk("aha152x: resetting bus...\n");
+	SETPORT(SCSISEQ, SCSIRSTO);
+	mdelay(256);
+	SETPORT(SCSISEQ, 0);
+	mdelay(DELAY);
+
+	reset_ports(shost);
+
+	printk(KERN_INFO
+	       "aha152x%d%s: "
+	       "vital data: rev=%x, "
+	       "io=0x%03lx (0x%03lx/0x%03lx), "
+	       "irq=%d, "
+	       "scsiid=%d, "
+	       "reconnect=%s, "
+	       "parity=%s, "
+	       "synchronous=%s, "
+	       "delay=%d, "
+	       "extended translation=%s\n",
+	       shost->host_no, setup->tc1550 ? " (tc1550 mode)" : "",
+	       GETPORT(REV) & 0x7,
+	       shost->io_port, aha->io_port0, aha->io_port1,
+	       shost->irq,
+	       shost->this_id,
+	       aha->reconnect ? "enabled" : "disabled",
+	       aha->parity ? "enabled" : "disabled",
+	       aha->synchronous ? "enabled" : "disabled",
+	       aha->delay,
+	       aha->ext_trans ? "enabled" : "disabled");
+
+	if (!request_region(shost->io_port, IO_RANGE, "aha152x"))
+		goto out_unregister;
+
+	/* not expecting any interrupts */
+	SETPORT(SIMODE0, 0);
+	SETPORT(SIMODE1, 0);
+
+	if (request_irq(shost->irq, swintr, SA_INTERRUPT|SA_SHIRQ,
+			"aha152x", shost) < 0) {
+		printk(KERN_ERR "aha152x%d: driver needs an IRQ.\n", shost->host_no);
+		goto out_release_region;
+	}
+
+	aha->swint = 0;
+
+	printk(KERN_INFO "aha152x%d: trying software interrupt, ",
+			 shost->host_no);
+	SETPORT(DMACNTRL0, SWINT|INTEN);
+	mdelay(1000);
+	free_irq(shost->irq, shost);
+
+	if (!aha->swint) {
+		if (TESTHI(DMASTAT, INTSTAT)) {
+			printk("lost.\n");
+		} else {
+			printk("failed.\n");
+		}
+
+		SETPORT(DMACNTRL0, INTEN);
+
+		printk(KERN_ERR "aha152x%d: IRQ %d possibly wrong.  "
+				"Please verify.\n", shost->host_no, shost->irq);
+		goto out_release_region;
+	}
+	printk("ok.\n");
+
+
+	/* clear interrupts */
+	SETPORT(SSTAT0, 0x7f);
+	SETPORT(SSTAT1, 0xef);
+
+	if (request_irq(shost->irq, intr, SA_INTERRUPT|SA_SHIRQ,
+				"aha152x", shost) < 0) {
+		printk(KERN_ERR "aha152x%d: failed to reassign interrupt.\n",
+				shost->host_no);
+		goto out_release_region;
+	}
+
+	aha152x_host[registered_count] = shost;
+	return shost;	/* the pcmcia stub needs the return value; */
+
+out_release_region:
+	release_region(shost->io_port, IO_RANGE);
+out_unregister:
+	scsi_unregister(shost);
+	return NULL;
+}
+
+static int aha152x_detect(Scsi_Host_Template * tpnt)
 {
 	int i, j, ok;
 #if defined(AUTOCONF)
@@ -979,10 +1098,6 @@
 	struct pnp_dev *dev = NULL;
 #endif
 #endif
-	tpnt->proc_name = "aha152x"; 
-
-	for (i = 0; i < ARRAY_SIZE(aha152x_host); i++)
-		aha152x_host[i] = (struct Scsi_Host *) NULL;
 
 	if (setup_count) {
 		printk(KERN_INFO "aha152x: processing commandline: ");
@@ -1231,185 +1346,16 @@
 	printk("detected %d controller(s)\n", setup_count);
 
 	for (i=0; i<setup_count; i++) {
-		struct Scsi_Host *shpnt;
-
-		aha152x_host[registered_count] = shpnt =
-		    scsi_register(tpnt, sizeof(struct aha152x_hostdata));
-
-		if(!shpnt) {
-			printk(KERN_ERR "aha152x: scsi_register failed\n");
-			continue;
-		}
-
-		registered_count++;
-
-		shpnt->io_port   = setup[i].io_port;
-		shpnt->n_io_port = IO_RANGE;
-		shpnt->irq       = setup[i].irq;
-
-		if(!setup[i].tc1550) {
-			HOSTIOPORT0 = setup[i].io_port;
-			HOSTIOPORT1 = setup[i].io_port;
-		} else {
-			HOSTIOPORT0 = setup[i].io_port+0x10;
-			HOSTIOPORT1 = setup[i].io_port-0x10;
-		}
-
-		ISSUE_SC	= 0;
-		CURRENT_SC	= 0;
-		DONE_SC		= 0;
-		DISCONNECTED_SC	= 0;
-
-		QLOCK		= SPIN_LOCK_UNLOCKED;
-
-		STATE		= 0;
-		PREVSTATE	= 0;
-		LASTSTATE	= 0;
-
-		MSGILEN		= 0;
-		MSGOLEN		= 0;
-
-		RECONNECT	= setup[i].reconnect;
-		SYNCHRONOUS	= setup[i].synchronous;
-		PARITY		= setup[i].parity;
-		DELAY		= setup[i].delay;
-		EXT_TRANS	= setup[i].ext_trans;
-#if defined(AHA152X_DEBUG)
-		HOSTDATA(shpnt)->debug = setup[i].debug;
-#endif
-		HOSTDATA(shpnt)->in_intr = 0;
-		HOSTDATA(shpnt)->commands = 0;
-
-#if defined(AHA152X_STAT)
-		HOSTDATA(shpnt)->total_commands=0;
-		HOSTDATA(shpnt)->disconnections=0;
-		HOSTDATA(shpnt)->busfree_without_any_action=0;
-		HOSTDATA(shpnt)->busfree_without_old_command=0;
-		HOSTDATA(shpnt)->busfree_without_new_command=0;
-		HOSTDATA(shpnt)->busfree_without_done_command=0;
-		HOSTDATA(shpnt)->busfree_with_check_condition=0;
-		for (j = idle; j<maxstate; j++) {
-			HOSTDATA(shpnt)->count[j]=0;
-			HOSTDATA(shpnt)->count_trans[j]=0;
-			HOSTDATA(shpnt)->time[j]=0;
-		}
-#endif
-
-		for (j = 0; j < 8; j++) {
-			HOSTDATA(shpnt)->syncrate[j] = 0;
-			HOSTDATA(shpnt)->syncneg[j] = 0;
-		}
-
-		SETPORT(SCSIID, setup[i].scsiid << 4);
-		shpnt->this_id = setup[i].scsiid;
-
-		if (setup[i].reconnect)
-			shpnt->can_queue = AHA152X_MAXQUEUE;
-
-		/* RESET OUT */
-		printk("aha152x: resetting bus...\n");
-		SETPORT(SCSISEQ, SCSIRSTO);
-		mdelay(256);
-		SETPORT(SCSISEQ, 0);
-		mdelay(DELAY);
-
-		reset_ports(shpnt);
-
-		printk(KERN_INFO
-		       "aha152x%d%s: "
-		       "vital data: rev=%x, "
-		       "io=0x%03lx (0x%03lx/0x%03lx), "
-		       "irq=%d, "
-		       "scsiid=%d, "
-		       "reconnect=%s, "
-		       "parity=%s, "
-		       "synchronous=%s, "
-		       "delay=%d, "
-		       "extended translation=%s\n",
-		       HOSTNO, setup[i].tc1550 ? " (tc1550 mode)" : "",
-		       GETPORT(REV) & 0x7,
-		       shpnt->io_port, HOSTIOPORT0, HOSTIOPORT1,
-		       shpnt->irq,
-		       shpnt->this_id,
-		       RECONNECT ? "enabled" : "disabled",
-		       PARITY ? "enabled" : "disabled",
-		       SYNCHRONOUS ? "enabled" : "disabled",
-		       DELAY,
-		       EXT_TRANS ? "enabled" : "disabled");
-
-		request_region(shpnt->io_port, IO_RANGE, "aha152x");
-
-		/* not expecting any interrupts */
-		SETPORT(SIMODE0, 0);
-		SETPORT(SIMODE1, 0);
-
-		ok = request_irq(shpnt->irq, swintr, SA_INTERRUPT|SA_SHIRQ, "aha152x", shpnt);
-		if (ok < 0) {
-			if (ok==-EINVAL)
-				printk(KERN_ERR "aha152x%d: bad IRQ %d.\n", HOSTNO, shpnt->irq);
-			else if(ok==-EBUSY)
-				printk(KERN_ERR "aha152x%d: IRQ %d already in use.\n", HOSTNO, shpnt->irq);
-			else
-				printk(KERN_ERR "aha152x%d: Unexpected error code %d on requesting IRQ %d.\n", HOSTNO, ok, shpnt->irq);
-
-			printk(KERN_ERR "aha152x%d: driver needs an IRQ.\n", HOSTNO);
-
-			scsi_unregister(shpnt);
-			registered_count--;
-			release_region(shpnt->io_port, IO_RANGE);
-			aha152x_host[registered_count] = 0;
-			shpnt = 0;
-			continue;
-		}
-		HOSTDATA(shpnt)->swint = 0;
-
-		printk(KERN_INFO "aha152x%d: trying software interrupt, ", HOSTNO);
-		SETPORT(DMACNTRL0, SWINT|INTEN);
-		mdelay(1000);
-		free_irq(shpnt->irq, shpnt);
-
-		if (!HOSTDATA(shpnt)->swint) {
-			if (TESTHI(DMASTAT, INTSTAT)) {
-				printk("lost.\n");
-			} else {
-				printk("failed.\n");
-			}
-
-			SETPORT(DMACNTRL0, INTEN);
-
-			printk(KERN_ERR "aha152x%d: IRQ %d possibly wrong.  Please verify.\n", HOSTNO, shpnt->irq);
-
-			registered_count--;
-			release_region(shpnt->io_port, IO_RANGE);
-			aha152x_host[registered_count] = 0;
-			scsi_unregister(shpnt);
-			shpnt=NULL;
-			continue;
-		}
-		printk("ok.\n");
-
-
-		/* clear interrupts */
-		SETPORT(SSTAT0, 0x7f);
-		SETPORT(SSTAT1, 0xef);
-
-		if (request_irq(shpnt->irq, intr, SA_INTERRUPT|SA_SHIRQ, "aha152x", shpnt) < 0) {
-			printk(KERN_ERR "aha152x%d: failed to reassign interrupt.\n", HOSTNO);
-
-			registered_count--;
-			release_region(shpnt->io_port, IO_RANGE);
-			aha152x_host[registered_count] = 0;
-			scsi_unregister(shpnt);
-			shpnt=NULL;
-			continue;
-		}
+		aha152x_probe_one(&setup[i]);
+		if (aha152x_host[registered_count])
+			registered_count++;
 	}
 
 	return registered_count>0;
 }
 
 
-int aha152x_release(struct Scsi_Host *shpnt)
+static int aha152x_release(struct Scsi_Host *shpnt)
 {
 	if (shpnt->irq)
 		free_irq(shpnt->irq, shpnt);
@@ -1471,7 +1417,7 @@
 /* 
  *  Queue a command and setup interrupts for a free bus.
  */
-int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct semaphore *sem, int phase, Scsi_Cmnd *done_SC, void (*done)(Scsi_Cmnd *))
+static int aha152x_internal_queue(Scsi_Cmnd *SCpnt, struct semaphore *sem, int phase, Scsi_Cmnd *done_SC, void (*done)(Scsi_Cmnd *))
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
@@ -1540,7 +1486,7 @@
 	return 0;
 }
 
-int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
+static int aha152x_queue(Scsi_Cmnd *SCpnt, void (*done)(Scsi_Cmnd *))
 {
 #if 0
 	if(*SCpnt->cmnd == REQUEST_SENSE) {
@@ -1559,7 +1505,7 @@
  *  run a command
  *
  */
-void internal_done(Scsi_Cmnd *SCpnt)
+static void internal_done(Scsi_Cmnd *SCpnt)
 {
 #if 0
 	struct Scsi_Host *shpnt = SCpnt->host;
@@ -1570,7 +1516,7 @@
 		up(SCSEM(SCpnt));
 }
 
-int aha152x_command(Scsi_Cmnd * SCpnt)
+static int aha152x_command(Scsi_Cmnd * SCpnt)
 {
 	DECLARE_MUTEX_LOCKED(sem);
 
@@ -1584,7 +1530,7 @@
  *  Abort a command
  *
  */
-int aha152x_abort(Scsi_Cmnd *SCpnt)
+static int aha152x_abort(Scsi_Cmnd *SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	Scsi_Cmnd *ptr;
@@ -1658,7 +1604,7 @@
  * FIXME: never seen this live. might lockup...
  *
  */
-int aha152x_device_reset(Scsi_Cmnd * SCpnt)
+static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	DECLARE_MUTEX_LOCKED(sem);
@@ -1716,7 +1662,7 @@
 	return ret;
 }
 
-void free_hard_reset_SCs(struct Scsi_Host *shpnt, Scsi_Cmnd **SCs)
+static void free_hard_reset_SCs(struct Scsi_Host *shpnt, Scsi_Cmnd **SCs)
 {
 	Scsi_Cmnd *ptr;
 	unsigned long flags;
@@ -1745,7 +1691,7 @@
  * Reset the bus
  *
  */
-int aha152x_bus_reset(Scsi_Cmnd *SCpnt)
+static int aha152x_bus_reset(Scsi_Cmnd *SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
 	unsigned long flags;
@@ -1840,7 +1786,7 @@
  * Return the "logical geometry"
  *
  */
-int aha152x_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+static int aha152x_biosparam(struct scsi_device *sdev, struct block_device *bdev,
 		sector_t capacity, int *info_array)
 {
 	struct Scsi_Host *shpnt = sdev->host;
@@ -3741,7 +3687,7 @@
 	return (pos - start);
 }
 
-int aha152x_set_info(char *buffer, int length, struct Scsi_Host *shpnt)
+static int aha152x_set_info(char *buffer, int length, struct Scsi_Host *shpnt)
 {
 	if(!shpnt || !buffer || length<8 || strncmp("aha152x ", buffer, 8)!=0)
 		return -EINVAL;
@@ -3788,7 +3734,7 @@
 #define SPRINTF(args...) \
 	do { if(pos < buffer + length) pos += sprintf(pos, ## args); } while(0)
 
-int aha152x_proc_info(char *buffer, char **start,
+static int aha152x_proc_info(char *buffer, char **start,
 		      off_t offset, int length, int hostno, int inout)
 {
 	int i;
@@ -3932,7 +3878,7 @@
 	return thislength < length ? thislength : length;
 }
 
-Scsi_Host_Template aha152x_driver_template = {
+static Scsi_Host_Template aha152x_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= AHA152X_REVID,
 	.proc_name		= "aha152x",
@@ -3954,6 +3900,6 @@
 };
 
 #ifndef PCMCIA
-#define driver_templace aha152x_driver_template
+#define driver_template aha152x_driver_template
 #include "scsi_module.c"
 #endif
===== drivers/scsi/aha152x.h 1.10 vs edited =====
--- 1.10/drivers/scsi/aha152x.h	Mon Mar 17 10:43:45 2003
+++ edited/drivers/scsi/aha152x.h	Thu Mar 27 13:03:59 2003
@@ -313,4 +313,24 @@
 };
 #endif
 
+/* for the pcmcia stub */
+struct aha152x_setup {
+	int io_port;
+	int irq;
+	int scsiid;
+	int reconnect;
+	int parity;
+	int synchronous;
+	int delay;
+	int ext_trans;
+	int tc1550;
+#if defined(AHA152X_DEBUG)
+	int debug;
+#endif
+	char *conf;
+};
+
+struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *);
+int aha152x_host_reset(struct scsi_cmnd *);
+
 #endif /* _AHA152X_H */
===== drivers/scsi/pcmcia/aha152x_stub.c 1.12 vs edited =====
--- 1.12/drivers/scsi/pcmcia/aha152x_stub.c	Sun Feb 16 08:23:48 2003
+++ edited/drivers/scsi/pcmcia/aha152x_stub.c	Thu Mar 27 15:01:39 2003
@@ -49,6 +49,7 @@
 
 #include "scsi.h"
 #include "hosts.h"
+#include "aha152x.h"
 
 #include <pcmcia/version.h>
 #include <pcmcia/cs_types.h>
@@ -102,8 +103,6 @@
     dev_node_t		node[8];
 } scsi_info_t;
 
-extern void aha152x_setup(char *str, int *ints);
-
 static void aha152x_release_cs(u_long arg);
 static int aha152x_event(event_t event, int priority,
 			 event_callback_args_t *args);
@@ -111,11 +110,7 @@
 static dev_link_t *aha152x_attach(void);
 static void aha152x_detach(dev_link_t *);
 
-#define driver_template aha152x_driver_template
-extern Scsi_Host_Template aha152x_driver_template;
-
-static dev_link_t *dev_list = NULL;
-
+static dev_link_t *dev_list;
 static dev_info_t dev_info = "aha152x_cs";
 
 /*====================================================================*/
@@ -227,11 +222,12 @@
 {
     client_handle_t handle = link->handle;
     scsi_info_t *info = link->priv;
+    struct aha152x_setup s;
     tuple_t tuple;
     cisparse_t parse;
-    int i, last_ret, last_fn, ints[8];
+    int i, last_ret, last_fn;
     u_char tuple_data[64];
-    Scsi_Device *dev;
+    struct scsi_device *dev;
     dev_node_t *node, **tail;
     struct Scsi_Host *host;
     
@@ -247,7 +243,6 @@
     link->conf.ConfigBase = parse.config.base;
 
     /* Configure card */
-    driver_template.module = &__this_module;
     link->state |= DEV_CONFIG;
 
     tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
@@ -276,29 +271,32 @@
     
     /* A bad hack... */
     release_region(link->io.BasePort1, link->io.NumPorts1);
-    
+
     /* Set configuration options for the aha152x driver */
-    ints[0] = 7;
-    ints[1] = link->io.BasePort1;
-    ints[2] = link->irq.AssignedIRQ;
-    ints[3] = host_id;
-    ints[4] = reconnect;
-    ints[5] = parity;
-    ints[6] = synchronous;
-    ints[7] = reset_delay;
-    if (ext_trans) {
-	ints[8] = ext_trans; ints[0] = 8;
-    }
-    aha152x_setup("PCMCIA setup", ints);
-    
-    scsi_register_host(&driver_template);
+    memset(&s, 0, sizeof(s));
+    s.conf        = "PCMCIA setup";
+    s.io_port     = link->io.BasePort1;
+    s.irq         = link->irq.AssignedIRQ;
+    s.scsiid      = host_id;
+    s.reconnect   = reconnect;
+    s.parity      = parity;
+    s.synchronous = synchronous;
+    s.delay       = reset_delay;
+    if (ext_trans)
+        s.ext_trans = ext_trans;
 
     tail = &link->dev;
     info->ndev = 0;
-    for (host = scsi_host_get_next(NULL); host;
-	 host = scsi_host_get_next(host))
-	if (host->hostt == &driver_template)
-	    list_for_each_entry (dev, &host->my_devices, siblings) {
+
+    host = aha152x_probe_one(&s);
+    if (host == NULL) {
+	printk(KERN_INFO "aha152x_cs: no SCSI devices found\n");
+	goto cs_failed;
+    }
+
+    scsi_add_host(host, NULL);
+
+    list_for_each_entry(dev, &host->my_devices, siblings) {
 	    u_long arg[2], id;
 	    kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
 	    id = (arg[0]&0x0f) + ((arg[0]>>4)&0xf0) +
@@ -328,11 +326,9 @@
 	    *tail = node; tail = &node->next;
 	    info->ndev++;
 	    info->host = dev->host;
-	}
+    }
+
     *tail = NULL;
-    if (info->ndev == 0)
-	printk(KERN_INFO "aha152x_cs: no SCSI devices found\n");
-    
     link->state &= ~DEV_CONFIG_PENDING;
     return;
     
@@ -340,41 +336,26 @@
     cs_error(link->handle, last_fn, last_ret);
     aha152x_release_cs((u_long)link);
     return;
-    
-} /* aha152x_config_cs */
-
-/*====================================================================*/
+}
 
 static void aha152x_release_cs(u_long arg)
 {
-    dev_link_t *link = (dev_link_t *)arg;
-
-    DEBUG(0, "aha152x_release_cs(0x%p)\n", link);
+	dev_link_t *link = (dev_link_t *)arg;
+	scsi_info_t *info = link->priv;
 
-#warning This does not protect you.  You need some real fix for your races.
-#if 0
-    if (GET_USE_COUNT(driver_template.module) != 0) {
-	DEBUG(1, "aha152x_cs: release postponed, "
-	      "device still open\n");
-	link->state |= DEV_STALE_CONFIG;
-	return;
-    }
-#endif
-
-    scsi_unregister_host(&driver_template);
-    link->dev = NULL;
+	scsi_remove_host(info->host);
+	link->dev = NULL;
     
-    CardServices(ReleaseConfiguration, link->handle);
-    CardServices(ReleaseIO, link->handle, &link->io);
-    CardServices(ReleaseIRQ, link->handle, &link->irq);
-    
-    link->state &= ~DEV_CONFIG;
-    if (link->state & DEV_STALE_LINK)
-	aha152x_detach(link);
+	CardServices(ReleaseConfiguration, link->handle);
+	CardServices(ReleaseIO, link->handle, &link->io);
+	CardServices(ReleaseIRQ, link->handle, &link->irq);
     
-} /* aha152x_release_cs */
+	link->state &= ~DEV_CONFIG;
+	scsi_unregister(info->host);
 
-/*====================================================================*/
+	if (link->state & DEV_STALE_LINK)
+		aha152x_detach(link);
+}
 
 static int aha152x_event(event_t event, int priority,
 			 event_callback_args_t *args)
@@ -414,28 +395,29 @@
 	break;
     }
     return 0;
-} /* aha152x_event */
+}
 
-/*====================================================================*/
+static struct pcmcia_driver aha152x_cs_driver = {
+	.owner		= THIS_MODULE,
+	.drv		= {
+		.name	= "aha152x_cs",
+	},
+	.attach		= aha152x_attach,
+	.detach		= aha152x_detach,
+};
 
-static int __init init_aha152x_cs(void) {
-    servinfo_t serv;
-    DEBUG(0, "%s\n", version);
-    CardServices(GetCardServicesInfo, &serv);
-    if (serv.Revision != CS_RELEASE_CODE) {
-	printk(KERN_NOTICE "aha152x_cs: Card Services release "
-	       "does not match!\n");
-	return -1;
-    }
-    register_pccard_driver(&dev_info, &aha152x_attach, &aha152x_detach);
-    return 0;
+static int __init init_aha152x_cs(void)
+{
+	return pcmcia_register_driver(&aha152x_cs_driver);
 }
 
-static void __exit exit_aha152x_cs(void) {
-    DEBUG(0, "aha152x_cs: unloading\n");
-    unregister_pccard_driver(&dev_info);
-    while (dev_list != NULL)
-	aha152x_detach(dev_list);
+static void __exit exit_aha152x_cs(void)
+{
+	pcmcia_unregister_driver(&aha152x_cs_driver);
+
+	/* XXX: this really needs to move into generic code.. */
+	while (dev_list != NULL)
+		aha152x_detach(dev_list);
 }
 
 module_init(init_aha152x_cs);
