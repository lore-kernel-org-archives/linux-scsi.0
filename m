Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C6DC433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 19:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94345613CB
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 19:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhEETuu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 15:50:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36887 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbhEETut (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 15:50:49 -0400
Received: from cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net ([80.193.200.194] helo=[192.168.0.210])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1leNWp-0003ku-NP; Wed, 05 May 2021 19:49:51 +0000
Subject: Re: [PATCH] scsi: ufs: ufs-exynos: make a const array static, makes
 object smaller
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210505190104.70112-1-colin.king@canonical.com>
 <0e90b057-3a87-bec5-c0b2-46c49b191651@canonical.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <a9fafdd2-6625-18dc-62f4-7b4a8c9fd9c2@canonical.com>
Date:   Wed, 5 May 2021 20:49:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <0e90b057-3a87-bec5-c0b2-46c49b191651@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/05/2021 20:41, Krzysztof Kozlowski wrote:
> On 05/05/2021 15:01, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Don't populate the const array granularity_tbl on the stack but instead it
>> static. Makes the object code smaller by 190 bytes:
>>
>> Before:
>>    text    data     bss     dec     hex filename
>>   25563    6908       0   32471    7ed7 ./drivers/scsi/ufs/ufs-exynos.o
>>
>> After:
>>    text    data     bss     dec     hex filename
>>   25213    7068       0   32281    7e19 ./drivers/scsi/ufs/ufs-exynos.o
>>
>> (gcc version 10.3.0)
> 
> I am not sure what's the benefit here - you moved the code from text to
> data. In total you decreased the size for this compilation settings
> (e.g. compiler + optimizations) but that might not be always true, right?

It is a marginal saving, but for arrays this size it makes sense to not
have to populate the data into the stack before using it and then
discarding it. This change essentially replaces quite a lot of
instructions that put the data onto the stack so I think it's worth while.

> 
> This has effect on the code readability - line is longer and reader
> would think "why this was made static since it is simple one-time const?".
>

Not sure how to respond to this. If they wonder why it is static const
and don't know why then one would hope they look it up in K&R and
familiarize themselves with C.  It's not so subtle.

Colin
> 
> Best regards,
> Krzysztof
> 

