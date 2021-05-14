Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05097C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 15:36:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6E0D613C4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 15:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbhENPhl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 11:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhENPhk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 11:37:40 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D24C061574
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 08:36:29 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id c16so138758ilo.1
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 08:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4/GUoS/s/pmKCrrW4dpmT6VyHP1dRyQUpvAxP6l+m+4=;
        b=c/J6awobOutwsD8qM65lKbpitWshdM0Z3jJuwxILQ6ZhdwOTgg7+Q4QqgKLGH09LiQ
         eYe6ECuHYExhZOU1TzMshCSmCu5Z5pVwlAvAtpfyLXNrCQNwttgPE0vvS197KKDfxZvA
         hlcp0d2PbZxB/7DNYSQC4dmNbOZzr+/+hIUGgvyYder5bqiKqyWjVH0HDtA05YAU1uvd
         EnRvJFEOUeRGGvFNRMKXVl0xdUwP9ZU8YGE4Mq9ab49QmEmSvL6Zk3RQIykZsGlSvvrr
         IJj5nwwSk+pwSYxxmSq/wtplyXwYrB8jHSGEB06BvGG2zwpQSZTxuv7/T5ZSIjDEylUs
         974w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4/GUoS/s/pmKCrrW4dpmT6VyHP1dRyQUpvAxP6l+m+4=;
        b=mEe7gg3AG1a6CtfkV22/rDu+vyKse6Ud3oMLL1gwIHwRYPCEBvc5uXJLPZH31Alpz+
         KCPse7QuE0F5/ZUKJZT6O+EvvSnTmeDVtP9L0jjHFQ1Z90ZC9Zh2HHrCcAMhVKO4vOn5
         97P1iFaXNgrE//PcKBsGBX4gIBHggh+AomNXCcZBMVnb/Cm9zqMv9a1pLY9rbgFEqXPp
         SxBC2b9ohjz3sKUQB4wjV+Cg5rtwx1pV90Gk9kTdqYHUcF5+SNdya0QGuu2gb48f2ZZi
         SJZRFzzuek9Fc+EGHjXTNc2iKDxmiWT3Z3xveOgkHTTuaxH9OuNTgpg39m0cUPc4/Kyh
         3zSA==
X-Gm-Message-State: AOAM531WLSmL07n0APx8mVNs1suiSg4XGpLGbR5IourncfSUmtbkIC08
        CB0GhFLNFGuobBKbBE5Ehw65JQ==
X-Google-Smtp-Source: ABdhPJyvIbSzncjDIb1dxsq2wEqhStDkWRXqtgyPV4HOJ6yW8EigZ4R0exjw+BiFUMHrrJ7pt2CVxQ==
X-Received: by 2002:a92:d1c4:: with SMTP id u4mr30973664ilg.286.1621006588857;
        Fri, 14 May 2021 08:36:28 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n184sm2922523iod.0.2021.05.14.08.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 08:36:28 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] blk-mq: Request queue-wide tags for shared sbitmap
To:     John Garry <john.garry@huawei.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, ming.lei@redhat.com,
        kashyap.desai@broadcom.com, chenxiang66@hisilicon.com,
        yama@redhat.com, dgilbert@interlog.com
References: <1620907258-30910-1-git-send-email-john.garry@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2d136383-7728-e680-7d1a-71c9f180fb28@kernel.dk>
Date:   Fri, 14 May 2021 09:36:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1620907258-30910-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/21 6:00 AM, John Garry wrote:
> This is v3 of patch/series. I have spun off a new patch for tag allocation
> refactoring.

Applied for 5.14, thanks.

-- 
Jens Axboe

