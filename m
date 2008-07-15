From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [patch 04/16] git-scsi-misc: fix SCSI_DH build errors
Date: Tue, 15 Jul 2008 15:08:17 -0700
Message-ID: <1216159697.27507.218.camel@chandra-ubuntu>
References: <200807040647.m646lPjk017478@imap1.linux-foundation.org>
	 <1215468655.3274.45.camel@localhost.localdomain>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59549 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbYGOWIb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 18:08:31 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FM8UHw026633
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 18:08:30 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FM8URi230478
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 18:08:30 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FM8TXB015181
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 18:08:30 -0400
In-Reply-To: <1215468655.3274.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, agk@redhat.com, andmike@us.ibm.com, hare@suse.de, michaelc@cs.wisc.edu, randy.dunlap@oracle.com

James, Andrew,

I couldn't find a way to remove that weird "depends" line by just
working with Kconfig rules.

Attached is a patch that removes the weird depends with some code
movements and Makefile changes. Let me know if you think it is worth.

regards,

chandra
On Mon, 2008-07-07 at 17:10 -0500, James Bottomley wrote:
> On Thu, 2008-07-03 at 23:47 -0700, akpm@linux-foundation.org wrote:
> > From: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > Do not automatically "select" SCSI_DH for dm-multipath. If SCSI_DH
> > doesn't exist, just do not allow  hardware handlers to be used.
> > 
> > Handle SCSI_DH being a module also. Make sure it doesn't allow DM_MULTIPATH
> > to be compiled in when SCSI_DH is a module.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Reported-by: Andrew Morton <akpm@linux-foundation.org>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Cc: Alasdair G Kergon <agk@redhat.com>
> > Cc: Mike Christie <michaelc@cs.wisc.edu>
> > Cc: Mike Anderson <andmike@us.ibm.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/md/Kconfig     |    2 +-
> >  drivers/md/dm-mpath.c  |    2 ++
> >  include/scsi/scsi_dh.h |   12 +++++++++++-
> >  3 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff -puN drivers/md/Kconfig~git-scsi-misc-fix-scsi_dh-build-errors drivers/md/Kconfig
> > --- a/drivers/md/Kconfig~git-scsi-misc-fix-scsi_dh-build-errors
> > +++ a/drivers/md/Kconfig
> > @@ -252,7 +252,7 @@ config DM_ZERO
> >  config DM_MULTIPATH
> >  	tristate "Multipath target"
> >  	depends on BLK_DEV_DM
> > -	select SCSI_DH
> > +	depends on SCSI_DH || !SCSI_DH
> 
> This is a bit horrible.  It's not very obvious what it means and it
> critically depends on the current !m == m behaviour.
> 
> >  	---help---
> >  	  Allow volume managers to support multipath hardware.
> >  
> > diff -puN drivers/md/dm-mpath.c~git-scsi-misc-fix-scsi_dh-build-errors drivers/md/dm-mpath.c
> > --- a/drivers/md/dm-mpath.c~git-scsi-misc-fix-scsi_dh-build-errors
> > +++ a/drivers/md/dm-mpath.c
> > @@ -664,6 +664,8 @@ static int parse_hw_handler(struct arg_s
> >  	request_module("scsi_dh_%s", m->hw_handler_name);
> >  	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
> >  		ti->error = "unknown hardware handler type";
> > +		kfree(m->hw_handler_name);
> > +		m->hw_handler_name = NULL;
> 
> This looks like some type of separate bug fix ... it's certainly not
> mentioned in the change log and has nothing to do with modular compile
> problems.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Remove the wierd depends line for DM_MULTIPATH, and move the scsi_dh interfaces
to a dummpy file.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/Makefile                            |    2 
 drivers/md/Kconfig                          |    1 
 drivers/scsi/Makefile                       |    2 
 drivers/scsi/device_handler/Makefile        |    1 
 drivers/scsi/device_handler/scsi_dh.c       |   32 +++++++++++----
 drivers/scsi/device_handler/scsi_dh_dummy.c |   57 ++++++++++++++++++++++++++++
 include/scsi/scsi_dh.h                      |    8 +++
 7 files changed, 91 insertions(+), 12 deletions(-)

Index: linux-2.6.26-rc5-mm3/drivers/md/Kconfig
===================================================================
--- linux-2.6.26-rc5-mm3.orig/drivers/md/Kconfig
+++ linux-2.6.26-rc5-mm3/drivers/md/Kconfig
@@ -252,7 +252,6 @@ config DM_ZERO
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
-	depends on SCSI_DH || !SCSI_DH
 	---help---
 	  Allow volume managers to support multipath hardware.
 
Index: linux-2.6.26-rc5-mm3/drivers/scsi/device_handler/Makefile
===================================================================
--- linux-2.6.26-rc5-mm3.orig/drivers/scsi/device_handler/Makefile
+++ linux-2.6.26-rc5-mm3/drivers/scsi/device_handler/Makefile
@@ -1,6 +1,7 @@
 #
 # SCSI Device Handler
 #
+obj-y				+= scsi_dh_dummy.o
 obj-$(CONFIG_SCSI_DH)		+= scsi_dh.o
 obj-$(CONFIG_SCSI_DH_RDAC)	+= scsi_dh_rdac.o
 obj-$(CONFIG_SCSI_DH_HP_SW)	+= scsi_dh_hp_sw.o
Index: linux-2.6.26-rc5-mm3/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- linux-2.6.26-rc5-mm3.orig/drivers/scsi/device_handler/scsi_dh.c
+++ linux-2.6.26-rc5-mm3/drivers/scsi/device_handler/scsi_dh.c
@@ -116,12 +116,12 @@ done:
 EXPORT_SYMBOL_GPL(scsi_unregister_device_handler);
 
 /*
- * scsi_dh_activate - activate the path associated with the scsi_device
+ * __scsi_dh_activate - activate the path associated with the scsi_device
  *      corresponding to the given request queue.
- * @q - Request queue that is associated with the scsi_device to be
- *      activated.
+ * q - Request queue that is associated with the scsi_device to be
+ *     activated.
  */
-int scsi_dh_activate(struct request_queue *q)
+static int __scsi_dh_activate(struct request_queue *q)
 {
 	int err = 0;
 	unsigned long flags;
@@ -144,18 +144,32 @@ int scsi_dh_activate(struct request_queu
 	put_device(&sdev->sdev_gendev);
 	return err;
 }
-EXPORT_SYMBOL_GPL(scsi_dh_activate);
 
 /*
- * scsi_dh_handler_exist - Return TRUE(1) if a device handler exists for
+ * __scsi_dh_handler_exist - Return TRUE(1) if a device handler exists for
  *	the given name. FALSE(0) otherwise.
- * @name - name of the device handler.
+ * name - name of the device handler.
  */
-int scsi_dh_handler_exist(const char *name)
+static int __scsi_dh_handler_exist(const char *name)
 {
 	return (get_device_handler(name) != NULL);
 }
-EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
+
+static int __init scsi_dh_init(void)
+{
+	ops.activate = __scsi_dh_activate;
+	ops.handler_exist = __scsi_dh_handler_exist;
+	return 0;
+}
+
+static void __init scsi_dh_exit(void)
+{
+	ops.activate = NULL;
+	ops.handler_exist = NULL;
+}
+
+module_init(scsi_dh_init);
+module_exit(scsi_dh_exit);
 
 MODULE_DESCRIPTION("SCSI device handler");
 MODULE_AUTHOR("Chandra Seetharaman <sekharan@us.ibm.com>");
Index: linux-2.6.26-rc5-mm3/drivers/scsi/device_handler/scsi_dh_dummy.c
===================================================================
--- /dev/null
+++ linux-2.6.26-rc5-mm3/drivers/scsi/device_handler/scsi_dh_dummy.c
@@ -0,0 +1,57 @@
+/*
+ * SCSI device handler dummy interface
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *      Authors:
+ *               Chandra Seetharaman <sekharan@us.ibm.com>
+ */
+
+#include <linux/module.h>
+#include <scsi/scsi_dh.h>
+
+struct scsi_dh_ops ops = {
+	.activate = NULL,
+	.handler_exist = NULL,
+};
+EXPORT_SYMBOL_GPL(ops);
+
+/*
+ * scsi_dh_activate - activate the path associated with the scsi_device
+ *      corresponding to the given request queue.
+ * @q - Request queue that is associated with the scsi_device to be
+ *      activated.
+ */
+int scsi_dh_activate(struct request_queue *req)
+{
+	if (ops.activate)
+		return ops.activate(req);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_activate);
+
+/*
+ * scsi_dh_handler_exist - Return TRUE(1) if a device handler exists for
+ *	the given name. FALSE(0) otherwise.
+ * @name - name of the device handler.
+ */
+int scsi_dh_handler_exist(const char *name)
+{
+	if (ops.handler_exist)
+		return ops.handler_exist(name);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_dh_handler_exist);
Index: linux-2.6.26-rc5-mm3/include/scsi/scsi_dh.h
===================================================================
--- linux-2.6.26-rc5-mm3.orig/include/scsi/scsi_dh.h
+++ linux-2.6.26-rc5-mm3/include/scsi/scsi_dh.h
@@ -54,7 +54,15 @@ enum {
 	SCSI_DH_NOSYS,
 	SCSI_DH_DRIVER_MAX,
 };
+
 #if defined(CONFIG_SCSI_DH) || defined(CONFIG_SCSI_DH_MODULE)
+struct scsi_dh_ops {
+	int (*activate) (struct request_queue *);
+	int (*handler_exist) (const char *);
+};
+
+extern struct scsi_dh_ops ops;
+
 extern int scsi_dh_activate(struct request_queue *);
 extern int scsi_dh_handler_exist(const char *);
 #else
Index: linux-2.6.26-rc5-mm3/drivers/scsi/Makefile
===================================================================
--- linux-2.6.26-rc5-mm3.orig/drivers/scsi/Makefile
+++ linux-2.6.26-rc5-mm3/drivers/scsi/Makefile
@@ -34,7 +34,7 @@ obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_t
 obj-$(CONFIG_SCSI_SAS_ATTRS)	+= scsi_transport_sas.o
 obj-$(CONFIG_SCSI_SAS_LIBSAS)	+= libsas/
 obj-$(CONFIG_SCSI_SRP_ATTRS)	+= scsi_transport_srp.o
-obj-$(CONFIG_SCSI_DH)		+= device_handler/
+obj-y				+= device_handler/
 
 obj-$(CONFIG_ISCSI_TCP) 	+= libiscsi.o	iscsi_tcp.o
 obj-$(CONFIG_INFINIBAND_ISER) 	+= libiscsi.o
Index: linux-2.6.26-rc5-mm3/drivers/Makefile
===================================================================
--- linux-2.6.26-rc5-mm3.orig/drivers/Makefile
+++ linux-2.6.26-rc5-mm3/drivers/Makefile
@@ -35,7 +35,7 @@ obj-$(CONFIG_NUBUS)		+= nubus/
 obj-$(CONFIG_ATM)		+= atm/
 obj-y				+= macintosh/
 obj-$(CONFIG_IDE)		+= ide/
-obj-$(CONFIG_SCSI)		+= scsi/
+obj-y				+= scsi/
 obj-$(CONFIG_ATA)		+= ata/
 obj-$(CONFIG_FUSION)		+= message/
 obj-$(CONFIG_FIREWIRE)		+= firewire/


