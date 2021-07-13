Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119DAC07E96
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E174261042
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 03:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237436AbhGNDOR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 23:14:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20750 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237382AbhGNDOQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 23:14:16 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210714031124epoutp022e72126b34e2c8c1c58abb0d26c25314~RiaV1-fZo2303023030epoutp02E
        for <linux-scsi@vger.kernel.org>; Wed, 14 Jul 2021 03:11:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210714031124epoutp022e72126b34e2c8c1c58abb0d26c25314~RiaV1-fZo2303023030epoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626232284;
        bh=qBhUdE1tXVsPFp+ogzY1QndefsySyYtc+FF2wqH0t8M=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=G4fiBsiQPn9PUeWUMX6E0XLTgUgwA6LSWU12le/E1LTkx1XLUOOWpWJ5dIS1+NPlB
         mIFGET2BEFANADccX8D3LnAF2VXrcmXs1JuIFoJmanJJ/+FUlUwmv+oQoceCaJwRda
         O1n67E0rZSiU98F4OIZwAONxLIkd6hpWjhnZEvtM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210714031114epcas5p4bad17ea91d582431801434c3c785d202~RiaMgAyhh0325303253epcas5p4m;
        Wed, 14 Jul 2021 03:11:14 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.40.209]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GPjFY0s9kz4x9Q2; Wed, 14 Jul
        2021 03:11:13 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F9.99.09476.0D55EE06; Wed, 14 Jul 2021 12:11:12 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20210713185948epcas5p27810c3236cd591b399c5814ba1970de0~RbtHjBFxB1113711137epcas5p2d;
        Tue, 13 Jul 2021 18:59:48 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210713185948epsmtrp11baed9fb30abbfc96aaccd8b399f5af5~RbtHiISLQ2327423274epsmtrp1w;
        Tue, 13 Jul 2021 18:59:48 +0000 (GMT)
X-AuditID: b6c32a49-6b7ff70000002504-c8-60ee55d0b71a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        57.96.08394.4A2EDE06; Wed, 14 Jul 2021 03:59:48 +0900 (KST)
Received: from alimakhtar02 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210713185943epsmtip24233fc507e6752aa5dfc9a86ba4515d0~RbtDV4bdr3002030020epsmtip2M;
        Tue, 13 Jul 2021 18:59:43 +0000 (GMT)
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
In-Reply-To: <20210709065711.25195-5-chanho61.park@samsung.com>
Subject: RE: [PATCH 04/15] scsi: ufs: ufs-exynos: simplify drv_data
 retrieval
