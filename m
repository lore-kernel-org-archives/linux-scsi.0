Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E53C11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 12:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 337446101D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 12:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbhGMMKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 08:10:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29031 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235966AbhGMMKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 08:10:08 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210713120717epoutp01fc377244a3f4608370b4dbdaadbe92c7~RWE8hI3hl1370013700epoutp01y
        for <linux-scsi@vger.kernel.org>; Tue, 13 Jul 2021 12:07:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210713120717epoutp01fc377244a3f4608370b4dbdaadbe92c7~RWE8hI3hl1370013700epoutp01y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626178037;
        bh=R3tW0QBmIpbb8LTVC1glOBNw5QQdmJceIXiCjMuheuI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=cbtIoxGypsYZKxHLmP8ls2ggAX84sv7yzCvV9jZ3NkRlYmdP9+uAcYALgJnUYJuNO
         dNvP8ZxoFp95HeyLdmVbT0ZgZZeigFUoCyU3kATiupXcMaH/ewInMZiX44GNiOtp2U
         1tO02+OFyDbggkOYSQL1HDFAQu8yoNk8JTFam2gQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210713120716epcas2p1176bb4b3c0f91a964117d91532e0e52d~RWE78iNLw3053630536epcas2p1A;
        Tue, 13 Jul 2021 12:07:16 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GPKBV6Gybz4x9Pq; Tue, 13 Jul
        2021 12:07:14 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C5.1E.09541.2F18DE06; Tue, 13 Jul 2021 21:07:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210713120713epcas2p175fb45b8668fedc287c7b8257655f4aa~RWE5SG4hP0274602746epcas2p1b;
        Tue, 13 Jul 2021 12:07:13 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210713120713epsmtrp1bbc962065e40692d38c3dde4a9370f94~RWE5On5Yw2738027380epsmtrp1L;
        Tue, 13 Jul 2021 12:07:13 +0000 (GMT)
