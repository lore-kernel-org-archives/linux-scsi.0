Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C59C11F66
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 02:58:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E2B3613B0
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 02:58:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237798AbhGNDBG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:01:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54010 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237599AbhGNDBG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 23:01:06 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210714025813epoutp01447e7961f6d101b5c64baaaafd37aa27~RiO1fWhvR2467224672epoutp01q
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 02:58:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210714025813epoutp01447e7961f6d101b5c64baaaafd37aa27~RiO1fWhvR2467224672epoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626231493;
        bh=AMeM28TWS2aSGP/MAjlG2xGWYbtuetrCX55zs4BkF/g=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=bWkxH0LEnNdZA8fDf+whIUa38CXS7ZzY31MJVyJlQuDZsoe16FE9f30UY3Ozt/cyk
         VVQKuhaizjKsHPbft0pFO/QoMEzvp28Y3Kv0e9iP0X0OOBaH98aGfIgidjpcQFYuhG
         /KlTgduk53lRsPFTv1sIAnsDFMCTuOi+F1LDec/Y=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210714025813epcas5p19d227b492fc6629a8cfae3e2ce8c07dd~RiO1CZivx0747107471epcas5p1O;
        Wed, 14 Jul 2021 02:58:13 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.40.198]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4GPhyV75QSz4x9Q2; Wed, 14 Jul
        2021 02:58:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.F5.09476.2C25EE06; Wed, 14 Jul 2021 11:58:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210713121146epcas5p43b800ea149a3377964752693720ab045~RWI3Iz1Uv3166131661epcas5p4j;
        Tue, 13 Jul 2021 12:11:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210713121146epsmtrp17414a113ec99b803512e9a52af24e429~RWI3H17v82983729837epsmtrp11;
        Tue, 13 Jul 2021 12:11:46 +0000 (GMT)
X-AuditID: b6c32a49-6b7ff70000002504-9f-60ee52c2936b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.4C.08394.2038DE06; Tue, 13 Jul 2021 21:11:46 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210713121142epsmtip23164bb2e8c7b6f91ad394664adc7866e~RWIzA8EvI3107731077epsmtip2b;
        Tue, 13 Jul 2021 12:11:41 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Chanho Park'" <chanho61.park@samsung.com>
Cc:     "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <robh+dt@kernel.org>
In-Reply-To: <CAJKOXPfJOGz7WhCk4HPtDh0=13gy0q=r5isLNkKz+yetAshAfw@mail.gmail.com>
Subject: RE: [PATCH 13/15] scsi: ufs: ufs-exynos: support exynosauto v9 ufs
 driver
