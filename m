From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH] 2.6.9 aacraid: dynamic dev update
Date: Fri, 24 Sep 2004 11:18:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096049918.31620.33.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:44954 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S269068AbUIXSSv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 14:18:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>


Description from Mark Salyzyn:
The main purpose of this patch is to move the array's cached request
sense packets into a per-adapter structure rather than leaving it global
(before ID 1,0,0,0 shares 2,0,0,0 cached sense). SAS pressed this change
as we needed to allocate the sense packets dynamically.

Applies to the scsi-misc bk tree.

Signed-off-by Mark Haverkamp <markh@osdl.org>

===== drivers/scsi/aacraid/aachba.c 1.27 vs edited =====
--- 1.27/drivers/scsi/aacraid/aachba.c	2004-08-16 10:55:47 -07:00
+++ edited/drivers/scsi/aacraid/aachba.c	2004-09-23 10:05:21 -07:00
@@ -131,47 +131,10 @@
 	u8 inqd_prl[4];	/* Product Revision Level */
 };
 
-struct sense_data {
-	u8 error_code;		/* 70h (current errors), 71h(deferred errors) */
-	u8 valid:1;		/* A valid bit of one indicates that the information  */
-				/* field contains valid information as defined in the
-				 * SCSI-2 Standard.
-				 */
-	u8 segment_number;	/* Only used for COPY, COMPARE, or COPY AND VERIFY Commands */
-	u8 sense_key:4;		/* Sense Key */
-	u8 reserved:1;
-	u8 ILI:1;		/* Incorrect Length Indicator */
-	u8 EOM:1;		/* End Of Medium - reserved for random access devices */
-	u8 filemark:1;		/* Filemark - reserved for random access devices */
-
-	u8 information[4];	/* for direct-access devices, contains the unsigned 
-				 * logical block address or residue associated with 
-				 * the sense key 
-				 */
-	u8 add_sense_len;	/* number of additional sense bytes to follow this field */
-	u8 cmnd_info[4];	/* not used */
-	u8 ASC;			/* Additional Sense Code */
-	u8 ASCQ;		/* Additional Sense Code Qualifier */
-	u8 FRUC;		/* Field Replaceable Unit Code - not used */
-	u8 bit_ptr:3;		/* indicates which byte of the CDB or parameter data
-				 * was in error
-				 */
-	u8 BPV:1;		/* bit pointer valid (BPV): 1- indicates that 
-				 * the bit_ptr field has valid value
-				 */
-	u8 reserved2:2;
-	u8 CD:1;		/* command data bit: 1- illegal parameter in CDB.
-				 * 0- illegal parameter in data.
-				 */
-	u8 SKSV:1;
-	u8 field_ptr[2];	/* byte of the CDB or parameter data in error */
-};
-
 /*
  *              M O D U L E   G L O B A L S
  */
  
-static struct sense_data sense_data[MAXIMUM_NUM_CONTAINERS];
 static unsigned long aac_build_sg(struct scsi_cmnd* scsicmd, struct sgmap* sgmap);
 static unsigned long aac_build_sg64(struct scsi_cmnd* scsicmd, struct sgmap64* psg);
 static int aac_send_srb_fib(struct scsi_cmnd* scsicmd);
