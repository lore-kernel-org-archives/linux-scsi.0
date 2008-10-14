From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg interface - revised
Date: Tue, 14 Oct 2008 04:44:17 -0700
Message-ID: <1FF7A5F2-7B3B-4862-8435-15E3C666D166@qlogic.com>
References: <9131BBA9-66C3-4ADB-88EC-077367BC7EFB@qlogic.com> <45109B57-BBED-47A8-8183-4F4464D1DBEC@qlogic.com> <20081014112148W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:18747 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbYJNLoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 07:44:20 -0400
In-Reply-To: <20081014112148W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, robert.w.love@intel.com


On Oct 13, 2008, at 7:22 PM, FUJITA Tomonori wrote:

> On Mon, 13 Oct 2008 11:14:56 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>
>>
>> On Oct 13, 2008, at 10:53 AM, Seokmann Ju wrote:
>>
>>> Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
>>> ---
>> By mistake, I placed patches so that it won't match with the subject.
>> Sorry for the shortcomings.
>> Here is the patch for scsi_transport_fc module.
>>
>> Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
>> ---
>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/
>> scsi_transport_fc.c
>> index cb971f0..dda12e0 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -43,6 +43,11 @@ static void fc_vport_sched_delete(struct
>> work_struct *work);
>>  static int fc_vport_setup(struct Scsi_Host *shost, int channel,
>>  	struct device *pdev, struct fc_vport_identifiers  *ids,
>>  	struct fc_vport **vport);
>> +static void fc_service_timeout(unsigned long);
>> +static void fc_service_done(struct fc_service *);
>> +static int fc_service_handler(struct Scsi_Host *, struct fc_rport *,
>> +    struct request *, struct request_queue *);
>> +static void fc_bsg_remove(struct Scsi_Host *, struct fc_rport *);
>>
>>  /*
>>   * Redefine so that we can have same named attributes in the
>> @@ -2406,12 +2411,194 @@ fc_rport_final_delete(struct work_struct  
>> *work)
>>
>>  	transport_remove_device(dev);
>>  	device_del(dev);
>> +	fc_bsg_remove(shost, rport);
>>  	transport_destroy_device(dev);
>>  	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
>>  	put_device(dev);			/* for self-reference */
>>  }
>>
>>
>> +static void fc_service_timeout(unsigned long _service)
>> +{
>> +	struct fc_service *service = (void *) _service;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&service->service_state_lock, flags);
>> +	if (!(service->service_state_flag & FC_SERVICE_STATE_DONE))
>> +		service->service_state_flag |= FC_SERVICE_STATE_TIMEOUT;
>> +	spin_unlock_irqrestore(&service->service_state_lock, flags);
>> +}
>
> Hmm, this function is not used? Using rq_timed_out_fn is todo?
Yes, timeout is not in place at this time.
That is what I'm working on.

