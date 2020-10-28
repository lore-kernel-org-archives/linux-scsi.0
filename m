Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AF3C55179
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 22:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 648F920754
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 22:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389612AbgJ1Wug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:50:36 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38276 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389610AbgJ1Wuf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Oct 2020 18:50:35 -0400
Received: by mail-oi1-f195.google.com with SMTP id 9so1295453oir.5;
        Wed, 28 Oct 2020 15:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=94gWFWTQQr945dbvotr81WLIHlciBWGEJdlFTXsxNX0=;
        b=FW3XZupD6RME05A6kvf1n17sCxFIYuQAFgrllE5K3Nyw8veNh5ORdC0fIsLswthaoY
         d8HuuCJLZ1XMe4v/LzsmhwltGP17bq5IHUY3lVRVPAwRp+D+8yWR46XHqQzqE++BWaGe
         I/n2ItJUo9lAMwexVmGIpA6HIQqA/d6empV/Sadv1tZt6B6IBxl5ArvfBXuYUIM80/Oh
         L2E0aJ5/qr8ENazOky5AU4WTziaOn3f/VfpGypfErv1czf7YX+JOvLU4kccjBRvmJlmL
         2jO0fJziT9bfhxCvSKDfuGHFZYAbAQoqQpiNR3yRj0OcpLvy+SRuXfQUpt5Gx3+RzZ8c
         oQQQ==
X-Gm-Message-State: AOAM533piZQDRgK8DNaV6v+NUNhLq2QE6TO+wrMjrmRUyvf0rGRFaLqS
        oixaIYHTHlwi8Y/BXsXfQU03qdP7AC3dzg==
X-Google-Smtp-Source: ABdhPJyYu1nxikKct93ZBfbAHHhX3RiaBcUADsl4+28JmKe4RvnXhqis7icDV2+Uc2pC+Y2zyi8OLA==
X-Received: by 2002:a17:90a:bf03:: with SMTP id c3mr5090925pjs.65.1603856490288;
        Tue, 27 Oct 2020 20:41:30 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id n16sm3884068pfo.150.2020.10.27.20.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 20:41:29 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
 <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
 <20201026131226.GA88490@SPB-NB-133.local>
 <270e2edf-49c9-942f-ac3d-b6dfa0aca8f7@acm.org>
 <20201027234639.GB88490@SPB-NB-133.local>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c3dac124-301e-df94-9d64-b3c46d4eafb9@acm.org>
Date:   Tue, 27 Oct 2020 20:41:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201027234639.GB88490@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27/20 4:46 PM, Roman Bolshakov wrote:
> Thanks for raising the point about overlength/underlength. If you wish
> we can add an extra check that fails DMA_TO_DEVICE && DATA with
> residuals only for SBC devices but note that before the series,
> underflow/overflow for WRITE didn't return GOOD status. The particular
> patch only changes sense code to more meaningful from the former INVALID
> FIELD IN CDB.
> 
> Theoretically, it could be good to have a configurable switch how LIO
> handles overflows/underflows for a LUN. Then it'd be possible to
> configure desired behaviour on a per-LUN basis. But there should be a
> clear need & demand for the feature to avoid maintenance of dead code.
>>> An additional question is what behavior other operating systems than
>> Linux expect? There are probably setups in which another operating
>> system than Linux communicates with a LIO SCSI target?
> 
> TBH I don't know any hosts that do SBC WRITE with residuals as normal
> course of operation. They wouldn't be able to work with LIO because it
> never returns GOOD status on WRITE with residuals. I can send an update
> later if the series works fine with modern hosts (~1 month, after a few
> cycles of system testing).

Hi Roman,

I'm not sure adding a new kernel switch is the best choice. That would
be an additional parameter users have to know about and have to learn
how to use.

Bodo seems to be in favor of this patch series. Are there other people
who want to share their opinion about this patch series?

Thanks,

Bart.
