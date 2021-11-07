Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDB2C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 21:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F2661288
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 21:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhKGVWt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Nov 2021 16:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbhKGVWs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Nov 2021 16:22:48 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD52C061570
        for <linux-scsi@vger.kernel.org>; Sun,  7 Nov 2021 13:20:05 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r8so2431750iog.7
        for <linux-scsi@vger.kernel.org>; Sun, 07 Nov 2021 13:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zOxRSAEdOrXagFyqm1lOCp1sO7zqGLiMqKw0bXeJJWw=;
        b=Uqwvy1WfIUYdFgdp0V3DIiFt3IRdc+TcvOHSTfQ6XLL6SyxbOEN2Hrz2woauXeIieD
         h/PvpnxWuVQDz8HZXCbBsnhxAjvI8P8K7gnLRzQ/sjJW14y3Gj7LWLEhfa4NngvQlYp1
         I6sDHoEgVl6Y1Lac6Pt1ABMy2PI7wkq4R6XC9MxfOUJCA9x81CCltvlGLPScCyt+AH+K
         Z7YfbLUArGGQSWNOJi1AMnHB6GZfP9LM9Z6IWzl+PJb4wAiGHKDSPH4Ay2+THAlixsBj
         r3sM5l/7lP5CFXpzkcxjgEhzEFYscPq6qBrfmKdKXWvhWPDXgqgSDKMVl39n5x25Ve96
         Ikjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zOxRSAEdOrXagFyqm1lOCp1sO7zqGLiMqKw0bXeJJWw=;
        b=G6g/M8fq7qTXUNbXvnxXs40/Eep8vvdskl09aX1NQKFXYeWHxzH30tl3ovCWx2NlLx
         Az36DSCbG3wLZiE2m7G9uaOylW5/pcMA3LClSiFPl7dNDHjo0GO2C/bDp0QQ9o7WytSQ
         bAofH6LOcWuLeasAcdtw99Y1N43CocvOERk3cS4VNiZM1XijkPPfBz6pHFQuYXnQY8/Z
         k6nxCyacgaRXS/swZX9ZDEPJ3jFqdN0qu9Aa6kqmKQB4MtaDNbLbTzKMFA/dEZboSVRF
         0ISsKNj2hXJJdJP5TpSbPTfOV8ZEgyzMZtANi4pQmM6CT/RDzcRPksZio60caw9ab/fz
         8L3A==
X-Gm-Message-State: AOAM531QFsSvsEBH0faKIYs7+UICv+ziN1nvo+cvGWqEHajLVVmCHGKM
        PFMZ5fejQlUDnAMjlbzHF/tTLg==
X-Google-Smtp-Source: ABdhPJxM16nhV8xoydrnwWRXtjuHki9c6awqX1ZziMpc6LmtrmsPGonV89lpv8rnJEQjNGgLEoEloA==
X-Received: by 2002:a05:6638:1382:: with SMTP id w2mr14845378jad.50.1636320004782;
        Sun, 07 Nov 2021 13:20:04 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id g13sm7983553ilc.54.2021.11.07.13.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 13:20:04 -0800 (PST)
Subject: Re: [PATCH 0/4] block: fix concurrent quiesce
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <364680b4-defa-a559-f7bf-53adcbec957f@kernel.dk>
Date:   Sun, 7 Nov 2021 14:20:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211103034305.3691555-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/21 9:43 PM, Ming Lei wrote:
> Hi Jens,
> 
> Convert SCSI into balanced quiesce and unquiesce by using atomic
> variable as suggested by James, meantime fix previous nvme conversion by
> adding one new API because we have to wait until the started quiesce is
> done.
> 
> 
> Ming Lei (4):
>   blk-mq: add one API for waiting until quiesce is done
>   scsi: avoid to quiesce sdev->request_queue two times
>   scsi: make sure that request queue queiesce and unquiesce balanced
>   nvme: wait until quiesce is done
> 
>  block/blk-mq.c             | 28 +++++++++++++------
>  drivers/nvme/host/core.c   |  4 +++
>  drivers/scsi/scsi_lib.c    | 55 +++++++++++++++++++++++---------------
>  include/linux/blk-mq.h     |  1 +
>  include/scsi/scsi_device.h |  1 +
>  5 files changed, 59 insertions(+), 30 deletions(-)

James/Martin, are you find with the SCSI side? Would make queueing this
up easier...

-- 
Jens Axboe

