From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6.9 aacraid: Add get container name functionality
Date: Mon, 04 Oct 2004 09:12:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096906348.9015.28.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:45699 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S267549AbUJDQMf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2004 12:12:35 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

James,

Next patch in the Adaptec raid driver update.

Description from Mark Salyzyn:
This patch to aacraid overrides the default naming for an array with the
programmed array name when set. The array name can be set in the BIOS,
or the management applications.

Applies to latest scsi-misc bk tree.

Signed-off-by: Mark Haverkamp <markh@osdl.org>


===== drivers/scsi/aacraid/aachba.c 1.28 vs edited =====
--- 1.28/drivers/scsi/aacraid/aachba.c	2004-09-27 07:27:33 -07:00
+++ edited/drivers/scsi/aacraid/aachba.c	2004-10-01 08:10:08 -07:00
@@ -335,6 +335,92 @@
 	return status;
 }
 
+static void aac_io_done(struct scsi_cmnd * scsicmd)
+{
+	unsigned long cpu_flags;
+	struct Scsi_Host *host = scsicmd->device->host;
+	spin_lock_irqsave(host->host_lock, cpu_flags);
+	scsicmd->scsi_done(scsicmd);
+	spin_unlock_irqrestore(host->host_lock, cpu_flags);
+}
+
+static void get_container_name_callback(void *context, struct fib * fibptr)
+{
+	struct aac_get_name_resp * get_name_reply;
+	struct scsi_cmnd * scsicmd;
+
+	scsicmd = (struct scsi_cmnd *) context;
+
+	dprintk((KERN_DEBUG "get_container_name_callback[cpu %d]: t = %ld.\n", smp_processor_id(), jiffies));
+	if (fibptr == NULL)
+		BUG();
+
+	get_name_reply = (struct aac_get_name_resp *) fib_data(fibptr);
+	/* Failure is irrelevant, using default value instead */
+	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
+	 && (get_name_reply->data[0] != '\0')) {
+		int    count;
+		char * dp;
+		char * sp = get_name_reply->data;
+		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)-1] = '\0';
+		while (*sp == ' ')
+			++sp;
+		count = sizeof(((struct inquiry_data *)NULL)->inqd_pid);
+		dp = ((struct inquiry_data *)scsicmd->request_buffer)->inqd_pid;
+		if (*sp) do {
+			*dp++ = (*sp) ? *sp++ : ' ';
+		} while (--count > 0);
+	}
+	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+
+	fib_complete(fibptr);
+	fib_free(fibptr);
+	aac_io_done(scsicmd);
+}
+
+/**
+ *	aac_get_container_name	-	get container name, none blocking.
+ */
+static int aac_get_container_name(struct scsi_cmnd * scsicmd, int cid)
+{
+	int status;
+	struct aac_get_name *dinfo;
+	struct fib * cmd_fibcontext;
+	struct aac_dev * dev;
+
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
+
+	if (!(cmd_fibcontext = fib_alloc(dev)))
+		return -ENOMEM;
+
+	fib_init(cmd_fibcontext);
+	dinfo = (struct aac_get_name *) fib_data(cmd_fibcontext);
+
+	dinfo->command = cpu_to_le32(VM_ContainerConfig);
+	dinfo->type = cpu_to_le32(CT_READ_NAME);
+	dinfo->cid = cpu_to_le32(cid);
+	dinfo->count = cpu_to_le32(sizeof(((struct aac_get_name_resp *)NULL)->data));
+
+	status = fib_send(ContainerCommand, 
+		  cmd_fibcontext, 
+		  sizeof (struct aac_get_name),
+		  FsaNormal, 
+		  0, 1, 
+		  (fib_callback) get_container_name_callback, 
+		  (void *) scsicmd);
+	
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS) 
+		return 0;
+		
+	printk(KERN_WARNING "aac_get_container_name: fib_send failed with status: %d.\n", status);
+	fib_complete(cmd_fibcontext);
+	fib_free(cmd_fibcontext);
+	return -1;
+}
+
 /**
  *	probe_container		-	query a logical volume
  *	@dev: device to query
@@ -446,14 +532,13 @@
  * Arguments: [1] pointer to void [1] int
  *
  * Purpose: Sets SCSI inquiry data strings for vendor, product
- * and revision level. Allows strings to be set in platform dependent
- * files instead of in OS dependent driver source.
+ * and revision level. Allows strings to be set in platform dependant
+ * files instead of in OS dependant driver source.
  */
 
 static void setinqstr(int devtype, void *data, int tindex)
 {
 	struct scsi_inq *str;
-	char *findit;
 	struct aac_driver_ident *mp;
 
 	mp = aac_get_driver_ident(devtype);
@@ -463,13 +548,14 @@
 	inqstrcpy (mp->vname, str->vid); 
 	inqstrcpy (mp->model, str->pid); /* last six chars reserved for vol type */
 
-	findit = str->pid;
-
-	for ( ; *findit != ' '; findit++); /* walk till we find a space then incr by 1 */
-		findit++;
-	
 	if (tindex < (sizeof(container_types)/sizeof(char *))){
-		inqstrcpy (container_types[tindex], findit);
+		char *findit = str->pid;
+
+		for ( ; *findit != ' '; findit++); /* walk till we find a space */
+		/* RAID is superfluous in the context of a RAID device */
+		if (memcmp(findit-4, "RAID", 4) == 0)
+			*(findit -= 4) = ' ';
+		inqstrcpy (container_types[tindex], findit + 1);
 	}
 	inqstrcpy ("V1.0", str->prl);
 }
@@ -514,20 +600,6 @@
 	}
 }
 
