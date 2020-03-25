Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8AABC54FCF
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 16:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4B692078A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 16:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dtJhSVng"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgCYQaq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 12:30:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54296 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727956AbgCYQap (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 12:30:45 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200325163043epoutp0453ae2143c8a50fedc775bb0aa83dcb0d~-mQWpjafX1779817798epoutp04s
        for <linux-scsi@vger.kernel.org>; Wed, 25 Mar 2020 16:30:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200325163043epoutp0453ae2143c8a50fedc775bb0aa83dcb0d~-mQWpjafX1779817798epoutp04s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1585153843;
        bh=Jjid3OCbf405YB87bLFZtPVycg3uhmaHWUs/g5VJJ6o=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=dtJhSVngi3l9NjEsi0h0YOJ4cIW28aUohWkSm7yKxPXdJ8Q7b7x86W9bK8q7t3kBy
         E24sdUyngiWb8+/tsMSmTgZWRRuasboiJDSZr3Wi53bT0nPdbBbONOLECv03N3MFRg
         lqiDbYTYUHZPO2+dw+LisyhqoSbjAHtN7zevo7Bg=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200325163042epcas5p490063c18b7538d1328925e36189482ea~-mQWHQaXG0752507525epcas5p4C;
        Wed, 25 Mar 2020 16:30:42 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C8.C7.04778.2378B7E5; Thu, 26 Mar 2020 01:30:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20200325163042epcas5p370e8e189e6a49f1f50cf5a68b52ab99e~-mQVZsL361415414154epcas5p3t;
        Wed, 25 Mar 2020 16:30:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200325163042epsmtrp1c75f9412873cb3f7e4cfa973ceae2ae1~-mQVYxR4d2393323933epsmtrp19;
        Wed, 25 Mar 2020 16:30:42 +0000 (GMT)
X-AuditID: b6c32a4a-33bff700000012aa-b1-5e7b87328ab7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9D.FB.04024.1378B7E5; Thu, 26 Mar 2020 01:30:41 +0900 (KST)
Received: from alimakhtar02 (unknown [107.108.234.165]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200325163038epsmtip228d90d395f59346c5ee1c4bc0a1d66fa~-mQSd_lDM3252832528epsmtip2c;
        Wed, 25 Mar 2020 16:30:38 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Cc:     <krzk@kernel.org>, <martin.petersen@oracle.com>,
        <kwmad.kim@samsung.com>, <stanley.chu@mediatek.com>,
        <cang@codeaurora.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <SN6PR04MB46404847C78F62BA2D5CD2A0FCF30@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v3 4/5] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Date:   Wed, 25 Mar 2020 22:00:36 +0530
Message-ID: <000001d602c2$b9a15f80$2ce41e80$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQG8Fm24XBW91IxNCpc3FyucYAw+uQGZ6IyRAhOVxEQCiTgOcqhboVgA
Content-Language: en-in
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7bCmhq5Re3Wcwer5hhYvf15ls/i0fhmr
        xfwj51gtzp/fwG5xc8tRFotNj6+xWlzeNYfNYsb5fUwW3dd3sFksP/6PyaJ17xF2i6VbbzI6
        8Hhc7utl8ti0qpPNY/OSeo+Wk/tZPD4+vcXi0bdlFaPH501yHu0HupkCOKK4bFJSczLLUov0
        7RK4MlZOEy54JFExce9hxgbGOUJdjJwcEgImEj/nHGPqYuTiEBLYzSjx5e99KOcTo8Th5gus
        EM43RokDV2+wwLQ0dV1kArGFBPYyShxfbwZR9IZR4s6xm2BFbAK6EjsWt7GB2CICtRKLJ3eA
        TWIGGftt72SwIk6BWIkZB2+wg9jCAiESbbd/gDWwCKhKvPnaxwpi8wpYSny52cYOYQtKnJz5
        BKyXWUBbYtnC18wQFylI/Hy6jBVimZvE7T3H2SBqxCWO/uyBqlnGLrGkWwzCdpH49+QSK4Qt
        LPHq+BZ2CFtK4mU/yC4OIDtbomeXMUS4RmLpvGNQz9tLHLgyhwWkhFlAU2L9Ln2ITXwSvb+f
        MEF08kp0tEFDV1Wi+d1VqE5piYnd3VBLPSR+LjzDOIFRcRaSv2Yh+WsWkvtnISxbwMiyilEy
        taA4Nz212LTAKC+1XK84Mbe4NC9dLzk/dxMjOKFpee1gXHbO5xCjAAejEg/vBsvqOCHWxLLi
        ytxDjBIczEoivJtTK+KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ805ivRojJJCeWJKanZpakFoE
        k2Xi4JRqYDxyYO5zfxmhS5t/Pd9ydrNBX1KzxvTPGxe9dE+vWxDmliO0pUrr7ft1EXY7TfVX
        eXi3Zx99leSyan71BceTj6ffVju/Iv/dZde6Js+XR2VCLxj+njSNd8p30yVlTBY2tW+X1l9y
        frRoZX5CS7H1vdzwE+WLSzeFsGZ7XWCaGcr9cH1SY9umNxOVWIozEg21mIuKEwHN3JwvZAMA
        AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWy7bCSvK5he3WcwbGHlhYvf15ls/i0fhmr
        xfwj51gtzp/fwG5xc8tRFotNj6+xWlzeNYfNYsb5fUwW3dd3sFksP/6PyaJ17xF2i6VbbzI6
        8Hhc7utl8ti0qpPNY/OSeo+Wk/tZPD4+vcXi0bdlFaPH501yHu0HupkCOKK4bFJSczLLUov0
        7RK4Mqae/8JUsFyioqnhGEsD433BLkZODgkBE4mmrotMXYxcHEICuxklvp96yAyRkJa4vnEC
        O4QtLLHy33N2iKJXjBK/ri8DS7AJ6ErsWNzGBpIQEWhklFj8bwkjiMMs8ItR4snah0wgVUIC
        E5gkJkwXBbE5BWIlZhy8AdYtLBAksWTxSlYQm0VAVeLN1z4wm1fAUuLLzTZ2CFtQ4uTMJywg
        NrOAtsTTm0/h7GULX0OdqiDx8+kysF4RATeJ23uOs0HUiEsc/dnDPIFReBaSUbOQjJqFZNQs
        JC0LGFlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIER6iW5g7Gy0viDzEKcDAq8fBu
        sKyOE2JNLCuuzD3EKMHBrCTCuzm1Ik6INyWxsiq1KD++qDQntfgQozQHi5I479O8Y5FCAumJ
        JanZqakFqUUwWSYOTqkGRu2HqxlvNE7YtUX5mazw7Pxr2ip+Wgnb+k4kJu3/vj+4/GFcKce9
        Cqu/3t/8/+omtwSdaWs58/VR6F/N9a6eex8WXcoK0vn5f93fhZrF5zqkmn13iu44n6Gj2s+e
        P0ky5X9o5wGviKV3Fqh+YeKLWp7x/WH4gz8frgrmO22J93jvv/yngI/JSSWW4oxEQy3mouJE
        AIp7gdjMAgAA
