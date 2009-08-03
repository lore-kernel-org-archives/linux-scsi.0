From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/6] RFC: beiscsi : handles core routines
Date: Mon, 3 Aug 2009 22:41:31 +0200
Message-ID: <20090803204131.GV12579@kernel.dk>
References: <20090728071251.GA13581@serverengines.com> <4A7716E9.9060307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:35426 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZHCUlb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2009 16:41:31 -0400
Content-Disposition: inline
In-Reply-To: <4A7716E9.9060307@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org

On Mon, Aug 03 2009, Mike Christie wrote:
> Hey Jens,
>
> Is your block napi code going to go upstream soon? Does it need more  
> testing or users?
>
> This driver is just using a normal old work queue for the completion  
> path, so I wanted to see about having Jay convert it to your code.

I plan to include the core bits for 2.6.32, so should be heading to
mainline soon(ish) :-)

>
>
>
> On 07/28/2009 02:13 AM, Jayamohan Kallickal wrote:
>> + */
>> +irqreturn_t be_isr(int irq, void *dev_id)
>> +{
>> +	struct beiscsi_hba *phba = NULL;
>> +	struct hwi_controller_ws *phwi_controller;
>> +	struct hwi_context_memory *phwi_context;
>> +	struct be_eq_entry *eqe = NULL;
>> +	struct be_queue_info *eq;
>> +	unsigned long flags, index;
>> +	unsigned int num_eq_processed;
>> +
>> +	phba = (struct beiscsi_hba *)dev_id;
>> +	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
>> +	phwi_context = phwi_controller->phwic;
>> +	spin_lock_irqsave(&phba->isr_lock, flags);
>> +
>> +	eq =&phwi_context->be_eq.q;
>> +	index = 0;
>> +	eqe = queue_tail_node(eq);
>> +	if (!eqe)
>> +		SE_DEBUG(DBG_LVL_1, "eqe is NULL\n");
>> +
>> +	num_eq_processed = 0;
>> +	while (eqe->
>> +	       dw[offsetof(struct amap_eq_entry, valid) /
>> +		  32]&  EQE_VALID_MASK) {
>> +		switch ((u32)
>> +			(eqe->
>> +			 dw[offsetof(struct amap_eq_entry, major_code) /
>> +			    32]&  EQE_MAJORCODE_MASK)) {
>> +		case EQ_MAJOR_CODE_COMPLETION:
>> +			/* Determine which CQ to process. */
>> +			if (((eqe->
>> +			      dw[offsetof(struct amap_eq_entry, resource_id) /
>> +				 32]&  EQE_RESID_MASK)>>  16) ==
>> +			    phwi_context->be_cq.id) {
>> +				SE_DEBUG(DBG_LVL_8, "\t\t todo_cq is set\n");
>> +				phba->todo_cq = 1;
>> +			} else {
>> +				SE_DEBUG(DBG_LVL_1,
>> +					 "\t\t Invalid CQ to process\n");
>> +			}
>> +			break;
>> +
>> +		default:
>> +			SE_DEBUG(DBG_LVL_1,
>> +			 "Unexpected struct eq_entry major_code: 0x%x\n",
>> +			  (eqe->dw[offsetof(struct amap_eq_entry, major_code) /
>> +				     32]&  EQE_MAJORCODE_MASK));
>> +		}
>> +
>> +		/* Mark this struct eq_entry as invalid */
>> +		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
>> +		queue_tail_inc(eq);
>> +		eqe = queue_tail_node(eq);
>> +
>> +		num_eq_processed++;
>> +	}
>> +	spin_unlock_irqrestore(&phba->isr_lock, flags);
>> +	queue_work(phba->wq,&phba->work_cqs);
>> +	hwi_ring_eq_db(phba, phwi_context->be_eq.q.id, 0,
>> +			/* clear interrupt */
>> +			num_eq_processed, 1, 1);
>> +	return IRQ_HANDLED;

-- 
Jens Axboe

