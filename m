Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF318C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 14:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ABC724954
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 14:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="A1DKTf7m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgEHO0h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 10:26:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:14682 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgEHO0g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 10:26:36 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200508142633epoutp02bba926d2131c31e19483b1b63cbb8012~NE8gddVMM0400004000epoutp02X
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 14:26:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200508142633epoutp02bba926d2131c31e19483b1b63cbb8012~NE8gddVMM0400004000epoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1588947993;
        bh=qJgUy4IMFj0K5N3SresA24W6Cz0ER/9akxjYN0Dhmr0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=A1DKTf7mfdl+a8FvKA6i9JJc9TlhRxgsvHAHZ6HpAgr9liKi9EXMAb2q78f85kXm9
         mb/eEpsHG2B4QxqwbMq8FfLuxr9B+2WpOCWlECO6/C9oP8oBFnyX/c2S6tledZ0opu
         f27decxneuBL5lvt9tRH70RqjuFi3odt6LKmGmnM=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200508142633epcas5p281d9261f05616c8d3d533b4ec9c4e1b5~NE8f7Srj-2972129721epcas5p2R;
        Fri,  8 May 2020 14:26:33 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.C5.23389.81C65BE5; Fri,  8 May 2020 23:26:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200508142632epcas5p381c470b7a1da0ccc683ae6944f69d248~NE8fan6zm1259012590epcas5p3l;
        Fri,  8 May 2020 14:26:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200508142632epsmtrp14a5c345c682cc3e1633c56f332e85799~NE8fZnzDb0119801198epsmtrp11;
        Fri,  8 May 2020 14:26:32 +0000 (GMT)
X-AuditID: b6c32a4b-7adff70000005b5d-e6-5eb56c18e443
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DE.63.18461.81C65BE5; Fri,  8 May 2020 23:26:32 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200508142628epsmtip2303280275302d6312062c2a1be36e3ca~NE8b0THJM1177711777epsmtip2W;
        Fri,  8 May 2020 14:26:28 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <huobean@gmail.com>,
        <asutoshd@codeaurora.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <beanhuo@micron.com>, <bvanassche@acm.org>,
        <tomas.winkler@intel.com>, <cang@codeaurora.org>,
        <rdunlap@infradead.org>, <seunguk.shin@samsung.com>
