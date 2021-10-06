Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21489C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 10:01:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB3416109F
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 10:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhJFKD1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 06:03:27 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11711 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237846AbhJFKDR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 06:03:17 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20211006100123euoutp02198f079c0c630783937889d4f725f9f3~raMSpq5fj1613816138euoutp02_
        for <linux-scsi@vger.kernel.org>; Wed,  6 Oct 2021 10:01:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20211006100123euoutp02198f079c0c630783937889d4f725f9f3~raMSpq5fj1613816138euoutp02_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1633514483;
        bh=FZBcHb7MoaKYxbk+/NhmGvSxHVs2WdKOe/OzkP+g/sg=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=aZQqF29olwPxwX6/Lo1rzXOBxvhShFGnO6azdoCTvkVWBdDFUOj+GQy0pT6vWGHlc
         tZrB+OFYFYBrtZkDg8raA1u5fInFr5Ud6DNjcAdqXyv/30FLCVLZyNIxo3FFsQCVLa
         LSywS8SyQKA+hDzy+M+SV4z1yiA2zUjZvVueBrMA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211006100123eucas1p13b64ab837df0cb5e262b2d517e4d2b6a~raMSNZ5mx2823628236eucas1p10;
        Wed,  6 Oct 2021 10:01:23 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id A3.76.56448.3F37D516; Wed,  6
        Oct 2021 11:01:23 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20211006100122eucas1p119be2455fe2809febb16490e7bbbe108~raMRpg3ox2795227952eucas1p13;
        Wed,  6 Oct 2021 10:01:22 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20211006100122eusmtrp2e553e6ca56aa3549f6bb389ab2268695~raMRofIT80327103271eusmtrp2N;
        Wed,  6 Oct 2021 10:01:22 +0000 (GMT)
X-AuditID: cbfec7f5-d3bff7000002dc80-79-615d73f305cb
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 61.7C.20981.2F37D516; Wed,  6
        Oct 2021 11:01:22 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20211006100122eusmtip1a94e2a6cd325173ea0fbbe1dcc9b7c90~raMRaQOYD0323803238eusmtip1Y;
        Wed,  6 Oct 2021 10:01:22 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Wed, 6 Oct 2021 11:01:21 +0100
Date:   Wed, 6 Oct 2021 12:01:21 +0200
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
Message-ID: <20211006100121.2hqfdkyuivzvzd33@mpHalley.domain_not_set.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <c1b0f954-0728-e6ab-73ab-7b466a7d2eb7@nvidia.com>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZduznOd3PxbGJBtNvKlmsvtvPZjHtw09m
        i1m3X7NYvD/4mNVi77vZrBaPN/1nstizaBKTxcrVR5ks/nbdY7KYdOgao8XeW9oW85c9Zbfo
        vr6DzWLf673MFsuP/2OymNhxlcni3Kw/bBaH711lsVj9x8Ji5TMmi1f74xxEPS5f8faY2PyO
        3ePy2VKPTas62Tw2L6n3mHxjOaPH7psNbB4zPn1h87h+ZjuTR2/zOzaPj09vsXhse9jL7vF+
        31Wg2tPVHp83yXm0H+hmChCI4rJJSc3JLEst0rdL4Mrovj+dtWCneEX33z/MDYxvhboYOTkk
        BEwkPt5ZwtzFyMUhJLCCUWLq1J9MEM4XRolFzRegMp8ZJWY9/MYG03L2/A4mEFtIYDmjxN/3
        inBF1+b/ZoVwtjBKXFr9nQWkikVARaL34wMwm03AXuLSslvMILaIgJ7E1Vs32EEamAU2cEps
        WrQBbIWwgKfEjg39YCt4BXwl9k9pZ4WwBSVOznwCNohZwEqi80MTUJwDyJaWWP6PAyTMKWAn
        sW/zbbCwhICyxPLpvhBH10qsPXYGbJWEwFQuia3bHjNB1LhIdH9JgKgRlnh1fAs7hC0j8X/n
        fCaI+mZGiTNrrjBDOD2MEn8mrWCEaLaW6DuTA9HgKLF9ykNmiDCfxI23ghBX8klM2jYdKswr
        0dEGDXY1iR1NWxknMCrPQvLXLCR/zUL4awEj8ypG8dTS4tz01GLjvNRyveLE3OLSvHS95Pzc
        TYzApHr63/GvOxhXvPqod4iRiYPxEKMEB7OSCG++fWyiEG9KYmVValF+fFFpTmrxIUZpDhYl
        cd5dW9fECwmkJ5akZqemFqQWwWSZODilGphi1n9f49/KeCVw54OOLZcXPlkctCx1l7275vGL
        eaGu86+EdLxV8H4jPuPnzyWXPip8Dr+vzvy3ZkX3Kdb1s1TNNAOUlx4zNpqx7qPRaamLjR3l
        swWE9Vjruze2/HgtsdYvU0+a7Yhqi0U8l5bP0ouRsSs1jpXIt76M/c4zYdPcjTfEFk7d8Nz5
        g3zuyWWqHjdOG8rcfVQV0FoT963ixFnBfN9vO1yXbihUn2yedf/irCmqu4s5Qi58nDfpVrmf
        VP+R4JAHNWvME+ZeXRrNdjvR4tqN6Y6h3Cc+mdpf3cPseP8NT3BqB/OdpsdaDHEagcbzo5kO
        z+2b77tO6JL1A/+qkLnhXdd/RsR93G+YdNtaiaU4I9FQi7moOBEAExL6ARkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t/xu7qfimMTDV4ckrZYfbefzWLah5/M
        FrNuv2axeH/wMavF3nezWS0eb/rPZLFn0SQmi5WrjzJZ/O26x2Qx6dA1Rou9t7Qt5i97ym7R
        fX0Hm8W+13uZLZYf/8dkMbHjKpPFuVl/2CwO37vKYrH6j4XFymdMFq/2xzmIely+4u0xsfkd
        u8fls6Uem1Z1snlsXlLvMfnGckaP3Tcb2DxmfPrC5nH9zHYmj97md2weH5/eYvHY9rCX3eP9
        vqtAtaerPT5vkvNoP9DNFCAQpWdTlF9akqqQkV9cYqsUbWhhpGdoaaFnZGKpZ2hsHmtlZKqk
        b2eTkpqTWZZapG+XoJfRfX86a8FO8Yruv3+YGxjfCnUxcnJICJhInD2/gwnEFhJYyijx5qc3
        RFxG4tOVj+wQtrDEn2tdbF2MXEA1Hxklmvra2SGcLYwSR77cZAGpYhFQkej9+ADMZhOwl7i0
        7BYziC0ioCdx9dYNsAZmgQ2cEpsWbWADSQgLeErs2NAPtppXwFdi/5R2Voipv5kkVn+7zwyR
        EJQ4OfMJ2FRmAQuJmfPPM3YxcgDZ0hLL/3GAhDkF7CT2bb7NChKWEFCWWD7dF+LqWolX93cz
        TmAUnoVk0Cwkg2YhDFrAyLyKUSS1tDg3PbfYSK84Mbe4NC9dLzk/dxMjMLlsO/Zzyw7Gla8+
        6h1iZOJgPMQowcGsJMKbbx+bKMSbklhZlVqUH19UmpNafIjRFBgUE5mlRJPzgektryTe0MzA
        1NDEzNLA1NLMWEmc1+TImnghgfTEktTs1NSC1CKYPiYOTqkGJlvmwgt8uvs2fJEyKxM/3Mvn
        ziM/0bW6aINqfsituT4Cuw39tvD8W9z+4KbFpnjrjdcPaDfahl/JuTGZeaKsVru574tOXk+5
        Bd77FXavK1+8+1jbl+WG3sG7Ns5XStqsG1Lb1stqKsnIy3PB6p3iarWTHWaWy99xWssUqB6Y
        a3kpoctUX5fdhbdLOSPlHaf5mucCqddjWoSCV7yV2Xndkc1gxm2rbz4n+x5fF9pxT/WRmd+x
        6jj3a/tk3Z8VJns9zvy3atmsiRkHjqnus302X/d0os1nmYXuErXzNLP4Y0/GTBO7f27J/tuz
        JnyVfb37u+Md1yVWkivatG6p9ofwbtu6+21h75xqxQA55bXqSizFGYmGWsxFxYkAjPGcILcD
        AAA=
