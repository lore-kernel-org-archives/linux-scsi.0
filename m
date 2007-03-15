From: Mark Haverkamp <markh@linux-foundation.org>
Subject: Re: [PATCH 3/7] aacraid: Fix blocking issue with container probing
	function (cast update)
Date: Thu, 15 Mar 2007 12:55:07 -0700
Message-ID: <1173988507.30374.33.camel@markh3.pdx.osdl.net>
References: <1173979603.30374.23.camel@markh3.pdx.osdl.net>
	 <1173986753.3379.18.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38464 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933564AbXCOTzL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 15:55:11 -0400
In-Reply-To: <1173986753.3379.18.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

The aac_probe_container call blocks. This is an issue because it is called on
occasion in the context of the queuecommand handler. Once in a blue moon this
has resulted in a kernel panic sleeping during interrupt; or problems with some
embedded system versions of the kernel that depend on queuecommand to not
block. This ugly patch rewrites the aac_probe_container call into a new routine
_aac_probe_container that is an asynchronous state machine to complete the
series of operations. The legacy blocking aac_probe_container call used in
other areas of the driver (during initialization scanning for all targets and
in the separate hot-add/remove [aacraid] thread) merely issues
_aac_probe_container and then simple spins calling schedule() waiting for
completion.

Signed-off-by: Mark Haverkamp <markh@linux-foundation.org>

---


