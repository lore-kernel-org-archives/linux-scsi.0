Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA5AC38A2D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 10:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbiJYKrA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 06:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbiJYKq7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 06:46:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1831CFD0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 03:46:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x2so8311678edd.2
        for <linux-scsi@vger.kernel.org>; Tue, 25 Oct 2022 03:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z9I9hKjxroauyjaQ+DVkkiyDN9LpQw/UgTxPKtmTkDI=;
        b=O5XzGl21zp5Kf+UgsZYFD5f9VocNReEpilUqUfVb1GbM+dXdSwbjTTC2jnzozsKHQs
         uQBQPRHDWaitXF1SmPgFDN7pncrL5lB5zYk/vnXrVe90nz/CgxxbO0t+dS0KCpFiqOMA
         YMeqN2tY8OoShGmVqbbC+5jYIOfV25nvhhblHYTNuXnsxXtA5kCXO5UkB9lO5g2JpAUC
         kGb13TSz/QhAHUU9KK+0nmZfMWrNlCRLhpC7jUJpc29YenbsO5f3g4eKsQRDpB+ZSmmX
         MLdJNL83W7x+HbO4dsRPnxQ/GEUbmZDcIZwv1RT++WuFGd2Wy1id4dOqcRPSYKPSg9MU
         ZIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9I9hKjxroauyjaQ+DVkkiyDN9LpQw/UgTxPKtmTkDI=;
        b=nJcarSlyV3bVrIDYyAYs4hH2EShfDrQC8V0Qp8CA/H6dzkzk/OxBwdRhdDrocFvmgw
         wa6NUIQ7PabqcavL3g/9XF4LvhXGKV/hRZ9qaCgLF0CEGaE2+bsaxSYwEY/safqhuy0x
         ibJpN0BER4x+LP8Mw/M92L69EbuHzjpR7er8uYMMC6NooYI1l9hWHU/G7mkDWa7MyltL
         s+r2OdAe2ygt7l2lKvottgmMhniY3ZHQ60Na+qCP41Ias0/NLU6cphIOHVvunG7gO+p2
         m5yTPjWOXJTiZrZGitmeilsu3Jkd+dfF13wE4bA0KdR5Ahtg0n5nvMSdVAlLxxuyuEsd
         ediQ==
X-Gm-Message-State: ACrzQf2/SSBNLWgAze1Ry9ba9eyHx5osTvD+y/rMzaXhFRFWujujv2GJ
        I7nM5icgqK2a5Oj0v9YJ1nE=
X-Google-Smtp-Source: AMsMyM517McmGsrGW6jJ9ODThMGTMVx38CCQwHGBWKZ/pJUjRoNlQCtZfudVjNiVi/LuWEV5X8gfjQ==
X-Received: by 2002:a05:6402:28ca:b0:43b:5235:f325 with SMTP id ef10-20020a05640228ca00b0043b5235f325mr34554556edb.320.1666694817062;
        Tue, 25 Oct 2022 03:46:57 -0700 (PDT)
Received: from [192.168.178.40] (ip5f597b78.dynamic.kabel-deutschland.de. [95.89.123.120])
        by smtp.gmail.com with ESMTPSA id p3-20020a056402074300b00461aaa39efbsm1441628edy.0.2022.10.25.03.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Oct 2022 03:46:56 -0700 (PDT)
Message-ID: <78357696-d9aa-71a0-8cee-0fadbc90655f@gmail.com>
Date:   Tue, 25 Oct 2022 12:46:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
From:   Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: [PATCH 1/5] sgl_alloc_order: remove 4 GiB limit
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20221024010244.9522-1-dgilbert@interlog.com>
 <20221024010244.9522-2-dgilbert@interlog.com> <Y1aDQznakNaWD8kd@ziepe.ca>
 <665f8dee-6688-60d1-5097-49f9726c38ec@gmail.com> <Y1bMKU5nq5DXYdbw@ziepe.ca>
Content-Language: en-US
In-Reply-To: <Y1bMKU5nq5DXYdbw@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24.10.22 19:32, Jason Gunthorpe wrote:
> On Mon, Oct 24, 2022 at 04:32:30PM +0200, Bodo Stroesser wrote:
>>> +struct scatterlist *sgl_alloc_order(size_t length, unsigned int order,
>>> +				    bool chainable, gfp_t gfp, size_t *nent_p)
>>>    {
>>>    	struct scatterlist *sgl, *sg;
>>>    	struct page *page;
>>> -	unsigned int nent, nalloc;
>>> +	size_t nent, nalloc;
>>>    	u32 elem_len;
>>> -	nent = round_up(length, PAGE_SIZE << order) >> (PAGE_SHIFT + order);
>>> -	/* Check for integer overflow */
>>> -	if (length > (nent << (PAGE_SHIFT + order)))
>>> -		return NULL;
>>> +	nent = length >> (PAGE_SHIFT + order);
>>> +	if (length % (1 << (PAGE_SHIFT + order)))
>>
>> This might end up doing a modulo operation for divisor 0, if caller
>> specifies a too high order parameter, right?
> 
> If that happens then the first >> will be busted too and this is all
> broken..
> 
> We assume the caller will pass a valid order paramter it seems, it is
> not userspace controlled.
> 

If a too high order is passed, alloc_pages will just return NULL, so
in the old code sgl_alloc_order simply returns NULL. Using modulo op
changes it to possibly crashing the system.

Bodo


