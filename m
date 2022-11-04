Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EF7C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Nov 2022 12:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiKDMig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Nov 2022 08:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiKDMhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2022 08:37:50 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018112D771
        for <linux-scsi@vger.kernel.org>; Fri,  4 Nov 2022 05:37:26 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id f27so12960591eje.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Nov 2022 05:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bjorling.me; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GMwNYpp6IfQSczWvUkHLD5pqC9pvJcuYiA9/8H6nV4E=;
        b=WNLlP8VNM+/KSac50oJJl3QvBf3rQ5avRCyPVI0bXJf9zcwM5KH5HNdg9lAXkHUxOq
         N/BIvehR3jBnRjcjEZCoXcn7jk6MjjlUUFJ/eF5wtuPkJyH1OLHbi3s4uck0UtsqYubM
         eAl+6I/okViZBIgZT9nHeg9NG97i+36i7fPDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GMwNYpp6IfQSczWvUkHLD5pqC9pvJcuYiA9/8H6nV4E=;
        b=D7kTmEzaVK0d6T4OGxPVxIlSJFA8yudFxBPa+LRMaC8Jg/eRLdbqJvcwD4dqE4ra6t
         4lgvwG3AL12aRRMK3oe/n1tkERTz9xi/wh0RddmZLl8YBWy0w69jeGIFjh3xu/AVjaEk
         h50sLaybiF5qIbpaVAOwCYEk7hjhcwrGRUPRgeAlMzpEvsAACPTi0guPdecYCeazJFjs
         Molxu/JfuqM29W4WivVaQZnIALGJzTdEmhdMz+X8QePseT93GJcDcnBceRQe+oREl7Ln
         ijtqJtLfnZlmISuG4Ec3eIkccDXZ9FMtNGGMXTWuxF/32tkfpOpvWoqneyqGrznSu5Ui
         H55w==
X-Gm-Message-State: ACrzQf0YE1+XqXuhY8Zg9A4zpqRQ+cH38F3sljbLx0b2rqjxQdugrumv
        LdnVUmDmB8tmgySP0vmTAYpplg==
X-Google-Smtp-Source: AMsMyM7tKo2kktI2MVBf2Ew2/7xph1uzc1PduX34Hppt3qiG6dJm8eyCzPX9sZQxxjuZXje5oirYAg==
X-Received: by 2002:a17:907:9495:b0:78e:1bee:5919 with SMTP id dm21-20020a170907949500b0078e1bee5919mr34149157ejc.701.1667565444385;
        Fri, 04 Nov 2022 05:37:24 -0700 (PDT)
Received: from [10.0.0.144] (xb932c246.cust.hiper.dk. [185.50.194.70])
        by smtp.gmail.com with ESMTPSA id t26-20020aa7db1a000000b0045ce419ecffsm1888637eds.58.2022.11.04.05.37.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 05:37:23 -0700 (PDT)
Message-ID: <878ea44b-9616-e7d0-661c-82eae23b1b35@bjorling.me>
Date:   Fri, 4 Nov 2022 13:37:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RESEND PATCH 0/4] Implement File-Based optimization
 functionality
Content-Language: en-US
To:     Juhyung Park <qkrwngud825@gmail.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     Jiaming Li <lijiaming3@xiaomi.corp-partner.google.com>,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijiaming3 <lijiaming3@xiaomi.com>
References: <20221102053058.21021-1-lijiaming3@xiaomi.corp-partner.google.com>
 <Y2IuhG8nBJj0F1fd@infradead.org>
 <c5948336-19fc-ddd3-bc34-aba2d1b02302@gmail.com>
From:   =?UTF-8?Q?Matias_Bj=c3=b8rling?= <m@bjorling.me>
In-Reply-To: <c5948336-19fc-ddd3-bc34-aba2d1b02302@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/11/2022 07.11, Juhyung Park wrote:
...
> 
> Is the idea really an utter madness? Majority of regular files that may 
> be of interest from the perspective of UFS aren't reflinked or 
> snapshotted (let alone the lack of support from ext4 or f2fs).
> 
> Device-side fragmentation is a real issue [1] and it makes more than 
> enough sense to defrag LBAs of interests to improve performance. This 
> was long overdue, unless the block interface itself changes somehow.

There are ongoing work with UFS to extend the block interface with 
zones. This approach eliminates the mismatch between the device-side 
mapping and host-side mapping and lets the host and device collaborate 
on the data placement.

> 
> The question is how to implement it correctly without creating a mess 
> with mismatched/outdated LBAs as you've mentioned, preferably through 
> file-system's integration: If the LBAs in questions are indeed 
> reflinked, how do we handle it?, If the LBAs are moved/invalidated from 
> defrag or GC, how do we make sure that UFS is up-to-date?, etc.

If using zoned UFS, the file-system can use zones for LBA tracking, 
eliminating the mismatched/outdated LBA issue. f2fs already supports 
this approach (works today with SMR HDDs and ZNS SSDs). It'll extend to 
UFS when zone support is added/implemented.

