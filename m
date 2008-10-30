From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support - revised
 II
Date: Thu, 30 Oct 2008 09:51:40 +0200
Message-ID: <4909678C.1010908@panasas.com>
References: <E35CF40D-87CC-4AA2-91EC-31064F70198E@qlogic.com> <20081030131825M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:32639 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbYJ3Hvr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 03:51:47 -0400
Received: by ug-out-1314.google.com with SMTP id 39so843232ugf.37
        for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2008 00:51:45 -0700 (PDT)
In-Reply-To: <20081030131825M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: seokmann.ju@qlogic.com, James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, robert.w.love@intel.com

FUJITA Tomonori wrote:
> On Wed, 29 Oct 2008 05:48:03 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
> 
>>  From f32b386a61a23f408974f2289cd34200f59401e1 Mon Sep 17 00:00:00 2001
>> From: root <root@linux-atl-00.qlogic.com>
>> Date: Tue, 28 Oct 2008 19:27:15 -0700
>> Subject: [PATCH] scsi_transport_fc: FC pass through support
>>
>> This patch will add FC pass through support.
>> The FC pass through support is service request handling mechanism
>> for FC specification defined services including,
>> - Link Services (Basic LS, Extended LS)
>> - Generic Services (FC-CT - Common Transport)
>> The support utilize BSG (Block layer SCSI Generic) interface with
>> bidi (bi-directional) nature in handling the service requests.
>>
>> This patch added following featues in the support
>> - FC service structure has defined to transport service requests
>> - Handles the service request in asynchronous manner - LLD
>> - Timeout capability
>> - Abort capability
>>
>> Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
>> ---
>>   drivers/scsi/scsi_transport_fc.c |  216 +++++++++++++++++++++++++++++ 
>> ++++++++-
>>   include/scsi/scsi_transport_fc.h |   81 ++++++++++++++-
>>   2 files changed, 294 insertions(+), 3 deletions(-)
> 
> First, the patch looks corrupt (I can't apply this). I guess that tabs
> are converted to spaces.
> 
> 
>> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/ 
>> scsi_transport_fc.c
>> index 1e71abf..e26e8e0 100644
>> --- a/drivers/scsi/scsi_transport_fc.c
>> +++ b/drivers/scsi/scsi_transport_fc.c
>> @@ -43,6 +43,11 @@ static void fc_vport_sched_delete(struct  
>> work_struct *work);
>>   static int fc_vport_setup(struct Scsi_Host *shost, int channel,
>>   	struct device *pdev, struct fc_vport_identifiers  *ids,
>>   	struct fc_vport **vport);
>> +static enum blk_eh_timer_return fc_service_timeout(struct request  
>> *req);
>> +static void fc_service_done(struct fc_service *);
>> +static int fc_service_handler(struct Scsi_Host *, struct fc_rport *,
>> +    struct request *, struct request_queue *);
>> +static void fc_bsg_remove(struct Scsi_Host *, struct fc_rport *);
>>
>>   /*
>>    * Redefine so that we can have same named attributes in the
>> @@ -2413,11 +2418,218 @@ fc_rport_final_delete(struct work_struct *work)
>>
>>   	transport_remove_device(dev);
>>   	device_del(dev);
>> +	fc_bsg_remove(shost, rport);
>>   	transport_destroy_device(dev);
>>   	put_device(&shost->shost_gendev);	/* for fc_host->rport list */
>>   	put_device(dev);			/* for self-reference */
>>   }
>>
>> +static enum blk_eh_timer_return fc_service_timeout(struct request *req)
>> +{
>> +	struct fc_service *service = (void *) req->special;
>> +	struct Scsi_Host *shost = rport_to_shost(service->rport);
>> +	struct fc_internal *i = to_fc_internal(shost->transportt);
>> +	unsigned long flags;
>> +	int res = 0;
>> +
>> +	if (service->rport->port_state == FC_PORTSTATE_BLOCKED)
>> +		return BLK_EH_RESET_TIMER;
>> +
>> +	spin_lock_irqsave(&service->service_state_lock, flags);
>> +	if (!(service->service_state_flag & FC_SERVICE_STATE_DONE))
>> +		service->service_state_flag |= FC_SERVICE_STATE_TIMEOUT;
>> +	spin_unlock_irqrestore(&service->service_state_lock, flags);
>> +
>> +	if (i->f->abort_fc_service)
>> +		res = i->f->abort_fc_service(service);
>> +
>> +	if (res) {
>> +		printk(KERN_ERR "ERROR: issuing FC service to the LLD "
>> +		"failed with status %d\n", res);
>> +		fc_service_done(service);
>> +	}
>> +
>> +	/* the blk_end_sync_io() doesn't check the error */
>> +	return BLK_EH_NOT_HANDLED;
>> +}
>> +
>> +static void fc_service_done(struct fc_service *service)
>> +{
>> +
>> +	if (service->service_state_flag != FC_SERVICE_STATE_DONE) {
>> +		if (service->service_state_flag == FC_SERVICE_STATE_TIMEOUT)
>> +			printk(KERN_ERR "ERROR: FC service timed out\n");
>> +		else if (service->service_state_flag ==
>> +		    FC_SERVICE_STATE_ABORTED)
>> +			printk(KERN_ERR "ERROR: FC service aborted\n");
>> +		else
>> +			printk(KERN_ERR "ERROR: FC service not finished\n");
>> +	}
>> +
>> +	if (service->srv_reply.status != FC_SERVICE_COMPLETE) {
>> +		printk(KERN_ERR "ERROR: FC service to rport %p failed with"
>> +		    " status 0x%x\n", service->rport,
>> +		    service->srv_reply.status);
>> +	}
>> +
>> +	service->req->errors = service->srv_reply.status;
>> +	service->req->next_rq->errors = service->srv_reply.status;
> 
> We don't need to save service->srv_reply.status at two places
> service->req is appropriate.
> 

TOMO Hi.
Do you know what is the difference between "req->error =" and the error
passed to blk_end_xxx_request(req, error, ...) ?

> 
>> +	blk_end_bidi_request(service->req, service->srv_reply.status,
>> +	    blk_rq_bytes(service->req),
>> +	    service->req->next_rq ? blk_rq_bytes(service->req->next_rq) : 0);
>> +
>> +	kfree(service->payload_dma);
>> +	kfree(service->response_dma);
>> +	kfree(service);
>> +}
>> +
<snip>

Boaz
