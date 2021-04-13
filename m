Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F454C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 18:19:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2F1613C1
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 18:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243143AbhDMSTt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 14:19:49 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:37814 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbhDMSTr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 14:19:47 -0400
Received: by mail-pf1-f182.google.com with SMTP id o123so11970998pfb.4
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 11:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LW9tWiii68EH1+kQJdr9oBqXxyQg9ZlTCFV5/qQ31Ds=;
        b=af6JDdYkekcuP0jg1ybAGnO7MqJn6Djohk28Uqnu/onwPNoOV2JVO08PoZv4cgqgAL
         hW5DKdoFg7vwizufobCLkxDPUucqHj6dqkpKG5DPdiLJY9TxNi/cSPB7jFpyFmueM4Bx
         Y2vhy5GshAKxXT4yV/nCueldknC80aILJRjpjPzNHQsCEKEmxtYi8Vxrndb6uxoMCuHs
         Fo0kHJ7gJ4ReVLrcXmCEMTaWaIpKLbmkRrde/paLl8OS+El+TLxlmtKahGsZdqYquJBi
         X2ywX+Xe0WYmnrMU6MFjH9VCVxML8VIbFRPW+juL79qU+sGBZWG++5jiS5gX2Htc7hpk
         ZLyQ==
X-Gm-Message-State: AOAM530gOAdaBfFeaIOzGsbT9xX2OTL+IXcorzuHNKsVC/bmcNvVCToN
        PF54sfYuG058WbUITfs+Hhs=
X-Google-Smtp-Source: ABdhPJxkK+NOHemB1IRnkzYRwxyUzrKcYMxdifAO/Igyoffkw6eqms6zu4wQs6kQrr7iTWxQWubs4Q==
X-Received: by 2002:a63:dd14:: with SMTP id t20mr33552251pgg.258.1618337964909;
        Tue, 13 Apr 2021 11:19:24 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:345f:c70d:97e0:e2ef? ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id hi5sm2873823pjb.31.2021.04.13.11.19.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Apr 2021 11:19:24 -0700 (PDT)
Subject: Re: [PATCH 19/20] target: Fix several format specifiers
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210413170714.2119-1-bvanassche@acm.org>
 <20210413170714.2119-20-bvanassche@acm.org>
 <b75dff73-80c2-23ca-1a6a-09826b39d5b9@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1c546f50-f9b0-9284-daca-3e6fce178740@acm.org>
Date:   Tue, 13 Apr 2021 11:19:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <b75dff73-80c2-23ca-1a6a-09826b39d5b9@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/13/21 10:47 AM, Mike Christie wrote:
> On 4/13/21 12:07 PM, Bart Van Assche wrote:
>> Use format specifier '%u' to format the u32 and int data types instead of
>> '%hu'.
>>
>> Cc: Mike Christie <michael.christie@oracle.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>  drivers/target/target_core_configfs.c | 6 +++---
>>  drivers/target/target_core_pr.c       | 6 ++----
>>  2 files changed, 5 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
>> index 9cb1ca8421c8..01005a9e5128 100644
>> --- a/drivers/target/target_core_configfs.c
>> +++ b/drivers/target/target_core_configfs.c
>> @@ -2746,7 +2746,7 @@ static ssize_t target_tg_pt_gp_alua_access_state_store(struct config_item *item,
>>  
>>  	if (!tg_pt_gp->tg_pt_gp_valid_id) {
>>  		pr_err("Unable to do implicit ALUA on non valid"
>> -			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
>> +			" tg_pt_gp ID: %u\n", tg_pt_gp->tg_pt_gp_valid_id);
>>  		return -EINVAL;
>>  	}
>>  	if (!target_dev_configured(dev)) {
>> @@ -2798,7 +2798,7 @@ static ssize_t target_tg_pt_gp_alua_access_status_store(
>>  
>>  	if (!tg_pt_gp->tg_pt_gp_valid_id) {
>>  		pr_err("Unable to do set ALUA access status on non"
>> -			" valid tg_pt_gp ID: %hu\n",
>> +			" valid tg_pt_gp ID: %u\n",
>>  			tg_pt_gp->tg_pt_gp_valid_id);
>>  		return -EINVAL;
>>  	}
>> @@ -2853,7 +2853,7 @@ static ssize_t target_tg_pt_gp_alua_support_##_name##_store(		\
>>  									\
>>  	if (!t->tg_pt_gp_valid_id) {					\
>>  		pr_err("Unable to do set " #_name " ALUA state on non"	\
>> -		       " valid tg_pt_gp ID: %hu\n",			\
>> +		       " valid tg_pt_gp ID: %u\n",			\
> 
> Did you just want to drop the tg_pt_gp_valid_id from the messages above?
> Instead make the messages stop at non valid tg_pt_gp. Like for the first one:
> 
> Unable to do implicit ALUA on non valid tg_pt_gp ID.
> 
> It looks like we might have used to print the actual id. That's why we did
> the hu and the message looks like we are printing the id "tg_pt_gp ID:".
> We are now printing just 0 or 1 but it looks like an id value in the message.

Right, printing tg_pt_gp_valid_id if we already know that it is zero is
not very useful. I will remove tg_pt_gp_valid_id from the above pr_err()
statements.

Bart.


