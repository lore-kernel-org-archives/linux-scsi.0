From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/3] aacraid: Update global function names
Date: Wed, 01 Feb 2006 09:30:55 -0800
Message-ID: <1138815055.27662.15.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:25999 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1422677AbWBARbA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 12:31:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

Reduce the possibility of namespace collision.  Prefix with aac_.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-02-01 09:02:10.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-02-01 09:02:46.000000000 -0800
@@ -173,10 +173,10 @@
 	int status = 0;
 	struct fib * fibptr;
 
-	if (!(fibptr = fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev)))
 		return -ENOMEM;
 
-	fib_init(fibptr);
+	aac_fib_init(fibptr);
 	{
 		struct aac_get_config_status *dinfo;
 		dinfo = (struct aac_get_config_status *) fib_data(fibptr);
@@ -186,7 +186,7 @@
 		dinfo->count = cpu_to_le32(sizeof(((struct aac_get_config_status_resp *)NULL)->data));
 	}
 
-	status = fib_send(ContainerCommand,
+	status = aac_fib_send(ContainerCommand,
 			    fibptr,
 			    sizeof (struct aac_get_config_status),
 			    FsaNormal,
@@ -209,30 +209,30 @@
 			status = -EINVAL;
 		}
 	}
-	fib_complete(fibptr);
+	aac_fib_complete(fibptr);
 	/* Send a CT_COMMIT_CONFIG to enable discovery of devices */
 	if (status >= 0) {
 		if (commit == 1) {
 			struct aac_commit_config * dinfo;
-			fib_init(fibptr);
+			aac_fib_init(fibptr);
 			dinfo = (struct aac_commit_config *) fib_data(fibptr);
 	
 			dinfo->command = cpu_to_le32(VM_ContainerConfig);
 			dinfo->type = cpu_to_le32(CT_COMMIT_CONFIG);
 	
-			status = fib_send(ContainerCommand,
+			status = aac_fib_send(ContainerCommand,
 				    fibptr,
 				    sizeof (struct aac_commit_config),
 				    FsaNormal,
 				    1, 1,
 				    NULL, NULL);
-			fib_complete(fibptr);
+			aac_fib_complete(fibptr);
 		} else if (commit == 0) {
 			printk(KERN_WARNING
 			  "aac_get_config_status: Foreign device configurations are being ignored\n");
 		}
 	}
-	fib_free(fibptr);
+	aac_fib_free(fibptr);
 	return status;
 }
 
@@ -255,15 +255,15 @@
 
 	instance = dev->scsi_host_ptr->unique_id;
 
-	if (!(fibptr = fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev)))
 		return -ENOMEM;
 
-	fib_init(fibptr);
+	aac_fib_init(fibptr);
 	dinfo = (struct aac_get_container_count *) fib_data(fibptr);
 	dinfo->command = cpu_to_le32(VM_ContainerConfig);
 	dinfo->type = cpu_to_le32(CT_GET_CONTAINER_COUNT);
 