Date:   Tue, 13 Jul 2021 17:41:40 +0530
Message-ID: <02a401d777e0$3ff92070$bfeb6150$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHyb2Euai2N4dYCWMtDA4PYCPryVgEgh/xhAisXkWEBe0FBs6rkqgfw
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJsWRmVeSWpSXmKPExsWy7bCmpu6hoHcJBlO/mlucfLKGzeLlz6ts
        FtM+/GS2+LR+GavF5f3aFj07nS1OT1jEZPFk/Sxmi0U3tjFZrLxmYXH+/AZ2i5tbjrJYzDi/
        j8mi+/oONovlx/8xWbTuPcLuIOBx+Yq3x+W+XiaPzSu0PBbvecnksWlVJ5vHhEUHGD0+Pr3F
        4tG3ZRWjx+dNch7tB7qZAriicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTy
        EnNTbZVcfAJ03TJzgP5QUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhXoFSfm
        Fpfmpesl5+daGRoYGJkCVSbkZHz/qV6w1K7i+Lo9bA2Mj3S6GDk5JARMJA5d/cTYxcjFISSw
        m1HicWsHE4TziVGi8edOKOcbo8TlzjesMC07X26BSuxllHi19S0zSEJI4CWjRO92bRCbTUBX
        YsfiNjYQW0QgRmLlpOXMIA3MAqdYJE7tPcsEkuAUCJRYs3oS2FRhgRCJBS19LCA2i4CqxJSn
        n4HiHBy8ApYSzx55g4R5BQQlTs58AlbCLKAtsWzha2aIgxQkfj5dxgqxy01i4713TBA14hJH
        f/aA7ZUQ+MEhMfvLNjaIBheJ/lWToL4Rlnh1fAs7hC0l8bK/jR1kr4RAtkTPLmOIcI3E0nnH
        WCBse4kDV+awgJQwC2hKrN+lDxGWlZh6ah3UWj6J3t9PmCDivBI75sHYqhLN765CjZGWmNjd
        zTqBUWkWks9mIflsFpIPZiFsW8DIsopRMrWgODc9tdi0wDAvtRw5ujcxglO5lucOxrsPPugd
        YmTiYDzEKMHBrCTCu9TobYIQb0piZVVqUX58UWlOavEhRlNgaE9klhJNzgdmk7ySeENTIzMz
        A0sDU2MLM0Mlcd6l7IcShATSE0tSs1NTC1KLYPqYODilGpgKbLs2zCgI1hdqcTtrFfekakWI
        +d7GuWc83y6Z7Ol42SSk+u0f+7aoGwGlAvrT8vUED11cX3nNOL5llbrPo01+u9auX9m1+N2f
        5OV9WRNnsWxUDP+216jtyA/ji23paebbni3r+3j40t6zufc9Q5cw7nMV3md0WXu7bPz26DuL
        XaPzds1ece5JuuuXfxYNDVtuzV/3nOHxhs51KywfmXAGPl81aeL3jqeyDRPuB6tNfn5XW1C8
        60kmh1P9uqYEdxNtx+3/GL4+XvIyy/DMXzN+q1VfODI62b3WTD5gKntz/c/1j/YLVec0C/3b
        kH+S77GgkVKmjKvxbbncW5xHBc97Lj3999Isttbkd22dWnVpSizFGYmGWsxFxYkAjSlU9m4E
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsWy7bCSvC5T89sEgwOX+S1OPlnDZvHy51U2
        i2kffjJbfFq/jNXi8n5ti56dzhanJyxisniyfhazxaIb25gsVl6zsDh/fgO7xc0tR1ksZpzf
        x2TRfX0Hm8Xy4/+YLFr3HmF3EPC4fMXb43JfL5PH5hVaHov3vGTy2LSqk81jwqIDjB4fn95i
        8ejbsorR4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBkPVpxnK3huU3Hx+CmWBsY52l2MnBwS
        AiYSO19uYepi5OIQEtjNKHFnTwcjREJa4vrGCewQtrDEyn/PwWwhgeeMEn0nUkFsNgFdiR2L
        29hAbBGBGImZ294yggxiFrjCIrGr7QkzxNROJokvW6+BTeUUCJRYs3oSK4gtLBAk8XXRDhYQ
        m0VAVWLK089AcQ4OXgFLiWePvEHCvAKCEidnPgErYRbQlnh68ymcvWzha2aI4xQkfj5dxgpx
        hJvExnvvmCBqxCWO/uxhnsAoPAvJqFlIRs1CMmoWkpYFjCyrGCVTC4pz03OLDQsM81LL9YoT
        c4tL89L1kvNzNzGCI1pLcwfj9lUf9A4xMnEwHmKU4GBWEuFdavQ2QYg3JbGyKrUoP76oNCe1
        +BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQamEzud9gi2WfoVM26fqixx4du7pbeX
        6jLdnyxxPKG/VtBniUd66fKn3Z7aEVMer3U4HM7uzsSn/JcpUiJGzqErv/67yNyLt/KEos9/
        fpfbpSmV0BO6655O9vZukb/aWhEF8ZeXmLKb/W8Of/e/rFt4mZl58MO0zkXle3o/Xsq7LHhf
        w0mG5VpezdPutX+sDrkrhIUvEq+/tofr+Z2yEtWVxVNywwoXamkbXZ/LLj3jBX/mqZ3fVY5M
        1vHbmxDE4HZjaWHBn4+TM49Xv6yaMyshyemCpFT7lZNFs5dfOxt0eLPrmk9HbrnqPbh6x0zx
        relHIT+e3mMnwxaHh024+G3SAz+X7uT5srcVmRdOzuRXYinOSDTUYi4qTgQAOoP+qVcDAAA=
