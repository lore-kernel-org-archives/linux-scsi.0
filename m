Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C97CCC4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 10:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A43892166E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 10:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbgEAKx6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 06:53:58 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2142 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728485AbgEAKx6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 06:53:58 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 3EA40D6DDB43284F7CCE;
        Fri,  1 May 2020 11:53:57 +0100 (IST)
Received: from [127.0.0.1] (10.47.3.165) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Fri, 1 May 2020
 11:53:56 +0100
Subject: Re: [PATCH RFC v3 36/41] scsi: libsas,hisi_sas,mvsas,pm8001: Allocate
 Scsi_cmd for slow task
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-37-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6256986a-2902-0bc9-bd9b-5d223d267c43@huawei.com>
Date:   Fri, 1 May 2020 11:53:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200430131904.5847-37-hare@suse.de>
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

On 30/04/2020 14:18, Hannes Reinecke wrote:
> k *sas_alloc_slow_task(gfp_t flags)
> +struct sas_task *sas_alloc_slow_task(struct sas_ha_struct *ha,
> +				     struct domain_device *dev,
> +				     struct scsi_lun *lun, gfp_t flags)
>   {
>   	struct sas_task *task = sas_alloc_task(flags);
> -	struct sas_task_slow *slow = kmalloc(sizeof(*slow), flags);
> +	struct Scsi_Host *shost = ha->core.shost;
> +	struct sas_task_slow *slow;
>   
> -	if (!task || !slow) {
> -		if (task)
> -			kmem_cache_free(sas_task_cache, task);
> -		kfree(slow);
> +	if (!task)
>   		return NULL;
> +
> +	slow = kzalloc(sizeof(*slow), flags);
> +	if (!slow)
> +		goto out_err_slow;
> +
> +	if (shost->nr_reserved_cmds) {
> +		struct scsi_device *sdev;
> +
> +		if (dev && dev->starget) {
> +			sdev = scsi_device_lookup_by_target(dev->starget,
> +						    scsilun_to_int(lun));
> +			if (!sdev)
> +				goto out_err_scmd;
> +		} else
> +			sdev = ha->core.shost_dev;

Could we always just use the ha->core.shost_dev? I feel that it would 
make the code neater.

Thanks,
John

> +		slow->scmd = scsi_get_reserved_cmd(sdev, DMA_NONE, false);
> +		if (!slow->scmd)
> +			goto out_err_scmd;
> +		ASSIGN_SAS_TASK(slow->scmd, task);
>   	}

