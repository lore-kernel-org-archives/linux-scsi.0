From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 4/4] aacraid:  rework packet support code
Date: Tue, 23 Jan 2007 15:00:30 -0800
Message-ID: <1169593230.10440.25.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33786 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965575AbXAWXAg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jan 2007 18:00:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

Replace all if/else packet formations with platform function calls. This is in
recognition of the proliferation of read and write packet types, and in the
need to migrate to up-and-coming packets for new products.

Signed-off-by Mark Haverkamp <markh@linux-foundation.org>
---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2007-01-18 10:11:26.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2007-01-18 10:11:30.000000000 -0800
@@ -706,6 +706,309 @@
 	}
 }
 
+static int aac_bounds_32(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba)
+{
+	if (lba & 0xffffffff00000000LL) {
+		int cid = scmd_id(cmd);
+		dprintk((KERN_DEBUG "aacraid: Illegal lba\n"));
+		cmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 |
+			SAM_STAT_CHECK_CONDITION;
+		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
+			    HARDWARE_ERROR,
+			    SENCODE_INTERNAL_TARGET_FAILURE,
+			    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
+			    0, 0);
+		memcpy(cmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(cmd->sense_buffer))
+		    ? sizeof(cmd->sense_buffer)
+		    : sizeof(dev->fsa_dev[cid].sense_data));
+		cmd->scsi_done(cmd);
+		return 1;
+	}
+	return 0;
+}
+
+static int aac_bounds_64(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba)
+{
+	return 0;
+}
+
+static void io_callback(void *context, struct fib * fibptr);
+
+static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32 count)
+{
+	u16 fibsize;
+	struct aac_raw_io *readcmd;
+	aac_fib_init(fib);
+	readcmd = (struct aac_raw_io *) fib_data(fib);
+	readcmd->block[0] = cpu_to_le32((u32)(lba&0xffffffff));
+	readcmd->block[1] = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
+	readcmd->count = cpu_to_le32(count<<9);
+	readcmd->cid = cpu_to_le16(scmd_id(cmd));
+	readcmd->flags = cpu_to_le16(1);
+	readcmd->bpTotal = 0;
+	readcmd->bpComplete = 0;
+
+	aac_build_sgraw(cmd, &readcmd->sg);
+	fibsize = sizeof(struct aac_raw_io) + ((le32_to_cpu(readcmd->sg.count) - 1) * sizeof (struct sgentryraw));
+	BUG_ON(fibsize > (fib->dev->max_fib_size - sizeof(struct aac_fibhdr)));
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	return aac_fib_send(ContainerRawIo,
+			  fib,
+			  fibsize,
+			  FsaNormal,
+			  0, 1,
+			  (fib_callback) io_callback,
+			  (void *) cmd);
+}
+
+static int aac_read_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32 count)
+{
+	u16 fibsize;
+	struct aac_read64 *readcmd;
+	aac_fib_init(fib);
+	readcmd = (struct aac_read64 *) fib_data(fib);
+	readcmd->command = cpu_to_le32(VM_CtHostRead64);
+	readcmd->cid = cpu_to_le16(scmd_id(cmd));
+	readcmd->sector_count = cpu_to_le16(count);
+	readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
+	readcmd->pad   = 0;
+	readcmd->flags = 0;
+
+	aac_build_sg64(cmd, &readcmd->sg);
+	fibsize = sizeof(struct aac_read64) +
+		((le32_to_cpu(readcmd->sg.count) - 1) *
+		 sizeof (struct sgentry64));
+	BUG_ON (fibsize > (fib->dev->max_fib_size -
+				sizeof(struct aac_fibhdr)));
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	return aac_fib_send(ContainerCommand64,
+			  fib,
+			  fibsize,
+			  FsaNormal,
+			  0, 1,
+			  (fib_callback) io_callback,
+			  (void *) cmd);
+}
+
+static int aac_read_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32 count)
+{
+	u16 fibsize;
+	struct aac_read *readcmd;
+	aac_fib_init(fib);
+	readcmd = (struct aac_read *) fib_data(fib);
+	readcmd->command = cpu_to_le32(VM_CtBlockRead);
+	readcmd->cid = cpu_to_le16(scmd_id(cmd));
+	readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
+	readcmd->count = cpu_to_le32(count * 512);
+
+	aac_build_sg(cmd, &readcmd->sg);
+	fibsize = sizeof(struct aac_read) +
+			((le32_to_cpu(readcmd->sg.count) - 1) *
+			 sizeof (struct sgentry));
+	BUG_ON (fibsize > (fib->dev->max_fib_size -
+				sizeof(struct aac_fibhdr)));
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	return aac_fib_send(ContainerCommand,
+			  fib,
+			  fibsize,
+			  FsaNormal,
+			  0, 1,
+			  (fib_callback) io_callback,
+			  (void *) cmd);
+}
+
+static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32 count)
+{
+	u16 fibsize;
+	struct aac_raw_io *writecmd;
+	aac_fib_init(fib);
+	writecmd = (struct aac_raw_io *) fib_data(fib);
+	writecmd->block[0] = cpu_to_le32((u32)(lba&0xffffffff));
+	writecmd->block[1] = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
+	writecmd->count = cpu_to_le32(count<<9);
+	writecmd->cid = cpu_to_le16(scmd_id(cmd));
+	writecmd->flags = 0;
+	writecmd->bpTotal = 0;
+	writecmd->bpComplete = 0;
+
+	aac_build_sgraw(cmd, &writecmd->sg);
+	fibsize = sizeof(struct aac_raw_io) + ((le32_to_cpu(writecmd->sg.count) - 1) * sizeof (struct sgentryraw));
+	BUG_ON(fibsize > (fib->dev->max_fib_size - sizeof(struct aac_fibhdr)));
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	return aac_fib_send(ContainerRawIo,
+			  fib,
+			  fibsize,
+			  FsaNormal,
+			  0, 1,
+			  (fib_callback) io_callback,
+			  (void *) cmd);
+}
+
+static int aac_write_block64(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32 count)
+{
+	u16 fibsize;
+	struct aac_write64 *writecmd;
+	aac_fib_init(fib);
+	writecmd = (struct aac_write64 *) fib_data(fib);
+	writecmd->command = cpu_to_le32(VM_CtHostWrite64);
+	writecmd->cid = cpu_to_le16(scmd_id(cmd));
+	writecmd->sector_count = cpu_to_le16(count);
+	writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
+	writecmd->pad	= 0;
+	writecmd->flags	= 0;
+
+	aac_build_sg64(cmd, &writecmd->sg);
+	fibsize = sizeof(struct aac_write64) +
+		((le32_to_cpu(writecmd->sg.count) - 1) *
+		 sizeof (struct sgentry64));
+	BUG_ON (fibsize > (fib->dev->max_fib_size -
+				sizeof(struct aac_fibhdr)));
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	return aac_fib_send(ContainerCommand64,
+			  fib,
+			  fibsize,
+			  FsaNormal,
+			  0, 1,
+			  (fib_callback) io_callback,
+			  (void *) cmd);
+}
+
+static int aac_write_block(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32 count)
+{
+	u16 fibsize;
+	struct aac_write *writecmd;
+	aac_fib_init(fib);
+	writecmd = (struct aac_write *) fib_data(fib);
+	writecmd->command = cpu_to_le32(VM_CtBlockWrite);
+	writecmd->cid = cpu_to_le16(scmd_id(cmd));
+	writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
+	writecmd->count = cpu_to_le32(count * 512);
+	writecmd->sg.count = cpu_to_le32(1);
+	/* ->stable is not used - it did mean which type of write */
+
+	aac_build_sg(cmd, &writecmd->sg);
+	fibsize = sizeof(struct aac_write) +
+		((le32_to_cpu(writecmd->sg.count) - 1) *
+		 sizeof (struct sgentry));
+	BUG_ON (fibsize > (fib->dev->max_fib_size -
+				sizeof(struct aac_fibhdr)));
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	return aac_fib_send(ContainerCommand,
+			  fib,
+			  fibsize,
+			  FsaNormal,
+			  0, 1,
+			  (fib_callback) io_callback,
+			  (void *) cmd);
+}
+
+static struct aac_srb * aac_scsi_common(struct fib * fib, struct scsi_cmnd * cmd)
+{
+	struct aac_srb * srbcmd;
+	u32 flag;
+	u32 timeout;
+
+	aac_fib_init(fib);
+	switch(cmd->sc_data_direction){
+	case DMA_TO_DEVICE:
+		flag = SRB_DataOut;
+		break;
+	case DMA_BIDIRECTIONAL:
+		flag = SRB_DataIn | SRB_DataOut;
+		break;
+	case DMA_FROM_DEVICE:
+		flag = SRB_DataIn;
+		break;
+	case DMA_NONE:
+	default:	/* shuts up some versions of gcc */
+		flag = SRB_NoDataXfer;
+		break;
+	}
+
+	srbcmd = (struct aac_srb*) fib_data(fib);
+	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
+	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(scmd_channel(cmd)));
+	srbcmd->id       = cpu_to_le32(scmd_id(cmd));
+	srbcmd->lun      = cpu_to_le32(cmd->device->lun);
+	srbcmd->flags    = cpu_to_le32(flag);
+	timeout = cmd->timeout_per_command/HZ;
+	if (timeout == 0)
+		timeout = 1;
+	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
+	srbcmd->retry_limit = 0; /* Obsolete parameter */
+	srbcmd->cdb_size = cpu_to_le32(cmd->cmd_len);
+	return srbcmd;
+}
+
+static void aac_srb_callback(void *context, struct fib * fibptr);
+
+static int aac_scsi_64(struct fib * fib, struct scsi_cmnd * cmd)
+{
+	u16 fibsize;
+	struct aac_srb * srbcmd = aac_scsi_common(fib, cmd);
+
+	aac_build_sg64(cmd, (struct sgmap64*) &srbcmd->sg);
+	srbcmd->count = cpu_to_le32(cmd->request_bufflen);
+
+	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
+	memcpy(srbcmd->cdb, cmd->cmnd, cmd->cmd_len);
+	/*
+	 *	Build Scatter/Gather list
+	 */
+	fibsize = sizeof (struct aac_srb) - sizeof (struct sgentry) +
+		((le32_to_cpu(srbcmd->sg.count) & 0xff) *
+		 sizeof (struct sgentry64));
+	BUG_ON (fibsize > (fib->dev->max_fib_size -
+				sizeof(struct aac_fibhdr)));
+
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	return aac_fib_send(ScsiPortCommand64, fib,
+				fibsize, FsaNormal, 0, 1,
+				  (fib_callback) aac_srb_callback,
+				  (void *) cmd);
+}
+
+static int aac_scsi_32(struct fib * fib, struct scsi_cmnd * cmd)
+{
+	u16 fibsize;
+	struct aac_srb * srbcmd = aac_scsi_common(fib, cmd);
+
+	aac_build_sg(cmd, (struct sgmap*)&srbcmd->sg);
+	srbcmd->count = cpu_to_le32(cmd->request_bufflen);
+
+	memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
+	memcpy(srbcmd->cdb, cmd->cmnd, cmd->cmd_len);
+	/*
+	 *	Build Scatter/Gather list
+	 */
+	fibsize = sizeof (struct aac_srb) +
+		(((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) *
+		 sizeof (struct sgentry));
+	BUG_ON (fibsize > (fib->dev->max_fib_size -
+				sizeof(struct aac_fibhdr)));
+
+	/*
+	 *	Now send the Fib to the adapter
+	 */
+	return aac_fib_send(ScsiPortCommand, fib, fibsize, FsaNormal, 0, 1,
+				  (fib_callback) aac_srb_callback, (void *) cmd);
+}
+
 int aac_get_adapter_info(struct aac_dev* dev)
 {
 	struct fib* fibptr;
@@ -874,14 +1177,27 @@
 		}
 	}
 	/* 
-	 * 57 scatter gather elements 
+	 * Deal with configuring for the individualized limits of each packet
+	 * interface.
 	 */
