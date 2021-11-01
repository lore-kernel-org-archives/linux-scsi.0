Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2871FC43217
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 19:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1447060E52
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 19:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhKAT4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 15:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbhKAT4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 15:56:47 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9BFC061714
        for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2021 12:54:13 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id w15so13576414ill.2
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 12:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=koQbBQ21p1fsQdBlT5oLumJMTocgWXeZsx4RpVzAmQY=;
        b=XnM6Ww1xAQ4aJAntWmx/aW6fEB3s9w9ALEa1XdlQXpgI819xGeGCnMWiLcvoQX33dd
         D7BSLvA2/wXUDFmEIGAPnBRlHzmebowZAOS6qqTbgLyHyN1JGeUO1YwXcdP00kFSPKTV
         +HtxkrwnQcjhih+8t2e30Rk2ZvuzfciWz9EF2pL0dLPAer/y3psjbe6/Il0RsGa0HUrM
         jyhH3vJ8AtNvd/o5N0EVRqwnpqwcCxCuXjMxD3hdxL/Ytw9jxluTRp5DoWHn8bhmoka2
         0uJ07IuLEylCjtLg8i99QDwsVhFEti7bB0w9fWk5l4GiXFkod8uWQD02VkJGzGn0Z3z3
         O3gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=koQbBQ21p1fsQdBlT5oLumJMTocgWXeZsx4RpVzAmQY=;
        b=bzQfxkW4300NjCmFOJNv2suF6s3pDfTwHubZqGkX5uvQ/8DGIzioQTHcto24H+JHWo
         Y5ECFN2uo78AsB7d4QGhbKId7sjVxoUb8YLNpsbBL2zPWB1odPsmqS8gGYybbLkfcVLQ
         jD5+mTwGlVyYeXYeWnjCK1DbiioCf1O5gsj720WzAirlSoCDiaBXffT/ErJD0c3Cy6Et
         j7McpGkZkE7GRHmTknR72Se+X549TjtyRa4QmHqg7T+4C19esG+uWKpNtXs+uiR/LqAa
         WSXJ4ghfLXkMD2Nk4d1IyVu8ROEYNaiIqLmH6e32gsA19vqUseYFuhI8MqvQJFGZpYVA
         wgQQ==
X-Gm-Message-State: AOAM531cpogLJs+fCB6v3nxUW2757ReSZjj/g+8UqNjv5xfJ1STd+ziD
        d5O12X6Wxj+9NEVsRu86RLr7+w==
X-Google-Smtp-Source: ABdhPJy/9YCvWsy4CcYhHnrFyE0rT2z+RApGafmCg/y4Tz/3v9B8FSsOihEyIPkQmLe0tOe8OerETw==
X-Received: by 2002:a05:6e02:1e02:: with SMTP id g2mr21957731ila.67.1635796452720;
        Mon, 01 Nov 2021 12:54:12 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h14sm8440390ils.75.2021.11.01.12.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 12:54:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     dm-devel@redhat.com, Yi Zhang <yi.zhang@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org
In-Reply-To: <20211021145918.2691762-1-ming.lei@redhat.com>
References: <20211021145918.2691762-1-ming.lei@redhat.com>
Subject: Re: [PATCH 0/3] block: keep quiesce & unquiesce balanced for scsi/dm
Message-Id: <163579645206.169811.345176407474716806.b4-ty@kernel.dk>
Date:   Mon, 01 Nov 2021 13:54:12 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 21 Oct 2021 22:59:15 +0800, Ming Lei wrote:
> Recently we merge the patch of e70feb8b3e68 ("blk-mq: support concurrent queue
> quiesce/unquiesce") for fixing race between driver and block layer wrt.
> queue quiesce.
> 
> Yi reported that srp/002 is broken with this patch, turns out scsi and
> dm don't keep the two balanced actually.
> 
> [...]

Applied, thanks!

[1/3] scsi: avoid to quiesce sdev->request_queue two times
      commit: 256117fb3b4f8832d6b29485d49d37ccc4c314d5
[2/3] scsi: make sure that request queue queiesce and unquiesce balanced
      commit: fba9539fc2109740e70e77c303dec50d1411e11f
[3/3] dm: don't stop request queue after the dm device is suspended
      commit: e719593760c34fbf346fc6e348113e042feb5f63

Best regards,
-- 
Jens Axboe