Date:   Wed, 14 Jul 2021 00:29:41 +0530
Message-ID: <037601d77819$404813e0$c0d83ba0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEgh/xhOfR89Em7SpyJUmGCKeOVGQHLhi0vAcUMiwGskpyowA==
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAJsWRmVeSWpSXmKPExsWy7bCmlu7F0HcJBktELE4+WcNm8fLnVTaL
        aR9+Mlt8Wr+M1eLyfm2Lnp3OFqcnLGKyeLJ+FrPFohvbmCxWXrOwuLnlKIvFjPP7mCy6r+9g
        s1h+/B+TA5/H5SveHpf7epk8Nq/Q8li85yWTx6ZVnWweExYdYPT4+PQWi0ffllWMHp83yXm0
        H+hmCuCKyrHJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgaFSgV5yYW1yal66XnJ9rZWhg
        YGQKVJmQk7HzfHrBVOmKi9tnMTcwPhHrYuTkkBAwkXjX1MTSxcjFISSwm1HixPsuRgjnE6PE
        pE+XmCGcb4wSfdvmsMO0nFzTwQaR2Mso8aNhCpTzklHi4/c3rCBVbAK6EjsWt4ElRARmMkrs
        Wn2WGSTBLHCCWWLyKTCbU8BeYvPX/2ANwgL+End/PWcBsVkEVCUO3XwEFucVsJQ4+HwDC4Qt
        KHFy5hMWiDnaEssWvmaGOElB4ufTZUD1HEDLnCQ+rE+BKBGXOPqzB+wFCYEXHBJX3j5kAqmR
        EHCROLiyDKJVWOLV8S1Qn0lJvOxvY4coyZbo2WUMEa6RWDrvGAuEbS9x4MocFpASZgFNifW7
        9CHCshJTT61jgtjKJ9H7+wkTRJxXYsc8GFtVovndVagx0hITu7tZJzAqzULy1ywkf81C8sAs
        hG0LGFlWMUqmFhTnpqcWmxYY5qWWI0f3JkZw0tby3MF498EHvUOMTByMhxglOJiVRHiXGr1N
        EOJNSaysSi3Kjy8qzUktPsRoCgzsicxSosn5wLyRVxJvaGpkZmZgaWBqbGFmqCTOu5T9UIKQ
        QHpiSWp2ampBahFMHxMHp1QD067mS+YTH6XnnI2rOhLaWrnqxcE7r44WH/h6Y6Fspt77lCru
        xftVWhuz57ifebP2dOZqnt5F/5LWfc3O71l4zbPtWEHFdXEjTscjguzT3M1XO57xsRY9ZK7Q
        bVQ3zWL1yQcyrR/iZ045bZLx5Vj587uXnjTttOnVCnNbq3es7P+tm3Mmrlr39/E03beFVlln
        tr2b8eFsG7f6tE3vuw7EtHcWc/3J+fLgxfNvIU85V2/92734uO28PPGdbgkHgztX3F77muH8
        0fcSYcuEdefMvtvtvtnwpJ+C8XydhIqni19uCD93lyX9sXfVvHf1OkV+CxLEvbgq3p7Q3X5U
        8rLiPhPe1ENXFqzKThEW3/e1u+qHEktxRqKhFnNRcSIAocEs82MEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWy7bCSvO6SR28TDBZOY7M4+WQNm8XLn1fZ
        LKZ9+Mls8Wn9MlaLy/u1LXp2OlucnrCIyeLJ+lnMFotubGOyWHnNwuLmlqMsFjPO72Oy6L6+
        g81i+fF/TA58HpeveHtc7utl8ti8Qstj8Z6XTB6bVnWyeUxYdIDR4+PTWywefVtWMXp83iTn
        0X6gmymAK4rLJiU1J7MstUjfLoErY97HiywF86Uqlp6czNLA+Em0i5GTQ0LAROLkmg62LkYu
        DiGB3YwSu44vYoRISEtc3ziBHcIWllj57zk7RNFzRolTd9ezgSTYBHQldixuA+sWEZjNKLHh
        1HawKmaBC8wSF3Y/gZp7mFHie/srsBZOAXuJzV//s4LYwgK+EqsfLQezWQRUJQ7dfARm8wpY
        Shx8voEFwhaUODnzCZjNLKAt8fTmUzh72cLXzBD3KUj8fLoMqJcD6AwniQ/rUyBKxCWO/uxh
        nsAoPAvJpFlIJs1CMmkWkpYFjCyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNzNzGCI1hL
        cwfj9lUf9A4xMnEwHmKU4GBWEuFdavQ2QYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC
        6YklqdmpqQWpRTBZJg5OqQam8M5QiyPuF75wTY2ulJMv+JXS/vXeyyKOij/TAnYEtn269ufx
        JtkQif5z71IlH0z6derGCdH1ae/7H6wuWMOSkzzx31fHlJaU01f2Xt275KJ3/dmrLBulWDqO
        hEjfkFmy8uT1rXeXHt68iq+89YSAb/nxhnVrtWcqmJkHJCw+vETm+yumkzuO3Ji+4SXrpLiN
        jj13DXVW7e6PKtQMezGx7dv/Fyt1rG7sa2h0OlAXZn3TJO8/Y1rvGbb6HVsnLdj9Q+daxnvN
        n4XZja/kLq9+Uvtpot9ubV6xi2wP40521Dtk31xxbe3ff6cfX94x03bTeYN9LPPEbh2Oepuz
        o/Z9/qG4PBb2YO8EM+XwlHlZ2gZKLMUZiYZazEXFiQBozcGbTwMAAA==
X-CMS-MailID: 20210713185948epcas5p27810c3236cd591b399c5814ba1970de0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210709065746epcas2p26f07099abcb946400ff2777fd9df975d
References: <20210709065711.25195-1-chanho61.park@samsung.com>
        <CGME20210709065746epcas2p26f07099abcb946400ff2777fd9df975d@epcas2p2.samsung.com>
        <20210709065711.25195-5-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Chanho