Cc:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hch@infradead.org>
In-Reply-To: <BYAPR04MB462904DA704A8FD42436BA9FFCA20@BYAPR04MB4629.namprd04.prod.outlook.com>
Subject: RE: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
Date:   Fri, 8 May 2020 19:56:16 +0530
Message-ID: <000401d62544$ab93ead0$02bbc070$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJO+B8HmB53n8gOhlSxo4VvqTv/wAGtj2ZpAcmq4aIBR3FF8aeGntbw
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGKsWRmVeSWpSXmKPExsWy7bCmlq5kztY4gxfnGS32tp1gt3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8XpCYuYLOacbWCyWHRjG5PF5V1z2Cy6r+9gs1h+/B+Txds701ks
        bm/hsli69SajxYeeOgd+j8tXvD0u9/UyeeycdZfdY/MKLY/Fe14yeUxYdIDRo+XkfhaP7+s7
        2Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDLaf3YxF5xVrvje9oatgfGj
        XBcjJ4eEgInEqgUHGLsYuTiEBHYzSkyc/5UdJCEk8IlRorU9GCLxjVHiwK7FzDAdi553sEAk
        9jJKHDwyAar9DaPEnVmbWECq2AR0JXYsbmMDSYgIHGGSuLq2HWwus0C4RM/LpYwgNqdArMSn
        FQfB4sICMRKzPnaxgdgsAioSV0/cAovzClhKzH0BEecVEJQ4OfMJC8QcbYllC19DnaQg8fPp
        MlYQW0TATeLTjEVQu8Qljv7sYQY5QkLgB4fEzI0PWSEaXCRab0EMlRAQlnh1fAs7hC0l8bK/
        DcjmALKzJXp2GUOEaySWzjvGAmHbSxy4MocFpIRZQFNi/S59iFV8Er2/nzBBdPJKdLQJQVSr
        SjS/uwrVKS0xsbsb6gAPiU0LHzBOYFScheSxWUgem4XkgVkIyxYwsqxilEwtKM5NTy02LTDO
        Sy3XK07MLS7NS9dLzs/dxAhOilreOxgfPfigd4iRiYPxEKMEB7OSCO/Eii1xQrwpiZVVqUX5
        8UWlOanFhxilOViUxHkfNwKlBNITS1KzU1MLUotgskwcnFINTAXOXHclOLMaZ6Ubrb/16f0E
        tZdZVyvCDH9PFWXo8TbN+3A3lPFCwZnZ748eeXz0qN6vwld2NTYqKo8uNetm1azevs/4U1VD
        aN7UK7ubTCK/xH3OPOxuM7fwT1bJ248RrkGL45/X977n6zc5qR/xX0OW48nVGRcsLs6ad//k
        +/wT7VbX51YVn6velGR7JGBuaNyZzVOdGC/F7EiUiDJM4v7378ohjpUpVi4GJ/fXPHa77fnn
        9ca/3jOTFq9ONdTP2VhyaMeqRCZ7af126duVDD+OXa17/yLyupHNgk8JuR4OiyUVnJNSd0+5
        ZLZ29qJnzz+tDlz3ZaLOtK7Dp+Uu79mqu+tK6e3Zkmryi63zN+spsRRnJBpqMRcVJwIAG6/I
        i/kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWy7bCSvK5EztY4g5k/ZCz2tp1gt3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8XpCYuYLOacbWCyWHRjG5PF5V1z2Cy6r+9gs1h+/B+Txds701ks
        bm/hsli69SajxYeeOgd+j8tXvD0u9/UyeeycdZfdY/MKLY/Fe14yeUxYdIDRo+XkfhaP7+s7
        2Dw+Pr3F4tG3ZRWjx+dNch7tB7qZAniiuGxSUnMyy1KL9O0SuDJunlvCXrBDvuL4m3uMDYxz
        JbsYOTkkBEwkFj3vYOli5OIQEtjNKNGzYTsLREJa4vrGCewQtrDEyn/P2SGKXjFKzPi0nhUk
        wSagK7FjcRsbSEJE4BKTxL4fr8E6mAUiJbYd+8QK0dHGJDF34WewBKdArMSnFQfBbGGBKIkL
        55+xgdgsAioSV0/cAovzClhKzH3RxQZhC0qcnPmEBWKotkTvw1ZGGHvZwtfMEOcpSPx8ugzs
        IhEBN4lPMxZBHSEucfRnD/MERuFZSEbNQjJqFpJRs5C0LGBkWcUomVpQnJueW2xYYJiXWq5X
        nJhbXJqXrpecn7uJERzhWpo7GLev+qB3iJGJg/EQowQHs5II78SKLXFCvCmJlVWpRfnxRaU5
        qcWHGKU5WJTEeW8ULowTEkhPLEnNTk0tSC2CyTJxcEo1MHk9Ef290PhemJJt4tl1+zZfXpml
        I/UnQss5n4eNsXyy1ldF7XOv7ntEfI20lBZfpvIqaf7J4JvVWecst6XuEHKqUE/38PvArXuU
        x/mxx07p1NCYn4EBj3QMQs69q5pfvUrj5XcOoac63KyCTCmTVm75fElISyZjQtsPu/zCb+cn
        2xyc0+S4tU/dn+3s7qKH54OMatjKhZo9Dk9cNSu0+/rdky6/VwbcX3LWXu+o1/RrTELJzzXt
        heYddzrBcHW61fuFrxinpWebm63JnRWs9tby/Ie1z00/ein/+C7H93BeplsFw3eD8/ZWotnX
        zq1/7nQoU8ZCS8f63NyN90Vc/4nzzaytefBW/apauFA3nxJLcUaioRZzUXEiAMMM+VpfAwAA
X-CMS-MailID: 20200508142632epcas5p381c470b7a1da0ccc683ae6944f69d248
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200508113840epcas5p1cee545219dd59b64eeea287f17d34cde
References: <20200504142032.16619-1-beanhuo@micron.com>
        <20200504142032.16619-6-beanhuo@micron.com>
        <CGME20200508113840epcas5p1cee545219dd59b64eeea287f17d34cde@epcas5p1.samsung.com>
        <BYAPR04MB462904DA704A8FD42436BA9FFCA20@BYAPR04MB4629.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+ seunguk.shin (who is one of the original author of the HPB, in case he ha=
s some more improvement inputs)

Hi Bean,
I second Avri input on splitting this patch series into logical smaller pat=
ches, that will helps reviewers.
Also if you can add support to build HPB as kernel module that will be usef=
ul.=20
I am looking into the HPB 1.0 spec, will review your patches soon.

