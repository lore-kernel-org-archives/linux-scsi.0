Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC82FC47254
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 10:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7A952166E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 10:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgEAKs0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 06:48:26 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2141 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728352AbgEAKsZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 06:48:25 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 24ADDC1B80BB27D0F0C8;
        Fri,  1 May 2020 11:48:24 +0100 (IST)
Received: from [127.0.0.1] (10.47.3.165) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 1 May 2020
 11:48:23 +0100
Subject: Re: [PATCH RFC v3 41/41] pm8001: use block-layer tags for ccb
 allocation
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-42-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d381fb5b-1ec9-a84c-1311-4e45daa386f0@huawei.com>
Date:   Fri, 1 May 2020 11:47:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-42-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.3.165]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/04/2020 14:19, Hannes Reinecke wrote:

Making this change is good.

>   /**
>     * pm8001_tag_alloc - allocate a empty tag for task used.
>     * @pm8001_ha: our hba struct
> -  * @tag_out: the found empty tag .
> +  * @dev: device from which the tag should be allocated or NULL
>     */
> -inline int pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha, u32 *tag_out)
> +inline u32 pm8001_tag_alloc(struct pm8001_hba_info *pm8001_ha,
> +			    struct domain_device *dev)
>   {
> -	unsigned int tag;
> -	void *bitmap = pm8001_ha->tags;
> -	unsigned long flags;
> +	struct sas_task *task;
> +	struct scsi_lun lun;
>   
> -	spin_lock_irqsave(&pm8001_ha->bitmap_lock, flags);
> -	tag = find_first_zero_bit(bitmap, pm8001_ha->tags_num);
> -	if (tag >= pm8001_ha->tags_num) {
> -		spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
> -		return -SAS_QUEUE_FULL;
> -	}
> -	set_bit(tag, bitmap);
> -	spin_unlock_irqrestore(&pm8001_ha->bitmap_lock, flags);
> -	*tag_out = tag;
> -	return 0;
> -}
> +	int_to_scsilun(0, &lun);
> +	task = sas_alloc_slow_task(pm8001_ha->sas, dev,
> +				   &lun, GFP_KERNEL);

According to the current code in sas_alloc_slow_task(), we should now 
set pm8001 shost->nr_reserved_cmds for this to work. Or always call 
scsi_device_reserved_cmd() in sas_alloc_slow_task().

So even though the current code does not reserve commands, I would 
prefer if it did, as good practice.

Thanks,
John

> +	if (!task)
> +		return -1;
>   
> -void pm8001_tag_init(struct pm8001_hba_info *pm8001_ha)
> -{
> -	int i;
> -	for (i = 0; i < pm8001_ha->tags_num; ++i)
> -		pm8001_tag_free(pm8001_ha, i);
> +	return task->tag;
>   }
>   
>    /**

