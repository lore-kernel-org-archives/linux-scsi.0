Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00262C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:35:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72F06103C
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 08:35:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhJMIhm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:37:42 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46499 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbhJMIhl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Oct 2021 04:37:41 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20211013083536euoutp0109e50be360fbbfcd250bc03eb5b459de~tiiZKVzY22700527005euoutp01E
        for <linux-scsi@vger.kernel.org>; Wed, 13 Oct 2021 08:35:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20211013083536euoutp0109e50be360fbbfcd250bc03eb5b459de~tiiZKVzY22700527005euoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1634114136;
        bh=lEXMQGbCbMscpq5Afgy20WzMWHP7jdEjLxxE5OlTv9w=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=Lrtu5DaW4v3dIKxcvPevjQhUxvpsJLRlXsW4Wnbr84VYuhvGUIDXAfyCHuFq5iwKw
         qpOTfmtjw+Gn3w/3v3tctgsc2kUt6/AU5JZL+GUlfPqpC9URXHugzYODUXMYvQbLcX
         2g/ID1y3UP+e9Ts7OV0Ncv7UISPCqOj3MlNoM45Q=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211013083536eucas1p1a795c57a764df3335f868000c9bd6669~tiiYmAiHG0164501645eucas1p1B;
        Wed, 13 Oct 2021 08:35:36 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id E7.15.45756.85A96616; Wed, 13
        Oct 2021 09:35:36 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211013083535eucas1p13f4ddfc4b6ee1a62c824d48b0cc0e105~tiiYLEzD81511715117eucas1p1f;
        Wed, 13 Oct 2021 08:35:35 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20211013083535eusmtrp1e3e4270a1575147c3e0ee833770dc49b~tiiYKE2KJ2173921739eusmtrp1c;
        Wed, 13 Oct 2021 08:35:35 +0000 (GMT)
X-AuditID: cbfec7f2-7bdff7000002b2bc-16-61669a58817f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 2F.C0.20981.75A96616; Wed, 13
        Oct 2021 09:35:35 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20211013083535eusmtip2ecd856f2ed1ab8f61ba652b25279da00~tiiX7G0Tr2272522725eusmtip2s;
        Wed, 13 Oct 2021 08:35:35 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Wed, 13 Oct 2021 09:35:34 +0100
