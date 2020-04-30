Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014DFC8300F
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD2ED2076D
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 13:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgD3NUi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 09:20:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:60760 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbgD3NUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 09:20:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1EA02AF13;
        Thu, 30 Apr 2020 13:20:02 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: [PATCH RFC v3 15/41] aacraid: use private commands
Date:   Thu, 30 Apr 2020 15:18:38 +0200
Message-Id: <20200430131904.5847-16-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
References: <20200430131904.5847-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Hannes Reinecke <hare@suse.com>

Use private commands to allocate internal commands.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/aacraid/aachba.c   | 14 ++++----
 drivers/scsi/aacraid/aacraid.h  |  9 +++--
 drivers/scsi/aacraid/commctrl.c | 57 ++++++++++++++++---------------
 drivers/scsi/aacraid/comminit.c | 34 +++++++-----------
 drivers/scsi/aacraid/commsup.c  | 76 +++++++++++++++++------------------------
 drivers/scsi/aacraid/dpcsup.c   |  2 +-
 drivers/scsi/aacraid/linit.c    | 54 +++++++++++++++--------------
 7 files changed, 116 insertions(+), 130 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index eb72ac8136c3..64bf36528579 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -359,7 +359,7 @@ int aac_get_config_status(struct aac_dev *dev, int commit_flag)
 	int status = 0;
 	struct fib * fibptr;
 
-	if (!(fibptr = aac_fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE)))
 		return -ENOMEM;
 
 	aac_fib_init(fibptr);
@@ -456,7 +456,7 @@ int aac_get_containers(struct aac_dev *dev)
 	struct aac_get_container_count_resp *dresp;
 	int maximum_num_containers = MAXIMUM_NUM_CONTAINERS;
 
-	if (!(fibptr = aac_fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE)))
 		return -ENOMEM;
 
 	aac_fib_init(fibptr);
