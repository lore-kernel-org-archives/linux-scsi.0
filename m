Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402D1C4167B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 17:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLHRoH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 12:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiLHRoG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 12:44:06 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5DAF1B9DB
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 09:44:02 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221208174359epoutp020926e400278f3887441640885fc696d8~u4mXr-ZbF2775727757epoutp02Q
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 17:43:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221208174359epoutp020926e400278f3887441640885fc696d8~u4mXr-ZbF2775727757epoutp02Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1670521439;
        bh=CS7uOpZ0H3tyJOOgD4PCI/tznYNW58nsQaqvUZbQKt4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ms3Vt/oa1qNi6GSIt7mGfKKyUGsGgka23y33bjUlIh0os/g2n3aO+bnxAaCHBK2s7
         Ln+fNWHPcknZDEDf+4cGjNW3lywHyMmFQd/ZqAAHYtAwy7qd+d/8Kc2C6u8rWl8nwU
         s28ihLx8lisiDhNwxsHzzxghBBOOj2Dp/thuqGjM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221208174358epcas5p339419205ec18412d938b806ee590eb0c~u4mW6Tm6h2596425964epcas5p3_;
        Thu,  8 Dec 2022 17:43:58 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4NShND39t8z4x9Pp; Thu,  8 Dec
        2022 17:43:56 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CA.5B.56352.C5222936; Fri,  9 Dec 2022 02:43:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221208174355epcas5p29c85a6e40f529d96df2a108b53b657e5~u4mUpfdem3133031330epcas5p2H;
        Thu,  8 Dec 2022 17:43:55 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221208174355epsmtrp17139207218c66c40538b4ea91e54d070~u4mUopgYi2824128241epsmtrp1j;
        Thu,  8 Dec 2022 17:43:55 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-9f-6392225c1f88
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.38.14392.B5222936; Fri,  9 Dec 2022 02:43:55 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20221208174350epsmtip2dd57c32848f269e0ff339f91c969f0ff~u4mPs2Ped0660306603epsmtip2N;
        Thu,  8 Dec 2022 17:43:49 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Zhe Wang'" <zhewang116@gmail.com>,
        "'Zhe Wang'" <zhe.wang1@unisoc.com>
Cc:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>,
        <avri.altman@wdc.com>, <linux-scsi@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <orsonzhai@gmail.com>,
        <yuelin.tang@unisoc.com>, <zhenxiong.lai@unisoc.com>,
        <zhang.lyra@gmail.com>
In-Reply-To: <CAJxzgGoqqRjbm75evK2uZpZvbf2T7z21GQ827p4Fmfn399_WMA@mail.gmail.com>
Subject: RE: [PATCH v3 2/2] scsi: ufs-unisoc: Add support for Unisoc UFS
 host controller
