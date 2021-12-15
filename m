Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91E58C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 15:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243877AbhLOPSR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 10:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237934AbhLOPSQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 10:18:16 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40C21C061574
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 07:18:16 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id o14so16688105plg.5
        for <linux-scsi@vger.kernel.org>; Wed, 15 Dec 2021 07:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kiTE7qhns0rYxwGDuD6ie8wRzuMuUFUFmrIwiVfTSvE=;
        b=P5CSOHUzOSqEuTCfYzAtu7efbt2rVYq9Ca/Y3eX2sXgBsiICcS9Sh7vaTF4BWXSX6M
         LWYhRvhSNQZq02qMRy5nKSHnjwS23WIvEPfFa7JPFLviBw0g64nrN0i/Wj+xjhPcVbw6
         DoNjCvx5sy2K0DF2CPA5UPAz1kdqyqhK192pCQ5J8aOZx4TTi1q2JxeC/9U26Z+Rlyig
         CAOqzjpXgHgf97MzTinitvOAXMW9zV0U4y0AbRICRrhjJRNu4WhLoJEBZWKH+UfYJg+g
         ItfZfXBjXnjOJXyTXZUXzZzVmpr4Q3mdnUpC0fCWI477WVns0rBWH7XMSZB8z7rXg5aw
         r50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kiTE7qhns0rYxwGDuD6ie8wRzuMuUFUFmrIwiVfTSvE=;
        b=JOhKZEekGb6bDJFIOYGRzD1+eeVfpyRwlgiirmQ5UoPn6oGYrUpVNy+TasuUOhAVzy
         jh7msn7ePDXjj69vRu9B9S0qgPMMz1n4YSpyPrs3Ti6fpK6GoYfwXN32MVEn7QBklNpT
         tULFBuUZ7Gqs72sCGHNrDL+ACOUcXnpNhcdVMhzFzNF0ZSj7MBrL/z6e3odlSWZhrS4u
         6cOTz1s5pa8i8ZDRTbqlwxJeXqtkFj21xVYwciLYnnEKjHnMEDai+nkytABA80E6KYTw
         SCJGKAbQnhWWrnoKXOZ3O6KqUMgqawmXFgenVNypZC76wQBrV/fjPkDwka463iujdh1/
         jdGg==
X-Gm-Message-State: AOAM533CR7JfH1ghLNPI4hwXHxPpxwoK3aVcR2zi9r20ZQW5xebQGNx6
        KWLBAxrxMLGMHuXkIUa8GE0=
X-Google-Smtp-Source: ABdhPJykBSpxnlFTMsDP3GLraOUafLqSlxVeQd1G+7PUhM2dICrgcWSF3t7VH7O2LANvtiBWVHkTww==
X-Received: by 2002:a17:902:b682:b0:143:7eb8:222 with SMTP id c2-20020a170902b68200b001437eb80222mr11760561pls.31.1639581495709;
        Wed, 15 Dec 2021 07:18:15 -0800 (PST)
Received: from [192.168.1.26] (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z13sm3263566pfj.7.2021.12.15.07.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 07:18:15 -0800 (PST)
Message-ID: <b112f61b-5f5c-86ff-952e-8e62e500a5e4@gmail.com>
Date:   Wed, 15 Dec 2021 07:18:14 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] efct: don't pass GFP_DMA to dma_alloc_coherent
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, james.smart@broadcom.com,
        ram.vegesna@broadcom.com
Cc:     linux-scsi@vger.kernel.org
References: <20211214163605.416288-1-hch@lst.de>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <20211214163605.416288-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/14/2021 8:36 AM, Christoph Hellwig wrote:
> dma_alloc_coherent ignores the zone specifiers, so this is pointless and
> confusing.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/elx/efct/efct_driver.c |  2 +-
>   drivers/scsi/elx/efct/efct_hw.c     | 10 +++++-----
>   drivers/scsi/elx/efct/efct_io.c     |  2 +-
>   drivers/scsi/elx/libefc/efc_cmds.c  |  4 ++--
>   drivers/scsi/elx/libefc/efc_els.c   |  4 ++--
>   drivers/scsi/elx/libefc_sli/sli4.c  | 14 +++++++-------
>   6 files changed, 18 insertions(+), 18 deletions(-)
> 

Looks good. Thanks Christoph.

Reviewed-by: James Smart <jsmart2021@gmail.com>

-- james

