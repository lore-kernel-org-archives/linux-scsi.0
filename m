Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E751C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE2DD613B9
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhGNDTu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:19:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32651 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237436AbhGNDTt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 23:19:49 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210714031657epoutp0338083061f6b17be1f11584fbf7d452eb~RifMNWqKN1960719607epoutp038
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 03:16:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210714031657epoutp0338083061f6b17be1f11584fbf7d452eb~RifMNWqKN1960719607epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626232617;
        bh=UlwnmLELdJhbMBN69VYc+G1JMPYDQE9s6u7YTgMaUqk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=EpVk34ot3kopU/UPVQKSPh/JOWqZOuEsO6gvjZpYeOJiH+O4eFICJv0UoMaWB7ItU
         ULy8Iw2NA6TQK4uhkNEMTkU+wkfFRe5jlg0G9gidEpcKi8RKywyUnqxlpxCjUppZlu
         MOkc1mYE1VuqtgzIcZ1RXWuubCT81GluhlAzq7wA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20210714031656epcas5p15dfb7946e7b4e702bf71fa8b6e8d18a2~RifK5YILb2244022440epcas5p1A;
        Wed, 14 Jul 2021 03:16:56 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.40.194]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GPjN60zpGz4x9Pt; Wed, 14 Jul
        2021 03:16:54 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.26.09452.5275EE06; Wed, 14 Jul 2021 12:16:54 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20210714014144epcas5p1dcbf62c5238cc2ecdb0c8faff8c71743~RhMDUr_fT2317023170epcas5p1G;
        Wed, 14 Jul 2021 01:41:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210714014144epsmtrp232444367406ac457449ae47f3e7b5bc4~RhMDTx8r51391913919epsmtrp2I;
        Wed, 14 Jul 2021 01:41:44 +0000 (GMT)
X-AuditID: b6c32a4b-43fff700000024ec-3f-60ee5725250b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.71.08289.8D04EE06; Wed, 14 Jul 2021 10:41:44 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210714014141epsmtip21c0b8894be97fe5b47a62a2f83a95e05~RhMBQk6LV2507425074epsmtip2U;
        Wed, 14 Jul 2021 01:41:41 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Chanho Park'" <chanho61.park@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'jongmin jeong'" <jjmin.jeong@samsung.com>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <20210709065711.25195-7-chanho61.park@samsung.com>
Subject: RE: [PATCH 06/15] scsi: ufs: ufs-exynos: add refclkout_stop control
Date:   Wed, 14 Jul 2021 07:11:40 +0530
Message-ID: <039c01d77851$66875bf0$339613d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEgh/xhOfR89Em7SpyJUmGCKeOVGQJXkMSTAkKCGK6sisFGAA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMJsWRmVeSWpSXmKPExsWy7bCmhq5a+LsEg0O3mSxOPlnDZvHy51U2
        i2kffjJbfFq/jNXi8n5ti56dzhanJyxisniyfhazxaIb25gsVl6zsLi55SiLxYzz+5gsuq/v
        YLNYfvwfkwOfx+Ur3h6X+3qZPDav0PJYvOclk8emVZ1sHhMWHWD0+Pj0FotH35ZVjB6fN8l5
        tB/oZgrgisqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAG6XkmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhUoFecmFtcmpeul5yfa2Vo
        YGBkClSZkJOxbdsjpoK1fBUrZ8xlb2Ds4eli5OSQEDCR+LPvEXsXIxeHkMBuRolPC/6xQTif
        GCUmn1oH5XxmlLh04D8LTMuFQ41QiV2MEk82XGGEcF4ySpw+3cAIUsUmoCuxY3EbWJWIwExG
        iV2rzzKDJJgFTjADDQazOQXsJT6faGQHsYUFfCROnjzOBGKzCKhKTJz9EqyGV8BS4v/Ml4wQ
        tqDEyZlPWCDmyEtsfzuHGeIkBYmfT5exdjFyAC1zkujtCoIoEZc4+rOHGeQGCYEXHBLT792E
        esFF4sni3awQtrDEq+Nb2CFsKYnP7/aygcyREMiW6NllDBGukVg67xhUq73EgStzWEBKmAU0
        Jdbv0ocIy0pMPbWOCWItn0Tv7ydMEHFeiR3zYGxVieZ3V6HGSEtM7O5mncCoNAvJY7OQPDYL
        yQezELYtYGRZxSiZWlCcm55abFpgnJdajhzhmxjBqVvLewfjowcf9A4xMnEwHmKU4GBWEuFd
        avQ2QYg3JbGyKrUoP76oNCe1+BCjKTC0JzJLiSbnA7NHXkm8oamRmZmBpYGpsYWZoZI471L2
        QwlCAumJJanZqakFqUUwfUwcnFINTAqeNfxZezbImh8rulh1aVPU4ditDAt0F73WOraiasHj
        2R91I05X2Tstl+f8EyXHoHFv9sGyg/Hbaq/XXc1RT5Zb3b9xf+Spw8eP1PcmGx7w893008U9
        XuhghkT65sl+9tLhDiKhPW/0r76XTprUUZn2MMXwY9HXQ/eyl0VHFOnUC1dO3KUcx7XrnLCr
        +NF5edlt3Bt/f9/zxexbSFBpUryKSsamJ9FndCfw8dy6dUw+Qe/vSpMFLrzzJuS9lWTbcrtS
        X8ujIObV1G8FL1drRueeUUredutkrNbJP1Ndi76kcasvXLGAlZO37fAtzXPvrPr2722uCP3Z
        cWep1rXFp6ZOTVBi3DpBZJF5Rtmc7UosxRmJhlrMRcWJAKwhwDFmBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSvO4Nh3cJBg9OsVqcfLKGzeLlz6ts
        FtM+/GS2+LR+GavF5f3aFj07nS1OT1jEZPFk/Sxmi0U3tjFZrLxmYXFzy1EWixnn9zFZdF/f
        wWax/Pg/Jgc+j8tXvD0u9/UyeWxeoeWxeM9LJo9NqzrZPCYsOsDo8fHpLRaPvi2rGD0+b5Lz
        aD/QzRTAFcVlk5Kak1mWWqRvl8CVsW3bI6aCtXwVK2fMZW9g7OHpYuTkkBAwkbhwqJGti5GL
        Q0hgB6PE+7sX2SES0hLXN06AsoUlVv57zg5R9JxR4unxO8wgCTYBXYkdi9vAukUEZjNKbDi1
        HayKWeACs8SF3U+g5h5mlFj34RdYC6eAvcTnE41gc4UFfCROnjzOBGKzCKhKTJz9EqyGV8BS
        4v/Ml4wQtqDEyZlPWEBsZgFtiac3n0LZ8hLb385hhrhPQeLn02WsXYwcQGc4SfR2BUGUiEsc
        /dnDPIFReBaSSbOQTJqFZNIsJC0LGFlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIE
        R7CW1g7GPas+6B1iZOJgPMQowcGsJMK71OhtghBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeC10n
        44UE0hNLUrNTUwtSi2CyTBycUg1MagpxnkFLt6SrCWxT3yjkm+WxMv6Bg/0V0asHuG41/6pW
        La6QesfaseGU++nrFj971r5PvChW3drMwvXOZfv/s7V2tZPUpuius1vHllh6JX2bktb1hB8T
        uWVW9nMy7/4UOoOzs3Xn+oCyR9Gpvb4LSnJm7JteKBX32TYskbVHi2lZq8Au0awJ96WjuP8Y
        lv7IvFj3hCl/1YfiN9/kJTo/rNv3m8Ho9PyF+9KdDTN3uL6Pm6t/cm2W99ULk/Qzd7Rte856
        WvfUslnPS/+vWVopqn3q23G1N18UrXl4C/vf5Lmo582TeBOW/bXl96Vy49lt7jFix9/3yazg
        F6m7cC7iR87tqy2xwVzCF9/8/JWhxFKckWioxVxUnAgADtqyG08DAAA=
