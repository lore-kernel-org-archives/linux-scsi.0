Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E0BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 14:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiI3OFF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 10:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbiI3OFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 10:05:03 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEEB69186
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 07:05:00 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id h194so3328307iof.4
        for <linux-scsi@vger.kernel.org>; Fri, 30 Sep 2022 07:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=KE/La02ogRQIY/HzxSEopjUhIfT01GVed+k6zu427FM=;
        b=eTSscY00rOLUJHWuFQyJIl59dQGpUSoWvHHwSfNnFKA4Lw44WSKU49+jZTWN47Jnf5
         55R/FwWHdwkFedGF7J3APM2KsySrM9JgactJUB3aSET9yPsj9KVjVwyT4ZLrz+OD+KKV
         AhfLWzDGtUjoMr5OXEttfZYzZDT4hj0bjxzcqlI1syLfAFm+CjXjGbkI72jZhUIib47a
         TiVeQlPuyIFn+ebZpyH/8DYCExfqdWWWzDillNjOUNcotehAMdGUndCvUHfH4w0GpLJq
         ughRo26e9JqrBgCkOHoGxXOjnjLv3PQ8AiiKFqEgltASsaQc8z5EH/ExdZCSOWlOJt00
         kMXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KE/La02ogRQIY/HzxSEopjUhIfT01GVed+k6zu427FM=;
        b=MoBmg1V+dge8ZupKNPKRRshibwtIg53pF0OMqoFkIy2whDVWRDcHJFpIpeOQMUvn19
         u2hMXIT00CNwukhihunwPoUrP7VkyLoXLvZHP+7cpXa5MjJWrW+wZYPWEI58QFcSSfGp
         uUg/KhDuB2oyWTnoDTb5uyiseusPnsO/KeLVpiMgR+z13gbcdngpEB7kE9+3Sactrfwf
         DHUegy1tMarC/oFLXYxOopz3bc2SayM9ZiTK17GftVYS2LS10SsyNjb+65GGXRr5y0/3
         WOUSJD1V7XbnM53oZ1olZ/ZJnidhurI1RSrSC1sWSC8l4cZVaBpSJZzEftDnFKn6q3fB
         CXQg==
X-Gm-Message-State: ACrzQf0Hq091Ku8IEXDy9MQ9qlQKa6EShyQFt95HjyJf3nxDvzzqtTg/
        L9rA8VcejS1fHQWTWa8kC74kNCbTDIvrag==
X-Google-Smtp-Source: AMsMyM4JtLxVJcRSJ6Gida3IQoin845TBOh5Ewp8EzEnzwL947qn7d3mtbmSE+hpAqBx4RR26Cvc1w==
X-Received: by 2002:a05:6638:1449:b0:35a:70ce:8a3f with SMTP id l9-20020a056638144900b0035a70ce8a3fmr4631148jad.42.1664546700214;
        Fri, 30 Sep 2022 07:05:00 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y4-20020a027304000000b00349d2d52f6asm963095jab.37.2022.09.30.07.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 07:04:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     kbusch@kernel.org, Anuj Gupta <anuj20.g@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        gost.dev@samsung.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
In-Reply-To: <20220930062749.152261-1-anuj20.g@samsung.com>
References: <CGME20220930063754epcas5p2aff33c952032713a39604388eacda910@epcas5p2.samsung.com>
 <20220930062749.152261-1-anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v12 00/12] Fixed-buffer for uring-cmd/passthru
Message-Id: <166454669913.10664.15099234392865928285.b4-ty@kernel.dk>
Date:   Fri, 30 Sep 2022 08:04:59 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 30 Sep 2022 11:57:37 +0530, Anuj Gupta wrote:
> uring-cmd lacks the ability to leverage the pre-registered buffers.
> This series adds that support in uring-cmd, and plumbs nvme passthrough
> to work with it.
> Patches 3 - 5 carve out a block helper and scsi, nvme then use it to
> avoid duplication of code.
> Patch 6 and 7 contains a bunch of general nvme cleanups, which got added
> along the iterations.
> 
> [...]

Applied, thanks!

[01/12] io_uring: add io_uring_cmd_import_fixed
        commit: a9216fac3ed8819cbbda5d39dd5fcaa43dfd35d8
[02/12] io_uring: introduce fixed buffer support for io_uring_cmd
        commit: 9cda70f622cdcf049521a9c2886e5fd8a90a0591
[03/12] block: add blk_rq_map_user_io
        commit: 557654025df5706785d395558244890dc4b2c875
[04/12] scsi: Use blk_rq_map_user_io helper
        commit: 6732932c836a4313f471b92b4d90761f31d3fa81
[05/12] nvme: Use blk_rq_map_user_io helper
        commit: 7f05635764390d5f811971af9f4c89b794032c80
[06/12] nvme: refactor nvme_add_user_metadata
        commit: 38c0ddab7b93daa90c046d0b9064a34fb0e586e5
[07/12] nvme: refactor nvme_alloc_request
        commit: 470e900c8036ff1aafeb5f06f3cb7a375a081399
[08/12] block: rename bio_map_put to blk_mq_map_bio_put
        commit: 32f1c71b15fc9cb8e964c3d0c15ca99a70cfe8a7
[09/12] block: factor out blk_rq_map_bio_alloc helper
        commit: ab89e8e7ca526ca04baaad2aa28172d336425d67
[10/12] block: extend functionality to map bvec iterator
        commit: 37987547932c89f15f9b76950040131ddb591a8b
[11/12] nvme: pass ubuffer as an integer
        commit: 4d174486820e625fa85bac5d4235d4b4cb659866
[12/12] nvme: wire up fixed buffer support for nvme passthrough
        commit: 23fd22e55b767be9c31fda57205afb2023cd6aad

Best regards,
-- 
Jens Axboe