@@ -275,21 +238,60 @@
  */
 int aac_get_containers(struct aac_dev *dev)
 {
-	struct fsa_scsi_hba *fsa_dev_ptr;
+	struct fsa_dev_info *fsa_dev_ptr;
 	u32 index; 
 	int status = 0;
-	struct aac_query_mount *dinfo;
-	struct aac_mount *dresp;
 	struct fib * fibptr;
 	unsigned instance;
 
-	fsa_dev_ptr = &(dev->fsa_dev);
 	instance = dev->scsi_host_ptr->unique_id;
 
 	if (!(fibptr = fib_alloc(dev)))
 		return -ENOMEM;
 
-	for (index = 0; index < MAXIMUM_NUM_CONTAINERS; index++) {
+	{
+		struct aac_get_container_count *dinfo;
+		struct aac_get_container_count_resp *dresp;
+		int maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
+
+		fib_init(fibptr);
+		dinfo = (struct aac_get_container_count *) fib_data(fibptr);
+	
+		dinfo->command = cpu_to_le32(VM_ContainerConfig);
+		dinfo->type = cpu_to_le32(CT_GET_CONTAINER_COUNT);
+	
+		status = fib_send(ContainerCommand,
+			    fibptr,
+			    sizeof (struct aac_get_container_count),
+			    FsaNormal,
+			    1, 1,
+			    NULL, NULL);
+		if (status >= 0) {
+			dresp = (struct aac_get_container_count_resp *) fib_data(fibptr);
+			maximum_num_containers = dresp->ContainerSwitchEntries;
+			fib_complete(fibptr);
+		}
+
+		if (maximum_num_containers < MAXIMUM_NUM_CONTAINERS)
+			maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
+		fsa_dev_ptr = (struct fsa_dev_info *) kmalloc(
+		  sizeof(*fsa_dev_ptr) * maximum_num_containers, GFP_KERNEL);
+		if (!fsa_dev_ptr) {
+			fib_free(fibptr);
+			return -ENOMEM;
+		}
+		memset(fsa_dev_ptr, 0, sizeof(*fsa_dev_ptr) * maximum_num_containers);
+
+		dev->fsa_dev = fsa_dev_ptr;
+		dev->maximum_num_containers = maximum_num_containers;
+	}
+
+	for (index = 0; index < dev->maximum_num_containers; index++) {
+		struct aac_query_mount *dinfo;
+		struct aac_mount *dresp;
+
+		fsa_dev_ptr[index].devname[0] = '\0';
+
 		fib_init(fibptr);
 		dinfo = (struct aac_query_mount *) fib_data(fibptr);
 
@@ -309,14 +311,20 @@
 		}
 		dresp = (struct aac_mount *)fib_data(fibptr);
 
+		dprintk ((KERN_DEBUG
+		  "VM_NameServe cid=%d status=%d vol=%d state=%d cap=%u\n",
+		  (int)index, (int)le32_to_cpu(dresp->status),
+		  (int)le32_to_cpu(dresp->mnt[0].vol),
+		  (int)le32_to_cpu(dresp->mnt[0].state),
+		  (unsigned)le32_to_cpu(dresp->mnt[0].capacity)));
 		if ((le32_to_cpu(dresp->status) == ST_OK) &&
 		    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
 		    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
-			fsa_dev_ptr->valid[index] = 1;
-			fsa_dev_ptr->type[index] = le32_to_cpu(dresp->mnt[0].vol);
-			fsa_dev_ptr->size[index] = le32_to_cpu(dresp->mnt[0].capacity);
+			fsa_dev_ptr[index].valid = 1;
+			fsa_dev_ptr[index].type = le32_to_cpu(dresp->mnt[0].vol);
+			fsa_dev_ptr[index].size = le32_to_cpu(dresp->mnt[0].capacity);
 			if (le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY)
-				    fsa_dev_ptr->ro[index] = 1;
+				    fsa_dev_ptr[index].ro = 1;
 		}
 		fib_complete(fibptr);
 		/*
@@ -336,19 +344,19 @@
  *	@cid: container identifier
  *
  *	Queries the controller about the given volume. The volume information
- *	is updated in the struct fsa_scsi_hba structure rather than returned.
+ *	is updated in the struct fsa_dev_info structure rather than returned.
  */
  
 static int probe_container(struct aac_dev *dev, int cid)
 {
-	struct fsa_scsi_hba *fsa_dev_ptr;
+	struct fsa_dev_info *fsa_dev_ptr;
 	int status;
 	struct aac_query_mount *dinfo;
 	struct aac_mount *dresp;
 	struct fib * fibptr;
 	unsigned instance;
 
-	fsa_dev_ptr = &(dev->fsa_dev);
+	fsa_dev_ptr = dev->fsa_dev;
 	instance = dev->scsi_host_ptr->unique_id;
 
 	if (!(fibptr = fib_alloc(dev)))
@@ -378,11 +386,11 @@
 	if ((le32_to_cpu(dresp->status) == ST_OK) &&
 	    (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE) &&
 	    (le32_to_cpu(dresp->mnt[0].state) != FSCS_HIDDEN)) {
-		fsa_dev_ptr->valid[cid] = 1;
-		fsa_dev_ptr->type[cid] = le32_to_cpu(dresp->mnt[0].vol);
-		fsa_dev_ptr->size[cid] = le32_to_cpu(dresp->mnt[0].capacity);
+		fsa_dev_ptr[cid].valid = 1;
+		fsa_dev_ptr[cid].type = le32_to_cpu(dresp->mnt[0].vol);
+		fsa_dev_ptr[cid].size = le32_to_cpu(dresp->mnt[0].capacity);
 		if (le32_to_cpu(dresp->mnt[0].state) & FSCS_READONLY)
-			fsa_dev_ptr->ro[cid] = 1;
+			fsa_dev_ptr[cid].ro = 1;
 	}
 
 error:
@@ -645,12 +653,15 @@
 	else {
 		printk(KERN_WARNING "read_callback: read failed, status = %d\n", readreply->status);
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-		set_sense((u8 *) &sense_data[cid],
+		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 				    HARDWARE_ERROR,
 				    SENCODE_INTERNAL_TARGET_FAILURE,
 				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
 				    0, 0);
-		memcpy(scsicmd->sense_buffer, &sense_data[cid], sizeof(struct sense_data));
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(dev->fsa_dev[cid].sense_data));
 	}
 	fib_complete(fibptr);
 	fib_free(fibptr);
@@ -691,12 +702,13 @@
 	else {
 		printk(KERN_WARNING "write_callback: write failed, status = %d\n", writereply->status);
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-		set_sense((u8 *) &sense_data[cid],
+		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 				    HARDWARE_ERROR,
 				    SENCODE_INTERNAL_TARGET_FAILURE,
 				    ASENCODE_INTERNAL_TARGET_FAILURE, 0, 0,
 				    0, 0);
-		memcpy(scsicmd->sense_buffer, &sense_data[cid], sizeof(struct sense_data));
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data, 
+				sizeof(struct sense_data));
 	}
 
 	fib_complete(fibptr);
@@ -938,11 +950,11 @@
 int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 {
 	u32 cid = 0;
-	int ret;
 	struct Scsi_Host *host = scsicmd->device->host;
 	struct aac_dev *dev = (struct aac_dev *)host->hostdata;
-	struct fsa_scsi_hba *fsa_dev_ptr = &dev->fsa_dev;
+	struct fsa_dev_info *fsa_dev_ptr = dev->fsa_dev;
 	int cardtype = dev->cardtype;
+	int ret;
 	
 	/*
 	 *	If the bus, id or lun is out of range, return fail
@@ -951,7 +963,7 @@
 	 */
 	if (scsicmd->device->id != host->this_id) {
 		if ((scsicmd->device->channel == 0) ){
-			if( (scsicmd->device->id >= MAXIMUM_NUM_CONTAINERS) || (scsicmd->device->lun != 0)){ 
+			if( (scsicmd->device->id >= dev->maximum_num_containers) || (scsicmd->device->lun != 0)){ 
 				scsicmd->result = DID_NO_CONNECT << 16;
 				__aac_io_done(scsicmd);
 				return 0;
@@ -962,7 +974,7 @@
 			 *	If the target container doesn't exist, it may have
 			 *	been newly created
 			 */
-			if (fsa_dev_ptr->valid[cid] == 0) {
+			if ((fsa_dev_ptr[cid].valid & 1) == 0) {
 				switch (scsicmd->cmnd[0]) {
 				case INQUIRY:
 				case READ_CAPACITY:
@@ -970,7 +982,7 @@
 					spin_unlock_irq(host->host_lock);
 					probe_container(dev, cid);
 					spin_lock_irq(host->host_lock);
-					if (fsa_dev_ptr->valid[cid] == 0) {
+					if (fsa_dev_ptr[cid].valid == 0) {
 						scsicmd->result = DID_NO_CONNECT << 16;
 						__aac_io_done(scsicmd);
 						return 0;
@@ -983,7 +995,7 @@
 			 *	If the target container still doesn't exist, 
 			 *	return failure
 			 */
-			if (fsa_dev_ptr->valid[cid] == 0) {
+			if (fsa_dev_ptr[cid].valid == 0) {
 				scsicmd->result = DID_BAD_TARGET << 16;
 				__aac_io_done(scsicmd);
 				return 0;
@@ -1006,12 +1018,15 @@
 	{
 		dprintk((KERN_WARNING "Only INQUIRY & TUR command supported for controller, rcvd = 0x%x.\n", scsicmd->cmnd[0]));
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-		set_sense((u8 *) &sense_data[cid],
+		set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 			    ILLEGAL_REQUEST,
 			    SENCODE_INVALID_COMMAND,
 			    ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+		  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
+		    ? sizeof(scsicmd->sense_buffer)
+		    : sizeof(dev->fsa_dev[cid].sense_data));
 		__aac_io_done(scsicmd);
-		memcpy(scsicmd->sense_buffer, &sense_data[cid], sizeof(struct sense_data));
 		return 0;
 	}
 
@@ -1036,7 +1051,7 @@
 		 *	Set the Vendor, Product, and Revision Level
 		 *	see: <vendor>.c i.e. aac.c
 		 */
-		setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), fsa_dev_ptr->type[cid]);
+		setinqstr(cardtype, (void *) (inq_data_ptr->inqd_vid), fsa_dev_ptr[cid].type);
 		if (scsicmd->device->id == host->this_id)
 			inq_data_ptr->inqd_pdt = INQD_PDT_PROC;	/* Processor device */
 		else
@@ -1047,11 +1062,14 @@
 	}
 	case READ_CAPACITY:
 	{
-		int capacity;
+		u32 capacity;
 		char *cp;
 
 		dprintk((KERN_DEBUG "READ CAPACITY command.\n"));
-		capacity = fsa_dev_ptr->size[cid] - 1;
+		if (fsa_dev_ptr[cid].size <= 0x100000000)
+			capacity = fsa_dev_ptr[cid].size - 1;
+		else
+			capacity = (u32)-1;
 		cp = scsicmd->request_buffer;
 		cp[0] = (capacity >> 24) & 0xff;
 		cp[1] = (capacity >> 16) & 0xff;
@@ -1106,8 +1124,8 @@
 	}
 	case REQUEST_SENSE:
 		dprintk((KERN_DEBUG "REQUEST SENSE command.\n"));
-		memcpy(scsicmd->sense_buffer, &sense_data[cid], sizeof (struct sense_data));
-		memset(&sense_data[cid], 0, sizeof (struct sense_data));
+		memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data, sizeof (struct sense_data));
+		memset(&dev->fsa_dev[cid].sense_data, 0, sizeof (struct sense_data));
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
 		return 0;
@@ -1115,9 +1133,9 @@
 	case ALLOW_MEDIUM_REMOVAL:
 		dprintk((KERN_DEBUG "LOCK command.\n"));
 		if (scsicmd->cmnd[4])
-			fsa_dev_ptr->locked[cid] = 1;
+			fsa_dev_ptr[cid].locked = 1;
 		else
-			fsa_dev_ptr->locked[cid] = 0;
+			fsa_dev_ptr[cid].locked = 0;
 
 		scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 		__aac_io_done(scsicmd);
@@ -1149,7 +1167,7 @@
 			 
 			spin_unlock_irq(host->host_lock);
 			if  (scsicmd->request->rq_disk)
-				memcpy(fsa_dev_ptr->devname[cid],
+				memcpy(fsa_dev_ptr[cid].devname,
 					scsicmd->request->rq_disk->disk_name,
 					8);
 
@@ -1169,11 +1187,13 @@
 			 */
 			printk(KERN_WARNING "Unhandled SCSI Command: 0x%x.\n", scsicmd->cmnd[0]);
 			scsicmd->result = DID_OK << 16 | COMMAND_COMPLETE << 8 | SAM_STAT_CHECK_CONDITION;
-			set_sense((u8 *) &sense_data[cid],
+			set_sense((u8 *) &dev->fsa_dev[cid].sense_data,
 				ILLEGAL_REQUEST, SENCODE_INVALID_COMMAND,
-			ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
-			memcpy(scsicmd->sense_buffer, &sense_data[cid],
-				sizeof(struct sense_data));
+				ASENCODE_INVALID_COMMAND, 0, 0, 0, 0);
+			memcpy(scsicmd->sense_buffer, &dev->fsa_dev[cid].sense_data,
+			  (sizeof(dev->fsa_dev[cid].sense_data) > sizeof(scsicmd->sense_buffer))
+			    ? sizeof(scsicmd->sense_buffer)
+			    : sizeof(dev->fsa_dev[cid].sense_data));
 			__aac_io_done(scsicmd);
 			return 0;
 	}
@@ -1182,16 +1202,16 @@
 static int query_disk(struct aac_dev *dev, void __user *arg)
 {
 	struct aac_query_disk qd;
-	struct fsa_scsi_hba *fsa_dev_ptr;
+	struct fsa_dev_info *fsa_dev_ptr;
 
-	fsa_dev_ptr = &(dev->fsa_dev);
+	fsa_dev_ptr = dev->fsa_dev;
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
 	if (qd.cnum == -1)
 		qd.cnum = ID_LUN_TO_CONTAINER(qd.id, qd.lun);
 	else if ((qd.bus == -1) && (qd.id == -1) && (qd.lun == -1)) 
 	{
-		if (qd.cnum < 0 || qd.cnum >= MAXIMUM_NUM_CONTAINERS)
+		if (qd.cnum < 0 || qd.cnum >= dev->maximum_num_containers)
 			return -EINVAL;
 		qd.instance = dev->scsi_host_ptr->host_no;
 		qd.bus = 0;
@@ -1200,16 +1220,17 @@
 	}
 	else return -EINVAL;
 
-	qd.valid = fsa_dev_ptr->valid[qd.cnum];
-	qd.locked = fsa_dev_ptr->locked[qd.cnum];
-	qd.deleted = fsa_dev_ptr->deleted[qd.cnum];
+	qd.valid = fsa_dev_ptr[qd.cnum].valid;
+	qd.locked = fsa_dev_ptr[qd.cnum].locked;
+	qd.deleted = fsa_dev_ptr[qd.cnum].deleted;
 
-	if (fsa_dev_ptr->devname[qd.cnum][0] == '\0')
+	if (fsa_dev_ptr[qd.cnum].devname[0] == '\0')
 		qd.unmapped = 1;
 	else
 		qd.unmapped = 0;
 
-	strlcpy(qd.name, fsa_dev_ptr->devname[qd.cnum], sizeof(qd.name));
+	strlcpy(qd.name, fsa_dev_ptr[qd.cnum].devname,
+	  min(sizeof(qd.name), sizeof(fsa_dev_ptr[qd.cnum].devname) + 1));
 
 	if (copy_to_user(arg, &qd, sizeof (struct aac_query_disk)))
 		return -EFAULT;
@@ -1219,49 +1240,49 @@
 static int force_delete_disk(struct aac_dev *dev, void __user *arg)
 {
 	struct aac_delete_disk dd;
-	struct fsa_scsi_hba *fsa_dev_ptr;
+	struct fsa_dev_info *fsa_dev_ptr;
 
-	fsa_dev_ptr = &(dev->fsa_dev);
+	fsa_dev_ptr = dev->fsa_dev;
 
 	if (copy_from_user(&dd, arg, sizeof (struct aac_delete_disk)))
 		return -EFAULT;
 
-	if (dd.cnum >= MAXIMUM_NUM_CONTAINERS)
+	if (dd.cnum >= dev->maximum_num_containers)
 		return -EINVAL;
 	/*
 	 *	Mark this container as being deleted.
 	 */
-	fsa_dev_ptr->deleted[dd.cnum] = 1;
+	fsa_dev_ptr[dd.cnum].deleted = 1;
 	/*
 	 *	Mark the container as no longer valid
 	 */
-	fsa_dev_ptr->valid[dd.cnum] = 0;
+	fsa_dev_ptr[dd.cnum].valid = 0;
 	return 0;
 }
 
 static int delete_disk(struct aac_dev *dev, void __user *arg)
 {
 	struct aac_delete_disk dd;
-	struct fsa_scsi_hba *fsa_dev_ptr;
+	struct fsa_dev_info *fsa_dev_ptr;
 
-	fsa_dev_ptr = &(dev->fsa_dev);
+	fsa_dev_ptr = dev->fsa_dev;
 
 	if (copy_from_user(&dd, arg, sizeof (struct aac_delete_disk)))
 		return -EFAULT;
 
-	if (dd.cnum >= MAXIMUM_NUM_CONTAINERS)
+	if (dd.cnum >= dev->maximum_num_containers)
 		return -EINVAL;
 	/*
 	 *	If the container is locked, it can not be deleted by the API.
 	 */
-	if (fsa_dev_ptr->locked[dd.cnum])
+	if (fsa_dev_ptr[dd.cnum].locked)
 		return -EBUSY;
 	else {
 		/*
 		 *	Mark the container as no longer being valid.
 		 */
-		fsa_dev_ptr->valid[dd.cnum] = 0;
-		fsa_dev_ptr->devname[dd.cnum][0] = '\0';
+		fsa_dev_ptr[dd.cnum].valid = 0;
+		fsa_dev_ptr[dd.cnum].devname[0] = '\0';
 		return 0;
 	}
 }
===== drivers/scsi/aacraid/aacraid.h 1.22 vs edited =====
--- 1.22/drivers/scsi/aacraid/aacraid.h	2004-09-14 16:04:25 -07:00
+++ edited/drivers/scsi/aacraid/aacraid.h	2004-09-23 10:00:36 -07:00
@@ -662,14 +662,53 @@
 	struct list_head	fib_list;	// this holds fibs and their attachd hw_fibs
 };
 
-struct fsa_scsi_hba {
-	u32		size[MAXIMUM_NUM_CONTAINERS];
-	u32		type[MAXIMUM_NUM_CONTAINERS];
-	u8		valid[MAXIMUM_NUM_CONTAINERS];
-	u8		ro[MAXIMUM_NUM_CONTAINERS];
-	u8		locked[MAXIMUM_NUM_CONTAINERS];
-	u8		deleted[MAXIMUM_NUM_CONTAINERS];
-	char		devname[MAXIMUM_NUM_CONTAINERS][8];
+struct sense_data {
+	u8 error_code;		/* 70h (current errors), 71h(deferred errors) */
+	u8 valid:1;		/* A valid bit of one indicates that the information  */
+				/* field contains valid information as defined in the
+				 * SCSI-2 Standard.
+				 */
+	u8 segment_number;	/* Only used for COPY, COMPARE, or COPY AND VERIFY Commands */
+	u8 sense_key:4;		/* Sense Key */
+	u8 reserved:1;
+	u8 ILI:1;		/* Incorrect Length Indicator */
+	u8 EOM:1;		/* End Of Medium - reserved for random access devices */
+	u8 filemark:1;		/* Filemark - reserved for random access devices */
+
+	u8 information[4];	/* for direct-access devices, contains the unsigned 
+				 * logical block address or residue associated with 
+				 * the sense key 
+				 */
+	u8 add_sense_len;	/* number of additional sense bytes to follow this field */
+	u8 cmnd_info[4];	/* not used */
+	u8 ASC;			/* Additional Sense Code */
+	u8 ASCQ;		/* Additional Sense Code Qualifier */
+	u8 FRUC;		/* Field Replaceable Unit Code - not used */
+	u8 bit_ptr:3;		/* indicates which byte of the CDB or parameter data
+				 * was in error
+				 */
+	u8 BPV:1;		/* bit pointer valid (BPV): 1- indicates that 
+				 * the bit_ptr field has valid value
+				 */
+	u8 reserved2:2;
+	u8 CD:1;		/* command data bit: 1- illegal parameter in CDB.
+				 * 0- illegal parameter in data.
+				 */
+	u8 SKSV:1;
+	u8 field_ptr[2];	/* byte of the CDB or parameter data in error */
+};
+
+struct fsa_dev_info {
+	u64		last;
+	u64		size;
+	u32		type;
+	u16		queue_depth;
+	u8		valid;
+	u8		ro;
+	u8		locked;
+	u8		deleted;
+	char		devname[8];
+	struct sense_data sense_data;
 };
 
 struct fib {
@@ -814,7 +853,8 @@
 	size_t			comm_size;
 
 	struct Scsi_Host	*scsi_host_ptr;
-	struct fsa_scsi_hba	fsa_dev;
+	int			maximum_num_containers;
+	struct fsa_dev_info	*fsa_dev;
 	pid_t			thread_pid;
 	int			cardtype;
 	
@@ -1213,6 +1253,25 @@
 	u32		command;	/* VM_ContainerConfig */
 	u32		type;		/* CT_COMMIT_CONFIG */
 };
+
+/*
+ *	Query for Container Configuration Count
+ */
+
+#define CT_GET_CONTAINER_COUNT 4
+struct aac_get_container_count {
+	u32		command;	/* VM_ContainerConfig */
+	u32		type;		/* CT_GET_CONTAINER_COUNT */
+};
+
+struct aac_get_container_count_resp {
+	u32		response; /* ST_OK */
+	u32		dummy0;
+	u32		MaxContainers;
+	u32		ContainerSwitchEntries;
+	u32		MaxPartitions;
+};
+
 
 /*
  *	Query for "mountable" objects, ie, objects that are typically
===== drivers/scsi/aacraid/linit.c 1.40 vs edited =====
--- 1.40/drivers/scsi/aacraid/linit.c	2004-09-19 07:35:54 -07:00
+++ edited/drivers/scsi/aacraid/linit.c	2004-09-23 09:56:38 -07:00
@@ -521,12 +521,10 @@
 {
 	unsigned index = id->driver_data;
 	struct Scsi_Host *shost;
-	struct fsa_scsi_hba *fsa_dev_ptr;
 	struct aac_dev *aac;
 	struct list_head *insert = &aac_devices;
 	int error = -ENODEV;
 	int unique_id = 0;
-	int container;
 
 	list_for_each_entry(aac, &aac_devices, entry) {
 		if (aac->id > unique_id) {
@@ -574,11 +572,6 @@
 		goto out_free_host;
 	spin_lock_init(&aac->fib_lock);
 
-	/* Initialize the ordinal number of the device to -1 */
-	fsa_dev_ptr = &aac->fsa_dev;
-	for (container = 0; container < MAXIMUM_NUM_CONTAINERS; container++)
-		fsa_dev_ptr->devname[container][0] = '\0';
-
 	if ((*aac_drivers[index].init)(aac))
 		goto out_free_fibs;
 
@@ -607,11 +600,16 @@
 	aac_get_containers(aac);
 	list_add(&aac->entry, insert);
 
+	shost->max_id = aac->maximum_num_containers;
+	if (shost->max_id < MAXIMUM_NUM_CONTAINERS)
+		shost->max_id = MAXIMUM_NUM_CONTAINERS;
+	else
+		shost->this_id = shost->max_id;
+
 	/*
 	 * dmb - we may need to move the setting of these parms somewhere else once
 	 * we get a fib that can report the actual numbers
 	 */
-	shost->max_id = MAXIMUM_NUM_CONTAINERS;
 	shost->max_lun = AAC_MAX_LUN;
 
 	pci_set_drvdata(pdev, shost);
@@ -635,6 +633,8 @@
 	iounmap((void * )aac->regs.sa);
  out_free_fibs:
 	kfree(aac->fibs);
+	if (aac->fsa_dev)
+		kfree(aac->fsa_dev);
  out_free_host:
 	scsi_host_put(shost);
  out_disable_pdev:



-- 
Mark Haverkamp <markh@osdl.org>

