Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11CEEC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 04:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF99B2256F
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jan 2021 04:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbhAYEyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Jan 2021 23:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbhAYEyN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jan 2021 23:54:13 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA088C06174A
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jan 2021 20:53:32 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l18so1707409pji.3
        for <linux-scsi@vger.kernel.org>; Sun, 24 Jan 2021 20:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yCVXNmnkbukJI6FbnBMkRVDM8J/Lut2yGB3GCl5tMhk=;
        b=mUc+2GmhUCQFtGXsbDdMUePaHUC70SqcjIvNUGzmQAMRmDih05IYA/pLKTv5cpBUJg
         8D4F5NWSJKzdXYHX3tUo/gpur6bsvJgO0jl+aDqenyGk4M3crlQnK9+R3fse9TDvl9Kg
         PDvjAjdRxv7sEQky3VyreBHgThr+GzpCJW1XuWOAUmcO51X0t91JXgwFck88xc5IXzZ7
         kcZMpDwGdq/6TX1yaFTbsmRuAy8Q+Bd9qAymHynKCsDAhhvlHsCRTzF+gutiHWy4k037
         tg1DroGlhRJAHLuCAeOG6dOO/t8s4/8RlUz8Nd7VLJNZUmhsSiwItgtDZcoPgaKB9O6D
         PMFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yCVXNmnkbukJI6FbnBMkRVDM8J/Lut2yGB3GCl5tMhk=;
        b=rTc1JXBDKRMwFBsIHAvAiRv5i6+0TUBc/V4SDb1YCx1o+n8ijZl6+uykODA28KI1/e
         CZSYYa6UqFgndDpD8dFygsMqndTOs+c5zghSdPvIxRqfw2lRrEyYh24/lZinQ9lk+Sme
         rX9Ip1hiAAgSbz+Otpb16f+mTOVyjdtAn0DA59FAZEF01BHCoL3g1lEL0Z6cm8PNrbzT
         7VBm41dIxZJ5lYK7cw8ReXZhm2UVXZXIbDbG//Xaq9bODuAI4d2c9srzdQDPUKQPQDRQ
         dItngTMrY+6iF8n9n2vTKBCGSk+pz5BzZrGfvmM0Li0ZYa/FB1N6lPoEUVscbPkpIkTC
         DbUQ==
X-Gm-Message-State: AOAM530pF1Pj/1NKhaadu5e9jSGlAEw4fA5+mkQvWjJS+7PdPvZytUK7
        6BVtNY27zWzNu4gnlJmoSCzkww==
X-Google-Smtp-Source: ABdhPJxH9fkoQGdpf2yTn0S6RVjDGgTIT95lILem9Ftm+wTQRagGEoMXbOUbGd2ZD+OyyhreIN7wUA==
X-Received: by 2002:a17:902:b285:b029:de:a0a3:f3b9 with SMTP id u5-20020a170902b285b02900dea0a3f3b9mr336676plr.34.1611550412389;
        Sun, 24 Jan 2021 20:53:32 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 68sm14877443pfe.33.2021.01.24.20.53.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Jan 2021 20:53:31 -0800 (PST)
Subject: Re: [PATCH V3 0/2] remove unused argument from blk_execute_rq_nowait
 and blk_execute_rq
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org,
        hch@infradead.org
References: <1611550198-17142-1-git-send-email-guoqing.jiang@cloud.ionos.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <50c4cdb5-b5ea-5431-c319-a6784f33f8b6@kernel.dk>
Date:   Sun, 24 Jan 2021 21:53:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1611550198-17142-1-git-send-email-guoqing.jiang@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/21 9:49 PM, Guoqing Jiang wrote:
> V3 changes:
> 1. rebase with for-5.12/block branch.
> 2. add Ulf's Acked-by.
> 
> V2 changes:
> 1. update commit header per Christoph's comment.
> 
> Hi Jens,
> 
> This series remove unused 'q' from blk_execute_rq_nowait and blk_execute_rq.
> Also update the comment for blk_execute_rq_nowait.
> 

Applied, thanks.

-- 
Jens Axboe

