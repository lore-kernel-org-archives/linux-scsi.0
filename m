From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: what replaces Scsi_Host->select_queue_depths?
Date: Fri, 25 Oct 2002 11:33:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025183319.GA1514@beaverton.ibm.com>
References: <3DB9858E.7090209@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DB9858E.7090209@mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: Steven Dake <sdake@mvista.com>
Cc: linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com


Steven Dake [sdake@mvista.com] wrote:
> I am looking at porting the QLA 2xxx driver that MontaVista has been working
> with QLogic on to 2.5.44.  I've removed the select_queue_depths function 
> calls
> from the init and it seems to work fine.
> 
> My question is, what replaces this API?  It looks like this only applies 
> to devices
> that don't support command tagged queueing (ie: a way to shut off access if
> the device doesn't support command tagged queueing).
> 
> Has this been genericized somewhere else in the scsi subsystem?

Steven,
	The slave_attached function should be used. We run the patch
	below on the 6.03.00b7 version of the driver available off the
	qlogic web site.
	http://download.qlogic.com/drivers/6443/qla2x00-v6.03.00b7-dist.tgz

	(I have tested more on earlier versions, but I believe patman
	has had some run time on b7).

Since Andrew is the maintainer he can comment on the correctness.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 Makefile  |    9 +++++++++
 qla2x00.c |   32 ++++++++++++++------------------
 qla2x00.h |    3 +--
 3 files changed, 24 insertions(+), 20 deletions(-)
------

diff -urNX dontdiff qla2x00src-v6.03.00b7/Makefile qla2x00src-v6.03.00b7-2.5.44/Makefile
--- qla2x00src-v6.03.00b7/Makefile	Wed Dec 31 16:00:00 1969
+++ qla2x00src-v6.03.00b7-2.5.44/Makefile	Fri Oct 25 11:12:05 2002
@@ -0,0 +1,9 @@
+# andmike's condensed makefile
+# To use cd to kernel source and type the following.
+# make SUBDIRS=/path/to/your/module modules
+
+CFLAGS_qla2200.o = -I$(TOPDIR)/drivers/scsi
+CFLAGS_qla2300.o = -I$(TOPDIR)/drivers/scsi
+obj-m	:= qla2200.o qla2300.o
+
+include	$(TOPDIR)/Rules.make
diff -urNX dontdiff qla2x00src-v6.03.00b7/qla2x00.c qla2x00src-v6.03.00b7-2.5.44/qla2x00.c
--- qla2x00src-v6.03.00b7/qla2x00.c	Mon Oct 14 06:15:26 2002
+++ qla2x00src-v6.03.00b7-2.5.44/qla2x00.c	Fri Oct 25 11:19:14 2002
@@ -77,7 +77,6 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/blk.h>
-#include <linux/tqueue.h>
 #include <linux/interrupt.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
@@ -228,7 +227,7 @@
 STATIC uint8_t qla2x00_register_with_Linux(scsi_qla_host_t *ha,
 			uint8_t maxchannels);
 STATIC int qla2x00_done(scsi_qla_host_t *);
-STATIC void qla2x00_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
+STATIC int qla2x00_slave_attach(Scsi_Device *);
 
 STATIC void qla2x00_timer(scsi_qla_host_t *);
 
@@ -2227,7 +2226,6 @@
 
 	host->can_queue = max_srbs;  /* default value:-MAX_SRBS(4096)  */
 	host->cmd_per_lun = 1;
-	host->select_queue_depths = qla2x00_select_queue_depth;
 	host->n_io_port = 0xFF;
 
 #if MEMORY_MAPPED_IO
@@ -3690,11 +3688,11 @@
 
 	heads = 64;
 	sectors = 32;
-	cylinders = disk->capacity / (heads * sectors);
+	cylinders = sector_div(disk->capacity, heads * sectors); 
 	if (cylinders > 1024) {
 		heads = 255;
 		sectors = 63;
-		cylinders = disk->capacity / (heads * sectors);
+		cylinders = sector_div(disk->capacity, heads * sectors);
 	}
 
 	geom[0] = heads;
@@ -4329,15 +4327,14 @@
 void
 qla2x00_device_queue_depth(scsi_qla_host_t *p, Scsi_Device *device)
 {
-	int default_depth = 16;
+	int queue_depth = 16;
 
-	device->queue_depth = default_depth;
 	if (device->tagged_supported) {
 		device->tagged_queue = 1;
 		device->current_tag = 0;
 #if defined(MODULE)
 		if (!(ql2xmaxqdepth == 0 || ql2xmaxqdepth > 256))
-			device->queue_depth = ql2xmaxqdepth;
+			queue_depth = ql2xmaxqdepth;
 #endif
 
 		printk(KERN_INFO
@@ -4347,33 +4344,32 @@
 			device->channel,
 			device->id,
 			device->lun, 
-			device->queue_depth);
+			queue_depth);
 	}
 
+	scsi_adjust_queue_depth(device, MSG_ORDERED_TAG, queue_depth);
 }
 
 /**************************************************************************
-*   qla2x00_select_queue_depth
+* qla2x00_slave_attach
 *
 * Description:
 *   Sets the queue depth for each SCSI device hanging off the input
 *   host adapter.  We use a queue depth of 2 for devices that do not
 *   support tagged queueing.
 **************************************************************************/
-STATIC void
-qla2x00_select_queue_depth(struct Scsi_Host *host, Scsi_Device *scsi_devs)
+STATIC int
+qla2x00_slave_attach(Scsi_Device *scsi_dev)
 {
-	Scsi_Device *device;
-	scsi_qla_host_t  *p = (scsi_qla_host_t *) host->hostdata;
+	scsi_qla_host_t  *p = (scsi_qla_host_t *) scsi_dev->host->hostdata;
 
 	ENTER("qla2x00_select_queue_depth");
 
-	for (device = scsi_devs; device != NULL; device = device->next) {
-		if (device->host == host)
-			qla2x00_device_queue_depth(p, device);
-	}
+	qla2x00_device_queue_depth(p, scsi_dev);
 
 	LEAVE("qla2x00_select_queue_depth");
+
+	return 0;
 }
 
 /**************************************************************************
diff -urNX dontdiff qla2x00src-v6.03.00b7/qla2x00.h qla2x00src-v6.03.00b7-2.5.44/qla2x00.h
--- qla2x00src-v6.03.00b7/qla2x00.h	Mon Oct 14 06:15:26 2002
+++ qla2x00src-v6.03.00b7-2.5.44/qla2x00.h	Fri Oct 25 11:12:05 2002
@@ -2710,7 +2710,6 @@
 
 
 #define QLA2100_LINUX_TEMPLATE {				\
-        next:   NULL,						\
 	module: NULL,						\
 	proc_dir: NULL,						\
 	proc_info: qla2x00_proc_info,	                        \
@@ -2728,7 +2727,7 @@
 	eh_host_reset_handler: qla2xxx_eh_host_reset,		\
 	abort: NULL,						\
 	reset: NULL,						\
-	slave_attach: NULL,					\
+	slave_attach: qla2x00_slave_attach,			\
 	bios_param: QLA2100_BIOSPARAM,				\
 	can_queue: 255,		/* max simultaneous cmds      */\
 	this_id: -1,		/* scsi id of host adapter    */\

