Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346F7C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 11:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12D3560296
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 11:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhKDLvw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 07:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbhKDLvv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 07:51:51 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8B3C061205
        for <linux-scsi@vger.kernel.org>; Thu,  4 Nov 2021 04:49:13 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q203so6385013iod.12
        for <linux-scsi@vger.kernel.org>; Thu, 04 Nov 2021 04:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=jcCYN/Vpuq9VjyR1baSc9jmePXWBGgpQHLyfjUo1kN0=;
        b=qFXeUbMx+fks5h4unoMKTc1LhJZqSE1NyKDAI5w83ogMKOOM0kU3purU/H33NlzPwW
         eHVV1IidhsSGwT1O6tr2jF8Faxr9jVev093BxfP6VSI4dkQ3J3vb4BtkyS+WNvCZLafE
         8RJ6NCGluBEgk853x+GL8iDQYteU5vl6fdQl0+ni96MIOIczYSlK45zpvMifA/kD95hg
         rPa4O1733yq2aC4AVUSrYAMw0Vg1m8W65eUmAmMKxQpMGVCRJrPiS3bXB3M6N1UHwxhP
         raoRViyx1obQj3jBzWassDHD8Ul/z65tEi99uP15mHMonnQSFjUH3i7iVD/2O78UIwYf
         qCcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=jcCYN/Vpuq9VjyR1baSc9jmePXWBGgpQHLyfjUo1kN0=;
        b=2zApuOMFNc+JpFBx/aX5KSQkHKeXm/YEjMhzhC8aHidzpXaqPxZcR02AZMF6lrhNwb
         puktz7tEojWwdryqFC/8u65EPL16nf2bWiR/585f3qPYqj8pdwrOsLWlJchZuZKOOCa3
         hdwn9Ivy+erliN5iSh/eMN/qtjlat1F0JAPZoB7vIdpLasbyfsW5+G6pk2J7K+dUMJou
         olmngvA6S8ZUaXoYwAlDtLO7R8mSYAtACziYJu2s1eRNMbB2vzC8rgMrDwSGI+QzNeve
         QyDFlLQqbnZeV95AY6u4Td4zSCVSTUHO2MHOIdoyrxWNcPdRhF5Wm/MXhyT39ToQIovq
         dd5g==
X-Gm-Message-State: AOAM530LRH3Z6JOWOfVvGvFxv1kn8c8o2r+fWdxlMcFH4zvgnmfPZPDB
        bI3Wze2P7MOAivtNS8wEpLHAGQ==
X-Google-Smtp-Source: ABdhPJzJv5ibu1rdNLJ/Ra2e9JNtbTKOYYws7eMieW7cg3crbW5dob+RRrmopP3pH67AnoqS2LtSxw==
X-Received: by 2002:a5d:9e44:: with SMTP id i4mr700296ioi.172.1636026552990;
        Thu, 04 Nov 2021 04:49:12 -0700 (PDT)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y3sm2877761ilv.5.2021.11.04.04.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 04:49:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     miquel.raynal@bootlin.com, martin.petersen@oracle.com,
        hare@suse.de, Luis Chamberlain <mcgrof@kernel.org>, jack@suse.cz,
        hch@lst.de, song@kernel.org, dave.jiang@intel.com, richard@nod.at,
        vishal.l.verma@intel.com, penguin-kernel@i-love.sakura.ne.jp,
        tj@kernel.org, ira.weiny@intel.com, vigneshr@ti.com,
        dan.j.williams@intel.com, ming.lei@redhat.com, efremov@linux.com
Cc:     linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
In-Reply-To: <20211103230437.1639990-1-mcgrof@kernel.org>
References: <20211103230437.1639990-1-mcgrof@kernel.org>
Subject: Re: [PATCH v5 00/14] last set for add_disk() error handling
Message-Id: <163602655191.22491.10844091970007142957.b4-ty@kernel.dk>
Date:   Thu, 04 Nov 2021 05:49:11 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 3 Nov 2021 16:04:23 -0700, Luis Chamberlain wrote:
> Jens,
> 
> as requested, I've folded all pending changes into this series. This
> v5 pegs on Christoph's reviewed-by tags and since I was respinning I
> modified the ataprobe and floppy driver changes as he suggested.
> 
> I think this is it. The world of floppy has been exciting for v5.16.
> 
> [...]

Applied, thanks!

[01/14] nvdimm/btt: use goto error labels on btt_blk_init()
        commit: 2762ff06aa49e3a13fb4b779120f4f8c12c39fd1
[02/14] nvdimm/btt: add error handling support for add_disk()
        commit: 16be7974ff5d0a5cd9f345571c3eac1c3f6ba6de
[03/14] nvdimm/blk: avoid calling del_gendisk() on early failures
        commit: b7421afcec0c77ab58633587ddc29d53e6eb95af
[04/14] nvdimm/blk: add error handling support for add_disk()
        commit: dc104f4bb2d0a652dee010e47bc89c1ad2ab37c9
[05/14] nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
        commit: accf58afb689f81daadde24080ea1164ad2db75f
[06/14] nvdimm/pmem: use add_disk() error handling
        commit: 5a192ccc32e2981f721343c750b8cfb4c3f41007
[07/14] z2ram: add error handling support for add_disk()
        commit: 15733754ccf35c49d2f36a7ac51adc8b975c1c78
[08/14] block/sunvdc: add error handling support for add_disk()
        commit: f583eaef0af39b792d74e39721b5ba4b6948a270
[09/14] mtd/ubi/block: add error handling support for add_disk()
        commit: ed73919124b2e48490adbbe48ffe885a2a4c6fee
[10/14] ataflop: remove ataflop_probe_lock mutex
        commit: 4ddb85d36613c45bde00d368bf9f357bd0708a0c
[11/14] block: update __register_blkdev() probe documentation
        commit: 26e06f5b13671d194d67ae8e2b66f524ab174153
[12/14] ataflop: address add_disk() error handling on probe
        commit: 46a7db492e7a27408bc164cbe6424683e79529b0
[13/14] floppy: address add_disk() error handling on probe
        commit: ec28fcc6cfcd418d20038ad2c492e87bf3a9f026
[14/14] block: add __must_check for *add_disk*() callers
        commit: 1698712d85ec2f128fc7e7c5dc2018b5ed2b7cf6

Best regards,
-- 
Jens Axboe


