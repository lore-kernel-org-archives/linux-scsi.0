Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BAFC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 17:10:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BB7C61221
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Nov 2021 17:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbhKDRNa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Nov 2021 13:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbhKDRN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Nov 2021 13:13:29 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FACC061208
        for <linux-scsi@vger.kernel.org>; Thu,  4 Nov 2021 10:10:51 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id o83so10298839oif.4
        for <linux-scsi@vger.kernel.org>; Thu, 04 Nov 2021 10:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SevfzmLSoiSwyaqVR0wq8id+v0W8G6ODuu7UIBW98Ck=;
        b=FI/9ZNYr6/fAExz91u+4IwEk/Sxb4E3n6n+OTpB6yV1R775Z6Rzn9wDuRKyhtHW7Yh
         l0iXs/DRJdBCFSmFd1drvVOSND9tg7xbhdWhPlV+E7agORgDq700oVfwOrZafut+uTjL
         wZsxQZh6zgZB+DNENjftVxGc9YpUsDAGiRyi//LUZnHzRHIRnbOFxBpPg8XrR9F7ikSf
         UDIo8ruFN9iOwT6B1ti3FGya6rHDXaX1OIjfzbF69TkBR2jACv9yQMF30HkEsRnr62o1
         dHzC2TUCo67saJOtouCkKq8r/H4VDxeLV8YfMGOr2rul3DM4MH9og7FmH1N3/1TnIjKp
         FZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SevfzmLSoiSwyaqVR0wq8id+v0W8G6ODuu7UIBW98Ck=;
        b=LOCxory2yJjRRJIY7n/vOuloMX9QGTGxQ8JyWQboubQrTzk7B+koMtqNaSQ0dzlj1C
         FohSTOYZ2McGFOA6JdftZ2OCQTKH7ln03Sfp0ozu8Tk+N2oyECh8uCRIyg82baj2edr9
         BM0LqbwzAWD/YngTx0QTYCmJjik/S02ekSZU5jh/K+HimNGs203s5reMI6Sqwny6DL3B
         +wtieiMlvz5UUdvr1ulaOPfQc602uWrrBU/b/DQqdsCUs5gkR+9rJ/0m1FpNZZdtMETw
         qSFsYbYe+XzUfW6Ax0++zn4A2b3k2Cf8IFc903UkNhkvlXmQmr6fLmSbQaZIDFVbrDf7
         tJDg==
X-Gm-Message-State: AOAM533+Fy0PVbkYgpWGgJtD37j4bjtLv+mji/fUaw9HQHykBgt2VdZe
        ElxXQ6WIjDVbrUunl1N8mN0C9T3KE10iHA==
X-Google-Smtp-Source: ABdhPJwKmmjP4pd9sA9tjR2/ScYq3sGmtX9vWhgQjNflbjsCxPsKiictYttp6KRG05oAopieT+rW4g==
X-Received: by 2002:aca:3fd7:: with SMTP id m206mr16918071oia.162.1636045850000;
        Thu, 04 Nov 2021 10:10:50 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a13sm1599171oiy.9.2021.11.04.10.10.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 10:10:49 -0700 (PDT)
Subject: Re: [PATCH v5 00/14] last set for add_disk() error handling
To:     Luis Chamberlain <mcgrof@kernel.org>, martin.petersen@oracle.com
Cc:     miquel.raynal@bootlin.com, hare@suse.de, jack@suse.cz, hch@lst.de,
        song@kernel.org, dave.jiang@intel.com, richard@nod.at,
        vishal.l.verma@intel.com, penguin-kernel@i-love.sakura.ne.jp,
        tj@kernel.org, ira.weiny@intel.com, vigneshr@ti.com,
        dan.j.williams@intel.com, ming.lei@redhat.com, efremov@linux.com,
        linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20211103230437.1639990-1-mcgrof@kernel.org>
 <163602655191.22491.10844091970007142957.b4-ty@kernel.dk>
 <4764286a-99b4-39f7-ce5c-9e88cee1a538@kernel.dk>
 <YYQTYctDjaxU2tkQ@bombadil.infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <377b472e-b788-df12-f9cd-7fc7b0887dc0@kernel.dk>
