Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF41C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 02:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 396E422225
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 02:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbhAKCdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Jan 2021 21:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbhAKCdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jan 2021 21:33:09 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22907C061786;
        Sun, 10 Jan 2021 18:32:29 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id t30so14844489wrb.0;
        Sun, 10 Jan 2021 18:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZdiQuyXyI29WpgOoPuBJ650oH5rlV0w+1X7Dgj+t0jY=;
        b=TsxvNWnN4kut+RCk067pjJC5W5BdXDdRIDIfWTq4H4wcup3hA1rRGmkpbbezo0Uur2
         vxj9FttkWwN3T7XzcW6Cf3fO0rWKDxknzifMiHYiTEuNFoxox4cFNfDbfU55ZbwnF22J
         lThQYfw03/KUXTM23vGwO9ZvGvNnbWbDU9R6vE5FvNRHzz3Kf/7on8qxYCn97loQOi2j
         NnEAwo6jQcbIYP66XRfYoq+C8vu30rDSddsiLYrKZcALwclHmadR3B3sX/4DoRpLK7R2
         edDSv9CCKf/a0fJP7/KJDPxcEbFlmbDN+yvpzThRxuRGKZ0xjJHyOvbztwcuzAOapfhb
         HBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZdiQuyXyI29WpgOoPuBJ650oH5rlV0w+1X7Dgj+t0jY=;
        b=NEUrTrOU20kWzpEaspO29M/o2CUZqmwGPGUT6x1z5aWvxhDTjWUYf5wjLGUBC1/GO7
         PGC18+rRwVEg1yNRubO4p9rO6I8PfaCWHtvWq50eBqFZZ+iJW1xgCE0IX7PZJqWUJWbk
         fAhW/nUkI7LXr1LGLPIS0GWDolooJomGCuRv8npalmZHclZp4IIDdkzUX0IMQO417Uat
         mnp7825wP2mayRMwOTC3VDKwH/Riy4G8FBiPeNJAR+HDVD7m4W8N0LhA7fWJp9ST5qkd
         OFk4hhC9js+Baznvs+94fqnjKsL6tzqwqPrpJnOtfbzJ6P2WW48114511ij+3Rlnyu6V
         9W2Q==
X-Gm-Message-State: AOAM530ASH+kXNSUnBZIOSYNTPW1H3qCWx/8POPXRf8Luncy6TWa4VFJ
        UuEv9PVeP9+VuqsC4ruVfCVJA+E7sn4=
X-Google-Smtp-Source: ABdhPJzTZ5seFMHLVFAEjTD5FCQdFE82O2u46jXrGyhASm6EVozGsTORdfQA76mYqDf8fhP0TvtFOQ==
X-Received: by 2002:a5d:6749:: with SMTP id l9mr14226648wrw.395.1610332346761;
        Sun, 10 Jan 2021 18:32:26 -0800 (PST)
Received: from [192.168.8.115] ([85.255.237.6])
        by smtp.gmail.com with ESMTPSA id a17sm23392736wrs.20.2021.01.10.18.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 18:32:26 -0800 (PST)
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <34cd22d6cec046e3adf402accb1453cc255b9042.1610207523.git.asml.silence@gmail.com>
 <BYAPR04MB4965F4DCF59E5225CF17322D86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <4d063dde-c710-44e3-31b9-8fb6b7e1d952@gmail.com>
 <BYAPR04MB49653C92C7925B8C3EAEF3CE86AD0@BYAPR04MB4965.namprd04.prod.outlook.com>
 <b9558bf8-a7e3-c2f9-ce00-3fc2b90dcc87@gmail.com>
 <BYAPR04MB4965E008861D5B29B9E757D186AB0@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] target/file: don't zero iter before iov_iter_bvec
Message-ID: <68887abc-2ef4-035e-625b-84569c1b5b24@gmail.com>
Date:   Mon, 11 Jan 2021 02:28:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB4965E008861D5B29B9E757D186AB0@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/01/2021 02:06, Chaitanya Kulkarni wrote:
> On 1/9/21 13:29, Pavel Begunkov wrote:
>> On 09/01/2021 20:52, Chaitanya Kulkarni wrote:
>>> On 1/9/21 12:40, Pavel Begunkov wrote:
>>>> I expect you won't find any, but such little things can pile up
>>>> into a not-easy-to-spot overhead over time.
>>> That is what I suspected with the resulting assembly. The commit log
>>> needs to document that there is no direct impact on the performance
>> It's obvious that 3-4 extra mov $0 off(%reg) won't change performance
>> but still hasn't been formally confirmed ...
> This is obvious for you and me since we spent time into looking into
> resulting assembly not every reviewer is expected to do that see [1].
>>
>>> which can be seen with this patch, but this is nice to have
>> ... so if you don't mind, I won't be resending just for that.
> As per commit log guidelines [1] you have to quantify the optimization.
> 
> Since you cannot quantify the optimization modify the commit log explaining

And then you see "Optimizations usually aren’t free but trade-offs
between", and the patch doesn't fall under it.

Let me be frank, I see it more like as a whim. If the maintainer agrees
with that strange requirement of yours and want to bury it under
bureaucracy, fine by me, don't take it, I don't care, but I haven't
ever been asked here to do that for patches as this.

> that there is not significant performance benefit observe.

It's not "I cannot" but rather "I haven't even tried to and expect...".
Don't mix, there is a huge difference between.

-- 
Pavel Begunkov
