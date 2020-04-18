Return-Path: <SRS0=0GAJ=6C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2239C3A5A0
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 13:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9236020780
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Apr 2020 13:08:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="TKP6Dzo+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgDRNIb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Apr 2020 09:08:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45490 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgDRNIa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Apr 2020 09:08:30 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200418130828epoutp04767d436471028c2cb0eb949d91382e2e~G6_necNif0981309813epoutp04F
        for <linux-scsi@vger.kernel.org>; Sat, 18 Apr 2020 13:08:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200418130828epoutp04767d436471028c2cb0eb949d91382e2e~G6_necNif0981309813epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587215308;
        bh=2oam/epN3FCBacMtvE1UAmxv8LZe2ptU3vW+pCn6n3M=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=TKP6Dzo+tvEkRV9Bd094zD4dKs8EyKOMBpx3GLJbqZcH+B+lTyYBuJTE5j5IdXzi9
         uhX/9kejM1q0RUJxzywv3oPc/UJuuvp4Q5g75Elr9RXkfG6Cg7vb9VGUX4Kn3tTqz5
         dDUeMxo1hOOW7JgBuV4PTW5jNNtwWFXp8s/GVAUQ=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200418130826epcas5p2ee3a41f3c7b960b06dcc94cf07670058~G6_mDNO7N2178721787epcas5p2d;
        Sat, 18 Apr 2020 13:08:26 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        62.B1.04736.ACBFA9E5; Sat, 18 Apr 2020 22:08:26 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200418130826epcas5p411cbf07b9ccbc0b17f829ac20451627d~G6_lmI9EF3188131881epcas5p4A;
        Sat, 18 Apr 2020 13:08:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200418130826epsmtrp2dd31965e35e759bba2b56163385e26a4~G6_llVVPR0489004890epsmtrp2F;
        Sat, 18 Apr 2020 13:08:26 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-77-5e9afbca4d54
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.E5.04024.ACBFA9E5; Sat, 18 Apr 2020 22:08:26 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200418130823epsmtip1430400b72b2507e6e3fa98bb740e8ffc~G6_i4A5F01834418344epsmtip1F;
        Sat, 18 Apr 2020 13:08:23 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <robh@kernel.org>
