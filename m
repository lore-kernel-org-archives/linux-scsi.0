Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63DEC433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 10:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C451320747
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 10:22:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=javigon-com.20150623.gappssmtp.com header.i=@javigon-com.20150623.gappssmtp.com header.b="eS2AS63X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgGBKV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 06:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728403AbgGBKUp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 06:20:45 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7E2C08C5DE
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 03:20:44 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so28667234ejj.5
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2020 03:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=y6QK1uUJZHQuZnFXHjM7RpcCfhjO+BnMr6K6R14LikI=;
        b=eS2AS63X4xHtWcaWVJuiQnZRL3FS5hl/kitkp/qfhE2U4bn44KsMkcI5ahaIUhkpta
         6tvJeM0eRhhkkdT/HtD13QyqAXZlJuuAf/hOLUhwUyrVhrIjZLI2hfSmgt0Q4v08rWWl
         8hS+jEqsMJSVlJnAruXLO3In7Lsa86+0XITBf7uyOLIOrdOeks10qjwobA7CaPzU54OH
         mdateSDMB8KYldO8l84nBECnC0GG8g0k4bICDJTD3s+k3LkuNDtPYYV+0R3HUmtsZXuS
         e9+cfSLqkoMb/HgGnCCw/eX3Iyfs42vr/mrFfAeVgD77VV9daKXn2j6SDsAxfRoi+XfU
         Ak+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=y6QK1uUJZHQuZnFXHjM7RpcCfhjO+BnMr6K6R14LikI=;
        b=amcZBRR3Qv5VvUfBiSYN+PAs1NJ/eFm3hOwzkatwgcccnIPQqkfxMh+jp/HFfPlzUM
         Q2NJMhiWusgd0J9ehQ96o6XDUtRmhdc9+g/e7WbBvefODRPSQuVh2fntNwWrjk/OB2hB
         2cxdCe8UtZ7pVIhqpNVJRAaXtG9Nd4IfLYNFgzf++9UeH3BECSWzbYBx//9muHCnspkl
         BIMzgKYdqBcbQPtyHzTITUtuCftO2LSvhvooImZkCceNmW7bBMGAepb3V0dtrS4MwtRa
         ztQQ3J33Hi15LQ4YORzej8hgqaN1qaGUoK7Qg1dH30QJG3o00bd2WGj5CVLL+rcb62m9
         rPcw==
X-Gm-Message-State: AOAM531ZbVnV2VQSnjdmzx1Hje2mFSUP9FIk/FHJ/yQhhRpoRZRhrn8z
        7wLIQrcbSe/1cipXNR4fe0Lgmw==
X-Google-Smtp-Source: ABdhPJznU0cTuSpy44OchlJ/NcoicUfXVthk+RD4AWFPMdlv1FyVBTAxmHOyydYRtWmTGe2aRm0ZCQ==
X-Received: by 2002:a17:906:c142:: with SMTP id dp2mr28125124ejc.541.1593685243381;
        Thu, 02 Jul 2020 03:20:43 -0700 (PDT)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id dh16sm9185934edb.3.2020.07.02.03.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 03:20:42 -0700 (PDT)
Date:   Thu, 2 Jul 2020 12:20:41 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: add max_active_zones to blk-sysfs
Message-ID: <20200702102041.qlehlokxel5ed6sf@mpHalley.local>
References: <20200616102546.491961-1-niklas.cassel@wdc.com>
 <20200616102546.491961-3-niklas.cassel@wdc.com>
 <20200701111330.3vpivrovh3i46maa@mpHalley.local>
 <20200702084104.GA607715@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200702084104.GA607715@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02.07.2020 08:41, Niklas Cassel wrote:
>On Wed, Jul 01, 2020 at 01:16:52PM +0200, Javier González wrote:
>> On 16.06.2020 12:25, Niklas Cassel wrote:
>> > Add a new max_active zones definition in the sysfs documentation.
>> > This definition will be common for all devices utilizing the zoned block
>> > device support in the kernel.
>> >
>> > Export max_active_zones according to this new definition for NVMe Zoned
>> > Namespace devices, ZAC ATA devices (which are treated as SCSI devices by
>> > the kernel), and ZBC SCSI devices.
>> >
>> > Add the new max_active_zones struct member to the request_queue, rather
>> > than as a queue limit, since this property cannot be split across stacking
>> > drivers.
>> >
>> > For SCSI devices, even though max active zones is not part of the ZBC/ZAC
>> > spec, export max_active_zones as 0, signifying "no limit".
>> >
>> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>> > ---
>
>(snip)
>
>> Looking a second time at these patches, wouldn't it make sense to move
>> this to queue_limits?
>
>Hello Javier,
>
>The problem with having MAR/MOR as queue_limits, is that they
>then would be split across stacking drivers/device-mapper targets.
>However, MAR/MOR are not splittable, at least not the way the
>block layer works today.
>
>If the block layer and drivers ever change so that they do
>accounting of zone conditions, then we could divide the MAR/MOR to
>be split over stacking drivers, but because of performance reasons,
>this will probably never happen.
>In the unlikely event that it did happen, we would still use the
>same sysfs-path for these properties, the only thing that would
>change would be that these would be moved into queue_limits.
>
>
>So the way the code looks right now, these properties cannot
>be split, therefore I chose to put them inside request_queue
>(just like nr_zones), rather than request_queue->limits
>(which is of type struct queue_limits).
>
>nr_zones is also exposed as a sysfs property, even though it
>is part of request_queue, so I don't see why MAR/MOR can't do
>the same. Also see Damien's replies to PATCH 1/2 of this series,
>which reaches the same conclusion.
>

Thanks for explaining Niklas - makes sense. I just looked at your patch
again while adding other attributes and thought it would be worth asking
the reason behind it.

You can keep the reviewed-by on the 2 patches.

Javier
