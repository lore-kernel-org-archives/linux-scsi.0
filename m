From: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH/RFC] UASP enhancement to usb-storage
Date: Thu, 1 Apr 2010 10:52:42 -0700
Message-ID: <20100401175242.GA10642@xanatos>
References: <201004011738.o31HcpDb025872@us01dwamd020.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201004011738.o31HcpDb025872-pJ+t1mZ+umbHCB+OhLwwH+tqTOX0CYZoAL8bYrjMMd8@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hrant Dalalyan <Hrant.Dalalyan-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Cc: USB mailing list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB storage mailing list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, Greg Kroah-Hartman <gregkh-l3A5Bk7waGM@public.gmane.org>, Paul Zimmerman <Paul.Zimmerman-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, John Youn <John.Youn-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, Ashot Madatyan <Ashot.Madatyan-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Forwarding to the linux-scsi list too.

Sarah Sharp

On Thu, Apr 01, 2010 at 10:38:51AM -0700, Hrant Dalalyan wrote:
> Implementation of USB Attached SCSI Protocol per UASP Specification
> (Rev.1, July 9, 2008).  Below is the list of the enhancements made to
> the usb-storage driver.
> 
> - Enhanced probe routine to identify UASP devices.
> - Allocation/deallocation of UASP specific resources.
> - Various enhancements to existing infrastructure to invoke UASP
>   specific routines.
> - Added SCSI command queueing mechanism and state machine for
>   handling multiple commands.
> - Implemented 'abort task' and 'reset nexus' task management
>   functions.
> 
> Limitations:
> 
> - Considered that the endpoint descriptors are received from the device
>  side in the following order:
>   - Command endpoint descriptor.
>   - Bulk in endpoint descriptor.
>   - Bulk out endpoint descriptor.
>   - Status endpoint descriptor.
> because in  the noted revision of the UASP Specification were not defined
> pipe usage descriptors.
> 
> - The max number of streams are not retrieved through the superspeed
>   endpoint companion descriptor and are fixed to 2 streams per
>   endpoint.
> - Device supported LUNs are assumed to be 1.
> - Concurrent processing of SCSI commands is not yet tested due to due
>   to some device limitations.  The driver is currently set to process
>   only 1 command at a time.
> - Abort task, Reset nexus task management functions, as well as some
>   error conditions and recovery situations are not yet tested.
> 
> Signed-off-by: Hrant Dalalyan <dalalyan-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
> ---
> 
>  drivers/usb/storage/protocol.c     |    5 +-
>  drivers/usb/storage/scsiglue.c     |  126 +++-
>  drivers/usb/storage/transport.c    | 1268 +++++++++++++++++++++++++++++++++++-
>  drivers/usb/storage/transport.h    |  150 +++++
>  drivers/usb/storage/unusual_devs.h |    3 +
>  drivers/usb/storage/usb.c          |  445 ++++++++++---
>  drivers/usb/storage/usb.h          |   59 ++
>  include/linux/usb_usual.h          |    1 +
>  8 files changed, 1931 insertions(+), 126 deletions(-)
> 
> diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
> index fc310f7..a8882f1 100644
> --- a/drivers/usb/storage/protocol.c
> +++ b/drivers/usb/storage/protocol.c
> @@ -119,7 +119,10 @@ void usb_stor_transparent_scsi_command(struct scsi_cmnd *srb,
>  				       struct us_data *us)
>  {
>  	/* send the command to the transport layer */
> -	usb_stor_invoke_transport(srb, us);
> +	if (us->protocol == US_PR_UASP)
> +		usb_stor_invoke_UASP_transport(us);
> +	else
> +		usb_stor_invoke_transport(srb, us);
>  }
>  EXPORT_SYMBOL_GPL(usb_stor_transparent_scsi_command);
>  
> diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
> index cfa26d5..dc8c602 100644
> --- a/drivers/usb/storage/scsiglue.c
> +++ b/drivers/usb/storage/scsiglue.c
> @@ -102,7 +102,7 @@ static int slave_alloc (struct scsi_device *sdev)
>  	 * values can be as large as 2048.  To make that work properly
>  	 * will require changes to the block layer.
>  	 */
> -	blk_queue_update_dma_alignment(sdev->request_queue, (512 - 1));
> +	blk_queue_update_dma_alignment(sdev->request_queue, (1024 - 1));
>  
>  	/*
>  	 * The UFI spec treates the Peripheral Qualifier bits in an
> @@ -281,11 +281,13 @@ static int queuecommand(struct scsi_cmnd *srb,
>  			void (*done)(struct scsi_cmnd *))
>  {
>  	struct us_data *us = host_to_us(srb->device->host);
> +	struct cmd_iu *cmdiu;
> +	unsigned long flags;
>  
>  	US_DEBUGP("%s called\n", __func__);
>  
>  	/* check for state-transition errors */
> -	if (us->srb != NULL) {
> +	if (us->protocol != US_PR_UASP && us->srb != NULL) {
>  		printk(KERN_ERR USB_STORAGE "Error in %s: us->srb = %p\n",
>  			__func__, us->srb);
>  		return SCSI_MLQUEUE_HOST_BUSY;
> @@ -299,10 +301,33 @@ static int queuecommand(struct scsi_cmnd *srb,
>  		return 0;
>  	}
>  
> -	/* enqueue the command and wake up the control thread */
> -	srb->scsi_done = done;
> -	us->srb = srb;
> -	complete(&us->cmnd_ready);
> +	if (us->protocol != US_PR_UASP) {
> +		/* enqueue the command and wake up the control thread */
> +		srb->scsi_done = done;
> +		us->srb = srb;
> +		complete(&us->cmnd_ready);
> +	} else {
> +		cmdiu = kzalloc(sizeof(struct cmd_iu), GFP_ATOMIC);
> +		if (!cmdiu)
> +			return SCSI_MLQUEUE_HOST_BUSY;
> +
> +		cmdiu->cmd_iu_id = IU_ID_COMMAND;
> +		cmdiu->ipt_tag = cpu_to_be16(usb_stor_get_tag(us));
> +		cmdiu->length = cpu_to_be16(30);
> +		cmdiu->lun[7] = srb->device->lun;
> +		memcpy(cmdiu->cdb, srb->cmnd, srb->cmd_len);
> +		cmdiu->cmd = srb;
> +		cmdiu->cmd->scsi_done = done;
> +		cmdiu->state = COMMAND_STATE_IDLE;
> +		cmdiu->us = us;
> +
> +		spin_lock_irqsave(&us->lock, flags);
> +		list_add_tail(&cmdiu->node, &us->temp_scsi_cmnd_queue);
> +		us->new_command = 1;
> +		spin_unlock_irqrestore(&us->lock, flags);
> +
> +		wake_up(&us->uasp_wq);
> +	}
>  
>  	return 0;
>  }
> @@ -310,39 +335,92 @@ static int queuecommand(struct scsi_cmnd *srb,
>  /***********************************************************************
>   * Error handling functions
>   ***********************************************************************/
> +static struct cmd_iu *find_cmd_by_ptr(struct us_data *us,
> +					struct scsi_cmnd *srb)
> +{
> +	struct cmd_iu *cmdiu = 0;
> +
> +	list_for_each_entry(cmdiu, &us->scsi_cmnd_queue, node) {
> +		if (cmdiu->cmd == srb)
> +			return cmdiu;
> +	}
> +
> +	list_for_each_entry(cmdiu, &us->temp_scsi_cmnd_queue, node) {
> +		if (cmdiu->cmd == srb)
> +			return cmdiu;
> +	}
> +
> +	return 0;
> +}
>  
>  /* Command timeout and abort */
>  static int command_abort(struct scsi_cmnd *srb)
>  {
>  	struct us_data *us = host_to_us(srb->device->host);
> +	struct cmd_iu *cmdiu;
> +	unsigned long flags;
>  
>  	US_DEBUGP("%s called\n", __func__);
>  
> -	/* us->srb together with the TIMED_OUT, RESETTING, and ABORTING
> -	 * bits are protected by the host lock. */
> -	scsi_lock(us_to_host(us));
> +	if (us->protocol != US_PR_UASP) {
> +		/* us->srb together with the TIMED_OUT, RESETTING, and
> +		 * ABORTING bits are protected by the host lock.
> +		 */
> +		scsi_lock(us_to_host(us));
>  
> -	/* Is this command still active? */
> -	if (us->srb != srb) {
> +		/* Is this command still active? */
> +		if (us->srb != srb) {
> +			scsi_unlock(us_to_host(us));
> +			US_DEBUGP("-- nothing to abort\n");
> +			return FAILED;
> +		}
> +		/* Set the TIMED_OUT bit.  Also set the ABORTING bit, but only
> +		 * if a device reset isn't already in progress (to avoid
> +		 * interfering with the reset). Note that we must retain the
> +		 * host lock while calling usb_stor_stop_transport();
> +		 * otherwise it might interfere with an auto-reset that
> +		 * begins as soon as we release the lock.
> +		 */
> +		set_bit(US_FLIDX_TIMED_OUT, &us->dflags);
> +		if (!test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +			set_bit(US_FLIDX_ABORTING, &us->dflags);
> +			usb_stor_stop_transport(us);
> +		}
>  		scsi_unlock(us_to_host(us));
> -		US_DEBUGP ("-- nothing to abort\n");
> -		return FAILED;
> -	}
> -
> -	/* Set the TIMED_OUT bit.  Also set the ABORTING bit, but only if
> -	 * a device reset isn't already in progress (to avoid interfering
> -	 * with the reset).  Note that we must retain the host lock while
> -	 * calling usb_stor_stop_transport(); otherwise it might interfere
> -	 * with an auto-reset that begins as soon as we release the lock. */
> -	set_bit(US_FLIDX_TIMED_OUT, &us->dflags);
> -	if (!test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +	} else {
> +		/* If we are disconnecting */
> +		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
> +			return FAILED;
> +
> +		/* If reset bit is set */
> +		if (test_bit(US_FLIDX_RESETTING, &us->dflags))
> +			return FAILED;
> +
> +		spin_lock_irqsave(&us->lock, flags);
> +		cmdiu = find_cmd_by_ptr(us, srb);
> +		spin_unlock_irqrestore(&us->lock, flags);
> +		/* Is this command still active? */
> +		if (!cmdiu)
> +			return FAILED;
> +
> +		spin_lock_irqsave(&us->lock, flags);
> +		memset(us->abort_task_tmf, 0, TM_FUNCTION_IU_SIZE);
> +		us->abort_task_tmf->cmdiu = cmdiu;
> +		us->abort_task_tmf->tm_iu_id = IU_ID_TASK_MANAGEMENT;
> +		us->abort_task_tmf->ipt_tag = cpu_to_be16(usb_stor_get_tag(us));
> +		us->abort_task_tmf->tm_function = TM_FUNCTION_ABORT_TASK;
> +		us->abort_task_tmf->task_tag = cmdiu->ipt_tag;
> +		memcpy(us->abort_task_tmf->lun, cmdiu->lun, 8);
> +		us->abort_task_tmf->state = COMMAND_STATE_IDLE;
>  		set_bit(US_FLIDX_ABORTING, &us->dflags);
> -		usb_stor_stop_transport(us);
> +		spin_unlock_irqrestore(&us->lock, flags);
> +
> +		wake_up(&us->uasp_wq);
>  	}
> -	scsi_unlock(us_to_host(us));
>  
>  	/* Wait for the aborted command to finish */
>  	wait_for_completion(&us->notify);
> +
>  	return SUCCESS;
>  }
>  
> diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
> index 589f6b4..e24a02f 100644
> --- a/drivers/usb/storage/transport.c
> +++ b/drivers/usb/storage/transport.c
> @@ -175,7 +175,7 @@ static int usb_stor_msg_common(struct us_data *us, int timeout)
>  	/* wait for the completion of the URB */
>  	timeleft = wait_for_completion_interruptible_timeout(
>  			&urb_done, timeout ? : MAX_SCHEDULE_TIMEOUT);
> - 
> +
>  	clear_bit(US_FLIDX_URB_ACTIVE, &us->dflags);
>  
>  	if (timeleft <= 0) {
> @@ -1305,3 +1305,1269 @@ int usb_stor_port_reset(struct us_data *us)
>  	}
>  	return result;
>  }
> +
> +void usb_stor_transfer_UASP_sglist(struct work_struct *work)
> +{
> +	struct stor_sg_req *sg_req = container_of(work,
> +						  struct stor_sg_req,
> +						  work);
> +	struct us_data *us = sg_req->us;
> +	struct cmd_iu *cmdiu = sg_req->cmdiu;
> +	unsigned int pipe = cmdiu->cmd->sc_data_direction == DMA_FROM_DEVICE ?
> +				us->recv_bulk_pipe : us->send_bulk_pipe;
> +	unsigned long flags;
> +	int tag;
> +	int i;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	/* The command is aborted by abort task or reset nexus */
> +	if (cmdiu->state == COMMAND_STATE_ABORTED)
> +		goto ret;
> +
> +	/* The command is halted by abort task or reset nexus */
> +	if (cmdiu->state == COMMAND_STATE_HALTED)
> +		goto ret;
> +
> +	/* Sense iu received earlier */
> +	if (cmdiu->state == COMMAND_STATE_STATUS)
> +		goto ret;
> +
> +	/* Disconnect bit is set */
> +	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
> +		goto ret;
> +
> +	/* Reset bit is set */
> +	if (test_bit(US_FLIDX_RESETTING, &us->dflags))
> +		goto ret;
> +
> +	sg_req->result = usb_sg_init(&sg_req->sg_req,
> +				     us->pusb_dev,
> +				     pipe,
> +				     0,
> +				     scsi_sglist(cmdiu->cmd),
> +				     scsi_sg_count(cmdiu->cmd),
> +				     scsi_bufflen(cmdiu->cmd),
> +				     GFP_NOIO);
> +
> +	if (sg_req->result)
> +		goto ret;
> +
> +	 /*
> +	  * workaround for setting stream_id for each urb of sg_request,
> +	  * this should be implemented in usbcore driver.
> +	  */
> +	tag = be16_to_cpu(cmdiu->ipt_tag);
> +	for (i = 0; i < sg_req->sg_req.entries; i++)
> +		sg_req->sg_req.urbs[i]->stream_id = tag;
> +
> +	/* wait for the completion of the transfer */
> +	usb_sg_wait(&sg_req->sg_req);
> +	scsi_set_resid(cmdiu->cmd, scsi_bufflen(cmdiu->cmd) -
> +						sg_req->sg_req.bytes);
> +
> +ret:
> +	spin_lock_irqsave(&us->lock, flags);
> +	/* This means that status received earlier with error code */
> +	if (cmdiu->state == COMMAND_STATE_STATUS)
> +		cmdiu->iobuf_sts = REQ_COMPLETED;
> +
> +	cmdiu->sgreq_sts = REQ_COMPLETED;
> +
> +	us->active_requests--;
> +	us->pending_requests++;
> +	spin_unlock_irqrestore(&us->lock, flags);
> +
> +	wake_up(&us->uasp_wq);
> +}
> +
> +static int usb_stor_transfer_UASP_buf(struct us_data *us,
> +				unsigned int pipe,
> +				struct urb *cur_urb,
> +				struct stor_iobuf *iobuf,
> +				unsigned int length,
> +				unsigned short stream_id,
> +				void (*urb_complete)(struct urb *urb),
> +				void *context)
> +{
> +	int result;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	/* fill and submit the URB */
> +	usb_fill_bulk_urb(cur_urb,
> +			us->pusb_dev,
> +			pipe,
> +			iobuf->buf,
> +			length,
> +			urb_complete,
> +			context);
> +
> +	/* fill the common fields in the URB */
> +	cur_urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
> +	cur_urb->transfer_dma = iobuf->dma;
> +	cur_urb->actual_length = 0;
> +	cur_urb->error_count = 0;
> +	cur_urb->status = 0;
> +	cur_urb->stream_id = stream_id;
> +
> +	/* submit the URB */
> +	result = usb_submit_urb(cur_urb, GFP_NOIO);
> +	if (result)
> +		return result;
> +
> +	return 0;
> +}
> +
> +static void usb_stor_cmd_urb_complete(struct urb *urb)
> +{
> +	unsigned long flags;
> +	struct cmd_iu *cmdiu = urb->context;
> +	struct us_data *us = cmdiu->us;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	us->command_pipe_sts = COMMAND_PIPE_IDLE;
> +
> +	spin_lock_irqsave(&us->lock, flags);
> +	cmdiu->iobuf_sts = REQ_COMPLETED;
> +	us->active_requests--;
> +	us->pending_requests++;
> +	spin_unlock_irqrestore(&us->lock, flags);
> +
> +	wake_up(&us->uasp_wq);
> +}
> +
> +static void usb_stor_status_urb_complete(struct urb *urb)
> +{
> +	unsigned long flags;
> +	struct cmd_iu *cmdiu = urb->context;
> +	struct us_data *us = cmdiu->us;
> +	struct s_iu *siu = (struct s_iu *)cmdiu->iobuf->buf;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	spin_lock_irqsave(&us->lock, flags);
> +	/*
> +	 * Everything is correct. If status completes earlier than data,
> +	 * just wait for data completion.
> +	 */
> +	if (!urb->status && siu->status == STATUS_GOOD)
> +		;
> +	/* The urb is completed with error,
> +	 * or the sense iu status is not good.
> +	 * Change cmdiu->state to COMMAND_STATE_STATUS.
> +	 */
> +	else {
> +		/* Command is
> +		 * halted
> +		 * aborted
> +		 * reset or
> +		 * disconnect bit is set.
> +		 */
> +		if (cmdiu->state == COMMAND_STATE_ABORTED ||
> +		    cmdiu->state == COMMAND_STATE_HALTED ||
> +		    test_bit(US_FLIDX_RESETTING, &us->dflags) ||
> +		    test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
> +			;
> +		else
> +			cmdiu->state = COMMAND_STATE_STATUS;
> +	}
> +
> +	cmdiu->iobuf_sts = REQ_COMPLETED;
> +	us->active_requests--;
> +	us->pending_requests++;
> +	spin_unlock_irqrestore(&us->lock, flags);
> +
> +	wake_up(&us->uasp_wq);
> +}
> +
> +static struct cmd_iu *usb_stor_find_cmd_iu_by_tag(
> +					struct list_head *scsi_cmnd_queue,
> +					__u16 ipt_tag)
> +{
> +	struct cmd_iu *cmdiu = 0;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	list_for_each_entry(cmdiu, scsi_cmnd_queue, node)
> +		if (cmdiu->ipt_tag == ipt_tag)
> +			return cmdiu;
> +
> +	return 0;
> +}
> +
> +static struct stor_iobuf *usb_stor_get_iobuf(struct us_data *us)
> +{
> +	int i;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	for (i = 0; i < MAX_IOBUF_COUNT; i++) {
> +		if (us->iobufs[i].sts == STOR_IOBUF_STATE_FREE) {
> +			us->iobufs[i].sts = STOR_IOBUF_STATE_BUSY;
> +			return &us->iobufs[i];
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct stor_urb *usb_stor_get_urb(struct us_data *us)
> +{
> +	int i;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	for (i = 0; i < MAX_URB_COUNT; i++) {
> +		if (us->urbs[i].sts == STOR_URB_STATE_FREE) {
> +			us->urbs[i].sts = STOR_URB_STATE_BUSY;
> +			return &us->urbs[i];
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct stor_sg_req *usb_stor_get_sg_req(struct us_data *us)
> +{
> +	int i;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	for (i = 0; i < MAX_SG_REQ_COUNT; i++) {
> +		if (us->sg_reqs[i].sts == STOR_SG_REQ_STATE_FREE) {
> +			us->sg_reqs[i].sts = STOR_SG_REQ_STATE_BUSY;
> +			return &us->sg_reqs[i];
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void usb_stor_update_scsi_cmnd_queue(struct us_data *us)
> +{
> +	struct cmd_iu *cmdiu1;
> +	struct cmd_iu *cmdiu2;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	list_for_each_entry_safe(cmdiu1, cmdiu2,
> +				&us->temp_scsi_cmnd_queue, node) {
> +		list_del(&cmdiu1->node);
> +		list_add_tail(&cmdiu1->node, &us->scsi_cmnd_queue);
> +	}
> +}
> +
> +static int usb_stor_check_scsi_cmnd(struct us_data *us, struct cmd_iu *cmdiu)
> +{
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	/* Reject the command if the direction indicator is UNKNOWN */
> +	if (cmdiu->cmd->sc_data_direction == DMA_BIDIRECTIONAL) {
> +		US_DEBUGP("%s - UNKNOWN data direction\n", __func__);
> +		cmdiu->cmd->result = DID_ERROR << 16;
> +		return -1;
> +	}
> +	/* Reject if target != 0 */
> +	else if (cmdiu->cmd->device->id) {
> +		US_DEBUGP("%s - Bad target number (%d:%d)\n",
> +			  __func__,
> +			  cmdiu->cmd->device->id,
> +			  cmdiu->cmd->device->lun);
> +		cmdiu->cmd->result = DID_BAD_TARGET << 16;
> +		return -1;
> +	}
> +	/* or if LUN is higher than the maximum known LUN */
> +	else if (cmdiu->cmd->device->lun > us->max_lun) {
> +		US_DEBUGP("%s - Bad LUN (%d:%d)\n",
> +			  __func__,
> +			  cmdiu->cmd->device->id,
> +			  cmdiu->cmd->device->lun);
> +		cmdiu->cmd->result = DID_BAD_TARGET << 16;
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int usb_stor_process_scsi_cmnd(struct us_data *us, struct cmd_iu *cmdiu)
> +{
> +	unsigned int transfer_length;
> +	unsigned int pipe;
> +	unsigned long flags;
> +	int result = 0;
> +	int status = 0;
> +	struct s_iu *siu = NULL;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +start:
> +	switch (cmdiu->state) {
> +	case COMMAND_STATE_IDLE:
> +		/* If the command is incorrest */
> +		if (usb_stor_check_scsi_cmnd(us, cmdiu)) {
> +			scsi_lock(us_to_host(us));
> +			cmdiu->cmd->scsi_done(cmdiu->cmd);
> +			cmdiu->iobuf->sts = STOR_IOBUF_STATE_FREE;
> +			cmdiu->urb->sts = STOR_URB_STATE_FREE;
> +			cmdiu->sg_req->sts = STOR_SG_REQ_STATE_FREE;
> +			list_del(&cmdiu->node);
> +			kfree(cmdiu);
> +			scsi_unlock(us_to_host(us));
> +			return result;
> +		}
> +
> +		/* Move to command state */
> +		cmdiu->state = COMMAND_STATE_COMMAND;
> +		cmdiu->iobuf_sts = REQ_NOT_SUBMITTED;
> +		cmdiu->sgreq_sts = REQ_NOT_SUBMITTED;
> +		goto start;
> +
> +	case COMMAND_STATE_COMMAND:
> +		/* Create the command buffer and submit the urb */
> +		if (cmdiu->iobuf_sts == REQ_NOT_SUBMITTED) {
> +			us->command_pipe_sts = COMMAND_PIPE_BUSY;
> +			memcpy(cmdiu->iobuf->buf,
> +			       (unsigned char *)cmdiu,
> +			       COMMAND_IU_SIZE);
> +
> +			status = usb_stor_transfer_UASP_buf(us,
> +						us->command_pipe,
> +						cmdiu->urb->req,
> +						cmdiu->iobuf,
> +						COMMAND_IU_SIZE,
> +						0,
> +						usb_stor_cmd_urb_complete,
> +						cmdiu);
> +
> +			if (status) {
> +				us->command_pipe_sts = COMMAND_PIPE_IDLE;
> +				cmdiu->state = COMMAND_STATE_COMPLETED;
> +				result = interpret_urb_result(us,
> +					us->command_pipe,
> +					COMMAND_IU_SIZE,
> +					status,
> +					cmdiu->urb->req->actual_length);
> +			} else {
> +				spin_lock_irqsave(&us->lock, flags);
> +				us->active_requests++;
> +
> +				if (cmdiu->iobuf_sts == REQ_NOT_SUBMITTED) {
> +					US_DEBUGP("%s URB is not completed\n",
> +						__func__);
> +					cmdiu->iobuf_sts = REQ_IN_PROGRESS;
> +				} else {
> +					US_DEBUGP("%s URB is completed\n",
> +						__func__);
> +				}
> +				spin_unlock_irqrestore(&us->lock, flags);
> +			}
> +		}
> +		/* Do nothing if the submitted urb is in progress */
> +		else if (cmdiu->iobuf_sts == REQ_IN_PROGRESS)
> +			;
> +		/* Submitted urb is completed
> +		 * 1. Check for errors, if any, return it.
> +		 * 2. If no any error move to the data or status stage.
> +		 */
> +		else if (cmdiu->iobuf_sts == REQ_COMPLETED) {
> +			transfer_length = scsi_bufflen(cmdiu->cmd);
> +
> +			result = interpret_urb_result(us,
> +					us->command_pipe,
> +					COMMAND_IU_SIZE,
> +					cmdiu->urb->req->status,
> +					cmdiu->urb->req->actual_length);
> +
> +			cmdiu->iobuf_sts = REQ_NOT_SUBMITTED;
> +
> +			if (result == USB_STOR_XFER_GOOD) {
> +				if (transfer_length)
> +					cmdiu->state = COMMAND_STATE_DATA;
> +				else
> +					cmdiu->state = COMMAND_STATE_STATUS;
> +
> +				goto start;
> +			} else
> +				cmdiu->state = COMMAND_STATE_COMPLETED;
> +		}
> +		break;
> +
> +	case COMMAND_STATE_DATA:
> +		if (cmdiu->sgreq_sts == REQ_NOT_SUBMITTED) {
> +			/* Run work, which will process the sg request */
> +			cmdiu->sgreq_sts = REQ_IN_PROGRESS;
> +			queue_work(us->sg_wq, &cmdiu->sg_req->work);
> +
> +			spin_lock_irqsave(&us->lock, flags);
> +			us->active_requests++;
> +			spin_unlock_irqrestore(&us->lock, flags);
> +
> +			/*
> +			 * Submit buffer on status endpoint too,
> +			 * maybe device will response with error
> +			 * status and not start the data stage.
> +			 */
> +			status = usb_stor_transfer_UASP_buf(us,
> +						us->status_pipe,
> +						cmdiu->urb->req,
> +						cmdiu->iobuf,
> +						SENSE_IU_SIZE,
> +						be16_to_cpu(cmdiu->ipt_tag),
> +						usb_stor_status_urb_complete,
> +						cmdiu);
> +
> +			if (status) {
> +				result = interpret_urb_result(us,
> +					us->status_pipe,
> +					SENSE_IU_SIZE,
> +					status,
> +					cmdiu->urb->req->actual_length);
> +			} else {
> +				spin_lock_irqsave(&us->lock, flags);
> +				if (cmdiu->iobuf_sts == REQ_NOT_SUBMITTED) {
> +					US_DEBUGP("%s URB is not completed\n",
> +						__func__);
> +					cmdiu->iobuf_sts = REQ_IN_PROGRESS;
> +				} else
> +					US_DEBUGP("%s URB is completed\n",
> +						__func__);
> +
> +				us->active_requests++;
> +				spin_unlock_irqrestore(&us->lock, flags);
> +			}
> +		}
> +		/* Do nothing if the submitted sg_req is in progress */
> +		else if (cmdiu->sgreq_sts == REQ_IN_PROGRESS)
> +			;
> +		/* Submitted sg_req is completed
> +		 * 1. Check for errors, if any, return it.
> +		 * 2. If no any error move to status stage.
> +		 */
> +		else if (cmdiu->sgreq_sts == REQ_COMPLETED) {
> +			pipe = cmdiu->cmd->sc_data_direction ==
> +				DMA_FROM_DEVICE ? us->recv_bulk_pipe :
> +				us->send_bulk_pipe;
> +			transfer_length = scsi_bufflen(cmdiu->cmd);
> +			cmdiu->sgreq_sts = REQ_NOT_SUBMITTED;
> +
> +			if (cmdiu->sg_req->result)
> +				result = USB_STOR_XFER_ERROR;
> +			else {
> +				result = interpret_urb_result(us,
> +						pipe,
> +						transfer_length,
> +						cmdiu->sg_req->sg_req.status,
> +						cmdiu->sg_req->sg_req.bytes);
> +
> +				if (result == USB_STOR_XFER_ERROR) {
> +					result = USB_STOR_TRANSPORT_ERROR;
> +				} else {
> +					result = USB_STOR_XFER_GOOD;
> +					cmdiu->state = COMMAND_STATE_STATUS;
> +					goto start;
> +				}
> +			}
> +		}
> +		break;
> +
> +	case COMMAND_STATE_STATUS:
> +		if (cmdiu->iobuf_sts == REQ_NOT_SUBMITTED) {
> +			status = usb_stor_transfer_UASP_buf(us,
> +						us->status_pipe,
> +						cmdiu->urb->req,
> +						cmdiu->iobuf,
> +						SENSE_IU_SIZE,
> +						be16_to_cpu(cmdiu->ipt_tag),
> +						usb_stor_status_urb_complete,
> +						cmdiu);
> +
> +			if (status) {
> +				result = interpret_urb_result(us,
> +					us->status_pipe,
> +					SENSE_IU_SIZE,
> +					status,
> +					cmdiu->urb->req->actual_length);
> +			} else {
> +				spin_lock_irqsave(&us->lock, flags);
> +				if (cmdiu->iobuf_sts == REQ_NOT_SUBMITTED) {
> +					US_DEBUGP("%s URB is not completed\n",
> +						__func__);
> +					cmdiu->iobuf_sts = REQ_IN_PROGRESS;
> +				} else
> +					US_DEBUGP("%s URB is completed\n",
> +						__func__);
> +
> +				us->active_requests++;
> +				spin_unlock_irqrestore(&us->lock, flags);
> +			}
> +		} else if (cmdiu->iobuf_sts == REQ_IN_PROGRESS)
> +			;
> +		else if (cmdiu->iobuf_sts == REQ_COMPLETED) {
> +			/*
> +			 * Sense iu received before DATA stage,
> +			 * that means something goes wrong on device side
> +			 */
> +			spin_lock_irqsave(&us->lock, flags);
> +			if (cmdiu->sgreq_sts == REQ_IN_PROGRESS) {
> +				US_DEBUGP("%s Sense IU completes early\n",
> +					__func__);
> +				siu = (struct s_iu *)cmdiu->iobuf->buf;
> +
> +				/* Sense iu with error. Cancel sg_list on the
> +				 * data pipe. After the sg_list proper
> +				 * cancelation return to the status stage and
> +				 * complete the command.
> +				 */
> +				if (!cmdiu->urb->req->status &&
> +				     siu->status != STATUS_GOOD)
> +					cmdiu->iobuf_sts = REQ_IN_PROGRESS;
> +
> +				spin_unlock_irqrestore(&us->lock, flags);
> +				US_DEBUGP("%s Cancelling sg request\n",
> +					__func__);
> +				usb_sg_cancel(&cmdiu->sg_req->sg_req);
> +
> +				if (!cmdiu->urb->req->status)
> +					break;
> +
> +				spin_lock_irqsave(&us->lock, flags);
> +			}
> +			spin_unlock_irqrestore(&us->lock, flags);
> +
> +			result = interpret_urb_result(us,
> +						us->command_pipe,
> +						SENSE_IU_SIZE,
> +						cmdiu->urb->req->status,
> +						cmdiu->urb->req->actual_length);
> +
> +			cmdiu->iobuf_sts = REQ_NOT_SUBMITTED;
> +			cmdiu->state = COMMAND_STATE_COMPLETED;
> +
> +			if (result == USB_STOR_XFER_GOOD)
> +				goto start;
> +		}
> +		break;
> +
> +	case COMMAND_STATE_COMPLETED:
> +		scsi_lock(us_to_host(us));
> +		siu = (struct s_iu *)cmdiu->iobuf->buf;
> +
> +		/* Status is GOOD */
> +		if (siu->status == STATUS_GOOD)
> +			cmdiu->cmd->result = SAM_STAT_GOOD;
> +		/* Status is CHECK CONDITION. Provide with the sense data */
> +		else if (siu->status == STATUS_CHECK_CONDITION) {
> +			memset(cmdiu->cmd->sense_buffer, 0, 18);
> +			cmdiu->cmd->sense_buffer[0] = 0x70;
> +			cmdiu->cmd->sense_buffer[2] = siu->sense_data[0];
> +			cmdiu->cmd->sense_buffer[7] = 10;
> +			cmdiu->cmd->sense_buffer[12] = siu->sense_data[1];
> +			cmdiu->cmd->sense_buffer[13] = siu->sense_data[2];
> +			cmdiu->cmd->result = SAM_STAT_CHECK_CONDITION;
> +		}
> +
> +		cmdiu->cmd->scsi_done(cmdiu->cmd);
> +		cmdiu->iobuf->sts = STOR_IOBUF_STATE_FREE;
> +		cmdiu->urb->sts = STOR_URB_STATE_FREE;
> +		cmdiu->sg_req->sts = STOR_SG_REQ_STATE_FREE;
> +		list_del(&cmdiu->node);
> +		kfree(cmdiu);
> +		scsi_unlock(us_to_host(us));
> +		break;
> +
> +	case COMMAND_STATE_ABORTED:
> +		/* If the command is aborted, we should not call scsi_done() */
> +		if (cmdiu->iobuf)
> +			cmdiu->iobuf->sts = STOR_IOBUF_STATE_FREE;
> +		if (cmdiu->urb)
> +			cmdiu->urb->sts = STOR_URB_STATE_FREE;
> +		if (cmdiu->sg_req)
> +			cmdiu->sg_req->sts = STOR_SG_REQ_STATE_FREE;
> +
> +		list_del(&cmdiu->node);
> +		kfree(cmdiu);
> +		break;
> +
> +	default:
> +		US_DEBUGP("%s - Unknown cmdiu->state %d!\n",
> +			__func__,
> +			cmdiu->state);
> +	}
> +
> +	return result;
> +}
> +
> +unsigned int usb_stor_get_tag(struct us_data *us)
> +{
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	us->tag++;
> +	if (us->tag >  USB_STOR_NUM_STREAMS)
> +		us->tag = 0;
> +
> +	if (!us->tag)
> +		us->tag++;
> +
> +	return us->tag;
> +}
> +
> +int usb_stor_UASP_transport(struct scsi_cmnd *srb, struct us_data *us)
> +{
> +	struct cmd_iu *cmdiu1;
> +	struct cmd_iu *cmdiu2;
> +	unsigned long flags;
> +	int cmd_is_active = 0;
> +	int result = 0;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	spin_lock_irqsave(&us->lock, flags);
> +	us->pending_requests = 0;
> +	us->new_command = 0;
> +	spin_unlock_irqrestore(&us->lock, flags);
> +
> +	/* Move commands from temp_scsi_cmnd_queue to scsi_cmnd_queue */
> +	spin_lock_irqsave(&us->lock, flags);
> +	usb_stor_update_scsi_cmnd_queue(us);
> +	spin_unlock_irqrestore(&us->lock, flags);
> +
> +	list_for_each_entry_safe(cmdiu1, cmdiu2, &us->scsi_cmnd_queue, node) {
> +		/* Disconnect bit is set */
> +		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +			US_DEBUGP("%s Disconnect bit is set\n", __func__);
> +			break;
> +		}
> +
> +		/* Reset bit is set */
> +		if (test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +			US_DEBUGP("%s Reset bit is set\n", __func__);
> +			break;
> +		}
> +
> +		/* If command state is idle */
> +		if (cmdiu1->state == COMMAND_STATE_IDLE) {
> +			/* If command pipe is busy */
> +			if (us->command_pipe_sts == COMMAND_PIPE_BUSY) {
> +				/* We have an unprocessed command */
> +				spin_lock_irqsave(&us->lock, flags);
> +				us->new_command = 1;
> +				spin_unlock_irqrestore(&us->lock, flags);
> +				continue;
> +			}
> +
> +			/* Tries to get buffer for this cmdiu */
> +			cmdiu1->iobuf = usb_stor_get_iobuf(us);
> +			if (cmdiu1->iobuf == 0)
> +				continue;
> +
> +			/* Tries to get urb for this cmdiu */
> +			cmdiu1->urb = usb_stor_get_urb(us);
> +			if (cmdiu1->urb == 0) {
> +				cmdiu1->iobuf->sts = STOR_IOBUF_STATE_FREE;
> +				continue;
> +			}
> +
> +			/* Tries to sg request for this cmdiu */
> +			cmdiu1->sg_req = usb_stor_get_sg_req(us);
> +			if (cmdiu1->sg_req == 0) {
> +				cmdiu1->iobuf->sts = STOR_IOBUF_STATE_FREE;
> +				cmdiu1->urb->sts = STOR_URB_STATE_FREE;
> +				continue;
> +			} else {
> +				cmdiu1->sg_req->cmdiu = cmdiu1;
> +				cmdiu1->sg_req->us = us;
> +			}
> +		}
> +		/*
> +		 * The processing of the command is halted because
> +		 * of abort task or reset nexus task management
> +		 * function processing
> +		 */
> +		if (cmdiu1->state == COMMAND_STATE_HALTED)
> +			continue;
> +
> +		/*
> +		 * Workaround - not perform other queued commands while
> +		 * curretn is active
> +		 */
> +		if (cmdiu1->state == COMMAND_STATE_COMMAND &&
> +		    cmdiu1->iobuf_sts == REQ_COMPLETED &&
> +		    cmd_is_active) {
> +			US_DEBUGP("%s - Command is sent to device, but " \
> +				"other command still active\n", __func__);
> +			continue;
> +		}
> +
> +		result = usb_stor_process_scsi_cmnd(us, cmdiu1);
> +		if (result)
> +			break;
> +
> +		if (cmdiu1->state == COMMAND_STATE_DATA ||
> +		    cmdiu1->state == COMMAND_STATE_STATUS) {
> +			cmd_is_active = 1;
> +			US_DEBUGP("%s - There is an active command\n",
> +				__func__);
> +		}
> +	}
> +
> +	return result;
> +}
> +
> +static void usb_stor_abort_task_urb_complete(struct urb *urb)
> +{
> +	unsigned long flags;
> +	struct us_data *us = urb->context;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	us->abort_task_tmf->req_sts = REQ_COMPLETED;
> +
> +	spin_lock_irqsave(&us->lock, flags);
> +	us->active_requests--;
> +	us->pending_requests++;
> +	spin_unlock_irqrestore(&us->lock, flags);
> +
> +	wake_up(&us->uasp_wq);
> +}
> +
> +static int usb_stor_abort_task(struct us_data *us)
> +{
> +	int status;
> +	int result = USB_STOR_TRANSPORT_GOOD;
> +	unsigned long flags;
> +	struct cmd_iu *cmdiu;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	if (us->abort_task_tmf->state == COMMAND_STATE_COMMAND ||
> +		us->abort_task_tmf->state == COMMAND_STATE_STATUS)
> +		goto start;
> +
> +	/* Try to find the command again */
> +	scsi_lock(us_to_host(us));
> +	usb_stor_update_scsi_cmnd_queue(us);
> +	scsi_unlock(us_to_host(us));
> +	cmdiu = usb_stor_find_cmd_iu_by_tag(
> +					&us->scsi_cmnd_queue,
> +					us->abort_task_tmf->task_tag);
> +
> +	/*
> +	 * Command IU is not found, notify to SCSI layer
> +	 * that abort is done
> +	 */
> +	if (cmdiu == NULL) {
> +		US_DEBUGP("%s Command is not found\n", __func__);
> +		us->abort_task_tmf->state = COMMAND_STATE_COMPLETED;
> +		clear_bit(US_FLIDX_ABORTING, &us->dflags);
> +		complete(&us->notify);
> +		return result;
> +	}
> +
> +	/*
> +	 * The processing of the Command IU is not started yet,
> +	 * or is finished, or aborted. Notify to SCSI layer that"
> +	 * abort is done.
> +	 */
> +	if (cmdiu->state == COMMAND_STATE_IDLE ||
> +	    cmdiu->state == COMMAND_STATE_COMPLETED ||
> +	    cmdiu->state == COMMAND_STATE_ABORTED) {
> +		US_DEBUGP("%s Processing of the command is finished\n",
> +			  __func__);
> +		cmdiu->state = COMMAND_STATE_ABORTED;
> +		us->abort_task_tmf->state = COMMAND_STATE_COMPLETED;
> +		clear_bit(US_FLIDX_ABORTING, &us->dflags);
> +		complete(&us->notify);
> +		return result;
> +	}
> +
> +	/* Get buffer for processing */
> +	us->abort_task_tmf->iobuf = usb_stor_get_iobuf(us);
> +	if (us->abort_task_tmf->iobuf == 0)
> +		return result;
> +
> +	/* Get urb for processing */
> +	us->abort_task_tmf->urb = usb_stor_get_urb(us);
> +	if (us->abort_task_tmf->urb == 0) {
> +		us->abort_task_tmf->iobuf->sts = STOR_IOBUF_STATE_FREE;
> +		return result;
> +	}
> +
> +	/* If the command pipe is busy, wait for idle */
> +	if (us->command_pipe_sts == COMMAND_PIPE_BUSY) {
> +		US_DEBUGP("%s Waiting for command pipe idle\n", __func__);
> +		wait_event(us->uasp_wq,
> +			(us->command_pipe_sts == COMMAND_PIPE_IDLE));
> +	}
> +
> +	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +		US_DEBUGP("%s Disconnect bit is set\n", __func__);
> +		return result;
> +	}
> +
> +	if (test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +		US_DEBUGP("%s Reset bit is set\n", __func__);
> +		return result;
> +	}
> +
> +	us->abort_task_tmf->state = COMMAND_STATE_COMMAND;
> +	us->abort_task_tmf->req_sts = REQ_NOT_SUBMITTED;
> +
> +start:
> +	switch (us->abort_task_tmf->state) {
> +	case COMMAND_STATE_COMMAND:
> +		US_DEBUGP("%s Command state\n", __func__);
> +		if (us->abort_task_tmf->req_sts == REQ_NOT_SUBMITTED) {
> +			spin_lock_irqsave(&us->lock, flags);
> +			us->abort_task_tmf->cmdiu->state =
> +						COMMAND_STATE_HALTED;
> +			spin_unlock_irqrestore(&us->lock, flags);
> +
> +			/* Send abort task tmf to device */
> +			memcpy(us->abort_task_tmf->iobuf->buf,
> +				(void *)us->abort_task_tmf,
> +				TM_FUNCTION_IU_SIZE);
> +
> +			us->command_pipe_sts = COMMAND_PIPE_BUSY;
> +			status = usb_stor_transfer_UASP_buf(us,
> +					us->command_pipe,
> +					us->abort_task_tmf->urb->req,
> +					us->abort_task_tmf->iobuf,
> +					TM_FUNCTION_IU_SIZE,
> +					0,
> +					usb_stor_abort_task_urb_complete,
> +					us);
> +
> +			/* Something went wrong, need to reset */
> +			if (status) {
> +				us->command_pipe_sts = COMMAND_PIPE_IDLE;
> +				result = interpret_urb_result(us,
> +					us->command_pipe,
> +					TM_FUNCTION_IU_SIZE,
> +					status,
> +					us->abort_task_tmf->urb->req->
> +					actual_length);
> +
> +				us->abort_task_tmf->iobuf->sts =
> +						STOR_IOBUF_STATE_FREE;
> +				us->abort_task_tmf->urb->sts =
> +						STOR_URB_STATE_FREE;
> +			} else {
> +				spin_lock_irqsave(&us->lock, flags);
> +				if (us->abort_task_tmf->req_sts ==
> +							REQ_NOT_SUBMITTED) {
> +					US_DEBUGP("%s URB is not completed\n",
> +								__func__);
> +					us->abort_task_tmf->req_sts =
> +							REQ_IN_PROGRESS;
> +				} else
> +					US_DEBUGP("%s URB is completed\n",
> +								__func__);
> +
> +				us->active_requests++;
> +				spin_unlock_irqrestore(&us->lock, flags);
> +			}
> +		} else if (us->abort_task_tmf->req_sts == REQ_IN_PROGRESS)
> +			;
> +		else if (us->abort_task_tmf->req_sts == REQ_COMPLETED) {
> +			result = interpret_urb_result(us,
> +				us->command_pipe,
> +				TM_FUNCTION_IU_SIZE,
> +				us->abort_task_tmf->urb->req->status,
> +				us->abort_task_tmf->urb->req->actual_length);
> +
> +			/* Something went wrong, need to reset */
> +			if (result) {
> +				us->abort_task_tmf->iobuf->sts =
> +							STOR_IOBUF_STATE_FREE;
> +				us->abort_task_tmf->urb->sts =
> +							STOR_URB_STATE_FREE;
> +			} else {
> +				us->abort_task_tmf->state =
> +							COMMAND_STATE_STATUS;
> +				us->abort_task_tmf->req_sts =
> +							REQ_NOT_SUBMITTED;
> +				goto start;
> +			}
> +		}
> +		break;
> +
> +	case COMMAND_STATE_STATUS:
> +		US_DEBUGP("%s Status state\n", __func__);
> +
> +		if (us->abort_task_tmf->req_sts == REQ_NOT_SUBMITTED) {
> +			status = usb_stor_transfer_UASP_buf(us,
> +					us->status_pipe,
> +					us->abort_task_tmf->urb->req,
> +					us->abort_task_tmf->iobuf,
> +					RESPONSE_IU_SIZE,
> +					be16_to_cpu(us->abort_task_tmf->
> +								ipt_tag),
> +					usb_stor_abort_task_urb_complete,
> +					us);
> +
> +			if (status) {
> +				result = interpret_urb_result(us,
> +					us->status_pipe,
> +					RESPONSE_IU_SIZE,
> +					status,
> +					us->abort_task_tmf->urb->req->
> +							actual_length);
> +
> +				us->abort_task_tmf->iobuf->sts =
> +							STOR_IOBUF_STATE_FREE;
> +				us->abort_task_tmf->urb->sts =
> +							STOR_URB_STATE_FREE;
> +			} else {
> +				spin_lock_irqsave(&us->lock, flags);
> +				if (us->abort_task_tmf->req_sts ==
> +							REQ_NOT_SUBMITTED) {
> +					US_DEBUGP("%s URB is not completed\n",
> +								__func__);
> +					us->abort_task_tmf->req_sts =
> +							REQ_IN_PROGRESS;
> +				} else {
> +					US_DEBUGP("%s URB is completed\n",
> +								__func__);
> +				}
> +				us->active_requests++;
> +				spin_unlock_irqrestore(&us->lock, flags);
> +			}
> +		} else if (us->abort_task_tmf->req_sts == REQ_IN_PROGRESS)
> +			;
> +		else if (us->abort_task_tmf->req_sts == REQ_COMPLETED) {
> +			result = interpret_urb_result(us,
> +					us->status_pipe,
> +					RESPONSE_IU_SIZE,
> +					us->abort_task_tmf->urb->req->status,
> +					us->abort_task_tmf->urb->req->
> +								actual_length);
> +
> +			us->abort_task_tmf->iobuf->sts = STOR_IOBUF_STATE_FREE;
> +			us->abort_task_tmf->urb->sts = STOR_URB_STATE_FREE;
> +
> +			if (!result) {
> +				/*
> +				* Kill all the active requests
> +				* connected to the aborted COMMAND IU
> +				*/
> +				if (us->abort_task_tmf->cmdiu->iobuf_sts ==
> +							REQ_IN_PROGRESS)
> +					usb_kill_urb(us->abort_task_tmf->
> +							cmdiu->urb->req);
> +
> +				if (us->abort_task_tmf->cmdiu->sgreq_sts ==
> +							REQ_IN_PROGRESS)
> +					usb_sg_cancel(&us->abort_task_tmf->
> +							cmdiu->sg_req->sg_req);
> +				/*
> +				 * FIXME maybe here we need to add a mechanism
> +				 * for waiting of the completion of the command
> +				 * related urbs and sg_reqs.
> +				 */
> +				us->abort_task_tmf->state =
> +						COMMAND_STATE_COMPLETED;
> +				clear_bit(US_FLIDX_ABORTING, &us->dflags);
> +				complete(&us->notify);
> +			}
> +		}
> +
> +		break;
> +	}
> +
> +	return result;
> +}
> +
> +void usb_stor_kill_all_requests(struct us_data *us)
> +{
> +	struct cmd_iu *cmdiu;
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	/* Move commands from temp_scsi_cmnd_queue to scsi_cmnd_queue */
> +	scsi_lock(us_to_host(us));
> +	usb_stor_update_scsi_cmnd_queue(us);
> +	scsi_unlock(us_to_host(us));
> +
> +	/* Abort all the commands */
> +	list_for_each_entry(cmdiu, &us->scsi_cmnd_queue, node) {
> +		scsi_lock(us_to_host(us));
> +		cmdiu->state = COMMAND_STATE_ABORTED;
> +		scsi_unlock(us_to_host(us));
> +
> +		/* FIXME do we need this? */
> +		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +			US_DEBUGP("%s Disconnect bit is set\n", __func__);
> +			cmdiu->cmd->result = DID_NO_CONNECT << 16;
> +		}
> +		/* FIXME do we need this? */
> +		if (test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +			US_DEBUGP("%s Reset bit is set\n", __func__);
> +			cmdiu->cmd->result = DID_ERROR << 16;
> +		}
> +		if (cmdiu->iobuf_sts == REQ_IN_PROGRESS) {
> +			US_DEBUGP("%s Kill the active urb\n", __func__);
> +			usb_kill_urb(cmdiu->urb->req);
> +		}
> +		if (cmdiu->sgreq_sts == REQ_IN_PROGRESS) {
> +			US_DEBUGP("%s - Kill the active sg_req\n", __func__);
> +			usb_sg_cancel(&cmdiu->sg_req->sg_req);
> +		}
> +	}
> +	/* If the abort command tm function is in progress, kill it */
> +	us->abort_task_tmf->state = COMMAND_STATE_COMPLETED;
> +
> +	if (us->abort_task_tmf->req_sts == REQ_IN_PROGRESS) {
> +		clear_bit(US_FLIDX_ABORTING, &us->dflags);
> +		usb_kill_urb(us->abort_task_tmf->urb->req);
> +		/* FIXME do we need to notify during reset? */
> +		complete(&us->notify);
> +	}
> +
> +	US_DEBUGP("%s - Waiting for completion for all aborted commands\n",
> +		  __func__);
> +	wait_event(us->uasp_wq, (us->active_requests == 0));
> +}
> +
> +static void usb_stor_complete_reset_nexus(struct urb *urb)
> +{
> +	struct completion *urb_done_ptr = urb->context;
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	complete(urb_done_ptr);
> +}
> +
> +int usb_stor_UASP_reset(struct us_data *us)
> +{
> +	long timeleft;
> +	int tag, result;
> +	struct tm_iu *tmiu;
> +	struct r_iu *riu;
> +	struct stor_iobuf *iobuf;
> +	struct stor_urb *urb;
> +	struct completion urb_done;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +		US_DEBUGP("%s Disconnect bit is set\n", __func__);
> +		return -1;
> +	}
> +
> +	/* Kill all the active requests, and wait for completion */
> +	usb_stor_kill_all_requests(us);
> +
> +	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +		US_DEBUGP("%s Disconnect bit is set\n", __func__);
> +		return -1;
> +	}
> +
> +	/* Get the buffer */
> +	iobuf = usb_stor_get_iobuf(us);
> +	if (!iobuf)
> +		return -1;
> +
> +	/* Get the urb */
> +	urb = usb_stor_get_urb(us);
> +	if (!urb) {
> +		iobuf->sts = STOR_IOBUF_STATE_FREE;
> +		return -1;
> +	}
> +
> +	tag = usb_stor_get_tag(us);
> +
> +	/* Initialize the command buffer */
> +	tmiu = (struct tm_iu *)iobuf->buf;
> +	memset(tmiu, 0, TM_FUNCTION_IU_SIZE);
> +	tmiu->tm_iu_id = IU_ID_TASK_MANAGEMENT;
> +	tmiu->reserved1 = 0;
> +	tmiu->ipt_tag = cpu_to_be16(tag);
> +	tmiu->tm_function = 0;
> +	tmiu->reserved2 = 0;
> +	tmiu->task_tag = 0;
> +	memset(tmiu->lun, 0, 8);
> +
> +	/* Fill the URB */
> +	usb_fill_bulk_urb(urb->req,
> +			  us->pusb_dev,
> +			  us->command_pipe,
> +			  iobuf->buf,
> +			  TM_FUNCTION_IU_SIZE,
> +			  usb_stor_complete_reset_nexus,
> +			  NULL);
> +
> +	init_completion(&urb_done);
> +
> +	/* Fill the common fields in the URB */
> +	urb->req->context = &urb_done;
> +	urb->req->actual_length = 0;
> +	urb->req->error_count = 0;
> +	urb->req->status = 0;
> +	urb->req->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
> +	urb->req->stream_id = 0;
> +	urb->req->transfer_buffer = iobuf->buf;
> +	urb->req->transfer_dma = iobuf->dma;
> +
> +	result = usb_submit_urb(urb->req, GFP_NOIO);
> +	if (result)
> +		goto err;
> +
> +	US_DEBUGP("%s - Waiting for completion of the submitted urb\n",
> +		  __func__);
> +
> +	/* wait for the completion of the URB */
> +	timeleft = wait_for_completion_interruptible_timeout(&urb_done,
> +							MAX_SCHEDULE_TIMEOUT);
> +
> +	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +		US_DEBUGP("%s Disconnect bit is set\n", __func__);
> +		goto err;
> +	}
> +
> +	if (timeleft <= 0) {
> +		usb_kill_urb(us->current_urb);
> +		goto err;
> +	}
> +
> +	if (interpret_urb_result(us,
> +				 us->command_pipe,
> +				 TM_FUNCTION_IU_SIZE,
> +				 result,
> +				 urb->req->actual_length))
> +		goto err;
> +
> +	/* Initialize the response buffer */
> +	riu = (struct r_iu *)iobuf->buf;
> +	memset(riu, 0, RESPONSE_IU_SIZE);
> +
> +	/* Fill the URB */
> +	usb_fill_bulk_urb(urb->req,
> +			  us->pusb_dev,
> +			  us->status_pipe,
> +			  iobuf->buf,
> +			  RESPONSE_IU_SIZE,
> +			  usb_stor_complete_reset_nexus,
> +			  NULL);
> +
> +	init_completion(&urb_done);
> +
> +	/* Fill the common fields in the URB */
> +	urb->req->context = &urb_done;
> +	urb->req->actual_length = 0;
> +	urb->req->error_count = 0;
> +	urb->req->status = 0;
> +	urb->req->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
> +	urb->req->stream_id = tag;
> +	urb->req->transfer_buffer = iobuf->buf;
> +	urb->req->transfer_dma = iobuf->dma;
> +
> +	result = usb_submit_urb(urb->req, GFP_NOIO);
> +	if (result)
> +		goto err;
> +
> +	US_DEBUGP("%s - Waiting for completion of the submitted urb\n",
> +		  __func__);
> +
> +	/* wait for the completion of the URB */
> +	timeleft = wait_for_completion_interruptible_timeout(
> +			&urb_done, MAX_SCHEDULE_TIMEOUT);
> +
> +	if (timeleft <= 0) {
> +		usb_kill_urb(us->current_urb);
> +		goto err;
> +	}
> +
> +	if (interpret_urb_result(us,
> +				 us->command_pipe,
> +				 RESPONSE_IU_SIZE,
> +				 result,
> +				 urb->req->actual_length))
> +		goto err;
> +
> +	iobuf->sts = STOR_IOBUF_STATE_FREE;
> +	urb->sts = STOR_URB_STATE_FREE;
> +	return 0;
> +err:
> +	US_DEBUGP("%s - Error\n", __func__);
> +
> +	iobuf->sts = STOR_IOBUF_STATE_FREE;
> +	urb->sts = STOR_URB_STATE_FREE;
> +	return -1;
> +}
> +
> +int usb_stor_UASP_max_lun(struct us_data *us)
> +{
> +	/*
> +	 * FIXME perform this action properly. REPORT LUNS SCSI command
> +	 * should be performed for getting all LUN related information.
> +	 * Currently on UASP mode assumes, that device is working with
> +	 * one LUN.
> +	 */
> +	us->max_lun = 0;
> +	return 0;
> +}
> +
> +void usb_stor_invoke_UASP_transport(struct us_data *us)
> +{
> +	int result = 0;
> +
> +	US_DEBUGP("%s called\n", __func__);
> +
> +	if (test_bit(US_FLIDX_ABORTING, &us->dflags)) {
> +		US_DEBUGP("%s abort bit is set\n", __func__);
> +		result = usb_stor_abort_task(us);
> +		/* Transport error, do reset */
> +		if (result)
> +			goto reset;
> +	}
> +
> +	/* If Disconnect bit is set */
> +	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +		US_DEBUGP("%s Disconnect bit is set\n", __func__);
> +		return;
> +	}
> +
> +	/* If Reset bit is set */
> +	if (test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +		US_DEBUGP("%s Reset bit is set\n", __func__);
> +		return;
> +	}
> +
> +	result = us->transport(0, us);
> +
> +	/* Transport error, do reset */
> +	if (result) {
> +		/* If Disconnect bit is set */
> +		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +			US_DEBUGP("%s Disconnect bit is set\n", __func__);
> +			return;
> +		}
> +
> +		/* If Reset bit is set */
> +		if (test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +			US_DEBUGP("%s Reset bit is set\n", __func__);
> +			return;
> +		}
> +
> +		US_DEBUGP("%s Goto reset\n", __func__);
> +		goto reset;
> +	}
> +
> +	return;
> +reset:
> +	scsi_lock(us_to_host(us));
> +	set_bit(US_FLIDX_RESETTING, &us->dflags);
> +	scsi_unlock(us_to_host(us));
> +
> +	mutex_unlock(&us->dev_mutex);
> +	result = usb_stor_port_reset(us);
> +	mutex_lock(&us->dev_mutex);
> +
> +	if (result < 0) {
> +		scsi_lock(us_to_host(us));
> +		usb_stor_report_device_reset(us);
> +		scsi_unlock(us_to_host(us));
> +		us->transport_reset(us);
> +	}
> +	clear_bit(US_FLIDX_RESETTING, &us->dflags);
> +}
> diff --git a/drivers/usb/storage/transport.h b/drivers/usb/storage/transport.h
> index 242ff5e..ebb86ed 100644
> --- a/drivers/usb/storage/transport.h
> +++ b/drivers/usb/storage/transport.h
> @@ -113,13 +113,163 @@ struct bulk_cs_wrap {
>  
>  #define US_CBI_ADSC		0
>  
> +/* IU identifier summary */
> +enum iu_id {
> +	IU_ID_COMMAND			= 0x01,
> +	IU_ID_SENSE			= 0x03,
> +	IU_ID_RESPONSE			= 0x04,
> +	IU_ID_TASK_MANAGEMENT		= 0x05,
> +	IU_ID_READ_READY		= 0x06,
> +	IU_ID_WRITE_READY		= 0x07,
> +};
> +
> +/* Task Attribute field */
> +enum task_attribute_data {
> +	TASK_ATTR_SIMPLE		= 0,
> +	TASK_ATTR_HEAD_OF_QUEUE		= 1,
> +	TASK_ATTR_ORDERED		= 2,
> +	TASK_ATTR_ACA			= 4,
> +};
> +
> +/* Command or Task Management Function IU state */
> +enum command_state {
> +	COMMAND_STATE_IDLE		= 0,
> +	COMMAND_STATE_COMMAND		= 1,
> +	COMMAND_STATE_DATA		= 2,
> +	COMMAND_STATE_STATUS		= 3,
> +	COMMAND_STATE_ABORTED		= 4,
> +	COMMAND_STATE_COMPLETED		= 5,
> +	COMMAND_STATE_HALTED		= 6,
> +};
> +
> +#define COMMAND_IU_SIZE		36
> +/* Command IU */
> +struct cmd_iu {
> +	__u8 cmd_iu_id;
> +	__u8 reserved;
> +	__u16 ipt_tag;
> +	__u16 length;
> +
> +	struct {
> +		unsigned int reserved:1;
> +		unsigned int task_priority:4;
> +		unsigned int task_attribute:3;
> +	} b;
> +
> +	__u8 lun[8];
> +	__u8 cdb[16];
> +	__u8 add_cdb[5];
> +
> +	struct scsi_cmnd *cmd;
> +
> +#define REQ_NOT_SUBMITTED	0
> +#define REQ_IN_PROGRESS		1
> +#define REQ_COMPLETED		2
> +	int iobuf_sts;
> +	int sgreq_sts;
> +	int state;
> +
> +	struct stor_iobuf *iobuf;
> +	struct stor_urb *urb;
> +	struct stor_sg_req *sg_req;
> +	struct us_data *us;
> +
> +	struct list_head node;
> +};
> +
> +/* Task Management Function IU types */
> +enum tm_function_data {
> +	TM_FUNCTION_ABORT_TASK			= 0x01,
> +	TM_FUNCTION_ABORT_TASK_SET		= 0x02,
> +	TM_FUNCTION_CLEAR_TASK_SET		= 0x04,
> +	TM_FUNCTION_RESET_LUN			= 0x08,
> +	TM_FUNCTION_IT_NEXUS_RESET		= 0x10,
> +	TM_FUNCTION_CLEAR_ACA			= 0x40,
> +	TM_FUNCTION_QUERY_TASK			= 0x80,
> +	TM_FUNCTION_QUERY_TASK_SET		= 0x81,
> +	TM_FUNCTION_QUERY_UNIT_ATTENTION	= 0x82,
> +};
> +
> +#define TM_FUNCTION_IU_SIZE	16
> +/* Task Management Function IU */
> +struct tm_iu {
> +	__u8 tm_iu_id;
> +	__u8 reserved1;
> +	__u16 ipt_tag;
> +	__u8 tm_function;
> +	__u8 reserved2;
> +	__u16 task_tag;
> +	__u8 lun[8];
> +
> +	struct stor_iobuf *iobuf;
> +	struct stor_urb *urb;
> +	int state;
> +	int req_sts;
> +	struct cmd_iu *cmdiu;
> +
> +	struct list_head node;
> +};
> +
> +/* Status values of Sense IU*/
> +enum status_code_data {
> +	STATUS_GOOD =			0x00,
> +	STATUS_CHECK_CONDITION =	0x02,
> +	STATUS_CONDITION_MET =		0x04,
> +	STATUS_BUSY =			0x08,
> +	STATUS_RESERVATION_CONFLICT =	0x18,
> +	STATUS_TASK_SET_FULL =		0x28,
> +	STATUS_ACA_ACTIVE =		0x30,
> +	STATUS_TASK_ABORTED =		0x40,
> +};
> +
> +#define SENSE_IU_SIZE	13
> +/* Sense IU */
> +struct s_iu {
> +	__u8 s_iu_id;
> +	__u8 reserved1;
> +	__u16 ipt_tag;
> +	__u16 length;
> +	__u8 status;
> +	__u8 reserved2;
> +	__u8 sense_data[5];
> +};
> +
> +/* Status values of Response IU */
> +enum response_code_data {
> +	RESPONSE_TM_FUNCTION_COMPLETE		= 0x00,
> +	RESPONSE_INVALID_IU			= 0x02,
> +	RESPONSE_TM_FUNCTION_NOT_SUPPORTED	= 0x04,
> +	RESPONSE_TM_FUNCTION_FAILED		= 0x05,
> +	RESPONSE_TM_FUNCTION_SUCCEEDED		= 0x08,
> +	RESPONSE_INCORRECT_LUN			= 0x09,
> +	RESPONSE_OVERLAPPED_TAG_ATTEMPTED	= 0x0A,
> +};
> +
> +#define RESPONSE_IU_SIZE	8
> +/* Response IU */
> +struct r_iu {
> +	__u8 r_iu_id;
> +	__u8 reserved;
> +	__u16 ipt_tag;
> +	__u8 resp_info[3];
> +	__u8 status;
> +};
> +
>  extern int usb_stor_CB_transport(struct scsi_cmnd *, struct us_data*);
>  extern int usb_stor_CB_reset(struct us_data*);
>  
>  extern int usb_stor_Bulk_transport(struct scsi_cmnd *, struct us_data*);
>  extern int usb_stor_Bulk_max_lun(struct us_data*);
>  extern int usb_stor_Bulk_reset(struct us_data*);
> +extern void usb_stor_transfer_UASP_sglist(struct work_struct *work);
> +extern void usb_stor_kill_all_requests(struct us_data *us);
> +extern unsigned int usb_stor_get_tag(struct us_data *us);
> +
> +extern int usb_stor_UASP_transport(struct scsi_cmnd *, struct us_data*);
> +extern int usb_stor_UASP_max_lun(struct us_data *);
> +extern int usb_stor_UASP_reset(struct us_data *);
>  
> +extern void usb_stor_invoke_UASP_transport(struct us_data *us);
>  extern void usb_stor_invoke_transport(struct scsi_cmnd *, struct us_data*);
>  extern void usb_stor_stop_transport(struct us_data*);
>  
> diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
> index d4f034e..b9809d5 100644
> --- a/drivers/usb/storage/unusual_devs.h
> +++ b/drivers/usb/storage/unusual_devs.h
> @@ -1875,3 +1875,6 @@ USUAL_DEV(US_SC_QIC, US_PR_BULK, USB_US_TYPE_STOR),
>  USUAL_DEV(US_SC_UFI, US_PR_BULK, USB_US_TYPE_STOR),
>  USUAL_DEV(US_SC_8070, US_PR_BULK, USB_US_TYPE_STOR),
>  USUAL_DEV(US_SC_SCSI, US_PR_BULK, 0),
> +
> +/* UASP transport */
> +USUAL_DEV(US_SC_SCSI, US_PR_UASP, 0),
> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index 8060b85..2960f68 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -256,125 +256,203 @@ void fill_inquiry_response(struct us_data *us, unsigned char *data,
>  }
>  EXPORT_SYMBOL_GPL(fill_inquiry_response);
>  
> +static int usb_stor_something_happen(struct us_data *us)
> +{
> +	/* Disconnect bit is set */
> +	if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
> +		US_DEBUGP("%s - Disconnect bit is set\n", __func__);
> +		return 1;
> +	}
> +
> +	/* Reset bit is set by SCSI or USB CORE */
> +	if (test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +		US_DEBUGP("%s - Reset bit is set\n", __func__);
> +		return 1;
> +	}
> +
> +	/* Some of the submitted requests finished */
> +	if (us->pending_requests) {
> +		US_DEBUGP("%s - There are pending requests\n", __func__);
> +		return 1;
> +	}
> +
> +	/* New command is received and command pipe is idle*/
> +	if (us->new_command && us->command_pipe_sts == COMMAND_PIPE_IDLE) {
> +		US_DEBUGP("%s - New command is received from SCSI layer\n",
> +			  __func__);
> +		return 1;
> +	}
> +
> +	/* Abort task is received from SCSI */
> +	if (us->abort_task_tmf->state == COMMAND_STATE_IDLE) {
> +		US_DEBUGP("%s - The task is aborted from SCSI layer\n",
> +			  __func__);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  static int usb_stor_control_thread(void * __us)
>  {
>  	struct us_data *us = (struct us_data *)__us;
>  	struct Scsi_Host *host = us_to_host(us);
>  
> -	for(;;) {
> -		US_DEBUGP("*** thread sleeping.\n");
> -		if (wait_for_completion_interruptible(&us->cmnd_ready))
> -			break;
> -
> -		US_DEBUGP("*** thread awakened.\n");
> +	if (us->protocol == US_PR_UASP) {
> +		for (;;) {
> +			US_DEBUGP("%s Thread sleeping\n", __func__);
> +			wait_event(us->uasp_wq, usb_stor_something_happen(us));
> +			US_DEBUGP("%s Thread wakes up\n", __func__);
>  
> -		/* lock the device pointers */
> -		mutex_lock(&(us->dev_mutex));
> +			/* Disconnect bit is set */
> +			if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags))
> +				break;
>  
> -		/* lock access to the state */
> -		scsi_lock(host);
> +			/* Reset bit is set */
> +			if (test_bit(US_FLIDX_RESETTING, &us->dflags)) {
> +				wait_event(us->uasp_wq,
> +					!test_bit(US_FLIDX_RESETTING,
> +							&us->dflags));
> +			}
>  
> -		/* When we are called with no command pending, we're done */
> -		if (us->srb == NULL) {
> -			scsi_unlock(host);
> +			mutex_lock(&(us->dev_mutex));
> +			us->proto_handler(0, us);
>  			mutex_unlock(&us->dev_mutex);
> -			US_DEBUGP("-- exiting\n");
> -			break;
> -		}
> +		} /* for (;;) */
> +
> +		/*
> +		* If we get here, that means Disconnect bit is set.
> +		* Kill all active requests then clear Disconnect bit.
> +		*/
> +		usb_stor_kill_all_requests(us);
> +		clear_bit(US_FLIDX_DISCONNECTING, &us->dflags);
> +		wake_up(&us->uasp_wq);
> +	} else {
> +		for (;;) {
> +			US_DEBUGP("*** thread sleeping.\n");
> +			if (wait_for_completion_interruptible(&us->cmnd_ready))
> +				break;
>  
> -		/* has the command timed out *already* ? */
> -		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
> -			us->srb->result = DID_ABORT << 16;
> -			goto SkipForAbort;
> -		}
> +			US_DEBUGP("*** thread awakened.\n");
>  
> -		scsi_unlock(host);
> +			/* lock the device pointers */
> +			mutex_lock(&(us->dev_mutex));
>  
> -		/* reject the command if the direction indicator 
> -		 * is UNKNOWN
> -		 */
> -		if (us->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
> -			US_DEBUGP("UNKNOWN data direction\n");
> -			us->srb->result = DID_ERROR << 16;
> -		}
> +			/* lock access to the state */
> +			scsi_lock(host);
>  
> -		/* reject if target != 0 or if LUN is higher than
> -		 * the maximum known LUN
> -		 */
> -		else if (us->srb->device->id && 
> -				!(us->fflags & US_FL_SCM_MULT_TARG)) {
> -			US_DEBUGP("Bad target number (%d:%d)\n",
> -				  us->srb->device->id, us->srb->device->lun);
> -			us->srb->result = DID_BAD_TARGET << 16;
> -		}
> +			/*
> +			 * When we are called with no command pending,
> +			 * we're done
> +			 */
> +			if (us->srb == NULL) {
> +				scsi_unlock(host);
> +				mutex_unlock(&us->dev_mutex);
> +				US_DEBUGP("-- exiting\n");
> +				break;
> +			}
>  
> -		else if (us->srb->device->lun > us->max_lun) {
> -			US_DEBUGP("Bad LUN (%d:%d)\n",
> -				  us->srb->device->id, us->srb->device->lun);
> -			us->srb->result = DID_BAD_TARGET << 16;
> -		}
> +			/* has the command timed out *already* ? */
> +			if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
> +				us->srb->result = DID_ABORT << 16;
> +				goto SkipForAbort;
> +			}
>  
> -		/* Handle those devices which need us to fake 
> -		 * their inquiry data */
> -		else if ((us->srb->cmnd[0] == INQUIRY) &&
> -			    (us->fflags & US_FL_FIX_INQUIRY)) {
> -			unsigned char data_ptr[36] = {
> -			    0x00, 0x80, 0x02, 0x02,
> -			    0x1F, 0x00, 0x00, 0x00};
> -
> -			US_DEBUGP("Faking INQUIRY command\n");
> -			fill_inquiry_response(us, data_ptr, 36);
> -			us->srb->result = SAM_STAT_GOOD;
> -		}
> +			scsi_unlock(host);
>  
> -		/* we've got a command, let's do it! */
> -		else {
> -			US_DEBUG(usb_stor_show_command(us->srb));
> -			us->proto_handler(us->srb, us);
> -		}
> +			/* reject the command if the direction indicator
> +			* is UNKNOWN
> +			*/
> +			if (us->srb->sc_data_direction == DMA_BIDIRECTIONAL) {
> +				US_DEBUGP("UNKNOWN data direction\n");
> +				us->srb->result = DID_ERROR << 16;
> +			}
> +
> +			/* reject if target != 0 or if LUN is higher than
> +			* the maximum known LUN
> +			*/
> +			else if (us->srb->device->id &&
> +					!(us->fflags & US_FL_SCM_MULT_TARG)) {
> +				US_DEBUGP("Bad target number (%d:%d)\n",
> +						us->srb->device->id,
> +						us->srb->device->lun);
> +				us->srb->result = DID_BAD_TARGET << 16;
> +			}
>  
> -		/* lock access to the state */
> -		scsi_lock(host);
> +			else if (us->srb->device->lun > us->max_lun) {
> +				US_DEBUGP("Bad LUN (%d:%d)\n",
> +					us->srb->device->id,
> +					us->srb->device->lun);
> +				us->srb->result = DID_BAD_TARGET << 16;
> +			}
>  
> -		/* indicate that the command is done */
> -		if (us->srb->result != DID_ABORT << 16) {
> -			US_DEBUGP("scsi cmd done, result=0x%x\n", 
> -				   us->srb->result);
> -			us->srb->scsi_done(us->srb);
> -		} else {
> +			/* Handle those devices which need us to fake
> +			* their inquiry data */
> +			else if ((us->srb->cmnd[0] == INQUIRY) &&
> +				(us->fflags & US_FL_FIX_INQUIRY)) {
> +				unsigned char data_ptr[36] = {
> +				0x00, 0x80, 0x02, 0x02,
> +				0x1F, 0x00, 0x00, 0x00};
> +
> +				US_DEBUGP("Faking INQUIRY command\n");
> +				fill_inquiry_response(us, data_ptr, 36);
> +				us->srb->result = SAM_STAT_GOOD;
> +			}
> +
> +			/* we've got a command, let's do it! */
> +			else {
> +				US_DEBUG(usb_stor_show_command(us->srb));
> +				us->proto_handler(us->srb, us);
> +			}
> +
> +			/* lock access to the state */
> +			scsi_lock(host);
> +
> +			/* indicate that the command is done */
> +			if (us->srb->result != DID_ABORT << 16) {
> +				US_DEBUGP("scsi cmd done, result=0x%x\n",
> +					us->srb->result);
> +				us->srb->scsi_done(us->srb);
> +			} else {
>  SkipForAbort:
> -			US_DEBUGP("scsi command aborted\n");
> -		}
> +				US_DEBUGP("scsi command aborted\n");
> +			}
>  
> -		/* If an abort request was received we need to signal that
> -		 * the abort has finished.  The proper test for this is
> -		 * the TIMED_OUT flag, not srb->result == DID_ABORT, because
> -		 * the timeout might have occurred after the command had
> -		 * already completed with a different result code. */
> -		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
> -			complete(&(us->notify));
> -
> -			/* Allow USB transfers to resume */
> -			clear_bit(US_FLIDX_ABORTING, &us->dflags);
> -			clear_bit(US_FLIDX_TIMED_OUT, &us->dflags);
> -		}
> +			/*
> +			 * If an abort request was received we need to signal
> +			 * that the abort has finished.  The proper test for
> +			 * this is the TIMED_OUT flag, not srb->result ==
> +			 * DID_ABORT, because the timeout might have occurred
> +			 * after the command had already completed with a
> +			 * different result code.
> +			 */
> +			if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
> +				complete(&(us->notify));
> +
> +				/* Allow USB transfers to resume */
> +				clear_bit(US_FLIDX_ABORTING, &us->dflags);
> +				clear_bit(US_FLIDX_TIMED_OUT, &us->dflags);
> +			}
>  
> -		/* finished working on this command */
> -		us->srb = NULL;
> -		scsi_unlock(host);
> +			/* finished working on this command */
> +			us->srb = NULL;
> +			scsi_unlock(host);
>  
> -		/* unlock the device pointers */
> -		mutex_unlock(&us->dev_mutex);
> -	} /* for (;;) */
> +			/* unlock the device pointers */
> +			mutex_unlock(&us->dev_mutex);
> +		} /* for (;;) */
>  
> -	/* Wait until we are told to stop */
> -	for (;;) {
> -		set_current_state(TASK_INTERRUPTIBLE);
> -		if (kthread_should_stop())
> -			break;
> -		schedule();
> +		/* Wait until we are told to stop */
> +		for (;;) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			if (kthread_should_stop())
> +				break;
> +			schedule();
> +		}
> +		__set_current_state(TASK_RUNNING);
>  	}
> -	__set_current_state(TASK_RUNNING);
> +
> +	US_DEBUGP("%s - Thread exits\n", __func__);
>  	return 0;
>  }	
>  
> @@ -385,6 +463,7 @@ SkipForAbort:
>  /* Associate our private data with the USB device */
>  static int associate_dev(struct us_data *us, struct usb_interface *intf)
>  {
> +	int i;
>  	US_DEBUGP("-- %s\n", __func__);
>  
>  	/* Fill in the device-related fields */
> @@ -416,6 +495,20 @@ static int associate_dev(struct us_data *us, struct usb_interface *intf)
>  		US_DEBUGP("I/O buffer allocation failed\n");
>  		return -ENOMEM;
>  	}
> +
> +	/* Allocate in/out buffers for UASP needs */
> +	for (i = 0; i < MAX_IOBUF_COUNT; i++) {
> +		us->iobufs[i].sts = STOR_IOBUF_STATE_FREE;
> +		us->iobufs[i].buf = usb_buffer_alloc(us->pusb_dev,
> +						US_IOBUF_SIZE,
> +						GFP_KERNEL,
> +						&us->iobufs[i].dma);
> +
> +		if (!us->iobufs[i].buf) {
> +			US_DEBUGP("UASP I/O buffer allocation failed\n");
> +			return -ENOMEM;
> +		}
> +	}
>  	return 0;
>  }
>  
> @@ -588,6 +681,12 @@ static void get_transport(struct us_data *us)
>  		us->transport = usb_stor_Bulk_transport;
>  		us->transport_reset = usb_stor_Bulk_reset;
>  		break;
> +
> +	case US_PR_UASP:
> +		us->transport_name = "UASP";
> +		us->transport = usb_stor_UASP_transport;
> +		us->transport_reset = usb_stor_UASP_reset;
> +		break;
>  	}
>  }
>  
> @@ -640,12 +739,45 @@ static int get_pipes(struct us_data *us)
>  	struct usb_endpoint_descriptor *ep_in = NULL;
>  	struct usb_endpoint_descriptor *ep_out = NULL;
>  	struct usb_endpoint_descriptor *ep_int = NULL;
> +	struct usb_endpoint_descriptor *ep_cmnd = NULL;
> +	struct usb_endpoint_descriptor *ep_sts = NULL;
> +	struct usb_host_endpoint *eps[3];
> +
> +	/* Allocate streams in case of UASP */
> +	if (us->protocol == US_PR_UASP) {
> +		for (i = 1; i < altsetting->desc.bNumEndpoints; i++)
> +			eps[i - 1] = &altsetting->endpoint[i];
> +
> +		i = usb_alloc_streams(us->pusb_intf,
> +					eps,
> +					3,
> +					USB_STOR_NUM_STREAMS,
> +					GFP_KERNEL);
> +		if (i < 0) {
> +			US_DEBUGP("Cannot allocate streams\n");
> +			return i;
> +		}
> +	}
>  
>  	/*
>  	 * Find the first endpoint of each type we need.
>  	 * We are expecting a minimum of 2 endpoints - in and out (bulk).
>  	 * An optional interrupt-in is OK (necessary for CBI protocol).
> +	 * In case of UASP we will need additional 2 bulk endpoints.
>  	 * We will ignore any others.
> +	 *
> +	 * In current version of UASP implementation not included support
> +	 * of Pipe Usage Descriptors. Therefore by somehow we need to know
> +	 * which pipe for what should be used. For example from device we
> +	 * will receive two In Endpoint Descriptors(Bulk In and Status), but
> +	 * we cannot identify which one is for Bulk In and which one is for
> +	 * Status. For that purposes in current UASP implementation assumes
> +	 * that Endpoint Descriptors received from device side should be in
> +	 * the following order.
> +	 * 1. Command Endpoint Descriptor.
> +	 * 2. Bulk In Endpoint Descriptor.
> +	 * 3. Bulk Out Endpoint Descriptor.
> +	 * 4. Status Endpoint Descriptor.
>  	 */
>  	for (i = 0; i < altsetting->desc.bNumEndpoints; i++) {
>  		ep = &altsetting->endpoint[i].desc;
> @@ -654,8 +786,13 @@ static int get_pipes(struct us_data *us)
>  			if (usb_endpoint_dir_in(ep)) {
>  				if (!ep_in)
>  					ep_in = ep;
> +				else if (us->protocol == US_PR_UASP &&
> +					!ep_sts)
> +					ep_sts = ep;
>  			} else {
> -				if (!ep_out)
> +				if (us->protocol == US_PR_UASP && !ep_cmnd)
> +					ep_cmnd = ep;
> +				else if (!ep_out)
>  					ep_out = ep;
>  			}
>  		}
> @@ -666,7 +803,8 @@ static int get_pipes(struct us_data *us)
>  		}
>  	}
>  
> -	if (!ep_in || !ep_out || (us->protocol == US_PR_CBI && !ep_int)) {
> +	if (!ep_in || !ep_out || (us->protocol == US_PR_CBI && !ep_int) ||
> +		((!ep_sts || !ep_cmnd) && us->protocol == US_PR_UASP)) {
>  		US_DEBUGP("Endpoint sanity check failed! Rejecting dev.\n");
>  		return -EIO;
>  	}
> @@ -678,6 +816,17 @@ static int get_pipes(struct us_data *us)
>  		usb_endpoint_num(ep_out));
>  	us->recv_bulk_pipe = usb_rcvbulkpipe(us->pusb_dev, 
>  		usb_endpoint_num(ep_in));
> +	/* UASP command pipe */
> +	if (ep_cmnd) {
> +		us->command_pipe = usb_sndbulkpipe(us->pusb_dev,
> +						   usb_endpoint_num(ep_cmnd));
> +		us->command_pipe_sts = COMMAND_PIPE_IDLE;
> +	}
> +	/* UASP status pipe */
> +	if (ep_sts) {
> +		us->status_pipe = usb_rcvbulkpipe(us->pusb_dev,
> +						  usb_endpoint_num(ep_sts));
> +	}
>  	if (ep_int) {
>  		us->recv_intr_pipe = usb_rcvintpipe(us->pusb_dev,
>  			usb_endpoint_num(ep_int));
> @@ -698,6 +847,21 @@ static int usb_stor_acquire_resources(struct us_data *us)
>  		return -ENOMEM;
>  	}
>  
> +	/* Allocate urbs for UASP*/
> +	for (p = 0; p < MAX_URB_COUNT; p++) {
> +		us->urbs[p].sts = STOR_SG_REQ_STATE_FREE;
> +
> +		us->urbs[p].req = usb_alloc_urb(0, GFP_KERNEL);
> +		if (!us->urbs[p].req) {
> +			US_DEBUGP("URB allocation for UASP failed\n");
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	/* Initialize works for UASP Scatter-Gather requests */
> +	for (p = 0; p < MAX_SG_REQ_COUNT; p++)
> +		INIT_WORK(&us->sg_reqs[p].work, usb_stor_transfer_UASP_sglist);
> +
>  	/* Just before we start our control thread, initialize
>  	 * the device if it needs initialization */
>  	if (us->unusual_dev->initFunction) {
> @@ -718,9 +882,22 @@ static int usb_stor_acquire_resources(struct us_data *us)
>  	return 0;
>  }
>  
> +/* Releases the given Command IU queue */
> +static void release_scsi_cmnd_queue(struct list_head *queue)
> +{
> +	struct cmd_iu *cmdiu1;
> +	struct cmd_iu *cmdiu2;
> +
> +	list_for_each_entry_safe(cmdiu1, cmdiu2, queue, node) {
> +		list_del(&cmdiu1->node);
> +		kfree(cmdiu1);
> +	}
> +}
> +
>  /* Release all our dynamic resources */
>  static void usb_stor_release_resources(struct us_data *us)
>  {
> +	int i;
>  	US_DEBUGP("-- %s\n", __func__);
>  
>  	/* Tell the control thread to exit.  The SCSI host must
> @@ -728,9 +905,16 @@ static void usb_stor_release_resources(struct us_data *us)
>  	 * so that we won't accept any more commands.
>  	 */
>  	US_DEBUGP("-- sending exit command to thread\n");
> -	complete(&us->cmnd_ready);
> -	if (us->ctl_thread)
> -		kthread_stop(us->ctl_thread);
> +
> +	if (us->protocol != US_PR_UASP) {
> +		complete(&us->cmnd_ready);
> +		if (us->ctl_thread)
> +			kthread_stop(us->ctl_thread);
> +	} else {
> +		wake_up(&us->uasp_wq);
> +		wait_event(us->uasp_wq,
> +			!test_bit(US_FLIDX_DISCONNECTING, &us->dflags));
> +	}
>  
>  	/* Call the destructor routine, if it exists */
>  	if (us->extra_destructor) {
> @@ -741,11 +925,29 @@ static void usb_stor_release_resources(struct us_data *us)
>  	/* Free the extra data and the URB */
>  	kfree(us->extra);
>  	usb_free_urb(us->current_urb);
> +
> +	/* Destroy workqueue */
> +	if (us->sg_wq)
> +		destroy_workqueue(us->sg_wq);
> +
> +	/* Free UASP related URB-s */
> +	for (i = 0; i < MAX_URB_COUNT; i++)
> +		usb_free_urb(us->urbs[i].req);
> +
> +	kfree(us->abort_task_tmf);
> +
> +	/* Release all Command IU queues */
> +	release_scsi_cmnd_queue(&us->scsi_cmnd_queue);
> +	release_scsi_cmnd_queue(&us->temp_scsi_cmnd_queue);
>  }
>  
>  /* Dissociate from the USB device */
>  static void dissociate_dev(struct us_data *us)
>  {
> +	int i;
> +	struct usb_host_endpoint *eps[3];
> +	struct usb_host_interface *altsetting = us->pusb_intf->cur_altsetting;
> +
>  	US_DEBUGP("-- %s\n", __func__);
>  
>  	/* Free the device-related DMA-mapped buffers */
> @@ -756,6 +958,24 @@ static void dissociate_dev(struct us_data *us)
>  		usb_buffer_free(us->pusb_dev, US_IOBUF_SIZE, us->iobuf,
>  				us->iobuf_dma);
>  
> +	/* Release allocated streams */
> +	if (us->protocol == US_PR_UASP) {
> +		for (i = 1; i < altsetting->desc.bNumEndpoints; i++)
> +			eps[i - 1] = &altsetting->endpoint[i];
> +
> +		usb_free_streams(us->pusb_intf, eps, 3, GFP_KERNEL);
> +	}
> +
> +	/* Release In/Out buffers allocated for UASP */
> +	for (i = 0; i < MAX_IOBUF_COUNT; i++) {
> +		if (us->iobufs[i].buf) {
> +			usb_buffer_free(us->pusb_dev,
> +				US_IOBUF_SIZE,
> +				us->iobufs[i].buf,
> +				us->iobufs[i].dma);
> +		}
> +	}
> +
>  	/* Remove our private data from the interface */
>  	usb_set_intfdata(us->pusb_intf, NULL);
>  }
> @@ -831,6 +1051,12 @@ static int usb_stor_scan_thread(void * __us)
>  			us->max_lun = usb_stor_Bulk_max_lun(us);
>  			mutex_unlock(&us->dev_mutex);
>  		}
> +		/* In case of UASP */
> +		else if (us->protocol == US_PR_UASP) {
> +			mutex_lock(&us->dev_mutex);
> +			us->max_lun = usb_stor_UASP_max_lun(us);
> +			mutex_unlock(&us->dev_mutex);
> +		}
>  		scsi_scan_host(us_to_host(us));
>  		printk(KERN_DEBUG "usb-storage: device scan complete\n");
>  
> @@ -876,6 +1102,25 @@ int usb_stor_probe1(struct us_data **pus,
>  	init_waitqueue_head(&us->delay_wait);
>  	init_completion(&us->scanning_done);
>  
> +	init_waitqueue_head(&us->uasp_wq);
> +	INIT_LIST_HEAD(&us->scsi_cmnd_queue);
> +	INIT_LIST_HEAD(&us->temp_scsi_cmnd_queue);
> +	spin_lock_init(&us->lock);
> +
> +	us->abort_task_tmf = kzalloc(sizeof(struct tm_iu), GFP_KERNEL);
> +	if (!us->abort_task_tmf) {
> +		result = -ENOMEM;
> +		goto BadDevice;
> +	}
> +	us->abort_task_tmf->state = COMMAND_STATE_COMPLETED;
> +
> +	US_DEBUGP("Create workqueue\n");
> +	us->sg_wq = create_singlethread_workqueue("USB Storage WQ");
> +	if (us->sg_wq == NULL) {
> +		result = -ENOMEM;
> +		goto BadDevice;
> +	}
> +
>  	/* Associate the us_data structure with the USB device */
>  	result = associate_dev(us, intf);
>  	if (result)
> diff --git a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
> index 2609efb..b9a7f17 100644
> --- a/drivers/usb/storage/usb.h
> +++ b/drivers/usb/storage/usb.h
> @@ -95,6 +95,47 @@ typedef void (*pm_hook)(struct us_data *, int);	/* power management hook */
>  #define US_SUSPEND	0
>  #define US_RESUME	1
>  
> +/* Number of streams we need to allocate */
> +#define USB_STOR_NUM_STREAMS	2
> +
> +/* Max number of Command IU-s could be queued */
> +#define MAX_COMMAND_COUNT	16
> +/* Max number of In/Out buffers */
> +#define MAX_IOBUF_COUNT		(MAX_COMMAND_COUNT << 1)
> +/* Max number of URBs */
> +#define MAX_URB_COUNT		(MAX_COMMAND_COUNT << 1)
> +/* Max number of Scatter-Gather requests */
> +#define MAX_SG_REQ_COUNT	(MAX_COMMAND_COUNT << 1)
> +
> +#define STOR_IOBUF_STATE_FREE	0
> +#define STOR_IOBUF_STATE_BUSY	1
> +/* used as an In/Out buffers for UASP only */
> +struct stor_iobuf {
> +	unsigned char	*buf;
> +	dma_addr_t	dma;
> +	int		sts;
> +};
> +
> +#define STOR_URB_STATE_FREE	0
> +#define STOR_URB_STATE_BUSY	1
> +/* used as an URB for UASP only */
> +struct stor_urb {
> +	struct urb		*req;
> +	int			sts;
> +};
> +
> +#define STOR_SG_REQ_STATE_FREE	0
> +#define STOR_SG_REQ_STATE_BUSY	1
> +/* used as a Scatter-Gather request for UASP only */
> +struct stor_sg_req {
> +	struct usb_sg_request	sg_req;
> +	int			sts;
> +	int			result;
> +	struct work_struct	work;
> +	struct cmd_iu 		*cmdiu;
> +	struct us_data 		*us;
> +};
> +
>  /* we allocate one of these for every device that we remember */
>  struct us_data {
>  	/* The device we're working with
> @@ -112,6 +153,12 @@ struct us_data {
>  	unsigned int		send_ctrl_pipe;
>  	unsigned int		recv_ctrl_pipe;
>  	unsigned int		recv_intr_pipe;
> +	unsigned int		command_pipe;
> +	unsigned int		status_pipe;
> +
> +#define COMMAND_PIPE_IDLE	0
> +#define COMMAND_PIPE_BUSY	1
> +	int			command_pipe_sts;
>  
>  	/* information about the device */
>  	char			*transport_name;
> @@ -132,6 +179,9 @@ struct us_data {
>  	/* SCSI interfaces */
>  	struct scsi_cmnd	*srb;		 /* current srb		*/
>  	unsigned int		tag;		 /* current dCBWTag	*/
> +	struct list_head	scsi_cmnd_queue;
> +	struct list_head	temp_scsi_cmnd_queue;
> +	struct tm_iu		*abort_task_tmf;
>  
>  	/* control and bulk communications data */
>  	struct urb		*current_urb;	 /* USB requests	 */
> @@ -140,6 +190,9 @@ struct us_data {
>  	unsigned char		*iobuf;		 /* I/O buffer		 */
>  	dma_addr_t		cr_dma;		 /* buffer DMA addresses */
>  	dma_addr_t		iobuf_dma;
> +	struct stor_iobuf	iobufs[MAX_IOBUF_COUNT];
> +	struct stor_urb		urbs[MAX_URB_COUNT];
> +	struct stor_sg_req	sg_reqs[MAX_SG_REQ_COUNT];
>  	struct task_struct	*ctl_thread;	 /* the control thread   */
>  
>  	/* mutual exclusion and synchronization structures */
> @@ -147,6 +200,12 @@ struct us_data {
>  	struct completion	notify;		 /* thread begin/end	    */
>  	wait_queue_head_t	delay_wait;	 /* wait during scan, reset */
>  	struct completion	scanning_done;	 /* wait for scan thread    */
> +	wait_queue_head_t	uasp_wq;
> +	struct workqueue_struct	*sg_wq;
> +	spinlock_t		lock;
> +	int			pending_requests;
> +	int			active_requests;
> +	int			new_command;
>  
>  	/* subdriver information */
>  	void			*extra;		 /* Any extra data          */
> diff --git a/include/linux/usb_usual.h b/include/linux/usb_usual.h
> index 3d15fb9..a1a9d86 100644
> --- a/include/linux/usb_usual.h
> +++ b/include/linux/usb_usual.h
> @@ -96,6 +96,7 @@ enum { US_DO_ALL_FLAGS };
>  #define US_PR_CBI	0x00		/* Control/Bulk/Interrupt */
>  #define US_PR_CB	0x01		/* Control/Bulk w/o interrupt */
>  #define US_PR_BULK	0x50		/* bulk only */
> +#define US_PR_UASP	0x62		/* UASP */
>  
>  #define US_PR_USBAT	0x80		/* SCM-ATAPI bridge */
>  #define US_PR_EUSB_SDDR09	0x81	/* SCM-SCSI bridge for SDDR-09 */
> -- 
> 1.6.0.6
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