X-CMS-MailID: 20210713121146epcas5p43b800ea149a3377964752693720ab045
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065747epcas2p483ee186906567e9e61a2a2c10209fc79
References: <CGME20210709065747epcas2p483ee186906567e9e61a2a2c10209fc79@epcas2p4.samsung.com>
        <20210709065711.25195-1-chanho61.park@samsung.com>
        <20210709065711.25195-14-chanho61.park@samsung.com>
        <CAJKOXPfJOGz7WhCk4HPtDh0=13gy0q=r5isLNkKz+yetAshAfw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Krzysztof Kozlowski <krzk=40kernel.org>
> Sent: 13 July 2021 16:28
> To: Chanho Park <chanho61.park=40samsung.com>
> Cc: Alim Akhtar <alim.akhtar=40samsung.com>; James E . J . Bottomley
> <jejb=40linux.ibm.com>; Martin K . Petersen <martin.petersen=40oracle.com=
>;
> Can Guo <cang=40codeaurora.org>; Jaegeuk Kim <jaegeuk=40kernel.org>;
> Kiwoong Kim <kwmad.kim=40samsung.com>; Avri Altman
> <avri.altman=40wdc.com>; Adrian Hunter <adrian.hunter=40intel.com>;
> Christoph Hellwig <hch=40infradead.org>; Bart Van Assche
> <bvanassche=40acm.org>; jongmin jeong <jjmin.jeong=40samsung.com>;
> Gyunghoon Kwon <goodjob.kwon=40samsung.com>; linux-samsung-
> soc=40vger.kernel.org; linux-scsi=40vger.kernel.org
> Subject: Re: =5BPATCH 13/15=5D scsi: ufs: ufs-exynos: support exynosauto =
v9 ufs
> driver
>=20
> -On Fri, 9 Jul 2021 at 08:59, Chanho Park <chanho61.park=40samsung.com>
> wrote:
> >
> > This patch adds to support ufs variant for ExynosAuto v9 SoC. This
> > requires control UFS IP sharability register via syscon and regmap.
> > Regarding uic_attr, most of values can be shared with exynos7 except
> > tx_dif_p_nsec value.
> >
> > Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
> > ---
> >  drivers/scsi/ufs/ufs-exynos.c =7C 97
> > +++++++++++++++++++++++++++++++++++
> >  1 file changed, 97 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufs-exynos.c
> > b/drivers/scsi/ufs/ufs-exynos.c index 9669afe8f1f4..82f915f7a447
> > 100644
> > --- a/drivers/scsi/ufs/ufs-exynos.c
> > +++ b/drivers/scsi/ufs/ufs-exynos.c
> > =40=40 -15,6 +15,7 =40=40
> >  =23include <linux/mfd/syscon.h>
> >  =23include <linux/phy/phy.h>
> >  =23include <linux/platform_device.h>
> > +=23include <linux/regmap.h>
> >
> >  =23include =22ufshcd.h=22
> >  =23include =22ufshcd-pltfrm.h=22
> > =40=40 -76,6 +77,12 =40=40
> >                                  UIC_TRANSPORT_NO_CONNECTION_RX =7C=5C
> >                                  UIC_TRANSPORT_BAD_TC)
> >
> > +/* FSYS UFS Sharability */
>=20
> Sharability -> Shareability
>=20
> > +=23define UFS_WR_SHARABLE                BIT(2)
> > +=23define UFS_RD_SHARABLE                BIT(1)
> > +=23define UFS_SHARABLE           (UFS_WR_SHARABLE =7C UFS_RD_SHARABLE)
> > +=23define UFS_SHARABILITY_OFFSET 0x710
> > +
> >  enum =7B
> >         UNIPRO_L1_5 =3D 0,/* PHY Adapter */
> >         UNIPRO_L2,      /* Data Link */
> > =40=40 -151,6 +158,80 =40=40 static int exynos7_ufs_drv_init(struct dev=
ice *dev,
> struct exynos_ufs *ufs)
> >         return 0;
> >  =7D
> >
> > +static int exynosauto_ufs_drv_init(struct device *dev, struct
> > +exynos_ufs *ufs) =7B
> > +       struct exynos_ufs_uic_attr *attr =3D ufs->drv_data->uic_attr;
> > +
> > +       /* IO Coherency setting */
> > +       if (ufs->sysreg) =7B
> > +               return regmap_update_bits(ufs->sysreg,
> UFS_SHARABILITY_OFFSET,
> > +                                         UFS_SHARABLE, UFS_SHARABLE);
> > +       =7D
> > +
> > +       attr->tx_dif_p_nsec =3D 3200000;
> > +
> > +       return 0;
> > +=7D
> > +
> > +static int exynosauto_ufs_pre_link(struct exynos_ufs *ufs) =7B
> > +       struct ufs_hba *hba =3D ufs->hba;
> > +       int i;
> > +
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x40);
> > +       for_each_ufs_rx_lane(ufs, i) =7B
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x12, i),
> > +                              DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rat=
e));
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x11, i), 0x0);
> > +
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, i), 0x2);
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, i), 0x8a);
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, i), 0xa3);
> > +
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1b, i), 0x2);
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1c, i), 0x8a);
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x1d, i), 0xa3);
> > +
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x2f, i), 0x79);
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x84, i), 0x1);
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x25, i), 0xf6);
> > +       =7D
> > +
> > +       for_each_ufs_tx_lane(ufs, i) =7B
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xaa, i),
> > +                              DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rat=
e));
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xa9, i), 0x02);
> > +
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xab, i), 0x8);
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xac, i), 0x22);
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0xad, i), 0x8);
> > +
> > +               ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x04, i), 0x1);
> > +       =7D
> > +
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x200), 0x0);
> > +
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE),
> 0x0);
> > +
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xa011), 0x8000);
> > +
> > +       return 0;
> > +=7D
> > +
> > +static int exynosauto_ufs_pre_pwr_change(struct exynos_ufs *ufs,
> > +                                        struct ufs_pa_layer_attr
> > +*pwr) =7B
> > +       struct ufs_hba *hba =3D ufs->hba;
> > +
> > +       /* PACP_PWR_req and delivered to the remote DME */
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
> 12000);
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
> 32000);
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
> 16000);
> > +
> > +       return 0;
> > +=7D
> > +
>=20
> No need for double line.
>=20
> > +
> >  static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)  =7B
> >         struct ufs_hba *hba =3D ufs->hba; =40=40 -1305,6 +1386,20 =40=
=40 static
> > struct exynos_ufs_uic_attr exynos7_uic_attr =3D =7B
> >         .pa_dbg_option_suite            =3D 0x30103,
> >  =7D;
> >
> > +static struct exynos_ufs_drv_data exynosauto_ufs_drvs =3D =7B
> > +       .uic_attr               =3D &exynos7_uic_attr,
> > +       .quirks                 =3D UFSHCD_QUIRK_PRDT_BYTE_GRAN =7C
> > +                                 UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR =7C
> > +                                 UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR =
=7C
> > +                                 UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_=
SETTING,
> > +       .opts                   =3D EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL=
 =7C
