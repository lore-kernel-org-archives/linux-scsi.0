Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F22C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 06:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9ADB860EFE
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Oct 2021 06:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbhJHGvZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Oct 2021 02:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhJHGvY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Oct 2021 02:51:24 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADDDC061755
        for <linux-scsi@vger.kernel.org>; Thu,  7 Oct 2021 23:49:30 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id g15-20020a9d128f000000b0054e3d55dd81so5424464otg.12
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 23:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20210112.gappssmtp.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=kWdIriwExu4LlJQU964sGxqqg1QcebE7i1wdIsD6J4k=;
        b=F+pf4LO3Ma1Iz4xpY8hOLtbitkZ9Y1ZMh2/WQR5vW7L5b4Et5pUSRwwEm7QlaDDzzo
         3CF0cMPwrYUL1J2zBX3ZIQFeCbW0W7XDqfGAilKWkev/u5RJLKdP0wr8YNAZGWxruu7v
         EYZCcBGNPQ3qRSOYQMoM+XgtM9Jrz7UVm3HS7aGiXqF+cOXW7bdwdH62Oez9VVr3tvFt
         Dbr3MdPy/G3T8jqF5BXhZ31vhH9VVxGRbzfbhgWI0A2uUcUR3XHhQioA9Z38etszvG1J
         9YTr1PiA28SNtWLMWdS8tsYOugthDTnwVvgvu07jlWHuW/Zk+Xaz+bF0DpC2FVmG6pZc
         5aqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=kWdIriwExu4LlJQU964sGxqqg1QcebE7i1wdIsD6J4k=;
        b=Uv4sMfsUcczAJtDvlzeTmPLTJKlF6j4qLf5ZkKSyrsrMoJs4+wy1unuR6454ikT4X9
         zGm6G5phTGlUij2lkLiRvXroQj0Fk1ZmCcopES4GwFIfx9DZUa3FnQHaJIQZcg5XY8vi
         aTCinudewS/oHGYPd7PxaanbmHJIH2ej8cNwe/VZqGgYXy5Dg3ikGoOqFa2p5VrF7zei
         4BDXZrSBeWKsXdtdVdrjMwvugl6/T3AwmNYUpqEWB7uOv5dJva/s3PjlDoHnZXsJrmxM
         qR2y1FnbXuelpNO3WaXx8Yk4b/SiiipPHY8HPDV2fiImQfpbEU3uMHQ4q/a213Q+n4su
         NZ9Q==
X-Gm-Message-State: AOAM532DhSc7+8txsLcDfZLr/YOrKLw8QIlMd8dFSxaIIjfsYMgX75PA
        mEmSM5CZWN6J1JRexBTwKPqUcA==
X-Google-Smtp-Source: ABdhPJy5QnapeLgcGWJ6jvzl+N+Y+bCEojADkeyAUGfRJJj/bp34o8DSnXn50k5+/PJLlpeQWlsNqw==
X-Received: by 2002:a9d:7681:: with SMTP id j1mr7204557otl.367.1633675769488;
        Thu, 07 Oct 2021 23:49:29 -0700 (PDT)
Received: from localhost (96.44.142.75.adsl.inet-telecom.org. [96.44.142.75])
        by smtp.gmail.com with ESMTPSA id k9sm364371otr.66.2021.10.07.23.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 23:49:29 -0700 (PDT)
From:   "Javier =?utf-8?B?R29uesOhbGV6?=" <javier@javigon.com>
X-Google-Original-From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
Date:   Fri, 8 Oct 2021 08:49:25 +0200
To:     Bart Van Assche <bvanassche@acm.org>
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
        Vincent Fu <vincent.fu@samsung.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06.10.2021 10:33, Bart Van Assche wrote:
>On 10/6/21 3:05 AM, Javier González wrote:
>>I agree that the topic is complex. However, we have not been able to
>>find a clear path forward in the mailing list.
>
>Hmm ... really? At least Martin Petersen and I consider device mapper 
>support essential. How about starting from Mikulas' patch series that 
>supports the device mapper? See also https://lore.kernel.org/all/alpine.LRH.2.02.2108171630120.30363@file01.intranet.prod.int.rdu2.redhat.com/

Thanks for the pointers. We are looking into Mikulas' patch - I agree
that it is a good start.

>>What do you think about joining the call to talk very specific next
>>steps to get a patchset that we can start reviewing in detail.
>
>I can do that.

Thanks. I will wait until Chaitanya's reply on his questions. We will
start suggesting some dates then.

Thanks,
Javier