Date:   Thu, 4 Nov 2021 11:10:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YYQTYctDjaxU2tkQ@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/21 11:07 AM, Luis Chamberlain wrote:
> On Thu, Nov 04, 2021 at 06:53:34AM -0600, Jens Axboe wrote:
>> On 11/4/21 5:49 AM, Jens Axboe wrote:
>>> On Wed, 3 Nov 2021 16:04:23 -0700, Luis Chamberlain wrote:
>>>> Jens,
>>>>
>>>> as requested, I've folded all pending changes into this series. This
>>>> v5 pegs on Christoph's reviewed-by tags and since I was respinning I
>>>> modified the ataprobe and floppy driver changes as he suggested.
>>>>
>>>> I think this is it. The world of floppy has been exciting for v5.16.
>>>>
>>>> [...]
>>>
>>> Applied, thanks!
>>>
>>> [01/14] nvdimm/btt: use goto error labels on btt_blk_init()
>>>         commit: 2762ff06aa49e3a13fb4b779120f4f8c12c39fd1
>>> [02/14] nvdimm/btt: add error handling support for add_disk()
>>>         commit: 16be7974ff5d0a5cd9f345571c3eac1c3f6ba6de
>>> [03/14] nvdimm/blk: avoid calling del_gendisk() on early failures
>>>         commit: b7421afcec0c77ab58633587ddc29d53e6eb95af
>>> [04/14] nvdimm/blk: add error handling support for add_disk()
>>>         commit: dc104f4bb2d0a652dee010e47bc89c1ad2ab37c9
>>> [05/14] nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
>>>         commit: accf58afb689f81daadde24080ea1164ad2db75f
>>> [06/14] nvdimm/pmem: use add_disk() error handling
>>>         commit: 5a192ccc32e2981f721343c750b8cfb4c3f41007
>>> [07/14] z2ram: add error handling support for add_disk()
>>>         commit: 15733754ccf35c49d2f36a7ac51adc8b975c1c78
>>> [08/14] block/sunvdc: add error handling support for add_disk()
>>>         commit: f583eaef0af39b792d74e39721b5ba4b6948a270
>>> [09/14] mtd/ubi/block: add error handling support for add_disk()
>>>         commit: ed73919124b2e48490adbbe48ffe885a2a4c6fee
>>> [10/14] ataflop: remove ataflop_probe_lock mutex
>>>         commit: 4ddb85d36613c45bde00d368bf9f357bd0708a0c
>>> [11/14] block: update __register_blkdev() probe documentation
>>>         commit: 26e06f5b13671d194d67ae8e2b66f524ab174153
>>> [12/14] ataflop: address add_disk() error handling on probe
>>>         commit: 46a7db492e7a27408bc164cbe6424683e79529b0
>>> [13/14] floppy: address add_disk() error handling on probe
>>>         commit: ec28fcc6cfcd418d20038ad2c492e87bf3a9f026
>>> [14/14] block: add __must_check for *add_disk*() callers
>>>         commit: 1698712d85ec2f128fc7e7c5dc2018b5ed2b7cf6
>>
>> rivers/scsi/sd.c: In function ‘sd_probe’:
>> drivers/scsi/sd.c:3573:9: warning: ignoring return value of ‘device_add_disk’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
>>  3573 |         device_add_disk(dev, gd, NULL);
>>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/sr.c: In function ‘sr_probe’:
>> drivers/scsi/sr.c:731:9: warning: ignoring return value of ‘device_add_disk’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
>>   731 |         device_add_disk(&sdev->sdev_gendev, disk, NULL);
>>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>>
>> Dropping the last two patches...
> 
> Martin K Peterson has the respective patches needed queued up on his tree
> for v5.16:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-staging&id=e9d658c2175b95a8f091b12ddefb271683aeacd9
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=5.16/scsi-staging&id=2a7a891f4c406822801ecd676b076c64de072c9e
> 
> Would the last patch be sent once that gets to Linus?

But that dependency wasn't clear in the patches posted, and it leaves me
wondering if there are others? I obviously can't queue up a patch that
adds a must_check to a function, when we still have callers that don't
properly check it.

That should have been made clear, and that last patch never should've
been part of the series. Please send it once Linus's tree has all
callers checking the result.

> Also curious why drop the last two patches instead just the last one for
> now?

Sorry, meant just the last one.

-- 
Jens Axboe

