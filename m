Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B745C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Nov 2021 15:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353210AbhKYPSU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 10:18:20 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:47316 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355963AbhKYPQP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 10:16:15 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 258351FDF3;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637853062; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ha0BcPhGIOFUjTBI4owINVfkCQUosbAJtPYzbLrQgDo=;
        b=pFqZms9R4NRDe5Xwwuo61PabkF1H/W3qUYjhLNCNJkc9FLEgYuQdeFYOeGpU+BIDKaBzne
        /Xp3mTKd8a3+X3chIbOalPZIiE6pOCARxS46sOMmxZs4tsz94+K2gUWhb2DoMgw0Ak0PzV
        hwivXSKK7nUVyJagbgVsEHEp6j/V+yU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637853062;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ha0BcPhGIOFUjTBI4owINVfkCQUosbAJtPYzbLrQgDo=;
        b=1xH+dbfw8v6NSTujIZt9tL+fw+wQ4e1FZcSbeYusgRi9KhFy6QgV0LHpgS+8NMwweAI226
        LEsp6AeaNvp+OdDA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 1ACE9A3B95;
        Thu, 25 Nov 2021 15:11:02 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CEE5F5191A08; Thu, 25 Nov 2021 16:11:01 +0100 (CET)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 14/15] aacraid: use scsi_get_internal_cmd()
Date:   Thu, 25 Nov 2021 16:10:47 +0100
Message-Id: <20211125151048.103910-15-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211125151048.103910-1-hare@suse.de>
References: <20211125151048.103910-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Use scsi_get_internal_cmd() to allocate internal commands and drop
the fake scsi command and device allocation during container probing.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aacraid/aachba.c   | 103 +++++++++++++++-----------------
 drivers/scsi/aacraid/aacraid.h  |   9 ++-
 drivers/scsi/aacraid/commctrl.c |  25 ++++----
 drivers/scsi/aacraid/comminit.c |   2 +-
 drivers/scsi/aacraid/commsup.c  |  66 +++++++++-----------
 drivers/scsi/aacraid/dpcsup.c   |   2 +-
 drivers/scsi/aacraid/linit.c    |   8 ++-
 7 files changed, 104 insertions(+), 111 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index b21ccf7af43f..ff4c5153b5d6 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -360,7 +360,7 @@ int aac_get_config_status(struct aac_dev *dev, int commit_flag)
 	int status = 0;
 	struct fib * fibptr;
 
-	if (!(fibptr = aac_fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE)))
 		return -ENOMEM;
 
 	aac_fib_init(fibptr);
@@ -457,7 +457,7 @@ int aac_get_containers(struct aac_dev *dev)
 	struct aac_get_container_count_resp *dresp;
 	int maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
 
-	if (!(fibptr = aac_fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE)))
 		return -ENOMEM;
 
 	aac_fib_init(fibptr);
