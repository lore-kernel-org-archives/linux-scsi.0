From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update fdomain pcmcia support
Date: Thu, 27 Feb 2003 17:53:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030227175333.B16092@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

get it to actually compile cleanly again, switch to scsi_add_host,
remove host list walking.



--- 1.18/drivers/scsi/fdomain.c	Thu Feb 20 13:16:32 2003
+++ edited/drivers/scsi/fdomain.c	Thu Feb 27 17:39:04 2003
@@ -271,13 +271,8 @@
 
  **************************************************************************/
 
+#include <linux/config.h>
 #include <linux/module.h>
-
-#ifdef PCMCIA
-#undef MODULE
-#endif
-
-#include <linux/config.h>	/* for CONFIG_PCI */
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/blk.h>
@@ -295,9 +290,13 @@
 
 #include "scsi.h"
 #include "hosts.h"
-#include "fdomain.h"
+
+MODULE_AUTHOR("Rickard E. Faith");
+MODULE_DESCRIPTION("Future domain SCSI driver");
+MODULE_LICENSE("GPL");
+
   
-#define VERSION          "$Revision: 5.50 $"
+#define VERSION          "$Revision: 5.51 $"
 
 /* START OF USER DEFINABLE OPTIONS */
 
@@ -421,15 +420,12 @@
 
 static void              do_fdomain_16x0_intr( int irq, void *dev_id,
 					    struct pt_regs * regs );
+int		 	fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt);
 
-#ifdef MODULE
-				/* Allow insmod parameters to be like LILO
-                                   parameters.  For example:
-				   insmod fdomain fdomain=0x140,11
-				*/
+/* Allow insmod parameters to be like LILO parameters.  For example:
+   insmod fdomain fdomain=0x140,11 */
 static char * fdomain = NULL;
 MODULE_PARM(fdomain, "s");
-#endif
 
 static unsigned long addresses[] = {
    0xc8000,
@@ -561,7 +557,7 @@
    printk( "\n" );
 }
 
-static int __init fdomain_setup(char *str)
+int __init fdomain_setup(char *str)
 {
 	int ints[4];
 
@@ -862,7 +858,7 @@
 }
 #endif
 
-static int fdomain_16x0_detect( Scsi_Host_Template *tpnt )
+struct Scsi_Host *__fdomain_16x0_detect( Scsi_Host_Template *tpnt )
 {
    int              retcode;
    struct Scsi_Host *shpnt;
@@ -879,13 +875,6 @@
    unsigned char    buf[buflen];
 #endif
 
-   tpnt->proc_name = "fdomain";
-
-#ifdef MODULE
-	if (fdomain)
-		fdomain_setup(fdomain);
-#endif
-   
    if (setup_called) {
 #if DEBUG_DETECT
       printk( "scsi: <fdomain> No BIOS, using port_base = 0x%x, irq = %d\n",
@@ -895,7 +884,7 @@
 	 printk( "scsi: <fdomain> Cannot locate chip at port base 0x%x\n",
 		 port_base );
 	 printk( "scsi: <fdomain> Bad LILO/INSMOD parameters?\n" );
-	 return 0;
+	 return NULL;
       }
    } else {
       int flag = 0;
@@ -910,7 +899,7 @@
 
 	 if (!flag) {
 	    printk( "scsi: <fdomain> Detection failed (no card)\n" );
-	    return 0;
+	    return NULL;
 	 }
       }
    }
@@ -936,7 +925,7 @@
       if (setup_called) {
 	 printk(KERN_ERR "scsi: <fdomain> Bad LILO/INSMOD parameters?\n");
       }
