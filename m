From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [Target_Core_Mod/PSCSI]: Use struct request to struct
 scsi_device->request_queue
Date: Wed, 03 Dec 2008 12:42:17 +0200
Message-ID: <49366289.2010500@panasas.com>
References: <1228265348.6229.130.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:5386 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYLCKmZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2008 05:42:25 -0500
Received: by ug-out-1314.google.com with SMTP id 39so3350995ugf.37
        for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2008 02:42:22 -0800 (PST)
In-Reply-To: <1228265348.6229.130.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Nicholas A. Bellinger wrote:
>>From 1b14b5e1fc9a7074322b1015bb86eca2a8ef4560 Mon Sep 17 00:00:00 2001
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> Date: Tue, 2 Dec 2008 16:30:51 -0800
> Subject: [PATCH] [Target_Core_Mod/PSCSI]: Use struct request to struct scsi_device->request_queue
> 
> This patch begins to remove the usage of scsi_execute_async() from the PSCSI
> subsystem plugin for v3.0 generic target core.
> 
> It uses blk_get_request() to allocate struct request in pscsi_blk_get_request()
> and used by all CDB types and both memory backing types.  struct request is then
> released with __blk_put_request() in the struct request->end_io() context in
> pscsi_req_done().
> 
> Also, this patch adds a temporary EXPORT_SYMBOL_GPL() for
> scsi/drivers/scsi_lib.c:scsi_req_map_sg() (which will also be going away at
> some point).  At that point, the upstream struct scatterlist and/or
> struct page -> struct request mapping for usage with struct scsi_device->request_queue
> will be dropped into place in drivers/lio-core/target_core_pscsi.c:pscsi_map_task_SG()
> 
> Tested on v2.6.28-rc7 32-bit x86 with virtual VMware TYPE_DISK on virtual MPT-Fusion
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/lio-core/target_core_pscsi.c |  206 +++++++++++++++++++++++++---------
>  drivers/lio-core/target_core_pscsi.h |    5 +-
>  drivers/scsi/scsi_lib.c              |    6 +-
>  3 files changed, 161 insertions(+), 56 deletions(-)
> 

This patch confuses me. Is this the same one posted few days ago minus the double-free
bug? It would be nice if you said that somewhere. Like [PATCH ver2] ...

But what confuses me are the previous two patches you sent that makes this patch not
compile. (Rename of se_task_t->task_buf => se_task_t->task_sg).

The previous two patches are not bisectable btw. Numbering a patchset could maybe help
a little, but will not help here, whichever way you order them they will only compile at
the very end (Well not even that, not with this one applied).

Sorry but I'm unable to farther review any of the patches. Please re-post everything
as a patchset so I can understand whats going on.

(And please give the URL of the git tree they are based on in each [PATCH 00/xx] mail.
Usually one states what the patchset is based on, eg. "based on scsi-misc as of ..."
but we all know where scsi-misc is)

Thanks
Boaz

> diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
> index ed9f588..bb46e1c 100644
> --- a/drivers/lio-core/target_core_pscsi.c
> +++ b/drivers/lio-core/target_core_pscsi.c
> @@ -37,6 +37,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/smp_lock.h>
>  #include <linux/genhd.h>
> +#include <linux/cdrom.h>
>  #include <linux/file.h>
>  
>  #include <scsi/scsi.h>
> @@ -44,6 +45,7 @@
>  #include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_host.h>
>  #include <sd.h>
> +#include <sr.h>
>  
>  #include <iscsi_linux_os.h>
>  #include <iscsi_linux_defs.h>
> @@ -763,11 +765,11 @@ extern void *pscsi_allocate_request (
>  	se_device_t *dev)
>  {
>  	pscsi_plugin_task_t *pt;
> -	if (!(pt = kmalloc(sizeof(pscsi_plugin_task_t), GFP_KERNEL))) {
> -		TRACE_ERROR("Unable to allocate pscsi_plugin_task_t\n");
> +	
> +	if (!(pt = kzalloc(sizeof(pscsi_plugin_task_t), GFP_KERNEL))) {
> +		printk(KERN_ERR "Unable to allocate pscsi_plugin_task_t\n");
>  		return(NULL);
>  	}
> -	memset(pt, 0, sizeof(pscsi_plugin_task_t));
>  
>  	return(pt);
>  }
> @@ -788,7 +790,44 @@ extern void pscsi_get_evpd_sn (unsigned char *buf, u32 size, se_device_t *dev)
>  	return;
>  }
>  
> -/*	pscsi_do_task(): (Part of se_subsystem_api_t template)
> +static int pscsi_blk_get_request (se_task_t *task)
> +{
> +	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
> +
> +	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
> +			(pt->pscsi_direction == DMA_TO_DEVICE), GFP_KERNEL);
> +	if (!(pt->pscsi_req) || IS_ERR(pt->pscsi_req)) {
> +		printk(KERN_ERR "PSCSI: blk_get_request() failed: %ld\n",
> +				IS_ERR(pt->pscsi_req));
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +	}
> +	/*
> +	 * Defined as "scsi command" in include/linux/blkdev.h.
> +	 */
> +	pt->pscsi_req->cmd_type = REQ_TYPE_BLOCK_PC;
> +	/*
> +	 * Setup the done function pointer for struct request,
> +	 * also set the end_io_data pointer.to se_task_t.
> +	 */
> +	pt->pscsi_req->end_io = pscsi_req_done;
> +	pt->pscsi_req->end_io_data = (void *)task;
> +	/*
> +	 * Load the referenced se_task_t's SCSI CDB into
> +	 * include/linux/blkdev.h:struct request->cmd
> +	 */
> +	pt->pscsi_req->cmd_len = COMMAND_SIZE(pt->pscsi_cdb[0]);
> +	memcpy(pt->pscsi_req->cmd, pt->pscsi_cdb, pt->pscsi_req->cmd_len);
> +	/*
> +	 * Setup pointer for outgoing sense data.
> +	 */
> +	pt->pscsi_req->sense = (void *)&pt->pscsi_sense[0];
> +	pt->pscsi_req->sense_len = 0;
> +
> +	return(0);
> +}
> +
> +/*      pscsi_do_task(): (Part of se_subsystem_api_t template)
>   *
>   *
>   */
> @@ -796,17 +835,32 @@ extern int pscsi_do_task (se_task_t *task)
>  {
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
> -	int ret;
> -	
> -	if ((ret = scsi_execute_async((struct scsi_device *)pdv->pdv_sd,
> -			   pt->pscsi_cdb, COMMAND_SIZE(pt->pscsi_cdb[0]), pt->pscsi_direction,
> -			   pt->pscsi_buf, task->task_size, task->task_sg_num,
> -			   (task->se_obj_api->get_device_type(task->se_obj_ptr) == 0) ?
> -			   PS_TIMEOUT_DISK : PS_TIMEOUT_OTHER, PS_RETRY,
> -			   (void *)task, pscsi_req_done, GFP_KERNEL)) != 0) {
> -		TRACE_ERROR("PSCSI Execute(): returned: %d\n", ret);
> -		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> -	}	
> +	struct gendisk *gd = NULL;
> +	/*
> +	 * Grab pointer to struct gendisk for TYPE_DISK and TYPE_ROM
> +	 * cases (eg: cases where struct scsi_device has a backing
> +	 * struct block_device.  Also set the struct request->timeout
> +	 * value based on peripheral device type (from SCSI).
> +	 */
> +	if (pdv->pdv_sd->type == TYPE_DISK) {
> +		struct scsi_disk *sdisk = dev_get_drvdata(
> +					&pdv->pdv_sd->sdev_gendev);
> +		gd = sdisk->disk;
> +		pt->pscsi_req->timeout = PS_TIMEOUT_DISK;
> +	} else if (pdv->pdv_sd->type == TYPE_ROM) {
> +		struct scsi_cd *scd = dev_get_drvdata(
> +					&pdv->pdv_sd->sdev_gendev);
> +		gd = scd->disk;
> +		pt->pscsi_req->timeout = PS_TIMEOUT_OTHER;
> +	} else
> +		pt->pscsi_req->timeout = PS_TIMEOUT_OTHER;
> +
> +	pt->pscsi_req->retries = PS_RETRY;
> +	/*
> +	 * Queue the struct request into the struct scsi_device->request_queue.
> +	 */
> +	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, gd,
> +			      pt->pscsi_req, 1, pscsi_req_done);
>  
>  	return(PYX_TRANSPORT_SENT_TO_TRANSPORT);
>  }
> @@ -817,7 +871,8 @@ extern int pscsi_do_task (se_task_t *task)
>   */
>  extern void pscsi_free_task (se_task_t *task)
>  {
> -	kfree(task->transport_req);
> +	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	kfree(pt);
>  	return;
>  }
>  
> @@ -1099,31 +1154,64 @@ extern void __pscsi_get_dev_info (pscsi_dev_virt_t *pdv, char *b, int *bl)
>  	return;
>  }
>  
> -/*	pscsi_map_task_SG(): 
> +extern int scsi_req_map_sg(struct request *, struct scatterlist *, int,  unsigned , gfp_t );
> +
> +/*      pscsi_map_task_SG(): 
>   *
>   *
>   */
> -extern void pscsi_map_task_SG (se_task_t *task)
> +extern int pscsi_map_task_SG (se_task_t *task)
>  {
>          pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> +	int ret = 0;
> +
>  	pt->pscsi_buf = (void *)task->task_buf;
>  
> -	return;
> +	if (!task->task_size)
> +		return(0);
> +#if 0
> +	if ((ret = blk_rq_map_sg(pdv->pdv_sd->request_queue,
> +			pt->pscsi_req,
> +			(struct scatterlist *)pt->pscsi_buf)) < 0) {
> +		printk(KERN_ERR "PSCSI: blk_rq_map_sg() returned %d\n", ret);
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +	}
> +#else
> +	if ((ret = scsi_req_map_sg(pt->pscsi_req,
> +			(struct scatterlist *)pt->pscsi_buf,
> +			task->task_sg_num, task->task_size,
> +			GFP_KERNEL)) < 0) {
> +		printk(KERN_ERR "PSCSI: scsi_req_map_sg() failed: %d\n", ret);
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +	}
> +#endif
> +	return(0);
>  }
>  
>  /*	pscsi_map_task_non_SG():
>   *
>   *
>   */
> -extern void pscsi_map_task_non_SG (se_task_t *task)
> +extern int pscsi_map_task_non_SG (se_task_t *task)
>  {
>  	iscsi_cmd_t *cmd = task->iscsi_cmd;
> +	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
> +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
> +	int ret = 0;
>  
> -	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  	pt->pscsi_buf = (void *)buf;
>  
> -	return;
> +	if (!task->task_size)
> +		return(0);
> +
> +	if ((ret = blk_rq_map_kern(pdv->pdv_sd->request_queue,
> +			pt->pscsi_req, pt->pscsi_buf,
> +			task->task_size, GFP_KERNEL)) < 0) {
> +		printk(KERN_ERR "PSCSI: blk_rq_map_kern() failed: %d\n", ret);
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +	}
> +	return(0);
>  }
>  
>  /*	pscsi_CDB_inquiry():
> @@ -1135,9 +1223,10 @@ extern int pscsi_CDB_inquiry (se_task_t *task, u32 size)
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  
>  	pt->pscsi_direction = DMA_FROM_DEVICE;
> -	pscsi_map_task_non_SG(task);
> +	if (pscsi_blk_get_request(task) < 0)
> +		return(-1);
>  
> -	return(0);
> +	return(pscsi_map_task_non_SG(task));
>  }
>  
>  extern int pscsi_CDB_none (se_task_t *task, u32 size)
> @@ -1146,7 +1235,7 @@ extern int pscsi_CDB_none (se_task_t *task, u32 size)
>  
>  	pt->pscsi_direction = DMA_NONE;
>  
> -	return(0);
> +	return(pscsi_blk_get_request(task));
>  }
>  
>  /*	pscsi_CDB_read_non_SG():
> @@ -1158,9 +1247,11 @@ extern int pscsi_CDB_read_non_SG (se_task_t *task, u32 size)
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  
>  	pt->pscsi_direction = DMA_FROM_DEVICE;
> -	pscsi_map_task_non_SG(task);
>  
> -	return(0);
> +	if (pscsi_blk_get_request(task) < 0)
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +
> +	return(pscsi_map_task_non_SG(task));
>  }
>  
>  /*	pscsi_CDB_read_SG():
> @@ -1172,7 +1263,12 @@ extern int pscsi_CDB_read_SG (se_task_t *task, u32 size)
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  
>  	pt->pscsi_direction = DMA_FROM_DEVICE;
> -	pscsi_map_task_SG(task);
> +
> +	if (pscsi_blk_get_request(task) < 0)
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +
> +	if (pscsi_map_task_SG(task) < 0)
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
>  
>  	return(task->task_sg_num);
>  }
> @@ -1186,9 +1282,11 @@ extern int pscsi_CDB_write_non_SG (se_task_t *task, u32 size)
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  
>  	pt->pscsi_direction = DMA_TO_DEVICE;
> -	pscsi_map_task_non_SG(task);
>  
> -	return(0);
> +	if (pscsi_blk_get_request(task) < 0)
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +
> +	return(pscsi_map_task_non_SG(task));
>  }
>  
>  /*	pscsi_CDB_write_SG():
> @@ -1200,7 +1298,12 @@ extern int pscsi_CDB_write_SG (se_task_t *task, u32 size)
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
>  
>  	pt->pscsi_direction = DMA_TO_DEVICE;
> -	pscsi_map_task_SG(task);
> +
> +	if (pscsi_blk_get_request(task) < 0)
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> +
> +	if (pscsi_map_task_SG(task) < 0)
> +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
>  	
>  	return(task->task_sg_num);
>  }
> @@ -1386,22 +1489,25 @@ extern void pscsi_shutdown_hba (se_hba_t *hba)
>   *
>   *
>   */
> -//#warning FIXME: We can do some custom handling of HBA fuckups here.
> -extern inline void pscsi_process_SAM_status (se_task_t *task, unsigned char *cdb, int result)
> +static inline void pscsi_process_SAM_status (
> +	se_task_t *task,
> +	pscsi_plugin_task_t *pt)
>  {
> -	if ((task->task_scsi_status = status_byte(result))) {
> +	if ((task->task_scsi_status = status_byte(pt->pscsi_result))) {
>  		task->task_scsi_status <<= 1;
> -		PYXPRINT("Parallel SCSI Status Byte exception - ITT: 0x%08x Task: %p CDB: 0x%02x"
> -			" Result: 0x%08x\n", task->iscsi_cmd->init_task_tag, task, cdb[0], result);
> +		PYXPRINT("PSCSI Status Byte exception at task: %p CDB: 0x%02x"
> +			" Result: 0x%08x\n", task, pt->pscsi_cdb[0],
> +			pt->pscsi_result);
>  	}
>  
> -	switch (host_byte(result)) {
> +	switch (host_byte(pt->pscsi_result)) {
>  	case DID_OK:
>  		transport_complete_task(task, (!task->task_scsi_status));
>  		break;
>  	default:
> -		PYXPRINT("Parallel SCSI Host Byte exception - ITT: 0x%08x Task: %p CDB: 0x%02x"
> -			" Result: 0x%08x\n", task->iscsi_cmd->init_task_tag, task, cdb[0], result);
> +		PYXPRINT("PSCSI Host Byte exception at task: %p CDB: 0x%02x"
> +			" Result: 0x%08x\n", task, pt->pscsi_cdb[0],
> +			pt->pscsi_result);
>  		task->task_scsi_status = SAM_STAT_CHECK_CONDITION;
>  		task->task_error_status = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
>  		task->iscsi_cmd->transport_error_status = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
> @@ -1412,21 +1518,17 @@ extern inline void pscsi_process_SAM_status (se_task_t *task, unsigned char *cdb
>  	return;
>  }
>  
> -extern void pscsi_req_done (void *data, char *sense, int result, int data_len)
> +extern void pscsi_req_done (struct request *req, int uptodate)
>  {
> -	se_task_t *task = (se_task_t *)data;
> +	se_task_t *task = (se_task_t *)req->end_io_data;	
>  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *)task->transport_req;
> -#if 0
> -	printk("pscsi_req_done(): result: %08x, sense: %p data_len: %d\n",
> -			result, sense, data_len);
> -#endif	
> -	pt->pscsi_result = result;
> -	pt->pscsi_data_len = data_len;
> -
> -	if (result != 0)
> -		memcpy(pt->pscsi_sense, sense, SCSI_SENSE_BUFFERSIZE);
> +
> +	pt->pscsi_result = req->errors;
> +	pt->pscsi_resid = req->data_len;
>  	
> -	pscsi_process_SAM_status(task, &pt->pscsi_cdb[0], result);
> +	pscsi_process_SAM_status(task, pt);
> +	__blk_put_request(req->q, req);
> +	pt->pscsi_req = NULL;
> +
>  	return;
>  }
> -
> diff --git a/drivers/lio-core/target_core_pscsi.h b/drivers/lio-core/target_core_pscsi.h
> index 980587d..090f0d2 100644
> --- a/drivers/lio-core/target_core_pscsi.h
> +++ b/drivers/lio-core/target_core_pscsi.h
> @@ -90,7 +90,7 @@ extern struct scatterlist *pscsi_get_SG (se_task_t *);
>  extern u32 pscsi_get_SG_count (se_task_t *);
>  extern int pscsi_set_non_SG_buf (unsigned char *, se_task_t *);
>  extern void pscsi_shutdown_hba (struct se_hba_s *);
> -extern void pscsi_req_done (void *, char *, int, int);
> +extern void pscsi_req_done (struct request *, int);
>  #endif
>  
>  #include <linux/device.h>
> @@ -104,8 +104,9 @@ typedef struct pscsi_plugin_task_s {
>  	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
>  	int	pscsi_direction;
>  	int	pscsi_result;
> -	u32	pscsi_data_len;
> +	u32	pscsi_resid;
>  	void	*pscsi_buf;
> +	struct request *pscsi_req;
>  } pscsi_plugin_task_t;
>  
>  #define PDF_HAS_CHANNEL_ID	0x01
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f5d3b96..9e03a02 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -303,8 +303,8 @@ static void scsi_bi_endio(struct bio *bio, int error)
>   * request can be sent to the block layer. We do not trust the scatterlist
>   * sent to use, as some ULDs use that struct to only organize the pages.
>   */
> -static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
> -			   int nsegs, unsigned bufflen, gfp_t gfp)
> +int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
> +		    int nsegs, unsigned bufflen, gfp_t gfp)
>  {
>  	struct request_queue *q = rq->q;
>  	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
> @@ -379,6 +379,8 @@ free_bios:
>  	return err;
>  }
>  
> +EXPORT_SYMBOL_GPL(scsi_req_map_sg);
> +
>  /**
>   * scsi_execute_async - insert request
>   * @sdev:	scsi device

