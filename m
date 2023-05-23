Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513C7C77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 17:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237995AbjEWRKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 13:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjEWRKb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 13:10:31 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1759C2
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 10:10:29 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-64d3491609fso3476270b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 10:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684861829; x=1687453829;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jo3xjFpBnr/x+nMMb7I2cW6M50SJXTKNdeEsLZBNoCc=;
        b=fGCjMsFIysDHVqmqy72YmOgCTmO9UOCEdAgVGliqiADw5vZOlmYMqS1DUVA5k5UXGk
         +qKqyDB+pY5Z5SzO5EoR3o+W6QYkALE5K86HSwWfK2Nbjk7s2LLxILIk1tgvUgjN/lc8
         ZsSN2i3gymPMs5GVQ5PBDhugKxSCEjaHHURlPIkO8mFFELNjVR6EbKu4w1fDtPOOEJbv
         rcXn6kDbg9RgngEQjj2NiIgLPUo/SDhtHuIsZUT82VQtNivZohJgyo6HCGy4O9ikFMjt
         HfyrSKUKjwjKe9GNKoZmeyVH/qZEYv+4xLxCvMvHxWgB9EBWyZsQa1uei/n5bea77y1R
         IMxQ==
X-Gm-Message-State: AC+VfDx3rQnxb2KuVNF6dQq0OI1gOiquASMVm5pkEhcHNbemRoiSpnKt
        5p62K/dFBAyYGm7N1HmtXNc=
X-Google-Smtp-Source: ACHHUZ6MVQ9Aiu++oj2PpnzMrIfmg5mlTiZ2ppwBoS3o8J2CncQ9Ut1iBE7J31uQwUJXekFuXbefmg==
X-Received: by 2002:a05:6a00:a14:b0:647:2ce5:57c4 with SMTP id p20-20020a056a000a1400b006472ce557c4mr20664557pfh.5.1684861828752;
        Tue, 23 May 2023 10:10:28 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:24d2:69cd:ef9a:8f83? ([2620:15c:211:201:24d2:69cd:ef9a:8f83])
        by smtp.gmail.com with ESMTPSA id f20-20020aa782d4000000b00634dde2992bsm5982488pfn.132.2023.05.23.10.10.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 10:10:28 -0700 (PDT)
Message-ID: <343be0eb-0650-cc5e-3154-ffe30f92c17d@acm.org>
Date:   Tue, 23 May 2023 10:10:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 3/4] scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
Content-Language: en-US
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230517222359.1066918-1-bvanassche@acm.org>
 <20230517222359.1066918-4-bvanassche@acm.org>
 <957fb6d6-83db-6230-d81c-646e12ed7bf1@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <957fb6d6-83db-6230-d81c-646e12ed7bf1@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/23 09:39, Adrian Hunter wrote:
> On 18/05/23 01:23, Bart Van Assche wrote:
>> Prepare for adding code in ufshcd_queuecommand() that may sleep.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/ufs/core/ufshcd.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index 7ee150d67d49..993034ac1696 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -8756,6 +8756,7 @@ static const struct scsi_host_template ufshcd_driver_template = {
>>   	.max_host_blocked	= 1,
>>   	.track_queue_depth	= 1,
>>   	.skip_settle_delay	= 1,
>> +	.queuecommand_may_block = true,
> 
> Shouldn't this only be for controllers that support
> clock gating?

Hi Adrian,

The overhead of BLK_MQ_F_BLOCKING is small relative to the time required to
queue a UFS command so I think enabling BLK_MQ_F_BLOCKING for all UFS host
controllers is fine. BLK_MQ_F_BLOCKING causes the block layer to use SRCU
instead of RCU. The cost of the sleepable RCU primitives is dominated by
the memory barrier (smp_mb()) in the srcu_read_lock() and srcu_read_unlock()
calls. From kernel/rcu/srcutree.c:

int __srcu_read_lock(struct srcu_struct *ssp)
{
	int idx;

	idx = READ_ONCE(ssp->srcu_idx) & 0x1;
	this_cpu_inc(ssp->sda->srcu_lock_count[idx].counter);
	smp_mb(); /* B */  /* Avoid leaking the critical section. */
	return idx;
}
EXPORT_SYMBOL_GPL(__srcu_read_lock);

void __srcu_read_unlock(struct srcu_struct *ssp, int idx)
{
	smp_mb(); /* C */  /* Avoid leaking the critical section. */
	this_cpu_inc(ssp->sda->srcu_unlock_count[idx].counter);
}
EXPORT_SYMBOL_GPL(__srcu_read_unlock);

The rcu_read_lock() and rcu_read_lock() implementations do not call
smp_mb() as one can see in include/linux/rcupdate.h:

static inline void __rcu_read_lock(void)
{
	preempt_disable();
}

static inline void __rcu_read_unlock(void)
{
	preempt_enable();
	if (IS_ENABLED(CONFIG_RCU_STRICT_GRACE_PERIOD))
		rcu_read_unlock_strict();
}

Thanks,

Bart.

