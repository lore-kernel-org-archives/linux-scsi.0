Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD6A5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 09:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7C6E61528
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 09:53:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349503AbhI3JzA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 05:55:00 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:45999 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349504AbhI3Jy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Sep 2021 05:54:59 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210930095316euoutp01a1956023279a057484279d25410757a0~pkNe6jQZS1107611076euoutp01r
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2021 09:53:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210930095316euoutp01a1956023279a057484279d25410757a0~pkNe6jQZS1107611076euoutp01r
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632995596;
        bh=dXfx/WMyrIWN+HAvhSUPKljKtdHmk58fulLYoRVhSCA=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=CnCnamPeaku0x0Rf8DTcgGXr0HaGymR7AlTNiNefxS/z9QDUvPIYC/KDSRVXafF5d
         2JsXL4ygRDeiDy+UH8f6x74ZCVe25l+WGT0qrh0pg/Z6wpIXqOp3j80Ifx7xusnOAp
         LWfLDlEwSItWKYUltyf6pzp1b84zd9LSanr/Rvos=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210930095315eucas1p242b75713efbe09654512e314cb32f1e2~pkNeMkA8A1821518215eucas1p2E;
        Thu, 30 Sep 2021 09:53:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 5B.EC.42068.B0985516; Thu, 30
        Sep 2021 10:53:15 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210930095314eucas1p10f56a3c7bc3cc167d93b3bd472c6852a~pkNdq_OAy1563315633eucas1p1X;
        Thu, 30 Sep 2021 09:53:14 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210930095314eusmtrp2613aace3fff86eb43febc14d1c8711da~pkNdp4irE0109501095eusmtrp2p;
        Thu, 30 Sep 2021 09:53:14 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-73-6155890b83b1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 5B.9B.20981.A0985516; Thu, 30
        Sep 2021 10:53:14 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210930095314eusmtip1eb040877616c6f8f18287fae83016cfe~pkNdeTsf-2640426404eusmtip1J;
        Thu, 30 Sep 2021 09:53:14 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Thu, 30 Sep 2021 10:53:13 +0100