Date:   Thu, 8 Dec 2022 23:13:45 +0530
Message-ID: <001501d90b2c$a4df1450$ee9d3cf0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJu7oDGscVkPyiQGSCSTHW6ZaeT6QGGuhw6AYh6OuUB2emx660RMOHw
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKJsWRmVeSWpSXmKPExsWy7bCmpm6M0qRkg+NHxCxe/rzKZjH/yDlW
        i0U3tjFZ9L14yGzRfX0Hm8Xy4/+YLKZ/mM1o0br3CLvFg/3GFssf7GK3uHl+OZvFtlln2C0m
        TrrH4sDrsXPWXXaPTas62TzuXNvD5jFh0QFGj49Pb7F4HG4/y+7xeZOcR/uBbqYAjqhsm4zU
        xJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygk5UUyhJzSoFC
        AYnFxUr6djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2Rlnmz6w
        Fqzexljxb7NWA2NvfRcjJ4eEgInEtMt7mbsYuTiEBHYzSrxZuoERwvnEKDGz7yJU5hujxIG/
        a9lhWi4v6IKq2ssoMevzLBYI5yWjxKUnMxlBqtgEdCV2LG5jA7FFBHwk9q+dC1bELLCRSWLT
        nEdACQ4OToFAiRcbuEBqhAWiJDquLGIBsVkEVCT29D4Fm8MrYCnxavdiZghbUOLkzCdgNcwC
        2hLLFr5mhrhIQeLn02WsELvcJF6dns4KUSMu8fLoEXaQvRICNzgkvmy9CLZXQsBF4vB5qF5h
        iVfHt0B9JiXxsr+NHaLEQ2LRHymIcIbE2+XrGSFse4kDV+awgJQwC2hKrN+lD7GJT6L39xMm
        iE5eiY42IYhqVYnmd1dZIGxpiYnd3awQtofEg+79zBMYFWch+WsWkr9mIbl/FsKyBYwsqxgl
        UwuKc9NTi00LjPNSy+HRnZyfu4kRnJ61vHcwPnrwQe8QIxMH4yFGCQ5mJRHeZcsmJgvxpiRW
        VqUW5ccXleakFh9iNAUG9kRmKdHkfGCGyCuJNzSxNDAxMzMzsTQ2M1QS5106pSNZSCA9sSQ1
        OzW1ILUIpo+Jg1OqgelR61td1avaTWcNmAuDnrUu/H3d4NCnLTMZ/3oaFi0988ydbV1cxf5r
        HDUHvoiFydkeZXCtmFTyKqla7cSGnynmBzO39Dxb+WExn6CMovWfSMtNx7a+1d67U+TPbrNU
        id7bvNlWybrX7rYKrp0Q4Rxcof8wyLfa13zT/P9phWf+RkW+Kpj297mqqgurBIPGjP1HDedc
        vd3L8NPhy/V6xmuWr5cbrhUs3SJrYbXOauEnN4tfmVqmqhJ1JzRUGbeITK6LPcI0d3fPQ+WJ
        JY6+1y5frXGe3tagvbxD/OElqfQiCccVf2aFq/R9Cp0rJfgnpmJPSs8y5lu92n8YrTrq51jO
        r9btE8lYznry9IMl25RYijMSDbWYi4oTAeL90otYBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvG600qRkg8tHjSxe/rzKZjH/yDlW
        i0U3tjFZ9L14yGzRfX0Hm8Xy4/+YLKZ/mM1o0br3CLvFg/3GFssf7GK3uHl+OZvFtlln2C0m
        TrrH4sDrsXPWXXaPTas62TzuXNvD5jFh0QFGj49Pb7F4HG4/y+7xeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujJ7dF9gKbm5krNi2opO9gXFxVRcjJ4eEgInE5QVdjCC2kMBuRokjP1Mh4tIS
        1zdOYIewhSVW/nsOZHMB1TxnlLizdgETSIJNQFdix+I2ti5GDg4RAT+JxV+1QMLMAnuZJE7e
        jIKo/8MoMfP+AVaQGk6BQIkXG7hAaoQFIiQur9sKtpdFQEViT+9TMJtXwFLi1e7FzBC2oMTJ
        mU9YIGZqS/Q+bGWEsZctfM0McZuCxM+ny1hBbBEBN4lXp6ezQtSIS7w8eoR9AqPwLCSjZiEZ
        NQvJqFlIWhYwsqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAiOUi3NHYzbV33QO8TI
        xMF4iFGCg1lJhHfZsonJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgt
        gskycXBKNTBFLJnwt5r5qE2EAVMPa8lX8a/nX9f7GVmeXOOw4Ufg7UXifL8/ubyRUFvyrO9/
        xdNyo8BF95pnq3cx8pr+//PX8bK1KJPHw5onJldKfzjNvSwX8P/5Q7aJ7d6fy85MU9rV7Sm6
        JqCqQLCE46K2S1DxB+FDK8/MFq79drHt2usXXKZP5k1cqf78asfZnrPbG5SK8jZ07Tb3XcNl
        JsfRckdY7Jjtqw+R2ZNMTwsst1by/nPR+XWOUHLK+rdmV4rrd2dbTiz3ZpqWpiLwbllpWVX/
        Lf7cuTJ+uTLGK+qmHLs4M7eN/ax6aYrZpms1sd8CjN/Pn/E12NVknw5vg7jjgSgpSafWXUuW
        9X8PnnLw0EIlluKMREMt5qLiRAAcrISzQQMAAA==
X-CMS-MailID: 20221208174355epcas5p29c85a6e40f529d96df2a108b53b657e5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221208053155epcas5p15cbd58a0a741f36cb583625dca83abf1
References: <20221122122030.7659-1-zhe.wang1@unisoc.com>
        <20221122122030.7659-3-zhe.wang1@unisoc.com>
        <CGME20221208053155epcas5p15cbd58a0a741f36cb583625dca83abf1@epcas5p1.samsung.com>
        <CAJxzgGoqqRjbm75evK2uZpZvbf2T7z21GQ827p4Fmfn399_WMA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Zhe Wang

