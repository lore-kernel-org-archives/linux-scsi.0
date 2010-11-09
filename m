From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC v2 16/21] tcm: Add PSCSI subsystem plugin
Date: Mon, 08 Nov 2010 21:13:07 -0800
Message-ID: <1289279587.19946.69.camel@haakon2.linux-iscsi.org>
References: <1285195867-11728-1-git-send-email-nab@linux-iscsi.org>
	 <4CD01EE2.20705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56459 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab0KIFSX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2010 00:18:23 -0500
In-Reply-To: <4CD01EE2.20705@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <axboe@kernel.dk>

<More follow up on Boaz comments from last week>

On Tue, 2010-11-02 at 16:23 +0200, Boaz Harrosh wrote:
> On 09/23/2010 12:51 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds the PSCSI subsystem plugin for accessing struct scsi_device
> > using struct request from upstream Linux/SCSI code.  This subsystem plugin
> > follows a passthrough design, and does not provide and control CDB emulation
> > for the registered struct scsi_device backstores.  This subsystem plugin also
> > allows the export of both TYPE_DISk and non TYPE_DISK struct scsi_devices.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/target_core_pscsi.c | 1569 ++++++++++++++++++++++++++++++++++++
> >  drivers/target/target_core_pscsi.h |   69 ++
> >  2 files changed, 1638 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/target_core_pscsi.c
> >  create mode 100644 drivers/target/target_core_pscsi.h
> > 
> > diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> > new file mode 100644
> > index 0000000..60f825d
> > --- /dev/null
> > +++ b/drivers/target/target_core_pscsi.c

<SNIP>

