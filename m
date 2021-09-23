Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010D1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:40:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C284C6109E
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbhIWEmP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 00:42:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24735 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhIWEmO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 00:42:14 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210923044042epoutp02167c5316d5a303aea7d7c418bfbe5150~nWblUmM4g2442324423epoutp02u
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 04:40:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210923044042epoutp02167c5316d5a303aea7d7c418bfbe5150~nWblUmM4g2442324423epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632372042;
        bh=Tira1m6L4Jq2Xo+c1TKSGJmKP7aYh8lCUQBYA2R2Kc0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=X/gA2m3Iw9DEjkRJUcjl0plxTgTVUWroPP57kMTtMNY9dnb8TTNSZz9zMozkmUUvN
         oIC6Qz4RXi2sA2+R5v1QgialHSqnZRoGBKjhCiIoDJaKsGwxHTAXShYGtlCwpPzk40
         iYD452/V4cBSwzmymQzpoOnc9Xor8m209akIhxoE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20210923044041epcas5p35369067f0867464e2504b9ee5d091651~nWbkzU-aV2313823138epcas5p3y;
        Thu, 23 Sep 2021 04:40:41 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4HFMsw4hL4z4x9QB; Thu, 23 Sep
        2021 04:40:36 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A5.80.10367.0450C416; Thu, 23 Sep 2021 13:40:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210923042846epcas5p23c4e7f7f770f7910a0ded12113ee1e0d~nWRK0XQw12641926419epcas5p27;
        Thu, 23 Sep 2021 04:28:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210923042846epsmtrp1e45bc21b3f107e5f80c8b303c29d7694~nWRKza5Rc1733117331epsmtrp1f;
        Thu, 23 Sep 2021 04:28:46 +0000 (GMT)
X-AuditID: b6c32a4a-b17ff7000000287f-da-614c0540e007
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.01.09091.E720C416; Thu, 23 Sep 2021 13:28:46 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923042844epsmtip1bade080d66f4dee77eaa9ee763212da8~nWRIZH5y60381103811epsmtip1H;
        Thu, 23 Sep 2021 04:28:44 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Chanho Park'" <chanho61.park@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <20210917065436.145629-11-chanho61.park@samsung.com>
Subject: RE: [PATCH v3 10/17] scsi: ufs: ufs-exynos: support custom version
 of ufs_hba_variant_ops
