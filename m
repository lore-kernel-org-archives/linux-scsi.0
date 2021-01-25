Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B58C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 04:38:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A7322472
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 04:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbhAYEhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jan 2021 23:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbhAYEhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jan 2021 23:37:37 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFDBC061574
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jan 2021 20:36:57 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j21so2216324pls.7
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jan 2021 20:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CvMA3FL8dHSfKJXeGv3WAf10xOnVS1nCO8k/Gm1YzTQ=;
        b=su+CfV5uTWK9uTt1Ew0ySTu9kxgdoDgPjBAY0wClNThUH43koxiXLnDyyfv/rfikW8
         BIYIC4b85X16l79slKjRUYF1hsnYs/nIaGp58SqKq0sEFpHjkAS3XBDPf8+w6dgpI5Rv
         GnH6atAAScQb+FkV7B+rLbPCxSYX4614HldAA9hSvTMhYktagh/KFeeQhFLMG7KFAxb8
         AcPFCMmOqn7FlsQFwc7v133qo9aezgVHK6s8BgS9SZtl0coRyrS40bNFBU1MfaDB7R8z
         bhKiWeCrPk88rv/2ncADRRly5wu9XjHa49OorOPU1Ytl5EDbOg71iZPv3AgqSToLU+8K
         RmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CvMA3FL8dHSfKJXeGv3WAf10xOnVS1nCO8k/Gm1YzTQ=;
        b=HB1FM53+55ynu4qC4C4KTpcokQeQNNIKQpn4TL1uZMurSvqrjJ7AvngokayDnrC9KX
         g1Dk7kIGZu7qXxweuXO4HNnHXvoG2DifQ+u4to7jMirJ3hZlpf2dvzSfqJusoIPxBuCG
         8PHfV0uGEWHtyy3hNDkItiVIuAjGChQHx9XYUe2GT+H71g6efRSe7eW6g6pQ+csmMMQI
         lQLFoQDKk3msVEzy1Lhda+HdeVTowNCIU3jc1UeBytoaTsPE5g/slu1tSpAPqDu+I8Dv
         +++bluX3HoSw5OeQW85VD8YODEnHsclap7d8KL+cSGVHlhnFuP/kYcoaS2W2h4wm6KWG
         3yWA==
X-Gm-Message-State: AOAM532L1RIGBZN3MftTEG29k+DI3b/dDsKcrQ+4RQCTlU9WJhaufkts
        FU9tHbZnim5jPmYzA5i8Tbwol1zf+tZA1w==
X-Google-Smtp-Source: ABdhPJzLQpPv+gD+Lys9TV4lNKinpYYaDjG7wsKLtc/8IPHdd11nmaWfE+aFmtiaHwis9uk519M7KA==
X-Received: by 2002:a17:90a:5aa4:: with SMTP id n33mr4205318pji.66.1611549417115;
        Sun, 24 Jan 2021 20:36:57 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id a30sm14772483pfh.66.2021.01.24.20.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 20:36:56 -0800 (PST)
Subject: Re: [PATCH 1/1] bsg: free the request before return error code
To:     Pan Bian <bianpan2016@163.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210119123311.108137-1-bianpan2016@163.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <391237ba-b507-25a5-555d-23d59d3dbfb4@kernel.dk>
Date:   Sun, 24 Jan 2021 21:36:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210119123311.108137-1-bianpan2016@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/19/21 5:33 AM, Pan Bian wrote:
> Free the request rq before returning error code.

Applied, thanks.

-- 
Jens Axboe

