From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Sun, 09 Feb 2014 00:26:48 -0800
Message-ID: <1391934408.25121.3.camel@haakon3.risingtidesystems.com>
References: <20140205123930.150608699@bombadil.infradead.org>
	 <20140205124021.286457268@bombadil.infradead.org>
	 <1391705819.22335.8.camel@dabdike> <52F3C21F.70409@acm.org>
	 <1391723900.14985.3.camel@haakon3.risingtidesystems.com>
	 <52F4B622.1070900@acm.org>
	 <1391801455.1155.26.camel@haakon3.risingtidesystems.com>
	 <52F60E61.5040609@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54020 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaBIIYT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Feb 2014 03:24:19 -0500
In-Reply-To: <52F60E61.5040609@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On Sat, 2014-02-08 at 12:00 +0100, Bart Van Assche wrote:
> On 02/07/14 20:30, Nicholas A. Bellinger wrote:
> > All that scsi_debug with NOP'ed REQ_TYPE_FS commands is doing is calling
> > scsi_cmd->done() as soon as the descriptor has been dispatched into LLD
> > ->queuecommand() code.
> > 
> > It's useful for determining an absolute performance ceiling between
> > scsi_mq vs. scsi_request_fn() based codepaths without involving any
> > other LLD specific overheads.
> 
> Sorry but I'm not convinced that the scsi_debug driver is well suited
> for testing scsi-mq. In source file drivers/scsi/scsi_debug.c of kernel
> 3.14-rc1 I found the following:
> 
> static DEF_SCSI_QCMD(scsi_debug_queuecommand)
> 
> From include/scsi/scsi_host.h:
> 
> /*
>  * Temporary #define for host lock push down. Can be removed when all
>  * drivers have been updated to take advantage of unlocked
>  * queuecommand.
>  *
>  */
> #define DEF_SCSI_QCMD(func_name) \
>         int func_name(struct Scsi_Host *shost, struct scsi_cmnd *cmd)  \
>         {                                                              \
>                 unsigned long irq_flags;                               \
>                 int rc;                                                \
>                 spin_lock_irqsave(shost->host_lock, irq_flags);        \
>                 scsi_cmd_get_serial(shost, cmd);                       \
>                 rc = func_name##_lck (cmd, cmd->scsi_done);            \
>                 spin_unlock_irqrestore(shost->host_lock, irq_flags);   \
>                 return rc;                                             \
>         }
> 
> In other words, all scsi_debug_queuecommand() are serialized. I think
> for testing the scsi-mq code properly a SCSI LLD driver is needed that
> allows concurrent queuecommand() calls.
> 

Again, try NOP'ing all REQ_TYPE_FS type commands immediately in
->queuecommand() in order to determine a baseline without any other LLD
overhead involved.

Here's what been used so far in target-pending/scsi-mq:

>From 0f312a951eedc87adc4c00adfec8ab317727efdd Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 24 May 2013 05:11:38 +0000
Subject: scsi-debug: Enable scsi-mq operation

v4 changes:
  - Bump can_queue to 64 for performance testing
  - Enable scsi-mq DIF support
  - Add nop_fs_io module parameter for performance testing

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 80b8b10..612d36d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -119,6 +119,7 @@ static const char * scsi_debug_version_date = "20100324";
 #define DEF_VIRTUAL_GB   0
 #define DEF_VPD_USE_HOSTNO 1
 #define DEF_WRITESAME_LENGTH 0xFFFF
+#define DEF_NOP_FS_IO 0
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -195,6 +196,7 @@ static unsigned int scsi_debug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static unsigned int scsi_debug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int scsi_debug_write_same_length = DEF_WRITESAME_LENGTH;
 static bool scsi_debug_removable = DEF_REMOVABLE;
+static unsigned int scsi_debug_nop_fs_io = DEF_NOP_FS_IO;
 
 static int scsi_debug_cmnd_count = 0;
 
@@ -2779,6 +2781,8 @@ module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(write_same_length, scsi_debug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
+module_param_named(nop_fs_io, scsi_debug_nop_fs_io, int,
+		   S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -2820,6 +2824,7 @@ MODULE_PARM_DESC(unmap_max_desc, "max # of ranges that can be unmapped in one cm
 MODULE_PARM_DESC(virtual_gb, "virtual gigabyte size (def=0 -> use dev_size_mb)");
 MODULE_PARM_DESC(vpd_use_hostno, "0 -> dev ids ignore hostno (def=1 -> unique dev ids)");
 MODULE_PARM_DESC(write_same_length, "Maximum blocks per WRITE SAME cmd (def=0xffff)");
+MODULE_PARM_DESC(nop_fs_io, "Turn REQ_TYPE_FS I/O into NOPs");
 
 static char sdebug_info[256];
 
@@ -3954,6 +3959,20 @@ write:
 
 static DEF_SCSI_QCMD(scsi_debug_queuecommand)
 
+static int scsi_debug_queuecommand_mq(struct Scsi_Host *host, struct scsi_cmnd *sc)
+{
+	struct request *rq = sc->request;
+
+	if (scsi_debug_nop_fs_io && rq->cmd_type == REQ_TYPE_FS) {
+		set_host_byte(sc, DID_OK);
+		sc->result |= SAM_STAT_GOOD;
+		sc->scsi_done(sc);
+		return 0;
+	}
+
+	return scsi_debug_queuecommand_lck(sc, sc->scsi_done);
+}
+
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
 	.write_info =		scsi_debug_write_info,
@@ -3965,6 +3984,8 @@ static struct scsi_host_template sdebug_driver_template = {
 	.slave_destroy =	scsi_debug_slave_destroy,
 	.ioctl =		scsi_debug_ioctl,
 	.queuecommand =		scsi_debug_queuecommand,
+	.queuecommand_mq =	scsi_debug_queuecommand_mq,
+	.scsi_mq =		true,
 	.eh_abort_handler =	scsi_debug_abort,
 	.eh_bus_reset_handler = scsi_debug_bus_reset,
 	.eh_device_reset_handler = scsi_debug_device_reset,
@@ -3973,7 +3994,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.can_queue =		SCSI_DEBUG_CANQUEUE,
 	.this_id =		7,
 	.sg_tablesize =		256,
-	.cmd_per_lun =		16,
+	.cmd_per_lun =		64,
 	.max_sectors =		0xffff,
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,

