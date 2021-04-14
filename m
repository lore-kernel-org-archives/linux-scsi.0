Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B5CC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 10:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31AAC6128E
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 10:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhDNKNh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 06:13:37 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2852 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232201AbhDNKNg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 06:13:36 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FKypP47rfz688dk;
        Wed, 14 Apr 2021 18:07:57 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 14 Apr 2021 12:13:14 +0200
Received: from [10.47.25.158] (10.47.25.158) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 14 Apr
 2021 11:13:13 +0100
Subject: Re: [bug report] shared tags causes IO hang and performance drop
To:     Ming Lei <ming.lei@redhat.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Douglas Gilbert <dgilbert@interlog.com>
References: <YHaez6iN2HHYxYOh@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <9a6145a5-e6ac-3d33-b52a-0823bfc3b864@huawei.com>
Date:   Wed, 14 Apr 2021 11:10:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YHaez6iN2HHYxYOh@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.25.158]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,

> 
> It is reported inside RH that CPU utilization is increased ~20% when
> running simple FIO test inside VM which disk is built on image stored
> on XFS/megaraid_sas.
> 
> When I try to investigate by reproducing the issue via scsi_debug, I found
> IO hang when running randread IO(8k, direct IO, libaio) on scsi_debug disk
> created by the following command:
> 
> 	modprobe scsi_debug host_max_queue=128 submit_queues=$NR_CPUS virtual_gb=256
> 

So I can recreate this hang for using mq-deadline IO sched for scsi 
debug, in that fio does not exit. I'm using v5.12-rc7.

Do you have any idea of what changed to cause this, as we would have 
tested this before? Or maybe only none IO sched on scsi_debug. And 
normally 4k block size and only rw=read (for me, anyway).

Note that host_max_queue=128 will cap submit queue depth at 128, while 
would be 192 by default.

Will check more...including CPU utilization.

Thanks,
John

> Looks it is caused by SCHED_RESTART because current RESTART is just done
> on current hctx, and we may need to restart all hctxs for shared tags, and the
> issue can be fixed by the append patch. However, IOPS drops more than 10% with
> the patch.
> 
> So any idea for this issue and the original performance drop?
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index e1e997af89a0..45188f7aa789 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -59,10 +59,18 @@ EXPORT_SYMBOL_GPL(blk_mq_sched_mark_restart_hctx);
>   
>   void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
>   {
> +	bool shared_tag = blk_mq_is_sbitmap_shared(hctx->flags);
> +
> +	if (shared_tag)
> +		blk_mq_run_hw_queues(hctx->queue, true);
> +
>   	if (!test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
>   		return;
>   	clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
>   
> +	if (shared_tag)
> +		return;
> +
>   	/*
>   	 * Order clearing SCHED_RESTART and list_empty_careful(&hctx->dispatch)
>   	 * in blk_mq_run_hw_queue(). Its pair is the barrier in
> 
> Thanks,
> Ming
> 
> .
> 

