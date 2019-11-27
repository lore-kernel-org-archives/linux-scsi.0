Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1552BC43215
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 14:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFAD720863
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 14:21:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="Dzjk7puv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfK0OVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:21:00 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:45357 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbfK0OVA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Nov 2019 09:21:00 -0500
Received: by mail-pj1-f66.google.com with SMTP id r11so2179279pjp.12
        for <linux-scsi@vger.kernel.org>; Wed, 27 Nov 2019 06:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Bj00DfyqrS1lFmmD2TnrPmfMRi8T2obEvmf14xMUbN0=;
        b=Dzjk7puvZwVSKZb5WAy96brJUIz5AyaLJXTVXKEj3ZucVFVna2cxJ2KufcbdUbhyuY
         whT9N7Ne57aqJdS1oCER0anwwionOxvWy6tGiPSv8NlfygfA1DShVdD7KSPzQP/mqpOa
         XMZ3tzfjgMjpu0jHNGSuVWVZuwsxmFb/WejADHAOGr7e7zXKT/5pot9gjP0dfPaNZrrK
         Mrz8rDXsUkmQq6WkDMgRPC7J+BfXBGmhnaUsM6Cl919/sKWfH6dHlLsXk5/RwQghVYyL
         7zcKFJkM2v0dfxu3HwH27R2cUCZjCKucqLl9VlhYgLkNJ+KMcaF2pau+uFwvC6EzF8cu
         1exg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bj00DfyqrS1lFmmD2TnrPmfMRi8T2obEvmf14xMUbN0=;
        b=icyiwCScK03ZtBagWaeg4YpC1ZizatDQg+c/ua+qeVJ3Gkf0089gsBsJfBwFzb+oLN
         /4dJKNfyykKb7N34CCyZpVsdx8oCrMWyvNedYj+EvoTRB03iKObkScGVNxTqcmjf40Ob
         NBNGEID1NHgzQ5HhRtZ5Az/ZJEr03eUDvYhnS7KwmJchbMZsRAma5Jc6os9ZFnnQi2fM
         qg5ero7Zmpo/IAr+vABF4rR+Vf2/XPO33gGx8KUSOPbRqF7ccEgZjwubwEcbozkDnnUv
         2qsFRybzSfV0JQDPMz2Ks87pVb/O/yC6isHoftF89STKuNYepfLXa8/ZK9FAw8Rst4EU
         ejlA==
X-Gm-Message-State: APjAAAU6XMVuib3oeqxTsSRzv2z9eT//Ijj17Komo9bLMkO90skPwssS
        Ptb22b0KKS5hQP6bRsbR9XB9pQ==
X-Google-Smtp-Source: APXvYqy+QD5pnCN3ee600yhNeQEPnpp4+ZhQ/RKcZaB/pHeNfk6Qm1kB+xs0pBdyFfhr2aWC7wUXZw==
X-Received: by 2002:a17:902:34d:: with SMTP id 71mr4288680pld.140.1574864458013;
        Wed, 27 Nov 2019 06:20:58 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:c030:6a7d:9480:46b8? ([2605:e000:100e:8c61:c030:6a7d:9480:46b8])
        by smtp.gmail.com with ESMTPSA id 203sm16967112pfy.185.2019.11.27.06.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 06:20:56 -0800 (PST)
Subject: Re: [PATCH 3/8] blk-mq: Use a pointer for sbitmap
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20191126091416.20052-1-hare@suse.de>
 <20191126091416.20052-4-hare@suse.de>
 <8f0522ee-2a81-c2ae-d111-3ff89ee6f93e@kernel.dk>
 <62838bca-cd3c-fccf-767c-76d8bea12324@huawei.com>
 <00a6d920-1855-c861-caa3-e845dcbe1fd8@kernel.dk>
 <baffb360-56c0-3da5-9a52-400fb763adbf@huawei.com>
 <9290eb7f-8d0b-8012-f9a4-a49c068def1b@kernel.dk>
 <157f3e58-1d16-cc6b-52aa-15a6e1ac828a@huawei.com>
 <1add0896-4867-12c5-4507-76526c27fb56@kernel.dk>
 <4a780199-7997-b677-b184-411afdeabba5@huawei.com>
 <b2810d59-5e74-87d9-3199-69e7c7bfcd37@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9b1b6d8f-8bf5-1b2f-ca9b-a4b1e2c071fe@kernel.dk>
Date:   Wed, 27 Nov 2019 06:20:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <b2810d59-5e74-87d9-3199-69e7c7bfcd37@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/27/19 6:12 AM, Hannes Reinecke wrote:
> On 11/27/19 2:05 PM, John Garry wrote:
>> On 27/11/2019 01:46, Jens Axboe wrote:
>>>>> Would be interesting to check the generated code for that, ideally we'd
>>>>> get rid of the extra load for that case, even if it is in the same
>>>>> cacheline.
>>>>>
>>>> I checked the disassembly and we still have the load instead of the add.
>>>>
>>>> This is not surprising, as the compiler would not know for certain that
>>>> we point to a field within the same struct. But at least we still should
>>>> point to a close memory.
>>>>
>>>> Note that the pointer could be dropped, which would remove the load, but
>>>> then we have many if-elses which could be slower, not to mention that
>>>> the blk-mq-tag code deals in bitmap pointers anyway.
>>
>> Hi Jens,
>>
>>> It might still be worthwhile to do:
>>>
>>> if (tags->ptr == &tags->__default)
>>>      foo(&tags->__default);
>>>
>>> to make it clear, as that branch will predict easily.
>>
>> Not sure. So this code does produce the same assembly, as we still need
>> to do the tags->ptr load for the comparison.
>>
>> And then if you consider blk_mq_get_tags() as an example, there is no
>> other hot value available to indicate whether the shared tags are used
>> to decide whether to use  &tags->__default.
>>
>> I'll consider it more.
>>
> After talking to our compiler folks I guess it should be possible to
> resurrect your original patch (with both the embedded bitmap and the
> point to the bitmap), linking the pointer to the embedded bitmap in the
> non-shared case.
> 
> Then we can access the pointer in all cases, but in the non-shared case
> that will then point to the embedded one, thus avoiding the possible
> cache miss.
> 
> I'll see how that goes.

That's exactly what I suggested yesterday, the discussion now is on how
to make that work in the cleanest way.

-- 
Jens Axboe

