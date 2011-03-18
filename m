From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 3/6] isci: request (core request infrastructure)
Date: Fri, 18 Mar 2011 12:41:10 -0400
Message-ID: <20110318164110.GB19008@infradead.org>
References: <20110207003056.27040.89174.stgit@localhost6.localdomain6>
 <20110207003450.27040.61422.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55442 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab1CRQlM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2011 12:41:12 -0400
Content-Disposition: inline
In-Reply-To: <20110207003450.27040.61422.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: james.bottomley@suse.de, dave.jiang@intel.com, linux-scsi@vger.kernel.org, jacek.danecki@intel.com, ed.ciechanowski@intel.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com

> +static int isci_request_alloc_io(
> +	struct isci_host *isci_host,
> +	struct sas_task *task,
> +	struct isci_request **isci_request,
> +	struct isci_remote_device *isci_device,
> +	gfp_t gfp_flags)
> +{
> +	int retval = isci_request_alloc_core(isci_host, isci_request,
> +					     isci_device, gfp_flags);
> +
> +	if (!retval) {
> +		(*isci_request)->ttype_ptr.io_task_ptr = task;
> +		(*isci_request)->ttype                 = io_task;
> +
> +		task->lldd_task = *isci_request;
> +	}
> +	return retval;
> +}

This has just a single caller and would be much cleaner just inlined
there.

Btw, care to explain why you don't allocate the full sas_task for
TMF requests?  It seems like a lot of code would benefit from that
generalization.

> +int isci_request_alloc_tmf(
> +	struct isci_host *isci_host,
> +	struct isci_tmf *isci_tmf,
> +	struct isci_request **isci_request,
> +	struct isci_remote_device *isci_device,
> +	gfp_t gfp_flags)
> +{
> +	int retval = isci_request_alloc_core(isci_host, isci_request,
> +					     isci_device, gfp_flags);
> +
> +	if (!retval) {
> +
> +		(*isci_request)->ttype_ptr.tmf_task_ptr = isci_tmf;
> +		(*isci_request)->ttype = tmf_task;
> +	}
> +	return retval;
> +}

Again, much better opencoded in the only caller.

> +	ret = isci_request_alloc_io(
> +		isci_host,
> +		task,
> +		&request,
> +		isci_device,
> +		gfp_flags
> +		);

How about reformatting arguments in the whole driver in the normal way,
e.g.

	ret = isci_request_alloc_io(isci_host, task, &request, isci_device,
				    gfp_flags);

