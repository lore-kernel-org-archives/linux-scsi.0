Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DF19C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 18:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiJFSkh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 14:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJFSkf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 14:40:35 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9D8357E3;
        Thu,  6 Oct 2022 11:40:33 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id v186so2822034pfv.11;
        Thu, 06 Oct 2022 11:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z2pht9RoqtyP284j+C1cC7Lqj7p0xiPE6PS482Bfdnw=;
        b=EaMiFdi95Tagr/hFleFBTrERXnt12mcZfJ1pkM5nibyPJ/SYTPQo6LrVgyyz4Kyw4f
         r64veENn+c/AbskZGcrzfxh1gAY4tuJKWKz9BbG+7EwAzmh7mqkfL6XNcGm0JDl7MdiK
         yx8aOKWonsA7xhPK3eEXeRhQ6enMTRmMmJg14f0wN2Wr3UY0Hzbh0aS9NdnPCkEktHlX
         zDnRKEb2nzaQWgapJnljklHc5Z37KDZGtavqWvuYpb1f2izUADc04rqBsFDzJSBCxwbo
         6YbF28iKIfiIZsfx+OY7a+FXpzA0iMQqsuyCL6Jpe3F31JLOdOY8ZwVtSriue+PPuH8a
         l6qA==
X-Gm-Message-State: ACrzQf1SQl5z73SJnGNs99IEOxtTeoI4xU2w4HgOPmQZ/5RxZPytlTVq
        NqSKUgpd9tkJdBtOvzVZunA=
X-Google-Smtp-Source: AMsMyM7O6ZwP1XgoQZ4RryLenvCTr4zIfNbhwRmXnxmeC6wuX+8NTfy6f3FcAAjd7qKs80T2PObciA==
X-Received: by 2002:a62:ee17:0:b0:55b:b0d:bc9f with SMTP id e23-20020a62ee17000000b0055b0b0dbc9fmr1228763pfi.39.1665081632917;
        Thu, 06 Oct 2022 11:40:32 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:1d3c:9be0:da66:6729? ([2620:15c:211:201:1d3c:9be0:da66:6729])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b0017a0668befasm12537245pln.124.2022.10.06.11.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Oct 2022 11:40:32 -0700 (PDT)
Message-ID: <51f62009-777f-8958-8d28-b29e64bbff09@acm.org>
Date:   Thu, 6 Oct 2022 11:40:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 01/21] block: add and use init tagset helper
Content-Language: en-US
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20221005032257.80681-1-kch@nvidia.com>
 <20221005032257.80681-2-kch@nvidia.com>
 <6fee2d7a-7fd1-73ee-2911-87a4ed3e8769@opensource.wdc.com>
 <CAPDyKFpBpiydQn+=24CqtaH_qa3tQfN2gQSiUrHCjnLSuy4=Kg@mail.gmail.com>
 <e0ea0b0a-5077-de37-046f-62902aca93b6@acm.org>
 <a7e4fe12-64f2-3164-d675-26310ac07c9e@nvidia.com>
 <7e9ce6b2-70c8-cf85-95ab-de09090db64d@nvidia.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7e9ce6b2-70c8-cf85-95ab-de09090db64d@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/6/22 11:13, Chaitanya Kulkarni wrote:
> I will trim down the argument list with the most common arguments
> and keep it to max 4-5 mandatory arguments identical to what we
> have done this for blk_next_bio() and bio_alloc_bioset() [1]
> where mandatory arguments are part of the initialization API
> than repeating the code all the in the tree, that creates
> maintenance work of treewide patches.
> 
> Also, instead of doing tree wide change in series I'll start small
> and gradually add more patches over time.
> 
> This definitely adds a more value to the code where code is not
> repeated for mandatory arguments, which are way less than 9.

Hmm ... I'm not convinced that the approach outlined above will result
in a valuable patch series. I think my objections also apply to the
approach outlined above.

Bart.
