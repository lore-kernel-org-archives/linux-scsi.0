From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 5/7] aacraid: remove un-needed references to container id
	(cid)
Date: Thu, 15 Mar 2007 10:26:55 -0700
Message-ID: <1173979615.30374.24.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60802 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXCOR06 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 13:26:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

This little patch removes the ',cid)' container identification argument
from some of the functions. The argument is used in some cases as merely
a debug helper and thus not used, and in others, the value can be
quickly acquired from the scsi command in their single solitary use in
the procedure rather than wasting resources on passing the argument in
from above.

Signed-off-by: Mark Haverkamp <markh@linux-foundation.org>

---


--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2007-03-15 08:30:15.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2007-03-15 08:30:19.000000000 -0700
@@ -375,7 +375,7 @@ static void get_container_name_callback(
 /**
  *	aac_get_container_name	-	get container name, none blocking.
  */
-static int aac_get_container_name(struct scsi_cmnd * scsicmd, int cid)
+static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 {
 	int status;
 	struct aac_get_name *dinfo;
@@ -392,7 +392,7 @@ static int aac_get_container_name(struct
 
 	dinfo->command = cpu_to_le32(VM_ContainerConfig);
 	dinfo->type = cpu_to_le32(CT_READ_NAME);
-	dinfo->cid = cpu_to_le32(cid);
+	dinfo->cid = cpu_to_le32(scmd_id(scsicmd));
 	dinfo->count = cpu_to_le32(sizeof(((struct aac_get_name_resp *)NULL)->data));
 
 	status = aac_fib_send(ContainerCommand,
@@ -1361,7 +1361,7 @@ static void io_callback(void *context, s
 	scsicmd->scsi_done(scsicmd);
 }
 
-static int aac_read(struct scsi_cmnd * scsicmd, int cid)
+static int aac_read(struct scsi_cmnd * scsicmd)
 {
 	u64 lba;
 	u32 count;
@@ -1375,7 +1375,7 @@ static int aac_read(struct scsi_cmnd * s
 	 */
 	switch (scsicmd->cmnd[0]) {
 	case READ_6:
-		dprintk((KERN_DEBUG "aachba: received a read(6) command on id %d.\n", cid));
+		dprintk((KERN_DEBUG "aachba: received a read(6) command on id %d.\n", scmd_id(scsicmd)));
 
 		lba = ((scsicmd->cmnd[1] & 0x1F) << 16) | 
 			(scsicmd->cmnd[2] << 8) | scsicmd->cmnd[3];
@@ -1385,7 +1385,7 @@ static int aac_read(struct scsi_cmnd * s
 			count = 256;
 		break;
 	case READ_16:
-		dprintk((KERN_DEBUG "aachba: received a read(16) command on id %d.\n", cid));
+		dprintk((KERN_DEBUG "aachba: received a read(16) command on id %d.\n", scmd_id(scsicmd)));
 
 		lba = 	((u64)scsicmd->cmnd[2] << 56) |
 		 	((u64)scsicmd->cmnd[3] << 48) |
@@ -1399,7 +1399,7 @@ static int aac_read(struct scsi_cmnd * s
 			(scsicmd->cmnd[12] << 8) | scsicmd->cmnd[13];
 		break;
 	case READ_12:
-		dprintk((KERN_DEBUG "aachba: received a read(12) command on id %d.\n", cid));
+		dprintk((KERN_DEBUG "aachba: received a read(12) command on id %d.\n", scmd_id(scsicmd)));
 
 		lba = ((u64)scsicmd->cmnd[2] << 24) | 
 			(scsicmd->cmnd[3] << 16) |
@@ -1409,7 +1409,7 @@ static int aac_read(struct scsi_cmnd * s
 		      	(scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
 		break;
 	default:
-		dprintk((KERN_DEBUG "aachba: received a read(10) command on id %d.\n", cid));
+		dprintk((KERN_DEBUG "aachba: received a read(10) command on id %d.\n", scmd_id(scsicmd)));
 
 		lba = ((u64)scsicmd->cmnd[2] << 24) | 
 			(scsicmd->cmnd[3] << 16) | 
@@ -1449,7 +1449,7 @@ static int aac_read(struct scsi_cmnd * s
 	return 0;
 }
 
-static int aac_write(struct scsi_cmnd * scsicmd, int cid)
+static int aac_write(struct scsi_cmnd * scsicmd)
 {
 	u64 lba;
 	u32 count;
@@ -1468,7 +1468,7 @@ static int aac_write(struct scsi_cmnd * 
 		if (count == 0)
 			count = 256;
 	} else if (scsicmd->cmnd[0] == WRITE_16) { /* 16 byte command */
-		dprintk((KERN_DEBUG "aachba: received a write(16) command on id %d.\n", cid));
+		dprintk((KERN_DEBUG "aachba: received a write(16) command on id %d.\n", scmd_id(scsicmd)));
 
 		lba = 	((u64)scsicmd->cmnd[2] << 56) |
 			((u64)scsicmd->cmnd[3] << 48) |
@@ -1480,14 +1480,14 @@ static int aac_write(struct scsi_cmnd * 
 		count = (scsicmd->cmnd[10] << 24) | (scsicmd->cmnd[11] << 16) |
 			(scsicmd->cmnd[12] << 8) | scsicmd->cmnd[13];
 	} else if (scsicmd->cmnd[0] == WRITE_12) { /* 12 byte command */
-		dprintk((KERN_DEBUG "aachba: received a write(12) command on id %d.\n", cid));
+		dprintk((KERN_DEBUG "aachba: received a write(12) command on id %d.\n", scmd_id(scsicmd)));
 
 		lba = ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16)
 		    | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
 		count = (scsicmd->cmnd[6] << 24) | (scsicmd->cmnd[7] << 16)
 		      | (scsicmd->cmnd[8] << 8) | scsicmd->cmnd[9];
 	} else {
-		dprintk((KERN_DEBUG "aachba: received a write(10) command on id %d.\n", cid));
+		dprintk((KERN_DEBUG "aachba: received a write(10) command on id %d.\n", scmd_id(scsicmd)));
 		lba = ((u64)scsicmd->cmnd[2] << 24) | (scsicmd->cmnd[3] << 16) | (scsicmd->cmnd[4] << 8) | scsicmd->cmnd[5];
 		count = (scsicmd->cmnd[7] << 8) | scsicmd->cmnd[8];
 	}
@@ -1567,7 +1567,7 @@ static void synchronize_callback(void *c
 	cmd->scsi_done(cmd);
 }
 
-static int aac_synchronize(struct scsi_cmnd *scsicmd, int cid)
+static int aac_synchronize(struct scsi_cmnd *scsicmd)
 {
 	int status;
 	struct fib *cmd_fibcontext;
@@ -1612,7 +1612,7 @@ static int aac_synchronize(struct scsi_c
 	synchronizecmd = fib_data(cmd_fibcontext);
 	synchronizecmd->command = cpu_to_le32(VM_ContainerConfig);
 	synchronizecmd->type = cpu_to_le32(CT_FLUSH_CACHE);
-	synchronizecmd->cid = cpu_to_le32(cid);
+	synchronizecmd->cid = cpu_to_le32(scmd_id(scsicmd));
 	synchronizecmd->count = 
 	     cpu_to_le32(sizeof(((struct aac_synchronize_reply *)NULL)->data));
 
@@ -1760,7 +1760,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 		setinqstr(dev, (void *) (inq_data.inqd_vid), fsa_dev_ptr[cid].type);
 		inq_data.inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
 		aac_internal_transfer(scsicmd, &inq_data, 0, sizeof(inq_data));
-		return aac_get_container_name(scsicmd, cid);
+		return aac_get_container_name(scsicmd);
 	}
 	case SERVICE_ACTION_IN:
 		if (!(dev->raw_io_interface) ||
@@ -1926,7 +1926,7 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 			  	min(sizeof(fsa_dev_ptr[cid].devname),
 				sizeof(scsicmd->request->rq_disk->disk_name) + 1));
 
-			return aac_read(scsicmd, cid);
+			return aac_read(scsicmd);
 
 		case WRITE_6:
 		case WRITE_10:
@@ -1934,11 +1934,11 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 		case WRITE_16:
 			if (dev->in_reset)
 				return -1;
-			return aac_write(scsicmd, cid);
+			return aac_write(scsicmd);
 
 		case SYNCHRONIZE_CACHE:
 			/* Issue FIB to tell Firmware to flush it's cache */
-			return aac_synchronize(scsicmd, cid);
+			return aac_synchronize(scsicmd);
 			
 		default:
 			/*

-- 
Mark Haverkamp <markh@linux-foundation.org>