-	if (!(dev->raw_io_interface)) {
+	dev->a_ops.adapter_scsi = (dev->dac_support)
+				? aac_scsi_64
+				: aac_scsi_32;
+	if (dev->raw_io_interface) {
+		dev->a_ops.adapter_bounds = (dev->raw_io_64)
+					? aac_bounds_64
+					: aac_bounds_32;
+		dev->a_ops.adapter_read = aac_read_raw_io;
+		dev->a_ops.adapter_write = aac_write_raw_io;
+	} else {
+		dev->a_ops.adapter_bounds = aac_bounds_32;
 		dev->scsi_host_ptr->sg_tablesize = (dev->max_fib_size -
 			sizeof(struct aac_fibhdr) -
 			sizeof(struct aac_write) + sizeof(struct sgentry)) /
 				sizeof(struct sgentry);
 		if (dev->dac_support) {
+			dev->a_ops.adapter_read = aac_read_block64;
+			dev->a_ops.adapter_write = aac_write_block64;
 			/* 
 			 * 38 scatter gather elements 
 			 */
@@ -891,6 +1207,9 @@
 				sizeof(struct aac_write64) +
 				sizeof(struct sgentry64)) /
 					sizeof(struct sgentry64);
+		} else {
+			dev->a_ops.adapter_read = aac_read_block;
+			dev->a_ops.adapter_write = aac_write_block;
 		}
 		dev->scsi_host_ptr->max_sectors = AAC_MAX_32BIT_SGBCOUNT;
 		if(!(dev->adapter_info.options & AAC_OPT_NEW_COMM)) {
@@ -1004,8 +1323,6 @@
 	u64 lba;
 	u32 count;
 	int status;
-
-	u16 fibsize;
 	struct aac_dev *dev;
 	struct fib * cmd_fibcontext;
 
@@ -1059,23 +1376,8 @@
 	}
 	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %llu, t = %ld.\n",
 	  smp_processor_id(), (unsigned long long)lba, jiffies));
