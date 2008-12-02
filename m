From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Changes to Linux/SCSI target mode infrastructure for v2.6.28
Date: Tue, 02 Dec 2008 02:34:37 -0800
Message-ID: <1228214077.6229.89.camel@haakon2.linux-iscsi.org>
References: <1228182727.13241.160.camel@haakon2.linux-iscsi.org>
	 <4934F441.8050606@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:31745 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752812AbYLBKek (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 05:34:40 -0500
In-Reply-To: <4934F441.8050606@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Hannes Reinecke <hare@suse.de>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>

On Tue, 2008-12-02 at 10:39 +0200, Boaz Harrosh wrote:
> Nicholas A. Bellinger wrote:
> > Greetings Tomo-san and Co,
> > 
> > With the ongoing work in Linux/SCSI for v2.6.28 to map target mode
> > struct scatterlist memory directly down to struct scsi_cmnd without the
> > need for a intermediate struct bio as with the existing
> > scsi_execute_async(), I have started the porting process for the
> > Linux/SCSI subsystem plugin in generic target core v3.0
> > (lio-core-2.6.git) on v2.6.28-rc6.
> > 
> > So far, using struct request for ICF_SCSI_CONTROL_NONSG_IO_CDB is up
> > using blk_rq_map_kern(), as well as ICF_SCSI_NON_DATA_CDB ops using
> > struct request.  In order to get the first READ_10s of type
> > ICF_SCSI_DATA_SG_IO_CDB to work, I had to add a temporary
> > EXPORT_SYMBOL_GPL() for drivers/scsi/scsi_lib.c:scsi_req_map_sg() in
> > lio-core-2.6.git for v2.6.28-rc6 in order to get TYPE_DISK up using an
> > software emulated MPT-Fusion HBA driver with struct request.  I have
> > been looking at drivers/scsi/scsi_tgt_lib.c() (which currently uses
> > struct request), and I figure we need something similar for the generic
> > target infrastructure, although __scsi_get_command() and
> > __scsi_put_command() are currently used in that code.
> > 
> > Below is what my patch looks like so far, I will probably just end up
> > commiting an temporary ifdef to keep scsi_execute_async() until the
> > proper pieces are in place and the other issues are resolved below.
> >>From there I will be able to drop in the proper upstream mapping bits
> > for struct scatterlist in
> > drivers/lio-core/target_core_pscsi.c:pscsi_map_task_SG() get rid of
> > scsi_req_map_sg() usage all together.
> > 
> > So far during my initial testing, I am running into a two different
> > exceptions.  One NULL pointer deference OOPS after half dozen Open/iSCSI
> > login/logouts in block/elevator.c:elv_dequeue_request().   Here is the
> > trace from SCSI softirq context:
> > 
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-0.png
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-1.png
> > 
> > The other one is a BUG_ON in blk/blk-timeout.c:177 in blk_add_timeout()
> > that happens after a few hundred MB of READ_10 traffic, which also
> > appears to pass through elv_dequeue_request() at some point:
> > 
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-2.png
> > http://linux-iscsi.org/builds/user/nab/2.6.28-rc6-oops-4.png
> > 
> > Tomo, Boaz, Jens, any comments..?
> > 
> > --nab
> > 
> > diff --git a/drivers/lio-core/target_core_pscsi.c b/drivers/lio-core/target_core_pscsi.c
> > index ed9f588..5161483 100644
> > --- a/drivers/lio-core/target_core_pscsi.c
> > +++ b/drivers/lio-core/target_core_pscsi.c
> > @@ -37,6 +37,7 @@
> >  #include <linux/spinlock.h>
> >  #include <linux/smp_lock.h>
> >  #include <linux/genhd.h>
> > +#include <linux/cdrom.h>
> >  #include <linux/file.h>
> >  
> >  #include <scsi/scsi.h>
> > @@ -44,6 +45,7 @@
> >  #include <scsi/scsi_cmnd.h>
> >  #include <scsi/scsi_host.h>
> >  #include <sd.h>
> > +#include <sr.h>
> >  
> >  #include <iscsi_linux_os.h>
> >  #include <iscsi_linux_defs.h>
> > @@ -763,11 +765,11 @@ extern void *pscsi_allocate_request (
> >  	se_device_t *dev)
> >  {
> >  	pscsi_plugin_task_t *pt;
> > -	if (!(pt = kmalloc(sizeof(pscsi_plugin_task_t), GFP_KERNEL))) {
> > -		TRACE_ERROR("Unable to allocate pscsi_plugin_task_t\n");
> > +	
> > +	if (!(pt = kzalloc(sizeof(pscsi_plugin_task_t), GFP_KERNEL))) {
> > +		printk(KERN_ERR "Unable to allocate pscsi_plugin_task_t\n");
> >  		return(NULL);
> >  	}
> > -	memset(pt, 0, sizeof(pscsi_plugin_task_t));
> >  
> >  	return(pt);
> >  }
> > @@ -788,7 +790,44 @@ extern void pscsi_get_evpd_sn (unsigned char *buf, u32 size, se_device_t *dev)
> >  	return;
> >  }
> >  
> > -/*	pscsi_do_task(): (Part of se_subsystem_api_t template)
> > +static int pscsi_blk_get_request (se_task_t *task)
> > +{
> > +	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> > +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
> > +
> > +	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
> > +			(pt->pscsi_direction == DMA_TO_DEVICE), GFP_KERNEL);
> > +	if (!(pt->pscsi_req) || IS_ERR(pt->pscsi_req)) {
> > +		printk(KERN_ERR "PSCSI: blk_get_request() failed: %ld\n",
> > +				IS_ERR(pt->pscsi_req));
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > +	}
> > +	/*
> > +	 * Defined as "scsi command" in include/linux/blkdev.h.
> > +	 */
> > +	pt->pscsi_req->cmd_type = REQ_TYPE_BLOCK_PC;
> > +	/*
> > +	 * Setup the done function pointer for struct request,
> > +	 * also set the end_io_data pointer.to se_task_t.
> > +	 */
> > +	pt->pscsi_req->end_io = pscsi_req_done;
> > +	pt->pscsi_req->end_io_data = (void *)task;
> > +	/*
> > +	 * Load the referenced se_task_t's SCSI CDB into
> > +	 * include/linux/blkdev.h:struct request->cmd
> > +	 */
> > +	pt->pscsi_req->cmd_len = COMMAND_SIZE(pt->pscsi_cdb[0]);
> > +	memcpy(pt->pscsi_req->cmd, pt->pscsi_cdb, pt->pscsi_req->cmd_len);
> 
> pt->pscsi_cdb is that a static sized buffer? What do you do with larger
> commands received on the iscsi wire. Are they dropped? 

Support for this is on the short-term TODO list for v3.0 in the generic
target engine..

> If you did have
> the full > 16 CDB in some buffer you could do:
> 
> +	pt->pscsi_req->cmd_len = scsi_command_size(pt->pscsi_cdb);
> +	pt->pscsi_req->cmd = pt->pscsi_cdb;
> 

<nod>, the plan is to remove pt->pscsi_cdb[] and use the struct
request->_cmd[] through the subsystem plugin API for the v3.0 generic
target core in lio-core-2.6.git..

> > +	/*
> > +	 * Setup pointer for outgoing sense data.
> > +	 */
> > +	pt->pscsi_req->sense = (void *)&pt->pscsi_sense[0];
> > +	pt->pscsi_req->sense_len = 0;
> > +
> > +	return(0);
> > +}
> > +
> > +/*      pscsi_do_task(): (Part of se_subsystem_api_t template)
> >   *
> >   *
> >   */
> > @@ -796,17 +835,32 @@ extern int pscsi_do_task (se_task_t *task)
> >  {
> >  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> >  	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
> > -	int ret;
> > -	
> > -	if ((ret = scsi_execute_async((struct scsi_device *)pdv->pdv_sd,
> > -			   pt->pscsi_cdb, COMMAND_SIZE(pt->pscsi_cdb[0]), pt->pscsi_direction,
> > -			   pt->pscsi_buf, task->task_size, task->task_sg_num,
> > -			   (task->se_obj_api->get_device_type(task->se_obj_ptr) == 0) ?
> > -			   PS_TIMEOUT_DISK : PS_TIMEOUT_OTHER, PS_RETRY,
> > -			   (void *)task, pscsi_req_done, GFP_KERNEL)) != 0) {
> > -		TRACE_ERROR("PSCSI Execute(): returned: %d\n", ret);
> > -		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > -	}	
> > +	struct gendisk *gd = NULL;
> > +	/*
> > +	 * Grab pointer to struct gendisk for TYPE_DISK and TYPE_ROM
> > +	 * cases (eg: cases where struct scsi_device has a backing
> > +	 * struct block_device.  Also set the struct request->timeout
> > +	 * value based on peripheral device type (from SCSI).
> > +	 */
> > +	if (pdv->pdv_sd->type == TYPE_DISK) {
> > +		struct scsi_disk *sdisk = dev_get_drvdata(
> > +					&pdv->pdv_sd->sdev_gendev);
> > +		gd = sdisk->disk;
> > +		pt->pscsi_req->timeout = PS_TIMEOUT_DISK;
> > +	} else if (pdv->pdv_sd->type == TYPE_ROM) {
> > +		struct scsi_cd *scd = dev_get_drvdata(
> > +					&pdv->pdv_sd->sdev_gendev);
> > +		gd = scd->disk;
> > +		pt->pscsi_req->timeout = PS_TIMEOUT_OTHER;
> > +	} else
> > +		pt->pscsi_req->timeout = PS_TIMEOUT_OTHER;
> > +
> > +	pt->pscsi_req->retries = PS_RETRY;
> > +	/*
> > +	 * Queue the struct request into the struct scsi_device->request_queue.
> > +	 */
> > +	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, gd,
> > +			      pt->pscsi_req, 1, pscsi_req_done);
> >  
> >  	return(PYX_TRANSPORT_SENT_TO_TRANSPORT);
> >  }
> > @@ -817,7 +871,14 @@ extern int pscsi_do_task (se_task_t *task)
> >   */
> >  extern void pscsi_free_task (se_task_t *task)
> >  {
> > -	kfree(task->transport_req);
> > +	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> > +
> > +	if (pt->pscsi_req) {
> > +		blk_put_request(pt->pscsi_req);	
> > +		pt->pscsi_req = NULL;
> > +	}
> > +
> > +	kfree(pt);
> >  	return;
> >  }
> >  
> > @@ -1099,31 +1160,65 @@ extern void __pscsi_get_dev_info (pscsi_dev_virt_t *pdv, char *b, int *bl)
> >  	return;
> >  }
> >  
> > -/*	pscsi_map_task_SG(): 
> > +extern int scsi_req_map_sg(struct request *, struct scatterlist *, int,  unsigned , gfp_t );
> > +
> > +/*      pscsi_map_task_SG(): 
> >   *
> >   *
> >   */
> > -extern void pscsi_map_task_SG (se_task_t *task)
> > +extern int pscsi_map_task_SG (se_task_t *task)
> >  {
> >          pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> > +	int ret = 0;
> > +
> >  	pt->pscsi_buf = (void *)task->task_buf;
> >  
> > -	return;
> > +	if (!task->task_size)
> > +		return(0);
> > +#if 0
> > +	if ((ret = blk_rq_map_sg(pdv->pdv_sd->request_queue,
> > +			pt->pscsi_req,
> > +			(struct scatterlist *)pt->pscsi_buf)) < 0) {
> > +		printk(KERN_ERR "PSCSI: blk_rq_map_sg() returned %d\n", ret);
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > +	}
> > +#else
> > +	if ((ret = scsi_req_map_sg(pt->pscsi_req,
> > +			(struct scatterlist *)pt->pscsi_buf,
> > +			task->task_sg_num, task->task_size,
> > +			GFP_KERNEL)) < 0) {
> > +		printk(KERN_ERR "PSCSI: scsi_req_map_sg() failed: %d\n", ret);
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > +	}
> > +#endif
> > +	return(0);
> >  }
> >  
> >  /*	pscsi_map_task_non_SG():
> >   *
> >   *
> >   */
> > -extern void pscsi_map_task_non_SG (se_task_t *task)
> > +extern int pscsi_map_task_non_SG (se_task_t *task)
> >  {
> >  	iscsi_cmd_t *cmd = task->iscsi_cmd;
> > +	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> > +	pscsi_dev_virt_t *pdv = (pscsi_dev_virt_t *) task->iscsi_dev->dev_ptr;
> >  	unsigned char *buf = (unsigned char *) T_TASK(cmd)->t_task_buf;
> > +	int ret = 0;
> >  
> > -	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> >  	pt->pscsi_buf = (void *)buf;
> >  
> > -	return;
> > +	if (!task->task_size)
> > +		return(0);
> > +
> > +	if ((ret = blk_rq_map_kern(pdv->pdv_sd->request_queue,
> > +			pt->pscsi_req, pt->pscsi_buf,
> > +			task->task_size, GFP_KERNEL)) < 0) {
> > +		printk(KERN_ERR "PSCSI: blk_rq_map_kern() failed: %d\n", ret);
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > +	}
> > +
> > +	return(0);
> >  }
> >  
> >  /*	pscsi_CDB_inquiry():
> > @@ -1135,9 +1230,11 @@ extern int pscsi_CDB_inquiry (se_task_t *task, u32 size)
> >  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> >  
> >  	pt->pscsi_direction = DMA_FROM_DEVICE;
> > -	pscsi_map_task_non_SG(task);
> > +	
> > +	if (pscsi_blk_get_request(task) < 0)
> > +		return(-1);
> >  
> > -	return(0);
> > +	return(pscsi_map_task_non_SG(task));
> >  }
> >  
> >  extern int pscsi_CDB_none (se_task_t *task, u32 size)
> > @@ -1146,7 +1243,7 @@ extern int pscsi_CDB_none (se_task_t *task, u32 size)
> >  
> >  	pt->pscsi_direction = DMA_NONE;
> >  
> > -	return(0);
> > +	return(pscsi_blk_get_request(task));
> >  }
> >  
> >  /*	pscsi_CDB_read_non_SG():
> > @@ -1158,9 +1255,11 @@ extern int pscsi_CDB_read_non_SG (se_task_t *task, u32 size)
> >  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> >  
> >  	pt->pscsi_direction = DMA_FROM_DEVICE;
> > -	pscsi_map_task_non_SG(task);
> >  
> > -	return(0);
> > +	if (pscsi_blk_get_request(task) < 0)
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > +
> > +	return(pscsi_map_task_non_SG(task));
> >  }
> >  
> >  /*	pscsi_CDB_read_SG():
> > @@ -1172,7 +1271,12 @@ extern int pscsi_CDB_read_SG (se_task_t *task, u32 size)
> >  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> >  
> >  	pt->pscsi_direction = DMA_FROM_DEVICE;
> > -	pscsi_map_task_SG(task);
> > +
> > +	if (pscsi_blk_get_request(task) < 0)
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > +
> > +	if (pscsi_map_task_SG(task) < 0)
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> >  
> >  	return(task->task_sg_num);
> >  }
> > @@ -1186,9 +1290,11 @@ extern int pscsi_CDB_write_non_SG (se_task_t *task, u32 size)
> >  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> >  
> >  	pt->pscsi_direction = DMA_TO_DEVICE;
> > -	pscsi_map_task_non_SG(task);
> >  
> > -	return(0);
> > +	if (pscsi_blk_get_request(task) < 0)
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > +
> > +	return(pscsi_map_task_non_SG(task));
> >  }
> >  
> >  /*	pscsi_CDB_write_SG():
> > @@ -1200,7 +1306,12 @@ extern int pscsi_CDB_write_SG (se_task_t *task, u32 size)
> >  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
> >  
> >  	pt->pscsi_direction = DMA_TO_DEVICE;
> > -	pscsi_map_task_SG(task);
> > +
> > +	if (pscsi_blk_get_request(task) < 0)
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> > +
> > +	if (pscsi_map_task_SG(task) < 0)
> > +		return(PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE);
> >  	
> >  	return(task->task_sg_num);
> >  }
> > @@ -1386,22 +1497,25 @@ extern void pscsi_shutdown_hba (se_hba_t *hba)
> >   *
> >   *
> >   */
> > -//#warning FIXME: We can do some custom handling of HBA fuckups here.
> > -extern inline void pscsi_process_SAM_status (se_task_t *task, unsigned char *cdb, int result)
> > +static inline void pscsi_process_SAM_status (
> > +	se_task_t *task,
> > +	pscsi_plugin_task_t *pt)
> >  {
> > -	if ((task->task_scsi_status = status_byte(result))) {
> > +	if ((task->task_scsi_status = status_byte(pt->pscsi_result))) {
> >  		task->task_scsi_status <<= 1;
> > -		PYXPRINT("Parallel SCSI Status Byte exception - ITT: 0x%08x Task: %p CDB: 0x%02x"
> > -			" Result: 0x%08x\n", task->iscsi_cmd->init_task_tag, task, cdb[0], result);
> > +		PYXPRINT("PSCSI Status Byte exception at task: %p CDB: 0x%02x"
> > +			" Result: 0x%08x\n", task, pt->pscsi_cdb[0],
> > +			pt->pscsi_result);
> >  	}
> >  
> > -	switch (host_byte(result)) {
> > +	switch (host_byte(pt->pscsi_result)) {
> >  	case DID_OK:
> >  		transport_complete_task(task, (!task->task_scsi_status));
> >  		break;
> >  	default:
> > -		PYXPRINT("Parallel SCSI Host Byte exception - ITT: 0x%08x Task: %p CDB: 0x%02x"
> > -			" Result: 0x%08x\n", task->iscsi_cmd->init_task_tag, task, cdb[0], result);
> > +		PYXPRINT("PSCSI Host Byte exception at task: %p CDB: 0x%02x"
> > +			" Result: 0x%08x\n", task, pt->pscsi_cdb[0],
> > +			pt->pscsi_result);
> >  		task->task_scsi_status = SAM_STAT_CHECK_CONDITION;
> >  		task->task_error_status = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
> >  		task->iscsi_cmd->transport_error_status = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
> > @@ -1412,21 +1526,17 @@ extern inline void pscsi_process_SAM_status (se_task_t *task, unsigned char *cdb
> >  	return;
> >  }
> >  
> > -extern void pscsi_req_done (void *data, char *sense, int result, int data_len)
> > +extern void pscsi_req_done (struct request *req, int uptodate)
> >  {
> > -	se_task_t *task = (se_task_t *)data;
> > +	se_task_t *task = (se_task_t *)req->end_io_data;	
> >  	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *)task->transport_req;
> > -#if 0
> > -	printk("pscsi_req_done(): result: %08x, sense: %p data_len: %d\n",
> > -			result, sense, data_len);
> > -#endif	
> > -	pt->pscsi_result = result;
> > -	pt->pscsi_data_len = data_len;
> > -
> > -	if (result != 0)
> > -		memcpy(pt->pscsi_sense, sense, SCSI_SENSE_BUFFERSIZE);
> > +
> > +	pt->pscsi_result = req->errors;
> > +	pt->pscsi_resid = req->data_len;
> >  	
> > -	pscsi_process_SAM_status(task, &pt->pscsi_cdb[0], result);
> > +	pscsi_process_SAM_status(task, pt);
> > +
> > +	__blk_put_request(req->q, req);
> > +
> >  	return;
> >  }
> > -
> > diff --git a/drivers/lio-core/target_core_pscsi.h b/drivers/lio-core/target_core_pscsi.h
> > index 980587d..090f0d2 100644
> > --- a/drivers/lio-core/target_core_pscsi.h
> > +++ b/drivers/lio-core/target_core_pscsi.h
> > @@ -90,7 +90,7 @@ extern struct scatterlist *pscsi_get_SG (se_task_t *);
> >  extern u32 pscsi_get_SG_count (se_task_t *);
> >  extern int pscsi_set_non_SG_buf (unsigned char *, se_task_t *);
> >  extern void pscsi_shutdown_hba (struct se_hba_s *);
> > -extern void pscsi_req_done (void *, char *, int, int);
> > +extern void pscsi_req_done (struct request *, int);
> >  #endif
> >  
> >  #include <linux/device.h>
> > @@ -104,8 +104,9 @@ typedef struct pscsi_plugin_task_s {
> >  	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
> >  	int	pscsi_direction;
> >  	int	pscsi_result;
> > -	u32	pscsi_data_len;
> > +	u32	pscsi_resid;
> >  	void	*pscsi_buf;
> 
> -	void	*pscsi_buf;
> +	struct scatterlist kern_buff;
> +	struct scatterlist *pscsi_sg;
> 
> See comment bellow, you will need to change all that code,
> functions APIs the works
> 

<nod>, as the I/O becomes stable using struct request, the plan is to
remove all of the duplicated structure members in struct
pscsi_plugin_task_s, and most likely getting rid of the structure all
together..

> > +	struct request *pscsi_req;
> >  } pscsi_plugin_task_t;
> >  
> >  #define PDF_HAS_CHANNEL_ID	0x01
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index f5d3b96..9e03a02 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -303,8 +303,8 @@ static void scsi_bi_endio(struct bio *bio, int error)
> >   * request can be sent to the block layer. We do not trust the scatterlist
> >   * sent to use, as some ULDs use that struct to only organize the pages.
> >   */
> > -static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
> > -			   int nsegs, unsigned bufflen, gfp_t gfp)
> > +int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
> > +		    int nsegs, unsigned bufflen, gfp_t gfp)
> >  {
> >  	struct request_queue *q = rq->q;
> >  	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > @@ -379,6 +379,8 @@ free_bios:
> >  	return err;
> >  }
> >  
> > +EXPORT_SYMBOL_GPL(scsi_req_map_sg);
> > +
> 
> Hmmm this is going away from here soon I hope. Better copy past it into your
> own code. Perhaps optimize to your needs.
> 

The only reason I am using this (and hence using the BIOs behind it) is
because the upstream code for struct scatterlist -> struct request ->
struct scsi_device->request_queue via blk_execute_rq_nowait() ops does
not exist (yet :-)

> >  /**
> >   * scsi_execute_async - insert request
> >   * @sdev:	scsi device
> > 
> > 
> 
> Do you have this code on a gitweb somewhere. I'm to lazy to download everything
> here?
> 

The v3.0 tree is located at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

So, I have not commited the original patch for scsi_execute_async()
removal in the LIO PSCSI plugin in v2.6.28-rc6, but I will add some
temporary stubs for both codepaths and default to the legacy codepath
(until the timeout issues are resolved) and make the commit soon.

> One thing I can not see is where you get your "(struct scatterlist *)pt->pscsi_buf"
> scatterlist from? is that from the network layer? don't you get them one by one
> from the network layer and copy them to your own allocated scatterlist array?

So, the generic target engine in v3.0 lio-core-2.6.git can either
internally allocate *OR* accept linked list scatterlist with struct page
members in drivers/lio-core/target_core_transport.h:se_mem_t->se_page
coming from a fabric module.  In current v2.9 and v3.0 LIO-Target
running code (just the iSCSi Target engine), this means the internally
allocation using Linux kernel sockets.

> Do you actually receive a network allocated scatterlist array? because if not
> you should go directly to BIOs and drop that scatterlist stuff.
> 

Well, this discussion is for the target_core_mod/PSCSI plugin located in
drivers/lio-core/target-core-pscsi.c.  The target_core_mod/IBLOCK plugin
located in drivers/lio-core/target-core-iblock.c already uses
bio_alloc() and bio_add_page() + submit_bio() when talking to struct
block_device for READ/WRITE I/O, and of course emulating the SCSI
control path for the rest.  This is used when talking with virtual
struct block_device, that do not map struct back to a single struct
scsi_device.

Considering the target_core_mod/PSCSI plugin is intended to be directly
queuing passthrough CDBs (the generic engine does handle sectors >
$STORAGE_OBJECT->max_sectors) into struct scsi_device->request_queue, I
would like to get rid of the BIO usage with scsi_execute_async() (/me
thinks of legacy scsi_do_req()) when a generic target engine is handling
the hardware restrictions related to max_sectors, queue_depth and struct
page memory allocation.

So I understand that getting rid of scsi_execute_async() and
scsi_req_map_sg() is a work in progress, and I am really asking more of
what should be used in place of scsi_req_map_sg() in
target_core_mod/PSCSI..?

> Also that void* SG/NON_SG type cast crap is not acceptable any more. We worked
> very hard to clean all that up. You need to hold typed scatterlist pointer and if
> you happen to have single kernel buffers for submission you hold an struct scatterlist
> somewhere and do an sg_init_one() on the kernel buffer.

Ok, drivers/lio-core/target_core_transport.c:transport_calc_sg_num() is
using include/linux/scatterlist.h:sg_init_table() to setup the freshly
allocated contigious array of struct scatterlist.  se_mem_t->se_page
located in the linked list of memory at
drivers/lio-core/target_core_base.h:se_transport_task_t->t_mem_list.
The generic target algortihms in target_core_transport.c allow the
linked list of struct page memory to be mapped to struct
scatterlist->page_link in
target_core_transport.c:transport_map_mem_to_sg() using
sg_assign_page().  This happens already across subsystem plugins for
Linux/SCSI, Linux/BLOCK and Linux/VFS using the same code path.

>  For me this is preliminary to
> even consider this code.
> 

Ok, I have no problem getting rid of the casts between target_core_mod
and the subsystem plugins related to contigious buffer or non contigious
buffer usage with struct scatterlist (or whatever that can reference
struct page).  I will make the stub commits for the original patch later
today, and will remove the casts from se_task_t->task_buf that are going
down to drivers/lio-core/target_core_base.h:se_subsystem_api_t at some
point in the near future.

Many thanks for your comments,

--nab


