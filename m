From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aha152x tidbits
Date: Mon, 17 Mar 2003 16:54:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030317165418.C29420@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

(1) fix the jiffies warnings
(2) remove the #undef MODULE braindamange for pcmcia
(3) make all methods static and move the template away from the header


--- 1.24/drivers/scsi/aha152x.c	Thu Feb 27 04:02:59 2003
+++ edited/drivers/scsi/aha152x.c	Mon Mar 17 16:08:45 2003
@@ -221,11 +221,6 @@
  *********************************************************************=
*****/
=20
 #include <linux/module.h>
-
-#if defined(PCMCIA)
-#undef MODULE
-#endif
-
 #include <linux/sched.h>
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -244,14 +239,16 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/isapnp.h>
-#include <asm/semaphore.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/blk.h>
+#include <asm/semaphore.h>
+#include <asm/io.h>
+#include <scsi/scsicam.h>
=20
+#include "scsi.h"
 #include "aha152x.h"
-#include <linux/stat.h>
-#include <linux/workqueue.h>
=20
-#include <scsi/scsicam.h>
=20
 /* DEFINES */
=20
@@ -338,11 +335,11 @@
 	resetting	=3D 0x0400,	/* BUS DEVICE RESET is pending */
 };
=20
-#if defined(MODULE)
 MODULE_AUTHOR("J=FCrgen Fischer");
 MODULE_DESCRIPTION(AHA152X_REVID);
 MODULE_LICENSE("GPL");
=20
+#if defined(MODULE) && !defined(PCMCIA)
 MODULE_PARM(io, "1-2i");
 MODULE_PARM_DESC(io,"base io address of controller");
 static int io[] =3D {0, 0};
@@ -396,6 +393,7 @@
 MODULE_PARM_DESC(aha152x1, "parameters for second controller");
 static int aha152x1[]  =3D {0, 11, 7, 1, 1, 1, DELAY_DEFAULT, 0, DEBUG=
_DEFAULT};
 #endif /* !defined(AHA152X_DEBUG) */
+#endif /* MODULE && !PCMCIA */
=20
 #ifdef __ISAPNP__
 static struct isapnp_device_id id_table[] __devinitdata =3D {
@@ -404,7 +402,6 @@
 };
 MODULE_DEVICE_TABLE(isapnp, id_table);
 #endif /* ISAPNP */
-#endif /* MODULE */
=20
 /* set by aha152x_setup according to the command line */
 static int setup_count =3D 0;
@@ -1040,7 +1037,7 @@
 	}
 #endif
=20
-#if defined(MODULE)
+#if defined(MODULE) && !defined(PCMCIA)
 	if (setup_count<ARRAY_SIZE(setup) && (aha152x[0]!=3D0 || io[0]!=3D0 |=
| irq[0]!=3D0)) {
 		if(aha152x[0]!=3D0) {
 			setup[setup_count].conf        =3D "";
@@ -2651,7 +2648,7 @@
=20
 static void datai_run(struct Scsi_Host *shpnt)
 {
-	unsigned int the_time;
+	unsigned long the_time;
 	int fifodata, data_count;
=20
 	/*
@@ -2793,7 +2790,7 @@
=20
 static void datao_run(struct Scsi_Host *shpnt)
 {
-	unsigned int the_time;
+	unsigned long the_time;
 	int data_count;
=20
 	/* until phase changes or all data sent */
@@ -3935,7 +3932,28 @@
 	return thislength < length ? thislength : length;
 }
=20
-/* Eventually this will go into an include file, but this will be late=
r */
-static Scsi_Host_Template driver_template =3D AHA152X;
+Scsi_Host_Template aha152x_driver_template =3D {
+	.module			=3D THIS_MODULE,
+	.name			=3D AHA152X_REVID,
+	.proc_name		=3D "aha152x",
+	.proc_info		=3D aha152x_proc_info,
+	.detect			=3D aha152x_detect,
+	.command		=3D aha152x_command,
+	.queuecommand		=3D aha152x_queue,
+	.eh_abort_handler	=3D aha152x_abort,
+	.eh_device_reset_handler =3D aha152x_device_reset,
+	.eh_bus_reset_handler	=3D aha152x_bus_reset,
+	.eh_host_reset_handler	=3D aha152x_host_reset,
+	.release		=3D aha152x_release,
+	.bios_param		=3D aha152x_biosparam,
+	.can_queue		=3D 1,
+	.this_id		=3D 7,
+	.sg_tablesize		=3D SG_ALL,
+	.cmd_per_lun		=3D 1,
+	.use_clustering		=3D DISABLE_CLUSTERING,
+};
=20
+#ifndef PCMCIA
+#define driver_templace aha152x_driver_template
 #include "scsi_module.c"
+#endif
=3D=3D=3D=3D=3D drivers/scsi/aha152x.h 1.9 vs edited =3D=3D=3D=3D=3D
--- 1.9/drivers/scsi/aha152x.h	Tue Dec 10 21:28:34 2002
+++ edited/drivers/scsi/aha152x.h	Mon Mar 17 15:43:45 2003
@@ -5,53 +5,11 @@
  * $Id: aha152x.h,v 2.5 2002/04/14 11:24:12 fischer Exp $
  */
=20
-#if defined(__KERNEL__)
-
-#include <linux/blk.h>
-#include "scsi.h"
-#include <asm/io.h>
-#include <linux/version.h>
-
-int aha152x_detect(Scsi_Host_Template *);
-int aha152x_command(Scsi_Cmnd *);
-int aha152x_queue(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-int aha152x_abort(Scsi_Cmnd *);
-int aha152x_release(struct Scsi_Host *shpnt);
-int aha152x_device_reset(Scsi_Cmnd *);
-int aha152x_bus_reset(Scsi_Cmnd *);
-int aha152x_host_reset(Scsi_Cmnd *);
-int aha152x_biosparam(struct scsi_device *, struct block_device *,
-		sector_t, int*);
-int aha152x_proc_info(char *buffer, char **start, off_t offset, int le=
ngth, int hostno, int inout);
-
 /* number of queueable commands
    (unless we support more than 1 cmd_per_lun this should do) */
 #define AHA152X_MAXQUEUE 7
=20
 #define AHA152X_REVID "Adaptec 152x SCSI driver; $Revision: 2.5 $"
-
-/* Initial value of Scsi_Host entry */
-#define AHA152X { .proc_name			=3D "aha152x",		\
-                  .proc_info			=3D aha152x_proc_info,	\
-                  .name				=3D AHA152X_REVID,		\
-                  .detect			=3D aha152x_detect,		\
-                  .command			=3D aha152x_command,	\
-                  .queuecommand			=3D aha152x_queue,		\
-		  .eh_abort_handler		=3D aha152x_abort,		\
-		  .eh_device_reset_handler	=3D aha152x_device_reset,	\
-		  .eh_bus_reset_handler		=3D aha152x_bus_reset,	\
-		  .eh_host_reset_handler	=3D aha152x_host_reset,	\
-                  .release			=3D aha152x_release,	\
-                  .bios_param			=3D aha152x_biosparam,	\
-                  .can_queue			=3D 1,			\
-                  .this_id			=3D 7,			\
-                  .sg_tablesize			=3D SG_ALL,			\
-                  .cmd_per_lun			=3D 1,			\
-                  .present			=3D 0,			\
-                  .unchecked_isa_dma		=3D 0,			\
-                  .use_clustering		=3D DISABLE_CLUSTERING }
-#endif
-
=20
 /* port addresses */
 #define SCSISEQ      (HOSTIOPORT0+0x00)    /* SCSI sequence control */
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
