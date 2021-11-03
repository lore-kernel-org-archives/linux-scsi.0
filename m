Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B0DC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 19:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB85060FC2
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 19:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhKCT3m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 15:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhKCT3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 15:29:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879A3C061203
        for <linux-scsi@vger.kernel.org>; Wed,  3 Nov 2021 12:27:03 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id s13so5204142wrb.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Nov 2021 12:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=n9eZm4ZLjJ18S7/RZOpREFC5R9Pnj2s1MfiRIP09vP4=;
        b=q2GIFhHVe5lThDSHIlbvG+djmqWJ8UVbfdOb6L8YSOQYNT2e+uPJr1W8EFCfyq4a6l
         J5suBfUP2J04f86osP7IsykSpLuHkRXY+9HLIK99h4lVxWMv+6f3bTadjKLStPPhILTM
         w5TNTki0SM8UzMsxyf/4KVQnDmem8qoz/n0g6RsSr7hMn/WnvmI+twqpsWQaWEaL15re
         H1k1+79yO5hsR4iag2207tH+XRlxr37rlofcKcWxtelSCp9KHNK9IDne4I2q8id5wGWm
         FFtIcx2UhgbG41e+6Sv31zAMpJMPyBRmWCon3LA0tK4d5QNM1ScfqoFmXflbYz8cgoXz
         nWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=n9eZm4ZLjJ18S7/RZOpREFC5R9Pnj2s1MfiRIP09vP4=;
        b=7dHSvaT9a9bqxfWOtm7daW9Rg0CCCHRs7XUEL14OO7WLquMxT3EJBqTYbLZe+31Thd
         iFDB/lFRQ5454Y5edA0AkVgzjzMKI4vTjvCfWin3BMlCKqEAtM+KETGMTiS3cxSMiY8t
         8uVQJYj037lPf2AZw/5CwciW06GR7fhY2v50tYIyvT/TLpR/81OvhIi3mld8Ll8OsVfi
         L6Dopv2IIbD/cen9da0YO+0+7Y2t5yfhHMnsmNWyh3SEKLTN+rkHD13+IdTAntjrJzDr
         H3wgo+bzkWnBpP3mLZJ47SAr1lKA5uclk0vwHwu9zjb2UrWm2cfz8YKy4/JibcII8Bm/
         Xd0w==
X-Gm-Message-State: AOAM5329E7hUtHjpxrpUhQkZO7hLg2HvCScUO8emjn6026uu29SUoTEL
        rYUZXuCILPKVYpEN9Z/YwQFU4g==
X-Google-Smtp-Source: ABdhPJwm0J2qtE+FE/PUvTFUO5lV8Xw5XsKj4sTwM2pR0jbx5CoUJ/9kjWwlg9/c73FShGDpL5/+Cg==
X-Received: by 2002:a05:6000:1841:: with SMTP id c1mr24598385wri.425.1635967621989;
        Wed, 03 Nov 2021 12:27:01 -0700 (PDT)
Received: from localhost (5.186.126.13.cgn.fibianet.dk. [5.186.126.13])
        by smtp.gmail.com with ESMTPSA id 9sm3893755wry.0.2021.11.03.12.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 12:27:01 -0700 (PDT)
Date:   Wed, 3 Nov 2021 20:27:00 +0100
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
Message-ID: <20211103192700.clqzvvillfnml2nu@mpHalley-2>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
 <20211029081447.ativv64dofpqq22m@ArmHalley.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211029081447.ativv64dofpqq22m@ArmHalley.local>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29.10.2021 10:14, Javier González wrote:
>On 29.10.2021 00:21, Chaitanya Kulkarni wrote:
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
>
>Here you have a Doogle for end of next week and the week after OCP.
>Please fill it out until Wednesday. I will set up a call with the
>selected slot:
>
>    https://doodle.com/poll/r2c8duy3r8g88v8q?utm_source=poll&utm_medium=link
>
>Thanks,
>Javier

I sent the invite for the people that signed up into the Doodle. The
call will take place on Monday November 15th, 17.00-19.00 CET. See the
list of current participants below. If anyone else wants to participate,
please send me a note and I will extend the invite.

   Johannes.Thumshirn@wdc.com
   Vincent.fu@samsung.com
   a.dawn@samsung.com
   a.manzanares@samsung.com
   bvanassche@acm.org
   himanshu.madhani@oracle.com
   joshi.k@samsung.com
   kch@nvidia.com
   martin.petersen@oracle.com
   nj.shetty@samsung.com
   selvakuma.s1@samsung

Javier