Date:   Thu, 30 Sep 2021 11:53:12 +0200
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
Message-ID: <20210930095312.jeipuaxzyyhd5e6e@mpHalley.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <c1b0f954-0728-e6ab-73ab-7b466a7d2eb7@nvidia.com>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTZxjde2+5vVTKLpXZN+LYVseyOAfqyPKyGXEfcZeI23SabN0yVuSm
        MsvH+iGicXSAswVaZyVDqkZkSoUqYvloG2w3MSvZAAdokRWpIOAI1arYJTIqjvbq5r9zznNO
        nuckD4kL9hKLyexcJSPPlchEBI/T5pr54/UF2i2SFY7jccg8vJ9AP96dwZFxyMdBdy6MRSCH
        /3AEGrM8wtD5WgOG6s2/YuhhmRdDho4BgBye19CxugkuKr9qI5DT58CRqXMOQwc0bgxdMgYJ
        dNHr5iBzEKH6mxia+vnLtc/Rl6+spw+U+Ln05R4VbWnQEnTziSL64KAJ0O1/qgn60HSAoK92
        WzFaV+In6HsTHg7dNqrj0nec7nlv1276viWe3vdLOfYxJeatzmJk2TsYedKar3jbWl3OiPx/
        eDsnK6YINWghy0AkCalkaBnz4WWARwqoUwCab13AWBIAUGN1RbDkPoD9pdeJJ5Hzdh0ewgLK
        BODha/H/mRp79ARLWgEc8VXPu0iSQyXAYl1UKEBQqbC/zhMOx1KJ0O0Z5Ib8ONUUCS21TeEN
        C6k0aGvaj4WyfGo1tHelh2Q+FQN/qx7nhDBOvQW1d4sjQhacioOmuXCdSGoNdDYPhWVILYWm
        qg3syXvg7y2ecDFIHeXBYY2Hww7eh0fagxiLF8KpzhYui5fAR/ZjjwMlAHafvoKzpALAoOEU
        YDe8DfXdMjbwDrRWjuKsHA0Hb8ewZ0ZDQ1vVY5kPNd8LWPcr0FbcCn4AS41PFTM+Vcz4f7Ea
        gDcAIaNS5EgZxapcpiBRIclRqHKliVvzcixg/lO75joDNmCaupfYATASdABI4qJY/gPhJxIB
        P0tSuIuR52XIVTJG0QHiSI5IyM9sOZ0hoKQSJbOdYfIZ+ZMpRkYuVmPVltTbn93ocy7ftFyZ
        VhjwoHdrHu5t1g8kyL3lMuwLoXDVqCvpTKo/s3K4RjdjbEwv7ak913dycqgdP2e3wudNM9KR
        zqzZa3vyQY6qdPyGdol3QjuR8upG8YdvBn/627e1oEH5edQ3ydJAyspNjUeTvhuaFvQd3+5f
        +8Eu66KXzOsq+9cpDC/ogC3rbCPmtd+MzetNcWRO+3e/8bJwB/h0xYP0OniCyfi2eCzZLD47
        vq+nUCM1iHe6lAl5Fw/pmy+VWjdsNtQXqYvU721ZZrxe0d2bPbBo8zODvQ3utIS/XjxzUBRz
        sv1WfupkdEm8umrkI//XUbPCjQXPxvjFfQv0I7MijmKbZOUyXK6Q/AvpltwAGAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t/xu7pcnaGJBkt3GVisvtvPZjHtw09m
        i1m3X7NYvD/4mNVi77vZrBaPN/1nstizaBKTxcrVR5ks/nbdY7KYdOgao8XeW9oW85c9Zbfo
        vr6DzWLf673MFsuP/2OymNhxlcni3Kw/bBaH711lsVj9x8Ji5TMmi1f74xxEPS5f8faY2PyO
        3ePy2VKPTas62Tw2L6n3mHxjOaPH7psNbB4zPn1h87h+ZjuTR2/zOzaPj09vsXhse9jL7vF+
        31Wg2tPVHp83yXm0H+hmChCI0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXS
        t7NJSc3JLEst0rdL0MvYemwfa8EvrooXPa/YGhi3cHQxcnJICJhI7NnZywxiCwksZZT4/dYe
        Ii4j8enKR3YIW1jiz7Uuti5GLqCaj4wSq27dYYZwtjJKdG+ZwtLFyMHBIqAq0dTLA9LAJmAv
        cWnZLbChIgJ6Eldv3WAHqWcW2MApsWnRBjaQhLCAp8SODf1MIL28AjYSO0/7QMz8zSSx+tt9
        sGZeAUGJkzOfsIDYzAIWEjPnn2cEqWcWkJZY/g/sAU4BO4l9m2+zgoQlBJQllk/3hbi5VuLz
        32eMExiFZyEZNAvJoFkIgxYwMq9iFEktLc5Nzy020itOzC0uzUvXS87P3cQITCzbjv3csoNx
        5auPeocYmTgYDzFKcDArifD+EA9OFOJNSaysSi3Kjy8qzUktPsRoCgyIicxSosn5wNSWVxJv
        aGZgamhiZmlgamlmrCTOa3JkTbyQQHpiSWp2ampBahFMHxMHp1QDk0zi7xmLNk5zy1/9ae0O
        00i33yzHmpesEmnaGrYvcq3aW4E332dm7jfef//ew9ffphrq+M1W25A/a4POvyVmL8WnXgqr
        lli9ofro/Ul26x26pnS9Cik7kGozK6bz890nllnTLktPDdqbYjnXJnRH/K6pTJdUPs37lRZr
        r+pumJqQHdAxL33CqzM9UreblCSWmqT1nLthtL1a8L6T+Gwmu9KQ+feVYnfd2Rk+JXHBzMSk
        BbNT//76vj3Or/X5h3UrNU/HmbRduHrt2y31e+qvJ/b/CBf24p5gKxg8+W7+m4XshoKbxI1F
        YkM0vqS21Lf+CuwOf3D81Lap8gx30xY777cMPn15ms30JE9jB6nT658psRRnJBpqMRcVJwIA
        sh+3PrUDAAA=
X-CMS-MailID: 20210930095314eucas1p10f56a3c7bc3cc167d93b3bd472c6852a
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
>2. What kind of feedback you got.
>3. What are the exact blockers/objections.
>4. Potential ways of moving forward.
>
>Although this all information is present in the mailing archives it is
>scattered all over the places, looking at the long CC list above we need
>to get the everyone on the same page in order to have a productive call.
>
>Once we have above discussion we can setup a precise agenda and assign
>slots.

Sounds reasonable. Let me collect all this information and post it here.
I will maintain a list of people that has showed interest on joining.
For now:

   - Martin
   - Johannes
   - Fred
   - Chaitanya
   - Adam
   - Kanchan
   - Selva
   - Nitesh
   - Javier
