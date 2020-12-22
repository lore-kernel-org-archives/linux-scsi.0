Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78A9C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 04:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74F023122
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 04:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725856AbgLVEkn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 23:40:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60012 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbgLVEkm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 23:40:42 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201222043958epoutp01efe397658f5129ef4add78ec7a2b3062~S8BbjEbtH0074100741epoutp01j
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 04:39:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201222043958epoutp01efe397658f5129ef4add78ec7a2b3062~S8BbjEbtH0074100741epoutp01j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608611998;
        bh=8Ojeq7p+L41n/Uh/9ZN+ITWrYojI8CZzGtDc65AF2f4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Jgiip4fCoM4OhC4RzZoTWS141mrVo+usMPAOrwi38naMHa8sBV/a+2x8z4/DX2Smz
         8qku4FMpqNcOpqRcvRfDt1tdLeeYjMmYW+Ong6rmr6kALthfjKGzkcR+HdTJEAk073
         IdtL9VETqAcH9IwuYbOAC/5W+1UltzzVA3EotmKY=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20201222043957epcas2p383ac2d28bae188d1fb2f4e784b0389fb~S8BbFvmk61193211932epcas2p3e;
        Tue, 22 Dec 2020 04:39:57 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.189]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4D0Nt40LWYz4x9Q5; Tue, 22 Dec
        2020 04:39:56 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CB.FA.05262.B9871EF5; Tue, 22 Dec 2020 13:39:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201222043955epcas2p109cf6bf6b9d89e2b41ae12b3da2fe681~S8BY3CHJE2004120041epcas2p1h;
        Tue, 22 Dec 2020 04:39:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201222043955epsmtrp19f460ea111c15ffade32362d449e3182~S8BY2e8X21944419444epsmtrp1P;
        Tue, 22 Dec 2020 04:39:55 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-a5-5fe1789bb59c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        3F.B2.08745.A9871EF5; Tue, 22 Dec 2020 13:39:54 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201222043954epsmtip265fcf9d8c24ce7d84dd2cc30600772a1~S8BYmySsy2808728087epsmtip2P;
        Tue, 22 Dec 2020 04:39:54 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>