--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2007-03-15 08:28:03.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2007-03-15 12:49:46.000000000 -0700
@@ -258,13 +258,10 @@ int aac_get_containers(struct aac_dev *d
 	u32 index; 
 	int status = 0;
 	struct fib * fibptr;
-	unsigned instance;
 	struct aac_get_container_count *dinfo;
 	struct aac_get_container_count_resp *dresp;
 	int maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
 
-	instance = dev->scsi_host_ptr->unique_id;
-
 	if (!(fibptr = aac_fib_alloc(dev)))
 		return -ENOMEM;
 
@@ -284,88 +281,35 @@ int aac_get_containers(struct aac_dev *d
 		maximum_num_containers = le32_to_cpu(dresp->ContainerSwitchEntries);
 		aac_fib_complete(fibptr);
 	}
+	aac_fib_free(fibptr);
 
 	if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
 		maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
-	fsa_dev_ptr = kmalloc(
-	  sizeof(*fsa_dev_ptr) * maximum_num_containers, GFP_KERNEL);
-	if (!fsa_dev_ptr) {
-		aac_fib_free(fibptr);
+	fsa_dev_ptr =  kmalloc(sizeof(*fsa_dev_ptr) * maximum_num_containers,
+			GFP_KERNEL);
+	if (!fsa_dev_ptr)
 		return -ENOMEM;
-	}
 	memset(fsa_dev_ptr, 0, sizeof(*fsa_dev_ptr) * maximum_num_containers);
 
 	dev->fsa_dev = fsa_dev_ptr;
 	dev->maximum_num_containers = maximum_num_containers;
 
-	for (index = 0; index < dev->maximum_num_containers; index++) {
-		struct aac_query_mount *dinfo;
-		struct aac_mount *dresp;
-
+	for (index = 0; index < dev->maximum_num_containers; ) {
 		fsa_dev_ptr[index].devname[0] = '\0';
 
-		aac_fib_init(fibptr);
-		dinfo = (struct aac_query_mount *) fib_data(fibptr);
-
-		dinfo->command = cpu_to_le32(VM_NameServe);
-		dinfo->count = cpu_to_le32(index);
-		dinfo->type = cpu_to_le32(FT_FILESYS);
+		status = aac_probe_container(dev, index);
 
-		status = aac_fib_send(ContainerCommand,
-				    fibptr,
-				    sizeof (struct aac_query_mount),
-				    FsaNormal,
-				    1, 1,
-				    NULL, NULL);
-		if (status < 0 ) {
+		if (status < 0) {
 			printk(KERN_WARNING "aac_get_containers: SendFIB failed.\n");
 			break;
 		}
-		dresp = (struct aac_mount *)fib_data(fibptr);
 
-		if ((le32_to_cpu(dresp->status) == ST_OK) &&
-		    (le32_to_cpu(dresp->mnt[0].vol) == CT_NONE)) {
-			dinfo->command = cpu_to_le32(VM_NameServe64);
-			dinfo->count = cpu_to_le32(index);
-			dinfo->type = cpu_to_le32(FT_FILESYS);
-
-			if (aac_fib_send(ContainerCommand,
-				    fibptr,
-				    sizeof(struct aac_query_mount),
-				    FsaNormal,
-				    1, 1,
-				    NULL, NULL) < 0)
-				continue;
-		} else
-			dresp->mnt[0].capacityhigh = 0;
-
-		dprintk ((KERN_DEBUG
-		  "VM_NameServe cid=%d status=%d vol=%d state=%d cap=%llu\n",
-		  (int)index, (int)le32_to_cpu(dresp->status),
-		  (int)le32_to_cpu(dresp->mnt[0].vol),
-		  (int)le32_to_cpu(dresp->mnt[0].state),
-		  ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
-		    (((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32)));
-		if ((le32_to_cpu(dresp->status) == ST_OK) &&
-		    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
-		    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
-			fsa_dev_ptr[index].valid = 1;
-			fsa_dev_ptr[index].type = le32_to_cpu(dresp->mnt[0].vol);
-			fsa_dev_ptr[index].size
-			  = ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
-			    (((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32);
-			if (le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY)
-				    fsa_dev_ptr[index].ro = 1;
-		}
-		aac_fib_complete(fibptr);
 		/*
 		 *	If there are no more containers, then stop asking.
 		 */
-		if ((index + 1) >= le32_to_cpu(dresp->count)){
+		if (++index >= status)
 			break;
-		}
 	}
-	aac_fib_free(fibptr);
 	return status;
 }
 
@@ -473,85 +417,185 @@ static int aac_get_container_name(struct
 	return -1;
 }
 
-/**
- *	aac_probe_container		-	query a logical volume
- *	@dev: device to query
- *	@cid: container identifier
- *
- *	Queries the controller about the given volume. The volume information
- *	is updated in the struct fsa_dev_info structure rather than returned.
- */
- 
-int aac_probe_container(struct aac_dev *dev, int cid)
+static int aac_probe_container_callback2(struct scsi_cmnd * scsicmd)
 {
-	struct fsa_dev_info *fsa_dev_ptr;
-	int status;
-	struct aac_query_mount *dinfo;
-	struct aac_mount *dresp;
-	struct fib * fibptr;
-	unsigned instance;
+	struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
 
-	fsa_dev_ptr = dev->fsa_dev;
-	if (!fsa_dev_ptr)
-		return -ENOMEM;
-	instance = dev->scsi_host_ptr->unique_id;
+	if (fsa_dev_ptr[scmd_id(scsicmd)].valid)
+		return aac_scsi_cmd(scsicmd);
 
-	if (!(fibptr = aac_fib_alloc(dev)))
-		return -ENOMEM;
+	scsicmd->result = DID_NO_CONNECT << 16;
+	scsicmd->scsi_done(scsicmd);
+	return 0;
+}
+
+static int _aac_probe_container2(void * context, struct fib * fibptr)
+{
+	struct scsi_cmnd * scsicmd = (struct scsi_cmnd *)context;
+	struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
+	int (*callback)(struct scsi_cmnd *);
+
+	scsicmd->SCp.Status = 0;
+	if (fsa_dev_ptr) {
+		struct aac_mount * dresp = (struct aac_mount *) fib_data(fibptr);
+		fsa_dev_ptr += scmd_id(scsicmd);
+
+		if ((le32_to_cpu(dresp->status) == ST_OK) &&
+		    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
+		    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
+			fsa_dev_ptr->valid = 1;
+			fsa_dev_ptr->type = le32_to_cpu(dresp->mnt[0].vol);
+			fsa_dev_ptr->size
+			  = ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
+			    (((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32);
+			fsa_dev_ptr->ro = ((le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY) != 0);
+		}
+		if ((fsa_dev_ptr->valid & 1) == 0)
+			fsa_dev_ptr->valid = 0;
+		scsicmd->SCp.Status = le32_to_cpu(dresp->count);
+	}
+	aac_fib_complete(fibptr);
+	aac_fib_free(fibptr);
+	callback = (int (*)(struct scsi_cmnd *))(scsicmd->SCp.ptr);
+	scsicmd->SCp.ptr = NULL;
+	return (*callback)(scsicmd);
+}
+
+static int _aac_probe_container1(void * context, struct fib * fibptr)
+{
+	struct scsi_cmnd * scsicmd;
+	struct aac_mount * dresp;
+	struct aac_query_mount *dinfo;
+	int status;
+
+	dresp = (struct aac_mount *) fib_data(fibptr);
+	dresp->mnt[0].capacityhigh = 0;
+	if ((le32_to_cpu(dresp->status) != ST_OK) ||
+	    ((le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
+	     (le32_to_cpu(dresp->mnt[0].state) == FSCS_HIDDEN)))
+		return _aac_probe_container2(context, fibptr);
+	scsicmd = (struct scsi_cmnd *) context;
+	scsicmd->SCp.phase = AAC_OWNER_MIDLEVEL;
 
 	aac_fib_init(fibptr);
 
 	dinfo = (struct aac_query_mount *)fib_data(fibptr);
 
-	dinfo->command = cpu_to_le32(VM_NameServe);
-	dinfo->count = cpu_to_le32(cid);
+	dinfo->command = cpu_to_le32(VM_NameServe64);
+	dinfo->count = cpu_to_le32(scmd_id(scsicmd));
 	dinfo->type = cpu_to_le32(FT_FILESYS);
 
 	status = aac_fib_send(ContainerCommand,
-			    fibptr,
-			    sizeof(struct aac_query_mount),
-			    FsaNormal,
-			    1, 1,
-			    NULL, NULL);
+			  fibptr,
+			  sizeof(struct aac_query_mount),
+			  FsaNormal,
+			  0, 1,
+			  (fib_callback) _aac_probe_container2,
+			  (void *) scsicmd);
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS) {
+		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+		return 0;
+	}
 	if (status < 0) {
-		printk(KERN_WARNING "aacraid: aac_probe_container query failed.\n");
-		goto error;
+		/* Inherit results from VM_NameServe, if any */
+		dresp->status = cpu_to_le32(ST_OK);
+		return _aac_probe_container2(context, fibptr);
 	}
+	return 0;
+}
 
-	dresp = (struct aac_mount *) fib_data(fibptr);
+static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(struct scsi_cmnd *))
+{
+	struct fib * fibptr;
+	int status = -ENOMEM;
 
-	if ((le32_to_cpu(dresp->status) == ST_OK) &&
-	    (le32_to_cpu(dresp->mnt[0].vol) == CT_NONE)) {
-		dinfo->command = cpu_to_le32(VM_NameServe64);
-		dinfo->count = cpu_to_le32(cid);
-		dinfo->type = cpu_to_le32(FT_FILESYS);
+	if ((fibptr = aac_fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) {
+		struct aac_query_mount *dinfo;
 
-		if (aac_fib_send(ContainerCommand,
-			    fibptr,
-			    sizeof(struct aac_query_mount),
-			    FsaNormal,
-			    1, 1,
-			    NULL, NULL) < 0)
-			goto error;
-	} else
-		dresp->mnt[0].capacityhigh = 0;
+		aac_fib_init(fibptr);
+
+		dinfo = (struct aac_query_mount *)fib_data(fibptr);
+
+		dinfo->command = cpu_to_le32(VM_NameServe);
+		dinfo->count = cpu_to_le32(scmd_id(scsicmd));
+		dinfo->type = cpu_to_le32(FT_FILESYS);
+		scsicmd->SCp.ptr = (char *)callback;
 
-	if ((le32_to_cpu(dresp->status) == ST_OK) &&
-	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
-	    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
-		fsa_dev_ptr[cid].valid = 1;
-		fsa_dev_ptr[cid].type = le32_to_cpu(dresp->mnt[0].vol);
-		fsa_dev_ptr[cid].size
-		  = ((u64)le32_to_cpu(dresp->mnt[0].capacity)) +
-		    (((u64)le32_to_cpu(dresp->mnt[0].capacityhigh)) << 32);
-		if (le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY)
-			fsa_dev_ptr[cid].ro = 1;
+		status = aac_fib_send(ContainerCommand,
+			  fibptr,
+			  sizeof(struct aac_query_mount),
+			  FsaNormal,
+			  0, 1,
+			  (fib_callback) _aac_probe_container1,
+			  (void *) scsicmd);
+		/*
+		 *	Check that the command queued to the controller
+		 */
+		if (status == -EINPROGRESS) {
+			scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+			return 0;
+		}
+		if (status < 0) {
+			scsicmd->SCp.ptr = NULL;
+			aac_fib_complete(fibptr);
+			aac_fib_free(fibptr);
+		}
 	}
+	if (status < 0) {
+		struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
+		if (fsa_dev_ptr) {
+			fsa_dev_ptr += scmd_id(scsicmd);
+			if ((fsa_dev_ptr->valid & 1) == 0) {
+				fsa_dev_ptr->valid = 0;
+				return (*callback)(scsicmd);
+			}
+		}
+	}
+	return status;
+}
 
-error:
-	aac_fib_complete(fibptr);
-	aac_fib_free(fibptr);
+/**
+ *	aac_probe_container		-	query a logical volume
+ *	@dev: device to query
+ *	@cid: container identifier
+ *
+ *	Queries the controller about the given volume. The volume information
+ *	is updated in the struct fsa_dev_info structure rather than returned.
+ */
+static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
+{
+	scsicmd->device = NULL;
+	return 0;
+}
+
+int aac_probe_container(struct aac_dev *dev, int cid)
+{
+	struct scsi_cmnd *scsicmd = kmalloc(sizeof(*scsicmd), GFP_KERNEL);
+	struct scsi_device *scsidev = kmalloc(sizeof(*scsidev), GFP_KERNEL);
+	int status;
 
+	if (!scsicmd || !scsidev) {
+		kfree(scsicmd);
+		kfree(scsidev);
+		return -ENOMEM;
+	}
+	scsicmd->list.next = NULL;
+	scsicmd->scsi_done = (void (*)(struct scsi_cmnd*))_aac_probe_container1;
+
+	scsicmd->device = scsidev;
+	scsidev->sdev_state = 0;
+	scsidev->id = cid;
+	scsidev->host = dev->scsi_host_ptr;
+
+	if (_aac_probe_container(scsicmd, aac_probe_container_callback1) == 0)
+		while (scsicmd->device == scsidev)
+			schedule();
+	status = scsicmd->SCp.Status;
+	kfree(scsicmd);
+	kfree(scsidev);
 	return status;
 }
 
@@ -1646,29 +1690,12 @@ int aac_scsi_cmd(struct scsi_cmnd * scsi
 				case TEST_UNIT_READY:
 					if (dev->in_reset)
 						return -1;
-					spin_unlock_irq(host->host_lock);
-					aac_probe_container(dev, cid);
-					if ((fsa_dev_ptr[cid].valid & 1) == 0)
-						fsa_dev_ptr[cid].valid = 0;
-					spin_lock_irq(host->host_lock);
-					if (fsa_dev_ptr[cid].valid == 0) {
-						scsicmd->result = DID_NO_CONNECT << 16;
-						scsicmd->scsi_done(scsicmd);
-						return 0;
-					}
+					return _aac_probe_container(scsicmd,
+							aac_probe_container_callback2);
 				default:
 					break;
 				}
 			}
-			/*
-			 *	If the target container still doesn't exist, 
-			 *	return failure
-			 */
-			if (fsa_dev_ptr[cid].valid == 0) {
-				scsicmd->result = DID_BAD_TARGET << 16;
-				scsicmd->scsi_done(scsicmd);
-				return 0;
-			}
 		} else {  /* check for physical non-dasd devices */
 			if ((dev->nondasd_support == 1) || expose_physicals) {
 				if (dev->in_reset)

-- 
Mark Haverkamp <markh@linux-foundation.org>