-      return 0;
+      return NULL;
    }
 
    if (this_id) {
@@ -957,7 +946,7 @@
 
    shpnt = scsi_register( tpnt, 0 );
    if(shpnt == NULL)
-   	return 0;
+   	return NULL;
    shpnt->irq = interrupt_level;
    shpnt->io_port = port_base;
    scsi_set_device(shpnt, &pdev->dev);
@@ -967,7 +956,7 @@
    /* Log IRQ with kernel */   
    if (!interrupt_level) {
       printk(KERN_ERR "scsi: <fdomain> Card Detected, but driver not loaded (no IRQ)\n" );
-      return 0;
+      return NULL;
    } else {
       /* Register the IRQ with the kernel */
 
@@ -988,7 +977,7 @@
 	    printk(KERN_ERR "                Send mail to faith@acm.org\n" );
 	 }
 	 printk(KERN_ERR "scsi: <fdomain> Detected, but driver not loaded (IRQ)\n" );
-	 return 0;
+	 return NULL;
       }
    }
 
@@ -1048,7 +1037,14 @@
    }
 #endif
 
-   return 1;			/* Maximum of one adapter will be detected. */
+   return shpnt;
+}
+
+static int fdomain_16x0_detect( Scsi_Host_Template *tpnt )
+{
+	if (fdomain)
+		fdomain_setup(fdomain);
+	return (__fdomain_16x0_detect(tpnt) != NULL);
 }
 
 static const char *fdomain_16x0_info( struct Scsi_Host *ignore )
@@ -1150,8 +1146,9 @@
 {
    int           status;
    unsigned long timeout;
+#if ERRORS_ONLY
    static int    flag = 0;
-
+#endif
 
    outb( 0x82, SCSI_Cntl_port ); /* Bus Enable + Select */
    outb( adapter_mask | (1 << target), SCSI_Data_NoACK_port );
@@ -1574,6 +1571,7 @@
 
 /* End of code derived from Tommy Thorn's work. */
 
+#if DEBUG_ABORT
 static void print_info(Scsi_Cmnd *SCpnt)
 {
    unsigned int imr;
@@ -1643,6 +1641,7 @@
 	 printk( "Configuration 2  = 0x%02x\n",
 		 inb( port_base + Configuration2 ) );
 }
+#endif
 
 static int fdomain_16x0_abort( Scsi_Cmnd *SCpnt)
 {
@@ -1670,7 +1669,7 @@
    return SUCCESS;
 }
 
-static int fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt)
+int fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt)
 {
    outb( 1, SCSI_Cntl_port );
    do_pause( 2 );
@@ -1866,9 +1865,29 @@
 	return 0;
 }
 
-MODULE_LICENSE("GPL");
-
-/* Eventually this will go into an include file, but this will be later */
-static Scsi_Host_Template driver_template = FDOMAIN_16X0;
+Scsi_Host_Template fdomain_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "fdomain",
+	.proc_name		= "fdomain",
+	.proc_info		= fdomain_16x0_proc_info,
+	.detect			= fdomain_16x0_detect,
+	.info			= fdomain_16x0_info,
+	.command		= fdomain_16x0_command,
+	.queuecommand		= fdomain_16x0_queue,
+	.eh_abort_handler	= fdomain_16x0_abort,
+	.eh_bus_reset_handler	= fdomain_16x0_bus_reset,
+	.eh_device_reset_handler = fdomain_16x0_device_reset,
+	.eh_host_reset_handler	= fdomain_16x0_host_reset,
+	.bios_param		= fdomain_16x0_biosparam,
+	.release		= fdomain_16x0_release,
+	.can_queue		= 1,
+	.this_id		= 6,
+	.sg_tablesize		= 64,
+	.cmd_per_lun		= 1,
+	.use_clustering		= DISABLE_CLUSTERING,
+};
 
+#ifndef PCMCIA
+#define driver_template fdomain_driver_template
 #include "scsi_module.c"