X-CMS-MailID: 20200325163042epcas5p370e8e189e6a49f1f50cf5a68b52ab99e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200319150710epcas5p11411da0ec2d56b403b80a206ce38a92b
References: <20200319150031.11024-1-alim.akhtar@samsung.com>
        <CGME20200319150710epcas5p11411da0ec2d56b403b80a206ce38a92b@epcas5p1.samsung.com>
        <20200319150031.11024-5-alim.akhtar@samsung.com>
        <SN6PR04MB46404847C78F62BA2D5CD2A0FCF30@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri
Thanks for review, see my comment inline below

> -----Original Message-----
> From: Avri Altman <Avri.Altman=40wdc.com>
> Sent: 22 March 2020 17:54
> To: Alim Akhtar <alim.akhtar=40samsung.com>; robh+dt=40kernel.org;
> devicetree=40vger.kernel.org; linux-scsi=40vger.kernel.org
> Cc: krzk=40kernel.org; martin.petersen=40oracle.com; kwmad.kim=40samsung.=
com;
> stanley.chu=40mediatek.com; cang=40codeaurora.org; linux-samsung-
> soc=40vger.kernel.org; linux-arm-kernel=40lists.infradead.org; linux-
> kernel=40vger.kernel.org
> Subject: RE: =5BPATCH v3 4/5=5D scsi: ufs-exynos: add UFS host support fo=
r Exynos
> SoCs
>=20
> > +static int exynos7_ufs_pre_link(struct exynos_ufs *ufs) =7B
> > +       struct ufs_hba *hba =3D ufs->hba;
> > +       u32 val =3D ufs->drv_data->uic_attr->pa_dbg_option_suite;
> Can pa_dbg_option_suite be replaced by a macro?
>=20
Going forward, I have plan to add multiple Samsung/Exynos SoC variants, whi=
ch will have its own drv_data. For that reason I kept it.
Let me have a relook on this.

> > +       exynos_ufs_disable_ov_tm(hba);
> > +
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE_DYN),
> > 0xf);
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OPTION_SUITE_DYN),
> > 0xf);
> A typo? Set PA_DBG_OPTION_SUITE_DYN twice?
>=20
Ack, will change

> > +=23define PWR_MODE_STR_LEN       64
> > +static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
> > +                               struct ufs_pa_layer_attr *pwr_max,
> > +                               struct ufs_pa_layer_attr *pwr_req) =7B
> > +       struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
> > +       struct phy *generic_phy =3D ufs->phy;
> > +       struct uic_pwr_mode *pwr =3D &ufs->pwr_act;
> > +       char pwr_str=5BPWR_MODE_STR_LEN=5D =3D =22=22;
> Un-needed complication IMO - all those snprintf that is.
>=20
You mean pwr_str initialization is not needed here?

> > +
> > +static void exynos_ufs_fit_aggr_timeout(struct exynos_ufs *ufs) =7B
> > +       const u8 cntr_div =3D 40;
> Can be replaced by a macro?
>=20
Sure, will change.

> > +struct exynos_ufs_drv_data exynos_ufs_drvs =3D =7B
> > +
> > +       .compatible             =3D =22samsung,exynos7-ufs=22,
> > +       .uic_attr               =3D &exynos7_uic_attr,
> > +       .quirks                 =3D UFSHCD_QUIRK_PRDT_BYTE_GRAN =7C
> > +                                 UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR =7C
> > +                                 UFSHCI_QUIRK_BROKEN_HCE =7C
> > +                                 UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR,
> > +       .opts                   =3D EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL =7C
> > +                                 EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL =
=7C
> > +                                 EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX,
> In what way opts are different from quirks?
>=20
Similar to quirks, but only specific to controller local control, like rela=
ted to APB interface and clock control.
These doesn't need a change in common ufshcd core. So kept as opts.
Will fix your comments and submit v4 soon.
Thanks.
>=20
> Thanks,
> Avri

