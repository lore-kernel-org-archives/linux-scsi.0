Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D67AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 03:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E9ED22B43
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 03:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgLVDSe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 22:18:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64798 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLVDSe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2020 22:18:34 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20201222031750epoutp03394bea3502d770845f4d8a679506223a~S65uNAX3H2480424804epoutp03E
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 03:17:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20201222031750epoutp03394bea3502d770845f4d8a679506223a~S65uNAX3H2480424804epoutp03E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608607070;
        bh=joO3hEwrDODguFpbbuJPH3Z+7IFab39yZFFcXqCg8PU=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=GGKaekHpZIb1dR8hQs3RAyq6t9egOMHr11mJviqrySxqStceHKZ6UzyY3ruUoFk0X
         l4KSCI13aatDIbt3/mK4tKP/q+gSEPQFhJe/bdR80fOG2QrLVInTMzVSyvunA7qY4v
         00e716vlOcnJ8lpZDCQJpcDv4NrAqXfETZGGxkd8=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20201222031749epcas2p1a33b8e5512bbe566ae212aa3080f614c~S65tkNYPP0916909169epcas2p18;
        Tue, 22 Dec 2020 03:17:49 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4D0M3H2kxlzMqYkj; Tue, 22 Dec
        2020 03:17:47 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.18.52511.B5561EF5; Tue, 22 Dec 2020 12:17:47 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20201222031746epcas2p35feabf17ce16b89cfe657c6b2f2157c6~S65rE0Nkh0878008780epcas2p3y;
        Tue, 22 Dec 2020 03:17:46 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201222031746epsmtrp1dd70906b5b0a32516c38e796f9b0c496~S65rEBOZx1266212662epsmtrp1g;
        Tue, 22 Dec 2020 03:17:46 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-45-5fe1655be83a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9A.9A.08745.A5561EF5; Tue, 22 Dec 2020 12:17:46 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20201222031746epsmtip1e34053f4935a58054ffb31fb6475165e~S65qzKNi00423804238epsmtip1K;
        Tue, 22 Dec 2020 03:17:46 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Can Guo'" <cang@codeaurora.org>
Cc:     <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <asutoshd@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>,
        <bhoon95.kim@samsung.com>
