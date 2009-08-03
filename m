From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/6] RFC: beiscsi : handles core routines
Date: Mon, 03 Aug 2009 11:57:13 -0500
Message-ID: <4A7716E9.9060307@cs.wisc.edu>
References: <20090728071251.GA13581@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34242 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbZHCQ5X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2009 12:57:23 -0400
In-Reply-To: <20090728071251.GA13581@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, Jens.Axboe@oracle.com

Hey Jens,

Is your block napi code going to go upstream soon? Does it need more 
testing or users?

This driver is just using a normal old work queue for the completion 
path, so I wanted to see about having Jay convert it to your code.



On 07/28/2009 02:13 AM, Jayamohan Kallickal wrote:
> + */
> +irqreturn_t be_isr(int irq, void *dev_id)
> +{
> +	struct beiscsi_hba *phba = NULL;
> +	struct hwi_controller_ws *phwi_controller;
> +	struct hwi_context_memory *phwi_context;
> +	struct be_eq_entry *eqe = NULL;
> +	struct be_queue_info *eq;
> +	unsigned long flags, index;
> +	unsigned int num_eq_processed;
> +
> +	phba = (struct beiscsi_hba *)dev_id;
> +	phwi_controller = GET_HWI_CONTROLLER_WS(phba);
> +	phwi_context = phwi_controller->phwic;
> +	spin_lock_irqsave(&phba->isr_lock, flags);
> +
> +	eq =&phwi_context->be_eq.q;
> +	index = 0;
> +	eqe = queue_tail_node(eq);
> +	if (!eqe)
> +		SE_DEBUG(DBG_LVL_1, "eqe is NULL\n");
> +
> +	num_eq_processed = 0;
> +	while (eqe->
> +	       dw[offsetof(struct amap_eq_entry, valid) /
> +		  32]&  EQE_VALID_MASK) {
> +		switch ((u32)
> +			(eqe->
> +			 dw[offsetof(struct amap_eq_entry, major_code) /
> +			    32]&  EQE_MAJORCODE_MASK)) {
> +		case EQ_MAJOR_CODE_COMPLETION:
> +			/* Determine which CQ to process. */
> +			if (((eqe->
> +			      dw[offsetof(struct amap_eq_entry, resource_id) /
> +				 32]&  EQE_RESID_MASK)>>  16) ==
> +			    phwi_context->be_cq.id) {
> +				SE_DEBUG(DBG_LVL_8, "\t\t todo_cq is set\n");
> +				phba->todo_cq = 1;
> +			} else {
> +				SE_DEBUG(DBG_LVL_1,
> +					 "\t\t Invalid CQ to process\n");
> +			}
> +			break;
> +
> +		default:
> +			SE_DEBUG(DBG_LVL_1,
> +			 "Unexpected struct eq_entry major_code: 0x%x\n",
> +			  (eqe->dw[offsetof(struct amap_eq_entry, major_code) /
> +				     32]&  EQE_MAJORCODE_MASK));
> +		}
> +
> +		/* Mark this struct eq_entry as invalid */
> +		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
> +		queue_tail_inc(eq);
> +		eqe = queue_tail_node(eq);
> +
> +		num_eq_processed++;
> +	}
> +	spin_unlock_irqrestore(&phba->isr_lock, flags);
> +	queue_work(phba->wq,&phba->work_cqs);
> +	hwi_ring_eq_db(phba, phwi_context->be_eq.q.id, 0,
> +			/* clear interrupt */
> +			num_eq_processed, 1, 1);
> +	return IRQ_HANDLED;
