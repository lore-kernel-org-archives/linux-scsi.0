From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 1/7] aacraid: Greater than 2TB capacity support (Update)
Date: Thu, 22 Sep 2005 09:15:24 -0700
Message-ID: <1127405725.30565.4.camel@markh1.pdx.osdl.net>
References: <1127246156.1891.31.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:64475 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030425AbVIVQSr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 12:18:47 -0400
In-Reply-To: <1127246156.1891.31.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, Christoph Hellwig <hch@infradead.org>


Updated to change the if/else sections to switch statements.

Received from Mark Salyzyn from Adaptec.
Greater than 2TB capacity patch. 

There are a few adapters that are capable of creating devices with this large
of a capacity, but now that we have the large fib support in, the management
applications will be capable of generating them.  The problem is, once they are
created, the driver will not be able to access the devices correctly without
this patch.

Applies to the scsi-misc-2.6 git tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-aac-2/drivers/scsi/aacraid/aachba.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/aachba.c	2005-09-08 11:31:18.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/aachba.c	2005-09-20 13:31:17.000000000 -0700
@@ -313,18 +313,37 @@
 		}
 		dresp = (struct aac_mount *)fib_data(fibptr);
 
+		if ((le32_to_cpu(dresp->status) == ST_OK) &&
+		    (le32_to_cpu(dresp->mnt[0].vol) == CT_NONE)) {
+			dinfo->command = cpu_to_le32(VM_NameServe64);
+			dinfo->count = cpu_to_le32(index);
+			dinfo->type = cpu_to_le32(FT_FILESYS);
+
+			if (fib_send(ContainerCommand,
+				    fibptr,
+				    sizeof(struct aac_query_mount),
+				    FsaNormal,
+				    1, 1,
+				    NULL, NULL) < 0)
+				continue;
+		} else
+			dresp->mnt[0].capacityhigh = 0;
+
 		dprintk ((KERN_DEBUG
-		  "VM_NameServe cid=%d status=%d vol=%d state=%d cap=%u\n",
+		  "VM_NameServe cid=%d status=%d vol=%d state=%d cap=%llu\n",
 		  (int)index, (int)le32_to_cpu(dresp->status),
 		  (int)le32_to_cpu(dresp->mnt[0].vol),
 		  (int)le32_to_cpu(dresp->mnt[0].state),
-		  (unsigned)le32_to_cpu(dresp->mnt[0].capacity)));
+		  ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
+		    (((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32)));
 		if ((le32_to_cpu(dresp->status) == ST_OK) &&
 		    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
 		    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
 			fsa_dev_ptr[index].valid = 1;
 			fsa_dev_ptr[index].type = le32_to_cpu(dresp->mnt[0].vol);
-			fsa_dev_ptr[index].size = le32_to_cpu(dresp->mnt[0].capacity);
+			fsa_dev_ptr[index].size
+			  = ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
+			    (((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32);
 			if (le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY)
 				    fsa_dev_ptr[index].ro = 1;
 		}
@@ -497,11 +516,29 @@
 	dresp = (struct aac_mount *) fib_data(fibptr);
 
 	if ((le32_to_cpu(dresp->status) == ST_OK) &&
+	    (le32_to_cpu(dresp->mnt[0].vol) == CT_NONE)) {
+		dinfo->command = cpu_to_le32(VM_NameServe64);
+		dinfo->count = cpu_to_le32(cid);
+		dinfo->type = cpu_to_le32(FT_FILESYS);
+
+		if (fib_send(ContainerCommand,
+			    fibptr,
+			    sizeof(struct aac_query_mount),
+			    FsaNormal,
+			    1, 1,
+			    NULL, NULL) < 0)
+			goto error;
+	} else
+		dresp->mnt[0].capacityhigh = 0;
+
+	if ((le32_to_cpu(dresp->status) == ST_OK) &&
 	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
 	    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
 		fsa_dev_ptr[cid].valid = 1;
 		fsa_dev_ptr[cid].type = le32_to_cpu(dresp->mnt[0].vol);
-		fsa_dev_ptr[cid].size = le32_to_cpu(dresp->mnt[0].capacity);
+		fsa_dev_ptr[cid].size
+		  = ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
+		    (((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32);
 		if (le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY)
 			fsa_dev_ptr[cid].ro = 1;
 	}
@@ -854,7 +891,40 @@
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 	cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
 
-	dprintk((KERN_DEBUG "io_callback[cpu %d]: lba = %u, t = %ld.\n", smp_processor_id(), ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3], jiffies));
+	if (nblank(dprintk(x))) {
+		u64 lba;
+		switch (scsicmd->cmnd[0]) {
+		case WRITE_6:
+		case READ_6:
+			lba = ((scsicmd->cmnd[1] & 0x1F) << 16) |
+			    (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
+			break;
+		case WRITE_16:
+		case READ_16:
+			lba = ((u64)scsicmd->cmnd[2] << 56) |
+			      ((u64)scsicmd->cmnd[3] << 48) |
+			      ((u64)scsicmd->cmnd[4] << 40) |
+			      ((u64)scsicmd->cmnd[5] << 32) |
+			      ((u64)scsicmd->cmnd[6] << 24) |
+			      (scsicmd->cmnd[7] << 16) |
+			      (scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
+			break;
+		case WRITE_12:
+		case READ_12:
+			lba = ((u64)scsicmd->cmnd[2] << 24) |
+			      (scsicmd->cmnd[3] << 16) |
+			      (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
+			break;
+		default:
+			lba = ((u64)scsicmd->cmnd[2] << 24) |
+			       (scsicmd->cmnd[3] << 16) |
+			       (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
+			break;
+		}
+		printk(KERN_DEBUG
+		  "io_callback[cpu %d]: lba = %llu, t = %ld.\n",
+		  smp_processor_id(), (unsigned long long)lba, jiffies);
+	}
 
 	if (fibptr == NULL)
 		BUG();
@@ -895,7 +965,7 @@
 
 static int aac_read(struct scsi_cmnd * scsicmd, int cid)
 {
-	u32 lba;
+	u64 lba;
 	u32 count;
 	int status;
 
@@ -907,23 +977,69 @@
 	/*
 	 *	Get block address and transfer length
 	 */
-	if (scsicmd->cmnd[0] == READ_6)	/* 6 byte command */
-	{
+	switch (scsicmd->cmnd[0]) {
+	case READ_6:
 		dprintk((KERN_DEBUG "aachba: received a read(6) command on id %d.\n", cid));
 
-		lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | (scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
+		lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | 
+			(scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
 		count = scsicmd->cmnd[4];
 
 		if (count == 0)
 			count = 256;
-	} else {
+		break;
+	case READ_16:
+		dprintk((KERN_DEBUG "aachba: received a read(16) command on id %d.\n", cid));
+
+		lba = 	((u64)scsicmd->cmnd[2] << 56) |
+		 	((u64)scsicmd->cmnd[3] << 48) |
+			((u64)scsicmd->cmnd[4] << 40) |
+			((u64)scsicmd->cmnd[5] << 32) |
+			((u64)scsicmd->cmnd[6] << 24) | 
+			(scsicmd->cmnd[7] << 16) |
+			(scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
+		count = (scsicmd->cmnd[10] << 24) | 
+			(scsicmd->cmnd[11] << 16) |
+			(scsicmd->cmnd[12] << 8) | scsicmd->cmnd[13];
+		break;
+	case READ_12:
+		dprintk((KERN_DEBUG "aachba: received a read(12) command on id %d.\n", cid));
+
+		lba = ((u64)scsicmd->cmnd[2] << 24) | 
+			(scsicmd->cmnd[3] << 16) |
+		    	(scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
+		count = (scsicmd->cmnd[6] << 24) | 
+			(scsicmd->cmnd[7] << 16) |
+		      	(scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
+		break;
+	default:
 		dprintk((KERN_DEBUG "aachba: received a read(10) command on id %d.\n", cid));
 
-		lba = (scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16) | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
+		lba = ((u64)scsicmd->cmnd[2] << 24) | 
+			(scsicmd->cmnd[3] << 16) | 
+			(scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
 		count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
+		break;
 	}
-	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %u, t = %ld.\n",
+	dprintk((KERN_DEBUG "aac_read[cpu %d]: lba = %llu, t = %ld.\n",
 	  smp_processor_id(), (unsigned long long)lba, jiffies));
+	if ((!(dev->raw_io_interface) || !(dev->raw_io_64)) &&
+		(lba & 0xffffffff00000000LL)) {
+		dprintk((KERN_DEBUG "aac_read: Illegal lba\n"));
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | 
+			SAM_STAT_CHECK_CONDITION;
+		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
+			    HARDWARE_ERROR,
+			    SENCODE_INTERNAL_TARGET_FAILURE,
+			    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
+			    0, 0);
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(dev->fsa_dev[cid].sense_data));
+		scsicmd->scsi_done(scsicmd);
+		return 0;
+	}
 	/*
 	 *	Alocate and initialize a Fib
 	 */
@@ -936,8 +1052,8 @@
 	if (dev->raw_io_interface) {
 		struct aac_raw_io *readcmd;
 		readcmd = (struct aac_raw_io *) fib_data(cmd_fibcontext);
-		readcmd->block[0] = cpu_to_le32(lba);
-		readcmd->block[1] = 0;
+		readcmd->block[0] = cpu_to_le32((u32)(lba&0xffffffff));
+		readcmd->block[1] = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
 		readcmd->count = cpu_to_le32(count<<9);
 		readcmd->cid = cpu_to_le16(cid);
 		readcmd->flags = cpu_to_le16(1);
@@ -964,7 +1080,7 @@
 		readcmd->command = cpu_to_le32(VM_CtHostRead64);
 		readcmd->cid = cpu_to_le16(cid);
 		readcmd->sector_count = cpu_to_le16(count);
-		readcmd->block = cpu_to_le32(lba);
+		readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 		readcmd->pad   = 0;
 		readcmd->flags = 0; 
 
@@ -989,7 +1105,7 @@
 		readcmd = (struct aac_read *) fib_data(cmd_fibcontext);
 		readcmd->command = cpu_to_le32(VM_CtBlockRead);
 		readcmd->cid = cpu_to_le32(cid);
-		readcmd->block = cpu_to_le32(lba);
+		readcmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 		readcmd->count = cpu_to_le32(count * 512);
 
 		aac_build_sg(scsicmd, &readcmd->sg);
@@ -1031,7 +1147,7 @@
 
 static int aac_write(struct scsi_cmnd * scsicmd, int cid)
 {
-	u32 lba;
+	u64 lba;
 	u32 count;
 	int status;
 	u16 fibsize;
@@ -1048,13 +1164,48 @@
 		count = scsicmd->cmnd[4];
 		if (count == 0)
 			count = 256;
+	} else if (scsicmd->cmnd[0] == WRITE_16) { /* 16 byte command */
+		dprintk((KERN_DEBUG "aachba: received a write(16) command on id %d.\n", cid));
+
+		lba = 	((u64)scsicmd->cmnd[2] << 56) |
+			((u64)scsicmd->cmnd[3] << 48) |
+			((u64)scsicmd->cmnd[4] << 40) |
+			((u64)scsicmd->cmnd[5] << 32) |
+			((u64)scsicmd->cmnd[6] << 24) | 
+			(scsicmd->cmnd[7] << 16) |
+			(scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
+		count = (scsicmd->cmnd[10] << 24) | (scsicmd->cmnd[11] << 16) |
+			(scsicmd->cmnd[12] << 8) | scsicmd->cmnd[13];
+	} else if (scsicmd->cmnd[0] == WRITE_12) { /* 12 byte command */
+		dprintk((KERN_DEBUG "aachba: received a write(12) command on id %d.\n", cid));
+
+		lba = ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16)
+		    | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
+		count = (scsicmd->cmnd[6] << 24) | (scsicmd->cmnd[7] << 16)
+		      | (scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
 	} else {
 		dprintk((KERN_DEBUG "aachba: received a write(10) command on id %d.\n", cid));
-		lba = (scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16) | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
+		lba = ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16) | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
 		count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
 	}
-	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %u, t = %ld.\n",
+	dprintk((KERN_DEBUG "aac_write[cpu %d]: lba = %llu, t = %ld.\n",
 	  smp_processor_id(), (unsigned long long)lba, jiffies));
+	if ((!(dev->raw_io_interface) || !(dev->raw_io_64))
+	 && (lba & 0xffffffff00000000LL)) {
+		dprintk((KERN_DEBUG "aac_write: Illegal lba\n"));
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
+		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
+			    HARDWARE_ERROR,
+			    SENCODE_INTERNAL_TARGET_FAILURE,
+			    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
+			    0, 0);
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(dev->fsa_dev[cid].sense_data));
+		scsicmd->scsi_done(scsicmd);
+		return 0;
+	}
 	/*
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
@@ -1068,8 +1219,8 @@
 	if (dev->raw_io_interface) {
 		struct aac_raw_io *writecmd;
 		writecmd = (struct aac_raw_io *) fib_data(cmd_fibcontext);
-		writecmd->block[0] = cpu_to_le32(lba);
-		writecmd->block[1] = 0;
+		writecmd->block[0] = cpu_to_le32((u32)(lba&0xffffffff));
+		writecmd->block[1] = cpu_to_le32((u32)((lba&0xffffffff00000000LL)>>32));
 		writecmd->count = cpu_to_le32(count<<9);
 		writecmd->cid = cpu_to_le16(cid);
 		writecmd->flags = 0; 
@@ -1096,7 +1247,7 @@
 		writecmd->command = cpu_to_le32(VM_CtHostWrite64);
 		writecmd->cid = cpu_to_le16(cid);
 		writecmd->sector_count = cpu_to_le16(count); 
-		writecmd->block = cpu_to_le32(lba);
+		writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 		writecmd->pad	= 0;
 		writecmd->flags	= 0;
 
@@ -1121,7 +1272,7 @@
 		writecmd = (struct aac_write *) fib_data(cmd_fibcontext);
 		writecmd->command = cpu_to_le32(VM_CtBlockWrite);
 		writecmd->cid = cpu_to_le32(cid);
-		writecmd->block = cpu_to_le32(lba);
+		writecmd->block = cpu_to_le32((u32)(lba&0xffffffff));
 		writecmd->count = cpu_to_le32(count * 512);
 		writecmd->sg.count = cpu_to_le32(1);
 		/* ->stable is not used - it did mean which type of write */
@@ -1310,6 +1461,11 @@
 			 */
 			if ((fsa_dev_ptr[cid].valid & 1) == 0) {
 				switch (scsicmd->cmnd[0]) {
+				case SERVICE_ACTION_IN:
+					if (!(dev->raw_io_interface) ||
+					    !(dev->raw_io_64) ||
+					    ((scsicmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
+						break;
 				case INQUIRY:
 				case READ_CAPACITY:
 				case TEST_UNIT_READY:
@@ -1375,7 +1531,6 @@
 		memset(&inq_data, 0, sizeof (struct inquiry_data));
 
 		inq_data.inqd_ver = 2;	/* claim compliance to SCSI-2 */
-		inq_data.inqd_dtq = 0x80;	/* set RMB bit to one indicating that the medium is removable */
 		inq_data.inqd_rdf = 2;	/* A response data format value of two indicates that the data shall be in the format specified in SCSI-2 */
 		inq_data.inqd_len = 31;
 		/*Format for "pad2" is  RelAdr | WBus32 | WBus16 |  Sync  | Linked |Reserved| CmdQue | SftRe */
@@ -1397,13 +1552,55 @@
 		aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
 		return aac_get_container_name(scsicmd, cid);
 	}
+	case SERVICE_ACTION_IN:
+		if (!(dev->raw_io_interface) ||
+		    !(dev->raw_io_64) ||
+		    ((scsicmd->cmnd[1] & 0x1f) != SAI_READ_CAPACITY_16))
+			break;
+	{
+		u64 capacity;
+		char cp[12];
+		unsigned int offset = 0;
+
+		dprintk((KERN_DEBUG "READ CAPACITY_16 command.\n"));
+		capacity = fsa_dev_ptr[cid].size - 1;
+		if (scsicmd->cmnd[13] > 12) {
+			offset = scsicmd->cmnd[13] - 12;
+			if (offset > sizeof(cp))
+				break;
+			memset(cp, 0, offset);
+			aac_internal_transfer(scsicmd, cp, 0, offset);
+		}
+		cp[0] = (capacity >> 56) & 0xff;
+		cp[1] = (capacity >> 48) & 0xff;
+		cp[2] = (capacity >> 40) & 0xff;
+		cp[3] = (capacity >> 32) & 0xff;
+		cp[4] = (capacity >> 24) & 0xff;
+		cp[5] = (capacity >> 16) & 0xff;
+		cp[6] = (capacity >> 8) & 0xff;
+		cp[7] = (capacity >> 0) & 0xff;
+		cp[8] = 0;
+		cp[9] = 0;
+		cp[10] = 2;
+		cp[11] = 0;
+		aac_internal_transfer(scsicmd, cp, offset, sizeof(cp));
+
+		/* Do not cache partition table for arrays */
+		scsicmd->device->removable = 1;
+
+		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+		scsicmd->scsi_done(scsicmd);
+
+		return 0;
+	}
+
 	case READ_CAPACITY:
 	{
 		u32 capacity;
 		char cp[8];
 
 		dprintk((KERN_DEBUG "READ CAPACITY command.\n"));
-		if (fsa_dev_ptr[cid].size <= 0x100000000LL)
+		if (fsa_dev_ptr[cid].size <= 0x100000000ULL)
 			capacity = fsa_dev_ptr[cid].size - 1;
 		else
 			capacity = (u32)-1;
@@ -1417,6 +1614,8 @@
 		cp[6] = 2;
 		cp[7] = 0;
 		aac_internal_transfer(scsicmd, cp, 0, sizeof(cp));
+		/* Do not cache partition table for arrays */
+		scsicmd->device->removable = 1;
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		scsicmd->scsi_done(scsicmd);
@@ -1497,6 +1696,8 @@
 	{
 		case READ_6:
 		case READ_10:
+		case READ_12:
+		case READ_16:
 			/*
 			 *	Hack to keep track of ordinal number of the device that
 			 *	corresponds to a container. Needed to convert
@@ -1504,17 +1705,19 @@
 			 */
 			 
 			spin_unlock_irq(host->host_lock);
-			if  (scsicmd->request->rq_disk)
-				memcpy(fsa_dev_ptr[cid].devname,
-					scsicmd->request->rq_disk->disk_name,
-					8);
-
+			if (scsicmd->request->rq_disk)
+				strlcpy(fsa_dev_ptr[cid].devname,
+				scsicmd->request->rq_disk->disk_name,
+			  	min(sizeof(fsa_dev_ptr[cid].devname),
+				sizeof(scsicmd->request->rq_disk->disk_name) + 1));
 			ret = aac_read(scsicmd, cid);
 			spin_lock_irq(host->host_lock);
 			return ret;
 
 		case WRITE_6:
 		case WRITE_10:
+		case WRITE_12:
+		case WRITE_16:
 			spin_unlock_irq(host->host_lock);
 			ret = aac_write(scsicmd, cid);
 			spin_lock_irq(host->host_lock);
@@ -1745,6 +1948,8 @@
 		case  WRITE_10:
 		case  READ_12:
 		case  WRITE_12:
+		case  READ_16:
+		case  WRITE_16:
 			if(le32_to_cpu(srbreply->data_xfer_length) < scsicmd->underflow ) {
 				printk(KERN_WARNING"aacraid: SCSI CMD underflow\n");
 			} else {
@@ -1850,8 +2055,8 @@
 				sizeof(scsicmd->sense_buffer) :
 				le32_to_cpu(srbreply->sense_data_size);
 #ifdef AAC_DETAILED_STATUS_INFO
-		dprintk((KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n", 
-					le32_to_cpu(srbreply->status), len));
+		printk(KERN_WARNING "aac_srb_callback: check condition, status = %d len=%d\n",
+					le32_to_cpu(srbreply->status), len);
 #endif
 		memcpy(scsicmd->sense_buffer, srbreply->sense_data, len);
 		
Index: scsi-misc-aac-2/drivers/scsi/aacraid/aacraid.h
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/aacraid.h	2005-09-08 11:31:18.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/aacraid.h	2005-09-20 13:20:04.000000000 -0700
@@ -1,6 +1,10 @@
 #if (!defined(dprintk))
 # define dprintk(x)
 #endif
+/* eg: if (nblank(dprintk(x))) */
+#define _nblank(x) #x
+#define nblank(x) _nblank(x)[0]
+
 
 /*------------------------------------------------------------------------------
  *              D E F I N E S
@@ -1012,6 +1016,7 @@
 	/* macro side-effects BEWARE */
 #	define			raw_io_interface \
 	  init->InitStructRevision==cpu_to_le32(ADAPTER_INIT_STRUCT_REVISION_4)
+	u8			raw_io_64;
 	u8			printf_enabled;
 };
 
@@ -1362,8 +1367,10 @@
 #define		VM_CtBlockVerify64	18
 #define		VM_CtHostRead64		19
 #define		VM_CtHostWrite64	20
+#define		VM_DrvErrTblLog		21
+#define		VM_NameServe64		22
 
-#define		MAX_VMCOMMAND_NUM	21	/* used for sizing stats array - leave last */
+#define		MAX_VMCOMMAND_NUM	23	/* used for sizing stats array - leave last */
 
 /*
  *	Descriptive information (eg, vital stats)
@@ -1472,6 +1479,7 @@
 						   manager (eg, filesystem) */
 	__le32			altoid;		/* != oid <==> snapshot or 
 						   broken mirror exists */
+	__le32			capacityhigh;
 };
 
 #define FSCS_NOTCLEAN	0x0001  /* fsck is neccessary before mounting */
Index: scsi-misc-aac-2/drivers/scsi/aacraid/comminit.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/comminit.c	2005-09-08 11:00:19.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/comminit.c	2005-09-20 13:20:02.000000000 -0700
@@ -315,6 +315,13 @@
 		- sizeof(struct aac_fibhdr)
 		- sizeof(struct aac_write) + sizeof(struct sgmap))
 			/ sizeof(struct sgmap);
+	dev->raw_io_64 = 0;
+	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
+		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
+	 		(status[0] == 0x00000001)) {
+		if (status[1] & AAC_OPT_NEW_COMM_64)
+			dev->raw_io_64 = 1;
+	}
 	if ((!aac_adapter_sync_cmd(dev, GET_COMM_PREFERRED_SETTINGS,
 	  0, 0, 0, 0, 0, 0,
 	  status+0, status+1, status+2, status+3, status+4))
Index: scsi-misc-aac-2/drivers/scsi/aacraid/linit.c
===================================================================
--- scsi-misc-aac-2.orig/drivers/scsi/aacraid/linit.c	2005-09-08 11:31:18.000000000 -0700
+++ scsi-misc-aac-2/drivers/scsi/aacraid/linit.c	2005-09-20 13:20:03.000000000 -0700
@@ -772,6 +772,7 @@
 	shost->irq = pdev->irq;
 	shost->base = pci_resource_start(pdev, 0);
 	shost->unique_id = unique_id;
+	shost->max_cmd_len = 16;
 
 	aac = (struct aac_dev *)shost->hostdata;
 	aac->scsi_host_ptr = shost;	


-- 
Mark Haverkamp <markh@osdl.org>

