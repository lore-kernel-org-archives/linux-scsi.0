From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add optional legacy	scsi_execute_async()
 usage for Linux/SCSI passthrough
Date: Sun, 19 Apr 2009 13:56:43 +0300
Message-ID: <49EB036B.8090607@panasas.com>
References: <1239930560.4176.577.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:36424 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZDSK4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2009 06:56:51 -0400
In-Reply-To: <1239930560.4176.577.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jens.axboe@oracle.com>, Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>, Geoff Levand <geoffrey.levand@am.sony.com>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Paul Mundt <lethal@linux-sh.org>

On 04/17/2009 04:09 AM, Nicholas A. Bellinger wrote:
> Greetings all,
> 
> This patch modifies the Target_Core_Mod/ConfigFS v3.0 PSCSI subsystem plugin for target_core_mod v3.0 to add
> a configurable method of choosing legacy scsi_execute_async() usage for underlying SCSI HTCL struct scsi_device.
> This method is still the only method of issuing I/O to the Linux SCSI subsystem is used for non TYPE_DISK hardware
> SCSI and SATA devices that appear under Linux-SCSI, but have not yet been updated to accept raw struct request
> operations directly.  Some of these include TYPE_ROM, TYPE_TYPE and TYPE_MEDIUM_CHANGER hardware.
> 
> This method can be used be used via ConfigFS as follows:
> 
> 	export TARGET=/sys/kernel/config/target/core/
>         # load target_core_mod
> 	modprobe target_core_mod
> 	# The Linux/SCSI scsi host id is part of pscsi_$HOST_ID HBA name..
> 	mkdir -p $TARGET/pscsi_0/sr0
> 	# echo CTL to the control configfs attribute
> 	echo scsi_channel_id=0,scsi_target_id=0,scsi_lun_id=0 > $TARGET/pscsi_0/sr0/control
>         # Activate the target_core_mod/ConfigFS PSCSI storage object
> 	echo 1 > $TARGET/pscsi_0/sr0/enable
> 
> At this point, creating symlinks for SCSI target ports to configfs enabled fabric modules
> against PSCSI hardware passthrough using te HCTL reference will work.
> 
> This patch are made against lio-core-2.6.git/master and tested on
> v2.6.29 x86 32-bit HVM with TYPE_DISK and v2.6.29 ppc64 with TYPE_ROM.
> The lio-core-2.6.git tree can be found at: 
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary
> 
> :-)
> 

Are you aware that scsi_execute_async() has gone in 2.6.30-rc1?

I'm not sure what would be the best alternative for you. I would say
a bio, but it is still being debated. Your current options are:

