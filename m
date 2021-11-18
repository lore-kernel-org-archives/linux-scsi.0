Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B065FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Nov 2021 15:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 905E861B31
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Nov 2021 15:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbhKRP1f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Nov 2021 10:27:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhKRP1c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Nov 2021 10:27:32 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04756C06173E
        for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2021 07:24:32 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id l19so6886992ilk.0
        for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2021 07:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=O+/LXAwdkIJFE9KERkHFyTHYhgjPDJwSFxMMHTdX3yg=;
        b=zBgJto18usU1xmq60M/0PBBdZEdin6MxUciyiMPmsRm9qlqmMppb67SSa8ExVBDlU0
         wMIMQB4F2uNjgBspW9AUAlLe9EdMZagx6Rw1bo3z9mBb+ChKlYuY023xwH7+4mqCB5VR
         28utk188sEDlpfgFJZ3bUToDJwh7ta11qg2TsiHU4DmE0/hLFb2s6IMMzKqHd3CoJarX
         leI/RkYcuY9ShLCIT2USQboFiPMG+8K1u9hjvChxmToKwaVWHJ5Vu67XtNT6KkP4JK5b
         M6pScDfMWb/7d9+klkgpUmswb5SRm4iY9TO0N0KEN4YreO/SfqghCDKbeS2uLRFWovX2
         fW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=O+/LXAwdkIJFE9KERkHFyTHYhgjPDJwSFxMMHTdX3yg=;
        b=c0zmHRU1ILUNHGioVX8HeF8MJ+izWLgqX5gNPQF7Fxgdp5XulRzcSOAhdrZBz7+LJn
         OugkCuO6SZpdYBV0DK5gbmE2JDvjOyyNg2UNTU/G7+qz4ro5PclorFoXVuRncfUF3AXD
         9q2EbKnf5jfXcFqzyumIDy7AroWqWP1utpoAn1NB6dQZxrJgKOA1IXboHr9Qx8xAPAoU
         wyR1AHaVXIomjZUPQ6GcGafY+OeOPgp2LryReT4ekmTIVvz5ah7NlguSNSCY6PY6dNfu
         kYd0tGKnf1/4E89YIHZj7vvb0LwM6i7uSbGKmZICmTRoOfM6L4RoCCtfigskhrn4e8qS
         Rxsg==
X-Gm-Message-State: AOAM530hnu1xXpS9oTO4Iu62PU0Osb+SYPVj5bwIrP1/gRT4/kU7o3z8
        cBQCJDiLWP49odQjZt3oiihV9g==
X-Google-Smtp-Source: ABdhPJw1CWvXIjvXMCPpD5KBZHirebHOwrkAQuXnPfp/9QlIOYGfAXP3exXDWUrnkjPXIosCNhmHQg==
X-Received: by 2002:a05:6e02:1c0c:: with SMTP id l12mr16760032ilh.84.1637249071369;
        Thu, 18 Nov 2021 07:24:31 -0800 (PST)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p18sm73311iov.44.2021.11.18.07.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 07:24:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-mtd@lists.infradead.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Richard Weinberger <richard@nod.at>,
        linux-scsi@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-block@vger.kernel.org
In-Reply-To: <20211117061404.331732-1-hch@lst.de>
References: <20211117061404.331732-1-hch@lst.de>
Subject: Re: move all struct request releated code out of blk-core.c (rebased)
Message-Id: <163724907076.288457.4311609107060829308.b4-ty@kernel.dk>
Date:   Thu, 18 Nov 2021 08:24:30 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 17 Nov 2021 07:13:53 +0100, Christoph Hellwig wrote:
> this series (against the for-5.16/passthrough-flag branch) removes the
> remaining struct request related code from blk-core.c and cleans up a
> few related bits around that.
> 
> Diffstat:
>  b/block/Makefile            |    2
>  b/block/blk-core.c          |  341 --------------------------
>  b/block/blk-mq.c            |  573 ++++++++++++++++++++++++++++++++++++--------
>  b/block/blk-mq.h            |    3
>  b/block/blk.h               |   33 --
>  b/drivers/mtd/mtd_blkdevs.c |   10
>  b/drivers/mtd/ubi/block.c   |    6
>  b/drivers/scsi/scsi_lib.c   |   42 +++
>  b/include/linux/blk-mq.h    |   13
>  block/blk-exec.c            |  116 --------
>  10 files changed, 552 insertions(+), 587 deletions(-)
> 
> [...]

Applied, thanks!

[01/11] block: move blk_rq_err_bytes to scsi
        commit: 6ace6442a37e17d56a1c54f55bea48ac796f869d
[02/11] block: remove rq_flush_dcache_pages
        commit: 01ed1e78789a2e3d7a895ca38706a4fb1a6146d0
[03/11] block: remove blk-exec.c
        commit: 9048707b1d8f8aebcf23e5b5b143ad1de2a93b34
[04/11] blk-mq: move blk_mq_flush_plug_list
        commit: 33af852518417ed7a90703c572e58cc99bef4770
[05/11] block: move request based cloning helpers to blk-mq.c
        commit: 432f3b8863dc44ac224e231dbe1b0038b5aa4239
[06/11] block: move blk_rq_init to blk-mq.c
        commit: 8586ee1a36a8f690492a7b7ee8f31c514d65957d
[07/11] block: move blk_steal_bios to blk-mq.c
        commit: 4ef40a1dc9ebeaa87cb53f16641d439d4ebcfdd0
[08/11] block: move blk_account_io_{start,done} to blk-mq.c
        commit: 1bdc7c540b455837af9d736e5f0abb77cfce3e62
[09/11] block: move blk_dump_rq_flags to blk-mq.c
        commit: 8a77648954e63f6654042567e31794bfd5ea02a5
[10/11] block: move blk_print_req_error to blk-mq.c
        commit: 065c87d65d74ac24bfc3bbc43de068ba99188b1c
[11/11] block: don't include blk-mq headers in blk-core.c
        commit: d94d230a3711ac85af1c3cd484419a4a81193387

Best regards,
-- 
Jens Axboe