-	if ((!(dev->raw_io_interface) || !(dev->raw_io_64)) &&
-		(lba & 0xffffffff00000000LL)) {
-		dprintk((KERN_DEBUG "aac_read: Illegal lba\n"));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | 
-			SAM_STAT_CHECK_CONDITION;
-		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
-			    HARDWARE_ERROR,
-			    SENCODE_INTERNAL_TARGET_FAILURE,
-			    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
-			    0, 0);
-		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
-		    ? sizeof(scsicmd->sense_buffer)
-		    : sizeof(dev->fsa_dev[cid].sense_data));
-		scsicmd->scsi_done(scsicmd);
+	if (aac_adapter_bounds(dev,scsicmd,lba))
 		return 0;
-	}
 	/*
 	 *	Alocate and initialize a Fib
 	 */
@@ -1083,85 +1385,7 @@
 		return -1;
 	}
 
-	aac_fib_init(cmd_fibcontext);
-
-	if (dev->raw_io_interface) {
-		struct aac_raw_io *readcmd;
-		readcmd = (struct aac_raw_io *) fib_data(cmd_fibcontext);
-		readcmd->block[0] = cpu_to_le32((u32)(lba&0xffffffff));
-		readcmd->block[1] = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
-		readcmd->count = cpu_to_le32(count<<9);
-		readcmd->cid = cpu_to_le16(cid);
-		readcmd->flags = cpu_to_le16(1);
-		readcmd->bpTotal = 0;
-		readcmd->bpComplete = 0;
-		
-		aac_build_sgraw(scsicmd, &readcmd->sg);
-		fibsize = sizeof(struct aac_raw_io) + ((le32_to_cpu(readcmd->sg.count) - 1) * sizeof (struct sgentryraw));
-		BUG_ON(fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)));
-		/*
-		 *	Now send the Fib to the adapter
-		 */
-		status = aac_fib_send(ContainerRawIo,
-			  cmd_fibcontext, 
-			  fibsize, 
-			  FsaNormal, 
-			  0, 1, 
-			  (fib_callback) io_callback, 
-			  (void *) scsicmd);
-	} else if (dev->dac_support == 1) {
-		struct aac_read64 *readcmd;
-		readcmd = (struct aac_read64 *) fib_data(cmd_fibcontext);
-		readcmd->command = cpu_to_le32(VM_CtHostRead64);
-		readcmd->cid = cpu_to_le16(cid);
-		readcmd->sector_count = cpu_to_le16(count);
-		readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
-		readcmd->pad   = 0;
-		readcmd->flags = 0; 
-
-		aac_build_sg64(scsicmd, &readcmd->sg);
-		fibsize = sizeof(struct aac_read64) + 
-			((le32_to_cpu(readcmd->sg.count) - 1) * 
-			 sizeof (struct sgentry64));
-		BUG_ON (fibsize > (dev->max_fib_size - 
-					sizeof(struct aac_fibhdr)));
-		/*
-		 *	Now send the Fib to the adapter
-		 */
-		status = aac_fib_send(ContainerCommand64,
-			  cmd_fibcontext, 
-			  fibsize, 
-			  FsaNormal, 
-			  0, 1, 
-			  (fib_callback) io_callback, 
-			  (void *) scsicmd);
-	} else {
-		struct aac_read *readcmd;
-		readcmd = (struct aac_read *) fib_data(cmd_fibcontext);
-		readcmd->command = cpu_to_le32(VM_CtBlockRead);
-		readcmd->cid = cpu_to_le32(cid);
-		readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
-		readcmd->count = cpu_to_le32(count * 512);
-
-		aac_build_sg(scsicmd, &readcmd->sg);
-		fibsize = sizeof(struct aac_read) + 
-			((le32_to_cpu(readcmd->sg.count) - 1) * 
-			 sizeof (struct sgentry));
-		BUG_ON (fibsize > (dev->max_fib_size -
-					sizeof(struct aac_fibhdr)));
-		/*
-		 *	Now send the Fib to the adapter
-		 */
-		status = aac_fib_send(ContainerCommand,
-			  cmd_fibcontext, 
-			  fibsize, 
-			  FsaNormal, 
-			  0, 1, 
-			  (fib_callback) io_callback, 
-			  (void *) scsicmd);
-	}
-
-	
+	status = aac_adapter_read(cmd_fibcontext, scsicmd, lba, count);
 
 	/*
 	 *	Check that the command queued to the controller
@@ -1187,7 +1411,6 @@
 	u64 lba;
 	u32 count;
 	int status;
-	u16 fibsize;
 	struct aac_dev *dev;
 	struct fib * cmd_fibcontext;
 
@@ -1227,22 +1450,8 @@
 	}
 	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %llu, t = %ld.\n",
 	  smp_processor_id(), (unsigned long long)lba, jiffies));
-	if ((!(dev->raw_io_interface) || !(dev->raw_io_64))
-	 && (lba & 0xffffffff00000000LL)) {
-		dprintk((KERN_DEBUG "aac_write: Illegal lba\n"));
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
-			    HARDWARE_ERROR,
-			    SENCODE_INTERNAL_TARGET_FAILURE,
-			    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
-			    0, 0);
-		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
-		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
-		    ? sizeof(scsicmd->sense_buffer)
-		    : sizeof(dev->fsa_dev[cid].sense_data));
-		scsicmd->scsi_done(scsicmd);
+	if (aac_adapter_bounds(dev,scsicmd,lba))
 		return 0;
-	}
 	/*
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
@@ -1251,85 +1460,8 @@
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
-	aac_fib_init(cmd_fibcontext);
 
-	if (dev->raw_io_interface) {
-		struct aac_raw_io *writecmd;
-		writecmd = (struct aac_raw_io *) fib_data(cmd_fibcontext);
-		writecmd->block[0] = cpu_to_le32((u32)(lba&0xffffffff));
-		writecmd->block[1] = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
-		writecmd->count = cpu_to_le32(count<<9);
-		writecmd->cid = cpu_to_le16(cid);
-		writecmd->flags = 0; 
-		writecmd->bpTotal = 0;
-		writecmd->bpComplete = 0;
-		
-		aac_build_sgraw(scsicmd, &writecmd->sg);
-		fibsize = sizeof(struct aac_raw_io) + ((le32_to_cpu(writecmd->sg.count) - 1) * sizeof (struct sgentryraw));
-		BUG_ON(fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)));
-		/*
-		 *	Now send the Fib to the adapter
-		 */
-		status = aac_fib_send(ContainerRawIo,
-			  cmd_fibcontext, 
-			  fibsize, 
-			  FsaNormal, 
-			  0, 1, 
-			  (fib_callback) io_callback, 
-			  (void *) scsicmd);
-	} else if (dev->dac_support == 1) {
-		struct aac_write64 *writecmd;
-		writecmd = (struct aac_write64 *) fib_data(cmd_fibcontext);
-		writecmd->command = cpu_to_le32(VM_CtHostWrite64);
-		writecmd->cid = cpu_to_le16(cid);
-		writecmd->sector_count = cpu_to_le16(count); 
-		writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
-		writecmd->pad	= 0;
-		writecmd->flags	= 0;
-
-		aac_build_sg64(scsicmd, &writecmd->sg);
-		fibsize = sizeof(struct aac_write64) + 
-			((le32_to_cpu(writecmd->sg.count) - 1) * 
-			 sizeof (struct sgentry64));
-		BUG_ON (fibsize > (dev->max_fib_size -
-					sizeof(struct aac_fibhdr)));
-		/*
-		 *	Now send the Fib to the adapter
-		 */
-		status = aac_fib_send(ContainerCommand64,
-			  cmd_fibcontext, 
-			  fibsize, 
-			  FsaNormal, 
-			  0, 1, 
-			  (fib_callback) io_callback, 
-			  (void *) scsicmd);
-	} else {
-		struct aac_write *writecmd;
-		writecmd = (struct aac_write *) fib_data(cmd_fibcontext);
-		writecmd->command = cpu_to_le32(VM_CtBlockWrite);
-		writecmd->cid = cpu_to_le32(cid);
-		writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
-		writecmd->count = cpu_to_le32(count * 512);
-		writecmd->sg.count = cpu_to_le32(1);
-		/* ->stable is not used - it did mean which type of write */
-
-		aac_build_sg(scsicmd, &writecmd->sg);
-		fibsize = sizeof(struct aac_write) + 
-			((le32_to_cpu(writecmd->sg.count) - 1) * 
-			 sizeof (struct sgentry));
-		BUG_ON (fibsize > (dev->max_fib_size -
-					sizeof(struct aac_fibhdr)));
-		/*
-		 *	Now send the Fib to the adapter
-		 */
-		status = aac_fib_send(ContainerCommand,
-			  cmd_fibcontext, 
-			  fibsize, 
-			  FsaNormal, 
-			  0, 1, 
-			  (fib_callback) io_callback, 
-			  (void *) scsicmd);
-	}
+	status = aac_adapter_write(cmd_fibcontext, scsicmd, lba, count);
 
 	/*
 	 *	Check that the command queued to the controller
@@ -2167,10 +2299,6 @@
 	struct fib* cmd_fibcontext;
 	struct aac_dev* dev;
 	int status;
-	struct aac_srb *srbcmd;
-	u16 fibsize;
-	u32 flag;
-	u32 timeout;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	if (scmd_id(scsicmd) >= dev->maximum_num_physicals ||
@@ -2180,88 +2308,14 @@
 		return 0;
 	}
 
-	switch(scsicmd->sc_data_direction){
-	case DMA_TO_DEVICE:
-		flag = SRB_DataOut;
-		break;
-	case DMA_BIDIRECTIONAL:
-		flag = SRB_DataIn | SRB_DataOut;
-		break;
-	case DMA_FROM_DEVICE:
-		flag = SRB_DataIn;
-		break;
-	case DMA_NONE:
-	default:	/* shuts up some versions of gcc */
-		flag = SRB_NoDataXfer;
-		break;
-	}
-
-
 	/*
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
 	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
 		return -1;
 	}
-	aac_fib_init(cmd_fibcontext);
-
-	srbcmd = (struct aac_srb*) fib_data(cmd_fibcontext);
-	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
-	srbcmd->channel  = cpu_to_le32(aac_logical_to_phys(scmd_channel(scsicmd)));
-	srbcmd->id   = cpu_to_le32(scmd_id(scsicmd));
-	srbcmd->lun      = cpu_to_le32(scsicmd->device->lun);
-	srbcmd->flags    = cpu_to_le32(flag);
-	timeout = scsicmd->timeout_per_command/HZ;
-	if(timeout == 0){
-		timeout = 1;
-	}
-	srbcmd->timeout  = cpu_to_le32(timeout);  // timeout in seconds
-	srbcmd->retry_limit = 0; /* Obsolete parameter */
-	srbcmd->cdb_size = cpu_to_le32(scsicmd->cmd_len);
-	
-	if( dev->dac_support == 1 ) {
-		aac_build_sg64(scsicmd, (struct sgmap64*) &srbcmd->sg);
-		srbcmd->count = cpu_to_le32(scsicmd->request_bufflen);
-
-		memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
-		memcpy(srbcmd->cdb, scsicmd->cmnd, scsicmd->cmd_len);
-		/*
-		 *	Build Scatter/Gather list
-		 */
-		fibsize = sizeof (struct aac_srb) - sizeof (struct sgentry) +
-			((le32_to_cpu(srbcmd->sg.count) & 0xff) * 
-			 sizeof (struct sgentry64));
-		BUG_ON (fibsize > (dev->max_fib_size -
-					sizeof(struct aac_fibhdr)));
+	status = aac_adapter_scsi(cmd_fibcontext, scsicmd);
 
-		/*
-		 *	Now send the Fib to the adapter
-		 */
-		status = aac_fib_send(ScsiPortCommand64, cmd_fibcontext,
-				fibsize, FsaNormal, 0, 1,
-				  (fib_callback) aac_srb_callback, 
-				  (void *) scsicmd);
-	} else {
-		aac_build_sg(scsicmd, (struct sgmap*)&srbcmd->sg);
-		srbcmd->count = cpu_to_le32(scsicmd->request_bufflen);
-
-		memset(srbcmd->cdb, 0, sizeof(srbcmd->cdb));
-		memcpy(srbcmd->cdb, scsicmd->cmnd, scsicmd->cmd_len);
-		/*
-		 *	Build Scatter/Gather list
-		 */
-		fibsize = sizeof (struct aac_srb) + 
-			(((le32_to_cpu(srbcmd->sg.count) & 0xff) - 1) * 
-			 sizeof (struct sgentry));
-		BUG_ON (fibsize > (dev->max_fib_size -
-					sizeof(struct aac_fibhdr)));
-
-		/*
-		 *	Now send the Fib to the adapter
-		 */
-		status = aac_fib_send(ScsiPortCommand, cmd_fibcontext, fibsize, FsaNormal, 0, 1,
-				  (fib_callback) aac_srb_callback, (void *) scsicmd);
-	}
 	/*
 	 *	Check that the command queued to the controller
 	 */
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2007-01-18 10:11:28.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2007-01-18 10:11:30.000000000 -0800
@@ -486,6 +486,7 @@
 
 struct aac_dev;
 struct fib;
