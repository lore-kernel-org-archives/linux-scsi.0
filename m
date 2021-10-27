Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AACF7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 14:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 869C260F56
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 14:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238841AbhJ0OlH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Oct 2021 10:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237877AbhJ0OlG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Oct 2021 10:41:06 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33ECC061570
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 07:38:40 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id i26so3132904ila.12
        for <linux-scsi@vger.kernel.org>; Wed, 27 Oct 2021 07:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AXihn/8PvH62ldISnz4SaTA+BeQjkNpRep7BwZH9kSs=;
        b=e9ZbK1qROGrN6+Mx2BjbAK7HAVDu8JPEPy7/j29XZSgqK9lCtCNlee8sxK7nDm47MQ
         I+kLX9BoMh21LAPvciWReSu1rn9hIyFhc8uBCD1fqoSL3ttcWPDFb4xhqrNk793m6e0X
         zGVDjKTWUEhqC7wQr8M7klhdv9ExB6zlpxbT0161JH11yi/fVmuVAlC3yQEcKQPhqiOR
         z9tH25FsPPhDclWOPuRtaANGCCFb/W0EU9Hj85u0V+1pxk3n/M2BfnJ9dkYZl7M78bjC
         wbZ0Eie939QG/tIQHVpy08JODl4Bfm621Y3ZyB6AXFi75DKGmmVzziHs5aTpGD3yu31r
         wG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AXihn/8PvH62ldISnz4SaTA+BeQjkNpRep7BwZH9kSs=;
        b=d+s0KWtF4Rs6M/Rsmk5ikxDFD+vDKp+tEYM6HmC7FoVpK4hARjEiNPkQ1VLffdl5+T
         BOX46jo+86EELSb01dnaEBEJXSyQW5+2ymJ5Gn6eOv/2ACSieu8OkRamx45E8vpUcMIY
         rOp33/RueByyGYNyDyBdAthzwD2Ck66fviFZuh6YL5oc1gW8MDNf1rxyM2Uurkl2uB9x
         qCsklnCwwxX7XmqPgxCfmKuTsMggcgVN7k60JN+gV5MdDrg/UiAvL1Rs85yFheNYqkmU
         9vr4ymxRr8x/b5c8+YbAofQ9clCUkQbgB5eaC8jGlQEkK9Qm8ifDv63KZfXxqYtZD/lJ
         YyNg==
X-Gm-Message-State: AOAM531cIq3tFRYqYOEt3CPaLLt1ICK226k0T6SHr91brL2VAi5xwN27
        X01B7/GdutqS9hfjKawxbauj0Q==
X-Google-Smtp-Source: ABdhPJyrjIHC/dGkhJmuYKIrlgOR3lXq62bJXZMMcXGurmSrRJeq7MYl9DVwxr42vCxpELLDNEijXA==
X-Received: by 2002:a92:b00c:: with SMTP id x12mr17857719ilh.37.1635345520174;
        Wed, 27 Oct 2021 07:38:40 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x13sm63875ile.9.2021.10.27.07.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 07:38:39 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: mark HPB support as BROKEN
To:     Keith Busch <kbusch@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <99641481-523a-e5a9-db48-dac2b547b4bd@acm.org>
 <7ed11ee1f8beca9a27c0cb2eb0dcea4dbd557961.camel@HansenPartnership.com>
 <870e986c-08dd-2fa2-a593-0f97e10d6df5@kernel.dk>
 <4438ab72-7da0-33de-ecc9-91c3c179eca7@acm.org>
 <c3d85be5-2708-ea50-09ac-2285928bbe0e@kernel.dk>
 <36729509daa80fd48453e8a3a1b5c23750948e6c.camel@HansenPartnership.com>
 <yq1ee873av4.fsf@ca-mkp.ca.oracle.com>
 <679b4d3b-778e-47cd-d53f-f7bf77315f7c@acm.org> <20211027052724.GA8946@lst.de>
 <b8aec3cb-75f1-3e1f-1dfc-5d77322b736f@acm.org>
 <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <804aabca-35cd-e22b-1108-b82be38f6885@kernel.dk>
Date:   Wed, 27 Oct 2021 08:38:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211027141231.GA2338303@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/21 8:12 AM, Keith Busch wrote:
> On Wed, Oct 27, 2021 at 06:16:19AM -0700, Bart Van Assche wrote:
>> On 10/26/21 10:27 PM, Christoph Hellwig wrote:
>>> On Tue, Oct 26, 2021 at 01:10:47PM -0700, Bart Van Assche wrote:
>>>> If blk_insert_cloned_request() is moved into the device mapper then I
>>>> think that blk_mq_request_issue_directly() will need to be exported.
>>>
>>> Which is even worse.
>>>
>>>> How
>>>> about the (totally untested) patch below for removing the
>>>> blk_insert_cloned_request() call from the UFS-HPB code?
>>>
>>> Which again doesn't fix anything.  The problem is that it fans out one
>>> request into two on the same queue, not the specific interface used.
>>
>> That patch fixes the reported issue, namely removing the additional accounting
>> caused by calling blk_insert_cloned_request(). Please explain why it is
>> considered wrong to fan out one request into two. That code could be reworked
>> such that the block layer is not involved as Adrian Hunter explained. However,
>> before someone spends time on making these changes I think that someone should
>> provide more information about why it is considered wrong to fan out one request
>> into two.
> 
> The original request consumes a tag from that queue's tagset. If the
> lifetime of that tag depends on that same queue having another free tag,
> you can deadlock.

And to expand on that, one potential solution would be to require as
many reserved tags as normal tags, and have the cloned/direct insert
grab requests out of the reserved pool. That guarantees the forward
progress that is currently violated by randomly requiring an extra tag.

-- 
Jens Axboe

