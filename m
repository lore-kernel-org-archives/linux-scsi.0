Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21F20C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 19:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F06B561262
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 19:13:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242407AbhI1TP0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 15:15:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36090 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240589AbhI1TPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 15:15:25 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210928191344euoutp01ae545f64a87243d9fd9c4e5de99f9a50~pEkRAPpuP1833218332euoutp014
        for <linux-scsi@vger.kernel.org>; Tue, 28 Sep 2021 19:13:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210928191344euoutp01ae545f64a87243d9fd9c4e5de99f9a50~pEkRAPpuP1833218332euoutp014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632856424;
        bh=WCjj/eTFYFtT74BPRzNb1VVr8ZyatpOXxZCtUM0p/+4=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=HderbyPaEcNqwEMmLiFsiJwWllV6dSToV4ZUo0KnczKGGhOmCH2L3Ssm77Msxjfs1
         VX6dD9df8wcexD+mU1qOFhPog6nrBzPwrEwGErvEPKOx+s5JbCpYtZq9Qcw5Oz4XRL
         uICXnYV1B7MPZqKljsfD/r5JtuU1NoFGUiQAtwf8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210928191343eucas1p1dcb8f91ba5677eb85814676136da4047~pEkQixJGu3000330003eucas1p1o;
        Tue, 28 Sep 2021 19:13:43 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 8E.C3.56448.76963516; Tue, 28
        Sep 2021 20:13:43 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c~pEkPwDJfn3124431244eucas1p2x;
        Tue, 28 Sep 2021 19:13:42 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210928191342eusmtrp2ad0242704d815a2ddbd01533014f75e2~pEkPvEiSk3183031830eusmtrp2z;
        Tue, 28 Sep 2021 19:13:42 +0000 (GMT)
