Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD465C4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 17:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98B92613BE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 17:51:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhE0RxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 13:53:14 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3096 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbhE0RxL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 13:53:11 -0400
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FrZnX0wwXz6Q2XZ;
        Fri, 28 May 2021 01:39:28 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 19:51:34 +0200
Received: from [10.47.88.230] (10.47.88.230) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 27 May
 2021 18:51:33 +0100
Subject: Re: [PATCH] scsi: core: fix failure handling of
 scsi_add_host_with_dma
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
References: <20210526081055.1932084-1-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6e5416aa-be0b-1cb5-918f-5eab93e155cb@huawei.com>
Date:   Thu, 27 May 2021 18:50:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210526081055.1932084-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.230]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/05/2021 09:10, Ming Lei wrote:
> When scsi_add_host_with_dma() return failure, the caller will call
> scsi_host_put(shost) to release everything allocated for this host
> instance. So we can't free allocated stuff in scsi_add_host_with_dma(),
> otherwise double free will be caused.
> 
> Strictly speaking, these host resources allocation should have been
> moved to scsi_host_alloc(), but the allocation may need driver's
> info which can be built between calling scsi_host_alloc() and
> scsi_add_host(), so just keep the allocations in
> scsi_add_host_with_dma().
> 

Hi Ming,

I did an experiment by making scsi_add_host_with_dma() fail by hacking 
the code, like:

                 snprintf(shost->work_q_name, sizeof(shost->work_q_name),
                          "scsi_wq_%d", shost->host_no);
#if 0
              shost->work_q = alloc_workqueue("%s",
                         WQ_SYSFS | __WQ_LEGACY | WQ_MEM_RECLAIM | 
WQ_UNBOUND,
                         1, shost->work_q_name);
#endif

I was finding that the shost gendev kobj kref count was 2 at the "fail" 
label - I would expect 1.

Did you actually ever see the release function - scsi_host_dev_release() 
- being called and causing the double free?

Thanks,
John

> Fixes the problem by relying on host device's release handler to
> release everything.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/hosts.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 624e2582c3df..ef8d2f512fe3 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -281,23 +281,22 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   
>   		if (!shost->work_q) {
>   			error = -EINVAL;
> -			goto out_free_shost_data;
> +			goto out_del_dev;
>   		}
>   	}
>   
>   	error = scsi_sysfs_add_host(shost);
>   	if (error)
> -		goto out_destroy_host;
> +		goto out_del_dev;
>   
>   	scsi_proc_host_add(shost);
>   	scsi_autopm_put_host(shost);
>   	return error;
>   
> - out_destroy_host:
> -	if (shost->work_q)
> -		destroy_workqueue(shost->work_q);
> - out_free_shost_data:
> -	kfree(shost->shost_data);
> +	/*
> +	 * any host allocation in this function will be freed in
> +	 * scsi_host_dev_release, so not free them in the failure path
> +	 */
>    out_del_dev:
>   	device_del(&shost->shost_dev);
>    out_del_gendev:
> @@ -307,7 +306,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	pm_runtime_disable(&shost->shost_gendev);
>   	pm_runtime_set_suspended(&shost->shost_gendev);
>   	pm_runtime_put_noidle(&shost->shost_gendev);
> -	scsi_mq_destroy_tags(shost);
>    fail:
>   	return error;
>   }
> 