@@ -732,9 +732,11 @@ static void _aac_probe_container1(void * context, struct fib * fibptr)
 static int _aac_probe_container(struct scsi_cmnd * scsicmd, int (*callback)(struct scsi_cmnd *))
 {
 	struct fib * fibptr;
+	struct aac_dev * dev;
 	int status = -ENOMEM;
 
-	if ((fibptr = aac_fib_alloc((struct aac_dev *)scsicmd->device->host->hostdata))) {
+	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
+	if ((fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE))) {
 		struct aac_query_mount *dinfo;
 
 		aac_fib_init(fibptr);
@@ -1673,7 +1675,7 @@ static int aac_send_safw_bmic_cmd(struct aac_dev *dev,
 		return 0;
 
 	/* allocate FIB */
-	fibptr = aac_fib_alloc(dev);
+	fibptr = aac_fib_alloc(dev, DMA_BIDIRECTIONAL);
 	if (!fibptr)
 		return -ENOMEM;
 
@@ -2040,7 +2042,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	struct aac_bus_info *command;
 	struct aac_bus_info_response *bus_info;
 
-	if (!(fibptr = aac_fib_alloc(dev)))
+	if (!(fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE)))
 		return -ENOMEM;
 
 	aac_fib_init(fibptr);
@@ -2087,7 +2089,7 @@ int aac_get_adapter_info(struct aac_dev* dev)
 		if (rcode >= 0)
 			memcpy(&dev->supplement_adapter_info, sinfo, sizeof(*sinfo));
 		if (rcode == -ERESTARTSYS) {
-			fibptr = aac_fib_alloc(dev);
+			fibptr = aac_fib_alloc(dev, DMA_FROM_DEVICE);
 			if (!fibptr)
 				return -ENOMEM;
 		}
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index e3e4ecbea726..5b3fd34363c0 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1291,13 +1291,16 @@ struct fsa_dev_info {
 };
 
 struct fib {
-	void			*next;	/* this is used by the allocator */
 	s16			type;
 	s16			size;
 	/*
 	 *	The Adapter that this I/O is destined for.
 	 */
 	struct aac_dev		*dev;
+	/*
+	 * The associated scsi command
+	 */
+	struct scsi_cmnd 	*scmd;
 	/*
 	 *	This is the event the sendfib routine will wait on if the
 	 *	caller did not pass one and this is synch io.
@@ -1552,7 +1555,6 @@ struct aac_dev
 	 */
 	struct fib              *fibs;
 
-	struct fib		*free_fib;
 	spinlock_t		fib_lock;
 
 	struct mutex		ioctl_mutex;
@@ -1597,6 +1599,7 @@ struct aac_dev
 	size_t			comm_size;
 
 	struct Scsi_Host	*scsi_host_ptr;
+	struct scsi_device	*scsi_host_dev;
 	int			maximum_num_containers;
 	int			maximum_num_physicals;
 	int			maximum_num_channels;
@@ -2686,7 +2689,7 @@ void aac_free_irq(struct aac_dev *dev);
 int aac_setup_safw_adapter(struct aac_dev *dev);
 const char *aac_driverinfo(struct Scsi_Host *);
 void aac_fib_vector_assign(struct aac_dev *dev);
-struct fib *aac_fib_alloc(struct aac_dev *dev);
+struct fib *aac_fib_alloc(struct aac_dev *dev, int direction);
 struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd);
 int aac_fib_setup(struct aac_dev *dev);
 void aac_fib_map_free(struct aac_dev *dev);
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index ffe41bc111fc..cd41a9e4ab4a 100644
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
@@ -462,7 +462,7 @@ static int check_revision(struct aac_dev *dev, void __user *arg)
 
 static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 {
-	struct fib* srbfib;
+	struct fib* srbfib = NULL;
 	int status;
 	struct aac_srb *srbcmd = NULL;
 	struct aac_hba_cmd_req *hbacmd = NULL;
@@ -493,31 +493,10 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		dprintk((KERN_DEBUG"aacraid: No permission to send raw srb\n"));
 		return -EPERM;
 	}
-	/*
-	 *	Allocate and initialize a Fib then setup a SRB command
-	 */
-	if (!(srbfib = aac_fib_alloc(dev))) {
-		return -ENOMEM;
-	}
-
-	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
-	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
-		dprintk((KERN_DEBUG"aacraid: Could not copy data size from user\n"));
-		rcode = -EFAULT;
-		goto cleanup;
-	}
-
-	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
-	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
-		rcode = -EINVAL;
-		goto cleanup;
-	}
-
 	user_srbcmd = kmalloc(fibsize, GFP_KERNEL);
 	if (!user_srbcmd) {
 		dprintk((KERN_DEBUG"aacraid: Could not make a copy of the srb\n"));
-		rcode = -ENOMEM;
-		goto cleanup;
+		return -ENOMEM;
 	}
 	if(copy_from_user(user_srbcmd, user_srb,fibsize)){
 		dprintk((KERN_DEBUG"aacraid: Could not copy srb from user\n"));
@@ -550,6 +529,28 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 		rcode = -EINVAL;
 		goto cleanup;
 	}
+
+	/*
+	 *	Allocate and initialize a Fib then setup a SRB command
+	 */
+	if (!(srbfib = aac_fib_alloc(dev, data_dir))) {
+		rcode = -ENOMEM;
+		goto cleanup;
+	}
+
+	memset(sg_list, 0, sizeof(sg_list)); /* cleanup may take issue */
+	if(copy_from_user(&fibsize, &user_srb->count,sizeof(u32))){
+		dprintk((KERN_DEBUG"aacraid: Could not copy data size from user\n"));
+		rcode = -EFAULT;
+		goto cleanup;
+	}
+
+	if ((fibsize < (sizeof(struct user_aac_srb) - sizeof(struct user_sgentry))) ||
+	    (fibsize > (dev->max_fib_size - sizeof(struct aac_fibhdr)))) {
+		rcode = -EINVAL;
+		goto cleanup;
+	}
+
 	actual_fibsize = sizeof(struct aac_srb) - sizeof(struct sgentry) +
 		((user_srbcmd->sg.count & 0xff) * sizeof(struct sgentry));
 	actual_fibsize64 = actual_fibsize + (user_srbcmd->sg.count & 0xff) *
@@ -971,13 +972,15 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 	}
 
 cleanup:
-	kfree(user_srbcmd);
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
+	kfree(user_srbcmd);
 
 	return rcode;
 }
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 355b16f0b145..baca5883775b 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -67,14 +67,13 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE2) ||
 		(dev->comm_interface == AAC_COMM_MESSAGE_TYPE3 &&
 		!dev->sa_firmware)) {
-		host_rrq_size =
-			(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB)
+		host_rrq_size = dev->scsi_host_ptr->can_queue
 				* sizeof(u32);
 		aac_init_size = sizeof(union aac_init);
 	} else if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3 &&
 		dev->sa_firmware) {
-		host_rrq_size = (dev->scsi_host_ptr->can_queue
-			+ AAC_NUM_MGT_FIB) * sizeof(u32)  * AAC_MAX_MSIX;
+		host_rrq_size = dev->scsi_host_ptr->can_queue
+			* sizeof(u32)  * AAC_MAX_MSIX;
 		aac_init_size = sizeof(union aac_init) +
 			(AAC_MAX_HRRQ - 1) * sizeof(struct _rrq);
 	} else {
@@ -179,8 +178,7 @@ static int aac_alloc_comm(struct aac_dev *dev, void **commaddr, unsigned long co
 			cpu_to_le32(INITFLAGS_DRIVER_USES_UTC_TIME |
 			INITFLAGS_DRIVER_SUPPORTS_PM);
 		init->r7.max_io_commands =
-			cpu_to_le32(dev->scsi_host_ptr->can_queue +
-					AAC_NUM_MGT_FIB);
+			cpu_to_le32(dev->scsi_host_ptr->can_queue);
 		init->r7.max_io_size =
 			cpu_to_le32(dev->scsi_host_ptr->max_sectors << 9);
 		init->r7.max_fib_size = cpu_to_le32(dev->max_fib_size);
@@ -327,7 +325,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 
 	aac_wait_for_io_completion(dev);
 
-	fibctx = aac_fib_alloc(dev);
+	fibctx = aac_fib_alloc(dev, DMA_NONE);
 	if (!fibctx)
 		return -ENOMEM;
 	aac_fib_init(fibctx);
@@ -462,9 +460,7 @@ void aac_define_int_mode(struct aac_dev *dev)
 	    dev->pdev->device == PMC_DEVICE_S6 ||
 	    dev->sync_mode) {
 		dev->max_msix = 1;
-		dev->vector_cap =
-			dev->scsi_host_ptr->can_queue +
-			AAC_NUM_MGT_FIB;
+		dev->vector_cap = dev->scsi_host_ptr->can_queue;
 		return;
 	}
 
@@ -500,11 +496,9 @@ void aac_define_int_mode(struct aac_dev *dev)
 			dev->max_msix = msi_count;
 	}
 	if (dev->comm_interface == AAC_COMM_MESSAGE_TYPE3 && dev->sa_firmware)
-		dev->vector_cap = dev->scsi_host_ptr->can_queue +
-				AAC_NUM_MGT_FIB;
+		dev->vector_cap = dev->scsi_host_ptr->can_queue;
 	else
-		dev->vector_cap = (dev->scsi_host_ptr->can_queue +
-				AAC_NUM_MGT_FIB) / msi_count;
+		dev->vector_cap = dev->scsi_host_ptr->can_queue / msi_count;
 
 }
 struct aac_dev *aac_init_adapter(struct aac_dev *dev)
@@ -610,14 +604,10 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 		host->sg_tablesize = status[2] >> 16;
 		dev->sg_tablesize = status[2] & 0xFFFF;
 		if (aac_is_src(dev)) {
-			if (host->can_queue > (status[3] >> 16) -
-					AAC_NUM_MGT_FIB)
-				host->can_queue = (status[3] >> 16) -
-					AAC_NUM_MGT_FIB;
-		} else if (host->can_queue > (status[3] & 0xFFFF) -
-				AAC_NUM_MGT_FIB)
-			host->can_queue = (status[3] & 0xFFFF) -
-				AAC_NUM_MGT_FIB;
+			if (host->can_queue > (status[3] >> 16))
+				host->can_queue = (status[3] >> 16);
+		} else if (host->can_queue > (status[3] & 0xFFFF))
+			host->can_queue = (status[3] & 0xFFFF);
 
 		dev->max_num_aif = status[4] & 0xFFFF;
 	}
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index ddd73f6798af..8c6da75188a6 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -64,7 +64,7 @@ static int fib_map_alloc(struct aac_dev *dev)
 	  AAC_NUM_MGT_FIB, &dev->hw_fib_pa));
 	dev->hw_fib_va = dma_alloc_coherent(&dev->pdev->dev,
 		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr))
-		* (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB) + (ALIGN32 - 1),
+		* (dev->scsi_host_ptr->can_queue) + (ALIGN32 - 1),
 		&dev->hw_fib_pa, GFP_KERNEL);
 	if (dev->hw_fib_va == NULL)
 		return -ENOMEM;