Date:   Thu, 23 Sep 2021 09:58:41 +0530
Message-ID: <001601d7b033$7fd2efb0$7f78cf10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQGu1qu5AcHKNVap7T1sMA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta0xTZxj2XDi0CONwk082THcMU0uKLddTAhNnY06EH0wzs5kxPKNnBXtN
        T5lsIRuTRJDbiqREu61RCFjZJleRcZmAqwRxwAaGjmi4WNDCLlwERiRsLS0b/57nfZ/ney/f
        93EQ/6dYCCdLpWO0KlpBYF5o671DBwVJHim0sGScS/bbvsNI+/ojjOyZuoSSlQvrCLlUX+tB
        jtwNJ0t+OEYO6Ktg0lZvRMgqaytMNv7xN0z+1mJByStDP8Jk8VgbRt7o24STfKmR0WTKmFeK
        USNlpTDVbOZT1Z12mGqqu4RR+qpuiFqrL8SoxZlxlCprqYOo5aZ9VEF3MZzqfUaekMnQUkbL
        Y1QZammWSpZIJJ9KP5YeEysUCURiMo7gqWglk0hIUlIFx7MUjmkI3se0ItsRSqVZljj8ZoJW
        na1jeJlqVpdIMBqpQhOtiWBpJZutkkWoGF28SCiMjHEIz8oza1rXUM2DoJye/i44D3riXwRx
        OQCPBlenuuAiyIvjj3dAoGz2oZssQWD1WpWbrELgwnApvG3JN5VBrkQXBCaXJtwqOwTu1t70
        dKowXADaqi9izkQg/gUMBp42I06C4AYEGL+/4iAcDhc/CqYvc52GAFwKJn4eQp0YxcPAY/OA
        hxP74GJw0/jS04X9QP9V25YGwcNB7fV5xNUSD6zP1G7pA/G3wOadYdilCQZ2y0+ezroAz+eC
        CnOD2yABzd8UYS4cAOb6WjxdOATYv7zo6ewN4HJQ0h7lCueCGtN91IWPgO7Rr1GnBMEPgfr2
        w65wKDA8uOUu+woofWlzb8sHtJm2cRjI//OR+5hXQXlxsYceIow7JjPumMy4YwLj/9WuQWgd
        tJfRsEoZw8ZoIlXM+f9uPEOtbIK2Xjv/RBs0NbkQ0QvBHKgXAhyECPRZtp6g/X2k9CefMlp1
        ujZbwbC9UIxj3eVISFCG2vFdVLp0UbRYGB0bGxstjooVEcE+i/Ni2h+X0TpGzjAaRrvtgznc
        kDy4cePJ6wUW84W0G78+u5205/1BK+0NHsrHw6ZMpy2VuIw/m5jcee4Nv/l71sUDZ/Iv73s8
        aPmqoedFi0USZz7Ff00+4xWqDxjk1ysORqXIOj5vPX3kI+87amZgcrarwtdwwGyQyHMCkyLX
        mEI9vnvNpN2VZLj9om+lc699KJSt0DevBBeff+f3D+f+GvPF/EZPkv+E5wTVQGfbJaHSwjzB
        SdMHtk3tSnZ59be2CsP0rYbcX57BaQX7n+/CKlNzV63Tu3M3eEKSo9rYfE9wP4PHs4rbM88d
        7ZDkxDd+NlG7Mpcxdrx3oapGk6JMW45/1zvk7T0Jz+NWu1uHuwrUyXGWagJlM2kRH9Gy9L+G
        V8BcdgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsWy7bCSnG4dk0+iwY/dahYnn6xhs3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8Xl/doWPTudLU5PWMRk8WT9LGaLRTe2MVlsfPuDyeLmlqMsFjPO
        72Oy6L6+g81i+fF/TA78HpeveHvMauhl87jc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPH9/Ud
        bB4fn95i8ejbsorR4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBkXN09gLPgiUrHgUytjA2O7
        UBcjJ4eEgIlE87w+xi5GLg4hgd2MElOuTmKHSEhLXN84AcoWllj57zk7RNFzRomPC7czgSTY
        BHQldixuYwNJiAg0M0nMbDgDNopZYC6zxMq5+6FajjFKrL34kaWLkYODU8BR4tEkTpBuYYEk
        iVlnTrCC2CwCqhJ3VpwGs3kFLCVWzvrNDmELSpyc+YQFxGYW0JZ4evMpnL1s4WtmiPMUJH4+
        XQbWKyLgJPFv+wUmiBpxiZdHj7BPYBSehWTULCSjZiEZNQtJywJGllWMkqkFxbnpucWGBYZ5
        qeV6xYm5xaV56XrJ+bmbGMERrqW5g3H7qg96hxiZOBgPMUpwMCuJ8H6+4ZUoxJuSWFmVWpQf
        X1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwTB6dUA9P87xZW201538hMMTm6xG7S
        re1TdJzafqg+sH8pdnejf9CTc2otihtFTrU8uPMgfbJ7ZGR+UfPbrIN8szZv3THHU6pggRM/
        5wa/Y7bXz+Xu5J2mUPJ+xparmdH7ji/wY8m8P8VFX3SepML8G/Obuq6cZPro9tQzhnmGetzH
        n0nux+sC1gpM/lhpWrNoaWLoOyeGueVLL793UzuySqAjQdSkOaxY7HrK0twQH9djqlqr06pz
        Zuzxm3yCK9V2s6mTjn7IfFY9DlkFsyUVszdGXDBazu6gpdt4akn/04hoIyWJrZ/bv3GK/q7p
        sucS22LWKWKbfSmjZmLKKp2SrgtqC1/udtl98OmTVzJ5sz7GJymxFGckGmoxFxUnAgDcsZ9Y
        XwMAAA==