> > +                                 EXYNOS_UFS_OPT_SKIP_CONFIG_PHY_ATTR =
=7C
> > +                                 EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
> > +       .drv_init               =3D exynosauto_ufs_drv_init,
> > +       .pre_link               =3D exynosauto_ufs_pre_link,
> > +       .pre_pwr_change         =3D exynosauto_ufs_pre_pwr_change,
> > +=7D;
> > +
> >  static struct exynos_ufs_drv_data exynos_ufs_drvs =3D =7B
> >         .uic_attr               =3D &exynos7_uic_attr,
> >         .quirks                 =3D UFSHCD_QUIRK_PRDT_BYTE_GRAN =7C
> > =40=40 -1330,6 +1425,8 =40=40 static struct exynos_ufs_drv_data
> > exynos_ufs_drvs =3D =7B  static const struct of_device_id
> exynos_ufs_of_match=5B=5D =3D =7B
> >         =7B .compatible =3D =22samsung,exynos7-ufs=22,
> >           .data       =3D &exynos_ufs_drvs =7D,
> > +       =7B .compatible =3D =22samsung,exynosautov9-ufs=22,
> > +         .data       =3D &exynosauto_ufs_drvs =7D,
>=20
> This compatible is not documented. It seems that no one document
> exynos7-ufs but that's not an excuse. :)
>=20
I was post along with UFS driver =5B1=5D, had Rob's Reviewed-by as well, no=
t sure why it is not merged.=20
Let me ping Rob on this.
=5B1=5D https://www.mail-archive.com/linux-kernel=40vger.kernel.org/msg2176=
074.html

> Best regards,
> Krzysztof

