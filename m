Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C23C001DF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 22:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346638AbjJSWkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Oct 2023 18:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbjJSWku (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2023 18:40:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F42124;
        Thu, 19 Oct 2023 15:40:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB89CC433C8;
        Thu, 19 Oct 2023 22:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697755248;
        bh=QfTE4cUL4mwaaLPvxL0PL45XS44NzfljHt3kH5CTJGE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=RMBzEXjRTclL7lVdSbp6YvoCjsj6TKlg0HvBQToQMPw1OAml4ShpUAykVfRVIlT98
         CY20I8kMpqqfMU/9ytXrWTDCA2DKR2WLz3mW74uyNTQE5ODGgrxFRvgkXULr8hzYeX
         WTHFUcBASkfJu11+JcXLl1U8l5kUdz+p4Sf8NtMiWz9xfYDegyATWthXdEMkdLyG/s
         9gop+/tOFikgY5iXAfChufK4Q6CXBj5g5sHSqjKX13zCnA106xxRQxlc73auxbuq/Z
         koXoMrUbF/HTyna0jFukE6gPLvTlXimvDDARM50ekKvUSHCdeMZVIfSZ3RW7nw4IIP
         ImlgpIM1FAb8Q==
Message-ID: <58ec6750-5582-4775-a38f-7d56d761136c@kernel.org>
Date:   Fri, 20 Oct 2023 07:40:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/14] Pass data temperature information to SCSI disk
 devices
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>
References: <20231017204739.3409052-1-bvanassche@acm.org>
 <3f3c2289-3185-4895-92cb-0692e3ca9ebc@kernel.dk>
 <e8b49fac-77ce-4b61-ac4d-e4ace58d8319@acm.org>
 <e2e56cdf-0cfe-4c5b-991f-ea6a80452891@kernel.org>
 <7908138a-3ae5-4ff5-9bda-4f41e81f2ef1@acm.org>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <7908138a-3ae5-4ff5-9bda-4f41e81f2ef1@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20/23 01:48, Bart Van Assche wrote:
> On 10/18/23 17:33, Damien Le Moal wrote:
>> On 10/19/23 04:34, Bart Van Assche wrote:
>  >> On 10/18/23 12:09, Jens Axboe wrote:
>>>> I'm also really against growing struct bio just for this. Why is patch 2
>>>> not just using the ioprio field at least?
>>>
>>> Hmm ... shouldn't the bits in the ioprio field in struct bio have the
>>> same meaning as in the ioprio fields used in interfaces between user
>>> space and the kernel? Damien Le Moal asked me not to use any of the
>>> ioprio bits passing data lifetime information from user space to the kernel.
>>
>> I said so in the context that if lifetime is a per-inode property, then ioprio
>> is the wrong interface since the ioprio API is per process or per IO. There is a
>> mismatch.
>>
>> One version of your patch series used fnctl() to set the lifetime per inode,
>> which is fine, and then used the BIO ioprio to pass the lifetime down to the
>> device driver. That is in theory a nice trick, but that creates conflicts with
>> the userspace ioprio API if the user uses that at the same time.
>>
>> So may be we should change bio ioprio from int to u16 and use the freedup u16
>> for lifetime. With that, things are cleanly separated without growing struct bio.
> 
> Hmm ... I think that bi_ioprio has been 16 bits wide since the 
> introduction of that data structure member in 2016?

My bad. struct bio->bi_ioprio is an unsigned short. I got confused with the user
API and kernel functions using an int in many places. We really should change
the kernel functions to use unsigned short for ioprio everywhere.

>>> Is it clear that the size of struct bio has not been changed because the
>>> new bi_lifetime member fills a hole in struct bio?
>>
>> When the struct is randomized, holes move or disappear. Don't count on that...
> 
> We should aim to maximize performance for users who do not use data 
> structure layout randomization.
> 
> Additionally, I doubt that anyone is using full structure layout 
> randomization for SCSI devices. No SCSI driver has any 
> __no_randomize_layout / __randomize_layout annotations although I'm sure 
> there are plenty of data structures in SCSI drivers for which the layout 
> matters.

Well, if Jens is OK with adding another "unsigned short bi_lifetime" in a hole
in struct bio, that's fine with me. Otherwise, we are back to discussing how to
pack bi_ioprio in a sensible manner so that we do not create a mess between the
use cases and APIs:
1) inode based lifetime with FS setting up the bi_ioprio field
2) Direct IOs to files of an FS with lifetime set by user per IO (e.g.
aio/io_uring/ioprio_set()) and/or fcntl()
3) Direct IOs to raw block devices with lifetime set by user per IO (e.g.
aio/io_uring/ioprio_set())

Any of the above case should also allow using ioprio class/level and CDL hint.

I think the most problematic part is (2) when lifetime are set with both fcntl()
and per IO: which lifetime is the valid one ? The one set with fcntl() or the
one specified for the IO ? I think the former is the one we want here.

If we can clarify that, then I guess using 3 or 4 bits from the 10 bits ioprio
hint should be OK. That would  give you 7 or 15 lifetime values. Enough no ?

-- 
Damien Le Moal
Western Digital Research