@@ -520,7 +520,7 @@ int aac_get_containers(struct aac_dev *dev)
 
 static void aac_scsi_done(struct scsi_cmnd *scmd)
 {
-	if (scmd->device->request_queue) {
+	if (scmd->device != scmd->device->host->shost_sdev) {
 		/* SCSI command has been submitted by the SCSI mid-layer. */
 		scsi_done(scmd);
 	} else {
@@ -620,9 +620,10 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 
 static int aac_probe_container_callback2(struct scsi_cmnd * scsicmd)
 {
-	struct fsa_dev_info *fsa_dev_ptr = ((struct aac_dev *)(scsicmd->device->host->hostdata))->fsa_dev;
+	struct aac_dev * dev = (struct aac_dev *)scsicmd->device->host->hostdata;
+	unsigned int cid = scmd_id(scsicmd);
 
-	if ((fsa_dev_ptr[scmd_id(scsicmd)].valid & 1))
+	if (cid < dev->maximum_num_containers && (dev->fsa_dev[cid].valid & 1))
 		return aac_scsi_cmd(scsicmd);
 
 	scsicmd->result = DID_NO_CONNECT << 16;
@@ -675,7 +676,6 @@ static void _aac_probe_container2(void * context, struct fib * fibptr)
 		fsa_dev_ptr->valid = 0;
 
 	aac_fib_complete(fibptr);
-	aac_fib_free(fibptr);
 	callback = (int (*)(struct scsi_cmnd *))(scsicmd->host_scribble);
 	scsicmd->host_scribble = NULL;
 	(*callback)(scsicmd);
@@ -734,55 +734,46 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 	}
 }
 
-static int _aac_probe_container(struct scsi_cmnd * scsicmd, unsigned int cid,
+static int _aac_probe_container(struct aac_dev *dev, struct fib *fibptr,
 				int (*callback)(struct scsi_cmnd *))
 {
-	struct aac_dev * dev =
-		(struct aac_dev *)scsicmd->device->host->hostdata;
-	struct fib * fibptr;
+	struct scsi_cmnd *scsicmd = fibptr->scmd;
 	int status = -ENOMEM;
+	struct aac_query_mount *dinfo;
 
-	if ((fibptr = aac_fib_alloc(dev))) {
-		struct aac_query_mount *dinfo;
-
-		aac_fib_init(fibptr);
-		fibptr->cid = cid;
+	aac_fib_init(fibptr);
 
-		dinfo = (struct aac_query_mount *)fib_data(fibptr);
+	dinfo = (struct aac_query_mount *)fib_data(fibptr);
 
-		if (fibptr->dev->supplement_adapter_info.supported_options2 &
-		    AAC_OPTION_VARIABLE_BLOCK_SIZE)
-			dinfo->command = cpu_to_le32(VM_NameServeAllBlk);
-		else
-			dinfo->command = cpu_to_le32(VM_NameServe);
+	if (fibptr->dev->supplement_adapter_info.supported_options2 &
+	    AAC_OPTION_VARIABLE_BLOCK_SIZE)
+		dinfo->command = cpu_to_le32(VM_NameServeAllBlk);
+	else
+		dinfo->command = cpu_to_le32(VM_NameServe);
 
-		dinfo->count = cpu_to_le32(fibptr->cid);
-		dinfo->type = cpu_to_le32(FT_FILESYS);
-		scsicmd->host_scribble = (char *)callback;
-		scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
+	dinfo->count = cpu_to_le32(fibptr->cid);
+	dinfo->type = cpu_to_le32(FT_FILESYS);
+	scsicmd->host_scribble = (unsigned char *)callback;
+	scsicmd->SCp.phase = AAC_OWNER_FIRMWARE;
 
-		status = aac_fib_send(ContainerCommand,
+	status = aac_fib_send(ContainerCommand,
 			  fibptr,
 			  sizeof(struct aac_query_mount),
 			  FsaNormal,
 			  0, 1,
 			  _aac_probe_container1,
 			  (void *) scsicmd);
-		/*
-		 *	Check that the command queued to the controller
-		 */
-		if (status == -EINPROGRESS)
-			return 0;
+	/*
+	 *	Check that the command queued to the controller
+	 */
+	if (status == -EINPROGRESS)
+		return 0;
 
-		if (status < 0) {
-			aac_fib_complete(fibptr);
-			aac_fib_free(fibptr);
-			scsicmd->host_scribble = NULL;
-		}
-	}
 	if (status < 0) {
-		if ((dev->fsa_dev[cid].valid & 1) == 0) {
-			dev->fsa_dev[cid].valid = 0;
+		aac_fib_complete(fibptr);
+		if ((dev->fsa_dev[fibptr->cid].valid & 1) == 0) {
+			dev->fsa_dev[fibptr->cid].valid = 0;
+			scsicmd->host_scribble = NULL;
 			return (*callback)(scsicmd);
 		}
 	}
@@ -809,28 +800,24 @@ static void aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
 
 int aac_probe_container(struct aac_dev *dev, unsigned int cid)
 {
-	struct scsi_cmnd *scsicmd = kzalloc(sizeof(*scsicmd), GFP_KERNEL);
-	struct scsi_device *scsidev = kzalloc(sizeof(*scsidev), GFP_KERNEL);
+	struct fib *fibptr;
+	struct scsi_cmnd *scsicmd;
 	int status;
 
-	if (!scsicmd || !scsidev) {
-		kfree(scsicmd);
-		kfree(scsidev);
+	fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE);
+	if (!fibptr)
 		return -ENOMEM;
-	}
 
-	scsicmd->device = scsidev;
-	scsidev->sdev_state = 0;
-	scsidev->id = cid;
-	scsidev->host = dev->scsi_host_ptr;
+	fibptr->cid = cid;
+	scsicmd = fibptr->scmd;
 
-	status = _aac_probe_container(scsicmd, cid,
+	status = _aac_probe_container(dev, fibptr,
 				      aac_probe_container_callback1);
 	if (status == 0)
 		while (scsicmd->host_scribble != NULL)
 			schedule();
-	kfree(scsidev);
-	kfree(scsicmd);
+
+	aac_fib_free(fibptr);
 	return status;
 }
 
@@ -1675,7 +1662,7 @@ static int aac_send_safw_bmic_cmd(struct aac_dev *dev,
 		return 0;
 
 	/* allocate FIB */
-	fibptr = aac_fib_alloc(dev);
+	fibptr = aac_fib_alloc(dev, DMA_BIDIRECTIONAL);
 	if (!fibptr)
 		return -ENOMEM;
 
@@ -2035,7 +2022,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	struct aac_bus_info *command;
 	struct aac_bus_info_response *bus_info;
 
-	if (!(fibptr = aac_fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE)))
 		return -ENOMEM;
 
 	aac_fib_init(fibptr);
@@ -2082,7 +2069,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 		if (rcode >= 0)
 			memcpy(&dev->supplement_adapter_info, sinfo, sizeof(*sinfo));
 		if (rcode == -ERESTARTSYS) {
-			fibptr = aac_fib_alloc(dev);
+			fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE);
 			if (!fibptr)
 				return -ENOMEM;
 		}
@@ -2795,6 +2782,8 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 			if (((fsa_dev_ptr[cid].valid & 1) == 0) ||
 			  (fsa_dev_ptr[cid].sense_data.sense_key ==
 			   NOT_READY)) {
+				struct fib * fibptr;
+
 				switch (scsicmd->cmnd[0]) {
 				case SERVICE_ACTION_IN_16:
 					if (!(dev->raw_io_interface) ||
@@ -2807,7 +2796,9 @@ int aac_scsi_cmd(struct scsi_cmnd * scsicmd)
 				case TEST_UNIT_READY:
 					if (dev->in_reset)
 						return SCSI_MLQUEUE_DEVICE_BUSY;
-					return _aac_probe_container(scsicmd, cid,
+					fibptr = aac_fib_alloc_tag(dev, scsicmd);
+					fibptr->cid = cid;
+					return _aac_probe_container(dev, fibptr,
 							aac_probe_container_callback2);
 				default:
 					break;
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 90705c4f8ec8..1892f49668aa 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1291,7 +1291,6 @@ struct fsa_dev_info {
 };
 
 struct fib {
-	void			*next;	/* this is used by the allocator */
 	s16			type;
 	s16			size;
 	/*
@@ -1302,6 +1301,10 @@ struct fib {
 	 *	The Container that this I/O is destined for.
 	 */
 	u32			cid;
+	/*
+	 * The associated scsi command
+	 */
+	struct scsi_cmnd 	*scmd;
 	/*
 	 *	This is the event the sendfib routine will wait on if the
 	 *	caller did not pass one and this is synch io.
@@ -1556,7 +1559,6 @@ struct aac_dev
 	 */
 	struct fib              *fibs;
 
-	struct fib		*free_fib;
 	spinlock_t		fib_lock;
 
 	struct mutex		ioctl_mutex;
@@ -1733,6 +1735,7 @@ struct aac_dev
 #define FIB_CONTEXT_FLAG_NATIVE_HBA_TMF	(0x00000020)
 #define FIB_CONTEXT_FLAG_SCSI_CMD	(0x00000040)
 #define FIB_CONTEXT_FLAG_EH_RESET	(0x00000080)
+#define FIB_CONTEXT_FLAG_INTERNAL_CMD	(0x00000100)
 
 /*
  *	Define the command values
@@ -2690,7 +2693,7 @@ void aac_free_irq(struct aac_dev *dev);
 int aac_setup_safw_adapter(struct aac_dev *dev);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
-struct fib *aac_fib_alloc(struct aac_dev *dev);
+struct fib *aac_fib_alloc(struct aac_dev *dev, int direction);
 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd);
 int aac_fib_setup(struct aac_dev *dev);
 void aac_fib_map_free(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index e7cc927ed952..bc5b81696476 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -55,7 +55,7 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 	if (dev->in_reset) {
 		return -EBUSY;
 	}
-	fibptr = aac_fib_alloc(dev);
+	fibptr = aac_fib_alloc(dev, DMA_BIDIRECTIONAL);
 	if(fibptr == NULL) {
 		return -ENOMEM;
 	}
@@ -478,7 +478,7 @@ static int check_revision(struct aac_dev *dev, void __user *arg)
  */
 static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 {
-	struct fib* srbfib;
+	struct fib* srbfib = NULL;
 	int status;
 	struct aac_srb *srbcmd = NULL;
 	struct aac_hba_cmd_req *hbacmd = NULL;
@@ -509,12 +509,6 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		dprintk((KERN_DEBUG"aacraid: No permission to send raw srb\n"));
 		return -EPERM;
 	}
-	/*
-	 *	Allocate and initialize a Fib then setup a SRB command
-	 */
-	if (!(srbfib = aac_fib_alloc(dev))) {
-		return -ENOMEM;
-	}
 
 	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
 	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
@@ -561,6 +555,15 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		rcode = -EINVAL;
 		goto cleanup;
 	}
+
+	/*
+	 *	Allocate and initialize a Fib
+	 */
+	if (!(srbfib = aac_fib_alloc(dev, data_dir))) {
+		rcode = -ENOMEM;
+		goto cleanup;
+	}
+
 	actual_fibsize = sizeof(struct aac_srb) - sizeof(struct sgentry) +
 		((user_srbcmd->sg.count & 0xff) * sizeof(struct sgentry));
 	actual_fibsize64 = actual_fibsize + (user_srbcmd->sg.count & 0xff) *
@@ -988,8 +991,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	if (rcode != -ERESTARTSYS) {
 		for (i = 0; i <= sg_indx; i++)
 			kfree(sg_list[i]);
-		aac_fib_complete(srbfib);
-		aac_fib_free(srbfib);
+		if (srbfib) {
+			aac_fib_complete(srbfib);
+			aac_fib_free(srbfib);
+		}
 	}
 
 	return rcode;
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 355b16f0b145..0d5be76891b0 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -327,7 +327,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 
 	aac_wait_for_io_completion(dev);
 
-	fibctx = aac_fib_alloc(dev);
+	fibctx = aac_fib_alloc(dev, DMA_NONE);
 	if (!fibctx)
 		return -ENOMEM;
 	aac_fib_init(fibctx);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index deb32c9f4b3e..aaa9b5d6f55d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -173,7 +173,6 @@ int aac_fib_setup(struct aac_dev * dev)
 		fibptr->dev = dev;
 		fibptr->hw_fib_va = hw_fib;
 		fibptr->data = (void *) fibptr->hw_fib_va->data;
-		fibptr->next = fibptr+1;	/* Forward chain the fibs */
 		init_completion(&fibptr->event_wait);
 		spin_lock_init(&fibptr->event_lock);
 		hw_fib->header.XferState = cpu_to_le32(0xffffffff);
@@ -200,14 +199,6 @@ int aac_fib_setup(struct aac_dev * dev)
 	 */
 	aac_fib_vector_assign(dev);
 
-	/*
-	 *	Add the fib chain to the free list
-	 */
-	dev->fibs[dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1].next = NULL;
-	/*
-	*	Set 8 fibs aside for management tools
-	*/
-	dev->free_fib = &dev->fibs[dev->scsi_host_ptr->can_queue];
 	return 0;
 }
 
@@ -233,7 +224,7 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 	fibptr->type = FSAFS_NTC_FIB_CONTEXT;
 	fibptr->callback_data = NULL;
 	fibptr->callback = NULL;
-	fibptr->flags = 0;
+	fibptr->scmd = scmd;
 
 	return fibptr;
 }
@@ -241,36 +232,30 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 /**
  *	aac_fib_alloc	-	allocate a fib
  *	@dev: Adapter to allocate the fib for
+ *	@direction: DMA data direction
  *
  *	Allocate a fib from the adapter fib pool. If the pool is empty we
  *	return NULL.
  */
 
-struct fib *aac_fib_alloc(struct aac_dev *dev)
+struct fib *aac_fib_alloc(struct aac_dev *dev, int direction)
 {
-	struct fib * fibptr;
+	struct scsi_cmnd *scmd;
+	struct fib * fibptr = NULL;
 	unsigned long flags;
+
 	spin_lock_irqsave(&dev->fib_lock, flags);
-	fibptr = dev->free_fib;
-	if(!fibptr){
-		spin_unlock_irqrestore(&dev->fib_lock, flags);
-		return fibptr;
+	scmd = scsi_get_internal_cmd(dev->scsi_host_ptr->shost_sdev,
+				     direction, true);
+	if (scmd) {
+		fibptr = aac_fib_alloc_tag(dev, scmd);
+		fibptr->flags |= FIB_CONTEXT_FLAG_INTERNAL_CMD;
 	}
-	dev->free_fib = fibptr->next;
 	spin_unlock_irqrestore(&dev->fib_lock, flags);
-	/*
-	 *	Set the proper node type code and node byte size
-	 */
-	fibptr->type = FSAFS_NTC_FIB_CONTEXT;
+	if (!fibptr)
+		return NULL;
+
 	fibptr->size = sizeof(struct fib);
-	/*
-	 *	Null out fields that depend on being zero at the start of
-	 *	each I/O
-	 */
-	fibptr->hw_fib_va->header.XferState = 0;
-	fibptr->flags = 0;
-	fibptr->callback = NULL;
-	fibptr->callback_data = NULL;
 
 	return fibptr;
 }
@@ -298,8 +283,15 @@ void aac_fib_free(struct fib *fibptr)
 			 (void*)fibptr,
 			 le32_to_cpu(fibptr->hw_fib_va->header.XferState));
 	}
-	fibptr->next = fibptr->dev->free_fib;
-	fibptr->dev->free_fib = fibptr;
+	if (fibptr->scmd) {
+		struct scsi_cmnd *scmd = fibptr->scmd;
+
+		fibptr->scmd = NULL;
+		if (fibptr->flags & FIB_CONTEXT_FLAG_INTERNAL_CMD) {
+			scsi_put_internal_cmd(scmd);
+			fibptr->flags &= ~FIB_CONTEXT_FLAG_INTERNAL_CMD;
+		}
+	}
 	spin_unlock_irqrestore(&fibptr->dev->fib_lock, flags);
 }
 
@@ -507,7 +499,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	 *	will have a debug mode where the adapter can notify the host
 	 *	it had a problem and the host can log that fact.
 	 */
-	fibptr->flags = 0;
+	fibptr->flags &= FIB_CONTEXT_FLAG_INTERNAL_CMD;
 	if (wait && !reply) {
 		return -EINVAL;
 	} else if (!wait && reply) {
@@ -562,7 +554,7 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 	if (!wait) {
 		fibptr->callback = callback;
 		fibptr->callback_data = callback_data;
-		fibptr->flags = FIB_CONTEXT_FLAG;
+		fibptr->flags |= FIB_CONTEXT_FLAG;
 	}
 
 	fibptr->done = 0;
@@ -714,7 +706,7 @@ int aac_hba_send(u8 command, struct fib *fibptr, fib_callback callback,
 	struct aac_hba_cmd_req *hbacmd = (struct aac_hba_cmd_req *)
 			fibptr->hw_fib_va;
 
-	fibptr->flags = (FIB_CONTEXT_FLAG | FIB_CONTEXT_FLAG_NATIVE_HBA);
+	fibptr->flags |= (FIB_CONTEXT_FLAG | FIB_CONTEXT_FLAG_NATIVE_HBA);
 	if (callback) {
 		wait = 0;
 		fibptr->callback = callback;
@@ -1663,7 +1655,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 		retval = unblock_retval;
 	if ((forced < 2) && (retval == -ENODEV)) {
 		/* Unwind aac_send_shutdown() IOP_RESET unsupported/disabled */
-		struct fib * fibctx = aac_fib_alloc(aac);
+		struct fib * fibctx = aac_fib_alloc(aac, DMA_NONE);
 		if (fibctx) {
 			struct aac_pause *cmd;
 			int status;
@@ -2290,7 +2282,7 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	int ret = -ENOMEM;
 	u32 vbus, vid;
 
-	fibptr = aac_fib_alloc(dev);
+	fibptr = aac_fib_alloc(dev, DMA_TO_DEVICE);
 	if (!fibptr)
 		goto out;
 
@@ -2388,7 +2380,7 @@ static int aac_send_hosttime(struct aac_dev *dev, struct timespec64 *now)
 	struct fib *fibptr;
 	__le32 *info;
 
-	fibptr = aac_fib_alloc(dev);
+	fibptr = aac_fib_alloc(dev, DMA_TO_DEVICE);
 	if (!fibptr)
 		goto out;
 
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index fbe334c59f37..9424792432ec 100644
--- a/drivers/scsi/aacraid/dpcsup.c
+++ b/drivers/scsi/aacraid/dpcsup.c
@@ -315,7 +315,7 @@ unsigned int aac_intr_normal(struct aac_dev *dev, u32 index, int isAif,
 		struct fib *fibctx;
 		struct aac_aifcmd *cmd;
 
-		fibctx = aac_fib_alloc(dev);
+		fibctx = aac_fib_alloc(dev, DMA_FROM_DEVICE);
 		if (!fibctx)
 			return 1;
 		aac_fib_init(fibctx);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index b92a6595358e..7268118186d1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -716,7 +716,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 			return ret;
 
 		/* start a HBA_TMF_ABORT_TASK TMF request */
-		fib = aac_fib_alloc(aac);
+		fib = aac_fib_alloc(aac, DMA_NONE);
 		if (!fib)
 			return ret;
 
@@ -927,7 +927,7 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 	pr_err("%s: Host device reset request. SCSI hang ?\n",
 	       AAC_DRIVERNAME);
 
-	fib = aac_fib_alloc(aac);
+	fib = aac_fib_alloc(aac, DMA_NONE);
 	if (!fib)
 		return ret;
 
@@ -990,7 +990,7 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 	pr_err("%s: Host target reset request. SCSI hang ?\n",
 	       AAC_DRIVERNAME);
 
-	fib = aac_fib_alloc(aac);
+	fib = aac_fib_alloc(aac, DMA_NONE);
 	if (!fib)
 		return ret;
 
@@ -1507,6 +1507,7 @@ static struct scsi_host_template aac_driver_template = {
 #endif
 	.emulated			= 1,
 	.no_write_same			= 1,
+	.alloc_host_sdev		= 1,
 };
 
 static void __aac_shutdown(struct aac_dev * aac)
@@ -1645,6 +1646,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->max_cmd_len = 16;
 	shost->max_id = MAXIMUM_NUM_CONTAINERS;
 	shost->max_lun = AAC_MAX_LUN;
+	shost->nr_reserved_cmds = AAC_NUM_MGT_FIB;
 	shost->sg_tablesize = HBA_MAX_SG_SEPARATE;
 
 	if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
-- 
2.29.2