> +	status = isci_io_request_build(isci_host, request, isci_device);
> +	if (status == SCI_SUCCESS) {

just goto out here for the not successfull case here to keep the
indentation down.

> +		    status == SCI_FAILURE_REMOTE_DEVICE_RESET_REQUIRED) {

		SCI_REMOTE_RESET_REQUIRED would be more than enough.

> + out:
> +	if (status != SCI_SUCCESS) {
> +
> +		/* release dma memory on failure. */
> +		isci_request_free(isci_host, request);
> +		request = NULL;
> +		ret = SCI_FAILURE;
> +	}
> +
> +	*isci_request = request;

Just do the 

	*isci_request = request;
	return SCI_SUCCESS;

before the out label and then simply the out label to:

	isci_request_free(isci_host, request);
	*isci_request = NULL;
	return SCI_FAILURE;

btw, what exactly is the scope of the SCI_ return values?  They seem to
be used for specific actions above, but also abused as simple true/fail
bools in other places.  I think you want specific return values for
a couple functions and else 0/-errno in normal linux style.

> +static void isci_request_process_response_iu(
> +	struct sas_task *task,
> +	struct ssp_response_iu *resp_iu,
> +	struct device *dev)
> +{
> +	dev_dbg(dev,
> +		"%s: resp_iu = %p "
> +		"resp_iu->status = 0x%x,\nresp_iu->datapres = %d "
> +		"resp_iu->response_data_len = %x, "
> +		"resp_iu->sense_data_len = %x\nrepsonse data: ",
> +		__func__,
> +		resp_iu,
> +		resp_iu->status,
> +		resp_iu->datapres,
> +		resp_iu->response_data_len,
> +		resp_iu->sense_data_len);
> +
> +	task->task_status.stat = resp_iu->status;
> +
> +	/* libsas updates the task status fields based on the response iu. */
> +	sas_ssp_task_response(dev, task, resp_iu);

Can be opencoded in it's only caller.

> +static void isci_request_set_open_reject_status(
> +	struct isci_request *request,
> +	struct sas_task *task,
> +	enum service_response *response_ptr,
> +	enum exec_status *status_ptr,
> +	enum isci_completion_selection *complete_to_host_ptr,
> +	enum sas_open_rej_reason open_rej_reason)
> +{
> +	/* Task in the target is done. */
> +	request->complete_in_target       = true;
> +	*response_ptr                     = SAS_TASK_UNDELIVERED;
> +	*status_ptr                       = SAS_OPEN_REJECT;
> +	*complete_to_host_ptr             = isci_perform_normal_io_completion;
> +	task->task_status.open_rej_reason = open_rej_reason;
> +}

Not a very useful helper.  Just have a goto in the only calling function
to fill the field out - the only thing differing is the open rejection
reason, which can be stored in a local variable.

> +		if ((isci_device->status == isci_stopping)
> +		    || (isci_device->status == isci_stopped)
> +		    )

very confusing indentation, this should be:

		if (isci_device->status == isci_stopping ||
		    isci_device->status == isci_stopped)

> +void *isci_request_ssp_io_request_get_cdb_address(
> +	struct isci_request *request)
> +{
> +	struct sas_task *task = isci_request_access_task(request);
> +
> +	dev_dbg(&request->isci_host->pdev->dev,
> +		"%s: request->task->ssp_task.cdb = %p\n",
> +		__func__,
> +		task->ssp_task.cdb);
> +	return task->ssp_task.cdb;
> +}

Just opencode it in the only caller.  And get rid of the totally
mad isci_request_access_task obsfucation too please.

> +/**
> + * isci_request_ssp_io_request_get_cdb_length() - This function is called by
> + *    the sci core to retrieve the cdb length for a given request.
> + * @request: This parameter is the isci_request object.
> + *
> + * cdb length for specified request.
> + */
> +u32 isci_request_ssp_io_request_get_cdb_length(
> +	struct isci_request *request)
> +{
> +	return 16;
> +}

Completely pointless.  Either use a constant or better derive it from
the host template so that it's just set in one place.

> +u32 isci_request_ssp_io_request_get_lun(
> +	struct isci_request *request)
> +{
> +	struct sas_task *task = isci_request_access_task(request);
> +
> +	return task->ssp_task.LUN[0];
> +}

Again, pointless.

> +u32 isci_request_ssp_io_request_get_task_attribute(
> +	struct isci_request *request)
> +{
> +	struct sas_task *task = isci_request_access_task(request);
> +
> +	dev_dbg(&request->isci_host->pdev->dev,
> +		"%s: request->task->ssp_task.task_attr = %x\n",
> +		__func__,
> +		task->ssp_task.task_attr);
> +
> +	return task->ssp_task.task_attr;
> +}

Once more.

> +u32 isci_request_ssp_io_request_get_command_priority(
> +	struct isci_request *request)
> +{
> +	struct sas_task *task = isci_request_access_task(request);
> +
> +	dev_dbg(&request->isci_host->pdev->dev,
> +		"%s: request->task->ssp_task.task_prio = %x\n",
> +		__func__,
> +		task->ssp_task.task_prio);
> +
> +	return task->ssp_task.task_prio;
> +}

And again..

> +static inline
> +enum isci_request_status isci_request_get_state(
> +	struct isci_request *isci_request)
> +{
> +	BUG_ON(isci_request == NULL);
> +
> +	/*probably a bad sign...	*/
> +	if (isci_request->status == unallocated)
> +		dev_warn(&isci_request->isci_host->pdev->dev,
> +			 "%s: isci_request->status == unallocated\n",
> +			 __func__);
> +
> +	return isci_request->status;
> +}

Here again.

> +static inline enum isci_request_status isci_request_change_started_to_newstate(
> +	struct isci_request *isci_request,
> +	struct completion *completion_ptr,
> +	enum isci_request_status newstate)
> +{
> +	enum isci_request_status old_state;
> +	unsigned long flags;
> +
> +	BUG_ON(isci_request == NULL);
> +
> +	spin_lock_irqsave(&isci_request->state_lock, flags);
> +
> +	old_state = isci_request->status;
> +
> +	if (old_state == started) {
> +		BUG_ON(isci_request->io_request_completion != NULL);
> +
> +		isci_request->io_request_completion = completion_ptr;
> +		isci_request->status = newstate;
> +	}
> +	spin_unlock_irqrestore(&isci_request->state_lock, flags);
> +
> +	dev_dbg(&isci_request->isci_host->pdev->dev,
> +		"%s: isci_request = %p, old_state = 0x%x\n",
> +		__func__,
> +		isci_request,
> +		old_state);
> +
> +	return old_state;
> +}

This one seems far too large to be inlined.

> +static inline enum isci_request_status isci_request_change_started_to_aborted(
> +	struct isci_request *isci_request,
> +	struct completion *completion_ptr)
> +{
> +	return isci_request_change_started_to_newstate(
> +		       isci_request, completion_ptr, aborted
> +		       );
> +}

Another completely pointless wrapper.

> +
> +#define isci_request_access_task(RequestPtr) \
> +	((RequestPtr)->ttype_ptr.io_task_ptr)
> +
> +#define isci_request_access_tmf(RequestPtr)  \
> +	((RequestPtr)->ttype_ptr.tmf_task_ptr)

Pretty pointless wrappers that are longer than their expansion.

> +	if ((task->data_dir != PCI_DMA_NONE) &&
> +	    !sas_protocol_ata(task->task_proto)) {
> +		if (task->num_scatter == 0)
> +			/* 0 indicates a single dma address */
> +			dma_unmap_single(
> +				&pdev->dev,
> +				request->zero_scatter_daddr,
> +				task->total_xfer_len,
> +				task->data_dir
> +				);
> +
> +		else  /* unmap the sgl dma addresses */
> +			dma_unmap_sg(
> +				&pdev->dev,
> +				task->scatter,
> +				request->num_sg_entries,
> +				task->data_dir
> +				);
> +	}

The driver should use S/G lists for it's internal commands as well to

