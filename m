From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update qlogic pcmcia support
Date: Thu, 27 Feb 2003 17:54:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030227175404.C16092@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

dito


--- 1.17/drivers/scsi/qlogicfas.c	Tue Feb  4 10:41:00 2003
+++ edited/drivers/scsi/qlogicfas.c	Thu Feb 27 17:13:04 2003
@@ -127,11 +127,6 @@
 #endif
 
 #include <linux/module.h>
-
-#ifdef PCMCIA
-#undef MODULE
-#endif
-
 #include <linux/blk.h>		/* to get disk capacity */
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -148,7 +143,6 @@
 
 #include "scsi.h"
 #include "hosts.h"
-#include "qlogicfas.h"
 
 /*----------------------------------------------------------------*/
 /* driver state info, local to driver */
@@ -166,6 +160,8 @@
 static int qlcfg9 = ((XTALFREQ + 4) / 5);
 static int qlcfgc = (FASTCLK << 3) | (FASTSCSI << 4);
 
+int qlogicfas_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *));
+
 /*----------------------------------------------------------------*/
 /* The qlogic card uses two register maps - These macros select which one */
 #define REG0 ( outb( inb( qbase + 0xd ) & 0x7f , qbase + 0xd ), outb( 4 , qbase + 0xd ))
@@ -631,14 +627,12 @@
  *	Look for qlogic card and init if found 
  */
  
-int __devinit qlogicfas_detect(Scsi_Host_Template * host)
+struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *host)
 {
 	int i, j;		/* these are only used by IRQ detect */
 	int qltyp;		/* type of chip */
 	struct Scsi_Host *hreg;	/* registered host structure */
 
-	host->proc_name = "qlogicfas";
-
 	/*	Qlogic Cards only exist at 0x230 or 0x330 (the chip itself
 	 *	decodes the address - I check 230 first since MIDI cards are
 	 *	typically at 0x330
@@ -659,7 +653,7 @@
 			release_region(qbase, 0x10);
 		}
 		if (qbase == 0x430)
-			return 0;
+			return NULL;;
 	} else
 		printk(KERN_INFO "Ql: Using preset base address of %03x\n", qbase);
 
@@ -726,16 +720,21 @@
 		qltyp, qbase, qlirq, QL_TURBO_PDMA);
 	host->name = qinfo;
 
-	return 1;
+	return hreg;
 
 err_release_mem:
 	release_region(qbase, 0x10);
 	if (host->can_queue)
 		free_irq(qlirq, do_ql_ihandl);
-	return 0;
+	return NULL;;
 
 }
 
+int __devinit qlogicfas_detect(Scsi_Host_Template *sht)
+{
+	return (__qlogicfas_detect(sht) != NULL);
+}
+
 /* 
  *	Return bios parameters 
  */
@@ -777,7 +776,7 @@
  *	the PCMCIA qlogic_stub code. This wants fixing
  */
 
-static int qlogicfas_bus_reset(Scsi_Cmnd * cmd)
+int qlogicfas_bus_reset(Scsi_Cmnd * cmd)
 {
 	qabort = 2;
 	ql_zap();
@@ -818,9 +817,27 @@
 /*
  *	The driver template is also needed for PCMCIA
  */
- 
-Scsi_Host_Template qlogicfas_driver_template = QLOGICFAS;
-#define driver_template qlogicfas_driver_template
+Scsi_Host_Template qlogicfas_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= "qlogicfas",
+	.proc_name		= "qlogicfas",
+	.detect			= qlogicfas_detect,
+	.info			= qlogicfas_info,
+	.command		= qlogicfas_command,
+	.queuecommand		= qlogicfas_queuecommand,
+	.eh_abort_handler	= qlogicfas_abort,
+	.eh_bus_reset_handler	= qlogicfas_bus_reset,
+	.eh_device_reset_handler= qlogicfas_device_reset,
+	.eh_host_reset_handler	= qlogicfas_host_reset,
+	.bios_param		= qlogicfas_biosparam,
+	.can_queue		= 0,
+	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 1,
+	.use_clustering		= DISABLE_CLUSTERING,
+};
 
+#ifndef PCMCIA
+#define driver_template qlogicfas_driver_template
 #include "scsi_module.c"
-
+#endif
--- 1.7/drivers/scsi/qlogicfas.h	Tue Dec 10 21:28:33 2002
+++ edited/drivers/scsi/qlogicfas.h	Thu Feb 27 16:41:33 2003
@@ -1,34 +0,0 @@
-#ifndef _QLOGICFAS_H
-#define _QLOGICFAS_H
-
-static int qlogicfas_detect(Scsi_Host_Template * );
-static const char * qlogicfas_info(struct Scsi_Host *);
-static int qlogicfas_command(Scsi_Cmnd *);
-static int qlogicfas_queuecommand(Scsi_Cmnd *, void (* done)(Scsi_Cmnd *));
-static int qlogicfas_abort(Scsi_Cmnd *);
-static int qlogicfas_bus_reset(Scsi_Cmnd *);
-static int qlogicfas_device_reset(Scsi_Cmnd *);
-static int qlogicfas_host_reset(Scsi_Cmnd *);
-static int qlogicfas_biosparam(struct scsi_device *, struct block_device *,
-			       sector_t, int[]);
-
-#define QLOGICFAS {						\
-	.detect         		= qlogicfas_detect,	\
-	.info           		= qlogicfas_info,		\
-	.command     			= qlogicfas_command, 	\
-	.queuecommand			= qlogicfas_queuecommand,	\
-	.eh_abort_handler          	= qlogicfas_abort,	\
-	.eh_bus_reset_handler		= qlogicfas_bus_reset,	\
-	.eh_device_reset_handler        = qlogicfas_device_reset,	\
-	.eh_host_reset_handler          = qlogicfas_host_reset,	\
-	.bios_param     = qlogicfas_biosparam,			\
-	.can_queue      = 0,					\
-	.this_id        = -1,					\
-	.sg_tablesize   = SG_ALL,					\
-	.cmd_per_lun    = 1,					\
-	.use_clustering = DISABLE_CLUSTERING			\
-}
-#endif /* _QLOGICFAS_H */
-
-
-
--- 1.11/drivers/scsi/pcmcia/qlogic_stub.c	Tue Feb  4 08:47:00 2003
+++ edited/drivers/scsi/pcmcia/qlogic_stub.c	Thu Feb 27 17:12:48 2003
@@ -55,7 +55,11 @@
 #include <pcmcia/ds.h>
 #include <pcmcia/ciscode.h>
 