In-Reply-To: <b64d3be97470a3061ee07b60169b1923@codeaurora.org>
Subject: RE: [PATCH v3 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Date:   Tue, 22 Dec 2020 13:39:54 +0900
Message-ID: <000801d6d81c$7e9bc530$7bd34f90$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKBb/35OrXWyvcQ6ZNTC/HczCQ1gAHXDzBJAhlr/PICIcv5GgJeOZtzAmJl0ucBoR3WnqhJuLaQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmhe7siofxBk/+6Vh8Wr+M1aL7+g42
        ByaPy329TB6fN8kFMEXl2GSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qba
        Krn4BOi6ZeYAjVdSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al
        6yXn51oZGhgYmQJVJuRkrL63galgvU7Fu8bLzA2Mm9S7GDk5JARMJE4e/sjSxcjFISSwg1Fi
        39kHjBDOJyDn6E5WCOczo8T1lqOsMC0Hu5Ywg9hCArsYJXYuMYSwXzBKTOoxArHZBLQlpj3c
        DVYvIqAq8a71PBuIzSygIPH2214mEJtTwE7i+rs7YHOEBdwkWr48AYuzANXP/fwUzOYVsJRY
        duAlM4QtKHFy5hMWiDnaEssWvmaGuEdB4ufTZUC7OIB2RUncWVwAUSIiMbuzDarkGrvEn8N6
        ELaLxLI3nVCvCEu8Or6FHcKWknjZ3wZl10vsm9oA9ruEQA+jxNN9/xghEsYSs561M4LsYhbQ
        lFi/Sx/ElBBQljhyC+oyPomOw3/ZIcK8Eh1tQhCNyhK/Jk2GGiIpMfPmHfYJjEqzkPw1C8lf
        s5A8MAth1wJGllWMYqkFxbnpqcVGBcbIMb2JEZzutNx3MM54+0HvECMTB+MhRgkOZiURXjOp
        +/FCvCmJlVWpRfnxRaU5qcWHGE2BIT2RWUo0OR+YcPNK4g1NjczMDCxNLUzNjCyUxHmLDR7E
        CwmkJ5akZqemFqQWwfQxcXBKNTBxrjx6fcf02+872L9aOR5g9BNeauH/V1wv23eepFVqweGd
        lZdY/YWCRKy3SXTdK3ztY3kmOlnplk69q8Cb2d//WhxcLLMi7PICjwkJostWHum7vL3eQ0L8
        8oHmdr9p/Xv7c278VJCXWOl+1kOsXkYgPPXDhIkp6+wOZNWGZsbXPjALmuOpfdBqZ2INd/lt
        11CFuHNi2/e+j4iK0Gx/2vM8r3GR6Iwbft3ixZp/DeOv+8u9r/ko+EjPyExpw/Qned4cSorZ
        91iTzsmwrO1SLbUTdfTcEPbY5VhJf3Tdy7trZ73fwO/g+fZAIUvbhh1r3E5ffnvn5/rKDeH5
        uvo7Nz6IfbzhRuYCUd/2Z7ZyAkosxRmJhlrMRcWJAFW2WXcABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWy7bCSvO6siofxBqfmW1p8Wr+M1aL7+g42
        ByaPy329TB6fN8kFMEVx2aSk5mSWpRbp2yVwZRyc9Yqt4LZyRe+0ucwNjBekuxg5OSQETCQO
        di1hBrGFBHYwSvzpdoaIS0qc2PmcEcIWlrjfcoS1i5ELqOYZo8S8r5PZQBJsAtoS0x7uZgWx
        RQRUJd61ngeLMwsoSLz9tpcJomEes8SsNRdYQBKcAnYS19/dAdsmLOAm0fLlCROIzQLUPPfz
        UzCbV8BSYtmBl8wQtqDEyZlPWCCGakv0PmxlhLGXLXzNDHGdgsTPp8uAjuAAOiJK4s7iAogS
        EYnZnW3MExiFZyGZNAvJpFlIJs1C0rKAkWUVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7u
        JkZw8Gtp7WDcs+qD3iFGJg7GQ4wSHMxKIrxmUvfjhXhTEiurUovy44tKc1KLDzFKc7AoifNe
        6DoZLySQnliSmp2aWpBaBJNl4uCUamA6o/nyycb1DDPz9gWxzP1VxnAivcji5462U7Ok9y2a
        k317T/95XzfBPxsK/rhHPeByr157gOFnZWuB6a+lmgvWzY3O8xX7veXT7caVwoUqf/73rImf
        IM13X97zH39t6eMQJu99Lq4ZE2eJrv95t+rfTrXSY4t63/T/fdbUNKPf4fottp49cyUmrX87
        42JTQ8jD2QVfv17jaEkPm3cwdaH+tx1nvRN9WzQUevb831to+/psy4qczJsam3fdVeTOkYpb
        6OD35catI+6PK9IqrhuLrDjaUM6W/uLP9/lx6wK2HXFiEpF33rs6/OHP2EX3v8/+uXiP2IKD
        liERZiWFoddjPijzxmrs61+7feYB6yL+nUosxRmJhlrMRcWJAPS1jzDtAgAA
X-CMS-MailID: 20201222043955epcas2p109cf6bf6b9d89e2b41ae12b3da2fe681
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222023244epcas2p2cb8f4f0b0b41a0eeb0207cd1b12ddd8c
References: <cover.1608603608.git.kwmad.kim@samsung.com>
        <CGME20201222023244epcas2p2cb8f4f0b0b41a0eeb0207cd1b12ddd8c@epcas2p2.samsung.com>
        <f79683fc5df0341047269fc73907e81109862abf.1608603608.git.kwmad.kim@samsung.com>
        <0cc3dc22424d2052c0cdde8b80aa237b@codeaurora.org>
        <000101d6d811$052b0f40$0f812dc0$@samsung.com>
        <dc8f95bd2aafc5f9e0ee58c58f075d29@codeaurora.org>
        <b64d3be97470a3061ee07b60169b1923@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2020-12-22 11:34, Can Guo wrote:
> > On 2020-12-22 11:17, Kiwoong Kim wrote:
> >>> On 2020-12-22 10:21, Kiwoong Kim wrote:
> >>> > Exynos requires one scatterlist entry for smaller than page size,
> i.e.
> >>> > 4KB. For the cases of dispatching commands with more than one
> >>> > scatterlist entry and under 4KB size, Exynos behaves as follows:
> >>> >
> >>> > Given that a command to read something from device is dispatched
> >>> > with two scatterlist entries that are named AAA and BBB. After
> >>> > dispatching, host builds two PRDT entries and during transmission,
> >>> > device sends just one DATA IN because device doesn't care on host
> dma.
> >>>
> >>> If my understanding is correct, above is same to all hosts, only
> >>> below part is Exynos's behavior. Please correct me if I am wrong.
> >> You're correct.
> >>
> >>>
> >>> > The host then tranfers
> >>> > the whole data from start address of the area named AAA.
> >>> > In consequebnce, the area that follows AAA would be corrupted.
> >>>
> >>> In consequence
> >>>
> >>> >
> >>> >     =7C<------------->=7C
> >>> >     +-------+------------         +-------+
> >>> >     +  AAA  + (corrupted)   ...   +  BBB  +
> >>> >     +-------+------------         +-------+
> >>> >
> >>>
> >>> AFAIK, queue->dma_alignment is only used in the case of direct-io,
> >>> i.e. in
> >>> blk_rq_map_user/kern(), which are mainly used in IOCTL.
> >>> If a request's buffer len and/or buffer start addr is not aligned
> >>> with
> >>> queue->dma_alignment, bio.c will make a bounce bio such that the
> >>> request
> >>> get a new buffer which starts on a new page. After the bounce bio is
> >> ended,
> >>> the data in the bound bio will be copied to the initial buffer.
> >>>
> >>> So in this fix, you are making sure the AAA and BBB are all mapped to
> >>> one
> >>> bounce bio and stay in one bi_vec, so when we do map_sg they come in
> >>> one
> >>> sglist, please correct me if I am wrong.
> >>>
> >>> If my understanding is correct, what is the real use case here -
> >>> why/how
> >>> user starts a request which can generate more than one sglists whose
> >>> sizes
> >>> are all under 4KB? I am just curious.
> >>>
> >>> Thanks,
> >>>
> >>> Can Guo.
> >>
> >> You nearly exactly got what I=E2=80=99m=20thinking.=0D=0A>=20>>=20And=
=20I=20think=20there=20could=20be=20various=20cases=20making=20those=20situ=
ations,=0D=0A>=20>>=20which=20are=20definitely=20up=20to=20user=20programs.=
=20That=20is=20the=20case=20using=0D=0A>=20>>=20different=20memory=20areas=
=20to=20contain=20something.=0D=0A>=20>>=0D=0A>=20>=0D=0A>=20=0D=0A>=20Hi=
=20Kiwoong,=0D=0A>=20=0D=0A>=20Sorry=20if=20I=20made=20you=20confused.=20I=
=20think=20I=20know=20your=20intention=20here=20now.=0D=0A>=20When=20bio.c=
=20makes=20the=20bounce=20bio,=20it=20allocates=20one=20new=20page=20and=0D=
=0A>=20add=20this=20page=20to=20the=20bounce=20bio.=20In=20this=20way,=20on=
ly=20one=20bi_vec=20is=0D=0A>=20needed=20and=20only=20one=20sglist=20entry=
=20shall=20be=20generated.=20Am=20I=20right?=0D=0A>=20=0D=0A>=20Thanks,=0D=
=0A>=20=0D=0A>=20Can=20Guo.=20=0D=0A=0D=0AYes,=20that's=20it.=0D=0A=0D=0A=
=0D=0AThanks.=0D=0AKiwoong=20Kim=0D=0A>=20>=0D=0A>=20>>=20Thanks.=0D=0A>=20=
>>=20Kiwoong=20Kim=0D=0A>=20>>>=0D=0A>=20>>>=20>=20Signed-off-by:=20Kiwoong=
=20Kim=20<kwmad.kim=40samsung.com>=0D=0A>=20>>>=20>=20---=0D=0A>=20>>>=20>=
=20=20drivers/scsi/ufs/ufs-exynos.c=20=7C=209=20+++++++++=0D=0A>=20>>>=20>=
=20=201=20file=20changed,=209=20insertions(+)=0D=0A>=20>>>=20>=0D=0A>=20>>>=
=20>=20diff=20--git=20a/drivers/scsi/ufs/ufs-exynos.c=0D=0A>=20>>>=20>=20b/=
drivers/scsi/ufs/ufs-exynos.c=20index=20a8770ff..8635d9d=20100644=0D=0A>=20=
>>>=20>=20---=20a/drivers/scsi/ufs/ufs-exynos.c=0D=0A>=20>>>=20>=20+++=20b/=
drivers/scsi/ufs/ufs-exynos.c=0D=0A>=20>>>=20>=20=40=40=20-14,6=20+14,7=20=
=40=40=0D=0A>=20>>>=20>=20=20=23include=20<linux/of_address.h>=0D=0A>=20>>>=
=20>=20=20=23include=20<linux/phy/phy.h>=0D=0A>=20>>>=20>=20=20=23include=
=20<linux/platform_device.h>=0D=0A>=20>>>=20>=20+=23include=20<linux/blkdev=
.h>=0D=0A>=20>>>=20>=0D=0A>=20>>>=20>=20=20=23include=20=22ufshcd.h=22=0D=
=0A>=20>>>=20>=20=20=23include=20=22ufshcd-pltfrm.h=22=0D=0A>=20>>>=20>=20=
=40=40=20-1193,6=20+1194,13=20=40=40=20static=20int=20exynos_ufs_resume(str=
uct=20ufs_hba=0D=0A>=20>>>=20>=20*hba,=20enum=20ufs_pm_op=20pm_op)=0D=0A>=
=20>>>=20>=20=20=09return=200;=0D=0A>=20>>>=20>=20=20=7D=0D=0A>=20>>>=20>=
=0D=0A>=20>>>=20>=20+static=20void=20exynos_ufs_slave_configure(struct=20sc=
si_device=20*sdev)=20=7B=0D=0A>=20>>>=20>=20+=09struct=20request_queue=20*q=
=20=3D=20sdev->request_queue;=0D=0A>=20>>>=20>=20+=0D=0A>=20>>>=20>=20+=09b=
lk_queue_update_dma_alignment(q,=20PAGE_SIZE=20-=201);=20=7D=0D=0A>=20>>>=
=20>=20+=0D=0A>=20>>>=20>=20=20static=20struct=20ufs_hba_variant_ops=20ufs_=
hba_exynos_ops=20=3D=20=7B=0D=0A>=20>>>=20>=20=20=09.name=09=09=09=09=3D=20=
=22exynos_ufs=22,=0D=0A>=20>>>=20>=20=20=09.init=09=09=09=09=3D=20exynos_uf=
s_init,=0D=0A>=20>>>=20>=20=40=40=20-1204,6=20+1212,7=20=40=40=20static=20s=
truct=20ufs_hba_variant_ops=0D=0A>=20>>>=20>=20ufs_hba_exynos_ops=20=3D=20=
=7B=0D=0A>=20>>>=20>=20=20=09.hibern8_notify=09=09=09=3D=20exynos_ufs_hiber=
n8_notify,=0D=0A>=20>>>=20>=20=20=09.suspend=09=09=09=3D=20exynos_ufs_suspe=
nd,=0D=0A>=20>>>=20>=20=20=09.resume=09=09=09=09=3D=20exynos_ufs_resume,=0D=
=0A>=20>>>=20>=20+=09.slave_configure=09=09=3D=20exynos_ufs_slave_configure=
,=0D=0A>=20>>>=20>=20=20=7D;=0D=0A>=20>>>=20>=0D=0A>=20>>>=20>=20=20static=
=20int=20exynos_ufs_probe(struct=20platform_device=20*pdev)=0D=0A=0D=0A
