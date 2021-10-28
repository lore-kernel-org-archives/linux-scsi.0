Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41640C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B72608FB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhJ1U4G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:56:06 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:44898 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbhJ1U4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2021 16:56:05 -0400
Received: by mail-pf1-f170.google.com with SMTP id a26so7076347pfr.11;
        Thu, 28 Oct 2021 13:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=53hJGGwZpzRu5RUX9RBgGrb7hsPcvv9GN9T8wxu6NEw=;
        b=asckzHS9VBGYdZhv+0YhMy8ZnkFOfVYV4Xs6N6OCFuysutl0AXJagid2I7SaFQRH9m
         xhmjepiylVplJngVAuBzwDN1By0tAgXcLNI237fG1fWz6WH/+RPVZdWZQ4UhhfF7kavT
         JAoOHOH/htX92CIgmgvNgCdQSF7uU4KRiv3aG7GgedGNcPkUZL9cN66myQrB9HC9p8Rb
         qU30rPOr4tonVZghI8TRYhdjqSYVrnN6DPOORZ2fTatNXuRoGHlUzhQG+erHx4WaJJz4
         bk3AvstIfvReTCVq5/LrgprF1EYrMtLLEwXQVXDYCTUp12J6qPdthiSYqcRf/FaRmUk8
         l+JA==
X-Gm-Message-State: AOAM531N69/ARgo0J6GIJd5kMxQaBoLXuqB++CvO5P92v7wOIcljFcV2
        irI6qRLOAy5TCxQ0Qz0cWQs=
X-Google-Smtp-Source: ABdhPJxs/mwQZw2E6fuIQod6mlK+HBVShLxwOYiqMMnlfIq9HbDobgKrwxa9zaDs8uxqifGj+86y6w==
X-Received: by 2002:a63:1cd:: with SMTP id 196mr4908239pgb.39.1635454418269;
        Thu, 28 Oct 2021 13:53:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:e816:bd0d:426c:f959])
        by smtp.gmail.com with ESMTPSA id b2sm3511228pgh.33.2021.10.28.13.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 13:53:37 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Jaegeuk Kim <jaegeuk@kernel.org>,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Daejun Park <daejun7.park@samsung.com>
References: <20211026071204.1709318-1-hch@lst.de>
 <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
 <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org> <20211027052724.GA8946@lst.de>
 <b2bcc13ccdc584962128a69fa5992936068e1a9b.camel@HansenPartnership.com>
 <a6af2ce7-4a03-ab0c-67cd-c58022e5ded1@acm.org>
 <4f16a99974be6f2a0f207d5ca7327719cdf4e36e.camel@HansenPartnership.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <76b67325-9788-2876-5546-5be6df615a5c@acm.org>
Date:   Thu, 28 Oct 2021 13:53:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4f16a99974be6f2a0f207d5ca7327719cdf4e36e.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/28/21 1:33 PM, James Bottomley wrote:
> On Thu, 2021-10-28 at 13:21 -0700, Bart Van Assche wrote:
> [...]
>> Hi James,
>>
>> The help with trying to find a solution is appreciated.
>>
>> One of the software developers who is familiar with HPB explained to
>> me that READ BUFFER and WRITE BUFFER commands may be received in an
>> arbitrary order by UFS devices. The UFS HPB spec requires UFS devices
>> to be able to stash up to 128 such pairs. I'm concerned that leaving
>> out WRITE BUFFER commands only will break the HPB protocol in a
>> subtle way.
> 
> Based on the publicly available information (the hotstorage paper) I
> don't belive it can.  The Samsung guys also appear to confirm that the
> use of WRITE BUFFER is simply an optimzation for large requests:
> 
> https://lore.kernel.org/all/20211025051654epcms2p36b259d237eb2b8b885210148118c5d3f@epcms2p3/
> 
> As did the excerpt from the spec you posted.  It will cause slowdowns
> for reads of > 32kb, because they have to go through the native FTL
> lookup now, but there shouldn't be any functional change.  Unless
> there's anything else in the proprietary spec that contradicts this?

Are the UFS standards really proprietary? On https://www.t10.org/pubs.htm
I found the following: "Approved American National Standards and Technical
Reports may be purchased from: [ ... ]". And on
https://www.jedec.org/document_search?search_api_views_fulltext=hpb I found
the following: "Available for purchase: $80.00". It seems to me that SCSI
and JEDEC standards are available under similar conditions?

Regarding the question about the impact of leaving out WRITE BUFFER
commands on the HPB protocol, I hope that one of the HPB experts will be so
kind to answer that question.

Bart.


