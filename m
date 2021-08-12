Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FF3C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 17:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51FBD60FED
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 17:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235698AbhHLRZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 13:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbhHLRZ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 13:25:57 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C99C0613D9
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 10:25:32 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id h11so11580480oie.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 10:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/t0crY99bVsBHmsGtf3nFKRr2bDvUGoWJNKWSR8x7Oc=;
        b=dRToqYfHRZlpx8HPyIvjpb8pMukJPa3W3JVGnhXop8tZRFVEu5wOeDIGyiumJHWwbn
         pgZZZahvBayAaO2OcETJVm8rfZDrx2UEX/qF85w5/N/AL9dEzwcvkXsDszPtSfggnOBw
         WRnLG6Z2AnGtrIkSuEB0pJTVgI7VD0Lfu+XVqeU50uOnTfPmvMYbFUMqZ/8NeuSQ9jLd
         Ux/oxcMi3D0ZZs0T8E6TBhDY1dJl9egtumD6A67Hu8AqekrbaGgN6RMj3OQBV02Tm/7P
         8D8GHnZSCtYmfnsn+DartzUv87VMXtbgstK4Rmjf+1yau6Q/Zn0VJ7qcahBWsv3VLkl7
         hHew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/t0crY99bVsBHmsGtf3nFKRr2bDvUGoWJNKWSR8x7Oc=;
        b=WhnAs4yeus0Ag6LRxUBnQ0CpiPzPaYKiXK+ZDthfIFA8qdZRFu8vNZFBrztb9cX8uA
         PEGFyO776ldc9xOFmir0eTM+jdLDva29r60tGTBzQacQ9v4V8W2+bphZmnjw7ZIgJ+1o
         SYTzizxkfjQewvDrGYaNolkunZvtB15WrBXqXlEOuqPISkUjeZ3qA4HUPp6qAIoKBdCZ
         hnw3NiO6FUV24W6EGkg7OcQzq8rw4M3BONQ0OMD6YeMiUTExBnaQmvwtvPjKRWqwBXxt
         7d4v9Y0Drb4MJKTyL3ef/rDddbxZCq6Jq1Bvi3JAPZ0jwiiQdAHfiUDklwM3U9/aSaSP
         5EzA==
X-Gm-Message-State: AOAM530aGyWcAAf5lJ9cGXBOVZ+kJ01BFSfNZCpCOXS8r+sh5aAOG4Ar
        bSzPmBeDMfQvNfslUig0aUfwnJl3ShcqqWEC
X-Google-Smtp-Source: ABdhPJw0Loyg5ImjbeFcFxIdHxZG3HBvV9n0kee1hpQKmPK+psbv78uiqj9qyFL/Rx7vi6R2FMlWmQ==
X-Received: by 2002:aca:f089:: with SMTP id o131mr4118849oih.37.1628789131106;
        Thu, 12 Aug 2021 10:25:31 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r137sm757387oie.17.2021.08.12.10.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 10:25:30 -0700 (PDT)
Subject: Re: [PATCH v5 0/5] Initial support for multi-actuator HDDs
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
 <a968069d-07df-396e-8ac6-04dfe3ee3040@kernel.dk>
 <yq1r1eyshs3.fsf@ca-mkp.ca.oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <743ace9d-2d10-f903-aa7f-cae3fbd1872f@kernel.dk>
Date:   Thu, 12 Aug 2021 11:25:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <yq1r1eyshs3.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/12/21 11:21 AM, Martin K. Petersen wrote:
> 
> Jens,
> 
>> This looks good to me now - are we taking this through the block tree?
>> If so, would be nice to get a SCSI signoff on patch 2.
> 
> I'd like to do one more review pass. Also, it may be best to take patch
> 2 through my tree since I suspect it will interfere with my VPD shuffle.

That's fine, we can do it like that. I'll wait a day or two and pending
any last minute changes, take 1,3-5 through block.

-- 
Jens Axboe

