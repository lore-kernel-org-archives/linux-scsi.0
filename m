Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE3EC43217
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Nov 2022 21:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiKRVon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Nov 2022 16:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiKRVol (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Nov 2022 16:44:41 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D0565E58
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 13:44:41 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id n17so6072202pgh.9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Nov 2022 13:44:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RkFTIrtdwyX2TNUxD2qJjCXIPObhIeqFxCdl7ZlUGmo=;
        b=6JLzxBfWf/1YhlRfbnAqy4hgapWQk0ulcqorY5tXB4oizia9yCJmoVVEPG3WyFZ6A6
         zPxn61ptgzPq7Qbfua0sfZG6eAR/2LGIk6SGqD8xFQlhbkVVSDb2FQ/NCEOPD8dkr/CC
         05QkgaLKP7yuKNCujsISckZPj7S1k9fJUsVTs2NQlkHdaYqUr/aQ9fxuqrg5Yp6fUYgu
         CaA3+YG5dQXA1EB8QTfht83+tpklW48Rj2vlU9Uo34BhdNBoE8hwCMmWppyEmTrXNtij
         WbFsCWqHLueRWkimNZcQ35vhY118ggOr4l8oPtc2PcdWfSsl0keRB3UVF12TXmlEi4lr
         FK3w==
X-Gm-Message-State: ANoB5pmfho7msOsBEg9q12XWSPZIaI44c6uJ8KsgdqOxGbqbRParkVYk
        rS7T2QyFXLJMdQanIMOYOgk=
X-Google-Smtp-Source: AA0mqf5fbBfts4orvzhHSKFQnZ47lpMAoImHSv5eqLfE89nX7xdyPt634pCIiyOtVtRngEXPvBYPIg==
X-Received: by 2002:a63:1659:0:b0:46e:f23a:e9aa with SMTP id 25-20020a631659000000b0046ef23ae9aamr8092182pgw.428.1668807880591;
        Fri, 18 Nov 2022 13:44:40 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5392:f94c:13ff:af1a? ([2620:15c:211:201:5392:f94c:13ff:af1a])
        by smtp.gmail.com with ESMTPSA id w11-20020a170902ca0b00b001867fdec154sm4126856pld.224.2022.11.18.13.44.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 13:44:39 -0800 (PST)
Message-ID: <5379c0ec-8dd3-f1bf-0a08-a621c68a3b6d@acm.org>
Date:   Fri, 18 Nov 2022 13:44:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] scsi: ufs: ufs-mediatek: Modify the return value
Content-Language: en-US
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     Chanwoo Lee <cw9316.lee@samsung.com>, stanley.chu@mediatek.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        matthias.bgg@gmail.com, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org
References: <CGME20221118045326epcas1p408c9e16a58201043c9eb3c99110fab0c@epcas1p4.samsung.com>
 <20221118045242.2770-1-cw9316.lee@samsung.com>
 <db25901b-8537-ca16-aaac-0daaa636d84d@acm.org>
 <c561e1ca-7739-efe7-5c36-952b01634a26@linux-m68k.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c561e1ca-7739-efe7-5c36-952b01634a26@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/22 13:34, Finn Thain wrote:
> On Fri, 18 Nov 2022, Bart Van Assche wrote:
> 
>> There is more Linux kernel code that [...] than code that [...].
> 
> Thus mediocrity prevails.

Mediocrity? I don't understand the above comment. Personally I prefer 
the style without !! and I don't think that it's a mediocre style.

Bart.