+#endif
--- 1.6/drivers/scsi/fdomain.h	Tue Dec 10 21:28:33 2002
+++ edited/drivers/scsi/fdomain.h	Thu Feb 27 16:47:13 2003
@@ -1,59 +0,0 @@
-/* fdomain.h -- Header for Future Domain TMC-16x0 driver
- * Created: Sun May  3 18:47:33 1992 by faith@cs.unc.edu
- * Revised: Thu Oct 12 13:21:35 1995 by faith@acm.org
- * Author: Rickard E. Faith, faith@cs.unc.edu
- * Copyright 1992, 1993, 1994, 1995 Rickard E. Faith
- *
- * $Id: fdomain.h,v 5.12 1995/10/12 19:01:09 root Exp $
-
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
-
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
-
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 675 Mass Ave, Cambridge, MA 02139, USA.
-
- */
-
-#ifndef _FDOMAIN_H
-#define _FDOMAIN_H
-
-static int        fdomain_16x0_detect( Scsi_Host_Template *);
-static int        fdomain_16x0_command( Scsi_Cmnd *);
-static int        fdomain_16x0_abort(Scsi_Cmnd *);
-static const char *fdomain_16x0_info(struct Scsi_Host *);
-static int        fdomain_16x0_bus_reset(Scsi_Cmnd *); 
-static int        fdomain_16x0_host_reset(Scsi_Cmnd *); 
-static int        fdomain_16x0_device_reset(Scsi_Cmnd *); 
-static int        fdomain_16x0_queue(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int        fdomain_16x0_biosparam(struct scsi_device *,
-		struct block_device *, sector_t, int * );
-static int        fdomain_16x0_proc_info(char *buffer, char **start, off_t offset,
-				   int length, int hostno, int inout );
-static int        fdomain_16x0_release(struct Scsi_Host *shpnt);
-
-#define FDOMAIN_16X0 { .proc_info      		= fdomain_16x0_proc_info,           \
-		       .detect         		= fdomain_16x0_detect,              \
-		       .info           		= fdomain_16x0_info,                \
-		       .command        		= fdomain_16x0_command,             \
-		       .queuecommand   		= fdomain_16x0_queue,               \
-		       .eh_abort_handler	= fdomain_16x0_abort,               \
-		       .eh_bus_reset_handler	= fdomain_16x0_bus_reset,           \
-		       .eh_device_reset_handler	= fdomain_16x0_device_reset,        \
-		       .eh_host_reset_handler	= fdomain_16x0_host_reset,          \
-		       .bios_param		= fdomain_16x0_biosparam,           \
-		       .release			= fdomain_16x0_release,		  \
-		       .can_queue		= 1, 				  \
-		       .this_id  		= 6, 				  \
-		       .sg_tablesize		= 64, 				  \
-		       .cmd_per_lun		= 1, 				  \
-		       .use_clustering		= DISABLE_CLUSTERING		  \
-}
-#endif
--- 1.12/drivers/scsi/pcmcia/fdomain_stub.c	Tue Feb  4 21:12:27 2003
+++ edited/drivers/scsi/pcmcia/fdomain_stub.c	Thu Feb 27 17:35:58 2003
@@ -61,15 +61,15 @@
 MODULE_DESCRIPTION("Future Domain PCMCIA SCSI driver");
 MODULE_LICENSE("Dual MPL/GPL");
 
-#define INT_MODULE_PARM(n, v) static int n = v; MODULE_PARM(n, "i")
-
 /* Bit map of interrupts to choose from */
-INT_MODULE_PARM(irq_mask, 0xdeb8);
+static int irq_mask = 0xdeb8;
+MODULE_PARM(irq_mask, "i");
 static int irq_list[4] = { -1 };
 MODULE_PARM(irq_list, "1-4i");
 
 #ifdef PCMCIA_DEBUG
-INT_MODULE_PARM(pc_debug, PCMCIA_DEBUG);
+static int pc_debug = PCMCIA_DEBUG;
+MODULE_PARM(pc_debug, "i");
 #define DEBUG(n, args...) if (pc_debug>(n)) printk(KERN_DEBUG args)
 static char *version =
 "fdomain_cs.c 1.47 2001/10/13 00:08:52 (David Hinds)";
@@ -81,11 +81,15 @@
 
 typedef struct scsi_info_t {
     dev_link_t		link;
+    struct Scsi_Host	*host;
     int			ndev;
     dev_node_t		node[8];
 } scsi_info_t;
 
