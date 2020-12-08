Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BD3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CE77239D0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgLHMXb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729486AbgLHMXb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 07:23:31 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1A4C0613D6
        for <linux-scsi@vger.kernel.org>; Tue,  8 Dec 2020 04:22:50 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id h16so6036356edt.7
        for <linux-scsi@vger.kernel.org>; Tue, 08 Dec 2020 04:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mimyofEa+0whU409Dhp0a+YV5b97sukKj8gfG9Rbmic=;
        b=O0MKn6nsnZaleEs/kNELsIh8dmH/kUILor5blbkmcjPeH/9Ep6OyKVm0KhMgD3NGd3
         jiS2xaM6anmzo4ZJoxWWeypRd3TPX9i1pbDK1fn7CHS4MoXi73uI9bkKwiK46bx0/aYj
         QiUgUp9GM2g/V0rTnnXbSt39JqhI5CnWjpjP7roaLEcLPuRXAYMc/oC98jZUIwDawmI9
         TuWYO0e8QQghyUuybvSDRbNtqa5oVqU+WzjvfKefSY9LEdJhMLfaBcg69YT58rpPi73N
         6QDuFT3wPIMhu+1PtBLD6TPuURzIfM/B6NmbuJq0Jt0I9O+0ZRmUCz9xhCfcsFBDaruc
         p2aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mimyofEa+0whU409Dhp0a+YV5b97sukKj8gfG9Rbmic=;
        b=bW7ZoLiBM/LaUWGyUIVnkdTFM6YbdHiXAzubQUt++WWX/o2Sie7RnFW6+3XOETopqd
         O1MOjfd8W9bgdiSVX2sM85k1NtzHw6lrgD7+evG4TvM+BdwN4KIS06Lb91yhD90sWpaj
         0gEsXp+sULQsE7r3l/eUIlE2uQBktzgNFGti+FgFscB/QphUtXO9sAGeh45mn4ZDKg/L
         BcqgbxYYgCjA6Y01jo09LmeMa3BPrn6+26nd3HMeYE4jmQN8AgZPcZgX9tz3XrfPEM17
         iv0LkkP4gEQFqZ2sjxi6GibMzhKNi3pZX+7C5FOr3h8maDhW+Ythd+7lYekev1Rjr8Wv
         w7ZA==
X-Gm-Message-State: AOAM530YZ0YR/j8Kyo44/2BDwcSZzg8jzFKDIU3ocz6rKrFW+73Thf1b
        e7JuzSU5S8ls+ZRfg+2PkGeFLw==
X-Google-Smtp-Source: ABdhPJwDxIoRMy+9VbYFQ3igoSIhbhtPBIxA8vjX9L86uM4LXFP5Wttpcb3/4YB/UuHFCIPdaYrkmA==
X-Received: by 2002:a50:ccdb:: with SMTP id b27mr18839271edj.20.1607430169696;
        Tue, 08 Dec 2020 04:22:49 -0800 (PST)
Received: from localhost (5.186.124.214.cgn.fibianet.dk. [5.186.124.214])
        by smtp.gmail.com with ESMTPSA id x15sm16783915edj.91.2020.12.08.04.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 04:22:49 -0800 (PST)
Date:   Tue, 8 Dec 2020 13:22:48 +0100
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier@javigon.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "selvajove@gmail.com" <selvajove@gmail.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
Message-ID: <20201208122248.utv7pqthmmn6uwv6@mpHalley>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
 <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
 <20201207192453.vc6clbdhz73hzs7l@mpHalley>
 <SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08.12.2020 08:40, Johannes Thumshirn wrote:
>On 07/12/2020 20:27, Javier González wrote:
>> Good point. We can share some performance data on how Simple Copy scales
>> in terms of bw / latency and the CPU usage. Do you have anything else in
>> mind?
>>
>
>With an emulation in the kernel, we could make the usd "backend"
>implementation configurable. So if the emulation is faster, users can select
>the emulation, if the device is faster then the device.
>
>Kind of what the crypto and raid code do as well.

Good idea. Are you thinking of a sysfs entry to select the backend?
>
>I'm really interested in this work, as BTRFS relocation/balance will have
>potential benefits, but we need to get it right.

Agree. We will post a V3 with emulation and addressing other comments.
We can take it from there. If you have comments on V2, please send them
our way and we will take them in.