Regards,
Alim

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 08 May 2020 17:09
> To: huobean=40gmail.com; alim.akhtar=40samsung.com;
> asutoshd=40codeaurora.org; jejb=40linux.ibm.com; martin.petersen=40oracle=
.com;
> stanley.chu=40mediatek.com; beanhuo=40micron.com; bvanassche=40acm.org;
> tomas.winkler=40intel.com; cang=40codeaurora.org; rdunlap=40infradead.org
> Cc: linux-scsi=40vger.kernel.org; linux-kernel=40vger.kernel.org;
> hch=40infradead.org
> Subject: RE: =5BRESENT PATCH RFC v3 5/5=5D scsi: ufs: UFS Host Performanc=
e
> Booster(HPB) driver
>=20
> Hi Bean,
> This patch is =7E3,000 lines long.
> Is it possible to divide it into a series of a smaller, more reviewable p=
atches?
> E.g. it can be something like:
> 1) Init part I - Read HPB config
> 2) Init part II - prepare for L2P cache management (introduce here all th=
e new
> data structures, memory allocation, etc.)
> 3) L2P cache management - activation / inactivation / eviction handlers
> 4) Add response API
> 5) Add prep_fn handler - the flows that contruct HPB-READ command.
> Or any other division that makes sense to you.
>=20
> Also, Is there a way to avoid all those =23ifdefs everywhere?
>=20
> Thanks,
> Avri
>=20
>=20
> >
> > From: Bean Huo <beanhuo=40micron.com>
> >
> > This patch is to add support for the UFS Host Performance Booster (HPB
> > v1.0), which is used to improve UFS read performance, especially for
> > the random read.
> >
> > NAND flash-based storage devices, including UFS, have mechanisms to
> > translate logical addresses of requests to the corresponding physical
> > addresses of the flash storage. Traditionally this L2P mapping data is
> > loaded to the internal SRAM in the storage controller. When the
> > capacity of storage is larger, a larger size of SRAM for the L2P map
> > data is required. Since increased SRAM size affects the manufacturing
> > cost significantly, it is not cost-effective to allocate all the
> > amount of SRAM needed to keep all the Logical-address to
> > Physical-address (L2P) map data. Therefore, L2P map data, which is
> > required to identify the physical address for the requested IOs, can
> > only be partially stored in SRAM from NAND flash. Due to this partial
> > loading, accessing the flash address area where the L2P information
> > for that address is not loaded in the SRAM can result in serious perfor=
mance
> degradation.
> >
> > The HPB is a software solution for the above problem, which uses the
> > host=E2=80=99s=20system=20memory=20as=20a=20cache=20for=20the=20FTL=20L=
2P=20mapping=20table.=20It=20does=0D=0A>=20>=20not=20need=20additional=20ha=
rdware=20support=20from=20the=20host=20side.=20By=20using=20HPB,=0D=0A>=20>=
=20the=20L2P=20mapping=20table=20can=20be=20read=20from=20host=20memory=20a=
nd=20stored=20in=0D=0A>=20>=20host-side=20memory.=20while=20reading=20the=
=20operation,=20the=20corresponding=20L2P=0D=0A>=20>=20information=20will=
=20be=20sent=20to=20the=20UFS=20device=20along=20with=20the=20reading=0D=0A=
>=20>=20request.=20Since=20the=20L2P=20entry=20is=20provided=20in=20the=20r=
ead=20request,=20UFS=0D=0A>=20>=20device=20does=20not=20have=20to=20load=20=
L2P=20entry=20from=20flash=20memory.=0D=0A>=20>=20This=20will=20significant=
ly=20improve=20random=20read=20performance.=0D=0A>=20>=0D=0A>=20>=20Signed-=
off-by:=20Bean=20Huo=20<beanhuo=40micron.com>=0D=0A>=20>=20---=0D=0A>=20>=
=20=20drivers/scsi/ufs/Kconfig=20=20=7C=20=20=2062=20+=0D=0A>=20>=20=20driv=
ers/scsi/ufs/Makefile=20=7C=20=20=20=201=20+=0D=0A>=20>=20=20drivers/scsi/u=
fs/ufshcd.c=20=7C=20=20234=20+++-=0D=0A>=20>=20=20drivers/scsi/ufs/ufshcd.h=
=20=7C=20=20=2023=20+=0D=0A>=20>=20=20drivers/scsi/ufs/ufshpb.c=20=7C=20276=
7=0D=0A>=20>=20+++++++++++++++++++++++++++++++++++++=0D=0A>=20>=20=20driver=
s/scsi/ufs/ufshpb.h=20=7C=20=20423=20++++++=0D=0A>=20>=20=206=20files=20cha=
nged,=203504=20insertions(+),=206=20deletions(-)=20=20create=20mode=0D=0A>=
=20>=20100644=20drivers/scsi/ufs/ufshpb.c=20=20create=20mode=20100644=0D=0A=
>=20>=20drivers/scsi/ufs/ufshpb.h=0D=0A>=20>=0D=0A=0D=0A
