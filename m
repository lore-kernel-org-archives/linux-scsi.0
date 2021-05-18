Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D38C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 21:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7811B60FE3
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 21:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhERVWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 17:22:51 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:39500 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbhERVWu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 17:22:50 -0400
Received: by mail-pf1-f181.google.com with SMTP id c17so8384207pfn.6
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 14:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+E8mpT7TA8viJWXCX32oQUfVHCiH8RtDoaMQ0vrY2u0=;
        b=r+AYCT+7bfB6J8J+pNnAmlLiLSvki/pnnQbTefmrDTNktaCbzK+Dja0nMtozIdYjUQ
         2F+UpPKxMtpeB7PutSafjtUtrtTkH2cKJ0i3tVdF3VeNM+D7q/ed5buX+rs8mOwHmlEt
         V13uQmfZPpWjQgKyrJi/fiNdkjmt05PTu4eH5ASHaW4R5iKeRF+eTP8OWYgNUAonr6gJ
         gwryxizjb/5djfBsNxJnon/Agge7tyMk5/tO+ryKwtQ29S+s97S5i0TF4B89XsIcLuDl
         Q4xQ0xlABAcztf4oqs8QiVfe7y4Kv9a+NfWY28oAUO0UFVJ9RFpXNVGXl7LZAAmugqe5
         /uEg==
X-Gm-Message-State: AOAM5320hsUGLe9BiRvkCnuZuNI/Nv0SuW8FwiKpc7q3yk/IXuDetsY2
        6BCOWSh+sOZZEOhk6Z0X9WJze96MnWZTkQ==
X-Google-Smtp-Source: ABdhPJy2RL8wtoIu5zIs5zn0rZO5RXXGibpvXYE88SOXoHSDaKToFrKLUSGfGX47s1O/Ecyy6S5h4g==
X-Received: by 2002:a63:1443:: with SMTP id 3mr7115643pgu.69.1621372891343;
        Tue, 18 May 2021 14:21:31 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:4ae4:fc49:eafe:4150? ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id j16sm4370784pfi.92.2021.05.18.14.21.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 14:21:30 -0700 (PDT)
Subject: Re: [PATCH v2 00/50] Remove the request pointer from struct scsi_cmnd
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20210518174450.20664-1-bvanassche@acm.org>
 <af39cb904e0f0450549f9fdcee3c256e61bfab93.camel@HansenPartnership.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f3dae885-5826-11da-0eec-04f0a3e04cd9@acm.org>
Date:   Tue, 18 May 2021 14:21:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <af39cb904e0f0450549f9fdcee3c256e61bfab93.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/18/21 10:55 AM, James Bottomley wrote:
> On Tue, 2021-05-18 at 10:44 -0700, Bart Van Assche wrote:
>> Hi Martin,
>>
>> This patch series implements the following two changes for all SCSI
>> drivers:
>> - Use blk_mq_rq_from_pdu() instead of the request member of struct
>> scsi_cmnd
>>   since adding an offset to a pointer is faster than pointer
>> indirection.
> 
> Are there any performance results to back up this assertion?  It's
> quite a lot of churn so it would be nice to know it's worth it.

I have not yet run any performance measurements because I expect that it
will be challenging to measure the performance impact of a change like
this one accurately. The performance measurement tool itself (e.g. fio)
might introduce more variation between runs than the performance
improvement of this patch series. Another reason I have not yet run any
performance measurements is because I was assuming that everyone would
be happy with a patch series that makes code faster and that reduces the
size of a key SCSI data structure.

Anyway, I have run 'make drivers/scsi/scsi_lib.lst' with and without
this patch series applied. What I see is that without this patch series
the assembly code for converting a SCSI command pointer into a request
pointer looks like this:

48 8b bb 10 01 00 00    mov    0x110(%rbx),%rdi

With this patch series applied that conversion code changes into the
following:

48 8d bb f0 fe ff ff    lea    -0x110(%rbx),%rdi

The above shows that struct request has a size of 0x110 = 272 bytes with
my kernel configuration.

This illustrates that this patch series realizes an improvement since
"mov" instructions used for converting SCSI command pointers into struct
request pointers are converted into "lea" instructions. "mov" fetches
data from memory while "lea" does not.

Bart.