>
>
>
>> +static void fc_service_done(struct fc_service *service)
>> +{
>> +	if (service->service_state_flag != FC_SERVICE_STATE_DONE) {
>> +		if (service->service_state_flag == FC_SERVICE_STATE_TIMEOUT) {
>> +			printk(KERN_ERR "ERROR: FC service timed out\n");
>> +			/* expect abort to be issued by the application */
>> +			return;
>> +		} else
>> +			printk(KERN_ERR "ERROR: FC service not finished\n");
>> +	}
>> +
>> +	if (service->srv_reply.status != FC_SERVICE_COMPLETE) {
>> +		printk(KERN_ERR "ERROR: FC service to rport %p failed with"
>> +		    " status 0x%x\n", service->rport,
>> +		    service->srv_reply.status);
>> +	}
>> +
>> +	if (service->srv_reply.residual) {
>> +		service->req->data_len = 0;
>> +		service->req->next_rq->data_len = service->srv_reply.residual;
>> +	} else {
>> +		service->req->data_len = 0;
>> +		service->req->next_rq->data_len = 0;
>> +	}
>> +
>> +	service->req->end_io(service->req, 0);
>> +	kfree(service);
>> +}
>> +
>> +static int
>> +issue_fc_service(struct fc_rport *rport, struct request *req,
>> +    struct request *rsp, struct request_queue *q)
>> +{
>> +	int res = -ECOMM;
>> +	struct fc_service *service;
>> +	struct Scsi_Host *shost = rport_to_shost(rport);
>> +	struct fc_internal *i = to_fc_internal(shost->transportt);
>> +	struct fc_service_request *srv_request = (struct  
>> fc_service_request *)
>> +	    req->cmd;
>> +
>> +	service = kzalloc(sizeof (struct fc_service), GFP_KERNEL);
>> +	if (!service)
>> +		return -ENOMEM;
>> +
>> +	service->rport = rport;
>> +	service->req = req;
>> +	service->q = q;
>> +	service->srv_request = srv_request;
>> +
>> +	sg_init_table(service->payload_dma, FC_SERVICE_MAX_SG);
>> +	service->payload_sg_cnt =
>> +	    blk_rq_map_sg(q, req, service->payload_dma);
>> +	service->payload = (void *) bio_data(req->bio);
>
> You use scatter-gather for data transfer so bio_data should not be
> used.
OK. Will be removed.

>
>
>
>> +	service->payload_size = req->data_len;
>> +
>> +	sg_init_table(service->response_dma, FC_SERVICE_MAX_SG);
>> +	service->response_sg_cnt =
>> +	    blk_rq_map_sg(q, rsp, service->response_dma);
>> +	service->response = bio_data(rsp->bio);
>> +	service->response_size = rsp->data_len;
>> +
>> +	/* sense area of the request structure */
>> +	service->reply_seq = req->sense;
>> +	service->service_done = fc_service_done;
>> +	service->service_state_flag = FC_SERVICE_STATE_PENDING;
>> +
>> +	if (i->f->execute_fc_service)
>> +		res = i->f->execute_fc_service(service);
>> +
>> +	if (res) {
>> +		printk(KERN_ERR "ERROR: issuing FC service to the LLD "
>> +		"failed with status %d\n", res);
>> +		fc_service_done(service);
>> +		return res;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +fc_service_handler(struct Scsi_Host *shost, struct fc_rport *rport,
>> +			  struct request *req, struct request_queue *q)
>> +{
>> +	int ret;
>> +	struct request *rsp = req->next_rq;
>> +
>> +	if (!rsp) {
>> +		printk(KERN_ERR "ERROR: space for a FC service"
>> +		   " response is missing\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if ((req->bio->bi_vcnt > FC_SERVICE_MAX_SG) ||
>> +	    (rsp->bio->bi_vcnt > FC_SERVICE_MAX_SG)) {
>> +		printk(KERN_ERR "ERROR: a FC service"
>> +		    " supports no more than %d SGs\n", FC_SERVICE_MAX_SG);
>> +		return -EINVAL;
>> +	}
>
> This doesn't look correct. bi_vcnt is not related with the number of
> sg. You use scatter-gather for large data transfer. You don't need to
> worry about bi_vcnt.
I see...
Is there is a way to check, then, how many SG entries the service  
needs before the blk_rq_map_sg()?
Having an 'payload_dma/response_dma' as array type seems not right,  
too..

>
>
>
>> +	ret = issue_fc_service(rport, req, rsp, q);
>> +
>> +	return ret;
>> +}
>> +
>> +static void fc_service_dispatch(struct request_queue *q)
>> +{
>> +	struct request *req;
>> +	struct fc_rport *rport = q->queuedata;
>> +	struct Scsi_Host *shost = rport_to_shost(rport);
>> +
>> +	while (!blk_queue_plugged(q)) {
>> +		req = elv_next_request(q);
>> +		if (!req)
>> +			break;
>> +
>> +		blkdev_dequeue_request(req);
>> +		spin_unlock_irq(q->queue_lock);
>> +
>> +		fc_service_handler(shost, rport, req, q);
>> +
>> +		spin_lock_irq(q->queue_lock);
>> +	}
>> +}
>> +
>> +static int
>> +fc_bsg_initialize(struct Scsi_Host *shost, struct fc_rport *rport)
>> +{
>> +	struct request_queue *q;
>> +	int error;
>> +	struct device *dev;
>> +	const char *name;
>> +	void (*release)(struct device *);
>> +
>> +	if (!rport) {
>> +		printk(KERN_ERR "ERROR: rport is NULL\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	q = blk_init_queue(fc_service_dispatch, NULL);
>> +	if (!q)
>> +		return -ENOMEM;
>> +
>> +	dev = &rport->dev;
>> +	name = dev->bus_id;
>> +	release = NULL;
>> +
>> +	error = bsg_register_queue(q, dev, name, release);
>> +	if (error) {
>> +		blk_cleanup_queue(q);
>> +		return -ENOMEM;
>> +	}
>
> I think that you need to call blk_queue_max_hw_segments and
> blk_queue_max_phys_segments here with FC_SERVICE_MAX_SG.
>
>
>> +
>> +	rport->q = q;
>> +	q->queuedata = rport;
>> +	queue_flag_set_unlocked(QUEUE_FLAG_BIDI, q);
>> +
>> +	return 0;
>> +}
>> +
>> +static void
>> +fc_bsg_remove(struct Scsi_Host *shost, struct fc_rport *rport)
>> +{
>> +	struct request_queue *q = rport->q;
>> +
>> +	if (!q)
>> +		return;
>> +
>> +	bsg_unregister_queue(q);
>> +}
>> +
>>  /**
>>   * fc_rport_create - allocates and creates a remote FC port.
>>   * @shost:	scsi host the remote port is connected to.
>> @@ -2471,8 +2658,8 @@ fc_rport_create(struct Scsi_Host *shost, int
>> channel,
>>  	else
>>  		rport->scsi_target_id = -1;
>>  	list_add_tail(&rport->peers, &fc_host->rports);
>> -	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
>>
>> +	get_device(&shost->shost_gendev);	/* for fc_host->rport list */
>>  	spin_unlock_irqrestore(shost->host_lock, flags);
>>
>>  	dev = &rport->dev;
>> @@ -2491,6 +2678,8 @@ fc_rport_create(struct Scsi_Host *shost, int
>> channel,
>>  	transport_add_device(dev);
>>  	transport_configure_device(dev);
>>
>> +	fc_bsg_initialize(shost, rport);
>> +
>>  	if (rport->roles & FC_PORT_ROLE_FCP_TARGET) {
>>  		/* initiate a scan of the target */
>>  		rport->flags |= FC_RPORT_SCAN_PENDING;
>> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/
>> scsi_transport_fc.h
>> index 21018a4..6c6809a 100644
>> --- a/include/scsi/scsi_transport_fc.h
>> +++ b/include/scsi/scsi_transport_fc.h
>> @@ -33,7 +33,6 @@
>>
>>  struct scsi_transport_template;
>>
>> -
>>  /*
>>   * FC Port definitions - Following FC HBAAPI guidelines
>>   *
>> @@ -352,6 +351,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
>>   	struct delayed_work fail_io_work;
>>   	struct work_struct stgt_delete_work;
>>  	struct work_struct rport_delete_work;
>> +	struct request_queue *q;
>>  } __attribute__((aligned(sizeof(unsigned long))));
>>
>>  /* bit field values for struct fc_rport "flags" field: */
>> @@ -514,6 +514,81 @@ struct fc_host_attrs {
>>  	struct workqueue_struct *devloss_work_q;
>>  };
>>
>> +#define FC_STATUS_BUF_SIZE 96
>> +
>> +enum fc_frame_type {
>> +	FC_FRAME_TYPE_BS,
>> +	FC_FRAME_TYPE_ELS,
>> +	FC_FRAME_TYPE_IEC = 4,
>> +	FC_FRAME_TYPE_IP,
>> +	FC_FRAME_TYPE_FCP = 8,
>> +	FC_FRAME_TYPE_GPP,
>> +	FC_FRAME_TYPE_FC_CT = 0x20,
>> +};
>> +
>> +enum fc_service_status {
>> +	FC_SERVICE_COMPLETE,
>> +	FC_SERVICE_TIMEOUT,
>> +	FC_SERVICE_ABORT,
>> +	FC_SERVICE_UNSUPPORTED,
>> +	FC_SERVICE_ERROR = -1,
>> +};
>> +
>> +#define FC_SERVICE_STATE_PENDING      1
>> +#define FC_SERVICE_STATE_DONE         2
>> +#define FC_SERVICE_STATE_ABORTED      4
>> +#define FC_SERVICE_STATE_TIMEOUT      8
>> +
>> +#define FC_SERVICE_TIMEOUT 10
>> +#define FC_SERVICE_MAX_SG             16
>> +
>> +/* request (CDB) structure of the sg_io_v4 */
>> +struct fc_service_request {
>> +	u8   request_type;
>> +	u8   timeout;
>> +	u8   reserved0;
>> +	u8   reserved1;
>> +};
>> +
>> +/* response  (request sense data) structure of the sg_io_v4 */
>> +struct fc_service_reply {
>> +	enum fc_service_status status;
>> +	u16  error_code;
>> +	u16  additional_error_code;
>> +	u32  residual;
>> +};
>> +
>> +struct fc_service {
>> +	struct fc_rport  *rport;
>> +	struct list_head list;
>> +
>> +	spinlock_t   service_state_lock;
>> +	unsigned     service_state_flag;
>> +
>> +	struct request *req;
>> +	struct request_queue *q;
>> +
>> +	/* Used by the discovery code. */
>> +	struct timer_list  timer;
>> +	struct completion  completion;
>> +
>> +	struct fc_service_request *srv_request;
>> +	void  *payload;
>> +	struct scatterlist payload_dma[FC_SERVICE_MAX_SG];
>> +	int   payload_sg_cnt;
>> +	int   payload_size;
>> +	void  *response;
>> +	struct scatterlist response_dma[FC_SERVICE_MAX_SG];
>> +	int   response_sg_cnt;
>> +	int   response_size;
>> +
>> +	struct fc_service_reply srv_reply;
>> +	void  *reply_seq;   /* pointer to sense area of request */
>> +	void  (*service_done)(struct fc_service *);
>> +
>> +	void *lld_pkt;
>> +};
>> +
>>  #define shost_to_fc_host(x) \
>>  	((struct fc_host_attrs *)(x)->shost_data)
>>
>> @@ -612,6 +687,10 @@ struct fc_function_template {
>>  	int     (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
>>  	int     (* it_nexus_response)(struct Scsi_Host *, u64, int);
>>
>> +	/* fc service handler */
>> +	int	(*execute_fc_service)(struct fc_service *);
>> +	int	(*abort_fc_service)(struct fc_service *);
>> +
>>  	/* allocation lengths for host-specific data */
>>  	u32	 			dd_fcrport_size;
>>  	u32	 			dd_fcvport_size;
>> @@ -732,7 +811,6 @@ fc_vport_set_state(struct fc_vport *vport, enum
>> fc_vport_state new_state)
>>  	vport->vport_state = new_state;
>>  }
>>
>> -
>>  struct scsi_transport_template *fc_attach_transport(
>>  			struct fc_function_template *);
>>  void fc_release_transport(struct scsi_transport_template *);
>> ---
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

