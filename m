Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6556FC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 16:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FA0120663
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 16:15:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IUzfOVGo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgFOQPp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 12:15:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:61755 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbgFOQPo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2020 12:15:44 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200615161541epoutp02a9f6ca1f2cec5f8ec4b964a22998e841~Yw8pD8pRE0654306543epoutp02b
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2020 16:15:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200615161541epoutp02a9f6ca1f2cec5f8ec4b964a22998e841~Yw8pD8pRE0654306543epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592237741;
        bh=yn3ZGD3Sx3u9Xx0Gs4zDm9kZr9Wmnca8BtW7gNrs0f8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=IUzfOVGo6yNO6b1tEEYeyqjPNpsYXTtZdOY2FjFOZ1scE5bh3S29H5gNQrEW4RNu2
         apyQ0IfM2BVOvh4ypvUsO8ZMDJLE7U8DXObmAAs0uz9B6wadfFt10VGrA8m4tUrcTq
         ho0m4749DnkcCfXqtmVxO7jClZWSSPK8GLbfNphg=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200615161540epcas5p1f284bbb11bcb5d84ed0d6753d9f957ef~Yw8oM0xY_2011020110epcas5p1f;
        Mon, 15 Jun 2020 16:15:40 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        EE.85.09475.CAE97EE5; Tue, 16 Jun 2020 01:15:40 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200615161539epcas5p26241107c8eaabfae1edafc35256091e0~Yw8nBstNa1810518105epcas5p28;
        Mon, 15 Jun 2020 16:15:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200615161539epsmtrp26cfc9488f423cfe861fe655a0ca4588c~Yw8nA3U8o0928009280epsmtrp2R;
        Mon, 15 Jun 2020 16:15:39 +0000 (GMT)
X-AuditID: b6c32a4b-389ff70000002503-18-5ee79eacead8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.B0.08303.BAE97EE5; Tue, 16 Jun 2020 01:15:39 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200615161536epsmtip1dffc161c3bdee0e92186109a3b7e45a6~Yw8kCavY91507915079epsmtip1I;
        Mon, 15 Jun 2020 16:15:36 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzk@kernel.org>
Cc:     <robh@kernel.org>, <devicetree@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <kwmad.kim@samsung.com>,
        <stanley.chu@mediatek.com>, <cang@codeaurora.org>,
        <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
