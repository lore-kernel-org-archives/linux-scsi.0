Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FADC433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:22:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B477461448
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 04:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhENEYJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 00:24:09 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53456 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbhENEYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 00:24:08 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620966178; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Tidp5AHB/0G5ZUAyb80f5iXE+ZzUs7+XEoQxUty2e64=;
 b=wlAl7bs3UPZfr+ncAWPoFiWFlwDuFc5VNYsQ+DBeHmciiH+cv13h3PQNXVz/Nq7mgZASfQTN
 v5nQSBrMTarQWLaduAvIcLPsW72wwxAwgUrRz8ed2CgUsZRcT+CpzKhnu28BR61RqvXx1rZu
 lmEI5RHwDvKvXWUvcNqgzyl88WA=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 609dfb1fd951beb69edd9335 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 May 2021 04:22:55
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 31EC8C4323A; Fri, 14 May 2021 04:22:55 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4D6C7C433D3;
        Fri, 14 May 2021 04:22:52 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 14 May 2021 12:22:52 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: Increase the usable queue depth
In-Reply-To: <c8932f54e6e95797c2969a16d07fd926@codeaurora.org>
References: <20210513164912.5683-1-bvanassche@acm.org>
 <c8932f54e6e95797c2969a16d07fd926@codeaurora.org>
Message-ID: <73c8d76ca8af028f27bde8b74f7d0dbd@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-14 12:04, Can Guo wrote:
> Hi Bart,
> 
> On 2021-05-14 00:49, Bart Van Assche wrote:
>> With the current implementation of the UFS driver active_queues is 1
>> instead of 0 if all UFS request queues are idle. That causes
>> hctx_may_queue() to divide the queue depth by 2 when queueing a 
>> request
>> and hence reduces the usable queue depth.
> 
> This is interesting. When all UFS queues are idle, in hctx_may_queue(),
> active_queues reads 1 (users == 1, depth == 32), where is it divided by 
> 2?
> 

Are you saying that if we queue a new request on one of the UFS request
queues, since the active_queues is always above 0, we can never use
the full queue depth? If so, then I agree.

Reviewed-by: Can Guo <cang@codeaurora.org>

> static inline bool hctx_may_queue(struct blk_mq_hw_ctx *hctx,
>                                   struct sbitmap_queue *bt)
> {
>         unsigned int depth, users;
> 
> ....
>                 users = atomic_read(&hctx->tags->active_queues);
>         }
> 
>         if (!users)
>                 return true;
> 
>         /*
>          * Allow at least some tags
>          */
>         depth = max((bt->sb.depth + users - 1) / users, 4U);
>         return __blk_mq_active_requests(hctx) < depth;
> }
> 
> Thanks,
> Can Guo.
> 
>> 
>> The shared tag set code in the block layer keeps track of the number 
>> of
>> active request queues. blk_mq_tag_busy() is called before a request is
>> queued onto a hwq and blk_mq_tag_idle() is called some time after the 
>> hwq
>> became idle. blk_mq_tag_idle() is called from inside 
>> blk_mq_timeout_work().
>> Hence, blk_mq_tag_idle() is only called if a timer is associated with 
>> each
>> request that is submitted to a request queue that shares a tag set 
>> with
>> another request queue. Hence this patch that adds a 
>> blk_mq_start_request()
>> call in ufshcd_exec_dev_cmd(). This patch doubles the queue depth on 
>> my
>> test setup from 16 to 32.
>> 
>> In addition to increasing the usable queue depth, also fix the
>> documentation of the 'timeout' parameter in the header above
>> ufshcd_exec_dev_cmd().
>> 
>> Cc: Can Guo <cang@codeaurora.org>
>> Cc: Alim Akhtar <alim.akhtar@samsung.com>
>> Cc: Avri Altman <avri.altman@wdc.com>
>> Cc: Stanley Chu <stanley.chu@mediatek.com>
>> Cc: Bean Huo <beanhuo@micron.com>
>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>> Fixes: 7252a3603015 ("scsi: ufs: Avoid busy-waiting by eliminating tag
>> conflicts")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index c96e36aab989..e669243354da 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2838,7 +2838,7 @@ static int ufshcd_wait_for_dev_cmd(struct 
>> ufs_hba *hba,
>>   * ufshcd_exec_dev_cmd - API for sending device management requests
>>   * @hba: UFS hba
>>   * @cmd_type: specifies the type (NOP, Query...)
>> - * @timeout: time in seconds
>> + * @timeout: timeout in milliseconds
>>   *
>>   * NOTE: Since there is only one available tag for device management 
>> commands,
>>   * it is expected you hold the hba->dev_cmd.lock mutex.
>> @@ -2868,6 +2868,9 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba 
>> *hba,
>>  	}
>>  	tag = req->tag;
>>  	WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
>> +	/* Set the timeout such that the SCSI error handler is not 
>> activated. */
>> +	req->timeout = msecs_to_jiffies(2 * timeout);
>> +	blk_mq_start_request(req);
>> 
>>  	init_completion(&wait);
>>  	lrbp = &hba->lrb[tag];