+extern Scsi_Host_Template fdomain_driver_template;
 extern void fdomain_setup(char *str, int *ints);
+extern struct Scsi_Host *__fdomain_16x0_detect( Scsi_Host_Template *tpnt );
+extern int fdomain_16x0_bus_reset(Scsi_Cmnd *SCpnt);
 
 static void fdomain_release(u_long arg);
 static int fdomain_event(event_t event, int priority,
@@ -94,8 +98,6 @@
 static dev_link_t *fdomain_attach(void);
 static void fdomain_detach(dev_link_t *);
 
-#define driver_template fdomain_driver_template
-extern Scsi_Host_Template fdomain_driver_template;
 
 static dev_link_t *dev_list = NULL;
 
@@ -231,7 +233,6 @@
     link->conf.ConfigBase = parse.config.base;
 
     /* Configure card */
-    driver_template.module = &__this_module;
     link->state |= DEV_CONFIG;
     
     tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
@@ -260,14 +261,18 @@
     sprintf(str, "%d,%d", link->io.BasePort1, link->irq.AssignedIRQ);
     fdomain_setup(str, ints);
     
-    scsi_register_host(&driver_template);
+    host = __fdomain_16x0_detect(&fdomain_driver_template);
+    if (!host) {
+        printk(KERN_INFO "fdomain_cs: no SCSI devices found\n");
+	goto cs_failed;
+    }
+ 
+    scsi_add_host(host, NULL);
 
     tail = &link->dev;
     info->ndev = 0;
-    for (host = scsi_host_get_next(NULL); host;
-	 host = scsi_host_get_next(host))
-	if (host->hostt == &driver_template)
-	    list_for_each_entry (dev, &host->my_devices, siblings) {
+   
+    list_for_each_entry (dev, &host->my_devices, siblings) {
 	    u_long arg[2], id;
 	    kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
 	    id = (arg[0]&0x0f) + ((arg[0]>>4)&0xf0) +
@@ -296,10 +301,11 @@
 	    }
 	    *tail = node; tail = &node->next;
 	    info->ndev++;
-	}
+
+    }
+
     *tail = NULL;
-    if (info->ndev == 0)
-	printk(KERN_INFO "fdomain_cs: no SCSI devices found\n");
+    info->host = host;
     
     link->state &= ~DEV_CONFIG_PENDING;
     return;
@@ -316,30 +322,22 @@
 static void fdomain_release(u_long arg)
 {
     dev_link_t *link = (dev_link_t *)arg;
+    scsi_info_t *info = link->priv;
 
     DEBUG(0, "fdomain_release(0x%p)\n", link);
 
-#warning This does not protect you.  You need some real fix for your races.
-#if 0
-    if (GET_USE_COUNT(&__this_module) != 0) {
-	DEBUG(1, "fdomain_cs: release postponed, "
-	      "device still open\n");
-	link->state |= DEV_STALE_CONFIG;
-	return;
-    }
-#endif
-
-    scsi_unregister_host(&driver_template);
+    scsi_remove_host(info->host);
     link->dev = NULL;
     
     CardServices(ReleaseConfiguration, link->handle);
     CardServices(ReleaseIO, link->handle, &link->io);
     CardServices(ReleaseIRQ, link->handle, &link->irq);
-    
+
+    scsi_unregister(info->host);
+
     link->state &= ~DEV_CONFIG;
     if (link->state & DEV_STALE_LINK)
 	fdomain_detach(link);
-    
 } /* fdomain_release */
 
 /*====================================================================*/
@@ -374,7 +372,7 @@
     case CS_EVENT_CARD_RESET:
 	if (link->state & DEV_CONFIG) {
 	    CardServices(RequestConfiguration, link->handle, &link->conf);
-	    fdomain_16x0_reset(NULL, 0);
+	    fdomain_16x0_bus_reset(NULL);
 	}
 	break;
     }