X-CMS-MailID: 20210923042846epcas5p23c4e7f7f770f7910a0ded12113ee1e0d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p39e18203beafe9377e9dac819f01b804f
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p39e18203beafe9377e9dac819f01b804f@epcas2p3.samsung.com>
        <20210917065436.145629-11-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Chanho Park =5Bmailto:chanho61.park=40samsung.com=5D
>Sent: Friday, September 17, 2021 12:24 PM
>To: Alim Akhtar <alim.akhtar=40samsung.com>; Avri Altman
><avri.altman=40wdc.com>; James E . J . Bottomley <jejb=40linux.ibm.com>; M=
artin
>K . Petersen <martin.petersen=40oracle.com>; Krzysztof Kozlowski
><krzysztof.kozlowski=40canonical.com>
>Cc: Bean Huo <beanhuo=40micron.com>; Bart Van Assche
><bvanassche=40acm.org>; Adrian Hunter <adrian.hunter=40intel.com>; Christo=
ph
>Hellwig <hch=40infradead.org>; Can Guo <cang=40codeaurora.org>; Jaegeuk Ki=
m
><jaegeuk=40kernel.org>; Gyunghoon Kwon <goodjob.kwon=40samsung.com>;
>linux-samsung-soc=40vger.kernel.org; linux-scsi=40vger.kernel.org; Chanho =
Park
><chanho61.park=40samsung.com>; Kiwoong Kim <kwmad.kim=40samsung.com>
>Subject: =5BPATCH v3 10/17=5D scsi: ufs: ufs-exynos: support custom versio=
n of
>ufs_hba_variant_ops
>
>By default, ufs_hba_exynos_ops will be used but this patch supports to use
>custom version of ufs_hba_variant_ops because some variants of exynos-ufs =
will
>use only few callbacks.
>
>Cc: Alim Akhtar <alim.akhtar=40samsung.com>
>Cc: Kiwoong Kim <kwmad.kim=40samsung.com>
>Cc: Krzysztof Kozlowski <krzysztof.kozlowski=40canonical.com>
>Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
>---
Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>

> drivers/scsi/ufs/ufs-exynos.c =7C 8 +++++++-  drivers/scsi/ufs/ufs-exynos=
.h =7C 1 +
> 2 files changed, 8 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c=
 index
>e32f7d09db1a..a3160d9bd234 100644
>--- a/drivers/scsi/ufs/ufs-exynos.c
>+++ b/drivers/scsi/ufs/ufs-exynos.c
>=40=40 -1238,8 +1238,14 =40=40 static int exynos_ufs_probe(struct platform=
_device
>*pdev)  =7B
> 	int err;
> 	struct device *dev =3D &pdev->dev;
>+	const struct ufs_hba_variant_ops *vops =3D &ufs_hba_exynos_ops;
>+	const struct exynos_ufs_drv_data *drv_data =3D
>+		device_get_match_data(dev);
>
>-	err =3D ufshcd_pltfrm_init(pdev, &ufs_hba_exynos_ops);
>+	if (drv_data && drv_data->vops)
>+		vops =3D drv_data->vops;
>+
>+	err =3D ufshcd_pltfrm_init(pdev, vops);
> 	if (err)
> 		dev_err(dev, =22ufshcd_pltfrm_init() failed %d=5Cn=22, err);
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h=
 index
>4f93db893ce8..bc4b8b0324bd 100644
>--- a/drivers/scsi/ufs/ufs-exynos.h
>+++ b/drivers/scsi/ufs/ufs-exynos.h
>=40=40 -142,6 +142,7 =40=40 struct exynos_ufs_uic_attr =7B  =7D;
>
> struct exynos_ufs_drv_data =7B
>+	const struct ufs_hba_variant_ops *vops;
> 	struct exynos_ufs_uic_attr *uic_attr;
> 	unsigned int quirks;
> 	unsigned int opts;
>--
>2.33.0


