Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E300DC432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 17:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC9520674
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 17:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfKZRC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 12:02:27 -0500
Received: from verein.lst.de ([213.95.11.211]:41738 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbfKZRC1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 12:02:27 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BFA6C68C4E; Tue, 26 Nov 2019 18:02:23 +0100 (CET)
Date:   Tue, 26 Nov 2019 18:02:23 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Balsundar P <balsundar.p@microsemi.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: Re: [PATCH 04/11] aacraid: Do not wait for outstanding write
 commands on synchronize_cache
Message-ID: <20191126170223.GF8204@lst.de>
References: <20191120103114.24723-1-hare@suse.de> <20191120103114.24723-5-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120103114.24723-5-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 20, 2019 at 11:31:07AM +0100, Hannes Reinecke wrote:
> There is no need to wait for outstanding write commands on synchronize
> cache; the block layer is responsible for I/O scheduling, no need
> to out-guess it on the driver layer.

So I think this doesn't make any sense as it doesn't fit the SCSI
SYNCRONIZE CACHE or Linux flush semantics, but i'd really like to hear
from the Microsemi folks.

FYI, below is the rather inconclusive commit from the history tree that
added this code originally:

---
From 45b95e26fd0e7dd6c38e424ee650becc15fe5975 Mon Sep 17 00:00:00 2001
From: Mark Haverkamp <markh@osdl.org>
Date: Sat, 22 Jan 2005 21:12:43 -0600
Subject: [PATCH] aacraid 2.6: add scsi synchronize cache support.

This is an update from the Adaptec driver that adds support for the scsi
synchronize cache command.  It essentially blocks further commands until
data has been flushed to the disks.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/aacraid/aachba.c  | 113 +++++++++++++++++++++++++++++++++
 drivers/scsi/aacraid/aacraid.h |  24 +++++++
 2 files changed, 137 insertions(+)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 514caa9adc2c..782776243b96 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -1029,6 +1029,114 @@ static int aac_write(struct scsi_cmnd * scsicmd, int cid)
 	return 0;
 }
 
+static void synchronize_callback(void *context, struct fib *fibptr)
+{
+	struct aac_synchronize_reply *synchronizereply;
+	struct scsi_cmnd *cmd;
+
+	cmd = context;
+
+	dprintk((KERN_DEBUG "synchronize_callback[cpu %d]: t = %ld.\n", 
+				smp_processor_id(), jiffies));
+	BUG_ON(fibptr == NULL);
+
+
+	synchronizereply = fib_data(fibptr);
+	if (le32_to_cpu(synchronizereply->status) == CT_OK)
+		cmd->result = DID_OK << 16 | 
+			COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+	else {
+		struct scsi_device *sdev = cmd->device;
+		struct aac_dev *dev = (struct aav_dev *)sdev->host->hostdata;
+		u32 cid = ID_LUN_TO_CONTAINER(sdev->id, sdev->lun);
+		printk(KERN_WARNING 
+		     "synchronize_callback: synchronize failed, status = %d\n",
+		     synchronizereply->status);
+		cmd->result = DID_OK << 16 | 
+			COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
+		set_sense((u8 *)&dev->fsa_dev[cid].sense_data,
+				    HARDWARE_ERROR,
+				    SENCODE_INTERNAL_TARGET_FAILURE,
+				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
+				    0, 0);
+		memcpy(cmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		  min(sizeof(dev->fsa_dev[cid].sense_data), 
+			  sizeof(cmd->sense_buffer)));
+	}
+
+	fib_complete(fibptr);
+	fib_free(fibptr);
+	aac_io_done(cmd);
+}
+
+static int aac_synchronize(struct scsi_cmnd *scsicmd, int cid)
+{
+	int status;
+	struct fib *cmd_fibcontext;
+	struct aac_synchronize *synchronizecmd;
+	struct scsi_cmnd *cmd;
+	struct scsi_device *sdev = scsicmd->device;
+	int active = 0;
+	unsigned long flags;
+
+	/*
+	 * Wait for all commands to complete to this specific
+	 * target (block).
+	 */
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	list_for_each_entry(cmd, &sdev->cmd_list, list)
+		if (cmd != scsicmd && cmd->serial_number != 0) {
+			++active;
+			break;
+		}
+
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+
+	/*
+	 *	Yield the processor (requeue for later)
+	 */
+	if (active)
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+
+	/*
+	 *	Alocate and initialize a Fib
+	 */
+	if (!(cmd_fibcontext = 
+	    fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) 
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	fib_init(cmd_fibcontext);
+
+	synchronizecmd = fib_data(cmd_fibcontext);
+	synchronizecmd->command = cpu_to_le32(VM_ContainerConfig);
+	synchronizecmd->type = cpu_to_le32(CT_FLUSH_CACHE);
+	synchronizecmd->cid = cpu_to_le32(cid);
+	synchronizecmd->count = 
+	     cpu_to_le32(sizeof(((struct aac_synchronize_reply *)NULL)->data));
+
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	status = fib_send(ContainerCommand,
+		  cmd_fibcontext,
+		  sizeof(struct aac_synchronize),
+		  FsaNormal,
+		  0, 1,
+		  (fib_callback)synchronize_callback,
+		  (void *)scsicmd);
+
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS)
+		return 0;
+
+	printk(KERN_WARNING 
+		"aac_synchronize: fib_send failed with status: %d.\n", status);
+	fib_complete(cmd_fibcontext);
+	fib_free(cmd_fibcontext);
+	return SCSI_MLQUEUE_HOST_BUSY;
+}
 
 /**
  *	aac_scsi_cmd()		-	Process SCSI command
@@ -1274,6 +1382,11 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			ret = aac_write(scsicmd, cid);
 			spin_lock_irq(host->host_lock);
 			return ret;
+
+		case SYNCHRONIZE_CACHE:
+			/* Issue FIB to tell Firmware to flush it's cache */
+			return aac_synchronize(scsicmd, cid);
+			
 		default:
 			/*
 			 *	Unhandled commands
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 987222ef30e1..7309129568b6 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1069,6 +1069,30 @@ struct aac_write_reply
 	u32		committed;
 };
 
+#define CT_FLUSH_CACHE 129
+struct aac_synchronize {
+	u32		command;	/* VM_ContainerConfig */
+	u32		type;		/* CT_FLUSH_CACHE */
+	u32		cid;
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		count;	/* sizeof(((struct aac_synchronize_reply *)NULL)->data) */
+};
+
+struct aac_synchronize_reply {
+	u32		dummy0;
+	u32		dummy1;
+	u32		status;	/* CT_OK */
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		parm5;
+	u8		data[16];
+};
+
 struct aac_srb
 {
 	u32		function;
-- 
2.20.1