+struct scsi_cmnd;
 
 struct adapter_ops
 {
@@ -501,6 +502,10 @@
 	irqreturn_t (*adapter_intr)(int irq, void *dev_id);
 	/* Packet operations */
 	int  (*adapter_deliver)(struct fib * fib);
+	int  (*adapter_bounds)(struct aac_dev * dev, struct scsi_cmnd * cmd, u64 lba);
+	int  (*adapter_read)(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32 count);
+	int  (*adapter_write)(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u32 count);
+	int  (*adapter_scsi)(struct fib * fib, struct scsi_cmnd * cmd);
 	/* Administrative operations */
 	int  (*adapter_comm)(struct aac_dev * dev, int comm);
 };
@@ -1061,6 +1066,18 @@
 #define aac_adapter_deliver(fib) \
 	((fib)->dev)->a_ops.adapter_deliver(fib)
 
+#define aac_adapter_bounds(dev,cmd,lba) \
+	dev->a_ops.adapter_bounds(dev,cmd,lba)
+
+#define aac_adapter_read(fib,cmd,lba,count) \
+	((fib)->dev)->a_ops.adapter_read(fib,cmd,lba,count)
+
+#define aac_adapter_write(fib,cmd,lba,count) \
+	((fib)->dev)->a_ops.adapter_write(fib,cmd,lba,count)
+
+#define aac_adapter_scsi(fib,cmd) \
+	((fib)->dev)->a_ops.adapter_scsi(fib,cmd)
+
 #define aac_adapter_comm(dev,comm) \
 	(dev)->a_ops.adapter_comm(dev, comm)
 
@@ -1783,7 +1800,6 @@
 	return (u32)capacity;
 }
 
-struct scsi_cmnd;
 /* SCp.phase values */
 #define AAC_OWNER_MIDLEVEL	0x101
 #define AAC_OWNER_LOWLEVEL	0x102

-- 
Mark Haverkamp <markh@linux-foundation.org>

