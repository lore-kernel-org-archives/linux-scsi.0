From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move ->eh_strategy_handler to the transport class
Date: Sat, 1 Apr 2006 19:21:04 +0200
Message-ID: <20060401172104.GA16921@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:16540 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751547AbWDARVT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Apr 2006 12:21:19 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Overriding the whole EH code is a per-transport, not per-host thing.
Move ->eh_strategy_handler to the transport class, same as
->eh_timed_out.

Downside is that scsi_host_alloc can't check for the total lack of EH
anymore, but the transition period from old EH where we needed it is
long gone already.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/ahci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ahci.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ahci.c	2006-04-01 18:42:41.000000000 +0200
@@ -207,7 +207,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= AHCI_MAX_SG,
Index: scsi-misc-2.6/drivers/scsi/ata_piix.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/ata_piix.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/ata_piix.c	2006-04-01 18:42:41.000000000 +0200
@@ -209,7 +209,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/libata-core.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/libata-core.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/libata-core.c	2006-04-01 18:42:41.000000000 +0200
@@ -4976,7 +4976,6 @@
 EXPORT_SYMBOL_GPL(ata_port_queue_task);
 EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
-EXPORT_SYMBOL_GPL(ata_scsi_error);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_release);
 EXPORT_SYMBOL_GPL(ata_host_intr);
Index: scsi-misc-2.6/drivers/scsi/libata-scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/libata-scsi.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/libata-scsi.c	2006-04-01 18:57:13.000000000 +0200
@@ -53,6 +53,7 @@
 typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc, const u8 *scsicmd);
 static struct ata_device *
 ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev);
+static void ata_scsi_error(struct Scsi_Host *host);
 enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 
 #define RW_RECOVERY_MPAGE 0x1
@@ -99,6 +100,7 @@
  * It just needs the eh_timed_out hook.
  */
 struct scsi_transport_template ata_scsi_transport_template = {
+	.eh_strategy_handler	= ata_scsi_error,
 	.eh_timed_out		= ata_scsi_timed_out,
 };
 
@@ -772,12 +774,9 @@
  *
  *	LOCKING:
  *	Inherited from SCSI layer (none, can sleep)
- *
- *	RETURNS:
- *	Zero.
  */
 
-int ata_scsi_error(struct Scsi_Host *host)
+static void ata_scsi_error(struct Scsi_Host *host)
 {
 	struct ata_port *ap;
 	unsigned long flags;
@@ -805,7 +804,6 @@
 	spin_unlock_irqrestore(&ap->host_set->lock, flags);
 
 	DPRINTK("EXIT\n");
-	return 0;
 }
 
 static void ata_eh_scsidone(struct scsi_cmnd *scmd)
Index: scsi-misc-2.6/drivers/scsi/libata.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/libata.h	2006-03-30 18:15:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/libata.h	2006-04-01 18:42:41.000000000 +0200
@@ -60,7 +60,6 @@
 extern struct scsi_transport_template ata_scsi_transport_template;
 
 extern void ata_scsi_scan_host(struct ata_port *ap);
-extern int ata_scsi_error(struct Scsi_Host *host);
 extern unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
 			       unsigned int buflen);
 
