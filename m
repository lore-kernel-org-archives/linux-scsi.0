From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] aacraid 2.6: add scsi synchronize cache support.
Date: Wed, 19 Jan 2005 14:01:42 -0800
Message-ID: <1106172102.11875.18.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:52408 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261926AbVASWBq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 17:01:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

This is an update from the adaptec driver that adds support for the scsi
synchronize cache command.  It essentially blocks further commands until
data has been flushed to the disks.

Signed-off-by: Mark Havekamp <markh@osdl.org>



===== drivers/scsi/aacraid/aachba.c 1.31 vs edited =====
--- 1.31/drivers/scsi/aacraid/aachba.c	2004-10-21 09:53:08 -07:00
+++ edited/drivers/scsi/aacraid/aachba.c	2005-01-06 13:15:17 -08:00
@@ -1029,6 +1029,112 @@
 	return 0;
 }
 
+static void synchronize_callback(void *context, struct fib * fibptr)
+{
+	struct aac_synchronize_reply * synchronizereply;
+	struct scsi_cmnd * scsicmd;
+
+	scsicmd = (struct scsi_cmnd *) context;
+
+	dprintk((KERN_DEBUG "synchronize_callback[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies));
+	if (fibptr == NULL)
+		BUG();
+
+
+	synchronizereply = (struct aac_synchronize_reply *) fib_data(fibptr);
+	if (le32_to_cpu(synchronizereply->status) == CT_OK) {
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+	} else {
+		struct scsi_device * device = scsicmd->device;
+		struct aac_dev *dev = (struct aac_dev *)device->host->hostdata;
+		u32 cid = ID_LUN_TO_CONTAINER(device->id, device->lun);
+		printk(KERN_WARNING "synchronize_callback: synchronize failed, status = %d\n", synchronizereply->status);
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
+		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
+				    HARDWARE_ERROR,
+				    SENCODE_INTERNAL_TARGET_FAILURE,
+				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
+				    0, 0);
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(dev->fsa_dev[cid].sense_data));
+	}
+
+	fib_complete(fibptr);
+	fib_free(fibptr);
+	aac_io_done(scsicmd);
+}
+
+static int aac_synchronize(struct scsi_cmnd * scsicmd, int cid)
+{
+	int status;
+	struct fib * cmd_fibcontext;
+	struct aac_synchronize * synchronizecmd;
+
+	/*
+	 * Wait for all commands to complete to this specific
+	 * target (block).
+	 */
+	struct scsi_cmnd * cmd;
+	struct scsi_device * device = scsicmd->device;
+	int active = 0;
+	unsigned long flags;
+	spin_lock_irqsave(&device->list_lock, flags);
+	list_for_each_entry(cmd, &device->cmd_list, list) {
+		if ((cmd != scsicmd) && (cmd->serial_number != 0)) {
+			++active;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&device->list_lock, flags);
+	if (active) {
+		/*
+		 *	Yield the processor (requeue for later)
+		 */
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	}
+
+/* XXX */printk(KERN_DEBUG "aac_synchronize[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies);
+/* XXX 	dprintk((KERN_DEBUG "aac_synchronize[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies)); */
+	/*
+	 *	Alocate and initialize a Fib
+	 */
+	if (!(cmd_fibcontext = fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) {
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
+	fib_init(cmd_fibcontext);
+
+	synchronizecmd = (struct aac_synchronize *) fib_data(cmd_fibcontext);
+	synchronizecmd->command = cpu_to_le32(VM_ContainerConfig);
+	synchronizecmd->type = cpu_to_le32(CT_FLUSH_CACHE);
+	synchronizecmd->cid = cpu_to_le32(cid);
+	synchronizecmd->count = cpu_to_le32(sizeof(((struct aac_synchronize_reply *)NULL)->data));
+
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	status = fib_send(ContainerCommand,
+		  cmd_fibcontext,
+		  sizeof(struct aac_synchronize),
+		  FsaNormal,
+		  0, 1,
+		  (fib_callback) synchronize_callback,
+		  (void *) scsicmd);
+
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS) {
+		return 0;
+	}
+
+	printk(KERN_WARNING "aac_synchronize: fib_send failed with status: %d.\n", status);
+	fib_complete(cmd_fibcontext);
+	fib_free(cmd_fibcontext);
+	return SCSI_MLQUEUE_HOST_BUSY;
+}
 
 /**
  *	aac_scsi_cmd()		-	Process SCSI command
@@ -1274,6 +1380,11 @@
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
+++ edited/drivers/scsi/aacraid/aacraid.h	2005-01-06 08:17:45 -08:00
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