> -----Original Message-----
> From: Chanho Park <chanho61.park=40samsung.com>
> Sent: 09 July 2021 12:27
> To: Alim Akhtar <alim.akhtar=40samsung.com>; James E . J . Bottomley
> <jejb=40linux.ibm.com>; Martin K . Petersen <martin.petersen=40oracle.com=
>
> Cc: Can Guo <cang=40codeaurora.org>; Jaegeuk Kim <jaegeuk=40kernel.org>;
> Kiwoong Kim <kwmad.kim=40samsung.com>; Avri Altman
> <avri.altman=40wdc.com>; Adrian Hunter <adrian.hunter=40intel.com>;
> Christoph Hellwig <hch=40infradead.org>; Bart Van Assche
> <bvanassche=40acm.org>; jongmin jeong <jjmin.jeong=40samsung.com>;
> Gyunghoon Kwon <goodjob.kwon=40samsung.com>; linux-samsung-
> soc=40vger.kernel.org; linux-scsi=40vger.kernel.org; Chanho Park
> <chanho61.park=40samsung.com>
> Subject: =5BPATCH 04/15=5D scsi: ufs: ufs-exynos: simplify drv_data retri=
eval
>=20
> The compatible field of exynos_ufs_drv_data is not necessary because
> of_device_id already has it. Thus, we don't need it anymore and we can ge=
t
> drv_data by device_get_match_data.
>=20
> Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
> ---
This patch can independently go in as this is clean-up and simplification o=
f the existing driver.

Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>

>  drivers/scsi/ufs/ufs-exynos.c =7C 10 +---------  drivers/scsi/ufs/ufs-ex=
ynos.h =7C
> 3 +--
>  2 files changed, 2 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.=
c
> index cf46d6f86e0e..db5892901cc0 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> =40=40 -893,17 +893,10 =40=40 static int exynos_ufs_post_link(struct ufs_=
hba
> *hba)  static int exynos_ufs_parse_dt(struct device *dev, struct exynos_u=
fs
> *ufs)  =7B
>  	struct device_node *np =3D dev->of_node;
> -	struct exynos_ufs_drv_data *drv_data =3D &exynos_ufs_drvs;
>  	struct exynos_ufs_uic_attr *attr;
>  	int ret =3D 0;
>=20
> -	while (drv_data->compatible) =7B
> -		if (of_device_is_compatible(np, drv_data->compatible)) =7B
> -			ufs->drv_data =3D drv_data;
> -			break;
> -		=7D
> -		drv_data++;
> -	=7D
> +	ufs->drv_data =3D device_get_match_data(dev);
>=20
>  	if (ufs->drv_data && ufs->drv_data->uic_attr) =7B
>  		attr =3D ufs->drv_data->uic_attr;
> =40=40 -1258,7 +1251,6 =40=40 static struct exynos_ufs_uic_attr exynos7_u=
ic_attr
> =3D =7B  =7D;
>=20
>  static struct exynos_ufs_drv_data exynos_ufs_drvs =3D =7B
> -	.compatible		=3D =22samsung,exynos7-ufs=22,
>  	.uic_attr		=3D &exynos7_uic_attr,
>  	.quirks			=3D UFSHCD_QUIRK_PRDT_BYTE_GRAN =7C
>  				  UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR =7C
> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.=
h
> index 475a5adf0f8b..7bf2053f6e90 100644
> --- a/drivers/scsi/ufs/ufs-exynos.h
> +++ b/drivers/scsi/ufs/ufs-exynos.h
> =40=40 -142,7 +142,6 =40=40 struct exynos_ufs_uic_attr =7B  =7D;
>=20
>  struct exynos_ufs_drv_data =7B
> -	char *compatible;
>  	struct exynos_ufs_uic_attr *uic_attr;
>  	unsigned int quirks;
>  	unsigned int opts;
> =40=40 -191,7 +190,7 =40=40 struct exynos_ufs =7B
>  	struct ufs_pa_layer_attr dev_req_params;
>  	struct ufs_phy_time_cfg t_cfg;
>  	ktime_t entry_hibern8_t;
> -	struct exynos_ufs_drv_data *drv_data;
> +	const struct exynos_ufs_drv_data *drv_data;
>=20
>  	u32 opts;
>  =23define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
> --
> 2.32.0


