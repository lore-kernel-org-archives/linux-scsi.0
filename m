From: aris@cathedrallabs.org (Aristeu Sergio Rozanski Filho)
Subject: [patch][3/3] qlogic_cs: use qlogicfas408 module
Date: Wed, 31 Mar 2004 10:08:12 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040331130812.GC28021@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/unnNtmY43mpUSKx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:54801 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261952AbUCaNJ5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Mar 2004 08:09:57 -0500
Received: from cathedrallabs.org (3-133.ctame701-3.telepar.net.br [200.181.174.133])
	by panda.sul.com.br (Postfix) with ESMTP id 04197327AE
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 10:10:22 -0300 (EST)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hi,
	this patch kills qlogic_core.c and I guess the same idea can be
	applied to other pcmcia scsi drivers. comments?

--
aris


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="03-qlogic_cs-use_qlogicfas408.patch"

diff -urNp -X dontdiff linux-2.6.4-applied/drivers/scsi/pcmcia/Makefile linux-2.6.4-work/drivers/scsi/pcmcia/Makefile
--- linux-2.6.4-applied/drivers/scsi/pcmcia/Makefile	2004-03-13 15:08:23.000000000 -0300
+++ linux-2.6.4-work/drivers/scsi/pcmcia/Makefile	2004-03-30 16:04:19.000000000 -0300
@@ -9,4 +9,4 @@ obj-$(CONFIG_PCMCIA_NINJA_SCSI)	+= nsp_c
 
 aha152x_cs-objs	:= aha152x_stub.o aha152x_core.o
 fdomain_cs-objs	:= fdomain_stub.o fdomain_core.o
-qlogic_cs-objs	:= qlogic_stub.o qlogic_core.o
+qlogic_cs-objs	:= qlogic_stub.o
diff -urNp -X dontdiff linux-2.6.4-applied/drivers/scsi/pcmcia/qlogic_core.c linux-2.6.4-work/drivers/scsi/pcmcia/qlogic_core.c
--- linux-2.6.4-applied/drivers/scsi/pcmcia/qlogic_core.c	2004-03-13 15:08:23.000000000 -0300
+++ linux-2.6.4-work/drivers/scsi/pcmcia/qlogic_core.c	1969-12-31 21:00:00.000000000 -0300
@@ -1,2 +0,0 @@
-#define PCMCIA 1
-#include "qlogicfas.c"
diff -urNp -X dontdiff linux-2.6.4-applied/drivers/scsi/pcmcia/qlogic_stub.c linux-2.6.4-work/drivers/scsi/pcmcia/qlogic_stub.c
--- linux-2.6.4-applied/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-13 15:10:48.000000000 -0300
+++ linux-2.6.4-work/drivers/scsi/pcmcia/qlogic_stub.c	2004-03-30 16:46:44.000000000 -0300
@@ -47,7 +47,7 @@
 
 #include "scsi.h"
 #include "hosts.h"
-#include "../qlogicfas.h"
+#include "../qlogicfas408.h"
 
 #include <pcmcia/version.h>
 #include <pcmcia/cs_types.h>
@@ -56,13 +56,13 @@
 #include <pcmcia/ds.h>
 #include <pcmcia/ciscode.h>
 
+/* Set the following to 2 to use normal interrupt (active high/totempole-
+ * tristate), otherwise use 0 (REQUIRED FOR PCMCIA) for active low, open
+ * drain
+ */
+#define INT_TYPE	0
 
-extern Scsi_Host_Template qlogicfas_driver_template;
-extern void qlogicfas_preset(int port, int irq);
-extern int qlogicfas_bus_reset(Scsi_Cmnd *);
-extern irqreturn_t do_ql_ihandl(int irq, void *dev_id, struct pt_regs *regs);
-
-static char *qlogic_name = "qlogic_cs";
+static char qlogic_name[] = "qlogic_cs";
 
 #ifdef PCMCIA_DEBUG
 static int pc_debug = PCMCIA_DEBUG;
@@ -73,6 +73,24 @@ static char *version = "qlogic_cs.c 1.79
 #define DEBUG(n, args...)
 #endif
 