X-AuditID: cbfec7f5-d53ff7000002dc80-10-61536967f9b8
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id C9.0F.31287.66963516; Tue, 28
        Sep 2021 20:13:42 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210928191342eusmtip1befbade2ffa71fb4c036d18ada9f7ff7~pEkPhnrVk1922619226eusmtip1V;
        Tue, 28 Sep 2021 19:13:42 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC02.scsc.local
        (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Tue, 28 Sep 2021 20:13:41 +0100
Date:   Tue, 28 Sep 2021 21:13:40 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
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
        "Nitesh Shetty" <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "Vincent Fu" <vincent.fu@samsung.com>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUxTVxjGOfe2t7fNWi/l68SPLVadFSbOwbaTYZxL0F0HZE6zDzcFm3EH
        jBZIWybMmIEQ1DI/6BaB2oghwxZKdAGL5dtgZsEW6oCK64ANFQmQWUohKw7LqFc3/3ve5/09
        Oe+THBIXP+auJDOy1IwySyaXEAJO082Fvs1pGftkr/dMSJFp5AyBzs0s4Ej3+zQHtT86z0X3
        G5Yw1FatxVCt6RcMPdGMYkjbdQegdlcUqro0zkOlQxYCdUy348hg9WOo7IQTQ326RQLdGHVy
        kGkRodqHGJrqTN4RSg8MJtBlRY949EBvLt1Qd5KgG3/6jv7hrgHQrb8VEHTF7BxBD9mvYbRn
        3MWhm8ZO8Wh3h3MZsx2hvQ0v08evl2J7Vnwu2JbKyDO+YZRbth8SpN+8sITnXI7Mc+h/5RWA
        bokG8ElIxUL9P/McDRCQYsoI4JBvgscOcwCea7v4bPAC2N08xnkeaZvtxdiFYTnS78X+o8pb
        S7gBSkyZlzeV8QHNoTZA/7CNCGiCehf2X3LhGkCSoVQMXLgcF8jiVCEfnrqhwQJMCLUbWn4+
        gwUYIZUEqywbA7aQCoY9lQ+eHoFT78CTM8e4AQSnVkGDnwzYfOog7LzlJQI2pNZBQ3kSe/JR
        eOuqC2O1RgCLJ7ezOh56hicBq0PglPUqj9Wr4VJz1dNWkCoC0F4/iLPD9wAuao2AfSAOnrbL
        2cB78NqPYzhri+Ddv4LZK0VQ21T+zBbCEyViln4VWo6ZwVmwTvdCL90LvXT/97oI8DoQweSq
        FGmMKiaLORytkilUuVlp0V9mKxrA8ve0+a3zFmCc8kR3AYwEXQCSuCRU6IvYJxMLU2X53zLK
        7BRlrpxRdYFVJEcSIWwx16eIqTSZmslkmBxG+XyLkfyVBdjH3B2ze2FF9eGv56Xhqe573OKx
        O5+u9iWsjQ0qfBhx5fYV6xYtyne9VXnQrQ3uqPA9sYa/FBquaTfWe13m67sOzJT59UA6HBJT
        8X7xK/GPb2/8s7O7NntvekeUyCpam5hw/3hpUU0rZ/Tvuf3Jm9XNNZMPHJGbykMu+D6TL1k/
        aUyyD/Z/oQ/Cx18jIr3qo/vBH9KwNUb+mqDEwQ+rd+626R3pVYnumqHquZGRFqd7fiJlmyKu
        6Z7NKTzv2eXJEa9Qhx0xRZMHTHtEJYYeQZgdG9Ct73VMx3/1EXAMCPssH/CTi/AWaV7m1rqR
        NzX5itmdeW9nxpoLGwsOna6N2vSGhKNKl22NxJUq2b//psH0DQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t/xu7ppmcGJBhtn6lmsvtvPZjHtw09m
        i1m3X7NY7H03m9Xi8ab/TBZ7Fk1isli5+iiTxd+ue0wWkw5dY7TYe0vbYv6yp+wW3dd3sFns
        e72X2WL58X9MFhM7rjJZnJv1h83i8L2rLBar/1hYrHzGZPFqf5yDiMflK94eE5vfsXtcPlvq
        sWlVJ5vH5iX1HpNvLGf02H2zgc1jxqcvbB7Xz2xn8vj49BaLx7aHvewe7/ddBSo7Xe3xeZOc
        R/uBbqYA/ig9m6L80pJUhYz84hJbpWhDCyM9Q0sLPSMTSz1DY/NYKyNTJX07m5TUnMyy1CJ9
        uwS9jGPz/jMXrNOqOD/nInsD4wmlLkZODgkBE4k9n84ydTFycQgJLGWUeD71JzNEQkbi05WP
        7BC2sMSfa11sEEUfGSU2HF3FDOFsZZRYcn4KE0gVi4CqxL87p9lAbDYBe4lLy24BFXFwiAgY
        S/xcZw1SzyzQyCnRe7gLrF5YwFNix4Z+JpAaXgFfifk71CFmrmeU+HV8NtgVvAKCEidnPmEB
        sZkFLCRmzj/PCFLPLCAtsfwfB0iYUyBWYv+pz2wgYQkBZYnl030hbq6V+Pz3GeMERuFZSAbN
        QjJoFsKgBYzMqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQLTyLZjPzfvYJz36qPeIUYmDsZD
        jBIczEoivD/EgxOFeFMSK6tSi/Lji0pzUosPMZoCA2Iis5Rocj4wkeWVxBuaGZgamphZGpha
        mhkrifNunbsmXkggPbEkNTs1tSC1CKaPiYNTqoFplb6Hv+Sz4I/cIb18BUt+NT7QuS3C9Z3N
        0Zyl8HzcppTjXjfDlc99vdVmrJ+5Pk01edJ7BwGek3xtos+cHVPncmktS877+fm+wNaJ63hc
        tcP/Ba32z/u/6euLfetd28tO3ZGR/bdA1G/vWbbWUP3A+eu09jJ4nTJWvvn/xUoNpzCNpu8L
        GLufyy5o9slcrje5afaqFR/bTisuvL9f+a1t+Pyz1ccP9qWkLAg37Q5YdllD0nN/4tsbk+9N
        P+6zr8RG5cQNC5WZrQs//wgol0o52bOS7xLrH6ULifM/xG/6Py00qFf0mq2c7cJdUxpkW3ac
        7vgtrSr9e9p7lpSNuUE7/ofJKj5YbBty/06T5LZOJZbijERDLeai4kQAknxuH6wDAAA=
X-CMS-MailID: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
X-Msg-Generator: CA
X-RootMTR: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
        <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
        <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12.05.2021 07:30, Johannes Thumshirn wrote:
>On 11/05/2021 02:15, Chaitanya Kulkarni wrote:
>> Hi,
>>
>> * Background :-
>> -----------------------------------------------------------------------
>>
>> Copy offload is a feature that allows file-systems or storage devices
>> to be instructed to copy files/logical blocks without requiring
>> involvement of the local CPU.
>>
>> With reference to the RISC-V summit keynote [1] single threaded
>> performance is limiting due to Denard scaling and multi-threaded
>> performance is slowing down due Moore's law limitations. With the rise
>> of SNIA Computation Technical Storage Working Group (TWG) [2],
>> offloading computations to the device or over the fabrics is becoming
>> popular as there are several solutions available [2]. One of the common
>> operation which is popular in the kernel and is not merged yet is Copy
>> offload over the fabrics or on to the device.
>>
>> * Problem :-
>> -----------------------------------------------------------------------
>>
>> The original work which is done by Martin is present here [3]. The
>> latest work which is posted by Mikulas [4] is not merged yet. These two
>> approaches are totally different from each other. Several storage
>> vendors discourage mixing copy offload requests with regular READ/WRITE
>> I/O. Also, the fact that the operation fails if a copy request ever
>> needs to be split as it traverses the stack it has the unfortunate
>> side-effect of preventing copy offload from working in pretty much
>> every common deployment configuration out there.
>>
>> * Current state of the work :-
>> -----------------------------------------------------------------------
>>
>> With [3] being hard to handle arbitrary DM/MD stacking without
>> splitting the command in two, one for copying IN and one for copying
>> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
>> candidate. Also, with [4] there is an unresolved problem with the
>> two-command approach about how to handle changes to the DM layout
>> between an IN and OUT operations.
>>
>> * Why Linux Kernel Storage System needs Copy Offload support now ?
>> -----------------------------------------------------------------------
>>
>> With the rise of the SNIA Computational Storage TWG and solutions [2],
>> existing SCSI XCopy support in the protocol, recent advancement in the
>> Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
>> DMA support in the Linux Kernel mainly for NVMe devices [7] and
>> eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
>> from Copy offload operation.
>>
>> With this background we have significant number of use-cases which are
>> strong candidates waiting for outstanding Linux Kernel Block Layer Copy
>> Offload support, so that Linux Kernel Storage subsystem can to address
>> previously mentioned problems [1] and allow efficient offloading of the
>> data related operations. (Such as move/copy etc.)
>>
>> For reference following is the list of the use-cases/candidates waiting
>> for Copy Offload support :-
>>
>> 1. SCSI-attached storage arrays.
>> 2. Stacking drivers supporting XCopy DM/MD.
>> 3. Computational Storage solutions.
>> 7. File systems :- Local, NFS and Zonefs.
>> 4. Block devices :- Distributed, local, and Zoned devices.
>> 5. Peer to Peer DMA support solutions.
>> 6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.
>>
>> * What we will discuss in the proposed session ?
>> -----------------------------------------------------------------------
>>
>> I'd like to propose a session to go over this topic to understand :-
>>
>> 1. What are the blockers for Copy Offload implementation ?
>> 2. Discussion about having a file system interface.
>> 3. Discussion about having right system call for user-space.
>> 4. What is the right way to move this work forward ?
>> 5. How can we help to contribute and move this work forward ?
>>
>> * Required Participants :-
>> -----------------------------------------------------------------------
>>
>> I'd like to invite file system, block layer, and device drivers
>> developers to:-
>>
>> 1. Share their opinion on the topic.
>> 2. Share their experience and any other issues with [4].
>> 3. Uncover additional details that are missing from this proposal.
>>
>> Required attendees :-
>>
>> Martin K. Petersen
>> Jens Axboe
>> Christoph Hellwig
>> Bart Van Assche
>> Zach Brown
>> Roland Dreier
>> Ric Wheeler
>> Trond Myklebust
>> Mike Snitzer
>> Keith Busch
>> Sagi Grimberg
>> Hannes Reinecke
>> Frederick Knight
>> Mikulas Patocka
>> Keith Busch
>>
>
>I would like to participate in this discussion as well. A generic block layer
>copy API is extremely helpful for filesystem garbage collection and copy operations
>like copy_file_range().


Hi all,

Since we are not going to be able to talk about this at LSF/MM, a few of
us thought about holding a dedicated virtual discussion about Copy
Offload. I believe we can use Chaitanya's thread as a start. Given the
current state of the current patches, I would propose that we focus on
the next step to get the minimal patchset that can go upstream so that
we can build from there.

Before we try to find a date and a time that fits most of us, who would
be interested in participating?

Thanks,
Javier
