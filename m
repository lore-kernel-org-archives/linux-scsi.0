Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F53C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 16:21:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77BE9611C9
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Nov 2021 16:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhKSQY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Nov 2021 11:24:27 -0500
Received: from mail-pl1-f182.google.com ([209.85.214.182]:42860 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhKSQY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2021 11:24:27 -0500
Received: by mail-pl1-f182.google.com with SMTP id u17so8495843plg.9;
        Fri, 19 Nov 2021 08:21:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dYLRPwJpMIma+7I/gXS8Fe5+Xg8Jtu68cLUUk/7i+NA=;
        b=6JwWElR7M04LaPrvrjcIlcqjJvIPzSPTW0U+mGcjYK4Q8carsl9+n8MBGqLX+JRI3I
         HqcRv5ZMmIXguaQPAi+PApfE1YHTpIYgwMZ3ETtjzEVWZllkCjUMM60Cz+2vFEha1Uqq
         I0Ls5mWMiyKUyh+7y+NREdXncwas7R+uSNjE5SdiFL4mtPMG9+/u3Yu6WjWtkoVITCa8
         DOz/DODv6oAFY7PCVbFJvOXA1YheQmJ+hysGdZ4T4UyE/x/TF1CaCDzmE07hQIxaZ8/B
         SB9S9xnEcnZdh9E7ouA/KPYVjLXTjNwLG8+IKgkooBR5AFzxoNSvR+ENIt0a44LOchej
         jLjA==
X-Gm-Message-State: AOAM532NQpbxSa5P5TQrnPthgRpICRdQylS16gxRCiYNEpfMCpOXpx5N
        dNADz8PQ8L4gIgcIEEmjzOU=
X-Google-Smtp-Source: ABdhPJw16jjqfIprCHt2mG+Ksck30kqntK4sVEg0T0pyn+4kYe1d4XjIzZ1UNiSmcyxOlOBtUI890Q==
X-Received: by 2002:a17:90a:f00e:: with SMTP id bt14mr927761pjb.219.1637338884999;
        Fri, 19 Nov 2021 08:21:24 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j1sm172775pfu.47.2021.11.19.08.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 08:21:24 -0800 (PST)
Message-ID: <bbe942b4-3239-6c54-2e16-431ac8056afa@acm.org>
Date:   Fri, 19 Nov 2021 08:21:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>
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
 <CA+1E3rJRT+89OCyqRtb5BFbez0BfkKvCGijd=nObMEB3_v6MyA@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CA+1E3rJRT+89OCyqRtb5BFbez0BfkKvCGijd=nObMEB3_v6MyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/21 02:47, Kanchan Joshi wrote:
> Given the multitude of things accumulated on this topic, Martin
> suggested to have a table/matrix.
> Some of those should go in the initial patchset, and the remaining are
> to be staged for subsequent work.
> Here is the attempt to split the stuff into two buckets. Please change
> if something needs to be changed below.
> 
> 1. Driver
> *********
> Initial: NVMe Copy command (single NS)
> Subsequent: Multi NS copy, XCopy/Token-based Copy
> 
> 2. Block layer
> **************
> Initial:
> - Block-generic copy (REQ_OP_COPY), with interface accommodating two block-devs
> - Emulation, when offload is natively absent
> - DM support (at least dm-linear)
> 
> 3. User-interface
> *****************
> Initial: new ioctl or io_uring opcode
> 
> 4. In-kernel user
> ******************
> Initial: at least one user
> - dm-kcopyd user (e.g. dm-clone), or FS requiring GC (F2FS/Btrfs)
> 
> Subsequent:
> - copy_file_range

Integrity support and inline encryption support are missing from the above
overview. Both are supported by the block layer. See also block/blk-integrity.c
and include/linux/blk-crypto.h. I'm not claiming that these should be supported
in the first version but I think it would be good to add these to the above
overview.

Thanks,

Bart.
