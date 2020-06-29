Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A867C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D99AB206F1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 20:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389692AbgF2U4c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 16:56:32 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2412 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731286AbgF2U4K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 16:56:10 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id F2B7692A48E618E55DAF;
        Mon, 29 Jun 2020 14:10:18 +0100 (IST)
Received: from [127.0.0.1] (10.210.170.8) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 29 Jun
 2020 14:10:18 +0100
Subject: Re: [PATCH 21/22] aacraid: use scsi_get_internal_cmd()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>
References: <20200629072021.9864-1-hare@suse.de>
 <20200629072021.9864-22-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d3ddc77d-11d9-f5ac-784e-af1f75bd5982@huawei.com>
Date:   Mon, 29 Jun 2020 14:08:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200629072021.9864-22-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.170.8]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>   	return fibptr;
>   }
> @@ -240,36 +231,28 @@ struct fib *aac_fib_alloc_tag(struct aac_dev *dev, struct scsi_cmnd *scmd)
>   /**
>    *	aac_fib_alloc	-	allocate a fib
>    *	@dev: Adapter to allocate the fib for
> + *	@direction: DMA data direction
>    *
>    *	Allocate a fib from the adapter fib pool. If the pool is empty we
>    *	return NULL.
>    */
>   
> -struct fib *aac_fib_alloc(struct aac_dev *dev)
> +struct fib *aac_fib_alloc(struct aac_dev *dev, int direction)
>   {
> -	struct fib * fibptr;
> +	struct scsi_cmnd *scmd;
> +	struct fib * fibptr = NULL;
>   	unsigned long flags;
> +
>   	spin_lock_irqsave(&dev->fib_lock, flags);

Do you still require this spinlock'ing?

> -	fibptr = dev->free_fib;
> -	if(!fibptr){
> -		spin_unlock_irqrestore(&dev->fib_lock, flags);
> -		return fibptr;
> -	}
> -	dev->free_fib = fibptr->next;
> +	scmd = scsi_get_internal_cmd(dev->scsi_host_dev, direction,
> +				     REQ_NOWAIT);
> +	if (scmd)
> +		fibptr = aac_fib_alloc_tag(dev, scmd);
>   	spin_unlock_irqrestore(&dev->fib_lock, flags);
> -	/*
> -	 *	Set the proper node type code and node byte size
> -	 */
> -	fibptr->type = FSAFS_NTC_FIB_CONTEXT;
> +	if (!fibptr)
> +		return NULL;
> +
>   	fibptr->size = sizeof(struct fib); > -	/*
> -	 *	Null out fields that depend on being zero at the start of
> -	 *	each I/O
> -	 */
> -	fibptr->hw_fib_va->header.XferState = 0;
> -	fibptr->flags = 0;
> -	fibptr->callback = NULL;
> -	fibptr->callback_data = NULL;
>   
>   	return fibptr;
>   }
> @@ -297,8 +280,12 @@ void aac_fib_free(struct fib *fibptr)
>   			 (void*)fibptr,
>   			 le32_to_cpu(fibptr->hw_fib_va->header.XferState));
>   	}
> -	fibptr->next = fibptr->dev->free_fib;
> -	fibptr->dev->free_fib = fibptr;
> +	if (fibptr->scmd) {
> +		struct scsi_cmnd *scmd = fibptr->scmd;
> +
> +		fibptr->scmd = NULL;
> +		scsi_put_internal_cmd(scmd);
> +	}
>   	spin_unlock_irqrestore(&fibptr->dev->fib_lock, flags);

as above

>   }