X-CMS-MailID: 20211006100122eucas1p119be2455fe2809febb16490e7bbbe108
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
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30.09.2021 09:43, Chaitanya Kulkarni wrote:
>Javier,
>
>>
>> Hi all,
>>
>> Since we are not going to be able to talk about this at LSF/MM, a few of
>> us thought about holding a dedicated virtual discussion about Copy
>> Offload. I believe we can use Chaitanya's thread as a start. Given the
>> current state of the current patches, I would propose that we focus on
>> the next step to get the minimal patchset that can go upstream so that
>> we can build from there.
>>
>
>I agree with having a call as it has been two years I'm trying to have
>this discussion.
>
>Before we setup a call, please summarize following here :-
>
>1. Exactly what work has been done so far.


We can categorize that into two sets. First one for XCopy (2014), and
second one for NVMe Copy (2021).

XCOPY set *********
- block-generic copy command (single range, between one
   source/destination device)
- ioctl interface for the above
- SCSI plumbing (block-generic to XCOPY conversion)
- device-mapper support: offload copy whenever possible (if IO is not
   split while traveling layers of virtual devices)

NVMe-Copy set *************
- block-generic copy command (multiple ranges, between one
   source/destination device)
- ioctl interface for the above
- NVMe plumbing (block-generic to NVMe Copy conversion)
- copy-emulation (read + write) in block-layer
- device-mapper support: no offload, rather fall back to copy-emulation


>2. What kind of feedback you got.

For NVMe Copy, the major points are - a) add copy-emulation in
block-layer and use that if copy-offload is not natively supported by
device b) user-interface (ioctl) should be extendable for copy across
two devices (one source, one destination) c) device-mapper targets
should support copy-offload, whenever possible

"whenever possible" cases get reduced compared to XCOPY because NVMe
Copy is wit

>3. What are the exact blockers/objections.

I think it was device-mapper for XCOPY and remains the same for NVMe
Copy as well.  Device-mapper support requires decomposing copy operation
to read and write.  While that is not great for efficiency PoV, bigger
concern is to check if we are taking the same route as XCOPY.

 From Martin's document (http://mkp.net/pubs/xcopy.pdf), if I got it
right, one the major blocker is having more failure cases than
successful ones. And that did not justify the effort/code to wire up
device mapper.  Is that a factor to consider for NVMe Copy (which is
narrower in scope than XCOPY).

>4. Potential ways of moving forward.

a) we defer attempt device-mapper support (until NVMe has
support/usecase), and address everything else (reusable user-interface
etc.)

b) we attempt device-mapper support (by moving to composite read+write
communication between block-layer and nvme)


Is this enough in your mind to move forward with a specific agenda? If
we can, I would like to target the meetup in the next 2 weeks.

Thanks,
Javier
