Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3ACFC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 17:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95CEE64FCF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 17:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbhCIRPl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 12:15:41 -0500
Received: from mail-pg1-f179.google.com ([209.85.215.179]:39893 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhCIRPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 12:15:11 -0500
Received: by mail-pg1-f179.google.com with SMTP id x29so9210204pgk.6;
        Tue, 09 Mar 2021 09:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IhwVS2D8UkJ+LBQWdC/ly8SR5Kmt1JsG8/atOpjGQbA=;
        b=gkCO13k7dlxsWmlh11f3zA60/77CRKstkI+JxK3xsmPs74r4rCGg+kpgBNuqYS9LXw
         Ol5ZW9cZaCGTkVh2ZNlQ3YT799O4kZjKZmjdoSBjrZcN9i6BNdTE3Qgh12IC0fbVAVl1
         rceb7MfUnNxKnfjsIuKnaWfSVLyy7D1r79fDOvYd56oOKGnoTeU6qG9YZxzcrAQJjDQo
         xwakJPn68SNbWf/SCLYLPRoqWRKVnGMPU5KMmmxTXpUqXJiN54TCdKnxXJNaBaSrebGr
         PfObb2baarWiNvNQCrtaxQhWKgK9J7Xj7I0WDuU+W6z2hViAo0aWnSWnJ10Xi05iBcmM
         sEHQ==
X-Gm-Message-State: AOAM530MddsIdMe7jUCcAL+sa6ATsZi5UKOxmXCdLQHQEdC2FgonNSIn
        8jX5AXncEvayPz+D+FF/kOY=
X-Google-Smtp-Source: ABdhPJzbbLwoRBqhwNq46k1/pwq7NVyXufzhaLG4TQ/R62OiDGbUpv+vsa5eH0J974mp36HNzX0gzA==
X-Received: by 2002:aa7:9145:0:b029:1ed:d58b:e276 with SMTP id 5-20020aa791450000b02901edd58be276mr26199953pfi.25.1615310111275;
        Tue, 09 Mar 2021 09:15:11 -0800 (PST)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k11sm13022739pfc.22.2021.03.09.09.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 09:15:10 -0800 (PST)
Subject: Re: [PATCH 00/23] target: code cleanup
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>
Cc:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "houpu@bytedance.com" <houpu@bytedance.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <BYAPR04MB496548D9C37AD2AFCB2974E886929@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9680a154-d360-39ba-1da5-717ec2ebe458@acm.org>
Date:   Tue, 9 Mar 2021 09:15:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB496548D9C37AD2AFCB2974E886929@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/8/21 9:04 PM, Chaitanya Kulkarni wrote:
> Bart, Martin, Hannes,
> 
> On 2/27/21 21:56, Chaitanya Kulkarni wrote:
>> Hi,
>>
>> This removes unused macros, various memset, extra variable in the
>> target/iblock for bio get and fixes type mismatch for the same.
>>
>> The unused macros warning are found at compile time and they are
>> documented in each patch commit log. For memset removal, there are no
>> warnings.
>>
>> First four patches are target_core_iblock.c cleanup. The next six
>> patches are removal of the unused macros followed by elevan patches to
>> remove the memset for local array buffers. The last patch is for
>> removing the duplicate memset to initialize the buffer to 0xff.
>>   
>> I've tested this patch series with creating target bdev backend with
>> loop back transport, fio verification job seems to work fine.
>>
>> Any feedback is welcome.
>>
>> This is generated on today's linux-block for-next.
>>
>> -ck
> 
> any comments on this ?

Although I'm not sure all patches in this series are useful, the patches 
in this series look good to me.

Bart.