In-Reply-To: <0cc3dc22424d2052c0cdde8b80aa237b@codeaurora.org>
Subject: RE: [PATCH v3 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Date:   Tue, 22 Dec 2020 12:17:46 +0900
Message-ID: <000101d6d811$052b0f40$0f812dc0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKBb/35OrXWyvcQ6ZNTC/HczCQ1gAHXDzBJAhlr/PICIcv5Gqh8rgcw
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJsWRmVeSWpSXmKPExsWy7bCmqW506sN4g48rhS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyaL7+g42i+XH/zFZ
        dN29wWix9N9bFgc+j8tXvD0u9/UyeUxYdIDR4/v6DjaPj09vsXj0bVnF6PF5k5xH+4FupgCO
        qBybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC7lRTK
        EnNKgUIBicXFSvp2NkX5pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJ
        ORnXHv5gKniiVPF5wQKWBsabcl2MnBwSAiYSOzpfsXQxcnEICexglFiwbx87hPOJUeJk1xEo
        5zOjxJQ3IBmIli9PvzJDJHYxSpy/uhOq6gWjxIt1d5lBqtgEtCWmPdzNCmKLCKhKvGs9zwZS
        xCxwkUniUkMv2ChOATuJn18+s4DYwgJuEi1fnjCB2CxADStn3AWzeQUsJb5OP8ECYQtKnJz5
        BMxmFjCQeH9uPjOErS2xbOFrZojzFCR+Pl0GtJgDaLGbxJHVNRAlIhKzO9ugSh5wSEybXgNS
        IiHgItHaag0RFpZ4dXwL1JNSEi/726Dseol9UxtYQc6XEOhhlHi67x8jRMJYYtazdkaIOcoS
        R25BXcYn0XH4LztEmFeio00IolpZ4tekyVCdkhIzb95hn8CoNAvJX7OQ/DULyV+zkDywgJFl
        FaNYakFxbnpqsVGBCXJsb2IEJ2otjx2Ms99+0DvEyMTBeIhRgoNZSYTXTOp+vBBvSmJlVWpR
        fnxRaU5q8SFGU2BQT2SWEk3OB+aKvJJ4Q1MjMzMDS1MLUzMjCyVx3iKDB/FCAumJJanZqakF
        qUUwfUwcnFINTCqBIrkrdrz2dgxcvKA1MoalNeH9EtPsd5dX1a6d69grP+vRY+V/z4/s1hO9
        tj5/7tyvVmkS+kfWsCq+uz3R/8CCm1yi3WxdsXmtdffCkjOjzonm+sem3TV3zvRykg/dMKVc
        h+/29Ad/a36lslScrzxiunVReNq9Sx/9wva1Whzf8ajm78PHLxrLN809t//qnN3cB1j8jzBx
        1J//KNlZlvXyW9ys+wsuN2TtPBK7RXTZ121cllxPeBP5YnM/XtbdutOk73zf/z3+e2fa/Fos
        v77j99THcaack7cVMa9jv3A/Pe5Ax6f5m5/InN/JFljbsIsrgNXXPrl+effeW+pB9ewmfjLy
        0yIuT5a+ldIjoqrEUpyRaKjFXFScCABmyr35XQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsWy7bCSnG5U6sN4g3t9uhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZNF9fQebxfLj/5gs
        uu7eYLRY+u8tiwOfx+Ur3h6X+3qZPCYsOsDo8X19B5vHx6e3WDz6tqxi9Pi8Sc6j/UA3UwBH
        FJdNSmpOZllqkb5dAlfG8wuT2AvuyFQsP/2JpYHxmFgXIyeHhICJxJenX5lBbCGBHYwSPZPr
        IeKSEid2PmeEsIUl7rccYe1i5AKqecYocWD5MhaQBJuAtsS0h7tZQWwRAVWJd63n2UCKmAUe
        MkksnHyDDaKjh0ni6LOfbCBVnAJ2Ej+/fAbrFhZwk2j58oQJxGYB6l454y6YzStgKfF1+gkW
        CFtQ4uTMJ2A2s4CRxLlD+9kgbG2JZQtfM0OcpyDx8+kyoCs4gK5wkziyugaiRERidmcb8wRG
        4VlIJs1CMmkWkkmzkLQsYGRZxSiZWlCcm55bbFhglJdarlecmFtcmpeul5yfu4kRHLFaWjsY
        96z6oHeIkYmD8RCjBAezkgivmdT9eCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeW
        pGanphakFsFkmTg4pRqYdOqNPXYFlWneOPjZQKDc/xrLs8mb5aYeypzEuolBPU3djKl35Sfx
        s9vtpyTsnPnpZHqd1KPrDFNv2PPsltCf9ufMyl06UgKGOTavpKpTJKcEFoS2/9vkuv/FMpc/
        Jx9LOK2etkxxBeMSQaWYuIUOV/wNa+zDrzaUeyZc7Gmudoj9FmijGn5fe8bpsvvGBRuuuKl7
        +9sUTGhLlWU5vN5p277dU2KLy+6Jn58Qc/KV0V+W76mtakbzpnNtSN/0c9txjwUi4R09hx2O
        fp33tiHY+9zGfCXDTr6NclO2ax+8eOWQ4LlCIW7FR+GX1jcu2t5W/umUd2iW8dPT6ZL57HF3
        l0a//v46tyhyzlUu7tMxSizFGYmGWsxFxYkAyUnsg0cDAAA=
X-CMS-MailID: 20201222031746epcas2p35feabf17ce16b89cfe657c6b2f2157c6
X-Msg-Generator: CA
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201222023244epcas2p2cb8f4f0b0b41a0eeb0207cd1b12ddd8c
References: <cover.1608603608.git.kwmad.kim@samsung.com>
        <CGME20201222023244epcas2p2cb8f4f0b0b41a0eeb0207cd1b12ddd8c@epcas2p2.samsung.com>
        <f79683fc5df0341047269fc73907e81109862abf.1608603608.git.kwmad.kim@samsung.com>
        <0cc3dc22424d2052c0cdde8b80aa237b@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2020-12-22 10:21, Kiwoong Kim wrote:
> > Exynos requires one scatterlist entry for smaller than page size, i.e.
> > 4KB. For the cases of dispatching commands with more than one
> > scatterlist entry and under 4KB size, Exynos behaves as follows:
> >
> > Given that a command to read something from device is dispatched with
> > two scatterlist entries that are named AAA and BBB. After dispatching,
> > host builds two PRDT entries and during transmission, device sends
> > just one DATA IN because device doesn't care on host dma.
>=20
> If my understanding is correct, above is same to all hosts, only below
> part is Exynos's behavior. Please correct me if I am wrong.
You're correct.

>=20
> > The host then tranfers
> > the whole data from start address of the area named AAA.
> > In consequebnce, the area that follows AAA would be corrupted.
>=20
> In consequence
>=20
> >
> >     =7C<------------->=7C
> >     +-------+------------         +-------+
> >     +  AAA  + (corrupted)   ...   +  BBB  +
> >     +-------+------------         +-------+
> >
>=20
> AFAIK, queue->dma_alignment is only used in the case of direct-io, i.e. i=
n
> blk_rq_map_user/kern(), which are mainly used in IOCTL.
> If a request's buffer len and/or buffer start addr is not aligned with
> queue->dma_alignment, bio.c will make a bounce bio such that the request
> get a new buffer which starts on a new page. After the bounce bio is
ended,
> the data in the bound bio will be copied to the initial buffer.
>=20
> So in this fix, you are making sure the AAA and BBB are all mapped to one
> bounce bio and stay in one bi_vec, so when we do map_sg they come in one
> sglist, please correct me if I am wrong.
>=20
> If my understanding is correct, what is the real use case here - why/how
> user starts a request which can generate more than one sglists whose size=
s
> are all under 4KB? I am just curious.
>=20
> Thanks,
>=20
> Can Guo.=20

You nearly exactly got what I=92m=20thinking.=0D=0AAnd=20I=20think=20there=
=20could=20be=20various=20cases=20making=20those=20situations,=0D=0Awhich=
=20are=20definitely=20up=20to=20user=20programs.=20That=20is=20the=20case=
=20using=0D=0Adifferent=20memory=20areas=20to=20contain=20something.=0D=0A=
=0D=0AThanks.=0D=0AKiwoong=20Kim=0D=0A>=20=0D=0A>=20>=20Signed-off-by:=20Ki=
woong=20Kim=20<kwmad.kim=40samsung.com>=0D=0A>=20>=20---=0D=0A>=20>=20=20dr=
ivers/scsi/ufs/ufs-exynos.c=20=7C=209=20+++++++++=0D=0A>=20>=20=201=20file=
=20changed,=209=20insertions(+)=0D=0A>=20>=0D=0A>=20>=20diff=20--git=20a/dr=
ivers/scsi/ufs/ufs-exynos.c=0D=0A>=20>=20b/drivers/scsi/ufs/ufs-exynos.c=20=
index=20a8770ff..8635d9d=20100644=0D=0A>=20>=20---=20a/drivers/scsi/ufs/ufs=
-exynos.c=0D=0A>=20>=20+++=20b/drivers/scsi/ufs/ufs-exynos.c=0D=0A>=20>=20=
=40=40=20-14,6=20+14,7=20=40=40=0D=0A>=20>=20=20=23include=20<linux/of_addr=
ess.h>=0D=0A>=20>=20=20=23include=20<linux/phy/phy.h>=0D=0A>=20>=20=20=23in=
clude=20<linux/platform_device.h>=0D=0A>=20>=20+=23include=20<linux/blkdev.=
h>=0D=0A>=20>=0D=0A>=20>=20=20=23include=20=22ufshcd.h=22=0D=0A>=20>=20=20=
=23include=20=22ufshcd-pltfrm.h=22=0D=0A>=20>=20=40=40=20-1193,6=20+1194,13=
=20=40=40=20static=20int=20exynos_ufs_resume(struct=20ufs_hba=0D=0A>=20>=20=
*hba,=20enum=20ufs_pm_op=20pm_op)=0D=0A>=20>=20=20=09return=200;=0D=0A>=20>=
=20=20=7D=0D=0A>=20>=0D=0A>=20>=20+static=20void=20exynos_ufs_slave_configu=
re(struct=20scsi_device=20*sdev)=20=7B=0D=0A>=20>=20+=09struct=20request_qu=
eue=20*q=20=3D=20sdev->request_queue;=0D=0A>=20>=20+=0D=0A>=20>=20+=09blk_q=
ueue_update_dma_alignment(q,=20PAGE_SIZE=20-=201);=20=7D=0D=0A>=20>=20+=0D=
=0A>=20>=20=20static=20struct=20ufs_hba_variant_ops=20ufs_hba_exynos_ops=20=
=3D=20=7B=0D=0A>=20>=20=20=09.name=09=09=09=09=3D=20=22exynos_ufs=22,=0D=0A=
>=20>=20=20=09.init=09=09=09=09=3D=20exynos_ufs_init,=0D=0A>=20>=20=40=40=
=20-1204,6=20+1212,7=20=40=40=20static=20struct=20ufs_hba_variant_ops=0D=0A=
>=20>=20ufs_hba_exynos_ops=20=3D=20=7B=0D=0A>=20>=20=20=09.hibern8_notify=
=09=09=09=3D=20exynos_ufs_hibern8_notify,=0D=0A>=20>=20=20=09.suspend=09=09=
=09=3D=20exynos_ufs_suspend,=0D=0A>=20>=20=20=09.resume=09=09=09=09=3D=20ex=
ynos_ufs_resume,=0D=0A>=20>=20+=09.slave_configure=09=09=3D=20exynos_ufs_sl=
ave_configure,=0D=0A>=20>=20=20=7D;=0D=0A>=20>=0D=0A>=20>=20=20static=20int=
=20exynos_ufs_probe(struct=20platform_device=20*pdev)=0D=0A=0D=0A
