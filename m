Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9106C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 14:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbiBQOxx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 09:53:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiBQOxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 09:53:53 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A6F1F4678
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 06:53:35 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f8so5227973pgc.8
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 06:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hWNk4us8op0b+wJiLg7HIDjnopxPEpD5VgycDmXyYzA=;
        b=0CArP/gwlQRvcpiaXCGErcBTurFuCrJ2cas60eHKzs6UH1KGNOFVAG3Fhf9ohu8LQx
         LM3ioGDDZtvpc3dReOMoF6Fh00kJa0wFtWEuC1Tyf/V+C3iy63P8BhWQdb59c0WEeZIP
         So15CzC4qKzVM6Jc+7imzy49BKxzNSrj8S8dWZbu4n6ck7Hr13qmB/wX3WbAD5aJ1UUq
         /Um/Kw36eg/OZqGHbar22/To5tsRod0ai0dyh6KDAj4GuG2CmXEhEKZPGQ4oIEVKxdgP
         WtY0h97QM8hJeRidzM2GXWyjwWXmWhdKeMAqYeKfLrFdwhHphKwpOKELe3WzDoKeJw5/
         gRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hWNk4us8op0b+wJiLg7HIDjnopxPEpD5VgycDmXyYzA=;
        b=NNuTaTCO3ykwb+xm0HH29anj26xoxkfXBPAd8WPz/INYSZglrrv1Ha3Tj6PWBZU+mj
         vafF/mAsWPL9hGum7yTR71UA8D36Z/IJTIbcM771QZKTQI2rem9hlnxmoArJuDCrMYpS
         LLuKiOH8vOpbn9Nj6vssz1EXgQ8QcWfRlzGtb814pZb+D6az+B0wABtHFId1W8ZalNH1
         Z8+FM51kpYFvqdis5Z9jcM3iuElRNHfF790ut+5wKBKT1WGCMWLDGAXssuEGXK/n9y5w
         GNjNiGKiTCNZ4HQqpGGdK0oDyf5hfFZQpn9A0NABEu6ECdVBmw9T2cdw70EQkjoDQrtm
         lPew==
X-Gm-Message-State: AOAM531bzoxUy6Si1Xf5H1ewPyp28DUlL+P/BIXLhBi0d9uJyMDd9t20
        TwgPGT0QPtT16YL1bD878+yR1ZMqrahkdA==
X-Google-Smtp-Source: ABdhPJxW7afmkKFjzfcCg0HmJf5RhvRYLphPv08F70x0dWvJm45BTosHGiOgq3k6MuwoCP5HHJNC1w==
X-Received: by 2002:a65:6e93:0:b0:362:da8d:88d5 with SMTP id bm19-20020a656e93000000b00362da8d88d5mr2703141pgb.194.1645109615299;
        Thu, 17 Feb 2022 06:53:35 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s5sm8651284pgo.37.2022.02.17.06.53.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 06:53:34 -0800 (PST)
Message-ID: <43426c0e-8c50-9288-05cf-7bc1f71c239b@kernel.dk>
Date:   Thu, 17 Feb 2022 07:53:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH V2 04/13] block/wbt: fix negative inflight counter when
 remove scsi device
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Ming Lei <ming.lei@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Laibin Qiu <qiulaibin@huawei.com>,
        Ming Lei <ming.lei@rehdat.com>
References: <20220122111054.1126146-1-ming.lei@redhat.com>
 <20220122111054.1126146-5-ming.lei@redhat.com> <20220217074502.GA1333@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220217074502.GA1333@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/22 12:45 AM, Christoph Hellwig wrote:
> Jens, can you pick this up for the block-5.17 tree?

Done

-- 
Jens Axboe