Index: scsi-misc-2.6/drivers/scsi/pdc_adma.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/pdc_adma.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/pdc_adma.c	2006-04-01 18:42:41.000000000 +0200
@@ -143,7 +143,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_mv.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_mv.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_mv.c	2006-04-01 18:42:41.000000000 +0200
@@ -378,8 +378,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
-	.can_queue		= MV_USE_Q_DEPTH,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= MV_MAX_SG_CT / 2,
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
Index: scsi-misc-2.6/drivers/scsi/sata_nv.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_nv.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_nv.c	2006-04-01 18:42:41.000000000 +0200
@@ -201,7 +201,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_promise.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_promise.c	2006-03-30 18:15:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_promise.c	2006-04-01 18:42:41.000000000 +0200
@@ -111,7 +111,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_qstor.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_qstor.c	2006-03-30 18:15:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_qstor.c	2006-04-01 18:42:41.000000000 +0200
@@ -132,7 +132,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= QS_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_sil.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_sil.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_sil.c	2006-04-01 18:42:41.000000000 +0200
@@ -146,7 +146,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_sil24.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_sil24.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_sil24.c	2006-04-01 18:42:41.000000000 +0200
@@ -281,7 +281,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_sis.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_sis.c	2006-03-30 18:15:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_sis.c	2006-04-01 18:42:41.000000000 +0200
@@ -87,7 +87,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= ATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_svw.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_svw.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_svw.c	2006-04-01 18:42:41.000000000 +0200
@@ -290,7 +290,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_sx4.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_sx4.c	2006-03-30 18:15:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_sx4.c	2006-04-01 18:42:41.000000000 +0200
@@ -182,7 +182,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_uli.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_uli.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_uli.c	2006-04-01 18:42:41.000000000 +0200
@@ -81,7 +81,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_via.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_via.c	2006-03-30 18:15:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_via.c	2006-04-01 18:42:41.000000000 +0200
@@ -94,7 +94,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/sata_vsc.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/sata_vsc.c	2006-03-30 18:54:54.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/sata_vsc.c	2006-04-01 18:42:41.000000000 +0200
@@ -263,7 +263,6 @@
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
 	.sg_tablesize		= LIBATA_MAX_PRD,
Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2006-03-30 18:15:30.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2006-04-01 19:11:42.000000000 +0200
@@ -1537,8 +1537,8 @@
 		 * what we need to do to get it up and online again (if we can).
 		 * If we fail, we end up taking the thing offline.
 		 */
-		if (shost->hostt->eh_strategy_handler) 
-			shost->hostt->eh_strategy_handler(shost);
+		if (shost->transportt->eh_strategy_handler)
+			shost->transportt->eh_strategy_handler(shost);
 		else
 			scsi_unjam_host(shost);
 
Index: scsi-misc-2.6/include/scsi/scsi_host.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_host.h	2006-03-30 18:54:57.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_host.h	2006-04-01 18:42:41.000000000 +0200
@@ -140,7 +140,6 @@
 	 *
 	 * Status: REQUIRED	(at least one of them)
 	 */
-	int (* eh_strategy_handler)(struct Scsi_Host *);
 	int (* eh_abort_handler)(struct scsi_cmnd *);
 	int (* eh_device_reset_handler)(struct scsi_cmnd *);
 	int (* eh_bus_reset_handler)(struct scsi_cmnd *);