>-----Original Message-----
>From: Zhe Wang =5Bmailto:zhewang116=40gmail.com=5D
>Sent: Thursday, December 8, 2022 11:02 AM
>To: Zhe Wang <zhe.wang1=40unisoc.com>
>Cc: martin.petersen=40oracle.com; jejb=40linux.ibm.com;
>krzysztof.kozlowski+dt=40linaro.org; robh+dt=40kernel.org;
>alim.akhtar=40samsung.com; avri.altman=40wdc.com; linux-
>scsi=40vger.kernel.org; devicetree=40vger.kernel.org; orsonzhai=40gmail.co=
m;
>yuelin.tang=40unisoc.com; zhenxiong.lai=40unisoc.com; zhang.lyra=40gmail.c=
om
>Subject: Re: =5BPATCH v3 2/2=5D scsi: ufs-unisoc: Add support for Unisoc U=
FS host
>controller
>
>Hi,
>
>A gentle ping.
>
>Best regards,
>Zhe
>
>
>On Tue, Nov 22, 2022 at 8:21 PM Zhe Wang <zhe.wang1=40unisoc.com> wrote:
>>
>> Add driver code for Unisoc ufs host controller, along with ufs
>> initialization.
>>
>> Signed-off-by: Zhe Wang <zhe.wang1=40unisoc.com>
>> ---
>>  drivers/ufs/host/Kconfig    =7C  12 +
>>  drivers/ufs/host/Makefile   =7C   1 +
>>  drivers/ufs/host/ufs-sprd.c =7C 457
>> ++++++++++++++++++++++++++++++++++++
>>  drivers/ufs/host/ufs-sprd.h =7C  73 ++++++
>>  4 files changed, 543 insertions(+)
>>  create mode 100644 drivers/ufs/host/ufs-sprd.c  create mode 100644
>> drivers/ufs/host/ufs-sprd.h
>>
>> diff --git a/drivers/ufs/host/Kconfig b/drivers/ufs/host/Kconfig index
>> 4cc2dbd79ed0..90a7142ec846 100644
>> --- a/drivers/ufs/host/Kconfig
>> +++ b/drivers/ufs/host/Kconfig
>> =40=40 -124,3 +124,15 =40=40 config SCSI_UFS_EXYNOS
>>
>>           Select this if you have UFS host controller on Samsung Exynos =
SoC.
>>           If unsure, say N.
>> +
>> +config SCSI_UFS_SPRD
>> +       tristate =22Unisoc specific hooks to UFS controller platform dri=
ver=22
>> +       depends on SCSI_UFSHCD_PLATFORM && (ARCH_SPRD =7C=7C
>COMPILE_TEST)
>> +       help
>> +         This selects the Unisoc specific additions to UFSHCD platform =
driver.
>> +         UFS host on Unisoc needs some vendor specific configuration be=
fore
>> +         accessing the hardware which includes PHY configuration and ve=
ndor
>> +         specific registers.
>> +
>> +         Select this if you have UFS controller on Unisoc chipset.
>> +         If unsure, say N.
>> diff --git a/drivers/ufs/host/Makefile b/drivers/ufs/host/Makefile
>> index 7717ca93e7d5..a946c3b35c9d 100644
>> --- a/drivers/ufs/host/Makefile
>> +++ b/drivers/ufs/host/Makefile
>> =40=40 -13,3 +13,4 =40=40 obj-=24(CONFIG_SCSI_UFS_HISI) +=3D ufs-hisi.o
>>  obj-=24(CONFIG_SCSI_UFS_MEDIATEK) +=3D ufs-mediatek.o
>>  obj-=24(CONFIG_SCSI_UFS_RENESAS) +=3D ufs-renesas.o
>>  obj-=24(CONFIG_SCSI_UFS_TI_J721E) +=3D ti-j721e-ufs.o
>> +obj-=24(CONFIG_SCSI_UFS_SPRD) +=3D ufs-sprd.o
Add above TI, alphabetical order w.r.t. vendor name