1. bio_alloc then loop () bio_add_pc_page, and finally blk_rq_append_bio
   (Which block people don't like)
2. sglist => page-pointers-array translation and blk_rq_map_user with 
   struct rq_map_data mode. (not possible with all kind of sglists)
2. sglist => iovec translation and blk_rq_map_user_iov()
   (Very very ugly mapping of pages to virtual pointers)

I have a similar situation with my OSD code.

Boaz

> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_pscsi.c |   88 +++++++++++++++++++++++++++++++-----
>  include/target/target_core_pscsi.h |    2 +
>  2 files changed, 79 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 0962563..66510f4 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -399,6 +399,8 @@ void *pscsi_allocate_virtdevice(se_hba_t *hba, const char *name)
>  		return NULL;
>  	}
>  	pdv->pdv_se_hba = hba;
> +	/* Use legacy path unless using ConfigFS FD method */
> +	pdv->pdv_legacy = 1;
>  
>  	printk(KERN_INFO "PSCSI: Allocated pdv: %p for %s\n", pdv, name);
>  	return (void *)pdv;
> @@ -555,9 +557,10 @@ int pscsi_activate_device(se_device_t *dev)
>  	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
>  	struct Scsi_Host *sh = sd->host;
>  
> -	printk(KERN_INFO "CORE_PSCSI[%d] - Activating Device with TCQ: %d at"
> +	printk(KERN_INFO "CORE_PSCSI[%d] - Activating %s Device with TCQ: %d at"
>  		" SCSI Location (Channel/Target/LUN) %d/%d/%d\n", sh->host_no,
> -		 sd->queue_depth, sd->channel, sd->id, sd->lun);
> +		(pdv->pdv_legacy) ? "Legacy" : "REQ",  sd->queue_depth,
> +		sd->channel, sd->id, sd->lun);
>  
>  	return 0;
>  }
> @@ -572,8 +575,9 @@ void pscsi_deactivate_device(se_device_t *dev)
>  	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
>  	struct Scsi_Host *sh = sd->host;
>  
> -	printk(KERN_INFO "CORE_PSCSI[%d] - Deactivating Device with TCQ: %d at"
> -		" SCSI Location (Channel/Target/LUN) %d/%d/%d\n", sh->host_no,
> +	printk(KERN_INFO "CORE_PSCSI[%d] - Deactivating %s Device with TCQ: %d"
> +		" at SCSI Location (Channel/Target/LUN) %d/%d/%d\n",
> +		sh->host_no, (pdv->pdv_legacy) ? "Legacy" : "REQ",
>  		sd->queue_depth, sd->channel, sd->id, sd->lun);
>  }
>  
> @@ -843,6 +847,30 @@ static int pscsi_blk_get_request(se_task_t *task)
>  	return 0;
>  }
>  
> +static int pscsi_do_task_legacy(
> +	se_task_t *task,
> +	pscsi_plugin_task_t *pt,
> +	pscsi_dev_virt_t *pdv)
> +{
> +	se_cmd_t *cmd = TASK_CMD(task);
> +	void *pscsi_buf = (task->task_sg_num != 0) ? task->task_sg :
> +			T_TASK(cmd)->t_task_buf;
> +	int ret;
> +
> +	ret = scsi_execute_async(pdv->pdv_sd, pt->pscsi_cdb,
> +			COMMAND_SIZE(pt->pscsi_cdb[0]), pt->pscsi_direction,
> +			pscsi_buf, task->task_size, task->task_sg_num,
> +			(pdv->pdv_sd->type == TYPE_DISK) ? PS_TIMEOUT_DISK :
> +			PS_TIMEOUT_OTHER, PS_RETRY, (void *)task,
> +			pscsi_req_done_legacy, GFP_KERNEL);
> +	if (ret != 0) {
> +		printk(KERN_ERR "PSCSI Execute(): returned: %d\n", ret);
> +		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	}
> +
> +	return 0;
> +}
> +
>  /*      pscsi_do_task(): (Part of se_subsystem_api_t template)
>   *
>   *
> @@ -852,6 +880,9 @@ int pscsi_do_task(se_task_t *task)
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
>  	struct gendisk *gd = NULL;
> +
> +	if (pdv->pdv_legacy)
> +		return pscsi_do_task_legacy(task, pt, pdv);
>  	/*
>  	 * Grab pointer to struct gendisk for TYPE_DISK and TYPE_ROM
>  	 * cases (eg: cases where struct scsi_device has a backing
> @@ -1104,6 +1135,7 @@ se_device_t *pscsi_create_virtdevice_from_fd(
>  		 * Keep track of the struct block_device for now..
>  		 */
>  		pdv->pdv_bd = bd;
> +		pdv->pdv_legacy = 0;
>  		/*
>  		 * pscsi_create_type_[disk,rom]() will release host_lock..
>  		 */
> @@ -1286,6 +1318,9 @@ int pscsi_map_task_SG(se_task_t *task)
>  			PAGE_SIZE - 1) >> PAGE_SHIFT;
>  	int nr_vecs = 0, ret = 0;
>  
> +	if (pdv->pdv_legacy)
> +		return 0;
> +
>  	if (!task->task_size)
>  		return 0;
>  	/*
> @@ -1387,6 +1422,9 @@ int pscsi_map_task_non_SG(se_task_t *task)
>  	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
>  	int ret = 0;
>  
> +	if (pdv->pdv_legacy)
> +		return 0;
> +
>  	if (!task->task_size)
>  		return 0;
>  
> @@ -1407,8 +1445,12 @@ int pscsi_map_task_non_SG(se_task_t *task)
>  int pscsi_CDB_inquiry(se_task_t *task, u32 size)
>  {
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
>  
>  	pt->pscsi_direction = DMA_FROM_DEVICE;
> +	if (pdv->pdv_legacy)
> +		return pscsi_map_task_non_SG(task);
> +
>  	if (pscsi_blk_get_request(task) < 0)
>  		return -1;
>  
> @@ -1418,10 +1460,11 @@ int pscsi_CDB_inquiry(se_task_t *task, u32 size)
>  int pscsi_CDB_none(se_task_t *task, u32 size)
>  {
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
>  
>  	pt->pscsi_direction = DMA_NONE;
>  
> -	return pscsi_blk_get_request(task);
> +	return (pdv->pdv_legacy) ? 0 : pscsi_blk_get_request(task);
>  }
>  
>  /*	pscsi_CDB_read_non_SG():
> @@ -1431,8 +1474,11 @@ int pscsi_CDB_none(se_task_t *task, u32 size)
>  int pscsi_CDB_read_non_SG(se_task_t *task, u32 size)
>  {
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
>  
>  	pt->pscsi_direction = DMA_FROM_DEVICE;
> +	if (pdv->pdv_legacy)
> +		return pscsi_map_task_non_SG(task);
>  
>  	if (pscsi_blk_get_request(task) < 0)
>  		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> @@ -1447,11 +1493,13 @@ int pscsi_CDB_read_non_SG(se_task_t *task, u32 size)
>  int pscsi_CDB_read_SG(se_task_t *task, u32 size)
>  {
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
>  
>  	pt->pscsi_direction = DMA_FROM_DEVICE;
>  
> -	if (pscsi_blk_get_request(task) < 0)
> -		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	if (!(pdv->pdv_legacy))
> +		if (pscsi_blk_get_request(task) < 0)
> +			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  
>  	if (pscsi_map_task_SG(task) < 0)
>  		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> @@ -1466,11 +1514,13 @@ int pscsi_CDB_read_SG(se_task_t *task, u32 size)
>  int pscsi_CDB_write_non_SG(se_task_t *task, u32 size)
>  {
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
>  
>  	pt->pscsi_direction = DMA_TO_DEVICE;
>  
> -	if (pscsi_blk_get_request(task) < 0)
> -		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	if (!(pdv->pdv_legacy))
> +		if (pscsi_blk_get_request(task) < 0)
> +			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  
>  	return pscsi_map_task_non_SG(task);
>  }
> @@ -1482,11 +1532,13 @@ int pscsi_CDB_write_non_SG(se_task_t *task, u32 size)
>  int pscsi_CDB_write_SG(se_task_t *task, u32 size)
>  {
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->se_dev->dev_ptr;
>  
>  	pt->pscsi_direction = DMA_TO_DEVICE;
>  
> -	if (pscsi_blk_get_request(task) < 0)
> -		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	if (!(pdv->pdv_legacy))
> +		if (pscsi_blk_get_request(task) < 0)
> +			return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  
>  	if (pscsi_map_task_SG(task) < 0)
>  		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> @@ -1643,6 +1695,20 @@ static inline void pscsi_process_SAM_status(
>  	return;
>  }
>  
> +void pscsi_req_done_legacy(void *data, char *sense, int result, int data_len)
> +{
> +	se_task_t *task = (se_task_t *)data;
> +	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *)task->transport_req;
> +
> +	pt->pscsi_result = result;
> +	pt->pscsi_resid = data_len;
> +
> +	if (result != 0)
> +		memcpy(pt->pscsi_sense, sense, SCSI_SENSE_BUFFERSIZE);	
> +
> +	pscsi_process_SAM_status(task, pt);
> +}
> +
>  void pscsi_req_done(struct request *req, int uptodate)
>  {
>  	se_task_t *task = (se_task_t *)req->end_io_data;
> diff --git a/include/target/target_core_pscsi.h b/include/target/target_core_pscsi.h
> index b05b793..0e1d6cf 100644
> --- a/include/target/target_core_pscsi.h
> +++ b/include/target/target_core_pscsi.h
> @@ -94,6 +94,7 @@ extern u32 pscsi_get_dma_length(u32, se_device_t *);
>  extern u32 pscsi_get_max_sectors(se_device_t *);
>  extern u32 pscsi_get_queue_depth(se_device_t *);
>  extern void pscsi_shutdown_hba(struct se_hba_s *);
> +extern void pscsi_req_done_legacy(void *, char *, int, int);
>  extern void pscsi_req_done(struct request *, int);
>  #endif
>  
> @@ -120,6 +121,7 @@ typedef struct pscsi_plugin_task_s {
>  
>  typedef struct pscsi_dev_virt_s {
>  	int	pdv_flags;
> +	int	pdv_legacy; /* Use scsi_execute_async() from HTCL */
>  	int	pdv_channel_id;
>  	int	pdv_target_id;
>  	int	pdv_lun_id;

