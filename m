Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E52C0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 15:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACB5320679
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 15:46:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cbjjzYh7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731915AbgCPPqN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:46:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30135 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731567AbgCPPqN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 11:46:13 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200316154611epoutp04c9b570f53244e9a18506b0eb84ba0e43~8015UaWtv2868728687epoutp04N
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2020 15:46:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200316154611epoutp04c9b570f53244e9a18506b0eb84ba0e43~8015UaWtv2868728687epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584373571;
        bh=VlLIsj9JOURtc5exm7wqAxruog0In12As3wD4YEUg8w=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=cbjjzYh74jvW9PubxWMFrCN2kHtHezNNluxOL4Z7x9Y+xo0fmHHy0AdKsjgtQk+rd
         DtuQ1qMk3dG3CqbbCTkQ392kJCg7oEv49vtXp/jmNT1EKU3zFM/fhWhvZFiZrRNLLG
         kwZKW2YfMPDaMuLic0exh0NI4Z9G+xN3/bJkAXgs=
Received: from epsmges5p3new.samsung.com (unknown [182.195.42.75]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20200316154610epcas5p325e20aa1e9695665e2657b0dc78c52f7~8014npIpc1355213552epcas5p3C;
        Mon, 16 Mar 2020 15:46:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.FF.04736.24F9F6E5; Tue, 17 Mar 2020 00:46:10 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200316154609epcas5p2821dd69b48b0ec71f025ed291c761a16~80139iTiD3085530855epcas5p21;
        Mon, 16 Mar 2020 15:46:09 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200316154609epsmtrp26c472850cbf8071b2991f5f3800ebb4e~801380DDf3012130121epsmtrp2w;
        Mon, 16 Mar 2020 15:46:09 +0000 (GMT)
X-AuditID: b6c32a4b-ae3ff70000001280-f2-5e6f9f424ad4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        97.40.04158.14F9F6E5; Tue, 17 Mar 2020 00:46:09 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200316154608epsmtip209bbc2c5e6b1be0d6288d9f8c80c2c87~8012hX6tg1934319343epsmtip2H;
        Mon, 16 Mar 2020 15:46:07 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Kiwoong Kim'" <kwmad.kim@samsung.com>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <cpgs@samsung.com>
Cc:     <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <cang@codeaurora.org>,
        "'Kishon Vijay Abraham I'" <kishon@ti.com>
In-Reply-To: <000001d5fb54$e5139c70$af3ad550$@samsung.com>
Subject: RE: [PATCH 2/5] phy: samsung-ufs: add UFS PHY driver for samsung
 SoC
Date:   Mon, 16 Mar 2020 21:16:06 +0530
Message-ID: <000101d5fbaa$032b0220$09810660$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGcomJoogAapdSxIIuFJfiljU0eNAHRmbrXAkKAqlQBsIDBJKiP6lQg
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7bCmpq7T/Pw4gys3+Cxe/rzKZvFp/TJW
        i5eHNC3mHznHanHhaQ+bxfnzG9gtbm45ymLRfX0Hm8Xy4/+YLFr3HmF34PK43NfL5LFpVSeb
        x8ent1g8+rasYvQ4fmM7k8fnTXIe7Qe6mQLYo7hsUlJzMstSi/TtErgy7s1bzFbwZDdjxbru
        zawNjHenM3YxcnJICJhIrL10ignEFhLYzSixrMOvi5ELyP7EKHFj/kJWCOcbo8SLZWtZYDq2
        7P7GApHYyyjxfNYxJgjnFaPEw/717CBVbAK6EjsWt7GBJEQEpjJKfNm1A6yFWaCfUeLBpoVs
        IFWcAlYSR2++ApsrLOAv0f9lFtglLAKqElMv/QObxCtgKfFq2yMmCFtQ4uTMJ2D1zALaEssW
        vmaGuElB4ufTZUDHcgBtc5PYfs8SokRc4ujPHmaQvRIC/ewSvzccYYWod5H4OvsuNASEJV4d
        38IOYUtJfH63lw1kjoRAtkTPLmOIcI3E0nnHoN63lzhwZQ4LSAmzgKbE+l36EGFeiYaNv9kh
        1vJJ9P5+wgQxhVeio00IokRVovndVagp0hITu7tZJzAqzULy1ywkf81C8sAshGULGFlWMUqm
        FhTnpqcWmxYY56WW6xUn5haX5qXrJefnbmIEpy4t7x2Mm875HGIU4GBU4uGdkZMfJ8SaWFZc
        mXuIUYKDWUmEd3EhUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvJNarMUIC6YklqdmpqQWpRTBZ
        Jg5OqQZG0cZlod39x/f9e3rP7YlgVe5spqz721LuK38yctc9kZu522PP3htyEhNPGRxJ2dy3
        t1oz+XPIhpgjpiu5Z71I59RKmDCRU9fk9N92U9G4vlMPHObwrbKvfvDYXMB6xsJfdvx5phET
        nfJOqFm433hW5DLtK/dG5xd9n/f/2VbhGLlUXzlb7V2BEktxRqKhFnNRcSIAf0/ehVkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWy7bCSvK7j/Pw4g8XP5Cxe/rzKZvFp/TJW
        i5eHNC3mHznHanHhaQ+bxfnzG9gtbm45ymLRfX0Hm8Xy4/+YLFr3HmF34PK43NfL5LFpVSeb
        x8ent1g8+rasYvQ4fmM7k8fnTXIe7Qe6mQLYo7hsUlJzMstSi/TtErgyjl/ZwVowcxtjxczX
        H9gbGHsmMXYxcnJICJhIbNn9jaWLkYtDSGA3o8SGRyfYIRLSEtc3ToCyhSVW/nvODlH0glHi
        RHM7C0iCTUBXYsfiNjaQhIjATEaJRUvXg41iFpjKKHF80yVWiJbXjBJrln9jBWnhFLCSOHrz
        FVi7sICvRNPjW2CHsAioSky99A9sH6+ApcSrbY+YIGxBiZMzn4DVMwtoSzy9+RTOXrbwNTPE
        fQoSP58uA5rPAXSGm8T2e5YQJeISR3/2ME9gFJ6FZNIsJJNmIZk0C0nLAkaWVYySqQXFuem5
        xYYFRnmp5XrFibnFpXnpesn5uZsYwXGopbWD8cSJ+EOMAhyMSjy8Dln5cUKsiWXFlbmHGCU4
        mJVEeBcXAoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzyucfixQSSE8sSc1OTS1ILYLJMnFwSjUw
        zmZ2r5ac2rfugtI1Npt5LfEOIndnzNp85/BB4/P7voZYLv497+F7F482MfmwM8dStBemMNm6
        lz0x3ShTqDJl9i9XztdvP1l8rwzfnBgj099xtf/wnsqcy4U3pzhVbGX4xd9awT198lrnDwlb
        d2xosvvc8/aDxFPfz5sN+G+ZbHS8w673aInELyWW4oxEQy3mouJEAIWJ+gy/AgAA
X-CMS-MailID: 20200316154609epcas5p2821dd69b48b0ec71f025ed291c761a16
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-CPGSPASS: Y
CMS-TYPE: 105P
X-CMS-RootMailID: 20200306151023epcas5p40179ecb7edaea3357c9d652553075b8d
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
        <CGME20200306151023epcas5p40179ecb7edaea3357c9d652553075b8d@epcas5p4.samsung.com>
        <20200306150529.3370-3-alim.akhtar@samsung.com>
        <000001d5fb54$e5139c70$af3ad550$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Kiwoong Kim <kwmad.kim=40samsung.com>
> Sent: 16 March 2020 11:07
> To: 'Alim Akhtar' <alim.akhtar=40samsung.com>; robh+dt=40kernel.org;
> devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; cpgs=40samsun=
g.com
> Cc: krzk=40kernel.org; avri.altman=40wdc.com; martin.petersen=40oracle.co=
m;
> cang=40codeaurora.org; 'Kishon Vijay Abraham I' <kishon=40ti.com>
> Subject: RE: =5BPATCH 2/5=5D phy: samsung-ufs: add UFS PHY driver for sam=
sung SoC
>=20
> > -----Original Message-----
> > From: Alim Akhtar <alim.akhtar=40samsung.com>
> > Sent: Saturday, March 7, 2020 12:05 AM
> > To: robh+dt=40kernel.org; devicetree=40vger.kernel.org; linux-
> > scsi=40vger.kernel.org
> > Cc: krzk=40kernel.org; avri.altman=40wdc.com; martin.petersen=40oracle.=
com;
> > kwmad.kim=40samsung.com; stanley.chu=40mediatek.com;
> cang=40codeaurora.org;
> > Alim Akhtar <alim.akhtar=40samsung.com>; Kishon Vijay Abraham I
> > <kishon=40ti.com>
> > Subject: =5BPATCH 2/5=5D phy: samsung-ufs: add UFS PHY driver for samsu=
ng
> > SoC
> >
> > This patch introduces Samsung UFS PHY driver. This driver supports to
> > deal with phy calibration and power control according to UFS host
> > driver's behavior.
> >
> > Signed-off-by: Seungwon Jeon <essuuj=40gmail.com>
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > Cc: Kishon Vijay Abraham I <kishon=40ti.com>
> > ---
> >  drivers/phy/samsung/Kconfig           =7C   9 +
> >  drivers/phy/samsung/Makefile          =7C   1 +
> >  drivers/phy/samsung/phy-exynos7-ufs.h =7C  85 +++++++
> > drivers/phy/samsung/phy-samsung-ufs.c =7C 311
> ++++++++++++++++++++++++++
> > drivers/phy/samsung/phy-samsung-ufs.h =7C 100 +++++++++
> >  include/linux/phy/phy-samsung-ufs.h   =7C  70 ++++++
> >  6 files changed, 576 insertions(+)
> >  create mode 100644 drivers/phy/samsung/phy-exynos7-ufs.h
> >  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.c
> >  create mode 100644 drivers/phy/samsung/phy-samsung-ufs.h
> >  create mode 100644 include/linux/phy/phy-samsung-ufs.h
> >
> > diff --git a/drivers/phy/samsung/Kconfig b/drivers/phy/samsung/Kconfig
> > index 9e483d1fdaf2..fc1e3c17f842 100644
> > --- a/drivers/phy/samsung/Kconfig
> > +++ b/drivers/phy/samsung/Kconfig
> > =40=40 -29,6 +29,15 =40=40 config PHY_EXYNOS_PCIE
> >  	  Enable PCIe PHY support for Exynos SoC series.
> >  	  This driver provides PHY interface for Exynos PCIe controller.
> >
> > +config PHY_SAMSUNG_UFS
> > +	tristate =22SAMSUNG SoC series UFS PHY driver=22
> > +	depends on OF && (ARCH_EXYNOS =7C=7C COMPILE_TEST)
> > +	select GENERIC_PHY
> > +	help
> > +	  Enable this to support the Samsung UFS PHY driver for
> > +	  Samsung SoCs. This driver provides the interface for UFS
> > +	  host controller to do PHY related programming.
> > +
> >  config PHY_SAMSUNG_USB2
> >  	tristate =22Samsung USB 2.0 PHY driver=22
> >  	depends on HAS_IOMEM
> > diff --git a/drivers/phy/samsung/Makefile
> > b/drivers/phy/samsung/Makefile index db9b1aa0de6e..3959100fe8a2 100644
> > --- a/drivers/phy/samsung/Makefile
> > +++ b/drivers/phy/samsung/Makefile
> > =40=40 -2,6 +2,7 =40=40
> >  obj-=24(CONFIG_PHY_EXYNOS_DP_VIDEO)	+=3D phy-exynos-dp-video.o
> >  obj-=24(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+=3D phy-exynos-mipi-video.o
> >  obj-=24(CONFIG_PHY_EXYNOS_PCIE)		+=3D phy-exynos-pcie.o
> > +obj-=24(CONFIG_PHY_SAMSUNG_UFS)		+=3D phy-samsung-ufs.o
> >  obj-=24(CONFIG_PHY_SAMSUNG_USB2)		+=3D phy-exynos-usb2.o
> >  phy-exynos-usb2-y			+=3D phy-samsung-usb2.o
> >  phy-exynos-usb2-=24(CONFIG_PHY_EXYNOS4210_USB2)	+=3D phy-exynos4210-
> usb2.o
> > diff --git a/drivers/phy/samsung/phy-exynos7-ufs.h
> > b/drivers/phy/samsung/phy-exynos7-ufs.h
> > new file mode 100644
> > index 000000000000..da981c1ac040
> > --- /dev/null
> > +++ b/drivers/phy/samsung/phy-exynos7-ufs.h
> > =40=40 -0,0 +1,85 =40=40
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * UFS PHY driver data for Samsung EXYNOS7 SoC
> > + *
> > + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> > + */
> > +=23ifndef _PHY_EXYNOS7_UFS_H_
> > +=23define _PHY_EXYNOS7_UFS_H_
> > +
> > +=23include =22phy-samsung-ufs.h=22
> > +
> > +=23define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL	0x720
> > +=23define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK	0x1
> > +=23define EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN	BIT(0)
> > +
> > +/* Calibration for phy initialization */ static const struct
> > +samsung_ufs_phy_cfg exynos7_pre_init_cfg=5B=5D =3D =7B
> > +	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_ANY),
> > +	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_ANY),
> > +	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_ANY),
> > +	PHY_COMN_REG_CFG(0x017, 0x84, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x035, 0x58, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x037, 0x40, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x03b, 0x83, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x04c, 0x5b, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_ANY),
> > +	PHY_TRSV_REG_CFG(0x05c, 0x14, PWR_MODE_ANY),
> > +	END_UFS_PHY_CFG
> > +=7D;
> > +
> > +static const struct samsung_ufs_phy_cfg exynos7_post_init_cfg=5B=5D =
=3D =7B
> > +	END_UFS_PHY_CFG
> > +=7D;
> > +
> > +/* Calibration for HS mode series A/B */ static const struct
> > +samsung_ufs_phy_cfg exynos7_pre_pwr_hs_cfg=5B=5D =3D =7B
> > +	PHY_COMN_REG_CFG(0x00f, 0xfa, PWR_MODE_HS_ANY),
> > +	PHY_COMN_REG_CFG(0x010, 0x82, PWR_MODE_HS_ANY),
> > +	PHY_COMN_REG_CFG(0x011, 0x1e, PWR_MODE_HS_ANY),
> > +	/* Setting order: 1st(0x16, 2nd(0x15) */
> > +	PHY_COMN_REG_CFG(0x016, 0xff, PWR_MODE_HS_ANY),
> > +	PHY_COMN_REG_CFG(0x015, 0x80, PWR_MODE_HS_ANY),
> > +	PHY_COMN_REG_CFG(0x017, 0x94, PWR_MODE_HS_ANY),
> > +	PHY_TRSV_REG_CFG(0x036, 0x32, PWR_MODE_HS_ANY),
> > +	PHY_TRSV_REG_CFG(0x037, 0x43, PWR_MODE_HS_ANY),
> > +	PHY_TRSV_REG_CFG(0x038, 0x3f, PWR_MODE_HS_ANY),
> > +	PHY_TRSV_REG_CFG(0x042, 0x88, PWR_MODE_HS_G2_SER_A),
> > +	PHY_TRSV_REG_CFG(0x042, 0xbb, PWR_MODE_HS_G2_SER_B),
> > +	PHY_TRSV_REG_CFG(0x043, 0xa6, PWR_MODE_HS_ANY),
> > +	PHY_TRSV_REG_CFG(0x048, 0x74, PWR_MODE_HS_ANY),
> > +	PHY_TRSV_REG_CFG(0x034, 0x35, PWR_MODE_HS_G2_SER_A),
> > +	PHY_TRSV_REG_CFG(0x034, 0x36, PWR_MODE_HS_G2_SER_B),
> > +	PHY_TRSV_REG_CFG(0x035, 0x5b, PWR_MODE_HS_G2_SER_A),
> > +	PHY_TRSV_REG_CFG(0x035, 0x5c, PWR_MODE_HS_G2_SER_B),
> > +	END_UFS_PHY_CFG
> > +=7D;
> > +
> > +/* Calibration for HS mode series A/B atfer PMC */ static const
> > +struct samsung_ufs_phy_cfg exynos7_post_pwr_hs_cfg=5B=5D =3D =7B
> > +	PHY_COMN_REG_CFG(0x015, 0x00, PWR_MODE_HS_ANY),
> > +	PHY_TRSV_REG_CFG(0x04d, 0x83, PWR_MODE_HS_ANY),
> > +	END_UFS_PHY_CFG
> > +=7D;
> > +
> > +static const struct samsung_ufs_phy_cfg
> > +*exynos7_ufs_phy_cfgs=5BCFG_TAG_MAX=5D
> > =3D =7B
> > +	=5BCFG_PRE_INIT=5D		=3D exynos7_pre_init_cfg,
> > +	=5BCFG_POST_INIT=5D		=3D exynos7_post_init_cfg,
> > +	=5BCFG_PRE_PWR_HS=5D	=3D exynos7_pre_pwr_hs_cfg,
> > +	=5BCFG_POST_PWR_HS=5D	=3D exynos7_post_pwr_hs_cfg,
> > +=7D;
> > +
> > +static struct samsung_ufs_phy_drvdata exynos7_ufs_phy =3D =7B
> > +	.cfg =3D exynos7_ufs_phy_cfgs,
> > +	.isol =3D =7B
> > +		.offset =3D EXYNOS7_EMBEDDED_COMBO_PHY_CTRL,
> > +		.mask =3D EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_MASK,
> > +		.en =3D EXYNOS7_EMBEDDED_COMBO_PHY_CTRL_EN,
> > +	=7D,
> > +=7D;
> > +
> > +=23endif /* _PHY_EXYNOS7_UFS_H_ */
> > diff --git a/drivers/phy/samsung/phy-samsung-ufs.c
> > b/drivers/phy/samsung/phy-samsung-ufs.c
> > new file mode 100644
> > index 000000000000..2d5db24de49b
> > --- /dev/null
> > +++ b/drivers/phy/samsung/phy-samsung-ufs.c
> > =40=40 -0,0 +1,311 =40=40
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * UFS PHY driver for Samsung SoC
> > + *
> > + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> > + * Author: Seungwon Jeon <essuuj=40gmail.com>
> > + * Author: Alim Akhtar <alim.akhtar=40samsung.com>
> > + *
> > + */
> > +=23include <linux/clk.h>
> > +=23include <linux/delay.h>
> > +=23include <linux/err.h>
> > +=23include <linux/of.h>
> > +=23include <linux/io.h>
> > +=23include <linux/iopoll.h>
> > +=23include <linux/mfd/syscon.h>
> > +=23include <linux/module.h>
> > +=23include <linux/phy/phy.h>
> > +=23include <linux/phy/phy-samsung-ufs.h> =23include
> > +<linux/platform_device.h> =23include <linux/regmap.h>
> > +
> > +=23include =22phy-samsung-ufs.h=22
> > +
> > +=23define for_each_phy_lane(phy, i) =5C
> > +	for (i =3D 0; i < (phy)->lane_cnt; i++) =23define for_each_phy_cfg(cf=
g)
> > +=5C
> > +	for (; (cfg)->id; (cfg)++)
> > +
> > +=23define PHY_DEF_LANE_CNT	1
> > +
> > +static void samsung_ufs_phy_config(struct samsung_ufs_phy *phy,
> > +			const struct samsung_ufs_phy_cfg *cfg, u8 lane) =7B
> > +	enum =7BLANE_0, LANE_1=7D; /* lane index */
> > +
> > +	switch (lane) =7B
> > +	case LANE_0:
> > +		writel(cfg->val, (phy)->reg_pma + cfg->off_0);
> > +		break;
> > +	case LANE_1:
> > +		if (cfg->id =3D=3D PHY_TRSV_BLK)
> > +			writel(cfg->val, (phy)->reg_pma + cfg->off_1);
> > +		break;
> > +	=7D
> > +=7D
> > +
> > +int samsung_ufs_phy_wait_for_lock_acq(struct phy *phy) =7B
> > +	struct samsung_ufs_phy *ufs_phy =3D get_samsung_ufs_phy(phy);
> > +	const unsigned int timeout_us =3D 100000;
> > +	const unsigned int sleep_us =3D 10;
> > +	u32 val;
> > +	int err;
> > +
> > +	err =3D readl_poll_timeout(
> > +			ufs_phy->reg_pma +
> PHY_APB_ADDR(PHY_PLL_LOCK_STATUS),
> > +			val, (val & PHY_PLL_LOCK_BIT), sleep_us, timeout_us);
> > +	if (err) =7B
> > +		dev_err(ufs_phy->dev,
> > +			=22failed to get phy pll lock acquisition %d=5Cn=22, err);
> > +		goto out;
> > +	=7D
> > +
> > +	err =3D readl_poll_timeout(
> > +			ufs_phy->reg_pma +
> PHY_APB_ADDR(PHY_CDR_LOCK_STATUS),
> > +			val, (val & PHY_CDR_LOCK_BIT), sleep_us, timeout_us);
> > +	if (err) =7B
> > +		dev_err(ufs_phy->dev,
> > +			=22failed to get phy cdr lock acquisition %d=5Cn=22, err);
> > +		goto out;
> > +	=7D
> > +
> > +out:
> > +	return err;
> > +=7D
> > +
> > +int samsung_ufs_phy_calibrate(struct phy *phy) =7B
> > +	struct samsung_ufs_phy *ufs_phy =3D get_samsung_ufs_phy(phy);
> > +	struct samsung_ufs_phy_cfg **cfgs =3D ufs_phy->cfg;
> > +	const struct samsung_ufs_phy_cfg *cfg;
> > +	int i;
> > +	int err =3D 0;
> > +
> > +	if (unlikely(ufs_phy->ufs_phy_state < CFG_PRE_INIT =7C=7C
> > +		     ufs_phy->ufs_phy_state >=3D CFG_TAG_MAX)) =7B
> > +		dev_err(ufs_phy->dev, =22invalid phy config index %d=5Cn=22,
> > +							ufs_phy-
> >ufs_phy_state);
> > +		return -EINVAL;
> > +	=7D
> > +
> > +	if (ufs_phy->is_pre_init)
> > +		ufs_phy->is_pre_init =3D false;
> > +	if (ufs_phy->is_post_init) =7B
> > +		ufs_phy->is_post_init =3D false;
> > +		ufs_phy->ufs_phy_state =3D CFG_POST_INIT;
> > +	=7D
> > +	if (ufs_phy->is_pre_pmc) =7B
> > +		ufs_phy->is_pre_pmc =3D false;
> > +		ufs_phy->ufs_phy_state =3D CFG_PRE_PWR_HS;
> > +	=7D
> > +	if (ufs_phy->is_post_pmc) =7B
> > +		ufs_phy->is_post_pmc =3D false;
> > +		ufs_phy->ufs_phy_state =3D CFG_POST_PWR_HS;
> > +	=7D
> > +
> > +	switch (ufs_phy->ufs_phy_state) =7B
> > +	case CFG_PRE_INIT:
> > +		ufs_phy->is_post_init =3D true;
> > +		break;
> > +	case CFG_POST_INIT:
> > +		ufs_phy->is_pre_pmc =3D true;
> > +		break;
> > +	case CFG_PRE_PWR_HS:
> > +		ufs_phy->is_post_pmc =3D true;
> > +		break;
> > +	case CFG_POST_PWR_HS:
> > +		break;
> > +	default:
> > +		dev_err(ufs_phy->dev, =22wrong state for phy calibration=5Cn=22);
> > +	=7D
> > +
> > +	cfg =3D cfgs=5Bufs_phy->ufs_phy_state=5D;
> > +	if (=21cfg)
> > +		goto out;
> > +
> > +	for_each_phy_cfg(cfg) =7B
> > +		for_each_phy_lane(ufs_phy, i) =7B
> > +			samsung_ufs_phy_config(ufs_phy, cfg, i);
> > +		=7D
> > +	=7D
> > +
> > +	if (ufs_phy->ufs_phy_state =3D=3D CFG_POST_PWR_HS)
> > +		err =3D samsung_ufs_phy_wait_for_lock_acq(phy);
> > +out:
> > +	return err;
> > +=7D
> > +
> > +static int samsung_ufs_phy_clks_init(struct samsung_ufs_phy *phy) =7B
> > +	struct clk *child, *parent;
> > +
> > +	child =3D devm_clk_get(phy->dev, =22ref_clk=22);
> > +	if (IS_ERR(child))
> > +		dev_err(phy->dev, =22failed to get ref_clk clock=5Cn=22);
> > +	else
> > +		phy->ref_clk =3D child;
> > +
> > +	parent =3D devm_clk_get(phy->dev, =22ref_clk_parent=22);
> > +	if (IS_ERR(parent))
> > +		dev_err(phy->dev, =22failed to get ref_clk_parent clock=5Cn=22);
> > +	else
> > +		phy->ref_clk_parent =3D parent;
> > +
> > +	return clk_set_parent(child, parent); =7D
> > +
> > +static int samsung_ufs_phy_init(struct phy *phy) =7B
> > +	struct samsung_ufs_phy *_phy =3D get_samsung_ufs_phy(phy);
> > +
> > +	_phy->lane_cnt =3D phy->attrs.bus_width;
> > +	_phy->ufs_phy_state =3D CFG_PRE_INIT;
> > +
> > +	_phy->is_pre_init =3D true;
> > +	_phy->is_post_init =3D false;
> > +	_phy->is_pre_pmc =3D false;
> > +	_phy->is_post_pmc =3D false;
> > +
> > +	samsung_ufs_phy_clks_init(_phy);
> > +
> > +	samsung_ufs_phy_calibrate(phy);
> > +
> > +	return 0;
> > +=7D
> > +
> > +static int samsung_ufs_phy_power_on(struct phy *phy) =7B
> > +	struct samsung_ufs_phy *_phy =3D get_samsung_ufs_phy(phy);
> > +	int ret;
> > +
> > +	ret =3D clk_prepare_enable(_phy->ref_clk);
> > +	if (ret) =7B
> > +		dev_err(_phy->dev, =22%s: ref_clk enable failed %d=5Cn=22,
> > +				__func__, ret);
> > +		return ret;
> > +	=7D
> > +
> > +	samsung_ufs_phy_ctrl_isol(_phy, false);
> > +	return 0;
> > +=7D
> > +
> > +static int samsung_ufs_phy_power_off(struct phy *phy) =7B
> > +	struct samsung_ufs_phy *_phy =3D get_samsung_ufs_phy(phy);
> > +
> > +	samsung_ufs_phy_ctrl_isol(_phy, true);
> > +	clk_disable_unprepare(_phy->ref_clk);
> > +	return 0;
> > +=7D
> > +
> > +static int samsung_ufs_phy_set_mode(struct phy *generic_phy,
> > +					enum phy_mode mode, int submode) =7B
> > +	struct samsung_ufs_phy *_phy =3D get_samsung_ufs_phy(generic_phy);
> > +
> > +	_phy->mode =3D PHY_MODE_INVALID;
> > +
> > +	if (mode > 0)
> > +		_phy->mode =3D mode;
> > +
> > +	return 0;
> > +=7D
> > +
> > +static struct phy_ops samsung_ufs_phy_ops =3D =7B
> > +	.init		=3D samsung_ufs_phy_init,
> > +	.power_on	=3D samsung_ufs_phy_power_on,
> > +	.power_off	=3D samsung_ufs_phy_power_off,
> > +	.calibrate	=3D samsung_ufs_phy_calibrate,
> > +	.set_mode	=3D samsung_ufs_phy_set_mode,
> > +=7D
> > +;
> > +static const struct of_device_id samsung_ufs_phy_match=5B=5D;
> > +
> > +static int samsung_ufs_phy_probe(struct platform_device *pdev) =7B
> > +	struct device *dev =3D &pdev->dev;
> > +	struct resource *res;
> > +	const struct of_device_id *match;
> > +	struct samsung_ufs_phy *phy;
> > +	struct phy *gen_phy;
> > +	struct phy_provider *phy_provider;
> > +	const struct samsung_ufs_phy_drvdata *drvdata;
> > +	int err =3D 0;
> > +
> > +	match =3D of_match_node(samsung_ufs_phy_match, dev->of_node);
> > +	if (=21match) =7B
> > +		err =3D -EINVAL;
> > +		dev_err(dev, =22failed to get match_node=5Cn=22);
> > +		goto out;
> > +	=7D
> > +
> > +	phy =3D devm_kzalloc(dev, sizeof(*phy), GFP_KERNEL);
> > +	if (=21phy) =7B
> > +		err =3D -ENOMEM;
> > +		goto out;
> > +	=7D
> > +
> > +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, =22phy-
> pma=22);
> > +	phy->reg_pma =3D devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(phy->reg_pma)) =7B
> > +		err =3D PTR_ERR(phy->reg_pma);
> > +		goto out;
> > +	=7D
> > +
> > +	phy->reg_pmu =3D syscon_regmap_lookup_by_phandle(
> > +				dev->of_node, =22samsung,pmu-syscon=22);
> > +	if (IS_ERR(phy->reg_pmu)) =7B
> > +		err =3D PTR_ERR(phy->reg_pmu);
> > +		dev_err(dev, =22failed syscon remap for pmu=5Cn=22);
> > +		goto out;
> > +	=7D
> > +
> > +	gen_phy =3D devm_phy_create(dev, NULL, &samsung_ufs_phy_ops);
> > +	if (IS_ERR(gen_phy)) =7B
> > +		err =3D PTR_ERR(gen_phy);
> > +		dev_err(dev, =22failed to create PHY for ufs-phy=5Cn=22);
> > +		goto out;
> > +	=7D
> > +
> > +	drvdata =3D match->data;
> > +	phy->dev =3D dev;
> > +	phy->drvdata =3D drvdata;
> > +	phy->cfg =3D (struct samsung_ufs_phy_cfg **)drvdata->cfg;
> > +	phy->isol =3D &drvdata->isol;
> > +	phy->lane_cnt =3D PHY_DEF_LANE_CNT;
> > +
> > +	phy_set_drvdata(gen_phy, phy);
> > +
> > +	phy_provider =3D devm_of_phy_provider_register(dev,
> > of_phy_simple_xlate);
> > +	if (IS_ERR(phy_provider)) =7B
> > +		err =3D PTR_ERR(phy_provider);
> > +		dev_err(dev, =22failed to register phy-provider=5Cn=22);
> > +		goto out;
> > +	=7D
> > +out:
> > +	return err;
> > +=7D
> > +
> > +static const struct of_device_id samsung_ufs_phy_match=5B=5D =3D =7B
> > +	=7B
> > +		.compatible =3D =22samsung,exynos7-ufs-phy=22,
> > +		.data =3D &exynos7_ufs_phy,
> > +	=7D,
> > +	=7B=7D,
> > +=7D;
> > +MODULE_DEVICE_TABLE(of, samsung_ufs_phy_match);
> > +
> > +static struct platform_driver samsung_ufs_phy_driver =3D =7B
> > +	.probe  =3D samsung_ufs_phy_probe,
> > +	.driver =3D =7B
> > +		.name =3D =22samsung-ufs-phy=22,
> > +		.of_match_table =3D samsung_ufs_phy_match,
> > +	=7D,
> > +=7D;
> > +module_platform_driver(samsung_ufs_phy_driver);
> > +MODULE_DESCRIPTION(=22Samsung SoC UFS PHY Driver=22);
> > +MODULE_AUTHOR(=22Seungwon Jeon <essuuj=40gmail.com>=22);
> > +MODULE_AUTHOR(=22Alim Akhtar <alim.akhtar=40samsung.com>=22);
> > +MODULE_LICENSE(=22GPL v2=22);
> > diff --git a/drivers/phy/samsung/phy-samsung-ufs.h
> > b/drivers/phy/samsung/phy-samsung-ufs.h
> > new file mode 100644
> > index 000000000000..d0ae2b416b2b
> > --- /dev/null
> > +++ b/drivers/phy/samsung/phy-samsung-ufs.h
> > =40=40 -0,0 +1,100 =40=40
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * UFS PHY driver for Samsung EXYNOS SoC
> > + *
> > + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> > + * Author: Seungwon Jeon <essuuj=40gmail.com>
> > + * Author: Alim Akhtar <alim.akhtar=40samsung.com>
> > + *
> > + */
> > +=23ifndef _PHY_SAMSUNG_UFS_
> > +=23define _PHY_SAMSUNG_UFS_
> > +
> > +=23define PHY_COMN_BLK	1
> > +=23define PHY_TRSV_BLK	2
> > +=23define END_UFS_PHY_CFG =7B 0 =7D
> > +=23define PHY_TRSV_CH_OFFSET	0x30
> > +=23define PHY_APB_ADDR(off)	((off) << 2)
> > +
> > +=23define PHY_COMN_REG_CFG(o, v, d) =7B	=5C
> > +	.off_0 =3D PHY_APB_ADDR((o)),	=5C
> > +	.off_1 =3D 0,		=5C
> > +	.val =3D (v),		=5C
> > +	.desc =3D (d),		=5C
> > +	.id =3D PHY_COMN_BLK,	=5C
> > +=7D
> > +
> > +=23define PHY_TRSV_REG_CFG(o, v, d) =7B	=5C
> > +	.off_0 =3D PHY_APB_ADDR((o)),	=5C
> > +	.off_1 =3D PHY_APB_ADDR((o) + PHY_TRSV_CH_OFFSET),	=5C
> > +	.val =3D (v),		=5C
> > +	.desc =3D (d),		=5C
> > +	.id =3D PHY_TRSV_BLK,	=5C
> > +=7D
> > +
> > +/* UFS PHY registers */
> > +=23define PHY_PLL_LOCK_STATUS	0x1e
> > +=23define PHY_CDR_LOCK_STATUS	0x5e
> > +
> > +=23define PHY_PLL_LOCK_BIT	BIT(5)
> > +=23define PHY_CDR_LOCK_BIT	BIT(4)
> > +
> > +/* PHY calibration point/state */
> > +enum =7B
> > +	CFG_PRE_INIT,
> > +	CFG_POST_INIT,
> > +	CFG_PRE_PWR_HS,
> > +	CFG_POST_PWR_HS,
> > +	CFG_TAG_MAX,
> > +=7D;
> > +
> > +struct samsung_ufs_phy_cfg =7B
> > +	u32 off_0;
> > +	u32 off_1;
> > +	u32 val;
> > +	u8 desc;
> > +	u8 id;
> > +=7D;
> > +
> > +struct samsung_ufs_phy_drvdata =7B
> > +	const struct samsung_ufs_phy_cfg **cfg;
> > +	struct pmu_isol =7B
> > +		u32 offset;
> > +		u32 mask;
> > +		u32 en;
> > +	=7D isol;
> > +=7D;
> > +
> > +struct samsung_ufs_phy =7B
> > +	struct device *dev;
> > +	void __iomem *reg_pma;
> > +	struct regmap *reg_pmu;
> > +	struct clk *ref_clk;
> > +	struct clk *ref_clk_parent;
> > +	const struct samsung_ufs_phy_drvdata *drvdata;
> > +	struct samsung_ufs_phy_cfg **cfg;
> > +	const struct pmu_isol *isol;
> > +	u8 lane_cnt;
> > +	int ufs_phy_state;
> > +	enum phy_mode mode;
> > +	bool is_pre_init;
> > +	bool is_post_init;
> > +	bool is_pre_pmc;
> > +	bool is_post_pmc;
> > +=7D;
> > +
> > +static inline struct samsung_ufs_phy *get_samsung_ufs_phy(struct phy
> > +*phy) =7B
> > +	return (struct samsung_ufs_phy *)phy_get_drvdata(phy); =7D
> > +
> > +static inline void samsung_ufs_phy_ctrl_isol(
> > +		struct samsung_ufs_phy *phy, u32 isol) =7B
> > +	regmap_update_bits(phy->reg_pmu, phy->isol->offset,
> > +			phy->isol->mask, isol ? 0 : phy->isol->en); =7D
> > +
> > +=23include =22phy-exynos7-ufs.h=22
> > +
> > +=23endif /* _PHY_SAMSUNG_UFS_ */
> > diff --git a/include/linux/phy/phy-samsung-ufs.h
> > b/include/linux/phy/phy- samsung-ufs.h new file mode 100644 index
> > 000000000000..1def56207f5d
> > --- /dev/null
> > +++ b/include/linux/phy/phy-samsung-ufs.h
> > =40=40 -0,0 +1,70 =40=40
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * phy-samsung-ufs.h - Header file for the UFS PHY of Samsung SoC
> > + *
> > + * Copyright (C) 2015 Samsung Electronics Co., Ltd.
> > + * Author: Seungwon Jeon <essuuj=40gmail.com>
> > + * Author: Alim Akhtar <alim.akhtar=40samsung.com>
> > + *
> > + */
> > +
> > +=23ifndef _PHY_EXYNOS_UFS_H_
> > +=23define _PHY_EXYNOS_UFS_H_
> > +
> > +=23include =22phy.h=22
> > +
> > +/* description for PHY calibration */ enum =7B
> > +	/* applicable to any */
> > +	PWR_DESC_ANY	=3D 0,
> > +	/* mode */
> > +	PWR_DESC_PWM	=3D 1,
> > +	PWR_DESC_HS	=3D 2,
> > +	/* series */
> > +	PWR_DESC_SER_A	=3D 1,
> > +	PWR_DESC_SER_B	=3D 2,
> > +	/* gear */
> > +	PWR_DESC_G1	=3D 1,
> > +	PWR_DESC_G2	=3D 2,
> > +	PWR_DESC_G3	=3D 3,
> > +	PWR_DESC_G4	=3D 4,
> > +	PWR_DESC_G5	=3D 5,
> > +	PWR_DESC_G6	=3D 6,
> > +	PWR_DESC_G7	=3D 7,
> > +	/* field mask */
> > +	MD_MASK		=3D 0x3,
> > +	SR_MASK		=3D 0x3,
> > +	GR_MASK		=3D 0x7,
> > +=7D;
> > +
> > +=23define PWR_MODE(g, s, m)	((((g) & GR_MASK) << 4) =7C=5C
> > +				 (((s) & SR_MASK) << 2) =7C ((m) & MD_MASK))
> > +=23define PWR_MODE_HS(g, s)	((((g) & GR_MASK) << 4) =7C=5C
> > +				 (((s) & SR_MASK) << 2) =7C PWR_DESC_HS)
> > +=23define PWR_MODE_HS_G1_ANY	PWR_MODE_HS(PWR_DESC_G1,
> PWR_DESC_ANY)
> > +=23define PWR_MODE_HS_G1_SER_A	PWR_MODE_HS(PWR_DESC_G1,
> PWR_DESC_SER_A)
> > +=23define PWR_MODE_HS_G1_SER_B	PWR_MODE_HS(PWR_DESC_G1,
> PWR_DESC_SER_B)
> > +=23define PWR_MODE_HS_G2_ANY	PWR_MODE_HS(PWR_DESC_G2,
> PWR_DESC_ANY)
> > +=23define PWR_MODE_HS_G2_SER_A	PWR_MODE_HS(PWR_DESC_G2,
> PWR_DESC_SER_A)
> > +=23define PWR_MODE_HS_G2_SER_B	PWR_MODE_HS(PWR_DESC_G2,
> PWR_DESC_SER_B)
> > +=23define PWR_MODE_HS_G3_ANY	PWR_MODE_HS(PWR_DESC_G3,
> PWR_DESC_ANY)
> > +=23define PWR_MODE_HS_G3_SER_A	PWR_MODE_HS(PWR_DESC_G3,
> PWR_DESC_SER_A)
> > +=23define PWR_MODE_HS_G3_SER_B	PWR_MODE_HS(PWR_DESC_G3,
> PWR_DESC_SER_B)
> > +=23define PWR_MODE_HS_ANY
> 	PWR_MODE(PWR_DESC_ANY,=5C
> > +					 PWR_DESC_ANY, PWR_DESC_HS)
> > +=23define PWR_MODE_PWM_ANY	PWR_MODE(PWR_DESC_ANY,=5C
> > +					 PWR_DESC_ANY, PWR_DESC_PWM)
> > +=23define PWR_MODE_ANY		PWR_MODE(PWR_DESC_ANY,=5C
> > +					 PWR_DESC_ANY, PWR_DESC_ANY)
> > +=23define IS_PWR_MODE_HS(d)	(((d) & MD_MASK) =3D=3D PWR_DESC_HS)
> > +=23define IS_PWR_MODE_PWM(d)	(((d) & MD_MASK) =3D=3D
> PWR_DESC_PWM)
> > +=23define IS_PWR_MODE_ANY(d)	((d) =3D=3D PWR_MODE_ANY)
> > +=23define IS_PWR_MODE_HS_ANY(d)	((d) =3D=3D PWR_MODE_HS_ANY)
> > +=23define COMP_PWR_MODE(a, b)		((a) =3D=3D (b))
> > +=23define COMP_PWR_MODE_GEAR(a, b)	((((a) >> 4) & GR_MASK) =3D=3D =5C
> > +					 (((b) >> 4) & GR_MASK))
> > +=23define COMP_PWR_MODE_SER(a, b)		((((a) >> 2) & SR_MASK)
> =3D=3D =5C
> > +					 (((b) >> 2) & SR_MASK))
> > +=23define COMP_PWR_MODE_MD(a, b)		(((a) & MD_MASK) =3D=3D
> ((b) &
> > MD_MASK))
> > +
> > +=23endif /* _PHY_EXYNOS_UFS_H_ */
> > --
> > 2.17.1
>=20
> Looks good.
> Reviewed-by: Kiwoong Kim <kwmad.kim=40xxxxxxx>
Thanks Kiwoong for review,
I will soon send V2 addressing review comments on other patches in this ser=
ies.

