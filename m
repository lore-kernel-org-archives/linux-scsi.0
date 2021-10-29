Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31557C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 08:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B00661157
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 08:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhJ2IRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 04:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232310AbhJ2IRS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 04:17:18 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFE5C061714
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 01:14:50 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id i5so7244792wrb.2
        for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2021 01:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8ddftgpK0LDx+G+FjrkBslhvyIqXHl28zfgWlGOCfAA=;
        b=ZvbA6OirgjAS7+trJNLUfzUzxnDghd5zTvC77XLYSKiUJni+0fhVC882L/ZVeGk6nP
         /kqxXGYeIC8ozy0ThUYCWPYJj/TnAzJyT1FoDRlAW81PXLjx1H4dovtDjSUYxLWm89Fm
         QeYR518/SaS27GmrZdJnfY4dbWaImq1x9hLn6jWFVn9mzRPWjglKS8+xiGDRwDWz/iYO
         zYrVWby82S3kK8LXamSjv0A8Cb66H4Oml/LfuIsvJZgM75kD+NlXEN9xPLTHLb4g/Maz
         3JCfMkKUJr7mv7erdqTMwWKCCXCZ8zHBaXoAeoSql0VKFMra1tHxcXHRWOHY5d7i4HUp
         zSSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8ddftgpK0LDx+G+FjrkBslhvyIqXHl28zfgWlGOCfAA=;
        b=Dr0KSXZn+1XLdzZKM9cTSNJzezYqRH7PnFoGj8G5O2QHzmTCJLK2icuBlggONPRO5w
         DZF7iIcjyr4dO+My/nANzBeiAeuoYqcWXUPyRFI+qNjptyYT2oujMUZo0gNQTN6H8jJU
         gvXDoA/MeI05gflpXkKb/Q0y6Ik16c/F81WxZGIFzek60WiEuAzCWHh9z5Be5w+YuUAy
         +Mu7zX1Zi8kJrPptH+JE+wj1mtql3njG+r8Rv7VHPooA7RiQBrmJvSiG8ECD89ZNgWCt
         SmUOhAzpKloq9jHTZmyN09Qwe4t01IT4fFBaxnK5wzjHCVFkUFdVewwkqRoUp+1/l8zC
         jBCg==
X-Gm-Message-State: AOAM531n/uMNsxc/qHYJYP04prngyeg27oZhor/pjV3ZtU7Mly8TMS3Z
        AzVY8JJtfxO097aWS92UbruePQ==
X-Google-Smtp-Source: ABdhPJz4KKl/vCIv4EZQxDSYhXgl6hLs1xW5oRUFqmNOfzBiIlxs2qrs7OEPigr3oNUptn2YXM3COQ==
X-Received: by 2002:adf:e387:: with SMTP id e7mr1473005wrm.412.1635495289096;
        Fri, 29 Oct 2021 01:14:49 -0700 (PDT)
Received: from localhost (5.186.124.144.cgn.fibianet.dk. [5.186.124.144])
        by smtp.gmail.com with ESMTPSA id s3sm8001684wmh.30.2021.10.29.01.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 01:14:48 -0700 (PDT)
Date:   Fri, 29 Oct 2021 10:14:47 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
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
        "hare@suse.de" <hare@suse.de>,
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
Message-ID: <20211029081447.ativv64dofpqq22m@ArmHalley.local>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29.10.2021 00:21, Chaitanya Kulkarni wrote:
>On 10/7/21 11:49 PM, Javier González wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On 06.10.2021 10:33, Bart Van Assche wrote:
>>> On 10/6/21 3:05 AM, Javier González wrote:
>>>> I agree that the topic is complex. However, we have not been able to
>>>> find a clear path forward in the mailing list.
>>>
>>> Hmm ... really? At least Martin Petersen and I consider device mapper
>>> support essential. How about starting from Mikulas' patch series that
>>> supports the device mapper? See also
>>> https://lore.kernel.org/all/alpine.LRH.2.02.2108171630120.30363@file01.intranet.prod.int.rdu2.redhat.com/
>>>
>
>When we add a new REQ_OP_XXX we need to make sure it will work with
>device mapper, so I agree with Bart and Martin.
>
>Starting with Mikulas patches is a right direction as of now..
>
>>
>> Thanks for the pointers. We are looking into Mikulas' patch - I agree
>> that it is a good start.
>>
>>>> What do you think about joining the call to talk very specific next
>>>> steps to get a patchset that we can start reviewing in detail.
>>>
>>> I can do that.
>>
>> Thanks. I will wait until Chaitanya's reply on his questions. We will
>> start suggesting some dates then.
>>
>
>I think at this point we need to at least decide on having a first call
>focused on how to proceed forward with Mikulas approach  ...
>
>Javier, can you please organize a call with people you listed in this
>thread earlier ?

Here you have a Doogle for end of next week and the week after OCP.
Please fill it out until Wednesday. I will set up a call with the
selected slot:

     https://doodle.com/poll/r2c8duy3r8g88v8q?utm_source=poll&utm_medium=link

Thanks,
Javier

