Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B4EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F409064E38
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 07:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhCAHPh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:15:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:58160 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232081AbhCAHPe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 02:15:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EEF0AAD29;
        Mon,  1 Mar 2021 07:14:51 +0000 (UTC)
Subject: Re: [PATCH 17/24] mpi3mr: add support of threaded isr
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-18-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <57154fa9-e795-6cd5-25e8-8b4282879f1c@suse.de>
Date:   Mon, 1 Mar 2021 08:14:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-18-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Register driver for threaded interrupt.
> 
> By default, driver will attempt io completion from interrupt context
> (primary handler). Since driver tracks per reply queue outstanding ios,
> it will schedule threaded ISR if there are any outstanding IOs expected
> on that particular reply queue. Threaded ISR (secondary handler) will loop
> for IO completion as long as there are outstanding IOs
> (speculative method using same per reply queue outstanding counter)
> or it has completed some X amount of commands (something like budget).
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h    | 12 ++++++
>   drivers/scsi/mpi3mr/mpi3mr_fw.c | 75 +++++++++++++++++++++++++++++++--
>   2 files changed, 84 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 74b6b4b6e322..41a8689b46c9 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -144,6 +144,10 @@ extern struct list_head mrioc_list;
>   /* Default target device queue depth */
>   #define MPI3MR_DEFAULT_SDEV_QD	32
>   
> +/* Definitions for Threaded IRQ poll*/
> +#define MPI3MR_IRQ_POLL_SLEEP			2
> +#define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
> +
>   /* SGE Flag definition */
>   #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
>   	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
> @@ -295,6 +299,9 @@ struct op_req_qinfo {
>    * @q_segment_list: Segment list base virtual address
>    * @q_segment_list_dma: Segment list base DMA address
>    * @ephase: Expected phased identifier for the reply queue
> + * @pend_ios: Number of IOs pending in HW for this queue
> + * @enable_irq_poll: Flag to indicate polling is enabled
> + * @in_use: Queue is handled by poll/ISR
>    */
>   struct op_reply_qinfo {
>   	u16 ci;
> @@ -306,6 +313,9 @@ struct op_reply_qinfo {
>   	void *q_segment_list;
>   	dma_addr_t q_segment_list_dma;
>   	u8 ephase;
> +	atomic_t pend_ios;
> +	bool enable_irq_poll;
> +	atomic_t in_use;
>   };
>   
>   /**
> @@ -559,6 +569,7 @@ struct scmd_priv {
>    * @shost: Scsi_Host pointer
>    * @id: Controller ID
>    * @cpu_count: Number of online CPUs
> + * @irqpoll_sleep: usleep unit used in threaded isr irqpoll
>    * @name: Controller ASCII name
>    * @driver_name: Driver ASCII name
>    * @sysif_regs: System interface registers virtual address
> @@ -660,6 +671,7 @@ struct mpi3mr_ioc {
>   	u8 id;
>   	int cpu_count;
>   	bool enable_segqueue;
> +	u32 irqpoll_sleep;
>   
>   	char name[MPI3MR_NAME_LENGTH];
>   	char driver_name[MPI3MR_NAME_LENGTH];
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index ba4bfcc17809..4c4e21fb4ef3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -346,12 +346,16 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
>   
>   	reply_qidx = op_reply_q->qid - 1;
>   
> +	if (!atomic_add_unless(&op_reply_q->in_use, 1, 1))
> +		return 0;
> +
>   	exp_phase = op_reply_q->ephase;
>   	reply_ci = op_reply_q->ci;
>   
>   	reply_desc = mpi3mr_get_reply_desc(op_reply_q, reply_ci);
>   	if ((le16_to_cpu(reply_desc->ReplyFlags) &
>   	    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase) {
> +		atomic_dec(&op_reply_q->in_use);
>   		return 0;
>   	}
>   
> @@ -364,6 +368,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
>   
>   		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
>   		    reply_qidx);
> +		atomic_dec(&op_reply_q->pend_ios);
>   		if (reply_dma)
>   			mpi3mr_repost_reply_buf(mrioc, reply_dma);
>   		num_op_reply++;
> @@ -378,6 +383,14 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
>   		if ((le16_to_cpu(reply_desc->ReplyFlags) &
>   		    MPI3_REPLY_DESCRIPT_FLAGS_PHASE_MASK) != exp_phase)
>   			break;
> +		/*
> +		 * Exit completion loop to avoid CPU lockup
> +		 * Ensure remaining completion happens from threaded ISR.
> +		 */
> +		if (num_op_reply > mrioc->max_host_ios) {
> +			intr_info->op_reply_q->enable_irq_poll = true;
> +			break;
> +		}
>   
>   	} while (1);
>   
> @@ -386,6 +399,7 @@ static int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
>   	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ConsumerIndex);
>   	op_reply_q->ci = reply_ci;
>   	op_reply_q->ephase = exp_phase;
> +	atomic_dec(&op_reply_q->in_use);
>   
>   	return num_op_reply;
>   }
> @@ -395,7 +409,7 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
>   	struct mpi3mr_intr_info *intr_info = privdata;
>   	struct mpi3mr_ioc *mrioc;
>   	u16 midx;
> -	u32 num_admin_replies = 0;
> +	u32 num_admin_replies = 0, num_op_reply = 0;
>   
>   	if (!intr_info)
>   		return IRQ_NONE;
> @@ -409,8 +423,10 @@ static irqreturn_t mpi3mr_isr_primary(int irq, void *privdata)
>   
>   	if (!midx)
>   		num_admin_replies = mpi3mr_process_admin_reply_q(mrioc);
> +	if (intr_info->op_reply_q)
> +		num_op_reply = mpi3mr_process_op_reply_q(mrioc, intr_info);
>   
> -	if (num_admin_replies)
> +	if (num_admin_replies || num_op_reply)
>   		return IRQ_HANDLED;
>   	else
>   		return IRQ_NONE;
> @@ -431,7 +447,20 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
>   	/* Call primary ISR routine */
>   	ret = mpi3mr_isr_primary(irq, privdata);
>   
> -	return ret;
> +	/*
> +	 * If more IOs are expected, schedule IRQ polling thread.
> +	 * Otherwise exit from ISR.
> +	 */
> +	if (!intr_info->op_reply_q)
> +		return ret;
> +
> +	if (!intr_info->op_reply_q->enable_irq_poll ||
> +	    !atomic_read(&intr_info->op_reply_q->pend_ios))
> +		return ret;
> +
> +	disable_irq_nosync(pci_irq_vector(mrioc->pdev, midx));
> +
> +	return IRQ_WAKE_THREAD;
>   }
>   
>   /**
> @@ -446,6 +475,36 @@ static irqreturn_t mpi3mr_isr(int irq, void *privdata)
>    */
>   static irqreturn_t mpi3mr_isr_poll(int irq, void *privdata)
>   {
> +	struct mpi3mr_intr_info *intr_info = privdata;
> +	struct mpi3mr_ioc *mrioc;
> +	u16 midx;
> +	u32 num_admin_replies = 0, num_op_reply = 0;
> +
> +	if (!intr_info || !intr_info->op_reply_q)
> +		return IRQ_NONE;
> +
> +	mrioc = intr_info->mrioc;
> +	midx = intr_info->msix_index;
> +
> +	/* Poll for pending IOs completions */
> +	do {
> +		if (!mrioc->intr_enabled)
> +			break;
> +
> +		if (!midx)
> +			num_admin_replies = mpi3mr_process_admin_reply_q(mrioc);
> +		if (intr_info->op_reply_q)
> +			num_op_reply +=
> +			    mpi3mr_process_op_reply_q(mrioc, intr_info);
> +
> +		usleep_range(mrioc->irqpoll_sleep, 10 * mrioc->irqpoll_sleep);
> +
> +	} while (atomic_read(&intr_info->op_reply_q->pend_ios) &&
> +	    (num_op_reply < mrioc->max_host_ios));
> +
> +	intr_info->op_reply_q->enable_irq_poll = false;
> +	enable_irq(pci_irq_vector(mrioc->pdev, midx));
> +
>   	return IRQ_HANDLED;
>   }
>   
> @@ -1161,6 +1220,9 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
>   	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
>   	op_reply_q->ci = 0;
>   	op_reply_q->ephase = 1;
> +	atomic_set(&op_reply_q->pend_ios, 0);
> +	atomic_set(&op_reply_q->in_use, 0);
> +	op_reply_q->enable_irq_poll = false;
>   
>   	if (!op_reply_q->q_segments) {
>   		retval = mpi3mr_alloc_op_reply_q_segments(mrioc, qidx);
> @@ -1482,6 +1544,10 @@ int mpi3mr_op_request_post(struct mpi3mr_ioc *mrioc,
>   		pi = 0;
>   	op_req_q->pi = pi;
>   
> +	if (atomic_inc_return(&mrioc->op_reply_qinfo[reply_qidx].pend_ios)
> +	    > MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT)
> +		mrioc->op_reply_qinfo[reply_qidx].enable_irq_poll = true;
> +
>   	writel(op_req_q->pi,
>   	    &mrioc->sysif_regs->OperQueueIndexes[reply_qidx].ProducerIndex);
>   
> @@ -2783,6 +2849,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
>   	u32 ioc_status, ioc_config, i;
>   	Mpi3IOCFactsData_t facts_data;
>   
> +	mrioc->irqpoll_sleep = MPI3MR_IRQ_POLL_SLEEP;
>   	mrioc->change_count = 0;
>   	if (!re_init) {
>   		mrioc->cpu_count = num_online_cpus();
> @@ -3068,6 +3135,8 @@ static void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
>   		mrioc->op_reply_qinfo[i].ci = 0;
>   		mrioc->op_reply_qinfo[i].num_replies = 0;
>   		mrioc->op_reply_qinfo[i].ephase = 0;
> +		atomic_set(&mrioc->op_reply_qinfo[i].pend_ios, 0);
> +		atomic_set(&mrioc->op_reply_qinfo[i].in_use, 0);
>   		mpi3mr_memset_op_reply_q_buffers(mrioc, i);
>   
>   		mrioc->req_qinfo[i].ci = 0;
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
