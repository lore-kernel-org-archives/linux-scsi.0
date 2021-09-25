Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A98C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 22:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A58460F5D
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 22:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhIYWBy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 18:01:54 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:52534 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229997AbhIYWBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Sep 2021 18:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1632607218;
        bh=59jbBFTzKtCWjj/DIzoKzuAIIlhYqOxBeTCE6Lbh8x8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=r/SCHhJXykzJb9KERMbCRC8ZBGo96cApvC7PR/TQnb3PCZZG/rV0ghuZkzb75Loa9
         m0jaTYsc747/bn+DrEJXZ6YZELS4Nmtvy1d9tgWyC2QGlVr7ZzDeG+SJVgLcwQR5dt
         jm+4xVJeUZmctcT7y3kMdH1S++QED4NyLrTlpxKg=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 36AA91280BE4;
        Sat, 25 Sep 2021 15:00:18 -0700 (PDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id N4Nj4PquTobK; Sat, 25 Sep 2021 15:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1632607218;
        bh=59jbBFTzKtCWjj/DIzoKzuAIIlhYqOxBeTCE6Lbh8x8=;
        h=Message-ID:Subject:From:To:Date:From;
        b=r/SCHhJXykzJb9KERMbCRC8ZBGo96cApvC7PR/TQnb3PCZZG/rV0ghuZkzb75Loa9
         m0jaTYsc747/bn+DrEJXZ6YZELS4Nmtvy1d9tgWyC2QGlVr7ZzDeG+SJVgLcwQR5dt
         jm+4xVJeUZmctcT7y3kMdH1S++QED4NyLrTlpxKg=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id B9D551280BC4;
        Sat, 25 Sep 2021 15:00:17 -0700 (PDT)
Message-ID: <790cc5690c18cf5216bc01662cd528004402081b.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.15-rc2
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 25 Sep 2021 15:00:16 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thirty Three fixes, I'm afraid.  Essentially the build up from the last
couple of weeks while I've been dealling with Linux Plumbers conference
infrastructure issues.  It's mostly the usual assortment of spelling
fixes and minor corrections.  The only core relevant changes are to the
sd driver to reduce the spin up message spew and fix a small memory
leak on the freeing path.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Adrian Hunter (2):
      scsi: ufs: core: Revert "scsi: ufs: Synchronize SCSI and UFS error handling"
      scsi: ufs: ufs-pci: Fix Intel LKF link stability

Arnd Bergmann (1):
      scsi: lpfc: Fix gcc -Wstringop-overread warning, again

Baokun Li (1):
      scsi: iscsi: Adjust iface sysfs attr detection

Bart Van Assche (2):
      scsi: ufs: core: Unbreak the reset handler
      scsi: sd_zbc: Support disks with more than 2**32 logical blocks

ChanWoo Lee (1):
      scsi: ufs: ufshpb: Remove unused parameters

Chi Minghao (1):
      scsi: lpfc: Remove unneeded variable

Colin Ian King (4):
      scsi: target: Fix spelling mistake "CONFLIFT" -> "CONFLICT"
      scsi: mpt3sas: Clean up some inconsistent indenting
      scsi: megaraid: Clean up some inconsistent indenting
      scsi: sr: Fix spelling mistake "does'nt" -> "doesn't"

Dan Carpenter (2):
      scsi: lpfc: Use correct scnprintf() limit
      scsi: lpfc: Fix sprintf() overflow in lpfc_display_fpin_wwpn()

Dmitry Bogdanov (1):
      scsi: qla2xxx: Restore initiator in dual mode

Hannes Reinecke (3):
      scsi: core: Remove 'current_tag'
      scsi: acornscsi: Remove tagged queuing vestiges
      scsi: fas216: Kill scmd->tag

Heiner Kallweit (1):
      scsi: sd: Make sd_spinup_disk() less noisy

Helge Deller (1):
      scsi: ncr53c8xx: Remove unused retrieve_from_waiting_list() function

James Smart (4):
      scsi: elx: efct: Do not hold lock while calling fc_vport_terminate()
      scsi: lpfc: Fix compilation errors on kernels with no CONFIG_DEBUG_FS
      scsi: lpfc: Fix CPU to/from endian warnings introduced by ELS processing
      scsi: elx: efct: Fix void-pointer-to-enum-cast warning for efc_nport_topology

Jens Axboe (1):
      scsi: Remove SCSI CDROM MAINTAINERS entry

Maurizio Lombardi (1):
      scsi: target: Fix the pgr/alua_support_store functions

Ming Lei (1):
      scsi: sd: Free scsi_disk device via put_device()

Naohiro Aota (1):
      scsi: sd_zbc: Ensure buffer size is aligned to SECTOR_SIZE

Nathan Chancellor (1):
      scsi: st: Add missing break in switch statement in st_ioctl()

Sreekanth Reddy (1):
      scsi: mpt3sas: Call cpu_relax() before calling udelay()

Wen Xiong (1):
      scsi: ses: Retry failed Send/Receive Diagnostic commands

Zenghui Yu (1):
      scsi: bsg: Fix device unregistration

jing yangyang (1):
      scsi: megaraid: Fix Coccinelle warning

And the diffstat:

 MAINTAINERS                               |   7 --
 block/bsg.c                               |  23 +++---
 drivers/scsi/arm/Kconfig                  |  11 ---
 drivers/scsi/arm/acornscsi.c              | 103 ++++++--------------------
 drivers/scsi/arm/fas216.c                 |  31 +++-----
 drivers/scsi/arm/queue.c                  |   2 +-
 drivers/scsi/elx/efct/efct_lio.c          |   4 +-
 drivers/scsi/elx/libefc/efc_device.c      |   7 +-
 drivers/scsi/elx/libefc/efc_fabric.c      |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c             |  10 ++-
 drivers/scsi/lpfc/lpfc_els.c              |  10 +--
 drivers/scsi/lpfc/lpfc_hw4.h              |   2 +-
 drivers/scsi/lpfc/lpfc_init.c             |  20 +++---
 drivers/scsi/lpfc/lpfc_nvme.c             |   2 -
 drivers/scsi/lpfc/lpfc_scsi.c             |   9 +--
 drivers/scsi/lpfc/lpfc_sli.c              |   5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |   7 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c       |   4 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c        |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |   3 +-
 drivers/scsi/ncr53c8xx.c                  |  23 ------
 drivers/scsi/qla2xxx/qla_init.c           |   3 +-
 drivers/scsi/scsi_transport_iscsi.c       |   8 +--
 drivers/scsi/sd.c                         |  14 ++--
 drivers/scsi/sd_zbc.c                     |   8 +--
 drivers/scsi/ses.c                        |  22 ++++--
 drivers/scsi/sr_ioctl.c                   |   2 +-
 drivers/scsi/st.c                         |   1 +
 drivers/scsi/ufs/ufshcd-pci.c             |  78 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c                 | 116 +++++++++++++++---------------
 drivers/scsi/ufs/ufshcd.h                 |   5 ++
 drivers/scsi/ufs/ufshpb.c                 |   8 +--
 drivers/target/target_core_configfs.c     |  32 +++++----
 drivers/target/target_core_pr.c           |   2 +-
 include/scsi/scsi_device.h                |   1 -
 35 files changed, 288 insertions(+), 300 deletions(-)

with full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index eeb4c70b3d5b..fd12a39f92ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16650,13 +16650,6 @@ M:	Lubomir Rintel <lkundrak@v3.sk>
 S:	Supported
 F:	drivers/char/pcmcia/scr24x_cs.c
 
-SCSI CDROM DRIVER
-M:	Jens Axboe <axboe@kernel.dk>
-L:	linux-scsi@vger.kernel.org
-S:	Maintained
-W:	http://www.kernel.dk
-F:	drivers/scsi/sr*
-
 SCSI RDMA PROTOCOL (SRP) INITIATOR
 M:	Bart Van Assche <bvanassche@acm.org>
 L:	linux-rdma@vger.kernel.org
diff --git a/block/bsg.c b/block/bsg.c
index 351095193788..882f56bff14f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -165,13 +165,20 @@ static const struct file_operations bsg_fops = {
 	.llseek		=	default_llseek,
 };
 
+static void bsg_device_release(struct device *dev)
+{
+	struct bsg_device *bd = container_of(dev, struct bsg_device, device);
+
+	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
+	kfree(bd);
+}
+
 void bsg_unregister_queue(struct bsg_device *bd)
 {
 	if (bd->queue->kobj.sd)
 		sysfs_remove_link(&bd->queue->kobj, "bsg");
 	cdev_device_del(&bd->cdev, &bd->device);
-	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
-	kfree(bd);
+	put_device(&bd->device);
 }
 EXPORT_SYMBOL_GPL(bsg_unregister_queue);
 
@@ -193,11 +200,13 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	if (ret < 0) {
 		if (ret == -ENOSPC)
 			dev_err(parent, "bsg: too many bsg devices\n");
-		goto out_kfree;
+		kfree(bd);
+		return ERR_PTR(ret);
 	}
 	bd->device.devt = MKDEV(bsg_major, ret);
 	bd->device.class = bsg_class;
 	bd->device.parent = parent;
+	bd->device.release = bsg_device_release;
 	dev_set_name(&bd->device, "%s", name);
 	device_initialize(&bd->device);
 
@@ -205,7 +214,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	bd->cdev.owner = THIS_MODULE;
 	ret = cdev_device_add(&bd->cdev, &bd->device);
 	if (ret)
-		goto out_ida_remove;
+		goto out_put_device;
 
 	if (q->kobj.sd) {
 		ret = sysfs_create_link(&q->kobj, &bd->device.kobj, "bsg");
@@ -217,10 +226,8 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 
 out_device_del:
 	cdev_device_del(&bd->cdev, &bd->device);
-out_ida_remove:
-	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
-out_kfree:
-	kfree(bd);
+out_put_device:
+	put_device(&bd->device);
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(bsg_register_queue);
diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index f34badc75196..9f64133f976a 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -10,17 +10,6 @@ config SCSI_ACORNSCSI_3
 	  This enables support for the Acorn SCSI card (aka30). If you have an
 	  Acorn system with one of these, say Y. If unsure, say N.
 
-config SCSI_ACORNSCSI_TAGGED_QUEUE
-	bool "Support SCSI 2 Tagged queueing"
-	depends on SCSI_ACORNSCSI_3
-	help
-	  Say Y here to enable tagged queuing support on the Acorn SCSI card.
-
-	  This is a feature of SCSI-2 which improves performance: the host
-	  adapter can send several SCSI commands to a device's queue even if
-	  previous commands haven't finished yet. Some SCSI devices don't
-	  implement this properly, so the safe answer is N.
-
 config SCSI_ACORNSCSI_SYNC
 	bool "Support SCSI 2 Synchronous Transfers"
 	depends on SCSI_ACORNSCSI_3
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 4a84599ff491..b4cb5fb19998 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -52,12 +52,8 @@
  * You can tell if you have a device that supports tagged queueing my
  * cating (eg) /proc/scsi/acornscsi/0 and see if the SCSI revision is reported
  * as '2 TAG'.
- *
- * Also note that CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE is normally set in the config
- * scripts, but disabled here.  Once debugged, remove the #undef, otherwise to debug,
- * comment out the undef.
  */
-#undef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
+
 /*
  * SCSI-II Synchronous transfer support.
  *
@@ -171,7 +167,7 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 			   unsigned int result);
 static int acornscsi_reconnect_finish(AS_Host *host);
 static void acornscsi_dma_cleanup(AS_Host *host);
-static void acornscsi_abortcmd(AS_Host *host, unsigned char tag);
+static void acornscsi_abortcmd(AS_Host *host);
 
 /* ====================================================================================
  * Miscellaneous
@@ -741,17 +737,6 @@ intr_ret_t acornscsi_kick(AS_Host *host)
 #endif
 
     if (from_queue) {
-#ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
-	/*
-	 * tagged queueing - allocate a new tag to this command
-	 */
-	if (SCpnt->device->simple_tags) {
-	    SCpnt->device->current_tag += 1;
-	    if (SCpnt->device->current_tag == 0)
-		SCpnt->device->current_tag = 1;
-	    SCpnt->tag = SCpnt->device->current_tag;
-	} else
-#endif
 	    set_bit(SCpnt->device->id * 8 +
 		    (u8)(SCpnt->device->lun & 0x07), host->busyluns);
 
@@ -1192,7 +1177,7 @@ void acornscsi_dma_intr(AS_Host *host)
 	 * the device recognises the attention.
 	 */
 	if (dmac_read(host, DMAC_STATUS) & STATUS_RQ0) {
-	    acornscsi_abortcmd(host, host->SCpnt->tag);
+	    acornscsi_abortcmd(host);
 
 	    dmac_write(host, DMAC_TXCNTLO, 0);
 	    dmac_write(host, DMAC_TXCNTHI, 0);
@@ -1560,23 +1545,6 @@ void acornscsi_message(AS_Host *host)
 	    acornscsi_sbic_issuecmd(host, CMND_ASSERTATN);
 
 	switch (host->scsi.last_message) {
-#ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
-	case HEAD_OF_QUEUE_TAG:
-	case ORDERED_QUEUE_TAG:
-	case SIMPLE_QUEUE_TAG:
-	    /*
-	     * ANSI standard says: (Section SCSI-2 Rev. 10c Sect 5.6.17)
-	     *  If a target does not implement tagged queuing and a queue tag
-	     *  message is received, it shall respond with a MESSAGE REJECT
-	     *  message and accept the I/O process as if it were untagged.
-	     */
-	    printk(KERN_NOTICE "scsi%d.%c: disabling tagged queueing\n",
-		    host->host->host_no, acornscsi_target(host));
-	    host->SCpnt->device->simple_tags = 0;
-	    set_bit(host->SCpnt->device->id * 8 +
-		    (u8)(host->SCpnt->device->lun & 0x7), host->busyluns);
-	    break;
-#endif
 	case EXTENDED_MESSAGE | (EXTENDED_SDTR << 8):
 	    /*
 	     * Target can't handle synchronous transfers
@@ -1687,24 +1655,11 @@ void acornscsi_buildmessages(AS_Host *host)
 #if 0
     /* does the device need the current command aborted */
     if (cmd_aborted) {
-	acornscsi_abortcmd(host->SCpnt->tag);
+	acornscsi_abortcmd(host);
 	return;
     }
 #endif
 
-#ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
-    if (host->SCpnt->tag) {
-	unsigned int tag_type;
-
-	if (host->SCpnt->cmnd[0] == REQUEST_SENSE ||
-	    host->SCpnt->cmnd[0] == TEST_UNIT_READY ||
-	    host->SCpnt->cmnd[0] == INQUIRY)
-	    tag_type = HEAD_OF_QUEUE_TAG;
-	else
-	    tag_type = SIMPLE_QUEUE_TAG;
-	msgqueue_addmsg(&host->scsi.msgs, 2, tag_type, host->SCpnt->tag);
-    }
-#endif
 
 #ifdef CONFIG_SCSI_ACORNSCSI_SYNC
     if (host->device[host->SCpnt->device->id].sync_state == SYNC_NEGOCIATE) {
@@ -1798,7 +1753,7 @@ int acornscsi_reconnect(AS_Host *host)
 		"to reconnect with\n",
 		host->host->host_no, '0' + target);
 	acornscsi_dumplog(host, target);
-	acornscsi_abortcmd(host, 0);
+	acornscsi_abortcmd(host);
 	if (host->SCpnt) {
 	    queue_add_cmd_tail(&host->queues.disconnected, host->SCpnt);
 	    host->SCpnt = NULL;
@@ -1821,7 +1776,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
 	host->scsi.disconnectable = 0;
 	if (host->SCpnt->device->id  == host->scsi.reconnected.target &&
 	    host->SCpnt->device->lun == host->scsi.reconnected.lun &&
-	    host->SCpnt->tag         == host->scsi.reconnected.tag) {
+	    scsi_cmd_to_tag(host->SCpnt) == host->scsi.reconnected.tag) {
 #if (DEBUG & (DEBUG_QUEUES|DEBUG_DISCON))
 	    DBG(host->SCpnt, printk("scsi%d.%c: reconnected",
 		    host->host->host_no, acornscsi_target(host)));
@@ -1848,7 +1803,7 @@ int acornscsi_reconnect_finish(AS_Host *host)
     }
 
     if (!host->SCpnt)
-	acornscsi_abortcmd(host, host->scsi.reconnected.tag);
+	acornscsi_abortcmd(host);
     else {
 	/*
 	 * Restore data pointer from SAVED pointers.
@@ -1889,21 +1844,15 @@ void acornscsi_disconnect_unexpected(AS_Host *host)
  * Function: void acornscsi_abortcmd(AS_host *host, unsigned char tag)
  * Purpose : abort a currently executing command
  * Params  : host - host with connected command to abort
- *	     tag  - tag to abort
  */
 static
-void acornscsi_abortcmd(AS_Host *host, unsigned char tag)
+void acornscsi_abortcmd(AS_Host *host)
 {
     host->scsi.phase = PHASE_ABORTED;
     sbic_arm_write(host, SBIC_CMND, CMND_ASSERTATN);
 
     msgqueue_flush(&host->scsi.msgs);
-#ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
-    if (tag)
-	msgqueue_addmsg(&host->scsi.msgs, 2, ABORT_TAG, tag);
-    else
-#endif
-	msgqueue_addmsg(&host->scsi.msgs, 1, ABORT);
+    msgqueue_addmsg(&host->scsi.msgs, 1, ABORT);
 }
 
 /* ==========================================================================================
@@ -1993,7 +1942,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	    printk(KERN_ERR "scsi%d.%c: PHASE_CONNECTING, SSR %02X?\n",
 		    host->host->host_no, acornscsi_target(host), ssr);
 	    acornscsi_dumplog(host, host->SCpnt ? host->SCpnt->device->id : 8);
-	    acornscsi_abortcmd(host, host->SCpnt->tag);
+	    acornscsi_abortcmd(host);
 	}
 	return INTR_PROCESSING;
 
@@ -2029,7 +1978,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	    printk(KERN_ERR "scsi%d.%c: PHASE_CONNECTED, SSR %02X?\n",
 		    host->host->host_no, acornscsi_target(host), ssr);
 	    acornscsi_dumplog(host, host->SCpnt ? host->SCpnt->device->id : 8);
-	    acornscsi_abortcmd(host, host->SCpnt->tag);
+	    acornscsi_abortcmd(host);
 	}
 	return INTR_PROCESSING;
 
@@ -2075,20 +2024,20 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	case 0x18:			/* -> PHASE_DATAOUT				*/
 	    /* COMMAND -> DATA OUT */
 	    if (host->scsi.SCp.sent_command != host->SCpnt->cmd_len)
-		acornscsi_abortcmd(host, host->SCpnt->tag);
+		acornscsi_abortcmd(host);
 	    acornscsi_dma_setup(host, DMA_OUT);
 	    if (!acornscsi_starttransfer(host))
-		acornscsi_abortcmd(host, host->SCpnt->tag);
+		acornscsi_abortcmd(host);
 	    host->scsi.phase = PHASE_DATAOUT;
 	    return INTR_IDLE;
 
 	case 0x19:			/* -> PHASE_DATAIN				*/
 	    /* COMMAND -> DATA IN */
 	    if (host->scsi.SCp.sent_command != host->SCpnt->cmd_len)
-		acornscsi_abortcmd(host, host->SCpnt->tag);
+		acornscsi_abortcmd(host);
 	    acornscsi_dma_setup(host, DMA_IN);
 	    if (!acornscsi_starttransfer(host))
-		acornscsi_abortcmd(host, host->SCpnt->tag);
+		acornscsi_abortcmd(host);
 	    host->scsi.phase = PHASE_DATAIN;
 	    return INTR_IDLE;
 
@@ -2156,7 +2105,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	    /* MESSAGE IN -> DATA OUT */
 	    acornscsi_dma_setup(host, DMA_OUT);
 	    if (!acornscsi_starttransfer(host))
-		acornscsi_abortcmd(host, host->SCpnt->tag);
+		acornscsi_abortcmd(host);
 	    host->scsi.phase = PHASE_DATAOUT;
 	    return INTR_IDLE;
 
@@ -2165,7 +2114,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	    /* MESSAGE IN -> DATA IN */
 	    acornscsi_dma_setup(host, DMA_IN);
 	    if (!acornscsi_starttransfer(host))
-		acornscsi_abortcmd(host, host->SCpnt->tag);
+		acornscsi_abortcmd(host);
 	    host->scsi.phase = PHASE_DATAIN;
 	    return INTR_IDLE;
 
@@ -2206,7 +2155,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	switch (ssr) {
 	case 0x19:			/* -> PHASE_DATAIN				*/
 	case 0x89:			/* -> PHASE_DATAIN				*/
-	    acornscsi_abortcmd(host, host->SCpnt->tag);
+	    acornscsi_abortcmd(host);
 	    return INTR_IDLE;
 
 	case 0x1b:			/* -> PHASE_STATUSIN				*/
@@ -2255,7 +2204,7 @@ intr_ret_t acornscsi_sbicintr(AS_Host *host, int in_irq)
 	switch (ssr) {
 	case 0x18:			/* -> PHASE_DATAOUT				*/
 	case 0x88:			/* -> PHASE_DATAOUT				*/
-	    acornscsi_abortcmd(host, host->SCpnt->tag);
+	    acornscsi_abortcmd(host);
 	    return INTR_IDLE;
 
 	case 0x1b:			/* -> PHASE_STATUSIN				*/
@@ -2482,7 +2431,6 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
     SCpnt->scsi_done = done;
     SCpnt->host_scribble = NULL;
     SCpnt->result = 0;
-    SCpnt->tag = 0;
     SCpnt->SCp.phase = (int)acornscsi_datadirection(SCpnt->cmnd[0]);
     SCpnt->SCp.sent_command = 0;
     SCpnt->SCp.scsi_xferred = 0;
@@ -2581,7 +2529,7 @@ static enum res_abort acornscsi_do_abort(AS_Host *host, struct scsi_cmnd *SCpnt)
 			break;
 
 		default:
-			acornscsi_abortcmd(host, host->SCpnt->tag);
+			acornscsi_abortcmd(host);
 			res = res_snooze;
 		}
 		local_irq_restore(flags);
@@ -2747,9 +2695,6 @@ char *acornscsi_info(struct Scsi_Host *host)
 #ifdef CONFIG_SCSI_ACORNSCSI_SYNC
     " SYNC"
 #endif
-#ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
-    " TAG"
-#endif
 #if (DEBUG & DEBUG_NO_WRITE)
     " NOWRITE (" __stringify(NO_WRITE) ")"
 #endif
@@ -2770,9 +2715,6 @@ static int acornscsi_show_info(struct seq_file *m, struct Scsi_Host *instance)
 #ifdef CONFIG_SCSI_ACORNSCSI_SYNC
     " SYNC"
 #endif
-#ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
-    " TAG"
-#endif
 #if (DEBUG & DEBUG_NO_WRITE)
     " NOWRITE (" __stringify(NO_WRITE) ")"
 #endif
@@ -2827,9 +2769,8 @@ static int acornscsi_show_info(struct seq_file *m, struct Scsi_Host *instance)
 	seq_printf(m, "Device/Lun TaggedQ      Sync\n");
 	seq_printf(m, "     %d/%llu   ", scd->id, scd->lun);
 	if (scd->tagged_supported)
-		seq_printf(m, "%3sabled(%3d) ",
-			     scd->simple_tags ? "en" : "dis",
-			     scd->current_tag);
+		seq_printf(m, "%3sabled ",
+			     scd->simple_tags ? "en" : "dis");
 	else
 		seq_printf(m, "unsupported  ");
 
diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 9c4458a99025..cf71ef488e36 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -77,7 +77,6 @@
  *  I was thinking that this was a good chip until I found this restriction ;(
  */
 #define SCSI2_SYNC
-#undef  SCSI2_TAG
 
 #undef DEBUG_CONNECT
 #undef DEBUG_MESSAGES
@@ -990,7 +989,7 @@ fas216_reselected_intr(FAS216_Info *info)
 		info->scsi.disconnectable = 0;
 		if (info->SCpnt->device->id  == target &&
 		    info->SCpnt->device->lun == lun &&
-		    info->SCpnt->tag         == tag) {
+		    scsi_cmd_to_rq(info->SCpnt)->tag == tag) {
 			fas216_log(info, LOG_CONNECT, "reconnected previously executing command");
 		} else {
 			queue_add_cmd_tail(&info->queues.disconnected, info->SCpnt);
@@ -1791,8 +1790,9 @@ static void fas216_start_command(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 	/*
 	 * add tag message if required
 	 */
-	if (SCpnt->tag)
-		msgqueue_addmsg(&info->scsi.msgs, 2, SIMPLE_QUEUE_TAG, SCpnt->tag);
+	if (SCpnt->device->simple_tags)
+		msgqueue_addmsg(&info->scsi.msgs, 2, SIMPLE_QUEUE_TAG,
+				scsi_cmd_to_rq(SCpnt)->tag);
 
 	do {
 #ifdef SCSI2_SYNC
@@ -1815,20 +1815,8 @@ static void fas216_start_command(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 
 static void fas216_allocate_tag(FAS216_Info *info, struct scsi_cmnd *SCpnt)
 {
-#ifdef SCSI2_TAG
-	/*
-	 * tagged queuing - allocate a new tag to this command
-	 */
-	if (SCpnt->device->simple_tags && SCpnt->cmnd[0] != REQUEST_SENSE &&
-	    SCpnt->cmnd[0] != INQUIRY) {
-	    SCpnt->device->current_tag += 1;
-		if (SCpnt->device->current_tag == 0)
-		    SCpnt->device->current_tag = 1;
-			SCpnt->tag = SCpnt->device->current_tag;
-	} else
-#endif
-		set_bit(SCpnt->device->id * 8 +
-			(u8)(SCpnt->device->lun & 0x7), info->busyluns);
+	set_bit(SCpnt->device->id * 8 +
+		(u8)(SCpnt->device->lun & 0x7), info->busyluns);
 
 	info->stats.removes += 1;
 	switch (SCpnt->cmnd[0]) {
@@ -2117,7 +2105,6 @@ fas216_std_done(FAS216_Info *info, struct scsi_cmnd *SCpnt, unsigned int result)
 	init_SCp(SCpnt);
 	SCpnt->SCp.Message = 0;
 	SCpnt->SCp.Status = 0;
-	SCpnt->tag = 0;
 	SCpnt->host_scribble = (void *)fas216_rq_sns_done;
 
 	/*
@@ -2223,7 +2210,6 @@ static int fas216_queue_command_lck(struct scsi_cmnd *SCpnt,
 	init_SCp(SCpnt);
 
 	info->stats.queues += 1;
-	SCpnt->tag = 0;
 
 	spin_lock(&info->host_lock);
 
@@ -3003,9 +2989,8 @@ void fas216_print_devices(FAS216_Info *info, struct seq_file *m)
 		dev = &info->device[scd->id];
 		seq_printf(m, "     %d/%llu   ", scd->id, scd->lun);
 		if (scd->tagged_supported)
-			seq_printf(m, "%3sabled(%3d) ",
-				     scd->simple_tags ? "en" : "dis",
-				     scd->current_tag);
+			seq_printf(m, "%3sabled ",
+				     scd->simple_tags ? "en" : "dis");
 		else
 			seq_puts(m, "unsupported   ");
 
diff --git a/drivers/scsi/arm/queue.c b/drivers/scsi/arm/queue.c
index e5559f27669d..c6f71a7d1b8e 100644
--- a/drivers/scsi/arm/queue.c
+++ b/drivers/scsi/arm/queue.c
@@ -214,7 +214,7 @@ struct scsi_cmnd *queue_remove_tgtluntag(Queue_t *queue, int target, int lun,
 	list_for_each(l, &queue->head) {
 		QE_t *q = list_entry(l, QE_t, list);
 		if (q->SCpnt->device->id == target && q->SCpnt->device->lun == lun &&
-		    q->SCpnt->tag == tag) {
+		    scsi_cmd_to_rq(q->SCpnt)->tag == tag) {
 			SCpnt = __queue_remove(queue, l);
 			break;
 		}
diff --git a/drivers/scsi/elx/efct/efct_lio.c b/drivers/scsi/elx/efct/efct_lio.c
index bb3b460dc0bc..4d73e92909ab 100644
--- a/drivers/scsi/elx/efct/efct_lio.c
+++ b/drivers/scsi/elx/efct/efct_lio.c
@@ -880,11 +880,11 @@ efct_lio_npiv_drop_nport(struct se_wwn *wwn)
 	struct efct *efct = lio_vport->efct;
 	unsigned long flags = 0;
 
-	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
-
 	if (lio_vport->fc_vport)
 		fc_vport_terminate(lio_vport->fc_vport);
 
+	spin_lock_irqsave(&efct->tgt_efct.efct_lio_lock, flags);
+
 	list_for_each_entry_safe(vport, next_vport, &efct->tgt_efct.vport_list,
 				 list_entry) {
 		if (vport->lio_vport == lio_vport) {
diff --git a/drivers/scsi/elx/libefc/efc_device.c b/drivers/scsi/elx/libefc/efc_device.c
index 725ca2a23fb2..52be01333c6e 100644
--- a/drivers/scsi/elx/libefc/efc_device.c
+++ b/drivers/scsi/elx/libefc/efc_device.c
@@ -928,22 +928,21 @@ __efc_d_wait_topology_notify(struct efc_sm_ctx *ctx,
 		break;
 
 	case EFC_EVT_NPORT_TOPOLOGY_NOTIFY: {
-		enum efc_nport_topology topology =
-					(enum efc_nport_topology)arg;
+		enum efc_nport_topology *topology = arg;
 
 		WARN_ON(node->nport->domain->attached);
 
 		WARN_ON(node->send_ls_acc != EFC_NODE_SEND_LS_ACC_PLOGI);
 
 		node_printf(node, "topology notification, topology=%d\n",
-			    topology);
+			    *topology);
 
 		/* At the time the PLOGI was received, the topology was unknown,
 		 * so we didn't know which node would perform the domain attach:
 		 * 1. The node from which the PLOGI was sent (p2p) or
 		 * 2. The node to which the FLOGI was sent (fabric).
 		 */
-		if (topology == EFC_NPORT_TOPO_P2P) {
+		if (*topology == EFC_NPORT_TOPO_P2P) {
 			/* if this is p2p, need to attach to the domain using
 			 * the d_id from the PLOGI received
 			 */
diff --git a/drivers/scsi/elx/libefc/efc_fabric.c b/drivers/scsi/elx/libefc/efc_fabric.c
index d397220d9e54..3270ce40196c 100644
--- a/drivers/scsi/elx/libefc/efc_fabric.c
+++ b/drivers/scsi/elx/libefc/efc_fabric.c
@@ -107,7 +107,6 @@ void
 efc_fabric_notify_topology(struct efc_node *node)
 {
 	struct efc_node *tmp_node;
-	enum efc_nport_topology topology = node->nport->topology;
 	unsigned long index;
 
 	/*
@@ -118,7 +117,7 @@ efc_fabric_notify_topology(struct efc_node *node)
 		if (tmp_node != node) {
 			efc_node_post_event(tmp_node,
 					    EFC_EVT_NPORT_TOPOLOGY_NOTIFY,
-					    (void *)topology);
+					    &node->nport->topology);
 		}
 	}
 }
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index b35bf70a8c0d..ebe417921dac 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -285,11 +285,8 @@ lpfc_cmf_info_show(struct device *dev, struct device_attribute *attr,
 				"6312 Catching potential buffer "
 				"overflow > PAGE_SIZE = %lu bytes\n",
 				PAGE_SIZE);
-		strscpy(buf + PAGE_SIZE - 1 -
-			strnlen(LPFC_INFO_MORE_STR, PAGE_SIZE - 1),
-			LPFC_INFO_MORE_STR,
-			strnlen(LPFC_INFO_MORE_STR, PAGE_SIZE - 1)
-			+ 1);
+		strscpy(buf + PAGE_SIZE - 1 - sizeof(LPFC_INFO_MORE_STR),
+			LPFC_INFO_MORE_STR, sizeof(LPFC_INFO_MORE_STR) + 1);
 	}
 	return len;
 }
@@ -6204,7 +6201,8 @@ lpfc_sg_seg_cnt_show(struct device *dev, struct device_attribute *attr,
 	len = scnprintf(buf, PAGE_SIZE, "SGL sz: %d  total SGEs: %d\n",
 		       phba->cfg_sg_dma_buf_size, phba->cfg_total_seg_cnt);
 
-	len += scnprintf(buf + len, PAGE_SIZE, "Cfg: %d  SCSI: %d  NVME: %d\n",
+	len += scnprintf(buf + len, PAGE_SIZE - len,
+			"Cfg: %d  SCSI: %d  NVME: %d\n",
 			phba->cfg_sg_seg_cnt, phba->cfg_scsi_seg_cnt,
 			phba->cfg_nvme_seg_cnt);
 	return len;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 1254a575fd47..052c0e5b1119 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4015,11 +4015,11 @@ lpfc_cmpl_els_edc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				be32_to_cpu(pcgd->desc_tag),
 				be32_to_cpu(pcgd->desc_len),
 				be32_to_cpu(pcgd->xmt_signal_capability),
-				be32_to_cpu(pcgd->xmt_signal_frequency.count),
-				be32_to_cpu(pcgd->xmt_signal_frequency.units),
+				be16_to_cpu(pcgd->xmt_signal_frequency.count),
+				be16_to_cpu(pcgd->xmt_signal_frequency.units),
 				be32_to_cpu(pcgd->rcv_signal_capability),
-				be32_to_cpu(pcgd->rcv_signal_frequency.count),
-				be32_to_cpu(pcgd->rcv_signal_frequency.units));
+				be16_to_cpu(pcgd->rcv_signal_frequency.count),
+				be16_to_cpu(pcgd->rcv_signal_frequency.units));
 
 			/* Compare driver and Fport capabilities and choose
 			 * least common.
@@ -9387,7 +9387,7 @@ lpfc_display_fpin_wwpn(struct lpfc_hba *phba, __be64 *wwnlist, u32 cnt)
 		/* Extract the next WWPN from the payload */
 		wwn = *wwnlist++;
 		wwpn = be64_to_cpu(wwn);
-		len += scnprintf(buf + len, LPFC_FPIN_WWPN_LINE_SZ,
+		len += scnprintf(buf + len, LPFC_FPIN_WWPN_LINE_SZ - len,
 				 " %016llx", wwpn);
 
 		/* Log a message if we are on the last WWPN
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 79a4872c2edb..7359505e6041 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -1167,7 +1167,7 @@ struct lpfc_mbx_read_object {  /* Version 0 */
 #define lpfc_mbx_rd_object_rlen_MASK	0x00FFFFFF
 #define lpfc_mbx_rd_object_rlen_WORD	word0
 			uint32_t rd_object_offset;
-			uint32_t rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW];
+			__le32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW];
 #define LPFC_OBJ_NAME_SZ 104   /* 26 x sizeof(uint32_t) is 104. */
 			uint32_t rd_object_cnt;
 			struct lpfc_mbx_host_buf rd_object_hbuf[4];
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0ec322f0e3cb..195169badb37 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5518,7 +5518,7 @@ lpfc_cgn_update_stat(struct lpfc_hba *phba, uint32_t dtag)
 	if (phba->cgn_fpin_frequency &&
 	    phba->cgn_fpin_frequency != LPFC_FPIN_INIT_FREQ) {
 		value = LPFC_CGN_TIMER_TO_MIN / phba->cgn_fpin_frequency;
-		cp->cgn_stat_npm = cpu_to_le32(value);
+		cp->cgn_stat_npm = value;
 	}
 	value = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ,
 				    LPFC_CGN_CRC32_SEED);
@@ -5547,9 +5547,9 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 	uint32_t mbps;
 	uint32_t dvalue, wvalue, lvalue, avalue;
 	uint64_t latsum;
-	uint16_t *ptr;
-	uint32_t *lptr;
-	uint16_t *mptr;
+	__le16 *ptr;
+	__le32 *lptr;
+	__le16 *mptr;
 
 	/* Make sure we have a congestion info buffer */
 	if (!phba->cgn_i)
@@ -5570,7 +5570,7 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 	if (phba->cgn_fpin_frequency &&
 	    phba->cgn_fpin_frequency != LPFC_FPIN_INIT_FREQ) {
 		value = LPFC_CGN_TIMER_TO_MIN / phba->cgn_fpin_frequency;
-		cp->cgn_stat_npm = cpu_to_le32(value);
+		cp->cgn_stat_npm = value;
 	}
 
 	/* Read and clear the latency counters for this minute */
@@ -5753,7 +5753,7 @@ lpfc_cgn_save_evt_cnt(struct lpfc_hba *phba)
 			dvalue += le32_to_cpu(cp->cgn_drvr_hr[i]);
 			wvalue += le32_to_cpu(cp->cgn_warn_hr[i]);
 			lvalue += le32_to_cpu(cp->cgn_latency_hr[i]);
-			mbps += le32_to_cpu(cp->cgn_bw_hr[i]);
+			mbps += le16_to_cpu(cp->cgn_bw_hr[i]);
 			avalue += le32_to_cpu(cp->cgn_alarm_hr[i]);
 		}
 		if (lvalue)		/* Avg of latency averages */
@@ -8277,11 +8277,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 	return 0;
 
 out_free_hba_hdwq_info:
-	free_percpu(phba->sli4_hba.c_stat);
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
+	free_percpu(phba->sli4_hba.c_stat);
 out_free_hba_idle_stat:
-	kfree(phba->sli4_hba.idle_stat);
 #endif
+	kfree(phba->sli4_hba.idle_stat);
 out_free_hba_eq_info:
 	free_percpu(phba->sli4_hba.eq_info);
 out_free_hba_cpu_map:
@@ -13411,8 +13411,8 @@ lpfc_init_congestion_buf(struct lpfc_hba *phba)
 
 	/* last used Index initialized to 0xff already */
 
-	cp->cgn_warn_freq = LPFC_FPIN_INIT_FREQ;
-	cp->cgn_alarm_freq = LPFC_FPIN_INIT_FREQ;
+	cp->cgn_warn_freq = cpu_to_le16(LPFC_FPIN_INIT_FREQ);
+	cp->cgn_alarm_freq = cpu_to_le16(LPFC_FPIN_INIT_FREQ);
 	crc = lpfc_cgn_calc_crc32(cp, LPFC_CGN_INFO_SZ, LPFC_CGN_CRC32_SEED);
 	cp->cgn_info_crc = cpu_to_le32(crc);
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 73a3568ff17e..479b3eed6208 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1489,9 +1489,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nvme_qhandle *lpfc_queue_info;
 	struct lpfc_nvme_fcpreq_priv *freqpriv;
 	struct nvme_common_command *sqe;
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t start = 0;
-#endif
 
 	/* Validate pointers. LLDD fault handling with transport does
 	 * have timing races.
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 0fde1e874c7a..befdf864c43b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1495,7 +1495,6 @@ static int
 lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		uint8_t *txop, uint8_t *rxop)
 {
-	uint8_t ret = 0;
 
 	if (sc->prot_flags & SCSI_PROT_IP_CHECKSUM) {
 		switch (scsi_get_prot_op(sc)) {
@@ -1548,7 +1547,7 @@ lpfc_bg_err_opcodes(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 #endif
 
@@ -5578,12 +5577,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	struct fc_rport *rport = starget_to_rport(scsi_target(cmnd->device));
 	int err, idx;
 	u8 *uuid = NULL;
-#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-	uint64_t start = 0L;
+	uint64_t start;
 
-	if (phba->ktime_on)
-		start = ktime_get_ns();
-#endif
 	start = ktime_get_ns();
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ffd8a140638c..78ce38d7251c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -22090,6 +22090,7 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	struct lpfc_dmabuf *pcmd;
+	u32 rd_object_name[LPFC_MBX_OBJECT_NAME_LEN_DW] = {0};
 
 	/* sanity check on queue memory */
 	if (!datap)
@@ -22113,10 +22114,10 @@ lpfc_read_object(struct lpfc_hba *phba, char *rdobject, uint32_t *datap,
 
 	memset((void *)read_object->u.request.rd_object_name, 0,
 	       LPFC_OBJ_NAME_SZ);
-	sprintf((uint8_t *)read_object->u.request.rd_object_name, rdobject);
+	scnprintf((char *)rd_object_name, sizeof(rd_object_name), rdobject);
 	for (j = 0; j < strlen(rdobject); j++)
 		read_object->u.request.rd_object_name[j] =
-			cpu_to_le32(read_object->u.request.rd_object_name[j]);
+			cpu_to_le32(rd_object_name[j]);
 
 	pcmd = kmalloc(sizeof(*pcmd), GFP_KERNEL);
 	if (pcmd)
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4298bf4a482..39d8754e63ac 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1916,7 +1916,7 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
 		raid = MR_LdRaidGet(ld, local_map_ptr);
 
 		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
-		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
+			blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
 
 		mr_device_priv_data->is_tm_capable =
 			raid->capability.tmCapable;
@@ -8033,7 +8033,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	if (instance->adapter_type != MFI_SERIES) {
 		megasas_release_fusion(instance);
-			pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
+		pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
 				(sizeof(struct MR_PD_CFG_SEQ) *
 					(MAX_PHYSICAL_DEVICES - 1));
 		for (i = 0; i < 2 ; i++) {
@@ -8773,8 +8773,7 @@ int megasas_update_device_list(struct megasas_instance *instance,
 
 		if (event_type & SCAN_VD_CHANNEL) {
 			if (!instance->requestorId ||
-			    (instance->requestorId &&
-			     megasas_get_ld_vf_affiliation(instance, 0))) {
+			megasas_get_ld_vf_affiliation(instance, 0)) {
 				dcmd_ret = megasas_ld_list_query(instance,
 						MR_LD_QUERY_TYPE_EXPOSED_TO_HOST);
 				if (dcmd_ret != DCMD_SUCCESS)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 6c82435bc9cc..27eb652b564f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1582,8 +1582,10 @@ mpt3sas_base_pause_mq_polling(struct MPT3SAS_ADAPTER *ioc)
 	 * wait for current poll to complete.
 	 */
 	for (qid = 0; qid < iopoll_q_count; qid++) {
-		while (atomic_read(&ioc->io_uring_poll_queues[qid].busy))
+		while (atomic_read(&ioc->io_uring_poll_queues[qid].busy)) {
+			cpu_relax();
 			udelay(500);
+		}
 	}
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 770b241d7bb2..1b79f01f03a4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2178,7 +2178,7 @@ mpt3sas_send_diag_release(struct MPT3SAS_ADAPTER *ioc, u8 buffer_type,
 		mpt3sas_check_cmd_timeout(ioc,
 		    ioc->ctl_cmds.status, mpi_request,
 		    sizeof(Mpi2DiagReleaseRequest_t)/4, reset_needed);
-		 *issue_reset = reset_needed;
+		*issue_reset = reset_needed;
 		rc = -EFAULT;
 		goto out;
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 2f82b1e629af..d383d4a03436 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10749,8 +10749,7 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct fw_event_work *fw_event)
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
 		_scsih_pcie_topology_change_event(ioc, fw_event);
 		ioc->current_event = NULL;
-			return;
-	break;
+		return;
 	}
 out:
 	fw_event_work_put(fw_event);
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 7a4f5d4dd670..2b8c6fa5e775 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -1939,11 +1939,8 @@ static	void	ncr_start_next_ccb (struct ncb *np, struct lcb * lp, int maxn);
 static	void	ncr_put_start_queue(struct ncb *np, struct ccb *cp);
 
 static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cmd);
-static struct scsi_cmnd *retrieve_from_waiting_list(int to_remove, struct ncb *np, struct scsi_cmnd *cmd);
 static void process_waiting_list(struct ncb *np, int sts);
 
-#define remove_from_waiting_list(np, cmd) \
-		retrieve_from_waiting_list(1, (np), (cmd))
 #define requeue_waiting_list(np) process_waiting_list((np), DID_OK)
 #define reset_waiting_list(np) process_waiting_list((np), DID_RESET)
 
@@ -7997,26 +7994,6 @@ static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cmd)
 	}
 }
 
-static struct scsi_cmnd *retrieve_from_waiting_list(int to_remove, struct ncb *np, struct scsi_cmnd *cmd)
-{
-	struct scsi_cmnd **pcmd = &np->waiting_list;
-
-	while (*pcmd) {
-		if (cmd == *pcmd) {
-			if (to_remove) {
-				*pcmd = (struct scsi_cmnd *) cmd->next_wcmd;
-				cmd->next_wcmd = NULL;
-			}
-#ifdef DEBUG_WAITING_LIST
-	printk("%s: cmd %lx retrieved from waiting list\n", ncr_name(np), (u_long) cmd);
-#endif
-			return cmd;
-		}
-		pcmd = (struct scsi_cmnd **) &(*pcmd)->next_wcmd;
-	}
-	return NULL;
-}
-
 static void process_waiting_list(struct ncb *np, int sts)
 {
 	struct scsi_cmnd *waiting_list, *wcmd;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 1e4e3e83b5c7..5fc7697f0af4 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -7169,7 +7169,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 				return 0;
 			break;
 		case QLA2XXX_INI_MODE_DUAL:
-			if (!qla_dual_mode_enabled(vha))
+			if (!qla_dual_mode_enabled(vha) &&
+			    !qla_ini_mode_enabled(vha))
 				return 0;
 			break;
 		case QLA2XXX_INI_MODE_ENABLED:
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index d8b05d8b5470..922e4c7bd88e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -441,9 +441,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	struct iscsi_transport *t = iface->transport;
 	int param = -1;
 
-	if (attr == &dev_attr_iface_enabled.attr)
-		param = ISCSI_NET_PARAM_IFACE_ENABLE;
-	else if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
+	if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
 		param = ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
 	else if (attr == &dev_attr_iface_header_digest.attr)
 		param = ISCSI_IFACE_PARAM_HDRDGST_EN;
@@ -483,7 +481,9 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	if (param != -1)
 		return t->attr_is_visible(ISCSI_IFACE_PARAM, param);
 
-	if (attr == &dev_attr_iface_vlan_id.attr)
+	if (attr == &dev_attr_iface_enabled.attr)
+		param = ISCSI_NET_PARAM_IFACE_ENABLE;
+	else if (attr == &dev_attr_iface_vlan_id.attr)
 		param = ISCSI_NET_PARAM_VLAN_ID;
 	else if (attr == &dev_attr_iface_vlan_priority.attr)
 		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index cbd9999f93a6..523bf2fdc253 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2124,6 +2124,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		retries = 0;
 
 		do {
+			bool media_was_present = sdkp->media_present;
+
 			cmd[0] = TEST_UNIT_READY;
 			memset((void *) &cmd[1], 0, 9);
 
@@ -2138,7 +2140,8 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * with any more polling.
 			 */
 			if (media_not_present(sdkp, &sshdr)) {
-				sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
+				if (media_was_present)
+					sd_printk(KERN_NOTICE, sdkp, "Media removed, stopped polling\n");
 				return;
 			}
 
@@ -3401,15 +3404,16 @@ static int sd_probe(struct device *dev)
 	}
 
 	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = dev;
+	sdkp->dev.parent = get_device(dev);
 	sdkp->dev.class = &sd_disk_class;
 	dev_set_name(&sdkp->dev, "%s", dev_name(dev));
 
 	error = device_add(&sdkp->dev);
-	if (error)
-		goto out_free_index;
+	if (error) {
+		put_device(&sdkp->dev);
+		goto out;
+	}
 
-	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
 	gd->major = sd_major((index & 0xf0) >> 4);
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index b9757f24b0d6..ed06798983f8 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -154,8 +154,8 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 
 	/*
 	 * Report zone buffer size should be at most 64B times the number of
-	 * zones requested plus the 64B reply header, but should be at least
-	 * SECTOR_SIZE for ATA devices.
+	 * zones requested plus the 64B reply header, but should be aligned
+	 * to SECTOR_SIZE for ATA devices.
 	 * Make sure that this size does not exceed the hardware capabilities.
 	 * Furthermore, since the report zone command cannot be split, make
 	 * sure that the allocated buffer can always be mapped by limiting the
@@ -174,7 +174,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 			*buflen = bufsize;
 			return buf;
 		}
-		bufsize >>= 1;
+		bufsize = rounddown(bufsize >> 1, SECTOR_SIZE);
 	}
 
 	return NULL;
@@ -280,7 +280,7 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 {
 	struct scsi_disk *sdkp;
 	unsigned long flags;
-	unsigned int zno;
+	sector_t zno;
 	int ret;
 
 	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..43e682297fd5 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -87,9 +87,16 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 		0
 	};
 	unsigned char recv_page_code;
+	unsigned int retries = SES_RETRIES;
+	struct scsi_sense_hdr sshdr;
+
+	do {
+		ret = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
+				       &sshdr, SES_TIMEOUT, 1, NULL);
+	} while (ret > 0 && --retries && scsi_sense_valid(&sshdr) &&
+		 (sshdr.sense_key == NOT_READY ||
+		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	ret =  scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buf, bufflen,
-				NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (unlikely(ret))
 		return ret;
 
@@ -121,9 +128,16 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 		bufflen & 0xff,
 		0
 	};
+	struct scsi_sense_hdr sshdr;
+	unsigned int retries = SES_RETRIES;
+
+	do {
+		result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
+					  &sshdr, SES_TIMEOUT, 1, NULL);
+	} while (result > 0 && --retries && scsi_sense_valid(&sshdr) &&
+		 (sshdr.sense_key == NOT_READY ||
+		  (sshdr.sense_key == UNIT_ATTENTION && sshdr.asc == 0x29)));
 
-	result = scsi_execute_req(sdev, cmd, DMA_TO_DEVICE, buf, bufflen,
-				  NULL, SES_TIMEOUT, SES_RETRIES, NULL);
 	if (result)
 		sdev_printk(KERN_ERR, sdev, "SEND DIAGNOSTIC result: %8x\n",
 			    result);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 79d9aa2df528..ddd00efc4882 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -523,7 +523,7 @@ static int sr_read_sector(Scsi_CD *cd, int lba, int blksize, unsigned char *dest
 			return rc;
 		cd->readcd_known = 0;
 		sr_printk(KERN_INFO, cd,
-			  "CDROM does'nt support READ CD (0xbe) command\n");
+			  "CDROM doesn't support READ CD (0xbe) command\n");
 		/* fall & retry the other way */
 	}
 	/* ... if this fails, we switch the blocksize using MODE SELECT */
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9d04929f03a1..ae8636d3780b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3823,6 +3823,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 	case CDROM_SEND_PACKET:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index b3bcc5c882da..149c1aa09103 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -128,6 +128,81 @@ static int ufs_intel_link_startup_notify(struct ufs_hba *hba,
 	return err;
 }
 
+static int ufs_intel_set_lanes(struct ufs_hba *hba, u32 lanes)
+{
+	struct ufs_pa_layer_attr pwr_info = hba->pwr_info;
+	int ret;
+
+	pwr_info.lane_rx = lanes;
+	pwr_info.lane_tx = lanes;
+	ret = ufshcd_config_pwr_mode(hba, &pwr_info);
+	if (ret)
+		dev_err(hba->dev, "%s: Setting %u lanes, err = %d\n",
+			__func__, lanes, ret);
+	return ret;
+}
+
+static int ufs_intel_lkf_pwr_change_notify(struct ufs_hba *hba,
+				enum ufs_notify_change_status status,
+				struct ufs_pa_layer_attr *dev_max_params,
+				struct ufs_pa_layer_attr *dev_req_params)
+{
+	int err = 0;
+
+	switch (status) {
+	case PRE_CHANGE:
+		if (ufshcd_is_hs_mode(dev_max_params) &&
+		    (hba->pwr_info.lane_rx != 2 || hba->pwr_info.lane_tx != 2))
+			ufs_intel_set_lanes(hba, 2);
+		memcpy(dev_req_params, dev_max_params, sizeof(*dev_req_params));
+		break;
+	case POST_CHANGE:
+		if (ufshcd_is_hs_mode(dev_req_params)) {
+			u32 peer_granularity;
+
+			usleep_range(1000, 1250);
+			err = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY),
+						  &peer_granularity);
+		}
+		break;
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static int ufs_intel_lkf_apply_dev_quirks(struct ufs_hba *hba)
+{
+	u32 granularity, peer_granularity;
+	u32 pa_tactivate, peer_pa_tactivate;
+	int ret;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_GRANULARITY), &granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_GRANULARITY), &peer_granularity);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &pa_tactivate);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_TACTIVATE), &peer_pa_tactivate);
+	if (ret)
+		goto out;
+
+	if (granularity == peer_granularity) {
+		u32 new_peer_pa_tactivate = pa_tactivate + 2;
+
+		ret = ufshcd_dme_peer_set(hba, UIC_ARG_MIB(PA_TACTIVATE), new_peer_pa_tactivate);
+	}
+out:
+	return ret;
+}
+
 #define INTEL_ACTIVELTR		0x804
 #define INTEL_IDLELTR		0x808
 
@@ -351,6 +426,7 @@ static int ufs_intel_lkf_init(struct ufs_hba *hba)
 	struct ufs_host *ufs_host;
 	int err;
 
+	hba->nop_out_timeout = 200;
 	hba->quirks |= UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8;
 	hba->caps |= UFSHCD_CAP_CRYPTO;
 	err = ufs_intel_common_init(hba);
@@ -381,6 +457,8 @@ static struct ufs_hba_variant_ops ufs_intel_lkf_hba_vops = {
 	.exit			= ufs_intel_common_exit,
 	.hce_enable_notify	= ufs_intel_hce_enable_notify,
 	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.pwr_change_notify	= ufs_intel_lkf_pwr_change_notify,
+	.apply_dev_quirks	= ufs_intel_lkf_apply_dev_quirks,
 	.resume			= ufs_intel_resume,
 	.device_reset		= ufs_intel_device_reset,
 };
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..029c9631ec2b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -17,8 +17,6 @@
 #include <linux/blk-pm.h>
 #include <linux/blkdev.h>
 #include <scsi/scsi_driver.h>
-#include <scsi/scsi_transport.h>
-#include "../scsi_transport_api.h"
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -237,6 +235,7 @@ static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
+static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
 static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
 static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
@@ -2759,8 +2758,13 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 out:
 	up_read(&hba->clk_scaling_lock);
 
-	if (ufs_trigger_eh())
-		scsi_schedule_eh(hba->host);
+	if (ufs_trigger_eh()) {
+		unsigned long flags;
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		ufshcd_schedule_eh_work(hba);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
 
 	return err;
 }
@@ -3919,35 +3923,6 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 }
 EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
 
-static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
-{
-	lockdep_assert_held(hba->host->host_lock);
-
-	return (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR) ||
-	       (hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
-}
-
-static void ufshcd_schedule_eh(struct ufs_hba *hba)
-{
-	bool schedule_eh = false;
-	unsigned long flags;
-
-	spin_lock_irqsave(hba->host->host_lock, flags);
-	/* handle fatal errors only when link is not in error state */
-	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
-		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
-		    ufshcd_is_saved_err_fatal(hba))
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
-		else
-			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
-		schedule_eh = true;
-	}
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (schedule_eh)
-		scsi_schedule_eh(hba->host);
-}
-
 /**
  * ufshcd_uic_pwr_ctrl - executes UIC commands (which affects the link power
  * state) and waits for it to take effect.
@@ -3968,7 +3943,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(uic_async_done);
 	unsigned long flags;
-	bool schedule_eh = false;
 	u8 status;
 	int ret;
 	bool reenable_intr = false;
@@ -4038,14 +4012,10 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	if (ret) {
 		ufshcd_set_link_broken(hba);
-		schedule_eh = true;
+		ufshcd_schedule_eh_work(hba);
 	}
-
 out_unlock:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-
-	if (schedule_eh)
-		ufshcd_schedule_eh(hba);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
 	return ret;
@@ -4776,7 +4746,7 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 	mutex_lock(&hba->dev_cmd.lock);
 	for (retries = NOP_OUT_RETRIES; retries > 0; retries--) {
 		err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_NOP,
-					       NOP_OUT_TIMEOUT);
+					  hba->nop_out_timeout);
 
 		if (!err || err == -ETIMEDOUT)
 			break;
@@ -5911,6 +5881,27 @@ static bool ufshcd_quirk_dl_nac_errors(struct ufs_hba *hba)
 	return err_handling;
 }
 
+/* host lock must be held before calling this func */
+static inline bool ufshcd_is_saved_err_fatal(struct ufs_hba *hba)
+{
+	return (hba->saved_uic_err & UFSHCD_UIC_DL_PA_INIT_ERROR) ||
+	       (hba->saved_err & (INT_FATAL_ERRORS | UFSHCD_UIC_HIBERN8_MASK));
+}
+
+/* host lock must be held before calling this func */
+static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
+{
+	/* handle fatal errors only when link is not in error state */
+	if (hba->ufshcd_state != UFSHCD_STATE_ERROR) {
+		if (hba->force_reset || ufshcd_is_link_broken(hba) ||
+		    ufshcd_is_saved_err_fatal(hba))
+			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
+		else
+			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_NON_FATAL;
+		queue_work(hba->eh_wq, &hba->eh_work);
+	}
+}
+
 static void ufshcd_clk_scaling_allow(struct ufs_hba *hba, bool allow)
 {
 	down_write(&hba->clk_scaling_lock);
@@ -6044,11 +6035,11 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
- * @host: SCSI host pointer
+ * @work: pointer to work structure
  */
-static void ufshcd_err_handler(struct Scsi_Host *host)
+static void ufshcd_err_handler(struct work_struct *work)
 {
-	struct ufs_hba *hba = shost_priv(host);
+	struct ufs_hba *hba;
 	unsigned long flags;
 	bool err_xfer = false;
 	bool err_tm = false;
@@ -6056,9 +6047,10 @@ static void ufshcd_err_handler(struct Scsi_Host *host)
 	int tag;
 	bool needs_reset = false, needs_restore = false;
 
+	hba = container_of(work, struct ufs_hba, eh_work);
+
 	down(&hba->host_sem);
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	hba->host->host_eh_scheduled = 0;
 	if (ufshcd_err_handling_should_stop(hba)) {
 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
@@ -6371,6 +6363,7 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 					 "host_regs: ");
 			ufshcd_print_pwr_info(hba);
 		}
+		ufshcd_schedule_eh_work(hba);
 		retval |= IRQ_HANDLED;
 	}
 	/*
@@ -6382,10 +6375,6 @@ static irqreturn_t ufshcd_check_errors(struct ufs_hba *hba, u32 intr_status)
 	hba->errors = 0;
 	hba->uic_error = 0;
 	spin_unlock(hba->host->host_lock);
-
-	if (queue_eh_work)
-		ufshcd_schedule_eh(hba);
-
 	return retval;
 }
 
@@ -6876,7 +6865,7 @@ static int ufshcd_eh_device_reset_handler(struct scsi_cmnd *cmd)
 			err = ufshcd_clear_cmd(hba, pos);
 			if (err)
 				break;
-			__ufshcd_transfer_req_compl(hba, pos, /*retry_requests=*/true);
+			__ufshcd_transfer_req_compl(hba, 1U << pos, false);
 		}
 	}
 
@@ -7048,17 +7037,15 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * will be to send LU reset which, again, is a spec violation.
 	 * To avoid these unnecessary/illegal steps, first we clean up
 	 * the lrb taken by this cmd and re-set it in outstanding_reqs,
-	 * then queue the error handler and bail.
+	 * then queue the eh_work and bail.
 	 */
 	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
 		ufshcd_update_evt_hist(hba, UFS_EVT_ABORT, lrbp->lun);
 
 		spin_lock_irqsave(host->host_lock, flags);
 		hba->force_reset = true;
+		ufshcd_schedule_eh_work(hba);
 		spin_unlock_irqrestore(host->host_lock, flags);
-
-		ufshcd_schedule_eh(hba);
-
 		goto release;
 	}
 
@@ -7191,10 +7178,11 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->force_reset = true;
+	ufshcd_schedule_eh_work(hba);
 	dev_err(hba->dev, "%s: reset in progress - 1\n", __func__);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	ufshcd_err_handler(hba->host);
+	flush_work(&hba->eh_work);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	if (hba->ufshcd_state == UFSHCD_STATE_ERROR)
@@ -8604,6 +8592,8 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	if (hba->is_powered) {
 		ufshcd_exit_clk_scaling(hba);
 		ufshcd_exit_clk_gating(hba);
+		if (hba->eh_wq)
+			destroy_workqueue(hba->eh_wq);
 		ufs_debugfs_hba_exit(hba);
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
@@ -9448,10 +9438,6 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hba)
 	return dma_set_mask_and_coherent(hba->dev, DMA_BIT_MASK(32));
 }
 
-static struct scsi_transport_template ufshcd_transport_template = {
-	.eh_strategy_handler = ufshcd_err_handler,
-};
-
 /**
  * ufshcd_alloc_host - allocate Host Bus Adapter (HBA)
  * @dev: pointer to device handle
@@ -9478,11 +9464,11 @@ int ufshcd_alloc_host(struct device *dev, struct ufs_hba **hba_handle)
 		err = -ENOMEM;
 		goto out_error;
 	}
-	host->transportt = &ufshcd_transport_template;
 	hba = shost_priv(host);
 	hba->host = host;
 	hba->dev = dev;
 	hba->dev_ref_clk_freq = REF_CLK_FREQ_INVAL;
+	hba->nop_out_timeout = NOP_OUT_TIMEOUT;
 	INIT_LIST_HEAD(&hba->clk_list_head);
 	spin_lock_init(&hba->outstanding_lock);
 
@@ -9517,6 +9503,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	int err;
 	struct Scsi_Host *host = hba->host;
 	struct device *dev = hba->dev;
+	char eh_wq_name[sizeof("ufs_eh_wq_00")];
 
 	if (!mmio_base) {
 		dev_err(hba->dev,
@@ -9570,6 +9557,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	hba->max_pwr_info.is_valid = false;
 
+	/* Initialize work queues */
+	snprintf(eh_wq_name, sizeof(eh_wq_name), "ufs_eh_wq_%d",
+		 hba->host->host_no);
+	hba->eh_wq = create_singlethread_workqueue(eh_wq_name);
+	if (!hba->eh_wq) {
+		dev_err(hba->dev, "%s: failed to create eh workqueue\n",
+			__func__);
+		err = -ENOMEM;
+		goto out_disable;
+	}
+	INIT_WORK(&hba->eh_work, ufshcd_err_handler);
 	INIT_WORK(&hba->eeh_work, ufshcd_exception_event_handler);
 
 	sema_init(&hba->host_sem, 1);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 52ea6f350b18..f0da5d3db1fa 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -741,6 +741,8 @@ struct ufs_hba_monitor {
  * @is_powered: flag to check if HBA is powered
  * @shutting_down: flag to check if shutdown has been invoked
  * @host_sem: semaphore used to serialize concurrent contexts
+ * @eh_wq: Workqueue that eh_work works on
+ * @eh_work: Worker to handle UFS errors that require s/w attention
  * @eeh_work: Worker to handle exception events
  * @errors: HBA errors
  * @uic_error: UFS interconnect layer error status
@@ -843,6 +845,8 @@ struct ufs_hba {
 	struct semaphore host_sem;
 
 	/* Work Queues */
+	struct workqueue_struct *eh_wq;
+	struct work_struct eh_work;
 	struct work_struct eeh_work;
 
 	/* HBA Errors */
@@ -858,6 +862,7 @@ struct ufs_hba {
 	/* Device management request data */
 	struct ufs_dev_cmd dev_cmd;
 	ktime_t last_dme_cmd_tstamp;
+	int nop_out_timeout;
 
 	/* Keeps information of the UFS device connected to this host */
 	struct ufs_dev_info dev_info;
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 02fb51ae8b25..589af5f6b940 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -333,9 +333,8 @@ ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn, int *rgn_idx,
 }
 
 static void
-ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshpb_lu *hpb,
-			    struct ufshcd_lrb *lrbp, u32 lpn, __be64 ppn,
-			    u8 transfer_len, int read_id)
+ufshpb_set_hpb_read_to_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
+			    __be64 ppn, u8 transfer_len, int read_id)
 {
 	unsigned char *cdb = lrbp->cmd->cmnd;
 	__be64 ppn_tmp = ppn;
@@ -703,8 +702,7 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		}
 	}
 
-	ufshpb_set_hpb_read_to_upiu(hba, hpb, lrbp, lpn, ppn, transfer_len,
-				    read_id);
+	ufshpb_set_hpb_read_to_upiu(hba, lrbp, ppn, transfer_len, read_id);
 
 	hpb->stats.hit_cnt++;
 	return 0;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 102ec644bc8a..023bd4516a68 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1110,20 +1110,24 @@ static ssize_t alua_support_store(struct config_item *item,
 {
 	struct se_dev_attrib *da = to_attrib(item);
 	struct se_device *dev = da->da_dev;
-	bool flag;
+	bool flag, oldflag;
 	int ret;
 
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	oldflag = !(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA);
+	if (flag == oldflag)
+		return count;
+
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_ALUA)) {
 		pr_err("dev[%p]: Unable to change SE Device alua_support:"
 			" alua_support has fixed value\n", dev);
-		return -EINVAL;
+		return -ENOSYS;
 	}
 
-	ret = strtobool(page, &flag);
-	if (ret < 0)
-		return ret;
-
 	if (flag)
 		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_ALUA;
 	else
@@ -1145,20 +1149,24 @@ static ssize_t pgr_support_store(struct config_item *item,
 {
 	struct se_dev_attrib *da = to_attrib(item);
 	struct se_device *dev = da->da_dev;
-	bool flag;
+	bool flag, oldflag;
 	int ret;
 
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	oldflag = !(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR);
+	if (flag == oldflag)
+		return count;
+
 	if (!(dev->transport->transport_flags_changeable &
 	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
 		pr_err("dev[%p]: Unable to change SE Device pgr_support:"
 			" pgr_support has fixed value\n", dev);
-		return -EINVAL;
+		return -ENOSYS;
 	}
 
-	ret = strtobool(page, &flag);
-	if (ret < 0)
-		return ret;
-
 	if (flag)
 		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_PGR;
 	else
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 4b94b085625b..3829b61b56c1 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -269,7 +269,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	spin_lock(&dev->dev_reservation_lock);
 	if (dev->reservation_holder &&
 	    dev->reservation_holder->se_node_acl != sess->se_node_acl) {
-		pr_err("SCSI-2 RESERVATION CONFLIFT for %s fabric\n",
+		pr_err("SCSI-2 RESERVATION CONFLICT for %s fabric\n",
 			tpg->se_tpg_tfo->fabric_name);
 		pr_err("Original reserver LUN: %llu %s\n",
 			cmd->se_lun->unpacked_lun,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 09a17f6e93a7..b97e142a7ca9 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -146,7 +146,6 @@ struct scsi_device {
 	struct scsi_vpd __rcu *vpd_pg83;
 	struct scsi_vpd __rcu *vpd_pg80;
 	struct scsi_vpd __rcu *vpd_pg89;
-	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;
 
 	blist_flags_t		sdev_bflags; /* black/white flags as also found in