+
+extern Scsi_Host_Template qlogicfas_driver_template;
 extern void qlogicfas_preset(int port, int irq);
+extern struct Scsi_Host *__qlogicfas_detect(Scsi_Host_Template *);
+extern int qlogicfas_bus_reset(Scsi_Cmnd *);
 
 #ifdef PCMCIA_DEBUG
 static int pc_debug = PCMCIA_DEBUG;
@@ -81,6 +85,7 @@
 
 typedef struct scsi_info_t {
 	dev_link_t link;
+	struct Scsi_Host *host;
 	unsigned short manf_id;
 	int ndev;
 	dev_node_t node[8];
@@ -92,9 +97,6 @@
 static dev_link_t *qlogic_attach(void);
 static void qlogic_detach(dev_link_t *);
 
-/* Import our driver template */
-extern Scsi_Host_Template qlogicfas_driver_template;
-#define driver_template qlogicfas_driver_template
 
 static dev_link_t *dev_list = NULL;
 
@@ -233,7 +235,6 @@
 		info->manf_id = le16_to_cpu(tuple.TupleData[0]);
 
 	/* Configure card */
-	driver_template.module = &__this_module;
 	link->state |= DEV_CONFIG;
 
 	tuple.DesiredTuple = CISTPL_CFTABLE_ENTRY;
@@ -272,46 +273,52 @@
 	else
 		qlogicfas_preset(link->io.BasePort1, link->irq.AssignedIRQ);
 
-	scsi_register_host(&driver_template);
-
 	tail = &link->dev;
 	info->ndev = 0;
-	for (host = scsi_host_get_next(NULL); host; host = scsi_host_get_next(host))
-		if (host->hostt == &driver_template)
-			list_for_each_entry (dev, &host->my_devices, siblings) {
-				u_long arg[2], id;
-				kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
-				id = (arg[0] & 0x0f) + ((arg[0] >> 4) & 0xf0) + ((arg[0] >> 8) & 0xf00) + ((arg[0] >> 12) & 0xf000);
-				node = &info->node[info->ndev];
-				node->minor = 0;
-				switch (dev->type) {
-				case TYPE_TAPE:
-					node->major = SCSI_TAPE_MAJOR;
-					sprintf(node->dev_name, "st#%04lx", id);
-					break;
-				case TYPE_DISK:
-				case TYPE_MOD:
-					node->major = SCSI_DISK0_MAJOR;
-					sprintf(node->dev_name, "sd#%04lx", id);
-					break;
-				case TYPE_ROM:
-				case TYPE_WORM:
-					node->major = SCSI_CDROM_MAJOR;
-					sprintf(node->dev_name, "sr#%04lx", id);
-					break;
-				default:
-					node->major = SCSI_GENERIC_MAJOR;
-					sprintf(node->dev_name, "sg#%04lx", id);
-					break;
-				}
-				*tail = node;
-				tail = &node->next;
-				info->ndev++;
-			}
-	*tail = NULL;
-	if (info->ndev == 0)
+
+	host = __qlogicfas_detect(&qlogicfas_driver_template);
+	if (!host) {
 		printk(KERN_INFO "qlogic_cs: no SCSI devices found\n");
+		goto out;
+	}
+
+	scsi_add_host(host, NULL);
+
+	list_for_each_entry(dev, &host->my_devices, siblings) {
+		u_long arg[2], id;
+		kernel_scsi_ioctl(dev, SCSI_IOCTL_GET_IDLUN, arg);
+		id = (arg[0] & 0x0f) + ((arg[0] >> 4) & 0xf0) + ((arg[0] >> 8) & 0xf00) + ((arg[0] >> 12) & 0xf000);
+		node = &info->node[info->ndev];
+		node->minor = 0;
+		switch (dev->type) {
+		case TYPE_TAPE:
+			node->major = SCSI_TAPE_MAJOR;
+			sprintf(node->dev_name, "st#%04lx", id);
+			break;
+		case TYPE_DISK:
+		case TYPE_MOD:
+			node->major = SCSI_DISK0_MAJOR;
+			sprintf(node->dev_name, "sd#%04lx", id);
+			break;
+		case TYPE_ROM:
+		case TYPE_WORM:
+			node->major = SCSI_CDROM_MAJOR;
+			sprintf(node->dev_name, "sr#%04lx", id);
+			break;
+		default:
+			node->major = SCSI_GENERIC_MAJOR;
+			sprintf(node->dev_name, "sg#%04lx", id);
+			break;
+		}
+		*tail = node;
+		tail = &node->next;
+		info->ndev++;
+	}
 
+	*tail = NULL;
+	info->host = host;
+
+out:
 	link->state &= ~DEV_CONFIG_PENDING;
 	return;
 
@@ -327,29 +334,22 @@
 static void qlogic_release(u_long arg)
 {
 	dev_link_t *link = (dev_link_t *) arg;
+	scsi_info_t *info = link->priv;
 
 	DEBUG(0, "qlogic_release(0x%p)\n", link);
 
-#warning This does not protect you.  You need some real fix for your races.
-#if 0
-	if (GET_USE_COUNT(&__this_module) != 0) {
-		DEBUG(0, "qlogic_cs: release postponed, device still open\n");
-		link->state |= DEV_STALE_CONFIG;
-		return;
-	}
-#endif
-
-	scsi_unregister_host(&driver_template);
+	scsi_remove_host(info->host);
 	link->dev = NULL;
 
 	CardServices(ReleaseConfiguration, link->handle);
 	CardServices(ReleaseIO, link->handle, &link->io);
 	CardServices(ReleaseIRQ, link->handle, &link->irq);
 
+	scsi_unregister(info->host);
+
 	link->state &= ~DEV_CONFIG;
 	if (link->state & DEV_STALE_LINK)
 		qlogic_detach(link);
-
 }				/* qlogic_release */
 
 /*====================================================================*/
@@ -390,7 +390,7 @@
 				outb(0x04, link->io.BasePort1 + 0xd);
 			}
 			/* Ugggglllyyyy!!! */
-			driver_template.eh_bus_reset_handler(NULL);
+			qlogicfas_bus_reset(NULL);
 		}
 		break;
 	}