>> diff --git a/drivers/ufs/host/ufs-sprd.c b/drivers/ufs/host/ufs-sprd.c
>> new file mode 100644 index 000000000000..b952a154e549
>> --- /dev/null
>> +++ b/drivers/ufs/host/ufs-sprd.c
>> =40=40 -0,0 +1,457 =40=40
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * UNISOC UFS Host Controller driver
>> + *
>> + * Copyright (C) 2022 Unisoc, Inc.
>> + * Author: Zhe Wang <zhe.wang1=40unisoc.com>  */
>> +
>> +=23include <linux/arm-smccc.h>
>> +=23include <linux/mfd/syscon.h>
>> +=23include <linux/of.h>
>> +=23include <linux/platform_device.h>
>> +=23include <linux/regmap.h>
>> +=23include <linux/reset.h>
>> +=23include <linux/regulator/consumer.h>
>> +
>> +=23include <ufs/ufshcd.h>
>> +=23include =22ufshcd-pltfrm.h=22
>> +=23include =22ufs-sprd.h=22
>> +
>> +static const struct of_device_id ufs_sprd_of_match=5B=5D;
>> +
>> +static struct ufs_sprd_priv *ufs_sprd_get_priv_data(struct ufs_hba
>> +*hba) =7B
>> +       struct ufs_sprd_host *host =3D ufshcd_get_variant(hba);
>> +
>> +       WARN_ON(=21host->priv);
>> +       return host->priv;
>> +=7D
>> +
>> +static void ufs_sprd_regmap_update(struct ufs_sprd_priv *priv, unsigned
>int index,
>> +                               unsigned int reg, unsigned int bits,
>> +unsigned int val) =7B
>> +       regmap_update_bits(priv->sysci=5Bindex=5D.regmap, reg, bits, val=
);
>> +=7D
>> +
>> +static void ufs_sprd_regmap_read(struct ufs_sprd_priv *priv, unsigned i=
nt
>index,
>> +                               unsigned int reg, unsigned int *val) =7B
>> +       regmap_read(priv->sysci=5Bindex=5D.regmap, reg, val); =7D
>> +
>> +static void ufs_sprd_get_unipro_ver(struct ufs_hba *hba) =7B
>> +       struct ufs_sprd_host *host =3D ufshcd_get_variant(hba);
>> +
>> +       if (ufshcd_dme_get(hba, UIC_ARG_MIB(PA_LOCALVERINFO), &host-
>>unipro_ver))
>> +               host->unipro_ver =3D 0;
>> +=7D
>> +
>> +static void ufs_sprd_ctrl_uic_compl(struct ufs_hba *hba, bool enable)
>> +=7B
>> +       u32 set =3D ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
>> +
>> +       if (enable =3D=3D true)
>> +               set =7C=3D UIC_COMMAND_COMPL;
>> +       else
>> +               set &=3D =7EUIC_COMMAND_COMPL;
>> +       ufshcd_writel(hba, set, REG_INTERRUPT_ENABLE); =7D
>> +
>> +static int ufs_sprd_get_reset_ctrl(struct device *dev, struct
>> +ufs_sprd_rst *rci) =7B
>> +       rci->rc =3D devm_reset_control_get(dev, rci->name);
>> +       if (IS_ERR(rci->rc)) =7B
>> +               dev_err(dev, =22failed to get reset ctrl:%s=5Cn=22, rci-=
>name);
>> +               return PTR_ERR(rci->rc);
>> +       =7D
>> +
>> +       return 0;
>> +=7D
>> +
>> +static int ufs_sprd_get_syscon_reg(struct device *dev, struct
>> +ufs_sprd_syscon *sysci) =7B
>> +       sysci->regmap =3D syscon_regmap_lookup_by_phandle(dev->of_node,
>sysci->name);
>> +       if (IS_ERR(sysci->regmap)) =7B
>> +               dev_err(dev, =22failed to get ufs syscon:%s=5Cn=22, sysc=
i->name);
>> +               return PTR_ERR(sysci->regmap);
>> +       =7D
>> +
>> +       return 0;
>> +=7D
>> +
>> +static int ufs_sprd_get_vreg(struct device *dev, struct ufs_sprd_vreg
>> +*vregi) =7B
>> +       vregi->vreg =3D devm_regulator_get(dev, vregi->name);
>> +       if (IS_ERR(vregi->vreg)) =7B
>> +               dev_err(dev, =22failed to get vreg:%s=5Cn=22, vregi->nam=
e);
>> +               return PTR_ERR(vregi->vreg);
>> +       =7D
>> +
>> +       return 0;
>> +=7D
>> +
>> +static int ufs_sprd_parse_dt(struct device *dev, struct ufs_hba *hba,
>> +struct ufs_sprd_host *host) =7B
>> +       u32 i;
>> +       struct ufs_sprd_priv *priv =3D host->priv;
>> +       int ret =3D 0;
>> +
>> +       /* Parse UFS reset ctrl info */
>> +       for (i =3D 0; i < SPRD_UFS_RST_MAX; i++) =7B
>> +               if (=21priv->rci=5Bi=5D.name)
>> +                       continue;
>> +               ret =3D ufs_sprd_get_reset_ctrl(dev, &priv->rci=5Bi=5D);
>> +               if (ret)
>> +                       goto out;
>> +       =7D
>> +
>> +       /* Parse UFS syscon reg info */
>> +       for (i =3D 0; i < SPRD_UFS_SYSCON_MAX; i++) =7B
>> +               if (=21priv->sysci=5Bi=5D.name)
>> +                       continue;
>> +               ret =3D ufs_sprd_get_syscon_reg(dev, &priv->sysci=5Bi=5D=
);
>> +               if (ret)
>> +                       goto out;
>> +       =7D
>> +
>> +       /* Parse UFS vreg info */
>> +       for (i =3D 0; i < SPRD_UFS_VREG_MAX; i++) =7B
>> +               if (=21priv->vregi=5Bi=5D.name)
>> +                       continue;
>> +               ret =3D ufs_sprd_get_vreg(dev, &priv->vregi=5Bi=5D);
>> +               if (ret)
>> +                       goto out;
>> +       =7D
>> +
>> +out:
>> +       return ret;
>> +=7D
>> +
>> +static int ufs_sprd_common_init(struct ufs_hba *hba) =7B
>> +       struct device *dev =3D hba->dev;
>> +       struct ufs_sprd_host *host;
>> +       struct platform_device *pdev =3D to_platform_device(dev);
>> +       const struct of_device_id *of_id;
>> +       int ret =3D 0;
>> +
>> +       host =3D devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
>> +       if (=21host)
>> +               return -ENOMEM;
>> +
>> +       of_id =3D of_match_node(ufs_sprd_of_match, pdev->dev.of_node);
>> +       if (of_id->data =21=3D NULL)
>> +               host->priv =3D container_of(of_id->data, struct ufs_sprd=
_priv,
>> +                                         ufs_hba_sprd_vops);
>> +
>> +       host->hba =3D hba;
>> +       ufshcd_set_variant(hba, host);
>> +
>> +       hba->caps =7C=3D UFSHCD_CAP_CLK_GATING =7C
>> +               UFSHCD_CAP_CRYPTO =7C
>> +               UFSHCD_CAP_WB_EN;
>> +       hba->quirks =7C=3D UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS;
>> +
>> +       ret =3D ufs_sprd_parse_dt(dev, hba, host);
>> +
>> +       return ret;
>> +=7D
>> +
>> +static int sprd_ufs_pwr_change_notify(struct ufs_hba *hba,
>> +                                     enum ufs_notify_change_status stat=
us,
>> +                                     struct ufs_pa_layer_attr *dev_max_=
params,
>> +                                     struct ufs_pa_layer_attr
>> +*dev_req_params) =7B
>> +       struct ufs_sprd_host *host =3D ufshcd_get_variant(hba);
>> +
>> +       if (status =3D=3D PRE_CHANGE) =7B
>> +               memcpy(dev_req_params, dev_max_params,
>> +                       sizeof(struct ufs_pa_layer_attr));
>> +               if (host->unipro_ver >=3D UFS_UNIPRO_VER_1_8)
>> +                       ufshcd_dme_configure_adapt(hba, dev_req_params-
>>gear_tx,
>> +                                                  PA_INITIAL_ADAPT);
>> +       =7D
>> +
>> +       return 0;
>> +=7D
>> +
>> +static int ufs_sprd_suspend(struct ufs_hba *hba, enum ufs_pm_op
>pm_op,
>> +                           enum ufs_notify_change_status status) =7B
>> +       unsigned long flags;
>> +
>> +       if (status =3D=3D PRE_CHANGE) =7B
>> +               if (ufshcd_is_auto_hibern8_supported(hba)) =7B
>> +                       spin_lock_irqsave(hba->host->host_lock, flags);
>> +                       ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TI=
MER);
>> +                       spin_unlock_irqrestore(hba->host->host_lock, fla=
gs);
>> +               =7D
>> +       =7D
>> +
>> +       return 0;
>> +=7D
>> +
>> +static void ufs_sprd_n6_host_reset(struct ufs_hba *hba) =7B
>> +       struct ufs_sprd_priv *priv =3D ufs_sprd_get_priv_data(hba);
>> +
>> +       dev_info(hba->dev, =22ufs host reset=21=5Cn=22);
>> +
>> +       reset_control_assert(priv->rci=5BSPRD_UFSHCI_SOFT_RST=5D.rc);
>> +       usleep_range(1000, 1100);
>> +       reset_control_deassert(priv->rci=5BSPRD_UFSHCI_SOFT_RST=5D.rc);
>> +=7D
>> +
>> +static int ufs_sprd_n6_device_reset(struct ufs_hba *hba) =7B
>> +       struct ufs_sprd_priv *priv =3D ufs_sprd_get_priv_data(hba);
>> +
>> +       dev_info(hba->dev, =22ufs device reset=21=5Cn=22);
>> +
>> +       reset_control_assert(priv->rci=5BSPRD_UFS_DEV_RST=5D.rc);
>> +       usleep_range(1000, 1100);
>> +       reset_control_deassert(priv->rci=5BSPRD_UFS_DEV_RST=5D.rc);
>> +
>> +       return 0;
>> +=7D
>> +
>> +static void ufs_sprd_n6_key_acc_enable(struct ufs_hba *hba) =7B
>> +       u32 val;
>> +       u32 retry =3D 10;
>> +       struct arm_smccc_res res;
>> +
>> +check_hce:
>> +       /* Key access only can be enabled under HCE enable */
>> +       val =3D ufshcd_readl(hba, REG_CONTROLLER_ENABLE);
>> +       if (=21(val & CONTROLLER_ENABLE)) =7B
>> +               ufs_sprd_n6_host_reset(hba);
>> +               val =7C=3D CONTROLLER_ENABLE;
>> +               ufshcd_writel(hba, val, REG_CONTROLLER_ENABLE);
>> +               usleep_range(1000, 1100);
>> +               if (retry) =7B
>> +                       retry--;
>> +                       goto check_hce;
>> +               =7D
>> +               goto disable_crypto;
>> +       =7D
>> +
>> +       arm_smccc_smc(SPRD_SIP_SVC_STORAGE_UFS_CRYPTO_ENABLE,
>> +                     0, 0, 0, 0, 0, 0, 0, &res);
>> +       if (=21res.a0)
>> +               return;
>> +
>> +disable_crypto:
>> +       dev_err(hba->dev, =22key reg access enable fail, disable crypto=
=5Cn=22);
>> +       hba->caps &=3D =7EUFSHCD_CAP_CRYPTO; =7D
>> +
>> +static int ufs_sprd_n6_init(struct ufs_hba *hba) =7B
>> +       struct ufs_sprd_priv *priv;
>> +       int ret =3D 0;
>> +
>> +       ret =3D ufs_sprd_common_init(hba);
>> +       if (ret =21=3D 0)
>> +               return ret;
>> +
>> +       priv =3D ufs_sprd_get_priv_data(hba);
>> +
>> +       ret =3D regulator_enable(priv->vregi=5BSPRD_UFS_VDD_MPHY=5D.vreg=
);
>> +       if (ret)
>> +               return -ENODEV;
>> +
>> +       if (hba->caps & UFSHCD_CAP_CRYPTO)
>> +               ufs_sprd_n6_key_acc_enable(hba);
>> +
>> +       return 0;
>> +=7D
>> +
>> +static int ufs_sprd_n6_phy_init(struct ufs_hba *hba) =7B
>> +       int ret =3D 0;
>> +       uint32_t val =3D 0;
>> +       uint32_t retry =3D 10;
>> +       uint32_t offset;
>> +       struct ufs_sprd_priv *priv =3D ufs_sprd_get_priv_data(hba);
>> +
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x8132), 0x90);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x811F), 0x01);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8009,
>> +                               UIC_ARG_MPHY_RX_GEN_SEL_INDEX(0)), 0x01)=
;
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB_SEL(0x8009,
>> +                               UIC_ARG_MPHY_RX_GEN_SEL_INDEX(1)), 0x01)=
;
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xD085), 0x01);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0x8114), 0x01);
Instead of using magical numbers, please add macro for these DME offset if =
it is not already in include/ufs/unipro.h

