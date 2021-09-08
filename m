Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376F5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 05:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 191B361152
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 05:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbhIHFLD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 01:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232089AbhIHFLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 01:11:02 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B9DC061575
        for <linux-scsi@vger.kernel.org>; Tue,  7 Sep 2021 22:09:54 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id q3so564558plx.4
        for <linux-scsi@vger.kernel.org>; Tue, 07 Sep 2021 22:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yPo1N8Hj0H2W3FnYApqgO3jz0WrsIXSz23WGq3vKxMo=;
        b=UFY4nJnY1VAJpIjoiUU39ivDVUXMUIwBBAEOvs+bQgQgAqvg0nm0rU5VjpZ392eNsM
         HiUooxxu1JOxpgwJ9Kt+RoybUqGI/zY5y+6j753mscd7r7Zas23OLYUdopyVXyNJibYl
         teX/3NCY1QirLysFQeo9EOcfwcHe5uA1MLVjiY2ePjlqnPNu6hLnlpzIalBtntF+ll5i
         y7oS3RpfzqNf7F4fCZ2qqDgcXYR+4TuRdeEuWn+zVA3hnDf1wWK6LvYx7U/5ipkVM8vv
         zrxRWcgLUs0KCqPodW9GzoQ9aj9blT23Y8wdIe9Cv2jhlZvvJaPqjdm4QB1MRcLAHPMO
         d1TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yPo1N8Hj0H2W3FnYApqgO3jz0WrsIXSz23WGq3vKxMo=;
        b=XDxKCAjZDe272AfDuzllcnFQe5xIcnPhYIpmX4vqOtZtvBxjTPBkDevxA4ZiNdvj6i
         yeG0LNMiUzPmbdE345v9e05zHgxvyNigcr4qbsoo3ZvEizphJnhQICdPGaOOn0JZ/NFD
         aaj4P+vig7y/yEFGFvycJht2AQrE/mpaepP2HyHoE2/1HYdotl0qzm5UbwKfzQ5oVLvX
         jGJG5HnFPzDoL5arlBdFEQ6x3knFgRhZAJt9TQ+A1gMwpDzWXXLaTmKQPVfa13jjoCgC
         HmZmmdJtZEY1Ff1wCz30vxxieOfCsourwtJmNiYEDZNIj/FvS2pSCYk8Gvzci7LEfbNF
         P1hQ==
X-Gm-Message-State: AOAM530U5V1zDSZRI1agAT5s9mGtqnD1MDERGmtCAj+BMETbXqAhco7I
        TTC+rLdehzaEVutHTho/95E=
X-Google-Smtp-Source: ABdhPJxpMo70R0sacQWj2fkkt4r03eo21ZCcCq2CCLTGhCRQoCkj67/YFqiZ/dQlzv0fhWf3rQDOJQ==
X-Received: by 2002:a17:902:8c93:b0:13a:1dd7:485b with SMTP id t19-20020a1709028c9300b0013a1dd7485bmr1488901plo.4.1631077794503;
        Tue, 07 Sep 2021 22:09:54 -0700 (PDT)
Received: from [192.168.1.40] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z124sm954679pgz.94.2021.09.07.22.09.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 22:09:54 -0700 (PDT)
Message-ID: <607bc840-ecf3-41db-ec34-7cf1bc75a254@gmail.com>
Date:   Tue, 7 Sep 2021 22:09:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH] lpfc: Fix compilation errors on kernels with no
 CONFIG_DEBUG_FS
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     linux-scsi@vger.kernel.org, Justin Tee <justin.tee@broadcom.com>
References: <20210830231305.6334-1-jsmart2021@gmail.com>
 <YTfwjGOHqKY55cwQ@MSI.localdomain>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <YTfwjGOHqKY55cwQ@MSI.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/7/2021 4:06 PM, Nathan Chancellor wrote:
> On Mon, Aug 30, 2021 at 04:13:05PM -0700, James Smart wrote:
>> The Kernel test robot flagged the following warning:
>> ".../lpfc_init.c:7788:35: error: 'struct lpfc_sli4_hba' has no member
>> named 'c_stat'"
>>
>> Reviewing this issue highlighted that one of the recent patches caused
>> the driver to no longer compile cleanly if CONFIG_DEBUG_FS is not set.
>>
>> Correct the different areas that are failing to compile.
>>
>> Fixes: 02243836ad6f ("scsi: lpfc: Add support for the CM framework")
>> Co-developed-by: Justin Tee <justin.tee@broadcom.com>
>> Signed-off-by: Justin Tee <justin.tee@broadcom.com>
>> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> I got bit by this in certain configurations, it would be helpful to get
> this into mainline sooner rather than later.
> 
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> 
> Couple of comments below.
> 
>> ---
>>   drivers/scsi/lpfc/lpfc_init.c | 12 ++++++++----
>>   drivers/scsi/lpfc/lpfc_nvme.c |  2 --
>>   drivers/scsi/lpfc/lpfc_scsi.c |  4 ----
>>   3 files changed, 8 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
>> index d3f1fa38269f..a6127a51b4fe 100644
>> --- a/drivers/scsi/lpfc/lpfc_init.c
>> +++ b/drivers/scsi/lpfc/lpfc_init.c
>> @@ -8254,7 +8254,11 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>>   		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
>>   				"3331 Failed allocating per cpu cgn stats\n");
>>   		rc = -ENOMEM;
>> -		goto out_free_hba_hdwq_info;
>> +#ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>> +		goto out_free_hba_hdwq_stat;
>> +#else
>> +		goto out_free_hba_idle_stat;
>> +#endif
>>   	}
>>   
>>   	/*
>> @@ -8276,12 +8280,12 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
>>   
>>   	return 0;
>>   
>> -out_free_hba_hdwq_info:
> 
> Wouldn't it be simpler to just move the ifdef up one line and the endif
> down one line to avoid the ifdef in the first hunk?

Yep. It is simpler.

> 
...
> 
> Someone is probably going to come along and complain that the 0L is a
> dead store. I would remove the assignment at the least but it might be
> worth combining the two lines.

NP. I'll take care of it.

-- james