X-AuditID: b6c32a46-0abff70000002545-9d-60ed81f2fbc5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.0C.08394.1F18DE06; Tue, 13 Jul 2021 21:07:13 +0900 (KST)
Received: from KORCO039056 (unknown [10.229.8.156]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210713120713epsmtip2c153f67be7bc3c9f27cdd5aa783bbb3c~RWE5AbFz83108131081epsmtip2i;
        Tue, 13 Jul 2021 12:07:13 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Krzysztof Kozlowski'" <krzk@kernel.org>
Cc:     "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
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
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
In-Reply-To: <CAJKOXPfJOGz7WhCk4HPtDh0=13gy0q=r5isLNkKz+yetAshAfw@mail.gmail.com>
Subject: RE: [PATCH 13/15] scsi: ufs: ufs-exynos: support exynosauto v9 ufs
 driver
Date:   Tue, 13 Jul 2021 21:07:13 +0900
Message-ID: <009b01d777df$9da09c40$d8e1d4c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHyb2Euai2N4dYCWMtDA4PYCPryVgEgh/xhAisXkWEBe0FBs6rkpggA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUwbZRzHee6u14NYvQHOJ6iknrhlkELbrXAsMDe7sDpmZBkxUYz0ArfS
        WNraK4sj0YwhDKh0sOjAshdEXiYsYxZWGJmmLSxkzgWR8TrDCAMEoRkvWxeGgKWHkf8+v5fv
        83t5nodAgwfwMEKrN7MmPaOj8CDM0bmLlizmedRShyeavjNxFafHLjlwema5H6fPzy+j9GJz
        vYD++qaSvltWg9ATzTaUrhlyIPSPAzTd03NdSA+33sboyp5fENoy2I7TDd1ryP6XVH33k1V9
        1lJE1XIlUvXDrRlEZW8sxlVlNU6gWpgcwVTW1kagWrKHq844LUhK0Ee6hCyWyWRNYlafYcjU
        6jWJVPKxdGW6IlYqk8ji6ThKrGey2UTq4JEUSZJW55uBEp9gdDk+VwrDcVTMvgSTIcfMirMM
        nDmRYo2ZOqNMZozmmGwuR6+JzjBk75VJpXKFL1OtyxqvvI4bb0k+/3asBjsFnoSXAIKA5B6Y
        fz61BAQRwWQ7gFP32xDeWASwvaNWyBteAKcLLvsigX7F5ZluAR/4GcDF+UqUN6YBvDvWJ9zI
        wskYOFPkEGxwKCmBLUMN/qNQ8iEGy593+QOB5FF4temcn0PIVFj9lRXbYIx8Cz7uHUU3WETG
        wwsPL2I8b4N3vpvwM0pGwfrvZ1G+JTFcnqzfLJYEaxf+QficUFhVXOjvDpLTBHR58nFecBCO
        VhcAnkPg392tQp7D4MzZQiEvsABYML6+GWgCsDjvCM9vw+cVrYKN9aHkLtjcEcNv8k3YNbLZ
        24uwqHNVyLtFsKgwmBfuhM62Cozn16HlwpKgDFC2LZPZtkxm2zKB7f9a1QBrBNtZI5etYTm5
        Ub71tu3A/8Ajk9rBN575aDdACOAGkECpUFGd3KMOFmUyJ3NZkyHdlKNjOTdQ+HZdjoa9nGHw
        /RC9OV2mkMfGSuMVtCJWTlOviAihWx1Mahgz+ynLGlnTfzqECAw7hVjmnkkLRb8HxCkJ+2pg
        2YPa4gmbpmxYa7/hPVF63N0RqF37ad1bV3ljkOmHn9XHu9SH3w/BLlV1rrqd5ck1f9Vu65Id
        EhDR3tJHlbk7PE1/PNZG7TZp07YfuGiNMA47zxa4pEOukwlpT4TvwTzrC462B4N/Sn/DXfmC
        3oT8lYaRlUMWZe+z9Q+xo+qV/aMDKalrx9OeXtuj7KszhN4Lb5geFx2e3RGR2xkfkQgj7V8M
        35anvhowmRQT9cbg3MLefRX34sA7vz6dOpOzlN8/VXIgIK1CzHmPWRew3R9rXrv2KKj19M2h
        03P9H1j7Rls+idp5pWX8XYV5oso52xw1Is34ksK4LEYWiZo45l/Z80fxaQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWy7bCSvO7HxrcJBt/malucfLKGzeLBvG1s
        Fi9/XmWzmPbhJ7PFp/XLWC16djpbnJ6wiMniyfpZzBaLbmxjslh5zcLi/PkN7BY3txxlsZhx
        fh+TRff1HWwWy4//Y3Lg97h8xdvjcl8vk8fmFVoei/e8ZPLYtKqTzWPCogOMHh+f3mLx6Nuy
        itHj8yY5j/YD3UwBXFFcNimpOZllqUX6dglcGcv2JBQ806no+f+dpYGxT66LkZNDQsBEYv7L
        46xdjFwcQgK7GSWWb7zHDpGQlXj2bgeULSxxv+UIVNEzRom2RU8YQRJsAvoSLzu2sYLYIgK6
        EptvLGcHKWIWeMkiseDkFTaIjk4miS9br4F1cAoESqxZPQmsQ1ggSOLroh0sIDaLgKrE+4v3
        mEFsXgFLiTn357JA2IISJ2c+AbOZBbQlnt58CmcvW/iaGeI8BYmfT5dBXeEmseTjHyaIGhGJ
        2Z1tzBMYhWchGTULyahZSEbNQtKygJFlFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZG
        cCxrae5g3L7qg94hRiYOxkOMEhzMSiK8S43eJgjxpiRWVqUW5ccXleakFh9ilOZgURLnvdB1
        Ml5IID2xJDU7NbUgtQgmy8TBKdXAdL553utItvq3D1qzrKa9FXMJ1VLLYwm22Ou6fvl7hXgu
        saK42PXTxZqlPs33ddmqs+3xOofTrx+rvGwW3O974Aj7opLGOrPj0W8krtjWtmRl/Yh2d7ts
        89Erkuvx7VDFkExZYfF3sXOPWF1ZeuT/ZfMm18zQmh0zPU/cexlY/KQ9gXXCs201kxutvlrW
        epe9Y3g0sfnHTW7duemNygWxv+eayz27WJRUk2634HCk/+kTtx6XKT43DU8o2/x90dQ2Eecf
        Jju7rV63192yOqmS9jI0Zcq81xXOQv7qP7eca/2UaNK2oH5BrzHD2tRDz1cJ3pTc+94gWvm3
        UrfJ+xfXM0Ikb+bpvJil8Y3Bfn6IEktxRqKhFnNRcSIAT+106lQDAAA=
X-CMS-MailID: 20210713120713epcas2p175fb45b8668fedc287c7b8257655f4aa
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
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

> > +/* FSYS UFS Sharability */
>=20
> Sharability -> Shareability

Typo. I'll correct it next patchset.

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
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_LOCAL_TX_LCC_ENABLE), 0x0);
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
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0), 12000);
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1), 32000);
> > +       ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2), 16000);
> > +
> > +       return 0;
> > +=7D
> > +
>=20
> No need for double line.

Will be fixed as well. :)

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
> This compatible is not documented. It seems that no one document exynos7-
> ufs but that's not an excuse. :)

Hmm. Let me check whether I can add ufs-exynos.yaml.

Best Regards,
Chanho Park

