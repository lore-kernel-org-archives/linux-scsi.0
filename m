From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 7/7] aacraid: Improved error handling
Date: Thu, 15 Mar 2007 10:27:45 -0700
Message-ID: <1173979665.30374.27.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60858 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXCOR1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 13:27:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

This set of fixes improve error handling stability of the driver. A popular
manifestation of the problems is an NULL pointer reference in the interrupt
handler when referencing portions of the scsi command context, or in the
scsi_done handling when an offlined device is referenced.

The aacraid driver currently does not get notification of orphaned command
completions due to devices going offline. The driver also fails to handle the
commands that are finished by the error handler, and thus can complete again
later at the hands of the adapter causing situations of completion of an
invalid scsi command context. Test Unit Ready calls abort assuming that the
abort was successful, but are not, and thus when the interrupt from the adapter
occurs, they reference invalid command contexts. We add in a TIMED_OUT flag to
inform the aacraid FIB context that the interrupt service should merely release
the driver resources and not complete the command up. We take advantage of this
with the abort handler as well for select abortable commands. And we detect and
react if a command that can not be aborted is currently still outstanding to
the controller when reissued by the retry mechanism.

Signed-off-by: Mark Haverkamp <markh@linux-foundation.org>

---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2007-03-15 08:30:19.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2007-03-15 08:30:23.000000000 -0700
@@ -5,7 +5,7 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -172,6 +172,30 @@ MODULE_PARM_DESC(acbsize, "Request a spe
 int expose_physicals = -1;
 module_param(expose_physicals, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(expose_physicals, "Expose physical components of the arrays. -1=protect 0=off, 1=on");
+
+
+static inline int aac_valid_context(struct scsi_cmnd *scsicmd,
+		struct fib *fibptr) {
+	struct scsi_device *device;
+
+	if (unlikely(!scsicmd || !scsicmd->scsi_done )) {
+		dprintk((KERN_WARNING "aac_valid_context: scsi command corrupt\n"))
+;
+                aac_fib_complete(fibptr);
+                aac_fib_free(fibptr);
+                return 0;
+        }
+	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
+	device = scsicmd->device;
+	if (unlikely(!device || !scsi_device_online(device))) {
+		dprintk((KERN_WARNING "aac_valid_context: scsi device corrupt\n"));
+		aac_fib_complete(fibptr);
+		aac_fib_free(fibptr);
+		return 0;
+	}
+	return 1;
+}
+
 /**
  *	aac_get_config_status	-	check the adapter configuration
  *	@common: adapter to query
@@ -342,6 +366,9 @@ static void get_container_name_callback(
 	scsicmd = (struct scsi_cmnd *) context;
 	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 
+	if (!aac_valid_context(scsicmd, fibptr))
+		return;
+
 	dprintk((KERN_DEBUG "get_container_name_callback[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies));
 	BUG_ON(fibptr == NULL);
 
@@ -431,9 +458,14 @@ static int aac_probe_container_callback2
 
 static int _aac_probe_container2(void * context, struct fib * fibptr)
 {
-	struct scsi_cmnd * scsicmd = (struct scsi_cmnd *)context;
-	struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
+	struct fsa_dev_info *fsa_dev_ptr;
 	int (*callback)(struct scsi_cmnd *);
+	struct scsi_cmnd * scsicmd = (struct scsi_cmnd *)context;
+
+	if (!aac_valid_context(scsicmd, fibptr))
+		return 0;
+
+	fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
 
 	scsicmd->SCp.Status = 0;
 	if (fsa_dev_ptr) {
@@ -477,6 +509,9 @@ static int _aac_probe_container1(void * 
 	scsicmd = (struct scsi_cmnd *) context;
 	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 
+	if (!aac_valid_context(scsicmd, fibptr))
+		return 0;
+
 	aac_fib_init(fibptr);
 
 	dinfo = (struct aac_query_mount *)fib_data(fibptr);
@@ -1287,6 +1322,9 @@ static void io_callback(void *context, s
 	scsicmd = (struct scsi_cmnd *) context;
 	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 
+	if (!aac_valid_context(scsicmd, fibptr))
+		return;
+
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	cid = scmd_id(scsicmd);
 
@@ -1534,6 +1572,9 @@ static void synchronize_callback(void *c
 	cmd = context;
 	cmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 
+	if (!aac_valid_context(cmd, fibptr))
+		return;
+
 	dprintk((KERN_DEBUG "synchronize_callback[cpu %d]: t = %ld.\n", 
 				smp_processor_id(), jiffies));
 	BUG_ON(fibptr == NULL);
@@ -2086,6 +2127,10 @@ static void aac_srb_callback(void *conte
 
 	scsicmd = (struct scsi_cmnd *) context;
 	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
+
+	if (!aac_valid_context(scsicmd, fibptr))
+		return;
+
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
 	BUG_ON(fibptr == NULL);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2007-03-15 08:30:12.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2007-03-15 08:30:23.000000000 -0700
@@ -971,7 +971,6 @@ struct aac_dev
 	struct fib              *fibs;
 
 	struct fib		*free_fib;
-	struct fib		*timeout_fib;
 	spinlock_t		fib_lock;
 	
 	struct aac_queue_block *queues;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2007-03-15 08:30:16.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2007-03-15 08:30:23.000000000 -0700
@@ -5,7 +5,7 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -178,7 +178,6 @@ struct fib *aac_fib_alloc(struct aac_dev
  *	@fibptr: fib to free up
  *
  *	Frees up a fib and places it on the appropriate queue
- *	(either free or timed out)
  */
  
 void aac_fib_free(struct fib *fibptr)
@@ -186,19 +185,15 @@ void aac_fib_free(struct fib *fibptr)
 	unsigned long flags;
 
 	spin_lock_irqsave(&fibptr->dev->fib_lock, flags);
-	if (fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT) {
+	if (unlikely(fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
 		aac_config.fib_timeouts++;
-		fibptr->next = fibptr->dev->timeout_fib;
-		fibptr->dev->timeout_fib = fibptr;
-	} else {
-		if (fibptr->hw_fib_va->header.XferState != 0) {
-			printk(KERN_WARNING "aac_fib_free, XferState != 0, fibptr = 0x%p, XferState = 0x%x\n",
-				 (void*)fibptr, 
-				 le32_to_cpu(fibptr->hw_fib_va->header.XferState));
-		}
-		fibptr->next = fibptr->dev->free_fib;
-		fibptr->dev->free_fib = fibptr;
-	}	
+	if (fibptr->hw_fib_va->header.XferState != 0) {
+		printk(KERN_WARNING "aac_fib_free, XferState != 0, fibptr = 0x%p, XferState = 0x%x\n",
+			 (void*)fibptr,
+			 le32_to_cpu(fibptr->hw_fib_va->header.XferState));
+	}
+	fibptr->next = fibptr->dev->free_fib;
+	fibptr->dev->free_fib = fibptr;
 	spin_unlock_irqrestore(&fibptr->dev->fib_lock, flags);
 }
 
--- scsi-misc-aac.orig/drivers/scsi/aacraid/dpcsup.c	2007-03-15 08:30:12.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/dpcsup.c	2007-03-15 08:30:23.000000000 -0700
@@ -5,7 +5,7 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -84,11 +84,13 @@ unsigned int aac_response_normal(struct 
 		 *	continue. The caller has already been notified that
 		 *	the fib timed out.
 		 */
-		if (!(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
-			dev->queues->queue[AdapNormCmdQueue].numpending--;
-		else {
-			printk(KERN_WARNING "aacraid: FIB timeout (%x).\n", fib->flags);
-			printk(KERN_DEBUG"aacraid: hwfib=%p fib index=%i fib=%p\n",hwfib, hwfib->header.SenderData,fib);
+		dev->queues->queue[AdapNormCmdQueue].numpending--;
+
+		if (unlikely(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
+			spin_unlock_irqrestore(q->lock, flags);
+			aac_fib_complete(fib);
+			aac_fib_free(fib);
+			spin_lock_irqsave(q->lock, flags);
 			continue;
 		}
 		spin_unlock_irqrestore(q->lock, flags);
@@ -281,14 +283,14 @@ unsigned int aac_intr_normal(struct aac_
 		 *	continue. The caller has already been notified that
 		 *	the fib timed out.
 		 */
-		if ((fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
-			printk(KERN_WARNING "aacraid: FIB timeout (%x).\n", fib->flags);
-			printk(KERN_DEBUG"aacraid: hwfib=%p index=%i fib=%p\n",hwfib, hwfib->header.SenderData,fib);
+		dev->queues->queue[AdapNormCmdQueue].numpending--;
+
+		if (unlikely(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
+			aac_fib_complete(fib);
+			aac_fib_free(fib);
 			return 0;
 		}
 
-		dev->queues->queue[AdapNormCmdQueue].numpending--;
-
 		if (fast) {
 			/*
 			 *	Doctor the fib
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2007-03-15 08:27:58.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2007-03-15 08:30:23.000000000 -0700
@@ -5,7 +5,7 @@
  * based on the old aacraid driver that is..
  * Adaptec aacraid device driver for Linux.
  *
- * Copyright (c) 2000 Adaptec, Inc. (aacraid@adaptec.com)
+ * Copyright (c) 2000-2007 Adaptec, Inc. (aacraid@adaptec.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -247,6 +247,19 @@ static struct aac_driver_ident aac_drive
 
 static int aac_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 {
+	struct Scsi_Host *host = cmd->device->host;
+	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
+	u32 count = 0;
+	cmd->scsi_done = done;
+	for (; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
+		struct fib * fib = &dev->fibs[count];
+		struct scsi_cmnd * command;
+		if (fib->hw_fib_va->header.XferState &&
+		    ((command = fib->callback_data)) &&
+		    (command == cmd) &&
+		    (cmd->SCp.phase == AAC_OWNER_FIRMWARE))
+			return 0; /* Already owned by Adapter */
+	}
 	cmd->scsi_done = done;
 	cmd->SCp.phase = AAC_OWNER_LOWLEVEL;
 	return (aac_scsi_cmd(cmd) ? FAILED : 0);
@@ -446,6 +459,40 @@ static int aac_ioctl(struct scsi_device 
 	return aac_do_ioctl(dev, cmd, arg);
 }
 
+static int aac_eh_abort(struct scsi_cmnd* cmd)
+{
+	struct Scsi_Host * host = cmd->device->host;
+	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
+	int count;
+	int ret = FAILED;
+
+	printk(KERN_ERR "%s: Host adapter abort request (%d,%d,%d,%d)\n",
+		AAC_DRIVERNAME,
+		cmd->device->host->host_no, sdev_channel(cmd->device),
+		sdev_id(cmd->device), cmd->device->lun);
+	switch (cmd->cmnd[0]) {
+	case SERVICE_ACTION_IN:
+		if (!(aac->raw_io_interface) ||
+		    !(aac->raw_io_64) ||
+		    ((cmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
+			break;
+	case INQUIRY:
+	case READ_CAPACITY:
+	case TEST_UNIT_READY:
+		/* Mark associated FIB to not complete, eh handler does this */
+		for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
+			struct fib * fib = &aac->fibs[count];
+			if (fib->hw_fib_va->header.XferState &&
+			  (fib->callback_data == cmd)) {
+				fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+				ret = SUCCESS;
+			}
+		}
+	}
+	return ret;
+}
+
 /*
  *	aac_eh_reset	- Reset command handling
  *	@scsi_cmd:	SCSI command block causing the reset
@@ -457,12 +504,20 @@ static int aac_eh_reset(struct scsi_cmnd
 	struct Scsi_Host * host = dev->host;
 	struct scsi_cmnd * command;
 	int count;
-	struct aac_dev * aac;
+	struct aac_dev * aac = (struct aac_dev *)host->hostdata;
 	unsigned long flags;
 
+	/* Mark the associated FIB to not complete, eh handler does this */
+	for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
+		struct fib * fib = &aac->fibs[count];
+		if (fib->hw_fib_va->header.XferState &&
+		  (fib->callback_data == cmd)) {
+			fib->flags |= FIB_CONTEXT_FLAG_TIMED_OUT;
+			cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
+		}
+	}
 	printk(KERN_ERR "%s: Host adapter reset request. SCSI hang ?\n", 
 					AAC_DRIVERNAME);
-	aac = (struct aac_dev *)host->hostdata;
 
 	if ((count = aac_check_health(aac)))
 		return count;
@@ -496,7 +551,7 @@ static int aac_eh_reset(struct scsi_cmnd
 		ssleep(1);
 	}
 	printk(KERN_ERR "%s: SCSI bus appears hung\n", AAC_DRIVERNAME);
-	return -ETIMEDOUT;
+	return SUCCESS; /* Cause an immediate retry of the command with a ten second delay after successful tur */
 }
 
 /**
@@ -796,6 +851,7 @@ static struct scsi_host_template aac_dri
 	.bios_param     		= aac_biosparm,	
 	.shost_attrs			= aac_attrs,
 	.slave_configure		= aac_slave_configure,
+	.eh_abort_handler		= aac_eh_abort,
 	.eh_host_reset_handler		= aac_eh_reset,
 	.can_queue      		= AAC_NUM_IO_FIB,	
 	.this_id        		= MAXIMUM_NUM_CONTAINERS,

-- 
Mark Haverkamp <markh@linux-foundation.org>

