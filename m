Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B14C18E5B
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 15:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B8C22051A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 15:45:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nvWdn8Vl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbgCPPpx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:45:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:30094 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731895AbgCPPpw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 11:45:52 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200316154542epoutp048c084ce28e060ca1b517af399664f1dc~801elFJQq2868728687epoutp04L
        for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2020 15:45:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200316154542epoutp048c084ce28e060ca1b517af399664f1dc~801elFJQq2868728687epoutp04L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1584373542;
        bh=NKPo1VZrrxUo6KlkjZOMyB6aZ8MfBr3eFe2/sBmYdCA=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=nvWdn8VlwVfRYCO0699cBk/oMeZzJ+Fb73aIeVe2Ft7YP5D3K1Sm96k4/cZQblpIq
         jMyS+GhTPhVSHS45Nt7K6xoUL1XmHW9my/RFVkhWu7eh8s5gI2OPsIVgI+NOtJDnMa
         pQ+J97tih8wIfq3udI0p0e6LimXO5recbqELxqOc=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200316154541epcas5p228493798baed8354a083162e97d47e25~801eH_Ngg2357023570epcas5p2w;
        Mon, 16 Mar 2020 15:45:41 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        01.D1.04782.52F9F6E5; Tue, 17 Mar 2020 00:45:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200316154540epcas5p2a178d36f596d7c57cb4b902f8dba3d7b~801dO3LUp3085530855epcas5p2e;
        Mon, 16 Mar 2020 15:45:40 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200316154540epsmtrp1c1a77c52f6f8904b95e5fd65dc2c86f9~801dODO8I1249912499epsmtrp17;
        Mon, 16 Mar 2020 15:45:40 +0000 (GMT)
