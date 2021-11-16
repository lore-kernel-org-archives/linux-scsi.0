Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EFEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 17:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B910E61545
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 17:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239276AbhKPSCi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 13:02:38 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:41980 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239160AbhKPSCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 13:02:38 -0500
Received: by mail-pf1-f172.google.com with SMTP id g19so94720pfb.8;
        Tue, 16 Nov 2021 09:59:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HMNPM/fgk1MNRXov4s8Yb+E4mhC1XJHGgm4p3VUdnQM=;
        b=pOrvZqwi74KB2+C67j5XXkSPmyNHGS0Z01NZQR4/oOnwKAt60Zw0F3GJnuL1sBzfHN
         dee8j2mL51kNzFG4K6rVXzi986YO7LZo0U+oQxyPsu3SvS5Jp/H0lK6FVJ35/damGmaj
         oMPaFzT5PWqRVH9F8XSxUNs1uXBGk6E7nJrAnZ8bJtpwvT7VI1LvdcGHXebVGuXgPE/H
         AN2J0VL75RVHAm2JZotUArIcdnJ2Ze8GmtjVv9yO02r1X8yM+2cMFq/b5gUnUkw+UOkq
         Z8TE6gsEI/ifezEmbPHVayNlRVg5ZB+iR8Y8Yx841g0gQNU7uNYww3L7wE50K1aHI4ea
         9TUA==
X-Gm-Message-State: AOAM531OxgAmWgjAJFUO1NgB9V7RlNAidf1rrGGEZwJF0FFZNtazO88J
        IOGtt22kKNoJE4Frsdjz1pk=
X-Google-Smtp-Source: ABdhPJzQD9bdY0VMmDxiCswmvq2I7y2fm9Zu6J87Vg5yOKJcwCnM9HD6kc+dZh6uUa9ezmqsxHqBag==
X-Received: by 2002:a63:b241:: with SMTP id t1mr604217pgo.154.1637085580607;
        Tue, 16 Nov 2021 09:59:40 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id v16sm15096386pgo.71.2021.11.16.09.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 09:59:39 -0800 (PST)
Message-ID: <ab4ec640-9a89-ea25-fe68-85bae2ae5d8d@acm.org>
Date:   Tue, 16 Nov 2021 09:59:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Content-Language: en-US
To:     =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>
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
References: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
 <20211029081447.ativv64dofpqq22m@ArmHalley.local>
 <20211103192700.clqzvvillfnml2nu@mpHalley-2>
 <20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/21 05:43, Javier González wrote:
>              - Here, we need copy emulation to support encryption 
> without dealing with HW issues and garbage

Hi Javier,

Thanks very much for having taken notes and also for having shared 
these. Regarding the above comment, after the meeting I learned that the 
above is not correct. Encryption in Android is LBA independent and hence 
it should be possible to offload F2FS garbage collection in Android once 
the (UFS) storage controller supports this.

For the general case, I propose to let the dm-crypt driver decide 
whether or not to offload data copying since that driver knows whether 
or not data copying can be offloaded.

Thanks,

Bart.