Date:   Wed, 13 Oct 2021 10:35:33 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
CC:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
        "Kanchan Joshi" <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20211013083533.hhgrkm3lhoytfp3a@mpHalley-2.domain_not_set.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211006100121.2hqfdkyuivzvzd33@mpHalley.domain_not_set.invalid>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIJsWRmVeSWpSXmKPExsWy7djPc7oRs9ISDc53c1qsvtvPZjHtw09m
        i1m3X7NYvD/4mNVi77vZrBaPN/1nstizaBKTxcrVR5ks/nbdY7KYdOgao8XeW9oW85c9Zbfo
        vr6DzWLf673MFsuP/2OymNhxlcni3Kw/bBaH711lsVj9x8Ji5TMmi1f74xxEPS5f8faY2PyO
        3ePy2VKPTas62Tw2L6n3mHxjOaPH7psNbB4zPn1h87h+ZjuTR2/zOzaPj09vsXhse9jL7vF+
        31Wg2tPVHp83yXm0H+hmChCI4rJJSc3JLEst0rdL4MroPu9ecE+y4t9/1wbGVyJdjJwcEgIm
        Ehe/LmLrYuTiEBJYwSjxafZfRpCEkMAXRonmLZkQic+MEh2vn7HAdJx8+pIZIrGcUeJa6zVW
        uKqGUwegMlsZJZadvssG0sIioCrx4OUvVhCbTcBe4tKyW8wgtoiAnsTVWzfYQRqYBTZwSmxa
        tAGsQVjAU2LHhn4mEJtXwF/i6eJZbBC2oMTJmU/A7mAWsJLo/NAENJQDyJaWWP6PAyIsL9G8
        dTbYfE4BP4nm67vZQUokBJQllk/3hfigVmLtsTNgayUElnJJzJ/wkhUi4SJx/eIiZghbWOLV
        8S3sELaMxOnJPSwQDc2MEmfWXGGGcHoYJf5MWsEIscFaou9MDkSDo8T2KQ+ZIcJ8EjfeCkLc
        xicxadt0qDCvREeb0ARGlVlIHpuF5LFZCI/NQvLYAkaWVYziqaXFuempxYZ5qeV6xYm5xaV5
        6XrJ+bmbGIGp9vS/4592MM599VHvECMTB+MhRgkOZiURXsOM1EQh3pTEyqrUovz4otKc1OJD
        jNIcLErivKtmr4kXEkhPLEnNTk0tSC2CyTJxcEo1MCXLzpqz3Cqm+6/Xr8t3/TvrmYvbXdOf
        a0483P2k7Fjwf4NXutccvutv7U4SDJLMmSP0Ji+g2nDlbdbV87JezJlorBf15HMj3+Ku1Qn/
        HgX+OqbA2/PMbUvT169MZx3uNEQ9vPpkQ/aSrfozPf1C+7oKYp5q6+THK/c7z3W9ZXTCWjve
        cfbn+rlMl45zrT0cwFW2MGLuqYLtNzOb71nIxzu3Xlpzr77uZsfOey+5kp4JPbpcmsO1v/Xp
        /whxwzme7Noni2uOLO82OHlI2n+7ke+9MvZ8hnTOj9fefvxnPO3b5D2BXXL8RRkGWd7a2mFp
        FyNbD87J3ap6tvG71TOPrxNehs09pCeSFVtio155SImlOCPRUIu5qDgRAIXemJckBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t/xe7rhs9ISDQ7vU7dYfbefzWLah5/M
        FrNuv2axeH/wMavF3nezWS0eb/rPZLFn0SQmi5WrjzJZ/O26x2Qx6dA1Rou9t7Qt5i97ym7R
        fX0Hm8W+13uZLZYf/8dkMbHjKpPFuVl/2CwO37vKYrH6j4XFymdMFq/2xzmIely+4u0xsfkd
        u8fls6Uem1Z1snlsXlLvMfnGckaP3Tcb2DxmfPrC5nH9zHYmj97md2weH5/eYvHY9rCX3eP9
        vqtAtaerPT5vkvNoP9DNFCAQpWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqk
        b2eTkpqTWZZapG+XoJfRfd694J5kxb//rg2Mr0S6GDk5JARMJE4+fcncxcjFISSwlFFi18Ev
        jBAJGYlPVz6yQ9jCEn+udbFBFH1klFj8vIkJwtkK5OyaAtbBIqAq8eDlL1YQm03AXuLSslvM
        ILaIgJ7E1Vs32EEamAU2cEpsWrSBDSQhLOApsWNDPxOIzSvgL/F08SyoFfuZJTo2/WCFSAhK
        nJz5hAXEZhawkJg5/zzQNg4gW1pi+T8OiLC8RPPW2WDLOAX8JJqv72YHKZEQUJZYPt0X4oNa
        iVf3dzNOYBSZhWToLCRDZyEMnYVk6AJGllWMIqmlxbnpucVGesWJucWleel6yfm5mxiBqWjb
        sZ9bdjCufPVR7xAjEwfjIUYJDmYlEV7DjNREId6UxMqq1KL8+KLSnNTiQ4ymwCCayCwlmpwP
        TIZ5JfGGZgamhiZmlgamlmbGSuK8JkfWxAsJpCeWpGanphakFsH0MXFwSjUwzXKcnt9/9urp
        FfIp8xYvYWI9ovucP8NhyrR7kjIx9cLX7HbOfjStX/VJkFbXjXVbO97Lny6YNq9BjTGSf2lV
        39pvqgufWZy8bGO5KqjUv1Fkxbki/XC/bXmnGNYoruLmCnvZox0574F4y4evJ3an1Z9LDxPe
        3nbu1rIt3D2yc42eXmn4sExZVePLFX2lx1N+adWlZCfUv4ueuVff+Crnr5aDr2bpRGzdY/Wu
        ecHd0sh/F8U/Wm+bpTtli5HjQi07908/V9b2zBNM5QkxKtr99HeueqJjzY6MjbWRqevEP0cs
        Mdx+4pqcS+mWl3efr94+76DhlzjfNcZOc2bIeG7ijDvAtkfQadnTSz7rrGaaP1diKc5INNRi
        LipOBAAGHKBGzgMAAA==
