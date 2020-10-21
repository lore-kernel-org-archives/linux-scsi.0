Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0503C388CE
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 04:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A3FB221FC
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 04:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZJ2JfmFE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407107AbgJUEXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 00:23:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26230 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407069AbgJUEXp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 00:23:45 -0400
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201021042340epoutp015560534016fe32bbad02861ca8131648~-5zgG1mX22371323713epoutp01A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2020 04:23:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201021042340epoutp015560534016fe32bbad02861ca8131648~-5zgG1mX22371323713epoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1603254220;
        bh=1e6enWprM1ZNW6jnwlkcz7Lh5JyNW3ve2/jxLEjHSwc=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ZJ2JfmFE8po6Es4ZRZrQiGbdD/MFPdzxz382Gznopb3rlIhypzXqqkh4DkSVB2A7o
         DvdCe4q8X9ZKAQP5IHzFOgbLTTCDdaudyBar+wEI9YoQANyyMPZisCQ3kk5KVq/Urn
         2q6u/a28YcQ6u63WVPTo16u0Y1yBHikW9zlZbWEQ=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201021042339epcas2p245a69fe1b84706d9f1eb983c8b358d54~-5zfzN1_u0201102011epcas2p2M;
        Wed, 21 Oct 2020 04:23:39 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4CGHRq4LMXzMqYkm; Wed, 21 Oct
        2020 04:23:35 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.CA.09588.5C7BF8F5; Wed, 21 Oct 2020 13:23:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20201021042333epcas2p2b794c192840431522a7da5d4ea9934cf~-5zZfcj0Q0645106451epcas2p2Q;
        Wed, 21 Oct 2020 04:23:33 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201021042333epsmtrp27782b139d92171991577b19872addc79~-5zZevvB90920609206epsmtrp25;
        Wed, 21 Oct 2020 04:23:33 +0000 (GMT)
X-AuditID: b6c32a45-36bff70000002574-bf-5f8fb7c5bedc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6A.B4.08604.4C7BF8F5; Wed, 21 Oct 2020 13:23:32 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201021042332epsmtip1baf21d90191da3f28879fa6edba9d7fa~-5zZSBIpU2561025610epsmtip1v;
        Wed, 21 Oct 2020 04:23:32 +0000 (GMT)
From:   "chanho61.park" <chanho61.park@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
Cc:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
In-Reply-To: <7fafcc82-2c42-8ef5-14a6-7906b5956363@acm.org>
Subject: RE: [PATCH] scsi: ufs: make sure scan sequence for multiple hosts
Date:   Wed, 21 Oct 2020 13:23:32 +0900
Message-ID: <000a01d6a761$efafcaf0$cf0f60d0$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_NextPart_000_000B_01D6A7AD.5F97E820"
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQE8rU9GG02+1hbAo1p5qXUnN9CPVgF+Wj0dAilh/bmquCal0A==
Content-Language: ko
X-MS-TNEF-Correlator: 000000001202C7091B686242807B1F7405DE85A3E4279301
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKJsWRmVeSWpSXmKPExsWy7bCmme7R7f3xBtvXKVg8mLeNzeLlz6ts
        FtM+/GS2WHRjG5PF5V1z2Cy6r+9gs1h+/B+TA7vH5SveHhMWHWD0+Pj0FotH35ZVjB6fN8l5
        tB/oZgpgi8qxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAE6RUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2Vo
        YGBkClSZkJPR+qeg4I1eRXfzNpYGxitaXYycHBICJhL79q9n7GLk4hAS2MEo8WXpMWYI5xOj
        xNO+D+wgVUIC3xglzi9w62LkAOs43mYBUbOXUWLW2b9QDS+AnKdH2UAa2AQMJd43rmAGsUUE
        kiSmPr/BCGIzC5RI7Ng3ASzOKWAtMfvZRmaQocICXhINTx1BwiwCqhIzZnWChXkFLCXuTDMH
        CfMKCEqcnPmEBWJKqMTz/9eZIB5QkPj5dBkrxCYniVvrr7ND1IhIzO5sY4aocZN40XIB7EkJ
        gTscErt/dLBAJFwkPtxsgSoSlnh1fAs7hC0l8fndXjYIu15ixaMmZojmHkaJl9P+QTXYS8x8
        upQJEijKEkduQR3HJ9Fx+C87RJhXoqNNCKJaXeLA9ulQa2Uluud8Zp3AqDQLyWuzkLw2C8kL
        ELa8xPa3c4BsDiBbU2L9Ln2IsKnEla+NUK2KElO6H7JD2OYSE7evZVnAyLGKUSy1oDg3PbXY
        qMAQOWVsYgSnaS3XHYyT337QO8TIxMF4iFEFqPfRhtUXGKVY8vLzUpVEeCew9sUL8aYkVlal
        FuXHF5XmpBYfYjQFxtNEZinR5HxgBskriTc0NTIzM7A0tTA1M7JQEucNXQnUJJCeWJKanZpa
        kFoE08fEwSnVwBRf+Kdlj8OC/9+trdwnOov//cYeItO3edcyFY5rm2QO/cyqTVpWbbE8jvNl
        9JzpCTvVZb0uvcgWvNDCt6OJcdnWE7Lypn/U1qs8XjJ13dJZM+/OvTyb+5TW29rl0xZOmdJj
        +2almWDcY/Gjtxn1IsSlIqN1OcX+R0z75LpVt33Z9gdVfDcnGTxPVvhUM8vH2WB9wdsrEurr
        mIXk9sQyC6/mfFWwwNVB+rPuu+/CF/9f0Zu++Y+LHqNOQIyCWmbLuU23JqpeXi/4fH9MDgPf
        F8UPD/WieUq3nim73Bq95chnplvbw65+WHxW7H17nOSxBlvpvBVzlqp2JHCtaf5yfO7/tQqC
        PuePfOeoiG2c3PNViaU4I9FQi7moOBEAe70dkWgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWy7bCSnO6R7f3xBtOmWVk8mLeNzeLlz6ts
        FtM+/GS2WHRjG5PF5V1z2Cy6r+9gs1h+/B+TA7vH5SveHhMWHWD0+Pj0FotH35ZVjB6fN8l5
        tB/oZgpgi+KySUnNySxLLdK3S+DK2Ph5JVvBJ72KnX3PWRsYr2h1MXJwSAiYSBxvs+hi5OIQ
        EtjNKPHzdT9TFyMnUFxW4tm7HewQtrDE/ZYjrBBFzxglrp5dwAqSYBMwlHjfuIIZZJCIQIpE
        zyMvkDCzQIXEoc6njBD1BxglTjycBjaIU8BaYvazjWD1wgJeEg1PHUHCLAKqEjNmdYKFeQUs
        Je5MMwcJ8woISpyc+YQFYmSoxPP/16FOU5D4+XQZ2AUiAk4St9ZfZ4eoEZGY3dnGDFHjJvGi
        5QLjBEbhWUhGzUIyahaSFghbW+LpzadQNfIS29/OgYqbSzTcfsoIYStKTOl+yA5hW0r8uLmM
        ZQEjxypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOCI1dLcwbh91Qe9Q4xMHIyHGFWA
        2h9tWH2BUYolLz8vVUmEdwJrX7wQb0piZVVqUX58UWlOavEhRmkOFiVx3huFC+OEBNITS1Kz
        U1MLUotgskwcnFINTMFe+ls7T2RO8P++5XSspM97j5sxVeHC+f674nlba30uNHSf9/Vze344
        zXaqRlJpuGznBCkniZitq+RmNRv9ujkj1OPWXoY/MTHsDU53Qtf6hAvZmnLpbBecY7TbRGjy
        XDGrmv4Ss8PNXheenlH+aneq3MT3ddHJGtOeL1tO/jKLerny78S/Zyw9GJuW//pR3plcGr5K
        cR73jZab9YJRrM9V4uf/5M1a5bPMqcY24VBC1qvXqs+Vb18/ssTpVLXDs833TJ095T2UZ4SJ
        uwppTC65tuCA4Xwf5y0KlnFfexosps468rDxk8yqkzfO/z+yL21hiKwb39Ewtjovy99O1ldc
        9vY/vTXT4e93jjPpSizFGYmGWsxFxYkAkhPqC1MDAAA=