> > +}
> > +
> > +/*	pscsi_add_device_to_list():
> > + *
> > + *
> > + */
> > +static struct se_device *pscsi_add_device_to_list(
> > +	struct se_hba *hba,
> > +	struct se_subsystem_dev *se_dev,
> > +	struct pscsi_dev_virt *pdv,
> > +	struct scsi_device *sd,
> > +	int dev_flags)
> > +{
> > +	struct se_device *dev;
> > +
> > +	/*
> > +	 * Some pseudo SCSI HBAs do not fill in sector_size
> > +	 * correctly. (See ide-scsi.c)  So go ahead and setup sane
> > +	 * values.
> > +	 */
> > +	if (!sd->sector_size) {
> > +		switch (sd->type) {
> > +		case TYPE_DISK:
> > +			sd->sector_size = 512;
> > +			break;
> > +		case TYPE_ROM:
> > +			sd->sector_size = 2048;
> > +			break;
> > +		case TYPE_TAPE: /* The Tape may not be in the drive */
> > +			break;
> > +		case TYPE_MEDIUM_CHANGER: /* Control CDBs only */
> > +			break;
> > +		default:
> > +			printk(KERN_ERR "Unable to set sector_size for %d\n",
> > +					sd->type);
> > +			return NULL;
> 
> What about sector-less devices? OSD, Scanners, printers ...
> +		default:
> +			break;

Yes, this code was originally put in place for some anicent LLDs on v2.4
and early v2.6 that did not properly set struct
scsi_device->sector_sector TYPE_DISK or TYPE_ROM.  I have not come
across this in a really, really long time so I think it may finally be
safe to drop this old code.

> 
> > +		}
> > +
> > +		if (sd->sector_size) {
> > +			printk(KERN_ERR "Set broken SCSI Device"
> > +				" %d:%d:%d sector_size to %d\n", sd->channel,
> > +				sd->id, sd->lun, sd->sector_size);
> > +		}
> > +	}
> > +
> > +	if (!sd->queue_depth) {
> > +		sd->queue_depth = PSCSI_DEFAULT_QUEUEDEPTH;
> > +
> > +		printk(KERN_ERR "Set broken SCSI Device %d:%d:%d"
> > +			" queue_depth to %d\n", sd->channel, sd->id,
> > +				sd->lun, sd->queue_depth);
> > +	}
> > +	/*
> > +	 * Set the pointer pdv->pdv_sd to from passed struct scsi_device,
> > +	 * which has already been referenced with Linux SCSI code with
> > +	 * scsi_device_get() in this file's pscsi_create_virtdevice().
> > +	 *
> > +	 * The passthrough operations called by the transport_add_device_*
> > +	 * function below will require this pointer to be set for passthroug
> > +	 *  ops.
> > +	 *
> > +	 * For the shutdown case in pscsi_free_device(), this struct
> > +	 * scsi_device  reference is released with Linux SCSI code
> > +	 * scsi_device_put() and the pdv->pdv_sd cleared.
> > +	 */
> > +	pdv->pdv_sd = sd;
> > +
> > +	dev = transport_add_device_to_core_hba(hba, &pscsi_template,
> > +				se_dev, dev_flags, (void *)pdv);
> > +	if (!(dev)) {
> > +		pdv->pdv_sd = NULL;
> > +		return NULL;
> > +	}
> > +
> > +	/*
> > +	 * For TYPE_TAPE, attempt to determine blocksize with MODE_SENSE.
> > +	 */
> > +	if (sd->type == TYPE_TAPE) {
> 
> Just as a future note:
> One of the things I'm missing from LIO is the notion of SCSI_TYPE or SCSI
> class. So things like this can be done in a plugin manner as per TYPE
> Like in the Kernel we have the ULDs for that.

Yes, this in pSCSI terms this is completely transparent in terms of
device type, aside from the old work around you caught above..  ;)

<SNIP>

> > +static inline void pscsi_blk_init_request(
> > +	struct se_task *task,
> > +	struct pscsi_plugin_task *pt,
> > +	struct request *req,
> > +	int bidi_read)
> > +{
> > +	/*
> > +	 * Defined as "scsi command" in include/linux/blkdev.h.
> > +	 */
> > +	req->cmd_type = REQ_TYPE_BLOCK_PC;
> > +	/*
> > +	 * For the extra BIDI-COMMAND READ struct request we do not
> > +	 * need to setup the remaining structure members
> > +	 */
> > +	if (bidi_read)
> > +		return;
> > +	/*
> > +	 * Setup the done function pointer for struct request,
> > +	 * also set the end_io_data pointer.to struct se_task.
> > +	 */
> > +	req->end_io = pscsi_req_done;
> > +	req->end_io_data = (void *)task;
> > +	/*
> > +	 * Load the referenced struct se_task's SCSI CDB into
> > +	 * include/linux/blkdev.h:struct request->cmd
> > +	 */
> > +	req->cmd_len = scsi_command_size(pt->pscsi_cdb);
> > +	req->cmd = &pt->pscsi_cdb[0];
> 
> Here!   req->cmd = TASK_CMD(task)->t_task_cdb;
> 
> I don't see in this patch the actual memcpy of TASK_CMD(task)->t_task_cdb into
> pt->pscsi_cdb, which I suspect is done in Generic code through the use of
> ->get_cdb(struct se_task *);?
> 
> If so then it means all the plugins have their own copy of the CDB? Now I finally
> understand the get_max_cdb_len().
> 
> All that could be totally clean. All plugins use the TASK_CMD(task)->t_task_cdb
> directly. Then get_max_cdb_len(), get_cdb(), the memcpy() and all these extra buffers
> just magically go away.

As described in the last response, the T_TASK(cmd)->t_task_cdb is used
as a base for all CDBs, and is the primary storage for all *non*
SCF_SCSI_DATA_SG_IO_CDB type ops.

For all bulk SCF_SCSI_DATA_SG_IO_CDB, we will memcpy
T_TASK(cmd)->t_task_cdb into the backend specific location (for
TCM/pSCSI this is pt->pscsi_cdb[])  and then update the LBA+length when
splitting the single received struct se_cmd across multiple struct
se_task w/ backend descriptors due to backend struct
se_dev_limits->limits.max_sectors limitations for underlying backend HW.

> 
> > +	/*
> > +	 * Setup pointer for outgoing sense data.
> > +	 */
> > +	req->sense = (void *)&pt->pscsi_sense[0];
> 
> What about sense Surly that is generic just as cdb is. Could you use the
> task's sense?
> 

Hmmmm, I am not sure we need to make this per struct se_task on the
backend / subsystem plugin side.  For the IBLOCK and FILEIO code this
will simply will be set to single outgoing se_cmd context sense buffer
being propigated up to the TFO API (eg: no per task sense buffer).  Only
pSCSI has an internal sense_buffer per struct pscsi_plugin_task because
we need it to be setup for the struct request->sense code.

> > +	req->sense_len = 0;
> > +}
> > +
> > +/*
> > + * Used for pSCSI data payloads for all *NON* SCF_SCSI_DATA_SG_IO_CDB
> > +*/
> > +static int pscsi_blk_get_request(struct se_task *task)
> > +{
> > +	struct pscsi_plugin_task *pt = (struct pscsi_plugin_task *) task->transport_req;
> > +	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) task->se_dev->dev_ptr;
> > +
> > +	pt->pscsi_req = blk_get_request(pdv->pdv_sd->request_queue,
> > +			(pt->pscsi_direction == DMA_TO_DEVICE), GFP_KERNEL);
> > +	if (!(pt->pscsi_req) || IS_ERR(pt->pscsi_req)) {
> > +		printk(KERN_ERR "PSCSI: blk_get_request() failed: %ld\n",
> > +				IS_ERR(pt->pscsi_req));
> > +		return PYX_TRANSPORT_LU_COMM_FAILURE;
> > +	}
> > +	/*
> > +	 * Setup the newly allocated struct request for REQ_TYPE_BLOCK_PC,
> > +	 * and setup rq callback, CDB and sense.
> > +	 */
> > +	pscsi_blk_init_request(task, pt, pt->pscsi_req, 0);
> > +	return 0;
> > +}
> > +
> > +/*      pscsi_do_task(): (Part of se_subsystem_api_t template)
> > + *
> > + *
> > + */
> > +static int pscsi_do_task(struct se_task *task)
> > +{
> > +	struct pscsi_plugin_task *pt = (struct pscsi_plugin_task *) task->transport_req;
> > +	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) task->se_dev->dev_ptr;
> > +	/*
> > +	 * Set the struct request->timeout value based on peripheral
> > +	 * device type from SCSI.
> > +	 */
> > +	if (pdv->pdv_sd->type == TYPE_DISK)
> > +		pt->pscsi_req->timeout = PS_TIMEOUT_DISK;
> > +	else
> > +		pt->pscsi_req->timeout = PS_TIMEOUT_OTHER;
> > +
> > +	pt->pscsi_req->retries = PS_RETRY;
> > +	/*
> > +	 * Queue the struct request into the struct scsi_device->request_queue.
> > +	 */
> > +	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, NULL,
> > +			      pt->pscsi_req, 1, pscsi_req_done);
> > +
> 
> /**
>  * blk_execute_rq_nowait - insert a request into queue for execution
>  * @q:		queue to insert the request in
>  * @bd_disk:	matching gendisk
>  * @rq:		request to insert
>  * @at_head:    insert request at head or tail of queue
>  * @done:	I/O completion handler
>  *
> 
> Surly you did not mean to use at_head==1? That is a very bad BUG. I bet
> this plugin was never heavily used.
> 

Yikes..

I have been keep folks who need pSCSI for TYPE_DISK for production on <=
v2.6.27 kernels before alot of this TCM/pSCSI code got changed to use
struct request directly..

Fixing now to take the SAM Task attr into account, seriously thanks for
catching this.

<SNIP>

> > +
> > +#if 0
> > +#define DEBUG_PSCSI(x...) printk(x)
> > +#else
> > +#define DEBUG_PSCSI(x...)
> > +#endif
> > +
> > +static int __pscsi_map_task_SG(
> > +	struct se_task *task,
> > +	struct scatterlist *task_sg,
> > +	u32 task_sg_num,
> > +	int bidi_read)
> > +{
> > +	struct pscsi_plugin_task *pt = (struct pscsi_plugin_task *) task->transport_req;
> > +	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) task->se_dev->dev_ptr;
> > +	struct bio *bio = NULL, *hbio = NULL, *tbio = NULL;
> > +	struct page *page;
> > +	struct scatterlist *sg;
> > +	u32 data_len = task->task_size, i, len, bytes, off;
> > +	int nr_pages = (task->task_size + task_sg[0].offset +
> 
> Please forgive me I must be looking at an old patch but this is what I could find
> in my mail box. 
> 
> 	task->task_size? there must be two of them one for write/uni one for bidi_rea

Currently there is no need for BIDI read specific task->task_size
because:

*) For BIDI operation w/ IBLOCK and FILEIO, the commands are executed as
multiple struct se_tasks.

*) For BIDI operation w/ PSCSI, the operation is a passthrough and
struct request does not need to know about size in
pscsi_blk_init_request().

> 
> > +			PAGE_SIZE - 1) >> PAGE_SHIFT;
> > +	int nr_vecs = 0, ret = 0;
> > +	int rw = (TASK_CMD(task)->data_direction == DMA_TO_DEVICE);
> > +
> > +	if (!task->task_size)
> 
> dito
> 
> > +		return 0;
> > +	/*
> > +	 * For SCF_SCSI_DATA_SG_IO_CDB, Use fs/bio.c:bio_add_page() to setup
> > +	 * the bio_vec maplist from TC< struct se_mem -> task->task_sg ->
> > +	 * struct scatterlist memory.  The struct se_task->task_sg[] currently needs
> > +	 * to be attached to struct bios for submission to Linux/SCSI using
> > +	 * struct request to struct scsi_device->request_queue.
> > +	 *
> > +	 * Note that this will be changing post v2.6.28 as Target_Core_Mod/pSCSI
> > +	 * is ported to upstream SCSI passthrough functionality that accepts
> > +	 * struct scatterlist->page_link or struct page as a paraemeter.
> > +	 */
> > +	DEBUG_PSCSI("PSCSI: nr_pages: %d\n", nr_pages);
> > +
> > +	for_each_sg(task_sg, sg, task_sg_num, i) {
> 
> Good received from caller
> 
> > +		page = sg_page(sg);
> > +		off = sg->offset;
> > +		len = sg->length;
> > +
> > +		DEBUG_PSCSI("PSCSI: i: %d page: %p len: %d off: %d\n", i,
> > +			page, len, off);
> > +
> > +		while (len > 0 && data_len > 0) {
> > +			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
> > +			bytes = min(bytes, data_len);
> > +
> > +			if (!(bio)) {
> > +				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
> > +				nr_pages -= nr_vecs;
> > +				/*
> > +				 * Calls bio_kmalloc() and sets bio->bi_end_io()
> > +				 */
> > +				bio = pscsi_get_bio(pdv, nr_vecs);
> > +				if (!(bio))
> > +					goto fail;
> > +
> > +				if (rw)
> > +					bio->bi_rw |= REQ_WRITE;
> > +
> > +				DEBUG_PSCSI("PSCSI: Allocated bio: %p,"
> > +					" dir: %s nr_vecs: %d\n", bio,
> > +					(rw) ? "rw" : "r", nr_vecs);
> > +				/*
> > +				 * Set *hbio pointer to handle the case:
> > +				 * nr_pages > BIO_MAX_PAGES, where additional
> > +				 * bios need to be added to complete a given
> > +				 * struct se_task
> > +				 */
> > +				if (!hbio)
> > +					hbio = tbio = bio;
> > +				else
> > +					tbio = tbio->bi_next = bio;
> > +			}
> > +
> > +			DEBUG_PSCSI("PSCSI: Calling bio_add_pc_page() i: %d"
> > +				" bio: %p page: %p len: %d off: %d\n", i, bio,
> > +				page, len, off);
> > +
> > +			ret = bio_add_pc_page(pdv->pdv_sd->request_queue,
> > +					bio, page, bytes, off);
> > +			if (ret != bytes)
> > +				goto fail;
> > +
> > +			DEBUG_PSCSI("PSCSI: bio->bi_vcnt: %d nr_vecs: %d\n",
> > +				bio->bi_vcnt, nr_vecs);
> > +
> > +			if (bio->bi_vcnt > nr_vecs) {
> > +				DEBUG_PSCSI("PSCSI: Reached bio->bi_vcnt max:"
> > +					" %d i: %d bio: %p, allocating another"
> > +					" bio\n", bio->bi_vcnt, i, bio);
> > +				/*
> > +				 * Clear the pointer so that another bio will
> > +				 * be allocated with pscsi_get_bio() above, the
> > +				 * current bio has already been set *tbio and
> > +				 * bio->bi_next.
> > +				 */
> > +				bio = NULL;
> > +			}
> > +
> > +			page++;
> > +			len -= bytes;
> > +			data_len -= bytes;
> > +			off = 0;
> > +		}
> > +	}
> > +	/*
> > +	 * Setup the primary pt->pscsi_req used for non BIDI and BIDI-COMMAND
> > +	 * primary SCSI WRITE poayload mapped for struct se_task->task_sg[]
> > +	 */
> > +	if (!(bidi_read)) {
> > +		/*
> > +		 * Starting with v2.6.31, call blk_make_request() passing in *hbio to
> > +		 * allocate the pSCSI task a struct request.
> > +		 */
> > +		pt->pscsi_req = blk_make_request(pdv->pdv_sd->request_queue,
> > +					hbio, GFP_KERNEL);
> > +		if (!(pt->pscsi_req)) {
> > +			printk(KERN_ERR "pSCSI: blk_make_request() failed\n");
> > +			goto fail;
> > +		}
> > +		/*
> > +		 * Setup the newly allocated struct request for REQ_TYPE_BLOCK_PC,
> > +		 * and setup rq callback, CDB and sense.
> > +		 */
> > +		pscsi_blk_init_request(task, pt, pt->pscsi_req, 0);
> > +
> > +		return task->task_sg_num;
> 		return task_sg_num ??
> > +	}
> > +	/*
> > +	 * Setup the secondary pt->pscsi_req_bidi used for the extra BIDI-COMMAND
> > +	 * SCSI READ paylaod mapped for struct se_task->task_sg_bidi[]
> > +	 */
> > +	pt->pscsi_req_bidi = blk_make_request(pdv->pdv_sd->request_queue,
> > +					hbio, GFP_KERNEL);
> > +	if (!(pt->pscsi_req_bidi)) {
> > +		printk(KERN_ERR "pSCSI: blk_make_request() failed for BIDI\n");
> > +		goto fail;
> > +	}
> > +	pscsi_blk_init_request(task, pt, pt->pscsi_req_bidi, 1);
> > +	/*
> > +	 * Setup the magic BIDI-COMMAND ->next_req pointer to the original
> > +	 * pt->pscsi_req.
> > +	 */	
> > +	pt->pscsi_req->next_rq = pt->pscsi_req_bidi;
> > +
> > +	return task->task_sg_num;
> 
> 	return task_sg_num ??
> 

