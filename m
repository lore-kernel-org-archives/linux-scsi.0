From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] add transport attributes to sym2
Date: 12 Mar 2004 18:39:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079134796.1756.46.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:15523 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262537AbUCLXkB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2004 18:40:01 -0500
List-Id: linux-scsi@vger.kernel.org
To: willy@debian.org
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This patch shows how to add transport attributes to the sym2 driver
using the pull method (the driver still keeps its own copies of the
attribute settings which are sync'd with the transport attribute ones
where necessary---the previous 53c700 patch used the directly shared
model).

Since sym2 is a more complex (and modern) driver, I've also put in
support for DT and wide settings (although not IU and QAS since the
actual driver doesn't have those).

James

diff -Nru a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Mar 12 17:28:08 2004
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	Fri Mar 12 17:28:08 2004
@@ -57,6 +57,9 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport.h>
+#include <scsi/scsi_transport_spi.h>
 
 #include "sym_glue.h"
 #include "sym_nvram.h"
@@ -87,6 +90,8 @@
 /* This lock protects only the memory allocation/free.  */
 spinlock_t sym53c8xx_lock = SPIN_LOCK_UNLOCKED;
 
+static struct scsi_transport_template *sym2_transport_template = NULL;
+
 /*
  *  Wrappers to the generic memory allocator.
  */
@@ -1819,6 +1826,8 @@
 	instance->can_queue	= (SYM_CONF_MAX_START-2);
 	instance->sg_tablesize	= SYM_CONF_MAX_SG;
 	instance->max_cmd_len	= 16;
+	BUG_ON(sym2_transport_template == NULL);
+	instance->transportt	= sym2_transport_template;
 
 	spin_unlock_irqrestore(instance->host_lock, flags);
 
@@ -2337,6 +2346,118 @@
 	attach_count--;
 }
 
+static void sym2_get_offset(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_offset(sdev) = tp->tinfo.curr.offset;
+}
+
+static void sym2_set_offset(struct scsi_device *sdev, int offset)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	if(tp->tinfo.curr.options & PPR_OPT_DT) {
+		if(offset > np->maxoffs_dt)
+			offset = np->maxoffs_dt;
+	} else {
+		if(offset > np->maxoffs)
+			offset = np->maxoffs;
+	}
+	tp->tinfo.goal.offset = offset;
+}
+
+
+static void sym2_get_period(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_period(sdev) = tp->tinfo.curr.period;
+}
+
+static void sym2_set_period(struct scsi_device *sdev, int period)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	if(period <= 9 && np->minsync_dt) {
+		if(period < np->minsync_dt)
+			period = np->minsync_dt;
+		tp->tinfo.goal.options = PPR_OPT_DT;
+		tp->tinfo.goal.period = period;
+		if(!tp->tinfo.curr.offset || tp->tinfo.curr.offset > np->maxoffs_dt)
+			tp->tinfo.goal.offset = np->maxoffs_dt;
+	} else {
+		if(period < np->minsync)
+			period = np->minsync;
+		tp->tinfo.goal.options = 0;
+		tp->tinfo.goal.period = period;
+		if(!tp->tinfo.curr.offset || tp->tinfo.curr.offset > np->maxoffs)
+			tp->tinfo.goal.offset = np->maxoffs;
+	}
+}
+
+static void sym2_get_width(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_width(sdev) = tp->tinfo.curr.width ? 1 : 0;
+}
+
+static void sym2_set_width(struct scsi_device *sdev, int width)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	tp->tinfo.goal.width = width;
+}
+
+static void sym2_get_dt(struct scsi_device *sdev)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	spi_dt(sdev) = (tp->tinfo.curr.options & PPR_OPT_DT) ? 1 : 0;
+}
+
+static void sym2_set_dt(struct scsi_device *sdev, int dt)
+{
+	struct sym_hcb *np = ((struct host_data *)sdev->host->hostdata)->ncb;
+	struct sym_tcb *tp = &np->target[sdev->id];
+
+	if(!dt) {
+		/* if clearing DT, then we may need to reduce the
+		 * period and the offset */
+		if(tp->tinfo.curr.period < np->minsync)
+			tp->tinfo.goal.period = np->minsync;
+		if(tp->tinfo.curr.offset > np->maxoffs)
+			tp->tinfo.goal.offset = np->maxoffs;
+		tp->tinfo.goal.options &= ~PPR_OPT_DT;
+	} else {
+		tp->tinfo.goal.options |= PPR_OPT_DT;
+	}
+}
+	
+
+static struct spi_function_template sym2_transport_functions = {
+	.set_offset	= sym2_set_offset,
+	.get_offset	= sym2_get_offset,
+	.show_offset	= 1,
+	.set_period	= sym2_set_period,
+	.get_period	= sym2_get_period,
+	.show_period	= 1,
+	.set_width	= sym2_set_width,
+	.get_width	= sym2_get_width,
+	.show_width	= 1,
+	.get_dt		= sym2_get_dt,
+	.set_dt		= sym2_set_dt,
+	.show_dt	= 1,
+};
+
 static struct pci_device_id sym2_id_table[] __devinitdata = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
@@ -2386,6 +2507,10 @@
 
 static int __init sym2_init(void)
 {
+	sym2_transport_template = spi_attach_transport(&sym2_transport_functions);
+	if(!sym2_transport_template)
+		return -ENODEV;
+
 	pci_register_driver(&sym2_driver);
 	return 0;
 }
@@ -2393,6 +2518,7 @@
 static void __exit sym2_exit(void)
 {
 	pci_unregister_driver(&sym2_driver);
+	spi_release_transport(sym2_transport_template);
 }
 
 module_init(sym2_init);