X-CMS-MailID: 20201021042333epcas2p2b794c192840431522a7da5d4ea9934cf
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d
References: <CGME20201020070519epcas2p27906d7db7c74e45f2acf8243ec2eae1d@epcas2p2.samsung.com>
        <20201020070516.129273-1-chanho61.park@samsung.com>
        <7fafcc82-2c42-8ef5-14a6-7906b5956363@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_000B_01D6A7AD.5F97E820
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"

Hi,

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Wednesday, October 21, 2020 12:15 PM
> To: Chanho Park <chanho61.park@samsung.com>; jejb@linux.ibm.com;
> martin.petersen@oracle.com
> Cc: alim.akhtar@samsung.com; avri.altman@wdc.com; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] scsi: ufs: make sure scan sequence for multiple
hosts
> 
> On 10/20/20 12:05 AM, Chanho Park wrote:
> > By doing scan as asynchronous way, scsi device scannning can be out of
> > order execution. It is no problem if there is a ufs host but the scsi
> > device name of each host can be changed according to the scan
sequences.
> >
> > Ideal Case) host0 scan first
> > host0 will be started from /dev/sda
> >  -> /dev/sdb (BootLUN0 of host0)
> >  -> /dev/sdc (BootLUN1 of host1)
> > host1 will be started from /dev/sdd
> >
> > This might be an ideal case and we can easily find the host device by
> > this mappinng.
> >
> > However, Abnormal Case) host1 scan first,
> > host1 will be started from /dev/sda and host0 will be followed later.
> >
> > To make sure the scan sequences according to the host, we can use a
> > bitmap which hosts are scanned and wait until previous hosts are
> > finished to scan.
> 
> This sounds completely wrong to me. No code should depend on the order in
> which LUNs are scanned. Please use the soft links created by udev instead
> of serializing LUN scanning.
> 

Thanks for your review.
Did you mean /dev/disk/by-[part]label/ symlink? It's quite reasonable to
use them by udev in userspace such as initramfs but some cases does not use
initramfs or initrd. In that case, we need to load the root
device(/dev/sda[N]) directly from kernel.
Anyway, scsi disk(sd) case, the scan order will not be changed until the
port has changed so they'll have permanent device names. I'd like to make
permanent UFS device names.

Best Regards,
Chanho Park

------=_NextPart_000_000B_01D6A7AD.5F97E820
Content-Type: application/ms-tnef; name="winmail.dat"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="winmail.dat"

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
UE0AAAAArL8=

------=_NextPart_000_000B_01D6A7AD.5F97E820--