@@ -88,7 +88,7 @@ void aac_fib_map_free(struct aac_dev *dev)
 	if(!dev->hw_fib_va || !dev->max_cmd_size)
 		return;
 
-	num_fibs = dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
+	num_fibs = dev->scsi_host_ptr->can_queue;
 	fib_size = dev->max_fib_size + sizeof(struct aac_fib_xporthdr);
 	alloc_size = fib_size * num_fibs + ALIGN32 - 1;
 
@@ -106,10 +106,10 @@ void aac_fib_vector_assign(struct aac_dev *dev)
 	struct fib *fibptr = NULL;
 
 	for (i = 0, fibptr = &dev->fibs[i];
-		i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
+		i < (dev->scsi_host_ptr->can_queue);
 		i++, fibptr++) {
 		if ((dev->max_msix == 1) ||
-		  (i > ((dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB - 1)
+		  (i > ((dev->scsi_host_ptr->can_queue - 1)
 			- dev->vector_cap))) {
 			fibptr->vector_no = 0;
 		} else {
@@ -138,9 +138,9 @@ int aac_fib_setup(struct aac_dev * dev)
 	u32 max_cmds;
 
 	while (((i = fib_map_alloc(dev)) == -ENOMEM)
-	 && (dev->scsi_host_ptr->can_queue > (64 - AAC_NUM_MGT_FIB))) {
-		max_cmds = (dev->scsi_host_ptr->can_queue+AAC_NUM_MGT_FIB) >> 1;
-		dev->scsi_host_ptr->can_queue = max_cmds - AAC_NUM_MGT_FIB;
+	 && (dev->scsi_host_ptr->can_queue > 64)) {
+		max_cmds = dev->scsi_host_ptr->can_queue >> 1;
+		dev->scsi_host_ptr->can_queue = max_cmds;
 		if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE3)
 			dev->init->r7.max_io_commands = cpu_to_le32(max_cmds);
 	}
@@ -149,7 +149,7 @@ int aac_fib_setup(struct aac_dev * dev)
 
 	memset(dev->hw_fib_va, 0,
 		(dev->max_cmd_size + sizeof(struct aac_fib_xporthdr)) *
-		(dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB));
+		dev->scsi_host_ptr->can_queue);
 
 	/* 32 byte alignment for PMC */
 	hw_fib_pa = (dev->hw_fib_pa + (ALIGN32 - 1)) & ~(ALIGN32 - 1);
@@ -165,7 +165,7 @@ int aac_fib_setup(struct aac_dev * dev)
 	 *	Initialise the fibs
 	 */
 	for (i = 0, fibptr = &dev->fibs[i];
-		i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
+		i < (dev->scsi_host_ptr->can_queue);
 		i++, fibptr++)
 	{
 		fibptr->flags = 0;
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
 
@@ -232,7 +223,7 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
 	fibptr->type = FSAFS_NTC_FIB_CONTEXT;
 	fibptr->callback_data = NULL;
 	fibptr->callback = NULL;
-	fibptr->flags = 0;
+	fibptr->scmd = scmd;
 
 	return fibptr;
 }
@@ -240,36 +231,27 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
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
-	}
-	dev->free_fib = fibptr->next;
+	scmd = scsi_get_reserved_cmd(dev->scsi_host_dev, direction);
+	if (scmd)
+		fibptr = aac_fib_alloc_tag(dev, scmd);
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
@@ -297,8 +279,12 @@ void aac_fib_free(struct fib *fibptr)
 			 (void*)fibptr,
 			 le32_to_cpu(fibptr->hw_fib_va->header.XferState));
 	}
-	fibptr->next = fibptr->dev->free_fib;
-	fibptr->dev->free_fib = fibptr;
+	if (fibptr->scmd) {
+		struct scsi_cmnd *scmd = fibptr->scmd;
+
+		fibptr->scmd = NULL;
+		scsi_put_reserved_cmd(scmd);
+	}
 	spin_unlock_irqrestore(&fibptr->dev->fib_lock, flags);
 }
 
@@ -1514,7 +1500,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 *	Loop through the fibs, close the synchronous FIBS
 	 */
 	retval = 1;