X-AuditID: b6c32a49-8b3ff700000012ae-6f-5e6f9f250537
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B6.40.04158.42F9F6E5; Tue, 17 Mar 2020 00:45:40 +0900 (KST)
Received: from alimakhtar02 (unknown [107.111.84.32]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200316154539epsmtip28d06243412764fd0063c8a81021d2504~801bwL_2v1924219242epsmtip2X;
        Mon, 16 Mar 2020 15:45:39 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Kiwoong Kim'" <kwmad.kim@samsung.com>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <cpgs@samsung.com>
Cc:     <krzk@kernel.org>, <avri.altman@wdc.com>,
        <martin.petersen@oracle.com>, <cang@codeaurora.org>
In-Reply-To: <009301d5fb54$69df8aa0$3d9e9fe0$@samsung.com>
Subject: RE: [PATCH 4/5] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Date:   Mon, 16 Mar 2020 21:15:37 +0530
Message-ID: <000001d5fba9$f1f70440$d5e50cc0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGcomJoogAapdSxIIuFJfiljU0eNAK9iB1XAbEgk+0BrZ40KqiNLKDw
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsWy7bCmlq7q/Pw4g893dS1e/rzKZvFp/TJW
        i5eHNC3mHznHanH+/AZ2i5tbjrJYdF/fwWax/Pg/JovWvUfYHTg9Lvf1MnlsWtXJ5vHx6S0W
        j74tqxg9Pm+S82g/0M0UwBbFZZOSmpNZllqkb5fAlXHj7VbWgtfNLBUTz55jaWD8N4e5i5GT
        Q0LAROLo8YPsXYxcHEICuxkl9nVfZYZwPjFKTFk4DyrzjVFi1axtbDAt+26vZIRI7GWUmDn3
        DJTzilHi8czdYIPZBHQldixuYwNJiAhMZZT4smsHC0iCWSBZYt7yN0wgNqeAlcSbLyfYQWxh
        gUCJia9/s4LYLAKqEm8P9YOt4xWwlDg6ZxoLhC0ocXLmE6g52hLLFr6G+kJB4ufTZWC9IgJu
        EvObbzFD1IhLHP3ZA1Xzm03iyRwBCNtFYveN30wQtrDEq+Nb2CFsKYmX/W1ANgeQnS3Rs8sY
        IlwjsXTeMRYI217iwJU5LCAlzAKaEut36UOEeSUaNv5mh9jKJ9H7+wkTxBReiY42IYgSVYnm
        d1ehpkhLTOzuZp3AqDQLyV+zkPw1C8n9sxCWLWBkWcUomVpQnJueWmxaYJiXWq5XnJhbXJqX
        rpecn7uJEZymtDx3MM4653OIUYCDUYmHd0ZOfpwQa2JZcWXuIUYJDmYlEd7FhUAh3pTEyqrU
        ovz4otKc1OJDjNIcLErivJNYr8YICaQnlqRmp6YWpBbBZJk4OKUaGPf/MVp10/9k6LqV2lx2
        cTa3A99+Sw0463Rw45L9k7/orD3YwHhIS/rzK5fYmNlXZRJ6/IW2Ot3hWnHa+8rer4bFF24p
        iS85FtvbalUaITSlWaHQcUt9TM686gU/b36t+7rbYtOa74Fr/876EOc690BjY5Gb+Vf2sr9h
        ySL/mo69+rPi8eyo4JtKLMUZiYZazEXFiQD1dm70TwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsWy7bCSvK7K/Pw4g9MX9Sxe/rzKZvFp/TJW
        i5eHNC3mHznHanH+/AZ2i5tbjrJYdF/fwWax/Pg/JovWvUfYHTg9Lvf1MnlsWtXJ5vHx6S0W
        j74tqxg9Pm+S82g/0M0UwBbFZZOSmpNZllqkb5fAlfHt/i72gmVfmSveftvM0sC4vo+5i5GT
        Q0LARGLf7ZWMXYxcHEICuxklThy/xwSRkJa4vnECO4QtLLHy33N2iKIXjBJ9FxezgSTYBHQl
        dixuYwNJiAjMZJRYtHQ9C0iCWSBdomHDBzaIjteMEh3LjoJ1cApYSbz5cgJsrLCAv8SKG42s
        IDaLgKrE20P9YDW8ApYSR+dMY4GwBSVOznwCNVRb4unNp3D2soWvoX5QkPj5dBnYHBEBN4n5
        zbeYIWrEJY7+7GGewCg8C8moWUhGzUIyahaSlgWMLKsYJVMLinPTc4sNC4zyUsv1ihNzi0vz
        0vWS83M3MYJjTktrB+OJE/GHGAU4GJV4eB2y8uOEWBPLiitzDzFKcDArifAuLgQK8aYkVlal
        FuXHF5XmpBYfYpTmYFES55XPPxYpJJCeWJKanZpakFoEk2Xi4JRqYIy7yzX/hG+Ddpy2//of
        DerKks1rP874tLjn0g3xSeWqp3Jm7WrIKlRa+UpFqLdvpe/f2NsBU5pL2H3v3I+7q8tf8f/l
        k8A52QeSVunV1yRuX75dz+R8w95enysbHpW/ZhU3t0183JgXnXvtGm9PeeGPsiUK+mrHNnH8
        eTn9TZ2ZVOK3Za2Tm5VYijMSDbWYi4oTAQMkIwq1AgAA
X-CMS-MailID: 20200316154540epcas5p2a178d36f596d7c57cb4b902f8dba3d7b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-CPGSPASS: Y
CMS-TYPE: 105P
X-CMS-RootMailID: 20200306151026epcas5p2620f97b53e318c6a4a3520b2846e7d48
References: <20200306150529.3370-1-alim.akhtar@samsung.com>
        <CGME20200306151026epcas5p2620f97b53e318c6a4a3520b2846e7d48@epcas5p2.samsung.com>
        <20200306150529.3370-5-alim.akhtar@samsung.com>
        <009301d5fb54$69df8aa0$3d9e9fe0$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Kiwoong Kim <kwmad.kim=40samsung.com>
> Sent: 16 March 2020 11:03
> To: 'Alim Akhtar' <alim.akhtar=40samsung.com>; robh+dt=40kernel.org;
> devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org; cpgs=40samsun=
g.com
> Cc: krzk=40kernel.org; avri.altman=40wdc.com; martin.petersen=40oracle.co=
m;
> cang=40codeaurora.org
> Subject: RE: =5BPATCH 4/5=5D scsi: ufs-exynos: add UFS host support for E=
xynos SoCs
>=20
> > -----Original Message-----
> > From: Alim Akhtar <alim.akhtar=40samsung.com>
> > Sent: Saturday, March 7, 2020 12:05 AM
> > To: robh+dt=40kernel.org; devicetree=40vger.kernel.org; linux-
> > scsi=40vger.kernel.org
> > Cc: krzk=40kernel.org; avri.altman=40wdc.com; martin.petersen=40oracle.=
com;
> > kwmad.kim=40samsung.com; stanley.chu=40mediatek.com;
> cang=40codeaurora.org; Alim
> > Akhtar <alim.akhtar=40samsung.com>
> > Subject: =5BPATCH 4/5=5D scsi: ufs-exynos: add UFS host support for Exy=
nos
> > SoCs
> >
> > This patch introduces Exynos UFS host controller driver,
> > which mainly handles vendor-specific operations including
> > link startup, power mode change and hibernation/unhibernation.
> >
> > Signed-off-by: Seungwon Jeon <essuuj=40gmail.com>
> > Signed-off-by: Alim Akhtar <alim.akhtar=40samsung.com>
> > ---
> >  drivers/scsi/ufs/Kconfig      =7C   12 +
> >  drivers/scsi/ufs/Makefile     =7C    1 +
> >  drivers/scsi/ufs/ufs-exynos.c =7C 1399 +++++++++++++++++++++++++++++++=
++
> >  drivers/scsi/ufs/ufs-exynos.h =7C  268 +++++++
> >  drivers/scsi/ufs/unipro.h     =7C   41 +
> >  5 files changed, 1721 insertions(+)
> >  create mode 100644 drivers/scsi/ufs/ufs-exynos.c
> >  create mode 100644 drivers/scsi/ufs/ufs-exynos.h
> >
> > diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> > index d14c2243e02a..8fda908bce5b 100644
> > --- a/drivers/scsi/ufs/Kconfig
> > +++ b/drivers/scsi/ufs/Kconfig
> > =40=40 -160,3 +160,15 =40=40 config SCSI_UFS_BSG
> >
> >  	  Select this if you need a bsg device node for your UFS controller.
> >  	  If unsure, say N.
> > +
> > +config SCSI_UFS_EXYNOS
> > +	bool =22EXYNOS specific hooks to UFS controller platform driver=22
> > +	depends on SCSI_UFSHCD_PLATFORM && ARCH_EXYNOS =7C=7C
> COMPILE_TEST
> > +	select PHY_EXYNOS_UFS
> > +	help
> > +	  This selects the EXYNOS specific additions to UFSHCD platform
> > driver.
> > +	  UFS host on EXYNOS includes HCI and UNIPRO layer, and associates
> > with
> > +	  UFS-PHY driver.
> > +
> > +	  Select this if you have UFS host controller on EXYNOS chipset.
> > +	  If unsure, say N.
> > diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> > index 94c6c5d7334b..f0c5b95ec9cc 100644
> > --- a/drivers/scsi/ufs/Makefile
> > +++ b/drivers/scsi/ufs/Makefile
> > =40=40 -4,6 +4,7 =40=40 obj-=24(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc=
-g210-
> pci.o
> > ufshcd-dwc.o tc-dwc-g210.
> >  obj-=24(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o
> ufshcd-
> > dwc.o tc-dwc-g210.o
> >  obj-=24(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
> >  obj-=24(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
> > +obj-=24(CONFIG_SCSI_UFS_EXYNOS) +=3D ufs-exynos.o
> >  obj-=24(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
> >  ufshcd-core-y				+=3D ufshcd.o ufs-sysfs.o
> >  ufshcd-core-=24(CONFIG_SCSI_UFS_BSG)	+=3D ufs_bsg.o
> > diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exyno=
s.c
> > new file mode 100644
> > index 000000000000..29a7cca7eaf1
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-exynos.c
> > =40=40 -0,0 +1,1399 =40=40
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * UFS Host Controller driver for Exynos specific extensions
> > + *
> > + * Copyright (C) 2014-2015 Samsung Electronics Co., Ltd.
> > + * Author: Seungwon Jeon  <essuuj=40gmail.com>
> > + * Author: Alim Akhtar <alim.akhtar=40samsung.com>
> > + *
> > + */
> > +
> > +=23include <linux/clk.h>
> > +=23include <linux/module.h>
> > +=23include <linux/of.h>
> > +=23include <linux/of_address.h>
> > +=23include <linux/phy/phy-samsung-ufs.h>
> > +=23include <linux/platform_device.h>
> > +
> > +=23include =22ufshcd.h=22
> > +=23include =22ufshcd-pltfrm.h=22
> > +=23include =22ufshci.h=22
> > +=23include =22unipro.h=22
> > +
> > +=23include =22ufs-exynos.h=22
> > +
> > +/*
> > + * Exynos's Vendor specific registers for UFSHCI
> > + */
> > +=23define HCI_TXPRDT_ENTRY_SIZE	0x00
> > +=23define PRDT_PREFECT_EN		BIT(31)
> > +=23define PRDT_SET_SIZE(x)	((x) & 0x1F)
> > +=23define HCI_RXPRDT_ENTRY_SIZE	0x04
> > +=23define HCI_1US_TO_CNT_VAL	0x0C
> > +=23define CNT_VAL_1US_MASK	0x3FF
> > +=23define HCI_UTRL_NEXUS_TYPE	0x40
> > +=23define HCI_UTMRL_NEXUS_TYPE	0x44
> > +=23define HCI_SW_RST		0x50
> > +=23define UFS_LINK_SW_RST		BIT(0)
> > +=23define UFS_UNIPRO_SW_RST	BIT(1)
> > +=23define UFS_SW_RST_MASK		(UFS_UNIPRO_SW_RST =7C
> UFS_LINK_SW_RST)
> > +=23define HCI_DATA_REORDER	0x60
> > +=23define HCI_UNIPRO_APB_CLK_CTRL	0x68
> > +=23define UNIPRO_APB_CLK(v, x)	(((v) & =7E0xF) =7C ((x) & 0xF))
> > +=23define HCI_AXIDMA_RWDATA_BURST_LEN	0x6C
> > +=23define HCI_GPIO_OUT		0x70
> > +=23define HCI_ERR_EN_PA_LAYER	0x78
> > +=23define HCI_ERR_EN_DL_LAYER	0x7C
> > +=23define HCI_ERR_EN_N_LAYER	0x80
> > +=23define HCI_ERR_EN_T_LAYER	0x84
> > +=23define HCI_ERR_EN_DME_LAYER	0x88
> > +=23define HCI_CLKSTOP_CTRL	0xB0
> > +=23define REFCLK_STOP		BIT(2)
> > +=23define UNIPRO_MCLK_STOP	BIT(1)
> > +=23define UNIPRO_PCLK_STOP	BIT(0)
> > +=23define CLK_STOP_MASK		(REFCLK_STOP =7C=5C
> > +				 UNIPRO_MCLK_STOP =7C=5C
> > +				 UNIPRO_PCLK_STOP)
> > +=23define HCI_MISC		0xB4
> > +=23define REFCLK_CTRL_EN		BIT(7)
> > +=23define UNIPRO_PCLK_CTRL_EN	BIT(6)
> > +=23define UNIPRO_MCLK_CTRL_EN	BIT(5)
> > +=23define HCI_CORECLK_CTRL_EN	BIT(4)
> > +=23define CLK_CTRL_EN_MASK	(REFCLK_CTRL_EN =7C=5C
> > +				 UNIPRO_PCLK_CTRL_EN =7C=5C
> > +				 UNIPRO_MCLK_CTRL_EN)
> > +/* Device fatal error */
> > +=23define DFES_ERR_EN		BIT(31)
> > +=23define DFES_DEF_L2_ERRS	(UIC_DATA_LINK_LAYER_ERROR_RX_BUF_OF
> =7C=5C
> > +				 UIC_DATA_LINK_LAYER_ERROR_PA_INIT)
> > +=23define DFES_DEF_L3_ERRS
> 	(UIC_NETWORK_UNSUPPORTED_HEADER_TYPE =7C=5C
> > +				 UIC_NETWORK_BAD_DEVICEID_ENC =7C=5C
> > +
> UIC_NETWORK_LHDR_TRAP_PACKET_DROPPING)
> > +=23define DFES_DEF_L4_ERRS
> 	(UIC_TRANSPORT_UNSUPPORTED_HEADER_TYPE =7C=5C
> > +				 UIC_TRANSPORT_UNKNOWN_CPORTID =7C=5C
> > +				 UIC_TRANSPORT_NO_CONNECTION_RX =7C=5C
> > +				 UIC_TRANSPORT_BAD_TC)
> > +
> > +enum =7B
> > +	UNIPRO_L1_5 =3D 0,/* PHY Adapter */
> > +	UNIPRO_L2,	/* Data Link */
> > +	UNIPRO_L3,	/* Network */
> > +	UNIPRO_L4,	/* Transport */
> > +	UNIPRO_DME,	/* DME */
> > +=7D;
> > +
> > +/*
> > + * UNIPRO registers
> > + */
> > +=23define UNIPRO_COMP_VERSION			0x000
> > +=23define UNIPRO_DME_PWR_REQ			0x090
> > +=23define UNIPRO_DME_PWR_REQ_POWERMODE		0x094
> > +=23define UNIPRO_DME_PWR_REQ_LOCALL2TIMER0	0x098
> > +=23define UNIPRO_DME_PWR_REQ_LOCALL2TIMER1	0x09C
> > +=23define UNIPRO_DME_PWR_REQ_LOCALL2TIMER2	0x0A0
> > +=23define UNIPRO_DME_PWR_REQ_REMOTEL2TIMER0	0x0A4
> > +=23define UNIPRO_DME_PWR_REQ_REMOTEL2TIMER1	0x0A8
> > +=23define UNIPRO_DME_PWR_REQ_REMOTEL2TIMER2	0x0AC
> > +
> > +/*
> > + * UFS Protector registers
> > + */
> > +=23define UFSPRSECURITY	0x010
> > +=23define NSSMU		BIT(14)
> > +=23define UFSPSBEGIN0	0x200
> > +=23define UFSPSEND0	0x204
> > +=23define UFSPSLUN0	0x208
> > +=23define UFSPSCTRL0	0x20C
> > +
> > +static void exynos_ufs_auto_ctrl_hcc(struct exynos_ufs *ufs, bool en);
> > +static void exynos_ufs_ctrl_clkstop(struct exynos_ufs *ufs, bool en);
> > +
> > +static inline void exynos_ufs_enable_auto_ctrl_hcc(struct exynos_ufs *=
ufs)
> > +=7B
> > +	exynos_ufs_auto_ctrl_hcc(ufs, true);
> > +=7D
> > +
> > +static inline void exynos_ufs_disable_auto_ctrl_hcc(struct exynos_ufs
> > *ufs)
> > +=7B
> > +	exynos_ufs_auto_ctrl_hcc(ufs, false);
> > +=7D
> > +
> > +static inline void exynos_ufs_disable_auto_ctrl_hcc_save(
> > +					struct exynos_ufs *ufs, u32 *val)
> > +=7B
> > +	*val =3D hci_readl(ufs, HCI_MISC);
> > +	exynos_ufs_auto_ctrl_hcc(ufs, false);
> > +=7D
> > +
> > +static inline void exynos_ufs_auto_ctrl_hcc_restore(
> > +					struct exynos_ufs *ufs, u32 *val)
> > +=7B
> > +	hci_writel(ufs, *val, HCI_MISC);
> > +=7D
> > +
> > +static inline void exynos_ufs_gate_clks(struct exynos_ufs *ufs)
> > +=7B
> > +	exynos_ufs_ctrl_clkstop(ufs, true);
> > +=7D
> > +
> > +static inline void exynos_ufs_ungate_clks(struct exynos_ufs *ufs)
> > +=7B
> > +	exynos_ufs_ctrl_clkstop(ufs, false);
> > +=7D
> > +
> > +static int exynos7_ufs_drv_init(struct device *dev, struct exynos_ufs
> > *ufs)
> > +=7B
> > +	return 0;
> > +=7D
> > +
> > +static int exynos7_ufs_pre_link(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	u32 val =3D ufs->drv_data->uic_attr->pa_dbg_option_suite;
> > +	int i;
> > +
> > +	exynos_ufs_enable_ov_tm(hba);
> > +	for_each_ufs_tx_lane(ufs, i)
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x297, i), 0x17);
> > +	for_each_ufs_rx_lane(ufs, i) =7B
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x362, i), 0xff);
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x363, i), 0x00);
> > +	=7D
> > +	exynos_ufs_disable_ov_tm(hba);
> > +
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE_DYN),
> 0xf);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE_DYN),
> 0xf);
> > +	for_each_ufs_tx_lane(ufs, i)
> > +		ufshcd_dme_set(hba,
> > +			UIC_ARG_MIB_SEL(TX_HIBERN8_CONTROL, i), 0x0);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_TXPHY_CFGUPDT), 0x1);
> > +	udelay(1);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE), val =7C (1
> <<
> > 12));
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_SKIP_RESET_PHY), 0x1);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_SKIP_LINE_RESET), 0x1);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_LINE_RESET_REQ), 0x1);
> > +	udelay(1600);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE), val);
> > +
> > +	return 0;
> > +=7D
> > +
> > +static int exynos7_ufs_post_link(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	int i;
> > +
> > +	exynos_ufs_enable_ov_tm(hba);
> > +	for_each_ufs_tx_lane(ufs, i) =7B
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x28b, i), 0x83);
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x29a, i), 0x07);
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x277, i),
> > +			TX_LINERESET_N(exynos_ufs_calc_time_cntr(ufs,
> > 200000)));
> > +	=7D
> > +	exynos_ufs_disable_ov_tm(hba);
> > +
> > +	exynos_ufs_enable_dbg_mode(hba);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_SAVECONFIGTIME), 0xbb8);
> > +	exynos_ufs_disable_dbg_mode(hba);
> > +
> > +	return 0;
> > +=7D
> > +
> > +static int exynos7_ufs_pre_pwr_change(struct exynos_ufs *ufs,
> > +						struct uic_pwr_mode *pwr)
> > +=7B
> > +	unipro_writel(ufs, 0x22, UNIPRO_DBG_FORCE_DME_CTRL_STATE);
> > +
> > +	return 0;
> > +=7D
> > +
> > +static int exynos7_ufs_post_pwr_change(struct exynos_ufs *ufs,
> > +						struct uic_pwr_mode *pwr)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_RXPHY_CFGUPDT), 0x1);
> > +
> > +	if (pwr->lane =3D=3D 1) =7B
> > +		exynos_ufs_enable_dbg_mode(hba);
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
> > 0x1);
> > +		exynos_ufs_disable_dbg_mode(hba);
> > +	=7D
> > +
> > +	return 0;
> > +=7D
> > +
> > +/**
> > + * exynos_ufs_auto_ctrl_hcc - HCI core clock control by h/w
> > + * Control should be disabled in the below cases
> > + * - Before host controller S/W reset
> > + * - Access to UFS protector's register
> > + */
> > +static void exynos_ufs_auto_ctrl_hcc(struct exynos_ufs *ufs, bool en)
> > +=7B
> > +	u32 misc =3D hci_readl(ufs, HCI_MISC);
> > +
> > +	if (en)
> > +		hci_writel(ufs, misc =7C HCI_CORECLK_CTRL_EN, HCI_MISC);
> > +	else
> > +		hci_writel(ufs, misc & =7EHCI_CORECLK_CTRL_EN, HCI_MISC);
> > +=7D
> > +
> > +static void exynos_ufs_ctrl_clkstop(struct exynos_ufs *ufs, bool en)
> > +=7B
> > +	u32 ctrl =3D hci_readl(ufs, HCI_CLKSTOP_CTRL);
> > +	u32 misc =3D hci_readl(ufs, HCI_MISC);
> > +
> > +	if (en) =7B
> > +		hci_writel(ufs, misc =7C CLK_CTRL_EN_MASK, HCI_MISC);
> > +		hci_writel(ufs, ctrl =7C CLK_STOP_MASK, HCI_CLKSTOP_CTRL);
> > +	=7D else =7B
> > +		hci_writel(ufs, ctrl & =7ECLK_STOP_MASK, HCI_CLKSTOP_CTRL);
> > +		hci_writel(ufs, misc & =7ECLK_CTRL_EN_MASK, HCI_MISC);
> > +	=7D
> > +=7D
> > +
> > +static int exynos_ufs_get_clk_info(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	struct list_head *head =3D &hba->clk_list_head;
> > +	struct ufs_clk_info *clki;
> > +	u32 pclk_rate;
> > +	u32 f_min, f_max;
> > +	u8 div =3D 0;
> > +	int ret =3D 0;
> > +
> > +	if (=21head =7C=7C list_empty(head))
> > +		goto out;
> > +
> > +	list_for_each_entry(clki, head, list) =7B
> > +		if (=21IS_ERR(clki->clk)) =7B
> > +			if (=21strcmp(clki->name, =22core_clk=22))
> > +				ufs->clk_hci_core =3D clki->clk;
> > +			else if (=21strcmp(clki->name, =22sclk_unipro_main=22))
> > +				ufs->clk_unipro_main =3D clki->clk;
> > +		=7D
> > +	=7D
> > +
> > +	if (=21ufs->clk_hci_core =7C=7C =21ufs->clk_unipro_main) =7B
> > +		dev_err(hba->dev, =22failed to get clk info=5Cn=22);
> > +		ret =3D -EINVAL;
> > +		goto out;
> > +	=7D
> > +
> > +	ufs->mclk_rate =3D clk_get_rate(ufs->clk_unipro_main);
> > +	pclk_rate =3D clk_get_rate(ufs->clk_hci_core);
> > +	f_min =3D ufs->pclk_avail_min;
> > +	f_max =3D ufs->pclk_avail_max;
> > +
> > +	if (ufs->opts & EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL) =7B
> > +		do =7B
> > +			pclk_rate /=3D (div + 1);
> > +
> > +			if (pclk_rate <=3D f_max)
> > +				break;
> > +			div++;
> > +		=7D while (pclk_rate >=3D f_min);
> > +	=7D
> > +
> > +	if (unlikely(pclk_rate < f_min =7C=7C pclk_rate > f_max)) =7B
> > +		dev_err(hba->dev, =22not available pclk range %d=5Cn=22,
> > pclk_rate);
> > +		ret =3D -EINVAL;
> > +		goto out;
> > +	=7D
> > +
> > +	ufs->pclk_rate =3D pclk_rate;
> > +	ufs->pclk_div =3D div;
> > +
> > +out:
> > +	return ret;
> > +=7D
> > +
> > +static void exynos_ufs_set_unipro_pclk_div(struct exynos_ufs *ufs)
> > +=7B
> > +	if (ufs->opts & EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL) =7B
> > +		u32 val;
> > +
> > +		val =3D hci_readl(ufs, HCI_UNIPRO_APB_CLK_CTRL);
> > +		hci_writel(ufs, UNIPRO_APB_CLK(val, ufs->pclk_div),
> > +			   HCI_UNIPRO_APB_CLK_CTRL);
> > +	=7D
> > +=7D
> > +
> > +static void exynos_ufs_set_pwm_clk_div(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	struct exynos_ufs_uic_attr *attr =3D ufs->drv_data->uic_attr;
> > +
> > +	ufshcd_dme_set(hba,
> > +		UIC_ARG_MIB(CMN_PWM_CLK_CTRL), attr-
> >cmn_pwm_clk_ctrl);
> > +=7D
> > +
> > +static void exynos_ufs_calc_pwm_clk_div(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	struct exynos_ufs_uic_attr *attr =3D ufs->drv_data->uic_attr;
> > +	const unsigned int div =3D 30, mult =3D 20;
> > +	const unsigned long pwm_min =3D 3 * 1000 * 1000;
> > +	const unsigned long pwm_max =3D 9 * 1000 * 1000;
> > +	const int divs=5B=5D =3D =7B32, 16, 8, 4=7D;
> > +	unsigned long clk =3D 0, _clk, clk_period;
> > +	int i =3D 0, clk_idx =3D -1;
> > +
> > +	clk_period =3D UNIPRO_PCLK_PERIOD(ufs);
> > +	for (i =3D 0; i < ARRAY_SIZE(divs); i++) =7B
> > +		_clk =3D NSEC_PER_SEC * mult / (clk_period * divs=5Bi=5D * div);
> > +		if (_clk >=3D pwm_min && _clk <=3D pwm_max) =7B
> > +			if (_clk > clk) =7B
> > +				clk_idx =3D i;
> > +				clk =3D _clk;
> > +			=7D
> > +		=7D
> > +	=7D
> > +
> > +	if (clk_idx =3D=3D -1) =7B
> > +		ufshcd_dme_get(hba, UIC_ARG_MIB(CMN_PWM_CLK_CTRL),
> &clk_idx);
> > +		dev_err(hba->dev,
> > +			=22failed to decide pwm clock divider, will not
> > change=5Cn=22);
> > +	=7D
> > +
> > +	attr->cmn_pwm_clk_ctrl =3D clk_idx & PWM_CLK_CTRL_MASK;
> > +=7D
> > +
> > +long exynos_ufs_calc_time_cntr(struct exynos_ufs *ufs, long period)
> > +=7B
> > +	const int precise =3D 10;
> > +	long pclk_rate =3D ufs->pclk_rate;
> > +	long clk_period, fraction;
> > +
> > +	clk_period =3D UNIPRO_PCLK_PERIOD(ufs);
> > +	fraction =3D ((NSEC_PER_SEC % pclk_rate) * precise) / pclk_rate;
> > +
> > +	return (period * precise) / ((clk_period * precise) + fraction);
> > +=7D
> > +
> > +static void exynos_ufs_specify_phy_time_attr(struct exynos_ufs *ufs)
> > +=7B
> > +	struct exynos_ufs_uic_attr *attr =3D ufs->drv_data->uic_attr;
> > +	struct ufs_phy_time_cfg *t_cfg =3D &ufs->t_cfg;
> > +
> > +	t_cfg->tx_linereset_p =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->tx_dif_p_nsec);
> > +	t_cfg->tx_linereset_n =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->tx_dif_n_nsec);
> > +	t_cfg->tx_high_z_cnt =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->tx_high_z_cnt_nsec);
> > +	t_cfg->tx_base_n_val =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->tx_base_unit_nsec);
> > +	t_cfg->tx_gran_n_val =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->tx_gran_unit_nsec);
> > +	t_cfg->tx_sleep_cnt =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->tx_sleep_cnt);
> > +
> > +	t_cfg->rx_linereset =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->rx_dif_p_nsec);
> > +	t_cfg->rx_hibern8_wait =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->rx_hibern8_wait_nsec);
> > +	t_cfg->rx_base_n_val =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->rx_base_unit_nsec);
> > +	t_cfg->rx_gran_n_val =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->rx_gran_unit_nsec);
> > +	t_cfg->rx_sleep_cnt =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->rx_sleep_cnt);
> > +	t_cfg->rx_stall_cnt =3D
> > +		exynos_ufs_calc_time_cntr(ufs, attr->rx_stall_cnt);
> > +=7D
> > +
> > +static void exynos_ufs_config_phy_time_attr(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	struct ufs_phy_time_cfg *t_cfg =3D &ufs->t_cfg;
> > +	int i;
> > +
> > +	exynos_ufs_set_pwm_clk_div(ufs);
> > +
> > +	exynos_ufs_enable_ov_tm(hba);
> > +
> > +	for_each_ufs_rx_lane(ufs, i) =7B
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_FILLER_ENABLE,
> i),
> > +				ufs->drv_data->uic_attr->rx_filler_enable);
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(RX_LINERESET_VAL,
> i),
> > +				RX_LINERESET(t_cfg->rx_linereset));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(RX_BASE_NVAL_07_00, i),
> > +				RX_BASE_NVAL_L(t_cfg->rx_base_n_val));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(RX_BASE_NVAL_15_08, i),
> > +				RX_BASE_NVAL_H(t_cfg->rx_base_n_val));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(RX_GRAN_NVAL_07_00, i),
> > +				RX_GRAN_NVAL_L(t_cfg->rx_gran_n_val));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(RX_GRAN_NVAL_10_08, i),
> > +				RX_GRAN_NVAL_H(t_cfg->rx_gran_n_val));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(RX_OV_SLEEP_CNT_TIMER,
> > i),
> > +				RX_OV_SLEEP_CNT(t_cfg->rx_sleep_cnt));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(RX_OV_STALL_CNT_TIMER,
> > i),
> > +				RX_OV_STALL_CNT(t_cfg->rx_stall_cnt));
> > +	=7D
> > +
> > +	for_each_ufs_tx_lane(ufs, i) =7B
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_LINERESET_P_VAL, i),
> > +				TX_LINERESET_P(t_cfg->tx_linereset_p));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_HIGH_Z_CNT_07_00, i),
> > +				TX_HIGH_Z_CNT_L(t_cfg->tx_high_z_cnt));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_HIGH_Z_CNT_11_08, i),
> > +				TX_HIGH_Z_CNT_H(t_cfg->tx_high_z_cnt));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_BASE_NVAL_07_00, i),
> > +				TX_BASE_NVAL_L(t_cfg->tx_base_n_val));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_BASE_NVAL_15_08, i),
> > +				TX_BASE_NVAL_H(t_cfg->tx_base_n_val));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_GRAN_NVAL_07_00, i),
> > +				TX_GRAN_NVAL_L(t_cfg->tx_gran_n_val));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_GRAN_NVAL_10_08, i),
> > +				TX_GRAN_NVAL_H(t_cfg->tx_gran_n_val));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_OV_SLEEP_CNT_TIMER,
> > i),
> > +				TX_OV_H8_ENTER_EN =7C
> > +				TX_OV_SLEEP_CNT(t_cfg->tx_sleep_cnt));
> > +		ufshcd_dme_set(hba,
> UIC_ARG_MIB_SEL(TX_MIN_ACTIVATETIME, i),
> > +				ufs->drv_data->uic_attr-
> >tx_min_activatetime);
> > +	=7D
> > +
> > +	exynos_ufs_disable_ov_tm(hba);
> > +=7D
> > +
> > +static void exynos_ufs_config_phy_cap_attr(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	struct exynos_ufs_uic_attr *attr =3D ufs->drv_data->uic_attr;
> > +	int i;
> > +
> > +	exynos_ufs_enable_ov_tm(hba);
> > +
> > +	for_each_ufs_rx_lane(ufs, i) =7B
> > +		ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_HS_G1_SYNC_LENGTH_CAP, i),
> > +				attr->rx_hs_g1_sync_len_cap);
> > +		ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_HS_G2_SYNC_LENGTH_CAP, i),
> > +				attr->rx_hs_g2_sync_len_cap);
> > +		ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_HS_G3_SYNC_LENGTH_CAP, i),
> > +				attr->rx_hs_g3_sync_len_cap);
> > +		ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_HS_G1_PREP_LENGTH_CAP, i),
> > +				attr->rx_hs_g1_prep_sync_len_cap);
> > +		ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_HS_G2_PREP_LENGTH_CAP, i),
> > +				attr->rx_hs_g2_prep_sync_len_cap);
> > +		ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_HS_G3_PREP_LENGTH_CAP, i),
> > +				attr->rx_hs_g3_prep_sync_len_cap);
> > +	=7D
> > +
> > +	if (attr->rx_adv_fine_gran_sup_en =3D=3D 0) =7B
> > +		for_each_ufs_rx_lane(ufs, i) =7B
> > +			ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_ADV_GRANULARITY_CAP, i), 0);
> > +
> > +			if (attr->rx_min_actv_time_cap)
> > +				ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_MIN_ACTIVATETIME_CAP,
> > +						i), attr-
> >rx_min_actv_time_cap);
> > +
> > +			if (attr->rx_hibern8_time_cap)
> > +				ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_HIBERN8TIME_CAP, i),
> > +						attr->rx_hibern8_time_cap);
> > +		=7D
> > +	=7D else if (attr->rx_adv_fine_gran_sup_en =3D=3D 1) =7B
> > +		for_each_ufs_rx_lane(ufs, i) =7B
> > +			if (attr->rx_adv_fine_gran_step)
> > +				ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_ADV_GRANULARITY_CAP,
> > +						i), RX_ADV_FINE_GRAN_STEP(
> > +						attr->rx_adv_fine_gran_step));
> > +
> > +			if (attr->rx_adv_min_actv_time_cap)
> > +				ufshcd_dme_set(hba,
> > +					UIC_ARG_MIB_SEL(
> > +
> 	RX_ADV_MIN_ACTIVATETIME_CAP, i),
> > +						attr-
> >rx_adv_min_actv_time_cap);
> > +
> > +			if (attr->rx_adv_hibern8_time_cap)
> > +				ufshcd_dme_set(hba,
> > +
> 	UIC_ARG_MIB_SEL(RX_ADV_HIBERN8TIME_CAP,
> > +						i),
> > +						attr-
> >rx_adv_hibern8_time_cap);
> > +		=7D
> > +	=7D
> > +
> > +	exynos_ufs_disable_ov_tm(hba);
> > +=7D
> > +
> > +static void exynos_ufs_establish_connt(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	enum =7B
> > +		DEV_ID		=3D 0x00,
> > +		PEER_DEV_ID	=3D 0x01,
> > +		PEER_CPORT_ID	=3D 0x00,
> > +		TRAFFIC_CLASS	=3D 0x00,
> > +	=7D;
> > +
> > +	/* allow cport attributes to be set */
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> CPORT_IDLE);
> > +
> > +	/* local unipro attributes */
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), DEV_ID);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), TRUE);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), PEER_DEV_ID);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID),
> PEER_CPORT_ID);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS),
> CPORT_DEF_FLAGS);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_TRAFFICCLASS),
> TRAFFIC_CLASS);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CONNECTIONSTATE),
> > CPORT_CONNECTED);
> > +=7D
> > +
> > +static void exynos_ufs_config_smu(struct exynos_ufs *ufs)
> > +=7B
> > +	u32 reg, val;
> > +
> > +	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
> > +
> > +	/* make encryption disabled by default */
> > +	reg =3D ufsp_readl(ufs, UFSPRSECURITY);
> > +	ufsp_writel(ufs, reg =7C NSSMU, UFSPRSECURITY);
> > +	ufsp_writel(ufs, 0x0, UFSPSBEGIN0);
> > +	ufsp_writel(ufs, 0xffffffff, UFSPSEND0);
> > +	ufsp_writel(ufs, 0xff, UFSPSLUN0);
> > +	ufsp_writel(ufs, 0xf1, UFSPSCTRL0);
> > +
> > +	exynos_ufs_auto_ctrl_hcc_restore(ufs, &val);
> > +=7D
> > +
> > +static void exynos_ufs_config_sync_pattern_mask(struct exynos_ufs *ufs=
,
> > +					struct uic_pwr_mode *pwr)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	u8 g =3D pwr->gear;
> > +	u32 mask, sync_len;
> > +	enum =7B
> > +		SYNC_LEN_G1 =3D 80 * 1000, /* 80us */
> > +		SYNC_LEN_G2 =3D 40 * 1000, /* 44us */
> > +		SYNC_LEN_G3 =3D 20 * 1000, /* 20us */
> > +	=7D;
> > +	int i;
> > +
> > +	if (g =3D=3D 1)
> > +		sync_len =3D SYNC_LEN_G1;
> > +	else if (g =3D=3D 2)
> > +		sync_len =3D SYNC_LEN_G2;
> > +	else if (g =3D=3D 3)
> > +		sync_len =3D SYNC_LEN_G3;
> > +	else
> > +		return;
> > +
> > +	mask =3D exynos_ufs_calc_time_cntr(ufs, sync_len);
> > +	mask =3D (mask >> 8) & 0xff;
> > +
> > +	exynos_ufs_enable_ov_tm(hba);
> > +
> > +	for_each_ufs_rx_lane(ufs, i)
> > +		ufshcd_dme_set(hba,
> > +			UIC_ARG_MIB_SEL(RX_SYNC_MASK_LENGTH, i), mask);
> > +
> > +	exynos_ufs_disable_ov_tm(hba);
> > +=7D
> > +
> > +static int exynos_ufs_pre_pwr_mode(struct ufs_hba *hba,
> > +				struct ufs_pa_layer_attr *pwr_max,
> > +				struct ufs_pa_layer_attr *final)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	struct phy *generic_phy =3D ufs->phy;
> > +	struct uic_pwr_mode *pwr_req =3D &ufs->pwr_req;
> > +	struct uic_pwr_mode *pwr_act =3D &ufs->pwr_act;
> > +
> > +	final->gear_rx
> > +		=3D pwr_act->gear =3D min_t(u32, pwr_max->gear_rx, pwr_req-
> > >gear);
> > +	final->gear_tx
> > +		=3D pwr_act->gear =3D min_t(u32, pwr_max->gear_tx, pwr_req-
> > >gear);
> > +	final->lane_rx
> > +		=3D pwr_act->lane =3D min_t(u32, pwr_max->lane_rx, pwr_req-
> > >lane);
> > +	final->lane_tx
> > +		=3D pwr_act->lane =3D min_t(u32, pwr_max->lane_tx, pwr_req-
> > >lane);
> > +	final->pwr_rx =3D pwr_act->mode =3D pwr_req->mode;
> > +	final->pwr_tx =3D pwr_act->mode =3D pwr_req->mode;
> > +	final->hs_rate =3D pwr_act->hs_series =3D pwr_req->hs_series;
> > +
> > +	/* save and configure l2 timer */
> > +	pwr_act->l_l2_timer=5B0=5D =3D pwr_req->l_l2_timer=5B0=5D;
> > +	pwr_act->l_l2_timer=5B1=5D =3D pwr_req->l_l2_timer=5B1=5D;
> > +	pwr_act->l_l2_timer=5B2=5D =3D pwr_req->l_l2_timer=5B2=5D;
> > +	pwr_act->r_l2_timer=5B0=5D =3D pwr_req->r_l2_timer=5B0=5D;
> > +	pwr_act->r_l2_timer=5B1=5D =3D pwr_req->r_l2_timer=5B1=5D;
> > +	pwr_act->r_l2_timer=5B2=5D =3D pwr_req->r_l2_timer=5B2=5D;
> > +
> > +	ufshcd_dme_set(hba,
> > +		UIC_ARG_MIB(DL_FC0PROTTIMEOUTVAL), pwr_act-
> >l_l2_timer=5B0=5D);
> > +	ufshcd_dme_set(hba,
> > +		UIC_ARG_MIB(DL_TC0REPLAYTIMEOUTVAL), pwr_act-
> >l_l2_timer=5B1=5D);
> > +	ufshcd_dme_set(hba,
> > +		UIC_ARG_MIB(DL_AFC0REQTIMEOUTVAL), pwr_act-
> >l_l2_timer=5B2=5D);
> > +	ufshcd_dme_set(hba,
> > +		UIC_ARG_MIB(PA_PWRMODEUSERDATA0), pwr_act-
> >r_l2_timer=5B0=5D);
> > +	ufshcd_dme_set(hba,
> > +		UIC_ARG_MIB(PA_PWRMODEUSERDATA1), pwr_act-
> >r_l2_timer=5B1=5D);
> > +	ufshcd_dme_set(hba,
> > +		UIC_ARG_MIB(PA_PWRMODEUSERDATA2), pwr_act-
> >r_l2_timer=5B2=5D);
> > +
> > +	unipro_writel(ufs,
> > +		pwr_act->l_l2_timer=5B0=5D,
> UNIPRO_DME_PWR_REQ_LOCALL2TIMER0);
> > +	unipro_writel(ufs,
> > +		pwr_act->l_l2_timer=5B1=5D,
> UNIPRO_DME_PWR_REQ_LOCALL2TIMER1);
> > +	unipro_writel(ufs,
> > +		pwr_act->l_l2_timer=5B2=5D,
> UNIPRO_DME_PWR_REQ_LOCALL2TIMER2);
> > +	unipro_writel(ufs,
> > +		pwr_act->r_l2_timer=5B0=5D,
> UNIPRO_DME_PWR_REQ_REMOTEL2TIMER0);
> > +	unipro_writel(ufs,
> > +		pwr_act->r_l2_timer=5B1=5D,
> UNIPRO_DME_PWR_REQ_REMOTEL2TIMER1);
> > +	unipro_writel(ufs,
> > +		pwr_act->r_l2_timer=5B2=5D,
> UNIPRO_DME_PWR_REQ_REMOTEL2TIMER2);
> > +
> > +	if (ufs->drv_data->pre_pwr_change)
> > +		ufs->drv_data->pre_pwr_change(ufs, pwr_act);
> > +
> > +	if (IS_UFS_PWR_MODE_HS(pwr_act->mode)) =7B
> > +		exynos_ufs_config_sync_pattern_mask(ufs, pwr_act);
> > +
> > +		switch (pwr_act->hs_series) =7B
> > +		case PA_HS_MODE_A:
> > +		case PA_HS_MODE_B:
> > +			phy_calibrate(generic_phy);
> > +			break;
> > +		=7D
> > +	=7D
> > +
> > +	return 0;
> > +=7D
> > +
> > +=23define PWR_MODE_STR_LEN	64
> > +static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
> > +				struct ufs_pa_layer_attr *pwr_max,
> > +				struct ufs_pa_layer_attr *pwr_req)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	struct phy *generic_phy =3D ufs->phy;
> > +	struct uic_pwr_mode *pwr =3D &ufs->pwr_act;
> > +	char pwr_str=5BPWR_MODE_STR_LEN=5D =3D =22=22;
> > +	int ret =3D 0;
> > +
> > +	if (ufs->drv_data->post_pwr_change)
> > +		ufs->drv_data->post_pwr_change(ufs, pwr);
> > +
> > +	if (IS_UFS_PWR_MODE_HS(pwr->mode)) =7B
> > +		switch (pwr->hs_series) =7B
> > +		case PA_HS_MODE_A:
> > +		case PA_HS_MODE_B:
> > +			phy_calibrate(generic_phy);
> > +			break;
> > +		=7D
> > +
> > +		snprintf(pwr_str, sizeof(pwr_str), =22Fast%s series_%s G_%d
> > L_%d=22,
> > +			pwr->mode =3D=3D FASTAUTO_MODE ? =22_Auto=22 : =22=22,
> > +			pwr->hs_series =3D=3D PA_HS_MODE_A ? =22A=22 : =22B=22,
> > +			pwr->gear, pwr->lane);
> > +	=7D else if (IS_UFS_PWR_MODE_PWM(pwr->mode)) =7B
> > +		snprintf(pwr_str, sizeof(pwr_str), =22Slow%s G_%d L_%d=22,
> > +			pwr->mode =3D=3D SLOWAUTO_MODE ? =22_Auto=22 : =22=22,
> > +			pwr->gear, pwr->lane);
> > +	=7D
> > +
> > +	dev_info(hba->dev, =22Power mode change %d : %s=5Cn=22, ret, pwr_str)=
;
> > +	return ret;
> > +=7D
> > +
> > +static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
> > +						int tag, bool op)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	u32 type;
> > +
> > +	type =3D  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
> > +
> > +	if (op)
> > +		hci_writel(ufs, type =7C (1 << tag), HCI_UTRL_NEXUS_TYPE);
> > +	else
> > +		hci_writel(ufs, type & =7E(1 << tag), HCI_UTRL_NEXUS_TYPE);
> > +=7D
> > +
> > +static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
> > +						int tag, u8 func)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	u32 type;
> > +
> > +	type =3D  hci_readl(ufs, HCI_UTMRL_NEXUS_TYPE);
> > +
> > +	switch (func) =7B
> > +	case UFS_ABORT_TASK:
> > +	case UFS_QUERY_TASK:
> > +		hci_writel(ufs, type =7C (1 << tag), HCI_UTMRL_NEXUS_TYPE);
> > +		break;
> > +	case UFS_ABORT_TASK_SET:
> > +	case UFS_CLEAR_TASK_SET:
> > +	case UFS_LOGICAL_RESET:
> > +	case UFS_QUERY_TASK_SET:
> > +		hci_writel(ufs, type & =7E(1 << tag), HCI_UTMRL_NEXUS_TYPE);
> > +		break;
> > +	=7D
> > +=7D
> > +
> > +static void exynos_ufs_phy_init(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +	struct phy *generic_phy =3D ufs->phy;
> > +
> > +	if (ufs->avail_ln_rx =3D=3D 0 =7C=7C ufs->avail_ln_tx =3D=3D 0) =7B
> > +		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILRXDATALANES),
> > +			&ufs->avail_ln_rx);
> > +		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILTXDATALANES),
> > +			&ufs->avail_ln_tx);
> > +		WARN(ufs->avail_ln_rx =21=3D ufs->avail_ln_tx,
> > +			=22available data lane is not equal(rx:%d, tx:%d)=5Cn=22,
> > +			ufs->avail_ln_rx, ufs->avail_ln_tx);
> > +	=7D
> > +
> > +	phy_set_bus_width(generic_phy, ufs->avail_ln_rx);
> > +	phy_init(generic_phy);
> > +=7D
> > +
> > +static void exynos_ufs_config_unipro(struct exynos_ufs *ufs)
> > +=7B
> > +	struct ufs_hba *hba =3D ufs->hba;
> > +
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_CLK_PERIOD),
> > +		DIV_ROUND_UP(NSEC_PER_SEC, ufs->mclk_rate));
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTRAILINGCLOCKS),
> > +			ufs->drv_data->uic_attr->tx_trailingclks);
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE),
> > +			ufs->drv_data->uic_attr->pa_dbg_option_suite);
> > +=7D
> > +
> > +static void exynos_ufs_config_intr(struct exynos_ufs *ufs, u32 errs, u=
8
> > index)
> > +=7B
> > +	switch (index) =7B
> > +	case UNIPRO_L1_5:
> > +		hci_writel(ufs, DFES_ERR_EN =7C errs, HCI_ERR_EN_PA_LAYER);
> > +		break;
> > +	case UNIPRO_L2:
> > +		hci_writel(ufs, DFES_ERR_EN =7C errs, HCI_ERR_EN_DL_LAYER);
> > +		break;
> > +	case UNIPRO_L3:
> > +		hci_writel(ufs, DFES_ERR_EN =7C errs, HCI_ERR_EN_N_LAYER);
> > +		break;
> > +	case UNIPRO_L4:
> > +		hci_writel(ufs, DFES_ERR_EN =7C errs, HCI_ERR_EN_T_LAYER);
> > +		break;
> > +	case UNIPRO_DME:
> > +		hci_writel(ufs, DFES_ERR_EN =7C errs, HCI_ERR_EN_DME_LAYER);
> > +		break;
> > +	=7D
> > +=7D
> > +
> > +static int exynos_ufs_pre_link(struct ufs_hba *hba)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +
> > +	/* hci */
> > +	exynos_ufs_config_intr(ufs, DFES_DEF_L2_ERRS, UNIPRO_L2);
> > +	exynos_ufs_config_intr(ufs, DFES_DEF_L3_ERRS, UNIPRO_L3);
> > +	exynos_ufs_config_intr(ufs, DFES_DEF_L4_ERRS, UNIPRO_L4);
> > +	exynos_ufs_set_unipro_pclk_div(ufs);
> > +
> > +	/* unipro */
> > +	exynos_ufs_config_unipro(ufs);
> > +
> > +	/* m-phy */
> > +	exynos_ufs_phy_init(ufs);
> > +	exynos_ufs_config_phy_time_attr(ufs);
> > +	exynos_ufs_config_phy_cap_attr(ufs);
> > +
> > +	if (ufs->drv_data->pre_link)
> > +		ufs->drv_data->pre_link(ufs);
> > +
> > +	return 0;
> > +=7D
> > +
> > +static void exynos_ufs_fit_aggr_timeout(struct exynos_ufs *ufs)
> > +=7B
> > +	const u8 cntr_div =3D 40;
> > +	u32 val;
> > +
> > +	val =3D exynos_ufs_calc_time_cntr(ufs, IATOVAL_NSEC / cntr_div);
> > +	hci_writel(ufs, val & CNT_VAL_1US_MASK, HCI_1US_TO_CNT_VAL);
> > +=7D
> > +
> > +static int exynos_ufs_post_link(struct ufs_hba *hba)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	struct phy *generic_phy =3D ufs->phy;
> > +	struct exynos_ufs_uic_attr *attr =3D ufs->drv_data->uic_attr;
> > +
> > +	exynos_ufs_establish_connt(ufs);
> > +	exynos_ufs_fit_aggr_timeout(ufs);
> > +
> > +	hci_writel(ufs, 0xa, HCI_DATA_REORDER);
> > +	hci_writel(ufs, PRDT_PREFECT_EN =7C PRDT_SET_SIZE(12),
> > +			HCI_TXPRDT_ENTRY_SIZE);
> > +	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_RXPRDT_ENTRY_SIZE);
> > +	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
> > +	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
> > +	hci_writel(ufs, 0xf, HCI_AXIDMA_RWDATA_BURST_LEN);
> > +
> > +	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)
> > +		ufshcd_dme_set(hba,
> > +			UIC_ARG_MIB(T_DBG_SKIP_INIT_HIBERN8_EXIT),
> TRUE);
> > +
> > +	if (attr->pa_granularity) =7B
> > +		exynos_ufs_enable_dbg_mode(hba);
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_GRANULARITY),
> > +				attr->pa_granularity);
> > +		exynos_ufs_disable_dbg_mode(hba);
> > +
> > +		if (attr->pa_tactivate)
> > +			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE),
> > +					attr->pa_tactivate);
> > +		if (attr->pa_hibern8time &&
> > +		    =21(ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER))
> > +			ufshcd_dme_set(hba,
> UIC_ARG_MIB(PA_HIBERN8TIME),
> > +					attr->pa_hibern8time);
> > +	=7D
> > +
> > +	if (ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER) =7B
> > +		if (=21attr->pa_granularity)
> > +			ufshcd_dme_get(hba,
> UIC_ARG_MIB(PA_GRANULARITY),
> > +					&attr->pa_granularity);
> > +		if (=21attr->pa_hibern8time)
> > +			ufshcd_dme_get(hba,
> UIC_ARG_MIB(PA_HIBERN8TIME),
> > +					&attr->pa_hibern8time);
> > +		/*
> > +		 * not wait for HIBERN8 time to exit hibernation
> > +		 */
> > +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME), 0);
> > +
> > +		if (attr->pa_granularity < 1 =7C=7C attr->pa_granularity > 6) =7B
> > +			/* Valid range for granularity: 1 =7E 6 */
> > +			dev_warn(hba->dev,
> > +				=22%s: pa_granularty %d is invalid, assuming
> > backwards compatibility=5Cn=22,
> > +				__func__,
> > +				attr->pa_granularity);
> > +			attr->pa_granularity =3D 6;
> > +		=7D
> > +	=7D
> > +
> > +	phy_calibrate(generic_phy);
> > +
> > +	if (ufs->drv_data->post_link)
> > +		ufs->drv_data->post_link(ufs);
> > +
> > +	return 0;
> > +=7D
> > +
> > +static void exynos_ufs_specify_pwr_mode(struct device_node *np,
> > +				struct exynos_ufs *ufs)
> > +=7B
> > +	struct uic_pwr_mode *pwr =3D &ufs->pwr_req;
> > +	const char *str =3D NULL;
> > +
> > +	if (=21of_property_read_string(np, =22ufs,pwr-attr-mode=22, &str)) =
=7B
> > +		if (=21strncmp(str, =22FAST=22, sizeof(=22FAST=22)))
> > +			pwr->mode =3D FAST_MODE;
> > +		else if (=21strncmp(str, =22SLOW=22, sizeof(=22SLOW=22)))
> > +			pwr->mode =3D SLOW_MODE;
> > +		else if (=21strncmp(str, =22FAST_auto=22, sizeof(=22FAST_auto=22)))
> > +			pwr->mode =3D FASTAUTO_MODE;
> > +		else if (=21strncmp(str, =22SLOW_auto=22, sizeof(=22SLOW_auto=22)))
> > +			pwr->mode =3D SLOWAUTO_MODE;
> > +		else
> > +			pwr->mode =3D FAST_MODE;
> > +	=7D else =7B
> > +		pwr->mode =3D FAST_MODE;
> > +	=7D
> > +
> > +	if (of_property_read_u32(np, =22ufs,pwr-attr-lane=22, &pwr->lane))
> > +		pwr->lane =3D 1;
> > +
> > +	if (of_property_read_u32(np, =22ufs,pwr-attr-gear=22, &pwr->gear))
> > +		pwr->gear =3D 1;
> > +
> > +	if (IS_UFS_PWR_MODE_HS(pwr->mode)) =7B
> > +		if (=21of_property_read_string(np,
> > +					=22ufs,pwr-attr-hs-series=22, &str)) =7B
> > +			if (=21strncmp(str, =22HS_rate_b=22, sizeof(=22HS_rate_b=22)))
> > +				pwr->hs_series =3D PA_HS_MODE_B;
> > +			else if (=21strncmp(str, =22HS_rate_a=22,
> > +					sizeof(=22HS_rate_a=22)))
> > +				pwr->hs_series =3D PA_HS_MODE_A;
> > +			else
> > +				pwr->hs_series =3D PA_HS_MODE_A;
> > +		=7D else =7B
> > +			pwr->hs_series =3D PA_HS_MODE_A;
> > +		=7D
> > +	=7D
> > +
> > +	if (of_property_read_u32_array(
> > +		np, =22ufs,pwr-local-l2-timer=22, pwr->l_l2_timer, 3)) =7B
> > +		pwr->l_l2_timer=5B0=5D =3D FC0PROTTIMEOUTVAL;
> > +		pwr->l_l2_timer=5B1=5D =3D TC0REPLAYTIMEOUTVAL;
> > +		pwr->l_l2_timer=5B2=5D =3D AFC0REQTIMEOUTVAL;
> > +	=7D
> > +
> > +	if (of_property_read_u32_array(
> > +		np, =22ufs,pwr-remote-l2-timer=22, pwr->r_l2_timer, 3)) =7B
> > +		pwr->r_l2_timer=5B0=5D =3D FC0PROTTIMEOUTVAL;
> > +		pwr->r_l2_timer=5B1=5D =3D TC0REPLAYTIMEOUTVAL;
> > +		pwr->r_l2_timer=5B2=5D =3D AFC0REQTIMEOUTVAL;
> > +	=7D
> > +=7D
> > +
> > +static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *=
ufs)
> > +=7B
> > +	struct device_node *np =3D dev->of_node;
> > +	struct exynos_ufs_drv_data *drv_data =3D &exynos_ufs_drvs;
> > +	struct exynos_ufs_uic_attr *attr;
> > +	u32 freq=5B2=5D;
> > +	int ret;
> > +
> > +	while (drv_data->compatible) =7B
> > +		if (of_device_is_compatible(np, drv_data->compatible)) =7B
> > +			ufs->drv_data =3D drv_data;
> > +			break;
> > +		=7D
> > +		drv_data++;
> > +	=7D
> > +
> > +	if (ufs->drv_data && ufs->drv_data->uic_attr) =7B
> > +		attr =3D ufs->drv_data->uic_attr;
> > +	=7D else =7B
> > +		dev_err(dev, =22failed to get uic attributes=5Cn=22);
> > +		ret =3D -EINVAL;
> > +		goto out;
> > +	=7D
> > +
> > +	ret =3D of_property_read_u32_array(np,
> > +			=22pclk-freq-avail-range=22, freq, ARRAY_SIZE(freq));
> > +	if (=21ret) =7B
> > +		ufs->pclk_avail_min =3D freq=5B0=5D;
> > +		ufs->pclk_avail_max =3D freq=5B1=5D;
> > +	=7D else =7B
> > +		dev_err(dev, =22failed to get available pclk range=5Cn=22);
> > +		goto out;
> > +	=7D
> > +
> > +	exynos_ufs_specify_pwr_mode(np, ufs);
> > +
> > +	if (=21of_property_read_u32(np, =22ufs-rx-adv-fine-gran-sup_en=22,
> > +				&attr->rx_adv_fine_gran_sup_en)) =7B
> > +		if (attr->rx_adv_fine_gran_sup_en =3D=3D 0) =7B
> > +			/* 100us step */
> > +			if (of_property_read_u32(np,
> > +					=22ufs-rx-min-activate-time-cap=22,
> > +					&attr->rx_min_actv_time_cap))
> > +				dev_warn(dev,
> > +					=22ufs-rx-min-activate-time-cap is
> > empty=5Cn=22);
> > +
> > +			if (of_property_read_u32(np,
> > +					=22ufs-rx-hibern8-time-cap=22,
> > +					&attr->rx_hibern8_time_cap))
> > +				dev_warn(dev,
> > +					=22ufs-rx-hibern8-time-cap is empty=5Cn=22);
> > +		=7D else if (attr->rx_adv_fine_gran_sup_en =3D=3D 1) =7B
> > +			/* fine granularity step */
> > +			if (of_property_read_u32(np,
> > +					=22ufs-rx-adv-fine-gran-step=22,
> > +					&attr->rx_adv_fine_gran_step))
> > +				dev_warn(dev,
> > +					=22ufs-rx-adv-fine-gran-step is
> empty=5Cn=22);
> > +
> > +			if (of_property_read_u32(np,
> > +					=22ufs-rx-adv-min-activate-time-cap=22,
> > +					&attr->rx_adv_min_actv_time_cap))
> > +				dev_warn(dev,
> > +					=22ufs-rx-adv-min-activate-time-cap is
> > empty=5Cn=22);
> > +
> > +			if (of_property_read_u32(np,
> > +					=22ufs-rx-adv-hibern8-time-cap=22,
> > +					&attr->rx_adv_hibern8_time_cap))
> > +				dev_warn(dev,
> > +					=22ufs-rx-adv-hibern8-time-cap is
> > empty=5Cn=22);
> > +		=7D else =7B
> > +			dev_warn(dev,
> > +				=22not supported val for ufs-rx-adv-fine-gran-
> > sup_en %d=5Cn=22,
> > +				attr->rx_adv_fine_gran_sup_en);
> > +		=7D
> > +	=7D else =7B
> > +		attr->rx_adv_fine_gran_sup_en =3D 0xf;
> > +	=7D
> > +
> > +	if (=21of_property_read_u32(np,
> > +				=22ufs-pa-granularity=22, &attr->pa_granularity)) =7B
> > +		if (of_property_read_u32(np,
> > +				=22ufs-pa-tacctivate=22, &attr->pa_tactivate))
> > +			dev_warn(dev, =22ufs-pa-tacctivate is empty=5Cn=22);
> > +
> > +		if (of_property_read_u32(np,
> > +				=22ufs-pa-hibern8time=22, &attr->pa_hibern8time))
> > +			dev_warn(dev, =22ufs-pa-hibern8time is empty=5Cn=22);
> > +	=7D
> > +
> > +out:
> > +	return ret;
> > +=7D
> > +
> > +static int exynos_ufs_init(struct ufs_hba *hba)
> > +=7B
> > +	struct device *dev =3D hba->dev;
> > +	struct platform_device *pdev =3D to_platform_device(dev);
> > +	struct exynos_ufs *ufs;
> > +	struct resource *res;
> > +	int ret;
> > +
> > +	ufs =3D devm_kzalloc(dev, sizeof(*ufs), GFP_KERNEL);
> > +	if (=21ufs)
> > +		return -ENOMEM;
> > +
> > +	/* exynos-specific hci */
> > +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM,
> =22vs_hci=22);
> > +	ufs->reg_hci =3D devm_ioremap_resource(dev, res);
> > +	if (=21ufs->reg_hci) =7B
> > +		dev_err(dev, =22cannot ioremap for hci vendor register=5Cn=22);
> > +		return -ENOMEM;
> > +	=7D
> > +
> > +	/* unipro */
> > +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM,
> =22unipro=22);
> > +	ufs->reg_unipro =3D devm_ioremap_resource(dev, res);
> > +	if (=21ufs->reg_unipro) =7B
> > +		dev_err(dev, =22cannot ioremap for unipro register=5Cn=22);
> > +		return -ENOMEM;
> > +	=7D
> > +
> > +	/* ufs protector */
> > +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM,
> =22ufsp=22);
> > +	ufs->reg_ufsp =3D devm_ioremap_resource(dev, res);
> > +	if (=21ufs->reg_ufsp) =7B
> > +		dev_err(dev, =22cannot ioremap for ufs protector register=5Cn=22);
> > +		return -ENOMEM;
> > +	=7D
> > +
> > +	ret =3D exynos_ufs_parse_dt(dev, ufs);
> > +	if (ret) =7B
> > +		dev_err(dev, =22failed to get dt info.=5Cn=22);
> > +		goto out;
> > +	=7D
> > +
> > +	ufs->phy =3D devm_phy_get(dev, =22ufs-phy=22);
> > +	if (IS_ERR(ufs->phy)) =7B
> > +		ret =3D PTR_ERR(ufs->phy);
> > +		dev_err(dev, =22failed to get ufs-phy=5Cn=22);
> > +		goto out;
> > +	=7D
> > +
> > +	ret =3D phy_power_on(ufs->phy);
> > +	if (ret)
> > +		goto phy_exit;
> > +
> > +	ufs->hba =3D hba;
> > +	ufs->opts =3D ufs->drv_data->opts =7C
> > +		EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB =7C
> > +		EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER;
> > +	ufs->rx_sel_idx =3D PA_MAXDATALANES;
> > +	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX)
> > +		ufs->rx_sel_idx =3D 0;
> > +	hba->priv =3D (void *)ufs;
> > +	hba->quirks =3D ufs->drv_data->quirks;
> > +	if (ufs->drv_data->drv_init) =7B
> > +		ret =3D ufs->drv_data->drv_init(dev, ufs);
> > +		if (ret) =7B
> > +			dev_err(dev, =22failed to init drv-data=5Cn=22);
> > +			goto phy_off;
> > +		=7D
> > +	=7D
> > +
> > +	ret =3D exynos_ufs_get_clk_info(ufs);
> > +	if (ret)
> > +		goto phy_off;
> > +	exynos_ufs_specify_phy_time_attr(ufs);
> > +	exynos_ufs_config_smu(ufs);
> > +	return 0;
> > +
> > +phy_off:
> > +	phy_power_off(ufs->phy);
> > +phy_exit:
> > +	phy_exit(ufs->phy);
> > +	hba->priv =3D NULL;
> > +out:
> > +	return ret;
> > +=7D
> > +
> > +static int exynos_ufs_host_reset(struct ufs_hba *hba)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	unsigned long timeout =3D jiffies + msecs_to_jiffies(1);
> > +	u32 val;
> > +	int ret =3D 0;
> > +
> > +	exynos_ufs_disable_auto_ctrl_hcc_save(ufs, &val);
> > +
> > +	hci_writel(ufs, UFS_SW_RST_MASK, HCI_SW_RST);
> > +
> > +	do =7B
> > +		if (=21(hci_readl(ufs, HCI_SW_RST) & UFS_SW_RST_MASK))
> > +			goto out;
> > +	=7D while (time_before(jiffies, timeout));
> > +
> > +	dev_err(hba->dev, =22timeout host sw-reset=5Cn=22);
> > +	ret =3D -ETIMEDOUT;
> > +
> > +out:
> > +	exynos_ufs_auto_ctrl_hcc_restore(ufs, &val);
> > +	return ret;
> > +=7D
> > +
> > +static void exynos_ufs_dev_hw_reset(struct ufs_hba *hba)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +
> > +	hci_writel(ufs, 0 << 0, HCI_GPIO_OUT);
> > +	udelay(5);
> > +	hci_writel(ufs, 1 << 0, HCI_GPIO_OUT);
> > +=7D
> > +
> > +static void exynos_ufs_pre_hibern8(struct ufs_hba *hba, u8 enter)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	struct exynos_ufs_uic_attr *attr =3D ufs->drv_data->uic_attr;
> > +
> > +	if (=21enter) =7B
> > +		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
> > +			exynos_ufs_disable_auto_ctrl_hcc(ufs);
> > +		exynos_ufs_ungate_clks(ufs);
> > +
> > +		if (ufs->opts & EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER) =7B
> > +			const unsigned int granularity_tbl=5B=5D =3D =7B
> > +				1, 4, 8, 16, 32, 100
> > +			=7D;
> > +			int h8_time =3D attr->pa_hibern8time *
> > +				granularity_tbl=5Battr->pa_granularity - 1=5D;
> > +			unsigned long us;
> > +			s64 delta;
> > +
> > +			do =7B
> > +				delta =3D h8_time - ktime_us_delta(ktime_get(),
> > +							ufs->entry_hibern8_t);
> > +				if (delta <=3D 0)
> > +					break;
> > +
> > +				us =3D min_t(s64, delta, USEC_PER_MSEC);
> > +				if (us >=3D 10)
> > +					usleep_range(us, us + 10);
> > +			=7D while (1);
> > +		=7D
> > +	=7D
> > +=7D
> > +
> > +static void exynos_ufs_post_hibern8(struct ufs_hba *hba, u8 enter)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +
> > +	if (=21enter) =7B
> > +		struct uic_pwr_mode *pwr =3D &ufs->pwr_act;
> > +		u32 mode =3D 0;
> > +
> > +		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);
> > +		if (mode =21=3D (pwr->mode << 4 =7C pwr->mode)) =7B
> > +			dev_warn(hba->dev, =22%s: power mode change=5Cn=22,
> > __func__);
> > +			hba->pwr_info.pwr_rx =3D (mode >> 4) & 0xf;
> > +			hba->pwr_info.pwr_tx =3D mode & 0xf;
> > +			ufshcd_config_pwr_mode(hba, &hba-
> >max_pwr_info.info);
> > +		=7D
> > +
> > +		if (=21(ufs->opts &
> EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB))
> > +			exynos_ufs_establish_connt(ufs);
> > +	=7D else =7B
> > +		ufs->entry_hibern8_t =3D ktime_get();
> > +		exynos_ufs_gate_clks(ufs);
> > +		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
> > +			exynos_ufs_enable_auto_ctrl_hcc(ufs);
> > +	=7D
> > +=7D
> > +
> > +static int exynos_ufs_hce_enable_notify(struct ufs_hba *hba,
> > +					enum ufs_notify_change_status status)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +	int ret =3D 0;
> > +
> > +	switch (status) =7B
> > +	case PRE_CHANGE:
> > +		ret =3D exynos_ufs_host_reset(hba);
> > +		if (ret)
> > +			return ret;
> > +		exynos_ufs_dev_hw_reset(hba);
> > +		break;
> > +	case POST_CHANGE:
> > +		exynos_ufs_calc_pwm_clk_div(ufs);
> > +		if (=21(ufs->opts &
> EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL))
> > +			exynos_ufs_enable_auto_ctrl_hcc(ufs);
> > +		break;
> > +	=7D
> > +
> > +	return ret;
> > +=7D
> > +
> > +static int exynos_ufs_link_startup_notify(struct ufs_hba *hba,
> > +					  enum ufs_notify_change_status
> status)
> > +=7B
> > +	int ret =3D 0;
> > +
> > +	switch (status) =7B
> > +	case PRE_CHANGE:
> > +		ret =3D exynos_ufs_pre_link(hba);
> > +		break;
> > +	case POST_CHANGE:
> > +		ret =3D exynos_ufs_post_link(hba);
> > +		break;
> > +	=7D
> > +
> > +	return ret;
> > +=7D
> > +
> > +static int exynos_ufs_pwr_change_notify(struct ufs_hba *hba,
> > +					enum ufs_notify_change_status status,
> > +					struct ufs_pa_layer_attr *pwr_max,
> > +					struct ufs_pa_layer_attr *pwr_req)
> > +=7B
> > +	int ret =3D 0;
> > +
> > +	switch (status) =7B
> > +	case PRE_CHANGE:
> > +		ret =3D exynos_ufs_pre_pwr_mode(hba, pwr_max, pwr_req);
> > +		break;
> > +	case POST_CHANGE:
> > +		ret =3D exynos_ufs_post_pwr_mode(hba, NULL, pwr_req);
> > +		break;
> > +	=7D
> > +
> > +	return ret;
> > +=7D
> > +
> > +static void exynos_ufs_hibern8_notify(struct ufs_hba *hba,
> > +				     enum uic_cmd_dme enter,
> > +				     enum ufs_notify_change_status notify)
> > +=7B
> > +	switch ((u8)notify) =7B
> > +	case PRE_CHANGE:
> > +		exynos_ufs_pre_hibern8(hba, enter);
> > +		break;
> > +	case POST_CHANGE:
> > +		exynos_ufs_post_hibern8(hba, enter);
> > +		break;
> > +	=7D
> > +=7D
> > +
> > +static int exynos_ufs_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_o=
p)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +
> > +	if (=21ufshcd_is_link_active(hba))
> > +		phy_power_off(ufs->phy);
> > +
> > +	return 0;
> > +=7D
> > +
> > +static int exynos_ufs_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op=
)
> > +=7B
> > +	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +
> > +	if (=21ufshcd_is_link_active(hba))
> > +		phy_power_on(ufs->phy);
> > +
> > +	exynos_ufs_config_smu(ufs);
> > +
> > +	return 0;
> > +=7D
> > +
> > +static struct ufs_hba_variant_ops ufs_hba_exynos_ops =3D =7B
> > +	.name				=3D =22exynos_ufs=22,
> > +	.init				=3D exynos_ufs_init,
> > +	.hce_enable_notify		=3D exynos_ufs_hce_enable_notify,
> > +	.link_startup_notify		=3D exynos_ufs_link_startup_notify,
> > +	.pwr_change_notify		=3D exynos_ufs_pwr_change_notify,
> > +	.setup_xfer_req			=3D
> > exynos_ufs_specify_nexus_t_xfer_req,
> > +	.setup_task_mgmt		=3D exynos_ufs_specify_nexus_t_tm_req,
> > +	.hibern8_notify			=3D exynos_ufs_hibern8_notify,
> > +	.suspend			=3D exynos_ufs_suspend,
> > +	.resume				=3D exynos_ufs_resume,
> > +=7D;
> > +
> > +static int exynos_ufs_probe(struct platform_device *pdev)
> > +=7B
> > +	int err;
> > +	struct device *dev =3D &pdev->dev;
> > +
> > +	err =3D ufshcd_pltfrm_init(pdev, &ufs_hba_exynos_ops);
> > +	if (err)
> > +		dev_err(dev, =22ufshcd_pltfrm_init() failed %d=5Cn=22, err);
> > +
> > +	return err;
> > +=7D
> > +
> > +static int exynos_ufs_remove(struct platform_device *pdev)
> > +=7B
> > +	struct ufs_hba *hba =3D  platform_get_drvdata(pdev);
> > +
> > +	pm_runtime_get_sync(&(pdev)->dev);
> > +	ufshcd_remove(hba);
> > +	return 0;
> > +=7D
> > +
> > +struct exynos_ufs_drv_data exynos_ufs_drvs =3D =7B
> > +
> > +	.compatible		=3D =22samsung,exynos7-ufs=22,
> > +	.uic_attr		=3D &exynos7_uic_attr,
> > +	.quirks			=3D UFSHCD_QUIRK_PRDT_BYTE_GRAN =7C
> > +				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR =7C
> > +				  UFSHCI_QUIRK_BROKEN_HCE =7C
> > +				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR,
> > +	.opts			=3D EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL =7C
> > +				  EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL
> =7C
> > +				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
> > +	.drv_init		=3D exynos7_ufs_drv_init,
> > +	.pre_link		=3D exynos7_ufs_pre_link,
> > +	.post_link		=3D exynos7_ufs_post_link,
> > +	.pre_pwr_change		=3D exynos7_ufs_pre_pwr_change,
> > +	.post_pwr_change	=3D exynos7_ufs_post_pwr_change,
> > +=7D;
> > +
> > +static const struct of_device_id exynos_ufs_of_match=5B=5D =3D =7B
> > +	=7B .compatible =3D =22samsung,exynos7-ufs=22,
> > +	  .data	      =3D &exynos_ufs_drvs =7D,
> > +	=7B=7D,
> > +=7D;
> > +
> > +static const struct dev_pm_ops exynos_ufs_pm_ops =3D =7B
> > +	.suspend	=3D ufshcd_pltfrm_suspend,
> > +	.resume		=3D ufshcd_pltfrm_resume,
> > +	.runtime_suspend =3D ufshcd_pltfrm_runtime_suspend,
> > +	.runtime_resume  =3D ufshcd_pltfrm_runtime_resume,
> > +	.runtime_idle    =3D ufshcd_pltfrm_runtime_idle,
> > +=7D;
> > +
> > +static struct platform_driver exynos_ufs_pltform =3D =7B
> > +	.probe	=3D exynos_ufs_probe,
> > +	.remove	=3D exynos_ufs_remove,
> > +	.shutdown =3D ufshcd_pltfrm_shutdown,
> > +	.driver	=3D =7B
> > +		.name	=3D =22exynos-ufshc=22,
> > +		.pm	=3D &exynos_ufs_pm_ops,
> > +		.of_match_table =3D of_match_ptr(exynos_ufs_of_match),
> > +	=7D,
> > +=7D;
> > +module_platform_driver(exynos_ufs_pltform);
> > diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exyno=
s.h
> > new file mode 100644
> > index 000000000000..98efffc2c19a
> > --- /dev/null
> > +++ b/drivers/scsi/ufs/ufs-exynos.h
> > =40=40 -0,0 +1,268 =40=40
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * UFS Host Controller driver for Exynos specific extensions
> > + *
> > + * Copyright (C) 2014-2015 Samsung Electronics Co., Ltd.
> > + *
> > + */
> > +
> > +=23ifndef _UFS_EXYNOS_H_
> > +=23define _UFS_EXYNOS_H_
> > +
> > +/*
> > + * UNIPRO registers
> > + */
> > +=23define UNIPRO_DBG_FORCE_DME_CTRL_STATE		0x150
> > +
> > +/*
> > + * MIBs for PA debug registers
> > + */
> > +=23define PA_DBG_CLK_PERIOD	0x9514
> > +=23define PA_DBG_TXPHY_CFGUPDT	0x9518
> > +=23define PA_DBG_RXPHY_CFGUPDT	0x9519
> > +=23define PA_DBG_MODE		0x9529
> > +=23define PA_DBG_SKIP_RESET_PHY	0x9539
> > +=23define PA_DBG_OV_TM		0x9540
> > +=23define PA_DBG_SKIP_LINE_RESET	0x9541
> > +=23define PA_DBG_LINE_RESET_REQ	0x9543
> > +=23define PA_DBG_OPTION_SUITE	0x9564
> > +=23define PA_DBG_OPTION_SUITE_DYN	0x9565
> > +
> > +/*
> > + * MIBs for Transport Layer debug registers
> > + */
> > +=23define T_DBG_SKIP_INIT_HIBERN8_EXIT	0xc001
> > +
> > +/*
> > + * Exynos MPHY attributes
> > + */
> > +=23define TX_LINERESET_N_VAL	0x0277
> > +=23define TX_LINERESET_N(v)	(((v) >> 10) & 0xFF)
> > +=23define TX_LINERESET_P_VAL	0x027D
> > +=23define TX_LINERESET_P(v)	(((v) >> 12) & 0xFF)
> > +=23define TX_OV_SLEEP_CNT_TIMER	0x028E
> > +=23define TX_OV_H8_ENTER_EN	(1 << 7)
> > +=23define TX_OV_SLEEP_CNT(v)	(((v) >> 5) & 0x7F)
> > +=23define TX_HIGH_Z_CNT_11_08	0x028C
> > +=23define TX_HIGH_Z_CNT_H(v)	(((v) >> 8) & 0xF)
> > +=23define TX_HIGH_Z_CNT_07_00	0x028D
> > +=23define TX_HIGH_Z_CNT_L(v)	((v) & 0xFF)
> > +=23define TX_BASE_NVAL_07_00	0x0293
> > +=23define TX_BASE_NVAL_L(v)	((v) & 0xFF)
> > +=23define TX_BASE_NVAL_15_08	0x0294
> > +=23define TX_BASE_NVAL_H(v)	(((v) >> 8) & 0xFF)
> > +=23define TX_GRAN_NVAL_07_00	0x0295
> > +=23define TX_GRAN_NVAL_L(v)	((v) & 0xFF)
> > +=23define TX_GRAN_NVAL_10_08	0x0296
> > +=23define TX_GRAN_NVAL_H(v)	(((v) >> 8) & 0x3)
> > +
> > +=23define RX_FILLER_ENABLE	0x0316
> > +=23define RX_FILLER_EN		(1 << 1)
> > +=23define RX_LINERESET_VAL	0x0317
> > +=23define RX_LINERESET(v)	(((v) >> 12) & 0xFF)
> > +=23define RX_LCC_IGNORE		0x0318
> > +=23define RX_SYNC_MASK_LENGTH	0x0321
> > +=23define RX_HIBERN8_WAIT_VAL_BIT_20_16	0x0331
> > +=23define RX_HIBERN8_WAIT_VAL_BIT_15_08	0x0332
> > +=23define RX_HIBERN8_WAIT_VAL_BIT_07_00	0x0333
> > +=23define RX_OV_SLEEP_CNT_TIMER	0x0340
> > +=23define RX_OV_SLEEP_CNT(v)	(((v) >> 6) & 0x1F)
> > +=23define RX_OV_STALL_CNT_TIMER	0x0341
> > +=23define RX_OV_STALL_CNT(v)	(((v) >> 4) & 0xFF)
> > +=23define RX_BASE_NVAL_07_00	0x0355
> > +=23define RX_BASE_NVAL_L(v)	((v) & 0xFF)
> > +=23define RX_BASE_NVAL_15_08	0x0354
> > +=23define RX_BASE_NVAL_H(v)	(((v) >> 8) & 0xFF)
> > +=23define RX_GRAN_NVAL_07_00	0x0353
> > +=23define RX_GRAN_NVAL_L(v)	((v) & 0xFF)
> > +=23define RX_GRAN_NVAL_10_08	0x0352
> > +=23define RX_GRAN_NVAL_H(v)	(((v) >> 8) & 0x3)
> > +
> > +=23define CMN_PWM_CLK_CTRL	0x0402
> > +=23define PWM_CLK_CTRL_MASK	0x3
> > +
> > +=23define IATOVAL_NSEC		20000	/* unit: ns */
> > +=23define UNIPRO_PCLK_PERIOD(ufs) (NSEC_PER_SEC / ufs->pclk_rate)
> > +
> > +struct exynos_ufs;
> > +
> > +struct uic_pwr_mode =7B
> > +	u32 lane;
> > +	u32 gear;
> > +	u8 mode;
> > +	u8 hs_series;
> > +	u32 l_l2_timer=5B3=5D;	/* local */
> > +	u32 r_l2_timer=5B3=5D;	/* remote */
> > +=7D;
> > +
> > +struct exynos_ufs_uic_attr =7B
> > +	/* TX Attributes */
> > +	unsigned int tx_trailingclks;
> > +	unsigned int tx_dif_p_nsec;
> > +	unsigned int tx_dif_n_nsec;
> > +	unsigned int tx_high_z_cnt_nsec;
> > +	unsigned int tx_base_unit_nsec;
> > +	unsigned int tx_gran_unit_nsec;
> > +	unsigned int tx_sleep_cnt;
> > +	unsigned int tx_min_activatetime;
> > +	/* RX Attributes */
> > +	unsigned int rx_filler_enable;
> > +	unsigned int rx_dif_p_nsec;
> > +	unsigned int rx_hibern8_wait_nsec;
> > +	unsigned int rx_base_unit_nsec;
> > +	unsigned int rx_gran_unit_nsec;
> > +	unsigned int rx_sleep_cnt;
> > +	unsigned int rx_stall_cnt;
> > +	unsigned int rx_hs_g1_sync_len_cap;
> > +	unsigned int rx_hs_g2_sync_len_cap;
> > +	unsigned int rx_hs_g3_sync_len_cap;
> > +	unsigned int rx_hs_g1_prep_sync_len_cap;
> > +	unsigned int rx_hs_g2_prep_sync_len_cap;
> > +	unsigned int rx_hs_g3_prep_sync_len_cap;
> > +	/* Common Attributes */
> > +	unsigned int cmn_pwm_clk_ctrl;
> > +	/* Internal Attributes */
> > +	unsigned int pa_dbg_option_suite;
> > +	/* Changeable Attributes */
> > +	unsigned int rx_adv_fine_gran_sup_en;
> > +	unsigned int rx_adv_fine_gran_step;
> > +	unsigned int rx_min_actv_time_cap;
> > +	unsigned int rx_hibern8_time_cap;
> > +	unsigned int rx_adv_min_actv_time_cap;
> > +	unsigned int rx_adv_hibern8_time_cap;
> > +	unsigned int pa_granularity;
> > +	unsigned int pa_tactivate;
> > +	unsigned int pa_hibern8time;
> > +=7D;
> > +
> > +struct exynos_ufs_drv_data =7B
> > +	char *compatible;
> > +	struct exynos_ufs_uic_attr *uic_attr;
> > +	unsigned int quirks;
> > +	unsigned int opts;
> > +	/* SoC's specific operations */
> > +	int (*drv_init)(struct device *dev, struct exynos_ufs *ufs);
> > +	int (*pre_link)(struct exynos_ufs *ufs);
> > +	int (*post_link)(struct exynos_ufs *ufs);
> > +	int (*pre_pwr_change)(struct exynos_ufs *ufs, struct uic_pwr_mode
> > *pwr);
> > +	int (*post_pwr_change)(struct exynos_ufs *ufs,
> > +				struct uic_pwr_mode *pwr);
> > +=7D;
> > +
> > +struct ufs_phy_time_cfg =7B
> > +	u32 tx_linereset_p;
> > +	u32 tx_linereset_n;
> > +	u32 tx_high_z_cnt;
> > +	u32 tx_base_n_val;
> > +	u32 tx_gran_n_val;
> > +	u32 tx_sleep_cnt;
> > +	u32 rx_linereset;
> > +	u32 rx_hibern8_wait;
> > +	u32 rx_base_n_val;
> > +	u32 rx_gran_n_val;
> > +	u32 rx_sleep_cnt;
> > +	u32 rx_stall_cnt;
> > +=7D;
> > +
> > +struct exynos_ufs =7B
> > +	struct ufs_hba *hba;
> > +	struct phy *phy;
> > +	void __iomem *reg_hci;
> > +	void __iomem *reg_unipro;
> > +	void __iomem *reg_ufsp;
> > +	struct clk *clk_hci_core;
> > +	struct clk *clk_unipro_main;
> > +	struct clk *clk_apb;
> > +	u32 pclk_rate;
> > +	u32 pclk_div;
> > +	u32 pclk_avail_min;
> > +	u32 pclk_avail_max;
> > +	u32 mclk_rate;
> > +	int avail_ln_rx;
> > +	int avail_ln_tx;
> > +	int rx_sel_idx;
> > +	struct uic_pwr_mode pwr_req;	/* requested power mode */
> > +	struct uic_pwr_mode pwr_act;	/* actual power mode */
> > +	struct ufs_phy_time_cfg t_cfg;
> > +	ktime_t entry_hibern8_t;
> > +	struct exynos_ufs_drv_data *drv_data;
> > +
> > +	u32 opts;
> > +=23define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
> > +=23define EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB	BIT(1)
> > +=23define EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL	BIT(2)
> > +=23define EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX	BIT(3)
> > +=23define EXYNOS_UFS_OPT_USE_SW_HIBERN8_TIMER	BIT(4)
> > +=7D;
> > +
> > +=23define for_each_ufs_rx_lane(ufs, i) =5C
> > +	for (i =3D (ufs)->rx_sel_idx; =5C
> > +		i < (ufs)->rx_sel_idx + (ufs)->avail_ln_rx; i++)
> > +=23define for_each_ufs_tx_lane(ufs, i) =5C
> > +	for (i =3D 0; i < (ufs)->avail_ln_tx; i++)
> > +
> > +=23define EXYNOS_UFS_MMIO_FUNC(name)
> 	  =5C
> > +static inline void name=23=23_writel(struct exynos_ufs *ufs, u32 val, =
u32
> > reg)=5C
> > +=7B									  =5C
> > +	writel(val, ufs->reg_=23=23name + reg);				  =5C
> > +=7D									  =5C
> > +									  =5C
> > +static inline u32 name=23=23_readl(struct exynos_ufs *ufs, u32 reg)
> > =5C
> > +=7B									  =5C
> > +	return readl(ufs->reg_=23=23name + reg);				  =5C
> > +=7D
> > +
> > +EXYNOS_UFS_MMIO_FUNC(hci);
> > +EXYNOS_UFS_MMIO_FUNC(unipro);
> > +EXYNOS_UFS_MMIO_FUNC(ufsp);
> > +=23undef EXYNOS_UFS_MMIO_FUNC
> > +
> > +extern long exynos_ufs_calc_time_cntr(struct exynos_ufs *, long);
> > +
> > +static inline void exynos_ufs_enable_ov_tm(struct ufs_hba *hba)
> > +=7B
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), TRUE);
> > +=7D
> > +
> > +static inline void exynos_ufs_disable_ov_tm(struct ufs_hba *hba)
> > +=7B
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), FALSE);
> > +=7D
> > +
> > +static inline void exynos_ufs_enable_dbg_mode(struct ufs_hba *hba)
> > +=7B
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), TRUE);
> > +=7D
> > +
> > +static inline void exynos_ufs_disable_dbg_mode(struct ufs_hba *hba)
> > +=7B
> > +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), FALSE);
> > +=7D
> > +
> > +struct exynos_ufs_drv_data exynos_ufs_drvs;
> > +
> > +struct exynos_ufs_uic_attr exynos7_uic_attr =3D =7B
> > +	.tx_trailingclks		=3D 0x10,
> > +	.tx_dif_p_nsec			=3D 3000000,	/* unit: ns */
> > +	.tx_dif_n_nsec			=3D 1000000,	/* unit: ns */
> > +	.tx_high_z_cnt_nsec		=3D 20000,	/* unit: ns */
> > +	.tx_base_unit_nsec		=3D 100000,	/* unit: ns */
> > +	.tx_gran_unit_nsec		=3D 4000,		/* unit: ns */
> > +	.tx_sleep_cnt			=3D 1000,		/* unit: ns */
> > +	.tx_min_activatetime		=3D 0xa,
> > +	.rx_filler_enable		=3D 0x2,
> > +	.rx_dif_p_nsec			=3D 1000000,	/* unit: ns */
> > +	.rx_hibern8_wait_nsec		=3D 4000000,	/* unit: ns */
> > +	.rx_base_unit_nsec		=3D 100000,	/* unit: ns */
> > +	.rx_gran_unit_nsec		=3D 4000,		/* unit: ns */
> > +	.rx_sleep_cnt			=3D 1280,		/* unit: ns */
> > +	.rx_stall_cnt			=3D 320,		/* unit: ns */
> > +	.rx_hs_g1_sync_len_cap		=3D SYNC_LEN_COARSE(0xf),
> > +	.rx_hs_g2_sync_len_cap		=3D SYNC_LEN_COARSE(0xf),
> > +	.rx_hs_g3_sync_len_cap		=3D SYNC_LEN_COARSE(0xf),
> > +	.rx_hs_g1_prep_sync_len_cap	=3D PREP_LEN(0xf),
> > +	.rx_hs_g2_prep_sync_len_cap	=3D PREP_LEN(0xf),
> > +	.rx_hs_g3_prep_sync_len_cap	=3D PREP_LEN(0xf),
> > +	.pa_dbg_option_suite		=3D 0x30103,
> > +=7D;
> > +=23endif /* _UFS_EXYNOS_H_ */
> > diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
> > index 3dc4d8b76509..f441ab54829c 100644
> > --- a/drivers/scsi/ufs/unipro.h
> > +++ b/drivers/scsi/ufs/unipro.h
> > =40=40 -64,8 +64,25 =40=40
> >  =23define CFGRXOVR4				0x00E9
> >  =23define RXSQCTRL				0x00B5
> >  =23define CFGRXOVR6				0x00BF
> > +=23define RX_HS_G1_SYNC_LENGTH_CAP		0x008B
> > +=23define RX_HS_G1_PREP_LENGTH_CAP		0x008C
> > +=23define RX_HS_G2_SYNC_LENGTH_CAP		0x0094
> > +=23define RX_HS_G3_SYNC_LENGTH_CAP		0x0095
> > +=23define RX_HS_G2_PREP_LENGTH_CAP		0x0096
> > +=23define RX_HS_G3_PREP_LENGTH_CAP		0x0097
> > +=23define RX_ADV_GRANULARITY_CAP			0x0098
> > +=23define RX_MIN_ACTIVATETIME_CAP			0x008F
> > +=23define RX_HIBERN8TIME_CAP			0x0092
> > +=23define RX_ADV_HIBERN8TIME_CAP			0x0099
> > +=23define RX_ADV_MIN_ACTIVATETIME_CAP		0x009A
> > +
> >
> >  =23define is_mphy_tx_attr(attr)			(attr < RX_MODE)
> > +=23define RX_ADV_FINE_GRAN_STEP(x)		((((x) & 0x3) << 1) =7C 0x1)
> > +=23define SYNC_LEN_FINE(x)			((x) & 0x3F)
> > +=23define SYNC_LEN_COARSE(x)			((1 << 6) =7C ((x) & 0x3F))
> > +=23define PREP_LEN(x)				((x) & 0xF)
> > +
> >  =23define RX_MIN_ACTIVATETIME_UNIT_US		100
> >  =23define HIBERN8TIME_UNIT_US			100
> >
> > =40=40 -124,6 +141,7 =40=40
> >  =23define PA_PACPREQEOBTIMEOUT	0x1591
> >  =23define PA_HIBERN8TIME		0x15A7
> >  =23define PA_LOCALVERINFO		0x15A9
> > +=23define PA_GRANULARITY		0x15AA
> >  =23define PA_TACTIVATE		0x15A8
> >  =23define PA_PACPFRAMECOUNT	0x15C0
> >  =23define PA_PACPERRORCOUNT	0x15C1
> > =40=40 -181,6 +199,9 =40=40 enum =7B
> >  	UNCHANGED	=3D 7,
> >  =7D;
> >
> > +=23define IS_UFS_PWR_MODE_HS(m)	(((m) =3D=3D FAST_MODE) =7C=7C ((m) =
=3D=3D
> > FASTAUTO_MODE))
> > +=23define IS_UFS_PWR_MODE_PWM(m)	(((m) =3D=3D SLOW_MODE) =7C=7C ((m)
> =3D=3D
> > SLOWAUTO_MODE))
> > +
> >  /* PA TX/RX Frequency Series */
> >  enum =7B
> >  	PA_HS_MODE_A	=3D 1,
> > =40=40 -242,6 +263,11 =40=40 enum ufs_unipro_ver =7B
> >  =23define DL_PEERTC1PRESENT	0x2066
> >  =23define DL_PEERTC1RXINITCREVAL	0x2067
> >
> > +/* Default value of L2 Timer */
> > +=23define FC0PROTTIMEOUTVAL	8191
> > +=23define TC0REPLAYTIMEOUTVAL	65535
> > +=23define AFC0REQTIMEOUTVAL	32767
> > +
> >  /*
> >   * Network Layer Attributes
> >   */
> > =40=40 -284,4 +310,19 =40=40 enum =7B
> >  	TRUE,
> >  =7D;
> >
> > +/* CPort setting */
> > +=23define E2EFC_ON	(1 << 0)
> > +=23define E2EFC_OFF	(0 << 0)
> > +=23define CSD_N_ON	(0 << 1)
> > +=23define CSD_N_OFF	(1 << 1)
> > +=23define CSV_N_ON	(0 << 2)
> > +=23define CSV_N_OFF	(1 << 2)
> > +=23define CPORT_DEF_FLAGS	(CSV_N_OFF =7C CSD_N_OFF =7C E2EFC_OFF)
> > +
> > +/* CPort connection state */
> > +enum =7B
> > +	CPORT_IDLE =3D 0,
> > +	CPORT_CONNECTED,
> > +=7D;
> > +
> >  =23endif /* _UNIPRO_H_ */
> > --
> > 2.17.1
>=20
> Looks good.
> Reviewed-by: Kiwoong Kim <kwmad.kim=40xxxxxxx>
Thanks Kiwoong for review,
I will soon send V2 addressing review comments on other patches in this ser=
ies.


