Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA2DC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11C4F20809
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgLAJul (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:50:41 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2182 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbgLAJul (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 04:50:41 -0500
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Clchr4P69z67KCf;
        Tue,  1 Dec 2020 17:47:40 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 1 Dec 2020 10:49:59 +0100
Received: from [10.47.7.145] (10.47.7.145) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 1 Dec 2020
 09:49:58 +0000
Subject: Re: [PATCH v1 1/3] add io_uring with IOPOLL support in scsi layer
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        <linux-scsi@vger.kernel.org>
CC:     Sumit Saxena <sumit.saxena@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        <linux-block@vger.kernel.org>
References: <20201015133633.61836-1-kashyap.desai@broadcom.com>
 <0531d781-38ed-0098-d5b8-727a3e143dde@huawei.com>
 <ba2f9cb923dc61e523e4ae41db615f9b@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <f6652a11-95e9-3dec-658c-df7a2a4ffa6b@huawei.com>
Date:   Tue, 1 Dec 2020 09:49:32 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <ba2f9cb923dc61e523e4ae41db615f9b@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.7.145]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/11/2020 07:41, Kashyap Desai wrote:
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
>>> 72b12102f777..5a3c383a2bb3 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1766,6 +1766,19 @@ static void scsi_mq_exit_request(struct
>> blk_mq_tag_set *set, struct request *rq,
>>>    			       cmd->sense_buffer);
>>>    }
>>>
>>> +
>>> +static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx) {
>>> +	struct request_queue *q = hctx->queue;
>>> +	struct scsi_device *sdev = q->queuedata;
>>> +	struct Scsi_Host *shost = sdev->host;
>> could we separately set hctx->driver_data = shost or similar for a quicker
>> lookup? I don't see hctx->driver_data set for SCSI currently.
>> Going through the scsi_device looks strange - I know that it is done in
>> scsi_commit_rqs.
> John - I have included your comments. Below is add-on patch which handles
> all your comment except one.
> Below is just compiled (not tested patch). Please let me know if you like to
> handle "scsi_init_hctx" in this patch or shall we do it as a separate patch
> (out of this patch series.) ?

It might be better as a separate patch if you also change 
scsi_commit_rqs() to use hctx->driver_data, which you are currently not 
doing (or showing here).

> 
> 
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1769,9 +1769,7 @@ static void scsi_mq_exit_request(struct blk_mq_tag_set
> *set, struct request *rq,
> 
>   static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
>   {
> -       struct request_queue *q = hctx->queue;
> -       struct scsi_device *sdev = q->queuedata;
> -       struct Scsi_Host *shost = sdev->host;
> +       struct Scsi_Host *shost = hctx->driver_data;
> 
>          if (shost->hostt->mq_poll)
>                  return shost->hostt->mq_poll(shost, hctx->queue_num);
> @@ -1779,6 +1777,14 @@ static int scsi_mq_poll(struct blk_mq_hw_ctx *hctx)
>          return 0;
>   }
> 
> +static int scsi_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
> +                         unsigned int hctx_idx)
> +{
> +       struct Scsi_Host *shost = data;
> +       hctx->driver_data = shost;
> +       return 0;
> +}
> +
>   static int scsi_map_queues(struct blk_mq_tag_set *set)
>   {
>          struct Scsi_Host *shost = container_of(set, struct Scsi_Host,
> tag_set);
> @@ -1846,6 +1852,7 @@ static const struct blk_mq_ops scsi_mq_ops_no_commit =
> {
>          .cleanup_rq     = scsi_cleanup_rq,
>          .busy           = scsi_mq_lld_busy,
>          .map_queues     = scsi_map_queues,
> +       .init_hctx      = scsi_init_hctx,
>          .poll           = scsi_mq_poll,
>   };
> 
> @@ -1875,6 +1882,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
>          .cleanup_rq     = scsi_cleanup_rq,
>          .busy           = scsi_mq_lld_busy,
>          .map_queues     = scsi_map_queues,
> +       .init_hctx      = scsi_init_hctx,
>          .poll           = scsi_mq_poll,
>   };
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 5844374a85b1..cc30df96f5f7 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -9,8 +9,8 @@
>   #include <linux/types.h>
>   #include <linux/timer.h>
>   #include <linux/scatterlist.h>
> -#include <scsi/scsi_host.h>
>   #include <scsi/scsi_device.h>
> +#include <scsi/scsi_host.h>
>   #include <scsi/scsi_request.h>
> 
>   struct Scsi_Host;
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 905ee6b00c55..a0cda0f66b84 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -274,7 +274,7 @@ struct scsi_host_template {
>           * SCSI interface of blk_poll - poll for IO completions.
>           * Possible interface only if scsi LLD expose multiple h/w queues.
>           *
> -        * Return values: Number of completed entries found.
> +        * Return value: Number of completed entries found.
>           *
>           * Status: OPTIONAL
>           */
> 
>>> +
>>> +	if (shost->hostt->mq_poll)
>> to avoid this check, could we reject if .mq_poll is not set and
>> HCTX_TYPE_POLL is?
> Is this urgent or shall we improve later ? I am not able to figure out how
> you want to manage this ? Can you explain little bit ?

I don't think that it will make much overhead difference, so ok to omit 
for now if more trouble than it's worth to implement.

Thanks,
John
