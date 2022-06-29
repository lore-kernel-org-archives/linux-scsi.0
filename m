Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AD9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 22:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiF2WGu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiF2WGu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 18:06:50 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4D6340CA
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 15:06:46 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id a15so16305123pfv.13
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 15:06:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3KSVN6JVejM3cO4In2m0beBFftj0UuguDc5dY5ZSqRA=;
        b=JgwKhb/v0dUGIX/NYCb2dGdMsPbGeP8mA9CNsdS49O3aO7AEY6G4KIUakKABp64Qqg
         +Vdlyul9yOjjpadVHHaDGLVSfFhNHMCYRUebMP/XhkinSnYZ9v70KsLlf11n2CyF+5bB
         lLfPTDRYlDo1iDiiqphbNbQGQMieo6Klm77y0UNTFkCPqiRsX0NzaaODxbjwsJGL0FP3
         GzVGfDdgCztNVk3allAnMxgJc5pC0PzoKt+T6KUm2Q4WWaefp8lZeMJLhvx6BtXXt3jY
         HpOhoH6TwODfNPpxW6FDAxl2eQerIQgfBS/OrCxVqCKgzcZhB0vFYRQgraR8GEQNWd9X
         PNUQ==
X-Gm-Message-State: AJIora+u1lQ1cWOSa8PLVxEz/V8gsq+zLinTYz/fT650Bjblkajzq1Zq
        LHpJRHI9iH0/Pn07rajnu9o=
X-Google-Smtp-Source: AGRyM1tU0WHOn2HcymaWxTGBeM37iwEZEvwowSMwisoMqx6dmZLpv/a8R+v3vy1+rhmYgGM2Pevdeg==
X-Received: by 2002:a62:7cc3:0:b0:525:20fc:275f with SMTP id x186-20020a627cc3000000b0052520fc275fmr11118159pfc.70.1656540406220;
        Wed, 29 Jun 2022 15:06:46 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:3841:49ce:cba5:1586? ([2620:15c:211:201:3841:49ce:cba5:1586])
        by smtp.gmail.com with ESMTPSA id a3-20020aa780c3000000b0050dc76281f8sm11947766pfn.210.2022.06.29.15.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 15:06:45 -0700 (PDT)
Message-ID: <a33b3450-f4fc-df07-dec7-137956ee332d@acm.org>
Date:   Wed, 29 Jun 2022 15:06:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/3] scsi: core: Retry after a delay if the device is
 becoming ready
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220628222131.14780-1-bvanassche@acm.org>
 <20220628222131.14780-3-bvanassche@acm.org> <YrupM8k8uG3HIRmt@T590>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <YrupM8k8uG3HIRmt@T590>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/22 18:21, Ming Lei wrote:
> On Tue, Jun 28, 2022 at 03:21:30PM -0700, Bart Van Assche wrote:
>> If a logical unit reports that it is becoming ready, retry the command
>> after a delay instead of retrying immediately.
>>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Hannes Reinecke <hare@suse.de>
>> Cc: John Garry <john.garry@huawei.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/scsi_error.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 49ef864df581..fb7e363c4c00 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -625,10 +625,10 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>>   			return NEEDS_RETRY;
>>   		/*
>>   		 * if the device is in the process of becoming ready, we
>> -		 * should retry.
>> +		 * should retry after a delay.
>>   		 */
>>   		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
>> -			return NEEDS_RETRY;
>> +			return ADD_TO_MLQUEUE;
> 
> The above code & commit log just said changing to retry after a delay, but not
> explains why, care to document reason why the delay is useful?

I came up with this patch because I was concerned about the impact of the LOGICAL
UNIT IS IN PROCESS OF BECOMING READY response on the START command. While reviewing
SBC-4 I noticed that that response can be produced for any command but not for the
START command with IMM=0. So I think this patch can be dropped since
sd_start_stop_device() does not set the IMM flag.

Thanks,

Bart.
