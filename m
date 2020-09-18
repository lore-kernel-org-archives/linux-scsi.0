Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F184C43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 17:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B52AC21741
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 17:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="gWUFB6iO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgIRRRt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 13:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbgIRRRt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 13:17:49 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE98C0613CE
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2020 10:17:49 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 60so6086219otw.3
        for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2020 10:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JUqiQSzhllVI057aTXz2PMTFJEWV6FgLZUeHAXitVIA=;
        b=gWUFB6iOP9XOh7KH05lYOr2sORiin/ancMlcFxzjs0GPW5jOrEW8fo7ksblL+sJm1m
         TpaYCfBbbuJzGv4J4a6W0q9XEQDcmF61mbfbt3ESUfM/BaGzDbwxnFGUeC0IgPdxTGD+
         cRmnXsJy3hjUvv8bpt+VI5jdbkh+Bpedkg8Jt+QwoFF0psK1vp0Eq6OYDpHgpcLTzu1L
         0gIsd+WmaL+lXJxVxkNEdtkrZIqtR5Qb0sXE3ziIjHcKrRJ10QQIAXFy5Q+T86eZ0P9v
         VwzfrHjUMiTJ4qmCoKidh588lvxxuPIZWWWKzec+K9enitrTv9o9DF2BemvZwNBKYqG4
         0CLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JUqiQSzhllVI057aTXz2PMTFJEWV6FgLZUeHAXitVIA=;
        b=IeifVqrASF8QrueEeToXlhxQ6OeBZGSX80C+f0RWjDkQdAv8oo8b7VmSDbjXKPBFms
         8D2chlghHxVWZtpSDM7pUIjAfb/6l9XqwnIIpk7lfX7bMVyFZe3dx2VVrxfL+R+tyFsr
         awOqfuz6Sc3liXU4kWSKY6V3nRrtd+2IJdojDvjEiSn2tGquoePzSjTtvLEpRSGu2KCg
         sWdtZD2VSRpG+9192rlajkbsM+bh0Tqdm7INxqHHGxRyOQzbo7/Rk0d99oOgMpj3ihoX
         X3zJSlxIpK/feVmivJeoMHcowaopL7E3bT63hC/vnPS3I6I35QwEUY4ikeJOQC5yAbkP
         glPg==
X-Gm-Message-State: AOAM533o19QBNqGZeFg2gqmXhLQ6cOV6xGX4BYAyjP8koqxZGOh4cJpy
        StBv8oVKB6UbmhOCYhAg1UGUGQ==
X-Google-Smtp-Source: ABdhPJxE46bj0+pPNUe6d6dV6MR0pQn+LjGvUdhHTufrFIzRjscfZ4AfSWYI8+1eQECdOdy9HM+seA==
X-Received: by 2002:a05:6830:1bf9:: with SMTP id k25mr23890348otb.310.1600449468463;
        Fri, 18 Sep 2020 10:17:48 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s5sm2758562otr.42.2020.09.18.10.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 10:17:47 -0700 (PDT)
Subject: Re: [PATCH] scsi: arcmsr: Remove the superfluous break
To:     Joe Perches <joe@perches.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        lee.jones@linaro.org, colin.king@canonical.com,
        mchehab+huawei@kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>
References: <20200918093230.49050-1-jingxiangfeng@huawei.com>
 <20200918145619.GA25599@embeddedor>
 <e9320543ab6e7c8bd5ceae8cfa9d0912a0e962e0.camel@perches.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2ce1124d-7f83-d9aa-f62a-519c8914ad98@kernel.dk>
Date:   Fri, 18 Sep 2020 11:17:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e9320543ab6e7c8bd5ceae8cfa9d0912a0e962e0.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/18/20 11:13 AM, Joe Perches wrote:
> On Fri, 2020-09-18 at 09:56 -0500, Gustavo A. R. Silva wrote:
>> On Fri, Sep 18, 2020 at 05:32:30PM +0800, Jing Xiangfeng wrote:
>>> Remove the superfluous break, as there is a 'return' before it.
>>>
>>
>> Apparently, the change is correct. Please, just add a proper Fixes tag by
>> yourself this time.
> 
> There's no need for a "Fixes:" here, it's purely cosmetic.
> 
> btw:
> 
> There are at least 150 instances of
> 	return foo(...);
> 	break;
> still in the kernel tree:

A lot of these are false positives, since they follow a pattern of:

if (some_condition)
	return func();
break;

-- 
Jens Axboe