+static Scsi_Host_Template qlogicfas_driver_template = {
+	.module			= THIS_MODULE,
+	.name			= qlogic_name,
+	.proc_name		= qlogic_name,
+	.info			= qlogicfas408_info,
+	.queuecommand		= qlogicfas408_queuecommand,
+	.eh_abort_handler	= qlogicfas408_abort,
+	.eh_bus_reset_handler	= qlogicfas408_bus_reset,
+	.eh_device_reset_handler= qlogicfas408_device_reset,
+	.eh_host_reset_handler	= qlogicfas408_host_reset,
+	.bios_param		= qlogicfas408_biosparam,
+	.can_queue		= 1,
+	.this_id		= -1,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 1,
+	.use_clustering		= DISABLE_CLUSTERING,
+};
+
 /*====================================================================*/
 
 /* Parameters that can be set with 'insmod' */
@@ -110,29 +128,17 @@ static struct Scsi_Host *qlogic_detect(S
 	int qltyp;		/* type of chip */
 	int qinitid;
 	struct Scsi_Host *shost;	/* registered host structure */
-	qlogicfas_priv_t priv;
+	struct qlogicfas408_priv *priv;
 
-	qltyp = inb(qbase + 0xe) & 0xf8;
+	qltyp = qlogicfas408_get_chip_type(qbase, INT_TYPE);
 	qinitid = host->this_id;
 	if (qinitid < 0)
 		qinitid = 7;	/* if no ID, use 7 */
-	outb(1, qbase + 8);	/* set for PIO pseudo DMA */
-	REG0;
-	outb(0x40 | qlcfg8 | qinitid, qbase + 8);	/* (ini) bus id, disable scsi rst */
-	outb(qlcfg5, qbase + 5);	/* select timer */
-	outb(qlcfg9, qbase + 9);	/* prescaler */
-
-#if QL_RESET_AT_START
-	outb(3, qbase + 3);
-	REG1;
-	/* FIXME: timeout */
-	while (inb(qbase + 0xf) & 4)
-		cpu_relax();
-	REG0;
-#endif
+
+	qlogicfas408_setup(qbase, qinitid, INT_TYPE);
 
 	host->name = qlogic_name;
-	shost = scsi_host_alloc(host, sizeof(struct qlogicfas_priv));
+	shost = scsi_host_alloc(host, sizeof(struct qlogicfas408_priv));
 	if (!shost)
 		goto err;
 	shost->io_port = qbase;
@@ -141,12 +147,14 @@ static struct Scsi_Host *qlogic_detect(S
 	if (qlirq != -1)
 		shost->irq = qlirq;
 
-	priv = (qlogicfas_priv_t)&(shost->hostdata[0]);
+	priv = get_priv_by_host(shost);
 	priv->qlirq = qlirq;
 	priv->qbase = qbase;
 	priv->qinitid = qinitid;
+	priv->shost = shost;
+	priv->int_type = INT_TYPE;					
 
-	if (request_irq(qlirq, do_ql_ihandl, 0, qlogic_name, shost))
+	if (request_irq(qlirq, qlogicfas408_ihandl, 0, qlogic_name, shost))
 		goto free_scsi_host;
 
 	sprintf(priv->qinfo,
@@ -307,9 +315,6 @@ static void qlogic_config(dev_link_t * l
 		outb(0x04, link->io.BasePort1 + 0xd);
 	}
 
-	qlogicfas_driver_template.name = qlogic_name;
-	qlogicfas_driver_template.proc_name = qlogic_name;
-
 	/* The KXL-810AN has a bigger IO port window */
 	if (link->io.NumPorts1 == 32)
 		host = qlogic_detect(&qlogicfas_driver_template, link,
@@ -402,7 +407,7 @@ static int qlogic_event(event_t event, i
 				outb(0x04, link->io.BasePort1 + 0xd);
 			}
 			/* Ugggglllyyyy!!! */
-			qlogicfas_bus_reset(NULL);
+			qlogicfas408_bus_reset(NULL);
 		}
 		break;
 	}

--/unnNtmY43mpUSKx--