X-CMS-MailID: 20210714014144epcas5p1dcbf62c5238cc2ecdb0c8faff8c71743
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p1367527fd1299b15fc339876281cb8af1
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p1367527fd1299b15fc339876281cb8af1@epcas2p1.samsung.com>
        <20210709065711.25195-7-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Chanho

> -----Original Message-----
> From: Chanho Park <chanho61.park@samsung.com>
> Sent: 09 July 2021 12:27
> To: Alim Akhtar <alim.akhtar@samsung.com>; James E . J . Bottomley
> <jejb@linux.ibm.com>; Martin K . Petersen <martin.petersen@oracle.com>
> Cc: Can Guo <cang@codeaurora.org>; Jaegeuk Kim <jaegeuk@kernel.org>;
> Kiwoong Kim <kwmad.kim@samsung.com>; Avri Altman
> <avri.altman@wdc.com>; Adrian Hunter <adrian.hunter@intel.com>;
> Christoph Hellwig <hch@infradead.org>; Bart Van Assche
> <bvanassche@acm.org>; jongmin jeong <jjmin.jeong@samsung.com>;
> Gyunghoon Kwon <goodjob.kwon@samsung.com>; linux-samsung-
> soc@vger.kernel.org; linux-scsi@vger.kernel.org; Chanho Park
> <chanho61.park@samsung.com>
> Subject: [PATCH 06/15] scsi: ufs: ufs-exynos: add refclkout_stop control
> 
> This patch adds REFCLKOUT_STOP control to CLK_STOP_MASK. It can
> en/disable reference clock out control for UFS device.
> 
> Signed-off-by: Chanho Park <chanho61.park@samsung.com>
> ---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/scsi/ufs/ufs-exynos.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index da02ad3b036c..78cc5bda0a1f 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -49,10 +49,11 @@
>  #define HCI_ERR_EN_T_LAYER	0x84
>  #define HCI_ERR_EN_DME_LAYER	0x88
>  #define HCI_CLKSTOP_CTRL	0xB0
> +#define REFCLKOUT_STOP		BIT(4)
>  #define REFCLK_STOP		BIT(2)
>  #define UNIPRO_MCLK_STOP	BIT(1)
>  #define UNIPRO_PCLK_STOP	BIT(0)
> -#define CLK_STOP_MASK		(REFCLK_STOP |\
> +#define CLK_STOP_MASK		(REFCLKOUT_STOP | REFCLK_STOP |\
>  				 UNIPRO_MCLK_STOP |\
>  				 UNIPRO_PCLK_STOP)
>  #define HCI_MISC		0xB4
> --
> 2.32.0