-	num_of_fibs = aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB;
+	num_of_fibs = aac->scsi_host_ptr->can_queue;
 	for (index = 0; index <  num_of_fibs; index++) {
 
 		struct fib *fib = &aac->fibs[index];
@@ -1661,7 +1647,7 @@ int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 		retval = unblock_retval;
 	if ((forced < 2) && (retval == -ENODEV)) {
 		/* Unwind aac_send_shutdown() IOP_RESET unsupported/disabled */
-		struct fib * fibctx = aac_fib_alloc(aac);
+	  struct fib * fibctx = aac_fib_alloc(aac, DMA_NONE);
 		if (fibctx) {
 			struct aac_pause *cmd;
 			int status;
@@ -2288,7 +2274,7 @@ static int aac_send_wellness_command(struct aac_dev *dev, char *wellness_str,
 	int ret = -ENOMEM;
 	u32 vbus, vid;
 
-	fibptr = aac_fib_alloc(dev);
+	fibptr = aac_fib_alloc(dev, DMA_TO_DEVICE);
 	if (!fibptr)
 		goto out;
 
@@ -2386,7 +2372,7 @@ int aac_send_hosttime(struct aac_dev *dev, struct timespec64 *now)
 	struct fib *fibptr;
 	__le32 *info;
 
-	fibptr = aac_fib_alloc(dev);
+	fibptr = aac_fib_alloc(dev, DMA_TO_DEVICE);
 	if (!fibptr)
 		goto out;
 
diff --git a/drivers/scsi/aacraid/dpcsup.c b/drivers/scsi/aacraid/dpcsup.c
index a557aa629827..ae88e1d20c7b 100644
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
index 83a60b0a8cd8..91a4780d9815 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -700,7 +700,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 		 host->host_no, sdev_channel(dev), sdev_id(dev), (int)dev->lun);
 
 		found = 0;
-		for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
+		for (count = 0; count < host->can_queue; ++count) {
 			fib = &aac->fibs[count];
 			if (*(u8 *)fib->hw_fib_va != 0 &&
 				(fib->flags & FIB_CONTEXT_FLAG_NATIVE_HBA) &&
@@ -713,7 +713,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 			return ret;
 
 		/* start a HBA_TMF_ABORT_TASK TMF request */
-		fib = aac_fib_alloc(aac);
+		fib = aac_fib_alloc(aac, DMA_NONE);
 		if (!fib)
 			return ret;
 
@@ -771,9 +771,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 			 * Mark associated FIB to not complete,
 			 * eh handler does this
 			 */
-			for (count = 0;
-				count < (host->can_queue + AAC_NUM_MGT_FIB);
-				++count) {
+			for (count = 0; count < host->can_queue; ++count) {
 				struct fib *fib = &aac->fibs[count];
 
 				if (fib->hw_fib_va->header.XferState &&
@@ -792,9 +790,7 @@ static int aac_eh_abort(struct scsi_cmnd* cmd)
 			 * Mark associated FIB to not complete,
 			 * eh handler does this
 			 */
-			for (count = 0;
-				count < (host->can_queue + AAC_NUM_MGT_FIB);
-				++count) {
+			for (count = 0; count < host->can_queue; ++count) {
 				struct scsi_cmnd *command;
 				struct fib *fib = &aac->fibs[count];
 
@@ -924,7 +920,7 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
 	pr_err("%s: Host device reset request. SCSI hang ?\n",
 	       AAC_DRIVERNAME);
 
-	fib = aac_fib_alloc(aac);
+	fib = aac_fib_alloc(aac, DMA_NONE);
 	if (!fib)
 		return ret;
 
@@ -987,7 +983,7 @@ static int aac_eh_target_reset(struct scsi_cmnd *cmd)
 	pr_err("%s: Host target reset request. SCSI hang ?\n",
 	       AAC_DRIVERNAME);
 
-	fib = aac_fib_alloc(aac);
+	fib = aac_fib_alloc(aac, DMA_NONE);
 	if (!fib)
 		return ret;
 
@@ -1037,7 +1033,7 @@ static int aac_eh_bus_reset(struct scsi_cmnd* cmd)
 
 	cmd_bus = aac_logical_to_phys(scmd_channel(cmd));
 	/* Mark the assoc. FIB to not complete, eh handler does this */
-	for (count = 0; count < (host->can_queue + AAC_NUM_MGT_FIB); ++count) {
+	for (count = 0; count < host->can_queue; ++count) {
 		struct fib *fib = &aac->fibs[count];
 
 		if (fib->hw_fib_va->header.XferState &&
@@ -1549,7 +1545,7 @@ static struct scsi_host_template aac_driver_template = {
 	.eh_target_reset_handler	= aac_eh_target_reset,
 	.eh_bus_reset_handler		= aac_eh_bus_reset,
 	.eh_host_reset_handler		= aac_eh_host_reset,
-	.can_queue			= AAC_NUM_IO_FIB,
+	.can_queue			= AAC_NUM_FIB,
 	.this_id			= MAXIMUM_NUM_CONTAINERS,
 	.sg_tablesize			= 16,
 	.max_sectors			= 128,
@@ -1573,7 +1569,7 @@ static void __aac_shutdown(struct aac_dev * aac)
 	if (aac->aif_thread) {
 		int i;
 		/* Clear out events first */
-		for (i = 0; i < (aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); i++) {
+		for (i = 0; i < aac->scsi_host_ptr->can_queue; i++) {
 			struct fib *fib = &aac->fibs[i];
 			if (!(fib->hw_fib_va->header.XferState & cpu_to_le32(NoResponseExpected | Async)) &&
 			    (fib->hw_fib_va->header.XferState & cpu_to_le32(ResponseExpected)))
@@ -1695,6 +1691,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
 	shost->max_cmd_len = 16;
+	shost->max_id = MAXIMUM_NUM_CONTAINERS;
+	shost->max_lun = AAC_MAX_LUN;
+	shost->nr_reserved_cmds = AAC_NUM_MGT_FIB;
+	shost->sg_tablesize = HBA_MAX_SG_SEPARATE;
 
 	if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
 		aac_init_char();
@@ -1711,7 +1711,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (aac_reset_devices || reset_devices)
 		aac->init_reset = true;
 
-	aac->fibs = kcalloc(shost->can_queue + AAC_NUM_MGT_FIB,
+	aac->fibs = kcalloc(shost->can_queue,
 			    sizeof(struct fib),
 			    GFP_KERNEL);
 	if (!aac->fibs)
@@ -1721,6 +1721,15 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	mutex_init(&aac->ioctl_mutex);
 	mutex_init(&aac->scan_mutex);
 
+	error = scsi_add_host(shost, &pdev->dev);
+	if (error)
+		goto out_free_fibs;
+
+	aac->scsi_host_dev = scsi_get_virtual_dev(shost,
+						  MAXIMUM_NUM_CONTAINERS, 0);
+	if (!aac->scsi_host_dev)
+		goto out_remove_host;
+
 	INIT_DELAYED_WORK(&aac->safw_rescan_work, aac_safw_rescan_worker);
 	INIT_DELAYED_WORK(&aac->src_reinit_aif_worker,
 				aac_src_reinit_aif_worker);
@@ -1817,18 +1826,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!aac->sa_firmware && aac_drivers[index].quirks & AAC_QUIRK_SRC)
 		aac_intr_normal(aac, 0, 2, 0, NULL);
 
-	/*
-	 * dmb - we may need to move the setting of these parms somewhere else once
-	 * we get a fib that can report the actual numbers
-	 */
-	shost->max_lun = AAC_MAX_LUN;
-
 	pci_set_drvdata(pdev, shost);
 
-	error = scsi_add_host(shost, &pdev->dev);
-	if (error)
-		goto out_deinit;
-
 	aac_scan_host(aac);
 
 	pci_enable_pcie_error_reporting(pdev);
@@ -1845,8 +1844,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 				  aac->comm_addr, aac->comm_phys);
 	kfree(aac->queues);
 	aac_adapter_ioremap(aac, 0);
-	kfree(aac->fibs);
 	kfree(aac->fsa_dev);
+ out_remove_host:
+	scsi_remove_host(shost);
+ out_free_fibs:
+	kfree(aac->fibs);
  out_free_host:
 	scsi_host_put(shost);
  out_disable_pdev:
@@ -1975,9 +1977,9 @@ static void aac_remove_one(struct pci_dev *pdev)
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
 
 	aac_cancel_rescan_worker(aac);
-	scsi_remove_host(shost);
 
 	__aac_shutdown(aac);
+	scsi_remove_host(shost);
 	aac_fib_map_free(aac);
 	dma_free_coherent(&aac->pdev->dev, aac->comm_size, aac->comm_addr,
 			  aac->comm_phys);
-- 
2.16.4

