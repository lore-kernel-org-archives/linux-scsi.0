Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57209C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 08:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E52861157
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 08:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbhJ2ISk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 04:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhJ2ISk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 04:18:40 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A40C061570
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 01:16:11 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id y84-20020a1c7d57000000b00330cb84834fso2601480wmc.2
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 01:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+A2GKLI9DhSLswhTJfVeFD3Ahs1nltZEg2bN0VulWy8=;
        b=hB5kBjOFs7MAfzwDO189P01WGd8nmfCbIqwRoeiF8+P9jSilK5Ez2qgyB3KnFevKwJ
         TWly59hVZD0G5qEZgrCMpQGbFZhobs1K79vYUOXDakL0c6nyAlZrsp9vK0wRggm0C7W9
         BUdyaxSMG85kJqmItNf8MSrY9B57NfdmTAvPPmKYzlNBhSMWZrtv60wH54oIyiubli04
         8msCNHWgwQjV8LnkDxLvhZo4qH8dAQ18dVynKzkSxeDydInlUsCgEDMZ7Y42W2hzeziN
         oiimlNWQJQvNEPrJlpq22VXTHmp2rXJo1w1IEQjELbU6qgpKqxPzmxMI440Y92qkJ8Z9
         Ab0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+A2GKLI9DhSLswhTJfVeFD3Ahs1nltZEg2bN0VulWy8=;
        b=BH2esrta1pXjHoDEBmltWn9PgrGHJlV/Vcwb/215QbrCca1bNO1TZ3BPJNfLWPTI7X
         bEJ1iwMhOxOJP8Dv5Ourz/Z6QJghtQtmGUYd9+BdM0za3qvSNv/DFC6NnQc3wPM0Dnbv
         q2QlwjOvlBrLvH43KURWFqWqT/SqmiUHRgguBK7Rl1C0LoHe15RQlt1y63jo6cs5OTNO
         ZBMCBzL9y/X0/oOfBaFgAY7vAd3ucm06UPnJq/pZMtAA5wDktgBYymnI9JWm5fb8/XtH
         o+ClN+e7mgIlVPIQon3IcyQjadtK9ZhBtumryabRRGBIliJdkEBby56t3zRb7H+Qv600
         vEzw==
X-Gm-Message-State: AOAM532LmgUa/EBJa6rTmXku96A9PpJq1VGC3pavj4khsA0sObZSi/MK
        hnjuF3EauPR+XGrMSZmfGkj/GQ==
X-Google-Smtp-Source: ABdhPJxEYoo56lOQFgqbHz0cJdbenOnmGMwhPleHbo+aaGvg342CUYI8ey6L6o22+/T2Kqj82W+gKA==
X-Received: by 2002:a1c:2507:: with SMTP id l7mr10125921wml.144.1635495370273;
        Fri, 29 Oct 2021 01:16:10 -0700 (PDT)
Received: from localhost (5.186.124.144.cgn.fibianet.dk. [5.186.124.144])
        by smtp.gmail.com with ESMTPSA id i3sm7380661wmq.18.2021.10.29.01.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 01:16:09 -0700 (PDT)
Date:   Fri, 29 Oct 2021 10:16:09 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20211029081609.obt7ssqxd3aotnum@ArmHalley.local>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
 <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29.10.2021 07:51, Hannes Reinecke wrote:
>On 10/29/21 2:21 AM, Chaitanya Kulkarni wrote:
>>On 10/7/21 11:49 PM, Javier González wrote:
>>>External email: Use caution opening links or attachments
>>>
>>>
>>>On 06.10.2021 10:33, Bart Van Assche wrote:
>>>>On 10/6/21 3:05 AM, Javier González wrote:
>>>>>I agree that the topic is complex. However, we have not been able to
>>>>>find a clear path forward in the mailing list.
>>>>
>>>>Hmm ... really? At least Martin Petersen and I consider device mapper
>>>>support essential. How about starting from Mikulas' patch series that
>>>>supports the device mapper? See also
>>>>https://lore.kernel.org/all/alpine.LRH.2.02.2108171630120.30363@file01.intranet.prod.int.rdu2.redhat.com/
>>>>
>>
>>When we add a new REQ_OP_XXX we need to make sure it will work with
>>device mapper, so I agree with Bart and Martin.
>>
>>Starting with Mikulas patches is a right direction as of now..
>>
>>>
>>>Thanks for the pointers. We are looking into Mikulas' patch - I agree
>>>that it is a good start.
>>>
>>>>>What do you think about joining the call to talk very specific next
>>>>>steps to get a patchset that we can start reviewing in detail.
>>>>
>>>>I can do that.
>>>
>>>Thanks. I will wait until Chaitanya's reply on his questions. We will
>>>start suggesting some dates then.
>>>
>>
>>I think at this point we need to at least decide on having a first call
>>focused on how to proceed forward with Mikulas approach  ...
>>
>>Javier, can you please organize a call with people you listed in this
>>thread earlier ?
>>
>Also Keith presented his work on a simple zone-based remapping block 
>device, which included an in-kernel copy offload facility.
>Idea is to lift that as a standalone patch such that we can use it a 
>fallback (ie software) implementation if no other copy offload 
>mechanism is available.
>

I believe this is in essence what we are trying to convey here: a
minimal patchset that enables Simple Copy and the infra around to extend
copy-offload use-cases.

I look forward to hear Keith's ideas around this!

Javier
