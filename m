From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 4/5] nvme-fabrics: Add target FC transport support
Date: Mon, 22 Aug 2016 09:56:41 -0700
Message-ID: <40a27ad0-1785-6ff8-123e-5d1ace2b7127@broadcom.com>
References: <5792b91e.51+4Ind0/2MxGqHU%james.smart@broadcom.com>
 <1470112670.6134.88.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36385 "EHLO
        mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbcHVQ5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2016 12:57:15 -0400
Received: by mail-pa0-f42.google.com with SMTP id pp5so39239085pac.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 09:56:43 -0700 (PDT)
In-Reply-To: <1470112670.6134.88.camel@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: J Freyensee <james_p_freyensee@linux.intel.com>, linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org



On 8/1/2016 9:37 PM, J Freyensee wrote:
>
>> +static void
>> +nvmet_fc_free_target_queue(struct nvmet_fc_tgt_queue *queue)
>> +{
>> +	struct nvmet_fc_tgtport *tgtport = queue->assoc->tgtport;
>> +	unsigned long flags;
>> +
>> +	/*
>> +	 * beware: nvmet layer hangs waiting for a completion if
>> +	 * connect command failed
>> +	 */
>> +	flush_workqueue(queue->work_q);
>> +	if (queue->connected)
>> +		nvmet_sq_destroy(&queue->nvme_sq);
> I was wondering if there is any way for this fc target layer to fake
> send an NVMe completion to the nvmet layer to prevent a nvmet layer
> hang (because I'm assuming the nvmet layer hangs because it never
> receives a connect completion upon failure here), then send a signal to
> tear down the sq.
>
> Or alternatively call nvmet_ctrl_fatal_error() if connect fails as a
> trial/alternative to having the nvmet layer hang?

I haven't tried to fix the bugs in the other layers - enough to do in FC 
already.  Agree to look into this.



>> +
>> +/**
>> + * nvme_fc_register_targetport - transport entry point called by an
>> + *                              LLDD to register the existence of a
>> local
>> + *                              NVME subystem FC port.
>> + * @pinfo:     pointer to information about the port to be
>> registered
>> + * @template:  LLDD entrypoints and operational parameters for the
>> port
>> + * @dev:       physical hardware device node port corresponds to.
>> Will be
>> + *             used for DMA mappings
>> + * @tgtport_p:   pointer to a local port pointer. Upon success, the
>
> looks like the variable tgtport_p does not exist (or it's now called
> portptr)?

Yeah - comment not in sync with the code's name.


>
>> +/*
>> + * Actual processing routine for received FC-NVME LS Requests from
>> the LLD
>> + */
>> +void
>> +nvmet_fc_handle_ls_rqst(struct nvmet_fc_tgtport *tgtport,
>> +			struct nvmet_fc_ls_iod *iod)
>> +{
>> +	struct fcnvme_ls_rqst_w0 *w0 =
>> +			(struct fcnvme_ls_rqst_w0 *)iod->rqstbuf;
>> +
>> +	iod->lsreq->nvmet_fc_private = iod;
>> +	iod->lsreq->rspbuf = iod->rspbuf;
>> +	iod->lsreq->rspdma = iod->rspdma;
>> +	iod->lsreq->done = nvmet_fc_xmt_ls_rsp_done;
>> +	/* Be preventative. handlers will later set to valid length
>> */
>> +	iod->lsreq->rsplen = 0;
>> +
>> +	iod->assoc = NULL;
>> +
>> +	/*
>> +	 * handlers:
>> +	 *   parse request input, set up nvmet req (cmd, rsp,
>>   execute)
>> +	 *   and format the LS response
>> +	 * if non-zero returned, then no futher action taken on the
>> LS
>> +	 * if zero:
>> +	 *   valid to call nvmet layer if execute routine set
>> +	 *   iod->rspbuf contains ls response
>> +	 */
>> +	switch (w0->ls_cmd) {
>> +	case FCNVME_LS_CREATE_ASSOCIATION:
>> +		/* Creates Association and initial Admin
>> Queue/Connection */
>> +		nvmet_fc_ls_create_association(tgtport, iod);
>> +		break;
>> +	case FCNVME_LS_CREATE_CONNECTION:
>> +		/* Creates an IO Queue/Connection */
>> +		nvmet_fc_ls_create_connection(tgtport, iod);
>> +		break;
>> +	case FCNVME_LS_DISCONNECT:
>> +		/* Terminate a Queue/Connection or the Association
>> */
>> +		nvmet_fc_ls_disconnect(tgtport, iod);
>> +		break;
>> +	default:
>> +		iod->lsreq->rsplen = nvmet_fc_format_rjt(iod
>> ->rspbuf,
>> +				NVME_FC_MAX_LS_BUFFER_SIZE, w0
>> ->ls_cmd,
>> +				LSRJT_REASON_INVALID_ELS_CODE,
>> +				LSRJT_EXPL_NO_EXPLANATION, 0);
>> +	}
>> +
>> +	nvmet_fc_xmt_ls_rsp(tgtport, iod);
>> +}
> All the functions in the case() (nvmet_fc_ls_disconnect(),
> nvmet_fc_ls_create_association(), etc)  have internal return values
> (errors and certain values), I'm curious why you wouldn't want to
> bubble up those values through the function calling chain?  Especially
> since there is a comment in the function above that says "if non-zero
> returned, then no futher action taken on the LS".

just style. they all generate a response payload that is then always 
sent, so returning a code didn't really mean much.  The comment is old. 
They used to return the value, but as you can see, they don't now. Will 
clean it up.


>
> .
>> +
>> +static int __init nvmet_fc_init_module(void)
>> +{
>> +	/* ensure NVMET_NR_QUEUES is a power of 2 - required for our
>> masks */
>> +	if (!is_power_of_2((unsigned long)NVMET_NR_QUEUES)) {
>> +		pr_err("%s: NVMET_NR_QUEUES required to be power of
>> 2\n",
>> +				__func__);
> If this is so important that NVMET_NR_QUEUES always be a power of two
> for this FC driver, I'd have the function print out the value in the
> error message for easier diagnosis.

no problem.


>
> And why mask the sign of NVMET_NR_QUEUES?  Yes, it would have to be a
> really careless programmer error that would be caught very quick if the
> #define became negative, but masking out the sign of a #define value
> that seems to be pretty important for FC transport functionality makes
> me a tad nervous.

I'll look at it. I believe I did the type redef to make the calling 
sequence happy.  I'll see if there's a better way.

> Good stuff James,
> J
>
>

Thanks

-- james

