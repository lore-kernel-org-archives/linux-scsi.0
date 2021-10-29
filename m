Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85385C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AFF361056
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 13:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhJ2No0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 09:44:26 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:4040 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhJ2NoZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 09:44:25 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Hgk4T4t3tz68700;
        Fri, 29 Oct 2021 21:37:13 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 15:41:55 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 14:41:54 +0100
Subject: Re: [PATCH v2] scsi: be2iscsi: Replace irq_poll with threaded IRQ
 handler.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-scsi@vger.kernel.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20211029074902.4fayed6mcltifgdz@linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d5212154-0dd7-58ac-9fc3-25d77fe2a8fa@huawei.com>
Date:   Fri, 29 Oct 2021 14:41:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211029074902.4fayed6mcltifgdz@linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static irqreturn_t be_iopoll(struct be_eq_obj *pbe_eq)
> +{
> +	struct beiscsi_hba *phba;
> +	unsigned int ret, io_events;
> +	struct be_eq_entry *eqe = NULL;
> +	struct be_queue_info *eq;
> +
> +	phba = pbe_eq->phba;
> +	if (beiscsi_hba_in_error(phba))
> +		return IRQ_NONE;
> +
> +	io_events = 0;
> +	eq = &pbe_eq->q;
> +	eqe = queue_tail_node(eq);
> +	while (eqe->dw[offsetof(struct amap_eq_entry, valid) / 32] &
> +			EQE_VALID_MASK) {
> +		AMAP_SET_BITS(struct amap_eq_entry, valid, eqe, 0);
> +		queue_tail_inc(eq);
> +		eqe = queue_tail_node(eq);
> +		io_events++;
> +	}
> +	hwi_ring_eq_db(phba, eq->id, 1, io_events, 0, 1);
> +
> +	ret = beiscsi_process_cq(pbe_eq);
> +	pbe_eq->cq_count += ret;
> +	beiscsi_log(phba, KERN_INFO,
> +		    BEISCSI_LOG_CONFIG | BEISCSI_LOG_IO,
> +		    "BM_%d : rearm pbe_eq->q.id =%d ret %d\n",
> +		    pbe_eq->q.id, ret);
> +	if (!beiscsi_hba_in_error(phba))
> +		hwi_ring_eq_db(phba, pbe_eq->q.id, 0, 0, 1, 1);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static irqreturn_t be_isr_misx_th(int irq, void *dev_id)
> +{
> +	struct be_eq_obj *pbe_eq  = dev_id;
> +
> +	return be_iopoll(pbe_eq);
> +}
> +
>   /**
>    * be_isr_msix - The isr routine of the driver.
>    * @irq: Not used
> @@ -713,9 +752,22 @@ static irqreturn_t be_isr_msix(int irq, void *dev_id)
>   	phba = pbe_eq->phba;
>   	/* disable interrupt till iopoll completes */
>   	hwi_ring_eq_db(phba, eq->id, 1,	0, 0, 1);
> -	irq_poll_sched(&pbe_eq->iopoll);
>   
> -	return IRQ_HANDLED;
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static irqreturn_t be_isr_thread(int irq, void *dev_id)
> +{
> +	struct beiscsi_hba *phba;
> +	struct hwi_controller *phwi_ctrlr;
> +	struct hwi_context_memory *phwi_context;
> +	struct be_eq_obj *pbe_eq;
> +
> +	phba = dev_id;
> +	phwi_ctrlr = phba->phwi_ctrlr;
> +	phwi_context = phwi_ctrlr->phwi_ctxt;
> +	pbe_eq = &phwi_context->be_eq[0];
> +	return be_iopoll(pbe_eq);
>   }
>   
>   /**
> @@ -735,6 +787,7 @@ static irqreturn_t be_isr(int irq, void *dev_id)
>   	struct be_ctrl_info *ctrl;
>   	struct be_eq_obj *pbe_eq;
>   	int isr, rearm;
> +	irqreturn_t ret;
>   
>   	phba = dev_id;
>   	ctrl = &phba->ctrl;
> @@ -774,10 +827,11 @@ static irqreturn_t be_isr(int irq, void *dev_id)
>   		/* rearm for MCCQ */
>   		rearm = 1;
>   	}
> +	ret = IRQ_HANDLED;
>   	if (io_events)
> -		irq_poll_sched(&pbe_eq->iopoll);
> +		ret = IRQ_WAKE_THREAD;
>   	hwi_ring_eq_db(phba, eq->id, 0, (io_events + mcc_events), rearm, 1);
> -	return IRQ_HANDLED;
> +	return ret;
>   }
>   
>   static void beiscsi_free_irqs(struct beiscsi_hba *phba)
> @@ -819,9 +873,10 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
>   				goto free_msix_irqs;
>   			}
>   
> -			ret = request_irq(pci_irq_vector(pcidev, i),
> -					  be_isr_msix, 0, phba->msi_name[i],
> -					  &phwi_context->be_eq[i]);
> +			ret = request_threaded_irq(pci_irq_vector(pcidev, i),
> +						   be_isr_msix, be_isr_misx_th,
> +						   0, phba->msi_name[i],
> +						   &phwi_context->be_eq[i]);

Would it be sensible to set ONESHOT flag here? I assume that we don't 
want the hard irq handler firing continuously while we poll completions 
in the threaded handler. That's my understanding of how ONESHOT should 
or would work... they currently seem to manually disable in 
be_isr_msix() -> hwi_ring_eq_db() for the same purpose, I guess.

Thanks,
John