-static void aac_io_done(struct scsi_cmnd * scsicmd)
-{
-	unsigned long cpu_flags;
-	struct Scsi_Host *host = scsicmd->device->host;
-	spin_lock_irqsave(host->host_lock, cpu_flags);
-	scsicmd->scsi_done(scsicmd);
-	spin_unlock_irqrestore(host->host_lock, cpu_flags);
-}
-
-static void __aac_io_done(struct scsi_cmnd * scsicmd)
-{
-	scsicmd->scsi_done(scsicmd);
-}
-
 int aac_get_adapter_info(struct aac_dev* dev)
 {
 	struct fib* fibptr;
@@ -962,7 +1034,7 @@
 		if ((scsicmd->device->channel == 0) ){
 			if( (scsicmd->device->id >= dev->maximum_num_containers) || (scsicmd->device->lun != 0)){ 
 				scsicmd->result = DID_NO_CONNECT << 16;
-				__aac_io_done(scsicmd);
+				scsicmd->scsi_done(scsicmd);
 				return 0;
 			}
 			cid = ID_LUN_TO_CONTAINER(scsicmd->device->id, scsicmd->device->lun);
@@ -981,7 +1053,7 @@
 					spin_lock_irq(host->host_lock);
 					if (fsa_dev_ptr[cid].valid == 0) {
 						scsicmd->result = DID_NO_CONNECT << 16;
-						__aac_io_done(scsicmd);
+						scsicmd->scsi_done(scsicmd);
 						return 0;
 					}
 				default:
@@ -994,7 +1066,7 @@
 			 */
 			if (fsa_dev_ptr[cid].valid == 0) {
 				scsicmd->result = DID_BAD_TARGET << 16;
-				__aac_io_done(scsicmd);
+				scsicmd->scsi_done(scsicmd);
 				return 0;
 			}
 		} else {  /* check for physical non-dasd devices */
@@ -1002,7 +1074,7 @@
 				return aac_send_srb_fib(scsicmd);
 			} else {
 				scsicmd->result = DID_NO_CONNECT << 16;
-				__aac_io_done(scsicmd);
+				scsicmd->scsi_done(scsicmd);
 				return 0;
 			}
 		}
@@ -1023,7 +1095,7 @@
 		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
 		    ? sizeof(scsicmd->sense_buffer)
 		    : sizeof(dev->fsa_dev[cid].sense_data));
-		__aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
 
@@ -1048,14 +1120,16 @@
 		 *	Set the Vendor, Product, and Revision Level
 		 *	see: <vendor>.c i.e. aac.c
 		 */
-		setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), fsa_dev_ptr[cid].type);
-		if (scsicmd->device->id == host->this_id)
+		if (scsicmd->device->id == host->this_id) {
+			setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), (sizeof(container_types)/sizeof(char *)));
 			inq_data_ptr->inqd_pdt = INQD_PDT_PROC;	/* Processor device */
-		else
-			inq_data_ptr->inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
-		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		__aac_io_done(scsicmd);
-		return 0;
+			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
+			scsicmd->scsi_done(scsicmd);
+			return 0;
+		}
+		setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), fsa_dev_ptr[cid].type);
+		inq_data_ptr->inqd_pdt = INQD_PDT_DA;	/* Direct/random access device */
+		return aac_get_container_name(scsicmd, cid);
 	}
 	case READ_CAPACITY:
 	{
@@ -1078,7 +1152,7 @@
 		cp[7] = 0;
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		__aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 
 		return 0;
 	}
@@ -1095,7 +1169,7 @@
 		mode_buf[3] = 0;	/* Block descriptor length */
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		__aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 
 		return 0;
 	}
@@ -1115,7 +1189,7 @@
 		mode_buf[7] = 0;	/* Block descriptor length (LSB) */
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		__aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 
 		return 0;
 	}
@@ -1124,7 +1198,7 @@
 		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data, sizeof (struct sense_data));
 		memset(&dev->fsa_dev[cid].sense_data, 0, sizeof (struct sense_data));
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		__aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 		return 0;
 
 	case ALLOW_MEDIUM_REMOVAL:
@@ -1135,7 +1209,7 @@
 			fsa_dev_ptr[cid].locked = 0;
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		__aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 		return 0;
 	/*
 	 *	These commands are all No-Ops
@@ -1148,7 +1222,7 @@
 	case SEEK_10:
 	case START_STOP:
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
-		__aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
 
@@ -1191,7 +1265,7 @@
 			  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
 			    ? sizeof(scsicmd->sense_buffer)
 			    : sizeof(dev->fsa_dev[cid].sense_data));
-			__aac_io_done(scsicmd);
+			scsicmd->scsi_done(scsicmd);
 			return 0;
 	}
 }
@@ -1518,7 +1592,7 @@
 
 	if( scsicmd->device->id > 15 || scsicmd->device->lun > 7) {
 		scsicmd->result = DID_NO_CONNECT << 16;
-		__aac_io_done(scsicmd);
+		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
 
===== drivers/scsi/aacraid/aacraid.h 1.23 vs edited =====
--- 1.23/drivers/scsi/aacraid/aacraid.h	2004-09-23 10:00:36 -07:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-10-01 08:09:07 -07:00
@@ -1307,6 +1307,31 @@
 	struct aac_mntent mnt[1];
 };
 
+#define CT_READ_NAME 130
+struct aac_get_name {
+	u32		command;	/* VM_ContainerConfig */
+	u32		type;		/* CT_READ_NAME */
+	u32		cid;
+	u32		parm1;
+	u32		parm2;
+	u32		parm3;
+	u32		parm4;
+	u32		count;	/* sizeof(((struct aac_get_name_resp *)NULL)->data) */
+};
+
+#define CT_OK        218
+struct aac_get_name_resp {
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
 /*
  * The following command is sent to shut down each container.
  */

-- 
Mark Haverkamp <markh@osdl.org>

