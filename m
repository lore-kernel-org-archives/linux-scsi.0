Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD06CC54FCB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 05:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8BD620767
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 05:05:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1JA17l3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725929AbgDVFFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 01:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVFFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 01:05:32 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A972FC061BD3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 22:05:31 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x17so35335wrt.5
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 22:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nzQHWx6NF1Vfza746EHjvw6j3dnSFFXu/ctVmf2T1pU=;
        b=m1JA17l3C/JR82Aqg7MG6jInJR0dQx2uth9pripAL2FNptb+lTneG5k5aqbtqmbthb
         N6HX4M6rGT6SRidbOwDHLLnI1pyozz2wB09B3djyb5M3f5EjmSIWz2hpylBAtim8qTsX
         /fICuDB/wi2OzCksQC7PP5F4v0Mt4Ibe7Ar/CUjxjhhd2yEfM6yPaEUt+vcIPTKTdzV1
         f+035Kd9lCb0TlS0MW04r1G6TxGld3bu2j3PCeNh8GhE6GCTIOKVcMvVvlw8t/Nv6P4I
         XwhyZEupI3A+94q+ITpiurgFU94Y2Y8lOdVk24o2WxwrwQsvSlDXe9UHrSkfCFSy/R1c
         lRJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nzQHWx6NF1Vfza746EHjvw6j3dnSFFXu/ctVmf2T1pU=;
        b=H0VeFJlvnibUmJ1ED2WSjaQJ7+Sha3WCYEkomdEJH33x0JfCh/dEXWC9gW8x4u/vIw
         RAr5NSwZKnpVbPhP70oW8FnlfWFQXzriPRkVzRe1j9tjaE+JDsmBSnTtUiDX1um64K+D
         8dG62EqbQehY0POfpku2xgGvh3u6OUrjzmX5haa71vvAOO+CcT/bQA9u2gHu6J6d/FJo
         +VnBoo8oWxkK3QzVgmp7BFd/RyFTHMeXw9yQIM9PtLbAKg6eL928eLwXpy2hrIIgxODb
         2L/4sJxDAhhmxwcVcsR0JGTty0KPjnBT8az4L7tFNrdU5l/49A+o6uammrpQJH/pP1Qo
         dc9g==
X-Gm-Message-State: AGi0PuaUnbH8YrW7EGc80Us6McWrr3taavBbbgcKj71g9NV3IsQBNvvs
        EkQXooHMtWT6LnAvi5t74uE=
X-Google-Smtp-Source: APiQypKM0q9Ikh4OFwknZ3IX/otvURNz8ANCP86MLP9w4NRn8qNU4/0+mtHC8/R+mEd898rv7yvMQQ==
X-Received: by 2002:a5d:4447:: with SMTP id x7mr27278509wrr.299.1587531930326;
        Tue, 21 Apr 2020 22:05:30 -0700 (PDT)
Received: from [192.168.1.237] (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id u3sm6231688wrt.93.2020.04.21.22.05.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 22:05:29 -0700 (PDT)
Subject: Re: [PATCH v3 04/31] elx: libefc_sli: queue create/destroy/parse
 routines
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, maier@linux.ibm.com,
        bvanassche@acm.org, herbszt@gmx.de, natechancellor@gmail.com,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-5-jsmart2021@gmail.com>
 <20200415100445.qdmx34sekrsyjo7r@carbon>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <a1837942-f6d8-a8bf-d6a6-c2d10ceb5e7e@gmail.com>
Date:   Tue, 21 Apr 2020 22:05:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200415100445.qdmx34sekrsyjo7r@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 3:04 AM, Daniel Wagner wrote:
...
>> +static void
>> +__sli_queue_destroy(struct sli4 *sli4, struct sli4_queue *q)
>> +{
>> +	if (!q->dma.size)
>> +		return;
>> +
>> +	dma_free_coherent(&sli4->pcidev->dev, q->dma.size,
>> +			  q->dma.virt, q->dma.phys);
>> +	memset(&q->dma, 0, sizeof(struct efc_dma));
> 
> Is this necessary to clear q->dma? Just asking if it's possible to
> avoid the additional work.

unfortunately, yes - at least q->dma.size must be cleared. It's used to 
detect validity (must be non-0).

...
>> +		q->dma.size = size * n_entries;
>> +		q->dma.virt = dma_alloc_coherent(&sli4->pcidev->dev,
>> +						 q->dma.size, &q->dma.phys,
>> +						 GFP_DMA);
>> +		if (!q->dma.virt) {
>> +			memset(&q->dma, 0, sizeof(struct efc_dma));
> 
> So if __sli_queue_destroy() keeps clearing q->dma, than this one can
> go away, since if __sli_queue_init() fails __sli_queue_destroy() will
> be called.

Well, this is the same thing - with q->dma.size being set to 0 so the 
dma_free_coherent() is avoided in the destroy call.

...
>> +sli_mq_write(struct sli4 *sli4, struct sli4_queue *q,
>> +	     u8 *entry)
>> +{
>> +	u8 *qe = q->dma.virt;
>> +	u32 qindex;
>> +	u32 val = 0;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(&q->lock, flags);
>> +	qindex = q->index;
>> +	qe += q->index * q->size;
>> +
>> +	memcpy(qe, entry, q->size);
>> +	q->n_posted = 1;
> 
> Shouldn't this be q->n_posted++ ? Or is it garanteed n_posted is 0?

yes - we post 1 at a time.


...
>> +sli_rq_write(struct sli4 *sli4, struct sli4_queue *q,
>> +	     u8 *entry)
>> +{
>> +	u8 *qe = q->dma.virt;
>> +	u32 qindex, n_posted;
>> +	u32 val = 0;
>> +
>> +	qindex = q->index;
>> +	qe += q->index * q->size;
>> +
>> +	memcpy(qe, entry, q->size);
>> +	q->n_posted = 1;
> 
> Again why not q->n_posted++ ?

Same thing.

> 
> I am confused why no lock is used here and in the fuction above. A few
> words on the locking desing would be highly appreciated.

Q lock is held while calling this function. There were comments in the 
caller. Will add one here.

Agree with the rest of the comments and will address.

-- james



