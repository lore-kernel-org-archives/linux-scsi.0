Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B4FC47096
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:48:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 876C0613AE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:48:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbhFANuB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 09:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbhFANtz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 09:49:55 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0921FC06175F
        for <linux-scsi@vger.kernel.org>; Tue,  1 Jun 2021 06:48:14 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id j1so7759758oie.6
        for <linux-scsi@vger.kernel.org>; Tue, 01 Jun 2021 06:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ipnxCnh19CBJuunWP2rsr0Ni235aZXMcvM30fyFeMuQ=;
        b=V0S6R6UmafrosfqM3fzGD59jB381L/p/7bytRzwtBjYk44ZPHrKU2HWzuhEzDtJydz
         DcC2KuQLoE18J1FBUZSGYoGhMnGy/8g1rqYoJGA9u7Sl03aalZoIoPk0TGD4xNqxAY7d
         tPYK7Xscb78FUgSfSKjdk7sFCijlvrJAqgrGtfjbn1GsnWDmw5xPhSff3fyvddODDseP
         oU1SoctgdMc/jCDOobqf03LN44VFePEEwGOVAzSLH97WR+9DCP886TcERarzw36yWuIP
         viV7w20/QrLhpYL4LJyJm4heuLOJXlX7FOiquGi/N1RKufWGQjPnG/EsoE1rSNG1bS9/
         WRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ipnxCnh19CBJuunWP2rsr0Ni235aZXMcvM30fyFeMuQ=;
        b=Lng4gwQ6Zj7ya0CpQ34U3njaimiTR0p0Uq8mL9V/NQyEkx0mW1xLM4rSAUAMge31Dr
         X+8yHC31Zba6eNN6a/myKjNHYVqNkdX8QVTqNvqdiswluNcZndJaT9ZsgCWC9Y/sUDhr
         okjbmuzgoqL7FGOFdYgNqMBJYh2h/b68oKGwWCJKAm4DkxljeK+v6HFDoohs287Oz5ZJ
         SEmVuJr6Rz625Fq4pmoYjbkNuRcFR8YzMHji/E7ELHiLGWHGTJlOFaR/TDovFTOfO2Wr
         raOFh0X7bWonja5LAcZROXcI6GUq6ZrhFaTUZKhRPcyVVUwliqgb/OGFEU4kQG9l0CN6
         26fg==
X-Gm-Message-State: AOAM531tmiYZr4MGfgkCCegv3X3LvCu15wfJ8YtBxI3oDerwVR8JUdX2
        9wNICIsia64fA3Wr91nL2ugnMX2UaT1DNQ==
X-Google-Smtp-Source: ABdhPJwxhtnzC3SisgYG8G/QsGTGKUqev34GCI1fM06rYYNl9kpAe5mHjI/TkhPqkXu3hvSl0+OSHA==
X-Received: by 2002:a05:6808:13ca:: with SMTP id d10mr18287063oiw.24.1622555293127;
        Tue, 01 Jun 2021 06:48:13 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id q14sm3731189ota.31.2021.06.01.06.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 06:48:12 -0700 (PDT)
Subject: Re: move bd_mutex to the gendisk v2
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20210525061301.2242282-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d5ce8361-f42d-c478-6e1a-5d652dc269d8@kernel.dk>
Date:   Tue, 1 Jun 2021 07:48:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210525061301.2242282-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/25/21 12:12 AM, Christoph Hellwig wrote:
> Hi all,
> 
> this series first cleans up gendisk allocation in the md driver to remove
> the ERESTARTSYS hack in blkdev_get, then further refactors blkdev_get
> and then finally moves bd_mutex into the gendisk as having separate locks
> for the whole device vs partitions just complicates locking in places that
> add an remove partitions a lot.
> 
> Changes since v1:
>  - rebased to the latest for-5.14/block branch
> 
> Diffstat:
>  Documentation/filesystems/locking.rst |    2 
>  block/genhd.c                         |   59 +++------
>  block/ioctl.c                         |    2 
>  block/partitions/core.c               |   45 +++----
>  drivers/block/loop.c                  |   14 +-
>  drivers/block/xen-blkfront.c          |    8 -
>  drivers/block/zram/zram_drv.c         |   18 +-
>  drivers/block/zram/zram_drv.h         |    2 
>  drivers/md/md.h                       |    6 
>  drivers/s390/block/dasd_genhd.c       |    8 -
>  drivers/scsi/sd.c                     |    4 
>  fs/block_dev.c                        |  207 ++++++++++++++++------------------
>  fs/btrfs/volumes.c                    |    2 
>  fs/super.c                            |    8 -
>  include/linux/blk_types.h             |    4 
>  include/linux/genhd.h                 |    6 
>  init/do_mounts.c                      |   10 -
>  17 files changed, 186 insertions(+), 219 deletions(-)

Applied, thanks. Took a bit of hand-applying, but we got there. Please
check the final result.

-- 
Jens Axboe

