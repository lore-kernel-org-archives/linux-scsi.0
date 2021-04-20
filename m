Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29437C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:59:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A61613C9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhDTPAN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 11:00:13 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:42729 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhDTPAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 11:00:13 -0400
Received: by mail-pl1-f179.google.com with SMTP id v13so6224685ple.9
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 07:59:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AXg1VLC+wDtk6omHmEMMM3KDV65Q/rTKHaxpHKGKOZU=;
        b=Xqh8u/s89G76PEr+c50srhz2+4Sf5H9z5mwrJ1uDPygYE05Pm72gfZCL2dswnMKVYT
         ob02MWaT3PXGh56LjqsnreAmZLqd5Ky8TT5xKXSdOrmBiEKZk10eKKu4plO27fB0Dhxr
         hdz2KEEaqr9JSzidpwLHmf8lHUbVNm475jiC2kD1/WBHObSsJD891B0mccZvpswLrGuR
         s1XyXvYxjxZOeJ5/WDTuv0KRn7XbPK04KIDPxe40xkFJgLWMekXU+hcg8Kk/FzQUm4fQ
         A0MGOAoCkwo/trTcLXKO3hfNlrPxyci0+WzJ91/14wzQLJK/hG/Ki6ck+qrf5Qu6V6mo
         pF/A==
X-Gm-Message-State: AOAM533ppfZICR5WDxUbLz8wGFaR5ZA5Q/12wjmMrvaqdeQ8AdZejkZ3
        Y5nqXoS9Gz21h7j+ybpV+GE=
X-Google-Smtp-Source: ABdhPJymJJSq5rMlz3CE2mFxUqbzovP1jYud3FckUxz0fatjJNFiqJ3TV+bqlOS5lTf4zM6Niocelw==
X-Received: by 2002:a17:90a:fa84:: with SMTP id cu4mr5599767pjb.2.1618930781366;
        Tue, 20 Apr 2021 07:59:41 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b389:6c06:5046:89e? ([2601:647:4000:d7:b389:6c06:5046:89e])
        by smtp.gmail.com with ESMTPSA id hi5sm2689692pjb.31.2021.04.20.07.59.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 07:59:40 -0700 (PDT)
Subject: Re: [PATCH 002/117] Introduce enums for the SAM, message, host and
 driver status codes
To:     Steffen Maier <maier@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-3-bvanassche@acm.org>
 <e2d93fe3-13ad-a1cd-2066-936562d097d5@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7915505f-b275-3131-c6c5-4c2dcf418b32@acm.org>
Date:   Tue, 20 Apr 2021 07:59:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <e2d93fe3-13ad-a1cd-2066-936562d097d5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 2:23 AM, Steffen Maier wrote:
> On 4/20/21 2:06 AM, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index 9afd65eb2c8b..54213c37806b 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -1775,6 +1775,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>>           fallthrough;
>>       case DID_SOFT_ERROR:
>>           return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
>> +    default:
>> +        break;
> 
> Remind me, what are the compiler warnings we use during build?
> Adding a default case seems OK for me if we use -Wswitch-enum, but I'm
> not sure if we only have -Wswitch because then we would not get static
> build warnings if we ever were to add new enum values but forgot to
> address them here?
Hi Steffen,

I think -Wall is enabled by default and also that -Wall implies -Wswitch
but not -Wswitch-enum.

If you want I can change the "default:" label above into an explicit
list of error codes that are not handled.

Thanks,

Bart.