>> +
>> +       do =7B
>> +               /* phy_sram_init_done */
>> +               ufs_sprd_regmap_read(priv, SPRD_UFS_ANLG, 0xc, &val);
>> +               if ((val & 0x1) =3D=3D 0x1) =7B
>> +                       for (offset =3D 0x40; offset < 0x42; offset++) =
=7B
>> +                               /* Lane afe calibration */
>> +                               ufshcd_dme_set(hba, UIC_ARG_MIB(0x8116),=
 0x1c);
>> +                               ufshcd_dme_set(hba, UIC_ARG_MIB(0x8117),=
 offset);
>> +                               ufshcd_dme_set(hba, UIC_ARG_MIB(0x8118),=
 0x04);
>> +                               ufshcd_dme_set(hba, UIC_ARG_MIB(0x8119),=
 0x00);
>> +                               ufshcd_dme_set(hba, UIC_ARG_MIB(0x811C),=
 0x01);
>> +                               ufshcd_dme_set(hba, UIC_ARG_MIB(0xD085),=
 0x01);
Same comment as above.
>> +                       =7D
>> +
>> +                       goto update_phy;
>> +               =7D
>> +               udelay(1000);
>> +               retry--;
>> +       =7D while (retry > 0);
>> +
>> +       ret =3D -ETIMEDOUT;
>> +       goto out;
>> +
>> +update_phy:
>> +       /* phy_sram_ext_ld_done */
>> +       ufs_sprd_regmap_update(priv, SPRD_UFS_ANLG, 0xc, 0x2, 0);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xD085), 0x01);
>> +       ufshcd_dme_set(hba, UIC_ARG_MIB(0xD0C1), 0x0);
>> +out:
>> +       return ret;
>> +=7D
>> +
>> +
>> +static int sprd_ufs_n6_hce_enable_notify(struct ufs_hba *hba,
>> +                                        enum ufs_notify_change_status
>> +status) =7B
>> +       int err =3D 0;
>> +       struct ufs_sprd_priv *priv =3D ufs_sprd_get_priv_data(hba);
>> +
>> +       if (status =3D=3D PRE_CHANGE) =7B
>> +               /* phy_sram_ext_ld_done */
>> +               ufs_sprd_regmap_update(priv, SPRD_UFS_ANLG, 0xc, 0x2, 0x=
2);
>> +               /* phy_sram_bypass */
>> +               ufs_sprd_regmap_update(priv, SPRD_UFS_ANLG, 0xc, 0x4,
>> + 0x4);
>> +
>> +               ufs_sprd_n6_host_reset(hba);
>> +
>> +               if (hba->caps & UFSHCD_CAP_CRYPTO)
>> +                       ufs_sprd_n6_key_acc_enable(hba);
>> +       =7D
>> +
>> +       if (status =3D=3D POST_CHANGE) =7B
>> +               err =3D ufs_sprd_n6_phy_init(hba);
>> +               if (err) =7B
>> +                       dev_err(hba->dev, =22Phy setup failed (%d)=5Cn=
=22, err);
>> +                       goto out;
>> +               =7D
>> +
>> +               ufs_sprd_get_unipro_ver(hba);
>> +       =7D
>> +out:
>> +       return err;
>> +=7D
>> +
>> +static void sprd_ufs_n6_h8_notify(struct ufs_hba *hba,
>> +                                 enum uic_cmd_dme cmd,
>> +                                 enum ufs_notify_change_status
>> +status) =7B
>> +       struct ufs_sprd_priv *priv =3D ufs_sprd_get_priv_data(hba);
>> +
>> +       if (status =3D=3D PRE_CHANGE) =7B
>> +               if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER)
>> +                       /*
>> +                        * Disable UIC COMPL INTR to prevent access to U=
FSHCI after
>> +                        * checking HCS.UPMCRS
>> +                        */
>> +                       ufs_sprd_ctrl_uic_compl(hba, false);
>> +
>> +               if (cmd =3D=3D UIC_CMD_DME_HIBER_EXIT) =7B
>> +                       ufs_sprd_regmap_update(priv, SPRD_UFS_AON_APB,
>APB_UFSDEV_REG,
>> +                               APB_UFSDEV_REFCLK_EN, APB_UFSDEV_REFCLK_=
EN);
>> +                       ufs_sprd_regmap_update(priv, SPRD_UFS_AON_APB,
>APB_USB31PLL_CTRL,
>> +                               APB_USB31PLLV_REF2MPHY,
>APB_USB31PLLV_REF2MPHY);
>> +               =7D
>> +       =7D
>> +
>> +       if (status =3D=3D POST_CHANGE) =7B
>> +               if (cmd =3D=3D UIC_CMD_DME_HIBER_EXIT)
>> +                       ufs_sprd_ctrl_uic_compl(hba, true);
>> +
>> +               if (cmd =3D=3D UIC_CMD_DME_HIBER_ENTER) =7B
>> +                       ufs_sprd_regmap_update(priv, SPRD_UFS_AON_APB,
>APB_UFSDEV_REG,
>> +                               APB_UFSDEV_REFCLK_EN, 0);
>> +                       ufs_sprd_regmap_update(priv, SPRD_UFS_AON_APB,
>APB_USB31PLL_CTRL,
>> +                               APB_USB31PLLV_REF2MPHY, 0);
>> +               =7D
>> +       =7D
>> +=7D
>> +
>> +static struct ufs_sprd_priv n6_ufs =3D =7B
>> +       .rci=5BSPRD_UFSHCI_SOFT_RST=5D =3D =7B .name =3D =22controller=
=22, =7D,
>> +       .rci=5BSPRD_UFS_DEV_RST=5D =3D =7B .name =3D =22device=22, =7D,
>> +
>> +       .sysci=5BSPRD_UFS_ANLG=5D =3D =7B .name =3D =22sprd,ufs-anlg-sys=
con=22, =7D,
>> +       .sysci=5BSPRD_UFS_AON_APB=5D =3D =7B .name =3D =22sprd,aon-apb-s=
yscon=22, =7D,
>> +
>> +       .vregi=5BSPRD_UFS_VDD_MPHY=5D =3D =7B .name =3D =22vdd-mphy=22, =
=7D,
>> +
>> +       .ufs_hba_sprd_vops =3D =7B
>> +               .name =3D =22sprd,ums9620-ufs=22,
>> +               .init =3D ufs_sprd_n6_init,
>> +               .hce_enable_notify =3D sprd_ufs_n6_hce_enable_notify,
>> +               .pwr_change_notify =3D sprd_ufs_pwr_change_notify,
>> +               .hibern8_notify =3D sprd_ufs_n6_h8_notify,
>> +               .device_reset =3D ufs_sprd_n6_device_reset,
>> +               .suspend =3D ufs_sprd_suspend,
>> +       =7D,
>> +=7D;
>> +
>> +static const struct of_device_id ufs_sprd_of_match=5B=5D =3D =7B
>> +       =7B .compatible =3D =22sprd,ums9620-ufs=22, .data =3D
>&n6_ufs.ufs_hba_sprd_vops=7D,
>> +       =7B=7D,
>> +=7D;
>> +
>> +static int ufs_sprd_probe(struct platform_device *pdev) =7B
>> +       int err;
>> +       struct device *dev =3D &pdev->dev;
>> +       const struct of_device_id *of_id;
>> +
>> +       of_id =3D of_match_node(ufs_sprd_of_match, dev->of_node);
>> +       err =3D ufshcd_pltfrm_init(pdev, of_id->data);
>> +       if (err)
>> +               dev_err(dev, =22ufshcd_pltfrm_init() failed %d=5Cn=22, e=
rr);
>> +
>> +       return err;
>> +=7D
>> +
>> +static int ufs_sprd_remove(struct platform_device *pdev) =7B
>> +       struct ufs_hba *hba =3D  platform_get_drvdata(pdev);
>> +
>> +       pm_runtime_get_sync(&(pdev)->dev);
>> +       ufshcd_remove(hba);
>> +       return 0;
>> +=7D
>> +
>> +static const struct dev_pm_ops ufs_sprd_pm_ops =3D =7B
>> +       SET_SYSTEM_SLEEP_PM_OPS(ufshcd_system_suspend,
>ufshcd_system_resume)
>> +       SET_RUNTIME_PM_OPS(ufshcd_runtime_suspend,
>ufshcd_runtime_resume, NULL)
>> +       .prepare         =3D ufshcd_suspend_prepare,
>> +       .complete        =3D ufshcd_resume_complete,
>> +=7D;
>> +
>> +static struct platform_driver ufs_sprd_pltform =3D =7B
>> +       .probe =3D ufs_sprd_probe,
>> +       .remove =3D ufs_sprd_remove,
>> +       .shutdown =3D ufshcd_pltfrm_shutdown,
>> +       .driver =3D =7B
>> +               .name =3D =22ufshcd-sprd=22,
>> +               .pm =3D &ufs_sprd_pm_ops,
>> +               .of_match_table =3D ufs_sprd_of_match,
Use of_match_ptr(ufs_sprd_of_match) instead