X-CMS-MailID: 20211013083535eucas1p13f4ddfc4b6ee1a62c824d48b0cc0e105
X-Msg-Generator: CA
X-RootMTR: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
        <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
        <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
        <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
        <c1b0f954-0728-e6ab-73ab-7b466a7d2eb7@nvidia.com>
        <20211006100121.2hqfdkyuivzvzd33@mpHalley.domain_not_set.invalid>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Chaitanya,

Did you have a chance to look at the answers below?

I would like to start finding candidate dates throughout the next couple
of weeks.

Thanks,
Javier

On 06.10.2021 12:01, Javier González wrote:
>On 30.09.2021 09:43, Chaitanya Kulkarni wrote:
>>Javier,
>>
>>>
>>>Hi all,
>>>
>>>Since we are not going to be able to talk about this at LSF/MM, a few of
>>>us thought about holding a dedicated virtual discussion about Copy
>>>Offload. I believe we can use Chaitanya's thread as a start. Given the
>>>current state of the current patches, I would propose that we focus on
>>>the next step to get the minimal patchset that can go upstream so that
>>>we can build from there.
>>>
>>
>>I agree with having a call as it has been two years I'm trying to have
>>this discussion.
>>
>>Before we setup a call, please summarize following here :-
>>
>>1. Exactly what work has been done so far.
>
>
>We can categorize that into two sets. First one for XCopy (2014), and
>second one for NVMe Copy (2021).
>
>XCOPY set *********
>- block-generic copy command (single range, between one
>  source/destination device)
>- ioctl interface for the above
>- SCSI plumbing (block-generic to XCOPY conversion)
>- device-mapper support: offload copy whenever possible (if IO is not
>  split while traveling layers of virtual devices)
>
>NVMe-Copy set *************
>- block-generic copy command (multiple ranges, between one
>  source/destination device)
>- ioctl interface for the above
>- NVMe plumbing (block-generic to NVMe Copy conversion)
>- copy-emulation (read + write) in block-layer
>- device-mapper support: no offload, rather fall back to copy-emulation
>
>
>>2. What kind of feedback you got.
>
>For NVMe Copy, the major points are - a) add copy-emulation in
>block-layer and use that if copy-offload is not natively supported by
>device b) user-interface (ioctl) should be extendable for copy across
>two devices (one source, one destination) c) device-mapper targets
>should support copy-offload, whenever possible
>
>"whenever possible" cases get reduced compared to XCOPY because NVMe
>Copy is wit
>
>>3. What are the exact blockers/objections.
>
>I think it was device-mapper for XCOPY and remains the same for NVMe
>Copy as well.  Device-mapper support requires decomposing copy operation
>to read and write.  While that is not great for efficiency PoV, bigger
>concern is to check if we are taking the same route as XCOPY.
>
>From Martin's document (http://mkp.net/pubs/xcopy.pdf), if I got it
>right, one the major blocker is having more failure cases than
>successful ones. And that did not justify the effort/code to wire up
>device mapper.  Is that a factor to consider for NVMe Copy (which is
>narrower in scope than XCOPY).
>
>>4. Potential ways of moving forward.
>
>a) we defer attempt device-mapper support (until NVMe has
>support/usecase), and address everything else (reusable user-interface
>etc.)
>
>b) we attempt device-mapper support (by moving to composite read+write
>communication between block-layer and nvme)
>
>
>Is this enough in your mind to move forward with a specific agenda? If
>we can, I would like to target the meetup in the next 2 weeks.
>
>Thanks,
>Javier

