From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] aacraid 2.6: add scsi synchronize cache support.
	(Update)
Date: Thu, 20 Jan 2005 09:03:10 -0800
Message-ID: <1106240590.436.10.camel@markh1.pdx.osdl.net>
References: <1106172102.11875.18.camel@markh1.pdx.osdl.net>
	 <20050120113132.GA391@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:10423 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S262238AbVATRD3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 12:03:29 -0500
In-Reply-To: <20050120113132.GA391@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Christoph,

On Thu, 2005-01-20 at 11:31 +0000, Christoph Hellwig wrote:

Fixed whitespace, 80 column wrap, casts, braces, parenthesis, etc.

> 
> > +		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
> 
> sense_data is u8 already.
sense_data is "struct sense_data" and I get a compiler warning without
the cast.

> 
> > +		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
> > +		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
> > +		    ? sizeof(scsicmd->sense_buffer)
> > +		    : sizeof(dev->fsa_dev[cid].sense_data));
> 
> Use max here?
I think min() is what is needed here.
--

James,
If this addresses Christoph's issues, here is the updated patch.

-----
This is an update from the Adaptec driver that adds support for the scsi
synchronize cache command.  It essentially blocks further commands until
data has been flushed to the disks.

Signed-off-by: Mark Haverkamp <markh@osdl.org>



===== drivers/scsi/aacraid/aachba.c 1.32 vs edited =====
--- 1.32/drivers/scsi/aacraid/aachba.c	2005-01-07 21:44:25 -08:00
+++ edited/drivers/scsi/aacraid/aachba.c	2005-01-20 08:51:37 -08:00
@@ -1029,6 +1029,114 @@
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
@@ -1274,6 +1382,11 @@
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
===== drivers/scsi/aacraid/aacraid.h 1.28 vs edited =====
--- 1.28/drivers/scsi/aacraid/aacraid.h	2004-12-27 10:28:37 -08:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2005-01-19 10:48:23 -08:00
@@ -1069,6 +1069,30 @@
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
Mark Haverkamp <markh@osdl.org>