>> +       =7D,
>> +=7D;
>> +module_platform_driver(ufs_sprd_pltform);
>> +
>> +MODULE_AUTHOR(=22Zhe Wang <zhe.wang1=40unisoc.com>=22);
>> +MODULE_DESCRIPTION(=22Unisoc UFS Host Driver=22);
>MODULE_LICENSE(=22GPL
>> +v2=22);
>> diff --git a/drivers/ufs/host/ufs-sprd.h b/drivers/ufs/host/ufs-sprd.h
>> new file mode 100644 index 000000000000..8f685ddd56c8
>> --- /dev/null
>> +++ b/drivers/ufs/host/ufs-sprd.h
>> =40=40 -0,0 +1,73 =40=40
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * UNISOC UFS Host Controller driver
>> + *
>> + * Copyright (C) 2022 Unisoc, Inc.
>> + * Author: Zhe Wang <zhe.wang1=40unisoc.com>  */
>> +
>> +=23ifndef _UFS_SPRD_H_
>> +=23define _UFS_SPRD_H_
>> +
>> +=23define APB_UFSDEV_REG         0xCE8
>> +=23define APB_UFSDEV_REFCLK_EN   0x2
>> +=23define APB_USB31PLL_CTRL      0xCFC
>> +=23define APB_USB31PLLV_REF2MPHY 0x1
>> +
>> +=23define SPRD_SIP_SVC_STORAGE_UFS_CRYPTO_ENABLE                       =
  =5C