Cc:     <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <krzk@kernel.org>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <SN6PR04MB46402211952BC3D427AADA00FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v6 0/10] exynos-ufs: Add support for UFS HCI
Date:   Sat, 18 Apr 2020 18:38:21 +0530
Message-ID: <002a01d61582$72250990$566f1cb0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ+JYn7iegE7csgtlAtGJi8waFUgQJQDPilAZpCPd2nD2XiwA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0gUURTHubOzs+Pmxm21PCmkLRipqZVFo4lJhU0PIaEIorRNJxV11Z2y
        tCQzMfOVRVAuZi9dwTRl1dh8v239oKH5TjG0l8qKGqEIlbuj5Ld7zv397v8cuLRI/lFsS4er
        rnJqlTJSQUnJdy1OTq6dy5rA3Y1l7szPpT6KmS/TipnnrV1ipru7XMIMVbaRjG6iX8z0VudR
        zNPueoLJGNBTTFHHH4L5W6uXMIVVQ8jXku3NziJYXfF9iq0ouM2mGBpIdu7rMMlmVxYjdkG3
        jb3XmEGcps9LvUO4yPA4Tu3uc0kaNvbkExVTuOFGaatrEiqySEcWNOB9MPvlgygdSWk5rkGw
        2PKLEIp5BAuldyih+I3AUDJErSmLPaWrSh2C4RE9EooZBEnGBomJorAr6F+nmg1r7A1v2nPM
        T4lwOQHNDWUrOk1b4IvQUbHXxFhhXxj//s3sktgRJt4uSkyIDHvC92rO1JbhTWDInSRNZxF2
        Ae3LaZEwkAMsfdWKhajDMDjVTgiMDbQtZZoHBayVQId+mRSEo9BVkrW6jRVMdVRKhLMtLBjr
        KFMu4AjIrPYQ2regML99VT0EjZ/ySBMiwk5QVu0uRG2ErOVJQjBlkJYqF2hHuGvsWzXt4GFG
        hlhAWJh+EpyDtmvW7aVZt5dm3fya/1kvEFmMtnIxfFQox++P8VBx1914ZRR/TRXqFhwdpUPm
        f+Z8Uo90XaeaEaaRwlKWlp0bKBcr4/j4qGYEtEhhLWvyW2nJQpTxCZw6Okh9LZLjm5EdTSps
        ZI/EfRfkOFR5lYvguBhOvXZL0Ba2ScirNWV5wb4NzQ6cGKH56PEddgWXpTeTB/2lVflbcE2s
        KujHscc+k+FShfa9JvtBjepZaGxvWMCRUYfEltqE5L0ShzOE/7mIej9tqnHG9WxPYpXhszE+
        wa6cvuLS3308bm5nZ5PaNsB/6aC3p7E/rpPfbLAfe+V1IDp1zr93dHKXguTDlHucRWpe+Q98
        UUguYwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWy7bCSnO6p37PiDHbNF7J4+fMqm8Wn9ctY
        LeYfOcdqcf78BnaLm1uOslhsenyN1eLyrjlsFjPO72Oy6L6+g81i+fF/TBb/9+xgt1i69Saj
        A4/H5b5eJo9NqzrZPDYvqfdoObmfxePj01ssHn1bVjF6fN4k59F+oJspgCOKyyYlNSezLLVI
        3y6BK2PRfbWCLu6KzW2NjA2MXZxdjJwcEgImEj8urWXuYuTiEBLYzSjRt3ALK0RCWuL6xgns
        ELawxMp/z9khil4xSkx4+gYswSagK7FjcRsbiC0iYCfxavJFRpAiZoFdTBJb721jgui4zyhx
        ePdkoCoODk6BWInjm41AGoQFHCQePH8GNohFQFXi8bof7CAlvAKWEs93pYKEeQUEJU7OfMIC
        YjMLaEs8vfkUzl628DUzxHEKEj+fLmOFuMFJ4sarY0wQNeISR3/2ME9gFJ6FZNQsJKNmIRk1
        C0nLAkaWVYySqQXFuem5xYYFhnmp5XrFibnFpXnpesn5uZsYwbGppbmD8fKS+EOMAhyMSjy8
        Bj0z44RYE8uKK3MPMUpwMCuJ8B50AwrxpiRWVqUW5ccXleakFh9ilOZgURLnfZp3LFJIID2x
        JDU7NbUgtQgmy8TBKdXAGLKew0jVq+vDFJkLfB9PfF8hnBfiKP6qpLjn9bKzswv3v9aZULbs
        N2fiY0Hlc45NlWsjrm5c+m9/24Ikd/8iydSJMeXCs1ieH/TTuX9QNmHNn4LFkSJ1tyNKm6e3
        1r4xecYl5OAt+Lamp6N7ZsvHulnXl516dvhoytpDV4uP15zu1duVfe/QciWW4oxEQy3mouJE
        APmZZKnJAgAA
X-CMS-MailID: 20200418130826epcas5p411cbf07b9ccbc0b17f829ac20451627d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364
References: <CGME20200417181006epcas5p269f8c4b94e60962a0b0318ef64a65364@epcas5p2.samsung.com>
        <20200417175944.47189-1-alim.akhtar@samsung.com>
        <SN6PR04MB46402211952BC3D427AADA00FCD60@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 18 April 2020 18:09
> To: Alim Akhtar <alim.akhtar=40samsung.com>; robh=40kernel.org
> Cc: devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; krzk=40ke=
rnel.org;
> martin.petersen=40oracle.com; kwmad.kim=40samsung.com;
> stanley.chu=40mediatek.com; cang=40codeaurora.org; linux-samsung-
> soc=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-
> kernel=40vger.kernel.org
> Subject: RE: =5BPATCH v6 0/10=5D exynos-ufs: Add support for UFS HCI
>=20
>=20
> >
> > This patch-set introduces UFS (Universal Flash Storage) host
> > controller support for Samsung family SoC. Mostly, it consists of UFS
> > PHY and host specific driver.
> >
> > - Changes since v5:
> > * re-introduce various quicks which was removed because of no driver
> > * consumer of those quirks, initial 4 patches does the same.
> You forgot to add those quirks to ufs_fixups.

ufs_fixups are for ufs __device__ related quirks, what I have posted are al=
l host controller quirks.
Please have a look on the other quirks related to HCI like UFSHCD_QUIRK_BRO=
KEN_UFS_HCI_VERSION
Which is used in other vendor HCI driver.=20
Let me know if I am missing anything here.

> Each patch that introduces a quirk needs to introduce its users as well -=
 This is
> the reason it was removed in the first place.
>=20
> Thanks,
> Avri

