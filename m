Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1687C47087
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 08:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACCFB613E3
	for <linux-scsi@archiver.kernel.org>; Fri, 28 May 2021 08:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhE1IhC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 May 2021 04:37:02 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3105 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbhE1Ig7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2021 04:36:59 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FryWv6RSvz6N3rw;
        Fri, 28 May 2021 16:28:59 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 10:35:22 +0200
Received: from [10.47.88.230] (10.47.88.230) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 28 May
 2021 09:35:22 +0100
Subject: Re: [PATCH V2 1/2] scsi: core: fix failure handling of
 scsi_add_host_with_dma
To:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
References: <20210528011838.2122559-1-ming.lei@redhat.com>
 <20210528011838.2122559-2-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0e3a05ab-2dba-cafd-2840-70a0559a9140@huawei.com>
Date:   Fri, 28 May 2021 09:34:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210528011838.2122559-2-ming.lei@redhat.com>
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

On 28/05/2021 02:18, Ming Lei wrote:
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
> Fixes the problem by relying on host device's release handler to
> release everything.
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

It now looks like we have a memory leak:

unreferenced object 0xffff0410070a4e00 (size 128):
   comm "swapper/0", pid 1, jiffies 4294894100 (age 90.744s)
   hex dump (first 32 bytes):
68 6f 73 74 30 00 00 00 00 00 00 00 00 00 00 00  host0...........
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
[<(____ptrval____)>] __kmalloc_track_caller+0x25c/0x380
[<(____ptrval____)>] kvasprintf+0xe8/0x1a4
[<(____ptrval____)>] kvasprintf_const+0xc8/0x17c
[<(____ptrval____)>] kobject_set_name_vargs+0x58/0xf4
[<(____ptrval____)>] dev_set_name+0xa4/0xe0
[<(____ptrval____)>] scsi_host_alloc+0x45c/0x5d0
[<(____ptrval____)>] hisi_sas_probe+0x40/0x570
[<(____ptrval____)>] hisi_sas_v2_probe+0x1c/0x2c
[<(____ptrval____)>] platform_probe+0x90/0x110
[<(____ptrval____)>] really_probe+0x148/0x744
[<(____ptrval____)>] driver_probe_device+0x8c/0xfc
[<(____ptrval____)>] device_driver_attach+0x11c/0x12c
[<(____ptrval____)>] __driver_attach+0xc8/0x1a0
[<(____ptrval____)>] bus_for_each_dev+0xe4/0x154
[<(____ptrval____)>] driver_attach+0x38/0x50
[<(____ptrval____)>] bus_add_driver+0x1bc/0x2c4
unreferenced object 0xffff001056581800 (size 256):
   comm "swapper/0", pid 1, jiffies 4294894398 (age 89.560s)
   hex dump (first 32 bytes):
00 00 00 00 00 00 00 00 08 18 58 56 10 00 ff ff  ..........XV....
08 18 58 56 10 00 ff ff c0 f4 b4 10 00 80 ff ff  ..XV............
   backtrace:
[<(____ptrval____)>] kmem_cache_alloc+0x298/0x350
[<(____ptrval____)>] device_add+0x6d8/0xc4c
[<(____ptrval____)>] scsi_add_host_with_dma+0x370/0x5dc
[<(____ptrval____)>] hisi_sas_probe+0x418/0x570
[<(____ptrval____)>] hisi_sas_v2_probe+0x1c/0x2c
[<(____ptrval____)>] platform_probe+0x90/0x110
[<(____ptrval____)>] really_probe+0x148/0x744
[<(____ptrval____)>] driver_probe_device+0x8c/0xfc
[<(____ptrval____)>] device_driver_attach+0x11c/0x12c
[<(____ptrval[  101.941505] random: fast init done
____)>] __driver_attach+0xc8/0x1a0
[<(____ptrval____)>] bus_for_each_dev+0xe4/0x154
[<(____ptrval____)>] driver_attach+0x38/0x50
[<(____ptrval____)>] bus_add_driver+0x1bc/0x2c4
[<(____ptrval____)>] driver_register+0xe4/0x210
[<(____ptrval____)>] __platform_driver_register+0x48/0x60
[<(____ptrval____)>] hisi_sas_v2_driver_init+0x20/0x2c

I think that the release for the shost_dev dev name memory needs fixing.

In scsi_host_dev_release(), for my experiment, shost state is running, 
so we miss the kfree(dev_name(&shost->shost_dev)), I guess. Not sure on 
the proper fix.

> ---
>   drivers/scsi/hosts.c | 14 ++++++--------
>   1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 697c09ef259b..ea50856cb203 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -278,23 +278,22 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
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

nit: "so do not free them"

> +	 */
>    out_del_dev:
>   	device_del(&shost->shost_dev);
>    out_del_gendev:
> @@ -304,7 +303,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	pm_runtime_disable(&shost->shost_gendev);
>   	pm_runtime_set_suspended(&shost->shost_gendev);
>   	pm_runtime_put_noidle(&shost->shost_gendev);
> -	scsi_mq_destroy_tags(shost);
>    fail:
>   	return error;
>   }
> 

Thanks,
John