-	status = fib_send(ContainerCommand,
+	status = aac_fib_send(ContainerCommand,
 		    fibptr,
 		    sizeof (struct aac_get_container_count),
 		    FsaNormal,
@@ -272,7 +272,7 @@
 	if (status >= 0) {
 		dresp = (struct aac_get_container_count_resp *)fib_data(fibptr);
 		maximum_num_containers = le32_to_cpu(dresp->ContainerSwitchEntries);
-		fib_complete(fibptr);
+		aac_fib_complete(fibptr);
 	}
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
@@ -280,7 +280,7 @@
 	fsa_dev_ptr = (struct fsa_dev_info *) kmalloc(
 	  sizeof(*fsa_dev_ptr) * maximum_num_containers, GFP_KERNEL);
 	if (!fsa_dev_ptr) {
-		fib_free(fibptr);
+		aac_fib_free(fibptr);
 		return -ENOMEM;
 	}
 	memset(fsa_dev_ptr, 0, sizeof(*fsa_dev_ptr) * maximum_num_containers);
@@ -294,14 +294,14 @@
 
 		fsa_dev_ptr[index].devname[0] = '\0';
 
-		fib_init(fibptr);
+		aac_fib_init(fibptr);
 		dinfo = (struct aac_query_mount *) fib_data(fibptr);
 
 		dinfo->command = cpu_to_le32(VM_NameServe);
 		dinfo->count = cpu_to_le32(index);
 		dinfo->type = cpu_to_le32(FT_FILESYS);
 
-		status = fib_send(ContainerCommand,
+		status = aac_fib_send(ContainerCommand,
 				    fibptr,
 				    sizeof (struct aac_query_mount),
 				    FsaNormal,
@@ -319,7 +319,7 @@
 			dinfo->count = cpu_to_le32(index);
 			dinfo->type = cpu_to_le32(FT_FILESYS);
 
-			if (fib_send(ContainerCommand,
+			if (aac_fib_send(ContainerCommand,
 				    fibptr,
 				    sizeof(struct aac_query_mount),
 				    FsaNormal,
@@ -347,7 +347,7 @@
 			if (le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY)
 				    fsa_dev_ptr[index].ro = 1;
 		}
-		fib_complete(fibptr);
+		aac_fib_complete(fibptr);
 		/*
 		 *	If there are no more containers, then stop asking.
 		 */
@@ -355,7 +355,7 @@
 			break;
 		}
 	}
-	fib_free(fibptr);
+	aac_fib_free(fibptr);
 	return status;
 }
 
@@ -413,8 +413,8 @@
 
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 
-	fib_complete(fibptr);
-	fib_free(fibptr);
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
 	scsicmd->scsi_done(scsicmd);
 }
 
@@ -430,10 +430,10 @@
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
-	if (!(cmd_fibcontext = fib_alloc(dev)))
+	if (!(cmd_fibcontext = aac_fib_alloc(dev)))
 		return -ENOMEM;
 
-	fib_init(cmd_fibcontext);
+	aac_fib_init(cmd_fibcontext);
 	dinfo = (struct aac_get_name *) fib_data(cmd_fibcontext);
 
 	dinfo->command = cpu_to_le32(VM_ContainerConfig);
@@ -441,7 +441,7 @@
 	dinfo->cid = cpu_to_le32(cid);
 	dinfo->count = cpu_to_le32(sizeof(((struct aac_get_name_resp *)NULL)->data));
 
-	status = fib_send(ContainerCommand, 
+	status = aac_fib_send(ContainerCommand,
 		  cmd_fibcontext, 
 		  sizeof (struct aac_get_name),
 		  FsaNormal, 
@@ -455,14 +455,14 @@
 	if (status == -EINPROGRESS) 
 		return 0;
 		
-	printk(KERN_WARNING "aac_get_container_name: fib_send failed with status: %d.\n", status);
-	fib_complete(cmd_fibcontext);
-	fib_free(cmd_fibcontext);
+	printk(KERN_WARNING "aac_get_container_name: aac_fib_send failed with status: %d.\n", status);
+	aac_fib_complete(cmd_fibcontext);
+	aac_fib_free(cmd_fibcontext);
 	return -1;
 }
 
 /**
- *	probe_container		-	query a logical volume
+ *	aac_probe_container		-	query a logical volume
  *	@dev: device to query
  *	@cid: container identifier
  *
@@ -470,7 +470,7 @@
  *	is updated in the struct fsa_dev_info structure rather than returned.
  */
  
-int probe_container(struct aac_dev *dev, int cid)
+int aac_probe_container(struct aac_dev *dev, int cid)
 {
 	struct fsa_dev_info *fsa_dev_ptr;
 	int status;
@@ -482,10 +482,10 @@
 	fsa_dev_ptr = dev->fsa_dev;
 	instance = dev->scsi_host_ptr->unique_id;
 
-	if (!(fibptr = fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev)))
 		return -ENOMEM;
 
-	fib_init(fibptr);
+	aac_fib_init(fibptr);
 
 	dinfo = (struct aac_query_mount *)fib_data(fibptr);
 
@@ -493,14 +493,14 @@
 	dinfo->count = cpu_to_le32(cid);
 	dinfo->type = cpu_to_le32(FT_FILESYS);
 
-	status = fib_send(ContainerCommand,
+	status = aac_fib_send(ContainerCommand,
 			    fibptr,
 			    sizeof(struct aac_query_mount),
 			    FsaNormal,
 			    1, 1,
 			    NULL, NULL);
 	if (status < 0) {
-		printk(KERN_WARNING "aacraid: probe_container query failed.\n");
+		printk(KERN_WARNING "aacraid: aac_probe_container query failed.\n");
 		goto error;
 	}
 
@@ -512,7 +512,7 @@
 		dinfo->count = cpu_to_le32(cid);
 		dinfo->type = cpu_to_le32(FT_FILESYS);
 
-		if (fib_send(ContainerCommand,
+		if (aac_fib_send(ContainerCommand,
 			    fibptr,
 			    sizeof(struct aac_query_mount),
 			    FsaNormal,
@@ -535,8 +535,8 @@
 	}
 
 error:
-	fib_complete(fibptr);
-	fib_free(fibptr);
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
 
 	return status;
 }
@@ -700,14 +700,14 @@
 	struct aac_bus_info *command;
 	struct aac_bus_info_response *bus_info;
 
-	if (!(fibptr = fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev)))
 		return -ENOMEM;
 
-	fib_init(fibptr);
+	aac_fib_init(fibptr);
 	info = (struct aac_adapter_info *) fib_data(fibptr);
 	memset(info,0,sizeof(*info));
 
-	rcode = fib_send(RequestAdapterInfo,
+	rcode = aac_fib_send(RequestAdapterInfo,
 			 fibptr, 
 			 sizeof(*info),
 			 FsaNormal, 
@@ -716,8 +716,8 @@
 			 NULL);
 
 	if (rcode < 0) {
-		fib_complete(fibptr);
-		fib_free(fibptr);
+		aac_fib_complete(fibptr);
+		aac_fib_free(fibptr);
 		return rcode;
 	}
 	memcpy(&dev->adapter_info, info, sizeof(*info));
@@ -725,13 +725,13 @@
 	if (dev->adapter_info.options & AAC_OPT_SUPPLEMENT_ADAPTER_INFO) {
 		struct aac_supplement_adapter_info * info;
 
-		fib_init(fibptr);
+		aac_fib_init(fibptr);
 
 		info = (struct aac_supplement_adapter_info *) fib_data(fibptr);
 
 		memset(info,0,sizeof(*info));
 
-		rcode = fib_send(RequestSupplementAdapterInfo,
+		rcode = aac_fib_send(RequestSupplementAdapterInfo,
 				 fibptr,
 				 sizeof(*info),
 				 FsaNormal,
@@ -748,7 +748,7 @@
 	 * GetBusInfo 
 	 */
 
-	fib_init(fibptr);
+	aac_fib_init(fibptr);
 
 	bus_info = (struct aac_bus_info_response *) fib_data(fibptr);
 
@@ -761,7 +761,7 @@
 	command->MethodId = cpu_to_le32(1);
 	command->CtlCmd = cpu_to_le32(GetBusInfo);
 
-	rcode = fib_send(ContainerCommand,
+	rcode = aac_fib_send(ContainerCommand,
 			 fibptr,
 			 sizeof (*bus_info),
 			 FsaNormal,
@@ -891,8 +891,8 @@
 		}
 	}
 
-	fib_complete(fibptr);
-	fib_free(fibptr);
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
 
 	return rcode;
 }
@@ -976,8 +976,8 @@
 		    ? sizeof(scsicmd->sense_buffer)
 		    : sizeof(dev->fsa_dev[cid].sense_data));
 	}
-	fib_complete(fibptr);
-	fib_free(fibptr);
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
 
 	scsicmd->scsi_done(scsicmd);
 }
@@ -1062,11 +1062,11 @@
 	/*
 	 *	Alocate and initialize a Fib
 	 */
-	if (!(cmd_fibcontext = fib_alloc(dev))) {
+	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
 		return -1;
 	}
 
-	fib_init(cmd_fibcontext);
+	aac_fib_init(cmd_fibcontext);
 
 	if (dev->raw_io_interface) {
 		struct aac_raw_io *readcmd;
@@ -1086,7 +1086,7 @@
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ContainerRawIo,
+		status = aac_fib_send(ContainerRawIo,
 			  cmd_fibcontext, 
 			  fibsize, 
 			  FsaNormal, 
@@ -1112,7 +1112,7 @@
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ContainerCommand64, 
+		status = aac_fib_send(ContainerCommand64,
 			  cmd_fibcontext, 
 			  fibsize, 
 			  FsaNormal, 
@@ -1136,7 +1136,7 @@
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ContainerCommand, 
+		status = aac_fib_send(ContainerCommand,
 			  cmd_fibcontext, 
 			  fibsize, 
 			  FsaNormal, 
@@ -1153,14 +1153,14 @@
 	if (status == -EINPROGRESS) 
 		return 0;
 		
-	printk(KERN_WARNING "aac_read: fib_send failed with status: %d.\n", status);
+	printk(KERN_WARNING "aac_read: aac_fib_send failed with status: %d.\n", status);
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
 	scsicmd->scsi_done(scsicmd);
-	fib_complete(cmd_fibcontext);
-	fib_free(cmd_fibcontext);
+	aac_fib_complete(cmd_fibcontext);
+	aac_fib_free(cmd_fibcontext);
 	return 0;
 }
 
@@ -1228,12 +1228,12 @@
 	/*
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
-	if (!(cmd_fibcontext = fib_alloc(dev))) {
+	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
 		scsicmd->result = DID_ERROR << 16;
 		scsicmd->scsi_done(scsicmd);
 		return 0;
 	}
-	fib_init(cmd_fibcontext);
+	aac_fib_init(cmd_fibcontext);
 
 	if (dev->raw_io_interface) {
 		struct aac_raw_io *writecmd;
@@ -1253,7 +1253,7 @@
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ContainerRawIo,
+		status = aac_fib_send(ContainerRawIo,
 			  cmd_fibcontext, 
 			  fibsize, 
 			  FsaNormal, 
@@ -1279,7 +1279,7 @@
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ContainerCommand64, 
+		status = aac_fib_send(ContainerCommand64,
 			  cmd_fibcontext, 
 			  fibsize, 
 			  FsaNormal, 
@@ -1305,7 +1305,7 @@
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ContainerCommand, 
+		status = aac_fib_send(ContainerCommand,
 			  cmd_fibcontext, 
 			  fibsize, 
 			  FsaNormal, 
@@ -1322,15 +1322,15 @@
 		return 0;
 	}
 
-	printk(KERN_WARNING "aac_write: fib_send failed with status: %d\n", status);
+	printk(KERN_WARNING "aac_write: aac_fib_send failed with status: %d\n", status);
 	/*
 	 *	For some reason, the Fib didn't queue, return QUEUE_FULL
 	 */
 	scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_TASK_SET_FULL;
 	scsicmd->scsi_done(scsicmd);
 
-	fib_complete(cmd_fibcontext);
-	fib_free(cmd_fibcontext);
+	aac_fib_complete(cmd_fibcontext);
+	aac_fib_free(cmd_fibcontext);
 	return 0;
 }
 
@@ -1369,8 +1369,8 @@
 			  sizeof(cmd->sense_buffer)));
 	}
 
-	fib_complete(fibptr);
-	fib_free(fibptr);
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
 	cmd->scsi_done(cmd);
 }
 
@@ -1407,10 +1407,10 @@
 	 *	Allocate and initialize a Fib
 	 */
 	if (!(cmd_fibcontext = 
-	    fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) 
+	    aac_fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	fib_init(cmd_fibcontext);
+	aac_fib_init(cmd_fibcontext);
 
 	synchronizecmd = fib_data(cmd_fibcontext);
 	synchronizecmd->command = cpu_to_le32(VM_ContainerConfig);
@@ -1422,7 +1422,7 @@
 	/*
 	 *	Now send the Fib to the adapter
 	 */
-	status = fib_send(ContainerCommand,
+	status = aac_fib_send(ContainerCommand,
 		  cmd_fibcontext,
 		  sizeof(struct aac_synchronize),
 		  FsaNormal,
@@ -1437,9 +1437,9 @@
 		return 0;
 
 	printk(KERN_WARNING 
-		"aac_synchronize: fib_send failed with status: %d.\n", status);
-	fib_complete(cmd_fibcontext);
-	fib_free(cmd_fibcontext);
+		"aac_synchronize: aac_fib_send failed with status: %d.\n", status);
+	aac_fib_complete(cmd_fibcontext);
+	aac_fib_free(cmd_fibcontext);
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
@@ -1488,7 +1488,7 @@
 				case READ_CAPACITY:
 				case TEST_UNIT_READY:
 					spin_unlock_irq(host->host_lock);
-					probe_container(dev, cid);
+					aac_probe_container(dev, cid);
 					if ((fsa_dev_ptr[cid].valid & 1) == 0)
 						fsa_dev_ptr[cid].valid = 0;
 					spin_lock_irq(host->host_lock);
@@ -2042,8 +2042,8 @@
 	 */
 	scsicmd->result |= le32_to_cpu(srbreply->scsi_status);
 
-	fib_complete(fibptr);
-	fib_free(fibptr);
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
 	scsicmd->scsi_done(scsicmd);
 }
 
@@ -2095,10 +2095,10 @@
 	/*
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
-	if (!(cmd_fibcontext = fib_alloc(dev))) {
+	if (!(cmd_fibcontext = aac_fib_alloc(dev))) {
 		return -1;
 	}
-	fib_init(cmd_fibcontext);
+	aac_fib_init(cmd_fibcontext);
 
 	srbcmd = (struct aac_srb*) fib_data(cmd_fibcontext);
 	srbcmd->function = cpu_to_le32(SRBF_ExecuteScsi);
@@ -2132,7 +2132,7 @@
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ScsiPortCommand64, cmd_fibcontext, 
+		status = aac_fib_send(ScsiPortCommand64, cmd_fibcontext,
 				fibsize, FsaNormal, 0, 1,
 				  (fib_callback) aac_srb_callback, 
 				  (void *) scsicmd);
@@ -2154,7 +2154,7 @@
 		/*
 		 *	Now send the Fib to the adapter
 		 */
-		status = fib_send(ScsiPortCommand, cmd_fibcontext, fibsize, FsaNormal, 0, 1,
+		status = aac_fib_send(ScsiPortCommand, cmd_fibcontext, fibsize, FsaNormal, 0, 1,
 				  (fib_callback) aac_srb_callback, (void *) scsicmd);
 	}
 	/*
@@ -2164,9 +2164,9 @@
 		return 0;
 	}
 
-	printk(KERN_WARNING "aac_srb: fib_send failed with status: %d\n", status);
-	fib_complete(cmd_fibcontext);
-	fib_free(cmd_fibcontext);
+	printk(KERN_WARNING "aac_srb: aac_fib_send failed with status: %d\n", status);
+	aac_fib_complete(cmd_fibcontext);
+	aac_fib_free(cmd_fibcontext);
 
 	return -1;
 }
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-02-01 08:58:40.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-02-01 09:02:46.000000000 -0800
@@ -1774,16 +1774,16 @@
 struct scsi_cmnd;
 
 const char *aac_driverinfo(struct Scsi_Host *);
-struct fib *fib_alloc(struct aac_dev *dev);
-int fib_setup(struct aac_dev *dev);
-void fib_map_free(struct aac_dev *dev);
-void fib_free(struct fib * context);
-void fib_init(struct fib * context);
+struct fib *aac_fib_alloc(struct aac_dev *dev);
+int aac_fib_setup(struct aac_dev *dev);
+void aac_fib_map_free(struct aac_dev *dev);
+void aac_fib_free(struct fib * context);
+void aac_fib_init(struct fib * context);
 void aac_printf(struct aac_dev *dev, u32 val);
-int fib_send(u16 command, struct fib * context, unsigned long size, int priority, int wait, int reply, fib_callback callback, void *ctxt);
+int aac_fib_send(u16 command, struct fib * context, unsigned long size, int priority, int wait, int reply, fib_callback callback, void *ctxt);
 int aac_consumer_get(struct aac_dev * dev, struct aac_queue * q, struct aac_entry **entry);
 void aac_consumer_free(struct aac_dev * dev, struct aac_queue * q, u32 qnum);
-int fib_complete(struct fib * context);
+int aac_fib_complete(struct fib * context);
 #define fib_data(fibctx) ((void *)(fibctx)->hw_fib->data)
 struct aac_dev *aac_init_adapter(struct aac_dev *dev);
 int aac_get_config_status(struct aac_dev *dev);
@@ -1799,11 +1799,11 @@
 unsigned int aac_intr_normal(struct aac_dev * dev, u32 Index);
 int aac_command_thread(struct aac_dev * dev);
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context *fibctx);
-int fib_adapter_complete(struct fib * fibptr, unsigned short size);
+int aac_fib_adapter_complete(struct fib * fibptr, unsigned short size);
 struct aac_driver_ident* aac_get_driver_ident(int devtype);
 int aac_get_adapter_info(struct aac_dev* dev);
 int aac_send_shutdown(struct aac_dev *dev);
-int probe_container(struct aac_dev *dev, int cid);
+int aac_probe_container(struct aac_dev *dev, int cid);
 extern int numacb;
 extern int acbsize;
 extern char aac_driver_version[];
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2006-02-01 08:58:40.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2006-02-01 09:02:46.000000000 -0800
@@ -63,7 +63,7 @@
 	unsigned size;
 	int retval;
 
-	fibptr = fib_alloc(dev);
+	fibptr = aac_fib_alloc(dev);
 	if(fibptr == NULL) {
 		return -ENOMEM;
 	}
@@ -73,7 +73,7 @@
 	 *	First copy in the header so that we can check the size field.
 	 */
 	if (copy_from_user((void *)kfib, arg, sizeof(struct aac_fibhdr))) {
-		fib_free(fibptr);
+		aac_fib_free(fibptr);
 		return -EFAULT;
 	}
 	/*
@@ -110,13 +110,13 @@
 		 */
 		kfib->header.XferState = 0;
 	} else {
-		retval = fib_send(le16_to_cpu(kfib->header.Command), fibptr,
+		retval = aac_fib_send(le16_to_cpu(kfib->header.Command), fibptr,
 				le16_to_cpu(kfib->header.Size) , FsaNormal,
 				1, 1, NULL, NULL);
 		if (retval) {
 			goto cleanup;
 		}
-		if (fib_complete(fibptr) != 0) {
+		if (aac_fib_complete(fibptr) != 0) {
 			retval = -EINVAL;
 			goto cleanup;
 		}
@@ -138,7 +138,7 @@
 		fibptr->hw_fib_pa = hw_fib_pa;
 		fibptr->hw_fib = hw_fib;
 	}
-	fib_free(fibptr);
+	aac_fib_free(fibptr);
 	return retval;
 }
 
@@ -464,10 +464,10 @@
 	/*
 	 *	Allocate and initialize a Fib then setup a BlockWrite command
 	 */
-	if (!(srbfib = fib_alloc(dev))) {
+	if (!(srbfib = aac_fib_alloc(dev))) {
 		return -ENOMEM;
 	}
-	fib_init(srbfib);
+	aac_fib_init(srbfib);
 
 	srbcmd = (struct aac_srb*) fib_data(srbfib);
 
@@ -601,7 +601,7 @@
 
 		srbcmd->count = cpu_to_le32(byte_count);
 		psg->count = cpu_to_le32(sg_indx+1);
-		status = fib_send(ScsiPortCommand64, srbfib, actual_fibsize, FsaNormal, 1, 1,NULL,NULL);
+		status = aac_fib_send(ScsiPortCommand64, srbfib, actual_fibsize, FsaNormal, 1, 1,NULL,NULL);
 	} else {
 		struct user_sgmap* upsg = &user_srbcmd->sg;
 		struct sgmap* psg = &srbcmd->sg;
@@ -649,7 +649,7 @@
 		}
 		srbcmd->count = cpu_to_le32(byte_count);
 		psg->count = cpu_to_le32(sg_indx+1);
-		status = fib_send(ScsiPortCommand, srbfib, actual_fibsize, FsaNormal, 1, 1, NULL, NULL);
+		status = aac_fib_send(ScsiPortCommand, srbfib, actual_fibsize, FsaNormal, 1, 1, NULL, NULL);
 	}
 
 	if (status != 0){
@@ -684,8 +684,8 @@
 	for(i=0; i <= sg_indx; i++){
 		kfree(sg_list[i]);
 	}
-	fib_complete(srbfib);
-	fib_free(srbfib);
+	aac_fib_complete(srbfib);
+	aac_fib_free(srbfib);
 
 	return rcode;
 }
--- scsi-misc-aac.orig/drivers/scsi/aacraid/comminit.c	2006-02-01 08:58:40.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/comminit.c	2006-02-01 09:05:52.000000000 -0800
@@ -185,17 +185,17 @@
 	struct aac_close *cmd;
 	int status;
 
-	fibctx = fib_alloc(dev);
+	fibctx = aac_fib_alloc(dev);
 	if (!fibctx)
 		return -ENOMEM;
-	fib_init(fibctx);
+	aac_fib_init(fibctx);
 
 	cmd = (struct aac_close *) fib_data(fibctx);
 
 	cmd->command = cpu_to_le32(VM_CloseAll);
 	cmd->cid = cpu_to_le32(0xffffffff);
 
-	status = fib_send(ContainerCommand,
+	status = aac_fib_send(ContainerCommand,
 			  fibctx,
 			  sizeof(struct aac_close),
 			  FsaNormal,
@@ -203,8 +203,8 @@
 			  NULL, NULL);
 
 	if (status == 0)
-		fib_complete(fibctx);
-	fib_free(fibctx);
+		aac_fib_complete(fibctx);
+	aac_fib_free(fibctx);
 	return status;
 }
 
@@ -427,7 +427,7 @@
 	/*
 	 *	Initialize the list of fibs
 	 */
-	if(fib_setup(dev)<0){
+	if (aac_fib_setup(dev) < 0) {
 		kfree(dev->queues);
 		return NULL;
 	}
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-02-01 08:58:40.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-02-01 09:07:58.000000000 -0800
@@ -67,27 +67,27 @@
 }
 
 /**
- *	fib_map_free		-	free the fib objects
+ *	aac_fib_map_free		-	free the fib objects
  *	@dev: Adapter to free
  *
  *	Free the PCI mappings and the memory allocated for FIB blocks
  *	on this adapter.
  */
 
-void fib_map_free(struct aac_dev *dev)
+void aac_fib_map_free(struct aac_dev *dev)
 {
 	pci_free_consistent(dev->pdev, dev->max_fib_size * (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB), dev->hw_fib_va, dev->hw_fib_pa);
 }
 
 /**
- *	fib_setup	-	setup the fibs
+ *	aac_fib_setup	-	setup the fibs
  *	@dev: Adapter to set up
  *
  *	Allocate the PCI space for the fibs, map it and then intialise the
  *	fib area, the unmapped fib data and also the free list
  */
 
-int fib_setup(struct aac_dev * dev)
+int aac_fib_setup(struct aac_dev * dev)
 {
 	struct fib *fibptr;
 	struct hw_fib *hw_fib_va;
@@ -134,14 +134,14 @@
 }
 
 /**
- *	fib_alloc	-	allocate a fib
+ *	aac_fib_alloc	-	allocate a fib
  *	@dev: Adapter to allocate the fib for
  *
  *	Allocate a fib from the adapter fib pool. If the pool is empty we
  *	return NULL.
  */
  
-struct fib * fib_alloc(struct aac_dev *dev)
+struct fib *aac_fib_alloc(struct aac_dev *dev)
 {
 	struct fib * fibptr;
 	unsigned long flags;
@@ -170,14 +170,14 @@
 }
 
 /**
- *	fib_free	-	free a fib
+ *	aac_fib_free	-	free a fib
  *	@fibptr: fib to free up
  *
  *	Frees up a fib and places it on the appropriate queue
  *	(either free or timed out)
  */
  
-void fib_free(struct fib * fibptr)
+void aac_fib_free(struct fib *fibptr)
 {
 	unsigned long flags;
 
@@ -188,7 +188,7 @@
 		fibptr->dev->timeout_fib = fibptr;
 	} else {
 		if (fibptr->hw_fib->header.XferState != 0) {
-			printk(KERN_WARNING "fib_free, XferState != 0, fibptr = 0x%p, XferState = 0x%x\n", 
+			printk(KERN_WARNING "aac_fib_free, XferState != 0, fibptr = 0x%p, XferState = 0x%x\n",
 				 (void*)fibptr, 
 				 le32_to_cpu(fibptr->hw_fib->header.XferState));
 		}
@@ -199,13 +199,13 @@
 }
 
 /**
- *	fib_init	-	initialise a fib
+ *	aac_fib_init	-	initialise a fib
  *	@fibptr: The fib to initialize
  *	
  *	Set up the generic fib fields ready for use
  */
  
-void fib_init(struct fib *fibptr)
+void aac_fib_init(struct fib *fibptr)
 {
 	struct hw_fib *hw_fib = fibptr->hw_fib;
 
@@ -362,7 +362,7 @@
  */
 
 /**
- *	fib_send	-	send a fib to the adapter
+ *	aac_fib_send	-	send a fib to the adapter
  *	@command: Command to send
  *	@fibptr: The fib
  *	@size: Size of fib data area
@@ -378,7 +378,9 @@
  *	response FIB is received from the adapter.
  */
  
-int fib_send(u16 command, struct fib * fibptr, unsigned long size,  int priority, int wait, int reply, fib_callback callback, void * callback_data)
+int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
+		int priority, int wait, int reply, fib_callback callback,
+		void *callback_data)
 {
 	struct aac_dev * dev = fibptr->dev;
 	struct hw_fib * hw_fib = fibptr->hw_fib;
@@ -493,7 +495,7 @@
 		q->numpending++;
 		*(q->headers.producer) = cpu_to_le32(index + 1);
 		spin_unlock_irqrestore(q->lock, qflags);
-		dprintk((KERN_DEBUG "fib_send: inserting a queue entry at index %d.\n",index));
+		dprintk((KERN_DEBUG "aac_fib_send: inserting a queue entry at index %d.\n",index));
 		if (!(nointr & aac_config.irq_mod))
 			aac_adapter_notify(dev, AdapNormCmdQueue);
 	}
@@ -520,7 +522,7 @@
 					list_del(&fibptr->queue);
 					spin_unlock_irqrestore(q->lock, qflags);
 					if (wait == -1) {
-	        				printk(KERN_ERR "aacraid: fib_send: first asynchronous command timed out.\n"
+	        				printk(KERN_ERR "aacraid: aac_fib_send: first asynchronous command timed out.\n"
 						  "Usually a result of a PCI interrupt routing problem;\n"
 						  "update mother board BIOS or consider utilizing one of\n"
 						  "the SAFE mode kernel options (acpi, apic etc)\n");
@@ -624,7 +626,7 @@
 }        
 
 /**
- *	fib_adapter_complete	-	complete adapter issued fib
+ *	aac_fib_adapter_complete	-	complete adapter issued fib
  *	@fibptr: fib to complete
  *	@size: size of fib
  *
@@ -632,7 +634,7 @@
  *	the adapter.
  */
 
-int fib_adapter_complete(struct fib * fibptr, unsigned short size)
+int aac_fib_adapter_complete(struct fib *fibptr, unsigned short size)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 	struct aac_dev * dev = fibptr->dev;
@@ -683,20 +685,20 @@
 	}
 	else 
 	{
-        	printk(KERN_WARNING "fib_adapter_complete: Unknown xferstate detected.\n");
+        	printk(KERN_WARNING "aac_fib_adapter_complete: Unknown xferstate detected.\n");
         	BUG();
 	}   
 	return 0;
 }
 
 /**
- *	fib_complete	-	fib completion handler
+ *	aac_fib_complete	-	fib completion handler
  *	@fib: FIB to complete
  *
  *	Will do all necessary work to complete a FIB.
  */
  
-int fib_complete(struct fib * fibptr)
+int aac_fib_complete(struct fib *fibptr)
 {
 	struct hw_fib * hw_fib = fibptr->hw_fib;
 
@@ -995,14 +997,14 @@
 	if (!dev || !dev->scsi_host_ptr)
 		return;
 	/*
-	 * force reload of disk info via probe_container
+	 * force reload of disk info via aac_probe_container
 	 */
 	if ((device_config_needed == CHANGE)
 	 && (dev->fsa_dev[container].valid == 1))
 		dev->fsa_dev[container].valid = 2;
 	if ((device_config_needed == CHANGE) ||
 			(device_config_needed == ADD))
-		probe_container(dev, container);
+		aac_probe_container(dev, container);
 	device = scsi_device_lookup(dev->scsi_host_ptr, 
 		CONTAINER_TO_CHANNEL(container), 
 		CONTAINER_TO_ID(container), 
@@ -1104,7 +1106,7 @@
 				/* Handle Driver Notify Events */
 				aac_handle_aif(dev, fib);
 				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
-				fib_adapter_complete(fib, (u16)sizeof(u32));
+				aac_fib_adapter_complete(fib, (u16)sizeof(u32));
 			} else {
 				struct list_head *entry;
 				/* The u32 here is important and intended. We are using
@@ -1241,7 +1243,7 @@
 				 *	Set the status of this FIB
 				 */
 				*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
-				fib_adapter_complete(fib, sizeof(u32));
+				aac_fib_adapter_complete(fib, sizeof(u32));
 				spin_unlock_irqrestore(&dev->fib_lock, flagv);
 				/* Free up the remaining resources */
 				hw_fib_p = hw_fib_pool;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/dpcsup.c	2006-02-01 08:58:40.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/dpcsup.c	2006-02-01 09:02:46.000000000 -0800
@@ -206,7 +206,7 @@
 			 *	Set the status of this FIB
 			 */
 			*(__le32 *)hw_fib->data = cpu_to_le32(ST_OK);
-			fib_adapter_complete(fib, sizeof(u32));
+			aac_fib_adapter_complete(fib, sizeof(u32));
 			spin_lock_irqsave(q->lock, flags);
 		}		
 	}
--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-02-01 09:02:16.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-02-01 09:02:46.000000000 -0800
@@ -941,7 +941,7 @@
 	aac_adapter_disable_int(aac);
 	free_irq(pdev->irq, aac);
  out_unmap:
-	fib_map_free(aac);
+	aac_fib_map_free(aac);
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
 	iounmap(aac->regs.sa);
@@ -975,7 +975,7 @@
 
 	aac_send_shutdown(aac);
 	aac_adapter_disable_int(aac);
-	fib_map_free(aac);
+	aac_fib_map_free(aac);
 	pci_free_consistent(aac->pdev, aac->comm_size, aac->comm_addr,
 			aac->comm_phys);
 	kfree(aac->queues);

-- 
Mark Haverkamp <markh@osdl.org>

