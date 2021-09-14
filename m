Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A65EFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 16:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8021E61107
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 16:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhINQeb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 12:34:31 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:44004 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhINQeN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 12:34:13 -0400
Received: by mail-pl1-f175.google.com with SMTP id v1so8581476plo.10
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 09:32:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F0rdTAKFHXO3u2CrzJs1GcATZhbo913j02LU5fB/LVQ=;
        b=Qug1gpuYRlJTuXk3NwLXsSG8bBZVB9i3eImgp8Kl+OAGWCoIjbw/URzyjzVIamZyzG
         m7YkolbE5puNfF477mkGR44ruqRS+BHACGlelvYpKrI8ISSOuzU3aXJJsGL8m/BU8X0B
         kbsRIojSOfegMqFC4Klt4jfPt/bXsfKXl13JE5qsLldxZChUnRJof5LLXPfd2wFJU2O7
         tjaUPAAeYgOMCb7cvzSYejqeoqznLot2g5k2JvQx3/mjWf8gwj0UHAC95AAudVCDh6Fy
         DNzAN3FDV4nOshW6pJdYcMt1Wj6L8hwmY05mzTHXKCwsNYz4GHlop/yF+iOS4xF6P95p
         D2rw==
X-Gm-Message-State: AOAM5314rcyFhaTxYNcTWsQ80kz50B81WY5PoMIQ4kPiHLXIDDBO4aSs
        N8OEcFF8HkRXYig0BPNtY94GSbEOmrY=
X-Google-Smtp-Source: ABdhPJw45JvAD5uhMeOaTnUjWCB9LG478yC0P5wEl5EUDHik/1W3yoX8O5f2wNVOhRkidTOX1/q6MA==
X-Received: by 2002:a17:90a:ea0a:: with SMTP id w10mr3138281pjy.32.1631637176013;
        Tue, 14 Sep 2021 09:32:56 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c71d:6cb8:8fe5:9909])
        by smtp.gmail.com with ESMTPSA id k190sm12145414pgc.11.2021.09.14.09.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 09:32:55 -0700 (PDT)
Subject: Re: [PATCH -next 0/2] Fix out-of-bound in resp_readcap16 and
 resp_report_tgtpgs
To:     yebin <yebin10@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Doug Gilbert <dgilbert@interlog.com>
References: <20210818021428.3720233-1-yebin10@huawei.com>
 <614040FD.3000209@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ea7d8f6a-5c70-502f-04e5-af2d0a0a7fcc@acm.org>
Date:   Tue, 14 Sep 2021 09:32:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <614040FD.3000209@huawei.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/13/21 11:28 PM, yebin wrote:
> ping...
> 
> On 2021/8/18 10:14, Ye Bin wrote:
>> Ye Bin (2):
>>    scsi:scsi_debug: Fix out-of-bound in resp_readcap16
>>    scsi:scsi_debug: Fix potential OOB in resp_report_tgtpgs
>>
>>   drivers/scsi/scsi_debug.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)

Hi Doug,

Do you plan to take a look at this patch series? If not, do you want me to
take a look?

Thanks,

Bart.