In-Reply-To: <20200614110202.GA9009@kozik-lap>
Subject: RE: [RESEND PATCH v10 10/10] arm64: dts: Add node for ufs exynos7
Date:   Mon, 15 Jun 2020 21:45:34 +0530
Message-ID: <000001d64330$35947020$a0bd5060$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG4t7PjQZEdjsbMgiywO+bF2ZMTLwIE8gPVATQJid0Cb/nUPqjnqNbQ
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsWy7bCmpu6aec/jDF590bN4+fMqm8Wn9ctY
        LeYfOcdqceFpD5vF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1Zxehx/MZ2Jo/Pm+Q82g90MwVw
        RnHZpKTmZJalFunbJXBl7N1zg7FgEnvFpcPrmBsYr7N1MXJySAiYSOxYeZ6xi5GLQ0hgN6PE
        poc3GUESQgKfGCW6fjhAJD4zShzdcpcFpuP53XYmiKJdjBLzj5tBFL1hlJi4/irYWDYBXYkd
        i9vAbBEge/ON5ewgRcwCt5gknl/5zAqS4BTQk7gy8QZYkbCAl8TiUxPBVrMIqEp8mHQZrIZX
        wFLi4dPXULagxMmZT8CuYBbQlli28DUzxEUKEj+fLmOFWOYmMf3LPkaIGnGJoz97mEEWSwjc
        4JDonrGNFaLBReLXsQdMELawxKvjW9ghbCmJz+/2Ah3EAWRnS/TsMoYI10gsnXcM6nt7iQNX
        5rCAlDALaEqs36UPsYpPovf3EyaITl6JjjYhiGpVieZ3V6E6pSUmdndDHeAhcaB9H/sERsVZ
        SB6bheSxWUgemIWwbAEjyypGydSC4tz01GLTAuO81HK94sTc4tK8dL3k/NxNjOA0p+W9g/HR
        gw96hxiZOBgPMUpwMCuJ8B6Sfx4nxJuSWFmVWpQfX1Sak1p8iFGag0VJnFfpx5k4IYH0xJLU
        7NTUgtQimCwTB6dUA5PPb4eG5lsJl+WeRRdM594+q2WdqM2bj7aG0hu3Llj7bmFHeovFuQId
        ybu1epe+dYld0JD7fOpfz8rdH5uWZmSWrnlxLJO3zmzZwZbjIa7T+PzXnHu2LPlFp72rdOHK
        B1n7tN9+CD7xJXHKM6a5yoG7hMp6CratvMp/cX7IE5+dzMo/75/Y3f8s3X1xnIy5T5TNoUMX
        vnbfEiqWj4u6xfo+WsrCvfuOK9f2bdo62fEzOO98z+r47F0R+ttv1dTVHGLfu3U33dm+/vCT
        2y/jFO5vkY17PSmEd/nJM6kZ+5LfhxooOH+Lush04883VhHv76d1hY8H3LLe61zw/Ia9sdDX
        v836IVdNfh7fslPqXfgGJZbijERDLeai4kQALx9+vuIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWy7bCSnO7qec/jDBZdlrR4+fMqm8Wn9ctY
        LeYfOcdqceFpD5vF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1Zxehx/MZ2Jo/Pm+Q82g90MwVw
        RnHZpKTmZJalFunbJXBlbFvXxFKwhbXizrNVLA2My1i6GDk5JARMJJ7fbWfqYuTiEBLYwShx
        5m0LI0RCWuL6xgnsELawxMp/z9khil4xSizrbGUDSbAJ6ErsWNwGZosA2ZtvLAcrYhZ4xiSx
        /tx/qI5HjBKXmqazglRxCuhJXJl4A6xDWMBLYvGpiWDrWARUJT5MugxWwytgKfHw6WsoW1Di
        5MwnYLcyC2hLPL35FM5etvA1M8R5ChI/ny5jhbjCTWL6l32MEDXiEkd/9jBPYBSehWTULCSj
        ZiEZNQtJywJGllWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMFRq6W1g3HPqg96hxiZ
        OBgPMUpwMCuJ8B6Sfx4nxJuSWFmVWpQfX1Sak1p8iFGag0VJnPfrrIVxQgLpiSWp2ampBalF
        MFkmDk6pBqYZyWntagy+f8tqF37x2fzmlJrYzOg9bV83LBMRtKxsW7l5ZkfKuamR/9YpTe7U
        aw2c4JIkxr3iRhxD0adLn01+TOs9lVgVsNmpKOxM1LHF7Hf76779u+c71XW+vNZz6+A3WzXP
        L/x6MO5mX9rXzVo9AimeqlNCRFOSGS75nl5+RuLe9GnWzx5abZP4OH9q6ZKruzTWu5Tfm5BY
        anG2UH7/sYmxp7xSO/lefGfiWzCh86/nwngN2ZLJc3YHiBqbXRLu8Hw3/77Vllm7+QPOb59i
        sVj5anCjsHDkkX1y8w83W7ZGc104wqd8/TbL1lVzVKYfiVcu60r7Z712bq6qep/ZZP5Yw+16
        RzauSzc2OiKhxFKckWioxVxUnAgAVKBKmkkDAAA=
X-CMS-MailID: 20200615161539epcas5p26241107c8eaabfae1edafc35256091e0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030458epcas5p3f9667bab202d99fb332d5bf5aad63c85
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030458epcas5p3f9667bab202d99fb332d5bf5aad63c85@epcas5p3.samsung.com>
        <20200613024706.27975-11-alim.akhtar@samsung.com>
        <20200614110202.GA9009@kozik-lap>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Sat, Jun 13, 2020 at 08:17:06AM +0530, Alim Akhtar wrote:
> > Adding dt node foe UFS and UFS-PHY for exynos7 SoC.
> >
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > Tested-by: Pawe=C5=82=20Chmiel=20<pawel.mikolaj.chmiel=40gmail.com>=0D=
=0A>=20>=20---=0D=0A>=20>=20=20.../boot/dts/exynos/exynos7-espresso.dts=20=
=20=20=20=20=20=7C=20=204=20++=0D=0A>=20>=20=20arch/arm64/boot/dts/exynos/e=
xynos7.dtsi=20=20=20=20=20=20=20=7C=2043=20++++++++++++++++++-=0D=0A>=20>=
=20=202=20files=20changed,=2045=20insertions(+),=202=20deletions(-)=0D=0A>=
=20>=0D=0A>=20=0D=0A>=20This=20is=20already=20applied=20and=20in=20the=20li=
nux-next.=20=20Don't=20resend=20applied=20patches.=0D=0A>=20=0D=0ASorry=20K=
rzysztof,=20did=20not=20realized=20that=20this=20was=20already=20landed=20i=
n=20Linux-next,=20=20your=20point=20taken.=0D=0A=0D=0A>=20Best=20regards,=
=0D=0A>=20Krzysztof=0D=0A=0D=0A
