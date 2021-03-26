Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1FFFC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 23:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60C661A27
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Mar 2021 23:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhCZXPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Mar 2021 19:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhCZXPe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2021 19:15:34 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CC4C0613AA
        for <linux-scsi@vger.kernel.org>; Fri, 26 Mar 2021 16:15:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so3201504pjb.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Mar 2021 16:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HZIBNhtHl+xCLaB+L/AxMk/nJWRocX0er656vj3kfNQ=;
        b=OsQz//KivuHAiCY0nvyPC7jgLCNtrvHf3FNx0UdeEpzZ7mD0igAIIJrCHIU7okpFTa
         vlzuxMLY9s7phpNgK/iL3u4/tEOMadC7vsztzpwsV+mcaETw6VAxNLT1s5OV3zEn5H+C
         fXt5lUPquptTWKfl/IbHsMNDpXTkzHJqskiReA8AXj+QPBofKfL2tCBVZY+9oZ0jwVg9
         49cxH68EsatWykEEZEPSgxIVDjZe7GpG4s0OVtkGWOWxP82MlpfHPFoMTxUhcF21Gvvw
         K4MH78EWg0STiaFxupZ9gfpLavqYhSR7lVHLVyWkfMo75dOPOCNPtzbuPBiqfMB9RfrG
         mhyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HZIBNhtHl+xCLaB+L/AxMk/nJWRocX0er656vj3kfNQ=;
        b=CvY5JPPd9g/psGve/UgqxZsSnvJG/2IOZIcloYPU9VPpNbf5Ryf3kIMBdUCun2g+yJ
         hEyhVNP4ojlOmXQsPc5hsV5R/ogkzsX5CzJtLvvVWv8ewn5KgPBxDUvsMxV8N+B+uDSC
         AZRSycNQnThWpd8xBJ4dbYkjPhBlYAKbvA/GJtHDWEN+IhSXx2E0/DJWBeRE/NzmEltg
         Uji6ZMnlIUYbfykYk9JYaY8CD+yJyMg2/kQ8h8lmMVbAiVbX2HzBPFqqYgWW9rvs/NYa
         gIKYpCa7M0VkBELkBTgWPbq/n696SU4efxv+p/3wfkBKrPb/6jeyB0R9RKBTvs54xlPZ
         fmMA==
X-Gm-Message-State: AOAM532wXbOxVTHedch7/w+iuojG/RjxgLFnkO/yAOH2wMOcgEA9kC9v
        1zjg5XoUy68rwbTOt2XmdPk30vgyg5Velg==
X-Google-Smtp-Source: ABdhPJzCRiysG9fK3eIi7Snq4O/FISqWHQU3VeWMfZQzPdAVx70bQgNmasONk4y9sTw/BTWiEt2qfw==
X-Received: by 2002:a17:902:da81:b029:e5:de44:af5b with SMTP id j1-20020a170902da81b02900e5de44af5bmr17309713plx.27.1616800533444;
        Fri, 26 Mar 2021 16:15:33 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21cf::141d? ([2620:10d:c090:400::5:4d27])
        by smtp.gmail.com with ESMTPSA id n10sm8947101pjo.15.2021.03.26.16.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 16:15:32 -0700 (PDT)
Subject: Re: start removing block bounce buffering support v2
To:     Christoph Hellwig <hch@lst.de>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210326055822.1437471-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5dad4408-7539-6edd-7aa8-6ddf9af38c9e@kernel.dk>
Date:   Fri, 26 Mar 2021 17:15:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210326055822.1437471-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/25/21 11:58 PM, Christoph Hellwig wrote:
> Hi all,
> 
> this series starts to clean up and remove the impact of the legacy old
> block layer bounce buffering code.
> 
> First it removes support for ISA bouncing.  This was used by three SCSI
> drivers.  One of them actually had an active user and developer 5 years
> ago so I've converted it to use a local bounce buffer - Ondrej, can you
> test the coversion?  The next one has been known broken for years, and
> the third one looks like it has no users for the ISA support so they
> are just dropped.
> 
> It then removes support for dealing with bounce buffering highmem pages
> for passthrough requests as we can just use the copy instead of the map
> path for them.  This will reduce efficiency for such setups on highmem
> systems (e.g. usb-storage attached DVD drives), but then again that is
> what you get for using a driver not using modern interfaces on a 32-bit
> highmem system.  It does allow to streamline the common path pretty nicely.

The core parts look good to me. If we can get the SCSI side to sign off
on those changes, I can take it for 5.13.

-- 
Jens Axboe

