Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13C6C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 08:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9F1620656
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 08:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgHKID3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 04:03:29 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2590 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728064AbgHKID3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Aug 2020 04:03:29 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id DC79ED003AA7FBCAF799;
        Tue, 11 Aug 2020 09:03:27 +0100 (IST)
Received: from [127.0.0.1] (10.210.168.126) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 11 Aug
 2020 09:03:26 +0100
Subject: Re: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>, <bvanassche@acm.org>,
        <hare@suse.com>, <hch@lst.de>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-3-git-send-email-john.garry@huawei.com>
 <20200611025759.GA453671@T590>
 <6ef76cdf-2fb3-0ce8-5b5a-0d7af0145901@huawei.com>
 <8ef58912-d480-a7e1-f04c-da9bd85ea0ae@huawei.com>
 <eaf188d5-dac0-da44-1c83-31ff2860d8fa@suse.de>
 <3b80b46173103c62c2f94e25ff517058@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <3742b7d4-df43-58ae-172d-2ff1ae46c33d@huawei.com>
Date:   Tue, 11 Aug 2020 09:01:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <3b80b46173103c62c2f94e25ff517058@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.168.126]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/08/2020 17:51, Kashyap Desai wrote:
>> tx context.
> Hannes/John - We need one more correction for below patch -
> 
> https://github.com/hisilicon/kernel-dev/commit/ff631eb80aa0449eaeb78a282fd7eff2a9e42f77
> 
> I noticed - that elevator_queued count goes negative mainly because there
> are some case where IO was submitted from dispatch queue(not scheduler
> queue) and request still has "RQF_ELVPRIV" flag set.
> In such cases " dd_finish_request" is called without " dd_insert_request". I
> think it is better to decrement counter once it is taken out from dispatched
> queue. (Ming proposed to use dispatch path for decrementing counter, but I
> somehow did not accounted assuming RQF_ELVPRIV will be set only if IO is
> submitted from scheduler queue.)
> 
> Below is additional change. Can you merge this ?
> 
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c
> index 9d75374..bc413dd 100644
> --- a/block/mq-deadline.c
> +++ b/block/mq-deadline.c
> @@ -385,6 +385,8 @@ static struct request *dd_dispatch_request(struct
> blk_mq_hw_ctx *hctx)
> 
>          spin_lock(&dd->lock);
>          rq = __dd_dispatch_request(dd);
> +       if (rq)
> +               atomic_dec(&rq->mq_hctx->elevator_queued);

Is there any reason why this operation could not be taken outside the 
spinlock? I assume raciness is not a problem with this patch...

>          spin_unlock(&dd->lock);
> 
>          return rq;
> @@ -574,7 +576,6 @@ static void dd_finish_request(struct request *rq)
>                          blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
>                  spin_unlock_irqrestore(&dd->zone_lock, flags);
>          }
> -       atomic_dec(&rq->mq_hctx->elevator_queued);
>   }
> 
>   static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
> --
> 2.9.5
> 
> Kashyap
> .#


btw, can you provide signed-off-by if you want credit upgraded to 
Co-developed-by?

Thanks,
john