This is no longer used in transport_generic_new_cmd() from
task->transport_map_task() to signal anything other than a less than
zero failure, so in the context of BIDI ops it does not matter.

> > +fail:
> > +	while (hbio) {
> > +		bio = hbio;
> > +		hbio = hbio->bi_next;
> > +		bio->bi_next = NULL;
> > +		bio_endio(bio, 0);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int pscsi_map_task_SG(struct se_task *task)
> > +{
> > +	int ret;
> > +	/*
> > +	 * Setup the main struct request for the task->task_sg[] payload
> > +	 */
> > +
> > +	ret = __pscsi_map_task_SG(task, task->task_sg, task->task_sg_num, 0);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (!(task->task_sg_bidi))
> > +		return ret;
> > +	/*
> > +	 * If present, set up the extra BIDI-COMMAND SCSI READ
> > +	 * struct request and payload.
> > +	 */
> > +	return __pscsi_map_task_SG(task, task->task_sg_bidi,
> > +				task->task_sg_num, 1);
> 
> The second __pscsi_map_task_SG can fail. Do you make sure to free
> the successful first __pscsi_map_task_SG? 
> 

Yes, this is all handled by walking the T_TASK(cmd)->t_task_list in
transport_free_dev_tasks().

<SNIP>

> > +static unsigned char *pscsi_get_cdb(struct se_task *task)
> > +{
> > +	struct pscsi_plugin_task *pt = (struct pscsi_plugin_task *) task->transport_req;
> > +
> > +	return pt->pscsi_cdb;
> > +}
> > +
> > +/*	pscsi_get_sense_buffer():
> > + *
> > + *
> > + */
> > +static unsigned char *pscsi_get_sense_buffer(struct se_task *task)
> > +{
> > +	struct pscsi_plugin_task *pt = (struct pscsi_plugin_task *) task->transport_req;
> 
> All over these. Don't cast a void pointer.

Yep, already dropped.

> 
> > +
> > +	return (unsigned char *)&pt->pscsi_sense[0];
> > +}
> > +
> > +/*	pscsi_get_blocksize():
> > + *
> > + *
> > + */
> > +static u32 pscsi_get_blocksize(struct se_device *dev)
> > +{
> > +	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) dev->dev_ptr;
> > +	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
> > +
> > +	return sd->sector_size;
> > +}
> > +
> > +/*	pscsi_get_device_rev():
> > + *
> > + *
> > + */
> > +static u32 pscsi_get_device_rev(struct se_device *dev)
> > +{
> > +	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) dev->dev_ptr;
> > +	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
> > +
> > +	return (sd->scsi_level - 1) ? sd->scsi_level - 1 : 1;
> > +}
> > +
> > +/*	pscsi_get_device_type():
> > + *
> > + *
> > + */
> > +static u32 pscsi_get_device_type(struct se_device *dev)
> > +{
> > +	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) dev->dev_ptr;
> > +	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
> > +
> > +	return sd->type;
> > +}
> > +
> > +/*	pscsi_get_dma_length():
> > + *
> > + *
> > + */
> > +static u32 pscsi_get_dma_length(u32 task_size, struct se_device *dev)
> > +{
> > +	return PAGE_SIZE;
> 
> ??

This is used to determine the sage of each individual struct se_mem
size 

> 
> > +}
> > +
> > +/*	pscsi_get_max_sectors():
> > + *
> > + *
> > + */
> > +static u32 pscsi_get_max_sectors(struct se_device *dev)
> > +{
> > +	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) dev->dev_ptr;
> > +	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
> > +
> > +	return (sd->host->max_sectors > sd->request_queue->limits.max_sectors) ?
> > +		sd->request_queue->limits.max_sectors : sd->host->max_sectors;
> > +}
> > +
> > +/*	pscsi_get_queue_depth():
> > + *
> > + *
> > + */
> > +static u32 pscsi_get_queue_depth(struct se_device *dev)
> > +{
> > +	struct pscsi_dev_virt *pdv = (struct pscsi_dev_virt *) dev->dev_ptr;
> > +	struct scsi_device *sd = (struct scsi_device *) pdv->pdv_sd;
> > +
> > +	return sd->queue_depth;
> > +}
> > +
> > +/*	pscsi_handle_SAM_STATUS_failures():
> > + *
> > + *
> > + */
> > +static inline void pscsi_process_SAM_status(
> > +	struct se_task *task,
> > +	struct pscsi_plugin_task *pt)
> > +{
> > +	task->task_scsi_status = status_byte(pt->pscsi_result);
> > +	if ((task->task_scsi_status)) {
> > +		task->task_scsi_status <<= 1;
> > +		printk(KERN_INFO "PSCSI Status Byte exception at task: %p CDB:"
> > +			" 0x%02x Result: 0x%08x\n", task, pt->pscsi_cdb[0],
> > +			pt->pscsi_result);
> > +	}
> > +
> > +	switch (host_byte(pt->pscsi_result)) {
> > +	case DID_OK:
> > +		transport_complete_task(task, (!task->task_scsi_status));
> > +		break;
> > +	default:
> > +		printk(KERN_INFO "PSCSI Host Byte exception at task: %p CDB:"
> > +			" 0x%02x Result: 0x%08x\n", task, pt->pscsi_cdb[0],
> > +			pt->pscsi_result);
> > +		task->task_scsi_status = SAM_STAT_CHECK_CONDITION;
> > +		task->task_error_status = PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
> > +		TASK_CMD(task)->transport_error_status =
> > +					PYX_TRANSPORT_UNKNOWN_SAM_OPCODE;
> > +		transport_complete_task(task, 0);
> > +		break;
> > +	}
> > +
> > +	return;
> > +}
> > +
> > +static void pscsi_req_done(struct request *req, int uptodate)
> > +{
> > +	struct se_task *task = (struct se_task *)req->end_io_data;
> > +	struct pscsi_plugin_task *pt = (struct pscsi_plugin_task *)task->transport_req;
> > +
> > +	pt->pscsi_result = req->errors;
> > +	pt->pscsi_resid = req->resid_len;
> > +
> > +	pscsi_process_SAM_status(task, pt);
> > +
> > +	if (req->next_rq != NULL) {
> > +		__blk_put_request(req->q, req->next_rq);
> > +		pt->pscsi_req_bidi = NULL;
> 
> 		req->next_rq = NULL
> 
> Actually pt->pscsi_req_bidi is never used, it's set and reset
> only req->next_rq is used. You are fine without it. You have
> pt->pscsi_req and pt->pscsi_req->next_rq;
> 

Dropping, thanks!

> > +	}
> > +
> > +	__blk_put_request(req->q, req);
> > +	pt->pscsi_req = NULL;
> > +}
> > +
> > +static struct se_subsystem_api pscsi_template = {
> > +	.name			= "pscsi",
> > +	.type			= PSCSI,
> > +	.transport_type		= TRANSPORT_PLUGIN_PHBA_PDEV,
> > +	.external_submod	= 1,
> > +	.cdb_none		= pscsi_CDB_none,
> > +	.cdb_read_non_SG	= pscsi_CDB_read_non_SG,
> > +	.cdb_read_SG		= pscsi_CDB_read_SG,
> > +	.cdb_write_non_SG	= pscsi_CDB_write_non_SG,
> > +	.cdb_write_SG		= pscsi_CDB_write_SG,
> > +	.attach_hba		= pscsi_attach_hba,
> > +	.detach_hba		= pscsi_detach_hba,
> > +	.pmode_enable_hba	= pscsi_pmode_enable_hba,
> > +	.activate_device	= pscsi_activate_device,
> > +	.deactivate_device	= pscsi_deactivate_device,
> > +	.allocate_virtdevice	= pscsi_allocate_virtdevice,
> > +	.create_virtdevice	= pscsi_create_virtdevice,
> > +	.free_device		= pscsi_free_device,
> > +	.transport_complete	= pscsi_transport_complete,
> > +	.allocate_request	= pscsi_allocate_request,
> > +	.do_task		= pscsi_do_task,
> > +	.free_task		= pscsi_free_task,
> > +	.check_configfs_dev_params = pscsi_check_configfs_dev_params,
> > +	.set_configfs_dev_params = pscsi_set_configfs_dev_params,
> > +	.show_configfs_dev_params = pscsi_show_configfs_dev_params,
> > +	.create_virtdevice_from_fd = NULL,
> > +	.get_plugin_info	= pscsi_get_plugin_info,
> > +	.get_hba_info		= pscsi_get_hba_info,
> > +	.get_dev_info		= pscsi_get_dev_info,
> > +	.check_lba		= pscsi_check_lba,
> > +	.check_for_SG		= pscsi_check_for_SG,
> > +	.get_cdb		= pscsi_get_cdb,
> > +	.get_sense_buffer	= pscsi_get_sense_buffer,
> > +	.get_blocksize		= pscsi_get_blocksize,
> > +	.get_device_rev		= pscsi_get_device_rev,
> > +	.get_device_type	= pscsi_get_device_type,
> > +	.get_dma_length		= pscsi_get_dma_length,
> > +	.get_max_sectors	= pscsi_get_max_sectors,
> > +	.get_queue_depth	= pscsi_get_queue_depth,
> > +	.write_pending		= NULL,
> > +};
> > +
> > +int __init pscsi_module_init(void)
> > +{
> > +	int ret;
> > +
> > +	INIT_LIST_HEAD(&pscsi_template.sub_api_list);
> > +
> > +	ret = transport_subsystem_register(&pscsi_template, THIS_MODULE);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> > +}
> > +
> > +void pscsi_module_exit(void)
> > +{
> > +	transport_subsystem_release(&pscsi_template);
> > +}
> > +
> > +MODULE_DESCRIPTION("TCM PSCSI subsystem plugin");
> > +MODULE_AUTHOR("nab@Linux-iSCSI.org");
> > +MODULE_LICENSE("GPL");
> > +
> > +module_init(pscsi_module_init);
> > +module_exit(pscsi_module_exit);
> > diff --git a/drivers/target/target_core_pscsi.h b/drivers/target/target_core_pscsi.h
> > new file mode 100644
> > index 0000000..d3c8972
> > --- /dev/null
> > +++ b/drivers/target/target_core_pscsi.h
> > @@ -0,0 +1,69 @@
> > +#ifndef TARGET_CORE_PSCSI_H
> > +#define TARGET_CORE_PSCSI_H
> > +
> > +#define PSCSI_VERSION		"v4.0"
> > +#define PSCSI_VIRTUAL_HBA_DEPTH	2048
> > +
> > +/* used in pscsi_find_alloc_len() */
> > +#ifndef INQUIRY_DATA_SIZE
> > +#define INQUIRY_DATA_SIZE	0x24
> > +#endif
> > +
> > +/* used in pscsi_add_device_to_list() */
> > +#define PSCSI_DEFAULT_QUEUEDEPTH	1
> > +
> > +#define PS_RETRY		5
> > +#define PS_TIMEOUT_DISK		(15*HZ)
> > +#define PS_TIMEOUT_OTHER	(500*HZ)
> > +
> > +extern struct se_global *se_global;
> > +extern struct block_device *linux_blockdevice_claim(int, int, void *);
> > +extern int linux_blockdevice_release(int, int, struct block_device *);
> > +extern int linux_blockdevice_check(int, int);
> > +
> > +#include <linux/device.h>
> > +#include <scsi/scsi_driver.h>
> > +#include <scsi/scsi_device.h>
> > +#include <linux/kref.h>
> > +#include <linux/kobject.h>
> > +
> > +struct pscsi_plugin_task {
> > +	unsigned char pscsi_cdb[TCM_MAX_COMMAND_SIZE];
> > +	unsigned char pscsi_sense[SCSI_SENSE_BUFFERSIZE];
> > +	int	pscsi_direction;
> > +	int	pscsi_result;
> > +	u32	pscsi_resid;
> 
> Scsi has two residual results. One inside each request. 
> 
> > +	struct request *pscsi_req;
> > +	struct request *pscsi_req_bidi;
> > +} ____cacheline_aligned;
> > +
> > +#define PDF_HAS_CHANNEL_ID	0x01
> > +#define PDF_HAS_TARGET_ID	0x02
> > +#define PDF_HAS_LUN_ID		0x04
> > +#define PDF_HAS_VPD_UNIT_SERIAL 0x08
> > +#define PDF_HAS_VPD_DEV_IDENT	0x10
> > +#define PDF_HAS_VIRT_HOST_ID	0x20	
> > +
> > +struct pscsi_dev_virt {
> > +	int	pdv_flags;
> > +	int	pdv_host_id;
> > +	int	pdv_channel_id;
> > +	int	pdv_target_id;
> > +	int	pdv_lun_id;
> > +	struct block_device *pdv_bd;
> > +	struct scsi_device *pdv_sd;
> > +	struct se_hba *pdv_se_hba;
> > +} ____cacheline_aligned;
> > +
> > +typedef enum phv_modes {
> > +	PHV_VIRUTAL_HOST_ID,
> > +	PHV_LLD_SCSI_HOST_NO
> > +} phv_modes_t;
> > +
> > +struct pscsi_hba_virt {
> > +	int			phv_host_id;
> > +	phv_modes_t		phv_mode;
> > +	struct Scsi_Host	*phv_lld_host;
> > +} ____cacheline_aligned;
> > +
> > +#endif   /*** TARGET_CORE_PSCSI_H ***/
> 
> Nic all over these patches you have
> +	struct pscsi_plugin_task *pt = (struct pscsi_plugin_task *) task->transport_req;
> Don't cast void pointers, please. That would be a big fat change just search for transport_req.
> 

Yes sorry, these casts have all be removed.

> OK So I'm stopping to review from email and will next go to the gitweb URL you sent me. Because
> in all my mailbox patches I cannot find where the task->transport_req is set, which means I'm
> missing some of them.

task->transport_req is set to the backend depend task descriptor form
the return pointer of struct se_subsystem_api->allocate_request() in
transport_generic_get_task()

>  The thing I wanted to know is if there is a 1-to-1 lifetime association

Correct.

> between a plugin task like  pscsi_plugin_task and the task-> which holds it. (On ->transport_req)
> If yes, you might consider an embedded se_task in each plugin_task and the use of container_of.
> Faster, more robust and cleans code considerably.

Yes, I have been thinking about converting this to a single allocation
following what has been done for struct se_cmd allocations living in
fabric dependent cmd descriptors.  I may have a look at see how easily
this can be done for v4.0 backend code..

Anyways, sending out a patch for the above items shortly.  Thanks for
your comments Boaz!

--nab