>> +       ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                         =
=5C
>> +                          ARM_SMCCC_SMC_32,                            =
=5C
>> +                          ARM_SMCCC_OWNER_SIP,                         =
=5C
>> +                          0x0301)
>> +
>> +enum SPRD_UFS_RST_INDEX =7B
>> +       SPRD_UFSHCI_SOFT_RST,
>> +       SPRD_UFS_DEV_RST,
>> +
>> +       SPRD_UFS_RST_MAX
>> +=7D;
>> +
>> +enum SPRD_UFS_SYSCON_INDEX =7B
>> +       SPRD_UFS_ANLG,
>> +       SPRD_UFS_AON_APB,
>> +
>> +       SPRD_UFS_SYSCON_MAX
>> +=7D;
>> +
>> +enum SPRD_UFS_VREG_INDEX =7B
>> +       SPRD_UFS_VDD_MPHY,
>> +
>> +       SPRD_UFS_VREG_MAX
>> +=7D;
>> +
>> +struct ufs_sprd_rst =7B
>> +       const char *name;
>> +       struct reset_control *rc;
>> +=7D;
>> +
>> +struct ufs_sprd_syscon =7B
>> +       const char *name;
>> +       struct regmap *regmap;
>> +=7D;
>> +
>> +struct ufs_sprd_vreg =7B
>> +       const char *name;
>> +       struct regulator *vreg;
>> +=7D;
>> +
>> +struct ufs_sprd_priv =7B
>> +       struct ufs_sprd_rst rci=5BSPRD_UFS_RST_MAX=5D;
>> +       struct ufs_sprd_syscon sysci=5BSPRD_UFS_SYSCON_MAX=5D;
>> +       struct ufs_sprd_vreg vregi=5BSPRD_UFS_VREG_MAX=5D;
>> +       const struct ufs_hba_variant_ops ufs_hba_sprd_vops; =7D;
>> +
>> +struct ufs_sprd_host =7B
>> +       struct ufs_hba *hba;
>> +       struct ufs_sprd_priv *priv;
>> +       void __iomem *ufs_dbg_mmio;
>> +
>> +       enum ufs_unipro_ver unipro_ver; =7D;
>> +
>> +=23endif /* _UFS_SPRD_H_ */
>> --
>> 2.17.1
>>

