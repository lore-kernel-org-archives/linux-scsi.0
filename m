Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C8DC4167B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 00:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D964123136
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 00:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgLFACl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Dec 2020 19:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgLFACl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2020 19:02:41 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63831C0613CF
        for <linux-scsi@vger.kernel.org>; Sat,  5 Dec 2020 16:01:55 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id m9so5948768pgb.4
        for <linux-scsi@vger.kernel.org>; Sat, 05 Dec 2020 16:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m6ZOlEEYAPn5D22xKU47CZXMmwT6O45WhKH57Gwas7Q=;
        b=0ZxbUo2d5cEJjGu35LPR5RFVMu6yLLcXFKcAawJumEf8iYO4FGG42D8vdIScrKTb4Z
         E3KdAGayeRJMGeysdDzaJ+89ci68hGVl6l+By3UODnl4xn/eJCvm5npnSw2YaU0j9x85
         AFQ1JQD/phf0zMmCb4TAyRU5Oz0OzwK4RsKyAOPeh8F2cIIKz8ofB+LTnkhBpUSZ8iZK
         32YE0e0/m3KKUzSxWDRqIuNGe9up70UICCeTPQCBsaNzQxemk+izNRDohFnWN8GrFHoU
         SdAEEAQSjBUi2mZ87VAGY7hdFaZEwkevntZKGR/6Faz92k38rDn6N8OfByp3k+D9cn0B
         ApSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m6ZOlEEYAPn5D22xKU47CZXMmwT6O45WhKH57Gwas7Q=;
        b=i69cSA8UZNWkvxf1Ia62y+UqyQAsKFe/Z8W03Vfo8Hr51o77mjR6rcQXo0epyXH2ja
         IaPsJdD8BY8RjlRr7cFVMET46/adUhVXapkn0Ix8RJyReOa+d3DhJeoq+FR3EJpJ7l8G
         I/XvMlORUQYaygyLLFIICHdzSx/UKZkq+mnqJvh42SYgqZgB618dShEcOJT0d2uS7pyU
         Y8/hJ4ZM5rKbRTeb3SWsmWIzFwCwEAn/o17m0QVYCznTN0IQyXMDfjPb9KzM9ive5NV0
         OMwUW7H0k2lOhphrUzv2fuTRIgI7nfw0ds05fuFrhiFC4q+Duzn9s7nkbraqC+6aKAxF
         P3oA==
X-Gm-Message-State: AOAM531GI7ROttd/30s8dkuDzuNZgjX+Y7Wi+iltmtpLAdJVFNxCj+z+
        K+Iu1GS3IFIbPNva4uHRmrTmrg==
X-Google-Smtp-Source: ABdhPJxmhbAbH6cKdUjlfDN9h/wA73T9dbE2auWUmxNgPfGQac/Y5ONV+lE+pTL48MhCgnJydrfd0Q==
X-Received: by 2002:a62:2a81:0:b029:18c:310f:74fe with SMTP id q123-20020a622a810000b029018c310f74femr10124642pfq.50.1607212914836;
        Sat, 05 Dec 2020 16:01:54 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y3sm6363325pjb.18.2020.12.05.16.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 16:01:54 -0800 (PST)
Subject: Re: [PATCH v4 0/9] Rework runtime suspend and SPI domain validation
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20201130024615.29171-1-bvanassche@acm.org>
 <yq1k0u1c6ye.fsf@ca-mkp.ca.oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8ad8e593-438f-c366-39e1-73a45045de04@kernel.dk>
Date:   Sat, 5 Dec 2020 17:01:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <yq1k0u1c6ye.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/20 6:51 PM, Martin K. Petersen wrote:
> 
> Jens,
> 
> Any objections to me picking this up?

No, go ahead. Looks good to me, you can add:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

to the series.

-- 
Jens Axboe