Index: scsi-misc-2.6/include/scsi/scsi_transport.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_transport.h	2006-03-30 18:15:30.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_transport.h	2006-04-01 18:57:33.000000000 +0200
@@ -50,6 +50,11 @@
 	unsigned int create_work_queue : 1;
 
 	/*
+	 * Allows a transport to override the default error handler.
+	 */
+	void (* eh_strategy_handler)(struct Scsi_Host *);
+
+	/*
 	 * This is an optional routine that allows the transport to become
 	 * involved when a scsi io timer fires. The return value tells the
 	 * timer routine how to finish the io timeout handling:
Index: scsi-misc-2.6/Documentation/DocBook/libata.tmpl
===================================================================
--- scsi-misc-2.6.orig/Documentation/DocBook/libata.tmpl	2006-03-04 13:07:35.000000000 +0100
+++ scsi-misc-2.6/Documentation/DocBook/libata.tmpl	2006-04-01 19:16:17.000000000 +0200
@@ -666,7 +666,7 @@
 
 	<sect1><title>ata_scsi_error()</title>
 	<para>
-	ata_scsi_error() is the current hostt->eh_strategy_handler()
+	ata_scsi_error() is the current transportt->eh_strategy_handler()
 	for libata.  As discussed above, this will be entered in two
 	cases - timeout and ATAPI error completion.  This function
 	calls low level libata driver's eng_timeout() callback, the
Index: scsi-misc-2.6/Documentation/scsi/scsi_eh.txt
===================================================================
--- scsi-misc-2.6.orig/Documentation/scsi/scsi_eh.txt	2006-03-04 13:07:35.000000000 +0100
+++ scsi-misc-2.6/Documentation/scsi/scsi_eh.txt	2006-04-01 19:17:24.000000000 +0200
@@ -19,9 +19,9 @@
 	[2-1-1] Overview
 	[2-1-2] Flow of scmds through EH
 	[2-1-3] Flow of control
-    [2-2] EH through hostt->eh_strategy_handler()
-	[2-2-1] Pre hostt->eh_strategy_handler() SCSI midlayer conditions
-	[2-2-2] Post hostt->eh_strategy_handler() SCSI midlayer conditions
+    [2-2] EH through transportt->eh_strategy_handler()
+	[2-2-1] Pre transportt->eh_strategy_handler() SCSI midlayer conditions
+	[2-2-2] Post transportt->eh_strategy_handler() SCSI midlayer conditions
 	[2-2-3] Things to consider
 
 
@@ -413,9 +413,9 @@
 	    layer of failure of the scmds.
 
 
-[2-2] EH through hostt->eh_strategy_handler()
+[2-2] EH through transportt->eh_strategy_handler()
 
- hostt->eh_strategy_handler() is invoked in the place of
+ transportt->eh_strategy_handler() is invoked in the place of
 scsi_unjam_host() and it is responsible for whole recovery process.
 On completion, the handler should have made lower layers forget about
 all failed scmds and either ready for new commands or offline.  Also,
@@ -424,7 +424,7 @@
 except for #1 must be implemented by eh_strategy_handler().
 
 
-[2-2-1] Pre hostt->eh_strategy_handler() SCSI midlayer conditions
+[2-2-1] Pre transportt->eh_strategy_handler() SCSI midlayer conditions
 
  The following conditions are true on entry to the handler.
 
@@ -437,7 +437,7 @@
  - shost->host_failed == shost->host_busy
 
 
-[2-2-2] Post hostt->eh_strategy_handler() SCSI midlayer conditions
+[2-2-2] Post transportt->eh_strategy_handler() SCSI midlayer conditions
 
  The following conditions must be true on exit from the handler.
 
Index: scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- scsi-misc-2.6.orig/Documentation/scsi/scsi_mid_low_api.txt	2006-03-04 13:07:35.000000000 +0100
+++ scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt	2006-04-01 19:17:48.000000000 +0200
@@ -804,7 +804,6 @@
    eh_bus_reset_handler - issue SCSI bus reset
    eh_device_reset_handler - issue SCSI device reset
    eh_host_reset_handler - reset host (host bus adapter)
-   eh_strategy_handler - driver supplied alternate to scsi_unjam_host()
    info - supply information about given host
    ioctl - driver can respond to ioctls
    proc_info - supports /proc/scsi/{driver_name}/{host_no}
@@ -970,24 +969,6 @@
 
 
 /**
- *      eh_strategy_handler - driver supplied alternate to scsi_unjam_host()
- *      @shp: host on which error has occurred
- *
- *      Returns TRUE if host unjammed, else FALSE.
- *
- *      Locks: none
- *
- *      Calling context: kernel thread
- *
- *      Notes: Invoked from scsi_eh thread. LLD supplied alternate to 
- *      scsi_unjam_host() found in scsi_error.c
- *
- *      Optionally defined in: LLD
- **/
-     int eh_strategy_handler(struct Scsi_Host * shp)
-
-
-/**
  *      info - supply information about given host: driver name plus data
  *             to distinguish given host
  *      @shp: host to supply information about
Index: scsi-misc-2.6/drivers/scsi/hosts.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/hosts.c	2006-03-04 13:07:44.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/hosts.c	2006-04-01 18:58:26.000000000 +0200
@@ -294,18 +294,6 @@
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
 
-        /* Check to see if this host has any error handling facilities */
-        if (!sht->eh_strategy_handler && !sht->eh_abort_handler &&
-	    !sht->eh_device_reset_handler && !sht->eh_bus_reset_handler &&
-            !sht->eh_host_reset_handler) {
-		printk(KERN_ERR "ERROR: SCSI host `%s' has no error handling\n"
-				"ERROR: This is not a safe way to run your "
-				        "SCSI host\n"
-				"ERROR: The error handling must be added to "
-				"this driver\n", sht->proc_name);
-		dump_stack();
-        }
-
 	shost = kzalloc(sizeof(struct Scsi_Host) + privsize, gfp_mask);
 	if (!shost)
 		return NULL;
Index: scsi-misc-2.6/include/linux/libata.h
===================================================================
--- scsi-misc-2.6.orig/include/linux/libata.h	2006-03-30 18:54:56.000000000 +0200
+++ scsi-misc-2.6/include/linux/libata.h	2006-04-01 18:43:40.000000000 +0200
@@ -515,7 +515,6 @@
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
-extern int ata_scsi_error(struct Scsi_Host *host);
 extern void ata_eh_qc_complete(struct ata_queued_cmd *qc);
 extern void ata_eh_qc_retry(struct ata_queued_cmd *qc);
 extern int ata_scsi_release(struct Scsi_Host *host);
